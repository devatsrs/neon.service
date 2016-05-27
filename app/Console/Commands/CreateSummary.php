<?php
namespace App\Console\Commands;


use App\Lib\CompanyGateway;
use App\Lib\CompanySetting;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Summary;
use App\Lib\TempUsageDetail;
use App\Lib\TempUsageDownloadLog;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;

class CreateSummary extends Command{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'createsummary';

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
        $CronJob =  CronJob::find($CronJobID);
        CronJob::activateCronJob($CronJob);
        CronJob::createLog($CronJobID);
        Log::useFiles(storage_path() . '/logs/createsummary-' . $CompanyID . '-' . date('Y-m-d') . '.log');
        try {

            //DB::connection('neon_report')->beginTransaction();
            $Date = CompanySetting::getKeyVal($CompanyID,'LastCustomerSummaryDate');

            if($Date == date("Y-m-d")) {
                Summary::generateSummary($CompanyID, 1);
            }else{
                Summary::generateSummary($CompanyID, 0);
                CompanySetting::setKeyVal($CompanyID,'LastCustomerSummaryDate',date("Y-m-d"));
            }
            //DB::connection('neon_report')->commit();
            $joblogdata['Message'] = 'Success';
            $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;

        } catch (\Exception $e) {
            try {
                //DB::connection('neon_report')->rollback();
            } catch (\Exception $err) {
                Log::error($err);
            }
            Log::error($e);
            $joblogdata['Message'] ='Error:'.$e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            if(!empty($cronsetting['ErrorEmail'])) {

                $result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
                Log::error("**Email Sent Status " . $result['status']);
                Log::error("**Email Sent message " . $result['message']);
            }
        }
        CronJobLog::createLog($CronJobID,$joblogdata);
        CronJob::deactivateCronJob($CronJob);
        Log::error(" CronJobId end" . $CronJobID);
        if(!empty($cronsetting['SuccessEmail'])) {
            $result = CronJob::CronJobSuccessEmailSend($CronJobID);
            Log::error("**Email Sent Status ".$result['status']);
            Log::error("**Email Sent message ".$result['message']);
        }

    }

}
