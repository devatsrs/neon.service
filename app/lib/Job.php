<?php
/**
 * Created by PhpStorm.
 * User: Ammar Zaheer
 * Date: 4/15/2015
 * Time: 12:37 PM
 */

namespace App\Lib;


use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;
use Webpatser\Uuid\Uuid;

class Job extends \Eloquent {

    protected $fillable = [];
    protected $guarded = array('JobID');

    protected $table = 'tblJob';

    protected  $primaryKey = "JobID";

    /*public static function GenerateJob($JobType, $options = "") {
        /*
         *  Generate Rate Table Log
         */
      /*  $CompanyID = $options['CompanyID'];
        unset($options['CompanyID']);

        $data["CompanyID"] = $CompanyID;
        $data["JobTypeID"] = 5;
        $data["JobStatusID"] = 1;
        $data["JobLoggedUserID"] = 0;//User::getMinUserID($CompanyID);
        $data["CreatedBy"] = 'RMScheduler';

        $data["Title"] =   'Generate Rate Table';
        $data["Description"] = 'Generate Rate Table';
        $data["Options"] =  json_encode($options);
        $data["created_at"] = date('Y-m-d H:i:s');
        $data["updated_at"] = date('Y-m-d H:i:s');



       /* $validator = Validator::make($data, $rules);

        if ($validator->fails()) {
            return validator_response($validator);
        }
        */
      /*  if ($JobID = Job::insertGetId($data)) {
            return $JobID;
        } else {
            return 0;
        }
    }*/

    public static function GenerateRateTable($JobType, $options = "") {
        /*
         *  Generate Rate Table Log
         */

        $jobType = JobType::where(["Code" => $JobType])->get(["JobTypeID", "Title"]);
        $jobStatus = JobStatus::where(["Code" => "P"])->get(["JobStatusID"]);
        $CompanyID = $options['CompanyID'];
        $data["CompanyID"] = $CompanyID;
        $data["JobTypeID"] = isset($jobType[0]->JobTypeID) ? $jobType[0]->JobTypeID : '';
        $data["JobStatusID"] = isset($jobStatus[0]->JobStatusID) ? $jobStatus[0]->JobStatusID : '';
        $data["JobLoggedUserID"] = 0;
        $data["CreatedBy"] = 'RM Scheduler';
        if(!empty($options['ratetablename'])){
            $ratetablename = $options['ratetablename'];
        }else{
            $ratetablename = '';
        }
        $data["Title"] =   $ratetablename;
        $data["Description"] = isset($jobType[0]->Title) ? $jobType[0]->Title : '';
        $data["Options"] =  json_encode($options);
        $jobdata["created_at"] = date('Y-m-d H:i:s');
        $data["updated_at"] = date('Y-m-d H:i:s');

        if ($JobID = Job::insertGetId($data)) {
            return $JobID;
        } else {
            return 0;
        }
    }

    public static function getfileName($AccountID,$trunks,$file_prefix){
        $trunkname = '';
        if(isset($trunks) && !is_array($trunks)){
            $trunkname = '_'.str_replace(' ','',DB::table('tblTrunk')->where(array('TrunkID'=>$trunks))->pluck('Trunk'));
        }
        $file_name = Str::slug($file_prefix.'_'.Account::find($AccountID)->AccountName.'_'. $trunkname.'_'. date('YmdHis'));
        return $file_name;

    }

    public static function send_job_status_email($job,$CompanyID){

        /** Send Job Failed Email **/
        $query = "CALL prc_WSGetJobDetails (" . $job->JobID .")";
        $result = DataTableSql::of($query)->getProcResult(array('JobData'));
        $CompanyName = Company::where("CompanyID",$CompanyID)->pluck("CompanyName");

        $User = User::getUserInfo($job->JobLoggedUserID);
        if($User->JobNotification==1) {
            $UserEmail = $User->EmailAddress;
            $userName = $User->FirstName . ' ' . $User->LastName;
            if ($UserEmail != '') {
                $status = Helper::sendMail('emails.invoices.bulk_invoice_email_status',
                    array(
                        'EmailTo' => $UserEmail,
                        'EmailToName' => $userName,
                        'Subject' => $result['data']['JobData'][0]->JobTitle,
                        'CompanyID' => $CompanyID,
                        'data' => array("job_data" => $result, 'CompanyName' => $CompanyName)
                    ));
                Job::find($job->JobID)->update(array('EmailSentStatus' => $status['status'], 'EmailSentStatusMessage' => $status['message']));
            }
        }
    }
    public static function send_job_status_email_list($job,$CompanyID,$EmailList){

       if(!empty($EmailList)){
            $query = "CALL prc_WSGetJobDetails (" . $job->JobID .")";
            $result = DataTableSql::of($query)->getProcResult(array('JobData'));
            $CompanyName = Company::where("CompanyID",$CompanyID)->pluck("CompanyName");
            foreach ($EmailList as $singleemail) {
                $singleemail = trim($singleemail);
                if (filter_var($singleemail, FILTER_VALIDATE_EMAIL)) {
                    $emaildata['EmailTo'] = $singleemail;
                    $emaildata['EmailToName'] = $CompanyName;
                    $emaildata['Subject'] =$result['data']['JobData'][0]->JobTitle;
                    $emaildata['CompanyID'] = $CompanyID;
                    $emaildata['data'] =array('job_data' => $result, 'CompanyName'=>$CompanyName);
    
                    $status = Helper::sendMail('emails.invoices.bulk_invoice_email_status',$emaildata);
                    Job::find($job->JobID)->update(array('EmailSentStatus'=>$status['status'],'EmailSentStatusMessage'=>$status['message']));
                }
            }
        }
    }
    public static function JobStatusProcess($JobID,$ProcessID,$PID){
        $jobdata = array();
        $jobdata['JobStatusID'] = 2;
        $jobdata['ProcessID'] = $ProcessID;
        $jobdata['PID'] = $PID; //Added by abubakar
        $jobdata['LastRunTime'] = date("Y-m-d H:i:s");
        Job::where(["JobID" => $JobID])->update($jobdata);
    }

    public static function CreateJob($CompanyID,$job_type,$Options){
        $UserID = User::where("CompanyID",$CompanyID)->where(["AdminUser"=>1,"Status"=>1])->min("UserID");
        $jobType = JobType::where(["Code" => $job_type])->get(["JobTypeID", "Title"]);
        $jobStatus = JobStatus::where(["Code" => "P"])->get(["JobStatusID"]);
        $jobdata = array();
        $jobdata["CompanyID"] = $CompanyID;
        $jobdata["JobTypeID"] = isset($jobType[0]->JobTypeID) ? $jobType[0]->JobTypeID : '';
        $jobdata["JobStatusID"] = isset($jobStatus[0]->JobStatusID) ? $jobStatus[0]->JobStatusID : '';
        $jobdata["JobLoggedUserID"] = $UserID;
        $jobdata["Title"] =  "[Auto] " . (isset($jobType[0]->Title) ? $jobType[0]->Title : '');
        $jobdata["Description"] = isset($jobType[0]->Title) ? $jobType[0]->Title : '';
        $jobdata["CreatedBy"] = "System";
        $jobdata["Options"] = json_encode($Options);
        $jobdata["created_at"] = date('Y-m-d H:i:s');
        $jobdata["updated_at"] = date('Y-m-d H:i:s');
        return $JobID = Job::insertGetId($jobdata);
    }

    public static function CreateAutoImportJob($CompanyID,$job_type,$options){

        switch ($job_type) {

            case 'VU':

                $UserID = User::where("CompanyID", $CompanyID)->where(["AdminUser" => 1, "Status" => 1])->min("UserID");
                $jobType = JobType::where(["Code" => $job_type])->get(["JobTypeID", "Title"]);
                $jobStatus = JobStatus::where(["Code" => "P"])->get(["JobStatusID"]);
                $jobdata = array();
                $jobdata["CompanyID"] = $CompanyID;
                $jobdata["AccountID"] = $options["AccountID"];
                $jobdata["JobTypeID"] = isset($jobType[0]->JobTypeID) ? $jobType[0]->JobTypeID : '';
                $jobdata["JobStatusID"] = isset($jobStatus[0]->JobStatusID) ? $jobStatus[0]->JobStatusID : '';
                $jobdata["JobLoggedUserID"] = $UserID;
                $AccountName = Account::where(["AccountID" => $options["AccountID"]])->pluck('AccountName');
                $jobdata["Title"] = $AccountName;
                $jobdata["Description"] = $AccountName . ' ' . isset($jobType[0]->Title) ? $jobType[0]->Title : '';
                $jobdata["CreatedBy"] = "System";
                $jobdata["created_at"] = date('Y-m-d H:i:s');
                $jobdata["updated_at"] = date('Y-m-d H:i:s');
                $JobID = Job::insertGetId($jobdata);

                /* Job Insert Here */
                if ($JobID) {
                    $data = array();
                    $data["JobID"] = $JobID;
                    $data["FileName"] = basename($options["full_path"]);
                    $data["FilePath"] = $options["full_path"];
                    $data["HttpPath"] = 0;
                    $data["Options"] =  json_encode(self::removeUnnecesorryOptions($jobType,$options) );
                    $data["CreatedBy"] = 'System';
                    $data["created_at"] = date('Y-m-d H:i:s');
                    $data["updated_at"] = date('Y-m-d H:i:s');
                    if ($JobFileID = JobFile::insertGetId($data)) {
                        // return $JobFileID;
                        return $JobID;
                    } else {
                        // error code
                    }
                }

            case 'PRTU':
            case 'DRTU':
            case 'RTU':

                $UserID = User::where("CompanyID", $CompanyID)->where(["AdminUser" => 1, "Status" => 1])->min("UserID");
                $jobType = JobType::where(["Code" => $job_type])->get(["JobTypeID", "Title"]);
                $jobStatus = JobStatus::where(["Code" => "P"])->get(["JobStatusID"]);
                $jobdata = array();
                $jobdata["CompanyID"] = $CompanyID;
                $options["CompanyID"] = $CompanyID;
                $jobdata["JobTypeID"] = isset($jobType[0]->JobTypeID) ? $jobType[0]->JobTypeID : '';
                $jobdata["JobStatusID"] = isset($jobStatus[0]->JobStatusID) ? $jobStatus[0]->JobStatusID : '';
                $jobdata["JobLoggedUserID"] = $UserID;
                $jobdata["Title"] =  $options['ratetablename']; // New check this
                $jobdata["Description"] = isset($jobType[0]->Title) ? $jobType[0]->Title : '';
                $jobdata["CreatedBy"] = "System";
                // $jobdata["Options"] = json_encode($options);
                $jobdata["created_at"] = date('Y-m-d H:i:s');
                $jobdata["updated_at"] = date('Y-m-d H:i:s');
                $JobID = Job::insertGetId($jobdata);

                /* Job Insert Here */
                if ($JobID) {
                    $data = array();
                    $data["JobID"] = $JobID;
                    $data["FileName"] = basename($options["full_path"]);
                    $data["FilePath"] = $options["full_path"];
                    $data["HttpPath"] = 0;
                    $data["Options"] =  json_encode(self::removeUnnecesorryOptions($jobType,$options) );
                    //$data["Options"] = '';
                    $data["CreatedBy"] = 'System';
                    $data["created_at"] = date('Y-m-d H:i:s');
                    $data["updated_at"] = date('Y-m-d H:i:s');
                    if ($JobFileID = JobFile::insertGetId($data)) {
                       // return $JobFileID;
                        return $JobID;
                    } else {
                        // error code
                    }
                }

        }


    }
    public static function removeUnnecesorryOptions( $type , $options = array()){
        if(!empty($options)){
            $unset_array = array("AccountID","CompanyID","full_path");
            foreach($unset_array as $unset_keys){
                if(isset($options[$unset_keys])){
                    unset($options[$unset_keys]);
                }
            }
        }
        return $options;

    }


}