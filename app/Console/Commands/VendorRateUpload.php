<?php
/**
 * Created by PhpStorm.
 * User: srs2
 * Date: 25/05/2015
 * Time: 06:58
 */

namespace App\Console\Commands;

use App\Lib\AmazonS3;
use App\Lib\Job;
use App\Lib\JobFile;
use App\Lib\TempVendorRate;
use App\Lib\VendorFileUploadTemplate;
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

        $arguments = $this->argument();
        $getmypid = getmypid(); // get proccess id added by abubakar
        $JobID = $arguments["JobID"];
        $job = Job::find($JobID);
        $ProcessID = Uuid::generate();
        Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Update by Abubakar
        $CompanyID = $arguments["CompanyID"];
        $bacth_insert_limit = 250;
        $counter = 0;
        Log::useFiles(storage_path() . '/logs/vendorfileupload-' .  $JobID. '-' . date('Y-m-d') . '.log');
        try {

            if (!empty($job)) {
                $jobfile = JobFile::where(['JobID' => $JobID])->first();
                $joboptions = json_decode($jobfile->Options);
                if (count($joboptions) > 0) {
                    if(isset($joboptions->uploadtemplate) && !empty($joboptions->uploadtemplate)){
                        $uploadtemplate = VendorFileUploadTemplate::find($joboptions->uploadtemplate);
                        $templateoptions = json_decode($uploadtemplate->Options);
                    }else{
                        $templateoptions = json_decode($joboptions->Options);
                    }
                    $csvoption = $templateoptions->option;
                    $attrselection = $templateoptions->selection;
                    if ($jobfile->FilePath) {
                        $path = AmazonS3::unSignedUrl($jobfile->FilePath);
                        if (strpos($path, "https://") !== false) {
                            $file = Config::get('app.temp_location') . basename($path);
                            file_put_contents($file, file_get_contents($path));
                            $jobfile->FilePath = $file;
                        } else {
                            $jobfile->FilePath = $path;
                        }
                    };

                    if (!empty($csvoption->Delimiter)) {
                        Config::set('excel.csv.delimiter', $csvoption->Delimiter);
                    }
                    if (!empty($csvoption->Enclosure)) {
                        Config::set('excel.csv.enclosure', $csvoption->Enclosure);
                    }
                    if (!empty($csvoption->Escape)) {
                        Config::set('excel.csv.line_ending', $csvoption->Escape);
                    }
                    Config::set('excel.import.heading','original');
                    Config::set('excel.import.dates.enable',false);
                    $isExcel = in_array(pathinfo($jobfile->FilePath, PATHINFO_EXTENSION),['xls','xlsx'])?true:false;
                    $results =  Excel::selectSheetsByIndex(0)->load($jobfile->FilePath, function ($reader) use ($csvoption,$isExcel) {
                        if ($csvoption->Firstrow == 'data') {
                            $reader->noHeading();
                        }
                    })->get();
                    $results = json_decode(json_encode($results), true);
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
                        $tempvendordata = array();
                        $tempvendordata['codedeckid'] = $joboptions->codedeckid;
                        $tempvendordata['ProcessId'] = (string) $ProcessID;
                        if (isset($attrselection->Code) && !empty($attrselection->Code) && !empty($temp_row[$attrselection->Code])) {
                            $tempvendordata['Code'] = $temp_row[$attrselection->Code];
                        }else{
                            $error[] = 'Code is blank at line no:'.$lineno;
                        }
                        if (isset($attrselection->Description) && !empty($attrselection->Description) && !empty($temp_row[$attrselection->Description])) {
                            $tempvendordata['Description'] = $temp_row[$attrselection->Description];
                        }else{
                            $error[] = 'Description is blank at line no:'.$lineno;
                        }
                        if (isset($attrselection->Rate) && !empty($attrselection->Rate) && is_numeric($temp_row[$attrselection->Rate])  ) {
                            if(is_numeric($temp_row[$attrselection->Rate])) {
                                $tempvendordata['Rate'] = $temp_row[$attrselection->Rate];
                            }else{
                                $error[] = 'Rate is not numeric at line no:'.$lineno;
                            }
                        }else{
                            $error[] = 'Rate is blank at line no:'.$lineno;
                        }
                        if (isset($attrselection->EffectiveDate) && !empty($attrselection->EffectiveDate) && !empty($temp_row[$attrselection->EffectiveDate])) {
                            try {
                                $tempvendordata['EffectiveDate'] = formatSmallDate($temp_row[$attrselection->EffectiveDate], $attrselection->DateFormat);
                            }catch (\Exception $e){
                                $error[] = 'Date format is Wrong  at line no:'.$lineno;
                            }
                        }elseif(empty($attrselection->EffectiveDate)){
                            $tempvendordata['EffectiveDate'] = date('Y-m-d');
                        }else{
                            $error[] = 'EffectiveDate is blank at line no:'.$lineno;
                        }
                        if (isset($attrselection->Action) && !empty($attrselection->Action)) {
                            $action_value = $temp_row[$attrselection->Action];
                            if (isset($attrselection->ActionDelete) && !empty($attrselection->ActionDelete) && strtolower($action_value) == strtolower($attrselection->ActionDelete) ) {
                                $tempvendordata['Change'] = 'D';
                            }else if (isset($attrselection->ActionUpdate) && !empty($attrselection->ActionUpdate) && strtolower($action_value) == strtolower($attrselection->ActionUpdate)) {
                                $tempvendordata['Change'] = 'U';
                            }else if (isset($attrselection->ActionInsert) && !empty($attrselection->ActionInsert) && strtolower($action_value) == strtolower($attrselection->ActionInsert)) {
                                $tempvendordata['Change'] = 'I';
                            }else{
                                $tempvendordata['Change'] = 'I';
                            }
                        }else{
                            $tempvendordata['Change'] = 'I';
                        }

                        if (isset($attrselection->ConnectionFee) && !empty($attrselection->ConnectionFee)) {
                            $tempvendordata['ConnectionFee'] = $temp_row[$attrselection->ConnectionFee];
                        }
                        if (isset($attrselection->Interval1) && !empty($attrselection->Interval1)) {
                            $tempvendordata['Interval1'] = $temp_row[$attrselection->Interval1];
                        }
                        if (isset($attrselection->IntervalN) && !empty($attrselection->IntervalN)) {
                            $tempvendordata['IntervalN'] = $temp_row[$attrselection->IntervalN];
                        }
                        if(isset($tempvendordata['Code']) && isset($tempvendordata['Description']) && isset($tempvendordata['Rate']) && isset($tempvendordata['EffectiveDate'])){
                            $batch_insert_array[] = $tempvendordata;
                            $counter++;
                        }
                        if($counter==$bacth_insert_limit){
                            Log::info('Batch insert start');
                            Log::info('global counter'.$lineno);
                            Log::info('insertion start');
                            TempVendorRate::insert($batch_insert_array);
                            Log::info('insertion end');
                            $batch_insert_array = [];
                            $counter = 0;
                        }
                        $lineno++;
                    } // loop over

                    if(!empty($batch_insert_array)){
                        Log::info('Batch insert start');
                        Log::info('global counter'.$lineno);
                        Log::info('insertion start');
                        Log::info('last batch insert ' . count($batch_insert_array));
                        Log::info(print_r($batch_insert_array,true));

                        TempVendorRate::insert($batch_insert_array);
                        Log::info('insertion end');
                    }
                    Log::info("start CALL  prc_WSProcessVendorRate ('" . $job->AccountID . "','" . $joboptions->Trunk . "'," . $joboptions->checkbox_replace_all . ",'" . $joboptions->checkbox_rates_with_effected_from . "','" . $ProcessID . "','" . $joboptions->checkbox_add_new_codes_to_code_decks . "','" . $CompanyID . "')");
                    try{
                        DB::beginTransaction();
                        $JobStatusMessage = DB::select("CALL  prc_WSProcessVendorRate ('" . $job->AccountID . "','" . $joboptions->Trunk . "'," . $joboptions->checkbox_replace_all . ",'" . $joboptions->checkbox_rates_with_effected_from . "','" . $ProcessID . "','" . $joboptions->checkbox_add_new_codes_to_code_decks . "','" . $CompanyID . "')");
                        Log::info("end CALL  prc_WSProcessVendorRate ('" . $job->AccountID . "','" . $joboptions->Trunk . "'," . $joboptions->checkbox_replace_all . ",'" . $joboptions->checkbox_rates_with_effected_from . "','" . $ProcessID . "','" . $joboptions->checkbox_add_new_codes_to_code_decks . "','" . $CompanyID . "')");
                        DB::commit();
                    }catch ( Exception $err ){
                        DB::rollback();
                        Log::error($err);
                    }

                    $JobStatusMessage = array_reverse(json_decode(json_encode($JobStatusMessage),true));
                    Log::info($JobStatusMessage);
                    Log::info(count($JobStatusMessage));
                    if(!empty($error) || count($JobStatusMessage) > 1){
                        $prc_error = array();
                        foreach ($JobStatusMessage as $JobStatusMessage) {
                            $prc_error[] = $JobStatusMessage['Message'];
                        }
                        $error = array_merge($prc_error,$error);
                        $job = Job::find($JobID);
                        $jobdata['JobStatusMessage'] = implode(',\n\r',fix_jobstatus_meassage($error));
                        $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','PF')->pluck('JobStatusID');
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
    }
}