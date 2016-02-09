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
use App\Lib\TempCodeDeck;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Facades\Excel;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;
use \Exception;

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
        $arguments = $this->argument();
        $getmypid = getmypid(); // get proccess id added by abubakar
        $JobID = $arguments["JobID"];
        $job = Job::find($JobID);
        $ProcessID = Uuid::generate();
        Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar
        $CompanyID = $arguments["CompanyID"];
        $bacth_insert_limit = 250;
        $counter = 0;
        Log::useFiles(storage_path() . '/logs/codedecksfileupload-' .  $JobID. '-' . date('Y-m-d') . '.log');
        try {
            if (!empty($job)) {
                $jobfile = JobFile::where(['JobID' => $JobID])->first();
                $joboptions = json_decode($jobfile->Options);
                if (count($joboptions) > 0) {
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

                    $results =  Excel::load($jobfile->FilePath, function ($reader){
                        $reader->formatDates(true, 'Y-m-d');
                    })->get();
                    $results = json_decode(json_encode($results), true);
                    $error = array();
                    $lineno = 2;
                    $batch_insert_array = [];
                    foreach ($results as $row) {
                        $tempcodedeckdata = array();
                        $tempcodedeckdata['codedeckid'] = $joboptions->codedeckid;
                        $tempcodedeckdata['ProcessId'] = $ProcessID;
                        $tempcodedeckdata['CompanyId'] = $CompanyID;
                        if (isset($row['code']) && !empty($row['code'])) {
                            $tempcodedeckdata['code'] = $row['code'];
                        }else{
                            $error[] = 'code is blank at line no:'.$lineno;
                        }
                        if (isset($row['country']) && !empty($row['country'])) {
                            $tempcodedeckdata['country'] = $row['country'];
                        }
                        if (isset($row['description']) && !empty($row['description'])) {
                            $tempcodedeckdata['description'] = $row['description'];
                        }else{
                            $error[] = 'description is blank at line no:'.$lineno;
                        }
                        if (isset($row['interval1']) && !empty($row['interval1'])) {
                            $tempcodedeckdata['interval1'] = $row['interval1'];
                        }
                        if (isset($row['intervaln']) && !empty($row['intervaln'])) {
                            $tempcodedeckdata['intervaln'] = $row['intervaln'];
                        }
                        if (isset($row['action']) && !empty($row['action'])) {
                            $tempcodedeckdata['action'] = $row['action'];
                        }else{
                            $tempcodedeckdata['action'] = 'I';
                        }
                        if(isset($tempcodedeckdata['code']) && isset($tempcodedeckdata['description'])){
                            $batch_insert_array[] = $tempcodedeckdata;
                            $counter++;
                        }
                        if($counter==$bacth_insert_limit){
                            Log::info('Batch insert start');
                            Log::info('global counter'.$lineno);
                            Log::info('insertion start');
                            TempCodeDeck::insert($batch_insert_array);
                            Log::info('insertion end');
                            $batch_insert_array = [];
                            $counter = 0;
                        }
                        $lineno++;
                    }
                    if(!empty($batch_insert_array)){
                        Log::info('Batch insert start');
                        Log::info('global counter'.$lineno);
                        Log::info('insertion start');
                        TempCodeDeck::insert($batch_insert_array);
                        Log::info('insertion end');
                    }

                    DB::beginTransaction();
                    Log::info("start CALL  prc_WSProcessCodeDeck ('" . $ProcessID . "','" . $CompanyID . "')");
                    $JobStatusMessage = DB::select("CALL  prc_WSProcessCodeDeck ('" . $ProcessID . "','" . $CompanyID . "')");
                    Log::info("end CALL  prc_WSProcessCodeDeck ('" . $ProcessID . "','" . $CompanyID . "')");
                    DB::commit();
                    $JobStatusMessage = array_reverse(json_decode(json_encode($JobStatusMessage),true));
                    if(!empty($error) || count($JobStatusMessage) > 1){
                        foreach ($JobStatusMessage as $JobStatusMessage) {
                            $error[] = $JobStatusMessage['Message'];
                        }
                        $job = Job::find($JobID);
                        $jobdata['JobStatusMessage'] = implode(',\n\r',$error);
                        $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','PF')->pluck('JobStatusID');
                        $jobdata['updated_at'] = date('Y-m-d H:i:s');
                        $jobdata['ModifiedBy'] = 'RMScheduler';
                        Job::where(["JobID" => $JobID])->update($jobdata);
                    }elseif(!empty($JobStatusMessage[0]['Message'])) {
                        $job = Job::find($JobID);
                        $jobdata['JobStatusMessage'] = $JobStatusMessage[0]['Message'];
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
    }
}