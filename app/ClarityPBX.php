<?php
namespace App;

use App\Lib\GatewayAPI;
use Exception;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class ClarityPBX{

    private static $config = array();
    private static $cli;
    private static $timeout = 0; /* 60 seconds timeout */
    private static $dbname = 'clarity';

    public function __construct($CompanyGatewayID){
        $setting = GatewayAPI::getSetting($CompanyGatewayID, 'ClarityPBX');
        foreach ((array)$setting as $configkey => $configval) {
            if ($configkey == 'password') {
                self::$config[$configkey] = Crypt::decrypt($configval);
            } else {
                self::$config[$configkey] = $configval;
            }
        }
        if (count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])) {
            Config::set('database.connections.pgsql.host',self::$config['dbserver']);
            Config::set('database.connections.pgsql.database',self::$dbname);
            Config::set('database.connections.pgsql.username',self::$config['username']);
            Config::set('database.connections.pgsql.password',self::$config['password']);

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

                $query = "select
                        cdr.src,cdr.dest,cdr.id AS call_id,cdr.sip_code,cdr.start_time,cdr.answer_time,cdr.end_time,cdr.duration_sec,cdr.src_ip,cdr.dest_ip,
                        crp.rate_bill_sec,crp.rate_cost_net,crp.vendor_bill_sec,crp.vendor_cost,
                        crs.rate_prefix,customer.descr AS customer_name,vendor.descr AS vendor_name
                    from
                      cdr
                    left join
                      cdr_rate_postproc as crp on crp.cdr_id=cdr.id
                    left join
                      cdr_rate_static as crs on crs.cdr_id=cdr.id
                    join
                      customer on customer.id = cdr.customer_id
                    join
                      vendor on vendor.id = cdr.vendor_id
                    where
                      cdr.end_time is not null and cdr.end_time >= '" . $addparams['start_date_ymd'] . "' and cdr.end_time < '" . $addparams['end_date_ymd'] . "'
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

    public static function updateAccountBalance($addparams = array()){
        $response = array();
        if (count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])) {
            try {
                $findAccountQuery = "SELECT
                                        COUNT(cbc.*)
                                    FROM
                                        customer_bg_credit_ctrl cbc
                                    WHERE
                                        cbc.customer_bg_id = (
                                            SELECT cb.id FROM customer_bg cb
                                            JOIN customer c on c.id = cb.customer_id
                                            WHERE c.descr = '".$addparams['AccountName']."'
                                            ORDER BY cb.id ASC LIMIT 1
                                        )";
                Log::info($findAccountQuery);
                $findAccountResult = DB::connection('pgsql')->select($findAccountQuery);

                if($findAccountResult[0]->count > 0) {
                    $calc = $addparams['Recall'] == 1 ? '-' : '+';
                    $query = "UPDATE
                                customer_bg_credit_ctrl
                            SET credit_bal = credit_bal ".$calc." ".$addparams['Amount']."
                            WHERE
                                customer_bg_id = (
                                    SELECT cb.id FROM customer_bg cb
                                    JOIN customer c on c.id = cb.customer_id
                                    WHERE c.descr = '".$addparams['AccountName']."'
                                    ORDER BY cb.id ASC LIMIT 1
                                )";
                    Log::info($query);
                    $result = DB::connection('pgsql')->select($query);

                    $response['Status'] = "OK";
                } else {
                    $response['faultString'] = $addparams['AccountName']." : Account or Account Balance entry not found in Gateway.";
                    $response['faultCode'] = "400";
                }

            } catch (Exception $e) {
                $response['faultString'] = $e->getMessage();
                $response['faultCode'] = $e->getCode();
                Log::error("Class Name:" . __CLASS__ . ",Method: " . __METHOD__ . ", Fault. Code: " . $e->getCode() . ", Reason: " . $e->getMessage());
                throw new Exception($e->getMessage());
            }
        }
        return $response;

    }

    //get data from gateway and insert in temp table
    public static function getCustomersList($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{
                $query = "select * from customer ";
                $response = DB::connection('pgsql')->select($query);
            }catch(Exception $e){
                $response['faultString'] =  $e->getMessage();
                $response['faultCode'] =  $e->getCode();
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $e->getCode(). ", Reason: " . $e->getMessage());
                //throw new Exception($e->getMessage());
            }
        }
        return $response;
    }

    //get data from gateway and insert in temp table
    public static function getVendorsList($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{
                $query = "select * from vendor ";
                $response = DB::connection('pgsql')->select($query);
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