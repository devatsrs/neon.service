<?php
namespace App\Lib;

class Notification extends \Eloquent {

    protected $guarded = array();

    protected $table = 'tblNotification';
    protected  $primaryKey = "NotificationID";

    const InvoiceCopy = 1;
    const ReRate=2;
    const WeeklyPaymentTransactionLog=3;
    const LowBalanceReminder=4;
    const PendingApprovalPayment=5;
    const RetentionDiskSpaceEmail=6;
    const PaymentReminder=7;

    public static $type = [ Notification::InvoiceCopy=>'Invoice Copy',
        Notification::ReRate=>'Re Rate Log',
        Notification::WeeklyPaymentTransactionLog=>'Weekly Payment Transaction Log',
        Notification::LowBalanceReminder=>'Low Balance Reminder',
        Notification::PendingApprovalPayment=>'Pending Approval Payment',
        Notification::RetentionDiskSpaceEmail=>'Retention Disk Space Email'];

    const INVOICE_BASE=1;
    const PAYMENT_BASE=2;

    public static $paymentreminder_type = [
        Notification::INVOICE_BASE=>'Invoice',
        Notification::PAYMENT_BASE=>'Payment'

    ];

    public static function getNotificationMail($data){
        $Notification = Notification::where(['CompanyID'=>$data['CompanyID'],'NotificationType'=>$data['NotificationType'],'Status'=>1])->pluck('EmailAddresses');
        return empty($Notification)?'':$Notification;
    }

    public static function getNotificationSettings($data){
        $Notification = Notification::where(['CompanyID'=>$data['CompanyID'],'NotificationType'=>$data['NotificationType'],'Status'=>1])->pluck('Settings');
        return empty($Notification)?'':$Notification;
    }
}