<?php
namespace App\Lib;
use Symfony\Component\Intl\Intl;
class CurrencyConversion extends \Eloquent {

    protected $fillable = [];
    protected $table = "tblCurrencyConversion";
    protected $primaryKey = "ConversionID";
}