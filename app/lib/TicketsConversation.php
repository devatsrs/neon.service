<?php
namespace App\Lib;
use Illuminate\Support\Facades\Config;
use Maatwebsite\Excel\Facades\Excel;

class TicketsConversation extends \Eloquent {

    protected $table 		= 	 "tblTicketsConversation";
    protected $primaryKey 	= 	 "TicketConversationID";
	protected $guarded 		=	 array("TicketConversationID");
	protected $fillable		= 	 [];
}