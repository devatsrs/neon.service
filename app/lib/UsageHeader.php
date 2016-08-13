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
        $delete_strtotime = '-3 month';
        $DeleteTime = getenv('DELETE_SUMMARY_TIME');
        if(!empty($DeleteTime)){
            $delete_strtotime = '- '.$DeleteTime;
        }
        $deletedate = date('Y-m-d',strtotime($delete_strtotime));
        if($StartDate < $deletedate && $usagecount > 0){
            $StartDate = $deletedate;
        }
        return $StartDate;
    }
    public static function getVendorStartHeaderDate($CompanyID){
        $StartDate =  DB::connection('sqlsrvcdrazure')->table('tblVendorCDRHeader')->where(['CompanyID'=>$CompanyID])->whereNotNull('AccountID')->min('StartDate');
        $usagecount = DB::connection('neon_report')->table('tblSummaryVendorHeader')->where(['CompanyID'=>$CompanyID])->count();
        $delete_strtotime = '-3 month';
        $DeleteTime = getenv('DELETE_SUMMARY_TIME');
        if(!empty($DeleteTime)){
            $delete_strtotime = '- '.$DeleteTime;
        }
        $deletedate = date('Y-m-d',strtotime($delete_strtotime));
        if($StartDate < $deletedate && $usagecount > 0){
            $StartDate = $deletedate;
        }
        return $StartDate;
    }

    // use for customer cdr retention
    public static function getMinDateUsageHeader($CompanyID){
        $StartDate =  UsageHeader::where(['CompanyID'=>$CompanyID])->min('StartDate');
        return $StartDate;
    }

    // use for vendor cdr retention
    public static function getMinDateVendorCDRHeader($CompanyID){
        $StartDate =  DB::connection('sqlsrvcdr')->table('tblVendorCDRHeader')->where(['CompanyID'=>$CompanyID])->min('StartDate');
        return $StartDate;
    }
}