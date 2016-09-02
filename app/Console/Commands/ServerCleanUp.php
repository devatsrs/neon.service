<?php namespace App\Console\Commands;

use App\Lib\CronHelper;
use App\Lib\RemoteSSH;
use Illuminate\Console\Command;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Retention;
use App\Lib\CompanyConfiguration;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use \Exception;
use Symfony\Component\Console\Input\InputArgument;

class ServerCleanUp extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'servercleanup';

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
		$dataactive['Active'] = 1;
		$dataactive['PID'] = $getmypid;
		$dataactive['LastRunTime'] = date('Y-m-d H:i:00');
		$CronJob->update($dataactive);
		$cronsetting = json_decode($CronJob->Settings,true);


		try{

			$joblogdata = array();
			$joblogdata['CronJobID'] = $CronJobID;
			$joblogdata['created_at'] = date('Y-m-d H:i:s');
			$joblogdata['created_by'] = 'RMScheduler';
			CronJob::createLog($CronJobID);
			Log::useFiles(storage_path() . '/logs/servercleanup-' . $CompanyID . '-' . date('Y-m-d') . '.log');

			$BeforeDiskSpaceOutput = Retention::getDiskSpaceOfServer($CompanyID);

			//delete storage log file
			Retention::deleteStorageLog($CompanyID);

			//delete temp file
			Retention::deleteTempFiles($CompanyID);

			//delete cdr sippy and vos files
			Retention::deleteCDRFiles($CompanyID);

			$AfterDiskSpaceOutput = Retention::getDiskSpaceOfServer($CompanyID);
			$FileRetentionEmail = \Notification::getNotificationMail(['CompanyID'=>$CompanyID,'NotificationType'=>\Notification::RetentionDiskSpaceEmail]);
			//$FileRetentionEmail = CompanyConfiguration::get($CompanyID,'FILE_RETENTION_EMAIL');
			if(!empty($FileRetentionEmail)){
				if(isset($BeforeDiskSpaceOutput) && count($BeforeDiskSpaceOutput)>0 && isset($AfterDiskSpaceOutput) && count($AfterDiskSpaceOutput)>0){
					$BeforeOutput = $BeforeDiskSpaceOutput[0];
					$AfterOutput = $AfterDiskSpaceOutput[0];
					$response = Retention::FileRetentionEmailSend($CompanyID,$BeforeOutput,$AfterOutput,$FileRetentionEmail);
					Log::info('Disk Space of Server Response - '.$response['message']);
				}
			}

			$joblogdata['Message'] = 'Success';
			$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
			CronJobLog::insert($joblogdata);

		}catch (\Exception $e){

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

		$dataactive['Active'] = 0;
		$dataactive['PID'] = '';
		$CronJob->update($dataactive);
		if(!empty($cronsetting['SuccessEmail'])) {
			$result = CronJob::CronJobSuccessEmailSend($CronJobID);
			Log::error("**Email Sent Status ".$result['status']);
			Log::error("**Email Sent message ".$result['message']);
		}
		Log::error(" CronJobId end " . $CronJobID);


		CronHelper::after_cronrun($this->name, $this);

    }

}
