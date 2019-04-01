<?php namespace App\Console\Commands;

use App\Lib\Company;
use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\Job;
use App\Lib\Timezones;
use App\Lib\VendorTrunk;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;

class SippyVendorRatePush extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'sippyvendorratepush';

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
    /**
     * Get the console command arguments.
     *
     * @return array
     */
    protected function getArguments()
    {
        return [
            ['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID '],
            ['CronJobID', InputArgument::REQUIRED, 'Argument CronJobID'],
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
        $CronJobID = $arguments["CronJobID"];
        $CompanyID = $arguments["CompanyID"];
        $CronJob = CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);
        CronJob::activateCronJob($CronJob);
        $CompanyGatewayID = $cronsetting['CompanyGatewayID'];
        Log::useFiles(storage_path() . '/logs/streamcoaccountimport-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');
        $joblogdata['Message'] = '';
        $UPLOADPATH = CompanyConfiguration::get($CompanyID,'UPLOAD_PATH');
        $processID = CompanyGateway::getProcessID();

        try {
            $AccountIDs = $cronsetting->AccountIDs;
            $TimezoneIDs = Timezones::getTimezonesIDList();

            foreach ($AccountIDs as $AccountID) {
                $VendorTrunks = VendorTrunk::where('AccountID',$AccountID);
                if($VendorTrunks->count() > 0) {
                    $VendorTrunkIDs = $VendorTrunks->get();
                    foreach ($VendorTrunkIDs as $VendorTrunkID) {
                        $TrunkID = $VendorTrunkID->TrunkID;
                        foreach ($TimezoneIDs as $TimezoneID => $TimezoneTitle) {
                            $file_path      = '';
                            $amazonPath     = '';
                            $downloadtype   = 'csv';
                            $Effective      = 'Now';
                            $CustomDate     = date('Y-m-d');

                            $file_name = Job::getfileName($AccountID,$TrunkID,'vendorsippydownload');
                            $amazonDir = AmazonS3::generate_upload_path(AmazonS3::$dir['VENDOR_DOWNLOAD'],$AccountID,$CompanyID) ;
                            //$local_dir = getenv('UPLOAD_PATH') . '/'.$amazonPath;

                            $query = "CALL  prc_WSGenerateVendorSippySheet ('" .$AccountID . "','" . $TrunkID."'," . $TimezoneID.",'".$Effective."','".$CustomDate."')";
                            Log::info($query);
                            $excel_data = DB::select($query);

                            if(count($excel_data) > 0) {
                                $excel_data = json_decode(json_encode($excel_data), true);

                                //Fix .333 to 0.333 on following column
                                foreach ($excel_data as $key => $excel_val) {
                                    foreach (['Price 1', 'Price N'] as $field) {
                                        $excel_data[$key][$field] = number_format($excel_val[$field], 9, '.', '');
                                    }
                                }

                                if ($downloadtype == 'xlsx') {
                                    $amazonPath = $amazonDir . $file_name . '.xlsx';
                                    $file_path = $UPLOADPATH . '/' . $amazonPath;
                                    $NeonExcel = new NeonExcelIO($file_path);
                                    $NeonExcel->write_excel($excel_data);
                                } else if ($downloadtype == 'csv') {
                                    $amazonPath = $amazonDir . $file_name . '.csv';
                                    $file_path = $UPLOADPATH . '/' . $amazonPath;
                                    $NeonExcel = new NeonExcelIO($file_path);
                                    $NeonExcel->write_csv($excel_data);
                                }

                                if(!AmazonS3::upload($file_path,$amazonDir,$CompanyID)){
                                    throw new Exception('Error in Amazon upload');
                                }
                                $fullPath = $amazonPath; //$destinationPath . $file_name;
                                $jobdata['OutputFilePath'] = $fullPath;
                                $jobdata['JobStatusMessage'] = 'Vendor Sippy File Generated Successfully';
                                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','S')->pluck('JobStatusID');
                                $jobdata['updated_at'] = date('Y-m-d H:i:s');
                                $jobdata['ModifiedBy'] = 'RMScheduler';
                                Job::where(["JobID" => $JobID])->update($jobdata);

                                DB::commit();
                            }
                        }
                    }
                }
            }
        } catch (\Exception $e) {
            try {
                DB::rollback();
            } catch (Exception $err) {
                Log::error($err);
            }
            date_default_timezone_set(Config::get('app.timezone'));
            $this->info('Failed:' . $e->getMessage());
            $joblogdata['Message'] = 'Error:' . $e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;

            Log::error($e);
            if(!empty($cronsetting['ErrorEmail'])) {
                $result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
                Log::error("**Email Sent Status " . $result['status']);
                Log::error("**Email Sent message " . $result['message']);
            }
        }
        CronJobLog::createLog($CronJobID,$joblogdata);
        CronJob::deactivateCronJob($CronJob);
        if(!empty($cronsetting['SuccessEmail'])) {
            $result = CronJob::CronJobSuccessEmailSend($CronJobID);
            Log::error("**Email Sent Status ".$result['status']);
            Log::error("**Email Sent message ".$result['message']);
        }

        CronHelper::after_cronrun($this->name, $this);

    }
}

