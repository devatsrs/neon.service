<?php
namespace App;

use App\Lib\CompanyConfiguration;
use Collective\Remote\RemoteFacade;
use \Exception;
use App\Lib\GatewayAPI;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Crypt;

class FTPSGateway{

    var $config = array();
    var $ftp  = "";

    var $DEFAULT_FILENAME = ".csv";

    var $DEFAULT_GATEWAYNAME = "FTP";

    public function __construct($CompanyGatewayID){

        $setting = GatewayAPI::getSetting($CompanyGatewayID,$this->DEFAULT_GATEWAYNAME);
        foreach((array)$setting as $configkey => $configval){
            if($configkey == 'password'){
                $this->config[$configkey] = Crypt::decrypt($configval);
            }else{
                $this->config[$configkey] = $configval;
            }
        }
        if(count($this->config) && isset($this->config['host']) && isset($this->config['username']) && isset($this->config['password'])){

            if(!isset($this->config['port'])){
                $this->config['port'] = "21";
            }
            if(!isset($this->config['ssl'])){
                $this->config['ssl'] = 0;
            }
            if(!isset($this->config['passive_mode'])){
                $this->config['passive_mode'] = 0;
            }

            $this->ftp = new \FtpClient\FtpClient();
            $this->ftp->connect($this->config['host'], boolval($this->config['ssl']), $this->config['port']);
            if($this->ftp->login($this->config['username'],$this->config['password'])) {
                if($this->config['passive_mode']){
                    $this->ftp->pasv(true);
                }
            }
        }
    }

    public function getFileLocation($CompanyID){

        $TEMP_PATH = CompanyConfiguration::get($CompanyID,'TEMP_PATH');

        $FTP_FILE_PATH = $TEMP_PATH . '/' . "ftp_files";

        if (!is_dir($FTP_FILE_PATH)) {
            @mkdir($FTP_FILE_PATH, 0777, true);
        }

        return $FTP_FILE_PATH;

    }

    public function getCDRs($addparams=array()){
        $response = array();
        if(count($this->config) && isset($this->config['host']) && isset($this->config['username']) && isset($this->config['password'])){
            $filename = array();
//            $files =  RemoteFacade::nlist($this->config['cdr_folder']);
            $files = $this->ftp->nlist($this->config['cdr_folder']);

            $FileNameRule = $this->DEFAULT_FILENAME;
            if(isset($this->config['FileNameRule'])  && !empty($this->config["FileNameRule"]) ){
                $FileNameRule = trim($this->config["FileNameRule"]);
            }
            foreach((array)$files as $file){
                if(strpos($file,$FileNameRule) !== false){
                    $filename[] =  basename($file);
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

    //-- Not in use
    public function deleteCDR($addparams=array()){
        $status = false;
        if(count($this->config) && isset($this->config['host']) && isset($this->config['username']) && isset($this->config['password'])){
            $status =  $this->ftp->delete($this->config['cdr_folder'].'/'.$addparams['filename']);
            if($status == true){

            }
        }
        return $status;
    }
    public function downloadCDR($addparams=array()){
        $status = false;
        if(count($this->config) && isset($this->config['host']) && isset($this->config['username']) && isset($this->config['password'])){
            $status = $this->ftp->get($addparams['download_path'] . basename($addparams['filename']),$this->config['cdr_folder'] .'/'. basename($addparams['filename']), FTP_ASCII  );
            if(isset($addparams['download_temppath'])){
                $this->ftp->get( $addparams['download_temppath'] . $addparams['filename'],$this->config['cdr_folder'] .'/'. $addparams['filename'], FTP_ASCII  );
            }
        }
        return $status;
    }

    /**
     * get date time from unix timestamp
     */
    public function get_file_datetime($filename){

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