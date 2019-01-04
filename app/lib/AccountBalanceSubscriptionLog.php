<?php

namespace App\Lib;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class AccountBalanceSubscriptionLog extends Model
{
    //
    protected $guarded = array("AccountBalanceSubscriptionLogID");
    protected $table = 'tblAccountBalanceSubscriptionLog';
    protected $primaryKey = "AccountBalanceSubscriptionLogID";
    public $timestamps = false; // no created_at and updated_at



    public static function CreateSubscriptionLog($CompanyID,$AccountID,$ServiceID,$BillingType,$NextCycleDate){
        $Today=date('Y-m-d');
        $AccountBilling = AccountBilling::where(['AccountID'=>$AccountID,'ServiceID'=>0])->first();
        $AccountService = AccountService::where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID])->first();
        while ($NextCycleDate <= $Today) {
            $ServiceBilling = ServiceBilling::where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID])->first();
            AccountBalanceSubscriptionLog::CreateServiceDetailLog($ServiceBilling->ServiceBillingID);
            $NextCycleDate = $ServiceBilling->NextCycleDate;

            $ServiceBillingData = array();
            $ServiceBillingData['LastCycleDate']=$NextCycleDate;
            $NewDate = next_billing_date($ServiceBilling->BillingCycleType,$ServiceBilling->BillingCycleValue,strtotime($NextCycleDate));
            $ServiceBillingData['NextCycleDate']=$NewDate;
            $ServiceBillingData['updated_at']=date('Y-m-d H:i:s');
            $ServiceBilling->update($ServiceBillingData);
            $NextCycleDate=$NewDate;
        }
        log::info('loop end '.$NextCycleDate);


    }

    public static function CreateServiceDetailLog($ServiceBillingID){
        $ServiceBilling = ServiceBilling::where(['ServiceBillingID'=>$ServiceBillingID])->first();
        $AccountID=$ServiceBilling->AccountID;
        $ServiceID=$ServiceBilling->ServiceID;
        $BillingType=$ServiceBilling->BillingType;
        $StartDate = $ServiceBilling->LastCycleDate;
        $StartDate = date('Y-m-d 00:00:00',strtotime($StartDate));
        $EndDate = date('Y-m-d 23:59:59', strtotime('-1 day', strtotime($ServiceBilling->NextCycleDate)));
        log::info('StartDate '.$StartDate.' End Date '.$EndDate);


        $AccountSubscriptions = AccountSubscription::where(['AccountID' => $AccountID, 'ServiceID' => $ServiceID])->get();
        if (!empty($AccountSubscriptions)) {
            foreach ($AccountSubscriptions as $AccountSubscription) {
                $AccountSubscriptionID = $AccountSubscription->AccountSubscriptionID;
                AccountBalanceSubscriptionLog::CreateSubscriptionBalanceLog($BillingType, $AccountSubscriptionID, $StartDate, $EndDate);
            }
        }

        $AccountOneOffCharges = AccountOneOffCharge::getAccountOneoffChargesByDate($AccountID, $ServiceID, $StartDate, $EndDate);
        if (count($AccountOneOffCharges)) {
            foreach ($AccountOneOffCharges as $AccountOneOffCharge) {
                $AccountOneOffChargeID = $AccountOneOffCharge->AccountOneOffChargeID;
                AccountBalanceSubscriptionLog::CreateOneOffChargeBalanceLog($BillingType, $AccountOneOffChargeID, $StartDate, $EndDate);
            }
        }

    }

    public static function CreateSubscriptionBalanceLog($BillingType,$AccountSubscriptionID,$StartDate,$EndDate){

        $AccountSubscription = AccountSubscription::where(['AccountSubscriptionID'=>$AccountSubscriptionID])->first();
        if($AccountSubscription->EndDate == '0000-00-00'){
            $AccountSubscription->EndDate  = date("Y-m-d",strtotime('+1 years'));
        }
        $AccountID = $AccountSubscription->AccountID;
        $ServiceID = $AccountSubscription->ServiceID;
        $CompanyID = Account::where(['AccountID'=>$AccountID])->pluck('CompanyId');
        $decimal_places = Helper::get_round_decimal_places($CompanyID,$AccountID,$ServiceID);
        $AccountBalanceLogID = AccountBalanceLog::where(['AccountID'=>$AccountID])->pluck('AccountBalanceLogID');
        $IssueDate=date('Y-m-d');

        $IsAdvance = BillingSubscription::isAdvanceSubscription($AccountSubscription->SubscriptionID);
        $FirstTimeBilling = 0;
        /**
         * New logic of first time billing or not
        */

        $Count = AccountBalanceSubscriptionLog::where(['AccountBalanceLogID'=>$AccountBalanceLogID,'ServiceID'=>$ServiceID,'ProductType'=>Product::SUBSCRIPTION,'ParentID'=>$AccountSubscriptionID])->count();
        if($Count==0){
            $FirstTimeBilling = 1;
        }

        //if($BillingType==AccountBalance::BILLINGTYPE_PREPAID){
            $BillingCycleType=AccountService::where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID])->pluck('SubscriptionBillingCycleType');
            $QuarterSubscription =  0;
            if($BillingCycleType == 'quarterly'){
                $QuarterSubscription = 1;
            }elseif($BillingCycleType == 'yearly'){
                $QuarterSubscription = 2;
            }

            /** Advance logic start */

            if(!empty($IsAdvance)){

                if($FirstTimeBilling==1) {
                    /**
                     * Subscription start date logic
                     */
                    $billed = 0;
                    $NewStartDate = '';
                    $NewEndDate = '';
                    if ($StartDate >= $AccountSubscription->StartDate && $StartDate <= $AccountSubscription->EndDate && $EndDate >= $AccountSubscription->StartDate && $EndDate <= $AccountSubscription->EndDate) {
                        $NewStartDate = $StartDate;
                        $NewEndDate = $EndDate;
                    } else if ($AccountSubscription->StartDate >= $StartDate && $AccountSubscription->StartDate <= $EndDate) {
                        $SubscriptionStartDateReg = $AccountSubscription->StartDate;
                        $SubscriptionEndDateReg = $EndDate;
                        if ($AccountSubscription->EndDate < $EndDate) {
                            $SubscriptionEndDateReg = $AccountSubscription->EndDate;// '15-3-2015' to '20-3-2015'
                        }
                        $NewStartDate = $SubscriptionStartDateReg;
                        $NewEndDate = $SubscriptionEndDateReg;
                    } else if ($AccountSubscription->EndDate >= $StartDate && $AccountSubscription->EndDate <= $EndDate) {
                        $SubscriptionEndDateReg = $AccountSubscription->EndDate;
                        $NewStartDate = $StartDate;
                        $NewEndDate = $SubscriptionEndDateReg;
                    } else {
                        $billed = 1;
                    }
                    if ($billed == 0) {
                        $NewEndDate = date('Y-m-d 23:59:59', strtotime($NewEndDate));
                        AccountBalanceSubscriptionLog::InsertSubscriptionBalanceDeatilLog($AccountSubscriptionID, $AccountBalanceLogID, $NewStartDate, $NewEndDate, $FirstTimeBilling, $QuarterSubscription, $decimal_places);
                        $FirstTimeBilling=0;
                    }
                }

                $NextCycleDate = ServiceBilling::where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID])->pluck('NextCycleDate');
                $BillingCycleType = ServiceBilling::where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID])->pluck('BillingCycleType');
                $BillingCycleValue = ServiceBilling::where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID])->pluck('BillingCycleValue');

                $StartDate=date('Y-m-d 00:00:00',strtotime($NextCycleDate));
                $EndDate=next_billing_date($BillingCycleType,$BillingCycleValue,strtotime($NextCycleDate));
                $EndDate = date('Y-m-d 23:59:59', strtotime('-1 day', strtotime($EndDate)));

                log::info('Advance StatDate '.$StartDate.' EndDate '.$EndDate);

            }else{
                log::info('Regular StatDate '.$StartDate.' EndDate '.$EndDate);
            }

            /** Advance logic end */

            /**
             * Regular logic start
            */
            $newbilled=0;
            $NewStartDate = '';
            $NewEndDate = '';
            $AlreadyBilled=0;

            if ($IsAdvance == 0 && $StartDate >= $AccountSubscription->StartDate && $StartDate <= $AccountSubscription->EndDate && $EndDate >= $AccountSubscription->StartDate && $EndDate <= $AccountSubscription->EndDate) {
                $NewStartDate = $StartDate;
                $NewEndDate = $EndDate;
            } else if ($IsAdvance == 0 && $AccountSubscription->StartDate >= $StartDate && $AccountSubscription->StartDate <= $EndDate) {
                $StartDate = $AccountSubscription->StartDate;
                if ($AccountSubscription->EndDate < $EndDate) {
                    $EndDate = $AccountSubscription->EndDate;
                }
                $NewStartDate = $StartDate;
                $NewEndDate = $EndDate;
            } else if ($IsAdvance == 0 && $AccountSubscription->EndDate >= $StartDate && $AccountSubscription->EndDate <= $EndDate) {
                $EndDate = $AccountSubscription->EndDate;
                $NewStartDate = $StartDate;
                $NewEndDate = $EndDate;
            } else if ($IsAdvance == 1 && $AlreadyBilled==0 && $AccountSubscription->EndDate >= $StartDate && $AccountSubscription->EndDate <= $EndDate) {
                $EndDate = $AccountSubscription->EndDate;
                $NewStartDate = $StartDate;
                $NewEndDate = $EndDate;
            } else if ($IsAdvance == 1 && $AlreadyBilled==0 && $StartDate >= $AccountSubscription->StartDate && $StartDate <= $AccountSubscription->EndDate && $EndDate >= $AccountSubscription->StartDate && $EndDate <= $AccountSubscription->EndDate) {
                $NewStartDate = $StartDate;
                $NewEndDate = $EndDate;
            }else{
                $newbilled=1;
            }

            if($newbilled==0){
                AccountBalanceSubscriptionLog::InsertSubscriptionBalanceDeatilLog($AccountSubscriptionID,$AccountBalanceLogID, $NewStartDate,$NewEndDate, $FirstTimeBilling,$QuarterSubscription,$decimal_places);
            }
            /**
             * Regular end start
             */

        //}


    }

    public static function InsertSubscriptionBalanceDeatilLog($AccountSubscriptionID,$AccountBalanceLogID, $SubscriptionStartDate,$SubscriptionEndDate, $FirstTimeBilling,$QuarterSubscription,$decimal_places){

        $SubscriptionCharge = AccountSubscription::getSubscriptionAmount($AccountSubscriptionID, $SubscriptionStartDate,$SubscriptionEndDate, $FirstTimeBilling,$QuarterSubscription);

        $AccountSubscription = AccountSubscription::where(['AccountSubscriptionID'=>$AccountSubscriptionID])->first();
        $ServiceID = $AccountSubscription->ServiceID;
        $AccountID = $AccountSubscription->AccountID;
        $IssueDate = date('Y-m-d');

        $qty = $AccountSubscription->Qty;
        $TotalSubscriptionCharge = ( $SubscriptionCharge * $qty );
        $Subscription = BillingSubscription::find($AccountSubscription->SubscriptionID);

        $DiscountLineAmount = 0;
        if(!empty($AccountSubscription->DiscountAmount) && !empty($AccountSubscription->DiscountType)){
            if($AccountSubscription->DiscountType=='Percentage'){
                $DiscountLineAmount =  (($TotalSubscriptionCharge * $AccountSubscription->DiscountAmount) / 100);
                $TotalSubscriptionCharge = $TotalSubscriptionCharge - $DiscountLineAmount;
            }
            if($AccountSubscription->DiscountType=='Flat'){
                $DiscountLineAmount = $AccountSubscription->DiscountAmount;
                $TotalSubscriptionCharge = $TotalSubscriptionCharge - $DiscountLineAmount;
            }
        }

        $Price = number_format($SubscriptionCharge, $decimal_places, '.', ''); // per subscription price
        $LineAmount = number_format($TotalSubscriptionCharge, $decimal_places, '.', ''); // total subscription price

        $ProductDescription = $AccountSubscription->InvoiceDescription;
        if ($FirstTimeBilling && $Subscription->ActivationFee >0) {
            $ActivationProductDescription=$ProductDescription.' Activation Fee';
            $TotalActivationFeeCharge = ( $Subscription->ActivationFee * $qty );
            /**
             * Entry no discount
             */

            $SubscriptionLogData=array();
            $SubscriptionLogData['AccountBalanceLogID']=$AccountBalanceLogID;
            $SubscriptionLogData['ServiceID']=$ServiceID;
            $SubscriptionLogData['IssueDate']=$IssueDate;
            $SubscriptionLogData['ProductType']=Product::SUBSCRIPTION;
            $SubscriptionLogData['ParentID']=$AccountSubscriptionID;
            $SubscriptionLogData['Description']=$ActivationProductDescription;
            $SubscriptionLogData['Price']=$Subscription->ActivationFee;
            $SubscriptionLogData['Qty']=$qty;
            $SubscriptionLogData['StartDate']=$SubscriptionStartDate;
            $SubscriptionLogData['EndDate']=$SubscriptionEndDate;
            $SubscriptionLogData['LineAmount']=$TotalActivationFeeCharge;
            $SubscriptionLogData['TotalTax']=0;
            $SubscriptionLogData['TotalAmount']=$TotalActivationFeeCharge;
            /*
            $SubscriptionLogData['DiscountAmount']=0;
            $SubscriptionLogData['DiscountType']='';
            $SubscriptionLogData['DiscountLineAmount']=0; */
            $SubscriptionLogData['created_at']=date('Y-m-d H:i:s');
            $SubscriptionLogData['updated_at']=date('Y-m-d H:i:s');
            $AccountBalanceSubscriptionLog = AccountBalanceSubscriptionLog::create($SubscriptionLogData);

            if($AccountSubscription->ExemptTax==0) {
                $AccountBalanceSubscriptionLogID = $AccountBalanceSubscriptionLog->AccountBalanceSubscriptionLogID;
                $TotalTax = AccountBalanceTaxRateLog::CreateSubscriptiontBalanceTax($AccountID, $AccountBalanceSubscriptionLogID, $TotalActivationFeeCharge);
                $GrandTotal = $TotalActivationFeeCharge + $TotalTax;
                $SubLogData = array();
                $SubLogData['TotalTax'] = $TotalTax;
                $SubLogData['TotalAmount'] = $GrandTotal;
                $SubLogData['updated_at'] = date('Y-m-d H:i:s');
                AccountBalanceSubscriptionLog::where(['AccountBalanceSubscriptionLogID' => $AccountBalanceSubscriptionLogID])->update($SubLogData);
            }

        }
        /**
         * Entry no discount
         */

        $SubscriptionLogData=array();
        $SubscriptionLogData['AccountBalanceLogID']=$AccountBalanceLogID;
        $SubscriptionLogData['ServiceID']=$ServiceID;
        $SubscriptionLogData['IssueDate']=$IssueDate;
        $SubscriptionLogData['ProductType']=Product::SUBSCRIPTION;
        $SubscriptionLogData['ParentID']=$AccountSubscriptionID;
        $SubscriptionLogData['Description']=$ProductDescription;
        $SubscriptionLogData['Price']=$Price;
        $SubscriptionLogData['Qty']=$qty;
        $SubscriptionLogData['StartDate']=$SubscriptionStartDate;
        $SubscriptionLogData['EndDate']=$SubscriptionEndDate;
        $SubscriptionLogData['LineAmount']=$LineAmount;
        $SubscriptionLogData['TotalTax']=0;
        $SubscriptionLogData['TotalAmount']=$LineAmount;

        if(!empty($AccountSubscription->DiscountAmount) && !empty($AccountSubscription->DiscountType)){
            $SubscriptionLogData['DiscountAmount'] = $AccountSubscription->DiscountAmount;
            $SubscriptionLogData['DiscountType'] = $AccountSubscription->DiscountType;
        }
        $SubscriptionLogData["DiscountLineAmount"] = $DiscountLineAmount;
        $SubscriptionLogData['created_at']=date('Y-m-d H:i:s');
        $SubscriptionLogData['updated_at']=date('Y-m-d H:i:s');
        $NewAccountBalanceSubscriptionLog = AccountBalanceSubscriptionLog::create($SubscriptionLogData);

        if($AccountSubscription->ExemptTax==0) {
            $AccountBalanceSubscriptionLogID = $NewAccountBalanceSubscriptionLog->AccountBalanceSubscriptionLogID;
            $TotalTax = AccountBalanceTaxRateLog::CreateSubscriptiontBalanceTax($AccountID, $AccountBalanceSubscriptionLogID, $LineAmount);
            $GrandTotal = $LineAmount + $TotalTax;
            $SubLogData = array();
            $SubLogData['TotalTax'] = $TotalTax;
            $SubLogData['TotalAmount'] = $GrandTotal;
            $SubLogData['updated_at'] = date('Y-m-d H:i:s');
            AccountBalanceSubscriptionLog::where(['AccountBalanceSubscriptionLogID' => $AccountBalanceSubscriptionLogID])->update($SubLogData);
        }
    }

    public static function CreateOneOffChargeBalanceLog($BillingType,$AccountOneOffChargeID,$StartDate,$EndDate){
        $AccountOneOffCharge = AccountOneOffCharge::find($AccountOneOffChargeID);
        $AccountID = $AccountOneOffCharge->AccountID;
        $ServiceID = $AccountOneOffCharge->ServiceID;
        $CompanyID = Account::where(['AccountID'=>$AccountID])->pluck('CompanyId');
        $decimal_places = Helper::get_round_decimal_places($CompanyID,$AccountID,$ServiceID);

        $AccountBalanceLogID = AccountBalanceLog::where(['AccountID'=>$AccountID])->pluck('AccountBalanceLogID');
        $IssueDate=date('Y-m-d');

        $ProductDescription = $AccountOneOffCharge->Description;
        $singlePrice = $AccountOneOffCharge->Price;
        $LineTotal = ($AccountOneOffCharge->Price) * $AccountOneOffCharge->Qty;

        $DiscountLineAmount = 0;
        if(!empty($AccountOneOffCharge->DiscountAmount) && !empty($AccountOneOffCharge->DiscountType)){
            if($AccountOneOffCharge->DiscountType=='Percentage'){
                $DiscountLineAmount =  (($LineTotal * $AccountOneOffCharge->DiscountAmount) / 100);
                $LineTotal = $LineTotal - $DiscountLineAmount;
            }
            if($AccountOneOffCharge->DiscountType=='Flat'){
                $DiscountLineAmount = $AccountOneOffCharge->DiscountAmount;
                $LineTotal = $LineTotal - $DiscountLineAmount;
            }
        }
        $singlePrice = number_format($singlePrice, $decimal_places, '.', '');
        $LineTotal = number_format($LineTotal, $decimal_places, '.', '');

        $OneOffChargeLogData=array();
        $OneOffChargeLogData['AccountBalanceLogID']=$AccountBalanceLogID;
        $OneOffChargeLogData['ServiceID']=$ServiceID;
        $OneOffChargeLogData['IssueDate']=$IssueDate;
        $OneOffChargeLogData['ProductType']=Product::ONEOFFCHARGE;
        $OneOffChargeLogData['ParentID']=$AccountOneOffChargeID;
        $OneOffChargeLogData['Description']=$ProductDescription;
        $OneOffChargeLogData['Price']=$singlePrice;
        $OneOffChargeLogData['Qty']=$AccountOneOffCharge->Qty;
        $OneOffChargeLogData['StartDate']=$AccountOneOffCharge->Date;
        $OneOffChargeLogData['EndDate']=$AccountOneOffCharge->Date;
        $OneOffChargeLogData['LineAmount']=$LineTotal;
        $OneOffChargeLogData['TotalTax']=0;
        $OneOffChargeLogData['TotalAmount']=$LineTotal;
        if(!empty($AccountOneOffCharge->DiscountAmount) && !empty($AccountOneOffCharge->DiscountType)){
            $OneOffChargeLogData['DiscountAmount'] = $AccountOneOffCharge->DiscountAmount;
            $OneOffChargeLogData['DiscountType'] = $AccountOneOffCharge->DiscountType;
        }
        $OneOffChargeLogData["DiscountLineAmount"] = $DiscountLineAmount;
        $OneOffChargeLogData['created_at']=date('Y-m-d H:i:s');
        $OneOffChargeLogData['updated_at']=date('Y-m-d H:i:s');
        $AccountBalanceOneOffLog = AccountBalanceSubscriptionLog::create($OneOffChargeLogData);
        if ($AccountOneOffCharge->TaxRateID || $AccountOneOffCharge->TaxRateID2) {

            $AccountBalanceSubscriptionLogID = $AccountBalanceOneOffLog->AccountBalanceSubscriptionLogID;
            $TotalTax = AccountBalanceTaxRateLog::CreateOneOffBalanceTax($AccountBalanceSubscriptionLogID, $AccountOneOffChargeID, $LineTotal);
            $GrandTotal = $LineTotal + $TotalTax;
            $SubLogData = array();
            $SubLogData['TotalTax'] = $TotalTax;
            $SubLogData['TotalAmount'] = $GrandTotal;
            $SubLogData['updated_at'] = date('Y-m-d H:i:s');
            AccountBalanceSubscriptionLog::where(['AccountBalanceSubscriptionLogID' => $AccountBalanceSubscriptionLogID])->update($SubLogData);

        }

    }
}
