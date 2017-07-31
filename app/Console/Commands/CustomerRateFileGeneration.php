<?php namespace App\Console\Commands;

use App\Lib\Account;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\RemoteSSH;
use App\Streamco;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;

class CustomerRateFileGeneration extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'customerratefilegeneration';

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
			['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID '],
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
		CronHelper::before_cronrun($this->name, $this );

		$arguments = $this->argument();
		$CronJobID = $arguments["CronJobID"];
		$CompanyID = $arguments["CompanyID"];
		$CronJob = CronJob::find($CronJobID);
		$cronsetting = json_decode($CronJob->Settings,true);

		CronJob::activateCronJob($CronJob);

		$CompanyGatewayID = $cronsetting['CompanyGatewayID'];

		Log::useFiles(storage_path() . '/logs/customerratefilegeneration-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');


		$joblogdata = array();
		$joblogdata['CronJobID'] = $CronJobID;
		$joblogdata['created_at'] = date('Y-m-d H:i:s');
		$joblogdata['created_by'] = 'RMScheduler';
		$joblogdata['Message'] = '';

		try {

			Log::error(' ========================== streamco transaction start =============================');

			// ssh detail

			$Streamco = new Streamco($CompanyGatewayID);

			Log::info("Streamco Connected");

			$Output = "";

			if(isset($cronsetting["ScriptLocation"]) && !empty($cronsetting["ScriptLocation"])) {

				$command =  "php " . $cronsetting["ScriptLocation"]  . "/artisan streamcoratefilegenerator customer ";
				if(empty($cronsetting["customers"])){

					$command .=  "--type=all";

				} else {

					$Accounts = Account::getAccountIDList();
					$selected = $cronsetting["customers"];
					$selectedAccounts = [];
					if(count($selected) > 0){

						foreach($selected as $AccountID){

							if(isset($Accounts[$AccountID])){
								$selectedAccounts[] = $Accounts[$AccountID];
							}
						}
					}
 					if(count($selectedAccounts) > 0){
						$command .= "--accounts=" . implode(",",$selectedAccounts);
					}

				}

				$Output = Streamco::execute_remote_cmd($command);

				$joblogdata['Message'] =  "Output: " . implode("<br>", $Output);

				if(!empty($Output) && !strpos("Exception" ,  implode("<br>", $Output)  )){

					$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;

				} else {

					$joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
				}

				CronJobLog::insert($joblogdata);

			} else {

				Log::info("No command found ");

				$joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
				$joblogdata['Message'] =  "No Script Location found";
				CronJobLog::insert($joblogdata);


			}



			CronJob::deactivateCronJob($CronJob);


		} catch (\Exception $e) {

			//Log::error(print_r($e,true));
			CronJob::deactivateCronJob($CronJob);

			$joblogdata['Message'] = 'Error:' . $e->getMessage();
			$joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
			CronJobLog::insert($joblogdata);

		}
		Log::info("Streamco end");

		CronHelper::after_cronrun($this->name, $this);
	}



}
