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

class PBXAccountUsage extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'pbxaccountusage';

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
        $ServiceID = (int)Service::getGatewayServiceID($CompanyGatewayID);
        $temptableName = CompanyGateway::CreateIfNotExistCDRTempUsageDetailTable($CompanyID,$CompanyGatewayID);
        Log::useFiles(storage_path() . '/logs/pbxaccountusage-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');

        /* To avoid runing same day cron job twice */
        //if(true){//if($yesterday_date > $param['start_date_ymd']) {
        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';
        $processID = CompanyGateway::getProcessID();
        $accounts = array();
        try {

            CronJob::createLog($CronJobID);

            $pbx = new PBX($CompanyGatewayID);
            $TimeZone = CompanyGateway::getGatewayTimeZone($CompanyGatewayID);
            if ($TimeZone != '') {
                date_default_timezone_set($TimeZone);
            } else {
                date_default_timezone_set('GMT'); // just to use e in date() function
            }
            $RateFormat = Company::PREFIX;
            $RateCDR = 0;

            if(isset($companysetting->RateCDR) && $companysetting->RateCDR){
                $RateCDR = $companysetting->RateCDR;
            }
            if(isset($companysetting->RateFormat) && $companysetting->RateFormat){
                $RateFormat = $companysetting->RateFormat;
            }
            $CLITranslationRule = $CLDTranslationRule =  '';
            if(!empty($companysetting->CLITranslationRule)){
                $CLITranslationRule = $companysetting->CLITranslationRule;
            }
            if(!empty($companysetting->CLDTranslationRule)){
                $CLDTranslationRule = $companysetting->CLDTranslationRule;
            }
            if($RateCDR == 0) {
                TempUsageDetail::applyDiscountPlan();
            }
            $param['start_date_ymd'] = $this->getStartDate($CompanyID, $CompanyGatewayID, $CronJobID);
            $param['end_date_ymd'] = $this->getLastDate($param['start_date_ymd'], $CompanyID, $CronJobID);
            $param['RateCDR'] = $RateCDR;

            Log::error(print_r($param, true));

            /**
             * Not in use
             * $CdrBehindData = array();
            //check CdrBehindDuration from cron job setting
            if(!empty($cronsetting['ErrorEmail'])){
                $CdrBehindData['startdatetime'] =$param['start_date_ymd'];
                CronJob::CheckCdrBehindDuration($CronJob,$CdrBehindData);
            }
            //CdrBehindDuration
             * */


            $today_current = date('Y-m-d H:i:s');

            $response = $pbx->getAccountCDRs($param);
            $response = json_decode(json_encode($response), true);
            Log::info('count ==' . count($response));
            $InserData = array();
            $data_count = 0;
            $insertLimit = 1000;
            if (!isset($response['faultCode'])) {

                foreach ((array)$response as $row_account) {

                    $data = $data_outbound = array();
                    if(!empty($row_account['accountcode'])) {


                        /**  User Field
                         * if it contains inbound. Src will be the Calling Party Number and First Destination will be the DID number
                         * if it contains outbound. Src will be the DID number from where outbound call is made and use last destination as the number dialed, if blank then use First Destination
                         * */
                        /**
                         * <InboundOutbound>
                         *
                         * split into two rows Inbound = Src,FirstDst
                         *
                         * Outbound = FirstDst,LstDst
                         */
                        $call_type = TempUsageDetail::check_call_type(strtolower($row_account["userfield"]),strtolower($row_account['cc_type']),strtolower($row_account['pincode']));

                        //Log::info( 'userfield ' . $row_account["userfield"] .' -  call_type ' . $call_type . '-  src ' . $row_account['src'] . ' -  firstdst ' . $row_account['firstdst']. '- lastdst ' . $row_account['lastdst'] );

                        $data['CompanyGatewayID'] = $CompanyGatewayID;
                        $data['CompanyID'] = $CompanyID;
                        $data['GatewayAccountID'] = $row_account['accountcode'];
                        $data['connect_time'] = date("Y-m-d H:i:s", strtotime($row_account['start']));
                        $data['disconnect_time'] = date("Y-m-d H:i:s", strtotime($row_account['end']));
                        $data['billed_second'] = $row_account['billsec'];
                        $data['billed_duration'] = $row_account['billsec'];
                        $data['duration'] = $row_account['duration'];


                        $data['trunk'] = 'Other';
                        $data['area_prefix'] = 'Other';
                        $data['pincode'] = $row_account['pincode'];
                        $data['disposition'] = $row_account['disposition'];
                        $data['extension'] = $row_account['extension'];
                        $data['ProcessID'] = $processID;
                        $data['ServiceID'] = $ServiceID;
                        $data['ID'] = $row_account['ID'];
                        $data['is_inbound'] = 0;
                        $data['cost'] = (float)$row_account['cc_cost'];
                        $data['cli'] = $row_account['src'];
                        $data['cld'] = !empty($row_account['lastdst']) ? $row_account['lastdst'] : $row_account['firstdst'];


                        if ($call_type == 'inbound') {

                            $data['cld'] = $row_account['firstdst'];
                            $data['is_inbound'] = 1;


                        } else if ($call_type == 'outbound') {

                            $data['cld'] = !empty($row_account['lastdst']) ? $row_account['lastdst'] : $row_account['firstdst'];

                        } else if ($call_type == 'none') {

                            $data['cld'] = !empty($row_account['lastdst']) ? $row_account['lastdst'] : $row_account['firstdst'];
                            //$data['is_inbound'] = 0;
                            /** if user field is blank */
                        } else if ($call_type == 'both') {

                            $data['cld'] = !empty($row_account['lastdst']) ? $row_account['lastdst'] : $row_account['firstdst'];
                            /** if user field is both */
                        }else if ($call_type == 'failed') {
                            //Log::info($row_account["userfield"]);
                            //Log::info($row_account["ID"]);
                            /** if user field is failed or blocked call any reason make duration zero */
                            $data['billed_duration'] = 0;
                            $data['billed_second'] = 0;
                        }


                        if ($call_type == 'both' && $RateCDR == 1) {

                            /**
                             * Inbound Entry
                             */

                            $data['cld'] = $row_account['firstdst'];
                            $data['cost'] = 0;
                            $data['is_inbound'] = 1;

                            /**
                             * Outbound Entry
                             */
                            $data_outbound = $data;

                            $data_outbound['cli'] = $row_account['firstdst'];
                            $data_outbound['cld'] = !empty($row_account['lastdst']) ? $row_account['lastdst'] : $row_account['firstdst'];
                            $data_outbound['cost'] = (float)$row_account['cc_cost'];
                            $data_outbound['is_inbound'] = 0;

                        }
                        $data['cli'] = apply_translation_rule($CLITranslationRule,$data['cli']);
                        $data['cld'] = apply_translation_rule($CLDTranslationRule,$data['cld']);

                        $InserData[] = $data;
                        $data_count++;

                        if ($call_type == 'both' && $RateCDR == 1 && !empty($data_outbound)) {
                            $data_outbound['cli'] = apply_translation_rule($CLITranslationRule,$data_outbound['cli']);
                            $data_outbound['cld'] = apply_translation_rule($CLDTranslationRule,$data_outbound['cld']);
                            $InserData[] = $data_outbound;
                            $data_count++;

                        }
                        if ($data_count > $insertLimit && !empty($InserData)) {
                            DB::connection('sqlsrvcdrazure')->table($temptableName)->insert($InserData);
                            $InserData = array();
                            $data_count = 0;
                        }
                    }

                }//loop

                if (!empty($InserData)) {
                    DB::connection('sqlsrvcdrazure')->table($temptableName)->insert($InserData);

                }
                date_default_timezone_set(Config::get('app.timezone'));
            }

            $joblogdata['Message'] = "CDR StartTime " . $param['start_date_ymd'] . " - End Time " . $param['end_date_ymd'];
            $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
            Log::error("pbx CDR StartTime " . $param['start_date_ymd'] . " - End Time " . $param['end_date_ymd']);
            Log::error(' ========================== pbx transaction end =============================');

            /** delete duplicate id*/
            Log::info("CALL  prc_DeleteDuplicateUniqueID ('".$CompanyID."','".$CompanyGatewayID."' , '" . $processID . "', '" . $temptableName . "' ) start");
            DB::connection('sqlsrvcdrazure')->statement("CALL  prc_DeleteDuplicateUniqueID ('".$CompanyID."','".$CompanyGatewayID."' , '" . $processID . "', '" . $temptableName . "' )");
            Log::info("CALL  prc_DeleteDuplicateUniqueID ('".$CompanyID."','".$CompanyGatewayID."' , '" . $processID . "', '" . $temptableName . "' ) end");
            //ProcessCDR

            Log::info("ProcessCDR($CompanyID,$processID,$CompanyGatewayID,$RateCDR,$RateFormat)");

            $skiped_account_data = TempUsageDetail::ProcessCDR($CompanyID,$processID,$CompanyGatewayID,$RateCDR,$RateFormat,$temptableName);
            if (count($skiped_account_data)) {
                $joblogdata['Message'] .= implode('<br>', $skiped_account_data);
            }

            DB::connection('sqlsrvcdrazure')->beginTransaction();
            DB::connection('sqlsrv2')->beginTransaction();
            if($RateCDR == 0) {
                Log::error("Porta CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' ) start");
                DB::statement("CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' )");
                Log::error("Porta CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' ) end");
            }
            Log::error('pbx prc_insertCDR start');
            DB::connection('sqlsrvcdrazure')->statement("CALL  prc_insertCDR ('" . $processID . "', '".$temptableName."' )");
            Log::error('pbx prc_insertCDR end');
            $logdata['CompanyGatewayID'] = $CompanyGatewayID;
            $logdata['CompanyID'] = $CompanyID;
            $logdata['start_time'] = $param['start_date_ymd'];
            $logdata['end_time'] = $param['end_date_ymd'];
            $logdata['created_at'] = date('Y-m-d H:i:s');
            $logdata['ProcessID'] = $processID;
            TempUsageDownloadLog::insert($logdata);
            DB::connection('sqlsrvcdrazure')->commit();
            DB::connection('sqlsrv2')->commit();
            CronJobLog::insert($joblogdata);
            TempUsageDetail::GenerateLogAndSend($CompanyID,$CompanyGatewayID,$cronsetting,$skiped_account_data,$CronJob->JobTitle);

        } catch (\Exception $e) {
            try {
                DB::rollback();
                DB::connection('sqlsrv2')->rollback();
                DB::connection('sqlsrvcdrazure')->rollback();
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
        $dataactive['Active'] = 0;
        $dataactive['PID'] = '';
        $CronJob->update($dataactive);
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
        $current = strtotime(date('Y-m-d H:i:s'));
        $seconds = $current - strtotime($endtime);
        $minutes = round($seconds / 60);
        if ($minutes <= $pbxusageinterval) {
            $endtime = date('Y-m-d H:i:s', strtotime('-'.$pbxusageinterval.' minute'));  //date('Y-m-d H:i:s');
        }
        if (empty($endtime)) {
            $endtime = date('Y-m-1 00:00:00');
        }
        return $endtime;
    }
}
