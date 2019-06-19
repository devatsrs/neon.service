<?php
namespace App;

use App\Lib\Account;
use App\Lib\GatewayAPI;
use App\Lib\RateTableRate;
use App\Lib\VendorRate;
use Exception;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class ClarityPBX{

    private static $config = array();
    private static $cli;
    private static $timeout = 0; /* 60 seconds timeout */
    private static $dbname = 'clarity';

    public static $pbxRates;
    public static $pbxInsertRates;
    public static $pbxUpdateRates;

    public function __construct($CompanyGatewayID){
        $setting = GatewayAPI::getSetting($CompanyGatewayID, 'ClarityPBX');
        foreach ((array)$setting as $configkey => $configval) {
            if ($configkey == 'password') {
                self::$config[$configkey] = Crypt::decrypt($configval);
            } else {
                self::$config[$configkey] = $configval;
            }
        }
        if (count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])) {
            Config::set('database.connections.pgsql.host',self::$config['dbserver']);
            Config::set('database.connections.pgsql.database',self::$dbname);
            Config::set('database.connections.pgsql.username',self::$config['username']);
            Config::set('database.connections.pgsql.password',self::$config['password']);

        }
    }

    public static function testConnection(){
        $response = array();
        if (count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])) {

            try {
                if (DB::connection('pgsql')->getDatabaseName()) {
                    $response['result'] = 'OK';
                }
            } catch (Exception $e) {
                $response['faultString'] = $e->getMessage();
                $response['faultCode'] = $e->getCode();
            }
        }
        return $response;
    }


    public static function getAccountCDRs($addparams = array()){
        $response = array();
        if (count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])) {
            try {

                $query = "select
                        cdr.src,cdr.dest,cdr.id AS call_id,cdr.sip_code,cdr.start_time,cdr.answer_time,cdr.end_time,cdr.duration_sec,cdr.src_ip,cdr.dest_ip,
                        crp.rate_bill_sec,crp.rate_cost_net,crp.vendor_bill_sec,crp.vendor_cost,
                        crs.rate_prefix,customer.descr AS customer_name,vendor.descr AS vendor_name
                    from
                      cdr
                    left join
                      cdr_rate_postproc as crp on crp.cdr_id=cdr.id
                    left join
                      cdr_rate_static as crs on crs.cdr_id=cdr.id
                    join
                      customer on customer.id = cdr.customer_id
                    join
                      vendor on vendor.id = cdr.vendor_id
                    where
                      cdr.end_time is not null and cdr.end_time >= '" . $addparams['start_date_ymd'] . "' and cdr.end_time < '" . $addparams['end_date_ymd'] . "'
                ";

                Log::info($query);
                $response = DB::connection('pgsql')->select($query);
            } catch (Exception $e) {
                $response['faultString'] = $e->getMessage();
                $response['faultCode'] = $e->getCode();
                Log::error("Class Name:" . __CLASS__ . ",Method: " . __METHOD__ . ", Fault. Code: " . $e->getCode() . ", Reason: " . $e->getMessage());
                throw new Exception($e->getMessage());
            }
        }
        return $response;

    }

    public static function updateAccountBalance($addparams = array()){
        $response = array();
        if (count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])) {
            try {
                $findAccountQuery = "SELECT
                                        COUNT(cbc.*)
                                    FROM
                                        customer_bg_credit_ctrl cbc
                                    WHERE
                                        cbc.customer_bg_id = (
                                            SELECT cb.id FROM customer_bg cb
                                            JOIN customer c on c.id = cb.customer_id
                                            WHERE c.descr = '".$addparams['AccountName']."'
                                            ORDER BY cb.id ASC LIMIT 1
                                        )";
                Log::info($findAccountQuery);
                $findAccountResult = DB::connection('pgsql')->select($findAccountQuery);

                if($findAccountResult[0]->count > 0) {
                    $calc = $addparams['Recall'] == 1 ? '-' : '+';
                    $query = "UPDATE
                                customer_bg_credit_ctrl
                            SET credit_bal = credit_bal ".$calc." ".$addparams['Amount']."
                            WHERE
                                customer_bg_id = (
                                    SELECT cb.id FROM customer_bg cb
                                    JOIN customer c on c.id = cb.customer_id
                                    WHERE c.descr = '".$addparams['AccountName']."'
                                    ORDER BY cb.id ASC LIMIT 1
                                )";
                    Log::info($query);
                    $result = DB::connection('pgsql')->select($query);

                    $response['Status'] = "OK";
                } else {
                    $response['faultString'] = $addparams['AccountName']." : Account or Account Balance entry not found in Gateway.";
                    $response['faultCode'] = "400";
                }

            } catch (Exception $e) {
                $response['faultString'] = $e->getMessage();
                $response['faultCode'] = $e->getCode();
                Log::error("Class Name:" . __CLASS__ . ",Method: " . __METHOD__ . ", Fault. Code: " . $e->getCode() . ", Reason: " . $e->getMessage());
                throw new Exception($e->getMessage());
            }
        }
        return $response;

    }

    //get data from gateway and insert in temp table
    public static function getCustomersList($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{
                $query = "select * from customer ";
                $response = DB::connection('pgsql')->select($query);
            }catch(Exception $e){
                $response['faultString'] =  $e->getMessage();
                $response['faultCode'] =  $e->getCode();
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $e->getCode(). ", Reason: " . $e->getMessage());
                //throw new Exception($e->getMessage());
            }
        }
        return $response;
    }

    //get data from gateway and insert in temp table
    public static function getVendorsList($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{
                $query = "select * from vendor ";
                $response = DB::connection('pgsql')->select($query);
            }catch(Exception $e){
                $response['faultString'] =  $e->getMessage();
                $response['faultCode'] =  $e->getCode();
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $e->getCode(). ", Reason: " . $e->getMessage());
                //throw new Exception($e->getMessage());
            }
        }
        return $response;
    }



    public static function updateRateTables($rateTables = []){
        $response = null;
        //dd(self::$config);
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{
                if(!empty($rateTables)) {
                    $list = DB::connection('pgsql')
                        ->table('term_rate_plan')
                        ->lists('descr', 'id');

                    $insertData = [];
                    foreach ($rateTables as $key => $rateTable)
                        if (!in_array($rateTable, $list)) {
                            $insertData[] = [
                                'descr' => $rateTable,
                                'region_group_id' => null,
                                'parent_term_rate_plan_id' => null
                            ];
                        }

                    if (!empty($insertData)){
                        DB::connection('pgsql')
                            ->table('term_rate_plan')->insert($insertData);
                    }

                    $response = DB::connection('pgsql')
                        ->table('term_rate_plan')
                        ->whereIn('descr', $rateTables)
                        ->lists('descr', 'id');


                }

            }catch(Exception $e){
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $e->getCode(). ", Reason: " . $e->getMessage());
                throw new Exception($e->getMessage());
            }
        }
        return $response;
    }


    public static function updateRateTableRates($CompanyID, $pbxRateTables = []){
        $response = null;
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{
                DB::beginTransaction();
                Log::info("Total RateTables: " . count($pbxRateTables));

                //DB::connection('pbxmysql')->table('ra_rates')->whereIn('ra_cl_id', array_keys($pbxRateTables))->delete();

                $totalInserted = 0;
                $totalUpdated  = 0;

                foreach($pbxRateTables as $cl_id => $pbxRateTable) {

                    Log::info("=========================================================");
                    Log::info("Starting ------ RateTableName: " . $pbxRateTable . " ------");
                    $rates = DB::connection('pgsql')->table('term_rate')
                        ->join('term_rate_plan', 'term_rate_plan.id', '=', 'term_rate.term_rate_plan_id')
                        ->select([
                            'term_rate.id as id',//Rate ID
                            'term_rate_plan.descr', // RateTable Name
                            'term_rate.prefix', // Code
                            'term_rate.minute_cost' // Cost Prefix
                            //'ra_cost'
                        ])->where('term_rate_plan.id', $cl_id);

                    self::$pbxRates = [];
                    $rates->chunk(10000, function ($chunk) {
                        foreach ($chunk as $item)
                            self::$pbxRates[$item->prefix] = $item;
                        Log::info("Fetching Data: " . count(self::$pbxRates));
                    });

                    Log::info("Total Fetched: " . count(self::$pbxRates));

                    $rateQ = RateTableRate::join('tblRateTable', 'tblRateTable.RateTableId', '=', 'tblRateTableRate.RateTableId')
                        ->join('tblRate', 'tblRate.RateID', '=', 'tblRateTableRate.RateID')
                        ->leftJoin('tblCountry', 'tblCountry.CountryID', '=', 'tblRate.CountryID')
                        ->select([
                            'tblRate.Code',
                            'tblRate.Interval1',
                            'tblCountry.Prefix',
                            'tblRateTableRate.Rate',
                            'tblRateTableRate.ConnectionFee',
                            'tblRateTable.RoundChargedAmount',
                            'tblRate.Description',
                            'tblRate.IntervalN'
                        ])->where([
                            'tblRateTable.CompanyId' => $CompanyID,
                            'tblRateTable.Status' => 1,
                            'tblRateTable.RateTableName' => $pbxRateTable
                        ])->whereDate('tblRateTableRate.EffectiveDate', "<=", date('Y-m-d'))
                        ->groupBy('tblRate.Code');

                    //Log::info($rateQ->toSql());

                    //Log::info("Total Available Rates: " . $rateQ->count());

                    self::$pbxInsertRates = [];
                    self::$pbxUpdateRates = [];

                    $rateQ->chunk(10000, function ($chunk) use ($cl_id, $pbxRateTable) {
                        Log::info("Rates Proceeding: " . $chunk->count());

                        foreach ($chunk as $arr) {

                            if (isset(self::$pbxRates[$arr->Code])) {
                                if (number_format(self::$pbxRates[$arr->Code]->minute_cost, 5) != number_format($arr->Rate, 5)) {
                                    self::$pbxUpdateRates[] = [
                                        'id' => self::$pbxRates[$arr->Code]->id,
                                        'minute_cost' => number_format($arr->Rate, 5)
                                    ];
                                }

                            } else {

                                self::$pbxInsertRates[] = [
                                    'term_rate_plan_id'  => $cl_id,
                                    'descr'           => substr($arr->Description,0,47),
                                    'prefix'          => $arr->Code,
                                    'min_duration'    => $arr->Interval1,
                                    'duration_incr'   => $arr->IntervalN,
                                    'minute_cost'     => $arr->Rate,
                                    'regional'        => 'undef',

                                ];
                            }
                        }

                        Log::info("Insert: " . count(self::$pbxInsertRates) . ", Update: " . count(self::$pbxUpdateRates));
                        sleep(1);
                    });

                    if (!empty(self::$pbxInsertRates))
                        foreach (array_chunk(self::$pbxInsertRates, 1500) as $insertData) {
                            DB::connection('pgsql')->table('term_rate')->insert($insertData);
                        }

                    if (!empty(self::$pbxUpdateRates))
                        foreach (self::$pbxUpdateRates as $key => $updateData) {
                            DB::connection('pgsql')->table('term_rate')
                                ->where('id', $updateData['id'])
                                ->update(['minute_cost' => $updateData['minute_cost']]);
                        }

                    $totalInserted += count(self::$pbxInsertRates);
                    $totalUpdated += count(self::$pbxUpdateRates);

                    Log::info("Total Inserted: " . count(self::$pbxInsertRates) . ", Total Updated:" . count(self::$pbxUpdateRates));

                    Log::info("Ending ------ RateTableName: " . $pbxRateTable . " ------");
                    Log::info("=========================================================");
                }

                DB::commit();

                $response = ['inserted' => $totalInserted, 'updated' => $totalUpdated];

                Log::info("Done " . json_encode($response));
            } catch(Exception $e){
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $e->getCode(). ", Reason: " . $e->getMessage());
                throw new Exception($e->getMessage());
            }
        }
        return $response;
    }


    public static function updateVendorRateTables($vendors = []){
        $response = null;
        //dd(self::$config);
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{
                if(!empty($vendors)) {
                    $list = DB::connection('pgsql')
                        ->table('vendor')
                        ->lists('descr', 'id');

                    $insertData = [];
                    foreach ($vendors as $key => $vendorName)
                        if (!in_array($vendorName, $list)) {
                            $insertData[] = [
                                'descr'           => $vendorName,
                                'active'       => true,
                            ];
                        }

                    if (!empty($insertData)){
                        DB::connection('pgsql')
                            ->table('vendor')->insert($insertData);
                    }
                    Log::info("Total Inserted Vendors: " . count($insertData));

                    $response = DB::connection('pgsql')
                        ->table('vendor')
                        ->whereIn('descr', $vendors)
                        ->lists('descr', 'id');
                }

            }catch(Exception $e){
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $e->getCode(). ", Reason: " . $e->getMessage());
                throw new Exception($e->getMessage());
            }
        }
        return $response;
    }


    public static function updateVendorRates($CompanyID, $pbxVendors = []){
        $response = null;
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{
                DB::beginTransaction();
                Log::info("Total Vendors: " . count($pbxVendors));

                //DB::connection('pbxmysql')->table('ra_rates')->whereIn('ra_cl_id', array_keys($pbxRateTables))->delete();

                $totalInserted = 0;
                $totalUpdated  = 0;

                foreach($pbxVendors as $pr_id => $pbxVendor) {

                    Log::info("=========================================================");
                    Log::info("Starting ------ Vendor : " . $pbxVendor . " ------");
                    $rates = DB::connection('pgsql')->table('vendor_term_route')
                        ->join('vendor', 'vendor.id', '=', 'vendor_term_route.vendor_id')
                        ->select([
                            'vendor_term_route.id',
                            //'vendor.id as vendorid', // Account id
                            'vendor_term_route.descr', // Account Name
                            'vendor_term_route.prefix', // Code
                            'vendor_term_route.minute_cost', // cost

                        ])->where('vendor.id', $pr_id);

                    self::$pbxRates = [];
                    $rates->chunk(10000, function ($chunk) {
                        foreach ($chunk as $item)
                            self::$pbxRates[$item->prefix] = $item;
                        Log::info("Fetching Data: " . count(self::$pbxRates));
                    });

                    Log::info("Total Fetched: " . count(self::$pbxRates));

                    $rateQ = VendorRate::join('tblAccount', 'tblAccount.AccountID', '=', 'tblVendorRate.AccountId')
                        ->join('tblRate', 'tblRate.RateID', '=', 'tblVendorRate.RateId')
                        ->leftJoin('tblCountry', 'tblCountry.CountryID', '=', 'tblRate.CountryID')
                        ->select([
                            'tblRate.Code',
                            'tblRate.Interval1',
                            'tblCountry.Prefix',
                            'tblVendorRate.Rate',
                            'tblVendorRate.ConnectionFee',
                            'tblVendorRate.MinimumCost',
                            'tblRate.Description',
                            'tblRate.IntervalN'
                        ])->where([
                            'tblAccount.VerificationStatus'  => Account::VERIFIED,
                            'tblAccount.IsVendor'			 => 1,
                            'tblAccount.CompanyID'			 => $CompanyID,
                            'tblAccount.AccountName'              => $pbxVendor
                        ])->whereDate('tblVendorRate.EffectiveDate', "<=", date('Y-m-d'))
                        ->groupBy('tblRate.Code');

                    //Log::info($rateQ->toSql());
                    //Log::info("Total Available Rates: " . $rateQ->count());die;

                    self::$pbxInsertRates = [];
                    self::$pbxUpdateRates = [];

                    $rateQ->chunk(10000, function ($chunk) use ($pr_id, $pbxVendor) {
                        //Log::info("Rates Proceeding: " . $chunk->count());

                        foreach ($chunk as $arr) {

                            if (isset(self::$pbxRates[$arr->Code])) {
                                if (number_format(self::$pbxRates[$arr->Code]->minute_cost, 5) != number_format($arr->Rate, 5)) {
                                    self::$pbxUpdateRates[] = [
                                        'id' => self::$pbxRates[$arr->Code]->id,
                                        'minute_cost' => number_format($arr->Rate, 5)
                                    ];
                                }

                            } else {
                                self::$pbxInsertRates[] = [
                                    'vendor_id'        => $pr_id,
                                    'active'       => true,
                                    'descr'       => substr($arr->Description,0,63),
                                    'prefix'          => $arr->Code,
                                    'regional'        => 'undef',
                                    'minute_cost'     => $arr->Rate,
                                    'min_duration'    => $arr->Interval1,
                                    'duration_incr'   => $arr->IntervalN,

                                ];
                            }
                        }

                        Log::info("Insert: " . count(self::$pbxInsertRates) . ", Update: " . count(self::$pbxUpdateRates));
                        sleep(1);
                    });


                    if (!empty(self::$pbxInsertRates))
                        foreach (array_chunk(self::$pbxInsertRates, 1500) as $insertData) {
                            DB::connection('pgsql')->table('vendor_term_route')->insert($insertData);
                        }

                    if (!empty(self::$pbxUpdateRates))
                        foreach (self::$pbxUpdateRates as $key => $updateData) {
                            DB::connection('pgsql')->table('vendor_term_route')
                                ->where('id', $updateData['id'])
                                ->update(['minute_cost' => $updateData['minute_cost']]);
                        }

                    $totalInserted += count(self::$pbxInsertRates);
                    $totalUpdated += count(self::$pbxUpdateRates);

                    Log::info("Total Inserted: " . count(self::$pbxInsertRates) . ", Total Updated:" . count(self::$pbxUpdateRates));

                    Log::info("Ending ------ Vendor Number: " . $pbxVendor . " ------");
                    Log::info("=========================================================");
                }

                DB::commit();

                $response = ['inserted' => $totalInserted, 'updated' => $totalUpdated];

                Log::info("Done " . json_encode($response));
            } catch(Exception $e){
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $e->getCode(). ", Reason: " . $e->getMessage());
                throw new Exception($e->getMessage());
            }
        }
        return $response;
    }

}