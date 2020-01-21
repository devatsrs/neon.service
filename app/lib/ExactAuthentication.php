<?php
namespace App\Lib;

class ExactAuthentication extends \Eloquent {
    protected $connection = 'sqlsrv';
    protected $fillable = [];
    protected $table = "tblExactAuthentication";
    protected $guarded = array("ExactAuthenticationID");
    protected $primaryKey = "ExactAuthenticationID";

    public $timestamps = false;

    const RESPONSE_TYPE_AUTH    = 'code'; // for auth request
    const RESPONSE_TYPE_TOKEN   = "authorization_code"; // for token request
    const RESPONSE_TYPE_REFRESH = 'refresh_token'; // for refresh token request

    const KEY_COST_COMPONENT_TERMINATION    = "CostComponentsTermination";
    const KEY_COST_COMPONENT_DID            = "CostComponentsAccess";
    const KEY_COST_COMPONENT_PKG            = "CostComponentsPackage";
    const KEY_PAYMENT_CONDITION             = "PaymentCondition";
    const KEY_ONE_OFF_INVOICE_COMPONENT     = "OneOffInvoiceComponent";
    const TEXT_COST_COMPONENT_TERMINATION   = "Cost Components - Termination";
    const TEXT_COST_COMPONENT_DID           = "Cost Components - Access";
    const TEXT_COST_COMPONENT_PKG           = "Cost Components - Package";
    const TEXT_PAYMENT_CONDITION            = "Payment Condition";
    const TEXT_ONE_OFF_INVOICE_COMPONENT    = "One-Off Invoice Component";

    const KEY_PAYMENT_CONDITION_PREPAID     = 'Prepaid';
    const KEY_PAYMENT_CONDITION_POSTPAID    = 'Postpaid';
    const KEY_PAYMENT_CONDITION_ONCREDIT    = 'OnCredit';
    const KEY_PAYMENT_CONDITION_CREDITCARD  = 'Creditcard';
    const KEY_PAYMENT_CONDITION_DIRECTDEBIT = 'DirectDebit';

    const KEY_VAT_COUNTRY_NL            = "NL";
    const KEY_VAT_COUNTRY_EU            = "EU";
    const KEY_VAT_COUNTRY_NEU           = "NEU";
    const TEXT_VAT_COUNTRY_NL           = "NETHERLANDS";
    const TEXT_VAT_COUNTRY_EU           = "EU Countries";
    const TEXT_VAT_COUNTRY_NEU          = "Non EU Countries";

    const ExactConfigKey            = "exact";
    const BASE_URL                  = 'https://start.exactonline.nl/';
    const AUTH_URL                  = 'api/oauth2/auth';
    const TOKEN_URL                 = 'api/oauth2/token';
    const DIVISION_URL              = 'api/v1/current/Me';
    const ACCOUNT_URL               = 'api/v1/{division}/crm/Accounts';
    const ITEM_URL                  = 'api/v1/{division}/logistics/Items';
    const SALES_INVOICE_URL         = 'api/v1/{division}/salesinvoice/SalesInvoices';
    const SALES_INVOICE_LINE_URL    = 'api/v1/{division}/salesinvoice/SalesInvoiceLines';
    const SALES_ENTRY_URL           = 'api/v1/{division}/salesentry/SalesEntries';
    const SALES_ENTRY_LINE_URL      = 'api/v1/{division}/salesentry/SalesEntryLines';
    const GLACCOUNTS_URL            = 'api/v1/{division}/financial/GLAccounts';
    const DOCUMENT_URL              = 'api/v1/{division}/documents/Documents';
    const DOCUMENT_TYPES_URL        = 'api/v1/{division}/documents/DocumentTypes';
    const DOCUMENT_ATTACHMENTS_URL  = 'api/v1/{division}/documents/DocumentAttachments';
    const JOURNALS_URL              = 'api/v1/{division}/financial/Journals';
    const RECEIVABLESLISTBYACCOUNT  = 'api/v1/{division}/read/financial/ReceivablesListByAccount';

    const DOCUMENT_TYPE_SALES_INVOICE     = 'Sales invoice';
    const DOCUMENT_TYPE_PURCHASE_INVOICE  = 'Purchase invoice';
    const DOCUMENT_TYPE_ATTACHMENT        = 'Attachment';

    const JOURNAL_SALES             = 20;//sales journal

    public static $MappingTypes = [
        ExactAuthentication::KEY_COST_COMPONENT_TERMINATION => ExactAuthentication::TEXT_COST_COMPONENT_TERMINATION,
        ExactAuthentication::KEY_COST_COMPONENT_DID         => ExactAuthentication::TEXT_COST_COMPONENT_DID,
        ExactAuthentication::KEY_COST_COMPONENT_PKG         => ExactAuthentication::TEXT_COST_COMPONENT_PKG,
        ExactAuthentication::KEY_PAYMENT_CONDITION          => ExactAuthentication::TEXT_PAYMENT_CONDITION,
        ExactAuthentication::KEY_ONE_OFF_INVOICE_COMPONENT  => ExactAuthentication::TEXT_ONE_OFF_INVOICE_COMPONENT,
    ];

    public static $VATCountry = [
        ExactAuthentication::KEY_VAT_COUNTRY_NL     => ExactAuthentication::TEXT_VAT_COUNTRY_NL,
        ExactAuthentication::KEY_VAT_COUNTRY_EU     => ExactAuthentication::TEXT_VAT_COUNTRY_EU,
        ExactAuthentication::KEY_VAT_COUNTRY_NEU    => ExactAuthentication::TEXT_VAT_COUNTRY_NEU,
    ];

    public static $PaymentConditionComponents = array(
        "Prepaid"       => "Prepaid",
        "Postpaid"      => "Postpaid",
        "OnCredit"      => "OnCredit",
        "Creditcard"    => "Creditcard",
        "DirectDebit"   => "DirectDebit",
    );

    public static $OneOffInvoiceComponent = array(
        "One-Off"       => "One-Off",
        "Outpayment"    => "Outpayment",
        "TopUp"         => "TopUp",
    );

    public static function getAllMappingElements(){
        $products = [];
        $products[ExactAuthentication::KEY_COST_COMPONENT_TERMINATION]  = RateTableRate::$Components;
        $products[ExactAuthentication::KEY_COST_COMPONENT_DID]          = RateTableDIDRate::$Components;
        $products[ExactAuthentication::KEY_COST_COMPONENT_PKG]          = RateTablePKGRate::$Components;
        $products[ExactAuthentication::KEY_PAYMENT_CONDITION]           = ExactAuthentication::$PaymentConditionComponents;
        $products[ExactAuthentication::KEY_ONE_OFF_INVOICE_COMPONENT]   = ExactAuthentication::$OneOffInvoiceComponent;
        return $products;
    }

}