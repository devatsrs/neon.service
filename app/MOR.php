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
    private static $dbname1 = 'mor';

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
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{
                $columns = !empty($addparams['columns']) ? (string)$addparams['columns'] : '*';
                $query = "select ".$columns." from users";

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
    public static function listCustomerNames($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{
                DB::purge('pbxmysql');
                Log::info(DB::connection('pbxmysql')->table('users')->toSql());
                $response = DB::connection('pbxmysql')->table('users')->lists('username');
            }catch(Exception $e){
                $response['faultString'] =  $e->getMessage();
                $response['faultCode'] =  $e->getCode();
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $e->getCode(). ", Reason: " . $e->getMessage());
                throw new Exception($e->getMessage());
            }
        }
        return $response;
    }



    public static function getAccountCDRs($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{

                $query = "select u.username,p.name as providername,c.originator_ip,c.terminator_ip,c.src as cli,c.dst as cld, c.ID as ID ,c.calldate as connect_time ,c.duration,c.billsec as billed_second,user_price as cost,provider_price,disposition,prefix
                    from calls c
                    inner join users u on c.user_id = u.id
                    left join providers p on c.provider_id =  p.id
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

    public static function getRates($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{
                DB::purge('pbxmysql');
                $sql = "SELECT
                            `destinations`.`name`, `destinations`.`prefix`, `tariffs`.`purpose`, `rates`.`effective_from`, `rate`, `connection_fee`, `increment_s`, `min_time`
                        FROM
                            `users`
                        INNER JOIN
                            `tariffs` ON `tariff_id` = `tariffs`.`id`
                        INNER JOIN
                            `rates` ON `rates`.`tariff_id` = `tariffs`.`id`
                        INNER JOIN
                            `destinations` ON `destination_id` = `destinations`.`id`
                        INNER JOIN
                            `ratedetails` ON `rates`.`id` = `rate_id`
                        WHERE
                            `username` = '".$addparams['username']."'";

                if(isset($addparams['Prefix']) && trim($addparams['Prefix']) != '') {
                    $sql .= " AND `destinations`.`prefix` LIKE '%".trim($addparams['Prefix'])."%'";
                }
                if(isset($addparams['Description']) && trim($addparams['Description']) != '') {
                    $sql .= " AND `destinations`.`name` LIKE '%".trim($addparams['Description'])."%'";
                }

                $mor_rates = DB::connection('pbxmysql')->select($sql);
                $mor_rates = json_decode(json_encode($mor_rates), true);

                $response['success'] = 1;
                $response['rates'] = $mor_rates;

            }catch(Exception $e){
                $response['faultString'] =  $e->getMessage();
                $response['faultCode'] =  $e->getCode();
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $e->getCode(). ", Reason: " . $e->getMessage());
                //throw new Exception($e->getMessage());
            }
        }
        return $response;

    }

}