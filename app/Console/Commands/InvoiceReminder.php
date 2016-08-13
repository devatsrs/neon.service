<?php
namespace App\Console\Commands;

use App\Lib\Account;
use App\Lib\Company;
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
                        $path = AmazonS3::unSignedUrl($joboptions->attachment);
                        if (strpos($path, "https://") !== false) {
                            $file = Config::get('app.temp_location') . basename($path);
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
                        if(isset($criteria->AccountID) && !empty($criteria->AccountID)) {
                            $AccountID = $criteria->AccountID;
                        }
                        if(isset($criteria->InvoiceNumber) && !empty($criteria->InvoiceNumber)) {
                            $InvoiceNumber = $criteria->InvoiceNumber;
                        }
                        if(isset($criteria->IssueDateStart) && !empty($criteria->IssueDateStart)) {
                            $IssueDateStart = $criteria->IssueDateStart;
                        }
                        if(isset($criteria->IssueDateEnd) && !empty($criteria->IssueDateEnd)) {
                            $IssueDateEnd = $criteria->IssueDateEnd;
                        }
                        if(isset($criteria->InvoiceType) && !empty($criteria->InvoiceType)) {
                            $InvoiceType = $criteria->InvoiceType;
                        }
                        if(isset($criteria->InvoiceStatus) && !empty($criteria->InvoiceStatus)) {
                            $InvoiceStatus = $criteria->InvoiceStatus;
                        }
                        $query = $CompanyID.",'".$AccountID."','".$InvoiceNumber."','".$IssueDateStart."','".$IssueDateEnd."','".$InvoiceType."','".$InvoiceStatus."',' ',' ',' ',' ',2";
                        if(isset($criteria->zerovalueinvoice) && !empty($criteria->zerovalueinvoice) && $criteria->zerovalueinvoice=='true'){
                            $query = $query.',0,1';
                        }
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
                                }else if (getenv('EmailToCustomer') == 1) {
                                    $emaildata['EmailTo'] = $Account->Email;//$invoice->Email;
                                } else {
                                    $emaildata['EmailTo'] = Company::getEmail($CompanyID);//$invoice->Email;
                                }

                                if (!empty($joboptions->attachment)) {
                                    $emaildata['attach'] = $joboptions->attachment;
                                }
                                $Signature = '';
                                if (!empty($JobLoggedUser)) {
                                    $emaildata['EmailFrom'] = $JobLoggedUser->EmailAddress;
                                    $emaildata['EmailFromName'] = $JobLoggedUser->FirstName . ' ' . $JobLoggedUser->LastName;
                                    if(isset($JobLoggedUser->EmailFooter) && trim($JobLoggedUser->EmailFooter) != '')
                                    {
                                        $Signature = $JobLoggedUser->EmailFooter;
                                    }
                                }
                                $emaildata['EmailToName'] = $Account->AccountName;
                                $TotalOutStanding =Account::getOutstandingAmount($CompanyID,$Account->AccountID,Helper::get_round_decimal_places($CompanyID,$Account->AccountID));
                                $InvoiceOutStanding =Account::getInvoiceOutstanding($CompanyID,$Account->AccountID,$invoice->InvoiceID,Helper::get_round_decimal_places($CompanyID,$Account->AccountID));
                                $extra = ['{{FirstName}}', '{{LastName}}', '{{Email}}', '{{Address1}}', '{{Address2}}', '{{Address3}}', '{{City}}', '{{State}}', '{{PostCode}}', '{{Country}}','{{InvoiceNumber}}','{{GrandTotal}}','{{OutStanding}}','{{TotalOutStanding}}','{{Signature}}'];
                                $replace = [$Account->FirstName, $Account->LastName, $Account->Email, $Account->Address1, $Account->Address2, $Account->Address3, $Account->City, $Account->State, $Account->PostCode, $Account->Country,$invoice->InvoiceNumber,$invoice->GrandTotal,$InvoiceOutStanding,$TotalOutStanding,$Signature];
                                $emaildata['extra'] = $extra;
                                $emaildata['replace'] = $replace;
                                $emaildata['Subject'] = $joboptions->subject;
                                $emaildata['Message'] = $joboptions->message;
                                $emaildata['CompanyID'] = $CompanyID;

                                $emaildata['mandrill'] = 1;
                                $status = Helper::sendMail('emails.BulkLeadEmailSend', $emaildata);
                                if (isset($status["status"]) && $status["status"] == 0) {
                                    $errors[] = $Account->AccountName . ', ' . $status["message"];
                                    $jobdata['EmailSentStatus'] = $status['status'];
                                    $jobdata['EmailSentStatusMessage'] = $status['message'];
                                } else {

                                    $logData = ['AccountID'=>$Account->AccountID,
                                        'ProcessID'=>$ProcessID,
                                        'JobID'=>$JobID,
                                        'User'=>$JobLoggedUser,
                                        'EmailFrom'=>$JobLoggedUser->EmailAddress,
                                        'EmailTo'=>$emaildata['EmailTo'],
                                        'Subject'=>$emaildata['Subject'],
                                        'Message'=>$status['body']];
                                    $statuslog = Helper::email_log($logData);
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