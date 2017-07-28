<?php
namespace App;

use App\Lib\NeonExcelIO;
use Collective\Remote\RemoteFacade;
use App\Lib\GatewayAPI;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class Streamco{
    private static $config = array();
    private static $cli;
    private static $timeout=0; /* 60 seconds timeout */
    private static $dbname1 = 'storage';

   public function __construct($CompanyGatewayID) {
       $setting = GatewayAPI::getSetting($CompanyGatewayID,'Streamco');
       foreach((array)$setting as $configkey => $configval){
           if($configkey == 'password' ||  $configkey == 'dbpassword'){
               self::$config[$configkey] = Crypt::decrypt($configval);
           }else{
               self::$config[$configkey] = $configval;
           }
       }

       self::$config['host'] = '188.227.186.98';
       self::$config['username']  = 'root';
       self::$config['password'] = 'KatiteDo48';

       if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['dbusername']) && isset(self::$config['dbpassword'])){
           extract(self::$config);
           Config::set('database.connections.pbxmysql.host',$host);
           Config::set('database.connections.pbxmysql.database',self::$dbname1);
           Config::set('database.connections.pbxmysql.username',$dbusername);
           Config::set('database.connections.pbxmysql.password',$dbpassword);
       }

       // ssh detail
       if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['username']) && isset(self::$config['password'])){
           Config::set('remote.connections.production.host',self::$config['host']);
           Config::set('remote.connections.production.username',self::$config['username']);
           Config::set('remote.connections.production.password',self::$config['password']);
       }

       Log::info(self::$config);

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


    public static function getAccountCDRs($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{

                $query = "select u.name as username,c.caller_id as  cli,c.callee_id as cld, c.ID as ID ,c.start_time as connect_time,c.end_time as disconnect_time ,c.total_seconds as duration,c.answered_seconds as billed_second,price as cost,hangup_cause as disposition,code as prefix
                    from originator_billed_cdr c
                    left join config.originators u on c.originator_id = u.id
                    where `end_time` >= '" . $addparams['start_date_ymd'] . "' and `end_time` < '" . $addparams['end_date_ymd'] . "'";

                Log::info($query);
                $response = DB::connection('pbxmysql')->select($query);
            }catch(\Exception $e){
                $response['faultString'] =  $e->getMessage();
                $response['faultCode'] =  $e->getCode();
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $e->getCode(). ", Reason: " . $e->getMessage());
                throw new \Exception($e->getMessage());
            }
        }
        return $response;

    }
    public static function getVAccountCDRs($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{

                $query = "select u.name as providername,c.caller_id as  cli,c.callee_id as cld,IFNULL(cc.ID,c.ID) as ID, c.ID as ID2,c.start_time as connect_time,c.end_time as disconnect_time ,c.total_seconds as duration,c.answered_seconds as billed_second,c.price as provider_price,c.hangup_cause as disposition,c.code as provider_prefix,cc.price as cost
                    from terminator_billed_cdr c
                    left join config.terminators u on c.terminator_id = u.id
                    left join originator_billed_cdr cc on c.call_id = cc.call_id
                    where c.`end_time` >= '" . $addparams['start_date_ymd'] . "' and c.`end_time` < '" . $addparams['end_date_ymd'] . "'";

                Log::info($query);
                $response = DB::connection('pbxmysql')->select($query);
            }catch(\Exception $e){
                $response['faultString'] =  $e->getMessage();
                $response['faultCode'] =  $e->getCode();
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $e->getCode(). ", Reason: " . $e->getMessage());
                throw new \Exception($e->getMessage());
            }
        }
        return $response;

    }

    /** get list of array of files
     * @return array
     */
    public function getCustomerRateFile($FileLocationFrom=''){

        $response = array();
        if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['username']) && isset(self::$config['password'])){
            $filename = array();
            $files =  RemoteFacade::nlist($FileLocationFrom);
            foreach((array)$files as $file){
                if(strpos($file,'.csv') !== false && strpos($file,'customer_rate') !== false){
                    $filename[] =$file;
                }
            }
            asort($filename);
            $filename = array_values($filename);
            //$lastele = array_pop($filename); no pop required now
            $response = $filename;
        }
        return $response;

    }

    /** get list of array of files
     * @return array
     */
    public function getVendorRateFile($FileLocationFrom=''){

        $response = array();
        if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['username']) && isset(self::$config['password'])){
            $filename = array();
            $files =  RemoteFacade::nlist($FileLocationFrom);
            foreach((array)$files as $file){
                if(strpos($file,'.csv') !== false && strpos($file,'vendor_rate') !== false){
                    $filename[] =$file;
                }
            }
            asort($filename);
            $filename = array_values($filename);
            //$lastele = array_pop($filename); no pop required now
            $response = $filename;
        }
        return $response;

    }


    /** download ratesheet file
     * @param array $addparams
     * @return bool
     */
    public static function downloadRemoteFile($addparams=array()){
        $status = false;
        if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['username']) && isset(self::$config['password'])){
            $downloading_path = $addparams['download_path'] .'/'. str_random(20); // basename($addparams['filename']);
            $new_path = $addparams['download_path'] .'/'. $addparams['filename'];
            $status = RemoteFacade::get($addparams['FileLocationFrom'] .'/'. $addparams['filename'], $downloading_path);
            if(!rename( $downloading_path , $new_path )){
                @unlink($downloading_path);
            }
        }
        return $status;
    }

    public static function getFileContent($FilePath){

        if (file_exists($FilePath)) {

            $NeonExcel = new NeonExcelIO($FilePath,["Delimiter"=>",","Enclosure"=>'']);
            return $results = $NeonExcel->read();
        }
        return false;

    }
}