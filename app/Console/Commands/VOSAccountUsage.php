<?php
/**
 * Created by PhpStorm.
 * User: srs2
 * Date: 25/05/2015
 * Time: 06:58
 */

namespace App\Console\Commands;


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
use App\Lib\UsageDownloadFiles;
use Exception;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;

class VOSAccountUsage extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'vosaccountusage';

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

        $CronJobID = $arguments["CronJobID"];
        $CompanyID = $arguments["CompanyID"];
        $CronJob = CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings, true);
        if(isset($cronsetting['FilesMaxProccess']) && $cronsetting['FilesMaxProccess'] > 0){
            $FilesMaxProccess = $cronsetting['FilesMaxProccess'];
        }else{
            $FilesMaxProccess = '30';
        }
        $data_count = 0;
        $data_countv = 0;
        $insertLimit = 1000;


        $CompanyGatewayID = $cronsetting['CompanyGatewayID'];
        $companysetting = json_decode(CompanyGateway::getCompanyGatewayConfig($CompanyGatewayID));
        $ServiceID = (int)Service::getGatewayServiceID($CompanyGatewayID);
        Log::useFiles(storage_path() . '/logs/vosaccountusage-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');
        $IpBased = ($companysetting->NameFormat == 'IP') ? 1 : 0;
        CronJob::activateCronJob($CronJob);
        CronJob::createLog($CronJobID);
        $processID = CompanyGateway::getProcessID();
        CompanyGateway::updateProcessID($CronJob,$processID);
        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';
        $joblogdata['Message'] = '';
        $delete_files = array();
        $temptableName = CompanyGateway::CreateIfNotExistCDRTempUsageDetailTable($CompanyID,$CompanyGatewayID);
        $tempVendortable =  CompanyGateway::CreateVendorTempTable($CompanyID,$CompanyGatewayID);
        //$tempLinkPrefix =  CompanyGateway::CreateTempLinkTable($CompanyID,$CompanyGatewayID);


        $VOS_LOCATION = CompanyConfiguration::get($CompanyID,'VOS_LOCATION');
        try {
            $start_time = date('Y-m-d H:i:s');
            Log::info("Start");
            /** get process file make them pending*/
            UsageDownloadFiles::UpdateProcessToPending($CompanyID,$CompanyGatewayID,$CronJob,$cronsetting);

            /** get pending files */
            $filenames = UsageDownloadFiles::getVosPendingFile($CompanyGatewayID);

            /** remove last downloaded */
            //$lastelse = array_pop($filenames);

            Log::info("Files Names Collected");
            Log::error('   vos File Count ' . count($filenames));
            $file_count = 1;
            $RateFormat = Company::PREFIX;
            $RateCDR = $AutoAddIP = 0;

            $RerateAccounts = !empty($companysetting->Accounts) ? count($companysetting->Accounts) : 0;

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
            if(isset($companysetting->AutoAddIP) && $companysetting->AutoAddIP){
                $AutoAddIP = $companysetting->AutoAddIP;
            }
            TempUsageDetail::applyDiscountPlan();
            Log::error(' ========================== vos transaction start =============================');
            CronJob::createLog($CronJobID);

            $TimeZone = CompanyGateway::getGatewayTimeZone($CompanyGatewayID);
            if ($TimeZone != '') {
                date_default_timezone_set($TimeZone);
            } else {
                date_default_timezone_set('GMT'); // just to use e in date() function
            }
            $CallID = CompanyGateway::getCallID($CompanyID,$CompanyGatewayID);
            foreach ($filenames as $UsageDownloadFilesID => $filename) {
                Log::info("Loop Start");

                if ($filename != '' && $file_count <= $FilesMaxProccess) {

                    $param = array();
                    $param['filename'] = $filename;

                    Log::info("CDR Insert Start ".$filename." processID: ".$processID);

                    /** update file status to progress */
                    UsageDownloadFiles::UpdateFileStausToProcess($UsageDownloadFilesID,$processID);
                    $delete_files[] = $UsageDownloadFilesID;
                    $fullpath = $VOS_LOCATION.'/'.$CompanyGatewayID. '/' ;
                    try{
                    if (($handle = fopen($fullpath.$filename, "r")) !== FALSE) {
                        $InserData = $InserVData = array();
                        while (($excelrow = fgetcsv($handle)) !== FALSE) {
                            if ( ($IpBased == 0 && !empty($excelrow['33']) ) || ($IpBased ==1 && !empty($excelrow['4']))) {
                                $uddata = array();
                                $uddata['CompanyGatewayID'] = $CompanyGatewayID;
                                $uddata['CompanyID'] = $CompanyID;
                                if($IpBased){
                                    $uddata['GatewayAccountID'] = $excelrow['4'];
                                }else{
                                    $uddata['GatewayAccountID'] = $excelrow['33'];
                                }
                                $uddata['AccountIP'] = $excelrow['4'];
                                $uddata['AccountName'] = $excelrow['33'];
                                $uddata['AccountNumber'] = '';
                                $uddata['AccountCLI'] = '';
                                $uddata['connect_time'] = date('Y-m-d H:i:s', ($excelrow['19']) / 1000);
                                $uddata['disconnect_time'] = date('Y-m-d H:i:s', ($excelrow['20']) / 1000);
                                $uddata['cost'] = (float)$excelrow['26'];
                                $uddata['cld'] = apply_translation_rule($CLDTranslationRule,$excelrow['3']);
                                $uddata['cli'] = apply_translation_rule($CLITranslationRule,$excelrow['1']);
                                $uddata['billed_duration'] = (int)$excelrow['25'];
                                $uddata['billed_second'] = (int)$excelrow['25'];
                                $uddata['duration'] = $excelrow['23'];
                                $uddata['trunk'] = 'Other';
                                $uddata['area_prefix'] = sippy_vos_areaprefix(apply_translation_rule($PrefixTranslationRule,$excelrow['24']),$RateCDR, $RerateAccounts);
                                $uddata['remote_ip'] = $excelrow['4'];
                                $uddata['ProcessID'] = $processID;
                                $uddata['ServiceID'] = $ServiceID;
                                $uddata['ID'] = $CallID;
                                $uddata['FileName'] = $filename;

                                $InserData[] = $uddata;
                                if($data_count > $insertLimit &&  !empty($InserData)){
                                    DB::connection('sqlsrvcdr')->table($temptableName)->insert($InserData);
                                    $InserData = array();
                                    $data_count = 0;
                                }
                            }
                            if (($IpBased == 0 &&  !empty($excelrow['40']) ) || ($IpBased ==1 && !empty($excelrow['10']))) {
                                $vendorcdrdata = array();
                                $vendorcdrdata['CompanyID'] = $CompanyID;
                                $vendorcdrdata['CompanyGatewayID'] = $CompanyGatewayID;
                                if($IpBased){
                                    $vendorcdrdata['GatewayAccountID'] = $excelrow['10'];
                                }else{
                                    $vendorcdrdata['GatewayAccountID'] = $excelrow['40'];
                                }
                                $vendorcdrdata['AccountIP'] = $excelrow['10'];
                                $vendorcdrdata['AccountName'] = $excelrow['40'];
                                $vendorcdrdata['AccountNumber'] = '';
                                $vendorcdrdata['AccountCLI'] = '';
                                $vendorcdrdata['billed_duration'] = (int)$excelrow['18'];
                                $vendorcdrdata['billed_second'] = (int)$excelrow['18'];
                                $vendorcdrdata['duration'] = $excelrow['23'];
                                $vendorcdrdata['buying_cost'] = (float)$excelrow['35'];
                                $vendorcdrdata['selling_cost'] = (float)$excelrow['26'];
                                $vendorcdrdata['connect_time'] = date('Y-m-d H:i:s', ($excelrow['19']) / 1000);
                                $vendorcdrdata['disconnect_time'] = date('Y-m-d H:i:s', ($excelrow['20']) / 1000);
                                $vendorcdrdata['cli'] = apply_translation_rule($CLITranslationRule,$excelrow['1']);
                                $vendorcdrdata['cld'] = apply_translation_rule($CLDTranslationRule,$excelrow['14']);
                                $vendorcdrdata['trunk'] = 'Other';
                                $vendorcdrdata['area_prefix'] = sippy_vos_areaprefix(apply_translation_rule($PrefixTranslationRule,$excelrow['34']),$RateCDR, $RerateAccounts);
                                $vendorcdrdata['remote_ip'] = $excelrow['10'];
                                $vendorcdrdata['ProcessID'] = $processID;
                                $vendorcdrdata['ServiceID'] = $ServiceID;
                                $vendorcdrdata['ID'] = $CallID;
                                $vendorcdrdata['FileName'] = $filename;

                                $InserVData[] = $vendorcdrdata;
                                if($data_countv > $insertLimit &&  !empty($InserVData)){
                                    DB::connection('sqlsrvcdr')->table($tempVendortable)->insert($InserVData);
                                    $InserVData = array();
                                    $data_countv =0;
                                }
                            }
                            $data_count++;
                            $data_countv++;
                            $CallID++;

                        }//loop

                        if(!empty($InserData)){
                            DB::connection('sqlsrvcdr')->table($temptableName)->insert($InserData);

                        }
                        if(!empty($InserVData)){
                            DB::connection('sqlsrvcdr')->table($tempVendortable)->insert($InserVData);
                        }

                        fclose($handle);
                    }
                    }catch(Exception $e){

                        Log::error($e);
                        /** update file status to error */
                        UsageDownloadFiles::UpdateFileStatusToError($CompanyID,$cronsetting,$CronJob->JobTitle,$UsageDownloadFilesID,$e->getMessage());
                    }

                    Log::info("CDR Insert END");
                    $file_count++;
                } else {
                    break;
                }
                Log::info("Loop End");

            }
            CompanyGateway::setCallID($CompanyID,$CompanyGatewayID,$CallID);


            Log::error(' ========================== vos transaction end =============================');
            //ProcessCDR

            Log::info("ProcessCDR($CompanyID,$processID,$CompanyGatewayID,$RateCDR,$RateFormat)");
            TempVendorCDR::ProcessCDR($CompanyID,$processID,$CompanyGatewayID,$RateCDR,$RateFormat,$tempVendortable,'','CurrentRate',0,$RerateAccounts);
            $skiped_account_data = TempUsageDetail::ProcessCDR($CompanyID,$processID,$CompanyGatewayID,$RateCDR,$RateFormat,$temptableName,'','CurrentRate',0,0,0,$RerateAccounts);
            if (count($skiped_account_data)) {
                $joblogdata['Message'] .=  implode('<br>', $skiped_account_data);
            }

            //select   MAX(disconnect_time) as max_date,MIN(connect_time)  as min_date    from tblTempUsageDetail where ProcessID = p_ProcessID;
            $result = DB::connection('sqlsrv2')->select("CALL  prc_start_end_time( '" . $processID . "','" . $temptableName . "')");

            $totaldata_count = DB::connection('sqlsrvcdr')->table($temptableName)->where('ProcessID',$processID)->count();
            DB::connection('sqlsrv2')->beginTransaction();
            DB::connection('sqlsrvcdr')->beginTransaction();



            Log::error("VOS CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' ) start");
            DB::statement("CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' )");
            Log::error("Vos CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' ) end");

            Log::error('vos prc_insertCDR start'.$processID);
            DB::connection('sqlsrvcdr')->statement("CALL  prc_insertCDR ('" . $processID . "', '".$temptableName."' )");
            DB::connection('sqlsrvcdr')->statement("CALL  prc_insertVendorCDR ('" . $processID . "', '".$tempVendortable."')");
            Log::error('vos prc_insertCDR end');

            /*Log::error('vos prc_linkCDR end');
            DB::connection('sqlsrvcdr')->statement("CALL  prc_linkCDR ('" . $processID . "','".$tempLinkPrefix."')");
            Log::error('vos prc_linkCDR end');*/
            /** update file process to completed */
            UsageDownloadFiles::UpdateProcessToComplete( $delete_files);

            if (!empty($result[0]->min_date)) {
                $filedetail = '<br>From' . date('Y-m-d H:i:00', strtotime($result[0]->min_date)) . ' To ' . date('Y-m-d H:i:00', strtotime($result[0]->max_date)) .' count '. $totaldata_count;
                date_default_timezone_set(Config::get('app.timezone'));
                $logdata['CompanyGatewayID'] = $CompanyGatewayID;
                $logdata['CompanyID'] = $CompanyID;
                $logdata['start_time'] = $result[0]->min_date;
                $logdata['end_time'] = $result[0]->max_date;
                $logdata['created_at'] = date('Y-m-d H:i:s');
                $logdata['ProcessID'] = $processID;
                TempUsageDownloadLog::insert($logdata);

            } else {
                $filedetail = '<br> No Data Found!!';
            }

            DB::connection('sqlsrvcdr')->commit();
            DB::connection('sqlsrv2')->commit();
            try {


                date_default_timezone_set(Config::get('app.timezone'));


                /**
                 * Not in use
                $CdrBehindData = array();
                if (!empty($result[0]->min_date) && !empty($cronsetting['ErrorEmail'])) {
                    $CdrBehindData['startdatetime'] = $result[0]->min_date;
                    CronJob::CheckCdrBehindDuration($CronJob, $CdrBehindData);
                }
                */

                $end_time = date('Y-m-d H:i:s');
                $joblogdata['Message'] .= $filedetail . ' <br/>' . time_elapsed($start_time, $end_time);
                $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;


                Log::error('vos delete file count ' . count($delete_files));

                DB::connection('sqlsrvcdr')->table($temptableName)->where(["processId" => $processID])->delete(); //TempUsageDetail::where(["processId" => $processID])->delete();
                //TempVendorCDR::where(["processId" => $processID])->delete();

                //Only for CDR Rerate ON.
                TempUsageDetail::GenerateLogAndSend($CompanyID, $CompanyGatewayID, $cronsetting, $skiped_account_data, $CronJob->JobTitle);
                if($AutoAddIP == 1) {
                    TempUsageDetail::AutoAddIPLog($CompanyID, $CompanyGatewayID);
                }
            }catch(Exception $e){
                Log::error($e);
            }

        } catch (Exception $e) {
            try {
                DB::connection('sqlsrvcdr')->rollback();
            } catch (Exception $err) {
                Log::error($err);
            }
            try {
                /** put back file to pending if any error occurred */
                UsageDownloadFiles::UpdateToPending($delete_files);

            } catch (Exception $err) {
                Log::error($err);
            }
            // delete temp table if process fail
            try {
                DB::connection('sqlsrvcdr')->table($temptableName)->where(["processId" => $processID])->delete();
                //TempUsageDetail::where(["processId" => $processID])->delete();
                //TempVendorCDR::where(["processId" => $processID])->delete();
                //DB::connection('sqlsrvcdr')->statement("  DELETE FROM tblTempUsageDetail WHERE ProcessID = '".$processID."'");
            } catch (\Exception $err) {
                Log::error($err);
            }

            Log::error($e);

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

}