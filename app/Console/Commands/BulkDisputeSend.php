<?php namespace App\Console\Commands;
use App\Lib\AmazonS3;
use App\Lib\Account;
use App\Lib\AccountBilling;
use App\Lib\BillingClass;
use App\Lib\CompanyConfiguration;
use App\Lib\Dispute;
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
use Cartalyst\Stripe\Api\Disputes;
use Symfony\Component\Console\Input\InputArgument;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Lib\Job;
use App\Lib\EmailsTemplates;

use Webpatser\Uuid\Uuid;

class BulkDisputeSend extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'bulkdisputesend';

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

        $jobdata = array();
        $errorslog = array();
        $CompanyID = $arguments["CompanyID"];
        Log::useFiles(storage_path().'/logs/bulkdisputesend-'.$JobID.'-'.date('Y-m-d').'.log');
	try {
        $ProcessID = Uuid::generate();
        Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar

        $Company = Company::find($CompanyID);
        $EMAIL_TO_CUSTOMER = CompanyConfiguration::get($CompanyID,'EMAIL_TO_CUSTOMER');
        $InvoiceCopyEmail_main = Notification::getNotificationMail(['CompanyID'=>$CompanyID,'NotificationType'=>Notification::InvoiceCopy]);
        //$InvoiceCopyEmail_main = empty($InvoiceCopyEmail_main)?$Company->Email:$InvoiceCopyEmail_main;
        if(!empty($job)){
            $JobLoggedUser = User::find($job->JobLoggedUserID);
            $joboptions = json_decode($job->Options);
            $email_sending_failed = [];
            $DisputeIDs = array_filter(explode(',', $joboptions->DisputeIDs), 'intval');
            if(count($DisputeIDs)>0) {
                foreach ($DisputeIDs as $DisputeID) {
                    $attachment="";
                    $Dispute = Dispute::find($DisputeID);
                    $Account = Account::find($Dispute->AccountID);
                    $Currency = Currency::find($Account->CurrencyId);
                    $CurrencyCode = !empty($Currency) ? $Currency->Code : '';
                    $_InvoiceNumber = $Dispute->InvoiceNo;
                    $emaildata['data'] = array(
                        'InvoiceNumber' => $_InvoiceNumber,
                        'CompanyName' => $Company->CompanyName,
                        'InvoiceGrandTotal' => $Dispute->DisputeAmount,
                        'CurrencyCode' => $CurrencyCode
                    );
                    $emaildata['EmailToName'] = $Company->CompanyName;
                    $emaildata['Subject'] = EmailsTemplates::SendDisputeSingle($Dispute->DisputeID,"subject",$CompanyID,$emaildata);
                    $emaildata['CompanyID'] = $CompanyID;
					$emaildata['UserID'] = $job->JobLoggedUserID;

					if(isset($joboptions->email_from))
					{
						$emaildata['EmailFrom'] = $joboptions->email_from;
					}

					$CustomerEmail = $Account->BillingEmail;
                    $CustomerEmail = explode(",", $CustomerEmail);
                    $customeremail_status['status'] = 0;
                    $customeremail_status['message'] = '';
                    $customeremail_status['body'] = '';
                    Log::info($CustomerEmail);
                    foreach ($CustomerEmail as $singleemail) {
                            $singleemail = trim($singleemail);
                            if (filter_var($singleemail, FILTER_VALIDATE_EMAIL)) {
                                $emaildata['EmailTo'] = $singleemail;

                                $body					=	EmailsTemplates::SendDisputeSingle($Dispute->DisputeID,'body',$CompanyID,$emaildata);
                                $emaildata['Subject']	=	EmailsTemplates::SendDisputeSingle($Dispute->DisputeID,"subject",$CompanyID,$emaildata);

                                if(!isset($emaildata['EmailFrom'])){
								$emaildata['EmailFrom']	=	EmailsTemplates::GetEmailTemplateFrom(Dispute::EMAILTEMPLATE,$CompanyID);

								}
                                $attachment=$Dispute->Attachment;
                                if($attachment && $attachment!=''){
                                    $UPLOADPATH = CompanyConfiguration::get($CompanyID,'UPLOAD_PATH').'/';
                                    $TEMP_PATH = CompanyConfiguration::get($CompanyID,'TEMP_PATH').'/'.pathinfo($attachment, PATHINFO_BASENAME);
                                    $attach = AmazonS3::download( $CompanyID, $attachment, $TEMP_PATH );
                                    $emaildata['attach'][] = (strpos($attach, "https://") !== false) ? $TEMP_PATH : $UPLOADPATH.$attachment;
                                }
                                Log::info("============ EmailData===========");
                                Log::info($emaildata);
                          	  	$customeremail_status 	= 	Helper::sendMail($body, $emaildata,0);
                            }
                       }
                    Log::info("====== CustomerMail Status======");
                    Log::info($customeremail_status);
                    //$status = Helper::sendMail('emails.invoices.bulk_invoice_email', $emaildata);
                    if ($customeremail_status['status'] == 0) {
                        $email_sending_failed[] = $Account->AccountName;
                        $status['status'] = 'failure';
                    } else {
                        $status['status'] = "success";
                        /*if ($Invoice->InvoiceStatus != Invoice::PAID && $Invoice->InvoiceStatus != Invoice::PARTIALLY_PAID && $Invoice->InvoiceStatus != Invoice::CANCEL) {
                            $Invoice->update(['InvoiceStatus' => Invoice::SEND]);
                        }*/
                        /**
                         * Insert Data in InvoiceLog
                         */
                       /* $invoiceloddata = array();
                        $invoiceloddata['DisputeID'] = $DisputeID;
                        $invoiceloddata['Note'] = InvoiceLog::$log_status[InvoiceLog::SENT] . ' By RMScheduler';
                        $invoiceloddata['created_at'] = date("Y-m-d H:i:s");
                        $invoiceloddata['InvoiceLogStatus'] = InvoiceLog::SENT;
                        InvoiceLog::insert($invoiceloddata);*/
                        /** log emails against account */
                        $statuslog = Helper::account_email_log($CompanyID, $Account->AccountID, $emaildata, $customeremail_status, $JobLoggedUser, $ProcessID, $JobID);
                        if ($statuslog['status'] == 0) {
                            $errorslog[] = $Account->AccountName . ' email log exception:' . $statuslog['message'];
                        }
                    }
                }
            }else{
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                $jobdata['JobStatusMessage'] = 'No Data Found';
            }

            Log::info($email_sending_failed);

            if((count($email_sending_failed) > 0)){
                $jobdata['JobStatusMessage'] =count($email_sending_failed)>0?' \n\r Email Sending Failed: '.implode(',\n\r',$email_sending_failed):'';
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