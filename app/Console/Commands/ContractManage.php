<?php namespace App\Console\Commands;

use App\Lib\Currency;
use App\Lib\EmailsTemplates;
use App\Lib\EmailTemplate;
use Illuminate\Console\Command;
use App\Lib\CronHelper;
use App\Lib\NeonAPI;
use App\Lib\Summary;
use App\Lib\RoutingProfileRate;
use App\Lib\CronJob;
use App\Lib\Account;
use App\Lib\Company;
use App\Lib\Notification;
use App\Lib\AccountEmailLog;
use App\Lib\Helper;
use App\Lib\CompanyConfiguration;
use App\Lib\CronJobLog;
use App\Lib\Retention;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use \Exception;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;

class ContractManage extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'contractmanage';

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
	public function handle()
	{
		//php artisan contractmanage 1 350
		//php artisan contractmanage 1 284
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
		$CancelContractResult = [];
		$RenewContractResult = [];
		$ExpireContractResult = [];

		Log::useFiles(storage_path() . '/logs/ContractManage-companyid-'.$CompanyID . '-cronjobid-'.$CronJobID.'-' . date('Y-m-d') . '.log');
		try {
			CronJob::createLog($CronJobID);

			$AccountServiceNumberAndPackage = "CALL prc_SetAccountServiceNumberAndPackage()";
			DB::select($AccountServiceNumberAndPackage);

			$CancelContractManage = "CALL prc_Cancel_Contract_Manage()";
			$selectCancelContract = DB::select($CancelContractManage);

			if(count($selectCancelContract) > 0){
				$ID = array();
				$InsertCancelHistory = array();
				foreach($selectCancelContract as $sel){

					array_push($ID,$sel->AccountServiceID);
					$InsertCancelHistory[] = [
						'Date' => date('Y-m-d H:i:s'),
						'Action' => 'Contract Cancel',
						'ActionBy' => $sel->UserName,
						'AccountServiceID' => $sel->AccountServiceID
					];

					DB::table('tblAccountServiceCancelContract')->where('AccountServiceID',$sel->AccountServiceID)->delete();

					$AccountNameGet = DB::table('tblAccount')->where('AccountID',$sel->AccountID)->first();
					$serviceName = DB::table('tblService')->where('ServiceID',$sel->ServiceID)->first();
					$CancelContract['AccountName'] = $AccountNameGet->AccountName;
					$CancelContract['CompanyId'] = $AccountNameGet->CompanyId;
					$CancelContract['ServiceTitle'] = $sel->ServiceTitle;
					$CancelContract['ServiceName'] = $serviceName->ServiceName;
					$CancelContractResult[count($CancelContractResult) + 1] = $CancelContract;
					var_dump($CancelContractResult);
				}

				Log::info('Contract Manage Account Service ID For Cancel Contract'. " " . print_r($ID,true));
				$data = array();
				$data['CancelContractStatus'] = 1;

				/** Update The Status Of Contract In Account Service Table */
				DB::table('tblAccountService')->whereIn('AccountServiceID',$ID)->update($data);
				/** Save History In History Table */
				DB::table('tblAccountServiceHistory')->insert($InsertCancelHistory);
				}
			/**Contract Renewal */
			$ContractRenewal = "CALL prc_Renewal_Contract()";
			$selectRenewalContract  = DB::select($ContractRenewal);

			if(count($selectRenewalContract) > 0){
				$Renewal = array();
				$InsertRenewalHistory = array();
				$RenewContract = array();
				$email = array();

				foreach($selectRenewalContract as $sel){
					$Renewal['ContractEndDate'] = date('y-m-d', strtotime($sel->ContractEndDate.' + '.$sel->Duration.'Months'));
					DB::table('tblAccountServiceContract')->where('AccountServiceID',$sel->AccountServiceID)->update($Renewal);
					$InsertRenewalHistory[] = [
						'Date' => date('Y-m-d H:i:s'),
						'Action' => 'Contract Renew',
						'ActionBy' => 'System',
						'AccountServiceID' => $sel->AccountServiceID

					];
					$serviceName = DB::table('tblService')->where('ServiceID',$sel->ServiceID)->first();
					$AccountNameGet = DB::table('tblAccount')->where('AccountID',$sel->AccountID)->first();
					$RenewContract['AccountName'] = $AccountNameGet->AccountName;
					$RenewContract['CompanyId'] = $AccountNameGet->CompanyId;
					$RenewContract['ServiceTitle'] = $sel->ServiceTitle;
					$RenewContract['ServiceName'] = $serviceName->ServiceName;
					$RenewContractResult[count($RenewContractResult) + 1] = $RenewContract;

					$account = DB::table('tblAccount')->where('AccountID',$sel->AccountID)->first();

					$email['AccountID'] = $account->AccountID;
					$email['CompanyID'] = $account->CompanyId;
					$email['ServiceTitle'] = $sel->ServiceTitle;
					$email['ServiceName'] = $serviceName->ServiceName;
					$email['ContractStartDate'] = $sel->ContractStartDate;
					$email['ContractEndDate'] = $sel->ContractEndDate;
					var_dump($email);
					$this->ContractManageCustomerEmail($email);
				}


				DB::table('tblAccountServiceHistory')->insert($InsertRenewalHistory);

				Log::info('Contract Manage Account Service ID For Renewal Contract'. " " . print_r($Renewal,true));
			}
			$Alerts = DB::table('tblAlert')->where('AlertType', 'Contract_Reminder')->where('status', 1)->get();
			foreach ($Alerts as $Alert) {
				$Settings = json_decode($Alert->Settings);
				//dd($Settings->ContractAlertDays);
				if ($Settings->AccountIDs == -1) {
					$ContractExpire = "CALL prc_getExpireForAdmin(0   , $Settings->ContractAlertDays )";
				} else {
					$ContractExpire = "CALL prc_getExpireForAdmin($Settings->AccountIDs  , $Settings->ContractAlertDays)";
				}
				$selectExpireContract = DB::select($ContractExpire);
//				var_dump($selectExpireContract);
//				var_dump($Settings);
//				die;
				if (count($selectExpireContract) > 0) {
					$ExpireContract = array();
					foreach ($selectExpireContract as $sel) {

						$AccountNameGet = DB::table('tblAccount')->where('AccountID', $sel->AccountID)->first();
						$serviceNames = DB::table('tblService')->where('ServiceID', $sel->ServiceID)->first();
						$ExpireContract['AccountName'] = $AccountNameGet->AccountName;
						$ExpireContract['CompanyId'] = $AccountNameGet->CompanyId;
						$ExpireContract['AccountID'] = $sel->AccountID;
						$ExpireContract['ServiceTitle'] = $sel->ServiceTitle;
						$ExpireContract['serviceNames'] = $serviceNames->ServiceName;
						$ExpireContract['ContractEndDate'] = $sel->ContractEndDate;
						$ExpireContractResult[count($ExpireContractResult) + 1] = $ExpireContract;


					}
					$this::ContractExpireEmailReminder($CompanyID, $ExpireContractResult, $Settings);
					$ExpireContractResult = [];
				}
				if ($Settings->EmailToAccount == 1) {
					$emailCustomerdata = [];
					if ($Settings->AccountIDs == -1) {
						$CustomerExpireContract = "CALL prc_getExpireContract( '0'   , $Settings->ContractAlertDays)";
					} else {
						$CustomerExpireContract = "CALL prc_getExpireContract($Settings->AccountIDs  , $Settings->ContractAlertDays)";
					}

					$selectCustomerExpireContract = DB::select($CustomerExpireContract);

					if (count($selectCustomerExpireContract) > 0) {
						foreach ($selectCustomerExpireContract as $sel) {
							var_dump($sel);
							$CustomerExpireContractByID = "CALL prc_getExpireContract( $sel->AccountID , $Settings->ContractAlertDays)";
							$selectCustomerExpireContractByID = DB::select($CustomerExpireContractByID);
							$emailCustomerdata['AccountID'] = $sel->AccountID;
							$emailCustomerdata['CompanyID'] = Account::getCompanyID($sel->AccountID);
							$emailCustomerdata['Services'] = "<table width='100%' border='1' cellpadding='0' cellspacing='0' style='border:1px solid #ccc;'>";
							$emailCustomerdata['Services'] .= "<tr>";
							$emailCustomerdata['Services'] .= "<th>Account</th>";
							$emailCustomerdata['Services'] .= "<th>Service Title</th>";
							$emailCustomerdata['Services'] .= "<th>Service Name</th>";
							$emailCustomerdata['Services'] .= "<th>Contract End Date</th>";
							$emailCustomerdata['Services'] .= "</tr>";

							foreach ($selectCustomerExpireContractByID as $selContract) {
								$serviceNames = DB::table('tblService')->where('ServiceID', $selContract->ServiceID)->first();
								$emailCustomerdata['Services'] .= "<tr>";
								$emailCustomerdata['Services'] .= "<td>" . $selContract->AccountID . "</td>";
								$emailCustomerdata['Services'] .= "<td>" . $selContract->ServiceTitle . "</td>";
								$emailCustomerdata['Services'] .= "<td>" . $serviceNames->ServiceName . "</td>";
								$emailCustomerdata['Services'] .= "<td>" . $selContract->ContractEndDate . "</td>";
								$emailCustomerdata['Services'] .= "</tr>";
							}
							$emailCustomerdata['Services'] .= "</table>";
							$emailCustomerdata['Days'] = $Settings->ContractAlertDays;
							$emailCustomerdata['AlertID'] = $Alert->AlertID;
							$emailCustomerdata['ServiceTitle'] = $selContract->ServiceTitle;
							$emailCustomerdata['ContractStartDate'] = $selContract->ContractStartDate;
							$emailCustomerdata['ContractEndDate'] = $selContract->ContractEndDate;

							$this->ContractExpireCustomerEmail($emailCustomerdata);
						}
					}
				}

				}
				if (!empty($CancelContractResult) || !empty($RenewContractResult)) {
					$this::ContractManageNotification($CancelContractResult, $RenewContractResult, $CompanyID);
				}
			$joblogdata['CronJobID'] = $CronJobID;
			$joblogdata['created_at'] = Date('y-m-d');
			$joblogdata['created_by'] = 'RMScheduler';
			$joblogdata['Message'] = 'Contract Manage Successfully Done';
			$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
			CronJobLog::insert($joblogdata);

			CronJob::deactivateCronJob($CronJob);
			CronHelper::after_cronrun($this->name, $this);
			$result = CronJob::CronJobSuccessEmailSend($CronJobID);
		}
		catch(Exception $ex){
			Log::useFiles(storage_path() . '/logs/ContractManage-Error-' . date('Y-m-d') . '.log');
			//Log::info('LCRRoutingEngine Error.');
			Log::useFiles(storage_path() . '/logs/ContractManage-Error-' . date('Y-m-d') . '.log');

			Log::error($ex);
			//$this->info('Failed:' . $ex->getMessage());
			$joblogdata['CronJobID'] = $CronJobID;
			$joblogdata['created_at'] = Date('y-m-d');
			$joblogdata['created_by'] = 'RMScheduler';
			$joblogdata['Message'] ='Error:'.$ex->getMessage();
			$joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
			CronJobLog::insert($joblogdata);
			CronJob::deactivateCronJob($CronJob);
			CronHelper::after_cronrun($this->name, $this);
			if(!empty($cronsetting['ErrorEmail'])) {


				$result = CronJob::CronJobErrorEmailSend($CronJobID,$ex);
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
	public static function ContractManageNotification($CancelContract,$RenewContract,$CompanyID)
	{
		try {
			Log::info("ContractManageNotification ");
			$emaildata = array();

			$ComanyName = Company::getName($CompanyID);

			$emaildata['CancelContract'] = $CancelContract;
			$emaildata['RenewContract'] = $RenewContract;

			$ContractManageEmail = Notification::getNotificationMail(['CompanyID' => $CompanyID, 'NotificationType' => Notification::ContractManage]);
			Log::info("$ContractManageEmail .." . $ContractManageEmail);

			$emaildata['CompanyID'] = $CompanyID;
			$emaildata['CompanyName'] = $ComanyName;
			$emaildata['EmailTo'] = $ContractManageEmail;
			$emaildata['EmailToName'] = '';
			$emaildata['Subject'] = 'Contract Manage Email';
			Log::info("ContractManage CancelContract count" . count($emaildata['CancelContract']));
			Log::info("ContractManage RenewContract count" . count($emaildata['RenewContract']));

			$result = Helper::sendMail('emails.contract_manage', $emaildata);
			return $result;
		} catch (Exception $ex) {

			Log::error($ex);
		}
	}

	public function ContractManageCustomerEmail($email){
		$CompanyID = $email['CompanyID'];
		$status = EmailsTemplates::CheckEmailTemplateStatus(Account::ContractManageEmailTemplate,$CompanyID);
		if($status != false) {
			$Account = Account::find($email['AccountID']);
			$CompanyName = Company::getName($CompanyID);
			$emaildata = array(
				'CompanyName' => $CompanyName,
				'CompanyID' => $CompanyID,
				'ServiceTitle' => $email['ServiceTitle'],
				'ServiceName' => $email['ServiceName'],
				'ContractStartDate' => $email['ContractStartDate'],
				'ContractEndDate' => $email['ContractEndDate']
			);

			$emaildata['EmailToName'] = $Account->AccountName;
			$body = EmailsTemplates::setContractManagePlaceholder($Account, 'body', $CompanyID, $emaildata);
			$emaildata['Subject'] = EmailsTemplates::setContractManagePlaceholder($Account, "subject", $CompanyID, $emaildata);
			if (!isset($emaildata['EmailFrom'])) {
				$emaildata['EmailFrom'] = EmailsTemplates::GetEmailTemplateFrom(Account::ContractManageEmailTemplate,$CompanyID);
			}

			$CustomerEmail = $Account->BillingEmail;
			if($CustomerEmail != '') {
				$CustomerEmail = explode(",", $CustomerEmail);
				$customeremail_status['status'] = 0;
				$customeremail_status['message'] = '';
				$customeremail_status['body'] = '';
				foreach ($CustomerEmail as $singleemail) {
					$singleemail = trim($singleemail);
					if (filter_var($singleemail, FILTER_VALIDATE_EMAIL)) {
						$emaildata['EmailTo'][] = $singleemail;
					}
				}
				Log::info("============ EmailData ===========");
				Log::info($emaildata);
				$customeremail_status = Helper::sendMaiL($body, $emaildata, 0);

				$EmailLog = DB::table('AccountEmailLog')->where('AccountID', $email['AccountID'])->whereRaw('Date(created_at) = CURDATE()')->where('EmailTo', $Account->BillingEmail)->where('EmailType',AccountEmailLog::ContractManage)->get();
				if (!count($EmailLog) > 0){

						$logdata = array(
							'CompanyID' => $CompanyID,
							'AccountID' => $email['AccountID'],
							'CreatedBy' => 'System Notification',
							'created_at' => date('Y-m-d H:i:s'),
							'EmailTo' => $Account->BillingEmail,
							'Message' => $body,
							'EmailType' => AccountEmailLog::ContractManage,
							'Subject' => 'Customer Contract Renewal'
						);
						AccountEmailLog::insert($logdata);
					}
				}
			}
		}
		//var_dump($email);


	public static function ContractExpireEmailReminder($CompanyID,$ExpireContractResult,$Settings)
	{

		$Company = Company::find($CompanyID);
		$TodayDate = date_create(date('Y-m-d'));
		$emailsTo = $Settings->ReminderEmail;
		$emaildata = array(
			'EmailToName' => $Company->CompanyName,
			'ExpireContracts' => $ExpireContractResult,
			'EmailTo' => $emailsTo,
			'CompanyID' => $CompanyID,
			'CompanyName' => $Company->CompanyName,
			'Subject' => 'Contract Expire Email'
		);
		$emailstatus = Helper::sendMail('emails.ContractExpire', $emaildata);

	}
	public function ContractExpireCustomerEmail($email){
		$CompanyID = $email['CompanyID'];
		$status = EmailsTemplates::CheckEmailTemplateStatus(Account::ContractExpireEmailTemplate,$CompanyID);
		if($status != false) {
			$Account = Account::find($email['AccountID']);
			$CompanyName = Company::getName($CompanyID);
			$emaildata = array(
				'CompanyName' => $CompanyName,
				'CompanyID' => $CompanyID,
				'Services' => $email['Services'],
				'Days' =>  $email['Days'],
				'ServiceTitle' => $email['ServiceTitle'],
				'ContractStartDate' => $email['ContractStartDate'],
				'ContractEndDate' => $email['ContractEndDate'],

			);
			$emaildata['EmailToName'] = $Account->AccountName;
			$body = EmailsTemplates::setContractExpirePlaceholder($Account, 'body', $CompanyID, $emaildata);
			$emaildata['Subject'] = EmailsTemplates::setContractExpirePlaceholder($Account, "subject", $CompanyID, $emaildata);
			if (!isset($emaildata['EmailFrom'])) {
				$emaildata['EmailFrom'] = EmailsTemplates::GetEmailTemplateFrom(Account::ContractExpireEmailTemplate,$CompanyID);
			}

			$CustomerEmail = $Account->BillingEmail;

			if($CustomerEmail != '') {
				$CustomerEmail = explode(",", $CustomerEmail);
				$customeremail_status['status'] = 0;
				$customeremail_status['message'] = '';
				$customeremail_status['body'] = '';
				foreach ($CustomerEmail as $singleemail) {
					$singleemail = trim($singleemail);
					if (filter_var($singleemail, FILTER_VALIDATE_EMAIL)) {
						$emaildata['EmailTo'][] = $singleemail;
					}
				}
				Log::info("============ EmailData ===========");
				Log::info($emaildata);
				$EmailLog = DB::table('AccountEmailLog')
					->where('AccountID', $email['AccountID'])
					->whereRaw('Date(created_at) = CURDATE()')
					->where('EmailTo', $Account->BillingEmail)
					->where('EmailType',AccountEmailLog::ContractExpire)
					->where('MonitoringID',$email['AlertID'])
					->get();
				if (!count($EmailLog) > 0){
					$customeremail_status = Helper::sendMaiL($body, $emaildata, 0);
					if ($customeremail_status) {

						$logdata = array(
							'CompanyID' => $CompanyID,
							'AccountID' => $email['AccountID'],
							'CreatedBy' => 'System Notification',
							'created_at' => date('Y-m-d H:i:s'),
							'EmailTo' => $Account->BillingEmail,
							'Message' => $body,
							'EmailType' => AccountEmailLog::ContractExpire,
							'Subject' => 'Customer Contract Expire',
							'MonitoringID' => $email['AlertID']
						);
						$emailLogId = AccountEmailLog::insert($logdata);
					}
				}
			}
		}
	}

	protected function getArguments()
	{
		return [
			['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID '],
			['CronJobID', InputArgument::REQUIRED, 'Argument CronJobID'],
		];
	}

	/**
	 * Get the console command options.
	 *
	 * @return array
	 */


}
