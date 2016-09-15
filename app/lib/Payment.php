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
        $cronjobdata = array();
        $PaymentReminderEmail = Notification::getNotificationMail(['CompanyID'=>$CompanyID,'NotificationType'=>Notification::PaymentReminder]);
        if(!empty($PaymentReminderEmail)){
            $settings = Notification::getNotificationSettings(['CompanyID'=>$CompanyID,'NotificationType'=>Notification::PaymentReminder]);
            $settings = json_decode($settings,true);
            $settings['PaymentReminderEmail'] = $PaymentReminderEmail;
            $settings['ProcessID'] = $ProcessID;

            if($settings['InvoiceBase'] == Notification::INVOICE_BASE){
                self::InvoiceBaseReminder($CompanyID,$settings);
            }else if($settings['InvoiceBase'] == Notification::PAYMENT_BASE){
                self::PaymentBaseReminder($CompanyID);
            }

        }
        return $cronjobdata;
    }

    public static function InvoiceBaseReminder($CompanyID,$settings){

        $query = "CALL prc_getDueInvoice(?,?)";
        $Invoices = DB::connection('sqlsrv2')->select($query,array($CompanyID,0));
        $NotifyDueInvoice = array_map('intval', explode(',',$settings['NotifyDueInvoice']));
        $NotifyUnpaidInvoice = array_map('intval',explode(',',$settings['NotifyUnpaidInvoice']));
        $SuspendWarning = array_map('intval',explode(',',$settings['SuspendWarning']));
        $NotifyAccountClose = array_map('intval',explode(',',$settings['NotifyAccountClose']));
        foreach ($Invoices as $Invoice) {
            if(Account::getAccountEmailCount($Invoice->AccountID,Notification::PaymentReminder) == 0) {
                if (in_array($Invoice->DueDay, $NotifyDueInvoice)) {
                    self::SendPaymentReminder($CompanyID, $settings, $settings['DueInvoice'], $Invoice);
                } else if (in_array($Invoice->DueDay, $NotifyUnpaidInvoice)) {
                    self::SendPaymentReminder($CompanyID, $settings, $settings['UnpaidInvoice'], $Invoice);
                } else if (in_array($Invoice->DueDay, $SuspendWarning)) {
                    self::SendPaymentReminder($CompanyID, $settings, $settings['AccountCloseWarning'], $Invoice);
                } else if (in_array($Invoice->DueDay, $NotifyAccountClose)) {
                    self::SendPaymentReminder($CompanyID, $settings, $settings['AccountCloseSoon'], $Invoice);
                }
            }
        }
    }

    public static function PaymentBaseReminder($CompanyID,$settings){

    }

    public static function SendPaymentReminder($CompanyID,$settings,$TemplateID,$Invoice){
        $Company = Company::find($CompanyID);
        $EmailSubject = '';
        $EmailMessage = '';
        $email_view = 'emails.template';
        $AccountManagerEmail = Account::getAccountOwnerEmail($Invoice);
        if (isset($settings['SendToAccountManager']) && $settings['SendToAccountManager'] == 1 && !empty($AccountManagerEmail)) {
            $settings['PaymentReminderEmail'] .= ',' . $AccountManagerEmail;
        }

        $EmailTemplate = EmailTemplate::find($TemplateID);
        if (!empty($EmailTemplate)) {
            $EmailSubject = $EmailTemplate->Subject;
            $EmailMessage = $EmailTemplate->TemplateBody;
        }

        $emaildata = array(
            'EmailTo' => explode(",", $settings['PaymentReminderEmail']),
            'EmailToName' => $Company->CompanyName,
            'Subject' => $EmailSubject . " (" . $Invoice->AccountName . ")",
            'CompanyID' => $CompanyID,
            'CompanyName' => $Company->CompanyName,
            'Message' => $EmailMessage
        );

        $status = Helper::sendMail($email_view, $emaildata);

        if ($status['status'] == 1 && !in_array($Invoice->AccountID, $settings['AccountID'])) {
            $statuslog = Helper::account_email_log($CompanyID, $Invoice->AccountID, $emaildata, $status, '', $settings['ProcessID']);
        }
        if (in_array($Invoice->AccountID, $settings['AccountID'])) {

            $CustomerEmail = $Invoice->BillingEmail;
            $CustomerEmail = explode(",", $CustomerEmail);
            foreach ($CustomerEmail as $singleemail) {
                if (filter_var($singleemail, FILTER_VALIDATE_EMAIL)) {
                    $emaildata['EmailTo'] = $singleemail;
                    $customeremail_status = Helper::sendMail('emails.account_balance_threshold', $emaildata);
                    if ($customeremail_status['status'] == 0) {
                        $cronjobdata[] = 'Failed sending email to ' . $Invoice->AccountName . ' (' . $singleemail . ')';
                    } else {
                        $statuslog = Helper::account_email_log($CompanyID, $Invoice->AccountID, $emaildata, $customeremail_status, '', $settings['ProcessID']);
                    }
                }

            }
        }
    }

} 