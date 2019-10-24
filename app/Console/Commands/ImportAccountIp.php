<?php namespace App\Console\Commands;

use App\Lib\AccountService;
use App\Lib\CompanyConfiguration;
use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\Gateway;
use App\Lib\AmazonS3;
use App\Lib\Job;
use App\Lib\Currency;
use App\Lib\Country;
use App\Lib\JobFile;
use App\Lib\Service;
use App\Lib\User;
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

class ImportAccountIp extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'importaccountip';

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
        CronHelper::before_cronrun($this->name, $this );

        $arguments = $this->argument();
        $getmypid = getmypid(); // get proccess id added by abubakar
        $JobID = $arguments["JobID"];
        $job = Job::find($JobID);

        $jobdata = array();
        $error = array();
        $CompanyID = $arguments["CompanyID"];
        $bacth_insert_limit = 50;
        $counter = 0;
        $importoptions = array();
        $joboptions = array();
        $tempProcessID = '';

        Log::useFiles(storage_path().'/logs/importaccountip-'.$JobID.'-'.date('Y-m-d').'.log');
        $TEMP_PATH = CompanyConfiguration::get($CompanyID,'TEMP_PATH').'/';
        try {
            $ProcessID = (string) Uuid::generate();
            Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar

            if (!empty($job)) {
                if(!empty($job->Options)){
                    $importoptions = json_decode($job->Options,true);
                }else{
                    $jobfile = JobFile::where(['JobID' => $JobID])->first();
                    $joboptions = json_decode($jobfile->Options);
                }

                $batch_insert_array = [];
                if (count($joboptions) > 0 || count($importoptions)>0) {
                    //gateway import start
                    if(count($importoptions)>0){
                        Log::info('Gateway AccountsIP Import');
                        $CompanyGatewayID = $importoptions['companygatewayid'];

                        if(!empty($importoptions['importprocessid'])){
                            $ProcessID = $importoptions['importprocessid'];
                        }else{
                            $ProcessID = '';
                        }
                        if(empty($importoptions['criteria'])){
                            $TempAccountIPIDs = explode(',',$importoptions['TempAccountIPIDs']);

                            DB::table('tblTempAccountIP')->where(['ProcessID'=>$ProcessID])->whereNotIn('tblTempAccountIPID',$TempAccountIPIDs)->delete();
                        }
                    } else { //excel/csv import
                        if(isset($joboptions->UploadTemplate) && !empty($joboptions->UploadTemplate)) {
                            $UploadTemplate = FileUploadTemplate::find($joboptions->UploadTemplate);
                            $templateoptions = json_decode($UploadTemplate->Options);
                        }else{
                            $templateoptions = json_decode($joboptions->Options);
                        }

                        $csvoption = $templateoptions->option;
                        $attrselection = $templateoptions->selection;
                        if (!empty($jobfile->FilePath)) {
                            $path = AmazonS3::unSignedUrl($jobfile->FilePath,$CompanyID);
                            if (strpos($path, "https://") !== false) {
                                $file = $TEMP_PATH . basename($path);
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

                        foreach ($results as $temp_row) {
                            if ($csvoption->Firstrow == 'data') {
                                array_unshift($temp_row, null);
                                unset($temp_row[0]);

                            }
                            $temp_row = filterArrayRemoveNewLines($temp_row);
                            $tempservice=1;
                            $tempItemData = array();
                            $checkemptyrow = array_filter(array_values($temp_row));
                            if(!empty($checkemptyrow)) {
                                if (isset($attrselection->AccountName) && !empty($attrselection->AccountName) && !empty($temp_row[$attrselection->AccountName])) {
                                    $AccountName = trim($temp_row[$attrselection->AccountName]);
                                    if(Account::where(["CompanyID"=> $CompanyID,'AccountName'=>$AccountName,'AccountType'=>1])->count()>0){
                                        $tempItemData['AccountName'] = $AccountName;
                                    }else{
                                        $error[] = $AccountName." - Account Name doesn't exists.";

                                    }

                                } else {
                                    $error[] = 'Account Name is blank at line no:' . $lineno;
                                }

                                if (isset($attrselection->IP) && !empty($attrselection->IP) && !empty($temp_row[$attrselection->IP])) {
                                    $IP = trim($temp_row[$attrselection->IP]);
                                    if(!empty($IP)){
                                        $TempIP = trim($temp_row[$attrselection->IP]);
                                    }
                                }

                                if (isset($attrselection->Type) && !empty($attrselection->Type) && !empty($temp_row[$attrselection->Type])) {
                                    $Type = trim($temp_row[$attrselection->Type]);
                                    if(!empty($Type)){
                                        if(strtolower($Type)=='customer'){
                                            $tempItemData['Type'] = 'Customer';
                                        }
                                        if(strtolower($Type)=='vendor'){
                                            $tempItemData['Type'] = 'Vendor';
                                        }
                                    }
                                }

                                if (isset($attrselection->Service) && !empty($attrselection->Service) && !empty($temp_row[$attrselection->Service])) {
                                    $Service = trim($temp_row[$attrselection->Service]);
                                    if(!empty($tempItemData['AccountName']) && !empty($Service)){
                                        $ServiceID = Service::getServiceIDByName($Service);
                                        if(!empty($ServiceID)){
                                            $AccountID = Account::where(['CompanyID'=> $CompanyID,'AccountName'=>$tempItemData['AccountName'],'AccountType'=>1])->pluck('AccountID');
                                            if(AccountService::where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID])->count()>0){
                                                $tempItemData['ServiceID'] = $ServiceID;
                                            }else{
                                                $error[] = $Service."(".$tempItemData['AccountName'].") - doesn't exists.";
                                                $tempservice=0;
                                            }
                                        }else{
                                            $error[] = $Service."(".$tempItemData['AccountName'].") - doesn't exists.";
                                            $tempservice=0;
                                        }
                                    }
                                }


                                if (isset($tempItemData['AccountName']) && isset($TempIP) && isset($tempItemData['Type']) && $tempservice==1) {
                                    //Log::info(print_r($tempItemData,true));
                                    $TempIP = str_replace(' ',',',$TempIP);
                                    $TempIP = str_replace("\n", ",", $TempIP);
                                    $TempIP = str_replace("\r", ",", $TempIP);
                                    $AllIPs = explode(',',trim($TempIP));

                                    foreach($AllIPs as $AllIP => $key){
                                        if(!empty($key)){
                                            $tempItemData['IP'] = trim($key);
                                            $tempItemData['CompanyID'] = $CompanyID;
                                            $tempItemData['ProcessID'] = $ProcessID;
                                            if(empty($tempItemData['ServiceID'])){
                                                $tempItemData['ServiceID'] = 0;
                                            }
                                            //$tempItemData['ServiceID'] = 0;
                                            $tempItemData['created_at'] = date('Y-m-d H:i:s.000');
                                            $tempItemData['created_by'] = 'System';
                                            $batch_insert_array[] = $tempItemData;
                                            $counter++;
                                        }
                                    }
                                }
                            }
                            if ($counter == $bacth_insert_limit) {
                                Log::info('Batch insert start');
                                Log::info('global counter' . $lineno);
                                Log::info('insertion start');
                                DB::table('tblTempAccountIP')->insert($batch_insert_array);
                                //Log::info(print_r($batch_insert_array,true));
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
                            DB::table('tblTempAccountIP')->insert($batch_insert_array);
                            //Log::info(print_r($batch_insert_array,true));
                            Log::info('insertion end');
                        }
                    }

                    Log::info("start CALL  prc_WSProcessImportAccountIP ('" . $ProcessID . "','" . $CompanyID . "')");
                    try {
                        DB::beginTransaction();
                        $JobStatusMessage = DB::select("CALL  prc_WSProcessImportAccountIP ('" . $ProcessID . "','" . $CompanyID . "')");
                        Log::info("end CALL  prc_WSProcessImportAccountIP ('" . $ProcessID . "','" . $CompanyID . "')");
                        DB::commit();
                        $JobStatusMessage = array_reverse(json_decode(json_encode($JobStatusMessage),true));
                        Log::info($JobStatusMessage);
                        Log::info(count($JobStatusMessage));
                        if(!empty($error) || count($JobStatusMessage) > 1){
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



                } // job option empty over



            } // job empty over


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

        CronHelper::after_cronrun($this->name, $this);
    }



}