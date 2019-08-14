<?php namespace App\Console\Commands;

use App\Lib\CompanyGateway;
use App\Lib\CronJob;
use App\Lib\EmailClient;
use App\Lib\TempUsageDetail;
use App\Lib\TempUsageDownloadLog;
use App\Lib\UsageDetail;
use App\Porta;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use League\Flysystem\Exception;
use Symfony\Component\Console\Input\InputArgument;
use Webklex\IMAP\Facades\Client;
use Webpatser\Uuid\Uuid;

class TempCommand extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'tempcommand';

	/**
	 * The console command description.
	 *
	 * @var string
	 */
	protected $description = 'Command description.';

	/**
	 * Create a new command instance.
	 *
	 * @return void
	 */
	public function __construct()
	{
		parent::__construct();
	}
    protected function getArguments()
    {
        return [
            ['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID '],
        ];
    }


    /**
	 * Execute the console command.
	 *
	 * @return mixed
	 */
    public function handle()
	{


		echo Crypt::decrypt("eyJpdiI6IjVyUkVKZ3RnMjVnSzA1Z0tWUlUxbnc9PSIsInZhbHVlIjoiOGdwVFNmdFRSUmowK1ZKXC9NOVwvZUc2ODVaYjRpMUVTZGJIZ2tqamxVczZnPSIsIm1hYyI6IjJkOTMwOTBjNTVhZGI5NmEzYTk2MmI4YTdkMjIzZjllMWJlNzdkMGM1N2JhZTFiM2I3NjdjMjc0MjgwYWYxYTkifQ==");
		exit;

		$mail = new \PHPMailer();
		$mail->setFrom('neon@mcxess.com', 'neon@mcxess');
		$mail->addAddress('shriramsoft@gmail.com', 'Dev');
		$mail->Subject  = 'First PHPMailer Message';
		$mail->Body     = 'Hi! This is my first e-mail sent through PHPMailer.';
		if(!$mail->send()) {
			echo 'Message was not sent.';
			echo 'Mailer error: ' . $mail->ErrorInfo;
		} else {
			echo 'Message has been sent.';
		}


		function xml_encode($mixed, $domElement=null, $DOMDocument=null) {
			if (is_null($DOMDocument)) {
				$DOMDocument =new \DOMDocument();
				$DOMDocument->formatOutput = true;
				xml_encode($mixed, $DOMDocument, $DOMDocument);
				echo $DOMDocument->saveXML();
			}
			else {
				if (is_array($mixed)) {
					foreach ($mixed as $index => $mixedElement) {
						if (is_int($index)) {
							if ($index === 0) {
								$node = $domElement;
							}
							else {
								$node = $DOMDocument->createElement($domElement->tagName);
								$domElement->parentNode->appendChild($node);
							}
						}
						else {
							$plural = $DOMDocument->createElement($index);
							$domElement->appendChild($plural);
							$node = $plural;
							if (!(rtrim($index, 's') === $index)) {
								$singular = $DOMDocument->createElement(rtrim($index, 's'));
								$plural->appendChild($singular);
								$node = $singular;
							}
						}

						xml_encode($mixedElement, $node, $DOMDocument);
					}
				}
				else {
					$domElement->appendChild($DOMDocument->createTextNode($mixed));
				}
			}
		}


		$data = array();
		for ($i = 0; $i < 3; $i++) {
			$data['users'][] = array(
				'name' => 'user' . $i,
				'img' => 'http://www.example.com/user' . $i . '.png',
				'website' => 'http://www.example.com/',
			);
		}

//header('Content-Type: application/xml');
		//echo xmlrpc_encode($data);
		//$data = json_decode(json_encode($data), true);
		function array2xml($array, $xml = false){

			if($xml === false){
				$xml = new \SimpleXMLElement('<result/>');
			}

			foreach($array as $key => $value){
				if(is_array($value)){
					array2xml($value, $xml->addChild($key));
				} else {
					$xml->addChild($key, $value);
				}
			}

			return $xml->asXML();
		}


		echo $xml = array2xml($data, false);

		exit;


		if(is_numeric(intval("upted"))){
			echo "yes";
		}else {
			echo "no";
		}

		exit;
	/*	try {
			imap_open(
				"{mail.suretel.co.za:143}INBOX",
				'test@suretel.co.za',
				'9*45dQbT5S4F.7@mxchK$J*#3'
			);
			return true;
		} catch (\ErrorException $e) {
			Log::error("Unable to validate");
			Log::error($e);
			return false;
		}*/




		/*array (
			'username' => 'test@suretel.co.za',
			'host' => 'mail.suretel.co.za',
			'port' => 143,
			'IsSSL' => 0,
			'password' => '9*45dQbT5S4F.7@mxchK$J*#3',
		)  */

		//array('username'=>$email,"host"=>$server,"port"=>$port,"IsSSL"=>$IsSsl,"password"=>$password)
		$oClient = new EmailClient([
			'host' => "mail.suretel.co.za",
			//'port' => '143',
			'port' => '993',
			'IsSSL' => 1,
			'username' => 'test@suretel.co.za',
			'password' => '9*45dQbT5S4F.7@mxchK$J*#3',
		]);

		$oClient = new EmailClient([
			'host' => "imap.europe.secureserver.net",
			//'port' => '143',
			'port' => '993',
			'IsSSL' => 1,
			'username' => 'bhavin@code-desk.com',
			'password' => 'N3on-S0ft',
		]);

		$connected = $oClient->connect();
		//Connect to the IMAP Server
		if(!$connected){
			echo "failed";
		}
		$aFolder = $connected->getFolders(false,"INBOX");

		foreach($aFolder as $oFolder) {
					echo PHP_EOL . $oFolder->fullName;
		}


	}

}
