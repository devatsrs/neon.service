@extends('layout.print')

@section('content')
    <link rel="stylesheet" type="text/css" href="{{base_path().'/resources/assets/invoicetemplate/invoicestyle.css'}}" />
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
</style>
<div class="inovicebody">
    <!-- logo and invoice from section start-->
    <header class="clearfix">
        <div id="logo">
            @if(!empty($logo))
                <img src="{{get_image_data($logo)}}" style="max-width: 250px">
            @endif
        </div>
        <div id="company">
            <h2 class="name"><b>Invoice From</b></h2>
            <div>{{ nl2br($InvoiceTemplate->Header)}}</div>
        </div>
    </header>
    <!-- logo and invoice from section end-->

    <!-- need to change with new logic -->

    <?php
    $InvoiceTo =$InvoiceFrom = '';
    $is_sub = $is_charge = false;
    $total_usage= $total_sub = $total_add = 0;
    foreach($InvoiceDetail as $ProductRow){
        if($ProductRow->ProductType == \App\Lib\Product::USAGE){
            $total_usage += $ProductRow->LineTotal;
        }
        if($ProductRow->ProductType == \App\Lib\Product::INVOICE_PERIOD){
            $InvoiceFrom = date('F d,Y',strtotime($ProductRow->StartDate));
            $InvoiceTo = date('F d,Y',strtotime($ProductRow->EndDate));
        }
        if($ProductRow->ProductType == \App\Lib\Product::SUBSCRIPTION){
            $total_sub += $ProductRow->LineTotal;
            $is_sub = true;
        }
        if($ProductRow->ProductType == \App\Lib\Product::ONEOFFCHARGE){
            $total_add += $ProductRow->LineTotal;
            $is_charge = true;
        }
    }


    $message = $InvoiceTemplate->InvoiceTo;

    $replace_array = \App\Lib\Invoice::create_accountdetails($Account);
    $text = \App\Lib\Invoice::getInvoiceToByAccount($message,$replace_array);
    $return_message = preg_replace("/(^[\r\n]*|[\r\n]+)[\s\t]*[\r\n]+/", "\n", $text);

    ?>



    <main>
        <div id="details" class="clearfix">
            <div id="client">
                <div class="to"><b>Invoice To:</b></div>
                <div>{{nl2br($return_message)}}</div>
            </div>
            <div id="invoice">
                <h1>Invoice No: {{$Invoice->FullInvoiceNumber}}</h1>
                <div class="date">Invoice Date: {{ date($InvoiceTemplate->DateFormat,strtotime($Invoice->IssueDate))}}</div>
                <div class="date">Due Date: {{date($InvoiceTemplate->DateFormat,strtotime($Invoice->IssueDate.' +'.$PaymentDueInDays.' days'))}}</div>
                @if($InvoiceTemplate->ShowBillingPeriod == 1)
                    <div class="date">Invoice Period: {{$InvoiceFrom}} - {{$InvoiceTo}}</div>
                @endif
            </div>
        </div>

        <!-- content of front page section start -->

        <table border="0" cellspacing="0" cellpadding="0" id="frontinvoice">
            <thead>


            <?php $VisibleColumns = (array)json_decode($InvoiceTemplate->VisibleColumns); $colspan = 0; ?>
            <tr>
                @if(!empty($VisibleColumns))
                    @if(isset($VisibleColumns['Description']) && $VisibleColumns['Description'] == 1 && !empty($InvoiceTemplate->ItemDescription))
                        <?php $colspan++; ?>
                        <th class="desc"><b>Description</b></th>
                    @endif
                    @if(isset($VisibleColumns['Usage']) && $VisibleColumns['Usage'] == 1)
                        <?php $colspan++; ?>
                        <th class="desc"><b>Usage</b></th>
                    @endif
                    @if(isset($VisibleColumns['Recurring']) && $VisibleColumns['Recurring'] == 1)
                        <?php $colspan++; ?>
                        <th class="desc"><b>Recurring</b></th>
                    @endif
                    @if(isset($VisibleColumns['Additional']) && $VisibleColumns['Additional'] == 1)
                        <?php $colspan++; ?>
                        <th class="desc"><b>Additional</b></th>
                    @endif
                    @if($colspan == 0)
                        <th class="desc"></th>
                    @endif
                        <th class="total"><b>Total</b></th>
                @else
                    <?php $colspan = 2; ?>
                    <th class="desc"><b>Usage</b></th>
                    <th class="desc"><b>Recurring</b></th>
                    <th class="desc"><b>Additional</b></th>
                    <th class="total"><b>Total</b></th>
                @endif
            </tr>
            </thead>
            <tbody>

            <tr>
                @if(!empty($VisibleColumns))
                    @if(isset($VisibleColumns['Description']) && $VisibleColumns['Description'] == 1 && !empty($InvoiceTemplate->ItemDescription))
                        <td class="desc">{{$InvoiceTemplate->ItemDescription}}</td>
                    @endif
                    @if(isset($VisibleColumns['Usage']) && $VisibleColumns['Usage'] == 1)
                        <td class="desc">{{$CurrencySymbol}}{{number_format($total_usage,$RoundChargesAmount)}}</td>
                    @endif
                    @if(isset($VisibleColumns['Recurring']) && $VisibleColumns['Recurring'] == 1)
                        <td class="desc">{{$CurrencySymbol}}{{number_format($total_sub,$RoundChargesAmount)}}</td>
                    @endif
                    @if(isset($VisibleColumns['Additional']) && $VisibleColumns['Additional'] == 1)
                        <td class="desc">{{$CurrencySymbol}}{{number_format($total_add,$RoundChargesAmount)}}</td>
                    @endif
                    @if($colspan == 0)
                        <td class="desc"></td>
                    @endif
                        <td class="total">{{$CurrencySymbol}}{{number_format($total_usage+$total_sub+$total_add,$RoundChargesAmount)}}</td>
                @else
                    <td class="desc">{{$CurrencySymbol}}{{number_format($total_usage,$RoundChargesAmount)}}</td>
                    <td class="desc">{{$CurrencySymbol}}{{number_format($total_sub,$RoundChargesAmount)}}</td>
                    <td class="desc">{{$CurrencySymbol}}{{number_format($total_add,$RoundChargesAmount)}}</td>
                    <td class="total">{{$CurrencySymbol}}{{number_format($total_usage+$total_sub+$total_add,$RoundChargesAmount)}}</td>
                @endif
            </tr>



            </tbody>
            <tfoot>
            <?php $colspan--; ?>
            <tr>
                @if(!empty($VisibleColumns))
                    @if($colspan > 0)
                        <td colspan="{{$colspan}}"></td>
                    @endif
                @else
                    <td colspan="2"></td>
                @endif
                <td>Sub Total</td>
                <td class="subtotal">{{$CurrencySymbol}}{{number_format($Invoice->SubTotal,$RoundChargesAmount)}}</td>
            </tr>
            @if(count($InvoiceTaxRates))
                @foreach($InvoiceTaxRates as $InvoiceTaxRate)
                <tr>
                    @if(!empty($VisibleColumns))
                        @if($colspan > 0)
                            <td colspan="{{$colspan}}"></td>
                        @endif
                    @else
                        <td colspan="2"></td>
                    @endif
                    <td>{{$InvoiceTaxRate->Title}}</td>
                    <td class="subtotal">{{$CurrencySymbol}}{{number_format($InvoiceTaxRate->TaxAmount,$RoundChargesAmount)}}</td>
                </tr>
                @endforeach
            @endif
            @if($Invoice->TotalDiscount > 0)
                <tr>
                    @if(!empty($VisibleColumns))
                        @if($colspan > 0)
                            <td colspan="{{$colspan}}"></td>
                        @endif
                    @else
                        <td colspan="2"></td>
                    @endif
                    <td>Discount</td>
                    <td class="subtotal">{{$CurrencySymbol}}{{number_format($Invoice->TotalDiscount,$RoundChargesAmount)}}</td>
                </tr>
            @endif
            @if($InvoiceTemplate->ShowPrevBal)
                <tr>
                    @if(!empty($VisibleColumns))
                        @if($colspan > 0)
                            <td colspan="{{$colspan}}"></td>
                        @endif
                    @else
                        <td colspan="2"></td>
                    @endif
                    <td>Brought Forward</td>
                    <td class="subtotal">{{$CurrencySymbol}}{{number_format($Invoice->PreviousBalance,$RoundChargesAmount)}}</td>
                </tr>
            @endif
            <tr>
                @if(!empty($VisibleColumns))
                    @if($colspan > 0)
                        <td colspan="{{$colspan}}"></td>
                    @endif
                @else
                    <td colspan="2"></td>
                @endif
                <td>
					@if(!$InvoiceTemplate->ShowPrevBal)
						<b>
					@endif
					
					Grand Total
					
					@if(!$InvoiceTemplate->ShowPrevBal)
						</b>				
					@endif
				</td>
                <td class="subtotal">
                    @if(!$InvoiceTemplate->ShowPrevBal)
                        <b>
                    @endif

                    {{$CurrencySymbol}}{{number_format($Invoice->GrandTotal,$RoundChargesAmount)}}

                    @if(!$InvoiceTemplate->ShowPrevBal)
                        </b>
                    @endif
                </td>
            </tr>
            @if($InvoiceTemplate->ShowPrevBal)
                <tr>
                    @if(!empty($VisibleColumns))
                        @if($colspan > 0)
                            <td colspan="{{$colspan}}"></td>
                        @endif
                    @else
                        <td colspan="2"></td>
                    @endif
                    <td><b>Total Due</b></td>
                    <td class="subtotal"><b>{{$CurrencySymbol}}{{number_format($Invoice->TotalDue,$RoundChargesAmount)}}</b></td>
                </tr>
            @endif
            </tfoot>
        </table>
        <!-- content of front page section end -->
    </main>

    <!-- adevrtisement and terms section start-->
    <div id="thanksadevertise">
        <div class="invoice-left">
            <p><a class="form-control" style="height: auto">{{nl2br($Invoice->Terms)}}</a></p>
        </div>
    </div>
    <!-- adevrtisement and terms section end -->



    @if($total_usage != 0 || $is_sub || $is_charge)
    <div class="page_break"> </div>
    <br/>
    @endif

    <main>
        @if($total_usage != 0)
        <div class="ChargesTitle clearfix">
            <div style="float:left;">Usage</div>
            <div style="text-align:right;float:right;">{{$CurrencySymbol}}{{number_format($total_usage,$RoundChargesAmount)}}</div>
        </div>
        <table border="0" cellspacing="0" cellpadding="0" id="backinvoice">
            <thead>
            <tr>
                <th class="leftalign">Title</th>
                <th class="leftalign">Description</th>
                <th class="rightalign">Price</th>
                <th class="rightalign">Qty</th>
                <th class="leftalign">Date From</th>
                <th class="leftalign">Date To</th>
                <th class="rightalign">Total</th>
            </tr>
            </thead>
            <tbody>
            @foreach($InvoiceDetail as $ProductRow)
                @if($ProductRow->ProductType == \App\Lib\Product::USAGE)
                    <tr>
                        <td class="leftalign">{{\App\Lib\Product::getProductName($ProductRow->ProductID,$ProductRow->ProductType)}}</td>
                        <td class="leftalign">{{$ProductRow->Description}}</td>
                        <td class="rightalign">{{number_format($total_usage,$RoundChargesAmount)}}</td>
                        <td class="rightalign">{{$ProductRow->Qty}}</td>
                        <td class="leftalign">{{date($InvoiceTemplate->DateFormat,strtotime($ProductRow->StartDate))}}</td>
                        <td class="leftalign">{{date($InvoiceTemplate->DateFormat,strtotime($ProductRow->EndDate))}}</td>
                        <td class="rightalign">{{number_format($total_usage,$RoundChargesAmount)}}</td>
                    </tr>
                @endif
            @endforeach
            </tbody>
        </table>
        @endif

        @if($is_sub)
            <div class="ChargesTitle clearfix">
                <div style="float:left;">Recurring</div>
                <div style="text-align:right;float:right;">{{$CurrencySymbol}}{{number_format($total_sub,$RoundChargesAmount)}}</div>
            </div>

            <table border="0" cellspacing="0" cellpadding="0" id="backinvoice">
                <thead>
                <tr>
                    <th class="leftalign">Title</th>
                    <th class="leftalign">Description</th>
                    <th class="rightalign">Price</th>
                    <th class="rightalign">Qty</th>
                    <th class="leftalign">Date From</th>
                    <th class="leftalign">Date To</th>
                    <th class="rightalign">Total</th>
                </tr>
                </thead>
                <tbody>
                @foreach($InvoiceDetail as $ProductRow)
                    @if($ProductRow->ProductType == \App\Lib\Product::SUBSCRIPTION)
                        <tr>
                            <td class="leftalign">{{\App\Lib\Product::getProductName($ProductRow->ProductID,$ProductRow->ProductType)}}</td>
                            <td class="leftalign">{{$ProductRow->Description}}</td>
                            <td class="rightalign">{{number_format($ProductRow->Price,$RoundChargesAmount)}}</td>
                            <td class="rightalign">{{$ProductRow->Qty}}</td>
                            <td class="leftalign">{{date($InvoiceTemplate->DateFormat,strtotime($ProductRow->StartDate))}}</td>
                            <td class="leftalign">{{date($InvoiceTemplate->DateFormat,strtotime($ProductRow->EndDate))}}</td>
                            <td class="rightalign">{{number_format($ProductRow->LineTotal,$RoundChargesAmount)}}</td>
                        </tr>
                    @endif
                @endforeach
                </tbody>
            </table>
        @endif

        @if($is_charge)
            <div class="ChargesTitle clearfix">
                <div style="float:left;">Additional</div>
                <div style="text-align:right;float:right;">{{$CurrencySymbol}}{{number_format($total_add,$RoundChargesAmount)}}</div>
            </div>

            <table border="0" cellspacing="0" cellpadding="0" id="backinvoice">
                <thead>
                <tr>
                    <th class="leftalign">Title</th>
                    <th class="leftalign">Description</th>
                    <th class="rightalign">Price</th>
                    <th class="rightalign">Qty</th>
                    <th class="leftalign">Date</th>
                    <th class="rightalign">Total</th>
                </tr>
                </thead>
                <tbody>
                @foreach($InvoiceDetail as $ProductRow)
                    @if($ProductRow->ProductType == \App\Lib\Product::ONEOFFCHARGE)
                        <tr>
                            <td class="leftalign">{{\App\Lib\Product::getProductName($ProductRow->ProductID,$ProductRow->ProductType)}}</td>
                            <td class="leftalign">{{$ProductRow->Description}}</td>
                            <td class="rightalign">{{number_format($ProductRow->Price,$RoundChargesAmount)}}</td>
                            <td class="rightalign">{{$ProductRow->Qty}}</td>
                            <td class="leftalign">{{date($InvoiceTemplate->DateFormat,strtotime($ProductRow->StartDate))}}</td>
                            <td class="rightalign">{{number_format($ProductRow->LineTotal,$RoundChargesAmount)}}</td>
                        </tr>
                    @endif
                @endforeach
                </tbody>
            </table>
        @endif
    </main>


		@if($InvoiceTemplate->InvoicePages == 'single_with_detail')

        @if(isset($usage_data_table['data']) && count($usage_data_table['data']) > 0 && $InvoiceTemplate->CDRType != \App\Lib\Account::NO_CDR)

            <div class="page_break"></div>
            <br />
            <br />



                <main>
                    <div class="ChargesTitle clearfix">
                        <div style="float:left;">Usage</div>
                    </div>

            @if($InvoiceTemplate->CDRType == \App\Lib\Account::SUMMARY_CDR)
                <table  border="0"  width="100%" cellpadding="0" cellspacing="0" id="backinvoice" class="bg_graycolor">
                    <tr>
                        @foreach($usage_data_table['header'] as $row)
                            <?php
                            $classname = 'centeralign';
                            if(in_array($row['Title'],array('AvgRatePerMin','ChargedAmount'))){
                                $classname = 'rightalign';
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


                            @foreach($usage_data_table['data'] as $ServiceID => $usage_data)
							@foreach($usage_data as $row)
                                <?php
                                $totalCalls  += $row['NoOfCalls'];
                                $totalDuration  += $row['DurationInSec'];
                                $totalBillDuration  += $row['BillDurationInSec'];
                                $totalTotalCharges  += $row['ChargedAmount'];
                                ?>
                                <tr>
                                    @foreach($usage_data_table['header'] as $table_h_row)
                                        <?php
                                        $classname = 'centeralign';
                                        if(in_array($table_h_row['Title'],array('AvgRatePerMin','ChargedAmount'))){
                                            $classname = 'rightalign';
                                        }else if(in_array($table_h_row['Title'],array('Trunk','AreaPrefix','Country','Description'))){
                                            $classname = 'leftalign';
                                        }
                                        ?>
                                        @if($table_h_row['Title'] == 'ChargedAmount')
                                            <td class="{{$classname}}">{{$CurrencySymbol}}{{ number_format($row['ChargedAmount'],$RoundChargesAmount)}}</td>
                                        @elseif($table_h_row['Title'] == 'AvgRatePerMin')
											<td class="{{$classname}}">{{$CurrencySymbol}}{{ $row['BillDurationInSec'] != 0? number_format(($row['ChargedAmount']/$row['BillDurationInSec'])*60,$RoundChargesAmount) : 0}}</td>
                                        @else
                                            <td class="{{$classname}}">{{$row[$table_h_row['Title']]}}</td>
                                        @endif
                                    @endforeach

                                </tr>
                            @endforeach
							@endforeach


                    <?php
                    $totalDuration = intval($totalDuration / 60) .':' . ($totalDuration % 60);
                    $totalBillDuration = intval($totalBillDuration / 60) .':' . ($totalBillDuration % 60);
                    ?>
                    <tr>
                        <th class="rightalign" colspan="{{count($usage_data_table['header']) - 4}}"></th>
                        <th>Calls</th>
                        <th>Duration</th>
                        <th class="centeralign">Billed <br> Duration</th>
                        <th class="centeralign">Charge</th>
                    </tr>
                    <tr>
                        <th class="rightalign" colspan="{{count($usage_data_table['header']) - 4}}"><strong>Total</strong></th>
                        <th>{{$totalCalls}}</th>
                        <th>{{$totalDuration}}</th>
                        <th class="centeralign">{{$totalBillDuration}}</th>
                        <th class="centeralign">{{$CurrencySymbol}}{{number_format($totalTotalCharges,$RoundChargesAmount)}}</th>
                    </tr>
                </table>
            @endif


            @if($InvoiceTemplate->CDRType == \App\Lib\Account::DETAIL_CDR)
                <table  border="0"  width="100%" cellpadding="0" cellspacing="0" id="backinvoice" class="bg_graycolor">
                    <tr>
                        @foreach($usage_data_table['header'] as $row)
                            <?php
                                $classname = 'centeralign';
                            if(in_array($row['Title'],array('ChargedAmount'))){
                                $classname = 'rightalign';
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
                    ?>


                            @foreach($usage_data_table['data'] as $ServiceID => $usage_data)
							@foreach($usage_data as $row)
                                <?php
                                $totalBillDuration  +=  $row['BillDuration'];
                                $totalTotalCharges  += $row['ChargedAmount'];
                                ?>
                                <tr>
                                    @foreach($usage_data_table['header'] as $table_h_row)
                                        <?php
                                        $classname = 'centeralign';
                                        if(in_array($table_h_row['Title'],array('ChargedAmount'))){
                                            $classname = 'rightalign';
                                        }else if(in_array($table_h_row['Title'],array('CLI','Prefix','CLD','ConnectTime','DisconnectTime'))){
                                            $classname = 'leftalign';
                                        }
                                        ?>
                                        @if($table_h_row['Title'] == 'ChargedAmount')
                                            <td class="{{$classname}}">{{$CurrencySymbol}}{{ number_format($row['ChargedAmount'],$RoundChargesAmount)}}</td>
                                        @elseif($table_h_row['Title'] == 'CLI' || $table_h_row['Title'] == 'CLD')
                                            <td class="{{$classname}}">{{substr($row[$table_h_row['Title']],1)}}</td>
                                        @else
                                            <td class="{{$classname}}">{{$row[$table_h_row['Title']]}}</td>
                                        @endif
                                    @endforeach
                                </tr>
                            @endforeach
							@endforeach


                    <tr>
                        <th class="rightalign" colspan="{{count($usage_data_table['header']) - 2}}"></th>
                        <th class="centeralign">Billed <br> Duration</th>
                        <th class="centeralign">Charge</th>
                    </tr>
                    <tr>
                        <th class="rightalign" colspan="{{count($usage_data_table['header']) - 2}}"><strong>Total</strong></th>
                        <th class="centeralign">{{$totalBillDuration}}</th>
                        <th class="centeralign">{{$CurrencySymbol}}{{number_format($totalTotalCharges,$RoundChargesAmount)}}</th>
                    </tr>
                </table>
            @endif
                </main>


        @endif
		@endif

        @if(!empty($ManagementReports) && $total_usage != 0)
            <div class="page_break"></div>
            @include('emails.invoices.management_chart')
        @endif

 @stop