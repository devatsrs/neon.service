<?php namespace App\Console\Commands;

use App\Lib\Company;
use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\NeonAlert;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;

class NeonAlerts extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'neonalerts';

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
    public function fire()
    {
        CronHelper::before_cronrun($this->name, $this );

        $arguments = $this->argument();
        $CronJobID = $arguments["CronJobID"];
        $CompanyID = $arguments["CompanyID"];
        $CronJob = CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);
        CronJob::activateCronJob($CronJob);
        CronJob::createLog($CronJobID);
        Log::useFiles(storage_path() . '/logs/neonalerts-' . $CronJobID . '-' . date('Y-m-d') . '.log');
        $ProcessID = CompanyGateway::getProcessID();
        try {


            $Companies = Company::where('Status',1)->get();
            $cronjobdata = [];
            foreach($Companies as $company) {
                $CompanyID = $company->CompanyID;
                $cronjobdata = NeonAlert::neon_alerts($CompanyID, $ProcessID);
            }
            if (count($cronjobdata)) {
                $joblogdata['Message'] = 'Message : ' . implode(',<br>', $cronjobdata);
                $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
                if (!empty($cronsetting['ErrorEmail'])) {
                    $result = CronJob::CronJobErrorEmailSend($CronJobID, implode(',\n\r', $cronjobdata));
                    Log::error("**Email Sent Status " . $result['status']);
                    Log::error("**Email Sent message " . $result['message']);
                }
            } else {
                $joblogdata['Message'] = 'Success';
                $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
            }

        } catch (\Exception $e) {

            $this->info('Failed:' . $e->getMessage());
            $joblogdata['Message'] = 'Error:' . $e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            Log::error($e);
            if(!empty($cronsetting['ErrorEmail'])) {
                $result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
                Log::error("**Email Sent Status " . $result['status']);
                Log::error("**Email Sent message " . $result['message']);
            }
        }

        CronJob::deactivateCronJob($CronJob);
        CronJobLog::createLog($CronJobID,$joblogdata);
        if(!empty($cronsetting['SuccessEmail'])) {
            $result = CronJob::CronJobSuccessEmailSend($CronJobID);
            Log::error("**Email Sent Status ".$result['status']);
            Log::error("**Email Sent message ".$result['message']);
        }

        CronHelper::after_cronrun($this->name, $this);
    }
}
