<?php
namespace App\Lib;

use Illuminate\Support\Facades\DB;

class UsageHeader extends \Eloquent {
	protected $fillable = [];
    protected $connection = 'sqlsrvcdr';
    protected $guarded = array('UsageHeaderID');
    protected $table = 'tblUsageHeader';
    protected  $primaryKey = "UsageHeaderID";

    public static function getStartHeaderDate($CompanyID){
        $StartDate =  UsageHeader::where(['CompanyID'=>$CompanyID])->whereNotNull('AccountID')->min('StartDate');
        $usagecount = DB::connection('neon_report')->table('tblSummaryHeader')
            ->join('tblUsageSummary','tblUsageSummary.SummaryHeaderID','=','tblSummaryHeader.SummaryHeaderID')
            ->where(['CompanyID'=>$CompanyID])->count();
        $DELETE_SUMMARY_TIME = CompanyConfiguration::get($CompanyID,'DELETE_SUMMARY_TIME');
        $delete_strtotime = '-3 month';
        $DeleteTime = $DELETE_SUMMARY_TIME;
        if(!empty($DeleteTime)){
            $delete_strtotime = '- '.$DeleteTime;
        }
        $deletedate = date('Y-m-d',strtotime($delete_strtotime));
        if($StartDate < $deletedate && $usagecount > 0){
            $StartDate = $deletedate;
        }
        if(empty($StartDate)){
            $StartDate = date('Y-m-d');
        }
        return $StartDate;
    }
    public static function getVendorStartHeaderDate($CompanyID){
        $StartDate =  DB::connection('sqlsrvcdr')->table('tblVendorCDRHeader')->where(['CompanyID'=>$CompanyID])->whereNotNull('AccountID')->min('StartDate');
        $usagecount = DB::connection('neon_report')->table('tblSummaryVendorHeader')
            ->join('tblUsageVendorSummary','tblUsageVendorSummary.SummaryVendorHeaderID','=','tblSummaryVendorHeader.SummaryVendorHeaderID')
            ->where(['CompanyID'=>$CompanyID])->count();
        $DELETE_SUMMARY_TIME = CompanyConfiguration::get($CompanyID,'DELETE_SUMMARY_TIME');
        $delete_strtotime = '-3 month';
        $DeleteTime = $DELETE_SUMMARY_TIME;
        if(!empty($DeleteTime)){
            $delete_strtotime = '- '.$DeleteTime;
        }
        $deletedate = date('Y-m-d',strtotime($delete_strtotime));
        if($StartDate < $deletedate && $usagecount > 0){
            $StartDate = $deletedate;
        }
        if(empty($StartDate)){
            $StartDate = date('Y-m-d');
        }
        return $StartDate;
    }

    // use for customer cdr retention
    public static function getMinDateUsageHeader($CompanyID){
        $StartDate =  UsageHeader::where(['CompanyID'=>$CompanyID])->min('StartDate');
        if(empty($StartDate)){
            $StartDate = date('Y-m-d');
        }
        return $StartDate;
    }

    // use for vendor cdr retention
    public static function getMinDateVendorCDRHeader($CompanyID){
        $StartDate =  DB::connection('sqlsrvcdr')->table('tblVendorCDRHeader')->where(['CompanyID'=>$CompanyID])->min('StartDate');
        if(empty($StartDate)){
            $StartDate = date('Y-m-d');
        }
        return $StartDate;
    }
}