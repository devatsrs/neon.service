<?php namespace App\Console\Commands;

use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\RemoteSSH;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\Log;
use Prophecy\Exception\Exception;
use Symfony\Component\Console\Input\InputArgument;
use Illuminate\Support\Facades\Config;

class RateExportToVos extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'rateexporttovos';

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
		CronHelper::before_cronrun($this->name, $this);

		$arguments = $this->argument();
		$CompanyID = $arguments["CompanyID"];
		$CronJobID = $arguments["CronJobID"];
		$CronJob = CronJob::find($CronJobID);
		$cronsetting = json_decode($CronJob->Settings, true);

		$CompanyGatewayID = $cronsetting['CompanyGatewayID'];
		$companysetting = json_decode(CompanyGateway::getCompanyGatewayConfig($CompanyGatewayID));

		$joblogdata = array();
		$joblogdata['CronJobID'] = $CronJobID;
		$joblogdata['created_at'] = date('Y-m-d H:i:s');
		$joblogdata['created_by'] = 'RMScheduler';
		$joblogdata['Message'] = '';

		$sshhost = $companysetting->sshhost;
		$sshuser = $companysetting->sshusername;
		$sshpass = Crypt::decrypt($companysetting->sshpassword);

		$ProcessID = rand(1111111, 9999999);

		Log::useFiles(storage_path() . '/logs/rateexporttovos-' . $CompanyID . '-' . date('Y-m-d') . '.log');

		try {
			Log::info('========================== rate export to vos transaction start =============================');
			$start_time = date('Y-m-d H:i:s');
			$rate_file_path = getenv("DOWNLOAD_FILE_LOCATION");

			if(is_dir($rate_file_path.'/'.$CompanyGatewayID)){
				$files = scandir($rate_file_path.'/'.$CompanyGatewayID);
				$filenames = array();
				if (count($files) > 2) {
					$config = array(
						"host" => $sshhost,
						"username" => $sshuser,
						"password" => $sshpass
					);
					RemoteSSH::setManualConfig($config);
					$remote_path = '/root/vos_import/rate_files/DOWNLOAD_FILE_LOCATION/';

					foreach ($files as $file) {
						$file = basename($file);
						if (is_file($rate_file_path.'/'.$CompanyGatewayID.'/'.$file) && strpos($file, '.csv') !== false) {
							$processed_path = getenv("PROCESSED_FILE_LOCATION") . '/' . $file;
							$error_path = getenv("ERROR_FILE_LOCATION") . '/' . $file;
							if (!file_exists($processed_path) && !file_exists($error_path)) {
								$filenames[] = $local_file = $rate_file_path.'/'.$CompanyGatewayID.'/'.$file;

								try {
									RemoteSSH::put($local_file, $remote_path . $file);
									Log::info($file . ' Uploaded to ' . $remote_path.$file);
									$joblogdata['Message'] .= ' <br/> ' . $file . ' Uploaded to ' . $remote_path.$file;
								} catch (\Exception $ex) {
									if(!is_dir(getenv("ERROR_FILE_LOCATION").'/'.$CompanyGatewayID)){
										//mkdir(getenv("ERROR_FILE_LOCATION").'/'.$CompanyGatewayID);
										RemoteSSH::make_dir($CompanyID,getenv("ERROR_FILE_LOCATION").'/'.$CompanyGatewayID);
									}
									rename($local_file, getenv("ERROR_FILE_LOCATION").'/'.$CompanyGatewayID.'/'.$file);
									Log::error(print_r($ex, true));
								}

								if(!is_dir(getenv("PROCESSED_FILE_LOCATION").'/'.$CompanyGatewayID)){
									RemoteSSH::make_dir($CompanyID,getenv("PROCESSED_FILE_LOCATION").'/'.$CompanyGatewayID);
									//mkdir(getenv("PROCESSED_FILE_LOCATION").'/'.$CompanyGatewayID);
								}
								rename($local_file,getenv("PROCESSED_FILE_LOCATION").'/'.$CompanyGatewayID.'/'.$file);
							}
						}
					}

					Log::info('Total files Uploaded : ' . count($filenames));
					$joblogdata['Message'] .= ' <br/> Total files found : ' . count($filenames);

					if(count($filenames) > 0) {
						try {
							//connect to vos server and run script to transfer data from temp table to main table
							if (!empty($sshhost) && !empty($sshuser) && !empty($sshpass)) {
								$config = array(
									"host" => $sshhost,
									"username" => $sshuser,
									"password" => $sshpass
								);
								RemoteSSH::setManualConfig($config);

								$command = 'perl vos_import/rateimporttovos.pl --ProcessID ' . $ProcessID;
								Log::info($command);

								$response = RemoteSSH::manualRun([$command]);
								Log::error('Here is response from command : ' . $response[0]);

								$response = explode(":", trim($response[0]));
								Log::error('Total Inserted Rates : ' . $response[0]);
								Log::error('Total Updated Rates : ' . $response[1]);

								$joblogdata['Message'] .= '<br/>' . " Total Inserted Rates : " . $response[0];
								$joblogdata['Message'] .= '<br/>' . " Total Updated Rates : " . $response[1];
							} else {
								$joblogdata['Message'] .= '<br/>' . " Not able to connect to VOS server because SSH details are not set in gateway.";
								Log::error('Not able to connect to VOS server because SSH details are not set in gateway.');
							}
						} catch (\Exception $e) {
							Log::error(print_r($e, true));
							$joblogdata['Message'] = '<br/>' . 'Error:' . $e->getMessage();
							$joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
							CronJobLog::insert($joblogdata);
						}
					}

					$end_time = date('Y-m-d H:i:s');
					$joblogdata['Message'] .= '<br/>' . time_elapsed($start_time, $end_time);
					$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
					CronJobLog::insert($joblogdata);
				} else {
					Log::info('No Rate Files to Export!');
				}
			} else {
				Log::info('No Rate Files to Export!');
			}

		} catch (\Exception $e) {
			Log::error(print_r($e, true));
			$joblogdata['Message'] = '<br/>' . 'Error:' . $e->getMessage();
			$joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
			CronJobLog::insert($joblogdata);
		}

		Log::info(' ========================== rate export to vos transaction end =============================');

		CronHelper::after_cronrun($this->name, $this);
	}

}
