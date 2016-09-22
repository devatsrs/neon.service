<?php


namespace App\Lib;


use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class Payment extends \Eloquent{
    protected $fillable = [];
    protected $connection = 'sqlsrv2';
    protected $table = "tblPayment";
    protected $primaryKey = "PaymentID";


    public static function PaymentReminder($CompanyID,$ProcessID){
        $query = "CALL prc_getDueInvoice(?,?)";
        $Invoices = DB::connection('sqlsrv2')->select($query, array($CompanyID, 0));

        foreach ($Invoices as $Invoice) {
            $BillingClass = AccountBilling::getBillingClass($Invoice->AccountID);
            if (isset($BillingClass->PaymentReminderStatus) && $BillingClass->PaymentReminderStatus == 1 && isset($BillingClass->PaymentReminderSettings)) {
                if (Account::getAccountEmailCount($Invoice->AccountID, AccountEmailLog::PaymentReminder) == 0) {
                    $settings = json_decode($BillingClass->PaymentReminderSettings, true);
                    $settings['ProcessID'] = $ProcessID;
                    if ($foundkey = array_search($Invoice->DueDay, $settings['Day'])) {
                        NeonAlert::SendReminder($CompanyID, $settings, $settings['TemplateID'][$foundkey], $Invoice->AccountID);
                    }
                }
            }
        }
    }

} 