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

                $query = "select c.domain_name as username,d.domain_description,direction as userfield,accountcode,caller_id_name,c.caller_id_number as cli,c.destination_number as cld, c.xml_cdr_uuid as id ,c.start_stamp as connect_time,c.end_stamp as disconnect_time,c.duration,c.billsec as billed_second,0 as cost,hangup_cause as disposition,json
                    from v_xml_cdr c
                    inner join v_domains d on d.domain_uuid=c.domain_uuid
                    where end_stamp >= '" . $addparams['start_date_ymd'] . "' and end_stamp < '" . $addparams['end_date_ymd'] . "'
                    AND (
                               direction like '%outbound%'
                            or direction like '%inbound%'
                            or (direction = 'local' AND  LENGTH(destination_number) > 4 )
                            or direction is null
                        )
                    ";

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