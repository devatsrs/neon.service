<p>
    Expensive Calls (Max. Duration {{$settings['Cost']}})
</p>
<h4>Customer</h4>
<table border="1" cellpadding="10" cellspacing="0" class="table table-bordered datatable">
    <thead>
    <tr role="row">
        <th>Connect Time</th>
        <th>Disconnect Time</th>
        <th>CLI</th>
        <th>CLD</th>
        <th>Call Duration</th>
        <th>Cost</th>
    </tr>
    </thead>
    <tbody>
    @foreach($call_cost as $call)
        <tr>
            <td>{{$call['connect_time']}}</td>
            <td>{{$call['disconnect_time']}}</td>
            <td>{{$call['cli']}}</td>
            <td>{{$call['cld']}}</td>
            <td>{{$call['billed_duration']}}</td>
            <td>{{$call['cost']}}</td>
        </tr>
    @endforeach
    </tbody>
</table>
@if(count($vcall_cost))
<h4>Vendor</h4>
<table border="1" cellpadding="10" cellspacing="0" class="table table-bordered datatable">
    <thead>
    <tr role="row">
        <th>Connect Time</th>
        <th>Disconnect Time</th>
        <th>CLI</th>
        <th>CLD</th>
        <th>Call Duration</th>
        <th>Cost</th>
    </tr>
    </thead>
    <tbody>
    @foreach($vcall_cost as $call)
        <tr>
            <td>{{$call['connect_time']}}</td>
            <td>{{$call['disconnect_time']}}</td>
            <td>{{$call['cli']}}</td>
            <td>{{$call['cld']}}</td>
            <td>{{$call['billed_duration']}}</td>
            <td>{{$call['buying_cost']}}</td>
        </tr>
    @endforeach
    </tbody>
</table>
@endif