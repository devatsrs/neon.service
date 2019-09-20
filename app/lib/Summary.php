<?php
namespace App\Lib;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Schema;

class Summary extends \Eloquent {
    public static function generateSummary($CompanyID,$today,$cronsetting=array(),$CronJob=array()){

        $message = array();

        if($today == 1){
            $UniqueID = self::CreateTempTable($CompanyID,0,date("Y-m-d"),'Live');
            if(!empty($CronJob)){
                CompanyGateway::updateProcessID($CronJob,$UniqueID);
            }

            Log::error("CALL prc_updateLiveTables($CompanyID,$UniqueID)");
            DB::connection('neon_report')->statement("CALL prc_updateLiveTables(?,?)",array($CompanyID,$UniqueID));

            $query = "call prc_generateSummaryLive($CompanyID,'" . date("Y-m-d") . "','" . date("Y-m-d") . "','".$UniqueID."')";
            Log::info($query);
            $error_message = DB::connection('neon_report')->select($query);
            if(count($error_message)){
                throw  new \Exception($error_message[0]->Message);
            }
        }else {

            if(isset($cronsetting['StartDate']) && !empty($cronsetting['StartDate'])){
                $startdate = date("Y-m-d", strtotime($cronsetting['StartDate']));
                $enddate = date("Y-m-d", strtotime($cronsetting['EndDate']));
            }else {
                $startdate = date("Y-m-d", strtotime(UsageHeader::getStartHeaderDate($CompanyID)));
                $enddate = date("Y-m-d", strtotime("-1 Day"));
            }
            self::markFinalSummary($CompanyID, $startdate);
            $start = $startdate;
            while ($start <= $enddate && $start < date("Y-m-d")) {

                $start_summary = $start;
                $end_summary = $start = date('Y-m-d', strtotime('+1 day', strtotime($start)));
                if ($end_summary > $enddate) {
                    $end_summary = $enddate;
                }
                try {
                    $UniqueID = self::CreateTempTable($CompanyID,0,$start_summary);
                    if(!empty($CronJob)){
                        CompanyGateway::updateProcessID($CronJob,$UniqueID);
                    }
                    $query = "call fnGetUsageForSummary($CompanyID,'" . $start_summary . "','" . $start_summary . "','".$UniqueID."')";
                    DB::connection('neon_report')->select($query);
                    $query = "call fnGetVendorUsageForSummary($CompanyID,'" . $start_summary . "','" . $start_summary . "','".$UniqueID."')";
                    DB::connection('neon_report')->select($query);
                    $query = "call prc_generateSummary($CompanyID,'" . $start_summary . "','" . $start_summary . "','".$UniqueID."')";
                    Log::info($query);
                    $error_message = DB::connection('neon_report')->select($query);

                    $query = "call prc_generateVendorSummary($CompanyID,'" . $start_summary . "','" . $start_summary . "','".$UniqueID."')";
                    Log::info($query);
                    $error_message2 = DB::connection('neon_report')->select($query);

                    if(count($error_message)){
                        throw  new \Exception($error_message[0]->Message);
                    }
                    if(count($error_message2)){
                        throw  new \Exception($error_message2[0]->Message);
                    }


                    $message['message'][] = $start_summary.' Generated Successfully';
                } catch (\Exception $e) {
                    Log::error($e);
                    $message['error'][] = $e->getMessage();
                    Log::info($start_summary);
                }
            }
            try {
                DB::connection('neon_report')->table('tblUsageSummaryDayLive')->truncate();
                DB::connection('neon_report')->table('tblUsageSummaryHourLive')->truncate();
                DB::connection('neon_report')->table('tblVendorSummaryDayLive')->truncate();
                DB::connection('neon_report')->table('tblVendorSummaryHourLive')->truncate();
            } catch (\Exception $e) {
                Log::error($e);
            }
            self::deleteOldTempTable($CompanyID,'customer');
            self::deleteOldTempTable($CompanyID,'vendor');
        }
        return $message;
    }

    public static function markFinalSummary($CompanyID,$startdate){

        /*$query = "call prc_markSummaryFinal($CompanyID,'".$startdate."')";
        Log::info($query);
        DB::connection('neon_report')->statement($query);*/
    }
    public static function generateVendorSummary($CompanyID,$today,$CronJob=array()){
        if($today == 1){
            $UniqueID = self::CreateTempTable($CompanyID,0,date("Y-m-d"),'Live');
            $UniquePID=$UniqueID.'vendor';
            if(!empty($CronJob)){
                CompanyGateway::updateProcessID($CronJob,$UniquePID);
            }

            $query = "call prc_generateVendorSummaryLive($CompanyID,'" . date("Y-m-d") . "','" . date("Y-m-d") . "','".$UniqueID."')";
            Log::info($query);
            $error_message = DB::connection('neon_report')->select($query);
            if(count($error_message)){
                throw  new \Exception($error_message[0]->Message);
            }
        }else {

           /* $startdate = date("Y-m-d", strtotime(UsageHeader::getVendorStartHeaderDate($CompanyID)));
            $enddate = date("Y-m-d", strtotime("-1 Day"));
            self::markFinalSummary($CompanyID, $startdate);
            $start = $startdate;
            while ($start <= $enddate) {

                $start_summary = $start;
                $end_summary = $start = date('Y-m-d', strtotime('+1 day', strtotime($start)));
                if ($end_summary > $enddate) {
                    $end_summary = $enddate;
                }
                try {
                    $UniqueID = self::CreateTempTable($CompanyID,0,$start_summary);
                    $query = "call prc_generateVendorSummary($CompanyID,'" . $start_summary . "','" . $start_summary . "','".$UniqueID."')";
                    Log::info($query);
                    $error_message = DB::connection('neon_report')->select($query);
                    if(count($error_message)){
                        throw  new \Exception($error_message[0]->Message);
                    }
                } catch (\Exception $e) {
                    Log::error($e);
                    Log::info($start_summary);
                }
            }
            //self::deleteOldTempTable($CompanyID,'vendor');*/
        }
    }

    public static function CreateTempTable($CompanyID,$CompanyGatewayID=0,$date,$extra_prefix=''){

        $UniqueID = $CompanyID;

        if(!empty($CompanyGatewayID)){
            $UniqueID = $CompanyID.$CompanyGatewayID;
        }

        if(!empty($UniqueID)) {
            $tag = '"RateCDR":"1"';
            $RateCDR = CompanyGateway::where(array('CompanyID'=>$CompanyID,'Status'=>1))->where('Settings','LIKE', '%'.$tag.'%')->count();
            $UniqueID .= date('Ymd',strtotime($date));
            $UniqueID .=$extra_prefix;

            $temp_table1 = 'tmp_tblUsageDetailsReport_'.$UniqueID;
            $temp_table2 = 'tmp_tblVendorUsageDetailsReport_'.$UniqueID;

            self::dropTableForNewColumn($temp_table1);
            self::dropTableForNewColumn($temp_table2);
            $sql_create_table = 'CREATE TABLE IF NOT EXISTS `'  . $temp_table1 . '` (
                                    `UsageDetailsReportID` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
                                    `UsageDetailID` BIGINT(20) UNSIGNED NULL DEFAULT NULL,
                                    `AccountID` INT(11) NULL DEFAULT NULL,
                                    `VAccountID` INT(11) NULL DEFAULT NULL,
                                    `CompanyID` INT(11) NULL DEFAULT NULL,
                                    `CompanyGatewayID` INT(11) NULL DEFAULT NULL,
                                    `GatewayAccountPKID` INT(11) NULL DEFAULT NULL,
                                    `GatewayVAccountPKID` INT(11) NULL DEFAULT NULL,
                                    `ServiceID` INT(11) NULL DEFAULT NULL,
                                    `connect_time` TIME NULL DEFAULT NULL,
                                    `connect_date` DATE NULL DEFAULT NULL,
                                    `billed_duration` INT(11) NULL DEFAULT NULL,
                                    `area_prefix` VARCHAR(50) NULL DEFAULT NULL ,
                                    `cost` DECIMAL(18,6) NULL DEFAULT NULL,
                                    `buying_cost` DECIMAL(18,6) NULL DEFAULT NULL,
                                    `duration` INT(11) NULL DEFAULT NULL,
                                    `trunk` VARCHAR(50) NULL DEFAULT NULL ,
                                    `call_status` TINYINT(4) NULL DEFAULT NULL,
                                    `call_status_v` TINYINT(4) NULL DEFAULT NULL,
                                    `disposition` VARCHAR(50) NULL DEFAULT NULL,
                                    `userfield` VARCHAR(255) NULL DEFAULT NULL ,
                                    `pincode` VARCHAR(50) NULL DEFAULT NULL ,
	                                `extension` VARCHAR(50) NULL DEFAULT NULL ,
                                    `ID` BIGINT(20) UNSIGNED NULL DEFAULT NULL,
                                    PRIMARY KEY (`UsageDetailsReportID`),
                                    UNIQUE INDEX `UK` (`UsageDetailID`, `call_status`),
                                    INDEX `temp_connect_time` (`connect_time`, `connect_date`),
                                    INDEX `IX_CompanyID` (`CompanyID`),
                                    INDEX `IX_UsageDetailID` (`UsageDetailID`),
                                    INDEX `IX_GCID` (`CompanyGatewayID`,`ID`)
                                )
                                ENGINE=InnoDB ; ';
            DB::connection('neon_report')->statement($sql_create_table);


            Log::error($temp_table1 . ' done ');

            $sql_create_table = 'CREATE TABLE IF NOT EXISTS `'  . $temp_table2 . '` (
                                   	`VendorUsageDetailsReportID` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
                                    `VendorCDRID` BIGINT(20) UNSIGNED NULL DEFAULT NULL,
                                    `VAccountID` INT(11) NULL DEFAULT NULL,
                                    `AccountID` INT(11) NULL DEFAULT NULL,
                                    `CompanyID` INT(11) NULL DEFAULT NULL,
                                    `CompanyGatewayID` INT(11) NULL DEFAULT NULL,
                                    `GatewayAccountPKID` INT(11) NULL DEFAULT NULL,
                                    `GatewayVAccountPKID` INT(11) NULL DEFAULT NULL,
                                    `ServiceID` INT(11) NULL DEFAULT NULL,
                                    `connect_time` TIME NULL DEFAULT NULL,
                                    `connect_date` DATE NULL DEFAULT NULL,
                                    `billed_duration` INT(11) NULL DEFAULT NULL,
                                    `duration` INT(11) NULL DEFAULT NULL,
                                    `selling_cost` DECIMAL(18,6) NULL DEFAULT NULL,
                                    `buying_cost` DECIMAL(18,6) NULL DEFAULT NULL,
                                    `trunk` VARCHAR(50) NULL DEFAULT NULL,
                                    `area_prefix` VARCHAR(50) NULL DEFAULT NULL,
                                    `call_status` TINYINT(4) NULL DEFAULT NULL,
                                    `call_status_v` TINYINT(4) NULL DEFAULT NULL,
                                    `ID` BIGINT(20) UNSIGNED NULL DEFAULT NULL,
                                    PRIMARY KEY (`VendorUsageDetailsReportID`),
                                    UNIQUE INDEX `UK` (`VendorCDRID`, `call_status_v`),
                                    INDEX `temp_connect_time` (`connect_time`, `connect_date`),
                                    INDEX `IX_CompanyID` (`CompanyID`),
                                    INDEX `IX_VendorCDRID` (`VendorCDRID`),
                                    INDEX `IX_GCID` (`CompanyGatewayID`,`ID`)
                                )
                                ENGINE=InnoDB ; ';
            DB::connection('neon_report')->statement($sql_create_table);


            Log::error($temp_table2 .' done ');

            //if($RateCDR >0 || empty($extra_prefix)) {
            if(empty($extra_prefix)) {
                Log::error(' DELETE FROM ' . $temp_table1);
                DB::connection('neon_report')->table($temp_table1)->truncate();
                DB::connection('neon_report')->table($temp_table2)->truncate();
            }

            //Log::error($link_table1 . ' done ');

            return $UniqueID;
        }
    }

    public static function deleteOldTempTable($CompanyID,$CS){
        $tables = DB::connection('neon_report')->select('SHOW TABLES');
        $deletedate = date('Ymd',strtotime('-1 day'));
        foreach($tables as $table)
        {
            foreach($table as $Tables_in_db_name=>$tablename) {

                if(strpos($tablename,'tmp_tblUsageDetailsReport_'.$CompanyID) !== false && $CS == 'customer'){
                    if(str_replace(array('tmp_tblUsageDetailsReport_'.$CompanyID,'Live'),'',$tablename)<=$deletedate){
                        Schema::connection('neon_report')->dropIfExists($tablename);

                    }
                }
                if(strpos($tablename,'tmp_tblVendorUsageDetailsReport_'.$CompanyID) !== false && $CS == 'vendor'){
                    if(str_replace(array('tmp_tblVendorUsageDetailsReport_'.$CompanyID,'Live'),'',$tablename)<=$deletedate){
                        Schema::connection('neon_report')->dropIfExists($tablename);
                    }
                }

                if(strpos($tablename,'tblTempCallDetail_1_'.$CompanyID) !== false && $CS == 'customer'){
                    if(str_replace(array('tblTempCallDetail_1_'.$CompanyID,'Live'),'',$tablename)<=$deletedate){
                        Schema::connection('neon_report')->dropIfExists($tablename);

                    }
                }
                if(strpos($tablename,'tblTempCallDetail_2_'.$CompanyID) !== false && $CS == 'vendor'){
                    if(str_replace(array('tblTempCallDetail_2_'.$CompanyID,'Live'),'',$tablename)<=$deletedate){
                        Schema::connection('neon_report')->dropIfExists($tablename);

                    }
                }
            }
        }
    }

    public static function dropTableForNewColumn($tbltempusagedetail_name){
        if(!Schema::connection('neon_report')->hasColumn($tbltempusagedetail_name, 'ID'))  //check whether users table has email column
        {
            Schema::connection('neon_report')->dropIfExists($tbltempusagedetail_name);

        }
    }

}