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

    public static $qos_alert_type = array(''=>'Select','ACD'=>'ACD','ASR'=>'ASR');
    public static $call_monitor_alert_type = array(''=>'Select','block_destination'=>'Blacklisted Destination','call_duration'=>'Longest Call','call_cost'=>'Expensive Calls','call_after_office'=>'Call After Business Hour');
    public static $call_monitor_customer_alert_type = array(''=>'Select','call_duration'=>'Longest Call','call_cost'=>'Expensive Calls','call_after_office'=>'Call After Business Hour');
    public static $call_blacklist_alert_type = array(''=>'Select','block_destination'=>'Blacklisted Destination');

    /** asr acd alerts */
    public static function asr_acd_alert($CompanyID, $ProcessID){
        $Alerts = Alert::where(array('CompanyID' => $CompanyID, 'AlertGroup' => 'qos', 'Status' => 1))->orderby('AlertType', 'asc')->get();
        foreach ($Alerts as $Alert) {

            $settings = $report_settings =  json_decode($Alert->Settings, true);
            $settings['ProcessID'] = $ProcessID;
            if (cal_next_runtime($settings) == date('Y-m-d H:i:00')) {
                if (!isset($settings['LastRunTime'])) {
                    if ($settings['Time'] == 'MINUTE') {
                        $settings['LastRunTime'] = date("Y-m-d H:00:00", strtotime('-' . $settings['Interval'] . ' minute'));
                    }else if ($settings['Time'] == 'HOUR') {
                        $settings['LastRunTime'] = date("Y-m-d H:00:00", strtotime('-' . $settings['Interval'] . ' hour'));
                    } else if ($settings['Time'] == 'DAILY') {
                        $settings['LastRunTime'] = date("Y-m-d 00:00:00", strtotime('-' . $settings['Interval'] . ' day'));
                    }
                    $settings['NextRunTime'] = next_run_time($settings);
                }
                if ($report_settings['Time'] == 'MINUTE') {
                    $report_settings['LastRunTime'] = date("Y-m-d H:00:00", strtotime('-' . $report_settings['Interval'] . ' minute'));
                } else if ($report_settings['Time'] == 'HOUR') {
                    $report_settings['LastRunTime'] = date("Y-m-d H:00:00", strtotime('-' . $report_settings['Interval'] . ' hour'));
                } else if ($report_settings['Time'] == 'DAILY') {
                    $report_settings['LastRunTime'] = date("Y-m-d 00:00:00", strtotime('-' . $report_settings['Interval'] . ' day'));
                }
                unset($report_settings['StartTime']);
                $report_settings['NextRunTime'] = next_run_time($report_settings);
                $StartDate = $report_settings['LastRunTime'];
                $EndDate = date("Y-m-d H:i:s", strtotime($report_settings['NextRunTime']) - 1);
                $CompanyGatewayID = isset($settings['CompanyGatewayID']) ? implode(',',$settings['CompanyGatewayID']) : '';
                $AccountIDs = isset($settings['AccountID']) ? implode(',',$settings['AccountID']) : '';
                $VAccountID = isset($settings['VAccountID']) ? implode(',',$settings['VAccountID']) : '';
                $CurrencyID = isset($settings['CurrencyID']) ? intval($settings['CurrencyID']) : 0;
                $NoOfCall = isset($settings['NoOfCall']) ? intval($settings['NoOfCall']) : 0;
                $AreaPrefix = !empty($settings['Prefix']) ? $settings['Prefix'] : '';
                $Trunk = !empty($settings['TrunkID']) ? implode(',',$settings['TrunkID']) : '';
                $CountryID = isset($settings['CountryID']) ? implode(',',$settings['CountryID']) : '';
                $ResellerID = 0;
                $settings = Helper::ACD_ASR_CR($settings);

                //$StartDate = '2016-12-01';$EndDate = '2016-12-05';
                /** send only if customer not empty or both empty */
                if(!empty($AccountIDs) || (empty($AccountIDs) && empty($VAccountID))) {
                    $query = "CALL prc_getACD_ASR_Alert(" . $CompanyID . ",'" . $CompanyGatewayID . "','" . $AccountIDs . "','" . $ResellerID . "','" . $CurrencyID . "','" . $StartDate . "','" . $EndDate . "','" . $AreaPrefix . "','" . $Trunk . "','" . $CountryID . "')";
                    Log::info($query);
                    $ACD_ASR_alerts = DB::connection('neon_report')->select($query);
                    foreach ($ACD_ASR_alerts as $ACD_ASR_alert) {
                        if ($ACD_ASR_alert->Connected > $NoOfCall) {
                            $AccountID = 0;
                            $settings['AccountName'] = '';
                            $settings['Subject'] = $Alert->Name;
                            if (isset($ACD_ASR_alert->AccountID)) {
                                $settings['AccountName'] = Account::getAccountName($ACD_ASR_alert->AccountID);
                                $AccountID = $ACD_ASR_alert->AccountID;
                            }

                            if ($Alert->AlertType == 'ACD' && !empty($ACD_ASR_alert->ACD) && ((!empty($Alert->LowValue) && $Alert->LowValue > $ACD_ASR_alert->ACD) || !empty($Alert->HighValue) && $Alert->HighValue < $ACD_ASR_alert->ACD)) {
                                $settings['EmailType'] = AccountEmailLog::QosACDAlert;
                                $settings['EmailMessage'] = View::make('emails.qos_acd_alert', compact('ACD_ASR_alert', 'Alert', 'settings'))->render();
                                NeonAlert::SendReminderToEmail($CompanyID, $Alert->AlertID, $AccountID, $settings);
                            }
                            if ($Alert->AlertType == 'ASR' && !empty($ACD_ASR_alert->ASR) && ((!empty($Alert->LowValue) && $Alert->LowValue > $ACD_ASR_alert->ASR) || !empty($Alert->HighValue) && $Alert->HighValue < $ACD_ASR_alert->ASR)) {
                                $settings['EmailType'] = AccountEmailLog::QosASRAlert;
                                $settings['EmailMessage'] = View::make('emails.qos_acd_alert', compact('ACD_ASR_alert', 'Alert', 'settings'))->render();
                                NeonAlert::SendReminderToEmail($CompanyID, $Alert->AlertID, $AccountID, $settings);
                            }
                        }
                    }
                }

                /** send only if vendor not empty or both empty */
                if(!empty($VAccountID) || (empty($AccountIDs) && empty($VAccountID))) {
                    $query = "CALL prc_getVendorACD_ASR_Alert(" . $CompanyID . ",'" . $CompanyGatewayID . "','" . $VAccountID . "','" . $CurrencyID . "','" . $StartDate . "','" . $EndDate . "','" . $AreaPrefix . "','" . $Trunk . "','" . $CountryID . "')";
                    Log::info($query);
                    $ACD_ASR_alerts = DB::connection('neon_report')->select($query);
                    foreach ($ACD_ASR_alerts as $ACD_ASR_alert) {
                        if ($ACD_ASR_alert->Connected > $NoOfCall) {
                            $AccountID = 0;
                            $settings['AccountName'] = '';
                            $settings['Subject'] = $Alert->Name;
                            if (isset($ACD_ASR_alert->AccountID)) {
                                $settings['AccountName'] = Account::getAccountName($ACD_ASR_alert->AccountID);
                                $AccountID = $ACD_ASR_alert->AccountID;
                            }
                            if ($Alert->AlertType == 'ACD' && !empty($ACD_ASR_alert->ACD) && ((!empty($Alert->LowValue) && $Alert->LowValue > $ACD_ASR_alert->ACD) || !empty($Alert->HighValue) && $Alert->HighValue < $ACD_ASR_alert->ACD)) {
                                $settings['EmailMessage'] = View::make('emails.qos_acd_alert', compact('ACD_ASR_alert', 'Alert', 'settings'))->render();
                                $settings['EmailType'] = AccountEmailLog::QosACDAlert;
                                NeonAlert::SendReminderToEmail($CompanyID, $Alert->AlertID, $AccountID, $settings);

                            }
                            if ($Alert->AlertType == 'ASR' && !empty($ACD_ASR_alert->ASR) && ((!empty($Alert->LowValue) && $Alert->LowValue > $ACD_ASR_alert->ASR) || !empty($Alert->HighValue) && $Alert->HighValue < $ACD_ASR_alert->ASR)) {
                                $settings['EmailMessage'] = View::make('emails.qos_acd_alert', compact('ACD_ASR_alert', 'Alert', 'settings'))->render();
                                $settings['EmailType'] = AccountEmailLog::QosASRAlert;
                                NeonAlert::SendReminderToEmail($CompanyID, $Alert->AlertID, $AccountID, $settings);
                            }
                        }
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
            $settings['Subject'] = $Alert->Name;
            Log::info($Alert->AlertType.' start');
            if ($Alert->AlertType == 'call_duration' && intval($settings['Duration']) > 0) {
                self::CallDurationAlerts($CompanyID,$Alert,$settings);
            } else if ($Alert->AlertType == 'call_cost' && doubleval($settings['Cost']) > 0) {
                self::CallCostAlerts($CompanyID,$Alert,$settings);
            } else if ($Alert->AlertType == 'call_after_office' && !empty($settings['OpenTime']) && !empty($settings['CloseTime'])) {
                self::CallOfficeAlert($CompanyID,$Alert,$settings);
            } else if ($Alert->AlertType == 'block_destination' && !empty($settings['BlacklistDestination'])) {
                self::CallBlackListAlert($CompanyID,$Alert,$settings);
            }
            Log::info($Alert->AlertType . ' end ' );
        }
    }

    public static function CallDurationAlerts($CompanyID,$Alert,$settings)
    {

        if($settings['AccountIDs'] > 0) {
            $settings['AccountID'] = $settings['AccountIDs'];
             self::CallDurationAlert($CompanyID,$Alert,$settings);
        }else if($settings['AccountIDs'] == -1){
            $call_durations = CDRPostProcess::where('billed_duration', '>', intval($settings['Duration']))->where('CompanyID',$CompanyID)->distinct()->get(['AccountID']);
            $vcall_durations = VCDRPostProcess::where('billed_duration', '>', intval($settings['Duration']))->where('CompanyID',$CompanyID)->distinct()->get(['AccountID']);
            foreach($call_durations as $call_duration){
                $settings['AccountID'] = $call_duration->AccountID;
                self::CallDurationAlert($CompanyID,$Alert,$settings);
            }
            foreach($vcall_durations as $vcall_duration){
                $settings['AccountID'] = $vcall_duration->AccountID;
                self::CallDurationAlert($CompanyID,$Alert,$settings);
            }
        }
    }
    public static function CallCostAlerts($CompanyID,$Alert,$settings)
    {
        if($settings['AccountIDs'] > 0) {
            $settings['AccountID'] = $settings['AccountIDs'];
            self::CallCostAlert($CompanyID,$Alert,$settings);
        }else if($settings['AccountIDs'] == -1){
            $call_costs = CDRPostProcess::where('cost', '>', doubleval($settings['Cost']))->where('CompanyID',$CompanyID)->distinct()->get(['AccountID']);
            $vcall_costs = VCDRPostProcess::where('buying_cost', '>', doubleval($settings['Cost']))->where('CompanyID',$CompanyID)->distinct()->get(['AccountID']);
            foreach($call_costs as $call_cost){
                $settings['AccountID'] = $call_cost->AccountID;
                self::CallCostAlert($CompanyID,$Alert,$settings);
            }
            foreach($vcall_costs as $vcall_cost){
                $settings['AccountID'] = $vcall_cost->AccountID;
                self::CallCostAlert($CompanyID,$Alert,$settings);
            }
        }
    }

    public static function CallDurationAlert($CompanyID,$Alert,$settings)
    {
        $call_duration_count = CDRPostProcess::where('AccountID', intval($settings['AccountID']))
            ->where('billed_duration', '>', intval($settings['Duration']))
            ->where('CompanyID',$CompanyID)
            ->count();
        $vcall_duration_count = VCDRPostProcess::where('AccountID', intval($settings['AccountID']))
            ->where('billed_duration', '>', intval($settings['Duration']))
            ->where('CompanyID',$CompanyID)
            ->count();

        if ($call_duration_count > 0 || $vcall_duration_count>0) {

            $Account = Account::find($settings['AccountID']);
            $call_duration = CDRPostProcess::where('AccountID', intval($settings['AccountID']))
                ->where('billed_duration', '>', intval($settings['Duration']))
                ->where('CompanyID',$CompanyID)
                ->get();
            $vcall_duration = VCDRPostProcess::where('AccountID', intval($settings['AccountID']))
                ->where('billed_duration', '>', intval($settings['Duration']))
                ->where('CompanyID',$CompanyID)
                ->get();
            $settings['EmailMessage'] = View::make('emails.call_duration_alert',compact('call_duration','vcall_duration','settings'))->render();
            $settings['EmailType'] = AccountEmailLog::CallDurationAlert;
            if(!empty($settings['ReminderEmail'])){
                NeonAlert::SendReminderToEmail($CompanyID, $Alert->AlertID,$settings['AccountID'],$settings);
            }
            if($settings['EmailToAccount'] == 1 && !empty($Account->BillingEmail)){
                $settings['ReminderEmail'] = $Account->BillingEmail;
                NeonAlert::SendReminderToEmail($CompanyID, $Alert->AlertID,$settings['AccountID'],$settings);
            }
        }
    }

    public static function CallCostAlert($CompanyID,$Alert,$settings)
    {
        $call_cost_count = CDRPostProcess::where('AccountID', intval($settings['AccountID']))
            ->where('cost', '>', doubleval($settings['Cost']))
            ->where('CompanyID',$CompanyID)
            ->count();
        $vcall_cost_count = VCDRPostProcess::where('AccountID', intval($settings['AccountID']))
            ->where('buying_cost', '>', doubleval($settings['Cost']))
            ->where('CompanyID',$CompanyID)
            ->count();

        if ($call_cost_count > 0 || $vcall_cost_count>0) {

            $Account = Account::find($settings['AccountID']);

            $call_cost = CDRPostProcess::where('AccountID', intval($settings['AccountID']))
                ->where('cost', '>', doubleval($settings['Cost']))
                ->where('CompanyID',$CompanyID)
                ->get();
            $vcall_cost = VCDRPostProcess::where('AccountID', intval($settings['AccountID']))
                ->where('buying_cost', '>', doubleval($settings['Cost']))
                ->where('CompanyID',$CompanyID)
                ->get();
            $settings['EmailMessage'] = View::make('emails.call_cost_alert',compact('call_cost','vcall_cost','settings'))->render();
            $settings['EmailType'] = AccountEmailLog::CallCostAlert;

            if(!empty($settings['ReminderEmail'])){
                NeonAlert::SendReminderToEmail($CompanyID, $Alert->AlertID,$settings['AccountID'],$settings);
            }
            if($settings['EmailToAccount'] == 1 && !empty($Account->BillingEmail)){
                $settings['ReminderEmail'] = $Account->BillingEmail;
                NeonAlert::SendReminderToEmail($CompanyID, $Alert->AlertID,$settings['AccountID'],$settings);
            }

        }
    }

    public static function CallOfficeAlert($CompanyID,$Alert,$settings)
    {
        $call_office_count = CDRPostProcess::where('AccountID', intval($settings['AccountID']))->where('CompanyID',$CompanyID)
            ->Where(function ($query) use ($settings) {
                $query->whereRaw("time(connect_time) < '" . date("H:i:s", strtotime($settings['OpenTime'])) . "'")
                    ->orwhereRaw("time(connect_time) > '" . date("H:i:s", strtotime($settings['CloseTime'])) . "'" );
            })
            ->count();
        $vcall_office_count = VCDRPostProcess::where('AccountID', intval($settings['AccountID']))->where('CompanyID',$CompanyID)
            ->Where(function ($query) use ($settings) {
                $query->whereRaw("time(connect_time) < '" . date("H:i:s", strtotime($settings['OpenTime'])) . "'")
                    ->orwhereRaw("time(connect_time) > '" . date("H:i:s", strtotime($settings['CloseTime'])) . "'" );
            })
            ->count();

        if ($call_office_count > 0 || $vcall_office_count > 0) {
            $Account = Account::find($settings['AccountID']);
            $call_office = CDRPostProcess::where('AccountID', intval($settings['AccountID']))->where('CompanyID',$CompanyID)
                ->Where(function ($query) use ($settings) {
                    $query->whereRaw("time(connect_time) < '" . date("H:i:s", strtotime($settings['OpenTime'])) . "'")
                        ->orwhereRaw("time(connect_time) > '" . date("H:i:s", strtotime($settings['CloseTime'])) . "'" );
                })
                ->get();
            $vcall_office = VCDRPostProcess::where('AccountID', intval($settings['AccountID']))->where('CompanyID',$CompanyID)
                ->Where(function ($query) use ($settings) {
                    $query->whereRaw("time(connect_time) < '" . date("H:i:s", strtotime($settings['OpenTime'])) . "'")
                        ->orwhereRaw("time(connect_time) > '" . date("H:i:s", strtotime($settings['CloseTime'])) . "'" );
                })
                ->get();
            $settings['EmailMessage'] = View::make('emails.call_office_alert', compact('call_office', 'vcall_office','settings'))->render();
            $settings['EmailType'] = AccountEmailLog::CallCostAlert;
            if(!empty($settings['ReminderEmail'])){
                NeonAlert::SendReminderToEmail($CompanyID, $Alert->AlertID,$settings['AccountID'],$settings);
            }
            if($settings['EmailToAccount'] == 1 && !empty($Account->BillingEmail)){
                $settings['ReminderEmail'] = $Account->BillingEmail;
                NeonAlert::SendReminderToEmail($CompanyID, $Alert->AlertID,$settings['AccountID'],$settings);
            }
        }
    }

    public static function CallBlackListAlert($CompanyID,$Alert,$settings)
    {

        $call_blacklist_count = CDRPostProcess::whereIn('CountryID',$settings['BlacklistDestination'])->where('CompanyID',$CompanyID)->count();
        $vcall_blacklist_count = VCDRPostProcess::whereIn('CountryID',$settings['BlacklistDestination'])->where('CompanyID',$CompanyID)->count();

        if ($call_blacklist_count > 0 || $vcall_blacklist_count > 0) {
            if (!empty($settings['ReminderEmail'])) {
                $call_blacklist = CDRPostProcess::whereIn('CountryID',$settings['BlacklistDestination'])->where('CompanyID',$CompanyID)->get();
                $vcall_blacklist = VCDRPostProcess::whereIn('CountryID',$settings['BlacklistDestination'])->where('CompanyID',$CompanyID)->get();


                $settings['EmailMessage'] = View::make('emails.call_blacklist_alert', compact('call_blacklist', 'vcall_blacklist','settings'))->render();
                $settings['EmailType'] = AccountEmailLog::CallCostAlert;
                NeonAlert::SendReminderToEmail($CompanyID, $Alert->AlertID, 0, $settings);
            }
        }


    }
    /** send vendor balance report to specified emails*/
    public static function VendorBalanceReport($CompanyID, $ProcessID){
        $Alerts = Alert::where(array('CompanyID' => $CompanyID, 'AlertGroup' => 'call','AlertType'=>'vendor_balance_report', 'Status' => 1))->orderby('AlertType', 'asc')->get();
        foreach ($Alerts as $Alert) {

            $settings = $report_settings = json_decode($Alert->Settings, true);
            $settings['ProcessID'] = $ProcessID;
            $settings['Subject'] = $Alert->Name;
            if (cal_next_runtime($settings) == date('Y-m-d H:i:00')) {
                if (!isset($settings['LastRunTime'])) {
                    if ($settings['Time'] == 'MINUTE') {
                        $settings['LastRunTime'] = date("Y-m-d H:00:00", strtotime('-' . $settings['Interval'] . ' minute'));
                    } else if ($settings['Time'] == 'HOUR') {
                        $settings['LastRunTime'] = date("Y-m-d H:00:00", strtotime('-' . $settings['Interval'] . ' hour'));
                    } else if ($settings['Time'] == 'DAILY') {
                        $settings['LastRunTime'] = date("Y-m-d 00:00:00", strtotime('-' . $settings['Interval'] . ' day'));
                    }
                    $settings['NextRunTime'] = next_run_time($settings);
                }
                if ($report_settings['Time'] == 'MINUTE') {
                    $report_settings['LastRunTime'] = date("Y-m-d H:00:00", strtotime('-' . $report_settings['Interval'] . ' minute'));
                } else if ($report_settings['Time'] == 'HOUR') {
                    $report_settings['LastRunTime'] = date("Y-m-d H:00:00", strtotime('-' . $report_settings['Interval'] . ' hour'));
                } else if ($report_settings['Time'] == 'DAILY') {
                    $report_settings['LastRunTime'] = date("Y-m-d 00:00:00", strtotime('-' . $report_settings['Interval'] . ' day'));
                }
                unset($report_settings['StartTime']);
                $report_settings['NextRunTime'] = next_run_time($report_settings);
                $StartDate = $report_settings['LastRunTime'];
                $EndDate = date("Y-m-d H:i:s", strtotime($report_settings['NextRunTime']) - 1);
                $VAccountIDs = isset($settings['VAccountID']) ? implode(',', $settings['VAccountID']) : '';

                //$StartDate = '2016-12-01';$EndDate = '2016-12-03';
                $VAccountIDs = explode(',', $VAccountIDs);
                /** send only if vendor not empty */
                foreach ($VAccountIDs as $VAccountID) {
                    if (!empty($VAccountID)) {
                        $query = "CALL prc_getVendorBalanceReport(" . $CompanyID . ",'" . $VAccountID . "','" . $StartDate . "','" . $EndDate . "')";
                        Log::info($query);
                        $ACD_ASR_alerts = DB::connection('neon_report')->select($query);
                        if (!empty($ACD_ASR_alerts)) {
                            $settings['EmailMessage'] = View::make('emails.vendor_report', compact('ACD_ASR_alerts', 'Alert', 'settings'))->render();
                            $settings['EmailType'] = AccountEmailLog::VendorBalanceReport;
                            NeonAlert::SendReminderToEmail($CompanyID, $Alert->AlertID, $VAccountID, $settings);
                        }
                    }
                }
                NeonAlert::UpdateNextRunTime($Alert->AlertID, 'Settings', 'Alert', $settings['NextRunTime']);
            }
        }
    }

    public static function sendAccountBalanceEmailReminder($CompanyID) {
        $Company 	= Company::find($CompanyID);
        $TodayDate 	= date_create(date('Y-m-d'));

        $Alerts = Alert::where(['CompanyID' => $CompanyID,'AlertType'=>'account_balance', 'AlertGroup' => 'call', 'Status' => 1])->get();

        foreach ($Alerts as $Alert) {
            $Settings   	= json_decode($Alert->Settings);
            $AccountID 		= $Settings->AccountIDs;

            if(!empty($AccountID)) {
                if($AccountID == -1) {
                    $Accounts = Account::where(['AccountType'=>1,'Status'=>1,'Billing'=>1])->get();
                } else {
                    $Accounts = Account::where(['AccountID'=>$AccountID,'AccountType'=>1,'Status'=>1,'Billing'=>1])->get();
                }

                foreach ($Accounts as $Account) {
                    $AccountBilling = AccountBilling::where(['AccountID'=>$Account->AccountID,'ServiceID'=>0]);
                    if($AccountBilling->count() > 0) {
                        $NextInvoiceDate = date_create($AccountBilling->first()->NextInvoiceDate);

                        $diff = date_diff($TodayDate,$NextInvoiceDate);

                        if($diff->invert == 0 && $diff->days == $Settings->ReminderDays) {
                            $IsEmailSend = AccountEmailLog::where(['CompanyID'=>$CompanyID,'AccountID'=>$Account->AccountID,'EmailType' => AccountEmailLog::AccountBalanceEmailReminder])
                                ->where('created_at','like',date('Y-m-d').'%')->count();

                            if(!($IsEmailSend > 0)) {
                                $EmailTemplate 	= EmailTemplate::getSystemEmailTemplate($CompanyID, 'AccountBalanceEmailReminder', $Account->LanguageID);
                                $EmailMessage 	= $EmailTemplate->TemplateBody;
                                $replace_array 	= Helper::create_replace_array($Account, array());
                                $EmailMessage 	= template_var_replace($EmailMessage, $replace_array);
                                $Subject 		= template_var_replace($EmailTemplate->Subject, $replace_array);
                                $EmailFrom 	    = $EmailTemplate->EmailFrom;

                                $emailsTo[] = $Settings->ReminderEmail;
                                if ($Settings->EmailToAccount == 1) {
                                    $emailsTo[] = $Account->BillingEmail;
                                }

                                $emaildata = array(
                                    'EmailToName' => $Company->CompanyName,
                                    'EmailTo' => $emailsTo,
                                    'EmailFrom' => $EmailFrom,
                                    'Subject' => $Subject,
                                    'CompanyID' => $CompanyID,
                                    'CompanyName' => $Company->CompanyName,
                                    'Message' => $EmailMessage
                                );

                                $emailstatus = Helper::sendMail('emails.template', $emaildata);

                                if ($emailstatus) {
                                    $logdata = array(
                                        'CompanyID' => $CompanyID,
                                        'AccountID' => $Account->AccountID,
                                        'CreatedBy' => 'System Notification',
                                        'created_at' => date('Y-m-d H:i:s'),
                                        'EmailTo' => implode(',', $emailsTo),
                                        'Subject' => $Subject,
                                        'Message' => $EmailMessage,
                                        'EmailType' => AccountEmailLog::AccountBalanceEmailReminder
                                    );

                                    AccountEmailLog::insert($logdata);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
