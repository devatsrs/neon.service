<?php
namespace App\Lib;
class TempDialPlan extends \Eloquent {
	protected $fillable = [];
    public $timestamps = false; // no created_at and updated_at

    protected $guarded = array('TempDialPlanID');

    protected $table = 'tblTempDialPlan';

    protected  $primaryKey = "TempDialPlanID";

}