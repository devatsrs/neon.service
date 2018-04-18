<?php
namespace App\Lib;
use Webklex\IMAP\Client;
use App\Lib\AutoImportInboxSetting;
class EmailClient
{

    protected $clientData;
    function connectClientEmail($CompanyID)
    {
        $inboxSetting = AutoImportInboxSetting::select('host','port','encryption','validate_cert','username','password')->where('CompanyID','=',$CompanyID)->get();
        $oClient = new Client([
            'host' => $inboxSetting[0]->host,
            'port' => $inboxSetting[0]->port,
            'encryption' => $inboxSetting[0]->encryption,
            'validate_cert' => $inboxSetting[0]->validate_cert,
            'username' => $inboxSetting[0]->username,
            'password' => $inboxSetting[0]->password,
        ]);

        //Connect to the IMAP Server
        $oClient->connect();
        return  $oClient;

    }
    function getEmailFolder($oClient){
        //Get all Mailboxes

        /** @var \Webklex\IMAP\Support\FolderCollection $aFolder */
        return $aFolder = $oClient->getFolders();
    }

}