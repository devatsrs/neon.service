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

    public static function SendBalanceThresoldEmail($CompanyID,$ProcessID,$cronsetting){
        $cronjobdata = array();
        $Company = Company::find($CompanyID);
        $EmailTemplate = EmailTemplate::find($cronsetting['TemplateID']);
        $EmailSubject = '';
        $EmailMessage = '';
        $replace_array = array();
        if (!empty($EmailTemplate)) {
            $EmailSubject =  $EmailTemplate->Subject;
            $EmailMessage = $EmailTemplate->TemplateBody;
        }
        $AccountBalanceWarnings = DB::select("CALL prc_GetAccountBalanceWarning('" . $CompanyID . "','0')");
        foreach($AccountBalanceWarnings as $AccountBalanceWarning){
            if($AccountBalanceWarning->BalanceWarning == 1 && Account::getAccountWarningEmailCount($AccountBalanceWarning->AccountID,$EmailSubject) == 0) {
                $Emails = isset($cronsetting['SuccessEmail']) ? $cronsetting['SuccessEmail'] : '';
                $AccountManagerEmail = Account::getAccountOwnerEmail($AccountBalanceWarning);
                if (empty($Emails) && !empty($AccountManagerEmail)) {
                    $Emails = $AccountManagerEmail;
                } else if (!empty($AccountManagerEmail)) {
                    $Emails .= ',' . $AccountManagerEmail;
                }
                $replace_array['BalanceAmount'] = $AccountBalanceWarning->BalanceAmount;
                $replace_array['BalanceThreshold'] = str_replace('p','%',$AccountBalanceWarning->BalanceThreshold);

                $emaildata = array(
                    'EmailTo' => explode(",", $Emails),
                    'EmailToName' => $Company->CompanyName,
                    'Subject' => $EmailSubject ." (".$AccountBalanceWarning->AccountName.")",
                    'CompanyID' => $CompanyID,
                    'CompanyName'=>$Company->CompanyName,
                    'Message' =>template_var_replace($EmailMessage,$replace_array)
                );
                $UserID = User::getMinUserID($CompanyID);
                $User = User::getUserInfo($UserID);
                $status = Helper::sendMail('emails.account_balance_threshold',$emaildata);
                if ($status['status'] == 1 && $AccountBalanceWarning->EmailToCustomer == 0) {
                    $logData = ['AccountID' => $AccountBalanceWarning->AccountID,
                        'ProcessID' => $ProcessID,
                        'JobID' => 0,
                        'User' => $User,
                        'EmailType' => AccountEmailLog::LowBalance,
                        'EmailFrom' => $User->EmailAddress,
                        'EmailTo' => $emaildata['EmailTo'],
                        'Subject' => $emaildata['Subject'],
                        'Message' => $status['body']];
                    $statuslog = Helper::email_log($logData);

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
                            $cronjobdata['JobStatusMessage'] = 'Failed sending email to ' . $AccountBalanceWarning->AccountName . ' (' . $singleemail . ')';
                        } else {
                            $logData = ['AccountID' => $AccountBalanceWarning->AccountID,
                                'ProcessID' => $ProcessID,
                                'JobID' => 0,
                                'User' => $User,
                                'EmailType' => AccountEmailLog::LowBalance,
                                'EmailFrom' => $User->EmailAddress,
                                'EmailTo' => $emaildata['EmailTo'],
                                'Subject' => $emaildata['Subject'],
                                'Message' => $customeremail_status['body']];
                            $statuslog = Helper::email_log($logData);
                            $cronjobdata['JobStatusMessage'] = 'Email sent successfully to ' . $AccountBalanceWarning->AccountName . ' (' . $singleemail . ')';
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
