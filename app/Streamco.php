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
           if($configkey == 'dbpassword'){
               self::$config[$configkey] = Crypt::decrypt($configval);
           }else{
               self::$config[$configkey] = $configval;
           }
       }
       if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['dbusername']) && isset(self::$config['dbpassword'])){
           extract(self::$config);
           Config::set('database.connections.pbxmysql.host',$host);
           Config::set('database.connections.pbxmysql.database',self::$dbname1);
           Config::set('database.connections.pbxmysql.username',$dbusername);
           Config::set('database.connections.pbxmysql.password',$dbpassword);

       }
    }
   public static function testConnection(){
       $response = array();
       if(count(self::$config) && isset(self::$config['api_url']) && isset(self::$config['dbpassword'])){
           $api_url = self::$config['api_url'].'/GetCustomersShortInfo/'.self::$config['dbpassword'].'/?format=json';
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
        if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['dbusername']) && isset(self::$config['dbpassword'])){
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
        if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['dbusername']) && isset(self::$config['dbpassword'])){
            try{

                $query = "select u.name as providername,c.caller_id as  cli,c.callee_id as cld,IFNULL(cc.ID,c.ID) as ID, c.ID as ID2,c.start_time as connect_time,c.end_time as disconnect_time ,c.total_seconds as duration,c.answered_seconds as billed_second,c.price as provider_price,c.hangup_cause as disposition,c.code as provider_prefix,cc.price as cost
                    from terminator_billed_cdr c
                    left join config.terminators u on c.terminator_id = u.id
                    left join originator_billed_cdr cc on c.call_id = cc.call_id
                    where c.`end_time` >= '" . $addparams['start_date_ymd'] . "' and c.`end_time` < '" . $addparams['end_date_ymd'] . "'";

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

    public static function importStreamcoAccounts($addparams=array()) {
        $response = array();
//        $currency = Currency::getCurrencyDropdownIDList();
        if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['dbusername']) && isset(self::$config['dbpassword'])){
            try{
                $dbname = 'config';
                $query1 = "select a.name,a.enabled,c.email,c.invoice_email,c.address from ".$dbname.".originators a LEFT JOIN ".$dbname.".companies c ON a.company_id=c.id"; // and userfield like '%outbound%'  removed for inbound calls
                $query2 = "select a.name,a.enabled,c.email,c.invoice_email,c.address from ".$dbname.".terminators a LEFT JOIN ".$dbname.".companies c ON a.company_id=c.id"; // and userfield like '%outbound%'  removed for inbound calls
                $results1 = DB::connection('pbxmysql')->select($query1);
                $results2 = DB::connection('pbxmysql')->select($query2);
                if(count($results1)>0 || count($results2)>0){
                    $tempItemData = array();
                    $batch_insert_array = array();
                    if(count($addparams)>0){
                        $CompanyGatewayID = $addparams['CompanyGatewayID'];
                        $CompanyID = $addparams['CompanyID'];
                        $ProcessID = $addparams['ProcessID'];
                        foreach ($results1 as $temp_row) {
                            $count = DB::table('tblAccount')->where(["AccountName" => $temp_row->name, "AccountType" => 1,"CompanyId"=>$CompanyID,"IsCustomer" => 1])->count();
                            if($count==0){
                                $tempItemData['AccountName'] = $temp_row->name;
                                $tempItemData['FirstName'] = "";
                                $tempItemData['Address1'] = $temp_row->address;
                                $tempItemData['Phone'] = "";
                                $tempItemData['BillingEmail'] = $temp_row->invoice_email;
                                $tempItemData['Email'] = $temp_row->email;
                                $tempItemData['AccountType'] = 1;
                                $tempItemData['CompanyId'] = $CompanyID;
                                $tempItemData['Status'] = $temp_row->enabled == 'yes' ? 1 : 0;
                                $tempItemData['IsCustomer'] = 1;
                                $tempItemData['IsVendor'] = 0;
                                $tempItemData['LeadSource'] = 'Gateway import';
                                $tempItemData['CompanyGatewayID'] = $CompanyGatewayID;
                                $tempItemData['ProcessID'] = $ProcessID;
                                $tempItemData['created_at'] = $addparams['ImportDate'];
                                $tempItemData['created_by'] = 'Imported';
                                $batch_insert_array[] = $tempItemData;
                            }
                        }
                        foreach ($results2 as $temp_row) {
                            $count = DB::table('tblAccount')->where(["AccountName" => $temp_row->name, "AccountType" => 1,"CompanyId"=>$CompanyID,"IsVendor" => 1])->count();
                            if($count==0){
                                $tempItemData['AccountName'] = $temp_row->name;
                                $tempItemData['FirstName'] = "";
                                $tempItemData['Address1'] = $temp_row->address;
                                $tempItemData['Phone'] = "";
                                $tempItemData['BillingEmail'] = $temp_row->invoice_email;
                                $tempItemData['Email'] = $temp_row->email;
                                $tempItemData['AccountType'] = 1;
                                $tempItemData['CompanyId'] = $CompanyID;
                                $tempItemData['Status'] = $temp_row->enabled == 'yes' ? 1 : 0;
                                $tempItemData['IsCustomer'] = 0;
                                $tempItemData['IsVendor'] = 1;
                                $tempItemData['LeadSource'] = 'Gateway import';
                                $tempItemData['CompanyGatewayID'] = $CompanyGatewayID;
                                $tempItemData['ProcessID'] = $ProcessID;
                                $tempItemData['created_at'] = $addparams['ImportDate'];
                                $tempItemData['created_by'] = 'Imported';
                                $batch_insert_array[] = $tempItemData;
                            }
                        }
                        if (!empty($batch_insert_array)) {
                            //Log::info('insertion start');
                            try{
                                if(DB::table('tblTempAccount')->insert($batch_insert_array)){
                                    $response['result'] = 'OK';
                                }
                            }catch(Exception $err){
                                $response['faultString'] =  $err->getMessage();
                                $response['faultCode'] =  $err->getCode();
                                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $err->getCode(). ", Reason: " . $err->getMessage());
                                //throw new Exception($err->getMessage());
                            }
                            //Log::info('insertion end');
                        }else{
                            $response['result'] = 'OK';
                        }
                    }
                }
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