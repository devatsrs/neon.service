<?php
/**
 * Created by PhpStorm.
 * User: srs2
 * Date: 19/06/2019
 * Time: 02:39
 */

namespace App\Console\Commands;



use App\Lib\Account;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\ClarityPBX;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;
use \Exception;
use App\Lib\CompanyGateway;

class ImportClarityAccounts extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'importclarityaccounts';

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
    protected function getArguments()
    {
        return [
            ['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID '],
            ['CronJobID', InputArgument::REQUIRED, 'Argument CronJobID'],
        ];
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle()
    {

        CronHelper::before_cronrun($this->name, $this );

        $arguments = $this->argument();

        $CronJobID = $arguments["CronJobID"];
        $CompanyID = $arguments["CompanyID"];
        $CronJob =  CronJob::find($CronJobID);
        $cronsetting =   json_decode($CronJob->Settings,true);
        CronJob::activateCronJob($CronJob);

        $CompanyGatewayID =  $cronsetting['CompanyGatewayID'];

        Log::useFiles(storage_path().'/logs/importclarityaccounts-'.$CompanyGatewayID.'-'.date('Y-m-d').'.log');

        try {

            Log::info("============ Clarity Account Import Start ============");

            CronJob::createLog($CronJobID);

            $joblogdata = array();
            $joblogdata['CronJobID'] = $CronJobID;
            $joblogdata['created_at'] = date('Y-m-d H:i:s');
            $joblogdata['created_by'] = 'RMScheduler';
            $joblogdata['Message'] = '';

            $batch_insert_array_customer = $batch_insert_array_vendor = $tempCustomerData = $tempVendorData = array();
            $customer_data_count    = 0;
            $vendor_data_count      = 0;
            $insertLimit            = 250;
            $importoption           = 1;
            $gateway                = "";
            $AccountType            = 1;
            $accountimportdate      = date('Y-m-d H:i:s.000');
            $ProcessID              = CompanyGateway::getProcessID();

            $ClarityPBX = new ClarityPBX($CompanyGatewayID);
            $Customers  = $ClarityPBX->getCustomersList();
            $Vendors    = $ClarityPBX->getVendorsList();

            if(count($Customers)>0) {
                foreach ($Customers as $temp_customer_row) {
                    $count = DB::table('tblAccount')->where(["AccountName" => $temp_customer_row->descr, "AccountType" => $AccountType])->count();
                    if ($count == 0) {
                        $tempCustomerData['AccountName'] = $temp_customer_row->descr;
                        $tempCustomerData['AccountType'] = $AccountType;
                        $tempCustomerData['CompanyId'] = $CompanyID;
                        $tempCustomerData['Status'] = 1;
                        $tempCustomerData['IsCustomer'] = 1;
                        $tempCustomerData['LeadSource'] = 'Gateway auto import';
                        $tempCustomerData['CompanyGatewayID'] = $CompanyGatewayID;
                        $tempCustomerData['ProcessID'] = $ProcessID;
                        $tempCustomerData['created_at'] = date('Y-m-d H:i:s.000');
                        $tempCustomerData['created_by'] = 'Auto Import';
                        $batch_insert_array_customer[] = $tempCustomerData;
                        $customer_data_count++;

                        if ($customer_data_count > $insertLimit && !empty($batch_insert_array_customer)) {
                            DB::table('tblTempAccount')->insert($batch_insert_array_customer);
                            $batch_insert_array_customer = array();
                            $customer_data_count = 0;
                        }
                    }
                }
            }

            if(count($Vendors)>0) {
                foreach ($Vendors as $temp_vendor_row) {
                    $count = DB::table('tblAccount')->where(["AccountName" => $temp_vendor_row->descr, "AccountType" => $AccountType])->count();
                    if ($count == 0) {
                        $tempVendorData['AccountName'] = $temp_vendor_row->descr;
                        $tempVendorData['AccountType'] = $AccountType;
                        $tempVendorData['CompanyId'] = $CompanyID;
                        $tempVendorData['Status'] = 1;
                        $tempVendorData['IsVendor'] = 1;
                        $tempVendorData['LeadSource'] = 'Gateway auto import';
                        $tempVendorData['CompanyGatewayID'] = $CompanyGatewayID;
                        $tempVendorData['ProcessID'] = $ProcessID;
                        $tempVendorData['created_at'] = date('Y-m-d H:i:s.000');
                        $tempVendorData['created_by'] = 'Auto Import';
                        $batch_insert_array_vendor[] = $tempVendorData;
                        $vendor_data_count++;

                        if ($vendor_data_count > $insertLimit && !empty($batch_insert_array_vendor)) {
                            DB::table('tblTempAccount')->insert($batch_insert_array_vendor);
                            $batch_insert_array_vendor = array();
                            $vendor_data_count = 0;
                        }
                    }
                }
            }

            if (!empty($batch_insert_array_customer)) {
                DB::table('tblTempAccount')->insert($batch_insert_array_customer);
            }
            if (!empty($batch_insert_array_vendor)) {
                DB::table('tblTempAccount')->insert($batch_insert_array_vendor);
            }

            Log::info("start CALL  prc_WSProcessImportAccount ('" . $ProcessID . "','" . $CompanyID . "','".$CompanyGatewayID."','".""."','".$importoption."','".$accountimportdate."','".$gateway."')");
            try {
                DB::beginTransaction();
                $JobStatusMessage = DB::select("CALL  prc_WSProcessImportAccount ('" . $ProcessID . "','" . $CompanyID . "','" . $CompanyGatewayID . "','" . "" . "','" . $importoption . "','".$accountimportdate."','".$gateway."')");
                Log::info("end CALL  prc_WSProcessImportAccount ('" . $ProcessID . "','" . $CompanyID . "','" . $CompanyGatewayID . "','" . "" . "','" . $importoption . "','".$accountimportdate."','".$gateway."')");
                DB::commit();
                $JobStatusMessage = array_reverse(json_decode(json_encode($JobStatusMessage),true));
                Account::updateAccountNo($CompanyID);
                Log::info('update account number - Done');
                Log::info('account import date - '.$accountimportdate);
                $AccData['UserID'] = 0;
                $AccData['CompanyID'] = $CompanyID;
                $AccData['AccountDate'] = $accountimportdate;
                Account::addAccountAudit($AccData);
                if(count($JobStatusMessage) > 1){
                    $prc_error = array();
                    foreach ($JobStatusMessage as $JobStatusMessage1) {
                        $prc_error[] = $JobStatusMessage1['Message'];
                    }
                    $error = $prc_error;
                    $JobStatusMessage = implode(',\n\r',fix_jobstatus_meassage($error));
                }elseif(!empty($JobStatusMessage[0]['Message'])){
                    $JobStatusMessage = $JobStatusMessage[0]['Message'];
                }
                Log::info($JobStatusMessage);

                $joblogdata['Message']       = $JobStatusMessage;
                $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
                CronJobLog::insert($joblogdata);

            } catch ( Exception $err ) {
                try{
                    DB::rollback();
                }catch (Exception $err) {
                    Log::error($err);
                }
                Log::error($err);

                $joblogdata['Message']       = 'Exception: ' . $err->getMessage();
                $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
                CronJobLog::insert($joblogdata);
            }

            CronJob::deactivateCronJob($CronJob);

            Log::info("============ Clarity Account Import End ============");

        }catch (Exception $e) {
            Log::error($e);
            CronJob::deactivateCronJob($CronJob);

            $joblogdata['Message'] = 'Error:' . $e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            CronJobLog::insert($joblogdata);

        }
        Log::info("Import Clarity Account end");

        CronHelper::after_cronrun($this->name, $this);

    }

}