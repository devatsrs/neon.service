<?php namespace App\Console\Commands;

use App\Lib\Account;
use App\Lib\Company;
use App\Lib\CompanySetting;
use App\Lib\Currency;
use App\Lib\DataTableSql;
use App\Lib\Helper;
use App\Lib\Invoice;
use App\Lib\InvoiceDetail;
use App\Lib\InvoiceTemplate;
use App\Lib\Product;
use App\Lib\TaxRate;
use App\Lib\User;
use Symfony\Component\Console\Input\InputArgument;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Lib\Job;

use Webpatser\Uuid\Uuid;

class BulkInvoiceGenerator extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'bulkinvoicegenerator';

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
            ['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID'],
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
        $arguments = $this->argument();
        $getmypid = getmypid(); // get proccess id added by abubakar
        $JobID = $arguments["JobID"];
        $job = Job::find($JobID);
        $ProcessID = Uuid::generate();
        Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar
        $decimal_places= 2;
        $CompanyID = $arguments["CompanyID"];
        Log::useFiles(storage_path().'/logs/bulkinvoicegenerator-'.$JobID.'-'.date('Y-m-d').'.log');
        DB::beginTransaction();
        DB::connection('sqlsrv2')->beginTransaction();
        $errorslog = array();
        try {
            $Company = Company::find($CompanyID);
            $UserEmail='';
            $InvoiceGenerationEmail = CompanySetting::getKeyVal($CompanyID,'InvoiceGenerationEmail');
            $InvoiceGenerationEmail = ($InvoiceGenerationEmail =='Invalid Key')?$Company->Email:$InvoiceGenerationEmail;
            if(isset($job->JobLoggedUserID) && $job->JobLoggedUserID > 0){
                $User = User::getUserInfo($job->JobLoggedUserID);
                //$UserEmail= $User->EmailAddress;
              //  $InvoiceGenerationEmail .= ',' . $UserEmail;
            }
            $InvoiceGenerationEmail = explode(",",$InvoiceGenerationEmail);
            if(!empty($job)){
                $joboptions = json_decode($job->Options);
                if(isset($joboptions->StartDate) && isset($joboptions->EndDate) && isset($joboptions->AccountID) && is_array($joboptions->AccountID)){
                    $account_skipped = array();
                    $email_sending_failed = array();
                    $invoice_usage_file_failed = array();
                    foreach($joboptions->AccountID as $key  => $AccountID) {
                        $query = "CALL prc_getAccountInvoiceTotal( " . (int)$AccountID . ",$CompanyID,'$joboptions->StartDate','$joboptions->EndDate',1)";
                        $result = DataTableSql::of($query, 'sqlsrv2')->getProcResult(array('TotalCharges'));
                        $Account = Account::find((int)$AccountID);
                        if(!empty($Account)) {
                            $InvoiceTemplate = InvoiceTemplate::find($Account->InvoiceTemplateID);
                            if (isset($result['data']['TotalCharges']) && isset($result['data']['TotalCharges'][0]->TotalCharges) && $result['data']['TotalCharges'][0]->TotalCharges > 0 && !empty($Account) && isset($InvoiceTemplate->InvoiceTemplateID) && $InvoiceTemplate->InvoiceTemplateID > 0) {

                                $Address = "";
                                $Address .= !empty($Account->Address1) ? $Account->Address1 . ',' . PHP_EOL : '';
                                $Address .= !empty($Account->Address2) ? $Account->Address2 . ',' . PHP_EOL : '';
                                $Address .= !empty($Account->Address3) ? $Account->Address3 . ',' . PHP_EOL : '';
                                $Address .= !empty($Account->City) ? $Account->City . ',' . PHP_EOL : '';
                                $Address .= !empty($Account->Country) ? $Account->Country : '';
                                $TotalCharges = $result['data']['TotalCharges'][0]->TotalCharges;
                                $RoundChargesAmount = ($Account->RoundChargesAmount > 0) ? $Account->RoundChargesAmount : $decimal_places;
                                $decimal_places = $RoundChargesAmount;
                                $SubTotal = number_format($TotalCharges, $decimal_places, '.', '');

                                $TaxRateId = $Account->TaxRateId;
                                /*$TaxRate = TaxRate::find($TaxRateId);
                                $TaxRateAmount = 0;
                                if (isset($TaxRate->Amount))
                                    $TaxRateAmount = $TaxRate->Amount;

                                $TotalTax = number_format((($TotalCharges * $TaxRateAmount) / 100), $RoundChargesAmount, '.', '');
                                */
                                $InvoiceData = array();
                                $InvoiceData["CompanyID"] = $CompanyID;
                                $InvoiceData["AccountID"] = $AccountID;
                                $InvoiceData["Address"] = $Address;
                                $InvoiceData["InvoiceNumber"] = $InvoiceNumber = InvoiceTemplate::getNextInvoiceNumber($InvoiceTemplate->InvoiceTemplateID, $CompanyID);
                                $InvoiceData["IssueDate"] = date('Y-m-d');
                                //$InvoiceData["PONumber"] = $data["PONumber"];
                                $InvoiceData["SubTotal"] = $SubTotal;
                                $InvoiceData["TotalDiscount"] = 0;
                                $InvoiceData["TotalTax"] =  0 ; //$TotalTax;
                                $InvoiceData["GrandTotal"] = $InvoiceGrandTotal = $SubTotal ; //($SubTotal + $TotalTax);
                                $InvoiceData["CurrencyID"] = $Account->CurrencyId;
                                //$InvoiceData["TaxRateID"] = $Account->TaxRateId;
                                $InvoiceData["Note"] = "Bulk Generated on " . date("d-m-Y"); //$data["Note"];
                                $InvoiceData["Terms"] = $InvoiceTemplate->Terms; //$data["Terms"];
                                $InvoiceData["CreatedBy"] = 'RMScheduler';
                                $InvoiceData["InvoiceType"] = Invoice::INVOICE_OUT;
                                $InvoiceData["InvoiceStatus"] = Invoice::AWAITING;
                                $Invoice = Invoice::create($InvoiceData);
                                //Store Last Invoice Number.
                                //InvoiceTemplate::find(Account::find($AccountID)->InvoiceTemplateID)->update(array("LastInvoiceNumber"=>$InvoiceData["InvoiceNumber"]));

                                $ProductDescription = " From " . date("d-m-Y", strtotime($joboptions->StartDate)) . " To " . date("d-m-Y", strtotime($joboptions->EndDate));
                                $InvoiceDetailData = array();
                                $InvoiceDetailData["InvoiceID"] = $Invoice->InvoiceID;
                                $InvoiceDetailData['ProductID'] = 0;
                                $InvoiceDetailData['Description'] = $ProductDescription;
                                $InvoiceDetailData['StartDate'] = $joboptions->StartDate;
                                $InvoiceDetailData['EndDate'] = $joboptions->EndDate;
                                $InvoiceDetailData['Price'] = $SubTotal;
                                $InvoiceDetailData['Qty'] = 1;
                                $InvoiceDetailData['Discount'] = 0;
                                $InvoiceDetailData['TaxAmount'] = 0 ; //$TotalTax;
                                $InvoiceDetailData['LineTotal'] = $SubTotal ; //($SubTotal + $TotalTax);
                                $InvoiceDetailData["created_at"] = date("Y-m-d H:i:s");
                                $InvoiceDetailData["CreatedBy"] = 'RMScheduler';
                                InvoiceDetail::insert($InvoiceDetailData);

                                /** Generate Usage File **/
                                $InvoiceID = $Invoice->InvoiceID;
                                if($InvoiceID > 0 && $AccountID  > 0 ) {
                                    $fullPath = Invoice::generate_usage_file($InvoiceID);
                                    if(!empty($fullPath)){

                                    }else{
                                        $invoice_usage_file_failed[] = $Account->AccountName . ' Reason:: Usage File Generation Failed';
                                    }
                                }

                                $Currency = Currency::find($Account->CurrencyId);
                                $CurrencyCode = !empty($Currency)?$Currency->Code:'';
                                $_InvoiceNumber = $InvoiceTemplate->InvoiceNumberPrefix . $InvoiceNumber;
                                $emaildata['data'] = array(
                                    'InvoiceNumber' => $_InvoiceNumber,
                                    'CompanyName' => $Company->CompanyName,
                                    'InvoiceGrandTotal' => $InvoiceGrandTotal,
                                    'CurrencyCode' => $CurrencyCode,
                                    'InvoiceLink' => getenv("WEBURL").'/invoice/' . $Invoice->InvoiceID . '/invoice_preview'
                                );
                                $emaildata['EmailToName'] = $Company->CompanyName;
                                $emaildata['Subject'] = 'New invoice ' . $_InvoiceNumber . ' from ' . $Company->CompanyName;
                                $emaildata['CompanyID'] = $CompanyID;
                                foreach($InvoiceGenerationEmail as $singleemail) {
                                    if (filter_var($singleemail, FILTER_VALIDATE_EMAIL)) {
                                        $emaildata['EmailTo'] = $singleemail;
                                        $status = Helper::sendMail('emails.invoices.bulk_invoice_email', $emaildata);
                                    }
                                }
                                if($joboptions->GenerateSend == 1) {
                                    //$CustomerEmail = $Account->BillingEmail;
                                    $CustomerEmail = Company::getEmail($CompanyID); //explode(",", $CustomerEmail);
                                    $emaildata['data']['InvoiceLink'] =  getenv("WEBURL") . '/invoice/'.$AccountID.'-'.$Invoice->InvoiceID.'/cview';
                                    $emaildata['EmailTo'] = $CustomerEmail; //'girish.vadher@code-desk.com'; //$Company->InvoiceGenerationEmail; //$Account->BillingEmail;
                                    $status = Helper::sendMail('emails.invoices.bulk_invoice_email', $emaildata);
                                    if ($status['status'] == 0) {
                                        $email_sending_failed[] = $Account->AccountName;
                                        $status['status'] = 'failure';
                                    } else {
                                        $status['status'] = "success";
                                        $Invoice->update(['InvoiceStatus' => Invoice::SEND]);
                                        $logData = ['AccountID'=>$Account->AccountID,
                                            'ProcessID'=>$ProcessID,
                                            'JobID'=>$JobID,
                                            'User'=>$User,
                                            'EmailFrom'=>$User->EmailAddress,
                                            'EmailTo'=>$emaildata['EmailTo'],
                                            'Subject'=>$emaildata['Subject'],
                                            'Message'=>$status['body']];
                                        $statuslog = Helper::email_log($logData);
                                        if($statuslog['status']==0) {
                                            $errorslog[] = $Account->AccountName . ' email log exception:' . $statuslog['message'];
                                        }
                                    }
                                }
                            }elseif (empty($InvoiceTemplate->InvoiceTemplateID)) {
                                $account_skipped[] = $Account->AccountName . ' Reason::No Invoice Template assigned';
                            }elseif (isset($result['data']['TotalCharges']) && isset($result['data']['TotalCharges'][0]->TotalCharges) && $result['data']['TotalCharges'][0]->TotalCharges == 0) {
                                $account_skipped[] = $Account->AccountName . ' Reason::Invoice already generated or CDR is missing';
                            }else {
                                $account_skipped[] = $Account->AccountName . ' Reason::No Gateway set up';
                            }

                        }
                    }
                    if(count($account_skipped)){
                        $jobdata['JobStatusMessage'] = 'Skipped account: '.implode(',\n\r',$account_skipped) .( count($email_sending_failed)>0?' \n\r \n\r Email Sending Failed: '.implode(',\n\r',$email_sending_failed):'');
                        $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','PF')->pluck('JobStatusID');
                    }else{
                        $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','S')->pluck('JobStatusID');
                        $jobdata['JobStatusMessage'] = 'Bulk Invoice Generated Successfully';
                    }
                    if(count($invoice_usage_file_failed)){
                        $jobdata['JobStatusMessage'] .= ' \n\r \n\r Invoice Created But Invoice Usage File Creation Failed: '.implode(',\n\r',$invoice_usage_file_failed) .( count($invoice_usage_file_failed)>0?' \n\r \n\r Email Sending Failed: '.implode(',\n\r',$email_sending_failed):'');
                        $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','PF')->pluck('JobStatusID');
                    }
                }else{
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                    $jobdata['JobStatusMessage'] = 'No Data Found';
                }
            }else{
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                $jobdata['JobStatusMessage'] = 'No Data Found';
            }

            if(count($errorslog)>0){
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','PF')->pluck('JobStatusID');
                $jobdata['JobStatusMessage'] .= count($errorslog).' Email log errors: '.implode(',\n\r',$errorslog);
            }
            $jobdata['updated_at'] = date('Y-m-d H:i:s');
            $jobdata['ModifiedBy'] = 'RMScheduler';
            Job::where(["JobID" => $JobID])->update($jobdata);
            DB::commit();
            DB::connection('sqlsrv2')->commit();

            //Email Status to InvoiceGenerationEmail
            $this->send_job_status_email($job,$CompanyID);

        } catch (\Exception $e) {
            DB::rollback();
            DB::connection('sqlsrv2')->rollback();
            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','F')->pluck('JobStatusID');
            $jobdata['JobStatusMessage'] = 'Exception: '.$e->getMessage();
            $jobdata['updated_at'] = date('Y-m-d H:i:s');
            $jobdata['ModifiedBy'] = 'RMScheduler';
            Job::where(["JobID" => $JobID])->update($jobdata);
            Log::error($e);

            $this->send_job_status_email($job,$CompanyID);

        }


    }

    public function send_job_status_email($job,$CompanyID){

        /** Send Job Failed Email **/
        $query = "CALL prc_WSGetJobDetails(" . $job->JobID .")";
        $result = DataTableSql::of($query)->getProcResult(array('JobData'));
        $CompanyName = Company::where("CompanyID",$CompanyID)->pluck("CompanyName");

        $User = User::getUserInfo($job->JobLoggedUserID);
        $UserEmail= $User->EmailAddress;

        if($UserEmail != '') {
            $status = Helper::sendMail('emails.invoices.bulk_invoice_email_status',
                array(
                    'EmailTo' => $UserEmail,
                    'EmailToName' => $CompanyName,
                    'Subject' => $result['data']['JobData'][0]->JobTitle,
                    'CompanyID' => $CompanyID,
                    'data' => array("job_data" => $result, 'CompanyName' => $CompanyName)
                ));
            Job::find($job->JobID)->update(array('EmailSentStatus'=>$status['status'],'EmailSentStatusMessage'=>$status['message']));
        }
    }


}