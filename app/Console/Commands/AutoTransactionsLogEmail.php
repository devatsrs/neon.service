<?php namespace App\Console\Commands;

use App\Lib\Company;
use App\Lib\CompanySetting;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\DataTableSql;
use App\Lib\Helper;
use App\Lib\Job;
use App\Lib\JobStatus;
use App\Lib\JobType;
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
	 * Execute the console command.
	 *
	 * @return mixed
	 */
	public function fire()
	{
        $arguments = $this->argument();
        $CompanyID = $arguments["CompanyID"];
        $CronJobID = $arguments["CronJobID"];
        $getmypid = getmypid(); // get proccess id
        $CronJob =  CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);
        $dataactive['Active'] = 1;
        $dataactive['PID'] = $getmypid;
        $CronJob->update($dataactive);

        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';


        //AccountName,InvoiceNumber,[Transaction], Notes,created_at,Amount,Status
        try {
            $Company = Company::find($CompanyID);
            $frequency = getenv("TRANSACTION_LOG_EMAIL_FREQUENCY");
            $frequency = (empty($frequency)) ? 'Daily' : $frequency;

            $query = "CALL prc_GetTransactionsLogbyInterval(  '" . $CompanyID . "' , '" . $frequency . "') "; // Default Weekly

            $result = DB::connection('sqlsrv2')->select($query);

            CronJob::createLog($CronJobID);

            if (count($result)) {

                /**  Create a Job */
                $UserID = User::where("CompanyID", $CompanyID)->where("Roles", "like", "%Admin%")->min("UserID");
                $CreatedBy = User::get_user_full_name($UserID);
                $jobType = JobType::where(["Code" => 'TLE'])->get(["JobTypeID", "Title"]); // Auto Weekly Transaction Update
                $jobStatus = JobStatus::where(["Code" => "I"])->get(["JobStatusID"]);
                $jobdata["CompanyID"] = $CompanyID;
                $jobdata["JobTypeID"] = isset($jobType[0]->JobTypeID) ? $jobType[0]->JobTypeID : '';
                $jobdata["JobStatusID"] = isset($jobStatus[0]->JobStatusID) ? $jobStatus[0]->JobStatusID : '';
                $jobdata["JobLoggedUserID"] = $UserID;
                $jobdata["Title"] = "[Auto] " . (isset($jobType[0]->Title) ? $jobType[0]->Title : '');
                $jobdata["Description"] = isset($jobType[0]->Title) ? $jobType[0]->Title : '';
                $jobdata["CreatedBy"] = $CreatedBy;
                $jobdata["updated_at"] = date('Y-m-d H:i:s');
                $JobID = Job::insertGetId($jobdata);


                /*$InvoiceGenerationEmail = CompanySetting::getKeyVal($CompanyID, 'InvoiceGenerationEmail');
                $InvoiceGenerationEmail = ($InvoiceGenerationEmail == 'Invalid Key') ? $Company->Email : $InvoiceGenerationEmail;*/
                $InvoiceGenerationEmail = isset($cronsetting['SuccessEmail']) ? $cronsetting['SuccessEmail'] : '';
                $status = Helper::sendMail('emails.invoices.transaction_log', array(
                    'EmailTo' => explode(",", $InvoiceGenerationEmail),
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
