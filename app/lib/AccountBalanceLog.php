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
            ->select('tblAccountBilling.AccountID')
            ->where(array('Status'=>1,'AccountType'=>1,'Billing'=>1,'tblAccountBilling.ServiceID'=>0,'tblAccountBilling.AccountServiceID'=>0,'tblAccountBilling.BillingType'=>AccountBalanceLog::BILLINGTYPE_PREPAID))
            //->where(array('tblAccount.AccountID'=>7990))
            ->get();
        foreach ($Accounts as $Account) {
                $AccountID = $Account->AccountID;
                $CompanyID = $Account->CompanyId;
                $AccountName = $Account->AccountName;
                log::info($Account->AccountID . ' ');
                try {
                    DB::beginTransaction();
                    DB::connection('sqlsrv2')->beginTransaction();
                    AccountBalanceUsageLog::CreateUsageLog($CompanyID, $AccountID, $ProcessID); // done
                    //AccountBalanceLog::CreateServiceLog($CompanyID, $AccountID, $ProcessID);
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
                if(empty($AccountService->SubscriptionBillingCycleType)) {
                    $BillingType = AccountBilling::BILLINGTYPE_POSTPAID;
                }
                $ServiceID          = $AccountService->ServiceID;
                $AccountServiceID   = $AccountService->AccountServiceID;
                $Count=1;
                $ServiceBilling = DB::table('tblServiceBilling')->where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID,'AccountServiceID'=>$AccountServiceID])->first();
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

                        $LatsCycleDate = $AccountBilling->BillingStartDate;
                        $ServiceBillingData=array();
                        $ServiceBillingData['AccountID']=$AccountID;
                        $ServiceBillingData['ServiceID']=$ServiceID;
                        $ServiceBillingData['AccountServiceID']=$AccountServiceID;
                        $ServiceBillingData['BillingType']=$BillingType;
                        $ServiceBillingData['LastCycleDate']=$LatsCycleDate;

                        if(empty($AccountService->SubscriptionBillingCycleType)) {
                            $NextCycleDate = next_billing_date($AccountBilling->BillingCycleType,$AccountBilling->BillingCycleValue,strtotime($LatsCycleDate));
                            $ServiceBillingData['BillingCycleType']=$AccountBilling->BillingCycleType;
                            $ServiceBillingData['BillingCycleValue']=$AccountBilling->BillingCycleValue;
                        }else{
                            $NextCycleDate = next_billing_date($AccountService->SubscriptionBillingCycleType,$AccountService->SubscriptionBillingCycleValue,strtotime($LatsCycleDate));
                            $ServiceBillingData['BillingCycleType']=$AccountService->SubscriptionBillingCycleType;
                            $ServiceBillingData['BillingCycleValue']=$AccountService->SubscriptionBillingCycleValue;
                        }

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
                    log::info('Main AccountService '.$AccountID.' '.$ServiceID.' '.$AccountServiceID);
                    log::info('NextCycleDate '.$NextCycleDate);
                    AccountBalanceSubscriptionLog::CreateSubscriptionLog($CompanyID,$AccountID,$ServiceID,$AccountServiceID,$BillingType,$NextCycleDate);
                }

            }

        }else{
            log::info('No Service');
        }
    }

    public static function updateAccountBalanceAmount(){
        $AccountID=0;
        DB::select("CALL prc_updatePrepaidAccountBalance(?)",array($AccountID));
    }

    public static function getPrepaidAccountBalance($AccountID){
        $BalanceAmount = AccountBalanceLog::where(['AccountID'=>$AccountID])->pluck('BalanceAmount');
        return $BalanceAmount;
    }

}
