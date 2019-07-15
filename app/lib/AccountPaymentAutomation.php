<?php
namespace App\Lib;

use Illuminate\Support\Facades\Log;

class AccountPaymentAutomation extends \Eloquent
{
    //
    protected $guarded = array("AccountPaymentAutomationID");

    protected $table = 'tblAccountPaymentAutomation';

    protected $primaryKey = "AccountPaymentAutomationID";

    /**
     * this will call neon api and it will add top up and generate invoice
     */
    public static function calldepositFundAPI($AutoPaymentAccount, $CompanyConfiguration)
    {
        $url = $CompanyConfiguration;
        $DepositAccount = array();
        $postdata = array();
        $postdata['AccountID'] = $AutoPaymentAccount->AccountID;
        $postdata['Amount'] = $AutoPaymentAccount->TopupAmount;
        $postdata = json_encode($postdata, true);

        if (!NeonAPI::endsWith($CompanyConfiguration, "/")) {
            $url = $CompanyConfiguration . "/";
        }
        $APIresponse = NeonAPI::callAPI($postdata, "api/account/depositFund", $url, '', 10080);
        if (isset($APIresponse["error"])) {
            try {
                $response = json_decode($APIresponse["error"]);
                //Log::info(print_r($APIresponse["error"],true));
                $DepositAccount[0] = "failed";
                $DepositAccount[1] = $response->ErrorMessage;
            } catch (\Exception $e){
                $DepositAccount[0] = "failed";
                $DepositAccount[1] = "Error While Calling API";
            }
        } else {
            try {
                $response = json_decode($APIresponse["response"]);
                //Log::info("Succcess" . print_r($response, true));
                $responseCode = $APIresponse["HTTP_CODE"];
                if ($responseCode == 200) {
                    $DepositAccount[0] = "success";
                    $DepositAccount[1] = $response;
                } else {
                    $DepositAccount[0] = "failed";
                    $DepositAccount[1] = $response;

                }
            }catch (\Exception $e){
                $DepositAccount[0] = "failed";
                $DepositAccount[1] = "Error While Calling API";
            }

        }

        return $DepositAccount;
    }

    public static function AutoTopUpNotification($CompanyID, $SuccessDepositAccounts, $FailureDepositFundAccounts)
    {
        try {
            $emaildata = array();

            $CompanyName = Company::getName($CompanyID);

            $emaildata['SuccessDepositAccount'] = $SuccessDepositAccounts;
            $emaildata['FailureDepositFund'] = $FailureDepositFundAccounts;

            $AutoTopUpNotificationEmail = Notification::getNotificationMail(['CompanyID' => $CompanyID, 'NotificationType' => Notification::AutoTopAccount]);
            Log::info('$AutoTopUpNotificationEmail ..' . $AutoTopUpNotificationEmail);

            $result = false;
            if (!empty($AutoTopUpNotificationEmail)) {
                //Log::info('Sending email.' . $AutoTopUpNotificationEmail);
                $emaildata['CompanyID'] = $CompanyID;
                $emaildata['CompanyName'] = $CompanyName;
                $emaildata['EmailTo'] = $AutoTopUpNotificationEmail;
                $emaildata['EmailToName'] = '';
                $emaildata['Subject'] = 'Auto Top Up Notification Email';
                //$emaildata['Message'] = $Message;
                $result = Helper::sendMail('emails.auto_top_up_amount', $emaildata);
            }
            return $result;
        } catch (\Exception $e) {
            Log::error("**Email Sent Status AutoTopUpNotification" . $e->getTraceAsString());
        }
    }
}
