<?php namespace App\Console\Commands;

use App\Lib\Account;
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
use \Exception;

/* not in use*/
class InvoiceManualGenerator extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'manualinvoice';

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

        $CompanyID = $arguments["CompanyID"];
        $CronJobID = $arguments["CronJobID"];
        $CronJob =  CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);



        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';

        Log::useFiles(storage_path().'/logs/manualinvoice-'.$CompanyID.'-'.date('Y-m-d').'.log');



        // Get Active Accounts which has  BillingCycleType set
        $Accounts = Account::select(["AccountID","AccountName"])
            ->whereIn("AccountID" ,explode(',','424,1148,367,298,994,30,938,13,1087,594,354,160,1016,51'))
            ->where(["CompanyID" =>$CompanyID, "Status" => 1,"AccountType" => 1 ])->whereNotNull('BillingCycleType')->get();

       /* $InvoiceGenerationEmail = CompanySetting::getKeyVal($CompanyID,'InvoiceGenerationEmail');
        $InvoiceGenerationEmail = ($InvoiceGenerationEmail != 'Invalid Key')?$InvoiceGenerationEmail:'';
        $InvoiceGenerationEmail = explode(",",$InvoiceGenerationEmail);*/

        $InvoiceGenerationEmail = isset($cronsetting['SuccessEmail']) ? $cronsetting['SuccessEmail'] :'';
        $InvoiceGenerationEmail = explode(",",$InvoiceGenerationEmail);

        $errors = array();
        $message = array();

        $AccountIDs = array_pluck($Accounts, 'AccountID');
        /**
        Create a Job
         */
        if(isset($arguments["UserID"]) && User::where("UserID",$arguments["UserID"])->count()>0){
            $UserID = $arguments["UserID"];
            Log::info('run by user '.$UserID);
        }else{
            $UserID = User::where("CompanyID",$CompanyID)->where(["AdminUser"=>1,"Status"=>1])->min("UserID");
        }

        $jobType = JobType::where(["Code" => 'BI'])->get(["JobTypeID", "Title"]);
        $jobStatus = JobStatus::where(["Code" => "I"])->get(["JobStatusID"]);
        $jobdata["CompanyID"] = $CompanyID;
        $jobdata["JobTypeID"] = isset($jobType[0]->JobTypeID) ? $jobType[0]->JobTypeID : '';
        $jobdata["JobStatusID"] = isset($jobStatus[0]->JobStatusID) ? $jobStatus[0]->JobStatusID : '';
        $jobdata["JobLoggedUserID"] = $UserID;
        $jobdata["Title"] =  "[Auto] " . (isset($jobType[0]->Title) ? $jobType[0]->Title : '').' Generate & Send';
        $jobdata["Description"] = isset($jobType[0]->Title) ? $jobType[0]->Title : '';
        $jobdata["CreatedBy"] = "System";
        $jobdata["Options"] = json_encode(array("accounts"=>$AccountIDs));
        $jobdata["created_at"] = date('Y-m-d H:i:s');
        $jobdata["updated_at"] = date('Y-m-d H:i:s');
        $JobID = Job::insertGetId($jobdata);

        Log::error(' ========================== Invoice Send Loop Start =============================');

        try {
            $ProcessID = Uuid::generate();

            Log::info($Accounts);
            foreach ($Accounts as $Account) {

                $AccountName = $Account['AccountName'];
                $AccountID = $Account['AccountID'];
                try {

                    /** TODO: Write code to check if all CDR is loaded of yesterday.
                     * ----------------------------------------------------------------------------------------
                     *
                     * */



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


                        Log::info('NextInvoiceDate =' . $NextInvoiceDate);

                        if (strtotime($NextInvoiceDate) <= strtotime(date("Y-m-d"))) {

                            Log::info(' ========================== Invoice Send Start =============================');
                            DB::beginTransaction();
                            DB::connection('sqlsrv2')->beginTransaction();
                            Log::info('AccountID =' . $AccountID . ' NextInvoiceDate = ' . $NextInvoiceDate);

                            $LastInvoiceDate = Invoice::getLastInvoiceDate($CompanyID, $AccountID);

                            Log::info('getLastInvoiceDate =' . $LastInvoiceDate);

                            /*                    $StartDate = $LastInvoiceDate;
                                                $EndDate = date("Y-m-d 23:59:59", strtotime("-1 Day", strtotime($NextInvoiceDate)));*/

                            Log::info('Invoice::sendInvoice(' . $CompanyID . ',' . $AccountID . ',' . $LastInvoiceDate . ',' . $NextInvoiceDate . ',' . implode(",", $InvoiceGenerationEmail) . ')');

                            $response = Invoice::sendManualInvoice($CompanyID, $AccountID, $LastInvoiceDate, $NextInvoiceDate, $InvoiceGenerationEmail,$ProcessID,$JobID);

                            Log::info('Invoice::sendInvoice done');

                            if (isset($response["status"]) && $response["status"] == 'success') {

                                Log::info('Invoice created - ' . print_r($response, true));
                                $message[] = $response["message"];
                                Log::info('Invoice Commited  AccountID = ' . $AccountID);
                                DB::commit();
                                DB::connection('sqlsrv2')->commit();

                            } else {
                                $errors[] = $response["message"];
                                DB::rollback();
                                DB::connection('sqlsrv2')->rollback();
                                Log::info('Invoice rollback  AccountID = ' . $AccountID);
                                Log::info(' ========================== Error  =============================');
                                Log::info('Invoice with Error - ' . print_r($response, true));

                            }
                        }

                    }

                    Log::info(' ========================== Invoice Send End =============================');


                } catch (\Exception $e) {

                    try {

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
