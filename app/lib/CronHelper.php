<?php
/**
 * Created by PhpStorm.
 * User: deven
 * Date: 07/06/2016
 * Time: 4:15 PM
 */

namespace App\Lib;

use Illuminate\Support\Facades\Log;

class CronHelper {

    private static $pid;

    function __construct() {}

    function __clone() {}

    public static function get_command_file_name($command_name, $Cron) {

        $arguments = $Cron->argument();
        $lock_command_file =  $command_name;
        if($command_name == 'invoicegenerator' && count($arguments) > 0){
            unset($arguments['UserID']);
            unset($arguments['JobID']);
            foreach($arguments as $argument_key => $argument_value) {
                $lock_command_file .= "_" . $argument_key . "_" . $argument_value;
            }
        }else if(count($arguments) > 0) {
            foreach($arguments as $argument_key => $argument_value) {
                $lock_command_file .= "_" . $argument_key . "_" . $argument_value;
            }
        }

        return str_slug($lock_command_file);
    }

    public static function before_cronrun($command_name,$Cron) {
        $arguments = $Cron->argument();

        if(isset($arguments["CompanyID"]) && !empty($arguments["CompanyID"])){

            Company::setup_timezone($arguments["CompanyID"]);
        }
        $lock_command_file = self::get_command_file_name($command_name,$Cron);
        $MysqlProcess=self::isMysqlPIDExists($arguments['CronJobID']);
        if(($pid = CronHelper::lock($lock_command_file)) ==  FALSE || $MysqlProcess==1) {
            Log::info( $lock_command_file ." Already running....####");
            Log::info("#### MysqlProcess=".$MysqlProcess);
            exit;
        }
        Log::info( $lock_command_file ." #Starts# ");
    }

    public static function after_cronrun($command_name,$Cron) {

        $lock_command_file = self::get_command_file_name($command_name,$Cron);

        CronHelper::unlock($lock_command_file);
        Log::info($lock_command_file . " #Stops# ");
        Log::info(memory_get_usage(true)/(1024*1024) . " MB  #Memory Used# ");
    }

    private static function isrunning() {

        //@TODO: checkout for windows system
        //http://lifehacker.com/362316/use-unix-commands-in-windows-built-in-command-prompt
        $pids = explode(PHP_EOL, `ps -e | grep php | awk '{print $1}'`);
        
        if( !empty(self::$pid) && self::$pid > 0 && in_array(self::$pid, $pids)) {
            Log::info(" Running pids " . print_r($pids,true));
            return TRUE;
        }
        return FALSE;
    }

    public static function lock($command) {

        if (!file_exists(storage_path() . '/locks/')) {
            mkdir(storage_path() . '/locks/');
        }

        $lock_file = storage_path() . '/locks/'.$command.'.lock';

        if(file_exists($lock_file)) {
            //return FALSE;

            // Is running?
            self::$pid = file_get_contents($lock_file);
            if(self::isrunning()) {
                Log::error("==".self::$pid."== Already in progress...");
                return FALSE;
            }
            else {
                Log::info("==".self::$pid."== Previous job died abruptly...");
            }
        }

        self::$pid = getmypid();
        file_put_contents($lock_file, self::$pid);
        Log::info("==".self::$pid."== Lock acquired, processing the job...");

        return self::$pid;
    }

    public static function unlock($command) {

         $lock_file = storage_path() . '/locks/'.$command.'.lock';

        if(file_exists($lock_file)){

            unlink($lock_file);
        }

        Log::info("==".self::$pid."== Releasing lock...");

        return TRUE;
    }

    public static function isMysqlPIDExists($CronJobID){
        $isExists=0;
        $CronJob = CronJob::find($CronJobID);
        if(!empty($CronJob)){
            $MysqlPID=$CronJob->MysqlPID;
            if($MysqlPID!=''){
                $MysqlProcess=DB::select("SELECT * FROM INFORMATION_SCHEMA.PROCESSLIST WHERE ID=".$MysqlPID)->count();
                if($MysqlProcess > 0){
                    $isExists=1;
                }
            }
        }
        return $isExists;
    }

}
