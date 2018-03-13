<?php
/**
 * Created by PhpStorm.
 * User: CodeDesk
 * Date: 28/07/2017
 * Time: 5:00 PM
 */

namespace App\Lib;

use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\Log;

class PeleCard {

    public $request;
    var $status;
    var $terminalNumber;
    var $user;
    var $password;
    var $SandboxUrl;
    var $LiveUrl;
    var $PeleCardLive;
    var $PeleCardUrl;
    var $SaveCardUrl;
    var $DebitRegularType;
    var $ConvertToToken;

    function __Construct($CompanyID){
        $PeleCardobj = SiteIntegration::CheckIntegrationConfiguration(true,SiteIntegration::$PeleCardSlug,$CompanyID);
        if($PeleCardobj){
            $this->SandboxUrl       = "https://gateway20.pelecard.biz/services/";
            $this->LiveUrl          = "https://gateway20.pelecard.biz/services/";

            $this->terminalNumber 	= 	$PeleCardobj->terminalNumber;
            $this->user		        = 	$PeleCardobj->user;
            $this->password		    = 	Crypt::decrypt($PeleCardobj->password);
            $this->PeleCardLive     = 	$PeleCardobj->PeleCardLive;
            $this->DebitRegularType = 	"DebitRegularType";
            $this->ConvertToToken   = 	"ConvertToToken";

            if(intval($this->PeleCardLive) == 1) {
                $this->PeleCardUrl	= 	$this->LiveUrl.$this->DebitRegularType;
                $this->SaveCardUrl	= 	$this->LiveUrl.$this->ConvertToToken;
            } else {
                $this->PeleCardUrl	= 	$this->SandboxUrl.$this->DebitRegularType;
                $this->SaveCardUrl	= 	$this->SandboxUrl.$this->ConvertToToken;
            }

            $this->status           =   true;
        }else{
            $this->status           =   false;
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

    public function pay_invoice($data){
        try {
            //test params
            $creditCard         = "4111111111111111";
            $creditCardDateMmYy = "1219";
            $cvv2               = "123";
            $id                 = "123456789";
            $paramX             = "test";

            $Account            = Account::find($data['AccountID']);
            $CurrencyID         = $Account->CurrencyId;
            $InvoiceCurrency    = Currency::getCurrencyCode($CurrencyID);
            $currency           = "1";

            if(strtolower($InvoiceCurrency) != "ils") {
                if(strtolower($InvoiceCurrency) == "usd") {
                    $currency   = "2";
                } else if(strtolower($InvoiceCurrency) == "eur") {
                    $currency   = "978";
                } else if(strtolower($InvoiceCurrency) == "gbp") {
                    $currency   = "286";
                } else {
                    $currency   = "0";
                }
            }

            if(!empty($data['Token'])) {
                $token              = $data['Token'];
                $creditCard         = "";
                $creditCardDateMmYy = "";
            } else {
                $token              = "";
                $creditCard         = $data['CardNumber'];
                $creditCardDateMmYy = $data['ExpirationMonth'].substr($data['ExpirationYear'], -2);
            }

            $postdata = array(
                'terminalNumber'        => $this->terminalNumber,
                'user'                  => $this->user,
                'password'              => $this->password,
                'shopNumber'            => "001",
                'creditCard'            => $creditCard,
                'creditCardDateMmYy'    => $creditCardDateMmYy,
                'token'                 => $token,
                'total'                 => str_replace(',','',str_replace('.','',$data['GrandTotal'])),
                'currency'              => $currency,
                'cvv2'                  => $data['CVVNumber'],
                'id'                    => $data['AccountID'],
                'authorizationNumber'   => "",
                'paramX'                => $data['InvoiceNumber']
            );
            $jsonData = json_encode($postdata);

            try {
                $res = $this->sendCurlRequest($this->PeleCardUrl,$jsonData);
            } catch (\Guzzle\Http\Exception\CurlException $e) {
                log::info($e->getMessage());
                $response['status']         = 'fail';
                $response['error']          = $e->getMessage();
            }

            if(!empty($res['StatusCode']) && $res['StatusCode']=='000'){
                $response['status']         = 'success';
                $response['response_code']  = 1;
                $response['note']           = 'PeleCard transaction_id '.$res['ResultData']['PelecardTransactionId'];
                $response['transaction_id'] = $res['ResultData']['PelecardTransactionId'];
                $response['amount']         = $data['GrandTotal'];
                $response['response']       = $res;
            }else{
                $response['status']         = 'fail';
                $response['transaction_id'] = !empty($res['ResultData']['PelecardTransactionId']) ? $res['ResultData']['PelecardTransactionId'] : "";
                $response['error']          = $res['ErrorMessage'];
                $response['response']       = $res;
                Log::info(print_r($res,true));
            }
        } catch (Exception $e) {
            log::info($e->getMessage());
            $response['status']             = 'fail';
            $response['error']              = $e->getMessage();
        }
        return $response;
    }

    public function sendCurlRequest($url,$data) {
        $ch = curl_init($url);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
        curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json; charset=UTF-8', 'Content-Length: ' . strlen($data)));
        $result = curl_exec($ch);
        $res = json_decode($result, true);
        return $res;
    }

}