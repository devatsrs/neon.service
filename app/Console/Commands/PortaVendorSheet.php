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
use App\Lib\CronHelper;
use App\Lib\GatewayAccount;
use App\Lib\Helper;
use App\Lib\Job;
use App\Lib\JobFile;
use App\Lib\NeonExcelIO;
use App\Lib\User;
use Box\Spout\Common\Type;
use Box\Spout\Writer\WriterFactory;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Maatwebsite\Excel\Facades\Excel;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;
use \Exception;

class PortaVendorSheet extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'portavendorsheet';

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


        CronHelper::before_cronrun($this->name, $this );



        $arguments = $this->argument();
        $getmypid = getmypid(); // get proccess id added by abubakar
        $JobID = $arguments["JobID"];
        $CompanyID = $arguments["CompanyID"];

        $job = Job::find($JobID);
        $ProcessID = Uuid::generate();
        $userInfo = User::getUserInfo($job->JobLoggedUserID);
        $joboptions = json_decode($job->Options);
        $start_time = date('Y-m-d H:i:s');

        Log::useFiles(storage_path().'/logs/portavendorsheet-'.$JobID.'-'.date('Y-m-d').'.log');
        DB::beginTransaction();
        try{
            Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar
            $tunkids = '';
            $file_path = '';
            $amazonPath = '';
            if(isset($joboptions->Trunks) && is_array($joboptions->Trunks)){
                $tunkids = implode(',',$joboptions->Trunks);
            }else if(isset($joboptions->Trunks) && !is_array($joboptions->Trunks)){
                $tunkids = $joboptions->Trunks;
            }
            if(!empty($joboptions->downloadtype)){
                $downloadtype = $joboptions->downloadtype;
            }else{
                $downloadtype = 'csv';
            }
            $file_name = Job::getfileName($job->AccountID,$joboptions->Trunks,'vendordownload');
            $amazonDir = AmazonS3::generate_upload_path(AmazonS3::$dir['VENDOR_DOWNLOAD'],$job->AccountID,$CompanyID) ;
            $Effective = 'Now';
            if(!empty($joboptions->Effective)){
                $Effective = $joboptions->Effective;
            }

            $excel_data = DB::select("CALL  prc_CronJobGeneratePortaVendorSheet ('" .$job->AccountID . "','" . $tunkids."','".$Effective."')");

            $excel_data = json_decode(json_encode($excel_data),true);

            if($downloadtype == 'xlsx'){
                $amazonPath = $amazonDir .  $file_name . '.xlsx';
                $file_path = getenv('UPLOAD_PATH') . '/'. $amazonPath ;
                $NeonExcel = new NeonExcelIO($file_path);
                $NeonExcel->write_excel($excel_data);
            }else if($downloadtype == 'csv'){
                $amazonPath = $amazonDir .  $file_name . '.csv';
                $file_path = getenv('UPLOAD_PATH') . '/'. $amazonPath ;
                $NeonExcel = new NeonExcelIO($file_path);
                $NeonExcel->write_csv($excel_data);
            }

            if(!AmazonS3::upload($file_path,$amazonDir,$CompanyID)){
                throw new Exception('Error in Amazon upload');
            }

            $time_taken = ' <br/> Time taken - ' . time_elapsed($start_time, date('Y-m-d H:i:s'));
            Log::info($time_taken);
            $jobdata['OutputFilePath'] = $amazonPath;
            $jobdata['JobStatusMessage'] = 'Porta File Generated Successfully';
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
            $jobdata['JobStatusMessage'] = 'Sheet Download Failed::'.$e->getMessage();
            $jobdata['updated_at'] = date('Y-m-d H:i:s');
            $jobdata['ModifiedBy'] = 'RMScheduler';
            Job::where(["JobID" => $JobID])->update($jobdata);
            Log::error($e);
        }
        Job::send_job_status_email($job,$CompanyID);


        CronHelper::after_cronrun($this->name, $this);


    }

}