<?php
namespace App\Lib;

class AccountPaymentAutomation extends \Eloquent {
    //
    protected $guarded = array("AccountPaymentAutomationID");

    protected $table = 'tblAccountPaymentAutomation';

    protected $primaryKey = "AccountPaymentAutomationID";

    /**
     * this will call neon api and it will add top up and generate invoice
     */
    public static function calldepositFundAPI($AutoPaymentAccount,$CompanyConfiguration)
    {
        $url = $CompanyConfiguration;
        $DepositAccount = array();
        $postdata = array();
        $postdata['AccountID'] = $AutoPaymentAccount->AccountID;
        $postdata['Amount'] = $AutoPaymentAccount->TopupAmount;
        $postdata = json_encode($postdata,true);

        if (!NeonAPI::endsWith($CompanyConfiguration,"/")) {
            $url = $CompanyConfiguration . "/";
        }
        $APIresponse = NeonAPI::callAPI($postdata,"api/account/depositFund",$url);
        if (isset($APIresponse["error"])) {
            $DepositAccount['status'] = "failed";
            $DepositAccount['response'] = $APIresponse["error"];
        } else {
            $response = json_decode($APIresponse["response"]);
            if (isset($response->ErrorMessage)) {
                $DepositAccount['status'] = "failed";
                $DepositAccount['response'] = $response->ErrorMessage;
            } else {
                $DepositAccount['status'] = "success";
                $DepositAccount['response'] = $response;
            }
        }

        return $DepositAccount;
    }

    public static function AutoTopUpNotification($CompanyID,$SuccessDepositAccounts,$FailureDepositFundAccounts){

        $emaildata = array();

        $ComanyName = Company::getName($CompanyID);

        $emaildata['SuccessDepositAccount'] = $SuccessDepositAccounts;
        $emaildata['FailureDepositFund'] = $FailureDepositFundAccounts;

        $AutoTopUpNotificationEmail = Notification::getNotificationMail(['CompanyID' => $CompanyID, 'NotificationType' => Notification::AutoTopAccount]);
        if (!empty($AutoTopUpNotificationEmail)){
            $emaildata['CompanyID'] = $CompanyID;
            $emaildata['CompanyName'] = $ComanyName;
            $emaildata['EmailTo'] = $AutoTopUpNotificationEmail;
            $emaildata['EmailToName'] = '';
            $emaildata['Subject'] = 'Auto Top Up Notification Email';
            //$emaildata['Message'] = $Message;
            $result = Helper::sendMail('emails.auto_top_up_amount', $emaildata);
        }
    }
}
