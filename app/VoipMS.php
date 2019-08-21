<?php
namespace App;

use Curl\Curl;
use \Exception;
use App\Lib\GatewayAPI;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Crypt;
class VoipMS{
    private static $config = array();
    private static $cli;
    private static $timeout=0; /* 60 seconds timeout */

    public function __construct($CompanyGatewayID){
        $setting = GatewayAPI::getSetting($CompanyGatewayID,'VoipMS');
        foreach((array)$setting as $configkey => $configval){
            if($configkey == 'password'){
                self::$config[$configkey] = Crypt::decrypt($configval);
            }else{
                self::$config[$configkey] = $configval;
            }
        }
        self::$config['method'] = "getLanguages";//test request

        if(count(self::$config) && isset(self::$config['api_url']) &&  isset(self::$config['username']) && isset(self::$config['password'])){
            self::$cli =  new Curl();
        }
    }
    public static function testConnection(){
        $response = array();
        if(count(self::$config) && isset(self::$config['api_url']) &&  isset(self::$config['username'])  && isset(self::$config['password'])){
            $api_url = self::$config['api_url'].'?api_username='.self::$config['username'].'&api_password='.self::$config['password'].'&method='.self::$config['method'];
            self::$cli->get($api_url);
            if(isset(self::$cli->response) && self::$cli->response != '') {
                $ResponseArray = json_decode(self::$cli->response, true);
                if(!empty($ResponseArray) && isset($ResponseArray['status']) && $ResponseArray['status'] == 'success') {
                    $response['result'] = 'OK';
                }
            }else if(isset(self::$cli->error_message) && isset(self::$cli->error_code)){
                $response['faultString'] =  self::$cli->error_message;
                $response['faultCode'] =  self::$cli->error_code;
            }
            self::$cli->close();
        }
        return $response;
    }
    public static function listAccounts($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['api_url']) && isset(self::$config['password'])){
            $api_url = self::$config['api_url'].'/getcustomersshortinfowithnolimit/'.self::$config['password'].'/true?format=json';
            self::$cli->get($api_url);
            if(isset(self::$cli->response) && self::$cli->response != '') {
                $ResponseArray = json_decode(self::$cli->response, true);
                if(!empty($ResponseArray) && isset($ResponseArray['CustomerRes'])) {
                    $response = $ResponseArray;
                    $response['result'] = 'OK';
                }
            }else if(isset(self::$cli->error_message) && isset(self::$cli->error_code)){
                $response['faultString'] =  self::$cli->error_message;
                $response['faultCode'] =  self::$cli->error_code;
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . self::$cli->error_code. ", Reason: " . self::$cli->error_message);
                throw new Exception(self::$cli->error_message);
            }
        }
        return $response;
    }
    public static function listCustomer($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['api_url']) && isset(self::$config['password']) && isset($addparams['ICustomer'])){
            echo $api_url = self::$config['api_url'].'/GetAccountByICustomer/'.self::$config['password'].'/'.$addparams['ICustomer'].'/?format=json';
            self::$cli->get($api_url);
            if(isset(self::$cli->response) && self::$cli->response != '') {
                $ResponseArray = json_decode(self::$cli->response, true);
                if(!empty($ResponseArray) && isset($ResponseArray['Accounts'])) {
                    $response = $ResponseArray;
                    $response['result'] = 'OK';
                }
            }else if(isset(self::$cli->error_message) && isset(self::$cli->error_code)){
                $response['faultString'] =  self::$cli->error_message;
                $response['faultCode'] =  self::$cli->error_code;
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . self::$cli->error_code. ", Reason: " . self::$cli->error_message);
                throw new Exception(self::$cli->error_message);
            }
        }
        return $response;

    }
    public static function getAccountCDRs($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['api_url']) &&  isset(self::$config['username'])  && isset(self::$config['password'])){
            $addparams['start_date_ymd'] = str_replace(" ","%20",$addparams['start_date_ymd']);
            $addparams['end_date_ymd'] = str_replace(" ","%20",$addparams['end_date_ymd']);
            $api_url = self::$config['api_url'].'?method=getCDR&api_username='.self::$config['username'].'&api_password='.self::$config['password'].'&date_from='.$addparams['start_date_ymd'].'&date_to='.$addparams['end_date_ymd'].'&answered=1&noanswer=1&failed=1&busy=1&timezone=0';
            self::$cli->get($api_url);
            if(isset(self::$cli->response) && self::$cli->response != '') {
                $ResponseArray = json_decode(self::$cli->response, true);
                if(!empty($ResponseArray) && isset($ResponseArray['cdr'])) {
                    $response = $ResponseArray;
                    $response['result'] = 'OK';
                } else {
                    $response['faultString'] = $ResponseArray['status'];
                    $response['faultCode'] 	 =  $ResponseArray['status'];
                    Log::error($ResponseArray);
                }
            }else if(isset(self::$cli->error_message) && isset(self::$cli->error_code)){
                $response['faultString'] =  self::$cli->error_message;
                $response['faultCode'] =  self::$cli->error_code;
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . self::$cli->error_code. ", Reason: " . self::$cli->error_message);
                throw new Exception(self::$cli->error_message);
            }
        }
        return $response;

    }
    public static function listVendors($addparams=array()){

    }

}