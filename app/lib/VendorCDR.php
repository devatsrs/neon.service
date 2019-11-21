<?php
namespace App\Lib;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class VendorCDR extends \Eloquent {
	protected $fillable = [];
    protected $connection = 'sqlsrvcdr';
    public $timestamps = false; // no created_at and updated_at

    protected $guarded = array('VendorCDRID');

    protected $table = 'tblVendorCDR';

    protected  $primaryKey = "VendorCDRID";

    const RATE_METHOD_CURRENT_RATE = "CurrentRate";
    const RATE_METHOD_SPECIFYRATE = "SpecifyRate";

    static $RateMethod = array(self::RATE_METHOD_CURRENT_RATE=>'Rate setup against account',self::RATE_METHOD_SPECIFYRATE=>'Specify Rate');

    public static function generatecsv($processID,$deletecdr=0,$IPbased = 0){
        Log::info("exec prc_getUsageDetail '".$processID."'");
        $UsageDetails = DB::connection('sqlsrvcdr')->select("CALL prc_getUsageDetail('".$processID."')");
        $count = 1;
        $excel_data = array();
        $prevacname = $prevfile = $get_current = $prevdate = $prevCompanyGatewayID='';
        $usedeatialids = array();
        foreach($UsageDetails as $UsageDetail){
            $cdrdate = date('Y-m-d',strtotime($UsageDetail->connect_time));
            $filename = $cdrdate.'.csv';
            if($IPbased == 1){
                $AccountName = trim($UsageDetail->remote_ip);
            }else{
                $AccountName = trim($UsageDetail->AccountName);
            }

            $fullpath = Config::get('app.cdr_location').$UsageDetail->CompanyGatewayID . '/' . $AccountName . '/';
            if (file_exists($fullpath) === false) {
                //mkdir($fullpath, 0777, true);
                RemoteSSH::make_dir(1,$fullpath);
            }
            $fullfilename = $fullpath.$filename;
            if($count == 1) {
                $prevacname = $AccountName;
                $prevfile = $filename;
                $prevCompanyGatewayID = $UsageDetail->CompanyGatewayID;
            }
            $prevfullpath = Config::get('app.cdr_location').$prevCompanyGatewayID . '/' . $prevacname . '/';
            $prevfullfilename = $prevfullpath.$prevfile;
            if($prevfullfilename != $fullfilename || $prevacname != $AccountName) {
                file_put_contents($prevfullfilename,$get_current,FILE_APPEND | LOCK_EX);
                $get_current='';
                $usedeatialids = array();
            }
            $excel_data = json_decode(json_encode($UsageDetail),true);
            unset($excel_data['CompanyGatewayID']);
            unset($excel_data['UsageDetailID']);
            $get_current .=implode(',',$excel_data)."\n";
            $usedeatialids[] = $UsageDetail->UsageDetailID;
            if(count($UsageDetails) == $count) {

                file_put_contents($prevfullfilename,$get_current, FILE_APPEND | LOCK_EX);
                $get_current='';
                $usedeatialids = array();

            }
            $prevacname = $AccountName;
            $prevfile = $filename;
            $prevdate = $cdrdate;
            $prevCompanyGatewayID = $UsageDetail->CompanyGatewayID;
            $count++;
        }
        if($deletecdr == 1){
            UsageDetail::where(["processId"=>$processID])->delete();
        }
    }


}