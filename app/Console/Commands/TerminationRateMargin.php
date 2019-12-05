<?php
/**
 * Created by PhpStorm.
 * User: vasim
 * Date: 07/10/2019
 * Time: 06:58
 */

namespace App\Console\Commands;

use App\Lib\CronHelper;
use App\Lib\Job;
use Illuminate\Support\Facades\DB;
use Illuminate\Console\Command;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;
use Illuminate\Support\Facades\Log;
use \Exception;

class TerminationRateMargin extends Command
{

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'terminationratemargin';

	/**
	 * The console command description.
	 *
	 * @var string
	 */
	protected $description = 'termination rate margin';

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
		$ProcessID = Uuid::generate();
		Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Update by Abubakar
		$CompanyID = $arguments["CompanyID"];

		Log::useFiles(storage_path() . '/logs/terminationratemargin-' .  $JobID. '-' . date('Y-m-d') . '.log');
		try {
			if (!empty($job)) {
				$joboptions = json_decode($job->Options);
				$params 	= $joboptions->params;

				$RateTableID 		= $params->RateTableID;
				$RateTableRateAAID 	= !empty($params->RateTableRateAAID) ? $params->RateTableRateAAID : 'NULL';
				$ProcessID 			= !empty($params->ProcessID) ? "'".$params->ProcessID."'" : 'NULL';

				$query = "CALL prc_updateMargins(".$RateTableID.",".$RateTableRateAAID.",$ProcessID);";

				$results = DB::statement($query);

				$success_message = 'Rate Difference Updated Successfully!';

				$jobdata['JobStatusMessage'] = $success_message;
				$jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','S')->pluck('JobStatusID');
				$jobdata['updated_at'] = date('Y-m-d H:i:s');
				$jobdata['ModifiedBy'] = 'RMScheduler';
				Job::where(["JobID" => $JobID])->update($jobdata);
			}


		} catch (\Exception $e) {
			$jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
			$jobdata['JobStatusMessage'] = 'Exception: ' . $e->getMessage();
			$jobdata['updated_at'] = date('Y-m-d H:i:s');
			$jobdata['ModifiedBy'] = 'RMScheduler';
			Job::where(["JobID" => $JobID])->update($jobdata);
			Log::error($e);
		}
		Job::send_job_status_email($job,$CompanyID);

		CronHelper::after_cronrun($this->name, $this);


	}
}