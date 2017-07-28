<?php
/**
 * Created by PhpStorm.
 * User: deven
 * Date: 25/07/2017
 * Time: 7:11 PM
 */

namespace App;


use App\Lib\CompanyGateway;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class RateImportExporter
{

    public $errors = array();
    public $CompanyID = 0;


    public static function getUniqueID($CompanyGatewayID){
        return CompanyGateway::where("CompanyGatewayID",$CompanyGatewayID)->pluck("UniqueID");
    }

    /* Create tblTempCustomerRatesImport_ tblTempVendorRatesImport_ Temp table as per UniqueID * */
    public static function CreateIfNotExistTempRateImportTable($CompanyID,$CompanyGatewayID,$extra_prefix=''){

        $UniqueID = self::getUniqueID($CompanyGatewayID);

        if( empty($UniqueID)){
            $UniqueID = $CompanyID.$CompanyGatewayID;
            CompanyGateway::where("CompanyGatewayID",$CompanyGatewayID)->update(["UniqueID"=>$UniqueID]);
        }

        if(!empty($UniqueID)) {
            $tbltemprateimport_name = self::getTablenameByUniqueID($UniqueID);

            Log::error( $tbltemprateimport_name);
            $tbltemprateimport_name .=$extra_prefix;

            $sql_create_table = 'CREATE TABLE IF NOT EXISTS `'  . $tbltemprateimport_name . '` (
                                    `TempRatesImportID` INT(11) NOT NULL AUTO_INCREMENT,
                                    `CompanyID` INT(11) NULL DEFAULT NULL,
                                    `CompanyGatewayID` INT(11) NULL DEFAULT NULL,
                                    `AccountID` INT(11) NULL DEFAULT NULL,
                                    `TrunkID` INT(11) NULL DEFAULT NULL,
                                    `RateID` INT(11) NULL DEFAULT NULL,
                                    `Code` varchar(50) NULL DEFAULT NULL,
                                    `Rate` DOUBLE NULL DEFAULT NULL ,
                                    `Preference` INT(11)  NULL DEFAULT NULL ,
                                    `ConnectionFee` DOUBLE NULL DEFAULT NULL ,
                                    `EffectiveDate` DateTime NULL DEFAULT NULL,
                                    `Interval1` INT(11) NULL DEFAULT NULL,
                                    `IntervalN` INT(11) NULL DEFAULT NULL,
                                    `ProcessID`  BIGINT(20) UNSIGNED NULL DEFAULT NULL ,
                                    PRIMARY KEY (`TempRatesImportID`),
                                    INDEX `IX_'.$tbltemprateimport_name.'PID_I_AID` (`ProcessID`,`AccountID`),
                                    INDEX `IX_ATR` (`AccountID`, `TrunkID`, `RateID`)
                                )
                                ENGINE=InnoDB ; ';
            DB::statement($sql_create_table);
            DB::statement(' DELETE FROM '.$tbltemprateimport_name);

            Log::error(' done ');

            return $tbltemprateimport_name;
        }
    }

    public static function getTablenameByUniqueID($UniqueID,$type='customer') {

        $tbl_ = "tblTempCustomerRatesImport_";

        if($type == 'vendor') {
            $tbl_ = "tblTempVendorRatesImport_";
        }

        return $tbl_. $UniqueID;

    }

    public static function importVendorRate($processID,$tempVendortable) {

        DB::statement("CALL  prc_VendorRatesFileImport ('" . $processID . "', '".$tempVendortable."' )");

    }

    public static function importCustomerRate($processID,$tempCustomertable) {

        DB::statement("CALL  prc_CustomerRatesFileImport ('" . $processID . "', '".$tempCustomertable."' )");

    }

}