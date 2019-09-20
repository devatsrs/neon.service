<?php
namespace App\Console\Commands;


use App\Lib\AccountBalance;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Summary;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;

class CreateSummaryLive extends Command{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'createsummarylive';

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
            ['CronJobID', InputArgument::REQUIRED, 'Argument CronJobID']
        ];
    }


    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle()
    {

        CronHelper::before_cronrun($this->name, $this );


        $arguments = $this->argument();
        $CompanyID = $arguments["CompanyID"];
        $CronJobID = $arguments["CronJobID"];
        $CronJob =  CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);
        CronJob::activateCronJob($CronJob);
        CronJob::createLog($CronJobID);
        Log::useFiles(storage_path() . '/logs/createsummarylive-' . $CompanyID . '-' . date('Y-m-d') . '.log');
        try {

            Summary::generateSummary($CompanyID,1,[],$CronJob);
            /** update unbilled amount*/
            AccountBalance::updateAccountUnbilledAmount($CompanyID);
            /** update SOA amount also*/
            AccountBalance::getOutstandingAmount($CompanyID,0);
            $joblogdata['Message'] = 'Success';
            $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;

        } catch (\Exception $e) {
            Log::error($e);
            $joblogdata['Message'] ='Error:'.$e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            if(!empty($cronsetting['ErrorEmail'])) {

                $result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
                Log::error("**Email Sent Status " . $result['status']);
                Log::error("**Email Sent message " . $result['message']);
            }
        }
        CronJobLog::createLog($CronJobID,$joblogdata);
        CronJob::deactivateCronJob($CronJob);
        Log::error(" CronJobId end" . $CronJobID);
        if(!empty($cronsetting['SuccessEmail'])) {
            $result = CronJob::CronJobSuccessEmailSend($CronJobID);
            Log::error("**Email Sent Status ".$result['status']);
            Log::error("**Email Sent message ".$result['message']);
        }

        CronHelper::after_cronrun($this->name, $this);

    }

}
