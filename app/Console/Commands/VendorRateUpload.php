<?php
/**
 * Created by PhpStorm.
 * User: srs2
 * Date: 25/05/2015
 * Time: 06:58
 */

namespace App\Console\Commands;

use App\Lib\AmazonS3;
use App\Lib\CompanyConfiguration;
use App\Lib\CronHelper;
use App\Lib\Job;
use App\Lib\JobFile;
use App\Lib\NeonExcelIO;
use App\Lib\TempVendorRate;
use App\Lib\FileUploadTemplate;
use App\Lib\Currency;
use App\Lib\Company;
use App\Lib\Account;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Facades\Excel;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;
use \Exception;

class VendorRateUpload extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'vendorfileupload';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Vendor file upload.';

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
        $ProcessID = Uuid::generate();
        Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Update by Abubakar
        $CompanyID = $arguments["CompanyID"];
        $bacth_insert_limit = 250;
        $counter = 0;
        $p_forbidden = 0;
        $p_preference = 0;
        $DialStringId = 0;
        $dialcode_separator = 'null';
        Log::useFiles(storage_path() . '/logs/vendorfileupload-' .  $JobID. '-' . date('Y-m-d') . '.log');
        $TEMP_PATH = CompanyConfiguration::get($CompanyID,'TEMP_PATH').'/';
        $error = array();
        try {

            if (!empty($job)) {
                $jobfile = JobFile::where(['JobID' => $JobID])->first();
                $joboptions = json_decode($jobfile->Options);
                if (count($joboptions) > 0) {
                    if (isset($joboptions->uploadtemplate) && !empty($joboptions->uploadtemplate)) {
                        $uploadtemplate = FileUploadTemplate::find($joboptions->uploadtemplate);
                        $templateoptions = json_decode($uploadtemplate->Options);
                    } else {
                        $templateoptions = json_decode($joboptions->Options);
                    }
                    $csvoption = $templateoptions->option;
                    $attrselection = $templateoptions->selection;
                    if(isset($templateoptions->importdialcodessheet) && !empty($templateoptions->importdialcodessheet)) {
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
                    }
                    /*else {
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
                        /*$FromCurrency = Currency::find($attrselection->FromCurrency);
                        $AccountCurrency = Currency::find(Account::find($job->AccountID)->CurrencyId);
                        $CompanyCurrency = Currency::find(Company::find($CompanyID)->CurrencyId);*/
                    } else {
                        $CurrencyConversion = 0;
                        $CurrencyID = 0;
                    }
                    /*if($CurrencyConversion == 1 && $FromCurrency && $ToCurrency && $FromCurrency->CurrencyId != $ToCurrency->CurrencyId) {
                        Log::info('From Currency : ' . $FromCurrency->Code);
                        Log::info('To Currency : ' . $ToCurrency->Code);
                    }*/

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
                        };

                       /* if(isset($templateoptions->skipRows) && $csvoption->Firstrow == 'columnname') {
                            $skiptRows              = $templateoptions->skipRows;
                            NeonExcelIO::$start_row = intval($skiptRows->start_row);
                            NeonExcelIO::$end_row   = intval($skiptRows->end_row);
                            $lineno                 = intval($skiptRows->start_row) + 2;
                        } else if (isset($templateoptions->skipRows) && $csvoption->Firstrow == 'data') {
                            $skiptRows              = $templateoptions->skipRows;
                            NeonExcelIO::$start_row = intval($skiptRows->start_row);
                            NeonExcelIO::$end_row   = intval($skiptRows->end_row);
                            $lineno                 = intval($skiptRows->start_row) + 1;
                        } else if ($csvoption->Firstrow == 'data') {
                            $lineno = 1;
                        } else {
                            $lineno = 2;
                        }
                        $Sheet = !empty($templateoptions->Sheet) ? $templateoptions->Sheet : '';
                        $NeonExcel = new NeonExcelIO($jobfile->FilePath, (array)$csvoption, $Sheet);
                        $results = $NeonExcel->read();*/
                        /*Log::info(print_r(array_slice($results,0,10),true));
                        Log::info(print_r(array_slice($results,-10,10),true));*/
                        
                        $data = json_decode(json_encode($templateoptions), true);
                        $data['start_row'] = $data['skipRows']['start_row'];
                        $data['end_row'] = $data['skipRows']['end_row'];
                        if(isset($data['importdialcodessheet']) && !empty($data['importdialcodessheet'])) {
                            $data['start_row_sheet2'] = $data['skipRows_sheet2']['start_row'];
                            $data['end_row_sheet2'] = $data['skipRows_sheet2']['end_row'];
                        }

                        //convert excel to CSV
                        $file_name_with_path = $jobfile->FilePath;
                        $NeonExcel = new NeonExcelIO($file_name_with_path, $data['option'], $data['importratesheet']);
                        $file_name = $NeonExcel->convertExcelToCSV($data);

                        if(isset($data['importdialcodessheet']) && !empty($data['importdialcodessheet'])) {
                            $NeonExcelSheet2 = new NeonExcelIO($file_name_with_path, $data['option'], $data['importdialcodessheet']);
                            $file_name2 = $NeonExcelSheet2->convertExcelToCSV($data);
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
                            $NeonExcel = new NeonExcelIO($file_name, (array) $csvoption);
                            $ratesheet = $NeonExcel->read();

                            if(isset($data['importdialcodessheet']) && !empty($data['importdialcodessheet'])) {
                                $skipRows_sheet2 = $templateoptions->skipRows_sheet2;
                                NeonExcelIO::$start_row = intval($skipRows_sheet2->start_row);
                                NeonExcelIO::$end_row = intval($skipRows_sheet2->end_row);
                                $NeonExcel2 = new NeonExcelIO($file_name2, (array)$csvoption);
                                $dialcodessheet = $NeonExcel2->read();
                            }

                        } else if ($csvoption->Firstrow == 'data') {
                            $lineno = 1;
                        } else {
                            $lineno = 2;
                        }

                        if(isset($data['importdialcodessheet']) && !empty($data['importdialcodessheet'])) {
                            $results = $this->merge_arrays($ratesheet, $dialcodessheet);
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

                        if(isset($data['importdialcodessheet']) && !empty($data['importdialcodessheet'])) {
                            foreach ($attrselection2 as $key => $value) {
                                $attrselection2->$key = str_replace("\r", '', $value);
                                $attrselection2->$key = str_replace("\n", '', $attrselection2->$key);
                            }
                        }

                        foreach ($results as $index => $temp_row) {

                            if ($csvoption->Firstrow == 'data') {
                                array_unshift($temp_row, null);
                                unset($temp_row[0]);
                            }

                            foreach ($temp_row as $key => $value) {
                                $key = str_replace("\r",'',$key);
                                $key = str_replace("\n",'',$key);
                                $temp_row[$key] = $value;
                            }

                            $tempvendordata = array();
                            $tempvendordata['codedeckid'] = $joboptions->codedeckid;
                            $tempvendordata['ProcessId'] = (string)$ProcessID;

                            //check empty row
                            $checkemptyrow = array_filter(array_values($temp_row));
                            if (!empty($checkemptyrow)) {
                                if (!empty($attrselection->CountryCode) || !empty($attrselection2->CountryCode)) {
                                    if(!empty($attrselection->CountryCode)) {
                                        $selection_CountryCode = $attrselection->CountryCode;
                                    } else if(!empty($attrselection2->CountryCode)) {
                                        $selection_CountryCode = $attrselection2->CountryCode;
                                    }
                                    if (isset($selection_CountryCode) && !empty($selection_CountryCode) && !empty($temp_row[$selection_CountryCode])) {
                                        $tempvendordata['CountryCode'] = trim($temp_row[$selection_CountryCode]);
                                    } else {
                                        $tempvendordata['CountryCode'] = '';
                                    }
                                }

                                if (!empty($attrselection->Code) || !empty($attrselection2->Code)) {
                                    if(!empty($attrselection->Code)) {
                                        $selection_Code = $attrselection->Code;
                                    } else if(!empty($attrselection2->Code)) {
                                        $selection_Code = $attrselection2->Code;
                                    }
                                    if (isset($selection_Code) && !empty($selection_Code) && trim($temp_row[$selection_Code]) != '') {
                                        $tempvendordata['Code'] = trim($temp_row[$selection_Code]);
                                    } else if (isset($selection_Code) && !empty($selection_Code) && !empty($temp_row[$selection_Code])) {
                                        $tempvendordata['Code'] = "";  // if code is blank but country code is not blank than mark code as blank., it will be merged with countr code later ie 91 - 1 -> 911
                                    } else {
                                        $error[] = 'Code is blank at line no:' . $lineno;
                                    }
                                }

                                if (!empty($attrselection->Description) || !empty($attrselection2->Description)) {
                                    if(!empty($attrselection->Description)) {
                                        $selection_Description = $attrselection->Description;
                                    } else if(!empty($attrselection2->Description)) {
                                        $selection_Description = $attrselection2->Description;
                                    }
                                    if (isset($selection_Description) && !empty($selection_Description) && !empty($temp_row[$selection_Description])) {
                                        $tempvendordata['Description'] = $temp_row[$selection_Description];
                                    } else {
                                        $error[] = 'Description is blank at line no:' . $lineno;
                                    }
                                }

                                /*if (isset($attrselection->FromCurrency) && !empty($attrselection->FromCurrency) && $attrselection->FromCurrency != 0) {
                                    $tempvendordata['CurrencyID'] = $attrselection->FromCurrency;
                                }*/

                                if (isset($attrselection->Action) && !empty($attrselection->Action)) {
                                    if (empty($temp_row[$attrselection->Action])) {
                                        $tempvendordata['Change'] = 'I';
                                    } else {
                                        $action_value = $temp_row[$attrselection->Action];
                                        if (isset($attrselection->ActionDelete) && !empty($attrselection->ActionDelete) && trim(strtolower($action_value)) == trim(strtolower($attrselection->ActionDelete))) {
                                            $tempvendordata['Change'] = 'D';
                                        } else if (isset($attrselection->ActionUpdate) && !empty($attrselection->ActionUpdate) && trim(strtolower($action_value)) == trim(strtolower($attrselection->ActionUpdate))) {
                                            $tempvendordata['Change'] = 'U';
                                        } else if (isset($attrselection->ActionInsert) && !empty($attrselection->ActionInsert) && trim(strtolower($action_value)) == trim(strtolower($attrselection->ActionInsert))) {
                                            $tempvendordata['Change'] = 'I';
                                        } else {
                                            $tempvendordata['Change'] = 'I';
                                        }
                                    }

                                } else {
                                    $tempvendordata['Change'] = 'I';
                                }

                                if (isset($attrselection->Rate) && !empty($attrselection->Rate) && is_numeric(trim($temp_row[$attrselection->Rate]))  ) {
                                    if (is_numeric(trim($temp_row[$attrselection->Rate]))) {
                                        $tempvendordata['Rate'] = trim($temp_row[$attrselection->Rate]);
                                    } else {
                                        $error[] = 'Rate is not numeric at line no:' . $lineno;
                                    }
                                }elseif($tempvendordata['Change'] == 'D') {
                                    $tempvendordata['Rate'] = 0;
                                }elseif($tempvendordata['Change'] != 'D') {
                                    $error[] = 'Rate is blank at line no:'.$lineno;
                                }

                                if(!empty($attrselection->EffectiveDate) || !empty($attrselection2->EffectiveDate)) {
                                    if(!empty($attrselection->EffectiveDate)) {
                                        $selection_EffectiveDate = $attrselection->EffectiveDate;
                                    } else if(!empty($attrselection2->EffectiveDate)) {
                                        $selection_EffectiveDate = $attrselection2->EffectiveDate;
                                    }

                                    if (isset($selection_EffectiveDate) && !empty($selection_EffectiveDate) && !empty($temp_row[$selection_EffectiveDate])) {
                                        try {
                                            $tempvendordata['EffectiveDate'] = formatSmallDate(str_replace('/', '-', $temp_row[$selection_EffectiveDate]), $attrselection->DateFormat);
                                        } catch (\Exception $e) {
                                            $error[] = 'Date format is Wrong  at line no:' . $lineno;
                                        }
                                    } elseif (empty($selection_EffectiveDate)) {
                                        $tempvendordata['EffectiveDate'] = date('Y-m-d');
                                    } elseif ($tempvendordata['Change'] == 'D') {
                                        $tempvendordata['EffectiveDate'] = date('Y-m-d');
                                    } elseif ($tempvendordata['Change'] != 'D') {
                                        $error[] = 'EffectiveDate is blank at line no:' . $lineno;
                                    }
                                } else {
                                    $tempvendordata['EffectiveDate'] = date('Y-m-d');
                                }

                                if (isset($attrselection->EndDate) && !empty($attrselection->EndDate) && !empty($temp_row[$attrselection->EndDate])) {
                                    try {
                                        $tempvendordata['EndDate'] = formatSmallDate(str_replace( '/','-',$temp_row[$attrselection->EndDate]), $attrselection->DateFormat);
                                    }catch (\Exception $e){
                                        $error[] = 'Date format is Wrong  at line no:'.$lineno;
                                    }
                                }

                                if (isset($attrselection->ConnectionFee) && !empty($attrselection->ConnectionFee)) {
                                    $tempvendordata['ConnectionFee'] = trim($temp_row[$attrselection->ConnectionFee]);
                                }
                                if (isset($attrselection->Interval1) && !empty($attrselection->Interval1)) {
                                    $tempvendordata['Interval1'] = intval(trim($temp_row[$attrselection->Interval1]));
                                }
                                if (isset($attrselection->IntervalN) && !empty($attrselection->IntervalN)) {
                                    $tempvendordata['IntervalN'] = intval(trim($temp_row[$attrselection->IntervalN]));
                                }
                                if (isset($attrselection->Preference) && !empty($attrselection->Preference)) {
                                    $tempvendordata['Preference'] = trim($temp_row[$attrselection->Preference]);
                                }
                                if (isset($attrselection->Forbidden) && !empty($attrselection->Forbidden)) {
                                    $Forbidden = trim($temp_row[$attrselection->Forbidden]);
                                    if ($Forbidden == '0') {
                                        $tempvendordata['Forbidden'] = 'UB';
                                    } elseif ($Forbidden == '1') {
                                        $tempvendordata['Forbidden'] = 'B';
                                    } else {
                                        $tempvendordata['Forbidden'] = '';
                                    }
                                }
                                if (!empty($DialStringId)) {
                                    if (isset($attrselection->DialStringPrefix) && !empty($attrselection->DialStringPrefix)) {
                                        $tempvendordata['DialStringPrefix'] = trim($temp_row[$attrselection->DialStringPrefix]);
                                    } else {
                                        $tempvendordata['DialStringPrefix'] = '';
                                    }
                                }

                                if (isset($tempvendordata['Code']) && isset($tempvendordata['Description']) && ( isset($tempvendordata['Rate'])  || $tempvendordata['Change'] == 'D') && isset($tempvendordata['EffectiveDate'])) {
                                    if(isset($tempvendordata['EndDate'])) {
                                        $batch_insert_array[] = $tempvendordata;
                                    } else {
                                        $batch_insert_array2[] = $tempvendordata;
                                    }
                                    $counter++;
                                }
                            }
                           

                            if ($counter == $bacth_insert_limit) {
                                Log::info('Batch insert start');
                                Log::info('global counter' . $lineno);
                                Log::info('insertion start');
                                TempVendorRate::insert($batch_insert_array);
                                TempVendorRate::insert($batch_insert_array2);
                                Log::info('insertion end');
                                $batch_insert_array = [];
                                $batch_insert_array2 = [];
                                $counter = 0;
                            }
                            $lineno++;
                        } // loop over

                        if(!empty($batch_insert_array) || !empty($batch_insert_array2)){
                            Log::info('Batch insert start');
                            Log::info('global counter' . $lineno);
                            Log::info('insertion start');
                            Log::info('last batch insert ' . count($batch_insert_array));
                            Log::info('last batch insert 2 ' . count($batch_insert_array2));
                            TempVendorRate::insert($batch_insert_array);
                            TempVendorRate::insert($batch_insert_array2);
                            Log::info('insertion end');
                        }
                    } else {
                        $ProcessID = $joboptions->ProcessID;
                    }
                    $JobStatusMessage = array();
                    $duplicatecode=0;


                    Log::info("start CALL  prc_WSProcessVendorRate ('" . $job->AccountID . "','" . $joboptions->Trunk . "'," . $joboptions->checkbox_replace_all . ",'" . $joboptions->checkbox_rates_with_effected_from . "','" . $ProcessID . "','" . $joboptions->checkbox_add_new_codes_to_code_decks . "','" . $CompanyID . "','".$p_forbidden."','".$p_preference."','".$DialStringId."','".$dialcode_separator."',".$CurrencyID.",".$joboptions->radio_list_option.",'".$p_UserName."')");

                    try{
                        DB::beginTransaction();
                        $JobStatusMessage = DB::select("CALL  prc_WSProcessVendorRate ('" . $job->AccountID . "','" . $joboptions->Trunk . "'," . $joboptions->checkbox_replace_all . ",'" . $joboptions->checkbox_rates_with_effected_from . "','" . $ProcessID . "','" . $joboptions->checkbox_add_new_codes_to_code_decks . "','" . $CompanyID . "','".$p_forbidden."','".$p_preference."','".$DialStringId."','".$dialcode_separator."',".$CurrencyID.",".$joboptions->radio_list_option.",'".$p_UserName."')");
                        Log::info("end CALL  prc_WSProcessVendorRate ('" . $job->AccountID . "','" . $joboptions->Trunk . "'," . $joboptions->checkbox_replace_all . ",'" . $joboptions->checkbox_rates_with_effected_from . "','" . $ProcessID . "','" . $joboptions->checkbox_add_new_codes_to_code_decks . "','" . $CompanyID . "','".$p_forbidden."','".$p_preference."','".$DialStringId."','".$dialcode_separator."',".$CurrencyID.",".$joboptions->radio_list_option.",'".$p_UserName."')");
                        DB::commit();

                        $JobStatusMessage = array_reverse(json_decode(json_encode($JobStatusMessage),true));
                        Log::info($JobStatusMessage);
                        Log::info(count($JobStatusMessage));

                        if(!empty($error) || count($JobStatusMessage) > 1){
                            $prc_error = array();
                            foreach ($JobStatusMessage as $JobStatusMessage1) {
                                $prc_error[] = $JobStatusMessage1['Message'];
                                if(strpos($JobStatusMessage1['Message'], 'DUPLICATE CODE') !==false || strpos($JobStatusMessage1['Message'], 'No PREFIX FOUND') !==false){
                                    $duplicatecode = 1;
                                }
                            }

                            $job = Job::find($JobID);

                            // if duplicate code exit job will fail
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

                            $jobdata['updated_at'] = date('Y-m-d H:i:s');
                            $jobdata['ModifiedBy'] = 'RMScheduler';
                            //Log::info($jobdata);
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

    public function merge_arrays(&$array1, &$array2) {
        $result = Array();
        foreach($array1 as $key => &$value) {
            $result[$key] = array_merge($value, $array2[$key]);
            //remove null index from arrays
            unset($result[$key][""]);
        }
        return $result;
    }
}