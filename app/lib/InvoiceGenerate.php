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

    public static function calculateTax($AccountID, $SubTotal){
        $Account = Account::find($AccountID);
        $Tax = 0;
        $TaxRates = explode(",", $Account->TaxRateID);
        foreach($TaxRates as $TaxRateID){

            $TaxRateID = intval($TaxRateID);

            if($TaxRateID>0){
                $TaxRate = TaxRate::where("TaxRateID",$TaxRateID)->first();
                if (isset($TaxRate->FlatStatus) && isset($TaxRate->Amount)) {
                    if ($TaxRate->FlatStatus == 1 && $SubTotal != 0) {
                        $Tax += $TaxRate->Amount;
                    } else {
                        $Tax += $SubTotal * ($TaxRate->Amount / 100);
                    }

                }
            }
        }

        return $Tax;
    }

    public static function calculateTaxFromGrandTotal($AccountID, $Total){
        $Account = Account::find($AccountID);
        $Tax = 0;
        $TaxRates = explode(",", $Account->TaxRateID);
        foreach($TaxRates as $TaxRateID){

            $TaxRateID = intval($TaxRateID);

            if($TaxRateID>0){
                $TaxRate = TaxRate::where("TaxRateID",$TaxRateID)->first();
                if (isset($TaxRate->FlatStatus) && isset($TaxRate->Amount)) {
                    if ($TaxRate->FlatStatus == 1 && $Total != 0) {
                        $Tax += $TaxRate->Amount;
                    } else {
                        $Tax += ($Total * $TaxRate->Amount) / (100 + $TaxRate->Amount);
                    }

                }
            }
        }

        return $Tax;
    }

    public static function checkIfAlreadyBilled($AccountID, $StartDate, $EndDate){
        $alreadyBilled = InvoiceDetail::leftJoin("tblInvoice","tblInvoice.InvoiceID", "=", "tblInvoiceDetail.InvoiceID")
            ->where([
                'tblInvoice.AccountID' => $AccountID,
                'tblInvoiceDetail.ProductType' => Product::USAGE,
                'tblInvoiceDetail.StartDate' => $StartDate,
                'tblInvoiceDetail.EndDate' => $EndDate,
            ])->first();

        return $alreadyBilled != false;
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
                $AlreadyBilled = self::checkIfAlreadyBilled($AccountID, $StartDate, $EndDate);
                //If Already Billed
                if ($AlreadyBilled) {
                    $error = $Account->AccountName . ' ' . Invoice::$InvoiceGenrationErrorReasons["AlreadyInvoiced"];
                    return array("status" => "failure", "message" => $error);
                }
            }

            //If Account usage not already billed
            Log::info('AlreadyBilled '. json_encode($AlreadyBilled));

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

            $AccountBalanceLogID = AccountBalanceLog::where([
                'AccountID' => $AccountID
            ])->pluck('AccountBalanceLogID');

            if($AccountBalanceLogID != false) {

                self::addInvoiceData($JobID,$CompanyID, $AccountID, $InvoiceID, $StartDate, $EndDate, $AccountBalanceLogID,$decimal_places,$Account->CurrencyId);

                return [
                    'status' => 'success',
                    'message' => $AccountID . ' Account Invoice added successfully'
                ];
            } else {
                return ['status' => "failure", "message" => $AccountID . ": Has no Balance Log ID"];
            }
        } catch (\Exception $err) {
            Log::error($err);
            return ['status' => "failure", "message" => $AccountID . ": " . $err->getMessage()];
        }
    }

    public static function addInvoiceData($JobID,$CompanyID,$AccountID,$InvoiceID,$StartDate,$EndDate, $AccountBalanceLogID,$decimal_places,$CurrencyID){

        $Account = Account::find($AccountID);
        // Fetching Usage Data
        $UsageGrandTotal = AccountBalanceUsageLog::where('AccountBalanceLogID', $AccountBalanceLogID)
            ->where('Date', '>=', $StartDate)
            ->where('Date', '<=', $EndDate)
            ->sum('TotalAmount');

        Log::error('Usage Total ' . $UsageGrandTotal);

        $UsageSubTotal = 0;
        $UsageTotalTax = 0;
        if($UsageGrandTotal > 0) {
            $TotalTax = self::calculateTaxFromGrandTotal($AccountID, $UsageGrandTotal);
            $UsageTotalTax = $TotalTax;
            $UsageSubTotal = $UsageGrandTotal - $TotalTax;
        }

        $ProductDescription = "From " . date("Y-m-d", strtotime($StartDate)) . " To " . date("Y-m-d", strtotime($EndDate));
        $TaxRates = !empty($Account->TaxRateID) ? explode(",", $Account->TaxRateID) : [];

        $InvoiceDetailArray = [
            'InvoiceID'          => $InvoiceID,
            'ProductType'        => Product::USAGE,
            'Description'        => $ProductDescription,
            'Price'              => number_format($UsageSubTotal, $decimal_places, '.', ''),
            'Qty'                => 1,
            'CurrencyID'         => $CurrencyID,
            'StartDate'          => $StartDate,
            'EndDate'            => $EndDate,
            'TaxRateID'          => isset($TaxRates[0]) ? $TaxRates[0] : 0,
            'TaxRateID2'         => isset($TaxRates[1]) ? $TaxRates[1] : 0,
            'TaxAmount'          => number_format($UsageTotalTax, $decimal_places, '.', ''),
            'DiscountType'       => 0,
            'DiscountAmount'     => 0,
            'DiscountLineAmount' => 0,
            'LineTotal'          => number_format($UsageSubTotal, $decimal_places, '.', '')
        ];

        $InvoiceDetail = InvoiceDetail::create($InvoiceDetailArray);

        $InvoiceDetailID = $InvoiceDetail->InvoiceDetailID;

        // Adding Monthly and Components data
        $query = "CALL prc_addInvoicePrepaidComponents($AccountID,$AccountBalanceLogID,$InvoiceID,$InvoiceDetailID,'$StartDate','$EndDate')";

        Log::error($query);
        DB::connection('sqlsrv2')->select($query);


        // Adding Monthly in Invoice Detail
        $Monthly = InvoiceComponentDetail::where('Component', 'Monthly')
            ->whereIn('InvoiceDetailID', $InvoiceDetailID)
            ->get();

        $MonthlyInvoiceDetail = [
            'InvoiceID'          => $InvoiceID,
            'ProductType'        => Product::SUBSCRIPTION,
            'Description'        => "Subscription",
            'Price'              => number_format($Monthly->sum('SubTotal'), $decimal_places, '.', ''),
            'Qty'                => 1,
            'CurrencyID'         => $CurrencyID,
            'StartDate'          => $StartDate,
            'EndDate'            => $EndDate,
            'TaxRateID'          => isset($TaxRates[0]) ? $TaxRates[0] : 0,
            'TaxRateID2'         => isset($TaxRates[1]) ? $TaxRates[1] : 0,
            'TaxAmount'          => number_format($Monthly->sum('TotalTax'), $decimal_places, '.', ''),
            'DiscountType'       => 0,
            'DiscountAmount'     => 0,
            'DiscountLineAmount' => 0,
            'LineTotal'          => number_format($Monthly->sum('SubTotal'), $decimal_places, '.', '')
        ];
        InvoiceDetail::create($MonthlyInvoiceDetail);


        // Adding OneOffCharge in Invoice Detail
        $OneOff = InvoiceComponentDetail::where('Component', 'OneOffCharge')
            ->whereIn('InvoiceDetailID', $InvoiceDetailID)
            ->get();

        $OneOffInvoiceDetail = [
            'InvoiceID'          => $InvoiceID,
            'ProductType'        => Product::ONEOFFCHARGE,
            'Description'        => "Subscription",
            'Price'              => number_format($OneOff->sum('SubTotal'), $decimal_places, '.', ''),
            'Qty'                => 1,
            'CurrencyID'         => $CurrencyID,
            'StartDate'          => $StartDate,
            'EndDate'            => $EndDate,
            'TaxRateID'          => isset($TaxRates[0]) ? $TaxRates[0] : 0,
            'TaxRateID2'         => isset($TaxRates[1]) ? $TaxRates[1] : 0,
            'TaxAmount'          => number_format($OneOff->sum('TotalTax'), $decimal_places, '.', ''),
            'DiscountType'       => 0,
            'DiscountAmount'     => 0,
            'DiscountLineAmount' => 0,
            'LineTotal'          => number_format($OneOff->sum('SubTotal'), $decimal_places, '.', '')
        ];
        InvoiceDetail::create($OneOffInvoiceDetail);


        // Adding Monthly Cost Total in Invoice
        $MonthlyCost = InvoiceComponentDetail::where('InvoiceDetailID', $InvoiceDetailID)
            ->whereIn('Component', ['OneOffCharge', 'Monthly'])->get();

        $MonthlySubtotal    = $MonthlyCost->sum('SubTotal');
        $MonthlyTax         = $MonthlyCost->sum('TotalTax');
        $MonthlyGrandTotal  = $MonthlyCost->sum('TotalCost');

        // Totals of Usage and Monthly Cost
        $InvoiceSubTotal    = $MonthlySubtotal + $UsageSubTotal;
        $InvoiceTaxTotal    = $MonthlyTax + $UsageTotalTax;
        $InvoiceGrandTotal  = $MonthlyGrandTotal + $UsageGrandTotal;

        //Updating Invoice Totals
        $Invoice = Invoice::find($InvoiceID);
        $Invoice->SubTotal = number_format($InvoiceSubTotal, $decimal_places, '.', '');
        $Invoice->TotalTax = number_format($InvoiceTaxTotal, $decimal_places, '.', '');
        $Invoice->GrandTotal = number_format($InvoiceGrandTotal, $decimal_places, '.', '');
        $Invoice->save();

        $InvoiceComponents = self::generatePdfComponentsData($InvoiceDetail, $decimal_places);
        $pdf_path = self::generate_pdf($InvoiceID, $InvoiceComponents);
        if(empty($pdf_path)){
            $error = self::$InvoiceGenerationErrorReasons["PDF"];
            return array("status" => "failure", "message" => $error);
        }else {
            $Invoice->update(["PDF" => $pdf_path]);
        }

        $ubl_path = self::generate_ubl_invoice($Invoice->InvoiceID,$InvoiceComponents,$decimal_places);
        if (empty($ubl_path)) {
            $error['message'] = 'Failed to generate Invoice UBL File.';
            $error['status'] = 'failure';
            return $error;
        } else {
            $Invoice->update(["UblInvoice" => $ubl_path]);
        }
    }

    public static function generate_pdf($InvoiceID, $InvoiceComponents){
        $Invoice = Invoice::find($InvoiceID);
        if($Invoice != false) {
            $language = Account::where("AccountID", $Invoice->AccountID)
                ->join('tblLanguage', 'tblLanguage.LanguageID', '=', 'tblAccount.LanguageID')
                ->join('tblTranslation', 'tblTranslation.LanguageID', '=', 'tblAccount.LanguageID')
                ->select('tblLanguage.ISOCode', 'tblTranslation.Language', 'tblLanguage.is_rtl')
                ->first();

            $AccountID  = $Invoice->AccountID;

            $Account    = Account::find($AccountID);
            $CompanyID  = $Account->CompanyId;
            $Company    = Company::find($CompanyID);

            $CurrencyID = $Invoice->CurrencyID;
            $Currency   = Currency::find($CurrencyID);
            $CurrencyCode   = !empty($Currency) ? $Currency->Code : '';
            $CurrencySymbol = Currency::getCurrencySymbol($CurrencyID);
            $RoundChargesAmount = Helper::get_round_decimal_places($AccountID);

            $AccountBilling = AccountBilling::where(['AccountID' => $AccountID])->first();
            $UploadPath     = CompanyConfiguration::get($CompanyID, 'UPLOAD_PATH');

            $InvoiceDetails = InvoiceDetail::where(["InvoiceID" => $InvoiceID])->get();

            // Calculating Start Date
            $StartDate        = $InvoiceDetails->first()->StartDate;
            $InvoicePeriod    = $InvoiceDetails != false ? date("M 'y", strtotime($StartDate)) : "";
            $InvoiceDetailIDs = InvoiceDetail::where(["InvoiceID" => $InvoiceID])->lists('InvoiceDetailID');

            // Getting total Monthly cost
            $MonthlySubTotal = InvoiceComponentDetail::where('Component', 'Monthly')
                ->whereIn('InvoiceDetailID', $InvoiceDetailIDs)
                ->sum('SubTotal');

            // Getting total OneOffCharge cost
            $OneOffSubTotal = InvoiceComponentDetail::where('Component', 'OneOffCharge')
                ->whereIn('InvoiceDetailID', $InvoiceDetailIDs)
                ->sum('SubTotal');

            // Getting total Usage cost
            $UsageSubTotal = InvoiceDetail::where([
                'InvoiceID' => $InvoiceID,
                'ProductType' => Product::USAGE
            ])->sum('LineTotal');

            $MonthlySubTotal    = number_format($MonthlySubTotal,$RoundChargesAmount);
            $OneOffSubTotal     = number_format($OneOffSubTotal,$RoundChargesAmount);
            $UsageSubTotal      = number_format($UsageSubTotal,$RoundChargesAmount);
            $TotalVAT           = number_format($Invoice->TotalTax,$RoundChargesAmount);
            $GrandTotal         = number_format($Invoice->GrandTotal,$RoundChargesAmount);

            $InvoiceComponents = self::generatePdfComponentsData($InvoiceDetailIDs, $RoundChargesAmount);

            Log::info("Component data " . json_encode($InvoiceComponents));
            $PageCounter = 1;
            $TotalPages = count($InvoiceComponents) + $PageCounter;

            App::setLocale($language->ISOCode);

            $Reseller = Reseller::where('ChildCompanyID', $CompanyID)->first();
            if (empty($Reseller->LogoUrl) || AmazonS3::unSignedUrl($Reseller->LogoAS3Key, $CompanyID) == '') {
                $as3url =  base_path().'/resources/assets/images/250x100.png';
            } else {
                $as3url = (AmazonS3::unSignedUrl($Reseller->CompanyLogoAS3Key,$CompanyID));
            }

            $logo_path = CompanyConfiguration::get($CompanyID,'UPLOAD_PATH');
            //@mkdir($logo_path, 0777, true);
            RemoteSSH::make_dir($CompanyID,$logo_path);
            //RemoteSSH::run($CompanyID,"chmod -R 777 " . $logo_path);
            $logo = $logo_path . '/' . basename($as3url);
            file_put_contents($logo, file_get_contents($as3url));
            //@chmod($logo, 0777);

            $dateFormat = !empty($Reseller->InvoiceDateFormat) ? $Reseller->InvoiceDateFormat : 'Y-m-d';
            $common_name = Str::slug($Account->AccountName . '-' . $Invoice->FullInvoiceNumber . '-' . date(invoice_date_fomat($dateFormat), strtotime($Invoice->IssueDate)) . '-' . $InvoiceID);

            $file_name = 'Invoice--' . $common_name . '.pdf';
            $htmlfile_name = 'Invoice--' . $common_name . '.html';

            $arrSignature = array();
            $arrSignature["UseDigitalSignature"] = CompanySetting::getKeyVal($CompanyID, 'UseDigitalSignature');
            $arrSignature["DigitalSignature"] = CompanySetting::getKeyVal($CompanyID, 'DigitalSignature');
            $arrSignature["signaturePath"]= CompanyConfiguration::get($CompanyID,'UPLOAD_PATH')."/".AmazonS3::generate_upload_path(AmazonS3::$dir['DIGITAL_SIGNATURE_KEY'], '', $CompanyID, true);
            if ($arrSignature["DigitalSignature"] != "Invalid Key") {
                $arrSignature["DigitalSignature"] = json_decode($arrSignature["DigitalSignature"]);
            } else {
                $arrSignature["UseDigitalSignature"] = false;
            }

            $MultiCurrencies = array();
            if (isset($InvoiceTemplate) && $InvoiceTemplate->ShowTotalInMultiCurrency == 1) {
                $MultiCurrencies = Invoice::getTotalAmountInOtherCurrency($Account->CompanyId, $Account->CurrencyId, $Invoice->GrandTotal, $RoundChargesAmount);
            }

            $PaymentDueInDays = AccountBilling::getPaymentDueInDays($Invoice->AccountID,0);

            $print_type = 'Invoice';
            $body = View::make('emails.invoices.newpdf', get_defined_vars())->render();
            $body = htmlspecialchars_decode($body);

            $footer = View::make('emails.invoices.pdffooter', get_defined_vars())->render();
            $footer = htmlspecialchars_decode($footer);

            $header = View::make('emails.invoices.pdfheader', get_defined_vars())->render();
            $header = htmlspecialchars_decode($header);

            $amazonPath = AmazonS3::generate_path(AmazonS3::$dir['INVOICE_UPLOAD'],$CompanyID,$Invoice->AccountID);
            $destination_dir = CompanyConfiguration::get($CompanyID, 'UPLOAD_PATH') . '/'. $amazonPath;

            if (!file_exists($destination_dir)) {
                RemoteSSH::make_dir($CompanyID,$destination_dir);
                //RemoteSSH::run($CompanyID, "mkdir -p " . $destination_dir);
                //RemoteSSH::run($CompanyID, "chmod -R 777 " . $destination_dir);
            }

            $local_file = $destination_dir .  $file_name;
            $local_htmlfile = $destination_dir .  $htmlfile_name;
            file_put_contents($local_htmlfile,$body);
            //@chmod($local_htmlfile,0777);
            $footer_name = 'footer-'. $common_name .'.html';
            $footer_html = $destination_dir.$footer_name;
            file_put_contents($footer_html,$footer);
            //@chmod($footer_html,0777);
            $header_name = 'header-'. $common_name .'.html';
            $header_html = $destination_dir.$header_name;
            file_put_contents($header_html,$header);
            //@chmod($footer_html,0777);

            $output= "";

            if(getenv('APP_OS') == 'Linux'){
                RemoteSSH::run($CompanyID, base_path(). '/wkhtmltox/bin/wkhtmltopdf --header-spacing 3 --footer-spacing 1 --header-html "'.$header_html.'" --footer-html "'.$footer_html.'" "'.$local_htmlfile.'" "'.$local_file.'"',$output);
                Log::info(base_path(). '/wkhtmltox/bin/wkhtmltopdf --header-spacing 3 --footer-spacing 1 --header-html --footer-html "'.$footer_html.'" "'.$local_htmlfile.'" "'.$local_file.'"');

                if($arrSignature["UseDigitalSignature"]==true){
                    Log::info("UseDigitalSignature true");
                    $newlocal_file = $destination_dir . str_replace(".pdf","-signature.pdf",$file_name);
                    $mypdfsignerOutput=RemoteSSH::run($CompanyID, 'PortableSigner  -n     -t '.$local_file.'      -o '.$newlocal_file.'     -s '.$arrSignature["signaturePath"].'digitalsignature.pfx -c "Signed after 4 alterations" -r "Approved for publication" -l "Department of Dermatology" -p Welcome100');
                    Log::info($mypdfsignerOutput);
                    if(file_exists($newlocal_file)){
                        RemoteSSH::run($CompanyID, 'rm '.$local_file);
                        RemoteSSH::run($CompanyID, 'mv '.$newlocal_file.' '.$local_file);
                    }
                }

            }else{
                Log::info("UseDigitalSignature false");
                exec (base_path().'/wkhtmltopdf/bin/wkhtmltopdf.exe --header-spacing 3 --footer-spacing 1 --header-html "'.$header_html.'" --footer-html "'.$footer_html.'" "'.$local_htmlfile.'" "'.$local_file.'"',$output);
                Log::info (base_path().'/wkhtmltopdf/bin/wkhtmltopdf.exe --header-spacing 3 --footer-spacing 1 --header-html "'.$header_html.'" --footer-html "'.$footer_html.'" "'.$local_htmlfile.'" "'.$local_file.'"',$output);
            }
            //@chmod($local_file,0777);
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


    public static function generatePdfComponentsData($InvoiceDetailIDs, $RoundChargesAmount){
        $data = [];
        //Getting all CLIs data
        $InvoiceComponents = DB::connection('sqlsrv2')
            ->table("tblInvoiceComponentDetail as id")
            ->select("tz.Title as Timezone","rt.Description as Destination","cli.CountryID","cli.Prefix","cli.PackageID","id.InvoiceComponentID","id.CLI","id.AccountServiceID","id.RateID","id.Component","id.Origination","id.Discount","id.DiscountPrice","id.Type","id.Quantity","id.Duration","id.SubTotal","id.TotalTax","id.TotalCost")
            ->join("speakintelligentRM.tblCLIRateTable as cli", function($join) {
                $join->on('cli.CLI', '=', 'id.CLI');
                $join->on('cli.AccountServiceID','=','id.AccountServiceID');
            })
            ->leftJoin("speakintelligentRM.tblTimezones as tz","tz.TimezonesID","=","id.TimezonesID")
            ->leftJoin("speakintelligentRM.tblRate as rt","rt.RateID","=","id.RateID")
            ->whereIn('id.InvoiceDetailID',$InvoiceDetailIDs)
            ->get();
        $PerCallComponents = ["CostPerCall", "SurchargePerCall", "OutpaymentCostPerCall"];

        foreach($InvoiceComponents as $invoiceComponent){
            $index = $invoiceComponent->CLI."_".$invoiceComponent->AccountServiceID."_".$invoiceComponent->CountryID;

            if(!isset($data[$index])){
                $data[$index] = [
                    'AccountServiceID' => $invoiceComponent->AccountServiceID,
                    'CLI'        => $invoiceComponent->CLI,
                    'CountryID'  => $invoiceComponent->CountryID,
                    'PackageID'  => $invoiceComponent->PackageID,
                    'Prefix'     => $invoiceComponent->Prefix,
                    'SubTotal'   => $invoiceComponent->SubTotal,
                    'TotalTax'   => $invoiceComponent->TotalTax,
                    'GrandTotal' => $invoiceComponent->TotalCost,
                ];
            } else {
                $data[$index]['SubTotal']   += $invoiceComponent->SubTotal;
                $data[$index]['TotalTax']   += $invoiceComponent->TotalTax;
                $data[$index]['GrandTotal'] += $invoiceComponent->TotalCost;
            }

            $Component = $invoiceComponent->Component;
            $Quantity  = (int)$invoiceComponent->Quantity;

            if(in_array($Component, ['OneOffCharge', 'Monthly'])){
                if(!isset($data[$index][$Component])) {
                    $data[$index][$Component] = [
                        'Price'     => (float)$Quantity > 0 ? ($invoiceComponent->SubTotal / $Quantity) : 0,
                        'Discount'  => (float)$invoiceComponent->Discount,
                        'DiscountPrice' => (float)$invoiceComponent->DiscountPrice,
                        'Quantity'  => $Quantity,
                        'SubTotal'  => $invoiceComponent->SubTotal,
                        'TotalTax'  => $invoiceComponent->TotalTax,
                        'TotalCost' => $invoiceComponent->TotalCost,
                        'ID'        => $invoiceComponent->InvoiceComponentID,
                    ];
                }
            } else {

                $Title = "";

                if($invoiceComponent->Type == "Outbound")
                    $Title = cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_COMPONENT_LBL_TERMINATION");

                if($Component == "RecordingCostPerMinute"){
                    $Title .= cus_lang("PAGE_INVOICE_PDF_LBL_COMPONENT_RECORDING_COST_PER_MINUTE");
                } elseif($Component == "PackageCostPerMinute"){
                    $Title .= cus_lang("PAGE_INVOICE_PDF_LBL_COMPONENT_PACKAGE_COST_PER_MINUTE");
                } elseif($Component == "SurchargePerMinute") {
                    $Title .= cus_lang("PAGE_INVOICE_PDF_LBL_SURCHARGE_PER_MINUTE");
                } elseif($Component == "SurchargePerCall") {
                    $Title .= cus_lang("PAGE_INVOICE_PDF_LBL_COMPONENT_SURCHARGE_PER_CALL");
                } elseif($Component == "CollectionCostAmount") {
                    $Title .= cus_lang("PAGE_INVOICE_PDF_LBL_COMPONENT_COLLECTION_COST_AMOUNT");
                } elseif($Component == "CostPerCall") {
                    $Title .= cus_lang("PAGE_INVOICE_PDF_LBL_COMPONENT_COST_PER_CALL");
                } elseif($Component == "CostPerMinute") {
                    $Title .= cus_lang("PAGE_INVOICE_PDF_LBL_COMPONENT_COST_PER_MINUTE");
                } elseif($Component == "OutpaymentPerMinute") {
                    $Title .= cus_lang("PAGE_INVOICE_PDF_LBL_COMPONENT_OUTPAYMENT_PER_MINUTE");
                } elseif($Component == "OutpaymentPerCall") {
                    $Title .= cus_lang("PAGE_INVOICE_PDF_LBL_COMPONENT_OUTPAYMENT_PER_CALL");
                } elseif($Component == "Chargeback") {
                    $Title .= cus_lang("PAGE_INVOICE_PDF_LBL_COMPONENT_CHARGEBACK");
                } elseif($Component == "Surcharges") {
                    $Title .= cus_lang("PAGE_INVOICE_PDF_LBL_COMPONENT_SURCHARGE");
                } else {
                    $Title .= $Component;
                }

                if($invoiceComponent->Destination != "")
                    $Title .= " " . $invoiceComponent->Destination;

                if($invoiceComponent->Origination != "")
                    $Title .= " of " . $invoiceComponent->Origination;

                if($invoiceComponent->Timezone != "")
                    $Title .= " " . $invoiceComponent->Timezone;

                $UnitPrice = 0;
                if(in_array($Component,$PerCallComponents) && $Quantity > 0){
                    $UnitPrice = (float)$invoiceComponent->TotalCost / $Quantity;
                }

                $Quantity = in_array($Component,$PerCallComponents) ? $invoiceComponent->Quantity : $invoiceComponent->Duration / 60;

                $data[$index]['components'][] = [
                    'Title'         => $Title,
                    'Type'          => $invoiceComponent->Type,
                    'Origination'   => $invoiceComponent->Origination,
                    'Component'     => $Component,
                    'Price'         => $UnitPrice > 0 ? number_format($UnitPrice,$RoundChargesAmount) : '',
                    'Discount'      => $invoiceComponent->Discount > 0 ? number_format($invoiceComponent->Discount,$RoundChargesAmount) : '',
                    'DiscountPrice' => $invoiceComponent->DiscountPrice > 0 ? number_format($invoiceComponent->DiscountPrice,$RoundChargesAmount) : '',
                    'Duration'      => number_format($invoiceComponent->Duration,$RoundChargesAmount),
                    'Quantity'      => $Quantity > 0 ? number_format($Quantity,0) : '',
                    'SubTotal'      => number_format($invoiceComponent->SubTotal,$RoundChargesAmount),
                    'TotalTax'      => number_format($invoiceComponent->TotalTax,$RoundChargesAmount),
                    'TotalCost'     => number_format($invoiceComponent->TotalCost,$RoundChargesAmount),
                    'ID'            => $invoiceComponent->InvoiceComponentID,
                ];
            }
        }

        return $data;
    }

    public static  function generate_ubl_invoice($InvoiceID, $InvoiceComponents, $RoundChargesAmount){
        if($InvoiceID>0) {
            $Invoice = Invoice::find($InvoiceID);
            $Account = Account::find($Invoice->AccountID);
            $common_name = Str::slug($Account->AccountName.'-'.$Invoice->FullInvoiceNumber.'-'.date("Y-m-d",strtotime($Invoice->IssueDate)).'-'.$InvoiceID);

            $file_name = 'Invoice--' .$common_name . '.xml';
            $body = self::ublInvoice($Invoice, $Account, $InvoiceComponents, $RoundChargesAmount);

            $amazonPath = AmazonS3::generate_path(AmazonS3::$dir['INVOICE_UPLOAD'],$Account->CompanyId,$Invoice->AccountID) ;
            $destination_dir = CompanyConfiguration::get('UPLOAD_PATH',$Account->CompanyId) . '/'. $amazonPath;

            if (!is_dir($destination_dir)) {
                mkdir($destination_dir, 0775, true);
            }

            $local_file = $destination_dir . $file_name;
            file_put_contents($local_file, $body);
            @chmod($local_file,0775);

            RemoteSSH::run("chmod -R 775 " . $destination_dir);
            if (file_exists($local_file)) {
                $fullPath = $amazonPath . basename($local_file); //$destinationPath . $file_name;
                if (AmazonS3::upload($local_file, $amazonPath,$Account->CompanyId)) {
                    return $fullPath;
                }
            }
            return '';
        }
    }

    public static function ublInvoice($Invoice, $Account, $InvoiceComponents, $RoundChargesAmount){
        $AccountID      = $Account->AccountID;
        $CompanyID      = $Account->CompanyId;
        $InvoiceID      = $Invoice->InvoiceID;
        $BillingClass   = AccountBilling::getBillingClass((int)$AccountID,0);
        $CompanyData    = Company::findOrFail($CompanyID);
        $CompanyAddr    = Company::getCompanyAddress($CompanyID);
        $AccountAddress = Account::getAddress($Account);
        $CurrencyID = !empty($Invoice->CurrencyID) ? $Invoice->CurrencyID : $Account->CurrencyId;
        $Currency = Currency::find($CurrencyID);
        $CurrencyCode = !empty($Currency) ? $Currency->Code : '';

        $generator = new \App\UblInvoice\Generator();
        $legalMonetaryTotal = new \App\UblInvoice\LegalMonetaryTotal();

// company address
        $companyAddress = new \App\UblInvoice\Address();
        if(!empty($CompanyAddr))
            $companyAddress->setStreetName($CompanyAddr);

        if (!empty($CompanyData->City))
            $companyAddress->setCityName($CompanyData->City);

        if (!empty($CompanyData->PostCode))
            $companyAddress->setPostalZone($CompanyData->PostCode);

        if (!empty($CompanyData->Country)) {
            $countryCode = Country::getCountryCodeByName($CompanyData->Country);
            $country = new \App\UblInvoice\Country();
            $country->setIdentificationCode($countryCode);
            $companyAddress->setCountry($country);
        }
// company
        $company  = new \App\UblInvoice\Party();
        $company->setName($CompanyData->CompanyName);
        $company->setPostalAddress($companyAddress);

// client address
        $clientAddress = new \App\UblInvoice\Address();

        if(!empty($AccountAddress))
            $clientAddress->setStreetName($AccountAddress);

        if (!empty($Account->City))
            $clientAddress->setCityName($Account->City);

        if (!empty($Account->PostCode))
            $clientAddress->setPostalZone($Account->PostCode);

        if (!empty($Account->Country)) {
            $countryCode = Country::getCountryCodeByName($Account->Country);
            $country = new \App\UblInvoice\Country();
            $country->setIdentificationCode($countryCode);
            $clientAddress->setCountry($country);
        }

// client
        $client = new \App\UblInvoice\Party();
        $client->setName($Account->AccountName);
        $client->setPostalAddress($clientAddress);
        $invoiceLines = [];
        $unitCode = 'A9';
        $InvoiceDetails   = InvoiceDetail::where(["InvoiceID" => $InvoiceID])->get();
        $StartDate        = $InvoiceDetails->first()->StartDate;
        $InvoicePeriod    = $InvoiceDetails != false ? date("M 'y", strtotime($StartDate)) : "";


        foreach($InvoiceComponents as $InvoiceComponent) {
            //product
            $description = Country::getCountryCode($InvoiceComponent['CountryID']) . " " . $InvoiceComponent['Prefix'] . "-" . $InvoiceComponent['CLI'];
            if(isset($InvoiceComponent['Monthly']) && !empty($InvoiceComponent['Monthly'])){
                $item = new \App\UblInvoice\Item();
                $item->setName(cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_MONTHLY_COST") . " " . $InvoicePeriod);
                $item->setDescription($description);
                $item->setSellersItemIdentification(Product::SUBSCRIPTION);

                //price
                $price = new \App\UblInvoice\Price();
                $price->setBaseQuantity($InvoiceComponent['Monthly']['Quantity']);
                $price->setUnitCode($unitCode);
                $price->setPriceAmount($InvoiceComponent['Monthly']['Price']);

                //line
                $invoiceLine = new \App\UblInvoice\InvoiceLine();
                $invoiceLine->setId($InvoiceComponent['Monthly']['ID']);
                $invoiceLine->setItem($item);

                $invoiceLine->setPrice($price);
                $invoiceLine->setUnitCode($unitCode);
                $invoiceLine->setInvoicedQuantity($InvoiceComponent['Monthly']['Quantity']);
                $invoiceLine->setLineExtensionAmount(number_format($InvoiceComponent['Monthly']['SubTotal'], $RoundChargesAmount));
                $invoiceLine->setTaxTotal($InvoiceComponent['Monthly']['TotalTax']);
                $invoiceLines[] = $invoiceLine;
            }

            if(isset($InvoiceComponent['OneOffCharge']) && !empty($InvoiceComponent['OneOffCharge'])){
                $item = new \App\UblInvoice\Item();
                $item->setName(cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_ADDITIONAL"));
                $item->setDescription($description);
                $item->setSellersItemIdentification(Product::ONEOFFCHARGE);

                //price
                $price = new \App\UblInvoice\Price();
                $price->setBaseQuantity($InvoiceComponent['OneOffCharge']['Quantity']);
                $price->setUnitCode($unitCode);
                $price->setPriceAmount($InvoiceComponent['OneOffCharge']['Price']);

                //line
                $invoiceLine = new \App\UblInvoice\InvoiceLine();
                $invoiceLine->setId($InvoiceComponent['OneOffCharge']['ID']);
                $invoiceLine->setItem($item);

                $invoiceLine->setPrice($price);
                $invoiceLine->setUnitCode($unitCode);
                $invoiceLine->setInvoicedQuantity($InvoiceComponent['OneOffCharge']['Quantity']);
                $invoiceLine->setLineExtensionAmount(number_format($InvoiceComponent['OneOffCharge']['SubTotal'], $RoundChargesAmount));
                $invoiceLine->setTaxTotal($InvoiceComponent['OneOffCharge']['TotalTax']);
                $invoiceLines[] = $invoiceLine;
            }
            if(isset($InvoiceComponent['components']) && count($InvoiceComponent['components'])>0){
                foreach($InvoiceComponent['components'] as $component => $comp){
                    if($comp['Quantity'] != 0){

                        $item = new \App\UblInvoice\Item();
                        $item->setName($comp['Title']);
                        $item->setDescription($description);
                        $item->setSellersItemIdentification(Product::USAGE);

                        //price
                        $price = new \App\UblInvoice\Price();
                        $price->setBaseQuantity($comp['Quantity']);
                        $price->setUnitCode($unitCode);
                        $price->setPriceAmount($comp['Price']);

                        //line
                        $invoiceLine = new \App\UblInvoice\InvoiceLine();
                        $invoiceLine->setId($comp['ID']);
                        $invoiceLine->setItem($item);

                        $invoiceLine->setPrice($price);
                        $invoiceLine->setUnitCode($unitCode);
                        $invoiceLine->setInvoicedQuantity($comp['Quantity']);
                        $invoiceLine->setLineExtensionAmount($comp['SubTotal']);
                        $invoiceLine->setTaxTotal($comp['TotalTax']);
                        $invoiceLines[] = $invoiceLine;
                    }
                }
            }
        }

// taxe TVA
        $TaxScheme    = new \App\UblInvoice\TaxScheme();
        $TaxScheme->setId(0);
        $taxCategory = new \App\UblInvoice\TaxCategory();
        $tax = $Account->TaxRateID != "" ? explode(",",$Account->TaxRateID) : "";
        $tax = !empty($tax) ? TaxRate::find($tax[0]) : false;
        $tax = $tax != false ? $tax->Title : "";
        $taxPercentage = number_format(((float)$Invoice->TotalTax / (float)$Invoice->GrandTotal) * 100, 2);
        $taxCategory->setId($Account->TaxRateID);
        $taxCategory->setName($tax);
        $taxCategory->setPercent($taxPercentage);
        $taxCategory->setTaxScheme($TaxScheme);
// taxes
        $taxTotal    = new \App\UblInvoice\TaxTotal();
        $taxSubTotal = new \App\UblInvoice\TaxSubTotal();
        $taxSubTotal->setTaxableAmount($Invoice->SubTotal);
        $taxSubTotal->setTaxAmount($Invoice->TotalTax);
        $taxSubTotal->setTaxCategory($taxCategory);
        $taxTotal->addTaxSubTotal($taxSubTotal);
        $taxTotal->setTaxAmount($taxSubTotal->getTaxAmount());

        $issueDate = \Carbon\Carbon::createFromFormat('Y-m-d H:i:s', $Invoice->IssueDate);
        $dueDate = \Carbon\Carbon::createFromFormat('Y-m-d H:i:s', $Invoice->IssueDate)->addDays($BillingClass->PaymentDueInDays);

// invoice
        $invoice = new \App\UblInvoice\Invoice();
        $invoice->setId($Invoice->FullInvoiceNumber);
        $invoice->setIssueDate($issueDate);
        $invoice->setDueDate($dueDate);
        $invoice->setCurrencyCode($CurrencyCode);
        $invoice->setNote($Invoice->Note);
        $invoice->setTerms("Expect payment within {$BillingClass->PaymentDueInDays} days.");
        $invoice->setInvoiceTypeCode($Invoice->InvoiceType);
        $invoice->setAccountingSupplierParty($company);
        $invoice->setAccountingCustomerParty($client);
        $invoice->setInvoiceLines($invoiceLines);
        $legalMonetaryTotal->setTaxExclusiveAmount($Invoice->SubTotal);
        $legalMonetaryTotal->setLineExtensionAmount($Invoice->SubTotal);
        $legalMonetaryTotal->setTaxInclusiveAmount($Invoice->GrandTotal);
        $legalMonetaryTotal->setPayableAmount($Invoice->GrandTotal);
        $legalMonetaryTotal->setAllowanceTotalAmount($Invoice->TotalDiscount);
        $invoice->setLegalMonetaryTotal($legalMonetaryTotal);
        $invoice->setTaxTotal($taxTotal);

        if($Invoice->PDF != "") {
            $additionalDocument = new \App\UblInvoice\AdditionalDocumentReference();
            $additionalDocument->setAttachment(AmazonS3::preSignedUrl($Account->PDF));
            $additionalDocument->setDocumentType("Invoice");
            $additionalDocument->setId("01");
            $invoice->setAdditionalDocumentReference($additionalDocument);
        }
        return $generator->invoice($invoice, $CurrencyCode);
    }
}