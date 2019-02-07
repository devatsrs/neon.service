<?php
namespace App\Lib;
use Symfony\Component\Intl\Intl;
class CurrencyConversion extends \Eloquent {

    protected $fillable = [
        'CompanyID', 'CurrencyID','Value','created_at','CreatedBy','updated_at','ModifiedBy','EffectiveDate',
    ];
    protected $table = "tblCurrencyConversion";
    protected $primaryKey = "ConversionID";


}