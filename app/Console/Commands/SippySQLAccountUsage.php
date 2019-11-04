<?php namespace App\Console\Commands;

use App\Lib\UsageDetail;
use App\SippySQL;
use App\Lib\Company;
use App\Lib\CompanyConfiguration;
use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Service;
use App\Lib\SippyImporter;
use App\Lib\TempVendorCDR;
use App\Lib\TempUsageDetail;
use App\Lib\TempUsageDownloadLog;
use Exception;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;

class SippySQLAccountUsage extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'sippysqlaccountusage';

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
        Log::useFiles(storage_path() . '/logs/SippySQLAccountUsage-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');
        $temptableName = CompanyGateway::CreateIfNotExistCDRTempUsageDetailTable($CompanyID,$CompanyGatewayID);
        $tempVendortable =  CompanyGateway::CreateVendorTempTable($CompanyID,$CompanyGatewayID);

        $joblogdata['Message'] = '';


        try {

            $processID = CompanyGateway::getProcessID();
            CompanyGateway::updateProcessID($CronJob,$processID);

            Log::error(' ========================== Sippy SQL transaction start =============================');
            CronJob::createLog($CronJobID);

            if(isset($cronsetting['CDRImportStartDate']) && !empty($cronsetting['CDRImportStartDate'])){

                $result = UsageDetail::reImportCDRByStartDate($cronsetting,$CronJobID,$processID);
                $joblogdata['CronJobStatus'] = $result['CronJobStatus'];
                $joblogdata['Message'] .= $result['Message'];
                goto end_of_cronjob;
                // break cron job after CDR Delete
            }

            $RateFormat = Company::PREFIX;
            $RateCDR = 0;

            if (isset($companysetting->RateCDR) && $companysetting->RateCDR) {
                $RateCDR = $companysetting->RateCDR;
            }
            if (isset($companysetting->RateFormat) && $companysetting->RateFormat) {
                $RateFormat = $companysetting->RateFormat;
            }
            $CLITranslationRule = $CLDTranslationRule = $PrefixTranslationRule = '';
            if (!empty($companysetting->CLITranslationRule)) {
                $CLITranslationRule = $companysetting->CLITranslationRule;
            }
            if (!empty($companysetting->CLDTranslationRule)) {
                $CLDTranslationRule = $companysetting->CLDTranslationRule;
            }
            if (!empty($companysetting->PrefixTranslationRule)) {
                $PrefixTranslationRule = $companysetting->PrefixTranslationRule;
            }
            $IpBased = ($companysetting->NameFormat == 'IP') ? 1 : 0;

            TempUsageDetail::applyDiscountPlan();
            $SippySQL = new SippySQL($CompanyGatewayID);

            $TimeZone = CompanyGateway::getGatewayTimeZone($CompanyGatewayID);
            if ($TimeZone != '') {
                date_default_timezone_set($TimeZone);
            } else {
                date_default_timezone_set('GMT'); // just to use e in date() function
            }

            try {
                $this->createAccountJobLog($CompanyID, $CompanyGatewayID);
            } catch (Exception $ex) {
                Log::error($ex);
            }

            $param['start_date_ymd'] = $this->getStartDate($CompanyID, $CompanyGatewayID, $CronJobID);
            $param['end_date_ymd'] = $this->getLastDate($param['start_date_ymd'], $CompanyID, $CronJobID);

            //	Debug only ...
            $endtime = TempUsageDownloadLog::where(array('CompanyID' => $CompanyID, 'CompanyGatewayID' => $CompanyGatewayID))->max('end_time');
            //start end time
            $filedetail = "<br>Gateway Current Time:  " . date('Y-m-d H:i:s');
            $filedetail .= "<br>Last End Time: " . $endtime;
            $filedetail .= "<br>New Start Time: " . date('Y-m-d H:i:s', strtotime('-10 minute', strtotime($endtime)));

//	Debug only ...

            Log::error(print_r($param, true));

            $RerateAccounts = !empty($companysetting->Accounts) ? count($companysetting->Accounts) : 0;

            $InserData = $InserVData = array();
            $data_count = $data_countv = 0;
            $insertLimit = 1000;

            $response = $SippySQL->getAccountCDRs($param);
            $response = json_decode(json_encode($response), true);
            if (!empty($response)) {
                if (!isset($response['faultCode'])) {
                    /**
                     * Insert Customer CDR to temp table
                     */
                    if (isset($response['cdrs_response'])) {
                        foreach ($response['cdrs_response'] as $cdr_rows) {
                            Log::error('call count customer ' . count($cdr_rows));
                            foreach ($cdr_rows as $cdr_row) {
                                if (($IpBased == 0 && !empty($cdr_row['i_account'])) || ($IpBased == 1 && !empty($cdr_row['remote_ip']))) {

                                    $uddata = array();
                                    $uddata['CompanyGatewayID'] = $CompanyGatewayID;
                                    $uddata['CompanyID'] = $CompanyID;
                                    if ($IpBased) {
                                        $uddata['GatewayAccountID'] = $cdr_row['remote_ip'];
                                    } else {
                                        $uddata['GatewayAccountID'] = $cdr_row['i_account'];
                                    }
                                    $uddata['AccountIP'] = $cdr_row['remote_ip'];
                                    $uddata['AccountName'] = '';
                                    $uddata['AccountNumber'] = $cdr_row['i_account'];
                                    $uddata['AccountCLI'] = '';
                                    $uddata['connect_time'] = gmdate('Y-m-d H:i:s', strtotime($cdr_row['setup_time']));
                                    $uddata['disconnect_time'] = gmdate('Y-m-d H:i:s', strtotime($cdr_row['disconnect_time']));
                                    $uddata['cost'] = (float)$cdr_row['cost'];
                                    $uddata['cld'] = apply_translation_rule($CLDTranslationRule, $cdr_row['cld_in']);
                                    $uddata['cli'] = apply_translation_rule($CLITranslationRule, $cdr_row['cli_in']);
                                    $uddata['billed_duration'] = $cdr_row['billed_duration'];
                                    $uddata['duration'] = $cdr_row['billed_duration'];
                                    $uddata['billed_second'] = $cdr_row['billed_duration'];
                                    $uddata['trunk'] = 'Other';
                                    $uddata['area_prefix'] = sippy_vos_areaprefix(apply_translation_rule($PrefixTranslationRule, $cdr_row['prefix']), $RateCDR, $RerateAccounts);
                                    $uddata['remote_ip'] = $cdr_row['remote_ip'];
                                    $uddata['ProcessID'] = $processID;
                                    $uddata['ServiceID'] = $ServiceID;
                                    $uddata['ID'] = $cdr_row['i_call'];

                                    $InserData[] = $uddata;

                                    if ($data_count > $insertLimit && !empty($InserData)) {
                                        DB::connection('sqlsrvcdr')->table($temptableName)->insert($InserData);
                                        $InserData = array();
                                        $data_count = 0;
                                    }
                                    $data_count++;
                                }
                            }// loop
                        }
                    }
                    if (!empty($InserData)) {
                        DB::connection('sqlsrvcdr')->table($temptableName)->insert($InserData);
                    }
                    Log::info("CDR Insert END");

                    /**
                     * Insert Vendor CDRs to Temp table
                     *
                     */
                    if (isset($response['cdrs_response_connection'])) {
                        $IpBased = 0;
                        foreach ($response['cdrs_response_connection'] as $cdr_rows) {
                            Log::error('call count vendor ' . count($cdr_rows));
                            foreach ($cdr_rows as $cdr_row) {
                                if (($IpBased == 0 && !empty($cdr_row['i_account_debug'])) || ($IpBased == 1 && !empty($cdr_row['remote_ip']))) {
                                    $uddata = array();
                                    $uddata['CompanyGatewayID'] = $CompanyGatewayID;
                                    $uddata['CompanyID'] = $CompanyID;
                                    if ($IpBased) {
                                        $uddata['GatewayAccountID'] = $cdr_row['remote_ip'];
                                    } else {
                                        $uddata['GatewayAccountID'] = $cdr_row['i_account_debug'];
                                    }
                                    $uddata['AccountIP'] = $cdr_row['remote_ip'];
                                    $uddata['AccountName'] = '';
                                    $uddata['AccountNumber'] = $cdr_row['i_account_debug'];
                                    $uddata['AccountCLI'] = '';
                                    $uddata['connect_time'] = gmdate('Y-m-d H:i:s', strtotime($cdr_row['setup_time']));
                                    $uddata['disconnect_time'] = gmdate('Y-m-d H:i:s', strtotime($cdr_row['disconnect_time']));
                                    $uddata['selling_cost'] = 0; // # is provided only in the cdrs table
                                    $uddata['buying_cost'] = (float)$cdr_row['cost'];
                                    $uddata['cld'] = apply_translation_rule($CLDTranslationRule, $cdr_row['cld_out']);
                                    $uddata['cli'] = apply_translation_rule($CLITranslationRule, $cdr_row['cli_out']);
                                    $uddata['billed_duration'] = $cdr_row['billed_duration'];
                                    $uddata['duration'] = $cdr_row['billed_duration'];
                                    $uddata['billed_second'] = $cdr_row['billed_duration'];
                                    $uddata['trunk'] = 'Other';
                                    $uddata['area_prefix'] = sippy_vos_areaprefix(apply_translation_rule($PrefixTranslationRule, $cdr_row['prefix']), $RateCDR, $RerateAccounts);
                                    $uddata['remote_ip'] = $cdr_row['remote_ip'];
                                    $uddata['ProcessID'] = $processID;
                                    $uddata['ServiceID'] = $ServiceID;
                                    $uddata['ID'] = $cdr_row['i_call'];

                                    $InserVData[] = $uddata;

                                    if ($data_countv > $insertLimit && !empty($InserVData)) {
                                        DB::connection('sqlsrvcdr')->table($tempVendortable)->insert($InserVData);
                                        $InserVData = array();
                                        $data_countv = 0;
                                    }
                                    $data_countv++;
                                }
                            }
                        }// loop
                    }
                    if (!empty($InserVData)) {
                        DB::connection('sqlsrvcdr')->table($tempVendortable)->insert($InserVData);
                    }
                    Log::info("vendor CDR Insert END");
                }

                date_default_timezone_set(Config::get('app.timezone'));
                /*
                Log::info("sippy CALL  prc_updateSippyCustomerSetupTime ('" . $processID . "', '".$temptableName."','".$tempVendortable."' ) start");
                $rows_updated = DB::connection('sqlsrvcdr')->select("CALL  prc_updateSippyCustomerSetupTime ('" . $processID . "', '".$temptableName."','".$tempVendortable."' )");
                Log::info("sippy CALL  prc_updateSippyCustomerSetupTime ('" . $processID . "', '".$temptableName."','".$tempVendortable."' ) end");
                */
                /** delete duplicate id from customer*/
                Log::info("CALL  prc_DeleteDuplicateUniqueID ('" . $CompanyID . "','" . $CompanyGatewayID . "' , '" . $processID . "', '" . $temptableName . "' ) start");
                DB::connection('sqlsrvcdr')->statement("CALL  prc_DeleteDuplicateUniqueID ('" . $CompanyID . "','" . $CompanyGatewayID . "' , '" . $processID . "', '" . $temptableName . "' )");
                Log::info("CALL  prc_DeleteDuplicateUniqueID ('" . $CompanyID . "','" . $CompanyGatewayID . "' , '" . $processID . "', '" . $temptableName . "' ) end");

                /** delete duplicate id from vendor*/
                Log::info("CALL  prc_DeleteDuplicateUniqueID2 ('" . $CompanyID . "','" . $CompanyGatewayID . "' , '" . $processID . "', '" . $tempVendortable . "' ) start");
                DB::connection('sqlsrvcdr')->statement("CALL  prc_DeleteDuplicateUniqueID2 ('" . $CompanyID . "','" . $CompanyGatewayID . "' , '" . $processID . "', '" . $tempVendortable . "' )");
                Log::info("CALL  prc_DeleteDuplicateUniqueID2 ('" . $CompanyID . "','" . $CompanyGatewayID . "' , '" . $processID . "', '" . $tempVendortable . "' ) end");

                Log::info("SippySQL CALL  prc_updatVendorSellingCost ('" . $processID . "', '" . $temptableName . "','" . $tempVendortable . "' ) start");
                DB::connection('sqlsrvcdr')->statement("CALL  prc_updatVendorSellingCost ('" . $processID . "', '" . $temptableName . "','" . $tempVendortable . "' )");
                Log::info("SippySQL CALL  prc_updatVendorSellingCost ('" . $processID . "', '" . $temptableName . "','" . $tempVendortable . "' ) end");

                Log::error("SippySQL CDR StartTime " . $param['start_date_ymd'] . " - End Time " . $param['end_date_ymd']);
                Log::error(' ========================== sippy transaction end =============================');
                //ProcessCDR

                Log::info("ProcessCDR($CompanyID,$processID,$CompanyGatewayID,$RateCDR,$RateFormat)");

                $skiped_vaccount_data = TempVendorCDR::ProcessCDR($CompanyID, $processID, $CompanyGatewayID, $RateCDR, $RateFormat, $tempVendortable, '', 'CurrentRate', 0, $RerateAccounts);
                $skiped_account_data = TempUsageDetail::ProcessCDR($CompanyID, $processID, $CompanyGatewayID, $RateCDR, $RateFormat, $temptableName, '', 'CurrentRate', 0, 0, 0, $RerateAccounts);

                $totaldata_count = DB::connection('sqlsrvcdr')->table($temptableName)->where('ProcessID', $processID)->count();
                $vtotaldata_count = DB::connection('sqlsrvcdr')->table($tempVendortable)->where('ProcessID', $processID)->count();

                DB::connection('sqlsrv2')->beginTransaction();
                DB::connection('sqlsrvcdr')->beginTransaction();

                if (count($skiped_account_data)) {
                    $filedetail .= "<br>----------------------------------------";
                    $filedetail .= implode('<br>', $skiped_account_data);
                }
                if (count($skiped_vaccount_data)) {
                    $filedetail .= "<br>----------------------------------------";
                    $filedetail .= implode('<br>', $skiped_vaccount_data);
                }
                $filedetail .= "<br>----------------------------------------";
                $filedetail .= "";
                $filedetail .= '<br>Vendor From ' . date('Y-m-d H:i:s', strtotime($param['start_date_ymd'])) . ' To ' . date('Y-m-d H:i:s', strtotime($param['end_date_ymd'])) . ' count ' . $vtotaldata_count;
                $filedetail .= '<br>Customer From ' . date('Y-m-d H:i:s', strtotime($param['start_date_ymd'])) . ' To ' . date('Y-m-d H:i:s', strtotime($param['end_date_ymd'])) . ' count ' . $totaldata_count;


                Log::error("SippySQL CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' ) start");
                DB::statement("CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' )");
                Log::error("SippySQL CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' ) end");

                Log::error('SippySQL prc_insertCDR start' . $processID);
                DB::connection('sqlsrvcdr')->statement("CALL  prc_insertCDR ('" . $processID . "', '" . $temptableName . "' )");
                DB::connection('sqlsrvcdr')->statement("CALL  prc_insertVendorCDR ('" . $processID . "', '" . $tempVendortable . "')");
                Log::error('SippySQL prc_insertCDR end');

                date_default_timezone_set(Config::get('app.timezone'));
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
                $joblogdata['Message'] .= $filedetail . ' <br/>';

                DB::connection('sqlsrvcdr')->table($temptableName)->where(["processId" => $processID])->delete(); //TempUsageDetail::where(["processId" => $processID])->delete();
                DB::connection('sqlsrvcdr')->table($tempVendortable)->where(["processId" => $processID])->delete(); //TempUsageDetail::where(["processId" => $processID])->delete();

                TempUsageDetail::GenerateLogAndSend($CompanyID, $CompanyGatewayID, $cronsetting, $skiped_account_data, $CronJob->JobTitle);
            } else {
                //start end time
                date_default_timezone_set(Config::get('app.timezone'));
                $logdata['CompanyGatewayID'] = $CompanyGatewayID;
                $logdata['CompanyID'] = $CompanyID;
                $logdata['start_time'] = $param['start_date_ymd'];
                $logdata['end_time'] = $param['end_date_ymd'];
                $logdata['created_at'] = date('Y-m-d H:i:s');
                $logdata['ProcessID'] = $processID;
                TempUsageDownloadLog::insert($logdata);

                $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
                $joblogdata['Message'] .= 'No CDR Records Found From ' . $param['start_date_ymd'] . ' To ' . $param['end_date_ymd'];
                Log::error('No CDR Records Found From ' . $param['start_date_ymd'] . ' To ' . $param['end_date_ymd']);
            }

        } catch (Exception $e) {
            try {
                DB::rollback();
                DB::connection('sqlsrv2')->rollback();
                DB::connection('sqlsrvcdr')->rollback();
            } catch (Exception $err) {
                Log::error($err);

            }
            // delete temp table if process fail
            try {
                DB::connection('sqlsrvcdr')->table($temptableName)->where(["processId" => $processID])->delete();
                DB::connection('sqlsrvcdr')->table($tempVendortable)->where(["processId" => $processID])->delete();

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

        end_of_cronjob:

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
        $endtimefinal = date('Y-m-d H:i:s', strtotime($startdate) + $cronsetting->MaxInterval * 60);
        if($endtimefinal > date('Y-m-d H:i:s')){
            return date('Y-m-d H:i:s');
        }
        return $endtimefinal;

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
        $endtime = date('Y-m-d H:i:s', strtotime('-'.$usageinterval.' minute',strtotime($endtime)));  //date('Y-m-d H:i:s');
        if($endtime > date('Y-m-d H:i:s')){
            return date('Y-m-d H:i:s');
        }

        //$endtime = TempUsageDownloadLog::where(array('CompanyID' => $companyid, 'CompanyGatewayID' => $CompanyGatewayID))->max('end_time');
        /*$endtime = TempUsageDownloadLog::where(array('CompanyID' => $companyid, 'CompanyGatewayID' => $CompanyGatewayID))->orderby('TempUsageDownloadLogID', 'desc')->limit(1)->pluck("end_time");
        return $endtime; */

        $usageinterval = CompanyConfiguration::get($companyid,'USAGE_INTERVAL');
        $current = strtotime(date('Y-m-d H:i:s'));
        $seconds = $current - strtotime($endtime);
        $minutes = round($seconds / 60);
        if ($minutes <= $usageinterval) {
            $endtime = date('Y-m-d H:i:s', strtotime('-'.$usageinterval.' minute'));  //date('Y-m-d H:i:s');
            Log::info("here - "  . $endtime);
        }
        if (empty($endtime)) {
            $endtime = date('Y-m-01 00:00:00');
        }
        return $endtime;
    }

    public function createAccountJobLog($CompanyID,$CompanyGatewayID){
        $Interval = CompanyConfiguration::getValueConfigurationByKey($CompanyID,"AUTO_SIPPY_ACCOUNT_IMPORT_INTERVAL");
        if($Interval > 0){
            $CurrentTime = date("Y-m-d H:i:s");
            Log::info("sippy CALL  prc_checkSippyAutoAccountImportJobInterval ('" . $CompanyID . "', '".$CurrentTime."') start");
            $result = DB::select("CALL  prc_checkSippyAutoAccountImportJobInterval ('" . $CompanyID . "', '".$CurrentTime."')");

            if(isset($result[0]->result)  && $result[0]->result == 1) {
                SippyImporter::add_missing_gatewayaccounts($CompanyID, $CompanyGatewayID);
                Log::info("add_missing_gatewayaccounts run");
            } else if(isset($result[0]->message)) {
                //Log::info("prc_checkSippyAutoAccountImportJobInterval result message");
                //Log::info($result[0]->message);
            }
        }
    }
}
