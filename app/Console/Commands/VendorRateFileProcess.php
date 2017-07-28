<?php namespace App\Console\Commands;

use App\Lib\Account;
use App\Lib\Company;
use App\Lib\CompanyConfiguration;
use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Service;
use App\Lib\TempUsageDetail;
use App\Lib\TempUsageDownloadLog;
use App\Lib\TempVendorCDR;
use App\Lib\Trunk;
use App\Lib\UsageDownloadFiles;
use App\RateImportExporter;
use App\Streamco;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;

class VendorRateFileProcess extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'vendorratefileprocess';

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


			/**
			get pending files to be process

			get/generate temptable name

			loop through files
				change status of file to process
				load data in temp table.

			loop end

			call procedure to import rates
			change status of file to complete

			commit
			 */


		CronHelper::before_cronrun($this->name, $this );


		$arguments = $this->argument();
		$getmypid = getmypid(); // get proccess id
		$CronJobID = $arguments["CronJobID"];
		$CompanyID = $arguments["CompanyID"];
		$CronJob = CronJob::find($CronJobID);
		$cronsetting = json_decode($CronJob->Settings, true);
		if(isset($cronsetting['FilesMaxProcess']) && $cronsetting['FilesMaxProcess'] > 0){
			$FilesMaxProcess = $cronsetting['FilesMaxProcess'];
		}else{
			$FilesMaxProcess = '5';
		}
		$data_count = 0;
		$insertLimit = 1000;


		$CompanyGatewayID = $cronsetting['CompanyGatewayID'];
		$FileLocationTo =  $cronsetting['FileLocation']; //'/home/temp/test_files_generation_to' ; //


		$dataactive['Active'] = 1;
		$dataactive['LastRunTime'] = date('Y-m-d H:i:00');
		$dataactive['PID'] = $getmypid;
		$CronJob->update($dataactive);

		$processID = rand(11111,99999999);

		$joblogdata = array();
		$joblogdata['CronJobID'] = $CronJobID;
		$joblogdata['created_at'] = date('Y-m-d H:i:s');
		$joblogdata['created_by'] = 'RMScheduler';
		$joblogdata['Message'] = '';
		$delete_files = array();
		$temptableName = RateImportExporter::CreateIfNotExistTempRateImportTable($CompanyID,$CompanyGatewayID);
		//$tempVendortable =  CompanyGateway::CreateVendorTempTable($CompanyID,$CompanyGatewayID);

		Log::useFiles(storage_path() . '/logs/vendorratefileprocess-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');

		try {
			$start_time = date('Y-m-d H:i:s');
			Log::info("Start");
			/** get process file make them pending*/
			UsageDownloadFiles::UpdateProcessToPending($CompanyID,$CompanyGatewayID,$CronJob,$cronsetting);

			/** get pending files */
			$filenames = UsageDownloadFiles::getVosPendingFile($CompanyGatewayID);

			/** remove last downloaded */
			//$lastelse = array_pop($filenames);

			Log::error('File Count ' . count($filenames));
			$file_count = 1;

			$error = array();
			Log::error(' ========================== Vendor Rate  Transaction start =============================');
			CronJob::createLog($CronJobID);

			$Trunks = Trunk::where(["CompanyId"=>$CompanyID])->get()->toArray();
			$TrunkArray = array();
			if(count($Trunks)>0){

				foreach($Trunks as $trunk){
					$TrunkArray[$trunk["Trunk"]] =$trunk["TrunkID"];
				}

			}
			foreach ($filenames as $UsageDownloadFilesID => $filename) {
				Log::info("Loop Start");
				$row_count = 0;
				if ($filename != '' && $file_count <= $FilesMaxProcess) {

					$param = array();
					$param['filename'] = $filename;

					Log::info("Insert Start ".$filename." processID: ".$processID);

					/** update file status to progress */
					UsageDownloadFiles::UpdateFileStausToProcess($UsageDownloadFilesID,$processID);

					$delete_files[] = $UsageDownloadFilesID;
					$fullpath = $FileLocationTo.'/'.$CompanyGatewayID. '/' ;


					try {

							$InserData = array();
							$TrunkID = $AccountID = 0;
							$row_count = 0;

							$rows =   Streamco::getFileContent($fullpath.$filename);

							//while (($row = fgetcsv($handle, 1000, ",")) !== FALSE) {

							foreach($rows as $key => $row) {


								if (!empty($row['GatewayAccountName'])) {

									if($row_count==0) {


										if(isset($row['GatewayTrunk']) && array_key_exists($row['GatewayTrunk'],$TrunkArray)){
											$TrunkID = $TrunkArray[$row['GatewayTrunk']];
										}

										if(isset($row['GatewayTrunk']) && $TrunkID == 0 ) {

											$TrunkID = Trunk::where(["CompanyId"=>$CompanyID,"Trunk"=>$row['GatewayTrunk'],"Status"=>1])->pluck("TrunkID");
											if(empty($TrunkID)) {

												$trunk_data = array(
													"CompanyId"=>$CompanyID,
													"Trunk"=>$row['GatewayTrunk'],
													"Status"=>1
												);
												$TrunkID = Trunk::insertGetId($trunk_data);


												$TrunkArray[$row["GatewayTrunk"]] =$TrunkID;
												Log::error("New Trunk created " . $row['GatewayTrunk'] );

											}

										} else {
											Log::error("Trunk Not exists in file " . $fullpath.$filename);
										}


										$Accounts = Account::getAccountIDList( array( 'IsVendor'=>1, 'CompanyID' => $CompanyID ) );
										//print_r($Accounts);
										if( isset($row['GatewayAccountName']) ) {

											if( !in_array($row['GatewayAccountName'], $Accounts) ) {

												$error[] = "Account Name '" . $row['GatewayAccountName'] . "' not found.";

												UsageDownloadFiles::UpdateToPending([$UsageDownloadFilesID]);

												break;
											} else {

												$AccountID = array_search($row['GatewayAccountName'], $Accounts);
											}
										}

									}
									if ($TrunkID > 0 && $AccountID > 0 ) {

										$uddata = array();
										$uddata['CompanyID'] = $CompanyID;
										$uddata['CompanyGatewayID'] = $CompanyGatewayID;
										$uddata['AccountID'] = $AccountID;
										$uddata['TrunkID'] = $TrunkID;
										$uddata['Code'] = $row['Code'];
										$uddata['Rate'] = $row['Rate'];
										$uddata['Preference'] = $row['Preference'];
										$uddata['ConnectionFee'] = $row['ConnectionFee'];
										$uddata['EffectiveDate'] = $row['EffectiveDate'];
										$uddata['Interval1'] = $row['Interval1'];
										$uddata['IntervalN'] = $row['IntervalN'];

										$uddata['ProcessID'] = (string) $processID;

										$InserData[] = $uddata;

										if ($data_count > $insertLimit && !empty($InserData)) {
											DB::table($temptableName)->insert($InserData);
											$InserData = array();
											$data_count = 0;
										}

										$row_count++;

									} else {

										Log::error("Trunk & Account are not found ");
										Log::error(print_r($row,true));

									}
								}
								$data_count++;


							}//loop

							if(!empty($InserData)){
								DB::table($temptableName)->insert($InserData);
							}

					}catch(\Exception $e){

						Log::error($e);
						/** update file status to error */
						UsageDownloadFiles::UpdateFileStatusToError($CompanyID,$cronsetting,$CronJob->JobTitle,$UsageDownloadFilesID,$e->getMessage());

						if( isset($row['GatewayAccountName']) ) {
							$error[] = "Error importing File '" . $fullpath.$filename . "' -  Error: " . $e->getMessage();
						}

					}

					Log::info("Rate Insert END");

					if($row_count>0) {
						$file_count++;
					}
				} else {
					break;
					// all files processed till max limit.
				}

			}
			Log::info("Loop End");


			Log::error(' ========================== vos transaction end =============================');
			//ProcessCDR

			Log::info("ProcessRate($processID,$temptableName)");

			DB::beginTransaction();

					RateImportExporter::importVendorRate($processID,$temptableName);

			DB::commit();

			$joblogdata['Message'] = 'Total  ' . $file_count .' files imported';

			$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;

			CronJobLog::insert($joblogdata);

			DB::table($temptableName)->where(["processId" => $processID])->delete();

		} catch (\Exception $e) {
			try {
				DB::rollback();
			} catch (\Exception $err) {
				Log::error($err);
			}
			try {
				/** put back file to pending if any error occurred */
				UsageDownloadFiles::UpdateToPending($delete_files);

			} catch (\Exception $err) {
				Log::error($err);
			}
			// delete temp table if process fail
			try {
				DB::table($temptableName)->where(["processId" => $processID])->delete();

			} catch (\Exception $err) {
				Log::error($err);
			}

			Log::error($e);

			$this->info('Failed:' . $e->getMessage());
			$joblogdata['Message'] = 'Error:' . $e->getMessage();
			$joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
			CronJobLog::insert($joblogdata);
			Log::error($e);
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

		DB::disconnect();

		CronHelper::after_cronrun($this->name, $this);


	}

}