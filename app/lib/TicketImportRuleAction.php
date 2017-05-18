<?php
namespace App\Lib;

class TicketImportRuleAction extends \Eloquent {

    var $log = array();

    public function doActions($TicketImportRuleID,$TicketData) {

        $TicketImportRuleActions = TicketImportRuleAction::where(["TicketImportRuleID" => $TicketImportRuleID])->orderby("Order")->get();

        $TicketID = $TicketData["TicketID"];
        foreach($TicketImportRuleActions as $TicketImportRuleAction) {
            $TicketImportRuleActionTypeID = $TicketImportRuleAction["TicketImportRuleActionTypeID"];

            if ((new TicketImportRuleActionType())->isDeleteTicket($TicketImportRuleActionTypeID)) {
                TicketsTable::deleteTicket($TicketID);
                $this->log[] = TicketImportRuleActionType::DELETE_TICKET;
                return $this;
            }
            if ((new TicketImportRuleActionType())->isSkipNotification($TicketImportRuleActionTypeID)) {
                $this->log[] = TicketImportRuleActionType::SKIP_NOTIFICATION;
            }
        }

        return $this;
    }

}
