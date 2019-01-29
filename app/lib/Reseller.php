<?php
namespace App\Lib;

class Reseller extends \Eloquent
{
    protected $guarded = array("ResellerID");

    protected $table = 'tblReseller';

    protected $primaryKey = "ResellerID";

    public static function getResellerAccountsByAccountID($AccountID,$CompanyGatewayID){
        $ResellerAccounts = array();
        $Reseller = Reseller::where(['AccountID'=>$AccountID,'Status'=>1])->first();
        if(!empty($Reseller) && count($Reseller)>0){
            $CompanyID = $Reseller->ChildCompanyID;
            $Count = Account::WHERE(['CompanyId'=>$CompanyID])->count();
            if($Count>0){
                $ResellerAccounts = DB::select('CALL prc_GetBlockUnblockAccount(?,?)', array($CompanyID, $CompanyGatewayID));
            }
        }
        return $ResellerAccounts;
    }

    /**
     * Company is reseller if yes than check main reseller account is block or not
    */
    public static function isResellerAndAccountBlock($CompanyID){
        $Blocked = 0;
        $Reseller = Reseller::where(['ChildCompanyID'=>$CompanyID,'Status'=>1])->first();
        if(!empty($Reseller) && count($Reseller)>0){
            $Blocked = Account::where(['AccountID'=>$Reseller->AccountID,'Blocked'=>1])->count();
        }
        return $Blocked;
    }
}