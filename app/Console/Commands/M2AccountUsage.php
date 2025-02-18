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
use App\Lib\TempVendorCDR;
use App\Lib\UsageDetail;
use App\M2;
use Exception;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;

class M2AccountUsage extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'm2accountusage';

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
        Log::useFiles(storage_path() . '/logs/m2accountusage-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');
        $temptableName = CompanyGateway::CreateIfNotExistCDRTempUsageDetailTable($CompanyID,$CompanyGatewayID);
        $tempVendortable =  CompanyGateway::CreateVendorTempTable($CompanyID,$CompanyGatewayID);
        //$tempLinkPrefix =  CompanyGateway::CreateTempLinkTable($CompanyID,$CompanyGatewayID);
        $joblogdata['Message'] = '';
        $processID = CompanyGateway::getProcessID();

        try {
            Log::error(' ========================== m2 transaction start =============================');
            CronJob::createLog($CronJobID);

            if(isset($cronsetting['CDRImportStartDate']) && !empty($cronsetting['CDRImportStartDate'])){

                $result = UsageDetail::reImportCDRByStartDate($cronsetting,$CronJobID,$processID);
                $joblogdata['CronJobStatus'] = $result['CronJobStatus'];
                $joblogdata['Message'] = $result['Message'];
                goto end_of_cronjob;
                // break cron job after CDR Delete
            }

            $RateFormat = Company::PREFIX;
            $RateCDR = $AutoAddIP = 0;

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
            if (isset($companysetting->AutoAddIP) && $companysetting->AutoAddIP) {
                $AutoAddIP = $companysetting->AutoAddIP;
            }
            TempUsageDetail::applyDiscountPlan();
            $m2 = new M2($CompanyGatewayID);

            $TimeZone = CompanyGateway::getGatewayTimeZone($CompanyGatewayID);
            if ($TimeZone != '') {
                date_default_timezone_set($TimeZone);
            } else {
                date_default_timezone_set('GMT'); // just to use e in date() function
            }
            $param['start_date_ymd'] = $this->getStartDate($CompanyID, $CompanyGatewayID, $CronJobID);
            $param['end_date_ymd'] = $this->getLastDate($param['start_date_ymd'], $CompanyID, $CronJobID);

            Log::error(print_r($param, true));

            $RerateAccounts = !empty($companysetting->Accounts) ? count($companysetting->Accounts) : 0;

            $InserData = $InserVData = array();
            $data_count = $data_countv = 0;
            $insertLimit = 1000;

            $response = $m2->getAccountCDRs($param);
            $response = json_decode(json_encode($response), true);
            if (!isset($response['faultCode'])) {
                Log::error('call count ' . count($response));
                foreach ((array)$response as $row_account) {
                    if (!empty($row_account['username']) || !empty($row_account['originator_ip'])) {
                        $data = array();
                        $data['CompanyGatewayID'] = $CompanyGatewayID;
                        $data['CompanyID'] = $CompanyID;
                        if ($companysetting->NameFormat == 'NAME') {
                            $data['GatewayAccountID'] = $row_account['username'];
                        } else if ($companysetting->NameFormat == 'IP') {
                            $data['GatewayAccountID'] = $row_account['originator_ip'];
                        }
                        $data['AccountIP'] = $row_account['originator_ip'];
                        $data['AccountName'] = $row_account['username'];
                        $data['AccountNumber'] = '';
                        $data['AccountCLI'] = '';
                        $data['connect_time'] = $row_account['connect_time'];
                        $data['disconnect_time'] = date('Y-m-d H:i:s', strtotime($row_account['connect_time']) + $row_account['billed_second']);
                        $data['cost'] = (float)$row_account['cost'];
                        $data['cld'] = apply_translation_rule($CLDTranslationRule, $row_account['cld']);
                        $data['cli'] = apply_translation_rule($CLITranslationRule, $row_account['cli']);
                        $data['billed_duration'] = $row_account['billed_second'];
                        $data['billed_second'] = $row_account['billed_second'];
                        $data['duration'] = $row_account['duration'];
                        $data['trunk'] = 'Other';
                        $data['area_prefix'] = sippy_vos_areaprefix(apply_translation_rule($PrefixTranslationRule, $row_account['prefix']), $RateCDR, $RerateAccounts);
                        $data['ProcessID'] = $processID;
                        $data['remote_ip'] = $row_account['originator_ip'];
                        $data['ServiceID'] = $ServiceID;
                        $data['disposition'] = $row_account['disposition'];
                        $data['ID'] = $row_account['ID'];
                        $InserData[] = $data;
                        $data_count++;
                        if ($data_count > $insertLimit && !empty($InserData)) {
                            DB::connection('sqlsrvcdr')->table($temptableName)->insert($InserData);
                            $InserData = array();
                            $data_count = 0;
                        }
                    }

                    if (!empty($row_account['terminator_ip']) || !empty($row_account['providername'])) {
                        $vendorcdrdata = array();
                        if ($companysetting->NameFormat == 'NAME') {
                            $vendorcdrdata['GatewayAccountID'] = !empty($row_account['providername']) ? $row_account['providername'] : '';
                        } else if ($companysetting->NameFormat == 'IP') {
                            $vendorcdrdata['GatewayAccountID'] = $row_account['terminator_ip'];
                        }
                        $vendorcdrdata['AccountIP'] = $row_account['terminator_ip'];
                        $vendorcdrdata['AccountName'] = !empty($row_account['providername']) ? $row_account['providername'] : '';
                        $vendorcdrdata['AccountNumber'] = '';
                        $vendorcdrdata['AccountCLI'] = '';
                        $vendorcdrdata['CompanyGatewayID'] = $CompanyGatewayID;
                        $vendorcdrdata['CompanyID'] = $CompanyID;
                        $vendorcdrdata['connect_time'] = $row_account['connect_time'];
                        $vendorcdrdata['disconnect_time'] = date('Y-m-d H:i:s', strtotime($row_account['connect_time']) + $row_account['billed_second']);
                        $vendorcdrdata['buying_cost'] = (float)$row_account['provider_price'];
                        $vendorcdrdata['selling_cost'] = (float)$row_account['cost'];
                        $vendorcdrdata['cld'] = apply_translation_rule($CLDTranslationRule, $row_account['cld']);
                        $vendorcdrdata['cli'] = apply_translation_rule($CLITranslationRule, $row_account['cli']);
                        $vendorcdrdata['billed_duration'] = $row_account['provider_billed_second'];
                        $vendorcdrdata['billed_second'] = $row_account['provider_billed_second'];
                        $vendorcdrdata['duration'] = $row_account['duration'];
                        $vendorcdrdata['trunk'] = 'Other';
                        $vendorcdrdata['area_prefix'] = sippy_vos_areaprefix(apply_translation_rule($PrefixTranslationRule, $row_account['prefix']), $RateCDR, $RerateAccounts);
                        $vendorcdrdata['ProcessID'] = $processID;
                        $vendorcdrdata['ServiceID'] = $ServiceID;
                        $vendorcdrdata['remote_ip'] = $row_account['terminator_ip'];
                        $vendorcdrdata['ID'] = $row_account['ID'];
                        $InserVData[] = $vendorcdrdata;
                        $data_countv++;
                        if ($data_countv > $insertLimit && !empty($InserVData)) {
                            DB::connection('sqlsrvcdr')->table($tempVendortable)->insert($InserVData);
                            $InserVData = array();
                            $data_countv = 0;
                        }
                    }
                }// loop
                if (!empty($InserData)) {
                    DB::connection('sqlsrvcdr')->table($temptableName)->insert($InserData);
                }
                if (!empty($InserVData)) {
                    DB::connection('sqlsrvcdr')->table($tempVendortable)->insert($InserVData);
                }
            }

//exit;
            date_default_timezone_set(Config::get('app.timezone'));
            /** delete duplicate id*/
            Log::info("CALL  prc_DeleteDuplicateUniqueID ('" . $CompanyID . "','" . $CompanyGatewayID . "' , '" . $processID . "', '" . $temptableName . "' ) start");
            DB::connection('sqlsrvcdr')->statement("CALL  prc_DeleteDuplicateUniqueID ('" . $CompanyID . "','" . $CompanyGatewayID . "' , '" . $processID . "', '" . $temptableName . "' )");
            Log::info("CALL  prc_DeleteDuplicateUniqueID ('" . $CompanyID . "','" . $CompanyGatewayID . "' , '" . $processID . "', '" . $temptableName . "' ) end");

            /** delete duplicate id*/
            Log::info("CALL  prc_DeleteDuplicateUniqueID2 ('" . $CompanyID . "','" . $CompanyGatewayID . "' , '" . $processID . "', '" . $tempVendortable . "' ) start");
            DB::connection('sqlsrvcdr')->statement("CALL  prc_DeleteDuplicateUniqueID2 ('" . $CompanyID . "','" . $CompanyGatewayID . "' , '" . $processID . "', '" . $tempVendortable . "' )");
            Log::info("CALL  prc_DeleteDuplicateUniqueID2 ('" . $CompanyID . "','" . $CompanyGatewayID . "' , '" . $processID . "', '" . $tempVendortable . "' ) end");

            Log::error("M2 CDR StartTime " . $param['start_date_ymd'] . " - End Time " . $param['end_date_ymd']);
            Log::error(' ========================== M2 transaction end =============================');
            //ProcessCDR

            Log::info("ProcessCDR($CompanyID,$processID,$CompanyGatewayID,$RateCDR,$RateFormat)");
            TempVendorCDR::ProcessCDR($CompanyID, $processID, $CompanyGatewayID, $RateCDR, $RateFormat, $tempVendortable, '', 'CurrentRate', 0, $RerateAccounts);
            $skiped_account_data = TempUsageDetail::ProcessCDR($CompanyID, $processID, $CompanyGatewayID, $RateCDR, $RateFormat, $temptableName, '', 'CurrentRate', 0, 0, 0, $RerateAccounts);
            if (count($skiped_account_data)) {
                $joblogdata['Message'] .= implode('<br>', $skiped_account_data) . '<br>';
            }
            $totaldata_count = DB::connection('sqlsrvcdr')->table($temptableName)->where('ProcessID', $processID)->count();
            DB::connection('sqlsrvcdr')->beginTransaction();
            DB::connection('sqlsrv2')->beginTransaction();

            Log::error("M2 CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' ) start");
            DB::statement("CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' )");
            Log::error("M2 CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' ) end");

            Log::error('M2 prc_insertCDR start');
            DB::connection('sqlsrvcdr')->statement("CALL  prc_insertCDR ('" . $processID . "', '" . $temptableName . "' )");
            DB::connection('sqlsrvcdr')->statement("CALL  prc_insertVendorCDR ('" . $processID . "', '" . $tempVendortable . "')");
            Log::error('M2 prc_insertCDR end');

            /*Log::error('M2 prc_linkCDR start');
            DB::connection('sqlsrvcdr')->statement("CALL  prc_linkCDR ('" . $processID . "','".$tempLinkPrefix."')");
            Log::error('M2 prc_linkCDR end');*/

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
            $joblogdata['Message'] .= "CDR StartTime " . $param['start_date_ymd'] . " - End Time " . $param['end_date_ymd'] . ' total data count ' . $totaldata_count . ' ' . time_elapsed($start_time, date('Y-m-d H:i:s'));

            DB::connection('sqlsrvcdr')->table($temptableName)->where(["ProcessID" => $processID])->delete(); //TempUsageDetail::where(["processId" => $processID])->delete();
            DB::connection('sqlsrvcdr')->table($tempVendortable)->where(["ProcessID" => $processID])->delete(); //TempUsageDetail::where(["processId" => $processID])->delete();
            TempUsageDetail::GenerateLogAndSend($CompanyID, $CompanyGatewayID, $cronsetting, $skiped_account_data, $CronJob->JobTitle);
            if ($AutoAddIP == 1) {
                TempUsageDetail::AutoAddIPLog($CompanyID, $CompanyGatewayID);
            }

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
                DB::connection('sqlsrvcdr')->table($tempVendortable)->where(["ProcessID" => $processID])->delete(); //TempUsageDetail::where(["processId" => $processID])->delete();
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
            $endtime = date('Y-m-01 00:00:00');
        }
        return $endtime;
    }
}
