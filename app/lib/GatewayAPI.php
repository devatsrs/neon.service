<?php
namespace App\Lib;


class GatewayAPI extends \Eloquent {
	protected $fillable = [];

    public static function getSetting($CompanyGatewayID,$gatewayname){
        $gatewayid = Gateway::getGatewayID($gatewayname);
        if($gatewayid >0){
            $companysetting =  CompanyGateway::getCompanyGatewayConfig($CompanyGatewayID);
           return (array)json_decode($companysetting);
        }
    }


}