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

class AccountImport extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'accountimport';

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

		// $dir = 'C:\Users\lenovo\Documents\accounts\Accounts.xlsx';
       
        Log::useFiles(storage_path() . '/logs/impotAccountData-' . date('Y-m-d') . '.log');

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
                if($temp_row['IsPartner'] == 1 || $temp_row['IsReseller'] == 1){
                    $checkemptyrow = array_filter(array_values($temp_row));
                    if(!empty($checkemptyrow)){
                        $tempItemData = array();
                        $tempItemData['AccountDynamicField'] = array();

                        if (isset($temp_row['AccountNo']) && !empty($temp_row['AccountNo'])) {
                            $tempItemData['AccountNo'] = $temp_row['AccountNo'];
                        } 
                        if (isset($temp_row['AccountName'])) {
                            $tempItemData['AccountName'] = trim($temp_row['AccountName']);
                        }
                        if (isset($temp_row['Phone'])) {
                            $tempItemData['Phone'] = $temp_row['Phone'];
                        }
                        if (isset($temp_row['BilllingAddress1'])) {
                            $tempItemData['BillingAddress1'] = $temp_row['BillingAddress1'];
                        }
                        if (isset($temp_row['BillingAddress2'])) {
                            $tempItemData['BillingAddress2'] = $temp_row['BillingAddress2'];
                        }
                        if (isset($temp_row['BillingAddress3'])) {
                            $tempItemData['BillingAddress3'] = $temp_row['BillingAddress3'];
                        }

                        if (isset($temp_row['BillingCity'])) {
                            $tempItemData['BillingCity'] = $temp_row['BillingCity'];
                        }

                        if (isset($temp_row['BilllingPostCode'])) {
                            $tempItemData['BilllingPostCode'] = $temp_row['BilllingPostCode'];
                        }


                        if (isset($temp_row['BillingEmail'])) {
                            $tempItemData['BillingEmail'] = $temp_row['BillingEmail'];
                        }
                        
                        if (isset($temp_row['BillingCountryIso'])) {
                            $tempItemData['CountryIso2'] = $temp_row['BillingCountryIso'];
                        }

                        if (isset($temp_row['IsVendor'])) {
                            $tempItemData['IsVendor'] = $temp_row['IsVendor'];
                        }

                        if (isset($temp_row['IsCustomer'])) {
                            $tempItemData['IsCustomer'] = $temp_row['IsCustomer'];
                        }
                        
                        if (isset($temp_row['IsPartner'])) {
                            $tempItemData['IsPartner'] = $temp_row['IsPartner'];
                        }

                        if (isset($temp_row['IsAffiliate'])) {
                            $tempItemData['IsAffiliate'] = $temp_row['IsAffiliate'];
                        }

                        if (isset($temp_row['Currency'])) {
                            $tempItemData['Currency'] = $temp_row['Currency'];
                        }
                        
                        if (isset($temp_row['VatNumber'])) {
                            $tempItemData['VatNumber'] = $temp_row['VatNumber'];
                        }

                        if (isset($temp_row['BillingType'])) {
                            $tempItemData['BillingTypeID'] = $temp_row['BillingType'];
                        }
                        
                        if (isset($temp_row['parentId'])) {
                            $tempItemData['PartnerID'] = $temp_row['parentId'];
                        }

                        $tempItemData['PartnerEmail'] = 'neon@speakintelligence.com';
                        $tempItemData['PartnerPanelPassword'] = 'Welcome12345';
                      
                        if (isset($temp_row['LanguageIso'])) {
                            $tempItemData['LanguageIso2'] = $temp_row['LanguageIso'];
                        }

                        if (isset($temp_row['BillingStartDate'])) {
                            $tempItemData['BillingStartDate'] = "2019-12-01";
                        }

                        if (isset($temp_row['AutoTopup'])) {
                            $tempItemData['AutoTopup'] = $temp_row['AutoTopup'];
                        }
                        
                        if (isset($temp_row['MinThreshold'])) {
                            $tempItemData['MinThreshold'] = $temp_row['MinThreshold'];
                        }

                        if (isset($temp_row['TopupAmount'])) {
                            $tempItemData['TopupAmount'] = $temp_row['TopupAmount'];
                        }

                        if (isset($temp_row['AutoOutpayment'])) {
                            $tempItemData['AutoOutpayment'] = $temp_row['AutoOutpayment'];
                        }

                        if (isset($temp_row['OutPaymentThreshold'])) {
                            $tempItemData['OutPaymentThreshold'] = $temp_row['OutPaymentThreshold'];
                        }
                        
                        if (isset($temp_row['OutPaymentAmount'])) {
                            $tempItemData['OutPaymentAmount'] = $temp_row['OutPaymentAmount'];
                        }

                        if (isset($temp_row['CustomerId'])) {
                            array_push($tempItemData['AccountDynamicField'] ,  [
                                "Name" => "CustomerID",
                                "Value" => $temp_row['CustomerId']
                            ]);
                        }

                        // if (isset($temp_row['poNumber'])) {
                        //     array_push($tempItemData['AccountDynamicField'] , [
                        //         "Name" => "PONumber",
                        //         "Value" => $temp_row['poNumber']
                        //     ]);
                        // }

                        if (isset($temp_row['RegisterDutchFoundation'])) {
                            array_push($tempItemData['AccountDynamicField'] ,  [
                                "Name" => "RegisterDutchFoundation",
                                "Value" => $temp_row['RegisterDutchFoundation']
                            ]);
                        }
                        
                        if (isset($temp_row['CocNumber'])) {

                            array_push($tempItemData['AccountDynamicField'] ,  [
                                "Name" => "COCNumber",
                                "Value" => $temp_row['CocNumber']
                            ]);
                            
                        }

                        if (isset($temp_row['AutoPay'])) {
                            $tempItemData['AutoPay'] = $temp_row['AutoPay'];
                        }

                        if (isset($temp_row['Active'])) {
                            $tempItemData['Active'] = $temp_row['Active'];
                        }

                        if (isset($temp_row['PaymentMethod'])) {
                            $tempItemData['PaymentMethodID'] = "1";
                        }
                        
                        // if (isset($temp_row['OutpaymentMethod']) && !empty($temp_row['OutpaymentMethod']) && $temp_row['OutpaymentMethod'] == "NULL") {
                        //     $tempItemData['PayoutMethodID'] = $temp_row['OutpaymentMethod'];
                        // }

                        if (isset($temp_row['BankAccount'])) {
                            $tempItemData['BankAccount'] = $temp_row['BankAccount'];
                        }
                        if (isset($temp_row['BankAccount'])) {
                            $tempItemData['Title'] = trim($temp_row['AccountName']);
                        }

                        if (isset($temp_row['BIC'])) {
                            $tempItemData['BIC'] = $temp_row['BIC'];
                        }

                        if (isset($temp_row['AccountHolderName'])) {
                            $tempItemData['AccountHolderName'] = $temp_row['AccountHolderName'];
                        }
                        
                        if (isset($temp_row['OutpaymentMethodTitle'])) {
                            $tempItemData['PayoutTitle'] = $temp_row['OutpaymentMethodTitle'];
                        }

                        if (isset($temp_row['OutpaymentMethodBankAccount'])) {
                            $tempItemData['PayoutBankAccount'] = $temp_row['OutpaymentMethodBankAccount'];
                        }

                        if (isset($temp_row['OutpaymentMethodBIC'])) {
                            $tempItemData['PayoutBIC'] = $temp_row['OutpaymentMethodBIC'];
                        }
                        
                        if (isset($temp_row['OutpaymentMethodAccountHolderName'])) {
                            $tempItemData['PayoutAccountHolderName'] = $temp_row['OutpaymentMethodAccountHolderName'];
                        }

                        if (isset($temp_row['OutpaymentMethodMandateCode'])) {
                            $tempItemData['PayoutMandateCode'] = $temp_row['OutpaymentMethodMandateCode'];
                        }

                        if (isset($temp_row['CardToken'])) {
                            $tempItemData['CardToken'] = $temp_row['CardToken'];
                        }

                        if (isset($temp_row['CardHolderName'])) {
                            $tempItemData['CardHolderName'] = $temp_row['CardHolderName'];
                        }

                        if (isset($temp_row['ExpirationMonth'])) {
                            $tempItemData['ExpirationMonth'] = $temp_row['ExpirationMonth'];
                        }

                        if (isset($temp_row['ExpirationYear'])) {
                            $tempItemData['ExpirationYear'] = $temp_row['ExpirationYear'];
                        }
                        
                        if (isset($temp_row['LastDigit'])) {
                            $tempItemData['LastDigit'] = $temp_row['LastDigit'];
                        }

                        
                        if (isset($temp_row['AccountNo']) && !empty($temp_row['AccountName']) && isset($temp_row['CustomerId']) && !empty($temp_row['CustomerId']) && isset($temp_row['BillingType']) && !empty($temp_row['BillingType']) && isset($temp_row['BillingStartDate']) && !empty($temp_row['BillingStartDate'])) {
                            $PricingJSONInput = json_encode($tempItemData, true);
                            $Response = NeonAPI::callAPI($PricingJSONInput , '/api/createAccount' , $url ,'application/json');
                            Log::info($temp_row['AccountNo'] . print_r($Response,true));
                            if($Response['HTTP_CODE'] != 200){
                                $errorslog[] = $temp_row['AccountName'] . ':' . $Response['error'];
                            }   
                        } else {
                            Log::error($temp_row['AccountNo'] . ' skipped line number' . $lineno);

                        }
                    }
                } 
            }
            
            foreach ($results as $temp_row) {
                if($temp_row['IsPartner'] != 1 && $temp_row['IsReseller'] != 1){
                    $checkemptyrow = array_filter(array_values($temp_row));
                    if(!empty($checkemptyrow)){
                        $tempItemData = array();
                        $tempItemData['AccountDynamicField'] = array();
                    
                        if (isset($temp_row['AccountNo']) && !empty($temp_row['AccountNo'])) {
                            $tempItemData['AccountNo'] = $temp_row['AccountNo'];
                        } 
                        if (isset($temp_row['AccountName'])) {
                            $tempItemData['AccountName'] = trim($temp_row['AccountName']);
                        }
                        if (isset($temp_row['Phone'])) {
                            $tempItemData['Phone'] = $temp_row['Phone'];
                        }
                        if (isset($temp_row['BilllingAddress1'])) {
                            $tempItemData['BillingAddress1'] = $temp_row['BillingAddress1'];
                        }
                        if (isset($temp_row['BillingAddress2'])) {
                            $tempItemData['BillingAddress2'] = $temp_row['BillingAddress2'];
                        }
                        if (isset($temp_row['BillingAddress3'])) {
                            $tempItemData['BillingAddress3'] = $temp_row['BillingAddress3'];
                        }

                        if (isset($temp_row['BillingCity'])) {
                            $tempItemData['BillingCity'] = $temp_row['BillingCity'];
                        }

                        if (isset($temp_row['BilllingPostCode'])) {
                            $tempItemData['BilllingPostCode'] = $temp_row['BilllingPostCode'];
                        }


                        if (isset($temp_row['BillingEmail'])) {
                            $tempItemData['BillingEmail'] = $temp_row['BillingEmail'];
                        }
                        
                        if (isset($temp_row['BillingCountryIso'])) {
                            $tempItemData['CountryIso2'] = $temp_row['BillingCountryIso'];
                        }

                        if (isset($temp_row['IsVendor'])) {
                            $tempItemData['IsVendor'] = $temp_row['IsVendor'];
                        }

                        if (isset($temp_row['IsCustomer'])) {
                            $tempItemData['IsCustomer'] = $temp_row['IsCustomer'];
                        }
                        
                        if (isset($temp_row['IsPartner'])) {
                            $tempItemData['IsPartner'] = $temp_row['IsPartner'];
                        }

                        if (isset($temp_row['IsAffiliate'])) {
                            $tempItemData['IsAffiliate'] = $temp_row['IsAffiliate'];
                        }

                        if (isset($temp_row['Currency'])) {
                            $tempItemData['Currency'] = $temp_row['Currency'];
                        }
                        
                        if (isset($temp_row['VatNumber'])) {
                            $tempItemData['VatNumber'] = $temp_row['VatNumber'];
                        }

                        if (isset($temp_row['BillingType'])) {
                            $tempItemData['BillingTypeID'] = $temp_row['BillingType'];
                        }
                        
                        if (isset($temp_row['parentId'])) {
                            $tempItemData['PartnerID'] = $temp_row['parentId'];
                        }

                        if (isset($temp_row['LanguageIso'])) {
                            $tempItemData['LanguageIso2'] = $temp_row['LanguageIso'];
                        }

                        if (isset($temp_row['BillingStartDate'])) {
                            $tempItemData['BillingStartDate'] = "2019-12-01";
                        }

                        if (isset($temp_row['AutoTopup'])) {
                            $tempItemData['AutoTopup'] = $temp_row['AutoTopup'];
                        }
                        
                        if (isset($temp_row['MinThreshold'])) {
                            $tempItemData['MinThreshold'] = $temp_row['MinThreshold'];
                        }

                        if (isset($temp_row['TopupAmount'])) {
                            $tempItemData['TopupAmount'] = $temp_row['TopupAmount'];
                        }

                        if (isset($temp_row['AutoOutpayment'])) {
                            $tempItemData['AutoOutpayment'] = $temp_row['AutoOutpayment'];
                        }

                        if (isset($temp_row['OutPaymentThreshold'])) {
                            $tempItemData['OutPaymentThreshold'] = $temp_row['OutPaymentThreshold'];
                        }
                        
                        if (isset($temp_row['OutPaymentAmount'])) {
                            $tempItemData['OutPaymentAmount'] = $temp_row['OutPaymentAmount'];
                        }

                        if (isset($temp_row['CustomerId'])) {
                            array_push($tempItemData['AccountDynamicField'] ,  [
                                "Name" => "CustomerID",
                                "Value" => $temp_row['CustomerId']
                            ]);
                        }

                        // if (isset($temp_row['poNumber'])) {
                        //     array_push($tempItemData['AccountDynamicField'] , [
                        //         "Name" => "PONumber",
                        //         "Value" => $temp_row['poNumber']
                        //     ]);
                        // }

                        if (isset($temp_row['RegisterDutchFoundation'])) {
                            array_push($tempItemData['AccountDynamicField'] ,  [
                                "Name" => "RegisterDutchFoundation",
                                "Value" => $temp_row['RegisterDutchFoundation']
                            ]);
                        }
                        
                        if (isset($temp_row['CocNumber'])) {

                            array_push($tempItemData['AccountDynamicField'] ,  [
                                "Name" => "COCNumber",
                                "Value" => $temp_row['CocNumber']
                            ]);
                            
                        }

                        if (isset($temp_row['AutoPay'])) {
                            $tempItemData['AutoPay'] = $temp_row['AutoPay'];
                        }

                        if (isset($temp_row['Active'])) {
                            $tempItemData['Active'] = $temp_row['Active'];
                        }

                        if (isset($temp_row['PaymentMethod'])) {
                            $tempItemData['PaymentMethodID'] = $temp_row['PaymentMethod'];
                        }
                        
                        // if (isset($temp_row['OutpaymentMethod']) && !empty($temp_row['OutpaymentMethod']) && $temp_row['OutpaymentMethod'] == "NULL") {
                        //     $tempItemData['PayoutMethodID'] = $temp_row['OutpaymentMethod'];
                        // }

                        if (isset($temp_row['BankAccount'])) {
                            $tempItemData['BankAccount'] = $temp_row['BankAccount'];
                        }
                        if (isset($temp_row['BankAccount'])) {
                            $tempItemData['Title'] = trim($temp_row['AccountName']);
                        }

                        if (isset($temp_row['BIC'])) {
                            $tempItemData['BIC'] = $temp_row['BIC'];
                        }

                        if (isset($temp_row['AccountHolderName'])) {
                            $tempItemData['AccountHolderName'] = $temp_row['AccountHolderName'];
                        }
                        
                        if (isset($temp_row['OutpaymentMethodTitle'])) {
                            $tempItemData['PayoutTitle'] = $temp_row['OutpaymentMethodTitle'];
                        }

                        if (isset($temp_row['OutpaymentMethodBankAccount'])) {
                            $tempItemData['PayoutBankAccount'] = $temp_row['OutpaymentMethodBankAccount'];
                        }

                        if (isset($temp_row['OutpaymentMethodBIC'])) {
                            $tempItemData['PayoutBIC'] = $temp_row['OutpaymentMethodBIC'];
                        }
                        
                        if (isset($temp_row['OutpaymentMethodAccountHolderName'])) {
                            $tempItemData['PayoutAccountHolderName'] = $temp_row['OutpaymentMethodAccountHolderName'];
                        }

                        if (isset($temp_row['OutpaymentMethodMandateCode'])) {
                            $tempItemData['PayoutMandateCode'] = $temp_row['OutpaymentMethodMandateCode'];
                        }

                        if (isset($temp_row['CardToken'])) {
                            $tempItemData['CardToken'] = $temp_row['CardToken'];
                        }

                        if (isset($temp_row['CardHolderName'])) {
                            $tempItemData['CardHolderName'] = $temp_row['CardHolderName'];
                        }

                        if (isset($temp_row['ExpirationMonth'])) {
                            $tempItemData['ExpirationMonth'] = $temp_row['ExpirationMonth'];
                        }

                        if (isset($temp_row['ExpirationYear'])) {
                            $tempItemData['ExpirationYear'] = $temp_row['ExpirationYear'];
                        }
                        
                        if (isset($temp_row['LastDigit'])) {
                            $tempItemData['LastDigit'] = $temp_row['LastDigit'];
                        }

                        
                        if (isset($temp_row['AccountNo']) && !empty($temp_row['AccountName']) && isset($temp_row['CustomerId']) && !empty($temp_row['CustomerId']) && isset($temp_row['BillingType']) && !empty($temp_row['BillingType']) && isset($temp_row['BillingStartDate']) && !empty($temp_row['BillingStartDate'])) {
                            $PricingJSONInput = json_encode($tempItemData, true);
                            $Response = NeonAPI::callAPI($PricingJSONInput , '/api/createAccount' , $url ,'application/json');
                            Log::info($temp_row['AccountNo'] . print_r($Response,true));
                            if($Response['HTTP_CODE'] != 200){
                                $errorslog[] = $temp_row['AccountName'] . ':' . $Response['error'];
                            }   
                        } else {
                            Log::error($temp_row['AccountNo'] . ' skipped line number' . $lineno);

                        }
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
