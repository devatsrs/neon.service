<?php

namespace App\Lib;

use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class Timezones extends \Eloquent {
    protected $fillable = [];
    protected $guarded = array();
    protected $table = 'tblTimezones';
    protected $primaryKey = "TimezonesID";
    public $timestamps  = false;

    public static $DaysOfWeek = array(
        "1" => "Sunday",
        "2" => "Monday",
        "3" => "Tuesday",
        "4" => "Wednesday",
        "5" => "Thursday",
        "6" => "Friday",
        "7" => "Saturday"
    );

    public static $Months = array(
        "1" => "January",
        "2" => "February",
        "3" => "March",
        "4" => "April",
        "5" => "May",
        "6" => "June",
        "7" => "July",
        "8" => "August",
        "9" => "September",
        "10" => "October",
        "11" => "November",
        "12" => "December"
    );

    public static $ApplyIF = array(
        "start" => "Session starts during this timezone",
        "end" => "Session finished during this timezone",
        "both" => "Session starts and finished during this timezone"
    );

    public static function getTimezonesIDList($reverse = 0) {
        if($reverse == 0) {
            return Timezones::where(['Status'=>1])->select(['Title', 'TimezonesID'])->orderBy('Title')->lists('Title', 'TimezonesID');
        } else {
            return Timezones::where(['Status'=>1])->select(['Title', 'TimezonesID'])->orderBy('Title')->lists('TimezonesID','Title');
        }
    }

}