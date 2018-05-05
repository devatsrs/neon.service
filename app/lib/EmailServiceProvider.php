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

}