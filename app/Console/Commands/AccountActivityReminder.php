<?php
namespace App\Console\Commands;

use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Helper;
use App\Lib\User;
use App\Lib\Task;
use App\Lib\Account;
use App\Lib\Company;
use App\Lib\JobStatus;
use Symfony\Component\Console\Input\InputArgument;
use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Config;
use App\Lib\Job;
use App\Lib\JobType;
use Webpatser\Uuid\Uuid;
use \Exception;

class AccountActivityReminder extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'accountactivityreminder';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Account Activity email send.';

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
        $getmypid = getmypid(); // get proccess id
        $CompanyID = $arguments["CompanyID"];
        $CronJobID = $arguments["CronJobID"];

        $CronJob =  CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);
        $dataactive['Active'] = 1;
        $dataactive['PID'] = $getmypid;
        $CronJob->update($dataactive);

        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';

        $count = 0;
        $JobID = 0;
        $errors = [];
        $today = date('Y-m-d');
        $Company = Company::find($CompanyID);
        try {
            CronJob::createLog($CronJobID);
            $select = ['tblAccount.AccountName', 'tblTask.Subject', 'tblTask.DueDate', 'tblCRMBoardColumn.BoardColumnName' ,'tblUser.EmailAddress', 'tblTask.Task_type', 'tblUser.FirstName', 'tblUser.LastName', 'tblAccount.AccountName'];
            $accounttask = Account::join('tblTask', 'tblTask.AccountIDs', '=', 'tblAccount.AccountID')
                ->join('tblCRMBoardColumn','tblTask.BoardColumnID','=','tblCRMBoardColumn.BoardColumnID')
               // ->join('tblUser', 'tblUser.UserID', '=', 'tblAccount.Owner');//convert(date,errorDate,101)
               ->join('tblUser', 'tblUser.UserID', '=', 'tblTask.UsersIDs');//convert(date,errorDate,101)
            $accounttask->where('tblAccount.CompanyID', $CompanyID)->whereRaw("DATE_FORMAT(tblTask.DueDate,'%Y-%m-%d')='" . $today . "'")->orderBy('tblUser.UserID', 'ASC')->orderBy('tblAccount.AccountID', 'DESC');
            //$accountactivity = AccountActivity::where('CompanyID', $CompanyID)->whereRaw('YEAR([Date])-MONTH([Date])-DAY([Date])=' . $today)->orderBy('AccountID','DESC');
            //$accountactivity->join('tblAccount','tblAccountActivity.AccountID','=','tblAccount.AccountID');
            $accounttask->select($select);
            $tasks = $accounttask->get();
            if (count($tasks)>0) {
                /**  Create a Job */
                $UserID = User::where("CompanyID", $CompanyID)->where("AdminUser", "=", "1")->min("UserID");
                $CreatedBy = User::get_user_full_name($UserID);
                $jobType = JobType::where(["Code" => 'AAE'])->get(["JobTypeID", "Title"]); // Account Activity Reminder
                $jobStatus = JobStatus::where(["Code" => "I"])->get(["JobStatusID"]);
                $jobdata["CompanyID"] = $CompanyID;
                $jobdata["JobTypeID"] = isset($jobType[0]->JobTypeID) ? $jobType[0]->JobTypeID : '';
                $jobdata["JobStatusID"] = isset($jobStatus[0]->JobStatusID) ? $jobStatus[0]->JobStatusID : '';
                $jobdata["JobLoggedUserID"] = $UserID;
                $jobdata["Title"] = (isset($jobType[0]->Title) ? $jobType[0]->Title : '');
                $jobdata["Description"] = isset($jobType[0]->Title) ? $jobType[0]->Title : '';
                $jobdata["CreatedBy"] = $CreatedBy;
                $jobdata["created_at"] = date('Y-m-d H:i:s');
                $jobdata["updated_at"] = date('Y-m-d H:i:s');
                $JobID = Job::insertGetId($jobdata);
                $emaillist = array();
                foreach ($tasks as $task) {
                    $emaillist[$task->EmailAddress][] = array('AccountName' => $task->AccountName,
                        'Subject' => $task->Subject,
                        'Date' => date('d-m-Y h:i:A',strtotime($task->DueDate)),
                        'TaskType' => 'Task',
                        'FirstName' => $task->FirstName,
                        'LastName' => $task->LastName,
                        'Priority' => $task->Priority,
                        'BoardColumnName'=>$task->BoardColumnName,
                        'AccountName'=>$task->AccountName);
                }

                foreach($emaillist as $email=>$tasks){
                    $status = Helper::sendMail('emails.AccountActivityEmailSend', array(
                        'EmailTo' => $email,
                        'EmailToName' => $tasks[0]['FirstName'] . ' ' . $tasks[0]['FirstName'],
                        'Subject' => 'Account activity reminder',
                        'CompanyID' => $CompanyID,
                        'data' => array("AccountTaskData" => $tasks, 'CompanyName' => $Company->CompanyName)
                    ));
                    if (isset($status["status"]) && $status["status"] == 0) {
                        $errors[] = 'Mail not send to ' . $tasks[0]['FirstName'] . ',\n\r Error Message:' . $status["message"];
                        $jobdata['EmailSentStatus'] = $status['status'];
                        $jobdata['EmailSentStatusMessage'] = $status['message'];
                    } else {
                        $count++;
                    }
                }

            } else {
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                $jobdata['JobStatusMessage'] = 'No Data Found';
            }

            if (count($errors) > 0) {
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'PF')->pluck('JobStatusID');
                $jobdata['JobStatusMessage'] = $count . ' Email sent, ' . count($errors) . ' Skipped account: ' . implode(',\n\r', $errors);
            } else {
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'S')->pluck('JobStatusID');
                $jobdata['JobStatusMessage'] = $count . " Email sent, Email successfully send to all.";
            }
            if($JobID > 0) {
                Job::where(["JobID" => $JobID])->update($jobdata);
                $job = Job::find($JobID);
                Job::send_job_status_email($job, $CompanyID);
            }

            $joblogdata['Message'] = 'Success';
            $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
            CronJobLog::insert($joblogdata);
        } catch (\Exception $e) {
            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
            $jobdata['JobStatusMessage'] = 'Exception: ' . $e->getMessage();
            $jobdata['updated_at'] = date('Y-m-d H:i:s');
            $jobdata['ModifiedBy'] = 'RMScheduler';
            if($JobID > 0) {
                Job::where(["JobID" => $JobID])->update($jobdata);
                $job = Job::find($JobID);
                Job::send_job_status_email($job, $CompanyID);
            }
            Log::error($e);
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
}