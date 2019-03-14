<?php namespace App\Console\Commands;

use App\Lib\Account;
use App\Lib\AccountBalance;
use App\Lib\ApprovedOutPaymentLog;
use App\Lib\CLIRateTable;
use App\Lib\Company;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Currency;
use App\Lib\EmailsTemplates;
use App\Lib\Helper;
use App\Lib\Invoice;
use App\Lib\Notification;
use App\Lib\OutPaymentLog;
use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Symfony\Component\Console\Input\InputArgument;
use Illuminate\Support\Facades\Log;

class ApproveOutPayment extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'ApproveOutPayment';

	/**
	 * The console command description.
	 *
	 * @var string
	 */
	protected $description = 'ApproveOutPayment Command description.';

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
		$SuccessOutPayment = array();
		$FailureOutPayment = array();
		CronHelper::before_cronrun($this->name, $this);
		$arguments = $this->argument();
		$CompanyID = $arguments["CompanyID"];
		$CronJobID = $arguments["CronJobID"];
		$CronJob =  CronJob::find($CronJobID);
		if($CronJob != false) {
			$cronsetting = json_decode($CronJob->Settings, true);
			CronJob::activateCronJob($CronJob);
			CronJob::createLog($CronJobID);
		} else {
			$this->info('Failed: Cron job does not exist.');
			exit();
		}

		Log::useFiles(storage_path() . '/logs/ApproveOutPayment-companyid-'.$CompanyID . '-cronjobid-'.$CronJobID.'-' . date('Y-m-d') . '.log');

		try {
			// Start Date
			$dt = Carbon::now()->subMonths(2)->toDateString();
			if(!empty(@$cronsetting['StartIssueDate']) && self::validateDate($cronsetting['StartIssueDate']))
				$dt = Carbon::createFromFormat('Y-m-d', $cronsetting['StartIssueDate'])->toDateString();

			// Vendor Invoices
			$query = Invoice::Join('tblInvoiceDetail','tblInvoice.InvoiceID','=','tblInvoiceDetail.InvoiceID')->select(['tblInvoice.InvoiceID','tblInvoiceDetail.StartDate','tblInvoiceDetail.EndDate','tblInvoice.AccountID'])->distinct('tblInvoice.InvoiceID')->where([
				'tblInvoice.CompanyID'   => $CompanyID,
				'tblInvoice.InvoiceType' => Invoice::INVOICE_IN
			])->whereDate('tblInvoice.IssueDate', ">=", $dt)
				->orderBy("tblInvoice.AccountID", "DESC");

			Log::info('Vendor Invoice Query.' . $query->toSql());
			$VendorInvoice = $query->get();

			$allApprovedPayments = [];
			//Fetching vendor invoice one by one
			foreach($VendorInvoice as $invoice) {
				if(!empty($invoice->StartDate) && !empty($invoice->EndDate)) {

					// Vendor CLIs
					$CLIs = CLIRateTable::where([
						'AccountID' => $invoice->AccountID,
						'Status' => 1
					])->lists('CLI');

					Log::info('CLIs.' . print_r($CLIs, true));
					if (!empty($CLIs)) {
						// OUT Payments Where Vendor, Status 0, Date in invoice dates, In CLIs
						$outPayment = OutPaymentLog::where([
							'VendorID' => $invoice->AccountID,
							'Status' => 0,
						])->whereIn('CLI', $CLIs)
							->whereDate('Date', ">=", $invoice->StartDate)
							->whereDate('Date', "<=", $invoice->EndDate)
							->get();

						// Accumulating Amount By Account ID
						$payable = [];
						if($outPayment != false)
							foreach ($outPayment as $op) {
								$accID = $op->AccountID;
								$payable[$accID]['Amount'] = isset($payable[$accID]['Amount']) ? $payable[$accID]['Amount'] + (float)$op->Amount : (float)$op->Amount;

								if(!isset($payable[$accID]['CLI']))
									$payable[$accID]['CLI'] = [];

								if(!in_array($op->CLI, $payable[$accID]['CLI']))
									$payable[$accID]['CLI'][] = $op->CLI;
							}

						Log::info('payable .' . print_r($payable, true));
						DB::beginTransaction();
						$approvedPaymentAccounts = [];
						$approvedPaymentArray = [];
						foreach($payable as $AID => $item){
							$Account = AccountBalance::where('AccountID', $AID)->first();
							if($Account->OutPaymentAwaiting >= $item['Amount']){
								$approvedPaymentAccounts[] = $AID;
								$approvalAmount = $Account->OutPaymentAwaiting - $item['Amount'];
								$approvedAmount = $Account->OutPaymentAvailable != NULL ? $Account->OutPaymentAvailable + $item['Amount'] : $item['Amount'];

								AccountBalance::where('AccountID', $AID)->update([
									'OutPaymentAwaiting' => $approvalAmount,
									'OutPaymentAvailable' => $approvedAmount
								]);

								$approvedPaymentArray[] = [
									'AccountID' => $AID,
									'VendorID' 	=> $invoice->AccountID,
									'InvoiceID' => $invoice->InvoiceID,
									'StartDate' => $invoice->StartDate,
									'EndDate' 	=> $invoice->EndDate,
									'Amount'   	=> $item['Amount'],
								];

								$SuccessOutPayment[] = [
									'AccountName' => $Account->AccountName,
									'AccountID'   => $AID,
									'VendorID' 	  => $invoice->AccountID,
									'InvoiceID'   => $invoice->InvoiceID,
									'StartDate'   => $invoice->StartDate,
									'EndDate' 	  => $invoice->EndDate,
									'Amount'   	  => $item['Amount'],
								];

							} else {
								$FailureOutPayment[] = [
									'AccountName' => $Account->AccountName,
									'AccountID'   => $AID,
									'VendorID' 	  => $invoice->AccountID,
									'InvoiceID'   => $invoice->InvoiceID,
									'StartDate'   => $invoice->StartDate,
									'EndDate'     => $invoice->EndDate,
									'Amount'      => $item['Amount'],
								];
							}
						}

						Log::info('approved .' . print_r($approvedPaymentArray, true));
						Log::info('Approved Accounts .' . print_r($approvedPaymentAccounts, true));
						if(!empty($approvedPaymentAccounts))
							OutPaymentLog::where([
								'VendorID' => $invoice->AccountID,
								'Status' => 0,
							])->whereIn('CLI', $CLIs)
								->whereDate('Date', ">=", $invoice->StartDate)
								->whereDate('Date', "<=", $invoice->EndDate)
								->whereIn('AccountID', $approvedPaymentAccounts)
								->update(['status' => 1]);

						if(!empty($approvedPaymentArray)) {
							ApprovedOutPaymentLog::insert($approvedPaymentArray);
							$allApprovedPayments = array_merge($approvedPaymentArray, $allApprovedPayments);
						}

						DB::commit();
					}
				}
			}


			Log::info("All Approved ". print_r($allApprovedPayments, true));

			if(!empty($allApprovedPayments))
				foreach($allApprovedPayments as $approved)
					self::approvedOutPaymentCustomerEmail($approved, $CompanyID);

			if (count($allApprovedPayments) > 0) {
				$this::ApproveOutPaymentNotification($CompanyID, $SuccessOutPayment, $FailureOutPayment);
			}

			CronJob::CronJobSuccessEmailSend($CronJobID);
			CronJob::deactivateCronJob($CronJob);
			CronHelper::after_cronrun($this->name, $this);
			echo "DONE With ApproveOutPayment";
		} catch (\Exception $e) {
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

	public static function validateDate($date, $format = 'Y-m-d')
	{
		$d = Carbon::createFromFormat($format,$date);
		return $d && $d->format($format) === $date;
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


	public static function approvedOutPaymentCustomerEmail($data, $CompanyID){

		$status = EmailsTemplates::CheckEmailTemplateStatus(Account::ApproveOutPaymentEmailTemplate, $CompanyID);
		if($status != false) {
			$Account = Account::find($data['AccountID']);
			$CompanyName = Company::getName($CompanyID);
			$Currency = Currency::find($Account->CurrencyId);
			$CurrencyCode = !empty($Currency) ? $Currency->Code : '';
			$emaildata = array(
				'CompanyName' => $CompanyName,
				'Currency' => $CurrencyCode,
				'CompanyID' => $CompanyID,
				'OutPaymentAmount' => $data['Amount'],
			);

			$emaildata['EmailToName'] = $Account->AccountName;
			$body = EmailsTemplates::setOutPaymentPlaceholder($Account, 'body', $CompanyID, $emaildata);
			$emaildata['Subject'] = EmailsTemplates::setOutPaymentPlaceholder($Account, "subject", $CompanyID, $emaildata);
			if (!isset($emaildata['EmailFrom'])) {
				$emaildata['EmailFrom'] = EmailsTemplates::GetEmailTemplateFrom(Account::ApproveOutPaymentEmailTemplate, $CompanyID);
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
				Helper::sendMaiL($body, $emaildata, 0);
			}
		}
	}


	/**
	 * @param $CompanyID
	 * @param $SuccessOutPayment
	 * @param $FailureOutPayment
	 * @return array|bool
	 */
	public static function ApproveOutPaymentNotification($CompanyID,$SuccessOutPayment,$FailureOutPayment){

		$emaildata = array();
		$CompanyName = Company::getName($CompanyID);

		$emaildata['SuccessOutPayment'] = $SuccessOutPayment;
		$emaildata['FailureOutPayment'] = $FailureOutPayment;

		$ApproveOutPaymentNotificationEmail = Notification::getNotificationMail(['CompanyID' => $CompanyID, 'NotificationType' => Notification::ApproveOutPayment]);
		Log::info("$ApproveOutPaymentNotificationEmail .." . $ApproveOutPaymentNotificationEmail);

		$result = false;
		if($ApproveOutPaymentNotificationEmail != '') {
			$emaildata['CompanyID']   = $CompanyID;
			$emaildata['CompanyName'] = $CompanyName;
			$emaildata['EmailTo'] 	  = $ApproveOutPaymentNotificationEmail;
			$emaildata['EmailToName'] = '';
			$emaildata['Subject'] 	  = 'Approve Out Payment Notification Email';
			//$emaildata['Message'] = $Message;
			Log::info("ApproveOutPaymentNotificationEmail Success: " . count($emaildata['SuccessOutPayment']));
			Log::info("ApproveOutPaymentNotificationEmail Failure: " . count($emaildata['FailureOutPayment']));
			$result = Helper::sendMail('emails.approve_out_payment', $emaildata);
		}
		return $result;
	}

}
