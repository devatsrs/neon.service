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

    const  ACCOUNT_BALANCE = 1;
    const  PREFERRED_METHOD = 2;
    public static $AutoPayMethod = array('0'=>'Select' ,self::ACCOUNT_BALANCE => 'Account Balance',self::PREFERRED_METHOD=>'Preferred Method');

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

    public static function getAccountAutoPaymentMethod($AccountID,$ServiceID=0){
        $AutoPayMethod = (int)AccountBilling::where(array('AccountID'=>$AccountID,'ServiceID'=>$ServiceID))->pluck('AutoPayMethod');
        return $AutoPayMethod;
    }

    public static function getPendingBillingAccounts($Date = "",$TypeColumn = ""){

        if($Date == "") $Date = date("Y-m-d");
        $Accounts = Account::join('tblAccountBilling','tblAccountBilling.AccountID','=','tblAccount.AccountID')
                ->select(["tblAccount.AccountID","tblAccount.AccountName",'tblAccountBilling.NextInvoiceDate','tblAccountBilling.LastInvoiceDate','tblAccountBilling.BillingStartDate','tblAccountBilling.LastChargeDate','tblAccountBilling.NextChargeDate','tblAccountBilling.BillingType','tblAccountBilling.BillingCycleType','tblAccountBilling.BillingCycleValue'])
            ->where(["Status" => 1,"AccountType" => 1, $TypeColumn => 1])
            ->where('tblAccountBilling.NextInvoiceDate','<=',$Date)
            ->whereNotNull('tblAccountBilling.BillingCycleType');

        Log::info("Getting $TypeColumn: " . $Accounts->toSql());

        return $Accounts->get();
    }

}
