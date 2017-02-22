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
use App\SippySSH;
use Exception;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;

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
    public function handle()
    {

        CronHelper::before_cronrun($this->name, $this );



        $arguments = $this->argument();
        $getmypid = getmypid(); // get proccess id
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
        $IpBased = ($companysetting->NameFormat == 'IP') ? 1 : 0;
        $dataactive['Active'] = 1;
        $dataactive['LastRunTime'] = date('Y-m-d H:i:00');
        $dataactive['PID'] = $getmypid;
        $CronJob->update($dataactive);
        $processID = CompanyGateway::getProcessID();
        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';
        $joblogdata['Message'] = '';
        $delete_files = $vdelete_files = array();
        $temptableName = CompanyGateway::CreateIfNotExistCDRTempUsageDetailTable($CompanyID,$CompanyGatewayID);
        $tempVendortable =  CompanyGateway::CreateVendorTempTable($CompanyID,$CompanyGatewayID);

        Log::useFiles(storage_path() . '/logs/sippyaccountusage-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');
        $SIPPYFILE_LOCATION = CompanyConfiguration::get($CompanyID,'SIPPYFILE_LOCATION');
        try {
            $start_time = date('Y-m-d H:i:s');
            Log::info("Start");
            /** get process file make them pending*/
            UsageDownloadFiles::UpdateProcessToPending($CompanyID,$CompanyGatewayID,$CronJob,$cronsetting);

            /** get pending files */
            $filenames = UsageDownloadFiles::getSippyPendingFile($CompanyGatewayID,SippySSH::$customer_cdr_file_name);
            $vfilenames = UsageDownloadFiles::getSippyPendingFile($CompanyGatewayID,SippySSH::$vendor_cdr_file_name);

            $lastelse = array_pop($filenames);
            $lastelse = array_pop($vfilenames);

            Log::info("Files Names Collected");
            Log::error('   sippy File Count ' . count($filenames));
            $file_count = 1;
            $RateFormat = Company::PREFIX;
            $RateCDR = 0;
            $ServiceID = 0;
            if(isset($companysetting->ServiceType) && $companysetting->ServiceType){
                $ServiceID = Service::getServiceID($CompanyID,$companysetting->ServiceType);
            }
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
                TempUsageDetail::applyDiscountPlan($ServiceID);
            }

            Log::error(' ========================== sippy transaction start =============================');
            CronJob::createLog($CronJobID);

            $TimeZone = CompanyGateway::getGatewayTimeZone($CompanyGatewayID);
            if ($TimeZone != '') {
                date_default_timezone_set($TimeZone);
            } else {
                date_default_timezone_set('GMT'); // just to use e in date() function
            }
            /**
             * Insert Customer CDR to temp table
             */
            foreach ($filenames as $UsageDownloadFilesID => $filename) {
                Log::info("Loop Start" . SippySSH::get_file_datetime($filename));

                if ($filename != '' && $file_count <= $FilesMaxProccess) {

                    $param = array();
                    $param['filename'] = $filename;

                    Log::info("CDR Insert Start ".$filename." processID: ".$processID);

                    $fullpath = $SIPPYFILE_LOCATION.'/'.$CompanyGatewayID. '/' ;
                    $csv_response = SippySSH::get_customer_file_content($fullpath.$filename,$CompanyID);
                    if ( isset($csv_response["return_var"]) &&  $csv_response["return_var"] == 0 && isset($csv_response["output"]) && count($csv_response["output"]) > 0  ) {
                        $delete_files[] = $UsageDownloadFilesID;
                        /** update file status to progress */
                        UsageDownloadFiles::UpdateFileStausToProcess($UsageDownloadFilesID,$processID);
                        $cdr_rows = $csv_response["output"];
                        $InserData = $InserVData = array();
                        foreach($cdr_rows as $cdr_row){

                            if (!empty($cdr_row['i_account']) || ($IpBased ==1 && !empty($cdr_row['remote_ip']))) {

                                $uddata = array();
                                $uddata['CompanyGatewayID'] = $CompanyGatewayID;
                                $uddata['CompanyID'] = $CompanyID;
                                if($IpBased){
                                    $uddata['GatewayAccountID'] = $cdr_row['remote_ip'];
                                }else{
                                    $uddata['GatewayAccountID'] = $cdr_row['i_account'];
                                }
                                $uddata['connect_time'] = gmdate('Y-m-d H:i:s', $cdr_row['connect_time']);
                                $uddata['disconnect_time'] = gmdate('Y-m-d H:i:s', $cdr_row['disconnect_time']);
                                $uddata['cost'] = (float)$cdr_row['cost'];
                                $uddata['cld'] = apply_translation_rule($CLDTranslationRule,$cdr_row['cld_in']);
                                $uddata['cli'] = apply_translation_rule($CLITranslationRule,$cdr_row['cli_in']);
                                $uddata['billed_duration'] = $cdr_row['billed_duration'];
                                $uddata['duration'] = $cdr_row['billed_duration'];
                                $uddata['billed_second'] = $cdr_row['billed_duration'];
                                $uddata['trunk'] = 'Other';
                                $uddata['area_prefix'] = sippy_vos_areaprefix(apply_translation_rule($CLDTranslationRule,$cdr_row['prefix']),$RateCDR);
                                $uddata['remote_ip'] = $cdr_row['remote_ip'];
                                $uddata['ProcessID'] = $processID;
                                $uddata['ServiceID'] = $ServiceID;

                                $InserData[] = $uddata;
                                if($data_count > $insertLimit &&  !empty($InserData)){
                                    DB::connection('sqlsrvcdrazure')->table($temptableName)->insert($InserData);
                                    $InserData = array();
                                    $data_count = 0;
                                }
                            }

                            $data_count++;


                        }//loop

                        if(!empty($InserData)){
                            DB::connection('sqlsrvcdrazure')->table($temptableName)->insert($InserData);

                        }

                    } else {

                        $return_var = isset($csv_response["return_var"])?$csv_response["return_var"]:"";
                        Log::error("Error Reading Sippy Customer Encoded File. " . $return_var);
                        /** update file status to error */
                        UsageDownloadFiles::UpdateFileStatusToError($CompanyID,$cronsetting,$CronJob->JobTitle,$UsageDownloadFilesID,$return_var);

                    }


                    Log::info("CDR Insert END");
                    $file_count++;
                } else {
                    break;
                }
                Log::info("Loop End");

            } // Customer cdr over.


            /**
             * Insert Vendor CDRs to Temp table
             *
             */
            $file_count = 1;
            $data_count = 0;
            foreach ($vfilenames as $UsageDownloadFilesID => $filename) {
                Log::info("Loop Start");

                if ($filename != '' && $file_count <= $FilesMaxProccess) {

                    $param = array();
                    $param['filename'] = $filename;

                    Log::info("VCDR Insert Start ".$filename." processID: ".$processID);


                    $fullpath = $SIPPYFILE_LOCATION.'/'.$CompanyGatewayID. '/' ;
                    $csv_response = SippySSH::get_vendor_file_content($fullpath.$filename,$CompanyID);


                    if ( isset($csv_response["return_var"]) &&  $csv_response["return_var"] == 0 && isset($csv_response["output"]) && count($csv_response["output"]) > 0  ) {
                        /** update file status to progress */
                        UsageDownloadFiles::UpdateFileStausToProcess($UsageDownloadFilesID,$processID);
                        $vdelete_files[] = $UsageDownloadFilesID;
                        $cdr_rows = $csv_response["output"];
                        $InserData = $InserVData = array();
                        foreach($cdr_rows as $cdr_row){

                            if (!empty($cdr_row['i_account_debug']) || ($IpBased ==1 && !empty($cdr_row['remote_ip']))) {

                                $uddata = array();
                                $uddata['CompanyGatewayID'] = $CompanyGatewayID;
                                $uddata['CompanyID'] = $CompanyID;
                                if($IpBased){
                                    $uddata['GatewayAccountID'] = $cdr_row['remote_ip'];
                                }else{
                                    $uddata['GatewayAccountID'] = $cdr_row['i_account_debug'];
                                }
                                $uddata['connect_time'] = gmdate('Y-m-d H:i:s', $cdr_row['connect_time']);
                                $uddata['disconnect_time'] = gmdate('Y-m-d H:i:s', $cdr_row['disconnect_time']);
                                //$uddata['selling_cost'] = 0; // # is provided only in the cdrs table
                                $uddata['buying_cost'] = (float)$cdr_row['cost'];
                                $uddata['cld'] = apply_translation_rule($CLDTranslationRule, $cdr_row['cld_out']);
                                $uddata['cli'] = apply_translation_rule($CLITranslationRule,$cdr_row['cli_out']);
                                $uddata['billed_duration'] = $cdr_row['billed_duration'];
                                $uddata['duration'] = $cdr_row['billed_duration'];
                                $uddata['billed_second'] = $cdr_row['billed_duration'];
                                $uddata['trunk'] = 'Other';
                                $uddata['area_prefix'] = sippy_vos_areaprefix(apply_translation_rule($CLDTranslationRule,$cdr_row['prefix']),$RateCDR);
                                $uddata['remote_ip'] = $cdr_row['remote_ip'];
                                $uddata['ProcessID'] = $processID;
                                $uddata['ServiceID'] = $ServiceID;

                                $InserVData[] = $uddata;
                                if($data_count > $insertLimit &&  !empty($InserVData)){
                                    DB::connection('sqlsrvcdrazure')->table($tempVendortable)->insert($InserVData);
                                    $InserVData = array();
                                    $data_count = 0;
                                }
                            }

                            $data_count++;


                        }//loop

                        if(!empty($InserData)){
                            DB::connection('sqlsrvcdrazure')->table($temptableName)->insert($InserData);

                        }
                        if(!empty($InserVData)){
                            DB::connection('sqlsrvcdrazure')->table($tempVendortable)->insert($InserVData);
                        }


                    } else {

                        $return_var = isset($csv_response["return_var"])?$csv_response["return_var"]:"";
                        Log::error("Error Reading Sippy Vendor Encoded File. " . $return_var);
                        /** update file status to error */
                        UsageDownloadFiles::UpdateFileStatusToError($CompanyID,$cronsetting,$CronJob->JobTitle,$UsageDownloadFilesID,$return_var);

                    }


                    Log::info("CDR Insert END");
                    $file_count++;
                } else {
                    break;
                }
                Log::info("Loop End");

            } // Vendor cdr over


            Log::error(' ========================== sippy transaction end =============================');
            $totaldata_count = DB::connection('sqlsrvcdrazure')->table($temptableName)->where('ProcessID',$processID)->count();
            $vtotaldata_count = DB::connection('sqlsrvcdrazure')->table($tempVendortable)->where('ProcessID',$processID)->count();

            //ProcessCDR

            Log::info("ProcessCDR($CompanyID,$processID,$CompanyGatewayID,$RateCDR,$RateFormat)");
            TempVendorCDR::ProcessCDR($CompanyID,$processID,$CompanyGatewayID,$RateCDR,$RateFormat,$tempVendortable);
            $skiped_account_data = TempUsageDetail::ProcessCDR($CompanyID,$processID,$CompanyGatewayID,$RateCDR,$RateFormat,$temptableName);
            if (count($skiped_account_data)) {
                $joblogdata['Message'] .= implode('<br>', $skiped_account_data);
            }

            //select   MAX(disconnect_time) as max_date,MIN(connect_time)  as min_date    from tblTempUsageDetail where ProcessID = p_ProcessID;
            $result = DB::connection('sqlsrv2')->select("CALL  prc_start_end_time( '" . $processID . "','" . $temptableName . "')");
            $vresult = DB::connection('sqlsrv2')->select("CALL  prc_start_end_time( '" . $processID . "','" . $tempVendortable. "')");


            DB::connection('sqlsrv2')->beginTransaction();
            DB::connection('sqlsrvcdrazure')->beginTransaction();

            $filedetail = "";
            if (!empty($vresult[0]->min_date)) {
                $filedetail .= '<br>Vendor From' . date('Y-m-d H:i:00', strtotime($vresult[0]->min_date)) . ' To ' . date('Y-m-d H:i:00', strtotime($vresult[0]->max_date)) .' count '. $vtotaldata_count;
            }else{
                $filedetail .= '<br> No VendorCDR Data Found!!';
            }
            if (!empty($result[0]->min_date)) {
                $filedetail .= '<br>Customer From' . date('Y-m-d H:i:00', strtotime($result[0]->min_date)) . ' To ' . date('Y-m-d H:i:00', strtotime($result[0]->max_date)) .' count '. $totaldata_count;
                date_default_timezone_set(Config::get('app.timezone'));
                $logdata['CompanyGatewayID'] = $CompanyGatewayID;
                $logdata['CompanyID'] = $CompanyID;
                $logdata['start_time'] = $result[0]->min_date;
                $logdata['end_time'] = $result[0]->max_date;
                $logdata['created_at'] = date('Y-m-d H:i:s');
                $logdata['ProcessID'] = $processID;
                TempUsageDownloadLog::insert($logdata);

            } else {
                $filedetail .= '<br> No CustomerCDR Data Found!!';
            }

            if($RateCDR == 0) {
                Log::error("Porta CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' ) start");
                DB::statement("CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' )");
                Log::error("Porta CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' ) end");
            }
            Log::error('sippy prc_insertCDR start'.$processID);
            DB::connection('sqlsrvcdrazure')->statement("CALL  prc_insertCDR ('" . $processID . "', '".$temptableName."' )");
            DB::connection('sqlsrvcdrazure')->statement("CALL  prc_insertVendorCDR ('" . $processID . "', '".$tempVendortable."')");
            Log::error('sippy prc_insertCDR end');
            /** update file process to completed */
            UsageDownloadFiles::UpdateProcessToComplete( $delete_files);

            /** update vendor file process to completed */
            UsageDownloadFiles::UpdateProcessToComplete( $vdelete_files);

            DB::connection('sqlsrvcdrazure')->commit();
            DB::connection('sqlsrv2')->commit();
            try {


                date_default_timezone_set(Config::get('app.timezone'));

                /**
                 * Not in Use
                 * $CdrBehindData = array();
                if (!empty($result[0]->min_date) && !empty($cronsetting['ErrorEmail'])) {
                    $CdrBehindData['startdatetime'] = $result[0]->min_date;
                    CronJob::CheckCdrBehindDuration($CronJob, $CdrBehindData);
                }
                 */

                $end_time = date('Y-m-d H:i:s');
                $joblogdata['Message'] .= $filedetail . ' <br/>' . time_elapsed($start_time, $end_time);
                $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
                CronJobLog::insert($joblogdata);

                Log::error('sippy delete file count ' . count($delete_files));

                DB::connection('sqlsrvcdrazure')->table($temptableName)->where(["processId" => $processID])->delete(); //TempUsageDetail::where(["processId" => $processID])->delete();
                DB::connection('sqlsrvcdrazure')->table($tempVendortable)->where(["processId" => $processID])->delete(); //TempUsageDetail::where(["processId" => $processID])->delete();
                //TempVendorCDR::where(["processId" => $processID])->delete();

                //Only for CDR Rerate ON.
                TempUsageDetail::GenerateLogAndSend($CompanyID, $CompanyGatewayID, $cronsetting, $skiped_account_data, $CronJob->JobTitle);
            }catch(Exception $e){
                Log::error($e);
            }

        } catch (Exception $e) {
            try {
                DB::connection('sqlsrvcdrazure')->rollback();
            } catch (Exception $err) {
                Log::error($err);
            }
            try {
                // Rename files to complete or delete
                /** put back file to pending if any error occurred */
                UsageDownloadFiles::UpdateToPending($delete_files);
                /** put back file to pending if any error occurred */
                UsageDownloadFiles::UpdateToPending($vdelete_files);

            } catch (Exception $err) {
                Log::error($err);
            }
            // delete temp table if process fail
            try {
                DB::connection('sqlsrvcdrazure')->table($temptableName)->where(["processId" => $processID])->delete();
                DB::connection('sqlsrvcdrazure')->table($tempVendortable)->where(["processId" => $processID])->delete();

            } catch (\Exception $err) {
                Log::error($err);
            }

            Log::error($e);

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

        CronHelper::after_cronrun($this->name, $this);

    }

}