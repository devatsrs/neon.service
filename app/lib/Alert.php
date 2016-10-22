<?php
namespace App\Lib;


use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\View;

class Alert extends \Eloquent{
    protected $guarded = array("AlertID");
    protected $fillable = [];
    protected $table = "tblAlert";
    protected $primaryKey = "AlertID";

    /** asr acd alerts */
    public static function asr_acd_alert($CompanyID, $ProcessID){
        $Alerts = Alert::where(array('CompanyID' => $CompanyID, 'AlertGroup' => 'qos', 'Status' => 1))->orderby('AlertType', 'asc')->get();
        foreach ($Alerts as $Alert) {

            $settings = json_decode($Alert->Settings, true);
            $settings['ProcessID'] = $ProcessID;
            if (cal_next_runtime($settings) == date('Y-m-d H:i:00')) {
                if (!isset($settings['LastRunTime'])) {
                    if ($settings['Time'] == 'HOUR') {
                        $settings['LastRunTime'] = date("Y-m-d H:00:00", strtotime('-' . $settings['Interval'] . ' hour'));
                    } else if ($settings['Time'] == 'DAILY') {
                        $settings['LastRunTime'] = date("Y-m-d 00:00:00", strtotime('-' . $settings['Interval'] . ' day'));
                    }
                    $settings['NextRunTime'] = next_run_time($settings);
                }
                $StartDate = $settings['LastRunTime'];
                $EndDate = date("Y-m-d H:i:s", strtotime($settings['NextRunTime']) - 1);
                $CompanyGatewayID = isset($settings['CompanyGatewayID']) ? intval($settings['CompanyGatewayID']) : 0;
                $AccountID = isset($settings['AccountID']) ? intval($settings['AccountID']) : 0;
                $CurrencyID = isset($settings['CurrencyID']) ? intval($settings['CurrencyID']) : 0;
                $AreaPrefix = !empty($settings['AreaPrefix']) ? $settings['AreaPrefix'] : '""';
                $Trunk = !empty($settings['Trunk']) ? $settings['Trunk'] : '""';
                $CountryID = isset($settings['CountryID']) ? intval($settings['CountryID']) : '0';


                $bind_param = array($CompanyID, $CompanyGatewayID, $AccountID, $CurrencyID, "'" . $StartDate . "'", "'" . $EndDate . "'", $AreaPrefix, $Trunk, $CountryID);
                $query = "CALL prc_getACD_ASR_Alert(" . implode(',', $bind_param) . ")";
                Log::info($query);
                $ACD_ASR_alerts = DB::connection('neon_report')->select($query);
                foreach ($ACD_ASR_alerts as $ACD_ASR_alert) {
                    if ($Alert->AlertType == 'ACD' && !empty($ACD_ASR_alert->ACD) && ((!empty($Alert->LowValue) && $Alert->LowValue > $ACD_ASR_alert->ACD) || !empty($Alert->HighValue) && $Alert->HighValue < $ACD_ASR_alert->ACD)) {
                        $settings['email_view'] = 'emails.qos_acd_alert';
                        $settings['Subject'] = 'Qos Alert ACD';
                        $settings['EmailType'] = AccountEmailLog::QosACDAlert;
                        NeonAlert::SendReminderToEmail($CompanyID, $Alert->AlertID,0, $settings);
                    }
                    if ($Alert->AlertType == 'ASR' && !empty($ACD_ASR_alert->ASR) && ((!empty($Alert->LowValue) && $Alert->LowValue > $ACD_ASR_alert->ASR) || !empty($Alert->HighValue) && $Alert->HighValue < $ACD_ASR_alert->ASR)) {
                        $settings['email_view'] = 'emails.qos_asr_alert';
                        $settings['Subject'] = 'Qos Alert ASR';
                        $settings['EmailType'] = AccountEmailLog::QosASRAlert;
                        NeonAlert::SendReminderToEmail($CompanyID, $Alert->AlertID,0, $settings);
                    }
                }
                $bind_param = array($CompanyID, $CompanyGatewayID, $AccountID, $CurrencyID, "'" . $StartDate . "'", "'" . $EndDate . "'", $AreaPrefix, $Trunk, $CountryID);
                $query = "CALL prc_getVendorACD_ASR_Alert(" . implode(',', $bind_param) . ")";
                Log::info($query);
                $ACD_ASR_alerts = DB::connection('neon_report')->select($query);
                foreach ($ACD_ASR_alerts as $ACD_ASR_alert) {
                    if ($Alert->AlertType == 'ACD' && !empty($ACD_ASR_alert->ACD) && ((!empty($Alert->LowValue) && $Alert->LowValue > $ACD_ASR_alert->ACD) || !empty($Alert->HighValue) && $Alert->HighValue < $ACD_ASR_alert->ACD)) {
                        $settings['email_view'] = 'emails.qos_acd_alert';
                        $settings['Subject'] = 'Qos Vendor Alert ACD';
                        $settings['EmailType'] = AccountEmailLog::QosACDAlert;
                        NeonAlert::SendReminderToEmail($CompanyID, $Alert->AlertID,0, $settings);
                    }
                    if ($Alert->AlertType == 'ASR' && !empty($ACD_ASR_alert->ASR) && ((!empty($Alert->LowValue) && $Alert->LowValue > $ACD_ASR_alert->ASR) || !empty($Alert->HighValue) && $Alert->HighValue < $ACD_ASR_alert->ASR)) {
                        $settings['email_view'] = 'emails.qos_asr_alert';
                        $settings['Subject'] = 'Qos Vendor Alert ASR';
                        $settings['EmailType'] = AccountEmailLog::QosASRAlert;
                        NeonAlert::SendReminderToEmail($CompanyID, $Alert->AlertID,0, $settings);
                    }
                }
                NeonAlert::UpdateNextRunTime($Alert->AlertID, 'Settings', 'Alert', $settings['NextRunTime']);
            }

        }
    }

    /** Call Monitor send alert for call duration , expensive call , call on blacklist destination , call after office time*/
    public static function CallMonitorAlert($CompanyID, $ProcessID)
    {
        $Alerts = Alert::where(array('CompanyID' => $CompanyID, 'AlertGroup' => 'call','Status' => 1))->orderby('AlertType', 'asc')->get();
        foreach ($Alerts as $Alert) {
            $settings = json_decode($Alert->Settings, true);
            $settings['ProcessID'] = $ProcessID;
            if ($Alert->AlertType == 'call_duration' && intval($settings['Duration']) > 0) {
                self::CallDurationAlert($CompanyID,$Alert,$settings);
            } else if ($Alert->AlertType == 'call_cost' && intval($settings['Cost']) > 0) {
                self::CallCostAlert($CompanyID,$Alert,$settings);
            } else if ($Alert->AlertType == 'call_after_office' && !empty($settings['OpenTime']) && !empty($settings['CloseTime'])) {
                self::CallOfficeAlert($CompanyID,$Alert,$settings);
            } else if ($Alert->AlertType == 'block_destination' && !empty($settings['BlacklistDestination'])) {
                self::CallBlackListAlert($CompanyID,$Alert,$settings);
            }
        }
    }

    public static function CallDurationAlert($CompanyID,$Alert,$settings)
    {
        $call_duration_count = CDRPostProcess::where('AccountID', intval($settings['AccountID']))
            ->where('billed_duration', '>', intval($settings['Duration']))
            ->count();
        $vcall_duration_count = VCDRPostProcess::where('AccountID', intval($settings['AccountID']))
            ->where('billed_duration', '>', intval($settings['Duration']))
            ->count();

        if ($call_duration_count > 0 || $vcall_duration_count>0) {

            $Account = Account::find($settings['AccountID']);

            if(!empty($Account->BillingEmail)){
                $call_duration = CDRPostProcess::where('AccountID', intval($settings['AccountID']))
                    ->where('billed_duration', '>', intval($settings['Duration']))
                    ->get();
                $vcall_duration = VCDRPostProcess::where('AccountID', intval($settings['AccountID']))
                    ->where('billed_duration', '>', intval($settings['Duration']))
                    ->get();

                $settings['ReminderEmail'] = $Account->BillingEmail;
                $settings['EmailMessage'] = View::make('emails.call_duration_alert',compact('call_duration','vcall_duration'))->render();
                $settings['Subject'] = 'Potential Fraud Alert Call Duration';
                $settings['EmailType'] = AccountEmailLog::CallDurationAlert;
                NeonAlert::SendReminderToEmail($CompanyID, $Alert->AlertID,$settings['AccountID'],$settings);
            }
        }
    }

    public static function CallCostAlert($CompanyID,$Alert,$settings)
    {
        $call_cost_count = CDRPostProcess::where('AccountID', intval($settings['AccountID']))
            ->where('cost', '>', intval($settings['Cost']))
            ->count();
        $vcall_cost_count = VCDRPostProcess::where('AccountID', intval($settings['AccountID']))
            ->where('buying_cost', '>', intval($settings['Cost']))
            ->count();

        if ($call_cost_count > 0 || $vcall_cost_count>0) {

            $Account = Account::find($settings['AccountID']);

            if(!empty($Account->BillingEmail)){
                $call_cost = CDRPostProcess::where('AccountID', intval($settings['AccountID']))
                    ->where('cost', '>', intval($settings['Cost']))
                    ->get();
                $vcall_cost = VCDRPostProcess::where('AccountID', intval($settings['AccountID']))
                    ->where('buying_cost', '>', intval($settings['Cost']))
                    ->get();

                $settings['ReminderEmail'] = $Account->BillingEmail;
                $settings['EmailMessage'] = View::make('emails.call_cost_alert',compact('call_cost','vcall_cost'))->render();
                $settings['Subject'] = 'Potential Fraud Alert Call Cost';
                $settings['EmailType'] = AccountEmailLog::CallCostAlert;
                NeonAlert::SendReminderToEmail($CompanyID, $Alert->AlertID,$settings['AccountID'],$settings);
            }
        }
    }

    public static function CallOfficeAlert($CompanyID,$Alert,$settings)
    {
        $call_office_count = CDRPostProcess::where('AccountID', intval($settings['AccountID']))
            ->Where(function ($query) use ($settings) {
                $query->whereRaw("time(connect_time) < '" . date("H:i:s", strtotime($settings['OpenTime'])) . "'")
                    ->orwhereRaw("time(connect_time) > '" . date("H:i:s", strtotime($settings['CloseTime'])) . "'" );
            })
            ->count();
        $vcall_office_count = VCDRPostProcess::where('AccountID', intval($settings['AccountID']))
            ->Where(function ($query) use ($settings) {
                $query->whereRaw("time(connect_time) < '" . date("H:i:s", strtotime($settings['OpenTime'])) . "'")
                    ->orwhereRaw("time(connect_time) > '" . date("H:i:s", strtotime($settings['CloseTime'])) . "'" );
            })
            ->count();

        if ($call_office_count > 0 || $vcall_office_count > 0) {
            $Account = Account::find($settings['AccountID']);
            if (!empty($Account->BillingEmail)) {
                $call_office = CDRPostProcess::where('AccountID', intval($settings['AccountID']))
                    ->Where(function ($query) use ($settings) {
                        $query->whereRaw("time(connect_time) < '" . date("H:i:s", strtotime($settings['OpenTime'])) . "'")
                            ->orwhereRaw("time(connect_time) > '" . date("H:i:s", strtotime($settings['CloseTime'])) . "'" );
                    })
                    ->get();
                $vcall_office = VCDRPostProcess::where('AccountID', intval($settings['AccountID']))
                    ->Where(function ($query) use ($settings) {
                        $query->whereRaw("time(connect_time) < '" . date("H:i:s", strtotime($settings['OpenTime'])) . "'")
                            ->orwhereRaw("time(connect_time) > '" . date("H:i:s", strtotime($settings['CloseTime'])) . "'" );
                    })
                    ->get();
                $settings['ReminderEmail'] = $Account->BillingEmail;
                $settings['EmailMessage'] = View::make('emails.call_office_alert', compact('call_office', 'vcall_office'))->render();
                $settings['Subject'] = 'Potential Fraud Alert Call Office';
                $settings['EmailType'] = AccountEmailLog::CallCostAlert;
                NeonAlert::SendReminderToEmail($CompanyID, $Alert->AlertID, $settings['AccountID'], $settings);
            }
        }
    }

    public static function CallBlackListAlert($CompanyID,$Alert,$settings)
    {

        $call_blacklist_count = CDRPostProcess::whereIn('CountryID',$settings['BlacklistDestination'])->count();
        $vcall_blacklist_count = VCDRPostProcess::whereIn('CountryID',$settings['BlacklistDestination'])->count();

        if ($call_blacklist_count > 0 || $vcall_blacklist_count > 0) {
            if (!empty($settings['ReminderEmail'])) {
                $call_blacklist = CDRPostProcess::whereIn('CountryID',$settings['BlacklistDestination'])->get();
                $vcall_blacklist = VCDRPostProcess::whereIn('CountryID',$settings['BlacklistDestination'])->get();

                $settings['ReminderEmail'] = 'girish.vadher@code-desk.com';
                $settings['EmailMessage'] = View::make('emails.call_blacklist_alert', compact('call_blacklist', 'vcall_blacklist'))->render();
                $settings['Subject'] = 'Potential Fraud Alert Call Black List';
                $settings['EmailType'] = AccountEmailLog::CallCostAlert;
                NeonAlert::SendReminderToEmail($CompanyID, $Alert->AlertID, 0, $settings);
            }
        }


    }


}
