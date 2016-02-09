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

}