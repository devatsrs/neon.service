<?php

namespace App\Lib;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class AccountBalanceTaxRateLog extends Model
{
    //
    protected $guarded = array("AccountBalanceTaxRateLogID");

    protected $table = 'tblAccountBalanceTaxRateLog';

    protected $primaryKey = "AccountBalanceTaxRateLogID";

    public $timestamps = false; // no created_at and updated_at

    public static function CreateUsageAccountBalanceTax($AccountID,$AccountBalanceUsageLogID,$TotalCharge){
        AccountBalanceTaxRateLog::where(array('ParentLogID'=>$AccountBalanceUsageLogID,'Type'=>Product::USAGE))->delete();
        //$TaxRateIDs = AccountBilling::getTaxRate($AccountID,0,0);
        $TaxRateIDs = Account::where(['AccountID'=>$AccountID])->pluck('TaxRateID');
        $TaxGrandTotal = 0;
        if(!empty($TaxRateIDs)){
            $TaxRateIDs = explode(",",$TaxRateIDs);
            foreach($TaxRateIDs as $TaxRateID) {
                $TaxRateID = intval($TaxRateID);
                if($TaxRateID>0){
                    $SubTotal = 0;
                    $TaxRate = TaxRate::where("TaxRateID",$TaxRateID)->first();
                    $Title = '';
                    if(isset($TaxRate->TaxType) && isset($TaxRate->Amount) ) {
                        if ($TaxRate->TaxType == TaxRate::TAX_ALL || $TaxRate->TaxType == TaxRate::TAX_USAGE) {
                            $SubTotal = $TotalCharge;
                            $Title = $TaxRate->Title;
                            $TotalTax = Invoice::calculateTotalTaxByTaxRateObj($TaxRate, $SubTotal);
                            $TaxGrandTotal += $TotalTax;
                            AccountBalanceTaxRateLog::create(array(
                                "ParentLogID"=>$AccountBalanceUsageLogID,
                                "Type"=>Product::USAGE,
                                "TaxRateID" => $TaxRateID,
                                "TaxAmount" => $TotalTax,
                                "Title" => $Title,
                                "created_at"=>date('Y-m-d H:i:s'),
                                "updated_at"=>date('Y-m-d H:i:s')
                            ));
                        }
                    }
                }
            }
        }
        return $TaxGrandTotal;
    }

    public static function CreateSubscriptiontBalanceTax($AccountID,$AccountBalanceSubscriptionLogID,$TotalCharge,$ProductType){
        AccountBalanceTaxRateLog::where(array('ParentLogID'=>$AccountBalanceSubscriptionLogID,'Type'=>$ProductType))->delete();
        //$TaxRateIDs = AccountBilling::getTaxRate($AccountID,0,0);
        $TaxRateIDs = Account::where(['AccountID'=>$AccountID])->pluck('TaxRateID');
        $TaxGrandTotal = 0;
        if(!empty($TaxRateIDs)){
            $TaxRateIDs = explode(",",$TaxRateIDs);
            foreach($TaxRateIDs as $TaxRateID) {
                $TaxRateID = intval($TaxRateID);
                if($TaxRateID>0){
                    $SubTotal = 0;
                    $TaxRate = TaxRate::where("TaxRateID",$TaxRateID)->first();
                    $Title = '';
                    if(isset($TaxRate->TaxType) && isset($TaxRate->Amount) ) {
                        if ($TaxRate->TaxType == TaxRate::TAX_ALL || $TaxRate->TaxType == TaxRate::TAX_RECURRING) {
                            $SubTotal = $TotalCharge;
                            $Title = $TaxRate->Title;
                            $TotalTax = Invoice::calculateTotalTaxByTaxRateObj($TaxRate, $SubTotal);
                            $TaxGrandTotal += $TotalTax;
                            AccountBalanceTaxRateLog::create(array(
                                "ParentLogID"=>$AccountBalanceSubscriptionLogID,
                                "Type"=>$ProductType,
                                "TaxRateID" => $TaxRateID,
                                "TaxAmount" => $TotalTax,
                                "Title" => $Title,
                                "created_at"=>date('Y-m-d H:i:s'),
                                "updated_at"=>date('Y-m-d H:i:s')
                            ));
                        }
                    }
                }
            }
        }
        return $TaxGrandTotal;
    }

    public static function CreateOneOffBalanceTax($AccountBalanceSubscriptionLogID,$AccountOneOffChargeID,$TotalCharge){
        $TaxGrandTotal = 0;
        $AccountOneOffCharge = AccountOneOffCharge::find($AccountOneOffChargeID);
        if ($AccountOneOffCharge->TaxRateID || $AccountOneOffCharge->TaxRateID2) {
            AccountBalanceTaxRateLog::where(array('ParentLogID'=>$AccountBalanceSubscriptionLogID,'Type'=>Product::ONEOFFCHARGE))->delete();

            if ($AccountOneOffCharge->TaxRateID) {
                $TaxRate = TaxRate::where("TaxRateID", $AccountOneOffCharge->TaxRateID)->first();
                $TotalTax = Invoice::calculateTotalTaxByTaxRateObj($TaxRate, $TotalCharge);
                $TaxGrandTotal += $TotalTax;
                $Title = $TaxRate->Title;
                AccountBalanceTaxRateLog::create(array(
                    "ParentLogID"=>$AccountBalanceSubscriptionLogID,
                    "Type"=>Product::ONEOFFCHARGE,
                    "TaxRateID" => $AccountOneOffCharge->TaxRateID,
                    "TaxAmount" => $TotalTax,
                    "Title" => $Title,
                    "created_at"=>date('Y-m-d H:i:s'),
                    "updated_at"=>date('Y-m-d H:i:s')
                ));
            }
            if ($AccountOneOffCharge->TaxRateID2) {
                $TaxRate = TaxRate::where("TaxRateID", $AccountOneOffCharge->TaxRateID2)->first();
                $TotalTax = Invoice::calculateTotalTaxByTaxRateObj($TaxRate, $TotalCharge);
                $TaxGrandTotal += $TotalTax;
                $Title = $TaxRate->Title;
                AccountBalanceTaxRateLog::create(array(
                    "ParentLogID"=>$AccountBalanceSubscriptionLogID,
                    "Type"=>Product::ONEOFFCHARGE,
                    "TaxRateID" => $AccountOneOffCharge->TaxRateID2,
                    "TaxAmount" => $TotalTax,
                    "Title" => $Title,
                    "created_at"=>date('Y-m-d H:i:s'),
                    "updated_at"=>date('Y-m-d H:i:s')
                ));
            }

        }
        return $TaxGrandTotal;
    }

}
