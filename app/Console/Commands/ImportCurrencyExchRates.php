<?php namespace App\Console\Commands;

use App\Lib\NeonAPI;
use App\Lib\Currency;
use App\Lib\CurrencyConversion;
use App\Lib\CurrencyConversionLog;
use Illuminate\Console\Command;
use App\Lib\CronJob;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;
use DB;
use Illuminate\Support\Facades\Log;
use App\Lib\CronJobLog;
use App\Lib\CronHelper;


class ImportCurrencyExchRates extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'europcentralbank';

	/**
	 * The console command description.
	 *
	 * @var string
	 */
	protected $description = 'This Command will Import All Exchange Rates From API';

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
	 * Execute the console command.
	 *
	 * @return mixed
	 */

	protected function getArguments()
	{
		return [
			['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID '],
			['CronJobID', InputArgument::REQUIRED, 'Argument CronJobID'],

		];
	}

	public function UpdateRates($value,$CompanyID, $rate)
	{
		$cur = DB::table('tblCurrency')->where(['Code' => $value, 'Status' => 1, 'CompanyId' => $CompanyID])->first();

		if (count($cur) == 1) {
			$oldrate = DB::table('tblCurrencyConversion')->where(['CurrencyID' => $cur->CurrencyId, 'CompanyID' => $CompanyID])->first();
			if(empty($oldrate->Value)){

				$insnewrec = CurrencyConversion::create([
					'CurrencyID' => $cur->CurrencyId,
					'CompanyID' => $CompanyID,
					'Value' => $rate,
					'created_at' => date("Y-m-d H:i:s"),
					'CreatedBy' => gethostname(),
					'updated_at' => date("Y-m-d H:i:s"),
					'ModifiedBy' => gethostname(),
					'EffectiveDate' => date("Y-m-d H:i:s")
				]);
				Log::info($insnewrec);
			} else {
				if (number_format((float)$rate, 6) != $oldrate->Value) {

					$rateupd = CurrencyConversion::updateOrCreate([
						'CurrencyID' => $cur->CurrencyId, 'CompanyID' => $CompanyID
					], ['CurrencyID' => $cur->CurrencyId,
						'CompanyID' => $CompanyID,
						'Value' => $rate,
						'updated_at' => date("Y-m-d H:i:s"),
						'ModifiedBy' => gethostname()

					]);
					Log::info($rateupd);

					if (CurrencyConversionLog::create([
						'CurrencyID' => $cur->CurrencyId,
						'CompanyID' => $CompanyID,
						'EffectiveDate' => date("Y-m-d H:i:s", strtotime($oldrate->EffectiveDate)),
						'created_at' => date("Y-m-d H:i:s"),
						'Value' => $oldrate->Value,
						'CreatedBy' => gethostname()
					])
					) {
						Log::info('Conversionlog Updated');
					} else {
						Log::error('Faild to Update ConversionLog');
					}
				}
			}
		}

	}


	public function handle()
	{
		$CronJobID = $this->argument("CronJobID");
		$companyID = $this->argument("CompanyID");
		try {
			CronHelper::before_cronrun($this->name, $this );
			$cronjob = CronJob::find($CronJobID);
			CronJob::activateCronJob($cronjob);
			$json = json_decode($cronjob->Settings);
			$url = $json->EuropCentralBank;
			$time_start = microtime(true);
			$xml = simplexml_load_file($url);
			foreach ($xml as $data) {
				foreach ($data as $val) {
					foreach ($val as $value) {
						$apival = $value['currency'];
						$rate = $value['rate'];
						$this->UpdateRates($apival, $companyID, $rate);

					}
				}
			}
			$time_end = microtime(true);
			$execution_time = ($time_end - $time_start)/60;


			CronJob::CronJobSuccessEmailSend($CronJobID);
			$joblogdata['CronJobID'] = $CronJobID;
			$joblogdata['created_at'] = Date('y-m-d');
			$joblogdata['created_by'] = 'RMScheduler';
			$joblogdata['Message'] = 'CurrencyExchangeRates Successfully Done';
			$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
			CronJobLog::insert($joblogdata);
			CronJob::deactivateCronJob($cronjob);
			CronHelper::after_cronrun($this->name, $this);
			Log::info("Cron Job Completed");
			echo "DONE With CurrencyExchangeRates";

		}catch (\Exception $e){echo $e;
			$this->info('Failed:' . $e->getMessage());
			$joblogdata['CronJobID'] = $CronJobID;
			$joblogdata['created_at'] = Date('y-m-d');
			$joblogdata['created_by'] = 'RMScheduler';
			$joblogdata['Message'] = 'Error:' . $e->getMessage();
			$joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
			CronJobLog::insert($joblogdata);
			if (!empty($cronsetting['ErrorEmail'])) {

				$result = CronJob::CronJobErrorEmailSend($CronJobID, $e);
				Log::error("**Email Sent Status " . $result['status']);
				Log::error("**Email Sent message " . $result['message']);
			}
		}



	}

	/**
	 * Get the console command arguments.
	 *
	 * @return array
	 */


	/**
	 * Get the console command options.
	 *
	 * @return array

	protected function getOptions()
	{
	return [
	['example', null, InputOption::VALUE_OPTIONAL, 'An example option.', null],
	];
	}*/

}
