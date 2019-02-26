<?php namespace App\Lib;

use App\SippySSH;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class VosIP extends Model {

    protected $fillable = [];
    protected $connection = 'sqlsrv';
    protected $guarded = array('VOSIPID');

    protected $table = 'tblVosIP';

    protected  $primaryKey = "VOSIPID";



}
