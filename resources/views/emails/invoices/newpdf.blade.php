@extends('layout.print')

@section('content')
    <link rel="stylesheet" type="text/css" href="{{base_path().'/resources/assets/css/bootstrap.css'}}" />
    <link rel="stylesheet" type="text/css" href="{{base_path().'/resources/assets/invoicetemplate/style.css'}}" />
    @if(isset($language->is_rtl) && $language->is_rtl=="Y")
        <link rel="stylesheet" type="text/css" href="{{base_path().'/resources/assets/css/bootstrap-rtl.min.css'}}" />
    @endif
    <style type="text/css">
        .bg_graycolor{
            background-color: #f5f5f6;
            font-size: 12px;
        }
        .bg_graycolor th, .bg_graycolor td{
            border: 1px solid #dddddd;
        }
        .invoice,
        .invoice table,.invoice table td,.invoice table th,
        .invoice ul li
        { font-size: 12px; }

        #pdf_header, #pdf_footer{
            /*position: fixed;*/
        }

        @media print {
            .page_break{page-break-after: always;}
            * {
                background-color: auto !important;
                background: auto !important;
                color: auto !important;
            }
        }
        .page_break{page-break-after: always;}
        tr {
            page-break-inside: avoid;
        }

        thead {
            display: table-header-group
        }

        tfoot {
            display: table-row-group
        }
        @if(isset($arrSignature["UseDigitalSignature"]) && $arrSignature["UseDigitalSignature"]==true)
    img.signatureImage {
            position: absolute;
            z-index: 99999;
            top: {{isset($arrSignature["DigitalSignature"]->positionTop)?$arrSignature["DigitalSignature"]->positionTop:0}}px;
            left: {{isset($arrSignature["DigitalSignature"]->positionLeft)?$arrSignature["DigitalSignature"]->positionLeft:0}}px;
        }
        @endif
		table td, table th{
            font-size: 11px
        }
    </style>

    <div class="invoiceBody">
        <div id="CompanyInfo">
            <div class="pull-right infoDiv">
                <h2>{{cus_lang("CUST_PANEL_PAGE_INVOICE_TITLE")}}</h2>
            </div>
            <div class="clearfix"></div>
            <div class="pull-left addrDiv">
                    {{ nl2br($Invoice->Address) }}
            </div>
            <div class="pull-right infoDiv">
                <table class="table">
                    <tr>
                        <td width="45%">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_LBL_INVOICE_NO")}}</td>
                        <td>{{ $Invoice->FullInvoiceNumber }}</td>
                    </tr>
                    <tr>
                        <td width="45%">{{cus_lang("CUST_PANEL_PAGE_INVOICE_TBL_AC_NAME")}}</td>
                        <td>{{ $Account->AccountName }}</td>
                    </tr>
                    <tr>
                        <td width="45%">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_LBL_INVOICE_DATE")}}</td>
                        <td>{{ date($dateFormat,strtotime($Invoice->IssueDate))}}</td>
                    </tr>
                    <tr>
                        <td width="45%">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_LBL_DUE_DATE")}}</td>
                        <td>{{date($dateFormat,strtotime($Invoice->IssueDate.' +' . $PaymentDueInDays . ' days'))}}</td>
                    </tr>
                    @if(!empty($MultiCurrencies))
                        @foreach($MultiCurrencies as $multiCurrency)
                            <tr>
                                <td width="40%">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_GRAND_TOTAL_IN")}}</td>                                         <td>{{$multiCurrency['Title']}} : {{$multiCurrency['Amount']}}</td>
                            </tr>
                        @endforeach
                    @endif
                </table>
            </div>
        </div>
        <div class="clearfix"></div>
        <div id="CompanyInfo2" class="clearfix">
            <div class="pull-left credentialDiv">
                @if(isset($arrSignature["UseDigitalSignature"]) && $arrSignature["UseDigitalSignature"] == true)
                    <img src="{{get_image_data($arrSignature['signaturePath'].$arrSignature['DigitalSignature']->image)}}" class="signatureImage" />
                @endif
            </div>
            <div class="pull-right infoDiv">
                <table class="table">
                    @if(!empty($Invoice->PONumber))
                        <tr>
                            <td width="45%">PO</td>
                            <td>{{ $Invoice->PONumber }}</td>
                        </tr>
                    @endif
                    <tr>
                        <td width="45%">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_LBL_INVOICE_PERIOD")}}</td>
                        <td>{{ $InvoicePeriod }}</td>
                    </tr>
                    <tr>
                        <td width="45%">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_LBL_PAGE")}}</td>
                        <td>{{ $PageCounter }}/{{ $TotalPages }}</td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="clearfix"></div>
        <br>
        <br>
        <div class="totalTable">
            <table class="table table-striped">
                <tr></tr>
                <tr>
                    <th style="font-size: 18px; width: 85%">{{cus_lang("CUST_PANEL_PAGE_ANALYSIS_HEADING_INVOICES_&_EXPENSES_LBL_TOTAL_INVOICE")}}</th>
                    <th class="text-right" style="width: 15%">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_AMOUNT")}} ({{$CurrencySymbol}})</th>
                </tr>
                <tr>
                    <td>{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_MONTHLY_COST")}} {{ $InvoicePeriod }}</td>
                    <td class="text-right">{{$CurrencySymbol}} {{ $MonthlySubTotal }}</td>
                </tr>
                @if($OneOffSubTotal > 0)
                    <tr>
                        <td>{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_TOTAL_ADDITIONAL_CHARGES")}}</td>
                        <td class="text-right">{{$CurrencySymbol}} {{ $OneOffSubTotal }}</td>
                    </tr>
                @endif
                <tr>
                    <td>{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TRAFFIC_COST")}}</td>
                    <td class="text-right">{{$CurrencySymbol}} {{ $UsageSubTotal }}</td>
                </tr>
                <tr>
                    <td>VAT</td>
                    <td class="text-right">{{$CurrencySymbol}}{{$TotalVAT}}</td>
                </tr>
            </table>
        </div>
        <div class="clearfix"></div>
        <div>
            <div class="termsDiv pull-left">
                <h4>{{ nl2br($Invoice->Terms) }}</h4>
            </div>
            <div class="totalAmount pull-right">
                <h4>{{$CurrencySymbol}} {{ $GrandTotal }}</h4>
            </div>
        </div>
        <div class="clearfix"></div>
        @if(count($InvoiceComponents))
            @foreach($InvoiceComponents as $key => $InvoiceComponent)
                @if($InvoiceComponent['GrandTotal'] > 0)
                    <?php $PageCounter += 1; ?>
                    <div class="page_break"></div>
                    <div id="CompanyInfo">
                        <br>
                        <div class="infoDetail">
                            <table class="table">
                                <tr>
                                    <td style="width: 15%">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_LBL_INVOICE_NO")}}</td>
                                    <td style="width: 15%">{{$Invoice->FullInvoiceNumber}}</td>
                                    <td style="width: 40%"></td>
                                    <td style="width: 15%">{{cus_lang("CUST_PANEL_PAGE_INVOICE_TBL_AC_NAME")}}</td>
                                    <td style="width: 15%">{{ $Account->AccountName }}</td>
                                </tr>
                                <tr>
                                    <td>{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_LBL_INVOICE_DATE")}}</td>
                                    <td>{{ date($dateFormat,strtotime($Invoice->IssueDate))}}</td>
                                    <td></td>
                                    <td>{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_LBL_INVOICE_PERIOD")}}</td>
                                    <td>{{ $InvoicePeriod }}</td>
                                </tr>
                                <tr>
                                    <td>{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_LBL_DUE_DATE")}}</td>
                                    <td>{{date($dateFormat,strtotime($Invoice->IssueDate.' +' . $PaymentDueInDays . ' days'))}}</td>
                                    <td></td>
                                    <td>{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_LBL_PAGE")}}</td>
                                    <td>{{ $PageCounter }}/{{ $TotalPages }}</td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <div class="clearfix"></div>
                    <div class="detailTable">
                        <table class="table table-striped">
                            <tr>
                                <th style="width: 40%">{{ \App\Lib\Country::getCountryCode($InvoiceComponent['CountryID']) }}  {{ $InvoiceComponent['Prefix'] }}-{{ $InvoiceComponent['CLI'] }} {{ \App\Lib\Package::getServiceNameByID($InvoiceComponent['PackageID']) }}</th>
                                <th class="text-right" style="width: 12%">Standard price ({{$CurrencySymbol}}) </th>
                                <th class="text-right" style="width: 12%">Disc. %</th>
                                <th class="text-right" style="width: 12%">Disc. Price ({{$CurrencySymbol}})</th>
                                <th class="text-right" style="width: 12%">Qty</th>
                                <th class="text-right" style="width: 12%">Amount ({{$CurrencySymbol}})</th>
                            </tr>
                            @if(isset($InvoiceComponent['Monthly']) && !empty($InvoiceComponent['Monthly']))
                                <tr>
                                    <th colspan="6">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_MONTHLY_COST") }} {{ $InvoicePeriod }}</th>
                                </tr>
                                <tr>
                                    <td>{{cus_lang("CUST_PANEL_PAGE_INVOICE_TBL_INVOICE_NUMBER")}}</td>
                                    <td class="text-right">@if(!empty($InvoiceComponent['Monthly']['Price'])){{$CurrencySymbol}} {{ number_format($InvoiceComponent['Monthly']['Price'], $RoundChargesAmount) }}@endif</td>
                                    <td class="text-right">@if(!empty($InvoiceComponent['Monthly']['Discount'])){{ number_format($InvoiceComponent['Monthly']['Discount'], $RoundChargesAmount) }} @endif</td>
                                    <td class="text-right">@if(!empty($InvoiceComponent['Monthly']['DiscountPrice'])){{$CurrencySymbol}} {{ number_format($InvoiceComponent['Monthly']['DiscountPrice'], $RoundChargesAmount) }} @endif</td>
                                    <td class="text-right">@if(!empty($InvoiceComponent['Monthly']['Quantity'])){{ number_format($InvoiceComponent['Monthly']['Quantity'], 0) }} @endif</td>
                                    <td class="text-right">{{$CurrencySymbol}} {{ number_format($InvoiceComponent['Monthly']['SubTotal'], $RoundChargesAmount) }}</td>
                                </tr>
                            @endif
                            @if(isset($InvoiceComponent['OneOffCharge']) && !empty($InvoiceComponent['OneOffCharge']))
                                <tr>
                                    <td>{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_ADDITIONAL")}}</td>
                                    <td class="text-right">@if(!empty($InvoiceComponent['OneOffCharge']['Price'])){{$CurrencySymbol}} {{ number_format($InvoiceComponent['OneOffCharge']['Price'], $RoundChargesAmount) }}@endif</td>
                                    <td class="text-right">@if(!empty($InvoiceComponent['OneOffCharge']['Discount'])){{ number_format($InvoiceComponent['OneOffCharge']['Discount'], $RoundChargesAmount) }} @endif</td>
                                    <td class="text-right">@if(!empty($InvoiceComponent['OneOffCharge']['DiscountPrice'])){{$CurrencySymbol}} {{ number_format($InvoiceComponent['OneOffCharge']['DiscountPrice'], $RoundChargesAmount) }} @endif</td>
                                    <td class="text-right">@if(!empty($InvoiceComponent['OneOffCharge']['Quantity'])){{ number_format($InvoiceComponent['OneOffCharge']['Quantity'], 0) }} @endif</td>
                                    <td class="text-right">{{$CurrencySymbol}} {{ number_format($InvoiceComponent['OneOffCharge']['SubTotal'], $RoundChargesAmount) }}</td>
                                </tr>
                            @endif
                            @if(isset($InvoiceComponent['components']) && count($InvoiceComponent['components'])>0)
                                <tr>
                                    <th>{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TRAFFIC_COST")}}</th>
                                </tr>
                                @foreach($InvoiceComponent['components'] as $component => $comp)
                                    @if($comp['Quantity'] != 0)
                                        <tr>
                                            <td>{{ $comp['Title'] }}</td>
                                            <td class="text-right">@if(!empty($comp['Price'])){{$CurrencySymbol}} {{ $comp['Price'] }} @endif</td>
                                            <td class="text-right">@if(!empty($comp['Discount'])){{ $comp['Discount'] }} @endif</td>
                                            <td class="text-right">@if(!empty($comp['DiscountPrice'])){{$CurrencySymbol}} {{ $comp['DiscountPrice'] }} @endif</td>
                                            <td class="text-right">@if(!empty($comp['Quantity'])){{ $comp['Quantity'] }} @endif</td>
                                            <td class="text-right">{{$CurrencySymbol}} {{ $comp['SubTotal'] }}</td>
                                        </tr>
                                    @endif
                                @endforeach
                            @endif
                            <tr style="font-size: 15px">
                                <th class="text-right" colspan="4">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_SUB_TOTAL")}}</th>
                                <td></td>
                                <td class="text-right">{{$CurrencySymbol}} {{ number_format($InvoiceComponent['SubTotal'], $RoundChargesAmount) }}</td>
                            </tr>
                            <tr style="font-size: 15px">
                                <th class="text-right" colspan="4">VAT</th>
                                <td></td>
                                <td class="text-right">{{$CurrencySymbol}} {{ number_format($InvoiceComponent['TotalTax'], $RoundChargesAmount) }}</td>
                            </tr>
                            <tr style="font-size: 15px">
                                <th class="text-right" colspan="4">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_GRAND_TOTAL")}}</th>
                                <td></td>
                                <td class="text-right">{{$CurrencySymbol}} {{ number_format($InvoiceComponent['GrandTotal'], $RoundChargesAmount) }}</td>
                            </tr>
                        </table>
                    </div>
                    <div class="clearfix"></div>
                @endif
            @endforeach
        @endif
    </div>
@stop