<?php namespace App\Console\Commands;

use App\Lib\Account;
use App\Lib\AccountBilling;
use App\Lib\RecurringInvoice;
use App\Lib\RecurringInvoiceLog;
use App\Lib\Company;
use App\Lib\CompanySetting;
use App\Lib\CronHelper;
use App\Lib\Currency;
use App\Lib\DataTableSql;
use App\Lib\Helper;
use App\Lib\Invoice;
use App\Lib\InvoiceLog;
use App\Lib\InvoiceDetail;
use App\Lib\InvoiceTemplate;
use App\Lib\Notification;
use App\Lib\Product;
use App\Lib\TaxRate;
use App\Lib\User;
use Symfony\Component\Console\Input\InputArgument;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Lib\Job;

use Webpatser\Uuid\Uuid;

class BulkInvoiceSend extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'bulkinvoicesend';

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

        CronHelper::before_cronrun($this->name, $this );

        $arguments = $this->argument();
        $getmypid = getmypid(); // get proccess id added by abubakar
        $JobID = $arguments["JobID"];
        $job = Job::find($JobID);
        $ProcessID = Uuid::generate();
        Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar
        $jobdata = array();
        $errorslog = array();
        $CompanyID = $arguments["CompanyID"];
        Log::useFiles(storage_path().'/logs/bulkinvoicesend-'.$JobID.'-'.date('Y-m-d').'.log');

            $Company = Company::find($CompanyID);
            $InvoiceCopyEmail_main = Notification::getNotificationMail(['CompanyID'=>$CompanyID,'NotificationType'=>Notification::InvoiceCopy]);
            $InvoiceCopyEmail_main = empty($InvoiceCopyEmail_main)?$Company->Email:$InvoiceCopyEmail_main;
            $dberrormsg = '';

            if(!empty($job)){
                $JobLoggedUser = User::find($job->JobLoggedUserID);
                $joboptions = json_decode($job->Options);
                $email_sending_failed = array();
                $pdf_generation_error = [];
                if(isset($joboptions->RecurringInvoice)){
                    $where=['AccountID'=>'','Status'=>'2','selectedIDs'=>''];
                    if(isset($joboptions->criteria) && !empty($joboptions->criteria)){
                        $criteria= json_decode($joboptions->criteria,true);
                        if(!empty($criteria['AccountID'])){
                            $where['AccountID']= $criteria['AccountID'];
                        }
                        $where['Status'] = $criteria['Status']==''?2:$criteria['Status'];
                    }else{
                        $where['selectedIDs']= $joboptions->selectedIDs;
                    }
                    $UserFullName = $JobLoggedUser->FirstName.' '. $JobLoggedUser->LastName;
                    $sql = "call prc_CreateInvoiceFromRecurringInvoice (".$CompanyID.",".intval($where['AccountID']).",".$where['Status'].",'".trim($where['selectedIDs'])."','".$UserFullName."',".RecurringInvoiceLog::GENERATE.",'".$ProcessID."')";
                    $result = DB::connection('sqlsrv2')->select($sql);
                    if(!empty($result[0]->message)){
                        $dberrormsg = $result[0]->message;
                        Log::info($dberrormsg);
                    }
                    $InvoiceIDs = Invoice::where(['ProcessID' => $ProcessID])->select(['InvoiceID'])->lists('InvoiceID');
                }else {
                    $InvoiceIDs = array_filter(explode(',', $joboptions->InvoiceIDs), 'intval');
                }

                if(count($InvoiceIDs)>0) {
                    $Products = Product::getAllProductName();
                    $Taxes = TaxRate::getAllTaxName();
                    $data['Products'] = $Products;
                    $data['Taxes'] = $Taxes;
                    foreach ($InvoiceIDs as $InvoiceID) {
                        $isPdfgenerated = 1;
                        $InvoiceCopyEmail = $InvoiceCopyEmail_main;
                        $Invoice = Invoice::find($InvoiceID);
                        if(isset($joboptions->RecurringInvoice)){
                            $recurringInvoice = RecurringInvoice::find($Invoice->RecurringInvoiceID);
                            $RecurringInvoiceData['NextInvoiceDate'] = next_billing_date($recurringInvoice->BillingCycleType, $recurringInvoice->BillingCycleValue , strtotime($recurringInvoice->NextInvoiceDate));
                            $RecurringInvoiceData['LastInvoicedDate'] = Date("Y-m-d H:i:s");
                            $recurringInvoice->update($RecurringInvoiceData);
                            $pdf_path = Invoice::generate_pdf($Invoice->InvoiceID,$data);
                            if(empty($pdf_path)){
                                $isPdfgenerated = 0;
                                $pdf_generation_error[] = Invoice::$InvoiceGenrationErrorReasons["PDF"].' against invoice ID'.$Invoice->InvoiceID;
                            }else{
                                $Invoice->update(["PDF" => $pdf_path]);

                            }
                        }

                        if($isPdfgenerated==1) {
                            $Account = Account::find($Invoice->AccountID);
                            $Currency = Currency::find($Account->CurrencyId);
                            $CurrencyCode = !empty($Currency) ? $Currency->Code : '';
                            $_InvoiceNumber = $Invoice->FullInvoiceNumber;

                            $emaildata['data'] = array(
                                'InvoiceNumber' => $_InvoiceNumber,
                                'CompanyName' => $Company->CompanyName,
                                'InvoiceGrandTotal' => $Invoice->GrandTotal,
                                'CurrencyCode' => $CurrencyCode,
                                'InvoiceLink' => getenv("WEBURL") . '/invoice/' . $Invoice->InvoiceID . '/invoice_preview'
                            );
                            $emaildata['EmailToName'] = $Company->CompanyName;
                            $emaildata['Subject'] = 'New invoice ' . $_InvoiceNumber . ' from ' . $Company->CompanyName . ' to (' . $Account->AccountName . ')';
                            $emaildata['CompanyID'] = $CompanyID;
                            //Log::info($InvoiceGenerationEmail);
                            if (!empty($Account->Owner)) {
                                $AccountManager = User::find($Account->Owner);
                                if (is_array($InvoiceCopyEmail)) {
                                    $InvoiceCopyEmail = implode(',', $InvoiceCopyEmail);
                                }
                                $InvoiceCopyEmail .= ',' . $AccountManager->EmailAddress;
                            }
                            $InvoiceCopyEmail = explode(",", $InvoiceCopyEmail);
                            Log::info($InvoiceCopyEmail);

                            foreach ($InvoiceCopyEmail as $singleemail) {
                                $singleemail = trim($singleemail);
                                if (filter_var($singleemail, FILTER_VALIDATE_EMAIL)) {
                                    $emaildata['EmailTo'] = 'abubakar@code-desk.com';//$singleemail;
                                    $status = Helper::sendMail('emails.invoices.bulk_invoice_email', $emaildata);
                                }
                            }
                            if (getenv('EmailToCustomer') == 1) {
                                $CustomerEmail = $Account->BillingEmail;
                            } else {
                                $CustomerEmail = Company::getEmail($CompanyID);;
                            }
                            $CustomerEmail = explode(",", $CustomerEmail);
                            $customeremail_status['status'] = 0;
                            $customeremail_status['message'] = '';
                            $customeremail_status['body'] = '';
                            Log::info($CustomerEmail);
                            foreach ($CustomerEmail as $singleemail) {
                                $singleemail = trim($singleemail);
                                if (filter_var($singleemail, FILTER_VALIDATE_EMAIL)) {
                                    $emaildata['EmailTo'] = 'abubakar@code-desk.com';$singleemail;
                                    $emaildata['data']['InvoiceLink'] = getenv("WEBURL") . '/invoice/' . $Invoice->AccountID . '-' . $Invoice->InvoiceID . '/cview?email=' . $singleemail;
                                    $customeremail_status = Helper::sendMail('emails.invoices.bulk_invoice_email', $emaildata);
                                }
                            }
                            Log::info($customeremail_status);
                            //$status = Helper::sendMail('emails.invoices.bulk_invoice_email', $emaildata);
                            if ($customeremail_status['status'] == 0) {
                                $email_sending_failed[] = $Account->AccountName;
                                $status['status'] = 'failure';
                            } else {
                                $status['status'] = "success";
                                if ($Invoice->InvoiceStatus != Invoice::PAID && $Invoice->InvoiceStatus != Invoice::PARTIALLY_PAID && $Invoice->InvoiceStatus != Invoice::CANCEL) {
                                    $Invoice->update(['InvoiceStatus' => Invoice::SEND]);

                                    if(isset($joboptions->RecurringInvoice)){
                                        $RecurringInvoiceLogData = array();
                                        $RecurringInvoiceLogData['RecurringInvoiceID']= $Invoice->RecurringInvoiceID;
                                        $RecurringInvoiceLogData['Note']= 'Invoice Sent By '.$UserFullName;
                                        $RecurringInvoiceLogData['created_at']= date("Y-m-d H:i:s");
                                        $RecurringInvoiceLogData['RecurringInvoiceLogStatus']= RecurringInvoiceLog::SENT;
                                        RecurringInvoiceLog::insert($RecurringInvoiceLogData);
                                    }

                                }
                                /**
                                 * Insert Data in InvoiceLog
                                 */
                                $invoiceloddata = array();
                                $invoiceloddata['InvoiceID'] = $InvoiceID;
                                $invoiceloddata['Note'] = InvoiceLog::$log_status[InvoiceLog::SENT] . ' By RMScheduler';
                                $invoiceloddata['created_at'] = date("Y-m-d H:i:s");
                                $invoiceloddata['InvoiceLogStatus'] = InvoiceLog::SENT;
                                InvoiceLog::insert($invoiceloddata);
                                /** log emails against account */
                                $statuslog = Helper::account_email_log($CompanyID, $Account->AccountID, $emaildata, $customeremail_status, $JobLoggedUser, $ProcessID, $JobID);
                                if ($statuslog['status'] == 0) {
                                    $errorslog[] = $Account->AccountName . ' email log exception:' . $statuslog['message'];
                                }
                            }
                        }
                    }
                }else{
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                    $jobdata['JobStatusMessage'] = 'No Data Found';
                }

                Log::info($email_sending_failed);
                Log::info($pdf_generation_error);

                    $jobdata['JobStatusMessage'] = $dberrormsg;
                if((count($email_sending_failed) > 0) || (count($pdf_generation_error)>0) || !empty($dberrormsg)){
                    $jobdata['JobStatusMessage'] =( count($email_sending_failed)>0?' \n\r Email Sending Failed: '.implode(',\n\r',$email_sending_failed):'').( count($pdf_generation_error)>0?' \n\r Pdf generation failed: '.implode(',\n\r',$pdf_generation_error):'').$dberrormsg;
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','PF')->pluck('JobStatusID');
                }else{
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','S')->pluck('JobStatusID');
                    $jobdata['JobStatusMessage'] = 'Bulk Invoice Sent Successfully';
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
            Job::send_job_status_email($job,$CompanyID);
        try {
        } catch (\Exception $e) {
            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','F')->pluck('JobStatusID');
            $jobdata['JobStatusMessage'] = 'Exception: '.$e->getMessage();
            $jobdata['updated_at'] = date('Y-m-d H:i:s');
            $jobdata['ModifiedBy'] = 'RMScheduler';
            Job::where(["JobID" => $JobID])->update($jobdata);
            Log::error($e);
        }


        CronHelper::after_cronrun($this->name, $this);

    }



}