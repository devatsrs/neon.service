<?php
namespace App\Lib;

use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Log;

class TicketImportRuleConditionType extends \Eloquent  {

    protected $table 		= 	"tblTicketImportRuleConditionType";
    protected $primaryKey 	= 	"TicketImportRuleConditionTypeID";
    protected $guarded 		=	 array("TicketImportRuleConditionTypeID");

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
    protected $cache_name = "TicketImportRuleConditionType";

    // load all types in cache
    function __construct(){

        if ($this->enable_cache && Cache::has($this->cache_name)) {

            $cache = Cache::get($this->cache_name);

        } else {
            $cache = array();
            $cache[$this->cache_name] = TicketImportRuleConditionType::lists('Condition','TicketImportRuleConditionTypeID');
            Cache::forever($this->cache_name, $cache);

        }
        Log::info("TicketImportRuleConditionType");
        Log::info($cache);

        return $cache[$this->cache_name];
    }

    // get type value by id
    function get($key){

        $cache = Cache::get($this->cache_name);
        $cache = isset($cache[$this->cache_name])?$cache[$this->cache_name]:"";
        if(!empty($cache) && isset($cache[$key])){
                return $cache[$key];
        }
        return "";

    }

    function isEmailFrom($TicketImportRuleConditionTypeID) {

        if($this->get($TicketImportRuleConditionTypeID) == self::EMAIL_FROM){
            return true;
        }
        return false;
    }
 }
