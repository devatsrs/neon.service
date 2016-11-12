<?php
namespace App\Lib;

class Country extends \Eloquent {
	protected $fillable = [];
    protected $guarded = array('CountryID');
    protected $table = 'tblCountry';
    protected  $primaryKey = "CountryID";

    public static function getCountryName($CountryID){
        return Country::where(["CountryID"=>$CountryID])->pluck('Country');
    }
}