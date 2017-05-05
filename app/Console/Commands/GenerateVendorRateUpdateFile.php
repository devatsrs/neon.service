<?php namespace App\Console\Commands;

use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\RateUpdateFileGenerator;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;

/** This command will be run immediately when any rate is updated in Customer or Vendor.
 * Class GenerateRateUpdateFile
 * @package App\Console\Commands
 */
class GenerateVendorRateUpdateFile extends Command
{

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'generatevendorrateupdatefile';

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
			['CronJobID', InputArgument::REQUIRED, 'Argument CronJobID'],
		];
	}

	/**
	 * Execute the console command.
	 *
	 * @return mixed
	 */
	public function fire()
	{
		/**
		 * @TODO: Need to sure Rate Table Generation cron job need to be generate in Same time zone of
		 * Gateway - ie. If Company Timezone is GMT +01:00 and Gateway Timezone is GMT 00:00
		 * Then Rate table should generate at GMT+1 11pm to match the Timezone of GMT
		 *
		 * Also there is no trigger when future effective date is current date.
		 */


		CronHelper::before_cronrun($this->name, $this);


		$arguments = $this->argument();

		$CronJobID = $arguments["CronJobID"];
		$CompanyID = $arguments["CompanyID"];
		$AccountType = 'vendor';

		Log::useFiles(storage_path() . '/logs/generatevendorrateupdatefile-' . $CompanyID . '-' . $CronJobID . '-' . $AccountType . '-'  . date('Y-m-d') . '.log');


		$CronJob = CronJob::find($CronJobID);
		$cronsetting = json_decode($CronJob->Settings, true);

		$joblogdata = array();
		$joblogdata['CronJobID'] = $CronJobID;
		$joblogdata['created_at'] = date('Y-m-d H:i:s');
		$joblogdata['created_by'] = 'RMScheduler';
		$joblogdata['Message'] = '';

		$updated_rates = array();
		CronJob::activateCronJob($CronJob);

		try {
			$future_rates = false;
			if (isset($cronsetting["FutureRate"])) {

				$future_rates = $cronsetting["FutureRate"];
			}

			if (!isset($cronsetting["FileLocation"]) || empty($cronsetting["FileLocation"])) {
				throw new \Exception(" CSV File Generate Location not specified.");
			}

			$local_dir = $cronsetting["FileLocation"];

			Log::info("generate_file");
			$RateUpdateFileGenerator = new RateUpdateFileGenerator();
			$RateUpdateFileGenerator->generate_file($CompanyID, $AccountType, 'current', $local_dir);

			//$updated_rates = array_merge($updated_rates ,  $RateUpdateFileGenerator->updated_rates );

			Log::info("generate_file over");



			if ($future_rates) {
				/**
				 * Need to manage future date at Gateway Side.
				 * So when current date = future date we done need to add in rate update history table.
				 * This scenario will be managed from gateway side if we update future rates in gateway.
				 */
				$RateUpdateFileGenerator->generate_file($CompanyID, $AccountType, 'future', $local_dir);
				//$updated_rates = array_merge($updated_rates ,  $RateUpdateFileGenerator->updated_rates );

			}


			if (count($RateUpdateFileGenerator->errors) > 0) {

				$joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
				$joblogdata['Message'] = implode('\n\r', $RateUpdateFileGenerator->errors);

			} else {

				$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
				$joblogdata['Message'] = "Success";

			}
			CronJobLog::insert($joblogdata);


		} catch (Exception $e) {

			Log::error($e);
			CronJob::deactivateCronJob($CronJob);

			$joblogdata['Message'] = 'Error:' . $e->getMessage();
			$joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
			CronJobLog::insert($joblogdata);

		}

		CronHelper::after_cronrun($this->name, $this);

	}

}

