<?php
namespace App\Lib;
use Illuminate\Support\Facades\Config;
use Maatwebsite\Excel\Facades\Excel;
use App\Lib\TicketsTable;

class TicketsTable extends \Eloquent {


    protected $guarded = array("TicketID");

    protected $table = 'tblTickets';

    protected $primaryKey = "TicketID";
	
    static  $FreshdeskTicket  		= 	1;
    static  $SystemTicket 			= 	0;
	static  $DefaultTicketStatus	=	'';
	static  $defaultSortField 		= 	'created_at';
	static  $defaultSortType 		= 	'desc';
	static  $Sortcolumns			=	array("created_at"=>"Date Created","subject"=>"Subject","status"=>"Status","group"=>"Group","updated_at"=>"Last Modified");
	
	static function GetAgentSubmitRules(){
		 $rules 	 =  array();
		 $messages	 =  array();
		 $fields 	 = 	Ticketfields::where(['AgentReqSubmit'=>1])->get();
		 
		foreach($fields as $fieldsdata)	 
		{
			$rules[$fieldsdata->FieldType] = 'required';
			$messages[$fieldsdata->FieldType.".required"] = "The ".$fieldsdata->AgentLabel." field is required";
		}
		
		return array("rules"=>$rules,"messages"=>$messages);
	}
	
	static function getClosedTicketStatus(){
		//TicketfieldsValues::WHERE
		 $ValuesID =  TicketfieldsValues::join('tblTicketfields','tblTicketfields.TicketFieldsID','=','tblTicketfieldsValues.FieldsID')
            ->where(['tblTicketfields.FieldType'=>Ticketfields::TICKET_SYSTEM_STATUS_FLD])->where(['tblTicketfieldsValues.FieldValueAgent'=>TicketfieldsValues::$Status_Closed])->pluck('ValuesID');			
			return $ValuesID;
	}
	
	static function getResolvedTicketStatus(){
		//TicketfieldsValues::WHERE
		 $ValuesID =  TicketfieldsValues::join('tblTicketfields','tblTicketfields.TicketFieldsID','=','tblTicketfieldsValues.FieldsID')
            ->where(['tblTicketfields.FieldType'=>Ticketfields::TICKET_SYSTEM_STATUS_FLD])->where(['tblTicketfieldsValues.FieldValueAgent'=>TicketfieldsValues::$Status_Resolved])->pluck('ValuesID');			
			return $ValuesID;
	}
	
	static function getOpenTicketStatus(){
		//TicketfieldsValues::WHERE
		 $ValuesID =  TicketfieldsValues::join('tblTicketfields','tblTicketfields.TicketFieldsID','=','tblTicketfieldsValues.FieldsID')
            ->where(['tblTicketfields.FieldType'=>Ticketfields::TICKET_SYSTEM_STATUS_FLD])->where(['tblTicketfieldsValues.FieldValueAgent'=>TicketfieldsValues::$Status_Open])->pluck('ValuesID');			
			return $ValuesID;
	}
	
	
	static function getTicketStatus($select=1){
		//TicketfieldsValues::WHERE
		 $row =  TicketfieldsValues::join('tblTicketfields','tblTicketfields.TicketFieldsID','=','tblTicketfieldsValues.FieldsID')->select(array('FieldValueAgent', 'ValuesID'))->where(['tblTicketfields.FieldType'=>Ticketfields::TICKET_SYSTEM_STATUS_FLD])->lists('FieldValueAgent','ValuesID');		
			if(!empty($row) && $select==1){
				$row =  array("0"=> "Select")+json_decode(json_encode($row),true);
			}else{
                 $row = json_decode(json_encode($row),true);
             }
			return $row;
	}
	
	static function getTicketType(){
		//TicketfieldsValues::WHERE
		 $row =  TicketfieldsValues::join('tblTicketfields','tblTicketfields.TicketFieldsID','=','tblTicketfieldsValues.FieldsID')
            ->where(['tblTicketfields.FieldType'=>Ticketfields::TICKET_SYSTEM_TYPE_FLD])->lists('FieldValueAgent','ValuesID');
			$row = array("0"=> "Select")+$row;
			return $row;
	}
	
	static function SetUpdateValues($TicketData,$ticketdetaildata,$Ticketfields){
			//$TicketData  = '';
			$data = array();
			
			foreach($Ticketfields as $TicketfieldsData)
			{	
				if(in_array($TicketfieldsData->FieldType,Ticketfields::$staticfields))
				{		
					if($TicketfieldsData->FieldType=='default_requester')
					{ 			
						$data[$TicketfieldsData->FieldType] = $TicketData->RequesterName." <".$TicketData->Requester.">";
					}
					
					if($TicketfieldsData->FieldType=='default_subject')
					{
						$data[$TicketfieldsData->FieldType] = $TicketData->Subject;
					}
					
					if($TicketfieldsData->FieldType=='default_ticket_type')
					{
						$data[$TicketfieldsData->FieldType] = $TicketData->Type;
					}
					
					if($TicketfieldsData->FieldType=='default_status')
					{
						$data[$TicketfieldsData->FieldType] = $TicketData->Status;
					}	
					
					if($TicketfieldsData->FieldType=='default_status')
					{
						$data[$TicketfieldsData->FieldType] = $TicketData->Status;
					}
					
					if($TicketfieldsData->FieldType=='default_priority')
					{
						$data[$TicketfieldsData->FieldType] = $TicketData->Priority;
					}
					
					if($TicketfieldsData->FieldType=='default_group')
					{
						$data[$TicketfieldsData->FieldType] = $TicketData->Group;
					}
					
					if($TicketfieldsData->FieldType=='default_agent')
					{
						$data[$TicketfieldsData->FieldType] = $TicketData->Agent;
					}
					
					if($TicketfieldsData->FieldType=='default_description')
					{
						$data[$TicketfieldsData->FieldType] = $TicketData->Description;
					}
				}else{
					foreach($ticketdetaildata as $ticketdetail){						
						if($TicketfieldsData->TicketFieldsID == $ticketdetail->FieldID){
							$data[$TicketfieldsData->FieldType] = $ticketdetail->FieldValue; break;
						}else{
							
							if(($TicketfieldsData->FieldHtmlType == Ticketfields::FIELD_HTML_TEXT) || ($TicketfieldsData->FieldHtmlType == Ticketfields::FIELD_HTML_TEXTAREA) || ($TicketfieldsData->FieldHtmlType == Ticketfields::FIELD_HTML_DATE)){
								$data[$TicketfieldsData->FieldType] =  '';
							}else{
								$data[$TicketfieldsData->FieldType] =  0;
							}
						}
					}
				}
				
			}
			
			$data['AttachmentPaths']  = 	 $TicketData->AttachmentPaths;	
			//Log::info(print_r($data,true));	
			return $data;
	}
	
	 
	static function CheckTicketLicense(){
		return true;
		//return false;
	}
	
	static function getTicketStatusByID($id,$fld='FieldValueAgent'){
		//TicketfieldsValues::WHERE
		 $ValuesID =  TicketfieldsValues::join('tblTicketfields','tblTicketfields.TicketFieldsID','=','tblTicketfieldsValues.FieldsID')
            ->where(['tblTicketfields.FieldType'=>Ticketfields::TICKET_SYSTEM_STATUS_FLD])->where(['tblTicketfieldsValues.ValuesID'=>$id])->pluck($fld);			
			return $ValuesID;
	}
	
	
	static function getTicketTypeByID($id,$fld='FieldValueAgent'){
		//TicketfieldsValues::WHERE
			$ValuesID =  TicketfieldsValues::join('tblTicketfields','tblTicketfields.TicketFieldsID','=','tblTicketfieldsValues.FieldsID')
            ->where(['tblTicketfields.FieldType'=>Ticketfields::TICKET_SYSTEM_TYPE_FLD])->where(['tblTicketfieldsValues.ValuesID'=>$id])->pluck($fld);			
			return $ValuesID;
	}
	
}