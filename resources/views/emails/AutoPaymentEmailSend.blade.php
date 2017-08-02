Hi <br><br>

We hereby confirm that we have received payment.<br>
<h4>Payment Detail</h4><br>
    Account Name: {{ $data['AccountName'] }}<br>
    Amount: {{ number_format($data['Amount'],2) }}<br>
    Status: {{ $data['Status'] }}<br>
    PaymentMethod:  {{ $data['PaymentMethod'] }}<br>
    Currency:  {{ $data['Currency'] }}<br>
    Notes:  {{ $data['Notes'] }}<br><br>
	
Best Regards<br>
{{$data['CompanyName']}}
