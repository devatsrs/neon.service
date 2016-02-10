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
use App\Lib\Payment;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Facades\Excel;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;
use \Exception;

class PaymentsUpload extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'paymentsupload';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Payments upload.';

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
        Log::useFiles(storage_path() . '/logs/paymentsfileupload-' .  $JobID. '-' . date('Y-m-d') . '.log');
        try {
            if (!empty($job)) {
                $jobfile = JobFile::where(['JobID' => $JobID])->first();

                if ($jobfile->FilePath) {
                    $path = AmazonS3::unSignedUrl($jobfile->FilePath);
                    if (strpos($path, "https://") !== false) {
                        $file = Config::get('app.temp_location') . basename($path);
                        file_put_contents($file, file_get_contents($path));
                        $jobfile->FilePath = $file;
                    } else {
                        $path = env('UPLOAD_PATH').'/'.$jobfile->FilePath;
                        $jobfile->FilePath = $path;
                    }
                }
                $results =  Excel::load($jobfile->FilePath, function ($reader){
                    $reader->formatDates(true, 'Y-m-d');
                })->get();
                $results = json_decode(json_encode($results), true);
                if(Payment::insert($results)){
                    $jobdata['JobStatusMessage'] = 'Payments inserted successfully';
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','S')->pluck('JobStatusID');
                }else{
                    $jobdata['JobStatusMessage'] = 'Some thing wrong with inserting Payments';
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','F')->pluck('JobStatusID');
                }

                $job = Job::find($JobID);
                $jobdata['updated_at'] = date('Y-m-d H:i:s');
                $jobdata['ModifiedBy'] = 'RMScheduler';
                Job::where(["JobID" => $JobID])->update($jobdata);

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
    }
}