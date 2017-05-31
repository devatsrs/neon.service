<?php
namespace App\Lib;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
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
                                    `ID` INT(11) NULL DEFAULT NULL,
                                    `ServiceID` INT(11) NULL DEFAULT NULL,
                                    `remote_ip` VARCHAR(100) NULL DEFAULT NULL ,
                                    `duration` INT(11) NULL DEFAULT NULL,
                                    `is_inbound` TINYINT(1) DEFAULT 0,
                                    `is_rerated` TINYINT(1) NULL DEFAULT 0,
                                    `disposition` VARCHAR(50) NULL DEFAULT NULL ,
                                    PRIMARY KEY (`TempUsageDetailID`),
                                    INDEX `IX_'.$tbltempusagedetail_name.'PID_I_AID` (`ProcessID`,`is_inbound`,`AccountID`),
                                    INDEX `IX_U` (`AccountName`, `AccountNumber`, `AccountCLI`, `AccountIP`, `CompanyGatewayID`, `ServiceID`, `CompanyID`)
                                )
                                ENGINE=InnoDB ; ';
            DB::connection('sqlsrvcdr')->statement($sql_create_table);
            DB::connection('sqlsrvcdr')->statement(' DELETE FROM '.$tbltempusagedetail_name);

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
                `ID` INT(11) NULL DEFAULT NULL,
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
                 PRIMARY KEY (`TempVendorCDRID`),
                 INDEX `IX_'.$tbltempusagedetail_name.'PID_I_AID` (`ProcessID`,`AccountID`),
                 INDEX `IX_U` (`AccountName`, `AccountNumber`, `AccountCLI`, `AccountIP`, `CompanyGatewayID`, `ServiceID`, `CompanyID`)
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


}