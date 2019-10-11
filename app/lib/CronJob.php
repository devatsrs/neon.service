<?php
namespace App\Lib;

use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Maatwebsite\Excel\Facades\Excel;
use App\Lib\NeonExcelIO;

class CronJob extends \Eloquent {
	protected $fillable = [];
    protected $guarded = array('CronJobID');

    protected $table = 'tblCronJob';

    protected  $primaryKey = "CronJobID";

    const  MINUTE = 1;
    const  HOUR = 2;
    const  DAILY = 3;
    const  WEEKLY = 4;
    const  MONTHLY = 5;
    const  YEARLY = 6;
    const  CUSTOM = 7;

    const JOBDAY_DAILY = 'DAILY';

    const  CRON_SUCCESS = 1;
    const  CRON_FAIL = 2;
	const  RATEEMAILTEMPLATE = 'CronRateSheetEmail';

    public static function checkForeignKeyById($id){
        return 0;
    }

    public static function getActiveCronCommand($companyid){
        $cmd =  CronJob::join('tblCronJobCommand','tblCronJobCommand.CronJobCommandID','=','tblCronJob.CronJobCommandID')->where(array('tblCronJob.CompanyID'=>$companyid,'tblCronJob.Status'=>1,'tblCronJob.Active'=>0))->select('tblCronJobCommand.Command','tblCronJob.CronJobID')->get();
        return $cmd;
    }

    public static function calcTimeRun($CronJob,$Command){

        $cronsetting = json_decode($CronJob->Settings);
        $strtotime_current = strtotime(date('Y-m-d H:i:00'));
        $strtotime = strtotime(date('Y-m-d H:i:00'));
        if(!empty($CronJob) && isset($cronsetting->JobTime)){
            switch($cronsetting->JobTime) {
                case 'HOUR':
                    if(isset($CronJob->LastRunTime) && isset($CronJob->NextRunTime) &&  $CronJob->NextRunTime >= date('Y-m-d H:i:00') && $CronJob->LastRunTime != ''){
                        $strtotime = strtotime($CronJob->LastRunTime);
                        if(isset($cronsetting->JobInterval)){
                            $strtotime += $cronsetting->JobInterval*60*60;
                        }
                        if($strtotime_current > $strtotime){
                            $strtotime = $strtotime_current;
                        }
                    }
                    $dayname = strtoupper(date('D'));

                    if(isset($cronsetting->JobDay) && is_array($cronsetting->JobDay) && !in_array($dayname,$cronsetting->JobDay) && !in_array(self::JOBDAY_DAILY,$cronsetting->JobDay)){
                        $strtotime = 0;
                    }else if(isset($cronsetting->JobDay) && !is_array($cronsetting->JobDay) && $cronsetting->JobDay != $dayname && !in_array(self::JOBDAY_DAILY,$cronsetting->JobDay)){
                        $strtotime = 0;
                    }

                    If(isset($cronsetting->JobStartTime) && date('Y-m-d H:i:00',strtotime(date('Y-m-d ').$cronsetting->JobStartTime)) > date('Y-m-d H:i:00')){
                        $strtotime = 0;
                    }

                    return date('Y-m-d H:i:00',$strtotime);
                case 'MINUTE':
                    if(isset($CronJob->LastRunTime) && isset($CronJob->NextRunTime) &&  $CronJob->NextRunTime >= date('Y-m-d H:i:00') && $CronJob->LastRunTime != ''){
                        $strtotime = strtotime($CronJob->LastRunTime);
                        if(isset($cronsetting->JobInterval)){
                            $strtotime += $cronsetting->JobInterval*60;
                        }
                        if($strtotime_current > $strtotime){
                            $strtotime = $strtotime_current;
                        }
                    }
                    $dayname = strtoupper(date('D'));
                    if(isset($cronsetting->JobDay) && is_array($cronsetting->JobDay) && !in_array($dayname,$cronsetting->JobDay) && !in_array(self::JOBDAY_DAILY,$cronsetting->JobDay)){
                        $strtotime = 0;
                    }else if(isset($cronsetting->JobDay) && !is_array($cronsetting->JobDay) && $cronsetting->JobDay != $dayname && !in_array(self::JOBDAY_DAILY,$cronsetting->JobDay)){
                        $strtotime = 0;
                    }
                    If(isset($cronsetting->JobStartTime) && date('Y-m-d H:i:00',strtotime(date('Y-m-d ').$cronsetting->JobStartTime)) > date('Y-m-d H:i:00')){
                        $strtotime = 0;
                    }
                    return date('Y-m-d H:i:00',$strtotime);
                case 'DAILY':
                    if(isset($CronJob->LastRunTime) && isset($CronJob->NextRunTime) &&  $CronJob->NextRunTime >= date('Y-m-d H:i:00') && $CronJob->LastRunTime != ''){
                        $strtotime = strtotime($CronJob->LastRunTime);
                        if(isset($cronsetting->JobInterval)){
                            $strtotime += $cronsetting->JobInterval*60*60*24;
                        }
                        if($strtotime_current > $strtotime){
                            $strtotime = $strtotime_current;
                        }
                    }
                    $dayname = strtoupper(date('D'));
                    if(isset($cronsetting->JobDay) && is_array($cronsetting->JobDay) && !in_array($dayname,$cronsetting->JobDay) && !in_array(self::JOBDAY_DAILY,$cronsetting->JobDay)){
                        $strtotime = 0;
                    }else if(isset($cronsetting->JobDay) && !is_array($cronsetting->JobDay) && $cronsetting->JobDay != $dayname && !in_array(self::JOBDAY_DAILY,$cronsetting->JobDay)){
                        $strtotime = 0;
                    }
                    If(isset($cronsetting->JobStartTime) && date('Y-m-d H:i:00',strtotime(date('Y-m-d ').$cronsetting->JobStartTime)) > date('Y-m-d H:i:00')){
                        $strtotime = 0;
                    }
                    return date('Y-m-d H:i:00',$strtotime);
                case 'MONTHLY':
                    if(isset($CronJob->LastRunTime) && isset($CronJob->NextRunTime) &&  $CronJob->NextRunTime >= date('Y-m-d H:i:00') && $CronJob->LastRunTime != ''){
                        $strtotime = strtotime($CronJob->LastRunTime);
                        if(isset($cronsetting->JobInterval)){
                            $strtotime = strtotime("+$cronsetting->JobInterval month", $strtotime);
                        }
                        if($strtotime_current > $strtotime){
                            $strtotime = $strtotime_current;
                        }
                    }

                    $dayname = strtoupper(date('D'));
                    if(isset($cronsetting->JobDay) && is_array($cronsetting->JobDay) && !in_array($dayname,$cronsetting->JobDay) && !in_array(self::JOBDAY_DAILY,$cronsetting->JobDay)){
                        $strtotime = 0;
                    }else if(isset($cronsetting->JobDay) && !is_array($cronsetting->JobDay) && $cronsetting->JobDay != $dayname && !in_array(self::JOBDAY_DAILY,$cronsetting->JobDay)){
                        $strtotime = 0;
                    }
                    If(isset($cronsetting->JobStartTime) && date('Y-m-d H:i:00',strtotime(date('Y-m-d ').$cronsetting->JobStartTime)) > date('Y-m-d H:i:00')){
                        $strtotime = 0;
                    }
                    if(isset($cronsetting->JobStartDay) && date('d',$strtotime) != $cronsetting->JobStartDay){
                        $strtotime = 0;
                    }
                    return date('Y-m-d H:i:00',$strtotime);
                case 'SECONDS':
                    $strtotime_current = strtotime(date('Y-m-d H:i:s'));
                    $strtotime = strtotime(date('Y-m-d H:i:s'));
                    if(isset($CronJob->LastRunTime) && isset($CronJob->NextRunTime) &&  $CronJob->NextRunTime >= date('Y-m-d H:i:s') && $CronJob->LastRunTime != ''){
                        $strtotime = strtotime($CronJob->LastRunTime);
                        if(isset($cronsetting->JobInterval)){
                            $strtotime += $cronsetting->JobInterval;
                        }
                        if($strtotime_current > $strtotime){
                            $strtotime = $strtotime_current;
                        }
                    }
                    $dayname = strtoupper(date('D'));
                    if(isset($cronsetting->JobDay) && is_array($cronsetting->JobDay) && !in_array($dayname,$cronsetting->JobDay) && !in_array(self::JOBDAY_DAILY,$cronsetting->JobDay)){
                        $strtotime = 0;
                    }else if(isset($cronsetting->JobDay) && !is_array($cronsetting->JobDay) && $cronsetting->JobDay != $dayname && !in_array(self::JOBDAY_DAILY,$cronsetting->JobDay)){
                        $strtotime = 0;
                    }
                    If(isset($cronsetting->JobStartTime) && date('Y-m-d H:i:s',strtotime(date('Y-m-d ').$cronsetting->JobStartTime)) > date('Y-m-d H:i:s')){
                        $strtotime = 0;
                    }
                    return date('Y-m-d H:i:s',$strtotime);
                default:
                    return '';
            }
        }else if(!empty($CronJob) && $Command == 'rategenerator'){
            if(isset($CronJob->LastRunTime) && isset($CronJob->NextRunTime) &&  $CronJob->NextRunTime >= date('Y-m-d H:i:00') && $CronJob->LastRunTime != ''){
                $strtotime = strtotime(date('Y-m-d ').$cronsetting->JobStartTime);
                $strtotime += 7*60*60*24;
            }
            $dayname = strtoupper(date('D'));
            if(isset($cronsetting->JobDay) && is_array($cronsetting->JobDay) && !in_array($dayname,$cronsetting->JobDay) && !in_array(self::JOBDAY_DAILY,$cronsetting->JobDay)){
                $strtotime = 0;
            }else if(isset($cronsetting->JobDay) && !is_array($cronsetting->JobDay) && $cronsetting->JobDay != $dayname && !in_array(self::JOBDAY_DAILY,$cronsetting->JobDay)){
                $strtotime = 0;
            }
            If(isset($cronsetting->JobStartTime) && date('Y-m-d H:i:00',strtotime(date('Y-m-d ').$cronsetting->JobStartTime)) > date('Y-m-d H:i:00')) {
                $strtotime = 0;
            }
            return date('Y-m-d H:i:00',$strtotime);
        }
    }
    public static function calcNextTimeRun($CronJobID){
        $CronJob =  CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings);
        $strtotime = strtotime(date('Y-m-d H:i:00'));
        $Command = DB::table('tblCronJobCommand')->where(array('CronJobCommandID'=>$CronJob->CronJobCommandID))->pluck('Command');
        if(!empty($CronJob) && isset($cronsetting->JobTime)){
            switch($cronsetting->JobTime) {
                case 'HOUR':
                    if($CronJob->LastRunTime == ''){
                        $strtotime = strtotime('+'.$cronsetting->JobInterval.' hour');
                    }else{
                        $strtotime = strtotime($CronJob->LastRunTime)+$cronsetting->JobInterval*60*60;
                    }
                    return date('Y-m-d H:i:00',$strtotime);
                case 'MINUTE':
                    if($CronJob->LastRunTime == ''){
                        $strtotime = strtotime('+'.$cronsetting->JobInterval.' minute');
                    }else{
                        $strtotime = strtotime($CronJob->LastRunTime)+$cronsetting->JobInterval*60;
                    }
                    return date('Y-m-d H:i:00',$strtotime);
                case 'DAILY':
                    if($CronJob->LastRunTime == ''){
                        $strtotime = strtotime('+'.$cronsetting->JobInterval.' day');
                    }else{
                        $strtotime = strtotime($CronJob->LastRunTime)+$cronsetting->JobInterval*60*60*24;
                    }
                    if(isset($cronsetting->JobStartTime)){
                        return date('Y-m-d',$strtotime).' '.date("H:i:00", strtotime("$cronsetting->JobStartTime"));
                    }
                    return date('Y-m-d H:i:00',$strtotime);
                case 'MONTHLY':
                    if($CronJob->LastRunTime == ''){
                        $strtotime = strtotime('+'.$cronsetting->JobInterval.' month');
                    }else{
                        $strtotime = strtotime("+$cronsetting->JobInterval month", strtotime($CronJob->LastRunTime));
                    }
                    if(isset($cronsetting->JobStartTime)){
                        return date('Y-m-d',$strtotime).' '.date("H:i:00", strtotime("$cronsetting->JobStartTime"));
                    }
                    return date('Y-m-d H:i:00',$strtotime);
                case 'SECONDS':
                    if($CronJob->LastRunTime == ''){
                        $strtotime = strtotime('+'.$cronsetting->JobInterval.' seconds');
                    }else{
                        $strtotime = strtotime($CronJob->LastRunTime)+$cronsetting->JobInterval;
                    }
                    return date('Y-m-d H:i:s',$strtotime);
                default:
                    return '';

            }
        }else if(!empty($CronJob) && isset($Command) && $Command == 'rategenerator'){
            if($CronJob->LastRunTime == ''){
                $strtotime = strtotime('+ 7 day');
            }else{
                $strtotime = strtotime($CronJob->LastRunTime)+ 7*60*60*24;
            }
            if(isset($cronsetting->JobStartTime)){
                return date('Y-m-d',$strtotime).' '.date("H:i:00", strtotime("$cronsetting->JobStartTime"));
            }
            return date('Y-m-d H:i:00',$strtotime);
        }
    }

    public static function createLog($CronJobID){
        $CronJob =  CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings);
        if(!empty($CronJob) && isset($cronsetting->JobTime) && $cronsetting->JobTime == 'SECONDS') {
            $time = strtotime(date('H:i:s'));
            $time = $cronsetting->JobInterval*round($time/$cronsetting->JobInterval);
            $data['LastRunTime'] = date('Y-m-d').' '.date('H:i:s',$time);
        }else{
            $data['LastRunTime'] = date('Y-m-d H:i:00');
        }

        $CronJob->update($data);
        $data['NextRunTime'] = CronJob::calcNextTimeRun($CronJob->CronJobID);
        $CronJob->update($data);
    }

    public static function checkStatus($CronJobID,$Command){
        $CronJob =  CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings);
        if(!empty($CronJob) && isset($cronsetting->JobTime) && $cronsetting->JobTime == 'SECONDS') {
            if (CronJob::calcTimeRun($CronJob,$Command) == date('Y-m-d H:i:s')) {
                return  true;
            }
        }else{
            if (CronJob::calcTimeRun($CronJob,$Command) == date('Y-m-d H:i:00')) {
                return  true;
            }
        }

        return false;
    }

    public static function calcTimeDiff($LastRunTime)
    {
        $seconds = strtotime(date('Y-m-d H:i:s')) - strtotime($LastRunTime);
        $minutes = floor(($seconds / 60));
        if (isset($minutes) && $minutes != '')
        {
            return $minutes;
        }else{
            return 0;
        }

    }

    public static function ActiveCronJobEmailSend($CronJob){
        $emaildata = array();

        $CronJobID = $CronJob->CronJobID;
        $JobTitle = $CronJob->JobTitle;
        $CompanyID = $CronJob->CompanyID;
        $LastRunTime = $CronJob->LastRunTime;
        $ComanyName = Company::getName($CompanyID);
        $PID = $CronJob->PID;
        $MysqlPID = $CronJob->MysqlPID;

        $minute = CronJob::calcTimeDiff($LastRunTime);
        $WEBURL = CompanyConfiguration::getValueConfigurationByKey($CompanyID,'WEB_URL');

        $cronsetting = json_decode($CronJob->Settings,true);
        $ActiveCronJobEmailTo = isset($cronsetting['ErrorEmail']) ? $cronsetting['ErrorEmail'] : '';

        if(getenv("APP_OS") == "Linux"){
            $KillCommand = 'kill -9 '.$PID;
        }else{
            $KillCommand = 'Taskkill /PID '.$PID.' /F';
        }

        if($MysqlPID!=''){
            try{
                $MysqlProcess=DB::select("SELECT * FROM INFORMATION_SCHEMA.PROCESSLIST where ID=".$MysqlPID);
                if(!empty($MysqlProcess)){
                    terminateMysqlProcess($MysqlPID);
                }
            }catch (\Exception $err) {
                Log::error($err);
            }

        }

		//Kill the process. 
 		$ReturnStatus = exec($KillCommand,$DetailOutput);
		CronJob::find($CronJobID)->update(["PID" => "", "Active"=>0,"LastRunTime" => date('Y-m-d H:i:00'),"MysqlPID"=>"","ProcessID"=>""]);

        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';
        $joblogdata['Message'] ='Error: CronJob is terminated by System, It Was running since ' . $minute . ' minutes.';
        $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
        CronJobLog::insert($joblogdata);

        if(!empty($ActiveCronJobEmailTo)) {

            $emaildata['KillCommand'] = $KillCommand;
            $emaildata['ReturnStatus'] = $ReturnStatus;
            $emaildata['DetailOutput'] = $DetailOutput;

            $emaildata['CompanyID'] = $CompanyID;
            $emaildata['Minute'] = $minute;
            $emaildata['JobTitle'] = $CronJob->JobTitle;
            $emaildata['PID'] = $CronJob->PID;
            $emaildata['CompanyName'] = $ComanyName;
            $emaildata['EmailTo'] = $ActiveCronJobEmailTo;
            $emaildata['EmailToName'] = '';
            $emaildata['Subject'] = $JobTitle . ' is terminated, Was running since ' . $minute . ' minutes.';
            $emaildata['Url'] = $WEBURL . '/cronjob_monitor';

            $emailstatus = Helper::sendMail('emails.ActiveCronJobEmailSend', $emaildata);
            return $emailstatus;
        }else{
            // Error Email is not setup.
            return -1;
        }
    }

    public static function CronJobSuccessEmailSend($CronJobID){
        $emaildata = array();
        $CronJob =  CronJob::find($CronJobID);
        $JobTitle = $CronJob->JobTitle;
        $CompanyID = $CronJob->CompanyID;

        $ComanyName = Company::getName($CompanyID);

        $cronsetting = json_decode($CronJob->Settings,true);
        $SuccessEmail = isset($cronsetting['SuccessEmail']) ? $cronsetting['SuccessEmail'] : '';
        //Log::info('Email Send' . $SuccessEmail);
        $emaildata['CompanyID'] = $CompanyID;
        $emaildata['CompanyName'] = $ComanyName;
        $emaildata['EmailTo'] = $SuccessEmail;
        $emaildata['EmailToName'] = '';
        $emaildata['Subject'] = $JobTitle.' - Success Cron Job';
        $emaildata['JobTitle'] = $JobTitle;
        $result = Helper::sendMail('emails.cronjobsuccessemail', $emaildata);
        return $result;
    }

    public static function CronJobErrorEmailSend($CronJobID,$Exception){

        $emaildata = array();
        $CronJob =  CronJob::find($CronJobID);
        $JobTitle = $CronJob->JobTitle;
        $CompanyID = $CronJob->CompanyID;

        $ComanyName = Company::getName($CompanyID);

        $cronsetting = json_decode($CronJob->Settings,true);
        $ErrorEmail = isset($cronsetting['ErrorEmail']) ? $cronsetting['ErrorEmail'] : '';
        $Message= '';
        if(is_object($Exception)){
            $Message.= $Exception->getMessage()."<br> ";
            $Message.=  str_replace("\n", "<br>", $Exception->getTraceAsString())."<br> ";
        }else{
            $Message.=  str_replace("\n", "<br>", $Exception)."<br> ";
        }


        $emaildata['CompanyID'] = $CompanyID;
        $emaildata['CompanyName'] = $ComanyName;
        $emaildata['EmailTo'] = $ErrorEmail;
        $emaildata['EmailToName'] = '';
        $emaildata['Subject'] = $JobTitle.' - Failed Error occurred in cron job';
        $emaildata['JobTitle'] = $JobTitle;
        $emaildata['Message'] = $Message;
        $result = Helper::sendMail('emails.cronjoberroremail', $emaildata);
        return $result;
    }

    public static function CronJobCdrBehindEmailSend($CronJobID,$CdrRunningBehindDuration){
        $emaildata = array();
        $CronJob =  CronJob::find($CronJobID);
        $JobTitle = $CronJob->JobTitle;
        $CompanyID = $CronJob->CompanyID;
        $LastCdrBehindEmailSendTime = isset($CronJob->CdrBehindEmailSendTime) ? $CronJob->CdrBehindEmailSendTime : '';
        $LastCdrBehindDuration = isset($CronJob->CdrBehindDuration) ? $CronJob->CdrBehindDuration : '';

        $WEBURL = CompanyConfiguration::getValueConfigurationByKey($CompanyID,'WEB_URL');
        $ComanyName = Company::getName($CompanyID);

        $cronsetting = json_decode($CronJob->Settings,true);
        $ErrorEmail = isset($cronsetting['ErrorEmail']) ? $cronsetting['ErrorEmail'] : '';

        $emaildata['CompanyID'] = $CompanyID;
        $emaildata['CompanyName'] = $ComanyName;
        $emaildata['EmailTo'] = $ErrorEmail;
        $emaildata['EmailToName'] = '';
        $emaildata['Subject'] = $JobTitle. ' - is currently running behind by ' . $CdrRunningBehindDuration .' minutes' ;
        $emaildata['JobTitle'] = $JobTitle;
        $emaildata['LastRunningBehindTime'] = $LastCdrBehindEmailSendTime;
        $emaildata['LastRunningBehindDuration'] = $LastCdrBehindDuration;
        $emaildata['RunningBehindDuration'] = $CdrRunningBehindDuration;
        $emaildata['Url'] = $WEBURL . '/cronjob_monitor';
        $result = Helper::sendMail('emails.cronjobcdrbehindemail', $emaildata);
        return $result;
    }

    // Not in use
    public static function NOT_IN_USE______CheckCdrBehindDuration($CronJob,$CdrBehindData){
        //check CdrBehindDuration from cron job setting
        $cronsetting = json_decode($CronJob->Settings, true);
        $CdrBehindEmailSendTime = $CronJob->CdrBehindEmailSendTime;
        if(!empty($cronsetting['CdrBehindDuration']) && !empty($cronsetting['ErrorEmail']) && !empty($cronsetting['CdrBehindDurationEmail']))
        {
            $CdrData = array();
            $CdrRunningBehindDuration = CronJob::calcTimeDiff($CdrBehindData['startdatetime']);
            $CurrentDateTime = date('Y-m-d H:i:s');
            //check RunningBehindDuration with Cron Job Max Behind Duration
            if(!empty($CdrRunningBehindDuration) && (int)$CdrRunningBehindDuration > (int)$cronsetting['CdrBehindDuration'])
            {
                //if not sent before
                if(isset($CdrBehindEmailSendTime) && $CdrBehindEmailSendTime !='')
                {
                    $CdrBehindEmailTime = CronJob::calcTimeDiff($CdrBehindEmailSendTime);
                    //check duration of last email send time
                    if(!empty($CdrBehindEmailTime) && (int)$CdrBehindEmailTime > (int)$cronsetting['CdrBehindDurationEmail']){

                        $emailstatus = CronJob::CronJobCdrBehindEmailSend($CronJob->CronJobID,$CdrRunningBehindDuration);
                        if (isset($emailstatus['status']) && $emailstatus['status'] == 1) {
                            $CdrData['CdrBehindEmailSendTime'] = $CurrentDateTime;
                            $CdrData['CdrBehindDuration'] = $CdrRunningBehindDuration;
                            $CronJob->update($CdrData);

                            Log::error("CDR Behind Duration Email Sent  -  Time : " . $CurrentDateTime);

                        } else {

                            Log::error('Failed to send Email Of CDR Behind Duration : Reason - ' . print_r($emailstatus, true));
                        }
                    }

                }else{
                    $emailstatus = CronJob::CronJobCdrBehindEmailSend($CronJob->CronJobID,$CdrRunningBehindDuration);
                    if (isset($emailstatus['status']) && $emailstatus['status'] == 1) {
                        $CdrData['CdrBehindEmailSendTime'] = $CurrentDateTime;
                        $CdrData['CdrBehindDuration'] = $CdrRunningBehindDuration;
                        $CronJob->update($CdrData);

                        Log::error("CDR Behind Duration Email Sent  -  Time : " . $CurrentDateTime);

                    } else {

                        Log::error('Failed to send Email Of CDR Behind Duration : Reason - ' . print_r($emailstatus, true));
                    }
                }
                Log::error('it is currently running behind by ' . $CdrRunningBehindDuration .' minutes');
            }

        } //CdrBehindDuration

    }
    public static function sendRateGenerationEmail($CompanyID,$CronJobID,$JobID,$EffectiveDate){
        $status['status']='';
        $status['message']='';
        $TEMP_PATH = CompanyConfiguration::get($CompanyID,'TEMP_PATH').'/';
        $CronJob =  CronJob::find($CronJobID);
        $cronsetting =   json_decode($CronJob->Settings);
        $CompanyName = DB::table('tblCompany')->where(['CompanyID'=>$CompanyID])->pluck('CompanyName');
        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';
        $joblogdata['Message'] = 'Success';
        $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
        CronJobLog::insert($joblogdata);

        $rates =  DB::select("CALL prc_GetLastRateTableRate(".$CompanyID.",'".$cronsetting->rateTableID."','".$EffectiveDate."')");
        $excel_data = json_decode(json_encode($rates),true);
        $filename = 'rate_table_'.date('Y-m-d His');

        $file_path = $TEMP_PATH.$filename.'.xlsx';

        $NeonExcel = new NeonExcelIO($file_path);
        $NeonExcel->write_excel($excel_data);

        /*Excel::create($filename, function ($excel) use ($excel_data) {
            $excel->sheet('Accounts', function ($sheet) use ($excel_data) {
                $sheet->fromArray($excel_data);
            });
        })->store('xls',Config::get('app.temp_location'));*/


        $emaildata['attach'] = $TEMP_PATH.$filename.'.xlsx';
        $rgname = DB::table('tblRateGenerator')->where(array('RateGeneratorId'=>$cronsetting->rateGeneratorID))->pluck('RateGeneratorName');
        $rtname = DB::table('tblRateTable')->where(array('RateTableId'=>$cronsetting->rateTableID))->pluck('RateTableName');
        $emaildata['data'] = array(
            'RateGeneratorName'=>$rgname,
            'RateTableName'=>$rtname,
            'EffectiveDate'=>$EffectiveDate,
        );
        $emaildata['Subject']= $rtname.' - Rate Update';
        $emaildata['CompanyID']= $CompanyID;
        Log::error("Rate Generate before email CronJobId" . $CronJobID."job id" .$JobID);

        $users = User::where(["CompanyID" => $CompanyID])->where('Roles', 'like', '%Account Manager%')->get(['EmailAddress','FirstName','LastName']);

        foreach($users as $user){
            $emailto = $user->EmailAddress;
            $FirstName = $user->FirstName;
            $LastName = $user->LastName;
            $emaildata['EmailTo'] = $emailto;
            $emaildata['EmailToName'] = $FirstName.' '.$LastName;
            $emaildata['FirstName'] = $FirstName;
            $emaildata['LastName'] = $LastName;
            $emaildata['CompanyName'] = $CompanyName;
            $status = Helper::sendMail('emails.rategenerator',$emaildata);
        }
        //$rates_email = explode(',',CompanySetting::getKeyVal($CompanyID,'RateGenerationEmail'));
        if(isset($cronsetting->SuccessEmail) && !empty($cronsetting->SuccessEmail)) {

            $rates_email = explode(',', $cronsetting->SuccessEmail);
            $valid_emails = array();

            foreach ($rates_email as $row) {
                $row = trim($row);
                if (filter_var($row, FILTER_VALIDATE_EMAIL)) {
                    $valid_emails[] = $row;
                    $emailto = $row;
                    $FirstName = 'Account';
                    $LastName = 'Manager';
                    $emaildata['EmailTo'] = $emailto;
                    $emaildata['EmailToName'] = $FirstName . ' ' . $LastName;
                    $emaildata['FirstName'] = $FirstName;
                    $emaildata['LastName'] = $LastName;
                    $emaildata['CompanyName'] = $CompanyName;
                    $status = Helper::sendMail('emails.rategenerator', $emaildata);
                }
            }

            Job::find($JobID)->update(array('EmailSentStatus' => $status['status'], 'EmailSentStatusMessage' => $status['message']));
            Log::error("Rate Generate after email CronJobId" . $CronJobID . "job id" . $JobID);
        }
    }
    public static function activateCronJob($CronJob){
        $getmypid = getmypid(); // get proccess id
        $dataactive['Active'] = 1;
        $dataactive['PID'] = $getmypid;
        $dataactive['LastRunTime'] = date('Y-m-d H:i:00');
        $CronJob->update($dataactive);

    }
    public static function deactivateCronJob($CronJob1){
        $CronJob=CronJob::find($CronJob1->CronJobID);
        $dataactive['PID'] = '';
        $dataactive['Active'] = 0;
        $dataactive['ProcessID'] = '';
        $dataactive['MysqlPID'] = '';
        $CronJob->update($dataactive);
    }

    // check sippy and vos download cronjob is active or not
    public static function checkCDRDownloadFiles($CompanyID){

        $CronJonCommandsIds = array();
        $rows = DB::table('tblCronJobCommand')->where(["Status"=> 1,'CompanyID'=>$CompanyID])->whereIn('Command',array('sippydownloadcdr','vosdownloadcdr','vos5000downloadcdr'))->get();
        if(count($rows)>0){
            foreach($rows as $row){
                if(!empty($row->CronJobCommandID)){
                    $CronJonCommandsIds[]=$row->CronJobCommandID;
                }
            }

            $count = CronJob::where(["Status"=> 1,'CompanyID'=>$CompanyID])->whereIn('CronJobCommandID',$CronJonCommandsIds)->count();
            if($count>0){
                return true;
            }
        }
        return false;
    }

    public static function GetNodesFromCronJob($CronJobID,$CompanyID,$Type){
        $Cron  = CronJob::where(['CronJobID' => $CronJobID , 'CompanyID' => $CompanyID])->first();
        if($Type == "CronJob"){
            $Nodes = json_decode($Cron->Settings,true);
        }else{
            $NodesFromCompany = CompanyConfiguration::where(['Key'=>'Nodes','CompanyID' => $CompanyID])->first();
            if($NodesFromCompany){
                $Nodes = json_decode($NodesFromCompany->value,true);
            }else{
                $Nodes['Nodes'] = "";
            }   
        }
        $Servers = [];
        if(isset($Nodes['Nodes']) && !empty($Nodes['Nodes'])){
            $Servers = $Nodes['Nodes'];
        } 
		
		if(!empty($Servers)){
            $CheckServerUp = Nodes::where(['ServerStatus' => '1', 'MaintananceStatus' => '0'])->whereIn('ServerID' , $Servers)->get();
            if($CheckServerUp){
                $array = [];
                foreach($CheckServerUp as $val){
                    $Key = array_search($val->ServerID,$Servers);
                    if($Key !== false)
                        $array[$Key] = json_decode(json_encode($val), true); 
                }
                ksort($array);
                return $array;
            }else{
                return false;
            }
        }else{
            return false;
        }
    }
}