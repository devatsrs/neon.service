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

    public static function getRecurringInvoices($CompanyID,$UserFullName,$ProcessID,$joboptions){
        $date = date('Y-m-d H:i:s');
        $where=['AccountID'=>'','Status'=>'2','selectedIDs'=>''];
        if(isset($joboptions->criteria) && !empty($joboptions->criteria)){
            $criteria= json_decode($joboptions->criteria,true);
            if(!empty($criteria['AccountID'])){
                $where['AccountID']= $criteria['AccountID'];
            }
            $where['Status'] = $criteria['Status']==''?2:$criteria['Status'];
        }else{
            $where['selectedIDs']= $joboptions->selectedIDs;
        }

        $sql = "call prc_CreateInvoiceFromRecurringInvoice (".$CompanyID.",".intval($where['AccountID']).",".$where['Status'].",'".trim($where['selectedIDs'])."','".$UserFullName."',".RecurringInvoiceLog::GENERATE.",'".$ProcessID."','".$date."')";
        $result = DB::connection('sqlsrv2')->select($sql);
        if(!empty($result[0]->message)){
            $dberrormsg = $result[0]->message;
            Log::info($dberrormsg);
        }
        $InvoiceIDs = Invoice::where(['ProcessID' => $ProcessID])->select(['InvoiceID'])->lists('InvoiceID');
        return $InvoiceIDs;
    }

}