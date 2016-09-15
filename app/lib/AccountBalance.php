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

    public static function SendBalanceThresoldEmail($CompanyID,$ProcessID){
        $cronjobdata = array();
        $LowBalanceReminderEmail = Notification::getNotificationMail(['CompanyID'=>$CompanyID,'NotificationType'=>Notification::LowBalanceReminder]);
        if(!empty($LowBalanceReminderEmail)){
        $settings = Notification::getNotificationSettings(['CompanyID'=>$CompanyID,'NotificationType'=>Notification::LowBalanceReminder]);
        $settings = json_decode($settings,true);
        $Company = Company::find($CompanyID);
        $EmailTemplate = EmailTemplate::find($settings['TemplateID']);
        $EmailSubject = '';
        $EmailMessage = '';
        $replace_array = array();
        if (!empty($EmailTemplate)) {
            $EmailSubject =  $EmailTemplate->Subject;
            $EmailMessage = $EmailTemplate->TemplateBody;
        }
        $AccountBalanceWarnings = DB::select("CALL prc_GetAccountBalanceWarning('" . $CompanyID . "','0')");
        foreach($AccountBalanceWarnings as $AccountBalanceWarning){
            if($AccountBalanceWarning->BalanceWarning == 1 && Account::getAccountEmailCount($AccountBalanceWarning->AccountID,Notification::LowBalanceReminder) == 0) {
                $AccountManagerEmail = Account::getAccountOwnerEmail($AccountBalanceWarning);
                if(isset($settings['SendToAccountManager']) && $settings['SendToAccountManager'] == 1 && !empty($AccountManagerEmail)){
                    $LowBalanceReminderEmail .= ',' . $AccountManagerEmail;
                }
                $replace_array['BalanceAmount'] = $AccountBalanceWarning->BalanceAmount;
                $replace_array['BalanceThreshold'] = str_replace('p','%',$AccountBalanceWarning->BalanceThreshold);

                $emaildata = array(
                    'EmailTo' => explode(",", $LowBalanceReminderEmail),
                    'EmailToName' => $Company->CompanyName,
                    'Subject' => $EmailSubject ." (".$AccountBalanceWarning->AccountName.")",
                    'CompanyID' => $CompanyID,
                    'CompanyName'=>$Company->CompanyName,
                    'Message' =>template_var_replace($EmailMessage,$replace_array)
                );
                //$UserID = User::getMinUserID($CompanyID);
                //$User = User::getUserInfo($UserID);

                $status = Helper::sendMail('emails.account_balance_threshold',$emaildata);
                if ($status['status'] == 1 && $AccountBalanceWarning->EmailToCustomer == 0) {
                    $statuslog = Helper::account_email_log($CompanyID,$AccountBalanceWarning->AccountID,$emaildata,$status,'',$ProcessID);
                }

                if($AccountBalanceWarning->EmailToCustomer == 1) {
                    if (getenv('EmailToCustomer') == 1) {
                        $CustomerEmail = $AccountBalanceWarning->BillingEmail;
                    } else {
                        $CustomerEmail = Company::getEmail($CompanyID);;
                    }
                    $CustomerEmail = explode(",", $CustomerEmail);
                    $customeremail_status['status'] = 0;
                    $customeremail_status['message'] = '';
                    $customeremail_status['body'] = '';

                    foreach ($CustomerEmail as $singleemail) {
                        if (filter_var($singleemail, FILTER_VALIDATE_EMAIL)) {
                            $emaildata['EmailTo'] = $singleemail;
                            $customeremail_status = Helper::sendMail('emails.account_balance_threshold', $emaildata);

                        }
                        if ($customeremail_status['status'] == 0) {
                            $cronjobdata[] = 'Failed sending email to ' . $AccountBalanceWarning->AccountName . ' (' . $singleemail . ')';
                        } else {
                            $statuslog = Helper::account_email_log($CompanyID,$AccountBalanceWarning->AccountID,$emaildata,$customeremail_status,'',$ProcessID);
                        }
                    }
                }

            }
        }
        }
        return $cronjobdata;
    }

    public static function updateAccountUnbilledAmount($CompanyID){
        DB::connection('neon_report')->select("CALL prc_updateUnbilledAmount(?)",array($CompanyID));
    }

}
