<?php
namespace App\Lib;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class RateSheetDetails extends \Eloquent {
	protected $fillable = [];
    protected $guarded = array('RateSheetDetailsID');

    protected $table = 'tblRateSheetDetails';

    protected  $primaryKey = "RateSheetDetailsID";

    public static function DeleteOldRateSheetDetails($latestVendorSheetID,$customerID,$rateSheetCategory){
        DB::statement("CALL prc_WSDeleteOldRateSheetDetails('" .$latestVendorSheetID. "','" . $customerID."','" . $rateSheetCategory."')");
    }

    public static function SaveToDetail($AccountID,$trunkname,$file_name,$excel_data){
        $ratesheetdata = array();
        $ratesheetdata['CustomerID'] = $AccountID;
        $ratesheetdata['DateGenerated'] = date('Y-m-d H:i:s');
        $ratesheetdata['FileName'] = $file_name;
        $ratesheetdata['Level'] = $trunkname;
        $RateSheetID = RateSheet::insertGetId($ratesheetdata);

        $InserData = array();
        $insertLimit = 1000;
        $data_count = 0;

        foreach ($excel_data as $excel_data_row) {
            $ratesheetdetaildata = array();
            $ratesheetdetaildata['RateID'] = $excel_data_row['rateid'];
            $ratesheetdetaildata['RateSheetID'] = $RateSheetID;
            $ratesheetdetaildata['Destination'] = $excel_data_row['destination'];
            $ratesheetdetaildata['Code'] = $excel_data_row['codes'];
            $ratesheetdetaildata['Rate'] = $excel_data_row['rate per minute (usd)'];
            $ratesheetdetaildata['Change'] = $excel_data_row['change'];
            $ratesheetdetaildata['EffectiveDate'] = $excel_data_row['effective date'];
            $ratesheetdetaildata['Interval1'] = $excel_data_row['interval1'];
            $ratesheetdetaildata['IntervalN'] = $excel_data_row['intervaln'];

            $InserData[] = $ratesheetdetaildata;

            if( $data_count > $insertLimit &&  !empty($InserData) ) {
                RateSheetDetails::insert($InserData);
                $InserData = array();
                $data_count = 0;
            }
            $data_count++;
        }

        if( !empty($InserData) ) {
            RateSheetDetails::insert($InserData);
        }

        return $RateSheetID;

    }
}