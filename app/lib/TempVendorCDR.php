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

    public static function ProcessCDR($CompanyID,$ProcessID,$CompanyGatewayID,$RateCDR,$RateFormat){
        $skiped_account_data =array();
        Log::error(' prc_insertGatewayVendorAccount start CompanyGatewayID = '.$CompanyGatewayID);
        DB::connection('sqlsrv2')->statement("CALL  prc_insertGatewayVendorAccount('" . $ProcessID . "')");
        Log::error(' prc_insertGatewayVendorAccount end CompanyGatewayID = '.$CompanyGatewayID);


        //Update tblGatewayAccount
        Log::error(' prc_getActiveGatewayAccount start CompanyGatewayID = '.$CompanyGatewayID);
        DB::connection('sqlsrv2')->statement('CALL  prc_getActiveGatewayAccount(' . $CompanyID . "," . $CompanyGatewayID." ,'','1')"); // Procedure Updated - 05-10-2015
        Log::error(' prc_getActiveGatewayAccount end CompanyGatewayID = '.$CompanyGatewayID);

        //Update tblVendorCDRHeader
        Log::error(' prc_setVendorAccountID start CompanyGatewayID = '.$CompanyGatewayID);
        DB::connection('sqlsrv2')->statement('CALL  prc_setVendorAccountID(' . $CompanyID.")");
        Log::error(' prc_setVendorAccountID end CompanyGatewayID = '.$CompanyGatewayID);


        if($RateFormat == Company::PREFIX) {
            Log::error(' prc_updateVendorPrefixTrunk start CompanyGatewayID = '.$CompanyGatewayID);
            DB::connection('sqlsrv2')->statement("CALL  prc_updateVendorPrefixTrunk('" . $CompanyID . "','" . $CompanyGatewayID . "','" . $ProcessID . "')");
            Log::error(' prc_updateVendorPrefixTrunk end CompanyGatewayID = '.$CompanyGatewayID);
        }


        Log::error(' prc_setVendorAccountIDCDR start CompanyGatewayID = '.$CompanyGatewayID);
        DB::connection('sqlsrv2')->statement("CALL prc_setVendorAccountIDCDR('" . $CompanyID . "','" . $ProcessID . "')");
        Log::error(' prc_setVendorAccountIDCDR end CompanyGatewayID = '.$CompanyGatewayID);


        Log::error(' prc_insertTempVendorCDR  start');
        DB::connection('sqlsrv2')->statement("CALL  prc_insertTempVendorCDR('" . $ProcessID . "')");
        Log::error('prc_insertTempVendorCDR  end');
        return $skiped_account_data;

    }
}
