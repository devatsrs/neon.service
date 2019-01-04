<?php namespace App\Console\Commands;

use App\Lib\AccountBalance;
use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Gateway;
use App\Lib\Reseller;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;

class PBXAccountBlock extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'pbxaccountblock';

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
        Log::useFiles(storage_path() . '/logs/pbxaccountblock-' . $CronJobID . '-' . date('Y-m-d') . '.log');
        $ProcessID = CompanyGateway::getProcessID();
        try {
            $Result = Reseller::isResellerAndAccountBlock($CompanyID);
            if($Result==0) {
                $GatewayID = Gateway::getGatewayID('PBX');
                $error_message = AccountBalance::PBXBlockUnBlockAccount($CompanyID, $GatewayID, $ProcessID);
                if (isset($error_message['faultString'])) {
                    $joblogdata['Message'] = $error_message['faultString'];
                    $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
                } else {
                    $joblogdata['Message'] = 'Success';
                    $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
                }
            }else{
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
