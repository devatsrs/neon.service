<?php namespace App\Console\Commands;

use App\Lib\Account;
use App\Lib\AmazonS3;
use App\Lib\Company;
use App\Lib\CronHelper;
use App\Lib\DataTableSql;
use App\Lib\Helper;
use App\Lib\Invoice;
use App\Lib\Job;
use App\Lib\InvoiceDetail;
use App\Lib\User;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;

class InvoiceUsageFileGenerator extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'invoiceusagefilegenerator';

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

        $decimal_places = 2;

        $CompanyID = $arguments["CompanyID"];

        try {
            $ProcessID = Uuid::generate();
            Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar

            if (!empty($job)) {

                $joboptions = json_decode($job->Options);
                $AccountID = $job->AccountID;
                $InvoiceID = $joboptions->InvoiceID;

                if ($InvoiceID > 0 && $AccountID > 0) {

                    $fullPath = Invoice::generate_usage_file($InvoiceID);
                    if (!empty($fullPath)) {

                        $jobdata["OutputFilePath"] = $fullPath;
                        $jobdata['JobStatusMessage'] = 'Usage File Created Successfully';
                        $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'S')->pluck('JobStatusID');
                    } else {
                        $jobdata['JobStatusMessage'] = 'Failed Creating Usage File';
                        $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                    }
                }

                $jobdata['updated_at'] = date('Y-m-d H:i:s');
                $jobdata['ModifiedBy'] = 'RMScheduler';
                Job::where(["JobID" => $JobID])->update($jobdata);

                /** Send Email Who generated job */
                $this->send_job_status_email($job, $CompanyID);
            }
        } catch (\Exception $e) {
            Log::error($e);
            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','F')->pluck('JobStatusID');
            $jobdata['JobStatusMessage'] = 'Exception: '.$e->getMessage();
            $jobdata['updated_at'] = date('Y-m-d H:i:s');
            $jobdata['ModifiedBy'] = 'RMScheduler';
            Job::where(["JobID" => $JobID])->update($jobdata);

            /** Send Email Who generated job */
            $this->send_job_status_email($job,$CompanyID);
        }

        CronHelper::after_cronrun($this->name, $this);

    }

    public function send_job_status_email($job,$CompanyID){
        if(isset($job->JobLoggedUserID) && $job->JobLoggedUserID > 0 ) {

            $User = User::getUserInfo($job->JobLoggedUserID);
            $UserEmail= $User->EmailAddress;

            $query = "CALL prc_WSGetJobDetails(" . $job->JobID.")";
            $result = DataTableSql::of($query)->getProcResult(array('JobData'));

            $CompanyName = Company::where("CompanyID",$CompanyID)->pluck("CompanyName");
            $status = Helper::sendMail('emails.invoices.invoice_usage_file_email',
                array(
                    'EmailTo' => $UserEmail,
                    'EmailToName' => $CompanyName,
                    'Subject' => $result['data']['JobData'][0]->JobTitle,
                    'CompanyID' => $CompanyID,
                    'data' => array("job_data" => $result, 'CompanyName' => $CompanyName)
                ));
            Job::find($job->JobID)->update(array('EmailSentStatus'=>$status['status'],'EmailSentStatusMessage'=>$status['message']));
        }
    }


}
