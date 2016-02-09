<?php
/**
 * Created by PhpStorm.
 * User: srs2
 * Date: 25/05/2015
 * Time: 06:58 
 */

namespace App\Console\Commands;


use App\Lib\Account;
use App\Lib\AmazonS3;
use App\Lib\GatewayAccount;
use App\Lib\Helper;
use App\Lib\Job;
use App\Lib\JobFile;
use App\Lib\User;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Maatwebsite\Excel\Facades\Excel;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;
use \Exception;

class CustomerPortaSheet extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'customerportasheet';

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
        $userInfo = User::getUserInfo($job->JobLoggedUserID);
        $joboptions = json_decode($job->Options);
        Log::useFiles(storage_path().'/logs/portasheet-'.$JobID.'-'.date('Y-m-d').'.log');
        if((int)$job->AccountID > 0 ) {
            $GatewayAccount = GatewayAccount::where(array('AccountID'=>$job->AccountID))->first();
        }
        DB::beginTransaction();
        try{
            Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar


            $tunkids = '';
            if(isset($joboptions->Trunks) && is_array($joboptions->Trunks)){
                $tunkids = implode(',',$joboptions->Trunks);
            }else if(isset($joboptions->Trunks) && !is_array($joboptions->Trunks)){
                $tunkids = $joboptions->Trunks;
            }
            $file_name = Job::getfileName($job->AccountID,$joboptions->Trunks,'customerdownload');
            $amazonPath = AmazonS3::generate_upload_path(AmazonS3::$dir['CUSTOMER_DOWNLOAD'],$job->AccountID,$CompanyID) ;
            $local_dir = getenv('UPLOAD_PATH') . '/'.$amazonPath;
            $excel_data = DB::select("CALL  prc_CronJobGeneratePortaSheet( '" .$job->AccountID . "','" . $tunkids."' ) ");
            $excel_data = json_decode(json_encode($excel_data),true);
            Excel::create($file_name, function ($excel) use ($excel_data,$file_name) {
                $excel->sheet('Sheet', function ($sheet) use ($excel_data) {
                    $sheet->fromArray($excel_data);
                });
            })->store('xlsx',$local_dir);
            $file_name .='.xlsx';

            if(!AmazonS3::upload($local_dir.'/'.$file_name,$amazonPath)){
                throw new Exception('Error in Amazon upload');
            }
            $fullPath = $amazonPath . $file_name; //$destinationPath . $file_name;

            $jobdata['OutputFilePath'] = $fullPath;
            $jobdata['JobStatusMessage'] = 'PortaSheet Generated Successfully';
            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','S')->pluck('JobStatusID');
            $jobdata['updated_at'] = date('Y-m-d H:i:s');
            $jobdata['ModifiedBy'] = 'RMScheduler';
            Job::where(["JobID" => $JobID])->update($jobdata);

            DB::commit();

        }catch (Exception $e) {
            try{
                DB::rollback();
            }catch (Exception $err) {
                Log::error($err);
            }
            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','F')->pluck('JobStatusID');
            $jobdata['JobStatusMessage'] = 'PortaSheet Download Failed::'.$e->getMessage();
            $jobdata['updated_at'] = date('Y-m-d H:i:s');
            $jobdata['ModifiedBy'] = 'RMScheduler';
            Job::where(["JobID" => $JobID])->update($jobdata);
            Log::error($e);
        }
        Job::send_job_status_email($job,$CompanyID);


    }

}