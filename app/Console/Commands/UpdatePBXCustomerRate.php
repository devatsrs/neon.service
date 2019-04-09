<?php namespace App\Console\Commands;

use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\RateTable;
use App\Lib\RateTableRate;
use App\PBX;
use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;

class UpdatePBXCustomerRate extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'updatepbxcustomerrate';

	/**
	 * The console command description.
	 *
	 * @var string
	 */
	protected $description = 'Update PBX Customer Rate.';

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
			['CronJobID', InputArgument::REQUIRED, 'Argument JobID '],
		];
	}

	/**
	 * Execute the console command.
	 *
	 * @return mixed
	 */
	public function handle()
	{
		CronHelper::before_cronrun($this->name, $this);
		$arguments = $this->argument();
		$CompanyID = $arguments["CompanyID"];
		$CronJobID = $arguments["CronJobID"];
		$CronJob = CronJob::find($CronJobID);
		$cronsetting = json_decode($CronJob->Settings, true);
		CronJob::activateCronJob($CronJob);
		CronJob::createLog($CronJobID);
		$CompanyGatewayID = $cronsetting['CompanyGatewayID'];
		$RateTableID = $cronsetting['rateTables'];
		$RateTableID = $RateTableID != "" && $RateTableID != false ? $RateTableID : false;

		$joblogdata = array();
		$joblogdata['CronJobID'] = $CronJobID;
		$joblogdata['created_at'] = date('Y-m-d H:i:s');
		$joblogdata['created_by'] = 'RMScheduler';

		Log::useFiles(storage_path() . '/logs/customerrateupdate-' . $CompanyID . '-' . date('Y-m-d') . '.log');
		try {
			$pbx = new PBX($CompanyGatewayID);
			$TimeZone = CompanyGateway::getGatewayTimeZone($CompanyGatewayID);
			if ($TimeZone != '') {
				date_default_timezone_set($TimeZone);
			} else {
				date_default_timezone_set('GMT'); // just to use e in date() function
			}
			$start_date = date('Y-m-d 00:00:00');
			Log::info(print_r($start_date, true));

			$RateTables = RateTable::where(['CompanyID' => $CompanyID, 'Status' => 1]);
			if($RateTableID != false) $RateTables->where(['RateTableId' => $RateTableID]);
			$RateTables = $RateTables->lists('RateTableName', 'RateTableId');

			$pbxRateTables = $pbx->updateRateTables($RateTables);

			$response = ['inserted' => 0, 'updated' => 0];
			if($pbxRateTables != false){
				$pbxRateTables = array_flip($pbxRateTables);
				$response = $pbx->updateRateTableRates($CompanyID, $pbxRateTables);
			}

			$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
			$joblogdata['Message'] = json_encode($response);
			Log::info("Update pbx customer rate StartTime " . $start_date . " - End Time " . date('Y-m-d H:i:s'));
			Log::info(' ========================== Update pbx customer rate end =============================');
			DB::connection('sqlsrv2')->commit();
			CronJobLog::insert($joblogdata);
		} catch (\Exception $e) {
			try {
				DB::rollback();
				DB::connection('sqlsrv2')->rollback();
			} catch (\Exception $err) {
				Log::error($err);
			}
			date_default_timezone_set(Config::get('app.timezone'));
			$this->info('Failed:' . $e->getMessage());
			$joblogdata['Message'] = 'Error:' . $e->getMessage();
			$joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
			CronJobLog::insert($joblogdata);
			Log::error($e);
			if (!empty($cronsetting['ErrorEmail'])) {
				$result = CronJob::CronJobErrorEmailSend($CronJobID, $e);
				Log::error("**Email Sent Status " . $result['status']);
				Log::error("**Email Sent message " . $result['message']);
			}
		}

		CronJob::deactivateCronJob($CronJob);
	}

}
