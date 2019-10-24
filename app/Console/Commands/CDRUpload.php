<?php namespace App\Console\Commands;

use App\Lib\AmazonS3;
use App\Lib\Company;
use App\Lib\CompanyConfiguration;
use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\FileUploadTemplate;
use App\Lib\Job;
use App\Lib\JobFile;
use App\Lib\NeonExcelIO;
use App\Lib\Service;
use App\Lib\TempUsageDetail;
use App\Lib\TempUsageDownloadLog;
use App\Lib\Trunk;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;

class CDRUpload extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'cdrupload';

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

    /**
     * Get the console command arguments.
     *
     * @return array
     */
    protected function getArguments()
    {
        return [
            ['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID '],
            ['JobID', InputArgument::REQUIRED, 'Argument JobID '],
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
        $getmypid = getmypid(); // get proccess id added by abubakar
        $JobID = $arguments["JobID"];
        $CompanyID = $arguments["CompanyID"];
        $job = Job::find($JobID);

        $jobfile = JobFile::where(["JobID" => $JobID])->first();
        $temptableName  = 'tblTempUsageDetail';

        Log::useFiles(storage_path() . '/logs/cdrupload-' . $JobID . '-' . date('Y-m-d') . '.log');
        $TEMP_PATH = CompanyConfiguration::get($CompanyID,'TEMP_PATH').'/';
        $error = array();
        $skipped_cli = array();
        $active_cli = array();
        try {
            $ProcessID = CompanyGateway::getProcessID();
            Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar
            $joboptions = json_decode($job->Options);
            //print_r($joboptions);exit;//CheckCustomerCLI,RateCDR
            $CompanyGatewayID = $joboptions->CompanyGatewayID;
            $temptableName = CompanyGateway::CreateIfNotExistCDRTempUsageDetailTable($CompanyID,$CompanyGatewayID,'cdr');
            $FileUploadTemplate = FileUploadTemplate::find($joboptions->FileUploadTemplateID);
            $TemplateOptions = json_decode($FileUploadTemplate->Options);
            $csvoption = $TemplateOptions->option;
            $attrselection = $TemplateOptions->selection;
            $RateCDR = 0;
            $NameFormat = '';
            $ServiceID = $OutboundRateTableID = $InboundRateTableID = $IgnoreZeroCall = 0;
            $Services = Service::where(array("CompanyID"=>$CompanyID,"Status"=>1))->lists('ServiceName', 'ServiceID');;
            $Trunks = Trunk::where([ "Status" => 1 , "CompanyID" => $CompanyID])->lists('Trunk', 'TrunkID');
            if(isset($attrselection->ServiceID) && $attrselection->ServiceID){
                $ServiceID = $attrselection->ServiceID;
            }
            if(isset($attrselection->OutboundRateTableID) && $attrselection->OutboundRateTableID){
                $OutboundRateTableID = $attrselection->OutboundRateTableID;
            }
            if(isset($attrselection->InboundRateTableID) && $attrselection->InboundRateTableID){
                $InboundRateTableID = $attrselection->InboundRateTableID;
            }
            if(isset($joboptions->IgnoreZeroRatedCall) && $joboptions->IgnoreZeroRatedCall){
                $IgnoreZeroCall = $joboptions->IgnoreZeroRatedCall;
            }

            if(isset($joboptions->RateCDR) && $joboptions->RateCDR){
                $RateCDR = $joboptions->RateCDR;
            }
            $RateFormat = Company::PREFIX;
            if(isset($joboptions->RateFormat) && $joboptions->RateFormat){
                $RateFormat = $joboptions->RateFormat;
            }
            if(isset($joboptions->Authentication) && $joboptions->Authentication){
                $NameFormat = $joboptions->Authentication;
            }
            $CLITranslationRule = $CLDTranslationRule =  '';
            if(!empty($attrselection->CLITranslationRule)){
                $CLITranslationRule = $attrselection->CLITranslationRule;
            }
            if(!empty($attrselection->CLDTranslationRule)){
                $CLDTranslationRule = $attrselection->CLDTranslationRule;
            }
            if (!empty($job) && !empty($jobfile)) {
                if ($jobfile->FilePath) {
                    $path = AmazonS3::unSignedUrl($jobfile->FilePath,$CompanyID);
                    if (strpos($path, "https://") !== false) {
                        $file = $TEMP_PATH . basename($path);
                        file_put_contents($file, file_get_contents($path));
                        $jobfile->FilePath = $file;
                    } else {
                        $jobfile->FilePath = $path;
                    }
                }

                $NeonExcel = new NeonExcelIO($jobfile->FilePath, (array) $csvoption);
                $results = $NeonExcel->read();

                if (isset($joboptions->CheckFile) && $joboptions->CheckFile == 1 && isset($attrselection->Authentication) && $attrselection->Authentication == 'CLI') {
                    foreach ($results as $temp_row) {
                        if ($csvoption->Firstrow == 'data') {
                            array_unshift($temp_row, null);
                            unset($temp_row[0]);
                        }
                        $temp_row = filterArrayRemoveNewLines($temp_row);
                        if (isset($attrselection->cli) && !empty($attrselection->cli)) {
                            $CustomerCLI = $temp_row[$attrselection->cli];
                            $checkCustomerCli = DB::select("CALL prc_checkCustomerCli(?,?)",array($CompanyID,$CustomerCLI));
                            if (isset($checkCustomerCli[0]->AccountID) && $checkCustomerCli[0]->AccountID) {
                                $active_cli[] = $CustomerCLI;
                            } else {
                                $skipped_cli[] = $CustomerCLI;
                            }
                        }
                    }
                }
                $skipped_cli = array_unique($skipped_cli);
                $lineno = 2;
                if ($csvoption->Firstrow == 'data') {
                    $lineno = 1;
                }
                $counter = 0;
                $bacth_insert_limit = 1000;
                $batch_insert_array = array();

                if ((count($skipped_cli) == 0 && $joboptions->CheckFile == 1) || $joboptions->CheckFile == 0) {
                    foreach ($results as $temp_row) {
                        if ($csvoption->Firstrow == 'data') {
                            array_unshift($temp_row, null);
                            unset($temp_row[0]);
                        }

                        $temp_row = filterArrayRemoveNewLines($temp_row);

                        $cdrdata = array();
                        $cdrdata['ProcessID'] = $ProcessID;

                        if(isset($attrselection->ServiceID) && !empty($attrselection->ServiceID) && isset($temp_row[$attrselection->ServiceID]) && $ServiceID_1 = array_search($temp_row[$attrselection->ServiceID],$Services)){
                            $cdrdata['ServiceID'] = $ServiceID_1;
                        }else{
                            $cdrdata['ServiceID'] = $ServiceID;
                        }

                        if(isset($attrselection->TrunkID) && !empty($attrselection->TrunkID) && array_key_exists($attrselection->TrunkID,$Trunks)){
                            $cdrdata['TrunkID'] = $attrselection->TrunkID;
                            $cdrdata['trunk'] = $Trunks[$attrselection->TrunkID];
                        }else if(isset($attrselection->TrunkID) && !empty($attrselection->TrunkID) && isset($temp_row[$attrselection->TrunkID]) && $TrunkID_1 = array_search($temp_row[$attrselection->TrunkID],$Trunks)){
                            $cdrdata['TrunkID'] = $TrunkID_1;
                            $cdrdata['trunk'] = $Trunks[$TrunkID_1];
                        }else{
                            $cdrdata['trunk'] = 'Other';
                        }

                        $cdrdata['CompanyGatewayID'] = $CompanyGatewayID;
                        $cdrdata['CompanyID'] = $CompanyID;
                        $cdrdata['area_prefix'] = 'Other';
                        $call_type = '';

                        //check empty row
                        $checkemptyrow = array_filter(array_values($temp_row));
                        if(!empty($checkemptyrow)){
                            if (isset($attrselection->connect_datetime) && !empty($attrselection->connect_datetime)) {
                                $cdrdata['connect_time'] = formatDate(str_replace( '/','-',$temp_row[$attrselection->connect_datetime]), $attrselection->DateFormat);
                            } elseif (isset($attrselection->connect_date) && !empty($attrselection->connect_date)) {
                                $cdrdata['connect_time'] = formatDate(str_replace( '/','-',$temp_row[$attrselection->connect_date].' '.$temp_row[$attrselection->connect_time]), $attrselection->DateFormat);
                            }
                            if (isset($attrselection->billed_duration) && !empty($attrselection->billed_duration)) {
                                $cdrdata['billed_duration'] = formatDuration($temp_row[$attrselection->billed_duration]);
                                $cdrdata['billed_second'] = formatDuration($temp_row[$attrselection->billed_duration]);
                            }
                            if (isset($attrselection->duration) && !empty($attrselection->duration)) {
                                $cdrdata['duration'] = formatDuration($temp_row[$attrselection->duration]);
                            }
                            if (isset($attrselection->disconnect_time) && !empty($attrselection->disconnect_time)) {
                                $cdrdata['disconnect_time'] = formatDate(str_replace( '/','-',$temp_row[$attrselection->disconnect_time]), $attrselection->DateFormat);
                            } elseif (isset($attrselection->billed_duration) && !empty($attrselection->billed_duration) && !empty($cdrdata['connect_time'])) {
                                $strtotime = strtotime($cdrdata['connect_time']);
                                $billed_duration = $cdrdata['billed_duration'];
                                $cdrdata['disconnect_time'] = date('Y-m-d H:i:s', $strtotime + $billed_duration);
                            }
                            if (isset($attrselection->cld) && !empty($attrselection->cld)) {
                                $cdrdata['cld'] = apply_translation_rule($CLDTranslationRule,$temp_row[$attrselection->cld]);
                            }
                            if (isset($attrselection->cli) && !empty($attrselection->cli)) {
                                $cdrdata['cli'] = apply_translation_rule($CLITranslationRule,$temp_row[$attrselection->cli]);
                            }
                            if (isset($attrselection->cost) && !empty($attrselection->cost) && $RateCDR == 0 ) {
                                $cdrdata['cost'] = $temp_row[$attrselection->cost];
                            }else if($RateCDR == 1){
                                $cdrdata['cost'] = 0;
                            }
                            if ($RateCDR == 1 && $RateFormat == Company::CHARGECODE && isset($attrselection->ChargeCode) && !empty($attrselection->ChargeCode)) {
                                $cdrdata['area_prefix'] = $temp_row[$attrselection->ChargeCode];
                            }
                            if(!empty($attrselection->TrunkID)){
                                $cdrdata['TrunkID'] = $attrselection->TrunkID;
                                $cdrdata['trunk'] = DB::table('tblTrunk')->where(array('TrunkID'=>$attrselection->TrunkID))->Pluck('trunk');
                            }
                            if (isset($attrselection->extension) && !empty($attrselection->extension)) {
                                $cdrdata['extension'] = $temp_row[$attrselection->extension];
                            }
                            if (isset($attrselection->pincode) && !empty($attrselection->pincode)) {
                                $cdrdata['pincode'] = $temp_row[$attrselection->pincode];
                            }
                            if (isset($attrselection->ID) && !empty($attrselection->ID)) {
                                $cdrdata['ID'] = $temp_row[$attrselection->ID];
                            }
                            if (isset($attrselection->is_inbound) && !empty($attrselection->is_inbound)) {
								$cdrdata['is_inbound'] = 0;
                                $call_type = TempUsageDetail::check_call_type(strtolower($temp_row[$attrselection->is_inbound]),'','');
                            }
                            if (isset($attrselection->Account) && !empty($attrselection->Account)) {
                                $cdrdata['GatewayAccountID'] = $temp_row[$attrselection->Account];
                                if ($NameFormat == 'NUB') {
                                    $cdrdata['AccountIP'] = '';
                                    $cdrdata['AccountName'] = '';
                                    $cdrdata['AccountNumber'] = $temp_row[$attrselection->Account];
                                    $cdrdata['AccountCLI'] = '';
                                } else if ($NameFormat == 'IP') {
                                    $cdrdata['AccountIP'] = $temp_row[$attrselection->Account];
                                    $cdrdata['AccountName'] = '';
                                    $cdrdata['AccountNumber'] = '';
                                    $cdrdata['AccountCLI'] = '';
                                }else if ($NameFormat == 'CLI') {
                                    $cdrdata['AccountIP'] = '';
                                    $cdrdata['AccountName'] = '';
                                    $cdrdata['AccountNumber'] = '';
                                    $cdrdata['AccountCLI'] = $temp_row[$attrselection->Account];
                                }else{
                                    $cdrdata['AccountIP'] = '';
                                    $cdrdata['AccountName'] = $temp_row[$attrselection->Account];
                                    $cdrdata['AccountNumber'] = '';
                                    $cdrdata['AccountCLI'] = '';
                                }

                            }
                            if(empty($cdrdata['GatewayAccountID'])){
                                $error[] = 'Account is blank at line no:'.$lineno;
                            }
                            if($RateCDR == 1 && empty($cdrdata['cld']) && !empty($attrselection->cld) && trim($temp_row[$attrselection->cld]) == ''){
                                $error[] = 'CLD is blank at line no:'.$lineno;
                            }
                            if($RateCDR == 1 && empty($cdrdata['billed_duration']) && !empty($attrselection->billed_duration) && trim($temp_row[$attrselection->billed_duration]) == ''){
                                $error[] = 'Billed duration is blank at line no:'.$lineno;
                            }



                            if(!empty($cdrdata['GatewayAccountID'])) {
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
                                    $counter++;

                                }

                                $batch_insert_array[] = $cdrdata;

                                if($counter >= $bacth_insert_limit){
                                    Log::info('Batch insert start - count' . count($batch_insert_array));

                                    DB::connection('sqlsrvcdr')->table($temptableName)->insert($batch_insert_array);

                                    Log::info('insertion end');
                                    $batch_insert_array = [];
                                    $counter = 0;
                                }
                                $counter++;

                            }
                        }
                        $lineno++;
                    } // loop

                    if(!empty($batch_insert_array)){
                        Log::info('Batch insert start - count' . count($batch_insert_array));

                        DB::connection('sqlsrvcdr')->table($temptableName)->insert($batch_insert_array);

                        Log::info('insertion end');
                    }

                }

                //ProcessCDR
                Log::info("ProcessCDR($CompanyID,$ProcessID,$CompanyGatewayID,$RateCDR,$RateFormat)");
                $skiped_account_data = TempUsageDetail::ProcessCDR($CompanyID,$ProcessID,$CompanyGatewayID,$RateCDR,$RateFormat,$temptableName,$NameFormat,'CurrentRate','0',$OutboundRateTableID,$InboundRateTableID,0);
                $skiped_rerated_data = array();
                if($IgnoreZeroCall == 1){
                    foreach($skiped_account_data as $key => $errormg){
                        if(strpos($errormg,'Doesnt exist in NEON') === false){
                            $skiped_rerated_data[] = $errormg;
                            unset($skiped_account_data[$key]);
                        }
                    }
                }

                $result = DB::connection('sqlsrv2')->select("CALL  prc_start_end_time( '" . $ProcessID . "','" . $temptableName . "')");
                Log::info(print_r($result,true));

                $totaldata_count = DB::connection('sqlsrvcdr')->table($temptableName)->where('ProcessID',$ProcessID)->whereNotNull('AccountID')->count();

                if ((count($skipped_cli) == 0 && count($skiped_account_data) == 0 && $joboptions->CheckFile == 1) || $joboptions->CheckFile == 0) {
                    DB::connection('sqlsrvcdr')->beginTransaction();

                    if (!empty($result[0]->min_date)) {
                        /** Add CDR log for Invoice generation. - to check cdr is available. */
                        $logdata['CompanyGatewayID'] = $CompanyGatewayID;
                        $logdata['CompanyID'] = $CompanyID;
                        $logdata['start_time'] = $result[0]->min_date;
                        $logdata['end_time'] = $result[0]->max_date;
                        $logdata['created_at'] = date('Y-m-d H:i:s');
                        $logdata['ProcessID'] = $ProcessID;
                        TempUsageDownloadLog::insert($logdata);
                    }
                    if($RateCDR == 0) {
                        Log::error("CDR upload CALL  prc_ProcessDiscountPlan ('" . $ProcessID . "', '" . $temptableName . "' ) start");
                        DB::statement("CALL  prc_ProcessDiscountPlan ('" . $ProcessID . "', '" . $temptableName . "' )");
                        Log::error("CDR upload CALL  prc_ProcessDiscountPlan ('" . $ProcessID . "', '" . $temptableName . "' ) end");
                    }

                    Log::error(' prc_insertCDR start');
                    DB::connection('sqlsrvcdr')->statement("CALL  prc_insertCDR ('" . $ProcessID . "', '".$temptableName."' )");
                    Log::error(' prc_insertCDR end');
                    DB::connection('sqlsrvcdr')->commit();
                }
                if (count($skiped_account_data) && $joboptions->CheckFile == 0) {
                    $skiped_account_data = array_merge(fix_jobstatus_meassage($error),fix_jobstatus_meassage($skiped_account_data));
                    $jobdata['JobStatusMessage'] = $totaldata_count.' Records Uploaded  \n\r' . implode(',\n\r', $skiped_account_data);
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'PF')->pluck('JobStatusID');
                }else if (count($skiped_account_data)) {
                    $skiped_account_data = array_merge(fix_jobstatus_meassage($error),fix_jobstatus_meassage($skiped_account_data));
                    $jobdata['JobStatusMessage'] =  implode(',\n\r', $skiped_account_data);
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                }else if (count($skiped_rerated_data)) {
                    $skiped_account_data = array_merge(fix_jobstatus_meassage($error),fix_jobstatus_meassage($skiped_account_data),fix_jobstatus_meassage($skiped_rerated_data));
                    $jobdata['JobStatusMessage'] = $totaldata_count.' Records Uploaded  \n\r' . implode(',\n\r', $skiped_account_data);
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'PF')->pluck('JobStatusID');
                } else if(count($skipped_cli)){
                    $skipped_cli = array_merge(fix_jobstatus_meassage($error),fix_jobstatus_meassage($skipped_cli));
                    $jobdata['JobStatusMessage'] = 'CLI Not Verified:' . implode(',\n\r', $skipped_cli);
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                } else if(count($error)){
                    $jobdata['JobStatusMessage'] = implode(',\n\r', fix_jobstatus_meassage($error));
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'PF')->pluck('JobStatusID');
                }else {
                    $jobdata['JobStatusMessage'] = $totaldata_count.' Records Uploaded  \n\r Customer CDR Uploaded Successfully';
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'S')->pluck('JobStatusID');
                }
                $jobdata['updated_at'] = date('Y-m-d H:i:s');
                $jobdata['ModifiedBy'] = 'RMScheduler';

                Job::where(["JobID" => $JobID])->update($jobdata);

                @unlink($TEMP_PATH . basename($jobfile->FilePath));
            } else {
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                $jobdata['JobStatusMessage'] = 'Related Job not found';
                $jobdata['updated_at'] = date('Y-m-d H:i:s');
                $jobdata['ModifiedBy'] = 'RMScheduler';
                Job::where(["JobID" => $JobID])->update($jobdata);
            }

        } catch (\Exception $e) {
            DB::rollback();
            DB::connection('sqlsrv2')->rollback();
            // delete temp table if process fail
            try {
                DB::connection('sqlsrvcdr')->table($temptableName)->where(["processId" => $ProcessID])->delete();
            } catch (\Exception $err) {
                Log::error($err);
            }
            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
            $jobdata['JobStatusMessage'] = 'Customer CDR Upload Failed::' . $e->getMessage();
            $jobdata['updated_at'] = date('Y-m-d H:i:s');
            $jobdata['ModifiedBy'] = 'RMScheduler';
            Job::where(["JobID" => $JobID])->update($jobdata);
            Log::error($e);
        }

        Job::send_job_status_email($job,$CompanyID);

        CronHelper::after_cronrun($this->name, $this);

    }
}

