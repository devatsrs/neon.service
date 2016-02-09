<?php
namespace App\Lib;

class FileUploadTemplate extends \Eloquent {
    protected $fillable = [];
    protected $guarded = array();
    protected $table = 'tblFileUploadTemplate';
    protected $primaryKey = "FileUploadTemplateID";
    const TEMPLATE_CDR = 1;

    public static function getTemplateIDList($Type){
        $row = FileUploadTemplate::where(['CompanyID'=>User::get_companyID(),'Type'=>$Type])->orderBy('Title')->lists('Title', 'FileUploadTemplateID');
        if(!empty($row)){
            $row = array(""=> "Select an upload Template")+$row;
        }
        return $row;
    }

}