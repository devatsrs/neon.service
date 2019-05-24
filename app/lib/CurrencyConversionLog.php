<?php namespace App\Lib;

use Illuminate\Database\Eloquent\Model;

class CurrencyConversionLog extends Model {

    protected $fillable = [
        'CurrencyID','CompanyID','EffectiveDate','created_at','Value','CreatedBy',
    ];
    protected $table = "tblCurrencyConversionLog";
    public $timestamps = false;

}
