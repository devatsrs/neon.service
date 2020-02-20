<?php namespace App\Console\Commands;

use App\Lib\CronHelper;
use App\Lib\NeonAPI;
use App\Lib\AmazonS3;
use App\Lib\SummeryData;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Lib\Job;
use App\Lib\JobFile;
use Maatwebsite\Excel\Facades\Excel;
use App\Lib\NeonExcelIO;
use Webpatser\Uuid\Uuid;
use Symfony\Component\Console\Input\InputArgument;
use Exception;
use App\Lib\CompanySetting;
use App\Lib\CompanyConfiguration;

class ServiceImport extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'serviceimport';

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
        $CompanyID = $arguments["CompanyID"];
        $job = Job::find($JobID);
        $jobfile = JobFile::where(['JobID' => $JobID])->first();
        $TEMP_PATH = CompanyConfiguration::get($CompanyID,'TEMP_PATH').'/';
        if ($jobfile->FilePath) {
            $path = AmazonS3::unSignedUrl($jobfile->FilePath, $CompanyID);
            if (strpos($path, "https://") !== false) {
                $file = $TEMP_PATH . basename($path);
                file_put_contents($file, file_get_contents($path));
                $jobfile->FilePath = $file;
            } else {
                $jobfile->FilePath = $path;
            }
        }

		//$dir = 'C:\Users\lenovo\Documents\accounts\Accounts.xlsx';
       
        Log::useFiles(storage_path() . '/logs/impotServiceData-' . date('Y-m-d') . '.log');

        try {
            $filepath = $jobfile->FilePath;

            Log::info($filepath . '  - Processing ');

            //$results = Excel::load($filepath)->toArray();
            $NeonExcel = new NeonExcelIO($filepath);
            $results = $NeonExcel->read();

            Log::info(count($results) . '  - Records Found ');

            $lineno = 2;
            $error = array();

            foreach ($results as $temp_row) {
            
                $checkemptyrow = array_filter(array_values($temp_row));
                if(!empty($checkemptyrow)){
                    $tempItemData = array();
                    $tempItemData['AccountDynamicField'] = array();
                    $tempItemData['Number'] = array();
                    $Number = array();
                    if (isset($temp_row['AccountNo']) && !empty($temp_row['AccountNo'])) {
                        $tempItemData['AccountNo'] = $temp_row['AccountNo'];
                    } 
                    if (isset($temp_row['AccountID'])) {
                        $tempItemData['AccountID'] = trim($temp_row['AccountID']);
                    }
                    

                    if (isset($temp_row['Customer'])) {
                        array_push($tempItemData['AccountDynamicField'] ,  [
                            "Name" => "CustomerID",
                            "Value" => $temp_row['CustomerId']
                        ]);
                    }

                    if (isset($temp_row['Number'])) {
                        $Number['NumberPurchased'] = $temp_row['Number'];
                    }

                    if (isset($temp_row['OrderID'])) {
                        $tempItemData['OrderId'] = $temp_row['OrderID'];
                    }

                    if (isset($temp_row['PackageProductId'])) {
                        $Number['PackageProductID'] = $temp_row['PackageProductId'];
                    }

                    if (isset($temp_row['NumberStartDate'])) {
                        $Number['ContractStartDate'] = $temp_row['NumberStartDate'];
                    }

                    if (isset($temp_row['NumberEndDate'])) {
                        $Number['ContractEndDate'] = $temp_row['NumberEndDate'];
                    }
                    
                    if (isset($temp_row['PackageStartDate'])) {
                        $Number['PackageStartDate'] = $temp_row['PackageStartDate'];
                    }

                    if (isset($temp_row['PackageEndDate'])) {
                        $Number['PackageEndDate'] = $temp_row['PackageEndDate'];
                    }

                    if (isset($temp_row['PackageContractId'])) {
                        $Number['PackageContractID'] = $temp_row['PackageContractId'];
                    }

                    if (isset($temp_row['NumberContractId'])) {
                        $Number['NumberContractID'] = $temp_row['NumberContractId'];
                    }

                    if (isset($temp_row['NumberProductId'])) {
                        $Number['ProductId'] = $temp_row['NumberProductId'];
                    }

                    if (isset($temp_row['InboundTariffCategoryId'])) {
                        $Number['InboundTariffCategoryID'] = $temp_row['InboundTariffCategoryId'];
                    }

                    array_push($tempItemData['Number'] ,  $Number);
                    
                    
                    if (isset($temp_row['AccountNo']) && !empty($temp_row['AccountName']) && isset($temp_row['CustomerId']) && !empty($temp_row['CustomerId']) && isset($temp_row['BillingType']) && !empty($temp_row['BillingType']) && isset($temp_row['BillingStartDate']) && !empty($temp_row['BillingStartDate'])) {
                        $PricingJSONInput = json_encode($tempItemData, true);
                        $Response = NeonAPI::callAPI($PricingJSONInput , 'api/addNewAccountService' , 'http://localhost/neon/web/staging/public/','json');
                        if($Response['HTTP_CODE'] != 200){
                            $errorslog[] = $temp_row['AccountName'] . ':' . $Response['error'];
                        }                
                    } else {
                        Log::error($temp_row['AccountNo'] . ' skipped line number' . $lineno);
                    }
                }
            }   
            $job = Job::find($JobID);
            $jobdata['JobStatusMessage'] = 'Accounts have imported successfully';
            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'S')->pluck('JobStatusID');
            $jobdata['updated_at'] = date('Y-m-d H:i:s');
            $jobdata['ModifiedBy'] = 'RMScheduler';
            Job::where(["JobID" => $JobID])->update($jobdata);

            if(isset($errorslog) && count($errorslog) > 0){
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','PF')->pluck('JobStatusID');
                $jobdata['JobStatusMessage'] .= count($errorslog).' Account import log errors: '.implode(',\n\r',$errorslog);
            }

        }catch (\Exception $ex){

            Log::error($ex);
            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
            $jobdata['JobStatusMessage'] = 'Exception: ' . $ex->getMessage();
            $jobdata['updated_at'] = date('Y-m-d H:i:s');
            $jobdata['ModifiedBy'] = 'RMScheduler';
            Job::where(["JobID" => $JobID])->update($jobdata);
            Log::error($ex);
        }
        Job::send_job_status_email($job,$CompanyID);

        CronHelper::after_cronrun($this->name, $this);

    }


}
