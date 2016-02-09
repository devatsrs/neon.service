<?php
namespace App\Console\Commands;


use App\Lib\CompanyGateway;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\TempUsageDetail;
use App\Lib\TempUsageDownloadLog;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;

class CreateDailySummary extends Command{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'createdailysummary';

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
        $arguments = $this->argument();
        $CompanyID = $arguments["CompanyID"];
        $CronJobID = $arguments["CronJobID"];
        $getmypid = getmypid(); // get proccess id

        $CronJob =  CronJob::find($CronJobID);
        $dataactive['Active'] = 1;
        $dataactive['PID'] = $getmypid;
        $CronJob->update($dataactive);

        try {

            $joblogdata = $errors = array();
            $joblogdata['CronJobID'] = $CronJobID;
            $joblogdata['created_at'] = date('Y-m-d H:i:s');
            $joblogdata['created_by'] = 'RMScheduler';
            CronJob::createLog($CronJobID);
            Log::useFiles(storage_path() . '/logs/createdailysummary-' . $CompanyID . '-' . date('Y-m-d') . '.log');

            DB::connection('sqlsrv2')->statement('CALL  prc_setAccountID(' . $CompanyID . ")");

            $UsageHeaders = TempUsageDownloadLog::where(array('DailySummaryStatus'=>0,'CompanyID'=>$CompanyID))->select(["TempUsageDownloadLogID","CompanyID","CompanyGatewayID","ProcessID"])->take(5)->get();
            //$UsageHeaders = UsageHeader::where(array('DailySummaryStatus'=>1,'CompanyID'=>$CompanyID))->select(["CompanyID","CompanyGatewayID","UsageHeaderID"])->get();
            foreach ($UsageHeaders as $UsageHeader) {
                try {
                    Log::info('========Transaction start========.ProcessID =='.$UsageHeader->ProcessID);
                    DB::connection('sqlsrv2')->beginTransaction();
                    $CompanyGatewayID = $UsageHeader->CompanyGatewayID;
                    $TimeZone = CompanyGateway::getGatewayTimeZone($CompanyGatewayID);
                    if (empty($TimeZone)) {
                        $TimeZone = 'GMT';
                    }
                    TempUsageDetail::GenerateDailySummary($CompanyID,$UsageHeader->ProcessID,$TimeZone );
                    TempUsageDownloadLog::where(array('TempUsageDownloadLogID'=>$UsageHeader->TempUsageDownloadLogID))->update(array('DailySummaryStatus'=>'1'));
                    DB::connection('sqlsrv2')->commit();
                    Log::info('========Transaction end========.');
                }catch (\Exception $e){
                    try {
                        DB::rollback();
                        DB::connection('sqlsrv2')->rollback();
                        DB::connection('sqlsrvcdrazure')->rollback();
                    } catch (\Exception $err) {
                        Log::error($err);
                    }
                    $errors[] = 'error with transaction '.$UsageHeader->ProcessID;
                    Log::error($e);

                }
            }
            if(!empty($errors)){
                $joblogdata['Message'] = implode(',\n\r',$errors);
                $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            }else{
                $joblogdata['Message'] = 'Success';
                $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
            }

            CronJobLog::insert($joblogdata);
        } catch (\Exception $e) {
            try {
                DB::rollback();
                DB::connection('sqlsrv2')->rollback();
                DB::connection('sqlsrvcdrazure')->rollback();
            } catch (\Exception $err) {
                Log::error($err);
            }
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
        $dataactive['PID'] = '';
        $dataactive['Active'] = 0;
        $CronJob->update($dataactive);
        Log::error(" CronJobId end" . $CronJobID);
        if(!empty($cronsetting['SuccessEmail'])) {
            $result = CronJob::CronJobSuccessEmailSend($CronJobID);
            Log::error("**Email Sent Status ".$result['status']);
            Log::error("**Email Sent message ".$result['message']);
        }

    }

}
