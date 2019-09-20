<?php namespace App\Console\Commands;

use App\Lib\Company;
use App\Lib\CompanyConfiguration;
use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Service;
use App\Lib\TempUsageDetail;
use App\Lib\TempUsageDownloadLog;
use App\PBX;
use Exception;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;

class ResellerPBXAccountUsage extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'resellerpbxaccountusage';

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
        $getmypid = getmypid(); // get proccess id
        $CronJobID = $arguments["CronJobID"];
        $CompanyID = $arguments["CompanyID"];
        $CronJob = CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);
        $dataactive['Active'] = 1;
        $dataactive['PID'] = $getmypid;
        $dataactive['LastRunTime'] = date('Y-m-d H:i:00');
        $CronJob->update($dataactive);

        $yesterday_date = date('Y-m-d 23:59:59', strtotime('-1 day'));
        $CompanyGatewayID = $cronsetting['CompanyGatewayID'];
        $companysetting = json_decode(CompanyGateway::getCompanyGatewayConfig($CompanyGatewayID));
        $temptableName = CompanyGateway::CreateIfNotExistCDRTempUsageDetailTable($CompanyID,$CompanyGatewayID,'reseller');
        Log::useFiles(storage_path() . '/logs/resellerpbxaccountusage-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');

        /* To avoid runing same day cron job twice */
        //if(true){//if($yesterday_date > $param['start_date_ymd']) {
        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';
        $processID = CompanyGateway::getProcessID();
        CompanyGateway::updateProcessID($CronJob,$processID);
        $accounts = array();
        try {
            CronJob::createLog($CronJobID);

            $RateFormat = Company::PREFIX;
            $RateCDR = 0;

            if(isset($companysetting->RateCDR) && $companysetting->RateCDR){
                $RateCDR = $companysetting->RateCDR;
            }
            if(isset($companysetting->RateFormat) && $companysetting->RateFormat){
                $RateFormat = $companysetting->RateFormat;
            }

            if(isset($cronsetting['StartDate']) && !empty($cronsetting['StartDate'])){
                $startdate = date("Y-m-d", strtotime($cronsetting['StartDate']));
                $enddate = date("Y-m-d", strtotime($cronsetting['EndDate']));
                $today=0;
            }else{
                $startdate = date("Y-m-d");
                $enddate = date("Y-m-d");
                $today=1;
            }

            //TempUsageDetail::applyDiscountPlan(); // when NextBillingDate comes , remove old discount entry and add fresh discout value with usedSeconds = 0

            $RerateAccounts = !empty($companysetting->Accounts) ? count($companysetting->Accounts) : 0;
            $today_current = date('Y-m-d H:i:s');


            $joblogdata['Message'] = "";
            $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;

            Log::error(' ========================== Temp table Data Insert and delete live cdr of reseller(today) start =============================');

            Log::info("CALL  prc_InsertTemptResellerCDR ('".$CompanyID."','".$CompanyGatewayID."' , '" . $processID . "', '" . $temptableName . "','".$startdate."','".$enddate."','".$today."' ) start");
            DB::connection('sqlsrvcdr')->statement("CALL  prc_InsertTemptResellerCDR ('".$CompanyID."','".$CompanyGatewayID."' , '" . $processID . "', '" . $temptableName . "','".$startdate."','".$enddate."','".$today."' )");
            Log::info("CALL  prc_InsertTemptResellerCDR ('".$CompanyID."','".$CompanyGatewayID."' , '" . $processID . "', '" . $temptableName . "','".$startdate."','".$enddate."','".$today."' ) end");

            Log::error(' ========================== Temp table Data Insert end =============================');

            /** delete duplicate id*/
            //ProcessCDR

            Log::info("ProcessCDR($CompanyID,$processID,$CompanyGatewayID,$RateCDR,$RateFormat)");

            $skiped_account_data = TempUsageDetail::ResellerProcessCDR($CompanyID,$processID,$CompanyGatewayID,$RateCDR,$RateFormat,$temptableName,'','CurrentRate',0,0,0,$RerateAccounts);
            if (count($skiped_account_data)) {
                $joblogdata['Message'] .= implode('<br>', $skiped_account_data);
            }

            DB::connection('sqlsrvcdr')->beginTransaction();
            DB::connection('sqlsrv2')->beginTransaction();

            Log::error('pbx prc_insertCDR start');
            DB::connection('sqlsrvcdr')->statement("CALL  prc_reseller_insertCDR ('" . $processID . "', '".$temptableName."' )");
            Log::error('pbx prc_insertCDR end');
            DB::connection('sqlsrvcdr')->commit();
            DB::connection('sqlsrv2')->commit();
            CronJobLog::insert($joblogdata);

            if(isset($cronsetting['StartDate']) && !empty($cronsetting['StartDate'])){
                $cronsetting['StartDate'] = $cronsetting['EndDate'] = '';
                $dataactive['Settings'] = json_encode($cronsetting);
            }
            //TempUsageDetail::GenerateLogAndSend($CompanyID,$CompanyGatewayID,$cronsetting,$skiped_account_data,$CronJob->JobTitle);

        } catch (\Exception $e) {
            try {
                DB::rollback();
                DB::connection('sqlsrv2')->rollback();
                DB::connection('sqlsrvcdr')->rollback();
            } catch (\Exception $err) {
                Log::error($err);
            }

            date_default_timezone_set(Config::get('app.timezone'));
            $this->info('Failed:' . $e->getMessage());
            $joblogdata['Message'] = 'Error:' . $e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            CronJobLog::insert($joblogdata);
            Log::error($e);
            if(!empty($cronsetting['ErrorEmail'])) {
                $result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
                Log::error("**Email Sent Status " . $result['status']);
                Log::error("**Email Sent message " . $result['message']);
            }
        }
        //}

        CronJob::deactivateCronJob($CronJob);

        if(!empty($cronsetting['SuccessEmail'])) {
            $result = CronJob::CronJobSuccessEmailSend($CronJobID);
            Log::error("**Email Sent Status ".$result['status']);
            Log::error("**Email Sent message ".$result['message']);
        }

        CronHelper::after_cronrun($this->name, $this);

    }

    public function getLastDate($startdate, $companyid, $CronJobID)
    {
        $Settings = CronJob::where(array('CompanyID' => $companyid, 'CronJobID' => $CronJobID))->pluck('Settings');
        $pbxusageinterval = CompanyConfiguration::get($companyid,'USAGE_PBX_INTERVAL');
        $cronsetting = json_decode($Settings);

        $seconds = strtotime(date('Y-m-d 00:00:00')) - strtotime($startdate);
        $hours = round($seconds / 60 / 60);

        if (isset($cronsetting->MaxInterval) && $hours > ($cronsetting->MaxInterval / 60)) {
            $endtimefinal = date('Y-m-d H:i:s', strtotime($startdate) + $cronsetting->MaxInterval * 60);
        } else {
            $endtimefinal = date('Y-m-d H:i:s', strtotime($startdate) + $pbxusageinterval * 60);
        }

        return $endtimefinal;
    }

    public static function getStartDate($companyid, $CompanyGatewayID, $CronJobID)
    {
        $endtime = TempUsageDownloadLog::where(array('CompanyID' => $companyid, 'CompanyGatewayID' => $CompanyGatewayID))->max('end_time');
        $pbxusageinterval = CompanyConfiguration::get($companyid,'USAGE_PBX_INTERVAL');
        $current = strtotime(date('Y-m-d H:i:s'));  // if no call then use current time and continew reading cdrs to go ahead
        $seconds = $current - strtotime($endtime);
        $minutes = round($seconds / 60);
        if ($minutes <= $pbxusageinterval) {
            $endtime = date('Y-m-d H:i:s', strtotime('-'.$pbxusageinterval.' minute'));  //date('Y-m-d H:i:s');
        }
        if (empty($endtime)) {
            $endtime = date('Y-m-01 00:00:00');
        }
        return $endtime;
    }
}
