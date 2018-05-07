@extends('layout.print')

@section('content')
    <style type="text/css">
        #pdf_footer {
            bottom: 0;
            /*border-top: 1px solid #aaaaaa;  */
            color: #000000;
            font-size: 10px;
        }
        #pdf_footer table {
            width:100%;
        }
    </style>
    <?php
    $FooterTerm = $Invoice->FooterTerm;

    $replace_array = \App\Lib\Invoice::create_accountdetails($Account);
    $FooterTermtext = \App\Lib\Invoice::getInvoiceToByAccount($FooterTerm,$replace_array);
    $FooterTerm_message = preg_replace("/(^[\r\n]*|[\r\n]+)[\s\t]*[\r\n]+/", "\n", $FooterTermtext);
    ?>
    <!-- footer section start -->
    <div id="pdf_footer">
        {{nl2br($FooterTerm_message)}}

    </div>
    <!-- footer section start -->

    </div> <!-- invoicebody(class) section end -->

 @stop