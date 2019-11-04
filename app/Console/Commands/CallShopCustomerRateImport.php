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
use App\Lib\CustomerTrunk;
use App\RateImportExporter;
use App\CallShop;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;

class CallShopCustomerRateImport extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'callshopcustomerrateimport';

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
		get rates from CallShop
		get/generate temptable name
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

		$data_count = 0;
		$insertLimit = 1000;

		$CompanyGatewayID = $cronsetting['CompanyGatewayID'];

		CronJob::activateCronJob($CronJob);

		$joblogdata['Message'] = '';

		Log::useFiles(storage_path() . '/logs/callshopcustomerrateimport-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');

		try {
			$processID = CompanyGateway::getProcessID();
			$start_time = date('Y-m-d H:i:s');
			$callShop = new CallShop($CompanyGatewayID);
			$callshop_customers = $callShop->listCustomerNames();
			$end_time = date('Y-m-d H:i:s');
			$execution_time = strtotime($end_time) - strtotime($start_time);
			Log::info("execution time for getting accounts from CallShop : " . $execution_time . " seconds");
			Log::info('accounts count from CallShop : '.count($callshop_customers));

			$start_time = date('Y-m-d H:i:s');
			if(isset($cronsetting['customers']) && $cronsetting['customers'] != '') {
				$AccountIDs = $cronsetting['customers'];
				//$Accounts = Account::whereIn('AccountID',$AccountIDs)->where(['IsCustomer'=>1])->select('AccountID','AccountName')->get();
				$Accounts = Account::whereIn('AccountID',$AccountIDs)->whereIn('AccountName',$callshop_customers)->where(['IsCustomer'=>1])->select('AccountID','AccountName')->get();
			} else {
				$a_data['Status'] = 1;
				$a_data['AccountType'] = 1;
				$a_data['VerificationStatus'] = Account::VERIFIED;
				$a_data['CompanyID'] = $CompanyID;
				$a_data['IsCustomer'] = 1;

				//$Accounts = Account::where($a_data)->select('AccountID','AccountName')->get();
				$Accounts = Account::where($a_data)->whereIn('AccountName',$callshop_customers)->select('AccountID','AccountName')->get();
			}
			$end_time = date('Y-m-d H:i:s');
			Log::info('Accounts which exist in both Neon and CallShop : '.count($Accounts));
			$execution_time = strtotime($end_time) - strtotime($start_time);
			Log::info("execution time for getting Accounts from NEON : " . $execution_time . " seconds");

			$temptableName = RateImportExporter::CreateIfNotExistTempRateImportTable($CompanyID,$CompanyGatewayID,'customer');
			$current_date = date('Y-m-d');
			Log::info("Start");

			$error = $error1 = array();
			Log::info(' ========================== Customer Rate  Transaction start =============================');
			CronJob::createLog($CronJobID);

			Log::info("Account Loop Start");
			$start_time = date('Y-m-d H:i:s');
			foreach ($Accounts as $Account) {
				$start_time_acc = date('Y-m-d H:i:s');
				try {
					$param['username'] = $Account->AccountName;
					$rates = $callShop->getRates($param);
//					Log::info(print_r($rates,true));exit;
					$InserData = array();
					$TrunkID = $AccountID = 0;

					$row_count = 0;

					$AccountID = $Account->AccountID;
					$AccountName = $Account->AccountName;

					if (!isset($rates['faultString']) && !isset($rates['faultCode'])) {
						if (isset($rates['rates']) && !empty($rates['rates']) && count($rates['rates']) > 0) {
							foreach ($rates['rates'] as $rate) {
								if ($row_count == 0) {
									if(isset($rate['estructura']) && !empty($rate['estructura']) && $rate['estructura'] != '') {
										$TrunkIDResult = DB::select("call prc_getTrunkByMaxMatch('".$CompanyID."','".$rate['estructura']."')");
										if(isset($TrunkIDResult[0]->TrunkID) && $TrunkIDResult[0]->TrunkID > 0) {
											$TrunkID = $TrunkIDResult[0]->TrunkID;
										}
									} else {
										$error_message = "Trunk Not exists for account : ". $AccountName;
										$error1[] = $error_message;
										Log::error($error_message);
										//throw  new \Exception($error_message);
									}

									if($TrunkID == 0) {
										$error_message = "Trunk not found for '" . $rate['estructura'];
										$error1[] = $error_message;
										Log::error($error_message);
										//throw  new \Exception($error_message);
									}

									if ($TrunkID > 0 && $AccountID > 0) {
										$CustomerTrunk = CustomerTrunk::where(["TrunkID"=>$TrunkID, "AccountID"=>$AccountID, "CompanyID"=>$CompanyID])->count();
										if($CustomerTrunk == 0) {
											$created_at = date('Y-m-d H:i:s');
											$CreatedBy = 'Rate Import';

											$customertrunkdata = array();
											$CodeDeckID = CodeDeck::getDefaultCodeDeckID($CompanyID);
											$customertrunkdata['CompanyID'] = $CompanyID;
											$customertrunkdata['AccountID'] = $AccountID;
											$customertrunkdata['TrunkID'] = $TrunkID;
											$customertrunkdata['Status'] = 1;
											$customertrunkdata['Prefix'] = LastPrefixNo::getLastPrefix($CompanyID);
											$customertrunkdata['CodeDeckID'] = $CodeDeckID;
											$customertrunkdata['created_at'] = $created_at;
											$customertrunkdata['CreatedBy'] = $CreatedBy;
											CustomerTrunk::insert($customertrunkdata);
											LastPrefixNo::updateLastPrefixNo($customertrunkdata['Prefix'], $CompanyID);
											Log::info("CustomerTrunk created " . $AccountName);
										}
									}

								}

								if ($TrunkID > 0 && $AccountID > 0) {
									$uddata = array();
									$uddata['CompanyID'] = $CompanyID;
									$uddata['CompanyGatewayID'] = $CompanyGatewayID;
									$uddata['AccountID'] = $AccountID;
									$uddata['Description'] = $rate['destino'];
									$uddata['TrunkID'] = $TrunkID;
									$uddata['Code'] = $rate['prefijo'];
									$uddata['Rate'] = $rate['importe'];
									//$uddata['Preference'] = $rate['Preference'];
									//$uddata['ConnectionFee'] = $rate['ConnectionFee'];
									$uddata['EffectiveDate'] = $current_date;
									$uddata['Interval1'] = $rate['psi'] == 0 ? 1 : $rate['psi'];
									$uddata['IntervalN'] = $rate['ps'];

									$uddata['ProcessID'] = (string)$processID;

									$InserData[] = $uddata;

									if ($data_count > $insertLimit && !empty($InserData)) {
										DB::table($temptableName)->insert($InserData);
										$InserData = array();
										$data_count = 0;
									}

									$row_count++;
								}
								$data_count++;
							}
							if (!empty($InserData)) {
								DB::table($temptableName)->insert($InserData);
								$InserData = array();
								$data_count = 0;
							}

							/** Code Added **/

							Log::info("ProcessRate ".$AccountName);

							DB::beginTransaction();
							DB::connection('sqlsrv2')->beginTransaction();

							$result_data = RateImportExporter::importCustomerRate($processID, $temptableName);
							if (count($result_data)) {
								$joblogdata['Message'] .=  implode('<br>', $result_data);
							} else {
								$joblogdata['Message'] .= $AccountName." No data imported";
							}

							DB::connection('sqlsrv2')->commit();
							DB::commit();

							DB::table($temptableName)->where(["processId" => $processID])->delete();

							/** Code Added **/

						} else {
							$error1[] = "rates not found for Account : '" . $Account->AccountName . "'";
						}
					} else {
						$error1[] = "Error getting rates for Account : '" . $Account->AccountName . "' -  Error: " . $rates['faultString'];
					}
				} catch (\Exception $e) {
					//Log::error($e);
					$err = "Error getting rates for Account : '" . $Account->AccountName . "' -  Error: " . $e;
					Log::error($err);
					$error[] = $err;
				}
				$end_time_acc = date('Y-m-d H:i:s');
				$execution_time_acc = strtotime($end_time_acc) - strtotime($start_time_acc);
				Log::info("execution time to import rates for account ".$Account->AccountName." : ".$execution_time_acc . " seconds");
			}
			$end_time = date('Y-m-d H:i:s');
			Log::info("Account Loop End");
			$execution_time = strtotime($end_time) - strtotime($start_time);
			Log::info("Account Loop execution time : ".$execution_time . " seconds");
			//Log::info('TempTable Data Count : '.DB::table($temptableName)->where(["processId" => $processID])->count());

			if(!empty($error)) {
				$joblogdata['Message'] = $joblogdata['Message'].implode('<br>',$error) ;
				$joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
			} else {
				$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
			}
			if(!empty($error1)) {
				$joblogdata['Message'] = $joblogdata['Message'] . implode('<br>', $error1);
			}

		} catch (\Exception $e) {
			try {
				DB::connection('sqlsrv2')->rollback();
				DB::rollback();
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