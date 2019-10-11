<?php

namespace App\Lib;

use App\PBX;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class AccountBalanceUsageLog extends Model
{
    //
    protected $guarded = array("AccountBalanceUsageLogID");

    protected $table = 'tblAccountBalanceUsageLog';

    protected $primaryKey = "AccountBalanceUsageLogID";

    public $timestamps = false; // no created_at and updated_at

    public static function CreateUsageLog($CompanyID,$AccountID,$ProcessID){
        $count=0;
        $EndDate=date('Y-m-d');
        $AccountBalanceLogID=AccountBalanceLog::where(['CompanyID'=>$CompanyID,'AccountID'=>$AccountID])->pluck('AccountBalanceLogID');
        if(empty($AccountBalanceLogID)){
            $data['CompanyID']=$CompanyID;
            $data['AccountID']=$AccountID;
            $data['BalanceAmount']=0;
            $data['created_at']=date('Y-m-d H:i:s');
            $data['updated_at']=date('Y-m-d H:i:s');
            AccountBalanceLog::create($data);

            $AccountBalanceLogID=AccountBalanceLog::where(['CompanyID'=>$CompanyID,'AccountID'=>$AccountID])->pluck('AccountBalanceLogID');
        }else{
            $count=AccountBalanceUsageLog::where(['AccountBalanceLogID'=>$AccountBalanceLogID])->count();
        }
        if(empty($count)){
            $StartDate = AccountBilling::where(['AccountID'=>$AccountID,'AccountServiceID'=>0,'ServiceID'=>0])->pluck('BillingStartDate');
        }else{
            /**
             * need to check
             **/
            // $StartDate = AccountBilling::where(['AccountID'=>$AccountID,'AccountServiceID'=>0,'ServiceID'=>0])->pluck('LastInvoiceDate');
            $StartDate = date('Y-m-d', strtotime('-1 day', strtotime($EndDate))); // yesterday
        }
        $Total=0;
        if(!empty($StartDate) && !empty($AccountBalanceLogID)){
            while ($StartDate <= $EndDate) {
                log::info('Date '.$StartDate);
                $SubTotal=AccountBalanceUsageLog::CreateUsageLogDaily($AccountID,$AccountBalanceLogID,$StartDate);
                $Total=$Total+$SubTotal;
                $StartDate = date('Y-m-d', strtotime('+1 day', strtotime($StartDate)));
            }
        }
        log::info('Total Charge '.$Total);

    }


    public static function CreateUsageLogDaily($AccountID,$AccountBalanceLogID,$Date){
        $UsageStartDate=date('Y-m-d 00:00:00',strtotime($Date));
        $UsageEndDate=date('Y-m-d 23:59:59',strtotime($Date));
        $Date=date('Y-m-d 00:00:00',strtotime($Date));
        $ServiceID=0;
        $AccountServiceID=0;
        //$TotalCharges = Invoice::getAccountUsageTotal($CompanyID, $AccountID, $UsageStartDate, $UsageEndDate,$ServiceID,$AccountServiceID);
        $TotalCharges = UsageDetail::getTotalUsageByStartDate($AccountID,$Date);
        //log::info('Total Usage '.$TotalCharges);
        $count = AccountBalanceUsageLog::where(['AccountBalanceLogID'=>$AccountBalanceLogID,'Type'=>0,'Date'=>$UsageStartDate])->count();
        if($count==0){
            $data=array();
            $data['AccountBalanceLogID']=$AccountBalanceLogID;
            $data['Type']=0;
            $data['Date']=$UsageStartDate;
            $data['UsageAmount']=$TotalCharges;
            $data['TotalTax']=0;
            $data['TotalAmount']=$TotalCharges;
            $data['created_at']=date('Y-m-d H:i:s');
            $data['updated_at']=date('Y-m-d H:i:s');
            AccountBalanceUsageLog::create($data);
        }
        $AccountBalanceUsageLogID = AccountBalanceUsageLog::where(['AccountBalanceLogID'=>$AccountBalanceLogID,'Type'=>0,'Date'=>$UsageStartDate])->pluck('AccountBalanceUsageLogID');
        //$TotalTax = AccountBalanceTaxRateLog::CreateUsageAccountBalanceTax($AccountID,$AccountBalanceUsageLogID,$TotalCharges);
        $TotalTax = 0;
        $GrandTotal = $TotalCharges + $TotalTax;
        $UpdateData=array();
        $UpdateData['UsageAmount']=$TotalCharges;
        $UpdateData['TotalTax']=$TotalTax;
        $UpdateData['TotalAmount']=$GrandTotal;
        $UpdateData['updated_at']=date('Y-m-d H:i:s');
        AccountBalanceUsageLog::where(['AccountBalanceUsageLogID'=>$AccountBalanceUsageLogID])->update($UpdateData);

        AccountBalanceUsageLog::CreateResellerUsageLogDaily($AccountID,$AccountBalanceLogID,$UsageStartDate);
        return $GrandTotal;
    }

    public static function CreateResellerUsageLogDaily($AccountID,$AccountBalanceLogID,$UsageStartDate){
        $Count = Reseller::where(['AccountID' =>$AccountID])->count();
        if($Count==1){
            $TotalCharges = UsageDetail::getResellerTotalUsageByStartDate($AccountID,$UsageStartDate);
            $TotalCharges = $TotalCharges * -1;

            $count = AccountBalanceUsageLog::where(['AccountBalanceLogID'=>$AccountBalanceLogID,'Type'=>1,'Date'=>$UsageStartDate])->count();
            if($count==0){
                $data=array();
                $data['AccountBalanceLogID']=$AccountBalanceLogID;
                $data['Type']=1;
                $data['Date']=$UsageStartDate;
                $data['UsageAmount']=$TotalCharges;
                $data['TotalTax']=0;
                $data['TotalAmount']=$TotalCharges;
                $data['created_at']=date('Y-m-d H:i:s');
                $data['updated_at']=date('Y-m-d H:i:s');
                AccountBalanceUsageLog::create($data);
            }
            $AccountBalanceUsageLogID = AccountBalanceUsageLog::where(['AccountBalanceLogID'=>$AccountBalanceLogID,'Type'=>1,'Date'=>$UsageStartDate])->pluck('AccountBalanceUsageLogID');
            //$TotalTax = AccountBalanceTaxRateLog::CreateUsageAccountBalanceTax($AccountID,$AccountBalanceUsageLogID,$TotalCharges);
            $TotalTax = 0;
            $GrandTotal = $TotalCharges + $TotalTax;
            $UpdateData=array();
            $UpdateData['UsageAmount']=$TotalCharges;
            $UpdateData['TotalTax']=$TotalTax;
            $UpdateData['TotalAmount']=$GrandTotal;
            $UpdateData['updated_at']=date('Y-m-d H:i:s');
            AccountBalanceUsageLog::where(['AccountBalanceUsageLogID'=>$AccountBalanceUsageLogID])->update($UpdateData);
        }
    }

}
