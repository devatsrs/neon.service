<?php
namespace App\Lib;

class AccountOneOffCharge extends \Eloquent {
    protected $fillable = [];
    protected $connection = "sqlsrv2";
    protected $table = "tblAccountOneOffCharge";
    protected $primaryKey = "AccountOneOffChargeID";
    protected $guarded = array('AccountOneOffChargeID');


    public static function check(){
        return true;
    }

    public static function getAccountOneoffChargesByDate($AccountID,$ServiceID,$AccountServiceID,$StartDate,$EndDate){
        $Result = AccountOneOffCharge::where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID,'AccountServiceID'=>$AccountServiceID])->whereBetween('Date',[$StartDate,$EndDate])->get();
        return $Result;
    }
}