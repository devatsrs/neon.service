<?php namespace App\Console\Commands;




use App\Lib\CronHelper;
use App\Lib\Summary;
use App\Lib\RoutingProfileRate;
use Illuminate\Console\Command;
use App\Lib\CronJob;
use App\Lib\Account;
use App\Lib\Company;
use App\Lib\Notification;
use App\Lib\Helper;
use App\Lib\CompanyConfiguration;
use App\Lib\CronJobLog;
use App\Lib\Retention;
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
	protected $name = 'AutoTopAccount';

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
		$ErrorDepositFund = array();
        $arguments = $this->argument();
        $CompanyID = $arguments["CompanyID"];
        $CronJobID = $arguments["CronJobID"];
        
        $CronJob =  CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);
        CronJob::activateCronJob($CronJob);
        CronJob::createLog($CronJobID);
        
        //print_r($cronsetting);die();
        Log::useFiles(storage_path() . '/logs/AutoTopAccount-companyid-'.$CompanyID . '-cronjobid:'.$CronJobID.'-' . date('Y-m-d') . '.log');
		try{

			$AutoPaymentAccountList = Account::
			Join('tblAccountPaymentAutomation','tblAccount.AccountID','=','tblAccountPaymentAutomation.AccountID')
				->select(['AccountName','tblAccount.AccountID','MinThreshold','TopupAmount'])
				->where('tblAccountPaymentAutomation.AutoTopup','=', 1)
				->orderBy("tblAccountPaymentAutomation.AccountID", "ASC");
			Log::info('$rate table query.' . $AutoPaymentAccountList->toSql());
			$AutoPaymentAccountList = $AutoPaymentAccountList->get();
			Log::info('DONE With AutoTopAccount.' . count($AutoPaymentAccountList));
			$CompanyConfiguration = CompanyConfiguration::where(['CompanyID' => $CompanyID, 'Key' => 'WEB_URL'])->pluck('Value');
			Log::info('$CompanyConfiguration .' . $CompanyConfiguration);
			foreach($AutoPaymentAccountList as  $AutoPaymentAccount) {
				if ($this::callAccountBalanceAPI($AutoPaymentAccount,$CompanyConfiguration)) {
					Log::info('Call the deposit API .');
					$DepositAccount = $this::calldepositFundAPI($AutoPaymentAccount,$CompanyConfiguration);
					Log::info('Call the deposit API $DepositAccount.' . print_r($DepositAccount,true));
					Log::info('Call the deposit API $DepositAccount.' . $DepositAccount[0]);
					if ($DepositAccount[0] == "success") {
						$successRecord = array();
						$successRecord["AccountID"] = $AutoPaymentAccount->AccountID;
						$successRecord["AccountName"] = $AutoPaymentAccount->AccountName;
						$successRecord["Amount"] = $AutoPaymentAccount->TopupAmount;
						$SuccessDepositAccount[count($SuccessDepositAccount) + 1] = $successRecord;
						Log::info('Call the deposit API $DepositAccount success.' . count($SuccessDepositAccount));
					}else if ($DepositAccount[0] == "failed") {
						$failedRecord = array();
						$failedRecord["AccountID"] = $AutoPaymentAccount->AccountID;
						$failedRecord["AccountName"] = $AutoPaymentAccount->AccountName;
						$failedRecord["Response"] = $DepositAccount[1];
						$FailureDepositFund[count($FailureDepositFund) + 1] = $failedRecord;
						Log::info('Call the deposit API $DepositAccount failed.' . count($FailureDepositFund));
					}else if ($DepositAccount[0] == "error") {
						$errorRecord = array();
						$errorRecord["AccountID"] = $AutoPaymentAccount->AccountID;
						$errorRecord["AccountName"] = $AutoPaymentAccount->AccountName;
						$errorRecord["Response"] = $DepositAccount[1];
						$ErrorDepositFund[count($ErrorDepositFund) + 1] = $errorRecord;
					}
				}

			}

			if (count($AutoPaymentAccountList) > 0) {
				$this::AutoTopUpNotification($CompanyID, $SuccessDepositAccount, $FailureDepositFund, $ErrorDepositFund);
			}else {
				Log::info('No Account IDs found for the auto top up.');
			}
            echo "DONE With AutoTopAccount";

			CronJob::CronJobSuccessEmailSend($CronJobID);
			//Log::info('routingList:Get the routing list user company.' . $CompanyID);
            Log::info('Run Cron.');
        }catch (\Exception $e){
            Log::useFiles(storage_path() . '/logs/AutoTopAccount-Error-' . date('Y-m-d') . '.log');
            //Log::info('LCRRoutingEngine Error.');
            Log::useFiles(storage_path() . '/logs/AutoTopAccount-Error-' . date('Y-m-d') . '.log');
            
            Log::error($e);
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
    }

	public static function AutoTopUpNotification($CompanyID,$SuccessDepositAccounts,$FailureDepositFundAccounts,$ErrorDepositFundAccounts){

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
		Log::info("AutoTopUpNotificationEmail 1" . count($emaildata['SuccessDepositAccount']));
		Log::info("AutoTopUpNotificationEmail 2" . count($emaildata['FailureDepositFund']));
		Log::info("AutoTopUpNotificationEmail 3" . count($emaildata['ErrorDepositFund']));
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
		Log::info("$AutoPaymentAccount .." . $AutoPaymentAccount->AccountID);
		$accountresponse = array();
		$topUpAmount = false;
		//https://appcenter.intuit.com/Playground/OAuth/AccessGranted?ia=true&oauth_token=lvprdco5CjnH7fx5z6P9RRHFm9AUrRHhhoH3UdCwjoGRrLEv&oauth_verifier=0hzsvq6&realmId=193514449127769&dataSource=QBO
		//$query = 'query?query='.urlencode('Select * from Customer');
		//$query = 'account/1';

		if ($this::endsWith($CompanyConfiguration,"/")) {
			$url = $CompanyConfiguration . "api/checkBalance";
		}else {
			$url = $CompanyConfiguration . "/api/checkBalance";
		}
		Log::info("Check Balacnce URL :" . $url);
		$curl = curl_init();

		$postdata = array(
			'AccountID'                => $AutoPaymentAccount->AccountID
		);

		$auth = base64_encode(getenv("NEON_USER_NAME") . ':' . getenv("NEON_USER_PASSWORD"));
		curl_setopt_array($curl, array(
			CURLOPT_URL => $url,
			CURLOPT_RETURNTRANSFER => true,
			CURLOPT_ENCODING => "",
			CURLOPT_MAXREDIRS => 10,
			CURLOPT_TIMEOUT => 30,
			CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
			CURLOPT_CUSTOMREQUEST => "POST",
			CURLOPT_POSTFIELDS => http_build_query($postdata, '', '&'),
			CURLOPT_HTTPHEADER => array(
				"accept: application/json",
				"authorization: Basic " . $auth,
			),
		));

		$response = curl_exec($curl);
		$err = curl_error($curl);

		curl_close($curl);

		if ($err) {
			$accountresponse["error"] = $err;
			$topUpAmount = false;
			Log::info(print_r($accountresponse,true));
			//echo "cURL Error #:" . $err;
		} else {
			//$accountresponse["response"] = $response;
			$response = json_decode($response);
			Log::info(print_r($response,true));
			if ($response->status == "success" &&
				$response->data->amount > $AutoPaymentAccount->MinThreshold) {
				$topUpAmount = true;
				return $topUpAmount;
			}
			//echo $response->data->amount;
		}
	}

	public function calldepositFundAPI($AutoPaymentAccount,$CompanyConfiguration)
	{
		Log::info("$AutoPaymentAccount .." . $AutoPaymentAccount->AccountID);
		$accountresponse = array();
		$topUpAmount = false;
		$DepositAccount = array();
		//https://appcenter.intuit.com/Playground/OAuth/AccessGranted?ia=true&oauth_token=lvprdco5CjnH7fx5z6P9RRHFm9AUrRHhhoH3UdCwjoGRrLEv&oauth_verifier=0hzsvq6&realmId=193514449127769&dataSource=QBO
		//$query = 'query?query='.urlencode('Select * from Customer');
		//$query = 'account/1';


		$url = $CompanyConfiguration . "api/depositFund";
		Log::info("calldepositFundAPI :" . $url);
		$curl = curl_init();

		$postdata = array(
			'AccountID'                => $AutoPaymentAccount->AccountID,
			'Amount'                => $AutoPaymentAccount->TopupAmount
		);

		$auth = base64_encode(getenv("NEON_USER_NAME") . ':' . getenv("NEON_USER_PASSWORD"));
		curl_setopt_array($curl, array(
			CURLOPT_URL => $url,
			CURLOPT_RETURNTRANSFER => true,
			CURLOPT_ENCODING => "",
			CURLOPT_MAXREDIRS => 10,
			CURLOPT_TIMEOUT => 30,
			CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
			CURLOPT_CUSTOMREQUEST => "POST",
			CURLOPT_POSTFIELDS => http_build_query($postdata, '', '&'),
			CURLOPT_HTTPHEADER => array(
				"accept: application/json",
				"authorization: Basic " . $auth,
			),
		));

		$response = curl_exec($curl);
		$err = curl_error($curl);

		curl_close($curl);

		if ($err) {
			$accountresponse["error"] = $err;
			$topUpAmount = false;
			Log::info(print_r($accountresponse,true));
			$DepositAccount[0] = "error";
			$DepositAccount[1] = $err;

			//echo "cURL Error #:" . $err;
		} else {
			//$accountresponse["response"] = $response;
			$response = json_decode($response);
			Log::info(print_r($response,true));
			if ($response->status == "success") {
				$DepositAccount[0] = "success";
				$DepositAccount[1] = $response;
			} else {
				$DepositAccount[0] = "failed";
				$DepositAccount[1] = $response;

			}
			//echo $response->data->amount;
		}

		return $DepositAccount;
	}
}
