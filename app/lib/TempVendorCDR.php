<?php
namespace App\Lib;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class TempVendorCDR extends \Eloquent {
	protected $fillable = [];
    protected $connection = 'sqlsrv2';
    public $timestamps = false; // no created_at and updated_at

    protected $guarded = array('TempVendorCDRID');

    protected $table = 'tblTempVendorCDR';

    protected  $primaryKey = "TempVendorCDRID";

    public static function ProcessCDR($CompanyID,$ProcessID,$CompanyGatewayID,$RateCDR,$RateFormat,$tempVendortable){
        $skiped_account_data =array();
        Log::error("start $CompanyGatewayID CALL  prc_insertGatewayVendorAccount('" . $ProcessID . "','".$tempVendortable."')");
        DB::connection('sqlsrv2')->statement("CALL  prc_insertGatewayVendorAccount('" . $ProcessID . "','".$tempVendortable."')");
        Log::error("end $CompanyGatewayID CALL  prc_insertGatewayVendorAccount('" . $ProcessID . "','".$tempVendortable."')");


        //Update tblGatewayAccount
        Log::error('start  prc_getActiveGatewayAccount start CompanyGatewayID = '.$CompanyGatewayID);
        DB::connection('sqlsrv2')->statement('CALL  prc_getActiveGatewayAccount(' . $CompanyID . "," . $CompanyGatewayID." ,'0','1')"); // Procedure Updated - 05-10-2015
        Log::error('end prc_getActiveGatewayAccount end CompanyGatewayID = '.$CompanyGatewayID);

        if($RateFormat == Company::PREFIX) {
            Log::error("start CALL  prc_updateVendorPrefixTrunk('" . $CompanyID . "','" . $CompanyGatewayID . "','" . $ProcessID . "',,'".$tempVendortable."')");
            DB::connection('sqlsrv2')->statement("CALL  prc_updateVendorPrefixTrunk('" . $CompanyID . "','" . $CompanyGatewayID . "','" . $ProcessID . "','".$tempVendortable."')");
            Log::error("end CALL  prc_updateVendorPrefixTrunk('" . $CompanyID . "','" . $CompanyGatewayID . "','" . $ProcessID . "',,'".$tempVendortable."')");
        }

        Log::error("start $CompanyGatewayID CALL  prc_setAccountIDCDR ('" . $CompanyID . "','" . $ProcessID . "', '".$tempVendortable."')");
        DB::connection('sqlsrv2')->statement("CALL  prc_setAccountIDCDR ('" . $CompanyID . "','" . $ProcessID . "', '".$tempVendortable."')");
        Log::error("end $CompanyGatewayID CALL  prc_setAccountIDCDR ('" . $CompanyID . "','" . $ProcessID . "', '".$tempVendortable."')");

        return $skiped_account_data;

    }
}
