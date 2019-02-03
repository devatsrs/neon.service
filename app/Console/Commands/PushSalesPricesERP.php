<?php namespace App\Console\Commands;




use App\Lib\CronHelper;
use App\Lib\NeonAPI;
use App\Lib\DynamicFields;
use App\Lib\Package;
use App\Lib\ServiceTemplate;
use App\Lib\ServiceTemapleSubscription;
use App\Lib\ServiceTemapleInboundTariff;
use App\Lib\DynamicFieldsValue;
use App\Lib\RateTableDIDRate;
use App\Lib\RoutingProfileRate;
use Illuminate\Console\Command;
use App\Lib\CronJob;
use App\Lib\Translation;
use App\Lib\RateTablePKGRate;

use App\Lib\Account;
use App\Lib\Company;
use App\Lib\Notification;
use App\Lib\Helper;
use App\Lib\CompanyConfiguration;
use App\Lib\CronJobLog;
use App\Lib\Retention;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use \Exception;
use Symfony\Component\Console\Input\InputArgument;
use Illuminate\Support\Facades\Crypt;
use App\Lib\CompanyGateway;

class PushSalesPricesERP extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'pushsalespriceserp';

	/**
	 * The console command description.
	 *
	 * @var string
	 */
	protected $description = 'Push Sales Prices to ERP System.';

	protected function getArguments()
	{
		return [
			['CompanyID', InputArgument::REQUIRED, 'Argument CompanyID '],
			['CronJobID', InputArgument::REQUIRED, 'Argument CronJobID'],
		];
	}

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
    public function handle() {
        //$results = array();
		$data = array();
		$Getdata = array(

		);
		//Staging php artisan pushsalespriceserp 1 268
		//php artisan pushsalespriceserp 1 336
        CronHelper::before_cronrun($this->name, $this );
		$SuccessDepositAccount = array();
		$FailureDepositFund = array();
		$ErrorDepositFund = array();
        $arguments = $this->argument();
        $CompanyID = $arguments["CompanyID"];
        $CronJobID = $arguments["CronJobID"];
        
        $CronJob =  CronJob::find($CronJobID);
        $cronsetting = json_decode($CronJob->Settings,true);
        CronJob::activateCronJob($CronJob);
        CronJob::createLog($CronJobID);
		$DynamicFieldsValues = '';
		$ProductServiceTemplate = '';
		$ServiceTemplateInboundTariffs = '';
		$results = array();
		$data = array();
		$pricePlanId = '1';
		$partnerId = '1';
		$productId = '1';
		$priceItemId = 1;
		$pricePlanTypeId = '3';
		$validFrom = date('Y-m-d');
		$PricingJSONInput = [];
		//$apiPricing = array;
		//$APIResponse ;
        //print_r($cronsetting);die();
        Log::useFiles(storage_path() . '/logs/PushSalesPricesERP-companyid-'.$CompanyID . '-cronjobid-'.$CronJobID.'-' . date('Y-m-d') . '.log');
		try{

/*
			$results = array();
			$data = array();
			$Getdata = array(

			);
			$APIResponse = NeonAPI::callGetAPI($Getdata,"api/Products","http://api-neon.speakintelligence.com/");
			if (isset($APIResponse["error"])) {
				Log::info('PushSalesPricesERP Error in  api/Products service.' . print_r($APIResponse["error"]));
			} else {
				$ProductResponses = json_decode($APIResponse["response"]);
				Log::info('PushSalesPricesERP .' . count($ProductResponses));*/
				$fieldName = 'ProductProductID';
				$AccountFieldName = 'CustomerID';
				$PackageFieldName = 'PackageID';
				$DynamicFieldsID = '';
				$AccountDynamicFieldsID = '';
				$PackageDynamicFieldsID = '';

				$Query = "select ParentID from tblDynamicFieldsValue where ";
				$DynamicFieldsID = DynamicFields::where(['CompanyID'=>$CompanyID,'Type'=>'serviceTemplate','Status'=>1,'FieldSlug'=>$fieldName])->pluck('DynamicFieldsID');
				if(empty($DynamicFieldsID)){
					Log::info('PushSalesPricesERP:DynamicFieldsID .' .$fieldName . ' Not Found');
					return;
				}
				$AccountDynamicFieldsID = DynamicFields::where(['CompanyID'=>$CompanyID,'Type'=>'account','Status'=>1,'FieldSlug'=>$AccountFieldName])->pluck('DynamicFieldsID');
				if(empty($AccountDynamicFieldsID)){
					Log::info('PushSalesPricesERP:DynamicFieldsID .' .$AccountFieldName . ' Not Found');
					return;
				}

			$PackageDynamicFieldsID = DynamicFields::where(['CompanyID'=>$CompanyID,'Type'=>'package','Status'=>1,'FieldSlug'=>$PackageFieldName])->pluck('DynamicFieldsID');
			if(empty($PackageDynamicFieldsID)){
				Log::info('PushSalesPricesERP:DynamicFieldsID .' .$PackageFieldName . ' Not Found');
				return;
			}

			$ProductPackages = Package::
			Join('tblDynamicFieldsValue', 'tblDynamicFieldsValue.ParentID', '=', 'tblPackage.PackageId')
				->select(['tblPackage.Name', 'tblPackage.RateTableId',
					'tblPackage.CurrencyId']);
			$ProductPackages = $ProductPackages->where(["tblDynamicFieldsValue.DynamicFieldsID" => $PackageDynamicFieldsID]);
			$ProductPackages = $ProductPackages->get();


				$PartnerIDQuery = "select reseller.AccountID,(select dfieldsValues.FieldValue from tblDynamicFieldsValue dfieldsValues
 								  where dfieldsValues.DynamicFieldsID= " . $AccountDynamicFieldsID . "
 								   and dfieldsValues.ParentID = reseller.AccountID) PartnerID
  								  from tblReseller reseller";


				Log::info('$PartnerIDQuery query.' . $PartnerIDQuery);
				$PartnerResults = DB::select($PartnerIDQuery);
				$ProductSelectionQuery = "select tblServiceTemapleInboundTariff.RateTableId,tblServiceTemplate.Name,tblServiceTemplate.country,
								  tblServiceTemplate.prefixName from tblServiceTemapleInboundTariff
								   join tblServiceTemplate on tblServiceTemapleInboundTariff.ServiceTemplateID = tblServiceTemplate.ServiceTemplateId
								     where tblServiceTemplate.ServiceTemplateId in ( select dfieldsValues.ParentID from tblDynamicFieldsValue dfieldsValues  where dfieldsValues.DynamicFieldsID= " . $DynamicFieldsID .")
								       and tblServiceTemplate.country is not null and tblServiceTemplate.prefixName is not null";


				Log::info('$ProductSelectionQuery query.' . $ProductSelectionQuery);
				$ProductResponses = DB::select($ProductSelectionQuery);

				foreach($PartnerResults as $PartnerResult) {
					Log::info('$ProductSelectionQuery Account.' . $PartnerResult->AccountID);
					$data_langs = Translation::get_language_labels();

					$json_file = json_decode($data_langs->Translation, true);
					$partnerId = empty($PartnerResult->PartnerID) ? '0': $PartnerResult->PartnerID;

						foreach ($ProductPackages as $ProductPackage) {
							if (!empty($ProductPackage["RateTableId"]) && $ProductPackage["RateTableId"] != 0) {
							$RateTablePKGRatesQuery = "select pkgRate.OneOffCost, pkgRate.MonthlyCost, pkgRate.PackageCostPerMinute, pkgRate.RecordingCostPerMinute,
 												  rate.RateID,timeZ.Title, (select Symbol from tblCurrency where CurrencyId = OneOffCostCurrency  ) as OneOffCostCurrencySymbol, (select Symbol from tblCurrency where CurrencyId = MonthlyCostCurrency  ) as MonthlyCostCurrencySymbol,  (select Symbol from tblCurrency where CurrencyId = PackageCostPerMinuteCurrency  ) as PackageCostPerMinuteCurrencySymbol, (select Symbol from tblCurrency where CurrencyId = RecordingCostPerMinuteCurrency  ) as RecordingCostPerMinuteCurrencySymbol, (select Prefix from tblCountry where CountryID = rate.CountryID) as countryPrefix
 												     from tblRateTablePKGRate pkgRate, tblRate rate,tblTimezones timeZ
 												        where pkgRate.RateID = rate.RateID and timeZ.TimezonesID = pkgRate.TimezonesID
 												         	 and (rate.Code = '" . $ProductPackage["Name"] . "') and (pkgRate.RateTableId = " . $ProductPackage["RateTableId"] . ")
 												         	  and (pkgRate.ApprovedStatus = 1) and pkgRate.EffectiveDate <= NOW()";

							Log::info('Package $RateTablePKGRates.' . $RateTablePKGRatesQuery);
							$RateTablePKGRates = DB::select($RateTablePKGRatesQuery);


							foreach ($RateTablePKGRates as $RateTablePKGRate) {
								Log::info('tblRateTablePKGRate RateID.' . $RateTablePKGRate->RateID);

								if (!empty($RateTablePKGRate->OneOffCost)) {
									$data["priceItemId"] = $RateTablePKGRate->RateID;
									$data["pricePlanId"] = $pricePlanId;
									$data["costGroupName"] = "INSTALLATION COSTS – ONE-OFF";

									$data["name"] = ',' . $RateTablePKGRate->Title . ',' . $RateTablePKGRate->countryPrefix . '' . ',' . $json_file['CUST_PANEL_PAGE_INVOICE_PDF_LBL_ONE_OFF_COST'] . '=' . $RateTablePKGRate->OneOffCost;
									$data["iso2"] = "English";
									$data["salesPricePercentage"] = "25";
									$data["currencySymbol"] = empty($RateTablePKGRate->OneOffCostCurrencySymbol) ? "$" : $RateTablePKGRate->OneOffCostCurrencySymbol;
									$results[] = $data;
								}
								if (!empty($RateTablePKGRate->MonthlyCost)) {
									$data["priceItemId"] = $RateTablePKGRate->RateID;;
									$data["costGroupName"] = "SUBSCRIPTION COSTS- MONTHLY COST";
									$data["pricePlanId"] = $pricePlanId;
									$data["name"] = ',' . $RateTablePKGRate->Title . ',' . $RateTablePKGRate->countryPrefix . '' . ',' . $json_file['CUST_PANEL_PAGE_INVOICE_PDF_LBL_MONTHLY_COST'] . '=' . $RateTablePKGRate->MonthlyCost;
									$data["iso2"] = "English";
									$data["salesPricePercentage"] = "25";
									$data["currencySymbol"] = empty($RateTablePKGRate->MonthlyCostCurrencySymbol) ? "$" : $RateTablePKGRate->MonthlyCostCurrencySymbol;
									$results[] = $data;
								}

								if (!empty($RateTablePKGRate->PackageCostPerMinute)) {
									$data["priceItemId"] = $RateTablePKGRate->RateID;;
									$data["costGroupName"] = "VARIABLE COSTS AND OUTPAYMENTS";
									$data["pricePlanId"] = $pricePlanId;
									$data["name"] = ',' . $RateTablePKGRate->Title . ',' . $RateTablePKGRate->countryPrefix . '' . ',' . $json_file['CUST_PANEL_PAGE_INVOICE_PDF_LBL_PACKAGE_COST_PER_MINUTE'] . '=' . $RateTablePKGRate->PackageCostPerMinute;
									$data["iso2"] = "English";
									$data["salesPricePercentage"] = "25";
									$data["currencySymbol"] = empty($RateTablePKGRate->PackageCostPerMinuteCurrencySymbol) ? "$" : $RateTablePKGRate->PackageCostPerMinuteCurrencySymbol;
									$results[] = $data;
								}
								if (!empty($RateTablePKGRate->RecordingCostPerMinute)) {
									$data["priceItemId"] = $RateTablePKGRate->RateID;;
									$data["costGroupName"] = "VARIABLE COSTS AND OUTPAYMENTS";
									$data["pricePlanId"] = $pricePlanId;
									$data["name"] = ',' . $RateTablePKGRate->Title . ',' . $RateTablePKGRate->countryPrefix . '' . ',' . $json_file['CUST_PANEL_PAGE_INVOICE_PDF_LBL_RECORDING_COST_PER_MINUTE'] . '=' . $RateTablePKGRate->RecordingCostPerMinute;
									$data["iso2"] = "English";
									$data["salesPricePercentage"] = "25";
									$data["currencySymbol"] = empty($RateTablePKGRate->RecordingCostPerMinuteCurrencySymbol) ? "$" : $RateTablePKGRate->RecordingCostPerMinuteCurrencySymbol;
									$results[] = $data;
								}

							}
						}
					}
					Log::info('priceItemList package size.' . count($results));
					foreach ($ProductResponses as $ProductResponse) {
						//Log::info('PushSalesPricesERP .' . $ProductResponse->productId . ' ' . $ProductResponse->name);
						//$DynamicProductTemplates = DynamicFieldsValue::getDynamicValuesByProductID($CompanyID, $DynamicFieldsID, $ProductResponse->productId);
					//	foreach ($DynamicProductTemplates as $DynamicProductTemplate) {
					//		$ServiceTemapleInboundTariff = ServiceTemapleInboundTariff::select(['ServiceTemapleInboundTariffId',
					//			'ServiceTemplateID', 'DIDCategoryId', 'RateTableId'])->where(['ServiceTemplateID' => $DynamicProductTemplate->ParentID]);
					//		$ServiceTemapleInboundTariffs = $ServiceTemapleInboundTariff->get();
					//		Log::info('$ServiceTemapleInboundTariff query 123.' . $ProductResponse->productId . ' ' . $DynamicProductTemplate->ParentID . ' ' . count($ServiceTemapleInboundTariffs));
						//	if (count($ServiceTemapleInboundTariffs) > 0) {
						//		foreach ($ServiceTemapleInboundTariffs as $ServiceTemapleInboundTariff) {
						//			$ServiceTemplateInboundTariffs = $ServiceTemplateInboundTariffs . $ServiceTemapleInboundTariff->RateTableId . ',';
						//		}
						//		$ServiceTemplateInboundTariffs = substr($ServiceTemplateInboundTariffs, 0, strlen($ServiceTemplateInboundTariffs) - 1);


								$Query = "select didRate.*,timeZ.Title,(select Prefix from tblCountry where Country = '" .$ProductResponse->country ."') as countryPrefix,(select Code from tblRate rate where didRate.OriginationRateID = rate.RateID) as orginationCode,
								(select Symbol from tblCurrency where CurrencyId = OneOffCostCurrency  ) as OneOffCostCurrencySymbol,
								 (select Symbol from tblCurrency where CurrencyId = MonthlyCostCurrency  ) as MonthlyCostCurrencySymbol,
								   (select Symbol from tblCurrency where CurrencyId = CostPerMinuteCurrency  ) as CostPerMinuteCurrencySymbol,
								    (select Symbol from tblCurrency where CurrencyId = OutpaymentPerCallCurrency  ) as OutpaymentPerCallCurrencySymbol,
								    (select Symbol from tblCurrency where CurrencyId = RegistrationCostPerNumberCurrency  ) as RegistrationCostPerNumberCurrencySymbol,
								    (select Symbol from tblCurrency where CurrencyId = CollectionCostAmountCurrency  ) as CollectionCostAmountCurrencySymbol
 					from tblRateTableDIDRate didRate,tblTimezones timeZ where
										didRate.RateID in (select RateID from tblRate where description = '" . $ProductResponse->country . "' and
										 Code = concat((select Prefix from tblCountry where Country = '" . $ProductResponse->country . "'), '" . $ProductResponse->prefixName . "'))
										   and RateTableId in (" . $ProductResponse->RateTableId . ")  and
										    timeZ.TimezonesID = didRate.TimezonesID";


								Log::info('$ServiceTemapleInboundTariff query.' . $Query);
								$RateTableDIDRates = DB::select($Query);
								//$RateTableDIDRates = $RateTableDIDRates->get();
								//Log::info('$ServiceTemapleInboundTariff query.' . $ServiceTemapleInboundTariff->toSql());



								//$system_name='CUST_PANEL_PAGE_INVOICE_PDF_LBL_COST_PER_CALL';
								//Log::info('Translation name.' . $json_file['CUST_PANEL_PAGE_INVOICE_PDF_LBL_COST_PER_CALL']);

								foreach ($RateTableDIDRates as $RateTableDIDRate) {
									Log::info('$RateTableDIDRate RateID.' . $RateTableDIDRate->RateID);
									$prefixName = $ProductResponse->prefixName;
									if (!empty($RateTableDIDRate->OneOffCost)) {
										$data["priceItemId"] = "1";
										$data["pricePlanId"] = $pricePlanId;
										$data["costGroupName"] = "INSTALLATION COSTS – ONE-OFF";

										$data["name"] = $RateTableDIDRate->orginationCode . ',' . $RateTableDIDRate->Title . ',' . $RateTableDIDRate->countryPrefix . $prefixName . ',' . $json_file['CUST_PANEL_PAGE_INVOICE_PDF_LBL_ONE_OFF_COST'] . '=' . $RateTableDIDRate->OneOffCost;
										$data["iso2"] = "English";
										$data["salesPricePercentage"] = "25";
										$data["currencySymbol"] = empty($RateTableDIDRate->OneOffCostCurrencySymbol) ? "$" : $RateTableDIDRate->OneOffCostCurrencySymbol;
										$results[] = $data;
									}
									if (!empty($RateTableDIDRate->CostPerMinute)) {
										$data["priceItemId"] = "2";
										$data["costGroupName"] = "VARIABLE COSTS AND OUTPAYMENTS";
										$data["pricePlanId"] = $pricePlanId;
										$data["name"] = $RateTableDIDRate->orginationCode . ',' . $RateTableDIDRate->Title . ',' . $RateTableDIDRate->countryPrefix . $prefixName . ',' . $json_file['CUST_PANEL_PAGE_INVOICE_PDF_LBL_COST_PER_MINUTE'] . '=' . $RateTableDIDRate->CostPerMinute;
										$data["iso2"] = "English";
										$data["salesPricePercentage"] = "25";
										$data["currencySymbol"] = empty($RateTableDIDRate->CostPerMinuteCurrencySymbol) ? "$" : $RateTableDIDRate->CostPerMinuteCurrencySymbol;
										$results[] = $data;
									}

									if (!empty($RateTableDIDRate->OutpaymentPerCall)) {
										$data["priceItemId"] = "3";
										$data["costGroupName"] = "VARIABLE COSTS AND OUTPAYMENTS";
										$data["pricePlanId"] = $pricePlanId;
										$data["name"] = $RateTableDIDRate->orginationCode . ',' . $RateTableDIDRate->Title . ',' . $RateTableDIDRate->countryPrefix . $prefixName . ',' . $json_file['CUST_PANEL_PAGE_INVOICE_PDF_LBL_OUTPAYMENT_PER_CALL'] . '=' . $RateTableDIDRate->OutpaymentPerCall;
										$data["iso2"] = "English";
										$data["salesPricePercentage"] = "25";
										$data["currencySymbol"] = empty($RateTableDIDRate->OutpaymentPerCallCurrency) ? "$" : $RateTableDIDRate->OutpaymentPerCallCurrency;
										$results[] = $data;
									}
									if (!empty($RateTableDIDRate->OutpaymentPerMinute)) {
										$data["priceItemId"] = "4";
										$data["costGroupName"] = "VARIABLE COSTS AND OUTPAYMENTS";
										$data["pricePlanId"] = $pricePlanId;
										$data["name"] = $RateTableDIDRate->orginationCode . ',' . $RateTableDIDRate->Title . ',' . $RateTableDIDRate->countryPrefix . $prefixName . ',' . $json_file['CUST_PANEL_PAGE_INVOICE_PDF_LBL_OUTPAYMENT_PER_MINUTE'] . '=' . $RateTableDIDRate->OutpaymentPerMinute;
										$data["iso2"] = "English";
										$data["salesPricePercentage"] = "25";
										$data["currencySymbol"] = empty($RateTableDIDRate->OutpaymentPerMinuteCurrencySymbol) ? "$" : $RateTableDIDRate->OutpaymentPerMinuteCurrencySymbol;
										$results[] = $data;
									}

									if (!empty($RateTableDIDRate->MonthlyCost)) {
										$data["priceItemId"] = "5";
										$data["costGroupName"] = "SUBSCRIPTION COSTS- MONTHLY COST";
										$data["pricePlanId"] = $pricePlanId;
										$data["name"] = $RateTableDIDRate->orginationCode . ',' . $RateTableDIDRate->Title . ',' . $RateTableDIDRate->countryPrefix . $prefixName . ',' . $json_file['CUST_PANEL_PAGE_INVOICE_PDF_LBL_MONTHLY_COST'] . '=' . $RateTableDIDRate->MonthlyCost;
										$data["iso2"] = "English";
										$data["salesPricePercentage"] = "25";
										$data["currencySymbol"] = empty($RateTableDIDRate->MonthlyCostCurrencySymbol) ? "$" : $RateTableDIDRate->MonthlyCostCurrencySymbol;
										$results[] = $data;
									}

									if (!empty($RateTableDIDRate->RegistrationCostPerNumber)) {
										$data["priceItemId"] = "7";
										$data["costGroupName"] = "INSTALLATION COSTS – ONE-OFF";
										$data["pricePlanId"] = $pricePlanId;
										$data["name"] = $RateTableDIDRate->orginationCode . ',' . $RateTableDIDRate->Title . ',' . $RateTableDIDRate->countryPrefix . $prefixName . ',' . $json_file['CUST_PANEL_PAGE_INVOICE_PDF_LBL_REGISTERATION_COST_PER_NUMBER'] . '=' . $RateTableDIDRate->RegistrationCostPerNumber;
										$data["iso2"] = "English";
										$data["salesPricePercentage"] = "25";
										$data["currencySymbol"] = empty($RateTableDIDRate->RegistrationCostPerNumberCurrencySymbol) ? "$" : $RateTableDIDRate->RegistrationCostPerNumberCurrencySymbol;
										$results[] = $data;
									}
									if (!empty($RateTableDIDRate->CollectionCostAmount)) {
										$data["priceItemId"] = "8";
										$data["costGroupName"] = "VARIABLE COSTS AND OUTPAYMENTS";
										$data["pricePlanId"] = $pricePlanId;
										$data["name"] = $RateTableDIDRate->orginationCode . ',' . $RateTableDIDRate->Title . ',' . $RateTableDIDRate->countryPrefix . $prefixName . ',' . $json_file['CUST_PANEL_PAGE_INVOICE_PDF_LBL_COLLECTION_COST_AMOUNT'] . '=' . $RateTableDIDRate->CollectionCostAmount;
										$data["iso2"] = "English";
										$data["salesPricePercentage"] = "25";
										$data["currencySymbol"] = empty($RateTableDIDRate->CollectionCostAmountCurrencySymbol) ? "$" : $RateTableDIDRate->CollectionCostAmountCurrencySymbol;
										$results[] = $data;
									}

								}

								Log::info('priceItemList size.' . count($results));
								//$apiPricing["priceItemList"] = $results;
								$Postdata = array(
//								'pricePlanId' => $pricePlanId,
//								'partnerId' => $partnerId,
//								'productId' => $productId,
//								'pricePlanTypeId'=>$pricePlanTypeId,
//								'validFrom'=>$validFrom,
//								'priceItemList'                => $results
								);
								$PricingJSONInput['pricePlanId'] = ++$pricePlanId;
								$PricingJSONInput['partnerId'] = $partnerId;
								$PricingJSONInput['productId'] = $productId;
								$PricingJSONInput['pricePlanTypeId'] = $pricePlanTypeId;
								$PricingJSONInput['validFrom'] = $validFrom;
								$PricingJSONInput['priceItemList'] = $results;
								//Log::info('priceItemList json encode.' . print_r($Postdata, true));
								$PricingJSONInput = json_encode($PricingJSONInput, true);
								Log::info('priceItemList json encode.' . $PricingJSONInput);
								$results = array();
								$data = array();

								$APIResponse = NeonAPI::callPostAPI($Postdata, $PricingJSONInput, "api/Pricing", "http://api-neon.speakintelligence.com/");
								$PricingJSONInput = [];

						//	}
						//}
						//$Query = $Query .'(DynamicFieldsID = ' . $DynamicFieldsID . " and FieldValue='" . $ProductResponse->productId . "')";
						//$Query = $Query . " OR ";
					}
				}
			//}

			//Code for PushSalesPriceService



			CronJob::deactivateCronJob($CronJob);
			CronHelper::after_cronrun($this->name, $this);
            echo "DONE With PushSalesPricesERP";


			//Log::info('routingList:Get the routing list user company.' . $CompanyID);
            Log::info('Run Cron.');
        }catch (\Exception $e){
            Log::useFiles(storage_path() . '/logs/PushSalesPricesERP-Error-' . date('Y-m-d') . '.log');
            //Log::info('LCRRoutingEngine Error.');
            Log::useFiles(storage_path() . '/logs/PushSalesPricesERP-Error-' . date('Y-m-d') . '.log');
            
            Log::error($e);
            $this->info('Failed:' . $e->getMessage());
            $joblogdata['Message'] ='Error:'.$e->getMessage();
            $joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
            CronJobLog::insert($joblogdata);
            if(!empty($cronsetting['ErrorEmail'])) {

                    $result = CronJob::CronJobErrorEmailSend($CronJobID,$e);
                    Log::error("**Email Sent Status " . $result['status']);
                    Log::error("**Email Sent message " . $result['message']);
            }


    }
    }





}
