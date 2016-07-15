<?php
namespace App\Lib;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class Summary extends \Eloquent {
    public static function generateSummary($CompanyID,$today){

        if($today == 1){
            $query = "call prc_generateSummaryLive($CompanyID,'" . date("Y-m-d") . "','" . date("Y-m-d") . "')";
            Log::info($query);
            $error_message = DB::connection('neon_report')->select($query);
            if(count($error_message)){
                throw  new \Exception($error_message[0]->Message);
            }
        }else {
            $startdate = date("Y-m-d", strtotime(UsageHeader::getStartHeaderDate($CompanyID)));
            $enddate = date("Y-m-d", strtotime("-1 Day"));
            self::markFinalSummary($CompanyID, $startdate);
            $start = $startdate;
            while ($start <= $enddate) {

                $start_summary = $start;
                $end_summary = $start = date('Y-m-d', strtotime('+1 day', strtotime($start)));
                if ($end_summary > $enddate) {
                    $end_summary = $enddate;
                }
                try {
                    $query = "call prc_generateSummary($CompanyID,'" . $start_summary . "','" . $start_summary . "')";
                    Log::info($query);
                    $error_message = DB::connection('neon_report')->select($query);
                    if(count($error_message)){
                        throw  new \Exception($error_message[0]->Message);
                    }
                } catch (\Exception $e) {
                    Log::error($e);
                    Log::info($start_summary);
                }
            }
        }
    }

    public static function markFinalSummary($CompanyID,$startdate){

        /*$query = "call prc_markSummaryFinal($CompanyID,'".$startdate."')";
        Log::info($query);
        DB::connection('neon_report')->statement($query);*/
    }
    public static function generateVendorSummary($CompanyID,$today){
        if($today == 1){
            $query = "call prc_generateVendorSummaryLive($CompanyID,'" . date("Y-m-d") . "','" . date("Y-m-d") . "')";
            Log::info($query);
            $error_message = DB::connection('neon_report')->select($query);
            if(count($error_message)){
                throw  new \Exception($error_message[0]->Message);
            }
        }else {
            $startdate = date("Y-m-d", strtotime(UsageHeader::getVendorStartHeaderDate($CompanyID)));
            $enddate = date("Y-m-d", strtotime("-1 Day"));
            self::markFinalSummary($CompanyID, $startdate);
            $start = $startdate;
            while ($start <= $enddate) {

                $start_summary = $start;
                $end_summary = $start = date('Y-m-d', strtotime('+1 day', strtotime($start)));
                if ($end_summary > $enddate) {
                    $end_summary = $enddate;
                }
                try {
                    $query = "call prc_generateVendorSummary($CompanyID,'" . $start_summary . "','" . $start_summary . "')";
                    Log::info($query);
                    $error_message = DB::connection('neon_report')->select($query);
                    if(count($error_message)){
                        throw  new \Exception($error_message[0]->Message);
                    }
                } catch (\Exception $e) {
                    Log::error($e);
                    Log::info($start_summary);
                }
            }
        }
    }

}