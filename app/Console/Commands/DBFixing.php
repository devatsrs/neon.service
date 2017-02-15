<?php namespace App\Console\Commands;

use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\UsageDetail;
use App\Lib\UsageDetailFailedCall;
use App\Lib\UsageHeader;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use \Exception;
use Symfony\Component\Console\Input\InputArgument;
use App\Lib\Helper;
use App\Lib\Company;

//-- not in use
class DBFixing extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'dbfixing';

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
    public function handle()
    {

        CronHelper::before_cronrun($this->name, $this );


        $arguments = $this->argument();
        $getmypid = getmypid(); // get proccess id
        $CompanyID = $arguments["CompanyID"];
        $CronJobID = $arguments["CronJobID"];

        $CronJob =  CronJob::find($CronJobID);
        $dataactive['Active'] = 1;
        $dataactive['PID'] = $getmypid;
        $dataactive['LastRunTime'] = date('Y-m-d H:i:00');
        $CronJob->update($dataactive);
        $cronsetting = json_decode($CronJob->Settings,true);

        try {
            $joblogdata = array();
            $joblogdata['CronJobID'] = $CronJobID;
            $joblogdata['created_at'] = date('Y-m-d H:i:s');
            $joblogdata['created_by'] = 'RMScheduler';
            CronJob::createLog($CronJobID);
            Log::useFiles(storage_path() . '/logs/dbfixing-' . $CompanyID . '-' . date('Y-m-d') . '.log');
            Log::info('fixiing delete old cdr Starts.');
            $DeleteCDRDateTime = '-3 month';
            $DeleteCDRTime = getenv('DELETE_CDR_TIME');
            if(!empty($DeleteCDRTime)){
                $DeleteCDRDateTime = '- '.$DeleteCDRTime;
            }

            $deletedate = date('Y-m-d',strtotime($DeleteCDRDateTime));
            Log::info('fixiing delete old cdr Starts.deletedate '.$deletedate);
            $UsageHeader = UsageHeader::where(array('CompanyID'=>$CompanyID))->where('StartDate','<',$deletedate)->orderby('StartDate')->get();

            foreach($UsageHeader as $singleUsageHeader){
                Log::info('UsageDetail delete start UsageHeaderID '.$singleUsageHeader->UsageHeaderID.'=== start date '.$singleUsageHeader->StartDate);
                UsageDetail::where(array('UsageHeaderID'=>$singleUsageHeader->UsageHeaderID))->delete();
                UsageDetailFailedCall::where(array('UsageHeaderID'=>$singleUsageHeader->UsageHeaderID))->delete();
                Log::info('UsageDetail delete end UsageHeaderID '.$singleUsageHeader->UsageHeaderID.'=== start date '.$singleUsageHeader->StartDate);
                UsageHeader::where(array('UsageHeaderID'=>$singleUsageHeader->UsageHeaderID))->delete();
            }
            Log::info('fixiing delete old cdr  End.');
            $joblogdata['Message'] = 'Success';
            $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
            CronJobLog::insert($joblogdata);

        } catch (\Exception $e) {
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
        $dataactive['Active'] = 0;
        $dataactive['PID'] = '';
        $CronJob->update($dataactive);
        if(!empty($cronsetting['SuccessEmail'])) {
            $result = CronJob::CronJobSuccessEmailSend($CronJobID);
            Log::error("**Email Sent Status ".$result['status']);
            Log::error("**Email Sent message ".$result['message']);
        }
        Log::error(" CronJobId end" . $CronJobID);

        CronHelper::after_cronrun($this->name, $this);

    }

}
