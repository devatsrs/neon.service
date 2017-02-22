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

    public static $ServiceType = array(""=>"Select", "voice"=>"Voice", "data"=>"Data", "sms"=>"SMS");

    public static function getServiceID($CompanyID,$ServiceType){
        return Service::where(array('CompanyID'=>$CompanyID,'ServiceType'=>$ServiceType))->pluck('ServiceID');
    }

}