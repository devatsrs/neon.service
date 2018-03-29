<?php
/**
 * Created by PhpStorm.
 * User: srs2
 * Date: 25/05/2015
 * Time: 06:58
 */

namespace App\Console\Commands;


use App\FTPGateway;
use App\FTPSSH;
use App\Lib\Company;
use App\Lib\CompanyConfiguration;
use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\FileUploadTemplate;
use App\Lib\Service;
use App\Lib\TempUsageDetail;
use App\Lib\TempUsageDownloadLog;
use App\Lib\UsageDownloadFiles;
use App\SippySSH;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;
use \Exception;

class FTPAccountUsage extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'ftpaccountusage';

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
        $insertLimit = 1000;


        $CompanyGatewayID = $cronsetting['CompanyGatewayID'];
        $companysetting = json_decode(CompanyGateway::getCompanyGatewayConfig($CompanyGatewayID));
        $ServiceID = (int)Service::getGatewayServiceID($CompanyGatewayID);

        //Template for file mapping
        $uploadTemplate = FileUploadTemplate::where(['CompanyGatewayID'=>$CompanyGatewayID])->first();
        $templateoptions = json_decode($uploadTemplate->Options);
        $csvoption = $templateoptions->option;
        $attrselection = $templateoptions->selection;

        CronJob::activateCronJob($CronJob);
        CronJob::createLog($CronJobID);
        $processID = CompanyGateway::getProcessID();
        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';
        $joblogdata['Message'] = '';

        $delete_files = array();
        $temptableName = CompanyGateway::CreateIfNotExistCDRTempUsageDetailTable($CompanyID,$CompanyGatewayID);

        Log::useFiles(storage_path() . '/logs/ftpaccountusage-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');
        $FTP_LOCATION =  FTPGateway::getFileLocation($CompanyID);
        try {
            $start_time = date('Y-m-d H:i:s');
            Log::info("Start");
            /** get process file make them pending*/
            UsageDownloadFiles::UpdateProcessToPending($CompanyID,$CompanyGatewayID,$CronJob,$cronsetting);

            /** get pending files */
            $filenames = UsageDownloadFiles::getFTPGatewayPendingFile($CompanyGatewayID);

            /** remove last downloaded */
            $lastelse = array_pop($filenames);

            Log::info("Files Names Collected");
            Log::error('   ftp File Count ' . count($filenames));
            $file_count = 1;
            $RateCDR = 0;
            $RerateAccounts = 0;
            if(isset($companysetting->RateCDR) && $companysetting->RateCDR){
                $RateCDR = $companysetting->RateCDR;
            }
            $RateFormat = Company::PREFIX;
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

            Log::error(' ========================== ftp transaction start =============================');
            CronJob::createLog($CronJobID);

            $TimeZone = CompanyGateway::getGatewayTimeZone($CompanyGatewayID);
            if ($TimeZone != '') {
                date_default_timezone_set($TimeZone);
            } else {
                date_default_timezone_set('GMT'); // just to use e in date() function
            }
            $CallID = 0;
            foreach ($filenames as $UsageDownloadFilesID => $filename) {
                Log::info("Loop Start");

                if ($filename != '' && $file_count <= $FilesMaxProccess) {

                    $param = array();
                    $param['filename'] = $filename;

                    Log::info("CDR Insert Start ".$filename." processID: ".$processID);

                    /** update file status to progress */
                    UsageDownloadFiles::UpdateFileStausToProcess($UsageDownloadFilesID,$processID);
                    $delete_files[] = $UsageDownloadFilesID;
                    $fullpath = $FTP_LOCATION.'/'.$CompanyGatewayID. '/' ;
                    try{
                        $NeonExcel = new NeonExcelIO($fullpath, (array) $csvoption);
                        $results = $NeonExcel->read();
                        $lineno = 2;
                        if ($csvoption->Firstrow == 'data') {
                            $lineno = 1;
                        }

                        $error = array();
                        $batch_insert_array = [];
                        foreach ($results as $index=>$temp_row) {
                            if ($csvoption->Firstrow == 'data') {
                                array_unshift($temp_row, null);
                                unset($temp_row[0]);
                            }
                            $cdrdata = array();
                            $cdrdata['ProcessID'] = $processID;
                            $cdrdata['ServiceID'] = $ServiceID;
                            $cdrdata['CompanyGatewayID'] = $CompanyGatewayID;
                            $cdrdata['CompanyID'] = $CompanyID;
                            $cdrdata['trunk'] = 'Other';
                            $cdrdata['area_prefix'] = 'Other';
                            $call_type = '';

                            //check empty row
                            $checkemptyrow = array_filter(array_values($temp_row));
                            if (!empty($checkemptyrow)) {
                                if (isset($attrselection->connect_datetime) && !empty($attrselection->connect_datetime)) {
                                    $cdrdata['connect_time'] = formatDate(str_replace('/', '-', $temp_row[$attrselection->connect_datetime]), $attrselection->DateFormat);
                                } elseif (isset($attrselection->connect_date) && !empty($attrselection->connect_date)) {
                                    $cdrdata['connect_time'] = formatDate(str_replace('/', '-', $temp_row[$attrselection->connect_date] . ' ' . $temp_row[$attrselection->connect_time]), $attrselection->DateFormat);
                                }
                                if (isset($attrselection->billed_duration) && !empty($attrselection->billed_duration)) {
                                    $cdrdata['billed_duration'] = formatDuration($temp_row[$attrselection->billed_duration]);
                                    $cdrdata['billed_second'] = formatDuration($temp_row[$attrselection->billed_duration]);
                                }
                                if (isset($attrselection->duration) && !empty($attrselection->duration)) {
                                    $cdrdata['duration'] = formatDuration($temp_row[$attrselection->duration]);
                                }
                                if (isset($attrselection->disconnect_time) && !empty($attrselection->disconnect_time)) {
                                    $cdrdata['disconnect_time'] = formatDate(str_replace('/', '-', $temp_row[$attrselection->disconnect_time]), $attrselection->DateFormat);
                                } elseif (isset($attrselection->billed_duration) && !empty($attrselection->billed_duration) && !empty($cdrdata['connect_time'])) {
                                    $strtotime = strtotime($cdrdata['connect_time']);
                                    $billed_duration = $cdrdata['billed_duration'];
                                    $cdrdata['disconnect_time'] = date('Y-m-d H:i:s', $strtotime + $billed_duration);
                                }
                                if (isset($attrselection->cld) && !empty($attrselection->cld)) {
                                    $cdrdata['cld'] = apply_translation_rule($CLDTranslationRule, $temp_row[$attrselection->cld]);
                                }
                                if (isset($attrselection->cli) && !empty($attrselection->cli)) {
                                    $cdrdata['cli'] = apply_translation_rule($CLITranslationRule, $temp_row[$attrselection->cli]);
                                }
                                if (isset($attrselection->cost) && !empty($attrselection->cost) && $RateCDR == 0) {
                                    $cdrdata['cost'] = $temp_row[$attrselection->cost];
                                } else if ($RateCDR == 1) {
                                    $cdrdata['cost'] = 0;
                                }


                                if (isset($attrselection->area_prefix) && !empty($attrselection->area_prefix)) {
                                    $uddata['area_prefix'] = sippy_vos_areaprefix(apply_translation_rule($PrefixTranslationRule,$temp_row[$attrselection->area_prefix]),$RateCDR, $RerateAccounts);
                                }

                                if (!empty($attrselection->TrunkID)) {
                                    $cdrdata['TrunkID'] = $attrselection->TrunkID;
                                    $cdrdata['trunk'] = DB::table('tblTrunk')->where(array('TrunkID' => $attrselection->TrunkID))->Pluck('trunk');
                                }
                                if (isset($attrselection->extension) && !empty($attrselection->extension)) {
                                    $cdrdata['extension'] = $temp_row[$attrselection->extension];
                                }

                                if (isset($attrselection->is_inbound) && !empty($attrselection->is_inbound)) {
                                    $cdrdata['is_inbound'] = 0;
                                    $call_type = TempUsageDetail::check_call_type(strtolower($temp_row[$attrselection->is_inbound]), '', '');
                                }
                                if (isset($attrselection->Account) && !empty($attrselection->Account)) {
                                    $cdrdata['GatewayAccountID'] = $temp_row[$attrselection->Account];
                                }
                                if (empty($cdrdata['GatewayAccountID'])) {
                                    $error[] = 'Account is blank at line no:' . $lineno;
                                }
                                if ($RateCDR == 1 && empty($cdrdata['cld']) && !empty($attrselection->cld) && trim($temp_row[$attrselection->cld]) == '') {
                                    $error[] = 'CLD is blank at line no:' . $lineno;
                                }
                                if ($RateCDR == 1 && empty($cdrdata['billed_duration']) && !empty($attrselection->billed_duration) && trim($temp_row[$attrselection->billed_duration]) == '') {
                                    $error[] = 'Billed duration is blank at line no:' . $lineno;
                                }


                                if (!empty($cdrdata['GatewayAccountID'])) {
                                    if ($call_type == 'inbound') {
                                        $cdrdata['is_inbound'] = 1;
                                    } else if ($call_type == 'outbound') {
                                        $cdrdata['is_inbound'] = 0;
                                    } else if ($call_type == 'none') {
                                        /** if user field is blank */
                                        $cdrdata['is_inbound'] = 0;
                                    } else if ($call_type == 'failed') {
                                        /** if user field is failed or blocked call any reason make duration zero */
                                        $cdrdata['billed_duration'] = 0;
                                        $cdrdata['billed_second'] = 0;
                                    }
                                    if ($call_type == 'both' && $RateCDR == 1) {

                                        /**
                                         * Inbound Entry
                                         */
                                        $cdrdata['cost'] = 0;
                                        $cdrdata['is_inbound'] = 1;

                                        /**
                                         * Outbound Entry
                                         */
                                        $data_outbound = $cdrdata;

                                        $data_outbound['cli'] = !empty($cdrdata['cli']) ? $cdrdata['cli'] : '';
                                        $data_outbound['cld'] = !empty($cdrdata['cld']) ? $cdrdata['cld'] : '';
                                        $data_outbound['cost'] = !empty($cdrdata['cost']) ? $cdrdata['cost'] : 0;
                                        $data_outbound['is_inbound'] = 0;
                                        $batch_insert_array[] = $data_outbound;
                                        $data_count++;

                                    }

                                    $batch_insert_array[] = $cdrdata;

                                    if ($data_count >= $insertLimit) {
                                        Log::info('Batch insert start - count' . count($batch_insert_array));

                                        DB::connection('sqlsrvcdr')->table($temptableName)->insert($batch_insert_array);

                                        Log::info('insertion end');
                                        $batch_insert_array = [];
                                        $data_count = 0;
                                    }
                                    $data_count++;

                                }
                            }
                        }// loop over

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

            if(!empty($batch_insert_array)){
                Log::info('Batch insert start - count' . count($batch_insert_array));

                DB::connection('sqlsrvcdr')->table($temptableName)->insert($batch_insert_array);

                Log::info('insertion end');
            }



            Log::error(' ========================== ftp transaction end =============================');
            //ProcessCDR

            Log::info("ProcessCDR($CompanyID,$processID,$CompanyGatewayID,$RateCDR,$RateFormat)");
            $skiped_account_data = TempUsageDetail::ProcessCDR($CompanyID,$processID,$CompanyGatewayID,$RateCDR,$RateFormat,$temptableName);
            if (count($skiped_account_data)) {
                $joblogdata['Message'] .=  implode('<br>', $skiped_account_data);
            }

            //select   MAX(disconnect_time) as max_date,MIN(connect_time)  as min_date    from tblTempUsageDetail where ProcessID = p_ProcessID;
            $result = DB::connection('sqlsrv2')->select("CALL  prc_start_end_time( '" . $processID . "','" . $temptableName . "')");

            $totaldata_count = DB::connection('sqlsrvcdrazure')->table($temptableName)->where('ProcessID',$processID)->count();
            DB::connection('sqlsrv2')->beginTransaction();
            DB::connection('sqlsrvcdrazure')->beginTransaction();

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


            Log::error("Porta CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' ) start");
            DB::statement("CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' )");
            Log::error("Porta CALL  prc_ProcessDiscountPlan ('" . $processID . "', '" . $temptableName . "' ) end");

            Log::error('ftp prc_insertCDR start'.$processID);
            DB::connection('sqlsrvcdrazure')->statement("CALL  prc_insertCDR ('" . $processID . "', '".$temptableName."' )");
            Log::error('ftp prc_insertCDR end');

            /** update file process to completed */
            UsageDownloadFiles::UpdateProcessToComplete( $delete_files);

            DB::connection('sqlsrvcdrazure')->commit();
            DB::connection('sqlsrv2')->commit();
            try {


                date_default_timezone_set(Config::get('app.timezone'));

                $end_time = date('Y-m-d H:i:s');
                $joblogdata['Message'] .= $filedetail . ' <br/>' . time_elapsed($start_time, $end_time);
                $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
                CronJobLog::insert($joblogdata);

                Log::error('ftp delete file count ' . count($delete_files));

                DB::connection('sqlsrvcdrazure')->table($temptableName)->where(["processId" => $processID])->delete(); //TempUsageDetail::where(["processId" => $processID])->delete();

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
                /** put back file to pending if any error occurred */
                UsageDownloadFiles::UpdateToPending($delete_files);

            } catch (Exception $err) {
                Log::error($err);
            }
            // delete temp table if process fail
            try {
                DB::connection('sqlsrvcdrazure')->table($temptableName)->where(["processId" => $processID])->delete();
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