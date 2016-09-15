<?php
namespace App\Lib;

use Illuminate\Support\Facades\Log;

class NeonAlert extends \Eloquent {

    public static function neon_alerts($CompanyID,$ProcessID){
        $cronjobdata = array();
        /*try {
            $cronjobdata = AccountBalance::SendBalanceThresoldEmail($CompanyID,$ProcessID);
        } catch (\Exception $e) {
            Log::error($e);
            $cronjobdata[] = 'Low Balance Reminder Failed';
        }*/

        try {
            $cronjobdata = Payment::PaymentReminder($CompanyID,$ProcessID);
        } catch (\Exception $e) {
            Log::error($e);
            $cronjobdata[] = 'Payment Reminder Failed';
        }

        return $cronjobdata;
    }


}