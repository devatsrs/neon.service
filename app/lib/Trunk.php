<?php

namespace App\Lib;

class Trunk extends \Eloquent  {

    public static $cache = array(
        "trunk_dropdown1_cache",   // Trunk => Trunk
        "trunk_dropdown2_cache",    // TrunkID => Trunk
        "trunk_cache",    // all records in obj
    ); 
 
    protected static $enable_cache = false;

    protected $guarded = array();

    public static $rules = array(
        'Trunk' =>      'required|unique:tblTrunk',
        'CompanyID' =>  'required',
       // 'RatePrefix' => 'required',
       // 'AreaPrefix' => 'required',
       // 'Prefix' =>     'required',
        'Status' =>     'between:0,1',
    );

    protected $table = 'tblTrunk';

    protected  $primaryKey = "TrunkID";


}
