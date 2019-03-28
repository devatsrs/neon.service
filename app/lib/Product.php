<?php
namespace App\Lib;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\View;


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
    const ADVANCECALLCHARGE = 7;
    public static $ProductTypes = ["item"=>self::ITEM, "usage"=>self::USAGE,"subscription"=>self::SUBSCRIPTION];
    public static $TypetoProducts = [self::ITEM => "item", self::USAGE => "usage", self::SUBSCRIPTION =>"subscription"];

    const Customer = 0;
    const Reseller = 1;

    const OutPaymentCode = 'outpayment';

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
    /** send LowStockReminder report to specified emails*/
    public static function LowStockReminder($CompanyID, $ProcessID){
        $Alerts = Alert::where(array('CompanyID' => $CompanyID, 'AlertGroup' => 'call','AlertType'=>'Low_stock_reminder', 'Status' => 1))->orderby('AlertType', 'asc')->get();
        foreach ($Alerts as $Alert) {
            $settings = $report_settings = json_decode($Alert->Settings, true);
            $settings['ProcessID'] = $ProcessID;
            $settings['Subject'] = $Alert->Name;
            if (cal_next_runtime($settings) == date('Y-m-d H:i:00')) {
                if (!isset($settings['LastRunTime'])) {
                    if ($settings['Time'] == 'MINUTE') {
                        $settings['LastRunTime'] = date("Y-m-d H:00:00", strtotime('-' . $settings['Interval'] . ' minute'));
                    } else if ($settings['Time'] == 'HOUR') {
                        $settings['LastRunTime'] = date("Y-m-d H:00:00", strtotime('-' . $settings['Interval'] . ' hour'));
                    } else if ($settings['Time'] == 'DAILY') {
                        $settings['LastRunTime'] = date("Y-m-d 00:00:00", strtotime('-' . $settings['Interval'] . ' day'));
                    }
                    $settings['NextRunTime'] = next_run_time($settings);
                }
                if ($report_settings['Time'] == 'MINUTE') {
                    $report_settings['LastRunTime'] = date("Y-m-d H:00:00", strtotime('-' . $report_settings['Interval'] . ' minute'));
                } else if ($report_settings['Time'] == 'HOUR') {
                    $report_settings['LastRunTime'] = date("Y-m-d H:00:00", strtotime('-' . $report_settings['Interval'] . ' hour'));
                } else if ($report_settings['Time'] == 'DAILY') {
                    $report_settings['LastRunTime'] = date("Y-m-d 00:00:00", strtotime('-' . $report_settings['Interval'] . ' day'));
                }
                unset($report_settings['StartTime']);
                $report_settings['NextRunTime'] = next_run_time($report_settings);

                /** send only if vendor not empty */

                $query = "CALL prc_getLowStockItemsAlert(".$CompanyID.")";
                //Log::info($query);
                $AlertItems = DB::connection('sqlsrv2')->select($query);
                if (!empty($AlertItems)) {
                    //Log::info(print_r($AlertItems,true));
                    $settings['EmailMessage'] = View::make('emails.lowstockreminder', compact('AlertItems'))->render();
                    //$settings['EmailType'] = AccountEmailLog::VendorBalanceReport;
                    NeonAlert::SendReminderToEmail($CompanyID, $Alert->AlertID,'0' ,$settings);
                }
                
                NeonAlert::UpdateNextRunTime($Alert->AlertID, 'Settings', 'Alert', $settings['NextRunTime']);
            }
        }
    }
}