<?php namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Lib\CronHelper;
use App\Lib\NeonAPI;
use App\Lib\Summary;
use App\Lib\RoutingProfileRate;
use App\Lib\CronJob;
use App\Lib\Account;
use App\Lib\Company;
use App\Lib\Notification;
use App\Lib\Helper;
use App\Lib\CompanyConfiguration;
use App\Lib\CronJobLog;
use App\Lib\Retention;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use \Exception;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;

class ContractManage extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'ContractManage';

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

	/**
	 * Execute the console command.
	 *
	 * @return mixed
	 */
	public function fire()
	{
		CronHelper::before_cronrun($this->name, $this );
		$SuccessDepositAccount = array();
		$FailureDepositFund = array();
		$ErrorDepositFund = array();
		$arguments = $this->argument();
		$CompanyID = $arguments["CompanyID"];
		$CronJobID = $arguments["CronJobID"];

		$CronJob =  CronJob::find($CronJobID);
		$cronsetting = json_decode($CronJob->Settings,true);
		CronJob::activateCronJob($CronJob);
		CronJob::createLog($CronJobID);

		//print_r($cronsetting);die();
		Log::useFiles(storage_path() . '/logs/ContractManage-companyid-'.$CompanyID . '-cronjobid-'.$CronJobID.'-' . date('Y-m-d') . '.log');
		try{
			$CancelContractManage = "CALL prc_Cancel_Contract_Manage()";
			$selectCancelContract  = DB::select($CancelContractManage);

			if(count($selectCancelContract) > 0){
				$ID = array();
				$InsertCancelHistory = array();

				foreach($selectCancelContract as $sel){

					array_push($ID,$sel->AccountServiceID);
					$InsertCancelHistory[] = [
						'Date' => DATE('y-m-d'),
						'Action' => 'Contract Cancel',
						'ActionBy' => 'System',
						'AccountServiceID' => $sel->AccountServiceID
					];
					DB::table('tblAccountServiceCancelContract')->where('AccountServiceID',$sel->AccountServiceID)->delete();
				}
				var_dump($ID);

				$data = array();
				$data['CancelContractStatus'] = 1;

				$AutoRenewal = array();
				$AutoRenewal['AutoRenewal'] = 0;


				/** Update The Status Of Contract In Account Service Table */
				DB::table('tblAccountService')->whereIn('AccountServiceID',$ID)->update($data);
				/** Change Cancel Contract Status In AccountService Table */
				DB::table('tblAccountServiceContract')->whereIn('AccountServiceID',$ID)->update($AutoRenewal);
				/** Save History In History Table */
				DB::table('tblAccountServiceHistory')->insert($InsertCancelHistory);
				}
			/**Contract Renewal */
			$ContractRenewal = "CALL prc_Renewal_Contract()";
			$selectRenewalContract  = DB::select($ContractRenewal);

			if(count($selectRenewalContract) > 0){
				$Renewal = array();
				$InsertRenewalHistory = array();
				//$InsertRenewalHistory = array();

				foreach($selectRenewalContract as $sel){
					$Renewal['ContractEndDate'] = date('y-m-d', strtotime($sel->ContractEndDate.' + '.$sel->Duration.' Months'));
					DB::table('tblAccountServiceContract')->where('AccountServiceID',$sel->AccountServiceID)->update($Renewal);
					$InsertRenewalHistory[] = [
						'Date' => DATE('y-m-d'),
						'Action' => 'Contract Renew',
						'ActionBy' => 'System',
						'AccountServiceID' => $sel->AccountServiceID

					];
				}

				DB::table('tblAccountServiceHistory')->insert($InsertRenewalHistory);
				var_dump($Renewal);
			}

			CronJob::deactivateCronJob($CronJob);
			CronHelper::after_cronrun($this->name, $this);
		}
		catch(Exception $ex){
			Log::useFiles(storage_path() . '/logs/ContractManage-Error-' . date('Y-m-d') . '.log');
			//Log::info('LCRRoutingEngine Error.');
			Log::useFiles(storage_path() . '/logs/ContractManage-Error-' . date('Y-m-d') . '.log');

			Log::error($ex);
			$this->info('Failed:' . $ex->getMessage());
			$joblogdata['Message'] ='Error:'.$ex->getMessage();
			$joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
			CronJobLog::insert($joblogdata);
			if(!empty($cronsetting['ErrorEmail'])) {

				$result = CronJob::CronJobErrorEmailSend($CronJobID,$ex);
				Log::error("**Email Sent Status " . $result['status']);
				Log::error("**Email Sent message " . $result['message']);
			}
		}
	}

	/**
	 * Get the console command arguments.
	 *
	 * @return array
	 */
	protected function getArguments()
	{
		return [
			['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID '],
			['CronJobID', InputArgument::REQUIRED, 'Argument CronJobID'],
		];
	}

	/**
	 * Get the console command options.
	 *
	 * @return array
	 */


}
