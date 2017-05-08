<?php
namespace App\Lib;
use Illuminate\Support\Facades\Config;
use Maatwebsite\Excel\Facades\Excel;

class TicketPriority extends \Eloquent {
	
    protected $table 		= 	"tblTicketPriority";
    protected $primaryKey 	= 	"PriorityID";
	protected $guarded 		=	 array("PriorityID");
	
	static function getTicketPriority($select=1){
		//TicketfieldsValues::WHERE
		 $row =  TicketPriority::orderBy('PriorityID')->lists('PriorityValue', 'PriorityID');
		if(!empty($row) && $select==1){
				$row =  array("0"=> "Select")+json_decode(json_encode($row),true);
		}else{
			 $row = json_decode(json_encode($row),true);
		 }
		 return $row;
	}
	
	static function getPriorityStatusByID($id){
			return TicketPriority::where(["PriorityID"=>$id])->pluck('PriorityValue');
	}
	
	static function getPriorityIDByStatus($id){ 
			return TicketPriority::where(["PriorityValue"=>$id])->pluck('PriorityID');
	}
   
}