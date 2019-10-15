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
        $Node = CronJob::GetNodesFromCronJob($CronJobID,$CompanyID,$Type);
        if($Node){
            if(self::MatchCronJobNodeWithCurrentServer($Node)){
                Log::info('local node ip '. $Node);
                return $Node;
            }else{
                return false;
            }
        }
        return false;		
    }

    public static function MatchCronJobNodeWithCurrentServer($NodeIp){
        $CurrentIp =  getenv("SERVER_LOCAL_IP");
        log::info('env local ip' . $CurrentIp);
        if($NodeIp == $CurrentIp){
            return true;
        }else{
            return false;
        }
       
    }

}