<?php
namespace app\lib;
class RateTableDIDRate extends \Eloquent {

    protected $fillable = [];
    protected $guarded= [];
    protected $table = 'tblRateTableDIDRate';
    protected $primaryKey = "RateTableDIDRateID";

    public static $rules = [
        'RateID'        =>      'required',
        'RateTableId'   =>      'required',
        'EffectiveDate' =>      'required',
        'TimezonesID'   =>      'required',
    ];

    public static $Components = array(
        "OneOffCost"                => "One-Off cost",
        "MonthlyCost"               => "Monthly cost",
        "CostPerCall"               => "Cost Per Call",
        "CostPerMinute"             => "Cost Per Minute",
        "SurchargePerCall"          => "Surcharge Per Call",
        "SurchargePerMinute"        => "Surcharge Per Minute",
        "OutpaymentPerCall"         => "Outpayment Per Call",
        "OutpaymentPerMinute"       => "Outpayment Per Minute",
        "Surcharges"                => "Surcharges",
        "Chargeback"                => "Chargeback",
        "CollectionCostAmount"      => "Collection Cost Amount",
        "CollectionCostPercentage"  => "Collection Cost (%)",
        "RegistrationCostPerNumber" => "Registration Cost Per Number",
    );
}