<?php
namespace App;

use App\Lib\Account;
use App\Lib\RateTable;
use App\Lib\RateTableRate;
use App\Lib\VendorRate;
use \Exception;
use App\Lib\GatewayAPI;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Crypt;
class PBX{
    private static $config = array();
    private static $dbname1 = 'asteriskcdrdb';
    private static $dbname2 = 'asterisk';
    private static $db1_tbl1_name = 'cdr';
    private static $connect;
    private static $timeout=0; /* 60 seconds timeout */

    const  INBOUND      = 1;
    const  OUTBOUND     = 2;
    const  CONFERENCE   = 3;
    const  OUTNOCHARGE  = 4;

    static $CcType = [ "OTHER", "INBOUND" , "OUTBOUND"   , "CONFERENCE"   , "OUTNOCHARGE"  ];

    /**
     *
     *
     *
     *  PBX Columns
     * --------------------------------------------------------
     * Database:  asteriskcdrdb
     * Database:  asterisk
     * --------------------------------------------------------
     * Table: asteriskcdrdb.cdr c
     * Table: asterisk.cc_callcosts cc
     * --------------------------------------------------------
     * ##################  PBX Columns ########################
     * ##################  ----------- ########################
     *
     * c.src
     * c.ID                                     ID
     * c.start                                  connect_time
     * c.end                                    disconnect_time
     * c.duration                               duration
     * c.billsec                                billed_second,billed_duration
     * c.realsrc as extension                   extension
     * c.accountcode                            --  GatewayAccountID,AccountNumber
     * c.firstdst                               if inbound call ,  cld
     * c.lastdst                               if outbound call ,  cld (if empty then firstdst) --
     * coalesce(sum(cc_cost)) as cc_cost        cost
     * c.pincode                                pincode
     * c.userfield                              userfield
     * cc_type                                  -- to check Failed Call or Ignore calls (used to check internal call)
     * disposition                              disposition
     *
     *--------------------------------------------------------
     */

    /**
     * PBX constructor.
     * @param $CompanyGatewayID
     */
    public function __construct($CompanyGatewayID){
        $setting = GatewayAPI::getSetting($CompanyGatewayID,'PBX');
        foreach((array)$setting as $configkey => $configval){
            if($configkey == 'password'){
                self::$config[$configkey] = Crypt::decrypt($configval);
            }else{
                self::$config[$configkey] = $configval;
            }
        }
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            extract(self::$config);
            Config::set('database.connections.pbxmysql.host',$dbserver);
            Config::set('database.connections.pbxmysql.database',self::$dbname2);
            Config::set('database.connections.pbxmysql.username',$username);
            Config::set('database.connections.pbxmysql.password',$password);

        }
    }
    public static function testConnection(){
        $response = array();
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{
                if(DB::connection('pbxmysql')->getDatabaseName()){
                    $response['result'] = 'OK';
                }
            }catch(Exception $e){
                $response['faultString'] =  $e->getMessage();
                $response['faultCode'] =  $e->getCode();
            }
        }
        return $response;
    }

    public static function getAccountCDRs($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{
                $query = "select c.src, c.ID,c.`start`,c.`end`,c.duration,c.billsec,c.realsrc as extension,c.accountcode,c.firstdst,c.lastdst,coalesce(sum(cc_cost)) as cc_cost,c.pincode, c.userfield,IFNULL(cc_type ,'') as cc_type,disposition,IFNULL(cc.cc_peername,'') as cc_peername,IFNULL(cc.cc_buy,'') as cc_buy
                    from asteriskcdrdb.cdr c
                    left outer join asterisk.cc_callcosts cc on
                     c.uniqueid=cc.cc_uniqueid and ( c.sequence=cc.cc_cdr_sequence or (c.sequence is null and cc.cc_cdr_sequence=0 ) ) /*-- Given by mirta same as in their front end.*/
                    where `end` >= '" . $addparams['start_date_ymd'] . "' and `end` < '" . $addparams['end_date_ymd'] . "'
                    AND (
                           userfield like '%outbound%'
                        or userfield like '%inbound%'
                        or ( userfield = '' AND  IFNULL(cc_type ,'') <> 'OUTNOCHARGE' )  /*-- Ignore Internal call*/
                        )
                    AND ( dst<>'h' or duration <> 0 ) /*-- given by mirta*/
                    AND IFNULL(cc_type ,'') <> 'OUTNOCHARGE'
                    and prevuniqueid=''
                    group by ID,c.`start`,c.`end`,realsrc,firstdst,duration,billsec,userfield,uniqueid,prevuniqueid,lastdst,dst,pincode,IFNULL(cc_type ,'')
                    "; // and userfield like '%outbound%'  removed for inbound calls
                Log::info($query);
                $response = DB::connection('pbxmysql')->select($query);
            }catch(Exception $e){
                $response['faultString'] =  $e->getMessage();
                $response['faultCode'] =  $e->getCode();
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $e->getCode(). ", Reason: " . $e->getMessage());
                throw new Exception($e->getMessage());
            }
        }
        return $response;

    }
    public static function blockAccount($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{
                $count = DB::connection('pbxmysql')->table('te_tenants')->where('te_code', $addparams['te_code'])->count();
                $disabled = DB::connection('pbxmysql')->table('te_tenants')->where('te_code', $addparams['te_code'])->pluck('te_disabled');
                if($disabled == '' && $count) {
                    DB::connection('pbxmysql')->table('te_tenants')->where('te_code', $addparams['te_code'])->update(array('te_disabled'=>'on'));
                    $response = array('message'=>'account blocked');
                }
            }catch(Exception $e){
                $response['faultString'] =  $e->getMessage();
                $response['faultCode'] =  $e->getCode();
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $e->getCode(). ", Reason: " . $e->getMessage());
                throw new Exception($e->getMessage());
            }
        }
        return $response;
    }

    public static function unBlockAccount($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{
                $disabled = DB::connection('pbxmysql')->table('te_tenants')->where('te_code', $addparams['te_code'])->pluck('te_disabled');
                if($disabled == 'on') {
                    DB::connection('pbxmysql')->table('te_tenants')->where('te_code', $addparams['te_code'])->update(array('te_disabled'=> ''));
                    $response = array('message'=>'account unblocked');
                }
            }catch(Exception $e){
                $response['faultString'] =  $e->getMessage();
                $response['faultCode'] =  $e->getCode();
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $e->getCode(). ", Reason: " . $e->getMessage());
                throw new Exception($e->getMessage());
            }
        }
        return $response;
    }

    public static function getAccountPayments($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{
                $query = "select bi_id, bi_te_id, bi_description, bi_date, bi_amount, te_code
                          from
                            bi_billings as bi inner join  te_tenants as te on bi.bi_te_id=te.te_id
                          where
                           `bi_date` >= '" . $addparams['start_date_ymd'] . "' and `bi_date` < '" . $addparams['end_date_ymd'] . "'
                          ";
                Log::info($query);
                $response = DB::connection('pbxmysql')->select($query);
            }catch(Exception $e){
                $response['faultString'] =  $e->getMessage();
                $response['faultCode'] =  $e->getCode();
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $e->getCode(). ", Reason: " . $e->getMessage());
                throw new Exception($e->getMessage());
            }
        }
        return $response;
    }

    public static function getAccountTenantsID($code){
        $response = null;
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{
                $response  = DB::connection('pbxmysql')->table('te_tenants')->where('te_code', $code)->pluck('te_id');
            }catch(Exception $e){
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $e->getCode(). ", Reason: " . $e->getMessage());
                throw new Exception($e->getMessage());
            }
        }
        return $response;
    }

    public static function insertBillings($arrInsert=array()){
        $count = 0;
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{
                foreach($arrInsert as $insert){
                    $where=array();
                    $where["bi_date"]=$insert["bi_date"];
                    $where["bi_description"]=$insert["bi_description"];
                    $where["bi_amount"]=$insert["bi_amount"];
                    $where["bi_te_id"]=$insert["bi_te_id"];

                    if(DB::connection('pbxmysql')->table('bi_billings')->where($where)->count()==0){
                        DB::connection('pbxmysql')->table('bi_billings')->insert($insert);
                        $count++;
                    }
                }
            }catch(Exception $e){
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $e->getCode(). ", Reason: " . $e->getMessage());
                throw new Exception($e->getMessage());
            }
        }
        return $count;
    }

    // delete from pbx which is recall payment in neon
    public static function deleteRecallID($paymentArr=array()){
        $response = null;
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{

                $where=array();
                $where["bi_date"]=$paymentArr["bi_date"];
                $where["bi_te_id"]=$paymentArr["bi_te_id"];
                $where["bi_description"]=$paymentArr["bi_description"];
                if(DB::connection('pbxmysql')->table('bi_billings')->where($where)->count()>0){
                    DB::connection('pbxmysql')->table('bi_billings')->where($where)->delete();
                }
            }catch(Exception $e){
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $e->getCode(). ", Reason: " . $e->getMessage());
                throw new Exception($e->getMessage());
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
                    $list = DB::connection('pbxmysql')
                        ->table('cl_clientrates')
                        ->lists('cl_name', 'cl_id');

                    $insertData = [];
                    foreach ($rateTables as $key => $rateTable)
                        if (!in_array($rateTable, $list)) {
                            $insertData[] = [
                                'cl_name' => $rateTable,
                                'cl_description' => '',
                                'cl_customratescript' => '',
                                'cl_ratescripttech' => 'AGI'
                            ];
                        }

                    if (!empty($insertData))
                        DB::connection('pbxmysql')
                            ->table('cl_clientrates')->insert($insertData);

                    $response = DB::connection('pbxmysql')
                        ->table('cl_clientrates')
                        ->whereIn('cl_name', $rateTables)
                        ->lists('cl_name', 'cl_id');
                }

            }catch(Exception $e){
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $e->getCode(). ", Reason: " . $e->getMessage());
                throw new Exception($e->getMessage());
            }
        }
        return $response;
    }

    public static $pbxRates;
    public static $pbxInsertRates;
    public static $pbxUpdateRates;

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
                    $rates = DB::connection('pbxmysql')->table('ra_rates')
                        ->join('cl_clientrates', 'cl_clientrates.cl_id', '=', 'ra_rates.ra_cl_id')
                        ->select([
                            'ra_id',
                            'cl_name', // RateTable Name
                            'ra_prefix', // Code
                            'ra_country', // Country Prefix
                            'ra_cost'
                        ])->where('ra_cl_id', $cl_id);

                    self::$pbxRates = [];
                    $rates->chunk(10000, function ($chunk) {
                        foreach ($chunk as $item)
                            self::$pbxRates[$item->ra_prefix] = $item;
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
                        //Log::info("Rates Proceeding: " . $chunk->count());

                        foreach ($chunk as $arr) {

                            if (isset(self::$pbxRates[$arr->Code])) {
                                if (number_format(self::$pbxRates[$arr->Code]->ra_cost, 5) != number_format($arr->Rate, 5)) {
                                    self::$pbxUpdateRates[] = [
                                        'ra_id' => self::$pbxRates[$arr->Code]->ra_id,
                                        'ra_cost' => number_format($arr->Rate, 5)
                                    ];
                                }

                            } else {
                                self::$pbxInsertRates[] = [
                                    'ra_cl_id'        => $cl_id,
                                    'ra_prefix'       => $arr->Code,
                                    'ra_country'      => $arr->Prefix === NULL ? '' : $arr->Prefix,
                                    'ra_network'      => $arr->Prefix === NULL ? '' : $arr->Prefix,
                                    'ra_cost'         => $arr->Rate,
                                    'ra_setup'        => $arr->ConnectionFee === NULL ? 0 : $arr->ConnectionFee,
                                    'ra_roundingtime' => $arr->Interval1,
                                    'ra_minimumcost'  => 0,
                                    'ra_roundingcost' => $arr->RoundChargedAmount === NULL ? 5 : $arr->RoundChargedAmount,
                                ];
                            }
                        }

                        Log::info("Insert: " . count(self::$pbxInsertRates) . ", Update: " . count(self::$pbxUpdateRates));
                        sleep(1);
                    });

                    if (!empty(self::$pbxInsertRates))
                        foreach (array_chunk(self::$pbxInsertRates, 1500) as $insertData) {
                            DB::connection('pbxmysql')->table('ra_rates')->insert($insertData);
                        }

                    if (!empty(self::$pbxUpdateRates))
                        foreach (self::$pbxUpdateRates as $key => $updateData) {
                            DB::connection('pbxmysql')->table('ra_rates')
                                ->where('ra_id', $updateData['ra_id'])
                                ->update(['ra_cost' => $updateData['ra_cost']]);
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


    /** Update Vendor Rates */

    public static function updateVendorRateTables($vendors = []){
        $response = null;
        //dd(self::$config);
        if(count(self::$config) && isset(self::$config['dbserver']) && isset(self::$config['username']) && isset(self::$config['password'])){
            try{
                if(!empty($vendors)) {
                    $list = DB::connection('pbxmysql')
                        ->table('pr_providers')
                        ->lists('pr_peername', 'pr_id');

                    $insertData = [];
                    foreach ($vendors as $key => $vendorNumber)
                        if (!in_array($vendorNumber, $list)) {
                            $insertData[] = [
                                'pr_name'           => $vendorNumber,
                                'pr_peername'       => $vendorNumber,
                                'pr_tech'           => '',
                                'pr_penalty'        => 0,
                                'pr_header1'        => '',
                                'pr_header2'        => '',
                                'pr_header3'        => '',
                                'pr_disabled'       => '',
                                'pr_ca_id'          => 0,
                                'pr_tech_id'        => 0,
                                'pr_userealtime'    => '',
                                'pr_adddigits'      => '',
                                'pr_deldigits'      => '',
                                'pr_callerpres'     => '',
                                'pr_smsurl'         => '',
                                'pr_smspost'        => '',
                                'pr_smsuser'        => '',
                                'pr_smspassword'    => '',
                                'pr_calleridregex'  => '',
                                'pr_smsprotocol'    => '',
                                'pr_smsprovider'    => '',
                                'pr_header4'        => '',
                                'pr_header5'        => '',
                                'pr_header6'        => '',
                            ];
                        }

                    if (!empty($insertData))
                        DB::connection('pbxmysql')
                            ->table('pr_providers')->insert($insertData);
                    Log::info("Total Inserted Vendors: " . count($insertData));

                    $response = DB::connection('pbxmysql')
                        ->table('pr_providers')
                        ->whereIn('pr_peername', $vendors)
                        ->lists('pr_peername', 'pr_id');
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
                    Log::info("Starting ------ Vendor Number: " . $pbxVendor . " ------");
                    $rates = DB::connection('pbxmysql')->table('pc_providercosts')
                        ->join('pr_providers', 'pr_providers.pr_id', '=', 'pc_providercosts.pc_pr_id')
                        ->select([
                            'pc_id',
                            'pr_peername', // Account Number
                            'pc_prefix', // Code
                            'pc_country', // Country Prefix
                            'pc_code',
                            'pc_cost'
                        ])->where('pc_pr_id', $pr_id);

                    self::$pbxRates = [];
                    $rates->chunk(10000, function ($chunk) {
                        foreach ($chunk as $item)
                            self::$pbxRates[$item->pc_prefix] = $item;
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
                        ])->where([
                            'tblAccount.VerificationStatus'  => Account::VERIFIED,
                            'tblAccount.IsVendor'			 => 1,
                            'tblAccount.CompanyID'			 => $CompanyID,
                            'tblAccount.Number'              => $pbxVendor
                        ])->whereDate('tblVendorRate.EffectiveDate', "<=", date('Y-m-d'))
                        ->groupBy('tblRate.Code');

                    //Log::info($rateQ->toSql());
                    //Log::info("Total Available Rates: " . $rateQ->count());

                    self::$pbxInsertRates = [];
                    self::$pbxUpdateRates = [];

                    $rateQ->chunk(10000, function ($chunk) use ($pr_id, $pbxVendor) {
                        //Log::info("Rates Proceeding: " . $chunk->count());

                        foreach ($chunk as $arr) {

                            if (isset(self::$pbxRates[$arr->Code])) {
                                if (number_format(self::$pbxRates[$arr->Code]->pc_cost, 5) != number_format($arr->Rate, 5)) {
                                    self::$pbxUpdateRates[] = [
                                        'pc_id' => self::$pbxRates[$arr->Code]->pc_id,
                                        'pc_cost' => number_format($arr->Rate, 5)
                                    ];
                                }

                            } else {
                                self::$pbxInsertRates[] = [
                                    'pc_pr_id'        => $pr_id,
                                    'pc_prefix'       => $arr->Code,
                                    'pc_code'         => $arr->Code,
                                    'pc_country'      => $arr->Prefix === NULL ? '' : $arr->Prefix,
                                    'pc_network'      => $arr->Prefix === NULL ? '' : $arr->Prefix,
                                    'pc_cost'         => $arr->Rate,
                                    'pc_setup'        => $arr->ConnectionFee === NULL ? 0 : $arr->ConnectionFee,
                                    'pc_roundingtime' => $arr->Interval1,
                                    'pc_minimumcost'  => $arr->MinimumCost === NULL ? 0 : $arr->MinimumCost,
                                    'pc_roundingcost' => 5,
                                    'pc_parent_id'    => 0,
                                ];
                            }
                        }

                        Log::info("Insert: " . count(self::$pbxInsertRates) . ", Update: " . count(self::$pbxUpdateRates));
                        sleep(1);
                    });


                    if (!empty(self::$pbxInsertRates))
                        foreach (array_chunk(self::$pbxInsertRates, 1500) as $insertData) {
                            DB::connection('pbxmysql')->table('pc_providercosts')->insert($insertData);
                        }

                    if (!empty(self::$pbxUpdateRates))
                        foreach (self::$pbxUpdateRates as $key => $updateData) {
                            DB::connection('pbxmysql')->table('pc_providercosts')
                                ->where('pc_id', $updateData['pc_id'])
                                ->update(['pc_cost' => $updateData['pc_cost']]);
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