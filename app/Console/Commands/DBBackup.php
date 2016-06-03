<?php namespace App\Console\Commands;

use App\Lib\Company;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Log;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;

class DBBackup extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'dbbackup';

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
			['BackupConfigFile', InputArgument::REQUIRED, 'automysqlbackup Config File Path'],
			['AWS_PATH', InputArgument::REQUIRED, 'AWS Directory Path to upload Backup Files ie. neon.backup/ '],
		];
	}

	/**
	 * Execute the console command.
	 *
	 * @return mixed
	 */
	public function fire()
	{
		Log::useFiles(storage_path() . '/logs/dbbackup-' . '-' . date('Y-m-d') . '.log');




		try{

			$arguments = $this->argument();
			$getmypid = getmypid(); // get proccess id
			$CompanyID = $arguments["CompanyID"];
			$BackupConfigFile = $arguments["BackupConfigFile"];
			$AWS_PATH = $arguments["AWS_PATH"];


			Log::info ( "Start " );

			Log::info ( "Starting backup..." );

			exec(getenv("BACKUP_COMMAND") . ' '  . $BackupConfigFile , $bk_output);//solo -port=6000 /usr/local/bin/automysqlbackup /etc/automysqlbackup/uk-neonlicence.conf

			Log::info ( "Backup is Completed "   );
			Log::info( " Output " . print_r($bk_output,true) );

			Log::info ( "Setting up Permissions" ); ;

			# Set permission to root user only.
			exec('chown root.root ' . getenv("BACKUP_DIR") . '* -R');
			exec('find ' . getenv("BACKUP_DIR"). '* -type f -exec chmod 400 {} \;');
			exec('find ' . getenv("BACKUP_DIR"). '* -type d -exec chmod 700 {} \;');

			Log::info ( "Uploading Backup to AmazonS3 "  );;

			exec(getenv("BACKUP_AWS_UPLOAD_COMMAND") . ' ' . $AWS_PATH , $aws_output) ;//solo -port=6001 s3cmd sync /home/autobackup/db/daily/neonlicencing s3://neon.backup/

			Log::info ( "Uploading Backup to AmazonS3 Completed "  );;
			Log::info ( "Output " . print_r($aws_output,true) );

			Log::info ( "Done! "  );

			$message = "DB Backup Completed with following output.";
			$message .= "<br> Output  " . print_r($bk_output,true);
			$message .= "<br> Output  " . print_r($aws_output,true);

			$this->send_update_email($CompanyID,$message);


		}catch (\Exception $ex) {

			Log::info( "Exception " . $ex->getMessage() );
			Log::info( "Full Exception" . print_r($ex,true) );

			$message = "DB Backup Failed";
			$message .= "<br> <b>" . $ex->getMessage() ."</b>";
			$message .= "<br> " . print_r($ex,true);

			$this->send_update_email($CompanyID,$message);


		}

	}

	public function send_update_email($CompanyID,$message){

		try{

			/// Email to
			$emaildata['EmailTo'] = getenv("BACKUP_EMAIL");
			$emaildata['EmailToName'] = getenv("BACKUP_EMAIL_NAME");
			$emaildata['Subject'] ="Backup Update ";
			$emaildata['CompanyID'] = $CompanyID;
			$emaildata['data'] =array('message' => $message, 'CompanyName'=>getenv("BACKUP_EMAIL_NAME"));

			$status = Helper::sendMail('emails.backup.backup_email',$emaildata);

		}catch (\Exception $ex) {

			Log::info( "Error Sending Email Exception " . $ex->getMessage() );
			Log::info( "Full Exception" . print_r($ex,true) );

		}
	}
}
