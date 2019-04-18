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
                Log::info("CALL prc_getDueInvoice($CompanyID,0,$BillingClassSingle->BillingClassID)");
                foreach ($Invoices as $Invoice) {
                    if (Account::getAccountEmailCount($Invoice->AccountID, AccountEmailLog::InvoicePaymentReminder) == 0) {
                        $settings['InvoiceNumber'] = $Invoice->InvoiceNumber;
                        $settings['InvoiceGrandTotal'] = number_format($Invoice->GrandTotal,Helper::get_round_decimal_places($CompanyID,$Invoice->AccountID));
                        $settings['InvoiceOutstanding'] = number_format($Invoice->InvoiceOutStanding,Helper::get_round_decimal_places($CompanyID,$Invoice->AccountID));
                        $settings['InvoiceID'] = $Invoice->InvoiceID;
                        $today = date('Y-m-d');
                        $getdaysdiff = getdaysdiff($today,$Invoice->AccountCreationDate);
                        $foundkey = array_search($Invoice->DueDay, $settings['Day']);
                         //Log::info($Invoice->DueDay.', '.$settings['Day']);
                        Log::info('check key '.$foundkey);
                        $default_lang_id = Translation::$default_lang_id;
                        $LanguageID = Account::getLanguageIDbyAccountID($Invoice->AccountID);
                        if ($foundkey !== false && check_account_age($settings,$foundkey,$getdaysdiff)) {
                            Log::info("start sending invoice reminder");
                            Log::info(json_encode($settings));
                            Log::info("billing class id ".$BillingClassSingle->BillingClassID);
                            //$LanguageID = Account::getLanguageIDbyAccountID($Invoice->AccountID);
                            //$EmailTemplateID = EmailTemplate::getSystemEmailTemplate($CompanyID, "InvoicePaymentReminder1", $LanguageID);
                            Log::info("slug ".$settings['TemplateID'][$foundkey]);
                            $EmailTemplateID = EmailTemplate::getSystemEmailTemplateID($CompanyID, $settings['TemplateID'][$foundkey],$LanguageID);
                            if(!empty($EmailTemplateID)){
                                NeonAlert::SendReminder($CompanyID, $settings, $EmailTemplateID->TemplateID, $Invoice->AccountID);
                            }
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
                    Log::info("CALL prc_AccountPaymentReminder($CompanyID,0,$BillingClassSingle->BillingClassID)");
                    $Invoices = DB::select($query, array($CompanyID, 0, $BillingClassSingle->BillingClassID));
                    Log::info(json_encode($Invoices));
                    foreach ($Invoices as $Invoice) {
                        $default_lang_id=Translation::$default_lang_id;
                        $LanguageID = Account::getLanguageIDbyAccountID($Invoice->AccountID);
                        //$LanguageID = Account::getLanguageIDbyAccountID($Invoice->AccountID);
                        //$EmailTemplateID = EmailTemplate::getSystemEmailTemplate($CompanyID, "AccountPaymentReminder", $LanguageID);
                        $EmailTemplateID = EmailTemplate::getSystemEmailTemplateID($CompanyID, "AccountPaymentReminder",$LanguageID);
                        if(!empty($EmailTemplateID)){
                            NeonAlert::SendReminder($CompanyID, $settings, $EmailTemplateID->TemplateID, $Invoice->AccountID);
                        }
                    }
                    NeonAlert::UpdateNextRunTime($BillingClassSingle->BillingClassID, 'PaymentReminderSettings','BillingClass');
                }
            }
        }
    }

    public static function GetBillingPeriodPayments($InvoiceID,$AccountID){
        $PaymentData=array();
        $InvoiceDetail=InvoiceDetail::where(['InvoiceID'=>$InvoiceID,'ProductType'=>Product::FIRST_PERIOD])->first();
        if(empty($InvoiceDetail)){
            $InvoiceDetail=InvoiceDetail::where(['InvoiceID'=>$InvoiceID,'ProductType'=>Product::USAGE])->first();
        }
        if(!empty($InvoiceDetail)){
            $StartDate=$InvoiceDetail->StartDate;
            $EndDate=$InvoiceDetail->EndDate;
            if(!empty($StartDate) && !empty($EndDate)){
                $EndDate=$InvoiceDetail->EndDate;
                $EndDate =  date("Y-m-d 00:00:00", strtotime( "+1 Day", strtotime($EndDate)));

                $Payments=Payment::whereBetween('PaymentDate', [$StartDate, $EndDate])->where(['PaymentType'=>'Payment In','Recall'=>0,'AccountID'=>$AccountID])->orderBy('PaymentDate', 'desc')->get();
                if(!empty($Payments) && count($Payments)>0){
                    foreach($Payments as $payment){
                        $temp=array();
                        $temp['PaymentDate']=$payment->PaymentDate;
                        $temp['Amount']=$payment->Amount;
                        $temp['Notes']=$payment->Notes;
                        $temp['PaymentMethod']=$payment->PaymentMethod;
                        $PaymentData[]=$temp;
                    }
                }
            }
        }
        return $PaymentData;
    }

} 