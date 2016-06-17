<?php
/**
 * Created by PhpStorm.
 * User: srs2
 * Date: 25/05/2015
 * Time: 06:58
 */

namespace App\Console\Commands;

use App\Lib\AmazonS3;
use App\Lib\CronHelper;
use App\Lib\Job;
use App\Lib\JobFile;
use App\Lib\NeonExcelIO;
use App\Lib\TempDialPlan;
use App\Lib\FileUploadTemplate;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Facades\Excel;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;
use \Exception;

class DialPlanUpload extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'dialplanupload';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Dial Plan upload.';

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
        $ProcessID = (string) Uuid::generate();
        Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar
        $CompanyID = $arguments["CompanyID"];
        $bacth_insert_limit = 250;
        $counter = 0;
        $start_time = date('Y-m-d H:i:s');
        $JobStatusMessage =array();
        $DialPlanID = '';

        Log::useFiles(storage_path() . '/logs/dialplanupload-' .  $JobID. '-' . date('Y-m-d') . '.log');
        try {

            if (!empty($job)) {
                $jobfile = JobFile::where(['JobID' => $JobID])->first();
                $joboptions = json_decode($jobfile->Options);
                if (count($joboptions) > 0) {
                    if(isset($joboptions->uploadtemplate) && !empty($joboptions->uploadtemplate)) {
                        $uploadtemplate = FileUploadTemplate::find($joboptions->uploadtemplate);
                        $templateoptions = json_decode($uploadtemplate->Options);
                    }else{
                        $templateoptions = json_decode($joboptions->Options);

                    }
                    $DialPlanID = $joboptions->DialPlanID;
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

                    $NeonExcel = new NeonExcelIO($jobfile->FilePath, (array) $csvoption);
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
                        $tempdialplandata = array();
                        $tempdialplandata['DialPlanID'] = $joboptions->DialPlanID;
                        $tempdialplandata['ProcessId'] = (string) $ProcessID;

                        //check empty row
                        $checkemptyrow = array_filter(array_values($temp_row));
                        if(!empty($checkemptyrow)){
                            if (isset($attrselection->DialString) && !empty($attrselection->DialString) && !empty($temp_row[$attrselection->DialString])) {
                                $tempdialplandata['DialString'] = trim($temp_row[$attrselection->DialString]);
                            }else{
                                $error[] = 'DialString is blank at line no:'.$lineno;
                            }
                            if (isset($attrselection->ChargeCode) && !empty($attrselection->ChargeCode) && !empty($temp_row[$attrselection->ChargeCode])) {
                                $tempdialplandata['ChargeCode'] = trim($temp_row[$attrselection->ChargeCode]);
                            }else{
                                $error[] = 'ChargeCode is blank at line no:'.$lineno;
                            }
                            if (isset($attrselection->Description) && !empty($attrselection->Description) && !empty($temp_row[$attrselection->Description])) {
                                $tempdialplandata['Description'] = trim($temp_row[$attrselection->Description]);
                            }else{
                                $error[] = 'Description is blank at line no:'.$lineno;
                            }

                            if (isset($attrselection->Forbidden) && !empty($attrselection->Forbidden)) {
                                $Forbidden = trim($temp_row[$attrselection->Forbidden]);
                                if($Forbidden=='0'){
                                    $tempdialplandata['Forbidden'] = '0';
                                }elseif($Forbidden=='1'){
                                    $tempdialplandata['Forbidden'] = '1';
                                }else{
                                    $tempdialplandata['Forbidden'] = '';
                                }
                            }

                            if (isset($attrselection->Action) && !empty($attrselection->Action)) {
                                if(empty($temp_row[$attrselection->Action])){
                                    $tempdialplandata['Action'] = 'I';
                                }else{
                                    $action_value = $temp_row[$attrselection->Action];
                                    if (isset($attrselection->ActionDelete) && !empty($attrselection->ActionDelete) && trim(strtolower($action_value)) == trim(strtolower($attrselection->ActionDelete)) ) {
                                        $tempdialplandata['Action'] = 'D';
                                    }else if (isset($attrselection->ActionUpdate) && !empty($attrselection->ActionUpdate) && trim(strtolower($action_value)) == trim(strtolower($attrselection->ActionUpdate))) {
                                        $tempdialplandata['Action'] = 'U';
                                    }else if (isset($attrselection->ActionInsert) && !empty($attrselection->ActionInsert) && trim(strtolower($action_value)) == trim(strtolower($attrselection->ActionInsert))) {
                                        $tempdialplandata['Action'] = 'I';
                                    }else{
                                        $tempdialplandata['Action'] = 'I';
                                    }
                                }

                            }else{
                                $tempdialplandata['Action'] = 'I';
                            }


                            if(isset($tempdialplandata['DialString']) && isset($tempdialplandata['ChargeCode']) && isset($tempdialplandata['Description'])){
                                $batch_insert_array[] = $tempdialplandata;
                                $counter++;
                            }
                        }

                        if($counter==$bacth_insert_limit){
                            Log::info('Batch insert start');
                            Log::info('global counter'.$lineno);
                            Log::info('insertion start');
                            TempDialPlan::insert($batch_insert_array);
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
                        TempDialPlan::insert($batch_insert_array);
                        Log::info('insertion end');
                    }

                    DB::beginTransaction();
                    Log::info("start CALL  prc_WSProcessDialPlan ('" . $ProcessID . "','" . $DialPlanID . "')");
                    $JobStatusMessage = DB::select("CALL  prc_WSProcessDialPlan ('" . $ProcessID . "','" . $DialPlanID . "')");
                    Log::info("end CALL  prc_WSProcessDialPlan ('" . $ProcessID . "','" . $DialPlanID . "')");
                    DB::commit();
                    $JobStatusMessage = array_reverse(json_decode(json_encode($JobStatusMessage),true));

                    //$time_taken = ' <br/> Time taken - ' . time_elapsed($start_time, date('Y-m-d H:i:s'));
                    //Log::info($time_taken);

                    if(!empty($error) || count($JobStatusMessage) > 1){
                        $prc_error = array();
                        foreach ($JobStatusMessage as $JobStatusMessage1) {
                            $prc_error[] = $JobStatusMessage1['Message'];
                        }

                        $job = Job::find($JobID);
                        $error = array_merge($prc_error,$error);
                        $jobdata['JobStatusMessage'] = implode(',\n\r',fix_jobstatus_meassage($error)) ;
                        $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','PF')->pluck('JobStatusID');
                        $jobdata['updated_at'] = date('Y-m-d H:i:s');
                        $jobdata['ModifiedBy'] = 'RMScheduler';
                        Job::where(["JobID" => $JobID])->update($jobdata);
                    }elseif(!empty($JobStatusMessage[0]['Message'])) {
                        $job = Job::find($JobID);

                        $jobdata['JobStatusMessage'] = $JobStatusMessage[0]['Message'] ;
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

        CronHelper::after_cronrun($this->name, $this);
    }
}