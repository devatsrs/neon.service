<?php namespace App\Console\Commands;

use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Service;
use App\ClarityPBX;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Config;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;

class exportClarityPBXPayments extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'exportclaritypbxpayments';

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

		Log::useFiles(storage_path() . '/logs/exportClarityPBXPayments-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');

		$joblogdata = array();
		$joblogdata['CronJobID'] = $CronJobID;
		$joblogdata['created_at'] = date('Y-m-d H:i:s');
		$joblogdata['created_by'] = 'RMScheduler';
		try {
			CronJob::createLog($CronJobID);
			$clarityPBX = new ClarityPBX($CompanyGatewayID);
			$TimeZone = CompanyGateway::getGatewayTimeZone($CompanyGatewayID);
			if ($TimeZone != '') {
				date_default_timezone_set($TimeZone);
			} else {
				date_default_timezone_set('GMT'); // just to use e in date() function
			}

			$start_date = date('Y-m-d 00:00:00', strtotime('-'.$exportdayslimit.' day'));
			Log::error(print_r($start_date, true));

			/** Start Add payment in ClarityPBX */

			$response = DB::connection('sqlsrv2')->select("call prc_getClarityPBXExportPayment(".$CompanyID.",'".$start_date."',0)");
			$response = json_decode(json_encode($response), true);
			Log::info('count ==' . count($response));
			$InsertData = array();
			$countInsert=0;
			$error = array();
			if ($response) {
				foreach ((array)$response as $row_account) {
					$paymentArr=array();
					$paymentArr["AccountName"]	= $row_account["AccountName"];
					$paymentArr["Amount"]		= $row_account["Amount"];
					$paymentArr["Recall"]		= $row_account['Recall'];

					$result = $clarityPBX->updateAccountBalance($paymentArr);

					if (isset($result['Status']) && $result['Status'] == 'OK') {
						$ClarityPaymentData['PaymentID'] 	= $row_account['PaymentID'];
						$ClarityPaymentData['CompanyID'] 	= $row_account['CompanyID'];
						$ClarityPaymentData['AccountID'] 	= $row_account['AccountID'];
						$ClarityPaymentData['Amount'] 		= $row_account['Amount'];
						$ClarityPaymentData['Recall'] 		= $row_account['Recall'];

						DB::connection('sqlsrv2')->table('tblClarityPBXPayment')->insert($ClarityPaymentData);

						$countInsert++;
					} else {
						$error[] = $result['faultString'];
					}
				}//loop

			}
			/** End Add payment in ClarityPBX */

			/** Start Deduct recall payment in ClarityPBX */

			$recallresponse = DB::connection('sqlsrv2')->select("call prc_getClarityPBXExportPayment(".$CompanyID.",'".$start_date."',1)");
			$recallresponse = json_decode(json_encode($recallresponse), true);
			Log::info('Recall count ==' . count($recallresponse));
			if(!empty($recallresponse)) {
				foreach ((array)$recallresponse as $row_account) {
					$paymentArr=array();
					$paymentArr["AccountName"]	= $row_account["AccountName"];
					$paymentArr["Amount"]		= $row_account["Amount"];
					$paymentArr["Recall"]		= $row_account['Recall'];

					$result = $clarityPBX->updateAccountBalance($paymentArr);

					if (isset($result['Status']) && $result['Status'] == 'OK') {
						$ClarityPaymentData['PaymentID'] 	= $row_account['PaymentID'];
						$ClarityPaymentData['CompanyID'] 	= $row_account['CompanyID'];
						$ClarityPaymentData['AccountID'] 	= $row_account['AccountID'];
						$ClarityPaymentData['Amount'] 		= $row_account['Amount'];
						$ClarityPaymentData['Recall'] 		= $row_account['Recall'];

						DB::connection('sqlsrv2')->table('tblClarityPBXPayment')->insert($ClarityPaymentData);

						$countInsert++;
					} else {
						$error[] = $result['faultString'];
					}
				}//loop
			}

			/** End Deduct recall payment in ClarityPBX */

			date_default_timezone_set(Config::get('app.timezone'));

			if(!empty($error)) {
				$error = array_unique($error);
				$error[] = "Payment Updated ".$countInsert;
				$joblogdata['Message'] = implode('<br/>',$error);
			} else {
				$joblogdata['Message'] = "Payment Updated ".$countInsert;
			}

			$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;

			Log::error(' ========================== import ClarityPBX payments end =============================');
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
