<?php namespace App\Console\Commands;

use App\Lib\Company;
use App\Lib\CompanyConfiguration;
use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\GatewayAccount;
use App\Lib\Service;
use App\Lib\TempUsageDetail;
use App\Lib\TempUsageDownloadLog;
use App\Lib\UsageDetail;
use App\Porta;
use Exception;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;

class PortaAccountUsage extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'portaaccountusage';

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
        $ServiceID = (int)Service::getGatewayServiceID($CompanyGatewayID);
        Log::useFiles(storage_path() . '/logs/portaaccountusage-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');
        $temptableName = CompanyGateway::CreateIfNotExistCDRTempUsageDetailTable($CompanyID,$CompanyGatewayID);

        /* To avoid runing same day cron job twice */
        //if(true){//if($yesterday_date > $param['start_date_ymd']) {

        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';
        $joblogdata['Message'] = '';
        $processID = CompanyGateway::getProcessID();
        CompanyGateway::updateProcessID($CronJob,$processID);
        $accounts = array();
        try {
            Log::error(' ========================== porta transaction start =============================');
            CronJob::createLog($CronJobID);

            if(isset($cronsetting['CDRImportStartDate']) && trim($cronsetting['CDRImportStartDate'])!=''){

                $result = UsageDetail::reImportCDRByStartDate($cronsetting,$CronJobID,$processID);

                $joblogdata['CronJobStatus'] = $result['CronJobStatus'];
                $joblogdata['Message'] .= $result['Message'];

                CronJobLog::insert($joblogdata);

            }else {

                $RateFormat = Company::PREFIX;
                $RateCDR = 0;

                $RerateAccounts = !empty($companysetting->Accounts) ? count($companysetting->Accounts) : 0;

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
                $porta = new Porta($CompanyGatewayID);
                $responselistAccounts = $porta->listAccounts();
                if (isset($responselistAccounts['CustomersShortInfo'])) {
                    foreach ((array)$responselistAccounts['CustomersShortInfo'] as $row_account) {

                        $gadata = array();
                        $gadata['CompanyID'] = $CompanyID;
                        $gadata['CompanyGatewayID'] = $CompanyGatewayID;
                        $gadata['ServiceID'] = $ServiceID;
                        $gadata['GatewayAccountID'] = $row_account['ICustomer'];
                        $gadata['AccountIP'] = '';
                        $gadata['AccountNumber'] = '';
                        $gadata['AccountCLI'] = '';
                        $accounts[$row_account['ICustomer']] = $row_account['Name'];

                        $gadata['AccountName'] = $row_account['Name'];
                        $row_account['CreationDate'] = date("Y-m-d H:i:s", (doubleval(filter_var($row_account['CreationDate'], FILTER_SANITIZE_NUMBER_INT)) / 1000));
                        $gadata['AccountDetailInfo'] = json_encode($row_account);
                        if (GatewayAccount::where(array('CompanyGatewayID' => $CompanyGatewayID, 'CompanyID' => $CompanyID, 'ServiceID' => $ServiceID, 'GatewayAccountID' => $row_account['ICustomer']))->count()) {
                            GatewayAccount::where(array('CompanyGatewayID' => $CompanyGatewayID, 'CompanyID' => $CompanyID, 'ServiceID' => $ServiceID, 'GatewayAccountID' => $row_account['ICustomer']))->update($gadata);
                        } else {
                            GatewayAccount::insert($gadata);
                        }
                    }
                }

                $TimeZone = CompanyGateway::getGatewayTimeZone($CompanyGatewayID);
                if ($TimeZone != '') {
                    date_default_timezone_set($TimeZone);
                } else {
                    date_default_timezone_set('GMT'); // just to use e in date() function
                }
                $param['start_date_ymd'] = $this->getStartDate($CompanyID, $CompanyGatewayID, $CronJobID);
                $param['end_date_ymd'] = $this->getLastDate($param['start_date_ymd'], $CompanyID, $CronJobID);

                Log::error(print_r($param, true));

                /**
                 * Not in Use
                 * $CdrBehindData = array();
                 * //check CdrBehindDuration from cron job setting
                 * if(!empty($cronsetting['ErrorEmail'])){
                 * $CdrBehindData['startdatetime'] =$param['start_date_ymd'];
                 * CronJob::CheckCdrBehindDuration($CronJob,$CdrBehindData);
                 * }
                 * //CdrBehindDuration
                 */

                $InserData = array();
                $data_count = 0;
                $insertLimit = 1000;
                foreach ($accounts as $GatewayAccountID => $AccountName) {
                    $param['ICustomer'] = $GatewayAccountID; //$rowdata->GatewayAccountID;
                    $response = array();

                    $response = $porta->getAccountCDRs($param);
                    if (!isset($response['faultCode'])) {
                        if (isset($response['DictPortaCustomerAccountCDRS']['Voice Calls'])) {
                            Log::error('call count ' . count($response['DictPortaCustomerAccountCDRS']['Voice Calls']) . ' GatewayAccountID = ' . $GatewayAccountID);
                            foreach ((array)$response['DictPortaCustomerAccountCDRS']['Voice Calls'] as $row_account) {
                                $data = array();
                                $data['CompanyGatewayID'] = $CompanyGatewayID;
                                $data['CompanyID'] = $CompanyID;
                                $data['GatewayAccountID'] = $row_account['ICustomer'];
                                $data['connect_time'] = date("Y-m-d H:i:s", (doubleval(filter_var($row_account['Connect_time'], FILTER_SANITIZE_NUMBER_INT)) / 1000));
                                $data['disconnect_time'] = date("Y-m-d H:i:s", (doubleval(filter_var($row_account['Disconnect_time'], FILTER_SANITIZE_NUMBER_INT)) / 1000));
                                $data['cost'] = (float)$row_account['Charged_Amount'];
                                $data['cld'] = apply_translation_rule($CLDTranslationRule, $row_account['CLD']);
                                $data['cli'] = apply_translation_rule($CLITranslationRule, $row_account['CLI']);
                                $data['billed_duration'] = $row_account['Charged_Quantity'];
                                $data['billed_second'] = $row_account['Charged_Quantity'];
                                $data['duration'] = $row_account['Used_Quantity'];

                                $data['AccountIP'] = '';
                                $data['AccountName'] = $AccountName;
                                $data['AccountNumber'] = '';
                                $data['AccountCLI'] = '';
                                //$data['AccountID'] = $rowdata->AccountID;
                                $data['trunk'] = 'Other';
                                $data['area_prefix'] = 'Other';
                                $data['ProcessID'] = $processID;
                                $data['ServiceID'] = $ServiceID;
                                $data['ID'] = $row_account['ID'];
                                if (isset($row_account['CallType']) && is_numeric($row_account['CallType'])) {
                                    $InserData[] = $data;
                                    $data_count++;
                                }
                                if ($data_count > $insertLimit && !empty($InserData)) {
                                    DB::connection('sqlsrvcdr')->table($temptableName)->insert($InserData);
                                    $InserData = array();
                                    $data_count = 0;
                                }
                            }

                        }

                    }
                }// loop
                if (!empty($InserData)) {
                    DB::connection('sqlsrvcdr')->table($temptableName)->insert($InserData);

                }
                date_default_timezone_set(Config::get('app.timezone'));
                /** delete duplicate id*/
                Log::info("CALL  prc_DeleteDuplicateUniqueID ('" . $CompanyID . "','" . $CompanyGatewayID . "' , '" . $processID . "', '" . $temptableName . "' ) start");
                DB::connection('sqlsrvcdr')->statement("CALL  prc_DeleteDuplicateUniqueID ('" . $CompanyID . "','" . $CompanyGatewayID . "' , '" . $processID . "', '" . $temptableName . "' )");
                Log::info("CALL  prc_DeleteDuplicateUniqueID ('" . $CompanyID . "','" . $CompanyGatewayID . "' , '" . $processID . "', '" . $temptableName . "' ) end");


                Log::error("Porta CDR StartTime " . $param['start_date_ymd'] . " - End Time " . $param['end_date_ymd']);
                Log::error(' ========================== porta transaction end =============================');
                //ProcessCDR

                Log::info("ProcessCDR($CompanyID,$processID,$CompanyGatewayID,$RateCDR,$RateFormat)");
                $skiped_account_data = TempUsageDetail::ProcessCDR($CompanyID, $processID, $CompanyGatewayID, $RateCDR, $RateFormat, $temptableName, '', 'CurrentRate', 0, 0, 0, $RerateAccounts);
                if (count($skiped_account_data)) {
                    $joblogdata['Message'] .= implode('<br>', $skiped_account_data) . '<br>';
                }
                $totaldata_count = DB::connection('sqlsrvcdr')->table($temptableName)->where('ProcessID', $processID)->count();
                DB::connection('sqlsrvcdr')->beginTransaction();
                DB::connection('sqlsrv2')->beginTransaction();

                Log::error("Porta CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' ) start");
                DB::statement("CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' )");
                Log::error("Porta CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' ) end");

                Log::error('Porta prc_insertCDR start');
                DB::connection('sqlsrvcdr')->statement("CALL  prc_insertCDR ('" . $processID . "', '" . $temptableName . "' )");
                Log::error('Porta prc_insertCDR end');
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
                CronJobLog::insert($joblogdata);
                DB::connection('sqlsrvcdr')->table($temptableName)->where(["processId" => $processID])->delete(); //TempUsageDetail::where(["processId" => $processID])->delete();
                TempUsageDetail::GenerateLogAndSend($CompanyID, $CompanyGatewayID, $cronsetting, $skiped_account_data, $CronJob->JobTitle);
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
                DB::connection('sqlsrvcdr')->table($temptableName)->where(["processId" => $processID])->delete(); //TempUsageDetail::where(["processId" => $processID])->delete();
                //DB::connection('sqlsrvcdr')->statement("  DELETE FROM tblTempUsageDetail WHERE ProcessID = '".$processID."'");
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
        $usageinterval = CompanyConfiguration::get($companyid,'USAGE_INTERVAL');
        $cronsetting = json_decode($Settings);

        $seconds = strtotime(date('Y-m-d 00:00:00')) - strtotime($startdate);
        $hours = round($seconds / 60 / 60);
        $endtimefinal = date('Y-m-d H:i:s', strtotime($startdate) + $cronsetting->MaxInterval * 60);
        if($endtimefinal > date('Y-m-d H:i:s')){
            return date('Y-m-d H:i:s');
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
    
}
