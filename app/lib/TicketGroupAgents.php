<?php 
namespace App\Lib;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\View;

class TicketGroupAgents extends \Eloquent { 

    protected $table 		= 	"tblTicketGroupAgents";
    protected $primaryKey 	= 	"GroupAgentsID";
    protected $fillable 	= 	['GroupID'];
   // public    $timestamps 	= 	false; // no created_at and updated_at	
   
   static function get_group_agents($id,$select = 1,$fld = 'UserID')
	{
		if($select){
			$Groupagents    =   array("Select"=>0);
		}else{
			$Groupagents    =   array();
		}
		if($id)
		{
			$Groupagentsdb	=	TicketGroupAgents::where(["GroupID"=>$id])->get(); 
		}
		else
		{
			$Groupagentsdb	=	TicketGroupAgents::get(); 
		}
		
		foreach($Groupagentsdb as $Groupagentsdata){
			$userdata = 	User::find($Groupagentsdata->UserID);
			if($userdata){	
				
				$Groupagents[$userdata->FirstName." ".$userdata->LastName] =	$userdata->$fld; 
			}			
		} 
		return $Groupagents;
	}
	
}