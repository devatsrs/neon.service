<?php
namespace App\Lib;
use Webklex\IMAP\Client;
use App\Lib\AutoImportInboxSetting;
use Illuminate\Support\Facades\Log;
class EmailClient
{

    protected $clientData;
    protected $host;
    protected $port;
    protected $IsSSL = 'TLS';
    protected $validate_cert = 'false';
    protected $username;
    protected $password;
    public function __construct($data = array()){
        if(is_array($data) && count($data)){
            foreach($data as $key => $value){
                $this->$key = $value;
            }
        }
        if($this->IsSSL == 1 ){
            $this->IsSSL='ssl';
            $this->validate_cert='true';
        }
    }
    function connectClientEmail($CompanyID)
    {
        $inboxSetting = AutoImportInboxSetting::select('host','port','IsSSL','username','password')->where('CompanyID','=',$CompanyID)->get();
        $oClient = new Client([
            'host' => $inboxSetting[0]->host,
            'port' => $inboxSetting[0]->port,
            'IsSSL' => $inboxSetting[0]->IsSSL==1?'ssl':'tls',
            'validate_cert' => $inboxSetting[0]->IsSSL==1? 'true':'false',
            'username' => $inboxSetting[0]->username,
            'password' => $inboxSetting[0]->password,
        ]);

        //Connect to the IMAP Server
        $oClient->connect();
        return  $oClient;

    }

    function connect(){

        $oClient = new Client([
            'host' => $this->host,
            'port' => $this->port,
			'IsSSL' => $this->IsSSL,
            'validate_cert' => $this->validate_cert,
            'username' => $this->username,
            'password' => $this->password,
        ]);

        //Connect to the IMAP Server
        $oClient->connect();
        return  $oClient;
    }

    function getEmailFolder($oClient){
        //Get all Mailboxes

        /** @var \Webklex\IMAP\Support\FolderCollection $aFolder */
        return $aFolder = $oClient->getFolders(false);
    }

}