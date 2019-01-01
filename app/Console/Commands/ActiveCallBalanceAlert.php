<?php namespace App\Console\Commands;

use App\Lib\AccountBalance;
use App\Lib\ActiveCall;
use App\Lib\CronHelper;
use App\Lib\Helper;
use App\Lib\SpeakIntelligenceAPI;
use Illuminate\Console\Command;
use Symfony\Component\Console\Input\InputArgument;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
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

        $getmypid = getmypid();
        $arguments = $this->argument();
        $CompanyID = $arguments['CompanyID'];
        $MainCronJobID = $arguments['CronJobID'];
        $MainCronJob = CronJob::find($MainCronJobID);
        //$maindataactive['Active'] = 1;
        $maindataactive['PID'] = $getmypid;
        $MainCronJob->update($maindataactive);

        $joblogdata = array();
        $joblogdata['CronJobID'] = $MainCronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';

        $Maincronsetting = json_decode($MainCronJob->Settings,true);
        $APIURL=isset($Maincronsetting['APIURL'])?$Maincronsetting['APIURL']:'';

        CronJob::createLog($MainCronJobID);
        Log::useFiles(storage_path() . '/logs/activecallbalancealert-' . date('Y-m-d') . '.log');
        Log::error(' ========================== active Call Balance start =============================');

        if($APIURL!=''){
            try {
                //BalanceAlert
                $LowBalanceArr=$ErrorAccount=array();

                $ActiveCallAccountIDs=ActiveCall::getUniqueAccountID($CompanyID);

                foreach($ActiveCallAccountIDs as $AccountID){
                    $AccountBalance = AccountBalance::getNewAccountExposure($AccountID);
                    if($AccountBalance <= 0){
                        log::info($APIURL);
                        $UUIDS=ActiveCall::getUUIDByAccountID($CompanyID,$AccountID);
                        if(!empty($UUIDS[0])){
                            $ActiveCallArr=array();
                            $ActiveCallArr['CustomerID']=$AccountID;
                            $ActiveCallArr['Balance']=$AccountBalance;
                            $ActiveCallArr['UUID']=$UUIDS;
                            $LowBalanceArr[]=$ActiveCallArr;
                        }else{
                            $ErrorAccount[]=$AccountID;
                        }

                    }

                }

                //Log::info(print_r($LowBalanceArr,true));die;

                if(!empty($LowBalanceArr)){
                    $Result = SpeakIntelligenceAPI::BalanceAlert($APIURL,$LowBalanceArr);
                    Log::info("=====API Response =====");
                    Log::info(print_r($Result,true));

                    $joblogdata['Message'] = "success";
                    $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;

                    if(!empty($ErrorAccount)){
                        $joblogdata['Message'].=" <br/>";
                        $joblogdata['Message'].=" No UUID Found On the Following Account: ";
                        $joblogdata['Message'].=implode(",",$ErrorAccount);
                    }
                }else{
                    $joblogdata['Message'] = "No Records Found.";
                    $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
                }


            }catch (\Exception $e) {
                Log::error($e);
                $joblogdata['Message'] ='Error:'.$e->getMessage();
                $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
                CronJobLog::insert($joblogdata);

            }
        }else{
            $joblogdata['Message'] ="API URL Not Found.";
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
        }

        CronJobLog::createLog($MainCronJobID,$joblogdata);

        $maindataactive['PID'] = '';
        $MainCronJob->update($maindataactive);

        if(!empty($Maincronsetting['SuccessEmail'])){
            $result = CronJob::CronJobSuccessEmailSend($MainCronJobID);
            Log::error("**Email Sent Status ".$result['status']);
            Log::error("**Email Sent message ".$result['message']);
        }
        Log::error(' ========================== active cronjob end =============================');

        CronHelper::after_cronrun($this->name, $this);

    }

}
