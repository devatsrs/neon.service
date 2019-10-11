<?php namespace App\Console\Commands;

use App\Lib\AccountBalanceLog;
use App\Lib\CronHelper;
use App\Lib\Summary;
use Illuminate\Console\Command;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Retention;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use \Exception;
use Symfony\Component\Console\Input\InputArgument;
use App\Lib\CompanyGateway;

class PartnerAccountUsage extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'partneraccountusage';

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
	 */
    public function handle()
	{


		CronHelper::before_cronrun($this->name, $this );


		$arguments = $this->argument();
		$getmypid = getmypid(); // get proccess id
		$CompanyID = $arguments["CompanyID"];
		$CronJobID = $arguments["CronJobID"];
		$Limit = 100;

		$CronJob =  CronJob::find($CronJobID);
		CronJob::activateCronJob($CronJob);
		$processID = CompanyGateway::getProcessID();
		CompanyGateway::updateProcessID($CronJob,$processID);
		$cronsetting = json_decode($CronJob->Settings,true);
		$error = '';

		Log::useFiles(storage_path() . '/logs/partneraccountusage-' . $CompanyID . '-' . date('Y-m-d') . '.log');

		try{

			$joblogdata = array();
			$joblogdata['CronJobID'] = $CronJobID;
			$joblogdata['created_at'] = date('Y-m-d H:i:s');
			$joblogdata['created_by'] = 'RMScheduler';
			CronJob::createLog($CronJobID);

			Log::info('Partner Account Usage Start.');

			DB::connection('sqlsrvcdr')->beginTransaction();

            Log::error("CALL  prc_insertTempPartnerCDR ('" . $Limit . "','" . $processID . "') start");
			DB::connection('sqlsrvcdr')->statement("CALL  prc_insertTempPartnerCDR ('" . $Limit . "', '".$processID."' )");
            Log::error("CALL  prc_insertTempPartnerCDR ('" . $Limit . "','" . $processID . "') end");

			DB::connection('sqlsrvcdr')->commit();

            $joblogdata['Message'] = 'Success';
            $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;

            CronJobLog::insert($joblogdata);

		}catch (\Exception $e){
			try {
				DB::connection('sqlsrvcdr')->rollback();
			} catch (\Exception $err) {
				Log::error($err);
			}

			Log::error($e);
			$this->info('Failed:' . $e->getMessage());
			$joblogdata['Message'] ='Error:'.$e->getMessage();
			$joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
			CronJobLog::insert($joblogdata);
			if(!empty($cronsetting['ErrorEmail'])) {
				$result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
				Log::error("**Email Sent Status " . $result['status']);
				Log::error("**Email Sent message " . $result['message']);
			}
		}

		CronJob::deactivateCronJob($CronJob);
		if(!empty($cronsetting['SuccessEmail']) && $error == '') {
			$result = CronJob::CronJobSuccessEmailSend($CronJobID);
			Log::error("**Email Sent Status ".$result['status']);
			Log::error("**Email Sent message ".$result['message']);
		}
		Log::error(" CronJobId end " . $CronJobID);
		CronHelper::after_cronrun($this->name, $this);
    }

}
