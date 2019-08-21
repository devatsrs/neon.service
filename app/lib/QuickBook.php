<?php
/**
 * Created by PhpStorm.
 * User: CodeDesk
 * Date: 8/22/2015
 * Time: 12:57 PM
 */

namespace App\Lib;

use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Log;

class QuickBook {

	protected $token ;
	protected $oauth_consumer_key ;
	protected $oauth_consumer_secret ;
	protected $sandbox ;
	protected $quickbooks_oauth_url ;
	protected $quickbooks_success_url ;
	protected $quickbooks_menu_url ;
	protected $dsn ;
	protected $encryption_key ;
	protected $the_username ;
	protected $the_tenant ;
	protected $quickbooks_is_connected = false;
	protected $realm ;
	protected $Context =array() ;
	protected $CompanyID;


	function __Construct($CompanyID){


		//require_once dirname(__FILE__) . '/quicibookmaster/QuickBooks.php';
		//require_once 'I:/www/bhavin/neon/web/newbhavin/app/lib/quicibookmaster/QuickBooks.php';
		//$path = getenv('PATH_SDK_ROOT').'QuickBooks.php';
		//require_once($path);
		Log::info('-- QuickBook Api Check --');
		$this->is_quickbook($CompanyID);
	}

	public function test_connection($CompanyID)
	{
		$response = false;
		if ($this->is_quickbook($CompanyID)){
			if ($this->quickbooks_is_connected) {
				$CompanyInfoService = new \QuickBooks_IPP_Service_CompanyInfo();
				$quickbooks_CompanyInfo = $CompanyInfoService->get($this->Context, $this->realm);
				if(!empty($quickbooks_CompanyInfo) && count($quickbooks_CompanyInfo)>0){
					$response = true;
				}
			}
		}
		return $response;
	}

	public function quickbook_disconnect(){

		if (!\QuickBooks_Utilities::initialized($this->dsn)) {
			// Initialize creates the neccessary database schema for queueing up requests and logging
			\QuickBooks_Utilities::initialize($this->dsn);
		}
		$IntuitAnywhere = new \QuickBooks_IPP_IntuitAnywhere($this->dsn, $this->encryption_key, $this->oauth_consumer_key, $this->oauth_consumer_secret, $this->quickbooks_oauth_url, $this->quickbooks_success_url);


		if ($IntuitAnywhere->disconnect($this->the_username, $this->the_tenant))
		{

		}
	}

	public function quickbook_connect(){
		if (!\QuickBooks_Utilities::initialized($this->dsn)) {
			// Initialize creates the neccessary database schema for queueing up requests and logging
			\QuickBooks_Utilities::initialize($this->dsn);
		}
		$IntuitAnywhere = new \QuickBooks_IPP_IntuitAnywhere($this->dsn, $this->encryption_key, $this->oauth_consumer_key, $this->oauth_consumer_secret, $this->quickbooks_oauth_url, $this->quickbooks_success_url);
		// Try to handle the OAuth request
		if ($IntuitAnywhere->handle($this->the_username, $this->the_tenant))
		{
			; // The user has been connected, and will be redirected to $that_url automatically.
		}
		else
		{
			// If this happens, something went wrong with the OAuth handshake
			die('Oh no, something bad happened: ' . $IntuitAnywhere->errorNumber() . ': ' . $IntuitAnywhere->errorMessage());
		}
	}

	public function check_quickbook($CompanyID){
		$QuickBookData		=	SiteIntegration::CheckIntegrationConfiguration(true,SiteIntegration::$QuickBookSlug,$CompanyID);
		$WEBURL = CompanyConfiguration::getValueConfigurationByKey($CompanyID,'WEB_URL');

		if(!$QuickBookData){
			$this->quickbooks_is_connected = false;
		}else{
			$OauthConsumerKey = $QuickBookData->OauthConsumerKey;
			$OauthConsumerSecret = $QuickBookData->OauthConsumerSecret;
			$AppToken = $QuickBookData->AppToken;
			$QuickBookSandbox = $QuickBookData->QuickBookSandbox;
			if(!empty($QuickBookSandbox) && $QuickBookSandbox == 1){
				$QuickBookSandbox = true;
			}else{
				$QuickBookSandbox = false;
			}
			if(!empty($OauthConsumerKey) && !empty($OauthConsumerSecret) && !empty($AppToken)){
				$this->oauth_consumer_key = $OauthConsumerKey;
				$this->oauth_consumer_secret = $OauthConsumerSecret;
				$this->token = $AppToken;
				$this->sandbox = $QuickBookSandbox;

				$oauth_url = $WEBURL . '/quickbook/oauth';
				$success_url = $WEBURL . '/quickbook/success';
				$menu_url = $WEBURL . '/quickbook';

				$dbconnection = Config::get('database.connections.sqlsrv');
				$dsn = 'mysqli://'.$dbconnection['username'].':'.$dbconnection['password'].'@'.$dbconnection['host'].'/'.$dbconnection['database'];

				//$this->quickbooks_oauth_url = 'http://localhost/bhavin/neon/web/newbhavin/public/quickbook/oauth';
				//$this->quickbooks_success_url = 'http://localhost/bhavin/neon/web/newbhavin/public/quickbook/success';
				//$this->quickbooks_menu_url = 'http://localhost/bhavin/neon/web/newbhavin/public/quickbook';
				//$this->dsn = 'mysqli://root:root@localhost/LocalRatemanagement';

				$this->quickbooks_oauth_url = $oauth_url;
				$this->quickbooks_success_url = $success_url;
				$this->quickbooks_menu_url = $menu_url;
				$this->dsn = $dsn;

				$this->encryption_key = 'bcde1234';
				$this->the_username = 'DO_NOT_CHANGE_ME'.$CompanyID;
				$this->the_tenant = 12345;
				$this->quickbooks_is_connected = true;
			}else{
				$this->quickbooks_is_connected = false;
			}
		}
	}

	public function is_quickbook($CompanyID){

		$this->check_quickbook($CompanyID);

		if($this->quickbooks_is_connected){
			if (!\QuickBooks_Utilities::initialized($this->dsn)) {
				// Initialize creates the neccessary database schema for queueing up requests and logging
				\QuickBooks_Utilities::initialize($this->dsn);
			}
			$IntuitAnywhere = new \QuickBooks_IPP_IntuitAnywhere($this->dsn, $this->encryption_key, $this->oauth_consumer_key, $this->oauth_consumer_secret, $this->quickbooks_oauth_url, $this->quickbooks_success_url);

			if ($IntuitAnywhere->check($this->the_username, $this->the_tenant) and
				$IntuitAnywhere->test($this->the_username, $this->the_tenant)
			) {
				// Yes, they are
				$this->quickbooks_is_connected = true;
				$IPP = new \QuickBooks_IPP($this->dsn);

				// Get our OAuth credentials from the database
				$creds = $IntuitAnywhere->load($this->the_username, $this->the_tenant);

				// Tell the framework to load some data from the OAuth store
				$IPP->authMode(
					\QuickBooks_IPP::AUTHMODE_OAUTH,
					$this->the_username,
					$creds);

				if ($this->sandbox)
				{
					// Turn on sandbox mode/URLs
					$IPP->sandbox(true);
				}

				// Print the credentials we're using
				//echo "<pre>";print_r($creds);exit;

				// This is our current realm
				$realm = $creds['qb_realm'];
				$this->realm = $realm;

				// Load the OAuth information from the database
				$Context = $IPP->context();

				$this->Context = $Context;
				Log::info('-- QuickBook Api Working --');
				return true;
			}else{
				$this->quickbooks_is_connected = false;
				Log::info('-- QuickBook Api Not Working --');
				return false;
			}
		}else{
			Log::info('-- QuickBook Api Not Working --');
			return false;
		}
	}

	public function addCustomers($Options)
	{
		Log::info('-- QuickBook Add Customer --');
		$response = array();
		if ($this->is_quickbook($Options['CompanyID'])){
			if ($this->quickbooks_is_connected) {

				//Log::error(print_r($Context,true));
				//Log::info('-- RealemID --'.print_r($realm,true));

				$accounts = $Options['Accounts'];

				if(!empty($accounts) && count($accounts)>0){
					foreach($accounts as $account){
						if(!empty($account))
							$response[] = $this->CreateCustomer($account);
					}
				}

			}
		}
		Log::info('-- QuickBook End Customer --');
		return $response;
	}

	public function CreateCustomer($AccountID){
		$response = array();
		$Account = Account::find($AccountID);
		$Account = $Account[0];
		$AccountName = $Account->AccountName;
		$count = $this->CheckCustomer($AccountID);
		Log::info('-- count --'.print_r($count,true));
		if(isset($count) && $count==0){
			Log::info('-- Create Customer --'.print_r($AccountName,true));
			$Context = $this->Context;
			$realm = $this->realm;

			$CustomerService = new \QuickBooks_IPP_Service_Customer();

			$Customer = new \QuickBooks_IPP_Object_Customer();

			$FirstName = $Account->FirstName;
			$LastName = $Account->LastName;
			$Phone = $Account->Phone;
			$BillingEmail = $Account->BillingEmail;
			$Address1 = $Account->Address1;
			$Address2 = $Account->Address2.$Account->Address3;
			$City = $Account->City;
			$PostCode = $Account->PostCode;
			$Country = $Account->Country;

			if(!empty($FirstName)){
				$Customer->setGivenName($FirstName);
			}
			if(!empty($LastName)){
				$Customer->setFamilyName($LastName);
			}
			if(!empty($AccountName)){
				$Customer->setDisplayName($AccountName);
			}
			if(!empty($Phone)){
				// Phone #
				$PrimaryPhone = new \QuickBooks_IPP_Object_PrimaryPhone();
				$PrimaryPhone->setFreeFormNumber($Phone);
				$Customer->setPrimaryPhone($PrimaryPhone);
			}
			if(!empty($Address1) || !empty($Address2) || !empty($City) || !empty($PostCode) || !empty($Country)){

				// Bill address
				$BillAddr = new \QuickBooks_IPP_Object_BillAddr();
				if(!empty($Address1)){
					$BillAddr->setLine1($Address1);
				}
				if(!empty($Address2)){
					$BillAddr->setLine2($Address2);
				}
				if(!empty($City)){
					$BillAddr->setCity($City);
				}
				if(!empty($PostCode)){
					$BillAddr->setPostalCode($PostCode);
				}
				if(!empty($Country)){
					$BillAddr->setCountry($Country);
				}
				$Customer->setBillAddr($BillAddr);
			}


			// Terms (e.g. Net 30, etc.)
			//	$Customer->setSalesTermRef(4);

			if(isset($BillingEmail) && $BillingEmail !=''){
				// Email
				$PrimaryEmailAddr = new \QuickBooks_IPP_Object_PrimaryEmailAddr();
				$PrimaryEmailAddr->setAddress($BillingEmail);
				$Customer->setPrimaryEmailAddr($PrimaryEmailAddr);
			}

			if ($resp = $CustomerService->add($Context, $realm, $Customer))
			{
				Log::info('-- Create Customer id first --'.print_r($resp,true));
				$resp = str_replace('{-','',$resp);
				$resp = str_replace('}','',$resp);
				//$response['Id'] = $resp;
				//$response['Name'] = $Customer->getDisplayName();

				/**
				 * Insert Data in QuickBookLog
				 */
				$quickbooklogdata = array();
				$quickbooklogdata['Note'] = $AccountName.' '.QuickBookLog::$log_status[QuickBookLog::ACCOUNT].' (Quickbookid : '.$resp.') Created';
				$quickbooklogdata['created_at'] = date("Y-m-d H:i:s");
				$quickbooklogdata['Type'] = QuickBookLog::ACCOUNT;
				QuickBookLog::insert($quickbooklogdata);


				$response['CustomerID'] = $resp;
				$response['Success'] = $Customer->getDisplayName(). '(Account) is created';

				Log::info('-- Create Customer id --'.print_r($resp,true));
				Log::info('-- Create Customer name --'.print_r($Customer->getDisplayName(),true));
			}
			else
			{
				$response['error'] = $AccountName.'(Account) is failed To create';
				$response['error_reason'] = $CustomerService->lastError($Context);

				Log::info('-- Create Customer Error --'.print_r($CustomerService->lastError($Context),true));
			}


		}
		//Log::info('-- Create Customer Response --'.print_r($response,true));
		return $response;
	}

	public function CheckCustomer($AccountID){
		$Account = Account::find($AccountID);
		$Account = $Account[0];
		$AccountName = $Account->AccountName;
		Log::info('Checkcustomer');
		$Context = $this->Context;
		$realm = $this->realm;

		$CustomerService = new \QuickBooks_IPP_Service_Customer();

		$customercount = $CustomerService->query($Context, $realm, "SELECT COUNT(*) FROM Customer WHERE DisplayName = '".$AccountName."'");
		return $customercount;

	}

	public function getCustomerId($AccountID){

		$Account = Account::find($AccountID);
		$AccountName = $Account->AccountName;
		log::info('Check Account Name '.$AccountName);
		$customers = array();
		$Context = $this->Context;
		$realm = $this->realm;

		$CustomerID = '';
		$CustomerService = new \QuickBooks_IPP_Service_Customer();

		if (strpos($AccountName, "'") !== false) {
			log::info('sinqle quoute exit');

			$customers = $CustomerService->query($Context, $realm, "SELECT * FROM Customer MAXRESULTS 1000");
			if(!empty($customers) && count($customers)>0) {
				foreach ((array)$customers as $customer) {
					//print_r($Item);
					if($AccountName == $customer->getDisplayName()){
						log::info('Check Quickbook Account name '.$customer->getDisplayName());
						$CustomerID = $customer->getId();
						$CustomerID = str_replace('{-', '', $CustomerID);
						$CustomerID = str_replace('}', '', $CustomerID);
						log::info('Check Account Id '.$CustomerID);
						return $CustomerID;
					}
				}
			}
			return '';

		}else{
			$customers = $CustomerService->query($Context, $realm, "SELECT * FROM Customer WHERE DisplayName = '".$AccountName."' ");
			if(!empty($customers) && count($customers)>0) {
				foreach ((array)$customers as $customer) {
					//print_r($Item);

					$CustomerID = $customer->getId();
					$CustomerID = str_replace('{-', '', $CustomerID);
					$CustomerID = str_replace('}', '', $CustomerID);
				}
			}
			log::info('Check Account Id '.$CustomerID);
			return $CustomerID;
		}
	}

	public function addItems($Options){
		Log::info('-- QuickBook Add Item --');
		$response = array();
		if ($this->is_quickbook($Options['CompanyID'])){
			if ($this->quickbooks_is_connected) {

				$Products = $Options['Products'];

				if(!empty($Products) && count($Products)>0){
					foreach($Products as $Product){
						if(!empty($Product))
							$response[] = $this->CreateItem($Product);
					}
				}

			}
		}
		Log::info('-- QuickBook End Item --');
		//log::info(print_r($response,true));
		return $response;
	}

	public function CreateItem($ProductName){
		$response = array();
		$count = $this->CheckItem($ProductName);
		Log::info('-- count --'.print_r($count,true));
		if(isset($count) && $count==0){
			Log::info('-- Create Item --'.print_r($ProductName,true));
			$Context = $this->Context;
			$realm = $this->realm;

			$ItemService = new \QuickBooks_IPP_Service_Item();

			$Item = new \QuickBooks_IPP_Object_Item();

			$Item->setName($ProductName);
			$Item->setType('Service');
			$Refid = $this->getItemIncomeAccountRef('Services');
			$Item->setIncomeAccountRef($Refid);

			if ($resp = $ItemService->add($Context, $realm, $Item))
			{
				$resp = str_replace('{-','',$resp);
				$resp = str_replace('}','',$resp);
				//$response['Id'] = $resp;
				//$response['Name'] = $Item->getName();

				$response['Success'] = $Item->getName(). '(Item) is created';

				/**
				 * Insert Data in QuickBookLog
				 */
				$quickbooklogdata = array();
				$quickbooklogdata['Note'] = $ProductName.' '.QuickBookLog::$log_status[QuickBookLog::PRODUCT].' (Quickbookid : '.$resp.') Created';
				$quickbooklogdata['created_at'] = date("Y-m-d H:i:s");
				$quickbooklogdata['Type'] = QuickBookLog::PRODUCT;
				QuickBookLog::insert($quickbooklogdata);

				Log::info('-- Create Item id --'.print_r($resp,true));
				Log::info('-- Create Item name --'.print_r($Item->getName(),true));
			}
			else
			{
				$response['error'] = $ProductName.'(Item) is failed To create';
				$response['error_reason'] = $ItemService->lastError($Context);

				Log::info('-- Create Item Error --'.print_r($ItemService->lastError($Context),true));
			}
		}
		//Log::info('-- Create Customer Response --'.print_r($response,true));
		return $response;
	}

	public function CheckItem($ProductName){

		Log::info('CheckProduct : '.$ProductName);
		$Context = $this->Context;
		$realm = $this->realm;

		$ItemService = new \QuickBooks_IPP_Service_Term();
		$itemcount = $ItemService->query($Context, $realm, "SELECT count(*) FROM Item WHERE Name = '".trim($ProductName)."' ");

		return $itemcount;

	}

	public function getItemIncomeAccountRef($type){
		$Context = $this->Context;
		$realm = $this->realm;
		$id = '';
		$ItemService = new \QuickBooks_IPP_Service_Term();
		log::info('Name Of Type'.$type);
		$items = $ItemService->query($Context, $realm, "SELECT * FROM Item WHERE Name = '".$type."' ");
		if(!empty($items)&&count($items)>0){
			$item = $items[0];
			$id = $item->getIncomeAccountRef();
			$id = str_replace('{-','',$id);
			$id = str_replace('}','',$id);
		}
		log:info('IncomeAccountRef id :'.$id);
		return $id;
	}

	public function getItemId($ProductName){

		Log::info('CheckProduct Id : '.$ProductName);
		$Context = $this->Context;
		$realm = $this->realm;

		$itemid = '';
		$ItemService = new \QuickBooks_IPP_Service_Term();

		$items = $ItemService->query($Context, $realm, "SELECT * FROM Item WHERE Name = '".$ProductName."' ");
		if(!empty($items) && count($items)>0){
			foreach ($items as $Item)
			{
				//print_r($Item);

				$itemid = $Item->getId();
				$itemid = str_replace('{-','',$itemid);
				$itemid = str_replace('}','',$itemid);
			}
		}

		return $itemid;
	}
	public function addPayments($Options){
		Log::info('-- QuickBook Add Payments --');
		$response = array();
		if ($this->is_quickbook($Options['CompanyID'])){
			if ($this->quickbooks_is_connected) {
				$Payments = $Options['Payments'];

				if(!empty($Payments) && count($Payments)>0){
					foreach($Payments as $Payment){
						if(!empty($Payment))
							$response[] = $this->CreatePayments($Payment);
					}
				}
			}
		}
		Log::info('-- QuickBook End Payments --');
		return $response;
	}

	public function CreatePayments($PaymentID){

		Log::info('Payment ID : '.print_r($PaymentID,true));
		$response = array();
		$PaymentData = Payment::find($PaymentID);
		if(!empty($PaymentData->InvoiceID)) {
			$InvoiceID = $PaymentData->InvoiceID;
			$Invoices = Invoice::find($InvoiceID);
			$InvoiceFullNumber = $Invoices->FullInvoiceNumber;
			//$count = $this->CheckInvoice($InvoiceFullNumber);
			//$CustomerID = $this->getCustomerId($Invoices->AccountID);
			$Account = Account::find($Invoices->AccountID);
			$AccountName = $Account->AccountName;

			Log::info('-- Create Payments --'.print_r($InvoiceFullNumber,true));
			$Context = $this->Context;
			$realm = $this->realm;

			//get invoice count from Quickbook
			$InvoiceService = new \QuickBooks_IPP_Service_Invoice();
			$invoicecount = $InvoiceService->query($Context, $realm, "SELECT count(*) FROM Invoice WHERE DocNumber = '".$InvoiceFullNumber."' ");
			if($invoicecount > 0) {

				//get invoice details from Quickbook
				$invoicedetails = $InvoiceService->query($Context, $realm, "SELECT Id FROM Invoice WHERE DocNumber = '" . $InvoiceFullNumber . "' ");
				$q_invoiceid = $invoicedetails[0]->getId();
				Log::info('Quickbook Invoice ID : ' . print_r($q_invoiceid, true));

				//get customer details from Quickbook
				$CustomerService = new \QuickBooks_IPP_Service_Customer();
				$customers = $CustomerService->query($Context, $realm, "SELECT Id FROM Customer WHERE FullyQualifiedName = '" . $AccountName . "' ");
				$q_customerid = $customers[0]->getId();
				Log::info('Quickbook Customer ID : ' . print_r($q_customerid, true));

				$PaymentService = new \QuickBooks_IPP_Service_Payment();
				// Create payment object
				$Payment = new \QuickBooks_IPP_Object_Payment();
				$Payment->setPaymentRefNum($PaymentData->PaymentID);
				$PaymentDate = date('Y-m-d', strtotime($PaymentData->PaymentDate));
				$Payment->setTxnDate($PaymentDate);
				$Payment->setTotalAmt($PaymentData->Amount);

				// Create line for payment (this details what it's applied to)
				$Line = new \QuickBooks_IPP_Object_Line();
				$Line->setAmount($PaymentData->Amount);

				// The line has a LinkedTxn node which links to the actual invoice
				$LinkedTxn = new \QuickBooks_IPP_Object_LinkedTxn();
				$LinkedTxn->setTxnId($q_invoiceid);
				$LinkedTxn->setTxnType('Invoice');
				$Line->setLinkedTxn($LinkedTxn);
				$Payment->addLine($Line);
				$Payment->setCustomerRef($q_customerid);

				//Log::info('-- Invoice Object --'.print_r($Invoice,true));

				if ($resp = $PaymentService->add($Context, $realm, $Payment)) {
					if (!empty($resp)) {
						$resp = str_replace('{-', '', $resp);
						$resp = str_replace('}', '', $resp);
					}

					/**
					 * Insert Data in QuickBookLog
					 */
					$quickbooklogdata = array();
					$quickbooklogdata['Note'] = $PaymentID . ' ' . QuickBookLog::$log_status[QuickBookLog::PAYMENT] . ' (Quickbookid : ' . $resp . ') Created';
					$quickbooklogdata['created_at'] = date("Y-m-d H:i:s");
					$quickbooklogdata['Type'] = QuickBookLog::PAYMENT;
					QuickBookLog::insert($quickbooklogdata);

					Log::info('-- Create Payment id (Quickbook) --' . print_r($resp, true));

					$response['Success'] = $PaymentID . '(Payment) is created';
				} else {
					$response['error'] = $PaymentID . '(Payment) is failed To create';
					$response['error_reason'] = $PaymentService->lastError($Context);
					Log::info('-- Create Payment Error --' . print_r($PaymentService->lastError($Context), true));
				}
			}
			else {
				$response['error'] = $PaymentID . '(Payment) is failed To create';
				$response['error_reason'] = 'Invoice Not Found in Quickbook';
			}
		}
		Log::info('-- Create Payment Done --');
		//Log::info(print_r($response,true));
		return $response;
	}

	public function addInvoices($Options){
		Log::info('-- QuickBook Add Inovice --');
		$response = array();
		if ($this->is_quickbook($Options['CompanyID'])){
			if ($this->quickbooks_is_connected) {
				$Invoices = $Options['Invoices'];

				if(!empty($Invoices) && count($Invoices)>0){
					foreach($Invoices as $Invoice){
						if(!empty($Invoice))
							$response[] = $this->CreateInvoice($Invoice);
					}
				}
			}
		}
		Log::info('-- QuickBook End Inovice --');
		return $response;
	}

	public function CreateInvoice($InvoiceID){
		//$InvoiceID = '62987';
		Log::info('Invoice ID : '.print_r($InvoiceID,true));
		$response = array();
		$Invoices = Invoice::find($InvoiceID);
		$InvoiceFullNumber = $Invoices->FullInvoiceNumber;
		$count = $this->CheckInvoice($InvoiceFullNumber);
		Log::info('-- count --'.print_r($count,true));
		if(isset($count) && $count==0) {
			Log::info('-- Create Invoice --'.print_r($InvoiceFullNumber,true));
			$Context = $this->Context;
			$realm = $this->realm;

			$CustomerID = $this->getCustomerId($Invoices->AccountID);

			$InvoiceService = new \QuickBooks_IPP_Service_Invoice();

			$Invoice = new \QuickBooks_IPP_Object_Invoice();
			$date = date('Y-m-d');
			$Invoice->setDocNumber($InvoiceFullNumber);
			$Invoice->setTxnDate($date);

			$InvoiceDetails = InvoiceDetail::where(["InvoiceID" => $InvoiceID])->get();

			if(!empty($InvoiceDetails) && count($InvoiceDetails)>0){
				foreach($InvoiceDetails as $InvoiceDetail){
					Log::info('Product id'.$InvoiceDetail->ProductID);
					Log::info('Product Type'.$InvoiceDetail->ProductType);
					$ItemID = '';
					$ProductID = $InvoiceDetail->ProductID;
					$ProductType = $InvoiceDetail->ProductType;
					if(!empty($ProductType) && $ProductType != 5){
						$ProductName = Product::getProductName($ProductID,$ProductType);
						$ItemID = $this->getItemId($ProductName);
						if(empty($ItemID)){
							$response['error'] = $InvoiceFullNumber.'(Invoice) is failed To create';
							$response['error_reason'] = $ProductName.'(Item Not created in quickbook)';
							return $response;
						}
					}
					//$invoicetaxid = $InvoiceDetail->TaxRateID;
					$amount =  $InvoiceDetail->LineTotal;
					$UnitePrise = $InvoiceDetail->Price;
					$Qty = $InvoiceDetail->Qty;
					$Description = $InvoiceDetail->Description;

					$Line = new \QuickBooks_IPP_Object_Line();
					$Line->setDetailType('SalesItemLineDetail');
					$Line->setAmount($amount);
					$Line->setDescription($Description);

					$SalesItemLineDetail = new \QuickBooks_IPP_Object_SalesItemLineDetail();
					$SalesItemLineDetail->setItemRef($ItemID);
					$SalesItemLineDetail->setUnitPrice($UnitePrise);
					$SalesItemLineDetail->setQty($Qty);

					//$InvoiceTaxRates = InvoiceTaxRate::where(["InvoiceID" => $InvoiceID,"TaxRateID" => $invoicetaxid])->get();
					$InvoiceTaxRates = InvoiceTaxRate::where(["InvoiceID" => $InvoiceID])->get();

					if(!empty($InvoiceTaxRates) && count($InvoiceTaxRates)>0) {
						$Memo = 'Sales Tax Included ';
						//if inline item contain tax
						$SalesItemLineDetail->setTaxCodeRef('TAX');

						foreach ($InvoiceTaxRates as $InvoiceTaxRate) {
							$Title = $InvoiceTaxRate->Title;
							//for multiple tax try
							//$TaxId = $this->GetTaxDetail($Title);
							//$TaxRateId = $this->GetTaxRateDetail($Title);
/*
							if (empty($TaxId)) {
								$response['error'] = $InvoiceFullNumber . '(Invoice) is failed To create';
								$response['error_reason'] = $Title . '(Tax Not created in quickbook)';
								return $response;
							}
*/
/*
							$TaxLine = new \QuickBooks_IPP_Object_TaxLine();
							$TaxLine->setDetailType('TaxLineDetail');
							$TaxLine->setAmount($InvoiceTaxRate->TaxAmount);

							$Memo .= ' '.$Title .'=>'.$InvoiceTaxRate->TaxAmount;
							$TaxLineDetail = new \QuickBooks_IPP_Object_TaxLineDetail();
							$TaxLineDetail->setTaxRateRef($TaxRateId);
							$TaxLineDetail->setPerCentBased('false');
							//$TaxLineDetail->setTaxPercent(8);
							//$TaxLineDetail->setNetAmountTaxable($total);
							$TaxLine->addTaxLineDetail($TaxLineDetail);
							$TaxLineDetail->addLine($TaxLine);*/

							//for multiple tax try
							//$TaxAmount[] = $InvoiceTaxRate->TaxAmount;
							$TaxAmount = $InvoiceTaxRate->TaxAmount;
						}
					}

					$Invoice->setCustomerMemo($Memo);
					$Invoice->setPrivateNote($Memo);

					$Line->addSalesItemLineDetail($SalesItemLineDetail);
					$Invoice->addLine($Line);

				}
			}

			$TaxId = $this->GetTaxDetail($Title);
			if (empty($TaxId)) {
				$response['error'] = $InvoiceFullNumber . '(Invoice) is failed To create';
				$response['error_reason'] = $Title . '(Tax Not created in quickbook)';
				return $response;
			}
			//for multiple tax try
			//$TotalSalesTax = array_sum($TaxAmount);
			$TotalSalesTax = $TaxAmount;
			//Log::info('-- $TotalSalesTax  --'.print_r($TotalSalesTax,true));
			$TxnTaxDetail = new \QuickBooks_IPP_Object_TxnTaxDetail();
			$TxnTaxDetail->setTxnTaxCodeRef($TaxId);
			$TxnTaxDetail->setTotalTax($TotalSalesTax);
			$Invoice->addTxnTaxDetail($TxnTaxDetail);

			$SalesTax = new \QuickBooks_IPP_Object_SalesTax();
			$SalesTax->setTaxable('true');
			$SalesTax->setSalesTaxCodeId($TaxId);
			$Invoice->addSalesTax($TotalSalesTax);

			$Invoice->setCustomerRef($CustomerID);

			//Log::info('-- Invoice Object --'.print_r($Invoice,true));

			if ($resp = $InvoiceService->add($Context, $realm, $Invoice))
			{
				if(!empty($resp)){
					$resp = str_replace('{-','',$resp);
					$resp = str_replace('}','',$resp);
				}

				/**
				 * Insert Data in InvoiceLog
				 */
				$invoiceloddata = array();
				$invoiceloddata['InvoiceID'] = $InvoiceID;
				$invoiceloddata['Note'] = InvoiceLog::$log_status[InvoiceLog::POST].' ('.$resp.') By RMScheduler';
				$invoiceloddata['created_at'] = date("Y-m-d H:i:s");
				$invoiceloddata['InvoiceLogStatus'] = InvoiceLog::POST;
				InvoiceLog::insert($invoiceloddata);

				$Invoices->update(['InvoiceStatus' => Invoice::POST]);

				/**
				 * Insert Data in QuickBookLog
				 */
				$quickbooklogdata = array();
				$quickbooklogdata['Note'] = $InvoiceID.' '.QuickBookLog::$log_status[QuickBookLog::INVOICE].' (Quickbookid : '.$resp.') Created';
				$quickbooklogdata['created_at'] = date("Y-m-d H:i:s");
				$quickbooklogdata['Type'] = QuickBookLog::INVOICE;
				QuickBookLog::insert($quickbooklogdata);

				Log::info('-- Create Invoice id --'.print_r($resp,true));
				Log::info('-- Create Invoice Number --'.print_r($Invoice->getDocNumber(),true));

				$response['Success'] = $Invoice->getDocNumber(). '(Invoice) is created';
			}
			else
			{
				$response['error'] = $InvoiceFullNumber.'(Invoice) is failed To create';
				$response['error_reason'] = $InvoiceService->lastError($Context);
				Log::info('-- Create Invoice Error --'.print_r($InvoiceService->lastError($Context),true));
			}
		}elseif(isset($count) && $count>0){
			$response['Success'] =$InvoiceFullNumber. '(Invoice) is already created';
		}
		Log::info('-- Create Invoice Done --');
		//Log::info(print_r($response,true));
		return $response;
	}

	public function CheckInvoice($InvoiceFullNumber){
		Log::info('CheckInvoice : '.$InvoiceFullNumber);
		$InvoiceService = new \QuickBooks_IPP_Service_Invoice();

		$Context = $this->Context;
		$realm = $this->realm;

		$invoicecount = $InvoiceService->query($Context, $realm, "SELECT count(*) FROM Invoice WHERE DocNumber = '".$InvoiceFullNumber."' ");
		return $invoicecount;
	}


	public function GetTaxDetail($TaxName){
		Log::info('Check Tax : '.$TaxName);

		$TaxId = '';

		$TaxCodeService = new \QuickBooks_IPP_Service_TaxCode();

		$Context = $this->Context;
		$realm = $this->realm;

		$taxcodes = $TaxCodeService->query($Context, $realm, "SELECT * FROM TaxCode WHERE Name = '".$TaxName."' ");

		if(!empty($taxcodes)){
			$taxcodes = $taxcodes[0];
			$TaxId = $taxcodes->getId();
			//$TaxId = str_replace('{-','',$TaxId);
			//$TaxId = str_replace('}','',$TaxId);
		}
		Log::info('Tax Id : '.$TaxId);
		//Log::info(print_r($taxcodes,true));
		return $TaxId;
	}

	public function GetTaxRateDetail($TaxName){
		Log::info('Check Tax Rate: '.$TaxName);

		$TaxRateId = '';

		$TaxCodeService = new \QuickBooks_IPP_Service_TaxCode();

		$Context = $this->Context;
		$realm = $this->realm;

		$taxrates = $TaxCodeService->query($Context, $realm, "SELECT * FROM TaxRate WHERE Name = '".$TaxName."' ");

		if(!empty($taxrates)){
			$taxrates = $taxrates[0];
			$TaxRateId = $taxrates->getId();
			//$TaxId = str_replace('{-','',$TaxId);
			//$TaxId = str_replace('}','',$TaxId);
		}
		Log::info('Tax Rate Id : '.$TaxRateId);
		//Log::info(print_r($taxcodes,true));
		return $TaxRateId;
	}

	public function addJournals($Options){
		Log::info('-- QuickBook Add Journal --');
		$response = array();
		$error = array();
		$success = array();
		$Journal = array();
		if ($this->is_quickbook($Options['CompanyID'])){
			if ($this->quickbooks_is_connected) {
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

						if(!empty($NewPaidInvoices) && count($NewPaidInvoices)>0){
							// Check Invoice and Payment Mapping

							$QuickBookMappingError=$this->checkQuickBookMapping($CompanyID,$PaidInvoices);
							if (!empty($QuickBookMappingError) && count($QuickBookMappingError)>0) {
								foreach ($QuickBookMappingError as $err) {
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

							} // quickbook mapping over
						} // newpaidinvoice over

						// End Create Journal
					}else{
						$error[] = 'Journal creation failed ';
					}
				} //invoice loop over
			}
		}
		$response['error'] = $error;
		$response['Success'] = $success;
		Log::info('-- QuickBook End Journal --');
		//log::info('Final Response');
		//log::info(print_r($response,true));

		return $response;
	}

	public function createJournal($JournalDate,$Invoices,$CompanyID){
		log::info(print_r($Invoices,true));
		$response = array();
		$error = array();
		$success = array();
		$JournalError = array();
		if(!empty($Invoices) && count($Invoices)>0){

			$QuickBookData		=	SiteIntegration::CheckIntegrationConfiguration(true,SiteIntegration::$QuickBookSlug,$CompanyID);

			$QuickBookData = json_decode(json_encode($QuickBookData),true);

			log::info(print_r($QuickBookData,true));
			$InvoiceAccountID = '';
			$PaymentAccountID = '';
			$TaxId = '';

			if(!empty($QuickBookData['InvoiceAccount'])){
				$InvoiceAccountID = $this->getQuickBookAccountantId($QuickBookData['InvoiceAccount']);
				if(empty($InvoiceAccountID)){
					$error[]='Invoice Mapping not setup correctly';
				}
			}else{
				$error[]='Invoice Mapping not setup in integration section';
			}

			if(!empty($QuickBookData['PaymentAccount'])){
				$PaymentAccountID = $this->getQuickBookAccountantId($QuickBookData['PaymentAccount']);
				if(empty($PaymentAccountID)){
					$error[]='Payment Mapping not setup correctly';
				}
			}else{
				$error[]='Payment Mapping not setup in integration section';
			}

			$Context = $this->Context;
			$realm = $this->realm;

			$JournalNumber = 'Neon'.date('Y').date('m').date('d').date('H').date('i').date('s');
			//log::info('Journal Number'.$JournalNumber);

			$JournalEntryService = new \QuickBooks_IPP_Service_JournalEntry();

			// Main journal entry object
			$JournalEntry = new \QuickBooks_IPP_Object_JournalEntry();
			$JournalEntry->setDocNumber($JournalNumber);
			$JournalEntry->setTxnDate($JournalDate);
			//$JournalEntry->setTxnDate(date('Y-m-d'));

			foreach($Invoices as $Invoice){

				$InvoiceData = array();

				$InvoiceData = Invoice::find($Invoice);

				$RoundChargesAmount = Helper::get_round_decimal_places($InvoiceData->CompanyID,$InvoiceData->AccountID,$InvoiceData->ServiceID);

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
				$InvoiceFullNumber = $InvoiceData->FullInvoiceNumber;
				//$InvoiceGrantTotal = number_format($InvoiceData->GrandTotal,$RoundChargesAmount);
				$PaymentTotal = number_format($InvoiceData->SubTotal,$RoundChargesAmount, '.', '');
				$InvoiceTaxRateAmount = Invoice::getInvoiceTaxRateAmount($Invoice,$RoundChargesAmount);
				$InvoiceGrantTotal = $PaymentTotal + $InvoiceTaxRateAmount;

				//Debit Section

				if(!empty($InvoiceAccountID)){
					$invoicedescription = $InvoiceFullNumber.' (Invoice)';
					$Line1 = new \QuickBooks_IPP_Object_Line();
					$Line1->setDescription($invoicedescription);
					$Line1->setAmount($InvoiceGrantTotal);
					$Line1->setDetailType('JournalEntryLineDetail');

					$Detail1 = new \QuickBooks_IPP_Object_JournalEntryLineDetail();
					$Detail1->setPostingType('Debit');
					$Detail1->setAccountRef($InvoiceAccountID);

					if(!empty($CustomerID)){
						$customer = new \QuickBooks_IPP_Object_Entity();
						$customer->setEntityRef($CustomerID);

						$Detail1->setEntity($customer);
					}

					$Line1->addJournalEntryLineDetail($Detail1);
					$JournalEntry->addLine($Line1);
				}

				//Credit Section

				if(!empty($PaymentAccountID)){
					$paymentdescription = $InvoiceFullNumber.' (Payment)';
					$Line2 = new \QuickBooks_IPP_Object_Line();
					$Line2->setDescription($paymentdescription);
					$Line2->setAmount($PaymentTotal);
					$Line2->setDetailType('JournalEntryLineDetail');

					$Detail2 = new \QuickBooks_IPP_Object_JournalEntryLineDetail();
					$Detail2->setPostingType('Credit');
					$Detail2->setAccountRef($PaymentAccountID);

					if(!empty($CustomerID)) {
						$customer1 = new \QuickBooks_IPP_Object_Entity();
						$customer1->setEntityRef($CustomerID);
						$Detail2->setEntity($customer1);
					}

					$Line2->addJournalEntryLineDetail($Detail2);
					$JournalEntry->addLine($Line2);
				}

				$InvoiceTaxRates = InvoiceTaxRate::where(["InvoiceID" => $Invoice])->get();

				if(!empty($InvoiceTaxRates) && count($InvoiceTaxRates)>0) {
					foreach ($InvoiceTaxRates as $InvoiceTaxRate) {
						$Title = $InvoiceTaxRate->Title;
						$TaxRateID = $InvoiceTaxRate->TaxRateID;
						$TaxAmount = number_format($InvoiceTaxRate->TaxAmount,$RoundChargesAmount, '.', '');
						//$Title = str_replace(' ','',$Title);
						log::info($Title);
						//$QuickBookData['Tax'][];

						if(!empty($QuickBookData['Tax'][$TaxRateID])){
							$TaxId = $this->getQuickBookAccountantId($QuickBookData['Tax'][$TaxRateID]);
						}

						if(empty($TaxId)){
							$error[] = $Title. '(Tax Mapping not) setup correctly';
						}else{
							$taxdescription = $InvoiceFullNumber.' '.$Title.' (Tax)';
							$Line = new \QuickBooks_IPP_Object_Line();
							$Line->setDescription($taxdescription);
							$Line->setAmount($TaxAmount);
							$Line->setDetailType('JournalEntryLineDetail');

							$Detail = new \QuickBooks_IPP_Object_JournalEntryLineDetail();
							$Detail->setPostingType('Credit');
							$Detail->setAccountRef($TaxId);
							if(!empty($CustomerID)) {
								$customer = new \QuickBooks_IPP_Object_Entity();
								$customer->setEntityRef($CustomerID);
								$Detail->setEntity($customer);
							}

							$Line->addJournalEntryLineDetail($Detail);
							$JournalEntry->addLine($Line);
						}

					}
				}

			}
			if(empty($error) && count($error)==0){
				log::info('No error');
				log::info(print_r($JournalEntry,true));
				if ($resp = $JournalEntryService->add($Context, $realm, $JournalEntry))
				{
					if(!empty($resp)){
						$resp = str_replace('{-','',$resp);
						$resp = str_replace('}','',$resp);
					}

					foreach($Invoices as $Invoice){
						$jernalmsg = '';
						$InvoiceLog = Invoice::find($Invoice);
						$InvoiceFullNumber = $InvoiceLog->FullInvoiceNumber;

						//$JournalError = $this->checkInvoiceInJournale($Invoice);
						if(!empty($JournalError) && count($JournalError)>0){
							if(!empty($JournalError[$Invoice])){
								$jernalmsg = $JournalError[$Invoice];
							}
						}


						$success[] = 'Invoice No:'.$InvoiceFullNumber.' posted to journal '.$jernalmsg;
						/**
						 * Insert Data in InvoiceLog
						 */
						$invoiceloddata = array();
						$invoiceloddata['InvoiceID'] = $Invoice;
						$invoiceloddata['Note'] = InvoiceLog::$log_status[InvoiceLog::POST].' (Journal Number : '.$JournalNumber.') By RMScheduler';
						$invoiceloddata['created_at'] = date("Y-m-d H:i:s");
						$invoiceloddata['InvoiceLogStatus'] = InvoiceLog::POST;
						InvoiceLog::insert($invoiceloddata);

						$InvoiceLog->update(['InvoiceStatus' => Invoice::POST]);

						/**
						 * Insert Data in QuickBookLog
						 */
						$quickbooklogdata = array();
						$quickbooklogdata['Note'] = $Invoice.' '.QuickBookLog::$log_status[QuickBookLog::INVOICE].' (Journal Number : '.$JournalNumber.' Journal Id : '.$resp.') Created';
						$quickbooklogdata['created_at'] = date("Y-m-d H:i:s");
						$quickbooklogdata['Type'] = QuickBookLog::INVOICE;
						QuickBookLog::insert($quickbooklogdata);
					}
					$success[] = $JournalDate.' Journal created (Journal Number '.$JournalNumber.' )';
					//$response['response'] = $resp;
				}
				else
				{
					$error[] = $JournalDate.' Journal creation failed '.$JournalEntryService->lastError($Context);
				}

			}else{
				$error[] = $JournalDate.' Journal creation failed ';
			}

		}
		//log::info('Journal Error '.print_r($error,true));
		//log::info('Journal Success '.print_r($success,true));
		$response['error'] = array_unique($error);
		$response['Success'] = $success;
		//log::info('Journal Response '.print_r($response,true));
		return $response;

	}

	public function getQuickBookAccountantId($AccountName){
		log::info('Accountant Check : '.$AccountName);
		$AccountID = '';
		$Context = $this->Context;

		$realm = $this->realm;

		$AccountService = new \QuickBooks_IPP_Service_Account();

		$Accounts = $AccountService->query($Context, $realm, "SELECT * FROM Account WHERE Name = '".$AccountName."' ");

		if(!empty($Accounts)){
			$Accounts = $Accounts[0];
			$AccountID = $Accounts->getId();
			$AccountID = str_replace('{-','',$AccountID);
			$AccountID = str_replace('}','',$AccountID);
		}

		log::info('Accountant Id : '.$AccountID);

		return $AccountID;
	}

	public function checkInvoiceInJournale($InvoiceID){
		$response = '';
		log::info('Check Invoice Alreday in Journal');
		$Invoice = Invoice::find($InvoiceID);
		$InvoiceFullNumber = $Invoice->FullInvoiceNumber;
		$invoicedescription = $InvoiceFullNumber.' (Invoice)';
		log::info(print_r($invoicedescription,true));
		$Context = $this->Context;

		$realm = $this->realm;
		$JournalEntryService = new \QuickBooks_IPP_Service_JournalEntry();
		$ErrorNumbers = '';

		$lists = $JournalEntryService->query($Context, $realm, "SELECT * FROM JournalEntry");
		if(!empty($lists) && count($lists)>0){
			foreach((array)$lists as $list){
				$lid = $list->getId();
				if(!empty($lid)){
					$DocNumber = $list->getDocNumber();
					$id = $list->getId();
					$id = str_replace('{-','',$id);
					$id = str_replace('}','',$id);
					//log::info('Id'.$id);
					$Line = $list->getLine();
					if(!empty($Line) && count($Line)>0){
						$description = $Line->getDescription();
						if(!empty($description)){
							if($description == $invoicedescription){
								//$error = $InvoiceFullNumber.' already added in journal number '.$DocNumber;
								//$response['journalerror'][] = $error;
								//$test = $id.' '.$DocNumber.' '.$description;
								//log::info(print_r($error,true));
								$ErrorNumbers = $ErrorNumbers.$DocNumber.',';
							}
						}
					}
				}
			}
		}
		if(isset($ErrorNumbers) && $ErrorNumbers!=''){
			$ErrorNumbers=rtrim($ErrorNumbers,',');
			$response = '(Warning: Invoice already exits against Journal:'.$ErrorNumbers.')';
		}
		//log::info(print_r($list,true));
		log::info(print_r($response,true));
		log::info('Check Invoice Alreday in Journal Over');
		return $response;
	}

	public function checkQuickBookMapping($CompanyID,$PaidInvoices){
		$error=array();
		$QuickBookData		=	SiteIntegration::CheckIntegrationConfiguration(true,SiteIntegration::$QuickBookSlug,$CompanyID);
		$QuickBookData = json_decode(json_encode($QuickBookData),true);
		if(!empty($QuickBookData['InvoiceAccount'])){
			$InvoiceAccountID = $this->getQuickBookAccountantId($QuickBookData['InvoiceAccount']);
			if(empty($InvoiceAccountID)){
				$error[]='Invoice Mapping not setup correctly';
			}
		}else{
			$error[]='Invoice Mapping not setup in integration section';
		}
		if(!empty($QuickBookData['PaymentAccount'])){
			$PaymentAccountID = $this->getQuickBookAccountantId($QuickBookData['PaymentAccount']);
			if(empty($PaymentAccountID)){
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

					if(!empty($QuickBookData['Tax'][$TaxRateID])){
						$TaxId = $this->getQuickBookAccountantId($QuickBookData['Tax'][$TaxRateID]);
					}
					if(empty($TaxId)){
						$error[] = $Title. '(Tax Mapping not) setup correctly';
					}
				}
			}
		}
		return $error;
	}


	public function getAllCustomer($AccountID){

		$Account = Account::find($AccountID);
		$AccountName = $Account->AccountName;
		log::info('Check Account Name '.$AccountName);
		$customers = array();
		$Context = $this->Context;
		$realm = $this->realm;

		$CustomerID = '';
		$CustomerService = new \QuickBooks_IPP_Service_Customer();

		if (strpos($AccountName, "'") !== false) {
			log::info('sinqle quoute exit');
		}

		$customers = $CustomerService->query($Context, $realm, "SELECT * FROM Customer MAXRESULTS 1000");
		/***
		if(!empty($customers) && count($customers)>0) {
			foreach ((array)$customers as $customer) {
				//print_r($Item);
				if($AccountName == $customer->getDisplayName()){
					log::info('Check Quickbook Account name '.$customer->getDisplayName());
					$CustomerID = $customer->getId();
					$CustomerID = str_replace('{-', '', $CustomerID);
					$CustomerID = str_replace('}', '', $CustomerID);
					log::info('Check Account Id '.$CustomerID);
					return $CustomerID;
				}
			}
		}
		return ''; */

		return $customers;
	}

	public function updateCustomer($AccountID){

		$Account = Account::find($AccountID);
		$AccountName = $Account->AccountName;
		log::info('Check Account Name '.$AccountName);
		$customers = array();
		$Context = $this->Context;
		$realm = $this->realm;

		$CustomerID = '';
		$CustomerService = new \QuickBooks_IPP_Service_Customer();

		$Customer = new \QuickBooks_IPP_Object_Customer();

		//$Customer->setDisplayName($AccountName);

		//$resp = $CustomerService->add($Context, $realm, $Customer)
		/*
		if (strpos($AccountName, "'") !== false) {
			log::info('sinqle quoute exit');
		}*/

		$customers = $CustomerService->query($Context, $realm, "SELECT * FROM Customer WHERE CompanyName = '".$AccountName."' ");
		$Customer = $customers[0];
		$Customer->setDisplayName($AccountName);
		$CustomerService->update($Context, $realm, $Customer->getId(), $Customer);
		return $customers;
		/*
		if(!empty($customers) && count($customers)>0) {
			foreach ((array)$customers as $customer) {
				//print_r($Item);
				if($AccountName == $customer->getDisplayName()){
					log::info('Check Quickbook Account name '.$customer->getDisplayName());
					$CustomerID = $customer->getId();
					$CustomerID = str_replace('{-', '', $CustomerID);
					$CustomerID = str_replace('}', '', $CustomerID);
					log::info('Check Account Id '.$CustomerID);
					return $CustomerID;
				}
			}
		}
		return '';*/

	}

}