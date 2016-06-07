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

    private static function isrunning() {

        $pids = explode(PHP_EOL, `ps -e | grep php | awk '{print $1}'`);
        if(in_array(self::$pid, $pids)) {
            return TRUE;
        }
        return FALSE;
    }

    public static function lock($command) {

        $lock_file = getenv("TEMP_PATH").$command.'.lock';

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

         $lock_file = getenv("TEMP_PATH").$command.'.lock';

        if(file_exists($lock_file)){

            unlink($lock_file);
        }

        Log::info("==".self::$pid."== Releasing lock...");

        return TRUE;
    }

}
