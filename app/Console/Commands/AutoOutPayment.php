<?php

namespace App\Console\Commands;

use App\Lib\Account;
use App\Lib\AccountBalance;
use App\Lib\AccountBalanceLog;
use App\Lib\AccountBilling;
use App\Lib\Company;
use App\Lib\CompanyConfiguration;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Currency;
use App\Lib\EmailsTemplates;
use App\Lib\Helper;
use App\Lib\NeonAPI;
use App\Lib\Notification;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;

class AutoOutPayment extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'AutoOutPayment';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'AutoOutPayment Command description.';

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
    public function handle() {
        CronHelper::before_cronrun($this->name, $this);
        $SuccessOutPayment = array();
        $FailureOutPayment = array();
        $ErrorOutPayment = array();
        $arguments = $this->argument();
        $CompanyID = $arguments["CompanyID"];
        $CronJobID = $arguments["CronJobID"];

        //dd($this->getArguments());
        $CronJob =  CronJob::find($CronJobID);
        if($CronJob != false) {
            $cronsetting = json_decode($CronJob->Settings, true);
            CronJob::activateCronJob($CronJob);
            CronJob::createLog($CronJobID);
        }
        //print_r($cronsetting);die();
        Log::useFiles(storage_path() . '/logs/AutoOutPayment-companyid-'.$CompanyID . '-cronjobid-'.$CronJobID.'-' . date('Y-m-d') . '.log');
        try {
            $AutoOutPaymentList =  Account::Join('tblAccountPaymentAutomation','tblAccount.AccountID','=','tblAccountPaymentAutomation.AccountID')
                ->Join('tblAccountBalance','tblAccount.AccountID','=','tblAccountBalance.AccountID')
                ->select(['BalanceAmount','AccountName','tblAccount.AccountID','AutoOutpayment','OutPaymentThreshold','OutPaymentAmount','OutPaymentAvailable'])
                ->where('tblAccountPaymentAutomation.AutoOutpayment','=', 1)
                ->where('tblAccountPaymentAutomation.OutPaymentThreshold','>', 0)
                ->where('tblAccountPaymentAutomation.OutPaymentAmount','>', 0)
                ->orderBy("tblAccountPaymentAutomation.AccountID", "ASC");

            Log::info('Auto Out Payment Query.' . $AutoOutPaymentList->toSql());
            $AutoOutPaymentList = $AutoOutPaymentList->get();

            Log::info('DONE With AutoOutPaymentAccount.' . count($AutoOutPaymentList));
            $CompanyConfiguration = CompanyConfiguration::where(['CompanyID' => $CompanyID, 'Key' => 'API'])->pluck('Value');
            foreach($AutoOutPaymentList as $AutoOutPaymentAccount) {

                $BillingType = AccountBilling::where([
                    'AccountID'=>$AutoOutPaymentAccount->AccountID,
                    'ServiceID'=>0
                ])->pluck('BillingType');
                $BalanceAmount = AccountBalance::getNewAccountBalance($CompanyID, $AutoOutPaymentAccount->AccountID);
                if(isset($BillingType) && $BillingType==1){
                    $BalanceAmount = AccountBalanceLog::getPrepaidAccountBalance($AutoOutPaymentAccount->AccountID);
                }

                if((float)$BalanceAmount >= (float)$AutoOutPaymentAccount->OutPaymentThreshold) {
                    $OutPaymentAccount = $this::callOutPaymentApi($AutoOutPaymentAccount, $CompanyConfiguration);
                    if ($OutPaymentAccount[0] == "success") {
                        $successRecord = array();
                        $successRecord["AccountID"] = $AutoOutPaymentAccount->AccountID;
                        $successRecord["AccountName"] = $AutoOutPaymentAccount->AccountName;
                        $successRecord["Amount"] = $AutoOutPaymentAccount->OutPaymentAmount;
                        $SuccessOutPayment[count($SuccessOutPayment) + 1] = $successRecord;
                        Log::info('Call the auto out payment API $AutoOutPaymentAccount success.' . count($SuccessOutPayment));
                    } elseif ($OutPaymentAccount[0] == "failed") {
                        $failedRecord = array();
                        $failedRecord["AccountID"] = $AutoOutPaymentAccount->AccountID;
                        $failedRecord["AccountName"] = $AutoOutPaymentAccount->AccountName;
                        $failedRecord["Response"] = $OutPaymentAccount[1];
                        $FailureOutPayment[count($FailureOutPayment) + 1] = $failedRecord;
                        Log::info('Call the auto out payment API $AutoOutPaymentAccount failed.' . count($FailureOutPayment));
                    } elseif ($OutPaymentAccount[0] == "error") {
                        $errorRecord = array();
                        $errorRecord["AccountID"] = $AutoOutPaymentAccount->AccountID;
                        $errorRecord["AccountName"] = $AutoOutPaymentAccount->AccountName;
                        $errorRecord["Response"] = $OutPaymentAccount[1];
                        $ErrorOutPayment[count($ErrorOutPayment) + 1] = $errorRecord;
                    }
                }
            }

            $totalMsg = count($SuccessOutPayment) + count($FailureOutPayment) + count($ErrorOutPayment);

            if ($totalMsg > 0) {
                $this::AutoOutPaymentNotification($CompanyID, $SuccessOutPayment, $FailureOutPayment, $ErrorOutPayment);
            } else {
                Log::info('No Account IDs found for the auto out payment.');
            }

            CronJob::CronJobSuccessEmailSend($CronJobID);
            CronJob::deactivateCronJob($CronJob);
            CronHelper::after_cronrun($this->name, $this);
            echo "DONE With AutoOutPayment";

        } catch (\Exception $e) {
            Log::useFiles(storage_path() . '/logs/AutoOutPayment-Error-' . date('Y-m-d') . '.log');
            //Log::info('LCRRoutingEngine Error.');
            Log::useFiles(storage_path() . '/logs/AutoOutPayment-Error-' . date('Y-m-d') . '.log');

            Log::error($e);
            $this->info('Failed:' . $e->getMessage());
            $joblogdata['Message'] = 'Error:' . $e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            CronJobLog::insert($joblogdata);
            if (!empty($cronsetting['ErrorEmail'])) {
                $result = CronJob::CronJobErrorEmailSend($CronJobID, $e);
                Log::error("**Email Sent Status " . $result['status']);
                Log::error("**Email Sent message " . $result['message']);
            }
        }
    }

    /**
     * Get the console command arguments.
     *
     * @return array
     */
    protected function getArguments()
    {
        return [
            ['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID '],
            ['CronJobID', InputArgument::REQUIRED, 'Argument CronJobID'],
        ];
    }


    /**
     * @param $AutoPaymentAccount
     * @param $CompanyConfiguration
     * @return array
     */
    public function callOutPaymentApi($AutoPaymentAccount,$CompanyConfiguration)
    {
        //$CompanyConfiguration = 'http://localhost/neon/web/staging/public';
        $url = $CompanyConfiguration;
        Log::info("$AutoPaymentAccount .." . $AutoPaymentAccount->AccountID);
        $autoOutPayment = array();
        $postdata = array(
            'AccountID' => $AutoPaymentAccount->AccountID,
            'Amount' => (int)$AutoPaymentAccount->OutPaymentAmount
        );
        $postdata = json_encode($postdata, true);

        if (!NeonAPI::endsWith($CompanyConfiguration,"/")) {
            $url = $CompanyConfiguration . "/";
        }
        $localIP = env('SERVER_LOCAL_IP');
        $url =  !empty($localIP) ? "http://$localIP/" : $url;
        Log::info("Out Payment API URL" . $url);
        $APIresponse = NeonAPI::callAPI($postdata,"api/requestFund",$url);
        //dd($APIresponse);
        if (isset($APIresponse["error"])) {
            Log::info(print_r($APIresponse["error"],true));
            $autoOutPayment[0] = "error";
            $autoOutPayment[1] = $APIresponse["error"];
        } else {
            $response = json_decode($APIresponse["response"], true);
            Log::info(print_r($response, true));
            $autoOutPayment[0] = isset($response['RequestFundID']) ? "success" : "failed";
            $autoOutPayment[1] = $response;
        }

        return $autoOutPayment;
    }

    /**
     * @param $CompanyID
     * @param $SuccessOutPayment
     * @param $FailureOutPayment
     * @param $ErrorOutPayment
     * @return array|bool
     */
    public static function AutoOutPaymentNotification($CompanyID,$SuccessOutPayment,$FailureOutPayment,$ErrorOutPayment){

        $emaildata = array();
        $CompanyName = Company::getName($CompanyID);

        $emaildata['SuccessOutPayment'] = $SuccessOutPayment;
        $emaildata['FailureOutPayment'] = $FailureOutPayment;
        $emaildata['ErrorOutPayment'] = $ErrorOutPayment;

        $AutoOutPaymentNotificationEmail = Notification::getNotificationMail(['CompanyID' => $CompanyID, 'NotificationType' => Notification::AutoOutPayment]);
        Log::info("$AutoOutPaymentNotificationEmail .." . $AutoOutPaymentNotificationEmail);

        $result = false;
        if($AutoOutPaymentNotificationEmail != '') {
            $emaildata['CompanyID'] = $CompanyID;
            $emaildata['CompanyName'] = $CompanyName;
            $emaildata['EmailTo'] = $AutoOutPaymentNotificationEmail;
            $emaildata['EmailToName'] = '';
            $emaildata['Subject'] = 'Auto Out Payment Notification Email';
            //$emaildata['Message'] = $Message;
            Log::info("AutoOutPaymentNotificationEmail Success: " . count($emaildata['SuccessOutPayment']));
            Log::info("AutoOutPaymentNotificationEmail Failure: " . count($emaildata['FailureOutPayment']));
            Log::info("AutoOutPaymentNotificationEmail Error: " . count($emaildata['ErrorOutPayment']));
            $result = Helper::sendMail('emails.auto_out_payment', $emaildata);
        }
        return $result;
    }

}
