<?php
namespace App\Lib;

class Product extends \Eloquent {
    protected $connection = 'sqlsrv2';
    protected $fillable = [];
    protected $guarded = array('ProductID');
    protected $table = 'tblProduct';
    public  $primaryKey = "ProductID"; //Used in BasedController

    const ITEM = 1;
    const USAGE = 2;
    const SUBSCRIPTION = 3;
    const ONEOFFCHARGE =4;
    const INVOICE_PERIOD = 5;
    const FIRST_PERIOD = 6;
    public static $ProductTypes = ["item"=>self::ITEM, "usage"=>self::USAGE,"subscription"=>self::SUBSCRIPTION];
    public static $TypetoProducts = [self::ITEM => "item", self::USAGE => "usage", self::SUBSCRIPTION =>"subscription"];

    const Customer = 0;
    const Reseller = 1;

    public static function getProductName($id,$ProductType){
        if( $id>0 && ($ProductType == self::ITEM || $ProductType == self::ONEOFFCHARGE)){
            $Product = Product::find($id);
            if(!empty($Product)){
                return $Product->Name;
            }
        }
        if( $id == 0 && $ProductType == self::USAGE ){
            return 'Usage';
        }
        if( $id > 0 && $ProductType == self::SUBSCRIPTION ){
            return BillingSubscription::getSubscriptionNameByID($id);
        }
    }

    public static function getAllProductName($CompanyID){
        $products = [];
        $items = Product::select(['ProductID','Name'])->where('CompanyId',$CompanyID)->lists('Name','ProductID');
        $products[Product::ITEM] = $items;
        $products[Product::ONEOFFCHARGE] = $items;
        $products[Product::SUBSCRIPTION] = BillingSubscription::getAllSubscriptionsNames($CompanyID);
        return $products;
    }
}