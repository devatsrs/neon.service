<?php
namespace App\Lib;


class TaxRate extends \Eloquent {

    protected $table = 'tblTaxRate';
    public $primaryKey = "TaxRateId";
    protected $fillable = [];
    protected $guarded = ['TaxRateId'];

    const TAX_ALL =1;
    const TAX_USAGE =2;
    const TAX_RECURRING =3;

    public static function getTaxName($TaxRateId){
        return $TaxRate = TaxRate::where(["TaxRateId"=>$TaxRateId])->pluck('Title');
    }

    public static function getAllTaxName($CompanyID){
        $items = TaxRate::select(['TaxRateId','Title'])->where('CompanyId',$CompanyID)->lists('Title','TaxRateId');
        return $items;
    }

    public static function calculateProductTaxAmount($TaxRateID,$Price) {
        if($TaxRateID>0){
            $TaxRate = TaxRate::where("TaxRateID",$TaxRateID)->first();
            if(isset($TaxRate->TaxType) && isset($TaxRate->Amount) ) {
                if (isset($TaxRate->FlatStatus) && isset($TaxRate->Amount)) {
                    if ($TaxRate->FlatStatus == 1) {
                        return $TaxRate->Amount;
                    } else {
                        return (($Price * $TaxRate->Amount) / 100);
                    }
                }
            }
        }
        return 0;
    }

}