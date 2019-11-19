@extends('layout.print')

@section('content')
    <style type="text/css">
        #pdf_footer {
            bottom: 0;
            border-top: 0.1pt solid #aaa;
            left: 0;
            right: 0;
            color: #aaa;
            font-size: 10px;
            text-align: center;
        }
    </style>

    <link rel="stylesheet" type="text/css" href="{{base_path().'/resources/assets/css/bootstrap.css'}}" />
    <link rel="stylesheet" type="text/css" href="{{base_path().'/resources/assets/invoicetemplate/style.css'}}" />

    <header class="clearfix">
        <div id="logo" class="pull-left text-left">
            @if(!empty($logo))
                <img src="{{get_image_data($logo)}}" style="max-width: 250px">
            @endif
        </div>
    </header>
@stop