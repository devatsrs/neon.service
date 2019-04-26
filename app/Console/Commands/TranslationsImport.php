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
use App\Lib\Job;
use App\Lib\JobFile;
use App\Lib\NeonExcelIO;
use App\Lib\TempCodeDeck;
use App\Lib\Translation;
use Exception;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;

class TranslationsImport extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'translationimport';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Translation Import.';

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
        $getmypid = getmypid();
        $JobID = $arguments["JobID"];
        $job = Job::find($JobID);
        $ProcessID = CompanyGateway::getProcessID();
        Job::JobStatusProcess($JobID, $ProcessID,$getmypid);
        $CompanyID = $arguments["CompanyID"];
        $bacth_insert_limit = 250;
        $counter = 0;
        $start_time = date('Y-m-d H:i:s');
        $JobStatusMessageError = array();
        $JobStatusMessageSuccess = '';

        Log::useFiles(storage_path() . '/logs/translationsimport-' .  $JobID. '-' . date('Y-m-d') . '.log');
        $TEMP_PATH = CompanyConfiguration::get($CompanyID,'TEMP_PATH').'/';
        try {
            if (!empty($job)) {
                Log::info("job find");
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
                    Log::info('final path '.$jobfile->FilePath);

                    $NeonExcel = new NeonExcelIO($jobfile->FilePath);
                    $results = $NeonExcel->read();
                    /*$results =  Excel::load($jobfile->FilePath, function ($reader){
                    })->get();*/
                    //$results = json_decode(json_encode($results), true);
                    $error = array();
                    $lineno = 2;
                    $batch_insert_array = [];
                    foreach ($results as $row) {

                        $tempdata = array();
                        $tempdata['ProcessId'] = $ProcessID;
                        $tempdata['CompanyId'] = $CompanyID;

                        //check empty row
                        $checkemptyrow = array_filter(array_values($row));
                        if(!empty($checkemptyrow)){
                            if (isset($row['SystemName']) && !empty($row['SystemName'])) {
                                $tempdata['SystemName'] = $row['SystemName'];
                                Log::info($tempdata['SystemName']);

                            }else{
                                $error[] = 'System Name is blank at line no:'.$lineno;
                            }
                            if (isset($row['Translation']) && !empty($row['Translation'])) {
                                $tempdata['Translation'] = $row['Translation'];
                            }else{
                                $error[] = 'Translation is blank at line no:'.$lineno;
                            }
                            if (isset($row['ISOCode']) && !empty($row['ISOCode'])) {
                                $tempdata['ISOCode'] = $row['ISOCode'];
                            }else{
                                $error[] = 'ISO Code is blank at line no:'.$lineno;
                            }
                            if(isset($tempdata['SystemName']) && isset($tempdata['Translation']) && isset($tempdata['ISOCode'])){
                                $batch_insert_array[] = $tempdata;
                                $counter++;
                            }
                        }

                        if($counter==$bacth_insert_limit){
                            Log::info('Batch insert start');
                            Log::info('global counter'.$lineno);
                            Log::info('insertion start');
                            Log::info('count ' . count($batch_insert_array));
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
                        foreach($batch_insert_array as $val)
                        {
                            $labels = Translation::get_language_labels($val['ISOCode']);
                            if(Translation::update_label($labels,strtoupper(str_replace(" ","_",$val['SystemName'])),$val['Translation']))
                            {
                                $JobStatusMessageSuccess = 'Successfully Updated';
                            } else {$JobStatusMessageError[] = $val['SystemName']." Unable to Update";}
                    }
                        Log::info(json_encode($batch_insert_array));
                        Log::info('insertion end');
                    }

                    $time_taken = ' <br/> Time taken - ' . time_elapsed($start_time, date('Y-m-d H:i:s'));
                    Log::info($time_taken);

                    if(!empty($error) || !empty($JobStatusMessageError)){

                        $job = Job::find($JobID);
                        $allerror = array_merge($JobStatusMessageError,$error);
                        $jobdata['JobStatusMessage'] = implode(',\n\r',fix_jobstatus_meassage($allerror)) ;
                        $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','PF')->pluck('JobStatusID');
                        $jobdata['updated_at'] = date('Y-m-d H:i:s');
                        $jobdata['ModifiedBy'] = 'RMScheduler';
                        Job::where(["JobID" => $JobID])->update($jobdata);
                        Log::info($JobStatusMessageError);
                    }elseif(!empty($JobStatusMessageSuccess)) {
                        $job = Job::find($JobID);
                        Log::info($JobStatusMessageSuccess);
                        $jobdata['JobStatusMessage'] = $JobStatusMessageSuccess ;
                        $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','S')->pluck('JobStatusID');
                        $jobdata['updated_at'] = date('Y-m-d H:i:s');
                        $jobdata['ModifiedBy'] = 'RMScheduler';
                        Job::where(["JobID" => $JobID])->update($jobdata);
                    }
                }
            }
            Job::send_job_status_email($job,$CompanyID);

        } catch (\Exception $e) {

            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
            $jobdata['JobStatusMessage'] = 'Exception: ' . $e->getMessage();
            $jobdata['updated_at'] = date('Y-m-d H:i:s');
            $jobdata['ModifiedBy'] = 'RMScheduler';
            Job::where(["JobID" => $JobID])->update($jobdata);
            Log::error($e);
            Job::send_job_status_email($job,$CompanyID);
        }
        CronHelper::after_cronrun($this->name, $this);
    }
}