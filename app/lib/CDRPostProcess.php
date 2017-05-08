<?php
namespace App\Lib;


class CDRPostProcess extends \Eloquent {

    protected $table = 'tblCDRPostProcess';

    public $primaryKey = "CDRPostProcessID";

    protected $fillable = [];

    protected $guarded = ['CDRPostProcessID'];

    protected $connection = 'sqlsrvcdr';

}