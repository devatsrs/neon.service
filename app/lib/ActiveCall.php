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


    public static function getUniqueAccountID($CompanyID){
        return ActiveCall::where('CompanyID',$CompanyID)->groupby('AccountID')->lists('AccountID');

    }

    public static function getUUIDByAccountID($CompanyID,$AccountID){
        return ActiveCall::where(['CompanyID'=>$CompanyID,'AccountID'=>$AccountID])->groupby('UUID')->lists('UUID');

    }

    public static function updateActiveCallCost($ActiveCallID){
        $ActiveCall = ActiveCall::find($ActiveCallID);
        $AccountID = $ActiveCall->AccountID;
        $CompanyID = $ActiveCall->CompanyID;
        $CompanyCurrency = Company::where(['CompanyID'=>$CompanyID])->pluck('CurrencyId');
        $AccountCurrency = Account::where(["AccountID"=>$AccountID])->pluck('CurrencyId');
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
        log::info('Current Date '.$Date.' Old Duration '.$OldDuration.' New Duration '.$Duration);
        if($Duration > $OldDuration) {

            $BilledDuration = $Duration;
            if ($ActiveCall->CallRecording == 1) {
                $CallRecordingDuration = strtotime($Date) - strtotime($ActiveCall->CallRecordingStartTime);
                $RateTablePKGRateID = $ActiveCall->RateTablePKGRateID;
                if(!empty($RateTablePKGRateID)){
                    $RateTablePKGRate = DB::table('tblRateTablePKGRate')->where(['RateTablePKGRateID'=>$RateTablePKGRateID])->first();
                    if(!empty($RateTablePKGRate)){
                        $PackageCostPerMinute = isset($RateTablePKGRate->PackageCostPerMinute)?$RateTablePKGRate->PackageCostPerMinute:0;
                        if(!empty($PackageCostPerMinute)){
                            if(!empty($RateTablePKGRate->PackageCostPerMinuteCurrency)) {
                                $PackageCostPerMinuteCurrency = $RateTablePKGRate->PackageCostPerMinuteCurrency;
                                $PackageCostPerMinute = Currency::convertCurrency($CompanyCurrency, $AccountCurrency, $PackageCostPerMinuteCurrency, $PackageCostPerMinute);
                            }
                            $PackageCostPerMinute = ($CallRecordingDuration * ($PackageCostPerMinute/60));
                        }

                        $RecordingCostPerMinute = isset($RateTablePKGRate->RecordingCostPerMinute)?$RateTablePKGRate->RecordingCostPerMinute:0;
                        if(!empty($RecordingCostPerMinute)){
                            if(!empty($RateTablePKGRate->RecordingCostPerMinuteCurrency)) {
                                $RecordingCostPerMinuteCurrency = $RateTablePKGRate->RecordingCostPerMinuteCurrency;
                                $RecordingCostPerMinute = Currency::convertCurrency($CompanyCurrency, $AccountCurrency, $RecordingCostPerMinuteCurrency, $RecordingCostPerMinute);
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
                    $RateTableRate = DB::table('tblRateTableRate')->where(['RateTableRateID'=>$RateTableRateID])->first();
                    $ConnectionFee = empty($RateTableRate->ConnectionFee) ? 0 : $RateTableRate->ConnectionFee;
                    if(!empty($ConnectionFee) && !empty($RateTableRate->ConnectionFeeCurrency)){
                        $ConnectionFee = Currency::convertCurrency($CompanyCurrency, $AccountCurrency, $RateTableRate->ConnectionFeeCurrency, $ConnectionFee);
                    }
                    $Interval1 = $RateTableRate->Interval1;
                    $IntervalN = $RateTableRate->IntervalN;
                    $Rate = $RateTableRate->Rate;
                    $RateN = $RateTableRate->RateN;
                    if(!empty($RateTableRate->RateCurrency)){
                        if(!empty($Rate)){
                            $Rate = Currency::convertCurrency($CompanyCurrency, $AccountCurrency, $RateTableRate->RateCurrency,$Rate);
                        }
                        if(!empty($RateN)){
                            $RateN = Currency::convertCurrency($CompanyCurrency, $AccountCurrency, $RateTableRate->RateCurrency,$RateN);
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
                if(!empty($ActiveCall->RateTableID)) {
                    $MinimumCallCharge = RateTable::where(['RateTableID' => $ActiveCall->RateTableID])->pluck('MinimumCallCharge');
                    if (!empty($MinimumCallCharge)) {
                        $RateCurrency = RateTable::where(['RateTableID' => $ActiveCall->RateTableID])->pluck('CurrencyID');
                        if (!empty($RateCurrency)) {
                            $MinimumCallCharge = Currency::convertCurrency($CompanyCurrency, $AccountCurrency, $RateCurrency, $MinimumCallCharge);
                        }
                        if ($MinimumCallCharge > $Cost) {
                            $Cost = $MinimumCallCharge;
                        }
                    }
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
                log::info('New Cost '.$Cost);

            }
            if ($CallType == 'Inbound') {
                $CostPerCall = 0;
                $CostPerMinute = 0;
                $SurchargePerCall = 0;
                $SurchargePerMinute = 0;
                $OutpaymentPerCall = 0;
                $OutpaymentPerMinute = 0;
                $Surcharges = 0;
                $CollectionCostAmount = 0;
                $CollectionCostPercentage = 0;
                $RateTableDIDRateID = $ActiveCall->RateTableDIDRateID;

                if ($RateTableDIDRateID > 0) {
                    $RateTableDIDRate = RateTableDIDRate::find($RateTableDIDRateID);

                    if ($Duration > 0) {
                        /**
                         * PerCall means - add direct cost
                         * PerMinute means - duration * cost
                         */

                        $CostPerCall = isset($RateTableDIDRate->CostPerCall)?$RateTableDIDRate->CostPerCall:0;
                        if(!empty($CostPerCall)){
                            if(!empty($RateTableDIDRate->CostPerCallCurrency)){
                                $CostPerCallCurrency = $RateTableDIDRate->CostPerCallCurrency;
                                $CostPerCall = Currency::convertCurrency($CompanyCurrency, $AccountCurrency, $CostPerCallCurrency, $CostPerCall);
                            }
                        }
                        $CostPerMinute = isset($RateTableDIDRate->CostPerMinute)?$RateTableDIDRate->CostPerMinute:0;
                        if(!empty($CostPerMinute)){
                            if(!empty($RateTableDIDRate->CostPerMinuteCurrency)) {
                                $CostPerMinuteCurrency = $RateTableDIDRate->CostPerMinuteCurrency;
                                $CostPerMinute = Currency::convertCurrency($CompanyCurrency, $AccountCurrency, $CostPerMinuteCurrency, $CostPerMinute);
                            }
                            $CostPerMinute = ($Duration * ($CostPerMinute/60));
                        }
                        $SurchargePerCall = isset($RateTableDIDRate->SurchargePerCall)?$RateTableDIDRate->SurchargePerCall:0;
                        if(!empty($SurchargePerCall)){
                            if(!empty($RateTableDIDRate->SurchargePerCallCurrency)) {
                                $SurchargePerCallCurrency = $RateTableDIDRate->SurchargePerCallCurrency;
                                $SurchargePerCall = Currency::convertCurrency($CompanyCurrency, $AccountCurrency, $SurchargePerCallCurrency, $SurchargePerCall);
                            }
                        }
                        $SurchargePerMinute = isset($RateTableDIDRate->SurchargePerMinute)?$RateTableDIDRate->SurchargePerMinute:0;
                        if(!empty($SurchargePerMinute)){
                            if(!empty($RateTableDIDRate->SurchargePerMinuteCurrency)) {
                                $SurchargePerMinuteCurrency = $RateTableDIDRate->SurchargePerMinuteCurrency;
                                $SurchargePerMinute = Currency::convertCurrency($CompanyCurrency, $AccountCurrency, $SurchargePerMinuteCurrency, $SurchargePerMinute);
                            }
                            $SurchargePerMinute = ($Duration * ($SurchargePerMinute/60));
                        }

                        /** Out Payment charge ***/
                        $OutpaymentPerCall = isset($RateTableDIDRate->OutpaymentPerCall)?$RateTableDIDRate->OutpaymentPerCall:0;
                        if(!empty($OutpaymentPerCall)){
                            if(!empty($RateTableDIDRate->OutpaymentPerCallCurrency)) {
                                $OutpaymentPerCallCurrency = $RateTableDIDRate->OutpaymentPerCallCurrency;
                                $OutpaymentPerCall = Currency::convertCurrency($CompanyCurrency, $AccountCurrency, $OutpaymentPerCallCurrency, $OutpaymentPerCall);
                            }
                            $OutpaymentPerCall = ($Duration * ($OutpaymentPerCall/60));
                        }
                        $OutpaymentPerMinute = isset($RateTableDIDRate->OutpaymentPerMinute)?$RateTableDIDRate->OutpaymentPerMinute:0;
                        if(!empty($OutpaymentPerMinute)){
                            if(!empty($RateTableDIDRate->OutpaymentPerMinuteCurrency)) {
                                $OutpaymentPerMinuteCurrency = $RateTableDIDRate->OutpaymentPerMinuteCurrency;
                                $OutpaymentPerMinute = Currency::convertCurrency($CompanyCurrency, $AccountCurrency, $OutpaymentPerMinuteCurrency, $OutpaymentPerMinute);
                            }
                            $OutpaymentPerMinute = ($Duration * ($OutpaymentPerMinute/60));
                        }

                        $Surcharges = isset($RateTableDIDRate->Surcharges)?$RateTableDIDRate->Surcharges:0;
                        if(!empty($Surcharges)){
                            if(!empty($RateTableDIDRate->SurchargesCurrency)) {
                                $SurchargesCurrency = $RateTableDIDRate->SurchargesCurrency;
                                $Surcharges = Currency::convertCurrency($CompanyCurrency, $AccountCurrency, $SurchargesCurrency, $Surcharges);
                            }
                            $Surcharges = ($Duration * ($Surcharges/60));
                        }

                        $CollectionCostAmount = isset($RateTableDIDRate->CollectionCostAmount)?$RateTableDIDRate->CollectionCostAmount:0;
                        if(!empty($CollectionCostAmount)){
                            if(!empty($RateTableDIDRate->CollectionCostAmountCurrency)) {
                                $CollectionCostAmountCurrency = $RateTableDIDRate->CollectionCostAmountCurrency;
                                $CollectionCostAmount = Currency::convertCurrency($CompanyCurrency, $AccountCurrency, $CollectionCostAmountCurrency, $CollectionCostAmount);
                            }
                        }

                        $Cost = $PackageCostPerMinute + $RecordingCostPerMinute + $CostPerCall + $CostPerMinute + $SurchargePerCall + $SurchargePerMinute + $Surcharges +$CollectionCostAmount - $OutpaymentPerCall - $OutpaymentPerMinute;

                        $CollectionCostPercentage = isset($RateTableDIDRate->CollectionCostPercentage)?$RateTableDIDRate->CollectionCostPercentage:0;
                        if(!empty($CollectionCostPercentage)){
                            if(!empty($TaxRateIDs)){
                                $Cost = ActiveCall::getCostWithTaxes($Cost,$TaxRateIDs);
                            }
                            $CollectionCostPercentage = $Cost * ($CollectionCostPercentage/100);
                            $Cost = $Cost + $CollectionCostPercentage;
                        }
                    }
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
                $UpdateData['CollectionCostAmount'] = $CollectionCostAmount;
                $UpdateData['CollectionCostPercentage'] = $CollectionCostPercentage;
                $UpdateData['PackageCostPerMinute'] = $PackageCostPerMinute;
                $UpdateData['RecordingCostPerMinute'] = $RecordingCostPerMinute;

                $UpdateData['updated_at'] = date('Y-m-d H:i:s');
                $ActiveCall->update($UpdateData);
                log::info('New Cost '.$Cost);
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