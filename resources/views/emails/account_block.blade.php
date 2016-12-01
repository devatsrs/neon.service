<p>
    Below Accounts are blocked/unblocked.
</p>
<table border="1" cellpadding="10" cellspacing="0" class="table table-bordered datatable">
    <thead>
    <tr role="row">
        <th><strong>Account Name</strong></th>
        <th><strong>Status</strong></th>
    </tr>
    </thead>
    <tbody>
    @foreach($data['Message'] as $account => $status)
    <tr>
        <td>{{$account}}</td>
        <td>{{$status}}</td>
    </tr>
    @endforeach
    </tbody>
</table>