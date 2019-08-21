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

    /* not in use*/
    public static function GenerateDailySummary($CompanyID,$ProcessID,$TimeZone){
        $BillingTimeZone = CompanySetting::getKeyVal($CompanyID,'SalesTimeZone');
        $BillingTimeZone = ($BillingTimeZone == 'Invalid Key') ? 'GMT' : $BillingTimeZone;
        $offset = get_timezone_offset($BillingTimeZone,$TimeZone);
        Log::error(' offset == '.$offset);

        $query =  "CALL prc_insertDailyData('" . $ProcessID . "','" .$offset. "')";
        Log::error($query);
        DB::connection('sqlsrv2')->statement($query);
    }

    /**
     * @param $CompanyID
     * @param $ProcessID
     * @param $CompanyGatewayID
     * @param $RateCDR
     * @param $RateFormat  - Prefix or ChargeCode(not in use at the moment, only used in cdr upload, ex. 2Circle)
     * @param $temptableName
     * @param string $NameFormat -- AuthenticationRule : AccountName,AccountNumber,CLI,IP etc default blank (only used for cdr upload)
     * @param string $RateMethod -- CurrentRate(Rate setup against account(CustomerRate)) , SpecifyRate  (only used for cdr upload when ReRating)
     * @param int $Rate
     * @param int $OutboundTableID  -- Outbound RateTableID  (only used for cdr upload when ReRating)
     * @param int $InboundTableID   -- Inbound RateTableID    (only used for cdr upload when ReRating)
     * @param int $Accounts         -- ReRate only Selected Account (when ReRating) Can be set from Gateway option
     * @return array
     */
    public static function ProcessCDR($CompanyID,$ProcessID,$CompanyGatewayID,$RateCDR,$RateFormat,$temptableName,$NameFormat='',$RateMethod='CurrentRate',$Rate=0,$OutboundTableID=0,$InboundTableID=0,$Accounts=0){
        $skiped_account_data =array();
        Log::error('start CALL  prc_ProcesssCDR( ' . $CompanyID . "," . $CompanyGatewayID .",".$ProcessID.",'".$temptableName."',$RateCDR,$RateFormat,'".$NameFormat."','".$RateMethod."','".$Rate."','".$OutboundTableID."','".$InboundTableID."','".$Accounts."')");
        $skiped_account = DB::connection('sqlsrv2')->select('CALL  prc_ProcesssCDR( ' . $CompanyID . "," . $CompanyGatewayID .",".$ProcessID.",'".$temptableName."',$RateCDR,$RateFormat,'".$NameFormat."','".$RateMethod."','".$Rate."','".$OutboundTableID."','".$InboundTableID."','".$Accounts."')");
        Log::error('end CALL  prc_ProcesssCDR( ' . $CompanyID . "," . $CompanyGatewayID .",".$ProcessID.",'".$temptableName."',$RateCDR,$RateFormat,'".$NameFormat."','".$RateMethod."','".$Rate."','".$OutboundTableID."','".$InboundTableID."','".$Accounts."')");
        foreach($skiped_account as $skiped_account_row){
            $skiped_account_data[]  = $skiped_account_row->Message;
        }
        return $skiped_account_data;

    }

    public static function ResellerProcessCDR($CompanyID,$ProcessID,$CompanyGatewayID,$RateCDR,$RateFormat,$temptableName,$NameFormat='',$RateMethod='CurrentRate',$Rate=0,$OutboundTableID=0,$InboundTableID=0,$Accounts=0){
        $skiped_account_data =array();
        Log::error('start CALL  prc_reseller_ProcesssCDR( ' . $CompanyID . "," . $CompanyGatewayID .",".$ProcessID.",'".$temptableName."',$RateCDR,$RateFormat,'".$NameFormat."','".$RateMethod."','".$Rate."','".$OutboundTableID."','".$InboundTableID."','".$Accounts."')");
        $skiped_account = DB::connection('sqlsrv2')->select('CALL  prc_reseller_ProcesssCDR( ' . $CompanyID . "," . $CompanyGatewayID .",".$ProcessID.",'".$temptableName."',$RateCDR,$RateFormat,'".$NameFormat."','".$RateMethod."','".$Rate."','".$OutboundTableID."','".$InboundTableID."','".$Accounts."')");
        Log::error('end CALL  prc_reseller_ProcesssCDR( ' . $CompanyID . "," . $CompanyGatewayID .",".$ProcessID.",'".$temptableName."',$RateCDR,$RateFormat,'".$NameFormat."','".$RateMethod."','".$Rate."','".$OutboundTableID."','".$InboundTableID."','".$Accounts."')");
        foreach($skiped_account as $skiped_account_row){
            $skiped_account_data[]  = $skiped_account_row->Message;
        }
        return $skiped_account_data;

    }

    /**not in use*/
    public static function RateCDR($CompanyID,$ProcessID,$temptableName,$CompanyGatewayID){
        $CompanyGateway = CompanyGateway::find($CompanyGatewayID);
        //$TempUsageDetails = TempUsageDetail::where(array('ProcessID'=>$ProcessID))->whereNotNull('AccountID')->where('trunk','!=','other')->groupBy('AccountID','trunk')->select(array('trunk','AccountID'))->get();
        $TempUsageDetails = DB::connection('sqlsrvcdr')->table($temptableName)->where(array('ProcessID'=>$ProcessID))->whereNotNull('AccountID')->where('trunk','!=','other')->groupBy('AccountID','trunk')->select(array('trunk','AccountID'))->get();
        $skiped_account_data = array();

        //@TODO: create new procedure to fix Rerate even if account or trunk not setup and rerating is on.
        foreach($TempUsageDetails as $TempUsageDetail){
            $TrunkID = DB::table('tblTrunk')->where(array('trunk'=>$TempUsageDetail->trunk))->pluck('TrunkID');
            if($TrunkID>0) {
                $rarateaccount = "CALL  prc_getCustomerCliRateByAccount('" . $CompanyID . "','" . $TempUsageDetail->AccountID . "','" . $TrunkID . "','" . $ProcessID . "','".$temptableName."')";
                $CustomerCliRateByAccount = DataTableSql::of($rarateaccount)->getProcResult(array('CustomerRates','CustomerCliRate'));
                $AccountRates = $CustomerCliRateByAccount['data']['CustomerCliRate'];
                //$AccountRates = DB::select($rarateaccount);
                Log::error("rarateaccount query = $rarateaccount");
                foreach($AccountRates as $AccountRate){
                    $TempRateLogdata = array();
                    $TempRateLogdata['CompanyID'] = $CompanyID;
                    $TempRateLogdata['CompanyGatewayID'] = $CompanyGatewayID;
                    $TempRateLogdata['MessageType'] = 2;
                    $TempRateLogdata['RateDate'] = date("Y-m-d");
                    $skiped_account_data[] = $TempRateLogdata['Message'] = "Account: ".$AccountRate->AccountName." - Trunk: ".$AccountRate->trunk." - Unable to Rerate number ".$AccountRate->area_prefix." - No Matching prefix found";
                    if(DB::table('tblTempRateLog')->where($TempRateLogdata)->count() == 0){
                        $TempRateLogdata['created_at'] = date("Y-m-d H:i:s");
                        $TempRateLogdata['SentStatus'] = 0;
                        DB::table('tblTempRateLog')->insert($TempRateLogdata);
                    }
                }
            }else{
                Log::error("rarateaccount query = $TempUsageDetail->trunk");
            }
        }
        // Update cost = 0 where AccountID not set and Trunk is not set.
        DB::connection('sqlsrvcdr')->table($temptableName)->where(array('ProcessID'=>$ProcessID))->whereNull('AccountID')->update(["cost" => 0 ]);
        DB::connection('sqlsrvcdr')->table($temptableName)->where(array('ProcessID'=>$ProcessID))->where('trunk','Other')->update(["cost" => 0 ]);

        $FailedAccounts = DB::connection('sqlsrvcdr')->table($temptableName)->where(array('ProcessID'=>$ProcessID))->whereNull('AccountID')->groupBy('GatewayAccountID')->select(array('GatewayAccountID'))->get();
        foreach($FailedAccounts as $FailedAccount){
            $TempRateLogdata = array();
            $TempRateLogdata['CompanyID'] = $CompanyID;
            $TempRateLogdata['CompanyGatewayID'] = $CompanyGatewayID;
            $TempRateLogdata['MessageType'] = 1;
            $TempRateLogdata['RateDate'] = date("Y-m-d");
            $skiped_account_data[] = $TempRateLogdata['Message'] =  "Account: ".$FailedAccount->GatewayAccountID." - Gateway: ".$CompanyGateway->Title." - Doesn't exist in NEON";
            if(DB::table('tblTempRateLog')->where($TempRateLogdata)->count() == 0){
                $TempRateLogdata['created_at'] = date("Y-m-d H:i:s");
                $TempRateLogdata['SentStatus'] = 0;
                DB::table('tblTempRateLog')->insert($TempRateLogdata);
            }
        }

        /**
         * IF PBX Gateway
         * Incomming CDR Rerate
         */
        $inbound_errors = TempUsageDetail::inbound_rerate($CompanyID,$ProcessID,$temptableName);
        if(count($inbound_errors) > 0){
            foreach($inbound_errors as $inbound_errors_row) {
                $TempRateLogdata = array();
                $TempRateLogdata['CompanyID'] = $CompanyID;
                $TempRateLogdata['CompanyGatewayID'] = $CompanyGatewayID;
                $TempRateLogdata['MessageType'] = 3;
                $TempRateLogdata['RateDate'] = date("Y-m-d");
                $skiped_account_data[] = $TempRateLogdata['Message'] = $inbound_errors_row;
                if(DB::table('tblTempRateLog')->where($TempRateLogdata)->count() == 0){
                    $TempRateLogdata['created_at'] = date("Y-m-d H:i:s");
                    $TempRateLogdata['SentStatus'] = 0;
                    DB::table('tblTempRateLog')->insert($TempRateLogdata);
                }
            }
        }

        return $skiped_account_data;
    }
    public static function GenerateLogAndSend($CompanyID,$CompanyGatewayID,$cronsetting,$skiped_account_data,$JobTitle){

        $Messages = DB::table('tblTempRateLog')->where(array(
            'CompanyID' => $CompanyID,
            'CompanyGatewayID' => $CompanyGatewayID,
            'SentStatus' => 0
        ))
            ->where('RateDate', '<', date("Y-m-d"))
            ->where('MessageType', '<>', 4)
            ->orderby('MessageType')->distinct()->get(['Message','MessageType']);
        $error_msg = array();

        $PrevMessageType=0;
        foreach ($Messages as $Messagesrow) {
            if($PrevMessageType != $Messagesrow->MessageType){
                $PrevMessageType = $Messagesrow->MessageType;
                if($Messagesrow->MessageType == 1){
                    $error_msg[] = '<b>Below Accounts Doesn\'t exist in NEON</b><br/>';
                }elseif($Messagesrow->MessageType == 2){
                    $error_msg[] = '<br/><b>Outbound Rerate Errors</b><br/>';
                }elseif($Messagesrow->MessageType == 3){
                    $error_msg[] = '<br/><b>Inbound Rerate Errors</b><br/>';
                }
            }

            $error_msg[] = $Messagesrow->Message;

        }
        $ReRateEmail = Notification::getNotificationMail(['CompanyID'=>$CompanyID,'NotificationType'=>Notification::ReRate]);
        $ReRateEmail = empty($ReRateEmail)?$cronsetting['ErrorEmail']:$ReRateEmail;
        $CompanyGatewayName = CompanyGateway::where(array('Status'=>1,'CompanyGatewayID'=>$CompanyGatewayID))->pluck('Title');
        if (!empty($ReRateEmail) && !empty($error_msg)) {
            $error_msg = array_merge(array('<br>

Please check below error messages while re-rating cdrs.

<br>'),$error_msg);
            $emaildata['CompanyID'] = $CompanyID;
            $emaildata['EmailTo'] = explode(',',$ReRateEmail);
            $emaildata['EmailToName'] = '';
            $emaildata['Message'] = implode('<br>', $error_msg);
            $emaildata['Subject'] = $CompanyGatewayName . ' CDR Rate Log ';
            $result = Helper::sendMail('emails.usagelog', $emaildata);
            if ($result['status'] == 1) {
                DB::table('tblTempRateLog')->where(array(
                    'CompanyID' => $CompanyID,
                    'CompanyGatewayID' => $CompanyGatewayID,
                    'SentStatus' => 0
                ))->where('RateDate', '<', date("Y-m-d"))
                    ->where('MessageType', '<>', 4)->update(array('SentStatus' => 1));
            }
        }
    }

    /**
     * For PBX Gateway
     * for is_inbound = 1 it will rerate based on Inbound RateTAble assign on Account.
     * Rerate Inbound CDRs
     */
    /**not in use*/
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

    public static function check_call_type($userfield,$cc_type,$pincode){

        $is_inbound = $is_outbound = $is_failed= false;


        //imedia only outbound. 0 = outbound and 1 = inbound
        if(isset($userfield) && (strpos($userfield,"inbound") !== false  || $userfield ==="1") ) {
            $is_inbound = true;
        }
        if(isset($userfield) && (strpos($userfield,"outbound") !== false || $userfield ==="0")) {
            $is_outbound = true;
        }
        /** if user field is blocked call any reason make duration zero */
        if(isset($userfield) && strpos($userfield,"blocked") !== false ) {
            $is_failed = true;
        }
        /**
        where cc_type outnocharge and pin code is not blank
        and bill sec > 0  and userfiled contains OUTBOUND

        Failed Call or Ignore calls
         */
        if(isset($userfield) && strpos($userfield,"outbound") !== false && strpos($cc_type,"outnocharge") !== false && !empty($pincode) ) {
            $is_failed = true;
        }
        if($is_failed){
            return 'failed';
        }else if($is_inbound && $is_outbound ){
            return 'both';
        }else if($is_inbound){
            return 'inbound';
        }else if($is_outbound){
            return 'outbound';
        }else if(empty($userfield) ) {
            return 'none';
        }
    }


    public static function applyDiscountPlan(){
        $today = date('Y-m-d');
        $todaytime = date('Y-m-d H:i:s');
        $Accounts = DB::table('tblAccountDiscountPlan')->where('EndDate','<=',$today)
            ->get(['AccountID','DiscountPlanID','ServiceID','EndDate','Type','AccountSubscriptionID','AccountName','AccountCLI','SubscriptionDiscountPlanID']);
        foreach($Accounts as $Account){
            $ServiceID = $Account->ServiceID;
            $Manualcount = AccountBilling::where(['AccountID'=>$Account->AccountID,'BillingCycleType'=>'manual'])->count();
            $AccountNextBilling = AccountNextBilling::getBilling($Account->AccountID, $ServiceID);
            $AccountBilling = AccountBilling::where(['AccountID' => $Account->AccountID, 'ServiceID' => 0])->first();
            $AccountServiceBilling = AccountBilling::where(['AccountID' => $Account->AccountID, 'ServiceID' => $ServiceID])->first();
            if (!empty($AccountNextBilling)) {
                $BillingCycleType = $AccountNextBilling->BillingCycleType;
                $BillingCycleValue = $AccountNextBilling->BillingCycleValue;
            } else if (!empty($AccountServiceBilling) && count($AccountServiceBilling)) {
                $BillingCycleType = $AccountServiceBilling->BillingCycleType;
                $BillingCycleValue = $AccountServiceBilling->BillingCycleValue;
            } else if (!empty($AccountBilling) && count($AccountBilling)) {
                $BillingCycleType = $AccountBilling->BillingCycleType;
                $BillingCycleValue = $AccountBilling->BillingCycleValue;
            }
            if($Manualcount == 0 && !empty($BillingCycleType)) {
                $days = getBillingDay(strtotime($Account->EndDate), $BillingCycleType, $BillingCycleValue); // monthly : 30 or 31 days
                $NextInvoiceDate = next_billing_date($BillingCycleType, $BillingCycleValue, strtotime($Account->EndDate));
                log::info('next invoice date');
                log::info($NextInvoiceDate);
                $getdaysdiff = getdaysdiff($NextInvoiceDate, $today); //
                log::info('getdaysdiff');
                log::info($getdaysdiff);
                $DayDiff = $getdaysdiff > 0 ? intval($getdaysdiff) : 0;
                $AccountSubscriptionID = $Account->AccountSubscriptionID;
                $AccountName=empty($Account->AccountName) ? '' : $Account->AccountName;
                $AccountCLI=empty($Account->AccountCLI) ? '' : $Account->AccountCLI;
                $SubscriptionDiscountPlanID=empty($Account->SubscriptionDiscountPlanID) ? 0 : $Account->SubscriptionDiscountPlanID;
                // Apply new fresh or reset Discount Plan from 0 UsedSeconds
                // if apply from 15th in between month . billing cycle thresold will be half. ie 1000 to 500
                Log::info("call prc_setAccountDiscountPlan ($Account->AccountID,$Account->DiscountPlanID,$Account->Type,$days,$DayDiff,'RMScheduler',$todaytime,$ServiceID,$AccountSubscriptionID,$AccountName,$AccountCLI,$SubscriptionDiscountPlanID)");
                DB::select('call prc_setAccountDiscountPlan(?,?,?,?,?,?,?,?,?,?,?,?)', array($Account->AccountID, intval($Account->DiscountPlanID), intval($Account->Type), $days, $DayDiff, 'RMScheduler', $todaytime, $ServiceID,$AccountSubscriptionID,$AccountName,$AccountCLI,$SubscriptionDiscountPlanID));
            }else{
                Log::info("No biiling setup");
            }

        }

    }

    public static function PostProcessCDR($CompanyID,$ProcessID){
        $UsageHeaders = DB::connection('sqlsrvcdr')->select('call prc_PostProcessCDR('.intval($CompanyID).')');
        $ProcessIDs = array();
        Alert::CallMonitorAlert($CompanyID,$ProcessID);
        foreach($UsageHeaders as $UsageHeader){
            $ProcessIDs[] =  $UsageHeader->ProcessID;
        }
        TempUsageDownloadLog::whereIn('ProcessID',$ProcessIDs)->update(array('PostProcessStatus'=>1));
    }

    public static function AutoAddIPLog($CompanyID,$CompanyGatewayID){

        $Messages = DB::table('tblTempRateLog')->where(array(
            'CompanyID' => $CompanyID,
            'CompanyGatewayID' => $CompanyGatewayID,
            'SentStatus' => 0,
            'MessageType' => 4,
        ))
            ->where('RateDate', '<', date("Y-m-d"))
            ->orderby('MessageType')->distinct()->get(['Message','MessageType']);
        $error_msg = array();
        $header_message = '';
        foreach ($Messages as $Messagesrow) {
            if($header_message == '') {
                $header_message = '<br/><b>New IP Added</b><br/>';
                $error_msg[] = $header_message;
            }
            $error_msg[] = $Messagesrow->Message;
        }
        $IPEmail = Notification::getNotificationMail(['CompanyID'=>$CompanyID,'NotificationType'=>Notification::AutoAddIP]);
        //$IPEmail = empty($IPEmail)?$cronsetting['ErrorEmail']:$ReRateEmail;
        $CompanyGatewayName = CompanyGateway::where(array('Status'=>1,'CompanyGatewayID'=>$CompanyGatewayID))->pluck('Title');
        if (!empty($IPEmail) && !empty($error_msg)) {
            $error_msg = array_merge(array('<br>

Please check below ip auto added.

<br>'),$error_msg);
            $emaildata['CompanyID'] = $CompanyID;
            $emaildata['EmailTo'] = explode(',',$IPEmail);
            $emaildata['EmailToName'] = '';
            $emaildata['Message'] = implode('<br>', $error_msg);
            $emaildata['Subject'] = $CompanyGatewayName . ' New IP Added ';
            $result = Helper::sendMail('emails.usagelog', $emaildata);
            if ($result['status'] == 1) {
                DB::table('tblTempRateLog')->where(array(
                    'CompanyID' => $CompanyID,
                    'CompanyGatewayID' => $CompanyGatewayID,
                    'SentStatus' => 0,
                    'MessageType' => 4,
                ))->where('RateDate', '<', date("Y-m-d"))->update(array('SentStatus' => 1));
            }
        }
    }

    public static function update_cost_with_margin($RateMethod,$ReRateMargin,$temptableName,$ProcessID) {

        if($RateMethod == UsageDetail::RATE_METHOD_VALUE_AGAINST_COST) {

            if (!empty($ReRateMargin)) {

                $ReRateMargin = trim($ReRateMargin);

                if (strpos($ReRateMargin, "p") !== FALSE) {

                    //$sql = "UPDATE `" . $temptableName . "` SET cost  = cost +  (cost * REPLACE('" . $ReRateMargin . "','p','')/100) WHERE ProcessID = '" . $ProcessID . "';"; // Note: cost + requested by imedia to remove
                    $sql = "UPDATE `" . $temptableName . "` SET cost  = (cost * REPLACE('" . $ReRateMargin . "','p','')/100) WHERE ProcessID = '" . $ProcessID . "';";
                    DB::connection('sqlsrvcdr')->statement($sql);
                    return true;

                } else {

                    $sql = "UPDATE `" . $temptableName . "` SET cost  = " . $ReRateMargin . " WHERE ProcessID = '" . $ProcessID . "';";
                    DB::connection('sqlsrvcdr')->statement($sql);
                    return true;

                }
            }
        }
        return false;
    }


    // set field base on authentication rule applied in gateway
    public static function ApplyGatewayAuthenticationRule($NameFormat,&$data , $AuthenticationValue , $spitby='-') {

        switch ($NameFormat){
            case  'NAMENUB':
                $_AuthenticationValue = explode($spitby,$AuthenticationValue);
                $data['AccountName']    =  $_AuthenticationValue[0];
                $data['AccountNumber']  =  $_AuthenticationValue[1];
                break;
            case  'NUBNAME':
                $_AuthenticationValue = explode($spitby,$AuthenticationValue);
                $data['AccountNumber']  =  $_AuthenticationValue[0];
                $data['AccountName']    =  $_AuthenticationValue[1];
                break;
            case  'NAME':
                $data['AccountName'] =  $AuthenticationValue;
                break;
            case  'NUB':
                $data['AccountNumber'] =  $AuthenticationValue;
                break;
            case  'IP':
                $data['AccountIP'] =  $AuthenticationValue;
                break;
            case  'CLI':
                $data['AccountCLI'] =  $AuthenticationValue;
                break;
            case  'Other':
                $data['AccountName'] =  $AuthenticationValue;
                break;
        }

    }
}
