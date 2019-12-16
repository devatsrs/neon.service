<?php
/**
 * Created by PhpStorm.
 * User: vasim
 * Date: 13/12/2019
 * Time: 06:58
 */

namespace App\Console\Commands;

use App\Lib\AmazonS3;
use App\Lib\CompanyConfiguration;
use App\Lib\CronHelper;
use App\Lib\Job;
use App\Lib\JobStatus;
use App\Lib\JobType;
use App\Lib\NeonExcelIO;
use Illuminate\Support\Facades\DB;
use Illuminate\Console\Command;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Config;
use \Exception;

class GridExport extends Command
{

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'gridexport';

	/**
	 * The console command description.
	 *
	 * @var string
	 */
	protected $description = 'grid export';

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

		$CompanyID = $arguments["CompanyID"];

		Log::useFiles(storage_path() . '/logs/gridexport-' .  $JobID. '-' . date('Y-m-d') . '.log');
		Log::info('gridexport starts');
		try {
			DB::beginTransaction();
			$ProcessID = Uuid::generate();
			Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Update by Abubakar
			if (!empty($job)) {
				$joboptions 	= json_decode($job->Options);
				$params     	= $joboptions->params;
				$query 			= $joboptions->query;
				$GridType 		= $joboptions->GridType;

				if($GridType == 'GT-TRT') {// grid type from RateTablesController->rate_export()
					DB::setFetchMode(\PDO::FETCH_ASSOC);
				}

				$result_data = DB::select($query);

				if($GridType == 'GT-TRT') {// grid type from RateTablesController->rate_export()
					DB::setFetchMode(Config::get('database.fetch'));
				}

				if($GridType == 'GT-LCR') {// grid type from LCRController->search_ajax_datagrid()
					$result_data = json_decode(json_encode($result_data),true);
					foreach($result_data as $rowno => $rows){
						foreach($rows as $colno => $colval){
							$result_data[$rowno][$colno] = str_replace( "<br>" , "\n" ,$colval );
						}
					}
				}
				if($GridType == 'GT-TRT') {// grid type from RateTablesController->rate_export()
					if (!empty($params->ResellerPage)) {
						foreach ($result_data as $key => $value) {
							if (isset($value['Approved By/Date'])) {
								unset($value['Approved By/Date']);
								$result_data[$key] = $value;
							}
							if (isset($value['ApprovedStatus'])) {
								unset($value['ApprovedStatus']);
								$result_data[$key] = $value;
							}
						}
					}
				}

				$amazonPath 		= AmazonS3::generate_upload_path(AmazonS3::$dir['GRID_EXPORT'],'',$CompanyID);
				$file_path 			= $amazonPath . $params->FileName;
				$UPLOAD_PATH 		= CompanyConfiguration::get($CompanyID,'UPLOAD_PATH');
				$full_file_path 	= $UPLOAD_PATH . '/' . $file_path;

				$NeonExcel = new NeonExcelIO($full_file_path);
				if($params->type=='csv'){
					$NeonExcel->write_csv($result_data);
				}elseif($params->type=='xlsx'){
					$NeonExcel->write_excel($result_data);
				}

				$jobdata['OutputFilePath'] 		= $file_path;
				$jobdata['JobStatusMessage'] 	= 'Export File Generated Successfully!';
				$jobdata['JobStatusID'] 		= DB::table('tblJobStatus')->where('Code','S')->pluck('JobStatusID');
				$jobdata['updated_at'] 			= date('Y-m-d H:i:s');
				$jobdata['ModifiedBy'] 			= 'RMScheduler';
				Job::where(["JobID" => $JobID])->update($jobdata);
			} else {
				$jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
				$jobdata['JobStatusMessage'] = 'Job not found.';
				$jobdata['updated_at'] = date('Y-m-d H:i:s');
				$jobdata['ModifiedBy'] = 'RMScheduler';
				Job::where(["JobID" => $JobID])->update($jobdata);
			}
			DB::commit();

		} catch (\Exception $e) {
			DB::rollback();
			$jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
			$jobdata['JobStatusMessage'] = 'Exception: ' . $e->getMessage();
			$jobdata['updated_at'] = date('Y-m-d H:i:s');
			$jobdata['ModifiedBy'] = 'RMScheduler';
			Job::where(["JobID" => $JobID])->update($jobdata);
			Log::error($e);
		}
		Log::info('gridexport ends');

		Job::send_job_status_email($job,$CompanyID);

		CronHelper::after_cronrun($this->name, $this);


	}
}