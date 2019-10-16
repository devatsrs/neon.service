<?php namespace App\Console\Commands;

use App\Lib\AccountBalanceLog;
use App\Lib\ActiveCall;
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

class UpdateActiveCallCost extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'updateactivecallcost';

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

		$CronJob =  CronJob::find($CronJobID);
		//CronJob::activateCronJob($CronJob);

		$getmypid = getmypid();
		$LastRunTime = date('Y-m-d H:i:00');
		$ActiveCronJobQuery="CALL prc_ActivateCronJob(".$CronJobID.",1,'".$getmypid."','".$LastRunTime."')";
		DB::select($ActiveCronJobQuery);

		$processID = CompanyGateway::getProcessID();
		CompanyGateway::updateProcessID($CronJob,$processID);
		$cronsetting = json_decode($CronJob->Settings,true);
		$error='';
		$errors = array();
		$Success = array();

		try{

			$joblogdata = array();
			$joblogdata['CronJobID'] = $CronJobID;
			$joblogdata['created_at'] = date('Y-m-d H:i:s');
			$joblogdata['created_by'] = 'RMScheduler';
			CronJob::createLog($CronJobID);
			Log::useFiles(storage_path() . '/logs/updateactivecallcost-' . $CompanyID . '-' . date('Y-m-d') . '.log');

			//Log::info('Account Balance Start.');

			$ActiveCalls = ActiveCall::where(['EndCall'=>0])->orderBy('ActiveCallID')->get();
			if(!empty($ActiveCalls) && count($ActiveCalls)>0){
				foreach($ActiveCalls as $ActiveCall){
					try {
						ActiveCall::updateActiveCallCost($ActiveCall->ActiveCallID);
						$Success[] = '1';
					}catch (Exception $ev) {
						Log::error($ev);
						$errors[] = 'Cost Update Failed ActiveCallID :' . $ActiveCall->ActiveCallID . ' Reason : ' . $ev->getMessage();
					}
				}
			}

			if(count($errors) > 0 && count($Success)>0){
				$joblogdata['Message'] = 'Success: ' . implode(',\n\r', $errors);
				$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
			}elseif(count($errors) > 0) {
				$joblogdata['Message'] = 'Error: ' . implode(',\n\r', $errors);
				$joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
			} else {
				$joblogdata['Message'] = 'Success';
				$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
			}

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

		/*$dataactive['Active'] = 0;
		$dataactive['PID'] = '';
		$CronJob->update($dataactive);*/
		//CronJob::deactivateCronJob($CronJob);

		DB::select("CALL prc_DeactivateCronJob(".$CronJob->CronJobID.")");

		if(!empty($cronsetting['SuccessEmail']) && $error == '') {
			$result = CronJob::CronJobSuccessEmailSend($CronJobID);
			Log::error("**Email Sent Status ".$result['status']);
			Log::error("**Email Sent message ".$result['message']);
		}
		Log::error(" CronJobId end " . $CronJobID);


		CronHelper::after_cronrun($this->name, $this);

    }

}
