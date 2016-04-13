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

        Log::error("start $CompanyGatewayID CALL  prc_setAccountIDCDR ('" . $CompanyID . "','" . $ProcessID . "', '".$tempVendortable."')");
        DB::connection('sqlsrv2')->statement("CALL  prc_setAccountIDCDR ('" . $CompanyID . "','" . $ProcessID . "', '".$tempVendortable."')");
        Log::error("end $CompanyGatewayID CALL  prc_setAccountIDCDR ('" . $CompanyID . "','" . $ProcessID . "', '".$tempVendortable."')");

        if($RateFormat == Company::PREFIX) {
            Log::error("start CALL  prc_updateVendorPrefixTrunk('" . $CompanyID . "','" . $CompanyGatewayID . "','" . $ProcessID . "',,'".$tempVendortable."')");
            DB::connection('sqlsrv2')->statement("CALL  prc_updateVendorPrefixTrunk('" . $CompanyID . "','" . $CompanyGatewayID . "','" . $ProcessID . "','".$tempVendortable."')");
            Log::error("end CALL  prc_updateVendorPrefixTrunk('" . $CompanyID . "','" . $CompanyGatewayID . "','" . $ProcessID . "',,'".$tempVendortable."')");
        }



        if($RateCDR == 1){
            $skiped_account_data = self::RateCDR($CompanyID,$ProcessID,$tempVendortable);
        }
        return $skiped_account_data;

    }
    public static function RateCDR($CompanyID,$ProcessID,$temptableName){
        //$TempUsageDetails = TempUsageDetail::where(array('ProcessID'=>$ProcessID))->whereNotNull('AccountID')->where('trunk','!=','other')->groupBy('AccountID','trunk')->select(array('trunk','AccountID'))->get();
        $TempUsageDetails = DB::connection('sqlsrvcdrazure')->table($temptableName)->where(array('ProcessID'=>$ProcessID))->whereNotNull('AccountID')->where('trunk','!=','other')->groupBy('AccountID','trunk')->select(array('trunk','AccountID'))->get();
        $skiped_account_data = array();
        foreach($TempUsageDetails as $TempUsageDetail){
            $TrunkID = DB::table('tblTrunk')->where(array('trunk'=>$TempUsageDetail->trunk))->pluck('TrunkID');
            if($TrunkID>0) {
                $rarateaccount = "CALL  prc_VendorCDRReRateByAccount('" . $CompanyID . "','" . $TempUsageDetail->AccountID . "','" . $TrunkID . "','" . $ProcessID . "','".$temptableName."')";
                $AccountRates = DB::select($rarateaccount);
                Log::error("rarateaccount query = $rarateaccount");
                foreach($AccountRates as $AccountRate){
                    $skiped_account_data[] = 'Account :: '.$AccountRate->AccountName.' Trunk ::'.$AccountRate->trunk.' Rate Code ::'.$AccountRate->area_prefix;
                }
            }else{
                Log::error("rarateaccount query = $TempUsageDetail->trunk");
            }
        }
        $FailedAccounts = DB::connection('sqlsrvcdrazure')->table($temptableName)->where(array('ProcessID'=>$ProcessID))->whereNotNull('AccountID')->where('trunk','=','other')->groupBy('GatewayAccountID','trunk')->select(array('GatewayAccountID','trunk'))->get();
        foreach($FailedAccounts as $FailedAccount){
            $skiped_account_data[] = $FailedAccount->GatewayAccountID.' Account Trunk Not Matched '.$FailedAccount->trunk;
        }
        $FailedAccounts = DB::connection('sqlsrvcdrazure')->table($temptableName)->where(array('ProcessID'=>$ProcessID))->whereNull('AccountID')->groupBy('GatewayAccountID')->select(array('GatewayAccountID'))->get();
        foreach($FailedAccounts as $FailedAccount){
            $skiped_account_data[] = 'Account Not Matched '.$FailedAccount->GatewayAccountID;
        }
        return $skiped_account_data;
    }
}
