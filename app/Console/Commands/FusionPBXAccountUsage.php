<?php namespace App\Console\Commands;

use App\FusionPBX;
use App\Lib\Company;
use App\Lib\CompanyConfiguration;
use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Service;
use App\Lib\TempUsageDetail;
use App\Lib\TempUsageDownloadLog;
use Exception;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;

class FusionPBXAccountUsage extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'fusionpbxaccountusage';

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
        ini_set('memory_limit', '-1');
        $start_time = date('Y-m-d H:i:s');
        $arguments = $this->argument();
        $CronJobID = $arguments["CronJobID"];
        $CompanyID = $arguments["CompanyID"];
        $CronJob = CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);
        CronJob::activateCronJob($CronJob);
        $CompanyGatewayID = $cronsetting['CompanyGatewayID'];
        $companysetting = json_decode(CompanyGateway::getCompanyGatewayConfig($CompanyGatewayID));
        $ServiceID = (int)Service::getGatewayServiceID($CompanyGatewayID);
        Log::useFiles(storage_path() . '/logs/fusionpbxaccountusage-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');
        $temptableName = CompanyGateway::CreateIfNotExistCDRTempUsageDetailTable($CompanyID,$CompanyGatewayID);

        $joblogdata['Message'] = '';
        $processID = CompanyGateway::getProcessID();

        try {
            Log::error(' ========================== Fusion PBX transaction start =============================');
            CronJob::createLog($CronJobID);
            $RateFormat = Company::PREFIX;
            $RateCDR = 0;

            if(isset($companysetting->RateCDR) && $companysetting->RateCDR){
                $RateCDR = $companysetting->RateCDR;
            }
            if(isset($companysetting->RateFormat) && $companysetting->RateFormat){
                $RateFormat = $companysetting->RateFormat;
            }
            $CLITranslationRule = $CLDTranslationRule = $PrefixTranslationRule = '';
            if(!empty($companysetting->CLITranslationRule)){
                $CLITranslationRule = $companysetting->CLITranslationRule;
            }
            if(!empty($companysetting->CLDTranslationRule)){
                $CLDTranslationRule = $companysetting->CLDTranslationRule;
            }
            if(!empty($companysetting->PrefixTranslationRule)){
                $PrefixTranslationRule = $companysetting->PrefixTranslationRule;
            }
            TempUsageDetail::applyDiscountPlan();
            $FusionPBX = new FusionPBX($CompanyGatewayID);


            $TimeZone = CompanyGateway::getGatewayTimeZone($CompanyGatewayID);
            if ($TimeZone != '') {
                date_default_timezone_set($TimeZone);
            } else {
                date_default_timezone_set('GMT'); // just to use e in date() function
            }
            $param['start_date_ymd'] = $this->getStartDate($CompanyID, $CompanyGatewayID, $CronJobID);
            $param['end_date_ymd'] = $this->getLastDate($param['start_date_ymd'], $CompanyID, $CronJobID);


            Log::error(print_r($param, true));



            $InserData = $InserVData = array();
            $data_count = $data_countv = 0;
            $insertLimit = 1000;

            $response = $FusionPBX->getAccountCDRs($param);
            $response = json_decode(json_encode($response), true);
            if (!isset($response['faultCode'])) {
                Log::error('call count ' . count($response));
                foreach ((array)$response as $row_account) {
                    $data = array();
                    $data['CompanyGatewayID'] = $CompanyGatewayID;
                    $data['CompanyID'] = $CompanyID;
                    if ($companysetting->NameFormat == 'NUB') {
                        $data['GatewayAccountID'] = $row_account['username'];
                    }
                    $data['AccountIP'] = '';
                    $data['AccountName'] = '';
                    $data['AccountNumber'] = $row_account['username'];
                    $data['AccountCLI'] = '';
                    $data['connect_time'] = $row_account['connect_time'];
                    $data['disconnect_time'] = $row_account['disconnect_time'];
                    $data['cost'] = (float)$row_account['cost'];
                    $data['cld'] = apply_translation_rule($CLDTranslationRule, $row_account['cld']);
                    $data['cli'] = apply_translation_rule($CLITranslationRule, $row_account['cli']);
                    $data['billed_duration'] = $row_account['billed_second'];
                    $data['billed_second'] = $row_account['billed_second'];
                    $data['duration'] = $row_account['duration'];
                    $data['trunk'] = 'Other';
                    $data['area_prefix'] = 'Other';
                    $data['userfield'] = $row_account['userfield'];
                    $data['is_inbound'] = $row_account['userfield'] == 'inbound'?1:0;
                    //$data['area_prefix'] = sippy_vos_areaprefix( apply_translation_rule($PrefixTranslationRule,$row_account['prefix']),$RateCDR);
                    $data['ProcessID'] = $processID;
                    $data['ServiceID'] = $ServiceID;
                    $data['disposition'] = $row_account['disposition'];
                    $data['ID'] = $row_account['id'];
                    $InserData[] = $data;
                    $data_count++;
                    if ($data_count > $insertLimit && !empty($InserData)) {
                        DB::connection('sqlsrvcdr')->table($temptableName)->insert($InserData);
                        $InserData = array();
                        $data_count = 0;
                    }
                }// loop
                if (!empty($InserData)) {
                    DB::connection('sqlsrvcdr')->table($temptableName)->insert($InserData);
                }

            }


            date_default_timezone_set(Config::get('app.timezone'));
            /** delete duplicate id*/
            Log::info("CALL  prc_DeleteDuplicateUniqueID ('".$CompanyID."','".$CompanyGatewayID."' , '" . $processID . "', '" . $temptableName . "' ) start");
            DB::connection('sqlsrvcdr')->statement("CALL  prc_DeleteDuplicateUniqueID ('".$CompanyID."','".$CompanyGatewayID."' , '" . $processID . "', '" . $temptableName . "' )");
            Log::info("CALL  prc_DeleteDuplicateUniqueID ('".$CompanyID."','".$CompanyGatewayID."' , '" . $processID . "', '" . $temptableName . "' ) end");

            Log::error("FusionPBX CDR StartTime " . $param['start_date_ymd'] . " - End Time " . $param['end_date_ymd']);
            Log::error(' ========================== FusionPBX transaction end =============================');
            //ProcessCDR

            Log::info("ProcessCDR($CompanyID,$processID,$CompanyGatewayID,$RateCDR,$RateFormat)");

            $skiped_account_data = TempUsageDetail::ProcessCDR($CompanyID,$processID,$CompanyGatewayID,$RateCDR,$RateFormat,$temptableName);
            if (count($skiped_account_data)) {
                $joblogdata['Message'] .= implode('<br>', $skiped_account_data) . '<br>';
            }
            $totaldata_count = DB::connection('sqlsrvcdr')->table($temptableName)->where('ProcessID',$processID)->count();
            DB::connection('sqlsrvcdr')->beginTransaction();
            DB::connection('sqlsrv2')->beginTransaction();

            Log::error("FusionPBX CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' ) start");
            DB::statement("CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' )");
            Log::error("FusionPBX CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' ) end");

            Log::error('FusionPBX prc_insertCDR start');
            DB::connection('sqlsrvcdr')->statement("CALL  prc_insertCDR ('" . $processID . "', '".$temptableName."' )");
            Log::error('FusionPBX prc_insertCDR end');
            $logdata['CompanyGatewayID'] = $CompanyGatewayID;
            $logdata['CompanyID'] = $CompanyID;
            $logdata['start_time'] = $param['start_date_ymd'];
            $logdata['end_time'] = $param['end_date_ymd'];
            $logdata['created_at'] = date('Y-m-d H:i:s');
            $logdata['ProcessID'] = $processID;
            TempUsageDownloadLog::insert($logdata);
			
            DB::connection('sqlsrvcdr')->commit();
            DB::connection('sqlsrv2')->commit();

            $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
            $joblogdata['Message'] .= "CDR StartTime " . $param['start_date_ymd'] . " - End Time " . $param['end_date_ymd'].' total data count '.$totaldata_count.' '.time_elapsed($start_time,date('Y-m-d H:i:s'));

            DB::connection('sqlsrvcdr')->table($temptableName)->where(["ProcessID" => $processID])->delete(); //TempUsageDetail::where(["processId" => $processID])->delete();

            TempUsageDetail::GenerateLogAndSend($CompanyID,$CompanyGatewayID,$cronsetting,$skiped_account_data,$CronJob->JobTitle);

        } catch (\Exception $e) {
            try {
                DB::rollback();
                DB::connection('sqlsrv2')->rollback();
                DB::connection('sqlsrvcdr')->rollback();
            } catch (Exception $err) {
                Log::error($err);

            }
            // delete temp table if process fail
            try {
                DB::connection('sqlsrvcdr')->table($temptableName)->where(["ProcessID" => $processID])->delete(); //TempUsageDetail::where(["processId" => $processID])->delete();

                //DB::connection('sqlsrvcdr')->statement("  DELETE FROM tblTempUsageDetail WHERE ProcessID = '".$processID."'");
            } catch (\Exception $err) {
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

    public function getLastDate($startdate, $companyid, $CronJobID)
    {
        $Settings = CronJob::where(array('CompanyID' => $companyid, 'CronJobID' => $CronJobID))->pluck('Settings');
        $usageinterval = CompanyConfiguration::get($companyid,'USAGE_INTERVAL');
        $cronsetting = json_decode($Settings);

        $seconds = strtotime(date('Y-m-d 00:00:00')) - strtotime($startdate);
        $hours = round($seconds / 60 / 60);

        if (isset($cronsetting->MaxInterval) && $hours > ($cronsetting->MaxInterval / 60)) {
            $endtimefinal = date('Y-m-d H:i:s', strtotime($startdate) + $cronsetting->MaxInterval * 60);
        } else {
            $endtimefinal = date('Y-m-d H:i:s', strtotime($startdate) + $usageinterval * 60);
        }

        return $endtimefinal;
    }

    public static function getStartDate($companyid, $CompanyGatewayID, $CronJobID)
    {
        $endtime = TempUsageDownloadLog::where(array('CompanyID' => $companyid, 'CompanyGatewayID' => $CompanyGatewayID))->max('end_time');
        $usageinterval = CompanyConfiguration::get($companyid,'USAGE_INTERVAL');
        $current = strtotime(date('Y-m-d H:i:s'));
        $seconds = $current - strtotime($endtime);
        $minutes = round($seconds / 60);
        if ($minutes <= $usageinterval) {
            $endtime = date('Y-m-d H:i:s', strtotime('-'.$usageinterval.' minute'));  //date('Y-m-d H:i:s');
        }
        if (empty($endtime)) {
            $endtime = date('Y-m-1 00:00:00');
        }
        return $endtime;
    }
}
