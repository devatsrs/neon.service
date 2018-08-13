<?php

namespace App\Lib;

use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class Customer extends \Eloquent {
    protected $fillable = [];
    protected $guarded = array('AccountID');
    protected $table = 'tblAccount';

    protected  $primaryKey = "AccountID";
    static protected  $enable_cache = true;
    public static $cache = ["CompanyGatewayConfig","AccountAuthenticate"];

    public static function getCompanyConfig($CompanyID,$CompanyGatewayID){
        $CompanyGatewayConfig = 'CompanyGatewayConfig' . $CompanyGatewayID;
        if (self::$enable_cache && Cache::has($CompanyGatewayConfig)) {
            $cache = Cache::get($CompanyGatewayConfig);
            self::$cache['CompanyGatewayConfig'] = $cache['CompanyGatewayConfig'];
        } else {
            self::$cache['CompanyGatewayConfig'] = json_decode(CompanyGateway::getCompanyGatewayConfig($CompanyGatewayID),true);
            $CACHE_EXPIRE = CompanyConfiguration::get($CompanyID,'CACHE_EXPIRE');
            $time = empty($CACHE_EXPIRE)?60:$CACHE_EXPIRE;
            $minutes = \Carbon\Carbon::now()->addMinutes($time);
            Cache::add($CompanyGatewayConfig, array('CompanyGatewayConfig' => self::$cache['CompanyGatewayConfig']), $minutes);
        }
        return self::$cache['CompanyGatewayConfig'];
    }

    public static function getAccountAuthRule($CompanyID,$AccountID){
        $AccountAuthenticate = 'AccountAuthenticate' . $AccountID;
        if (self::$enable_cache && Cache::has($AccountAuthenticate)) {
            $cache = Cache::get($AccountAuthenticate);
            self::$cache['AccountAuthenticate'] = $cache['AccountAuthenticate'];
        } else {
            self::$cache['AccountAuthenticate'] = DB::table('tblAccountAuthenticate')->where(['AccountID'=>$AccountID])->first();
            $CACHE_EXPIRE = CompanyConfiguration::get($CompanyID,'CACHE_EXPIRE');;
            $time = empty($CACHE_EXPIRE)?60:$CACHE_EXPIRE;
            $minutes = \Carbon\Carbon::now()->addMinutes($time);
            Cache::add($AccountAuthenticate, array('AccountAuthenticate' => self::$cache['AccountAuthenticate']), $minutes);
        }
        return self::$cache['AccountAuthenticate'];
    }

    public static function getName($CompanyID,$CompanyGatewayID,$AccountID,$account,$CV){
        $AccountNames = array();
        $NameFormat = $AccountName = '';
        $CompanyGatewayConfig = self::getCompanyConfig($CompanyID,$CompanyGatewayID);
        $AccountAuthenticate = self::getAccountAuthRule($CompanyID,$AccountID);
        if(!empty($AccountAuthenticate) && count($AccountAuthenticate) && !empty($AccountAuthenticate->CustomerAuthRule) && $CV == 'customer'){
            $NameFormat = $AccountAuthenticate->CustomerAuthRule;
            $AccountName = $AccountAuthenticate->CustomerAuthValue;
        }elseif(!empty($AccountAuthenticate) && count($AccountAuthenticate) && !empty($AccountAuthenticate->VendorAuthRule) && $CV == 'vendor'){
            $NameFormat = $AccountAuthenticate->VendorAuthRule;
            $AccountName = $AccountAuthenticate->VendorAuthValue;
        }
        if(empty($NameFormat)){
            $NameFormat = $CompanyGatewayConfig['NameFormat'];
        }
        $AccountNames['NameFormat'] = $NameFormat;

        switch ($NameFormat){
            case  'NAMENUB':
                $AccountNames['AccountName'] =  $account->AccountName.'-'.$account->Number;
                return $AccountNames;
                break;
            case  'NUBNAME':
                $AccountNames['AccountName'] =  $account->Number.'-'.$account->AccountName;
                return $AccountNames;
                break;
            case  'NAME':
                $AccountNames['AccountName'] =  $account->AccountName;
                return $AccountNames;
                break;
            case  'NUB':
                $AccountNames['AccountName'] =  $account->Number;
                return $AccountNames;
                break;
            case  'IP':
                $AccountNames['AccountName'] =  $AccountName;
                return $AccountNames;
                break;
            case  'CLI':
                $AccountNames['AccountName'] =  $AccountName;
                return $AccountNames;
                break;
            case  'Other':
                $AccountNames['AccountName'] =  $AccountName;
                return $AccountNames;
                break;
        }

    }



    public static function generateCustomerFile($CompanyID,$cronsetting){
        $response['error'] = $response['message']  = array();
        $file_count = 0;
        $FileLocation = $cronsetting['FileLocation'];
        $CompanyGatewayID = $cronsetting['CompanyGatewayID'];
        $Effective = 'Now';
        if(!empty($cronsetting['Effective'])){
            $Effective = $cronsetting['Effective'];
        }
        if (isset($cronsetting["customers"]) && !empty($cronsetting["customers"])) {
            $accounts_array = $cronsetting["customers"];

            $account = Account::join('tblCustomerTrunk', 'tblAccount.AccountID', '=', 'tblCustomerTrunk.AccountID')
                ->join('tblTrunk', 'tblTrunk.TrunkID', '=', 'tblCustomerTrunk.TrunkID');
            $account->where([
                "tblAccount.CompanyId" => $CompanyID,
                "tblAccount.AccountType" => 1,
                "tblAccount.VerificationStatus" => Account::VERIFIED,
                "tblCustomerTrunk.Status" => 1,
                "tblTrunk.Status" => 1,
            ]);
            $account->whereIN('tblAccount.AccountID',$accounts_array);
        }else{
            $account = Account::join('tblCustomerTrunk', 'tblAccount.AccountID', '=', 'tblCustomerTrunk.AccountID')
                ->join('tblTrunk', 'tblTrunk.TrunkID', '=', 'tblCustomerTrunk.TrunkID');
            $account->where([
                "tblAccount.CompanyId" => $CompanyID,
                "tblAccount.AccountType" => 1,
                "tblAccount.VerificationStatus" => Account::VERIFIED,
                "tblCustomerTrunk.Status" => 1,
                "tblTrunk.Status" => 1,

            ]);
        }
        $destination = $FileLocation.'/'.$CompanyGatewayID;
        if (!file_exists($destination)) {
            mkdir($destination, 0777, true);
        }
        $accounts = $account->select('tblAccount.*','tblTrunk.*','tblCustomerTrunk.Prefix AS CustomerTrunkPrefix')->get();
        foreach ($accounts as $account) {
            try {
                $file_name = Job::getfileName($account->AccountID, $account->TrunkID, '');
                $local_file = $destination . '/customer_' . $file_name.'.csv';
                $account_name = Customer::getName($account->CompanyId,$CompanyGatewayID,$account->AccountID,$account,'customer');
                if(!empty($account_name['AccountName'])) {
                    DB::beginTransaction();
                    Log::info("CALL prc_CustomerRateForExport(" . $account->CompanyId . "," . $account->AccountID . "," . $account->TrunkID . ",'".$account_name['NameFormat']."','".$account_name['AccountName']."','" . $account->Trunk . "','".$account->CustomerTrunkPrefix."','".$Effective."')");
                    $excel_data = DB::select("CALL prc_CustomerRateForExport(" . $account->CompanyId . "," . $account->AccountID . "," . $account->TrunkID . ",'".$account_name['NameFormat']."','".$account_name['AccountName']."','" . $account->Trunk . "','".$account->CustomerTrunkPrefix."','".$Effective."')");
                    $excel_data = json_decode(json_encode($excel_data), true);
                    $output = Helper::array_to_csv($excel_data);
                    if (empty($excel_data)) {
                        $response['message'][] = ' No data found against account: ' . $account->AccountName . ' trunk: ' . $account->Trunk;
                        Log::info('No data found against account: ' . $account->AccountName . ' trunk: ' . $account->Trunk);
                    }else{
                        $response['message'][] = ' File Generated account: ' . $account->AccountName . ' trunk: ' . $account->Trunk;
                        file_put_contents($local_file, $output);
                        $file_count++;
                    }
                    DB::commit();
                    Log::info('transaction commit ');
                }
            } catch (\Exception $e) {
                $response['error'][] = 'account: ' . $account->AccountName . ' trunk: ' . $account->Trunk.' Error '.$e->getMessage();
                try {
                    DB::rollback();
                } catch (\Exception $err) {
                    Log::error($err);
                }
                Log::error('Account' . $account->AccountName . ' exception ' . $e);
            }
        }

        if($file_count){
            $response['message'][] = 'Total '.$file_count.' files generated';
        }
        return $response;
    }
    public static function generateVendorFile($CompanyID,$cronsetting){
        $response['error'] = $response['message']  = array();
        $file_count = 0;
        $FileLocation = $cronsetting['FileLocation'];
        $CompanyGatewayID = $cronsetting['CompanyGatewayID'];
        $Effective = 'Now';
        $DiscontinueRate = 'no';
        if(!empty($cronsetting['Effective'])){
            $Effective = $cronsetting['Effective'];
        }
        if(!empty($cronsetting['DiscontinueRate'])){
            $DiscontinueRate = $cronsetting['DiscontinueRate'];
        }
        if (isset($cronsetting["vendors"]) && !empty($cronsetting["vendors"])) {
            $accounts_array = $cronsetting["vendors"];

            $account = Account::join('tblVendorTrunk', 'tblAccount.AccountID', '=', 'tblVendorTrunk.AccountID')
                ->join('tblTrunk', 'tblTrunk.TrunkID', '=', 'tblVendorTrunk.TrunkID');
            $account->where([
                "tblAccount.CompanyId" => $CompanyID,
                "tblAccount.AccountType" => 1,
                "tblAccount.VerificationStatus" => Account::VERIFIED,
                "tblVendorTrunk.Status" => 1,
                "tblTrunk.Status" => 1,
            ]);
            $account->whereIN('tblAccount.AccountID',$accounts_array);
        }else{
            $account = Account::join('tblVendorTrunk', 'tblAccount.AccountID', '=', 'tblVendorTrunk.AccountID')
                ->join('tblTrunk', 'tblTrunk.TrunkID', '=', 'tblVendorTrunk.TrunkID');
            $account->where([
                "tblAccount.CompanyId" => $CompanyID,
                "tblAccount.AccountType" => 1,
                "tblAccount.VerificationStatus" => Account::VERIFIED,
                "tblVendorTrunk.Status" => 1,
                "tblTrunk.Status" => 1,
            ]);
        }

        $destination = $FileLocation.'/'.$CompanyGatewayID;
        if (!file_exists($destination)) {
            mkdir($destination, 0777, true);
        }
        $accounts = $account->select('tblAccount.*','tblTrunk.*','tblVendorTrunk.Prefix AS VendorTrunkPrefix')->get();
        foreach ($accounts as $account) {
            try {
                $file_name = Job::getfileName($account->AccountID, $account->TrunkID, '');
                $local_file = $destination . '/vendor_' . $file_name.'.csv';
                $account_name = Customer::getName($account->CompanyId,$CompanyGatewayID,$account->AccountID,$account,'vendor');
                if(!empty($account_name['AccountName'])) {
                    DB::beginTransaction();
                    Log::info("CALL prc_VendorRateForExport(" . $account->CompanyId . "," . $account->AccountID . "," . $account->TrunkID . ",'".$account_name['NameFormat']."','".$account_name['AccountName']."','" . $account->Trunk . "','".$account->VendorTrunkPrefix."','".$Effective."','".$DiscontinueRate."')");
                    $excel_data = DB::select("CALL prc_VendorRateForExport(" . $account->CompanyId . "," . $account->AccountID . "," . $account->TrunkID . ",'".$account_name['NameFormat']."','".$account_name['AccountName']."','" . $account->Trunk . "','".$account->VendorTrunkPrefix."','".$Effective."','".$DiscontinueRate."')");
                    $excel_data = json_decode(json_encode($excel_data), true);
                    $output = Helper::array_to_csv($excel_data);
                    if (empty($excel_data)) {
                        Log::info('No data found against account: ' . $account->AccountName . ' trunk: ' . $account->Trunk);
                        $response['message'][] = ' No data found against account: ' . $account->AccountName . ' trunk: ' . $account->Trunk;
                    }else{
                        $response['message'][] = ' File Generated account: ' . $account->AccountName . ' trunk: ' . $account->Trunk;
                        file_put_contents($local_file, $output);
                        $file_count++;
                    }
                    DB::commit();
                    Log::info('transaction commit ');
                }
            } catch (\Exception $e) {
                $response['error'][] = 'account: ' . $account->AccountName . ' trunk: ' . $account->Trunk.' Error '.$e->getMessage();
                try {
                    DB::rollback();
                } catch (\Exception $err) {
                    Log::error($err);
                }
                Log::error('Account' . $account->AccountName . ' exception ' . $e);
            }
        }
        if($file_count){
            $response['message'][] = 'Total '.$file_count.' files generated';
        }
        return $response;
    }

    public static function generatePushSippyRateFile($CompanyID,$cronsetting){
        $response['error']  = $response['message']  = array();
        $file_count         = 0;
        $FileLocation       = $cronsetting['FileLocation'];
        $CompanyGatewayID   = $cronsetting['CompanyGatewayID'];
        $Effective          = 'Now';
        $CustomDate         = date('Y-m-d');
        if(!empty($cronsetting['Effective'])){
            $Effective = $cronsetting['Effective'];
        }
        if (isset($cronsetting["customers"]) && !empty($cronsetting["customers"])) {
            $accounts_array = $cronsetting["customers"];

            $account = Account::join('tblCustomerTrunk', 'tblAccount.AccountID', '=', 'tblCustomerTrunk.AccountID')
                ->join('tblTrunk', 'tblTrunk.TrunkID', '=', 'tblCustomerTrunk.TrunkID');
            $account->where([
                "tblAccount.CompanyId" => $CompanyID,
                "tblAccount.AccountType" => 1,
                "tblAccount.VerificationStatus" => Account::VERIFIED,
                "tblCustomerTrunk.Status" => 1,
                "tblTrunk.Status" => 1,
            ]);
            $account->whereIN('tblAccount.AccountID',$accounts_array);
        }else{
            $account = Account::join('tblCustomerTrunk', 'tblAccount.AccountID', '=', 'tblCustomerTrunk.AccountID')
                ->join('tblTrunk', 'tblTrunk.TrunkID', '=', 'tblCustomerTrunk.TrunkID');
            $account->where([
                "tblAccount.CompanyId" => $CompanyID,
                "tblAccount.AccountType" => 1,
                "tblAccount.VerificationStatus" => Account::VERIFIED,
                "tblCustomerTrunk.Status" => 1,
                "tblTrunk.Status" => 1,
            ]);
        }
        $destination = $FileLocation.'/'.$CompanyGatewayID;
        if (!file_exists($destination)) {
            mkdir($destination, 0777, true);
        }
        $accounts = $account->distinct()->select('tblAccount.*')->get();
        $Timezones = Timezones::getTimezonesIDList();

        $SippySFTP = new SippySFTP($CompanyGatewayID);

        foreach ($accounts as $account) {
            $TrunkIDs   = CustomerTrunk::where('AccountID',$account->AccountID)->lists('TrunkID');
            $TrunkNames = Trunk::whereIn('TrunkID',$TrunkIDs)->lists('Trunk');
            $TrunkIDs   = implode(',',$TrunkIDs);
            $TrunkNames = implode(',',$TrunkNames);

            foreach ($Timezones as $TimezoneID => $TimezoneTitle) {
                try {
                    DB::beginTransaction();

                    $file_name = Job::getfileName($account->AccountID, $account->TrunkID, '');
                    $local_file = $destination . '/customer_' . $file_name.'_'.$TimezoneTitle.'_'.'.csv';

                    $query = "CALL  prc_WSGenerateSippySheet ('" .$account->AccountID . "','" . $TrunkIDs."'," . $TimezoneID.",'".$Effective."','".$CustomDate."')";
                    Log::info($query);
                    $excel_data = DB::select($query);
                    if(count($excel_data) > 0) {
                        $excel_data = json_decode(json_encode($excel_data), true);

                        //Fix .333 to 0.333 on following column
                        foreach ($excel_data as $key => $excel_val) {
                            foreach (['Price 1', 'Price N'] as $field) {
                                $excel_data[$key][$field] = number_format($excel_val[$field], 9, '.', '');
                            }
                        }

                        // generate and write data to csv file
                        $NeonExcel = new NeonExcelIO($local_file);
                        $NeonExcel->write_csv($excel_data);

                        $response['message'][] = ' File Generated account: ' . $account->AccountName . ' trunk: ' . $TrunkNames . ' timezone: ' . $TimezoneTitle;
                        $file_count++;

                        $addparam['i_upload_type'] = 1;//$SippySFTP->getDictionary();

                        $options = array();
                        try{
                            $result = $SippySFTP->getUploadToken($addparam);
                            if (!empty($result) && !isset($result['faultCode'])) {
                                if(!empty($result['token'])){
                                    //pending code to upload file
                                    $fileparam['token'] = $result['token'];
                                    $fileparam['url']   = $result['url'];
                                    $fileparam['file']  = $local_file;
                                    $upload = $SippySFTP->uploadFile($fileparam);

                                    $options['token']  = $result['token'];
                                    $options['url']    = $result['url'];

                                    $jobType    = JobType::where(["Code" => 'SRP'])->get(["JobTypeID", "Title"]);
                                    $jobStatus  = JobStatus::where(["Code" => "P"])->get(["JobStatusID"]);
                                    $jobdata['CompanyID']       = $CompanyID;
                                    $jobdata['AccountID']       = $account->AccountID;
                                    $jobdata['OutputFilePath']  = $local_file;
                                    $jobdata["JobTypeID"]       = isset($jobType[0]->JobTypeID) ? $jobType[0]->JobTypeID : '';
                                    $jobdata["JobStatusID"]     = isset($jobStatus[0]->JobStatusID) ? $jobStatus[0]->JobStatusID : '';
                                    $jobdata["Title"]           = $account->AccountName . ' ' . $TimezoneTitle . ' ' . (isset($jobType[0]->Title) ? $jobType[0]->Title : '');
                                    $jobdata["Description"]     = $account->AccountName . ' ' . $TimezoneTitle . ' ' . (isset($jobType[0]->Title) ? $jobType[0]->Title : '');
                                    $jobdata['CreatedBy']       = 'System';
                                    $jobdata["Options"]         = json_encode($options);
                                    $jobdata["created_at"]      = date('Y-m-d H:i:s');
                                    $jobdata["updated_at"]      = date('Y-m-d H:i:s');
                                    $JobID = Job::insertGetId($jobdata);

                                    $response['message'][] = ' File uploaded against account: ' . $account->AccountName . ' trunks: ' . $TrunkNames . ' timezone: ' . $TimezoneTitle;

                                    DB::commit();
                                    Log::info('transaction commit ');
                                } else {
                                    $response['error'][] = 'token not generated in sippy for account: ' . $account->AccountName . ' trunks: ' . $TrunkNames . ' timezone: ' . $TimezoneTitle;
                                }
                            } else {
                                $response['error'][] = 'account: ' . $account->AccountName . ' trunks: ' . $TrunkNames . ' timezone: ' . $TimezoneTitle.' faultCode '.$result['faultCode'].' faultString '.$result['faultString'];
                            }
                        }catch (\Exception $e) {
                            Log::error($e);
                            $response['error'][] = 'account: ' . $account->AccountName . ' trunks: ' . $TrunkNames . ' timezone: ' . $TimezoneTitle.' Error '.$e->getMessage();
                        }
                    } else {
                        $response['message'][] = ' No data found against account: ' . $account->AccountName . ' trunks: ' . $TrunkNames . ' timezone: ' . $TimezoneTitle;
                        Log::info('No data found against account: ' . $account->AccountName . ' trunks: ' . $TrunkNames . ' timezone: ' . $TimezoneTitle);
                    }
                } catch (\Exception $e) {
                    $response['error'][] = 'account: ' . $account->AccountName . ' trunks: ' . $TrunkNames . ' timezone: ' . $TimezoneTitle.' Error '.$e->getMessage();
                    try {
                        DB::rollback();
                    } catch (\Exception $err) {
                        Log::error($err);
                    }
                    Log::error('Account' . $account->AccountName . ' exception ' . $e);
                }
            }
        }

        if($file_count){
            $response['message'][] = 'Total '.$file_count.' files generated';
        }
        return $response;
    }
}