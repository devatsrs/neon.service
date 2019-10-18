<?php
namespace App\Lib;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Schema;
use Webpatser\Uuid\Uuid;


class CompanyGateway extends \Eloquent {
	protected $fillable = [];

    protected $guarded = array('CompanyGatewayID');

    protected $table = 'tblCompanyGateway';

    protected  $primaryKey = "CompanyGatewayID";



    public static function checkForeignKeyById($id){
        $hasAccountApprovalList =0;
        if( intval($hasAccountApprovalList) > 0){
            return true;
        }else{
            return false;
        }
    }
    public static function getCompanyGatewayIdList($CompanyID){
        $row = CompanyGateway::where(array('Status'=>1,'CompanyID'=>$CompanyID))->lists('Title', 'CompanyGatewayID');
        if(!empty($row)){
            $row = array(""=> "Select a Gateway")+$row;
        }
        return $row;

    }
    public static function getCompanyGatewayConfig($CompanyGatewayID){
        return CompanyGateway::where(array('Status'=>1,'CompanyGatewayID'=>$CompanyGatewayID))->pluck('Settings');
    }
    public static function getCompanyGatewayID($CompanyID,$gatewayid){
        return CompanyGateway::where(array('GatewayID'=>$gatewayid,'CompanyID'=>$CompanyID))->pluck('CompanyGatewayID');
    }
    public static function getGatewayTimeZone($CompanyGatewayID){
        return CompanyGateway::where(array('CompanyGatewayID'=>$CompanyGatewayID))->pluck('TimeZone');
    }
    public static function getGatewayBillingTimeZone($CompanyGatewayID){
        return CompanyGateway::where(array('CompanyGatewayID'=>$CompanyGatewayID))->pluck('BillingTimeZone');
    }

    public static function getUniqueID($CompanyGatewayID){
        return CompanyGateway::where("CompanyGatewayID",$CompanyGatewayID)->pluck("UniqueID");
    }

    /* Create tblTempUsageDetail Temp table as per UniqueID * */
    public static function CreateIfNotExistCDRTempUsageDetailTable($CompanyID,$CompanyGatewayID,$extra_prefix=''){

        $UniqueID = self::getUniqueID($CompanyGatewayID);

        if( empty($UniqueID)){
            $UniqueID = $CompanyID.$CompanyGatewayID;
            CompanyGateway::where("CompanyGatewayID",$CompanyGatewayID)->update(["UniqueID"=>$UniqueID]);
        }

        if(!empty($UniqueID)) {
            $tbltempusagedetail_name = self::getUsagedetailTablenameByUniqueID($UniqueID);

            Log::error( $tbltempusagedetail_name);
            $tbltempusagedetail_name .=$extra_prefix;

            $temp_tblRetailUsageDetail_TableName = self::getUsagedetailRetailTablename($tbltempusagedetail_name);

            //self::dropTableForNewColumn($tbltempusagedetail_name);
            Schema::connection('sqlsrvcdr')->dropIfExists($tbltempusagedetail_name);
            $sql_create_table = 'CREATE TABLE IF NOT EXISTS `'  . $tbltempusagedetail_name . '` (
                                    `TempUsageDetailID` INT(11) NOT NULL AUTO_INCREMENT,
                                    `CompanyID` INT(11) NULL DEFAULT NULL,
                                    `CompanyGatewayID` INT(11) NULL DEFAULT NULL,
                                    `GatewayAccountPKID` INT(11) NULL DEFAULT NULL,
                                    `GatewayAccountID` VARCHAR(100) NULL DEFAULT NULL ,
                                    `AccountName` VARCHAR(100) NULL DEFAULT NULL ,
                                    `AccountNumber` VARCHAR(100) NULL DEFAULT NULL ,
                                    `AccountCLI` VARCHAR(100) NULL DEFAULT NULL ,
                                    `AccountIP` VARCHAR(100) NULL DEFAULT NULL ,
                                    `AccountID` INT(11) NULL DEFAULT NULL,
                                    `TrunkID` INT(11) NULL DEFAULT NULL,
                                    `UseInBilling` TINYINT(1) NULL DEFAULT NULL,
                                    `connect_time` DATETIME NULL DEFAULT NULL,
                                    `disconnect_time` DATETIME NULL DEFAULT NULL,
                                    `billed_duration` INT(11) NULL DEFAULT NULL,
                                    `billed_second` INT(11) NULL DEFAULT NULL,
                                    `trunk` VARCHAR(50) NULL DEFAULT NULL ,
                                    `area_prefix` VARCHAR(50) NULL DEFAULT NULL ,
                                    `TrunkPrefix` VARCHAR(50) NULL DEFAULT NULL ,
                                    `pincode` VARCHAR(50) NULL DEFAULT NULL ,
                                    `extension` VARCHAR(50) NULL DEFAULT NULL ,
                                    `cli` VARCHAR(500) NULL DEFAULT NULL ,
                                    `cld` VARCHAR(500) NULL DEFAULT NULL ,
                                    `cost` DOUBLE NULL DEFAULT NULL,
                                    `ProcessID`  BIGINT(20) UNSIGNED NULL DEFAULT NULL ,
                                    `ID` BIGINT(20) NULL DEFAULT NULL,
                                    `UUID` VARCHAR(200) NULL DEFAULT NULL ,
                                    `ServiceID` INT(11) NULL DEFAULT NULL,
                                    `remote_ip` VARCHAR(100) NULL DEFAULT NULL ,
                                    `duration` INT(11) NULL DEFAULT NULL,
                                    `is_inbound` TINYINT(1) DEFAULT 0,
                                    `is_rerated` TINYINT(1) NULL DEFAULT 0,
                                    `disposition` VARCHAR(50) NULL DEFAULT NULL ,
                                    `userfield` VARCHAR(255) NULL DEFAULT NULL ,
                                    `cc_type` TINYINT(1) NULL DEFAULT NULL ,
                                    `customer_trunk_type` VARCHAR(255) NULL DEFAULT NULL ,
                                    `TimezonesID` INT(11) NULL DEFAULT NULL,
                                    PRIMARY KEY (`TempUsageDetailID`),
                                    INDEX `IX_'.$tbltempusagedetail_name.'PID_I_AID` (`ProcessID`,`is_inbound`,`AccountID`),
                                    INDEX `IX_U` (`AccountName`, `AccountNumber`, `AccountCLI`, `AccountIP`, `CompanyGatewayID`, `ServiceID`, `CompanyID`),
                                    INDEX `IX_CDR_Timezone` (`TimezonesID`),
                                    INDEX `IX_ID` (`ID`)
                                )
                                ENGINE=InnoDB ; ';
            DB::connection('sqlsrvcdr')->statement($sql_create_table);
            DB::connection('sqlsrvcdr')->statement(' DELETE FROM '.$tbltempusagedetail_name);

            Schema::connection('sqlsrvcdr')->dropIfExists($temp_tblRetailUsageDetail_TableName);
            $temp_tblRetailUsageDetail_Create = "CREATE TABLE IF NOT EXISTS `".$temp_tblRetailUsageDetail_TableName."` (
                                        `TempRetailUsageDetailID` INT(11) NOT NULL AUTO_INCREMENT,
                                        `TempUsageDetailID` BIGINT(20) NOT NULL,
                                        `ID`  BIGINT(20) NULL DEFAULT NULL ,
                                        `cc_type` TINYINT(1) NOT NULL DEFAULT '0',
                                        `ProcessID`  BIGINT(20) UNSIGNED NULL DEFAULT NULL ,
                                        PRIMARY KEY (`TempRetailUsageDetailID`),
                                        UNIQUE INDEX `IX_TempUsageDetailID` (`TempUsageDetailID`),
                                        KEY `IX_ID` (`ID`),
                                        KEY `IX_ProcessID` (`ProcessID`),
                                        KEY `IX_cc_type` (`cc_type`)
                                    )
                                    COLLATE='utf8_unicode_ci'
                                    ENGINE=InnoDB
                                    ;";
            DB::connection('sqlsrvcdr')->statement($temp_tblRetailUsageDetail_Create);
            DB::connection('sqlsrvcdr')->statement(' DELETE FROM '.$temp_tblRetailUsageDetail_TableName);

            Log::error(' done ');

            return $tbltempusagedetail_name;
        }
    }

    public static function getUsagedetailTablenameByUniqueID($UniqueID,$vendor=0){
        $tblPrefix = "tblTempUsageDetail_";
        if($vendor == 1){
            $tblPrefix = "tblTempVendorCDR_";
        }
        return $tbltempusagedetail_name  = $tblPrefix. $UniqueID;

    }

    public static function getUsagedetailRetailTablename($tbltempusagedetail_name){

        return $tbltempusagedetail_name . "_Retail";

    }
    public static function CreateVendorTempTable($CompanyID,$CompanyGatewayID,$extra_prefix=''){

        $UniqueID = self::getUniqueID($CompanyGatewayID);

        if( empty($UniqueID)){
            $UniqueID = $CompanyID.$CompanyGatewayID;
            CompanyGateway::where("CompanyGatewayID",$CompanyGatewayID)->update(["UniqueID"=>$UniqueID]);
        }

        if(!empty($UniqueID)) {
            $tbltempusagedetail_name = self::getUsagedetailTablenameByUniqueID($UniqueID,1);

            $tbltempusagedetail_name .=$extra_prefix;
            Log::error($tbltempusagedetail_name);
            Schema::connection('sqlsrvcdr')->dropIfExists($tbltempusagedetail_name);
            $sql_create_table = 'CREATE TABLE IF NOT EXISTS `'  . $tbltempusagedetail_name . '` (
            	`TempVendorCDRID` INT(11) NOT NULL AUTO_INCREMENT,
                `CompanyID` INT(11) NULL DEFAULT NULL,
                `CompanyGatewayID` INT(11) NULL DEFAULT NULL,
                `GatewayAccountPKID` INT(11) NULL DEFAULT NULL,
                `GatewayAccountID` VARCHAR(100) NULL DEFAULT NULL,
                `AccountName` VARCHAR(100) NULL DEFAULT NULL ,
                `AccountNumber` VARCHAR(100) NULL DEFAULT NULL ,
                `AccountCLI` VARCHAR(100) NULL DEFAULT NULL ,
                `AccountIP` VARCHAR(100) NULL DEFAULT NULL ,
                `AccountID` INT(11) NULL DEFAULT NULL,
                `TrunkID` INT(11) NULL DEFAULT NULL,
                `UseInBilling` TINYINT(1) NULL DEFAULT NULL,
                `billed_duration` INT(11) NULL DEFAULT NULL,
                `billed_second` INT(11) NULL DEFAULT NULL,
                `duration` INT(11) NULL DEFAULT NULL,
                `ID` BIGINT(20) NULL DEFAULT NULL,
                `ServiceID` INT(11) NULL DEFAULT NULL,
                `selling_cost` DOUBLE NULL DEFAULT NULL,
                `buying_cost` DOUBLE NULL DEFAULT NULL,
                `connect_time` DATETIME NULL DEFAULT NULL,
                `disconnect_time` DATETIME NULL DEFAULT NULL,
                `cli` VARCHAR(500) NULL DEFAULT NULL ,
                `cld` VARCHAR(500) NULL DEFAULT NULL ,
                `trunk` VARCHAR(50) NULL DEFAULT NULL ,
                `area_prefix` VARCHAR(50) NULL DEFAULT NULL ,
                `TrunkPrefix` VARCHAR(50) NULL DEFAULT NULL ,
                `remote_ip` VARCHAR(100) NULL DEFAULT NULL ,
                `ProcessID`  BIGINT(20) UNSIGNED NULL DEFAULT NULL ,
                `is_rerated` TINYINT(1) NULL DEFAULT 0,
                `vendor_trunk_type` VARCHAR(255) NULL DEFAULT NULL ,
                `TimezonesID` INT(11) NULL DEFAULT NULL,
                 PRIMARY KEY (`TempVendorCDRID`),
                 INDEX `IX_'.$tbltempusagedetail_name.'PID_I_AID` (`ProcessID`,`AccountID`),
                 INDEX `IX_U` (`AccountName`, `AccountNumber`, `AccountCLI`, `AccountIP`, `CompanyGatewayID`, `ServiceID`, `CompanyID`),
                 INDEX `IX_CDR_Timezone` (`TimezonesID`),
                 INDEX `IX_ID` (`ID`)
                 )COLLATE=\'utf8_unicode_ci\' ENGINE=InnoDB ; ';
            DB::connection('sqlsrvcdr')->statement($sql_create_table);

            DB::connection('sqlsrvcdr')->statement(' DELETE FROM '.$tbltempusagedetail_name);

            Log::error('done ');

            return $tbltempusagedetail_name;
        }
    }
    public static function getProcessID(){
        $processID = Uuid::generate();
        return  DB::connection('sqlsrv2')->table('tblProcessID')->insertGetId(array('Process'=>$processID));
    }

    public static function dropTableForNewColumn($tbltempusagedetail_name){
        if(!Schema::connection('sqlsrvcdr')->hasColumn($tbltempusagedetail_name, 'UUID'))  //check whether users table has email column
        {
            Schema::connection('sqlsrvcdr')->dropIfExists($tbltempusagedetail_name);

        }
    }
    public static function getCallID($CompanyID,$CompanyGatewayID){
        $UniqueID = (int)CompanyConfiguration::getValueConfigurationByKey($CompanyID,'VOS_UniqueID_'.$CompanyGatewayID);
        if($UniqueID == 0){
            $CompanyConfiguration['CompanyID'] = $CompanyID;
            $CompanyConfiguration['Key'] = 'VOS_UniqueID_'.$CompanyGatewayID;
			$UniqueID = (int)DB::connection('sqlsrvcdr')->table('tblUCall')->max('UID');
			if($UniqueID == 0){
				$CompanyConfiguration['Value'] = $UniqueID =  1;
			}else{
				$CompanyConfiguration['Value'] = $UniqueID+1 ;
			}
            CompanyConfiguration::insert($CompanyConfiguration);
        }
        return $UniqueID;
    }
    public static function setCallID($CompanyID,$CompanyGatewayID,$UniqueID){
        CompanyConfiguration::where(['CompanyID'=>$CompanyID,'Key'=>'VOS_UniqueID_'.$CompanyGatewayID])->update(array('Value'=>$UniqueID));
    }

    /** function not in use*/
    public static function CreateTempLinkTable($CompanyID,$CompanyGatewayID,$extra_prefix=''){

        $UniqueID = self::getUniqueID($CompanyGatewayID);

        if( empty($UniqueID)){
            $UniqueID = $CompanyID.$CompanyGatewayID;
            CompanyGateway::where("CompanyGatewayID",$CompanyGatewayID)->update(["UniqueID"=>$UniqueID]);
        }

        if(!empty($UniqueID)) {
            $UniqueID .=$extra_prefix;

            $link_table1 = 'tblTempCallDetail_1_'.$UniqueID;
            $link_table2 = 'tblTempCallDetail_2_'.$UniqueID;

            $sql_create_table = 'CREATE TABLE IF NOT EXISTS `'  . $link_table1 . '` (
                                    `TempCallDetailID` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
                                    `GCID1` BIGINT(20) UNSIGNED NULL DEFAULT NULL,
                                    `CID` BIGINT(20) NULL DEFAULT NULL,
                                    `UsageHeaderID` INT(11) NULL DEFAULT NULL,
                                    `CompanyGatewayID1` INT(11) NULL DEFAULT NULL,
                                    `GatewayAccountPKID` INT(11) NULL DEFAULT NULL,
                                    `AccountID` INT(11) NULL DEFAULT NULL,
                                    `FailCall` TINYINT(4) NULL DEFAULT NULL,
                                    `ProcessID` BIGINT(20) UNSIGNED NULL DEFAULT NULL,
                                    PRIMARY KEY (`TempCallDetailID`),
                                    INDEX `IX_CID` (`GCID1`),
                                    INDEX `IX_ProcessID` (`ProcessID`)
                                )
                                ENGINE=InnoDB ; ';
            DB::connection('sqlsrvcdr')->statement($sql_create_table);
            DB::connection('sqlsrvcdr')->statement(' DELETE FROM '.$link_table1);

            $sql_create_table = 'CREATE TABLE IF NOT EXISTS `'  . $link_table2 . '` (
                                    `TempCallDetailID` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
                                    `GCID2` BIGINT(20) UNSIGNED NULL DEFAULT NULL,
                                    `VCID` BIGINT(20) NULL DEFAULT NULL,
                                    `VendorCDRHeaderID` INT(11) NULL DEFAULT NULL,
                                    `CompanyGatewayID2` INT(11) NULL DEFAULT NULL,
                                    `GatewayVAccountPKID` INT(11) NULL DEFAULT NULL,
                                    `VAccountID` INT(11) NULL DEFAULT NULL,
                                    `FailCallV` TINYINT(4) NULL DEFAULT NULL,
                                    `ProcessID` BIGINT(20) UNSIGNED NULL DEFAULT NULL,
                                    PRIMARY KEY (`TempCallDetailID`),
                                    INDEX `IX_CID` (`GCID2`),
                                    INDEX `IX_ProcessID` (`ProcessID`)
                                )
                                ENGINE=InnoDB ; ';
            DB::connection('sqlsrvcdr')->statement($sql_create_table);
            DB::connection('sqlsrvcdr')->statement(' DELETE FROM '.$link_table2);

            Log::error(' done ');

            return $UniqueID;
        }
    }


    public static function updateProcessID($CronJob,$processID){
       // $CronJob->update(['ProcessID'=>$processID]);
        DB::select("CALL prc_updateProcessID(".$CronJob->CronJobID.",'".$processID."')");
    }


}