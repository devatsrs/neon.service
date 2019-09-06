<?php
namespace App\Lib;

use Illuminate\Support\Facades\Log;

class NeonAlert extends \Eloquent {

    public static function neon_alerts($CompanyID,$ProcessID){
        $cronjobdata = array();

        Log::info('============== LowBalanceReminder START===========');
        try {
            AccountBalance::LowBalanceReminder($CompanyID,$ProcessID);
        } catch (\Exception $e) {
            Log::error($e);
            $cronjobdata[] = 'Low Balance Reminder of Company ' . $CompanyID . ' Failed';
        }
        Log::info('============== LowBalanceReminder END ===========');
        Log::info('============== Balance Warning START===========');
        try {
            AccountBalance::SendBalanceWarning($CompanyID,$ProcessID);
        } catch (\Exception $e) {
            Log::error($e);
            $cronjobdata[] = 'Balance Warning of Company ' . $CompanyID . ' Failed';
        }
        Log::info('============== Balance Warning END===========');
        Log::info('============== Zero Balance Warning START===========');
        try {
            AccountBalance::SendZeroBalanceWarning($CompanyID,$ProcessID);
        } catch (\Exception $e) {
            Log::error($e);
            $cronjobdata[] = 'Zero Balance Warning of Company ' . $CompanyID . ' Failed';
        }
        Log::info('============== Zero Balance Warning END===========');
        Log::info('============== InvoicePaymentReminder START===========');
        try {
            Payment::InvoicePaymentReminder($CompanyID,$ProcessID);
        } catch (\Exception $e) {
            Log::error($e);
            $cronjobdata[] = 'Payment Reminder of Company ' . $CompanyID . ' Failed';
        }
        Log::info('============== InvoicePaymentReminder END ===========');
        Log::info('============== AccountPaymentReminder START===========');
        try {
            Payment::AccountPaymentReminder($CompanyID,$ProcessID);
        } catch (\Exception $e) {
            Log::error($e);
            $cronjobdata[] = 'Payment Reminder of Company ' . $CompanyID . ' Failed';
        }
        Log::info('============== AccountPaymentReminder END===========');

        /*Log::info('============== ACD/ASR alert START===========');
        try {
            Alert::asr_acd_alert($CompanyID,$ProcessID);
        } catch (\Exception $e) {
            Log::error($e);
            $cronjobdata[] = 'ACD/ASR alert of Company ' . $CompanyID . ' failed';
        }
        Log::info('============== ACD/ASR alert END===========');

        Log::info('============== Vendor Balance alert START===========');
        try {
            Alert::VendorBalanceReport($CompanyID,$ProcessID);
        } catch (\Exception $e) {
            Log::error($e);
            $cronjobdata[] = 'Vendor Balance alert of Company ' . $CompanyID . ' failed';
        }
        Log::info('============== Vendor Balance alert END===========');*/

        Log::info('============== CDR Post Process START===========');
        try {
            TempUsageDetail::PostProcessCDR($CompanyID,$ProcessID);
        } catch (\Exception $e) {
            Log::error($e);
            $cronjobdata[] = 'Call Monitor of Company ' . $CompanyID . ' Failed';
        }
        Log::info('============== CDR Post Process END===========');

        Log::info('============== Report Schedule START===========');
        try {
            ReportSchedule::send_schedule_report($CompanyID);
        } catch (\Exception $e) {
            Log::error($e);
            $cronjobdata[] = 'Report Schedule of Company ' . $CompanyID . ' Failed';
        }
        Log::info('============== Report Schedule END===========');

        /*Log::info('============== Account Balance Email Reminder START===========');
        try {
            Alert::sendAccountBalanceEmailReminder($CompanyID);
        } catch (\Exception $e) {
            Log::error($e);
            $cronjobdata[] = 'Account Balance Email Reminder of Company ' . $CompanyID . ' Failed';
        }
        Log::info('============== Account Balance Email Reminder  END===========');
        Log::info('============== LowStockReminder alert START===========');
        try {
            Product::LowStockReminder($CompanyID,$ProcessID);
        } catch (\Exception $e) {
            Log::error($e);
            $cronjobdata[] = 'LowStockReminder alert of Company ' . $CompanyID . ' failed';
        }
        Log::info('============== LowStockReminder alert END===========');*/

        return $cronjobdata;
    }

    public static function SendReminder($CompanyID,$settings,$TemplateID,$AccountID,$AccountBalanceWarning=""){
        $Company = Company::find($CompanyID);
        $email_view = 'emails.template';
        $Account = Account::find($AccountID);
        
        $AccountManagerEmail = Account::getAccountOwnerEmail($Account);
        if (isset($settings['AccountManager']) && $settings['AccountManager'] == 1 && !empty($AccountManagerEmail)) {
            $settings['ReminderEmail'] .= ',' . $AccountManagerEmail;
        }
        
        if(isset($AccountBalanceWarning->BalanceThreshold) && !empty($AccountBalanceWarning)){
            $settings['BalanceThreshold'] = $AccountBalanceWarning->BalanceThreshold;
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
            
            $EmailSubject = template_var_replace($EmailSubject,$replace_array);
            $emaildata = array(
                'EmailToName' => $Company->CompanyName,
                'Subject' => $EmailSubject . " (" . $Account->AccountName . ")",
                'CompanyID' => $CompanyID,
                'CompanyName' => $Company->CompanyName,
                'Message' => $EmailMessage,

            );
            if(isset($settings['InvoiceNumber'])){
                $emaildata['InvoiceNo'] = $settings['InvoiceNumber'];
            }
            if(!empty($settings['ReminderEmail'])) {
                $emaildata['EmailTo'] = explode(",", $settings['ReminderEmail']);
                $status = Helper::sendMail($email_view, $emaildata);
                if($status['status'] == 1) {
                    Helper::account_email_log($CompanyID, $AccountID, $emaildata, $status, '', $settings['ProcessID'], 0, $EmailType);
                }
            }
            
            $haveEmail=0;
            //For Balance Threshold
            if(!empty($AccountBalanceWarning->BalanceThresholdEmail)){
                $BalanceThresholdEmail=$AccountBalanceWarning->BalanceThresholdEmail;
                $ThresholdEmail = $BalanceThresholdEmail;
                $ThresholdEmail = explode(",", $ThresholdEmail);
                foreach ($ThresholdEmail as $Thresholdsingleemail) {
                    $Thresholdsingleemail = trim($Thresholdsingleemail);
                    Log::info(' Thresholdsingleemail = '.$Thresholdsingleemail.' --------- ');
                    if (filter_var($Thresholdsingleemail, FILTER_VALIDATE_EMAIL)) {
                        $haveEmail=1;
                        $emaildata['EmailTo'] = $Thresholdsingleemail;
                        $customeremail_status = Helper::sendMail($email_view, $emaildata);
                        if ($customeremail_status['status'] == 0) {
                            $cronjobdata[] = 'Failed sending email to ' . $Account->AccountName . ' (' . $Thresholdsingleemail . ')';
                        } else {
                            $statuslog = Helper::account_email_log($CompanyID, $AccountID, $emaildata, $customeremail_status, '', $settings['ProcessID'],0,$EmailType);
                        }
                    }
                }
            }
            Log::info('haveEmail = '.$haveEmail.' --------- ');
            if($haveEmail==0){
                $CustomerEmail = $Account->BillingEmail;
                $CustomerEmail = explode(",", $CustomerEmail);
                foreach ($CustomerEmail as $singleemail) {
                    $singleemail = trim($singleemail);
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
            Log::info('End Email low balance:'.$haveEmail);
        }

    }
    public static function SendReminderToEmail($CompanyID,$AlertID,$AccountID,$settings){
        $Company = Company::find($CompanyID);
        $email_view = 'emails.template';

        $EmailType = 0;
        if (isset($settings['EmailType']) && $settings['EmailType'] > 0) {
            $EmailType = $settings['EmailType'];
        }
        $emaildata = array(
            'EmailToName' => $Company->CompanyName,
            'Subject' => $settings['Subject'],
            'CompanyID' => $CompanyID,
            'CompanyName' => $Company->CompanyName,
            'Message' => $settings['EmailMessage']
        );
        if (!empty($settings['ReminderEmail'])) {
            Log::info('AccountID = '.$AccountID.' email '.$settings['ReminderEmail'].' SendReminder sent ');
            $emaildata['EmailTo'] = explode(",", $settings['ReminderEmail']);
            $status = Helper::sendMail($email_view, $emaildata);
            if($status['status'] == 1) {
                $statuslog = Helper::account_email_log($CompanyID, $AccountID, $emaildata, $status, '', $settings['ProcessID'], 0, $EmailType);
                if ($statuslog['status'] == 1) {
                    Helper::alert_email_log($AlertID, $statuslog['AccountEmailLog']->AccountEmailLogID);
                }
            }
        }
    }

    public  static function UpdateNextRunTime($ClassID,$setting_name,$ClassName,$LastRunTime=''){
        if($ClassName == 'Alert'){
            $Class = Alert::find($ClassID);
        }else if($ClassName == 'BillingClass'){
            $Class = BillingClass::find($ClassID);
        }else if($ClassName == 'ReportSchedule'){
            $Class = ReportSchedule::find($ClassID);
        }
        $settings = json_decode($Class->$setting_name, true);
        if(!empty($LastRunTime)) {
            $settings['LastRunTime'] = $LastRunTime;
        }else{
            $settings['LastRunTime'] = date('Y-m-d H:i:00');
        }
        $settings['NextRunTime'] = next_run_time($settings);
        $Class->$setting_name = json_encode($settings);
        $Class->update();
    }


}