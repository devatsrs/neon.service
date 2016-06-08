<?php namespace App\Console\Commands;

use App\Lib\Company;
use App\Lib\CronHelper;
use App\Lib\Helper;
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


	protected $dotenv ;

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
			['BackupConfigFile', InputArgument::REQUIRED, 'automysqlbackup Config File Path'],
		];
	}

	/**
	 * Execute the console command.
	 *
	 * @return mixed
	 */
	public function fire()
	{

		CronHelper::before_cronrun($this);

		Log::useFiles(storage_path() . '/logs/dbbackup-' . '-' . date('Y-m-d') . '.log');

		try{

			$arguments = $this->argument();
			$getmypid = getmypid(); // get proccess id

			$BackupConfigFile = $arguments["BackupConfigFile"];

			/**
			 * add extra NEON_ config variables in automysqlbackup config file
			 *
			 * NEON_backup_command=/usr/local/bin/solo -port=6000 /usr/local/bin/automysqlbackup
			   NEON_backup_aws_command=/usr/local/bin/solo -port=6001 /usr/local/bin/aws s3 sync --delete /home/autobackup/db/daily/RateManagement4 s3://neon.backup/other/
			   NEON_email=
			   NEON_email_name=
			   NEON_CompanyID=
			 */
			$dotenv = new \Dotenv();
			$dotenv->load(dirname($BackupConfigFile),basename($BackupConfigFile));

			$CompanyID = getenv("NEON_CompanyID");

			Log::info ( "Start " );

			Log::info ( "Starting backup..." );

			$backup_cmd = getenv("NEON_backup_command") . ' '  . $BackupConfigFile; // fron config file.
			$bk_output = shell_exec( $backup_cmd );//solo -port=6000 /usr/local/bin/automysqlbackup /etc/automysqlbackup/uk-neonlicence.conf

			Log::info ( "Backup is Completed "   );
			Log::info( " Output " . print_r($bk_output,true) );

			Log::info ( "Setting up Permissions" ); ;

			# Set permission to root user only.
			exec('chown root.root ' . getenv("CONFIG_backup_dir") . '* -R');
			exec('find ' . getenv("CONFIG_backup_dir"). '* -type f -exec chmod 400 {} \;');
			exec('find ' . getenv("CONFIG_backup_dir"). '* -type d -exec chmod 700 {} \;');

			Log::info ( "Uploading Backup to AmazonS3 "  );;

			$aws_command = getenv("NEON_backup_aws_command") ;

			$aws_output = shell_exec($aws_command ) ;//solo -port=6001 s3cmd sync /home/autobackup/db/daily/neonlicencing s3://neon.backup/

			Log::info ( "Uploading Backup to AmazonS3 Completed "  );;
			Log::info ( "Output " . print_r($aws_output,true) );

			Log::info ( "Done! "  );

			$message = "<b>DB Backup Completed with following output.</b>";
			$message .= "<br><br><br> <b>Backup Output</b>  " .   $bk_output;
 			$message .= "<br><br><br> <b>AWS Output</b>  " .  $aws_output;

			$this->send_update_email($BackupConfigFile,$CompanyID,$message);


		}catch (\Exception $ex) {

			Log::info( "Exception " . $ex->getMessage() );
			Log::info( "Full Exception" . print_r($ex,true) );

			$message = "DB Backup Failed";
			$message .= "<br> <b>" . $ex->getMessage() ."</b>";
			$message .= "<br> " . implode("<br>", $ex);

			$this->send_update_email($BackupConfigFile,$CompanyID,$message);

		}

		CronHelper::after_cronrun($this);

	}

	public function send_update_email($BackupConfigFile,$CompanyID,$message){

		try{

			$dotenv = new \Dotenv();
			$dotenv->load(dirname($BackupConfigFile),basename($BackupConfigFile));

			/// Email to
			$emaildata['EmailTo'] = getenv("NEON_email");
			$emaildata['EmailToName'] = getenv("NEON_email_name");
			$emaildata['Subject'] ="Backup Update ";
			$emaildata['CompanyID'] = $CompanyID;
			$emaildata['data'] =array('message' => nl2br($message), 'CompanyName'=>getenv("NEON_email_name"));

			$status = Helper::sendMail('emails.backup.dbbackup_email',$emaildata);

		}catch (\Exception $ex) {

			Log::info( "Error Sending Email Exception " . $ex->getMessage() );
			Log::info( "Full Exception" . implode("<br>", $ex) );

		}
	}
}
