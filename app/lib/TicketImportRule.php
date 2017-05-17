<?php
namespace App\Lib;

use Illuminate\Database\Eloquent\Model;

class TicketImportRule extends Model {

    protected $table 		= 	"tblTicketImportRule";
    protected $primaryKey 	= 	"TicketImportRuleID";
    protected $guarded 		=	 array("TicketImportRuleID");


    public static function check($CompanyID,$TicketID){

        $Ticket = TicketsTable::where(["TicketID"=>$TicketID])->get(["CompanyID"]);
        $Ticket = json_decode(json_encode($Ticket),true);

        $TicketImportRules =  TicketImportRule::where(["CompanyID"=>$CompanyID,"Status"=>1])->get();

        foreach($TicketImportRules as $TicketImportRule ){

            print_r($TicketImportRule);

        }
    }
}
