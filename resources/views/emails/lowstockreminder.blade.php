<!DOCTYPE html>
<html lang="en-US">
<head>
    <meta charset="utf-8">
</head>
<body>
<h2>Low Stock Reminder</h2>

<table border="1" cellpadding="10" cellspacing="0" class="table table-bordered datatable">
    <thead>
    <tr role="row">
        <th><strong>Item Type</strong></th>
        <th><strong>Item Name</strong></th>
        <th><strong>Item Code</strong></th>
        <th><strong>Stock</strong></th>
        <th><strong>Low Stock Level</strong></th>

    </tr>
    </thead>
    <tbody>
    @foreach($AlertItems as $AlertItem)
        <tr>
            <td>{{$AlertItem->title}}</td>
            <td>{{$AlertItem->Name}}</td>
            <td>{{$AlertItem->Code}}</td>
            <td>{{$AlertItem->Stock}}</td>
            <td>{{$AlertItem->LowStockLevel}}</td>
        </tr>
    @endforeach
    </tbody>
</table>

</body>
</html>