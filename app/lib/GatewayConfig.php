<?php
namespace App\Lib;
class GatewayConfig extends \Eloquent {
	protected $fillable = [];

    protected $guarded = array('GatewayConfigID');

    protected $table = 'tblGatewayConfig';

    protected  $primaryKey = "GatewayConfigID";


    public static function getConfigTitle($GatewayConfigID){
        return GatewayConfig::where(array('GatewayConfigID'=>$GatewayConfigID))->pluck('Title');
    }
    public static function getConfigName($GatewayConfigID){
        return GatewayConfig::where(array('GatewayConfigID'=>$GatewayConfigID))->pluck('Name');
    }
}