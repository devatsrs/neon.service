<?php
namespace App\Lib;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Maatwebsite\Excel\Facades\Excel;

class AutoImportRate extends \Eloquent {


    protected $guarded = array("TicketID");

    protected $table = 'tblAutoImport';

    protected $primaryKey = "AutoImportID";
	
    static  $FreshdeskTicket  		= 	1;
    static  $SystemTicket 			= 	0;
	static  $DefaultTicketStatus	=	'';
	static  $defaultSortField 		= 	'created_at';
	static  $defaultSortType 		= 	'desc';
	static  $Sortcolumns			=	array("created_at"=>"Date Created","subject"=>"Subject","status"=>"Status","group"=>"Group","updated_at"=>"Last Modified");
	


	/*static function checkRepeatedEmails($CompanyID,$data) {

		// Create Import Rule
		// Check Duplicate

		$emailToBlock = $data["from"];
		$GroupID 	  = $data["GroupID"];

		//call prc_TicketCheckRepeatedEmails(1,'sumera@code-desk.com',1)
		$query = "call prc_TicketCheckRepeatedEmails ('" . $CompanyID . "','" . $emailToBlock . "','" . $GroupID . "')";
		$isBlock = DB::select($query);

		if(isset($isBlock[0]->isAlreadyBlocked) && $isBlock[0]->isAlreadyBlocked == 1) {
			Log::info("Repeated Emails skipped: AlreadyBlocked");
			return true;

		} else if(isset($isBlock[0]->block) && $isBlock[0]->block == 1) {

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
						return false;
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
						return false;
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

				new TicketEmails(array("GroupID" => $GroupID, "CompanyID" => $CompanyID, "EmailToBlock" => $emailToBlock , "TriggerType" => array("RepeatedEmailBlockEmail")));

				return true;

			}catch (Exception $ex) {

				DB::rollback();
				Log::info("Failed to add Import Rule for Skip notification against email " . $emailToBlock);
			}

		}

		return false;
	}*/

	public static function  getAutoImportMail()
	{
		return  AutoImportRate::where('Attachment','!=','')->lists('MessageId','From');

	}
	static function getLastEmailReadDateTime($CompanyID) {

		$LastEmailReadDateTime = AutoImportRate::orderBy('AutoImportID', 'desc')->where("CompanyID", $CompanyID)->first();
		if(isset($LastEmailReadDateTime->created_at)){
			return $LastEmailReadDateTime->created_at;
		}else{
			date("Y-m-d H:i:s");
		}	
		return $LastEmailReadDateTime;

	}

}