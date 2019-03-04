<?php

namespace App;
use App\Lib\GatewayAPI;
use App\Lib\RemoteSSH;
use App\Lib\xmlrpc_client;
use App\Lib\xmlrpcmsg;
use App\Lib\xmlrpcval;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Crypt;
use \Exception;

//use App\Lib\Xmlrpc;

/*Class for sippy api
 *@author:girish.vadher.it@gmail.com
 *Date:08-Dec-2014
 */

//require_once 'xmlrpc/xmlrpc.inc';

class Sippy{
    private static $config = array();
    private static $cli;
    private static $timeout=0; /* 60 seconds timeout */

    //https://178.62.213.114/xmlapi/xmlapi - api url

    public static $GatewayName = "SippySFTP";

   public function __construct($CompanyGatewayID){
       $setting = GatewayAPI::getSetting($CompanyGatewayID,self::$GatewayName);
       foreach((array)$setting as $configkey => $configval){
           if($configkey == 'api_password'){
               self::$config['password'] = Crypt::decrypt($configval);
           }else if($configkey == 'api_username'){
               self::$config['username'] = $configval;
           }else{
               self::$config[$configkey] = $configval;
           }
       }
       if(count(self::$config)>0) {
           self::$cli = new xmlrpc_client(self::$config['api_url']);
           self::$cli->return_type = 'phpvals';
           //self::$cli->debug =2;
           self::$cli->setSSLVerifyPeer(false);
           self::$cli->setSSLVerifyHost(2);
           self::$cli->setCredentials(self::$config['username'], self::$config['password'], CURLAUTH_DIGEST);
       }

    }
   public static function testConnection(){
        if(count(self::$config)>0) {
            $params = array(new xmlrpcval(array(
                "offset" => new xmlrpcval('0', "int"),
                "limit" => new xmlrpcval('1', "int"),
            ), 'struct'));
            $msg = new xmlrpcmsg('listAccounts', $params);
            $r = self::$cli->send($msg, self::$timeout);
            if ($r->faultCode()) {
                //echo $r->faultCode();echo $r->faultString();exit;
                error_log("Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                throw new Exception($r->faultString());
            }
            return $r->value();
        }
   }
    public static function listAccounts($addparams=array()){
        if(count(self::$config)>0) {
            $params = array(new xmlrpcval($addparams,'struct'));
            $msg = new xmlrpcmsg('listAccounts', $params);
            $r = self::$cli->send($msg, self::$timeout);
            if ($r->faultCode()) {
                //echo $r->faultCode();echo $r->faultString();exit;
                error_log("Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                throw new Exception($r->faultString());
            }
            return $r->value();
        }
    }
    public static function getAccountCDRs($addparams=array()){
        if(count(self::$config)>0) {
           if(isset($addparams['i_account'])){
                $addparams['i_account'] = new xmlrpcval($addparams["i_account"], "int");
            }
            if(isset($addparams['offset'])){
                $addparams['offset'] = new xmlrpcval($addparams["offset"], "int");
            }
            if(isset($addparams['limit'])){
                $addparams['limit'] = new xmlrpcval($addparams["limit"], "int");
            }

            if(isset($addparams['type'])){
                $addparams['type'] = new xmlrpcval($addparams["type"], "string");
            }else{
                $addparams['type'] = new xmlrpcval("non_zero", "string");
            }

            if(isset($addparams['start_date'])){
                $addparams['start_date'] = new xmlrpcval($addparams["start_date"], "string");
            }
            if(isset($addparams['end_date'])){
                $addparams['end_date'] = new xmlrpcval($addparams["end_date"], "string");
            }

            //print_r(new xmlrpcval($addparams["start_date"], "string"));
            //exit;

            $params = array(new xmlrpcval($addparams,'struct'));

            $msg = new xmlrpcmsg('getAccountCDRs', $params);

            $r = self::$cli->send($msg, self::$timeout);
            if ($r->faultCode()) {
                //echo $r->faultCode();echo $r->faultString();exit;
                error_log("Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                throw new Exception($r->faultString());
            }
            return $r->value();
        }
    }


    public static function listVendors($addparams=array()){
        if(count(self::$config)>0) {
            $params = array(new xmlrpcval($addparams,'struct'));
            $msg = new xmlrpcmsg('listVendors', $params);
            $r = self::$cli->send($msg, self::$timeout);
            if ($r->faultCode()) {
                //echo $r->faultCode();echo $r->faultString();exit;
                error_log("Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                return array('faultCode'=>$r->faultCode(),'faultString'=>$r->faultString());
            }
            return $r->value();
        }
    }
    public static function listVendorConnections($addparams=array()){
        if(count(self::$config)>0) {
            $addparams['i_vendor'] = new xmlrpcval($addparams["i_vendor"], "int");
            $params = array(new xmlrpcval($addparams,'struct'));
            $msg = new xmlrpcmsg('listVendorConnections', $params);
            $r = self::$cli->send($msg, self::$timeout);
            if ($r->faultCode()) {
                //echo $r->faultCode();echo $r->faultString();exit;
                error_log("Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                return array('faultCode'=>$r->faultCode(),'faultString'=>$r->faultString());
            }
            return $r->value();
        }
    }

    public static function getVendorConnectionsList($addparams=array()){
        if(count(self::$config)>0) {
            $addparams['i_vendor'] = new xmlrpcval($addparams["i_vendor"], "int");
            $params = array(new xmlrpcval($addparams,'struct'));
            $msg = new xmlrpcmsg('getVendorConnectionsList', $params);
            $r = self::$cli->send($msg, self::$timeout);
            if ($r->faultCode()) {
                //echo $r->faultCode();echo $r->faultString();exit;
                error_log("Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                return array('faultCode'=>$r->faultCode(),'faultString'=>$r->faultString());
            }
            return $r->value();
        }
    }

    public static function getVendorConnectionInfo($addparams=array()){
        if(count(self::$config)>0) {
            $addparams['i_connection'] = new xmlrpcval($addparams["i_connection"], "int");
            $params = array(new xmlrpcval($addparams,'struct'));
            $msg = new xmlrpcmsg('getVendorConnectionInfo', $params);
            $r = self::$cli->send($msg, self::$timeout);
            if ($r->faultCode()) {
                //echo $r->faultCode();echo $r->faultString();exit;
                error_log("Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                return array('faultCode'=>$r->faultCode(),'faultString'=>$r->faultString());
            }
            return $r->value();
        }
    }

    public static function listAuthRules($addparams=array()){
        if(count(self::$config)>0) {
            if(isset($addparams['i_account']))
                $addparams['i_account'] = new xmlrpcval($addparams["i_account"], "int");
            $params = array(new xmlrpcval($addparams,'struct'));
            $msg = new xmlrpcmsg('listAuthRules', $params);
            $r = self::$cli->send($msg, self::$timeout);
            if ($r->faultCode()) {
                //echo $r->faultCode();echo $r->faultString();exit;
                error_log("Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                return array('faultCode'=>$r->faultCode(),'faultString'=>$r->faultString());
            }
            return $r->value();
        }
    }

    public static function getAuthRuleInfo($addparams=array()){
        if(count(self::$config)>0) {
            $addparams['i_authentication'] = new xmlrpcval($addparams["i_authentication"], "int");
            $params = array(new xmlrpcval($addparams,'struct'));
            $msg = new xmlrpcmsg('getAuthRuleInfo', $params);
            $r = self::$cli->send($msg, self::$timeout);
            if ($r->faultCode()) {
                //echo $r->faultCode();echo $r->faultString();exit;
                error_log("Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                return array('faultCode'=>$r->faultCode(),'faultString'=>$r->faultString());
            }
            return $r->value();
        }
    }

    public static function listDestinationSets($addparams=array()){
        if(count(self::$config)>0) {
            if(isset($addparams['i_account'])){
                $addparams['name_pattern'] = new xmlrpcval($addparams["name_pattern"], "string");
            }
            if(isset($addparams['i_destination_set'])){
                $addparams['i_destination_set'] = new xmlrpcval($addparams["i_destination_set"], "int");
            }
            $params = array(new xmlrpcval($addparams,'struct'));

            $msg = new xmlrpcmsg('listDestinationSets', $params);

            $r = self::$cli->send($msg, self::$timeout);
            if ($r->faultCode()) {
                //echo $r->faultCode();echo $r->faultString();exit;
                error_log("Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                return array('faultCode'=>$r->faultCode(),'faultString'=>$r->faultString());
            }
            return $r->value();
        }
    }
    public static function addDestinationSet($addparams=array()){
        if(count(self::$config)>0) {
            $addparams['name'] = new xmlrpcval($addparams["name"], "string");
            $addparams['currency'] = new xmlrpcval($addparams["currency"], "string");
            $params = array(new xmlrpcval($addparams,'struct'));

            $msg = new xmlrpcmsg('addDestinationSet', $params);

            $r = self::$cli->send($msg, self::$timeout);
            if ($r->faultCode()) {
                //echo $r->faultCode();echo $r->faultString();exit;
                error_log("Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                return array('faultCode'=>$r->faultCode(),'faultString'=>$r->faultString());
            }
            return $r->value();
        }
    }

    public static function addRouteToDestinationSet($addparams=array()){
        if(count(self::$config)>0) {
            if(isset($addparams['prefix'])){
                $addparams['prefix'] = new xmlrpcval($addparams["prefix"], "string");
            }
            if(isset($addparams['i_destination_set'])){
                $addparams['i_destination_set'] = new xmlrpcval($addparams["i_destination_set"], "int");
            }
            $params = array(new xmlrpcval($addparams,'struct'));

            $msg = new xmlrpcmsg('addRouteToDestinationSet', $params);

            $r = self::$cli->send($msg, self::$timeout);
            if ($r->faultCode()) {
                //echo $r->faultCode();echo $r->faultString();exit;
                error_log("Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                return array('faultCode'=>$r->faultCode(),'faultString'=>$r->faultString());
            }
            return $r->value();
        }
    }
    public static function delRouteFromDestinationSet($addparams=array()){
        if(count(self::$config)>0) {
            if(isset($addparams['prefix'])){
                $addparams['prefix'] = new xmlrpcval($addparams["prefix"], "string");
            }
            if(isset($addparams['i_destination_set'])){
                $addparams['i_destination_set'] = new xmlrpcval($addparams["i_destination_set"], "int");
            }
            $params = array(new xmlrpcval($addparams,'struct'));

            $msg = new xmlrpcmsg('delRouteFromDestinationSet', $params);

            $r = self::$cli->send($msg, self::$timeout);
            if ($r->faultCode()) {
                //echo $r->faultCode();echo $r->faultString();exit;
                error_log("Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                return array('faultCode'=>$r->faultCode(),'faultString'=>$r->faultString());
            }
            return $r->value();
        }
    }
    public static function updateRouteInDestinationSet($addparams=array()){
        if(count(self::$config)>0) {
            if(isset($addparams['prefix'])){
                $addparams['prefix'] = new xmlrpcval($addparams["prefix"], "string");
            }
            if(isset($addparams['i_destination_set'])){
                $addparams['i_destination_set'] = new xmlrpcval($addparams["i_destination_set"], "int");
            }
            if(isset($addparams['preference'])){
                $addparams['preference'] = new xmlrpcval($addparams["preference"], "int");
            }

            $params = array(new xmlrpcval($addparams,'struct'));

            $msg = new xmlrpcmsg('updateRouteInDestinationSet', $params);

            $r = self::$cli->send($msg, self::$timeout);
            if ($r->faultCode()) {
                //echo $r->faultCode();echo $r->faultString();exit;
                error_log("Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                return array('faultCode'=>$r->faultCode(),'faultString'=>$r->faultString());
            }
            return $r->value();
        }
    }

    public static function getAccountInfo($addparams=array()){
        if(count(self::$config)>0) {
            if(isset($addparams['i_account'])){
                $addparams['i_account'] = new xmlrpcval($addparams["i_account"], "int");
            }
            if(isset($addparams['username'])){
                $addparams['username'] = new xmlrpcval($addparams["username"], "string");
            }
            $params = array(new xmlrpcval($addparams,'struct'));
            $msg = new xmlrpcmsg('getAccountInfo', $params);
            $r = self::$cli->send($msg, self::$timeout);
            if ($r->faultCode()) {
                //echo $r->faultCode();echo $r->faultString();exit;
                error_log("Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                return array('faultCode'=>$r->faultCode(),'faultString'=>$r->faultString());
            }
            return $r->value();
        }
    }

    public static function getVendorInfo($addparams=array()){
        if(count(self::$config)>0) {
            if(isset($addparams['i_vendor'])){
                $addparams['i_vendor'] = new xmlrpcval($addparams["i_vendor"], "int");
            }
            if(isset($addparams['name'])){
                $addparams['name'] = new xmlrpcval($addparams["name"], "string");
            }
            $params = array(new xmlrpcval($addparams,'struct'));
            $msg = new xmlrpcmsg('getVendorInfo', $params);
            $r = self::$cli->send($msg, self::$timeout);
            if ($r->faultCode()) {
                //echo $r->faultCode();echo $r->faultString();exit;
                error_log("Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                return array('faultCode'=>$r->faultCode(),'faultString'=>$r->faultString());
            }
            return $r->value();
        }
    }

    public static function createAccount($addparams=array()){
        if(count(self::$config)>0) {
            $params = array(new xmlrpcval($addparams,'struct'));
            $msg = new xmlrpcmsg('createAccount', $params);
            $r = self::$cli->send($msg, self::$timeout);
            if ($r->faultCode()) {
                //echo $r->faultCode();echo $r->faultString();exit;
                error_log("Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                return array('faultCode'=>$r->faultCode(),'faultString'=>$r->faultString());
            }
            return $r->value();
        }
    }
    public static function updateAccount($addparams=array()){
        if(count(self::$config)>0) {
            $params = array(new xmlrpcval($addparams,'struct'));
            $msg = new xmlrpcmsg('updateAccount', $params);
            $r = self::$cli->send($msg, self::$timeout);
            if ($r->faultCode()) {
                //echo $r->faultCode();echo $r->faultString();exit;
                error_log("Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                return array('faultCode'=>$r->faultCode(),'faultString'=>$r->faultString());
            }
            return $r->value();
        }
    }

    public static function getUploadToken($addparams=array()){
        if(count(self::$config)>0) {
            //Log::info($addparams);
            if(isset($addparams['i_upload_type'])){
                $addparams['i_upload_type'] = new xmlrpcval($addparams["i_upload_type"], "int");
            }
            if(isset($addparams['i_customer'])){
                $addparams['i_customer'] = new xmlrpcval($addparams["i_customer"], "int");
            }
            if(isset($addparams['params']['i_tariff'])){
                $addparams['params']['i_tariff'] = new xmlrpcval($addparams["params"]['i_tariff'], "int");
                $addparams['params'] = new xmlrpcval($addparams["params"], "struct");
            }
            if(isset($addparams['params']['i_destination_set'])){
                $addparams['params']['i_destination_set'] = new xmlrpcval($addparams["params"]['i_destination_set'], "int");
                $addparams['params'] = new xmlrpcval($addparams["params"], "struct");
            }
            $params = array(new xmlrpcval($addparams,'struct'));
            $msg = new xmlrpcmsg('getUploadToken', $params);

            $r = self::$cli->send($msg, self::$timeout);
            if ($r->faultCode()) {
                //echo $r->faultCode();echo $r->faultString();exit;
                error_log("Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                return array('faultCode'=>$r->faultCode(),'faultString'=>$r->faultString());
            }
            return $r->value();
        }
    }
    public static function uploadFile($addparams=array()){
        /*if (function_exists('curl_file_create')) { // php 5.5+
            $cFile = curl_file_create($addparams['file']);
        } else { //
            $cFile = '@' . realpath($addparams['file']);
        }
        $post = array('file_contents'=> $cFile);
        $curl = curl_init();
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_URL,$addparams['url']);
        curl_setopt($curl, CURLOPT_POST,1);
        curl_setopt($curl, CURLOPT_POSTFIELDS, $post);
        //curl_setopt($curl, CURLOPT_VERBOSE, 1);
        curl_setopt($curl, CURLOPT_HTTPHEADER, array(
            'Content-Type: application/octet-stream',
            'Content-Type: text/plain',
            'Transfer-Encoding: chunked'
        ));
        $result = curl_exec ($curl);
        curl_close ($curl);
        return $result;*/
        $CompanyID = $addparams['CompanyID'];
        $command = 'cat '.$addparams['file'].' | curl -v -o - --no-buffer -H "Content-Type: application/octet-stream" -k -H "Transfer-Encoding: chunked" "'.$addparams['url'].'" --data-binary @-';
        //exec('cat '.$addparams['file'].' | curl -v -o - --no-buffer -H "Content-Type: application/octet-stream" -k -H "Transfer-Encoding: chunked" "'.$addparams['url'].'" --data-binary @-');
        RemoteSSH::run($CompanyID, $command);
    }
    public static function getUploadStatus($addparams=array()){
        //possible values for status return by api is
        /*
            INIT_TOKEN
            FILE_UPLOADED
            PROCESSING
            FAIL
            DONE
        */
        if(count(self::$config)>0) {
            if(isset($addparams['token'])){
                $addparams['token'] = new xmlrpcval($addparams["token"], "string");
            }
            $params = array(new xmlrpcval($addparams,'struct'));
            $msg = new xmlrpcmsg('getUploadStatus', $params);
            $r = self::$cli->send($msg, self::$timeout);
            if ($r->faultCode()) {
                //echo $r->faultCode();echo $r->faultString();exit;
                error_log("Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                return array('faultCode'=>$r->faultCode(),'faultString'=>$r->faultString());
            }
            return $r->value();
        }
    }
    public static function getDictionary($addparams=array()){
        if(count(self::$config)>0) {
            $addparams['name'] = new xmlrpcval('upload_types', "string");
            $params = array(new xmlrpcval($addparams,'struct'));
            $msg = new xmlrpcmsg('getDictionary', $params);
            $r = self::$cli->send($msg, self::$timeout);
            if ($r->faultCode()) {
                //echo $r->faultCode();echo $r->faultString();exit;
                error_log("Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                return array('faultCode'=>$r->faultCode(),'faultString'=>$r->faultString());
            }
            return $r->value();
        }
    }
    public static function getCustomerInfo($addparams=array()){
        if(count(self::$config)>0) {
            if(isset($addparams['i_customer'])){
                $addparams['i_customer'] = new xmlrpcval($addparams["i_customer"], "int");
            }
            if(isset($addparams['name'])){
                $addparams['name'] = new xmlrpcval($addparams["name"], "string");
            }
            $params = array(new xmlrpcval($addparams,'struct'));
            $msg = new xmlrpcmsg('getCustomerInfo', $params);
            $r = self::$cli->send($msg, self::$timeout);
            if ($r->faultCode()) {
                //echo $r->faultCode();echo $r->faultString();exit;
                error_log("Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $r->faultCode() . ", Reason: " . $r->faultString());
                return array('faultCode'=>$r->faultCode(),'faultString'=>$r->faultString());
            }
            return $r->value();
        }
    }

}