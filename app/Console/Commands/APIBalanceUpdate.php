<?php namespace App\Console\Commands;

use App\Lib\CronHelper;
use Illuminate\Console\Command;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use \Exception;
use Symfony\Component\Console\Input\InputArgument;
use App\Lib\CompanyGateway;

class APIBalanceUpdate extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'apibalanceupdate';

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

		$CompanyID = $arguments["CompanyID"];
		$CronJobID = $arguments["CronJobID"];

		$CronJob =  CronJob::find($CronJobID);
		CronJob::activateCronJob($CronJob);
		$processID = CompanyGateway::getProcessID();
		CompanyGateway::updateProcessID($CronJob,$processID);
		$cronsetting = json_decode($CronJob->Settings,true);
		$error='';
		try{

			$joblogdata = array();
			$joblogdata['CronJobID'] = $CronJobID;
			$joblogdata['created_at'] = date('Y-m-d H:i:s');
			$joblogdata['created_by'] = 'RMScheduler';
			CronJob::createLog($CronJobID);
			Log::useFiles(storage_path() . '/logs/apibalanceupdate-' . $CompanyID . '-' . date('Y-m-d') . '.log');

			//Log::info('Account Balance Start.');

			DB::connection('neon_routingengine')->beginTransaction();
			DB::connection('neon_routingengine')->statement("CALL  prc_CreateAPIAccountBalance()");
			DB::connection('neon_routingengine')->commit();

			$joblogdata['Message'] = 'Success';
			$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
			CronJobLog::insert($joblogdata);

		}catch (\Exception $e){

			Log::error($e);
			$error=1;
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
