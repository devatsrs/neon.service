<?php
namespace App\Lib;

class JobFile extends \Eloquent {
	protected $fillable = [];

	protected $table = "tblJobFile";
	protected  $primaryKey = "JobFileID";
}