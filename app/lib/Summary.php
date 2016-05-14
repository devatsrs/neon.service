<?php
namespace App\Lib;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class Summary extends \Eloquent {
    public static function generateSummary($CompanyID){

        $startdate = date("Y-m-d", strtotime(UsageHeader::getStartHeaderDate($CompanyID)));
        $enddate  = date("Y-m-d", strtotime("-1 Day"));
        self::markFinalSummary($CompanyID,$startdate);
        $start = $startdate;
        while($start <= $enddate){

            $start_summary = $start;
            $end_summary = $start = date('Y-m-d', strtotime('+1 day',strtotime($start)));
            if($end_summary>$enddate){
                $end_summary = $enddate;
            }
            try {
                DB::connection('neon_report')->beginTransaction();
                $query = "call prc_generateSummary($CompanyID,'" . $start_summary . "','" . $start_summary . "')";
                Log::info($query);
                DB::connection('neon_report')->statement($query);
                DB::connection('neon_report')->commit();
            } catch (\Exception $e) {
                try {
                    DB::connection('neon_report')->rollback();
                } catch (\Exception $err) {
                    Log::error($err);
                }
                Log::error($e);
                Log::info($start_summary);
            }
        }
    }

    public static function markFinalSummary($CompanyID,$startdate){

        /*$query = "call prc_markSummaryFinal($CompanyID,'".$startdate."')";
        Log::info($query);
        DB::connection('neon_report')->statement($query);*/
    }

}