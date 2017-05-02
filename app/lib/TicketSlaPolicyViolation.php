<?php
namespace App\Lib;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class TicketSlaPolicyViolation extends \Eloquent {

    protected $table 		= 	"tblTicketSlaPolicyViolation";
    protected $primaryKey 	= 	"ViolationID";
	protected $guarded 		=	 array("ViolationID");	
	
	static $RespondedVoilationType   = 0;
	static $ResolvedVoilationType    = 1;
}

