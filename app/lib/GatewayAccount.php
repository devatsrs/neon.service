<?php
namespace App\Lib;
class GatewayAccount extends \Eloquent {
	protected $fillable = [];
    protected $connection = 'sqlsrv2';
    protected $table = 'tblGatewayAccount';
    public $timestamps = false; // no created_at and updated_at

    public static function getAccountIDList($CompanyID,$gatewayid=0){
        $row = GatewayAccount::where(array('CompanyID'=>$CompanyID))->select(array('AccountName', 'GatewayAccountID'))->orderBy('AccountName')->lists('AccountName', 'GatewayAccountID');
        if(!empty($row)){
            $row = array(""=> "Select a Account")+$row;
        }
        return $row;
    }

}