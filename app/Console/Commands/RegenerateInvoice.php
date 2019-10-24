<?php namespace App\Console\Commands;

use App\Lib\Account;
use App\Lib\CompanySetting;
use App\Lib\CronHelper;
use App\Lib\Invoice;
use App\Lib\InvoiceDetail;
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



        $arguments = $this->argument();
        $getmypid = getmypid(); // get proccess id added by abubakar
        $CompanyID = $arguments["CompanyID"];
        $JobID = $arguments["JobID"];
        $errors = array();
        $message = array();
        $jobdata = array();

        $job = Job::find($JobID);
        $joboptions = json_decode($job->Options);
        //$InvoiceGenerationEmail = CompanySetting::getKeyVal($CompanyID,'InvoiceGenerationEmail');
        $InvoiceCopyEmail = Notification::getNotificationMail(['CompanyID'=>$CompanyID,'NotificationType'=>Notification::InvoiceCopy]);
        $InvoiceCopyEmail = !empty($InvoiceCopyEmail)?$InvoiceCopyEmail:'';
        $InvoiceCopyEmail = explode(",",$InvoiceCopyEmail);


        Log::useFiles(storage_path() . '/logs/regenerateinvoice-' . $CompanyID . '-' . $JobID . '-' . date('Y-m-d') . '.log');

        try {
            $ProcessID = Uuid::generate();
            Job::JobStatusProcess($JobID, $ProcessID,$getmypid);//Change by abubakar
            if (isset($joboptions->InvoiceIDs)) {

                $InvoiceIDs = explode(',',$joboptions->InvoiceIDs);
                sort($InvoiceIDs);

                if (count($InvoiceIDs) > 0) {

                    foreach ($InvoiceIDs as $InvoiceID) {
                        $Invoice = Invoice::find($InvoiceID);
                        if(!empty($Invoice) && $Invoice->InvoiceStatus != Invoice::CANCEL){

                        $InvoiceDetail = InvoiceDetail::where("InvoiceID",$InvoiceID)->get();
                        $Account = Account::find((int)$Invoice->AccountID);
                        $AccountID = $Account->AccountID;

                        try {

                            DB::beginTransaction();
                            DB::connection('sqlsrv2')->beginTransaction();

                            $FirstInvoiceSend =  InvoiceDetail::where("InvoiceID",$InvoiceID)->where("ProductType",Product::FIRST_PERIOD)->count();

                            $hasUsageInInvoice =  InvoiceDetail::where("InvoiceID",$InvoiceID)->where("ProductType",Product::USAGE)->count();

                            if($hasUsageInInvoice == 0 && $FirstInvoiceSend==0){

                                $errors[] = $Account->AccountName .'('.$Invoice->FullInvoiceNumber.') ' . ' Invoice has no usage';

                                DB::commit();
                                DB::connection('sqlsrv2')->commit();

                            }else {


                                if (!empty($Invoice) && !empty($InvoiceDetail)) {

                                    $EndDate = date("Y-m-d", strtotime($InvoiceDetail[0]->EndDate));


                                    if (strtotime($EndDate) <= strtotime(date("Y-m-d"))) {

                                        Log::info(' ========================== Invoice Send Start =============================');

                                        log::info('Regular Invoice Regenerate');
                                        $response = Invoice::regenerateInvoice($CompanyID, $Invoice, $InvoiceDetail, $InvoiceCopyEmail,$ProcessID,$JobID,$FirstInvoiceSend);

                                        if (isset($response["status"]) && $response["status"] == 'success') {

                                            Log::info('Invoice created - ' . print_r($response, true));
                                            Log::info('Invoice Commited  AccountID = ' . $AccountID);
                                            $message[] = $response["message"];
                                            DB::commit();
                                            DB::connection('sqlsrv2')->commit();

                                        } else {

                                            $errors[] = $response["message"];
                                            DB::rollback();
                                            DB::connection('sqlsrv2')->rollback();
                                            Log::info(' ========================== Error  =============================');
                                            Log::info('Invoice with Error - ' . print_r($response, true));

                                            continue;

                                        }

                                    }
                                }
                            }

                            Log::error(' ========================== Invoice Send End =============================');


                        } catch (\Exception $e) {

                            try {

                                Log::error('Invoice Rollback InvoiceID = ' . $InvoiceID);
                                DB::rollback();
                                DB::connection('sqlsrv2')->rollback();
                                Log::error($e);

                                $errors[] = $e->getMessage();


                            } catch (\Exception $err) {
                                Log::error($err);
                                $errors[] = $e->getMessage() . ' ## ' . $err->getMessage();
                            }

                        }}else{
                            if(!empty($Invoice) && $Invoice->InvoiceStatus == Invoice::CANCEL){
                                $errors[] = 'Invoice Status is Cancel ('.$Invoice->InvoiceNumber.')';
                            }else{
                                $errors[] = 'Invoice ID Not Found '.$InvoiceID;
                            }
                        }
                    } //loop over


                    Log::error(' ========================== Invoice Send Loop End =============================');

                    Log::error('count($errors) '.count($errors));

                   if (count($errors) > 0) {
                       if (count($errors) >= count($InvoiceIDs) ) {
                           $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'F')->pluck('JobStatusID');
                       }else{
                            $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'PF')->pluck('JobStatusID');
                       }
                       $jobdata['JobStatusMessage'] = 'Skipped account: ' . implode(',\n\r', $errors);

                    }else if(count($message)){

                        $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'S')->pluck('JobStatusID');
                        $jobdata['JobStatusMessage'] = 'Invoice Recreated Successfully' . implode(',\n\r', $message);
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
                    $jobdata['JobStatusMessage'] .= $JobStatusMessage . '\n\r' . $e->getMessage();
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
