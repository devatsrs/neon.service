<?php

namespace App\Lib;

use Collective\Remote\RemoteFacade;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Log;

class RemoteSSH{
    private static $config = array();
    public static $uploadPath = '';

    public static function setConfig($CompanyID){
        //$Configuration = CompanyConfiguration::getValueConfigurationByKey($CompanyID,'SSH');
        $Configuration = CompanyConfiguration::get($CompanyID,'SSH');

        if(!empty($Configuration)){
            self::$config = json_decode($Configuration,true);
        }
        if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['username']) && isset(self::$config['password'])){
            Config::set('remote.connections.production',self::$config);
        }
    }

    /** Execute command and return output
     * @param array $commands
     * @return array
     */
    public static function run($CompanyID,$commands = array()){

        self::setConfig($CompanyID);

        //Log::info($commands);

        $output = array();
        RemoteFacade::run($commands, function($line) use(&$output) {
            $output[]=trim($line.PHP_EOL);
        });

        //Log::info($output);


        return $output;
        /*
        if( count($output) == 1 && is_numeric($output[0])){
            // PID
            return $output[0];
        }
        else{
            // Other OUTPUT
            return $output;
        }*/

    }

    public static function setManualConfig($Configuration){

        if(!empty($Configuration)){
            self::$config = $Configuration;
        }
        if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['username']) && isset(self::$config['password'])){
            Config::set('remote.connections.production',self::$config);
        }
    }

    /** Execute command and return output
     * @param array $commands
     * @return array
     */
    public static function manualRun($commands = array()){
        $output = array();
        RemoteFacade::run($commands, function($line) use(&$output) {
            $output[]=trim($line.PHP_EOL);
        });

        return $output;
    }

    /** Upload local file to remote location
     * @param array $commands
     * @return array
     */
    public static function put($localpath,$remotepath){
        RemoteFacade::put($localpath,$remotepath);
    }

    public static function make_dir($CompanyID,$folder, $permission = "775" ){

        self::setConfig($CompanyID);

        $command  = "mkdir -p " . $folder;
        self::run($CompanyID, $command);

        $command2  = "chmod -R ". $permission . " ".$folder;
        self::run($CompanyID, $command2);

    }
}