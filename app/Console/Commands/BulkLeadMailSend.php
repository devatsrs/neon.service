<?php namespace App\Console\Commands;

use App\Lib\Account;
use App\lib\AmazonS3;
use App\Lib\Company;
use App\Lib\CompanyConfiguration;
use App\Lib\CronHelper;
use App\Lib\Helper;
use App\Lib\Job;
use App\Lib\JobType;
use App\Lib\User;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;

class BulkLeadMailSend extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'bulkleademailsend';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'bulk lead email send.';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct(){
        parent::__construct();
    }
    /**
     * Get the console command arguments.
     *
     * @return array
     */
    protected function getArguments()
    {
        return [
            ['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID'],
            ['JobID', InputArgument::REQUIRED, 'Argument JobID '],
        ];
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function fire()
    {

        CronHelper::before_cronrun($this->name, $this );

        $arguments = $this->argument();
        $getmypid = getmypid(); // get proccess id added by abubakar
        $JobID = $arguments["JobID"];
        $job = Job::find($JobID);

        $jobType = JobType::where(['JobTypeID'=>$job->JobTypeID])->pluck('Code');
        $CompanyID = $arguments["CompanyID"];
        $EMAIL_TO_CUSTOMER = CompanyConfiguration::get($CompanyID,'EMAIL_TO_CUSTOMER');
        $TEMP_PATH = CompanyConfiguration::get($CompanyID,'TEMP_PATH').'/';
        $errors = array();
        $errorslog = array();
        try {
            $ProcessID = Uuid::generate();
            Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar

            if(!empty($job)){
                $JobLoggedUser = User::find($job->JobLoggedUserID);
                $joboptions = json_decode($job->Options);
                if(count($joboptions)>0){
                    $ids = $joboptions->SelectedIDs;
                    $criteria = '';
                    if(!empty($joboptions->criteria)){
                        $criteria = json_decode($joboptions->criteria);
                    }
                    if(!empty($joboptions->attachment)){
                        $path = AmazonS3::unSignedUrl($joboptions->attachment,$CompanyID);
                        if(strpos($path, "https://") !== false){
                            $file = $TEMP_PATH.basename($path);
                            file_put_contents($file,file_get_contents($path));
                            $joboptions->attachment = $file;
                        }else{
                            $joboptions->attachment=$path;
                        }
                    }
                    $count = 0;
                    if(!empty($ids)) {
                        $ids = explode(',',$ids);
                        if(count($ids)>0){
                            foreach($ids as $id) {
                                $account = Account::find($id);
                                $emaildata['EmailTo'] = '';
                                if($joboptions->test==1){
                                    $emaildata['EmailTo'] = $joboptions->testEmail;
                                }else if($EMAIL_TO_CUSTOMER == 1){
                                    $emaildata['EmailTo'] = $account->Email;//$account->Email;
                                }

                                if ($emaildata['EmailTo'] != "") {

                                    if(!empty($joboptions->attachment)){
                                        $emaildata['attach'] = $joboptions->attachment;
                                    }

                                    $emaildata['EmailToName'] = $account->AccountName;
                                    $replace_array = Helper::create_replace_array($account,array(),$JobLoggedUser);
                                    $message =  template_var_replace($joboptions->message,$replace_array);
                                    $emaildata['Subject']   = $joboptions->subject;
                                    $emaildata['Message']   = $message;
                                    $emaildata['CompanyID'] = $CompanyID;

                                    $emaildata['mandrill'] = 1;
									if(isset($joboptions->email_from))
									{
										$emaildata['EmailFrom'] = $joboptions->email_from;
									}
									
                                    $status = Helper::sendMail('emails.template', $emaildata);
                                    if (isset($status["status"]) && $status["status"] == 0) {
                                        $errors[] = $account->AccountName.', '.$status["message"];
                                    } else{
                                        /** log emails against account */
                                        $statuslog = Helper::account_email_log($CompanyID,$account->AccountID,$emaildata,$status,$JobLoggedUser,$ProcessID,$JobID);

                                        if($statuslog['status']==0) {
                                            $errorslog[] = $account->AccountName . ' email log exception:' . $statuslog['message'];
                                        }
                                        $count++;
                                    }
                                }else{
                                    $errors[] = $account->AccountName.', '.' Email Not Found';
                                }
                            }
                        }else{
                            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                            $jobdata['JobStatusMessage'] = 'No Data Found';
                        }
                    }else{
                        if(!empty($criteria)){
                            $account=Account::leftjoin('tblUser', 'tblAccount.Owner', '=', 'tblUser.UserID')->select('tblAccount.*');
                            $account->where(["tblAccount.CompanyID" => $CompanyID]);
                            if($jobType=='BLE'){
                                $account->where(["tblAccount.AccountType"=>0]);
                            }else{
                                $account->where(["tblAccount.AccountType"=>1]);
                            }
                            if(isset($criteria->account_name) && !empty($criteria->account_name)) {
                                $account->where('tblAccount.AccountName', 'like','%'.$criteria->account_name.'%');
                            }
                            if(isset($criteria->account_number) && !empty($criteria->account_number)) {
                                $account->where('tblAccount.Number','like', '%'.$criteria->account_number.'%');
                            }
                            if( isset($criteria->contact_name) &&!empty($criteria->contact_name)) {
                                $account->leftjoin('tblContact', 'tblContact.Owner', '=', 'tblAccount.AccountID');
                                $account->whereRaw(  " CONCAT(tblContact.FirstName,' ',tblContact.LastName) like '%".$criteria->contact_name."%'");
                            }
                            if(isset($criteria->account_active)) {
                                if($criteria->account_active == 'true' ) {
                                    $account->where('tblAccount.Status', 1);
                                }else{
                                    $account->where('tblAccount.Status', 0);
                                }
                            }
                            if(isset($criteria->vendor_on_off) && $criteria->vendor_on_off == 'true' ) {
                                $account->where('tblAccount.IsVendor', 1);
                            }
                            if(isset($criteria->customer_on_off) && $criteria->customer_on_off == 'true' ) {
                                $account->where('tblAccount.IsCustomer', 1);
                            }
                            if(isset($criteria->verification_status) && trim($criteria->verification_status) >= 0) {
                                $account->where('tblAccount.VerificationStatus', (int)$criteria->verification_status);
                            }

                            if(isset($criteria->tag) && trim($criteria->tag) != '') {
                                $account->where('tblAccount.tags', 'like','%'.trim($criteria->tag).'%');
                            }
                            if (isset($criteria->low_balance) && $criteria->low_balance == 'true') {
                                $account->leftjoin('tblAccountBalance', 'tblAccountBalance.AccountID', '=', 'tblAccount.AccountID');
                                $account->whereRaw("(CASE WHEN tblAccountBalance.BalanceThreshold LIKE '%p' THEN REPLACE(tblAccountBalance.BalanceThreshold, 'p', '')/ 100 * tblAccountBalance.PermanentCredit ELSE tblAccountBalance.BalanceThreshold END) < tblAccountBalance.BalanceAmount");
                            }

                            if(isset($criteria->account_owners)  && trim($criteria->account_owners) > 0) {
                                $account->where('tblAccount.Owner', (int)$criteria->account_owners);
                            }
                            //DB::enableQueryLog();
                            $result = $account->get();
                            if(!empty($result)){
                                foreach($result as $account) {
                                    if (!empty($account->Email)) {
                                        if($EMAIL_TO_CUSTOMER == 1){
                                            $emaildata['EmailTo'] = $account->Email;//$account->Email;
                                        }

                                        if(!empty($joboptions->attachment)){
                                            $emaildata['attach'] = $joboptions->attachment;
                                        }
                                        $emaildata['EmailToName'] = $account->AccountName;
                                        $replace_array = Helper::create_replace_array($account,array(),$JobLoggedUser);
                                        //$joboptions->message = template_var_replace($joboptions->message,$replace_array);
										$message =  template_var_replace($joboptions->message,$replace_array);
                                        $emaildata['Subject'] = $joboptions->subject;
                                        $emaildata['Message'] = $message;
                                        $emaildata['CompanyID'] = $CompanyID;

                                        $emaildata['mandrill'] = 1;
                                        $status = Helper::sendMail('emails.template', $emaildata);
                                        if (isset($status["status"]) && $status["status"] == 0) {
                                            $errors[] = $account->AccountName.', '.$status["message"];
                                            $jobdata['EmailSentStatus'] = $status['status'];
                                            $jobdata['EmailSentStatusMessage']= $status['message'];
                                        }else{
                                            /** log emails against account */
                                            $statuslog = Helper::account_email_log($CompanyID,$account->AccountID,$emaildata,$status,$JobLoggedUser,$ProcessID,$JobID);

                                            if($statuslog['status']==0) {
                                                $errorslog[] = $account->AccountName . ' email log exception:' . $statuslog['message'];
                                            }
                                            $count++;
                                        }
                                    }else{
                                        $errors[] = $account->AccountName.', '.' Email Not Found';
                                    }
                                }
                            }else{
                                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                                $jobdata['JobStatusMessage'] = 'No Data Found';
                            }
                      }else{
                            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                            $jobdata['JobStatusMessage'] = 'No selected id, No criteria';
                      }
                   }
                }else{
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                    $jobdata['JobStatusMessage'] = 'No Data Found';
                }
            }else{
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                $jobdata['JobStatusMessage'] = 'No Data Found';
            }
            $testemail = ($joboptions->test==1?'testemail,':'');
            if(count($errors)>0 || count($errorslog)>0){
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','PF')->pluck('JobStatusID');
                if(count($errors)>0){
                    $jobdata['JobStatusMessage'] = $testemail.' '.$count.' Email sent, '.count($errors).' Skipped account: '.implode(',\n\r',$errors);
                }else{
                    $jobdata['JobStatusMessage'] = $testemail.' '.$count.' Email sent, '.count($errorslog).' Email log errors: '.implode(',\n\r',$errorslog);
                }
            }else{
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','S')->pluck('JobStatusID');
                $jobdata['JobStatusMessage'] = $testemail.' '.$count." Email sent, Email successfully send to all.";
            }
            $jobdata['updated_at'] = date('Y-m-d H:i:s');
            $jobdata['ModifiedBy'] = 'RMScheduler';
            Job::where(["JobID" => $JobID])->update($jobdata);
            DB::commit();
            Job::send_job_status_email($job,$CompanyID);

        } catch (\Exception $e) {
            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','F')->pluck('JobStatusID');
            $jobdata['JobStatusMessage'] = 'Exception: '.$e->getMessage();
            $jobdata['updated_at'] = date('Y-m-d H:i:s');
            $jobdata['ModifiedBy'] = 'RMScheduler';
            Job::where(["JobID" => $JobID])->update($jobdata);
            Log::error($e);
            Job::send_job_status_email($job,$CompanyID);
        }

        CronHelper::after_cronrun($this->name, $this);

    }
}