<?php
namespace App\Lib;

class VendorFileUploadTemplate extends \Eloquent {
    protected $fillable = [];
    protected $guarded = array();
    protected $table = 'tblVendorFileUploadTemplate';
    protected $primaryKey = "VendorFileUploadTemplateID";

    public static function getTemplateIDList($CompanyID){
        $row = VendorFileUploadTemplate::where(['CompanyID'=>$CompanyID])->orderBy('Title')->lists('Title', 'VendorFileUploadTemplateID');
        if(!empty($row)){
            $row = array(""=> "Select an upload Template")+$row;
        }
        return $row;
    }

}