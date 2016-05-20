<?php namespace App\Console\Commands;

use App\Lib\TempUsageDetail;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Maatwebsite\Excel\Facades\Excel;
use App\Lib\NeonExcelIO;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;
use Webpatser\Uuid\Uuid;

class ManualPortaAccountCDRImport extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'manualportaaccountcdrimport';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Import CDR Exported from Porta';

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
     * Execute the console command.
     *
     * @return mixed
     */
    public function fire()
    {
        $arguments = $this->argument();

        $CompanyID = $arguments["CompanyID"];
        $AccountID = 99;
        $GatewayAccountID = 104482;
        $CompanyGatewayID = 1;
        $ProcessID = Uuid::generate();
        $StartDate = '2015-10-01 00:00:00';
        $EndDate = '2015-10-31 23:59:59';
        $file = 'C:/Users/deven/Desktop/TMP/CDR/CDRs/CDRs/HGA Accountants.csv';
        //Account	From	To	Country	Description	Date/Time	Charged time, hour:min:sec	Amount, GBP	Hidden

        //$results =  Excel::load($file)->toArray();
        $NeonExcel = new NeonExcelIO($file);
        $results = $NeonExcel->read();
        //print_r($results);
        //exit;
        $lineno = 2;
        DB::connection('sqlsrv2')->statement("CALL prc_DeleteCDR('" . $CompanyID . "','" . $CompanyGatewayID . "','" . $StartDate . "','" . $EndDate . "',$AccountID,'' )");
        $error = array();
        foreach ($results as $temp_row) {

            /*,[CompanyID]
            ,[CompanyGatewayID]
            ,[GatewayAccountID]
            ,[AccountID]
            ,[connect_time]
            ,[disconnect_time]
            ,[billed_duration]
            ,[trunk]
            ,[area_prefix]
            ,[cli]
            ,[cld]
            ,[cost]
            ,[ProcessID]
            ,[ID]
            ,[remote_ip]
            ,[duration]*/

            $tempItemData = array();
            //check empty row
            $checkemptyrow = array_filter(array_values($temp_row));
            if(!empty($checkemptyrow)){
                if(isset($temp_row['account']) && !empty($temp_row['account']) ){
                    $tempItemData['CompanyID'] = $CompanyID;
                    $tempItemData['CompanyGatewayID'] = $CompanyGatewayID;
                    $tempItemData['GatewayAccountID'] = $GatewayAccountID;
                    $tempItemData['connect_time'] = formatDate($temp_row['datetime']);

                    $strtotime = strtotime($tempItemData['connect_time']);
                    $billed_duration = strtotime($temp_row['charged_time_hourminsec']); //billed_duration
                    $tempItemData['disconnect_time'] = date('Y-m-d H:i:s', $strtotime + formatDuration($temp_row['charged_time_hourminsec']));
                    $tempItemData['duration'] = formatDuration($temp_row['charged_time_hourminsec']);
                    $tempItemData['billed_duration'] = formatDuration($temp_row['charged_time_hourminsec']);
                    $tempItemData['cli'] = $temp_row['from'];
                    $tempItemData['cld'] = $temp_row['to'];
                    $tempItemData['cost'] = $temp_row['amount_gbp'];
                    $tempItemData['ProcessID'] = $ProcessID;
                    $tempItemData['AccountID'] = $AccountID;

                    TempUsageDetail::insert($tempItemData);

                }else{
                    Log::error($lineno . ' line number skipped.');
                }
            }
            $lineno++;

        }
        Log::error(' prc_insertTempCDR start');
        DB::connection('sqlsrv2')->statement("CALL prc_insertTempCDR('" . $ProcessID . "')");
        Log::error('prc_insertTempCDR end');
        $result = DB::connection('sqlsrv2')->select("CALL prc_start_end_time('" . $ProcessID . "')");
        Log::info(print_r($result,true));
        DB::connection('sqlsrvcdrazure')->beginTransaction();
        Log::error(' prc_insertCDR start');
        DB::connection('sqlsrvcdrazure')->statement("CALL prc_insertCDR('" . $ProcessID . "')");
        Log::error(' prc_insertCDR end');
        DB::connection('sqlsrvcdrazure')->commit();
        TempUsageDetail::where(["processId" => $ProcessID])->delete();
        Log::error(print_r($error,true));
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
        ];
    }



}
