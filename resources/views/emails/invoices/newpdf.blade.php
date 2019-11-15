@extends('layout.print')

@section('content')
    <link rel="stylesheet" type="text/css" href="<?php echo public_path("assets/css/invoicetemplate/invoicestyle.css"); ?>" />
    @if(isset($language->is_rtl) && $language->is_rtl=="Y")
        <link rel="stylesheet" type="text/css" href="<?php echo public_path("assets/css/bootstrap-rtl.min.css"); ?>" />
        <style type="text/css">
            .leftsideview{
                direction: ltr;
            }
            #details{
                border-right: 3px solid #000000;
                padding-right: 6px;
                padding-left: 0px;
                border-left: 0px;
            }
        </style>
    @endif
    <style type="text/css">
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
            display: table-row-group
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

    </style>

    <div class="inovicebody">
        <!-- logo and invoice from section start-->
        <header class="clearfix">
            <div id="logo" class="pull-left flip">
                @if(!empty($logo))
                    <img src="{{get_image_data($logo)}}" style="max-width: 250px">
                @endif
            </div>
            <div id="company" class="pull-right flip">
                <h2 class="name text-right flip"><b>@lang('routes.CUST_PANEL_PAGE_INVOICE_PDF_LBL_INVOICE_FROM')</b></h2>
                <div class="text-right flip">{{ nl2br(Account::getAddress($Account)) }}</div>
            </div>
        </header>
        <!-- logo and invoice from section end-->

        <main>
            @if(isset($arrSignature["UseDigitalSignature"]) && $arrSignature["UseDigitalSignature"]==true)
                <img src="{{get_image_data($arrSignature['signaturePath'].$arrSignature['DigitalSignature']->image)}}" class="signatureImage" />
            @endif

            <div id="details" class="clearfix">
                <div id="client" class="pull-left flip">
                    <div class="to"><b>@lang('routes.CUST_PANEL_PAGE_INVOICE_PDF_LBL_INVOICE_TO')</b></div>
                    <div>{{nl2br($Invoice->Address)}}</div>
                </div>
                <div id="invoice" class="pull-right flip">
                    <h1  class="text-right flip">@lang('routes.CUST_PANEL_PAGE_INVOICE_PDF_LBL_INVOICE_NO') {{$Invoice->FullInvoiceNumber}}</h1>
                    <div class="date text-right flip">@lang('routes.CUST_PANEL_PAGE_INVOICE_PDF_LBL_INVOICE_DATE') {{ date(invoice_date_fomat($Reseller->InvoiceDateFormat),strtotime($Invoice->IssueDate))}}</div>
                    <div class="date text-right flip">@lang('routes.CUST_PANEL_PAGE_INVOICE_PDF_LBL_DUE_DATE') {{date(invoice_date_fomat($Reseller->InvoiceDateFormat),strtotime($Invoice->IssueDate.' +0 days'))}}</div>
                    @if(!empty($MultiCurrencies))
                        @foreach($MultiCurrencies as $multiCurrency)
                            <div class="text-right flip">@lang('routes.CUST_PANEL_PAGE_INVOICE_PDF_TBL_GRAND_TOTAL_IN') {{$multiCurrency['Title']}} : {{$multiCurrency['Amount']}}</div>
                        @endforeach
                    @endif
                </div>
            </div>

            <!-- content of front page section start -->
            <!--<div id="Service">
              <h1>Item</h1>
            </div>-->
            <div class="clearfix"></div>
            <table border="0" cellspacing="0" cellpadding="0" id="frontinvoice">
                <thead>
                <tr>
                    <th class="desc"><b>Total</b></th>
                    <th class="rightalign"><b>@lang('routes.CUST_PANEL_PAGE_INVOICE_PDF_TBL_QUANTITY')</b></th>
                    <th class="rightalign"><b>@lang('routes.CUST_PANEL_PAGE_INVOICE_PDF_TBL_PRICE')</b></th>
                    <th class="rightalign"><b>@lang("routes.CUST_PANEL_PAGE_INVOICE_PDF_TBL_DISCOUNT") ({{$CurrencySymbol}})</b></th>
                    <th class="total"><b>@lang('routes.CUST_PANEL_PAGE_INVOICE_PDF_TBL_LINE_TOTAL') ({{$CurrencySymbol}})</b></th>
                </tr>
                </thead>

                <tbody>
                @foreach($mainData as $mainRow)
                    <tr>
                        <td class="desc">{{$mainRow['Title']}}</td>
                        <td class="rightalign leftsideview">{{$mainRow['Qty']}}</td>
                        <td class="rightalign leftsideview">{{$mainRow['Rate']}}</td>
                        <td class="rightalign leftsideview">{{$mainRow['Discount']}}</td>
                        <td class="total leftsideview">{{number_format($mainRow['Amount'],$RoundChargesAmount)}}</td>
                    </tr>
                @endforeach
                </tbody>
            </table>
            <!-- content of front page section end -->

            <!-- adevrtisement and terms section start-->
            <div id="thanksadevertise">
                <div class="invoice-left">
                    <p><a class="form-control pull-left" style="height: auto">{{nl2br($Invoice->Terms)}}</a></p>
                </div>
                <div class="invoice-right">
                    <p>
                    <h3 class="form-control pull-right" style="height: auto">
                        {{$CurrencySymbol}}{{number_format($Invoice->GrandTotal,$RoundChargesAmount)}}
                    </h3>
                </div>
            </div>
            <!-- adevrtisement and terms section end -->
            @if(count($InvoiceComponents))
                @foreach($InvoiceComponents as $key => $InvoiceComponent)
                    <div class="detailTable">
                        <table class="table table-striped">
                            <tr></tr>
                            <tr>
                                <th style="width: 40%">{{ Country::where('CountryID', $InvoiceComponent['CountryID'])->pluck('ISO2') }}  {{ $InvoiceComponent['Prefix'] }}-{{ $InvoiceComponent['CLI'] }}  {{ Package::getPackageNameByID($InvoiceComponent['PackageID']) }} </th>
                                <th class="text-right" style="width: 12%; font-size: ">Standard price ({{$CurrencySymbol}}) </th>
                                <th class="text-right" style="width: 12%">Disc. %</th>
                                <th class="text-right" style="width: 12%"> Disc. Price ({{$CurrencySymbol}})</th>
                                <th class="text-right" style="width: 12%"> Qty</th>
                                <th class="text-right" style="width: 12%">Amount ({{$CurrencySymbol}})</th>
                            </tr>
                            <tr>
                                <th colspan="6">Monthly Costs {{ $InvoiceComponent['date'] }}</th>
                            </tr>
                            <tr>
                                <td>Number</td>
                                <td>{{$CurrencySymbol}} {{number_format((int)@$InvoiceComponent['Monthly']['TotalCost'],$RoundChargesAmount)}}</td>
                                <td>{{$CurrencySymbol}} {{number_format((int)@$InvoiceComponent['Monthly']['Discount'],$RoundChargesAmount)}}</td>
                                <td>{{$CurrencySymbol}} {{number_format((int)@$InvoiceComponent['Monthly']['DiscountPrice'],$RoundChargesAmount)}}</td>
                                <td>{{number_format((int)@$InvoiceComponent['Monthly']['Quantity'],0)}}</td>
                                <td>{{$CurrencySymbol}} {{number_format((int)@$InvoiceComponent['Monthly']['TotalCost'],$RoundChargesAmount)}}</td>
                            </tr>
                            @if(count($InvoiceComponent['components']))
                                <tr>
                                    <th colspan="6">Traffic costs</th>
                                </tr>
                                @foreach($InvoiceComponent['components'] as $component => $comp)
                                    <tr>
                                        <td>{{ $comp['Title'] }}</td>
                                        <td>{{ $comp['Price'] }}</td>
                                        <td>{{ $comp['Discount'] }}</td>
                                        <td>{{ $comp['DiscountPrice'] }}</td>
                                        <td>{{ $comp['Quantity'] }}</td>
                                        <td>{{ $comp['TotalCost'] }}</td>
                                    </tr>
                                @endforeach
                            @endif
                        </table>
                    </div>
                @endforeach
            @endif
        </main>
@stop