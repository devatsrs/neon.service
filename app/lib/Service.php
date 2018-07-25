<?php
namespace App\Lib;
class Service extends \Eloquent {
    protected $guarded = array("ServiceID");

    protected $table = 'tblService';

    protected $primaryKey = "ServiceID";

    public static $rules = array(
        'ServiceName' =>      'required|unique:tblService',
        'CompanyID' =>  'required',
        'ServiceType' => 'required',
        'Status' =>     'between:0,1',
    );

    public static $defaultService = 'Other Service';

    public static $ServiceType = array(""=>"Select", "voice"=>"Voice", "data"=>"Data", "sms"=>"SMS");

    public static function getServiceID($CompanyID,$ServiceType){
        return Service::where(array('CompanyID'=>$CompanyID,'ServiceType'=>$ServiceType))->pluck('ServiceID');
    }
    public static function getGatewayServiceID($CompanyGatewayID){
        return Service::where(array('CompanyGatewayID'=>$CompanyGatewayID,'Status'=>1))->pluck('ServiceID');
    }

    public static function getServiceName($ServiceID){
        return Service::where(array('ServiceID'=>$ServiceID))->pluck('ServiceName');

    }
    public static function getServiceIDByName($ServiceName){
        return Service::where(array('ServiceName'=>$ServiceName))->pluck('ServiceID');

    }

}