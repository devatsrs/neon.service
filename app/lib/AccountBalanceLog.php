<?php

namespace App\Lib;

use App\PBX;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;


class AccountBalanceLog extends Model
{
    //
    protected $guarded = array("AccountBalanceLogID");

    protected $table = 'tblAccountBalanceLog';

    protected $primaryKey = "AccountBalanceLogID";

    public $timestamps = false; // no created_at and updated_at

    const BILLINGTYPE_PREPAID = 1;
    const BILLINGTYPE_POSTPAID = 2;
    const BILLINGTYPE_BOTH = 3;

    public static function CreateAllLog($ProcessID){
        Log::info('CreateAllLog Start ');
        $errors = array();

        /**
        $Accounts =   AccountBilling::join('tblAccount','tblAccount.AccountID','=','tblAccountBilling.AccountID')
            ->select('tblAccountBilling.AccountID','tblAccount.CompanyId','tblAccount.AccountName')
            ->where(array('Status'=>1,'AccountType'=>1,'Billing'=>1,'tblAccountBilling.ServiceID'=>0,'tblAccountBilling.AccountServiceID'=>0,'tblAccountBilling.BillingType'=>AccountBalanceLog::BILLINGTYPE_PREPAID))
            //->where(array('tblAccount.AccountID'=>6736))
            //->where(array('tblAccount.AccountID'=>5401))
            ->get();
         * */

        $Accounts = Account::getAllAccounts([1,8,9]);
        foreach ($Accounts as $Account) {
                $AccountID = $Account['AccountID'];
                $CompanyID = $Account['CompanyId'];
                $AccountName = $Account['AccountName'];
                $Reseller = $Account['Reseller'];
                log::info($Account['AccountID'] . ' ');
                try {
                    DB::beginTransaction();
                    DB::connection('sqlsrv2')->beginTransaction();
                    log::info('Usage Start');
                    AccountBalanceUsageLog::CreateUsageLog($CompanyID, $AccountID, $ProcessID); // done
                    log::info('Subscription Start');
                    AccountBalanceLog::CreateServiceLog($CompanyID, $AccountID, $ProcessID);
                    log::info('One Off Start');
                    AccountOneOffCharge::CreateOneOffServiceLog($CompanyID, $AccountID, $ProcessID);
                    if($Reseller==1){
                        $SubscriptionDatas = DB::select("call prc_insertPartnerSubscriptionsLog ('" . $CompanyID . "','".$AccountID."','".$ProcessID."')");
                        log::info('subscription data count '.count($SubscriptionDatas));
                        if(count($SubscriptionDatas) > 0){
                            AccountBalanceSubscriptionLog::insertPartnerSubscriptionLog($CompanyID,$AccountID,$ProcessID,$SubscriptionDatas);// need to remove comment
                        }
                    }
                    DB::statement("CALL prc_ProcessSubscriptionDiscountPlan ('" . $ProcessID . "')");

                    DB::commit();
                    DB::connection('sqlsrv2')->commit();

                    AccountBalanceLog::updateAccountBalanceAmount($AccountID);
                } catch (\Exception $e) {
                    try {
                        Log::error('Account Balance Rollback AccountID = ' . $AccountID);
                        DB::connection('sqlsrv2')->rollback();
                        DB::rollback();
                        Log::error($e);
                        $errors[] = $AccountName . " " . $e->getMessage();

                    } catch (\Exception $err) {
                        Log::error($err);
                        $errors[] = $AccountName . " " . $e->getMessage() . ' ## ' . $err->getMessage();
                    }

                }
        }
        Log::info('CreateAllLog End ');

        return $errors;

    }

    public static function CreateServiceLog($CompanyID,$AccountID,$ProcessID){
        /* Subscription wise log Account Level */
        AccountBalanceLog::CreateSubscriptionServiceLog($CompanyID,$AccountID,$ProcessID);

        /* Service wise log */

        AccountBalanceLog::CreateAccountServiceLog($CompanyID,$AccountID,$ProcessID);

    }

    public static function updateAccountBalanceAmount($AccountID){
        //$AccountID=0;
        DB::select("CALL prc_updatePrepaidAccountBalance(?)",array($AccountID));
    }

    public static function getPrepaidAccountBalance($AccountID){
        $BalanceAmount = AccountBalanceLog::where(['AccountID'=>$AccountID])->pluck('BalanceAmount');
        return $BalanceAmount;
    }

    /** new */
    public static function CreateSubscriptionServiceLog($CompanyID,$AccountID,$ProcessID){
        $Today=date('Y-m-d');
        $AccountSubscriptions = AccountSubscription::where(['AccountID'=>$AccountID,'ServiceID'=>0,'AccountServiceID'=>0])->get();
        if(!empty($AccountSubscriptions)){
            /**
             * Prepaid service
             */
            foreach($AccountSubscriptions as $AccountSubscription){
                $AccountSubscriptionID = $AccountSubscription->AccountSubscriptionID;
                $NextCycleDate='';
                $LatsCycleDate='';
                $ServiceID          = 0;
                $AccountServiceID   = 0;
                $CLIRateTableID =0;
                $AccountServicePackageID =0;
                $Count=1;
                $AccountBilling=AccountBilling::where(['AccountID'=>$AccountID,'ServiceID'=>0,'AccountServiceID'=>0])->first();
                $BillingType = $AccountBilling->BillingType;
                $ServiceBilling = DB::table('tblServiceBilling')->where(['AccountSubscriptionID'=>$AccountSubscriptionID,'AccountID'=>$AccountID,'ServiceID'=>$ServiceID,'AccountServiceID'=>$AccountServiceID,'CLIRateTableID'=>$CLIRateTableID,'AccountServicePackageID'=>$AccountServicePackageID])->first();
                if(empty($ServiceBilling)){
                    if(!empty($AccountBilling->BillingStartDate)){

                        // if billing type is postpaid and billing cycle is manual then skip this service
                        if($AccountBilling->BillingCycleType == 'manual') {
                            continue;
                        }
                        // if BillingStartDate is null then skip this service
                        if(empty($AccountBilling->BillingStartDate)) {
                            continue;
                        }

                        if(empty($AccountSubscription->Frequency)){
                            continue;
                        }

                        if(empty($AccountSubscription->StartDate)){
                            continue;
                        }

                        $LatsCycleDate = $AccountSubscription->StartDate; // before date is Billing Start Date
                        $ServiceBillingData=array();
                        $ServiceBillingData['AccountSubscriptionID']=$AccountSubscriptionID;
                        $ServiceBillingData['AccountID']=$AccountID;
                        $ServiceBillingData['ServiceID']=$ServiceID;
                        $ServiceBillingData['AccountServiceID']=$AccountServiceID;
                        $ServiceBillingData['CLIRateTableID']=$CLIRateTableID;
                        $ServiceBillingData['BillingType']=$BillingType;
                        $ServiceBillingData['LastCycleDate']=$LatsCycleDate;
                        $Frequency = strtolower($AccountSubscription->Frequency);
                        $SubscriptionBillingCycleValue = '';
                        if($Frequency=='weekly'){
                            $SubscriptionBillingCycleValue='monday';
                        }

                        //$NextCycleDate = next_billing_date($Frequency,$SubscriptionBillingCycleValue,strtotime($LatsCycleDate));
                        $NextCycleDate = $LatsCycleDate; // first invoice generate logic
                        $ServiceBillingData['BillingCycleType']=$Frequency;
                        $ServiceBillingData['BillingCycleValue']=$SubscriptionBillingCycleValue;

                        $ServiceBillingData['NextCycleDate']=$NextCycleDate;
                        $ServiceBillingData['created_at']=date('Y-m-d H:i:s');
                        $ServiceBillingData['updated_at']=date('Y-m-d H:i:s');

                        DB::table('tblServiceBilling')->insert($ServiceBillingData);
                    }
                }else{
                    $LatsCycleDate = $ServiceBilling->LastCycleDate;
                    $NextCycleDate = $ServiceBilling->NextCycleDate;
                }
                /***
                 * Subscriptions
                 */

                //log::info('ServiceID '.$ServiceID.' Billing Type '.$BillingType.' Count '.$Count.' LastCycleDate '.$LatsCycleDate.' NextCycleDate '.$NextCycleDate);
                if(!empty($NextCycleDate) && $NextCycleDate <= $Today){
                    log::info('Main AccountService '.$AccountID.' '.$ServiceID.' '.$AccountServiceID.' '.$AccountSubscriptionID);
                    log::info('NextCycleDate '.$NextCycleDate);
                    AccountBalanceSubscriptionLog::CreateSubscriptionLog($CompanyID,$AccountID,$ProcessID,$ServiceID,$AccountServiceID,$CLIRateTableID,$AccountServicePackageID,$BillingType,$NextCycleDate,$AccountSubscriptionID);
                }

            }

        }else{
            log::info('No Subscription');
        }
    }

    public static function CreateAccountServiceLog($CompanyID,$AccountID,$ProcessID){
        $Today=date('Y-m-d');
        $AccountServices = AccountService::where(['AccountID'=>$AccountID])->get();

        if(!empty($AccountServices)){
            /**
             * Prepaid service
             */
            foreach($AccountServices as $AccountService){
                $NextCycleDate='';
                $LatsCycleDate='';
                $AccountBilling=AccountBilling::where(['AccountID'=>$AccountID,'ServiceID'=>0,'AccountServiceID'=>0])->first();
                $BillingType = $AccountBilling->BillingType;
                $ServiceID = $AccountService->ServiceID;
                $AccountServiceID = $AccountService->AccountServiceID;

                $CliRateTables = CLIRateTable::where(['AccountServiceID'=>$AccountServiceID])->where(['Status'=>1])->where('NumberStartDate','<=',$Today)->get();
                if(!empty($CliRateTables)) {
                    foreach ($CliRateTables as $CliRateTable) {
                        $CLIRateTableID = $CliRateTable->CLIRateTableID;
                        $AccountServicePackageID = $CliRateTable->AccountServicePackageID;
                        AccountBalanceLog::InsertServiceBilling($CompanyID,$AccountID,$ServiceID,$AccountServiceID,$CLIRateTableID,0,$ProcessID);
                        if($AccountServicePackageID>0){
                            AccountBalanceLog::InsertServiceBilling($CompanyID,$AccountID,$ServiceID,$AccountServiceID,$CLIRateTableID,$AccountServicePackageID,$ProcessID);
                        }

                    } // cliratetable loop over
                }//empty check over
            } // account service loop over

        }else{
            log::info('No Service');
        }
    }

    // working on
    public static function InsertServiceBilling($CompanyID,$AccountID,$ServiceID,$AccountServiceID,$CLIRateTableID,$AccountServicePackageID,$ProcessID){
        $Today=date('Y-m-d');

        $AccountBilling=AccountBilling::where(['AccountID'=>$AccountID,'ServiceID'=>0,'AccountServiceID'=>0])->first();
        $BillingType = $AccountBilling->BillingType;

        $Count = 1;
        $ServiceBilling = DB::table('tblServiceBilling')->where(['AccountID' => $AccountID, 'ServiceID' => $ServiceID, 'AccountServiceID' => $AccountServiceID, 'CLIRateTableID' => $CLIRateTableID,'AccountServicePackageID' => $AccountServicePackageID, 'AccountSubscriptionID' => 0])->first();
        if (empty($ServiceBilling)) {
            if (!empty($AccountBilling->BillingStartDate)) {

                // if billing type is postpaid and billing cycle is manual then skip this service
                if ($AccountBilling->BillingCycleType == 'manual') {
                    return;
                }
                // if BillingStartDate is null then skip this service
                if (empty($AccountBilling->BillingStartDate)) {
                    return;
                }

                $CliRateTable=CLIRateTable::where(['CLIRateTableID'=>$CLIRateTableID])->first();

                $AccountServicePackage = DB::table('tblAccountServicePackage')->where(['AccountServicePackageID'=>$AccountServicePackageID])->first();

                if($AccountServicePackageID > 0){
                    $LatsCycleDate = $AccountServicePackage->PackageStartDate;
                }else{
                    $LatsCycleDate = $CliRateTable->NumberStartDate;
                }

                $BillingCycleType = 'monthly';
                $BillingCycleValue = '';

                if(!empty($BillingType) && $BillingType == AccountBilling::BILLINGTYPE_PREPAID){
                    $BillingCycleType = 'monthly_anniversary';
                    $BillingCycleValue = $LatsCycleDate;
                }

                if($BillingType == AccountBilling::BILLINGTYPE_POSTPAID && $LatsCycleDate < $AccountBilling->BillingStartDate){
                    $LatsCycleDate = $AccountBilling->BillingStartDate;
                }

                //$LatsCycleDate = $AccountBilling->BillingStartDate;
                $ServiceBillingData = array();
                $ServiceBillingData['AccountID'] = $AccountID;
                $ServiceBillingData['ServiceID'] = $ServiceID;
                $ServiceBillingData['AccountServiceID'] = $AccountServiceID;
                $ServiceBillingData['AccountSubscriptionID'] = 0;
                $ServiceBillingData['CLIRateTableID'] = $CLIRateTableID;
                $ServiceBillingData['AccountServicePackageID'] = $AccountServicePackageID;
                $ServiceBillingData['BillingType'] = $BillingType;
                $ServiceBillingData['LastCycleDate'] = $LatsCycleDate;



                //$NextCycleDate = next_billing_date($BillingCycleType, $BillingCycleValue, strtotime($LatsCycleDate));
                $NextCycleDate = $LatsCycleDate; // first billing should both date same
                $ServiceBillingData['BillingCycleType'] = $BillingCycleType;
                $ServiceBillingData['BillingCycleValue'] = $BillingCycleValue;


                $ServiceBillingData['NextCycleDate'] = $NextCycleDate;
                $ServiceBillingData['created_at'] = date('Y-m-d H:i:s');
                $ServiceBillingData['updated_at'] = date('Y-m-d H:i:s');

                DB::table('tblServiceBilling')->insert($ServiceBillingData);
            }
        } else {
            $LatsCycleDate = $ServiceBilling->LastCycleDate;
            $NextCycleDate = $ServiceBilling->NextCycleDate;
        }
        /***
         * Subscriptions
         */

        //log::info('ServiceID '.$ServiceID.' Billing Type '.$BillingType.' Count '.$Count.' LastCycleDate '.$LatsCycleDate.' NextCycleDate '.$NextCycleDate);
        if (!empty($NextCycleDate) && $NextCycleDate <= $Today) {
            log::info('Main AccountService ' . $AccountID . ' ' . $ServiceID . ' ' . $AccountServiceID . ' 0');
            log::info('NextCycleDate ' . $NextCycleDate);
            AccountBalanceSubscriptionLog::CreateSubscriptionLog($CompanyID, $AccountID,$ProcessID, $ServiceID, $AccountServiceID, $CLIRateTableID,$AccountServicePackageID, $BillingType, $NextCycleDate, 0);
        }


    }
}
