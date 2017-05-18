<?php
namespace App\Lib;

class TicketImportRule extends \Eloquent  {

    protected $table 		= 	"tblTicketImportRule";
    protected $primaryKey 	= 	"TicketImportRuleID";
    protected $guarded 		=	 array("TicketImportRuleID");

    const MATCH_ANY         = 1;
    const MATCH_ALL         = 2;

    public static function check($CompanyID,$TicketData){


        $TicketImportRules =  TicketImportRule::where(["CompanyID"=>$CompanyID,"Status"=>1])->get();

        if(count($TicketImportRules) > 0) {
            foreach ($TicketImportRules as $TicketImportRule) {
                $TicketImportRuleID = $TicketImportRule["TicketImportRuleID"];
                $Match = $TicketImportRule["Match"];

                $TicketImportRuleConditions = TicketImportRuleCondition::where(["TicketImportRuleID" => $TicketImportRuleID])->orderby("Order")->get();
                if(count($TicketImportRuleConditions) > 0) {
                    foreach ($TicketImportRuleConditions as $TicketImportRuleCondition) {

                        $TicketImportRuleConditionTypeID = $TicketImportRuleCondition["TicketImportRuleConditionTypeID"];
                        $Operand = $TicketImportRuleCondition["Operand"];
                        $Value = $TicketImportRuleCondition["Value"];

                        if($TicketImportRuleConditionTypeID > 0 && with(new TicketImportRuleConditionType())->isEmailFrom($TicketImportRuleConditionTypeID)) {

                            $fromEmail = $TicketData["Requester"];
                            if( TicketImportRuleCondition::if($fromEmail)->is($Operand)->value($Value) ) {

                                $result = TicketImportRuleAction::doActions($TicketData);

                                if($result && $Match == self::MATCH_ANY) {
                                    //$result["action"] =

                                }

                            }

                        }

                    }
                }


            }
        }
     }
}
