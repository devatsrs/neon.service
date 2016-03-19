<?php namespace App\Console\Commands;
use App;
use App\Lib\CronJob;
use App\Lib\CronJobLog;
use App\Lib\User;
use App\Lib\Company;
use App\Lib\DataTableSql;
use App\Lib\Helper;
use Illuminate\Console\Command;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Config;
use \Exception;

class PendingDueSheet extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'pendingduesheet';

	/**
	 * The console command description.
	 *
	 * @var string
	 */
	protected $description = 'Email pending due sheets to account manager.';

	/**
	 * Create a new command instance.
	 *
	 * @return void
	 */
	public function __construct()
	{
		parent::__construct();
	}

	/**
	 * Execute the console command.
	 *
	 * @return mixed
	 */
	public function fire()
	{

        $arguments = $this->argument();
        $getmypid = getmypid(); // get proccess id
        $CronJobID = $arguments["CronJobID"];
        $CompanyID = $arguments["CompanyID"];
        $CronJob =  CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);
        $dataactive['Active'] = 1;
        $dataactive['PID'] = $getmypid;
        $dataactive['LastRunTime'] = date('Y-m-d H:i:00');
        $CronJob->update($dataactive);
        Log::useFiles(storage_path().'/logs/pendingduesheet-'.$CronJobID.'-'.date('Y-m-d').'.log');


        DB::beginTransaction();
        $joblogdata = array();
        $joblogdata['CronJobID'] = $CronJobID;
        $joblogdata['created_at'] = date('Y-m-d H:i:s');
        $joblogdata['created_by'] = 'RMScheduler';
        $forceelse = false;

        try {
            CronJob::createLog($CronJobID);

            //$CompanyDueSheetEmail = Company::select('DueSheetEmail','CompanyName')->where("CompanyID", '=', $CompanyID)->first();
            $query = "CALL prc_GetRecentDueSheetCronJob(" . $CompanyID . ")";

            $result = DataTableSql::of($query)->getProcResult(array('VendorCustomerPending'));
            $dueSheetVendorCustomer = $result['data']['VendorCustomerPending'];
            $temp = array();
            if(count($dueSheetVendorCustomer)>0){
                foreach($dueSheetVendorCustomer as $key=>$row){
                    $temp[] = array('AccountID'=>$row->AccountID,'AccountName'=>$row->AccountName,'Trunk'=>$row->Trunk,'EffectiveDate'=>$row->EffectiveDate,'DAYSDIFF'=>$row->DAYSDIFF,'type'=>$row->type);
                }

                $ComanyName = Company::getName($CompanyID);
                /*$emailAddress =$CompanyDueSheetEmail->DueSheetEmail;
                $emailToName = $CompanyDueSheetEmail->CompanyName;*/

                if(!empty($cronsetting['SuccessEmail'])) {
                    $emailAddress = $cronsetting['SuccessEmail'];
                    $emailToName = $ComanyName;
                    $data['EmailTo'] = explode(',', $emailAddress);
                    $data['EmailToName'] = $emailToName;
                    $data['Subject'] = 'Pending Due Sheets';
                    $data['CompanyID'] = $CompanyID;
                    $data['data'] = $temp;
                    $status = Helper::sendMail('emails.PendingDueSheets', $data);
                }
            }
            //echo $status['message'];
            $joblogdata['Message'] = 'Success';
            $joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
            CronJobLog::insert($joblogdata);
            DB::commit();

        }catch (\Exception $e) {
            DB::rollback();
            $this->info('Failed:' . $e->getMessage());
            $joblogdata['Message'] ='Error:'.$e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            date_default_timezone_set(Config::get('app.timezone'));
            CronJobLog::insert($joblogdata);
            Log::error("PendingDueSheet : ". $e->getMessage());
            if(!empty($cronsetting['ErrorEmail'])) {
                $result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
                Log::error("**Email Sent Status " . $result['status']);
                Log::error("**Email Sent message " . $result['message']);
            }
        }
        $dataactive['Active'] = 0;
        $dataactive['PID'] = '';
        $CronJob->update($dataactive);
        if(!empty($cronsetting['SuccessEmail'])) {
            $result = CronJob::CronJobSuccessEmailSend($CronJobID);
            Log::error("**Email Sent Status ".$result['status']);
            Log::error("**Email Sent message ".$result['message']);
        }
	}

	/**
	 * Get the console command arguments.
	 *
	 * @return array
	 */
	protected function getArguments()
	{
        return [
            ['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID '],
            ['CronJobID', InputArgument::REQUIRED, 'Argument CronJobID'],
        ];
	}

	/**
	 * Get the console command options.
	 *
	 * @return array
	 */
	protected function getOptions()
	{
		return [
			['example', null, InputOption::VALUE_OPTIONAL, 'An example option.', null],
		];
	}

}
