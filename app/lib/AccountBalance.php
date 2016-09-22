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
        $AccountBalanceWarnings = DB::select("CALL prc_LowBalanceReminder('" . $CompanyID . "','0')");
        foreach ($AccountBalanceWarnings as $AccountBalanceWarning) {
            $BillingClass = AccountBilling::getBillingClass($AccountBalanceWarning->AccountID);
            if (isset($BillingClass->LowBalanceReminderStatus) && $BillingClass->LowBalanceReminderStatus == 1 && isset($BillingClass->LowBalanceReminderSettings)) {
                if ($AccountBalanceWarning->BalanceWarning == 1 && Account::getAccountEmailCount($AccountBalanceWarning->AccountID, AccountEmailLog::LowBalanceReminder) == 0) {
                    $settings = json_decode($BillingClass->LowBalanceReminderSettings, true);
                    $settings['ProcessID'] = $ProcessID;
                    $settings['BalanceAmount'] = $AccountBalanceWarning->BalanceAmount;
                    $settings['BalanceThreshold'] = str_replace('p', '%', $AccountBalanceWarning->BalanceThreshold);
                    NeonAlert::SendReminder($CompanyID, $settings, $settings['TemplateID'], $AccountBalanceWarning->AccountID);
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

}
