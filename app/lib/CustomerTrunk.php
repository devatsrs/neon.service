<?php

namespace App\Lib;

class CustomerTrunk extends \Eloquent {
    protected $fillable = [];
    protected $guarded = array('CustomerTrunkID');
    protected $table = 'tblCustomerTrunk';

    protected  $primaryKey = "CustomerTrunkID";


    public static function getCustomerTrunksByTrunkAsKey($AccountID=0){

        $customer_trunks = CustomerTrunk::where(["AccountID"=>$AccountID,"Status"=>1])->get()->toArray();
        $records = array();
        foreach ($customer_trunks as $customer_trunk) {
            $records[$customer_trunk['TrunkID']] = $customer_trunk;
        }
        return $records;
    }

}