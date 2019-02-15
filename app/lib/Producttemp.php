<?php
namespace App\Lib;
class Producttemp extends \Eloquent
{
    //Package
    protected $guarded = array("ProductId");

    protected $table = 'tblProducts_temp';

    protected $primaryKey = "ProductId";


}