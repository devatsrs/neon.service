<?php
namespace App;

use App\Lib\GatewayAPI;
use Exception;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class SippySQL{

    private static $config = array();
    private static $cli;
    private static $timeout = 0; /* 60 seconds timeout */

    public function __construct($CompanyGatewayID){
        $setting = GatewayAPI::getSetting($CompanyGatewayID, 'SippySQL');
        foreach ((array)$setting as $configkey => $configval) {
            if ($configkey == 'dbpassword') {
                self::$config[$configkey] = Crypt::decrypt($configval);
            } else {
                self::$config[$configkey] = $configval;
            }
        }
        if (count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['dbusername']) && isset(self::$config['dbpassword'])) {
            extract(self::$config);
            Config::set('database.connections.pgsql.host', $dbserver);
            Config::set('database.connections.pgsql.database', $dbname);
            Config::set('database.connections.pgsql.username', $dbusername);
            Config::set('database.connections.pgsql.password', $dbpassword);

        }
    }

    public static function testConnection(){
        $response = array();
        if (count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['dbusername']) && isset(self::$config['dbpassword'])) {

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
        if (count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['dbusername']) && isset(self::$config['dbpassword'])) {
            try {
                //$addparams['end_date_ymd'] = '2018-06-03 00:02:00';
                //$query = "select table_name as calls_table,REPLACE(table_name, 'calls', 'cdrs') as cdrs_table, REPLACE(table_name, 'calls', 'cdrs_connections') as cdrs_connections_table  from calls_schedule where newest_setup_time >= '" . $addparams['start_date_ymd'] . "' and newest_setup_time < '" . $addparams['end_date_ymd'] . "'";
                //Log::info($query);
                //$tables = DB::connection('pgsql')->select($query);

                $cdrs_table = "cdrs";
                $cdrs_connections_table = "cdrs_connections";
                $calls_table = "calls";

                $response_cdr = array();
               // foreach($tables as $tablename)
               // {
                $cdrs_qry = "select a.username,cc.i_account,cc.remote_ip,c.setup_time,cc.disconnect_time,cc.cost,cc.cld_in,cc.cli_in,cc.billed_duration,cc.prefix,cc.i_call,c.i_call from ".$cdrs_table." as cc inner join ".$calls_table." as c on cc.i_call = c.i_call left join accounts as a on cc.i_account = a.i_account where cc.disconnect_time >= '" . $addparams['start_date_ymd'] . "' and cc.disconnect_time < '" . $addparams['end_date_ymd'] . "' ";
                $response_cdr = DB::connection('pgsql')->select($cdrs_qry);
                Log::info($cdrs_qry);

                $cdrs_conn_qry = "select a.username,cc.i_account_debug,cc.remote_ip,c.setup_time,cc.disconnect_time,cc.cost,cc.cld_out,cc.cli_out,cc.billed_duration,cc.prefix,cc.i_call,c.i_call from ".$cdrs_connections_table." as cc inner join ".$calls_table." as c on cc.i_call = c.i_call left join accounts as a on cc.i_account_debug = a.i_account where cc.disconnect_time >= '" . $addparams['start_date_ymd'] . "' and cc.disconnect_time < '" . $addparams['end_date_ymd'] . "' ";
                $response_cdr_connection = DB::connection('pgsql')->select($cdrs_conn_qry);
                Log::info($cdrs_conn_qry);

                    $response['cdrs_response'][] = $response_cdr;
                    $response['cdrs_response_connection'][] = $response_cdr_connection;
                //}
                //print_R($response_cdr);exit;

            } catch (Exception $e) {
                $response['faultString'] = $e->getMessage();
                $response['faultCode'] = $e->getCode();
                Log::error("Class Name:" . __CLASS__ . ",Method: " . __METHOD__ . ", Fault. Code: " . $e->getCode() . ", Reason: " . $e->getMessage());
                throw new Exception($e->getMessage());
            }
        }
        return $response;

    }

    public static function getAccountByIP($addparams = array()){

        $response = array();
        if (count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['dbusername']) && isset(self::$config['dbpassword'])) {
            try {
                $qry = "select i_account from authentications where remote_ip in (" . $addparams['remote_ip'] . ") and remote_ip != ''  limit 1";
                $response = DB::connection('pgsql')->select($qry);
                Log::info($qry);
            } catch (Exception $e) {
                $response['faultString'] = $e->getMessage();
                $response['faultCode'] = $e->getCode();
                Log::error("Class Name:" . __CLASS__ . ",Method: " . __METHOD__ . ", Fault. Code: " . $e->getCode() . ", Reason: " . $e->getMessage());
                throw new Exception($e->getMessage());
            }
        }
        return $response;

    }

    public static function getTariffID($addparams = array()){

        $response = array();
        if (count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['dbusername']) && isset(self::$config['dbpassword'])) {
            try {
                $qry = "select i_tariff from billing_plans where i_billing_plan = " . $addparams['i_billing_plan'] . " limit 1";
                $response = DB::connection('pgsql')->select($qry);
                Log::info($qry);
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