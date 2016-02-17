<?php
/**
 * Created by PhpStorm.
 * User: srs2
 * Date: 25/05/2015
 * Time: 06:58
 */

namespace App\Console\Commands;


use App\Lib\CompanyGateway;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\TempUsageDetail;
use App\Lib\TempUsageDownloadLog;
use App\Lib\TempVendorCDR;
use App\SippySSH;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;
use \Exception;
use App\Lib\Company;

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
        $processID = Uuid::generate();
        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';
        $joblogdata['Message'] = '';
        $delete_files = array();
        $temptableName = CompanyGateway::CreateIfNotExistCDRTempUsageDetailTable($CompanyID,$CompanyGatewayID);

        Log::useFiles(storage_path() . '/logs/sippyaccountusage-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');
        try {
            $start_time = date('Y-m-d H:i:s');
            Log::info("Start");

            $filenames = array();
            $new_filenames = scandir(Config::get('app.sippy_location') . $CompanyGatewayID);
            foreach ((array)$new_filenames as $file) {
                if (strpos($file, 'pending_'.SippySSH::$customer_cdr_file_name) !== false) {
                    $filenames[] = $file;
                }
            }
            $lastelse = array_pop($filenames);

            Log::info("Files Names Collected");
            Log::error('   sippy File Count ' . count($filenames));
            $file_count = 1;

            Log::error(' ========================== sippy transaction start =============================');
            if (count($filenames)) {
                CronJob::createLog($CronJobID);
            }

            $TimeZone = CompanyGateway::getGatewayTimeZone($CompanyGatewayID);
            if ($TimeZone != '') {
                date_default_timezone_set($TimeZone);
            } else {
                date_default_timezone_set('GMT'); // just to use e in date() function
            }
            foreach ($filenames as $filename) {
                Log::info("Loop Start");

                if ($filename != '' && $file_count <= $FilesMaxProccess) {

                    $param = array();
                    $param['filename'] = $filename;

                    Log::info("CDR Insert Start ".$filename." processID: ".$processID);

                    $file_result = SippySSH::changeCDRFilesStatus("pending-to-progress" , $filename , $CompanyGatewayID ,true );
                    if(!empty($file_result) && isset($file_result['new_filename']) &&  !empty($file_result['new_filename']) && isset($file_result['new_file_fullpath']) &&  !empty($file_result['new_file_fullpath']) ) {

                        $delete_files[] = $file_result['new_filename'];
                        $inproress_name = $file_result['new_file_fullpath'];
                    }

                    $csv_response = SippySSH::get_file_content($inproress_name);

                    if ( isset($csv_response["return_var"]) &&  $csv_response["return_var"] == 0 && isset($csv_response["output"]) && count($csv_response["output"]) > 0  ) {

                        $cdr_rows = $csv_response["output"];
                        $InserData = $InserVData = array();
                        foreach($cdr_rows as $cdr_row){

                            if (!empty($cdr_rows['i_account']) || ($IpBased ==1 && !empty($cdr_rows['remote_ip']))) {

                                $uddata = array();
                                $uddata['CompanyGatewayID'] = $CompanyGatewayID;
                                $uddata['CompanyID'] = $CompanyID;
                                if($IpBased){
                                    $uddata['GatewayAccountID'] = $cdr_rows['remote_ip'];
                                }else{
                                    $uddata['GatewayAccountID'] = $cdr_rows['i_account'];
                                }
                                $uddata['connect_time'] = gmdate('Y-m-d H:i:s', $cdr_rows['connect_time']);
                                $uddata['disconnect_time'] = gmdate('Y-m-d H:i:s', $cdr_rows['disconnect_time']);
                                $uddata['cost'] = (float)$cdr_rows['cost'];
                                $uddata['cld'] = str_replace('2222', '', $cdr_rows['cld_in']);
                                $uddata['cli'] = $cdr_rows['cld_in'];
                                $uddata['billed_duration'] = $cdr_rows['billed_duration'];
                                $uddata['duration'] = $cdr_rows['billed_duration'];
                                $uddata['trunk'] = 'Other';
                                $uddata['area_prefix'] = $cdr_rows['prefix'];
                                $uddata['remote_ip'] = $cdr_rows['remote_ip'];
                                $uddata['ProcessID'] = $processID;

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
                        Log::error("Error Reading Sippy Encoded File. " . $return_var);

                    }


                    Log::info("CDR Insert END");
                    $file_count++;
                } else {
                    break;
                }
                Log::info("Loop End");

            }


            Log::error(' ========================== sippy transaction end =============================');
            //ProcessCDR
            $RateFormat = Company::PREFIX;
            $RateCDR = 0;
            if(isset($companysetting->RateCDR) && $companysetting->RateCDR){
                $RateCDR = $companysetting->RateCDR;
            }
            if(isset($companysetting->RateFormat) && $companysetting->RateFormat){
                $RateFormat = $companysetting->RateFormat;
            }
            Log::info("ProcessCDR($CompanyID,$processID,$CompanyGatewayID,$RateCDR,$RateFormat)");
            //TempVendorCDR::ProcessCDR($CompanyID,$processID,$CompanyGatewayID,$RateCDR,$RateFormat);
            $skiped_account_data = TempUsageDetail::ProcessCDR($CompanyID,$processID,$CompanyGatewayID,$RateCDR,$RateFormat,$temptableName);
            if (count($skiped_account_data)) {
                $joblogdata['Message'] .= ' <br>Skipped Rerate Code:' . implode('<br>', $skiped_account_data);
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

            Log::error('sippy prc_insertCDR start'.$processID);
            DB::connection('sqlsrvcdrazure')->statement("CALL  prc_insertCDR ('" . $processID . "', '".$temptableName."' )");
            //DB::connection('sqlsrvcdrazure')->statement("CALL  prc_insertVendorCDR ('" . $processID . "')");
            Log::error('sippy prc_insertCDR end');


            DB::connection('sqlsrvcdrazure')->commit();
            DB::connection('sqlsrv2')->commit();
            try {
                // Rename files to complete or delete
                SippySSH::changeCDRFilesStatus("progress-to-complete" , $delete_files , $CompanyGatewayID );

                date_default_timezone_set(Config::get('app.timezone'));
                $CdrBehindData = array();
                if (!empty($result[0]->min_date) && !empty($cronsetting['ErrorEmail'])) {
                    $CdrBehindData['startdatetime'] = $result[0]->min_date;
                    CronJob::CheckCdrBehindDuration($CronJob, $CdrBehindData);
                }
                $end_time = date('Y-m-d H:i:s');
                $joblogdata['Message'] .= $filedetail . ' <br/>' . time_elapsed($start_time, $end_time);
                $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
                CronJobLog::insert($joblogdata);

                Log::error('sippy delete file count ' . count($delete_files));

                DB::connection('sqlsrvcdrazure')->table($temptableName)->where(["processId" => $processID])->delete(); //TempUsageDetail::where(["processId" => $processID])->delete();
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
                SippySSH::changeCDRFilesStatus("progress-to-pending" , $delete_files , $CompanyGatewayID );

            } catch (Exception $err) {
                Log::error($err);
            }
            // delete temp table if process fail
            try {
                DB::connection('sqlsrvcdrazure')->table($temptableName)->where(["processId" => $processID])->delete();
                //TempUsageDetail::where(["processId" => $processID])->delete();
                //TempVendorCDR::where(["processId" => $processID])->delete();
                //DB::connection('sqlsrvcdrazure')->statement("  DELETE FROM tblTempUsageDetail WHERE ProcessID = '".$processID."'");
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
    }

}