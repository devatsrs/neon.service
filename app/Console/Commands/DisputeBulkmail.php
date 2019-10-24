<?php
namespace App\Console\Commands;

use App\Lib\Account;
use App\Lib\Company;
use App\Lib\CompanyConfiguration;
use App\Lib\CronHelper;
use App\Lib\Dispute;
use App\Lib\Helper;
use App\Lib\Invoice;
use App\Lib\InvoiceLog;
use App\Lib\User;
use App\lib\AmazonS3;
use Symfony\Component\Console\Input\InputArgument;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Config;
use App\Lib\Job;
use Webpatser\Uuid\Uuid;

class DisputeBulkmail extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'disputebulkemail';

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
    public function __construct()
    {
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
        $getmypid = getmypid(); // get proccess id
        $JobID = $arguments["JobID"];
        $job = Job::find($JobID);

        $CompanyID = $arguments["CompanyID"];
        $EMAIL_TO_CUSTOMER = CompanyConfiguration::get($CompanyID,'EMAIL_TO_CUSTOMER');
        $TEMP_PATH = CompanyConfiguration::get($CompanyID,'TEMP_PATH').'/';
        $errors = array();
        $errorslog = array();
        Log::useFiles(storage_path().'/logs/disputebulkmail-'.$JobID.'-'.date('Y-m-d').'.log');
        try {
            $ProcessID = Uuid::generate();
            Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar

            if (!empty($job)) {
                $JobLoggedUser = User::find($job->JobLoggedUserID);
                $joboptions = json_decode($job->Options);
                if (count($joboptions) > 0) {
                    $ids = $joboptions->SelectedIDs;
                    $criteria = '';
                    if (!empty($joboptions->criteria)) {
                        $criteria = json_decode($joboptions->criteria);
                    }
                    if (!empty($joboptions->attachment)) {
                        $path = AmazonS3::unSignedUrl($joboptions->attachment,$CompanyID);
                        if (strpos($path, "https://") !== false) {
                            $file = $TEMP_PATH . basename($path);
                            file_put_contents($file, file_get_contents($path));
                            $joboptions->attachment = $file;
                        } else {
                            $joboptions->attachment = $path;
                        }
                    }
                    $count = 0;
                    if (!empty($ids)) {
                        $ids = explode(',', $ids);
                        $disputequery=Dispute::where('CompanyID',$CompanyID)->whereIn('DisputeID',$ids);
                        $result = $disputequery->get();
                    } else if (!empty($criteria)) {
                        $AccountID = empty($criteria->AccountID)?'NULL':$criteria->AccountID;
                        $InvoiceNumber =empty($criteria->InvoiceNo)?'NULL':$criteria->InvoiceNo;
                        $DisputeStartDate = $criteria->DisputeDate_StartDate!=''?$criteria->DisputeDate_StartDate:'NULL';
                        $DisputeEndDate = $criteria->DisputeDate_EndDate!=''?$criteria->DisputeDate_EndDate:'NULL';
                        $InvoiceType = $criteria->InvoiceType == 'All'?'':$criteria->InvoiceType;
                        $Status = isset($criteria->Status) && $criteria->Status != ''?$criteria->Status:'NULL';
                        $tag =isset($criteria->tag) && $criteria->tag!='' ?$criteria->tag:'';

                        $p_disputestart			 =		'NULL';
                        $p_disputeend			 =		'NULL';

                        if($DisputeStartDate!='' && $DisputeStartDate!='NULL')
                        {
                            $p_disputestart		=	"'".$DisputeStartDate."'"; //.' '.$data['p_disputestartTime']."'";
                        }
                        if($DisputeEndDate!='' && $DisputeEndDate!='NULL')
                        {
                            $p_disputeend			=	"'".$DisputeEndDate."'"; //.' '.$data['p_disputeendtime']."'";
                        }

                        if($p_disputestart!='NULL' && $p_disputeend=='')
                        {
                            $p_disputeend			= 	"'".date("Y-m-d H:i:s")."'";
                        }

                        $query = "call prc_getDisputes (".$CompanyID.",".intval($InvoiceType).",".$AccountID.",".$InvoiceNumber.",".$Status.",".$p_disputestart.",".$p_disputeend.",'','','','',2,'".$tag."')";
                        Log::info($query);
                        $result = DB::connection('sqlsrv2')->select($query);
                        Log::info("-------Results----");
                        Log::info(print_r($result,true));
                    }
                    if (!empty($result)) {
                        foreach ($result as $dispute) {
                            $Account = Account::find($dispute->AccountID);

                            if (!empty($Account->Email)) {
                                if($joboptions->test==1){
                                    $emaildata['EmailTo'] = $joboptions->testEmail;
                                }else if ($EMAIL_TO_CUSTOMER == 1) {
                                    //$emaildata['EmailTo'] = $Account->Email;//$invoice->Email;
                                    $emaildata['EmailTo'] = $Account->BillingEmail;//$invoice->Email;
                                }

                                if (!empty($joboptions->attachment)) {
                                    $emaildata['attach'] = $joboptions->attachment;
                                }

                                $emaildata['EmailToName'] = $Account->AccountName;

                                $replace_array['InvoiceNumber'] = $dispute->InvoiceNo;
                                $replace_array = Helper::create_replace_array($Account,$replace_array,$JobLoggedUser);
                                //$joboptions->message = template_var_replace($joboptions->message,$replace_array);
								$message =  template_var_replace($joboptions->message,$replace_array);

                                $emaildata['Subject'] = $joboptions->subject;
                                $emaildata['Message'] = $message;
                                $emaildata['CompanyID'] = $CompanyID;

                                $emaildata['mandrill'] = 1;
                                $status = Helper::sendMail('emails.template', $emaildata);
                                if (isset($status["status"]) && $status["status"] == 0) {
                                    $errors[] = $Account->AccountName . ', ' . $status["message"];
                                    $jobdata['EmailSentStatus'] = $status['status'];
                                    $jobdata['EmailSentStatusMessage'] = $status['message'];
                                } else {

                                    /** log emails against account */
                                    $statuslog = Helper::account_email_log($CompanyID,$Account->AccountID,$emaildata,$status,$JobLoggedUser,$ProcessID,$JobID);
                                    if($statuslog['status']==0) {
                                        $errorslog[] = $Account->AccountName . ' email log exception:' . $statuslog['message'];
                                    }
                                    $count++;
                                }
                            } else {
                                $errors[] = $Account->AccountName . ', ' . ' Email Not Found';
                            }
                        }
                    } else {
                        $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                        $jobdata['JobStatusMessage'] = 'No Data Found';
                    }

                } else {
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                    $jobdata['JobStatusMessage'] = 'No Data Found';
                }
            } else {
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                $jobdata['JobStatusMessage'] = 'No Data Found';
            }
            $testemail = ($joboptions->test == 1 ? 'testemail,' : '');
            if(count($errors)>0 || count($errorslog)>0){
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','PF')->pluck('JobStatusID');
                if(count($errors)>0){
                    $jobdata['JobStatusMessage'] = $testemail.' '.$count.' Email sent, '.count($errors).' Skipped account: '.implode(',\n\r',$errors);
                }else{
                    $jobdata['JobStatusMessage'] = $testemail.' '.$count.' Email sent, '.count($errorslog).' Email log errors: '.implode(',\n\r',$errorslog);
                }
            } else {
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'S')->pluck('JobStatusID');
                $jobdata['JobStatusMessage'] = $testemail . ' ' . $count . " Email sent, Email successfully send to all.";
            }
            $jobdata['updated_at'] = date('Y-m-d H:i:s');
            $jobdata['ModifiedBy'] = 'RMScheduler';
            Job::where(["JobID" => $JobID])->update($jobdata);
            Job::send_job_status_email($job, $CompanyID);

        } catch (\Exception $e) {
            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
            $jobdata['JobStatusMessage'] = 'Exception: ' . $e->getMessage();
            $jobdata['updated_at'] = date('Y-m-d H:i:s');
            $jobdata['ModifiedBy'] = 'RMScheduler';
            Job::where(["JobID" => $JobID])->update($jobdata);
            Log::error($e);
            Job::send_job_status_email($job, $CompanyID);
        }

        CronHelper::after_cronrun($this->name, $this);

    }
}