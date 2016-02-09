<?php
namespace App\Lib;
class AccountPaymentProfile extends \Eloquent {
    protected $fillable = [];
    protected $guarded = array('AccountPaymentProfileID');
    protected $table = 'tblAccountPaymentProfile';
    protected $primaryKey = "AccountPaymentProfileID";

    public static function getActiveProfile($AccountID){
        $AccountPaymentProfile =array();
        if(Account::where(array('AccountID'=>$AccountID))->pluck('Autopay') == 1) {
            $AccountPaymentProfile = AccountPaymentProfile::where(array('AccountID' => $AccountID, 'Status' => 1, 'Blocked' => 0, 'isDefault' => 1))->first();
        }
        return $AccountPaymentProfile;
    }
    public static function setProfileBlock($AccountPaymentProfileID){
        AccountPaymentProfile::where(array('AccountPaymentProfileID'=>$AccountPaymentProfileID))->update(array('Blocked'=>1));
    }
}