<?php namespace App\Console\Commands;

use App\Lib\Account;
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

class UpdatePBXVendorRate extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'updatepbxvendorrate';

	/**
	 * The console command description.
	 *
	 * @var string
	 */
	protected $description = 'Update PBX Vendor Rate.';

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
		$CronJob   = CronJob::find($CronJobID);
		$cronsetting = json_decode($CronJob->Settings, true);
		CronJob::activateCronJob($CronJob);
		CronJob::createLog($CronJobID);
		$CompanyGatewayID = $cronsetting['CompanyGatewayID'];
		$VendorsIDs = $cronsetting['vendors'];
		$VendorsIDs = $VendorsIDs != "" && !empty($VendorsIDs) ? array_filter(explode(",", $VendorsIDs), 'intval') : false;

		$joblogdata = array();
		$joblogdata['CronJobID'] = $CronJobID;
		$joblogdata['created_at'] = date('Y-m-d H:i:s');
		$joblogdata['created_by'] = 'RMScheduler';

		Log::useFiles(storage_path() . '/logs/vendorrateupdate-' . $CompanyID . '-' . date('Y-m-d') . '.log');
		try {
			$pbx = new PBX($CompanyGatewayID);
			$TimeZone = CompanyGateway::getGatewayTimeZone($CompanyGatewayID);
			if ($TimeZone != '') {
				date_default_timezone_set($TimeZone);
			} else {
				date_default_timezone_set('GMT'); // just to use e in date() function
			}
			$start_date = date('Y-m-d H:i:s');
			Log::info(print_r($start_date, true));

			$Vendors = Account::where([
				'Status'			 => 1,
				'AccountType'		 => 1,
				'VerificationStatus' => Account::VERIFIED,
				'IsVendor'			 => 1,
				'CompanyID'			 => $CompanyID,
			]);

			if($VendorsIDs != false) $Vendors->whereIn('AccountID', $VendorsIDs);
			Log::info("Vendors query : ". $Vendors->toSql());
			$Vendors = $Vendors->lists('Number', 'AccountID');

			$pbxVendors = $pbx->updateVendorRateTables($Vendors);

			$response = ['inserted' => 0, 'updated' => 0];
			if($pbxVendors != false)
				$response = $pbx->updateVendorRates($CompanyID, $pbxVendors);

			$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
			$joblogdata['Message'] = "Detail: " . json_encode($response);
			Log::info("Update pbx vendor rate StartTime " . $start_date . " - End Time " . date('Y-m-d H:i:s'));
			Log::info(' ========================== Update pbx vendor rate end =============================');
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
