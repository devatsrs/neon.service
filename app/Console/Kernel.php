<?php namespace App\Console;

use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;

class Kernel extends ConsoleKernel {

	/**
	 * The Artisan commands provided by your application.
	 *
	 * @var array
	 */
	protected $commands = [
		'App\Console\Commands\Inspire',
		'App\Console\Commands\DBCleanUp',
		'App\Console\Commands\SippyAccountUsage',
		'App\Console\Commands\SippyDownloadCDR',
        'App\Console\Commands\RMService',
        'App\Console\Commands\CDRUpload',
        'App\Console\Commands\RateGenerator',
        'App\Console\Commands\PortaAccountUsage',
        'App\Console\Commands\PendingDueSheet',
        'App\Console\Commands\CustomerPortaSheet',
        'App\Console\Commands\CustomerMorSheet',
        'App\Console\Commands\VOSAccountUsage',
        'App\Console\Commands\VOSDownloadCDR',
        'App\Console\Commands\BulkInvoiceSend',
        'App\Console\Commands\BulkCreditNoteSend',
        'App\Console\Commands\PortaVendorSheet',
		'App\Console\Commands\VendorMorSheet',
        'App\Console\Commands\DBFixing',
        'App\Console\Commands\CDRRecalculate',
        'App\Console\Commands\InvoiceUsageFileGenerator',
        'App\Console\Commands\CustomerRateSheetGenerator',
        'App\Console\Commands\DemoData',
        'App\Console\Commands\PBXAccountUsage',
        'App\Console\Commands\InvoiceGenerator',
        'App\Console\Commands\RegenerateInvoice',
        'App\Console\Commands\BulkLeadMailSend',
        'App\Console\Commands\TempCommand',
        'App\Console\Commands\BulkAutoPaymentCapture',
        'App\Console\Commands\AutoTransactionsLogEmail',
        'App\Console\Commands\VendorRateUpload',
        'App\Console\Commands\CodeDecksUpload',
        'App\Console\Commands\AccountActivityReminder',
        'App\Console\Commands\InvoiceReminder',
        'App\Console\Commands\AutoInvoiceReminder',
        'App\Console\Commands\ReImportCDRbyAccount',
        'App\Console\Commands\ManualPortaAccountCDRImport',
        'App\Console\Commands\CustomerSippySheetGeneration',
        'App\Console\Commands\VendorSippySheetGeneration',
        'App\Console\Commands\VendorVOSSheetGeneration',
        'App\Console\Commands\CustomerVOSSheetGeneration',
        'App\Console\Commands\RateTableGenerator',
        'App\Console\Commands\ActiveCronJobEmail',
        'App\Console\Commands\CreateDailySummary',
        'App\Console\Commands\InvoiceManualGenerator',
        'App\Console\Commands\ImportSummeryData',
        'App\Console\Commands\RegenerateManualInvoice',
		'App\Console\Commands\NeonService',
        'App\Console\Commands\MigrateMSSQLtoMYSQL',
        'App\Console\Commands\RateTableRateUpload',
        'App\Console\Commands\PaymentsUpload',
		'App\Console\Commands\VCDRUpload',
		'App\Console\Commands\NeonAlerts',
		'App\Console\Commands\SippyMissingCDRFileFix',
		'App\Console\Commands\CreateSummary',
		'App\Console\Commands\CreateVendorSummary',
		'App\Console\Commands\CreateSummaryLive',
		'App\Console\Commands\CreateVendorSummaryLive',
		'App\Console\Commands\ImportAccount',
		'App\Console\Commands\ImportAccountIp',
		'App\Console\Commands\DBBackup',
		'App\Console\Commands\DialStringUpload',
		'App\Console\Commands\ServerCleanUp',
		'App\Console\Commands\GenerateCustomerRateUpdateFile',
		'App\Console\Commands\GenerateVendorRateUpdateFile',
		'App\Console\Commands\QuickBookInvoicePost',		
		'App\Console\Commands\QuickBookPaymentsPost',		
		'App\Console\Commands\PBXAccountBlock',
		'App\Console\Commands\ReadEmailsTickets',
		'App\Console\Commands\MORAccountUsage',
		'App\Console\Commands\ManualImportAccounts',
		'App\Console\Commands\CustomerRateFileDownload',
		'App\Console\Commands\VendorRateFileDownload',
		'App\Console\Commands\VendorRateFileProcess',
		'App\Console\Commands\CustomerRateFileProcess',
		'App\Console\Commands\ItemUpload',
		'App\Console\Commands\CallShopAccountUsage',
		'App\Console\Commands\StreamcoAccountUsage',
		'App\Console\Commands\StreamcoAccountImport',
		'App\Console\Commands\CustomerRateFileGeneration',
		'App\Console\Commands\VendorRateFileGeneration',
		'App\Console\Commands\CustomerRateFileExport',
		'App\Console\Commands\VendorRateFileExport',
		'App\Console\Commands\RateFileExport',
		'App\Console\Commands\FusionPBXAccountUsage',
		'App\Console\Commands\RateExportToVos',
		'App\Console\Commands\M2AccountUsage',
		'App\Console\Commands\MorCustomerRateImport',
		'App\Console\Commands\CallShopCustomerRateImport',
		'App\Console\Commands\XeroInvoicePost',
		'App\Console\Commands\CustomerM2SheetGeneration',
		'App\Console\Commands\VendorM2SheetGeneration',
		'App\Console\Commands\XeroPaymentImport',
		'App\Console\Commands\VoipNowAccountUsage',
		'App\Console\Commands\VOS5000AccountUsage',
		'App\Console\Commands\VOS5000DownloadCDR',
		'App\Console\Commands\ReadEmailsAutoImport',
		'App\Console\Commands\ResellerPBXAccountUsage',
		'App\Console\Commands\FTPDownloadCDR',
		'App\Console\Commands\FTPAccountUsage',
		'App\Console\Commands\ProcessCallCharges',
		'App\Console\Commands\SippySQLAccountUsage',
		'App\Console\Commands\VoipMSAccountUsage',
		'App\Console\Commands\VendorCDRRecalculate',
		'App\Console\Commands\SippyRateFileStatus',
		'App\Console\Commands\SingleInvoiceGeneration',
		'App\Console\Commands\importPBXPayments',
		'App\Console\Commands\exportPbxPayments',
		'App\Console\Commands\BulkDisputeSend',
		'App\Console\Commands\DisputeBulkmail',
		'App\Console\Commands\AccountBalanceGenerator',
		'App\Console\Commands\FTPVendorDownloadCDR',
		'App\Console\Commands\FTPVendorAccountUsage',
		'App\Console\Commands\ImportVOSAccountBalance',
		'App\Console\Commands\ImportVOSAccounts',
		'App\Console\Commands\UpdatePBXCustomerRate',
		'App\Console\Commands\ClarityPBXAccountUsage',
		'App\Console\Commands\UpdatePBXVendorRate',
		'App\Console\Commands\exportClarityPBXPayments',
		'App\Console\Commands\GetVOSCustomerRate',
		'App\Console\Commands\GetVOSVendorRate',
		'App\Console\Commands\ExportClarityPBXCustomerRate',
		'App\Console\Commands\ExportClarityPBXVendorRate',
		'App\Console\Commands\ImportClarityAccounts',
		'App\Console\Commands\HUAWEIAccountUsage',
		'App\Console\Commands\HUAWEIDownloadCDR',
		'App\Console\Commands\PortaOneAccountUsage',

	];

	/**
	 * Define the application's command schedule.
	 *
	 * @param  \Illuminate\Console\Scheduling\Schedule  $schedule
	 * @return void
	 */
	protected function schedule(Schedule $schedule)
	{
		//$schedule->command('inspire')->everyFiveMinutes();
		//$schedule->command('neonservice')->everyMinute();

       // $schedule->exec('cmd')->daily();
        //$schedule->exec('sippyaccountusage')->hourly();

    }

}
