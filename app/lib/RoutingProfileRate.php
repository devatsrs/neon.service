<?php
namespace App\Lib;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\View;


class RoutingProfileRate extends \Eloquent {
    
    protected $connection = 'neon_routingengine';
    protected $fillable = [];
    protected $guarded = array('id');
    protected $table = 'tblRoutingProfileRate';
    public  $primaryKey = "id"; //Used in BasedController
    public $timestamps = false;

    const ITEM = 1;
    const USAGE = 2;
    const SUBSCRIPTION = 3;
    const ONEOFFCHARGE =4;
    const INVOICE_PERIOD = 5;
    const FIRST_PERIOD = 6;
    const ADVANCECALLCHARGE = 7;
    public static $ProductTypes = ["item"=>self::ITEM, "usage"=>self::USAGE,"subscription"=>self::SUBSCRIPTION];
    public static $TypetoProducts = [self::ITEM => "item", self::USAGE => "usage", self::SUBSCRIPTION =>"subscription"];

    const Customer = 0;
    const Reseller = 1;

    public static function getProductName($id,$ProductType){
        
    }

    public static function getAllProductName($CompanyID){
        
    }
    /** send LowStockReminder report to specified emails*/
    public static function LowStockReminder($CompanyID, $ProcessID){
    }
}