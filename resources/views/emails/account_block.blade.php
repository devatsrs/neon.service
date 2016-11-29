<p>
    Below Accounts are blocked due insufficient balance
</p>
<table border="1" cellpadding="10" cellspacing="0" class="table table-bordered datatable">
    <thead>
    <tr role="row">
        <th><strong>Account Name</strong></th>
        <th><strong>Status</strong></th>
    </tr>
    </thead>
    <tbody>
    @foreach($data['Message'] as $account)
    <tr>
        <td>{{$account}}</td>
        <td>blocked</td>
    </tr>
    @endforeach
    </tbody>
</table>