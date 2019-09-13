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

        $Accounts =   AccountBilling::join('tblAccount','tblAccount.AccountID','=','tblAccountBilling.AccountID')
            ->select('tblAccountBilling.AccountID','tblAccount.CompanyId','tblAccount.AccountName')
            ->where(array('Status'=>1,'AccountType'=>1,'Billing'=>1,'tblAccountBilling.ServiceID'=>0,'tblAccountBilling.AccountServiceID'=>0,'tblAccountBilling.BillingType'=>AccountBalanceLog::BILLINGTYPE_PREPAID))
            //->where(array('tblAccount.AccountID'=>6736))
            ->get();
        foreach ($Accounts as $Account) {
                $AccountID = $Account->AccountID;
                $CompanyID = $Account->CompanyId;
                $AccountName = $Account->AccountName;
                log::info($Account->AccountID . ' ');
                try {
                    DB::beginTransaction();
                    DB::connection('sqlsrv2')->beginTransaction();
                    log::info('Usage Start');
                    AccountBalanceUsageLog::CreateUsageLog($CompanyID, $AccountID, $ProcessID); // done
                    log::info('Subscription Start');
                    AccountBalanceLog::CreateServiceLog($CompanyID, $AccountID, $ProcessID);
                    log::info('One Off Start');
                    AccountOneOffCharge::CreateOneOffServiceLog($CompanyID, $AccountID, $ProcessID);
                    DB::commit();
                    DB::connection('sqlsrv2')->commit();
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
        /* Subscription wise log */
        AccountBalanceLog::CreateSubscriptionServiceLog($CompanyID,$AccountID,$ProcessID);

        /* Service wise log */

        AccountBalanceLog::CreateAccountServiceLog($CompanyID,$AccountID,$ProcessID);

    }

    public static function updateAccountBalanceAmount(){
        $AccountID=0;
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
                $BillingType = AccountBilling::BILLINGTYPE_PREPAID;
                $ServiceID          = 0;
                $AccountServiceID   = 0;
                $CLIRateTableID =0;
                $Count=1;
                $ServiceBilling = DB::table('tblServiceBilling')->where(['AccountSubscriptionID'=>$AccountSubscriptionID,'AccountID'=>$AccountID,'ServiceID'=>$ServiceID,'AccountServiceID'=>$AccountServiceID,'CLIRateTableID'=>$CLIRateTableID])->first();
                if(empty($ServiceBilling)){
                    $AccountBilling=AccountBilling::where(['AccountID'=>$AccountID,'ServiceID'=>0,'AccountServiceID'=>0])->first();
                    if(!empty($AccountBilling->BillingStartDate)){

                        // if billing type is postpaid and billing cycle is manual then skip this service
                        if($BillingType == AccountBilling::BILLINGTYPE_POSTPAID && $AccountBilling->BillingCycleType == 'manual') {
                            continue;
                        }
                        // if BillingStartDate is null then skip this service
                        if(empty($AccountBilling->BillingStartDate)) {
                            continue;
                        }

                        if(empty($AccountSubscription->Frequency)){
                            continue;
                        }

                        $LatsCycleDate = $AccountBilling->BillingStartDate;
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
                        $NextCycleDate = next_billing_date($Frequency,$SubscriptionBillingCycleValue,strtotime($LatsCycleDate));
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
                    AccountBalanceSubscriptionLog::CreateSubscriptionLog($CompanyID,$AccountID,$ServiceID,$AccountServiceID,$CLIRateTableID,$BillingType,$NextCycleDate,$AccountSubscriptionID);
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
                $BillingType = AccountBilling::BILLINGTYPE_PREPAID;
                $ServiceID = $AccountService->ServiceID;
                $AccountServiceID = $AccountService->AccountServiceID;

                $CliRateTables = CLIRateTable::where(['AccountServiceID'=>$AccountServiceID])->where('NumberStartDate','<=',$Today)->get();
                if(!empty($CliRateTables)) {
                    foreach ($CliRateTables as $CliRateTable) {
                        $CLIRateTableID = $CliRateTable->CLIRateTableID;
                        $Count = 1;
                        $ServiceBilling = DB::table('tblServiceBilling')->where(['AccountID' => $AccountID, 'ServiceID' => $ServiceID, 'AccountServiceID' => $AccountServiceID, 'CLIRateTableID' => $CLIRateTableID, 'AccountSubscriptionID' => 0])->first();
                        if (empty($ServiceBilling)) {
                            $AccountBilling = AccountBilling::where(['AccountID' => $AccountID, 'ServiceID' => 0, 'AccountServiceID' => 0])->first();
                            if (!empty($AccountBilling->BillingStartDate)) {

                                // if billing type is postpaid and billing cycle is manual then skip this service
                                if ($BillingType == AccountBilling::BILLINGTYPE_POSTPAID && $AccountBilling->BillingCycleType == 'manual') {
                                    continue;
                                }
                                // if BillingStartDate is null then skip this service
                                if (empty($AccountBilling->BillingStartDate)) {
                                    continue;
                                }

                                $LatsCycleDate = $AccountBilling->BillingStartDate;
                                $ServiceBillingData = array();
                                $ServiceBillingData['AccountID'] = $AccountID;
                                $ServiceBillingData['ServiceID'] = $ServiceID;
                                $ServiceBillingData['AccountServiceID'] = $AccountServiceID;
                                $ServiceBillingData['AccountSubscriptionID'] = 0;
                                $ServiceBillingData['CLIRateTableID'] = $CLIRateTableID;
                                $ServiceBillingData['BillingType'] = $BillingType;
                                $ServiceBillingData['LastCycleDate'] = $LatsCycleDate;

                                $BillingCycleType = 'monthly';
                                $BillingCycleValue = '';

                                $NextCycleDate = next_billing_date($BillingCycleType, $BillingCycleValue, strtotime($LatsCycleDate));
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
                            AccountBalanceSubscriptionLog::CreateSubscriptionLog($CompanyID, $AccountID, $ServiceID, $AccountServiceID, $CLIRateTableID, $BillingType, $NextCycleDate, 0);
                        }

                    } // cliratetable loop over
                }//empty check over
            } // account service loop over

        }else{
            log::info('No Service');
        }
    }
}
