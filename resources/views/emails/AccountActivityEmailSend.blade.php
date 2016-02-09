
<p>
Hi {{$data['data']['AccountActivityData'][0]['FirstName']}} {{$data['data']['AccountActivityData'][0]['LastName']}} ,
</p>

<p>
This is reminder for activity related to account.
</p>
<p>
following the detail of activities.
</p>
<style>
.aligncenter { text-align: center; }
.headercolor {background-color: #E5E4F2}
.rowscolor {background-color: #FCF7FC}
</style>
<table cellpadding="1" cellspacing="1" width="75%" class="aligncenter">
    <thead>
    <tr class="headercolor">
        <th width="25%">Account Name</th>
        <th width="25%">Title</th>
        <th width="25%">Date</th>
        <th width="25%">Activity Type</th>
    </tr>
    </thead>
    <tbody>
@foreach($data['data']['AccountActivityData'] as $activity )
    <tr class="rowscolor">
        <td>{{$activity['AccountName']}}</td>
        <td>{{$activity['Title']}}</td>
        <td>{{$activity['Date']}}</td>
        <td>{{$activity['ActivityType']}}</td>
    </tr>
@endforeach
    </tbody>
</table>
<p>
Thanks
</p>

<p>
{{$data['data']['CompanyName']}}
</p>