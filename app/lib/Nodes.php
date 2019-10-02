<?php

namespace App\Lib;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\View;

class Nodes extends \Eloquent{

	//protected $fillable = ["NoteID","CompanyID","AccountID","Title","Note","created_at","updated_at","created_by","updated_by" ];

    protected $guarded = array();

    protected $table = 'tblNode';

    protected  $primaryKey = "ServerID";

    public static $rules = array(
        'ServerName' =>      'required|unique:tblNode',
        'ServerIP' =>      'required|unique:tblNode',
        'Username' =>      'required|unique:tblNode',
    );

    public static function getActiveNodes(){
        $Nodes = Nodes::where('Status','1')->lists('ServerName','ServerIP');
        return $Nodes;
    }

    public static function GetActiveNodeFromCronjobNodes($CronJobID,$CompanyID){
        $Nodes = CronJob::GetNodesFromCronJob($CronJobID,$CompanyID);
        if($Nodes){
            foreach($Nodes as $val){
                if(self::MatchCronJobNodeWithCurrentServer($val['ServerIP'])){
                    return $val['ServerIP'];
                }
            }
        }
        return false;		
    }

    public static function MatchCronJobNodeWithCurrentServer($NodeIp){
        $host= gethostname();
        $CurrentIp = gethostbyname($host);
        if($NodeIp == $CurrentIp){
            return true;
        }else{
            return false;
        }
       
    }

}