<?php
namespace App\Lib;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;


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
        return CompanyGateway::where(array('Status'=>1,'CompanyGatewayID'=>$CompanyGatewayID))->pluck('TimeZone');
    }
    public static function getGatewayBillingTimeZone($CompanyGatewayID){
        return CompanyGateway::where(array('Status'=>1,'CompanyGatewayID'=>$CompanyGatewayID))->pluck('BillingTimeZone');
    }

    public static function getUniqueID($CompanyGatewayID){
        return CompanyGateway::where("CompanyGatewayID",$CompanyGatewayID)->pluck("UniqueID");
    }

    /* Create tblTempUsageDetail Temp table as per UniqueID * */
    public static function CreateIfNotExistCDRTempUsageDetailTable($CompanyID,$CompanyGatewayID){

        $UniqueID = self::getUniqueID($CompanyGatewayID);

        if( empty($UniqueID)){
            $UniqueID = $CompanyID.$CompanyGatewayID;
            CompanyGateway::where("CompanyGatewayID",$CompanyGatewayID)->update(["UniqueID"=>$UniqueID]);
        }

        if(!empty($UniqueID)) {
            $tbltempusagedetail_name = self::getUsagedetailTablenameByUniqueID($UniqueID);

            Log::error(' prc_create_tempusagedetail_table = ' . $tbltempusagedetail_name);
            //DB::connection('sqlsrvcdr')->statement("CALL  prc_create_tempusagedetail_table ('" . $tbltempusagedetail_name . "')");

            $sql_create_table = 'CREATE TABLE IF NOT EXISTS `'  . $tbltempusagedetail_name . '` (
                                    `TempUsageDetailID` INT(11) NOT NULL AUTO_INCREMENT,
                                    `CompanyID` INT(11) NULL DEFAULT NULL,
                                    `CompanyGatewayID` INT(11) NULL DEFAULT NULL,
                                    `GatewayAccountID` VARCHAR(100) NULL DEFAULT NULL ,
                                    `AccountID` INT(11) NULL DEFAULT NULL,
                                    `connect_time` DATETIME NULL DEFAULT NULL,
                                    `disconnect_time` DATETIME NULL DEFAULT NULL,
                                    `billed_duration` INT(11) NULL DEFAULT NULL,
                                    `trunk` VARCHAR(50) NULL DEFAULT NULL ,
                                    `area_prefix` VARCHAR(50) NULL DEFAULT NULL ,
                                    `pincode` VARCHAR(50) NULL DEFAULT NULL ,
                                    `cli` VARCHAR(500) NULL DEFAULT NULL ,
                                    `cld` VARCHAR(500) NULL DEFAULT NULL ,
                                    `cost` DOUBLE NULL DEFAULT NULL,
                                    `ProcessID` VARCHAR(200) NULL DEFAULT NULL ,
                                    `ID` INT(11) NULL DEFAULT NULL,
                                    `remote_ip` VARCHAR(100) NULL DEFAULT NULL ,
                                    `duration` INT(11) NULL DEFAULT NULL,
                                    PRIMARY KEY (`TempUsageDetailID`),
                                    INDEX `IX_'.$tbltempusagedetail_name.'_CompanyID_CompanyGatewayID_ProcessID` (`CompanyID`, `CompanyGatewayID`, `ProcessID`)
                                )
                                ENGINE=InnoDB ; ';
            DB::connection('sqlsrvcdr')->statement($sql_create_table);

            Log::error(' prc_create_tempusagedetail_table done ');

            return $tbltempusagedetail_name;
        }
    }

    public static function getUsagedetailTablenameByUniqueID($UniqueID){

        $tblPrefix = "tblTempUsageDetail_";
        return $tbltempusagedetail_name  = $tblPrefix. $UniqueID;

    }
}