<?php
namespace App\Lib;
use App\Lib\EmailClient;
use Webklex\IMAP\Client;


class EmailServiceProvider
{


    // contructor

    public function connectEmail($CompanyID)
    {
        $EmailClient = new EmailClient();
        $connect = $EmailClient->connectClientEmail($CompanyID);
        if($connect){
            return $EmailClient->getEmailFolder($connect);
        }else{
            return false;
        }
    }

    public static function getCC($cc){

            if (!empty($cc)) {
            foreach ($cc as $ccmail) {
            $cmail[] = $ccmail->mail;
            }
                $ccemail = implode(", ", $cmail);
            } else {
                $ccemail = '';
            }
        return $ccemail;

    }

    public static function GetMatchSubjectEmail($fromMail,$CompanyID){
        $autoImportSetting = \DB::table("tblAutoImportSetting")->whereRaw(" CompanyID = '".$CompanyID."' AND '".$fromMail."' LIKE  CONCAT('%', SendorEmail, '%')  ")->count();
        return $autoImportSetting;
    }

    Public static function GetMappingArray(){
        $Staticdata =
            Array	(
                "option" => Array(
                    "Delimiter" => '',
                    "Enclosure" =>'',
                    "Escape" => '',
                    "Firstrow" => "columnname"
                ),
                "selection" => Array(
                    "Code" => "Code",
                    "Description" => "Destination",
                    "Rate" => "Rate",
                    "EffectiveDate" => "Effective Date",
                    "Action" => "Action",
                    "ActionInsert" => "I",
                    "ActionUpdate" => "U",
                    "ActionDelete" => "D",
                    "Interval1" => "Interval1",
                    "IntervalN" => "IntervalN",
                    "ConnectionFee" => "Connection Fee",
                    "DateFormat" => "d-m-Y"
                )

            );
        return $Staticdata;
    }






}