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
use App\Lib\JobStatus;
use App\Lib\JobType;
use Illuminate\Support\Facades\DB;
use Illuminate\Console\Command;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;
use Illuminate\Support\Facades\Log;
use \Exception;

class TerminationRateOperation extends Command
{

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'terminationrateoperation';

	/**
	 * The console command description.
	 *
	 * @var string
	 */
	protected $description = 'termination rate operation';

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

		Log::useFiles(storage_path() . '/logs/terminationrateoperation-' .  $JobID. '-' . date('Y-m-d') . '.log');
		Log::info('terminationrateoperation starts');
		try {
			$ProcessID = Uuid::generate();
			Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Update by Abubakar
			if (!empty($job)) {
				$joboptions = json_decode($job->Options);
				$params     = $joboptions->params;
				$query 		= $joboptions->query;
				$results 	= DB::select($query);

				$success_message = '';
				if($joboptions->OperationType =='Update') {
					$success_message = 'Rate Updated Successfully!';

					if($params->ApprovedStatus == 0 && !empty($results[0]->ProcessID)) {
						$params2['RateTableID']       	= $params->RateTableID;
						$params2['RateTableRateAAID']   = '';
						$params2['ProcessID']           = $results[0]->ProcessID;

						$options['RateTableName']   = $joboptions->RateTableName;
						$options['params']          = $params2;
						$rules = array(
							'CompanyID' => 'required',
							'JobTypeID' => 'required',
							'JobStatusID' => 'required',
							'JobLoggedUserID' => 'required',
							'Title' => 'required',
							'CreatedBy' => 'required',
						);

						$JobType     = 'TRM';
						$jobType     = JobType::where(["Code" => $JobType])->get(["JobTypeID", "Title"]);
						$jobStatus   = JobStatus::where(["Code" => "P"])->get(["JobStatusID"]);

						$CompanyID              = $joboptions->CompanyID;
						$options["CompanyID"]   = $CompanyID;
						$data["CompanyID"]      = $CompanyID;
						$data["JobTypeID"]      = isset($jobType[0]->JobTypeID) ? $jobType[0]->JobTypeID : '';
						$data["JobStatusID"]    = isset($jobStatus[0]->JobStatusID) ? $jobStatus[0]->JobStatusID : '';
						$data["JobLoggedUserID"]= $job->JobLoggedUserID;
						$data["Title"]          = 'Termination Rate Difference ('.$options['RateTableName'].')';
						$data["Description"]    = ' ' . isset($jobType[0]->Title) ? $jobType[0]->Title : '';
						$data["CreatedBy"]      = $job->CreatedBy;
						$data["updated_at"]     = date('Y-m-d H:i:s');
						$data["created_at"]     = date('Y-m-d H:i:s');
						$data["Options"]        = json_encode($options);

						$validator = \Validator::make($data, $rules);

						if ($validator->fails()) {
							    return validator_response($validator);
 						}

 						$JobID2 = Job::insertGetId($data);
				  	}

				} else if ($joboptions->OperationType =='Delete') {
					$success_message = 'Rate Deleted Successfully!';
				} else if ($joboptions->OperationType =='Approve') {
					$success_message = 'Rate Approved Successfully!';
				} else if ($joboptions->OperationType =='Reject') {
					$success_message = 'Rate Rejected Successfully!';
				}

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
		Log::info('terminationrateoperation ends');

		Job::send_job_status_email($job,$CompanyID);

		CronHelper::after_cronrun($this->name, $this);


	}
}