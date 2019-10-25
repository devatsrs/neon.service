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
        $NodeLocalIP = CronJob::GetNodesFromCronJob($CronJobID,$CompanyID,$Type);
        if(!empty($NodeLocalIP)){
            if(self::MatchCronJobNodeWithCurrentServer($NodeLocalIP)){
                Log::info('local node ip '. $NodeLocalIP);
                return true;
            }
        }
        return false;		
    }

    public static function MatchCronJobNodeWithCurrentServer($NodeLocalIP){
        $CurrentServerIp =  getenv("SERVER_LOCAL_IP");
        log::info('env local ip' . $CurrentServerIp);
        if($NodeLocalIP === $CurrentServerIp){
            return true;
        }else{
            return false;
        }
       
    }

}