<?php namespace App\Console\Commands;

use App\Lib\AmazonS3;
use App\Lib\Company;
use App\Lib\CompanyGateway;
use App\Lib\FileUploadTemplate;
use App\Lib\Job;
use App\Lib\JobFile;
use App\Lib\TempUsageDownloadLog;
use App\Lib\TempVendorCDR;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Maatwebsite\Excel\Facades\Excel;
use App\Lib\NeonExcelIO;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;

class VCDRUpload extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'vcdrupload';

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
        $arguments = $this->argument();
        $getmypid = getmypid(); // get proccess id added by abubakar
        $JobID = $arguments["JobID"];
        $CompanyID = $arguments["CompanyID"];
        $job = Job::find($JobID);
        $ProcessID = Uuid::generate();
        $jobfile = JobFile::where(["JobID" => $JobID])->first();
        $temptableName = 'tblTempVendorCDR';
        Job::JobStatusProcess($JobID, $ProcessID, $getmypid);//Change by abubakar
        Log::useFiles(storage_path() . '/logs/vcdrupload-' . $JobID . '-' . date('Y-m-d') . '.log');
        $skiped_account = array();
        $skiped_account_data = array();
        try {
            DB::beginTransaction();
            DB::connection('sqlsrv2')->beginTransaction();
            $joboptions = json_decode($job->Options);
            $CompanyGatewayID = $joboptions->CompanyGatewayID;
            $temptableName = CompanyGateway::CreateVendorTempTable($CompanyID, $CompanyGatewayID);
            $FileUploadTemplate = FileUploadTemplate::find($joboptions->FileUploadTemplateID);
            $TemplateOptions = json_decode($FileUploadTemplate->Options);
            $csvoption = $TemplateOptions->option;
            $attrselection = $TemplateOptions->selection;
            $RateCDR = 0;
            if (isset($joboptions->RateCDR) && $joboptions->RateCDR) {
                $RateCDR = $joboptions->RateCDR;
            }
            $RateFormat = Company::PREFIX;
            if (!empty($joboptions->RateFormat)) {
                $RateFormat = $joboptions->RateFormat;
            }

            if (!empty($job) && !empty($jobfile)) {
                if ($jobfile->FilePath) {
                    $path = AmazonS3::unSignedUrl($jobfile->FilePath);
                    if (strpos($path, "https://") !== false) {
                        $file = Config::get('app.temp_location') . basename($path);
                        file_put_contents($file, file_get_contents($path));
                        $jobfile->FilePath = $file;
                    } else {
                        $jobfile->FilePath = $path;
                    }
                }
                /*
                if (!empty($csvoption->Delimiter)) {
                    Config::set('excel::csv.delimiter', $csvoption->Delimiter);
                }
                if (!empty($csvoption->Enclosure)) {
                    Config::set('excel::csv.enclosure', $csvoption->Enclosure);
                }
                if (!empty($csvoption->Escape)) {
                    Config::set('excel::csv.line_ending', $csvoption->Escape);
                }
                Config::set('excel.import.heading', 'original');
                $excel = Excel::load($jobfile->FilePath, function ($reader) use ($csvoption) {
                    if ($csvoption->Firstrow == 'data') {
                        $reader->noHeading();
                    }
                    $reader->formatDates(true, 'Y-m-d');
                })->get();
                $results = json_decode(json_encode($excel), true);
                */
                $NeonExcel = new NeonExcelIO($jobfile->FilePath, (array) $csvoption);
                $results = $NeonExcel->read();

                $lineno = 2;
                if ($csvoption->Firstrow == 'data') {
                    $lineno = 1;
                }

                foreach ($results as $temp_row) {
                    if ($csvoption->Firstrow == 'data') {
                        array_unshift($temp_row, null);
                        unset($temp_row[0]);
                    }
                    $cdrdata = array();
                    $cdrdata['ProcessID'] = $ProcessID;
                    $cdrdata['CompanyGatewayID'] = $CompanyGatewayID;
                    $cdrdata['CompanyID'] = $CompanyID;
                    $cdrdata['trunk'] = 'Other';
                    $cdrdata['area_prefix'] = 'Other';

                    //check empty row
                    $checkemptyrow = array_filter(array_values($temp_row));
                    if(!empty($checkemptyrow)){
                        if (!empty($attrselection->connect_datetime)) {
                            $cdrdata['connect_time'] = formatDate(str_replace( '/','-',$temp_row[$attrselection->connect_datetime]));
                        } elseif (!empty($attrselection->connect_date)) {
                            $cdrdata['connect_time'] = formatDate(str_replace( '/','-',$temp_row[$attrselection->connect_date] . ' ' . $temp_row[$attrselection->connect_time]));
                        }
                        if (!empty($attrselection->billed_duration)) {
                            $cdrdata['billed_duration'] = formatDuration($temp_row[$attrselection->billed_duration]);
                        }
                        if (!empty($attrselection->duration)) {
                            $cdrdata['duration'] = formatDuration($temp_row[$attrselection->duration]);
                        }
                        if (!empty($attrselection->disconnect_time)) {
                            $cdrdata['disconnect_time'] = formatDate(str_replace( '/','-',$temp_row[$attrselection->disconnect_time]));
                        } elseif (!empty($attrselection->billed_duration) && !empty($cdrdata['connect_time'])) {
                            $strtotime = strtotime($cdrdata['connect_time']);
                            $billed_duration = $cdrdata['billed_duration'];
                            $cdrdata['disconnect_time'] = date('Y-m-d H:i:s', $strtotime + $billed_duration);
                        }
                        if (!empty($attrselection->cld)) {
                            $cdrdata['cld'] = $temp_row[$attrselection->cld];
                        }
                        if (!empty($attrselection->cli)) {
                            $cdrdata['cli'] = $temp_row[$attrselection->cli];
                        }
                        if (!empty($attrselection->buycost)) {
                            $cdrdata['buying_cost'] = $temp_row[$attrselection->buycost];
                        }
                        if (!empty($attrselection->sellcost)) {
                            if (!empty($joboptions->RateCDR) && !empty($attrselection->area_prefix) && !empty($joboptions->TrunkID) && $joboptions->TrunkID > 0) {
                                $cdrdata['area_prefix'] = $temp_row[$attrselection->area_prefix];
                                $cdrdata['trunk'] = DB::table('tblTrunk')->where(array('TrunkID' => $joboptions->TrunkID))->Pluck('trunk');
                                $RateFormat = Company::CHARGECODE;
                            } else {
                                $cdrdata['selling_cost'] = $temp_row[$attrselection->sellcost];
                            }
                        }
                        if (isset($attrselection->Account) && !empty($attrselection->Account)) {
                            $cdrdata['GatewayAccountID'] = $temp_row[$attrselection->Account];
                        }
                        //print_r($cdrdata);exit;
                        if (!empty($cdrdata['GatewayAccountID'])) {
                            DB::connection('sqlsrvcdrazure')->table($temptableName)->insert($cdrdata);
                        }
                    }
                    $lineno++;
                }
                if (count($skiped_account_data) == 0) {
                    DB::commit();
                    DB::connection('sqlsrv2')->commit();
                } else {
                    DB::rollback();
                    DB::connection('sqlsrv2')->rollback();
                }

                //ProcessCDR
                Log::info("ProcessCDR($CompanyID, $ProcessID, $CompanyGatewayID, $RateCDR, $RateFormat, $temptableName)");
                $skiped_account_data = TempVendorCDR::ProcessCDR($CompanyID, $ProcessID, $CompanyGatewayID, $RateCDR, $RateFormat, $temptableName);

                $result = DB::connection('sqlsrv2')->select("CALL  prc_start_end_time( '" . $ProcessID . "','" . $temptableName . "')");
                Log::info(print_r($result, true));


                if (count($skiped_account_data) == 0) {
                    DB::connection('sqlsrvcdrazure')->beginTransaction();

                    if (!empty($result[0]->min_date)) {
                        $StartDate = $result[0]->min_date;
                        $EndDate = $result[0]->max_date;
                        $logdata['CompanyGatewayID'] = 0;
                        $logdata['CompanyID'] = $CompanyID;
                        $logdata['start_time'] = $result[0]->min_date;
                        $logdata['end_time'] = $result[0]->max_date;
                        $logdata['created_at'] = date('Y-m-d H:i:s');
                        $logdata['ProcessID'] = $ProcessID;
                        TempUsageDownloadLog::insert($logdata);
                        DB::connection('sqlsrv2')->statement("CALL prc_DeleteVCDR('" . $CompanyID . "','" . $CompanyGatewayID . "','" . $StartDate . "','" . $EndDate . "','')");

                    }

                    Log::error(' prc_insertCDR start');
                    DB::connection('sqlsrvcdrazure')->statement("CALL  prc_insertVendorCDR ('" . $ProcessID . "', '" . $temptableName . "' )");
                    Log::error(' prc_insertCDR end');
                    DB::connection('sqlsrvcdrazure')->commit();
                }
                //DB::connection('sqlsrvcdrazure')->table($temptableName)->where(["processId" => $ProcessID])->delete(); //TempUsageDetail::where(["processId" => $processID])->delete();
                foreach ($skiped_account as $accountrow) {
                    $skiped_account_data[] = $accountrow->AccountName;
                }
                if (count($skiped_account_data)) {
                    $jobdata['JobStatusMessage'] = 'Skipped Code:' . implode(',\n\r', $skiped_account_data);
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                } else {
                    $jobdata['JobStatusMessage'] = 'Vendor CDR Uploaded Successfully';
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'S')->pluck('JobStatusID');
                }
                $jobdata['updated_at'] = date('Y-m-d H:i:s');
                $jobdata['ModifiedBy'] = 'RMScheduler';

                Job::where(["JobID" => $JobID])->update($jobdata);

                @unlink(Config::get('app.temp_location') . basename($jobfile->FilePath));
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
                DB::connection('sqlsrvcdrazure')->table($temptableName)->where(["processId" => $ProcessID])->delete();//TempUsageDetail::where(["processId" => $processID])->delete();
                //DB::connection('sqlsrvcdrazure')->statement("  DELETE FROM tblTempUsageDetail WHERE ProcessID = '" . $processID . "'");
            } catch (\Exception $err) {
                Log::error($err);
            }
            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
            $jobdata['JobStatusMessage'] = 'Vendor CDR Upload Failed::' . $e->getMessage();
            $jobdata['updated_at'] = date('Y-m-d H:i:s');
            $jobdata['ModifiedBy'] = 'RMScheduler';
            Job::where(["JobID" => $JobID])->update($jobdata);
            Log::error($e);
        }
        Job::send_job_status_email($job, $CompanyID);
    }
}

