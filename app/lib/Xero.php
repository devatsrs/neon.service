<?php
/**
 * Created by PhpStorm.
 * User: CodeDesk
 * Date: 03/11/2017(d-m-y)
 * Time: 12:30 PM
 */

namespace App\Lib;

use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Log;
use XeroPHP\Application\PublicApplication;
use XeroPHP\Application\PrivateApplication;
use XeroPHP\Remote\Request;
use XeroPHP\Remote\URL;

class Xero {

	protected $token ;
	protected $ConsumerKey ;
	protected $ConsumerSecret ;
	protected $status = false;
	protected $XeroContext ;
	protected $CompanyID;


	function __Construct($CompanyID){

		Log::info('-- Xero Api Check --');
		$this->set_connection($CompanyID);
    }

	public function set_connection($CompanyID){
		$is_xero = SiteIntegration::CheckIntegrationConfiguration(true, SiteIntegration::$XeroSlug,$CompanyID);
		if(!empty($is_xero)){
			$this->ConsumerSecret = $is_xero->ConsumerKey;
			$this->ConsumerSecret = $is_xero->ConsumerSecret;

			$UPLOADPATH = CompanyConfiguration::get($CompanyID,'UPLOAD_PATH');
			$TEMP_PATH =  CompanyConfiguration::get($CompanyID,'TEMP_PATH').'/';

			$path = AmazonS3::unSignedUrl($is_xero->XeroFilePath,$CompanyID);
			if (strpos($path, "https://") !== false) {
				$file = $TEMP_PATH . basename($path);
				file_put_contents($file, file_get_contents($path));
				$FilePath = $file;
			} else {
				$FilePath = $path;
			}

			//$path = $UPLOADPATH.'/'.$is_xero->XeroFilePath;

			$key = 'file://'.$FilePath;

			Log::info('Xero Pem file path '.$key);

			$config = [
				'oauth' => [
					'callback'         => 'http://localhost/',
					'consumer_key'     => $is_xero->ConsumerKey,
					'consumer_secret'  => $is_xero->ConsumerSecret,
					'rsa_private_key'  => $key,
					//'rsa_private_key'  => 'file://D:/c/bhavin/OPENSSL/privatekey.pem',
				],
			];
			try {
				$xero = new PrivateApplication($config);
				$Organisation = $xero->load('Accounting\\Organisation')->execute();
				log::info(print_r($Organisation,true));
				log::info('count '.count($Organisation));
				$Count = count($Organisation);
				if($Count>0){
					$this->status = true;
					$this->XeroContext = $xero;
				}else{
					$this->status = false;
				}
			} catch (\Exception $err) {
				$this->status = false;
				Log::error($err);
			}
		}else{
			$this->status = false;
		}
	}

	public function test_connection($CompanyID){
		return $this->status;
	}

	public function addCustomers($Options)
	{
		Log::info('-- Xero Add Customer --');
		$response = array();

		$accounts = $Options['Accounts']['AccountID'];
		if(!empty($accounts) && count($accounts)>0){
			foreach($accounts as $account){
				if(!empty($account)) {
					$response[] = $this->CreateCustomer($account);
				}
			}
		}

		Log::info('-- Xero End Customer --');
		return $response;
	}

	public function CreateCustomer($AccountID){
		$response = array();
		log::info('AccountID '.$AccountID);
		$Account = Account::find($AccountID);
		$AccountName = $Account->AccountName;
		log::info('AccountName '.$AccountName);
		$count = $this->CheckCustomer($AccountID);
		Log::info('-- count --'.print_r($count,true));
		if(isset($count) && $count==0){
			$XeroContext = $this->XeroContext;
			try {
				$contact = new \XeroPHP\Models\Accounting\Contact($XeroContext);
				$contact->setName($AccountName);
				$contact->setContactStatus('ACTIVE');
				if(!empty($Account->FirstName)){
					$contact->setFirstName($Account->FirstName);
				}
				if(!empty($Account->LastName)){
					$contact->setLastName($Account->LastName);
				}
				if(!empty($Account->Email)){
					$contact->setEmailAddress($Account->Email);
				}

				$Result = $contact->save()->getElements();
				log::info(print_r($Result, true));
				if (!empty($Result)) {
					$ContactID = $Result[0]['ContactID'];
					$ContactName = $Result[0]['Name'];

					$response['CustomerID'] = $ContactID;
					$response['Success'] = $ContactName. '(Account) is created';


					/**
					 * Need to change in future if want to use
					 * Insert Data in QuickBookLog
					 */
					$quickbooklogdata = array();
					$quickbooklogdata['Note'] = $AccountName.' '.QuickBookLog::$log_status[QuickBookLog::ACCOUNT].' (Xeroid : '.$ContactID.') Created';
					$quickbooklogdata['created_at'] = date("Y-m-d H:i:s");
					$quickbooklogdata['Type'] = QuickBookLog::ACCOUNT;
					QuickBookLog::insert($quickbooklogdata);

					log::info('ContactID ' . $ContactID);
					Log::info('-- Create Customer id --'.$ContactID);
					Log::info('-- Create Customer name --test customer');
					//Log::info('-- Create Customer name --'.$AccountName);
				}
			}catch (\Exception $err) {
				$response['error'] = $AccountName.'(Account) is failed To create';
				$response['error_reason'] = $err->getMessage();

				Log::info('-- Create Customer Error --'.print_r($err->getMessage(),true));

			}
		}
		return $response;

	}

	public function CheckCustomer($AccountID){
		$Response = 0;
		$Account = Account::find($AccountID);
		$AccountName = $Account->AccountName;
		Log::info('Checkcustomer');
		$XeroContext = $this->XeroContext;
		$contacts = $XeroContext->load('Accounting\\Contact')
			->where('Name', $AccountName)
			->execute();
		if(!empty($contacts) && count($contacts)>0){
			$ContactID = $contacts[0]->ContactID;
			if(!empty($ContactID)){
				$Response = 1;
			}
			log::info(print_r($ContactID,true));
		}

		return $Response;
	}

	public function CreateItem($ProductName){
		$response = array();
		$count = $this->CheckItem($ProductName);
		Log::info('-- count --'.print_r($count,true));

		if(isset($count) && $count==0){
			Log::info('-- Create Item --'.print_r($ProductName,true));

			$XeroContext = $this->XeroContext;
			try {
				$Item = new \XeroPHP\Models\Accounting\Item($XeroContext);
				$Item->setName($ProductName);
				$Item->setDescription('Test New');
				//$Item->setInventoryAssetAccountCode('111');
				$Item->setIsTrackedAsInventory('false');
				$Item->setIsSold('false');
				$Item->setIsPurchased('false');
				$Item->setCode('112');
				$Result = $Item->save()->getElements();
				log::info(print_r($Result, true));
				if (!empty($Result)) {
					$ItemID = $Result[0]['ItemID'];
					$ItemName = $Result[0]['Name'];

					$response['CustomerID'] = $ItemID;
					$response['Success'] = $ItemName. '(Item) is created';

					log::info('ItemID ' . $ItemID);
					Log::info('-- Create Item id --'.$ItemID);
					Log::info('-- Create Customer name --'.$ItemName);
				}
			}catch (\Exception $err) {
				$response['error'] = $ProductName.'(Item) is failed To create';
				$response['error_reason'] = $err->getMessage();

				Log::info('-- Create Item Error --'.print_r($err->getMessage(),true));

			}
		}
		return $response;
	}

	public function CheckItem($ProductName){

		Log::info('CheckProduct : '.$ProductName);

		$Response = 0;
		//$Account = Account::find($AccountID);
		//$AccountName = $Account->AccountName;
		Log::info('CheckItem');
		$XeroContext = $this->XeroContext;
		$Items = $XeroContext->load('Accounting\\Item')
			->where('Name', $ProductName)
			->execute();
		log::info(print_r($Items,true));
		if(!empty($Items) && count($Items)>0){
			$ItemID = $Items[0]->ItemID;
			if(!empty($ItemID)){
				$Response = 1;
			}
			log::info(print_r($ItemID,true));
		}

		return $Response;

	}

	public function addInvoices($Options){
		$response = array();
		Log::info('-- Xero Add Inovice --');
		$Invoices = $Options['Invoices'];
		if(!empty($Invoices) && count($Invoices)>0){
			foreach($Invoices as $Invoice){
				if(!empty($Invoice))
					$response[] = $this->CreateInvoice($Invoice);
			}
		}
		Log::info('-- Xero End Inovice --');
		return $response;
	}

	public function getCustomerId($AccountID){

		$Account = Account::find($AccountID);
		$AccountName = $Account->AccountName;
		log::info('Check Account Name '.$AccountName);

		$ContactID = '';

		$XeroContext = $this->XeroContext;
		$contacts = $XeroContext->load('Accounting\\Contact')
			->where('Name', $AccountName)
			->execute();
		if(!empty($contacts) && count($contacts)>0){
			$ContactID = $contacts[0]->ContactID;
			//log::info(print_r($ContactID,true));
		}

		log::info('Check Account Id '.$ContactID);

		return $ContactID;
	}

	public function CreateInvoice($InvoiceID){
		Log::info('Invoice ID : '.print_r($InvoiceID,true));
		$response = array();
		$XeroContext = $this->XeroContext;
		$Invoices = Invoice::find($InvoiceID);
		$InvoiceFullNumber = $Invoices->FullInvoiceNumber;
		$count = $this->CheckInvoice($InvoiceFullNumber);
		Log::info('-- count --'.print_r($count,true));
		if(isset($count) && $count==0) {
			Log::info('-- Create Invoice --'.print_r($InvoiceFullNumber,true));
			$data = $this->GetInvoiceData($InvoiceID);
			if(!empty($data) && count($data)>0) {
				try {

					$invoice = new \XeroPHP\Models\Accounting\Invoice($XeroContext);
					$CustomerID = $this->getCustomerId($Invoices->AccountID);
					$contact = $XeroContext->loadByGUID('Accounting\\Contact', $CustomerID);
					$invoice->setContact($contact);
					$invoice->setType('ACCREC');

					$dateInstance = new \DateTime($Invoices->IssueDate);
					$invoice->setDate($dateInstance);
					//$invoice->setDueDate($dateInstance);
					$invoice->setInvoiceNumber($InvoiceFullNumber);
					$invoice->setReference($InvoiceID);

					//$invoice->setCurrencyCode('GBP');
					$invoice->setStatus('Draft');
					$invoice->setLineAmountType('NoTax');

					foreach ($data as $lineItem) {
						if(!empty($lineItem['LineTotal'])) {
							$line = new \XeroPHP\Models\Accounting\Invoice\LineItem($XeroContext);

							$line->setDescription($lineItem['Description']);

							$line->setQuantity($lineItem['Qty']);
							//$line->setUnitAmount(99.99);
							//$line->setTaxAmount(0);
							$line->setLineAmount($lineItem['LineTotal']);
							//$line->setDiscountRate(0); // Percentage

							// Add the line to the order
							$invoice->addLineItem($line);
						}
					}
					if (!empty($Invoices->TotalTax)) {
						$line = new \XeroPHP\Models\Accounting\Invoice\LineItem($XeroContext);
						//$line->setItemCode('112');
						$line->setUnitAmount($Invoices->TotalTax);
						//$line->setTaxType('NONE');
						//$line->setTaxAmount('0.00');
						$line->setDescription('Overall Tax');
						$line->setQuantity(1);
						$line->setLineAmount($Invoices->TotalTax);
						$invoice->addLineItem($line);
					}

					$SaveInvoice = $invoice->save()->getElements();

					log::info(count($SaveInvoice) . ' count');
					log::info(print_r($SaveInvoice, true));
					$SaveInvoiceID = $SaveInvoice[0]['InvoiceID'];
					log::info('Saved InvoiceID '.$SaveInvoiceID);
					if(!empty($SaveInvoiceID)){
						/**
						 * Insert Data in InvoiceLog
						 */
						$invoiceloddata = array();
						$invoiceloddata['InvoiceID'] = $InvoiceID;
						$invoiceloddata['Note'] = InvoiceLog::$log_status[InvoiceLog::POST].' ('.$SaveInvoiceID.'(Xero)) By RMScheduler';
						$invoiceloddata['created_at'] = date("Y-m-d H:i:s");
						$invoiceloddata['InvoiceLogStatus'] = InvoiceLog::POST;
						InvoiceLog::insert($invoiceloddata);

						$Invoices->update(['InvoiceStatus' => Invoice::POST]);

						/**
						 * Insert Data in QuickBookLog
						 */
						$quickbooklogdata = array();
						$quickbooklogdata['Note'] = $InvoiceID.' '.QuickBookLog::$log_status[QuickBookLog::INVOICE].' (Xeroid : '.$SaveInvoiceID.') Created';
						$quickbooklogdata['created_at'] = date("Y-m-d H:i:s");
						$quickbooklogdata['Type'] = QuickBookLog::INVOICE;
						QuickBookLog::insert($quickbooklogdata);

						Log::info('-- Create Invoice id --'.print_r($SaveInvoiceID,true));

						$response['Success'] =$InvoiceFullNumber. '(Invoice) is created';
					}else{
						$response['error'] = $InvoiceFullNumber.'(Invoice) is failed To create';
						$response['error_reason'] = '';
						Log::info('-- Create Invoice Error --');
					}
				}catch(\exception $e){
					Log::error($e);
					$response['error'] = $InvoiceFullNumber.'(Invoice) is failed To create';
					$response['error_reason'] = $e->getMessage();
					Log::info('-- Create Invoice Error --'.print_r($e->getMessage(),true));

					Log::info('-- Create Invoice Error --');
				}
			}else{
				$response['error'] = $InvoiceFullNumber.'(Invoice) is failed To create';
				$response['error_reason'] = 'No Invoice Detail';
				Log::info('-- Create Invoice Error -- No Invoice Detail');
			}
		}elseif(isset($count) && $count>0){
			$response['Success'] =$InvoiceFullNumber. '(Invoice) is already created';
		}

		Log::info('-- Create Invoice Done --');
		//Log::info(print_r($response,true));
		return $response;
	}

	public function addJournals($Options){

	}

	public function GetInvoiceData($InvoiceID){
		$data = array();
		$Invoice = Invoice::find($InvoiceID);
		$InvoiceDetails = InvoiceDetail::where('InvoiceID','=',$InvoiceID)->get();
		$SubTotal = 0;
		foreach($InvoiceDetails as $InvoiceDetail){
			if($InvoiceDetail->ProductType != Product::INVOICE_PERIOD){
				$InvoiceData = array();
				$InvoiceData['InvoiceDetailID'] = $InvoiceDetail->InvoiceDetailID;
				$InvoiceData['ProductID'] = $InvoiceDetail->ProductID;
				$InvoiceData['ProductType'] = $InvoiceDetail->ProductType;
				$InvoiceData['Description'] = $InvoiceDetail->Description;
				$InvoiceData['Qty'] = $InvoiceDetail->Qty;
				$InvoiceData['LineTotal'] = $InvoiceDetail->LineTotal;
				$data[]=$InvoiceData;
				$SubTotal=$SubTotal+$InvoiceDetail->LineTotal;
			}
		}
		//log::info(print_r($data,true));
		log::info('Invoice SubTotal '.$Invoice->SubTotal);
		log::info('Invoice DetTotal '.$SubTotal);
		return $data;
	}

	public function CheckInvoice($InvoiceFullNumber){
		Log::info('CheckInvoice : '.$InvoiceFullNumber);

		$invoicecount = 0;
		$InvoiceID = '';

		$XeroContext = $this->XeroContext;
		$invoices = $XeroContext->load('Accounting\\Invoice')
			->where('InvoiceNumber', $InvoiceFullNumber)
			->execute();
		if(!empty($invoices) && count($invoices)>0){
			$InvoiceID = $invoices[0]->InvoiceID;
			if(!empty($InvoiceID)){
				$invoicecount=1;
			}
		}

		log::info('Check Invoice Id '.$InvoiceID);

		return $invoicecount;
	}
}