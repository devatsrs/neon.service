<?php
/**
 * Created by PhpStorm.
 * User: CodeDesk
 * Date: 26/07/2017
 * Time: 12:00 PM
 */

namespace App\Lib;

use Cartalyst\Stripe\Laravel\Facades\Stripe;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Log;

class StripeACH {

	protected $CompanyID;
	var $status ;
	var $stripe_secret_key;
	var $stripe_publishable_key;


	function __Construct($CompanyID){
		$is_stripe = SiteIntegration::CheckIntegrationConfiguration(true, SiteIntegration::$StripeACHSlug,$CompanyID);
		if(!empty($is_stripe)){
			$this->stripe_secret_key = $is_stripe->SecretKey;
			$this->stripe_publishable_key = $is_stripe->PublishableKey;

			/**
			 * Whenever you need work with stripe first we need to set key and version in services config
			 */

			Config::set('services.stripe.secret', $is_stripe->SecretKey);
			Config::set('services.stripe.version', '2016-07-06');
			$this->status = true;;
		}else{
			$this->status = false;
		}
    }

	public function test_connection($CompanyID)
	{
		$response = 'connection fail';
		if ($this->status){
			$response = 'conection done';
		}
		return $response;
	}

	public static function createchargebycustomer($data)
	{
		$response = array();
		$token = array();
		$charge = array();
		try{

			$charge = Stripe::charges()->create([
				'amount' => $data['amount'], // $10
				'currency' => $data['currency'],
				'description' => $data['description'],
				'customer' => $data['customerid'],
				'capture'=>true
			]);

			//log::info(print_r($charge,true));

			if(empty($charge['failure_message'])){
				$response['response_code'] = 1;
				$response['status'] = 'Success';
				$response['id'] = $charge['id'];
				$response['note'] = 'Stripe transaction_id '.$charge['id'];
				$Amount = ($charge['amount']/100);
				$response['amount'] = $Amount;
				$response['response'] = $charge;
			}else{
				$response['status'] = 'fail';
				$response['error'] = $charge['failure_message'];
			}


		} catch (Exception $e) {
			Log::error($e);
			//return ["return_var"=>$e->getMessage()];
			$response['status'] = 'fail';
			$response['error'] = $e->getMessage();
		}

		return $response;

	}

	public static function findcharge($data){
		$charge = Stripe::charges()->find('py_1AjjaRCLEhHAk25Ku7dwa3AG');
		return $charge;
	}



}