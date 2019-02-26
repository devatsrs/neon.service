<?php
/**
 * Created by PhpStorm.
 * User: srs2
 * Date: 25/05/2015
 * Time: 06:58
 */

namespace App\Console\Commands;



use App\Lib\CompanyConfiguration;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\UsageDownloadFiles;
use App\VOS5000;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;
use \Exception;
use App\Lib\Gateway;
use App\Lib\CompanyGateway;
use VOS5000API;
use App\Lib\VOSAccountBalance;

class ImportVOSAccountBalance extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'importvosaccountbalance';

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

        Log::useFiles(storage_path().'/logs/importvosaccountbalance-'.$CompanyGatewayID.'-'.date('Y-m-d').'.log');

        try {

            Log::info("Import Account Balance Start");

            CronJob::createLog($CronJobID);

            $joblogdata = array();
            $joblogdata['CronJobID'] = $CronJobID;
            $joblogdata['created_at'] = date('Y-m-d H:i:s');
            $joblogdata['created_by'] = 'RMScheduler';
            $joblogdata['Message'] = '';

            Log::info("============ VOS Account Balance Start ============");

            $GatewayID = Gateway::getGatewayID(Gateway::GATEWAY_VOS5000);
            $CompanyGateways = CompanyGateway::where(['GatewayID'=>$GatewayID,'Status'=>1])->get();
            $Message="";
            $PostData=array();
            $PostData['accounts']="";

            if(!empty($CompanyGateways)) {
                foreach ($CompanyGateways as $CompanyGateway) {
                    $CompanyGatewayID = $CompanyGateway->CompanyGatewayID;
                    $CompanyGatewayTitle = $CompanyGateway->Title;

                    $GetAllAccounts = VOS5000API::request('GetAllCustomers', $CompanyGatewayID, $CompanyGatewayTitle, $PostData);

                    $Message .= "<br> <b> Gateway : </b> " . $CompanyGatewayTitle;
                    $Message .= "<br>";
                    if (!empty($GetAllAccounts->accounts)) {
                        Log::info("Total Record=" . count($GetAllAccounts->accounts));
                        $VOSAccountBalance = array();
                        $AccountsData = array();
                        $AccountsData['accounts'] = $GetAllAccounts->accounts;
                        $GetCustomerDetail = VOS5000API::request('GetCustomer', $CompanyGatewayID, $CompanyGatewayTitle, $AccountsData);

                        if (!empty($GetCustomerDetail->infoCustomers)) {
                            try {
                                Log::info("TotalCustomers Details = " . count($GetCustomerDetail->infoCustomers));
                                foreach ($GetCustomerDetail->infoCustomers as $val) {
                                    $data = array();
                                    //Log::info(print_r($val,true));die;
                                    $data['CompanyID'] = $CompanyID;
                                    $data['CompanyGatewayID'] = $CompanyGatewayID;
                                    $data['AccountName'] = $val->name;
                                    $data['AccountBalance'] = $val->money;
                                    $data['AccountNumber'] = $val->account;

                                    $data['created_at'] = date('Y-m-d H:i:s');
                                    $data['created_by'] = 'API';

                                    //Log::info(print_r($data,true));die;
                                    array_push($VOSAccountBalance, $data);
                                }
                                Log::info("Total Found Accounts Balance=" . count($VOSAccountBalance));
                                if (!empty($VOSAccountBalance) && count($VOSAccountBalance) > 0) {
                                    DB::beginTransaction();

                                    VOSAccountBalance::where(['CompanyID'=>$CompanyID,"CompanyGatewayID"=>$CompanyGatewayID])->delete();
                                    Log::info("Count Insert=" . count($VOSAccountBalance));

                                    // It will process at a time 1500 records
                                    foreach (array_chunk($VOSAccountBalance, 1500) as $t) {
                                        VOSAccountBalance::insert($t);
                                    }

                                    DB::commit();
                                    $Message .= count($VOSAccountBalance) . " AccountBalance imported.";
                                } else {
                                    $Message .= "No Records Found.";
                                }

                                Log::info($Message);

                            } catch (Exception $e) {
                                //DB::connection('sqlsrvcdr')->rollback();
                                CronJob::deactivateCronJob($CronJob);

                                $joblogdata['Message'] = 'Error:' . $e->getMessage();
                                $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
                                CronJobLog::insert($joblogdata);
                            }
                        } else {
                            $Message .= "No any Customer Details Found";
                        }

                    } else {
                        //return $Res;
                        $Message .= "No Records Found.";
                    }
                }
            }else{
                $Message.="No any Company Gateway Found.";
            }

            //call procedure for check Account exist on Neon or not


            $joblogdata['Message'] = $Message;
            $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
            CronJobLog::insert($joblogdata);

            CronJob::deactivateCronJob($CronJob);

            Log::info("Import Account Balance Completed ");

        }catch (Exception $e) {
            Log::error($e);
            CronJob::deactivateCronJob($CronJob);

            $joblogdata['Message'] = 'Error:' . $e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            CronJobLog::insert($joblogdata);

        }
        Log::info("Import Account Balance end");

        CronHelper::after_cronrun($this->name, $this);

    }

}