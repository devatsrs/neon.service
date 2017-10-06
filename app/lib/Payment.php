<?php


namespace App\Lib;


use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class Payment extends \Eloquent{
    protected $fillable = [];
    protected $connection = 'sqlsrv2';
    protected $table = "tblPayment";
    protected $primaryKey = "PaymentID";

    const AUTOINVOICETEMPLATE = "AutoInvoicePayment";


    public static function InvoicePaymentReminder($CompanyID,$ProcessID){

        $BillingClass = BillingClass::where('CompanyID',$CompanyID)->get();
        foreach($BillingClass as $BillingClassSingle) {
            if (isset($BillingClassSingle->InvoiceReminderStatus) && $BillingClassSingle->InvoiceReminderStatus == 1 && isset($BillingClassSingle->InvoiceReminderSettings)) {
                $settings = json_decode($BillingClassSingle->InvoiceReminderSettings, true);
                $settings['EmailType'] = AccountEmailLog::InvoicePaymentReminder;
                $settings['ProcessID'] = $ProcessID;
                $query = "CALL prc_getDueInvoice(?,?,?)";
                $Invoices = DB::connection('sqlsrv2')->select($query, array($CompanyID, 0, $BillingClassSingle->BillingClassID));
                foreach ($Invoices as $Invoice) {
                    if (Account::getAccountEmailCount($Invoice->AccountID, AccountEmailLog::InvoicePaymentReminder) == 0) {
                        $settings['InvoiceNumber'] = $Invoice->InvoiceNumber;
                        $settings['InvoiceGrandTotal'] = number_format($Invoice->GrandTotal,Helper::get_round_decimal_places($CompanyID,$Invoice->AccountID));
                        $settings['InvoiceOutstanding'] = number_format($Invoice->InvoiceOutStanding,Helper::get_round_decimal_places($CompanyID,$Invoice->AccountID));
                        $today = date('Y-m-d');
                        $getdaysdiff = getdaysdiff($today,$Invoice->AccountCreationDate);
                        $foundkey = array_search($Invoice->DueDay, $settings['Day']);
                        if ($foundkey !== false && check_account_age($settings,$foundkey,$getdaysdiff)) {
                            NeonAlert::SendReminder($CompanyID, $settings, $settings['TemplateID'][$foundkey], $Invoice->AccountID);
                        }
                    }
                }
            }
        }
    }
    public static function AccountPaymentReminder($CompanyID,$ProcessID){
        $BillingClass = BillingClass::where('CompanyID', $CompanyID)->get();
        foreach ($BillingClass as $BillingClassSingle) {
            if (isset($BillingClassSingle->PaymentReminderStatus) && $BillingClassSingle->PaymentReminderStatus == 1 && isset($BillingClassSingle->PaymentReminderSettings)) {
                $settings = json_decode($BillingClassSingle->PaymentReminderSettings, true);
                $settings['ProcessID'] = $ProcessID;
                if (cal_next_runtime($settings) == date('Y-m-d H:i:00')) {
                    $query = "CALL prc_AccountPaymentReminder(?,?,?)";
                    $Invoices = DB::select($query, array($CompanyID, 0, $BillingClassSingle->BillingClassID));
                    foreach ($Invoices as $Invoice) {
                        NeonAlert::SendReminder($CompanyID, $settings, $settings['TemplateID'], $Invoice->AccountID);
                    }
                    NeonAlert::UpdateNextRunTime($BillingClassSingle->BillingClassID, 'PaymentReminderSettings','BillingClass');
                }
            }
        }
    }

} 