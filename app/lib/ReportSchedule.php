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

            $settings = $report_settings = json_decode($ReportSchedule->Settings, true);

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
                if ($report_settings['Time'] == 'HOUR') {
                    $report_settings['LastRunTime'] = date("Y-m-d H:00:00", strtotime('-' . $report_settings['Interval'] . ' hour'));
                }else if ($report_settings['Time'] == 'DAILY') {
                    $report_settings['LastRunTime'] = date("Y-m-d 00:00:00", strtotime('-' . $report_settings['Interval'] . ' day'));
                } else if ($report_settings['Time'] == 'WEEKLY') {
                    $report_settings['LastRunTime'] = date("Y-m-d 00:00:00", strtotime('-' . $report_settings['Interval'] . ' week'));
                } else if ($report_settings['Time'] == 'MONTHLY') {
                    $report_settings['LastRunTime'] = date("Y-m-d 00:00:00", strtotime('-' . $report_settings['Interval'] . ' month'));
                } else if ($report_settings['Time'] == 'YEARLY') {
                    $report_settings['LastRunTime'] = date("Y-m-d 00:00:00", strtotime('-' . $report_settings['Interval'] . ' year'));
                }
                unset($report_settings['StartTime']);
                $report_settings['NextRunTime'] = next_run_time($report_settings);
                $StartDate = $report_settings['LastRunTime'];
                $EndDate = date("Y-m-d H:i:s", strtotime($report_settings['NextRunTime']) - 1);
                $amazonDir = AmazonS3::generate_upload_path(AmazonS3::$dir['REPORT_ATTACHMENT'],0,$CompanyID) ;
                $UPLOADPATH = CompanyConfiguration::get($CompanyID,'UPLOAD_PATH');
                $Format = 'XLS';
                if(!empty($settings['Format'])){
                    $Format = $settings['Format'];
                }
                $Reports = explode(',',$ReportSchedule->ReportID);
                //Log::info("Report IDs : ".print_r($Reports,true));
                $TEMP_PATH = CompanyConfiguration::get($CompanyID,'TEMP_PATH');
                $FilesToDelete = array();

                foreach($Reports as $ReportID) {
                    $web_url = CompanyConfiguration::getValueConfigurationByKey($CompanyID, 'WEB_URL') . '/report/export/' . $ReportID . '?StartDate=' . urlencode($StartDate) . '&EndDate=' . urlencode($EndDate) . '&Type=' . $Format . '&Time=' . $settings['Time'];
                    Log::info("Report URL : ".$web_url);
                    $cli = new Curl();
                    $cli->get($web_url);
                    $response = $cli->response;
                    $file_name =  basename($ReportSchedule->Name).' '.$ReportID. ' ' . substr($StartDate, 0, 10) . ' ' . substr($EndDate, 0, 10) . '.' . strtolower($Format);
                    $amazonPath = $amazonDir .  $file_name;
                    $file_path = $UPLOADPATH . '/'. $amazonPath ;
                    file_put_contents($file_path, $response);
                    if(!AmazonS3::upload($file_path,$amazonDir,$CompanyID)){
                        throw new \Exception('Error in Amazon upload');
                    }
                    // If amazon is on then we need to download file from amazon to local
                    // because when we upload to amazon it delete from local
                    $attachTempPath = $FilesToDelete[] = $TEMP_PATH.'/'.$file_name;
                    $attach = AmazonS3::download($CompanyID,$amazonPath,$attachTempPath);
                    // if amazon is on then downloaded file path otherwise local filepath
                    $settings['attach'][] = (strpos($attach, "https://") !== false) ? $attachTempPath : $file_path;
                    $settings['AttachmentPaths'][] = $amazonPath;
                }
                $settings['EmailMessage'] = 'Please check attached reports. Start Date: '.$StartDate.' to End Date: '.$EndDate;
                $settings['Subject'] = $ReportSchedule->Name;

                $settings['EmailType'] = AccountEmailLog::ReportEmail;
                ReportSchedule::SendReportEmail($CompanyID, $ReportSchedule->ReportScheduleID, $settings);
                NeonAlert::UpdateNextRunTime($ReportSchedule->ReportScheduleID, 'Settings', 'ReportSchedule', $settings['NextRunTime']);

                // If amazon is on then we need to delete temp files from local which we have downloaded from amazon above in the loop
                foreach ($FilesToDelete as $key => $value) {
                    @unlink($value);
                }
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
            'AttachmentPaths' => $settings['AttachmentPaths'],
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
