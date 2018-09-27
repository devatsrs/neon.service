<?php
namespace App\Lib;
use Illuminate\Support\Facades\Config;
use Maatwebsite\Excel\Facades\Excel;
use Illuminate\Support\Facades\Log;

class TicketfieldsValues extends \Eloquent {

    protected $table 		= 	"tblTicketfieldsValues";
    protected $primaryKey 	= 	"ValuesID";
	protected $guarded 		=	 array("ValuesID");
   // public    $timestamps 	= 	false; // no created_at and updated_at	
  // protected $fillable = ['GroupName','GroupDescription','GroupEmailAddress','GroupAssignTime','GroupAssignEmail','GroupAuomatedReply'];
	protected $fillable = [];
	
	static $Status_Closed = 'Closed';
	static $Status_Open = 'Open';
	static $Status_Resolved = 'Resolved';
	static $Status_UnResolved = 'All UnResolved';
	static $Status_waiting_on_customer = 'Waiting on Customer';
	static $Status_Waiting_on_Third_Party = 'Waiting on Third Party';


	/*public function getUnResolvedTicketStatus(){

		$ValuesID =  TicketfieldsValues::join('tblTicketfields','tblTicketfields.TicketFieldsID','=','tblTicketfieldsValues.FieldsID')
			->where(['tblTicketfields.FieldType'=>Ticketfields::TICKET_SYSTEM_STATUS_FLD])->where(['tblTicketfieldsValues.FieldValueAgent'=>TicketfieldsValues::$Status_UnResolved])->pluck('ValuesID');
		return $ValuesID;

	}*/
	
	static function GetUnResolvedTicketStatus(){
		  $statusArray	= 	TicketsTable::getTicketStatus(0);
		  unset($statusArray[array_search('Resolved', $statusArray)]);
		  unset($statusArray[array_search('Closed', $statusArray)]);
		  $status = implode(',',array_keys($statusArray));
          return $status;
	}
}