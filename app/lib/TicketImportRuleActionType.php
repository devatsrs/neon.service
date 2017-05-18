<?php
namespace App\Lib;

use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Log;

class TicketImportRuleActionType extends \Eloquent  {

    protected $table 		= 	"tblTicketImportRuleActionType";
    protected $primaryKey 	= 	"TicketImportRuleActionTypeID";
    protected $guarded 		=	 array("TicketImportRuleActionTypeID");


    const DELETE_TICKET = 'delete_ticket';
    const SKIP_NOTIFICATION = 'skip_notification';
    const SET_PRIORITY = 'set_priority';
    const SET_STATUS = 'set_status';
    const SET_AGENT = 'set_agent';
    const SET_GROUP = 'set_group';

    protected $enable_cache = true;
    protected $cache_name = "TicketImportRuleActionType";

    // load all types in cache
    function __construct(){

        Log::info("Action Cache name " . $this->cache_name);

        if ($this->enable_cache && Cache::has($this->cache_name)) {

            $cache = Cache::get($this->cache_name);

        } else {
            $cache = array();
            $cache[$this->cache_name] = TicketImportRuleActionType::lists('Action','TicketImportRuleActionTypeID');
            Cache::forever($this->cache_name, $cache);

        }
        return $cache[$this->cache_name];
    }

    // get type value by id
    function get($key){

        $cache = Cache::get($this->cache_name);
        $cache = isset($cache[$this->cache_name])?$cache[$this->cache_name]:"";

        Log::info($cache);
        if(!empty($cache) && isset($cache[$key])){
            return $cache[$key];
        }
        return "";

    }

    function isDeleteTicket($TicketImportRuleActionTypeID){

        if($this->get($TicketImportRuleActionTypeID) == self::DELETE_TICKET){
            Log::info("DELETE_TICKET " );
            return true;
        }
        return false;
    }

    function isSkipNotification($TicketImportRuleActionTypeID){

        if($this->get($TicketImportRuleActionTypeID) == self::SKIP_NOTIFICATION){
            return true;
        }
        return false;
    }

}
