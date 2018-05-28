<?php

namespace App\Lib;

use App\PBX;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class AccountBalance extends Model
{
    //
    protected $guarded = array("AccountBalanceID");

    protected $table = 'tblAccountBalance';

    protected $primaryKey = "AccountBalanceID";

    public $timestamps = false; // no created_at and updated_at

    const BILLINGTYPE_PREPAID = 1;
    const BILLINGTYPE_POSTPAID = 2;
    const BILLINGTYPE_BOTH = 3;


    public static function LowBalanceReminder($CompanyID,$ProcessID){

        $BillingClass = BillingClass::where('CompanyID',$CompanyID)->get();
        foreach($BillingClass as $BillingClassSingle) {
            if (isset($BillingClassSingle->LowBalanceReminderStatus) && $BillingClassSingle->LowBalanceReminderStatus == 1 && isset($BillingClassSingle->LowBalanceReminderSettings)) {
                $settings = json_decode($BillingClassSingle->LowBalanceReminderSettings, true);
                $settings['ProcessID'] = $ProcessID;
                $settings['EmailType'] = AccountEmailLog::LowBalanceReminder;
                $LastRunTime = isset($settings['LastRunTime'])?$settings['LastRunTime']:'';
                $query = "CALL prc_LowBalanceReminder(?,?,?)";
                $AccountBalanceWarnings = DB::select($query, array($CompanyID, 0,$BillingClassSingle->BillingClassID));
                foreach ($AccountBalanceWarnings as $AccountBalanceWarning) {
                    if ($AccountBalanceWarning->BalanceWarning == 1 &&(Account::FirstLowBalanceReminder($AccountBalanceWarning->AccountID,$LastRunTime) == 0 || cal_next_runtime($settings) == date('Y-m-d H:i:00'))) {
                        Log::info('AccountID = '.$AccountBalanceWarning->AccountID.' SendReminder sent ');
                        NeonAlert::SendReminder($CompanyID, $settings, $settings['TemplateID'], $AccountBalanceWarning->AccountID);
                    }
                }
                if(cal_next_runtime($settings) == date('Y-m-d H:i:00')){
                    NeonAlert::UpdateNextRunTime($BillingClassSingle->BillingClassID,'LowBalanceReminderSettings','BillingClass');
                }
            }
        }
    }

    public static function updateAccountUnbilledAmount($CompanyID){
        $today = date('Y-m-d 23:59:59');
        DB::connection('neon_report')->select("CALL prc_updateUnbilledAmount(?,?)",array($CompanyID,$today));
    }

    public static function getBalanceAmount($AccountID){
        return AccountBalance::where(['AccountID'=>$AccountID])->pluck('BalanceAmount');
    }
    public static function getBalanceThreshold($AccountID){
        return str_replace('p', '%',AccountBalance::where(['AccountID'=>$AccountID])->pluck('BalanceThreshold'));
    }
    public static function getOutstandingAmount($CompanyID,$AccountID){
        DB::connection('sqlsrv2')->statement('CALL prc_updateSOAOffSet(?,?)',array($CompanyID,$AccountID));
        return AccountBalance::where(['AccountID'=>$AccountID])->pluck('SOAOffset');
    }

    /** blocking account by gateway */
    public static function PBXBlockUnBlockAccount($CompanyID,$GatewayID,$ProcessID){
        $email_message  = array();
        $error_message  = array();
        $BlockingGateways = CompanyGateway::where(array('CompanyID'=>$CompanyID,'GatewayID'=>$GatewayID,'Status'=>1))->get();
        foreach ($BlockingGateways as $BlockingGateway) {
            $pbx = new PBX($BlockingGateway->CompanyGatewayID);
            $BlockingAccounts = DB::select('CALL prc_GetBlockUnblockAccount(?,?)', array($CompanyID, $BlockingGateway->CompanyGatewayID));
            foreach ($BlockingAccounts as $BlockingAccount) {
                $param['te_code'] = $BlockingAccount->Number;

                if($BlockingAccount->Balance > 0) {
                    $response = $pbx->blockAccount($param);
                    if(isset($response['message']) && $response['message'] == 'account blocked'){
                        $email_message[$BlockingAccount->AccountName] = 'Blocked';
                    }
                    if(isset($response['faultCode'])){
                        $error_message =  $response;
                    }
                    if($BlockingAccount->Blocked == 0) {
                        Account::where('AccountID', $BlockingAccount->AccountID)->update(array('Blocked' => 1));
                    }
                }else{
                    $response =  $pbx->unBlockAccount($param);
                    if(isset($response['message']) && $response['message'] == 'account unblocked'){
                        $email_message[$BlockingAccount->AccountName] = 'Unblocked';
                    }
                    if(isset($response['faultCode'])){
                        $error_message =  $response;
                    }
                    if($BlockingAccount->Blocked == 1) {
                        Account::where('AccountID', $BlockingAccount->AccountID)->update(array('Blocked' => 0));
                    }
                }

            }

        }

        $notification_email = Notification::getNotificationMail(['CompanyID' => $CompanyID, 'NotificationType' => Notification::BlockAccount]);
        $Company = Company::find($CompanyID);
        if (!empty($notification_email) && !empty($email_message)) {
            Log::info($notification_email . ' block email sent ');
            $emaildata = array(
                'EmailToName' => $Company->CompanyName,
                'Subject' => 'Account Status Changed',
                'CompanyID' => $CompanyID,
                'CompanyName' => $Company->CompanyName,
                'Message' => $email_message
            );
            $emaildata['EmailTo'] = $notification_email;

            $status = Helper::sendMail('emails.account_block', $emaildata);
            $statuslog = Helper::account_email_log($CompanyID, 0, $emaildata, $status, '', $ProcessID, 0, Notification::BlockAccount);
        }
        return $error_message;
    }

    public static function AutoPayInvoice($data){
        $response = array();
        $CompanyID = $data['CompanyID'];
        $AccountID = $data['AccountID'];
        $Amount = $data['GrandTotal'];
        $AccountOutstandingBalance = AccountBalance::getAccountSOA($CompanyID,$AccountID);
        $CheckAccountBalance = AccountBalance::CheckAccountBalance($AccountID,$AccountOutstandingBalance,$Amount);

        if(isset($CheckAccountBalance) && $CheckAccountBalance==1){
            $response['response_code'] = 1;
            $response['status'] = 'Success';
            $response['id'] = '1';
            $response['note'] = 'Account Balance Payment Success';
            $response['amount'] = $Amount;
            $response['response'] = array();
        }else{
            $response['status'] = 'fail';
            $response['error'] = 'Account has not sufficient balance';
        }

        return $response;

    }

    public static function getAccountSOA($CompanyID,$AccountID){
        $query = "call prc_getSOA (" . $CompanyID . "," . $AccountID . ",'','',0)";
        $result = DataTableSql::of($query,'sqlsrv2')->getProcResult(array('InvoiceOutWithPaymentIn','InvoiceInWithPaymentOut','InvoiceOutAmountTotal','InvoiceOutDisputeAmountTotal','PaymentInAmountTotal','InvoiceInAmountTotal','InvoiceInDisputeAmountTotal','PaymentOutAmountTotal'));

        $InvoiceOutAmountTotal = $result['data']['InvoiceOutAmountTotal'];
        $PaymentInAmountTotal = $result['data']['PaymentInAmountTotal'];
        $InvoiceInAmountTotal = $result['data']['InvoiceInAmountTotal'];
        $PaymentOutAmountTotal = $result['data']['PaymentOutAmountTotal'];

        $InvoiceOutAmountTotal = ($InvoiceOutAmountTotal[0]->InvoiceOutAmountTotal <> 0) ? $InvoiceOutAmountTotal[0]->InvoiceOutAmountTotal : 0;
        $PaymentInAmountTotal = ($PaymentInAmountTotal[0]->PaymentInAmountTotal <> 0) ? $PaymentInAmountTotal[0]->PaymentInAmountTotal : 0;
        $InvoiceInAmountTotal = ($InvoiceInAmountTotal[0]->InvoiceInAmountTotal <> 0) ? $InvoiceInAmountTotal[0]->InvoiceInAmountTotal : 0;
        $PaymentOutAmountTotal = ($PaymentOutAmountTotal[0]->PaymentOutAmountTotal <> 0) ? $PaymentOutAmountTotal[0]->PaymentOutAmountTotal : 0;

        $OffsetBalance = ($InvoiceOutAmountTotal - $PaymentInAmountTotal) - ($InvoiceInAmountTotal - $PaymentOutAmountTotal);

        return $OffsetBalance;

    }

    public static function getAccountExposure($CompanyID,$AccountID){
        $AccountBalance = AccountBalance::where('AccountID', $AccountID)->first(['AccountID', 'PermanentCredit', 'UnbilledAmount','EmailToCustomer', 'TemporaryCredit', 'TemporaryCreditDateTime', 'BalanceThreshold','BalanceAmount','VendorUnbilledAmount']);
        $UnbilledAmount = $AccountBalance->UnbilledAmount;
        $VendorUnbilledAmount = $AccountBalance->VendorUnbilledAmount;
        $SOA_Amount = AccountBalance::getAccountSOA($CompanyID,$AccountID);
        $BalanceAmount = $SOA_Amount+($UnbilledAmount-$VendorUnbilledAmount);

        return $BalanceAmount;
    }

    public static function CheckAccountBalance($AccountID,$AccountOutstandingBalance,$Amount){
        $SufficentBalance=0;
        $BillingType = AccountBilling::where(['AccountID'=>$AccountID,'ServiceID'=>0])->pluck('BillingType');
        log::info('BillingType '.$BillingType);
        log::info('AccountOutstandingBalance '.$AccountOutstandingBalance);
        log::info('Amount '.$Amount);
        if(isset($BillingType)){
            if($BillingType==AccountBilling::BILLINGTYPE_PREPAID){
                if($AccountOutstandingBalance<0){
                    $AccountOutstandingBalance=abs($AccountOutstandingBalance);
                }else{
                    $AccountOutstandingBalance=($AccountOutstandingBalance) * -1;
                }
                //before it is amount
                if($AccountOutstandingBalance>0){
                    $SufficentBalance=1;
                }
            }else{
                if($AccountOutstandingBalance<0){
                    $AccountOutstandingBalance=abs($AccountOutstandingBalance);
                    //before it is amount
                    if($AccountOutstandingBalance>0){
                        $SufficentBalance=1;
                    }
                }
            }
        }
        log::info('New AccountOutstandingBalance '.$AccountOutstandingBalance);
        return $SufficentBalance;
    }

    /**
     * Send Email - if(AccountBalance > Next Invoice Generate required balance)
     * first email goes to date reminder date and other will go through interval wise
    */
    public static function SendBalanceWarning($CompanyID,$ProcessID){
        $BillingClass = BillingClass::where('CompanyID',$CompanyID)->get();
        foreach($BillingClass as $BillingClassSingle) {
            if(isset($BillingClassSingle->BalanceWarningStatus) && $BillingClassSingle->BalanceWarningStatus == 1 && isset($BillingClassSingle->BalanceWarningStatus)){
                $settings = json_decode($BillingClassSingle->BalanceWarningSettings, true);
                $BillingClassID = $BillingClassSingle->BillingClassID;
                log::info('BillingClassID '.$BillingClassID);
                $settings['ProcessID'] = $ProcessID;
                $settings['EmailType'] = AccountEmailLog::BalanceWarning;
                $settings['LastRunTime'] = isset($settings['LastRunTime'])?$settings['LastRunTime']:'';
                $LastRunTime = isset($settings['LastRunTime'])?$settings['LastRunTime']:'';
                if(!empty($settings['RenewalDays'])){
                    $RenewalDays = $settings['RenewalDays'];
                    $IncludeUnBilledAmount = empty($settings['IncludeUnBilledAmount']) ? 0 : $settings['IncludeUnBilledAmount'];
                    $InvoiceTemplateID=BillingClass::getInvoiceTemplateID($BillingClassID);
                    $InvoiceTemplate=InvoiceTemplate::find($InvoiceTemplateID);
                    $IgnoreCallCharge=$InvoiceTemplate->IgnoreCallCharge;

                    log::info('RenewalDays '.$RenewalDays);
                    log::info('IncludeUnBilledAmount '.$IncludeUnBilledAmount);
                    log::info('IgnoreCallCharge '.$IgnoreCallCharge);

                    $Accounts =   AccountBilling::join('tblAccount','tblAccount.AccountID','=','tblAccountBilling.AccountID')
                        ->select('tblAccountBilling.*','AccountName')
                        ->where(array('CompanyID'=>$CompanyID,'Status'=>1,'Billing'=>1,"AccountType"=>1,'BillingClassID'=>$BillingClassID))
                        ->get();

                    if(!empty($Accounts) && count($Accounts)>0)
                    {
                        foreach($Accounts as $account){
                            $AccountID=$account->AccountID;
                            if((Account::FirstBalanceWarning($AccountID,$LastRunTime) == 0 || cal_next_runtime($settings) == date('Y-m-d H:i:00'))) {
                                log::info('Account '.$account->AccountName);
                                $AccountBillingID=$account->AccountBillingID;
                                $BillingType=empty($account->BillingType)?'1':$account->BillingType;
                                $NextInvoiceDate=$account->NextInvoiceDate;
                                $CheckInvoiceDate =  date("Y-m-d", strtotime( "-".$RenewalDays." Day", strtotime($NextInvoiceDate)));
                                $Today = date("Y-m-d");
                                if($NextInvoiceDate >= $Today) {
                                    log::info('NextInvoiceDate ' . $NextInvoiceDate . ' - RenewalDate ' . $CheckInvoiceDate . ' - Today Date ' . $Today);
                                }
                                // check date - next invoice date = today or grater , renewal day = today or less today
                                if($NextInvoiceDate >= $Today && $Today >=$CheckInvoiceDate){
                                    $response = Invoice::getFutureInvoiceTotal($CompanyID,$AccountBillingID,0);
                                    $GrandTotal=$response['GrandTotal'];
                                    $SubTotal=$response['SubTotal'];
                                    $AccountBalance  = AccountBalance::getAccountBalance($CompanyID,$AccountID);
                                    $AccountExposure = AccountBalance::getAccountBalance($CompanyID,$AccountID);
                                    if($IncludeUnBilledAmount==1){
                                        $AccountOutstandingBalance = $AccountExposure;
                                    }else{
                                        $AccountOutstandingBalance = $AccountBalance;
                                    }
                                    log::info('AccountBalance '.$AccountOutstandingBalance);
                                    log::info('Next Invoice GrandTotal '.$GrandTotal);
                                    if($AccountOutstandingBalance <= $GrandTotal) {
                                        Log::info('AccountID = '.$AccountID.' SendReminder sent ');
                                        NeonAlert::SendReminder($CompanyID, $settings, $settings['TemplateID'], $AccountID);

                                    }
                                }
                            }
                        }//account loop over
                    }//empty account
                }// no renewal days
                if(cal_next_runtime($settings) == date('Y-m-d H:i:00')){
                    Log::info('next runtime update ');
                    NeonAlert::UpdateNextRunTime($BillingClassSingle->BillingClassID,'BalanceWarningSettings','BillingClass');
                }
            }
        }// billing class loop over
    }

    public static function getAccountBalance($CompanyID,$AccountID){
        $AccountBalance = AccountBalance::getAccountSOA($CompanyID,$AccountID);
        $BillingType = AccountBilling::where(['AccountID'=>$AccountID,'ServiceID'=>0])->pluck('BillingType');
        /**
         * If billing type postpaid it will display as it is
         */
        if(isset($BillingType)){
            if($BillingType==AccountBilling::BILLINGTYPE_PREPAID){
                if($AccountBalance<0){
                    $AccountBalance=abs($AccountBalance);
                }else{
                    $AccountBalance=($AccountBalance) * -1;
                }
            }
            /*
            else{
                if($AccountBalance<0){
                    $AccountBalance=0;
                }
            }*/
        }else{
            if($AccountBalance<0){
                $AccountBalance=0;
            }
        }
        return $AccountBalance;
    }

    public static function getAccountOutstandingBalance($CompanyID,$AccountID){
        $AccountOutstandingBalance = AccountBalance::getAccountExposure($CompanyID,$AccountID);
        $BillingType = AccountBilling::where(['AccountID'=>$AccountID,'ServiceID'=>0])->pluck('BillingType');
        if(isset($BillingType)){
            if($BillingType==AccountBilling::BILLINGTYPE_PREPAID){
                if($AccountOutstandingBalance<0){
                    $AccountOutstandingBalance=abs($AccountOutstandingBalance);
                }else{
                    $AccountOutstandingBalance=($AccountOutstandingBalance) * -1;
                }
            }
            /*
            else{
                if($AccountOutstandingBalance<0){
                    $AccountOutstandingBalance=0;
                }
            }*/
        }else{
            if($AccountOutstandingBalance<0){
                $AccountOutstandingBalance=0;
            }
        }
        return $AccountOutstandingBalance;
    }
}
