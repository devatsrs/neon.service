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

class HUAWEIAccountUsage extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'huaweiaccountusage';

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
        Log::useFiles(storage_path() . '/logs/huaweiaccountusage-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');
        $IpBased = ($companysetting->NameFormat == 'IP') ? 1 : 0;
        CronJob::activateCronJob($CronJob);
        CronJob::createLog($CronJobID);
        $processID = CompanyGateway::getProcessID();
        //  CompanyGateway::updateProcessID($CronJob,$processID);
        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';
        $joblogdata['Message'] = '';
        $delete_files = array();
        $temptableName = CompanyGateway::CreateIfNotExistCDRTempUsageDetailTable($CompanyID,$CompanyGatewayID);
        $tempVendortable =  CompanyGateway::CreateVendorTempTable($CompanyID,$CompanyGatewayID);
        //$tempLinkPrefix =  CompanyGateway::CreateTempLinkTable($CompanyID,$CompanyGatewayID);

        $HUAWEI_LOCATION = CompanyConfiguration::get($CompanyID,'HUAWEI_LOCATION');
        $HUAWEI_CSV_LOCATION = CompanyConfiguration::get($CompanyID,'HUAWEI_CSV_LOCATION');
        $destination = $HUAWEI_CSV_LOCATION .'/'.$CompanyGatewayID;
        if (!file_exists($destination)) {
            mkdir($destination, 0777, true);
        }
        try {
            $start_time = date('Y-m-d H:i:s');
            Log::info("Start");
            /** get process file make them pending*/
            UsageDownloadFiles::UpdateProcessToPending($CompanyID,$CompanyGatewayID,$CronJob,$cronsetting);

            /** get pending files */
            $filenames = UsageDownloadFiles::getHuaweiPendingFile($CompanyGatewayID);
            $csv_filenames = array();
            if(count($filenames) > 0)
            {
                foreach($filenames as $k => $v)
                {
                    $tmpfn = explode(".",$v);
                    $command = "huawei_parser ".$HUAWEI_LOCATION."/".$CompanyGatewayID."/".$v ." ". $destination."/".$tmpfn[0].".csv";
                    //log::info('command '.$command);
                    $csv_filenames[$k] =  $tmpfn[0].".csv";
                    $output = trim(shell_exec($command));
                }
            }
            //Log::info("Files Names".print_r($csv_filenames,true));
            /** remove last downloaded */
            //$lastelse = array_pop($filenames);

            Log::info("Files Names Collected");
            Log::error('   Huawei File Count ' . count($filenames));
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
            Log::error(' ========================== huawei transaction start =============================');
            CronJob::createLog($CronJobID);

            $TimeZone = CompanyGateway::getGatewayTimeZone($CompanyGatewayID);
            if ($TimeZone != '') {
                date_default_timezone_set($TimeZone);
            } else {
                date_default_timezone_set('GMT'); // just to use e in date() function
            }
            $CallID = CompanyGateway::getHuaweiCallID($CompanyID,$CompanyGatewayID);
            foreach ($csv_filenames as $UsageDownloadFilesID => $filename) {
                Log::info("Loop Start");

                if ($filename != '' && $file_count <= $FilesMaxProccess) {

                    $param = array();
                    $param['filename'] = $filename;

                    Log::info("CDR Insert Start ".$filename." processID: ".$processID);

                    /** update file status to progress */
                    UsageDownloadFiles::UpdateFileStausToProcess($UsageDownloadFilesID,$processID);
                    $delete_files[] = $UsageDownloadFilesID;
                    $fullpath = $HUAWEI_CSV_LOCATION.'/'.$CompanyGatewayID. '/' ;

                    try{
                        if (($handle = fopen($fullpath.$filename, "r")) !== FALSE) {
                            $InserData = $InserVData = array();
                            //for skiping first row
                            fgetcsv($handle);
                            while (($excelrow = fgetcsv($handle)) !== FALSE) {
                                //Log::info("file2".print_R($excelrow,true));
                                if (!empty($excelrow['9'])) {

                                    $uddata = array();
                                    $uddata['CompanyGatewayID'] = $CompanyGatewayID;
                                    $uddata['CompanyID'] = $CompanyID;
                                    if($IpBased){
                                        $uddata['GatewayAccountID'] = $excelrow['9'];
                                    }else{
                                        $uddata['GatewayAccountID'] = $excelrow['9'];
                                    }

                                    $uddata['AccountIP'] = $excelrow['9'];
                                    $uddata['AccountName'] = $excelrow['9'];
                                    $uddata['AccountNumber'] = '';
                                    $uddata['AccountCLI'] = '';
                                    $uddata['disconnect_time'] = $this->ConvertDateTime($excelrow['5']);

                                    //getting connect time using disconnect_time - duration
                                    $tmpcontime = strtotime($uddata['disconnect_time']) - $excelrow['6'];
                                    $uddata['connect_time'] = date('Y-m-d H:i:s',$tmpcontime);

                                    //$uddata['cost'] = (float)$excelrow['26'];
                                    $uddata['cost'] = 0;
                                    $uddata['cld'] = apply_translation_rule($CLDTranslationRule,$excelrow['22']);
                                    $uddata['cli'] = apply_translation_rule($CLITranslationRule,$excelrow['3']);
                                    $uddata['billed_duration'] = $excelrow['6'];
                                    $uddata['billed_second'] = $excelrow['6'];
                                    $uddata['duration'] = $excelrow['6'];
                                    $uddata['trunk'] = 'Other';
                                    $uddata['area_prefix'] = '';
                                    $uddata['remote_ip'] = $excelrow['9'];
                                    $uddata['ProcessID'] = $processID;
                                    $uddata['ServiceID'] = $ServiceID;
                                    $uddata['ID'] = $CallID;
                                    $uddata['caller_address_nature'] = $excelrow['4'];
                                    $uddata['called_address_nature'] = $excelrow['8'];
                                    $uddata['alert_time'] = $this->ConvertDateTime($excelrow['36']);
                                    $uddata['trunk_group_in'] = $excelrow['9'];
                                    $uddata['trunk_group_out'] = $excelrow['11'];
                                    $uddata['caller_trunk_cic'] = $excelrow['10'];
                                    $uddata['called_trunk_cic'] = $excelrow['12'];
                                    $uddata['connected_number'] = $excelrow['25'];
                                    $uddata['connected_address_nature'] = $excelrow['26'];
                                    $uddata['caller_call_id'] = $excelrow['33'];
                                    $uddata['called_call_id'] = $excelrow['34'];
                                    $uddata['global_call_ref'] = $excelrow['20'];
                                    $uddata['connection_id'] = $excelrow['13'];
                                    $uddata['audio_codec_type'] = $excelrow['37'];
                                    $uddata['FileName'] = $filename;

                                    $InserData[] = $uddata;
                                    if($data_count > $insertLimit &&  !empty($InserData)){
                                        DB::connection('sqlsrvcdr')->table($temptableName)->insert($InserData);
                                        $InserData = array();
                                        $data_count = 0;
                                    }

                                }
                                if (!empty($excelrow['11'])) {

                                    $vendorcdrdata = array();
                                    $vendorcdrdata['CompanyID'] = $CompanyID;
                                    $vendorcdrdata['CompanyGatewayID'] = $CompanyGatewayID;
                                    if($IpBased){
                                        $vendorcdrdata['GatewayAccountID'] = $excelrow['11'];
                                    }else{
                                        $vendorcdrdata['GatewayAccountID'] = $excelrow['11'];
                                    }
                                    $vendorcdrdata['AccountIP'] = $excelrow['11'];
                                    $vendorcdrdata['AccountName'] = $excelrow['11'];
                                    $vendorcdrdata['AccountNumber'] = '';
                                    $vendorcdrdata['AccountCLI'] = '';
                                    $vendorcdrdata['billed_duration'] = $excelrow['6'];
                                    $vendorcdrdata['billed_second'] = $excelrow['6'];
                                    $vendorcdrdata['duration'] = $excelrow['6'];
                                    $vendorcdrdata['buying_cost'] = 0;
                                    $vendorcdrdata['selling_cost'] = '';
                                    $vendorcdrdata['disconnect_time'] = $this->ConvertDateTime($excelrow['5']);

                                    //getting connect time using disconnect_time - duration
                                    $tmpcontime = strtotime($vendorcdrdata['disconnect_time']) - $excelrow['6'];
                                    $vendorcdrdata['connect_time'] = date('Y-m-d H:i:s',$tmpcontime);

                                    $vendorcdrdata['cld'] = apply_translation_rule($CLDTranslationRule,$excelrow['22']);
                                    $vendorcdrdata['cli'] = apply_translation_rule($CLITranslationRule,$excelrow['3']);
                                    $vendorcdrdata['trunk'] = 'Other';
                                    $vendorcdrdata['area_prefix'] = '';
                                    $vendorcdrdata['remote_ip'] = $excelrow['11'];
                                    $vendorcdrdata['ProcessID'] = $processID;
                                    $vendorcdrdata['ServiceID'] = $ServiceID;
                                    $vendorcdrdata['ID'] = $CallID;
                                    $vendorcdrdata['caller_address_nature'] = $excelrow['4'];
                                    $vendorcdrdata['called_address_nature'] = $excelrow['8'];
                                    $vendorcdrdata['alert_time'] = $this->ConvertDateTime($excelrow['36']);
                                    $vendorcdrdata['trunk_group_in'] = $excelrow['9'];
                                    $vendorcdrdata['trunk_group_out'] = $excelrow['11'];
                                    $vendorcdrdata['caller_trunk_cic'] = $excelrow['10'];
                                    $vendorcdrdata['called_trunk_cic'] = $excelrow['12'];
                                    $vendorcdrdata['connected_number'] = $excelrow['25'];
                                    $vendorcdrdata['connected_address_nature'] = $excelrow['26'];
                                    $vendorcdrdata['caller_call_id'] = $excelrow['33'];
                                    $vendorcdrdata['called_call_id'] = $excelrow['34'];
                                    $vendorcdrdata['global_call_ref'] = $excelrow['20'];
                                    $vendorcdrdata['connection_id'] = $excelrow['13'];
                                    $vendorcdrdata['audio_codec_type'] = $excelrow['37'];
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
            CompanyGateway::setHuaweiCallID($CompanyID,$CompanyGatewayID,$CallID);


            Log::error(' ========================== huawei transaction end =============================');
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

    public function ConvertDateTime($date){

        $tmpdiscontime = explode(" ",$date);
        $ampm_var = $tmpdiscontime[2];
        array_pop($tmpdiscontime);
        $discontime = implode(" ",$tmpdiscontime);
        $tmptime = date('Y-m-d H:i:s',strtotime($discontime));
        $tmpbs = $tmptime ." ". $ampm_var;
        $finaldatetime = date('Y-m-d H:i:s',strtotime($tmpbs));
        //$con_time = strtotime($tmp) - 1800.0;
        //echo $con_time = date('Y-m-d H:i:s',$con_time);
        return $finaldatetime;

    }

}