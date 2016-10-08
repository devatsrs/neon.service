<?php

namespace App\Lib;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class AccountBalance extends Model
{
    //
    protected $guarded = array("AccountBalanceID");

    protected $table = 'tblAccountBalance';

    protected $primaryKey = "AccountBalanceID";

    public $timestamps = false; // no created_at and updated_at

    public static function LowBalanceReminder($CompanyID,$ProcessID){

        $BillingClass = BillingClass::where('CompanyID',$CompanyID)->get();
        foreach($BillingClass as $BillingClassSingle) {
            if (isset($BillingClassSingle->LowBalanceReminderStatus) && $BillingClassSingle->LowBalanceReminderStatus == 1 && isset($BillingClassSingle->LowBalanceReminderSettings)) {
                $settings = json_decode($BillingClassSingle->LowBalanceReminderSettings, true);
                $settings['ProcessID'] = $ProcessID;
                $settings['EmailType'] = AccountEmailLog::LowBalanceReminder;
                $query = "CALL prc_LowBalanceReminder(?,?,?)";
                $AccountBalanceWarnings = DB::select($query, array($CompanyID, 0,$BillingClassSingle->BillingClassID));
                foreach ($AccountBalanceWarnings as $AccountBalanceWarning) {
                    if ($AccountBalanceWarning->BalanceWarning == 1 &&(Account::FirstLowBalanceReminder($AccountBalanceWarning->AccountID) == 0 || cal_next_runtime($settings) == date('Y-m-d H:i:00'))) {
                        Log::info('AccountID = '.$AccountBalanceWarning->AccountID.' SendReminder sent ');
                        NeonAlert::SendReminder($CompanyID, $settings, $settings['TemplateID'], $AccountBalanceWarning->AccountID);
                    }
                }
                if(cal_next_runtime($settings) == date('Y-m-d H:i:00')){
                    NeonAlert::UpdateNextRunTime($BillingClassSingle->BillingClassID,'LowBalanceReminderSettings');
                }
            }
        }
    }

    public static function updateAccountUnbilledAmount($CompanyID){
        DB::connection('neon_report')->select("CALL prc_updateUnbilledAmount(?)",array($CompanyID));
    }

    public static function getBalanceAmount($AccountID){
        return AccountBalance::where(['AccountID'=>$AccountID])->pluck('BalanceAmount');
    }
    public static function getBalanceThreshold($AccountID){
        return str_replace('p', '%',AccountBalance::where(['AccountID'=>$AccountID])->pluck('BalanceThreshold'));
    }
    public static function getOutstandingAmount($CompanyID,$AccountID){
        DB::connection('sqlsrv2')->statement('CALL prc_updateSOAOffSet(?,?)',array($CompanyID,$AccountID));
        return AccountBalance::where(['AccountID'=>$AccountID])->pluck('SOAOffset');
    }

}
