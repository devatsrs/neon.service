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

				$oauth_url = getenv("WEBURL") . '/quickbook/oauth';
				$success_url = getenv("WEBURL") . '/quickbook/success';
				$menu_url = getenv("WEBURL") . '/quickbook';

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

		$Context = $this->Context;
		$realm = $this->realm;

		$CustomerID = '';
		$CustomerService = new \QuickBooks_IPP_Service_Customer();

		$customers = $CustomerService->query($Context, $realm, "SELECT * FROM Customer WHERE DisplayName = '".$AccountName."' ");
		foreach ($customers as $customer)
		{
			//print_r($Item);

			$CustomerID = $customer->getId();
			$CustomerID = str_replace('{-','',$CustomerID);
			$CustomerID = str_replace('}','',$CustomerID);
		}

		return $CustomerID;
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

		$itemcount = $ItemService->query($Context, $realm, "SELECT count(*) FROM Item WHERE Name = '".$ProductName."' ");

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

			$Invoice->setDocNumber($InvoiceFullNumber);
			$Invoice->setTxnDate('2016-10-11');

			$InvoiceDetails = InvoiceDetail::where(["InvoiceID" => $InvoiceID])->get();

			if(!empty($InvoiceDetails) && count($InvoiceDetails)>0){
				foreach($InvoiceDetails as $InvoiceDetail){
					Log::info('Product id'.$InvoiceDetail->ProductID);
					Log::info('Product Type'.$InvoiceDetail->ProductType);
					$ItemID = '';
					$ProductID = $InvoiceDetail->ProductID;
					$ProductType = $InvoiceDetail->ProductType;
					if(!empty($ProductType)){
						$ProductName = Product::getProductName($ProductID,$ProductType);
						$ItemID = $this->getItemId($ProductName);
						if(empty($ItemID)){
							$response['error'] = $InvoiceFullNumber.'(Invoice) is failed To create';
							$response['error_reason'] = $ProductName.'(Item Not created in quickbook)';
							return $response;
						}
					}

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

					$Line->addSalesItemLineDetail($SalesItemLineDetail);

					$Invoice->addLine($Line);

				}
			}

			$InvoiceTaxRates = InvoiceTaxRate::where("InvoiceID",$InvoiceID)->get();
			if(!empty($InvoiceTaxRates) && count($InvoiceTaxRates)>0){
				foreach($InvoiceTaxRates as $InvoiceTaxRate){
					$Title = $InvoiceTaxRate->Title;
					$ItemID = $this->getItemId($Title);
					if(empty($ItemID)){
						$response['error'] = $InvoiceFullNumber.'(Invoice) is failed To create';
						$response['error_reason'] = $Title.'(Item Not created in quickbook)';
						return $response;
					}
					$amount =$InvoiceTaxRate->TaxAmount;
					$UnitePrise =$InvoiceTaxRate->TaxAmount;
					$Qty = 1;

					$Line = new \QuickBooks_IPP_Object_Line();
					$Line->setDetailType('SalesItemLineDetail');
					$Line->setAmount($amount);

					$SalesItemLineDetail = new \QuickBooks_IPP_Object_SalesItemLineDetail();
					$SalesItemLineDetail->setItemRef($ItemID);
					$SalesItemLineDetail->setUnitPrice($UnitePrise);
					$SalesItemLineDetail->setQty($Qty);

					$Line->addSalesItemLineDetail($SalesItemLineDetail);

					$Invoice->addLine($Line);
				}
			}

			/*
			 example
			$Line1 = new \QuickBooks_IPP_Object_Line();
			$Line1->setDetailType('SalesItemLineDetail');
			$Line1->setAmount(20.0000 * 1.0000 * 0.516129);
			$Line1->setDescription('Test description goes here.');

			$SalesItemLineDetail1 = new \QuickBooks_IPP_Object_SalesItemLineDetail();
			$SalesItemLineDetail1->setItemRef('25');
			$SalesItemLineDetail1->setUnitPrice(20 * 0.516129);
			$SalesItemLineDetail1->setQty(1.00000);

			$Line1->addSalesItemLineDetail($SalesItemLineDetail1);

			$Invoice->addLine1($Line1); */

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

}