<?php
/**
 * Created by PhpStorm.
 * User: srs2
 * Date: 25/05/2015
 * Time: 06:58
 */
//if you change anything in this file then you need to change also in VendorRateUpload in service and RateUploadController.php->ReviewRates() in web

namespace App\Console\Commands;

use App\Lib\AmazonS3;
use App\Lib\CompanyConfiguration;
use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\Job;
use App\Lib\JobFile;
use App\Lib\NeonExcelIO;
use App\Lib\TempRateTableRate;
use App\Lib\FileUploadTemplate;
use App\Lib\Timezones;
use Exception;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;

class RateTableRateUpload extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'ratetablefileupload';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Rate table file upload.';

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
        $ProcessID = CompanyGateway::getProcessID();
        Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar
        $CompanyID = $arguments["CompanyID"];
        $bacth_insert_limit = 250;
        $counter = 0;
        $p_forbidden = 0;
        $p_preference = 0;
        $DialStringId = 0;
        $dialcode_separator = 'null';
        Log::useFiles(storage_path() . '/logs/ratetablefileupload-' .  $JobID. '-' . date('Y-m-d') . '.log');
        $TEMP_PATH = CompanyConfiguration::get($CompanyID,'TEMP_PATH').'/';
        $error = array();
        try {

            if (!empty($job)) {
                $jobfile = JobFile::where(['JobID' => $JobID])->first();
                $joboptions = json_decode($jobfile->Options);
                if (count($joboptions) > 0) {

                    if(isset($joboptions->uploadtemplate) && !empty($joboptions->uploadtemplate)){
                        $uploadtemplate = FileUploadTemplate::find($joboptions->uploadtemplate);
                        $templateoptions = json_decode($uploadtemplate->Options);
                    }else{
                        $templateoptions = json_decode($joboptions->Options);
                    }
                    $csvoption = $templateoptions->option;
                    $attrselection = $templateoptions->selection;
                    if(!empty($templateoptions->importdialcodessheet)) {
                        $attrselection2 = $templateoptions->selection2;
                    }

                    // check dialstring mapping or not
                    if (isset($attrselection->DialString) && !empty($attrselection->DialString)) {
                        $DialStringId = $attrselection->DialString;
                    } else {
                        $DialStringId = 0;
                    }
                    if (isset($attrselection->Forbidden) && !empty($attrselection->Forbidden)) {
                        $p_forbidden = 1;
                    }
                    if (isset($attrselection->Preference) && !empty($attrselection->Preference)) {
                        $p_preference = 1;
                    }

                    if (isset($attrselection->DialCodeSeparator)) {
                        if ($attrselection->DialCodeSeparator == '') {
                            $dialcode_separator = 'null';
                        } else {
                            $dialcode_separator = $attrselection->DialCodeSeparator;
                        }
                    } /*else {
                        $dialcode_separator = 'null';
                    }*/
                    if(isset($attrselection2->DialCodeSeparator)){
                        if($attrselection2->DialCodeSeparator == ''){
                            $dialcode_separator = 'null';
                        }else{
                            $dialcode_separator = $attrselection2->DialCodeSeparator;
                        }
                    }

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
                        if(!empty($data['importdialcodessheet'])) {
                            $data['start_row_sheet2'] = $data['skipRows_sheet2']['start_row'];
                            $data['end_row_sheet2'] = $data['skipRows_sheet2']['end_row'];
                        }
                        //convert excel to CSV
                        $file_name_with_path = $jobfile->FilePath;
                        $NeonExcel = new NeonExcelIO($file_name_with_path, $data['option'], $data['importratesheet']);
                        $file_name = $NeonExcel->convertExcelToCSV($data);

                        if(!empty($data['importdialcodessheet'])) {
                            $data2 = $data;
                            $data2['start_row'] = $data["start_row_sheet2"];
                            $data2['end_row'] = $data["end_row_sheet2"];
                            $NeonExcelSheet2 = new NeonExcelIO($file_name_with_path, $data2['option'], $data2['importdialcodessheet']);
                            $file_name2 = $NeonExcelSheet2->convertExcelToCSV($data2);
                        }

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

                        $NeonExcel = new NeonExcelIO($file_name, (array) $csvoption);
                        $ratesheet = $NeonExcel->read();

                        if(!empty($data['importdialcodessheet'])) {
                            $skipRows_sheet2 = $templateoptions->skipRows_sheet2;
                            NeonExcelIO::$start_row = intval($skipRows_sheet2->start_row);
                            NeonExcelIO::$end_row = intval($skipRows_sheet2->end_row);
                            $NeonExcel2 = new NeonExcelIO($file_name2, (array)$csvoption);
                            $dialcodessheet = $NeonExcel2->read();
                        }

                        if(!empty($data['importdialcodessheet'])) {
                            $Join1 = $data["selection"]['Join1'];
                            $Join2 = $data["selection2"]['Join2'];
                            foreach($ratesheet as $key => $value)
                            {
                                foreach($dialcodessheet as $key1 => $value1)
                                {
                                    if($value[$Join1] == $value1[$Join2])
                                    {
                                        $results[$key1] = array_merge($value1, $ratesheet[$key]);
                                    }
                                    unset($results[$key1][""]);
                                }
                            }
                        }else{
                            $results = $ratesheet;
                        }

                        // if EndDate is mapped and not empty than data will store in and insert from $batch_insert_array
                        // if EndDate is mapped and     empty than data will store in and insert from $batch_insert_array2
                        $batch_insert_array = $batch_insert_array2 = [];

                        foreach ($attrselection as $key => $value) {
                            $attrselection->$key = str_replace("\r",'',$value);
                            $attrselection->$key = str_replace("\n",'',$attrselection->$key);
                        }
                        if(!empty($data['importdialcodessheet'])) {
                            foreach ($attrselection2 as $key => $value) {
                                $attrselection2->$key = str_replace("\r", '', $value);
                                $attrselection2->$key = str_replace("\n", '', $attrselection2->$key);
                            }
                        }

                        $error = array();

                        //get how many rates mapped against timezones
                        $AllTimezones = Timezones::getTimezonesIDList();//all timezones

                        $lineno1 = $lineno;
                        foreach ($AllTimezones as $TimezoneID => $Title) {
                            $id = $TimezoneID == 1 ? '' : $TimezoneID;
                            $Rate1Column            = 'Rate'.$id;
                            $RateNColumn            = 'RateN'.$id;
                            $Interval1Column        = 'Interval1'.$id;
                            $IntervalNColumn        = 'IntervalN'.$id;
                            $PreferenceColumn       = 'Preference'.$id;
                            $ConnectionFeeColumn    = 'ConnectionFee'.$id;
                            $ForbiddenColumn        = 'Forbidden'.$id;

                            // check if rate is mapped against timezone
                            if (!empty($attrselection->$Rate1Column)) {
                                $lineno = $lineno1;
                                foreach ($results as $temp_row) {
                                    if ($csvoption->Firstrow == 'data') {
                                        array_unshift($temp_row, null);
                                        unset($temp_row[0]);
                                    }

                                    foreach ($temp_row as $key => $value) {
                                        $key = str_replace("\r", '', $key);
                                        $key = str_replace("\n", '', $key);
                                        $temp_row[$key] = $value;
                                    }

                                    $tempratetabledata = array();
                                    $tempratetabledata['codedeckid'] = $joboptions->codedeckid;
                                    $tempratetabledata['ProcessId'] = (string)$ProcessID;

                                    //check empty row
                                    $checkemptyrow = array_filter(array_values($temp_row));
                                    if (!empty($checkemptyrow)) {
                                        if (!empty($attrselection->CountryCode) || !empty($attrselection2->CountryCode)) {
                                            if (!empty($attrselection->CountryCode)) {
                                                $selection_CountryCode = $attrselection->CountryCode;
                                            } else if (!empty($attrselection2->CountryCode)) {
                                                $selection_CountryCode = $attrselection2->CountryCode;
                                            }
                                            if (isset($selection_CountryCode) && !empty($selection_CountryCode) && !empty($temp_row[$selection_CountryCode])) {
                                                $tempratetabledata['CountryCode'] = trim($temp_row[$selection_CountryCode]);
                                            } else {
                                                $tempratetabledata['CountryCode'] = '';
                                            }
                                        }

                                        if (!empty($attrselection->Code) || !empty($attrselection2->Code)) {
                                            if (!empty($attrselection->Code)) {
                                                $selection_Code = $attrselection->Code;
                                            } else if (!empty($attrselection2->Code)) {
                                                $selection_Code = $attrselection2->Code;
                                            }
                                            if (isset($selection_Code) && !empty($selection_Code) && trim($temp_row[$selection_Code]) != '') {
                                                $tempratetabledata['Code'] = trim($temp_row[$selection_Code]);
                                            } else if (!empty($tempratetabledata['CountryCode'])) {
                                                $tempratetabledata['Code'] = "";  // if code is blank but country code is not blank than mark code as blank., it will be merged with countr code later ie 91 - 1 -> 911
                                            } else {
                                                $error[] = 'Code is blank at line no:' . $lineno;
                                            }
                                        }

                                        if (!empty($attrselection->Description) || !empty($attrselection2->Description)) {
                                            if (!empty($attrselection->Description)) {
                                                $selection_Description = $attrselection->Description;
                                            } else if (!empty($attrselection2->Description)) {
                                                $selection_Description = $attrselection2->Description;
                                            }
                                            if (isset($selection_Description) && !empty($selection_Description) && !empty($temp_row[$selection_Description])) {
                                                $tempratetabledata['Description'] = $temp_row[$selection_Description];
                                            } else {
                                                $error[] = 'Description is blank at line no:' . $lineno;
                                            }
                                        }

                                        /*if (isset($attrselection->FromCurrency) && !empty($attrselection->FromCurrency) && $attrselection->FromCurrency != 0) {
                                            $tempratetabledata['CurrencyID'] = $attrselection->FromCurrency;
                                        }*/

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

                                        if (isset($attrselection->$Rate1Column) && !empty($attrselection->$Rate1Column)) {
                                            $temp_row[$attrselection->$Rate1Column] = preg_replace('/[^.0-9\-]/', '', $temp_row[$attrselection->$Rate1Column]); //remove anything but numbers and 0 (only allow numbers,-dash,.dot)
                                            if (is_numeric(trim($temp_row[$attrselection->$Rate1Column]))) {
                                                $tempratetabledata['Rate'] = trim($temp_row[$attrselection->$Rate1Column]);
                                            } else {
                                                $error[] = 'Rate is not numeric at line no:' . $lineno;
                                            }
                                        } elseif ($tempratetabledata['Change'] == 'D') {
                                            $tempratetabledata['Rate'] = 0;
                                        } elseif ($tempratetabledata['Change'] != 'D') {
                                            $error[] = 'Rate is blank at line no:' . $lineno;
                                        }

                                        if (isset($attrselection->$RateNColumn) && !empty($attrselection->$RateNColumn)) {
                                            $tempratetabledata['RateN'] = trim($temp_row[$attrselection->$RateNColumn]);
                                        } else if(isset($tempratetabledata['Rate'])) {
                                            $tempratetabledata['RateN'] = $tempratetabledata['Rate'];
                                        }

                                        if (!empty($attrselection->EffectiveDate) || !empty($attrselection2->EffectiveDate)) {
                                            if (!empty($attrselection->EffectiveDate)) {
                                                $selection_EffectiveDate = $attrselection->EffectiveDate;
                                                $selection_dateformat = $attrselection->DateFormat;
                                            } else if (!empty($attrselection2->EffectiveDate)) {
                                                $selection_EffectiveDate = $attrselection2->EffectiveDate;
                                                $selection_dateformat = $attrselection2->DateFormat;
                                            }

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

                                        if (isset($attrselection->$ConnectionFeeColumn) && !empty($attrselection->$ConnectionFeeColumn)) {
                                            $tempratetabledata['ConnectionFee'] = trim($temp_row[$attrselection->$ConnectionFeeColumn]);
                                        }
                                        if (isset($attrselection->$Interval1Column) && !empty($attrselection->$Interval1Column)) {
                                            $tempratetabledata['Interval1'] = intval(trim($temp_row[$attrselection->$Interval1Column]));
                                        }
                                        if (isset($attrselection->$IntervalNColumn) && !empty($attrselection->$IntervalNColumn)) {
                                            $tempratetabledata['IntervalN'] = intval(trim($temp_row[$attrselection->$IntervalNColumn]));
                                        }
                                        if (!empty($DialStringId)) {
                                            if (isset($attrselection->DialStringPrefix) && !empty($attrselection->DialStringPrefix)) {
                                                $tempratetabledata['DialStringPrefix'] = trim($temp_row[$attrselection->DialStringPrefix]);
                                            } else {
                                                $tempratetabledata['DialStringPrefix'] = '';
                                            }
                                        }

                                        $tempratetabledata['TimezonesID'] = $TimezoneID;

                                        if (isset($tempratetabledata['Code']) && isset($tempratetabledata['Description']) && (isset($tempratetabledata['Rate']) || $tempratetabledata['Change'] == 'D') && isset($tempratetabledata['EffectiveDate'])) {
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
                                            TempRateTableRate::insert($batch_insert_array);
                                        }
                                        if(!empty($batch_insert_array2)) {
                                            TempRateTableRate::insert($batch_insert_array2);
                                        }
                                        Log::info('insertion end');
                                        $batch_insert_array = [];
                                        $batch_insert_array2 = [];
                                        $counter = 0;
                                    }
                                    $lineno++;
                                } // loop over
                            } // if rate is mapped against timezone condition

                            if(!empty($batch_insert_array) || !empty($batch_insert_array2)){
                                Log::info('Batch insert start');
                                Log::info('global counter' . $lineno);
                                Log::info('insertion start');
                                Log::info('last batch insert ' . count($batch_insert_array));
                                Log::info('last batch insert 2 ' . count($batch_insert_array2));
                                if(!empty($batch_insert_array)) {
                                    TempRateTableRate::insert($batch_insert_array);
                                }
                                if(!empty($batch_insert_array2)) {
                                    TempRateTableRate::insert($batch_insert_array2);
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

                    $query = "CALL  prc_WSProcessRateTableRate ('" . $joboptions->RateTableID . "','" . $joboptions->checkbox_replace_all . "','" . $joboptions->checkbox_rates_with_effected_from . "','" . $ProcessID . "','" . $joboptions->checkbox_add_new_codes_to_code_decks . "','" . $CompanyID . "','".$p_forbidden."','".$p_preference."','".$DialStringId."','".$dialcode_separator."',".$CurrencyID.",".$joboptions->radio_list_option.",'".$p_UserName."')";

                    Log::info("start ".$query);

                    try{
                        DB::beginTransaction();
                        $JobStatusMessage = DB::select($query);
                        Log::info("end ".$query);
                        DB::commit();

                        $JobStatusMessage = array_reverse(json_decode(json_encode($JobStatusMessage),true));
                        Log::info($JobStatusMessage);
                        Log::info(count($JobStatusMessage));
                        if(!empty($error) || count($JobStatusMessage) > 1){
                            $prc_error = array();
                            foreach ($JobStatusMessage as $JobStatusMessage1) {
                                $prc_error[] = $JobStatusMessage1['Message'];
                                if(strpos($JobStatusMessage1['Message'], 'DUPLICATE CODE') !==false){
                                    $duplicatecode = 1;
                                }
                            }
                            $job = Job::find($JobID);
                            if($duplicatecode == 1){
                                $error = array_merge($prc_error,$error);
                                unset($error[0]);
                                $jobdata['JobStatusMessage'] = implode(',\n\r',fix_jobstatus_meassage($error));
                                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','F')->pluck('JobStatusID');
                            }else{
                                $error = array_merge($prc_error,$error);
                                $jobdata['JobStatusMessage'] = implode(',\n\r',fix_jobstatus_meassage($error));
                                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','PF')->pluck('JobStatusID');
                            }
                            //$jobdata['JobStatusMessage'] = implode(',\n\r',$error);
                            $jobdata['updated_at'] = date('Y-m-d H:i:s');
                            $jobdata['ModifiedBy'] = 'RMScheduler';
                            Log::info($jobdata);
                            Job::where(["JobID" => $JobID])->update($jobdata);
                        }elseif(!empty($JobStatusMessage[0]['Message'])){
                            $job = Job::find($JobID);
                            $jobdata['JobStatusMessage'] = $JobStatusMessage[0]['Message'];
                            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','S')->pluck('JobStatusID');
                            $jobdata['updated_at'] = date('Y-m-d H:i:s');
                            $jobdata['ModifiedBy'] = 'RMScheduler';
                            Job::where(["JobID" => $JobID])->update($jobdata);
                        }

                    }catch ( Exception $err ){
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