<?php namespace App\Console\Commands;

use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Service;
use App\PBX;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Config;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;

class exportPbxPayments extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'exportpbxpayments';

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

	public function fire()
	{
		CronHelper::before_cronrun($this->name, $this );
		$arguments = $this->argument();
		$getmypid = getmypid(); // get proccess id
		$CronJobID = $arguments["CronJobID"];
		$CompanyID = $arguments["CompanyID"];
		$CronJob = CronJob::find($CronJobID);
		$cronsetting = json_decode($CronJob->Settings,true);
		$dataactive['Active'] = 1;
		$dataactive['PID'] = $getmypid;
		$dataactive['LastRunTime'] = date('Y-m-d H:i:00');
		$CronJob->update($dataactive);
		$CompanyGatewayID = $cronsetting['CompanyGatewayID'];
		$exportdayslimit = trim($cronsetting['exportdayslimit']);

		if(empty($exportdayslimit)){
			$exportdayslimit=2;
		}
		Log::useFiles(storage_path() . '/logs/exportPbxPayments-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');

		$joblogdata = array();
		$joblogdata['CronJobID'] = $CronJobID;
		$joblogdata['created_at'] = date('Y-m-d H:i:s');
		$joblogdata['created_by'] = 'RMScheduler';
		try {
			CronJob::createLog($CronJobID);
			$pbx = new PBX($CompanyGatewayID);
			$TimeZone = CompanyGateway::getGatewayTimeZone($CompanyGatewayID);
			if ($TimeZone != '') {
				date_default_timezone_set($TimeZone);
			} else {
				date_default_timezone_set('GMT'); // just to use e in date() function
			}

			$start_date = date('Y-m-d 00:00:00', strtotime('-'.$exportdayslimit.' day'));
			Log::error(print_r($start_date, true));

			/** Start insert payment in pbx */

			$response = DB::connection('sqlsrv2')->select("call prc_getPBXExportPayment(".$CompanyID.",'".$start_date."',0)");
			$response = json_decode(json_encode($response), true);
			Log::info('count ==' . count($response));
			$InsertData = array();
			$countInsert=0;
			if ($response) {
				foreach ((array)$response as $row_account) {
					$paymentArr=array();
					$paymentArr["bi_description"]=$row_account["Notes"];
					$paymentArr["bi_date"]=$row_account["PaymentDate"];
					$paymentArr["bi_amount"]=$row_account["Amount"];
					$TenantsID = $pbx->getAccountTenantsID($row_account["Number"]);
					if($TenantsID){
						$paymentArr["bi_te_id"]=$TenantsID;
						$InsertData[]=$paymentArr;
					}
				}//loop

				if (!empty($InsertData)) {
					$countInsert=$pbx->insertBillings($InsertData);
				}
			}
			/** End insert payment in pbx */

			/** Start Delete recall payment in pbx */

			$recallresponse = DB::connection('sqlsrv2')->select("call prc_getPBXExportPayment(".$CompanyID.",'".$start_date."',1)");
			$recallresponse = json_decode(json_encode($recallresponse), true);
			Log::info('Recall count ==' . count($recallresponse));
			if(!empty($recallresponse)) {
				foreach ((array)$recallresponse as $row_account) {
					$paymentArr=array();
					$paymentArr["bi_description"]=$row_account["Notes"];
					$paymentArr["bi_date"]=$row_account["PaymentDate"];
					$paymentArr["bi_amount"]=$row_account["Amount"];
					$TenantsID = $pbx->getAccountTenantsID($row_account["Number"]);
					if(!empty($TenantsID)){
						$paymentArr["bi_te_id"]=$TenantsID;
						$pbx->deleteRecallID($paymentArr);
					}
				}
			}

			/** End Delete recall payment in pbx */

			date_default_timezone_set(Config::get('app.timezone'));

			$joblogdata['Message'] = "Record Insert ".$countInsert;
			$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
			Log::error(' ========================== import pbx payments end =============================');
			DB::connection('sqlsrv2')->commit();
			CronJobLog::insert($joblogdata);

		} catch (\Exception $e) {
			try {
				DB::rollback();
				DB::connection('sqlsrv2')->rollback();
			} catch (\Exception $err) {
				Log::error($err);
			}
			date_default_timezone_set(Config::get('app.timezone'));
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

		CronHelper::after_cronrun($this->name, $this);
	}
}
