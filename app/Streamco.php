<?php
namespace App;

use App\Lib\Account;
use App\Lib\CodeDeck;
use App\Lib\Currency;
use App\Lib\CustomerTrunk;
use App\Lib\GatewayAPI;
use App\Lib\LastPrefixNo;
use App\Lib\NeonExcelIO;
use App\Lib\Trunk;
use App\Lib\VendorTrunk;
use Collective\Remote\RemoteFacade;
use Exception;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class Streamco{
    private static $config = array();
    private static $cli;
    private static $timeout=0; /* 60 seconds timeout */
    private static $dbname1 = 'storage';

   public function __construct($CompanyGatewayID){
       $setting = GatewayAPI::getSetting($CompanyGatewayID,'Streamco');
       foreach((array)$setting as $configkey => $configval){
           if($configkey == 'dbpassword' || $configkey == 'password'){
               self::$config[$configkey] = Crypt::decrypt($configval);
           }else{
               self::$config[$configkey] = $configval;
           }
       }
       if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['dbusername']) && isset(self::$config['dbpassword'])){
           extract(self::$config);
           Config::set('database.connections.pbxmysql.host',$host);
           Config::set('database.connections.pbxmysql.database',self::$dbname1);
           Config::set('database.connections.pbxmysql.username',$dbusername);
           Config::set('database.connections.pbxmysql.password',$dbpassword);
       }

       // ssh detail
       if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['username']) && isset(self::$config['password'])){
           Config::set('remote.connections.production.host',self::$config['host']);
           Config::set('remote.connections.production.username',self::$config['username']);
           Config::set('remote.connections.production.password',self::$config['password']);
       }

       Log::info(self::$config);

   }
   
    public static function getAccountCDRs($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['dbusername']) && isset(self::$config['dbpassword'])){
            try{

                $query = "select com.name as username,c.caller_id as  cli,c.callee_id as cld, c.ID as ID ,c.start_time as connect_time,c.end_time as disconnect_time ,c.total_seconds as duration,c.answered_seconds as billed_second,price as cost,hangup_cause as disposition,code as prefix
                    from originator_billed_cdr c
                    left join config.originators u on c.originator_id = u.id
                    left join config.companies com on com.id = u.company_id
                    where `end_time` >= '" . $addparams['start_date_ymd'] . "' and `end_time` < '" . $addparams['end_date_ymd'] . "'";

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
    public static function getVAccountCDRs($addparams=array()){
        $response = array();
        if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['dbusername']) && isset(self::$config['dbpassword'])){
            try{

                $query = "select com.name as providername,c.caller_id as  cli,c.callee_id as cld,IFNULL(cc.ID,c.ID) as ID, c.ID as ID2,c.start_time as connect_time,c.end_time as disconnect_time ,c.total_seconds as duration,c.answered_seconds as billed_second,c.price as provider_price,c.hangup_cause as disposition,c.code as provider_prefix,cc.price as cost
                    from terminator_billed_cdr c
                    left join config.terminators u on c.terminator_id = u.id
                    left join originator_billed_cdr cc on c.call_id = cc.call_id
                    left join config.companies com on com.id = u.company_id
                    where c.`end_time` >= '" . $addparams['start_date_ymd'] . "' and c.`end_time` < '" . $addparams['end_date_ymd'] . "'";

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
    /** get list of array of files
     * @return array
     */
    public function getCustomerRateFile($FileLocationFrom=''){

        $response = array();
        if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['username']) && isset(self::$config['password'])){
            $filename = array();
            $files =  RemoteFacade::nlist($FileLocationFrom);
            foreach((array)$files as $file){
                if(strpos($file,'.csv') !== false && strpos($file,'customer_rate') !== false){
                    $filename[] =$file;
                }
            }
            asort($filename);
            $filename = array_values($filename);
            //$lastele = array_pop($filename); no pop required now
            $response = $filename;
        }
        return $response;

    }

    /** get list of array of files
     * @return array
     */
    public function getVendorRateFile($FileLocationFrom=''){

        $response = array();
        if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['username']) && isset(self::$config['password'])){
            $filename = array();
            $files =  RemoteFacade::nlist($FileLocationFrom);
            foreach((array)$files as $file){
                if(strpos($file,'.csv') !== false && strpos($file,'vendor_rate') !== false){
                    $filename[] =$file;
                }
            }
            asort($filename);
            $filename = array_values($filename);
            //$lastele = array_pop($filename); no pop required now
            $response = $filename;
        }
        return $response;

    }


    /** download ratesheet file
     * @param array $addparams
     * @return bool
     */
    public static function downloadRemoteFile($addparams=array()){
        $status = false;
        if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['username']) && isset(self::$config['password'])){
            $downloading_path = $addparams['download_path'] .'/'. str_random(20); // basename($addparams['filename']);
            $new_path = $addparams['download_path'] .'/'. $addparams['filename'];
            $status = RemoteFacade::get($addparams['FileLocationFrom'] .'/'. $addparams['filename'], $downloading_path);
            if(!rename( $downloading_path , $new_path )){
                @unlink($downloading_path);
            }
        }
        return $status;
    }

    public static function getFileContent($FilePath){

        if (file_exists($FilePath)) {

            $NeonExcel = new NeonExcelIO($FilePath,["Delimiter"=>",","Enclosure"=>'']);
            return $results = $NeonExcel->read();
        }
        return false;

    }
    public static function importStreamcoAccounts($addparams=array()) {
        // same code in web/Streamco.php@getAccountsDetail()
        // if you change anything here than you also have to change there
        $response = array();
        if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['dbusername']) && isset(self::$config['dbpassword'])){
            try{
                $currency = Currency::getCurrencyDropdownIDList($addparams['CompanyID']);
                $dbname = 'config';
                $query = "SELECT DISTINCT
                              c.name,c.address,c.email,c.invoice_email,o.company_id,cu.name AS currency,IF(o.company_id,1,0) AS IsCustomer,IF(t.company_id,1,0) AS IsVendor
                          FROM
                              ".$dbname.".companies AS c
                          LEFT JOIN
                              ".$dbname.".originators AS o ON o.company_id = c.id
                          LEFT JOIN
                              ".$dbname.".terminators AS t ON t.company_id = c.id
                          LEFT JOIN
                              ".$dbname.".currencies AS cu ON c.balance_currency_id=cu.id";
                $results = DB::connection('pbxmysql')->select($query);
                if(count($results)>0){
                    $tempItemData = array();
                    $batch_insert_array = array();
                    if(count($addparams)>0){
                        $CompanyGatewayID = $addparams['CompanyGatewayID'];
                        $CompanyID = $addparams['CompanyID'];
                        $ProcessID = $addparams['ProcessID'];
                        foreach ($results as $temp_row) {
                            $count = Account::where(["AccountName" => $temp_row->name, "AccountType" => 1,"CompanyId"=>$CompanyID])->count();
                            if($count==0){
                                $tempItemData['AccountName'] = $temp_row->name;
                                $tempItemData['FirstName'] = "";
                                $tempItemData['Address1'] = $temp_row->address;
                                $tempItemData['Phone'] = "";
                                $tempItemData['BillingEmail'] = $temp_row->invoice_email;
                                $tempItemData['Email'] = $temp_row->email;
                                $tempItemData['Currency'] = array_search($temp_row->currency,$currency) ? array_search($temp_row->currency,$currency):null;
                                $tempItemData['AccountType'] = 1;
                                $tempItemData['CompanyId'] = $CompanyID;
                                $tempItemData['Status'] = 1;
                                $tempItemData['IsCustomer'] = $temp_row->IsCustomer;
                                $tempItemData['IsVendor'] = $temp_row->IsVendor;
                                $tempItemData['LeadSource'] = 'Gateway import';
                                $tempItemData['CompanyGatewayID'] = $CompanyGatewayID;
                                $tempItemData['ProcessID'] = $ProcessID;
                                $tempItemData['created_at'] = $addparams['ImportDate'];
                                $tempItemData['created_by'] = 'Imported';
                                $batch_insert_array[] = $tempItemData;
                            }
                        }
                        if (!empty($batch_insert_array)) {
                            //Log::info('insertion start');
                            try{
                                if(DB::table('tblTempAccount')->insert($batch_insert_array)){
                                    $response['result'] = 'OK';
                                }
                            }catch(Exception $err){
                                $response['faultString'] =  $err->getMessage();
                                $response['faultCode'] =  $err->getCode();
                                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $err->getCode(). ", Reason: " . $err->getMessage());
                                //throw new Exception($err->getMessage());
                            }
                            //Log::info('insertion end');
                        }else{
                            $response['result'] = 'OK';
                        }
                    }
                }
            }catch(Exception $e){
                $response['faultString'] =  $e->getMessage();
                $response['faultCode'] =  $e->getCode();
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $e->getCode(). ", Reason: " . $e->getMessage());
                //throw new Exception($e->getMessage());
            }
        }
        return $response;
    }

    public static function importStreamcoTrunks($addparams=array()) {
        $response = array();
        if(count(self::$config) && isset(self::$config['host']) && isset(self::$config['dbusername']) && isset(self::$config['dbpassword'])){
            try{
                $dbname = 'config';
                $totaltrunksinserted = 0;
                $totalcustomerstrunksinserted = 0;
                $totalvendorstrunksinserted = 0;
                $created_at = date('Y-m-d H:i:s');
                $CreatedBy = 'auto import account';
                $queryo = "SELECT
                              c.name AS AccountName,o.name AS TrunkName,IF(o.company_id,1,0) AS IsCustomer
                          FROM
                              ".$dbname.".companies AS c
                          LEFT JOIN
                              ".$dbname.".originators AS o ON o.company_id = c.id
                          WHERE o.enabled='yes'";
                $resultso = DB::connection('pbxmysql')->select($queryo);
                if(count($resultso)>0){
                    if(count($addparams)>0){
                        $CompanyID = $addparams['CompanyID'];
                        foreach ($resultso as $temp_row) {
                            $account = Account::where(["AccountName" => $temp_row->AccountName, "AccountType" => 1,"CompanyId"=>$CompanyID]);
                            if($account->count()>0){
                                $AccountID = $account->first()->AccountID;
                                $Trunk = Trunk::where(["Trunk"=>$temp_row->TrunkName, "CompanyID"=>$CompanyID]);
                                if($Trunk->count() > 0) {
                                    $TrunkID = $Trunk->first()->TrunkID;
                                } else {
                                    $trunkdata['Trunk'] = $temp_row->TrunkName;
                                    $trunkdata['CompanyID'] = $CompanyID;
                                    $trunkdata['Status'] = 1;
                                    $trunkdata['created_at'] = $created_at;
                                    $TrunkID = Trunk::insertGetId($trunkdata);
                                    $totaltrunksinserted++;
                                }
                                $CustomerTrunk = CustomerTrunk::where(["TrunkID"=>$TrunkID, "AccountID"=>$AccountID, "CompanyID"=>$CompanyID])->count();
                                if($CustomerTrunk == 0) {
                                    $customertrunkdata = array();
                                    $CodeDeckID = CodeDeck::getDefaultCodeDeckID();
                                    $customertrunkdata['CompanyID'] = $CompanyID;
                                    $customertrunkdata['AccountID'] = $AccountID;
                                    $customertrunkdata['TrunkID'] = $TrunkID;
                                    $customertrunkdata['Status'] = 1;
                                    $customertrunkdata['Prefix'] = LastPrefixNo::getLastPrefix($CompanyID);
                                    $customertrunkdata['CodeDeckID'] = $CodeDeckID;
                                    $customertrunkdata['created_at'] = $created_at;
                                    $customertrunkdata['CreatedBy'] = $CreatedBy;
                                    CustomerTrunk::insert($customertrunkdata);
                                    LastPrefixNo::updateLastPrefixNo($customertrunkdata['Prefix'],$CompanyID);
                                    $totalcustomerstrunksinserted++;
                                }
                            }
                        }
                    }
                }
                $queryt = "SELECT
                              c.name AS AccountName,t.name AS TrunkName,IF(t.company_id,1,0) AS IsVendor
                          FROM
                              ".$dbname.".companies AS c
                          LEFT JOIN
                              ".$dbname.".terminators AS t ON t.company_id = c.id
                          WHERE t.enabled='yes'";
                $resultst = DB::connection('pbxmysql')->select($queryt);
                if(count($resultst)>0){
                    if(count($addparams)>0){
                        $CompanyID = $addparams['CompanyID'];
                        foreach ($resultst as $temp_row) {
                            $account = Account::where(["AccountName" => $temp_row->AccountName, "AccountType" => 1,"CompanyId"=>$CompanyID]);
                            if($account->count()>0){
                                $AccountID = $account->first()->AccountID;
                                $Trunk = Trunk::where(["Trunk"=>$temp_row->TrunkName, "CompanyID"=>$CompanyID]);
                                if($Trunk->count() > 0) {
                                    $TrunkID = $Trunk->first()->TrunkID;
                                } else {
                                    $trunkdata['Trunk'] = $temp_row->TrunkName;
                                    $trunkdata['CompanyID'] = $CompanyID;
                                    $trunkdata['Status'] = 1;
                                    $trunkdata['created_at'] = $created_at;
                                    $TrunkID = Trunk::insertGetId($trunkdata);
                                    $totaltrunksinserted++;
                                }
                                $VendorTrunk = VendorTrunk::where(["TrunkID"=>$TrunkID, "AccountID"=>$AccountID, "CompanyID"=>$CompanyID])->count();
                                if($VendorTrunk == 0) {
                                    $vendortrunkdata = array();
                                    $CodeDeckID = CodeDeck::getDefaultCodeDeckID();
                                    $vendortrunkdata['CompanyID'] = $CompanyID;
                                    $vendortrunkdata['AccountID'] = $AccountID;
                                    $vendortrunkdata['TrunkID'] = $TrunkID;
                                    $vendortrunkdata['Status'] = 1;
                                    $vendortrunkdata['CodeDeckID'] = $CodeDeckID;
                                    $vendortrunkdata['created_at'] = $created_at;
                                    $vendortrunkdata['CreatedBy'] = $CreatedBy;
                                    VendorTrunk::insert($vendortrunkdata);
                                    $totalvendorstrunksinserted++;
                                }
                            }
                        }
                    }
                }
                Log::info($totaltrunksinserted.' Trunks inserted');
                Log::info($totalcustomerstrunksinserted.' Customer Trunks inserted');
                Log::info($totalvendorstrunksinserted.' Vendor Trunks inserted');
            }catch(Exception $e){
                $response['faultString'] =  $e->getMessage();
                $response['faultCode'] =  $e->getCode();
                Log::error("Class Name:".__CLASS__.",Method: ". __METHOD__.", Fault. Code: " . $e->getCode(). ", Reason: " . $e->getMessage());
                //throw new Exception($e->getMessage());
            }
        }
        return $response;
    }
}