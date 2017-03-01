<?php
namespace App\Lib;

use \Illuminate\Support\Facades\Cache;

class CompanyConfiguration extends \Eloquent {

    protected $fillable = [];
    protected $guarded = array('CompanyConfigurationID');
    protected $table = 'tblCompanyConfiguration';
    public  $primaryKey = "CompanyConfigurationID";
    static protected  $enable_cache = true;
    public static $cache = ["CompanyConfiguration"];


    //without cache get value of configuration
    public static function getValueConfigurationByKey($CompanyID,$Key){
        if($CompanyID > 0){
            $ConfigurationValue = CompanyConfiguration::where(['CompanyID'=>$CompanyID,'Key'=>$Key])->pluck("Value");
            return $ConfigurationValue;
        }
    }


    public static function getConfiguration($CompanyID=0){
        $LicenceKey = getenv('LICENCE_KEY');
        $CompanyName = getenv('COMPANY_NAME');
        $CompanyConfiguration = 'CompanyConfiguration' . $LicenceKey.$CompanyName;

        if (self::$enable_cache && Cache::has($CompanyConfiguration)) {
            $cache = Cache::get($CompanyConfiguration);
            self::$cache['CompanyConfiguration'] = $cache['CompanyConfiguration'];
        } else {
            self::$cache['CompanyConfiguration'] = CompanyConfiguration::where(['CompanyID'=>$CompanyID])->lists('Value','Key');
            $CACHE_EXPIRE = self::$cache['CompanyConfiguration']['CACHE_EXPIRE'];
            $time = empty($CACHE_EXPIRE)?60:$CACHE_EXPIRE;
            $minutes = \Carbon\Carbon::now()->addMinutes($time);
            //Cache::forever($CompanyConfiguration, array('CompanyConfiguration' => self::$cache['CompanyConfiguration']));
            Cache::add($CompanyConfiguration, array('CompanyConfiguration' => self::$cache['CompanyConfiguration']), $minutes);
        }
        return self::$cache['CompanyConfiguration'];
    }

    public static function get($CompanyID,$key = ""){

        $cache = CompanyConfiguration::getConfiguration($CompanyID);

        if(!empty($key) ){

            if(isset($cache[$key])){
                return $cache[$key];
            }
        }
        return "";

    }

    public static function getJsonKey($CompanyID,$key = "",$index = ""){

        $cache = CompanyConfiguration::getConfiguration($CompanyID);

        if(!empty($key) ){

            if(isset($cache[$key])){

                $json = json_decode($cache[$key],true);
                if(isset($json[$index])){
                    return $json[$index];
                }
            }
        }
        return "";

    }
}