<?php

class RateGenerator extends \Eloquent {

    protected $fillable = [];
    protected $guarded = array();
    protected $table = 'tblRateGenerator';
    protected $primaryKey = "RateGeneratorId";
	
	public function raterule()
    {
        return $this->hasMany('RateRule');
    }

}