<?php namespace App\Console\Commands;

use App\Lib\Company;
use App\Lib\CompanyConfiguration;
use App\Lib\CompanySetting;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\DataTableSql;
use App\Lib\Helper;
use App\Lib\Job;
use App\Lib\JobStatus;
use App\Lib\JobType;
use App\Lib\Notification;
use App\Lib\User;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;

class AutoTransactionsLogEmail extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'transactionlogemail';

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
            ['CronJobID', InputArgument::REQUIRED, 'Argument CronJobID'],
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
        $CompanyID = $arguments["CompanyID"];
        $CronJobID = $arguments["CronJobID"];
        $getmypid = getmypid(); // get proccess id
        $CronJob =  CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);
        $dataactive['Active'] = 1;
        $dataactive['PID'] = $getmypid;
        $dataactive['LastRunTime'] = date('Y-m-d H:i:00');
        $CronJob->update($dataactive);

        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';

        $TRANSACTION_LOG_EMAIL_FREQUENCY = CompanyConfiguration::get($CompanyID,'TRANSACTION_LOG_EMAIL_FREQUENCY');
        //AccountName,InvoiceNumber,[Transaction], Notes,created_at,Amount,Status
        try {
            $Company = Company::find($CompanyID);
            $frequency = $TRANSACTION_LOG_EMAIL_FREQUENCY;
            $frequency = (empty($frequency)) ? 'Daily' : $frequency;

            $query = "CALL prc_GetTransactionsLogbyInterval(  '" . $CompanyID . "' , '" . $frequency . "') "; // Default Weekly

            $result = DB::connection('sqlsrv2')->select($query);

            CronJob::createLog($CronJobID);

            if (count($result)) {

                /**  Create a Job */
                $UserID = User::where("CompanyID", $CompanyID)->where(["AdminUser"=>1,"Status"=>1])->min("UserID");
                $CreatedBy = User::get_user_full_name($UserID);
                $jobType = JobType::where(["Code" => 'TLE'])->get(["JobTypeID", "Title"]); // Auto Weekly Transaction Update
                $jobStatus = JobStatus::where(["Code" => "I"])->get(["JobStatusID"]);
                $jobdata["CompanyID"] = $CompanyID;
                $jobdata["JobTypeID"] = isset($jobType[0]->JobTypeID) ? $jobType[0]->JobTypeID : '';
                $jobdata["JobStatusID"] = isset($jobStatus[0]->JobStatusID) ? $jobStatus[0]->JobStatusID : '';
                $jobdata["JobLoggedUserID"] = $UserID;
                $jobdata["Title"] = "[Auto] " . (isset($jobType[0]->Title) ? $jobType[0]->Title : '');
                $jobdata["Description"] = isset($jobType[0]->Title) ? $jobType[0]->Title : '';
                $jobdata["CreatedBy"] = "System";
                $jobdata["created_at"] = date('Y-m-d H:i:s');
                $jobdata["updated_at"] = date('Y-m-d H:i:s');
                $JobID = Job::insertGetId($jobdata);


                /*$InvoiceGenerationEmail = CompanySetting::getKeyVal($CompanyID, 'InvoiceGenerationEmail');
                $InvoiceGenerationEmail = ($InvoiceGenerationEmail == 'Invalid Key') ? $Company->Email : $InvoiceGenerationEmail;*/
                $WeeklyPaymentTransactionLogEmail = Notification::getNotificationMail(['CompanyID'=>$CompanyID,'NotificationType'=>Notification::WeeklyPaymentTransactionLog]);
                $WeeklyPaymentTransactionLogEmail = empty($WeeklyPaymentTransactionLogEmail) ? $cronsetting['SuccessEmail'] : $WeeklyPaymentTransactionLogEmail;
                $status = Helper::sendMail('emails.invoices.transaction_log', array(
                    'EmailTo' => explode(",", $WeeklyPaymentTransactionLogEmail),
                    'EmailToName' => $Company->CompanyName,
                    'Subject' => 'Weekly Payment Transaction log',
                    'CompanyID' => $CompanyID,
                    'data' => array("TransactionData" => $result, 'CompanyName' => $Company->CompanyName)
                ));
                if ($status['status'] == 0) {

                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                    $jobdata['JobStatusMessage'] = 'Failed sending email';

                } else {
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'S')->pluck('JobStatusID');
                    $jobdata['JobStatusMessage'] = 'Email sent successfully.';
                }

                Job::where(["JobID" => $JobID])->update($jobdata);
                $job = Job::find($JobID);
                Job::send_job_status_email($job, $CompanyID);
                $joblogdata['Message'] = 'Success';
                $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
                CronJobLog::insert($joblogdata);
            }
        } catch (\Exception $e) {

            Log::error($e);
            if(!empty($cronsetting['ErrorEmail']))
            {
                $result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
                Log::error("**Email Sent Status ".$result['status']);
                Log::error("**Email Sent message ".$result['message']);
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




}
