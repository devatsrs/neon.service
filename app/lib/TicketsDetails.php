<?php
namespace App\Lib;

class TicketsDetails extends \Eloquent
{
    protected $guarded = array("TicketsDetailsID");

    protected $table = 'tblTicketsDetails';

    protected $primaryKey = "TicketsDetailsID";	
   
}