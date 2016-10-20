<?php
namespace App\Lib;


use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class Alert extends \Eloquent {
    protected $guarded = array("AlertID");
    protected $fillable = [];
    protected $table = "tblAlert";
    protected $primaryKey = "AlertID";


    public static function asr_acd_alert($CompanyID,$ProcessID){
        $Alerts = Alert::where(array('CompanyID' => $CompanyID, 'AlertGroup' => 'qos', 'Status' => 1))->orderby('AlertType', 'asc')->get();
        foreach ($Alerts as $Alert) {

            $settings = json_decode($Alert->Settings, true);
            $settings['ProcessID'] = $ProcessID;
            if (cal_next_runtime($settings) == date('Y-m-d H:i:00')) {
                if(!isset($settings['LastRunTime'])) {
                    if($settings['Time'] == 'HOUR') {
                        $settings['LastRunTime'] = date("Y-m-d H:00:00",strtotime('-'.$settings['Interval'].' hour'));
                    }else if($settings['Time'] == 'DAILY'){
                        $settings['LastRunTime'] = date("Y-m-d 00:00:00",strtotime('-'.$settings['Interval'].' day'));
                    }
                    $settings['NextRunTime'] = next_run_time($settings);
                }
                $StartDate = $settings['LastRunTime'];
                $EndDate = $settings['NextRunTime'];
                $CompanyGatewayID = isset($settings['CompanyGatewayID']) ? intval($settings['CompanyGatewayID']) : 0;
                $AccountID = isset($settings['AccountID']) ? intval($settings['AccountID']) : 0;
                $CurrencyID = isset($settings['CurrencyID']) ? intval($settings['CurrencyID']) : 0;
                $AreaPrefix = !empty($settings['AreaPrefix']) ? $settings['AreaPrefix'] : '""';
                $Trunk = !empty($settings['Trunk']) ? $settings['Trunk'] : '""';
                $CountryID = isset($settings['CountryID']) ? intval($settings['CountryID']) : '0';


                $query = "CALL prc_getACD_ASR_Alert(?,?,?,?,?,?,?,?,?)";
                $bind_param = array($CompanyID, $CompanyGatewayID, $AccountID, $CurrencyID, $StartDate, $EndDate, $AreaPrefix, $Trunk, $CountryID);
                Log::info("CALL prc_getACD_ASR_Alert(" . implode(',',$bind_param) . ")");
                $ACD_ASR_alerts = DB::connection('neon_report')->select($query, $bind_param);
                foreach ($ACD_ASR_alerts as $ACD_ASR_alert) {
                    if ($Alert->AlertType == 'ACD' &&  !empty($ACD_ASR_alert->ACD) &&  ((!empty($Alert->LowValue) && $Alert->LowValue > $ACD_ASR_alert->ACD) || !empty($Alert->HighValue) && $Alert->HighValue < $ACD_ASR_alert->ACD)) {
                        $settings['email_view'] = 'emails.qos_acd_alert';
                        $settings['Subject'] = 'Qos Alert ACD';
                        $settings['EmailMessag'] = 'Qos Alert ACD';
                        $settings['EmailType'] = AccountEmailLog::QosACDAert;
                        NeonAlert::SendReminderToEmail($CompanyID,$Alert->AlertID, $settings);
                    }
                    if ($Alert->AlertType == 'ASR' &&  !empty($ACD_ASR_alert->ASR) &&  ((!empty($Alert->LowValue) && $Alert->LowValue > $ACD_ASR_alert->ASR) || !empty($Alert->HighValue) && $Alert->HighValue < $ACD_ASR_alert->ASR)) {
                        $settings['email_view'] = 'emails.qos_asr_alert';
                        $settings['Subject'] = 'Qos Alert ASR';
                        $settings['EmailMessag'] = 'Qos Alert ASR';
                        $settings['EmailType'] = AccountEmailLog::QosASRAert;
                        NeonAlert::SendReminderToEmail($CompanyID,$Alert->AlertID,$settings,'');
                    }
                }
                NeonAlert::UpdateNextRunTime($Alert->AlertID, 'Settings', 'Alert',$EndDate);
            }

        }
    }


}
