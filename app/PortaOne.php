<?php
namespace App;

use Curl\Curl;
use \Exception;
use App\Lib\GatewayAPI;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Crypt;
class PortaOne{
    private static $config = array();
    private static $cli;
    private static $timeout=0; /* 60 seconds timeout */

    public function __construct($CompanyGatewayID){
        $setting = GatewayAPI::getSetting($CompanyGatewayID,'PortaOne');
        foreach((array)$setting as $configkey => $configval){
            if($configkey == 'password'){
                self::$config[$configkey] = Crypt::decrypt($configval);
            }else{
                self::$config[$configkey] = $configval;
            }
        }
        if(count(self::$config) && isset(self::$config['api_url']) && isset(self::$config['username']) && isset(self::$config['password'])){
            self::$cli =  new Curl();
        }
    }
    public static function testConnection(){
        $response = array();
        if(count(self::$config) && isset(self::$config['api_url']) && isset(self::$config['username']) && isset(self::$config['password'])){
            $curl = curl_init();
            $post_data = array(
                'auth_info' => json_encode(array('login' => self::$config['username'],'token' => self::$config['password'])),
                /* 'params' => json_encode(array(
                     'limit' => "2",
                 )),*/
            );
            $api_url = self::$config['api_url'].'/rest/Customer/get_customer_list/';
            curl_setopt_array($curl,
                array(
                    CURLOPT_URL => $api_url,
                    CURLOPT_POST => true,
                    CURLOPT_SSL_VERIFYPEER => false,
                    CURLOPT_SSL_VERIFYHOST => false,
                    CURLOPT_RETURNTRANSFER => true,
                    CURLOPT_SSLVERSION => 6,
                    CURLOPT_POSTFIELDS => http_build_query($post_data),
                )
            );

            $reply = curl_exec($curl);
            $ResponseArray = json_decode($reply, true);
            // self::$cli->post($api_url,$post_data);
            if(!empty($ResponseArray) && isset($ResponseArray['customer_list'])) {
                $response = $ResponseArray;
                $response['result'] = 'OK';
                curl_close($curl);

            }else if(isset($ResponseArray['faultstring']) && isset($ResponseArray['faultcode'])){
                $response['faultString'] =  $ResponseArray['faultstring'];
                $response['faultCode'] =  $ResponseArray['faultcode'];
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $ResponseArray['faultcode']. ", Reason: " . $ResponseArray['faultstring']);
                curl_close($curl);
            }
        }
        return $response;
    }
    public static function listAccounts($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['api_url']) && isset(self::$config['username']) && isset(self::$config['password'])){

            $curl = curl_init();
            $post_data = array(
                'auth_info' => json_encode(array('login' => self::$config['username'],'token' => self::$config['password'])),
                 'params' => json_encode(array(
                     'limit' => "1",
                 )),
            );
            $api_url = self::$config['api_url'].'/rest/Customer/get_customer_list/';
            curl_setopt_array($curl,
                array(
                    CURLOPT_URL => $api_url,
                    CURLOPT_POST => true,
                    CURLOPT_SSL_VERIFYPEER => false,
                    CURLOPT_SSL_VERIFYHOST => false,
                    CURLOPT_RETURNTRANSFER => true,
                    CURLOPT_SSLVERSION => 6,
                    CURLOPT_POSTFIELDS => http_build_query($post_data),
                )
            );

            $reply = curl_exec($curl);
            $ResponseArray = json_decode($reply, true);

            // self::$cli->post($api_url,$post_data);
            if(!empty($ResponseArray) && isset($ResponseArray['customer_list'])) {
                Log::info('Total Customer - '.count($ResponseArray['customer_list']));
                $response = $ResponseArray;
                $response['result'] = 'OK';
                curl_close($curl);

            }else if(isset($ResponseArray['faultstring']) && isset($ResponseArray['faultcode'])){
                $response['faultString'] =  $ResponseArray['faultstring'];
                $response['faultCode'] =  $ResponseArray['faultcode'];
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $ResponseArray['faultcode']. ", Reason: " . $ResponseArray['faultstring']);
                curl_close($curl);
                //throw new Exception(self::$cli->error_message);
            }
        }
        return $response;
    }

    public static function getAccountCDRs($addparams=array()){
        $response = array();

        if(count(self::$config) && isset(self::$config['api_url']) && isset(self::$config['username']) && isset(self::$config['password']) && isset($addparams['ICustomer'])){
            // $addparams['start_date_ymd'] = str_replace(" ","%20",$addparams['start_date_ymd']);
            // $addparams['end_date_ymd'] = str_replace(" ","%20",$addparams['end_date_ymd']);
            $curl = curl_init();
            $post_data = array(
                'auth_info' => json_encode(array('login' => self::$config['username'],'token' => self::$config['password'])),
                'params' => json_encode(array(
                    'i_customer' => $addparams['ICustomer'],
                    'from_date' => $addparams['start_date_ymd'],
                    'to_date' => $addparams['end_date_ymd'],
                    'i_service_type' => 3, //for Voice Calls = 3
                    //'cdr_entity' => 'A', // for fetch customers accounts
                    'get_total' => "1",
                )),
            );
            $api_url = self::$config['api_url'].'/rest/Customer/get_customer_xdrs/';
            curl_setopt_array($curl,
                array(
                    CURLOPT_URL => $api_url,
                    CURLOPT_POST => true,
                    CURLOPT_SSL_VERIFYPEER => false,
                    CURLOPT_SSL_VERIFYHOST => false,
                    CURLOPT_RETURNTRANSFER => true,
                    CURLOPT_SSLVERSION => 6,
                    CURLOPT_POSTFIELDS => http_build_query($post_data),
                )
            );
            //$api_url = self::$config['api_url'].'/getCustomerAccountCDRS/'.self::$config['password'].'/'.$addparams['ICustomer'].'/'.$addparams['start_date_ymd'].'/'.$addparams['end_date_ymd'].'/true/?format=json';
            // self::$cli->get($api_url);
            $reply = curl_exec($curl);
            $ResponseArray = json_decode($reply, true);
            //Log::info(print_r($ResponseArray,true));
            //Log::info('Total Cdrs - '.count($ResponseArray['xdr_list']));

            if(!empty($ResponseArray) && isset($ResponseArray['xdr_list'])) {
                $response = $ResponseArray;
                $response['result'] = 'OK';
                curl_close($curl);

            }else if(isset($ResponseArray['faultstring']) && isset($ResponseArray['faultcode'])){
                $response['faultString'] =  $ResponseArray['faultstring'];
                $response['faultCode'] =  $ResponseArray['faultcode'];
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $ResponseArray['faultcode']. ", Reason: " . $ResponseArray['faultstring']);
                curl_close($curl);
                //throw new Exception(self::$cli->error_message);
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
    public static function listVendors($addparams=array()){

    }

}