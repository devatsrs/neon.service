<?php namespace App\Console\Commands;

use App\Lib\Account;
use App\Lib\BillingClass;
use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Invoice;
use App\Lib\Job;
use App\Lib\JobStatus;
use App\Lib\JobType;
use App\Lib\Product;
use App\Lib\RecurringInvoice;
use App\Lib\TaxRate;
use App\Lib\User;
use Exception;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputOption;
use Webpatser\Uuid\Uuid;

class ProcessCallCharges extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'processcallcharges';

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

    protected function getArguments()
    {
        return [
            ['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID '],
            ['CronJobID', InputArgument::REQUIRED, 'Argument CronJobID'],
        ];
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     * This CronJob is for automatic deduct usage call charge when our billing cycle
     * if that billing class enable deduct usage call charge on and account has auto pay on and auto payment method is account balance.
     */
    public function fire()
    {
        CronHelper::before_cronrun($this->name, $this );

        $arguments = $this->argument();
        $CronJobID = $arguments["CronJobID"];
        $CompanyID = (int)$arguments["CompanyID"];
        $CronJob = CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);
        CronJob::activateCronJob($CronJob);
        CronJob::createLog($CronJobID);
        Log::useFiles(storage_path() . '/logs/processcallcharges-' . $CronJobID . '-' . date('Y-m-d') . '.log');

        try {
            $ProcessID = CompanyGateway::getProcessID();
            $cronjobdata=array();

            $BillingClassCount = BillingClass::where(['DeductCallChargeInAdvance'=>1])->count();
            Log::info('Billing class - active Deductcallcharge count '.$BillingClassCount);
            if($BillingClassCount>0){
                $cronjobdata = Invoice::ProcessAccountCallCharges($CompanyID,$ProcessID);
            }
            if(count($cronjobdata)){
                $joblogdata['Message'] ='Success : '.implode(',<br>',$cronjobdata);
                $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
            }else{
                $joblogdata['Message'] = 'Success';
                $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
            }

        } catch (\Exception $e) {

            $this->info('Failed:' . $e->getMessage());
            $joblogdata['Message'] = 'Error:' . $e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            Log::error($e);
            if(!empty($cronsetting['ErrorEmail'])) {
                $result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
                Log::error("**Email Sent Status " . $result['status']);
                Log::error("**Email Sent message " . $result['message']);
            }
        }

        CronJob::deactivateCronJob($CronJob);
        CronJobLog::createLog($CronJobID,$joblogdata);
        if(!empty($cronsetting['SuccessEmail'])) {
            $result = CronJob::CronJobSuccessEmailSend($CronJobID);
            Log::error("**Email Sent Status ".$result['status']);
            Log::error("**Email Sent message ".$result['message']);
        }

        CronHelper::after_cronrun($this->name, $this);
    }
}
