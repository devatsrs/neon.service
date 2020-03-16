<?php
/**
 * Created by PhpStorm.
 * User: bhavin
 * Date: 25/02/2020
 * Time: 15:36
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

class ImportCDRs extends Command
{

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'importcdrs';

	/**
	 * The console command description.
	 *
	 * @var string
	 */
	protected $description = 'import cdrs from file';

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

		Log::useFiles(storage_path() . '/logs/importcdrs-' .  $JobID. '-' . date('Y-m-d') . '.log');
		Log::info('importcdrs starts '.$JobID);
		try {
			$ProcessID = Uuid::generate();
			Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Update by Abubakar
			if (!empty($job)) {
				$jobfile = JobFile::where(['JobID' => $JobID])->first();

				if ($jobfile->FilePath) {
					
					$file_name = $jobfile->FilePath;
					$joboptions = json_decode($jobfile->Options);
					$Date_Format = $joboptions->date_format;

					$NeonExcel 	= new NeonExcelIO($file_name);
					$results 	= $NeonExcel->read();

					foreach ($results as $temp_row) {
						$checkemptyrow = array_filter(array_values($temp_row));
						if(!empty($checkemptyrow)) {
							$row_data = array();
							$row_data['ProcessID'] = $ProcessID;
							$row_data['ServiceNumber'] = trim($temp_row['Number']);
							$row_data['CustomerID'] = trim($temp_row['CustomerID']);
							$row_data['connect_time'] = formatDate(str_replace( '/','-',$temp_row['ConnectTime']), $Date_Format);
							$row_data['disconnect_time'] = formatDate(str_replace( '/','-',$temp_row['DisconnectTime']), $Date_Format);
							$row_data['billed_duration'] = trim($temp_row['BilledDuration']);
							$row_data['Duration'] = trim($temp_row['BilledDuration']);
							$row_data['CLI'] = trim($temp_row['CLI']);
							$row_data['CLD'] = trim($temp_row['CLD']);
							$row_data['is_inbound'] = trim($temp_row['IsInbound']);
							$row_data['UUID'] = trim($temp_row['UUID']);
							$row_data['OriginType'] = trim($temp_row['OriginType']);
							$row_data['OriginProvider'] = trim($temp_row['OriginProvider']);
							$row_data['created_at'] = date('Y-m-d H:i:s');

							$batch_insert_array[] = $row_data;
							$counter++;

							if ($counter == $bacth_insert_limit) {
								DB::connection('sqlsrvcdr')->table('tblAccountCDRs')->insert($batch_insert_array);
								$batch_insert_array = [];
								$counter = 0;
							}
						}
					}

					if(!empty($batch_insert_array)) {						
                        DB::connection('sqlsrvcdr')->table('tblAccountCDRs')->insert($batch_insert_array);
						$batch_insert_array = [];
						$counter = 0;
					}

					try{
						$query = "CALL prc_calculateCDR('$ProcessID')";
						//DB::connection('sqlsrvcdr')->beginTransaction();
						Log::info("start ".$query);
						$JobStatusMessage = DB::connection('sqlsrvcdr')->select($query);
						Log::info("end ".$query);
						//DB::connection('sqlsrvcdr')->commit();

						$JobStatusMessage = array_reverse(json_decode(json_encode($JobStatusMessage),true));
						if(count($JobStatusMessage) > 1){
							$error = array();
							foreach ($JobStatusMessage as $JobStatusMessage1) {
								$error[] = $JobStatusMessage1['Message'];
							}
							//$job = Job::find($JobID);
							$jobdata['JobStatusMessage'] = implode(',\n\r',$error);
							$jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','PF')->pluck('JobStatusID');
							$jobdata['updated_at'] = date('Y-m-d H:i:s');
							$jobdata['ModifiedBy'] = 'RMScheduler';
							Job::where(["JobID" => $JobID])->update($jobdata);
						}elseif(!empty($JobStatusMessage[0]['Message'])){
							//$job = Job::find($JobID);
							$jobdata['JobStatusMessage'] = $JobStatusMessage[0]['Message'];
							$jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','S')->pluck('JobStatusID');
							$jobdata['updated_at'] = date('Y-m-d H:i:s');
							$jobdata['ModifiedBy'] = 'RMScheduler';
							Job::where(["JobID" => $JobID])->update($jobdata);
						}
					}catch ( Exception $err ){
						//DB::connection('sqlsrvcdr')->rollback();
						Log::error($err);
						$jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
						$jobdata['JobStatusMessage'] = 'Exception: ' . $err->getMessage();
						$jobdata['updated_at'] = date('Y-m-d H:i:s');
						$jobdata['ModifiedBy'] = 'RMScheduler';
						Job::where(["JobID" => $JobID])->update($jobdata);
					}
				}

			}
		} catch (\Exception $e) {
			$jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
			$jobdata['JobStatusMessage'] = 'Exception: ' . $e->getMessage();
			$jobdata['updated_at'] = date('Y-m-d H:i:s');
			$jobdata['ModifiedBy'] = 'RMScheduler';
			Job::where(["JobID" => $JobID])->update($jobdata);
			Log::error($e);
		}
		Log::info('importcdrs ends');

		Job::send_job_status_email($job,$CompanyID);

		CronHelper::after_cronrun($this->name, $this);


	}
}