<?php
/**
 * Created by PhpStorm.
 * User: srs2
 * Date: 25/05/2015
 * Time: 06:58 
 */

namespace App\Console\Commands;

use App\Lib\CompanyGateway;
use App\Lib\Gateway;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Customer;
use Exception;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;

class VendorRateFileExport  extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'vendorratefileexport';

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
        $CompanyID = $arguments["CompanyID"];
        $CronJobID = $arguments["CronJobID"];
        $CronJob =  CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);
        CronJob::activateCronJob($CronJob);
        CronJob::createLog($CronJobID);
        $CompanyGatewayID = $cronsetting['CompanyGatewayID'];
        Log::useFiles(storage_path() . '/logs/vendorratefileexport-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');

        $GatewayID = CompanyGateway::find($CompanyGatewayID)->GatewayID;
        $Gateway = Gateway::getGatewayName($GatewayID);
        try {
            if($Gateway == 'SippySFTP' || $Gateway == 'SippySQL') { //sippy
                $response = Customer::generatePushVendorSippyRateFile($CompanyID, $cronsetting);
            } else {
                $response = Customer::generateVendorFile($CompanyID,$cronsetting);
            }

            $final_array = array_merge($response['error'],$response['message']);
            if(count($response['error'])){
                $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
                $joblogdata['Message'] = implode('<br>', fix_jobstatus_meassage($final_array));
            }else{
                $joblogdata['Message'] = !empty($final_array)?implode('<br>', fix_jobstatus_meassage($final_array)):'Success';
                $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
            }


        } catch (\Exception $e) {
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

        CronHelper::after_cronrun($this->name, $this);

    }
}