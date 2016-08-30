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
	
   static function GetIntegrationDataBySlug($slug){
	   
	   $companyID	=  User::get_companyID();
	   
	  $Subcategory = Integration::select("*");
	  $Subcategory->leftJoin('tblIntegrationConfiguration', function($join)
		{
			$join->on('tblIntegrationConfiguration.IntegrationID', '=', 'tblIntegration.IntegrationID');
	
		})->where(["tblIntegration.CompanyID"=>$companyID])->where(["tblIntegration.Slug"=>$slug]);
		 $result = $Subcategory->first();
		 return $result;
   } 
}