@extends('layout.print')

@section('content')
    <link rel="stylesheet" type="text/css" href="<?php echo URL::to('/'); ?>/assets/css/invoicetemplate/invoicestyle.css" />
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
            <h2 class="name">INVOICE FROM</h2>
            <div>{{ nl2br($InvoiceTemplate->Header)}}</div>
        </div>
    </header>
    <!-- logo and invoice from section end-->

    <!-- need to change with new logic -->

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

    $message = $InvoiceTemplate->InvoiceTo;

    $replace_array = \App\Lib\Invoice::create_accountdetails($Account);
    $return_message = \App\Lib\Invoice::getInvoiceToByAccount($message,$replace_array);

    ?>


    <main>
        <div id="details" class="clearfix">
            <div id="client">
                <div class="to">INVOICE TO:</div>
                <div>{{nl2br($return_message)}}</div>
            </div>
            <div id="invoice">
                <h1>Invoice No: {{$Invoice->FullInvoiceNumber}}</h1>
                <div class="date">Invoice Date: {{ date($InvoiceTemplate->DateFormat,strtotime($Invoice->IssueDate))}}</div>
                <div class="date">Due Date: {{date('d-m-Y',strtotime($Invoice->IssueDate.' +'.$PaymentDueInDays.' days'))}}</div>
                @if($InvoiceTemplate->ShowBillingPeriod == 1)
                    <div class="date">Invoice Period: {{$InvoiceFrom}} - {{$InvoiceTo}}</div>
                @endif
            </div>
        </div>

        <!-- content of front page section start -->

        <table border="0" cellspacing="0" cellpadding="0" id="frontinvoice">
            <thead>

            <!-- need here start loop of service -->

            <tr>
                <th class="desc">DESCRIPTION</th>
                <th class="desc">Usage</th>
                <th class="desc">Recurring</th>
                <th class="desc">Additional</th>
                <th class="total">TOTAL</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td class="desc">Service - 1</td>
                <td class="desc">$1,200.00</td>
                <td class="desc">$1,000.00</td>
                <td class="desc">$1,000.00</td>
                <td class="total">$3,200.00</td>
            </tr>
            <tr>
                <td class="desc">Service - 2</td>
                <td class="desc">$1,200.00</td>
                <td class="desc">$1,000.00</td>
                <td class="desc">$1,000.00</td>
                <td class="total">$3,200.00</td>
            </tr>
            <tr>
                <td class="desc">Other Service</td>
                <td class="desc">$400.00</td>
                <td class="desc">$400.00</td>
                <td class="desc">$400.00</td>
                <td class="total">$1,200.00</td>
            </tr>

            <!-- need here end loop of service -->

            </tbody>
            <tfoot>
            <tr>
                <td colspan="2"></td>
                <td colspan="2">SUB TOTAL</td>
                <td class="subtotal">{{$CurrencySymbol}}{{number_format($Invoice->SubTotal,$RoundChargesAmount)}}</td>
            </tr>
            @if(count($InvoiceTaxRates))
                @foreach($InvoiceTaxRates as $InvoiceTaxRate)
                <tr>
                    <td colspan="2"></td>
                    <td colspan="2">{{$InvoiceTaxRate->Title}}</td>
                    <td class="subtotal">{{$CurrencySymbol}}{{number_format($InvoiceTaxRate->TaxAmount,$RoundChargesAmount)}}</td>
                </tr>
                @endforeach
            @endif
            @if($Invoice->TotalDiscount > 0)
                <tr>
                    <td colspan="2"></td>
                    <td colspan="2">Discount</td>
                    <td class="subtotal">{{$CurrencySymbol}}{{number_format($Invoice->TotalDiscount,$RoundChargesAmount)}}</td>
                </tr>
            @endif
            @if($InvoiceTemplate->ShowPrevBal)
                <tr>
                    <td colspan="2"></td>
                    <td colspan="2">BROUGHT FORWARD</td>
                    <td class="subtotal">{{$CurrencySymbol}}{{number_format($Invoice->PreviousBalance,$RoundChargesAmount)}}</td>
                </tr>
            @endif
            <tr>
                <td colspan="2"></td>
                <td colspan="2">GRAND TOTAL</td>
                <td class="subtotal">{{$CurrencySymbol}}{{number_format($Invoice->GrandTotal,$RoundChargesAmount)}}</td>
            </tr>
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

    <!-- need to impliment service brack login -->

    <div class="page_break"> </div>
    <br/>
    <header class="clearfix">
        <div id="Service">
            <h1>Service 1</h1>
        </div>
    </header>
    <main>
        <div class="ChargesTitle clearfix">
            <div style="float:left;">Usage</div>
            <div style="text-align:right;float:right;">$6.20</div>
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
            <tr>
                <td class="leftalign">Usage</td>
                <td class="leftalign">From 01-01-2017 To 31-01-2017</td>
                <td class="rightalign">1.24</td>
                <td class="rightalign">1</td>
                <td class="leftalign">01-01-2017</td>
                <td class="leftalign">31-01-2017</td>
                <td class="rightalign">1.24</td>
            </tr>
            </tbody>
        </table>

        <div class="ChargesTitle clearfix">
            <div style="float:left;">Recurring</div>
            <div style="text-align:right;float:right;">$99.87</div>
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
            <tr>
                <td class="leftalign">WT Premium - £5.99 - NO IPPHONE</td>
                <td class="leftalign">WT Premium - £5.99 - NO IPPHONE</td>
                <td class="rightalign">5.99</td>
                <td class="rightalign">12</td>
                <td class="leftalign">01-02-2017</td>
                <td class="leftalign">28-02-2017</td>
                <td class="rightalign">71.88</td>
            </tr>
            </tbody>
        </table>

        <div class="ChargesTitle clearfix">
            <div style="float:left;">Additional</div>
            <div style="text-align:right;float:right;">$32.00</div>
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
            <tr>
                <td class="leftalign">PBXSETUP</td>
                <td class="leftalign">SETUP COST PER USER</td>
                <td class="rightalign">10.00</td>
                <td class="rightalign">2</td>
                <td class="leftalign">28-02-2017</td>
                <td class="rightalign">20.00</td>
            </tr>
            </tbody>
        </table>
    </main>

    <!-- service section end -->


 @stop