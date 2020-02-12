<?php
namespace App\Lib;

class AccountOneOffCharge extends \Eloquent {
    protected $fillable = [];
    protected $connection = "sqlsrv2";
    protected $table = "tblAccountOneOffCharge";
    protected $primaryKey = "AccountOneOffChargeID";
    protected $guarded = array('AccountOneOffChargeID');


    public static function check(){
        return true;
    }

    public static function getAccountOneoffChargesByDate($AccountID,$ServiceID,$AccountServiceID,$StartDate,$EndDate){
        $Result = AccountOneOffCharge::where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID,'AccountServiceID'=>$AccountServiceID])->whereBetween('Date',[$StartDate,$EndDate])->get();
        return $Result;
    }

    public static function CreateOneOffServiceLog($CompanyID, $AccountID, $ProcessID){
        $Today=date('Y-m-d 00:00:00');
        $AccountOneOffCharges = AccountOneOffCharge::where(['AccountID'=>$AccountID,'ServiceID'=>0,'AccountServiceID'=>0])->get();
        $AccountBilling=AccountBilling::where(['AccountID'=>$AccountID,'ServiceID'=>0,'AccountServiceID'=>0])->first();
        $BillingType = $AccountBilling->BillingType;
        if(!empty($AccountOneOffCharges)){
            foreach ($AccountOneOffCharges as $AccountOneOffCharge) {
                if($AccountOneOffCharge->Date <= $Today ) {
                    $Count = AccountBalanceSubscriptionLog::where(['ProductType' => Product::ONEOFFCHARGE, 'ParentID' => $AccountOneOffCharge->AccountOneOffChargeID, 'StartDate' => $AccountOneOffCharge->Date])->count();
                    if ($Count == 0) {
                        AccountBalanceSubscriptionLog::CreateOneOffChargeBalanceLog($ProcessID,$BillingType, $AccountOneOffCharge->AccountOneOffChargeID, $AccountOneOffCharge->Date, $AccountOneOffCharge->Date);
                    }
                }
            }
        }
    }
}