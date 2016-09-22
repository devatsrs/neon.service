<?php
namespace App\Lib;
class AccountBilling extends \Eloquent {
    //
    protected $guarded = array("AccountBillingID");

    protected $table = 'tblAccountBilling';

    protected $primaryKey = "AccountBillingID";

    public $timestamps = false; // no created_at and updated_at

    public static function getBilling($AccountID){
        return AccountBilling::where('AccountID',$AccountID)->first();
    }
    public static function getBillingKey($AccountBilling,$key){
        return !empty($AccountBilling)?$AccountBilling->$key:'';
    }
    public static function getInvoiceTemplateID($AccountID){
        return AccountBilling::where('AccountID',$AccountID)->pluck('InvoiceTemplateID');
    }
    public static function getSendInvoiceSetting($AccountID){
        return AccountBilling::where('AccountID',$AccountID)->pluck('SendInvoiceSetting');
    }

    public static function getBillingClass($AccountID){
        $BillingClassID = (int)AccountBilling::where(array('AccountID'=>$AccountID))->pluck('BillingClassID');
        return BillingClass::getBillingClass($BillingClassID);
    }
    public static function getBillingClassKey($BillingClass,$key){
        return !empty($BillingClass)?$BillingClass->$key:'';
    }
}
