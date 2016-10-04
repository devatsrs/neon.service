<?php namespace App\Console\Commands;

use App\Lib\Account;
use App\Lib\AccountBilling;
use App\Lib\AccountNextBilling;
use App\Lib\CompanySetting;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Invoice;
use App\Lib\Job;
use App\Lib\JobStatus;
use App\Lib\JobType;
use App\Lib\User;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;
use App\Lib\Helper;
use App\Lib\Company;
use \Exception;

class InvoiceGenerator extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'invoicegenerator';

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
     * Execute the console command.
     *  Make sure we have CDR Loaded before running this cron job.
     * @return mixed
     */
    public function fire()
    {

        CronHelper::before_cronrun($this->name, $this );


        $arguments = $this->argument();
        $getmypid = getmypid(); // get proccess id
        $ProcessID = Uuid::generate();
        $CompanyID = $arguments["CompanyID"];
        $CronJobID = $arguments["CronJobID"];
        $JobID = $arguments["JobID"];
        $CronJob =  CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);
        $today = date("Y-m-d");

        $dataactive['Active'] = 1;
        $dataactive['PID'] = $getmypid;
        $dataactive['LastRunTime'] = date('Y-m-d H:i:00');
        $CronJob->update($dataactive);

        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';

        Log::useFiles(storage_path().'/logs/invoicegenerator-'.$CompanyID.'-'.date('Y-m-d').'.log');



        // Get Active Accounts which has  BillingCycleType set
        $Accounts = Account::join('tblAccountBilling','tblAccountBilling.AccountID','=','tblAccount.AccountID')->select(["tblAccount.AccountID","AccountName"])->where(["CompanyID" =>$CompanyID, "Status" => 1,"AccountType" => 1 ])->where('tblAccountBilling.NextInvoiceDate','<=',$today)->whereNotNull('tblAccountBilling.BillingCycleType')->get();

       /* $InvoiceGenerationEmail = CompanySetting::getKeyVal($CompanyID,'InvoiceGenerationEmail');
        $InvoiceGenerationEmail = ($InvoiceGenerationEmail != 'Invalid Key')?$InvoiceGenerationEmail:'';
        $InvoiceGenerationEmail = explode(",",$InvoiceGenerationEmail);*/

        $InvoiceGenerationEmail = isset($cronsetting['SuccessEmail']) ? $cronsetting['SuccessEmail'] :'';
        $InvoiceGenerationEmail = explode(",",$InvoiceGenerationEmail);

        $errors = array();
        $message = array();

        $AccountIDs = array_pluck($Accounts, 'AccountID');

        if((int)$JobID == 0) {

            /**
             * Create a Job
             */
            if (isset($arguments["UserID"]) && User::where("UserID", $arguments["UserID"])->count() > 0) {
                $UserID = $arguments["UserID"];
                Log::info('run by user ' . $UserID);
            } else {
                $UserID = User::where("CompanyID", $CompanyID)->where("Roles", "like", "%Admin%")->min("UserID");
            }

            $jobType = JobType::where(["Code" => 'BI'])->get(["JobTypeID", "Title"]);
            $jobStatus = JobStatus::where(["Code" => "I"])->get(["JobStatusID"]);
            $jobdata["CompanyID"] = $CompanyID;
            $jobdata["JobTypeID"] = isset($jobType[0]->JobTypeID) ? $jobType[0]->JobTypeID : '';
            $jobdata["JobStatusID"] = isset($jobStatus[0]->JobStatusID) ? $jobStatus[0]->JobStatusID : '';
            $jobdata["JobLoggedUserID"] = $UserID;
            $jobdata["Title"] = "[Auto] " . (isset($jobType[0]->Title) ? $jobType[0]->Title : '') . ' Generate & Send';
            $jobdata["Description"] = isset($jobType[0]->Title) ? $jobType[0]->Title : '';
            $jobdata["CreatedBy"] = User::get_user_full_name($UserID);
            $jobdata["Options"] = json_encode(array("accounts" => $AccountIDs,'CronJobID'=>$CronJobID));
            $jobdata["updated_at"] = date('Y-m-d H:i:s');
            $JobID = Job::insertGetId($jobdata);
            $jobdata = array();
        }else{
            Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar
        }
        /** ************************************************************/


        Log::error(' ========================== Invoice Send Loop Start =============================');
        $skip_accounts = array();
        try {
            CronJob::createLog($CronJobID);
            do{
            $Accounts = Account::join('tblAccountBilling','tblAccountBilling.AccountID','=','tblAccount.AccountID')
                ->select(["tblAccountBilling.AccountID","tblAccountBilling.NextInvoiceDate","AccountName"])
                ->whereNotIn('tblAccount.AccountID',$skip_accounts)
                ->where(["CompanyID" =>$CompanyID, "Status" => 1,"AccountType" => 1,"Billing"=>1 ])
                ->where('tblAccountBilling.NextInvoiceDate','<>','')
                ->where('tblAccountBilling.NextInvoiceDate','<>','0000-00-00')
                ->where('tblAccountBilling.NextInvoiceDate','<=',$today)
                ->whereNotNull('tblAccountBilling.BillingCycleType')
                ->orderby('tblAccount.AccountID')->get();
            foreach ($Accounts as $Account) {

                $AccountName = $Account['AccountName'];
                $AccountID = $Account['AccountID'];
                try {



                    $NextInvoiceDate = Invoice::getNextInvoiceDate($CompanyID, $AccountID);
                    Log::info('AccountID =' . $AccountID . ' NextInvoiceDate = ' . $NextInvoiceDate);

                    if (!empty($NextInvoiceDate)) {

                        $EndDate = date("Y-m-d", strtotime("-1 Day", strtotime($NextInvoiceDate)));
                        /**
                         * 1. If Account is not in tblAccountGateway Generate Invoice
                         * 2. If Account is present check **cdr download log** end date > $EndDate (1-11-2015 > 31-10-2015)
                         * 3. If no calling in CDR then also log is generated so checking in log only. not in tblUsageDetails so if customer is
                         * not sending any traffic then also 0 value invoice is generated.
                         * */
                        $isCDRLoaded = DB::connection('sqlsrv2')->select("CALL prc_checkCDRIsLoadedOrNot(" . (int)$AccountID . ",$CompanyID,'$EndDate')");

                        Log::info('isCDRLoaded ' . print_r($isCDRLoaded, true));

                        if (strtotime($NextInvoiceDate) <= strtotime(date("Y-m-d"))) {

                            if (isset($isCDRLoaded[0]->isLoaded) && $isCDRLoaded[0]->isLoaded == 1 ) {

                                Log::info(' ========================== Invoice Send Start =============================');


                                if (strtotime($NextInvoiceDate) <= strtotime(date("Y-m-d"))) {
                                    DB::beginTransaction();
                                    DB::connection('sqlsrv2')->beginTransaction();
                                    Log::info('AccountID =' . $AccountID . ' NextInvoiceDate = ' . $NextInvoiceDate);

                                    $LastInvoiceDate = Invoice::getLastInvoiceDate($CompanyID, $AccountID);

                                    Log::info('getLastInvoiceDate =' . $LastInvoiceDate);

                                    /*                    $StartDate = $LastInvoiceDate;
                                                        $EndDate = date("Y-m-d 23:59:59", strtotime("-1 Day", strtotime($NextInvoiceDate)));*/

                                    Log::info('Invoice::sendInvoice(' . $CompanyID . ',' . $AccountID . ',' . $LastInvoiceDate . ',' . $NextInvoiceDate . ',' . implode(",", $InvoiceGenerationEmail) . ')');

                                    $response = Invoice::sendInvoice($CompanyID, $AccountID, $LastInvoiceDate, $NextInvoiceDate, $InvoiceGenerationEmail,$ProcessID,$JobID);

                                    Log::info('Invoice::sendInvoice done');

                                    if (isset($response["status"]) && $response["status"] == 'success') {

                                        Log::info('Invoice created - ' . print_r($response, true));
                                        $message[] = $response["message"];
                                        Log::info('Invoice Commited  AccountID = ' . $AccountID);
                                        DB::connection('sqlsrv2')->commit();
                                        Log::info('=========== Updating  InvoiceDate =========== ');
                                        $AccountBilling = AccountBilling::getBilling($AccountID);
                                        $oldNextInvoiceDate = $NextInvoiceDate;
                                        $NewNextInvoiceDate = next_billing_date($AccountBilling->BillingCycleType,$AccountBilling->BillingCycleValue,strtotime($oldNextInvoiceDate));
                                        AccountBilling::where(['AccountID'=>$AccountID])->update(["LastInvoiceDate"=>$oldNextInvoiceDate,"NextInvoiceDate"=>$NewNextInvoiceDate]);
                                        $AccountNextBilling = AccountNextBilling::getBilling($AccountID);
                                        if(!empty($AccountNextBilling)){
                                            AccountBilling::where(['AccountID'=>$AccountID])->update(["BillingCycleType"=>$AccountNextBilling->BillingCycleType,"BillingCycleValue"=>$AccountNextBilling->BillingCycleValue,'LastInvoiceDate'=>$AccountNextBilling->LastInvoiceDate,'NextInvoiceDate'=>$AccountNextBilling->NextInvoiceDate]);
                                            AccountNextBilling::where(['AccountID'=>$AccountID])->delete();
                                        }


                                        Log::info('=========== Updated  InvoiceDate =========== ') ;
                                        DB::commit();

                                    } else {
                                        $errors[] = $response["message"];
                                        DB::rollback();
                                        DB::connection('sqlsrv2')->rollback();
                                        $skip_accounts[] = $AccountID;
                                        Log::info('Invoice rollback  AccountID = ' . $AccountID);
                                        Log::info(' ========================== Error  =============================');
                                        Log::info('Invoice with Error - ' . print_r($response, true));

                                    }
                                }
                            }else {
                                $errors[] = $AccountName . " " . Invoice::$InvoiceGenrationErrorReasons["NoCDR"];
                                $skip_accounts[] = $AccountID;
                                continue;
                            }
                        }else{
                            $skip_accounts[] = $AccountID;
                        }

                    }else{
                        $skip_accounts[] = $AccountID;
                    }

                    Log::info(' ========================== Invoice Send End =============================');


                } catch (\Exception $e) {

                    try {
                        $skip_accounts[] = $AccountID;
                        Log::error('Invoice Rollback AccountID = ' . $AccountID);
                        DB::rollback();
                        DB::connection('sqlsrv2')->rollback();
                        Log::error($e);

                        $errors[] = $AccountName . " " . $e->getMessage();


                    }catch (Exception $err) {
                        Log::error($err);
                        $errors[] = $AccountName . " " . $e->getMessage() . ' ## ' . $err->getMessage();
                    }

                }

            } // Loop over
                //Log::info($skip_accounts);
        }while(Account::join('tblAccountBilling','tblAccountBilling.AccountID','=','tblAccount.AccountID')
                ->select(["tblAccount.AccountID","AccountName"])
                ->where(["CompanyID" =>$CompanyID, "Status" => 1,"AccountType" => 1,"Billing"=>1 ])
                ->where('tblAccountBilling.NextInvoiceDate','<>','')
                ->where('tblAccountBilling.NextInvoiceDate','<>','0000-00-00')
                ->where('tblAccountBilling.NextInvoiceDate','<=',$today)
                ->whereNotIn('tblAccount.AccountID',$skip_accounts)
                ->whereNotNull('tblAccountBilling.BillingCycleType')->count());


            Log::info(' ========================== Invoice Send Loop End =============================');

            if(count($errors)>0){
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','PF')->pluck('JobStatusID');
                $jobdata['JobStatusMessage'] = 'Skipped account: '.implode(',\n\r',$errors);
            }else if(isset($message['accounts']) && $message['accounts'] != ''){
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','PF')->pluck('JobStatusID');
                $jobdata['JobStatusMessage'] = 'Skipped account: '.implode(',\n\r',$message);
            }else{
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','S')->pluck('JobStatusID');
                $jobdata['JobStatusMessage'] = 'Invoice created Successfully';
            }


            $jobdata['ModifiedBy'] = 'RMScheduler';
            Job::where(["JobID" => $JobID])->update($jobdata);
            $job = Job::find($JobID);
            Log::info(' ========================== Job Updated =============================');
            if(!empty($InvoiceGenerationEmail)){
                Job::send_job_status_email_list($job,$CompanyID,$InvoiceGenerationEmail);
            }else{
                Job::send_job_status_email($job,$CompanyID);
            }
            Log::info(' ========================== Job Email Sent =============================');
            $joblogdata['Message'] = 'Success';
            $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
            CronJobLog::insert($joblogdata);

        }catch (\Exception $e) {

            try {
                Log::info(' ========================== Exception occured =============================');
                Log::error($e);
                if($JobID > 0) {
                    $job = Job::find($JobID);
                    $JobStatusMessage = $job->JobStatusMessage ;
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                    $jobdata['JobStatusMessage'] .= $JobStatusMessage . '\n\r'. $e->getMessage();
                    Job::where(["JobID" => $JobID])->update($jobdata);
                    $job = Job::find($JobID);
                    if(!empty($InvoiceGenerationEmail)){
                        Job::send_job_status_email_list($job,$CompanyID,$InvoiceGenerationEmail);
                    }else{
                        Job::send_job_status_email($job,$CompanyID);
                    }
                    Log::info(' ========================== Exception updated in job and email sent =============================');
                }

                Log::info(' =======================================================');

            } catch (Exception $err) {
                Log::error($err);
            }
            $this->info('Failed:' . $e->getMessage());
            $joblogdata['Message'] ='Error:'.$e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            CronJobLog::insert($joblogdata);
            if(!empty($cronsetting['ErrorEmail'])) {
                $result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
                Log::error("**Email Sent Status " . $result['status']);
                Log::error("**Email Sent message " . $result['message']);
            }
        }
        $dataactive['Active'] = 0;
        $dataactive['PID'] = '';
        $CronJob->update($dataactive);
        if(!empty($cronsetting['SuccessEmail'])){
            $result = CronJob::CronJobSuccessEmailSend($CronJobID);
            Log::error("**Email Sent Status ".$result['status']);
            Log::error("**Email Sent message ".$result['message']);
        }
        Log::error(" CronJobId end" . $CronJobID);


        CronHelper::after_cronrun($this->name, $this);

    }

    protected function getArguments()
    {
        return [
            ['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID'],
            ['CronJobID', InputArgument::REQUIRED, 'Argument CronJobID'],
            ['UserID', InputArgument::OPTIONAL, 'Argument UserID'],
            ['JobID',InputArgument::OPTIONAL,'Argument JobID']
        ];
    }

    /**
     * Get the console command options.
     *
     * @return array
     */
    protected function getOptions()
    {
        return [
            ['example', null, InputOption::VALUE_OPTIONAL, 'An example option.', null],
        ];
    }

}
