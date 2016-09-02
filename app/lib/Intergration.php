<?php
namespace App\Lib;
use Illuminate\Support\Facades\Config;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use App\Lib\CompanySetting;

class Integration extends Model{
    protected $guarded 		= 	array("IntegrationID");
    protected $table 		= 	'tblIntegration';
    protected $primaryKey 	= 	"IntegrationID";
	
    public static $rules = array(
    );	  
}