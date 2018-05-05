<?php
namespace App\Lib;

class Reseller extends \Eloquent
{
    protected $guarded = array("ResellerID");

    protected $table = 'tblReseller';

    protected $primaryKey = "ResellerID";

}