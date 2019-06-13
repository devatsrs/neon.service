<?php
namespace App\Lib;
use Illuminate\Support\Facades\DB;

class ServiceTemplate extends \Eloquent
{
    protected $guarded = array("ServiceTemplateID");

    protected $table = 'tblServiceTemplate';

    protected $primaryKey = "ServiceTemplateId";

    public static $rules = array(
        'ServiceId' =>  'required',
        'Name' => 'required',
        'CurrencyId' => 'required',

       // 'selectedSubscription' => 'required',
       // 'selectedcategotyTariff' => 'required',
    );

    public static $updateRules = array(
        'ServiceId' =>  'required',
        'Name' => 'required',
        
       // 'selectedSubscription' => 'required',
       // 'selectedcategotyTariff' => 'required',
    );

    public static $ServiceType = array(""=>"Select", "voice"=>"Voice");


    public static function getAccessTypeDD($CompanyID,$includePrefix=0){
        if($includePrefix == 1)
            return ServiceTemplate::select('accessType',DB::raw('CONCAT("DBDATA-",accessType) AS accessTypeValue'))->where("CompanyID",$CompanyID)->where("accessType",'!=','')->orderBy('accessType')->lists("accessType", "accessTypeValue");
        else
            return ServiceTemplate::where("CompanyID",$CompanyID)->where("accessType",'!=','')->orderBy('accessType')->lists("accessType", "accessType");
    }
    public static function getPrefixDD($CompanyID,$includePrefix=0){
        if($includePrefix == 1)
            return ServiceTemplate::select('prefixName',DB::raw('CONCAT("DBDATA-",prefixName) AS prefixNameValue'))->where("CompanyID",$CompanyID)->where("prefixName",'!=','')->orderBy('prefixName')->lists("prefixName", "prefixNameValue");
        else
            return ServiceTemplate::where("CompanyID",$CompanyID)->where("prefixName",'!=','')->orderBy('prefixName')->lists("prefixName", "prefixName");
    }
    public static function getCityDD($CompanyID,$includePrefix=0){
        if($includePrefix == 1)
            return ServiceTemplate::select('City',DB::raw('CONCAT("DBDATA-",City) AS CityValue'))->where("CompanyID",$CompanyID)->where("City",'!=','')->orderBy('City')->lists("City", "CityValue");
        else
            return ServiceTemplate::where("CompanyID",$CompanyID)->where("City",'!=','')->orderBy('City')->lists("City", "City");
    }
    public static function getTariffDD($CompanyID,$includePrefix=0){
        if($includePrefix == 1)
            return ServiceTemplate::select('Tariff',DB::raw('CONCAT("DBDATA-",Tariff) AS TariffValue'))->where("CompanyID",$CompanyID)->where("Tariff",'!=','')->orderBy('Tariff')->lists("Tariff", "TariffValue");
        else
            return ServiceTemplate::where("CompanyID",$CompanyID)->where("Tariff",'!=','')->orderBy('Tariff')->lists("Tariff", "Tariff");
    }
    public static function getCountryPrefixDD($includePrefix=0){
        if($includePrefix == 1)
            return $country = Country::select('Country AS country',DB::raw('CONCAT("DBDATA-",Prefix) AS Prefix'))->orderBy('country')->lists("country", "Prefix");
        else
            return $country = Country::select('Country AS country','Prefix')->orderBy('country')->lists("country", "Prefix");
    }
}