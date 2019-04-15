<?php

namespace App\Lib;

use App\PBX;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Lib\AccountBalanceLog;

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


    /**
     * @param $CompanyID
     * @param $ProcessID
     */
    public static function LowBalanceReminder($CompanyID, $ProcessID){

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
                    if ($AccountBalanceWarning->BalanceWarning == 1 &&(Account::LowBalanceReminderEmailCheck($AccountBalanceWarning->AccountID,$AccountBalanceWarning->BalanceThresholdEmail,$LastRunTime) == 0 || cal_next_runtime($settings) == date('Y-m-d H:i:00'))) {
                        Log::info('AccountID = '.$AccountBalanceWarning->AccountID.' SendReminder sent ');
                        $LanguageID = Account::getLanguageIDbyAccountID($AccountBalanceWarning->AccountID);
                        
                        //------------------------------------------------------
                        $default_lang_id=Translation::$default_lang_id;
                        $querypro = "CALL prc_GetSystemEmailTemplate(?,?,?,?,?)";
                        $GetSystemEmailTemplate = DB::select($querypro, array($CompanyID, "LowBalanceReminder",$LanguageID,$AccountBalanceWarning->AccountID,$default_lang_id));
                        $TemplateID = $GetSystemEmailTemplate[0]->tID;
                        //------------------------------------------------------
                        Log::info('TemplateID = '.$GetSystemEmailTemplate[0]->tID.' --------- ');
                        Log::info('CompanyID = '.$CompanyID.' --------- ');
                        Log::info('AccountID = '.$AccountBalanceWarning->AccountID.' --------- '.$default_lang_id);
                        //$EmailTemplateID = EmailTemplate::getSystemEmailTemplate($CompanyID, "LowBalanceReminder", $LanguageID);

                        NeonAlert::SendReminder($CompanyID, $settings, $TemplateID, $AccountBalanceWarning->AccountID);
                        //NeonAlert::SendReminder($CompanyID, $settings, $settings['TemplateID'], $AccountBalanceWarning->AccountID);
                    }
                }
                if(cal_next_runtime($settings) == date('Y-m-d H:i:00')){
                    NeonAlert::UpdateNextRunTime($BillingClassSingle->BillingClassID,'LowBalanceReminderSettings','BillingClass');
                }
            }
        }
    }

    public static function SendZeroBalanceWarning($CompanyID, $ProcessID){

        $BillingClass = BillingClass::where('CompanyID',$CompanyID)->get();
        foreach($BillingClass as $BillingClassSingle) {
            if (isset($BillingClassSingle->ZeroBalanceWarningStatus) && $BillingClassSingle->ZeroBalanceWarningStatus == 1 && isset($BillingClassSingle->ZeroBalanceWarningStatus)) {
                $settings = json_decode($BillingClassSingle->ZeroBalanceWarningSettings, true);
                $settings['ProcessID'] = $ProcessID;
                $settings['EmailType'] = AccountEmailLog::ZeroBalanceWarning;
                $LastRunTime = isset($settings['LastRunTime'])?$settings['LastRunTime']:'';
                $query = "CALL prc_ZeroBalanceWarning(?,?,?)";
                $AccountZeroBalanceWarnings = DB::select($query, array($CompanyID, 0,$BillingClassSingle->BillingClassID));
                Log::info("CALL prc_ZeroBalanceWarning(".$CompanyID.",0,".$BillingClassSingle->BillingClassID.")");
                foreach ($AccountZeroBalanceWarnings as $AccountZeroBalanceWarning) {
                    /*$Account = Account::find($AccountZeroBalanceWarning->AccountID);
                    $emaildata = array(
                        'CompanyID' => $CompanyID,
                        'AccountID' => $AccountZeroBalanceWarning->AccountID,
                        'CountDown' => $AccountZeroBalanceWarning->CountDown
                    );*/
                    // EmailsTemplates::setZeroBalanceCountDownPlaceholder($Account, 'body', $CompanyID, $emaildata);
                    $CountDown = $settings['CountDown'];
                    $settings['CountDown'] = $AccountZeroBalanceWarning->CountDown;
                    if (isset($AccountZeroBalanceWarning->BalanceAmount) &&(Account::ZeroBalanceReminderEmailCheck($AccountZeroBalanceWarning->AccountID,$AccountZeroBalanceWarning->BalanceThresholdEmail,$LastRunTime) == 0 || cal_next_runtime($settings) == date('Y-m-d H:i:00'))) {
                    Log::info("balance check ". $AccountZeroBalanceWarning->BalanceAmount.' count down '.$AccountZeroBalanceWarning->CountDown);
                        if($AccountZeroBalanceWarning->BalanceAmount <= 0 && $AccountZeroBalanceWarning->CountDown == -1)
                        {
                                AccountBalance::where(['AccountID' => $AccountZeroBalanceWarning->AccountID])
                                    ->update(['CountDown' => $CountDown]);
                        }
                        $LanguageID = Account::getLanguageIDbyAccountID($AccountZeroBalanceWarning->AccountID);
                        if($AccountZeroBalanceWarning->BalanceAmount <= 0 && $AccountZeroBalanceWarning->CountDown == 0)
                        {
                            $EmailTemplateID = EmailTemplate::getSystemEmailTemplate($CompanyID, "FinalZeroBalanceWarning", $LanguageID);
                            NeonAlert::SendReminder($CompanyID, $settings, $EmailTemplateID->TemplateID, $AccountZeroBalanceWarning->AccountID);
                            AccountBalance::where(['AccountID' => $AccountZeroBalanceWarning->AccountID])
                                ->update(['CountDown' => -2]);
                            Log::info('AccountID = '.$AccountZeroBalanceWarning->AccountID.' SendReminder sent ');
                            Log::info('template id '. $EmailTemplateID->TemplateID);

                        } else if ($AccountZeroBalanceWarning->BalanceAmount <= 0 && $AccountZeroBalanceWarning->CountDown > 0) {
                            Log::info('Account balance = '.$AccountZeroBalanceWarning->BalanceAmount.' and count'.$AccountZeroBalanceWarning->CountDown);
                            $EmailTemplateID = EmailTemplate::getSystemEmailTemplate($CompanyID, "ZeroBalanceWarning", $LanguageID);
                            NeonAlert::SendReminder($CompanyID, $settings, $EmailTemplateID->TemplateID, $AccountZeroBalanceWarning->AccountID);
                            AccountBalance::where(['AccountID' => $AccountZeroBalanceWarning->AccountID])
                                ->decrement('CountDown', 1);
                            Log::info('AccountID = '.$AccountZeroBalanceWarning->AccountID.' SendReminder sent ');
                            Log::info('template id '. $EmailTemplateID->TemplateID);

                        } else if($AccountZeroBalanceWarning->BalanceAmount > 0 && $AccountZeroBalanceWarning->CountDown > 0)
                        {
                            AccountBalance::where(['AccountID' => $AccountZeroBalanceWarning->AccountID])
                                ->update(['CountDown' => -1]);
                        }
                        //NeonAlert::SendReminder($CompanyID, $settings, $settings['TemplateID'], $AccountBalanceWarning->AccountID);
                    }
                }
                if(cal_next_runtime($settings) == date('Y-m-d H:i:00')){
                    NeonAlert::UpdateNextRunTime($BillingClassSingle->BillingClassID,'ZeroBalanceWarningSettings','BillingClass');
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

    public static function getDynamicfieldValue($CompanyID,$ParentID,$FieldName){
        $FieldValue = 0;
        $FieldsID = DB::table('tblDynamicFields')->where(['CompanyID'=>$CompanyID,'FieldSlug'=>$FieldName])->pluck('DynamicFieldsID');
        if(!empty($FieldsID)){
            $FieldValue = DB::table('tblDynamicFieldsValue')->where(['ParentID'=>$ParentID,'DynamicFieldsID'=>$FieldsID])->pluck('FieldValue');
        }
        return $FieldValue;
    }

    public static function getDynamicfieldBySlug($CompanyID,$Type,$ParentID,$fieldSlug){
        $FieldValue=0;
        $Count = DB::table('tblDynamicFields')->where(['CompanyID'=>$CompanyID,'Type'=>$Type,'Status'=>1,'FieldSlug'=>$fieldSlug])->count();
        if($Count > 0){
            $FieldSlug = DB::table('tblDynamicFields')->where(['CompanyID'=>$CompanyID,'Type'=>$Type,'Status'=>1,'FieldSlug'=>$fieldSlug])->pluck('FieldSlug');
            $FieldValue = AccountBalance::getDynamicfieldValue($CompanyID,$ParentID,$FieldSlug);
        }
        return $FieldValue;
    }

    /** blocking account by gateway */
    public static function PBXBlockUnBlockAccount($CompanyID,$GatewayID,$ProcessID){
        $email_message  = array();
        $error_message  = array();
        $Results = array();
        $BillingClass = BillingClass::select('BillingClassID')->where(["CompanyID" => $CompanyID,"SuspendAccount" => 1])->get()->toArray();
        $Accounts =   AccountBilling::join('tblAccount','tblAccount.AccountID','=','tblAccountBilling.AccountID')
            ->select('tblAccountBilling.AccountID')
            ->where(array('CompanyID'=>$CompanyID,'Status'=>1,"AccountType"=>1))
            ->whereIn('tblAccountBilling.BillingClassID',$BillingClass)
            ->distinct()
            ->get()->toArray();

        $BlockingGateways = CompanyGateway::where(array('CompanyID'=>$CompanyID,'GatewayID'=>$GatewayID,'Status'=>1))->get();
        if(!empty($BillingClass) && !empty($BlockingGateways)) {
            foreach ($BlockingGateways as $BlockingGateway) {
                $BlockingAccounts = DB::select('CALL prc_GetBlockUnblockAccount(?,?)', array($CompanyID, $BlockingGateway->CompanyGatewayID));
                foreach ($BlockingAccounts as $BlockingAccount) {
                    if (in_array($BlockingAccount->AccountID, array_column($Accounts, 'AccountID'))) {
                        $param['te_code'] = $BlockingAccount->Number;
                        $PbxAcctStatus=AccountBalance::getDynamicfieldBySlug($CompanyID,'account',$BlockingAccount->AccountID,'pbxaccountstatus');
                        $Autoblock=AccountBalance::getDynamicfieldBySlug($CompanyID,'account',$BlockingAccount->AccountID,'autoblock');

                        if(isset($Autoblock) && $Autoblock == 1){
                            if(isset($PbxAcctStatus)){
                                if($PbxAcctStatus!=$BlockingAccount->Blocked){
                                    $response= AccountBalance::pbxAccountBlocking($BlockingAccount,$param,$PbxAcctStatus,$BlockingGateway->CompanyGatewayID,$CompanyID);
                                    if(!empty($response['AccountName']) && !empty($response['BlockedStatus'])){
                                        $email_message[$response['AccountName']]=$response['BlockedStatus'];
                                    }
                                    $error_message = $response['error_message'];
                                    Log::info("Account ID=".$BlockingAccount->AccountID." ,PbxAcctStatus=".$PbxAcctStatus);
                                }
                            }
                        }else{
                            if ($BlockingAccount->Balance < 0) {
                                $response=AccountBalance::pbxAccountBlocking($BlockingAccount,$param,1,$BlockingGateway->CompanyGatewayID,$CompanyID);
                                if(!empty($response['AccountName']) && !empty($response['BlockedStatus'])){
                                    $email_message[$response['AccountName']]=$response['BlockedStatus'];
                                }
                                $error_message = $response['error_message'];
                                Log::info("==== Blocking due to Balance ====");
                            } else {
                                $response= AccountBalance::pbxAccountBlocking($BlockingAccount,$param,0,$BlockingGateway->CompanyGatewayID,$CompanyID);
                                if(!empty($response['AccountName']) && !empty($response['BlockedStatus'])){
                                    $email_message[$response['AccountName']]=$response['BlockedStatus'];
                                }
                                $error_message = $response['error_message'];
                                Log::info("==== UnBlocking due to Balance ====");
                            }
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
        }
        return $error_message;
    }

    public static function SendAccountBlockingEmail($CompanyID,$AccountID,$Blocked){
        $CustomerEmail = '';
        $CompanyName = Company::getName($CompanyID);
        $EMAIL_TO_CUSTOMER = CompanyConfiguration::get($CompanyID,'EMAIL_TO_CUSTOMER');
        $Account = Account::find($AccountID);
        if ($EMAIL_TO_CUSTOMER == 1) {
            $CustomerEmail = $Account->BillingEmail;
        }
        $CustomerEmail = explode(",", $CustomerEmail);
        if($Blocked==1){
            $EmailTemplate 	= EmailTemplate::getSystemEmailTemplate($CompanyID, 'PBXAccountBlockEmail', $Account->LanguageID);
        }else{
            $EmailTemplate 	= EmailTemplate::getSystemEmailTemplate($CompanyID, 'PBXAccountUnBlockEmail', $Account->LanguageID);
        }
        if (!empty($CustomerEmail) && !empty($EmailTemplate) && !empty($EmailTemplate->Status)) {
            foreach ($CustomerEmail as $singleemail) {
                $singleemail = trim($singleemail);
                if (filter_var($singleemail, FILTER_VALIDATE_EMAIL)) {
                    $EmailMessage 	= $EmailTemplate->TemplateBody;
                    $replace_array 	= Helper::create_replace_array($Account, array());
                    $EmailMessage 	= template_var_replace($EmailMessage, $replace_array);
                    $Subject 		= template_var_replace($EmailTemplate->Subject, $replace_array);
                    $EmailFrom 	    = $EmailTemplate->EmailFrom;
                    $EmailsTo		= $singleemail;
                    $Emaildata = array(
                        'EmailToName' => $CompanyName,
                        'EmailTo' => $EmailsTo,
                        'EmailFrom' => $EmailFrom,
                        'Subject' => $Subject,
                        'CompanyID' => $CompanyID,
                        'CompanyName' => $CompanyName,
                        'Message' => $EmailMessage
                    );
                    $customeremail_status = Helper::sendMail('emails.template', $Emaildata);
                    log::info(print_r($customeremail_status,true));
                    if (!empty($customeremail_status['status'])) {
                        $statuslog = Helper::account_email_log($CompanyID, $Account->AccountID, $Emaildata, $customeremail_status, '', '', 0,0);
                    }
                }
            }
        }
    }

    public static function AutoPayInvoice($data){
        $response = array();
        $CompanyID = $data['CompanyID'];
        $AccountID = $data['AccountID'];
        $Amount = $data['GrandTotal'];
        $AccountOutstandingBalance = AccountBalance::getBalanceSOAOffsetAmount($AccountID);
        $CheckAccountBalance = AccountBalance::CheckAccountBalance($AccountID,$AccountOutstandingBalance,$Amount);

        if(isset($CheckAccountBalance) && $CheckAccountBalance==1){
            $response['response_code'] = 1;
            $response['status'] = 'success';
            $response['id'] = '1';
            $response['note'] = 'Account Balance Payment Success';
            $response['amount'] = $Amount;
            $response['response'] = array();
        }else{
            $response['response_code'] = 1;
            $response['status'] = 'success';
            $response['id'] = '1';
            $response['note'] = 'Account Balance Payment Success';
            $response['amount'] = $Amount;
            $response['response'] = array();
            /*$response['status'] = 'fail';
            $response['error'] = 'Account has not sufficient balance';*/
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

        if(!empty($InvoiceOutAmountTotal[0]->InvoiceOutAmountTotal)){
            $InvoiceOutAmountTotal = ($InvoiceOutAmountTotal[0]->InvoiceOutAmountTotal <> 0) ? $InvoiceOutAmountTotal[0]->InvoiceOutAmountTotal : 0;
        }else{
            $InvoiceOutAmountTotal = 0;
        }
        if(!empty($PaymentInAmountTotal[0]->PaymentInAmountTotal)){
            $PaymentInAmountTotal = ($PaymentInAmountTotal[0]->PaymentInAmountTotal <> 0) ? $PaymentInAmountTotal[0]->PaymentInAmountTotal : 0;
        }else{
            $PaymentInAmountTotal = 0;
        }
        if(!empty($InvoiceInAmountTotal[0]->InvoiceInAmountTotal)){
            $InvoiceInAmountTotal = ($InvoiceInAmountTotal[0]->InvoiceInAmountTotal <> 0) ? $InvoiceInAmountTotal[0]->InvoiceInAmountTotal : 0;
        }else{
            $InvoiceInAmountTotal = 0;
        }
        if(!empty($PaymentOutAmountTotal[0]->PaymentOutAmountTotal)){
            $PaymentOutAmountTotal = ($PaymentOutAmountTotal[0]->PaymentOutAmountTotal <> 0) ? $PaymentOutAmountTotal[0]->PaymentOutAmountTotal : 0;
        }else{
            $PaymentOutAmountTotal = 0;
        }





        $OffsetBalance = ($InvoiceOutAmountTotal - $PaymentInAmountTotal) - ($InvoiceInAmountTotal - $PaymentOutAmountTotal);

        return $OffsetBalance;

    }

    public static function getAccountExposure($CompanyID,$AccountID){
        $AccountBalance = AccountBalance::where('AccountID', $AccountID)->first(['AccountID', 'PermanentCredit', 'UnbilledAmount','EmailToCustomer', 'TemporaryCredit', 'TemporaryCreditDateTime', 'BalanceThreshold','BalanceAmount','VendorUnbilledAmount']);
        $UnbilledAmount = $AccountBalance->UnbilledAmount;
        $VendorUnbilledAmount = $AccountBalance->VendorUnbilledAmount;
        $SOA_Amount = AccountBalance::getBalanceSOAOffsetAmount($AccountID);
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
                                    $InvoicePeriod=array();
                                    $AccountBilling=AccountBilling::find($AccountBillingID);
                                    $InvoicePeriod['AccountBillingID'] = $AccountBillingID;
                                    $InvoicePeriod['LastInvoiceDate'] = $AccountBilling->LastInvoiceDate;
                                    $InvoicePeriod['NextInvoiceDate'] = $AccountBilling->NextInvoiceDate;
                                    $InvoicePeriod['LastChargeDate'] = $AccountBilling->LastChargeDate;
                                    $InvoicePeriod['NextChargeDate'] = $AccountBilling->NextChargeDate;
                                    $response = Invoice::getFutureInvoiceTotal($CompanyID,$InvoicePeriod,0);
                                    $GrandTotal=$response['GrandTotal'];
                                    $SubTotal=$response['SubTotal'];
                                    $AccountBalance  = AccountBalance::getAccountBalance($CompanyID,$AccountID);
                                    $AccountExposure = AccountBalance::getAccountOutstandingBalance($CompanyID,$AccountID);
                                    if($IncludeUnBilledAmount==1){
                                        $AccountOutstandingBalance = $AccountExposure;
                                    }else{
                                        $AccountOutstandingBalance = $AccountBalance;
                                    }
                                    log::info('AccountBalance '.$AccountOutstandingBalance);
                                    log::info('Next Invoice GrandTotal '.$GrandTotal);
                                    if($AccountOutstandingBalance <= $GrandTotal) {
                                        Log::info('AccountID = '.$AccountID.' SendReminder sent ');
                                        $LanguageID = Account::getLanguageIDbyAccountID(AccountID);
                                        $EmailTemplateID = EmailTemplate::getSystemEmailTemplate($CompanyID, "AccountBalanceWarning", $LanguageID);

                                        NeonAlert::SendReminder($CompanyID, $settings, $EmailTemplateID->TemplateID, $AccountID);

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
        $AccountBalance = AccountBalance::getBalanceSOAOffsetAmount($AccountID);
        $BillingType = AccountBilling::where(['AccountID'=>$AccountID,'ServiceID'=>0])->pluck('BillingType');
        /**
         * If billing type postpaid it will display as it is
         */
        if(isset($BillingType)){
            if($BillingType==AccountBilling::BILLINGTYPE_PREPAID){
                $AccountBalance = AccountBalanceLog::getPrepaidAccountBalance($AccountID);
                /*
                if($AccountBalance<0){
                    $AccountBalance=abs($AccountBalance);
                }else{
                    $AccountBalance=($AccountBalance) * -1;
                }*/
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
        $AccountBalance = number_format($AccountBalance,Helper::get_round_decimal_places($CompanyID,$AccountID));
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

    public static function pbxAccountBlocking($BlockingAccount,$param,$blocked,$CompanyGatewayID,$CompanyID){
        $Results = array();
        $error_message  = array();
        $email_message = array();
        $AccountName = '';
        $BlockedStatus = '';
        $pbx = new PBX($CompanyGatewayID);
        if($blocked==1){
            $response = $pbx->blockAccount($param);
            if (isset($response['message']) && $response['message'] == 'account blocked') {
                //$email_message[$BlockingAccount->AccountName] = 'Blocked';
                $AccountName=$BlockingAccount->AccountName;
                $BlockedStatus='Blocked';
            }
            if (isset($response['faultCode'])) {
                $error_message = $response;
                Log::info("===== Error ON Block ===== ");
                Log::info($error_message);
            }
            if($BlockingAccount->IsReseller==1){
                AccountBalance::pbxResellerBlocking($BlockingAccount->AccountID,$blocked,$CompanyGatewayID);
            }
            if ($BlockingAccount->Blocked == 0) {
                Account::where('AccountID', $BlockingAccount->AccountID)->update(array('Blocked' => 1));

                AccountBalance::SendAccountBlockingEmail($CompanyID, $BlockingAccount->AccountID,1);
            }
            Log::info("Account ID=".$BlockingAccount->AccountID." is blocked");
        }

        if($blocked==0){
            $response = $pbx->unBlockAccount($param);
            if (isset($response['message']) && $response['message'] == 'account unblocked') {
                //$email_message[$BlockingAccount->AccountName] = 'Unblocked';
                $AccountName=$BlockingAccount->AccountName;
                $BlockedStatus='Unblocked';
            }
            if (isset($response['faultCode'])) {
                $error_message = $response;
                Log::info("===== Error ON Unblock ===== ");
                Log::info($error_message);
            }
            if($BlockingAccount->IsReseller==1){
                AccountBalance::pbxResellerBlocking($BlockingAccount->AccountID,$blocked,$CompanyGatewayID);
            }
            if ($BlockingAccount->Blocked == 1) {
                Account::where('AccountID', $BlockingAccount->AccountID)->update(array('Blocked' => 0));
                AccountBalance::SendAccountBlockingEmail($CompanyID, $BlockingAccount->AccountID,0);
            }
            Log::info("Account ID=".$BlockingAccount->AccountID." is UnBlocked");
        }
        $Results['AccountName']=$AccountName;
        $Results['BlockedStatus']=$BlockedStatus;
        $Results['error_message']=$error_message;
        return $Results;
    }
    public static function getBalanceSOAOffsetAmount($AccountID){
        return AccountBalance::where(['AccountID'=>$AccountID])->pluck('SOAOffset');
    }

    public static function getNewAccountExposure($AccountID){
        $SOA_Amount = AccountBalance::getBalanceSOAOffsetAmount($AccountID);
        $response = AccountBalance::where('AccountID', $AccountID)->first(['AccountID', 'PermanentCredit', 'UnbilledAmount', 'EmailToCustomer', 'TemporaryCredit', 'TemporaryCreditDateTime', 'BalanceThreshold', 'BalanceAmount', 'VendorUnbilledAmount']);
        $UnbilledAmount = empty($response->UnbilledAmount) ? 0 : $response->UnbilledAmount;
        $VendorUnbilledAmount = empty($response->VendorUnbilledAmount) ? 0 : $response->VendorUnbilledAmount;
        $AccountBalance = $SOA_Amount + ($UnbilledAmount - $VendorUnbilledAmount);
        $AccountBalance = number_format($AccountBalance, get_round_decimal_places($AccountID));
        return $AccountBalance;
    }

    public static function pbxResellerBlocking($AccountID,$blocked,$CompanyGatewayID){
        $ResellerAccounts = Reseller::getResellerAccountsByAccountID($AccountID,$CompanyGatewayID);
        if(!empty($ResellerAccounts)){
            foreach($ResellerAccounts as $ResellerAccount){
                $param['te_code'] = $ResellerAccount->Number;
                $AccountName=$ResellerAccount->AccountName;
                $pbx = new PBX($CompanyGatewayID);
                if($blocked==1){
                    $response = $pbx->blockAccount($param);
                    if (isset($response['faultCode'])) {
                        $error_message = $response;
                        Log::info($AccountName." ===== Error ON Block ===== ");
                        Log::info($error_message);
                    }
                    if ($ResellerAccount->Blocked == 0) {
                        Account::where('AccountID', $ResellerAccount->AccountID)->update(array('Blocked' => 1));
                    }
                    Log::info($AccountName." is blocked");
                }

                if($blocked==0){
                    $response = $pbx->unBlockAccount($param);
                    if (isset($response['faultCode'])) {
                        $error_message = $response;
                        Log::info($AccountName." ===== Error ON Unblock ===== ");
                        Log::info($error_message);
                    }
                    if ($ResellerAccount->Blocked == 1) {
                        Account::where('AccountID', $ResellerAccount->AccountID)->update(array('Blocked' => 0));
                    }
                    Log::info($AccountName." is UnBlocked");
                }
            }
        }
    }

    /**
     * This function only for prepaid account
     **/
    public static function getAccountBalanceWithActiveCall($AccountID){

        $AccountBalance = AccountBalanceLog::getPrepaidAccountBalance($AccountID);
        $ActiveBalance = ActiveCall::where(['AccountID'=>$AccountID])->sum('Cost');

        $AccountBalance = empty($AccountBalance)?0:$AccountBalance;
        $ActiveBalance = empty($ActiveBalance)?0:$ActiveBalance;

        $TotalAmount = $AccountBalance - $ActiveBalance;

        return $TotalAmount;
    }
}
