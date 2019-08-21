<?php namespace App\Console\Commands;

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

class DBCleanUp extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'dbcleanup';

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
		/*$dataactive['Active'] = 1;
		$dataactive['PID'] = $getmypid;
		$dataactive['LastRunTime'] = date('Y-m-d H:i:00');
		$CronJob->update($dataactive);*/
		CronJob::activateCronJob($CronJob);
		$processID = CompanyGateway::getProcessID();
		/*CompanyGateway::updateProcessID($CronJob,$processID);*/
		$cronsetting = json_decode($CronJob->Settings,true);
		$error = '';


		try{

			$joblogdata = array();
			$joblogdata['CronJobID'] = $CronJobID;
			$joblogdata['created_at'] = date('Y-m-d H:i:s');
			$joblogdata['created_by'] = 'RMScheduler';
			CronJob::createLog($CronJobID);
			Log::useFiles(storage_path() . '/logs/dbcleanup-' . $CompanyID . '-' . date('Y-m-d') . '.log');

			Log::info('DBcleanup Starts.');

			/*
			 * @TODO: need to update as per new tables changes 27-03-18
			 * */

			//Log::info('Delete Old Deleted Tickets.');
			//	$error .= Retention::TicketDeleteFromDeleteTable($CompanyID);
			//Log::info('Delete Old Deleted Tickets End.');

			Log::info('Usage Download Log Start.');
				$error .= Retention::deleteUsageDownloadLog($CompanyID);
			Log::info('Usage Download Log End.');

			Log::info('Cronjob History Delete Start.');
				$error .= Retention::deleteJobOrCronJobLog($CompanyID,'Cronjob');
			Log::info('Cronjob History Delete End.');

			Log::info('Job Log Delete Start.');
				$error .= Retention::deleteJobOrCronJobLog($CompanyID,'Job');
			Log::info('Job Log Delete End.');

			Log::info('Customer RateSheet History Delete Starts.');
				$error .= Retention::deleteJobOrCronJobLog($CompanyID,'CustomerRateSheet');
			Log::info('Customer RateSheet History Delete End.');

			Log::info('Vendor RateSheet History Delete Start.');
				$error .= Retention::deleteJobOrCronJobLog($CompanyID,'VendorRateSheet');
			Log::info('Vendor RateSheet History Delete End.');

			Log::info('All Old Rate Delete Start');
				$error .= Retention::deleteAllOldRate($CompanyID);
			Log::info('All Old Rate Delete End');

			Log::info('Customer CDR Delete Start.');
			$error .= Retention::deleteCustomerCDR($CompanyID, "CDR");
			Log::info('Customer CDR Delete End.');


			Log::info('Customer Failed Call Start.');
			$error .= Retention::deleteCustomerCDR($CompanyID, "CDRFailedCalls");
			Log::info('Customer Failed Call Delete End.');

			Log::info('Vendor CDR Delete Start.');
			$error .= Retention::deleteVendorCDR($CompanyID, "CDR");
			Log::info('Vendor CDR Delete End.');

			Log::info('Vendor CDR Delete Start.');
			$error .= Retention::deleteVendorCDR($CompanyID, "CDRFailedCalls");
			Log::info('Vendor CDR Delete End.');

			Log::info('RateLog Delete Start.');
			DB::table('tblTempRateLog')->where(["SentStatus"=>1,"CompanyID"=>$CompanyID])->delete();
			$DeleteRateDate = date('Y-m-d', strtotime('-1 days', strtotime(date('Y-m-d'))));
			DB::table('tblTempRateLog')->where(["CompanyID"=>$CompanyID])->where("RateDate","<",$DeleteRateDate)->delete();
			Log::info('RateLog Delete End.');

			Log::info('Archive Old Rate Delete Start.');
			$error .= Retention::deleteArchiveOldRate($CompanyID,'ArchiveOldRate',$processID);
			Log::info('Archive Old Rate Delete End.');

			Log::info('Tickets Delete Start.');
			$error .= Retention::deleteTickets($CompanyID,'DeleteTickets',$processID);
			Log::info('Tickets Delete End.');



			Log::info('DBcleanup Done.');

			if(isset($error) && $error != ''){
				$joblogdata['Message'] = $error;
				$joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;

				if(!empty($cronsetting['ErrorEmail'])) {

					$result = CronJob::CronJobErrorEmailSend($CronJobID,$error);
					Log::error("**Email Sent Status " . $result['status']);
					Log::error("**Email Sent message " . $result['message']);
				}
			}else{
				$joblogdata['Message'] = 'Success';
				$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
			}

			CronJobLog::insert($joblogdata);


		}catch (\Exception $e){
			Log::info('DBcleanup Rollback Today.');
			DB::rollback();

			Log::error($e);
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
