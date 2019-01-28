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
    const BlockAccount=7;
    const InvoicePaidByCustomer=8;
    const AutoAddIP=9;
    const AutoTopAccount=11;
    const ContractEnding=12;
    const AutoOutPayment=13;

    public static $type = [ Notification::InvoiceCopy=>'Invoice Copy',
        Notification::ReRate=>'Re Rate Log',
        Notification::WeeklyPaymentTransactionLog=>'Weekly Payment Transaction Log',
        Notification::LowBalanceReminder=>'Low Balance Reminder',
        Notification::PendingApprovalPayment=>'Payment Verification',
        Notification::BlockAccount=>'Block Account',
        Notification::RetentionDiskSpaceEmail=>'Retention Disk Space Email',
        Notification::InvoicePaidByCustomer=>'Invoice Paid',
        Notification::AutoAddIP=>'Auto Add IP',
        Notification::AutoTopAccount=>'Auto Top Account'

    ];

    public static function getNotificationMail($data){
        $Notification = Notification::where(['CompanyID'=>$data['CompanyID'],'NotificationType'=>$data['NotificationType'],'Status'=>1])->pluck('EmailAddresses');
        return empty($Notification)?'':$Notification;
    }
}