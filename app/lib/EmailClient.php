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
    protected $IsSSL = 'tls';
    protected $validate_cert = 0;
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
            $this->validate_cert=1;
        }
    }
    function connectClientEmail($CompanyID)
    {
        $inboxSetting = AutoImportInboxSetting::select('host','port','IsSSL','username','password')->where('CompanyID','=',$CompanyID)->get();

        if($this->IsSSL == 1 ){
            $this->IsSSL='ssl';
            $this->validate_cert = 1;
        }

        $oClient = new Client([
            'host' => $inboxSetting[0]->host,
            'port' => $inboxSetting[0]->port,
            'validate_cert' => $this->validate_cert,
            'encryption' => $this->IsSSL,
            'username' => $inboxSetting[0]->username,
            'password' => $inboxSetting[0]->password,
        ]);

        //Connect to the IMAP Server
        $oClient->connect();
        return  $oClient;

    }

    function connect(){

        $req = [
            'host' => $this->host,
            'port' => $this->port,
            'validate_cert' => $this->validate_cert,
            'encryption' => $this->IsSSL,
            'username' => $this->username,
            'password' => $this->password,
        ];
        $oClient = new Client($req);
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