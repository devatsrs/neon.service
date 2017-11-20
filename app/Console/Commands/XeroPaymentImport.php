<?php namespace App\Console\Commands;

use App\Lib\Xero;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;
use App\Lib\Company;
use \Exception;

class XeroPaymentImport extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'xeropaymentimport';

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

    /**
     * Get the console command arguments.
     *
     * @return array
     */
    protected function getArguments()
    {
        return [
            ['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID'],
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
        $getmypid = getmypid(); // get proccess id
        $CompanyID = $arguments["CompanyID"];
        $CronJobID = $arguments["CronJobID"];

        $CronJob =  CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);

        $dataactive['Active'] = 1;
        $dataactive['PID'] = $getmypid;
        $dataactive['LastRunTime'] = date('Y-m-d H:i:00');
        $CronJob->update($dataactive);
        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';

        /**
         * If days is 7 then it will get payment of last 7 days
         * Default is 7 days
        */
        $days = 7;
        if(!empty($cronsetting['ImportDays'])){
            $days = $cronsetting['ImportDays'];
        }

        $errors = array();
        Log::useFiles(storage_path() . '/logs/xeropaymentimport-' . date('Y-m-d') . '.log');
        /**  Loop through account Outstanding.*/

        $Company=Company::find($CompanyID);
        /** ************************************************************/
        try {
            CronJob::createLog($CronJobID);
            $XeroConnection = new Xero($CompanyID);
            $connect = $XeroConnection->test_connection($CompanyID);

            if(!empty($connect)){
                $date = date("Y-m-d 00:00:00", strtotime("-".$days." days"));
                Log::error(" Invoice Payment Date ".$date);
                $PaymentResult = $XeroConnection->GetAndInsertPayment($date);
                if(!empty($PaymentResult) && $PaymentResult['Status']=='success'){
                    //$joblogdata['Message'] = 'Success';
                    $joblogdata['Message'] = $PaymentResult['Message'];
                    $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
                    CronJobLog::insert($joblogdata);
                }elseif(!empty($PaymentResult) && $PaymentResult['Status']=='failed'){
                    $joblogdata['Message'] = $PaymentResult['Message'];
                    $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
                    CronJobLog::insert($joblogdata);
                    if(!empty($cronsetting['ErrorEmail'])) {
                        $result = CronJob::CronJobErrorEmailSend($CronJobID,$PaymentResult['Message']);
                        Log::error("**Email Sent Status " . $result['status']);
                        Log::error("**Email Sent message " . $result['message']);
                    }
                }else{
                    $joblogdata['Message'] = 'Success';
                    $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
                    CronJobLog::insert($joblogdata);
                }
            }else{
                $ErrorMessage = 'Xero API Not Setup Correctly';
                $joblogdata['Message'] ='Error : '.$ErrorMessage;
                $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
                CronJobLog::insert($joblogdata);
                if(!empty($cronsetting['ErrorEmail'])) {
                    $result = CronJob::CronJobErrorEmailSend($CronJobID,$ErrorMessage);
                    Log::error("**Email Sent Status " . $result['status']);
                    Log::error("**Email Sent message " . $result['message']);
                }
            }
        }catch (\Exception $e) {
            $errors[] = $e->getMessage();
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
        if(!empty($cronsetting['SuccessEmail'])){
            $result = CronJob::CronJobSuccessEmailSend($CronJobID);
            Log::error("**Email Sent Status ".$result['status']);
            Log::error("**Email Sent message ".$result['message']);
        }
        Log::error(" CronJobId end" . $CronJobID);

        CronHelper::after_cronrun($this->name, $this);

    }




}
