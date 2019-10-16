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
        //CronJob::activateCronJob($MainCronJob);

        $getmypid = getmypid();
        $LastRunTime = date('Y-m-d H:i:00');
        $ActiveCronJobQuery="CALL prc_ActivateCronJob(".$MainCronJobID.",1,'".$getmypid."','".$LastRunTime."')";
        DB::select($ActiveCronJobQuery);

        $processID = CompanyGateway::getProcessID();
        CompanyGateway::updateProcessID($MainCronJob,$processID);

        $joblogdata = array();
        $joblogdata['CronJobID'] = $MainCronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';
        $Error=0;

        $Maincronsetting = json_decode($MainCronJob->Settings,true);
        $APIURL=isset($Maincronsetting['APIURL'])?$Maincronsetting['APIURL']:'';
        $BlockCallAPI=isset($Maincronsetting['BlockCallAPI'])?$Maincronsetting['BlockCallAPI']:'';

        CronJob::createLog($MainCronJobID);
        Log::useFiles(storage_path() . '/logs/activecallbalancealert-' . date('Y-m-d') . '.log');
        Log::error(' ========================== active Call Balance start =============================');

        if($APIURL!=''){
            try {
                //BalanceAlert
                $LowBalanceArr=$ErrorAccount=array();

                /**
                 * This cronjob will check (accountbalance - live call balance) of Account (Active Call)
                 * if account balance is zero or less than we will send reminder (alert)
                */

                $ActiveCallAccountIDs=ActiveCall::getUniqueAccountID();
                if(!empty($ActiveCallAccountIDs)) {
                    foreach ($ActiveCallAccountIDs as $AccountID) {
                        $AccountBalance = AccountBalance::getAccountBalanceWithActiveCallRE($AccountID);
                        if ($AccountBalance <= 0) {
                            /** check auto top up is on or not */

                            log::info($APIURL);
                            $UUIDS = ActiveCall::getUUIDByAccountID($AccountID);
                            if (!empty($UUIDS[0])) {
                                $ActiveCallArr = array();
                                $ActiveCallArr['CustomerID'] = $AccountID;
                                $ActiveCallArr['Balance'] = $AccountBalance;
                                $ActiveCallArr['UUID'] = $UUIDS;
                                $LowBalanceArr[] = $ActiveCallArr;
                            } else {
                                $ErrorAccount[] = $AccountID;
                            }

                        }

                    }
                }

                //Log::info(print_r($LowBalanceArr,true));die;

                if(!empty($LowBalanceArr)){
                    $Result = SpeakIntelligenceAPI::BalanceAlert($APIURL,$LowBalanceArr);
                    Log::info("=====API Response =====");
                    Log::info(print_r($Result,true));
                    /*
                    if($BlockCallAPI != ''){
                        Log::info("=====Block Call API Start =====");
                        foreach($LowBalanceArr as $Callblock){
                            $BlockCallsApiArr = array();
                            $BlockCallsApiArr['AccountID']      = $Callblock['CustomerID'];
                            $BlockCallsApiArr['UUID']           = implode(",", $Callblock['UUID']);
                            $BlockCallsApiArr['DisconnectTime'] = date("Y-m-d H:i:s");
                            $BlockCallsApiArr['BlockReason']    = 'Insufficient Balance';
                            $JSONInput = json_encode($BlockCallsApiArr, true);
                            $Result = NeonAPI::callAPI($JSONInput,'',$BlockCallAPI,'application/json');
                            Log::info("Block call api response." . json_encode($Result));
                        }
                    }else{
                        $joblogdata['Message'] ="Block Call API URL Not Found.";
                        $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
                        $Error=1;
                    }*/

                    $joblogdata['Message'] = "success";
                    $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;

                    if(!empty($ErrorAccount)){
                        $joblogdata['Message'].=" <br/>";
                        $joblogdata['Message'].=" No UUID Found On the Following Account: ";
                        $joblogdata['Message'].=implode(",",$ErrorAccount);
                    }
                }else{
                    $joblogdata['Message'] = "No Records Found.";
                    $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
                }


            }catch (\Exception $e) {
                Log::error($e);
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

       // CronJob::deactivateCronJob($MainCronJob);

        DB::select("CALL prc_DeactivateCronJob(".$MainCronJobID.")");

        if(!empty($Maincronsetting['SuccessEmail']) && $Error==0){
            $result = CronJob::CronJobSuccessEmailSend($MainCronJobID);
            Log::error("**Email Sent Status ".$result['status']);
            Log::error("**Email Sent message ".$result['message']);
        }
        Log::error(' ========================== active cronjob end =============================');

        CronHelper::after_cronrun($this->name, $this);

    }

}
