<?php
/**
 * Created by PhpStorm.
 * User: srs2
 * Date: 25/05/2015
 * Time: 06:58
 */
//if you change anything in this file then you need to change also in VendorRateUpload,RateTableRateUpload in service and RateUploadController.php->ReviewRates() in web

namespace App\Console\Commands;

use App\Lib\AmazonS3;
use App\Lib\CompanyConfiguration;
use App\Lib\CompanySetting;
use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\Job;
use App\Lib\JobFile;
use App\Lib\NeonExcelIO;
use App\Lib\RateTable;
use App\Lib\TempRateTablePKGRate;
use App\Lib\FileUploadTemplate;
use App\Lib\Timezones;
use App\Lib\Currency;
use Exception;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;

class RateTablePKGRateUpload extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'ratetablepkgfileupload';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Rate table Package file upload.';

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
            ['JobID', InputArgument::REQUIRED, 'Argument JobID'],
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
        $getmypid = getmypid(); // get proccess id added by abubakar
        $JobID = $arguments["JobID"];
        $job = Job::find($JobID);
        $p_UserName = $job->CreatedBy;

        $CompanyID = $arguments["CompanyID"];
        $bacth_insert_limit = 1000;
        $counter = 0;
        $DialStringId = 0;
        $dialcode_separator = 'null';
        Log::useFiles(storage_path() . '/logs/ratetablepkgfileupload-' .  $JobID. '-' . date('Y-m-d') . '.log');
        $TEMP_PATH = CompanyConfiguration::get($CompanyID,'TEMP_PATH').'/';
        $error = array();
        try {
            $ProcessID = CompanyGateway::getProcessID();
            Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar

            if (!empty($job)) {
                $jobfile = JobFile::where(['JobID' => $JobID])->first();
                $joboptions = json_decode($jobfile->Options);
                if (count($joboptions) > 0) {
                    $rateTable = RateTable::find($joboptions->RateTableID);

                    if(isset($joboptions->uploadtemplate) && !empty($joboptions->uploadtemplate)){
                        $uploadtemplate = FileUploadTemplate::find($joboptions->uploadtemplate);
                        $templateoptions = json_decode($uploadtemplate->Options);
                    }else{
                        $templateoptions = json_decode($joboptions->Options);
                    }

                    // get mapped code/package from template options
                    $MappedCodeList = !empty($templateoptions->MappedCodeList) ? json_decode($templateoptions->MappedCodeList,true) : [];
                    $CompareMappedCodeList = array();
                    foreach($MappedCodeList AS $key => $val){
                        $CompareMappedCodeList[$val['Code']] = $val;
                    }

                    $csvoption = $templateoptions->option;
                    $attrselection = $templateoptions->selection;

                    if (isset($attrselection->FromCurrency) && !empty($attrselection->FromCurrency)) {
                        $CurrencyConversion = 1;
                        $CurrencyID = $attrselection->FromCurrency;
                    } else {
                        $CurrencyConversion = 0;
                        $CurrencyID = 0;
                    }

                    if (empty($joboptions->ProcessID)) {
                        if ($jobfile->FilePath) {
                            $path = AmazonS3::unSignedUrl($jobfile->FilePath, $CompanyID);
                            if (strpos($path, "https://") !== false) {
                                $file = $TEMP_PATH . basename($path);
                                file_put_contents($file, file_get_contents($path));
                                $jobfile->FilePath = $file;
                            } else {
                                $jobfile->FilePath = $path;
                            }
                        }

                        $data = json_decode(json_encode($templateoptions), true);
                        $data['start_row'] = $data['skipRows']['start_row'];
                        $data['end_row'] = $data['skipRows']['end_row'];

                        //convert excel to CSV
                        $file_name = $file_name2 = $file_name_with_path = $jobfile->FilePath;
                        //$NeonExcel = new NeonExcelIO($file_name_with_path, $data['option'], $data['importratesheet']);
                        //$file_name = $NeonExcel->convertExcelToCSV($data);

                        if(isset($templateoptions->skipRows)) {
                            $skipRows              = $templateoptions->skipRows;

                            if($csvoption->Firstrow == 'columnname'){
                                $lineno                 = intval($skipRows->start_row) + 2;
                            }
                            if($csvoption->Firstrow == 'data'){
                                $lineno                 = intval($skipRows->start_row) + 1;
                            }
                            NeonExcelIO::$start_row = intval($skipRows->start_row);
                            NeonExcelIO::$end_row   = intval($skipRows->end_row);

                        } else if ($csvoption->Firstrow == 'data') {
                            $lineno = 1;
                        } else {
                            $lineno = 2;
                        }

                        $NeonExcel = new NeonExcelIO($file_name, (array) $csvoption, $data['importratesheet']);
                        $ratesheet = $NeonExcel->read();

                        $results = array();

                        $results = $ratesheet;

                        // if EndDate is mapped and not empty than data will store in and insert from $batch_insert_array
                        // if EndDate is mapped and     empty than data will store in and insert from $batch_insert_array2
                        $batch_insert_array = $batch_insert_array2 = [];

                        foreach ($attrselection as $key => $value) {
                            $attrselection->$key = str_replace("\r",'',$value);
                            $attrselection->$key = str_replace("\n",'',$attrselection->$key);
                        }

                        $error = array();

                        $CostComponents[] = 'OneOffCost';
                        $CostComponents[] = 'MonthlyCost';
                        $CostComponents[] = 'PackageCostPerMinute';
                        $CostComponents[] = 'RecordingCostPerMinute';

                        $prefixKeyword          = 'DBDATA-';
                        $includePrefix          = 1;
                        $component_currencies   = Currency::getCurrencyDropdownIDList($CompanyID,$includePrefix); // to check when currency mapped from DB
                        $component_currencies2  = Currency::getCurrencyDropdownIDList($CompanyID);  // to check when currency mapped from File
                        $component_currencies2  = array_map('strtolower', $component_currencies2);

                        //get how many rates mapped against timezones
                        $AllTimezones = Timezones::getTimezonesIDList();//all timezones

                        $lineno1 = $lineno;
                        foreach ($AllTimezones as $TimezoneID => $Title) {
                            $id = $TimezoneID == 1 ? '' : $TimezoneID;
                            $OneOffCostColumn                 = 'OneOffCost'.$id;
                            $MonthlyCostColumn                = 'MonthlyCost'.$id;
                            $PackageCostPerMinuteColumn       = 'PackageCostPerMinute'.$id;
                            $RecordingCostPerMinuteColumn     = 'RecordingCostPerMinute'.$id;

                            $OneOffCostCurrencyColumn               = 'OneOffCostCurrency'.$id;
                            $MonthlyCostCurrencyColumn              = 'MonthlyCostCurrency'.$id;
                            $PackageCostPerMinuteCurrencyColumn     = 'PackageCostPerMinuteCurrency'.$id;
                            $RecordingCostPerMinuteCurrencyColumn   = 'RecordingCostPerMinuteCurrency'.$id;

                            // check if rate is mapped against timezone
                            //if (!empty($attrselection->$MonthlyCostColumn)) {
                                $lineno = $lineno1;

                                foreach ($results as $temp_row) {
                                    if ($csvoption->Firstrow == 'data') {
                                        array_unshift($temp_row, null);
                                        unset($temp_row[0]);
                                    }

                                    /*foreach ($temp_row as $key => $value) {
                                        $key = str_replace("\r", '', $key);
                                        $key = str_replace("\n", '', $key);
                                        $temp_row[$key] = $value;
                                    }*/
                                    $temp_row = filterArrayRemoveNewLines($temp_row);

                                    $tempratetabledata = array();
                                    $tempratetabledata['codedeckid'] = $joboptions->codedeckid;
                                    $tempratetabledata['ProcessId'] = (string)$ProcessID;

                                    //check empty row
                                    $checkemptyrow = array_filter(array_values($temp_row));
                                    if (!empty($checkemptyrow)) {

                                        if (isset($attrselection->Code) && !empty($attrselection->Code)) {
                                            $selection_Code = $attrselection->Code;
                                            if (!empty($selection_Code) && isset($temp_row[$selection_Code]) && trim($temp_row[$selection_Code]) != '') {
                                                $tempratetabledata['Code'] = trim($temp_row[$selection_Code]);
                                                $tempratetabledata['Description'] = $tempratetabledata['Code'];
                                            } else {
                                                $error[] = 'Package Name is blank at line no:' . $lineno;
                                            }
                                        }

                                        if (isset($attrselection->Action) && !empty($attrselection->Action)) {
                                            if (empty($temp_row[$attrselection->Action])) {
                                                $tempratetabledata['Change'] = 'I';
                                            } else {
                                                $action_value = $temp_row[$attrselection->Action];
                                                if (isset($attrselection->ActionDelete) && !empty($attrselection->ActionDelete) && trim(strtolower($action_value)) == trim(strtolower($attrselection->ActionDelete))) {
                                                    $tempratetabledata['Change'] = 'D';
                                                } else if (isset($attrselection->ActionUpdate) && !empty($attrselection->ActionUpdate) && trim(strtolower($action_value)) == trim(strtolower($attrselection->ActionUpdate))) {
                                                    $tempratetabledata['Change'] = 'U';
                                                } else if (isset($attrselection->ActionInsert) && !empty($attrselection->ActionInsert) && trim(strtolower($action_value)) == trim(strtolower($attrselection->ActionInsert))) {
                                                    $tempratetabledata['Change'] = 'I';
                                                } else {
                                                    $tempratetabledata['Change'] = 'I';
                                                }
                                            }

                                        } else {
                                            $tempratetabledata['Change'] = 'I';
                                        }

                                        $CostComponentsMapped = 0;

                                        if (!empty($attrselection->$OneOffCostColumn) && isset($temp_row[$attrselection->$OneOffCostColumn]) && trim($temp_row[$attrselection->$OneOffCostColumn]) != '') {
                                            $tempratetabledata['OneOffCost'] = trim($temp_row[$attrselection->$OneOffCostColumn]);
                                            $CostComponentsMapped++;
                                        } else {
                                            $tempratetabledata['OneOffCost'] = NULL;
                                        }

                                        if (!empty($attrselection->$MonthlyCostColumn) && isset($temp_row[$attrselection->$MonthlyCostColumn]) && trim($temp_row[$attrselection->$MonthlyCostColumn]) != '') {
                                            $tempratetabledata['MonthlyCost'] = trim($temp_row[$attrselection->$MonthlyCostColumn]);
                                            $CostComponentsMapped++;
                                        } else {
                                            $tempratetabledata['MonthlyCost'] = NULL;
                                        }

                                        if (!empty($attrselection->$PackageCostPerMinuteColumn) && isset($temp_row[$attrselection->$PackageCostPerMinuteColumn]) && trim($temp_row[$attrselection->$PackageCostPerMinuteColumn]) != '') {
                                            $tempratetabledata['PackageCostPerMinute'] = trim($temp_row[$attrselection->$PackageCostPerMinuteColumn]);
                                            $CostComponentsMapped++;
                                        } else {
                                            $tempratetabledata['PackageCostPerMinute'] = NULL;
                                        }

                                        if (!empty($attrselection->$RecordingCostPerMinuteColumn) && isset($temp_row[$attrselection->$RecordingCostPerMinuteColumn]) && trim($temp_row[$attrselection->$RecordingCostPerMinuteColumn]) != '') {
                                            $tempratetabledata['RecordingCostPerMinute'] = trim($temp_row[$attrselection->$RecordingCostPerMinuteColumn]);
                                            $CostComponentsMapped++;
                                        } else {
                                            $tempratetabledata['RecordingCostPerMinute'] = NULL;
                                        }

                                        if($CostComponentsMapped > 0) {
                                            $CostComponentsError = 1;
                                            foreach ($CostComponents as $key => $component) {
                                                if ($tempratetabledata[$component] != NULL) {
                                                    $CostComponentsError = 0;
                                                    break;
                                                }
                                            }
                                        } else {
                                            $CostComponentsError = 0;
                                        }
                                        if($CostComponentsError==1) {
                                            $error[] = 'All Cost Component is blank at line no:' . $lineno;
                                        }

                                        if (!empty($attrselection->$OneOffCostCurrencyColumn)) {
                                            if(array_key_exists($attrselection->$OneOffCostCurrencyColumn, $component_currencies)) {// if currency selected from Neon Currencies
                                                $tempratetabledata['OneOffCostCurrency'] = str_replace($prefixKeyword,'',$attrselection->$OneOffCostCurrencyColumn);
                                            } else if(isset($temp_row[$attrselection->$OneOffCostCurrencyColumn]) && array_search(strtolower($temp_row[$attrselection->$OneOffCostCurrencyColumn]),$component_currencies2)) {// if currency selected from file
                                                $tempratetabledata['OneOffCostCurrency'] = array_search(strtolower($temp_row[$attrselection->$OneOffCostCurrencyColumn]),$component_currencies2);
                                            } else {
                                                $tempratetabledata['OneOffCostCurrency'] = NULL;
                                                $error[] = 'One-Off Cost Currency is not match at line no:' . $lineno;
                                            }
                                        } else {
                                            $tempratetabledata['OneOffCostCurrency'] = NULL;
                                        }

                                        if (!empty($attrselection->$MonthlyCostCurrencyColumn)) {
                                            if(array_key_exists($attrselection->$MonthlyCostCurrencyColumn, $component_currencies)) {// if currency selected from Neon Currencies
                                                $tempratetabledata['MonthlyCostCurrency'] = str_replace($prefixKeyword,'',$attrselection->$MonthlyCostCurrencyColumn);
                                            } else if(isset($temp_row[$attrselection->$MonthlyCostCurrencyColumn]) && array_search(strtolower($temp_row[$attrselection->$MonthlyCostCurrencyColumn]),$component_currencies2)) {// if currency selected from file
                                                $tempratetabledata['MonthlyCostCurrency'] = array_search(strtolower($temp_row[$attrselection->$MonthlyCostCurrencyColumn]),$component_currencies2);
                                            } else {
                                                $tempratetabledata['MonthlyCostCurrency'] = NULL;
                                                $error[] = 'Monthly Cost Currency is not match at line no:' . $lineno;
                                            }
                                        } else {
                                            $tempratetabledata['MonthlyCostCurrency'] = NULL;
                                        }

                                        if (!empty($attrselection->$PackageCostPerMinuteCurrencyColumn)) {
                                            if(array_key_exists($attrselection->$PackageCostPerMinuteCurrencyColumn, $component_currencies)) {// if currency selected from Neon Currencies
                                                $tempratetabledata['PackageCostPerMinuteCurrency'] = str_replace($prefixKeyword,'',$attrselection->$PackageCostPerMinuteCurrencyColumn);
                                            } else if(isset($temp_row[$attrselection->$PackageCostPerMinuteCurrencyColumn]) && array_search(strtolower($temp_row[$attrselection->$PackageCostPerMinuteCurrencyColumn]),$component_currencies2)) {// if currency selected from file
                                                $tempratetabledata['PackageCostPerMinuteCurrency'] = array_search(strtolower($temp_row[$attrselection->$PackageCostPerMinuteCurrencyColumn]),$component_currencies2);
                                            } else {
                                                $tempratetabledata['PackageCostPerMinuteCurrency'] = NULL;
                                                $error[] = 'Cost Per Call Currency is not match at line no:' . $lineno;
                                            }
                                        } else {
                                            $tempratetabledata['PackageCostPerMinuteCurrency'] = NULL;
                                        }

                                        if (!empty($attrselection->$RecordingCostPerMinuteCurrencyColumn)) {
                                            if(array_key_exists($attrselection->$RecordingCostPerMinuteCurrencyColumn, $component_currencies)) {// if currency selected from Neon Currencies
                                                $tempratetabledata['RecordingCostPerMinuteCurrency'] = str_replace($prefixKeyword,'',$attrselection->$RecordingCostPerMinuteCurrencyColumn);
                                            } else if(isset($temp_row[$attrselection->$RecordingCostPerMinuteCurrencyColumn]) && array_search(strtolower($temp_row[$attrselection->$RecordingCostPerMinuteCurrencyColumn]),$component_currencies2)) {// if currency selected from file
                                                $tempratetabledata['RecordingCostPerMinuteCurrency'] = array_search(strtolower($temp_row[$attrselection->$RecordingCostPerMinuteCurrencyColumn]),$component_currencies2);
                                            } else {
                                                $tempratetabledata['RecordingCostPerMinuteCurrency'] = NULL;
                                                $error[] = 'Cost Per Minute Currency is not match at line no:' . $lineno;
                                            }
                                        } else {
                                            $tempratetabledata['RecordingCostPerMinuteCurrency'] = NULL;
                                        }

                                        if (!empty($attrselection->EffectiveDate)) {
                                            $selection_EffectiveDate = $attrselection->EffectiveDate;
                                            $selection_dateformat = $attrselection->DateFormat;

                                            if (isset($selection_EffectiveDate) && !empty($selection_EffectiveDate) && !empty($temp_row[$selection_EffectiveDate])) {
                                                try {
                                                    $tempratetabledata['EffectiveDate'] = formatSmallDate(str_replace('/', '-', $temp_row[$selection_EffectiveDate]), $selection_dateformat);
                                                } catch (\Exception $e) {
                                                    $error[] = 'Date format is Wrong  at line no:' . $lineno;
                                                }
                                            } elseif (empty($selection_EffectiveDate)) {
                                                $tempratetabledata['EffectiveDate'] = date('Y-m-d');
                                            } elseif ($tempratetabledata['Change'] == 'D') {
                                                $tempratetabledata['EffectiveDate'] = date('Y-m-d');
                                            } elseif ($tempratetabledata['Change'] != 'D') {
                                                $error[] = 'EffectiveDate is blank at line no:' . $lineno;
                                            }
                                        } else {
                                            $tempratetabledata['EffectiveDate'] = date('Y-m-d');
                                        }

                                        if (isset($attrselection->EndDate) && !empty($attrselection->EndDate) && !empty($temp_row[$attrselection->EndDate])) {
                                            try {
                                                $tempratetabledata['EndDate'] = formatSmallDate(str_replace('/', '-', $temp_row[$attrselection->EndDate]), $attrselection->DateFormat);
                                            } catch (\Exception $e) {
                                                $error[] = 'Date format is Wrong  at line no:' . $lineno;
                                            }
                                        }

                                        $tempratetabledata['TimezonesID'] = $TimezoneID;

                                        if (isset($tempratetabledata['Code']) && isset($tempratetabledata['Description']) && ($CostComponentsMapped>0 || $tempratetabledata['Change'] == 'D') && isset($tempratetabledata['EffectiveDate'])) {

                                            $check_code_key = $tempratetabledata['Code'];
                                            if(array_key_exists($check_code_key,$CompareMappedCodeList)) {
                                                $tempratetabledata['Code'] = $CompareMappedCodeList[$check_code_key]['CodeValue'];
                                            }

                                            if (isset($tempratetabledata['EndDate'])) {
                                                $batch_insert_array[] = $tempratetabledata;
                                            } else {
                                                $batch_insert_array2[] = $tempratetabledata;
                                            }
                                            $counter++;
                                        }
                                    }
                                    if ($counter == $bacth_insert_limit) {
                                        Log::info('Batch insert start');
                                        Log::info('global counter' . $lineno);
                                        Log::info('insertion start');
                                        if(!empty($batch_insert_array)) {
                                            TempRateTablePKGRate::insert($batch_insert_array);
                                        }
                                        if(!empty($batch_insert_array2)) {
                                            TempRateTablePKGRate::insert($batch_insert_array2);
                                        }
                                        Log::info('insertion end');
                                        $batch_insert_array = [];
                                        $batch_insert_array2 = [];
                                        $counter = 0;
                                    }
                                    $lineno++;
                                } // loop over
                            //} // if rate is mapped against timezone condition

                            if(!empty($batch_insert_array) || !empty($batch_insert_array2)){
                                Log::info('Batch insert start');
                                Log::info('global counter' . $lineno);
                                Log::info('insertion start');
                                Log::info('last batch insert ' . count($batch_insert_array));
                                Log::info('last batch insert 2 ' . count($batch_insert_array2));
                                if(!empty($batch_insert_array)) {
                                    TempRateTablePKGRate::insert($batch_insert_array);
                                }
                                if(!empty($batch_insert_array2)) {
                                    TempRateTablePKGRate::insert($batch_insert_array2);
                                }
                                Log::info('insertion end');
                                $batch_insert_array = [];
                                $batch_insert_array2 = [];
                                $counter = 0;
                            }
                        } // $Ratekeys loop over

                    } else {
                        $ProcessID = $joboptions->ProcessID;
                    }
                    $JobStatusMessage = array();
                    $duplicatecode=0;

                    $RateApprovalProcess = CompanySetting::getKeyVal($CompanyID,'RateApprovalProcess');
                    if($RateApprovalProcess == 1 && $rateTable->AppliedTo != RateTable::APPLIED_TO_VENDOR) {
                        $query = "CALL  prc_WSProcessRateTablePKGRateAA ('" . $joboptions->RateTableID . "','" . $joboptions->checkbox_replace_all . "','" . $joboptions->checkbox_rates_with_effected_from . "','" . $ProcessID . "','" . $joboptions->checkbox_add_new_codes_to_code_decks . "','" . $CompanyID . "'," . $CurrencyID . "," . $joboptions->radio_list_option . ",'" . $p_UserName . "')";
                    } else {
                        $query = "CALL  prc_WSProcessRateTablePKGRate ('" . $joboptions->RateTableID . "','" . $joboptions->checkbox_replace_all . "','" . $joboptions->checkbox_rates_with_effected_from . "','" . $ProcessID . "','" . $joboptions->checkbox_add_new_codes_to_code_decks . "','" . $CompanyID . "'," . $CurrencyID . "," . $joboptions->radio_list_option . ",'" . $p_UserName . "')";
                    }
                    Log::info("start " . $query);

                    try {
                        DB::beginTransaction();
                        $JobStatusMessage = DB::select($query);
                        Log::info("end " . $query);
                        DB::commit();

                        $JobStatusMessage = array_reverse(json_decode(json_encode($JobStatusMessage), true));
                        Log::info($JobStatusMessage);
                        Log::info(count($JobStatusMessage));
                        if (!empty($error) || count($JobStatusMessage) > 1) {
                            $prc_error = array();
                            foreach ($JobStatusMessage as $JobStatusMessage1) {
                                $prc_error[] = $JobStatusMessage1['Message'];
                                if (strpos($JobStatusMessage1['Message'], 'DUPLICATE PACKAGE NAME') !== false) {
                                    $duplicatecode = 1;
                                }
                            }
                            $job = Job::find($JobID);
                            if ($duplicatecode == 1) {
                                $error = array_merge($prc_error, $error);
                                unset($error[0]);
                                $jobdata['JobStatusMessage'] = implode(',\n\r', fix_jobstatus_meassage($error));
                                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                            } else {
                                $error = array_merge($prc_error, $error);
                                $jobdata['JobStatusMessage'] = implode(',\n\r', fix_jobstatus_meassage($error));
                                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'PF')->pluck('JobStatusID');
                            }
                            //$jobdata['JobStatusMessage'] = implode(',\n\r',$error);
                            $jobdata['updated_at'] = date('Y-m-d H:i:s');
                            $jobdata['ModifiedBy'] = 'RMScheduler';
                            Log::info($jobdata);
                            Job::where(["JobID" => $JobID])->update($jobdata);
                        } elseif (!empty($JobStatusMessage[0]['Message'])) {
                            $job = Job::find($JobID);
                            $jobdata['JobStatusMessage'] = $JobStatusMessage[0]['Message'];
                            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'S')->pluck('JobStatusID');
                            $jobdata['updated_at'] = date('Y-m-d H:i:s');
                            $jobdata['ModifiedBy'] = 'RMScheduler';
                            Job::where(["JobID" => $JobID])->update($jobdata);
                        }

                    } catch (Exception $err) {
                        DB::rollback();
                        Log::error($err);

                        $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                        $jobdata['JobStatusMessage'] = 'Exception: ' . $err->getMessage();
                        $jobdata['updated_at'] = date('Y-m-d H:i:s');
                        $jobdata['ModifiedBy'] = 'RMScheduler';
                        Job::where(["JobID" => $JobID])->update($jobdata);
                        Log::error($err);
                    }
                }
            }

        } catch (\Exception $e) {
            try{
                DB::rollback();
            }catch (Exception $err) {
                Log::error($err);
            }
            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
            $jobdata['JobStatusMessage'] = 'Exception: ' . $e->getMessage();
            $jobdata['updated_at'] = date('Y-m-d H:i:s');
            $jobdata['ModifiedBy'] = 'RMScheduler';
            Job::where(["JobID" => $JobID])->update($jobdata);
            Log::error($e);
        }
        Job::send_job_status_email($job,$CompanyID);

        CronHelper::after_cronrun($this->name, $this);

    }

}