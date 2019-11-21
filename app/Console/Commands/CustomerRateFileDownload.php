<?php namespace App\Console\Commands;

use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\RemoteSSH;
use App\Streamco;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;
use App\Lib\CronJobLog;
use App\Lib\UsageDownloadFiles;

class CustomerRateFileDownload extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'customerratefiledownload';

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

		$CronJobID = $arguments["CronJobID"];
		$CompanyID = $arguments["CompanyID"];
		$CronJob =  CronJob::find($CronJobID);
		$cronsetting =   json_decode($CronJob->Settings,true);
		CronJob::activateCronJob($CronJob);

		$CompanyGatewayID =  $cronsetting['CompanyGatewayID'];
		$FilesDownloadLimit =  $cronsetting['FilesDownloadLimit'];
		$FileLocationFrom =   $cronsetting['FileLocationFrom'];
		$FileLocationTo =  $cronsetting['FileLocationTo'];
		Log::useFiles(storage_path().'/logs/customerratefiledownload-'.$CompanyGatewayID.'-'.date('Y-m-d').'.log');
		try {

			Log::info("Start");

			CronJob::createLog($CronJobID);

			$joblogdata = array();
			$joblogdata['CronJobID'] = $CronJobID;
			$joblogdata['created_at'] = date('Y-m-d H:i:s');
			$joblogdata['created_by'] = 'RMScheduler';
			$joblogdata['Message'] = '';

			$Streamco = new Streamco($CompanyGatewayID);
			Log::info("Streamco Connected");
			$filenames = $Streamco->getCustomerRateFile($FileLocationFrom);
			$destination = $FileLocationTo .'/'.$CompanyGatewayID;
			if (!file_exists($destination)) {
				//mkdir($destination, 0777, true);
				RemoteSSH::make_dir($CompanyID,$destination);
			}
			//$filenames = UsageDownloadFiles::remove_downloaded_files($CompanyGatewayID,$filenames);
			Log::info('File download Count '.count($filenames));
			$downloaded = array();
			if(count($filenames) > 0) {

				/**
				 * GET array of files that are not exist in db
				 */

				foreach ($filenames as $filename) {
					$isdownloaded = false;
					$file_path = $destination . '/' . basename($filename);
					if (!file_exists($file_path)) {
						$param = array();
						$param['filename'] = $filename;
						$param['FileLocationFrom'] = $FileLocationFrom;
						$param['download_path'] = $destination ;
						//$param['download_temppath'] = Config::get('app.temp_location').$CompanyGatewayID.'/';
						$Streamco->downloadRemoteFile($param);

						//if file not exist continue.
						if (!file_exists($file_path)) {
							continue;
						}
						// if file size zero, delete the file to download it again.
						else if(filesize($file_path) == 0 || filesize($file_path) == FALSE){
							unlink($file_path);
							Log::info("Zero size file deleted " . $file_path );
							continue;
						}
						Log::info("downloaded file" . $filename);
						$downloaded[] = $filename;
						//$Streamco->deleteCDR($param);
						$isdownloaded = true;

					}else {
						//Log::info("File was already exist  " . $filename . ' - ' . $Streamco->get_file_datetime($filename));
					}

					if(filesize($file_path) > 0 &&  UsageDownloadFiles::where(array("CompanyGatewayID" => $CompanyGatewayID, "FileName" => basename($filename)))->count() == 0 ) {
						if($isdownloaded == false){
							$param = array();
							$param['filename'] = $filename;
							$param['download_path'] = $destination . '/';
							$Streamco->downloadRemoteFile($param);
							Log::info("Missing file inserted " . $filename );
						}
						UsageDownloadFiles::create(array("CompanyGatewayID" => $CompanyGatewayID, "FileName" => basename($filename), "CreatedBy" => "NeonService"));
					}

					if (count($downloaded) == $FilesDownloadLimit) {
						break;
					}

				}

			}

			$downloaded_files = count($downloaded);
			$joblogdata['Message'] = "Files Downloaded " . $downloaded_files;
			/*if (count($downloaded) > 0) {

				$joblogdata['Message'] .= "<br> Date  : " . $Streamco->get_file_datetime($downloaded[0]);
				$joblogdata['Message'] .= " - " . $Streamco->get_file_datetime($downloaded[$downloaded_files - 1]);
			}*/
			$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
			CronJobLog::insert($joblogdata);

			CronJob::deactivateCronJob($CronJob);

			Log::info("Streamco file Download Completed ");


		}catch (\Exception $e) {
			Log::error($e);
			CronJob::deactivateCronJob($CronJob);

			$joblogdata['Message'] = 'Error:' . $e->getMessage();
			$joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
			CronJobLog::insert($joblogdata);

		}
		Log::info("Streamco end");

		CronHelper::after_cronrun($this->name, $this);

	}

}