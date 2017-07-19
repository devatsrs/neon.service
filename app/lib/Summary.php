<?php
namespace App\Lib;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Schema;

class Summary extends \Eloquent {
    public static function generateSummary($CompanyID,$today){


        if($today == 1){
            $UniqueID = self::CreateCustomerTempTable($CompanyID,0,date("Y-m-d"),'Live');
            $query = "call prc_generateSummaryLive($CompanyID,'" . date("Y-m-d") . "','" . date("Y-m-d") . "','".$UniqueID."')";
            Log::info($query);
            $error_message = DB::connection('neon_report')->select($query);
            if(count($error_message)){
                throw  new \Exception($error_message[0]->Message);
            }
        }else {

            $startdate = date("Y-m-d", strtotime(UsageHeader::getStartHeaderDate($CompanyID)));
            $enddate = date("Y-m-d", strtotime("-1 Day"));
            self::deleteOldTempTable($CompanyID,$startdate);
            self::markFinalSummary($CompanyID, $startdate);
            $start = $startdate;
            while ($start <= $enddate) {

                $start_summary = $start;
                $end_summary = $start = date('Y-m-d', strtotime('+1 day', strtotime($start)));
                if ($end_summary > $enddate) {
                    $end_summary = $enddate;
                }
                try {
                    $UniqueID = self::CreateCustomerTempTable($CompanyID,0,$start_summary);
                    $query = "call prc_generateSummary($CompanyID,'" . $start_summary . "','" . $start_summary . "','".$UniqueID."')";
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
        }
    }

    public static function markFinalSummary($CompanyID,$startdate){

        /*$query = "call prc_markSummaryFinal($CompanyID,'".$startdate."')";
        Log::info($query);
        DB::connection('neon_report')->statement($query);*/
    }
    public static function generateVendorSummary($CompanyID,$today){
        if($today == 1){
            $UniqueID = self::CreateVendorTempTable($CompanyID,0,date("Y-m-d"),'Live');
            $query = "call prc_generateVendorSummaryLive($CompanyID,'" . date("Y-m-d") . "','" . date("Y-m-d") . "','".$UniqueID."')";
            Log::info($query);
            $error_message = DB::connection('neon_report')->select($query);
            if(count($error_message)){
                throw  new \Exception($error_message[0]->Message);
            }
        }else {

            $startdate = date("Y-m-d", strtotime(UsageHeader::getVendorStartHeaderDate($CompanyID)));
            $enddate = date("Y-m-d", strtotime("-1 Day"));
            self::deleteOldTempTable($CompanyID,$startdate);
            self::markFinalSummary($CompanyID, $startdate);
            $start = $startdate;
            while ($start <= $enddate) {

                $start_summary = $start;
                $end_summary = $start = date('Y-m-d', strtotime('+1 day', strtotime($start)));
                if ($end_summary > $enddate) {
                    $end_summary = $enddate;
                }
                try {
                    $UniqueID = self::CreateVendorTempTable($CompanyID,0,$start_summary);
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
        }
    }

    public static function CreateCustomerTempTable($CompanyID,$CompanyGatewayID=0,$date,$extra_prefix=''){

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
                                    `duration` INT(11) NULL DEFAULT NULL,
                                    `trunk` VARCHAR(50) NULL DEFAULT NULL ,
                                    `call_status` TINYINT(4) NULL DEFAULT NULL,
                                    `call_status_v` TINYINT(4) NULL DEFAULT NULL,
                                    `disposition` VARCHAR(50) NULL DEFAULT NULL,
                                    `userfield` VARCHAR(255) NULL DEFAULT NULL ,
                                    `pincode` VARCHAR(50) NULL DEFAULT NULL ,
	                                `extension` VARCHAR(50) NULL DEFAULT NULL ,
                                    PRIMARY KEY (`UsageDetailsReportID`),
                                    UNIQUE INDEX `UK` (`UsageDetailID`, `call_status`),
                                    INDEX `temp_connect_time` (`connect_time`, `connect_date`),
                                    INDEX `IX_CompanyID` (`CompanyID`),
                                    INDEX `IX_UsageDetailID` (`UsageDetailID`)
                                )
                                ENGINE=InnoDB ; ';
            DB::connection('neon_report')->statement($sql_create_table);


            Log::error($temp_table1 . ' done ');

            $link_table1 = 'tblTempCallDetail_1_'.$UniqueID;

            $sql_create_table = 'CREATE TABLE IF NOT EXISTS `'  . $link_table1 . '` (
                                    `CallDetailID` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
                                    `GCID` BIGINT(20) UNSIGNED NULL DEFAULT NULL,
                                    `CID` BIGINT(20) NULL DEFAULT NULL,
                                    `VCID` BIGINT(20) NULL DEFAULT NULL,
                                    `UsageHeaderID` INT(11) NULL DEFAULT NULL,
	                                `VendorCDRHeaderID` INT(11) NULL DEFAULT NULL,
                                    `CompanyGatewayID` INT(11) NULL DEFAULT NULL,
                                    `GatewayAccountPKID` INT(11) NULL DEFAULT NULL,
                                    `GatewayVAccountPKID` INT(11) NULL DEFAULT NULL,
                                    `AccountID` INT(11) NULL DEFAULT NULL,
                                    `VAccountID` INT(11) NULL DEFAULT NULL,
                                    `FailCall` TINYINT(4) NULL DEFAULT NULL,
                                    `FailCallV` TINYINT(4) NULL DEFAULT NULL,
                                    PRIMARY KEY (`CallDetailID`),
                                    INDEX `IX_GCID` (`GCID`),
                                    INDEX `IX_CID` (`CID`),
                                    INDEX `IX_VCID` (`VCID`)
                                )
                                ENGINE=InnoDB ; ';
            DB::connection('neon_report')->statement($sql_create_table);
            if($RateCDR >0 || empty($extra_prefix)) {
                Log::error(' DELETE FROM ' . $temp_table1);
                DB::connection('neon_report')->statement(' DELETE FROM ' . $temp_table1);
                DB::connection('neon_report')->statement(' DELETE FROM ' . $link_table1);
            }else{
                Log::error("CALL prc_updateLiveTables($CompanyID,$UniqueID,'Customer')");
                DB::connection('neon_report')->statement("CALL prc_updateLiveTables(?,?,?)",array($CompanyID,$UniqueID,'Customer'));
            }

            Log::error($link_table1 . ' done ');

            return $UniqueID;
        }
    }

    public static function CreateVendorTempTable($CompanyID,$CompanyGatewayID=0,$date,$extra_prefix=''){

        $UniqueID = $CompanyID;

        if(!empty($CompanyGatewayID)){
            $UniqueID = $CompanyID.$CompanyGatewayID;
        }

        if(!empty($UniqueID)) {
            $tag = '"RateCDR":"1"';
            $RateCDR = CompanyGateway::where(array('CompanyID'=>$CompanyID,'Status'=>1))->where('Settings','LIKE', '%'.$tag.'%')->count();
            $UniqueID .= date('Ymd',strtotime($date));
            $UniqueID .=$extra_prefix;


            $temp_table1 = 'tmp_tblVendorUsageDetailsReport_'.$UniqueID;

            $sql_create_table = 'CREATE TABLE IF NOT EXISTS `'  . $temp_table1 . '` (
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
                                    PRIMARY KEY (`VendorUsageDetailsReportID`),
                                    UNIQUE INDEX `UK` (`VendorCDRID`, `call_status_v`),
                                    INDEX `temp_connect_time` (`connect_time`, `connect_date`),
                                    INDEX `IX_CompanyID` (`CompanyID`),
                                    INDEX `IX_VendorCDRID` (`VendorCDRID`)
                                )
                                ENGINE=InnoDB ; ';
            DB::connection('neon_report')->statement($sql_create_table);


            Log::error($temp_table1 .' done ');

            $link_table1 = 'tblTempCallDetail_2_'.$UniqueID;

            $sql_create_table = 'CREATE TABLE IF NOT EXISTS `'  . $link_table1 . '` (
                                    `CallDetailID` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
                                    `GCID` BIGINT(20) UNSIGNED NULL DEFAULT NULL,
                                    `CID` BIGINT(20) NULL DEFAULT NULL,
                                    `VCID` BIGINT(20) NULL DEFAULT NULL,
                                    `UsageHeaderID` INT(11) NULL DEFAULT NULL,
	                                `VendorCDRHeaderID` INT(11) NULL DEFAULT NULL,
                                    `CompanyGatewayID` INT(11) NULL DEFAULT NULL,
                                    `GatewayAccountPKID` INT(11) NULL DEFAULT NULL,
                                    `GatewayVAccountPKID` INT(11) NULL DEFAULT NULL,
                                    `AccountID` INT(11) NULL DEFAULT NULL,
                                    `VAccountID` INT(11) NULL DEFAULT NULL,
                                    `FailCall` TINYINT(4) NULL DEFAULT NULL,
                                    `FailCallV` TINYINT(4) NULL DEFAULT NULL,
                                    PRIMARY KEY (`CallDetailID`),
                                    INDEX `IX_GCID` (`GCID`),
                                    INDEX `IX_CID` (`CID`),
                                    INDEX `IX_VCID` (`VCID`)
                                )
                                ENGINE=InnoDB ; ';
            DB::connection('neon_report')->statement($sql_create_table);
            if($RateCDR >0 || empty($extra_prefix)) {
                Log::error(' DELETE FROM ' . $temp_table1);
                DB::connection('neon_report')->statement(' DELETE FROM ' . $temp_table1);
                DB::connection('neon_report')->statement(' DELETE FROM ' . $link_table1);
            }else{
                Log::error("CALL prc_updateLiveTables($CompanyID,$UniqueID,'Vendor')");
                DB::connection('neon_report')->statement("CALL prc_updateLiveTables(?,?,?)",array($CompanyID,$UniqueID,'Vendor'));
            }


            Log::error($link_table1 . ' done ');

            return $UniqueID;
        }
    }

    public static function deleteOldTempTable($CompanyID,$deletedate){
        $tables = DB::connection('neon_report')->select('SHOW TABLES');
        $deletedate = date('Ymd',strtotime($deletedate));
        foreach($tables as $table)
        {
            foreach($table as $Tables_in_db_name=>$tablename) {

                if(strpos($tablename,'tmp_tblUsageDetailsReport_'.$CompanyID) !== false){
                    if(str_replace(array('tmp_tblUsageDetailsReport_'.$CompanyID,'Live'),'',$tablename)<$deletedate){
                        Schema::connection('neon_report')->dropIfExists($tablename);

                    }
                }
                if(strpos($tablename,'tmp_tblVendorUsageDetailsReport_'.$CompanyID) !== false){
                    if(str_replace(array('tmp_tblVendorUsageDetailsReport_'.$CompanyID,'Live'),'',$tablename)<$deletedate){
                        Schema::connection('neon_report')->dropIfExists($tablename);
                    }
                }

                if(strpos($tablename,'tblTempCallDetail_1_'.$CompanyID) !== false){
                    if(str_replace(array('tblTempCallDetail_1_'.$CompanyID,'Live'),'',$tablename)<$deletedate){
                        Schema::connection('neon_report')->dropIfExists($tablename);

                    }
                }
                if(strpos($tablename,'tblTempCallDetail_2_'.$CompanyID) !== false){
                    if(str_replace(array('tblTempCallDetail_2_'.$CompanyID,'Live'),'',$tablename)<$deletedate){
                        Schema::connection('neon_report')->dropIfExists($tablename);

                    }
                }
            }
        }
    }

}