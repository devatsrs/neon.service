<?php namespace App\Console\Commands;


use App\Lib\Account;
use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\UsageDetail;
use App\Streamco;
use Exception;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;

class StreamcoAccountImport extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'streamcoaccountimport';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Command import.';

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
        ini_set('memory_limit', '-1');
        $arguments = $this->argument();
        $CronJobID = $arguments["CronJobID"];
        $CompanyID = $arguments["CompanyID"];
        $CronJob = CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);
        CronJob::activateCronJob($CronJob);
        $CompanyGatewayID = $cronsetting['CompanyGatewayID'];
        Log::useFiles(storage_path() . '/logs/streamcoaccountimport-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');
        $joblogdata['Message'] = '';


        try {
            $processID = CompanyGateway::getProcessID();
            Log::error(' ========================== streamco transaction start =============================');
            CronJob::createLog($CronJobID);

            $streamco = new Streamco($CompanyGatewayID);

            // starts import accounts
            $addparams['CompanyGatewayID'] = $CompanyGatewayID;
            $addparams['CompanyID'] = $CompanyID;
            $addparams['ProcessID'] = $processID;
            $addparams['ImportDate'] = date('Y-m-d H:i:s.000');
            Account::importStreamcoAccounts($streamco, $addparams);
//            Account::importStreamcoTrunks($streamco,$addparams);
            // ends import accounts

        } catch (\Exception $e) {
            try {
                DB::rollback();
            } catch (Exception $err) {
                Log::error($err);
            }
            date_default_timezone_set(Config::get('app.timezone'));
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
        CronJobLog::createLog($CronJobID,$joblogdata);
        CronJob::deactivateCronJob($CronJob);
        if(!empty($cronsetting['SuccessEmail'])) {
            $result = CronJob::CronJobSuccessEmailSend($CronJobID);
            Log::error("**Email Sent Status ".$result['status']);
            Log::error("**Email Sent message ".$result['message']);
        }

        CronHelper::after_cronrun($this->name, $this);

    }

}
