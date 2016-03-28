<?php namespace App\Console\Commands;

use App\Lib\DataTableSql;
use App\Lib\User;
use Illuminate\Console\Command;
use App\Lib\CronJob;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Queue;
use Symfony\Component\Console\Input\InputArgument;

class RMService extends Command {

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'rmservice';

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

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle()
    {
        try {

            $arguments = $this->argument();
            $CompanyID = $arguments["CompanyID"];
            $query = "CALL prc_CronJobAllPending ( $CompanyID )";
            $allpending = DataTableSql::of($query)->getProcResult(array(
                'PendingUploadCDR',
                'PendingInvoiceGenerate',
                'PendingPortaSheet',
                'getActiveCronCommand',
                'getVosDownloadCommand',
                'PendingBulkMailSend',
                'PortVendorSheet',
                'CDRRecalculate',
                'PendingInvoiceUsageFileGeneration',
                'PendingCustomerRateSheet',
                'InvoiceRegenerate',
                'BulkLeadEmail',
                'BulkAccountEmail',
                'PendingVendorUpload',
                'PendingCodeDeckUpload',
                'InvoiceReminder',
                'CustomerSippySheetDownload',
                'VendorSippySheetDownload',
                'CustomerVOSSheetDownload',
                'VendorVOSSheetDownload',
                'RateTableGeneration',
                'RateTableFileUpload',
                'VendorCDRUpload',
                'getSippyDownloadCommand'
            ));

            $cmdarray = $allpending['data']['getVosDownloadCommand'];
            foreach ($cmdarray as $com) {
                if (isset($com->CronJobID) && $com->CronJobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen(env('PHPExePath')." ".env('RMArtisanFileLocation')." ".$com->Command." ". $CompanyID." ".$com->CronJobID . " &","r"));
                    }else{
                        pclose(popen("start /B ". env('PHPExePath')." ".env('RMArtisanFileLocation')." ".$com->Command." ". $CompanyID." ".$com->CronJobID, "r"));
                    }

                }
            }
            foreach($allpending['data']['PendingUploadCDR'] as $pedingcdrrow){
                if (isset($pedingcdrrow->JobID) && $pedingcdrrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen(env('PHPExePath')." ".env('RMArtisanFileLocation')." cdrupload " . $CompanyID . " " . $pedingcdrrow->JobID . " &","r"));
                    }else {
                        pclose(popen("start /B " . env('PHPExePath') . " " . env('RMArtisanFileLocation') . " cdrupload " . $CompanyID . " " . $pedingcdrrow->JobID . " ", "r"));
                    }
                }
            }
            foreach($allpending['data']['PendingInvoiceGenerate'] as $pedinginvoicerow){
                if (isset($pedinginvoicerow->JobID) && $pedinginvoicerow->JobID>0) {
                    $Options = json_decode($pedinginvoicerow->Options);
                    $CronJobID = $Options->CronJobID;
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen(env('PHPExePath')." ".env('RMArtisanFileLocation')." invoicegenerator " . $CompanyID . " $CronJobID " . $pedinginvoicerow->JobLoggedUserID . " $pedinginvoicerow->JobID &","r"));
                    }else {
                        pclose(popen("start /B " . env('PHPExePath') . " " . env('RMArtisanFileLocation') . " invoicegenerator " . $CompanyID . " $CronJobID " . $pedinginvoicerow->JobLoggedUserID . " $pedinginvoicerow->JobID ", "r"));
                    }
                }
            }
            foreach($allpending['data']['PendingPortaSheet'] as $pedingportarow){
                if (isset($pedingportarow->JobID) && $pedingportarow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen(env('PHPExePath')." ".env('RMArtisanFileLocation')." customerportasheet " . $CompanyID . " " . $pedingportarow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . env('PHPExePath') . " " . env('RMArtisanFileLocation') . " customerportasheet " . $CompanyID . " " . $pedingportarow->JobID . " ", "r"));
                    }
                }
            }
            foreach($allpending['data']['PendingBulkMailSend'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen(env('PHPExePath')." ".env('RMArtisanFileLocation')." bulkinvoicesend " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . env('PHPExePath') . " " . env('RMArtisanFileLocation') . " bulkinvoicesend " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }
            foreach($allpending['data']['PortVendorSheet'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen(env('PHPExePath')." ".env('RMArtisanFileLocation')." portavendorsheet " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . env('PHPExePath') . " " . env('RMArtisanFileLocation') . " portavendorsheet " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }
            foreach($allpending['data']['CDRRecalculate'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen(env('PHPExePath')." ".env('RMArtisanFileLocation')." cdrrecal " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . env('PHPExePath') . " " . env('RMArtisanFileLocation') . " cdrrecal " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }
            foreach($allpending['data']['InvoiceRegenerate'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen(env('PHPExePath')." ".env('RMArtisanFileLocation')." regenerateinvoice " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . env('PHPExePath') . " " . env('RMArtisanFileLocation') . " regenerateinvoice " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }
            foreach($allpending['data']['PendingVendorUpload'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen(env('PHPExePath')." ".env('RMArtisanFileLocation')." vendorfileupload " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . env('PHPExePath') . " " . env('RMArtisanFileLocation') . " vendorfileupload " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }
            foreach($allpending['data']['PendingCodeDeckUpload'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen(env('PHPExePath')." ".env('RMArtisanFileLocation')." codedecksupload " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . env('PHPExePath') . " " . env('RMArtisanFileLocation') . " codedecksupload " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }

            foreach($allpending['data']['InvoiceReminder'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen(env('PHPExePath')." ".env('RMArtisanFileLocation')." invoicereminder " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . env('PHPExePath') . " " . env('RMArtisanFileLocation') . " invoicereminder " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }
            foreach($allpending['data']['PendingInvoiceUsageFileGeneration'] as $pendinginvoiceusagefilerow){
                if (isset($pendinginvoiceusagefilerow->JobID) && $pendinginvoiceusagefilerow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen(env('PHPExePath')." ".env('RMArtisanFileLocation')." invoiceusagefilegenerator " . $CompanyID . " " . $pendinginvoiceusagefilerow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . env('PHPExePath') . " " . env('RMArtisanFileLocation') . " invoiceusagefilegenerator " . $CompanyID . " " . $pendinginvoiceusagefilerow->JobID . " ", "r"));
                    }
                }
            }
            foreach($allpending['data']['BulkLeadEmail'] as $bulkleademail){
                if (isset($bulkleademail->JobID) && $bulkleademail->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen(env('PHPExePath')." ".env('RMArtisanFileLocation')." bulkleademailsend " . $CompanyID . " " . $bulkleademail->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . env('PHPExePath') . " " . env('RMArtisanFileLocation') . " bulkleademailsend " . $CompanyID . " " . $bulkleademail->JobID . " ", "r"));
                    }
                }
            }
            foreach($allpending['data']['BulkAccountEmail'] as $bulkaccountemail){
                if (isset($bulkaccountemail->JobID) && $bulkaccountemail->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen(env('PHPExePath')." ".env('RMArtisanFileLocation')." bulkleademailsend " . $CompanyID . " " . $bulkaccountemail->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . env('PHPExePath') . " " . env('RMArtisanFileLocation') . " bulkleademailsend " . $CompanyID . " " . $bulkaccountemail->JobID . " ", "r"));
                    }
                }
            }

            foreach($allpending['data']['CustomerSippySheetDownload'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen(env('PHPExePath')." ".env('RMArtisanFileLocation')." customersippysheetgeneration " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . env('PHPExePath') . " " . env('RMArtisanFileLocation') . " customersippysheetgeneration " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }

            foreach($allpending['data']['VendorSippySheetDownload'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen(env('PHPExePath')." ".env('RMArtisanFileLocation')." vendorsippysheetgeneration " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . env('PHPExePath') . " " . env('RMArtisanFileLocation') . " vendorsippysheetgeneration " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }

            foreach($allpending['data']['CustomerVOSSheetDownload'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen(env('PHPExePath')." ".env('RMArtisanFileLocation')." customervossheetgeneration " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . env('PHPExePath') . " " . env('RMArtisanFileLocation') . " customervossheetgeneration " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }

            foreach($allpending['data']['VendorVOSSheetDownload'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen(env('PHPExePath')." ".env('RMArtisanFileLocation')." vendorvossheetgeneration " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . env('PHPExePath') . " " . env('RMArtisanFileLocation') . " vendorvossheetgeneration " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }

            foreach($allpending['data']['RateTableGeneration'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen(env('PHPExePath')." ".env('RMArtisanFileLocation')." ratetablegenerator " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . env('PHPExePath') . " " . env('RMArtisanFileLocation') . " ratetablegenerator " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }

            foreach($allpending['data']['RateTableFileUpload'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen(env('PHPExePath')." ".env('RMArtisanFileLocation')." ratetablefileupload " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . env('PHPExePath') . " " . env('RMArtisanFileLocation') . " ratetablefileupload " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }
            foreach($allpending['data']['VendorCDRUpload'] as $allpendingrow){
                if (isset($allpendingrow->JobID) && $allpendingrow->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen(env('PHPExePath')." ".env('RMArtisanFileLocation')." vcdrupload " . $CompanyID . " " . $allpendingrow->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . env('PHPExePath') . " " . env('RMArtisanFileLocation') . " vcdrupload " . $CompanyID . " " . $allpendingrow->JobID . " ", "r"));
                    }
                }
            }

            /* Sippy CDR File download */
            $cmdarray = $allpending['data']['getSippyDownloadCommand'];
            foreach ($cmdarray as $com) {
                if (isset($com->CronJobID) && $com->CronJobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen(env('PHPExePath')." ".env('RMArtisanFileLocation')." ".$com->Command." ". $CompanyID." ".$com->CronJobID . " &","r"));
                    }else{
                        pclose(popen("start /B ". env('PHPExePath')." ".env('RMArtisanFileLocation')." ".$com->Command." ". $CompanyID." ".$com->CronJobID, "r"));
                    }

                }
            }

            //------------------------ Cron job start here------------------------//

            $cmdarray = $allpending['data']['getActiveCronCommand'];//CronJob::getActiveCronCommand($CompanyID. " &","r"));
            foreach ($cmdarray as $com) {
                if (CronJob::checkStatus($com->CronJobID,$com->Command)) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen(env('PHPExePath')." ".env('RMArtisanFileLocation'). " " . $com->Command . " " . $CompanyID . " " . $com->CronJobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . env('PHPExePath') . " " . env('RMArtisanFileLocation') . " " . $com->Command . " " . $CompanyID . " " . $com->CronJobID, "r"));
                    }
                }
            }
            foreach($allpending['data']['PendingCustomerRateSheet'] as $allpendingrs){
                if (isset($allpendingrs->JobID) && $allpendingrs->JobID>0) {
                    if(getenv('APP_OS') == 'Linux') {
                        pclose(popen(env('PHPExePath')." ".env('RMArtisanFileLocation')." customerratesheet " . $CompanyID . " " . $allpendingrs->JobID . " ". " &","r"));
                    }else {
                        pclose(popen("start /B " . env('PHPExePath') . " " . env('RMArtisanFileLocation') . " customerratesheet " . $CompanyID . " " . $allpendingrs->JobID . " ", "r"));
                    }
                }
            }
        }catch(\Exception $e){
            Log::error($e);
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
        ];
    }



}

