<?php
namespace App\Lib;


class InvoiceHistory extends \Eloquent {
    protected $connection = 'sqlsrv2';
    protected $fillable = [];
    protected $guarded = array('InvoiceHistoryID');
    protected $table = 'tblInvoiceHistory';
    protected  $primaryKey = "InvoiceHistoryID";

    public static function addInvoiceHistoryDetail($InvoiceID,$AccountID, $InvoiceAccountType,$ServiceID,$FirstInvoiceSend,$Regenerate){
        $InvoiceHistoryDetail=array();
        $AccountBillings = AccountBilling::getBilling($AccountID,$ServiceID);
        $InvoiceHistoryDetail["InvoiceID"]=$InvoiceID;
        $InvoiceHistoryDetail["AccountID"]=$AccountID;
        $InvoiceHistoryDetail["BillingType"]=$AccountBillings->BillingType;
        $InvoiceHistoryDetail["BillingTimezone"]=$AccountBillings->BillingTimezone;
        $InvoiceHistoryDetail["BillingCycleType"]=$AccountBillings->BillingCycleType;
        $InvoiceHistoryDetail["BillingCycleValue"]=$AccountBillings->BillingCycleValue;
        $InvoiceHistoryDetail["BillingStartDate"] = $AccountBillings->BillingStartDate;
        if($Regenerate==0) {

            $InvoiceHistoryDetail["LastInvoiceDate"] = $AccountBillings->LastInvoiceDate;
            $InvoiceHistoryDetail["NextInvoiceDate"] = $AccountBillings->NextInvoiceDate;
            $InvoiceHistoryDetail["LastChargeDate"] = $AccountBillings->LastChargeDate;
            $InvoiceHistoryDetail["NextChargeDate"] = $AccountBillings->NextChargeDate;
        }else{
            /**
             * StartDate = 2018-04-02 00:00:00 , EndDate = 2018-04-08 23:59:59
             * LastInvoiceDate = 2018-04-02 , NextInvoiceDate = 2018-04-09
             * LastChargeDate = 2018-04-02 , NextChargeDate = 2018-04-08
            */
            $Product = $InvoiceAccountType != "Affiliate" ? Product::USAGE : Product::INVOICE_PERIOD;
            $StartDate = InvoiceDetail::where(["InvoiceID" => $InvoiceID, "ProductType" => $Product, "ServiceID" => $ServiceID])->pluck('StartDate');
            $StartDate = date("Y-m-d", strtotime($StartDate));
            $EndDate = InvoiceDetail::where(["InvoiceID" => $InvoiceID, "ProductType" => $Product, "ServiceID" => $ServiceID])->pluck('EndDate');
            $NextChargeDate = date("Y-m-d", strtotime($EndDate));
            $NextInvoiceDate = date("Y-m-d", strtotime("+1 Day", strtotime($NextChargeDate)));

            $InvoiceHistoryDetail["LastInvoiceDate"] = $StartDate;
            $InvoiceHistoryDetail["NextInvoiceDate"] = $NextInvoiceDate;
            $InvoiceHistoryDetail["LastChargeDate"] = $StartDate;
            $InvoiceHistoryDetail["NextChargeDate"] = $NextChargeDate;
        }
        $InvoiceHistoryDetail["ServiceID"]=$ServiceID;
        $InvoiceHistoryDetail["IssueDate"]=date("Y-m-d");
        $InvoiceHistoryDetail["FirstInvoice"]=$FirstInvoiceSend;
        InvoiceHistory::insert($InvoiceHistoryDetail);
    }

}