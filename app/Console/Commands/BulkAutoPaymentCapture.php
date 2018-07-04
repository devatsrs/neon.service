<?php namespace App\Console\Commands;

use App\Lib\Account;
use App\Lib\EmailsTemplates;
use App\Lib\AccountBilling;
use App\Lib\AccountPaymentProfile;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\Currency;
use App\Lib\Invoice;
use App\Lib\Job;
use App\Lib\JobStatus;
use App\Lib\JobType;
use App\Lib\Payment;
use App\Lib\PaymentGateway;
use App\Lib\TransactionLog;
use App\Lib\User;
use App\Lib\Notification;
use App\Lib\CompanyConfiguration;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;
use App\Lib\Helper;
use App\Lib\Company;
use \Exception;

class BulkAutoPaymentCapture extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'bulkautopaymentcapture';

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
            ['CronJobID', InputArgument::REQUIRED, 'Argument CronJobID'],
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
        $getmypid = getmypid(); // get proccess id
        $CompanyID = $arguments["CompanyID"];
        $CronJobID = $arguments["CronJobID"];

        $CronJob =  CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);

        $dataactive['Active'] = 1;
        $dataactive['PID'] = $getmypid;
        $dataactive['LastRunTime'] = date('Y-m-d H:i:00');
        $CronJob->update($dataactive);
        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';
        $errors = array();
        Log::useFiles(storage_path() . '/logs/bulkautopaymentcapture-' . date('Y-m-d') . '.log');
        /**  Loop through account Outstanding.*/

        $Accounts =   AccountBilling::join('tblAccount','tblAccount.AccountID','=','tblAccountBilling.AccountID')
            ->select('tblAccountBilling.AccountID','tblAccountBilling.AutoPaymentSetting','tblAccountBilling.AutoPayMethod','tblAccount.*')
            ->where(array('CompanyID'=>$CompanyID,'Status'=>1,'Billing'=>1,"AccountType"=>1))
            ->whereNotNull('AutoPaymentSetting')
            ->where('AutoPaymentSetting','<>','never')
            ->where('AutoPayMethod','<>','0')
            ->get();

        /**  Create a Job */
        $UserID = User::where("CompanyID", $CompanyID)->where(["AdminUser"=>1,"Status"=>1])->min("UserID");
        $CreatedBy = User::get_user_full_name($UserID);
        $jobType = JobType::where(["Code" => 'BPC'])->get(["JobTypeID", "Title"]);
        $jobStatus = JobStatus::where(["Code" => "I"])->get(["JobStatusID"]);
        $jobdata["CompanyID"] = $CompanyID;
        $jobdata["JobTypeID"] = isset($jobType[0]->JobTypeID) ? $jobType[0]->JobTypeID : '';
        $jobdata["JobStatusID"] = isset($jobStatus[0]->JobStatusID) ? $jobStatus[0]->JobStatusID : '';
        $jobdata["JobLoggedUserID"] = $UserID;
        $jobdata["Title"] = "[Auto] " . (isset($jobType[0]->Title) ? $jobType[0]->Title : '');
        $jobdata["Description"] = isset($jobType[0]->Title) ? $jobType[0]->Title : '';
        $jobdata["CreatedBy"] = "System";
        $jobdata["created_at"] = date('Y-m-d H:i:s');
        $jobdata["updated_at"] = date('Y-m-d H:i:s');
        $JobID = Job::insertGetId($jobdata);
        $EMAIL_TO_CUSTOMER = CompanyConfiguration::get($CompanyID,'EMAIL_TO_CUSTOMER');
        $Company=Company::find($CompanyID);
        /** ************************************************************/
        try {
            CronJob::createLog($CronJobID);
            if(!empty($Accounts) && count($Accounts)>0) {
                foreach ($Accounts as $account) {
                    $AccountID=$account->AccountID;
                    $AccountBalanceGateway=0;
                    $AutoPayMethod = $account->AutoPayMethod;
                    if($AutoPayMethod==AccountBilling::ACCOUNT_BALANCE){
                        $AccountBalanceGateway=1;
                    }
                    $AutoPaymentSetting=$account->AutoPaymentSetting;
                    $PaymentMethod=$account->PaymentMethod;
                    if($AccountBalanceGateway==1){
                        $PaymentMethod='AccountBalance';
                    }
                    log::info('PaymentMethod - '.count($PaymentMethod));

                    $PaymentDueInDays=1;
                    /**
                     * if auto payment setting is invoice day, $PaymentDueInDays=0
                     * if auto payment setting is due date, $PaymentDueInDays=1
                     */
                    if($AutoPaymentSetting=='invoiceday'){
                        $PaymentDueInDays=0;
                    }
                    /**  Get All UnPaid  Invoice */
                    $AutoPay = 1;
                    Log::error("CALL  prc_getPaymentPendingInvoice ('" . $CompanyID . "', '" . $AccountID . "', '".$PaymentDueInDays."', '".$AutoPay."' ) ");

                    $unPaidInvoices = DB::connection('sqlsrv2')->select('CALL prc_getPaymentPendingInvoice( ' . $CompanyID . ',' . $AccountID .',' . $PaymentDueInDays .',' . $AutoPay .")");

                    log::info('PaymentPendingInvoice Count - '.count($unPaidInvoices));

                    if(!empty($unPaidInvoices)) {

                        if (!empty($PaymentMethod)) {
                            if($PaymentMethod=='AccountBalance'){
                                $PaymentGatewayID = 1;
                            }else{
                                $PaymentGatewayID = PaymentGateway::getPaymentGatewayIDByName($PaymentMethod);
                            }

                            if (!empty($PaymentGatewayID)) {
                                $VerifyStatus = 1;
                                if($PaymentMethod=='AccountBalance') {
                                    $CustomerProfile=1;
                                }else{
                                    $CustomerProfile = AccountPaymentProfile::getActiveProfile($AccountID, $PaymentGatewayID);
                                    if (!empty($CustomerProfile) && $PaymentMethod == 'StripeACH') {
                                        $StripeObj = json_decode($CustomerProfile->Options);
                                        if (empty($StripeObj->VerifyStatus) || $StripeObj->VerifyStatus !== 'verified') {
                                            $VerifyStatus = 0;
                                        }
                                    }
                                }
                                if (!empty($CustomerProfile) && $VerifyStatus=='1') {
                                    $PaymentGateway = $PaymentMethod;
                                    if($PaymentMethod=='AccountBalance') {
                                        $AccountPaymentProfileID=0;
                                        $options = (object) array();
                                    }else {
                                        $AccountPaymentProfileID = $CustomerProfile->AccountPaymentProfileID;
                                        $options = json_decode($CustomerProfile->Options);
                                    }

                                    $outstanginamount = 0;
                                    $fullnumber = '';
                                    foreach ($unPaidInvoices as $Invoiceid) {
                                        $outstanginamount += $Invoiceid->RemaingAmount;
                                        $AllInvoice = Invoice::find($Invoiceid->InvoiceID);
                                        $fullnumber .= $AllInvoice->FullInvoiceNumber . ',';
                                    }
                                    if ($fullnumber != '') {
                                        $fullnumber = rtrim($fullnumber, ',');
                                    }
                                    $outstanginamount = number_format($outstanginamount, 2, '.', '');
                                    $options->InvoiceNumber = $fullnumber;

                                    Log::info("Outstanding Amount " . $outstanginamount);
                                    Log::info("Invoice Full Number " . $fullnumber);

                                    /**  Start Transaction */
                                    Log::info("Transaction start");
                                    try {
                                        $transactionResponse = PaymentGateway::addTransaction($PaymentGateway, $outstanginamount, $options, $account, $AccountPaymentProfileID, $CompanyID);

                                    Log::info("Transaction end");
                                    if (isset($transactionResponse['response_code']) && $transactionResponse['response_code'] == 1) {
                                        foreach ($unPaidInvoices as $Invoiceid) {
                                            /**  Update Invoice as Paid */
                                            $Invoice = Invoice::find($Invoiceid->InvoiceID);
                                            $paymentdata = array();
                                            $paymentdata['CompanyID'] = $Invoice->CompanyID;
                                            $paymentdata['AccountID'] = $Invoice->AccountID;
                                            $paymentdata['InvoiceNo'] = $Invoice->FullInvoiceNumber;
                                            $paymentdata['InvoiceID'] = (int)$Invoice->InvoiceID;
                                            $paymentdata['PaymentDate'] = date('Y-m-d');
                                            $paymentdata['PaymentMethod'] = $transactionResponse['transaction_payment_method'];
                                            $paymentdata['CurrencyID'] = $account->CurrencyId;
                                            $paymentdata['PaymentType'] = 'Payment In';
                                            $paymentdata['Notes'] = $transactionResponse['transaction_notes'];
                                            $paymentdata['Amount'] = floatval($Invoiceid->RemaingAmount);
                                            $paymentdata['Status'] = 'Approved';
                                            $paymentdata['created_at'] = date('Y-m-d H:i:s');
                                            $paymentdata['updated_at'] = date('Y-m-d H:i:s');
                                            $paymentdata['CreatedBy'] = $CreatedBy;
                                            $paymentdata['ModifyBy'] = $CreatedBy;
                                            if($PaymentMethod!='AccountBalance') {
                                                Payment::insert($paymentdata);
                                            }
                                            $transactiondata = array();
                                            $transactiondata['CompanyID'] = $account->CompanyId;
                                            $transactiondata['AccountID'] = $account->AccountID;
                                            $transactiondata['InvoiceID'] = $Invoice->InvoiceID;
                                            $transactiondata['Transaction'] = $transactionResponse['transaction_id'];
                                            $transactiondata['Notes'] = $transactionResponse['transaction_notes'];
                                            $transactiondata['Amount'] = floatval($Invoiceid->RemaingAmount);
                                            $transactiondata['Status'] = TransactionLog::SUCCESS;
                                            $transactiondata['created_at'] = date('Y-m-d H:i:s');
                                            $transactiondata['updated_at'] = date('Y-m-d H:i:s');
                                            $transactiondata['CreatedBy'] = 'RMScheduler';
                                            $transactiondata['ModifyBy'] = 'RMScheduler';
                                            TransactionLog::insert($transactiondata);
                                            $Invoice->update(array('InvoiceStatus' => Invoice::PAID));

                                            $Emaildata = array();
                                            $CustomerEmail = '';
                                            if ($EMAIL_TO_CUSTOMER == 1) {
                                                $CustomerEmail = $account->BillingEmail;
                                            }
                                            $Emaildata['Subject'] = $fullnumber . ' Invoice Payment';
                                            $Emaildata['CompanyID'] = $CompanyID;
                                            $Emaildata['CompanyName'] = $Company->CompanyName;
                                            $Emaildata['AccountName'] = $account->AccountName;
                                            $Emaildata['Amount'] = floatval($Invoiceid->RemaingAmount);
                                            $Emaildata['Status'] = 'Success';
                                            $Emaildata['PaymentMethod'] = $PaymentMethod;
                                            $Emaildata['Currency'] = Currency::getCurrencyCode($account->CurrencyId);
                                            $Emaildata['Notes'] = $transactionResponse['transaction_notes'];

                                            $CustomerEmail = explode(",", $CustomerEmail);
                                            $EmailTemplateStatus = EmailsTemplates::CheckEmailTemplateStatus(Payment::AUTOINVOICETEMPLATE, $CompanyID);
                                            if (!empty($CustomerEmail) && !empty($EmailTemplateStatus)) {
                                                $staticdata = array();
                                                $staticdata['PaidAmount'] = floatval($Invoiceid->RemaingAmount);
                                                $staticdata['PaidStatus'] = 'Success';
                                                $staticdata['PaymentMethod'] = $PaymentMethod;
                                                $staticdata['PaymentNotes'] = $transactionResponse['transaction_notes'];

                                                foreach ($CustomerEmail as $singleemail) {
                                                    $singleemail = trim($singleemail);
                                                    if (filter_var($singleemail, FILTER_VALIDATE_EMAIL)) {
                                                        $Emaildata['EmailTo'] = $singleemail;
                                                        $WEBURL = CompanyConfiguration::getValueConfigurationByKey($CompanyID, 'WEB_URL');
                                                        $Emaildata['data']['InvoiceLink'] = $WEBURL . '/invoice/' . $AccountID . '-' . $Invoice->InvoiceID . '/cview?email=' . $singleemail;
                                                        $body = EmailsTemplates::SendAutoPayment($Invoice->InvoiceID, 'body', $CompanyID, $singleemail, $staticdata);
                                                        $Emaildata['Subject'] = EmailsTemplates::SendAutoPayment($Invoice->InvoiceID, "subject", $CompanyID, $singleemail, $staticdata);
                                                        if (!isset($Emaildata['EmailFrom'])) {
                                                            $Emaildata['EmailFrom'] = EmailsTemplates::GetEmailTemplateFrom(Payment::AUTOINVOICETEMPLATE, $CompanyID);
                                                        }
                                                        $customeremail_status = Helper::sendMail($body, $Emaildata, 0);
                                                        if (!empty($customeremail_status['status'])) {
                                                            $JobLoggedUser = User::find($UserID);
                                                            $statuslog = Helper::account_email_log($CompanyID, $AccountID, $Emaildata, $customeremail_status, $JobLoggedUser, '', $JobID);
                                                        }
                                                        //Log::info($customeremail_status);
                                                    }
                                                }
                                            }

                                            $NotificationEmails = Notification::getNotificationMail(['CompanyID'=>$CompanyID,'NotificationType'=>Notification::InvoicePaidByCustomer]);
                                            $emailArray = explode(',', $NotificationEmails);
                                            if (!empty($emailArray)) {
                                                foreach ($emailArray as $singleemail) {
                                                    $singleemail = trim($singleemail);
                                                    if (filter_var($singleemail, FILTER_VALIDATE_EMAIL)) {
                                                        $Emaildata['EmailTo'] = $singleemail;
                                                        $Emaildata['EmailToName'] = '';
                                                        $status = Helper::sendMail('emails.AutoPaymentEmailSend', $Emaildata);
                                                    }
                                                }
                                            }

                                        }
                                    } else {
                                        foreach ($unPaidInvoices as $Invoiceid) {
                                            $Invoice = Invoice::find($Invoiceid->InvoiceID);
                                            $transactiondata = array();
                                            $transactiondata['CompanyID'] = $account->CompanyId;
                                            $transactiondata['AccountID'] = $account->AccountID;
                                            $transactiondata['InvoiceID'] = $Invoice->InvoiceID;
                                            if(!empty($transactionResponse['transaction_id'])) {
                                                $transactiondata['Transaction'] = $transactionResponse['transaction_id'];
                                            }else{
                                                $transactiondata['Transaction'] = '';
                                            }
                                            $transactiondata['Notes'] = $transactionResponse['transaction_notes'];
                                            $transactiondata['Amount'] = floatval($Invoiceid->RemaingAmount);
                                            $transactiondata['Status'] = TransactionLog::FAILED;
                                            $transactiondata['created_at'] = date('Y-m-d H:i:s');
                                            $transactiondata['updated_at'] = date('Y-m-d H:i:s');
                                            $transactiondata['CreatedBy'] = $CreatedBy;
                                            $transactiondata['ModifyBy'] = $CreatedBy;
                                            TransactionLog::insert($transactiondata);

                                            $Emaildata = array();
                                            $Emaildata['Subject'] = $fullnumber . 'Invoice Payment';
                                            $Emaildata['CompanyID'] = $CompanyID;
                                            $Emaildata['CompanyName'] = $Company->CompanyName;
                                            $Emaildata['AccountName'] = $account->AccountName;
                                            $Emaildata['Amount'] = floatval($Invoiceid->RemaingAmount);;
                                            $Emaildata['Status'] = 'Fail';
                                            $Emaildata['PaymentMethod'] = $PaymentMethod;
                                            $Emaildata['Currency'] = Currency::getCurrencyCode($account->CurrencyId);
                                            $Emaildata['Notes'] = $transactionResponse['transaction_notes'];

                                            $CustomerEmail = '';
                                            if ($EMAIL_TO_CUSTOMER == 1) {
                                                $CustomerEmail = $account->BillingEmail;
                                            }
                                            $CustomerEmail = explode(",", $CustomerEmail);
                                            $EmailTemplateStatus = EmailsTemplates::CheckEmailTemplateStatus(Payment::AUTOINVOICETEMPLATE, $CompanyID);
                                            log::info('EmailTemplat Status '.$EmailTemplateStatus);
                                            if (!empty($CustomerEmail) && !empty($EmailTemplateStatus)) {
                                                $staticdata = array();
                                                $staticdata['PaidAmount'] = floatval($Invoiceid->RemaingAmount);
                                                $staticdata['PaidStatus'] = 'Failed';
                                                $staticdata['PaymentMethod'] = $PaymentMethod;
                                                $staticdata['PaymentNotes'] = $transactionResponse['transaction_notes'];

                                                foreach ($CustomerEmail as $singleemail) {
                                                    $singleemail = trim($singleemail);
                                                    if (filter_var($singleemail, FILTER_VALIDATE_EMAIL)) {
                                                        $Emaildata['EmailTo'] = $singleemail;
                                                        $WEBURL = CompanyConfiguration::getValueConfigurationByKey($CompanyID, 'WEB_URL');
                                                        $Emaildata['data']['InvoiceLink'] = $WEBURL . '/invoice/' . $AccountID . '-' . $Invoice->InvoiceID . '/cview?email=' . $singleemail;
                                                        $body = EmailsTemplates::SendAutoPayment($Invoice->InvoiceID, 'body', $CompanyID, $singleemail, $staticdata);
                                                        $Emaildata['Subject'] = EmailsTemplates::SendAutoPayment($Invoice->InvoiceID, "subject", $CompanyID, $singleemail, $staticdata);
                                                        if (!isset($Emaildata['EmailFrom'])) {
                                                            $Emaildata['EmailFrom'] = EmailsTemplates::GetEmailTemplateFrom(Payment::AUTOINVOICETEMPLATE, $CompanyID);
                                                        }
                                                        $customeremail_status = Helper::sendMail($body, $Emaildata, 0);
                                                        log::info('Customer EmailTemplat Status '.print_r($customeremail_status,true));
                                                        if (!empty($customeremail_status['status'])) {
                                                            $JobLoggedUser = User::find($UserID);
                                                            $statuslog = Helper::account_email_log($CompanyID, $AccountID, $Emaildata, $customeremail_status, $JobLoggedUser, '', $JobID);
                                                        }
                                                        //Log::info($customeremail_status);
                                                    }
                                                }
                                            }


                                            $NotificationEmails = Notification::getNotificationMail(['CompanyID'=>$CompanyID,'NotificationType'=>Notification::InvoicePaidByCustomer]);
                                            $emailArray = explode(',', $NotificationEmails);
                                            if (!empty($emailArray)) {
                                                foreach ($emailArray as $singleemail) {
                                                    $singleemail = trim($singleemail);
                                                    if (filter_var($singleemail, FILTER_VALIDATE_EMAIL)) {
                                                        $Emaildata['EmailTo'] = $singleemail;
                                                        $Emaildata['EmailToName'] = '';
                                                        $status = Helper::sendMail('emails.AutoPaymentEmailSend', $Emaildata);
                                                    }
                                                }
                                            }
                                        }
                                        $errors[] = 'Transaction Failed :' . $account->AccountName . ' Reason : ' . $transactionResponse['failed_reason'];
                                    }
                                    }catch (Exception $ev) {
                                        Log::error($ev);
                                        $errors[] = 'Transaction Failed :' . $account->AccountName . ' Reason : ' . $ev->getMessage();
                                    }

                                } else {
                                    $errors[] = 'Payment Profile Not set:' . $account->AccountName;
                                }
                            } else {
                                $errors[] = 'Payment Profile Not set:' . $account->AccountName;
                            }
                        } else {
                            $errors[] = 'Payment Method Not set:' . $account->AccountName;
                        }

                    } /* account outstanding over */

                } /* account loop over */
            } /* empty account over */

            $joblogdata['Message'] = 'Success';
            $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
            CronJobLog::insert($joblogdata);
        }catch (\Exception $e) {
            $errors[] = $e->getMessage();
            Log::error($e);
            $this->info('Failed:' . $e->getMessage());
            $joblogdata['Message'] ='Error:'.$e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            CronJobLog::insert($joblogdata);
            if(!empty($cronsetting['ErrorEmail'])) {
                $result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
                Log::error("**Email Sent Status " . $result['status']);
                Log::error("**Email Sent message " . $result['message']);
            }
        }

        /**  Email job detail */
        if (count($errors) > 0) {
            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'PF')->pluck('JobStatusID');
            $jobdata['JobStatusMessage'] = 'Skipped account: ' . implode(',\n\r', $errors);
        } else {
            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'S')->pluck('JobStatusID');
            $jobdata['JobStatusMessage'] = 'Payment Received  Successfully';
        }
        Job::where(["JobID" => $JobID])->update($jobdata);
        $job = Job::find($JobID);
        Job::send_job_status_email($job, $CompanyID);
        $dataactive['Active'] = 0;
        $dataactive['PID'] = '';
        $CronJob->update($dataactive);
        if(!empty($cronsetting['SuccessEmail'])){
            $result = CronJob::CronJobSuccessEmailSend($CronJobID);
            Log::error("**Email Sent Status ".$result['status']);
            Log::error("**Email Sent message ".$result['message']);
        }
        Log::error(" CronJobId end" . $CronJobID);

        CronHelper::after_cronrun($this->name, $this);

    }




}
