<?php namespace App\Console\Commands;

use App\Lib\AccountBalance;
use App\Lib\ActiveCall;
use App\Lib\CronHelper;
use App\Lib\Helper;
use App\Lib\SpeakIntelligenceAPI;
use Illuminate\Console\Command;
use Symfony\Component\Console\Input\InputArgument;
use App\Lib\CompanyGateway;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\AccountPaymentAutomation;
use App\Lib\Company;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Config;
use \Exception;

class ProcessActiveCall extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'processactivecall';

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
        CronHelper::before_cronrun($this->name, $this );

        $arguments = $this->argument();
        $CompanyID = $arguments['CompanyID'];
        $CronJobID = $arguments['CronJobID'];
        $CronJob =  CronJob::find($CronJobID);
        CronJob::activateCronJob($CronJob);


        $cronsetting = json_decode($CronJob->Settings,true);

        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';

        CronJob::createLog($CronJobID);

        Log::useFiles(storage_path() . '/logs/processactivecall-' . date('Y-m-d') . '.log');
        Log::error(' ========================== Process active Call start =============================');


        try {
            $processID = CompanyGateway::getProcessID();
            CompanyGateway::updateProcessID($CronJob,$processID);

            DB::beginTransaction();

            Log::error("CALL  prc_ProcessActiveCallCost ('" . $processID . "') start");
            DB::statement("CALL  prc_ProcessActiveCallCost ('" . $processID . "')");
            Log::error("CALL  prc_ProcessActiveCallCost ('" . $processID . "') end");

            DB::commit();

            $joblogdata['Message'] = 'Success';
            $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;

            CronJobLog::insert($joblogdata);

        } catch (\Exception $e) {
            try {
                DB::rollback();
            } catch (\Exception $err) {
                Log::error($err);
            }
            $this->info('Failed:' . $e->getMessage());
            $joblogdata['Message'] = 'Error:' . $e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            CronJobLog::insert($joblogdata);
            Log::error($e);
            if(!empty($cronsetting['ErrorEmail'])) {
                $result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
                Log::error("**Email Sent Status " . $result['status']);
                Log::error("**Email Sent message " . $result['message']);
            }
        }


        CronJob::deactivateCronJob($CronJob);
        if(!empty($cronsetting['SuccessEmail'])) {
            $result = CronJob::CronJobSuccessEmailSend($CronJobID);
            Log::error("**Email Sent Status ".$result['status']);
            Log::error("**Email Sent message ".$result['message']);
        }

        Log::error(' ========================== active cronjob end =============================');

        CronHelper::after_cronrun($this->name, $this);

    }

}
