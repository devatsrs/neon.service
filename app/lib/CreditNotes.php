<?php
namespace App\Lib;

use Chumper\Zipper\Facades\Zipper;
use Illuminate\Support\Facades\App;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\View;
use Illuminate\Support\Str;
use Webpatser\Uuid\Uuid;

class CreditNotes extends \Eloquent {
    protected $connection = 'sqlsrv2';
    protected $fillable = [];
    protected $guarded = array('CreditNotesID');
    protected $table = 'tblCreditNotes';
    protected  $primaryKey = "CreditNotesID";
    const  INVOICE_OUT = 1;
    const  INVOICE_IN= 2;
    const OPEN = 'open';
    const CLOSE = 'close';
    const DRAFT = 'draft';
    const SEND = 'send';
    const AWAITING = 'awaiting';
    const CANCEL = 'cancel';
    const RECEIVED = 'received';
    const PAID = 'paid';
    const PARTIALLY_PAID = 'partially_paid';
    const ITEM_INVOICE =1;
	const EMAILTEMPLATE 		= "CreditNotesSingleSend";
	

}