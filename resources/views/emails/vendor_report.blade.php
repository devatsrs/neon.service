<table border="1" cellpadding="10" cellspacing="0" class="table table-bordered datatable">
    <thead>
    <tr role="row">
        <th><strong>Account</strong></th>
        <th><strong>Date</strong></th>
        <th><strong>Hour</strong></th>
        <th><strong>Attempts</strong></th>
        <th><strong>Connected</strong></th>
        <th><strong>Cost</strong></th>
        <th><strong>Minutes</strong></th>
        <th><strong>Current ACD</strong></th>
        <th><strong>Current ASR</strong></th>

    </tr>
    </thead>
    <tbody>
    @foreach($ACD_ASR_alerts as $ACD_ASR_alert)
        <tr>
            <td>{{$ACD_ASR_alert->AccountName}}</td>
            <td>{{$ACD_ASR_alert->Date}}</td>
            <td>{{$ACD_ASR_alert->Hour}}</td>
            <td>{{$ACD_ASR_alert->Attempts}}</td>
            <td>{{$ACD_ASR_alert->Connected}}</td>
            <td>{{$ACD_ASR_alert->Cost}}</td>
            <td>{{$ACD_ASR_alert->Minutes}}</td>
            <td>{{$ACD_ASR_alert->ACD}}</td>
            <td>{{$ACD_ASR_alert->ASR}}</td>

        </tr>
    @endforeach
    </tbody>
</table>