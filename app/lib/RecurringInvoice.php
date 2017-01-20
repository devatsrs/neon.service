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

    public static function GenerateRecurringInvoice($CompanyID,$ProcessID,$UserID,$date,$JobID,$InvoiceGenerationEmail)
    {
        Log::info(' ========================== Recurring invoice Start =============================');
        /* recurring template*/
        $recuringerrors = [];
        $notIn = [];
        $UserFullName = User::get_user_full_name($UserID);
        do {
            $recurringInvoiceIDs = RecurringInvoice::select(['RecurringInvoiceID'])
                ->where(['Status' => RecurringInvoice::ACTIVE])
                ->whereRaw("Date(NextInvoiceDate)<=DATE('" . $date . "')")
                ->whereNotIn('RecurringInvoiceID', $notIn)
                ->lists('RecurringInvoiceID');
            Log::info('recurring invoices ID');
            $selectedIDs = implode(',', $recurringInvoiceIDs);
            Log::info($selectedIDs);
            if (count($recurringInvoiceIDs) > 0) {
                foreach ($recurringInvoiceIDs as $RInvoiceID) {
                    $recurringInvoice = RecurringInvoice::find($RInvoiceID);
                    $AccountName = Account::getAccountName($recurringInvoice->AccountID);
                    try {
                        DB::beginTransaction();
                        DB::connection('sqlsrv2')->beginTransaction();
                        $sql = "call prc_CreateInvoiceFromRecurringInvoice (" . $CompanyID . ",'" . trim($RInvoiceID) . "','" . $UserFullName . "'," . RecurringInvoiceLog::GENERATE . ",'" . $ProcessID . "','" . $date . "')";
                        Log::info($sql);
                        $result = DB::connection('sqlsrv2')->select($sql);
                        if ($result[0]->InvoiceID > 0) {
                            DB::connection('sqlsrv2')->commit();
                            $recurringInvoice = RecurringInvoice::find($RInvoiceID);
                            $RecurringInvoiceData['NextInvoiceDate'] = next_billing_date($recurringInvoice->BillingCycleType, $recurringInvoice->BillingCycleValue, strtotime($recurringInvoice->NextInvoiceDate));
                            $RecurringInvoiceData['LastInvoicedDate'] = Date("Y-m-d H:i:s");
                            $recurringInvoice->update($RecurringInvoiceData);
                            DB::commit();
                        }else{
                            if (!empty($result[0]->message)) {
                                $recuringerrors[] = $result[0]->message;
                            }
                            DB::rollback();
                            DB::connection('sqlsrv2')->rollback();
                            $notIn[] = $RInvoiceID;
                            Log::info('Invoice rollback  RInvoiceID = ' . $RInvoiceID);
                            Log::info(' ========================== Error  =============================');
                            Log::info('Invoice with Error - ' . print_r($result, true));

                        }

                    } catch (\Exception $e) {

                        try {
                            $notIn[] = $RInvoiceID;
                            Log::error('Invoice Rollback RInvoiceID = ' . $RInvoiceID);
                            DB::rollback();
                            DB::connection('sqlsrv2')->rollback();
                            Log::error($e);

                            $recuringerrors[] = $AccountName . " " . $e->getMessage();


                        } catch (\Exception $err) {
                            Log::error($err);
                            $recuringerrors[] = $AccountName . " " . $e->getMessage() . ' ## ' . $err->getMessage();
                        }

                    }
                }
            }

        } while (RecurringInvoice::select(['RecurringInvoiceID'])
            ->where(['Status' => RecurringInvoice::ACTIVE])
            ->whereRaw("Date(NextInvoiceDate)<=DATE('" . $date . "')")
            ->whereNotIn('RecurringInvoiceID', $notIn)
            ->count());
        $joberror = RecurringInvoice::SendRecurringInvoice($CompanyID, $JobID, $ProcessID, $InvoiceGenerationEmail);
        Log::info(' Job Error');
        Log::info($joberror);
        Log::info(' Recurring invoice skipped ' . print_r($recuringerrors, true));
        Log::info(' ========================== Recurring invoice End =============================');

        return $recuringerrors;
    }

}