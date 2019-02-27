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
		$PriceAPIURL = $cronsetting['PriceAPIURL'];
		$PriceAPIMethod = $cronsetting['PriceAPIMethod'];
	//	echo $PriceAPIURL;
	//	echo $PriceAPIMethod;
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
		$DiDCategorySaveID = -1;
		$DiDCategorySaveDescription = '';
		$SetRateTableEffectiveDate = '';
		$SetDiDCategory = 0;
		$data_langs = [];
		$validFrom = date('Y-m-d');
		$PricingJSONInput = [];
		//$apiPricing = array;
		//$APIResponse ;
        //print_r($cronsetting);die();
        Log::useFiles(storage_path() . '/logs/PushSalesPricesERP-companyid-'.$CompanyID . '-cronjobid-'.$CronJobID.'-' . date('Y-m-d') . '.log');
		//Log::info('PriceAPIURL .' .$PriceAPIURL  . ' ' . 'PriceAPIMethod' . ' ' .$PriceAPIMethod);
		try {

			//Load Data

			/*$LoadQuery = "select ServiceTemplateId,city_tariff,concat((select Prefix from tblCountry where Country = template.country), case when SUBSTRING(template.prefixName, 1, 1) = '0' THEN SUBSTRING(template.prefixName, 2, LENGTH(template.prefixName)) ELSE template.prefixName END) as Code from tblServiceTemplate template where city_tariff is not null";


			Log::info('$LoadQuery query.' . $LoadQuery);
			$LoadQueryResults = DB::select($LoadQuery);
			foreach($LoadQueryResults as $LoadQueryResult) {
				$LoadQuery = "select ServiceTemplateId,city_tariff,concat((select Prefix from tblCountry where Country = template.country), case when SUBSTRING(template.prefixName, 1, 1) = '0' THEN SUBSTRING(template.prefixName, 2, LENGTH(template.prefixName)) ELSE template.prefixName END) as Code from tblServiceTemplate template where city_tariff is not null";
			}

			return;*/
			//End Load Data


			$fieldName = 'ProductID';
			$AccountFieldName = 'CustomerID';
			$PackageFieldName = 'PackageID';
			$DynamicFieldsID = '';
			$AccountDynamicFieldsID = '';
			$PackageDynamicFieldsID = '';

			$Query = "select ParentID from tblDynamicFieldsValue where ";
			$DynamicFieldsID = DynamicFields::where(['CompanyID' => $CompanyID, 'Type' => 'serviceTemplate', 'Status' => 1, 'FieldName' => $fieldName])->pluck('DynamicFieldsID');
			$AccountDynamicFieldsID = DynamicFields::where(['CompanyID' => $CompanyID, 'Type' => 'account', 'Status' => 1, 'FieldName' => $AccountFieldName])->pluck('DynamicFieldsID');
			$PackageDynamicFieldsID = DynamicFields::where(['CompanyID' => $CompanyID, 'Type' => 'package', 'Status' => 1, 'FieldName' => $PackageFieldName])->pluck('DynamicFieldsID');
			if (!empty($DynamicFieldsID) && !empty($AccountDynamicFieldsID) && !empty($PackageDynamicFieldsID)) {

			$ProductPackages = Package::
			Join('tblDynamicFieldsValue', 'tblDynamicFieldsValue.ParentID', '=', 'tblPackage.PackageId')
				->select(['tblPackage.Name', 'tblPackage.RateTableId',
					'tblPackage.CurrencyId']);
			$ProductPackages = $ProductPackages->where(["tblDynamicFieldsValue.DynamicFieldsID" => $PackageDynamicFieldsID]);
			$ProductPackages = $ProductPackages->where(["tblPackage.CompanyID" => $CompanyID]);
			$ProductPackages = $ProductPackages->where(["tblPackage.status" => 1]);
			//Log::info('Product Packages $ProductPackages.' . $ProductPackages->toSql());
			$ProductPackages = $ProductPackages->get();


			$PartnerIDQuery = "select reseller.AccountID,(select dfieldsValues.FieldValue from tblDynamicFieldsValue dfieldsValues
 								  where dfieldsValues.DynamicFieldsID= " . $AccountDynamicFieldsID . "
 								   and dfieldsValues.ParentID = reseller.AccountID) PartnerID
  								  from tblReseller reseller";


			//Log::info('$PartnerIDQuery query.' . $PartnerIDQuery);
			$PartnerResults = DB::select($PartnerIDQuery);
			$ProductSelectionQuery = "select tblServiceTemapleInboundTariff.DIDCategoryId as DIDCategoryId,tblServiceTemapleInboundTariff.RateTableId,tblServiceTemplate.Name as ProductName,tblServiceTemplate.country,tblServiceTemplate.city_tariff,
									(select  EffectiveDate  from tblRateTableRate tableRate where tableRate.RateTableId = tblServiceTemapleInboundTariff.RateTableId) as TableEffectiveDate,
								  case when SUBSTRING(tblServiceTemplate.prefixName, 1, 1) = '0' THEN SUBSTRING(tblServiceTemplate.prefixName, 2, LENGTH(tblServiceTemplate.prefixName)) ELSE tblServiceTemplate.prefixName END as prefixName,(select CategoryName from tblDIDCategory where DIDCategoryID = tblServiceTemapleInboundTariff.DIDCategoryId) as CategoryDescription from tblServiceTemapleInboundTariff
								   join tblServiceTemplate on tblServiceTemapleInboundTariff.ServiceTemplateID = tblServiceTemplate.ServiceTemplateId
								     where tblServiceTemplate.ServiceTemplateId in ( select dfieldsValues.ParentID from tblDynamicFieldsValue dfieldsValues  where dfieldsValues.DynamicFieldsID= " . $DynamicFieldsID . ")
								       and tblServiceTemplate.country is not null and tblServiceTemplate.prefixName is not null order by tblServiceTemapleInboundTariff.DIDCategoryId";


			//Log::info('$ProductSelectionQuery query.' . $ProductSelectionQuery);
			$ProductResponses = DB::select($ProductSelectionQuery);
			$DiDCategorySaveID = '';
			$SetDiDCategory = 0;

			foreach ($PartnerResults as $PartnerResult) {
				//Log::info('$ProductSelectionQuery Account.' . $PartnerResult->AccountID);
				$SetDiDCategory = 0;
				$DiDCategorySaveID = '';


				$partnerId = empty($PartnerResult->PartnerID) ? '' : $PartnerResult->PartnerID;

				foreach ($ProductPackages as $ProductPackage) {
					if (!empty($ProductPackage["RateTableId"]) && $ProductPackage["RateTableId"] != 0) {
						$RateTablePKGRatesQuery = "select pkgRate.OneOffCost, pkgRate.MonthlyCost, pkgRate.PackageCostPerMinute, pkgRate.RecordingCostPerMinute,
 												  rate.RateID,timeZ.Title,pkgRate.EffectiveDate, (select Symbol from tblCurrency where CurrencyId = OneOffCostCurrency  ) as OneOffCostCurrencySymbol, (select Symbol from tblCurrency where CurrencyId = MonthlyCostCurrency  ) as MonthlyCostCurrencySymbol,  (select Symbol from tblCurrency where CurrencyId = PackageCostPerMinuteCurrency  ) as PackageCostPerMinuteCurrencySymbol, (select Symbol from tblCurrency where CurrencyId = RecordingCostPerMinuteCurrency  ) as RecordingCostPerMinuteCurrencySymbol, (select Prefix from tblCountry where CountryID = rate.CountryID) as countryPrefix
 												     from tblRateTablePKGRate pkgRate, tblRate rate,tblTimezones timeZ
 												        where pkgRate.RateID = rate.RateID and timeZ.TimezonesID = pkgRate.TimezonesID
 												         	 and (rate.Code = '" . $ProductPackage["Name"] . "') and (pkgRate.RateTableId = " . $ProductPackage["RateTableId"] . ")
 												         	  and (pkgRate.ApprovedStatus = 1) and pkgRate.EffectiveDate <= NOW()";

						//Log::info('Package $RateTablePKGRates.' . $RateTablePKGRatesQuery);
						$RateTablePKGRates = DB::select($RateTablePKGRatesQuery);


						//Log::info('Loop $data_langs.' . count($data_langs));
						foreach ($RateTablePKGRates as $RateTablePKGRate) {
							//Log::info('tblRateTablePKGRate RateID.' . $RateTablePKGRate->RateID);
							$data_langs = DB::table('tblLanguage')
								->select("TranslationID", "tblTranslation.Language", "Translation", "tblLanguage.ISOCode")
								->join('tblTranslation', 'tblLanguage.LanguageID', '=', 'tblTranslation.LanguageID')
								->get();
							//	Log::info('Loop $data_langs.' . count($data_langs));

							foreach ($data_langs as $data_lang) {
								$json_file = json_decode($data_lang->Translation, true);
								//if ($data_lang->ISOCode == "es") {
								//	Log::info('Loop $data_langs.' .  $data_lang->ISOCode . ' ' .$json_file['CUST_PANEL_PAGE_INVOICE_PDF_LBL_ONE_OFF_COST']);
								//}
								//Log::info('Loop $data_langs.' . $json_file['CUST_PANEL_PAGE_INVOICE_PDF_LBL_ONE_OFF_COST'] );
								if (!empty($RateTablePKGRate->OneOffCost) && !empty($json_file['CUST_PANEL_PAGE_INVOICE_PDF_LBL_ONE_OFF_COST'])) {
									$data["priceItemId"] = '';// $RateTablePKGRate->RateID;
									$data["pricePlanId"] = '';
									$data["costGroupName"] = "INSTALLATION COSTS";

									$data["name"] = $json_file["CUST_PANEL_PAGE_INVOICE_PDF_LBL_ONE_OFF_COST"] . ($RateTablePKGRate->Title == "Default" ? "" : $RateTablePKGRate->Title) . '=';
									$data["iso2"] = $data_lang->ISOCode;
									$data["salesPrice"] = $RateTablePKGRate->OneOffCost;
									$data["salesPricePercentage"] = "";
									$data["currencySymbol"] = empty($RateTablePKGRate->OneOffCostCurrencySymbol) ? "$" : $RateTablePKGRate->OneOffCostCurrencySymbol;
									$results[] = $data;
								}
								if (!empty($RateTablePKGRate->MonthlyCost) && !empty($json_file["CUST_PANEL_PAGE_INVOICE_PDF_LBL_MONTHLY_COST"])) {
									$data["priceItemId"] = '';// $RateTablePKGRate->RateID;;
									$data["costGroupName"] = "SUBSCRIPTION COSTS";
									$data["pricePlanId"] = '';
									$data["name"] = $json_file["CUST_PANEL_PAGE_INVOICE_PDF_LBL_MONTHLY_COST"] . ($RateTablePKGRate->Title == "Default" ? "" : $RateTablePKGRate->Title);
									$data["iso2"] = $data_lang->ISOCode;
									$data["salesPrice"] = $RateTablePKGRate->MonthlyCost;
									$data["salesPricePercentage"] = "";
									$data["currencySymbol"] = empty($RateTablePKGRate->MonthlyCostCurrencySymbol) ? "$" : $RateTablePKGRate->MonthlyCostCurrencySymbol;
									$results[] = $data;
								}

								if (!empty($RateTablePKGRate->PackageCostPerMinute) && !empty($json_file["CUST_PANEL_PAGE_INVOICE_PDF_LBL_PACKAGE_COST_PER_MINUTE"])) {
									$data["priceItemId"] = '';//$RateTablePKGRate->RateID;;
									$data["costGroupName"] = "VARIABLE COSTS AND OUTPAYMENTS";
									$data["pricePlanId"] = '';
									$data["name"] = $json_file["CUST_PANEL_PAGE_INVOICE_PDF_LBL_PACKAGE_COST_PER_MINUTE"] . ($RateTablePKGRate->Title == "Default" ? "" : $RateTablePKGRate->Title);
									$data["iso2"] = $data_lang->ISOCode;
									$data["salesPrice"] = $RateTablePKGRate->PackageCostPerMinute;
									$data["salesPricePercentage"] = "";
									$data["currencySymbol"] = empty($RateTablePKGRate->PackageCostPerMinuteCurrencySymbol) ? "$" : $RateTablePKGRate->PackageCostPerMinuteCurrencySymbol;
									$results[] = $data;
								}
								if (!empty($RateTablePKGRate->RecordingCostPerMinute) && !empty($json_file["CUST_PANEL_PAGE_INVOICE_PDF_LBL_RECORDING_COST_PER_MINUTE"])) {
									$data["priceItemId"] = '';//$RateTablePKGRate->RateID;;
									$data["costGroupName"] = "VARIABLE COSTS AND OUTPAYMENTS";
									$data["pricePlanId"] = '';
									$data["name"] = $json_file["CUST_PANEL_PAGE_INVOICE_PDF_LBL_RECORDING_COST_PER_MINUTE"] . ($RateTablePKGRate->Title == "Default" ? "" : $RateTablePKGRate->Title);
									$data["iso2"] = $data_lang->ISOCode;
									$data["salesPrice"] = $RateTablePKGRate->RecordingCostPerMinute;
									$data["salesPricePercentage"] = "";
									$data["currencySymbol"] = empty($RateTablePKGRate->RecordingCostPerMinuteCurrencySymbol) ? "$" : $RateTablePKGRate->RecordingCostPerMinuteCurrencySymbol;
									$results[] = $data;
								}

							}
						}
					}
				}
				//Log::info('priceItemList package size.' . count($results));
				if (count($results) > 0) {
					$Postdata = array();
					$PricingJSONInput['pricePlanId'] = '';
					$PricingJSONInput['partnerId'] = $partnerId;
					$PricingJSONInput['productId'] = $productId;
					$PricingJSONInput['pricePlanTypeId'] = "";
					$PricingJSONInput['validFrom'] = $validFrom;
					$PricingJSONInput['priceItemList'] = $results;
					//Log::info('priceItemList json encode.' . print_r($Postdata, true));
					$PricingJSONInput = json_encode($PricingJSONInput, true);
					//Log::info('priceItemList json encode.' . $PricingJSONInput);
					$results = array();
					$data = array();

					$APIResponse = NeonAPI::callPostAPI($Postdata, $PricingJSONInput, $PriceAPIMethod, $PriceAPIURL);
					$PricingJSONInput = [];
				}

				foreach ($ProductResponses as $ProductResponse) {
					$DiDCategorySaveDescription = $ProductResponse->CategoryDescription;
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


					$Query = "select didRate.*,timeZ.Title,(select Prefix from tblCountry where Country = '" . $ProductResponse->country . "') as countryPrefix,(select Code from tblRate rate where didRate.OriginationRateID = rate.RateID) as orginationCode,
								(select Symbol from tblCurrency where CurrencyId = OneOffCostCurrency  ) as OneOffCostCurrencySymbol,
								 (select Symbol from tblCurrency where CurrencyId = MonthlyCostCurrency  ) as MonthlyCostCurrencySymbol,
								   (select Symbol from tblCurrency where CurrencyId = CostPerMinuteCurrency  ) as CostPerMinuteCurrencySymbol,
								    (select Symbol from tblCurrency where CurrencyId = OutpaymentPerCallCurrency  ) as OutpaymentPerCallCurrencySymbol,
								    (select Symbol from tblCurrency where CurrencyId = RegistrationCostPerNumberCurrency  ) as RegistrationCostPerNumberCurrencySymbol,
								    (select Symbol from tblCurrency where CurrencyId = SurchargePerCallCurrency  ) as SurchargePerCallCurrencySymbol,
								    (select Symbol from tblCurrency where CurrencyId = SurchargePerMinuteCurrency  ) as SurchargePerMinuteCurrencySymbol,
								    (select Symbol from tblCurrency where CurrencyId = SurchargesCurrency  ) as SurchargesCurrencyCurrencySymbol,
								    (select Symbol from tblCurrency where CurrencyId = CostPerCallCurrency  ) as CostPerCallCurrencySymbol,
								    (select Symbol from tblCurrency where CurrencyId = ChargebackCurrency  ) as ChargebackCurrencySymbol,
								    (select Symbol from tblCurrency where CurrencyId = CollectionCostAmountCurrency  ) as CollectionCostAmountCurrencySymbol
 					from tblRateTableDIDRate didRate,tblTimezones timeZ where
										didRate.RateID in (select RateID from tblRate where Code = concat((select Prefix from tblCountry where Country = '" . $ProductResponse->country . "'), '" . $ProductResponse->prefixName . "'))
										   and RateTableId in (" . $ProductResponse->RateTableId . ")
										   and didRate.CityTariff = '" . $ProductResponse->city_tariff . "'" . "
										   and didRate.ApprovedStatus = 1 and didRate.EffectiveDate <= NOW()
										    and timeZ.TimezonesID = didRate.TimezonesID";


					//Log::info('$ServiceTemapleInboundTariff query.' . $Query);
					$RateTableDIDRates = DB::select($Query);
					//$RateTableDIDRates = $RateTableDIDRates->get();
					//Log::info('$ServiceTemapleInboundTariff query.' . $ServiceTemapleInboundTariff->toSql());


					//$system_name='CUST_PANEL_PAGE_INVOICE_PDF_LBL_COST_PER_CALL';
					//Log::info('Translation name.' . $json_file['CUST_PANEL_PAGE_INVOICE_PDF_LBL_COST_PER_CALL']);
					foreach ($RateTableDIDRates as $RateTableDIDRate) {
						Log::info('$RateTableDIDRate RateID.' . $RateTableDIDRate->RateID);
						$prefixName = $ProductResponse->prefixName;
						$SetRateTableEffectiveDate = $ProductResponse->TableEffectiveDate;
						$data_langs = DB::table('tblLanguage')
							->select("TranslationID", "tblTranslation.Language", "Translation", "tblLanguage.ISOCode")
							->join('tblTranslation', 'tblLanguage.LanguageID', '=', 'tblTranslation.LanguageID')
							->get();
						if ($SetDiDCategory == 1) {
							//Log::info('priceItemList json encode outside compare.' . $ProductResponse->DIDCategoryId . ':' . $DiDCategorySaveID);
							if ($ProductResponse->DIDCategoryId != $DiDCategorySaveID) {
								//	Log::info('priceItemList json encode outside compare true.' . $ProductPackage->DIDCategoryId . ':' .  $DiDCategorySaveID . ":" . count($results)) ;
								if (count($results) > 0) {
									$Postdata = array();
									$PricingJSONInput['pricePlanId'] = "";
									$PricingJSONInput['partnerId'] = $partnerId;
									$PricingJSONInput['productId'] = $productId;
									$PricingJSONInput['pricePlanTypeId'] = Helper::getPricePlanTypeID($DiDCategorySaveDescription);
									$PricingJSONInput['validFrom'] = empty($SetRateTableEffectiveDate) ? $validFrom : $SetRateTableEffectiveDate;
									$PricingJSONInput['priceItemList'] = $results;
									//Log::info('priceItemList json encode.' . print_r($Postdata, true));
									$PricingJSONInput = json_encode($PricingJSONInput, true);
									//Log::info('priceItemList json encode outside.' . $ProductPackage->DIDCategoryId . ' ' . $PricingJSONInput);
									$APIResponse = NeonAPI::callPostAPI($Postdata, $PricingJSONInput, $PriceAPIMethod, $PriceAPIURL);
									$PricingJSONInput = [];
									$results = array();
									$data = array();
								}

							} else {
								$DiDCategorySaveID = $ProductPackage->DIDCategoryId;
							}
						}
						$LabelName = '';
						//Log::info('Language Count.' . count($data_langs)) ;
						foreach ($data_langs as $data_lang) {
							$LabelName = $ProductResponse->country;
							$json_file = json_decode($data_lang->Translation, true);
							//Log::info('Language Code.' . $data_lang->ISOCode);
							//Universal Code Changes
							if (strpos($ProductResponse->ProductName, 'UIFN') != false) {
								$LabelName = str_replace(" ", "_", $LabelName);
							} else {
								$LabelName = '';
							}
							//Log::info('Label Name.' . $data_lang->ISOCode);
							//Log::info('Label Name.' . $json_file['CUST_PANEL_PAGE_INVOICE_PDF_LBL_ONE_OFF_COST_VIETNAM']);
							//Log::info('Label Name.' . Helper::getTranslationText($json_file,"CUST_PANEL_PAGE_INVOICE_PDF_LBL_ONE_OFF_COST",$LabelName));

							if (!empty($RateTableDIDRate->OneOffCost) &&
								!empty(Helper::getTranslationText($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_LBL_ONE_OFF_COST", $LabelName))
							) {
								$data["priceItemId"] = "";
								$data["pricePlanId"] = "";
								$data["costGroupName"] = "INSTALLATION COSTS";

								$data["name"] = Helper::getTranslationText($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_LBL_ONE_OFF_COST", $LabelName) . '='
									. (!empty($RateTableDIDRate->orginationCode) ? (" From " .
										Helper::getTranslationTextForKey($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_" . $RateTableDIDRate->orginationCode, $RateTableDIDRate->orginationCode) . ' ') : "")
									. ($RateTableDIDRate->Title == "Default" ? "" :
										Helper::getTranslationTextForKey($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_" . $RateTableDIDRate->Title, $RateTableDIDRate->Title));
								$data["iso2"] = $data_lang->ISOCode;
								$data["salesPrice"] = $RateTableDIDRate->OneOffCost;
								$data["salesPricePercentage"] = "";
								$data["currencySymbol"] = empty($RateTableDIDRate->OneOffCostCurrencySymbol) ? "$" : $RateTableDIDRate->OneOffCostCurrencySymbol;
								$results[] = $data;
							}
							if (!empty($RateTableDIDRate->CostPerMinute) &&
								!empty(Helper::getTranslationText($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_LBL_COST_PER_MINUTE", $LabelName))
							) {
								$data["priceItemId"] = "";
								$data["costGroupName"] = "VARIABLE COSTS AND OUTPAYMENTS";
								$data["pricePlanId"] = "";
								$data["name"] = Helper::getTranslationText($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_LBL_COST_PER_MINUTE", $LabelName) . '='
									. (!empty($RateTableDIDRate->orginationCode) ? (" From " .
										Helper::getTranslationTextForKey($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_" . $RateTableDIDRate->orginationCode, $RateTableDIDRate->orginationCode) . ' ') : "")
									. ($RateTableDIDRate->Title == "Default" ? "" : Helper::getTranslationTextForKey($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_" . $RateTableDIDRate->Title, $RateTableDIDRate->Title));
								$data["iso2"] = $data_lang->ISOCode;
								$data["salesPricePercentage"] = "";
								$data["salesPrice"] = $RateTableDIDRate->CostPerMinute;
								$data["currencySymbol"] = empty($RateTableDIDRate->CostPerMinuteCurrencySymbol) ? "$" : $RateTableDIDRate->CostPerMinuteCurrencySymbol;
								$results[] = $data;
							}

							if (!empty($RateTableDIDRate->CostPerCall) &&
								!empty(Helper::getTranslationText($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_LBL_COST_PER_CALL", $LabelName))
							) {
								$data["priceItemId"] = "";
								$data["costGroupName"] = "VARIABLE COSTS AND OUTPAYMENTS";
								$data["pricePlanId"] = "";
								$data["name"] = Helper::getTranslationText($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_LBL_COST_PER_CALL", $LabelName) . '='
									. (!empty($RateTableDIDRate->orginationCode) ? (" From " .
										Helper::getTranslationTextForKey($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_" . $RateTableDIDRate->orginationCode, $RateTableDIDRate->orginationCode) . ' ') : "")
									. ($RateTableDIDRate->Title == "Default" ? "" : Helper::getTranslationTextForKey($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_" . $RateTableDIDRate->Title, $RateTableDIDRate->Title));
								$data["iso2"] = $data_lang->ISOCode;
								$data["salesPricePercentage"] = "";
								$data["salesPrice"] = $RateTableDIDRate->CostPerCall;
								$data["currencySymbol"] = empty($RateTableDIDRate->CostPerCallCurrencySymbol) ? "$" : $RateTableDIDRate->CostPerCallCurrencySymbol;
								$results[] = $data;
							}

							if (!empty($RateTableDIDRate->OutpaymentPerCall) &&
								!empty(Helper::getTranslationText($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_LBL_OUTPAYMENT_PER_CALL", $LabelName))
							) {
								$data["priceItemId"] = "";
								$data["costGroupName"] = "VARIABLE COSTS AND OUTPAYMENTS";
								$data["pricePlanId"] = "";

								$data["name"] = Helper::getTranslationText($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_LBL_OUTPAYMENT_PER_CALL", $LabelName) . '='
									. (!empty($RateTableDIDRate->orginationCode) ? (" From " .
										Helper::getTranslationTextForKey($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_" . $RateTableDIDRate->orginationCode, $RateTableDIDRate->orginationCode) . ' ') : "")
									. ($RateTableDIDRate->Title == "Default" ? "" : Helper::getTranslationTextForKey($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_" . $RateTableDIDRate->Title, $RateTableDIDRate->Title));
								$data["iso2"] = $data_lang->ISOCode;
								$data["salesPricePercentage"] = "";
								$data["salesPrice"] = $RateTableDIDRate->OutpaymentPerCall;
								$data["currencySymbol"] = empty($RateTableDIDRate->OutpaymentPerCallCurrency) ? "$" : $RateTableDIDRate->OutpaymentPerCallCurrency;
								$results[] = $data;
							}
							if (!empty($RateTableDIDRate->OutpaymentPerMinute) &&
								!empty(Helper::getTranslationText($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_LBL_OUTPAYMENT_PER_MINUTE", $LabelName))
							) {
								$data["priceItemId"] = "";
								$data["costGroupName"] = "VARIABLE COSTS AND OUTPAYMENTS";
								$data["pricePlanId"] = "";
								$data["name"] = Helper::getTranslationText($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_LBL_OUTPAYMENT_PER_MINUTE", $LabelName) . '='
									. (!empty($RateTableDIDRate->orginationCode) ? (" From " .
										Helper::getTranslationTextForKey($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_" . $RateTableDIDRate->orginationCode, $RateTableDIDRate->orginationCode) . ' ') : "") .
									($RateTableDIDRate->Title == "Default" ? "" : Helper::getTranslationTextForKey($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_" . $RateTableDIDRate->Title, $RateTableDIDRate->Title));
								$data["iso2"] = $data_lang->ISOCode;
								$data["salesPrice"] = $RateTableDIDRate->OutpaymentPerMinute;
								$data["salesPricePercentage"] = "";
								$data["currencySymbol"] = empty($RateTableDIDRate->OutpaymentPerMinuteCurrencySymbol) ? "$" : $RateTableDIDRate->OutpaymentPerMinuteCurrencySymbol;
								$results[] = $data;
							}

							if (!empty($RateTableDIDRate->Chargeback) &&
								!empty(Helper::getTranslationText($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_LBL_CHARGEBACK", $LabelName))
							) {
								$data["priceItemId"] = "";
								$data["costGroupName"] = "VARIABLE COSTS AND OUTPAYMENTS";
								$data["pricePlanId"] = "";

								$data["name"] = Helper::getTranslationText($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_LBL_CHARGEBACK", $LabelName) . '='
									. (!empty($RateTableDIDRate->orginationCode) ? (" From " .
										Helper::getTranslationTextForKey($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_" . $RateTableDIDRate->orginationCode, $RateTableDIDRate->orginationCode) . ' ') : "")
									. ($RateTableDIDRate->Title == "Default" ? "" : Helper::getTranslationTextForKey($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_" . $RateTableDIDRate->Title, $RateTableDIDRate->Title));
								$data["iso2"] = $data_lang->ISOCode;
								$data["salesPricePercentage"] = "";
								$data["salesPrice"] = $RateTableDIDRate->OutpaymentPerCall;
								$data["currencySymbol"] = empty($RateTableDIDRate->ChargebackCurrencySymbol) ? "$" : $RateTableDIDRate->ChargebackCurrencySymbol;
								$results[] = $data;
							}
							//Log::info('$RateTableDIDRate->MonthlyCost.' . $RateTableDIDRate->MonthlyCost.' '.
							//	Helper::getTranslationText($json_file,"CUST_PANEL_PAGE_INVOICE_PDF_LBL_MONTHLY_COST",$LabelName)) ;

							if (!empty($RateTableDIDRate->MonthlyCost) &&
								!empty(Helper::getTranslationText($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_LBL_MONTHLY_COST", $LabelName))
							) {
								$data["priceItemId"] = "";
								$data["costGroupName"] = "SUBSCRIPTION COSTS";
								$data["pricePlanId"] = "";
								$data["name"] = Helper::getTranslationText($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_LBL_MONTHLY_COST", $LabelName) . '='
									. (!empty($RateTableDIDRate->orginationCode) ? (" From " .
										Helper::getTranslationTextForKey($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_" . $RateTableDIDRate->orginationCode, $RateTableDIDRate->orginationCode) . ' ') : "") .
									($RateTableDIDRate->Title == "Default" ? "" : Helper::getTranslationTextForKey($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_" . $RateTableDIDRate->Title, $RateTableDIDRate->Title));
								$data["iso2"] = $data_lang->ISOCode;
								$data["salesPrice"] = $RateTableDIDRate->MonthlyCost;
								$data["salesPricePercentage"] = "";
								$data["currencySymbol"] = empty($RateTableDIDRate->MonthlyCostCurrencySymbol) ? "$" : $RateTableDIDRate->MonthlyCostCurrencySymbol;
								$results[] = $data;
								//Log::info('$RateTableDIDRate->MonthlyCost.' . count($results));
							}

							if (!empty($RateTableDIDRate->RegistrationCostPerNumber)
								&& !empty(Helper::getTranslationText($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_LBL_REGISTERATION_COST_PER_NUMBER", $LabelName))
							) {
								$data["priceItemId"] = "";
								$data["costGroupName"] = "INSTALLATION COSTS";
								$data["pricePlanId"] = "";
								$data["name"] = Helper::getTranslationText($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_LBL_REGISTERATION_COST_PER_NUMBER", $LabelName) . '='
									. (!empty($RateTableDIDRate->orginationCode) ? (" From " .
										Helper::getTranslationTextForKey($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_" . $RateTableDIDRate->orginationCode, $RateTableDIDRate->orginationCode) . ' ') : "") .
									($RateTableDIDRate->Title == "Default" ? "" : Helper::getTranslationTextForKey($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_" . $RateTableDIDRate->Title, $RateTableDIDRate->Title));
								$data["iso2"] = $data_lang->ISOCode;
								$data["salesPrice"] = $RateTableDIDRate->RegistrationCostPerNumber;
								$data["salesPricePercentage"] = "";
								$data["currencySymbol"] = empty($RateTableDIDRate->RegistrationCostPerNumberCurrencySymbol) ? "$" : $RateTableDIDRate->RegistrationCostPerNumberCurrencySymbol;
								$results[] = $data;
							}
							if (!empty($RateTableDIDRate->CollectionCostAmount) &&
								!empty(Helper::getTranslationText($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_LBL_COLLECTION_COST_AMOUNT", $LabelName))
							) {
								$data["priceItemId"] = "";
								$data["costGroupName"] = "VARIABLE COSTS AND OUTPAYMENTS";
								$data["pricePlanId"] = "";
								$data["name"] = Helper::getTranslationText($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_LBL_COLLECTION_COST_AMOUNT", $LabelName) . '='
									. (!empty($RateTableDIDRate->orginationCode) ? (" From " .
										Helper::getTranslationTextForKey($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_" . $RateTableDIDRate->orginationCode, $RateTableDIDRate->orginationCode) . ' ') : "") .
									($RateTableDIDRate->Title == "Default" ? "" : Helper::getTranslationTextForKey($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_" . $RateTableDIDRate->Title, $RateTableDIDRate->Title));
								$data["iso2"] = $data_lang->ISOCode;
								$data["salesPrice"] = $RateTableDIDRate->CollectionCostAmount;
								$data["salesPricePercentage"] = "";
								$data["currencySymbol"] = empty($RateTableDIDRate->CollectionCostAmountCurrencySymbol) ? "$" : $RateTableDIDRate->CollectionCostAmountCurrencySymbol;
								$results[] = $data;
							}
							if (!empty($RateTableDIDRate->CollectionCostAmount) &&
								!empty(Helper::getTranslationText($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_LBL_COLLECTION_COST_AMOUNT", $LabelName))
							) {
								$data["priceItemId"] = "";
								$data["costGroupName"] = "VARIABLE COSTS AND OUTPAYMENTS";
								$data["pricePlanId"] = "";
								$data["name"] = Helper::getTranslationText($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_LBL_COLLECTION_COST_AMOUNT", $LabelName) . '='
									. (!empty($RateTableDIDRate->orginationCode) ? (" From " .
										Helper::getTranslationTextForKey($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_" . $RateTableDIDRate->orginationCode, $RateTableDIDRate->orginationCode) . ' ') : "") .
									($RateTableDIDRate->Title == "Default" ? "" : Helper::getTranslationTextForKey($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_" . $RateTableDIDRate->Title, $RateTableDIDRate->Title));
								$data["iso2"] = $data_lang->ISOCode;
								$data["salesPrice"] = $RateTableDIDRate->CollectionCostAmount;
								$data["salesPricePercentage"] = "";
								$data["currencySymbol"] = empty($RateTableDIDRate->CollectionCostAmountCurrencySymbol) ? "$" : $RateTableDIDRate->CollectionCostAmountCurrencySymbol;
								$results[] = $data;
							}

							if (!empty($RateTableDIDRate->SurchargePerCall) &&
								!empty(Helper::getTranslationText($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_LBL_SURCHARGE_PER_CALL", $LabelName))
							) {
								$data["priceItemId"] = "";
								$data["costGroupName"] = "VARIABLE COSTS AND OUTPAYMENTS";
								$data["pricePlanId"] = "";
								$data["name"] = Helper::getTranslationText($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_LBL_SURCHARGE_PER_CALL", $LabelName) . '='
									. (!empty($RateTableDIDRate->orginationCode) ? (" From " .
										Helper::getTranslationTextForKey($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_" . $RateTableDIDRate->orginationCode, $RateTableDIDRate->orginationCode) . ' ') : "") .
									($RateTableDIDRate->Title == "Default" ? "" : Helper::getTranslationTextForKey($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_" . $RateTableDIDRate->Title, $RateTableDIDRate->Title));
								$data["iso2"] = $data_lang->ISOCode;
								$data["salesPrice"] = $RateTableDIDRate->SurchargePerCall;
								$data["salesPricePercentage"] = "";
								$data["currencySymbol"] = empty($RateTableDIDRate->SurchargePerCallCurrencySymbol) ? "$" : $RateTableDIDRate->SurchargePerCallCurrencySymbol;
								$results[] = $data;
							}
							if (!empty($RateTableDIDRate->SurchargePerMinute) &&
								!empty(Helper::getTranslationText($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_LBL_SURCHARGE_PER_MINUTE", $LabelName))
							) {
								$data["priceItemId"] = "";
								$data["costGroupName"] = "VARIABLE COSTS AND OUTPAYMENTS";
								$data["pricePlanId"] = "";
								$data["name"] = Helper::getTranslationText($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_LBL_SURCHARGE_PER_MINUTE", $LabelName) . '='
									. (!empty($RateTableDIDRate->orginationCode) ? (" From " .
										Helper::getTranslationTextForKey($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_" . $RateTableDIDRate->orginationCode, $RateTableDIDRate->orginationCode) . ' ') : "") .
									($RateTableDIDRate->Title == "Default" ? "" : Helper::getTranslationTextForKey($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_" . $RateTableDIDRate->Title, $RateTableDIDRate->Title));
								$data["iso2"] = $data_lang->ISOCode;
								$data["salesPrice"] = $RateTableDIDRate->SurchargePerMinute;
								$data["salesPricePercentage"] = "";
								$data["currencySymbol"] = empty($RateTableDIDRate->SurchargePerMinuteCurrencySymbol) ? "$" : $RateTableDIDRate->SurchargePerMinuteCurrencySymbol;
								$results[] = $data;
							}
							if (!empty($RateTableDIDRate->Surcharges) &&
								!empty(Helper::getTranslationText($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_LBL_SURCHARGE", $LabelName))
							) {
								$data["priceItemId"] = "";
								$data["costGroupName"] = "VARIABLE COSTS AND OUTPAYMENTS";
								$data["pricePlanId"] = "";
								$data["name"] = Helper::getTranslationText($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_LBL_SURCHARGE", $LabelName) . '='
									. (!empty($RateTableDIDRate->orginationCode) ? (" From " .
										Helper::getTranslationTextForKey($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_" . $RateTableDIDRate->orginationCode, $RateTableDIDRate->orginationCode) . ' ') : "") .
									($RateTableDIDRate->Title == "Default" ? "" : Helper::getTranslationTextForKey($json_file, "CUST_PANEL_PAGE_INVOICE_PDF_" . $RateTableDIDRate->Title, $RateTableDIDRate->Title)) . '=';
								$data["iso2"] = $data_lang->ISOCode;
								$data["salesPrice"] = "";
								$data["salesPricePercentage"] = $RateTableDIDRate->Surcharges;
								$data["currencySymbol"] = empty($RateTableDIDRate->SurchargesCurrencyCurrencySymbol) ? "$" : $RateTableDIDRate->SurchargesCurrencyCurrencySymbol;
								$results[] = $data;
							}


						}
					}

					//Log::info('priceItemList size.' . count($results));
					//$apiPricing["priceItemList"] = $results;
					$Postdata = array(
//								'pricePlanId' => $pricePlanId,
//								'partnerId' => $partnerId,
//								'productId' => $productId,
//								'pricePlanTypeId'=>$pricePlanTypeId,
//								'validFrom'=>$validFrom,
//								'priceItemList'                => $results
					);


					//	}
					//}
					//$Query = $Query .'(DynamicFieldsID = ' . $DynamicFieldsID . " and FieldValue='" . $ProductResponse->productId . "')";
					//$Query = $Query . " OR ";
					if ($SetDiDCategory == 0) {
						$DiDCategorySaveID = $ProductResponse->DIDCategoryId;
						$SetDiDCategory = 1;
					//	Log::info('priceItemList json encode outside compare0.' . $ProductResponse->DIDCategoryId . ":" . $DiDCategorySaveID);

					}


				}

				if (count($results) > 0) {
					$Postdata = array();
					$PricingJSONInput['pricePlanId'] = "";
					$PricingJSONInput['partnerId'] = $partnerId;
					$PricingJSONInput['productId'] = $productId;
					$PricingJSONInput['pricePlanTypeId'] = Helper::getPricePlanTypeID($DiDCategorySaveDescription);
					$PricingJSONInput['validFrom'] = empty($SetRateTableEffectiveDate) ? $validFrom : $SetRateTableEffectiveDate;;
					$PricingJSONInput['priceItemList'] = $results;
					//Log::info('priceItemList json encode.' . print_r($Postdata, true));
					$PricingJSONInput = json_encode($PricingJSONInput, true);
					//Log::info('priceItemList json encode inside.' . $DiDCategorySaveID . ' ' . $PricingJSONInput);
					$APIResponse = NeonAPI::callPostAPI($Postdata, $PricingJSONInput, $PriceAPIMethod, $PriceAPIURL);
					$PricingJSONInput = [];
					$results = array();
					$data = array();
				}
			}
				CronJob::CronJobSuccessEmailSend($CronJobID);
				$joblogdata['CronJobID'] = $CronJobID;
				$joblogdata['created_at'] = Date('y-m-d');
				$joblogdata['created_by'] = 'RMScheduler';
				$joblogdata['Message'] = 'PushSalesServiceERP Successfully Done';
				$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
				CronJobLog::insert($joblogdata);
				CronJob::deactivateCronJob($CronJob);
				CronHelper::after_cronrun($this->name, $this);
			//	echo "DONE With PushSalesPricesERP";
		} else {
			//	Log::info('PushSalesPricesERP:DynamicFieldsID .' . $fieldName . ' Not Found');
			//	Log::info('PushSalesPricesERP:DynamicFieldsID .' . $AccountFieldName . ' Not Found');
			//	Log::info('PushSalesPricesERP:DynamicFieldsID .' . $PackageFieldName . ' Not Found');
				CronJob::CronJobSuccessEmailSend($CronJobID);
				$joblogdata['CronJobID'] = $CronJobID;
				$joblogdata['created_at'] = Date('y-m-d');
				$joblogdata['created_by'] = 'RMScheduler';
				$joblogdata['Message'] = 'PushSalesServiceERP, One of DynamicFiled is missing ' . $fieldName . ' '
				.' ' . $AccountFieldName . ' ' . $PackageFieldName;
				$joblogdata['CronJobStatus'] = CronJob::CRON_SUCCESS;
				CronJobLog::insert($joblogdata);
				CronJob::deactivateCronJob($CronJob);
				CronHelper::after_cronrun($this->name, $this);
			//	echo "DONE With PushSalesPricesERP";

		}
				//Code for PushSalesPriceService





				//Log::info('routingList:Get the routing list user company.' . $CompanyID);
			//	Log::info('Run Cron.');
			}catch(\Exception $e){
				Log::useFiles(storage_path() . '/logs/PushSalesPricesERP-Error-' . date('Y-m-d') . '.log');
				//Log::info('LCRRoutingEngine Error.');
				Log::useFiles(storage_path() . '/logs/PushSalesPricesERP-Error-' . date('Y-m-d') . '.log');

				Log::error($e);
				$this->info('Failed:' . $e->getMessage());
				$joblogdata['CronJobID'] = $CronJobID;
				$joblogdata['created_at'] = Date('y-m-d');
				$joblogdata['created_by'] = 'RMScheduler';
				$joblogdata['Message'] = 'Error:' . $e->getMessage();
				$joblogdata['CronJobStatus'] = CronJob::CRON_FAIL;
				CronJobLog::insert($joblogdata);
				if (!empty($cronsetting['ErrorEmail'])) {

					$result = CronJob::CronJobErrorEmailSend($CronJobID, $e);
					Log::error("**Email Sent Status " . $result['status']);
					Log::error("**Email Sent message " . $result['message']);
				}


			}

}






}
