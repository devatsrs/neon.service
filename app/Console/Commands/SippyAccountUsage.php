<?php namespace App\Console\Commands;


use App\Lib\GatewayAccount;
use App\Lib\TempUsageDetail;
use App\Sippy;
use Symfony\Component\Console\Input\InputArgument;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Config;
use App\Lib\TempUsageDownloadLog;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\CompanyGateway;
use Webpatser\Uuid\Uuid;
use App\Lib\Helper;
use App\Lib\Company;
use \Exception;

class SippyAccountUsage extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'sippyaccountusage';

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
        ini_set('memory_limit', '-1');

        $arguments = $this->argument();
        $getmypid = getmypid(); // get proccess id
        $CronJobID = $arguments["CronJobID"];
        $CompanyID = $arguments["CompanyID"];
        $CronJob = CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);

        $dataactive['Active'] = 1;
        $dataactive['LastRunTime'] = date('Y-m-d H:i:00');
        $dataactive['PID'] = $getmypid;
        $CronJob->update($dataactive);
        $processID = Uuid::generate();
        $data_count =$totaldata_count = 0;
        $insertLimit = 1000;


        $yesterday_date = date('Y-m-d 23:59:59', strtotime('-1 day'));
        $CompanyGatewayID = $cronsetting['CompanyGatewayID'];
        $companysetting = json_decode(CompanyGateway::getCompanyGatewayConfig($CompanyGatewayID));
        $IpBased = ($companysetting->NameFormat == 'IP') ? 1 : 0;
        $param['start_date_ymd'] = TempUsageDownloadLog::getStartDate($CompanyID, $CompanyGatewayID, $CronJobID);
        Log::useFiles(storage_path() . '/logs/sippyaccountusage-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');
        $temptableName = CompanyGateway::CreateIfNotExistCDRTempUsageDetailTable($CompanyID,$CompanyGatewayID);


        /* cdrbehinde update */
        $CdrBehindData = array();
        //check CdrBehindDuration from cron job setting
        if(!empty($cronsetting['ErrorEmail'])){
            $CdrBehindData['startdatetime'] = $param['start_date_ymd'];
            CronJob::CheckCdrBehindDuration($CronJob,$CdrBehindData);
        }

        /* To avoid runing same day cron job twice */
        if ($yesterday_date > $param['start_date_ymd']) {
            $joblogdata = array();
            $joblogdata['CronJobID'] = $CronJobID;
            $joblogdata['created_at'] = date('Y-m-d H:i:s');
            $joblogdata['created_by'] = 'RMScheduler';
            $joblogdata['Message'] = '';

            try {
                $start_time = date('Y-m-d H:i:s');
                Log::error(' ========================== sippy transaction start =============================');
                CronJob::createLog($CronJobID);
                $sippyxc = new Sippy($CompanyGatewayID);
                $responselistAccounts = $sippyxc->listAccounts();
                foreach ((array)$responselistAccounts['accounts'] as $row_account) {
                    $gadata = array();
                    $gadata['CompanyID'] = $CompanyID;
                    $gadata['CompanyGatewayID'] = $CompanyGatewayID;
                    $gadata['GatewayAccountID'] = $row_account['i_account'];
                    $gadata['AccountName'] = $row_account['username'];
                    $gadata['AccountDetailInfo'] = json_encode($row_account);

                    if (GatewayAccount::where(array('CompanyGatewayID' => $CompanyGatewayID, 'CompanyID' => $CompanyID, 'GatewayAccountID' => $row_account['i_account']))->count()) {
                        //GatewayAccount::where(array('CompanyGatewayID' => $CompanyGatewayID, 'CompanyID' => $CompanyID, 'GatewayAccountID' => $row_account['i_account']))->update($gadata);
                    } else {
                        GatewayAccount::insert($gadata);
                    }
                }

                $TimeZone = CompanyGateway::getGatewayTimeZone($CompanyGatewayID);
                if ($TimeZone == '') {
                    $TimeZone = 'GMT';
                }
                date_default_timezone_set($TimeZone);

                $param['end_date_ymd'] = TempUsageDownloadLog::getLastDate($param['start_date_ymd'], $CompanyID, $CronJobID);
                $addparam['start_date'] = date('H:i:s.000 e D M d Y', strtotime($param['start_date_ymd']));
                $addparam['end_date'] = date('H:i:s.000 e D M d Y', strtotime($param['end_date_ymd']));
                Log::error(print_r($param, true));


                //CdrBehindDuration

                $response = array();
                $sippy = new Sippy($CompanyGatewayID);

                $response = $sippy->getAccountCDRs($addparam);
                if (!isset($response['faultCode'])) {
                    if (isset($response['cdrs'])) {
                        Log::error(print_r(count($response['cdrs']), true));
                        $InserData = array();
                        foreach ((array)$response['cdrs'] as $row_account) {
                            $data = array();
                            $data['CompanyGatewayID'] = $CompanyGatewayID;
                            $data['CompanyID'] = $CompanyID;
                            $data['GatewayAccountID'] = $row_account['i_account'];
                            $setup_strtotime = $strtotime = strtotime(date('Y-m-d ', strtotime($row_account['connect_time'])) . substr($row_account['connect_time'], 0, 8));
                            if(isset($row_account['setup_time'])) {
                                $setup_strtotime = strtotime(date('Y-m-d ', strtotime($row_account['setup_time'])) . substr($row_account['setup_time'], 0, 8));
                            }
                            $data['connect_time'] = date('Y-m-d H:i:s', $setup_strtotime);
                            $data['disconnect_time'] = date('Y-m-d H:i:s', $strtotime + $row_account['billed_duration']);
                            $data['cost'] = (float)$row_account['cost'];
                            $data['cld'] = str_replace('2222', '', $row_account['cld_in']);
                            $data['cli'] = $row_account['cli_in'];
                            $data['billed_duration'] = $row_account['billed_duration'];
                            $data['duration'] = $row_account['billed_duration'];
                            $data['trunk'] = 'Other';
                            $data['area_prefix'] = 'Other';
                            $data['remote_ip'] = $row_account['remote_ip'];
                            $data['ProcessID'] = $processID;
                            $InserData[] = $data;
                            if($data_count > $insertLimit &&  !empty($InserData)){
                                DB::connection('sqlsrvcdrazure')->table($temptableName)->insert($InserData);
                                $InserData = array();
                                $data_count = 0;
                            }
                            $data_count++;
                            $totaldata_count++;
                        } // loop over
                        if(!empty($InserData)){
                            DB::connection('sqlsrvcdrazure')->table($temptableName)->insert($InserData);
                        }
                    }

                    date_default_timezone_set(Config::get('app.timezone'));

                }

                Log::error("CDR StartTime " . $addparam['start_date'] . " - End Time " . $addparam['end_date']);
                //ProcessCDR
                $RateFormat = Company::PREFIX;
                $RateCDR = 0;
                if(isset($companysetting->RateCDR) && $companysetting->RateCDR){
                    $RateCDR = $companysetting->RateCDR;
                }
                if(isset($companysetting->RateFormat) && $companysetting->RateFormat){
                    $RateFormat = $companysetting->RateFormat;
                }
                Log::info("ProcessCDR($CompanyID,$processID,$CompanyGatewayID,$RateCDR,$RateFormat,$temptableName)");
                $skiped_account_data = TempUsageDetail::ProcessCDR($CompanyID,$processID,$CompanyGatewayID,$RateCDR,$RateFormat,$temptableName);
                if (count($skiped_account_data)) {
                    $joblogdata['Message'] .= ' <br>Skipped Rerate Code:' . implode('<br>', $skiped_account_data);
                }

                DB::connection('sqlsrvcdrazure')->beginTransaction();
                DB::connection('sqlsrv2')->beginTransaction();
                Log::error('Sippy prc_insertCDR start');
                DB::connection('sqlsrvcdrazure')->statement("CALL  prc_insertCDR ('" . $processID . "', '".$temptableName."' )");
                Log::error('Sippy prc_insertCDR end');
                $logdata['CompanyGatewayID'] = $CompanyGatewayID;
                $logdata['CompanyID'] = $CompanyID;
                $logdata['start_time'] = $param['start_date_ymd'];
                $logdata['end_time'] = $param['end_date_ymd'];
                $logdata['created_at'] = date('Y-m-d H:i:s');
                $logdata['ProcessID'] = $processID;
                TempUsageDownloadLog::insert($logdata);
				

                DB::connection('sqlsrvcdrazure')->commit();
                DB::connection('sqlsrv2')->commit();

                $end_time = date('Y-m-d H:i:s');
                $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
                $joblogdata['Message'] .= "CDR StartTime " . $addparam['start_date'] . " - End Time " . $addparam['end_date'].' total data count '.$totaldata_count.' '.time_elapsed($start_time,$end_time);
                CronJobLog::insert($joblogdata);
                DB::connection('sqlsrvcdrazure')->table($temptableName)->where(["processId" => $processID])->delete(); //TempUsageDetail::where(["processId" => $processID])->delete();
                TempUsageDetail::GenerateLogAndSend($CompanyID,$CompanyGatewayID,$cronsetting,$skiped_account_data,$CronJob->JobTitle);
            } catch (\Exception $e) {
                try {
                    @DB::rollback();
                    @DB::connection('sqlsrv2')->rollback();
                    @DB::connection('sqlsrvcdrazure')->rollback();
                } catch (\Exception $err) {
                    Log::error($err);
                }
                // delete temp table if process fail
                try {
                    DB::connection('sqlsrvcdrazure')->table($temptableName)->where(["processId" => $processID])->delete();//TempUsageDetail::where(["processId" => $processID])->delete();
                    //DB::connection('sqlsrvcdrazure')->statement("  DELETE FROM tblTempUsageDetail WHERE ProcessID = '" . $processID . "'");
                } catch (\Exception $err) {
                    Log::error($err);
                }
                $this->info('Failed:' . $e->getMessage());
                $joblogdata['Message'] = 'Error:' . $e->getMessage();
                $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
                date_default_timezone_set(Config::get('app.timezone'));
                CronJobLog::insert($joblogdata);
                Log::error($e);
                if (!empty($cronsetting['ErrorEmail'])){
                    $result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
                    Log::error("**Email Sent Status " . $result['status']);
                    Log::error("**Email Sent message " . $result['message']);
                }
            }
        }else{

            // When Sippy Cdr download is finished . keep update LastRunTime and NextRunTime to avoid ActiveCronJobEmail to send alert.
            CronJob::createLog($CronJobID);

        }
        $dataactive['Active'] = 0;
        $dataactive['PID'] = '';
        $CronJob->update($dataactive);
        if(!empty($cronsetting['SuccessEmail'])) {
            $result = CronJob::CronJobSuccessEmailSend($CronJobID);
            Log::error("**Email Sent Status ".$result['status']);
            Log::error("**Email Sent message ".$result['message']);
        }

        DB::disconnect('sqlsrv');
        DB::disconnect('sqlsrv2');
        DB::disconnect('sqlsrvcdr');

    }

}
