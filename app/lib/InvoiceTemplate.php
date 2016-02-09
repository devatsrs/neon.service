<?php
namespace App\Lib;

class InvoiceTemplate extends \Eloquent {
    protected $connection = 'sqlsrv2';
    protected $fillable = [];
    protected $guarded = array('InvoiceTemplateID');
    protected $table = 'tblInvoiceTemplate';
    protected  $primaryKey = "InvoiceTemplateID";

    public static function getNextInvoiceNumber($InvoiceTemplateid,$CompanyId){
        $InvoiceTemplate = InvoiceTemplate::find($InvoiceTemplateid);
        $NewInvoiceNumber =  (($InvoiceTemplate->LastInvoiceNumber > 0)?($InvoiceTemplate->LastInvoiceNumber + 1):$InvoiceTemplate->InvoiceStartNumber);
        while(Invoice::where(["CompanyID"=> $CompanyId,'InvoiceNumber'=>$NewInvoiceNumber])->count() ==1){
            $NewInvoiceNumber++;
        }
        return $NewInvoiceNumber;
    }

}