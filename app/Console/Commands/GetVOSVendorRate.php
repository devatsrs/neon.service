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
use App\Lib\CustomerTrunk;
use App\Lib\UsageDownloadFiles;
use App\Lib\DataTableSql;
use App\Lib\VendorTrunk;
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

class GetVOSVendorRate extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'getvosvendorrate';

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

        Log::useFiles(storage_path().'/logs/getvosvendorrate-'.$CompanyGatewayID.'-'.date('Y-m-d').'.log');

        try {

            Log::info("============ VOS Vendor Rate Start ============");

            CronJob::createLog($CronJobID);

            $joblogdata = array();
            $joblogdata['CronJobID'] = $CronJobID;
            $joblogdata['created_at'] = date('Y-m-d H:i:s');
            $joblogdata['created_by'] = 'RMScheduler';
            $joblogdata['Message'] = '';

            $GatewayID = Gateway::getGatewayID(Gateway::GATEWAY_VOS5000);
            $CompanyGateways = CompanyGateway::where(['GatewayID'=>$GatewayID,'Status'=>1])->get();
            $Message="";
            $PostData=array();
            $Prefixes=array();

            if(!empty($CompanyGateways)) {
                $VendorTrunks=VendorTrunk::where(["Status"=>1])->where("Prefix","!=","")->get();
                foreach ($CompanyGateways as $CompanyGateway) {

                    $CompanyGatewayID = $CompanyGateway->CompanyGatewayID;
                    $CompanyGatewayTitle = $CompanyGateway->Title;

                    $Message .= "<br> <b> Gateway : </b> " . $CompanyGatewayTitle;
                    $Message .= "<br>";

                    foreach($VendorTrunks as $VendorTrunk) {
                        $Prefix=$VendorTrunk->Prefix;
                        array_push($Prefixes,$Prefix);
                    }
                    if(!empty($Prefixes)){

                        $PostData['accounts']=$Prefixes;
                        $GetAllAccounts = VOS5000API::request('GetCustomer', $CompanyGatewayID, $CompanyGatewayTitle, $PostData);

                        if (!empty($GetAllAccounts->infoCustomers)) {
                            Log::info("Total Record=" . count($GetAllAccounts->infoCustomers));
                            $StoreRateData=array();
                            try {
                                foreach ($GetAllAccounts->infoCustomers as $Account) {
                                    $feerateGroup = $Account->feerateGroup;

                                    $GetFeeRates = VOS5000API::request('GetFeeRate', $CompanyGatewayID, $CompanyGatewayTitle, ["feeRateGroup" => $feerateGroup]);
                                    if (!empty($GetFeeRates->infoFeeRates)) {
                                        foreach ($GetFeeRates->infoFeeRates as $GetFeeRate) {
                                            $RateGroup = array();
                                            $RateGroup['CompanyID'] = $CompanyID;
                                            $RateGroup['FeePrefix'] = $GetFeeRate->feePrefix;
                                            $RateGroup['AreaCode'] = $GetFeeRate->areaCode;
                                            $RateGroup['AreaName'] = $GetFeeRate->areaName;
                                            $RateGroup['Fee'] = $GetFeeRate->fee;
                                            $RateGroup['Period'] = $GetFeeRate->period;
                                            $RateGroup['Type'] = $GetFeeRate->type;
                                            $RateGroup['IvrFee'] = $GetFeeRate->ivrFee;
                                            $RateGroup['IvrPeriod'] = $GetFeeRate->ivrPeriod;
                                            $RateGroup['FeeRateGroup'] = $feerateGroup;

                                            array_push($StoreRateData, $RateGroup);

                                        }
                                    } else {
                                        $Message .= "No Any Free Rates Found.";
                                    }

                                }
                                Log::info("Count Total Store Data= " . count($StoreRateData));
                                if (!empty($StoreRateData)) {
                                    //here store
                                    DB::connection('sqlsrv')->table("tblVOSVendorFeeRateGroup")->truncate();

                                    // It will process at a time 1500 records
                                    foreach (array_chunk($StoreRateData, 1500) as $t) {
                                        DB::connection('sqlsrv')->table("tblVOSVendorFeeRateGroup")->insert($t);
                                    }
                                   // $Message .= count($StoreRateData) . " Vendor Rates imported.";

                                    $query = "call prc_VOSImportVendorFeeRate (".$CompanyID.")";
                                    Log::info($query);

                                    $VOSAccount = DataTableSql::of($query)->getProcResult(array('ArchivedRatesTotal', 'TotalRatesImport'));
                                    $TotalArchivedRates = !empty($VOSAccount['data']['ArchivedRatesTotal'][0]->TotalArchivedRates) ? $VOSAccount['data']['ArchivedRatesTotal'][0]->TotalArchivedRates : 0;
                                    $TotalRateImport = !empty($VOSAccount['data']['TotalRatesImport'][0]->TotalVendorRatesImport) ? $VOSAccount['data']['TotalRatesImport'][0]->TotalVendorRatesImport : 0;

                                    $Message .= $TotalArchivedRates . " Vendor Rates Archived. <br>";
                                    $Message .= $TotalRateImport . " Vendor Rates Imported.";

                                }else{
                                    $Message .= count($StoreRateData) . " No Vendor Rates Found.";
                                }
                            }catch (Exception $e) {
                                //DB::connection('sqlsrvcdr')->rollback();
                                CronJob::deactivateCronJob($CronJob);
                                Log::info("############ Exception Generated ##############");
                                Log::info($e->getMessage());
                                $joblogdata['Message'] = 'Error:' . $e->getMessage();
                                $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
                                CronJobLog::insert($joblogdata);

                            }

                        }else{
                            $Message .= "No Accounts Found.";
                        }

                    }else{
                        $Message.="No any Vendor Prefix Found.";
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

            Log::info("Get VOS Customer Rate Completed ");

        }catch (Exception $e) {
            Log::error($e);
            CronJob::deactivateCronJob($CronJob);

            $joblogdata['Message'] = 'Error:' . $e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            CronJobLog::insert($joblogdata);

        }
        Log::info($Message);
        Log::info("Get VOS Customer Rate end");

        CronHelper::after_cronrun($this->name, $this);

    }

}