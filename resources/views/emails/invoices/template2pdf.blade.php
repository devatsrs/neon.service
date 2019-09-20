@extends('layout.print')

@section('content')
    <link rel="stylesheet" type="text/css" href="{{base_path().'/resources/assets/invoicetemplate/template2invoicestyle.css'}}" />
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
            #Service{
                float: right;
            }
            .leftalign {
                text-align: right;
            }
            .rightalign {
                text-align: left;
            }
            .summaryright{
                float: left;
            }
            .summaryleft{
                float: right;
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
<div class="inovicebody">
    <!-- logo and invoice from section start-->
    <header class="clearfix">
        <div id="logo" class="pull-left flip">
            @if(!empty($logo))
                <img src="{{get_image_data($logo)}}" style="max-width: 250px">
            @endif
        </div>
        <div id="company" class="pull-right flip">
            <h2 class="name text-right flip"><b>{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_LBL_INVOICE_FROM")}}</b></h2>
            <div class="text-right flip">{{ nl2br($InvoiceTemplate->Header)}}</div>
        </div>
    </header>
    <!-- logo and invoice from section end-->

    <!-- need to change with new logic -->

    <?php
    $InvoiceTo =$InvoiceFrom = '';
    $AllTaxSummary = array();
    $AllTaxCount=0;
    $AllPayment=0;
	$total_usage = 0;
    foreach($InvoiceDetail as $ProductRow){
        if($ProductRow->ProductType == \App\Lib\Product::INVOICE_PERIOD){
            $InvoiceFrom = date('F d,Y',strtotime($ProductRow->StartDate));
            $InvoiceTo = date('F d,Y',strtotime($ProductRow->EndDate));
        }
		if($ProductRow->ProductType == \App\Lib\Product::USAGE){
            $total_usage += $ProductRow->LineTotal;
        }
    }

    $message = $InvoiceTemplate->InvoiceTo;

    $replace_array = \App\Lib\Invoice::create_accountdetails($Account);
    $text = \App\Lib\Invoice::getInvoiceToByAccount($message,$replace_array);
    $return_message = preg_replace("/(^[\r\n]*|[\r\n]+)[\s\t]*[\r\n]+/", "\n", $text);

    $Terms = $Invoice->Terms;
    $textTerms = \App\Lib\Invoice::getInvoiceToByAccount($Terms,$replace_array);
    $return_terms = preg_replace("/(^[\r\n]*|[\r\n]+)[\s\t]*[\r\n]+/", "\n", $textTerms);

    $AllUsageTotal=0;
    $AllSubTotal=0;
    $AllAddTotal=0;
    if(!empty($service_data) && count($service_data)>0){
        foreach($service_data as $service){
            $AllUsageTotal+= number_format($service['usage_cost'],$RoundChargesAmount);
            $AllSubTotal+=number_format($service['sub_cost'],$RoundChargesAmount);
            $AllAddTotal+=number_format($service['add_cost'],$RoundChargesAmount);
        }
    }
    if(!empty($InvoiceTaxRates) && count($InvoiceTaxRates)>0){
        foreach($InvoiceTaxRates as $InvoiceTaxRate){
            $tempsummary['Title']=$InvoiceTaxRate->Title;
            $tempsummary['Amount']=$InvoiceTaxRate->TaxAmount;
            $AllTaxSummary[]=$tempsummary;
            $AllTaxCount+= str_replace(',','',$InvoiceTaxRate->TaxAmount);
        }
    }

    $FooterTerm = $Invoice->FooterTerm;
    $replace_array = \App\Lib\Invoice::create_accountdetails($Account);
    $FooterTermtext = \App\Lib\Invoice::getInvoiceToByAccount($FooterTerm,$replace_array);
    $FooterTerm_message = preg_replace("/(^[\r\n]*|[\r\n]+)[\s\t]*[\r\n]+/", "\n", $FooterTermtext);

    if(!empty($payment_data) && count($payment_data)>0){
        foreach($payment_data as $row){
            $AllPayment  += str_replace(',','',$row['Amount']);
        }
    }
    // if cdrtype is detailcdr and calltype is active than we need to display inbound usage and outbound usage separate in detail section. otherwise it will as it is
    $DisplayCallType=0;
    $CallTypeData = array('NoCallType');
    if($InvoiceTemplate->CDRType == \App\Lib\Account::DETAIL_CDR){
        $DisplayCallType=\App\Lib\InvoiceTemplate::DisplayCallType($usage_data_table['header']);
        if($DisplayCallType==1){
            $CallTypeData= array('OutBound','InBound');
        }
    }
    ?>


    <main>
        @if(isset($arrSignature["UseDigitalSignature"]) && $arrSignature["UseDigitalSignature"]==true)
            <img src="{{get_image_data($arrSignature['signaturePath'].$arrSignature['DigitalSignature']->image)}}" class="signatureImage" />
        @endif
        <div id="details" class="clearfix">
            <div id="client" class="pull-left flip">
                <div class="to"><b>{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_LBL_INVOICE_TO")}}</b></div>
                <div>{{nl2br($return_message)}}</div>
            </div>
            <div id="invoice" class="pull-right flip">
                <h1 class="text-right flip">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_LBL_INVOICE_NO")}} {{$Invoice->FullInvoiceNumber}}</h1>
                <div class="date text-right flip">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_LBL_INVOICE_DATE")}} {{ date($InvoiceTemplate->DateFormat,strtotime($Invoice->IssueDate))}}</div>
                <div class="date text-right flip">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_LBL_DUE_DATE")}} {{date($InvoiceTemplate->DateFormat,strtotime($Invoice->IssueDate.' +'.$PaymentDueInDays.' days'))}}</div>
                @if($InvoiceTemplate->ShowBillingPeriod == 1)
                    <div class="date text-right flip">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_LBL_INVOICE_PERIOD")}} {{ date($InvoiceTemplate->DateFormat,strtotime($InvoiceFrom))}} - {{ date($InvoiceTemplate->DateFormat,strtotime($InvoiceTo))}}</div>
                @endif
                @if(!empty($MultiCurrencies))
                    @foreach($MultiCurrencies as $multiCurrency)
                        <div class="text-right flip">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_GRAND_TOTAL_IN")}} {{$multiCurrency['Title']}} : {{$multiCurrency['Amount']}}</div>
                    @endforeach
                @endif
            </div>
        </div>

        <div style="clear:both;"></div>
        <!-- content of front page section start -->

        <div class="summaryleft" id="summarysection">
            <h2>{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_SUMMARY_OF_CHARGES")}}</h2>
            <table border="0" cellspacing="0" cellpadding="0" id="frontinvoice">
                <tr>
                    <td class="desc">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_BROUGHT_FORWARD")}}</td>
                    <td class="">{{$CurrencySymbol}}{{number_format($Invoice->PreviousBalance,$RoundChargesAmount)}}</td>
                </tr>
                <tr>
                    <td class="desc">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_CURRENT_CHARGES")}}</td>
                    <td class="">{{$CurrencySymbol}}{{number_format($Invoice->GrandTotal,$RoundChargesAmount)}}</td>
                </tr>
                <tr>
                    <td class="desc"><b>{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_TOTAL_DUE")}}</b></td>
                    <td class=""><b>{{$CurrencySymbol}}{{number_format($Invoice->TotalDue,$RoundChargesAmount)}}</b></td>
                </tr>
            </table>
            <br><br>
            <h2>{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_CURRENT_CHARGES_DETAILS")}}</h2>
            <table border="0" cellspacing="0" cellpadding="0" id="frontinvoice">
                <tr>
                    <td class="desc">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_TOTAL_USAGE_CHARGES")}}</td>
                    <td class="">{{$CurrencySymbol}}{{number_format($AllUsageTotal,$RoundChargesAmount)}}</td>
                </tr>
                <tr>
                    <td class="desc">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_TOTAL_RECURRING_CHARGES")}}</td>
                    <td class="">{{$CurrencySymbol}}{{number_format($AllSubTotal,$RoundChargesAmount)}}</td>
                </tr>
                <tr>
                    <td class="desc">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_TOTAL_ADDITIONAL_CHARGES")}}</td>
                    <td class="">{{$CurrencySymbol}}{{number_format($AllAddTotal,$RoundChargesAmount)}}</td>
                </tr>
                <tr>
                    <td class="desc">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_TOTAL_TAXES")}}</td>
                    <td class="">{{$CurrencySymbol}}{{number_format($AllTaxCount,$RoundChargesAmount)}}</td>
                </tr>
                <tr>
                    <td class="desc"><b>{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_GRAND_TOTAL")}}</b></td>
                    <td class=""><b>{{$CurrencySymbol}}{{number_format($Invoice->GrandTotal,$RoundChargesAmount)}}</b></td>
                </tr>
            </table>
        </div>
        <div class="summaryright" id="summarysection">
            {{nl2br($return_terms)}}
        </div>
        <div style="clear:both;"></div>
        <!-- footer section -->
        @if($InvoiceTemplate->FooterDisplayOnlyFirstPage==1)
        <div id="thanksadevertise">
            <div class="invoice-left">
                <p><a class="form-control pull-left" style="height: auto">{{nl2br($FooterTerm_message)}}</a></p>
            </div>
        </div>
        @endif
        <!-- footer section end -->
        <!-- content of front page section end -->
    </main>

    <!-- need to impliment service brack login -->
    @if($InvoiceTemplate->ServiceSplit==0)
    <div class="page_break"> </div>
    <br/>
    @endif
    @foreach($service_data as $ServiceID => $service)
        <?php
        $is_sub = $is_charge = false;
        foreach($InvoiceDetail as $ProductRow){
            if($ProductRow->ProductType == \App\Lib\Product::SUBSCRIPTION && $ProductRow->ServiceID == $ServiceID){
                $is_sub = true;
            }
            if($ProductRow->ProductType == \App\Lib\Product::ONEOFFCHARGE && $ProductRow->ServiceID == $ServiceID){
                $is_charge = true;
            }
        }
        ?>

        @if($InvoiceTemplate->ServiceSplit==1)
            <div class="page_break"> </div>
            <br/>
        @endif
    <header class="clearfix">
        @if(!empty($service['servicetitleshow']))
        <div id="Service">
            <h1>{{$service['name']}}</h1>
            @if(!empty($service['servicedescription']))
                {{nl2br($service['servicedescription'])}}
            @endif
        </div>
        @else
            <div id="Service">
                @if(!empty($service['servicedescription']))
                    <h2> {{nl2br($service['servicedescription'])}} </h2>
                @endif
            </div>
        @endif
    </header>
    <main>
        @if($service['usage_cost'] != 0)
        <div class="ChargesTitle clearfix">
            <div class="pull-left flip col-harf">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_LBL_USAGE")}}</div>
            <div class="text-right pull-right flip col-harf">{{$CurrencySymbol}}{{number_format($service['usage_cost'],$RoundChargesAmount)}}</div>
        </div>
        <table border="0" cellspacing="0" cellpadding="0" id="backinvoice">
            <thead>
            <tr>
                <th class="leftalign">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_TITLE")}}</th>
                <th class="leftalign">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_DESCRIPTION")}}</th>
                <th class="leftalign">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_DATE_FROM")}}</th>
                <th class="leftalign">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_DATE_TO")}}</th>
                <th class="rightalign leftsideview">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_PRICE")}}</th>
                <th class="rightalign leftsideview">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_QUANTITY")}}</th>
                <th class="rightalign leftsideview">{{cus_lang("TABLE_TOTAL")}}</th>
            </tr>
            </thead>
            <tbody>
            @foreach($InvoiceDetail as $ProductRow)
                @if($ProductRow->ProductType == \App\Lib\Product::USAGE && isset($service['usage_cost']))
                    <tr>
                        <td class="leftalign">{{\App\Lib\Product::getProductName($ProductRow->ProductID,$ProductRow->ProductType)}}</td>
                        <td class="leftalign">{{$ProductRow->Description}}</td>
                        <td class="leftalign">{{date($InvoiceTemplate->DateFormat,strtotime($ProductRow->StartDate))}}</td>
                        <td class="leftalign">{{date($InvoiceTemplate->DateFormat,strtotime($ProductRow->EndDate))}}</td>
                        <td class="rightalign leftsideview">{{number_format($service['usage_cost'],$RoundChargesAmount)}}</td>
                        <td class="rightalign leftsideview">{{$ProductRow->Qty}}</td>
                        <td class="rightalign leftsideview">{{number_format($service['usage_cost'],$RoundChargesAmount)}}</td>
                    </tr>
                @endif
            @endforeach
            </tbody>
        </table>
        @endif

        @if($is_sub)
            <div class="ChargesTitle clearfix">
                <div class="pull-left flip col-harf">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_RECURRING")}}</div>
                <div class="text-right pull-right flip col-harf">{{$CurrencySymbol}}{{number_format($service['sub_cost'],$RoundChargesAmount)}}</div>
            </div>

            <table border="0" cellspacing="0" cellpadding="0" id="backinvoice">
                <thead>
                <tr>
                    <th class="leftalign">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_TITLE")}}</th>
                    <th class="leftalign">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_DESCRIPTION")}}</th>
                    <th class="leftalign">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_DATE_FROM")}}</th>
                    <th class="leftalign">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_DATE_TO")}}</th>
                    <th class="rightalign leftsideview">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_PRICE")}}</th>
                    <th class="rightalign leftsideview">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_QUANTITY")}}</th>
                    <th class="rightalign leftsideview">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_DISCOUNT")}}</th>
                    <th class="rightalign leftsideview">{{cus_lang("TABLE_TOTAL")}}</th>
                </tr>
                </thead>
                <tbody>
                @foreach($InvoiceDetail as $ProductRow)
                    @if($ProductRow->ProductType == \App\Lib\Product::SUBSCRIPTION && $ProductRow->ServiceID == $ServiceID)
                        <tr>
                            <td class="leftalign">{{\App\Lib\Product::getProductName($ProductRow->ProductID,$ProductRow->ProductType)}}</td>
                            <td class="leftalign">{{$ProductRow->Description}}</td>
                            <td class="leftalign">{{date($InvoiceTemplate->DateFormat,strtotime($ProductRow->StartDate))}}</td>
                            <td class="leftalign">{{date($InvoiceTemplate->DateFormat,strtotime($ProductRow->EndDate))}}</td>
                            <td class="rightalign leftsideview">{{number_format($ProductRow->Price,$RoundChargesAmount)}}</td>
                            <td class="rightalign leftsideview">{{$ProductRow->Qty}}</td>
                            <td class="rightalign leftsideview">
                                @if(!empty($ProductRow->DiscountAmount) && !empty($ProductRow->DiscountType))
                                    {{number_format($ProductRow->DiscountAmount,$RoundChargesAmount)}}@if($ProductRow->DiscountType=='Percentage') % @endif
                                @endif
                            </td>
                            <td class="rightalign leftsideview">{{number_format($ProductRow->LineTotal,$RoundChargesAmount)}}</td>
                        </tr>
                    @endif
                @endforeach
                </tbody>
            </table>
        @endif

        @if($is_charge)
            <div class="ChargesTitle clearfix">
                <div class="pull-left flip col-harf">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_ADDITIONAL")}}</div>
                <div class="text-right pull-right flip col-harf">{{$CurrencySymbol}}{{number_format($service['add_cost'],$RoundChargesAmount)}}</div>
            </div>

            <table border="0" cellspacing="0" cellpadding="0" id="backinvoice">
                <thead>
                <tr>
                    <th class="leftalign">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_TITLE")}}</th>
                    <th class="leftalign">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_DESCRIPTION")}}</th>
                    <th class="leftalign">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_DATE")}}</th>
                    <th class="rightalign leftsideview">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_PRICE")}}</th>
                    <th class="rightalign leftsideview">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_QUANTITY")}}</th>
                    <th class="rightalign leftsideview">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_DISCOUNT")}}</th>
                    <th class="rightalign leftsideview">{{cus_lang("TABLE_TOTAL")}}</th>
                </tr>
                </thead>
                <tbody>
                @foreach($InvoiceDetail as $ProductRow)
                    @if($ProductRow->ProductType == \App\Lib\Product::ONEOFFCHARGE && $ProductRow->ServiceID == $ServiceID)
                        <tr>
                            <td class="leftalign">{{\App\Lib\Product::getProductName($ProductRow->ProductID,$ProductRow->ProductType)}}</td>
                            <td class="leftalign">{{$ProductRow->Description}}</td>
                            <td class="leftalign">{{date($InvoiceTemplate->DateFormat,strtotime($ProductRow->StartDate))}}</td>
                            <td class="rightalign leftsideview">{{number_format($ProductRow->Price,$RoundChargesAmount)}}</td>
                            <td class="rightalign leftsideview">{{$ProductRow->Qty}}</td>
                            <td class="rightalign leftsideview">
                                @if(!empty($ProductRow->DiscountAmount) && !empty($ProductRow->DiscountType))
                                    {{number_format($ProductRow->DiscountAmount,$RoundChargesAmount)}}@if($ProductRow->DiscountType=='Percentage') % @endif
                                @endif
                            </td>
                            <td class="rightalign leftsideview">{{number_format($ProductRow->LineTotal,$RoundChargesAmount)}}</td>
                        </tr>
                    @endif
                @endforeach
                </tbody>
            </table>
        @endif
    </main>
    @endforeach

    <!-- service section end -->
	@if($InvoiceTemplate->InvoicePages == 'single_with_detail')
    @foreach($service_data as $ServiceID => $service)
        @if(isset($usage_data_table['data'][$ServiceID]) && count($usage_data_table['data'][$ServiceID]) > 0 && $InvoiceTemplate->CDRType != \App\Lib\Account::NO_CDR)

            <div class="page_break"></div>
            <br />
            <br />
            <header class="clearfix">
                @if(!empty($service['servicetitleshow']))
                    <div id="Service">
                        <h1>{{$service['name']}}</h1>
                        @if(!empty($service['servicedescription']))
                            {{nl2br($service['servicedescription'])}}
                        @endif
                    </div>
                @else
                    <div id="Service">
                        @if(!empty($service['servicedescription']))
                            <h2> {{nl2br($service['servicedescription'])}} </h2>
                        @endif
                    </div>
                @endif
            </header>

            @if($InvoiceTemplate->CDRType == \App\Lib\Account::SUMMARY_CDR)
            <main>
                <div class="ChargesTitle clearfix">
                    <div class="pull-left flip">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_LBL_USAGE")}}</div>
                </div>
                <table  border="0"  width="100%" cellpadding="0" cellspacing="0" id="backinvoice" class="bg_graycolor">
                    <tr>
                        @foreach($usage_data_table['header'] as $row)
                            <?php
                            $classname = 'centeralign';
                            if(in_array($row['Title'],array('AvgRatePerMin','ChargedAmount'))){
                                $classname = 'rightalign leftsideview';
                            }else if(in_array($row['Title'],array('Trunk','AreaPrefix','Country','Description'))){
                                $classname = 'leftalign';
                            }
                            ?>
                            <th class="{{$classname}}">{{$row['UsageName']}}</th>
                        @endforeach
                    </tr>
                    <?php
                    $totalCalls=0;
                    $totalDuration=0;
                    $totalBillDuration=0;
                    $totalTotalCharges=0;
                    ?>
                    @foreach($usage_data_table['data'][$ServiceID] as $row)
                        <?php
                        $totalCalls  += $row['NoOfCalls'];
                        $totalDuration  += $row['DurationInSec'];
                        $totalBillDuration  += $row['BillDurationInSec'];
						$totalTotalCharges  += str_replace(',','',$row['ChargedAmount']);
                        ?>
                        <tr>
                            @foreach($usage_data_table['header'] as $table_h_row)
                                <?php
                                $classname = 'centeralign';
                                if(in_array($table_h_row['Title'],array('AvgRatePerMin','ChargedAmount'))){
                                    $classname = 'rightalign leftsideview';
                                }else if(in_array($table_h_row['Title'],array('Trunk','AreaPrefix','Country','Description'))){
                                    $classname = 'leftalign';
                                }
                                ?>
                                @if($table_h_row['Title'] == 'ChargedAmount')
                                        <td class="{{$classname}}">{{$CurrencySymbol}}{{ \App\Lib\Invoice::NumberFormatNoZeroValue($row['ChargedAmount'],$RoundChargesCDR)}}</td>
                                @elseif($table_h_row['Title'] == 'AvgRatePerMin')
                                    <td class="{{$classname}}">{{$CurrencySymbol}}{{ $row['BillDurationInSec'] != 0? number_format($row['AvgRatePerMin'],$RoundChargesAmount) : 0}}</td>
                                @else
                                    <td class="{{$classname}}">{{$row[$table_h_row['Title']]}}</td>
                                @endif
                            @endforeach

                        </tr>
                    @endforeach
                    <?php
                    $totalDuration = intval($totalDuration / 60) .':' . ($totalDuration % 60);
                    $totalBillDuration = intval($totalBillDuration / 60) .':' . ($totalBillDuration % 60);
                    ?>
                    <tr>
                        <th class="rightalign" colspan="{{count($usage_data_table['header']) - 4}}"></th>
                        <th>{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_CALLS")}}</th>
                        <th>{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_DURATION")}}</th>
                        <th class="centeralign">{{str_replace(" ","<br>", cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_BILLED_DURATION"))}}</th>
                        <th class="centeralign">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_CHARGE")}}</th>
                    </tr>
                    <tr>
                        <th class="rightalign" colspan="{{count($usage_data_table['header']) - 4}}"><strong>{{cus_lang("TABLE_TOTAL")}}</strong></th>
                        <th>{{$totalCalls}}</th>
                        <th>{{$totalDuration}}</th>
                        <th class="centeralign">{{$totalBillDuration}}</th>
                        <th class="centeralign">{{$CurrencySymbol}}{{number_format($totalTotalCharges,$RoundChargesAmount)}}</th>
                    </tr>
                </table>
            </main>
            @endif

            @if($InvoiceTemplate->CDRType == \App\Lib\Account::DETAIL_CDR)
            <main>
            @foreach($CallTypeData as $key=>$Value)
                <div class="ChargesTitle clearfix">
                    @if($Value=='NoCallType')
                        <div class="pull-left flip">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_LBL_USAGE")}}</div>
                    @else
                        @if($Value=='OutBound')
                            <div class="pull-left flip">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_LBL_USAGE")}} - Outgoing</div>
                        @endif
                        @if($Value=='InBound')
                            <div class="pull-left flip">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_LBL_USAGE")}} - Incoming</div>
                        @endif
                    @endif
                </div>
                <table  border="0"  width="100%" cellpadding="0" cellspacing="0" id="backinvoice" class="bg_graycolor">
                    <tr>
                        @foreach($usage_data_table['header'] as $row)
                            <?php
                            $classname = 'centeralign';
                            if(in_array($row['Title'],array('ChargedAmount'))){
                                $classname = 'rightalign leftsideview';
                            }else if(in_array($row['Title'],array('CLI','Prefix','CLD','ConnectTime','DisconnectTime'))){
                                $classname = 'leftalign';
                            }
                            ?>
                            <th class="{{$classname}}">{{$row['UsageName']}}</th>
                        @endforeach
                    </tr>
                    <?php
                        $totalBillDuration=0;
                        $totalTotalCharges=0;
                        $CallTypeColumn='';
                        if($Value=='InBound'){
                            $CallTypeColumn='Incoming';
                        }
                        if($Value=='OutBound'){
                            $CallTypeColumn='Outgoing';
                        }
                    ?>
                    @foreach($usage_data_table['data'][$ServiceID] as $row)
                    @if($row['CallType']==$CallTypeColumn || $DisplayCallType==0)
                        <?php
                        $totalBillDuration  +=  $row['BillDuration'];
						$totalTotalCharges  += str_replace(',','',$row['ChargedAmount']);
                        ?>
                        <tr>
                            @foreach($usage_data_table['header'] as $table_h_row)
                                <?php
                                $classname = 'centeralign';
                                if(in_array($table_h_row['Title'],array('ChargedAmount'))){
                                    $classname = 'rightalign leftsideview';
                                }else if(in_array($table_h_row['Title'],array('CLI','Prefix','CLD','ConnectTime','DisconnectTime'))){
                                    $classname = 'leftalign';
                                }
                                ?>
                                @if($table_h_row['Title'] == 'ChargedAmount')
                                    <td class="{{$classname}}">{{$CurrencySymbol}}{{ \App\Lib\Invoice::NumberFormatNoZeroValue($row['ChargedAmount'],$RoundChargesCDR)}}</td>
                                @elseif($table_h_row['Title'] == 'CLI' || $table_h_row['Title'] == 'CLD')
                                    <td class="{{$classname}}">{{substr($row[$table_h_row['Title']],1)}}</td>
                                @else
                                    <td class="{{$classname}}">{{$row[$table_h_row['Title']]}}</td>
                                @endif
                            @endforeach
                        </tr>
                    @endif
                    @endforeach
                    <tr>
                        <th class="rightalign" colspan="{{count($usage_data_table['header']) - 2}}"></th>
                        <th class="centeralign">{{str_replace(" ","<br>", cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_BILLED_DURATION"))}}</th>
                        <th class="centeralign">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_CHARGE")}}</th>
                    </tr>
                    <tr>
                        <th class="rightalign" colspan="{{count($usage_data_table['header']) - 2}}"><strong>{{cus_lang("TABLE_TOTAL")}}</strong></th>
                        <th class="centeralign">{{$totalBillDuration}}</th>
                        <th class="centeralign">{{$CurrencySymbol}}{{number_format($totalTotalCharges,$RoundChargesAmount)}}</th>
                    </tr>
                </table>
            @endforeach
            </main>
            @endif
        @endif
    @endforeach
	@endif
    @if(!empty($InvoiceTemplate->ShowPaymentWidgetInvoice) || count($AllTaxSummary)>0 )
        <div class="page_break"></div>
        @if(count($AllTaxSummary)>0)
        <div class="ChargesTitle clearfix">
            <div class="pull-left flip col-harf">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_TAXE_SUMMARY")}}</div>
        </div>

        <table border="0" cellspacing="0" cellpadding="0" id="backinvoice">
            <thead>
            <tr>
                <th class="leftalign">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_TITLE")}}</th>
                <th class="leftalign">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_AMOUNT")}}</th>
            </tr>
            </thead>
            <tbody>
            @foreach($AllTaxSummary as $row)
                <tr>
                    <td class="leftalign">{{$row['Title']}}</td>
                    <td class="leftalign">{{$CurrencySymbol}}{{number_format($row['Amount'],$RoundChargesAmount)}}</td>
                </tr>
            @endforeach
            <tr>
                <td class="leftalign total">{{cus_lang("TABLE_TOTAL")}}</td>
                <td class="leftalign total">{{$CurrencySymbol}}{{number_format($AllTaxCount,$RoundChargesAmount)}}</td>
            </tr>
            </tbody>
        </table>
        @endif
        @if(!empty($InvoiceTemplate->ShowPaymentWidgetInvoice) && !empty($payment_data) && count($payment_data)>0)
            <div class="ChargesTitle clearfix">
                <div class="pull-left flip col-harf">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_PAYMENT")}}</div>
            </div>

            <table border="0" cellspacing="0" cellpadding="0" id="backinvoice">
                <thead>
                <tr>
                    <th class="leftalign">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_DATE")}}</th>
                    <th class="leftalign">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_AMOUNT")}}</th>
                    <th class="leftalign">{{cus_lang("CUST_PANEL_PAGE_INVOICE_PDF_TBL_NOTES")}}</th>
                </tr>
                </thead>
                <tbody>
                @foreach($payment_data as $row)
                    <?php
                    $AllPayment  += str_replace(',','',$row['Amount']);
                    ?>
                    <tr>
                        <td class="leftalign">{{date($InvoiceTemplate->DateFormat,strtotime($row['PaymentDate']))}}</td>
                        <td class="leftalign">{{$CurrencySymbol}}{{number_format($row['Amount'],$RoundChargesAmount)}}</td>
                        <td class="leftalign">{{$row['Notes']}}</td>
                    </tr>
                @endforeach
                <tr>
                    <td class="leftalign total">{{cus_lang("TABLE_TOTAL")}}</td>
                    <td class="leftalign total" colspan="2">{{$CurrencySymbol}}{{number_format($AllPayment,$RoundChargesAmount)}}</td>
                </tr>
                </tbody>
            </table>
        @endif

    @endif
    @if(!empty($ManagementReports) && $total_usage != 0)
        <div class="page_break"></div>
        @include('emails.invoices.management_chart')
    @endif

 @stop