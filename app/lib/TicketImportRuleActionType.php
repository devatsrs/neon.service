<?php
namespace App\Lib;

class TicketImportRuleActionType extends \Eloquent  {

    protected $table 		= 	"tblTicketImportRuleActionType";
    protected $primaryKey 	= 	"TicketImportRuleActionTypeID";
    protected $guarded 		=	 array("TicketImportRuleActionTypeID");


    const EMAIL_FROM = 'from_email';
    const EMAIL_TO = 'to_email';
    const SUBJECT = 'subject';
    const DESCRIPTION = 'description';
    const DESC_OR_SUB = 'subject_or_description';
    const PRIORITY = 'priority';
    const STATUS = 'status';
    const AGENT = 'agent';
    const GROUP = 'group';

    protected $enable_cache = true;
    protected $cache_name = "TicketImportRuleActionType";

    // load all types in cache
    function __construct(){

        if ($this->enable_cache && Cache::has($this->cache_name)) {

            $cache = Cache::get($this->cache_name);

        } else {
            $cache = array();
            $cache[$this->cache_name] = TicketImportRuleConditionType::lists('Condition','TicketImportRuleConditionTypeID');
            Cache::forever($this->cache_name, $cache);

        }
        return $cache[$this->cache_name];
    }

    // get type value by id
    function get($key){

        $cache = Cache::get($this->cache_name);
        if(!empty($cache) && isset($cache[$key])){
            return $cache[$key];
        }
        return "";

    }

    function isEmailFrom($TicketImportRuleConditionTypeID){

        if($this->get($TicketImportRuleConditionTypeID) == self::EMAIL_FROM){
            return true;
        }
        return false;
    }

}
