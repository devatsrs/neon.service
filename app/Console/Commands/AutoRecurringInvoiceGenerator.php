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
use App\Lib\RecurringInvoice;
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

class AutoRecurringInvoiceGenerator extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'autorecurringinvoicegenerator';

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

        //CronHelper::before_cronrun($this->name, $this );


        $arguments = $this->argument();
        $getmypid = getmypid(); // get proccess id
        $CompanyID = $arguments["CompanyID"];
        $CronJobID = $arguments["CronJobID"];
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

        Log::useFiles(storage_path().'/logs/autorecurringinvoicegenerator-'.$CompanyID.'-'.date('Y-m-d').'.log');


        if (isset($arguments["UserID"]) && User::where("UserID", $arguments["UserID"])->count() > 0) {
            $UserID = $arguments["UserID"];
            Log::info('run by user ' . $UserID);
        } else {
            $UserID = User::where("CompanyID", $CompanyID)->where("Roles", "like", "%Admin%")->min("UserID");
        }
        $recurringInvoiceIDs = RecurringInvoice::select(['RecurringInvoiceID'])
                                ->where(['Status'=>RecurringInvoice::ACTIVE])
                                ->whereRaw('Date(NextInvoiceDate)<=DATE(NOW())')
                                ->lists('RecurringInvoiceID');
        $jobType = JobType::where(["Code" => 'BI'])->get(["JobTypeID", "Title"]);
        $jobStatus = JobStatus::where(["Code" => "I"])->get(["JobStatusID"]);
        $jobdata["CompanyID"] = $CompanyID;
        $jobdata["JobTypeID"] = isset($jobType[0]->JobTypeID) ? $jobType[0]->JobTypeID : '';
        $jobdata["JobStatusID"] = isset($jobStatus[0]->JobStatusID) ? $jobStatus[0]->JobStatusID : '';
        $jobdata["JobLoggedUserID"] = $UserID;
        $jobdata["Title"] = "[Auto] " . (isset($jobType[0]->Title) ? $jobType[0]->Title : '') . ' Generate & Send';
        $jobdata["Description"] = isset($jobType[0]->Title) ? $jobType[0]->Title : '';
        $jobdata["CreatedBy"] = User::get_user_full_name($UserID);
        $jobdata["Options"] = json_encode(["selectedIDs" => implode(',',$recurringInvoiceIDs),'RecurringInvoice'=>1,'CronJobID'=>$CronJobID]);
        $jobdata["created_at"] = date('Y-m-d H:i:s');
        $jobdata["updated_at"] = date('Y-m-d H:i:s');
        $JobID = Job::insertGetId($jobdata);

        $jobdata = array();
        $errors = '';

        try {
            CronJob::createLog($CronJobID);
            Log::info('before call job');
            $this->call('bulkinvoicesend', ['CompanyID' => $CompanyID, 'JobID' => $JobID]);
            Log::info('after call job');
            $job = Job::find($JobID);
            if($job->JobStatusID == DB::table('tblJobStatus')->where('Code','PF')->pluck('JobStatusID')){
                $errors = $job->JobStatusMessage;
            }
            Log::info($errors);
            if(!empty($errors)){
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','PF')->pluck('JobStatusID');
                $jobdata['JobStatusMessage'] = 'Skipped account: '.$errors;
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
            ['UserID', InputArgument::OPTIONAL, 'Argument UserID']
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
