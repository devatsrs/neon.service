<?php

namespace App\Lib;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

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
                $query = "CALL prc_LowBalanceReminder(?,?,?)";
                $AccountBalanceWarnings = DB::select($query, array($CompanyID, 0,$BillingClassSingle->BillingClassID));
                foreach ($AccountBalanceWarnings as $AccountBalanceWarning) {
                    $settings = json_decode($BillingClassSingle->LowBalanceReminderSettings, true);
                    if ($AccountBalanceWarning->BalanceWarning == 1 && cal_next_runtime($settings) == date('Y-m-d H:i:00')) {
                        $settings['ProcessID'] = $ProcessID;
                        NeonAlert::SendReminder($CompanyID, $settings, $settings['TemplateID'], $AccountBalanceWarning->AccountID);
                    }
                }
                NeonAlert::UpdateNextRunTime($BillingClassSingle->BillingClassID,'LowBalanceReminderSettings');
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

}
