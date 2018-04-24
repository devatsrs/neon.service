<?php
namespace App\Lib;

class FileUploadTemplate extends \Eloquent {
    protected $fillable = [];
    protected $guarded = array();
    protected $table = 'tblFileUploadTemplate';
    protected $primaryKey = "FileUploadTemplateID";
    const TEMPLATE_CDR              = 'CDR';
    const TEMPLATE_VENDORCDR        = 'VendorCDR';
    const TEMPLATE_Account          = 'Account';
    const TEMPLATE_Leads            = 'Leads';
    const TEMPLATE_DIALSTRING       = 'DialString';
    const TEMPLATE_IPS              = 'IPs';
    const TEMPLATE_ITEM             = 'Item';
    const TEMPLATE_VENDOR_RATE      = 'VendorRate';
    const TEMPLATE_PAYMENT          = 'Payment';
    const TEMPLATE_RATETABLE_RATE   = 'RatetableRate';
    const TEMPLATE_CUSTOMER_RATE    = 'CustomerRate';

    public static function getTemplateIDList($CompanyID,$Type){
        $row = FileUploadTemplate::where(['CompanyID'=>$CompanyID,'FileUploadTemplateTypeID'=>$Type])->orderBy('Title')->lists('Title', 'FileUploadTemplateID');
        if(!empty($row)){
            $row = array(""=> "Select an upload Template")+$row;
        }
        return $row;
    }

}