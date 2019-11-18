@extends('layout.print')

@section('content')
    <link rel="stylesheet" type="text/css" href="{{base_path().'/resources/assets/css/bootstrap.css'}}" />
    <link rel="stylesheet" type="text/css" href="{{base_path().'/resources/assets/invoicetemplate/style.css'}}" />
    @if(isset($language->is_rtl) && $language->is_rtl=="Y")
        <link rel="stylesheet" type="text/css" href="{{base_path().'/resources/assets/css/bootstrap-rtl.min.css'}}" />
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
            #client{
                border-left: 0;
            }
            #frontinvoice .desc {
                text-align: right;
            }
            .float-left{
                float: right;
            }
            .leftalign {
                text-align: right;
            }
            .rightalign {
                text-align: left;
            }
        </style>
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
    </style>

    <div class="invoiceBody">
        <div class="col-md-12">
            <div id="CompanyInfo">
                <div class="pull-right infoDiv">
                    <h2>Invoice</h2>
                </div>
                <div class="clearfix"></div>
                <div class="pull-left addrDiv">
                    {{ nl2br(\App\Lib\Account::getAddress($Account)) }}
                </div>
                <div class="pull-right infoDiv">
                    <table class="table">
                        <tr>
                            <td width="45%">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_LBL_INVOICE_NO")}}</td>
                            <td>{{$Invoice->FullInvoiceNumber}}</td>
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
                    @if(isset($arrSignature["UseDigitalSignature"]) && $arrSignature["UseDigitalSignature"]==true)
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
                            <td width="45%">Period</td>
                            <td>{{ $InvoicePeriod }}</td>
                        </tr>
                        <tr>
                            <td width="45%">Page</td>
                            <td>1/2</td>
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
                        <th style="font-size: 18px; width: 56%">Total</th>
                        <th class="text-right" style="width: 11%">Quantity</th>
                        <th class="text-right" style="width: 11%">Rate</th>
                        <th class="text-right" style="width: 11%">Discount ({{$CurrencySymbol}})</th>
                        <th class="text-right" style="width: 11%">Amount ({{$CurrencySymbol}})</th>
                    </tr>
                    <tr>
                        <td>{{ $TotalMonthlyCost['title'] }}</td>
                        <td class="text-right">{{ $TotalMonthlyCost['qty'] }}</td>
                        <td class="text-right">{{$CurrencySymbol}} {{ $TotalMonthlyCost['rate'] }}</td>
                        <td class="text-right">{{$CurrencySymbol}} {{ $TotalMonthlyCost['discount'] }}</td>
                        <td class="text-right">{{$CurrencySymbol}} {{ $TotalMonthlyCost['amount'] }}</td>
                    </tr>
                    <tr>
                        <td>{{ $TotalUsageCost['title'] }}</td>
                        <td class="text-right">{{ $TotalUsageCost['qty'] }}</td>
                        <td class="text-right">{{$CurrencySymbol}} {{ $TotalUsageCost['rate'] }}</td>
                        <td class="text-right">{{$CurrencySymbol}} {{ $TotalUsageCost['discount'] }}</td>
                        <td class="text-right">{{$CurrencySymbol}} {{ $TotalUsageCost['amount'] }}</td>
                    </tr>
                    <tr>
                        <td>VAT</td>
                        <td class="text-right"></td>
                        <td class="text-right">21%</td>
                        <td class="text-right"></td>
                        <td class="text-right">00.00</td>
                    </tr>
                </table>
            </div>
            <div class="clearfix"></div>
            <div>
                <div class="termsDiv pull-left">
                    <h4>{{nl2br($Invoice->Terms)}}</h4>
                </div>
                <div class="totalAmount pull-right">
                    <h4>{{$CurrencySymbol}} 00,000.00</h4>
                </div>
            </div>
        </div>
        <div class="clearfix"></div>
        <div class="page_break"></div>
        <div class="col-md-12">
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
                            <td>Period </td>
                            <td>{{ $InvoicePeriod }}</td>
                        </tr>
                        <tr>
                            <td>{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_LBL_DUE_DATE")}}</td>
                            <td>{{date($dateFormat,strtotime($Invoice->IssueDate.' +' . $PaymentDueInDays . ' days'))}}</td>
                            <td></td>
                            <td>Page</td>
                            <td>2/2</td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="clearfix"></div>
            <div class="detailTable">
                <table class="table table-striped">
                    <tr>
                        <th style="width: 40%">BE  0800-39001  Custom </th>
                        <th class="text-right" style="width: 12%; font-size: ">Standard price ({{$CurrencySymbol}}) </th>
                        <th class="text-right" style="width: 12%">Disc. %</th>
                        <th class="text-right" style="width: 12%"> Disc. Price ({{$CurrencySymbol}})</th>
                        <th class="text-right" style="width: 12%"> Qty</th>
                        <th class="text-right" style="width: 12%">Amount ({{$CurrencySymbol}})</th>
                    </tr>
                    <tr>
                        <th colspan="6">Monthly  costs jan '19 </th>
                    </tr>
                    <tr>
                        <td>Number</td>
                        <td class="text-right">{{$CurrencySymbol}} 5,00 </td>
                        <td class="text-right">10 % </td>
                        <td class="text-right">{{$CurrencySymbol}} 4,50 </td>
                        <td class="text-right">1 </td>
                        <td class="text-right">{{$CurrencySymbol}} 4,50 </td>
                    </tr>
                    <tr>
                        <th colspan="6">Traffic costs</th>
                    </tr>
                    <tr>
                        <td>Traffic costs per call from fixed off peak</td>
                        <td class="text-right">{{$CurrencySymbol}} 5,00 </td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                        <td class="text-right">100</td>
                        <td class="text-right">{{$CurrencySymbol}} 1.50 </td>
                    </tr>
                    <tr>
                        <td>Traffic costs per call from fixed off peak</td>
                        <td class="text-right">€ 5,00 </td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                        <td class="text-right">100</td>
                        <td class="text-right">{{$CurrencySymbol}} 1.50 </td>
                    </tr>
                    <tr>
                        <td>Cost per minute off-peak from fixed</td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                    </tr>
                    <tr>
                        <td>Cost per minute peak from fixed</td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                    </tr>
                    <tr>
                        <td>Package cost per minute</td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                    </tr>
                    <tr>
                        <td>Voice Recording</td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                    </tr>
                    <tr>
                        <td>Cost per minute off-peak from fixed</td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                    </tr>
                    <tr>
                        <td>Termination costs per minute Belgium Fixed </td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                    </tr>
                    <tr>
                        <td>Termination costs per minute Netherlands Fixed </td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                        <td class="text-right"></td>
                    </tr>
                    <tr style="font-size: 15px">
                        <th class="text-right" colspan="4">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_SUB_TOTAL")}}</th>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr style="font-size: 15px">
                        <th class="text-right" colspan="4">VAT</th>
                        <td></td>
                        <td>%</td>
                    </tr>
                    <tr style="font-size: 15px">
                        <th class="text-right" colspan="4">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_GRAND_TOTAL")}}</th>
                        <td></td>
                        <td> {{$CurrencySymbol}} </td>
                    </tr>
                </table>
            </div>
            <div class="clearfix"></div>
        </div>
        <div class="clearfix"></div>
    </div>
@stop