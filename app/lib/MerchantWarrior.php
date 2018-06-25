<?php
/**
 * Created by PhpStorm.
 * User: Badal
 * Date: 23/06/2018
 * Time: 04:30 PM
 */
namespace App\Lib;

use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\Log;

class MerchantWarrior {

    public $request;
    var $status;
    var $merchantUUID;
    var $apiKey;
    var $hash;
    var $SandboxUrl;
    var $LiveUrl;
    var $MerchantWarriorUrl;
    var $SaveCardUrl;


    function __Construct($CompanyID=0){
        $MerchantWarriorobj = SiteIntegration::CheckIntegrationConfiguration(true,SiteIntegration::$MerchantWarriorSlug,$CompanyID);
        if($MerchantWarriorobj){
            $this->SandboxUrl           = "https://base.merchantwarrior.com/post/";
            $this->LiveUrl              = "https://api.merchantwarrior.com/post/";
            $this->SandboxTokenUrl      = "https://base.merchantwarrior.com/token/";
            $this->LiveTokenUrl         = "https://api.merchantwarrior.com/token/";
            $this->merchantUUID 	    = 	$MerchantWarriorobj->merchantUUID;
            $this->apiKey		        = 	$MerchantWarriorobj->apiKey;
            $this->apiPassphrase		= 	$MerchantWarriorobj->apiPassphrase;
            $this->SaveCardUrl	        = 	$this->SandboxUrl; // change live url here
            $this->MerchantWarriorUrl   = 	$this->SandboxUrl; // change live url here
            $this->status               =   true;
        }else{
            $this->status               =   false;
        }
    }

    public function pay_invoice($data){
        try {

            $Account            = Account::find($data['AccountID']);
            $CurrencyID         = $Account->CurrencyId;
            $InvoiceCurrency    = Currency::getCurrencyCode($CurrencyID);

            //$data['GrandTotal'] = 70;
            if(is_int($data['GrandTotal'])) {
                $Amount = str_replace(',', '', str_replace('.', '', $data['GrandTotal']));
                $Amount = number_format((float)$Amount, 2, '.', '');
            }
            else{
                $Amount = number_format(round($data['GrandTotal']), 2, '.', ''); // for testing value must be .00
                //$Amount = $data['GrandTotal']; // for live
            }

            //generate hash as per reference in https://dox.merchantwarrior.com/?php#transaction-type-hash
            $hash = strtolower($this->apiPassphrase . $this->merchantUUID . $Amount . $InvoiceCurrency) ;
            $hash = md5($hash);

            $postdata = array(
                'method'                => 'processCard',
                'merchantUUID'          => $this->merchantUUID,
                'apiKey'                => $this->apiKey,
                'transactionAmount'     => $Amount,
                'transactionCurrency'   => $InvoiceCurrency,
                'transactionProduct'    => 'Invoice No.' . $data['InvoiceNumber'],
                'customerName'          => $Account->AccountName,
                'customerCountry'       => $Account->Country,
                'customerState'         => $Account->State,
                'customerCity'          => $Account->City,
                'customerAddress'       => $Account->Address1,
                'customerPostCode'      => $Account->PostCode,
                'customerPhone'         => $Account->Phone,
                'customerEmail'         => $Account->Email,
                'cardID'                => $data['cardID'],
                'hash'                  => $hash
            );

            try {
                $res = $this->sendCurlRequest($this->SandboxTokenUrl, $postdata);
            } catch (\Guzzle\Http\Exception\CurlException $e) {
                log::info($e->getMessage());
                $response['status']         = 'fail';
                $response['error']          = $e->getMessage();
            }

            if(!empty($res['status']) && $res['status']==1 && $res['responseData']['responseCode']==0){
                $response['status']         = 'success';
                $response['note']           = 'MerchantWarrior transaction_id '.$res['transactionID'];
                $response['transaction_id'] = $res['transactionID'];
                $response['response_code']  = 1;
                $response['amount']         = $res['responseData']['transactionAmount'];
                $response['response']       = $res;
            }else{
                $response['status']         = 'fail';
                $response['transaction_id'] = !empty($res['transactionID']) ? $res['transactionID'] : "";
                $response['error']          = $res['responseData']['responseMessage'];
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
        $curl = curl_init();
        curl_setopt($curl, CURLOPT_HEADER, false);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_URL, $url);
        curl_setopt($curl, CURLOPT_POST, true);
        curl_setopt($curl, CURLOPT_POSTFIELDS, http_build_query($data, '', '&'));

        $curl_response = curl_exec($curl);
        $error = curl_error($curl);

        // Check for CURL errors
        if (isset($error) && strlen($error)) {
            throw new Exception("CURL Error: {$error}");
        }

        // Parse the XML
        $xml = simplexml_load_string($curl_response);
        // Convert the result from a SimpleXMLObject into an array
        $xml = (array)$xml;
        // Validate the response - the only successful code is 0
        $status = ((int)$xml['responseCode'] === 0) ? true : false;

        // Make the response a little more useable
        $res = array (
            'status' => $status,
            'transactionID' => (isset($xml['transactionID']) ? $xml['transactionID'] : null),
            'responseData' => $xml
        );
        return $res;
    }

}