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

    const  NOT_VERIFIED = 0;
    //const  PENDING_VERIFICATION = 1;
    const  VERIFIED =2;
    const  OutPaymentEmailTemplate ='OutPayment';
    const  ApproveOutPaymentEmailTemplate ='ApproveOutPayment';
    const  ContractManageEmailTemplate ='ContractRenewal';
    const  ContractExpireEmailTemplate = 'ContractExpire';
    const  DETAIL_CDR = 1;
    const  SUMMARY_CDR= 2;
    const  NO_CDR = 3;
    public static $cdr_type = array(''=>'Select a CDR Type' ,self::DETAIL_CDR => 'Detail CDR',self::SUMMARY_CDR=>'Summary CDR');
    public static $req_cdr_detail_column = array('account_id','cli','cld','connect_time','disconnect_time','billed_duration_sec','cost');
    public static $req_cdr_summary_column = array('account_id','area_prefix','total_charges','total_duration','number_of_cdr');
    public static $req_cdr_detail_column_single = array('cli','cld','connect_time','disconnect_time','billed_duration_sec','cost');
    public static $req_cdr_summary_column_single = array('area_prefix','total_charges','total_duration','number_of_cdr');

    static  $defaultAccountAuditFields = [
        'AccountName'=>'AccountName',
        'Address1'=>'Address1',
        'Address2'=>'Address2',
        'Address3'=>'Address3',
        'City'=>'City',
        'PostCode'=>'PostCode',
        'Country'=>'Country',
        'IsCustomer'=>'IsCustomer',
        'IsVendor'=>'IsVendor'
    ];

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
    public static function getDynamicfieldValue($ParentID,$FieldName,$CompanyID){
        $FieldValue = '';

        $FieldsID = DB::table('tblDynamicFields')->where(['CompanyID'=> $CompanyID,'FieldSlug'=>$FieldName])->pluck('DynamicFieldsID');
        if(!empty($FieldsID)){
            $FieldValue = DynamicFieldsValue::where(['ParentID'=>$ParentID,'DynamicFieldsID'=>$FieldsID])->pluck('FieldValue');
        }

        return $FieldValue;
    }

    public static function getDynamicfields($Type,$ParentID,$CompanyID){
        $results = array();
        $data = array();

        $Fields = DB::table('tblDynamicFields')->where(['CompanyID'=> $CompanyID,'Type'=>$Type,'Status'=>1])->get();
        Log::info("Count for Dynamic fields for Account ." . $ParentID . count($Fields));
        if(!empty($Fields) && count($Fields)>0){
            Log::info("Count for Dynamic fields for Account ." . $ParentID . ' in side loop ');
            foreach($Fields as $Field){
                Log::info("Count for Dynamic fields for Account ." . $ParentID . ' ' . $Field->FieldSlug);
                $FieldValue = Account::getDynamicfieldValue($ParentID,$Field->FieldSlug,$CompanyID);
                $data[$Field->FieldName] = $FieldValue;
                Log::info("Count for Dynamic fields for Account ." . $ParentID . ' ' . count($results));
            }
        }
        Log::info("Count for Dynamic fields for Account ." . $ParentID . ' ' . count($results));
        return $data;
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
            ->where('InvoiceStatus','!=',Invoice::CANCEL)
            ->Where(function($query)
            {
                $query->whereNull('ItemInvoice')
                ->orwhere('ItemInvoice', '!=', 1);

            })->count();
    }
    public static function getBillingTimeZone($AccountID){
        return AccountBilling::where(array('AccountID'=>$AccountID,'ServiceID'=>0))->pluck('BillingTimezone');
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

    public static function getOutPayment($AccountID){
        $OutPaymentAmount ='';
        $AccountAutomation = AccountPaymentAutomation::where('AccountID', $AccountID)->first();
        if($AccountAutomation != false)
            $OutPaymentAmount = $AccountAutomation->OutPaymentAmount;
        return $OutPaymentAmount;
    }

    public static function getInvoiceOutstanding($CompanyID,$AccountID,$Invoiceids,$decimal_places = 2){
        $query = "CALL prc_getPaymentPendingInvoice('". $CompanyID  . "',  '". $AccountID  . "',0,0)";
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
    public static function LowBalanceReminderEmailCheck($AccountID,$email,$LastRunTime){

        $accountemaillog =  AccountEmailLog::where(array('AccountID'=>$AccountID,'EmailType'=>AccountEmailLog::LowBalanceReminder,'EmailTo'=>$email));
        if(!empty($LastRunTime)){
                $accountemaillog->whereRaw(" DATE_FORMAT(`created_at`,'%Y-%m-%d') >= '".date('Y-m-d',strtotime($LastRunTime))."'");
        }
        $count = $accountemaillog->count();
        Log::info('AccountID = '.$AccountID.' email count = ' . $count);
        return $count;
    }

    public static function FirstBalanceWarning($AccountID,$LastRunTime){
        $accountemaillog =  AccountEmailLog::where(array('AccountID'=>$AccountID,'EmailType'=>AccountEmailLog::BalanceWarning));
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

    public static function getCompanyID($AccountID){
        return Account::where(["AccountID"=>$AccountID])->pluck('CompanyID');
    }

    public static function addAccountAudit($data=array()){
        $UserID = $data['UserID'];
        $CompanyID = $data['CompanyID'];
        $AccountDate = $data['AccountDate'];
        $IP = get_client_ip();
        $header = ["UserID"=>$UserID,
            "CompanyID"=>$CompanyID,
            "ParentColumnName"=>'AccountID',
            "Type"=>'account',
            "IP"=>$IP,
            "UserType"=>0
        ];
        $detail = array();
        $accounts = Account::where(['CompanyID'=>$CompanyID,'created_at'=>$AccountDate])->get()->toarray();
        Log::info('account count '.count($accounts));
        if(!empty($accounts) && count($accounts)>0){
            foreach($accounts as $index=>$value ){
                foreach(Account::$defaultAccountAuditFields as $AuditColumn){
                    $data = ['OldValue'=>'',
                        'NewValue'=>$value[$AuditColumn],
                        'ColumnName'=>$AuditColumn,
                        'ParentColumnID'=>$value['AccountID']
                    ];
                    $detail[]=$data;
                }
            }
        }

        Log::info('account audit detail count '.count($detail));

        if(!empty($detail) && count($detail)>0){
            Log::info('Audit create start');
            AuditHeader::add_AuditLog($header,$detail);
            Log::info('Audit create end');
        }

    }

    public static function getAccountIDList($data=array()){

        $data['Status'] = 1;
        if(!isset($data['AccountType'])) {
            $data['AccountType'] = 1;
            $data['VerificationStatus'] = Account::VERIFIED;
        }
        //$data['CompanyID']=$data['CompanyID'];
        $row = Account::where($data)->select(array('AccountName', 'AccountID'))->orderBy('AccountName')->lists('AccountName', 'AccountID');
        return $row;
    }


    public static function getLanguageIDbyAccountID($AcID)
    {
        return Account::find($AcID)->pluck('LanguageID');
    }

    public static function importStreamcoAccounts($streamco,$addparams) {
        $processID = isset($addparams['ProcessID']) ? $addparams['ProcessID'] : '';
        $CompanyID = isset($addparams['CompanyID']) ? $addparams['CompanyID'] : 0;
        $CompanyGatewayID = isset($addparams['CompanyGatewayID']) ? $addparams['CompanyGatewayID'] : 0;
        Log::info('Accounts Import Start');
        $account_response = $streamco->importStreamcoAccounts($addparams);
        if(isset($account_response['result']) && $account_response['result'] == 'OK') {
            $importoption = 1;
            $AccountIDs = '';
            $gateway = '';
            Log::info("start CALL  prc_WSProcessImportAccount ('" . $processID . "','" . $CompanyID . "','".$CompanyGatewayID."','".$AccountIDs."','".$importoption."','" . $addparams['ImportDate'] . "','".$gateway."')");
            try {
                DB::beginTransaction();
                $JobStatusMessage = DB::select("CALL  prc_WSProcessImportAccount ('" . $processID . "','" . $CompanyID . "','" . $CompanyGatewayID . "','" . $AccountIDs . "','" . $importoption . "','" . $addparams['ImportDate'] . "','".$gateway."')");
                Log::info("end CALL  prc_WSProcessImportAccount ('" . $processID . "','" . $CompanyID . "','" . $CompanyGatewayID . "','" . $AccountIDs . "','" . $importoption . "','" . $addparams['ImportDate'] . "','".$gateway."')");
                DB::commit();
                $JobStatusMessage = array_reverse(json_decode(json_encode($JobStatusMessage),true));
                Log::info($JobStatusMessage);
                Account::updateAccountNo($CompanyID);
                Log::info('update account number - Done');
                Log::info(count($JobStatusMessage));
                Log::info('Accounts Import End');
            }catch ( Exception $err ){
                try{
                    DB::rollback();
                }catch (Exception $err) {
                    Log::error($err);
                }
                Log::error($err);
            }
        }
    }

    public static function importStreamcoTrunks($streamco,$addparams) {
        /*$processID = isset($addparams['ProcessID']) ? $addparams['ProcessID'] : '';
        $CompanyID = isset($addparams['CompanyID']) ? $addparams['CompanyID'] : 0;
        $CompanyGatewayID = isset($addparams['CompanyGatewayID']) ? $addparams['CompanyGatewayID'] : 0;*/
        try {
            Log::info('Trunks Import Start');
            $streamco->importStreamcoTrunks($addparams);
            Log::info('Trunks Import End');
        }catch ( Exception $err ){
            try{
                DB::rollback();
            }catch (Exception $err) {
                Log::error($err);
            }
            Log::error($err);
        }
    }

}