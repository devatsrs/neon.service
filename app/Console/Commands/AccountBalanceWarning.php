<?php namespace App\Console\Commands;

use App\Lib\Account;
use App\Lib\Company;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Helper;
use App\Lib\User;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;

class AccountBalanceWarning extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'accountbalancewarning';

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

    protected function getArguments()
    {
        return [
            ['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID '],
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

        $arguments = $this->argument();
        $getmypid = getmypid(); // get proccess id
        $CronJobID = $arguments["CronJobID"];
        $CompanyID = $arguments["CompanyID"];
        $CronJob = CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);
        $dataactive['Active'] = 1;
        $dataactive['PID'] = $getmypid;
        $dataactive['LastRunTime'] = date('Y-m-d H:i:00');
        $CronJob->update($dataactive);

        Log::useFiles(storage_path() . '/logs/accountbalancewarning-' . $CronJobID . '-' . date('Y-m-d') . '.log');

        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';
        $ProcessID = Uuid::generate();
        $cronjobdata = array();
        try {
            CronJob::createLog($CronJobID);
            $Company = Company::find($CompanyID);
            $AccountBalanceWarnings = DB::select("CALL prc_GetAccountBalanceWarning('" . $CompanyID . "','0')");
            foreach($AccountBalanceWarnings as $AccountBalanceWarning){
                if($AccountBalanceWarning->BalanceWarning == 1 && Account::getAccountWarningEmailCount($AccountBalanceWarning->AccountID,$cronsetting['EmailSubject']) == 0) {
                    $Emails = isset($cronsetting['SuccessEmail']) ? $cronsetting['SuccessEmail'] : '';
                    $AccountManagerEmail = Account::getAccountOwnerEmail($AccountBalanceWarning);
                    if (empty($Emails) && !empty($AccountManagerEmail)) {
                        $Emails = $AccountManagerEmail;
                    } else if (!empty($AccountManagerEmail)) {
                        $Emails .= ',' . $AccountManagerEmail;
                    }
                    $emaildata = array(
                        'EmailTo' => explode(",", $Emails),
                        'EmailToName' => $Company->CompanyName,
                        'Subject' => $cronsetting['EmailSubject'],
                        'CompanyID' => $CompanyID,
                        'CompanyName'=>$Company->CompanyName,
                        'Message' =>$cronsetting['EmailMessage']
                    );
                    $status = Helper::sendMail('emails.account_balance_threshold',$emaildata);


                    if(getenv('EmailToCustomer') == 1){
                        $CustomerEmail = $AccountBalanceWarning->BillingEmail;
                    }else{
                        $CustomerEmail = Company::getEmail($CompanyID);;
                    }
                    $CustomerEmail = explode(",",$CustomerEmail);
                    $customeremail_status['status'] = 0;
                    $customeremail_status['message'] = '';
                    $customeremail_status['body'] = '';
                    $UserID = User::getMinUserID($CompanyID);
                    $User = User::getUserInfo($UserID);
                    foreach($CustomerEmail as $singleemail){
                        if (filter_var($singleemail, FILTER_VALIDATE_EMAIL)) {
                            $emaildata['EmailTo'] = $singleemail;
                            $customeremail_status = Helper::sendMail('emails.account_balance_threshold', $emaildata);

                        }
                        if ($customeremail_status['status'] == 0) {
                            $cronjobdata['JobStatusMessage'] = 'Failed sending email to ' . $AccountBalanceWarning->AccountName .' ('.$singleemail.')';
                        } else {
                            $logData = ['AccountID'=>$AccountBalanceWarning->AccountID,
                                'ProcessID'=>$ProcessID,
                                'JobID'=>0,
                                'User'=>$User,
                                'EmailFrom'=>$User->EmailAddress,
                                'EmailTo'=>$emaildata['EmailTo'],
                                'Subject'=>$emaildata['Subject'],
                                'Message'=>$customeremail_status['body']];
                            $statuslog = Helper::email_log($logData);
                            $cronjobdata['JobStatusMessage'] = 'Email sent successfully to ' . $AccountBalanceWarning->AccountName.' ('.$singleemail.')';
                        }
                    }

                }
            }
            if(count($cronjobdata)){
                $joblogdata['Message'] ='Message : '.implode(',<br>',$cronjobdata);
            }else{
                $joblogdata['Message'] = 'Success';
            }
            $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
            CronJobLog::insert($joblogdata);
        } catch (\Exception $e) {

            $this->info('Failed:' . $e->getMessage());
            $joblogdata['Message'] = 'Error:' . $e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            CronJobLog::insert($joblogdata);
            Log::error($e);
            if(!empty($cronsetting['ErrorEmail'])) {
                $result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
                Log::error("**Email Sent Status " . $result['status']);
                Log::error("**Email Sent message " . $result['message']);
            }
        }

        $dataactive['Active'] = 0;
        $dataactive['PID'] = '';
        $CronJob->update($dataactive);
        if(!empty($cronsetting['SuccessEmail'])) {
            $result = CronJob::CronJobSuccessEmailSend($CronJobID);
            Log::error("**Email Sent Status ".$result['status']);
            Log::error("**Email Sent message ".$result['message']);
        }
    }
}
