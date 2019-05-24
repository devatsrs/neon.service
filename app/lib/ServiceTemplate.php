<?php
namespace App\Lib;
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


    public static function getAccessTypeDD($CompanyID){
        return ServiceTemplate::where("CompanyID",$CompanyID)->where("accessType",'!=','')->orderBy('accessType')->lists("accessType", "accessType");
    }
    public static function getPrefixDD($CompanyID){
        return ServiceTemplate::where("CompanyID",$CompanyID)->where("prefixName",'!=','')->orderBy('prefixName')->lists("prefixName", "prefixName");
    }
    public static function getCityDD($CompanyID){
        return ServiceTemplate::where("CompanyID",$CompanyID)->where("City",'!=','')->orderBy('City')->lists("City", "City");
    }
    public static function getTariffDD($CompanyID){
        return ServiceTemplate::where("CompanyID",$CompanyID)->where("Tariff",'!=','')->orderBy('Tariff')->lists("Tariff", "Tariff");
    }
    public static function getCountryPrefixDD(){
        return $country = Country::select('Country AS country','Prefix')->orderBy('country')->lists("country", "Prefix");
    }
}