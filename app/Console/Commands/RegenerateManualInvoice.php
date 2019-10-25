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

class RegenerateManualInvoice extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'remanualinvoice';

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
            ['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID ']
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
        $CompanyID = $arguments["CompanyID"];
        $errors = array();
        $message = array();
        //$InvoiceGenerationEmail = CompanySetting::getKeyVal($CompanyID,'InvoiceGenerationEmail');
        $InvoiceCopyEmail = Notification::getNotificationMail(['CompanyID'=>$CompanyID,'NotificationType'=>Notification::InvoiceCopy]);
        $InvoiceCopyEmail = !empty($InvoiceCopyEmail)?$InvoiceCopyEmail:'';
        $InvoiceCopyEmail = explode(",",$InvoiceCopyEmail);

        $InvoiceIDs = '11975,9802';
        Log::useFiles(storage_path() . '/logs/remanualinvoice-' . $CompanyID . '-' . date('Y-m-d') . '.log');

        try {
            $ProcessID = Uuid::generate();

            if (isset($InvoiceIDs)) {

                $InvoiceIDs = explode(',',$InvoiceIDs);

                if (count($InvoiceIDs) > 0) {

                    foreach ($InvoiceIDs as $InvoiceID) {
                        $Invoice = Invoice::find($InvoiceID);
                        if(!empty($Invoice)){

                        $InvoiceDetail = InvoiceDetail::where("InvoiceID",$InvoiceID)->get();
                        $Account = Account::find((int)$Invoice->AccountID);
                        $AccountID = $Account->AccountID;

                        try {

                            DB::beginTransaction();
                            DB::connection('sqlsrv2')->beginTransaction();


                            $hasUsageInInvoice =  InvoiceDetail::where("InvoiceID",$InvoiceID)
                                ->Where(function($query)
                                {
                                    $query->where("ProductType",Product::USAGE)
                                        ->orWhere("ProductType",Product::SUBSCRIPTION);
                                })->count();

                            if($hasUsageInInvoice == 0){

                                $errors[] = $Account->AccountName .' ' . ' Invoice has no usage or Subscription';

                                DB::commit();
                                DB::connection('sqlsrv2')->commit();

                            }else {


                                if (!empty($Invoice) && !empty($InvoiceDetail)) {

                                    $EndDate = date("Y-m-d", strtotime($InvoiceDetail[0]->EndDate));


                                    if (strtotime($EndDate) <= strtotime(date("Y-m-d"))) {

                                        Log::info(' ========================== Invoice Send Start =============================');

                                        $response = Invoice::resendManualInvoice($CompanyID, $Invoice, $InvoiceDetail, $InvoiceCopyEmail,$ProcessID,'');

                                        if (isset($response["status"]) && $response["status"] == 'success') {

                                            Log::info('Invoice created - ' . print_r($response, true));
                                            $message[] = $response["message"];

                                        } else {

                                            $errors[] = $response["message"];
                                            DB::rollback();
                                            DB::connection('sqlsrv2')->rollback();
                                            Log::info(' ========================== Error  =============================');
                                            Log::info('Invoice with Error - ' . print_r($response, true));

                                            continue;

                                        }

                                        if (count($errors) == 0) {

                                            Log::info('Invoice Commited  AccountID = ' . $AccountID);

                                            DB::commit();
                                            DB::connection('sqlsrv2')->commit();
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
                            $errors[] = 'Invoice ID Not Found '.$InvoiceID;
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
                       $jobdata['JobStatusMessage'] = 'Skipped account: ' . implode(PHP_EOL, $errors);
                       Log::info($jobdata);
                    }else if(count($message)){

                        $jobdata['JobStatusID'] = DB::table('tblJobStatus')->where('Code', 'S')->pluck('JobStatusID');
                        $jobdata['JobStatusMessage'] = 'Invoice Recreated Successfully'.PHP_EOL.implode(PHP_EOL, $message);
                       Log::info($jobdata);
                    }


                }
            }

        } catch (\Exception $e) {

            try {
                Log::info(' ========================== Exception occured =============================');
                Log::error($e);
                Log::info(' =======================================================');

            } catch (\Exception $err) {
                Log::error($err);
            }

        }


        CronHelper::after_cronrun($this->name, $this);


    }

}
