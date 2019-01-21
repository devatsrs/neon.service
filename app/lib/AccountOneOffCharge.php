<?php
namespace App\Lib;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class AccountOneOffCharge extends \Eloquent {
    protected $fillable = [];
    protected $connection = "sqlsrv2";
    protected $table = "tblAccountOneOffCharge";
    protected $primaryKey = "AccountOneOffChargeID";
    protected $guarded = array('AccountOneOffChargeID');


    public static function check(){
        return true;
    }

    public static function getAccountOneoffChargesByDate($AccountID,$ServiceID,$StartDate,$EndDate){
        $Result = AccountOneOffCharge::where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID])->whereBetween('Date',[$StartDate,$EndDate])->get();
        return $Result;
    }

}