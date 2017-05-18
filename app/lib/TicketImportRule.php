<?php
namespace App\Lib;

class TicketImportRule extends \Eloquent
{

    protected $table = "tblTicketImportRule";
    protected $primaryKey = "TicketImportRuleID";
    protected $guarded = array("TicketImportRuleID");

    const MATCH_ANY = 1;
    const MATCH_ALL = 2;

    var $operation_log = array();

    public static function check($CompanyID, $TicketData)
    {


        $TicketImportRules = TicketImportRule::where(["CompanyID" => $CompanyID, "Status" => 1])->get();


        if (count($TicketImportRules) > 0) {

            $total_rule_matches = 0;
            foreach ($TicketImportRules as $TicketImportRule) {
                $TicketImportRuleID = $TicketImportRule["TicketImportRuleID"];
                $Match = $TicketImportRule["Match"];

                $TicketImportRuleConditions = TicketImportRuleCondition::where(["TicketImportRuleID" => $TicketImportRuleID])->orderby("Order")->get();
                if (count($TicketImportRuleConditions) > 0) {
                    foreach ($TicketImportRuleConditions as $TicketImportRuleCondition) {

                        $TicketImportRuleConditionTypeID = $TicketImportRuleCondition["TicketImportRuleConditionTypeID"];
                        $Operand = $TicketImportRuleCondition["Operand"];
                        $Value = $TicketImportRuleCondition["Value"];

                        if ($TicketImportRuleConditionTypeID > 0 && (new TicketImportRuleConditionType())->isEmailFrom($TicketImportRuleConditionTypeID)) {

                            //@TODO: this is for requester email match only.
                            $fromEmail = $TicketData["Requester"];
                            if (TicketImportRuleCondition::field($fromEmail)->operand($Operand)->value($Value)->check()) {
                                $total_rule_matches++;
                                if ($Match == self::MATCH_ANY) {
                                    break;
                                }
                            }

                        }

                    }
                }
                if (($Match == self::MATCH_ANY && $total_rule_matches == 1) || ($Match == self::MATCH_ALL && $total_rule_matches == count($TicketImportRuleConditions))) {

                    $TicketImportRuleAction = (new TicketImportRuleAction)->doActions($TicketImportRuleID, $TicketData);

                    return $TicketImportRuleAction->log;
                }
            }
        }
    }

}