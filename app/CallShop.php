<?php
namespace App;

use App\Lib\GatewayAPI;
use Exception;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class CallShop{
    private static $config = array();
    private static $cli;
    private static $timeout=0; /* 60 seconds timeout */
    private static $dbname1 = 'svbpanel';

   public function __construct($CompanyGatewayID){
       $setting = GatewayAPI::getSetting($CompanyGatewayID,'CallShop');
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
    public static function listCustomerNames($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{
                DB::purge('pbxmysql');
                Log::info(DB::connection('pbxmysql')->table('usuarios')->toSql());
                $response = DB::connection('pbxmysql')->table('usuarios')->lists('usuario');
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

                $query = "select u.usuario as username,p.usuario as providername,c.dispositivo_usuario as  cli,c.numero_destino as cld, c.ID as ID ,c.fecha as disconnect_time ,c.duracion as duration,c.duracion as billed_second,usuario_coste_final as cost,proveedor_coste_final as provider_price,hangupcause as disposition,usuario_prefijo as prefix,proveedor_prefijo as provider_prefix
                    from cdrs c
                    left join usuarios u on c.usuario_id = u.id
                    left join proveedores p on c.proveedor_id = p.id
                    where `fecha` >= '" . $addparams['start_date_ymd'] . "' and `fecha` < '" . $addparams['end_date_ymd'] . "'";

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
                            `tarifas`.`estructura`, `importes`.`prefijo`, `importes`.`destino`, `importes`.`importe`, `importes`.`psi`, `importes`.`ps`
                        FROM
                            `usuarios`
                        INNER JOIN
                            `tarifas` ON `tarifas_id` = `tarifas`.`id`
                        INNER JOIN
                            `importes` ON `importes`.`tarifas_id` = `usuarios`.`tarifas_id`
                        WHERE
                            `usuario` = '".$addparams['username']."'";

                if(isset($addparams['Prefix']) && trim($addparams['Prefix']) != '') {
                    $sql .= " AND `prefijo` LIKE '%".trim($addparams['Prefix'])."%'";
                }
                if(isset($addparams['Description']) && trim($addparams['Description']) != '') {
                    $sql .= " AND `destino` LIKE '%".trim($addparams['Description'])."%'";
                }

                $callshop_rates = DB::connection('pbxmysql')->select($sql);
                $callshop_rates = json_decode(json_encode($callshop_rates), true);

                $response['success'] = 1;
                $response['rates'] = $callshop_rates;

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