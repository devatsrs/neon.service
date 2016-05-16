<?php namespace App\Console\Commands;

use App\Lib\CompanyGateway;
use App\Lib\Gateway;
use App\Lib\AmazonS3;
use App\Lib\Job;
use App\Lib\JobFile;
use App\Lib\FileUploadTemplate;
use App\Lib\VendorFileUploadTemplate;
use Illuminate\Support\Facades\DB;
use App\Lib\NeonExcelIO;
use Maatwebsite\Excel\Facades\Excel;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Log;
use App\Lib\Account;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;
use \Exception;

class ImportAccount extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'importaccount';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Command description.';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }
    /**
     * Get the console command arguments.
     *
     * @return array
     */
    protected function getArguments()
    {
        return [
            ['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID'],
            ['JobID', InputArgument::REQUIRED, 'Argument JobID '],
        ];
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function fire()
    {
        $arguments = $this->argument();
        $getmypid = getmypid(); // get proccess id added by abubakar
        $JobID = $arguments["JobID"];
        $job = Job::find($JobID);
        $ProcessID = (string) Uuid::generate();
        Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar
        $jobdata = array();
        $errorslog = array();
        $CompanyID = $arguments["CompanyID"];
        $bacth_insert_limit = 100;
        $counter = 0;
        $importoptions = array();
        $joboptions = array();

        Log::useFiles(storage_path().'/logs/importaccount-'.$JobID.'-'.date('Y-m-d').'.log');
        try {

            if (!empty($job)) {
                if(!empty($job->Options)){
                    $importoptions = json_decode($job->Options,true);

                }else{
                    $jobfile = JobFile::where(['JobID' => $JobID])->first();
                    $joboptions = json_decode($jobfile->Options);
                }
                $CompanyGatewayID ='';
                $AccountType = 0;
                $TempAccountIDs = '';
                $importoption = 0;
                $error = array();
                $JobStatusMessage =array();
                $batch_insert_array = [];
                if (count($joboptions) > 0 || count($importoptions)>0) {
                    //manual import start
                    if(count($importoptions)>0){
                        $AccountType = 1;
                        Log::info('Manually Accounts Import Start');
                        $CompanyGatewayID = $importoptions['companygatewayid'];
                        if(!empty($importoptions['criteria'])){
                            $importoption = 1;
                        }else{
                            $TempAccountIDs = $importoptions['TempAccountIDs'];
                            $importoption = 2;
                        }

                     //manual import end
                    }else {//csv import start
                        if(!empty($joboptions->AccountType)) {
                            $AccountType=$joboptions->AccountType;
                        }
                        if($AccountType==1) {
                            Log::info('Accounts Import By CSV Start');
                        }else{
                            Log::info('Leads Import Start');
                        }
                        if(isset($joboptions->uploadtemplate) && !empty($joboptions->uploadtemplate)) {
                            $uploadtemplate = FileUploadTemplate::find($joboptions->uploadtemplate);
                            $templateoptions = json_decode($uploadtemplate->Options);
                        }else{
                            $templateoptions = json_decode($joboptions->Options);

                        }
                        if (!empty($joboptions->CompanyGatewayID)) {
                            $CompanyGatewayID = $joboptions->CompanyGatewayID;
                        }

                        $csvoption = $templateoptions->option;
                        $attrselection = $templateoptions->selection;
                        if (!empty($jobfile->FilePath)) {
                            $path = AmazonS3::unSignedUrl($jobfile->FilePath);
                            if (strpos($path, "https://") !== false) {
                                $file = Config::get('app.temp_location') . basename($path);
                                file_put_contents($file, file_get_contents($path));
                                $jobfile->FilePath = $file;
                            } else {
                                $jobfile->FilePath = $path;
                            }
                        }

                        $NeonExcel = new NeonExcelIO($jobfile->FilePath, (array) $csvoption);
                        $results = $NeonExcel->read();
                        $lineno = 2;
                        if ($csvoption->Firstrow == 'data') {
                            $lineno = 1;
                        }
                        $lastaccountnumber=Account::getLastAccountNo($CompanyID);

                        foreach ($results as $temp_row) {
                            if ($csvoption->Firstrow == 'data') {
                                array_unshift($temp_row, null);
                                unset($temp_row[0]);

                            }
                            $tempItemData = array();
                            $checkemptyrow = array_filter(array_values($temp_row));
                            if(!empty($checkemptyrow)) {
                                if (isset($attrselection->AccountName) && !empty($attrselection->AccountName) && !empty($temp_row[$attrselection->AccountName])) {
                                    $tempItemData['AccountName'] = trim($temp_row[$attrselection->AccountName]);
                                } else {
                                    $error[] = 'AccountName is blank at line no:' . $lineno;
                                }
                                if (isset($attrselection->FirstName) && !empty($attrselection->FirstName) && !empty($temp_row[$attrselection->FirstName])) {
                                    $tempItemData['FirstName'] = trim($temp_row[$attrselection->FirstName]);
                                } else {
                                    $error[] = 'Firs tName is blank at line no:' . $lineno;
                                }
                                if (isset($attrselection->Country) && !empty($attrselection->Country) && !empty($temp_row[$attrselection->Country])) {
                                    $tempItemData['Country'] = trim($temp_row[$attrselection->Country]);
                                } else {
                                    $error[] = 'Country is blank at line no:' . $lineno;
                                }

                                if (isset($attrselection->AccountNumber) && !empty($attrselection->AccountNumber)) {
                                    $accountnumber = trim($temp_row[$attrselection->AccountNumber]);
                                    if(Account::where(["CompanyID"=> $CompanyID,'Number'=>$accountnumber])->count()==0){
                                        $tempItemData['Number'] = $accountnumber;
                                    }else{
                                        $tempItemData['Number'] = $lastaccountnumber;
                                        $lastaccountnumber++;
                                        while(Account::where(["CompanyID"=> $CompanyID,'Number'=>$lastaccountnumber])->count() >=1 ){
                                            $lastaccountnumber++;
                                        }
                                    }

                                }else{
                                    $tempItemData['Number'] = $lastaccountnumber;
                                    $lastaccountnumber++;
                                    while(Account::where(["CompanyID"=> $CompanyID,'Number'=>$lastaccountnumber])->count() >=1 ){
                                        $lastaccountnumber++;
                                    }
                                }


                                if (isset($attrselection->Email) && !empty($attrselection->Email)) {
                                    $tempItemData['Email'] = trim($temp_row[$attrselection->Email]);
                                }

                                if (isset($attrselection->LastName) && !empty($attrselection->LastName)) {
                                    $tempItemData['LastName'] = trim($temp_row[$attrselection->LastName]);
                                }

                                if (isset($attrselection->Title) && !empty($attrselection->Title)) {
                                    $tempItemData['Title'] = trim($temp_row[$attrselection->Title]);
                                }

                                if (isset($attrselection->Phone) && !empty($attrselection->Phone)) {
                                    $tempItemData['Phone'] = trim($temp_row[$attrselection->Phone]);
                                }

                                if (isset($attrselection->Pincode) && !empty($attrselection->Pincode)) {
                                    $tempItemData['PostCode'] = trim($temp_row[$attrselection->Pincode]);
                                }

                                if (isset($attrselection->Address1) && !empty($attrselection->Address1)) {
                                    $tempItemData['Address1'] = $temp_row[$attrselection->Address1];
                                }

                                if (isset($attrselection->Address2) && !empty($attrselection->Address2)) {
                                    $tempItemData['Address2'] = $temp_row[$attrselection->Address2];
                                }

                                if (isset($attrselection->Address3) && !empty($attrselection->Address3)) {
                                    $tempItemData['Address3'] = $temp_row[$attrselection->Address3];
                                }

                                if (isset($attrselection->City) && !empty($attrselection->City)) {
                                    $tempItemData['City'] = trim($temp_row[$attrselection->City]);
                                }

                                if (isset($attrselection->tags) && !empty($attrselection->tags)) {
                                    $tempItemData['tags'] = $temp_row[$attrselection->tags];
                                }

                                if (isset($attrselection->NamePrefix) && !empty($attrselection->NamePrefix)) {
                                    $tempItemData['NamePrefix'] = trim($temp_row[$attrselection->NamePrefix]);
                                }
                                if (isset($tempItemData['AccountName']) && isset($tempItemData['Country']) && isset($tempItemData['FirstName'])) {
                                    $tempItemData['AccountType'] = $AccountType;
                                    $tempItemData['Status'] = 1;
                                    $tempItemData['LeadSource'] = 'csv import';
                                    $tempItemData['CompanyId'] = $CompanyID;
                                    $tempItemData['CompanyGatewayID'] = $CompanyGatewayID;
                                    $tempItemData['ProcessID'] = $ProcessID;
                                    $tempItemData['created_at'] = date('Y-m-d H:i:s.000');
                                    $tempItemData['created_by'] = 'Imported';
                                    $batch_insert_array[] = $tempItemData;
                                    $counter++;
                                }
                            }
                            if ($counter == $bacth_insert_limit) {
                                Log::info('Batch insert start');
                                Log::info('global counter' . $lineno);
                                Log::info('insertion start');
                                DB::table('tblTempAccount')->insert($batch_insert_array);
                                Log::info('insertion end');
                                $batch_insert_array = [];
                                $counter = 0;
                            }
                            $lineno++;
                        }
                        if (!empty($batch_insert_array)) {
                            Log::info('Batch insert start');
                            Log::info('global counter' . $lineno);
                            Log::info('insertion start');
                            Log::info('last batch insert ' . count($batch_insert_array));
                            DB::table('tblTempAccount')->insert($batch_insert_array);
                            Log::info('insertion end');
                        }

                    }//csv import end
                    Log::info("start CALL  prc_WSProcessImportAccount ('" . $ProcessID . "','" . $CompanyID . "','".$CompanyGatewayID."','".$TempAccountIDs."','".$importoption."')");
                    try {
                        DB::beginTransaction();
                        $JobStatusMessage = DB::select("CALL  prc_WSProcessImportAccount ('" . $ProcessID . "','" . $CompanyID . "','" . $CompanyGatewayID . "','" . $TempAccountIDs . "','" . $importoption . "')");
                        Log::info("end CALL  prc_WSProcessImportAccount ('" . $ProcessID . "','" . $CompanyID . "','" . $CompanyGatewayID . "','" . $TempAccountIDs . "','" . $importoption . "')");
                        DB::commit();
                        $JobStatusMessage = array_reverse(json_decode(json_encode($JobStatusMessage),true));
                        Log::info($JobStatusMessage);

                        Log::info(count($JobStatusMessage));
                        if(!empty($error || count($JobStatusMessage) > 1)){
                            $prc_error = array();
                            foreach ($JobStatusMessage as $JobStatusMessage1) {
                                $prc_error[] = $JobStatusMessage1['Message'];
                            }
                            $error = array_merge($prc_error,$error);
                            $job = Job::find($JobID);
                            $jobdata['JobStatusMessage'] = implode(',\n\r',fix_jobstatus_meassage($error));
                            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','PF')->pluck('JobStatusID');
                            $jobdata['updated_at'] = date('Y-m-d H:i:s');
                            $jobdata['ModifiedBy'] = 'RMScheduler';
                            Log::info($jobdata);
                            Job::where(["JobID" => $JobID])->update($jobdata);
                        }elseif(!empty($JobStatusMessage[0]['Message'])){
                            $job = Job::find($JobID);
                            $jobdata['JobStatusMessage'] = $JobStatusMessage[0]['Message'];
                            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','S')->pluck('JobStatusID');
                            $jobdata['updated_at'] = date('Y-m-d H:i:s');
                            $jobdata['ModifiedBy'] = 'RMScheduler';
                            Job::where(["JobID" => $JobID])->update($jobdata);
                        }
                        if($AccountType==1){
                            Log::info('Accounts Import End');
                        }else{
                            Log::info('Leads import End');
                        }
                    }catch ( Exception $err ){
                        try{
                            DB::rollback();
                        }catch (Exception $err) {
                            Log::error($err);
                        }
                        $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                        $jobdata['JobStatusMessage'] = 'Exception: ' . $err->getMessage();
                        $jobdata['updated_at'] = date('Y-m-d H:i:s');
                        $jobdata['ModifiedBy'] = 'RMScheduler';
                        Job::where(["JobID" => $JobID])->update($jobdata);
                        Log::error($err);
                    }

                }
            }


        } catch (\Exception $e) {
            try{
                DB::rollback();
            }catch (Exception $err) {
                Log::error($err);
            }
            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
            $jobdata['JobStatusMessage'] = 'Exception: ' . $e->getMessage();
            $jobdata['updated_at'] = date('Y-m-d H:i:s');
            $jobdata['ModifiedBy'] = 'RMScheduler';
            Job::where(["JobID" => $JobID])->update($jobdata);
            Log::error($e);
        }
        Job::send_job_status_email($job,$CompanyID);
    }



}