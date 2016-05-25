<?php
namespace App\Lib;

use Illuminate\Support\Facades\DB;

class UsageHeader extends \Eloquent {
	protected $fillable = [];
    protected $connection = 'sqlsrvcdrazure';
    protected $guarded = array('UsageHeaderID');
    protected $table = 'tblUsageHeader';
    protected  $primaryKey = "UsageHeaderID";

    public static function getStartHeaderDate($CompanyID){
        $StartDate =  UsageHeader::where(['CompanyID'=>$CompanyID])->whereNotNull('AccountID')->min('StartDate');
        $usagecount = DB::connection('neon_report')->table('tblSummaryHeader')->where(['CompanyID'=>$CompanyID])->count();
        if($StartDate < date('Y-m-1', strtotime('-3 month')) && $usagecount > 0){
            $StartDate = date('Y-m-1', strtotime('-3 month'));
        }
        return $StartDate;
    }
    public static function getVendorStartHeaderDate($CompanyID){
        $StartDate =  DB::connection('sqlsrvcdrazure')->table('tblVendorCDRHeader')->where(['CompanyID'=>$CompanyID])->whereNotNull('AccountID')->min('StartDate');
        $usagecount = DB::connection('neon_report')->table('tblSummaryVendorHeader')->where(['CompanyID'=>$CompanyID])->count();
        if($StartDate < date('Y-m-1', strtotime('-3 month')) && $usagecount > 0){
            $StartDate = date('Y-m-1', strtotime('-3 month'));
        }
        return $StartDate;
    }
}