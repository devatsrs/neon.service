<?php namespace App\Console\Commands;

use App\Lib\Account;
use App\Lib\CompanyConfiguration;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\EmailClient;
use App\Lib\Exact;
use App\Lib\ExactAuthentication;
use App\Lib\ExactInvoiceLog;
use App\Lib\Invoice;
use App\Lib\Payment;
use App\Lib\Product;
use App\Lib\RateTable;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use League\Flysystem\Exception;
use Symfony\Component\Console\Input\InputArgument;
use Webklex\IMAP\Facades\Client;
use Webpatser\Uuid\Uuid;

class ExactPaymentImport extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'exactpaymentimport';

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
	public function handle()
	{
		CronHelper::before_cronrun($this->name, $this);
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

		Log::useFiles(storage_path() . '/logs/exactpaymentimport-'. date('Y-m-d').'.log');
		Log::info(' ========================== import exact invoice payment start =============================');

		$countInvoicePaymentImported= 0;
		$joblogdata 				= array();
		$joblogdata['CronJobID'] 	= $CronJobID;
		$joblogdata['created_at'] 	= date('Y-m-d H:i:s');
		$joblogdata['created_by'] 	= 'RMScheduler';
		$error = $success = [];
		try {
			CronJob::createLog($CronJobID);
			$exact = new Exact($CompanyID);

			$PendingPaymentInvoices_q = "CALL prc_getExactPendingInvoicePayment()";

			$PendingPaymentInvoices = DB::connection('sqlsrv2')->select($PendingPaymentInvoices_q);

			$PendingInvoicesExact = $PendingInvoicesNeon = [];
			foreach ($PendingPaymentInvoices as $PendingPaymentInvoice) {
				$PendingInvoicesNeon[] = $PendingPaymentInvoice->InvoiceNumber;
				$Account = $exact->getAccount($PendingPaymentInvoice->Number);

				if (!isset($Account['faultString']) && !empty($Account[0]['ID'])) {
					$ReceivableList = $exact->getReceivablesListByAccount($Account[0]['ID']);

					if (!isset($ReceivableList['faultString']) && count($ReceivableList) > 0) {
						foreach ($ReceivableList as $key => $value) {
							$PendingInvoicesExact[] = $value['YourRef'];
						}
					} else { // need to change this
						if (empty($ReceivableList['nodata'])) {
							$error[] = "Account " . $PendingPaymentInvoice->AccountName . "(" . $PendingPaymentInvoice->Number . ") has Error: <br/>" . $ReceivableList['faultString'];
						}
					}
				} else {
					if (!empty($Account['nodata'])) { // if account not found
						$error[] = "Account " . $PendingPaymentInvoice->AccountName . "(" . $PendingPaymentInvoice->Number . ") not exist in Exact.";
					} else { // if error
						$error[] = "Account " . $PendingPaymentInvoice->AccountName . "(" . $PendingPaymentInvoice->Number . ") has Error: <br/>" . $Account['faultString'];
					}
				}
			}

			// $PendingInvoicesExact will have only invoices which are not paid in Exact
			// $PendingInvoicesNeon will have all invoices which have pending payment in Neon
			// So, we will find out which invoices need to mark paid based on which invoices are pending in Exact
			$ToBePaidInvoices = array_diff($PendingInvoicesNeon,$PendingInvoicesExact); // will return all invoice which is in $PendingInvoicesNeon but not in $PendingInvoicesExact

			DB::connection('sqlsrv2')->beginTransaction();

			foreach ($ToBePaidInvoices as $key => $value) {
				$Invoice = Invoice::where("InvoiceNumber",$value)->first();
				$Account = Account::find($Invoice->AccountID);

				// get invoice components by InvoiceID
				$invoice_components_q = "CALL prc_getPendingInvoiceListForExact($Invoice->InvoiceID)";
				$invoice_components = DB::connection('sqlsrv2')->select($invoice_components_q);

				// if PaymentMethod is not set then skip the invoice
				if(!empty($Account->PaymentMethod)) {
					// if PaymentMethod is WireTransfer or DirectDebit or Invoice is outpayment invoice then need to create payment entry
					if(in_array($Account->PaymentMethod,['WireTransfer','DirectDebit']) || ($Invoice->ItemInvoice == 1 && $invoice_components[0]->Component == 'Outpayment')) {
						$paymentdata = array();
						$paymentdata['CompanyID'] 		= $Invoice->CompanyID;
						$paymentdata['AccountID'] 		= $Invoice->AccountID;
						$paymentdata['InvoiceNo'] 		= $Invoice->FullInvoiceNumber;
						$paymentdata['InvoiceID'] 		= (int)$Invoice->InvoiceID;
						$paymentdata['PaymentDate'] 	= date('Y-m-d');
						$paymentdata['PaymentMethod'] 	= "";//$transactionResponse['transaction_payment_method'];
						$paymentdata['CurrencyID'] 		= $Account->CurrencyId;
						$paymentdata['PaymentType'] 	= 'Payment In';
						$paymentdata['Notes'] 			= "Payment Inserted By ExactPaymentImport cronjob at ".date('Y-m-d H:i:s');
						$paymentdata['Amount'] 			= floatval($Invoice->GrandTotal);
						$paymentdata['Status'] 			= 'Approved';
						$paymentdata['created_at'] 		= date('Y-m-d H:i:s');
						$paymentdata['updated_at'] 		= date('Y-m-d H:i:s');
						$paymentdata['CreatedBy'] 		= "ExactPaymentImport";
						$paymentdata['ModifyBy'] 		= "ExactPaymentImport";

						Payment::insert($paymentdata);
						ExactInvoiceLog::where(['InvoiceID'=>$Invoice->InvoiceID])->update(["PaymentStatus"=>1]);
						$Invoice->update(["InvoiceStatus"=>'paid']);
					} else {
						ExactInvoiceLog::where(['InvoiceID'=>$Invoice->InvoiceID])->update(["PaymentStatus"=>1]);
					}
					$countInvoicePaymentImported++;
					$success[] = "Payment for Invoice ".$Invoice->InvoiceNumber." successfully imported.";
				} else {
					$error[] = "Invoice ".$Invoice->InvoiceNumber." is skipped due to Payment Method is not set on account.";
				}
			}
			DB::connection('sqlsrv2')->commit();

			if(empty($error)) {
				$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
				$joblogdata['Message'] = "Invoice Payment Imported count : ".$countInvoicePaymentImported . "<br/>" . implode("<br/>", $success);
			} else {
				$error = array_unique($error); // remove multiple same error message and keep just one
				Log::info('Error : ');
				Log::info($error);
				Log::info($error);
				$joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
				$joblogdata['Message'] = "Invoice Payment Imported ".$countInvoicePaymentImported . "<br/>" . implode("<br/>", $success) . "<br/>" . implode("<br/>", $error);
			}

			Log::info(' ========================== import exact invoice payment end =============================');
			CronJobLog::insert($joblogdata);

		} catch (\Exception $e) {
			DB::connection('sqlsrv2')->rollback();
			date_default_timezone_set(Config::get('app.timezone'));
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

		CronHelper::after_cronrun($this->name, $this);
	}

}
