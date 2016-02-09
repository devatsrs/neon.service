<?php
namespace App\Console\Commands;

use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\EmailTemplate;
use App\Lib\Invoice;
use Symfony\Component\Console\Input\InputArgument;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Lib\Job;
use Webpatser\Uuid\Uuid;
use App\Lib\Helper;
use App\Lib\Company;
use \Exception;

class AutoInvoiceReminder extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'autoinvoicereminder';

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
            ['CronJobID', InputArgument::REQUIRED, 'Argument CronJobID '],
        ];
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function fire()
    {
        $arguments = $this->argument();
        $getmypid = getmypid(); // get proccess id
        $CronJobID = $arguments["CronJobID"];
        $CompanyID = $arguments["CompanyID"];
        $CronJob = CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);

        $dataactive['Active'] = 1;
        $dataactive['PID'] = $getmypid;
        $CronJob->update($dataactive);
        Log::useFiles(storage_path() . '/logs/autoinvoicereminder-' . $CronJobID . '-' . date('Y-m-d') . '.log');
        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';
        $processID = Uuid::generate();
        try {
            Log::error(' ========================== auto invoice reminder start =============================');
            DB::beginTransaction();
            CronJob::createLog($CronJobID);
            $Options = array();
            $JobID = 0;

            $EmailTemplate = EmailTemplate::find($cronsetting['TemplateID']);
            if (!empty($EmailTemplate)) {
                $Options['subject'] = $EmailTemplate->Subject;
                if (!empty($cronsetting['AccountID'])) {
                    $Invoice = Invoice::where(array('AccountID'=>$cronsetting['AccountID'],'InvoiceType'=>Invoice::INVOICE_OUT))->orderBy('InvoiceID', 'desc')->first();
                    $Options['SelectedIDs'] = $Invoice->InvoiceID;
                    $Options['criteria'] = '';
                } else {
                    $Options['SelectedIDs'] = '';
                    $Options['criteria'] = '';
                }
                $Options['message'] = $EmailTemplate->TemplateBody;
                $Options['attachment'] = '';
                $Options['test'] = '0';
                $Options['testEmail'] = '';
                $JobID = Job::CreateJob($CompanyID, 'IR', $Options);
            }
            $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
            CronJobLog::insert($joblogdata);
            DB::commit();
            if ($JobID > 0) {
                pclose(popen("start /B " . env('PHPExePath') . " " . env('RMArtisanFileLocation') . " invoicereminder " . $CompanyID . " " . $JobID . " ", "r"));
            }
            Log::error(' ========================== auto invoice reminder end =============================');

        } catch (\Exception $e) {
            Log::error("auto invoice reminder" . $CronJobID);
            DB::rollback();
            $this->info('Failed:' . $e->getMessage());
            $joblogdata['Message'] = 'Error:' . $e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            CronJobLog::insert($joblogdata);
            Log::error("RateGenerator : " . $e->getMessage());
            if(!empty($cronsetting['ErrorEmail'])) {
                $result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
                Log::error("**Email Sent Status " . $result['status']);
                Log::error("**Email Sent message " . $result['message']);
            }
        }
        $dataactive['Active'] = 0;
        $dataactive['PID'] = '';
        $CronJob->update($dataactive);
        if(!empty($cronsetting['SuccessEmail'])) {
            $result = CronJob::CronJobSuccessEmailSend($CronJobID);
            Log::error("**Email Sent Status ".$result['status']);
            Log::error("**Email Sent message ".$result['message']);
        }
        Log::error("auto invoice reminder" . $CronJobID);
    }
}