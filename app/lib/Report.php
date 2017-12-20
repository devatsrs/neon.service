<?php
namespace App\Lib;


use Curl\Curl;
use Illuminate\Support\Facades\Log;

class Report extends \Eloquent{
    protected $guarded = array("ReportID");
    protected $connection = 'neon_report';
    protected $fillable = [];
    protected $table = "tblReport";
    protected $primaryKey = "ReportID";

    /** send schedule report  */
    public static function send_schedule_report($CompanyID){
        $Reports = Report::where(array('CompanyID' => $CompanyID,'Schedule' => 1))->orderby('ReportID', 'asc')->get();
        foreach ($Reports as $Report) {

            $settings = json_decode($Report->ScheduleSettings, true);

            if (cal_next_runtime($settings) == date('Y-m-d H:i:00')) {
                if (!isset($settings['LastRunTime'])) {
                    if ($settings['Time'] == 'DAILY') {
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
                $web_url= $web_url.'/report/export/'.$Report->ReportID.'?StartDate='.urlencode($StartDate).'&EndDate='.urlencode($EndDate);
                $cli = new Curl();
                $cli->get($web_url);
                $response = $cli->response;
                $report = $TEMP_PATH.basename($Report->Name).' '.substr($StartDate,0,10).' '.substr($EndDate,0,10).'.xls';
                file_put_contents($report,$response);
                $settings['EmailMessage'] = 'Please check file';
                $settings['Subject'] = 'Please check file';
                $settings['attach'] = $report;
                $settings['EmailType'] = AccountEmailLog::ReportEmail;
                Report::SendReportEmail($CompanyID, $Report->ReportID, $settings);
                NeonAlert::UpdateNextRunTime($Report->ReportID, 'ScheduleSettings', 'Report', $settings['NextRunTime']);
                @unlink($report);
            }
        }
    }
    public static function SendReportEmail($CompanyID,$ReportID,$settings){
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
            'attach' => $settings['attach']
        );
        if (!empty($settings['NotificationEmail'])) {
            $emaildata['EmailTo'] = explode(",", $settings['NotificationEmail']);
            Log::info($settings['NotificationEmail']);
            $status = Helper::sendMail($email_view, $emaildata);
            Log::info($status);
            if($status['status'] == 1) {
                $statuslog = Helper::account_email_log($CompanyID, 0, $emaildata, $status, '', '', 0, $EmailType);
                if ($statuslog['status'] == 1) {
                    Report::report_email_log($ReportID, $statuslog['AccountEmailLog']->AccountEmailLogID);
                }
            }
        }
    }

    public static function report_email_log($ReportID,$AccountEmailLogID){
        $logData = [
            'ReportID' => $ReportID,
            'AccountEmailLogID' => $AccountEmailLogID,
            'SendBy' => 'RMScheduler',
            'send_at'=>date('Y-m-d H:i:s')
        ];
        $statuslog = ReportLog::create($logData);
        return $statuslog;
    }


}
