<?php

namespace App\Lib;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\View;

class Nodes extends \Eloquent{


    Const JOB = "Job";
    Const CRONJOB = "CronJob";

	//protected $fillable = ["NoteID","CompanyID","AccountID","Title","Note","created_at","updated_at","created_by","updated_by" ];

    protected $guarded = array();

    protected $table = 'tblNode';

    protected  $primaryKey = "ServerID";

    public static $rules = array(
        'ServerName' =>      'required|unique:tblNode',
        'ServerIP' =>      'required|unique:tblNode',
        'Username' =>      'required',
    );

    public static function getActiveNodes(){
        $Nodes = Nodes::where('Status','1')->lists('ServerName','ServerIP');
        return $Nodes;
    }

    public static function GetActiveNodeFromCronjobNodes($CronJobID,$CompanyID,$Type){
        $Nodes = CronJob::GetNodesFromCronJob($CronJobID,$CompanyID,$Type);
        
        if($Nodes){
            foreach($Nodes as $val){
                if(self::MatchCronJobNodeWithCurrentServer($val['ServerIP'])){
                    Log::info('server node name '. $val['ServerIP']);
                    return $val['ServerIP'];
                }elseif(self::MatchCronJobNodeWithCurrentServer($val['LocalIP'])){
                    Log::info('local node name '. $val['LocalIP']);
                    return $val['LocalIP'];
                }
            }
        }
        return false;		
    }

    public static function MatchCronJobNodeWithCurrentServer($NodeIp){
        $CurrentIp = $host = gethostname();
        if($NodeIp == $CurrentIp){
            return true;
        }else{
            return false;
        }
       
    }

}