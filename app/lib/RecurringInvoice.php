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

}