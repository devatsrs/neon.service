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

    public static function GenerateRecurringInvoice($CompanyID,$ProcessID,$UserID,$date,$JobID,$InvoiceGenerationEmail,$data)
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
                            $pdf_path = Invoice::generate_pdf($result[0]->InvoiceID, $data);
                            if(!empty($pdf_path)) {
                                $Invoice = Invoice::find($result[0]->InvoiceID);
                                $Invoice->update(["PDF" => $pdf_path]);
                                $recurringInvoice = RecurringInvoice::find($RInvoiceID);
                                $RecurringInvoiceData['NextInvoiceDate'] = next_billing_date($recurringInvoice->BillingCycleType, $recurringInvoice->BillingCycleValue, strtotime($recurringInvoice->NextInvoiceDate));
                                $RecurringInvoiceData['LastInvoicedDate'] = Date("Y-m-d H:i:s");
                                $recurringInvoice->update($RecurringInvoiceData);
                                $status = RecurringInvoice::SendRecurringInvoice($CompanyID, $JobID, $Invoice, $ProcessID, $InvoiceGenerationEmail, $data);
                                if ($status['status'] == 0) {
                                    $recuringerrors[] = $status['message'];
                                }
                                DB::commit();
                            }else{
                                DB::rollback();
                                DB::connection('sqlsrv2')->rollback();
                                $status['message'] = Invoice::$InvoiceGenrationErrorReasons["PDF"].' against invoice ID'.$Invoice->InvoiceID;
                                Log::info('Invoice rollback  InvoiceID = ' . $result[0]->InvoiceID);
                                Log::info(' ========================== Error  =============================');
                                Log::info($status['message']);
                                $recuringerrors[] = $status['message'];
                            }
                        }else{
                            if (!empty($result[0]->Message)) {
                                $recuringerrors[] = $result[0]->Message;
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
        Log::info('recurring errors'.print_r($recuringerrors,true));
        Log::info(' ========================== Recurring invoice End =============================');

        return $recuringerrors;
    }

    public static function SendRecurringInvoice($CompanyID,$JobID,$Invoice,$ProcessID,$InvoiceGenerationEmail,$data){
        $CompanyName = Company::getName($CompanyID);
        $status = ['status'=>1,'message'=>'invoice send successfully'];
        if(!empty($Invoice)) {
            $account = Account::find($Invoice->AccountID);
            $emailStatus = Invoice::EmailToCustomer($account, $Invoice->GrandTotal, $Invoice, '', $CompanyName, $CompanyID, $InvoiceGenerationEmail, $ProcessID, $JobID);
            if ($emailStatus['status'] == 'failure') {
                $status['status'] = 0;
                $status['message'] = $emailStatus['message'];
            }
        }
    }

}