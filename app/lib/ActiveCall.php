<?php
namespace App\Lib;

class ActiveCall extends \Eloquent {

    protected $connection = 'speakIntelligentRoutingEngine';
    protected $fillable = [];
    protected $guarded = array('ActiveCallID');
    protected $table = 'tblActiveCall';
    public  $primaryKey = "ActiveCallID"; //Used in BasedController


    public static function getUniqueAccountID($CompanyID){
        return ActiveCall::where('CompanyId',$CompanyID)->groupby('AccountId')->lists('AccountId');

    }

    public static function getUUIDByAccountID($CompanyID,$AccountID){
        return ActiveCall::where(['CompanyId'=>$CompanyID,'AccountId'=>$AccountID])->groupby('UUID')->lists('UUID');

    }

}