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
use App\Lib\DataTableSql;
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
use App\Lib\VOSAccount;
use App\Lib\VosIP;

class ImportVOSAccounts extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'importvosaccounts';

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

        Log::useFiles(storage_path().'/logs/importvosaccounts-'.$CompanyGatewayID.'-'.date('Y-m-d').'.log');

        try {

            Log::info("Import VOS Accounts Start");

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
                $i=0;
                foreach ($CompanyGateways as $CompanyGateway) {
                    $i++;
                    $CompanyGatewayID = $CompanyGateway->CompanyGatewayID;
                    $CompanyGatewayTitle = $CompanyGateway->Title;

                    $GetAllAccounts = VOS5000API::request('GetAllCustomers', $CompanyGatewayID, $CompanyGatewayTitle, $PostData);
                    if($i > 1){
                        $Message.="<br>";
                    }
                    $Message .= "<br> <u><b> Gateway :  " . $CompanyGatewayTitle." </b></u>";
                    $Message .= "<br>";
                    if (!empty($GetAllAccounts->accounts)) {
                        Log::info("Total Record=" . count($GetAllAccounts->accounts));
                        $VOSAccount = array();
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
                                    $data['LimitMoney'] = $val->limitMoney;
                                    $data['AccountType'] = $val->type;
                                    $data['AccountNumber'] = $val->account;
                                    $data['Address'] = $val->infoCustomerAdditional->address;
                                    $data['PostCode'] = $val->infoCustomerAdditional->postCode;
                                    $data['Phone'] = $val->infoCustomerAdditional->telephone;
                                    $data['Fax'] = $val->infoCustomerAdditional->fax;
                                    $data['Email'] = $val->infoCustomerAdditional->email;

                                    $data['created_at'] = date('Y-m-d H:i:s');
                                    $data['created_by'] = 'API';

                                    //Log::info(print_r($data,true));die;
                                    array_push($VOSAccount, $data);
                                }
                                Log::info("Total Found Accounts =" . count($VOSAccount));
                                if (!empty($VOSAccount) && count($VOSAccount) > 0) {
                                    DB::beginTransaction();

                                    VOSAccount::where(['CompanyID'=>$CompanyID,"CompanyGatewayID"=>$CompanyGatewayID])->delete();
                                    Log::info("Count Insert=" . count($VOSAccount));

                                    // It will process at a time 1500 records
                                    foreach (array_chunk($VOSAccount, 1500) as $t) {
                                        VOSAccount::insert($t);
                                    }

                                    DB::commit();
                                    $Message .= count($VOSAccount) . " Accounts imported.";
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


                    //For Customer GatewayMapping
                    $Message.= "<br> <b> Customer IP Import(GatewayMapping)  : </b> ";
                    $Message.= "<br>";
                    $Message.= $this->GetGatewayMapping($CompanyID,$CompanyGatewayID, $CompanyGatewayTitle, $PostData);

                    //For Vendor GetGatewayRouting
                    $Message.= "<br> <b> Vendor IP Import(GatewayMapping)  : </b> ";
                    $Message.= "<br>";
                    $Message.= $this->GetGatewayRouting($CompanyID,$CompanyGatewayID, $CompanyGatewayTitle, $PostData);

                    $query = "call prc_VOSCreateAccountOnNeonIfNotExist (".$CompanyID.")";
                    $VOSAccount = DataTableSql::of($query)->getProcResult(array('TotalCreateAccount'));
                    Log::info("===== Vos Account =====");
                    Log::info(print_r($VOSAccount,true));
                    $ResultAccnt=!empty($VOSAccount['data']['TotalCreateAccount'][0]->TotalAccountCreate)?$VOSAccount['data']['TotalCreateAccount'][0]->TotalAccountCreate:'';
                    if($ResultAccnt > 0){
                        $Message.= "<br><br> <b> Accounts Created  : </b>".$ResultAccnt;
                    }else{
                        $Message.= "<br><br> <b> No Accounts Found to Create </b>";
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

            Log::info("Import VOS Account Completed ");

        }catch (Exception $e) {
            Log::error($e);
            CronJob::deactivateCronJob($CronJob);

            $joblogdata['Message'] = 'Error:' . $e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            CronJobLog::insert($joblogdata);

        }
        Log::info("Import VOS Account end");

        CronHelper::after_cronrun($this->name, $this);

    }


    //For Customer
    function GetGatewayMapping($CompanyID,$CompanyGatewayID, $CompanyGatewayTitle, $PostData){
        $Message="";
        $VOSIPs=array();
        $GetGatewayMapping = VOS5000API::request('GetGatewayMapping', $CompanyGatewayID, $CompanyGatewayTitle, $PostData);
        if (!empty($GetGatewayMapping->infoGatewayMappings)) {
            try{

                foreach ($GetGatewayMapping->infoGatewayMappings as $val) {
                    $data = array();
                    //Log::info(print_r($val,true));die;
                    $data['CompanyID'] = $CompanyID;
                    $data['CompanyGatewayID'] = $CompanyGatewayID;
                    $data['AccountName'] = $val->accountName;
                    $data['Name'] = $val->name;
                    $data['RemoteIps'] = $val->remoteIps;
                    $data['IPType'] = 0; //Customer
                    $data['LockType'] = $val->lockType;
                    $data['LineLimit'] = $val->capacity;
                    $data['routingGatewayGroups'] = $val->routingGatewayGroups;

                    $RatePrefix = '';
                    if(!empty($val->rewriteRulesOutCallee)){
                        $rewriteRulesOutCallee = explode(",",$val->rewriteRulesOutCallee);

                        if(count($rewriteRulesOutCallee) > 1){
                            foreach($rewriteRulesOutCallee as $rp){
                               $temp_rp = explode(":",$rp);
                                if(!empty($temp_rp[1])){
                                    $RatePrefix.= $temp_rp[1].',';
                                }
                            }
                        }else{
                            //single
                            if(!empty($rewriteRulesOutCallee[0])){
                                $temp_rp = explode(":",$rewriteRulesOutCallee[0]);

                                if(!empty($temp_rp)){
                                    $RatePrefix = $temp_rp[1];
                                }
                            }
                        }

                        $RatePrefix= trim($RatePrefix,',');

                    }

                    $data['RoutePrefix'] = $RatePrefix;
                    $data['created_at'] = date('Y-m-d H:i:s');
                    $data['created_by'] = 'API';

                    //Log::info(print_r($data,true));die;
                    array_push($VOSIPs, $data);
                }

                Log::info("Total Found IPs =" . count($VOSIPs));
                if (!empty($VOSIPs) && count($VOSIPs) > 0) {
                    DB::beginTransaction();

                    VosIP::where(['CompanyID'=>$CompanyID,"CompanyGatewayID"=>$CompanyGatewayID,"IPType"=>0])->delete();
                    Log::info("Count Insert=" . count($VOSIPs));

                    // It will process at a time 1500 records
                    foreach (array_chunk($VOSIPs, 1500) as $t) {
                        VosIP::insert($t);
                    }

                    DB::commit();
                    $Message .= count($VOSIPs) . " GatewayMapping imported.";
                } else {
                    $Message .= "No Records Found.";
                }

                Log::info($Message);


                //IP Store Against Account
                $StoreIP=array();
                $VOSIPs=VOSIP::get();
                if(!empty($VOSIPs)){
                    $VOSip=array();
                    foreach($VOSIPs as $VOSIP){
                        $IPArray=explode(",",$VOSIP->RemoteIps);
                        foreach($IPArray as $IP){
                            $IPdata=array();
                            $IPdata['VOSIPID']=$VOSIP->VOSIPID;
                            $IPdata['AccountName']=$VOSIP->AccountName;
                            $IPdata['IPTYPE']=$VOSIP->AccountName;
                            $IPdata['IP']=$IP;
                            $IPdata['created_at']=date('Y-m-d H:i:s');

                            array_push($VOSip,$IPdata);
                        }
                    }
                    if(!empty($VOSip)){
                        DB::connection('sqlsrv')->table("tblVOSIPAgainstAccount")->truncate();
                        DB::connection('sqlsrv')->table("tblVOSIPAgainstAccount")->insert($VOSip);
                    }
                }



            }catch (Exception $e) {
                DB::rollback();
                $Message .= 'Error:' . $e->getMessage();
                return $Message;
            }

        }else {
            //return $Res;
            $Message .= "No Records Found.";
        }

        return $Message;
    }

    //For Vendor

    function GetGatewayRouting($CompanyID,$CompanyGatewayID, $CompanyGatewayTitle, $PostData){
        $Message="";
        $VOSIPs=array();
        $GetGatewayRouting = VOS5000API::request('GetGatewayRouting', $CompanyGatewayID, $CompanyGatewayTitle, $PostData);
        if (!empty($GetGatewayRouting->infoGatewayRoutings)) {
            try{

                foreach ($GetGatewayRouting->infoGatewayRoutings as $val) {
                    $data = array();
                    //Log::info(print_r($val,true));die;
                    $data['CompanyID'] = $CompanyID;
                    $data['CompanyGatewayID'] = $CompanyGatewayID;
                    $data['LocalIP'] = $val->localIp;
                    $data['AccountName'] = $val->clearingAccountName;
                    $data['RemoteIps'] = $val->remoteIp;
                    $data['Name'] = $val->name;
                    $data['IPType'] = 1; //vendor
                    $data['LockType'] = $val->lockType;
                    $data['NumberPrefix'] = $val->prefix;
                    $data['LineLimit'] = $val->capacity;

                    $data['created_at'] = date('Y-m-d H:i:s');
                    $data['created_by'] = 'API';


                    $RatePrefix = '';
                    if(!empty($val->rewriteRulesInCallee)){
                        $rewriteRulesOutCallee = explode(",",$val->rewriteRulesInCallee);

                        if(count($rewriteRulesOutCallee) > 1){
                            foreach($rewriteRulesOutCallee as $rp){
                                $temp_rp = explode(":",$rp);
                                if(!empty($temp_rp)){
                                    $RatePrefix.= $temp_rp[1].',';
                                }
                            }
                        }else{
                            //single
                            if(!empty($rewriteRulesOutCallee[0])){
                                $temp_rp = explode(":",$rewriteRulesOutCallee[0]);
                                if(!empty($temp_rp)){
                                    $RatePrefix.= $temp_rp[1];
                                }
                            }
                        }

                        $RatePrefix= trim($RatePrefix,',');

                    }

                    $data['RoutePrefix'] = $RatePrefix;

                    //Log::info(print_r($data,true));die;
                    array_push($VOSIPs, $data);
                }

                Log::info("Total Found GatewayRouting  =" . count($VOSIPs));
                if (!empty($VOSIPs) && count($VOSIPs) > 0) {
                    DB::beginTransaction();

                    VosIP::where(['CompanyID'=>$CompanyID,"CompanyGatewayID"=>$CompanyGatewayID,"IPType"=>1])->delete();
                    Log::info("Count Insert=" . count($VOSIPs));

                    // It will process at a time 1500 records
                    foreach (array_chunk($VOSIPs, 1500) as $t) {
                        VosIP::insert($t);
                    }

                    DB::commit();
                    $Message .= count($VOSIPs) . " GatewayRouting imported.";
                } else {
                    $Message .= "No Records Found.";
                }

                Log::info($Message);

            }catch (Exception $e) {
                DB::rollback();
                $Message .= 'Error:' . $e->getMessage();
                return $Message;
            }

        }else {
            //return $Res;
            $Message .= "No Records Found.";
        }

        return $Message;
    }

}