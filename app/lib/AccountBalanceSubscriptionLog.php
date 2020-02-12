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



    public static function CreateSubscriptionLog($CompanyID,$AccountID,$ProcessID,$ServiceID,$AccountServiceID,$CLIRateTableID,$AccountServicePackageID,$BillingType,$NextCycleDate,$AccountSubscriptionID){
        $Today=date('Y-m-d');
        while ($NextCycleDate <= $Today) {
            $ServiceBilling = ServiceBilling::where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID,'AccountServiceID'=>$AccountServiceID,'AccountSubscriptionID'=>$AccountSubscriptionID,'CLIRateTableID'=>$CLIRateTableID,'AccountServicePackageID'=>$AccountServicePackageID])->first();
            AccountBalanceSubscriptionLog::CreateServiceDetailLog($ServiceBilling->ServiceBillingID,$ProcessID);
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

    public static function CreateServiceDetailLog($ServiceBillingID,$ProcessID){
        $ServiceBilling = ServiceBilling::where(['ServiceBillingID'=>$ServiceBillingID])->first();
        $AccountID=$ServiceBilling->AccountID;
        $ServiceID=$ServiceBilling->ServiceID;
        $AccountServiceID=$ServiceBilling->AccountServiceID;
        $AccountSubscriptionID=$ServiceBilling->AccountSubscriptionID;
        $CLIRateTableID=$ServiceBilling->CLIRateTableID;
        $AccountServicePackageID=$ServiceBilling->AccountServicePackageID;
        $BillingType = $ServiceBilling->BillingType;
        $StartDate = $ServiceBilling->LastCycleDate;
        $StartDate = date('Y-m-d 00:00:00', strtotime($StartDate));
        $EndDate = date('Y-m-d 23:59:59', strtotime('-1 day', strtotime($ServiceBilling->NextCycleDate)));
        log::info('StartDate ' . $StartDate . ' End Date ' . $EndDate);

        if($AccountSubscriptionID >0 ) {

            /** change if need to work as service */
            //$AccountSubscriptions = AccountSubscription::where(['AccountID' => $AccountID, 'ServiceID' => $ServiceID, 'AccountServiceID' => $AccountServiceID])->get();
            $AccountSubscriptions = AccountSubscription::where(['AccountSubscriptionID' => $AccountSubscriptionID])->get();
            if (!empty($AccountSubscriptions)) {
                foreach ($AccountSubscriptions as $AccountSubscription) {
                    $AccountSubscriptionID = $AccountSubscription->AccountSubscriptionID;
                    AccountBalanceSubscriptionLog::CreateSubscriptionBalanceLog($ProcessID,$BillingType, $AccountSubscriptionID, $StartDate, $EndDate);
                }
            }
        }else{
            AccountBalanceSubscriptionLog::CreateServiceNumberBalanceLog($ProcessID,$BillingType, $AccountServiceID,$CLIRateTableID,$AccountServicePackageID, $StartDate, $EndDate);
        }

        /** need to change if need to work as service */

        /*
        $AccountOneOffCharges = AccountOneOffCharge::getAccountOneoffChargesByDate($AccountID, $ServiceID, $AccountServiceID, $StartDate, $EndDate);
        if (count($AccountOneOffCharges)) {
            foreach ($AccountOneOffCharges as $AccountOneOffCharge) {
                $AccountOneOffChargeID = $AccountOneOffCharge->AccountOneOffChargeID;
                AccountBalanceSubscriptionLog::CreateOneOffChargeBalanceLog($BillingType, $AccountOneOffChargeID, $StartDate, $EndDate);
            }
        } */

    }

    public static function CreateSubscriptionBalanceLog($ProcessID,$BillingType,$AccountSubscriptionID,$StartDate,$EndDate){

        $AccountSubscription = AccountSubscription::where(['AccountSubscriptionID'=>$AccountSubscriptionID])->first();
        if($AccountSubscription->EndDate == '0000-00-00'){
            $AccountSubscription->EndDate  = date("Y-m-d",strtotime('+1 years'));
        }
        $AccountID = $AccountSubscription->AccountID;
        $ServiceID = $AccountSubscription->ServiceID;
        $AccountServiceID = $AccountSubscription->AccountServiceID;
        $CLIRateTableID = $AccountSubscription->CLIRateTableID;
        $AccountServicePackageID = $AccountSubscription->AccountServicePackageID;
        $CompanyID = Account::where(['AccountID'=>$AccountID])->pluck('CompanyId');
        $decimal_places = Helper::get_round_decimal_places($CompanyID,$AccountID,$ServiceID,$AccountServiceID);
        $AccountBalanceLogID = AccountBalanceLog::where(['AccountID'=>$AccountID])->pluck('AccountBalanceLogID');
        $IssueDate=date('Y-m-d');

        $IsAdvance = BillingSubscription::isAdvanceSubscription($AccountSubscription->SubscriptionID);
        $FirstTimeBilling = 0;
        /**
         * New logic of first time billing or not
        */

        $Count = AccountBalanceSubscriptionLog::where(['AccountBalanceLogID'=>$AccountBalanceLogID,'ServiceID'=>$ServiceID,'AccountServiceID'=>$AccountServiceID,'ProductType'=>Product::SUBSCRIPTION,'ParentID'=>$AccountSubscriptionID])->count();
        if($Count==0){
            $FirstTimeBilling = 1;
        }

        //if($BillingType==AccountBalance::BILLINGTYPE_PREPAID){
            //$BillingCycleType=AccountService::where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID,'AccountServiceID'=>$AccountServiceID])->pluck('SubscriptionBillingCycleType');
            $BillingCycleType = ServiceBilling::where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID,'AccountServiceID'=>$AccountServiceID,'AccountSubscriptionID'=>$AccountSubscriptionID,'CLIRateTableID'=>$CLIRateTableID,'AccountServicePackageID'=>$AccountServicePackageID])->pluck('BillingCycleType');
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
                        AccountBalanceSubscriptionLog::InsertSubscriptionBalanceDetailLog($ProcessID,$AccountSubscriptionID, $AccountBalanceLogID, $NewStartDate, $NewEndDate, $FirstTimeBilling, $QuarterSubscription, $decimal_places);
                        $FirstTimeBilling=0;
                    }
                }

                $NextCycleDate = ServiceBilling::where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID,'AccountServiceID'=>$AccountServiceID,'AccountSubscriptionID'=>$AccountSubscriptionID])->pluck('NextCycleDate');
                $BillingCycleType = ServiceBilling::where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID,'AccountServiceID'=>$AccountServiceID,'AccountSubscriptionID'=>$AccountSubscriptionID])->pluck('BillingCycleType');
                $BillingCycleValue = ServiceBilling::where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID,'AccountServiceID'=>$AccountServiceID,'AccountSubscriptionID'=>$AccountSubscriptionID])->pluck('BillingCycleValue');

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
                AccountBalanceSubscriptionLog::InsertSubscriptionBalanceDetailLog($ProcessID,$AccountSubscriptionID,$AccountBalanceLogID, $NewStartDate,$NewEndDate, $FirstTimeBilling,$QuarterSubscription,$decimal_places);
            }
            /**
             * Regular end start
             */

        //}


    }

    public static function InsertSubscriptionBalanceDetailLog($ProcessID,$AccountSubscriptionID,$AccountBalanceLogID, $SubscriptionStartDate,$SubscriptionEndDate, $FirstTimeBilling,$QuarterSubscription,$decimal_places){

        $SubscriptionCharge = AccountSubscription::getSubscriptionAmount($AccountSubscriptionID, $SubscriptionStartDate,$SubscriptionEndDate, $FirstTimeBilling,$QuarterSubscription);
        // convert currency

        $AccountSubscription = AccountSubscription::where(['AccountSubscriptionID'=>$AccountSubscriptionID])->first();
        $ServiceID = $AccountSubscription->ServiceID;
        $AccountServiceID = $AccountSubscription->AccountServiceID;
        $AccountID = $AccountSubscription->AccountID;
        $IssueDate = date('Y-m-d');

        $AccountCurrency = Account::where(['AccountID'=>$AccountID])->pluck('CurrencyId');
        $CompanyID = Account::where(['AccountID'=>$AccountID])->pluck('CompanyId');
        $CompanyCurrency = Company::where(['CompanyID'=>$CompanyID])->pluck('CurrencyId');

        if(!empty($SubscriptionCharge) && !empty($AccountSubscription->RecurringCurrencyID)){
            $SubscriptionCharge = Currency::convertCurrency($CompanyCurrency, $AccountCurrency, $AccountSubscription->RecurringCurrencyID, $SubscriptionCharge);
        }

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

            if(!empty($Subscription->ActivationFee) && !empty($AccountSubscription->OneOffCurrencyID)){
                $Subscription->ActivationFee = Currency::convertCurrency($CompanyCurrency, $AccountCurrency, $AccountSubscription->OneOffCurrencyID, $Subscription->ActivationFee);
            }

            $ActivationProductDescription=$ProductDescription.' Activation Fee';
            $TotalActivationFeeCharge = ( $Subscription->ActivationFee * $qty );
            /**
             * Entry no discount
             */

            $SubscriptionLogData=array();
            $SubscriptionLogData['AccountBalanceLogID']=$AccountBalanceLogID;
            $SubscriptionLogData['ServiceID']=$ServiceID;
            $SubscriptionLogData['AccountServiceID']=$AccountServiceID;
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
            $SubscriptionLogData['TotalAmount']=$TotalActivationFeeCharge;
            $SubscriptionLogData['CustomerSubscriptionLogID']=0;
            $SubscriptionLogData['CLIRateTableID']=0;
            $SubscriptionLogData['ProcessID']=$ProcessID;
            /*
            $SubscriptionLogData['DiscountAmount']=0;
            $SubscriptionLogData['DiscountType']='';
            $SubscriptionLogData['DiscountLineAmount']=0; */
            $SubscriptionLogData['created_at']=date('Y-m-d H:i:s');
            $SubscriptionLogData['updated_at']=date('Y-m-d H:i:s');
            $AccountBalanceSubscriptionLog = AccountBalanceSubscriptionLog::create($SubscriptionLogData);

            if($AccountSubscription->ExemptTax==0) {
                $AccountBalanceSubscriptionLogID = $AccountBalanceSubscriptionLog->AccountBalanceSubscriptionLogID;
                $ProductType = Product::SUBSCRIPTION;
                $TotalTax = AccountBalanceTaxRateLog::CreateSubscriptiontBalanceTax($AccountID, $AccountBalanceSubscriptionLogID, $TotalActivationFeeCharge,$ProductType);
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
        $SubscriptionLogData['AccountServiceID']=$AccountServiceID;
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
        $SubscriptionLogData['CustomerSubscriptionLogID']=0;
        $SubscriptionLogData['CLIRateTableID']=0;
        $SubscriptionLogData['ProcessID']=$ProcessID;

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
            $ProductType = Product::SUBSCRIPTION;
            $TotalTax = AccountBalanceTaxRateLog::CreateSubscriptiontBalanceTax($AccountID, $AccountBalanceSubscriptionLogID, $LineAmount,$ProductType);
            $GrandTotal = $LineAmount + $TotalTax;
            $SubLogData = array();
            $SubLogData['TotalTax'] = $TotalTax;
            $SubLogData['TotalAmount'] = $GrandTotal;
            $SubLogData['updated_at'] = date('Y-m-d H:i:s');
            AccountBalanceSubscriptionLog::where(['AccountBalanceSubscriptionLogID' => $AccountBalanceSubscriptionLogID])->update($SubLogData);
        }
    }

    public static function CreateOneOffChargeBalanceLog($ProcessID,$BillingType,$AccountOneOffChargeID,$StartDate,$EndDate){
        $AccountOneOffCharge = AccountOneOffCharge::find($AccountOneOffChargeID);
        $AccountID = $AccountOneOffCharge->AccountID;
        $ServiceID = $AccountOneOffCharge->ServiceID;
        $AccountServiceID = $AccountOneOffCharge->AccountServiceID;
        $CompanyID = Account::where(['AccountID'=>$AccountID])->pluck('CompanyId');
        $decimal_places = Helper::get_round_decimal_places($CompanyID,$AccountID,$ServiceID,$AccountServiceID);

        $AccountBalanceLogID = AccountBalanceLog::where(['AccountID'=>$AccountID])->pluck('AccountBalanceLogID');
        $IssueDate=date('Y-m-d');

        $ProductDescription = $AccountOneOffCharge->Description;
        $singlePrice = $AccountOneOffCharge->Price;

        $AccountCurrency = Account::where(['AccountID'=>$AccountID])->pluck('CurrencyId');
        $CompanyID = Account::where(['AccountID'=>$AccountID])->pluck('CompanyId');
        $CompanyCurrency = Company::where(['CompanyID'=>$CompanyID])->pluck('CurrencyId');

        if(!empty($singlePrice) && !empty($AccountOneOffCharge->CurrencyID)){
            $singlePrice = Currency::convertCurrency($CompanyCurrency, $AccountCurrency, $AccountOneOffCharge->CurrencyID, $singlePrice);
        }

        $LineTotal = ($singlePrice) * $AccountOneOffCharge->Qty;

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
        $OneOffChargeLogData['AccountServiceID']=$AccountServiceID;
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
        $OneOffChargeLogData['CustomerSubscriptionLogID']=0;
        $OneOffChargeLogData['CLIRateTableID']=0;
        $OneOffChargeLogData['ProcessID']=$ProcessID;
        if(!empty($AccountOneOffCharge->DiscountAmount) && !empty($AccountOneOffCharge->DiscountType)){
            $OneOffChargeLogData['DiscountAmount'] = $AccountOneOffCharge->DiscountAmount;
            $OneOffChargeLogData['DiscountType'] = $AccountOneOffCharge->DiscountType;
        }
        $OneOffChargeLogData["DiscountLineAmount"] = $DiscountLineAmount;
        $OneOffChargeLogData['created_at']=date('Y-m-d H:i:s');
        $OneOffChargeLogData['updated_at']=date('Y-m-d H:i:s');
        $AccountBalanceOneOffLog = AccountBalanceSubscriptionLog::create($OneOffChargeLogData);

        $AccountBalanceSubscriptionLogID = $AccountBalanceOneOffLog->AccountBalanceSubscriptionLogID;
        $ProductType = Product::ONEOFFCHARGE;
        $TotalTax = AccountBalanceTaxRateLog::CreateSubscriptiontBalanceTax($AccountID, $AccountBalanceSubscriptionLogID, $LineTotal,$ProductType);
        $GrandTotal = $LineTotal + $TotalTax;
        $SubLogData = array();
        $SubLogData['TotalTax'] = $TotalTax;
        $SubLogData['TotalAmount'] = $GrandTotal;
        $SubLogData['updated_at'] = date('Y-m-d H:i:s');
        AccountBalanceSubscriptionLog::where(['AccountBalanceSubscriptionLogID' => $AccountBalanceSubscriptionLogID])->update($SubLogData);
        /*
        if ($AccountOneOffCharge->TaxRateID || $AccountOneOffCharge->TaxRateID2) {

            $AccountBalanceSubscriptionLogID = $AccountBalanceOneOffLog->AccountBalanceSubscriptionLogID;
            $TotalTax = AccountBalanceTaxRateLog::CreateOneOffBalanceTax($AccountBalanceSubscriptionLogID, $AccountOneOffChargeID, $LineTotal);
            $GrandTotal = $LineTotal + $TotalTax;
            $SubLogData = array();
            $SubLogData['TotalTax'] = $TotalTax;
            $SubLogData['TotalAmount'] = $GrandTotal;
            $SubLogData['updated_at'] = date('Y-m-d H:i:s');
            AccountBalanceSubscriptionLog::where(['AccountBalanceSubscriptionLogID' => $AccountBalanceSubscriptionLogID])->update($SubLogData);

        }*/

    }

    public static function CreateServiceNumberBalanceLog($ProcessID,$BillingType, $AccountServiceID,$CLIRateTableID,$AccountServicePackageID, $StartDate, $EndDate){
        $Today=date('Y-m-d');
        $NewAccountServicePackageID = $AccountServicePackageID;
        //$query = "CALL prcGetAccountServiceNumberData(?)";
        $AccountServiceNumberDatas = DB::select("CALL prcGetAccountServiceNumberData('.$AccountServiceID.','.$CLIRateTableID.')");

        log::info('count data '.count($AccountServiceNumberDatas));

        if(count($AccountServiceNumberDatas) > 0){

            foreach($AccountServiceNumberDatas as $AccountServiceNumberData){
                $CLIRateTableID = $AccountServiceNumberData->CLIRateTableID;
                $AccountServicePackageID = $AccountServiceNumberData->AccountServicePackageID;

                $CliRateTables = CLIRateTable::where(['CLIRateTableID'=>$CLIRateTableID])->where('NumberStartDate','<=',$Today)->first();
                if(!empty($CliRateTables)){
                    //log::info(print_r($AccountServiceNumberData,true));
                    //Monthly Cost
                    if(empty($NewAccountServicePackageID)) {
                        if (!empty($AccountServiceNumberData->MonthlyCost)) {
                            //log::info('MonthlyCost '.$AccountServiceNumberData->MonthlyCost);
                            AccountBalanceSubscriptionLog::calculateMonthlyCost($ProcessID, $AccountServiceNumberData->CLI, $AccountServiceNumberData->MonthlyCost, 'Number', $CLIRateTableID, $StartDate, $EndDate, $CLIRateTableID,$NewAccountServicePackageID);
                        }
                        //OneOff Cost
                        if (!empty($AccountServiceNumberData->OneOffCost)) {
                            //log::info('OneOffCost '.$AccountServiceNumberData->OneOffCost);
                            AccountBalanceSubscriptionLog::calculateOneOffCost($ProcessID, $AccountServiceNumberData->CLI, $AccountServiceNumberData->OneOffCost, 'Number', $CLIRateTableID, Product::NUMBER_ONEOFFCHARGE, $CLIRateTableID);
                        }
                        //Registration Cost
                        if (!empty($AccountServiceNumberData->RegistrationCostPerNumber)) {
                            //log::info('RegistrationCostPerNumber '.$AccountServiceNumberData->RegistrationCostPerNumber);
                            AccountBalanceSubscriptionLog::calculateOneOffCost($ProcessID, $AccountServiceNumberData->CLI, $AccountServiceNumberData->RegistrationCostPerNumber, 'Number', $CLIRateTableID, Product::NUMBER_REGISTRATIONCOST, $CLIRateTableID);
                        }
                    }
                    if($NewAccountServicePackageID > 0) {
                        // need package condition
                        $PackageStartDate = DB::table('tblAccountServicePackage')->where(['AccountServicePackageID' => $AccountServicePackageID])->pluck('PackageStartDate');
                        if ($PackageStartDate <= $Today) {
                            if (!empty($AccountServiceNumberData->PKGMonthlyCost)) {
                                //log::info('PKGMonthlyCost '.$AccountServiceNumberData->PKGMonthlyCost);
                                AccountBalanceSubscriptionLog::calculateMonthlyCost($ProcessID, $AccountServiceNumberData->CLI, $AccountServiceNumberData->PKGMonthlyCost, 'Package', $AccountServicePackageID, $StartDate, $EndDate, $CLIRateTableID,$NewAccountServicePackageID);
                            }
                            //OneOff Cost
                            if (!empty($AccountServiceNumberData->PKGOneOffCost)) {
                                //log::info('PKGOneOffCost '.$AccountServiceNumberData->PKGOneOffCost);
                                AccountBalanceSubscriptionLog::calculateOneOffCost($ProcessID, $AccountServiceNumberData->CLI, $AccountServiceNumberData->PKGOneOffCost, 'Package', $AccountServicePackageID, Product::PACKAGE_ONEOFFCHARGE, $CLIRateTableID);
                            }
                        }
                    }
                }
            }
        }
    }

    public static function calculateMonthlyCost($ProcessID,$CLI,$MonthlyCost,$Type,$ParentID,$StartDate,$EndDate,$CLIRateTableID,$NewAccountServicePackageID){
        $BillingType = 1;
        $AccountSubscriptionID = 0;

        $ProductName = 'Monthly Cost';

        if($Type=='Number'){
            $CliRateTables = CLIRateTable::where(['CLIRateTableID'=>$ParentID])->first();

			if($CliRateTables->NumberEndDate == '0000-00-00'){
                $CliRateTables->NumberEndDate  = date("Y-m-d",strtotime('+1 years'));
            }
			$NumberStartDate = $CliRateTables->NumberStartDate;
			$NumberEndDate = $CliRateTables->NumberEndDate;
			$AccountID = $CliRateTables->AccountID;
			$ServiceID = $CliRateTables->ServiceID;
			$AccountServiceID = $CliRateTables->AccountServiceID;
			$ProductType = Product::NUMBER_MONTHLY_SUBSCRIPTION;
			$Description = $CLI.' '.$ProductName;

		}else{

            $AccountServicePackage = DB::table('tblAccountServicePackage')->where(['AccountServicePackageID'=>$ParentID])->first();
            $PackageName = DB::table('tblPackage')->where(['PackageId'=>$AccountServicePackage->PackageId])->pluck('Name');
            $NumberStartDate = $AccountServicePackage->PackageStartDate;
            $NumberEndDate = $AccountServicePackage->PackageEndDate;
            $AccountID = $AccountServicePackage->AccountID;
            $ServiceID = $AccountServicePackage->ServiceID;
            $AccountServiceID = $AccountServicePackage->AccountServiceID;
            $ProductType = Product::PACKAGE_MONTHLY_SUBSCRIPTION;
            $Description = $PackageName.' '.$ProductName.'('.$CLI.')';
            if(!empty($AccountServicePackage->ContractID)){
                $Description = $PackageName.'-'.$AccountServicePackage->ContractID.' '.$ProductName.'('.$CLI.')';
            }
        }

        $NumberStartDate = date('Y-m-d 00:00:00',strtotime($NumberStartDate));
        $NumberEndDate   = date('Y-m-d 23:59:59',strtotime($NumberEndDate));

        //$CLIRateTableID = $CliRateTables->CLIRateTableID


        $CompanyID = Account::where(['AccountID'=>$AccountID])->pluck('CompanyId');
        $decimal_places = Helper::get_round_decimal_places($CompanyID,$AccountID,$ServiceID,$AccountServiceID);
        $AccountBalanceLogID = AccountBalanceLog::where(['AccountID'=>$AccountID])->pluck('AccountBalanceLogID');
        $IssueDate=date('Y-m-d');

        $data = array();
        $data['MonthlyCost'] = $MonthlyCost;
        $data['ServiceID'] = $ServiceID;
        $data['AccountServiceID'] = $AccountServiceID;
        $data['AccountID'] = $AccountID;
        $data['ProductType'] = $ProductType;
        $data['ParentID'] =  $ParentID;
        $data['Description'] = $Description;
        $data['CLIRateTableID'] = $CLIRateTableID;

        $IsAdvance = 1;
        $FirstTimeBilling = 0;
        /**
         * New logic of first time billing or not
         */

        $Count = AccountBalanceSubscriptionLog::where(['AccountBalanceLogID'=>$AccountBalanceLogID,'ServiceID'=>$ServiceID,'AccountServiceID'=>$AccountServiceID,'ProductType'=>$ProductType,'ParentID'=>$ParentID])->count();
        if($Count==0){
            $FirstTimeBilling = 1;
        }

        //if($BillingType==AccountBalance::BILLINGTYPE_PREPAID){
        //$BillingCycleType=AccountService::where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID,'AccountServiceID'=>$AccountServiceID])->pluck('SubscriptionBillingCycleType');
        $BillingCycleType = 'monthly';
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
                if ($StartDate >= $NumberStartDate && $StartDate <= $NumberEndDate && $EndDate >= $NumberStartDate && $EndDate <= $NumberEndDate) {
                    $NewStartDate = $StartDate;
                    $NewEndDate = $EndDate;
                } else if ($NumberStartDate >= $StartDate && $NumberStartDate <= $EndDate) {
                    $SubscriptionStartDateReg = $NumberStartDate;
                    $SubscriptionEndDateReg = $EndDate;
                    if ($NumberEndDate < $EndDate) {
                        $SubscriptionEndDateReg = $NumberEndDate;// '15-3-2015' to '20-3-2015'
                    }
                    $NewStartDate = $SubscriptionStartDateReg;
                    $NewEndDate = $SubscriptionEndDateReg;
                } else if ($NumberEndDate >= $StartDate && $NumberEndDate <= $EndDate) {
                    $SubscriptionEndDateReg = $NumberEndDate;
                    $NewStartDate = $StartDate;
                    $NewEndDate = $SubscriptionEndDateReg;
                } else {
                    $billed = 1;
                }
                if ($billed == 0) {
                    $NewEndDate = date('Y-m-d 23:59:59', strtotime($NewEndDate));

                    AccountBalanceSubscriptionLog::InsertMonthlyBalanceDetailLog($ProcessID,$data, $AccountBalanceLogID, $NewStartDate, $NewEndDate, $FirstTimeBilling, $QuarterSubscription, $decimal_places);
                    $FirstTimeBilling=0;
                }
            }

            $NextCycleDate = ServiceBilling::where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID,'AccountServiceID'=>$AccountServiceID,'AccountSubscriptionID'=>$AccountSubscriptionID,'CLIRateTableID'=>$CLIRateTableID,'AccountServicePackageID'=>$NewAccountServicePackageID])->pluck('NextCycleDate');
            $BillingCycleType = ServiceBilling::where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID,'AccountServiceID'=>$AccountServiceID,'AccountSubscriptionID'=>$AccountSubscriptionID,'CLIRateTableID'=>$CLIRateTableID,'AccountServicePackageID'=>$NewAccountServicePackageID])->pluck('BillingCycleType');
            $BillingCycleValue = ServiceBilling::where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID,'AccountServiceID'=>$AccountServiceID,'AccountSubscriptionID'=>$AccountSubscriptionID,'CLIRateTableID'=>$CLIRateTableID,'AccountServicePackageID'=>$NewAccountServicePackageID])->pluck('BillingCycleValue');

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

        log::info('IsAdvance '.$IsAdvance.' AlreadyBilled'.$AlreadyBilled.' StartDate '.$StartDate.' EndDate '.$EndDate.' NumberStartDate '.$NumberStartDate.' NumberEndDate '.$NumberEndDate);

        if ($IsAdvance == 0 && $StartDate >= $NumberStartDate && $StartDate <= $NumberEndDate && $EndDate >= $NumberStartDate && $EndDate <= $NumberEndDate) {
            $NewStartDate = $StartDate;
            $NewEndDate = $EndDate;
        } else if ($IsAdvance == 0 && $NumberStartDate >= $StartDate && $NumberStartDate <= $EndDate) {
            $StartDate = $NumberStartDate;
            if ($NumberEndDate < $EndDate) {
                $EndDate = $NumberEndDate;
            }
            $NewStartDate = $StartDate;
            $NewEndDate = $EndDate;
        } else if ($IsAdvance == 0 && $NumberEndDate >= $StartDate && $NumberEndDate <= $EndDate) {
            $EndDate = $NumberEndDate;
            $NewStartDate = $StartDate;
            $NewEndDate = $EndDate;
        } else if ($IsAdvance == 1 && $AlreadyBilled==0 && $StartDate >= $NumberStartDate && $StartDate <= $NumberEndDate && $EndDate >= $NumberStartDate && $EndDate <= $NumberEndDate) {
            $NewStartDate = $StartDate;
            $NewEndDate = $EndDate;
            log::info(' test condition 1');
        } else if ($IsAdvance == 1 && $AlreadyBilled==0 && $NumberStartDate >= $StartDate && $NumberStartDate <= $EndDate) {
            $NewStartDate = $NumberStartDate;
            $NewEndDate = $EndDate;
            if ($NumberEndDate < $EndDate) {
                $NewEndDate = $NumberEndDate;// '15-3-2015' to '20-3-2015'
            }
            log::info(' test condition 2');
        } else if ($IsAdvance == 1 && $AlreadyBilled==0 && $NumberEndDate >= $StartDate && $NumberEndDate <= $EndDate) {
            $NewStartDate = $StartDate;
            $NewEndDate = $NumberEndDate;
            log::info(' test condition 3');
        } else {
            log::info(' test condition 4');
            $newbilled=1;
        }

        log::info('newbilled '.$newbilled);

        if($newbilled==0){
            AccountBalanceSubscriptionLog::InsertMonthlyBalanceDetailLog($ProcessID,$data,$AccountBalanceLogID, $NewStartDate,$NewEndDate, $FirstTimeBilling,$QuarterSubscription,$decimal_places);
        }
        /**
         * Regular end start
         */

        //}


    }

    public static function InsertMonthlyBalanceDetailLog($ProcessID,$data,$AccountBalanceLogID, $SubscriptionStartDate,$SubscriptionEndDate, $FirstTimeBilling,$QuarterSubscription,$decimal_places){
        log::info('Monthly balance log '.' '.$data['AccountID'].' '.$data['Description']);
        $SubscriptionCharge = $data['MonthlyCost'];
        $ServiceID = $data['ServiceID'];
        $AccountServiceID = $data['AccountServiceID'];
        $AccountID = $data['AccountID'];
        $ProductType = $data['ProductType'];
        $IssueDate = date('Y-m-d');
        $qty = 1;
        $TotalSubscriptionCharge = ( $SubscriptionCharge * $qty );

        $DiscountLineAmount = 0;

        $Price = number_format($SubscriptionCharge, $decimal_places, '.', ''); // per subscription price
        $LineAmount = number_format($TotalSubscriptionCharge, $decimal_places, '.', ''); // total subscription price

        /**
         * Entry no discount
         */

        $SubscriptionLogData=array();
        $SubscriptionLogData['AccountBalanceLogID']=$AccountBalanceLogID;
        $SubscriptionLogData['ServiceID']=$ServiceID;
        $SubscriptionLogData['AccountServiceID']=$AccountServiceID;
        $SubscriptionLogData['IssueDate']=$IssueDate;
        $SubscriptionLogData['ProductType']=$ProductType;
        $SubscriptionLogData['ParentID']=$data['ParentID'];
        $SubscriptionLogData['Description']=$data['Description'];
        $SubscriptionLogData['Price']=$Price;
        $SubscriptionLogData['Qty']=$qty;
        $SubscriptionLogData['StartDate']=$SubscriptionStartDate;
        $SubscriptionLogData['EndDate']=$SubscriptionEndDate;
        $SubscriptionLogData['LineAmount']=$LineAmount;
        $SubscriptionLogData['TotalTax']=0;
        $SubscriptionLogData['TotalAmount']=$LineAmount;
        $SubscriptionLogData['CustomerSubscriptionLogID']=0;
        $SubscriptionLogData['CLIRateTableID']=$data['CLIRateTableID'];
        $SubscriptionLogData['ProcessID']=$ProcessID;
        $SubscriptionLogData["DiscountLineAmount"] = $DiscountLineAmount;
        $SubscriptionLogData['created_at']=date('Y-m-d H:i:s');
        $SubscriptionLogData['updated_at']=date('Y-m-d H:i:s');

        $NewAccountBalanceSubscriptionLog = AccountBalanceSubscriptionLog::create($SubscriptionLogData);

        /* Exampt No */

        $AccountBalanceSubscriptionLogID = $NewAccountBalanceSubscriptionLog->AccountBalanceSubscriptionLogID;
        $TotalTax = AccountBalanceTaxRateLog::CreateSubscriptiontBalanceTax($AccountID, $AccountBalanceSubscriptionLogID, $LineAmount,$ProductType);
        $GrandTotal = $LineAmount + $TotalTax;
        $SubLogData = array();
        $SubLogData['TotalTax'] = $TotalTax;
        $SubLogData['TotalAmount'] = $GrandTotal;
        $SubLogData['updated_at'] = date('Y-m-d H:i:s');
        AccountBalanceSubscriptionLog::where(['AccountBalanceSubscriptionLogID' => $AccountBalanceSubscriptionLogID])->update($SubLogData);

    }

    public static function calculateOneOffCost($ProcessID,$CLI,$OneOffCost,$Type,$ParentID,$ProductType,$CLIRateTableID){
        log::info('Monthly One off log '.' '.$ParentID.' '.$ProductType);
        /* $Count = AccountBalanceSubscriptionLog::where(['ProductType' => $ProductType, 'ParentID' => $ParentID])
            ->where('Description', 'like','%'.$CLI.'%')
            ->count();
        */
        $Count = 0;
        if ($Count == 0) {

            $ProductName = 'One-Off Cost';
            if($Type=='Number'){
                    $CliRateTables = CLIRateTable::where(['CLIRateTableID'=>$ParentID])->first();

                    if($CliRateTables->NumberEndDate == '0000-00-00'){
                        $CliRateTables->NumberEndDate  = date("Y-m-d",strtotime('+1 years'));
                    }
                    $NumberStartDate = $CliRateTables->NumberStartDate;
                    $NumberEndDate = $CliRateTables->NumberEndDate;
                    $AccountID = $CliRateTables->AccountID;
                    $ServiceID = $CliRateTables->ServiceID;
                    $AccountServiceID = $CliRateTables->AccountServiceID;

                    if($ProductType == Product::NUMBER_REGISTRATIONCOST){
                    $ProductName = 'Registration Cost';
                    }
                    $Description = $CLI.' '.$ProductName;
            }else{
                    $AccountServicePackage = DB::table('tblAccountServicePackage')->where(['AccountServicePackageID'=>$ParentID])->first();
                    $PackageName = DB::table('tblPackage')->where(['PackageId'=>$AccountServicePackage->PackageId])->pluck('Name');
                    $NumberStartDate = $AccountServicePackage->PackageStartDate;
                    $NumberEndDate = $AccountServicePackage->PackageEndDate;
                    $AccountID = $AccountServicePackage->AccountID;
                    $ServiceID = $AccountServicePackage->ServiceID;
                    $AccountServiceID = $AccountServicePackage->AccountServiceID;
                    $Description = $PackageName.' '.$ProductName.'('.$CLI.')';
                    if(!empty($AccountServicePackage->ContractID)){
                        $Description = $PackageName.'-'.$AccountServicePackage->ContractID.' '.$ProductName.'('.$CLI.')';
                    }
            }

            log::info($Description.' '.$OneOffCost);

            $CompanyID = Account::where(['AccountID'=>$AccountID])->pluck('CompanyId');
            $decimal_places = Helper::get_round_decimal_places($CompanyID,$AccountID,$ServiceID,$AccountServiceID);

            $AccountBalanceLogID = AccountBalanceLog::where(['AccountID'=>$AccountID])->pluck('AccountBalanceLogID');
            $IssueDate=date('Y-m-d');

            $singlePrice = $OneOffCost;

            $LineTotal = ($singlePrice) * 1;

            $DiscountLineAmount = 0;
            $singlePrice = number_format($singlePrice, $decimal_places, '.', '');
            $LineTotal = number_format($LineTotal, $decimal_places, '.', '');

            $Count = AccountBalanceSubscriptionLog::where(['ProductType' => $ProductType, 'ParentID' => $ParentID,'AccountBalanceLogID' =>$AccountBalanceLogID])
            ->where('Description', 'like','%'.$Description.'%')
            ->count();

            if ($Count == 0) {

                $OneOffChargeLogData = array();
                $OneOffChargeLogData['AccountBalanceLogID'] = $AccountBalanceLogID;
                $OneOffChargeLogData['ServiceID'] = $ServiceID;
                $OneOffChargeLogData['AccountServiceID'] = $AccountServiceID;
                $OneOffChargeLogData['IssueDate'] = $IssueDate;
                $OneOffChargeLogData['ProductType'] = $ProductType;
                $OneOffChargeLogData['ParentID'] = $ParentID;
                $OneOffChargeLogData['Description'] = $Description;
                $OneOffChargeLogData['Price'] = $singlePrice;
                $OneOffChargeLogData['Qty'] = 1;
                $OneOffChargeLogData['StartDate'] = $NumberStartDate;
                $OneOffChargeLogData['EndDate'] = $NumberStartDate;
                $OneOffChargeLogData['LineAmount'] = $LineTotal;
                $OneOffChargeLogData['TotalTax'] = 0;
                $OneOffChargeLogData['TotalAmount'] = $LineTotal;
                $OneOffChargeLogData['CustomerSubscriptionLogID'] = 0;
                $OneOffChargeLogData['CLIRateTableID'] = $CLIRateTableID;
                $OneOffChargeLogData['ProcessID'] = $ProcessID;
                $OneOffChargeLogData["DiscountLineAmount"] = $DiscountLineAmount;
                $OneOffChargeLogData['created_at'] = date('Y-m-d H:i:s');
                $OneOffChargeLogData['updated_at'] = date('Y-m-d H:i:s');
                $AccountBalanceOneOffLog = AccountBalanceSubscriptionLog::create($OneOffChargeLogData);


                $AccountBalanceSubscriptionLogID = $AccountBalanceOneOffLog->AccountBalanceSubscriptionLogID;
                $TotalTax = AccountBalanceTaxRateLog::CreateSubscriptiontBalanceTax($AccountID, $AccountBalanceSubscriptionLogID, $LineTotal, $ProductType);
                $GrandTotal = $LineTotal + $TotalTax;
                $SubLogData = array();
                $SubLogData['TotalTax'] = $TotalTax;
                $SubLogData['TotalAmount'] = $GrandTotal;
                $SubLogData['updated_at'] = date('Y-m-d H:i:s');
                AccountBalanceSubscriptionLog::where(['AccountBalanceSubscriptionLogID' => $AccountBalanceSubscriptionLogID])->update($SubLogData);
            }
        }
    }

    public static function insertPartnerSubscriptionLog($CompanyID,$AccountID,$ProcessID,$SubscriptionDatas){
        $decimal_places = Helper::get_round_decimal_places($CompanyID,$AccountID,0,0);
        $IssueDate = date('Y-m-d');
        $SubscriptionDatas = json_decode(json_encode($SubscriptionDatas),true);
        foreach($SubscriptionDatas as $SubscriptionData){
            $singlePrice = number_format($SubscriptionData['Price'], $decimal_places, '.', '');
            $LineTotal = ($singlePrice) * 1;
            $LineTotal = number_format($LineTotal, $decimal_places, '.', '');

            $SubscriptionLogData=array();
            $SubscriptionLogData['AccountBalanceLogID']=$SubscriptionData['AccountBalanceLogID'];
            $SubscriptionLogData['ServiceID']=$SubscriptionData['ServiceID'];
            $SubscriptionLogData['AccountServiceID']=$SubscriptionData['AccountServiceID'];
            $SubscriptionLogData['IssueDate']=$IssueDate;
            $SubscriptionLogData['ProductType']=$SubscriptionData['ProductType'];
            $SubscriptionLogData['ParentID']=$SubscriptionData['ParentID'];
            $SubscriptionLogData['Description']=$SubscriptionData['Description'];
            $SubscriptionLogData['Price']=$singlePrice;
            $SubscriptionLogData['Qty']=$SubscriptionData['Qty'];
            $SubscriptionLogData['StartDate']=$SubscriptionData['StartDate'];
            $SubscriptionLogData['EndDate']=$SubscriptionData['EndDate'];
            $SubscriptionLogData['LineAmount']=$LineTotal;
            $SubscriptionLogData['TotalTax']=0;
            $SubscriptionLogData['TotalAmount']=$LineTotal;
            $SubscriptionLogData["DiscountLineAmount"] = 0;
            $SubscriptionLogData["CustomerSubscriptionLogID"] = $SubscriptionData["CustomerSubscriptionLogID"];
            $SubscriptionLogData["CLIRateTableID"] = $SubscriptionData["CLIRateTableID"];
            $SubscriptionLogData["ProcessID"] = $ProcessID;
            $SubscriptionLogData['created_at']=date('Y-m-d H:i:s');
            $SubscriptionLogData['updated_at']=date('Y-m-d H:i:s');

            $NewAccountBalanceSubscriptionLog = AccountBalanceSubscriptionLog::create($SubscriptionLogData);

            /* Exampt No */

            $AccountBalanceSubscriptionLogID = $NewAccountBalanceSubscriptionLog->AccountBalanceSubscriptionLogID;
            $TotalTax = AccountBalanceTaxRateLog::CreateSubscriptiontBalanceTax($AccountID, $AccountBalanceSubscriptionLogID, $LineTotal,$SubscriptionData['ProductType']);
            $GrandTotal = $LineTotal + $TotalTax;
            $SubLogData = array();
            $SubLogData['TotalTax'] = $TotalTax;
            $SubLogData['TotalAmount'] = $GrandTotal;
            $SubLogData['updated_at'] = date('Y-m-d H:i:s');
            AccountBalanceSubscriptionLog::where(['AccountBalanceSubscriptionLogID' => $AccountBalanceSubscriptionLogID])->update($SubLogData);
        }
    }
}
