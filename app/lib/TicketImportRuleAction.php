<?php
namespace App\Lib;

use Illuminate\Support\Facades\Log;

class TicketImportRuleAction extends \Eloquent {

    protected $guarded = array("TicketImportRuleActionID");
    protected $table = 'tblTicketImportRuleAction';
    protected $primaryKey = "TicketImportRuleActionID";

    var $log = array();

    public function doActions($TicketImportRuleID,$TicketData) {

        $TicketImportRuleActions = TicketImportRuleAction::where(["TicketImportRuleID" => $TicketImportRuleID])->orderby("Order")->get();

        $TicketID = $TicketData["TicketID"];
        $log = array();

        Log::info("doActions - " . count($TicketImportRuleActions) );
        Log::info($TicketImportRuleActions);

        if(count($TicketImportRuleActions) > 0) {
            foreach ($TicketImportRuleActions as $TicketImportRuleAction) {
                $TicketImportRuleActionTypeID = $TicketImportRuleAction["TicketImportRuleActionTypeID"];

                Log::info("TicketImportRuleActionTypeID " . $TicketImportRuleActionTypeID);

                if ((new TicketImportRuleActionType())->isDeleteTicket($TicketImportRuleActionTypeID)) {
                    TicketsTable::deleteTicket($TicketID);
                    $log[] = TicketImportRuleActionType::DELETE_TICKET;
                    Log::info($log);

                    return $log;
                }
                if ((new TicketImportRuleActionType())->isSkipNotification($TicketImportRuleActionTypeID)) {
                    $log[] = TicketImportRuleActionType::SKIP_NOTIFICATION;
                }
            }
        }

        return $log;
    }

}
