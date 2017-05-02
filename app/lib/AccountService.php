<?php
namespace App\Lib;
class AccountService extends \Eloquent {
	protected $fillable = [];
    protected $connection = "sqlsrv";
    protected $table = "tblAccountService";
    protected $primaryKey = "AccountServiceID";
    protected $guarded = array('AccountServiceID');

    public static function getServiceName($AccountID,$ServiceID){
        $servicename = AccountService::where(array('AccountID'=>$AccountID,'ServiceID'=>$ServiceID))->pluck('ServiceTitle');
        if(empty($servicename)){
            $servicename =  Service::getServiceName($ServiceID);
        }
        return $servicename;
    }

}