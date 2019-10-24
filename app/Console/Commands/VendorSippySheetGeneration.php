<?php namespace App\Console\Commands;

use App\Lib\CompanyConfiguration;
use App\Lib\CronHelper;
use App\Lib\RateTable;
use App\Lib\RateType;
use Illuminate\Console\Command;
use Symfony\Component\Console\Input\InputArgument;
use App\Lib\AmazonS3;
use App\Lib\Job;
use App\Lib\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Maatwebsite\Excel\Facades\Excel;
use App\Lib\NeonExcelIO;
use Webpatser\Uuid\Uuid;
use \Exception;

class VendorSippySheetGeneration extends Command {

	protected $name = 'vendorsippysheetgeneration';
	protected $description = 'Command description.';

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

	public function fire()
	{

        CronHelper::before_cronrun($this->name, $this );

        $arguments = $this->argument();
        $getmypid = getmypid(); // get proccess id added by abubakar
        $JobID = $arguments["JobID"];
        $CompanyID = $arguments["CompanyID"];

        $job = Job::find($JobID);

        $userInfo = User::getUserInfo($job->JobLoggedUserID);
        $joboptions = json_decode($job->Options);

        Log::useFiles(storage_path().'/logs/vendorsippysheet-'.$JobID.'-'.date('Y-m-d').'.log');
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
            $file_name = Job::getfileName($job->AccountID,$joboptions->Trunks,'vendorsippydownload');
            $amazonDir = AmazonS3::generate_upload_path(AmazonS3::$dir['VENDOR_DOWNLOAD'],$job->AccountID,$CompanyID) ;
            //$local_dir = getenv('UPLOAD_PATH') . '/'.$amazonPath;
            $Effective = 'Now';
            if(!empty($joboptions->Effective)){
                $Effective = $joboptions->Effective;
                if($Effective == 'CustomDate') {
                    $CustomDate = $joboptions->CustomDate;
                } else {
                    $CustomDate = date('Y-m-d');
                }
            }

            $AppliedToVendor=RateTable::APPLIED_TO_VENDOR;
            $VoiceCallTypeID=RateType::getRateTypeIDBySlug(RateType::SLUG_VOICECALL);
            $query = "CALL  prc_WSGenerateVendorSippySheet ('" .$job->AccountID . "','" . $tunkids."'," . $timezoneid.",'".$Effective."','".$CustomDate."',".$AppliedToVendor.",".$VoiceCallTypeID.")";
            Log::info($query);
            $excel_data = DB::select($query);
            $excel_data = json_decode(json_encode($excel_data),true);

            //Fix .333 to 0.333 on following column
            foreach($excel_data  as $key => $excel_val){
                foreach(['Price 1','Price N'] as $field){
                    $excel_data[$key][$field] = number_format($excel_val[$field],9,'.','');
                }
            }

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

            /*
            Excel::create($file_name, function ($excel) use ($excel_data,$file_name) {
                $excel->sheet('Sheet', function ($sheet) use ($excel_data) {
                    $sheet->fromArray($excel_data);
                });
            })->store('csv',$local_dir);
            $file_name .='.csv';

            if(!AmazonS3::upload($local_dir.'/'.$file_name,$amazonPath)){
                throw new Exception('Error in Amazon upload');
            }*/
            $fullPath = $amazonPath; //$destinationPath . $file_name;
            $jobdata['OutputFilePath'] = $fullPath;
            $jobdata['JobStatusMessage'] = 'Vendor Sippy File Generated Successfully';
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
