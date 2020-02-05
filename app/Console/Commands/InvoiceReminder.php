<?php
namespace App\Console\Commands;

use App\Lib\Account;
use App\Lib\Company;
use App\Lib\CompanyConfiguration;
use App\Lib\CronHelper;
use App\Lib\Helper;
use App\Lib\Invoice;
use App\Lib\InvoiceLog;
use App\Lib\User;
use App\lib\AmazonS3;
use Symfony\Component\Console\Input\InputArgument;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Config;
use App\Lib\Job;
use Webpatser\Uuid\Uuid;

class InvoiceReminder extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'invoicereminder';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'bulk lead email send.';

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
        $getmypid = getmypid(); // get proccess id
        $JobID = $arguments["JobID"];
        $job = Job::find($JobID);
        $ProcessID = Uuid::generate();
        Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar
        $CompanyID = $arguments["CompanyID"];
        $EMAIL_TO_CUSTOMER = CompanyConfiguration::get($CompanyID,'EMAIL_TO_CUSTOMER');
        $TEMP_PATH = CompanyConfiguration::get($CompanyID,'TEMP_PATH').'/';
        $errors = array();
        $errorslog = array();
        try {
            if (!empty($job)) {
                $JobLoggedUser = User::find($job->JobLoggedUserID);
                $joboptions = json_decode($job->Options);
                if (count($joboptions) > 0) {
                    $ids = $joboptions->SelectedIDs;
                    $criteria = '';
                    if (!empty($joboptions->criteria)) {
                        $criteria = json_decode($joboptions->criteria);
                    }
                    if (!empty($joboptions->attachment)) {
                        $path = AmazonS3::unSignedUrl($joboptions->attachment,$CompanyID);
                        if (strpos($path, "https://") !== false) {
                            $file = $TEMP_PATH . basename($path);
                            file_put_contents($file, file_get_contents($path));
                            $joboptions->attachment = $file;
                        } else {
                            $joboptions->attachment = $path;
                        }
                    }
                    $count = 0;
                    if (!empty($ids)) {
                        $ids = explode(',', $ids);
                        $invoicequery = Invoice::select('tblInvoice.*');
                        $invoicequery->where(["tblInvoice.CompanyID" => $CompanyID]);
                        $invoicequery->whereIn('InvoiceID',$ids);
                        $result = $invoicequery->get();
                    } else if (!empty($criteria)) {
                        $AccountID = $InvoiceNumber = $IssueDateStart = $IssueDateEnd = $InvoiceType = $InvoiceStatus = '';
                        $Overdue =0;
                        if(isset($criteria->AccountID) && !empty($criteria->AccountID)) {
                            $AccountID = $criteria->AccountID;
                        }
                        if(isset($criteria->InvoiceNumber) && !empty($criteria->InvoiceNumber)) {
                            $InvoiceNumber = $criteria->InvoiceNumber;
                        }
                        if(isset($criteria->IssueDate) && !empty($criteria->IssueDate)) {
                            $arr = explode(' - ',$criteria->IssueDate);
                            $IssueDateStart = $arr[0];
                            $IssueDateEnd = $arr[1];
                        }
                        if(isset($criteria->InvoiceType) && !empty($criteria->InvoiceType)) {
                            $InvoiceType = $criteria->InvoiceType;
                        }
                        if(isset($criteria->InvoiceStatus) && !empty($criteria->InvoiceStatus)) {
                            $InvoiceStatus = $criteria->InvoiceStatus;
                        }
                        if(isset($criteria->Overdue) && !empty($criteria->Overdue)) {
                            $Overdue = $criteria['Overdue']== 'true'?1:0;
                        }
                        $query = $CompanyID.",'".$AccountID."','".$InvoiceNumber."','".$IssueDateStart."','".$IssueDateEnd."','".$InvoiceType."','".$InvoiceStatus."',".$Overdue.",' ',' ',' ',' ',2";
                        if(isset($criteria->zerovalueinvoice) && !empty($criteria->zerovalueinvoice) && $criteria->zerovalueinvoice=='true'){
                            $query = $query.',0,0,1';
                        }else{
                            $query = $query.',0,0,0';
                        }
                        $query.=",'',".$job->JobLoggedUserID; //userID
                        $query.=",''";//Tag
                        $query =  "CALL prc_getInvoice(".$query.")";

                        $result = DB::connection('sqlsrv2')->select($query);

                    }
                    if (!empty($result)) {
                        foreach ($result as $invoice) {
                            $Account = Account::find($invoice->AccountID);
                            //print_r($invoice);
                            //print_r($Account);exit;
                            if (!empty($Account->Email)) {
                                if($joboptions->test==1){
                                    $emaildata['EmailTo'] = $joboptions->testEmail;
                                }else if ($EMAIL_TO_CUSTOMER == 1) {
                                    //$emaildata['EmailTo'] = $Account->Email;//$invoice->Email;
                                    $emaildata['EmailTo'] = $Account->BillingEmail;//$invoice->Email;
                                }

                                if (!empty($joboptions->attachment)) {
                                    $emaildata['attach'] = $joboptions->attachment;
                                }

                                $emaildata['EmailToName'] = $Account->AccountName;

                                $InvoiceOutStanding =Account::getInvoiceOutstanding($CompanyID,$Account->AccountID,$invoice->InvoiceID,Helper::get_round_decimal_places($CompanyID,$Account->AccountID));

                                $replace_array['InvoiceNumber'] = $invoice->InvoiceNumber;
                                $replace_array['InvoiceGrandTotal'] = $invoice->GrandTotal;
                                $replace_array['InvoiceOutstanding'] = $InvoiceOutStanding;
                                $replace_array['InvoiceID'] = $invoice->InvoiceID;

                                $replace_array = Helper::create_replace_array($Account,$replace_array,$JobLoggedUser);
                                //$joboptions->message = template_var_replace($joboptions->message,$replace_array);
								$message =  template_var_replace($joboptions->message,$replace_array);

                                $emaildata['Subject'] = $joboptions->subject;
                                $emaildata['Message'] = $message;
                                $emaildata['CompanyID'] = $CompanyID;

                                $emaildata['mandrill'] = 1;
                                $status = Helper::sendMail('emails.template', $emaildata);
                                if (isset($status["status"]) && $status["status"] == 0) {
                                    $errors[] = $Account->AccountName . ', ' . $status["message"];
                                    $jobdata['EmailSentStatus'] = $status['status'];
                                    $jobdata['EmailSentStatusMessage'] = $status['message'];
                                } else {

                                    /** log emails against account */
                                    $statuslog = Helper::account_email_log($CompanyID,$Account->AccountID,$emaildata,$status,$JobLoggedUser,$ProcessID,$JobID);
                                    if($statuslog['status']==0) {
                                        $errorslog[] = $Account->AccountName . ' email log exception:' . $statuslog['message'];
                                    }
                                    $count++;
                                }
                            } else {
                                $errors[] = $Account->AccountName . ', ' . ' Email Not Found';
                            }
                        }
                    } else {
                        $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                        $jobdata['JobStatusMessage'] = 'No Data Found';
                    }

                } else {
                    $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                    $jobdata['JobStatusMessage'] = 'No Data Found';
                }
            } else {
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                $jobdata['JobStatusMessage'] = 'No Data Found';
            }
            $testemail = ($joboptions->test == 1 ? 'testemail,' : '');
            if(count($errors)>0 || count($errorslog)>0){
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code','PF')->pluck('JobStatusID');
                if(count($errors)>0){
                    $jobdata['JobStatusMessage'] = $testemail.' '.$count.' Email sent, '.count($errors).' Skipped account: '.implode(',\n\r',$errors);
                }else{
                    $jobdata['JobStatusMessage'] = $testemail.' '.$count.' Email sent, '.count($errorslog).' Email log errors: '.implode(',\n\r',$errorslog);
                }
            } else {
                $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'S')->pluck('JobStatusID');
                $jobdata['JobStatusMessage'] = $testemail . ' ' . $count . " Email sent, Email successfully send to all.";
            }
            $jobdata['updated_at'] = date('Y-m-d H:i:s');
            $jobdata['ModifiedBy'] = 'RMScheduler';
            Job::where(["JobID" => $JobID])->update($jobdata);
            Job::send_job_status_email($job, $CompanyID);

        } catch (\Exception $e) {
            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
            $jobdata['JobStatusMessage'] = 'Exception: ' . $e->getMessage();
            $jobdata['updated_at'] = date('Y-m-d H:i:s');
            $jobdata['ModifiedBy'] = 'RMScheduler';
            Job::where(["JobID" => $JobID])->update($jobdata);
            Log::error($e);
            Job::send_job_status_email($job, $CompanyID);
        }

        CronHelper::after_cronrun($this->name, $this);

    }
}