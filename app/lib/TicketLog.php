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

    /*
ParentType -- Account, Contact, User, System
Action -- Created , Replied by cust / user ,  status changdd , note added
ActionText -- Status Changed from {from_Status} to {to_Status}
       -- Created by {ParentType} <a>{ParentID}</a>
       -- Created by {ParentType} <a>{ParentID}</a>
*/
    const TICKET_ACTION_CREATED = 1;
    const TICKET_ACTION_ASSIGNED_TO = 2;
    const TICKET_ACTION_AGENT_REPLIED = 3;
    const TICKET_ACTION_CUSTOMER_REPLIED = 4;
    const TICKET_ACTION_STATUS_CHANGED = 5;
    const TICKET_ACTION_NOTE_ADDED = 6;
    const TICKET_ACTION_FIELD_CHANGED = 7;

    const TICKET_USER_TYPE_ACCOUNT = 1;
    const TICKET_USER_TYPE_CONTACT = 2;
    const TICKET_USER_TYPE_USER = 3;
    const TICKET_USER_TYPE_SYSTEM = 4;

    static  $TicketUserTypes = [ self::TICKET_USER_TYPE_ACCOUNT  => "Account",
                            self::TICKET_USER_TYPE_CONTACT  => "Contact",
                            self::TICKET_USER_TYPE_USER     => "User",
                            self::TICKET_USER_TYPE_SYSTEM   => "System"
                        ];

    public static function insertTicketLog($log_data ) {

        $log_data['created_at'] = date("Y-m-d H:i:s");

        self::add($log_data);

    }

    public static function add($data) {

        TicketLog::insert($data);
    }

}