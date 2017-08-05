<?php

namespace App\Lib;

class VendorTrunk extends \Eloquent {
    protected $fillable = [];
    protected $guarded = array('VendorTrunkID');
    protected $table = 'tblVendorTrunk';

    protected  $primaryKey = "VendorTrunkID";


    public static function getVendorTrunksByTrunkAsKey($AccountID=0){

        $vendor_trunks = VendorTrunk::where(["AccountID"=>$AccountID,"Status"=>1])->get()->toArray();
        $records = array();
        foreach ($vendor_trunks as $vendor_trunk) {
            $records[$vendor_trunk['TrunkID']] = $vendor_trunk;
        }
        return $records;
    }

}