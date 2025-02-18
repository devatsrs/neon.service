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
        $usagecount = 0;
        $StartDate =  UsageHeader::where(['CompanyID'=>$CompanyID])->whereNotNull('AccountID')->min('StartDate');
        $usage = DB::connection('neon_report')->table('tblHeader')->where(['CompanyID'=>$CompanyID])->first();
        if(!empty($usage) && count($usage)){
            $usagecount = 1;
        }
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
        $usagecount = 0;
        $StartDate =  DB::connection('sqlsrvcdr')->table('tblVendorCDRHeader')->where(['CompanyID'=>$CompanyID])->whereNotNull('AccountID')->min('StartDate');
        $usage = DB::connection('neon_report')->table('tblHeaderV')->where(['CompanyID'=>$CompanyID])->first();
        if(!empty($usage) && count($usage)){
            $usagecount = 1;
        }
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