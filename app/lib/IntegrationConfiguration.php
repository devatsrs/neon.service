<?php
namespace App\Lib;
use Illuminate\Support\Facades\Config;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use App\Lib\CompanySetting;

class IntegrationConfiguration extends Model
{
    protected $guarded 		= 	array("IntegrationConfigurationID");
    protected $table 		= 	'tblIntegrationConfiguration';
    protected $primaryKey 	= 	"IntegrationConfigurationID";
	
    public static $rules = array(
    );	
	
   static function GetIntegrationDataBySlug($CompanyID,$slug){
	   
	  $Subcategory = Integration::select("*");
	  $Subcategory->leftJoin('tblIntegrationConfiguration', function($join) use($CompanyID)
		{
			$join->on('tblIntegrationConfiguration.IntegrationID', '=', 'tblIntegration.IntegrationID');
			$join->where('tblIntegrationConfiguration.CompanyID','=',$CompanyID);
	
		})->where(["tblIntegration.Slug"=>$slug]);
		 $result = $Subcategory->first();
		 return $result;
   } 
}