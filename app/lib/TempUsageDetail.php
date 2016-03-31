<?php
namespace App\Lib;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class TempUsageDetail extends \Eloquent {
    protected $fillable = [];
    protected $connection = 'sqlsrv2';
    public $timestamps = false; // no created_at and updated_at

    protected $guarded = array('TempUsageDetailID');

    protected $table = 'tblTempUsageDetail';

    protected  $primaryKey = "TempUsageDetailID";

    public static function GenerateDailySummary($CompanyID,$ProcessID,$TimeZone){
        $BillingTimeZone = CompanySetting::getKeyVal($CompanyID,'SalesTimeZone');
        $BillingTimeZone = ($BillingTimeZone == 'Invalid Key') ? 'GMT' : $BillingTimeZone;
        $offset = get_timezone_offset($BillingTimeZone,$TimeZone);
        Log::error(' offset == '.$offset);

        $query =  "CALL prc_insertDailyData('" . $ProcessID . "','" .$offset. "')";
        Log::error($query);
        DB::connection('sqlsrv2')->statement($query);
    }
    public static function ProcessCDR($CompanyID,$ProcessID,$CompanyGatewayID,$RateCDR,$RateFormat,$temptableName){
        $skiped_account_data =array();
        Log::error(' prc_insertGatewayAccount start CompanyGatewayID = '.$CompanyGatewayID . ", '".$temptableName."'" );
        DB::connection('sqlsrv2')->statement("CALL  prc_insertGatewayAccount('" . $ProcessID . "' , '".$temptableName."');" );
        Log::error(' prc_insertGatewayAccount end CompanyGatewayID = '.$CompanyGatewayID . ", '".$temptableName."'" );


        // Update  tblGatewayAccount
        Log::error(' prc_getActiveGatewayAccount start CompanyGatewayID = '.$CompanyGatewayID);
        DB::connection('sqlsrv2')->statement('CALL  prc_getActiveGatewayAccount( ' . $CompanyID . "," . $CompanyGatewayID .",'0','1')"); // Procedure Updated - 05-10-2015
        Log::error(' prc_getActiveGatewayAccount end CompanyGatewayID = '.$CompanyGatewayID);


        /*
		place inside transaction
		Log::error(' prc_setAccountID start CompanyGatewayID = '.$CompanyGatewayID);
        DB::connection('sqlsrv2')->statement('CALL  prc_setAccountID(' . $CompanyID . ")");
        Log::error(' prc_setAccountID end CompanyGatewayID = '.$CompanyGatewayID);
		*/


        if($RateFormat == Company::PREFIX) {
            Log::error(' prc_updatePrefixTrunk start CompanyGatewayID = '.$CompanyGatewayID);
            DB::connection('sqlsrv2')->statement("CALL  prc_updatePrefixTrunk ('" . $CompanyID . "','" . $CompanyGatewayID . "','" . $ProcessID . "' , '".$temptableName."')");
            Log::error(' prc_updatePrefixTrunk end CompanyGatewayID = '.$CompanyGatewayID);
        }


        Log::error(' prc_setAccountIDCDR start CompanyGatewayID = '.$CompanyGatewayID);
        DB::connection('sqlsrv2')->statement("CALL  prc_setAccountIDCDR ('" . $CompanyID . "','" . $ProcessID . "', '".$temptableName."')");
        Log::error(' prc_setAccountIDCDR end CompanyGatewayID = '.$CompanyGatewayID);

        if($RateCDR == 1){
            $skiped_account_data = TempUsageDetail::RateCDR($CompanyID,$ProcessID,$temptableName);
        }else{
            /**
             * IF PBX Gateway
             * Incomming CDR Rerate
             */
            $inbound_errors = TempUsageDetail::inbound_rerate($CompanyID, $ProcessID, $temptableName);
            if (count($inbound_errors) > 0) {
                $skiped_account_data[] = ' <br>Inbound Rerate Errors: <br>' . implode('<br>', $inbound_errors);
            }
        }

        Log::error(' prc_insertTempCDR start');
        //DB::connection('sqlsrv2')->statement("CALL  prc_insertTempCDR('" . $ProcessID . "')");
        Log::error('prc_insertTempCDR end');
        return $skiped_account_data;

    }

    public static function RateCDR($CompanyID,$ProcessID,$temptableName){
        //$TempUsageDetails = TempUsageDetail::where(array('ProcessID'=>$ProcessID))->whereNotNull('AccountID')->where('trunk','!=','other')->groupBy('AccountID','trunk')->select(array('trunk','AccountID'))->get();
        $TempUsageDetails = DB::connection('sqlsrvcdrazure')->table($temptableName)->where(array('ProcessID'=>$ProcessID))->whereNotNull('AccountID')->where('trunk','!=','other')->groupBy('AccountID','trunk')->select(array('trunk','AccountID'))->get();
        $skiped_account_data = array();
        foreach($TempUsageDetails as $TempUsageDetail){
            $TrunkID = DB::table('tblTrunk')->where(array('trunk'=>$TempUsageDetail->trunk))->pluck('TrunkID');
            if($TrunkID>0) {
                $rarateaccount = "CALL  prc_getCustomerCliRateByAccount('" . $CompanyID . "','" . $TempUsageDetail->AccountID . "','" . $TrunkID . "','" . $ProcessID . "','".$temptableName."')";
                $CustomerCliRateByAccount = DataTableSql::of($rarateaccount)->getProcResult(array('CustomerRates','CustomerCliRate'));
                $AccountRates = $CustomerCliRateByAccount['data']['CustomerCliRate'];
                //$AccountRates = DB::select($rarateaccount);
                Log::error("rarateaccount query = $rarateaccount");
                foreach($AccountRates as $AccountRate){
                    $skiped_account_data[] = 'Account :: '.$AccountRate->AccountName.' Trunk ::'.$AccountRate->trunk.' Rate Code ::'.$AccountRate->area_prefix;
                }
            }else{
                Log::error("rarateaccount query = $TempUsageDetail->trunk");
            }
        }
        $FailedAccounts = DB::connection('sqlsrvcdrazure')->table($temptableName)->where(array('ProcessID'=>$ProcessID))->whereNull('AccountID')->groupBy('GatewayAccountID')->select(array('GatewayAccountID'))->get();
        foreach($FailedAccounts as $FailedAccount){
            $skiped_account_data[] = 'Account Not Matched '.$FailedAccount->GatewayAccountID;
        }

        /**
         * IF PBX Gateway
         * Incomming CDR Rerate
         */
        $inbound_errors = TempUsageDetail::inbound_rerate($CompanyID,$ProcessID,$temptableName);
        if(count($inbound_errors) > 0){
            $skiped_account_data[] = ' <br>Inbound Rerate Errors: <br>' . implode('<br>', $inbound_errors);
        }

        return $skiped_account_data;
    }
    public static function GenerateLogAndSend($CompanyID,$CompanyGatewayID,$cronsetting,$skiped_account_data,$JobTitle){
        if(count($skiped_account_data)) {
            $file_name = $CompanyGatewayID.'-'.date('Y-m-d').'.txt';
            $usage_dir = getenv('UPLOAD_PATH') . '/UsageLog/'.$CompanyGatewayID.'/';
            if (!file_exists($usage_dir)) {
                @mkdir($usage_dir, 0777, TRUE);
            }
            $file_content = PHP_EOL.implode("\n\r".PHP_EOL, $skiped_account_data);
            file_put_contents($usage_dir . '/' . $file_name, $file_content,FILE_APPEND);

            $new_filenames = scandir($usage_dir);
            $filenames = array();

            foreach ((array)$new_filenames as $file) {
                if (strpos($file,$CompanyGatewayID) !== false) {
                    $filenames[] = $file;
                }
            }
            if(count($filenames)>1){
                if(!empty($cronsetting['ErrorEmail'])) {
                    $emaildata['CompanyID'] = $CompanyID;
                    $emaildata['EmailTo'] = $cronsetting['ErrorEmail'];
                    $emaildata['EmailToName'] = '';
                    $emaildata['Subject'] = $JobTitle.' Usage Log file with Account and Trunk did not match ';
                    $emaildata['attach'] = $usage_dir.$filenames[0];
                    $result = Helper::sendMail('emails.usagelog', $emaildata);
                    if($result['status'] == 1){
                        @unlink($usage_dir.$filenames[0]);
                    }
                }
            }
        }
    }

    /**
     * For PBX Gateway
     * for is_inbound = 1 it will rerate based on Inbound RateTAble assign on Account.
     * Rerate Inbound CDRs
     */
    public static function inbound_rerate($CompanyID,$processID,$temptableName){

        $response = array();
        Log::info("CALL  prc_update_inbound_call_rate ('" . $CompanyID . "','" . $processID . "', '" . $temptableName . "')");
        $result = DB::connection('sqlsrvcdr')->select("CALL  prc_update_inbound_call_rate ('" . $CompanyID . "','" . $processID . "', '" . $temptableName . "')");
        if(count($result) > 0) {
            foreach ($result as $row ) {
                $response[] =  $row->Message;
            }
        }
        return $response;

    }

    public static function check_call_type($userfield){

        $is_inbound = $is_outbound = false;
        if(isset($userfield) && strpos($userfield,"inbound") !== false ) {
            $is_inbound = true;
        }
        if(isset($userfield) && strpos($userfield,"outbound") !== false ) {
            $is_outbound = true;
        }

        if($is_inbound && $is_outbound ){
            return 'both';
        }else if($is_inbound){
            return 'inbound';
        }else if($is_outbound){
            return 'outbound';
        }else if(empty($userfield) ) {
            return 'none';
        }
    }
}
