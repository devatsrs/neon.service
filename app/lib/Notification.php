<?php

class Notification extends \Eloquent {

    protected $guarded = array();

    protected $table = 'tblNotification';
    protected  $primaryKey = "NotificationID";

    const InvoiceGeneration = 1;
    const ReRate=2;
    const WeeklyPaymentTransactionLog=3;
    const LowBalanceReminder=4;
    const PendingApprovalPayment=5;

    public static $type = [ Notification::InvoiceGeneration=>'Invoice Generation',
        Notification::ReRate=>'Re Rate Log',
        Notification::WeeklyPaymentTransactionLog=>'Weekly Payment Transaction Log',
        Notification::LowBalanceReminder=>'Low Balance Reminder',
        Notification::PendingApprovalPayment=>'Pending Approval Payment'];

    public static function getNotificationMail($data){
        $Notification = Notification::where(['CompanyID'=>$data['CompanyID'],'NotificationType'=>$data['NotificationType']])->first();
        if(!empty($Notification)){
            return $Notification->EmailAddresses;
        }
        return '';
    }
}