<?php
namespace App\Lib;

use Illuminate\Support\Facades\Log;

class NeonAlert extends \Eloquent {

    public static function neon_alerts($CompanyID,$ProcessID){
        $cronjobdata = array();
        Log::info('============== LowBalanceReminder START===========');
        try {
            $cronjobdata = AccountBalance::LowBalanceReminder($CompanyID,$ProcessID);
        } catch (\Exception $e) {
            Log::error($e);
            $cronjobdata[] = 'Low Balance Reminder Failed';
        }
        Log::info('============== LowBalanceReminder END ===========');
        Log::info('============== InvoicePaymentReminder START===========');
        try {
            $cronjobdata = Payment::InvoicePaymentReminder($CompanyID,$ProcessID);
        } catch (\Exception $e) {
            Log::error($e);
            $cronjobdata[] = 'Payment Reminder Failed';
        }
        Log::info('============== InvoicePaymentReminder END ===========');
        Log::info('============== AccountPaymentReminder START===========');
        try {
            $cronjobdata = Payment::AccountPaymentReminder($CompanyID,$ProcessID);
        } catch (\Exception $e) {
            Log::error($e);
            $cronjobdata[] = 'Payment Reminder Failed';
        }
        Log::info('============== AccountPaymentReminder END===========');

        Log::info('============== ACD/ASR alert START===========');
        try {
            Alert::asr_acd_alert($CompanyID,$ProcessID);
        } catch (\Exception $e) {
            Log::error($e);
            $cronjobdata[] = 'ACD/ASR alert failed';
        }
        Log::info('============== ACD/ASR alert END===========');

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
        $EmailType = 0;
        if(isset($settings['EmailType']) && $settings['EmailType']>0){
            $EmailType = $settings['EmailType'];
        }

        $EmailTemplate = EmailTemplate::find($TemplateID);
        if (!empty($EmailTemplate)) {
            $EmailSubject = $EmailTemplate->Subject;
            $EmailMessage = $EmailTemplate->TemplateBody;
            $replace_array = Helper::create_replace_array($Account,$settings);
            $EmailMessage = template_var_replace($EmailMessage,$replace_array);
            $emaildata = array(
                'EmailToName' => $Company->CompanyName,
                'Subject' => $EmailSubject . " (" . $Account->AccountName . ")",
                'CompanyID' => $CompanyID,
                'CompanyName' => $Company->CompanyName,
                'Message' => $EmailMessage
            );
            if(!empty($settings['ReminderEmail'])) {
                $emaildata['EmailTo'] = explode(",", $settings['ReminderEmail']);
                $status = Helper::sendMail($email_view, $emaildata);
                Helper::account_email_log($CompanyID, $AccountID, $emaildata, $status, '', $settings['ProcessID'],0,$EmailType);
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
                        $statuslog = Helper::account_email_log($CompanyID, $AccountID, $emaildata, $customeremail_status, '', $settings['ProcessID'],0,$EmailType);
                    }
                }
            }
        }

    }
    public static function SendReminderToEmail($CompanyID,$AlertID,$settings){
        $Company = Company::find($CompanyID);
        $email_view = 'emails.template';
        if (isset($settings['email_view']) && $settings['email_view'] > 0) {
            $email_view = $settings['email_view'];
        }
        $EmailType = 0;
        if (isset($settings['EmailType']) && $settings['EmailType'] > 0) {
            $EmailType = $settings['EmailType'];
        }
        $emaildata = array(
            'EmailToName' => $Company->CompanyName,
            'Subject' => $settings['Subject'],
            'CompanyID' => $CompanyID,
            'CompanyName' => $Company->CompanyName,
            'Message' => $settings['EmailMessag']
        );
        if (!empty($settings['ReminderEmail'])) {
            Log::info('AccountID = '.$settings['ReminderEmail'].' SendReminder sent ');
            $emaildata['EmailTo'] = explode(",", $settings['ReminderEmail']);
            $status = Helper::sendMail($email_view, $emaildata);
            $statuslog = Helper::account_email_log($CompanyID, 0, $emaildata, $status, '', $settings['ProcessID'], 0, $EmailType);
            if($statuslog['status'] == 1 && $status['status'] == 1) {
                Helper::alert_email_log($AlertID, $statuslog['AccountEmailLog']->AccountEmailLogID);
            }
        }
    }

    public  static function UpdateNextRunTime($ClassID,$setting_name,$ClassName){
        if($ClassName == 'Alert'){
            $Class = Alert::find($ClassID);
        }else if($ClassName == 'BillingClass'){
            $Class = BillingClass::find($ClassID);
        }
        $settings = json_decode($Class->$setting_name, true);
        $settings['LastRunTime'] = date('Y-m-d H:i:00');
        $settings['NextRunTime'] = next_run_time($settings);
        $Class->$setting_name = json_encode($settings);
        $Class->update();
    }


}