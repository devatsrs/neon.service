<?php
namespace App\Lib;
class AccountPaymentProfile extends \Eloquent {
    protected $fillable = [];
    protected $guarded = array('AccountPaymentProfileID');
    protected $table = 'tblAccountPaymentProfile';
    protected $primaryKey = "AccountPaymentProfileID";

    public static function getActiveProfile($AccountID,$PaymentGatewayID){
        $AccountPaymentProfile =array();
        $AccountPaymentProfile = AccountPaymentProfile::where(array('AccountID' => $AccountID,'PaymentGatewayID'=>$PaymentGatewayID,'Status' => 1, 'isDefault' => 1))
            ->Where(function($query)
            {
                $query->where("Blocked",'<>',1)
                    ->orwhereNull("Blocked");
            })
            ->first();
        return $AccountPaymentProfile;
    }
    public static function setProfileBlock($AccountPaymentProfileID){
        AccountPaymentProfile::where(array('AccountPaymentProfileID'=>$AccountPaymentProfileID))->update(array('Blocked'=>1));
    }
}