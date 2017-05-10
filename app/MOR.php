<?php
namespace App;

use App\Lib\GatewayAPI;
use Exception;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class MOR{
    private static $config = array();
    private static $cli;
    private static $timeout=0; /* 60 seconds timeout */
    private static $dbname1 = 'MOR_CDR';

   public function __construct($CompanyGatewayID){
       $setting = GatewayAPI::getSetting($CompanyGatewayID,'MOR');
       foreach((array)$setting as $configkey => $configval){
           if($configkey == 'password'){
               self::$config[$configkey] = Crypt::decrypt($configval);
           }else{
               self::$config[$configkey] = $configval;
           }
       }
       if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
           extract(self::$config);
           Config::set('database.connections.pbxmysql.host',$dbserver);
           Config::set('database.connections.pbxmysql.database',self::$dbname1);
           Config::set('database.connections.pbxmysql.username',$username);
           Config::set('database.connections.pbxmysql.password',$password);

       }
    }
   public static function testConnection(){
       $response = array();
       if(count(self::$config) && isset(self::$config['api_url']) && isset(self::$config['password'])){
           $api_url = self::$config['api_url'].'/GetCustomersShortInfo/'.self::$config['password'].'/?format=json';
           self::$cli->get($api_url);
           if(isset(self::$cli->response) && self::$cli->response != '') {
                   $ResponseArray = json_decode(self::$cli->response, true);
                   if(!empty($ResponseArray) && isset($ResponseArray['CustomerRes'])) {
                       $response['result'] = 'OK';
                   }
           }else if(isset(self::$cli->error_message) && isset(self::$cli->error_code)){
               $response['faultString'] =  self::$cli->error_message;
               $response['faultCode'] =  self::$cli->error_code;
           }
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

    public static function getAccountCDRs($addparams=array()) {
        $response = array();
        if(count(self::$config) && isset(self::$config['api_url']) && isset(self::$config['password'])) {

            $rez = self::morRequest('user_calls', $addparams);
            if ($rez) {
                $xml = $rez['xml'];
                if ($xml->calls_stat && $xml->calls_stat->count() > 0) {
                    foreach ($xml->calls_stat as $val) {
                        $ps = (string)$val->period->period_start;
                        $pe = (string)$val->period->period_end;

                        if ($val->calls->call && $val->calls->call->count() > 0) {
                            foreach ($val->calls->call as $v) {
                                $tmp = array();



                                $tmp['connect_time'] = (string)$v->calldate2;
                                $tmp['disconnect_time'] = (string)$v->calldate2;
                                $tmp['cost'] = (string)$v->user_price;
                                $tmp['cld'] = (string)$v->destination;
                                $tmp['cli'] = (string)$v->src;
                                $tmp['billed_duration'] = (string)$v->nice_billsec;
                                $tmp['billed_second'] = (string)$v->nice_billsec;
                                $tmp['duration'] = (string)$v->nice_billsec;
                                $tmp['ID'] = (string)$v->uniqueid;
                                $tmp['clid'] = (string)$v->clid;
                                $tmp['did'] = (string)$v->did;
                                $tmp['currency'] = (string)$xml->currency;

                                $response[] = $tmp;
                            }
                        }
                    }
                }

            }
        }
        return $response;
    }

    public static function morRequest($host, $data = array(), $useHash = true){
        $req = $data;
        $hashKeys = array('user_id', 'period_start', 'period_end', 'direction', 'calltype', 'device', 'balance', 'users', 'block',
            'email', 'mtype', 'monitoring_id', 'tariff_id', 'u0', 'u1', 'u2', 'u3', 'u4', 'u5', 'u6', 'u7', 'u8', 'u9', 'u10', 'u11',
            'u12', 'u13', 'u14', 'u15', 'u16', 'u17', 'u18', 'u19', 'u20', 'u21', 'u22', 'u23', 'u24', 'u25', 'u26', 'u27', 'u28', 'ay',
            'am', 'ad', 'by', 'bm', 'bd', 'pswd', 'user_warning_email_hour', 'pgui', 'pcsv', 'ppdf', 'recording_forced_enabled', 'i4',
            'tax4_enabled', 'tax2_enabled', 'accountant_type_invalid', 'block_at_conditional', 'tax3_enabled', 'accountant_type',
            'tax1_value', 'show_zero_calls', 'warning_email_active', 'compound_tax', 'tax4_name', 'allow_loss_calls', 'tax3_name',
            'tax2_name', 'credit', 'tax1_name', 'total_tax_name', 'tax2_value', 'tax4_value', 'ignore_global_monitorings', 'i1',
            'tax3_value', 'cyberplat_active', 'i2', 'i3', 'recording_enabled', 'email_warning_sent_test', 'own_providers', 'a0', 'a1',
            'a2', 'a3', 'a4', 'a5', 'a6', 'a7', 'a8', 'a9', 's_user', 's_call_type', 's_device', 's_provider', 's_hgc', 's_did',
            's_destination', 'order_by', 'order_desc', 'only_did', 'description', 'pin', 'type', 'devicegroup_id', 'phonebook_id',
            'number', 'name', 'speeddial', 's_user_id', 's_from', 's_till', 's_transaction', 's_completed', 's_username', 's_first_name',
            's_last_name', 's_paymenttype', 's_amount_max', 's_currency', 's_number', 's_pin');
        if ($useHash) {
            $hash_string = '';
            foreach ($hashKeys as $val) {
                if (in_array($val, array_keys($data))) {
                    $hash_string .= $data[$val];
                }
            }
            $hash_string .= self::$config['password']; // @param API authkey
            $hash = sha1($hash_string);
            $req['hash'] = $hash;
        }

        $req['u'] = 'admin'; // @param user name
        $req['p'] = 'admin1'; // @param password
        $reqHost = self::$config['api_url'] . $host; // @param MOR hostname
        echo $reqHost;
        print_r($host);
        exit;
        self::$cli->post($reqHost, $req);
        $response = array();
        $error_code = 500;
        if (isset(self::$cli->response) && self::$cli->response != '') {
            $rep_message = self::$cli->response;
            if ($rep_message && $rep_message == 'Incorrect hash') {
                $error_message = self::$cli->response;
                $response['faultString'] = $error_message;
                $response['faultCode'] = $error_code;
                Log::error("Class Name:" . __CLASS__ . ",Method: " . __METHOD__ . ", Fault. Code: " . $error_code . ", Reason: " . $error_message);
                throw new Exception(self::$cli->error_message);
            }else{
                $xml = @simplexml_load_string($rep_message);
                if (!$xml || (string)($xml) == 'API Requests are disabled' || (string)$xml == 'User was not found' || isset($xml->body)) {
                    $error_message = (string)($xml);
                    $response['faultString'] = $error_message;
                    $response['faultCode'] = $error_code;
                    Log::error("Class Name:" . __CLASS__ . ",Method: " . __METHOD__ . ", Fault. Code: " . $error_code . ", Reason: " . $error_message);
                    throw new Exception($error_message);
                }
                $response['xml'] = $xml;
                $response['result'] = 'OK';
            }

        } else if (isset(self::$cli->error_message) && isset(self::$cli->error_code)) {
            $response['faultString'] = self::$cli->error_message;
            $response['faultCode'] = self::$cli->error_code;
            Log::error("Class Name:" . __CLASS__ . ",Method: " . __METHOD__ . ", Fault. Code: " . self::$cli->error_code . ", Reason: " . self::$cli->error_message);
            throw new Exception(self::$cli->error_message);
        }
        return $response;
    }

    public static function getAccountCDRs2($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{

                $query = "select u.username,u.originator_ip,c.src as cli,c.dst as cld, c.ID as ID ,c.calldate as connect_time ,c.duration,c.billsec as billed_second,user_price as cost,disposition
                    from calls c
                    inner join users u on c.user_id = u.id
                    where `calldate` >= '" . $addparams['start_date_ymd'] . "' and `calldate` < '" . $addparams['end_date_ymd'] . "'";

                Log::info($query);
                $response = DB::connection('pbxmysql')->select($query);
            }catch(Exception $e){
                $response['faultString'] =  $e->getMessage();
                $response['faultCode'] =  $e->getCode();
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $e->getCode(). ", Reason: " . $e->getMessage());
                throw new Exception($e->getMessage());
            }
        }
        return $response;

    }



}