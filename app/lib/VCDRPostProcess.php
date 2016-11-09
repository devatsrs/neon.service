<?php
namespace App\Lib;


class VCDRPostProcess extends \Eloquent {

    protected $table = 'tblVCDRPostProcess';

    public $primaryKey = "VCDRPostProcessID";

    protected $fillable = [];

    protected $guarded = ['VCDRPostProcessID'];

    protected $connection = 'sqlsrvcdrazure';

}