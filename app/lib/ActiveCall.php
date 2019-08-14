<?php
namespace App\Lib;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class ActiveCall extends \Eloquent {

    protected $connection = 'neon_routingengine';
    protected $fillable = [];
    protected $guarded = array('ActiveCallID');
    protected $table = 'tblActiveCall';
    public  $primaryKey = "ActiveCallID"; //Used in BasedController


    public static function getUniqueAccountID(){
        return ActiveCall::groupby('AccountID')->lists('AccountID');

    }

    public static function getUUIDByAccountID($AccountID){
        return ActiveCall::where(['AccountID'=>$AccountID])->groupby('UUID')->lists('UUID');

    }

    public static function updateActiveCallCost($ActiveCallID){
        $ActiveCall = ActiveCall::where(['ActiveCallID'=>$ActiveCallID])->first();
        $AccountID = $ActiveCall->AccountID;
        $CompanyID = $ActiveCall->CompanyID;
        $CompanyCurrency = DB::connection('neon_routingengine')->table('tblBaseCurrency')->first();
        $CompanyCurrency = $CompanyCurrency->CurrencyId;
        $AccountCurrency = DB::connection('neon_routingengine')->table('tblAccount')->where(['AccountID'=>$AccountID])->pluck('CurrencyId');

        $Cost = $ActiveCall->Cost;
        $CallType = $ActiveCall->CallType;
        $OldDuration = $ActiveCall->Duration;
        $CallRecordingDuration = $ActiveCall->CallRecordingDuration;
        $PackageCostPerMinute= $ActiveCall->PackageCostPerMinute;
        $RecordingCostPerMinute= $ActiveCall->RecordingCostPerMinute;
        $TaxRateIDs = $ActiveCall->TaxRateIDs;
        /**
         * update duration = current time - connect time
         */

        $Date = date('Y-m-d H:i:s');

        $Duration = strtotime($Date) - strtotime($ActiveCall->ConnectTime);
        //log::info('Current Date '.$Date.' Old Duration '.$OldDuration.' New Duration '.$Duration);
        if($Duration > $OldDuration) {

            $BilledDuration = $Duration;
            $RateTablePKGRateID = $ActiveCall->RateTablePKGRateID;
            if(!empty($RateTablePKGRateID)){
                $RateTablePKGRate = DB::connection('neon_routingengine')->table('tblRateTableDetails')->where(['ActiveCallID'=>$ActiveCallID,'PKG_RateTablePKGRateID'=>$RateTablePKGRateID])->first();
                if(!empty($RateTablePKGRate)){

                    $PackageCostPerMinute = isset($RateTablePKGRate->PKG_PackageCostPerMinute)?$RateTablePKGRate->PKG_PackageCostPerMinute:0;
                    if(!empty($PackageCostPerMinute)){
                        if(!empty($RateTablePKGRate->PKG_PackageCostPerMinuteCurrency)) {
                            $PackageCostPerMinuteCurrency = $RateTablePKGRate->PKG_PackageCostPerMinuteCurrency;
                            $PackageCostPerMinute = Currency::convertCurrencyForRouting($CompanyCurrency, $AccountCurrency, $PackageCostPerMinuteCurrency, $PackageCostPerMinute);
                        }
                        $PackageCostPerMinute = ($BilledDuration * ($PackageCostPerMinute/60));
                    }

                    if ($ActiveCall->CallRecording == 1) {
                        $CallRecordingDuration = strtotime($Date) - strtotime($ActiveCall->CallRecordingStartTime);

                        $RecordingCostPerMinute = isset($RateTablePKGRate->PKG_RecordingCostPerMinute)?$RateTablePKGRate->PKG_RecordingCostPerMinute:0;
                        if(!empty($RecordingCostPerMinute)){
                            if(!empty($RateTablePKGRate->PKG_RecordingCostPerMinuteCurrency)) {
                                $RecordingCostPerMinuteCurrency = $RateTablePKGRate->PKG_RecordingCostPerMinuteCurrency;
                                $RecordingCostPerMinute = Currency::convertCurrencyForRouting($CompanyCurrency, $AccountCurrency, $RecordingCostPerMinuteCurrency, $RecordingCostPerMinute);
                            }
                            $RecordingCostPerMinute = ($CallRecordingDuration * ($RecordingCostPerMinute/60));
                        }
                    }
                }
            }
            /** calculation outbound cost */

            if ($CallType == 'Outbound') {
                $RateTableRateID = $ActiveCall->RateTableRateID;
                if ($RateTableRateID > 0) {
                    $RateTableRate = DB::connection('neon_routingengine')->table('tblRateTableDetails')->where(['ActiveCallID'=>$ActiveCallID,'Cust_RateTableRateID'=>$RateTableRateID])->first();
                    $ConnectionFee = empty($RateTableRate->Cust_ConnectionFee) ? 0 : $RateTableRate->Cust_ConnectionFee;
                    if(!empty($ConnectionFee) && !empty($RateTableRate->Cust_ConnectionFeeCurrency)){
                        $ConnectionFee = Currency::convertCurrencyForRouting($CompanyCurrency, $AccountCurrency, $RateTableRate->Cust_ConnectionFeeCurrency, $ConnectionFee);
                    }
                    $Interval1 = $RateTableRate->Cust_Interval1;
                    $IntervalN = $RateTableRate->Cust_IntervalN;
                    $Rate = $RateTableRate->Cust_Rate;
                    $RateN = $RateTableRate->Cust_RateN;
                    $MinimumDuration = empty($RateTableRate->Cust_MinimumDuration) ? 0 : $RateTableRate->Cust_MinimumDuration;
                    if($MinimumDuration > $Duration){
                        $Duration = $MinimumDuration;
                    }
                    if(!empty($RateTableRate->Cust_RateCurrency)){
                        if(!empty($Rate)){
                            $Rate = Currency::convertCurrencyForRouting($CompanyCurrency, $AccountCurrency, $RateTableRate->Cust_RateCurrency,$Rate);
                        }
                        if(!empty($RateN)){
                            $RateN = Currency::convertCurrencyForRouting($CompanyCurrency, $AccountCurrency, $RateTableRate->Cust_RateCurrency,$RateN);
                        }
                    }
                    /** cost update */
                    if ($Duration >= $Interval1) {
                        $Cost = ($Rate / 60.0) * $Interval1 + ceil(($Duration - $Interval1) / $IntervalN) * ($RateN / 60.0) * $IntervalN + $ConnectionFee;
                    } elseif ($Duration > 0) {
                        $Cost = $Rate + $ConnectionFee;
                    } else {
                        $Cost = 0;
                    }
                    /** Billed Duration */
                    if ($Duration >= $Interval1) {
                        $BilledDuration = $Interval1 + ceil(($Duration - $Interval1) / $IntervalN) * $IntervalN;
                    } elseif ($Duration > 0) {
                        $BilledDuration = $Interval1;
                    } else {
                        $BilledDuration = 0;
                    }

                }
                $Cost = $Cost + $PackageCostPerMinute + $RecordingCostPerMinute;

                /** minimum cost calculation
                 * if cost is less than minimum cost , cost update as minimum cost
                 */
                /* removed this functionality
                if(!empty($ActiveCall->RateTableID)) {
                    $MinimumCallCharge = RateTable::where(['RateTableID' => $ActiveCall->RateTableID])->pluck('MinimumCallCharge');
                    if (!empty($MinimumCallCharge)) {
                        $RateCurrency = RateTable::where(['RateTableID' => $ActiveCall->RateTableID])->pluck('CurrencyID');
                        if (!empty($RateCurrency)) {
                            $MinimumCallCharge = Currency::convertCurrencyForRouting($CompanyCurrency, $AccountCurrency, $RateCurrency, $MinimumCallCharge);
                        }
                        if ($MinimumCallCharge > $Cost) {
                            $Cost = $MinimumCallCharge;
                        }
                    }
                }*/

                if($Cost>0){
                    $Cost = ActiveCall::getCostWithTaxes($Cost,$TaxRateIDs);
                }

                /** update cost and duration */

                $UpdateData = array();
                $UpdateData['Duration'] = $Duration;
                $UpdateData['billed_duration'] = $BilledDuration;
                $UpdateData['CallRecordingDuration'] = $CallRecordingDuration;
                $UpdateData['Cost'] = $Cost;
                $UpdateData['PackageCostPerMinute'] = $PackageCostPerMinute;
                $UpdateData['RecordingCostPerMinute'] = $RecordingCostPerMinute;
                $UpdateData['updated_at'] = date('Y-m-d H:i:s');
                $ActiveCall->update($UpdateData);
                //log::info('New Cost '.$Cost);

            }
            if ($CallType == 'Inbound') {
                $CostPerCall = 0;
                $CostPerMinute = 0;
                $SurchargePerCall = 0;
                $SurchargePerMinute = 0;
                $OutpaymentPerCall = 0;
                $OutpaymentPerMinute = 0;
                $Surcharges = 0;
                $Chargeback = 0;
                $TotalOutPayment = 0;
                $CollectionCostAmount = 0;
                $CollectionCostPercentage = 0;
                $RateTableDIDRateID = $ActiveCall->RateTableDIDRateID;

                if ($RateTableDIDRateID > 0) {
                    $RateTableDIDRate = DB::connection('neon_routingengine')->table('tblRateTableDetails')->where(['ActiveCallID'=>$ActiveCallID,'DID_RateTableDIDRateID'=>$RateTableDIDRateID])->first();

                    if ($Duration > 0) {
                        /**
                         * PerCall means - add direct cost
                         * PerMinute means - duration * cost
                         */

                        $CostPerCall = isset($RateTableDIDRate->DID_CostPerCall)?$RateTableDIDRate->DID_CostPerCall:0;
                        if(!empty($CostPerCall)){
                            if(!empty($RateTableDIDRate->DID_CostPerCallCurrency)){
                                $CostPerCallCurrency = $RateTableDIDRate->DID_CostPerCallCurrency;
                                $CostPerCall = Currency::convertCurrencyForRouting($CompanyCurrency, $AccountCurrency, $CostPerCallCurrency, $CostPerCall);
                            }
                        }
                        $CostPerMinute = isset($RateTableDIDRate->DID_CostPerMinute)?$RateTableDIDRate->DID_CostPerMinute:0;
                        if(!empty($CostPerMinute)){
                            if(!empty($RateTableDIDRate->DID_CostPerMinuteCurrency)) {
                                $CostPerMinuteCurrency = $RateTableDIDRate->DID_CostPerMinuteCurrency;
                                $CostPerMinute = Currency::convertCurrencyForRouting($CompanyCurrency, $AccountCurrency, $CostPerMinuteCurrency, $CostPerMinute);
                            }
                            $CostPerMinute = ($Duration * ($CostPerMinute/60));
                        }
                        $SurchargePerCall = isset($RateTableDIDRate->DID_SurchargePerCall)?$RateTableDIDRate->DID_SurchargePerCall:0;
                        if(!empty($SurchargePerCall)){
                            if(!empty($RateTableDIDRate->DID_SurchargePerCallCurrency)) {
                                $SurchargePerCallCurrency = $RateTableDIDRate->DID_SurchargePerCallCurrency;
                                $SurchargePerCall = Currency::convertCurrencyForRouting($CompanyCurrency, $AccountCurrency, $SurchargePerCallCurrency, $SurchargePerCall);
                            }
                        }
                        $SurchargePerMinute = isset($RateTableDIDRate->DID_SurchargePerMinute)?$RateTableDIDRate->DID_SurchargePerMinute:0;
                        if(!empty($SurchargePerMinute)){
                            if(!empty($RateTableDIDRate->DID_SurchargePerMinuteCurrency)) {
                                $SurchargePerMinuteCurrency = $RateTableDIDRate->DID_SurchargePerMinuteCurrency;
                                $SurchargePerMinute = Currency::convertCurrencyForRouting($CompanyCurrency, $AccountCurrency, $SurchargePerMinuteCurrency, $SurchargePerMinute);
                            }
                            $SurchargePerMinute = ($Duration * ($SurchargePerMinute/60));
                        }

                        /** Out Payment charge ***/
                        $OutpaymentPerCall = isset($RateTableDIDRate->DID_OutpaymentPerCall)?$RateTableDIDRate->DID_OutpaymentPerCall:0;
                        if(!empty($OutpaymentPerCall)){
                            if(!empty($RateTableDIDRate->DID_OutpaymentPerCallCurrency)) {
                                $OutpaymentPerCallCurrency = $RateTableDIDRate->DID_OutpaymentPerCallCurrency;
                                $OutpaymentPerCall = Currency::convertCurrencyForRouting($CompanyCurrency, $AccountCurrency, $OutpaymentPerCallCurrency, $OutpaymentPerCall);
                            }
                        }
                        $OutpaymentPerMinute = isset($RateTableDIDRate->DID_OutpaymentPerMinute)?$RateTableDIDRate->DID_OutpaymentPerMinute:0;
                        if(!empty($OutpaymentPerMinute)){
                            if(!empty($RateTableDIDRate->DID_OutpaymentPerMinuteCurrency)) {
                                $OutpaymentPerMinuteCurrency = $RateTableDIDRate->DID_OutpaymentPerMinuteCurrency;
                                $OutpaymentPerMinute = Currency::convertCurrencyForRouting($CompanyCurrency, $AccountCurrency, $OutpaymentPerMinuteCurrency, $OutpaymentPerMinute);
                            }
                            $OutpaymentPerMinute = ($Duration * ($OutpaymentPerMinute/60));
                        }

                        if(empty($SurchargePerCall) && empty($SurchargePerMinute)){
                            $Surcharges = isset($RateTableDIDRate->DID_Surcharges) ? $RateTableDIDRate->DID_Surcharges : 0;
                            if (!empty($Surcharges)) {
                                if (!empty($RateTableDIDRate->DID_SurchargesCurrency)) {
                                    $SurchargesCurrency = $RateTableDIDRate->DID_SurchargesCurrency;
                                    $Surcharges = Currency::convertCurrencyForRouting($CompanyCurrency, $AccountCurrency, $SurchargesCurrency, $Surcharges);
                                }
                                $Surcharges = ($Duration * ($Surcharges / 60));
                            }
                        }

                        $CollectionCostAmount = isset($RateTableDIDRate->DID_CollectionCostAmount)?$RateTableDIDRate->DID_CollectionCostAmount:0;
                        if(!empty($CollectionCostAmount)){
                            if(!empty($RateTableDIDRate->DID_CollectionCostAmountCurrency)) {
                                $CollectionCostAmountCurrency = $RateTableDIDRate->DID_CollectionCostAmountCurrency;
                                $CollectionCostAmount = Currency::convertCurrencyForRouting($CompanyCurrency, $AccountCurrency, $CollectionCostAmountCurrency, $CollectionCostAmount);
                            }
                        }

                        $Cost = $PackageCostPerMinute + $RecordingCostPerMinute + $CostPerCall + $CostPerMinute + $SurchargePerCall + $SurchargePerMinute + $Surcharges +$CollectionCostAmount - $OutpaymentPerCall - $OutpaymentPerMinute;

                        $CollectionCostPercentage = isset($RateTableDIDRate->DID_CollectionCostPercentage)?$RateTableDIDRate->DID_CollectionCostPercentage:0;
                        $TotalOutPayment = $OutpaymentPerCall + $OutpaymentPerMinute;
                        if(!empty($CollectionCostPercentage) && $TotalOutPayment > 0){
                            /*
                            if(!empty($TaxRateIDs)){
                                $TotalOutPayment = ActiveCall::getCostWithTaxes($TotalOutPayment,$TaxRateIDs);
                            }*/
                            $TotalOutPaymentTax = $TotalOutPayment * (1.21);
                            $TotalOutPayment = $TotalOutPayment + $TotalOutPaymentTax;
                            $CollectionCostPercentage = $TotalOutPayment * ($CollectionCostPercentage/100);
                            $Cost = $Cost + $CollectionCostPercentage;
                        }
                        $TotalOutPayment = $OutpaymentPerCall + $OutpaymentPerMinute;
                        $Chargeback = isset($RateTableDIDRate->DID_Chargeback)?$RateTableDIDRate->DID_Chargeback:0;
                        if(!empty($Chargeback) && $TotalOutPayment > 0){
                            $Chargeback = $TotalOutPayment * ($Chargeback/100);
                            $Cost = $Cost + $Chargeback;
                        }
                    }
                }

                if($Cost>0){
                    $Cost = ActiveCall::getCostWithTaxes($Cost,$TaxRateIDs);
                }

                $UpdateData = array();
                $UpdateData['Duration'] = $Duration;
                $UpdateData['billed_duration'] = $Duration;
                $UpdateData['CallRecordingDuration'] = $CallRecordingDuration;
                $UpdateData['Cost'] = $Cost;
                $UpdateData['CostPerCall'] = $CostPerCall;
                $UpdateData['CostPerMinute'] = $CostPerMinute;
                $UpdateData['SurchargePerCall'] = $SurchargePerCall;
                $UpdateData['SurchargePerMinute'] = $SurchargePerMinute;
                $UpdateData['OutpaymentPerCall'] = $OutpaymentPerCall;
                $UpdateData['OutpaymentPerMinute'] = $OutpaymentPerMinute;
                $UpdateData['Surcharges'] = $Surcharges;
                $UpdateData['Chargeback'] = $Chargeback;
                $UpdateData['CollectionCostAmount'] = $CollectionCostAmount;
                $UpdateData['CollectionCostPercentage'] = $CollectionCostPercentage;
                $UpdateData['PackageCostPerMinute'] = $PackageCostPerMinute;
                $UpdateData['RecordingCostPerMinute'] = $RecordingCostPerMinute;

                $UpdateData['updated_at'] = date('Y-m-d H:i:s');
                $ActiveCall->update($UpdateData);
                //log::info('New Cost '.$Cost);
            }
        }
    }

    public static function getCostWithTaxes($Cost,$TaxRateIDs){
        $TaxGrandTotal = 0;
        $TaxRateIDs = explode(",",$TaxRateIDs);
        if(!empty($TaxRateIDs) && count($TaxRateIDs)>0) {
            foreach($TaxRateIDs as $TaxRateID) {
                $TaxRateID = intval($TaxRateID);
                if($TaxRateID>0){
                    $TaxAmount=TaxRate::calculateProductTaxAmount($TaxRateID,$Cost);
                    $TaxGrandTotal += $TaxAmount;
                }
            }
        }
        $Total = $Cost + $TaxGrandTotal;

        return $Total;
    }

}