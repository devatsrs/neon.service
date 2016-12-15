<?php
/**
 * Created by PhpStorm.
 * User: deven
 * Date: 15/12/2016
 * Time: 5:32 PM
 */

namespace App;


use App\Lib\Account;
use App\Lib\CodeDeck;
use App\Lib\CustomerRateUpdateHistory;
use App\Lib\CustomerRateUpdateHistoryWithData;
use App\Lib\CustomerTrunk;
use App\Lib\NeonExcelIO;
use App\Lib\Trunk;
use App\Lib\VendorRateUpdateHistory;
use App\Lib\VendorRateUpdateHistoryWithData;
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

        $query = "CALL prc_getRateUpdateHistory(" . $CompanyID . ",'" . $AccountType . "','" . $RateType . "','" . $current_date . "')";
        Log::info($query);
        $csv_data = DB::select($query);
        $csv_data = json_decode(json_encode($csv_data), true);
        Log::info($csv_data);

        $dir = $local_dir;
        if (!file_exists($dir)) {
            @mkdir($dir, 0777, TRUE);
        }

        if(count($csv_data) > 0) {

            foreach ($csv_data as $row) {
                $this->process_single_row($row);
            }

            if (count($this->updated_rates) > 0 ) {

                $sort_column = $AccountType == 'customer' ? "CustomerRateUpdateHistoryID" : "VendorRateUpdateHistoryID";

                //insert processed history records to history  data table
                try {

                    $this->insert_updated_rates_to_history_data($AccountType);

                } catch (\Exception $ex) {
                    Log::error($ex);
                    throw $ex;
                }



                // take records from history table
                $query = "CALL prc_getRateUpdateHistoryWithData(" . $CompanyID . ",'".$AccountType."','".$RateType."','".$current_date."')";
                Log::info($query);
                $csv_data = DB::select($query);
                $csv_data = collect($csv_data)->groupBy("AccountID");

                Log::info($csv_data);
                foreach ($csv_data as $AccountID => $rows) {

                    $rows = collect($rows)->toArray();
                    $rows = json_decode(json_encode($rows),true);

                    $file_name = $AccountID . '_' . date('Y-m-d-H:i:s');
                    $file_path = $dir . '/' . $AccountType . '_' . $RateType . '_' . $file_name . '.csv';

                    $min_max_ids = $this->get_min_max_primary_key_id($sort_column,$rows); // take min and max primary key to update records.

                    /**
                     * Generate Rate Update file based in processed rows
                     */
                    $NeonExcel = new NeonExcelIO($file_path);
                    $NeonExcel->generate_rate_update_file($rows);

                    if (file_exists($file_path) && is_numeric($min_max_ids["min_id"]) && is_numeric($min_max_ids["max_id"])) {

                        try {

                            $this->delete_history_table($AccountID,$sort_column,$min_max_ids,$AccountType = 'customer');

                        } catch (\Exception $ex) {
                            Log::error($ex);
                            @unlink($file_path);
                            $this->errors[] = $ex->getMessage();

                        }

                    }

                }
            }
        }

    }

    public function get_min_max_primary_key_id($primary_key, $rows)
    {

        $max_id = collect($rows)->sortByDesc($primary_key)->first()[$primary_key];
        $min_id = collect($rows)->sortBy($primary_key)->first()[$primary_key];

        return ["max_id" => $max_id, "min_id" => $min_id];
    }

    public function process_rows($rows)
    {
        foreach ($rows as $row) {

            $this->process_single_row($row);
        }

    }

    public function process_single_row($row)
    {

        $action = $row["created_by"];
        $IsDelete = $row["IsDelete"];

        Log::info("Processing");
        Log::info($row);
        if ($action == 'Codedeck_Code_Update_Delete_Trigger' || $action == 'Codedeck_Code_Update_Trigger' || $action == 'Codedeck_Interval_Update_Trigger') {

            /**
             * 1. tblRate_after_update - ( No AccountID, Only CompanyID,RateID,Code )
             * This will add 2 entry in history.
             *
             * 	a. When code is changed
             * Codedeck_Code_Update_Delete_Trigger - OLD code deleted
             * Codedeck_Code_Update_Trigger - New code update
             *
             *        created_by = Codedeck_Code_Update_Delete_Trigger
             *        Code = OLD Code
             *        IsDelete = 1

             * Query : select all customer rate including rate table with same rate id with delete = 1 with old code .
             *
             * b. when interval is changed
             * Codedeck_Interval_Update_Trigger - New interval update record.

             *        created_by = Codedeck_Code_Update_Trigger
             *        Code = NEW Code

             * Query : select all customer rate including rate table with same rate id with new code.
             *
             * case 2.
             *    created_by = Codedeck_Interval_Update_Trigger
             *
             * Query : select all customer rate including rate table with same rate id with new code.

             */

            $this->get_customer_rates_account($row);


        }

        /**
         * 2. tblCustomerTrunk add/update - (No RateID only CompanyID,AccountID,TrunkID,RateTableID)
         * case 1. tblCustomerTrunk_after_insert
         *        created_by = Customer_Trunk_Rate_Table_Insert_Trigger
         *        RateTableID = NEW.RateTableID
         *        TrunkID = NEW.TrunkID
         *        AccountID = NEW.AccountID
         *
         * Get this Rate Table Rate where RateTableID is this
         * generate array with TrunkID=NEW.TrunkID and AccountID = NEW.AccountID.
         * case 2. tblCustomerTrunk_after_update
         *        created_by = Customer_Trunk_Status_Update_Trigger
         *        RateTableID = OLD.RateTableID
         *        TrunkID = NEW.TrunkID
         *        AccountID = NEW.AccountID
         *        NEW.Status = 0
         *
         *        Get Rate Table Rate where RateTableID = OLD.RateTableID
         *        generate array with TrunkID=NEW.TrunkID and AccountID = NEW.AccountID with IsDelete = 1.
         *
         *        created_by = Customer_Trunk_Status_Update_Trigger
         *        RateTableID = OLD.RateTableID
         *        TrunkID = NEW.TrunkID
         *        AccountID = NEW.AccountID
         *        NEW.Status = 1
         *
         *        Get this Rate Table Rate where OLD.RateTableID is this
         *        generate array with TrunkID=NEW.TrunkID and AccountID = NEW.AccountID with IsDelete = 1.
         *        AND
         * Get Rate table rate where RateTableID  = NEW.RateTableID
         *        generate array with TrunkID=NEW.TrunkID and AccountID = NEW.AccountID.
         */

        if ($action == 'Customer_Trunk_Rate_Table_Insert_Trigger' ) {

            $this->get_rate_table_rates_account($row);
        }

        if($action == 'Customer_Trunk_Rate_Table_Update_Trigger' && $IsDelete == 1){

            //OLD Rate Table
            //$this->get_rate_table_rates_account($row);
            /*
             * @TODO: what if rate table is also deleted or may be some of rates is updated or deleted from rate table.
             * so best way is to delete all old rates and update new.
            */

            $updated_rates[] = array(
                "CompanyID" => $this->CompanyID,
                "CustomerRateUpdateHistoryID" => $row['CustomerRateUpdateHistoryID'],
                "Code" => '*', // All
                "EffectiveDate" => date("Y-m-d"),
                "Rate" => 0,
                "Interval1" => 0,
                "IntervalN" => 0,
                "IsDelete" => 1,
                "created_by" => $action,
            );
            $this->updated_rates = array_merge($this->updated_rates, $updated_rates);

        }
        if( ( $action == 'Customer_Trunk_Rate_Table_Update_Trigger' && $IsDelete == 0 ) || $action == 'Customer_Trunk_Status_Update_Trigger'){
            //NEW Rate TAble Rate TAble
            // OR Status Changed
            $this->get_customer_rates_account($row);
        }

        /**
         * 3. tblRateTableRate add/update/delete - ( no CompanyID and AccountID only RateTableID and RateID)
         * case 1. tblRateTableRate_after_insert
         *        created_by = Rate_Table_Rate_Insert_Trigger
         *
         * Get this Rate Table Rate where RateTableID is NEW.RateTableID
         * generate array with Active TrunkID and AccountID = NEW.AccountID.
         *
         * case 2. tblRateTableRate_after_update
         *        created_by = Rate_Table_Rate_Update_Trigger
         *
         * Get this Rate Table Rate where RateTableID is NEW.RateTableID
         * generate array with Active TrunkID AccountID = NEW.AccountID and NEW.RateID not in (CustomerRate.RateID).
         * case 3. tblRateTableRate_after_delete
         *        created_by = Rate_Table_Rate_Delete_Trigger
         *
         * Get this Rate Table Rate where RateTableID is OLD.RateTableID
         * generate array with Active TrunkID and AccountID = NEW.AccountID and NEW.RateID not in (CustomerRate.RateID).
         */

        if ($action == 'Rate_Table_Rate_Insert_Trigger' || $action == 'Rate_Table_Rate_Update_Trigger' || $action == 'Rate_Table_Rate_Delete_Trigger') {

            $this->get_customer_rates_account($row);

        }

        /**
         * 4. tblCustomerRate add/update/delete - ( No CompanyID only AccountID and RateID )
         * case 1. tblCustomerRate_after_insert
         *        created_by = Customer_Rate_Insert_Trigger
         *
         * Get this Customer Rate Table where RateID is NEW.RateID
         * generate array with Active TrunkID and AccountID = NEW.AccountID.
         * case 2. tblCustomerRate_after_update
         *        created_by = Customer_Rate_Update_Trigger
         *
         * Get this Customer Rate Table where RateID is NEW.RateID
         * generate array with Active TrunkID and AccountID = NEW.AccountID.
         * case 2. tblCustomerRate_after_delete
         *        created_by = Customer_Rate_Delete_Trigger
         *
         * Get this Customer Rate Table where RateID is OLD.RateID
         * generate array with Active TrunkID and AccountID = OLD.AccountID with Delete.
         * AND
         * Get Active Trunk Rate Table Rate where where RateID is OLD.RateID
         */

        if ($action == 'Customer_Rate_Insert_Trigger' || $action == 'Customer_Rate_Update_Trigger' || $action == 'Customer_Rate_Delete_Trigger') {

            //$this->get_customer_rates_account($row);

            $Prefix = Trunk::where(["TrunkID"=>$row['TrunkID'] , "CompanyID" => $this->CompanyID ])->first()->pluck("RatePrefix");
            $Code = CodeDeck::where(["RateID"=>$row['RateID'] , "CompanyID" => $this->CompanyID ])->first()->pluck("Code");

            $updated_rates[] = array(
                "CompanyID" => $this->CompanyID,
                "CustomerRateUpdateHistoryID" => $row['CustomerRateUpdateHistoryID'],
                "AccountID" => $row['AccountID'],
                "Code" => trim($Prefix) . trim($Code),
                "EffectiveDate" => $row["EffectiveDate"],
                "Rate" => $row["Rate"],
                "Interval1" => $row["Interval1"],
                "IntervalN" => $row["IntervalN"],
                "IsDelete" => $IsDelete,
                "created_by" => $action,
            );

            $this->updated_rates = array_merge($this->updated_rates, $updated_rates);


        }
        if ($action == 'Vendor_Rate_Delete_Trigger' || $action == 'Vendor_Rate_Insert_Trigger' || $action == 'Vendor_Rate_Update_Trigger') {

            $Prefix = Trunk::where(["TrunkID"=>$row['TrunkID'] , "CompanyID" => $this->CompanyID ])->first()->pluck("RatePrefix");
            $Code = CodeDeck::where(["RateID"=>$row['RateID'] , "CompanyID" => $this->CompanyID ])->first()->pluck("Code");

            $updated_rates[] = array(
                "CompanyID" => $this->CompanyID,
                "VendorRateUpdateHistoryID" => $row['VendorRateUpdateHistoryID'],
                "AccountID" => $row['AccountID'],
                "Code" => $Prefix . $Code,
                "EffectiveDate" => $row["EffectiveDate"],
                "Rate" => $row["Rate"],
                "Interval1" => $row["Interval1"],
                "IntervalN" => $row["IntervalN"],
                "IsDelete" => $IsDelete,
                "created_by" => $action,
            );

            $this->updated_rates = array_merge($this->updated_rates, $updated_rates);

        }



        /**
         * Now insert this array into tblCustomerRateUpdateHistoryWithData table
         * Why? because there may be future_rate_update option off and future code should also be updated to gateway.
         */

    }

    public function get_rate_table_rates_account($row) {

        if (empty($row["AccountID"])) {

            $AccountIDs = Account::select(["AccountID"])
                ->where(["CompanyID" => $this->CompanyID, "Status" => 1, "AccountType" => 1, "IsCustomer" => 1])
                ->get()->toArray();

            foreach ($AccountIDs as $Account) {

                $this->get_rate_table_rates($Account["AccountID"],$row);

            }
        } else {

            $this->get_rate_table_rates($row["AccountID"],$row);
        }

    }

    public function get_customer_rates_account($row) {

        if (empty($row["AccountID"])) {

            $AccountIDs = Account::select(["AccountID"])
                ->where(["CompanyID" => $this->CompanyID, "Status" => 1, "AccountType" => 1, "IsCustomer" => 1])
                ->get()->toArray();

            foreach ($AccountIDs as $Account) {

                $this->get_customer_rates($Account["AccountID"],$row);

            }
        } else {

            $this->get_customer_rates($row["AccountID"],$row);
        }

    }

    public function get_customer_rates($AccountID, $row)
    {
        $TrunkID = $row["TrunkID"];
        if(empty($TrunkID)) {
            $Trunks = CustomerTrunk::getCustomerTrunksByTrunkAsKey($AccountID);
            foreach ($Trunks as $TrunkID => $Trunk) {

                $this->get_customer_rate_trunk($AccountID,$Trunk,$row);

            }
        } else {
            $Trunk = Trunk::where(["TrunkID"=>$TrunkID , "CompanyID" => $this->CompanyID ])->first();
            $this->get_customer_rate_trunk($AccountID,$Trunk,$row);

        }
    }

    public function get_rate_table_rates($AccountID, $row)
    {
        $TrunkID = $row["TrunkID"];
        if(empty($TrunkID)) {
            $Trunks = CustomerTrunk::getCustomerTrunksByTrunkAsKey($AccountID);
            foreach ($Trunks as $TrunkID => $Trunk) {

                $this->get_rate_table_rate_trunk($AccountID,$Trunk,$row);

            }
        } else {
            $Trunk = Trunk::where(["TrunkID"=>$TrunkID , "CompanyID" => $this->CompanyID ])->first();
            $this->get_rate_table_rate_trunk($AccountID,$Trunk,$row);

        }
    }

    public function get_customer_rate_trunk($AccountID,$Trunk, $row)
    {

        $updated_rates = array();

        $action = $row["created_by"];
        $IsDelete = $row["IsDelete"];

        $Prefix = $Trunk["RatePrefix"]; //@TODO: check if its only need to add once we have checkbox (Include prefix in Rate sheet ) in CustomerTrunk selected
        $p_companyid = $this->CompanyID;
        $p_AccountID = $AccountID;
        $p_trunkID = $Trunk["TrunkID"];
        $p_contryID = 'NULL';

        /**
         * TODO: need to see if its future code is deleted or current code?
         */
        if(!empty($row["Code"])){
            $p_code = $row["Code"];
        } else if (!empty($row["RateID"]) && $row["RateID"] > 0) {
            $p_code = CodeDeck::where(["RateID"=>$row["RateID"]])->first()->pluck("Code");
        }else {
            $p_code = 'NULL';
        }
        $p_description = 'NULL';
        $p_Effective = 'All';
        $p_effectedRates = 1;
        $p_RoutinePlan = 0;
        $p_PageNumber = 0;
        $p_RowspPage = 0;
        $p_lSortCol = 0;
        $p_SortOrder = '';
        $p_isExport = 1;

        if ($action == 'Codedeck_Code_Update_Delete_Trigger') {
            // check for rate id as code is changed.
            $p_code = CodeDeck::where(["RateID"=>$row["RateID"]])->first()->pluck("Code");
        }

        $customer_rates = DB::select("call prc_GetCustomerRate (?,?,?,?,'?',?,?,?,?,?,?,'?','?',?)", array($p_companyid, $p_AccountID, $p_trunkID, $p_contryID, $p_code, $p_description, $p_Effective, $p_effectedRates, $p_RoutinePlan, $p_PageNumber, $p_RowspPage, $p_lSortCol, $p_SortOrder, $p_isExport));

        if ( count($customer_rates) == 0 &&  $action == 'Rate_Table_Rate_Delete_Trigger' || $action == 'Customer_Rate_Delete_Trigger'  ) {

            $p_code = CodeDeck::where(["RateID"=>$row["RateID"]])->first()->pluck("Code");

            $updated_rates[] = array(
                "CompanyID" => $this->CompanyID,
                "CustomerRateUpdateHistoryID" => $row['CustomerRateUpdateHistoryID'],
                "AccountID" => $p_AccountID,
                "Code" => $Prefix . $p_code,
                "EffectiveDate" => $row["EffectiveDate"],
                "Rate" => $row["Rate"],
                "Interval1" => $row["Interval1"],
                "IntervalN" => $row["IntervalN"],
                "IsDelete" => $IsDelete,
                "created_by" => $action,
            );

        }
        if( count($customer_rates) == 0 ) {

            foreach ($customer_rates as $customer_rate) {

                $code = $Prefix . $customer_rate["Code"];
                if ($action == 'Codedeck_Code_Update_Delete_Trigger') {
                    // as code is changed we need old code with delete 1
                    $code = $Prefix . $row["Code"];
                }

                $updated_rates[] = array(
                    "CompanyID" => $p_companyid,
                    "CustomerRateUpdateHistoryID" => $row['CustomerRateUpdateHistoryID'],
                    "AccountID" => $p_AccountID,
                    "Code" => $code,
                    "EffectiveDate" => $customer_rate["EffectiveDate"],
                    "Rate" => $customer_rate["Rate"],
                    "Interval1" => $customer_rate["Interval1"],
                    "IntervalN" => $customer_rate["IntervalN"],
                    "IsDelete" => $IsDelete,
                    "created_by" => $action,
                );
            }
        }

        if (!empty($updated_rates)) {
            $this->updated_rates =  array_merge($this->updated_rates, $updated_rates);
        }
    }

    public function get_rate_table_rate_trunk($AccountID,$Trunk, $row)
    {

        $action = $row["created_by"];
        $IsDelete = $row["IsDelete"];

        $Prefix = $Trunk["RatePrefix"]; //@TODO: check if its only need to add once we have checkbox (Include prefix in Rate sheet ) in CustomerTrunk selected
        $p_companyid = $this->CompanyID;
        $p_RateTableId = $row["RateTableID"];
        $p_trunkID = $Trunk["TrunkID"];
        $p_contryID = 'NULL';
        if(!empty($row["Code"])){
            $p_code = $row["Code"];
        } else if (!empty($row["RateID"]) && $row["RateID"] > 0) {
            $p_code = CodeDeck::where(["RateID"=>$row["RateID"]])->first()->pluck("Code");
        }else {
            $p_code = 'NULL';
        }
        $p_description = 'NULL';
        $p_Effective = 'All';
        $p_effectedRates = 1;
        $p_RoutinePlan = 0;
        $p_PageNumber = 0;
        $p_RowspPage = 0;
        $p_lSortCol = 0;
        $p_SortOrder = '';
        $p_isExport = 1;

        $customer_rates = DB::select("call prc_GetRateTableRate (?,?,?,?,'?',?,?,?,?,?,?,?)", array($p_companyid, $p_RateTableId, $p_trunkID, $p_contryID, $p_code, $p_description, $p_Effective, $p_effectedRates, $p_RoutinePlan, $p_PageNumber, $p_RowspPage, $p_lSortCol, $p_SortOrder, $p_isExport));

        $updated_rates = array();
        foreach ($customer_rates as $customer_rate) {
            $updated_rates[] = array(
                "CompanyID" => $p_companyid,
                "CustomerRateUpdateHistoryID" => $row['CustomerRateUpdateHistoryID'],
                "AccountID" => $AccountID,
                "Code" => $Prefix . $customer_rate["Code"],
                "EffectiveDate" => $customer_rate["EffectiveDate"],
                "Rate" => $customer_rate["Rate"],
                "Interval1" => $customer_rate["Interval1"],
                "IntervalN" => $customer_rate["IntervalN"],
                "IsDelete" => $IsDelete,
                "created_by" => $action,
            );
        }

        if (!empty($updated_rates)) {
            $this->updated_rates = array_merge($this->updated_rates, $updated_rates);
        }
    }

    public function insert_updated_rates_to_history_data($type='customer'){

        Log::info("Inserting to history data");
        if(count($this->updated_rates) > 0 ) {
            $rates  =  $this->updated_rates;
            $InserData = array();
            $data_count = 0;
            $insertLimit = 1000;
            foreach($rates as $rate) {

                $InserData[] = $rate;
                $data_count++;
                if ($data_count > $insertLimit && !empty($InserData)) {
                    if($type == 'customer'){
                        CustomerRateUpdateHistoryWithData::insert($InserData);
                    } else {
                        VendorRateUpdateHistoryWithData::insert($InserData);
                    }
                    $InserData = array();
                    $data_count = 0;
                }
            }

            if (!empty($InserData)) {
                if($type == 'customer'){
                    CustomerRateUpdateHistoryWithData::insert($InserData);
                } else {
                    VendorRateUpdateHistoryWithData::insert($InserData);
                }
            }

        }
    }

    public function delete_history_table($AccountID,$sort_column,$min_max_ids,$AccountType = 'customer'){

        try {

            DB::beginTransaction();

            if ($AccountType == 'customer') {

                CustomerRateUpdateHistory::where($sort_column, '>=', $min_max_ids["min_id"])->where($sort_column, '<=', $min_max_ids["max_id"])->where(["AccountID" => $AccountID])->delete();
                CustomerRateUpdateHistoryWithData::where($sort_column, '>=', $min_max_ids["min_id"])->where($sort_column, '<=', $min_max_ids["max_id"])->where(["AccountID" => $AccountID])->delete();

            } else if ($AccountType == 'vendor') {

                VendorRateUpdateHistory::where($sort_column, '>=', $min_max_ids["min_id"])->where($sort_column, '<=', $min_max_ids["max_id"])->where(["AccountID" => $AccountID])->delete();
                VendorRateUpdateHistoryWithData::where($sort_column, '>=', $min_max_ids["min_id"])->where($sort_column, '<=', $min_max_ids["max_id"])->where(["AccountID" => $AccountID])->delete();
            }

            DB::commit();

        } catch (\Exception $ex) {

            Log::error($ex);
            DB::rollback();
            throw $ex;

        }

    }
}