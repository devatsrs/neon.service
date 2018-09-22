<?php namespace App\Console\Commands;

use App\Lib\JobStatus;
use App\Lib\JobType;
use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\Invoice;
use App\Lib\AmazonS3;
use App\Lib\Job;
use App\Lib\Currency;
use App\Lib\Country;
use App\Lib\JobFile;
use App\Lib\Service;
use App\Lib\User;
use App\Lib\Account;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\FileUploadTemplate;
use App\Lib\VendorFileUploadTemplate;
use App\Lib\NeonExcelIO;
use Maatwebsite\Excel\Facades\Excel;
use Illuminate\Support\Facades\DB;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;
use \Exception;

class SingleInvoiceGeneration extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'singleinvoicegeneration';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Command description.';

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
            ['AccountIDs', InputArgument::REQUIRED, 'Argument AccountIDs'],
            ['JobID', InputArgument::OPTIONAL, 'Argument JobID '],
        ];
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function fire()
    {
        Log::useFiles(storage_path() . '/logs/singleinvoicegeneration-' . date('Y-m-d') . '.log');

        CronHelper::before_cronrun($this->name, $this );
        $arguments = $this->argument();
        $getmypid = getmypid();
        $ProcessID = CompanyGateway::getProcessID();
        $JobID = $arguments["JobID"];
        $CompanyID = $arguments["CompanyID"];
        $SingleInvoice = $arguments["AccountIDs"];
        log::info('Single Invoice Accounts '.$SingleInvoice);
        $UserID = User::where("CompanyID", $CompanyID)->where(["AdminUser"=>1,"Status"=>1])->min("UserID");
        $today = date("Y-m-d");
        $date = date('Y-m-d H:i:s');

        $AutoInvoiceGeneratorCommandID = DB::table('tblCronJobCommand')->where(['Command'=>'invoicegenerator','CompanyID'=>$CompanyID,'Status'=>1])->pluck('CronJobCommandID');
        $CronJobID = CronJob::where(['CompanyID'=>$CompanyID,'CronJobCommandID'=>$AutoInvoiceGeneratorCommandID])->pluck('CronJobID');
        $CronJob =  CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);
        $InvoiceGenerationEmail = isset($cronsetting['SuccessEmail']) ? $cronsetting['SuccessEmail'] :'';
        $InvoiceGenerationEmail = explode(",",$InvoiceGenerationEmail);

        if((int)$JobID == 0) {
            $jobType = JobType::where(["Code" => 'BI'])->get(["JobTypeID", "Title"]);
            $jobStatus = JobStatus::where(["Code" => "I"])->get(["JobStatusID"]);
            $jobdata["CompanyID"] = $CompanyID;
            $jobdata["JobTypeID"] = isset($jobType[0]->JobTypeID) ? $jobType[0]->JobTypeID : '';
            $jobdata["JobStatusID"] = isset($jobStatus[0]->JobStatusID) ? $jobStatus[0]->JobStatusID : '';
            $jobdata["JobLoggedUserID"] = $UserID;
            $jobdata["Title"] = "[Auto] " . (isset($jobType[0]->Title) ? $jobType[0]->Title : '') . ' Generate & Send';
            $jobdata["Description"] = isset($jobType[0]->Title) ? $jobType[0]->Title : '';
            $jobdata["CreatedBy"] = "System";
            $jobdata["Options"] = json_encode(array("accounts" => '',"recurringInvoiceIDs"=>'','CronJobID'=>$CronJobID));
            $jobdata["created_at"] = $date;
            $jobdata["updated_at"] = $date;
            $JobID = Job::insertGetId($jobdata);
            $jobdata = array();
        }else{
            Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//
        }
        Log::info('JobID '.$JobID);
        try {
            $response = Invoice::GenerateInvoice($CompanyID,$InvoiceGenerationEmail,$ProcessID, $JobID,$SingleInvoice);
            $errors = isset($response['errors'])?$response['errors']:array();
            $message = isset($response['message'])?$response['message']:array();

            if(count($errors)>0){
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','PF')->pluck('JobStatusID');
                $jobdata['JobStatusMessage'] = (count($errors)>0?'Skipped account: '.implode(',\n\r',$errors):'');
            }else if(isset($message['accounts']) && $message['accounts'] != ''){
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','PF')->pluck('JobStatusID');
                $jobdata['JobStatusMessage'] = 'Skipped account: '.implode(',\n\r',$message);
            }else{
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','S')->pluck('JobStatusID');
                $jobdata['JobStatusMessage'] = 'Invoice created Successfully';
            }

            $jobdata['ModifiedBy'] = 'RMScheduler';
            Job::where(["JobID" => $JobID])->update($jobdata);
            $job = Job::find($JobID);
            Log::info(' ========================== Job Updated =============================');
            if(!empty($InvoiceGenerationEmail)){
                Job::send_job_status_email_list($job,$CompanyID,$InvoiceGenerationEmail);
            }else{
                Job::send_job_status_email($job,$CompanyID);
            }
            Log::info(' ========================== Job Email Sent =============================');

        }catch (\Exception $e) {

            try {
                Log::info(' ========================== Exception occured =============================');
                Log::error($e);
                if($JobID > 0) {
                    $job = Job::find($JobID);
                    $JobStatusMessage = $job->JobStatusMessage ;
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                    $jobdata['JobStatusMessage'] .= $JobStatusMessage . '\n\r'. $e->getMessage();
                    Job::where(["JobID" => $JobID])->update($jobdata);
                    $job = Job::find($JobID);
                    if(!empty($InvoiceGenerationEmail)){
                        Job::send_job_status_email_list($job,$CompanyID,$InvoiceGenerationEmail);
                    }else{
                        Job::send_job_status_email($job,$CompanyID);
                    }
                    Log::info(' ========================== Exception updated in job and email sent =============================');
                }

                Log::info(' =======================================================');

            } catch (Exception $err) {
                Log::error($err);
            }
            $this->info('Failed:' . $e->getMessage());
            $joblogdata['Message'] ='Error:'.$e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            if(!empty($cronsetting['ErrorEmail'])) {
                $result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
                Log::error("**Email Sent Status " . $result['status']);
                Log::error("**Email Sent message " . $result['message']);
            }
        }
        if(!empty($cronsetting['SuccessEmail'])){
            $result = CronJob::CronJobSuccessEmailSend($CronJobID);
            Log::error("**Email Sent Status ".$result['status']);
            Log::error("**Email Sent message ".$result['message']);
        }
        Log::error(" CronJobId end" . $CronJobID);

        CronHelper::after_cronrun($this->name, $this);
    }



}