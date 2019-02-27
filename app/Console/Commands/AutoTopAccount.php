<?php namespace App\Console\Commands;




use App\Lib\CronHelper;
use App\Lib\NeonAPI;
use App\Lib\Summary;
use App\Lib\AccountPaymentAutomation;
use Illuminate\Console\Command;
use App\Lib\CronJob;
use App\Lib\Account;
use App\Lib\Company;
use App\Lib\Notification;
use App\Lib\Helper;
use App\Lib\CompanyConfiguration;
use App\Lib\CronJobLog;
use App\Lib\AccountBalance;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use \Exception;
use Symfony\Component\Console\Input\InputArgument;
use Illuminate\Support\Facades\Crypt;
use App\Lib\CompanyGateway;

class AutoTopAccount extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'autotopaccount';

	/**
	 * The console command description.
	 *
	 * @var string
	 */
	protected $description = 'AutoTopAccount Command description.';

	protected function getArguments()
	{
		return [
			['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID '],
			['CronJobID', InputArgument::REQUIRED, 'Argument CronJobID'],
		];
	}

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
        
        CronHelper::before_cronrun($this->name, $this );
		$SuccessDepositAccount = array();
		$FailureDepositFund = array();
        $arguments = $this->argument();
        $CompanyID = $arguments["CompanyID"];
        $CronJobID = $arguments["CronJobID"];
        
        $CronJob =  CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);
        CronJob::activateCronJob($CronJob);
        CronJob::createLog($CronJobID);
        
        //print_r($cronsetting);die();
        Log::useFiles(storage_path() . '/logs/AutoTopAccount-companyid-'.$CompanyID . '-cronjobid-'.$CronJobID.'-' . date('Y-m-d') . '.log');
		try{

			$AutoPaymentAccountList = Account::
			Join('tblAccountPaymentAutomation','tblAccount.AccountID','=','tblAccountPaymentAutomation.AccountID')
				->select(['AccountName','tblAccount.AccountID','Number','MinThreshold','TopupAmount'])
				->where(['tblAccount.Status'=>1,'tblAccount.CompanyId'=>$CompanyID])
				->where('tblAccountPaymentAutomation.AutoTopup','=', 1)
				->orderBy("tblAccountPaymentAutomation.AccountID", "ASC");
			$AutoPaymentAccountList = $AutoPaymentAccountList->get();
			$CompanyConfiguration = CompanyConfiguration::where(['CompanyID' => $CompanyID, 'Key' => 'WEB_URL'])->pluck('Value');
			if(!empty($AutoPaymentAccountList) && !empty($CompanyConfiguration)) {
				foreach ($AutoPaymentAccountList as $AutoPaymentAccount) {
					$AccountBalance = AccountBalance::getAccountBalanceWithActiveCall($AutoPaymentAccount->AccountID);
					if ($AccountBalance <= $AutoPaymentAccount->MinThreshold && $AutoPaymentAccount->TopupAmount > 0) {
						$DepositAccount = AccountPaymentAutomation::calldepositFundAPI($AutoPaymentAccount, $CompanyConfiguration);
						if (!empty($DepositAccount)) {
							if ($DepositAccount[0] == "success") {
								$successRecord = array();
								$successRecord["AccountID"] = $AutoPaymentAccount->AccountID;
								$successRecord["AccountName"] = $AutoPaymentAccount->AccountName;
								$successRecord["Number"] = $AutoPaymentAccount->Number;
								$successRecord["Amount"] = $AutoPaymentAccount->TopupAmount;
								$SuccessDepositAccount[count($SuccessDepositAccount) + 1] = $successRecord;
								//Log::info('Call the deposit API $DepositAccount success.' . count($SuccessDepositAccount));
							} else if ($DepositAccount[0] == "failed") {
								$failedRecord = array();
								$failedRecord["AccountID"] = $AutoPaymentAccount->AccountID;
								$failedRecord["AccountName"] = $AutoPaymentAccount->AccountName;
								$failedRecord["Number"] = $AutoPaymentAccount->Number;
								$failedRecord["Response"] = $DepositAccount[1];
								$FailureDepositFund[count($FailureDepositFund) + 1] = $failedRecord;
								//Log::info('Call the deposit API $DepositAccount failed.' . count($FailureDepositFund));
							}
						}
					}

				}


				if (count($AutoPaymentAccountList) > 0) {
					if (count($FailureDepositFund) > 0 || count($SuccessDepositAccount)) {
						AccountPaymentAutomation::AutoTopUpNotification($CompanyID, $SuccessDepositAccount, $FailureDepositFund);
					}
				} else {
					Log::info('No Account IDs found for the auto top up.');
				}
			}

			CronJob::CronJobSuccessEmailSend($CronJobID);
			$joblogdata['CronJobID'] = $CronJobID;
			$joblogdata['created_at'] = Date('y-m-d');
			$joblogdata['created_by'] = 'RMScheduler';
			$joblogdata['Message'] = 'AutoTopAccount Successfully Done';
			$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
			CronJobLog::insert($joblogdata);
			CronJob::deactivateCronJob($CronJob);
			CronHelper::after_cronrun($this->name, $this);
			//Log::info('routingList:Get the routing list user company.' . $CompanyID);
            Log::info('Run Cron.');
        }catch (\Exception $e){
            Log::error($e);
            $this->info('Failed:' . $e->getMessage());
			$joblogdata['CronJobID'] = $CronJobID;
			$joblogdata['created_at'] = Date('y-m-d');
			$joblogdata['created_by'] = 'RMScheduler';
            $joblogdata['Message'] ='Error:'.$e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            CronJobLog::insert($joblogdata);
            if(!empty($cronsetting['ErrorEmail'])) {
				$result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
				Log::error("**Email Sent Status " . $result['status']);
				Log::error("**Email Sent message " . $result['message']);
            }
  	  }

    }



	public static function AutoTopUpNotification($CompanyID,$SuccessDepositAccounts,$FailureDepositFundAccounts,$ErrorDepositFundAccounts)
	{

		$emaildata = array();

		$ComanyName = Company::getName($CompanyID);

		$emaildata['SuccessDepositAccount'] = $SuccessDepositAccounts;
		$emaildata['FailureDepositFund'] = $FailureDepositFundAccounts;
		$emaildata['ErrorDepositFund'] = $ErrorDepositFundAccounts;

		$AutoTopUpNotificationEmail = Notification::getNotificationMail(['CompanyID' => $CompanyID, 'NotificationType' => Notification::AutoTopAccount]);
		Log::info("$AutoTopUpNotificationEmail .." . $AutoTopUpNotificationEmail);

		$emaildata['CompanyID'] = $CompanyID;
		$emaildata['CompanyName'] = $ComanyName;
		$emaildata['EmailTo'] = $AutoTopUpNotificationEmail;
		$emaildata['EmailToName'] = '';
		$emaildata['Subject'] = 'Auto Top Up Notification Email';
		//$emaildata['Message'] = $Message;
		//Log::info("AutoTopUpNotificationEmail 1" . count($emaildata['SuccessDepositAccount']));
		//Log::info("AutoTopUpNotificationEmail 2" . count($emaildata['FailureDepositFund']));
		//Log::info("AutoTopUpNotificationEmail 3" . count($emaildata['ErrorDepositFund']));
		$result = Helper::sendMail('emails.auto_top_up_amount', $emaildata);
		return $result;
	}

	function endsWith($haystack, $needle) {
		// search forward starting from end minus needle length characters
		if ($needle === '') {
			return true;
		}
		$diff = \strlen($haystack) - \strlen($needle);
		return $diff >= 0 && strpos($haystack, $needle, $diff) !== false;
	}

	public function callAccountBalanceAPI($AutoPaymentAccount,$CompanyConfiguration)
{
	try {
		$url = $CompanyConfiguration;
		Log::info("$AutoPaymentAccount .." . $AutoPaymentAccount->AccountID);
		$accountresponse = array();
		$topUpAmount = false;
		//$postdata = array(
		//	'AccountID'                => $AutoPaymentAccount->AccountID
		//);
		$postdata['AccountID'] = $AutoPaymentAccount->AccountID;
		$postdata = json_encode($postdata, true);
		if (!NeonAPI::endsWith($CompanyConfiguration, "/")) {
			$url = $CompanyConfiguration . "/";
		}
		//Log::info("Balance API URL" . $url);

		$APIresponse = NeonAPI::callAPI($postdata, "api/account/checkBalance", $url);

		if (isset($APIresponse["error"])) {

			return $topUpAmount = false;
			//echo "cURL Error #:" . $err;
		} else {
			$response = json_decode($APIresponse["response"]);
			//Log::info(print_r($APIresponse["response"], true));
			if (!empty($response->amount) && $response->amount >= $AutoPaymentAccount->MinThreshold) {
				$topUpAmount = true;
				return $topUpAmount;
			}


		}
	} catch (Exception $e) {
		Log::error("Balance API URL" . $e->getTraceAsString());
		return false;
	}
}

	public function calldepositFundAPI($AutoPaymentAccount,$CompanyConfiguration)
	{
		try{
		$url = $CompanyConfiguration;
		Log::info("$AutoPaymentAccount .." . $AutoPaymentAccount->AccountID);
		$accountresponse = array();
		$topUpAmount = false;
		$DepositAccount = array();
		//$postdata = array(
		//	'AccountID'                => $AutoPaymentAccount->AccountID,
		//	'Amount'                => $AutoPaymentAccount->TopupAmount
		//);

		$postdata['AccountID'] = $AutoPaymentAccount->AccountID;
		$postdata['Amount'] = $AutoPaymentAccount->TopupAmount;
		$postdata = json_encode($postdata,true);

		if (!NeonAPI::endsWith($CompanyConfiguration,"/")) {
			$url = $CompanyConfiguration . "/";
		}
		//Log::info("Balance API URL" . $url);
		$APIresponse = NeonAPI::callAPI($postdata,"api/account/depositFund",$url);


		if (isset($APIresponse["error"])) {
			//$accountresponse["error"] = $err;
			$topUpAmount = false;
			$response = json_decode($APIresponse["error"]);
			//Log::info(print_r($APIresponse["error"],true));
			$DepositAccount[0] = "error";
			$DepositAccount[1] = $response->ErrorMessage;
			//Log::info("error " . print_r($DepositAccount,true));
			//echo "cURL Error #:" . $err;
		} else {
			//$accountresponse["response"] = $response;
			$response = json_decode($APIresponse["response"]);
			//Log::info("Succcess" . print_r($response,true));
			$responseCode = $APIresponse["HTTP_CODE"];
			if ($responseCode == 200) {
				$DepositAccount[0] = "success";
				$DepositAccount[1] = $response;
			} else {
				$DepositAccount[0] = "failed";
				$DepositAccount[1] = $response;

			}
			//echo $response->data->amount;
		}

		return $DepositAccount;
		}catch (\Exception $e){
			Log::error("Balance API URL" . $e->getTraceAsString());
			return [];
		}
	}


}
