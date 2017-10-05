<?php
/**
 * Created by PhpStorm.
 * User: CodeDesk
 * Date: 28/07/2017
 * Time: 5:00 PM
 */

namespace App\Lib;

use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Log;

class FideliPay{

	protected $CompanyID;
	var $status ;
	var $SourceKey;
	var $Pin;
	var $FideliPayUrl;


	function __Construct($CompanyID){
		$FideliPayObj = SiteIntegration::CheckIntegrationConfiguration(true, SiteIntegration::$FideliPaySlug,$CompanyID);
		if(!empty($FideliPayObj)){
			$this->SourceKey 	            = 	$FideliPayObj->SourceKey;
			$this->Pin						= 	$FideliPayObj->Pin;
			$FideliPayUrl				    = CompanyConfiguration::get($CompanyID,'FIDELIPAY_WSDL_URL');
			$this->FideliPayUrl				= 	$FideliPayUrl;

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
	
	public function getClient(){
        $wsdl = $this->FideliPayUrl;
        return new \SoapClient($wsdl,array("trace"=>1,"exceptions"=>1));
    }
    public function getToken(){        
        $sourcekey = $this->SourceKey;
        $pin = $this->Pin;

		$ClientIP = get_client_ip();

        // generate random seed value
        $seed=time() . rand();

        // make hash value using sha1 function
        $clear= $sourcekey . $seed . $pin;
        $hash=sha1($clear);

        // assembly ueSecurityToken as an array
        $token=array(
            'SourceKey'=>$sourcekey,
            'PinHash'=>array(
                'Type'=>'sha1',
                'Seed'=>$seed,
                'HashValue'=>$hash
            ),
            'ClientIP'=>$ClientIP,
        );

        return $token;
    }

	public function createchargebycustomer($data)
	{
		$response = array();
		$client = $this->getClient();
		$token  = $this->getToken();

		try{
			$Parameters=array(
				'Command'=>'Sale',
				'Details'=>array(
					'Invoice' => $data['Invoice'],
					'PONum' => '',
					'OrderID' => '',
					'Description' => $data['Description'],
					'Amount'=>$data['Amount']
				)
			);

			$CustomerNumber=$data['CustomerNumber'];
			$PayMethod='0';

			$res=$client->runCustomerTransaction($token, $CustomerNumber, $PayMethod, $Parameters);

			log::info(print_r($res,true));

			if(!empty($res->ResultCode) && $res->ResultCode=='A'){
				$response['response_code'] = 1;
				$response['status'] = 'Success';
				$response['id'] = $res->RefNum;
				$response['note'] = 'Fidelipay transaction_id '.$res->RefNum;
				$Amount = ($res->AuthAmount);
				$response['amount'] = $Amount;
				$response['response'] = $res;
			}else{
				$response['status'] = 'fail';
				$response['error'] = $res->Error;
			}

		} catch (\Exception $e) {
			Log::error($e);
			//return ["return_var"=>$e->getMessage()];
			$response['status'] = 'fail';
			$response['error'] = $e->getMessage();
		}

		return $response;

	}
}