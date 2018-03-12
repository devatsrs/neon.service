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


    /**
     *
     *
     *
     *  PBX Columns
     * --------------------------------------------------------
     * Database:  asteriskcdrdb
     * Database:  asterisk
     * --------------------------------------------------------
     * Table: asteriskcdrdb.cdr c
     * Table: asterisk.cc_callcosts cc
     * --------------------------------------------------------
     * ##################  PBX Columns ########################
     * ##################  ----------- ########################
     *
     * c.src
     * c.ID                                     ID
     * c.start                                  connect_time
     * c.end                                    disconnect_time
     * c.duration                               duration
     * c.billsec                                billed_second,billed_duration
     * c.realsrc as extension                   extension
     * c.accountcode                            --  GatewayAccountID,AccountNumber
     * c.firstdst                               if inbound call ,  cld
     * c.lastdst                               if outbound call ,  cld (if empty then firstdst) --
     * coalesce(sum(cc_cost)) as cc_cost        cost
     * c.pincode                                pincode
     * c.userfield                              userfield
     * cc_type                                  -- to check Failed Call or Ignore calls (used to check internal call)
     * disposition                              disposition
     *
     *--------------------------------------------------------
     */

    /**
     * PBX constructor.
     * @param $CompanyGatewayID
     */
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
           Config::set('database.connections.pbxmysql.database',self::$dbname2);
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
                $query = "select c.src, c.ID,c.`start`,c.`end`,c.duration,c.billsec,c.realsrc as extension,c.accountcode,c.firstdst,c.lastdst,coalesce(sum(cc_cost)) as cc_cost,c.pincode, c.userfield,cc_type,disposition
                    from asteriskcdrdb.cdr c
                    left outer join asterisk.cc_callcosts cc on
                     c.uniqueid=cc.cc_uniqueid and ( c.sequence=cc.cc_cdr_sequence or (c.sequence is null and cc.cc_cdr_sequence=0 ) ) /*-- Given by mirta same as in their front end.*/
                    where `end` >= '" . $addparams['start_date_ymd'] . "' and `end` < '" . $addparams['end_date_ymd'] . "'
                    AND (
                           userfield like '%outbound%'
                        or userfield like '%inbound%'
                        or ( userfield = '' AND  cc_type <> 'OUTNOCHARGE' )  /*-- Ignore Internal call*/
                        )
                    AND  cc_type <> 'OUTNOCHARGE'
                    AND ( dst<>'h' or duration <> 0 ) /*-- given by mirta*/
                    and prevuniqueid=''
                    group by ID,c.`start`,c.`end`,realsrc,firstdst,duration,billsec,userfield,uniqueid,prevuniqueid,lastdst,dst,pincode
                    "; // and userfield like '%outbound%'  removed for inbound calls
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
    public static function blockAccount($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{
                $count = DB::connection('pbxmysql')->table('te_tenants')->where('te_code', $addparams['te_code'])->count();
                $disabled = DB::connection('pbxmysql')->table('te_tenants')->where('te_code', $addparams['te_code'])->pluck('te_disabled');
                if($disabled == '' && $count) {
                    DB::connection('pbxmysql')->table('te_tenants')->where('te_code', $addparams['te_code'])->update(array('te_disabled'=>'on'));
                    $response = array('message'=>'account blocked');
                }
            }catch(Exception $e){
                $response['faultString'] =  $e->getMessage();
                $response['faultCode'] =  $e->getCode();
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $e->getCode(). ", Reason: " . $e->getMessage());
                throw new Exception($e->getMessage());
            }
        }
        return $response;
    }

    public static function unBlockAccount($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{
                $disabled = DB::connection('pbxmysql')->table('te_tenants')->where('te_code', $addparams['te_code'])->pluck('te_disabled');
                if($disabled == 'on') {
                    DB::connection('pbxmysql')->table('te_tenants')->where('te_code', $addparams['te_code'])->update(array('te_disabled'=> ''));
                    $response = array('message'=>'account unblocked');
                }
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