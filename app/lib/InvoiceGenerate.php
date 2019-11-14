<?php
namespace App\Lib;

use Chumper\Zipper\Facades\Zipper;
use Illuminate\Support\Facades\App;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\View;
use Illuminate\Support\Str;
use Webpatser\Uuid\Uuid;

class InvoiceGenerate {

    public static $InvoiceGenerationErrorReasons = [
        "Email" =>  "Failed to send Email.",
        "InvoiceTemplate" => "No Invoice Template assigned",
        "AlreadyInvoiced" => "Account is already billed on this duration",
        "NoGateway" => "No Gateway set up",
        "NoCDR" => "CDR is missing or not Loaded yet",
        "UsageFile" => "Usage File Generation Failed",
        "PDF" => "Failed to create Invoice PDF",
        "NoUsage" => "No Usage or Subscription found",
        "InvalidAccount" => "No Account Exist",
    ];

    public static function getNextInvoiceNumber($CompanyID){
        $Company = Company::find($CompanyID);
        $NewInvoiceNumber =  ($Company->LastInvoiceNumber > 0)?($Company->LastInvoiceNumber + 1):1;
        while(Invoice::where([
                "InvoiceNumber" => $NewInvoiceNumber,
                'CompanyID'     => $CompanyID
            ])->count()>0){
            $NewInvoiceNumber++;
        }

        return $NewInvoiceNumber;
    }

    public static function GenerateInvoice($CompanyID,$AccountIDs,$InvoiceGenerationEmail,$ProcessID, $JobID)
    {

        Log::useFiles(storage_path() . '/logs/GenerateInvoice-' . date('Y-m-d') . '.log');
        $skip_accounts = array();
        $today = date("Y-m-d");
        $response = $errors = $message = array();

        foreach($AccountIDs as $AccountID){
            $Account = Account::find($AccountID);
            if($Account != false)
                $Account = json_decode(json_encode($Account),true);
            else
                return ['status' => 'failure', "message" => self::$InvoiceGenerationErrorReasons['InvalidAccount']];

            $AccountName = $Account['AccountName'];
            try {

                $AccountBilling = AccountBilling::where(['AccountID' => $AccountID])->first();

                // Check if 1st invoice sent
                $FirstInvoiceCheck = 0;
                if($AccountBilling->NextInvoiceDate == $AccountBilling->BillingStartDate) {
                    $InvoiceCount = Account::getInvoiceCount($AccountID);
                    if($InvoiceCount > 0) $FirstInvoiceCheck = 1;
                }

                $FirstInvoice       = $FirstInvoiceCheck;
                $LastChargeDate     = $AccountBilling->LastChargeDate;
                $NextChargeDate     = $AccountBilling->NextChargeDate;

                if($FirstInvoice == 1){
                    $NextInvoiceDate = $AccountBilling->BillingStartDate;
                    $LastInvoiceDate = $AccountBilling->BillingStartDate;
                }else{
                    $LastInvoiceDate = $AccountBilling->LastInvoiceDate;
                    $NextInvoiceDate = $AccountBilling->NextInvoiceDate;
                }

                Log::info('AccountID =' . $AccountID . ' FirstInvoiceSend '.$FirstInvoice);
                Log::info('LastInvoiceDate '.$LastInvoiceDate.' NextInvoiceDate '.$NextInvoiceDate);
                Log::info('LastChargeDate '.$LastChargeDate.' NextChargeDate '.$NextChargeDate);

                $BillingCycleType   = $AccountBilling->BillingCycleType;
                $BillingType        = $AccountBilling->BillingType;

                if (!empty($NextInvoiceDate) && $BillingCycleType != 'manual') {

                    if (strtotime($NextInvoiceDate) <= strtotime($today)) {

                        Log::info(' ========================== Invoice Send Start =============================');

                        DB::beginTransaction();
                        DB::connection('sqlsrv2')->beginTransaction();


                        Log::info('Invoice::sendInvoice(' . $CompanyID . ',' . $AccountID . ',' . $LastInvoiceDate . ',' . $NextInvoiceDate . ',' . implode(",", $InvoiceGenerationEmail) . ')');
                        $response = self::sendInvoice($CompanyID, $AccountID, $FirstInvoice, $LastInvoiceDate, $NextInvoiceDate, $InvoiceGenerationEmail, $ProcessID, $JobID);

                        Log::info('Invoice::sendInvoice done');

                        if (isset($response["status"]) && $response["status"] == 'success') {

                            Log::info('Invoice created - ' . print_r($response, true));
                            $message[] = $response["message"];
                            Log::info('Invoice Committed  AccountID = ' . $AccountID);
                            DB::connection('sqlsrv2')->commit();
                            Log::info('=========== Updating  InvoiceDate =========== ');
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
                            AccountBilling::where(['AccountID' => $AccountID])->update(["LastInvoiceDate" => $oldNextInvoiceDate, "NextInvoiceDate" => $NewNextInvoiceDate,'LastChargeDate'=>$NewLastChargeDate,'NextChargeDate'=>$NewNextChargeDate]);
                            $AccountNextBilling = AccountNextBilling::getBilling($AccountID,0);
                            if (!empty($AccountNextBilling)) {
                                AccountBilling::where(['AccountID' => $AccountID])->update(["BillingCycleType" => $AccountNextBilling->BillingCycleType, "BillingCycleValue" => $AccountNextBilling->BillingCycleValue, 'LastInvoiceDate' => $AccountNextBilling->LastInvoiceDate, 'NextInvoiceDate' => $AccountNextBilling->NextInvoiceDate]);
                                AccountNextBilling::where(['AccountID' => $AccountID])->delete();
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

                    } else
                        $skip_accounts[] = $AccountID;

                } else
                    $skip_accounts[] = $AccountID;

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
        }

        $response['errors'] = $errors;
        $response['message'] = $message;
        return $response;
    }


    public static function sendInvoice($CompanyID,$AccountID, $FirstInvoice,$LastInvoiceDate,$NextInvoiceDate,$InvoiceGenerationEmail,$ProcessID,$JobID){

        try {
            $Today=date('Y-m-d');
            $error = "";
            $CompanyName      = Company::getName($CompanyID);
            $Account          = Account::find($AccountID);
            $AccountBilling   = AccountBilling::where(['AccountID' => $AccountID])->first();
            $AccountBillingClass = AccountBilling::getBillingClass((int)$AccountID,0);
            $StartDate        = $AccountBilling->LastChargeDate;
            $EndDate          = $AccountBilling->NextChargeDate;
            $StartDate          = date("Y-m-d 00:00:00", strtotime($StartDate));
            $EndDate          = date("Y-m-d 23:59:59", strtotime($EndDate));
            Log::info('StartDate =' . $StartDate . " EndDate =" .$EndDate );

            $BillingCycleType   = $AccountBilling->BillingCycleType;
            $BillingType        = $AccountBilling->BillingType;

            if($AccountID <= 0 || $CompanyID <= 0 || empty($StartDate) || empty($EndDate))
                return ['status' => "failure", "message" => "Invalid Request."];

            if(empty($Account))
                return ['status' => "failure", "message" => "Invalid Account"];


            // Collecting Invoice Data

            $Reseller = Reseller::where('ChildCompanyID', $Account->CompanyId)->first();
            $message = isset($Reseller->InvoiceTo) ? $Reseller->InvoiceTo : '';
            $replace_array = Invoice::create_accountdetails($Account);
            $text = Invoice::getInvoiceToByAccount($message, $replace_array);
            $InvoiceToAddress = preg_replace("/(^[\r\n]*|[\r\n]+)[\s\t]*[\r\n]+/", "\n", $text);
            $Terms = isset($Reseller->TermsAndCondition) ? $Reseller->TermsAndCondition : '';
            $FooterTerm = isset($Reseller->FooterTerm) ? $Reseller->FooterTerm : '';
            $LastInvoiceNumber = self::getNextInvoiceNumber($CompanyID);
            $FullInvoiceNumber = Company::getCompanyField($CompanyID, "InvoiceNumberPrefix") . $LastInvoiceNumber;

            $decimal_places = Helper::get_round_decimal_places($CompanyID,$Account->AccountID);
            $isPostPaid = $BillingType === AccountBilling::BILLINGTYPE_POSTPAID;
            $AlreadyBilled=0;

            if($FirstInvoice == 0){
                $AlreadyBilled = self::checkIfAlreadyBilled($CompanyID,$AccountID, $StartDate, $EndDate);
                //If Already Billed
                if ($AlreadyBilled) {
                    $error = $Account->AccountName . ' ' . Invoice::$InvoiceGenrationErrorReasons["AlreadyInvoiced"];
                    return array("status" => "failure", "message" => $error);
                }
            }

            //If Account usage not already billed
            Log::info('AlreadyBilled '.$AlreadyBilled);

            //Creating Invoice
            $InvoiceData = array(
                "CompanyID" 	=> $CompanyID,
                "AccountID" 	=> $AccountID,
                "ServiceID" 	=> 0,
                "Address" 		=> $InvoiceToAddress,
                "IssueDate" 	=> $Today,
                "TotalDiscount" => 0,
                "CurrencyID" 	=> $Account->CurrencyId,
                "Note" 			=> "Auto Generated on " . $Today,
                "Terms" 		=> $Terms,
                'FooterTerm' 	=> $FooterTerm,
                "InvoiceStatus" => Invoice::AWAITING,
                "InvoiceNumber" => $LastInvoiceNumber,
                "FullInvoiceNumber" => $FullInvoiceNumber,
            );
            $Invoice = Invoice::insertInvoice($InvoiceData);
            $InvoiceID = $Invoice->InvoiceID;

            Log::error('$AccountID  '. $AccountID);
            Log::error('$isPostPaid  '. $isPostPaid);
            Log::error('$StartDate  '. $StartDate);
            Log::error('$EndDate  '. $EndDate);
            Log::error('$InvoiceID  '. $InvoiceID);
            if($isPostPaid){

                //AccountSubscription::addPostPaidSubscriptionInvoice($JobID,$CompanyID, $AccountID, $InvoiceID, $BillingType, $BillingCycleType, $StartDate, $EndDate, $FirstInvoice);
                //AccountOneOffCharge::addPostPaidOneOfChargeInvoice($JobID,$CompanyID, $AccountID, $InvoiceID);

                // Add Account service id
                //self::addPostPaidUsageInvoice($JobID,$CompanyID,$AccountID,$InvoiceID,$BillingType,$BillingCycleType,$StartDate,$EndDate,$FirstInvoice);

            } else {
                $AccountBalanceLogID = AccountBalanceLog::where([
                    'CompanyID' => $CompanyID,
                    'AccountID' => $AccountID
                ])->pluck('AccountBalanceLogID');

                if($AccountBalanceLogID != false) {
                    self::addPrepaidUsage($JobID,$CompanyID, $AccountID, $InvoiceID, $StartDate, $EndDate, $AccountBalanceLogID,$decimal_places,$Account->CurrencyId);
                    self::addPrepaidSubscription($JobID,$CompanyID, $AccountID, $InvoiceID, $StartDate, $EndDate, $AccountBalanceLogID,$decimal_places,$Account->CurrencyId);
                    self::addPrepaidOneOffCharge($JobID,$CompanyID, $AccountID, $InvoiceID, $StartDate, $EndDate, $AccountBalanceLogID,$decimal_places,$Account->CurrencyId);

                    Log::info('PDF Generation start');

                    /*$pdf_path = self::generate_pdf($InvoiceID);
                    if(empty($pdf_path)){
                        $error = self::$InvoiceGenerationErrorReasons["PDF"];
                        return array("status" => "failure", "message" => $error);
                    }else {
                        $Invoice->update(["PDF" => $pdf_path]);
                    }*/
                    return [
                        'status' => 'success',
                        'message' => $AccountID . ' Account Invoice added successfully'
                    ];
                }
            }
        } catch (\Exception $err) {
            Log::error($err);
            return ['status' => "failure", "message" => $AccountID . ": " . $err->getMessage()];
        }
    }

    public static function checkIfAlreadyBilled($CompanyID, $AccountID, $StartDate, $EndDate){
        $alreadyBilled = InvoiceDetail::leftJoin("tblInvoice","tblInvoice.InvoiceID", "=", "tblInvoiceDetail.InvoiceID")
            ->where([
                'tblInvoice.AccountID' => $AccountID,
                'tblInvoiceDetail.ProductType' => Product::USAGE,
                'tblInvoiceDetail.StartDate' => $StartDate,
                'tblInvoiceDetail.EndDate' => $EndDate,
            ])->first();

        return $alreadyBilled != false;
    }

    public static function addPrepaidUsage($JobID,$CompanyID,$AccountID,$InvoiceID,$StartDate,$EndDate, $AccountBalanceLogID,$decimal_places,$CurrencyID){
        $AccountBalanceUsageLog = AccountBalanceUsageLog::select(DB::raw("SUM(UsageAmount) AS SubTotal, SUM(TotalTax) AS TotalTax, SUM(TotalAmount) AS GrandTotal"))
            ->where([
                'AccountBalanceLogID' => $AccountBalanceLogID
            ])->where('Date', '>=', $StartDate)
            ->where('Date', '<=', $EndDate)
            ->first();


        $Invoice = Invoice::find($InvoiceID);
        $InvoiceSubTotal = $Invoice->SubTotal;
        $InvoiceTaxTotal = $Invoice->TotalTax;
        $InvoiceGrandTotal = $Invoice->GrandTotal;
        $InvoiceDetailArray = [];

        Log::error('Usage Start  ' . json_encode(!empty($AccountBalanceUsageLog)));
        if (!empty($AccountBalanceUsageLog)) {
            $ProductDescription = "From " . date("Y-m-d", strtotime($StartDate)) . " To " . date("Y-m-d", strtotime($EndDate));

            $InvoiceDetailArray = [
                'InvoiceID' => $InvoiceID,
                'ProductType' => Product::USAGE,
                'Description' => $ProductDescription,
                'Price' => number_format($AccountBalanceUsageLog->SubTotal, $decimal_places, '.', ''),
                'Qty' => 1,
                'CurrencyID' => $CurrencyID,
                'StartDate' => $StartDate,
                'EndDate' => $EndDate,
                'TaxAmount' => number_format($AccountBalanceUsageLog->TotalTax, $decimal_places, '.', ''),
                'DiscountType' => 0,
                'DiscountAmount' => 0,
                'DiscountLineAmount' => 0,
                'LineTotal' => number_format($AccountBalanceUsageLog->SubTotal, $decimal_places, '.', ''),
                //'TotalAmount' => $AccountBalanceUsageLog->GrandTotal,
            ];

            $InvoiceSubTotal += $AccountBalanceUsageLog->SubTotal;
            $InvoiceTaxTotal += $AccountBalanceUsageLog->TotalTax;
            $InvoiceGrandTotal += $AccountBalanceUsageLog->GrandTotal;
        }



        if(!empty($InvoiceDetailArray)){
            $InvoiceDetail = InvoiceDetail::create($InvoiceDetailArray);
            $InvoiceDetailID = $InvoiceDetail->InvoiceDetailID;

            self::addPrepaidInvoiceTaxRate($InvoiceID, $InvoiceDetailID, $AccountBalanceLogID, Product::USAGE, $StartDate, $EndDate);

            self::addUsageComponents($JobID,$CompanyID,$AccountID,$InvoiceID,$StartDate,$EndDate, $AccountBalanceLogID,$InvoiceDetailID);

            $Invoice->SubTotal = number_format($InvoiceSubTotal, $decimal_places, '.', '');
            $Invoice->TotalTax = number_format($InvoiceTaxTotal, $decimal_places, '.', '');
            $Invoice->GrandTotal = number_format($InvoiceGrandTotal, $decimal_places, '.', '');
            $Invoice->save();
        }
    }

    public static function addPrepaidInvoiceTaxRate($InvoiceID, $InvoiceDetailID, $AccountBalanceLogID, $ProductType, $StartDate, $EndDate){
        $taxRateData = $TaxRateLogs = [];
        if($ProductType == Product::USAGE){
            $TaxRateLogs = AccountBalanceTaxRateLog::join("tblAccountBalanceUsageLog as ul","ul.AccountBalanceUsageLogID","=","tblAccountBalanceTaxRateLog.ParentLogID")
                ->where([
                    'ul.AccountBalanceLogID' => $AccountBalanceLogID,
                    'tblAccountBalanceTaxRateLog.Type' => Product::USAGE,
                ])->where('ul.Date', '>=', $StartDate)
                ->where('ul.Date', '<=', $EndDate)
                ->get();
            Log::info("Usage Tax Rate Logs: " . $TaxRateLogs->count());
        } elseif ($ProductType == Product::SUBSCRIPTION){
            $TaxRateLogs = AccountBalanceTaxRateLog::join("tblAccountBalanceSubscriptionLog as sl","sl.AccountBalanceSubscriptionLogID","=","tblAccountBalanceTaxRateLog.ParentLogID")
                ->where([
                    'sl.AccountBalanceLogID' => $AccountBalanceLogID,
                    'tblAccountBalanceTaxRateLog.Type' => Product::SUBSCRIPTION,
                ])->where('sl.StartDate', '>=', $StartDate)
                ->where('sl.EndDate', '<=', $EndDate)
                ->get();
            Log::info("Subscription Tax Rate Logs: " . $TaxRateLogs->count());
        } elseif($ProductType == Product::ONEOFFCHARGE){
            $TaxRateLogs = AccountBalanceTaxRateLog::join("tblAccountBalanceSubscriptionLog as sl","sl.AccountBalanceSubscriptionLogID","=","tblAccountBalanceTaxRateLog.ParentLogID")
                ->where([
                    'sl.AccountBalanceLogID' => $AccountBalanceLogID,
                    'tblAccountBalanceTaxRateLog.Type' => Product::ONEOFFCHARGE,
                ])->where('sl.StartDate', '>=', $StartDate)
                ->where('sl.EndDate', '<=', $EndDate)
                ->get();
            Log::info("OneOffCharge Tax Rate Logs: " . $TaxRateLogs->count());
        }

        foreach($TaxRateLogs as $TaxRateLog){
            $taxRateData = array(
                "InvoiceID" => $InvoiceID,
                "InvoiceDetailID" => $InvoiceDetailID,
                "TaxRateID" => $TaxRateLog->TaxRateID,
                "TaxAmount" => $TaxRateLog->TaxAmount,
                "Title" => $TaxRateLog->Title,
            );

            InvoiceTaxRate::create($taxRateData);
        }

    }

    public static function addUsageComponents($JobID,$CompanyID,$AccountID,$InvoiceID,$StartDate,$EndDate, $AccountBalanceLogID,$InvoiceDetailID){
        $query = "CALL prc_addInvoicePrepaidComponents($CompanyID,$AccountID,$AccountBalanceLogID,$InvoiceDetailID,'$StartDate','$EndDate')";

        Log::error('prc_addCLIInvoiceComponents  '. $query);
        DB::connection('sqlsrv2')->select($query);
    }


    public static function addPrepaidSubscription($JobID,$CompanyID,$AccountID,$InvoiceID,$StartDate,$EndDate, $AccountBalanceLogID,$decimal_places,$CurrencyID, $ServiceID = 0, $AccountServiceID = 0){

        $AccountBalanceSubscriptionLogs = AccountBalanceSubscriptionLog::where([
            'AccountBalanceLogID' => $AccountBalanceLogID,
            'ServiceID'=>$ServiceID,
            'AccountServiceID'=>$AccountServiceID,
            'ProductType'=>Product::SUBSCRIPTION
        ])
            ->where('StartDate','>=',$StartDate)
            ->where('EndDate','<=',$EndDate)
            ->get();

        $Invoice                = Invoice::find($InvoiceID);
        $InvoiceSubTotal        = $Invoice->SubTotal;
        $InvoiceDiscountTotal   = $Invoice->TotalDiscount;
        $InvoiceTaxTotal        = $Invoice->TotalTax;
        $InvoiceGrandTotal      = $Invoice->GrandTotal;
        $SubscriptionArray      = [];

        Log::error('Subscription Start  ' . json_encode(count($AccountBalanceSubscriptionLogs)));
        foreach($AccountBalanceSubscriptionLogs as $AccountBalanceSubscriptionLog){

            $checkIfExist = InvoiceDetail::leftJoin("tblInvoice","tblInvoice.InvoiceID", "=", "tblInvoiceDetail.InvoiceID")
                ->where([
                    'tblInvoice.AccountID' => $AccountID,
                    'tblInvoiceDetail.AccountSubscriptionID' => $AccountBalanceSubscriptionLog->ParentID,
                    'tblInvoiceDetail.ProductType' => Product::SUBSCRIPTION,
                    'tblInvoiceDetail.StartDate' => $AccountBalanceSubscriptionLog->StartDate,
                    'tblInvoiceDetail.EndDate' => $AccountBalanceSubscriptionLog->EndDate,
                ])->first();

            if ($checkIfExist == false) {
                $InvoiceDetailArray = [
                    'InvoiceID' => $InvoiceID,
                    'ProductType' => Product::SUBSCRIPTION,
                    'Description' => $AccountBalanceSubscriptionLog->Description,
                    'Price' => $AccountBalanceSubscriptionLog->Price,
                    'Qty' => $AccountBalanceSubscriptionLog->Qty,
                    'CurrencyID' => $CurrencyID,
                    'StartDate' => $AccountBalanceSubscriptionLog->StartDate,
                    'EndDate' => $AccountBalanceSubscriptionLog->EndDate,
                    'TaxAmount' => (float)$AccountBalanceSubscriptionLog->TaxAmount ,
                    'DiscountType' => $AccountBalanceSubscriptionLog->DiscountType,
                    'DiscountAmount' => (float)$AccountBalanceSubscriptionLog->DiscountAmount,
                    'DiscountLineAmount' => (float)$AccountBalanceSubscriptionLog->DiscountLineAmount,
                    'LineTotal' => (float)$AccountBalanceSubscriptionLog->LineAmount,
                    //'TotalAmount' => $AccountBalanceSubscriptionLog->TotalAmount,
                    'AccountSubscriptionID' => $AccountBalanceSubscriptionLog->ParentID,
                ];

                $SubscriptionArray[] = $InvoiceDetailArray;
                $InvoiceSubTotal += $AccountBalanceSubscriptionLog->LineAmount;
                $InvoiceDiscountTotal += $AccountBalanceSubscriptionLog->DiscountAmount;
                $InvoiceTaxTotal += $AccountBalanceSubscriptionLog->TaxAmount;
                $InvoiceGrandTotal += $AccountBalanceSubscriptionLog->TotalAmount;


                $InvoiceDetail = InvoiceDetail::create($InvoiceDetailArray);
                $InvoiceDetailID = $InvoiceDetail->InvoiceDetailID;
                self::addPrepaidInvoiceTaxRate($InvoiceID, $InvoiceDetailID, $AccountBalanceLogID, Product::SUBSCRIPTION, $StartDate, $EndDate);
            }
        }

        if(count($SubscriptionArray) > 0){
            $Invoice->SubTotal = number_format($InvoiceSubTotal, $decimal_places, '.', '');
            $Invoice->TotalDiscount = number_format($InvoiceDiscountTotal, $decimal_places, '.', '');
            $Invoice->TotalTax = number_format($InvoiceTaxTotal, $decimal_places, '.', '');
            $Invoice->GrandTotal = number_format($InvoiceGrandTotal, $decimal_places, '.', '');
            $Invoice->save();
        }
    }

    public static function addPrepaidOneOffCharge($JobID,$CompanyID,$AccountID,$InvoiceID,$StartDate,$EndDate, $AccountBalanceLogID,$decimal_places,$CurrencyID, $ServiceID = 0, $AccountServiceID = 0){

        $AccountBalanceSubscriptionLogs = AccountBalanceSubscriptionLog::where([
            'AccountBalanceLogID' => $AccountBalanceLogID,
            'ServiceID'=>$ServiceID,
            'AccountServiceID'=>$AccountServiceID,
            'ProductType'=>Product::ONEOFFCHARGE
        ])
            ->where('StartDate','>=',$StartDate)
            ->where('EndDate','<=',$EndDate)
            ->get();

        $Invoice                = Invoice::find($InvoiceID);
        $InvoiceSubTotal        = $Invoice->SubTotal;
        $InvoiceDiscountTotal   = $Invoice->TotalDiscount;
        $InvoiceTaxTotal        = $Invoice->TotalTax;
        $InvoiceGrandTotal      = $Invoice->GrandTotal;
        $OneOffArray            = [];

        Log::error('OneOffCharge Start  ' . json_encode(count($AccountBalanceSubscriptionLogs)));
        foreach($AccountBalanceSubscriptionLogs as $AccountBalanceSubscriptionLog) {

            $checkIfExist = InvoiceDetail::leftJoin("tblInvoice","tblInvoice.InvoiceID", "=", "tblInvoiceDetail.InvoiceID")
                ->where([
                    'tblInvoice.AccountID' => $AccountID,
                    'tblInvoiceDetail.AccountOneOffChargeID' => $AccountBalanceSubscriptionLog->ParentID,
                    'tblInvoiceDetail.ProductType' => Product::ONEOFFCHARGE,
                    'tblInvoiceDetail.StartDate' => $AccountBalanceSubscriptionLog->StartDate,
                    'tblInvoiceDetail.EndDate' => $AccountBalanceSubscriptionLog->EndDate,
                ])->first();

            if ($checkIfExist == false) {
                $InvoiceDetailArray = [
                    'InvoiceID' => $InvoiceID,
                    'ProductType' => Product::ONEOFFCHARGE,
                    'Description' => $AccountBalanceSubscriptionLog->Description,
                    'Price' => $AccountBalanceSubscriptionLog->Price,
                    'Qty' => $AccountBalanceSubscriptionLog->Qty,
                    'CurrencyID' => $CurrencyID,
                    'StartDate' => $AccountBalanceSubscriptionLog->StartDate,
                    'EndDate' => $AccountBalanceSubscriptionLog->EndDate,
                    'TaxAmount' => (float)$AccountBalanceSubscriptionLog->TaxAmount,
                    'DiscountType' => $AccountBalanceSubscriptionLog->DiscountType,
                    'DiscountAmount' => (float)$AccountBalanceSubscriptionLog->DiscountAmount,
                    'DiscountLineAmount' => (float)$AccountBalanceSubscriptionLog->DiscountLineAmount,
                    'LineTotal' => (float)$AccountBalanceSubscriptionLog->LineAmount,
                    //'TotalAmount' => $AccountBalanceSubscriptionLog->TotalAmount,
                    'AccountOneOffChargeID' => $AccountBalanceSubscriptionLog->ParentID,
                ];

                $OneOffArray[] = $InvoiceDetailArray;
                $InvoiceSubTotal += $AccountBalanceSubscriptionLog->LineAmount;
                $InvoiceDiscountTotal += $AccountBalanceSubscriptionLog->DiscountAmount;
                $InvoiceTaxTotal += $AccountBalanceSubscriptionLog->TaxAmount;
                $InvoiceGrandTotal += $AccountBalanceSubscriptionLog->TotalAmount;

                $InvoiceDetail = InvoiceDetail::create($InvoiceDetailArray);
                $InvoiceDetailID = $InvoiceDetail->InvoiceDetailID;
                self::addPrepaidInvoiceTaxRate($InvoiceID, $InvoiceDetailID, $AccountBalanceLogID, Product::ONEOFFCHARGE, $StartDate, $EndDate);
            }
        }

        if(count($OneOffArray) > 0){
            $Invoice->SubTotal = number_format($InvoiceSubTotal, $decimal_places, '.', '');
            $Invoice->TotalDiscount = number_format($InvoiceDiscountTotal, $decimal_places, '.', '');
            $Invoice->TotalTax = number_format($InvoiceTaxTotal, $decimal_places, '.', '');
            $Invoice->GrandTotal = number_format($InvoiceGrandTotal, $decimal_places, '.', '');
            $Invoice->save();
        }
    }

    public static function addPostPaidUsageInvoice($JobID,$CompanyID, $AccountID, $InvoiceID, $BillingType, $BillingCycleType, $StartDate, $EndDate, $FirstInvoice){

    }

    public static function generate_pdf($InvoiceID){
        $Invoice = Invoice::find($InvoiceID);
        if($Invoice != false) {
            $language = Account::where("AccountID", $Invoice->AccountID)
                ->join('tblLanguage', 'tblLanguage.LanguageID', '=', 'tblAccount.LanguageID')
                ->join('tblTranslation', 'tblTranslation.LanguageID', '=', 'tblAccount.LanguageID')
                ->select('tblLanguage.ISOCode', 'tblTranslation.Language', 'tblLanguage.is_rtl')
                ->first();

            App::setLocale($language->ISOCode);


            $Account = Account::find($Invoice->AccountID);
            $AccountID = $Invoice->AccountID;
            $CompanyID = $Account->CompanyId;
            $Company = Company::find($CompanyID);
            $AccountBilling = AccountBilling::where(['AccountID' => $AccountID])->first();
            $UploadPath = CompanyConfiguration::get($CompanyID,'UPLOAD_PATH');
            $Currency = Currency::find($Account->CurrencyId);
            $CurrencyCode = !empty($Currency)?$Currency->Code:'';
            $CurrencySymbol =  Currency::getCurrencySymbol($Account->CurrencyId);
            $InvoiceDetails = InvoiceDetail::where(["InvoiceID" => $InvoiceID])->get();
            $decimal_places = Helper::get_round_decimal_places($CompanyID,$Account->AccountID);

            $Reseller = Reseller::where('ChildCompanyID', $CompanyID)->first();
            if (empty($Reseller->LogoUrl) || AmazonS3::unSignedUrl($Reseller->LogoAS3Key, $Account->CompanyId) == '') {
                $as3url =  public_path("/assets/images/250x100.png");
            } else {
                $as3url = (AmazonS3::unSignedUrl($Reseller->LogoAS3Key,$Account->CompanyId));
            }
            $logo_path = CompanyConfiguration::get('UPLOAD_PATH',$Account->CompanyId) . '/logo/' . $Account->CompanyId;
            @mkdir($logo_path, 0777, true);
            RemoteSSH::run("chmod -R 777 " . $logo_path);
            $logo = $logo_path  . '/'  . basename($as3url);
            file_put_contents($logo, file_get_contents($as3url));
            @chmod($logo,0777);

            $dateFormat = isset($Reseller->InvoiceDateFormat) ? $Reseller->InvoiceDateFormat : '';
            $common_name = Str::slug($Account->AccountName.'-'.$Invoice->FullInvoiceNumber.'-'.date(invoice_date_fomat($dateFormat),strtotime($Invoice->IssueDate)).'-'.$InvoiceID);

            $file_name = 'Invoice--' .$common_name . '.pdf';
            $htmlfile_name = 'Invoice--' .$common_name . '.html';


            $arrSignature=array();
            $arrSignature["UseDigitalSignature"] = CompanySetting::getKeyVal('UseDigitalSignature', $Account->CompanyId);
            $arrSignature["DigitalSignature"] = CompanySetting::getKeyVal('DigitalSignature', $Account->CompanyId);
            $arrSignature["signaturePath"]= CompanyConfiguration::get('UPLOAD_PATH')."/".AmazonS3::generate_upload_path(AmazonS3::$dir['DIGITAL_SIGNATURE_KEY'], '', $Account->CompanyId, true);
            if($arrSignature["DigitalSignature"]!="Invalid Key"){
                $arrSignature["DigitalSignature"]=json_decode($arrSignature["DigitalSignature"]);
            }else{
                $arrSignature["UseDigitalSignature"]=false;
            }
            $MultiCurrencies=array();
            if(isset($InvoiceTemplate) && $InvoiceTemplate->ShowTotalInMultiCurrency==1){
                $MultiCurrencies = Invoice::getTotalAmountInOtherCurrency($Account->CompanyId,$Account->CurrencyId,$Invoice->GrandTotal,$decimal_places);
            }

            $print_type = 'Invoice';
            $body = View::make('invoices.pdf', get_defined_vars())->render();

            $body = htmlspecialchars_decode($body);
            $footer = View::make('invoices.pdffooter', compact('Invoice','print_type'))->render();
            $footer = htmlspecialchars_decode($footer);

            $header = View::make('invoices.pdfheader', compact('Invoice','print_type'))->render();
            $header = htmlspecialchars_decode($header);

            $amazonPath = AmazonS3::generate_path(AmazonS3::$dir['INVOICE_UPLOAD'],$Account->CompanyId,$Invoice->AccountID) ;
            $destination_dir = CompanyConfiguration::get('UPLOAD_PATH',$Account->CompanyId) . '/'. $amazonPath;

            if (!file_exists($destination_dir)) {
                mkdir($destination_dir, 0777, true);
            }
            RemoteSSH::run("chmod -R 777 " . $destination_dir);

            $local_file = $destination_dir .  $file_name;

            $local_htmlfile = $destination_dir .  $htmlfile_name;
            file_put_contents($local_htmlfile,$body);
            @chmod($local_htmlfile,0777);
            $footer_name = 'footer-'. $common_name .'.html';
            $footer_html = $destination_dir.$footer_name;
            file_put_contents($footer_html,$footer);
            @chmod($footer_html,0777);

            $header_name = 'header-'. $common_name .'.html';
            $header_html = $destination_dir.$header_name;
            file_put_contents($header_html,$header);
            @chmod($footer_html,0777);

            $output= "";

            if(getenv('APP_OS') == 'Linux'){
                exec (base_path(). '/wkhtmltox/bin/wkhtmltopdf --header-spacing 3 --footer-spacing 1 --header-html "'.$header_html.'" --footer-html "'.$footer_html.'" "'.$local_htmlfile.'" "'.$local_file.'"',$output);

                if($arrSignature["UseDigitalSignature"]==true){
                    $newlocal_file = $destination_dir . str_replace(".pdf","-signature.pdf",$file_name);

                    $mypdfsignerOutput=RemoteSSH::run('PortableSigner  -n     -t '.$local_file.'      -o '.$newlocal_file.'     -s '.$arrSignature["signaturePath"].'digitalsignature.pfx -c "Signed after 4 alterations" -r "Approved for publication" -l "Department of Dermatology" -p Welcome100');
                    Log::info($mypdfsignerOutput);
                    if(file_exists($newlocal_file)){
                        RemoteSSH::run('rm '.$local_file);
                        RemoteSSH::run('mv '.$newlocal_file.' '.$local_file);
                    }
                }

            }else{
                exec (base_path().'/wkhtmltopdf/bin/wkhtmltopdf.exe --header-spacing 3 --footer-spacing 1 --header-html "'.$header_html.'" --footer-html "'.$footer_html.'" "'.$local_htmlfile.'" "'.$local_file.'"',$output);
            }
            @chmod($local_file,0777);
            Log::info($output);
            @unlink($local_htmlfile);
            @unlink($footer_html);
            @unlink($header_html);
            if (file_exists($local_file)) {
                $fullPath = $amazonPath . basename($local_file); //$destinationPath . $file_name;
                if (AmazonS3::upload($local_file, $amazonPath,$Account->CompanyId)) {
                    return $fullPath;
                }
            }
        }
        return '';
    }
}