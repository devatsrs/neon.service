<?php namespace App\Console\Commands;




	use App\Lib\CronHelper;
	use App\Lib\NeonAPI;
	use App\Lib\DynamicFields;
	use App\Lib\Package;
	use App\Lib\ServiceTemplate;
	use App\Lib\ServiceTemapleSubscription;
	use App\Lib\ServiceTemapleInboundTariff;
	use App\Lib\DynamicFieldsValue;
	use App\Lib\RateTableDIDRate;
	use App\Lib\RoutingProfileRate;
	use Illuminate\Console\Command;
	use App\Lib\CronJob;
	use App\Lib\Translation;
	use App\Lib\RateTablePKGRate;

	use App\Lib\Account;
	use App\Lib\Company;
	use App\Lib\Notification;
	use App\Lib\Helper;
	use App\Lib\CompanyConfiguration;
	use App\Lib\CronJobLog;
	use App\Lib\Retention;
	use Illuminate\Support\Facades\DB;
	use Illuminate\Support\Facades\Log;
	use \Exception;
	use Symfony\Component\Console\Input\InputArgument;
	use Illuminate\Support\Facades\Crypt;
	use App\Lib\CompanyGateway;

	class UpdateRateTableInProductAndPackage extends Command {

		/**
		 * The console command name.
		 *
		 * @var string
		 */
		protected $name = 'updateratetableproductandpackage';

		/**
		 * The console command description.
		 *
		 * @var string
		 */
		protected $description = 'Push Sales Prices to ERP System.';

		protected function getArguments()
		{
			return [
				['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID '],
				['CronJobID', InputArgument::REQUIRED, 'Argument CronJobID'],
			];
		}

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
		public function handle() {

			//Staging php artisan updateratetableproductandpackage 1 286
			//php artisan updateratetableproductandpackage 1 349
			CronHelper::before_cronrun($this->name, $this );

			$arguments = $this->argument();
			$CompanyID = $arguments["CompanyID"];
			$CronJobID = $arguments["CronJobID"];

			$CronJob =  CronJob::find($CronJobID);
			$cronsetting = json_decode($CronJob->Settings,true);
			Log::useFiles(storage_path() . '/logs/updateratetableproductandpackage-companyid-'.$CompanyID . '-cronjobid-'.$CronJobID.'-' . date('Y-m-d') . '.log');
	try{
			CronJob::activateCronJob($CronJob);
			CronJob::createLog($CronJobID);

				DB::select('CALL UpdateRateTableInProductAndPackage(' .$CompanyID. ')');
		//Log::info('UpdateRateTableInProductAndPackage succefully run.');
					CronJob::CronJobSuccessEmailSend($CronJobID);
					$joblogdata['CronJobID'] = $CronJobID;
					$joblogdata['created_at'] = Date('y-m-d');
					$joblogdata['created_by'] = 'RMScheduler';
					$joblogdata['Message'] = 'Product And Package Rate Table Updated';
					$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
					CronJobLog::insert($joblogdata);
					CronJob::deactivateCronJob($CronJob);
					CronHelper::after_cronrun($this->name, $this);
				//	echo "DONE With updateratetableproductandpackage";


					//Log::info('routingList:Get the routing list user company.' . $CompanyID);
				//	Log::info('Run Cron.');
				}catch(\Exception $e){
					Log::useFiles(storage_path() . '/logs/updateratetableproductandpackage-Error-' . date('Y-m-d') . '.log');
					//Log::info('LCRRoutingEngine Error.');
					Log::useFiles(storage_path() . '/logs/updateratetableproductandpackage-Error-' . date('Y-m-d') . '.log');

					Log::error($e);
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



	}
