<?php namespace App\Console\Commands;
use App\Lib\CronHelper;
use App\Lib\Job;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use Illuminate\Console\Command;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use \Exception;

class RateGenerator extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'rategenerator';

	/**
	 * The console command description.
	 *
	 * @var string
	 */
	protected $description = 'Generate rates against given rate table';

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
	 * Cron Job for Rate Table Generate
	 */
	public function fire()
	{


        CronHelper::before_cronrun($this->name, $this );


        $arguments = $this->argument();

        $CronJobID = $arguments["CronJobID"];
        $getmypid = getmypid(); // get proccess id
        $CronJob =  CronJob::find($CronJobID);
        $cronsetting =   json_decode($CronJob->Settings);
        $dataactive['Active'] = 1;
        $dataactive['PID'] = $getmypid;
        $dataactive['LastRunTime'] = date('Y-m-d H:i:00');
        $CronJob->update($dataactive);
        Log::useFiles(storage_path().'/logs/rategenerator-'.$CronJobID.'-'.date('Y-m-d').'.log');
        Log::error("Rate Generate start CronJobId" . $CronJobID);
        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';
        $EffectiveDay = 7;
        if(isset($cronsetting->EffectiveDay)){
            $EffectiveDay =$cronsetting->EffectiveDay;
        }
        try {
            CronJob::createLog($CronJobID);
            $CompanyID = $arguments["CompanyID"];
            $data['UserID'] = $CronJob->UserID;
            $data['RateGeneratorId']=$cronsetting->rateGeneratorID;
            $data['EffectiveDate'] = date('Y-m-d',strtotime('+'.$EffectiveDay.' days'));
            $data['RateTableId']= $cronsetting->rateTableID;
            $data['CompanyID'] = $CompanyID;
            $JobID = Job::GenerateJob("GRT",$data);
            if ($JobID > 0) {
                if(getenv('APP_OS') == 'Linux') {
                    pclose(popen(env('PHPExePath') . " " . env('RMArtisanFileLocation') . " ratetablegenerator " . $CompanyID . " " . $JobID . " ".$CronJobID." &", "r"));
                }else {
                    pclose(popen("start /B " . env('PHPExePath') . " " . env('RMArtisanFileLocation') . " ratetablegenerator " . $CompanyID . " " . $JobID . " ".$CronJobID, "r"));
                }
            }

           //Log::error("CDR StartTime " . $addparam['start_date'] . " - End Time " . $addparam['end_date']);

        }catch (\Exception $e) {
            Log::error("Rate Generate rollback CronJobId" . $CronJobID);
            $this->info('Failed:' . $e->getMessage());
            $joblogdata['Message'] ='Error:'.$e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            CronJobLog::insert($joblogdata);
            Log::error("RateGenerator : ". $e->getMessage());
            if(!empty($cronsetting->ErrorEmail)) {
                $result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
                Log::error("**Email Sent Status " . $result['status']);
                Log::error("**Email Sent message " . $result['message']);
            }
        }
        $dataactive['Active'] = 0;
        $dataactive['PID'] = '';
        $CronJob->update($dataactive);
        if(!empty($cronsetting->SuccessEmail))
        {
            $result = CronJob::CronJobSuccessEmailSend($CronJobID);
            Log::error("**Email Sent Status ".$result['status']);
            Log::error("**Email Sent message ".$result['message']);
        }
        Log::error("Rate Generate end CronJobId" . $CronJobID);


        CronHelper::after_cronrun($this->name, $this);


    }





}
