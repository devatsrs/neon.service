<?php namespace App\Console\Commands;

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
        $ActiveCronJobEmailMinute = isset($Maincronsetting['AlertEmailInterval']) ? $Maincronsetting['AlertEmailInterval'] : '';
        CronJob::createLog($MainCronJobID);
        Log::useFiles(storage_path() . '/logs/activecronjob-' . date('Y-m-d') . '.log');
        Log::error(' ========================== active cronjob start =============================');
        try {
            $acarray = DB::select('CALL  prc_ActiveCronJobEmail (' . $CompanyID .") ");
            foreach($acarray as $ac) {
                if (isset($ac->CronJobID) && $ac->CronJobID > 0) {

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
                        if(isset($minute) && (int)$minute > (int)$limitTime )
                        {
							Log::error("LastRunTime ". $LastRunTime );
							Log::error("Minutes ". $minute . " >  " . (int)$limitTime);
                            Log::error("CronJob Active Need To Update");
							
                            $EmailSendTime = date('Y-m-d H:i:s');

                            //check cron job email is send before any time

							//if(empty($LastEmailSendTime))
							if(true)	// always email as its terminating jobs in CronJob::ActiveCronJobEmailSend
                            {
                                //if not sent before
                                if(!empty($cronsetting['ErrorEmail'])) {

                                    $emailstatus = CronJob::ActiveCronJobEmailSend($ac);

                                    if (isset($emailstatus['status']) && $emailstatus['status'] == 1) {

                                        CronJob::find($CronJobID)->update(['EmailSendTime'=>$EmailSendTime]);

                                        Log::error($JobTitle . "  - Threshold limit Email Sent  -  Time : " . $EmailSendTime);

                                    } else {

                                        Log::error('Failed to send Active Cron Job Email Reason - ' . print_r($emailstatus, true));
                                    }
                                }
                            }
                            else{

                                //check cron job email time of previous mail send
                                $LastEmailSend = CronJob::calcTimeDiff($LastEmailSendTime);

                                if(isset($LastEmailSend) && (int)$LastEmailSend > (int)$ActiveCronJobEmailMinute)
                                {
                                    if(!empty($cronsetting['ErrorEmail'])) {

                                        $emailstatus = CronJob::ActiveCronJobEmailSend($CronJobID);

                                        if (isset($emailstatus['status']) && $emailstatus['status'] == 1) {
                                            CronJob::find($CronJobID)->update(['EmailSendTime'=>$EmailSendTime]);
                                            Log::error($emailstatus['message']);
                                            Log::error("Cron Job Email Send Time : " . $EmailSendTime);

                                            Log::error($JobTitle . "  - Threshold limit Email Sent  -  Time : " . $EmailSendTime);

                                        } else {

                                            Log::error('Failed to send Active Cron Job Email Reason - ' . print_r($emailstatus, true));
                                        }
                                    }
                                }

                            }

                        }

                    }catch (\Exception $err) {
                        Log::error($err);
                    }
                    Log::error(' ========================== active cronjob email end =============================');
                }
            } // foreach end
            $joblogdata['Message'] = 'Success';
            $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
            CronJobLog::insert($joblogdata);
        }catch (\Exception $e) {
            Log::error($e);
            $joblogdata['Message'] ='Error:'.$e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            CronJobLog::insert($joblogdata);
            if(!empty($Maincronsetting['ErrorEmail']))
            {
                $result = CronJob::CronJobErrorEmailSend($MainCronJobID,$e);
                Log::error("**Email Sent Status ".$result['status']);
                Log::error("**Email Sent message ".$result['message']);
            }
        }
        //$maindataactive['Active'] = 0;
        $maindataactive['PID'] = '';
        $MainCronJob->update($maindataactive);

        if(!empty($Maincronsetting['SuccessEmail'])){
            $result = CronJob::CronJobSuccessEmailSend($MainCronJobID);
            Log::error("**Email Sent Status ".$result['status']);
            Log::error("**Email Sent message ".$result['message']);
        }
        Log::error(' ========================== active cronjob end =============================');

    }

}
