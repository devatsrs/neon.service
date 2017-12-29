<?php
namespace App\Lib;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Maatwebsite\Excel\Facades\Excel;

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

	static function deleteTicket($TicketID) {
		$Ticket = TicketsTable::find($TicketID);
		if(!empty($Ticket) && isset($Ticket->TicketID) && $Ticket->TicketID > 0 ) {
			TicketsDetails::where(["TicketID"=>$TicketID])->delete();
			TicketLog::where(["TicketID"=>$TicketID])->delete();
			AccountEmailLog::where(["TicketID"=>$TicketID])->delete();
			$Ticket->delete();
			Log::info("TicketDeleted " . $TicketID);
			return true;
		}
		return false;
	}
	static function setTicketFieldValue($TicketID,$Field,$Value) {
		$Ticket = TicketsTable::find($TicketID);
		if(!empty($Ticket) && isset($Ticket->TicketID) && $Ticket->TicketID > 0 ) {

			try{
				if($Ticket->update([$Field=>$Value])){
					return true;
				}
			} catch (\Exception $ex){
				Log::info("Error with setTicketValue " );
				Log::info(print_r($ex,true));
			}
		}
		return false;
	}


	/** Check Repeated Emails and add to Import Rule and send email to support ticket email.
	 * @param $companyID
	 * @param $data
	 * @return bool
	 */
	static function checkRepeatedEmails($CompanyID,$data) {

		// Create Import Rule
		// Check Duplicate

		$emailToBlock = $data["from"];
		$GroupID 	  = $data["GroupID"];

		//call prc_TicketCheckRepeatedEmails(1,'sumera@code-desk.com')
		$query = "call prc_TicketCheckRepeatedEmails ('" . $CompanyID . "','" . $emailToBlock . "')";
		$isBlock = DB::select($query);

		if(isset($isBlock[0]->block) && $isBlock[0]->block == 1) {

			try {

				DB::beginTransaction();

				$Title = "Spam Detection by System Against Email: " . $emailToBlock;
				$Description = "Spam Detection by System Against Email: " . $emailToBlock;;
				$SaveData = array(
					"CompanyID" => $CompanyID,
					"Title" => $Title,
					"Description" => $Description,
					"Match" => TicketImportRule::MATCH_ANY,   // All , Any
					"Status" => 1,
					"created_at" => date('Y-m-d H:i:s'),
					"created_by" => "Neon"
				);

				$ID = TicketImportRule::insertGetId($SaveData);

				if ($ID) {
					// Add condition

					$Conditions = TicketImportRuleConditionType::lists('Condition','TicketImportRuleConditionTypeID');
					$rule_condition = array_search(TicketImportRuleConditionType::EMAIL_FROM, $Conditions);
					if ($rule_condition == false) {
						Log::info("Condition TicketImportRuleConditionType::EMAIL_FROM not found");
						return;
					}

					$SaveConditionData = array(
						"TicketImportRuleID" => $ID,
						"TicketImportRuleConditionTypeID" => $rule_condition,
						"Operand" => 'is',
						"Value" => $emailToBlock,
						"Order" => 1
					);

					TicketImportRuleCondition::create($SaveConditionData);

					// Add Action
					$Conditions = TicketImportRuleActionType::lists('Action','TicketImportRuleActionTypeID');
					$rule_action = array_search(TicketImportRuleActionType::SKIP_NOTIFICATION, $Conditions);
					if ($rule_action == false) {
						Log::info("Condition TicketImportRuleActionType::SKIP_NOTIFICATION not found");
						return;
					}

					$SaveRuleData = array(
						"TicketImportRuleID" => $ID,
						"TicketImportRuleActionTypeID" => $rule_action,
						"Value" => "",
						"Order" => 1
					);

					TicketImportRuleAction::create($SaveRuleData);

					Log::info("Import Rule for Skip notification Saved against email " . $emailToBlock);

				}

				DB::commit();

				return true;

				new TicketEmails(array("GroupID" => $GroupID, "CompanyID" => $CompanyID, "EmailToBlock" => $emailToBlock , "TriggerType" => array("RepeatedEmailBlockEmail")));

			}catch (Exception $ex) {

				DB::rollback();
				Log::info("Failed to add Import Rule for Skip notification against email " . $emailToBlock);
			}

		}

		return false;
	}
}