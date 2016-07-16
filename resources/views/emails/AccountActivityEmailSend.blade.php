
<p>
Hi {{$data['data']['AccountTaskData'][0]['FirstName']}} {{$data['data']['AccountTaskData'][0]['LastName']}} ,
</p>

<p>
This is reminder for task related to account.
</p>
<p>
following the detail of tasks.
</p>
<style>
    .aligncenter { text-align: center; }
    .headercolor {background-color: #E5E4F2}
    .rowscolor {background-color: #FCF7FC}
    .priority {
        border-left: 3px solid #cc2424;
    }
    .normal {
        border-left: 3px solid #00a651;
    }
    .inlinetable {
        text-align: left;
        display: inline;
        line-height: 40px;
    }
</style>
<table cellpadding="1" cellspacing="1" width="75%" class="aligncenter">
    <thead>
    <tr class="headercolor">
        <th width="15%">Account Name</th>
        <th width="45%">Title</th>
        <th width="25%">Date</th>
        <th width="15%">Type</th>
    </tr>
    </thead>
    <tbody>
@foreach($data['data']['AccountTaskData'] as $activity )
    <tr class="rowscolor">
        <td><div class="{{$activity['Priority']==1?'priority':'normal'}} inlinetable">&nbsp;</div><div class="inlinetable">{{$activity['AccountName']}}</div></td>
        <td>{{$activity['Title']}}</td>
        <td>{{$activity['Date']}}</td>
        <td>{{$activity['TaskType']}}</td>
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