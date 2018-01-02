<?php
namespace App\Lib;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Lib\User;
use App\Lib\Ticketfields;

class TicketLog extends \Eloquent 
{
    protected $guarded = array("TicketLogID");

    protected $table = 'tblTicketLog';

    protected $primaryKey = "TicketLogID";


    static  $defaultTicketLogFields = [
        'Type'=>Ticketfields::default_ticket_type,
        'Status'=>Ticketfields::default_status,
        'Priority'=>Ticketfields::default_priority,
        'Group'=>Ticketfields::default_group,
        'Agent'=>Ticketfields::default_agent
    ];


    const NEW_TICKET = 'new_ticket';
    const STATUS_CHANGED = 'status_changed';
    const TICKET_REPLIED = 'ticket_replied';

    public static function insertTicketLog($log_data, $Action ) {

        $log_data['created_at'] = date("Y-m-d H:i:s");

        if($Action == self::NEW_TICKET) {

            $log_data["NewTicket"]  =1;
            self::add($log_data);

        }  else if($Action == self::TICKET_REPLIED ) {

            $data_reply = $log_data;
            self::add($data_reply);

            $ticketfieldsValues = TicketfieldsValues::where(["FieldValueAgent"=>TicketfieldsValues::$Status_Open])->get(["ValuesID", "FieldsID"])->first()->toArray();

            $data_status = [
                'TicketFieldID' => $ticketfieldsValues["FieldsID"],
                'TicketFieldValueFromID' => 0,
                'TicketFieldValueToID' => $ticketfieldsValues["ValuesID"],
            ];
            $data_status = array_merge($data_reply,$data_status);
            self::add($data_status);

        }


    }

    public static function add($data) {

        TicketLog::insert($data);
    }

}