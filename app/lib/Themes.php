<?php
namespace App\Lib;

use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\View;
use Illuminate\Support\Str;

class Themes extends \Eloquent {
	
    protected $connection 	= 	'sqlsrv';
    protected $fillable 	= 	[];
    protected $guarded 		= 	array('ThemeID');
    protected $table 		= 	'tblCompanyThemes';
    protected $primaryKey 	= 	"ThemeID";
    const INACTIVE 			= 	'inactive';
    const ACTIVE 			= 	'active';
	
}