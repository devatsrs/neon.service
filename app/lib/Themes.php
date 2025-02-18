<?php
namespace App\Lib;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\View;
use Illuminate\Support\Str;
use Webpatser\Uuid\Uuid;

class Themes extends \Eloquent {
	
    protected $connection 	= 	'sqlsrv';
    protected $fillable 	= 	[];
    protected $guarded 		= 	array('ThemeID');
    protected $table 		= 	'tblCompanyThemes';
    protected $primaryKey 	= 	"ThemeID";
    const INACTIVE 			= 	'inactive';
    const ACTIVE 			= 	'active';
	

   public static function get_theme_status()
	{
       $Company 		= 	Company::find(User::get_companyID());		
       $themeStatus 	= 	explode(',','');
       $themearray 		= 	array(
	   										''=>'Select Theme Status',
											self::ACTIVE=>'Active',
	   										self::INACTIVE=>'Inactive'																					
								);
	   
        foreach($themeStatus as $status)
		{
            $themearray[$status] = $status;
        }
		
        return $themearray;
    }

}