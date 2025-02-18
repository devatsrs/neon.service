<p>
    Alert raised due to following criteria
</p>
<table border="1" cellpadding="10" cellspacing="0" class="table table-bordered datatable">
    <thead>
    <tr role="row">
        <th><strong>Hour</strong></th>
        <th><strong>Attempts</strong></th>
        <th><strong>Connected</strong></th>
        @if(!empty($settings['NoOfCall']))
        <th><strong>No of Call</strong></th>
        @endif
        @if(!empty($settings['AccountName']))
            <th><strong>Account</strong></th>
        @endif
        @if(!empty($settings['GatewayNames']))
            <th><strong>Gateway</strong></th>
        @endif
        @if(!empty($settings['CountryNames']))
            <th><strong>Country</strong></th>
        @endif
        @if(!empty($settings['TrunkNames']))
            <th><strong>Trunk</strong></th>
        @endif
        @if(!empty($settings['Prefix']))
            <th><strong>Prefix</strong></th>
        @endif
        @if(!empty($Alert->LowValue))
            <th><strong>Low Value</strong></th>
        @endif
        @if(!empty($Alert->HighValue))
            <th><strong>High Value</strong></th>
        @endif

        <th><strong>Minutes</strong></th>
        <th><strong>Current ACD</strong></th>
        <th><strong>Current ASR</strong></th>

    </tr>
    </thead>
    <tbody>
    <tr>
        <td>{{$ACD_ASR_alert->Hour}}</td>
        <td>{{$ACD_ASR_alert->Attempts}}</td>
        <td>{{$ACD_ASR_alert->Connected}}</td>
        @if(!empty($settings['NoOfCall']))
        <td>{{$settings['NoOfCall']}}</td>
        @endif
        @if(!empty($settings['AccountName']))
            <td> {{$settings['AccountName']}}</td>
        @endif
        @if(!empty($settings['GatewayNames']))
            <td>{{implode(',',$settings['GatewayNames'])}}</td>
        @endif
        @if(!empty($settings['CountryNames']))
            <td>{{implode(',',$settings['CountryNames'])}}</td>
        @endif
        @if(!empty($settings['TrunkNames']))
            <td>{{implode(',',$settings['TrunkNames'])}}</td>
        @endif
        @if(!empty($settings['Prefix']))
            <td>{{$settings['Prefix']}}</td>
        @endif
        @if(!empty($Alert->LowValue))
            <td>{{$Alert->LowValue}}</td>
        @endif
        @if(!empty($Alert->HighValue))
            <td>{{$Alert->HighValue}}</td>
        @endif

        <td>{{$ACD_ASR_alert->Minutes}}</td>
        <td>{{$ACD_ASR_alert->ACD}}</td>
        <td>{{$ACD_ASR_alert->ASR}}</td>

    </tr>
    </tbody>
</table>