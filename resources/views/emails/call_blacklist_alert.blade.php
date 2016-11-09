<p>
    Call made in Blacklisted Destination.
</p>
<table border="1" cellpadding="10" cellspacing="0" class="table table-bordered datatable">
    <thead>
    <tr role="row">
        <th>Customer Name</th>
        <th>Destination</th>
        <th>Connect Time</th>
        <th>Disconnect Time</th>
        <th>CLI</th>
        <th>CLD</th>
        <th>Call Duration</th>
        <th>Cost</th>
    </tr>
    </thead>
    <tbody>
    @foreach($call_blacklist as $call)
        <tr>
            <td>{{\App\Lib\Account::getAccountName($call['AccountID'])}}</td>
            <td>{{\App\Lib\Country::getCountryName($call['CountryID'])}}</td>
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
@if(count($vcall_blacklist))
<table border="1" cellpadding="10" cellspacing="0" class="table table-bordered datatable">
    <thead>
    <tr role="row">
        <th>Vendor Name</th>
        <th>Destination</th>
        <th>Connect Time</th>
        <th>Disconnect Time</th>
        <th>CLI</th>
        <th>CLD</th>
        <th>Call Duration</th>
        <th>Cost</th>
    </tr>
    </thead>
    <tbody>
    @foreach($vcall_blacklist as $call)
        <tr>
            <td>{{\App\Lib\Account::getAccountName($call['AccountID'])}}</td>
            <td>{{\App\Lib\Country::getCountryName($call['CountryID'])}}</td>
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