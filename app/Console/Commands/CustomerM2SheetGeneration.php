<?php
/**
 * Created by PhpStorm.
 * User: bhavin
 * Date: 09/11/2017
 * Time: 12:00 
 */

namespace App\Console\Commands;


use App\Lib\Account;
use App\Lib\AmazonS3;
use App\Lib\CompanyConfiguration;
use App\Lib\CronHelper;
use App\Lib\GatewayAccount;
use App\Lib\Helper;
use App\Lib\Job;
use App\Lib\JobFile;
use App\Lib\NeonExcelIO;
use App\Lib\User;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Maatwebsite\Excel\Facades\Excel;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;
use \Exception;

class CustomerM2SheetGeneration extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'customerm2sheetgeneration';

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

        $userInfo = User::getUserInfo($job->JobLoggedUserID);
        $joboptions = json_decode($job->Options);
        Log::useFiles(storage_path().'/logs/m2customersheetgeneration-'.$JobID.'-'.date('Y-m-d').'.log');
        $UPLOADPATH = CompanyConfiguration::get($CompanyID,'UPLOAD_PATH');

        DB::beginTransaction();
        try{
            $ProcessID = Uuid::generate();
            Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar

            $tunkids = '';
            $file_path = '';
            $amazonPath = '';
            if(isset($joboptions->Trunks) && is_array($joboptions->Trunks)){
                $tunkids = implode(',',$joboptions->Trunks);
            }else if(isset($joboptions->Trunks) && !is_array($joboptions->Trunks)){
                $tunkids = $joboptions->Trunks;
            }
            $timezoneid = $joboptions->Timezones;

            if(!empty($joboptions->downloadtype)){
                $downloadtype = $joboptions->downloadtype;
            }else{
                $downloadtype = 'csv';
            }
            $Effective = 'Now';
            if(!empty($joboptions->Effective)){
                $Effective = $joboptions->Effective;
                if($Effective == 'CustomDate') {
                    $CustomDate = $joboptions->CustomDate;
                } else {
                    $CustomDate = date('Y-m-d');
                }
            }
            $file_name = Job::getfileName($job->AccountID,$joboptions->Trunks,'customerdownload');
            $amazonDir = AmazonS3::generate_upload_path(AmazonS3::$dir['CUSTOMER_DOWNLOAD'],$job->AccountID,$CompanyID) ;
            //$excel_data = DB::select("CALL  prc_CronJobGenerateM2Sheet( '" .$job->AccountID . "','" . $tunkids."','".$Effective."' ) ");
            $query = "CALL  prc_CronJobGenerateM2Sheet( '" .$job->AccountID . "','" . $tunkids."'," . $timezoneid.",'".$Effective."','".$CustomDate."' ) ";
            //Log::info($query);
            $excel_data = DB::select($query);
            $excel_data = json_decode(json_encode($excel_data),true);

            if($downloadtype == 'xlsx'){
                $amazonPath = $amazonDir .  $file_name . '.xlsx';
                $file_path = $UPLOADPATH . '/'. $amazonPath ;
                $NeonExcel = new NeonExcelIO($file_path);
                $NeonExcel->write_excel($excel_data);
            }else if($downloadtype == 'csv'){
                $amazonPath = $amazonDir .  $file_name . '.csv';
                $file_path = $UPLOADPATH . '/'. $amazonPath ;
                $NeonExcel = new NeonExcelIO($file_path);
                $NeonExcel->write_csv($excel_data);
            }

            if(!AmazonS3::upload($file_path,$amazonDir,$CompanyID)){
                throw new Exception('Error in Amazon upload');
            }

            $jobdata['OutputFilePath'] = $amazonPath;
            $jobdata['JobStatusMessage'] = 'M2 Customer Rate File Generated Successfully';
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
            $jobdata['JobStatusMessage'] = 'M2 Customer Rate Download Failed::'.$e->getMessage();
            $jobdata['updated_at'] = date('Y-m-d H:i:s');
            $jobdata['ModifiedBy'] = 'RMScheduler';
            Job::where(["JobID" => $JobID])->update($jobdata);
            Log::error($e);
        }
        Job::send_job_status_email($job,$CompanyID);

        CronHelper::after_cronrun($this->name, $this);

    }

}