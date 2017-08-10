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
        return self::$cache;
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

    public static function getName($CompanyID,$CompanyGatewayID,$AccountID,$account){
        $AccountNames = array();
        $NameFormat = $AccountName = '';
        $CompanyGatewayConfig = self::getCompanyConfig($CompanyID,$CompanyGatewayID);
        $AccountAuthenticate = self::getAccountAuthRule($CompanyID,$AccountID);
        if(!empty($AccountAuthenticate) && count($AccountAuthenticate)){
            $NameFormat = $AccountAuthenticate->CustomerAuthRule;
            $AccountName = $AccountAuthenticate->CustomerAuthValue;
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
                $file_name = Job::getfileName($account->AccountID, $account->Trunk, '');
                $local_file = $destination . '/customer_' . $file_name.'.csv';
                $account_name = Customer::getName($account->CompanyId,$CompanyGatewayID,$account->AccountID,$account);
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
                $account_name = Customer::getName($account->CompanyId,$CompanyGatewayID,$account->AccountID,$account);
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

}