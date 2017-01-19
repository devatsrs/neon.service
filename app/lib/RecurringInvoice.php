<?php
namespace App\Lib;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
class RecurringInvoice extends \Eloquent {
	
    protected $connection 	= 	'sqlsrv2';
    protected $fillable 	= 	[];
    protected $guarded 		= 	array('RecurringInvoiceID');
    protected $table 		= 	'tblRecurringInvoice';
    protected $primaryKey 	= 	"RecurringInvoiceID";
    const ACTIVE 			= 	1;
    const INACTIVE 				= 	0;


    public static function get_recurringinvoices_status(){
        return [''=>'All',self::ACTIVE=>'Active',self::INACTIVE=>'InActive'];
    }

    public static function SendRecurringInvoice($CompanyID,$JobID,$ProcessID,$InvoiceGenerationEmail){
        $InvoiceIDs = Invoice::where(['ProcessID' => $ProcessID])->select(['InvoiceID'])->lists('InvoiceID');
        $CompanyName = Company::getName($CompanyID);
        if(count($InvoiceIDs)>0) {
            $pdf_generation_error = [];
            $Products = Product::getAllProductName();
            $Taxes = TaxRate::getAllTaxName();
            $data['Products'] = $Products;
            $data['Taxes'] = $Taxes;
            foreach ($InvoiceIDs as $InvoiceID) {
                $Invoice = Invoice::find($InvoiceID);
                $status = RecurringInvoice::checkInvoiceStatus($Invoice, $data);
                if(!empty($status['error'])){
                    $pdf_generation_error[] = $status['error'];
                }
                if($status['status']==1) {
                    $account = Account::find($Invoice->AccountID);
                    Invoice::EmailToCustomer($account,$Invoice->GrandTotal,$Invoice,'',$CompanyName,$CompanyID,$InvoiceGenerationEmail,$ProcessID,$JobID);
                }
            }
            return $pdf_generation_error;
        }
    }

    public static function checkInvoiceStatus($Invoice,$data){
        $isSend = 1;
        $status = ['status'=>1,'error'=>''];
        $recurringInvoice = RecurringInvoice::find($Invoice->RecurringInvoiceID);
        $pdf_path = Invoice::generate_pdf($Invoice->InvoiceID,$data);
        if(empty($pdf_path)){
            $isSend = 0;
            $status['error'] = Invoice::$InvoiceGenrationErrorReasons["PDF"].' against invoice ID'.$Invoice->InvoiceID;
        }else{
            $Invoice->update(["PDF" => $pdf_path]);
        }
        $BillingClass = BillingClass::getBillingClass($recurringInvoice->BillingClassID);
        if($BillingClass->SendInvoiceSetting == 'after_admin_review'){
            $isSend = 0;
        }
        $status['status'] = $isSend;
        return $status;
    }

}