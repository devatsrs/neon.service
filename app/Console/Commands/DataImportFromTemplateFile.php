<?php
/**
 * Created by PhpStorm.
 * User: vasim
 * Date: 17/02/2020
 * Time: 06:58
 */

namespace App\Console\Commands;

use App\Lib\AmazonS3;
use App\Lib\CompanyConfiguration;
use App\Lib\CronHelper;
use App\Lib\Job;
use App\Lib\JobFile;
use App\Lib\NeonExcelIO;
use Illuminate\Support\Facades\DB;
use Illuminate\Console\Command;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;
use Illuminate\Support\Facades\Log;
use \Exception;

class DataImportFromTemplateFile extends Command
{

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'dataimportfromtemplatefile';

	/**
	 * The console command description.
	 *
	 * @var string
	 */
	protected $description = 'data import from template file';

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
			['JobID', InputArgument::REQUIRED, 'Argument JobID'],
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
		$getmypid = getmypid(); // get proccess id added by abubakar
		$JobID = $arguments["JobID"];
		$job = Job::find($JobID);

		$bacth_insert_limit = 1000;
		$counter 			= 0;
		$batch_insert_array = [];

		$CompanyID = $arguments["CompanyID"];

		Log::useFiles(storage_path() . '/logs/dataimportfromtemplatefile-' .  $JobID. '-' . date('Y-m-d') . '.log');
		Log::info('dataimportfromtemplatefile starts');
		try {
			$TEMP_PATH = CompanyConfiguration::get($CompanyID,'TEMP_PATH').'/';
			$ProcessID = Uuid::generate();
			Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Update by Abubakar
			if (!empty($job)) {
				$jobfile = JobFile::where(['JobID' => $JobID])->first();

				if ($jobfile->FilePath) {
					$path = AmazonS3::unSignedUrl($jobfile->FilePath, $CompanyID);
					if (strpos($path, "https://") !== false) {
						$file = $TEMP_PATH . basename($path);
						file_put_contents($file, file_get_contents($path));
						$jobfile->FilePath = $file;
					} else {
						$jobfile->FilePath = $path;
					}

					$file_name = $file_name2 = $file_name_with_path = $jobfile->FilePath;

					$NeonExcel 	= new NeonExcelIO($file_name);
					$results 	= $NeonExcel->read();

					foreach ($results as $temp_row) {
						$row_data = array();

						$row_data['numberContractId'] 		= trim($temp_row['numberContractId']);
						$row_data['PackageContractId'] 		= trim($temp_row['PackageContractId']);
						$row_data['Number'] 				= trim($temp_row['NumberTitle']);
						$row_data['PackageTitle'] 			= trim($temp_row['PackageTitle']);
						$row_data['PricePlanTypeId'] 		= trim($temp_row['PricePlanTypeId']);
						$row_data['SalesPrice'] 			= trim($temp_row['SalesPrice']);
						$row_data['code'] 					= trim($temp_row['code']);
						$row_data['CurrencyName'] 			= trim($temp_row['CurrencyName']);
						$row_data['TariffCode'] 			= trim($temp_row['TariffCode']);
						$row_data['TerminationCountryIso2'] = trim($temp_row['TerminationCountryIso2']);
						$row_data['InOutboundType'] 		= trim($temp_row['InOutboundType']);
						$row_data['AccountNumber'] 			= trim($temp_row['AccountNumber']);
						$row_data['product'] 				= trim($temp_row['product']);
						$row_data['ProductId'] 				= trim($temp_row['ProductId']);
						$row_data['ProcessID'] 				= $ProcessID;

						$batch_insert_array[] = $row_data;
						$counter++;

						if ($counter == $bacth_insert_limit) {
							DB::table('tblTempDataImport')->insert($batch_insert_array);
							$batch_insert_array = [];
							$counter = 0;
						}
					}

					if(!empty($batch_insert_array)) {
						DB::table('tblTempDataImport')->insert($batch_insert_array);
						$batch_insert_array = [];
						$counter = 0;
					}

					try{
						$query = "CALL prc_ProcessDataImport('$ProcessID')";
						DB::beginTransaction();
						Log::info("start ".$query);
						$JobStatusMessage = DB::select($query);
						Log::info("end ".$query);
						DB::commit();

						$JobStatusMessage = array_reverse(json_decode(json_encode($JobStatusMessage),true));
						if(count($JobStatusMessage) > 1){
							$error = array();
							foreach ($JobStatusMessage as $JobStatusMessage1) {
								$error[] = $JobStatusMessage1['Message'];
							}
							$job = Job::find($JobID);
							$jobdata['JobStatusMessage'] = implode(',\n\r',$error);
							$jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','PF')->pluck('JobStatusID');
							$jobdata['updated_at'] = date('Y-m-d H:i:s');
							$jobdata['ModifiedBy'] = 'RMScheduler';
							Job::where(["JobID" => $JobID])->update($jobdata);
						}elseif(!empty($JobStatusMessage[0]['Message'])){
							$job = Job::find($JobID);
							$jobdata['JobStatusMessage'] = $JobStatusMessage[0]['Message'];
							$jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','S')->pluck('JobStatusID');
							$jobdata['updated_at'] = date('Y-m-d H:i:s');
							$jobdata['ModifiedBy'] = 'RMScheduler';
							Job::where(["JobID" => $JobID])->update($jobdata);
						}
					}catch ( Exception $err ){
						DB::rollback();
						Log::error($err);
						$jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
						$jobdata['JobStatusMessage'] = 'Exception: ' . $err->getMessage();
						$jobdata['updated_at'] = date('Y-m-d H:i:s');
						$jobdata['ModifiedBy'] = 'RMScheduler';
						Job::where(["JobID" => $JobID])->update($jobdata);
					}
				}

				/*$jobdata['JobStatusMessage'] = "Data Imported Successfully.";
				$jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','S')->pluck('JobStatusID');
				$jobdata['updated_at'] = date('Y-m-d H:i:s');
				$jobdata['ModifiedBy'] = 'RMScheduler';
				Job::where(["JobID" => $JobID])->update($jobdata);*/
			}
		} catch (\Exception $e) {
			$jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
			$jobdata['JobStatusMessage'] = 'Exception: ' . $e->getMessage();
			$jobdata['updated_at'] = date('Y-m-d H:i:s');
			$jobdata['ModifiedBy'] = 'RMScheduler';
			Job::where(["JobID" => $JobID])->update($jobdata);
			Log::error($e);
		}
		Log::info('dataimportfromtemplatefile ends');

		Job::send_job_status_email($job,$CompanyID);

		CronHelper::after_cronrun($this->name, $this);


	}
}