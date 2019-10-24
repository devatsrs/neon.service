<?php namespace App\Console\Commands;

use App\Lib\CompanyConfiguration;
use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\Gateway;
use App\Lib\AmazonS3;
use App\Lib\Job;
use App\Lib\Currency;
use App\Lib\Country;
use App\Lib\JobFile;
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

        CronHelper::before_cronrun($this->name, $this );


        $arguments = $this->argument();
        $getmypid = getmypid(); // get proccess id added by abubakar
        $JobID = $arguments["JobID"];
        $job = Job::find($JobID);

        $jobdata = array();
        $errorslog = array();
        $CompanyID = $arguments["CompanyID"];
        $bacth_insert_limit = 50;
        $counter = 0;
        $importoptions = array();
        $joboptions = array();
        $tempProcessID = '';
        $AccData = array();

        $accountimportdate = date('Y-m-d H:i:s.000');

        Log::useFiles(storage_path().'/logs/importaccount-'.$JobID.'-'.date('Y-m-d').'.log');
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
                $UserID = $job->JobLoggedUserID;
                $CompanyGatewayID =0;
                $tempCompanyGatewayID =0;
                $AccountType = 0;
                $TempAccountIDs = '';
                $importoption = 0;
                $gateway = "";
                $error = array();
                $JobStatusMessage =array();
                $batch_insert_array = [];
                if (count($joboptions) > 0 || count($importoptions)>0) {
                    //manual import start
                    if(count($importoptions)>0){
                        $AccountType = 1;
                        Log::info('Manually Accounts Import Start');

                        if(!empty($importoptions['quickbookimportprocessid'])){
                            $QuickBookProcessID = $importoptions['quickbookimportprocessid'];
                        }else{
                            $QuickBookProcessID = '';
                        }

                        /* QuickBook Import */
                        if(!empty($QuickBookProcessID)){
                            Log::info('QuickBook Accounts Import');
                            $importoption = 1;
                            $tempProcessID = $QuickBookProcessID;
                            if(!empty($importoptions['criteria'])){
                                $tempCompanyGatewayID = 0;
                            }else{
                                $TempAccountIDs = $importoptions['TempAccountIDs'];
                            }

                        }else{
                            Log::info('Gateway Accounts Import');
                            $CompanyGatewayID = $importoptions['companygatewayid'];

                            if(!empty($importoptions['criteria'])){
                                $importoption = 1;
                                $tempCompanyGatewayID = $importoptions['companygatewayid'];
                            }else{
                                $TempAccountIDs = $importoptions['TempAccountIDs'];
                                $importoption = 1;
                            }
                            if(isset($importoptions['gateway']) && !empty($importoptions['gateway'])){
                                $gateway = $importoptions['gateway'];
                            }
                            if(!empty($importoptions['importprocessid'])){
                                $tempProcessID = $importoptions['importprocessid'];
                            }else{
                                $tempProcessID = '';
                            }
                        }

                     //manual import end
                    }else {//csv import start
                        $tempProcessID = $ProcessID;
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
                        $lastaccountnumber=Account::getLastAccountNo($CompanyID);
                        $erroraccountnumber = 0;

                        foreach ($results as $temp_row) {
                            if ($csvoption->Firstrow == 'data') {
                                array_unshift($temp_row, null);
                                unset($temp_row[0]);

                            }
                            $temp_row = filterArrayRemoveNewLines($temp_row);
                            $tempItemData = array();
                            $checkemptyrow = array_filter(array_values($temp_row));
                            if(!empty($checkemptyrow)) {
                                if (isset($attrselection->AccountName) && !empty($attrselection->AccountName) && !empty($temp_row[$attrselection->AccountName])) {
                                    $AccountName = trim($temp_row[$attrselection->AccountName]);
                                    if(Account::where(["CompanyID"=> $CompanyID,'AccountName'=>$AccountName,'AccountType'=>$AccountType])->count()==0){
                                        $tempItemData['AccountName'] = $AccountName;
                                    }else{
                                        if($AccountType==0) {
                                            $error[] = $AccountName.' - Company already exists.';
                                        }else{
                                            $error[] = $AccountName.' - Account Name already exists.';
                                        }
                                    }

                                } else {
                                    if($AccountType==0) {
                                        $error[] = 'Company is blank at line no:' . $lineno;
                                    }else{
                                        $error[] = 'Account Name is blank at line no:' . $lineno;
                                    }
                                }

                                //lead - first name and last name required
                                if($AccountType==0) {
                                    if (isset($attrselection->FirstName) && !empty($attrselection->FirstName) && !empty($temp_row[$attrselection->FirstName])) {
                                        $tempItemData['FirstName'] = trim($temp_row[$attrselection->FirstName]);
                                    } else {
                                        $error[] = 'First Name is blank at line no:' . $lineno;
                                    }

                                    if (isset($attrselection->LastName) && !empty($attrselection->LastName)  && !empty($temp_row[$attrselection->LastName])) {
                                        $tempItemData['LastName'] = trim($temp_row[$attrselection->LastName]);
                                    } else {
                                        $error[] = 'Last Name is blank at line no:' . $lineno;
                                    }
                                }else{
                                    if (isset($attrselection->FirstName) && !empty($attrselection->FirstName)) {
                                        $tempItemData['FirstName'] = trim($temp_row[$attrselection->FirstName]);
                                    }
                                    if (isset($attrselection->LastName) && !empty($attrselection->LastName)) {
                                        $tempItemData['LastName'] = trim($temp_row[$attrselection->LastName]);
                                    }
                                }
                                if (isset($attrselection->Country) && !empty($attrselection->Country)) {
                                    //$tempItemData['Country'] = trim($temp_row[$attrselection->Country]);
                                    $checkCountry=strtoupper(trim($temp_row[$attrselection->Country]));
                                    if($checkCountry=='UK'){
                                        $checkCountry = 'UNITED KINGDOM';
                                    }
                                    $count = Country::where(["Country" => $checkCountry])->count();
                                    if($count>0){
                                        $tempItemData['Country'] = $checkCountry;
                                    }else{
                                        $tempItemData['Country'] = '';
                                    }
                                }

                                if (isset($attrselection->AccountNumber) && !empty($attrselection->AccountNumber)) {
                                    $accountnumber = trim($temp_row[$attrselection->AccountNumber]);
                                    if(!empty($accountnumber))
                                    {
                                        if(Account::where(["CompanyID"=> $CompanyID,'Number'=>$accountnumber])->count()==0){
                                            $tempItemData['Number'] = $accountnumber;
                                            $erroraccountnumber = 0;
                                        }else{
                                            $error[] = $accountnumber.' - Account Number already exists.';
                                            $erroraccountnumber = 1;
                                        }

                                    }else{
                                        $erroraccountnumber = 0;
                                        $tempItemData['Number'] = null;
                                    }

                                    /*if(Account::where(["CompanyID"=> $CompanyID,'Number'=>$accountnumber])->count()==0){
                                        $tempItemData['Number'] = $accountnumber;
                                    }else{
                                        $tempItemData['Number'] = $lastaccountnumber;
                                        $lastaccountnumber++;
                                        while(Account::where(["CompanyID"=> $CompanyID,'Number'=>$lastaccountnumber])->count() >=1 ){
                                            $lastaccountnumber++;
                                        }
                                    }*/

                                }else{
                                    /*$tempItemData['Number'] = $lastaccountnumber;
                                    $lastaccountnumber++;
                                    while(Account::where(["CompanyID"=> $CompanyID,'Number'=>$lastaccountnumber])->count() >=1 ){
                                        $lastaccountnumber++;
                                    }*/
                                    $erroraccountnumber = 0;
                                    $tempItemData['Number'] = null;
                                }


                                if (isset($attrselection->Email) && !empty($attrselection->Email)) {
                                    $tempItemData['Email'] = trim($temp_row[$attrselection->Email]);
                                }

                                /*
                                if (isset($attrselection->Title) && !empty($attrselection->Title)) {
                                    $tempItemData['Title'] = trim($temp_row[$attrselection->Title]);
                                }*/

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

                                if (isset($attrselection->Website) && !empty($attrselection->Website)) {
                                    $tempItemData['Website'] = trim($temp_row[$attrselection->Website]);
                                }

                                if (isset($attrselection->Mobile) && !empty($attrselection->Mobile)) {
                                    $tempItemData['Mobile'] = trim($temp_row[$attrselection->Mobile]);
                                }

                                if (isset($attrselection->Fax) && !empty($attrselection->Fax)) {
                                    $tempItemData['Fax'] = trim($temp_row[$attrselection->Fax]);
                                }

                                if (isset($attrselection->Skype) && !empty($attrselection->Skype)) {
                                    $tempItemData['Skype'] = trim($temp_row[$attrselection->Skype]);
                                }

                                if (isset($attrselection->Twitter) && !empty($attrselection->Twitter)) {
                                    $tempItemData['Twitter'] = trim($temp_row[$attrselection->Twitter]);
                                }

                                if (isset($attrselection->Employee) && !empty($attrselection->Employee)) {
                                    $tempItemData['Employee'] = trim($temp_row[$attrselection->Employee]);
                                }

                                if (isset($attrselection->Description) && !empty($attrselection->Description)) {
                                    $tempItemData['Description'] = $temp_row[$attrselection->Description];
                                }

                                if (isset($attrselection->BillingEmail) && !empty($attrselection->BillingEmail)) {
                                    $tempItemData['BillingEmail'] = trim($temp_row[$attrselection->BillingEmail]);
                                }

                                if (isset($attrselection->VatNumber) && !empty($attrselection->VatNumber)) {
                                    $tempItemData['VatNumber'] = trim($temp_row[$attrselection->VatNumber]);
                                }

                                if (isset($attrselection->Currency) && !empty($attrselection->Currency)) {
                                    // get currencyid from currency code
                                    $cid = Currency::getCurrencyId($CompanyID,trim($temp_row[$attrselection->Currency]));
                                    if(!empty($cid) && $cid>0){
                                        $tempItemData['Currency'] = $cid;
                                    }else{
                                        $tempItemData['Currency'] = '';
                                    }
                                }
								
								if (isset($attrselection->AccountOwner) && !empty($attrselection->AccountOwner)) {
									$owner = User::getUserIDByUserName($CompanyID,$temp_row[$attrselection->AccountOwner]); 
                                    $tempItemData['Owner'] = $owner;
                                }
								
								if (isset($attrselection->Vendor) && !empty($attrselection->Vendor)) {
									$vendor 				  = 	trim($temp_row[$attrselection->Vendor]); 
									$vendorval  			  = 	0;
									if($vendor=='Yes') {$vendorval = 1;}
                                    $tempItemData['IsVendor'] = 	$vendorval;
                                }
								
								if (isset($attrselection->Customer) && !empty($attrselection->Customer)) {
									$Customer   				= trim($temp_row[$attrselection->Customer]);
									$CustomerVal 				= 0;
									if($Customer=='Yes'){$CustomerVal = 1;}	
                                    $tempItemData['IsCustomer'] = $CustomerVal;
                                }							

                                if (isset($tempItemData['AccountName'])) {
                                    if($AccountType==1 && $erroraccountnumber==0){
                                            $tempItemData['AccountType'] = $AccountType;
                                            $tempItemData['Status'] = 1;
                                            $tempItemData['LeadSource'] = 'csv import';
                                            $tempItemData['CompanyId'] = $CompanyID;
                                            $tempItemData['CompanyGatewayID'] = $CompanyGatewayID;
                                            $tempItemData['ProcessID'] = $ProcessID;
                                            $tempItemData['created_at'] = $accountimportdate;
                                            $tempItemData['created_by'] = 'Imported';
                                            $batch_insert_array[] = $tempItemData;
                                            $counter++;
                                    }elseif($AccountType==0){
                                        if(isset($tempItemData['FirstName']) && isset($tempItemData['LastName'])){
                                            $tempItemData['AccountType'] = $AccountType;
                                            $tempItemData['Status'] = 1;
                                            $tempItemData['LeadSource'] = 'csv import';
                                            $tempItemData['CompanyId'] = $CompanyID;
                                            $tempItemData['CompanyGatewayID'] = $CompanyGatewayID;
                                            $tempItemData['ProcessID'] = $ProcessID;
                                            $tempItemData['created_at'] = $accountimportdate;
                                            $tempItemData['created_by'] = 'Imported';
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
                    Log::info("start CALL  prc_WSProcessImportAccount ('" . $tempProcessID . "','" . $CompanyID . "','".$tempCompanyGatewayID."','".$TempAccountIDs."','".$importoption."','".$accountimportdate."','".$gateway."')");
                    try {
                        DB::beginTransaction();
                        $JobStatusMessage = DB::select("CALL  prc_WSProcessImportAccount ('" . $tempProcessID . "','" . $CompanyID . "','" . $tempCompanyGatewayID . "','" . $TempAccountIDs . "','" . $importoption . "','".$accountimportdate."','".$gateway."')");
                        Log::info("end CALL  prc_WSProcessImportAccount ('" . $tempProcessID . "','" . $CompanyID . "','" . $tempCompanyGatewayID . "','" . $TempAccountIDs . "','" . $importoption . "','".$accountimportdate."','".$gateway."')");
                        DB::commit();
                        $JobStatusMessage = array_reverse(json_decode(json_encode($JobStatusMessage),true));
                        Log::info($JobStatusMessage);
                        Account::updateAccountNo($CompanyID);
                        Log::info('update account number - Done');
                        Log::info('account import date - '.$accountimportdate);
                        $AccData['UserID'] = $UserID;
                        $AccData['CompanyID'] = $CompanyID;
                        $AccData['AccountDate'] = $accountimportdate;
                        Account::addAccountAudit($AccData);
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
                        if($AccountType==1){
                            Log::info('Accounts Import End');
                        }else{
                            Log::info('Leads import End');
                        }
                    } catch ( Exception $err ) {
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

        CronHelper::after_cronrun($this->name, $this);
    }



}