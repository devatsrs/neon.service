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
                    'Subject' => $EmailSubject,
                    'CompanyID' => $CompanyID,
                    'CompanyName'=>$Company->CompanyName,
                    'Message' =>template_var_replace($EmailMessage,$replace_array)
                );
                $status = Helper::sendMail('emails.account_balance_threshold',$emaildata);


                if(getenv('EmailToCustomer') == 1){
                    $CustomerEmail = $AccountBalanceWarning->BillingEmail;
                }else{
                    $CustomerEmail = Company::getEmail($CompanyID);;
                }
                $CustomerEmail = explode(",",$CustomerEmail);
                $customeremail_status['status'] = 0;
                $customeremail_status['message'] = '';
                $customeremail_status['body'] = '';
                $UserID = User::getMinUserID($CompanyID);
                $User = User::getUserInfo($UserID);
                foreach($CustomerEmail as $singleemail){
                    if (filter_var($singleemail, FILTER_VALIDATE_EMAIL)) {
                        $emaildata['EmailTo'] = $singleemail;
                        $customeremail_status = Helper::sendMail('emails.account_balance_threshold', $emaildata);

                    }
                    if ($customeremail_status['status'] == 0) {
                        $cronjobdata['JobStatusMessage'] = 'Failed sending email to ' . $AccountBalanceWarning->AccountName .' ('.$singleemail.')';
                    } else {
                        $logData = ['AccountID'=>$AccountBalanceWarning->AccountID,
                            'ProcessID'=>$ProcessID,
                            'JobID'=>0,
                            'User'=>$User,
                            'EmailType'=>AccountEmailLog::LowBalance,
                            'EmailFrom'=>$User->EmailAddress,
                            'EmailTo'=>$emaildata['EmailTo'],
                            'Subject'=>$emaildata['Subject'],
                            'Message'=>$customeremail_status['body']];
                        $statuslog = Helper::email_log($logData);
                        $cronjobdata['JobStatusMessage'] = 'Email sent successfully to ' . $AccountBalanceWarning->AccountName.' ('.$singleemail.')';
                    }
                }

            }
        }
        return $cronjobdata;
    }

    public static function AccountBalanceUpdates($CompanyID){
        $AccountBalances = AccountBalance::join('tblAccount','tblAccount.AccountID','=','tblAccountBalance.AccountID')->where(array('CompanyID'=>$CompanyID))->get(array('tblAccount.AccountID'));
        foreach($AccountBalances as $AccountBalance){
            self::setAccountBalance($CompanyID,$AccountBalance->AccountID);
            //self::setAccountUsedCredits($CompanyID,$AccountBalance->AccountID);
        }
    }

    public static function getUnbilledAmount($CompanyID,$AccountID){
        $Amount = 0;
        $LastInvoiceDate = Invoice::getLastInvoiceDate($CompanyID, $AccountID);
        if(!empty($LastInvoiceDate)){
            $UnbilledAmount = DB::connection('sqlsrv2')->select("CALL prc_getUnbilledAmount(?,?,?)",array($CompanyID,$AccountID,$LastInvoiceDate));
            $Amount = $UnbilledAmount[0]->FinalAmount;
        }
        return $Amount;
    }

    public static function setAccountUsedCredits($CompanyID,$AccountID){
        $Amount = self::getUnbilledAmount($CompanyID,$AccountID);
        AccountBalance::where(array('AccountID'=>$AccountID))->update(array('CreditUsed'=>$Amount));
    }

    public static function getAccountBalance($CompanyID,$AccountID){
        $query = "call prc_getSOA (" . $CompanyID . "," . $AccountID . ",'','',0)";
        $result = DataTableSql::of($query,'sqlsrv2')->getProcResult(array('InvoiceOut','PaymentIn','InvoiceIn','PaymentOut','InvoiceOutAmountTotal','InvoiceOutDisputeAmountTotal','PaymentInAmountTotal','InvoiceInAmountTotal','InvoiceInDisputeAmountTotal','PaymentOutAmountTotal'));

        $InvoiceOutAmountTotal = $result['data']['InvoiceOutAmountTotal'];
        $PaymentInAmountTotal = $result['data']['PaymentInAmountTotal'];
        $InvoiceInAmountTotal = $result['data']['InvoiceInAmountTotal'];
        $PaymentOutAmountTotal = $result['data']['PaymentOutAmountTotal'];

        $InvoiceOutAmountTotal = ($InvoiceOutAmountTotal[0]->InvoiceOutAmountTotal > 0) ? $InvoiceOutAmountTotal[0]->InvoiceOutAmountTotal : 0;
        $PaymentInAmountTotal = ($PaymentInAmountTotal[0]->PaymentInAmountTotal > 0) ? $PaymentInAmountTotal[0]->PaymentInAmountTotal : 0;
        $InvoiceInAmountTotal = ($InvoiceInAmountTotal[0]->InvoiceInAmountTotal > 0) ? $InvoiceInAmountTotal[0]->InvoiceInAmountTotal : 0;
        $PaymentOutAmountTotal = ($PaymentOutAmountTotal[0]->PaymentOutAmountTotal > 0) ? $PaymentOutAmountTotal[0]->PaymentOutAmountTotal : 0;

        $OffsetBalance = ($InvoiceOutAmountTotal - $PaymentInAmountTotal) - ($InvoiceInAmountTotal - $PaymentOutAmountTotal);

        return $OffsetBalance;


    }

    public static function setAccountBalance($CompanyID,$AccountID){
        $OffsetBalance = self::getAccountBalance($CompanyID,$AccountID);
        $Amount = self::getUnbilledAmount($CompanyID,$AccountID);
        AccountBalance::where(array('AccountID'=>$AccountID))->update(array('BalanceAmount'=>($OffsetBalance+$Amount)));
        AccountBalance::where(array('AccountID'=>$AccountID))->update(array('CreditUsed'=>$Amount));
    }


}
