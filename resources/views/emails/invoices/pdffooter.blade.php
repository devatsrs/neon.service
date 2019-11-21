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
    <link rel="stylesheet" type="text/css" href="{{base_path().'/resources/assets/css/bootstrap.css'}}" />
    <link rel="stylesheet" type="text/css" href="{{base_path().'/resources/assets/invoicetemplate/style.css'}}" />
    <!-- footer section start -->
    <footer>
        <div class="footer-logo pull-left text-left">
            @if(!empty($logo))
                <img src="{{get_image_data($logo)}}" style="max-width: 150px">
            @endif
        </div>
        <div class="footer-detail pull-right">
            {{ nl2br($Invoice->FooterTerm) }}
        </div>
        <div class="clearfix"></div>
    </footer>
    <!-- footer section start -->

@stop