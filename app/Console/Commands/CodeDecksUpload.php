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
use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\Helper;
use App\Lib\Job;
use App\Lib\JobFile;
use App\Lib\NeonExcelIO;
use App\Lib\TempCodeDeck;
use Exception;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;

class CodeDecksUpload extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'codedecksupload';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Code Decks upload.';

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
        $ProcessID = CompanyGateway::getProcessID();
        Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar
        $CompanyID = $arguments["CompanyID"];
        $bacth_insert_limit = 250;
        $counter = 0;
        $start_time = date('Y-m-d H:i:s');
        $JobStatusMessage =array();

        Log::useFiles(storage_path() . '/logs/codedecksfileupload-' .  $JobID. '-' . date('Y-m-d') . '.log');
        $TEMP_PATH = CompanyConfiguration::get($CompanyID,'TEMP_PATH').'/';
        try {
            if (!empty($job)) {
                $jobfile = JobFile::where(['JobID' => $JobID])->first();
                $joboptions = json_decode($jobfile->Options);
                if (count($joboptions) > 0) {
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
                    Log::info($jobfile->FilePath);

                    $NeonExcel = new NeonExcelIO($jobfile->FilePath);
                    $results = $NeonExcel->read();

                    /*$results =  Excel::load($jobfile->FilePath, function ($reader){
                    })->get();*/
                    //$results = json_decode(json_encode($results), true);
                    $error = array();
                    $lineno = 2;
                    $batch_insert_array = [];
                    foreach ($results as $row) {

                        $tempcodedeckdata = array();
                        $tempcodedeckdata['codedeckid'] = $joboptions->codedeckid;
                        $tempcodedeckdata['ProcessId'] = $ProcessID;
                        $tempcodedeckdata['CompanyId'] = $CompanyID;

                        //check empty row
                        $checkemptyrow = array_filter(array_values($row));
                        if(!empty($checkemptyrow)){
                            if (isset($row['Code']) && !empty($row['Code'])) {
                                $tempcodedeckdata['Code'] = $row['Code'];
                            }else{
                                $error[] = 'code is blank at line no:'.$lineno;
                            }
                            if (isset($row['Country']) && !empty($row['Country'])) {
                                $tempcodedeckdata['Country'] = $row['Country'];
                            }else{
                                $tempcodedeckdata['Country'] = '';
                            }
                            if (isset($row['Description']) && !empty($row['Description'])) {
                                $tempcodedeckdata['Description'] = $row['Description'];
                            }else{
                                $error[] = 'description is blank at line no:'.$lineno;
                            }
							if (isset($row['Type']) && !empty($row['Type'])) {
                                $tempcodedeckdata['Type'] = $row['Type'];
								
                            }else{
                                $tempcodedeckdata['Type'] = "";
                            }
                            if (isset($row['Interval1']) && !empty($row['Interval1'])) {
                                $tempcodedeckdata['Interval1'] = $row['Interval1'];
                            }else{
                                $tempcodedeckdata['Interval1'] = '';
                            }
                            if (isset($row['IntervalN']) && !empty($row['IntervalN'])) {
                                $tempcodedeckdata['IntervalN'] = $row['IntervalN'];
                            }else{
                                $tempcodedeckdata['IntervalN'] = '';
                            }
                            if (isset($row['MinimumDuration']) && !empty($row['MinimumDuration'])) {
                                $tempcodedeckdata['MinimumDuration'] = $row['MinimumDuration'];
                            }else{
                                $tempcodedeckdata['MinimumDuration'] = '';
                            }
                            if (isset($row['Action']) && !empty($row['Action'])) {
                                $tempcodedeckdata['Action'] = $row['Action'];
                            }else{
                                $tempcodedeckdata['Action'] = 'I';
                            }
                            if(isset($tempcodedeckdata['Code']) && isset($tempcodedeckdata['Description'])){
                                $batch_insert_array[] = $tempcodedeckdata;
                                $counter++;
                            }
                        }
                        if($counter==$bacth_insert_limit){
                            Log::info('Batch insert start');
                            Log::info('global counter'.$lineno);
                            Log::info('insertion start');
                            Log::info('count ' . count($batch_insert_array));
                            TempCodeDeck::insert($batch_insert_array);
                            Log::info('insertion end');
                            $batch_insert_array = [];
                            $counter = 0;
                        }
                        $lineno++;
                    } // loop end


                    if(!empty($batch_insert_array)){
                        Log::info('Batch insert start');
                        Log::info('global counter'.$lineno);
                        Log::info('insertion start');
                        Log::info('count ' . count($batch_insert_array));
                        TempCodeDeck::insert($batch_insert_array);
						Log::info(json_encode($batch_insert_array));
                        Log::info('insertion end');
                    }

                    DB::beginTransaction();
                    Log::info("start CALL  prc_WSProcessCodeDeck ('" . $ProcessID . "','" . $CompanyID . "')");
                    $JobStatusMessage = DB::select("CALL  prc_WSProcessCodeDeck ('" . $ProcessID . "','" . $CompanyID . "')");
                    Log::info("end CALL  prc_WSProcessCodeDeck ('" . $ProcessID . "','" . $CompanyID . "')");
                    DB::commit();
                    $JobStatusMessage = array_reverse(json_decode(json_encode($JobStatusMessage),true));

                    $time_taken = ' <br/> Time taken - ' . time_elapsed($start_time, date('Y-m-d H:i:s'));
                    Log::info($time_taken);

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
            Job::send_job_status_email($job,$CompanyID);

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
            Job::send_job_status_email($job,$CompanyID);
        }

        CronHelper::after_cronrun($this->name, $this);

            // Trigger   insert_into_rate_search_code
        Helper::trigger_command($CompanyID,"insert_into_rate_search_code",$joboptions->codedeckid);

    }
}