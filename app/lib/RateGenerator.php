<?php

class RateGenerator extends \Eloquent {

    protected $fillable = [];
    protected $guarded = array();
    protected $table = 'tblRateGenerator';
    protected $primaryKey = "RateGeneratorId";

    const VoiceCall = 1;
    const DID = 2;

    public function raterule()
    {
        return $this->hasMany('RateRule');
    }

}