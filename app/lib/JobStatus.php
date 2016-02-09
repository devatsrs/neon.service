<?php

namespace App\Lib;

class JobStatus extends \Eloquent {
	protected $fillable = [];

	protected $table = "tblJobStatus";
	protected  $primaryKey = "JobStatusID";

    public static function getJobStatusIDList(){
        $row = JobStatus::lists( 'Title','JobStatusID');
        if(!empty($row)){
            $row = array(""=> "Select a Status")+$row;
        }
        return $row;

    }
}