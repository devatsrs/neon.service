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
    public static function getCityTariffDD($CompanyID){
        return ServiceTemplate::where("CompanyID",$CompanyID)->where("city_tariff",'!=','')->orderBy('city_tariff')->lists("city_tariff", "city_tariff");
    }
    public static function getCountryPrefixDD($CompanyID){
        return $country = ServiceTemplate::Join('tblCountry', function($join) {
            $join->on('tblServiceTemplate.country','=','tblCountry.country');
        })->select('tblServiceTemplate.country AS country','tblCountry.Prefix As Prefix')->where("tblServiceTemplate.CompanyID",$CompanyID)
            ->orderBy('tblServiceTemplate.country')->lists("country", "Prefix");
    }
}