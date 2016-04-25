<?php
namespace App;

use \Exception;
use App\Lib\GatewayAPI;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Crypt;
class PBX{
    private static $config = array();
    private static $dbname1 = 'asteriskcdrdb';
    private static $dbname2 = 'asterisk';
    private static $db1_tbl1_name = 'cdr';
    private static $connect;
    private static $timeout=0; /* 60 seconds timeout */


    public function __construct($CompanyGatewayID){
       $setting = GatewayAPI::getSetting($CompanyGatewayID,'PBX');
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
       if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
           try{
               if(DB::connection('pbxmysql')->getDatabaseName()){
                   $response['result'] = 'OK';
               }
           }catch(Exception $e){
               $response['faultString'] =  $e->getMessage();
               $response['faultCode'] =  $e->getCode();
           }
       }
       return $response;
    }

    public static function getAccountCDRs($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{
                if($addparams['RateCDR'] == 1) {
                    $query = "select c.src, c.ID,c.`start`,c.`end`,c.duration,c.billsec,c.realsrc as extension,c.accountcode,c.firstdst,c.lastdst,0 as cc_cost,c.pincode, c.userfield
                        from asteriskcdrdb.cdr c
                        where `end` >= '" . $addparams['start_date_ymd'] . "' and `end` < '" . $addparams['end_date_ymd'] . "'
                        AND (
                               userfield like '%outbound%'
                            or userfield like '%inbound%'
                            or ( userfield = '' AND  billsec > 0 AND LENGTH(lastdst)>=8 AND concat('',lastdst * 1) = lastdst )
                            )
                        AND ( dst<>'h' or duration <> 0 )
                        and prevuniqueid=''
                        group by ID,c.`start`,answer,c.`end`,clid,realsrc,firstdst,duration,billsec,disposition,dcontext,dstchannel,userfield,uniqueid,prevuniqueid,lastdst,wherelanded,dst,firstdst,srcCallID,linkedid,peeraccount,originateid,pincode
                        "; // and userfield like '%outbound%'  removed for inbound calls
                }else{
                    $query = "select c.src, c.ID,c.`start`,c.`end`,c.duration,c.billsec,c.realsrc as extension,c.accountcode,c.firstdst,c.lastdst,coalesce(sum(cc_cost)) as cc_cost,c.pincode, c.userfield
                        from asteriskcdrdb.cdr c
                        left outer join asterisk.cc_callcosts cc on
                         c.uniqueid=cc.cc_uniqueid and ( c.sequence=cc.cc_cdr_sequence or (c.sequence is null and cc.cc_cdr_sequence=0 ) )
                        where `end` >= '" . $addparams['start_date_ymd'] . "' and `end` < '" . $addparams['end_date_ymd'] . "'
                        AND (
                               userfield like '%outbound%'
                            or userfield like '%inbound%'
                            or ( userfield = '' AND  billsec > 0 AND LENGTH(lastdst)>=8 AND concat('',lastdst * 1) = lastdst )
                            )
                        AND ( dst<>'h' or duration <> 0 )
                        and prevuniqueid=''
                        group by ID,c.`start`,answer,c.`end`,clid,realsrc,firstdst,duration,billsec,disposition,dcontext,dstchannel,userfield,uniqueid,prevuniqueid,lastdst,wherelanded,dst,firstdst,srcCallID,linkedid,peeraccount,originateid,cc_country,cc_network,pincode
                        "; // and userfield like '%outbound%'  removed for inbound calls
                }
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