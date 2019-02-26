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

		Log::useFiles(storage_path() . '/logs/CurrencyExchangeRate-Success-1-' . date('Y-m-d') . '.log');
        Log::info('line 1');
		//Log::info('line 2');

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
