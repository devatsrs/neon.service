<?php
namespace App\Lib;

class DealDetail extends \Eloquent {

    protected $guarded      = array("DealDetailID");
    protected $table        = 'tblDealDetail';
    protected $primaryKey   = "DealDetailID";

}