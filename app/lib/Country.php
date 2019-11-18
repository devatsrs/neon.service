<?php
namespace App\Lib;

use Illuminate\Support\Facades\Cache;

class Country extends \Eloquent {
	protected $fillable = [];
    protected $guarded = array('CountryID');
    protected $table = 'tblCountry';
    protected  $primaryKey = "CountryID";
    public static $enable_cache = false;

    public static $cache = array(
        "country_dropdown_cache",   // Country => Country
    );

    public static function getCountryName($CountryID){
        return Country::where(["CountryID"=>$CountryID])->pluck('Country');
    }
    public static function getCountryCode($CountryID){
        return Country::where(["CountryID"=>$CountryID])->pluck('ISO2');
    }

    public static function getCountryDropdownList($is_all=''){

        if (self::$enable_cache && Cache::has('country_dropdown_cache')) {
            //check if the cache has already the ```user_defaults``` item
            $admin_defaults = Cache::get('country_dropdown_cache');
            //get the admin defaults
            self::$cache['country_dropdown_cache'] = $admin_defaults['country_dropdown_cache'];
        } else {
            //if the cache doesn't have it yet
            self::$cache['country_dropdown_cache'] = Country::lists('Country', 'Country');

            self::$cache['country_dropdown_cache'] = array("" => "Select")+ self::$cache['country_dropdown_cache'];

            //cache the database results so we won't need to fetch them again for 10 minutes at least
            Cache::forever('country_dropdown_cache', array('country_dropdown_cache' => self::$cache['country_dropdown_cache']));

        }

        if($is_all == 'All'){
            unset(self::$cache['country_dropdown_cache'][""]);
            self::$cache['country_dropdown_cache'] = array("All" => "All")+self::$cache['country_dropdown_cache'];
        }

        return self::$cache['country_dropdown_cache'];
    }
}