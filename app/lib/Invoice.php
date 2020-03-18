<?php
namespace App\Lib;

use Chumper\Zipper\Facades\Zipper;
use Illuminate\Support\Facades\App;
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
    public static function generate_usage_file($InvoiceID,$usage_data_table,$start_date,$end_date,$GroupByService,$usage_data_noservice){

        $zipfiles = array();


        if(!empty($InvoiceID)) {
            $fullPath = "";
            $Invoice = Invoice::find($InvoiceID);
            $AccountID = $Invoice->AccountID;
            $CompanyID = $Invoice->CompanyID;
            if(!empty($CompanyID) && !empty($AccountID) && !empty($InvoiceID) ) {
                $ProcessID = Uuid::generate();
                $UPLOADPATH = CompanyConfiguration::get($CompanyID, 'UPLOAD_PATH');
                $amazonPath = AmazonS3::generate_path(AmazonS3::$dir['INVOICE_USAGE_FILE'], $CompanyID, $AccountID);
                $dir = $UPLOADPATH . '/' . $amazonPath;
                if (!file_exists($dir)) {
                    RemoteSSH::make_dir($CompanyID,$dir);
                    //RemoteSSH::run($CompanyID, "mkdir -p " . $dir);
                    //RemoteSSH::run($CompanyID, "chmod -R 777 " . $dir);
                }
                if (is_writable($dir)) {
                    $AccountName = Account::where(["AccountID" => $AccountID])->pluck('AccountName');

                    if(count($usage_data_table['data'])>0 && $GroupByService == 1) {


                        foreach ($usage_data_table['data'] as $ServiceID => $usage_data) {

                            /** remove extra columns*/
                            $usage_data = remove_extra_columns($usage_data,$usage_data_table);

                            if ($ServiceID == 0) {
                                $ServiceTitle = Service::$defaultService;
                            } else {
                                $ServiceTitle = AccountService::getServiceName($AccountID, $ServiceID);
                            }

                            $local_file = $dir . '/' . str_slug($ServiceTitle) . '-' . date("d-m-Y-H-i-s", strtotime($start_date)) . '-TO-' . date("d-m-Y-H-i-s", strtotime($end_date)) . '__' . $ProcessID . '.csv';

                            $output = Helper::array_to_csv($usage_data);
                            file_put_contents($local_file, $output);
                            if (file_exists($local_file)) {
                                $zipfiles[] = $local_file;
                            }

                        }
                    }else if(count($usage_data_noservice)>0 && $GroupByService == 0) {
                        /** remove extra columns*/
                        $usage_data_noservice = remove_extra_columns($usage_data_noservice,$usage_data_table);
                        $local_file = $dir . '/' . str_slug($AccountName) . '-' . date("d-m-Y-H-i-s", strtotime($start_date)) . '-TO-' . date("d-m-Y-H-i-s", strtotime($end_date)) . '__' . $ProcessID . '.csv';
                        $output = Helper::array_to_csv($usage_data_noservice);
                        file_put_contents($local_file, $output);
                        if (file_exists($local_file)) {
                            $zipfiles[] = $local_file;
                        }
                    }else{
                        $usage_data = array();
                        $local_file = $dir . '/' . str_slug($AccountName) . '-' . date("d-m-Y-H-i-s", strtotime($start_date)) . '-TO-' . date("d-m-Y-H-i-s", strtotime($end_date)) . '__' . $ProcessID . '.csv';

                        $output = Helper::array_to_csv($usage_data);
                        file_put_contents($local_file, $output);
                        if (file_exists($local_file)) {
                            $zipfiles[] = $local_file;
                        }
                    }
                    if (!empty($zipfiles)) {

                        // when files only one then csv download other wise zip of all csv download
                        if(count($zipfiles)==1){
                            $local_zip_file = $zipfiles[0];
                        }else{

                            $local_zip_file = $dir . '/' . str_slug($AccountName) . '-' . date("d-m-Y-H-i-s", strtotime($start_date)) . '-TO-' . date("d-m-Y-H-i-s", strtotime($end_date)) . '__' . $ProcessID . '.zip';

                            /* make zip of all csv files */

                            Zipper::make($local_zip_file)->add($zipfiles)->close();
                        }

                        $fullPath = $amazonPath . basename($local_zip_file); //$destinationPath . $file_name;
                        if (!AmazonS3::upload($local_zip_file, $amazonPath, $CompanyID)) {
                            throw new Exception('Error in Amazon upload');
                        }

                        AmazonS3::delete($Invoice->UsagePath,$CompanyID); // Delete old usage file from amazon
                        $Invoice->update(["UsagePath" => $fullPath]); // Update new one
                    }

                }
            }

            return $fullPath;
        }
    }


    public static function getMonthlyInvoicesData($InvoiceIDs){
        return Invoice::join("tblInvoiceDetail","tblInvoiceDetail.InvoiceID","=","tblInvoice.InvoiceID")
            ->whereIn("tblInvoice.InvoiceID", $InvoiceIDs)
            ->whereIn("tblInvoiceDetail.ProductType",[Product::USAGE, Product::INVOICE_PERIOD])
            ->select("tblInvoiceDetail.StartDate","tblInvoiceDetail.EndDate","tblInvoice.AccountType","tblInvoice.InvoiceNumber","tblInvoice.InvoiceID","tblInvoice.AccountID","tblInvoice.CompanyID")
            ->groupBy("tblInvoice.InvoiceID")
            ->get();
    }

    public static function delInvoiceData($InvoiceID) {
        InvoiceDetail::where('InvoiceID', $InvoiceID)->delete();
        InvoiceComponentDetail::leftJoin('tblInvoiceDetail', "tblInvoiceDetail.InvoiceDetailID","=","tblInvoiceComponentDetail.InvoiceDetailID")
            ->whereNull("tblInvoiceDetail.InvoiceDetailID")->delete();
        AccountBalanceSubscriptionLog::where('InvoiceID', $InvoiceID)->update(['InvoiceID' => 0]);
    }

    public static function regenerateInvoiceData($InvoiceData, $InvoiceEmail, $JobID = 0){

        DB::beginTransaction();
        DB::connection('sqlsrv2')->beginTransaction();

        $InvoiceID      = $InvoiceData->InvoiceID;
        $AccountID      = $InvoiceData->AccountID;
        $CompanyID      = $InvoiceData->CompanyID;
        $AccountType    = $InvoiceData->AccountType;
        $StartDate      = $InvoiceData->StartDate;
        $EndDate        = $InvoiceData->EndDate;

        try {
            self::delInvoiceData($InvoiceID);
            $Account = Account::find($AccountID);
            $BalanceLog = AccountBalanceLog::where('AccountID',$AccountID)->first();

            if($Account != false && $BalanceLog != false) {

                $AccountBalanceLogID = $BalanceLog->AccountBalanceLogID;
                $decimal_places = Helper::get_round_decimal_places($CompanyID,$AccountID);

                // Adding Invoice Data
                InvoiceGenerate::addInvoiceData($CompanyID, $AccountID, $InvoiceID, $StartDate, $EndDate, $AccountBalanceLogID, $AccountType, $decimal_places, $Account->CurrencyId);

                DB::connection('sqlsrv2')->commit();
                DB::commit();
                Log::info('Invoice Regenerated InvoiceID = ' . $InvoiceID);

                // Sending Email
                $Invoice = Invoice::find($InvoiceID);
                $InvoiceNumberPrefix = Company::getCompanyField($CompanyID, "InvoiceNumberPrefix");
                $CompanyName = Company::getName($Account->CompanyId);

                $status = Invoice::EmailToCustomer($Account,$Invoice->GrandTotal,$Invoice,$InvoiceNumberPrefix,$CompanyName,$CompanyID,$InvoiceEmail,0,$JobID);
                if(isset($status['status']) && isset($status['message']) && $status['status']=='failure'){
                    Log::info('Email sent failed against InvoiceID = ' . $InvoiceID);
                }

                return true;

            } else {
                DB::rollback();
                DB::connection('sqlsrv2')->rollback();

                Log::error("$InvoiceID : Invoice Regenerate Rollback. $AccountID : Has no Balance Log ID.");

                return false;
            }
        } catch (\Exception $err) {
            DB::rollback();
            DB::connection('sqlsrv2')->rollback();

            Log::error("$InvoiceID: Invoice Regenerate Rollback. Failed.");
            Log::error($err);

            return false;
        }
    }

    /**
     * Invoice Generation Date
     * */
    public static function getLastInvoiceDate($CompanyID,$AccountID,$ServiceID ){

        /**
         * Assumption : If Billing Cycle is 7 Days then Usage and Subscription both will be 7 Days and same for Monthly and other billing cycles..
         * */
        if(!empty($CompanyID) && !empty($AccountID) ) {


            $LastInvoiceDate = AccountBilling::where(["AccountID" => $AccountID,"ServiceID"=>$ServiceID])->pluck("LastInvoiceDate");

            if (!empty($LastInvoiceDate)) {
                return $LastInvoiceDate;
            }
            // ignore item invoice
            $invocie_count =  Account::getInvoiceCount($AccountID);
            if($invocie_count == 0){
                $AccountBilling = AccountBilling::getBilling($AccountID,$ServiceID);
                $BillingStartDate = $AccountBilling->BillingStartDate;
                return $BillingStartDate;
            }

        }

    }

    /**
     * Invoice Generation Date
     * Always calculate next Invoice Date from Last InvoiceDate or BillingStartDate
     * */
    public static function getNextInvoiceDate($CompanyID,$AccountID,$ServiceID){

        /**
         * Assumption : If Billing Cycle is 7 Days then Usage and Subscription both will be 7 Days and same for Monthly and other billing cycles..
         * */
        if(!empty($CompanyID) && !empty($AccountID) ) {

            $Account = AccountBilling::select(["NextInvoiceDate","BillingStartDate","LastInvoiceDate","BillingCycleType","BillingCycleValue"])->where(["AccountID"=>$AccountID,"ServiceID"=>$ServiceID])->first()->toArray();

            if(!empty($Account['LastInvoiceDate'])){
                $BillingStartDate = strtotime($Account['LastInvoiceDate']);
            }
            else if(!empty($Account['BillingStartDate'])) {
                $BillingStartDate = strtotime($Account['BillingStartDate']);
            }else{
                return '';
            }
            $NextInvoiceDate = next_billing_date($Account['BillingCycleType'],$Account['BillingCycleValue'],$BillingStartDate);
            return $NextInvoiceDate;
        }

    }
    /**
     * Invoice Generation Date
     * */
    public static function calculateNextInvoiceDateFromLastInvoiceDate($InvoiceID,$CompanyID,$AccountID,$ServiceID,$LastInvoiceDate){

        if(!empty($CompanyID) && !empty($AccountID) && !empty($LastInvoiceDate) ){

            $BillingCycle = InvoiceHistory::select(["BillingCycleType", "BillingCycleValue"])->where(["InvoiceID"=>$InvoiceID,"AccountID"=>$AccountID,"ServiceID"=>$ServiceID])->first()->toArray();
            //"weekly"=>"Weekly", "monthly"=>"Monthly" , "daily"=>"Daily", "in_specific_days"=>"In Specific days", "monthly_anniversary"=>"Monthly anniversary");

            $NextInvoiceDate = "";
            $LastInvoiceDate = strtotime($LastInvoiceDate);
            $NextInvoiceDate = next_billing_date($BillingCycle['BillingCycleType'],$BillingCycle['BillingCycleValue'],$LastInvoiceDate);

            return $NextInvoiceDate;
        }

    }


    public static function sendInvoice($CompanyID,$AccountID,$LastInvoiceDate,$NextInvoiceDate,$InvoiceGenerationEmail,$ProcessID,$JobID,$ServiceID,$ManualInvoice){

        /**
         * Invoice Will Calculate Base on Last Charge Date and Next Charge Date(both date included)
         *
         **/

        $error = "";
        $FirstInvoiceSend=1;
        if($ManualInvoice==1){
            $StartDate = $LastInvoiceDate;
            $EndDate =  date("Y-m-d 23:59:59", strtotime( "-1 Day", strtotime($NextInvoiceDate)));
            $FirstInvoiceSend=0;
        }else{
            $FirstInvoiceSend=Invoice::isFirstInvoiceSend($CompanyID,$AccountID,$ServiceID);
            $AccountBilling = AccountBilling::getBilling($AccountID,$ServiceID);
            $StartDate=$AccountBilling->LastChargeDate;
            $EndDate=$AccountBilling->NextChargeDate;
            $EndDate =  date("Y-m-d 23:59:59", strtotime($EndDate));
        }

        Log::info('start Date =' . $StartDate . " EndDate =" .$EndDate );

        if($AccountID > 0 && $CompanyID > 0 && !empty($StartDate) && !empty($EndDate)) {

            $CompanyName  = Company::getName($CompanyID);

            $Account = Account::find((int)$AccountID);
            $AccountBilling = AccountBilling::getBillingClass((int)$AccountID,$ServiceID);

            if(!empty($Account)) {

                $InvoiceTemplate = InvoiceTemplate::where("InvoiceTemplateID",$AccountBilling->InvoiceTemplateID)->first();

                if ( empty($AccountBilling->InvoiceTemplateID) || empty($InvoiceTemplate) ) {
                    $error = $Account->AccountName . ' ' . Invoice::$InvoiceGenrationErrorReasons['InvoiceTemplate'];
                    return array("status" => "failure", "message" => $error);
                }

                Log::info('InvoiceTemplate->InvoiceNumberPrefix =' .($InvoiceTemplate->InvoiceNumberPrefix)) ;
                Log::info('InvoiceTemplate->Terms =' .($InvoiceTemplate->Terms));


                if(!empty($InvoiceTemplate)) {

                    $InvoiceTemplate->DateFormat = invoice_date_fomat($InvoiceTemplate->DateFormat);
                    $decimal_places = Helper::get_round_decimal_places($CompanyID,$Account->AccountID,$ServiceID);

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

                    if($FirstInvoiceSend==0){
                        $AlreadyBilled = Invoice::checkIfAccountUsageAlreadyBilled($CompanyID,$AccountID, $StartDate, $EndDate,$ServiceID);
                        //If Already Billed
                        if ($AlreadyBilled) {
                            $error = $Account->AccountName . ' ' . Invoice::$InvoiceGenrationErrorReasons["AlreadyInvoiced"];
                            return array("status" => "failure", "message" => $error);
                        }
                    }else{
                        $AlreadyBilled=0;
                    }


                    $Invoice = "";
                    $SubTotal = 0;
                    $SubTotalWithoutTax = 0;
                    $AdditionalChargeTax = 0;

                    //If Account usage not already billed
                    Log::info('AlreadyBilled '.$AlreadyBilled);
                    if (!$AlreadyBilled) {
                        $OnlyUsageCallChares=0;
                        $uResponse = self::addUsage($Account,$CompanyID, $AccountID,$LastInvoiceDate,$NextInvoiceDate,$StartDate,$EndDate,$InvoiceTemplate,$SubTotal,$decimal_places,$ServiceID,$FirstInvoiceSend,$OnlyUsageCallChares,0);
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
                    $subResponse = self::addSubscription($Invoice,$ServiceID,$StartDate,$EndDate,$SubTotal,$decimal_places,0,$FirstInvoiceSend);
                    $SubTotal = $subResponse["SubTotal"];
                    $SubTotalWithoutTax += $subResponse["SubscriptionChargewithouttaxTotal"];

                    /**
                     * Add OneOffCharge in InvoiceDetail if any
                     */
                    $subResponse = self::addOneOffCharge($Invoice,$ServiceID,$StartDate,$EndDate,$SubTotal,$decimal_places,0,$FirstInvoiceSend);
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
                        $InvoiceID = $Invoice->InvoiceID;
                        $UsageStartDate = InvoiceDetail::where(["InvoiceID" => $InvoiceID, "ProductType" => Product::USAGE, "ServiceID" => $ServiceID])->pluck('StartDate');
                        $UsageStartDate = date("Y-m-d", strtotime($UsageStartDate));
                        $UsageEndDate = InvoiceDetail::where(["InvoiceID" => $InvoiceID, "ProductType" => Product::USAGE, "ServiceID" => $ServiceID])->pluck('EndDate');
                        log::info("New UsageDates ".$UsageStartDate.' - '.$UsageEndDate);
                        $OnlyUsageCallCharge=0;
                        $totals = self::updateInvoiceAllTotalAmounts($Invoice,$SubTotal,$SubTotalWithoutTax,$AdditionalChargeTax,$decimal_places,$ServiceID,$OnlyUsageCallCharge);

                        /*
                         * PDF Generation CODE HERE
                         *
                         */

                        if($FirstInvoiceSend==1 || $InvoiceTemplate->IgnoreCallCharge==1){
                            $usage_data = array();
                            $usage_data_table = self::usageDataTable($usage_data,$InvoiceTemplate);
                            $usage_data_table = array();
                            $usage_data_table['header'] =array();
                            $usage_data_table['data'] = array();
                        }else{
                            $usage_data = self::getInvoiceServiceUsage($CompanyID,$AccountID,$ServiceID,$UsageStartDate,$UsageEndDate,$InvoiceTemplate);
                            $usage_data_table = self::usageDataTable($usage_data,$InvoiceTemplate);
                        }

                        Log::info('PDF Generation start');

                        $pdf_path = Invoice::generate_pdf($InvoiceID,array(),$usage_data,$usage_data_table);
                        if(empty($pdf_path)){
                            $error = Invoice::$InvoiceGenrationErrorReasons["PDF"];
                            return array("status" => "failure", "message" => $error);
                        }else{
                            $Invoice->update(["PDF" => $pdf_path]);

                            // 0 entry in tblProcessCallChargesLog if call charges in invoice (deduct call charges in advance is turned off in billing class)
                            if($AccountBilling->DeductCallChargeInAdvance == 0) {
                                $ProductDescription = " From " . date($InvoiceTemplate->DateFormat, strtotime($UsageStartDate)) . " To " . date($InvoiceTemplate->DateFormat, strtotime($UsageEndDate));
                                $CallChargesData["InvoiceID"] = $InvoiceID;
                                $CallChargesData['ProductID'] = 0;
                                $CallChargesData['ServiceID'] = $ServiceID;
                                $CallChargesData['ProductType'] = Product::ADVANCECALLCHARGE;
                                $CallChargesData['Description'] = $ProductDescription;
                                $CallChargesData['StartDate'] = $UsageStartDate;
                                $CallChargesData['EndDate'] = $UsageEndDate;
                                $CallChargesData['Price'] = 0;
                                $CallChargesData['Qty'] = 1;
                                $CallChargesData['Discount'] = 0;
                                $CallChargesData['LineTotal'] = 0;
                                $CallChargesData["created_at"] = date("Y-m-d H:i:s");
                                $CallChargesData["CreatedBy"] = 'RMScheduler';
                                InvoiceDetail::insert($CallChargesData);
                            }
                        }

                        Log::info('PDF fullPath ' . $pdf_path);

                        /** Generate Usage File **/
                        Log::info('Generate Usage File Start ') ;

                        $fullPath = "";
                        if($FirstInvoiceSend==1 || $InvoiceTemplate->IgnoreCallCharge==1){
                            // No Need to file generate
                        }else{
                            if ($InvoiceTemplate->CDRType != Account::NO_CDR) { // Check in to generate Invoice usage file or not
                                if ($InvoiceID > 0 && $AccountID > 0) {
                                    $fullPath = Invoice::generate_usage_file($InvoiceID, $usage_data_table, $UsageStartDate, $UsageEndDate, $InvoiceTemplate->GroupByService, $usage_data);
                                    if (empty($fullPath)) {
                                        $error = $Account->AccountName . ' ' . Invoice::$InvoiceGenrationErrorReasons['UsageFile'];
                                    }
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



    public static function checkIfAccountUsageAlreadyBilled($CompanyID,$AccountID,$StartDate,$EndDate,$ServiceID){

        if(!empty($CompanyID) && !empty($AccountID) && !empty($StartDate) && !empty($EndDate) ){

            //Check if Invoice Usage is alrady Created.
            $isAccountUsageBilled = DB::connection('sqlsrv2')->select("SELECT COUNT(inv.InvoiceID) as count  FROM tblInvoice inv LEFT JOIN tblInvoiceDetail invd  ON invd.InvoiceID = inv.InvoiceID WHERE inv.CompanyID = " . $CompanyID . " AND inv.AccountID = " . $AccountID . " AND (('" . $StartDate . "' BETWEEN invd.StartDate AND invd.EndDate) OR('" . $EndDate . "' BETWEEN invd.StartDate AND invd.EndDate) OR (invd.StartDate BETWEEN '" . $StartDate . "' AND '" . $EndDate . "') ) and invd.ProductType = " . Product::USAGE . " and inv.InvoiceType = " . Invoice::INVOICE_OUT . " and inv.InvoiceStatus != '" . Invoice::CANCEL."' AND inv.ServiceID = $ServiceID");

            if (isset($isAccountUsageBilled[0]->count) && $isAccountUsageBilled[0]->count == 0) {
                return false;
            }
        }
        return true;
    }

    public static function getAccountUsageTotal($CompanyID,$AccountID,$StartDate,$EndDate,$ServiceID) {

        $TotalCharges = 0;
        if(!empty($CompanyID) && !empty($AccountID) && !empty($StartDate) && !empty($EndDate) ) {
            $IsReseller = Account::where(array('AccountID'=>$AccountID))->pluck('IsReseller');
            if(empty($IsReseller)){
                Log::info('Reseller ==> 0');
                $GatewayAccount =  GatewayAccount::where(array('AccountID'=>$AccountID))->distinct()->get(['CompanyGatewayID']);
            }else{
                Log::info('Reseller ==> 1');
                $GatewayAccount =  CompanyGateway::where(array('Status'=>1))->get(['CompanyGatewayID']);
            }
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
                $query = "CALL prc_getAccountInvoiceTotal(" . (int)$AccountID . ",$CompanyID,".$GatewayAccountRow['CompanyGatewayID'].",".$ServiceID.",'$BillingStartDate','$BillingEndDate',0,0)";
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

    public static  function generate_pdf($InvoiceID,$data = [],$usage_data = [],$usage_data_table = []){

        if($InvoiceID>0) {
            $print_type = Invoice::PRINTTYPE;
            $Invoice = Invoice::find($InvoiceID);

            $language=Account::where("AccountID", $Invoice->AccountID)
                ->join('tblLanguage', 'tblLanguage.LanguageID', '=', 'tblAccount.LanguageID')
                ->join('tblTranslation', 'tblTranslation.LanguageID', '=', 'tblAccount.LanguageID')
                ->select('tblLanguage.ISOCode', 'tblTranslation.Language', 'tblLanguage.is_rtl')
                ->first();
            App::setLocale($language->ISOCode);

            $InvoiceDetail = InvoiceDetail::where(["InvoiceID" => $InvoiceID])->get();
            $Account = Account::find($Invoice->AccountID);
            $ServiceID = $Invoice->ServiceID;
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
                $AccountBilling = AccountBilling::getBillingClass($Invoice->AccountID,$ServiceID);
                $PaymentDueInDays = AccountBilling::getPaymentDueInDays($Invoice->AccountID,$ServiceID);
                $InvoiceTemplateID = $AccountBilling->InvoiceTemplateID;
                $InvoiceTaxRates = InvoiceTaxRate::where("InvoiceID",$InvoiceID)
                    ->select('TaxRateID', 'Title', DB::Raw('sum(TaxAmount) as TaxAmount'))
                    ->groupBy("TaxRateID")->get();
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

            $service_data = self::getServiceData($Invoice->AccountID,$ServiceID,$usage_data,$InvoiceDetail);

            $InvoiceDetailPeriod = InvoiceDetail::where(["InvoiceID" => $InvoiceID,'ProductType'=>Product::INVOICE_PERIOD])->first();
            $InvoiceTemplate->DateFormat = invoice_date_fomat($InvoiceTemplate->DateFormat);
            if(empty($Invoice->RecurringInvoiceID) && !empty($InvoiceDetailPeriod) && isset($InvoiceDetailPeriod->StartDate) && isset($InvoiceDetailPeriod->EndDate) && $InvoiceDetailPeriod->StartDate != '1900-01-01' && $InvoiceDetailPeriod->EndDate != '1900-01-01') {
                $common_name = Str::slug($Account->AccountName . '-' . $Invoice->FullInvoiceNumber . '-From-' . date($InvoiceTemplate->DateFormat, strtotime($InvoiceDetailPeriod->StartDate)) .'-To-'.date($InvoiceTemplate->DateFormat, strtotime($InvoiceDetailPeriod->EndDate)). '-' . $InvoiceID);
            }else{
                $common_name = Str::slug($Account->AccountName . '-' . $Invoice->FullInvoiceNumber . '-' . date($InvoiceTemplate->DateFormat, strtotime($Invoice->IssueDate)) . '-' . $InvoiceID);
            }
            $InvoiceUSAGEPeriod = InvoiceDetail::where(["InvoiceID" => $InvoiceID,'ProductType'=>Product::USAGE])->first();
            $ManagementReports = array();
            if(!empty($InvoiceUSAGEPeriod) && !empty($InvoiceTemplate->ManagementReport)){
                $management_query = "call prc_InvoiceManagementReport ('" . $companyID . "','".intval($Invoice->AccountID) . "','".$InvoiceUSAGEPeriod->StartDate . "','".$InvoiceUSAGEPeriod->EndDate. "')";
                $ManagementReports = DataTableSql::of($management_query,'sqlsrvcdr')->getProcResult(array('LongestCalls','ExpensiveCalls','DialledNumber','DailySummary','UsageCategory'));
                $ManagementReports = json_decode(json_encode($ManagementReports['data']), true);
            }
            $file_name = 'Invoice-' . $common_name . '.pdf';
            $htmlfile_name = 'Invoice-' . $common_name . '.html';
            $RoundChargesAmount = Helper::get_round_decimal_places($Account->CompanyId,$Account->AccountID,$ServiceID);
            $RoundChargesCDR    = AccountBilling::getRoundChargesCDR($Account->AccountID,$ServiceID);

            /*Payment Data*/
            $payment_data = Payment::GetBillingPeriodPayments($InvoiceID,$Account->AccountID);

            $arrSignature=array();
            $arrSignature["UseDigitalSignature"] = CompanySetting::getKeyVal($companyID, 'UseDigitalSignature');
            $arrSignature["DigitalSignature"] = CompanySetting::getKeyVal($companyID, 'DigitalSignature');
            $arrSignature["signaturePath"]= CompanyConfiguration::get($companyID,'UPLOAD_PATH')."/".AmazonS3::generate_upload_path(AmazonS3::$dir['DIGITAL_SIGNATURE_KEY'], '', $companyID, true);
            if($arrSignature["DigitalSignature"]!="Invalid Key"){
                $arrSignature["DigitalSignature"]=json_decode($arrSignature["DigitalSignature"]);
            }else{
                $arrSignature["UseDigitalSignature"]=false;
            }
            /**
             * $InvoiceTemplate->DefaultTemplate = 0=>default template(template 1) , 1=>template 2
             */

            $MultiCurrencies=array();
            if($InvoiceTemplate->ShowTotalInMultiCurrency==1){
                $MultiCurrencies = Invoice::getTotalAmountInOtherCurrency($companyID,$Account->CurrencyId,$Invoice->GrandTotal,$RoundChargesAmount);
            }

            if(!empty($Invoice->RecurringInvoiceID)) {
                $body = View::make('emails.invoices.itempdf', compact('Invoice', 'InvoiceDetail', 'Account', 'InvoiceTemplate', 'CurrencyCode', 'logo', 'CurrencySymbol', 'AccountBilling', 'InvoiceTaxRates', 'PaymentDueInDays', 'InvoiceAllTaxRates','RoundChargesAmount','RoundChargesCDR','data','print_type','language','arrSignature','MultiCurrencies'))->render();
            }else if($InvoiceTemplate->GroupByService == 1) {
                if($InvoiceTemplate->DefaultTemplate ==1){
                    $body = View::make('emails.invoices.template2pdf', compact('Invoice', 'InvoiceDetail', 'InvoiceTaxRates', 'Account', 'InvoiceTemplate', 'usage_data_table', 'CurrencyCode', 'CurrencySymbol', 'logo', 'AccountBilling', 'PaymentDueInDays', 'RoundChargesAmount','RoundChargesCDR','print_type','service_data','ManagementReports','language','payment_data', 'arrSignature','MultiCurrencies'))->render();
                }else{
                    $body = View::make('emails.invoices.pdf', compact('Invoice', 'InvoiceDetail', 'InvoiceTaxRates', 'Account', 'InvoiceTemplate', 'usage_data_table', 'CurrencyCode', 'CurrencySymbol', 'logo', 'AccountBilling', 'PaymentDueInDays', 'RoundChargesAmount','RoundChargesCDR','print_type','service_data','ManagementReports','language','payment_data', 'arrSignature','MultiCurrencies'))->render();
                }
            }else {
                if($InvoiceTemplate->DefaultTemplate ==1){
                    $body = View::make('emails.invoices.template2defaultpdf', compact('Invoice', 'InvoiceDetail', 'InvoiceTaxRates', 'Account', 'InvoiceTemplate', 'usage_data_table', 'CurrencyCode', 'CurrencySymbol', 'logo', 'AccountBilling', 'PaymentDueInDays', 'RoundChargesAmount','RoundChargesCDR','print_type','service_data','ManagementReports','language','payment_data', 'arrSignature','MultiCurrencies'))->render();
                }else{
                    $body = View::make('emails.invoices.defaultpdf', compact('Invoice', 'InvoiceDetail', 'InvoiceTaxRates', 'Account', 'InvoiceTemplate', 'usage_data_table', 'CurrencyCode', 'CurrencySymbol', 'logo', 'AccountBilling', 'PaymentDueInDays', 'RoundChargesAmount','RoundChargesCDR','print_type','service_data','ManagementReports','language','payment_data', 'arrSignature','MultiCurrencies'))->render();
                }

            }
            $body = htmlspecialchars_decode($body);
            $footer = View::make('emails.invoices.pdffooter', compact('Invoice', 'Account','InvoiceTemplate'))->render();
            $footer = htmlspecialchars_decode($footer);

            $header = View::make('emails.invoices.pdfheader', compact('Invoice'))->render();
            $header = htmlspecialchars_decode($header);

            $amazonPath = AmazonS3::generate_path(AmazonS3::$dir['INVOICE_UPLOAD'],$Account->CompanyId,$Invoice->AccountID) ;
            $destination_dir = $UPLOADPATH . '/'. $amazonPath;
            if (!file_exists($destination_dir)) {
                RemoteSSH::make_dir($companyID,$destination_dir);
                //RemoteSSH::run($companyID, "mkdir -p " . $destination_dir);
                //RemoteSSH::run($companyID, "chmod -R 777 " . $destination_dir);
            }
            $local_file = $destination_dir .  $file_name;
            $local_htmlfile = $destination_dir .  $htmlfile_name;
            file_put_contents($local_htmlfile,$body);
            $footer_name = 'footer-'. $common_name .'.html';
            $footer_html = $destination_dir.$footer_name;
            file_put_contents($footer_html,$footer);
            $header_name = 'header-'. $common_name .'.html';
            $header_html = $destination_dir.$header_name;
            file_put_contents($header_html,$header);
            $output= "";
            if(getenv('APP_OS') == 'Linux'){
                RemoteSSH::run($companyID, base_path(). '/wkhtmltox/bin/wkhtmltopdf --header-spacing 3 --footer-spacing 1 --header-html "'.$header_html.'" --footer-html "'.$footer_html.'" "'.$local_htmlfile.'" "'.$local_file.'"',$output);
                Log::info(base_path(). '/wkhtmltox/bin/wkhtmltopdf --header-spacing 3 --footer-spacing 1 --header-html --footer-html "'.$footer_html.'" "'.$local_htmlfile.'" "'.$local_file.'"');

                if($arrSignature["UseDigitalSignature"]==true){
                    $newlocal_file = $destination_dir . str_replace(".pdf","-signature.pdf",$file_name);
                    $mypdfsignerOutput=RemoteSSH::run($companyID, 'PortableSigner  -n     -t '.$local_file.'      -o '.$newlocal_file.'     -s '.$arrSignature["signaturePath"].'digitalsignature.pfx -c "Signed after 4 alterations" -r "Approved for publication" -l "Department of Dermatology" -p Welcome100');
                    Log::info($mypdfsignerOutput);
                    if(file_exists($newlocal_file)){
                        RemoteSSH::run($companyID, 'rm '.$local_file);
                        RemoteSSH::run($companyID, 'mv '.$newlocal_file.' '.$local_file);
                    }
                }

            }else{
                exec (base_path().'/wkhtmltopdf/bin/wkhtmltopdf.exe --header-spacing 3 --footer-spacing 1 --header-html "'.$header_html.'" --footer-html "'.$footer_html.'" "'.$local_htmlfile.'" "'.$local_file.'"',$output);
                Log::info (base_path().'/wkhtmltopdf/bin/wkhtmltopdf.exe --header-spacing 3 --footer-spacing 1 --header-html "'.$header_html.'" --footer-html "'.$footer_html.'" "'.$local_htmlfile.'" "'.$local_file.'"',$output);
            }
            Log::info($output);
            Log::info($local_htmlfile);
            Log::info($header_html);
            Log::info($footer_html);
            @unlink($local_htmlfile);
            @unlink($header_html);
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



    /**
    Calculate Total Tax on Invoice (Only Add Tax on Overall Invoice + Recurring Tax )
     *  Will add with passed usageTotalTax
     */
    public static function insertInvoiceTaxRate($InvoiceID,$AccountID,$InvoiceSubTotal,$AdditionalChargeTax,$ServiceID) {

        /*$Invoice = Invoice::find($InvoiceID);
        $InvoiceSubTotal = $Invoice->SubTotal;*/

        //Get Account TaxIDs
        $TaxRateIDs = AccountBilling::getTaxRate($AccountID,$ServiceID);

        $InvoiceDetails = InvoiceDetail::where("InvoiceID",$InvoiceID)->where("ProductType",Product::SUBSCRIPTION)->get();
        $SubscriptionTotal = 0;
        foreach($InvoiceDetails as $InvoiceDetail){
            $ExemptTax = AccountSubscription::where(array('AccountID'=>$AccountID,'SubscriptionID'=>$InvoiceDetail->ProductID))->pluck('ExemptTax');
            if($ExemptTax == 0) {
                $SubscriptionTotal += $InvoiceDetail->LineTotal;
            }
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

                        } else if ($TaxRate->TaxType == TaxRate::TAX_USAGE) {
                            $SubTotal = $UsageTotal;
                            $Title = $TaxRate->Title . ' (Usage)';

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

                        } else if ($TaxRate->TaxType == TaxRate::TAX_RECURRING) {
                            /* $SubTotal = $SubscriptionTotal;

                             $Title = $TaxRate->Title . ' (Subscription)';*/
                            foreach($InvoiceDetails as $InvoiceDetail){
                                $ExemptTax = AccountSubscription::where(array('AccountID'=>$AccountID,'AccountSubscriptionID'=>$InvoiceDetail->AccountSubscriptionID,'SubscriptionID'=>$InvoiceDetail->ProductID))->pluck('ExemptTax');
                                if($ExemptTax == 0) {

                                    $TotalTax = Invoice::calculateTotalTaxByTaxRateObj($TaxRate, $InvoiceDetail->LineTotal);
                                    $TaxGrandTotal += $TotalTax;
                                    $Title = $TaxRate->Title;
                                    InvoiceTaxRate::create(array(
                                        "InvoiceDetailID" =>$InvoiceDetail->InvoiceDetailID,
                                        "InvoiceID" => $InvoiceID,
                                        "TaxRateID" => $TaxRateID,
                                        "TaxAmount" => $TotalTax,
                                        "Title" => $Title,
                                    ));

                                }
                            }
                        }

                        //$TotalTax = Invoice::calculateTotalTaxByTaxRateObj($TaxRate, $SubTotal);
                        /*if ($TaxRate->TaxType == TaxRate::TAX_ALL) {
                             $TotalTax += $AdditionalChargeTax;
                            Log::info('AdditionalChargeTax - ' . $AdditionalChargeTax);
                             $AdditionalChargeTax = 0;
                        }*/
                        /* $TaxGrandTotal += $TotalTax;
                         InvoiceTaxRate::create(array(
                             "InvoiceID" => $InvoiceID,
                             "TaxRateID" => $TaxRateID,
                             "TaxAmount" => $TotalTax,
                             "Title" => $Title,
                         ));*/
                    }
                }
            }
        }
        $TaxGrandTotal += self::addOneOffTaxCharge($InvoiceID,$AccountID,$ServiceID);
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
    public static function regenerateInvoice($CompanyID,$Invoice, $InvoiceDetail,$InvoiceGenerationEmail,$ProcessID,$JobID,$FirstInvoiceSend){
        $error = array();
        $message = array();
        $SubTotal = 0;
        $SubTotalWithoutTax = $AdditionalChargeTax =  0;
        $regenerate =1;
        $Account = Account::find((int)$Invoice->AccountID);
        $ServiceID = $Invoice->ServiceID;
        $AccountID = $Account->AccountID;
        $AccountBilling = AccountBilling::getBillingClass($AccountID,$ServiceID);

        /**
         * New Logic - Regenerate will work on invoice history like period lastchargedate-nextchragedate,usage came from invoicedetail
         */
        $InvoiceHistory = InvoiceHistory::where(["InvoiceID"=>$Invoice->InvoiceID,"AccountID"=>$AccountID,"ServiceID"=>$ServiceID])->First();
        if(empty($InvoiceHistory)){
            InvoiceHistory::addInvoiceHistoryDetail($Invoice->InvoiceID,$AccountID,$ServiceID,$FirstInvoiceSend,1);
            log::info('Invoice History Created');
            $InvoiceHistory = InvoiceHistory::where(["InvoiceID"=>$Invoice->InvoiceID,"AccountID"=>$AccountID,"ServiceID"=>$ServiceID])->First();
        }
        $BillingCycleType = $InvoiceHistory->BillingCycleType;
        $StartDate=$InvoiceHistory->LastChargeDate;
        $EndDate=$InvoiceHistory->NextChargeDate;
        $EndDate =  date("Y-m-d 23:59:59", strtotime($EndDate));

        if($FirstInvoiceSend==0) {
            $UsageStartDate = InvoiceDetail::where(["InvoiceID" => $Invoice->InvoiceID, "ProductType" => Product::USAGE, "ServiceID" => $ServiceID])->pluck('StartDate');
            $UsageStartDate = date("Y-m-d", strtotime($UsageStartDate));
            $UsageEndDate = InvoiceDetail::where(["InvoiceID" => $Invoice->InvoiceID, "ProductType" => Product::USAGE, "ServiceID" => $ServiceID])->pluck('EndDate');
        }else{
            $UsageStartDate='';
            $UsageEndDate='';
        }

        if($BillingCycleType == 'manual'){
            $StartDate = $UsageStartDate;
            $EndDate =  date("Y-m-d 23:59:59", strtotime($UsageEndDate));
        }
        Log::info('BillingCycleType : ' . $BillingCycleType.' - '.'StartDate : ' . $StartDate.' - '.'EndDate : '.$EndDate);

        /**
        $StartDate = date("Y-m-d", strtotime($InvoiceDetail[0]->StartDate));
        $EndDate = date("Y-m-d 23:59:59", strtotime($InvoiceDetail[0]->EndDate));*/

        if($AccountID > 0 && $CompanyID > 0 && !empty($StartDate) && !empty($EndDate)) {
            $CompanyName = Company::getName($CompanyID);

            if (!empty($Account)) {
                $InvoiceTemplate = InvoiceTemplate::where("InvoiceTemplateID", $AccountBilling->InvoiceTemplateID)->first();
                if ( empty($AccountBilling->InvoiceTemplateID) || empty($InvoiceTemplate) ) {
                    $error['message'] = $Account->AccountName . ' ' . Invoice::$InvoiceGenrationErrorReasons['InvoiceTemplate'];
                    $error['status'] = 'failure';
                    return $error;
                }
                if (!empty($InvoiceTemplate)) {
                    $decimal_places = Helper::get_round_decimal_places($CompanyID,$Account->AccountID,$ServiceID);

                    Log::info('Invoice::getAccountUsageTotal(' . $CompanyID . ',' . $AccountID . ',' . $UsageStartDate . ',' . $UsageEndDate . ')');
                    $InvoiceTemplate->DateFormat = invoice_date_fomat($InvoiceTemplate->DateFormat);

                    //get Total Usage
                    if($FirstInvoiceSend==1){
                        $TotalCharges=0;
                    }else{
                        if(isset($InvoiceTemplate->IgnoreCallCharge) && $InvoiceTemplate->IgnoreCallCharge==1){
                            $TotalCharges = 0;
                            Log::info('Invoice IgnoreCallCharge 1');
                        } else{
                            $TotalCharges = Invoice::getAccountUsageTotal($CompanyID, $AccountID, $UsageStartDate, $UsageEndDate,$ServiceID);
                        }
                    }

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
                    if($FirstInvoiceSend==0) {
                        $ProductDescription = " From " . date($InvoiceTemplate->DateFormat, strtotime($UsageStartDate)) . " To " . date($InvoiceTemplate->DateFormat, strtotime($UsageEndDate));
                        $InvoiceDetailData = array();
                        $InvoiceDetailData["InvoiceID"] = $Invoice->InvoiceID;
                        $InvoiceDetailData['ProductID'] = 0;
                        $InvoiceDetailData['ProductType'] = Product::USAGE;
                        $InvoiceDetailData['Description'] = $ProductDescription;
                        $InvoiceDetailData['StartDate'] = $UsageStartDate;
                        $InvoiceDetailData['EndDate'] = $UsageEndDate;
                        $InvoiceDetailData['Price'] = $TotalUsageCharges;
                        $InvoiceDetailData['Qty'] = 1;
                        $InvoiceDetailData['Discount'] = 0;
                        $InvoiceDetailData['LineTotal'] = $TotalUsageCharges;
                        $InvoiceDetailData["updated_at"] = date("Y-m-d H:i:s");
                        $InvoiceDetailData["ModifiedBy"] = 'RMScheduler';
                        InvoiceDetail::where(array('InvoiceID' => $Invoice->InvoiceID, 'ProductID' => 0, 'ProductType' => Product::USAGE))->update($InvoiceDetailData);
                    }
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
                    $subResponse = self::addSubscription($Invoice,$ServiceID,$StartDate,$EndDate,$SubTotal,$decimal_places,$regenerate,$FirstInvoiceSend);
                    $SubTotal = $subResponse["SubTotal"];
                    $SubTotalWithoutTax += $subResponse["SubscriptionChargewithouttaxTotal"];

                    /**
                     * Add OneOffCharge in InvoiceDetail if any
                     */
                    $subResponse = self::addOneOffCharge($Invoice,$ServiceID,$StartDate,$EndDate,$SubTotal,$decimal_places,$regenerate,$FirstInvoiceSend);
                    $SubTotal = $subResponse["SubTotal"];
                    $SubTotalWithoutTax += $subResponse["SubscriptionChargewithouttaxTotal"];
                    $AdditionalChargeTax = $subResponse["AdditionalChargeTotalTax"];


                    Log::info('USAGE FILE & Invoice PDF & EMAIL Start');

                    if (isset($Invoice)) {

                        // Add Tax in Subtotal and Update all Total Fields in Invoice Table.
                        $OnlyUsageCallCharge=0;
                        $totals = self::updateInvoiceAllTotalAmounts($Invoice,$SubTotal,$SubTotalWithoutTax,$AdditionalChargeTax,$decimal_places,$ServiceID,$OnlyUsageCallCharge);

                        /*
                         * PDF Generation CODE HERE
                         *
                         */
                        Log::info('PDF Generation start');
                        if($FirstInvoiceSend==1 || $InvoiceTemplate->IgnoreCallCharge==1){
                            $usage_data = array();
                            $usage_data_table = self::usageDataTable($usage_data,$InvoiceTemplate);
                            $usage_data_table = array();
                            $usage_data_table['header'] =array();
                            $usage_data_table['data'] = array();
                        }else{
                            $usage_data = self::getInvoiceServiceUsage($CompanyID,$AccountID,$ServiceID,$UsageStartDate,$UsageEndDate,$InvoiceTemplate);
                            $usage_data_table = self::usageDataTable($usage_data,$InvoiceTemplate);
                        }

                        $pdf_path = Invoice::generate_pdf($Invoice->InvoiceID,array(),$usage_data,$usage_data_table);
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
                        if($FirstInvoiceSend==1 || $InvoiceTemplate->IgnoreCallCharge==1){
                            // No Need to file generate
                        }else{
                            if ($InvoiceTemplate->CDRType != Account::NO_CDR) { // Check in to generate Invoice usage file or not
                                $InvoiceID = $Invoice->InvoiceID;
                                if ($InvoiceID > 0 && $AccountID > 0) {
                                    $fullPath = Invoice::generate_usage_file($InvoiceID, $usage_data_table, $UsageStartDate, $UsageEndDate, $InvoiceTemplate->GroupByService, $usage_data);
                                    if (empty($fullPath)) {
                                        $error['message'] = $Account->AccountName . ' ' . Invoice::$InvoiceGenrationErrorReasons['UsageFile'];
                                        $error['status'] = 'failure';
                                    }
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
        $WEBURL = CompanyConfiguration::getValueConfigurationByKey($CompanyID,'WEB_URL');
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

        $invoicePdfSend = CompanySetting::getKeyVal($CompanyID,'invoicePdfSend');
        if($invoicePdfSend!='Invalid Key' && $invoicePdfSend && !empty($Invoice->PDF)){
            $UPLOADPATH = CompanyConfiguration::get($CompanyID,'UPLOAD_PATH');
            $TEMP_PATH = CompanyConfiguration::get($CompanyID,'TEMP_PATH').'/'.pathinfo($Invoice->PDF, PATHINFO_BASENAME);
            $attach = AmazonS3::download( $CompanyID, $Invoice->PDF, $TEMP_PATH );
            $emaildata['attach'][] = (strpos($attach, "https://") !== false) ? $TEMP_PATH : $UPLOADPATH.$Invoice->PDF;
        }

        $status['status'] = "success"; // Default Status

        foreach ($InvoiceGenerationEmail as $singleemail) {
            $singleemail = trim($singleemail);
            if (filter_var($singleemail, FILTER_VALIDATE_EMAIL)) {
                $emaildata['EmailTo'] = $singleemail;
                // $emaildata['Subject'] = 'New invoice ' . $_InvoiceNumber . '('.$Account->AccountName.') from ' . $CompanyName;
                $body					=	EmailsTemplates::SendinvoiceSingle($Invoice->InvoiceID,'body',$CompanyID,$singleemail,$emaildata);
                $emaildata['Subject']	=	EmailsTemplates::SendinvoiceSingle($Invoice->InvoiceID,"subject",$CompanyID,$singleemail,$emaildata);

                $status = Helper::sendMail($body, $emaildata,0);
                // $status = Helper::sendMail('emails.invoices.bulk_invoice_email', $emaildata);
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
        }elseif(AccountBilling::getSendInvoiceSetting($Account->AccountID) == 'automatically'){
            $canSend=1;
        }
        Log::info('$canSend:' . json_encode($canSend));

        if( $EMAIL_TO_CUSTOMER == 1 && $canSend == 1  && $GrandTotal > 0 ) {

            $InvoiceGenerationEmail = Notification::getNotificationMail(['CompanyID' => $CompanyID, 'NotificationType' => Notification::InvoiceCopy]);
            if(!empty($InvoiceGenerationEmail)) {
                $InvoiceGenerationEmail = explode(',',$InvoiceGenerationEmail);
                foreach ($InvoiceGenerationEmail as $singleemail) {
                    $singleemail = trim($singleemail);
                    if (filter_var($singleemail, FILTER_VALIDATE_EMAIL)) {
                        $emaildata['EmailTo'] = $singleemail;
                        $emaildata['data']['InvoiceLink'] = $WEBURL . '/invoice/' . $Account->AccountID . '-' . $Invoice->InvoiceID . '/cview?email=' . $singleemail;
                        $emaildata['InvoiceLink'] = $WEBURL . '/invoice/' . $Account->AccountID . '-' . $Invoice->InvoiceID . '/cview?email=' . $singleemail;
                        $body					=	EmailsTemplates::SendinvoiceSingle($Invoice->InvoiceID,'body',$CompanyID,$singleemail,$emaildata);
                        $emaildata['Subject']	=	EmailsTemplates::SendinvoiceSingle($Invoice->InvoiceID,"subject",$CompanyID,$singleemail,$emaildata);

                        $status = Helper::sendMail($body, $emaildata,0);

                        //  $status = Helper::sendMail('emails.invoices.bulk_invoice_email', $emaildata);
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
                        $emaildata['InvoiceLink'] = $WEBURL . '/invoice/' . $Account->AccountID . '-' . $Invoice->InvoiceID . '/cview?email=' . $singleemail;
                        $body					=	EmailsTemplates::SendinvoiceSingle($Invoice->InvoiceID,'body',$CompanyID,$singleemail,$emaildata);
                        $emaildata['Subject']	=	EmailsTemplates::SendinvoiceSingle($Invoice->InvoiceID,"subject",$CompanyID,$singleemail,$emaildata);
                        $emaildata['EmailFrom']	=	EmailsTemplates::GetEmailTemplateFrom(Invoice::EMAILTEMPLATE,$CompanyID);

                        $status = Helper::sendMail($body, $emaildata,0);
                        //$status = Helper::sendMail('emails.invoices.bulk_invoice_email', $emaildata);
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
                    $UserID = Job::find($JobID)->JobLoggedUserID;
                    if (!empty($UserID) && $UserID > 0) {
                        $User = User::find($UserID);
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

    public static function updateInvoiceAllTotalAmounts($Invoice,$SubTotal,$SubTotalWithoutTax,$AdditionalChargeTax,$decimal_places,$ServiceID,$OnlyUsageCallCharge=0){

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
        if($OnlyUsageCallCharge==1) {
            $TotalTax = Invoice::insertInvoiceUsageTaxRate($Invoice->InvoiceID, $Invoice->AccountID, $SubTotal, $AdditionalChargeTax, $ServiceID);
        }else{
            $TotalTax = Invoice::insertInvoiceTaxRate($Invoice->InvoiceID, $Invoice->AccountID, $SubTotal, $AdditionalChargeTax, $ServiceID);
        }
        //$TotalTax += $AdditionalChargeTax; // Additional Tax from AdditionalCharge

        Log::info(' TotalTax ' . $TotalTax);

        $InvoiceGrandTotal = $SubTotal + $TotalTax + $SubTotalWithoutTax; // Total Tax Added in Grand Total.

        $TotalDue = $InvoiceGrandTotal + $PreviousBalance; // Grand Total - Previous Balance is Total Due.

        Log::info(' InvoiceGrandTotal ' . $InvoiceGrandTotal);
        //$InvoiceGrandTotal = number_format($InvoiceGrandTotal, $decimal_places, '.', '');
        $SubTotal = number_format($SubTotal+$SubTotalWithoutTax, $decimal_places, '.', '');
        $TotalTax = number_format($TotalTax, $decimal_places, '.', '');
        $TotalDue = number_format($TotalDue, $decimal_places, '.', '');

        $InvoiceTaxRateAmount =Invoice::getInvoiceTaxRateAmount($Invoice->InvoiceID,$decimal_places);
        $InvoiceGrandTotal = $SubTotal + $InvoiceTaxRateAmount;

        Log::info('GrandTotal ' . $InvoiceGrandTotal);
        Log::info('SubTotal ' . $SubTotal);
        Log::info('TotalDue ' . $TotalDue);

        $Totals = ["TotalTax"=> $TotalTax , "GrandTotal" => $InvoiceGrandTotal,"SubTotal" => $SubTotal,'PreviousBalance'=>$PreviousBalance,'TotalDue'=>$TotalDue];
        $Invoice->update($Totals);
        return $Totals;
    }

    public static function getInvoiceTaxRateAmount($InvoiceID,$RoundChargesAmount){

        $InvoiceTaxRateAmount = 0;

        $InvoiceTaxRates = InvoiceTaxRate::where(["InvoiceID" => $InvoiceID])->get();

        if(!empty($InvoiceTaxRates) && count($InvoiceTaxRates)>0) {
            foreach ($InvoiceTaxRates as $InvoiceTaxRate) {
                $Title = $InvoiceTaxRate->Title;
                $TaxRateID = $InvoiceTaxRate->TaxRateID;
                $TaxAmount = number_format($InvoiceTaxRate->TaxAmount,$RoundChargesAmount, '.', '');
                $InvoiceTaxRateAmount+=	$TaxAmount;
            }
        }

        Log::info('InvoiceTaxAmount '.$InvoiceTaxRateAmount);

        return $InvoiceTaxRateAmount;
    }

    public static function addSubscription($Invoice,$ServiceID,$StartDate,$EndDate,$SubTotal,$decimal_places,$regenerate = 0,$FirstInvoiceSend=0){

        // Get All Account Subscriptions
        $query = "CALL prc_getAccountSubscription(?,?)";
        $AccountSubscriptions = DB::connection('sqlsrv2')->select($query,array($Invoice->AccountID,$ServiceID));
        Log::info("Call prc_getAccountSubscription($Invoice->AccountID,$ServiceID)") ;
        $SubscriptionChargewithouttaxTotal = 0;
        Log::info('SUBSCRIPTION '.count($AccountSubscriptions)) ;
        $StartDate = date("Y-m-d",strtotime($StartDate));
        if($FirstInvoiceSend==1) {
            $EndDate = Invoice::getNextDateFirstInvoice($Invoice->InvoiceID,$Invoice->CompanyID, $Invoice->AccountID, $ServiceID);
            /** End Date Change for advance subscription*/
            $EndDate = date("Y-m-d", strtotime($EndDate));
        }else{
            $EndDate = date("Y-m-d",strtotime($EndDate));
        }


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
                $AlreadyBilled=0;
                /**check for advance subscription*/
                Log::info( " ============================Subscription Start ================= \n\n");
                Log::info( ' SubscriptionID - ' . $AccountSubscription->SubscriptionID );
                if($AccountSubscription->EndDate == '0000-00-00'){
                    $AccountSubscription->EndDate  = date("Y-m-d",strtotime('+1 years'));
                }
                $BillingCycleType = InvoiceHistory::where(["InvoiceID"=>$Invoice->InvoiceID,"AccountID"=>$Invoice->AccountID,"ServiceID"=>$ServiceID])->pluck('BillingCycleType');
                if(BillingSubscription::isAdvanceSubscription($AccountSubscription->SubscriptionID) && $BillingCycleType != 'manual'){
                    $isAdvanceSubscription =1;
                    Log::info( 'isAdvanceSubscription - ' . $AccountSubscription->SubscriptionID );

                    //Advance Subscription Date

                    /**
                     * Check StartDate And End Date and already billed or not
                     **/

                    $SubscriptionStartDate = Invoice::calculateNextInvoiceDateFromLastInvoiceDate($Invoice->InvoiceID,$Invoice->CompanyID,$Invoice->AccountID,$ServiceID,$StartDate); // Advance Date 1-7-2015 - 1-8-2015
                    $SubscriptionEndDate = Invoice::calculateNextInvoiceDateFromLastInvoiceDate($Invoice->InvoiceID,$Invoice->CompanyID,$Invoice->AccountID,$ServiceID,$SubscriptionStartDate); // Advance Date 1-7-2015 - 1-8-2015
                    $SubscriptionEndDate = date("Y-m-d", strtotime("-1 Day", strtotime($SubscriptionEndDate))); // Convert 1-8-2015 -to 31-7-2015
                    if($FirstInvoiceSend==0) {
                        $ASdata = Invoice::getAccountAdavanceSubscriptionDate($Invoice->InvoiceID,$Invoice->AccountID, $SubscriptionStartDate, $SubscriptionEndDate, $AccountSubscription);
                        $AlreadyBilled = $ASdata['AlreadyCharged'];
                        $SubscriptionStartDate = $ASdata['StartDate'];
                        $SubscriptionEndDate = $ASdata['EndDate'];
                        if ($AlreadyBilled == 1) {
                            log::info($AccountSubscription->InvoiceDescription . ' ' . $SubscriptionStartDate . ' ' . $SubscriptionEndDate . ' is already charged');
                        }
                    }

                    $NewBillingStartDate = InvoiceHistory::where(["InvoiceID"=>$Invoice->InvoiceID,"AccountID"=>$Invoice->AccountID,"ServiceID"=>$ServiceID])->pluck('BillingStartDate');
                    if($NewBillingStartDate>$AccountSubscription->StartDate){
                        log::info('New Account Subscription Start');
                        $AccountSubscription->StartDate=$NewBillingStartDate;
                    }
                    log::info(' AccountSubscription StartDate '.$AccountSubscription->StartDate.' StartDate '.$StartDate);
                    if (AccountSubscription::checkFirstTimeBilling($AccountSubscription->StartDate,$StartDate)) {
                        Log::info( 'First Time + Advance Billing - Yes' );

                        /**
                         * regular Subscription '1-1-2015' to '1-1-2016'
                         * charge for '1-3-2015' to '1-4-2015'
                         */
                        log::info('StartDate '.$StartDate.' - EndDate '.$EndDate);
                        log::info('ACStartDate '.$AccountSubscription->StartDate.' - ACEndDate '.$AccountSubscription->EndDate);
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

                if($FirstInvoiceSend==0) {

                    if ($isAdvanceSubscription == 0 && $SubscriptionStartDate >= $AccountSubscription->StartDate && $SubscriptionStartDate <= $AccountSubscription->EndDate && $SubscriptionEndDate >= $AccountSubscription->StartDate && $SubscriptionEndDate <= $AccountSubscription->EndDate) {
                        Log::info('regular Subscription ');
                        $addInvoiceSubscriptionDetail = Invoice::addInvoiceSubscriptionDetail($Invoice, $AccountSubscription, $SubscriptionStartDate, $SubscriptionEndDate, $SubscriptionChargewithouttaxTotal, $SubTotal, $decimal_places);
                        $SubTotal = $addInvoiceSubscriptionDetail['SubTotal'];
                        $SubscriptionChargewithouttaxTotal = $addInvoiceSubscriptionDetail['SubscriptionChargewithouttaxTotal'];
                    } else if ($isAdvanceSubscription == 0 && $AccountSubscription->StartDate >= $SubscriptionStartDate && $AccountSubscription->StartDate <= $SubscriptionEndDate) {
                        /**
                         *Special Subscription with StartDate  '15-3-2015' to '1-1-2016'
                         * charge for '1-3-2015' to '1-4-2015' should take '15-3-2015' to '1-4-2015'
                         */
                        $SubscriptionStartDate = $AccountSubscription->StartDate;
                        Log::info('charge half of month - Subscription Start after StartDate');
                        if ($AccountSubscription->EndDate < $SubscriptionEndDate) {
                            $SubscriptionEndDate = $AccountSubscription->EndDate;// '15-3-2015' to '20-3-2015'
                            Log::info('charge half of month - Subscription end before EndDate');
                        }
                        $addInvoiceSubscriptionDetail = Invoice::addInvoiceSubscriptionDetail($Invoice, $AccountSubscription, $SubscriptionStartDate, $SubscriptionEndDate, $SubscriptionChargewithouttaxTotal, $SubTotal, $decimal_places);
                        $SubTotal = $addInvoiceSubscriptionDetail['SubTotal'];
                        $SubscriptionChargewithouttaxTotal = $addInvoiceSubscriptionDetail['SubscriptionChargewithouttaxTotal'];
                    } else if ($isAdvanceSubscription == 0 && $AccountSubscription->EndDate >= $SubscriptionStartDate && $AccountSubscription->EndDate <= $SubscriptionEndDate) {
                        /**
                         *Special Subscription with EndDate  '1-1-2015' to '15-3-2015'
                         * charge for '1-3-2015' to '1-4-2015' should take '1-3-2015' to '15-3-2015'
                         */
                        Log::info('charge half of month - 2 Subscription end before EndDate');
                        $SubscriptionEndDate = $AccountSubscription->EndDate;
                        $addInvoiceSubscriptionDetail = Invoice::addInvoiceSubscriptionDetail($Invoice, $AccountSubscription, $SubscriptionStartDate, $SubscriptionEndDate, $SubscriptionChargewithouttaxTotal, $SubTotal, $decimal_places);
                        $SubTotal = $addInvoiceSubscriptionDetail['SubTotal'];
                        $SubscriptionChargewithouttaxTotal = $addInvoiceSubscriptionDetail['SubscriptionChargewithouttaxTotal'];
                    } else if ($isAdvanceSubscription == 1 && $AlreadyBilled==0 && $AccountSubscription->EndDate >= $SubscriptionStartDate && $AccountSubscription->EndDate <= $SubscriptionEndDate) {
                        /** if advance subscription and expiring in current month
                         *Special Subscription with EndDate  '2015-08-01' to '2015-11-03'
                         * Advance charge for '1-11-2015' to '31-11-2015' should take '1-11-2015' to '03-11-2015'
                         */
                        Log::info('advance charge for next month expiring subscription.');
                        $SubscriptionEndDate = $AccountSubscription->EndDate;
                        $addInvoiceSubscriptionDetail = Invoice::addInvoiceSubscriptionDetail($Invoice, $AccountSubscription, $SubscriptionStartDate, $SubscriptionEndDate, $SubscriptionChargewithouttaxTotal, $SubTotal, $decimal_places);
                        $SubTotal = $addInvoiceSubscriptionDetail['SubTotal'];
                        $SubscriptionChargewithouttaxTotal = $addInvoiceSubscriptionDetail['SubscriptionChargewithouttaxTotal'];
                    } else if ($isAdvanceSubscription == 1 && $AlreadyBilled==0 && $SubscriptionStartDate >= $AccountSubscription->StartDate && $SubscriptionStartDate <= $AccountSubscription->EndDate && $SubscriptionEndDate >= $AccountSubscription->StartDate && $SubscriptionEndDate <= $AccountSubscription->EndDate) {
                        Log::info('regular Advance Subscription ');
                        //Charge Current Subscription Date
                        $addInvoiceSubscriptionDetail = Invoice::addInvoiceSubscriptionDetail($Invoice, $AccountSubscription, $SubscriptionStartDate, $SubscriptionEndDate, $SubscriptionChargewithouttaxTotal, $SubTotal, $decimal_places);
                        $SubTotal = $addInvoiceSubscriptionDetail['SubTotal'];
                        $SubscriptionChargewithouttaxTotal = $addInvoiceSubscriptionDetail['SubscriptionChargewithouttaxTotal'];
                    }
                }
                Log::info( " ============================Subscription End ================= \n\n");

            } // Subscription loop over



        } //Subscription over
        Log::info('SUBSCRIPTION Over');

        return array("SubTotal"=>$SubTotal,'SubscriptionChargewithouttaxTotal' => $SubscriptionChargewithouttaxTotal);
    }

    public static function addUsage($Account,$CompanyID, $AccountID,$LastInvoiceDate,$NextInvoiceDate,$StartDate,$EndDate,$InvoiceTemplate,$SubTotal,$decimal_places,$ServiceID,$FirstInvoiceSend,$OnlyUsageCallChares=0,$ProcessCallCharge=0){
        /**
         * Start Date = Last Invoice ChargeDate , End Date = Next Invoice ChargeDate
         */
        $UsageStartDate=$StartDate;
        $UsageEndDate=$EndDate;

        if($FirstInvoiceSend==1) {
            $TotalCharges = 0;
        }else{
            /**
             * IF InvoiceGeneration Date < InvoiceNextChargeDate
             * Than EndDate Is Yesterday Date
             */
            $NewLastChargeDate = date("Y-m-d", strtotime("+1 Day", strtotime($EndDate)));
            if($NewLastChargeDate>$NextInvoiceDate){
                Log::info('Charge In Advance Logic ');
                $UsageEndDate =  date("Y-m-d 23:59:59", strtotime( "-1 Day", strtotime($NextInvoiceDate)));
            }

            /**
             * We Need To Check Last UsageEndDate - if any mismatch than continue with that usagedate
             * Than StartDate Is LastUsageDate
             */

            if($ProcessCallCharge == 0) { // only for sendInvoice()
                // not need when generating total for future invoice (deduct call charges in advance)
                $UsageStartDate=Invoice::getAccountUsageStartDate($AccountID,$StartDate,$ServiceID);
            }
            if(isset($InvoiceTemplate->IgnoreCallCharge) && $InvoiceTemplate->IgnoreCallCharge==1 && $OnlyUsageCallChares==0){
                $TotalCharges = 0;
                Log::info('Invoice IgnoreCallCharge 1');
            } else{
                $TotalCharges = Invoice::getAccountUsageTotal($CompanyID, $AccountID, $UsageStartDate, $UsageEndDate, $ServiceID);
                Log::info('Invoice::getAccountUsageTotal(' . $CompanyID . ',' . $AccountID . ',' . $UsageStartDate . ',' . $UsageEndDate . ')');
            }
        }
        Log::info('TotalCharges - '.$TotalCharges) ;

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
        $InvoiceNumber = InvoiceTemplate::getNextInvoiceNumber(AccountBilling::getInvoiceTemplateID($AccountID,$ServiceID), $CompanyID);
        $Invoice = Invoice::insertInvoice(array(
            "CompanyID" => $CompanyID,
            "AccountID" => $AccountID,
            "ServiceID" => $ServiceID,
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
        InvoiceTemplate::find(AccountBilling::getInvoiceTemplateID($AccountID,$ServiceID))->update(array("LastInvoiceNumber" => $InvoiceNumber));

        if($FirstInvoiceSend==0) {
            /**
             * Add Usage in InvoiceDetail
             */
            $ProductDescription = " From " . date($InvoiceTemplate->DateFormat, strtotime($UsageStartDate)) . " To " . date($InvoiceTemplate->DateFormat, strtotime($UsageEndDate));
            $InvoiceDetailData = array();
            $InvoiceDetailData["InvoiceID"] = $Invoice->InvoiceID;
            $InvoiceDetailData['ProductID'] = 0;
            $InvoiceDetailData['ServiceID'] = $ServiceID;
            $InvoiceDetailData['ProductType'] = Product::USAGE;
            $InvoiceDetailData['Description'] = $ProductDescription;
            $InvoiceDetailData['StartDate'] = $UsageStartDate;
            $InvoiceDetailData['EndDate'] = $UsageEndDate;
            $InvoiceDetailData['Price'] = $TotalUsageCharges;
            $InvoiceDetailData['Qty'] = 1;
            $InvoiceDetailData['Discount'] = 0;
            $InvoiceDetailData['LineTotal'] = $TotalUsageCharges;
            $InvoiceDetailData["created_at"] = date("Y-m-d H:i:s");
            $InvoiceDetailData["CreatedBy"] = 'RMScheduler';
            InvoiceDetail::insert($InvoiceDetailData);

            $BillingType = AccountBilling::getBillingType($AccountID);
            $AccountBilling = AccountBilling::getBilling($AccountID,$ServiceID);
            $BillingCycleType = $AccountBilling->BillingCycleType;
            if($BillingType == AccountBilling::BILLINGTYPE_PREPAID && $BillingCycleType != 'manual'){
                $InvoiceStartDate = date("Y-m-d", strtotime( "+1 Day",strtotime($EndDate)));
                $InvoiceEndDate = date("Y-m-d", strtotime( "-1 Day",strtotime(next_billing_date($AccountBilling->BillingCycleType, $AccountBilling->BillingCycleValue, strtotime($InvoiceStartDate)))));
            }else{
                $InvoiceStartDate = $StartDate;
                $InvoiceEndDate = $EndDate;
            }
        }else{
            $InvoiceStartDate = date("Y-m-d", strtotime($StartDate));
            $InvoiceEndDate   = date("Y-m-d", strtotime($StartDate));

            $InvoiceDetailData = array();
            $InvoiceDetailData["InvoiceID"] = $Invoice->InvoiceID;
            $InvoiceDetailData['ProductID'] = 0;
            $InvoiceDetailData['ServiceID'] = $ServiceID;
            $InvoiceDetailData['ProductType'] = Product::FIRST_PERIOD;
            $InvoiceDetailData['Description'] = 'First Invoice';
            $InvoiceDetailData['StartDate'] = $InvoiceStartDate;
            $InvoiceDetailData['EndDate'] = $InvoiceEndDate;
            $InvoiceDetailData['Price'] = 0;
            $InvoiceDetailData['Qty'] = 0;
            $InvoiceDetailData['Discount'] = 0;
            $InvoiceDetailData['LineTotal'] = 0;
            $InvoiceDetailData["created_at"] = date("Y-m-d H:i:s");
            $InvoiceDetailData["CreatedBy"] = 'RMScheduler';
            InvoiceDetail::insert($InvoiceDetailData);

            $AccountBilling = AccountBilling::getBilling($AccountID,$ServiceID);
            $InvoiceStartDate = $EndDate;
            $checkDate = date("Y-m-d", strtotime( "+1 Day",strtotime($EndDate)));
            $InvoiceEndDate = date("Y-m-d", strtotime( "-1 Day",strtotime(next_billing_date($AccountBilling->BillingCycleType, $AccountBilling->BillingCycleValue, strtotime($checkDate)))));

        }

        $InvoiceDetailData = array();
        $InvoiceDetailData["InvoiceID"] = $Invoice->InvoiceID;
        $InvoiceDetailData['ProductID'] = 0;
        $InvoiceDetailData['ServiceID'] = $ServiceID;
        $InvoiceDetailData['ProductType'] = Product::INVOICE_PERIOD;
        $InvoiceDetailData['Description'] = 'Invoice Period';
        $InvoiceDetailData['StartDate'] = $InvoiceStartDate;
        $InvoiceDetailData['EndDate'] = $InvoiceEndDate;
        $InvoiceDetailData['Price'] = 0;
        $InvoiceDetailData['Qty'] = 0;
        $InvoiceDetailData['Discount'] = 0;
        $InvoiceDetailData['LineTotal'] = 0;
        $InvoiceDetailData["created_at"] = date("Y-m-d H:i:s");
        $InvoiceDetailData["CreatedBy"] = 'RMScheduler';
        InvoiceDetail::insert($InvoiceDetailData);

        InvoiceHistory::addInvoiceHistoryDetail($Invoice->InvoiceID,$AccountID,$ServiceID,$FirstInvoiceSend,0);

        return array("SubTotal"=>$SubTotal,'Invoice' => $Invoice);

    }
    public static function addInvoiceSubscriptionDetail($Invoice,$AccountSubscription,$SubscriptionStartDate,$SubscriptionEndDate,$SubscriptionChargewithouttaxTotal,$SubTotal,$decimal_places){
        //if (!Invoice::checkIfAccountSubscriptionAlreadyBilled($Invoice->InvoiceID,$Invoice->CompanyID, $Invoice->AccountID, $AccountSubscription->SubscriptionID, $SubscriptionStartDate, $SubscriptionEndDate)  ) {

        /** Check if running first time having old subscriber customers.
         * which add activation fee in Total Amount.
         * */
        if (AccountSubscription::checkFirstTimeBilling($AccountSubscription->StartDate,$SubscriptionStartDate)) {
            $FirstTime = true;
            log::info('First Time True '.$AccountSubscription->StartDate.' '.$SubscriptionStartDate);
        } else {
            $FirstTime = false;
            log::info('First Time False '.$AccountSubscription->StartDate.' '.$SubscriptionStartDate);
        }

        Log::info('StartDate '. $SubscriptionStartDate .' AccountSubscription->StartDate '. $AccountSubscription->StartDate .' EndDate '. $SubscriptionEndDate .' AccountSubscription->EndDate '.$AccountSubscription->EndDate);
        $BillingCycleType = InvoiceHistory::where(["InvoiceID"=>$Invoice->InvoiceID,"AccountID"=>$Invoice->AccountID,"ServiceID"=>$Invoice->ServiceID])->pluck('BillingCycleType');
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
        $ProductDescription = $AccountSubscription->InvoiceDescription;
        //$Subscription = BillingSubscription::find($AccountSubscription->SubscriptionID);
        $Subscription = AccountSubscription::find($AccountSubscription->AccountSubscriptionID);

        /**
         * Checking Already Subscription Added or not
         */

        $AlreadyInvoiceSubscription=Invoice::IsAlreadyInvoiceSubscriptionDetail($Invoice->AccountID,$AccountSubscription->ServiceID,$AccountSubscription->SubscriptionID,$SubscriptionStartDate,$SubscriptionEndDate,$ProductDescription,$TotalSubscriptionCharge,$SubscriptionCharge,$qty,$AccountSubscription->AccountSubscriptionID);

        log::info('Already Invoice Subscription '. $AlreadyInvoiceSubscription);
        Log::info('Invoice::IsAlreadyInvoiceSubscriptionDetail('.$Invoice->AccountID. ',' .$AccountSubscription->ServiceID. ',' .$AccountSubscription->SubscriptionID. ',' .$SubscriptionStartDate. ',' .$SubscriptionEndDate. ',' .$ProductDescription. ',' .$TotalSubscriptionCharge. ','.$SubscriptionCharge. ','.$qty.','.$AccountSubscription->AccountSubscriptionID.')');

        log::info('DiscountAmount '.$Subscription->DiscountAmount);
        log::info('DiscountType '.$Subscription->DiscountType);
        log::info('SubscriptionCharge '.$TotalSubscriptionCharge);
        $DiscountLineAmount = 0;
        if(!empty($Subscription->DiscountAmount) && !empty($Subscription->DiscountType)){
            if($Subscription->DiscountType=='Percentage'){
                $DiscountLineAmount =  (($TotalSubscriptionCharge * $Subscription->DiscountAmount) / 100);
                $TotalSubscriptionCharge = $TotalSubscriptionCharge - $DiscountLineAmount;
            }
            if($Subscription->DiscountType=='Flat'){
                $DiscountLineAmount = $Subscription->DiscountAmount;
                $TotalSubscriptionCharge = $TotalSubscriptionCharge - $DiscountLineAmount;
            }
        }
        log::info('New SubscriptionCharge '.$TotalSubscriptionCharge);

        if($AlreadyInvoiceSubscription==0){
            if($AccountSubscription->ExemptTax){
                $SubscriptionChargewithouttaxTotal += $TotalSubscriptionCharge;
            }else{
                $SubTotal += $TotalSubscriptionCharge;
            }
        }

        $SubscriptionCharge = number_format($SubscriptionCharge, $decimal_places, '.', '');
        $TotalSubscriptionCharge = number_format($TotalSubscriptionCharge, $decimal_places, '.', '');

        Log::info( ' TotalSubscriptionCharge - ' . $TotalSubscriptionCharge );

        if ($FirstTime && $Subscription->ActivationFee >0) {
            $ActivationProductDescription=$ProductDescription.' Activation Fee';
            $TotalActivationFeeCharge = ( $Subscription->ActivationFee * $qty );
            $AlreadyActivationFee=Invoice::IsAlreadyInvoiceSubscriptionDetail($Invoice->AccountID,$AccountSubscription->ServiceID,$AccountSubscription->SubscriptionID,$SubscriptionStartDate,$SubscriptionEndDate,$ActivationProductDescription,$TotalActivationFeeCharge,$Subscription->ActivationFee,$qty,$AccountSubscription->AccountSubscriptionID);
            log::info('Already Activatiob Fee '. $AlreadyActivationFee);
            Log::info('Invoice::IsAlreadyInvoiceSubscriptionDetail('.$Invoice->AccountID.','.$AccountSubscription->ServiceID.','.$AccountSubscription->SubscriptionID.','.$SubscriptionStartDate.','.$SubscriptionEndDate.','.$ActivationProductDescription.','.$TotalActivationFeeCharge.','.$Subscription->ActivationFee.','.$qty.','.$AccountSubscription->AccountSubscriptionID.')');
            if($AlreadyActivationFee==0) {
                if ($AccountSubscription->ExemptTax) {
                    $SubscriptionChargewithouttaxTotal += $TotalActivationFeeCharge;
                } else {
                    $SubTotal += $TotalActivationFeeCharge;
                }
                $InvoiceDetailData = array();
                $InvoiceDetailData["InvoiceID"] = $Invoice->InvoiceID;
                $InvoiceDetailData['ProductID'] = $AccountSubscription->SubscriptionID;
                $InvoiceDetailData['ServiceID'] = $AccountSubscription->ServiceID;
                $InvoiceDetailData['ProductType'] = Product::SUBSCRIPTION;
                $InvoiceDetailData['Description'] = $ActivationProductDescription;
                $InvoiceDetailData['StartDate'] = $SubscriptionStartDate;
                $InvoiceDetailData['EndDate'] = $SubscriptionEndDate;
                $InvoiceDetailData['Price'] = $Subscription->ActivationFee;
                $InvoiceDetailData['Qty'] = $qty;
                $InvoiceDetailData['Discount'] = 0;
                $InvoiceDetailData['LineTotal'] = $TotalActivationFeeCharge;
                $InvoiceDetailData['AccountSubscriptionID'] = $AccountSubscription->AccountSubscriptionID;
                $InvoiceDetailData["created_at"] = date("Y-m-d H:i:s");
                $InvoiceDetailData["CreatedBy"] = 'RMScheduler';
                InvoiceDetail::insert($InvoiceDetailData);
            }
        }
        //$ProductDescription .= " From " . date($InvoiceTemplate->DateFormat, strtotime($SubscriptionStartDate)) . " To " . date($InvoiceTemplate->DateFormat, strtotime($SubscriptionEndDate));
        if($AlreadyInvoiceSubscription==0) {
            $InvoiceDetailData = array();
            $InvoiceDetailData["InvoiceID"] = $Invoice->InvoiceID;
            $InvoiceDetailData['ProductID'] = $AccountSubscription->SubscriptionID;
            $InvoiceDetailData['ServiceID'] = $AccountSubscription->ServiceID;
            $InvoiceDetailData['ProductType'] = Product::SUBSCRIPTION;
            $InvoiceDetailData['Description'] = $ProductDescription;
            $InvoiceDetailData['StartDate'] = $SubscriptionStartDate;
            $InvoiceDetailData['EndDate'] = $SubscriptionEndDate;
            $InvoiceDetailData['Price'] = $SubscriptionCharge;
            $InvoiceDetailData['Qty'] = $qty;
            $InvoiceDetailData['Discount'] = 0;
            $InvoiceDetailData['LineTotal'] = $TotalSubscriptionCharge;
            $InvoiceDetailData['AccountSubscriptionID'] = $AccountSubscription->AccountSubscriptionID;
            $InvoiceDetailData["created_at"] = date("Y-m-d H:i:s");
            $InvoiceDetailData["CreatedBy"] = 'RMScheduler';
            if(!empty($Subscription->DiscountAmount) && !empty($Subscription->DiscountType)){
                $InvoiceDetailData['DiscountAmount'] = $Subscription->DiscountAmount;
                $InvoiceDetailData['DiscountType'] = $Subscription->DiscountType;
            }
            $InvoiceDetailData["DiscountLineAmount"] = $DiscountLineAmount;

            InvoiceDetail::insert($InvoiceDetailData);
        }
        return array("SubTotal"=>$SubTotal,'SubscriptionChargewithouttaxTotal' => $SubscriptionChargewithouttaxTotal);

        //}
    }
    public static function addOneOffTaxCharge($InvoiceID,$AccountID,$ServiceID){
        // new logic start
        $AdditionalChargeTotalTax = 0;
        $InvoiceDetails = InvoiceDetail::where("InvoiceID",$InvoiceID)->where("ProductType",Product::ONEOFFCHARGE)->get();
        if(!empty($InvoiceDetails)) {
            foreach ($InvoiceDetails as $InvoiceDetail) {
                $AccountOneOffCharge = AccountOneOffCharge::where(['AccountID'=>$AccountID,'AccountOneOffChargeID'=>$InvoiceDetail->AccountOneOffChargeID])->first();
                if(!empty($AccountOneOffCharge)){
                    $LineTotal = $InvoiceDetail->LineTotal;
                    if ($AccountOneOffCharge->TaxRateID || $AccountOneOffCharge->TaxRateID2) {
                        InvoiceTaxRate::where(['InvoiceID' => $InvoiceID,'InvoiceDetailID' => $InvoiceDetail->InvoiceDetailID])->delete();
                        if ($AccountOneOffCharge->TaxRateID) {
                            $TaxRate = TaxRate::where("TaxRateID", $AccountOneOffCharge->TaxRateID)->first();
                            $TotalTax = Invoice::calculateTotalTaxByTaxRateObj($TaxRate, $LineTotal);
                            $AdditionalChargeTotalTax += $TotalTax;
                            InvoiceTaxRate::create(array(
                                "InvoiceDetailID"=>$InvoiceDetail->InvoiceDetailID,
                                "InvoiceID" => $InvoiceID,
                                "TaxRateID" => $AccountOneOffCharge->TaxRateID,
                                "TaxAmount" => $TotalTax,
                                "Title" => $TaxRate->Title,
                            ));
                        }
                        if ($AccountOneOffCharge->TaxRateID2) {
                            $TaxRate = TaxRate::where("TaxRateID", $AccountOneOffCharge->TaxRateID2)->first();
                            $TotalTax = Invoice::calculateTotalTaxByTaxRateObj($TaxRate, $LineTotal);
                            $AdditionalChargeTotalTax += $TotalTax;
                            InvoiceTaxRate::create(array(
                                "InvoiceDetailID"=>$InvoiceDetail->InvoiceDetailID,//Invoidedetail
                                "InvoiceID" => $InvoiceID,
                                "TaxRateID" => $AccountOneOffCharge->TaxRateID2,
                                "TaxAmount" => $TotalTax,
                                "Title" => $TaxRate->Title,
                            ));
                        }

                    }
                }
            }
        }
        // new logic end
        Log::info('AccountOneOffCharge Tax Over');

        return $AdditionalChargeTotalTax;

    }
    public static function addOneOffCharge($Invoice,$ServiceID,$StartDate,$EndDate,$SubTotal,$decimal_places,$regenerate = 0,$FirstInvoiceSend=0){
        if($FirstInvoiceSend==1){
            $StartDate = date("Y-m-d",strtotime($StartDate));
            $EndDate = Invoice::getNextDateFirstInvoice($Invoice->InvoiceID,$Invoice->CompanyID, $Invoice->AccountID, $ServiceID); /** End Date Change for advance One off(first time)*/
            $EndDate =  date("Y-m-d 23:59:59", strtotime($EndDate));
        }else{
            $EndDate =  date("Y-m-d 23:59:59", strtotime( "+1 Day", strtotime($EndDate))); // for invoice generation day include
        }

        $query = "CALL prc_getAccountOneOffCharge(?,?,?,?)";
        $AccountOneOffCharges = DB::connection('sqlsrv2')->select($query,array($Invoice->AccountID,$ServiceID,$StartDate,$EndDate));
        Log::info("Call prc_getAccountOneOffCharge($Invoice->AccountID,$ServiceID,$StartDate,$EndDate)") ;
        $SubscriptionChargewithouttaxTotal = 0;
        $AdditionalChargeTotalTax = 0;
        Log::info('AccountOneOffCharge '.count($AccountOneOffCharges)) ;
        if($regenerate == 1) {
            InvoiceDetail::where(array('InvoiceID'=>$Invoice->InvoiceID,'ProductType'=>Product::ONEOFFCHARGE))->delete();
        }
        if (count($AccountOneOffCharges)) {
            foreach ($AccountOneOffCharges as $AccountOneOffCharge) {
                // in future we will use AccountOneOffChargeID
                $OneOffcount = InvoiceDetail::Join('tblInvoice','tblInvoiceDetail.InvoiceID','=','tblInvoice.InvoiceID')
                    ->where(['ProductID'=>$AccountOneOffCharge->ProductID,'StartDate'=>$AccountOneOffCharge->Date,'EndDate'=>$AccountOneOffCharge->Date,'ProductType'=>Product::ONEOFFCHARGE,'tblInvoiceDetail.ServiceID'=>$AccountOneOffCharge->ServiceID,'tblInvoiceDetail.Description'=>$AccountOneOffCharge->Description,'tblInvoiceDetail.Price'=>$AccountOneOffCharge->Price,'tblInvoiceDetail.Qty'=>$AccountOneOffCharge->Qty])
                    ->where(['tblInvoice.AccountID'=>$Invoice->AccountID])
                    ->count();

                Log::info(' AccountOneOffChargeID - ' . $AccountOneOffCharge->AccountOneOffChargeID);

                Log::info(' AccountOneOffChargeID - ' . $AccountOneOffCharge->Date);
                if($OneOffcount==0) {
                    $ProductDescription = $AccountOneOffCharge->Description;
                    $singlePrice = $AccountOneOffCharge->Price;
                    $LineTotal = ($AccountOneOffCharge->Price) * $AccountOneOffCharge->Qty;
                    if ($AccountOneOffCharge->TaxRateID || $AccountOneOffCharge->TaxRateID2) {
                        $AdditionalChargeTotalTax += $AccountOneOffCharge->TaxAmount;
                        Log::info(' TaxAmount - ' . $AccountOneOffCharge->TaxAmount);
                    }
                    log::info('AccountOneOffCharge DiscountAmount '.$AccountOneOffCharge->DiscountAmount);
                    log::info('AccountOneOffCharge DiscountType '.$AccountOneOffCharge->DiscountType);
                    log::info('AccountOneOffCharge LineTotal '.$LineTotal);
                    $DiscountLineAmount = 0;
                    if(!empty($AccountOneOffCharge->DiscountAmount) && !empty($AccountOneOffCharge->DiscountType)){
                        if($AccountOneOffCharge->DiscountType=='Percentage'){
                            $DiscountLineAmount =  (($LineTotal * $AccountOneOffCharge->DiscountAmount) / 100);
                            $LineTotal = $LineTotal - $DiscountLineAmount;
                            $SubscriptionChargewithouttaxTotal += $LineTotal;
                        }
                        if($AccountOneOffCharge->DiscountType=='Flat'){
                            $DiscountLineAmount = $AccountOneOffCharge->DiscountAmount;
                            $LineTotal = $LineTotal - $DiscountLineAmount;
                            $SubscriptionChargewithouttaxTotal += $LineTotal;
                        }
                    }
                    log::info('New LineTotal '.$LineTotal);

                    $singlePrice = number_format($singlePrice, $decimal_places, '.', '');
                    $LineTotal = number_format($LineTotal, $decimal_places, '.', '');
                    $InvoiceDetailData = array();
                    $InvoiceDetailData["InvoiceID"] = $Invoice->InvoiceID;
                    $InvoiceDetailData['ProductID'] = $AccountOneOffCharge->ProductID;
                    $InvoiceDetailData['ServiceID'] = $AccountOneOffCharge->ServiceID;
                    $InvoiceDetailData['ProductType'] = Product::ONEOFFCHARGE;
                    $InvoiceDetailData['Description'] = $ProductDescription;
                    $InvoiceDetailData['StartDate'] = $AccountOneOffCharge->Date;
                    $InvoiceDetailData['EndDate'] = $AccountOneOffCharge->Date;
                    $InvoiceDetailData['Price'] = $singlePrice;
                    $InvoiceDetailData['Qty'] = $AccountOneOffCharge->Qty;
                    $InvoiceDetailData['Discount'] = 0;
                    $InvoiceDetailData['LineTotal'] = $LineTotal;
                    $InvoiceDetailData["created_at"] = date("Y-m-d H:i:s");
                    $InvoiceDetailData["CreatedBy"] = 'RMScheduler';
                    $InvoiceDetailData["AccountOneOffChargeID"] = $AccountOneOffCharge->AccountOneOffChargeID;
                    if(!empty($AccountOneOffCharge->DiscountAmount) && !empty($AccountOneOffCharge->DiscountType)){
                        $InvoiceDetailData['DiscountAmount'] = $AccountOneOffCharge->DiscountAmount;
                        $InvoiceDetailData['DiscountType'] = $AccountOneOffCharge->DiscountType;
                    }
                    $InvoiceDetailData["DiscountLineAmount"] = $DiscountLineAmount;
                    InvoiceDetail::insert($InvoiceDetailData);
                }
            }
        } //Subscription over
        Log::info('AccountOneOffCharge Over');

        return array("SubTotal"=>$SubTotal,'SubscriptionChargewithouttaxTotal' => $SubscriptionChargewithouttaxTotal,'AdditionalChargeTotalTax'=>$AdditionalChargeTotalTax);

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

    public static function GenerateInvoice($CompanyID,$InvoiceGenerationEmail,$ProcessID, $JobID,$SingleInvoice)
    {
        $skip_accounts = array();
        $today = date("Y-m-d");
        $response = $errors = $message = array();
        $count=0;

        do {
            $query = "CALL prc_getBillingAccounts(?,?,?,?)";
            $Accounts = DB::select($query,array($CompanyID,$today,implode(',',$skip_accounts),$SingleInvoice));
            Log::info("Call prc_getBillingAccounts($CompanyID,$today,'".implode(',',$skip_accounts)."','".$SingleInvoice."')");
            log::info(print_r($Accounts,true));
            $Accounts = json_decode(json_encode($Accounts),true);

            foreach ($Accounts as $Account) {

                $AccountName = $Account['AccountName'];
                $AccountID = $Account['AccountID'];
                $ServiceID = $Account['ServiceID'];
                try {
                    $FirstInvoice = Invoice::isFirstInvoiceSend($CompanyID,$AccountID,$ServiceID);

                    $AccountBillings = AccountBilling::getBilling($AccountID, $ServiceID);
                    $LastChargeDate = $AccountBillings->LastChargeDate;
                    $NextChargeDate = $AccountBillings->NextChargeDate;

                    if($FirstInvoice==1){
                        $NextInvoiceDate = Invoice::getFirstInvoiceDate($CompanyID,$AccountID,$ServiceID);
                        $LastInvoiceDate = $AccountBillings->BillingStartDate;
                    }else{
                        /*
                        $NextInvoiceDate = Invoice::getNextInvoiceDate($CompanyID, $AccountID, $ServiceID);
                        $LastInvoiceDate = Invoice::getLastInvoiceDate($CompanyID, $AccountID, $ServiceID);
                        */
                        $LastInvoiceDate = $AccountBillings->LastInvoiceDate;
                        $NextInvoiceDate = $AccountBillings->NextInvoiceDate;

                    }

                    Log::info('AccountID =' . $AccountID . ' FirstInvoiceSend '.$FirstInvoice);
                    Log::info('LastInvoiceDate '.$LastInvoiceDate.' NextInvoiceDate '.$NextInvoiceDate);
                    Log::info('LastChargeDate '.$LastChargeDate.' NextChargeDate '.$NextChargeDate);

                    $BillingCycleType = $AccountBillings->BillingCycleType;

                    if (!empty($NextInvoiceDate) && $BillingCycleType != 'manual') {

                        $EndDate = date("Y-m-d", strtotime("-1 Day", strtotime($NextInvoiceDate)));

                        //@todo: Need to check checkCDRIsLoadedOrNot.

                        /**
                         * 1. If Account is not in tblAccountGateway Generate Invoice
                         * 2. If Account is present check **cdr download log** end date > $EndDate (1-11-2015 > 31-10-2015)
                         * 3. If no calling in CDR then also log is generated so checking in log only. not in tblUsageDetails so if customer is
                         * not sending any traffic then also 0 value invoice is generated.
                         * */
                        $isCDRLoaded = DB::connection('sqlsrv2')->select("CALL prc_checkCDRIsLoadedOrNot(" . (int)$AccountID . ",$CompanyID,'$EndDate')");

                        Log::info('isCDRLoaded ' . print_r($isCDRLoaded, true));

                        if (strtotime($NextInvoiceDate) <= strtotime(date("Y-m-d"))) {

                            if (isset($isCDRLoaded[0]->isLoaded) && $isCDRLoaded[0]->isLoaded == 1) {

                                Log::info(' ========================== Invoice Send Start =============================');


                                DB::beginTransaction();
                                DB::connection('sqlsrv2')->beginTransaction();

                                /*                    $StartDate = $LastInvoiceDate;
                                                    $EndDate = date("Y-m-d 23:59:59", strtotime("-1 Day", strtotime($NextInvoiceDate)));*/

                                Log::info('Invoice::sendInvoice(' . $CompanyID . ',' . $AccountID . ',' . $LastInvoiceDate . ',' . $NextInvoiceDate . ',' . implode(",", $InvoiceGenerationEmail) . ')');
                                $response = Invoice::sendInvoice($CompanyID, $AccountID, $LastInvoiceDate, $NextInvoiceDate, $InvoiceGenerationEmail, $ProcessID, $JobID,$ServiceID,0);

                                Log::info('Invoice::sendInvoice done');

                                if (isset($response["status"]) && $response["status"] == 'success') {

                                    Log::info('Invoice created - ' . print_r($response, true));
                                    $message[] = $response["message"];
                                    Log::info('Invoice Committed  AccountID = ' . $AccountID);
                                    DB::connection('sqlsrv2')->commit();
                                    Log::info('=========== Updating  InvoiceDate =========== ');
                                    $AccountBilling = AccountBilling::getBilling($AccountID, $ServiceID);
                                    $oldNextInvoiceDate = $NextInvoiceDate;
                                    //Add One Date In Last Charge Date because when we next period(Last Charge Date - Next Charge)Both Date include
                                    if($FirstInvoice==1) {
                                        $CheckBillingStartDate = date("Y-m-d", strtotime($AccountBilling->BillingStartDate));
                                        $NewLastChargeDate = date("Y-m-d", strtotime($AccountBilling->NextChargeDate));
                                        if($NewLastChargeDate!=$CheckBillingStartDate){
                                            $CheckChargeDate=date("Y-m-d", strtotime("+1 Day", strtotime($AccountBilling->NextChargeDate)));
                                            $NewNextChargeDate=next_billing_date($AccountBilling->BillingCycleType, $AccountBilling->BillingCycleValue, strtotime($CheckChargeDate));
                                        }else{
                                            $NewNextChargeDate=next_billing_date($AccountBilling->BillingCycleType, $AccountBilling->BillingCycleValue, strtotime($AccountBilling->NextChargeDate));
                                        }

                                        $NewNextChargeDate = date("Y-m-d", strtotime("-1 Day", strtotime($NewNextChargeDate)));
                                        log::info('FirstInvoice '.$NewLastChargeDate.' '.$NewNextChargeDate);
                                    }else{
                                        $NewLastChargeDate = date("Y-m-d", strtotime("+1 Day", strtotime($AccountBilling->NextChargeDate)));
                                        $NewNextChargeDate=next_billing_date($AccountBilling->BillingCycleType, $AccountBilling->BillingCycleValue, strtotime($NewLastChargeDate));
                                        $NewNextChargeDate = date("Y-m-d", strtotime("-1 Day", strtotime($NewNextChargeDate)));
                                        log::info('NextInvoice '.$NewLastChargeDate.' '.$NewNextChargeDate);
                                    }

                                    $NewNextInvoiceDate = next_billing_date($AccountBilling->BillingCycleType, $AccountBilling->BillingCycleValue, strtotime($oldNextInvoiceDate));
                                    AccountBilling::where(['AccountID' => $AccountID, 'ServiceID' => $ServiceID])->update(["LastInvoiceDate" => $oldNextInvoiceDate, "NextInvoiceDate" => $NewNextInvoiceDate,'LastChargeDate'=>$NewLastChargeDate,'NextChargeDate'=>$NewNextChargeDate]);
                                    $AccountNextBilling = AccountNextBilling::getBilling($AccountID, $ServiceID);
                                    if (!empty($AccountNextBilling)) {
                                        AccountBilling::where(['AccountID' => $AccountID, 'ServiceID' => $ServiceID])->update(["BillingCycleType" => $AccountNextBilling->BillingCycleType, "BillingCycleValue" => $AccountNextBilling->BillingCycleValue, 'LastInvoiceDate' => $AccountNextBilling->LastInvoiceDate, 'NextInvoiceDate' => $AccountNextBilling->NextInvoiceDate]);
                                        AccountNextBilling::where(['AccountID' => $AccountID, 'ServiceID' => $ServiceID])->delete();
                                    }
                                    log::info("new dates");
                                    Log::info('LastInvoiceDate '.$oldNextInvoiceDate.' NextInvoiceDate '.$NewNextInvoiceDate);
                                    Log::info('LastChargeDate '.$NewLastChargeDate.' NextChargeDate '.$NewNextChargeDate);

                                    Log::info('=========== Updated  InvoiceDate =========== ');
                                    DB::commit();

                                } else {
                                    $errors[] = $response["message"];
                                    DB::rollback();
                                    DB::connection('sqlsrv2')->rollback();
                                    $skip_accounts[] = $AccountID;
                                    Log::info('Invoice rollback  AccountID = ' . $AccountID);
                                    Log::info(' ========================== Error  =============================');
                                    Log::info('Invoice with Error - ' . print_r($response, true));

                                }

                            } else {
                                $errors[] = $AccountName . " " . Invoice::$InvoiceGenrationErrorReasons["NoCDR"];
                                $skip_accounts[] = $AccountID;
                                continue;
                            }
                        } else {
                            $skip_accounts[] = $AccountID;
                        }

                    } else {
                        $skip_accounts[] = $AccountID;
                    }

                    Log::info(' ========================== Invoice Send End =============================');

                } catch (\Exception $e) {

                    try {
                        $skip_accounts[] = $AccountID;
                        Log::error('Invoice Rollback AccountID = ' . $AccountID);
                        DB::rollback();
                        DB::connection('sqlsrv2')->rollback();
                        Log::error($e);

                        $errors[] = $AccountName . " " . $e->getMessage();


                    } catch (Exception $err) {
                        Log::error($err);
                        $errors[] = $AccountName . " " . $e->getMessage() . ' ## ' . $err->getMessage();
                    }

                }
            } // Loop over
            //Log::info($skip_accounts);
            //Break; //if generate only one invoice per account
        } while (count(DB::select($query,array($CompanyID,$today,implode(',',$skip_accounts),$SingleInvoice))));


        $response['errors'] = $errors;
        $response['message'] = $message;
        return $response;
    }

    public static function getInvoiceServiceUsage($CompanyID,$AccountID,$ServiceID,$start_date,$end_date,$InvoiceTemplate){

        $usage_data = array();
        $ShowZeroCall = 1;
        //$GatewayAccount = GatewayAccount::where(array('AccountID' => $AccountID))->distinct()->get(['CompanyGatewayID']);
        $IsReseller = Account::where(array('AccountID'=>$AccountID))->pluck('IsReseller');
        if(empty($IsReseller)){
            Log::info('Reseller ==> 0');
            $GatewayAccount =  GatewayAccount::where(array('AccountID'=>$AccountID))->distinct()->get(['CompanyGatewayID']);
        }else{
            Log::info('Reseller ==> 1');
            $GatewayAccount =  CompanyGateway::where(array('Status'=>1))->get(['CompanyGatewayID']);
        }
        $AccountBilling = AccountBilling::getBillingClass($AccountID,$ServiceID);
        if(!empty($AccountBilling) && isset($AccountBilling->InvoiceTemplateID)) {
            $InvoiceTemplate = InvoiceTemplate::find($AccountBilling->InvoiceTemplateID);
            if (!empty($InvoiceTemplate) && isset($InvoiceTemplate->ShowZeroCall)) {
                $ShowZeroCall = intval($InvoiceTemplate->ShowZeroCall);
            }
        }
        $UsageColumn = getUsageColumns($InvoiceTemplate);
        $activeColumns = array();
        $GroupColumns = array('Trunk','Country','AreaPrefix','Description','AvgRatePerMin');
        foreach($UsageColumn as $UsageColumnRow){
            if($UsageColumnRow['Status']=='true') {
                $activeColumns[] = $UsageColumnRow['Title'];

            }
        }
        $activeColumns = array_intersect($activeColumns,$GroupColumns);

        $RoundChargesCDR    = AccountBilling::getRoundChargesCDR($AccountID,$ServiceID);

        foreach ($GatewayAccount as $GatewayAccountRow) {
            $GatewayAccountRow['CompanyGatewayID'];
            $BillingTimeZone = CompanyGateway::getGatewayBillingTimeZone($GatewayAccountRow['CompanyGatewayID']);
            $TimeZone = CompanyGateway::getGatewayTimeZone($GatewayAccountRow['CompanyGatewayID']);
            $AccountBillingTimeZone = Account::getBillingTimeZone($AccountID);
            if (!empty($AccountBillingTimeZone)) {
                $BillingTimeZone = $AccountBillingTimeZone;
            }
            $BillingStartDate = change_timezone($BillingTimeZone, $TimeZone, $start_date, $CompanyID);
            $BillingEndDate = change_timezone($BillingTimeZone, $TimeZone, $end_date, $CompanyID);
            Log::info('original start date ==>' . $start_date . ' changed start date ==>' . $BillingStartDate . ' original end date ==>' . $end_date . ' changed end date ==>' . $BillingEndDate);
            $query = "CALL prc_getInvoiceUsage(" . $CompanyID . ",'" . $AccountID . "','" . $ServiceID . "','".$GatewayAccountRow['CompanyGatewayID']."','" . $BillingStartDate . "','" . $BillingEndDate . "',".$ShowZeroCall.")";
            Log::info($query);
            $result_data = DB::connection('sqlsrv2')->select($query);
            $result_data = json_decode(json_encode($result_data), true);
            //$usage_data = $usage_data+json_decode(json_encode($result_data), true);
            foreach ($result_data as $result_row) {
                if (isset($result_row['AreaPrefix'])) {
                    $key_col_comb = '';
                    foreach($activeColumns as $activeColumn){
                        $key_col_comb .= $activeColumn.'##'.$result_row[$activeColumn].'##';
                    }
                    if($InvoiceTemplate->GroupByService){
                        $key_col_comb .= 'ServiceID##'.$result_row['ServiceID'].'##';
                    }
                    if (isset($usage_data[$key_col_comb])) {
                        $usage_data[$key_col_comb]['NoOfCalls'] += $result_row['NoOfCalls'];
                        $usage_data[$key_col_comb]['ChargedAmount'] += $result_row['ChargedAmount'];
                        $usage_data[$key_col_comb]['DurationInSec'] += $result_row['DurationInSec'];
                        $usage_data[$key_col_comb]['BillDurationInSec'] += $result_row['BillDurationInSec'];
                        $usage_data[$key_col_comb]['Duration'] = (int)($usage_data[$key_col_comb]['DurationInSec']/60).':'.$usage_data[$key_col_comb]['DurationInSec']%60;
                        $usage_data[$key_col_comb]['BillDuration'] = (int)($usage_data[$key_col_comb]['BillDurationInSec']/60).':'.$usage_data[$key_col_comb]['BillDurationInSec']%60;
                        if($usage_data[$key_col_comb]['BillDurationInSec'] != 0) {
                            $usage_data[$key_col_comb]['AvgRatePerMin'] = number_format($result_row['AvgRatePerMin'], 6);
                        }else{
                            $usage_data[$key_col_comb]['AvgRatePerMin'] = 0;
                        }
                    } else {
                        $usage_data[$key_col_comb] = $result_row;
                        $usage_data[$key_col_comb]['ChargedAmount'] = $usage_data[$key_col_comb]['ChargedAmount'];
                        if($usage_data[$key_col_comb]['BillDurationInSec'] != 0) {
                            $usage_data[$key_col_comb]['AvgRatePerMin'] = number_format($result_row['AvgRatePerMin'], 6);
                        }else{
                            $usage_data[$key_col_comb]['AvgRatePerMin'] = 0;
                        }
                    }
                } else {
                    $result_row['ChargedAmount'] = $result_row['ChargedAmount'];
                    $usage_data[] = $result_row;
                }
            }
        }
        return array_values($usage_data);
    }

    public static function create_accountdetails($Account){
        $replace_array = array();
        $replace_array['FirstName'] = $Account->FirstName;
        $replace_array['LastName'] = $Account->LastName;
        $replace_array['AccountName'] = $Account->AccountName;
        $replace_array['AccountNumber'] = $Account->Number;
        $replace_array['VatNumber'] = $Account->VatNumber;
        $replace_array['NominalCode'] = $Account->NominalAnalysisNominalAccountNumber;
        $replace_array['Email'] = $Account->Email;
        $replace_array['Address1'] = $Account->Address1;
        $replace_array['Address2'] = $Account->Address2;
        $replace_array['Address3'] = $Account->Address3;
        $replace_array['City'] = $Account->City;
        $replace_array['State'] = $Account->State;
        $replace_array['PostCode'] = $Account->PostCode;
        $replace_array['Country'] = $Account->Country;
        $replace_array['Phone'] = $Account->Phone;
        $replace_array['Fax'] = $Account->Fax;
        $replace_array['Website'] = $Account->Website;
        $replace_array['Currency'] = Currency::getCurrencyCode($Account->CurrencyId);
        $replace_array['CurrencySign'] = Currency::getCurrencySymbol($Account->CurrencyId);
        $replace_array['CompanyName'] = Company::getName($Account->CompanyId);
        $replace_array['CompanyVAT'] = Company::getCompanyField($Account->CompanyId,"VAT");
        $replace_array['CompanyAddress'] = Company::getCompanyFullAddress($Account->CompanyId);
        $replace_array['AccountBalance'] = $replace_array['CurrencySign'] ."". AccountBalance::getAccountBalance($Account->CompanyId,$Account->AccountID);


        return $replace_array;
    }


    public static function getInvoiceToByAccount($Message,$replace_array){
        $extra = [
            '{AccountName}',
            '{FirstName}',
            '{LastName}',
            '{AccountNumber}',
            '{VatNumber}',
            '{VatNumber}',
            '{NominalCode}',
            '{Phone}',
            '{Fax}',
            '{Website}',
            '{Email}',
            '{Address1}',
            '{Address2}',
            '{Address3}',
            '{City}',
            '{State}',
            '{PostCode}',
            '{Country}',
            '{Currency}',
            '{CompanyName}',
            '{CompanyVAT}',
            '{CompanyAddress}',
            '{AccountBalance}'
        ];

        foreach($extra as $item){
            $item_name = str_replace(array('{','}'),array('',''),$item);
            if(array_key_exists($item_name,$replace_array)) {
                $Message = str_replace($item,$replace_array[$item_name],$Message);
            }
        }
        return $Message;
    }

    public static function getServiceUsageTotal($usage_data){
        $service_usage_data = array();
        foreach($usage_data as $usage_data_row){
            $ServiceID = $usage_data_row['ServiceID'];
            if(isset($service_usage_data[$ServiceID])){
                $service_usage_data[$ServiceID]['usage_cost'] +=  $usage_data_row['ChargedAmount'];
            }else{
                $service_usage_data[$ServiceID]['usage_cost'] =  $usage_data_row['ChargedAmount'];
            }
        }
        return $service_usage_data;
    }
    public static function getServiceSubscriptionTotal($InvoiceDetail){
        $service_sub_data = array();
        foreach($InvoiceDetail as $InvoiceDetailRow){
            if($InvoiceDetailRow->ProductType == Product::SUBSCRIPTION) {
                $ServiceID = $InvoiceDetailRow->ServiceID;
                if (isset($service_sub_data[$ServiceID])) {
                    $service_sub_data[$ServiceID]['sub_cost'] += $InvoiceDetailRow->LineTotal;
                } else {
                    $service_sub_data[$ServiceID]['sub_cost'] = $InvoiceDetailRow->LineTotal;
                }
            }
        }
        return $service_sub_data;
    }

    public static function getServiceAdditionalTotal($InvoiceDetail){
        $service_add_data = array();
        foreach($InvoiceDetail as $InvoiceDetailRow){
            if($InvoiceDetailRow->ProductType == Product::ONEOFFCHARGE) {
                $ServiceID = $InvoiceDetailRow->ServiceID;
                if (isset($service_add_data[$ServiceID])) {
                    $service_add_data[$ServiceID]['add_cost'] += $InvoiceDetailRow->LineTotal;
                } else {
                    $service_add_data[$ServiceID]['add_cost'] = $InvoiceDetailRow->LineTotal;
                }
            }
        }
        return $service_add_data;
    }

    public static function getServiceData($AccountID,$ServiceID,$usage_data,$InvoiceDetail){
        $service_data = array();
        $service_usage_data = self::getServiceUsageTotal($usage_data);
        $service_sub_data = self::getServiceSubscriptionTotal($InvoiceDetail);
        $service_add_data = self::getServiceAdditionalTotal($InvoiceDetail);
        $query = "CALL prc_getAccountService(?,?)";
        $Accountservices = DB::select($query,array($AccountID,$ServiceID));


        /** service applied at account level*/
        foreach($Accountservices as $Accountservice){
            $Account_ServiceID = $Accountservice->ServiceID;
            if(isset($service_usage_data[$Account_ServiceID]) || isset($service_sub_data[$Account_ServiceID]) || isset($service_add_data[$Account_ServiceID])){
                if(isset($service_usage_data[$Account_ServiceID])){
                    $service_data[$Account_ServiceID]['usage_cost'] = $service_usage_data[$Account_ServiceID]['usage_cost'];
                }else{
                    $service_data[$Account_ServiceID]['usage_cost'] = 0;
                }
                if(isset($service_sub_data[$Account_ServiceID])){
                    $service_data[$Account_ServiceID]['sub_cost'] = $service_sub_data[$Account_ServiceID]['sub_cost'];
                }else{
                    $service_data[$Account_ServiceID]['sub_cost'] = 0;
                }
                if(isset($service_add_data[$Account_ServiceID])){
                    $service_data[$Account_ServiceID]['add_cost'] = $service_add_data[$Account_ServiceID]['add_cost'];
                }else{
                    $service_data[$Account_ServiceID]['add_cost'] = 0;
                }
                $service_data[$Account_ServiceID]['name'] = AccountService::getServiceName($AccountID, $Account_ServiceID);
                $service_data[$Account_ServiceID]['servicedescription'] = AccountService::getServiceDescription($AccountID, $Account_ServiceID);
                $service_data[$Account_ServiceID]['servicetitleshow'] = AccountService::getServiceTitleShow($AccountID, $Account_ServiceID);
            }
        }

        /** default service with name other */
        if(isset($service_usage_data[0]) || isset($service_sub_data[0]) || isset($service_add_data[0])){
            if(isset($service_usage_data[0])){
                $service_data[0]['usage_cost'] = $service_usage_data[0]['usage_cost'];
            }else{
                $service_data[0]['usage_cost'] = 0;
            }
            if(isset($service_sub_data[0])){
                $service_data[0]['sub_cost'] = $service_sub_data[0]['sub_cost'];
            }else{
                $service_data[0]['sub_cost'] = 0;
            }
            if(isset($service_add_data[0])){
                $service_data[0]['add_cost'] = $service_add_data[0]['add_cost'];
            }else{
                $service_data[0]['add_cost'] = 0;
            }
            $service_data[0]['name'] = Service::$defaultService;
            $service_data[0]['servicedescription'] = '';
            $service_data[0]['servicetitleshow'] = 1;

        }
        return $service_data;
    }

    public static function usageDataTable($usage_data,$InvoiceTemplate){
        $usage_data_table = array();
        $usage_data_table['header'] =array();
        $usage_data_table['data'] = array();
        $UsageColumn = getUsageColumns($InvoiceTemplate);
        if(count($usage_data)) {

            $order = array();
            foreach($UsageColumn as $UsageColumnRow){
                if($UsageColumnRow['Status']=='true') {
                    $order[] = $UsageColumnRow['Title'];
                    $usage_data_table['header'][] = $UsageColumnRow;
                }
            }
            $usage_data_table['order']=$order;
            foreach($usage_data as $row_key =>$usage_data_row){
                if (isset($usage_data_row['AreaPrefix'])) {
                    if($usage_data_row['BillDurationInSec'] != 0) {
                        $usage_data_row['AvgRatePerMin'] = number_format($usage_data_row['AvgRatePerMin'], 6);
                    }else{
                        $usage_data_row['AvgRatePerMin'] = 0;
                    }
                }
                $usage_data[$row_key] = array_replace(array_flip($order), $usage_data_row);
                $ServiceID = $usage_data[$row_key]['ServiceID'];
                if(isset($service_usage_data[$ServiceID])){
                    $usage_data_table['data'][$ServiceID][] =  $usage_data[$row_key];
                }else{
                    $usage_data_table['data'][$ServiceID][] =  $usage_data[$row_key];
                }
            }
        }
        return $usage_data_table;
    }

    public static function GenerateManualInvoice($CompanyID,$InvoiceGenerationEmail,$ProcessID, $JobID,$Options)
    {
        $ServiceID = 0;
        $AccountID = $Options['AccountID'];
        $Account = Account::find($AccountID);
        $AccountName = $Account['AccountName'];
        $LastInvoiceDate = $Options['PeriodFrom'];
        $NextInvoiceDate = $Options['PeriodTo'];
        $NextInvoiceDate =  date("Y-m-d", strtotime( "+1 Day", strtotime($NextInvoiceDate)));
        $response = $errors = $message = array();
        try {

            Log::info('AccountID =' . $AccountID . ' NextInvoiceDate = ' . $NextInvoiceDate);
            if (!empty($NextInvoiceDate) && strtotime($NextInvoiceDate) <= strtotime(date("Y-m-d"))) {
                $EndDate = date("Y-m-d", strtotime("-1 Day", strtotime($NextInvoiceDate)));
                /**
                 * 1. If Account is not in tblAccountGateway Generate Invoice
                 * 2. If Account is present check **cdr download log** end date > $EndDate (1-11-2015 > 31-10-2015)
                 * 3. If no calling in CDR then also log is generated so checking in log only. not in tblUsageDetails so if customer is
                 * not sending any traffic then also 0 value invoice is generated.
                 * */
                $isCDRLoaded = DB::connection('sqlsrv2')->select("CALL prc_checkCDRIsLoadedOrNot(" . (int)$AccountID . ",$CompanyID,'$EndDate')");
                Log::info('isCDRLoaded ' . print_r($isCDRLoaded, true));
                if (isset($isCDRLoaded[0]->isLoaded) && $isCDRLoaded[0]->isLoaded == 1) {

                    Log::info(' ========================== Invoice Send Start =============================');

                    DB::beginTransaction();
                    DB::connection('sqlsrv2')->beginTransaction();

                    Log::info('Invoice::sendInvoice(' . $CompanyID . ',' . $AccountID . ',' . $LastInvoiceDate . ',' . $NextInvoiceDate . ',' . implode(",", $InvoiceGenerationEmail) . ')');
                    $response = Invoice::sendInvoice($CompanyID, $AccountID, $LastInvoiceDate, $NextInvoiceDate, $InvoiceGenerationEmail, $ProcessID, $JobID, $ServiceID,1);
                    Log::info('Invoice::sendInvoice done');
                    if (isset($response["status"]) && $response["status"] == 'success') {

                        Log::info('Invoice created - ' . print_r($response, true));
                        $message[] = $response["message"];
                        Log::info('Invoice Committed  AccountID = ' . $AccountID);
                        DB::connection('sqlsrv2')->commit();
                        Log::info('=========== Updating  InvoiceDate =========== ');
                        $oldNextInvoiceDate = $NextInvoiceDate;
                        AccountBilling::where(['AccountID' => $AccountID, 'ServiceID' => $ServiceID])->update(["LastInvoiceDate" => $oldNextInvoiceDate]);
                        $AccountNextBilling = AccountNextBilling::getBilling($AccountID, $ServiceID);
                        if (!empty($AccountNextBilling)) {
                            AccountBilling::where(['AccountID' => $AccountID, 'ServiceID' => $ServiceID])->update(["BillingCycleType" => $AccountNextBilling->BillingCycleType, "BillingCycleValue" => $AccountNextBilling->BillingCycleValue, 'LastInvoiceDate' => $AccountNextBilling->LastInvoiceDate, 'NextInvoiceDate' => $AccountNextBilling->NextInvoiceDate]);
                            AccountNextBilling::where(['AccountID' => $AccountID, 'ServiceID' => $ServiceID])->delete();
                        }
                        Log::info('=========== Updated  InvoiceDate =========== ');
                        DB::commit();

                    } else {
                        $errors[] = $response["message"];
                        DB::rollback();
                        DB::connection('sqlsrv2')->rollback();
                        Log::info('Invoice rollback  AccountID = ' . $AccountID);
                        Log::info(' ========================== Error  =============================');
                        Log::info('Invoice with Error - ' . print_r($response, true));
                    }
                } else {
                    $errors[] = $AccountName . " " . Invoice::$InvoiceGenrationErrorReasons["NoCDR"];
                }
            }
            Log::info(' ========================== Invoice Send End =============================');
        } catch (\Exception $e) {

            try {

                Log::error('Invoice Rollback AccountID = ' . $AccountID);
                DB::rollback();
                DB::connection('sqlsrv2')->rollback();
                Log::error($e);
                $errors[] = $AccountName . " " . $e->getMessage();
            } catch (Exception $err) {
                Log::error($err);
                $errors[] = $AccountName . " " . $e->getMessage() . ' ## ' . $err->getMessage();
            }
        }

        $response['errors'] = $errors;
        $response['message'] = $message;
        return $response;
    }

    public static function NumberFormatNoZeroValue($value,$decimal_point) {
        $value=str_replace(',','',$value);
        $value2 = number_format($value,$decimal_point);
        $default_value = "0.000000";
        $result = $value2==0 && $value>0 ? (float) substr_replace($default_value,'1',$decimal_point+1) : $value2;
        return $result;
    }

    public static function getFirstInvoiceDate($CompanyID,$AccountID,$ServiceID){

        /**
         * Assumption : If Billing Cycle is 7 Days then Usage and Subscription both will be 7 Days and same for Monthly and other billing cycles..
         * */
        if(!empty($CompanyID) && !empty($AccountID) ) {

            $Account = AccountBilling::select(["NextInvoiceDate","BillingStartDate","LastInvoiceDate","BillingCycleType","BillingCycleValue"])->where(["AccountID"=>$AccountID,"ServiceID"=>$ServiceID])->first()->toArray();

            if(!empty($Account['BillingStartDate'])) {
                $BillingStartDate = strtotime($Account['BillingStartDate']);
            }else{
                return '';
            }
            $NextInvoiceDate = date("Y-m-d", $BillingStartDate);

            return $NextInvoiceDate;
        }

    }
    public static function getNextDateFirstInvoice($InvoiceID,$CompanyID,$AccountID,$ServiceID){

        /**
         * Assumption : If Billing Cycle is 7 Days then Usage and Subscription both will be 7 Days and same for Monthly and other billing cycles..
         * */
        if(!empty($CompanyID) && !empty($AccountID) ) {

            //$Account = AccountBilling::select(["NextInvoiceDate","BillingStartDate","LastInvoiceDate","BillingCycleType","BillingCycleValue","NextChargeDate"])->where(["AccountID"=>$AccountID,"ServiceID"=>$ServiceID])->first()->toArray();
            $Account=InvoiceHistory::select(["NextInvoiceDate","BillingStartDate","LastInvoiceDate","BillingCycleType","BillingCycleValue","NextChargeDate"])->where(["InvoiceID"=>$InvoiceID,"AccountID"=>$AccountID,"ServiceID"=>$ServiceID])->first()->toArray();
            if(!empty($Account['BillingStartDate'])) {
                $BillingStartDate = strtotime($Account['BillingStartDate']);
            }else{
                return '';
            }
            if($Account['BillingStartDate']==$Account['NextChargeDate']){
                $NextInvoiceDate = next_billing_date($Account['BillingCycleType'],$Account['BillingCycleValue'],$BillingStartDate);
                $NextInvoiceDate = date("Y-m-d 00:00:00", strtotime("-1 Day", strtotime($NextInvoiceDate)));
            }else{
                $NextInvoiceDate = $Account['NextChargeDate'];
            }

            return $NextInvoiceDate;
        }

    }

    public static function isFirstInvoiceSend($CompanyID,$AccountID,$ServiceID){
        $FirstInvoice=0;
        /**  Billingstart and NextInvoiceDate is same than it would be first invoice **/
        $Account = AccountBilling::where(["AccountID"=>$AccountID,"ServiceID"=>$ServiceID])->first();
        if(!empty($Account)){
            $BillingStartDate=$Account->BillingStartDate;
            $NextInvoiceDate=$Account->NextInvoiceDate;
            $BillingCycleType=$Account->BillingCycleType;
            if($BillingStartDate==$NextInvoiceDate && $BillingCycleType != 'manual'){
                $invocie_count =  Account::getInvoiceCount($AccountID);
                if($invocie_count==0){
                    $FirstInvoice=1;
                }
            }
        }
        return $FirstInvoice;
    }

    public static function IsAlreadyInvoiceSubscriptionDetail($AccountID,$ServiceID,$ProductID,$StartDate,$EndDate,$Description,$LineTotal,$Price,$Qty,$AccountSubscriptionID){
        $SubscriptionCount = InvoiceDetail::Join('tblInvoice','tblInvoiceDetail.InvoiceID','=','tblInvoice.InvoiceID')
            ->where(['ProductID'=>$ProductID,'StartDate'=>$StartDate,'EndDate'=>$EndDate,'ProductType'=>Product::SUBSCRIPTION,'tblInvoiceDetail.Description'=>$Description,'Price'=>$Price,'Qty'=>$Qty,'tblInvoiceDetail.ServiceID'=>$ServiceID,'tblInvoiceDetail.AccountSubscriptionID'=>$AccountSubscriptionID])
            ->where(['tblInvoice.AccountID'=>$AccountID])
            ->where('tblInvoice.InvoiceStatus','<>',Invoice::CANCEL)
            ->count();
        return $SubscriptionCount;
    }

    public static function getAccountUsageStartDate($AccountID,$StartDate,$ServiceID){
        $UsageStartDate=$StartDate;
        $UsageDetails = InvoiceDetail::Join('tblInvoice','tblInvoiceDetail.InvoiceID','=','tblInvoice.InvoiceID')
            ->where(['ProductType'=>Product::USAGE,'tblInvoiceDetail.ServiceID'=>$ServiceID])
            ->where(['tblInvoice.AccountID'=>$AccountID])
            ->orderby('tblInvoiceDetail.InvoiceDetailID','desc')
            ->limit(1)
            ->first();
        if(!empty($UsageDetails)){
            $EndDate = $UsageDetails->EndDate;
            if(!empty($EndDate)){
                $EndDate = date("Y-m-d", strtotime("+1 Day", strtotime($EndDate)));
                if($EndDate<$StartDate){
                    $UsageStartDate=$EndDate;
                }
            }
        }
        return $UsageStartDate;
    }

    public static function getAccountAdavanceSubscriptionDate($InvoiceID,$AccountID,$SubscriptionStartDate,$SubscriptionEndDate,$AccountSubscription){
        $SubscriptionData=array();
        $SubscriptionData['StartDate']=$SubscriptionStartDate;
        $SubscriptionData['EndDate']=$SubscriptionEndDate;

        $InvoiceHistory = InvoiceHistory::where(["InvoiceID"=>$InvoiceID,"AccountID"=>$AccountID])->first();
        $NewLastChargeDate = date("Y-m-d", strtotime("+1 Day", strtotime($InvoiceHistory->NextChargeDate)));
        $NewNextChargeDate=next_billing_date($InvoiceHistory->BillingCycleType, $InvoiceHistory->BillingCycleValue, strtotime($NewLastChargeDate));
        $NewNextChargeDate = date("Y-m-d 00:00:00", strtotime("-1 Day", strtotime($NewNextChargeDate)));
        Log::info('SubscriptionStartDate =' . $SubscriptionStartDate.' - SubscriptionEndDate = '.$SubscriptionEndDate);
        Log::info('NewNextChargeDate =' . $NewNextChargeDate );
        if (AccountSubscription::checkFirstTimeBilling($AccountSubscription->StartDate,$InvoiceHistory->LastInvoiceDate)) {

        }else{
            if($NewNextChargeDate > $SubscriptionEndDate){
                $SubscriptionData['EndDate']=$NewNextChargeDate;
            }
        }

        $SubscriptionData['AlreadyCharged']=0;
        $ProductID = $AccountSubscription->SubscriptionID;
        $Qty = $AccountSubscription->Qty;
        $ServiceID = $AccountSubscription->ServiceID;

        $StartDate = InvoiceDetail::Join('tblInvoice','tblInvoiceDetail.InvoiceID','=','tblInvoice.InvoiceID')
            ->where(['ProductID'=>$ProductID,'ProductType'=>Product::SUBSCRIPTION,'Qty'=>$Qty,'tblInvoiceDetail.ServiceID'=>$ServiceID])
            ->where('tblInvoice.InvoiceID','<',$InvoiceID)
            ->where(['tblInvoice.AccountID'=>$AccountID])
            ->min('StartDate');

        $EndDate = InvoiceDetail::Join('tblInvoice','tblInvoiceDetail.InvoiceID','=','tblInvoice.InvoiceID')
            ->where(['ProductID'=>$ProductID,'ProductType'=>Product::SUBSCRIPTION,'Qty'=>$Qty,'tblInvoiceDetail.ServiceID'=>$ServiceID])
            ->where('tblInvoice.InvoiceID','<',$InvoiceID)
            ->where(['tblInvoice.AccountID'=>$AccountID])
            ->max('EndDate');

        if(empty($StartDate) && empty($EndDate)){
            Log::info('SubscriptionDate');
            Log::info(print_r($SubscriptionData,true));
            return $SubscriptionData;
        }
        Log::info('EndDate =' . $EndDate);
        if($SubscriptionStartDate > $EndDate){
            $EndDate = date("Y-m-d", strtotime("+1 Day", strtotime($EndDate)));
            Log::info('NewEndDate1 =' . $EndDate);
            $SubscriptionData['StartDate']=$EndDate;
        }elseif($SubscriptionEndDate <= $EndDate){
            $SubscriptionData['AlreadyCharged']=1;
        }elseif($SubscriptionStartDate <= $EndDate && $SubscriptionEndDate > $EndDate){
            $EndDate = date("Y-m-d", strtotime("+1 Day", strtotime($EndDate)));
            Log::info('NewEndDate =' . $EndDate);
            $SubscriptionData['StartDate']=$EndDate;
        }
        Log::info('SubscriptionDate');
        Log::info(print_r($SubscriptionData,true));
        return $SubscriptionData;
    }

    public static function getFutureInvoiceTotal($CompanyID,$InvoicePeriod,$OnlyUsageCallChares=0){
        /**
         * Invoice Will Calculate Base on Last Charge Date and Next Charge Date(both date included)
         *
         **/
        $response=array();
        $error = "";
        $FirstInvoiceSend=0;
        $AlreadyBilled=0;
        $AccountBilling=AccountBilling::find($InvoicePeriod['AccountBillingID']);
        $AccountID = $AccountBilling->AccountID;
        $ServiceID=$AccountBilling->ServiceID;
        $LastInvoiceDate = $InvoicePeriod['LastInvoiceDate'];
        $NextInvoiceDate = $InvoicePeriod['NextInvoiceDate'];

        $StartDate  = $InvoicePeriod['LastChargeDate'];
        $EndDate    = $InvoicePeriod['NextChargeDate'];
        $EndDate    =  date("Y-m-d 23:59:59", strtotime($EndDate));

        Log::info('start Date =' . $StartDate . " EndDate =" .$EndDate );

        $CompanyName  = Company::getName($CompanyID);
        $Account = Account::find((int)$AccountID);

        $InvoiceTemplateID=BillingClass::getInvoiceTemplateID($AccountBilling->BillingClassID);

        $InvoiceTemplate = InvoiceTemplate::where("InvoiceTemplateID",$InvoiceTemplateID)->first();
        //Log::info('InvoiceTemplate->InvoiceNumberPrefix =' .($InvoiceTemplate->InvoiceNumberPrefix)) ;
        //Log::info('InvoiceTemplate->Terms =' .($InvoiceTemplate->Terms));

        $InvoiceTemplate->DateFormat = invoice_date_fomat($InvoiceTemplate->DateFormat);
        $decimal_places = Helper::get_round_decimal_places($CompanyID,$Account->AccountID,$ServiceID);

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
        //Log::info('Invoice::checkIfAccountUsageAlreadyBilled') ;

        $Invoice = "";
        $SubTotal = 0;
        $SubTotalWithoutTax = 0;
        $AdditionalChargeTax = 0;

        //If Account usage not already billed

        DB::connection('sqlsrv2')->beginTransaction();

        $uResponse = self::addUsage($Account,$CompanyID, $AccountID,$LastInvoiceDate,$NextInvoiceDate,$StartDate,$EndDate,$InvoiceTemplate,$SubTotal,$decimal_places,$ServiceID,$FirstInvoiceSend,$OnlyUsageCallChares,1);
        $Invoice = $uResponse["Invoice"];
        $SubTotal = $uResponse["SubTotal"];

        // Usage Over

        //Log::info('Usage Over') ;

        /**
         ***************************
         **************************
        Step 2  SUBSCRIPTION
         **************************
         **************************
         */

        if($OnlyUsageCallChares==0) {

            /**
             * Add Subscription in InvoiceDetail if any
             */
            $subResponse = self::addSubscription($Invoice, $ServiceID, $StartDate, $EndDate, $SubTotal, $decimal_places, 0, $FirstInvoiceSend);
            $SubTotal = $subResponse["SubTotal"];
            $SubTotalWithoutTax += $subResponse["SubscriptionChargewithouttaxTotal"];

            /**
             * Add OneOffCharge in InvoiceDetail if any
             */
            $subResponse = self::addOneOffCharge($Invoice, $ServiceID, $StartDate, $EndDate, $SubTotal, $decimal_places, 0, $FirstInvoiceSend);
            $SubTotal = $subResponse["SubTotal"];
            $SubTotalWithoutTax += $subResponse["SubscriptionChargewithouttaxTotal"];
            $AdditionalChargeTax = $subResponse["AdditionalChargeTotalTax"];
        }
        /**
         ***************************
         **************************
        Step 3  USAGE FILE & Invoice PDF & EMAIL
         **************************
         **************************
         */

        //Log::info('USAGE FILE & Invoice PDF & EMAIL Start') ;

        if (isset($Invoice)) {
            $InvoiceID = $Invoice->InvoiceID;
            $totals = self::updateInvoiceAllTotalAmounts($Invoice,$SubTotal,$SubTotalWithoutTax,$AdditionalChargeTax,$decimal_places,$ServiceID,$OnlyUsageCallChares);
            log::info(print_r($totals,true));
            $response = $totals;
            if($OnlyUsageCallChares==1){
                $Description = InvoiceDetail::where("InvoiceID",$InvoiceID)->where("ProductType",Product::USAGE)->pluck('Description');
                $response['Description'] = empty($Description) ? '' : $Description;
            }


        }//Email Sending over

        DB::connection('sqlsrv2')->rollback();

        //Log::info('=========== Email Sending over =========== ') ;

        return $response;

    }

    public static function insertInvoiceUsageTaxRate($InvoiceID,$AccountID,$InvoiceSubTotal,$AdditionalChargeTax,$ServiceID) {

        /*$Invoice = Invoice::find($InvoiceID);
        $InvoiceSubTotal = $Invoice->SubTotal;*/

        //Get Account TaxIDs
        $TaxRateIDs = AccountBilling::getTaxRate($AccountID,$ServiceID);

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

                        }
                        $TotalTax = Invoice::calculateTotalTaxByTaxRateObj($TaxRate, $SubTotal);

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

        return $TaxGrandTotal;
    }

    public static function ProcessAccountCallCharges($CompanyID,$ProcessID){
        $processresponse = $errors = $message = array();

        $query = "CALL prc_getDeductCallChargeAccounts(?)";
        $Accounts = DB::select($query,array($CompanyID));
        Log::info("Call prc_getBillingAccounts($CompanyID)");
        //log::info(print_r($Accounts,true));
        $Accounts = json_decode(json_encode($Accounts),true);

        foreach ($Accounts as $Account) {
            $AccountID = $Account['AccountID'];
            $ServiceID = $Account['ServiceID'];
            $NextInvoiceDate = $Account['NextInvoiceDate'];
            $DeductCallChargeCount=0;
            $AutoPaymentSetting = AccountBilling::where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID])->pluck('AutoPaymentSetting');
            $AutoPayMethod = AccountBilling::where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID])->pluck('AutoPayMethod');

            /**
             * When Autopay on and autopaymethod is account balancd and billing class have deductcallcharge is on than add negetive payment of usage
             */
            if(!empty($AutoPaymentSetting) && $AutoPaymentSetting!='never' && !empty($AutoPayMethod) && $AutoPayMethod=AccountBilling::ACCOUNT_BALANCE){
                $BillingClassID = AccountBilling::where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID,'NextInvoiceDate'=>$NextInvoiceDate])->pluck('BillingClassID');
                if(!empty($BillingClassID)){
                    $DeductCallChargeCount = BillingClass::where(['BillingClassID'=>$BillingClassID,'DeductCallChargeInAdvance'=>1])->count();
                }
            }

            log::info('DeductCallChargeCount '.$DeductCallChargeCount);
            log::info('AccountID '.$AccountID.' ServiceID '.$ServiceID.' NextInvoiceDate '.$NextInvoiceDate);

            if($DeductCallChargeCount > 0) {
                $AllInvoicePeriods = self::getInvoiceperiodsFromLastInvoiceDateToTillNow($AccountID, $ServiceID);

                foreach ($AllInvoicePeriods as $InvoicePeriod) {
                    $StartDate  = date('Y-m-d 00:00:00', strtotime($InvoicePeriod['LastChargeDate']));
                    $EndDate    = date('Y-m-d 23:59:59', strtotime($InvoicePeriod['NextChargeDate']));
                    $PaymentStatus1 = DB::connection('sqlsrv2')->table('tblPayment')->where(['AccountID' => $AccountID, 'UsageStartDate' => $InvoicePeriod['LastChargeDate'], 'UsageEndDate' => $InvoicePeriod['NextChargeDate']]);
                    $PaymentStatus2 = DB::connection('sqlsrv2')
                        ->table('tblInvoice')
                        ->join('tblInvoiceDetail','tblInvoiceDetail.InvoiceID','=','tblInvoice.InvoiceID')
                        ->where(['AccountID' => $AccountID,'ProductType' => Product::ADVANCECALLCHARGE, 'StartDate' => $StartDate, 'EndDate' => $EndDate])
                        ->select(['tblInvoiceDetail.StartDate','tblInvoiceDetail.EndDate'])
                        ->orderBy('tblInvoice.InvoiceID','desc');
                    if ($PaymentStatus1->count() == 0 && $PaymentStatus2->count() == 0) {
                        log::info('PaymentStatus 0');
                        $EndDate = date("Y-m-d", strtotime("-1 Day", strtotime($InvoicePeriod['NextInvoiceDate'])));
                        $isCDRLoaded = DB::connection('sqlsrv2')->select("CALL prc_checkCDRIsLoadedOrNot(" . (int)$AccountID . ",$CompanyID,'$EndDate')");
                        if (isset($isCDRLoaded[0]->isLoaded) && $isCDRLoaded[0]->isLoaded == 1) {
                            $response = Invoice::getFutureInvoiceTotal($CompanyID, $InvoicePeriod, 1);
                            $Description = $response['Description'];
                            $Amount = '-' . $response['GrandTotal'];
                            log::info('New Amount ' . $Amount);
                            $account = Account::find($AccountID);
                            $paymentdata = array();
                            $paymentdata['CompanyID'] = $CompanyID;
                            $paymentdata['AccountID'] = $AccountID;
                            $paymentdata['PaymentDate'] = date('Y-m-d');
                            $paymentdata['PaymentMethod'] = 'Account Balance';
                            $paymentdata['CurrencyID'] = $account->CurrencyId;
                            $paymentdata['PaymentType'] = 'Payment In';
                            $paymentdata['Notes'] = 'Usage Call Charges ('.$StartDate.' to '.$EndDate.')';
                            $paymentdata['Amount'] = floatval($Amount);
                            $paymentdata['Status'] = 'Approved';
                            $paymentdata['created_at'] = date('Y-m-d H:i:s');
                            $paymentdata['updated_at'] = date('Y-m-d H:i:s');
                            $paymentdata['CreatedBy'] = 'ProcessCallChargeSystem';
                            $paymentdata['ModifyBy'] = 'ProcessCallChargeSystem';
                            $paymentdata['UsageStartDate'] = $InvoicePeriod['LastChargeDate'];
                            $paymentdata['UsageEndDate'] = $InvoicePeriod['NextChargeDate'];

                            $PaymentMethod = 'Account Balance';
                            $AccountOutstandingBalance = AccountBalance::getBalanceSOAOffsetAmount($AccountID);
                            $CheckAccountBalance = AccountBalance::CheckAccountBalance($AccountID, $AccountOutstandingBalance, $response['GrandTotal']);
                            $EMAIL_TO_CUSTOMER = CompanyConfiguration::get($CompanyID, 'EMAIL_TO_CUSTOMER');
                            $Company = Company::find($CompanyID);
                            $UserID = User::where("CompanyID", $CompanyID)->where(["AdminUser" => 1, "Status" => 1])->min("UserID");

                            if ($payment = Payment::insert($paymentdata)) {
                                /*$LogData = array();
                                $LogData['AccountID'] = $AccountID;
                                $LogData['ServiceID'] = $ServiceID;
                                $LogData['InvoiceDate'] = $InvoicePeriod['NextInvoiceDate'];
                                $LogData['Description'] = $Description;
                                $LogData['Amount'] = $Amount;
                                $LogData['PaymentStatus'] = 1;
                                DB::connection('sqlsrv2')->table('tblProcessCallChargesLog')->insert($LogData);*/

                                $processresponse[] = $account->AccountName . ' Call Charges ' . $Description;

                                $Emaildata = array();
                                $Emaildata['CompanyID'] = $CompanyID;
                                $Emaildata['CompanyName'] = $Company->CompanyName;
                                $Emaildata['AccountName'] = $account->AccountName;
                                $Emaildata['Amount'] = floatval($response['GrandTotal']);
                                $Emaildata['PaymentMethod'] = $PaymentMethod;
                                $Emaildata['Currency'] = Currency::getCurrencyCode($account->CurrencyId);

                                /*Email Send Start */
                                if (isset($CheckAccountBalance) && $CheckAccountBalance == 1) {
                                    $CustomerEmail = '';
                                    if ($EMAIL_TO_CUSTOMER == 1) {
                                        $CustomerEmail = $account->BillingEmail;
                                    }

                                    $Emaildata['Subject'] = 'Call Charges (' . $Description . ') Payment';
                                    $Emaildata['Status'] = 'Success';
                                    $Emaildata['Notes'] = 'Call charges is Successfully paid';

                                    $CustomerEmail = explode(",", $CustomerEmail);
                                    $EmailTemplateStatus = EmailsTemplates::CheckEmailTemplateStatus(Payment::AUTOINVOICETEMPLATE, $CompanyID);
                                    if (!empty($CustomerEmail) && !empty($EmailTemplateStatus)) {
                                        $staticdata = array();
                                        $staticdata['PaidAmount'] = floatval($response['GrandTotal']);
                                        $staticdata['PaidStatus'] = 'Success';
                                        $staticdata['PaymentMethod'] = $PaymentMethod;
                                        $staticdata['PaymentNotes'] = 'Usage call charges is Successfully paid';
                                        foreach ($CustomerEmail as $singleemail) {
                                            $singleemail = trim($singleemail);
                                            if (filter_var($singleemail, FILTER_VALIDATE_EMAIL)) {
                                                $Emaildata['EmailTo'] = $singleemail;
                                                $WEBURL = CompanyConfiguration::getValueConfigurationByKey($CompanyID, 'WEB_URL');
                                                //$Emaildata['data']['InvoiceLink'] = $WEBURL . '/invoice/' . $AccountID . '-' . $Invoice->InvoiceID . '/cview?email=' . $singleemail;
                                                $body = EmailsTemplates::SendAutoPaymentFromProcessCallChare($AccountID, 'body', $CompanyID, $singleemail, $staticdata);
                                                //$Emaildata['Subject'] = EmailsTemplates::SendAutoPaymentFromProcessCallChare($AccountID, "subject", $CompanyID, $singleemail, $staticdata);
                                                if (!isset($Emaildata['EmailFrom'])) {
                                                    $Emaildata['EmailFrom'] = EmailsTemplates::GetEmailTemplateFrom(Payment::AUTOINVOICETEMPLATE, $CompanyID);
                                                }
                                                $customeremail_status = Helper::sendMail($body, $Emaildata, 0);
                                                if (!empty($customeremail_status['status'])) {
                                                    $JobLoggedUser = User::find($UserID);
                                                    $statuslog = Helper::account_email_log($CompanyID, $AccountID, $Emaildata, $customeremail_status, $JobLoggedUser, '', 0);
                                                }
                                            }
                                        }
                                    }
                                    $NotificationEmails = Notification::getNotificationMail(['CompanyID' => $CompanyID, 'NotificationType' => Notification::InvoicePaidByCustomer]);
                                    $emailArray = explode(',', $NotificationEmails);
                                    if (!empty($emailArray)) {
                                        foreach ($emailArray as $singleemail) {
                                            $singleemail = trim($singleemail);
                                            if (filter_var($singleemail, FILTER_VALIDATE_EMAIL)) {
                                                $Emaildata['EmailTo'] = $singleemail;
                                                $Emaildata['EmailToName'] = '';
                                                $status = Helper::sendMail('emails.AutoPaymentEmailSend', $Emaildata);
                                            }
                                        }
                                    }
                                } else {
                                    $Emaildata['Subject'] = 'Call Charges (' . $Description . ') Payment';
                                    $Emaildata['Status'] = 'Fail';
                                    $Emaildata['Notes'] = 'Account has not sufficient balance';

                                    $CustomerEmail = '';
                                    if ($EMAIL_TO_CUSTOMER == 1) {
                                        $CustomerEmail = $account->BillingEmail;
                                    }
                                    $CustomerEmail = explode(",", $CustomerEmail);
                                    $EmailTemplateStatus = EmailsTemplates::CheckEmailTemplateStatus(Payment::AUTOINVOICETEMPLATE, $CompanyID);
                                    log::info('EmailTemplat Status ' . $EmailTemplateStatus);
                                    if (!empty($CustomerEmail) && !empty($EmailTemplateStatus)) {
                                        $staticdata = array();
                                        $staticdata['PaidAmount'] = floatval($response['GrandTotal']);
                                        $staticdata['PaidStatus'] = 'Failed';
                                        $staticdata['PaymentMethod'] = $PaymentMethod;
                                        $staticdata['PaymentNotes'] = 'Account has not sufficient balance';

                                        foreach ($CustomerEmail as $singleemail) {
                                            $singleemail = trim($singleemail);
                                            if (filter_var($singleemail, FILTER_VALIDATE_EMAIL)) {
                                                $Emaildata['EmailTo'] = $singleemail;
                                                $WEBURL = CompanyConfiguration::getValueConfigurationByKey($CompanyID, 'WEB_URL');
                                                //$Emaildata['data']['InvoiceLink'] = $WEBURL . '/invoice/' . $AccountID . '-' . $Invoice->InvoiceID . '/cview?email=' . $singleemail;
                                                $body = EmailsTemplates::SendAutoPaymentFromProcessCallChare($AccountID, 'body', $CompanyID, $singleemail, $staticdata);
                                                //$Emaildata['Subject'] = EmailsTemplates::SendAutoPaymentFromProcessCallChare($AccountID, "subject", $CompanyID, $singleemail, $staticdata);
                                                if (!isset($Emaildata['EmailFrom'])) {
                                                    $Emaildata['EmailFrom'] = EmailsTemplates::GetEmailTemplateFrom(Payment::AUTOINVOICETEMPLATE, $CompanyID);
                                                }
                                                $customeremail_status = Helper::sendMail($body, $Emaildata, 0);
                                                //log::info('Customer EmailTemplat Status '.print_r($customeremail_status,true));
                                                if (!empty($customeremail_status['status'])) {
                                                    $JobLoggedUser = User::find($UserID);
                                                    $statuslog = Helper::account_email_log($CompanyID, $AccountID, $Emaildata, $customeremail_status, $JobLoggedUser, '', 0);
                                                }
                                                //Log::info($customeremail_status);
                                            }
                                        }
                                    }
                                    $NotificationEmails = Notification::getNotificationMail(['CompanyID' => $CompanyID, 'NotificationType' => Notification::InvoicePaidByCustomer]);
                                    $emailArray = explode(',', $NotificationEmails);
                                    if (!empty($emailArray)) {
                                        foreach ($emailArray as $singleemail) {
                                            $singleemail = trim($singleemail);
                                            if (filter_var($singleemail, FILTER_VALIDATE_EMAIL)) {
                                                $Emaildata['EmailTo'] = $singleemail;
                                                $Emaildata['EmailToName'] = '';
                                                $status = Helper::sendMail('emails.AutoPaymentEmailSend', $Emaildata);
                                            }
                                        }
                                    }
                                }
                                /* Email send Over */

                            }
                        }
                    } // payment status condition
                } // InvoicePeriod for specific account loop over
            } // deduct call charge condition
        } // Account Loop over

        return $processresponse;
    }

    /*public static function getInvoiceperiodsFromLastInvoiceDateToTillNow($AccountID,$ServiceID){
        $AllInvoicePeriods = array();
        $today = '2018-08-06';//date('Y-m-d');

        $PaymentStatus = DB::connection('sqlsrv2')
                            ->table('tblProcessCallChargesLog')
                            ->where(['AccountID' => $AccountID, 'ServiceID' => $ServiceID])
                            ->orderBy('LogID','desc');

        $AccountBilling     = AccountBilling::where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID])->first();
        $BillingCycleType   = $AccountBilling->BillingCycleType;
        $BillingCycleValue  = $AccountBilling->BillingCycleValue;

        if($PaymentStatus->count() > 0) {
            // if found any entry in log then we will get last invoice date from there
            $PaymentStatus      = $PaymentStatus->first();
            $LastInvoiceDate    = $PaymentStatus->InvoiceDate;
            $NextInvoiceDate    = next_billing_date($BillingCycleType, $BillingCycleValue, strtotime($LastInvoiceDate));
        } else if($AccountBilling->NextInvoiceDate > $today && $AccountBilling->LastInvoiceDate == $today) {
            // if Next Invoice Date is future's date then get Dates from tblInvoice
            // if invoice is generated for the period then get dates from tblInvoice
            $LastInvoice = Invoice::join('tblInvoiceDetail','tblInvoice.InvoiceID','=','tblInvoiceDetail.InvoiceID')
                                    ->where(['tblInvoice.AccountID'=>$AccountID,'tblInvoiceDetail.ProductType'=>2,'tblInvoice.IssueDate'=>$today])
                                    ->orderBy('tblInvoiceDetail.StartDate','asc')
                                    ->select(['tblInvoiceDetail.StartDate','tblInvoiceDetail.EndDate']);
            if($LastInvoice->count() > 0) {
                $LastInvoice        = $LastInvoice->first();
                $StartDate          = $LastInvoice->StartDate;
                $EndtDate           = $LastInvoice->EndDate;
                $LastInvoiceDate    = date('Y-m-d',strtotime($StartDate));
                $NextInvoiceDate    = date('Y-m-d',strtotime($EndtDate.' + 1 day'));
            } else {
                // if not found any invoice, first invoice then
                $LastInvoiceDate    = $AccountBilling->LastInvoiceDate;
                $NextInvoiceDate    = $AccountBilling->NextInvoiceDate;
            }
        } else {
            // if Next Invoice Date today or past then get dates from AccountBilling
            $LastInvoiceDate    = $AccountBilling->LastInvoiceDate;
            $NextInvoiceDate    = $AccountBilling->NextInvoiceDate;
        }

        if($NextInvoiceDate <= $today) {
            $AllInvoicePeriods[0]['AccountID'] = $AccountID;
            $AllInvoicePeriods[0]['AccountBillingID'] = $AccountBilling->AccountBillingID;
            $AllInvoicePeriods[0]['BillingCycleType'] = $BillingCycleType;
            $AllInvoicePeriods[0]['BillingCycleValue'] = $BillingCycleValue;
            $AllInvoicePeriods[0]['LastInvoiceDate'] = $LastInvoiceDate;
            $AllInvoicePeriods[0]['NextInvoiceDate'] = $NextInvoiceDate;
            $AllInvoicePeriods[0]['LastChargeDate'] = $LastInvoiceDate;
            $AllInvoicePeriods[0]['NextChargeDate'] = date('Y-m-d', strtotime($NextInvoiceDate . ' - 1 day'));
            while ($NextInvoiceDate < $today) {
                $temp = array();
                $temp['AccountID'] = 111;
                $temp['AccountBillingID'] = $AccountBilling->AccountBillingID;
                $temp['BillingCycleType'] = $BillingCycleType;
                $temp['BillingCycleValue'] = $BillingCycleValue;
                $temp['LastInvoiceDate'] = $NextInvoiceDate;
                $NextBillingDate = next_billing_date($BillingCycleType, $BillingCycleValue, strtotime($NextInvoiceDate));
                if ($NextBillingDate <= $today) {
                    $temp['NextInvoiceDate'] = $NextBillingDate;
                    $temp['LastChargeDate'] = $temp['LastInvoiceDate'];
                    $temp['NextChargeDate'] = date('Y-m-d', strtotime($NextBillingDate . ' - 1 day'));
                    array_push($AllInvoicePeriods, $temp);
                }
                //$AllInvoicePeriods[]=$temp;
                $NextInvoiceDate = $NextBillingDate;
            }
        }
        return $AllInvoicePeriods;
    }*/
    public static function getInvoiceperiodsFromLastInvoiceDateToTillNow($AccountID,$ServiceID){
        $AllInvoicePeriods = array();
        $today = date('Y-m-d');
        /*$today1 = '2018-08-06';//date('Y-m-d');
        $today2 = '2018-08-08';//date('Y-m-d');*/

        // check in tblPayment if any entries exist then take last usage dates from it
        $PaymentStatus1 = DB::connection('sqlsrv2')
            ->table('tblPayment')
            ->where(['AccountID' => $AccountID])
            ->where('UsageStartDate', '!=', 'NULL')
            ->where('UsageEndDate', '!=', 'NULL')
            ->orderBy('UsageStartDate','desc');

        // check in tblInvoiceDetail if any entries exist then take last usage dates from it
        // in tblInvoiceDetail we are inserting 0 value with ADVANCECALLCHARGE type when DeductCallChargesInAdvance is turned off in billing class
        $PaymentStatus2 = DB::connection('sqlsrv2')
            ->table('tblInvoice')
            ->join('tblInvoiceDetail','tblInvoiceDetail.InvoiceID','=','tblInvoice.InvoiceID')
            ->where(['AccountID' => $AccountID,'ProductType' => Product::ADVANCECALLCHARGE])
            ->select(['tblInvoiceDetail.StartDate','tblInvoiceDetail.EndDate'])
            ->orderBy('tblInvoice.InvoiceID','desc');

        $AccountBilling     = AccountBilling::where(['AccountID'=>$AccountID,'ServiceID'=>$ServiceID])->first();
        $BillingCycleType   = $AccountBilling->BillingCycleType;
        $BillingCycleValue  = $AccountBilling->BillingCycleValue;

        if($PaymentStatus1->count() > 0 || $PaymentStatus2->count() > 0) {
            // if found any entry in log then we will get last usage dates from there
            $EndtDate = '';
            if($PaymentStatus1->count() > 0 && $PaymentStatus2->count() > 0) {
                $PaymentStatus = $PaymentStatus1->first();
                $InvoiceStatus = $PaymentStatus2->first();
                if($PaymentStatus->UsageStartDate > $InvoiceStatus->StartDate) {
                    $EndtDate   = $PaymentStatus->UsageEndDate;
                } else {
                    $EndtDate   = $InvoiceStatus->EndDate;
                }
            } else if ($PaymentStatus1->count() > 0) {
                $PaymentStatus = $PaymentStatus1->first();
                $EndtDate   = $PaymentStatus->UsageEndDate;
            } else if ($PaymentStatus2->count() > 0) {
                $InvoiceStatus = $PaymentStatus2->first();
                $EndtDate   = $InvoiceStatus->EndDate;
            }

            $LastInvoiceDate    = date('Y-m-d',strtotime($EndtDate.' + 1 day'));
            $NextInvoiceDate    = next_billing_date($BillingCycleType, $BillingCycleValue, strtotime($LastInvoiceDate));
        } else if($AccountBilling->NextInvoiceDate > $today && $AccountBilling->LastInvoiceDate == $today) {
            // if Next Invoice Date is future's date then get Dates from tblInvoice
            // if invoice is generated for the period then get dates from tblInvoice
            $LastInvoice = Invoice::join('tblInvoiceDetail','tblInvoice.InvoiceID','=','tblInvoiceDetail.InvoiceID')
                ->where(['tblInvoice.AccountID'=>$AccountID,'tblInvoiceDetail.ProductType'=>Product::USAGE,'tblInvoice.IssueDate'=>$today])
                ->orderBy('tblInvoiceDetail.StartDate','asc')
                ->select(['tblInvoiceDetail.StartDate','tblInvoiceDetail.EndDate']);
            //Log::info($LastInvoice->count());
            if($LastInvoice->count() > 0) {
                $LastInvoice        = $LastInvoice->first();
                $StartDate          = $LastInvoice->StartDate;
                $EndtDate           = $LastInvoice->EndDate;
                $LastInvoiceDate    = date('Y-m-d',strtotime($StartDate));
                $NextInvoiceDate    = date('Y-m-d',strtotime($EndtDate.' + 1 day'));
            } else {
                // if not found any invoice, first invoice then
                $LastInvoiceDate    = $AccountBilling->LastInvoiceDate;
                $NextInvoiceDate    = $AccountBilling->NextInvoiceDate;
            }
        } else {
            // if Next Invoice Date today or past then get dates from AccountBilling
            $LastInvoiceDate    = $AccountBilling->LastInvoiceDate;
            $NextInvoiceDate    = $AccountBilling->NextInvoiceDate;
        }

        if($NextInvoiceDate <= $today) {
            $AllInvoicePeriods[0]['AccountID'] = $AccountID;
            $AllInvoicePeriods[0]['AccountBillingID'] = $AccountBilling->AccountBillingID;
            $AllInvoicePeriods[0]['BillingCycleType'] = $BillingCycleType;
            $AllInvoicePeriods[0]['BillingCycleValue'] = $BillingCycleValue;
            $AllInvoicePeriods[0]['LastInvoiceDate'] = $LastInvoiceDate;
            $AllInvoicePeriods[0]['NextInvoiceDate'] = $NextInvoiceDate;
            $AllInvoicePeriods[0]['LastChargeDate'] = $LastInvoiceDate;
            $AllInvoicePeriods[0]['NextChargeDate'] = date('Y-m-d', strtotime($NextInvoiceDate . ' - 1 day'));
            while ($NextInvoiceDate < $today) {
                $temp = array();
                $temp['AccountID'] = $AccountID;
                $temp['AccountBillingID'] = $AccountBilling->AccountBillingID;
                $temp['BillingCycleType'] = $BillingCycleType;
                $temp['BillingCycleValue'] = $BillingCycleValue;
                $temp['LastInvoiceDate'] = $NextInvoiceDate;
                $NextBillingDate = next_billing_date($BillingCycleType, $BillingCycleValue, strtotime($NextInvoiceDate));
                if ($NextBillingDate <= $today) {
                    $temp['NextInvoiceDate'] = $NextBillingDate;
                    $temp['LastChargeDate'] = $temp['LastInvoiceDate'];
                    $temp['NextChargeDate'] = date('Y-m-d', strtotime($NextBillingDate . ' - 1 day'));
                    array_push($AllInvoicePeriods, $temp);
                }
                //$AllInvoicePeriods[]=$temp;
                $NextInvoiceDate = $NextBillingDate;
            }
        }
        //Log::info($AllInvoicePeriods);
        return $AllInvoicePeriods;
    }

    public static function getTotalAmountInOtherCurrency($CompanyID,$BaseCurrencyID,$Amount,$RoundChargesAmount){
        $Results=array();
        $CompanyCurrencyID=Company::where('CompanyID',$CompanyID)->pluck('CurrencyId');
        if(!empty($CompanyCurrencyID)) {
            $Currencies = Currency::where('CurrencyId', '<>', $BaseCurrencyID)->get();
            if (!empty($Currencies) && count($Currencies) > 0) {
                foreach ($Currencies as $currency) {
                    $CurrencyID = $currency->CurrencyId;
                    $ConversionRate = CurrencyConversion::where('CurrencyID', $CurrencyID)->pluck('Value');
                    $Title = Currency::getCurrencyCode($CurrencyID);
                    $Symbol = Currency::getCurrencySymbol($CurrencyID);
                    if (!empty($ConversionRate)) {
                        $temp = array();
                        $temp['Title'] = $Title;
                        if ($BaseCurrencyID == $CompanyCurrencyID) {
                            $TempAmount = ($Amount * $ConversionRate);
                            $TempAmount = number_format($TempAmount,$RoundChargesAmount);

                        }else{
                            $ACConversionRate = CurrencyConversion::where('CurrencyID',$BaseCurrencyID)->pluck('Value');
                            $TempAmount = ($ConversionRate) * ($Amount/$ACConversionRate);
                            $TempAmount = number_format($TempAmount,$RoundChargesAmount);
                        }
                        $temp['Amount'] = $Symbol . $TempAmount;
                        $Results[] = $temp;
                    }
                }

            }
        }
        return $Results;
    }


    public static $PerMinuteComponents = [
        "RecordingCostPerMinute",
        "PackageCostPerMinute",
        "SurchargePerMinute",
        "CostPerMinute",
        "OutpaymentPerMinute"
    ];

    public static function getComponentTitle($InvoiceComponent){

        $Title = "";

        $Component = $InvoiceComponent->Component;
        $ComponentTitles = [
            "RecordingCostPerMinute" => cus_lang("PAGE_INVOICE_PDF_LBL_COMPONENT_RECORDING_COST_PER_MINUTE"),
            "PackageCostPerMinute" => cus_lang("PAGE_INVOICE_PDF_LBL_COMPONENT_PACKAGE_COST_PER_MINUTE"),
            "SurchargePerMinute" => cus_lang("PAGE_INVOICE_PDF_LBL_SURCHARGE_PER_MINUTE"),
            "SurchargePerCall" => cus_lang("PAGE_INVOICE_PDF_LBL_COMPONENT_SURCHARGE_PER_CALL"),
            "CollectionCostAmount" => cus_lang("PAGE_INVOICE_PDF_LBL_COMPONENT_COLLECTION_COST_AMOUNT"),
            "CollectionCostPercentage" => cus_lang("PAGE_INVOICE_PDF_LBL_COMPONENT_COLLECTION_COST_PERCENTAGE"),
            "CostPerCall" => cus_lang("PAGE_INVOICE_PDF_LBL_COMPONENT_COST_PER_CALL"),
            "CostPerMinute" => cus_lang("PAGE_INVOICE_PDF_LBL_COMPONENT_COST_PER_MINUTE"),
            "OutpaymentPerMinute" => cus_lang("PAGE_INVOICE_PDF_LBL_COMPONENT_OUTPAYMENT_PER_MINUTE"),
            "OutpaymentPerCall" => cus_lang("PAGE_INVOICE_PDF_LBL_COMPONENT_OUTPAYMENT_PER_CALL"),
            "Chargeback" => cus_lang("PAGE_INVOICE_PDF_LBL_COMPONENT_CHARGEBACK"),
            "Surcharges" => cus_lang("PAGE_INVOICE_PDF_LBL_COMPONENT_SURCHARGE"),
        ];

        if($InvoiceComponent->Type == "Outbound")
            $Title = cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_COMPONENT_LBL_TERMINATION");

        $Title .= isset($ComponentTitles[$Component]) ? $ComponentTitles[$Component] : $Component;

        if($InvoiceComponent->Destination != "")
            $Title .= " " . $InvoiceComponent->Destination;

        $TerminationType = "";
        if($InvoiceComponent->TerminationType != "" && $InvoiceComponent->TerminationType != "NA")
            $TerminationType = " " . $InvoiceComponent->TerminationType;

        if($InvoiceComponent->Origination != "" && $InvoiceComponent->Origination != "NA")
            $Title .= " of" . $TerminationType . " " . $InvoiceComponent->Origination;
        elseif($TerminationType != "")
            $Title .= " of" . $TerminationType;


        if($InvoiceComponent->Timezone != "" && $InvoiceComponent->Timezone != "Default")
            $Title .= " " . $InvoiceComponent->Timezone;
        return $Title;
    }

    public static function getMonthlyTitle($InvoiceComponent){

        $Title = "";

        $Component = $InvoiceComponent->Component . "_" . $InvoiceComponent->ProductType;
        $ComponentTitles = [
            "MonthlyCost_2" => cus_lang("PAGE_INVOICE_PDF_LBL_COMPONENT_MONTHLY_COST_ACCESS"),
            "MonthlyCost_3" => cus_lang("PAGE_INVOICE_PDF_LBL_COMPONENT_MONTHLY_COST_PACKAGE"),
            "OneOffCost_2"  => cus_lang("PAGE_INVOICE_PDF_LBL_COMPONENT_ONE_OFF_COST_ACCESS"),
            "OneOffCost_3"  => cus_lang("PAGE_INVOICE_PDF_LBL_COMPONENT_ONE_OFF_COST_PACKAGE"),
        ];
        if(isset($ComponentTitles[$Component]))
            $Title = $ComponentTitles[$Component];

        return $Title;
    }

    public static function getComponentsData($InvoiceDetailIDs, $IsAffiliate = 0){
        $InvoiceDetailIDs = is_array($InvoiceDetailIDs) ? $InvoiceDetailIDs : [$InvoiceDetailIDs];
        //Getting all CLIs data
        return DB::connection('sqlsrv2')
            ->table("tblInvoiceComponentDetail as id")
            ->select("tz.Title as Timezone","rt.Description as Destination","rt.Type as TerminationType","cli.CountryID","cli.Prefix","pkg.PackageId","id.InvoiceComponentDetailID","id.CLI","id.AccountServiceID","id.RateID","id.Component","id.Origination","id.Discount","id.DiscountPrice","id.Type","id.ProductType","id.Quantity","id.Duration","id.SubTotal","id.TotalTax","id.TotalCost","id.CustomerID","ac.AccountName")
            ->join("speakintelligentRM.tblCLIRateTable as cli", "cli.CLIRateTableID","=","id.CLIRateTableID")
            ->leftJoin("speakintelligentRM.tblAccountServicePackage as pkg","pkg.AccountServicePackageID","=","cli.AccountServicePackageID")
            ->leftJoin("speakintelligentRM.tblAccount as ac","ac.AccountID","=","id.CustomerID")
            ->leftJoin("speakintelligentRM.tblTimezones as tz","tz.TimezonesID","=","id.TimezonesID")
            ->leftJoin("speakintelligentRM.tblRate as rt","rt.RateID","=","id.RateID")
            ->whereIn('id.InvoiceDetailID',$InvoiceDetailIDs)
            ->where('id.IsAffiliate', $IsAffiliate)
            ->get();
    }


    public static function getCustomerComponents($InvoiceDetailIDs, $RoundChargesAmount){
        $data = [];
        //Getting all CLIs data
        $InvoiceComponents = self::getComponentsData($InvoiceDetailIDs);

        foreach($InvoiceComponents as $invoiceComponent){
            $index = $invoiceComponent->CLI."_".$invoiceComponent->AccountServiceID."_".$invoiceComponent->CountryID;

            if(!isset($data[$index])){
                $data[$index] = [
                    'AccountServiceID' => $invoiceComponent->AccountServiceID,
                    'CLI'        => $invoiceComponent->CLI,
                    'CustomerID' => $invoiceComponent->CustomerID,
                    'CountryID'  => $invoiceComponent->CountryID,
                    'PackageID'  => $invoiceComponent->PackageId,
                    'Prefix'     => $invoiceComponent->Prefix,
                    'DiscountPrice'   => $invoiceComponent->DiscountPrice,
                    'SubTotal'   => $invoiceComponent->SubTotal,
                    'TotalTax'   => $invoiceComponent->TotalTax,
                    'GrandTotal' => $invoiceComponent->TotalCost,
                ];
            } else {
                $data[$index]['DiscountPrice']   += $invoiceComponent->DiscountPrice;
                $data[$index]['SubTotal']   += $invoiceComponent->SubTotal;
                $data[$index]['TotalTax']   += $invoiceComponent->TotalTax;
                $data[$index]['GrandTotal'] += $invoiceComponent->TotalCost;
            }

            // Product type
            // 0 = Account Level
            // 1 = Termination
            // 2 = Access
            // 3 = Package
            $ProductType = $invoiceComponent->ProductType;
            $Component = $invoiceComponent->Component;
            $Quantity  = (int)$invoiceComponent->Quantity;

            if(in_array($Component, ['OneOffCost', 'MonthlyCost'])){
                if(!isset($data[$index][$Component][$ProductType])) {
                    $data[$index][$Component][$ProductType] = [
                        'Title'     => self::getMonthlyTitle($invoiceComponent),
                        'Price'     => (float)$Quantity > 0 ? ($invoiceComponent->SubTotal / $Quantity) : 0,
                        'Discount'  => (float)$invoiceComponent->Discount,
                        'DiscountPrice' => (float)$invoiceComponent->DiscountPrice,
                        'Quantity'  => $Quantity,
                        'SubTotal'  => $invoiceComponent->SubTotal,
                        'TotalTax'  => $invoiceComponent->TotalTax,
                        'TotalCost' => $invoiceComponent->TotalCost,
                        'ID'        => $invoiceComponent->InvoiceComponentDetailID,
                    ];
                } else {

                    $arrData = $data[$index][$Component][$ProductType];

                    $arrData['Discount']  += (float)$invoiceComponent->Discount;
                    $arrData['DiscountPrice'] += (float)$invoiceComponent->DiscountPrice;
                    $arrData['Quantity']  += $Quantity;
                    $arrData['SubTotal']  += $invoiceComponent->SubTotal;
                    $arrData['TotalTax']  += $invoiceComponent->TotalTax;
                    $arrData['TotalCost'] += $invoiceComponent->TotalCost;

                    $arrData['Price'] = (float)$arrData['Quantity'] > 0.00000 ? ($arrData['SubTotal'] / $arrData['Quantity']) : 0;

                    $data[$index][$Component][$ProductType] = $arrData;
                }

            } else {

                $Title = self::getComponentTitle($invoiceComponent);

                $iSeconds = (float)$invoiceComponent->Duration;
                if(in_array($Component, self::$PerMinuteComponents)) {
                    $min = intval($iSeconds / 60);
                    $Quantity = (float)$min . '.' . str_pad(($iSeconds % 60), 2, '0', STR_PAD_LEFT);
                } else
                    $Quantity = (float)$invoiceComponent->Quantity;

                $UnitPrice = 0;
                if($Quantity > 0.00000){
                    $RemainingStandardPrice = (float)($invoiceComponent->SubTotal + $invoiceComponent->DiscountPrice);

                    if(in_array($Component, self::$PerMinuteComponents)) {
                        $UnitPrice = (float)($RemainingStandardPrice / $iSeconds) * 60;
                    } else {
                        $UnitPrice = $RemainingStandardPrice / $Quantity;
                    }
                }

                $data[$index]['components'][] = [
                    'Title'         => $Title,
                    'Type'          => $invoiceComponent->Type,
                    'Origination'   => $invoiceComponent->Origination,
                    'Component'     => $Component,
                    'Price'         => $UnitPrice != 0.000000 ? number_format($UnitPrice,$RoundChargesAmount) : 0,
                    'Discount'      => $invoiceComponent->Discount != 0 ? number_format($invoiceComponent->Discount,$RoundChargesAmount) : '',
                    'DiscountPrice' => $invoiceComponent->DiscountPrice != 0.00000 ? number_format($invoiceComponent->DiscountPrice,$RoundChargesAmount) : '',
                    'Duration'      => number_format($invoiceComponent->Duration,$RoundChargesAmount),
                    'Quantity'      => $Quantity > 0.00000 ? $Quantity : '',
                    'SubTotal'      => number_format($invoiceComponent->SubTotal,$RoundChargesAmount),
                    'TotalTax'      => number_format($invoiceComponent->TotalTax,$RoundChargesAmount),
                    'TotalCost'     => number_format($invoiceComponent->TotalCost,$RoundChargesAmount),
                    'ID'            => $invoiceComponent->InvoiceComponentDetailID,
                ];
            }
        }

        return $data;
    }


    public static function getComponentDataByCustomer($InvoiceDetailIDs, $RoundChargesAmount, $IsAffiliate = 0){
        $data = [];
        $InvoiceComponents = self::getComponentsData($InvoiceDetailIDs,$IsAffiliate);
        $InvoiceDetailIDs = is_array($InvoiceDetailIDs) ? $InvoiceDetailIDs : [$InvoiceDetailIDs];

        foreach($InvoiceComponents as $invoiceComponent){
            $index = $invoiceComponent->CLI ."_".$invoiceComponent->AccountServiceID."_".$invoiceComponent->CountryID;

            $CID = $invoiceComponent->CustomerID;
            if(!isset($data[$CID])){
                $data[$CID]['Name'] = $invoiceComponent->AccountName;
                $data[$CID]['OneOffSubTotal'] = InvoiceComponentDetail::where('Component', 'OneOffCost')
                    ->where(['CustomerID' => $CID, 'IsAffiliate' => $IsAffiliate])
                    ->whereIn('InvoiceDetailID', $InvoiceDetailIDs)
                    ->sum('SubTotal');

                $data[$CID]['MonthlySubTotal'] = InvoiceComponentDetail::where('Component', 'MonthlyCost')
                    ->where(['CustomerID' => $CID, 'IsAffiliate' => $IsAffiliate])
                    ->whereIn('InvoiceDetailID', $InvoiceDetailIDs)
                    ->sum('SubTotal');

                $data[$CID]['UsageSubTotal'] = InvoiceComponentDetail::whereIn('InvoiceDetailID', $InvoiceDetailIDs)
                    ->where(['CustomerID' => $CID, 'IsAffiliate' => $IsAffiliate])
                    ->whereNotIn('Component',['OneOffCost','MonthlyCost'])
                    ->sum('SubTotal');

                $data[$CID]['TotalVAT'] = InvoiceComponentDetail::whereIn('InvoiceDetailID', $InvoiceDetailIDs)
                    ->where(['CustomerID' => $CID, 'IsAffiliate' => $IsAffiliate])
                    ->sum('TotalTax');

                $data[$CID]['GrandTotal'] = InvoiceComponentDetail::whereIn('InvoiceDetailID', $InvoiceDetailIDs)
                    ->where(['CustomerID' => $CID, 'IsAffiliate' => $IsAffiliate])
                    ->sum('TotalCost');
            }

            if(!isset($data[$CID]['data'][$index])){
                $data[$CID]['data'][$index] = [
                    'AccountServiceID' => $invoiceComponent->AccountServiceID,
                    'CLI'        => $invoiceComponent->CLI,
                    'CustomerID' => $invoiceComponent->CustomerID,
                    'CountryID'  => $invoiceComponent->CountryID,
                    'PackageID'  => $invoiceComponent->PackageId,
                    'Prefix'     => $invoiceComponent->Prefix,
                    'SubTotal'   => $invoiceComponent->SubTotal,
                    'TotalTax'   => $invoiceComponent->TotalTax,
                    'GrandTotal' => $invoiceComponent->TotalCost,
                ];
            } else {
                $data[$CID]['data'][$index]['SubTotal']   += $invoiceComponent->SubTotal;
                $data[$CID]['data'][$index]['TotalTax']   += $invoiceComponent->TotalTax;
                $data[$CID]['data'][$index]['GrandTotal'] += $invoiceComponent->TotalCost;
            }

            // Product type
            // 0 = Account Level
            // 1 = Termination
            // 2 = Access
            // 3 = Package
            $ProductType = $invoiceComponent->ProductType;
            $Component = $invoiceComponent->Component;
            $Quantity  = (int)$invoiceComponent->Quantity;

            if(in_array($Component, ['OneOffCost', 'MonthlyCost'])){
                if(!isset($data[$CID]['data'][$index][$Component][$ProductType])) {
                    $data[$CID]['data'][$index][$Component][$ProductType] = [
                        'Title'     => self::getMonthlyTitle($invoiceComponent),
                        'Price'     => (float)$Quantity > 0 ? ($invoiceComponent->SubTotal / $Quantity) : 0,
                        'Discount'  => (float)$invoiceComponent->Discount,
                        'DiscountPrice' => (float)$invoiceComponent->DiscountPrice,
                        'Quantity'  => $Quantity,
                        'SubTotal'  => $invoiceComponent->SubTotal,
                        'TotalTax'  => $invoiceComponent->TotalTax,
                        'TotalCost' => $invoiceComponent->TotalCost,
                        'ID'        => $invoiceComponent->InvoiceComponentDetailID,
                    ];
                } else {

                    $arrData = $data[$CID]['data'][$index][$Component][$ProductType];

                    $arrData['Discount']  += (float)$invoiceComponent->Discount;
                    $arrData['DiscountPrice'] += (float)$invoiceComponent->DiscountPrice;
                    $arrData['Quantity']  += $Quantity;
                    $arrData['SubTotal']  += $invoiceComponent->SubTotal;
                    $arrData['TotalTax']  += $invoiceComponent->TotalTax;
                    $arrData['TotalCost'] += $invoiceComponent->TotalCost;

                    $arrData['Price'] = (float)$arrData['Quantity'] > 0 ? ($arrData['SubTotal'] / $arrData['Quantity']) : 0;

                    $data[$CID]['data'][$index][$Component][$ProductType] = $arrData;
                }

            } else {

                $Title = self::getComponentTitle($invoiceComponent);

                $iSeconds = (float)$invoiceComponent->Duration;
                if(in_array($Component, self::$PerMinuteComponents)) {
                    $min = intval($iSeconds / 60);
                    $Quantity = (float)$min . '.' . str_pad(($iSeconds % 60), 2, '0', STR_PAD_LEFT);
                } else
                    $Quantity = (float)$invoiceComponent->Quantity;

                $UnitPrice = 0;
                if($Quantity > 0.00000){
                    $RemainingStandardPrice = (float)($invoiceComponent->SubTotal + $invoiceComponent->DiscountPrice);

                    if(in_array($Component, self::$PerMinuteComponents)) {
                        $UnitPrice = (float)($RemainingStandardPrice / $iSeconds) * 60;
                    } else {
                        $UnitPrice = $RemainingStandardPrice / $Quantity;
                    }
                }

                $data[$CID]['data'][$index]['components'][] = [
                    'Title'         => $Title,
                    'Type'          => $invoiceComponent->Type,
                    'Origination'   => $invoiceComponent->Origination,
                    'Component'     => $Component,
                    'Price'         => $UnitPrice != 0.000000 ? number_format($UnitPrice,$RoundChargesAmount) : 0,
                    'Discount'      => $invoiceComponent->Discount != 0 ? number_format($invoiceComponent->Discount,$RoundChargesAmount) : '',
                    'DiscountPrice' => $invoiceComponent->DiscountPrice != 0.000000 ? number_format($invoiceComponent->DiscountPrice,$RoundChargesAmount) : '',
                    'Duration'      => number_format($invoiceComponent->Duration,$RoundChargesAmount),
                    'Quantity'      => $Quantity > 0.00000 ? $Quantity : '',
                    'SubTotal'      => number_format($invoiceComponent->SubTotal,$RoundChargesAmount),
                    'TotalTax'      => number_format($invoiceComponent->TotalTax,$RoundChargesAmount),
                    'TotalCost'     => number_format($invoiceComponent->TotalCost,$RoundChargesAmount),
                    'ID'            => $invoiceComponent->InvoiceComponentDetailID,
                ];
            }
        }

        return $data;
    }

}