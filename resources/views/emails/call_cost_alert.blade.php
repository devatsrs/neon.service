Please check following Potential Fraud Alert Call Cost
<h2>Customer</h2>
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
<h2>Vendor</h2>
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