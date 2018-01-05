<?php
namespace App\Lib;
use Validator;
use Illuminate\Support\Facades\DB;

class Contact extends \Eloquent{

    protected $guarded = array();

    protected $table = 'tblContact';

    protected  $primaryKey = "ContactID";
    public static $rules = array(
       // 'AccountID' =>      'required',
        'CompanyID' =>  'required',
        'FirstName' => 'required',
        'LastName' => 'required',
    );


    public static function get_full_name($ContactID) {

        $contactInfo = Contact::where(["ContactID" => $ContactID])->select(["FirstName","LastName"])->first();

        if(isset($contactInfo->FirstName) && isset($contactInfo->LastName)){
            return $contactInfo->FirstName.' '. $contactInfo->LastName;
        }

    }

}