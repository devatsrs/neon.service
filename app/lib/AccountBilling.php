<?php
namespace App\Lib;
class AccountBilling extends \Eloquent {
    //
    protected $guarded = array("AccountBillingID");

    protected $table = 'tblAccountBilling';

    protected $primaryKey = "AccountBillingID";

    const BILLINGTYPE_PREPAID = 1;
    const BILLINGTYPE_POSTPAID = 2;

    public $timestamps = false; // no created_at and updated_at

    public static function getBilling($AccountID,$ServiceID){
        return AccountBilling::where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID])->first();
    }
    public static function getBillingKey($AccountBilling,$key){
        return !empty($AccountBilling)?$AccountBilling->$key:'';
    }
    public static function getInvoiceTemplateID($AccountID,$ServiceID){
        $BillingClassID = self::getBillingClassID($AccountID,$ServiceID);
        return BillingClass::getInvoiceTemplateID($BillingClassID);
    }
    public static function getSendInvoiceSetting($AccountID){
        return AccountBilling::where(array('AccountID'=>$AccountID,'ServiceID'=>0))->pluck('SendInvoiceSetting');
    }
    public static function getBillingType($AccountID){
        return AccountBilling::where(array('AccountID'=>$AccountID,'ServiceID'=>0))->pluck('BillingType');
    }

    public static function getBillingClass($AccountID,$ServiceID){
        $BillingClassID = (int)AccountBilling::where(array('AccountID'=>$AccountID,'ServiceID'=>$ServiceID))->pluck('BillingClassID');
        if($BillingClassID == 0){
            $BillingClassID = (int)AccountBilling::where(array('AccountID'=>$AccountID,'ServiceID'=>0))->pluck('BillingClassID');
        }
        return BillingClass::getBillingClass($BillingClassID);
    }
    public static function getBillingClassKey($BillingClass,$key){
        return !empty($BillingClass)?$BillingClass->$key:'';
    }
    public static function getBillingClassID($AccountID,$ServiceID){
        $BillingClassID = (int)AccountBilling::where(array('AccountID'=>$AccountID,'ServiceID'=>$ServiceID))->pluck('BillingClassID');
        if($BillingClassID == 0){
            $BillingClassID = (int)AccountBilling::where(array('AccountID'=>$AccountID,'ServiceID'=>0))->pluck('BillingClassID');
        }
        return $BillingClassID;
    }
    public static function getPaymentDueInDays($AccountID,$ServiceID){
        $BillingClassID = self::getBillingClassID($AccountID,$ServiceID);
        return BillingClass::getPaymentDueInDays($BillingClassID);
    }
    public static function getRoundChargesAmount($AccountID,$ServiceID){
        $roundCharge = '';
        $BillingClassID = self::getBillingClassID($AccountID,$ServiceID);
        if(!empty($BillingClassID)){
            $roundCharge = BillingClass::getRoundChargesAmount($BillingClassID);
        }
        return $roundCharge;
    }
    public static function getRoundChargesCDR($AccountID,$ServiceID){
        $roundCharge = 2;
        $BillingClassID = self::getBillingClassID($AccountID,$ServiceID);
        if(!empty($BillingClassID)){
            $roundCharge = BillingClass::getRoundChargesCDR($BillingClassID);
        }
        return $roundCharge;
    }
    public static function getTaxRate($AccountID,$ServiceID){
        $BillingClassID = self::getBillingClassID($AccountID,$ServiceID);
        return BillingClass::getTaxRate($BillingClassID);
    }
}
