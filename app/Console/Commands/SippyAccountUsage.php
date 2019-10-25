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
use App\Lib\SippyImporter;
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
        $CronJobID = $arguments["CronJobID"];
        $CompanyID = $arguments["CompanyID"];
        $CronJob = CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings, true);
        if(isset($cronsetting['FilesMaxProccess']) && $cronsetting['FilesMaxProccess'] > 0){
            $FilesMaxProccess = $cronsetting['FilesMaxProccess'];
        }else{
            $FilesMaxProccess = '30';
        }


        $insertLimit = 1000;


        $CompanyGatewayID = $cronsetting['CompanyGatewayID'];
        $companysetting = json_decode(CompanyGateway::getCompanyGatewayConfig($CompanyGatewayID));
        $ServiceID = (int)Service::getGatewayServiceID($CompanyGatewayID);
        Log::useFiles(storage_path() . '/logs/sippyaccountusage-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');
        $IpBased = ($companysetting->NameFormat == 'IP') ? 1 : 0;
        CronJob::activateCronJob($CronJob);
        CronJob::createLog($CronJobID);

        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';
        $joblogdata['Message'] = '';
        $delete_files = $vdelete_files = array();
        $temptableName = CompanyGateway::CreateIfNotExistCDRTempUsageDetailTable($CompanyID,$CompanyGatewayID);
        $tempVendortable =  CompanyGateway::CreateVendorTempTable($CompanyID,$CompanyGatewayID);
        //$tempLinkPrefix =  CompanyGateway::CreateTempLinkTable($CompanyID,$CompanyGatewayID);

        $SIPPYFILE_LOCATION = CompanyConfiguration::get($CompanyID,'SIPPYFILE_LOCATION');
        try {
            $processID = CompanyGateway::getProcessID();
            CompanyGateway::updateProcessID($CronJob,$processID);
            $start_time = date('Y-m-d H:i:s');
            Log::info("Start");
            /** get process file make them pending*/
            UsageDownloadFiles::UpdateProcessToPending($CompanyID,$CompanyGatewayID,$CronJob,$cronsetting);

            /** get pending files */
            $filenames = UsageDownloadFiles::getSippyPendingFile($CompanyGatewayID,$FilesMaxProccess);
            //$vfilenames = UsageDownloadFiles::getSippyPendingFile($CompanyGatewayID,SippySSH::$vendor_cdr_file_name);

            //$lastelse = array_pop($filenames);
            //$lastelse = array_pop($vfilenames);

            Log::info("Files Names Collected");
            Log::error('   sippy File Count ' . count($filenames));

            $RerateAccounts = !empty($companysetting->Accounts) ? count($companysetting->Accounts) : 0;

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

            Log::error(' ========================== sippy transaction start =============================');


            $TimeZone = CompanyGateway::getGatewayTimeZone($CompanyGatewayID);
            if ($TimeZone != '') {
                date_default_timezone_set($TimeZone);
            } else {
                date_default_timezone_set('GMT'); // just to use e in date() function
            }


            try{

                $this->createAccountJobLog($CompanyID,$CompanyGatewayID);

            } catch (Exception $ex ) {
                Log::error($ex);
            }

            foreach ($filenames as $time_key => $files) {
				foreach ($files as $UsageDownloadFilesID => $filename) {
                    Log::info("Loop Start" . SippySSH::get_file_datetime($filename));
                    /**
                     * Insert Customer CDR to temp table
                     */
                    if ($filename != '' && strpos($filename, SippySSH::$customer_cdr_file_name) !== false) {

                        $param = array();
                        $param['filename'] = $filename;

                        Log::info("CDR Insert Start " . $filename . " processID: " . $processID);

                        $fullpath = $SIPPYFILE_LOCATION . '/' . $CompanyGatewayID . '/';
                        $csv_response = SippySSH::get_customer_file_content($fullpath . $filename, $CompanyID);
                        if (isset($csv_response["return_var"]) && $csv_response["return_var"] == 0 && isset($csv_response["output"]) && count($csv_response["output"]) > 0) {
                            $delete_files[] = $UsageDownloadFilesID;
                            /** update file status to progress */
                            UsageDownloadFiles::UpdateFileStausToProcess($UsageDownloadFilesID, $processID);
                            $cdr_rows = $csv_response["output"];
                            $InserData = $InserVData = array();
                            $data_count = 0;
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
                                    $uddata['connect_time'] = gmdate('Y-m-d H:i:s', $cdr_row['connect_time']);
                                    $uddata['disconnect_time'] = gmdate('Y-m-d H:i:s', $cdr_row['disconnect_time']);
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
                                }

                                $data_count++;


                            }//loop

                            if (!empty($InserData)) {
                                DB::connection('sqlsrvcdr')->table($temptableName)->insert($InserData);

                            }

                        } else {

                            $return_var = isset($csv_response["return_var"]) ? $csv_response["return_var"] : "";
                            Log::error("Error Reading Sippy Customer Encoded File. " . $return_var);
                            /** update file status to error */
                            UsageDownloadFiles::UpdateFileStatusToError($CompanyID, $cronsetting, $CronJob->JobTitle, $UsageDownloadFilesID, $return_var);

                        }


                        Log::info("CDR Insert END");

                    }

                    /**
                     * Insert Vendor CDRs to Temp table
                     *
                     */
                    if ($filename != '' && strpos($filename, SippySSH::$vendor_cdr_file_name) !== false) {
                        Log::info("VCDR Insert Start ".$filename." processID: ".$processID);

                        $fullpath = $SIPPYFILE_LOCATION.'/'.$CompanyGatewayID. '/' ;
                        $csv_response = SippySSH::get_vendor_file_content($fullpath.$filename,$CompanyID);

                        if ( isset($csv_response["return_var"]) &&  $csv_response["return_var"] == 0 && isset($csv_response["output"]) && count($csv_response["output"]) > 0  ) {
                            /** update file status to progress */
                            UsageDownloadFiles::UpdateFileStausToProcess($UsageDownloadFilesID,$processID);
                            $vdelete_files[] = $UsageDownloadFilesID;
                            $cdr_rows = $csv_response["output"];
                            $InserData = $InserVData = array();
                            $data_count = 0;
                            foreach($cdr_rows as $cdr_row){

                                if (($IpBased ==0 && !empty($cdr_row['i_account_debug'])) || ($IpBased ==1 && !empty($cdr_row['remote_ip']))) {

                                    $uddata = array();
                                    $uddata['CompanyGatewayID'] = $CompanyGatewayID;
                                    $uddata['CompanyID'] = $CompanyID;
                                    if($IpBased){
                                        $uddata['GatewayAccountID'] = $cdr_row['remote_ip'];
                                    }else{
                                        $uddata['GatewayAccountID'] = $cdr_row['i_account_debug'];
                                    }
                                    $uddata['AccountIP'] = $cdr_row['remote_ip'];
                                    $uddata['AccountName'] = '';
                                    $uddata['AccountNumber'] = $cdr_row['i_account_debug'];
                                    $uddata['AccountCLI'] = '';
                                    $uddata['connect_time'] = gmdate('Y-m-d H:i:s', $cdr_row['call_setup_time']);
                                    $uddata['disconnect_time'] = gmdate('Y-m-d H:i:s', $cdr_row['disconnect_time']);
                                    $uddata['selling_cost'] = 0; // # is provided only in the cdrs table
                                    $uddata['buying_cost'] = (float)$cdr_row['cost'];
                                    $uddata['cld'] = apply_translation_rule($CLDTranslationRule, $cdr_row['cld_out']);
                                    $uddata['cli'] = apply_translation_rule($CLITranslationRule,$cdr_row['cli_out']);
                                    $uddata['billed_duration'] = $cdr_row['billed_duration'];
                                    $uddata['duration'] = $cdr_row['billed_duration'];
                                    $uddata['billed_second'] = $cdr_row['billed_duration'];
                                    $uddata['trunk'] = 'Other';
                                    $uddata['area_prefix'] = sippy_vos_areaprefix(apply_translation_rule($PrefixTranslationRule,$cdr_row['prefix']),$RateCDR, $RerateAccounts);
                                    $uddata['remote_ip'] = $cdr_row['remote_ip'];
                                    $uddata['ProcessID'] = $processID;
                                    $uddata['ServiceID'] = $ServiceID;
                                    $uddata['ID'] = $cdr_row['i_call'];

                                    $InserVData[] = $uddata;
                                    if($data_count > $insertLimit &&  !empty($InserVData)){
                                        DB::connection('sqlsrvcdr')->table($tempVendortable)->insert($InserVData);
                                        $InserVData = array();
                                        $data_count = 0;
                                    }
                                }

                                $data_count++;


                            }//loop

                            if(!empty($InserData)){
                                DB::connection('sqlsrvcdr')->table($temptableName)->insert($InserData);

                            }
                            if(!empty($InserVData)){
                                DB::connection('sqlsrvcdr')->table($tempVendortable)->insert($InserVData);
                            }


                        } else {

                            $return_var = isset($csv_response["return_var"])?$csv_response["return_var"]:"";
                            Log::error("Error Reading Sippy Vendor Encoded File. " . $return_var);
                            /** update file status to error */
                            UsageDownloadFiles::UpdateFileStatusToError($CompanyID,$cronsetting,$CronJob->JobTitle,$UsageDownloadFilesID,$return_var);

                        }


                        Log::info("vendor CDR Insert END");

                    }
                    Log::info("Loop End");

                }
            }







            Log::error(' ========================== sippy transaction end =============================');
            $totaldata_count = DB::connection('sqlsrvcdr')->table($temptableName)->where('ProcessID',$processID)->count();
            $vtotaldata_count = DB::connection('sqlsrvcdr')->table($tempVendortable)->where('ProcessID',$processID)->count();


            Log::info("sippy CALL  prc_updateSippyCustomerSetupTime ('" . $processID . "', '".$temptableName."','".$tempVendortable."' ) start");
            $rows_updated = DB::connection('sqlsrvcdr')->select("CALL  prc_updateSippyCustomerSetupTime ('" . $processID . "', '".$temptableName."','".$tempVendortable."' )");
            Log::info("sippy CALL  prc_updateSippyCustomerSetupTime ('" . $processID . "', '".$temptableName."','".$tempVendortable."' ) end");

            Log::info("prc_updateSippyCustomerSetupTime rows updated " . $rows_updated[0]->rows_updated);


            Log::info("sippy CALL  prc_updatVendorSellingCost ('" . $processID . "', '".$temptableName."','".$tempVendortable."' ) start");
            DB::connection('sqlsrvcdr')->statement("CALL  prc_updatVendorSellingCost ('" . $processID . "', '".$temptableName."','".$tempVendortable."' )");
            Log::info("sippy CALL  prc_updatVendorSellingCost ('" . $processID . "', '".$temptableName."','".$tempVendortable."' ) end");
            //ProcessCDR

            Log::info("ProcessCDR($CompanyID,$processID,$CompanyGatewayID,$RateCDR,$RateFormat)");
            TempVendorCDR::ProcessCDR($CompanyID,$processID,$CompanyGatewayID,$RateCDR,$RateFormat,$tempVendortable,'','CurrentRate',0,$RerateAccounts);
            $skiped_account_data = TempUsageDetail::ProcessCDR($CompanyID,$processID,$CompanyGatewayID,$RateCDR,$RateFormat,$temptableName,'','CurrentRate',0,0,0,$RerateAccounts);
            if (count($skiped_account_data)) {
                $joblogdata['Message'] .= implode('<br>', $skiped_account_data);
            }

            //select   MAX(disconnect_time) as max_date,MIN(connect_time)  as min_date    from tblTempUsageDetail where ProcessID = p_ProcessID;
            $result = DB::connection('sqlsrv2')->select("CALL  prc_start_end_time( '" . $processID . "','" . $temptableName . "')");
            $vresult = DB::connection('sqlsrv2')->select("CALL  prc_start_end_time( '" . $processID . "','" . $tempVendortable. "')");


            DB::connection('sqlsrv2')->beginTransaction();
            DB::connection('sqlsrvcdr')->beginTransaction();

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

            Log::error("Sippy CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' ) start");
            DB::statement("CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' )");
            Log::error("Sippy CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' ) end");

            Log::error('sippy prc_insertCDR start'.$processID);
            DB::connection('sqlsrvcdr')->statement("CALL  prc_insertCDR ('" . $processID . "', '".$temptableName."' )");
            DB::connection('sqlsrvcdr')->statement("CALL  prc_insertVendorCDR ('" . $processID . "', '".$tempVendortable."')");
            Log::error('sippy prc_insertCDR end');

            /*Log::error('sippy prc_linkCDR end');
            DB::connection('sqlsrvcdr')->statement("CALL  prc_linkCDR ('" . $processID . "','".$tempLinkPrefix."')");
            Log::error('sippy prc_linkCDR end');*/

            /** update file process to completed */
            UsageDownloadFiles::UpdateProcessToComplete( $delete_files);

            /** update vendor file process to completed */
            UsageDownloadFiles::UpdateProcessToComplete( $vdelete_files);

            DB::connection('sqlsrvcdr')->commit();
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


                Log::error('sippy delete file count ' . count($delete_files));

                DB::connection('sqlsrvcdr')->table($temptableName)->where(["processId" => $processID])->delete(); //TempUsageDetail::where(["processId" => $processID])->delete();
                DB::connection('sqlsrvcdr')->table($tempVendortable)->where(["processId" => $processID])->delete(); //TempUsageDetail::where(["processId" => $processID])->delete();
                //TempVendorCDR::where(["processId" => $processID])->delete();

                //Only for CDR Rerate ON.
                TempUsageDetail::GenerateLogAndSend($CompanyID, $CompanyGatewayID, $cronsetting, $skiped_account_data, $CronJob->JobTitle);
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
                DB::connection('sqlsrvcdr')->table($temptableName)->where(["processId" => $processID])->delete();
                DB::connection('sqlsrvcdr')->table($tempVendortable)->where(["processId" => $processID])->delete();

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