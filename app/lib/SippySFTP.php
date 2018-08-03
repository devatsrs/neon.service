<?php

namespace App\Lib;

use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\Log;

require_once 'utilities/xmlrpc/xmlrpc.inc';

class SippySFTP {
    private static $config = array();
    private static $cli;
    private static $timeout=0; /* 60 seconds timeout */

    public function __construct($CompanyGatewayID){
        $setting = GatewayAPI::getSetting($CompanyGatewayID,'SippySFTP');
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
            self::$cli = new \xmlrpc_client(self::$config['api_url']);
            self::$cli->return_type = 'phpvals';
            //self::$cli->debug =2;
            self::$cli->setSSLVerifyPeer(false);
            self::$cli->setSSLVerifyHost(2);
            self::$cli->setCredentials(self::$config['username'], self::$config['password'], CURLAUTH_DIGEST);
        }
    }
    public static function testConnection(){
        if(count(self::$config)>0) {
            $params = array(new \xmlrpcval(array(
                "offset" => new \xmlrpcval('0', "int"),
                "limit" => new \xmlrpcval('1', "int"),
            ), 'struct'));
            $msg = new \xmlrpcmsg('listAccounts', $params);
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
    public static function listAccounts($addparams=array()){
        if(count(self::$config)>0) {
            $params = array(new \xmlrpcval($addparams,'struct'));
            $msg = new \xmlrpcmsg('listAccounts', $params);
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
            $params = array(new \xmlrpcval($addparams,'struct'));
            $msg = new \xmlrpcmsg('getUploadToken', $params);
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
        if (function_exists('curl_file_create')) { // php 5.5+
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
            'Transfer-Encoding: chunked'
        ));
        $result = curl_exec ($curl);
        curl_close ($curl);
        return $result;
    }
    public static function getUploadStatus($addparams=array()){
        if(count(self::$config)>0) {
            $params = array(new \xmlrpcval($addparams,'struct'));
            $msg = new \xmlrpcmsg('getUploadStatus', $params);
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
            $addparams['name'] = 'upload_types';
            $params = array(new \xmlrpcval($addparams,'struct'));
            $msg = new \xmlrpcmsg('getDictionary', $params);
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
    public static function getAccountCDRs($addparams=array()){
        if(count(self::$config)>0) {

            if(isset($addparams['i_account'])){
                $addparams['i_account'] = new \xmlrpcval($addparams["i_account"], "int");
            }
            if(isset($addparams['offset'])){
                $addparams['offset'] = new \xmlrpcval($addparams["offset"], "int");
            }
            if(isset($addparams['limit'])){
                $addparams['limit'] = new \xmlrpcval($addparams["limit"], "int");
            }

            if(isset($addparams['type'])){
                $addparams['type'] = new \xmlrpcval($addparams["type"], "string");
            }else{
                $addparams['type'] = new \xmlrpcval("non_zero", "string");
            }

            if(isset($addparams['start_date'])){
                $addparams['start_date'] = new \xmlrpcval($addparams["start_date"], "string");
            }
            if(isset($addparams['end_date'])){
                $addparams['end_date'] = new \xmlrpcval($addparams["end_date"], "string");
            }

            $params = array(new \xmlrpcval($addparams,'struct'));
            $msg = new \xmlrpcmsg('getAccountCDRs', $params);
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
    public static function listVendors($addparams=array()){
        if(count(self::$config)>0) {
            $params = array(new \xmlrpcval($addparams,'struct'));
            $msg = new \xmlrpcmsg('listVendors', $params);
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
            $addparams['i_vendor'] = new \xmlrpcval($addparams["i_vendor"], "int");
            $params = array(new \xmlrpcval($addparams,'struct'));
            $msg = new \xmlrpcmsg('listVendorConnections', $params);
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
            $addparams['i_vendor'] = new \xmlrpcval($addparams["i_vendor"], "int");
            $params = array(new \xmlrpcval($addparams,'struct'));
            $msg = new \xmlrpcmsg('getVendorConnectionsList', $params);
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
            $addparams['i_connection'] = new \xmlrpcval($addparams["i_connection"], "int");
            $params = array(new \xmlrpcval($addparams,'struct'));
            $msg = new \xmlrpcmsg('getVendorConnectionInfo', $params);
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
                $addparams['i_account'] = new \xmlrpcval($addparams["i_account"], "int");
            $params = array(new \xmlrpcval($addparams,'struct'));
            $msg = new \xmlrpcmsg('listAuthRules', $params);
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
            $addparams['i_authentication'] = new \xmlrpcval($addparams["i_authentication"], "int");
            $params = array(new \xmlrpcval($addparams,'struct'));
            $msg = new \xmlrpcmsg('getAuthRuleInfo', $params);
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
                $addparams['name_pattern'] = new \xmlrpcval($addparams["name_pattern"], "string");
            }
            if(isset($addparams['i_destination_set'])){
                $addparams['i_destination_set'] = new \xmlrpcval($addparams["i_destination_set"], "int");
            }
            $params = array(new \xmlrpcval($addparams,'struct'));

            $msg = new \xmlrpcmsg('listDestinationSets', $params);

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
            $addparams['name'] = new \xmlrpcval($addparams["name"], "string");
            $addparams['currency'] = new \xmlrpcval($addparams["currency"], "string");
            $params = array(new \xmlrpcval($addparams,'struct'));

            $msg = new \xmlrpcmsg('addDestinationSet', $params);

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
                $addparams['prefix'] = new \xmlrpcval($addparams["prefix"], "string");
            }
            if(isset($addparams['i_destination_set'])){
                $addparams['i_destination_set'] = new \xmlrpcval($addparams["i_destination_set"], "int");
            }
            $params = array(new \xmlrpcval($addparams,'struct'));

            $msg = new \xmlrpcmsg('addRouteToDestinationSet', $params);

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
                $addparams['prefix'] = new \xmlrpcval($addparams["prefix"], "string");
            }
            if(isset($addparams['i_destination_set'])){
                $addparams['i_destination_set'] = new \xmlrpcval($addparams["i_destination_set"], "int");
            }
            $params = array(new \xmlrpcval($addparams,'struct'));

            $msg = new \xmlrpcmsg('delRouteFromDestinationSet', $params);

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
                $addparams['prefix'] = new \xmlrpcval($addparams["prefix"], "string");
            }
            if(isset($addparams['i_destination_set'])){
                $addparams['i_destination_set'] = new \xmlrpcval($addparams["i_destination_set"], "int");
            }
            if(isset($addparams['preference'])){
                $addparams['preference'] = new \xmlrpcval($addparams["preference"], "int");
            }

            $params = array(new \xmlrpcval($addparams,'struct'));

            $msg = new \xmlrpcmsg('updateRouteInDestinationSet', $params);

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
                $addparams['i_account'] = new \xmlrpcval($addparams["i_account"], "int");
            }
            if(isset($addparams['username'])){
                $addparams['username'] = new \xmlrpcval($addparams["username"], "string");
            }
            $params = array(new \xmlrpcval($addparams,'struct'));
            $msg = new \xmlrpcmsg('getAccountInfo', $params);
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
                $addparams['i_vendor'] = new \xmlrpcval($addparams["i_vendor"], "int");
            }
            if(isset($addparams['name'])){
                $addparams['name'] = new \xmlrpcval($addparams["name"], "string");
            }
            $params = array(new \xmlrpcval($addparams,'struct'));
            $msg = new \xmlrpcmsg('getVendorInfo', $params);
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
            $params = array(new \xmlrpcval($addparams,'struct'));
            $msg = new \xmlrpcmsg('createAccount', $params);
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
            $params = array(new \xmlrpcval($addparams,'struct'));
            $msg = new \xmlrpcmsg('updateAccount', $params);
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