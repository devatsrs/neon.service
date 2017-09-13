<?php namespace App\Console\Commands;

use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\NeonExcelIO;
use App\Lib\RemoteSSH;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
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

		$dbserver = $companysetting->host;
		$database = $companysetting->database;
		$username = $companysetting->dbusername;
		$password = Crypt::decrypt($companysetting->dbpassword);

		if(!empty($dbserver) && !empty($database) && !empty($username) && !empty($password)) {

			Config::set('database.connections.vosmysql.host',$dbserver);
			Config::set('database.connections.vosmysql.database',$database);
			Config::set('database.connections.vosmysql.username',$username);
			Config::set('database.connections.vosmysql.password',$password);
			//echo "<pre>";print_r([$dbserver,$database,$username,$password]);exit();
			//echo DB::connection('vosmysql')->getDatabaseName();exit;

			try {
				DB::connection('vosmysql')->getDatabaseName();
				$connection = 1;
			} catch (\Exception $e) {
				$connection = 0;
			}

			if($connection == 1) {

				$sshhost = $companysetting->sshhost;
				$sshuser = $companysetting->sshusername;
				$sshpass = Crypt::decrypt($companysetting->sshpassword);

				$ProcessID = rand(1111111, 9999999);
				$data_count = 0;
				$insertLimit = 100;
				$temptableName = 'tmp_neon_rate_import';

				Log::useFiles(storage_path() . '/logs/rateexporttovos-' . $CompanyID . '-' . date('Y-m-d') . '.log');

				try {
					Log::info('========================== rate export to vos transaction start =============================');
					$start_time = date('Y-m-d H:i:s');
					$rate_file_path = getenv("DOWNLOAD_FILE_LOCATION");
					$files = scandir($rate_file_path);
					$filenames = array();
					//			echo "<pre>";print_r($rate_file_path);exit();
					if(is_dir($rate_file_path.'/'.$CompanyGatewayID)){
						if (count($files) > 2) {
							foreach ($files as $file) {
								if (is_file($rate_file_path.'/'.$CompanyGatewayID.'/'.$file) && strpos($file, '.csv') !== false) {
									$processed_path = getenv("PROCESSED_FILE_LOCATION") . '/' . basename($file);
									$error_path = getenv("ERROR_FILE_LOCATION") . '/' . basename($file);
									if (!file_exists($processed_path) && !file_exists($error_path)) {
										$filenames[] = $rate_file_path.'/'.$CompanyGatewayID.'/'.$file;
									}
								}
							}

							Log::info('Total files found : ' . count($filenames));
							$joblogdata['Message'] .= ' <br/> Total files found : ' . count($filenames);

							foreach ($filenames as $filename) {
								$NeonExcel = new NeonExcelIO($filename, []);
								$results = $NeonExcel->read();

								if (count($results) == 0) {
									Log::error('No Data in Rate File : ' . $filename);
									$joblogdata['Message'] .= ' <br/> No Data in Rate File : ' . $filename;
								}

								foreach ($results as $index => $row) {
									try {
										$rate_data = array();

										$rate_data['Code'] = $row['Code'];
										$rate_data['AccountName'] = $row['AccountName'];
										$rate_data['Description'] = $row['Description'];
										$rate_data['EffectiveDate'] = $row['EffectiveDate'];
										$rate_data['Preference'] = isset($row['Preference']) ? $row['Preference'] : 0;
										$rate_data['ConnectionFee'] = $row['ConnectionFee'];
										$rate_data['Rate'] = $row['Rate'];
										$rate_data['Interval1'] = $row['Interval1'];
										$rate_data['IntervalN'] = $row['IntervalN'];
										$rate_data['Blocked'] = isset($row['Blocked']) ? $row['Blocked'] : 0;
										$rate_data['ProcessID'] = $ProcessID;
										$rate_data['isCustomer'] = isset($row['CustomerTrunkPrefix']) ? 1 : 0;
										$rate_data['isVendor'] = isset($row['VendorTrunkPrefix']) ? 1 : 0;

										$InsertData[] = $rate_data;
										if ($data_count > $insertLimit && !empty($InsertData)) {
											DB::connection('vosmysql')->table($temptableName)->insert($InsertData);
											$InsertData = array();
											$data_count = 0;
										}
										$data_count++;

									} catch (\Exception $ex) {
										if(!is_dir(getenv("ERROR_FILE_LOCATION").'/'.$CompanyGatewayID)){
											mkdir(getenv("ERROR_FILE_LOCATION").'/'.$CompanyGatewayID);
										}
										rename(getenv("DOWNLOAD_FILE_LOCATION").'/'.$CompanyGatewayID.'/'.basename($filename), getenv("ERROR_FILE_LOCATION").'/'.$CompanyGatewayID.'/'.basename($filename));
										Log::error(print_r($ex, true));
										//throw $ex;
									}
								}
								if(!is_dir(getenv("PROCESSED_FILE_LOCATION").'/'.$CompanyGatewayID)){
									mkdir(getenv("PROCESSED_FILE_LOCATION").'/'.$CompanyGatewayID);
								}
								rename(getenv("DOWNLOAD_FILE_LOCATION").'/'.$CompanyGatewayID.'/'.basename($filename),getenv("PROCESSED_FILE_LOCATION").'/'.$CompanyGatewayID.'/'.basename($filename));
							}

							if (!empty($InsertData)) {
								DB::connection('vosmysql')->table($temptableName)->insert($InsertData);
							}

							$count = DB::connection('vosmysql')->table($temptableName)->where('ProcessID', $ProcessID)->count();
							Log::info($count . " Records Inserted into temp table.");
							$joblogdata['Message'] .= '<br/>' . " Records Inserted into temp table : " . $count;

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

									/*if($response == 1) {
										Log::error('Script successfully ran on vos server');
									} else {
										Log::error('Script not found or some error occurred in script on vos server');
										Log::error('Here is response from command : '. $response);
									}*/
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
				DB::disconnect('vosmysql');
			} else {
				Log::info('Can\'t connect to database, maybe database details are wrong or there is issue at VOS side.');
				Log::error(print_r($e, true));
				$joblogdata['Message'] = '<br/>' . 'Error:' . $e->getMessage();
				$joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
				CronJobLog::insert($joblogdata);
			}
		} else {
			Log::info('Not able to connect to VOS database because database details are not set in gateway.');
			$joblogdata['Message'] = '<br/> Not able to connect to VOS database because database details are not set in gateway.';
			$joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
			CronJobLog::insert($joblogdata);
		}

		Log::info(' ========================== rate export to vos transaction end =============================');

		CronHelper::after_cronrun($this->name, $this);
	}

}
