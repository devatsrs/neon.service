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

class importPBXPayments extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'importpbxpayments';

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
		$importdayslimit = trim($cronsetting['importdayslimit']);

		if(empty($importdayslimit)){
			$importdayslimit=2;
		}
//		$importdayslimit=366*2;
		Log::useFiles(storage_path() . '/logs/importpbxpayments-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');

		$joblogdata = array();
		$joblogdata['CronJobID'] = $CronJobID;
		$joblogdata['created_at'] = date('Y-m-d H:i:s');
		$joblogdata['created_by'] = 'RMScheduler';

		try {
			$processID = CompanyGateway::getProcessID();
			CronJob::createLog($CronJobID);
			$pbx = new PBX($CompanyGatewayID);
			$TimeZone = CompanyGateway::getGatewayTimeZone($CompanyGatewayID);
			if ($TimeZone != '') {
				date_default_timezone_set($TimeZone);
			} else {
				date_default_timezone_set('GMT'); // just to use e in date() function
			}

			$param['start_date_ymd'] = date('Y-m-d 23:59:59', strtotime('-'.$importdayslimit.' day'));
			$param['end_date_ymd'] = date('Y-m-d H:i:s');

			Log::error(print_r($param, true));
			$response = $pbx->getAccountPayments($param);
			$response = json_decode(json_encode($response), true);
			Log::info('count ==' . count($response));
			$InserData = array();

			if (!isset($response['faultCode'])) {
				foreach ((array)$response as $row_account) {
					$paymentArr=array();
					$paymentArr["ProcessID"]=$processID;
					$paymentArr["Note"]=$row_account["bi_description"];
					$paymentArr["PaymentDate"]=$row_account["bi_date"];
					$paymentArr["Amount"]=abs($row_account["bi_amount"]);
					$paymentArr["GatewayAccountID"]=$row_account["te_code"];

					$TransactionID=$row_account["bi_id"].$row_account["bi_te_id"].str_replace('-','',$row_account["bi_date"]);
					$TransactionID=str_replace(':','',$TransactionID);
					$TransactionID=str_replace(' ','',$TransactionID);
					$paymentArr["TransactionID"]=$TransactionID;

					$InserData[]=$paymentArr;
				}//loop

				if (!empty($InserData)) {
					DB::connection('sqlsrv2')->table('tblTempPBXPaymentDetail')->insert($InserData);
				}
				date_default_timezone_set(Config::get('app.timezone'));
			}

			Log::error("PBX CALL  prc_importPBXPaymentAccounting('" . $processID . "') start");
			$JobStatusMessage = DB::connection('sqlsrv2')->select("CALL  prc_importPBXPaymentAccounting('" . $processID . "')");
			Log::error("PBX CALL  prc_importPBXPaymentAccounting('" . $processID . "') end");

			$JobStatusMessage = array_reverse(json_decode(json_encode($JobStatusMessage),true));
			Log::info($JobStatusMessage);
			Log::info(count($JobStatusMessage));
			$joblogdata['Message'] = "Payment StartTime " . $param['start_date_ymd'] . " - End Time " . $param['end_date_ymd']." <br>";
			if(count($JobStatusMessage) > 1){
				$prc_error = array();
				foreach ($JobStatusMessage as $JobStatusMessage1) {
					$prc_error[] = $JobStatusMessage1['Message'];
				}
				$JobMessage = implode('<br>',fix_jobstatus_meassage($prc_error));				
				$joblogdata['Message'] .= $JobMessage;

			}elseif(!empty($JobStatusMessage[0]['Message'])){
				$JobMessage = $JobStatusMessage[0]['Message'];				
				$joblogdata['Message'] .= $JobMessage;
			}
			 
			$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
			Log::error("pbx payment StartTime " . $param['start_date_ymd'] . " - End Time " . $param['end_date_ymd']);
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
