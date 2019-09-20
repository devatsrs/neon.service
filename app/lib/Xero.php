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
use Webpatser\Uuid\Uuid;
use Illuminate\Support\Facades\DB;

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
				//log::info(print_r($Organisation,true));
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

	/* Not Using */
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
		$CompanyID= $Options['CompanyID'];
		if(!empty($Invoices) && count($Invoices)>0){
			foreach($Invoices as $Invoice){
				if(!empty($Invoice))
					$response[] = $this->CreateInvoice($Invoice,$CompanyID);
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

	public function CreateInvoice($InvoiceID,$CompanyID){
		Log::info('Invoice ID : '.print_r($InvoiceID,true));
		$response = array();
		$XeroContext = $this->XeroContext;
		$XeroData		=	SiteIntegration::CheckIntegrationConfiguration(true,SiteIntegration::$XeroSlug,$CompanyID);
		$XeroData = json_decode(json_encode($XeroData),true);
		log::info(print_r($XeroData,true));
		$Invoices = Invoice::find($InvoiceID);
		$InvoiceFullNumber = $Invoices->FullInvoiceNumber;
		$count = $this->CheckInvoice($InvoiceFullNumber);
		Log::info('-- count --'.print_r($count,true));
		if(isset($count) && $count==0) {
			Log::info('-- Create Invoice --'.print_r($InvoiceFullNumber,true));
			$data = $this->GetInvoiceData($InvoiceID,$XeroData);
			if(!empty($data) && count($data)>0) {
				try {

					$invoice = new \XeroPHP\Models\Accounting\Invoice($XeroContext);
					$CustomerID = $this->getCustomerId($Invoices->AccountID);
					$contact = $XeroContext->loadByGUID('Accounting\\Contact', $CustomerID);
					$invoice->setContact($contact);
					$invoice->setType('ACCREC');

					if(!empty($Invoices->BillingClassID)){
						$PaymentDueInDays = BillingClass::getPaymentDueInDays($Invoices->BillingClassID);
					}else{
						$PaymentDueInDays = AccountBilling::getPaymentDueInDays($Invoices->AccountID,$Invoices->ServiceID);
					}

					$date =  date('Y-m-d H:i:s',strtotime($Invoices->IssueDate.' +'.$PaymentDueInDays.' days'));

					$dateInstance = new \DateTime($Invoices->IssueDate);
					$invoice->setDate($dateInstance);

					$duedateInstance = new \DateTime($date);
					$invoice->setDueDate($duedateInstance);

					$invoice->setInvoiceNumber($InvoiceFullNumber);
					$invoice->setReference($InvoiceID);

					//$invoice->setCurrencyCode('GBP');
					$invoice->setStatus('Draft');
					//$invoice->setLineAmountType('NoTax');

					//fetch only overall taxes
					$InvoiceTaxRate = InvoiceTaxRate::where(["InvoiceID"=>$InvoiceID,"InvoiceTaxType"=>1])->first();
					$AllInvoiceTaxRate = InvoiceTaxRate::where(["InvoiceID"=>$InvoiceID])->first();
					log::info("InvoiceData". print_r($data, true));
					log::info("InvoiceTaxRate". print_r($InvoiceTaxRate, true));

					$XeroItems = $XeroContext->load('Accounting\\Item')->execute();
					//log::info('XeroItems' .print_r($XeroItems,true));

					$XeroTaxRates = $XeroContext->load('Accounting\\TaxRate')->where('Status', 'ACTIVE')->execute();
					//log::info("XeroTaxRates ". print_r($XeroTaxRates, true));

					$XeroAccounts = $XeroContext->load('Accounting\\Account')->execute();
					//log::info("XeroAccounts ". print_r($XeroAccounts, true));

					foreach ($data as $lineItem) {
						if(!empty($lineItem['LineTotal'])) {
							$line = new \XeroPHP\Models\Accounting\Invoice\LineItem($XeroContext);

							$Description = $lineItem['Title'].' - '.$lineItem['Description'];
							$line->setDescription($Description);
							$ProductName = product::getProductName($lineItem['ProductID'],$lineItem['ProductType']);
							log::info("ProductName". print_r($ProductName, true));

							$ItemCode = $this->SearchItemXero($ProductName,$XeroItems);
							if(!empty($ItemCode))
							{
								log::info("xeroItemCode". $ItemCode);
								$line->setItemCode($ItemCode);
							}

							//check if Percentage overall tax is entered (not line tax)
							if (!empty($InvoiceTaxRate)) {

								$taxratesdata = $this->SearchTaxRatesXero($InvoiceTaxRate->Title,$XeroTaxRates);
								log::info("test ". print_r($taxratesdata, true));
								if(count($taxratesdata) == 0)
								{
									$taxratesdata = $this->SearchTaxRatesXero($lineItem['TaxRateName'],$XeroTaxRates);
									log::info("test2 ". print_r($taxratesdata, true));
								}
							}
							else{
								if(isset($lineItem['TaxRateName']))
								{
									$taxratesdata = $this->SearchTaxRatesXero($lineItem['TaxRateName'],$XeroTaxRates);
									log::info("test3 ". print_r($taxratesdata, true));
								}
								else{
									$taxratesdata = array();
									log::info("test4 ". print_r($taxratesdata, true));
								}
							}
							log::info("count-taxratesdata ". count($taxratesdata));
							if(count($taxratesdata) > 0)
							{
								$line->setTaxType($taxratesdata['TaxType']);
							}
							else{
								//check if Flat overall tax is entered (not line tax)
								if(isset($AllInvoiceTaxRate))
								{
									if($AllInvoiceTaxRate->InvoiceTaxType == 1)
									{
										$FlatStatus = TaxRate::getTaxFlatStatus($AllInvoiceTaxRate->TaxRateID);
										if($FlatStatus == 1){
											log::info("TaxAmount ". print_r($AllInvoiceTaxRate->TaxAmount, true));
											$line->setTaxAmount($AllInvoiceTaxRate->TaxAmount);
										}
									}
									else{
										$FlatStatus = TaxRate::getTaxFlatStatus($AllInvoiceTaxRate->TaxRateID);
										if($FlatStatus == 1){
											log::info("TaxAmount ". print_r($lineItem['TaxAmount'], true));
											$line->setTaxAmount($lineItem['TaxAmount']);
										}
									}
								}
							}

							unset($ItemCode);
							unset($taxratesdata);
							if(isset($lineItem['AccountMappingName']) && $lineItem['AccountMappingName'] != '')
							{
								//$InvoiceItemAccount = $this->SearchAccountXero($lineItem['AccountMappingName'],$XeroAccounts);
								$InvoiceItemAccount = "";
								foreach ($XeroAccounts as $key => $val) {
									//Log::info("keyname".$key);
									//Log::info("valname".print_r($val,true));
									if ($val['Name'] == $lineItem['AccountMappingName']) {
										$InvoiceItemAccount = $XeroAccounts[$key]['Code'];
									}
								}
								log::info("InvoiceItemAccount ". $InvoiceItemAccount);
								if(!empty($InvoiceItemAccount))
								{
									log::info("InvoiceItemAccount ".$InvoiceItemAccount);
									$line->setAccountCode($InvoiceItemAccount);
								}
							}
							//$line->setTaxAmount($taxratesdata[0]->EffectiveRate);
							//$line->setItemCode('112');
							$line->setQuantity($lineItem['Qty']);
							$line->setUnitAmount($lineItem['Price']);

							$line->setLineAmount($lineItem['LineTotal']);
							if($lineItem['DiscountType'] != 'Flat')
							{
								$line->setDiscountRate($lineItem['DiscountAmount']); // Percentage
							}

							// Add the line to the order
							$invoice->addLineItem($line);
						}
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

	public function SearchItemXero($ProductName,$XeroItems){
		foreach ($XeroItems as $key => $val) {
			if ($val['Name'] === $ProductName) {
				return $XeroItems[$key]['Code'];
			}
		}
		return null;
	}

	public function SearchTaxRatesXero($TaxRateName,$XeroTaxRates){
		foreach ($XeroTaxRates as $key => $val) {
			Log::info("valname".print_r($val));
			if ($val['Name'] === $TaxRateName) {
				return $XeroTaxRates[$key];
			}
		}
		return null;
	}

	public function SearchAccountXero($AccountName,$XeroAccounts){
		foreach ($XeroAccounts as $key => $val) {
			Log::info("valname".print_r($val));
			if ($val['Name'] === $AccountName) {
				return $XeroAccounts[$key]['Code'];
			}
		}
		return null;
	}

	public function SearchItem($ProductName){

		Log::info('SearchItem : '.$ProductName);

		$Response = 0;
		//$Account = Account::find($AccountID);
		//$AccountName = $Account->AccountName;
		Log::info('SearchItem');
		$XeroContext = $this->XeroContext;
		$Items = $XeroContext->load('Accounting\\Item')
			->where('Name', $ProductName)
			->execute();
		log::info(print_r($Items,true));
		if(!empty($Items) && count($Items)>0){
			$ItemCode = $Items[0]->Code;
			if(!empty($ItemCode)){
				$Response = $ItemCode;
			}
			log::info("$ItemCode".print_r($ItemCode,true));
		}

		return $Response;

	}

	public function GetInvoiceData($InvoiceID,$XeroData){
		$data = array();
		$Invoice = Invoice::find($InvoiceID);
		$InvoiceDetails = InvoiceDetail::where('InvoiceID','=',$InvoiceID)->get();
		$SubTotal = 0;
		foreach($InvoiceDetails as $InvoiceDetail){
			if($InvoiceDetail->ProductType != Product::INVOICE_PERIOD){
				$InvoiceData = array();
				$Title = '';
				if($InvoiceDetail->ProductType == Product::USAGE ){
					$Title = 'Usage';
				}
				if($InvoiceDetail->ProductType == Product::SUBSCRIPTION ){
					$Title = 'Recurring';
				}
				if($InvoiceDetail->ProductType == Product::ONEOFFCHARGE ){
					$Title = 'Additional';
				}
				if($InvoiceDetail->ProductType == Product::ITEM ){
					$Title = 'Item';
				}
				$InvoiceData['Title'] = $Title;
				$InvoiceData['InvoiceDetailID'] = $InvoiceDetail->InvoiceDetailID;
				$InvoiceData['ProductID'] = $InvoiceDetail->ProductID;
				$InvoiceData['ProductType'] = $InvoiceDetail->ProductType;
				$InvoiceData['Description'] = $InvoiceDetail->Description;
				$InvoiceData['Qty'] = $InvoiceDetail->Qty;
				$InvoiceData['Price'] = $InvoiceDetail->Price;
				$InvoiceData['LineTotal'] = $InvoiceDetail->LineTotal;
				$InvoiceData['DiscountType'] = $InvoiceDetail->DiscountType;
				$InvoiceData['DiscountAmount'] = $InvoiceDetail->DiscountAmount;
				$InvoiceData['TaxRateName'] = TaxRate::getTaxName($InvoiceDetail->TaxRateID);
				$InvoiceData['FlatStatus'] = TaxRate::getTaxFlatStatus($InvoiceDetail->TaxRateID);
				$InvoiceData['TaxAmount'] = $InvoiceDetail->TaxAmount;

				if($InvoiceDetail->ProductID == 0)
				{
					$InvoiceData['AccountMappingName'] = $XeroData['Usage'][0];
				}
				else
				{
					if($Title == 'Item')
					{
						$InvoiceData['AccountMappingName'] = $XeroData['Items'][$InvoiceDetail->ProductID];
					}
					if($Title = 'Recurring')
					{
						$InvoiceData['AccountMappingName'] = $XeroData['Subscriptions'][$InvoiceDetail->ProductID];
					}
					if($Title == 'Usage')
					{
						$InvoiceData['AccountMappingName'] = $XeroData['Usage'][0];
					}
				}


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

	public function addJournals($Options){
		Log::info('-- Xero Add Journal --');
		$response = array();
		$error = array();
		$success = array();
		$Journal = array();

		$Invoices = $Options['Invoices'];
		$CompanyID = $Options['CompanyID'];

		if(!empty($Invoices) && count($Invoices)>0){
			$PaidInvoices = array();
			foreach($Invoices as $Invoice){
				if(!empty($Invoice))
					$InvoiceData = array();
				$InvoiceData = Invoice::find($Invoice);
				$InvoiceFullNumber = $InvoiceData->FullInvoiceNumber;
				log::info('Invoice ID : '.$Invoice);
				$CheckInvoiceFullPaid = Invoice::CheckInvoiceFullPaid($Invoice,$CompanyID);
				if(!empty($CheckInvoiceFullPaid)){
					$PaidInvoices[] = $Invoice;
				}else{
					$error[] =$InvoiceFullNumber.'(Invoice) not fully paid';
				}
				//$response[] = $this->CreateInvoice($Invoice);
			}

			if(!empty($PaidInvoices) && count($PaidInvoices)>0){
				/**
				 * New Change Start
				 **/

				$NewPaidInvoices = array();
				foreach($PaidInvoices as $paidInvoice){
					$Payments = Payment::where(['InvoiceID'=>$paidInvoice])->first();
					$PaymentDate=$Payments->PaymentDate;
					$PaymentDate=date('Y-m-d',strtotime($PaymentDate));
					$NewPaidInvoices[$PaymentDate][]=$paidInvoice;
				}

				if(!empty($NewPaidInvoices) && count($NewPaidInvoices)>0) {
					// Check Invoice and Payment Mapping

					$XeroMappingError=$this->checkXeroMapping($CompanyID,$PaidInvoices);
					if (!empty($XeroMappingError) && count($XeroMappingError)>0) {
						foreach ($XeroMappingError as $err) {
							$error[] = $err;
						}
					}else{
						foreach ($NewPaidInvoices as $key => $NewPaidInvoice) {
							log::info('Journal Payment Date ' . $key);
							$Journal = $this->createJournal($key, $NewPaidInvoice, $CompanyID);
							if (!empty($Journal)) {
								if (!empty($Journal['error']) && count($Journal['error']) > 0) {
									foreach ($Journal['error'] as $err) {
										$error[] = $err;
									}
								}
								if (!empty($Journal['Success']) && count($Journal['Success']) > 0) {
									foreach ($Journal['Success'] as $SucessMessage) {
										$success[] = $SucessMessage;
									}
								}
							}
						}

					} // xero mapping over
				} // newpaidinvoice over
			}else{
				$error[] = 'Journal creation failed ';
			}
		}//invoice loop over

		$response['error'] = $error;
		$response['Success'] = $success;
		Log::info('-- Xero End Journal --');
		//log::info('Final Response');
		//log::info(print_r($response,true));

		return $response;
	}

	public function getAccountMapping($name){
		$XeroContext = $this->XeroContext;
		$Response = array();
		$accounts = $XeroContext->load('Accounting\\Account')
			->where('Name', $name)
			->execute();
		if(!empty($accounts) && count($accounts)>0){
			$Response['AccountID'] = $accounts[0]->AccountID;
			$Response['Code'] = $accounts[0]->Code;
			$Response['Type'] = $accounts[0]->Type;
			$Response['Name'] = $accounts[0]->Name;
			$Response['TaxType'] = $accounts[0]->TaxType;
			$Response['Class'] = $accounts[0]->Class;
			$Response['ReportingCode'] = $accounts[0]->ReportingCode;
			$Response['ReportingCodeName'] = $accounts[0]->ReportingCodeName;
			$Response['Status'] = $accounts[0]->Status;

			//log::info(print_r($ContactID,true));
		}
		log::info(print_r($Response,true));
		return $Response;
	}

	public function createJournal($JournalDate,$Invoices,$CompanyID){
		log::info(print_r($Invoices,true));
		$response = array();
		$error = array();
		$success = array();
		$JournalError = array();
		if(!empty($Invoices) && count($Invoices)>0){

			$XeroData		=	SiteIntegration::CheckIntegrationConfiguration(true,SiteIntegration::$XeroSlug,$CompanyID);

			$XeroData = json_decode(json_encode($XeroData),true);

			log::info(print_r($XeroData,true));
			$InvoiceAccount = array();
			$PaymentAccount = array();
			$TaxId = '';

			if(!empty($XeroData['InvoiceAccount'])){
				$InvoiceAccount = $this->getAccountMapping($XeroData['InvoiceAccount']);
				if(empty($InvoiceAccount)){
					$error[]='Invoice Mapping not setup correctly';
				}
			}else{
				$error[]='Invoice Mapping not setup in integration section';
			}

			if(!empty($XeroData['PaymentAccount'])){
				$PaymentAccount = $this->getAccountMapping($XeroData['PaymentAccount']);
				if(empty($PaymentAccount)){
					$error[]='Payment Mapping not setup correctly';
				}
			}else{
				$error[]='Payment Mapping not setup in integration section';
			}

			$XeroContext = $this->XeroContext;

			$JournalNumber = 'Neon'.date('Y').date('m').date('d').date('H').date('i').date('s');
			//log::info('Journal Number'.$JournalNumber);

			try {

				$Journal = new \XeroPHP\Models\Accounting\ManualJournal($XeroContext);

				$Journal->setStatus('POSTED');
				$Journal->setNarration($JournalNumber);

				$dateInstance = new \DateTime($JournalDate);
				$Journal->setDate($dateInstance);
				//$Journal->setReference('checkjournal');


				foreach($Invoices as $Invoice){

					$InvoiceData = array();

					$InvoiceData = Invoice::find($Invoice);

					$RoundChargesAmount = Helper::get_round_decimal_places($InvoiceData->CompanyID,$InvoiceData->AccountID,$InvoiceData->ServiceID);

					/*

					$JournalErrormsg = $this->checkInvoiceInJournale($Invoice);
					if(isset($JournalErrormsg) && $JournalErrormsg != ''){
						$JournalError[$Invoice] = $JournalErrormsg;
					}

					$CustomerID = $this->getCustomerId($InvoiceData->AccountID);
					if(empty($CustomerID)){
						$response = $this->CreateCustomer($InvoiceData->AccountID);
						$Account = Account::find($InvoiceData->AccountID);
						$AccountName = $Account->AccountName;
						if(!empty($response) && !empty($response['CustomerID'])){
							$CustomerID = $response['CustomerID'];
							$success[] = $AccountName. '(Account) is created';
						}else{
							$error[] = $AccountName.'(Customer) creation failed ';
						}
					}
					*/
					$InvoiceFullNumber = $InvoiceData->FullInvoiceNumber;
					//$InvoiceGrantTotal = $InvoiceData->GrandTotal;
					//$PaymentTotal = $InvoiceData->SubTotal;
					$PaymentTotal = number_format($InvoiceData->SubTotal,$RoundChargesAmount, '.', '');
					$InvoiceTaxRateAmount = Invoice::getInvoiceTaxRateAmount($Invoice,$RoundChargesAmount);
					$InvoiceGrantTotal = $PaymentTotal + $InvoiceTaxRateAmount;
					$TaxTotal = $InvoiceData->TotalTax;


					//Debit Section

					if(!empty($InvoiceAccount)){
						$invoicedescription = $InvoiceFullNumber.' (Invoice)';
						log::info('$invoicedescription '.$invoicedescription);
						log::info(print_r($InvoiceAccount,true));
						$JournalLines = new \XeroPHP\Models\Accounting\ManualJournal\JournalLine($XeroContext);

						$JournalLines->setDescription($invoicedescription);
						$JournalLines->setAccountCode($InvoiceAccount['Code']);
						$JournalLines->setLineAmount($InvoiceGrantTotal);
						$Journal->addJournalLine($JournalLines);

					}

					//Credit Section if total is in minus(-) it will goes to credit section

					if(!empty($PaymentAccount)){
						$paymentdescription = $InvoiceFullNumber.' (Payment)';
						log::info('$paymentdescription '.$paymentdescription);
						log::info(print_r($PaymentAccount,true));
						$JournalLines1 = new \XeroPHP\Models\Accounting\ManualJournal\JournalLine($XeroContext);

						$JournalLines1->setDescription($paymentdescription);
						$JournalLines1->setAccountCode($PaymentAccount['Code']);
						$JournalLines1->setLineAmount('-'.$PaymentTotal);
						$Journal->addJournalLine($JournalLines1);

						// All Tax
						$InvoiceTaxRates = InvoiceTaxRate::where(["InvoiceID"=>$Invoice])->get();

						if(!empty($InvoiceTaxRates) && count($InvoiceTaxRates)>0) {
							foreach ($InvoiceTaxRates as $InvoiceTaxRate) {

								$Title = $InvoiceTaxRate->Title;
								$TaxRateID = $InvoiceTaxRate->TaxRateID;
								log::info($Title);
								$TaxAmount = number_format($InvoiceTaxRate->TaxAmount,$RoundChargesAmount, '.', '');
								if($InvoiceTaxRate->InvoiceTaxType==0){
									$type='Inline Tax';
								}elseif($InvoiceTaxRate->InvoiceTaxType==1){
									$type='Overall Tax';
								}else{
									$type='';
								}

								if(!empty($XeroData['Tax'][$TaxRateID])){
									$TaxAccount = $this->getAccountMapping($XeroData['Tax'][$TaxRateID]);
								}

								if(empty($TaxAccount)){
									$error[] = $Title. '(Tax Mapping not) setup correctly';
								}else{

									$taxdescription = $InvoiceFullNumber.' '.$Title.' ('.$type.')';
									$JournalLines2 = new \XeroPHP\Models\Accounting\ManualJournal\JournalLine($XeroContext);

									$JournalLines2->setDescription($taxdescription);
									$JournalLines2->setAccountCode($TaxAccount['Code']);
									$JournalLines2->setLineAmount('-'.$TaxAmount);
									$Journal->addJournalLine($JournalLines2);
								}
							}
						}
					}

				}
				if(empty($error) && count($error)==0){
					log::info('No error');

					//Log::info(print_r($Journal,true));
					$SaveManualJournal = $Journal->save()->getElements();

					$ManualJournalID = $SaveManualJournal[0]['ManualJournalID'];

					if (!empty($ManualJournalID))
					{
						foreach($Invoices as $Invoice){
							$jernalmsg = '';
							$InvoiceLog = Invoice::find($Invoice);
							$InvoiceFullNumber = $InvoiceLog->FullInvoiceNumber;

							/*
							if(!empty($JournalError) && count($JournalError)>0){
								if(!empty($JournalError[$Invoice])){
									$jernalmsg = $JournalError[$Invoice];
								}
							}*/


							$success[] = 'Invoice No:'.$InvoiceFullNumber.' posted to journal '.$jernalmsg;
							/**
							 * Insert Data in InvoiceLog
							 */
							$invoiceloddata = array();
							$invoiceloddata['InvoiceID'] = $Invoice;
							$invoiceloddata['Note'] = InvoiceLog::$log_status[InvoiceLog::POST].' (Xero Journal Number : '.$JournalNumber.') By RMScheduler';
							$invoiceloddata['created_at'] = date("Y-m-d H:i:s");
							$invoiceloddata['InvoiceLogStatus'] = InvoiceLog::POST;
							InvoiceLog::insert($invoiceloddata);

							$InvoiceLog->update(['InvoiceStatus' => Invoice::POST]);

							/**
							 * Insert Data in QuickBookLog
							 */
							$quickbooklogdata = array();
							$quickbooklogdata['Note'] = $Invoice.' '.QuickBookLog::$log_status[QuickBookLog::INVOICE].' (Xero Journal Number : '.$JournalNumber.' Journal Id : '.$ManualJournalID.') Created';
							$quickbooklogdata['created_at'] = date("Y-m-d H:i:s");
							$quickbooklogdata['Type'] = QuickBookLog::INVOICE;
							QuickBookLog::insert($quickbooklogdata);
						}
						$success[] = $JournalDate.' Journal created (Journal Number '.$JournalNumber.' )';
						//$response['response'] = $resp;
					}
					else
					{
						$error[] = $JournalDate.' Journal creation failed ';
					}

				}else{
					$error[] = $JournalDate.' Journal creation failed ';
				}

			}catch(\exception $e){
				Log::error($e);
				$error[] = $JournalDate.' Journal creation failed '.$e->getMessage();
			}

		}

		//log::info('Journal Error '.print_r($error,true));
		//log::info('Journal Success '.print_r($success,true));
		$response['error'] = array_unique($error);
		$response['Success'] = $success;
		//log::info('Journal Response '.print_r($response,true));
		return $response;

	}

	/**
	 * Xero Payment Import
	 */
	public function GetAndInsertPayment($date){
		$response = array();
		$data = array();
		$ProcessID = Uuid::generate();
		$bacth_insert_limit = 250;
		$counter = 0;
		$lineno = 0;
		try
		{
			$XeroContext = $this->XeroContext;
			$dateInstance = new \DateTime($date);
			$payments = $XeroContext->load('Accounting\\Payment')->modifiedAfter($dateInstance)->execute();

			//log::info(print_r($payments[0],true));exit;
			foreach($payments as $payment){
				$paymentarray = array();
				$paymentarray['ProcessID'] = $ProcessID;
				$paymentarray['CompanyID'] = 1;
				$paymentarray['TransactionID'] = $payment->PaymentID;
				$paymentarray['Amount'] = $payment->Amount;
				//$paymentarray['Status'] = $payment->Status;
				//$paymentarray['Status'] = $payment->Status;
				$paymentarray['InvoiceNumber'] = $payment->Invoice['InvoiceNumber'];
				$paymentarray['AccountName'] = $payment->Invoice['Contact']['Name'];
				$paymentarray['PaymentDate'] = $payment->Date->format('Y-m-d H:i:s');
				$paymentarray['Notes'] = 'Xero Payment ID '. $payment->PaymentID;
				//$paymentarray['CreateDate'] = $payment->UpdatedDateUTC->format('Y-m-d H:i:s');
				if(!empty($payment->PaymentID)){
					$data[]=$paymentarray;
					$counter++;
				}

				if($counter==$bacth_insert_limit){
					Log::info('Batch insert start');
					Log::info('global counter'.$lineno);
					Log::info('insertion start');
					DB::connection('sqlsrv2')->table('tblTempPaymentAccounting')->insert($data);
					Log::info('insertion end');
					$data = [];
					$counter = 0;
				}
				$lineno++;
			} // loop over

			if(!empty($data)){
				Log::info('Batch insert start');
				Log::info('global counter'.$lineno);
				Log::info('insertion start');
				Log::info('last batch insert ' . count($data));
				DB::connection('sqlsrv2')->table('tblTempPaymentAccounting')->insert($data);
				Log::info('insertion end');
			}
			//log::info(print_r($data,true));

			DB::connection('sqlsrv2')->beginTransaction();
			Log::info("CALL  prc_importPaymentAccounting ('".$ProcessID."') start");
			$JobStatusMessage =DB::connection('sqlsrv2')->select("CALL  prc_importPaymentAccounting ('".$ProcessID."')");
			Log::info("CALL  prc_importPaymentAccounting ('".$ProcessID."') end");
			DB::connection('sqlsrv2')->commit();

			$JobStatusMessage = array_reverse(json_decode(json_encode($JobStatusMessage),true));
			Log::info($JobStatusMessage);
			Log::info(count($JobStatusMessage));
			if(count($JobStatusMessage) > 1){
				$prc_error = array();
				foreach ($JobStatusMessage as $JobStatusMessage1) {
					$prc_error[] = $JobStatusMessage1['Message'];
				}
				//$JobMessage = implode(',\n\r',fix_jobstatus_meassage($prc_error));
				$JobMessage = implode('<br>',fix_jobstatus_meassage($prc_error));
				$response['Status'] = 'success';
				$response['Message'] = $JobMessage;

			}elseif(!empty($JobStatusMessage[0]['Message'])){
				$JobMessage = $JobStatusMessage[0]['Message'];
				$response['Status'] = 'success';
				$response['Message'] = $JobMessage;
			}

		}catch (\Exception $e) {
			DB::connection('sqlsrv2')->rollback();
			Log::error($e);
			$JobMessage = 'Error: ' . $e->getMessage();
			$response['Status'] = 'failed';
			$response['Message'] = $JobMessage;
		}

		return $response;
	}
	public function checkXeroMapping($CompanyID,$PaidInvoices){
		$error=array();
		$XeroData =	SiteIntegration::CheckIntegrationConfiguration(true,SiteIntegration::$XeroSlug,$CompanyID);
		$XeroData = json_decode(json_encode($XeroData),true);

		if(!empty($XeroData['InvoiceAccount'])){
			$InvoiceAccount = $this->getAccountMapping($XeroData['InvoiceAccount']);
			if(empty($InvoiceAccount)){
				$error[]='Invoice Mapping not setup correctly';
			}
		}else{
			$error[]='Invoice Mapping not setup in integration section';
		}

		if(!empty($XeroData['PaymentAccount'])){
			$PaymentAccount = $this->getAccountMapping($XeroData['PaymentAccount']);
			if(empty($PaymentAccount)){
				$error[]='Payment Mapping not setup correctly';
			}
		}else{
			$error[]='Payment Mapping not setup in integration section';
		}

		if(!empty($PaidInvoices) && count($PaidInvoices)>0){
			$InvoiceTaxRates = InvoiceTaxRate::distinct()->select(array('TaxRateID','Title'))->whereIn('InvoiceID',$PaidInvoices)->get()->toArray();
			if(!empty($InvoiceTaxRates) && count($InvoiceTaxRates)>0){
				foreach($InvoiceTaxRates as $InvoiceTaxRate){
					$Title = $InvoiceTaxRate['Title'];
					$TaxRateID = $InvoiceTaxRate['TaxRateID'];
					if(!empty($XeroData['Tax'][$TaxRateID])){
						$TaxAccount = $this->getAccountMapping($XeroData['Tax'][$TaxRateID]);
					}
					if(empty($TaxAccount)){
						$error[] = $Title. '(Tax Mapping not) setup correctly';
					}
				}
			}
		}
		return $error;
	}

}