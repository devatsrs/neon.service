<?php
namespace App;

use App\Lib\GatewayAPI;
use Exception;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class FusionPBX{

    private static $config = array();
    private static $cli;
    private static $timeout = 0; /* 60 seconds timeout */
    private static $dbname1 = 'fusionpbx';

    public function __construct($CompanyGatewayID){
        $setting = GatewayAPI::getSetting($CompanyGatewayID, 'FusionPBX');
        foreach ((array)$setting as $configkey => $configval) {
            if ($configkey == 'password') {
                self::$config[$configkey] = Crypt::decrypt($configval);
            } else {
                self::$config[$configkey] = $configval;
            }
        }
        if (count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])) {
            extract(self::$config);
            Config::set('database.connections.pgsql.host', $dbserver);
            Config::set('database.connections.pgsql.database', self::$dbname1);
            Config::set('database.connections.pgsql.username', $username);
            Config::set('database.connections.pgsql.password', $password);

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


    public static function getAccountCDRs($addparams = array()){
        $response = array();
        if (count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])) {
            try {

                $query = "select u.username,c.originator_ip,c.terminator_ip,c.src as cli,c.dst as cld, c.ID as ID ,c.calldate as connect_time ,c.duration,c.billsec as billed_second,user_price as cost,provider_price,disposition,prefix
                    from calls c
                    inner join users u on c.user_id = u.id
                    where `calldate` >= '" . $addparams['start_date_ymd'] . "' and `calldate` < '" . $addparams['end_date_ymd'] . "'";

                Log::info($query);
                $response = DB::connection('pgsql')->select($query);
            } catch (Exception $e) {
                $response['faultString'] = $e->getMessage();
                $response['faultCode'] = $e->getCode();
                Log::error("Class Name:" . __CLASS__ . ",Method: " . __METHOD__ . ", Fault. Code: " . $e->getCode() . ", Reason: " . $e->getMessage());
                throw new Exception($e->getMessage());
            }
        }
        return $response;

    }


}