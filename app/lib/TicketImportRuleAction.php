<?php
namespace App\Lib;

use Illuminate\Support\Facades\Log;

class TicketImportRuleAction extends \Eloquent {

    protected $guarded = array("TicketImportRuleActionID");
    protected $table = 'tblTicketImportRuleAction';
    protected $primaryKey = "TicketImportRuleActionID";


}
