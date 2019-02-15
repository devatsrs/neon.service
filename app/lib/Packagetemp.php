<?php
namespace App\Lib;
class Packagetemp extends \Eloquent
{
    //Package
    protected $guarded = array("ProductId");

    protected $table = 'tblPackage_temp';

    protected $primaryKey = "ProductId";


}