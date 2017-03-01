<?php namespace App\Console\Commands;
use App\Lib\CompanyConfiguration;
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
            $data['RateGeneratorId']=$cronsetting->rateGeneratorID;
            $data['EffectiveDate'] = date('Y-m-d',strtotime('+'.$EffectiveDay.' days'));
            $data['RateTableId']= $cronsetting->rateTableID;
			
			if(isset($cronsetting->replace_rate)){
					$data['replace_rate']= $cronsetting->replace_rate;	
			}else{
				$data['replace_rate']= 0;
			}
			
			if(isset($cronsetting->EffectiveRate)){
					$data['EffectiveRate']= $cronsetting->EffectiveRate;	
			}else{
				$data['EffectiveRate']= 'now';
			}
						
            if(!empty($data['RateTableId'])){
                $data['ratetablename'] = DB::table('tblRateTable')->where(array('RateTableId'=>$data['RateTableId']))->pluck('RateTableName');
            }else{
                $data['ratetablename'] = '';
            }
            $data['CompanyID'] = $CompanyID;

            $JobID = Job::GenerateRateTable("GRT",$data);
            if ($JobID > 0) {
                $PHP_EXE_PATH = CompanyConfiguration::get($CompanyID,'PHP_EXE_PATH');
                $RMArtisanFileLocation = CompanyConfiguration::get($CompanyID,'RM_ARTISAN_FILE_LOCATION');
                if(getenv('APP_OS') == 'Linux') {
                    pclose(popen($PHP_EXE_PATH . " " . $RMArtisanFileLocation . " ratetablegenerator " . $CompanyID . " " . $JobID . " ".$CronJobID." &", "r"));
                }else {
                    pclose(popen("start /B " . $PHP_EXE_PATH . " " . $RMArtisanFileLocation . " ratetablegenerator " . $CompanyID . " " . $JobID . " ".$CronJobID, "r"));
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
