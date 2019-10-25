<?php namespace App\Console\Commands;

use App\Lib\Account;
use App\Lib\CodeDeck;
use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\LastPrefixNo;
use App\Lib\Trunk;
use App\Lib\UsageDownloadFiles;
use App\Lib\VendorTrunk;
use App\RateImportExporter;
use App\Streamco;
use Illuminate\Console\Command;
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


		CronJob::activateCronJob($CronJob);

		$joblogdata['Message'] = '';
		$delete_files = array();
		//$tempVendortable =  CompanyGateway::CreateVendorTempTable($CompanyID,$CompanyGatewayID);

		Log::useFiles(storage_path() . '/logs/vendorratefileprocess-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');

		try {
			$processID = CompanyGateway::getProcessID();
			$temptableName = RateImportExporter::CreateIfNotExistTempRateImportTable($CompanyID,$CompanyGatewayID,'vendor');
			$start_time = date('Y-m-d H:i:s');
			Log::info("Start");
			/** get process file make them pending*/
			UsageDownloadFiles::UpdateProcessToPendingStreamco($CompanyID,$CompanyGatewayID,$CronJob,$cronsetting,'vendor_rate');

			/** get pending files */
			$filenames = UsageDownloadFiles::getStreamcoVendorPendingFile($CompanyGatewayID);

			/** remove last downloaded */
			//$lastelse = array_pop($filenames);

			Log::error('File Count ' . count($filenames));
			$file_count = 1;

			$error = array();
			Log::error(' ========================== Vendor Rate  Transaction start =============================');
			CronJob::createLog($CronJobID);

			foreach ($filenames as $UsageDownloadFilesID => $filename) {
				Log::info("Loop Start");
				$row_count = 0;
				if ($filename != '' && $file_count <= $FilesMaxProcess) {

					$param = array();
					$param['filename'] = $filename;

					Log::info("Insert Start ".$filename." processID: ".$processID);

					/** update file status to progress */
					UsageDownloadFiles::UpdateFileStausToProcess($UsageDownloadFilesID,$processID);


					$fullpath = $FileLocationTo.'/'.$CompanyGatewayID. '/' ;


					try {

						$InserData = array();
						$TrunkID = $AccountID = 0;
						$row_count = 0;

						$rows =   Streamco::getFileContent($fullpath.$filename);

						//while (($row = fgetcsv($handle, 1000, ",")) !== FALSE) {
						if(!empty($rows) && count($rows) > 0){

							foreach($rows as $key => $row) {


								if (!empty($row['GatewayAccountName'])) {

									if ($row_count == 0) {

										if (isset($row['GatewayTrunk']) ) {
											$TrunkIDResult = DB::select("call prc_getTrunkByMaxMatch('".$CompanyID."','".$row['GatewayTrunk']."')");
											if(isset($TrunkIDResult[0]->TrunkID) && $TrunkIDResult[0]->TrunkID > 0) {
												$TrunkID = $TrunkIDResult[0]->TrunkID;
											}
										} else {

											$error_message = "GatewayTrunk Not exists in file.";

											//$error[] = $error_message;
											Log::error($error_message);
											throw  new \Exception($error_message);
										}

										if($TrunkID == 0){

											$error_message = "Trunk not found for '" . $row['GatewayTrunk'];

											//$error[] = $error_message;
											Log::error($error_message);
											throw  new \Exception($error_message);
										}


										$Accounts = Account::getAccountIDList(array('IsVendor' => 1, 'CompanyId' => $CompanyID));
										//print_r($Accounts);
										if (isset($row['GatewayAccountName'])) {

											if (!in_array($row['GatewayAccountName'], $Accounts)) {

												$error_message = "Account Name '" . $row['GatewayAccountName'] . "' not found";

												//$error[] = $error_message;
												Log::error($error_message);
												throw  new \Exception($error_message);

											} else {

												$AccountID = array_search($row['GatewayAccountName'], $Accounts);

											}
										}
										if ($TrunkID > 0 && $AccountID > 0) {

											$delete_files[] = $UsageDownloadFilesID;

											$VendorTrunk = VendorTrunk::where(["TrunkID"=>$TrunkID, "AccountID"=>$AccountID, "CompanyID"=>$CompanyID])->count();
											if($VendorTrunk == 0) {
												$created_at = date('Y-m-d H:i:s');
												$CreatedBy = 'Rate Import';

												$vendortrunkdata = array();
												$CodeDeckID = CodeDeck::getDefaultCodeDeckID($CompanyID);
												$vendortrunkdata['CompanyID'] = $CompanyID;
												$vendortrunkdata['AccountID'] = $AccountID;
												$vendortrunkdata['TrunkID'] = $TrunkID;
												$vendortrunkdata['Status'] = 1;
												$vendortrunkdata['CodeDeckID'] = $CodeDeckID;
												$vendortrunkdata['created_at'] = $created_at;
												$vendortrunkdata['CreatedBy'] = $CreatedBy;
												VendorTrunk::insert($vendortrunkdata);
												Log::error("VendorTrunk created " . $row['GatewayAccountName']);
											}


										}

									}
									if ($TrunkID > 0 && $AccountID > 0) {

										$uddata = array();
										$uddata['CompanyID'] = $CompanyID;
										$uddata['CompanyGatewayID'] = $CompanyGatewayID;
										$uddata['AccountID'] = $AccountID;
										$uddata['TrunkID'] = $TrunkID;
										$uddata['Code'] = $row['Code'];
										$uddata['Description'] = $row['Description'];
										$uddata['Rate'] = $row['Rate'];
										$uddata['Preference'] = $row['Preference'];
										$uddata['ConnectionFee'] = $row['ConnectionFee'];
										$uddata['EffectiveDate'] = $row['EffectiveDate'];
										$uddata['Interval1'] = $row['Interval1'];
										$uddata['IntervalN'] = $row['IntervalN'];

										$uddata['ProcessID'] = (string)$processID;

										$InserData[] = $uddata;

										if ($data_count > $insertLimit && !empty($InserData)) {
											DB::table($temptableName)->insert($InserData);
											$InserData = array();
											$data_count = 0;
										}

										$row_count++;

									}
								}
								$data_count++;

							}//loop
						}

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



			Log::info("ProcessRate($processID,$temptableName)");
			DB::beginTransaction();
			DB::connection('sqlsrv2')->beginTransaction();

			$result_data = RateImportExporter::importVendorRate($processID, $temptableName);
			if (count($result_data)) {
				$joblogdata['Message'] .=  implode('<br>', $result_data);
			} else {
				$joblogdata['Message'] .= "No data imported";
			}
			/** update file process to completed */
			UsageDownloadFiles::UpdateProcessToComplete($delete_files);

			DB::connection('sqlsrv2')->commit();
			DB::commit();

			if(!empty($error)) {
				$joblogdata['Message'] = $joblogdata['Message'].implode('<br>',$error) ;
				$joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
			} else {
				$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
			}

			DB::table($temptableName)->where(["processId" => $processID])->delete();

		} catch (\Exception $e) {
			try {
				DB::connection('sqlsrv2')->rollback();
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
			Log::error($e);
			if(!empty($cronsetting['ErrorEmail'])) {

				$result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
				Log::error("**Email Sent Status " . $result['status']);
				Log::error("**Email Sent message " . $result['message']);
			}
		}
		CronJobLog::createLog($CronJobID,$joblogdata);
		CronJob::deactivateCronJob($CronJob);

		if(!empty($cronsetting['SuccessEmail'])) {

			$result = CronJob::CronJobSuccessEmailSend($CronJobID);
			Log::error("**Email Sent Status ".$result['status']);
			Log::error("**Email Sent message ".$result['message']);

		}



		CronHelper::after_cronrun($this->name, $this);


	}

}