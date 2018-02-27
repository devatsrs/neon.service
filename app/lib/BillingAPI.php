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

class BillingAPI {

	protected $request ;
	protected $quickbooks_is_connected = false;

	function __Construct($CompanyID){

		if($this->check_quickbook($CompanyID)){
			$this->request = new QuickBook($CompanyID);
		}
	}

	public function test_connection($CompanyID)
	{
		/* Check Connection default return Company Info */
		if($this->quickbooks_is_connected){
			/* check Authantication and connect api */

			return $this->request->test_connection($CompanyID);
		}
		return false;
	}

	public function quickbook_disconnect(){
		/* Check Connection default return Company Info */
		if($this->quickbooks_is_connected){
			/* check Authantication and connect api */

			$this->request->quickbook_disconnect();
		}
		return false;
	}

	public function quickbook_connect(){
		if($this->quickbooks_is_connected){
			/* check Authantication and connect api */

			$this->request->quickbook_connect();
		}
		return false;
	}

	public function addCustomers($Options)
	{
		if($this->quickbooks_is_connected){
			/* check Authantication and connect api */

			return $this->request->addCustomers($Options);
		}
		return false;
	}

	public function check_quickbook($CompanyID){
		$QuickBookData		=	SiteIntegration::CheckIntegrationConfiguration(true,SiteIntegration::$QuickBookSlug,$CompanyID);
		Log::info('-- Check QuickBook --');
		if(!$QuickBookData){
			$this->quickbooks_is_connected = false;
			Log::info('-- QuickBook Integration Not setup --');
			return false;
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
				/*Only check quickbooks_is_connected*/
				$this->oauth_consumer_key = $OauthConsumerKey;
				$this->oauth_consumer_secret = $OauthConsumerSecret;
				$this->token = $AppToken;
				$this->sandbox = $QuickBookSandbox;

				$this->quickbooks_oauth_url = 'http://localhost/bhavin/neon/web/newbhavin/public/quickbook/oauth';
				$this->quickbooks_success_url = 'http://localhost/bhavin/neon/web/newbhavin/public/quickbook/success';
				$this->quickbooks_menu_url = 'http://localhost/bhavin/neon/web/newbhavin/public/quickbook';
				$this->dsn = 'mysqli://root:root@localhost/LocalRatemanagement';
				$this->encryption_key = 'bcde1234';
				$this->the_username = 'DO_NOT_CHANGE_ME'.$CompanyID;
				$this->the_tenant = 12345;
				$this->quickbooks_is_connected = true;
				Log::info('-- QuickBook Integration Setup Done --');
				return true;
			}else{
				$this->quickbooks_is_connected = false;
				Log::info('-- QuickBook Integration Not setup --');
				return false;
			}
		}
	}

	public function is_quickbook(){
		if($this->quickbooks_is_connected){
			if (!QuickBooks_Utilities::initialized($this->dsn)) {
				// Initialize creates the neccessary database schema for queueing up requests and logging
				QuickBooks_Utilities::initialize($this->dsn);
			}
			$IntuitAnywhere = new QuickBooks_IPP_IntuitAnywhere($this->dsn, $this->encryption_key, $this->oauth_consumer_key, $this->oauth_consumer_secret, $this->quickbooks_oauth_url, $this->quickbooks_success_url);

			if ($IntuitAnywhere->check($this->the_username, $this->the_tenant) and
				$IntuitAnywhere->test($this->the_username, $this->the_tenant)
			) {
				// Yes, they are
				$this->quickbooks_is_connected = true;
				$IPP = new QuickBooks_IPP($this->dsn);

				// Get our OAuth credentials from the database
				$creds = $IntuitAnywhere->load($this->the_username, $this->the_tenant);

				// Tell the framework to load some data from the OAuth store
				$IPP->authMode(
					QuickBooks_IPP::AUTHMODE_OAUTH,
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

				return true;
			}else{
				$this->quickbooks_is_connected = false;
				return false;
			}
		}else{
			return false;
		}
	}

	public function addItems($Options){
		if($this->quickbooks_is_connected){
			/* check Authantication and connect api */

			return $this->request->addItems($Options);
		}
		return false;
	}

	public function addInvoices($Options){
		if($this->quickbooks_is_connected){
			/* check Authantication and connect api */

			return $this->request->addInvoices($Options);
		}
		return false;
	}

	public function addJournals($Options){
		if($this->quickbooks_is_connected){
			/* check Authantication and connect api */

			return $this->request->addJournals($Options);
		}
		return false;
	}

	public function getCustomerId($id){
		if($this->quickbooks_is_connected){
			/* check Authantication and connect api */

			return $this->request->getCustomerId($id);
		}
		return false;
	}

	public function getAllCustomer($id){
		if($this->quickbooks_is_connected){
			/* check Authantication and connect api */

			return $this->request->getAllCustomer($id);
		}
		return false;
	}

	public function updateCustomer($id){
		if($this->quickbooks_is_connected){
			/* check Authantication and connect api */

			return $this->request->updateCustomer($id);
		}
		return false;
	}
}