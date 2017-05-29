<?php
namespace App\Lib;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Lib\User;
use App\Lib\Ticketfields;

class TicketLog extends \Eloquent 
{
    protected $guarded = array("TicketLogID");

    protected $table = 'tblTicketLog';

    protected $primaryKey = "TicketLogID";


    static  $defaultTicketLogFields = [
        'Type'=>Ticketfields::default_ticket_type,
        'Status'=>Ticketfields::default_status,
        'Priority'=>Ticketfields::default_priority,
        'Group'=>Ticketfields::default_group,
        'Agent'=>Ticketfields::default_agent
    ];


    public static function AddLog($TicketID,$array,$CompanyID){

	    if(isset($array['AccountID']) && $array['AccountID']>0){
            $UserID 	 	= 	0;
            $AccountID   	= 	$array['AccountID'];
        }else if(isset($array['UserID']) && $array['UserID'] >0){
            $UserID 		=  $array['UserID'];
            $AccountID  	=  0;
        }else{
			$AccountID  	= 	0; 
			$UserID 		= 	0;
			
		}
		
        $data = ['UserID' => $UserID,
            'AccountID' => $AccountID,
            'CompanyID' => $CompanyID,
            'TicketID' => $TicketID,
			"NewTicket" =>1,
            'created_at' => date("Y-m-d H:i:s")];
        TicketLog::insert($data);
    }

}