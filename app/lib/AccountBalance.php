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
        DB::connection('neon_report')->select("CALL prc_updateUnbilledAmount(?)",array($CompanyID));
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

}
