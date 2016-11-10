<?php namespace App\Console\Commands;

use App\Lib\Account;
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

        /**  Loop through account Outstanding.*/
        $Accounts = Account::select(["AccountID", "AccountName","CompanyId","CurrencyId"])
                    ->where(["CompanyID" => $CompanyID, "Status" => 1, "AccountType" => 1, "Autopay" => 1])
                    //->where(["AccountID" => 13])
                    ->get();

        /**  Create a Job */
        $UserID = User::where("CompanyID", $CompanyID)->where("Roles", "like", "%Admin%")->min("UserID");
        $CreatedBy = User::get_user_full_name($UserID);
        $jobType = JobType::where(["Code" => 'BPC'])->get(["JobTypeID", "Title"]);
        $jobStatus = JobStatus::where(["Code" => "I"])->get(["JobStatusID"]);
        $jobdata["CompanyID"] = $CompanyID;
        $jobdata["JobTypeID"] = isset($jobType[0]->JobTypeID) ? $jobType[0]->JobTypeID : '';
        $jobdata["JobStatusID"] = isset($jobStatus[0]->JobStatusID) ? $jobStatus[0]->JobStatusID : '';
        $jobdata["JobLoggedUserID"] = $UserID;
        $jobdata["Title"] = "[Auto] " . (isset($jobType[0]->Title) ? $jobType[0]->Title : '');
        $jobdata["Description"] = isset($jobType[0]->Title) ? $jobType[0]->Title : '';
        $jobdata["CreatedBy"] = $CreatedBy;
        $jobdata["created_at"] = date('Y-m-d H:i:s');
        $jobdata["updated_at"] = date('Y-m-d H:i:s');
        $JobID = Job::insertGetId($jobdata);

        /** ************************************************************/
        try {
            CronJob::createLog($CronJobID);
            foreach ($Accounts as $account) {
                $outstanamout = DB::connection('sqlsrv2')->select('CALL prc_getAccountOutstandingAmount( ' . $CompanyID . ',' . $account->AccountID .")");
                $outstanginamount = isset($outstanamout[0]) ? $outstanamout[0]->Outstanding : 0;

                if ($outstanginamount > 0) {

                    /**  get Default Payment Method*/
                    $CustomerProfile = AccountPaymentProfile::getActiveProfile($account->AccountID);
                    if(!empty($CustomerProfile)) {
                        $PaymentGateway = PaymentGateway::getName($CustomerProfile->PaymentGatewayID);
                        $AccountPaymentProfileID = $CustomerProfile->AccountPaymentProfileID;
                        $options = json_decode($CustomerProfile->Options);
                        /**  Get All UnPaid  Invoice */
                        $unPaidInvoices = DB::connection('sqlsrv2')->select('CALL prc_getPaymentPendingInvoice( ' . $CompanyID.',' . $account->AccountID.",1)");

                        /**  Start Transaction */
                        $transactionResponse = PaymentGateway::addTransaction($PaymentGateway, $outstanginamount, $options, $account,$AccountPaymentProfileID,$CompanyID);

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
                                $paymentdata['Currency'] = Currency::getCurrencyCode($account->CurrencyId);
                                $paymentdata['PaymentType'] = 'Payment In';
                                $paymentdata['Notes'] = $transactionResponse['transaction_notes'];
                                $paymentdata['Amount'] = floatval($Invoiceid->RemaingAmount);
                                $paymentdata['Status'] = 'Approved';
                                $paymentdata['created_at'] = date('Y-m-d H:i:s');
                                $paymentdata['updated_at'] = date('Y-m-d H:i:s');
                                $paymentdata['CreatedBy'] = $CreatedBy;
                                $paymentdata['ModifyBy'] = $CreatedBy;
                                Payment::insert($paymentdata);
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
                            }
                        } else {
                            foreach ($unPaidInvoices as $Invoiceid) {
                                $Invoice = Invoice::find($Invoiceid->InvoiceID);
                                $transactiondata = array();
                                $transactiondata['CompanyID'] = $account->CompanyId;
                                $transactiondata['AccountID'] = $account->AccountID;
                                $transactiondata['InvoiceID'] = $Invoice->InvoiceID;
                                $transactiondata['Transaction'] = $transactionResponse['transaction_id'];
                                $transactiondata['Notes'] = $transactionResponse['transaction_notes'];
                                $transactiondata['Amount'] = floatval($Invoiceid->RemaingAmount);
                                $transactiondata['Status'] = TransactionLog::FAILED;
                                $transactiondata['created_at'] = date('Y-m-d H:i:s');
                                $transactiondata['updated_at'] = date('Y-m-d H:i:s');
                                $transactiondata['CreatedBy'] = $CreatedBy;
                                $transactiondata['ModifyBy'] = $CreatedBy;
                                TransactionLog::insert($transactiondata);
                            }
                            $errors[] = 'Transaction Failed :' . $account->AccountName . ' Reason : ' . $transactionResponse['failed_reason'];
                        }
                    } else {
                        $errors[] = 'Payment Profile Not set:' . $account->AccountName;
                    }
                }
            }
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
