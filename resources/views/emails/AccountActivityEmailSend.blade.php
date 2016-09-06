
<p>
Hi {{$data['data']['AccountTaskData'][0]['FirstName']}} {{$data['data']['AccountTaskData'][0]['LastName']}} ,
</p>

<p>
    Please find below your activities due soon :
</p>


<style>
    .alignleft { text-align: left; }
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
<table cellpadding="1" cellspacing="1" width="75%" class="alignleft">
    <thead>
    <tr class="headercolor">
        <th width="30%">Type</th>
        <th width="30%">Title</th>
        <th width="25%">Date</th>
        <th width="15%">Status</th>
        <th width="15%">Related To</th>

    </tr>
    </thead>
    <tbody>
@foreach($data['data']['AccountTaskData'] as $activity )
    <tr class="rowscolor">
        <td><div class="{{$activity['Priority']==1?'priority':'normal'}} inlinetable">&nbsp;</div><div class="inlinetable">{{$activity['TaskType']}}</div></td>
        <td>{{$activity['Subject']}}</td>
        <td>{{$activity['Date']}}</td>
        <td>{{$activity['BoardColumnName']}}</td>
        <td>{{$activity['AccountName']}}</td>
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