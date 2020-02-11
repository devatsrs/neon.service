<?php namespace App\Console\Commands;

/*
 * Only files will be uploaded as Document in exact for Prepaid invoices, sales entry will not be created for Prepaid invoices in exact.
 * For Postpaid invoices files will be uploaded as Document and also sales entry will be created in exact.
*/

use App\Lib\CompanyConfiguration;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\EmailClient;
use App\Lib\Exact;
use App\Lib\ExactAuthentication;
use App\Lib\ExactInvoiceLog;
use App\Lib\Invoice;
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

class ExactInvoiceExport extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'exactinvoiceexport';

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

		Log::useFiles(storage_path() . '/logs/exactinvoiceexport-'. date('Y-m-d').'.log');
		Log::info(' ========================== export exact invoice start =============================');

		$countInvoicePosted 		= 0;
		$joblogdata 				= array();
		$joblogdata['CronJobID'] 	= $CronJobID;
		$joblogdata['created_at'] 	= date('Y-m-d H:i:s');
		$joblogdata['created_by'] 	= 'RMScheduler';
		$error = $success = [];
		try {
			CronJob::createLog($CronJobID);
			$exact = new Exact($CompanyID);

			$Journal 				= $exact->getJournal(ExactAuthentication::JOURNAL_SALES); // exact sales journal, which we need to pass while creating invoice
			$DocumentTypeSales 		= $exact->getDocumentType(ExactAuthentication::DOCUMENT_TYPE_SALES_INVOICE); // sales invoice exact document type when create document there
			$DocumentTypePurchase 	= $exact->getDocumentType(ExactAuthentication::DOCUMENT_TYPE_SALES_INVOICE); // purchase invoice exact document type when create document there

			// check if Journal found or not
			if(isset($Journal['faultString']) || empty($Journal[0]['Code'])) {
				if(!empty($Journal['nodata'])) { // if Journal not found
					$error[] = "Journal not found in exact, Journal : ".ExactAuthentication::JOURNAL_SALES;
				} else { // if error
					$error[] = $Journal['faultString'];
				}
			}

			// check if DocumentType Found or not
			if(isset($DocumentTypeSales['faultString']) || empty($DocumentTypeSales[0]['ID'])) {
				if(!empty($DocumentTypeSales['nodata'])) { // if Document Type not found
					$error[] = "Document Type not found in exact, Document Type : ".ExactAuthentication::DOCUMENT_TYPE_SALES_INVOICE;
				} else { // if error
					$error[] = $DocumentTypeSales['faultString'];
				}
			}

			if(empty($error)) {
				// get all sales/customer invoices which's status is sent
				$invoice_q = 'CALL prc_getPendingInvoiceListForExact(NULL)';

				$invoices = DB::connection('sqlsrv2')->select($invoice_q);

				// get all mapped glcode from mapping screen section
				$MappedGLCode_q = "SELECT ic.Settings
								   FROM tblIntegration i
								   JOIN	tblIntegrationConfiguration ic ON i.IntegrationID = ic.IntegrationID
								   WHERE i.Slug='exact'";

				$MappedGLCodeData = DB::select($MappedGLCode_q);
				$MappedGLCode = !empty($MappedGLCodeData[0]->Settings) ? json_decode($MappedGLCodeData[0]->Settings, true) : [];

				// loop through each invoice, invoice will be posted one by one
				foreach ($invoices as $invoice) {
					$invoice_desc = '';
					$invoice_desc_year = '';
					$invoice_desc_month = '';
					$InvoiceNumber = $invoice->InvoiceNumber;
					$PaymentStatus = ExactInvoiceLog::PaymentStatusPaid; // default pending for all invoices

					$PaymentCondition = $BillingType = '';
					if($invoice->BillingType == 1) { // prepaid
						$BillingType = 'Prepaid';
						if (!empty($MappedGLCode[ExactAuthentication::KEY_PAYMENT_CONDITION][ExactAuthentication::KEY_PAYMENT_CONDITION_PREPAID])) {
							$PaymentCondition = $MappedGLCode[ExactAuthentication::KEY_PAYMENT_CONDITION][ExactAuthentication::KEY_PAYMENT_CONDITION_PREPAID];
						}
					} else { // postpaid
						//need to change when we know how to know which type to send
						$BillingType = 'Postpaid';
						if (!empty($MappedGLCode[ExactAuthentication::KEY_PAYMENT_CONDITION][ExactAuthentication::KEY_PAYMENT_CONDITION_POSTPAID])) {
							$PaymentCondition = $MappedGLCode[ExactAuthentication::KEY_PAYMENT_CONDITION][ExactAuthentication::KEY_PAYMENT_CONDITION_POSTPAID];
						}
						if (!empty($MappedGLCode[ExactAuthentication::KEY_PAYMENT_CONDITION][ExactAuthentication::KEY_PAYMENT_CONDITION_ONCREDIT])) {
							$PaymentCondition = $MappedGLCode[ExactAuthentication::KEY_PAYMENT_CONDITION][ExactAuthentication::KEY_PAYMENT_CONDITION_ONCREDIT];
						}
						if (!empty($MappedGLCode[ExactAuthentication::KEY_PAYMENT_CONDITION][ExactAuthentication::KEY_PAYMENT_CONDITION_CREDITCARD])) {
							$PaymentCondition = $MappedGLCode[ExactAuthentication::KEY_PAYMENT_CONDITION][ExactAuthentication::KEY_PAYMENT_CONDITION_CREDITCARD];
						}
						if (!empty($MappedGLCode[ExactAuthentication::KEY_PAYMENT_CONDITION][ExactAuthentication::KEY_PAYMENT_CONDITION_DIRECTDEBIT])) {
							$PaymentCondition = $MappedGLCode[ExactAuthentication::KEY_PAYMENT_CONDITION][ExactAuthentication::KEY_PAYMENT_CONDITION_DIRECTDEBIT];
						}
					}

					if($PaymentCondition == '') {
						$error[] = "Code Not mapped against ".$BillingType." Payment Condition, please map it in order to post ".$BillingType." invoice to exact.";
						// if payment condition is not mapped then skip invoice
						continue;
					}
					$error = array_unique($error); // remove multiple same error message and keep just one

					// get account from exact by neon account number
					$Account = $exact->getAccount($invoice->Number);

					$invoice_data = $invoice_log_data = array();
					// if no error and account found in exact then only proceed further
					if (!isset($Account['faultString']) && !empty($Account[0]['ID'])) {
						//document upload code will be here
						$DocumentData 	= array('Subject' => $InvoiceNumber, 'Type' => $DocumentTypeSales[0]['ID'], 'Account' => $Account[0]['ID']);
						$Document 		= $exact->createDocument($DocumentData);

						// if no error and account found in exact then only proceed further
						if (!isset($Document['faultString']) && !empty($Document['ID'])) {
							$file_name	 = [];
							$file_name[] = $invoice->PDF;
							$file_name[] = $invoice->UblInvoice;
							$file_name[] = $invoice->UsagePath;
							$UploadPath = CompanyConfiguration::get($CompanyID, 'UPLOAD_PATH');

							$doc_error_count = 0;
							$doc_error = [];
							foreach ($file_name as $key => $file) {
								if(!empty($file)) {
									$file_path = $UploadPath . '/' . $file;
									$Document_file_data = array('Document' => $Document['ID'], 'FileName' => basename($file_path));
									$DocumentFile = $exact->uploadDocumentFile($Document_file_data, $file_path);

									if (!empty($DocumentFile['faultString'])) {
										$doc_error[] = $DocumentFile['faultString'];
										$doc_error_count++;
									}
									if ($doc_error_count > 0) {
										// if error while uploading documents then skip invoice and delete created document from exact
										$docfileerrormsg = implode("<br/>&#9;", $doc_error);
										$error[] = "Error in invoice : " . $invoice->InvoiceNumber . "<br/>&#9;" . $docfileerrormsg;
										// remove/rollback created document from exact
										$exact->deleteDocument($Document);
										continue;// if error while uploading files in document in exact then skip invoice
									}
								}
							}
						} else {
							// Error while creating Document in Exact
							$error[] = $Document['faultString'];
							continue;// if error while creating document in exact then skip invoice
						}

						// only files will be uploaded if prepaid invoice, sales entry will not create for prepaid invoices
						// so, further portion will be skipped, it will direct log in ExactInvoiceLog table
						if($invoice->BillingType == 1 && $invoice->ItemInvoice != 1) { // only prepaid usage invoice, not one-off invoice
							//$PaymentStatus = ExactInvoiceLog::PaymentStatusPaid; // mark prepaid usage invoice as paid
							goto SECTION_ExactInvoiceLog;
						}

						$invoice_components_q = "CALL prc_getPendingInvoiceListForExact($invoice->InvoiceID)";

						$invoice_components = DB::connection('sqlsrv2')->select($invoice_components_q);

						// if PaymentMethod is not set or PaymentMethod is WireTransfer or DirectDebit then Status will be pending because we need to import payment from exact for that
						if(empty($invoice->PaymentMethod) || in_array($invoice->PaymentMethod,['WireTransfer','DirectDebit'])) {
							$PaymentStatus = ExactInvoiceLog::PaymentStatusPending;
						} else { // mark as paid so, ignore payment import from exact
							$PaymentStatus = ExactInvoiceLog::PaymentStatusPaid;
						}

						$glerror_count = 0;
						$glerror = [];
						$glerror['component'] = [];
						$glerror['taxrate'] = [];
						$SalesEntryLines = [];
						//loop through each invoice line and create array for SalesLinesEntry to post with invoice in exact
						foreach ($invoice_components as $invoice_component) {
							// if OutPayment Invoice then Status will be pending because we need to import payment from exact for that
							if($invoice->ItemInvoice == 1 && $invoice_component->Component == 'Outpayment') {
								$PaymentStatus = ExactInvoiceLog::PaymentStatusPending;
							}

							$invoice_desc_year = date('Y', strtotime($invoice_component->StartDate));
							$invoice_desc_month = date('m', strtotime($invoice_component->StartDate));
							$invoice_desc = $invoice_desc_year . $invoice_desc_month;

							$GLCode = '';
							// get GLCode for the component from mapped GLCode which is mapped in gateway mapping screen
							if($invoice->ItemInvoice == 1) { // if item/one-off invoice (created from frontend) then check with access component as for now(2019-12-23), need to change later when customer specifies requirement
								if (!empty($MappedGLCode[ExactAuthentication::KEY_ONE_OFF_INVOICE_COMPONENT][$invoice_component->Component]))
									$GLCode = $MappedGLCode[ExactAuthentication::KEY_ONE_OFF_INVOICE_COMPONENT][$invoice_component->Component];
							} else if($invoice_component->AccountServiceID == 0) { // if account level charges, additional or subscription
								if (!empty($MappedGLCode[ExactAuthentication::KEY_COST_COMPONENT_PKG][$invoice_component->Component]))
									$GLCode = $MappedGLCode[ExactAuthentication::KEY_COST_COMPONENT_PKG][$invoice_component->Component];
							} else { // number related charges under service
								if ($invoice_component->ProductType==RateTable::RATE_TABLE_TYPE_ACCESS && !empty($MappedGLCode[ExactAuthentication::KEY_COST_COMPONENT_DID][$invoice_component->Component]))
									$GLCode = $MappedGLCode[ExactAuthentication::KEY_COST_COMPONENT_DID][$invoice_component->Component];
								else if ($invoice_component->ProductType==RateTable::RATE_TABLE_TYPE_TERMINATION && !empty($MappedGLCode[ExactAuthentication::KEY_COST_COMPONENT_TERMINATION][$invoice_component->Component]))
									$GLCode = $MappedGLCode[ExactAuthentication::KEY_COST_COMPONENT_TERMINATION][$invoice_component->Component];
								else if ($invoice_component->ProductType==RateTable::RATE_TABLE_TYPE_PACKAGE && !empty($MappedGLCode[ExactAuthentication::KEY_COST_COMPONENT_PKG][$invoice_component->Component]))
									$GLCode = $MappedGLCode[ExactAuthentication::KEY_COST_COMPONENT_PKG][$invoice_component->Component];
							}

							// if GLCode is mapped then create invoice line entry in SalesEntryLines array
							if ($GLCode != '') { //  && ($invoice_component->TaxRateID == 0 || $invoice_component->ExactVATCode != '')
								$GLAccount 	= $exact->getGLAccount($GLCode);
								// if no error and GLAccount found in exact then only proceed further
								if (!isset($GLAccount['faultString']) && !empty($GLAccount[0]['ID'])) {
									// SalesEntryLines to send with invoice data
									$SalesEntryLines[] = array('Description' => $invoice_desc, 'GLAccount' => $GLAccount[0]['ID'], 'AmountFC' => $invoice_component->TotalCost, 'VATCode' => $invoice_component->ExactVATCode);
								} else {
									$glerror_count++;
									if (!empty($GLAccount['nodata'])) { // if GLAccount not found
										$glerror['component'][] = "GLCode not found in exact for Component : " . $invoice_component->Component . " : GLCode : " . $GLCode;
									} else { // if error
										$glerror['component'][] = $GLAccount['faultString'];
									}
								}
							} else {
								$glerror_count++;
								if($GLCode == '')
									$glerror['component'][] = "GLCode not mapped in Neon for component : " . $invoice_component->Component;
								else
									$glerror['taxrate'][] = "Code not mapped in Neon for Tax Rate : " . $invoice_component->NeonVATCode;
							}
						}

						// if no error against any invoice line then proceed further
						if ($glerror_count == 0) {
							$DueDays = !empty($invoice->PaymentDueInDays) ? $invoice->PaymentDueInDays : 2; // default 2 days
							// invoice entry data
							$invoice_data['Description'] 		= $invoice_desc;
							$invoice_data['Customer'] 			= $Account[0]['ID'];
							$invoice_data['Journal'] 			= $Journal[0]['Code'];
							$invoice_data['Document'] 			= $Document['ID'];
							$invoice_data['YourRef'] 			= $InvoiceNumber;
							$invoice_data['ReportingYear'] 		= $invoice_desc_year;
							$invoice_data['ReportingPeriod']	= $invoice_desc_month;
							$invoice_data['EntryDate'] 			= $invoice->IssueDate;
							$invoice_data['DueDate'] 			= date('Y-m-d', strtotime($invoice->IssueDate . ' + ' . $DueDays . ' days'));
							$invoice_data['PaymentCondition']	= $PaymentCondition;
							$invoice_data['SalesEntryLines']	= $SalesEntryLines;

							$ExactInvoice = $exact->createSalesEntry($invoice_data);

							// check if invoice created successfully in exact without error
							if (!isset($ExactInvoice['faultString']) && !empty($ExactInvoice['EntryID'])) {
								// checkpoint for prepaid invoice
								SECTION_ExactInvoiceLog:
								$countInvoicePosted++;
								$success[] = "Invoice ".$InvoiceNumber." posted successfully.";
								$ExactResponse['Invoice'] 			= !empty($ExactInvoice) ? $ExactInvoice : [];
								$ExactResponse['Document'] 			= $Document;
								$invoice_log_data['InvoiceID'] 		= $invoice->InvoiceID;
								$invoice_log_data['ExactResponse'] 	= json_encode($ExactResponse);
								$invoice_log_data['PaymentStatus'] 	= $PaymentStatus;
								$invoice_log_data['created_at'] 	= date('Y-m-d');
//								$invoice_log_data['updated_at'] 	= date('Y-m-d');

								ExactInvoiceLog::insert($invoice_log_data);
							} else {
								// Error while creating Invoice in Exact
								$error[] = $ExactInvoice['faultString'];
								// remove/rollback created document from exact
								$exact->deleteDocument($Document);
							}

						} else {// if any error against any one invoice line then invoice will be skipped and log error
							$glerror['component']	= array_unique($glerror['component']);
							$glerror['taxrate']		= array_unique($glerror['taxrate']);
							$glerrormsg 			= implode("<br/>&#9;", $glerror['component']) . "<br/>&#9;" . implode("<br/>&#9;", $glerror['taxrate']);
							$error[] 				= "Error in invoice : " . $invoice->InvoiceNumber . "<br/>&#9;" . $glerrormsg;
							// remove/rollback created document from exact
							$exact->deleteDocument($Document);
						}

					} else {
						if (!empty($Account['nodata'])) { // if account not found
							$error[] = "Account " . $invoice->AccountName . "(" . $invoice->Number . ") not exist in Exact.";
						} else { // if error
							$error[] = "Account " . $invoice->AccountName . "(" . $invoice->Number . ") has Error: <br/>" . $Account['faultString'];
						}
					}

				}
			}

			if(empty($error)) {
				$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
				$joblogdata['Message'] = "Invoice Posted ".$countInvoicePosted . "<br/>" . implode("<br/>", $success);
			} else {
				$error = array_unique($error); // remove multiple same error message and keep just one
				Log::info('Error : ');
				Log::info($error);
				$joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
				$joblogdata['Message'] = "Invoice Posted ".$countInvoicePosted . "<br/>" . implode("<br/>", $success) . "<br/>" . implode("<br/>", $error);
			}

			Log::info(' ========================== export exact invoice end =============================');
			CronJobLog::insert($joblogdata);

		} catch (\Exception $e) {
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
