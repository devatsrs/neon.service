<?php namespace App\Console\Commands;

use App\Lib\Account;
use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Invoice;
use App\Lib\InvoiceGenerate;
use App\Lib\Job;
use App\Lib\JobStatus;
use App\Lib\JobType;
use App\Lib\Product;
use App\Lib\TaxRate;
use App\Lib\User;
use Exception;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputOption;
use Webpatser\Uuid\Uuid;

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
        $ProcessID = CompanyGateway::getProcessID();
        $CompanyID = $arguments["CompanyID"];
        $CronJobID = $arguments["CronJobID"];
        $JobID = $arguments["JobID"];
        $CronJob =  CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);
        $today = date("Y-m-d");
        $date = date('Y-m-d H:i:s');
        CronJob::activateCronJob($CronJob);
        CronJob::createLog($CronJobID);

        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = $date;
        $joblogdata['created_by'] = 'RMScheduler';

        Log::useFiles(storage_path().'/logs/invoicegenerator-'.$CompanyID.'-'.date('Y-m-d').'.log');

        $Products = Product::getAllProductName($CompanyID);
        $Taxes = TaxRate::getAllTaxName($CompanyID);
        $data['Products'] = $Products;
        $data['Taxes'] = $Taxes;


        // Get Active Accounts which has BillingCycleType set
        $Accounts = Account::join('tblAccountBilling','tblAccountBilling.AccountID','=','tblAccount.AccountID')->select(["tblAccount.AccountID","AccountName"])->where(["Status" => 1,"AccountType" => 1,'IsCustomer' => 1])->where('tblAccountBilling.NextInvoiceDate','<=',$today)->whereNotNull('tblAccountBilling.BillingCycleType')->get();


        Log::info("Getting Accounts " . Account::join('tblAccountBilling','tblAccountBilling.AccountID','=','tblAccount.AccountID')->select(["tblAccount.AccountID","AccountName"])->where(["Status" => 1,"AccountType" => 1,'IsCustomer' => 1])->where('tblAccountBilling.NextInvoiceDate','<=',$today)->whereNotNull('tblAccountBilling.BillingCycleType')->toSql());
        Log::info("Accounts " . json_encode($Accounts));
        $InvoiceGenerationEmail = isset($cronsetting['SuccessEmail']) ? $cronsetting['SuccessEmail'] :'';
        $InvoiceGenerationEmail = explode(",",$InvoiceGenerationEmail);



        $AccountIDs = array_pluck($Accounts, 'AccountID');

        if (isset($arguments["UserID"]) && User::where("UserID", $arguments["UserID"])->count() > 0) {
            $UserID = $arguments["UserID"];
            Log::info('run by user ' . $UserID);
        } else {
            $UserID = User::where("CompanyID", $CompanyID)->where(["AdminUser"=>1,"Status"=>1])->min("UserID");
        }

        if((int)$JobID == 0) {

            /**
             * Create a Job
             */

            $jobType = JobType::where(["Code" => 'BI'])->get(["JobTypeID", "Title"]);
            $jobStatus = JobStatus::where(["Code" => "I"])->get(["JobStatusID"]);
            $jobdata["CompanyID"] = $CompanyID;
            $jobdata["JobTypeID"] = isset($jobType[0]->JobTypeID) ? $jobType[0]->JobTypeID : '';
            $jobdata["JobStatusID"] = isset($jobStatus[0]->JobStatusID) ? $jobStatus[0]->JobStatusID : '';
            $jobdata["JobLoggedUserID"] = $UserID;
            $jobdata["Title"] = "[Auto] " . (isset($jobType[0]->Title) ? $jobType[0]->Title : '') . ' Generate & Send';
            $jobdata["Description"] = isset($jobType[0]->Title) ? $jobType[0]->Title : '';
            $jobdata["CreatedBy"] = "System";
            $jobdata["Options"] = json_encode(array("accounts" => $AccountIDs,'CronJobID'=>$CronJobID));
            $jobdata["created_at"] = $date;
            $jobdata["updated_at"] = $date;
            $JobID = Job::insertGetId($jobdata);
            $jobdata = array();
        }else{
            Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar
        }
        /** ************************************************************/

        try {
            /** regular invoice start */
            $SingleInvoice = 0;
            $response = InvoiceGenerate::GenerateInvoice($CompanyID,$AccountIDs,$InvoiceGenerationEmail,$ProcessID,$JobID);
            $errors = isset($response['errors'])?$response['errors']:array();
            $message = isset($response['message'])?$response['message']:array();


            if(count($errors)>0){
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','PF')->pluck('JobStatusID');
                $jobdata['JobStatusMessage'] = (count($errors)>0?'Skipped account: '.implode(',\n\r',$errors):'');
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
        CronJob::deactivateCronJob($CronJob);
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
