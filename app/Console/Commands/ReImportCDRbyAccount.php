<?php namespace App\Console\Commands;

use App\Lib\CompanyGateway;
use App\Lib\CronHelper;
use App\Lib\CronJob;
use App\Lib\TempUsageDetail;
use App\Porta;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;

class ReImportCDRbyAccount extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'reimportcdr';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'When local CDR doesnt match with Gateway cdr run this service to reCollect CDR from gateway.';

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
            ['CronJobID', InputArgument::REQUIRED, 'Argument CronJobID '],
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
        $CronJob = CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings);

        $yesterday_date = date('Y-m-d 23:59:59', strtotime('-1 day'));
        $CompanyGatewayID = $cronsetting->CompanyGatewayID;
        $companysetting = json_decode(CompanyGateway::getCompanyGatewayConfig($CompanyGatewayID));
        Log::useFiles(storage_path() . '/logs/tempcommand-' . $CompanyGatewayID . '-' . date('Y-m-d') . '.log');

        /* To avoid runing same day cron job twice */
        //if(true){//if($yesterday_date > $param['start_date_ymd']) {


        $accounts = array();
        try {
            $processID = Uuid::generate();
            DB::beginTransaction();
            DB::connection('sqlsrv2')->beginTransaction();
            DB::connection('sqlsrvcdr')->beginTransaction();
            Log::error(' ========================== porta transaction start =============================');

            $porta = new Porta($CompanyGatewayID);
            $responselistAccounts = $porta->listAccounts();
            /*foreach ((array)$responselistAccounts['CustomersShortInfo'] as $row_account) {
                $gadata = array();
                $gadata['CompanyID'] = $CompanyID;
                $gadata['CompanyGatewayID'] = $CompanyGatewayID;
                $gadata['GatewayAccountID'] = $accounts[] = $row_account['ICustomer'];

                $gadata['AccountName'] = $row_account['Name'];
                $row_account['CreationDate'] = date("Y-m-d H:i:s", (doubleval(filter_var($row_account['CreationDate'], FILTER_SANITIZE_NUMBER_INT)) / 1000));
                $gadata['AccountDetailInfo'] = json_encode($row_account);
                if (GatewayAccount::where(array('CompanyGatewayID' => $CompanyGatewayID, 'CompanyID' => $CompanyID, 'GatewayAccountID' => $row_account['ICustomer']))->count()) {
                    //GatewayAccount::where(array('CompanyGatewayID' => $CompanyGatewayID, 'CompanyID' => $CompanyID, 'GatewayAccountID' => $row_account['ICustomer']))->update($gadata);
                } else {
                    GatewayAccount::insert($gadata);
                }
            }*/

            $TimeZone = CompanyGateway::getGatewayTimeZone($CompanyGatewayID);
            if ($TimeZone != '') {
                date_default_timezone_set($TimeZone);
            } else {
                date_default_timezone_set('GMT'); // just to use e in date() function
            }
            $param['start_date_ymd'] = '2015-09-21'; //$this->getStartDate($CompanyID, $CompanyGatewayID, $CronJobID);
            $param['end_date_ymd'] = '2015-09-22';// $this->getLastDate($param['start_date_ymd'], $CompanyID, $CronJobID);

            Log::error(print_r($param, true));

            $AccountID = 105;
            $GatewayAccountID = 102360;
            //Delete old CDR on same duration.
            DB::connection('sqlsrv2')->statement("CALL prc_DeleteCDR(1 , 1 , '".$param['start_date_ymd']."', '".$param['end_date_ymd']."',".$AccountID.",'')");


            //foreach ($accounts as $GatewayAccountID) {
            $param['ICustomer'] = $GatewayAccountID; //$rowdata->GatewayAccountID;
            $response = array();

            $response = $porta->getAccountCDRs($param);
            if (!isset($response['faultCode'])) {
                if (isset($response['DictPortaCustomerAccountCDRS']['Voice Calls'])) {
                    Log::error(print_r(count($response['DictPortaCustomerAccountCDRS']['Voice Calls']), true));

                    foreach ((array)$response['DictPortaCustomerAccountCDRS']['Voice Calls'] as $row_account) {
                        $data = array();
                        $data['CompanyGatewayID'] = $CompanyGatewayID;
                        $data['CompanyID'] = $CompanyID;
                        $data['GatewayAccountID'] = $row_account['ICustomer'];
                        $data['connect_time'] = date("Y-m-d H:i:s", (doubleval(filter_var($row_account['Connect_time'], FILTER_SANITIZE_NUMBER_INT)) / 1000));
                        $data['disconnect_time'] = date("Y-m-d H:i:s", (doubleval(filter_var($row_account['Disconnect_time'], FILTER_SANITIZE_NUMBER_INT)) / 1000));
                        $data['cost'] = (float)$row_account['Charged_Amount'];
                        $data['cld'] = $row_account['CLD'];
                        $data['cli'] = $row_account['CLI'];
                        $seconds = strtotime(date("Y-m-d H:i:s", (doubleval(filter_var($row_account['Disconnect_time'], FILTER_SANITIZE_NUMBER_INT)) / 1000))) - strtotime(date("Y-m-d H:i:s", (doubleval(filter_var($row_account['Connect_time'], FILTER_SANITIZE_NUMBER_INT)) / 1000)));
                        $data['billed_duration'] = $seconds;
                        $data['duration'] = $seconds;
                        //$data['AccountID'] = $rowdata->AccountID;
                        $data['trunk'] = 'Other';
                        $data['area_prefix'] = 'Other';
                        $data['ProcessID'] = $processID;
                        $data['ID'] = $row_account['ID'];
                        //Log::error("CallType ==".$row_account['CallType']);
                        if (isset($row_account['CallType']) && is_numeric($row_account['CallType'])) {

                            $UniqueID = DB::connection('sqlsrvcdr')->select("CALL prc_checkUniqueID('" . $CompanyGatewayID . "','" . $row_account['ID'] . "')");
                            if (count($UniqueID) == 0) {
                                Log::error("CallType ==".$row_account['CallType'].$processID);
                                TempUsageDetail::insert($data);
                            }
                        }
                    }


                }


            }
            //}
            date_default_timezone_set(Config::get('app.timezone'));
            DB::commit();
            DB::connection('sqlsrv2')->commit();
            DB::connection('sqlsrvcdr')->commit();
            Log::error("Porta CDR StartTime " . $param['start_date_ymd'] . " - End Time " . $param['end_date_ymd']);
            Log::error(' ========================== porta transaction end =============================');
            ///
            //Update Prefix  , AreaCode
            ///
            Log::error('Porta prc_updatePrefixTrunk_NEW start');
            DB::connection('sqlsrv2')->statement("CALL prc_updatePrefixTrunk_NEW('" . $CompanyID . "','" . $CompanyGatewayID . "','" . $processID . "')");
            Log::error('Porta prc_updatePrefixTrunk_NEW end');
            Log::error('Porta prc_setAccountIDCDR_NEW start');
            DB::connection('sqlsrv2')->statement("CALL prc_setAccountIDCDR_NEW('" . $CompanyID . "','" . $processID . "')");
            Log::error('Porta prc_setAccountIDCDR_NEW start');
            Log::error('Porta prc_insertTempCDR start');
            DB::connection('sqlsrv2')->statement("CALL prc_insertTempCDR('" . $processID . "')");
            Log::error('Porta prc_insertTempCDR end');

            DB::connection('sqlsrvcdr')->beginTransaction();
            Log::error('Porta prc_insertCDR start');
            DB::connection('sqlsrvcdr')->statement("CALL prc_insertCDR('" . $processID . "')");
            Log::error('Porta prc_insertCDR end');
            DB::connection('sqlsrvcdr')->commit();
            //TempUsageDetail::where(["processId" => $processID])->delete();
            DB::connection('sqlsrv2')->select("CALL prc_getActiveGatewayAccount(" . $CompanyID . "," . $CompanyGatewayID.",'','1')");

        } catch (\Exception $e) {
            try {
                DB::rollback();
                DB::connection('sqlsrv2')->rollback();
                DB::connection('sqlsrvcdr')->rollback();
            } catch (\Exception $err) {
                Log::error($err);
            }
            date_default_timezone_set(Config::get('app.timezone'));
            $this->info('Failed:' . $e->getMessage());
            $joblogdata['Message'] = 'Error:' . $e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            Log::error($e);
        }
        //}


        CronHelper::after_cronrun($this->name, $this);



    }

}
