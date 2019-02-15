<?php
namespace App\Lib;
class Producttemp extends \Eloquent
{
    //Package
    protected $guarded = array("id");

    protected $table = 'tblProducts_temp';

    protected $primaryKey = "id";


}