<?php
/**
 * Created by PhpStorm.
 * User: deven
 * Date: 15/12/2016
 * Time: 5:32 PM
 */

namespace App;


use App\Lib\NeonExcelIO;
use App\Lib\RemoteSSH;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class RateUpdateFileGenerator
{

    public $errors = array();
    public $CompanyID = 0;
    public $updated_rates = array();

    public function generate_file($CompanyID, $AccountType, $RateType, $local_dir)
    {
        $this->CompanyID  = $CompanyID;

        $this->updated_rates = array(); // clear rates
        $current_date = date("Y-m-d");

        $AccountType = strtolower($AccountType);
        $RateType = strtolower($RateType);


        $dir = $local_dir;
        if (!file_exists($dir)) {
            //@mkdir($dir, 0777, TRUE);
            RemoteSSH::make_dir($CompanyID,$dir);
        }

        $sort_column = $AccountType == 'customer' ? "CustomerRateUpdateHistoryWithDataID" : "VendorRateUpdateHistoryWithDataID";

        //insert processed history records to history  data table
        try {


            $query = "CALL prc_ProcessRateUpdateHistory(" . $CompanyID . ",'" . $AccountType . "','" . $RateType . "','" . $current_date . "')";
            Log::info($query);
            DB::select($query);

            $query = "CALL prc_getRateUpdateHistoryWithData(" . $CompanyID . ",'" . $AccountType . "','" . $RateType . "','" . $current_date . "')";
            Log::info($query);
            $csv_data = DB::select($query);
            $csv_data = collect($csv_data)->groupBy("AccountID");
            Log::info($csv_data);

            foreach ($csv_data as $AccountID => $rows) {

                $rows = collect($rows)->toArray();
                $rows = json_decode(json_encode($rows),true);

                $file_name = $AccountID . '_' . date('Y-m-d-H-i-s');
                $file_path = $dir . '/' . $AccountType . '_' . $RateType . '_' . $file_name . '.csv';

                $min_max_ids = $this->get_min_max_primary_key_id($sort_column,$rows); // take min and max primary key to update records.

                /**
                 * Generate Rate Update file based in processed rows
                 */
                $NeonExcel = new NeonExcelIO($file_path);
                $NeonExcel->generate_rate_update_file($rows);

                if (file_exists($file_path) && is_numeric($min_max_ids["min_id"]) && is_numeric($min_max_ids["max_id"])) {

                    try {

                        $this->delete_history_table($AccountID,$sort_column,$min_max_ids,$AccountType);

                    } catch (\Exception $ex) {
                        Log::error($ex);
                        @unlink($file_path);
                        $this->errors[] = $ex->getMessage();
                    }
                }
            }
        } catch (\Exception $ex) {
            Log::error($ex);
            throw $ex;
        }
    }

    public function get_min_max_primary_key_id($primary_key, $rows)
    {
        $max_id = collect($rows)->sortBy($primary_key,SORT_DESC,1)->first(function($row) use ($primary_key) { return $row[$primary_key];});
        $min_id = collect($rows)->sortBy($primary_key,SORT_ASC)->first(function($row) use ($primary_key) { return $row[$primary_key];});

         return ["max_id" => $max_id, "min_id" => $min_id];
    }

    public function delete_history_table($AccountID,$sort_column,$min_max_ids,$AccountType = 'customer'){

        try {

            DB::beginTransaction();

            if ($AccountType == 'customer') {

                //CustomerRateUpdateHistoryWithData::where($sort_column, '>=', $min_max_ids["min_id"])->where($sort_column, '<=', $min_max_ids["max_id"])->where(["AccountID" => $AccountID])->delete();

            } else if ($AccountType == 'vendor') {

                //VendorRateUpdateHistoryWithData::where($sort_column, '>=', $min_max_ids["min_id"])->where($sort_column, '<=', $min_max_ids["max_id"])->where(["AccountID" => $AccountID])->delete();
            }

            DB::commit();

        } catch (\Exception $ex) {

            Log::error($ex);
            DB::rollback();
            throw $ex;

        }

    }
}