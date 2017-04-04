<?php
namespace App\Lib;

use Chumper\Zipper\Facades\Zipper;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\View;
use Illuminate\Support\Str;
use Webpatser\Uuid\Uuid;

class Invoice extends \Eloquent {
    protected $connection = 'sqlsrv2';
    protected $fillable = [];
    protected $guarded = array('InvoiceID');
    protected $table = 'tblInvoice';
    protected $primaryKey = "InvoiceID";
	const 	PRINTTYPE = 'Invoice';
    const  INVOICE_OUT = 1;
    const  INVOICE_IN= 2;
    const DRAFT = 'draft';
    const SEND = 'send';
    const AWAITING = 'awaiting';
    const CANCEL = 'cancel';
    const RECEIVED = 'received';
    const PAID = 'paid';
    const PARTIALLY_PAID = 'partially_paid';
    const POST = 'post';
	const EMAILTEMPLATE = "InvoiceSingleSend";
    public static $invoice_type = array(''=>'Select an Invoice Type' ,self::INVOICE_OUT => 'Invoice Sent',self::INVOICE_IN=>'Invoice Received','All'=>'Both');
    public static $invoice_status = array(''=>'Select Invoice Status',self::DRAFT=>'Draft',self::SEND=>'Send',self::AWAITING=>'Awaiting Approval',self::CANCEL=>'Cancel',self::POST=>'Post');

    public static $InvoiceGenrationErrorReasons = [
        "Email" =>  "Failed to send Email.",
        "InvoiceTemplate" => "No Invoice Template assigned",
        "AlreadyInvoiced" => "Account is already billed on this duration",
        "NoGateway" => "No Gateway set up",
        "NoCDR" => "CDR is missing or not Loaded yet",
        "UsageFile" => "Usage File Generation Failed",
        "PDF" => "Failed to create Invoice PDF",
        "NoUsage" => "No Usage or Subscription found",
    ];

    /**
     *  Generate Usage file Upload and update Amazon path in Invoice Table
     */
    public static function generate_usage_file($InvoiceID){

        if(!empty($InvoiceID)) {

            $Invoice = Invoice::find($InvoiceID);
            $AccountID = $Invoice->AccountID;
            $CDRType = AccountBilling::getCDRType($AccountID);
            $CompanyID = $Invoice->CompanyID;
            $path = "";
            if ($CDRType == Account::SUMMARY_CDR) {
                $path = self::generate_usage_summery_file($CompanyID, $AccountID, $InvoiceID);
            } else if ($CDRType == Account::DETAIL_CDR) {
                $path = self::generate_usage_detail_file($CompanyID, $AccountID, $InvoiceID);
            }
            if (!empty($path)) {
                AmazonS3::delete($Invoice->UsagePath,$CompanyID); // Delete old usage file from amazon
                $Invoice->update(["UsagePath" => $path]); // Update new one
            }
            return $path;
        }
    }

    /** This function is not in use*/
    public static function generate_usage_detail_file_old($CompanyID,$AccountID,$InvoiceID){

        $GatewayAccounts = GatewayAccount::where("AccountID",$AccountID)->get();
        $InvoiceDetail = InvoiceDetail::select("StartDate", "EndDate")->where("InvoiceID", $InvoiceID)->where("ProductID", 0)->first()->toArray();
        if (isset($InvoiceDetail['StartDate']) && isset($InvoiceDetail['EndDate'])) {


            foreach ($GatewayAccounts as $GatewayAccount) {
                $CompanyGatewayID = $GatewayAccount->CompanyGatewayID;
                $filenames =array();
                $startdate = $enddate = "";

                $companysetting = json_decode(CompanyGateway::getCompanyGatewayConfig($CompanyGatewayID));
                $IpBased = ($companysetting->NameFormat == 'IP') ? 1 : 0;

                $accountname = GatewayAccount::where(array('CompanyGatewayID' => $CompanyGatewayID, 'CompanyID' => $CompanyID, 'AccountID' => $AccountID))->pluck('AccountName');
                $accountip = Account::where(array('CompanyID' => $CompanyID, 'AccountID' => $AccountID))->pluck('AccountIP');
                if ($IpBased == 1) {
                    $AccountName = trim($accountip);
                } else {
                    $AccountName = trim($accountname);
                }
                if (isset($InvoiceDetail['StartDate'])) {
                    $startdate = date("Y-m-d",strtotime($InvoiceDetail['StartDate']));
                }
                if (isset($InvoiceDetail['EndDate'])) {
                    $enddate = date("Y-m-d",strtotime($InvoiceDetail['EndDate']));
                }
                $dir = Config::get('app.cdr_location') . $CompanyGatewayID .'/' . $AccountName;

                $it = new \RecursiveIteratorIterator(new \RecursiveDirectoryIterator($dir));

                while($it->valid()) {
                    if (!$it->isDot()) {
                        //echo 'SubPathName: ' . $it->getSubPathName() . "\n";
                        //echo 'SubPath:     ' . $it->getSubPath() . "\n";
                        //echo 'Key:         ' . $it->key() . "\n\n";
                        $date = str_replace('.csv','',basename($it->key()));
                        if($startdate != '' && $enddate != '' && $date >= $startdate && $date <= $enddate ) {
                            $filenames[] = $it->key();
                        }
                    }
                    $it->next();
                }
                $AccountName = Account::where(["AccountID"=>$AccountID])->pluck('AccountName');
                $ZipFile = $dir . '/' . str_slug($AccountName).'-detail-'.   date("d-m-Y-H-i-s", strtotime($InvoiceDetail['StartDate'])) . '-TO-' . date("d-m-Y-H-i-s", strtotime($InvoiceDetail['EndDate']))."__" . str_random(10) .'.zip';
                Zipper::make($ZipFile)->add($filenames)->close();

                if(file_exists($ZipFile)){
                    $amazondir = AmazonS3::$dir['INVOICE_USAGE_FILE'];
                    $amazonPath = AmazonS3::generate_upload_path($amazondir, $AccountID, $CompanyID);
                    $fullPath = $amazonPath . basename($ZipFile); //$destinationPath . $file_name;
                    if (!AmazonS3::upload($ZipFile, $amazonPath,$CompanyID)) {
                        throw new Exception('Error in Amazon upload');
                    }
                    return $fullPath;
                }
            }
        }

    }

    public static function generate_usage_detail_file($CompanyID,$AccountID,$InvoiceID){
        if(!empty($CompanyID) && !empty($AccountID) && !empty($InvoiceID) ) {
            $ProcessID = Uuid::generate();
            $UPLOADPATH = CompanyConfiguration::get($CompanyID,'UPLOAD_PATH');
            $InvoiceDetail = InvoiceDetail::select("StartDate", "EndDate")->where("InvoiceID", $InvoiceID)->where("ProductID", 0)->first()->toArray();
            if (isset($InvoiceDetail['StartDate']) && isset($InvoiceDetail['EndDate'])) {

                $start_date = $InvoiceDetail['StartDate'];
                $end_date = $InvoiceDetail['EndDate'];
                $amazonPath = AmazonS3::generate_path(AmazonS3::$dir['INVOICE_USAGE_FILE'],$CompanyID,$AccountID) ;
                $dir = $UPLOADPATH . '/'. $amazonPath;
                if (!file_exists($dir)) {
                    mkdir($dir, 0777, TRUE);
                }
                if (is_writable($dir)) {
                    $AccountName = Account::where(["AccountID" => $AccountID])->pluck('AccountName');
                    $local_file = $dir . '/' . str_slug($AccountName) . '-usage-' . date("d-m-Y-H-i-s", strtotime($start_date)) . '-TO-' . date("d-m-Y-H-i-s", strtotime($end_date)) . '__' . $ProcessID . '.csv';
                    $GatewayAccount =  GatewayAccount::where(array('AccountID'=>$AccountID))->distinct()->get(['CompanyGatewayID']);
                    $usage_data = array();
                    foreach($GatewayAccount as $GatewayAccountRow) {
                        $GatewayAccountRow['CompanyGatewayID'];
                        $BillingTimeZone = CompanyGateway::getGatewayBillingTimeZone($GatewayAccountRow['CompanyGatewayID']);
                        $TimeZone = CompanyGateway::getGatewayTimeZone($GatewayAccountRow['CompanyGatewayID']);
                        $AccountBillingTimeZone = Account::getBillingTimeZone($AccountID);
                        if(!empty($AccountBillingTimeZone)){
                            $BillingTimeZone = $AccountBillingTimeZone;
                        }
                        $BillingStartDate = change_timezone($BillingTimeZone,$TimeZone,$start_date,$CompanyID);
                        $BillingEndDate = change_timezone($BillingTimeZone,$TimeZone,$end_date,$CompanyID);
                        Log::info('original start date ==>'.$start_date.' changed start date ==>'.$BillingStartDate.' original end date ==>'.$end_date.' changed end date ==>'.$BillingEndDate);
                        $query = "CALL prc_getInvoiceUsage(" . $CompanyID . ",'" . $AccountID . "','".$GatewayAccountRow['CompanyGatewayID']."','" . $BillingStartDate . "','" . $BillingEndDate . "',1)";
                        Log::info($query);
                        $result_data = DB::connection('sqlsrv2')->select($query);
                        $result_data = json_decode(json_encode($result_data), true);
                        //$usage_data = $usage_data+json_decode(json_encode($result_data), true);
                        foreach($result_data as $result_row){
                            if(isset($result_row['AreaPrefix'])){
                                $key = searcharray($result_row['AreaPrefix'], 'AreaPrefix',$result_row['Trunk'],'Trunk',$usage_data);
                                if(isset($usage_data[$key]['AreaPrefix'])){
                                    $usage_data[$key]['NoOfCalls'] += $result_row['NoOfCalls'];
                                    $usage_data[$key]['Duration'] = add_duration($result_row['Duration'],$usage_data[$key]['Duration']);
                                    $usage_data[$key]['BillDuration'] = add_duration($result_row['BillDuration'],$usage_data[$key]['BillDuration']);
                                    $usage_data[$key]['TotalCharges'] += $result_row['TotalCharges'];
                                    $usage_data[$key]['DurationInSec'] += $result_row['Duration'];
                                    $usage_data[$key]['BillDurationInSec'] += $result_row['BillDuration'];
                                }else{
                                    $usage_data[] = $result_row;
                                }
                            }else{
                                $usage_data[] = $result_row;
                            }
                        }
                    }
                    $output = Helper::array_to_csv($usage_data);
                    file_put_contents($local_file, $output);
                    if (file_exists($local_file)) {
                        $fullPath = $amazonPath . basename($local_file); //$destinationPath . $file_name;
                        if (!AmazonS3::upload($local_file, $amazonPath,$CompanyID)) {
                            throw new Exception('Error in Amazon upload');
                        }
                        return $fullPath;
                    }
                }
            }

        }
    }

    public static function generate_usage_summery_file($CompanyID,$AccountID,$InvoiceID){

        if(!empty($CompanyID) && !empty($AccountID) && !empty($InvoiceID) ) {

            $ProcessID = Uuid::generate();
            $UPLOADPATH = CompanyConfiguration::get($CompanyID,'UPLOAD_PATH');
            $InvoiceDetail = InvoiceDetail::select("StartDate", "EndDate")->where("InvoiceID", $InvoiceID)->where("ProductID", 0)->first()->toArray();
            if (isset($InvoiceDetail['StartDate']) && isset($InvoiceDetail['EndDate'])) {

                $start_date = $InvoiceDetail['StartDate'];
                $end_date = $InvoiceDetail['EndDate'];
                $amazonPath = AmazonS3::generate_path(AmazonS3::$dir['INVOICE_USAGE_FILE'],$CompanyID,$AccountID) ;
                $dir = $UPLOADPATH . '/'. $amazonPath;
                if (!file_exists($dir)) {
                    mkdir($dir, 0777, TRUE);
                }
                if (is_writable($dir)) {
                    $AccountName = Account::where(["AccountID" => $AccountID])->pluck('AccountName');
                    $local_file = $dir . '/' . str_slug($AccountName) . '-summery-' . date("d-m-Y-H-i-s", strtotime($start_date)) . '-TO-' . date("d-m-Y-H-i-s", strtotime($end_date)) . '__' . $ProcessID . '.csv';
                    $GatewayAccount =  GatewayAccount::where(array('AccountID'=>$AccountID))->distinct()->get(['CompanyGatewayID']);
                    $usage_data = array();
                    foreach($GatewayAccount as $GatewayAccountRow) {
                        $GatewayAccountRow['CompanyGatewayID'];
                        $BillingTimeZone = CompanyGateway::getGatewayBillingTimeZone($GatewayAccountRow['CompanyGatewayID']);
                        $TimeZone = CompanyGateway::getGatewayTimeZone($GatewayAccountRow['CompanyGatewayID']);
                        $AccountBillingTimeZone = Account::getBillingTimeZone($AccountID);
                        if(!empty($AccountBillingTimeZone)){
                            $BillingTimeZone = $AccountBillingTimeZone;
                        }
                        $BillingStartDate = change_timezone($BillingTimeZone,$TimeZone,$start_date,$CompanyID);
                        $BillingEndDate = change_timezone($BillingTimeZone,$TimeZone,$end_date,$CompanyID);
                        Log::info('original start date ==>'.$start_date.' changed start date ==>'.$BillingStartDate.' original end date ==>'.$end_date.' changed end date ==>'.$BillingEndDate);
                        $query = "CALL prc_getInvoiceUsage(" . $CompanyID . ",'" . $AccountID . "','".$GatewayAccountRow['CompanyGatewayID']."','". $BillingStartDate . "','" . $BillingEndDate . "',1)";
                        Log::info($query);
                        $result_data = DB::connection('sqlsrv2')->select($query);
                        $result_data = json_decode(json_encode($result_data), true);
                        //$usage_data = $usage_data+json_decode(json_encode($result_data), true);
                        foreach($result_data as $result_row){
                            if(isset($result_row['AreaPrefix'])){
                                if(isset($result_row['DurationInSec'])){
                                    unset($result_row['DurationInSec']);
                                }
                                if(isset($result_row['BillDurationInSec'])){
                                    unset($result_row['BillDurationInSec']);
                                }
                                $key = searcharray($result_row['AreaPrefix'], 'AreaPrefix',$result_row['Trunk'],'Trunk',$usage_data);
                                if(isset($usage_data[$key]['AreaPrefix'])){
                                    $usage_data[$key]['NoOfCalls'] += $result_row['NoOfCalls'];
                                    $usage_data[$key]['Duration'] = add_duration($result_row['Duration'],$usage_data[$key]['Duration']);
                                    $usage_data[$key]['BillDuration'] = add_duration($result_row['BillDuration'],$usage_data[$key]['BillDuration']);
                                    $usage_data[$key]['TotalCharges'] += $result_row['TotalCharges'];
                                }else{
                                    $usage_data[] = $result_row;
                                }
                            }else{
                                $usage_data[] = $result_row;
                            }
                        }
                    }
                    $output = Helper::array_to_csv($usage_data);
                    file_put_contents($local_file, $output);
                    if (file_exists($local_file)) {
                        $fullPath = $amazonPath . basename($local_file); //$destinationPath . $file_name;
                        if (!AmazonS3::upload($local_file, $amazonPath,$CompanyID)) {
                            throw new Exception('Error in Amazon upload');
                        }
                        return $fullPath;
                    }
                }
            }

        }
    }
    /**
     * Invoice Generation Date
     * */
    public static function getLastInvoiceDate($CompanyID,$AccountID ){

        /**
         * Assumption : If Billing Cycle is 7 Days then Usage and Subscription both will be 7 Days and same for Monthly and other billing cycles..
         * */
        if(!empty($CompanyID) && !empty($AccountID) ) {


            $LastInvoiceDate = AccountBilling::where("AccountID", $AccountID)->pluck("LastInvoiceDate");

            if (!empty($LastInvoiceDate)) {
                return $LastInvoiceDate;
            }
            // ignore item invoice
            $invocie_count =  Account::getInvoiceCount($AccountID);
            if($invocie_count == 0){
                $AccountBilling = AccountBilling::getBilling($AccountID);
                $BillingStartDate = $AccountBilling->BillingStartDate;
                return $BillingStartDate;
            }

        }

    }

    /**
     * Invoice Generation Date
     * Always calculate next Invoice Date from Last InvoiceDate or BillingStartDate
     * */
    public static function getNextInvoiceDate($CompanyID,$AccountID){

        /**
         * Assumption : If Billing Cycle is 7 Days then Usage and Subscription both will be 7 Days and same for Monthly and other billing cycles..
         * */
        if(!empty($CompanyID) && !empty($AccountID) ) {

            $Account = AccountBilling::select(["NextInvoiceDate","BillingStartDate","LastInvoiceDate"])->where("AccountID",$AccountID)->first()->toArray();

            /*if(!empty($Account['NextInvoiceDate'])) {
                return $Account['NextInvoiceDate'];
            }*/

            $BillingCycle = AccountBilling::select(["BillingCycleType","BillingCycleValue"])->where("AccountID",$AccountID)->first()->toArray();
            //"weekly"=>"Weekly", "monthly"=>"Monthly" , "daily"=>"Daily", "in_specific_days"=>"In Specific days", "monthly_anniversary"=>"Monthly anniversary");

            $NextInvoiceDate = "";
            $BillingStartDate = "";
            if(!empty($Account['LastInvoiceDate'])){
                $BillingStartDate = strtotime($Account['LastInvoiceDate']);
            }
            else if(!empty($Account['BillingStartDate'])) {
                $BillingStartDate = strtotime($Account['BillingStartDate']);
            }else{
                return '';
            }
            $NextInvoiceDate = next_billing_date($BillingCycle['BillingCycleType'],$BillingCycle['BillingCycleValue'],$BillingStartDate);
            return $NextInvoiceDate;
        }

    }
    /**
     * Invoice Generation Date
     * */
    public static function calculateNextInvoiceDateFromLastInvoiceDate($CompanyID,$AccountID,$LastInvoiceDate){

        if(!empty($CompanyID) && !empty($AccountID) && !empty($LastInvoiceDate) ){

            $BillingCycle = AccountBilling::select(["BillingCycleType", "BillingCycleValue"])->where("AccountID", $AccountID)->first()->toArray();
            //"weekly"=>"Weekly", "monthly"=>"Monthly" , "daily"=>"Daily", "in_specific_days"=>"In Specific days", "monthly_anniversary"=>"Monthly anniversary");

            $NextInvoiceDate = "";
            $LastInvoiceDate = strtotime($LastInvoiceDate);
            $NextInvoiceDate = next_billing_date($BillingCycle['BillingCycleType'],$BillingCycle['BillingCycleValue'],$LastInvoiceDate);

            return $NextInvoiceDate;
        }

    }


    public static function sendInvoice($CompanyID,$AccountID,$LastInvoiceDate,$NextInvoiceDate,$InvoiceGenerationEmail,$ProcessID,$JobID){

        $error = "";
        $StartDate = $LastInvoiceDate;
        $EndDate =  date("Y-m-d 23:59:59", strtotime( "-1 Day", strtotime($NextInvoiceDate)));

        Log::info('start Date =' . $StartDate . " EndDate =" .$EndDate );

        if($AccountID > 0 && $CompanyID > 0 && !empty($StartDate) && !empty($EndDate)) {

            $CompanyName  = Company::getName($CompanyID);

            $Account = Account::find((int)$AccountID);
            $AccountBilling = AccountBilling::getBillingClass((int)$AccountID);

            if(!empty($Account)) {

                $InvoiceTemplate = InvoiceTemplate::where("InvoiceTemplateID",$AccountBilling->InvoiceTemplateID)->select(["Terms","FooterTerm","InvoiceNumberPrefix","DateFormat"])->first();

                if ( empty($AccountBilling->InvoiceTemplateID) || empty($InvoiceTemplate) ) {
                    $error = $Account->AccountName . ' ' . Invoice::$InvoiceGenrationErrorReasons['InvoiceTemplate'];
                    return array("status" => "failure", "message" => $error);
                }

                Log::info('InvoiceTemplate->InvoiceNumberPrefix =' .($InvoiceTemplate->InvoiceNumberPrefix)) ;
                Log::info('InvoiceTemplate->Terms =' .($InvoiceTemplate->Terms));


                if(!empty($InvoiceTemplate)) {

                    $InvoiceTemplate->DateFormat = invoice_date_fomat($InvoiceTemplate->DateFormat);
                    $decimal_places = Helper::get_round_decimal_places($CompanyID,$Account->AccountID);

                    /**
                     ***************************
                     **************************
                    Step 1     USAGE
                     **************************
                     **************************
                     */
                    //Check if Invoice Usage is already Created.
                    //TRUE=Already Billed
                    //FALSE = Not billed
                    Log::info('Invoice::checkIfAccountUsageAlreadyBilled') ;

                    $AlreadyBilled = Invoice::checkIfAccountUsageAlreadyBilled($CompanyID,$AccountID, $StartDate, $EndDate);

                    //If Already Billed

                    if ($AlreadyBilled) {
                        $error = $Account->AccountName . ' ' . Invoice::$InvoiceGenrationErrorReasons["AlreadyInvoiced"];
                        return array("status" => "failure", "message" => $error);
                    }

                    $Invoice = "";
                    $SubTotal = 0;
                    $SubTotalWithoutTax = 0;
                    $AdditionalChargeTax = 0;

                    //If Account usage not already billed

                    if (!$AlreadyBilled) {

                        $uResponse = self::addUsage($Account,$CompanyID, $AccountID,$StartDate,$EndDate,$InvoiceTemplate,$SubTotal,$decimal_places);
                        $Invoice = $uResponse["Invoice"];
                        $SubTotal = $uResponse["SubTotal"];

                    } // Usage Over

                    Log::info('Usage Over') ;

                    /**
                     ***************************
                     **************************
                    Step 2  SUBSCRIPTION
                     **************************
                     **************************
                     */

                    /**
                     * Add Subscription in InvoiceDetail if any
                     */
                    $subResponse = self::addSubscription($Invoice,$InvoiceTemplate,$StartDate,$EndDate,$SubTotal,$decimal_places);
                    $SubTotal = $subResponse["SubTotal"];
                    $SubTotalWithoutTax += $subResponse["SubscriptionChargewithouttaxTotal"];

                    /**
                     * Add OneOffCharge in InvoiceDetail if any
                     */
                    $subResponse = self::addOneOffCharge($Invoice,$InvoiceTemplate,$StartDate,$EndDate,$SubTotal,$decimal_places);
                    $SubTotal = $subResponse["SubTotal"];
                    $SubTotalWithoutTax += $subResponse["SubscriptionChargewithouttaxTotal"];
                    $AdditionalChargeTax = $subResponse["AdditionalChargeTotalTax"];

                    /**
                     ***************************
                     **************************
                    Step 3  USAGE FILE & Invoice PDF & EMAIL
                     **************************
                     **************************
                     */

                    Log::info('USAGE FILE & Invoice PDF & EMAIL Start') ;

                    if (isset($Invoice)) {

                        $totals = self::updateInvoiceAllTotalAmounts($Invoice,$SubTotal,$SubTotalWithoutTax,$AdditionalChargeTax,$decimal_places);

                        /*
                         * PDF Generation CODE HERE
                         *
                         */
                        Log::info('PDF Generation start');

                        $pdf_path = Invoice::generate_pdf($Invoice->InvoiceID);
                        if(empty($pdf_path)){
                            $error = Invoice::$InvoiceGenrationErrorReasons["PDF"];
                            return array("status" => "failure", "message" => $error);
                        }else{
                            $Invoice->update(["PDF" => $pdf_path]);
                        }

                        Log::info('PDF fullPath ' . $pdf_path);

                        /** Generate Usage File **/
                        Log::info('Generate Usage File Start ') ;

                        $fullPath = "";
                        if($AccountBilling->CDRType != Account::NO_CDR) { // Check in to generate Invoice usage file or not
                            $InvoiceID = $Invoice->InvoiceID;
                            if ($InvoiceID > 0 && $AccountID > 0) {
                                $fullPath = Invoice::generate_usage_file($InvoiceID);
                                if (empty($fullPath)) {
                                    $error = $Account->AccountName . ' ' . Invoice::$InvoiceGenrationErrorReasons['UsageFile'];
                                }
                            }
                        }

                        Log::info('Usage File fullPath ' . $fullPath ) ;

                        if(empty($error)) {

                            $status = self::EmailToCustomer($Account,$totals['GrandTotal'],$Invoice,$InvoiceTemplate->InvoiceNumberPrefix,$CompanyName,$CompanyID,$InvoiceGenerationEmail,$ProcessID,$JobID);


                            if(isset($status['status']) && isset($status['message']) && $status['status']=='failure'){
                                $error_1 = $status['message'];
                            }
                        }

                    }//Email Sending over

                    Log::info('=========== Email Sending over =========== ') ;



                }
                if(!empty($error)){

                    Log::info('=========== Returning as Error =========== ' . $error) ;

                    return array("status"=>"failure","message"=> $error);
                }else{
                    Log::info('=========== Returning as Success =========== AccountID ' . $AccountID) ;
                    return array("status"=>"success","message"=> "Invoice Created Successfully.",'accounts'=>(isset($error_1)?$error_1:''));
                }
            }

        }
    }


    public static function insertInvoice($data){


        if(!empty($data)) {

            $data["CreatedBy"] = 'RMScheduler';
            $data["IssueDate"] = date('Y-m-d');
            $data["TotalDiscount"]     = 0;
            $data["InvoiceType"] = Invoice::INVOICE_OUT;

            $Invoice = Invoice::create($data);
            return $Invoice;

        }

    }



    public static function checkIfAccountUsageAlreadyBilled($CompanyID,$AccountID,$StartDate,$EndDate){

        if(!empty($CompanyID) && !empty($AccountID) && !empty($StartDate) && !empty($EndDate) ){

            //Check if Invoice Usage is alrady Created.
            $isAccountUsageBilled = DB::connection('sqlsrv2')->select("SELECT COUNT(inv.InvoiceID) as count  FROM tblInvoice inv LEFT JOIN tblInvoiceDetail invd  ON invd.InvoiceID = inv.InvoiceID WHERE inv.CompanyID = " . $CompanyID . " AND inv.AccountID = " . $AccountID . " AND (('" . $StartDate . "' BETWEEN invd.StartDate AND invd.EndDate) OR('" . $EndDate . "' BETWEEN invd.StartDate AND invd.EndDate) OR (invd.StartDate BETWEEN '" . $StartDate . "' AND '" . $EndDate . "') ) and invd.ProductType = " . Product::USAGE . " and inv.InvoiceType = " . Invoice::INVOICE_OUT . " and inv.InvoiceStatus != '" . Invoice::CANCEL."'");

            if (isset($isAccountUsageBilled[0]->count) && $isAccountUsageBilled[0]->count == 0) {
                return false;
            }
        }
        return true;
    }

    public static function getAccountUsageTotal($CompanyID,$AccountID,$StartDate,$EndDate) {

        $TotalCharges = 0;
        if(!empty($CompanyID) && !empty($AccountID) && !empty($StartDate) && !empty($EndDate) ) {
            $GatewayAccount =  GatewayAccount::where(array('AccountID'=>$AccountID))->distinct()->get(['CompanyGatewayID']);
            foreach($GatewayAccount as $GatewayAccountRow) {
                $GatewayAccountRow['CompanyGatewayID'];
                $BillingTimeZone = CompanyGateway::getGatewayBillingTimeZone($GatewayAccountRow['CompanyGatewayID']);
                $TimeZone = CompanyGateway::getGatewayTimeZone($GatewayAccountRow['CompanyGatewayID']);
                $AccountBillingTimeZone = Account::getBillingTimeZone($AccountID);
                if(!empty($AccountBillingTimeZone)){
                    $BillingTimeZone = $AccountBillingTimeZone;
                }
                $BillingStartDate = change_timezone($BillingTimeZone,$TimeZone,$StartDate,$CompanyID);
                $BillingEndDate = change_timezone($BillingTimeZone,$TimeZone,$EndDate,$CompanyID);
                Log::info('original start date ==>'.$StartDate.' changed start date ==>'.$BillingStartDate.' original end date ==>'.$EndDate.' changed end date ==>'.$BillingEndDate);
                $query = "CALL prc_getAccountInvoiceTotal(" . (int)$AccountID . ",$CompanyID,".$GatewayAccountRow['CompanyGatewayID'].",'$BillingStartDate','$BillingEndDate',0,0)";
                $result = DB::connection('sqlsrv2')->select($query);
                if (isset($result[0])&& !empty($result) && isset($result[0]->TotalCharges) && $result[0]->TotalCharges > 0) {
                    $TotalCharges += $result[0]->TotalCharges;
                    Log::info(' CompanyGatewayID '.$GatewayAccountRow['CompanyGatewayID'].' TotalCharges ==>'.$result[0]->TotalCharges);
                }
            }
        }
        return $TotalCharges;

    }

    public static function checkIfAccountSubscriptionAlreadyBilled($InvoiceID,$CompanyID,$AccountID,$SubscriptionID, $StartDate,$EndDate)
    {

        if(!empty($CompanyID) && !empty($AccountID) && !empty($StartDate) && !empty($EndDate) ) {

            $isAccountSubscriptionBilled = DB::connection('sqlsrv2')->select("SELECT COUNT(inv.InvoiceID) as count  FROM tblInvoice inv LEFT JOIN tblInvoiceDetail invd  ON invd.InvoiceID = inv.InvoiceID WHERE inv.CompanyID = " . $CompanyID . " AND inv.AccountID = " . $AccountID . " AND inv.InvoiceID != ".$InvoiceID."  AND invd.ProductID = ".$SubscriptionID ."  AND (('" . $StartDate . "' BETWEEN invd.StartDate AND invd.EndDate) OR('" . $EndDate . "' BETWEEN invd.StartDate AND invd.EndDate) OR (invd.StartDate BETWEEN '" . $StartDate . "' AND '" . $EndDate . "') ) and invd.ProductType = " . Product::SUBSCRIPTION . " and inv.InvoiceStatus != '" . Invoice::CANCEL."'");

            if (isset($isAccountSubscriptionBilled[0]->count) && $isAccountSubscriptionBilled[0]->count == 0) {
                return false;
            }
            return true;

        }

    }

    public static  function generate_pdf($InvoiceID,$data = []){
        if($InvoiceID>0) {
			$print_type = Invoice::PRINTTYPE;
            $Invoice = Invoice::find($InvoiceID);
            $InvoiceDetail = InvoiceDetail::where(["InvoiceID" => $InvoiceID])->get();
            $Account = Account::find($Invoice->AccountID);
            $companyID = $Account->CompanyId;
            $UPLOADPATH = CompanyConfiguration::get($companyID,'UPLOAD_PATH');
            if(!empty($Invoice->RecurringInvoiceID)){
                $recurringInvoice = RecurringInvoice::find($Invoice->RecurringInvoiceID);
                $billingClass = BillingClass::where('BillingClassID',$recurringInvoice->BillingClassID)->first();
                $InvoiceTemplateID = $billingClass->InvoiceTemplateID;
                $PaymentDueInDays = $billingClass->PaymentDueInDays;

                $InvoiceAllTaxRates = DB::connection('sqlsrv2')->table('tblInvoiceTaxRate')
                    ->select('TaxRateID', 'Title', DB::Raw('sum(TaxAmount) as TaxAmount'))
                    ->where("InvoiceID", $InvoiceID)
                    ->orderBy("InvoiceTaxRateID", "asc")
                    ->groupBy("TaxRateID")
                    ->get();
            }else{
                $AccountBilling = AccountBilling::getBillingClass($Invoice->AccountID);
                $PaymentDueInDays = AccountBilling::getPaymentDueInDays($Invoice->AccountID);
                $InvoiceTemplateID = $AccountBilling->InvoiceTemplateID;
                $InvoiceTaxRates = InvoiceTaxRate::where("InvoiceID",$InvoiceID)->get();
            }
            $Currency = Currency::find($Account->CurrencyId);
            $CurrencyCode = !empty($Currency)?$Currency->Code:'';
            $CurrencySymbol =  Currency::getCurrencySymbol($Account->CurrencyId);
            $InvoiceTemplate = InvoiceTemplate::find($InvoiceTemplateID);
            if (empty($InvoiceTemplate->CompanyLogoUrl) || AmazonS3::unSignedUrl($InvoiceTemplate->CompanyLogoAS3Key,$companyID) == '') {
                $as3url =  base_path().'/resources/assets/images/250x100.png'; //'http://placehold.it/250x100';
            } else {
                $as3url = (AmazonS3::unSignedUrl($InvoiceTemplate->CompanyLogoAS3Key,$companyID));
            }
            $logo = $UPLOADPATH . '/' . basename($as3url);
            file_put_contents($logo, file_get_contents($as3url));

            $usage_data = array();
            $InvoiceTemplate->DateFormat = invoice_date_fomat($InvoiceTemplate->DateFormat);
            $file_name = 'Invoice--' . date($InvoiceTemplate->DateFormat) . '.pdf';
            $htmlfile_name = 'Invoice--' . date($InvoiceTemplate->DateFormat) . '.html';
            if($InvoiceTemplate->InvoicePages == 'single_with_detail' && empty($Invoice->RecurringInvoiceID)) {
                foreach ($InvoiceDetail as $Detail) {
                    if (isset($Detail->StartDate) && isset($Detail->EndDate) && $Detail->StartDate != '1900-01-01' && $Detail->EndDate != '1900-01-01') {


                        $start_date = $Detail->StartDate;
                        $end_date = $Detail->EndDate;
                        $ShowZeroCall = 1;
                        if(isset($InvoiceTemplate->ShowZeroCall) && $InvoiceTemplate->ShowZeroCall != 1 ){
                            $ShowZeroCall = 0;
                        }
                        $GatewayAccount =  GatewayAccount::where(array('AccountID'=>$Invoice->AccountID))->distinct()->get(['CompanyGatewayID']);
                        foreach($GatewayAccount as $GatewayAccountRow) {
                            $GatewayAccountRow['CompanyGatewayID'];
                            $BillingTimeZone = CompanyGateway::getGatewayBillingTimeZone($GatewayAccountRow['CompanyGatewayID']);
                            $TimeZone = CompanyGateway::getGatewayTimeZone($GatewayAccountRow['CompanyGatewayID']);
                            $AccountBillingTimeZone = Account::getBillingTimeZone($Invoice->AccountID);
                            if(!empty($AccountBillingTimeZone)){
                                $BillingTimeZone = $AccountBillingTimeZone;
                            }
                            $BillingStartDate = change_timezone($BillingTimeZone,$TimeZone,$start_date,$companyID);
                            $BillingEndDate = change_timezone($BillingTimeZone,$TimeZone,$end_date,$companyID);
                            Log::info('original start date ==>'.$start_date.' changed start date ==>'.$BillingStartDate.' original end date ==>'.$end_date.' changed end date ==>'.$BillingEndDate);
                            $query = "CALL prc_getInvoiceUsage(" . $companyID . ",'" . $Invoice->AccountID . "','".$GatewayAccountRow['CompanyGatewayID']."','" . $BillingStartDate . "','" . $BillingEndDate . "',".intval($InvoiceTemplate->ShowZeroCall).")";
                            Log::info($query);
                            $result_data = DB::connection('sqlsrv2')->select($query);
                            $result_data = json_decode(json_encode($result_data), true);
                            //$usage_data = $usage_data+json_decode(json_encode($result_data), true);
                            foreach($result_data as $result_row){
                                if(isset($result_row['AreaPrefix'])){
                                    $key = searcharray($result_row['AreaPrefix'], 'AreaPrefix',$result_row['Trunk'],'Trunk',$usage_data);
                                    if(isset($usage_data[$key]['AreaPrefix'])){
                                        $usage_data[$key]['NoOfCalls'] += $result_row['NoOfCalls'];
                                        $usage_data[$key]['Duration'] = add_duration($result_row['Duration'],$usage_data[$key]['Duration']);
                                        $usage_data[$key]['BillDuration'] = add_duration($result_row['BillDuration'],$usage_data[$key]['BillDuration']);
                                        $usage_data[$key]['TotalCharges'] += $result_row['TotalCharges'];
                                        $usage_data[$key]['DurationInSec'] += $result_row['Duration'];
                                        $usage_data[$key]['BillDurationInSec'] += $result_row['BillDuration'];
                                    }else{
                                        $usage_data[] = $result_row;
                                    }
                                }else{
                                    $usage_data[] = $result_row;
                                }
                            }
                        }

                        $file_name =  'Invoice-From-' . Str::slug($start_date) . '-To-' . Str::slug($end_date) . '.pdf';
                        $htmlfile_name =  'Invoice-From-' . Str::slug($start_date) . '-To-' . Str::slug($end_date) . '.html';
                        break;
                    }
                }
            }
            $RoundChargesAmount = Helper::get_round_decimal_places($Account->CompanyId,$Account->AccountID);
			
            if(empty($Invoice->RecurringInvoiceID)) {
                $body = View::make('emails.invoices.pdf', compact('Invoice', 'InvoiceDetail', 'InvoiceTaxRates', 'Account', 'InvoiceTemplate', 'usage_data', 'CurrencyCode', 'CurrencySymbol', 'logo', 'AccountBilling', 'PaymentDueInDays', 'RoundChargesAmount','print_type'))->render();
            }else {
                $body = View::make('emails.invoices.itempdf', compact('Invoice', 'InvoiceDetail', 'Account', 'InvoiceTemplate', 'CurrencyCode', 'logo', 'CurrencySymbol', 'AccountBilling', 'InvoiceTaxRates', 'PaymentDueInDays', 'InvoiceAllTaxRates','RoundChargesAmount','data','print_type'))->render();
            }
            $body = htmlspecialchars_decode($body);
            $footer = View::make('emails.invoices.pdffooter', compact('Invoice'))->render();
            $footer = htmlspecialchars_decode($footer);

            $header = View::make('emails.invoices.pdfheader', compact('Invoice'))->render();
            $header = htmlspecialchars_decode($header);
            
            $amazonPath = AmazonS3::generate_path(AmazonS3::$dir['INVOICE_UPLOAD'],$Account->CompanyId,$Invoice->AccountID) ;
            $destination_dir = $UPLOADPATH . '/'. $amazonPath;
            if (!file_exists($destination_dir)) {
                mkdir($destination_dir, 0777, true);
            }
            $file_name = Uuid::generate() .'-'. $file_name;
            $htmlfile_name = Uuid::generate() .'-'. $htmlfile_name;
            $local_file = $destination_dir .  $file_name;
            $local_htmlfile = $destination_dir .  $htmlfile_name;
            file_put_contents($local_htmlfile,$body);
            $footer_name = 'footer-'. Uuid::generate() .'.html';
            $footer_html = $destination_dir.$footer_name;
            file_put_contents($footer_html,$footer);
            $header_name = 'header-'. Uuid::generate() .'.html';
            $header_html = $destination_dir.$header_name;
            file_put_contents($header_html,$header);
            $output= "";
            if(getenv('APP_OS') == 'Linux'){
                exec (base_path(). '/wkhtmltox/bin/wkhtmltopdf --header-spacing 3 --footer-spacing 1 --header-html "'.$header_html.'" --footer-html "'.$footer_html.'" "'.$local_htmlfile.'" "'.$local_file.'"',$output);
                Log::info(base_path(). '/wkhtmltox/bin/wkhtmltopdf --header-spacing 3 --footer-spacing 1 --header-html --footer-html "'.$footer_html.'" "'.$local_htmlfile.'" "'.$local_file.'"',$output);

            }else{
                exec (base_path().'/wkhtmltopdf/bin/wkhtmltopdf.exe --header-spacing 3 --footer-spacing 1 --header-html "'.$header_html.'" --footer-html "'.$footer_html.'" "'.$local_htmlfile.'" "'.$local_file.'"',$output);
                Log::info (base_path().'/wkhtmltopdf/bin/wkhtmltopdf.exe --header-spacing 3 --footer-spacing 1 --header-html "'.$header_html.'" --footer-html "'.$footer_html.'" "'.$local_htmlfile.'" "'.$local_file.'"',$output);
            }
            Log::info($output);
            Log::info($local_htmlfile);
            @unlink($local_htmlfile);
            @unlink($footer_html);
            if (file_exists($local_file)) {
                $fullPath = $amazonPath . basename($local_file); //$destinationPath . $file_name;
                if (AmazonS3::upload($local_file, $amazonPath,$companyID)) {
                    return $fullPath;
                }
            }
            return '';
        }
    }

    //Not in Use
    public static function calculateUsageTax($AccountID, $UsageSubTotal){

        //Get Account TaxIDs
        $TaxRateIDs = AccountBilling::getTaxRate($AccountID);
        $TotalTax = 0;
        if(!empty($TaxRateIDs)){

            $TaxRateIDs = explode(",",$TaxRateIDs);

            foreach($TaxRateIDs as $TaxRateID) {

                $TaxRateID = intval($TaxRateID);

                if($TaxRateID>0){

                    $TaxRate = TaxRate::where("TaxRateID",$TaxRateID)->where("TaxType",TaxRate::TAX_USAGE )->first();

                    if(isset($TaxRate->Amount)) {

                        if ($TaxRate->FlatStatus == 1) {

                            $TotalTax = $TaxRate->Amount;

                        } else {

                            $TotalTax = (($UsageSubTotal * $TaxRate->Amount) / 100);
                        }
                    }
                }
            }
        }
        return $TotalTax;

    }

    /**
    Calculate Total Tax on Invoice (Only Add Tax on Overall Invoice + Recurring Tax )
     *  Will add with passed usageTotalTax
     */
    public static function insertInvoiceTaxRate($InvoiceID,$AccountID,$InvoiceSubTotal,$AdditionalChargeTax) {

        /*$Invoice = Invoice::find($InvoiceID);
        $InvoiceSubTotal = $Invoice->SubTotal;*/

        //Get Account TaxIDs
        $TaxRateIDs = AccountBilling::getTaxRate($AccountID);

        $InvoiceDetails = InvoiceDetail::where("InvoiceID",$InvoiceID)->where("ProductType",Product::SUBSCRIPTION)->get();
        $SubscriptionTotal = 0;
        foreach($InvoiceDetails as $InvoiceDetails){
            $SubscriptionTotal +=   $InvoiceDetails->LineTotal;
        }
        //delete tax first
        InvoiceTaxRate::where("InvoiceID",$InvoiceID)->delete();

        $UsageTotal = InvoiceDetail::where("InvoiceID",$InvoiceID)->where("ProductType",Product::USAGE)->pluck('LineTotal');

        $TaxGrandTotal = 0;
        if(!empty($TaxRateIDs)){

            $TaxRateIDs = explode(",",$TaxRateIDs);

            foreach($TaxRateIDs as $TaxRateID) {

                $TaxRateID = intval($TaxRateID);

                if($TaxRateID>0){

                    $SubTotal = 0;
                    $TaxRate = TaxRate::where("TaxRateID",$TaxRateID)->first();
                    $Title = '';
                    if(isset($TaxRate->TaxType) && isset($TaxRate->Amount) ) {

                        if ($TaxRate->TaxType == TaxRate::TAX_ALL) {
                            $SubTotal = $InvoiceSubTotal;
                            $Title = $TaxRate->Title;
                        } else if ($TaxRate->TaxType == TaxRate::TAX_USAGE) {
                            $SubTotal = $UsageTotal;
                            $Title = $TaxRate->Title . ' (Usage)';

                        } else if ($TaxRate->TaxType == TaxRate::TAX_RECURRING) {
                            $SubTotal = $SubscriptionTotal;
                            $Title = $TaxRate->Title . ' (Subscription)';
                        }

                        $TotalTax = Invoice::calculateTotalTaxByTaxRateObj($TaxRate, $SubTotal);
                        /*if ($TaxRate->TaxType == TaxRate::TAX_ALL) {
                             $TotalTax += $AdditionalChargeTax;
                            Log::info('AdditionalChargeTax - ' . $AdditionalChargeTax);
                             $AdditionalChargeTax = 0;
                        }*/
                        $TaxGrandTotal += $TotalTax;
                        InvoiceTaxRate::create(array(
                            "InvoiceID" => $InvoiceID,
                            "TaxRateID" => $TaxRateID,
                            "TaxAmount" => $TotalTax,
                            "Title" => $Title,
                        ));
                    }
                }
            }
        }
        $TaxGrandTotal += self::addOneOffTaxCharge($InvoiceID,$AccountID);
        return $TaxGrandTotal;
    }

    public static function calculateTotalTaxByTaxRateObj($TaxRate , $SubTotal )
    {
        $TotalTax = 0;

        if(isset($TaxRate->FlatStatus) && isset($TaxRate->Amount)) {
            if ($TaxRate->FlatStatus == 1 && $SubTotal != 0) {

                $TotalTax = $TaxRate->Amount;

            } else {

                $TotalTax = (($SubTotal * $TaxRate->Amount) / 100);

            }

        }

        return $TotalTax;
    }
    public static function regenerateInvoice($CompanyID,$Invoice, $InvoiceDetail,$InvoiceGenerationEmail,$ProcessID,$JobID){
        $error = array();
        $message = array();
        $SubTotal = 0;
        $SubTotalWithoutTax = $AdditionalChargeTax =  0;
        $regenerate =1;
        $Account = Account::find((int)$Invoice->AccountID);
        $AccountBilling = AccountBilling::getBillingClass($Invoice->AccountID);
        $AccountID = $Account->AccountID;
        $StartDate = date("Y-m-d", strtotime($InvoiceDetail[0]->StartDate));
        $EndDate = date("Y-m-d 23:59:59", strtotime($InvoiceDetail[0]->EndDate));

        if($AccountID > 0 && $CompanyID > 0 && !empty($StartDate) && !empty($EndDate)) {
            $CompanyName = Company::getName($CompanyID);

            if (!empty($Account)) {
                $InvoiceTemplate = InvoiceTemplate::where("InvoiceTemplateID", $AccountBilling->InvoiceTemplateID)->select(["Terms","FooterTerm", "InvoiceNumberPrefix","DateFormat"])->first();
                if ( empty($AccountBilling->InvoiceTemplateID) || empty($InvoiceTemplate) ) {
                    $error['message'] = $Account->AccountName . ' ' . Invoice::$InvoiceGenrationErrorReasons['InvoiceTemplate'];
                    $error['status'] = 'failure';
                    return $error;
                }
                if (!empty($InvoiceTemplate)) {
                    $decimal_places = Helper::get_round_decimal_places($CompanyID,$Account->AccountID);

                    Log::info('Invoice::getAccountUsageTotal(' . $CompanyID . ',' . $AccountID . ',' . $StartDate . ',' . $EndDate . ')');
                    $InvoiceTemplate->DateFormat = invoice_date_fomat($InvoiceTemplate->DateFormat);

                    //get Total Usage
                    $TotalCharges = Invoice::getAccountUsageTotal($CompanyID, $AccountID, $StartDate, $EndDate);


                    Log::info('TotalCharges - ' . $TotalCharges);


                    $Address = Account::getFullAddress($Account);

                    $TotalUsageCharges = number_format($TotalCharges, $decimal_places, '.', '');

                    $SubTotal += $TotalUsageCharges;

                    /**
                     * Add Tax Rate
                     * */
                    Log::info('TotalUsageCharges - ' . $TotalUsageCharges);

                    /**
                     * Update Data in Invoice
                     */
                    $Invoicedataarray = array();
                    $Invoicedataarray['Address'] = $Address;
                    $Invoicedataarray['CurrencyID'] = $Account->CurrencyId;
                    $Invoicedataarray['Note'] = "ReGenerated on " . date($InvoiceTemplate->DateFormat);
                    $Invoicedataarray['Terms'] = $InvoiceTemplate->Terms;
                    $Invoicedataarray['FooterTerm'] = $InvoiceTemplate->FooterTerm;
                    $Invoicedataarray['InvoiceStatus'] = self::AWAITING;
                    $Invoice->update($Invoicedataarray);
                    /**
                     * Update Usage in InvoiceDetail
                     */
                    $ProductDescription = " From " . date($InvoiceTemplate->DateFormat, strtotime($StartDate)) . " To " . date($InvoiceTemplate->DateFormat, strtotime($EndDate));
                    $InvoiceDetailData = array();
                    $InvoiceDetailData["InvoiceID"] = $Invoice->InvoiceID;
                    $InvoiceDetailData['ProductID'] = 0;
                    $InvoiceDetailData['ProductType'] = Product::USAGE;
                    $InvoiceDetailData['Description'] = $ProductDescription;
                    $InvoiceDetailData['StartDate'] = $StartDate;
                    $InvoiceDetailData['EndDate'] = $EndDate;
                    $InvoiceDetailData['Price'] = $TotalUsageCharges;
                    $InvoiceDetailData['Qty'] = 1;
                    $InvoiceDetailData['Discount'] = 0;
                    $InvoiceDetailData['LineTotal'] = $TotalUsageCharges;
                    $InvoiceDetailData["updated_at"] = date("Y-m-d H:i:s");
                    $InvoiceDetailData["ModifiedBy"] = 'RMScheduler';
                    InvoiceDetail::where(array('InvoiceID' => $Invoice->InvoiceID, 'ProductID' => 0, 'ProductType' => Product::USAGE))->update($InvoiceDetailData);

                    /**
                     * Insert Data in InvoiceLog
                     */
                    $invoiceloddata = array();
                    $invoiceloddata['InvoiceID'] = $Invoice->InvoiceID;
                    $invoiceloddata['Note'] = InvoiceLog::$log_status[InvoiceLog::REGENERATED].' By RMScheduler';
                    $invoiceloddata['created_at'] = date("Y-m-d H:i:s");
                    $invoiceloddata['InvoiceLogStatus'] = InvoiceLog::REGENERATED;
                    InvoiceLog::insert($invoiceloddata);

                    // }
                    Log::info('Usage Over');

                    /**
                     * Add Subscription in InvoiceDetail if any
                     */
                    $subResponse = self::addSubscription($Invoice,$InvoiceTemplate,$StartDate,$EndDate,$SubTotal,$decimal_places,$regenerate);
                    $SubTotal = $subResponse["SubTotal"];
                    $SubTotalWithoutTax += $subResponse["SubscriptionChargewithouttaxTotal"];

                    /**
                     * Add OneOffCharge in InvoiceDetail if any
                     */
                    $subResponse = self::addOneOffCharge($Invoice,$InvoiceTemplate,$StartDate,$EndDate,$SubTotal,$decimal_places,$regenerate);
                    $SubTotal = $subResponse["SubTotal"];
                    $SubTotalWithoutTax += $subResponse["SubscriptionChargewithouttaxTotal"];
                    $AdditionalChargeTax = $subResponse["AdditionalChargeTotalTax"];


                    Log::info('USAGE FILE & Invoice PDF & EMAIL Start');

                    if (isset($Invoice)) {

                        // Add Tax in Subtotal and Update all Total Fields in Invoice Table.
                        $totals = self::updateInvoiceAllTotalAmounts($Invoice,$SubTotal,$SubTotalWithoutTax,$AdditionalChargeTax,$decimal_places);

                        /*
                         * PDF Generation CODE HERE
                         *
                         */
                        Log::info('PDF Generation start');

                        $pdf_path = Invoice::generate_pdf($Invoice->InvoiceID);
                        if (empty($pdf_path)) {
                            $error['message'] = Invoice::$InvoiceGenrationErrorReasons["PDF"];
                            $error['status'] = 'failure';
                            return $error;
                        } else {
                            $Invoice->update(["PDF" => $pdf_path]);
                        }

                        Log::info('PDF fullPath ' . $pdf_path);

                        /** Generate Usage File **/
                        Log::info('Generate Usage File Start ');

                        $fullPath = "";
                        $message['message'] = $Account->AccountName.' ('.$Invoice->InvoiceNumber.')';
                        if ($AccountBilling->CDRType != Account::NO_CDR) { // Check in to generate Invoice usage file or not
                            $InvoiceID = $Invoice->InvoiceID;
                            if ($InvoiceID > 0 && $AccountID > 0) {
                                $fullPath = Invoice::generate_usage_file($InvoiceID);
                                if (empty($fullPath)) {
                                    $error['message'] = $Account->AccountName . ' ' . Invoice::$InvoiceGenrationErrorReasons['UsageFile'];
                                    $error['status'] = 'failure';
                                }
                            }
                        }

                        Log::info('Usage File fullPath ' . $fullPath);

                        if(empty($error)) {

                            $status = self::EmailToCustomer($Account,$totals['GrandTotal'],$Invoice,$InvoiceTemplate->InvoiceNumberPrefix,$CompanyName,$CompanyID,$InvoiceGenerationEmail,$ProcessID,$JobID);


                            if(isset($status['status']) && isset($status['message']) && $status['status']=='failure'){
                                $error_1 = $status['message'];
                            }

                        }




                    }//Email Sending over
                    Log::info('=========== Email Sending over =========== ');
                }
                if (!empty($error)) {
                    Log::info('=========== Returning as Error =========== ' . print_r($error,true));
                    return $error;
                } else {
                    $message['message']= ' Invoice Regenerated '.(isset($message['message'])?$message['message']:'');
                    $message['status'] = "success";
                    Log::info('=========== Returning as Success =========== AccountID ' . $AccountID);
                    return $message;
                }
            }
        }
    }

    public static  function EmailToCustomer($Account,$GrandTotal,$Invoice,$InvoiceNumberPrefix,$CompanyName,$CompanyID,$InvoiceGenerationEmail,$ProcessID,$JobID){


        $status = array();
        $errorslog = array();

        /**
         * Send Email to Staff
         */
        $emaildata = array();
        $Currency = Currency::find($Account->CurrencyId);
        $WEBURL = CompanyConfiguration::get($CompanyID,'WEB_URL');
        $EMAIL_TO_CUSTOMER = CompanyConfiguration::get($CompanyID,'EMAIL_TO_CUSTOMER');
        $CurrencyCode = !empty($Currency) ? $Currency->Code : '';
        $_InvoiceNumber = $Invoice->FullInvoiceNumber;
        $emaildata['data'] = array(
            'InvoiceNumber' => $_InvoiceNumber,
            'CompanyName' => $CompanyName,
            'InvoiceGrandTotal' => $GrandTotal,
            'CurrencyCode' => $CurrencyCode,
            'InvoiceLink' => $WEBURL . '/invoice/' . $Invoice->InvoiceID . '/invoice_preview'
        );
        $emaildata['EmailToName'] = $CompanyName;
        $emaildata['Subject'] = 'New invoice ' . $_InvoiceNumber . ' from ' . $CompanyName;
        $emaildata['CompanyID'] = $CompanyID;

        $status['status'] = "success"; // Default Status

        foreach ($InvoiceGenerationEmail as $singleemail) {
            $singleemail = trim($singleemail);
            if (filter_var($singleemail, FILTER_VALIDATE_EMAIL)) {
                $emaildata['EmailTo'] = $singleemail;
                $emaildata['Subject'] = 'New invoice ' . $_InvoiceNumber . '('.$Account->AccountName.') from ' . $CompanyName;
                $status = Helper::sendMail('emails.invoices.bulk_invoice_email', $emaildata);
                $Invoice->update(['InvoiceStatus' => Invoice::AWAITING]);
                if ($status['status'] == 0) {
                    $status['status'] = 'failure';
                    Log::info('Email Sending Failed to Staff '  . print_r($status, true));
                }
            }
        }

        Log::info('Sending Email to Staff over');
        Log::info('Email Status  ' .$status['status'] );


        //-----------------------------------------------------------------------------

        Log::info('Sending Email to Customer') ;

        /** Email to Customer * */
        // Send only When Auto Invoice is On and GrandTotal is set.
        //If Recurring invoice and Auto Invoice on from Recurring Section
        $canSend = 0;
        if(!empty($Invoice->RecurringInvoiceID) && $Invoice->RecurringInvoiceID>0){
            $recurringInvoice = RecurringInvoice::find($Invoice->RecurringInvoiceID);
            $billingClass = BillingClass::getBillingClass($recurringInvoice->BillingClassID);
            if(!empty($billingClass)) {
                if ($billingClass->SendInvoiceSetting == 'automatically') {
                    $canSend = 1;
                }
            }else{
                $status['status'] = 'failure';
                $status['message'] = 'No recurring class found against '.$Invoice->InvoiceID;

            }
        }else if(AccountBilling::getSendInvoiceSetting($Account->AccountID) == 'automatically'){
            $canSend=1;
        }
        if( $EMAIL_TO_CUSTOMER == 1 && $canSend == 1  && $GrandTotal > 0 ) {

            $InvoiceGenerationEmail = Notification::getNotificationMail(['CompanyID' => $CompanyID, 'NotificationType' => Notification::InvoiceCopy]);
            //$CustomerEmail = $Account->BillingEmail;    //$CustomerEmail = 'deven@code-desk.com'; //explode(",", $CustomerEmail);
            //$emaildata['data']['InvoiceLink'] = getenv("WEBURL") . '/invoice/' . $Account->AccountID . '-' . $Invoice->InvoiceID . '/cview';
            //$emaildata['EmailTo'] = $InvoiceGenerationEmail; //'girish.vadher@code-desk.com'; //$Company->InvoiceGenerationEmail; //$Account->BillingEmail;
            //$status = Helper::sendMail('emails.invoices.bulk_invoice_email', $emaildata);
            if(!empty($InvoiceGenerationEmail)) {
                $InvoiceGenerationEmail = explode(',',$InvoiceGenerationEmail);
                foreach ($InvoiceGenerationEmail as $singleemail) {
                    $singleemail = trim($singleemail);
                    if (filter_var($singleemail, FILTER_VALIDATE_EMAIL)) {
                        $emaildata['EmailTo'] = $singleemail;
                        $emaildata['data']['InvoiceLink'] = $WEBURL . '/invoice/' . $Account->AccountID . '-' . $Invoice->InvoiceID . '/cview?email=' . $singleemail;
                        $status = Helper::sendMail('emails.invoices.bulk_invoice_email', $emaildata);
                    }
                }
            }

            if (!empty($Account->BillingEmail)) {
                $CustomerEmails = explode(',',$Account->BillingEmail);
                foreach ($CustomerEmails as $singleemail) {
                    $singleemail = trim($singleemail);
                    if (filter_var($singleemail, FILTER_VALIDATE_EMAIL)) {
                        $emaildata['EmailTo'] = $singleemail;
                        $emaildata['data']['InvoiceLink'] = $WEBURL . '/invoice/' . $Account->AccountID . '-' . $Invoice->InvoiceID . '/cview?email=' . $singleemail;
                        $status = Helper::sendMail('emails.invoices.bulk_invoice_email', $emaildata);
                    }
                }

                if ($status['status'] == 0) {
                    $email_sending_failed[] = $Account->AccountName;
                    $status['status'] = 'failure';
                    $status['message'] = $Account->AccountName . ' ' . Invoice::$InvoiceGenrationErrorReasons['Email'];
                    $Invoice->update(['InvoiceStatus' => Invoice::AWAITING, "Note" => $Invoice->Note . " \n Failed to send Email at " . date("Y-m-d H:i:s")]);
                } else {
                    $status['status'] = "success";
                    $Invoice->update(['InvoiceStatus' => Invoice::SEND]);

                    $invoiceloddata = array();
                    $invoiceloddata['InvoiceID'] = $Invoice->InvoiceID;
                    $invoiceloddata['Note'] = InvoiceLog::$log_status[InvoiceLog::SENT] . ' By RMScheduler';
                    $invoiceloddata['created_at'] = date("Y-m-d H:i:s");
                    $invoiceloddata['InvoiceLogStatus'] = InvoiceLog::SENT;
                    InvoiceLog::insert($invoiceloddata);

                    if (!empty($Invoice->RecurringInvoiceID) && $Invoice->RecurringInvoiceID > 0) {
                        $RecurringInvoiceLogData = array();
                        $RecurringInvoiceLogData['RecurringInvoiceID'] = $Invoice->RecurringInvoiceID;
                        $RecurringInvoiceLogData['Note'] = 'Invoice ' . $Invoice->FullInvoiceNumber.' '.RecurringInvoiceLog::$log_status[RecurringInvoiceLog::SENT] .' By RMScheduler';
                        $RecurringInvoiceLogData['created_at'] = date("Y-m-d H:i:s");
                        $RecurringInvoiceLogData['RecurringInvoiceLogStatus'] = RecurringInvoiceLog::SENT;
                        RecurringInvoiceLog::insert($RecurringInvoiceLogData);
                    }

                    $User = '';
                    if (!@empty($Account->Owner)) {
                        $User = User::find($Account->Owner);
                    }
                    /** log emails against account */
                    $statuslog = Helper::account_email_log($CompanyID, $Account->AccountID, $emaildata, $status, $User, $ProcessID, $JobID);

                    if ($statuslog['status'] == 0) {
                        $status['status'] = 'failure';
                        $errorslog[] = $Account->AccountName . ' email log exception:' . $statuslog['message'];
                        $status['message'] = $statuslog['message'];
                    }

                }

            }else{
                if(!empty($Invoice->RecurringInvoiceID) && $Invoice->RecurringInvoiceID > 0) {
                    $status['status'] = 'failure';
                    $status['message'] = $Account->AccountName . ': Invoice ' . $Invoice->FullInvoiceNumber . ' is created but not sent ( Email not set up )';
                }
            }
        }
        return $status;
    }

    public static function updateInvoiceAllTotalAmounts($Invoice,$SubTotal,$SubTotalWithoutTax,$AdditionalChargeTax,$decimal_places){

        /**
         * Find
         * Previous Balance
         * Charge for this period  - usage + subscription + vat
         * Total
         */
        $PreviousBalanceTotal  = DB::connection('sqlsrv2')->select("CALL prc_getAccountPreviousBalance($Invoice->CompanyID,$Invoice->AccountID,$Invoice->InvoiceID )" );
        $PreviousBalance = 0;
        if(isset($PreviousBalanceTotal[0]->PreviousBalance)) {

            $PreviousBalance = $PreviousBalanceTotal[0]->PreviousBalance;
        }


        /* Finalize Invoice Total */

        /* Total Tax to update here */
        Log::info(' SubTotal ' . $SubTotal);
        Log::info(' SubTotalWithouttaxTotal ' . $SubTotalWithoutTax);
        $TotalTax = Invoice::insertInvoiceTaxRate($Invoice->InvoiceID,$Invoice->AccountID, $SubTotal,$AdditionalChargeTax);
        //$TotalTax += $AdditionalChargeTax; // Additional Tax from AdditionalCharge

        Log::info(' TotalTax ' . $TotalTax);

        $InvoiceGrandTotal = $SubTotal + $TotalTax + $SubTotalWithoutTax; // Total Tax Added in Grand Total.

        $TotalDue = $InvoiceGrandTotal + $PreviousBalance; // Grand Total - Previous Balance is Total Due.

        $InvoiceGrandTotal = number_format($InvoiceGrandTotal, $decimal_places, '.', '');
        $SubTotal = number_format($SubTotal+$SubTotalWithoutTax, $decimal_places, '.', '');
        $TotalTax = number_format($TotalTax, $decimal_places, '.', '');
        $TotalDue = number_format($TotalDue, $decimal_places, '.', '');

        Log::info('GrandTotal ' . $InvoiceGrandTotal);
        Log::info('SubTotal ' . $SubTotal);
        Log::info('TotalDue ' . $TotalDue);

        $Totals = ["TotalTax"=> $TotalTax , "GrandTotal" => $InvoiceGrandTotal,"SubTotal" => $SubTotal,'PreviousBalance'=>$PreviousBalance,'TotalDue'=>$TotalDue];
        $Invoice->update($Totals);
        return $Totals;
    }

    public static function addSubscription($Invoice,$InvoiceTemplate,$StartDate,$EndDate,$SubTotal,$decimal_places,$regenerate = 0){

        // Get All Account Subscriptions
        $AccountSubscriptions = AccountSubscription::join('tblBillingSubscription', 'tblAccountSubscription.SubscriptionID', '=', 'tblBillingSubscription.SubscriptionID')->where("tblAccountSubscription.AccountID", $Invoice->AccountID)->select("tblAccountSubscription.*")->orderBy('SequenceNo','asc')->get();
        $SubscriptionChargewithouttaxTotal = 0;
        Log::info('SUBSCRIPTION '.count($AccountSubscriptions)) ;
        $StartDate = date("Y-m-d",strtotime($StartDate));
        $EndDate = date("Y-m-d",strtotime($EndDate));
        if($regenerate == 1) {
            InvoiceDetail::where(array('InvoiceID'=>$Invoice->InvoiceID,'ProductType'=>Product::SUBSCRIPTION))->delete();
        }
        if (count($AccountSubscriptions)) {

            /**
             * If Account has any subscription then
             *      check if first time billing
             *          get Subscription StartDate to yesterday Date
             *          Find Total Subscription Amount and update into InvoiceDetail.
             *      else
             *          Find Total Subscription Amount for same duration and update into InvoiceDetail.
             * END
             * */

            foreach ($AccountSubscriptions as $AccountSubscription) {
                $isAdvanceSubscription =0;
                /**check for advance subscription*/
                Log::info( " ============================Subscription Start ================= \n\n");
                Log::info( ' SubscriptionID - ' . $AccountSubscription->SubscriptionID );
                if($AccountSubscription->EndDate == '0000-00-00'){
                    $AccountSubscription->EndDate  = date("Y-m-d",strtotime('+1 years'));
                }
                if(BillingSubscription::isAdvanceSubscription($AccountSubscription->SubscriptionID)){
                $isAdvanceSubscription =1;
                    Log::info( 'isAdvanceSubscription - ' . $AccountSubscription->SubscriptionID );

                    //Advance Subscription Date
                    $SubscriptionStartDate = Invoice::calculateNextInvoiceDateFromLastInvoiceDate($Invoice->CompanyID,$Invoice->AccountID,$StartDate); // Advance Date 1-7-2015 - 1-8-2015
                    $SubscriptionEndDate = Invoice::calculateNextInvoiceDateFromLastInvoiceDate($Invoice->CompanyID,$Invoice->AccountID,$SubscriptionStartDate); // Advance Date 1-7-2015 - 1-8-2015
                    $SubscriptionEndDate = date("Y-m-d", strtotime("-1 Day", strtotime($SubscriptionEndDate))); // Convert 1-8-2015 -to 31-7-2015

                    if (AccountSubscription::checkFirstTimeBilling($AccountSubscription->StartDate,$StartDate)) {
                        Log::info( 'First Time + Advance Billing - Yes' );

                        /**
                         * regular Subscription '1-1-2015' to '1-1-2016'
                         * charge for '1-3-2015' to '1-4-2015'
                         */
                        if( $StartDate >= $AccountSubscription->StartDate && $StartDate <= $AccountSubscription->EndDate && $EndDate >= $AccountSubscription->StartDate && $EndDate <= $AccountSubscription->EndDate) {
                            Log::info( 'regular Subscription if advance ' );
                            //Charge Current Subscription Date
                            $addInvoiceSubscriptionDetail =  Invoice::addInvoiceSubscriptionDetail($Invoice,$AccountSubscription,$StartDate,$EndDate,$SubscriptionChargewithouttaxTotal,$SubTotal,$decimal_places);
                            $SubTotal = $addInvoiceSubscriptionDetail['SubTotal'];
                            $SubscriptionChargewithouttaxTotal = $addInvoiceSubscriptionDetail['SubscriptionChargewithouttaxTotal'];
                        }else if( $AccountSubscription->StartDate >= $StartDate && $AccountSubscription->StartDate <= $EndDate ){
                            /**
                             *Special Subscription with StartDate  '15-3-2015' to '1-1-2016'
                             * charge for '1-3-2015' to '1-4-2015' should take '15-3-2015' to '1-4-2015'
                             */
                            $SubscriptionStartDateReg = $AccountSubscription->StartDate;
                            $SubscriptionEndDateReg = $EndDate;
                            Log::info( 'charge half of month - Subscription Start after StartDate' );
                            if($AccountSubscription->EndDate < $EndDate){
                                $SubscriptionEndDateReg = $AccountSubscription->EndDate;// '15-3-2015' to '20-3-2015'
                                Log::info( 'charge half of month - Subscription end before EndDate' );
                            }
                            $addInvoiceSubscriptionDetail =  Invoice::addInvoiceSubscriptionDetail($Invoice,$AccountSubscription,$SubscriptionStartDateReg,$SubscriptionEndDateReg,$SubscriptionChargewithouttaxTotal,$SubTotal,$decimal_places);
                            $SubTotal = $addInvoiceSubscriptionDetail['SubTotal'];
                            $SubscriptionChargewithouttaxTotal = $addInvoiceSubscriptionDetail['SubscriptionChargewithouttaxTotal'];
                        }else if( $AccountSubscription->EndDate >= $StartDate && $AccountSubscription->EndDate <= $EndDate ){
                            /**
                             *Special Subscription with EndDate  '1-1-2015' to '15-3-2015'
                             * charge for '1-3-2015' to '1-4-2015' should take '1-3-2015' to '15-3-2015'
                             */
                            Log::info( 'charge half of month - 2 Subscription end before EndDate' );
                            $SubscriptionEndDateReg = $AccountSubscription->EndDate;
                            $addInvoiceSubscriptionDetail =  Invoice::addInvoiceSubscriptionDetail($Invoice,$AccountSubscription,$StartDate,$SubscriptionEndDateReg,$SubscriptionChargewithouttaxTotal,$SubTotal,$decimal_places);
                            $SubTotal = $addInvoiceSubscriptionDetail['SubTotal'];
                            $SubscriptionChargewithouttaxTotal = $addInvoiceSubscriptionDetail['SubscriptionChargewithouttaxTotal'];
                        }

                    }
                }else{
                    $SubscriptionStartDate = $StartDate;
                    $SubscriptionEndDate = $EndDate;
                }
                Log::info( ' SubscriptionID - ' . $SubscriptionStartDate.'====='.$SubscriptionEndDate);
                Log::info( ' AccountSubscriptionID - '.$AccountSubscription->AccountSubscriptionID. ' === ' . $AccountSubscription->StartDate.'====='.$AccountSubscription->EndDate);

                //if advance subscription + regular month ( 2 entry for same subscription )
                //1. StartDate 15-7-2015 End Date 31-7-2015
                //2. 15-7-2015-31-7-2015 + 1-8-2015 -30-8-2015

               /**
                 * regular Subscription '1-1-2015' to '1-1-2016'
                 * charge for '1-3-2015' to '1-4-2015'
                 */
                if( $isAdvanceSubscription == 0 && $SubscriptionStartDate >= $AccountSubscription->StartDate && $SubscriptionStartDate <= $AccountSubscription->EndDate && $SubscriptionEndDate >= $AccountSubscription->StartDate && $SubscriptionEndDate <= $AccountSubscription->EndDate) {
                    Log::info( 'regular Subscription ' );
                    $addInvoiceSubscriptionDetail =  Invoice::addInvoiceSubscriptionDetail($Invoice,$AccountSubscription,$SubscriptionStartDate,$SubscriptionEndDate,$SubscriptionChargewithouttaxTotal,$SubTotal,$decimal_places);
                    $SubTotal = $addInvoiceSubscriptionDetail['SubTotal'];
                    $SubscriptionChargewithouttaxTotal = $addInvoiceSubscriptionDetail['SubscriptionChargewithouttaxTotal'];
                }else if( $isAdvanceSubscription == 0 && $AccountSubscription->StartDate >= $SubscriptionStartDate && $AccountSubscription->StartDate <= $SubscriptionEndDate ){
                    /**
                     *Special Subscription with StartDate  '15-3-2015' to '1-1-2016'
                     * charge for '1-3-2015' to '1-4-2015' should take '15-3-2015' to '1-4-2015'
                     */
                    $SubscriptionStartDate = $AccountSubscription->StartDate;
                    Log::info( 'charge half of month - Subscription Start after StartDate' );
                    if($AccountSubscription->EndDate < $SubscriptionEndDate){
                        $SubscriptionEndDate = $AccountSubscription->EndDate;// '15-3-2015' to '20-3-2015'
                        Log::info( 'charge half of month - Subscription end before EndDate' );
                    }
                    $addInvoiceSubscriptionDetail =  Invoice::addInvoiceSubscriptionDetail($Invoice,$AccountSubscription,$SubscriptionStartDate,$SubscriptionEndDate,$SubscriptionChargewithouttaxTotal,$SubTotal,$decimal_places);
                    $SubTotal = $addInvoiceSubscriptionDetail['SubTotal'];
                    $SubscriptionChargewithouttaxTotal = $addInvoiceSubscriptionDetail['SubscriptionChargewithouttaxTotal'];
                }else if($isAdvanceSubscription ==0 && $AccountSubscription->EndDate >= $SubscriptionStartDate && $AccountSubscription->EndDate <= $SubscriptionEndDate ){
                    /**
                     *Special Subscription with EndDate  '1-1-2015' to '15-3-2015'
                     * charge for '1-3-2015' to '1-4-2015' should take '1-3-2015' to '15-3-2015'
                     */
                    Log::info( 'charge half of month - 2 Subscription end before EndDate' );
                    $SubscriptionEndDate = $AccountSubscription->EndDate;
                    $addInvoiceSubscriptionDetail =  Invoice::addInvoiceSubscriptionDetail($Invoice,$AccountSubscription,$SubscriptionStartDate,$SubscriptionEndDate,$SubscriptionChargewithouttaxTotal,$SubTotal,$decimal_places);
                    $SubTotal = $addInvoiceSubscriptionDetail['SubTotal'];
                    $SubscriptionChargewithouttaxTotal = $addInvoiceSubscriptionDetail['SubscriptionChargewithouttaxTotal'];
                }else if($isAdvanceSubscription ==1 && $AccountSubscription->EndDate >= $SubscriptionStartDate && $AccountSubscription->EndDate <= $SubscriptionEndDate ){
                    /** if advance subscription and expiring in current month
                     *Special Subscription with EndDate  '2015-08-01' to '2015-11-03'
                     * Advance charge for '1-11-2015' to '31-11-2015' should take '1-11-2015' to '03-11-2015'
                     */
                    Log::info( 'advance charge for next month expiring subscription.' );
                    $SubscriptionEndDate = $AccountSubscription->EndDate;
                    $addInvoiceSubscriptionDetail =  Invoice::addInvoiceSubscriptionDetail($Invoice,$AccountSubscription,$SubscriptionStartDate,$SubscriptionEndDate,$SubscriptionChargewithouttaxTotal,$SubTotal,$decimal_places);
                    $SubTotal = $addInvoiceSubscriptionDetail['SubTotal'];
                    $SubscriptionChargewithouttaxTotal = $addInvoiceSubscriptionDetail['SubscriptionChargewithouttaxTotal'];
                }else if( $isAdvanceSubscription ==1 && $SubscriptionStartDate > $AccountSubscription->StartDate && $SubscriptionStartDate <= $AccountSubscription->EndDate && $SubscriptionEndDate >= $AccountSubscription->StartDate && $SubscriptionEndDate <= $AccountSubscription->EndDate) {
                    Log::info( 'regular Advance Subscription ' );
                    //Charge Current Subscription Date
                    $addInvoiceSubscriptionDetail =  Invoice::addInvoiceSubscriptionDetail($Invoice,$AccountSubscription,$SubscriptionStartDate,$SubscriptionEndDate,$SubscriptionChargewithouttaxTotal,$SubTotal,$decimal_places);
                    $SubTotal = $addInvoiceSubscriptionDetail['SubTotal'];
                    $SubscriptionChargewithouttaxTotal = $addInvoiceSubscriptionDetail['SubscriptionChargewithouttaxTotal'];
                }
                Log::info( " ============================Subscription End ================= \n\n");

            } // Subscription loop over



        } //Subscription over
        Log::info('SUBSCRIPTION Over');

        return array("SubTotal"=>$SubTotal,'SubscriptionChargewithouttaxTotal' => $SubscriptionChargewithouttaxTotal);
    }

    public static function addUsage($Account,$CompanyID, $AccountID,$StartDate,$EndDate,$InvoiceTemplate,$SubTotal,$decimal_places){

        Log::info('Invoice::getAccountUsageTotal('.$CompanyID.','. $AccountID.','. $StartDate.','. $EndDate.')') ;

        //get Total Usage
        $TotalCharges = Invoice::getAccountUsageTotal($CompanyID, $AccountID, $StartDate, $EndDate);

        /*if( $TotalCharges == 0 ) {
            $error = $Account->AccountName . ' ' . Invoice::$InvoiceGenrationErrorReasons['NoCDR'];
            return array("status" => "failure", "message" => $error);
        }*/

        Log::info('TotalCharges - '.$TotalCharges) ;

        //if ($TotalCharges > 0) {
        //Create Invoice even if TotalCharges is zero its used for PBX customer

        $Address = Account::getFullAddress($Account);

        $TotalUsageCharges = number_format($TotalCharges, $decimal_places, '.', '');

        $SubTotal += $TotalUsageCharges;

        /**
         * Add Tax Rate
         * */
        Log::info('TotalUsageCharges - '.$TotalUsageCharges) ;

        /**
         * Add Data in Invoice
         */
        $InvoiceNumber = InvoiceTemplate::getNextInvoiceNumber(AccountBilling::getInvoiceTemplateID($AccountID), $CompanyID);
        $Invoice = Invoice::insertInvoice(array(
            "CompanyID" => $CompanyID,
            "AccountID" => $AccountID,
            "Address" => $Address,
            "InvoiceNumber" => $InvoiceNumber,
            "FullInvoiceNumber" => $InvoiceTemplate->InvoiceNumberPrefix.$InvoiceNumber,
            "IssueDate" => date('Y-m-d'),
            "TotalDiscount" => 0,
            "CurrencyID" => $Account->CurrencyId,
            "Note" => "Auto Generated on " . date($InvoiceTemplate->DateFormat),
            "Terms" => $InvoiceTemplate->Terms,
            'FooterTerm' => $InvoiceTemplate->FooterTerm,
            "InvoiceStatus" => Invoice::AWAITING
        ));

        /**
         * Insert Data in InvoiceLog
         */
        $invoiceloddata = array();
        $invoiceloddata['InvoiceID'] = $Invoice->InvoiceID;
        $invoiceloddata['Note'] = InvoiceLog::$log_status[InvoiceLog::CREATED].' By RMScheduler';
        $invoiceloddata['created_at'] = date("Y-m-d H:i:s");
        $invoiceloddata['InvoiceLogStatus'] = InvoiceLog::CREATED;
        InvoiceLog::insert($invoiceloddata);


        //Store Last Invoice Number.
        InvoiceTemplate::find(AccountBilling::getInvoiceTemplateID($AccountID))->update(array("LastInvoiceNumber" => $InvoiceNumber));

        /**
         * Add Usage in InvoiceDetail
         */
        $ProductDescription = " From " . date($InvoiceTemplate->DateFormat, strtotime($StartDate)) . " To " . date($InvoiceTemplate->DateFormat, strtotime($EndDate));
        $InvoiceDetailData = array();
        $InvoiceDetailData["InvoiceID"] = $Invoice->InvoiceID;
        $InvoiceDetailData['ProductID'] = 0;
        $InvoiceDetailData['ProductType'] = Product::USAGE;
        $InvoiceDetailData['Description'] = $ProductDescription;
        $InvoiceDetailData['StartDate'] = $StartDate;
        $InvoiceDetailData['EndDate'] = $EndDate;
        $InvoiceDetailData['Price'] = $TotalUsageCharges;
        $InvoiceDetailData['Qty'] = 1;
        $InvoiceDetailData['Discount'] = 0;
        $InvoiceDetailData['LineTotal'] = $TotalUsageCharges;
        $InvoiceDetailData["created_at"] = date("Y-m-d H:i:s");
        $InvoiceDetailData["CreatedBy"] = 'RMScheduler';
        InvoiceDetail::insert($InvoiceDetailData);


        return array("SubTotal"=>$SubTotal,'Invoice' => $Invoice);

    }
    public static function addInvoiceSubscriptionDetail($Invoice,$AccountSubscription,$SubscriptionStartDate,$SubscriptionEndDate,$SubscriptionChargewithouttaxTotal,$SubTotal,$decimal_places){
        //if (!Invoice::checkIfAccountSubscriptionAlreadyBilled($Invoice->InvoiceID,$Invoice->CompanyID, $Invoice->AccountID, $AccountSubscription->SubscriptionID, $SubscriptionStartDate, $SubscriptionEndDate)  ) {

            /** Check if running first time having old subscriber customers.
             * which add activation fee in Total Amount.
             * */
            if (AccountSubscription::checkFirstTimeBilling($AccountSubscription->StartDate,$SubscriptionStartDate)) {
                $FirstTime = true;
            } else {
                $FirstTime = false;
            }
            Log::info('StartDate '. $SubscriptionStartDate .' AccountSubscription->StartDate '. $AccountSubscription->StartDate .' EndDate '. $SubscriptionEndDate .' AccountSubscription->EndDate '.$AccountSubscription->EndDate);
            $BillingCycleType = AccountBilling::where('AccountID',$Invoice->AccountID)->pluck('BillingCycleType');
            $QuarterSubscription =  0;
            if($BillingCycleType == 'quarterly'){
                $QuarterSubscription = 1;
            }elseif($BillingCycleType == 'yearly'){
                $QuarterSubscription = 2;
            }
            //Get Subscription Amount
            $SubscriptionCharge = AccountSubscription::getSubscriptionAmount($AccountSubscription->AccountSubscriptionID, $SubscriptionStartDate, $SubscriptionEndDate, $FirstTime,$QuarterSubscription);
            Log::info('AccountSubscription::getSubscriptionAmount('.$AccountSubscription->AccountSubscriptionID.','. $SubscriptionStartDate .','. $SubscriptionEndDate .','. $FirstTime .','.$QuarterSubscription.')');
            Log::info( 'SubscriptionCharge - ' . $SubscriptionCharge );

            /**
             *  Add Subscription to Invoice Grant Total .
             * */
            $qty = $AccountSubscription->Qty;
            $TotalSubscriptionCharge = ( $SubscriptionCharge * $qty );
            if($AccountSubscription->ExemptTax){
                $SubscriptionChargewithouttaxTotal += $TotalSubscriptionCharge;
            }else{
                $SubTotal += $TotalSubscriptionCharge;
            }

            $SubscriptionCharge = number_format($SubscriptionCharge, $decimal_places, '.', '');
            $TotalSubscriptionCharge = number_format($TotalSubscriptionCharge, $decimal_places, '.', '');

            Log::info( ' TotalSubscriptionCharge - ' . $TotalSubscriptionCharge );

            $ProductDescription = $AccountSubscription->InvoiceDescription;
            //$Subscription = BillingSubscription::find($AccountSubscription->SubscriptionID);
            $Subscription = AccountSubscription::find($AccountSubscription->AccountSubscriptionID);

        if ($FirstTime && $Subscription->ActivationFee >0) {
                $TotalActivationFeeCharge = ( $Subscription->ActivationFee * $qty );
                if($AccountSubscription->ExemptTax){
                    $SubscriptionChargewithouttaxTotal += $TotalActivationFeeCharge;
                }else{
                    $SubTotal += $TotalActivationFeeCharge;
                }
                $InvoiceDetailData = array();
                $InvoiceDetailData["InvoiceID"] = $Invoice->InvoiceID;
                $InvoiceDetailData['ProductID'] = $AccountSubscription->SubscriptionID;
                $InvoiceDetailData['ProductType'] = Product::SUBSCRIPTION;
                $InvoiceDetailData['Description'] = $ProductDescription.' Activation Fee';
                $InvoiceDetailData['StartDate'] = $SubscriptionStartDate;
                $InvoiceDetailData['EndDate'] = $SubscriptionEndDate;
                $InvoiceDetailData['Price'] = $Subscription->ActivationFee;
                $InvoiceDetailData['Qty'] = $qty;
                $InvoiceDetailData['Discount'] = 0;
                $InvoiceDetailData['LineTotal'] = $TotalActivationFeeCharge;
                $InvoiceDetailData["created_at"] = date("Y-m-d H:i:s");
                $InvoiceDetailData["CreatedBy"] = 'RMScheduler';
                InvoiceDetail::insert($InvoiceDetailData);
            }
            //$ProductDescription .= " From " . date($InvoiceTemplate->DateFormat, strtotime($SubscriptionStartDate)) . " To " . date($InvoiceTemplate->DateFormat, strtotime($SubscriptionEndDate));
            $InvoiceDetailData = array();
            $InvoiceDetailData["InvoiceID"] = $Invoice->InvoiceID;
            $InvoiceDetailData['ProductID'] = $AccountSubscription->SubscriptionID;
            $InvoiceDetailData['ProductType'] = Product::SUBSCRIPTION;
            $InvoiceDetailData['Description'] = $ProductDescription;
            $InvoiceDetailData['StartDate'] = $SubscriptionStartDate;
            $InvoiceDetailData['EndDate'] = $SubscriptionEndDate;
            $InvoiceDetailData['Price'] = $SubscriptionCharge;
            $InvoiceDetailData['Qty'] = $qty;
            $InvoiceDetailData['Discount'] = 0;
            $InvoiceDetailData['LineTotal'] = $TotalSubscriptionCharge;
            $InvoiceDetailData["created_at"] = date("Y-m-d H:i:s");
            $InvoiceDetailData["CreatedBy"] = 'RMScheduler';
            InvoiceDetail::insert($InvoiceDetailData);
            return array("SubTotal"=>$SubTotal,'SubscriptionChargewithouttaxTotal' => $SubscriptionChargewithouttaxTotal);

        //}
    }
    public static function addOneOffTaxCharge($InvoiceID,$AccountID){
        $InvoiceDetail = InvoiceDetail::where("InvoiceID",$InvoiceID)->get();
        $StartDate = date("Y-m-d", strtotime($InvoiceDetail[0]->StartDate));
        $EndDate = date("Y-m-d", strtotime($InvoiceDetail[0]->EndDate));

        $AccountOneOffCharges = AccountOneOffCharge::where("AccountID", $AccountID)->whereBetween('Date',array($StartDate,$EndDate))->get();
        $AdditionalChargeTotalTax = 0;
        Log::info('AccountOneOffCharge Tax '.count($AccountOneOffCharges)) ;
        if (count($AccountOneOffCharges)) {
            foreach ($AccountOneOffCharges as $AccountOneOffCharge) {
                Log::info(' AccountOneOffChargeID - ' . $AccountOneOffCharge->AccountOneOffChargeID);
                $LineTotal = ($AccountOneOffCharge->Price)*$AccountOneOffCharge->Qty;
                if($AccountOneOffCharge->TaxRateID || $AccountOneOffCharge->TaxRateID2){
                    $AdditionalChargeTotalTax += $AccountOneOffCharge->TaxAmount;

                    if($AccountOneOffCharge->TaxRateID){
                        $TaxRate = TaxRate::where("TaxRateID",$AccountOneOffCharge->TaxRateID)->first();
                        $TotalTax = Invoice::calculateTotalTaxByTaxRateObj($TaxRate, $LineTotal);
                        if(InvoiceTaxRate::where(['InvoiceID'=>$InvoiceID,'TaxRateID'=>$AccountOneOffCharge->TaxRateID])->count() == 0) {
                            InvoiceTaxRate::create(array(
                                "InvoiceID" => $InvoiceID,
                                "TaxRateID" => $AccountOneOffCharge->TaxRateID,
                                "TaxAmount" => $TotalTax,
                                "Title" => $TaxRate->Title,
                            ));
                        }else{
                            $TaxAmount = InvoiceTaxRate::where(['InvoiceID'=>$InvoiceID,'TaxRateID'=>$AccountOneOffCharge->TaxRateID])->pluck('TaxAmount');
                            InvoiceTaxRate::where(['InvoiceID'=>$InvoiceID,'TaxRateID'=>$AccountOneOffCharge->TaxRateID])->update(array('TaxAmount'=>$TotalTax+$TaxAmount));
                        }
                    }
                    if($AccountOneOffCharge->TaxRateID2){
                        $TaxRate = TaxRate::where("TaxRateID",$AccountOneOffCharge->TaxRateID2)->first();
                        $TotalTax = Invoice::calculateTotalTaxByTaxRateObj($TaxRate, $LineTotal);
                        if(InvoiceTaxRate::where(['InvoiceID'=>$InvoiceID,'TaxRateID'=>$AccountOneOffCharge->TaxRateID2])->count() == 0) {
                            InvoiceTaxRate::create(array(
                                "InvoiceID" => $InvoiceID,
                                "TaxRateID" => $AccountOneOffCharge->TaxRateID2,
                                "TaxAmount" => $TotalTax,
                                "Title" => $TaxRate->Title,
                            ));
                        }else{
                            $TaxAmount = InvoiceTaxRate::where(['InvoiceID'=>$InvoiceID,'TaxRateID'=>$AccountOneOffCharge->TaxRateID2])->pluck('TaxAmount');
                            InvoiceTaxRate::where(['InvoiceID'=>$InvoiceID,'TaxRateID'=>$AccountOneOffCharge->TaxRateID2])->update(array('TaxAmount'=>$TotalTax+$TaxAmount));
                        }
                    }

                    Log::info(' TaxAmount - ' . $AccountOneOffCharge->TaxAmount);
                }

            }
        } //Subscription over
        Log::info('AccountOneOffCharge Tax Over');

        return $AdditionalChargeTotalTax;


    }
    public static function addOneOffCharge($Invoice,$InvoiceTemplate,$StartDate,$EndDate,$SubTotal,$decimal_places,$regenerate = 0){
        $AccountOneOffCharges = AccountOneOffCharge::where("AccountID", $Invoice->AccountID)
                ->whereBetween('Date',array($StartDate,$EndDate))->get();
        $SubscriptionChargewithouttaxTotal = 0;
        $AdditionalChargeTotalTax = 0;
        Log::info('AccountOneOffCharge '.count($AccountOneOffCharges)) ;
        $StartDate = date("Y-m-d",strtotime($StartDate));
        $EndDate = date("Y-m-d",strtotime($EndDate));
        if($regenerate == 1) {
            InvoiceDetail::where(array('InvoiceID'=>$Invoice->InvoiceID,'ProductType'=>Product::ONEOFFCHARGE))->delete();
        }
        if (count($AccountOneOffCharges)) {
            foreach ($AccountOneOffCharges as $AccountOneOffCharge) {
                Log::info(' AccountOneOffChargeID - ' . $AccountOneOffCharge->AccountOneOffChargeID);

                Log::info(' AccountOneOffChargeID - ' . $AccountOneOffCharge->Date);
                $ProductDescription = $AccountOneOffCharge->Description;
                $singlePrice = $AccountOneOffCharge->Price;
                $LineTotal = ($AccountOneOffCharge->Price)*$AccountOneOffCharge->Qty;
                if($AccountOneOffCharge->TaxRateID || $AccountOneOffCharge->TaxRateID2){
                    $SubscriptionChargewithouttaxTotal += $LineTotal;
                    $AdditionalChargeTotalTax += $AccountOneOffCharge->TaxAmount;
                    Log::info(' TaxAmount - ' . $AccountOneOffCharge->TaxAmount);
                    //$SubTotal += $LineTotal+$AccountOneOffCharge->TaxAmount;
                }else{
                    $SubscriptionChargewithouttaxTotal += $LineTotal;
                }
                $singlePrice = number_format($singlePrice, $decimal_places, '.', '');
                $LineTotal = number_format($LineTotal, $decimal_places, '.', '');
                $InvoiceDetailData = array();
                $InvoiceDetailData["InvoiceID"] = $Invoice->InvoiceID;
                $InvoiceDetailData['ProductID'] = $AccountOneOffCharge->ProductID;
                $InvoiceDetailData['ProductType'] = Product::ONEOFFCHARGE;
                $InvoiceDetailData['Description'] = $ProductDescription ;
                $InvoiceDetailData['StartDate'] = $AccountOneOffCharge->Date;
                $InvoiceDetailData['EndDate'] = $AccountOneOffCharge->Date;
                $InvoiceDetailData['Price'] = $singlePrice;
                $InvoiceDetailData['Qty'] = $AccountOneOffCharge->Qty;
                $InvoiceDetailData['Discount'] = 0;
                $InvoiceDetailData['LineTotal'] = $LineTotal;
                $InvoiceDetailData["created_at"] = date("Y-m-d H:i:s");
                $InvoiceDetailData["CreatedBy"] = 'RMScheduler';
                InvoiceDetail::insert($InvoiceDetailData);
            }
        } //Subscription over
        Log::info('AccountOneOffCharge Over');

        return array("SubTotal"=>$SubTotal,'SubscriptionChargewithouttaxTotal' => $SubscriptionChargewithouttaxTotal,'AdditionalChargeTotalTax'=>$AdditionalChargeTotalTax);

    }

    public static function sendManualInvoice($CompanyID,$AccountID,$LastInvoiceDate,$NextInvoiceDate,$InvoiceGenerationEmail,$ProcessID,$JobID){

        $error = "";
        $StartDate = $LastInvoiceDate;		
        $EndDate =  date("Y-m-d 23:59:59", strtotime( "-1 Day", strtotime($NextInvoiceDate)));
		$print_type = Invoice::PRINTTYPE;
        Log::info('start Date =' . $StartDate . " EndDate =" .$EndDate );

        if($AccountID > 0 && $CompanyID > 0 && !empty($StartDate) && !empty($EndDate)) {

            $CompanyName  = Company::getName($CompanyID);
            $UPLOADPATH = CompanyConfiguration::get($CompanyID,'UPLOAD_PATH');

            $Account = Account::find((int)$AccountID);
            $AccountBilling = AccountBilling::getBillingClass((int)$AccountID);

            if(!empty($Account)) {

                $InvoiceTemplate = InvoiceTemplate::where("InvoiceTemplateID",$AccountBilling->InvoiceTemplateID)->select(["Terms","FooterTerm","InvoiceNumberPrefix","DateFormat"])->first();

                if ( empty($AccountBilling->InvoiceTemplateID) || empty($InvoiceTemplate) ) {
                    $error = $Account->AccountName . ' ' . Invoice::$InvoiceGenrationErrorReasons['InvoiceTemplate'];
                    return array("status" => "failure", "message" => $error);
                }

                Log::info('InvoiceTemplate->InvoiceNumberPrefix =' .($InvoiceTemplate->InvoiceNumberPrefix)) ;
                Log::info('InvoiceTemplate->Terms =' .($InvoiceTemplate->Terms));


                if(!empty($InvoiceTemplate)) {

                    $InvoiceTemplate->DateFormat = invoice_date_fomat($InvoiceTemplate->DateFormat);
                    $decimal_places = Helper::get_round_decimal_places($CompanyID,$Account->AccountID);

                    /**
                     ***************************
                     **************************
                    Step 1     USAGE
                     **************************
                     **************************
                     */
                    //Check if Invoice Usage is alrady Created.
                    //TRUE=Already Billed
                    //FALSE = Not billed
                    Log::info('Invoice::checkIfAccountUsageAlreadyBilled') ;

                    $AlreadyBilled = Invoice::checkIfAccountUsageAlreadyBilled($CompanyID,$AccountID, $StartDate, $EndDate);

                    //If Already Billed

                    if ($AlreadyBilled) {
                        $error = $Account->AccountName . ' ' . Invoice::$InvoiceGenrationErrorReasons["AlreadyInvoiced"];
                        return array("status" => "failure", "message" => $error);
                    }

                    $Invoice = "";
                    $SubTotal = 0;
                    $SubTotalWithoutTax = 0;
                    $AdditionalChargeTax = 0;

                    //If Account usage not already billed

                    if (!$AlreadyBilled) {

                        $uResponse = self::addManualUsage($Account,$CompanyID, $AccountID,$StartDate,$EndDate,$InvoiceTemplate,$SubTotal,$decimal_places);
                        $Invoice = $uResponse["Invoice"];
                        $SubTotal = $uResponse["SubTotal"];

                    } // Usage Over
                    $InvoiceID = $Invoice->InvoiceID;
                    Log::info('Usage Over') ;

                    /**
                     ***************************
                     **************************
                    Step 2  SUBSCRIPTION
                     **************************
                     **************************
                     */

                    /**
                     * Add Subscription in InvoiceDetail if any
                     */
                    //$subResponse = self::addSubscription($Invoice,$InvoiceTemplate,$StartDate,$EndDate,$SubTotal,$decimal_places);
                    //$SubTotal = $subResponse["SubTotal"];
                    //$SubTotalWithoutTax += $subResponse["SubscriptionChargewithouttaxTotal"];

                    /**
                     * Add OneOffCharge in InvoiceDetail if any
                     */
                    //$subResponse = self::addOneOffCharge($Invoice,$InvoiceTemplate,$StartDate,$EndDate,$SubTotal,$decimal_places);
                    //$SubTotal = $subResponse["SubTotal"];
                    //$SubTotalWithoutTax += $subResponse["SubscriptionChargewithouttaxTotal"];
                    //$AdditionalChargeTax = $subResponse["AdditionalChargeTotalTax"];

                    /**
                     ***************************
                     **************************
                    Step 3  USAGE FILE & Invoice PDF & EMAIL
                     **************************
                     **************************
                     */

                    Log::info('USAGE FILE & Invoice PDF & EMAIL Start') ;

                    if (isset($Invoice)) {

                        $totals = self::updateInvoiceAllTotalAmounts($Invoice,$SubTotal,$SubTotalWithoutTax,$AdditionalChargeTax,$decimal_places);

                        /*
                         * PDF Generation CODE HERE
                         *
                         */
                        Log::info('PDF Generation start');

                        //$pdf_path = Invoice::generate_pdf($Invoice->InvoiceID);
                        $pdf_path = '';
                        $InvoiceDetail = InvoiceDetail::where(["InvoiceID" => $InvoiceID])->get();
                        $Account = Account::find($Invoice->AccountID);
                        $Currency = Currency::find($Account->CurrencyId);
                        $CurrencyCode = !empty($Currency)?$Currency->Code:'';
                        $CurrencySymbol =  Currency::getCurrencySymbol($Account->CurrencyId);
                        $InvoiceTemplate = InvoiceTemplate::find($AccountBilling->InvoiceTemplateID);
                        if (empty($InvoiceTemplate->CompanyLogoUrl) || AmazonS3::unSignedUrl($InvoiceTemplate->CompanyLogoAS3Key,$CompanyID) == '') {
                            $as3url =  base_path().'/resources/assets/images/250x100.png'; //'http://placehold.it/250x100';
                        } else {
                            $as3url = (AmazonS3::unSignedUrl($InvoiceTemplate->CompanyLogoAS3Key,$CompanyID));
                        }
                        $logo = $UPLOADPATH . '/' . basename($as3url);
                        file_put_contents($logo, file_get_contents($as3url));
                        $InvoiceTaxRates = InvoiceTaxRate::where("InvoiceID",$InvoiceID)->get();
                        $usage_data = array();
                        $InvoiceTemplate->DateFormat = invoice_date_fomat($InvoiceTemplate->DateFormat);
                        $file_name = 'Invoice--' . date($InvoiceTemplate->DateFormat) . '.pdf';
                        $htmlfile_name = 'Invoice--' . date($InvoiceTemplate->DateFormat) . '.html';
                        if($InvoiceTemplate->InvoicePages == 'single_with_detail') {
                            foreach ($InvoiceDetail as $Detail) {
                                if (isset($Detail->StartDate) && isset($Detail->EndDate) && $Detail->StartDate != '1900-01-01' && $Detail->EndDate != '1900-01-01') {

                                    $companyID = $Account->CompanyId;
                                    $start_date = $Detail->StartDate;
                                    $end_date = $Detail->EndDate;
                                    $result_data = DB::connection('sqlsrv2')->table('tblSummeryData')->where(array('AccountID'=>$AccountID))->get();

                                    $result_data = json_decode(json_encode($result_data), true);
                                    //$usage_data = $usage_data+json_decode(json_encode($result_data), true);
                                    $countkey = 0;
                                    foreach($result_data as $result_row){
                                        if(empty($result_row['AreaPrefix'])){
                                            $result_row['AreaPrefix'] = 'Other';
                                        }
                                        $key = searcharray($result_row['AreaPrefix'], 'AreaPrefix',$result_row['Trunk'],'Trunk',$usage_data);
                                        if(isset($usage_data[$key]['AreaPrefix'])){
                                            $usage_data[$key]['NoOfCalls'] += $result_row['TotalCalls'];
                                            $usage_data[$key]['Duration'] = add_duration(((int)($result_row['Duration']/60).':'.$result_row['Duration']%60),$usage_data[$key]['Duration']);
                                            $usage_data[$key]['BillDuration'] = add_duration(((int)($result_row['Duration']/60).':'.$result_row['Duration']%60),$usage_data[$key]['BillDuration']);
                                            $usage_data[$key]['TotalCharges'] += $result_row['TotalCharge'];
                                            $usage_data[$key]['DurationInSec'] += $result_row['Duration'];
                                            $usage_data[$key]['BillDurationInSec'] += $result_row['Duration'];
                                        }else{
                                            $usage_data[$countkey]['Trunk'] = 'Other';
                                            $usage_data[$countkey]['AreaPrefix'] = $result_row['AreaPrefix'];
                                            $usage_data[$countkey]['Country'] = $result_row['Country'];
                                            $usage_data[$countkey]['Description'] = $result_row['AreaName'];
                                            $usage_data[$countkey]['NoOfCalls'] = $result_row['TotalCalls'];
                                            $usage_data[$countkey]['Duration'] = (int)($result_row['Duration']/60).':'.$result_row['Duration']%60;
                                            $usage_data[$countkey]['BillDuration'] = (int)($result_row['Duration']/60).':'.$result_row['Duration']%60;
                                            $usage_data[$countkey]['TotalCharges'] = $result_row['TotalCharge'];
                                            $usage_data[$countkey]['DurationInSec'] = $result_row['Duration'];
                                            $usage_data[$countkey]['BillDurationInSec'] = $result_row['Duration'];
                                        }
                                        $countkey++;
                                    }

                                    $file_name =  'Invoice-From-' . Str::slug($start_date) . '-To-' . Str::slug($end_date) . '.pdf';
                                    $htmlfile_name =  'Invoice-From-' . Str::slug($start_date) . '-To-' . Str::slug($end_date) . '.html';
                                    break;
                                }
                            }
                        }
						
                        $body = View::make('emails.invoices.pdf', compact('Invoice', 'InvoiceDetail','InvoiceTaxRates', 'Account', 'InvoiceTemplate', 'usage_data', 'CurrencyCode','CurrencySymbol', 'logo','print_type'))->render();
                        $body = htmlspecialchars_decode($body);
                        $footer = View::make('emails.invoices.pdffooter', compact('Invoice'))->render();
                        $footer = htmlspecialchars_decode($footer);
                        $header = View::make('emails.invoices.pdfheader', compact('Invoice'))->render();
                        $header = htmlspecialchars_decode($header);

                        $amazonPath = AmazonS3::generate_path(AmazonS3::$dir['INVOICE_UPLOAD'],$Account->CompanyId,$Invoice->AccountID) ;
                        $destination_dir = $UPLOADPATH . '/'. $amazonPath;
                        if (!file_exists($destination_dir)) {
                            mkdir($destination_dir, 0777, true);
                        }
                        $file_name = Uuid::generate() .'-'. $file_name;
                        $htmlfile_name = Uuid::generate() .'-'. $htmlfile_name;
                        $local_file = $destination_dir .  $file_name;
                        $local_htmlfile = $destination_dir .  $htmlfile_name;
                        file_put_contents($local_htmlfile,$body);
                        $footer_name = 'footer-'. Uuid::generate() .'.html';
                        $footer_html = $destination_dir.$footer_name;
                        file_put_contents($footer_html,$footer);
                        $header_name = 'header-'. Uuid::generate() .'.html';
                        $header_html = $destination_dir.$header_name;
                        file_put_contents($header_html,$header);
                        $output= "";
                        if(getenv('APP_OS') == 'Linux'){
                            exec (base_path(). '/wkhtmltox/bin/wkhtmltopdf --header-spacing 3 --footer-spacing 1 --header-html "'.$header_html.'" --footer-html "'.$footer_html.'" "'.$local_htmlfile.'" "'.$local_file.'"',$output);
                            Log::info(base_path(). '/wkhtmltox/bin/wkhtmltopdf --header-spacing 3 --footer-spacing 1 --header-html "'.$header_html.'" --footer-html "'.$footer_html.'" "'.$local_htmlfile.'" "'.$local_file.'"',$output);
                        }else{
                            exec (base_path().'/wkhtmltopdf/bin/wkhtmltopdf.exe --header-spacing 3 --footer-spacing 1 --header-html "'.$header_html.'" --footer-html "'.$footer_html.'" "'.$local_htmlfile.'" "'.$local_file.'"',$output);
                            Log::info (base_path().'/wkhtmltopdf/bin/wkhtmltopdf.exe --header-spacing 3 --footer-spacing 1 --header-html "'.$header_html.'" --footer-html "'.$footer_html.'" "'.$local_htmlfile.'" "'.$local_file.'"',$output);
                        }
                        Log::info($output);
                        Log::info($local_htmlfile);
                        @unlink($local_htmlfile);
                        @unlink($footer_html);
                        if (file_exists($local_file)) {
                            $fullPath = $amazonPath . basename($local_file); //$destinationPath . $file_name;
                            if (AmazonS3::upload($local_file, $amazonPath,$CompanyID)) {
                                $pdf_path = $fullPath;
                            }
                        }

                        if(empty($pdf_path)){
                            $error = Invoice::$InvoiceGenrationErrorReasons["PDF"];
                            return array("status" => "failure", "message" => $error);
                        }else{
                            $Invoice->update(["PDF" => $pdf_path]);
                        }

                        Log::info('PDF fullPath ' . $pdf_path);

                        /** Generate Usage File **/
                        Log::info('Generate Usage File Start ') ;

                        $fullPath = "";
                        if($AccountBilling->CDRType != Account::NO_CDR) { // Check in to generate Invoice usage file or not
                            $InvoiceID = $Invoice->InvoiceID;
                            if ($InvoiceID > 0 && $AccountID > 0) {
                                $amazonPath = AmazonS3::generate_path(AmazonS3::$dir['INVOICE_USAGE_FILE'],$CompanyID,$AccountID) ;
                                $dir = $UPLOADPATH . '/'. $amazonPath;
                                if (!file_exists($dir)) {
                                    mkdir($dir, 0777, TRUE);
                                }
                                if (is_writable($dir)) {
                                    $AccountName = Account::where(["AccountID" => $AccountID])->pluck('AccountName');
                                    $local_file = $dir . '/' . str_slug($AccountName) . '-summary-' . date("d-m-Y-H-i-s", strtotime($StartDate)) . '-TO-' . date("d-m-Y-H-i-s", strtotime($EndDate)) . '__' . $ProcessID . '.csv';

                                    $output = Helper::array_to_csv($usage_data);
                                    file_put_contents($local_file, $output);
                                    if (file_exists($local_file)) {
                                        $fullPath = $amazonPath . basename($local_file); //$destinationPath . $file_name;
                                        if (!AmazonS3::upload($local_file, $amazonPath,$CompanyID)) {
                                            throw new Exception('Error in Amazon upload');
                                        }
                                        if (!empty($fullPath)) {
                                            AmazonS3::delete($Invoice->UsagePath,$CompanyID); // Delete old usage file from amazon
                                            $Invoice->update(["UsagePath" => $fullPath]); // Update new one
                                        }
                                    }
                                }
                                if (empty($fullPath)) {
                                    $error = $Account->AccountName . ' ' . Invoice::$InvoiceGenrationErrorReasons['UsageFile'];
                                }
                            }
                        }

                        Log::info('Usage File fullPath ' . $fullPath ) ;

                        if(empty($error)) {

                            //$status = self::EmailToCustomer($Account,$totals['TotalDue'],$Invoice,$InvoiceTemplate->InvoiceNumberPrefix,$CompanyName,$CompanyID,$InvoiceGenerationEmail,$ProcessID,$JobID);

                            if(isset($status['status']) && isset($status['message']) && $status['status']=='failure'){
                                $error_1 = $status['message'];
                            }
                        }

                    }//Email Sending over

                    Log::info('=========== Email Sending over =========== ') ;

                    /*if (isset($Invoice)) {

                        Log::info('=========== Updating  InvoiceDate =========== ') ;

                        $oldNextInvoiceDate = $NextInvoiceDate;
                        $Account->update(["LastInvoiceDate"=>$oldNextInvoiceDate]);
                        $NewNextInvoiceDate = Invoice::calculateNextInvoiceDateFromLastInvoiceDate($CompanyID,$AccountID,$oldNextInvoiceDate);
                        $Account->update(["NextInvoiceDate"=>$NewNextInvoiceDate]);

                        Log::info('=========== Updated  InvoiceDate =========== ') ;

                    }*/

                }
                if(!empty($error)){

                    Log::info('=========== Returning as Error =========== ' . $error) ;

                    return array("status"=>"failure","message"=> $error);
                }else{
                    Log::info('=========== Returning as Success =========== AccountID ' . $AccountID) ;
                    return array("status"=>"success","message"=> "Invoice Created Successfully.",'accounts'=>(isset($error_1)?$error_1:''));
                }
            }

        }
    }
    public static function addManualUsage($Account,$CompanyID, $AccountID,$StartDate,$EndDate,$InvoiceTemplate,$SubTotal,$decimal_places){

        Log::info('Invoice::getAccountUsageTotal('.$CompanyID.','. $AccountID.','. $StartDate.','. $EndDate.')') ;

        //get Total Usage
        $TotalCharges = DB::connection('sqlsrv2')->table('tblSummeryData')->where(array('AccountID'=>$AccountID))->sum('TotalCharge');
        //$TotalCharges = Invoice::getAccountUsageTotal($CompanyID, $AccountID, $StartDate, $EndDate);

        /*if( $TotalCharges == 0 ) {
            $error = $Account->AccountName . ' ' . Invoice::$InvoiceGenrationErrorReasons['NoCDR'];
            return array("status" => "failure", "message" => $error);
        }*/

        Log::info('TotalCharges - '.$TotalCharges) ;

        //if ($TotalCharges > 0) {
        //Create Invoice even if TotalCharges is zero its used for PBX customer

        $Address = Account::getFullAddress($Account);

        $TotalUsageCharges = number_format($TotalCharges, $decimal_places, '.', '');

        $SubTotal = floatval($SubTotal) + floatval($TotalUsageCharges);

        /**
         * Add Tax Rate
         * */
        Log::info('TotalUsageCharges - '.$TotalUsageCharges) ;

        /**
         * Add Data in Invoice
         */
        $InvoiceNumber = InvoiceTemplate::getNextInvoiceNumber(AccountBilling::getInvoiceTemplateID($AccountID), $CompanyID);
        $Invoice = Invoice::insertInvoice(array(
            "CompanyID" => $CompanyID,
            "AccountID" => $AccountID,
            "Address" => $Address,
            "InvoiceNumber" => $InvoiceNumber,
            "FullInvoiceNumber" => $InvoiceTemplate->InvoiceNumberPrefix.$InvoiceNumber,
            "IssueDate" => date('Y-m-d'),
            "TotalDiscount" => 0,
            "CurrencyID" => $Account->CurrencyId,
            "Note" => "Auto Generated on " . date($InvoiceTemplate->DateFormat),
            "Terms" => $InvoiceTemplate->Terms,
            'FooterTerm' => $InvoiceTemplate->FooterTerm,
            "InvoiceStatus" => Invoice::AWAITING
        ));

        /**
         * Insert Data in InvoiceLog
         */
        $invoiceloddata = array();
        $invoiceloddata['InvoiceID'] = $Invoice->InvoiceID;
        $invoiceloddata['Note'] = InvoiceLog::$log_status[InvoiceLog::CREATED].' By RMScheduler';
        $invoiceloddata['created_at'] = date("Y-m-d H:i:s");
        $invoiceloddata['InvoiceLogStatus'] = InvoiceLog::CREATED;
        InvoiceLog::insert($invoiceloddata);


        //Store Last Invoice Number.
        InvoiceTemplate::find(AccountBilling::getInvoiceTemplateID($AccountID))->update(array("LastInvoiceNumber" => $InvoiceNumber));

        /**
         * Add Usage in InvoiceDetail
         */
        $ProductDescription = " From " . date($InvoiceTemplate->DateFormat, strtotime($StartDate)) . " To " . date($InvoiceTemplate->DateFormat, strtotime($EndDate));
        $InvoiceDetailData = array();
        $InvoiceDetailData["InvoiceID"] = $Invoice->InvoiceID;
        $InvoiceDetailData['ProductID'] = 0;
        $InvoiceDetailData['ProductType'] = Product::USAGE;
        $InvoiceDetailData['Description'] = $ProductDescription;
        $InvoiceDetailData['StartDate'] = $StartDate;
        $InvoiceDetailData['EndDate'] = $EndDate;
        $InvoiceDetailData['Price'] = $TotalUsageCharges;
        $InvoiceDetailData['Qty'] = 1;
        $InvoiceDetailData['Discount'] = 0;
        $InvoiceDetailData['LineTotal'] = $TotalUsageCharges;
        $InvoiceDetailData["created_at"] = date("Y-m-d H:i:s");
        $InvoiceDetailData["CreatedBy"] = 'RMScheduler';
        InvoiceDetail::insert($InvoiceDetailData);


        return array("SubTotal"=>$SubTotal,'Invoice' => $Invoice);

    }
    public static function resendManualInvoice($CompanyID,$Invoice,$InvoiceDetail,$InvoiceGenerationEmail,$ProcessID,$JobID){

        $error = "";
        $SubTotal = 0;
		$print_type = Invoice::PRINTTYPE;
        $SubTotalWithoutTax = $AdditionalChargeTax =  0;
        $regenerate =1;
        $UPLOADPATH = CompanyConfiguration::get($CompanyID,'UPLOAD_PATH');
        $Account = Account::find((int)$Invoice->AccountID);
        $AccountID = $Account->AccountID;
        $StartDate = date("Y-m-d", strtotime($InvoiceDetail[0]->StartDate));
        $EndDate = date("Y-m-d 23:59:59", strtotime($InvoiceDetail[0]->EndDate));

        Log::info('start Date =' . $StartDate . " EndDate =" .$EndDate );

        if($AccountID > 0 && $CompanyID > 0 && !empty($StartDate) && !empty($EndDate)) {
            $CompanyName = Company::getName($CompanyID);

            $AccountBilling = AccountBilling::getBillingClass($AccountID);
            $InvoiceID = $Invoice->InvoiceID;
            if (!empty($Account)) {
                $InvoiceTemplate = InvoiceTemplate::where("InvoiceTemplateID", $AccountBilling->InvoiceTemplateID)->select(["Terms","FooterTerm", "InvoiceNumberPrefix","DateFormat"])->first();
                if ( empty($AccountBilling->InvoiceTemplateID) || empty($InvoiceTemplate) ) {
                    $error['message'] = $Account->AccountName . ' ' . Invoice::$InvoiceGenrationErrorReasons['InvoiceTemplate'];
                    $error['status'] = 'failure';
                    return $error;
                }
                if (!empty($InvoiceTemplate)) {
                    $decimal_places = Helper::get_round_decimal_places($CompanyID,$Account->AccountID);

                    Log::info('Invoice::getAccountUsageTotal(' . $CompanyID . ',' . $AccountID . ',' . $StartDate . ',' . $EndDate . ')');
                    $InvoiceTemplate->DateFormat = invoice_date_fomat($InvoiceTemplate->DateFormat);

                    //get Total Usage
                    $TotalCharges = DB::connection('sqlsrv2')->table('tblSummeryData')->where(array('AccountID'=>$AccountID))->sum('TotalCharge');


                    Log::info('TotalCharges - ' . $TotalCharges);


                    $Address = Account::getFullAddress($Account);

                    $TotalUsageCharges = number_format($TotalCharges, $decimal_places, '.', '');

                    $SubTotal += $TotalUsageCharges;

                    /**
                     * Add Tax Rate
                     * */
                    Log::info('TotalUsageCharges - ' . $TotalUsageCharges);

                    /**
                     * Update Data in Invoice
                     */
                    $Invoicedataarray = array();
                    $Invoicedataarray['Address'] = $Address;
                    $Invoicedataarray['CurrencyID'] = $Account->CurrencyId;
                    $Invoicedataarray['Note'] = "ReGenerated on " . date($InvoiceTemplate->DateFormat);
                    $Invoicedataarray['Terms'] = $InvoiceTemplate->Terms;
                    $Invoicedataarray['FooterTerm'] = $InvoiceTemplate->FooterTerm;
                    $Invoicedataarray['InvoiceStatus'] = self::AWAITING;
                    $Invoice->update($Invoicedataarray);
                    /**
                     * Update Usage in InvoiceDetail
                     */
                    $ProductDescription = " From " . date($InvoiceTemplate->DateFormat, strtotime($StartDate)) . " To " . date($InvoiceTemplate->DateFormat, strtotime($EndDate));
                    $InvoiceDetailData = array();
                    $InvoiceDetailData["InvoiceID"] = $Invoice->InvoiceID;
                    $InvoiceDetailData['ProductID'] = 0;
                    $InvoiceDetailData['ProductType'] = Product::USAGE;
                    $InvoiceDetailData['Description'] = $ProductDescription;
                    $InvoiceDetailData['StartDate'] = $StartDate;
                    $InvoiceDetailData['EndDate'] = $EndDate;
                    $InvoiceDetailData['Price'] = $TotalUsageCharges;
                    $InvoiceDetailData['Qty'] = 1;
                    $InvoiceDetailData['Discount'] = 0;
                    $InvoiceDetailData['LineTotal'] = $TotalUsageCharges;
                    $InvoiceDetailData["updated_at"] = date("Y-m-d H:i:s");
                    $InvoiceDetailData["ModifiedBy"] = 'RMScheduler';
                    InvoiceDetail::where(array('InvoiceID' => $Invoice->InvoiceID, 'ProductID' => 0, 'ProductType' => Product::USAGE))->update($InvoiceDetailData);

                    /**
                     * Insert Data in InvoiceLog
                     */
                    $invoiceloddata = array();
                    $invoiceloddata['InvoiceID'] = $Invoice->InvoiceID;
                    $invoiceloddata['Note'] = InvoiceLog::$log_status[InvoiceLog::REGENERATED].' By RMScheduler';
                    $invoiceloddata['created_at'] = date("Y-m-d H:i:s");
                    $invoiceloddata['InvoiceLogStatus'] = InvoiceLog::REGENERATED;
                    InvoiceLog::insert($invoiceloddata);

                    // }
                    Log::info('Usage Over');



                    Log::info('USAGE FILE & Invoice PDF & EMAIL Start');

                    if (isset($Invoice)) {

                        // Add Tax in Subtotal and Update all Total Fields in Invoice Table.
                        $totals = self::updateInvoiceAllTotalAmounts($Invoice,$SubTotal,$SubTotalWithoutTax,$AdditionalChargeTax,$decimal_places);

                        /*
                         * PDF Generation CODE HERE
                         *
                         */
                        Log::info('PDF Generation start');

                        //$pdf_path = Invoice::generate_pdf($Invoice->InvoiceID);
                        $pdf_path = '';
                        $InvoiceDetail = InvoiceDetail::where(["InvoiceID" => $InvoiceID])->get();
                        $Account = Account::find($Invoice->AccountID);
                        $Currency = Currency::find($Account->CurrencyId);
                        $CurrencyCode = !empty($Currency)?$Currency->Code:'';
                        $CurrencySymbol =  Currency::getCurrencySymbol($Account->CurrencyId);
                        $InvoiceTemplate = InvoiceTemplate::find($AccountBilling->InvoiceTemplateID);
                        if (empty($InvoiceTemplate->CompanyLogoUrl) || AmazonS3::unSignedUrl($InvoiceTemplate->CompanyLogoAS3Key,$CompanyID) == '') {
                            $as3url =  base_path().'/resources/assets/images/250x100.png'; //'http://placehold.it/250x100';
                        } else {
                            $as3url = (AmazonS3::unSignedUrl($InvoiceTemplate->CompanyLogoAS3Key,$CompanyID));
                        }
                        $logo = $UPLOADPATH . '/' . basename($as3url);
                        file_put_contents($logo, file_get_contents($as3url));
                        $InvoiceTaxRates = InvoiceTaxRate::where("InvoiceID",$InvoiceID)->get();
                        $usage_data = array();
                        $InvoiceTemplate->DateFormat = invoice_date_fomat($InvoiceTemplate->DateFormat);
                        $file_name = 'Invoice--' . date($InvoiceTemplate->DateFormat) . '.pdf';
                        $htmlfile_name = 'Invoice--' . date($InvoiceTemplate->DateFormat) . '.html';
                        if($InvoiceTemplate->InvoicePages == 'single_with_detail') {
                            foreach ($InvoiceDetail as $Detail) {
                                if (isset($Detail->StartDate) && isset($Detail->EndDate) && $Detail->StartDate != '1900-01-01' && $Detail->EndDate != '1900-01-01') {

                                    $companyID = $Account->CompanyId;
                                    $start_date = $Detail->StartDate;
                                    $end_date = $Detail->EndDate;
                                    $result_data = DB::connection('sqlsrv2')->table('tblSummeryData')->where(array('AccountID'=>$AccountID))->get();

                                    $result_data = json_decode(json_encode($result_data), true);
                                    //$usage_data = $usage_data+json_decode(json_encode($result_data), true);
                                    $countkey = 0;
                                    foreach($result_data as $result_row){
                                        if(empty($result_row['AreaPrefix'])){
                                            $result_row['AreaPrefix'] = 'Other';
                                        }
                                        $key = searcharray($result_row['AreaPrefix'], 'AreaPrefix',$result_row['Trunk'],'Trunk',$usage_data);
                                        if(isset($usage_data[$key]['AreaPrefix'])){
                                            $usage_data[$key]['NoOfCalls'] += $result_row['TotalCalls'];
                                            $usage_data[$key]['Duration'] = add_duration(((int)($result_row['Duration']/60).':'.$result_row['Duration']%60),$usage_data[$key]['Duration']);
                                            $usage_data[$key]['BillDuration'] = add_duration(((int)($result_row['Duration']/60).':'.$result_row['Duration']%60),$usage_data[$key]['BillDuration']);
                                            $usage_data[$key]['TotalCharges'] += $result_row['TotalCharge'];
                                            $usage_data[$key]['DurationInSec'] += $result_row['Duration'];
                                            $usage_data[$key]['BillDurationInSec'] += $result_row['Duration'];
                                        }else{
                                            $usage_data[$countkey]['Trunk'] = 'Other';
                                            $usage_data[$countkey]['AreaPrefix'] = $result_row['AreaPrefix'];
                                            $usage_data[$countkey]['Country'] = $result_row['Country'];
                                            $usage_data[$countkey]['Description'] = $result_row['AreaName'];
                                            $usage_data[$countkey]['NoOfCalls'] = $result_row['TotalCalls'];
                                            $usage_data[$countkey]['Duration'] = (int)($result_row['Duration']/60).':'.$result_row['Duration']%60;
                                            $usage_data[$countkey]['BillDuration'] = (int)($result_row['Duration']/60).':'.$result_row['Duration']%60;
                                            $usage_data[$countkey]['TotalCharges'] = $result_row['TotalCharge'];
                                            $usage_data[$countkey]['DurationInSec'] = $result_row['Duration'];
                                            $usage_data[$countkey]['BillDurationInSec'] = $result_row['Duration'];

                                        }
                                        $countkey++;
                                    }

                                    $file_name =  'Invoice-From-' . Str::slug($start_date) . '-To-' . Str::slug($end_date) . '.pdf';
                                    $htmlfile_name =  'Invoice-From-' . Str::slug($start_date) . '-To-' . Str::slug($end_date) . '.html';
                                    break;
                                }
                            }
                        }
                        $body = View::make('emails.invoices.pdf', compact('Invoice', 'InvoiceDetail','InvoiceTaxRates', 'Account', 'InvoiceTemplate', 'usage_data', 'CurrencyCode','CurrencySymbol', 'logo','print_type'))->render();
                        $body = htmlspecialchars_decode($body);
                        $footer = View::make('emails.invoices.pdffooter', compact('Invoice'))->render();
                        $footer = htmlspecialchars_decode($footer);
                        $header = View::make('emails.invoices.pdfheader', compact('Invoice'))->render();
                        $header = htmlspecialchars_decode($header);

                        $amazonPath = AmazonS3::generate_path(AmazonS3::$dir['INVOICE_UPLOAD'],$Account->CompanyId,$Invoice->AccountID) ;
                        $destination_dir = $UPLOADPATH . '/'. $amazonPath;
                        if (!file_exists($destination_dir)) {
                            mkdir($destination_dir, 0777, true);
                        }
                        $file_name = Uuid::generate() .'-'. $file_name;
                        $htmlfile_name = Uuid::generate() .'-'. $htmlfile_name;
                        $local_file = $destination_dir .  $file_name;
                        $local_htmlfile = $destination_dir .  $htmlfile_name;
                        file_put_contents($local_htmlfile,$body);
                        $footer_name = 'footer-'. Uuid::generate() .'.html';
                        $footer_html = $destination_dir.$footer_name;
                        file_put_contents($footer_html,$footer);
                        $header_name = 'header-'. Uuid::generate() .'.html';
                        $header_html = $destination_dir.$header_name;
                        file_put_contents($header_html,$header);
                        $output= "";
                        if(getenv('APP_OS') == 'Linux'){
                            exec (base_path(). '/wkhtmltox/bin/wkhtmltopdf --header-spacing 3 --footer-spacing 1 --header-html "'.$header_html.'" --footer-html "'.$footer_html.'" "'.$local_htmlfile.'" "'.$local_file.'"',$output);
                            Log::info(base_path(). '/wkhtmltox/bin/wkhtmltopdf --header-spacing 3 --footer-spacing 1 --header-html "'.$header_html.'" --footer-html "'.$footer_html.'" "'.$local_htmlfile.'" "'.$local_file.'"',$output);

                        }else{
                            exec (base_path().'/wkhtmltopdf/bin/wkhtmltopdf.exe --header-spacing 3 --footer-spacing 1 --header-html "'.$header_html.'" --footer-html "'.$footer_html.'" "'.$local_htmlfile.'" "'.$local_file.'"',$output);
                            Log::info (base_path().'/wkhtmltopdf/bin/wkhtmltopdf.exe --header-spacing 3 --footer-spacing 1 --header-html "'.$header_html.'" --footer-html "'.$footer_html.'" "'.$local_htmlfile.'" "'.$local_file.'"',$output);
                        }
                        Log::info($output);
                        Log::info($local_htmlfile);
                        @unlink($local_htmlfile);
                        @unlink($footer_html);
                        if (file_exists($local_file)) {
                            $fullPath = $amazonPath . basename($local_file); //$destinationPath . $file_name;
                            if (AmazonS3::upload($local_file, $amazonPath,$CompanyID)) {
                                $pdf_path = $fullPath;
                            }
                        }

                        if(empty($pdf_path)){
                            $error = Invoice::$InvoiceGenrationErrorReasons["PDF"];
                            return array("status" => "failure", "message" => $error);
                        }else{
                            $Invoice->update(["PDF" => $pdf_path]);
                        }

                        Log::info('PDF fullPath ' . $pdf_path);

                        /** Generate Usage File **/
                        Log::info('Generate Usage File Start ');

                        $fullPath = "";
                        $message['message'] = $Account->AccountName;
                        if($AccountBilling->CDRType != Account::NO_CDR) { // Check in to generate Invoice usage file or not
                            $InvoiceID = $Invoice->InvoiceID;
                            if ($InvoiceID > 0 && $AccountID > 0) {
                                $amazonPath = AmazonS3::generate_path(AmazonS3::$dir['INVOICE_USAGE_FILE'],$CompanyID,$AccountID) ;
                                $dir = $UPLOADPATH . '/'. $amazonPath;
                                if (!file_exists($dir)) {
                                    mkdir($dir, 0777, TRUE);
                                }
                                if (is_writable($dir)) {
                                    $AccountName = Account::where(["AccountID" => $AccountID])->pluck('AccountName');
                                    $local_file = $dir . '/' . str_slug($AccountName) . '-summary-' . date("d-m-Y-H-i-s", strtotime($StartDate)) . '-TO-' . date("d-m-Y-H-i-s", strtotime($EndDate)) . '__' . $ProcessID . '.csv';

                                    $output = Helper::array_to_csv($usage_data);
                                    file_put_contents($local_file, $output);
                                    if (file_exists($local_file)) {
                                        $fullPath = $amazonPath . basename($local_file); //$destinationPath . $file_name;
                                        if (!AmazonS3::upload($local_file, $amazonPath,$CompanyID)) {
                                            throw new Exception('Error in Amazon upload');
                                        }
                                        if (!empty($fullPath)) {
                                            AmazonS3::delete($Invoice->UsagePath,$CompanyID); // Delete old usage file from amazon
                                            $Invoice->update(["UsagePath" => $fullPath]); // Update new one
                                        }
                                    }
                                }
                                if (empty($fullPath)) {
                                    $error = $Account->AccountName . ' ' . Invoice::$InvoiceGenrationErrorReasons['UsageFile'];
                                }
                            }
                        }

                        Log::info('Usage File fullPath ' . $fullPath);





                    }//Email Sending over
                    Log::info('=========== Email Sending over =========== ');
                }
                if (!empty($error)) {
                    Log::info('=========== Returning as Error =========== ' . print_r($error,true));
                    return $error;
                } else {
                    $message['message']= ' Invoice Regenerated '.(isset($message['message'])?$message['message']:'');
                    $message['status'] = "success";
                    Log::info('=========== Returning as Success =========== AccountID ' . $AccountID);
                    return $message;
                }
            }
        }
    }

    public static function CheckInvoiceFullPaid($InvoiceID,$CompanyID){
        $Response = false;
        $InvoiceTotal = '';
        $PaymentTotal = '';
        if(!empty($InvoiceID)){
            $Invoice = Invoice::find($InvoiceID);
            $InvoiceTotal = $Invoice->GrandTotal;

            $PaymentTotal = Payment::where(['CompanyID' =>$CompanyID, 'InvoiceID' => $InvoiceID, 'Recall' => '0', 'Status' =>'Approved'])->sum('Amount');

            log::info('Invoice Total '.$InvoiceTotal);
            log::info('Payment Total '.$PaymentTotal);

            if(!empty($InvoiceTotal) && !empty($PaymentTotal) && $InvoiceTotal == $PaymentTotal){
                log::info('Total Matching');
                $Response = true;

            }
        }
        return $Response;
    }

}