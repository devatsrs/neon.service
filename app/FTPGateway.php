<?php
namespace App;

use App\Lib\AmazonS3;
use App\Lib\CompanyConfiguration;
use App\Lib\CompanyGateway;
use App\Lib\Gateway;
use App\Lib\RemoteSSH;
use Collective\Remote\RemoteFacade;
use \Exception;
use App\Lib\GatewayAPI;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Crypt;
class FTPGateway{

    private static $config = array();

    const DEFAULT_FILENAME = ".csv";
    const DEFAULT_GATEWAYNAME = "FTP";

    private static $FTPSGatewayObj ;
    public function __construct($CompanyGatewayID){


        $setting = GatewayAPI::getSetting($CompanyGatewayID,self::DEFAULT_GATEWAYNAME);
        foreach((array)$setting as $configkey => $configval){
            if($configkey == 'password' && !empty($configval)){
                self::$config[$configkey] = Crypt::decrypt($configval);
            }else{
                self::$config[$configkey] = $configval;
            }
        }

        if(isset(self::$config['protocol_type']) && self::$config['protocol_type'] == Gateway::SSH_FILE_TRANSFER) {

            if (count(self::$config) && isset(self::$config['host']) && isset(self::$config['username']) && isset(self::$config['password'])) {
                Config::set('remote.connections.production', self::$config);

                if(isset(self::$config["key"]) && !empty(self::$config["key"]) ) {

                    $CompanyID = CompanyGateway::where(array('CompanyGatewayID'=>$CompanyGatewayID))->pluck('CompanyID');
                    $UPLOADPATH = CompanyConfiguration::get($CompanyID,'UPLOAD_PATH');
                    $full_key_path = $UPLOADPATH   . "/" . self::$config["key"];

                    if(!file_exists($full_key_path)) {
                        $path = AmazonS3::download($CompanyID, self::$config["key"], $full_key_path);
                        $full_key_path = "";
                        if (file_exists($path)) {
                            $full_key_path = $path;
                        } else {

                        }
                    }

                    Config::set('remote.connections.production.key',   $full_key_path);

                }


            }
        }else {

            if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['username']) && isset(self::$config['password'])){
                self::$FTPSGatewayObj  = new FTPSGateway($CompanyGatewayID);
            }
        }

    }

    public static function getFileLocation($CompanyID){

        $TEMP_PATH = CompanyConfiguration::get($CompanyID,'TEMP_PATH');

        $FTP_FILE_PATH = $TEMP_PATH . '/' . "ftp_files";

        if (!is_dir($FTP_FILE_PATH)) {
            //@mkdir($FTP_FILE_PATH, 0777, true);
            RemoteSSH::make_dir($CompanyID,$FTP_FILE_PATH);
        }

        return $FTP_FILE_PATH;

    }

    public static function getCDRs($addparams=array()){

        if(!empty(self::$FTPSGatewayObj)){
            return self::$FTPSGatewayObj->getCDRs($addparams);
        }

        $response = array();
        if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['username']) && isset(self::$config['password'])){
            $filename = array();
            $files =  RemoteFacade::nlist(self::$config['cdr_folder']);
            $FileNameRule = self::DEFAULT_FILENAME;
            if(isset(self::$config['FileNameRule'])  && !empty(self::$config["FileNameRule"]) ){
                $FileNameRule = trim(self::$config["FileNameRule"]);
            }

            foreach((array)$files as $file){
                if(strpos($file,$FileNameRule) !== false){
                    $filename[] =$file;
                }
            }
            asort($filename);
            $filename = array_values($filename);
            if(isset($addparams["SkipOneFile"])){
                $lastele = array_pop($filename);
            }
            $response = $filename;
        }
        return $response;
    }
    public static function deleteCDR($addparams=array()){

        if(!empty(self::$FTPSGatewayObj)){
            return self::$FTPSGatewayObj->deleteCDR($addparams);
        }
        $status = false;
        if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['username']) && isset(self::$config['password'])){
            $status =  RemoteFacade::delete(self::$config['cdr_folder'].'/'.$addparams['filename']);
            if($status == true){

            }
        }
        return $status;
    }
    public static function downloadCDR($addparams=array()){
        if(!empty(self::$FTPSGatewayObj)){
            return self::$FTPSGatewayObj->downloadCDR($addparams);
        }

        $status = false;
        if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['username']) && isset(self::$config['password'])){
            $status = RemoteFacade::get(self::$config['cdr_folder'] .'/'. $addparams['filename'], $addparams['download_path'] . $addparams['filename']);
            if(isset($addparams['download_temppath'])){
                RemoteFacade::get(self::$config['cdr_folder'] .'/'. $addparams['filename'], $addparams['download_temppath'] . $addparams['filename']);
            }
        }
        return $status;
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