<?php
namespace App;

use Collective\Remote\RemoteFacade;
use \Exception;
use App\Lib\GatewayAPI;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Crypt;
class VOS5000{
    private static $config = array();

    /**
    VOS cSV columns


    0	=	callere164
    1	=	calleraccesse164
    2	=	calleee164
    3	=	calleeaccesse164
    4	=	callerip
    5	=	callergatewayid
    6	=	callerproductid
    7	=	callertogatewaye164
    8	=	callertype
    9	=	calleeip
    10	=	calleegatewayid
    11	=	calleeproductid
    12	=	calleetogatewaye164
    13	=	calleetype
    14	=	billingmode
    15	=	calllevel
    16	=	agentfeetime
    17	=	starttime
    18	=	stoptime
    19	=	callerpdd
    20	=	calleepdd
    21	=	holdtime
    22	=	callerareacode
    23	=	feetime
    24	=	fee
    25	=	suitefee
    26	=	suitefeetime
    27	=	incomefee
    28	=	customeraccount
    29	=	customername
    30	=	calleeareacode
    31	=	agentfee
    32	=	agentsuitefee
    33	=	agentsuitefeetime
    34	=	agentaccount
    35	=	agentname
    36	=	flowno
    37	=	softswitchname
    38	=	softswitchcallid
    39	=	callercallid
    40	=	calleecallid
    41	=	enddirection
    42	=	endreason
    43	=	billingtype
    44	=	cdrlevel
    45	=	agentcdr_id
    46	=	failed_gateways

     */

    public function __construct($CompanyGatewayID){
        $setting = GatewayAPI::getSetting($CompanyGatewayID,'VOS5000');
        foreach((array)$setting as $configkey => $configval){
            if($configkey == 'password'){
                self::$config[$configkey] = Crypt::decrypt($configval);
            }else{
                self::$config[$configkey] = $configval;
            }
        }
        if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['username']) && isset(self::$config['password'])){
            Config::set('remote.connections.production',self::$config);
        }
    }
    public static function getCDRs($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['username']) && isset(self::$config['password'])){
            $filename = array();
            $files =  RemoteFacade::nlist(self::$config['cdr_folder']);
            foreach((array)$files as $file){
                if(strpos($file,'cdr_') !== false){
                    $filename[] =$file;
                }
            }
            asort($filename);
            $filename = array_values($filename);
            $lastele = array_pop($filename);
            $response = $filename;
        }
        return $response;
    }
    public static function deleteCDR($addparams=array()){
        $status = false;
        if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['username']) && isset(self::$config['password'])){
            $status =  RemoteFacade::delete(self::$config['cdr_folder'].'/'.$addparams['filename']);
            if($status == true){

            }
        }
        return $status;
    }
    public static function downloadCDR($addparams=array()){
        $status = false;
        if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['username']) && isset(self::$config['password'])){
            $status = RemoteFacade::get(self::$config['cdr_folder'] .'/'. $addparams['filename'], $addparams['download_path'] . $addparams['filename']);
            if(isset($addparams['download_temppath'])){
                RemoteFacade::get(self::$config['cdr_folder'] .'/'. $addparams['filename'], $addparams['download_temppath'] . $addparams['filename']);
            }
        }
        return $status;
    }

    //not in use
    public static function changeCDRFilesStatus($status,$delete_files,$CompanyGatewayID,$isSingle=false){

        if(empty($CompanyGatewayID) && !is_numeric($CompanyGatewayID)){
            throw new Exception("Invalid CompanyGatewayID");
        }

        if($status== "progress-to-pending" ) {
            if( is_array($delete_files) && count($delete_files)>0) {
                foreach ($delete_files as $filename) {
                    $inproress_name = Config::get('app.vos_location') . $CompanyGatewayID . '/' . basename($filename);
                    $complete_name = str_replace('progress', 'pending', Config::get('app.vos_location') . $CompanyGatewayID . '/' . basename($filename));
                    rename($inproress_name, $complete_name);
                    Log::info('progress-to-pending ' . $complete_name);

                }
            }
        }
        if($status== "pending-to-progress" ) {
            if($isSingle == true && is_string($delete_files) ){
                $filename = $delete_files;
                $inproress_name = Config::get('app.vos_location') . $CompanyGatewayID . '/' . basename($filename);
                $complete_file_name = str_replace('pending', 'progress', basename($filename));
                $complete_name = Config::get('app.vos_location') . $CompanyGatewayID . '/' . $complete_file_name;
                rename($inproress_name, $complete_name);
                Log::info('pending-to-progress ' . $complete_name);
                return array("new_filename"=>$complete_file_name,"new_file_fullpath"=>$complete_name);
            }
            if( is_array($delete_files) && count($delete_files)>0) {
                foreach ($delete_files as $filename) {

                    $inproress_name = Config::get('app.vos_location') . $CompanyGatewayID . '/' . basename($filename);
                    $complete_file_name = str_replace('pending', 'progress', basename($filename));
                    $complete_name = Config::get('app.vos_location') . $CompanyGatewayID . '/' . $complete_file_name;
                    rename($inproress_name, $complete_name);
                    Log::info('pending-to-progress ' . $complete_name);
                }
            }
        }
        if($status== "progress-to-complete" ) {
            if( is_array($delete_files) && count($delete_files)>0) {
                foreach ($delete_files as $filename) {
                    $inproress_name = Config::get('app.vos_location') . $CompanyGatewayID . '/' . basename($filename);
                    $complete_name = str_replace('progress', 'complete', Config::get('app.vos_location') . $CompanyGatewayID . '/' . basename($filename));
                    rename($inproress_name, $complete_name);
                    Log::info('progress-to-complete ' . $complete_name);

                    /*if(unlink($complete_name)){
                        Log::info("CDR delete file ".$filename." processID: ".$processID);
                    }else{
                        Log::info("CDR not delete file ".$filename." processID: ".$processID);
                    }*/
                }
            }
        }
    }

    /**
     * get date time from unix timestamp
     */
    public static function get_file_datetime($filename){

        if(empty($filename)){
            return '';
        }

        //cdr_20160609_151311.csv

        $filename = str_replace("cdr_","",$filename);
        $filename = str_replace("_","",$filename);
        $filename = str_replace(".csv","",$filename);

        $year = substr($filename,0,4);
        $month = substr($filename,4,2);
        $day = substr($filename,6,2);
        $hr = substr($filename,8,2);
        $min = substr($filename,10,2);
        $sec = substr($filename,12,2);

        return $year . '-' . $month . '-' . $day . ' ' . $hr . ':' . $min . ':' . $sec;

    }
}