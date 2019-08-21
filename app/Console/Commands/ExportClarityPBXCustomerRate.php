<?php namespace App\Console\Commands;

use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\RateTable;
use App\Lib\Service;
use App\ClarityPBX;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Config;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;

class ExportClarityPBXCustomerRate extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'exportclaritypbxcustomerrate';

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

	public function fire()
	{
		CronHelper::before_cronrun($this->name, $this );
		$arguments = $this->argument();
		$getmypid = getmypid(); // get proccess id
		$CronJobID = $arguments["CronJobID"];
		$CompanyID = $arguments["CompanyID"];
		$CronJob = CronJob::find($CronJobID);
		$cronsetting = json_decode($CronJob->Settings,true);
		$dataactive['Active'] = 1;
		$dataactive['PID'] = $getmypid;
		$dataactive['LastRunTime'] = date('Y-m-d H:i:00');
		$CronJob->update($dataactive);
		$CompanyGatewayID = $cronsetting['CompanyGatewayID'];

		$RateTableID = $cronsetting['rateTables'];
		$RateTableID = $RateTableID != "" && $RateTableID != false ? $RateTableID : false;

		Log::useFiles(storage_path() . '/logs/exportClarityPbxCustomerRate-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');

		$joblogdata = array();
		$joblogdata['CronJobID'] = $CronJobID;
		$joblogdata['created_at'] = date('Y-m-d H:i:s');
		$joblogdata['created_by'] = 'RMScheduler';


		try {
			CronJob::createLog($CronJobID);
			$clarityPBX = new ClarityPBX($CompanyGatewayID);
			$TimeZone = CompanyGateway::getGatewayTimeZone($CompanyGatewayID);
			if ($TimeZone != '') {
				date_default_timezone_set($TimeZone);
			} else {
				date_default_timezone_set('GMT'); // just to use e in date() function
			}

			/** Start Export Customer in ClarityPBX */

			$RateTables = RateTable::where(['CompanyID' => $CompanyID, 'Status' => 1]);
			if($RateTableID != false) $RateTables->where(['RateTableId' => $RateTableID]);
			$RateTables = $RateTables->lists('RateTableName', 'RateTableId');
			$pbxRateTables = $clarityPBX->updateRateTables($RateTables);

			$response = ['inserted' => 0, 'updated' => 0];
			if($pbxRateTables != false){
				$response = $clarityPBX->updateRateTableRates($CompanyID, $pbxRateTables);
			}

			$joblogdata['Message'] = "Detail: ".json_encode($response);
			$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;

			Log::error(' ========================== import ClarityPBX CustomerRate end =============================');
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

		CronHelper::after_cronrun($this->name, $this);
	}
}
