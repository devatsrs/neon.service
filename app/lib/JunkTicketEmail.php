<?php
namespace App\Lib;
use Illuminate\Support\Facades\Config;

class JunkTicketEmail extends \Eloquent {
    protected $guarded = array("JunkTicketEmailID");
    protected $fillable = [];
    protected $table = "tblJunkTicketEmail";
    protected $primaryKey = "JunkTicketEmailID";

    static public function add($logData){

        return JunkTicketEmail::insertGetId($logData);

    }
}