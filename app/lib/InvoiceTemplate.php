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

    public static  function defaultUsageColumns(){
        $UsageColumn = array();
        /* Default Value */
        $test_detail='[{"Title":"Prefix","ValuesID":"1","UsageName":"Prefix","Status":true,"FieldOrder":1},{"Title":"CLI","ValuesID":"2","UsageName":"CLI","Status":true,"FieldOrder":2},{"Title":"CLD","ValuesID":"3","UsageName":"CLD","Status":true,"FieldOrder":3},{"Title":"ConnectTime","ValuesID":"4","UsageName":"Connect Time","Status":true,"FieldOrder":4},{"Title":"DisconnectTime","ValuesID":"4","UsageName":"Disconnect Time","Status":true,"FieldOrder":5},{"Title":"BillDuration","ValuesID":"6","UsageName":"Duration","Status":true,"FieldOrder":6},{"Title":"ChargedAmount","ValuesID":"7","UsageName":"Cost","Status":true,"FieldOrder":7},{"Title":"BillDurationMinutes","ValuesID":"8","UsageName":"DurationMinutes","Status":false,"FieldOrder":8},{"Title":"Country","ValuesID":"9","UsageName":"Country","Status":true,"FieldOrder":9},{"Title":"CallType","ValuesID":"10","UsageName":"CallType","Status":true,"FieldOrder":10},{"Title":"Description","ValuesID":"11","UsageName":"Description","Status":false,"FieldOrder":11}]';
        $UsageColumn['Detail']  =  json_decode($test_detail,true);

        $test_summary='[{"Title":"Trunk","ValuesID":"1","UsageName":"Trunk","Status":true,"FieldOrder":1},{"Title":"AreaPrefix","ValuesID":"2","UsageName":"Prefix","Status":true,"FieldOrder":2},{"Title":"Country","ValuesID":"3","UsageName":"Country","Status":true,"FieldOrder":3},{"Title":"Description","ValuesID":"4","UsageName":"Description","Status":true,"FieldOrder":4},{"Title":"NoOfCalls","ValuesID":"5","UsageName":"No of calls","Status":true,"FieldOrder":5},{"Title":"Duration","ValuesID":"6","UsageName":"Duration","Status":true,"FieldOrder":6},{"Title":"BillDuration","ValuesID":"7","UsageName":"Billed Duration","Status":true,"FieldOrder":7},{"Title":"AvgRatePerMin","ValuesID":"8","UsageName":"Avg Rate/Min","Status":true,"FieldOrder":8},{"Title":"ChargedAmount","ValuesID":"7","UsageName":"Cost","Status":true,"FieldOrder":9}]';
        $UsageColumn['Summary']  =  json_decode($test_summary,true);

        return $UsageColumn;

    }

    public static function DisplayCallType($dataarrays){
        $CallType=0;
        foreach($dataarrays as $us){
            if($us['Title']=='CallType' && $us['Status']==1){
                $CallType=1;
            }
        }
        return $CallType;
    }
}