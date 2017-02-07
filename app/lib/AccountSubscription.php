<?php

namespace App\Lib;

use Illuminate\Support\Facades\Log;

class AccountSubscription extends \Eloquent
{
    protected $fillable = [];
    protected $connection = "sqlsrv2";
    protected $table = "tblAccountSubscription";
    protected $primaryKey = "AccountSubscriptionID";
    protected $guarded = array('AccountSubscriptionID');

    public static $rules = array(
        'AccountID' => 'required',
        'SubscriptionID' => 'required',
        'StartDate' => 'required',
        'EndDate' => 'required'
    );

    public static function  checkForeignKeyById($id)
    {

        if ($id > 0) {
            return false;
        }
    }

    public static function checkFirstTimeBilling($AccountSubscriptionStartDate,$StartDate)
    {
        //Sub date : 13-8-2015
        // Start Date : 1-8-2015
        //When Running Customers are setup in the live system. Sub Start Date :  1-1-2015 , StartDate - 1-8-2015 (Current)
        if(date('Y-m-d',strtotime($AccountSubscriptionStartDate)) < date('Y-m-d',strtotime($StartDate))) {
            return false;
        }
        return TRUE;
    }

    public static function getSubscriptionAmount($SubscriptionID, $StartDate, $EndDate, $FirstTime,$SubscriptionType=0)
    {

        /** Assumtion : Date Different should not be more than one month.
         *  check period =
         *  2015-02-01 - 2015-03-01 = 1 month 0 days
         *  2015-07-13 - 2016-07-20 = 0 month 7 days
         */
        $TotalAmount = 0;
        if ($SubscriptionID > 0) {

            $EndDate = date('Y-m-d',strtotime($EndDate)+24*60*60); //add one day for monthly
            $seconds =  strtotime($EndDate) - strtotime($StartDate);
            $days = round($seconds / 60 / 60  /24);
            $Subscriptiondays = cal_days_in_month(CAL_GREGORIAN,date('m',strtotime($StartDate)),date('Y',strtotime($StartDate)));

            Log::info( 'days diff - ' . $days.' subscription days '.print_r($Subscriptiondays,true));

//            $Subscription = BillingSubscription::find($SubscriptionID);
		    $Subscription = AccountSubscription::find($SubscriptionID);

            if ($SubscriptionType == 2 && $days >= 365 ) { // if yearly
                Log::info(' ========== yearly start ============');
                $TotalAmount += $Subscription->YearlyFee;
                Log::info(' ========== yearly end ============');

            }else if($SubscriptionType == 1 && $days > 27){ // if quarterly
                Log::info(' ========== quarterly start ============');
                $QuarterStartDate = $StartDate;
                if(date('m',strtotime($EndDate)) == 1){
                    $endmonth  = 13;
                }else{
                    $endmonth = date('m',strtotime($EndDate));
                }
                for($startmonth = date('m',strtotime($StartDate));$startmonth < $endmonth ; $startmonth++){

                    if($EndDate > date('Y-m-t',strtotime($QuarterStartDate))  ){
                        $QuarterEndDate = date('Y-m-t',strtotime($QuarterStartDate));
                        $QuarterEndDate = date('Y-m-d',strtotime($QuarterEndDate)+24*60*60); //add one day for monthly
                    }else{
                        $QuarterEndDate = $EndDate;
                    }
                    $Subscriptiondays = cal_days_in_month(CAL_GREGORIAN,$startmonth,date('Y',strtotime($QuarterStartDate)));
                    $seconds =  strtotime($QuarterEndDate) - strtotime($QuarterStartDate);
                    $days = round($seconds / 60 / 60  /24);
                    Log::info('start day ' . $QuarterStartDate.' end day '.$QuarterEndDate);
                    Log::info('days diff - ' . $days.' subscription days '.$Subscriptiondays);
                    if ($Subscriptiondays == $days) { // if monthly
                        $TotalAmount += $Subscription->MonthlyFee;
                        Log::info('MonthlyFee = '.$Subscription->MonthlyFee);
                    } else if ($days == 7) { // if weekly
                        $TotalAmount += $Subscription->WeeklyFee;
                        Log::info('WeeklyFee = '.$Subscription->WeeklyFee);
                    } else { // if daily
                        $TotalAmount += $days * $Subscription->DailyFee;
                        Log::info('DailyFee = '.$Subscription->DailyFee.' days '.$days);
                    }
                    $QuarterStartDate = date("Y-m-d", strtotime("first day of next month ",strtotime($QuarterStartDate)));
                }
                Log::info(' ========== quarterly end ============');

            } else if ($Subscriptiondays == $days) { // if monthly
                $TotalAmount += $Subscription->MonthlyFee;
            } else if ($days == 7) { // if weekly
                $TotalAmount += $Subscription->WeeklyFee;
            } else { // if daily
                $TotalAmount += $days * $Subscription->DailyFee;
            }

        }
        return $TotalAmount;
    }
}