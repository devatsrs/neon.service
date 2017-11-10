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

    public static function ProcessCDR($CompanyID,$ProcessID,$CompanyGatewayID,$RateCDR,$RateFormat,$tempVendortable,$NameFormat='',$Accounts=0){
        $skiped_account_data =array();
        $skiped_account_data =array();
        Log::error('start CALL  prc_ProcesssVCDR( ' . $CompanyID . "," . $CompanyGatewayID .",".$ProcessID.",'".$tempVendortable."',$RateCDR,$RateFormat,'".$NameFormat."','".$Accounts."')");
        $skiped_account = DB::connection('sqlsrv2')->select('CALL  prc_ProcesssVCDR( ' . $CompanyID . "," . $CompanyGatewayID .",".$ProcessID.",'".$tempVendortable."',$RateCDR,$RateFormat,'".$NameFormat."','".$Accounts."')");
        Log::error('end CALL  prc_ProcesssVCDR( ' . $CompanyID . "," . $CompanyGatewayID .",".$ProcessID.",'".$tempVendortable."',$RateCDR,$RateFormat,'".$NameFormat."','".$Accounts."')");
        foreach($skiped_account as $skiped_account_row){
            $skiped_account_data[]  = $skiped_account_row->Message;
        }

        return $skiped_account_data;

    }
    /** not in use */
    public static function RateCDR($CompanyID,$ProcessID,$temptableName){
        //$TempUsageDetails = TempUsageDetail::where(array('ProcessID'=>$ProcessID))->whereNotNull('AccountID')->where('trunk','!=','other')->groupBy('AccountID','trunk')->select(array('trunk','AccountID'))->get();
        $TempUsageDetails = DB::connection('sqlsrvcdr')->table($temptableName)->where(array('ProcessID'=>$ProcessID))->whereNotNull('AccountID')->where('trunk','!=','other')->groupBy('AccountID','trunk')->select(array('trunk','AccountID'))->get();
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
        $FailedAccounts = DB::connection('sqlsrvcdr')->table($temptableName)->where(array('ProcessID'=>$ProcessID))->whereNotNull('AccountID')->where('trunk','=','other')->groupBy('GatewayAccountID','trunk')->select(array('GatewayAccountID','trunk'))->get();
        foreach($FailedAccounts as $FailedAccount){
            $skiped_account_data[] = $FailedAccount->GatewayAccountID.' Account Trunk Not Matched '.$FailedAccount->trunk;
        }
        $FailedAccounts = DB::connection('sqlsrvcdr')->table($temptableName)->where(array('ProcessID'=>$ProcessID))->whereNull('AccountID')->groupBy('GatewayAccountID')->select(array('GatewayAccountID'))->get();
        foreach($FailedAccounts as $FailedAccount){
            $skiped_account_data[] = 'Account Not Matched '.$FailedAccount->GatewayAccountID;
        }
        return $skiped_account_data;
    }
}
