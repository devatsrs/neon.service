@extends('layout.print')

@section('content')
<style>
*{
    font-family: Arial;
    font-size: 10px;
    line-height: normal;
}
p{ line-height: 20px;}
.text-small p{line-height: 10px;}
.text-left{ text-align: left}
.text-right{ text-align: right}
.text-center{ text-align: center}
table.invoice th{ padding:3px; background-color: #f5f5f6}
.bg_graycolor{background-color: #f5f5f6}
table.invoice td , table.invoice_total td{ padding:3px;}
.page_break{ padding: 10px 0; page-break-after: always;}
@media print {
    * {
        background-color: auto !important;
        background: auto !important;
        color: auto !important;
    }
    th,td{ padding: 1px; margin: 1px;}
}
table{
  width: 100%;
  border-spacing: 0;
  margin-bottom: 20px;
}

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
<br/>
        <table border="0" width="100%" cellpadding="0" cellspacing="0">
            <tr>
                <td class="col-md-6" valign="top">
                    @if(!empty($logo))
                   <img src="{{get_image_data($logo)}}" style="max-width: 250px">
                   @endif
                </td>
                <td class="col-md-6 text-right" valign="top">
                    <br>
                   <strong>Invoice From:</strong>
                   <p><strong>{{ nl2br($InvoiceTemplate->Header)}}</strong></p>

                </td>
            </tr>
        </table>
        <br />

        <table border="0" width="100%" cellpadding="0" cellspacing="0">
            <tr>
                <td class="col-md-6 text-small"  valign="top" >
                        <strong>Invoice To</strong>
                        <p>{{$Account->AccountName}}<br>
                        {{nl2br($Invoice->Address)}}</p>
                </td>
                <td class="col-md-6 text-right text-small"  valign="top" >
                        <p><b>Invoice No: </b>{{$Invoice->FullInvoiceNumber}}<br>
                        <b>Invoice Date: </b>{{ date($InvoiceTemplate->DateFormat,strtotime($Invoice->IssueDate))}}<br>
                        <b>Due Date: </b>{{date($InvoiceTemplate->DateFormat,strtotime($Invoice->IssueDate.' +'.$PaymentDueInDays.' days'))}}</p>
                </td>
            </tr>
        </table>

        <?php
        $InvoiceTo =$InvoiceFrom = '';
        $is_sub = $is_charge = false;
        $subscriptiontotal = $chargetotal =$useagetotal= 0;
        $subscriptionarray= array();
            foreach($InvoiceDetail as $ProductRow){
                if($ProductRow->ProductType == \App\Lib\Product::SUBSCRIPTION){
                    $subscriptiontotal += $ProductRow->LineTotal;
                    $is_sub = true;
                }
                if($ProductRow->ProductType == \App\Lib\Product::ONEOFFCHARGE){
                    $chargetotal += $ProductRow->LineTotal;
                    $is_charge = true;
                }
                if($ProductRow->ProductType == \App\Lib\Product::USAGE){
                    $useagetotal += $ProductRow->LineTotal;
                    $InvoiceFrom = date('F d,Y',strtotime($ProductRow->StartDate));
                    $InvoiceTo = date('F d,Y',strtotime($ProductRow->EndDate));
                }
            }

        ?>
        @if(($InvoiceTemplate->ShowBillingPeriod == 1) || ($InvoiceTemplate->ShowPrevBal))
        <table width="100%" border="0">
            <tbody>
            <tr>
                <td width="40%">
					@if($InvoiceTemplate->ShowBillingPeriod == 1)
                    <table border="1"  width="100%" cellpadding="0" cellspacing="0" class="invoice table table-bordered">
                        <thead>
                        <tr>
                            <th colspan="2" style="text-align: center;">Invoice Period</th>
                        </tr>
                        <tr>
                            <th style="text-align: center;">From</th>
                            <th style="text-align: center;">To</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td class="text-center">{{$InvoiceFrom}}</td>
                            <td class="text-center">{{$InvoiceTo}}</td>
                        </tr>
                        </tbody>
                    </table>
					@endif
					</td>
                <td width="25%"></td>
                <td width="35%">
                    @if($InvoiceTemplate->ShowPrevBal)
                    <table class="table table-bordered" style="width: 100%; text-align: right;">
                        <tbody>
                        <tr>
                            <td style="border-top: 1px solid black;text-align: left;">Previous Balance</td>
                            <td style="border-top: 1px solid black; text-align: right;">{{$CurrencySymbol}}{{number_format($Invoice->PreviousBalance,$RoundChargesAmount)}}</td>
                        </tr>
                        <tr>
                            <td style="border-top: 1px solid black;text-align: left;">Charges for this period</td>
                            <td style="border-top: 1px solid black; text-align: right;">{{$CurrencySymbol}}{{number_format($Invoice->GrandTotal,$RoundChargesAmount)}}</td>
                        </tr>
                        <tr>
                            <td style="border-top: 2px solid black;text-align: left;">Total Due</td>
                            <td style="border-top: 2px solid black; text-align: right;">{{$CurrencySymbol}}{{number_format($Invoice->TotalDue,$RoundChargesAmount)}}</td>
                        </tr>
                        </tbody>
                    </table>
                    @endif
                    </td>
            </tr>
            </tbody>
        </table>
		@endif
<div class="row">
    <div class="col-md-12">
        <table  border="1"  width="100%" cellpadding="0" cellspacing="0" class="bg_graycolor invoice_total col-md-12 table table-bordered">
            <tfoot>
                <tr>
                        <td class="text-left" ><strong>Usage</strong></td>
                        <td class="text-right">{{number_format($useagetotal,$RoundChargesAmount)}}</td>
                </tr>
                @if($is_sub == true)
                <tr>
                        <td class="text-left"><strong>Subscription</strong></td>
                        <td class="text-right">{{number_format($subscriptiontotal,$RoundChargesAmount)}}</td>
                </tr>
                @endif

                 @if($is_charge == true)
                <tr>
                        <td class="text-left"><strong>Additional Charges</strong></td>
                        <td class="text-right">{{number_format($chargetotal,$RoundChargesAmount)}}</td>
                </tr>
                @endif
            </tfoot>
        </table>
    </div>
</div>

    <div class="row">
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-body">
                        <div class="table-responsive">
                                <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="col-md-5" valign="top" width="55%">
                                                <p><a class="form-control" style="height: auto">{{nl2br($Invoice->Terms)}}</a></p>
                                        </td>
                                        <td class="col-md-6"  valign="top" width="35%" >
                                                <table  border="1"  width="100%" cellpadding="0" cellspacing="0" class="bg_graycolor invoice_total col-md-12 table table-bordered">
                                                    <tfoot>
                                                        <tr>
                                                            <td class="text-right"><strong>SubTotal</strong></td>
                                                            <td class="text-right">{{$CurrencySymbol}}{{number_format($Invoice->SubTotal,$RoundChargesAmount)}}</td>
                                                        </tr>
                                                        @if(count($InvoiceTaxRates))
                                                        @foreach($InvoiceTaxRates as $InvoiceTaxRate)
                                                        <tr>
                                                                <td class="text-right"><strong>{{$InvoiceTaxRate->Title}}</strong></td>
                                                                <td class="text-right">{{$CurrencySymbol}}{{number_format($InvoiceTaxRate->TaxAmount,$RoundChargesAmount)}}</td>
                                                        </tr>
                                                        @endforeach
                                                        @endif
                                                        @if($Invoice->TotalDiscount > 0)
                                                        <tr>
                                                                <td class="text-right"><strong>Discount</strong></td>
                                                                <td class="text-right">{{$CurrencySymbol}}{{number_format($Invoice->TotalDiscount,$RoundChargesAmount)}}</td>
                                                        </tr>
                                                        @endif
                                                        <tr>
                                                                <td class="text-right"><strong>Invoice Total</strong></td>
                                                                <td class="text-right">{{$CurrencySymbol}}{{number_format($Invoice->GrandTotal,$RoundChargesAmount)}} </td>
                                                        </tr>
                                                    </tfoot>
                                                </table>
                                        </td>
                                    </tr>
                                </table>
                                </br>
                                </br>
                                </br>
                        </div>
                    </div>
                </div>
            </div>
        </div>
<div class="page_break"> </div>
<br/><br/><br/>
<h5>Usage Charges</h5>
<table border="1"  width="100%" cellpadding="0" cellspacing="0" class="invoice col-md-12 table table-bordered">
        <thead>
        <tr>
            <th style="text-align: center;">Title</th>
            <th style="text-align: left;">Description</th>
            <th style="text-align: center;">Price</th>
            <th style="text-align: center;">Quantity</th>
            <th style="text-align: center;">Date From</th>
            <th style="text-align: center;">Date To</th>
            <th style="text-align: center;">Line Total</th>
        </tr>
        </thead>
        <tbody>
        @foreach($InvoiceDetail as $ProductRow)
        @if($ProductRow->ProductType == \App\Lib\Product::USAGE)
        <tr>
            <td class="text-center">{{\App\Lib\Product::getProductName($ProductRow->ProductID,$ProductRow->ProductType)}}</td>
            <td class="text-left">{{$ProductRow->Description}}</td>
            <td class="text-center">{{number_format($ProductRow->Price,$RoundChargesAmount)}}</td>
            <td class="text-center">{{$ProductRow->Qty}}</td>
            <td class="text-center">{{date($InvoiceTemplate->DateFormat,strtotime($ProductRow->StartDate))}}</td>
            <td class="text-center">{{date($InvoiceTemplate->DateFormat,strtotime($ProductRow->EndDate))}}</td>
            <td class="text-center">{{number_format($ProductRow->LineTotal,$RoundChargesAmount)}}</td>
        </tr>
        @endif
        @endforeach
        </tbody>
    </table>
    @if($is_sub == true)
    <br />
    <h5>Subscription Charges</h5>
    <table border="1"  width="100%" cellpadding="0" cellspacing="0" class="invoice col-md-12 table table-bordered">
            <thead>
            <tr>
                <th style="text-align: center;">Title</th>
                <th style="text-align: left;">Description</th>
                <th style="text-align: center;">Price</th>
                <th style="text-align: center;">Quantity</th>
                <th style="text-align: center;">Date From</th>
                <th style="text-align: center;">Date To</th>
                <th style="text-align: center;">Line Total</th>
            </tr>
            </thead>
            <tbody>
            @foreach($InvoiceDetail as $ProductRow)
            @if($ProductRow->ProductType == \App\Lib\Product::SUBSCRIPTION)
            <tr>
                <td class="text-center">{{\App\Lib\Product::getProductName($ProductRow->ProductID,$ProductRow->ProductType)}}</td>
                <td class="text-left">{{$ProductRow->Description}}</td>
                <td class="text-center">{{number_format($ProductRow->Price,$RoundChargesAmount)}}</td>
                <td class="text-center">{{$ProductRow->Qty}}</td>
                <td class="text-center">{{date($InvoiceTemplate->DateFormat,strtotime($ProductRow->StartDate))}}</td>
                <td class="text-center">{{date($InvoiceTemplate->DateFormat,strtotime($ProductRow->EndDate))}}</td>
                <td class="text-center">{{number_format($ProductRow->LineTotal,$RoundChargesAmount)}}</td>
            </tr>
            @endif
            @endforeach
            </tbody>
        </table>
    @endif
    @if($is_charge == true)
        <br />
        <h5> Additional Charges </h5>
        <table border="1"  width="100%" cellpadding="0" cellspacing="0" class="invoice col-md-12 table table-bordered">
                <thead>
                <tr>
                    <th style="text-align: center;">Title</th>
                    <th style="text-align: left;">Description</th>
                    <th style="text-align: center;">Price</th>
                    <th style="text-align: center;">Quantity</th>
                    <th style="text-align: center;">Date</th>
                    <th style="text-align: center;">Line Total</th>
                </tr>
                </thead>
                <tbody>
                @foreach($InvoiceDetail as $ProductRow)
                @if($ProductRow->ProductType == \App\Lib\Product::ONEOFFCHARGE)
                <tr>
                    <td class="text-center">{{\App\Lib\Product::getProductName($ProductRow->ProductID,$ProductRow->ProductType)}}</td>
                    <td class="text-left">{{$ProductRow->Description}}</td>
                    <td class="text-center">{{number_format($ProductRow->Price,$RoundChargesAmount)}}</td>
                    <td class="text-center">{{$ProductRow->Qty}}</td>
                    <td class="text-center">{{date($InvoiceTemplate->DateFormat,strtotime($ProductRow->StartDate))}}</td>
                    <td class="text-center">{{number_format($ProductRow->LineTotal,$RoundChargesAmount)}}</td>
                </tr>
                @endif
                @endforeach
                </tbody>
            </table>
        @endif

     @if(count($usage_data) > 0 && $AccountBilling->CDRType != \App\Lib\Account::NO_CDR)

              <div class="page_break"></div>
               <br />
               <br />


                     <h2 class="text-center">Usage</h2>
                     @if($AccountBilling->CDRType == \App\Lib\Account::SUMMARY_CDR)
                     <table  border="1"  width="100%" cellpadding="0" cellspacing="0" class="bg_graycolor invoice_total col-md-12 table table-bordered">
                          <tr>
                             <th class="text-center" width="10%">Trunk</th>
                             <th width="10%">Prefix</th>
                             <th width="10%">Country</th>
                             <th width="20%">Description</th>
                             <th width="10%">No. of Calls</th>
                             <th width="10%">Duration<br>mm:ss</th>
                             <th class="text-center" width="10%">Billed Duration<br>mm:ss</th>
                             <th class="text-center" width="10%">Charged Amount</th>
                             <th class="text-center" width="10%">Avg. Rate/Min</th>
                         </tr>
                              <?php
                                 $totalCalls=0;
                                 $totalDuration=0;
                                 $totalBillDuration=0;
                                 $totalTotalCharges=0;
                             ?>
                             @foreach($usage_data as $row)
                             <?php
                                 $totalCalls  += $row['NoOfCalls'];
                                 $totalDuration  += $row['DurationInSec'];
                                 $totalBillDuration  += $row['BillDurationInSec'];
                                 $totalTotalCharges  += $row['TotalCharges'];
                             ?>
                                 <tr>
                                 <td class="text-center">{{$row['Trunk']}}</td>
                                 <td>{{$row['AreaPrefix']}}</td>
                                 <td>{{$row['Country']}}</td>
                                 <td>{{$row['Description']}}</td>
                                 <td>{{$row['NoOfCalls']}}</td>
                                 <td>{{$row['Duration']}}</td>
                                 <td class="text-center">{{$row['BillDuration']}}</td>
                                 <td class="text-center">{{$CurrencySymbol}}{{ number_format($row['TotalCharges'],$RoundChargesAmount)}}</td>
                                 <td class="text-center">{{$CurrencySymbol}}{{ number_format(($row['TotalCharges']/$row['BillDurationInSec'])*60,$RoundChargesAmount)}}</td>
                                </tr>
                             @endforeach
                             <?php
                             $totalDuration = intval($totalDuration / 60) .':' . ($totalDuration % 60);
                             $totalBillDuration = intval($totalBillDuration / 60) .':' . ($totalBillDuration % 60);
                             ?>
                              <tr>
                                 <th class="text-right" colspan="4"><strong>Total</strong></th>
                                 <th>{{$totalCalls}}</th>
                                 <th>{{$totalDuration}}</th>
                                 <th class="text-center">{{$totalBillDuration}}</th>
                                  <th class="text-center">{{$CurrencySymbol}}{{number_format($totalTotalCharges,$RoundChargesAmount)}}</th>
                                  <th></th>
                             </tr>
                      </table>
                     @endif


                     @if($AccountBilling->CDRType == \App\Lib\Account::DETAIL_CDR)
                     <table  border="1"  width="100%" cellpadding="0" cellspacing="0" class="bg_graycolor invoice_total col-md-12 table table-bordered">
                          <tr>
                             <th class="text-center" width="10%">Prefix</th>
                             <th width="10%">Cli</th>
                             <th width="20%">Cld</th>
                             <th width="10%">Connect Time</th>
                             <th width="10%">Disconnect Time</th>
                             <th class="text-center" width="10%">Duration</th>
                             <th class="text-center" width="10%">Charged Amount</th>
                         </tr>
                              <?php
                                 $totalBillDuration=0;
                                 $totalTotalCharges=0;
                             ?>
                             @foreach($usage_data as $row)
                             <?php
                                 $totalBillDuration  +=  $row['billed_duration'];
                                 $totalTotalCharges  += $row['cost'];
                             ?>
                             <tr>
                             <td class="text-center">{{$row['area_prefix']}}</td>
                             <td>{{substr($row['cli'],1)}}</td>
                             <td>{{substr($row['cld'],1)}}</td>
                             <td>{{$row['connect_time']}}</td>
                             <td>{{$row['disconnect_time']}}</td>
                             <td class="text-center">{{$row['billed_duration']}}</td>
                             <td class="text-center">{{$CurrencySymbol}}{{ number_format($row['cost'],$RoundChargesAmount)}}</td>
                             </tr>
                             @endforeach
                              <tr>
                              <th class="text-right" colspan="5"><strong>Total</strong></th>
                              <th class="text-center">{{$totalBillDuration}}</th>
                              <th class="text-center">{{$CurrencySymbol}}{{number_format($totalTotalCharges,$RoundChargesAmount)}}</th>
                              </tr>
                      </table>
                     @endif


              @endif


 @stop