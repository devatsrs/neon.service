<?php
namespace App\Lib;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Maatwebsite\Excel\Facades\Excel;
use App\Lib\CompanySetting;

class Account extends \Eloquent {
    protected $guarded = array("AccountID");
    protected $fillable = [];
    protected $table = "tblAccount";
    protected $primaryKey = "AccountID";

    const  DETAIL_CDR = 1;
    const  SUMMARY_CDR= 2;
    const  NO_CDR = 3;
    public static $cdr_type = array(''=>'Select a CDR Type' ,self::DETAIL_CDR => 'Detail CDR',self::SUMMARY_CDR=>'Summary CDR');
    public static $req_cdr_detail_column = array('account_id','cli','cld','connect_time','disconnect_time','billed_duration_sec','cost');
    public static $req_cdr_summary_column = array('account_id','area_prefix','total_charges','total_duration','number_of_cdr');
    public static $req_cdr_detail_column_single = array('cli','cld','connect_time','disconnect_time','billed_duration_sec','cost');
    public static $req_cdr_summary_column_single = array('area_prefix','total_charges','total_duration','number_of_cdr');


    // not in use
    public static function checkExcelFormat($cdr_type,$filepath,$single=0){
        $formatstaus=  'Column are missing:';
        if(isset($cdr_type) && $cdr_type>0) {
            switch ($cdr_type){
                case Account::DETAIL_CDR:
                    if(Excel::load(Config::get('app.temp_location').basename($filepath), function($reader) {})->first()) {
                        $excel = Excel::load(Config::get('app.temp_location') . basename($filepath), function ($reader) {
                            })->first()->toArray();
                        $excel_array_key = array_keys($excel);
                        $required_array_key = Account::$req_cdr_detail_column;
                        if ($single > 0) {
                            $required_array_key = Account::$req_cdr_detail_column_single;
                        }
                        $excel_array_key = array_intersect($required_array_key, $excel_array_key);
                        if ($excel_array_key == $required_array_key) {
                            $formatstaus = 1;
                        } else {
                            $formatstaus = 'Column are missing: "' . implode('","', array_values(array_diff($required_array_key, $excel_array_key))) . '"';
                        }
                    }
                    return $formatstaus;
                case Account::SUMMARY_CDR:
                    if(Excel::load(Config::get('app.temp_location').basename($filepath), function($reader) {})->first()) {
                        $excel = Excel::load(Config::get('app.temp_location') . basename($filepath), function ($reader) {
                            })->first()->toArray();
                        $excel_array_key = array_keys($excel);
                        $required_array_key = Account::$req_cdr_summary_column;
                        if ($single > 0) {
                            $required_array_key = Account::$req_cdr_summary_column_single;
                        }
                        $excel_array_key = array_intersect($required_array_key, $excel_array_key);
                        if ($excel_array_key == $required_array_key) {
                            $formatstaus = 1;
                        } else {
                            $formatstaus = 'Column are missing: "' . implode('","', array_values(array_diff($required_array_key, $excel_array_key))) . '"';
                        }
                    }
                    return $formatstaus;
            }
        }
        return $formatstaus;
    }
    public static function checkForCDR($GatewayAccountID){
        $accountid = GatewayAccount::where(array('GatewayAccountID'=>$GatewayAccountID))->pluck('AccountID');
        $cdr_type = AccountBilling::getCDRType($accountid);
        return $cdr_type;
    }

    //not in use
    public static function getExcelFormat($filepath){
        $excel = Excel::load(Config::get('app.temp_location').basename($filepath), function($reader) {})->first()->toArray();
        $excel_array_key = array_keys($excel);
        $cdr_type = 0;
        if(Account::$req_cdr_summary_column == array_intersect(Account::$req_cdr_summary_column,$excel_array_key) ){
            $cdr_type = Account::SUMMARY_CDR;
        }elseif(Account::$req_cdr_detail_column == array_intersect(Account::$req_cdr_detail_column,$excel_array_key)){
            $cdr_type = Account::DETAIL_CDR;
        }
        return $cdr_type;
    }

    public static function getFullAddress($Account){
        $Address = "";
        $Address .= !empty($Account->Address1) ? $Account->Address1 . ',' . PHP_EOL : '';
        $Address .= !empty($Account->Address2) ? $Account->Address2 . ',' . PHP_EOL : '';
        $Address .= !empty($Account->Address3) ? $Account->Address3 . ',' . PHP_EOL : '';
        $Address .= !empty($Account->City) ? $Account->City . ',' . PHP_EOL : '';
        $Address .= !empty($Account->PostCode) ? $Account->PostCode . ',' . PHP_EOL : '';
        $Address .= !empty($Account->Country) ? $Account->Country : '';
        return $Address;

    }
    // ignore item invoice
    public static function getInvoiceCount($AccountID){
        return (int)Invoice::where(array('AccountID'=>$AccountID))
            ->Where(function($query)
            {
                $query->whereNull('ItemInvoice')
                ->orwhere('ItemInvoice', '!=', 1);

            })->count();
    }
    public static function getBillingTimeZone($AccountID){
        return AccountBilling::where(array('AccountID'=>$AccountID))->pluck('BillingTimezone');
    }
    public static function getOutstandingAmount($CompanyID,$AccountID,$decimal_places = 2){

        $query = "CALL prc_getAccountOutstandingAmount('". $CompanyID  . "',  '". $AccountID  . "')";
        $AccountOutstandingResult = DataTableSql::of($query, 'sqlsrv2')->getProcResult(array('AccountOutstanding'));
        $AccountOutstanding = $AccountOutstandingResult['data']['AccountOutstanding'];
        if(count($AccountOutstanding)>0){
            $AccountOutstanding = array_shift($AccountOutstanding);
            $Outstanding = $AccountOutstanding->Outstanding;
            $Outstanding= number_format($Outstanding,$decimal_places);
            return $Outstanding;
        }
    }
    public static function getInvoiceOutstanding($CompanyID,$AccountID,$Invoiceids,$decimal_places = 2){
        $query = "CALL prc_getPaymentPendingInvoice('". $CompanyID  . "',  '". $AccountID  . "',0)";
        $InvoiceOutstandingResult = DB::connection('sqlsrv2')->select($query);
        $Outstanding = 0;
        foreach ($InvoiceOutstandingResult as $Invoiceid) {
            if(in_array($Invoiceid->InvoiceID,explode(',',$Invoiceids))) {
                $Outstanding += $Invoiceid->RemaingAmount;
            }
        }
        $Outstanding= number_format($Outstanding,$decimal_places,'.', '');
        return $Outstanding;
    }
    public static function getAccountOwnerEmail($Account){
        $AccountManagerEmail ='';
        if(!empty($Account->Owner))
        {
            $AccountManager = User::find($Account->Owner);
            $AccountManagerEmail = $AccountManager->EmailAddress;
        }
        return $AccountManagerEmail;
    }
    public static function getAccountEmailCount($AccountID,$EmailType){
        $count =  AccountEmailLog::
            where(array('AccountID'=>$AccountID,'EmailType'=>$EmailType))
            ->whereRaw(" DATE_FORMAT(`created_at`,'%Y-%m-%d') = '".date('Y-m-d')."'")
            ->count();
        return $count;
    }

    public static function getLastAccountNo($CompanyID){
        $LastAccountNo =  CompanySetting::getKeyVal($CompanyID,'LastAccountNo');
        if($LastAccountNo == 'Invalid Key'){
            $LastAccountNo = 1;
            CompanySetting::setKeyVal($CompanyID,'LastAccountNo',$LastAccountNo);
        }

        while(Account::where(["CompanyID"=> $CompanyID,'Number'=>$LastAccountNo])->count() >=1 ){
            $LastAccountNo++;
        }
        return $LastAccountNo;
    }


    public static function updateAccountNo($CompanyID){
        $accounts = Account::select('AccountID')->where(["CompanyId" => $CompanyID,"AccountType" => 1,"Number"=>null])->get()->toArray();
        if(count($accounts)>0){
            foreach($accounts as $account){
                $accountid = $account['AccountID'];
                $lastnumber = Account::getLastAccountNo($CompanyID);
                Account::where('AccountID', $accountid)->update(['Number' => $lastnumber]);
                CompanySetting::setKeyVal($CompanyID,'LastAccountNo',$lastnumber);
            }
        }
    }
    public static function FirstLowBalanceReminder($AccountID,$LastRunTime){


        $accountemaillog =  AccountEmailLog::where(array('AccountID'=>$AccountID,'EmailType'=>AccountEmailLog::LowBalanceReminder));
        if(!empty($LastRunTime)){
                $accountemaillog->whereRaw(" DATE_FORMAT(`created_at`,'%Y-%m-%d') >= '".date('Y-m-d',strtotime($LastRunTime))."'");
        }
        $count = $accountemaillog->count();
        Log::info('AccountID = '.$AccountID.' email count = ' . $count);
        return $count;
    }

    public static function getAccountName($AccountID){
        return Account::where(["AccountID"=>$AccountID])->pluck('AccountName');
    }

}