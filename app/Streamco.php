<?php
namespace App;

use App\Lib\GatewayAPI;
use Exception;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class Streamco{
    private static $config = array();
    private static $cli;
    private static $timeout=0; /* 60 seconds timeout */
    private static $dbname1 = 'storage';

   public function __construct($CompanyGatewayID){
       $setting = GatewayAPI::getSetting($CompanyGatewayID,'Streamco');
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


    public static function getAccountCDRs($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{

                $query = "select u.name as username,c.caller_id as  cli,c.callee_id as cld, c.ID as ID ,c.start_time as connect_time,c.end_time as disconnect_time ,c.total_seconds as duration,c.answered_seconds as billed_second,price as cost,hangup_cause as disposition,code as prefix
                    from originator_billed_cdr c
                    left join config.originators u on c.originator_id = u.id
                    where `end_time` >= '" . $addparams['start_date_ymd'] . "' and `end_time` < '" . $addparams['end_date_ymd'] . "'";

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
    public static function getVAccountCDRs($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{

                $query = "select u.name as providername,c.caller_id as  cli,c.callee_id as cld,cc.ID as ID, c.ID as ID2,c.start_time as connect_time,c.end_time as disconnect_time ,c.total_seconds as duration,c.answered_seconds as billed_second,c.price as provider_price,c.hangup_cause as disposition,c.code as provider_prefix,cc.price as cost
                    from terminator_billed_cdr c
                    left join config.terminators u on c.terminator_id = u.id
                    left join terminator_billed_cdr cc on c.call_id = u.call_id
                    where `end_time` >= '" . $addparams['start_date_ymd'] . "' and `end_time` < '" . $addparams['end_date_ymd'] . "'";

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