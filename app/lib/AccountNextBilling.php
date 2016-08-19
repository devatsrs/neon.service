<?php
namespace App\Lib;
class AccountNextBilling extends \Eloquent {
    //
    protected $guarded = array("AccountNextBillingID");

    protected $table = 'tblAccountNextBilling';

    protected $primaryKey = "AccountNextBillingID";

    public $timestamps = false; // no created_at and updated_at

    public static function getBilling($AccountID){
        return AccountNextBilling::where('AccountID',$AccountID)->first();
    }
    public static function getBillingKey($AccountBilling,$key){
        return !empty($AccountBilling)?$AccountBilling->$key:'';
    }
}
