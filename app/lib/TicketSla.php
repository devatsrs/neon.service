<?php

namespace App\Lib;
use App\Lib\TicketSlaPolicyViolation;
use App\Lib\TicketSlaPolicyApplyTo;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class TicketSla extends \Eloquent
{
	protected $table 		= 	"tblTicketSla";
    protected $primaryKey 	= 	"TicketSlaID";
	protected $guarded 		=	 array("TicketSlaID");	
    /**
     * Assign SLA policy to ticket
     */
    public static function assignSlaToTicket($CompanyID,$TicketID){

        $query 				=      	"call prc_AssignSlaToTicket (".$CompanyID.",".$TicketID.")";
        DB::select($query);

    }
	
	static function CheckSlavoilation($TicketData){
		$SlaData  			= 	TicketSla::find($TicketData->TicketSlaID);
		
		if($SlaData->Status>0)
		{
			/*$TicketPriority		=	TicketPriority::getPriorityIDByStatus($TicketData->PriorityValue);
			$Slavoilation  		= 	TicketSlaPolicyViolation::where(['TicketSlaID'=>$TicketData->TicketSlaID])->get();
			$SlaPolicyApplyTo  	= 	TicketSlaPolicyApplyTo::where(['TicketSlaID'=>$TicketData->TicketSlaID])->get();*/
			$SlaTarget  		= 	TicketSlaTarget::where(['TicketSlaID'=>$TicketData->TicketSlaID,"PriorityID"=>$TicketPriority])->first();
			
			$CreatedAt			=   $TicketData->created_at;
			
			Log::info(print_r($SlaTarget,true));
			
			if(count($SlaTarget)>0){
				
				$DateResponse = new \DateTime($CreatedAt);
				$DateResponse->modify('+'.$SlaTarget->RespondValue.' '.$SlaTarget->RespondType.'');
				$ResponseTime  =  $DateResponse->format('Y-m-d H:i'); 
				
				$DateResolve  = new \DateTime($CreatedAt);
				$DateResolve->modify('+'.$SlaTarget->ResolveValue.' '.$SlaTarget->ResolveType.'');
				$ResolveTime  =  $DateResolve->format('Y-m-d H:i'); 
				
				Log::info("ResponseTime:".$ResponseTime);
				Log::info("ResolveTime:".$ResolveTime);
				
				
			}	
			
			/*switch ($TicketData->PriorityValue) {
				case "":
				break;
				
			}*/
			
			
				
		}
		//	
		/*Log::info("SlaData:");				Log::info(print_r($SlaData,true));
		Log::info("Slavoilation:");			Log::info(print_r($Slavoilation,true));
		Log::info("SlaPolicyApplyTo:");		Log::info(print_r($SlaPolicyApplyTo,true));
		Log::info("SlaTarget:");				Log::info(print_r($SlaTarget,true));*/
		
	}
}
