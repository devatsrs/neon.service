<?php
namespace App;

use App\Lib\GatewayAPI;
use Exception;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class VoipNow{
    private static $config = array();
    private static $cli;
    private static $timeout=0; /* 60 seconds timeout */
    private static $dbname1 = 'voipnow';

   public function __construct($CompanyGatewayID){
       $setting = GatewayAPI::getSetting($CompanyGatewayID,'VoipNow');
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
       if (count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])) {

           try {
               if (DB::connection('pgsql')->getDatabaseName()) {
                   $response['result'] = 'OK';
               }
           } catch (Exception $e) {
               $response['faultString'] = $e->getMessage();
               $response['faultCode'] = $e->getCode();
           }
       }
       return $response;
   }

    public static function getAccountCDRs($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{

                /*
                    * ----flow => in----------
                    partyid  => cli
                    did => cld
                    ----flow = out------------------
                    did => cli
                    extension_number => cld
               */

                    $query = "select c.company AS username,ch.caller_info AS originator_ip,
                              CASE WHEN flow = 'in' THEN
                                  ch.partyid
                              ELSE
                                  ch.did
                              END as cli,
                              CASE WHEN flow = 'out' THEN
                                  ch.extension_number
                              ELSE
                                  ch.did
                              END as cld,
                              ch.id as ID ,ch.start as connect_time ,ch.duration,ch.duration as billed_second,ch.costres as cost,ch.disposion AS disposition,prefix,ch.flow AS userfield
                    from call_history ch
                    inner join client c on ch.client_client_id = c.id
                    where `start` >= '" . $addparams['start_date_ymd'] . "' and `start` < '" . $addparams['end_date_ymd'] . "'
                    and calltype = 'out'";
                // | calltype // | out      || local    || elocal   |
                //out = external

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