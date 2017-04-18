<?php
namespace App\Lib;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class TicketSlaPolicyApplyTo extends \Eloquent {

    protected $table 		= 	"tblTicketSlaPolicyApplyTo";
    protected $primaryKey 	= 	"ApplyToID";
	protected $guarded 		=	 array("ApplyToID");	
}