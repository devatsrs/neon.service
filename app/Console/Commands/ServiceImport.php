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
        $url = CompanyConfiguration::where(['CompanyID' => $CompanyID, 'Key' => 'WEB_URL'])->pluck('Value');


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
            $errorslog = array();
            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'I')->pluck('JobStatusID');
            Job::where(["JobID" => $JobID])->update($jobdata);
            foreach ($results as $temp_row) {
            
                $checkemptyrow = array_filter(array_values($temp_row));
                if(!empty($checkemptyrow)){
                    $tempItemData = array();
                    $tempItemData['AccountDynamicField'] = array();
                    $tempItemData['Numbers'] = array();
                    $Number = array();
                    // if (isset($temp_row['AccountNo']) && !empty($temp_row['AccountNo'])) {
                    //     $tempItemData['AccountNo'] = $temp_row['AccountNo'];
                    // } 
                    // if (isset($temp_row['AccountID'])) {
                    //     $tempItemData['AccountID'] = trim($temp_row['AccountID']);
                    // }
                    

                    if (isset($temp_row['CustomerId'])) {
                        array_push($tempItemData['AccountDynamicField'] ,  [
                            "Name" => "CustomerID",
                            "Value" => $temp_row['CustomerId']
                        ]);
                    }

                    if (isset($temp_row['Number'])) {
                        $Number['NumberPurchased'] = $temp_row['Number'];
                    }

                    if (isset($temp_row['OrderID'])) {
                        $tempItemData['OrderID'] = "1";
                    }

                    if (isset($temp_row['PackageProductId'])) {
                        $Number['PackageProductID'] = $temp_row['PackageProductId'];
                    }

                    if (isset($temp_row['NumberStartDate'])) {
                        $NumberStartDate = explode('.',$temp_row['NumberStartDate']);
                        $Number['ContractStartDate'] = $NumberStartDate[0];
                    }

                    if (isset($temp_row['NumberEndDate'])) {
                        $NumberEndDate = explode('.',$temp_row['NumberEndDate']);
                        $Number['ContractEndDate'] = $NumberEndDate[0];
                    }
                    
                    if (isset($temp_row['PackageStartDate'])) {
                        $PackageStartDate = explode('.',$temp_row['PackageStartDate']);
                        $Number['PackageStartDate'] = $PackageStartDate[0];
                    }

                    if (isset($temp_row['PackageEndDate'])) {
                        $PackageEndDate = explode('.',$temp_row['PackageEndDate']);
                        $Number['PackageEndDate'] =  $PackageEndDate[0];
                    }

                    if (isset($temp_row['PackageContractId'])) {
                        $Number['PackageContractID'] = $temp_row['PackageContractId'];
                    }

                    if (isset($temp_row['NumberContractId'])) {
                        $Number['NumberContractID'] = $temp_row['NumberContractId'];
                    }

                    if (isset($temp_row['NumberProductId'])) {
                        $Number['ProductID'] = $temp_row['NumberProductId'];
                    }

                    $Number['InboundTariffCategoryID'] = "1";
                    

                    array_push($tempItemData['Numbers'] ,  $Number);
                    
                    //if (isset($temp_row['AccountNo']) && !empty($temp_row['AccountName']) && isset($temp_row['CustomerId']) && !empty($temp_row['CustomerId']) && isset($temp_row['BillingType']) && !empty($temp_row['BillingType']) && isset($temp_row['BillingStartDate']) && !empty($temp_row['BillingStartDate'])) {
                    $PricingJSONInput = json_encode($tempItemData, true);
                    $Response = NeonAPI::callAPI($PricingJSONInput , '/api/addNewAccountService' , $url,'application/json');
                    if($Response['HTTP_CODE'] != 200){
                        $errorslog[] = $temp_row['Number'] . ':' . $Response['error'];
                    }                
                    //} else {
                        //Log::error($temp_row['AccountNo'] . ' skipped line number' . $lineno);
                    //}
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
                $jobdata['JobStatusMessage'] = count($errorslog).' Service import log errors: '.implode(',\n\r',$errorslog);
                Job::where(["JobID" => $JobID])->update($jobdata);
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
