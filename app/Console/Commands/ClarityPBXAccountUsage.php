<?php namespace App\Console\Commands;

use App\ClarityPBX;
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
use Exception;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;

class ClarityPBXAccountUsage extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'claritypbxaccountusage';

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
        Log::useFiles(storage_path() . '/logs/claritypbxaccountusage-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');
        $temptableName = CompanyGateway::CreateIfNotExistCDRTempUsageDetailTable($CompanyID,$CompanyGatewayID);
        $tempVendortable =  CompanyGateway::CreateVendorTempTable($CompanyID,$CompanyGatewayID);

        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';
        $joblogdata['Message'] = '';
        $processID = CompanyGateway::getProcessID();
        CompanyGateway::updateProcessID($CronJob,$processID);

        try {
            Log::error(' ========================== Clarity PBX transaction start =============================');
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
            TempUsageDetail::applyDiscountPlan();
            $ClarityPBX = new ClarityPBX($CompanyGatewayID);


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

            $response = $ClarityPBX->getAccountCDRs($param);
            $response = json_decode(json_encode($response), true);
            if (!isset($response['faultCode'])) {
                Log::error('call count ' . count($response));
                foreach ((array)$response as $row_account) {
                    if (!empty($row_account['customer_name'])) {
                        $data = array();
                        $data['CompanyGatewayID']   = $CompanyGatewayID;
                        $data['CompanyID']          = $CompanyID;

                        if ($companysetting->NameFormat == 'NAME') {
                            $data['GatewayAccountID'] = $row_account['customer_name'];
                        }
                        $data['AccountIP']          = $row_account['src_ip'];
                        $data['AccountName']        = $row_account['customer_name'];
                        $data['AccountNumber']      = '';
                        $data['connect_time']       = !empty($row_account['answer_time']) ? $row_account['answer_time'] : $row_account['start_time'];
                        $data['disconnect_time']    = !empty($row_account['end_time']) ? $row_account['end_time'] : $row_account['start_time'];
                        $data['cost']               = (float)$row_account['rate_cost_net'];
                        $data['cli']                = apply_translation_rule($CLITranslationRule, $row_account['src']);
                        $data['cld']                = apply_translation_rule($CLDTranslationRule, $row_account['dest']);
                        $data['AccountCLI']         = $data['cli'];
                        $data['billed_duration']    = !empty($row_account['rate_bill_sec']) ? $row_account['rate_bill_sec'] : 0;
                        $data['billed_second']      = !empty($row_account['rate_bill_sec']) ? $row_account['rate_bill_sec'] : 0;
                        $data['duration']           = !empty($row_account['duration_sec']) ? $row_account['duration_sec'] : 0;
                        $data['trunk']              = 'Other';
                        $data['is_inbound']         = '';
                        $data['area_prefix']        = sippy_vos_areaprefix( apply_translation_rule($PrefixTranslationRule,$row_account['rate_prefix']),$RateCDR, $RerateAccounts);
                        $data['ProcessID']          = $processID;
                        $data['ServiceID']          = $ServiceID;
                        $data['disposition']        = $row_account['sip_code'];
                        $data['ID']                 = $row_account['call_id'];
                        $InserData[]                = $data;
                        $data_count++;
                        if ($data_count > $insertLimit && !empty($InserData)) {
                            DB::connection('sqlsrvcdr')->table($temptableName)->insert($InserData);
                            $InserData = array();
                            $data_count = 0;
                        }
                    }

                    if(!empty($row_account['vendor_name'])) {
                        $vendordata                     = array();
                        $vendordata['CompanyGatewayID'] = $CompanyGatewayID;
                        $vendordata['CompanyID']        = $CompanyID;

                        if ($companysetting->NameFormat == 'NAME') {
                            $vendordata['GatewayAccountID'] = $row_account['vendor_name'];
                        }
                        $vendordata['AccountIP']        = $row_account['dest_ip'];
                        $vendordata['AccountName']      = $row_account['vendor_name'];
                        $vendordata['AccountNumber']    = '';
                        $vendordata['connect_time']     = !empty($row_account['answer_time']) ? $row_account['answer_time'] : $row_account['start_time'];
                        $vendordata['disconnect_time']  = !empty($row_account['end_time']) ? $row_account['end_time'] : $row_account['start_time'];
                        $vendordata['selling_cost']     = (float)$row_account['rate_cost_net'];
                        $vendordata['buying_cost']      = (float)$row_account['vendor_cost'];
                        $vendordata['cli']              = apply_translation_rule($CLITranslationRule, $row_account['src']);
                        $vendordata['cld']              = apply_translation_rule($CLDTranslationRule, $row_account['dest']);
                        $vendordata['AccountCLI']       = $vendordata['cli'];
                        $vendordata['billed_duration']  = !empty($row_account['vendor_bill_sec']) ? $row_account['vendor_bill_sec'] : 0;
                        $vendordata['billed_second']    = !empty($row_account['vendor_bill_sec']) ? $row_account['vendor_bill_sec'] : 0;
                        $vendordata['duration']         = !empty($row_account['duration_sec']) ? $row_account['duration_sec'] : 0;
                        $vendordata['trunk']            = 'Other';
                        $vendordata['area_prefix']      = sippy_vos_areaprefix( apply_translation_rule($PrefixTranslationRule,$row_account['rate_prefix']),$RateCDR, $RerateAccounts);
                        $vendordata['ProcessID']        = $processID;
                        $vendordata['ServiceID']        = $ServiceID;
                        $vendordata['ID']               = $row_account['call_id'];
                        $InserVData[]                   = $vendordata;
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

            date_default_timezone_set(Config::get('app.timezone'));

            $joblogdata['Message'] = "CDR StartTime " . $param['start_date_ymd'] . " - End Time " . $param['end_date_ymd'];
            $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
            Log::error("claritypbx CDR StartTime " . $param['start_date_ymd'] . " - End Time " . $param['end_date_ymd']);
            Log::error(' ========================== claritypbx transaction end =============================');

            /** delete duplicate id*/
            /** Check in tblUsageDetails and tblUsageDetailFailedCall table  and remove existing from temp table */
            Log::info("CALL  prc_DeleteDuplicateUniqueID ('" . $CompanyID . "','" . $CompanyGatewayID . "' , '" . $processID . "', '" . $temptableName . "' ) start");
            DB::connection('sqlsrvcdr')->statement("CALL  prc_DeleteDuplicateUniqueID ('" . $CompanyID . "','" . $CompanyGatewayID . "' , '" . $processID . "', '" . $temptableName . "' )");
            Log::info("CALL  prc_DeleteDuplicateUniqueID ('" . $CompanyID . "','" . $CompanyGatewayID . "' , '" . $processID . "', '" . $temptableName . "' ) end");


            /** delete duplicate id*/
            Log::info("CALL  prc_DeleteDuplicateUniqueID2 ('" . $CompanyID . "','" . $CompanyGatewayID . "' , '" . $processID . "', '" . $tempVendortable . "' ) start");
            DB::connection('sqlsrvcdr')->statement("CALL  prc_DeleteDuplicateUniqueID2 ('" . $CompanyID . "','" . $CompanyGatewayID . "' , '" . $processID . "', '" . $tempVendortable . "' )");
            Log::info("CALL  prc_DeleteDuplicateUniqueID2 ('" . $CompanyID . "','" . $CompanyGatewayID . "' , '" . $processID . "', '" . $tempVendortable . "' ) end");

            //ProcessCDR
            /** claritypbx ProcessCDR New Tasks
             * 1. update cost = 0 where cc_type = 4 (OUTNOCHARGE)
             */
            Log::info("ProcessCDR($CompanyID,$processID,$CompanyGatewayID,$RateCDR,$RateFormat)");
            TempVendorCDR::ProcessCDR($CompanyID, $processID, $CompanyGatewayID, $RateCDR, $RateFormat, $tempVendortable, '', 'CurrentRate', 0, $RerateAccounts);
            $skiped_account_data = TempUsageDetail::ProcessCDR($CompanyID, $processID, $CompanyGatewayID, $RateCDR, $RateFormat, $temptableName, '', 'CurrentRate', 0, 0, 0, $RerateAccounts);
            if (count($skiped_account_data)) {
                $joblogdata['Message'] .= implode('<br>', $skiped_account_data);
            }

            DB::connection('sqlsrvcdr')->beginTransaction();
            DB::connection('sqlsrv2')->beginTransaction();

            //
            Log::error("claritypbx CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' ) start");
            DB::statement("CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' )");
            Log::error("claritypbx CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' ) end");

            /** claritypbx prc_insertCDR New Tasks
             * 1. Move disposition <> "ANSWERED" to failed call
             */
            Log::error('claritypbx prc_insertCDR start');
            DB::connection('sqlsrvcdr')->statement("CALL  prc_insertCDR ('" . $processID . "', '" . $temptableName . "' )");
            DB::connection('sqlsrvcdr')->statement("CALL  prc_insertVendorCDR ('" . $processID . "', '" . $tempVendortable . "')");

            Log::error('claritypbx prc_insertCDR end');
            $logdata['CompanyGatewayID'] = $CompanyGatewayID;
            $logdata['CompanyID'] = $CompanyID;
            $logdata['start_time'] = $param['start_date_ymd'];
            $logdata['end_time'] = $param['end_date_ymd'];
            $logdata['created_at'] = date('Y-m-d H:i:s');
            $logdata['ProcessID'] = $processID;
            TempUsageDownloadLog::insert($logdata);
            DB::connection('sqlsrvcdr')->commit();
            DB::connection('sqlsrv2')->commit();

            TempUsageDetail::GenerateLogAndSend($CompanyID, $CompanyGatewayID, $cronsetting, $skiped_account_data, $CronJob->JobTitle);

            end_of_cronjob:

            CronJobLog::insert($joblogdata);

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
