<?php
namespace App\Lib;


use Curl\Curl;
use Illuminate\Support\Facades\Log;

class ReportSchedule extends \Eloquent{
    protected $guarded = array("ReportScheduleID");
    protected $connection = 'neon_report';
    protected $fillable = [];
    protected $table = "tblReportSchedule";
    protected $primaryKey = "ReportScheduleID";

    /** send schedule report  */
    public static function send_schedule_report($CompanyID){
        $ReportSchedules = ReportSchedule::where(array('CompanyID' => $CompanyID,'Status' => 1))->orderby('ReportScheduleID', 'asc')->get();
        foreach ($ReportSchedules as $ReportSchedule) {

            $settings = json_decode($ReportSchedule->Settings, true);

            if (cal_next_runtime($settings) == date('Y-m-d H:i:00')) {
                if (!isset($settings['LastRunTime'])) {
                    if ($settings['Time'] == 'HOUR') {
                        $settings['LastRunTime'] = date("Y-m-d H:00:00", strtotime('-' . $settings['Interval'] . ' hour'));
                    }else if ($settings['Time'] == 'DAILY') {
                        $settings['LastRunTime'] = date("Y-m-d 00:00:00", strtotime('-' . $settings['Interval'] . ' day'));
                    } else if ($settings['Time'] == 'WEEKLY') {
                        $settings['LastRunTime'] = date("Y-m-d 00:00:00", strtotime('-' . $settings['Interval'] . ' week'));
                    } else if ($settings['Time'] == 'MONTHLY') {
                        $settings['LastRunTime'] = date("Y-m-d 00:00:00", strtotime('-' . $settings['Interval'] . ' month'));
                    } else if ($settings['Time'] == 'YEARLY') {
                        $settings['LastRunTime'] = date("Y-m-d 00:00:00", strtotime('-' . $settings['Interval'] . ' year'));
                    }
                    $settings['NextRunTime'] = next_run_time($settings);
                }
                $StartDate = $settings['LastRunTime'];
                $EndDate = date("Y-m-d H:i:s", strtotime($settings['NextRunTime']) - 1);
                $web_url = CompanyConfiguration::get($CompanyID, 'WEB_URL');//'http://localhost/girish/neon/web/girish/public'
                $TEMP_PATH = CompanyConfiguration::get($CompanyID,'TEMP_PATH').'/';
                $Format = 'XLS';
                if(!empty($settings['Format'])){
                    $Format = $settings['Format'];
                }
                $Reports = explode(',',$ReportSchedule->ReportID);
                foreach($Reports as $ReportID) {
                    $web_url = $web_url . '/report/export/' . $ReportID . '?StartDate=' . urlencode($StartDate) . '&EndDate=' . urlencode($EndDate) . '&Type=' . $Format;
                    $cli = new Curl();
                    $cli->get($web_url);
                    $response = $cli->response;

                    $report = $TEMP_PATH . basename($ReportSchedule->Name) . ' ' . substr($StartDate, 0, 10) . ' ' . substr($EndDate, 0, 10) . '.' . strtolower($Format);
                    file_put_contents($report, $response);
                    $settings['attach'][] = $report;
                }
                $settings['EmailMessage'] = 'Please check attached report of date from Start Date: '.$StartDate.' to End Date: '.$EndDate;
                $settings['Subject'] = $ReportSchedule->Name;

                $settings['EmailType'] = AccountEmailLog::ReportEmail;
                ReportSchedule::SendReportEmail($CompanyID, $ReportSchedule->ReportScheduleID, $settings);
                NeonAlert::UpdateNextRunTime($ReportSchedule->ReportScheduleID, 'Settings', 'ReportSchedule', $settings['NextRunTime']);
                @unlink($report);
            }
        }
    }
    public static function SendReportEmail($CompanyID,$ReportScheduleID,$settings){
        $Company = Company::find($CompanyID);
        $email_view = 'emails.template';

        $EmailType = 0;
        if (isset($settings['EmailType']) && $settings['EmailType'] > 0) {
            $EmailType = $settings['EmailType'];
        }
        $emaildata = array(
            'EmailToName' => $Company->CompanyName,
            'Subject' => $settings['Subject'],
            'CompanyID' => $CompanyID,
            'CompanyName' => $Company->CompanyName,
            'Message' => $settings['EmailMessage'],
            'attach' => $settings['attach'],
            'cc' => (isset($settings['cc'])?$settings['cc']:''),
            'bcc' => (isset($settings['bcc'])?$settings['bcc']:''),
        );
        if (!empty($settings['NotificationEmail'])) {
            $emaildata['EmailTo'] = explode(",", $settings['NotificationEmail']);
            Log::info($settings['NotificationEmail']);
            $status = Helper::sendMail($email_view, $emaildata);
            //Log::info($status);
            if($status['status'] == 1) {
                $statuslog = Helper::account_email_log($CompanyID, 0, $emaildata, $status, '', '', 0, $EmailType);
                if ($statuslog['status'] == 1) {
                    ReportSchedule::report_email_log($ReportScheduleID, $statuslog['AccountEmailLog']->AccountEmailLogID);
                }
            }
        }
    }

    public static function report_email_log($ReportScheduleID,$AccountEmailLogID){
        $logData = [
            'ReportScheduleID' => $ReportScheduleID,
            'AccountEmailLogID' => $AccountEmailLogID,
            'SendBy' => 'RMScheduler',
            'send_at'=>date('Y-m-d H:i:s')
        ];
        $statuslog = ReportScheduleLog::create($logData);
        return $statuslog;
    }


}
