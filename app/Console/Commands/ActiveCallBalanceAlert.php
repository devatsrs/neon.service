<?php namespace App\Console\Commands;

use App\Lib\AccountBalance;
use App\Lib\ActiveCall;
use App\Lib\CronHelper;
use App\Lib\NeonAPI;
use App\Lib\Helper;
use App\Lib\SpeakIntelligenceAPI;
use Illuminate\Console\Command;
use Symfony\Component\Console\Input\InputArgument;
use App\Lib\CompanyGateway;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\AccountPaymentAutomation;
use App\Lib\Company;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Config;
use \Exception;

class ActiveCallBalanceAlert extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'activecallbalancealert';

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
            ['CronJobID', InputArgument::REQUIRED, 'Argument CronJobID '],
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
        $CompanyID = $arguments['CompanyID'];
        $MainCronJobID = $arguments['CronJobID'];
        $MainCronJob = CronJob::find($MainCronJobID);
        CronJob::activateCronJob($MainCronJob);


        $joblogdata = array();
        $joblogdata['CronJobID'] = $MainCronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';
        $Error=0;

        $Maincronsetting = json_decode($MainCronJob->Settings,true);
        $APIURL=isset($Maincronsetting['APIURL'])?$Maincronsetting['APIURL']:'';
        $BlockCallAPI=isset($Maincronsetting['BlockCallAPI'])?$Maincronsetting['BlockCallAPI']:'';

        CronJob::createLog($MainCronJobID);
        Log::useFiles(storage_path() . '/logs/activecallbalancealert-' .$CompanyID.'-'. date('Y-m-d') . '.log');
        Log::error(' ========================== active Call Balance start =============================');

        if($APIURL!=''){
            try {
                $processID = CompanyGateway::getProcessID();
                CompanyGateway::updateProcessID($MainCronJob,$processID);
                //BalanceAlert
                $LowBalanceArr=$ErrorAccount=array();

                /**
                 * This cronjob will check (accountbalance - live call balance) of Account (Active Call)
                 * if account balance is zero or less than we will send reminder (alert)
                */
                $Count = 0;
                while(1) { // infinite loop
                    try {
                        log::info('Loop is working');
                        $Count++;
                        $ActiveCallAccountIDs = ActiveCall::getUniqueAccountIDByComapny($CompanyID);
                        if (!empty($ActiveCallAccountIDs)) {
                            foreach ($ActiveCallAccountIDs as $AccountID) {

                                $AccountBalanceData = DB::connection('neon_routingengine')->select("call prc_getActiveCallCostByAccount ('" . $AccountID . "')");
                                if (count($AccountBalanceData) > 0) {
                                    //log::info(print_r($AccountBalanceData,true));
                                    $has_balance = $AccountBalanceData[0]->has_balance;
                                    $BalanceAmount = $AccountBalanceData[0]->BalanceAmount;

                                   // log::info('AccountID : ' . $AccountID . ' - has_balance : ' . $has_balance . ' - BalanceAmount : ' . $BalanceAmount);

                                    if (isset($has_balance) && $has_balance == 0) {
                                        log::info('Balance is low');
                                        Helper::trigger_command($CompanyID, "send_active_call_alert", $AccountID . ' ' . $APIURL);
                                    }

                                }

                            }
                        }
                    }catch (\Exception $ev) {
                        try {
                            Log::error($ev);
                        }catch (\Exception $ev) {

                        }

                        try {
                            $joblogdata['Message'] = 'Error:' . $ev->getMessage();
                            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
                            //CronJobLog::insert($joblogdata);
                            CronJobLog::createLog($MainCronJobID, $joblogdata);
                        }catch (\Exception $evv){

                        }
                        try{
                            if (!empty($cronsetting['ErrorEmail'])) {
                                $result = CronJob::CronJobErrorEmailSend($MainCronJobID, $ev);
                            }
                        }catch (\Exception $evvv){

                        }
                    }
                } // infinite loop over

                //Log::info(print_r($LowBalanceArr,true));die;

                if(empty($LowBalanceArr)){
                    $joblogdata['Message'] = "No Records Found.";
                    $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
                }


            }catch (\Exception $e) {
                Log::error($e->getMessage());
                $joblogdata['Message'] ='Error:'.$e->getMessage();
                $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
                //CronJobLog::insert($joblogdata);
                CronJobLog::createLog($MainCronJobID,$joblogdata);
                if(!empty($cronsetting['ErrorEmail'])) {

                    $result = CronJob::CronJobErrorEmailSend($MainCronJobID,$e);
                    Log::error("**Email Sent Status " . $result['status']);
                    Log::error("**Email Sent message " . $result['message']);
                }
                $Error=1;

            }
        }else{
            $joblogdata['Message'] ="API URL Not Found.";
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            $Error=1;

        }

        CronJobLog::createLog($MainCronJobID,$joblogdata);

        CronJob::deactivateCronJob($MainCronJob);

        if(!empty($Maincronsetting['SuccessEmail']) && $Error==0){
            $result = CronJob::CronJobSuccessEmailSend($MainCronJobID);
            Log::error("**Email Sent Status ".$result['status']);
            Log::error("**Email Sent message ".$result['message']);
        }
        Log::error(' ========================== active cronjob end =============================');

        CronHelper::after_cronrun($this->name, $this);

    }

}
