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

}