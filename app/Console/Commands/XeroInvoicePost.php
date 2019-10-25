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
use App\Lib\Xero;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;

class XeroInvoicePost extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'xeroinvoicepost';

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
        $successmessage = array();
        $errormessage = array();
        $results = array();
        $jobdata = array();

        $job = Job::find($JobID);
        $joboptions = json_decode($job->Options);


        Log::useFiles(storage_path() . '/logs/xeroinvoicepost-' . $CompanyID . '-' . $JobID . '-' . date('Y-m-d') . '.log');

        try {
            $ProcessID = Uuid::generate();
            Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar

            if (isset($joboptions->InvoiceIDs)) {

                $XeroConnection = new Xero($CompanyID);
                $connect = $XeroConnection->test_connection($CompanyID);

                if(!empty($connect)){


                    if(isset($joboptions->type) && $joboptions->type == 'journal'){

                        //invoice journal post start

                        $InvoiceIDs = explode(',',$joboptions->InvoiceIDs);
                        $journalOptions = array();
                        $journalOptions['CompanyID'] = $CompanyID;
                        $journalOptions['Invoices'] = $InvoiceIDs;
                        $results = $XeroConnection->addJournals($journalOptions);

                        if(!empty($results['error']) && count($results['error'])>0){
                            foreach($results['error'] as $err){
                                $errormessage[] = $err;
                            }
                        }
                        if(!empty($results['Success'])) {
                            foreach($results['Success'] as $Successmsg){
                                $successmessage[] = $Successmsg;
                            }
                        }


                        //log::info(print_r($journals,true));

                        //invoice journal post over


                    }else{
                        //invoice post over start
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
                        $AccountOptions = array();
                        $AccountOptions['CompanyID'] = $CompanyID;
                        $AccountOptions['Accounts'] = $InvoiceAccounts;
                        Log::info('-- Xero Customer Options--');
                        //Log::error($AccountOptions);

                        $Customer = $XeroConnection->addCustomers($AccountOptions);
                        //$Customer = array_filter($Customer);

                        //Log::info(print_r($Customer,true));

                        /**
                        Item will not create
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

                        $Items = $XeroConnection->addItems($ItemOptions);
                        //Log::info(' -- items --');
                        //Log::info(print_r($Items,true));

                        */
                        $invoiceOptions = array();
                        $invoiceOptions['CompanyID'] = $CompanyID;
                        $invoiceOptions['Invoices'] = $InvoiceIDs;
                        $Invoices = $XeroConnection->addInvoices($invoiceOptions);

                        $results = array_merge($Customer,$Invoices);
                        $results = array_filter($results);


                        foreach($results as $result){
                            if(!empty($result['error'])){
                                if(!empty($result['error_reason'])){
                                    $errormessage[] = $result['error'].'\n\r'.$result['error_reason'];
                                }else{
                                    $errormessage[] = $result['error'];
                                }
                            }
                            if(!empty($result['Success'])) {
                                $successmessage[] = $result['Success'];
                            }
                        }

                    }
                    //invoice post over

                    log::info(print_r($successmessage,true));
                    log::info(print_r($errormessage,true));

                    //exit;

                    //$Invoices = array_filter($Invoices);
                    //Log::info(' -- invoices --');
                    //Log::info(print_r($Invoices,true));
                    if(!empty($errormessage) && count($errormessage)>0 && !empty($successmessage) && count($successmessage)>0){
                        $error = array_merge($errormessage,$successmessage);
                        $job = Job::find($JobID);
                        $jobdata['JobStatusMessage'] = implode(',\n\r',fix_jobstatus_meassage($error));
                        $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','PF')->pluck('JobStatusID');
                        $jobdata['updated_at'] = date('Y-m-d H:i:s');
                        $jobdata['ModifiedBy'] = 'RMScheduler';
                        Job::where(["JobID" => $JobID])->update($jobdata);
                    }elseif(empty($successmessage) && !empty($errormessage) && count($errormessage)>0){
                        $job = Job::find($JobID);
                        $jobdata['JobStatusMessage'] = implode(',\n\r',fix_jobstatus_meassage($errormessage));
                        $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','F')->pluck('JobStatusID');
                        $jobdata['updated_at'] = date('Y-m-d H:i:s');
                        $jobdata['ModifiedBy'] = 'RMScheduler';
                        Job::where(["JobID" => $JobID])->update($jobdata);
                    }elseif(empty($errormessage) && !empty($successmessage) && count($successmessage)>0){
                        $job = Job::find($JobID);
                        $jobdata['JobStatusMessage'] = implode(',\n\r',fix_jobstatus_meassage($successmessage));
                        $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','S')->pluck('JobStatusID');
                        $jobdata['updated_at'] = date('Y-m-d H:i:s');
                        $jobdata['ModifiedBy'] = 'RMScheduler';
                        Job::where(["JobID" => $JobID])->update($jobdata);
                    }else{
                        $job = Job::find($JobID);
                        $jobdata['JobStatusMessage'] = 'Invoice Create Failed';
                        $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','F')->pluck('JobStatusID');
                        $jobdata['updated_at'] = date('Y-m-d H:i:s');
                        $jobdata['ModifiedBy'] = 'RMScheduler';
                        Job::where(["JobID" => $JobID])->update($jobdata);
                    }
                    Job::send_job_status_email($job, $CompanyID);

                }else{

                    $job = Job::find($JobID);
                    $jobdata['JobStatusMessage'] = 'Xero API Not Setup Correctly';
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','F')->pluck('JobStatusID');
                    $jobdata['updated_at'] = date('Y-m-d H:i:s');
                    $jobdata['ModifiedBy'] = 'RMScheduler';
                    Job::where(["JobID" => $JobID])->update($jobdata);

                    Job::send_job_status_email($job, $CompanyID);
                }
            }

        } catch (\Exception $e) {

                Log::info(' ========================== Exception occured =============================');
                Log::error($e);

                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                $jobdata['JobStatusMessage'] = 'Exception: ' . $e->getMessage();
                $jobdata['updated_at'] = date('Y-m-d H:i:s');
                $jobdata['ModifiedBy'] = 'RMScheduler';
                Job::where(["JobID" => $JobID])->update($jobdata);

                Job::send_job_status_email($job, $CompanyID);
                Log::info(' ========================== Exception updated in job and email sent =============================');

        }

        CronHelper::after_cronrun($this->name, $this);

    }

}
