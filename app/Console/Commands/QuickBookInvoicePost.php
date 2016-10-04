<?php namespace App\Console\Commands;

use App\Lib\Account;
use App\Lib\CompanySetting;
use App\Lib\BillingAPI;
use App\Lib\CronHelper;
use App\Lib\Invoice;
use App\Lib\InvoiceDetail;
use App\Lib\InvoiceTaxRate;
use App\Lib\Job;
use App\Lib\Product;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;

class QuickBookInvoicePost extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'quickbookinvoicepost';

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
            ['JobID', InputArgument::REQUIRED, 'Argument JobID '],
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
        $CompanyID = $arguments["CompanyID"];
        $JobID = $arguments["JobID"];
        $errors = array();
        $message = array();
        $jobdata = array();

        $job = Job::find($JobID);
        $joboptions = json_decode($job->Options);
        $ProcessID = Uuid::generate();
        Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar

        Log::useFiles(storage_path() . '/logs/quickbookinvoicepost-' . $CompanyID . '-' . $JobID . '-' . date('Y-m-d') . '.log');

        try {

            if (isset($joboptions->InvoiceIDs)) {

                $QuickBooks = new BillingAPI($CompanyID);
                $connect = $QuickBooks->test_connection($CompanyID);

                if(!empty($connect)){

                    $InvoiceIDs = explode(',',$joboptions->InvoiceIDs);
                    $InvoiceAccounts = array();
                    $InvoiceItems = array();
                    if(count($InvoiceIDs) > 0){
                        foreach ($InvoiceIDs as $InvoiceID) {
                            $Invoice = Invoice::find($InvoiceID);
                            $AccountID = $Invoice->AccountID;
                            $InvoiceAccounts['AccountID'][] = $AccountID;
                        }
                    }
                    $InvoiceAccounts = array_filter(array_unique($InvoiceAccounts['AccountID']));
                    $AccountOptions = array();
                    $AccountOptions['CompanyID'] = $CompanyID;
                    $AccountOptions['Accounts'] = $InvoiceAccounts;
                    Log::info('-- QuickBook Customer Options--');
                    //Log::error($AccountOptions);

                    $Customer = $QuickBooks->addCustomers($AccountOptions);

                    //Log::info(print_r($Customer,true));

                    if(count($InvoiceIDs) > 0){
                        foreach ($InvoiceIDs as $InvoiceID) {
                            $Invoice = Invoice::find($InvoiceID);
                            $InvoiceDetails = InvoiceDetail::where(["InvoiceID" => $InvoiceID])->get();
                            if(!empty($InvoiceDetails) && count($InvoiceDetails)>0){
                                foreach($InvoiceDetails as $InvoiceDetail){
                                    Log::info('Product id'.$InvoiceDetail->ProductID);
                                    Log::info('Product Type'.$InvoiceDetail->ProductType);
                                    $ProductID = $InvoiceDetail->ProductID;
                                    $ProductType = $InvoiceDetail->ProductType;
                                    if(!empty($ProductType)){
                                        $ProductName = Product::getProductName($ProductID,$ProductType);
                                        $InvoiceItems['ProductName'][] = $ProductName;
                                    }
                                }
                            }

                            $InvoiceTaxRates = InvoiceTaxRate::where(["InvoiceID" => $InvoiceID])->get();
                            if(!empty($InvoiceTaxRates) && count($InvoiceTaxRates)>0){
                                foreach($InvoiceTaxRates as $InvoiceTaxRate){
                                    $TaxName = $InvoiceTaxRate->Title;
                                    $InvoiceItems['ProductName'][] = $TaxName;
                                }
                            }
                        }
                    }

                    $InvoiceItems = array_filter(array_unique($InvoiceItems['ProductName']));

                    $ItemOptions = array();
                    $ItemOptions['CompanyID'] = $CompanyID;
                    $ItemOptions['Products'] = $InvoiceItems;

                    $Items = $QuickBooks->addItems($ItemOptions);
                    //Log::info(' -- items --');
                    //Log::info(print_r($Items,true));


                    $invoiceOptions = array();
                    $invoiceOptions['CompanyID'] = $CompanyID;
                    $invoiceOptions['Invoices'] = $InvoiceIDs;
                    $Invoices = $QuickBooks->addInvoices($invoiceOptions);
                    //Log::info(' -- invoices --');
                    //Log::info(print_r($Invoices,true));

                    $job = Job::find($JobID);
                    $jobdata['JobStatusMessage'] = '';
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','S')->pluck('JobStatusID');
                    $jobdata['updated_at'] = date('Y-m-d H:i:s');
                    $jobdata['ModifiedBy'] = 'RMScheduler';
                    Job::where(["JobID" => $JobID])->update($jobdata);

                    Job::send_job_status_email($job, $CompanyID);

                }else{

                    $job = Job::find($JobID);
                    $jobdata['JobStatusMessage'] = 'QuickBook API Not Setup Correctly';
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','F')->pluck('JobStatusID');
                    $jobdata['updated_at'] = date('Y-m-d H:i:s');
                    $jobdata['ModifiedBy'] = 'RMScheduler';
                    Job::where(["JobID" => $JobID])->update($jobdata);

                    Job::send_job_status_email($job, $CompanyID);
                }


            }

        } catch (\Exception $e) {

            try {
                Log::info(' ========================== Exception occured =============================');
                Log::error($e);
                if ($JobID > 0) {
                    $job = Job::find($JobID);
                    $JobStatusMessage = $job->JobStatusMessage;
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                    $jobdata['JobStatusMessage'] .= $JobStatusMessage . '\n\r' . $e->getMessage();
                    Job::where(["JobID" => $JobID])->update($jobdata);
                    $job = Job::find($JobID);
                    Job::send_job_status_email($job, $CompanyID);
                    Log::info(' ========================== Exception updated in job and email sent =============================');
                }

                Log::info(' =======================================================');

            } catch (\Exception $err) {
                Log::error($err);
            }

        }

        CronHelper::after_cronrun($this->name, $this);


    }

}
