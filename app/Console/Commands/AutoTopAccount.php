<?php namespace App\Console\Commands;




use App\Lib\CronHelper;
use App\Lib\NeonAPI;
use App\Lib\Summary;
use App\Lib\AccountPaymentAutomation;
use Illuminate\Console\Command;
use App\Lib\CronJob;
use App\Lib\Account;
use App\Lib\Company;
use App\Lib\Notification;
use App\Lib\Helper;
use App\Lib\CompanyConfiguration;
use App\Lib\CronJobLog;
use App\Lib\AccountBalance;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use \Exception;
use Symfony\Component\Console\Input\InputArgument;
use Illuminate\Support\Facades\Crypt;
use App\Lib\CompanyGateway;

class AutoTopAccount extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'AutoTopAccount';

	/**
	 * The console command description.
	 *
	 * @var string
	 */
	protected $description = 'AutoTopAccount Command description.';

	protected function getArguments()
	{
		return [
			['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID '],
			['CronJobID', InputArgument::REQUIRED, 'Argument CronJobID'],
		];
	}

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
    public function handle() {
        
        CronHelper::before_cronrun($this->name, $this );
		$SuccessDepositAccount = array();
		$FailureDepositFund = array();
        $arguments = $this->argument();
        $CompanyID = $arguments["CompanyID"];
        $CronJobID = $arguments["CronJobID"];
        
        $CronJob =  CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);
        CronJob::activateCronJob($CronJob);
        CronJob::createLog($CronJobID);
        
        //print_r($cronsetting);die();
        Log::useFiles(storage_path() . '/logs/AutoTopAccount-companyid-'.$CompanyID . '-cronjobid-'.$CronJobID.'-' . date('Y-m-d') . '.log');
		try{

			$AutoPaymentAccountList = Account::
			Join('tblAccountPaymentAutomation','tblAccount.AccountID','=','tblAccountPaymentAutomation.AccountID')
				->select(['AccountName','tblAccount.AccountID','Number','MinThreshold','TopupAmount'])
				->where(['tblAccount.Status'=>1,'tblAccount.CompanyId'=>$CompanyID])
				->where('tblAccountPaymentAutomation.AutoTopup','=', 1)
				->orderBy("tblAccountPaymentAutomation.AccountID", "ASC");
			$AutoPaymentAccountList = $AutoPaymentAccountList->get();
			$CompanyConfiguration = CompanyConfiguration::where(['CompanyID' => $CompanyID, 'Key' => 'WEB_URL'])->pluck('Value');
			if(!empty($AutoPaymentAccountList) && !empty($CompanyConfiguration)) {
				foreach ($AutoPaymentAccountList as $AutoPaymentAccount) {
					$AccountBalance = AccountBalance::getAccountBalanceWithActiveCall($AutoPaymentAccount->AccountID);
					if ($AccountBalance >= $AutoPaymentAccount->MinThreshold && $AutoPaymentAccount->TopupAmount > 0) {
						$DepositAccount = AccountPaymentAutomation::calldepositFundAPI($AutoPaymentAccount, $CompanyConfiguration);
						if (!empty($DepositAccount)) {
							if ($DepositAccount['status'] == "success") {
								$successRecord = array();
								$successRecord["AccountID"] = $AutoPaymentAccount->AccountID;
								$successRecord["AccountName"] = $AutoPaymentAccount->AccountName;
								$successRecord["Number"] = $AutoPaymentAccount->Number;
								$successRecord["Amount"] = $AutoPaymentAccount->TopupAmount;
								$SuccessDepositAccount[count($SuccessDepositAccount) + 1] = $successRecord;
								Log::info('Call the deposit API $DepositAccount success.' . count($SuccessDepositAccount));
							} else if ($DepositAccount['status'] == "failed") {
								$failedRecord = array();
								$failedRecord["AccountID"] = $AutoPaymentAccount->AccountID;
								$failedRecord["AccountName"] = $AutoPaymentAccount->AccountName;
								$failedRecord["Number"] = $AutoPaymentAccount->Number;
								$failedRecord["Response"] = $DepositAccount['response'];
								$FailureDepositFund[count($FailureDepositFund) + 1] = $failedRecord;
								Log::info('Call the deposit API $DepositAccount failed.' . count($FailureDepositFund));
							}
						}
					}

				}

				if (count($AutoPaymentAccountList) > 0) {
					if (count($FailureDepositFund) > 0 || count($SuccessDepositAccount)) {
						AccountPaymentAutomation::AutoTopUpNotification($CompanyID, $SuccessDepositAccount, $FailureDepositFund);
					}
				} else {
					Log::info('No Account IDs found for the auto top up.');
				}
			}

			CronJob::CronJobSuccessEmailSend($CronJobID);
			CronJob::deactivateCronJob($CronJob);
			CronHelper::after_cronrun($this->name, $this);
			//Log::info('routingList:Get the routing list user company.' . $CompanyID);
            Log::info('Run Cron.');
        }catch (\Exception $e){
            Log::error($e);
            $this->info('Failed:' . $e->getMessage());
            $joblogdata['Message'] ='Error:'.$e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            CronJobLog::insert($joblogdata);
            if(!empty($cronsetting['ErrorEmail'])) {
				$result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
				Log::error("**Email Sent Status " . $result['status']);
				Log::error("**Email Sent message " . $result['message']);
            }
  	  }

    }

}
