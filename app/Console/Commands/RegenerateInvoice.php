<?php namespace App\Console\Commands;

use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\Invoice;
use App\Lib\Job;
use App\Lib\Notification;
use App\Lib\Product;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;

class RegenerateInvoice extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'regenerateinvoice';

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
        $ProcessID = CompanyGateway::getProcessID();
        $arguments = $this->argument();
        $getmypid = getmypid(); // get proccess id added by abubakar
        $CompanyID = $arguments["CompanyID"];
        $JobID = $arguments["JobID"];
        $jobdata = array();

        $job = Job::find($JobID);
        $joboptions = json_decode($job->Options);
        //$InvoiceGenerationEmail = CompanySetting::getKeyVal($CompanyID,'InvoiceGenerationEmail');
        $InvoiceCopyEmail = Notification::getNotificationMail(['CompanyID'=>$CompanyID,'NotificationType'=>Notification::InvoiceCopy]);
        $InvoiceCopyEmail = !empty($InvoiceCopyEmail)?$InvoiceCopyEmail:'';
        $InvoiceCopyEmail = explode(",",$InvoiceCopyEmail);

        Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar
        Log::useFiles(storage_path() . '/logs/regenerateinvoice-' . $CompanyID . '-' . $JobID . '-' . date('Y-m-d') . '.log');

        try {
            if (isset($joboptions->InvoiceIDs)) {


                $InvoiceIDs = explode(',',$joboptions->InvoiceIDs);
                if (count($InvoiceIDs) > 0) {

                    $Invoices = Invoice::join("tblInvoiceDetail","tblInvoiceDetail.InvoiceID","=","tblInvoice.InvoiceID")
                        ->whereIn("tblInvoice.InvoiceID", $InvoiceIDs)
                        ->whereIn("tblInvoiceDetail.ProductType",[Product::USAGE, Product::INVOICE_PERIOD])
                        ->select("tblInvoiceDetail.StartDate","tblInvoiceDetail.EndDate","tblInvoice.AccountType","tblInvoice.InvoiceNumber","tblInvoice.InvoiceID","tblInvoice.AccountID","tblInvoice.CompanyID")
                        ->groupBy("tblInvoice.InvoiceID")
                        ->get();

                    $CustomerInvoices   = [];
                    $AffiliateInvoices  = [];
                    $PartnerInvoices    = [];

                    foreach ($Invoices AS $Invoice){
                        switch ($Invoice->AccountType){
                            case "Customer":
                                $CustomerInvoices[] = $Invoice;
                                break;
                            case "Affiliate":
                                $AffiliateInvoices[] = $Invoice;
                                break;
                            case "Partner":
                                $PartnerInvoices[] = $Invoice;
                                break;
                        }
                    }

                    $CustomerIDs  = array_pluck($CustomerInvoices, 'InvoiceID');
                    $AffiliateIDs = array_pluck($AffiliateInvoices, 'InvoiceID');
                    $PartnerIDs   = array_pluck($PartnerInvoices, 'InvoiceID');

                    Log::info(' ========================== Invoice Send Start =============================');

                    $skippedInvoiceNumbers = [];

                    if(!empty($CustomerInvoices)){
                        Log::info("Customers Invoice Regeneration Started against " . json_encode($CustomerIDs));
                        foreach($CustomerInvoices as $CustomerInvoice){
                            $resp = Invoice::regenerateInvoiceData($CustomerInvoice, $InvoiceCopyEmail, $JobID, $ProcessID);
                            if($resp === false) $skippedInvoiceNumbers[] = $CustomerInvoice->InvoiceNumber;
                        }
                    }

                    if(!empty($AffiliateInvoices)){
                        Log::info("Affiliates Invoice Regeneration Started against " . json_encode($AffiliateIDs));
                        foreach($AffiliateInvoices as $AffiliateInvoice){
                            $resp = Invoice::regenerateInvoiceData($AffiliateInvoice, $InvoiceCopyEmail, $JobID, $ProcessID);
                            if($resp === false) $skippedInvoiceNumbers[] = $CustomerInvoice->InvoiceNumber;
                        }
                    }

                    if(!empty($PartnerInvoices)){
                        Log::info("Partners Invoice Regeneration Started against " . json_encode($PartnerIDs));
                        foreach($PartnerInvoices as $PartnerInvoice){
                            $resp = Invoice::regenerateInvoiceData($PartnerInvoice, $InvoiceCopyEmail, $JobID, $ProcessID);
                            if($resp === false) $skippedInvoiceNumbers[] = $CustomerInvoice->InvoiceNumber;
                        }
                    }

                    Log::error(' ========================== Invoice Send Loop End =============================');

                    $TotalSkipped = count($skippedInvoiceNumbers);
                    $TotalInvoices = $Invoices->count();
                    Log::error('Total skipped invoice '. $TotalSkipped);

                    if ($TotalSkipped > 0) {

                        if ($TotalInvoices == $TotalSkipped) {
                            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                        } else {
                            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'PF')->pluck('JobStatusID');
                        }

                        $jobdata['JobStatusMessage'] = 'Skipped invoice numbers: ' . implode(', ', $skippedInvoiceNumbers);
                    } else {

                        $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'S')->pluck('JobStatusID');
                        $jobdata['JobStatusMessage'] = 'Invoice Regenerated Successfully';
                    }

                    Log::error('jobdata '.$JobID . print_r($jobdata,true));

                    $jobdata['ModifiedBy'] = 'RMScheduler';
                    $job = Job::find($JobID);
                    $job->update($jobdata);
                    Job::send_job_status_email($job, $CompanyID);
                    Log::info(' ========================== Job Updated =============================');
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
                    $jobdata['JobStatusMessage'] = $JobStatusMessage . '\n\r' . $e->getMessage();
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
