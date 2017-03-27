<?php
namespace App\Lib;
class AccountBilling extends \Eloquent {
    //
    protected $guarded = array("AccountBillingID");

    protected $table = 'tblAccountBilling';

    protected $primaryKey = "AccountBillingID";

    public $timestamps = false; // no created_at and updated_at

    public static function getBilling($AccountID,$ServiceID){
        return AccountBilling::where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID])->first();
    }
    public static function getBillingKey($AccountBilling,$key){
        return !empty($AccountBilling)?$AccountBilling->$key:'';
    }
    public static function getInvoiceTemplateID($AccountID){
        $BillingClassID = self::getBillingClassID($AccountID);
        return BillingClass::getInvoiceTemplateID($BillingClassID);
    }
    public static function getSendInvoiceSetting($AccountID){
        return AccountBilling::where(array('AccountID'=>$AccountID,'ServiceID'=>0))->pluck('SendInvoiceSetting');
    }

    public static function getBillingClass($AccountID){
        $BillingClassID = (int)AccountBilling::where(array('AccountID'=>$AccountID,'ServiceID'=>0))->pluck('BillingClassID');
        return BillingClass::getBillingClass($BillingClassID);
    }
    public static function getBillingClassKey($BillingClass,$key){
        return !empty($BillingClass)?$BillingClass->$key:'';
    }
    public static function getBillingClassID($AccountID){
        return AccountBilling::where(array('AccountID'=>$AccountID,'ServiceID'=>0))->pluck('BillingClassID');
    }
    public static function getPaymentDueInDays($AccountID){
        $BillingClassID = self::getBillingClassID($AccountID);
        return BillingClass::getPaymentDueInDays($BillingClassID);
    }
    public static function getCDRType($AccountID){
        $BillingClassID = self::getBillingClassID($AccountID);
        return BillingClass::getCDRType($BillingClassID);
    }
    public static function getRoundChargesAmount($AccountID){
        $roundCharge = '';
        $BillingClassID = self::getBillingClassID($AccountID);
        if(!empty($BillingClassID)){
            $roundCharge = BillingClass::getRoundChargesAmount($BillingClassID);
        }
        return $roundCharge;
    }
    public static function getTaxRate($AccountID){
        $BillingClassID = self::getBillingClassID($AccountID);
        return BillingClass::getTaxRate($BillingClassID);
    }

    public static function serviceBilling($AccountID){
        return AccountBilling::where(array('AccountID'=>$AccountID))
            ->where('ServiceID', '<>', '0')
            ->count();
    }
}
