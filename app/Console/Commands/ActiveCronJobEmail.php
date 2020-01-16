<?php namespace App\Console\Commands;

use App\Lib\CronHelper;
use App\Lib\Helper;
use Illuminate\Console\Command;
use Symfony\Component\Console\Input\InputArgument;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Company;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Config;
use \Exception;

class ActiveCronJobEmail extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'activecronjobemail';

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
        /*$maindataactive['PID'] = $getmypid;
        $MainCronJob->update($maindataactive);*/
        //CronJob::activateCronJob($MainCronJob);

        $joblogdata = array();
        $joblogdata['CronJobID'] = $MainCronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';

        $Maincronsetting = json_decode($MainCronJob->Settings,true);
        $ActiveCronJobEmailMinute = isset($Maincronsetting['AlertEmailInterval']) ? $Maincronsetting['AlertEmailInterval'] : '';
        //CronJob::createLog($MainCronJobID);
        Log::useFiles(storage_path() . '/logs/activecronjob-' . date('Y-m-d') . '.log');
        Log::error(' ========================== active cronjob start =============================');
        try {
            $acarray = DB::select('CALL  prc_ActiveCronJobEmail (' . $CompanyID .") ");
            $Message="";
            $msg="";
            foreach($acarray as $ac) {
                if (isset($ac->CronJobID) && $ac->CronJobID > 0) {
                    $CurrentServerIp = getenv("SERVER_LOCAL_IP");
                    if($CurrentServerIp != $ac->RunningOnServer) {
                        continue;
                    }

                    Log::error(' ========================== active cronjob email start =============================');
                    $CronJobID = $ac->CronJobID;
                    $cronsetting = json_decode($ac->Settings,true);
                    try {
                        $JobTitle = $ac->JobTitle;
                        $LastRunTime = $ac->LastRunTime;
                        $LastEmailSendTime = $ac->EmailSendTime;
                        $PID = $ac->PID;
                        Log::error("CronJob PID - ".$PID);
                        Log::error("CronJob Title - ".$JobTitle);
                        Log::error("CronJob ID - ".$CronJobID);
                        Log::error("CronJob Last Run Time ".$LastRunTime);
                        //check cron job is running time
                        $minute = CronJob::calcTimeDiff($LastRunTime);

                        Log::error("CronJob Active Minutes ".$minute);

                        $limitTime = isset($cronsetting['ThresholdTime']) ? $cronsetting['ThresholdTime'] : '';
                        //check cron job is running more than limit time
                        if(isset($minute) && (int)$minute >= (int)$limitTime )
                        {
							Log::error("LastRunTime ". $LastRunTime );
							Log::error("Minutes ". $minute . " >  " . (int)$limitTime);
                            Log::error("CronJob Active Need To Update");
							
                            $emailstatus = CronJob::ActiveCronJobEmailSend($ac);

                            $msg.=$JobTitle." - Running Since ".$minute." min <br>";

                            if($emailstatus == -1 ){

                                // Error Email is not setup.
                                //Log::info($JobTitle . "  - Error Email not setup ");

                            }
                            else if (isset($emailstatus['status']) && $emailstatus['status'] == 1) {

                                CronJob::find($CronJobID)->update(['EmailSendTime'=>date('Y-m-d H:i:s')]);

                                //Log::error($JobTitle . "  - Threshold limit Email Sent  -  Time : " . $EmailSendTime);

                            } else {

                                Log::error('Failed to send Active Cron Job Email Reason - ' . print_r($emailstatus, true));
                            }


                        }

                    }catch (\Exception $err) {
                        Log::error($err);
                    }
                    Log::error(' ========================== active cronjob email end =============================');
                }
            } // foreach end
            if($msg!=''){
                $Message="Following Cron Jobs are killed : <br>";
                $Message.=$msg;
            }else{
                $Message="No Actions";
            }
            //$joblogdata['Message'] = 'Success';
            $joblogdata['Message'] = $Message;
            $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
            //CronJobLog::insert($joblogdata);

            // if lock error occurs then comment below line
            CronJobLog::createLog($MainCronJobID,$joblogdata);

        }catch (\Exception $e) {
            Log::error($e);
            $joblogdata['Message'] ='Error:'.$e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            //CronJobLog::insert($joblogdata);

            // if lock error occurs then comment below line
            CronJobLog::createLog($MainCronJobID,$joblogdata);

            if(!empty($Maincronsetting['ErrorEmail'])) 
            {
                $result = CronJob::CronJobErrorEmailSend($MainCronJobID,$e);
                Log::error("**Email Sent Status ".$result['status']);
                Log::error("**Email Sent message ".$result['message']);
            }
        }
        //$maindataactive['Active'] = 0;
        /*$maindataactive['PID'] = '';
        $MainCronJob->update($maindataactive);*/

        //CronJob::deactivateCronJob($MainCronJob);

        if(!empty($Maincronsetting['SuccessEmail'])){
            $result = CronJob::CronJobSuccessEmailSend($MainCronJobID);
            Log::error("**Email Sent Status ".$result['status']);
            Log::error("**Email Sent message ".$result['message']);
        }
        Log::error(' ========================== active cronjob end =============================');

        CronHelper::after_cronrun($this->name, $this);

    }

}
