<?php
namespace App\Lib;

use Illuminate\Support\Facades\Log;

class NeonAlert extends \Eloquent {

    public static function neon_alerts($CompanyID,$ProcessID){
        $cronjobdata = array();
        try {
            $cronjobdata = AccountBalance::LowBalanceReminder($CompanyID,$ProcessID);
        } catch (\Exception $e) {
            Log::error($e);
            $cronjobdata[] = 'Low Balance Reminder Failed';
        }

        try {
            $cronjobdata = Payment::PaymentReminder($CompanyID,$ProcessID);
        } catch (\Exception $e) {
            Log::error($e);
            $cronjobdata[] = 'Payment Reminder Failed';
        }

        return $cronjobdata;
    }

    public static function SendReminder($CompanyID,$settings,$TemplateID,$AccountID){
        $Company = Company::find($CompanyID);
        $email_view = 'emails.template';
        $Account = Account::find($AccountID);
        $AccountManagerEmail = Account::getAccountOwnerEmail($Account);
        if (isset($settings['AccountManager']) && $settings['AccountManager'] == 1 && !empty($AccountManagerEmail)) {
            $settings['ReminderEmail'] .= ',' . $AccountManagerEmail;
        }
        $EmailTemplate = EmailTemplate::find($TemplateID);
        if (!empty($EmailTemplate)) {
            $EmailSubject = $EmailTemplate->Subject;
            $EmailMessage = $EmailTemplate->TemplateBody;
            $replace_array = Helper::create_replace_array($Account,$settings);
            $EmailMessage = template_var_replace($EmailMessage,$replace_array);

            if(empty($settings['ReminderEmail'])) {
                $emaildata = array(
                    'EmailTo' => explode(",", $settings['ReminderEmail']),
                    'EmailToName' => $Company->CompanyName,
                    'Subject' => $EmailSubject . " (" . $Account->AccountName . ")",
                    'CompanyID' => $CompanyID,
                    'CompanyName' => $Company->CompanyName,
                    'Message' => $EmailMessage
                );

                $status = Helper::sendMail($email_view, $emaildata);
            }

            $CustomerEmail = $Account->BillingEmail;
            $CustomerEmail = explode(",", $CustomerEmail);
            foreach ($CustomerEmail as $singleemail) {
                if (filter_var($singleemail, FILTER_VALIDATE_EMAIL)) {
                    $emaildata['EmailTo'] = $singleemail;
                    $customeremail_status = Helper::sendMail($email_view, $emaildata);
                    if ($customeremail_status['status'] == 0) {
                        $cronjobdata[] = 'Failed sending email to ' . $Account->AccountName . ' (' . $singleemail . ')';
                    } else {
                        $statuslog = Helper::account_email_log($CompanyID, $AccountID, $emaildata, $customeremail_status, '', $settings['ProcessID']);
                    }
                }
            }
        }

    }


}