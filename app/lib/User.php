<?php
namespace App\Lib;
use Illuminate\Support\Facades\Config;
use Maatwebsite\Excel\Facades\Excel;

class User extends \Eloquent {

    protected $fillable = [];
    protected $table = "tblUser";
    protected $primaryKey = "UserID";

    public static function getAllAM($CompanyID){
        $users = User::where(["CompanyID" => $CompanyID,"Status" => 1])->where('Roles', 'like', '%Account Manager%')->get(['EmailAddress']);
        $emailto = array();
        foreach($users as $user){
            if(!empty($user->EmailAddress)){
                $emailto[] = $user->EmailAddress;
            }
        }
    }
    public static function getUserInfo($userID){
         $userInfo = User::where(["UserID" => $userID])->first();
        return $userInfo;
    }

    public static function get_user_full_name($UserID){

        $userInfo = User::where(["UserID" => $UserID])->select(["FirstName","LastName"])->first();

        if(isset($userInfo->FirstName) && isset($userInfo->LastName)){
            return $userInfo->FirstName.' '. $userInfo->LastName;
        }

    }
	
	    public static function getUserIDByUserName($CompanyID,$Name){
        $UserID = '';
        $users = User::where(["CompanyID"=>$CompanyID,"Status"=>'1'])->get();
        if(count($users)>0){
            foreach($users as $user){
                $username = $user->FirstName.' '. $user->LastName;
                if($username==$Name){
                    if(!empty($user->UserID)){
                        $UserID = $user->UserID;
                    }
                }
            }
        }
        return $UserID;
    }
	
    /*public static function getMinUserID($CompanyID){
        return $UserID = User::where("CompanyID",$CompanyID)->where("Roles","like","%Admin%")->min("UserID");
    }*/

    public static function getDummyUserInfo($CompanyID,$Company){
        $User = new \stdClass();
        $User->UserID = 0;
        $User->CompanyID = $CompanyID;
        $User->FirstName = 'RM';
        $User->LastName = ' Scheduler';
        $User->EmailAddress = $Company->EmailFrom;
        return $User;
    }
}