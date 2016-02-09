
Hi {{$data['data']['CompanyName']}}
<br><br>

Please check, You have following transactions in your system.

<br><br><br><br>

<table border="1" cellpadding="0" cellspacing="0" style="width: 100.0%;border-collapse: collapse;border: none;border-spacing: 0;max-width: 100%;" >
    <thead>
        <tr>
            <th style="background-color: #f9f9f9;padding:10px 5px;font-weight: bold; color: #717171;font-size: 12px;line-height: 150%;" >Date</th>
            <th style="background-color: #f9f9f9;padding:10px 5px;font-weight: bold; color: #717171;font-size: 12px;line-height: 150%;" >Account Name</th>
            <th style="background-color: #f9f9f9;padding:10px 5px;font-weight: bold; color: #717171;font-size: 12px;line-height: 150%;" >Transaction</th>
            <th style="background-color: #f9f9f9;padding:10px 5px;font-weight: bold; color: #717171;font-size: 12px;line-height: 150%;" >Invoice Number</th>
            <th style="background-color: #f9f9f9;padding:10px 5px;font-weight: bold; color: #717171;font-size: 12px;line-height: 150%;" >Notes</th>
            <th style="background-color: #f9f9f9;padding:10px 5px;font-weight: bold; color: #717171;font-size: 12px;line-height: 150%;" >Status</th>
            <th style="background-color: #f9f9f9;padding:10px 5px;font-weight: bold; color: #717171;font-size: 12px;line-height: 150%;" >Amount</th>
        </tr>
    </thead>

            @if(count($data['data']['TransactionData']))
            <tbody>
            <?php $total = 0;?>

            @foreach($data['data']['TransactionData'] as $transaction)
            <?php
                    $total += $transaction->Amount;
            ?>
            <tr>
                <td style="background-color: #fff;padding:10px 5px;font-weight: normal; color: #989393;font-size: 12px;line-height: 150%;" >{{$transaction->created_at}}</td>
                <td style="background-color: #fff;padding:10px 5px;font-weight: normal; color: #989393;font-size: 12px;line-height: 150%;" >{{$transaction->AccountName}}</td>
                <td style="background-color: #fff;padding:10px 5px;font-weight: normal; color: #989393;font-size: 12px;line-height: 150%;" >{{$transaction->Transaction}}</td>
                <td style="background-color: #fff;padding:10px 5px;font-weight: normal; color: #989393;font-size: 12px;line-height: 150%;" >{{$transaction->InvoiceNumber}}</td>
                <td style="background-color: #fff;padding:10px 5px;font-weight: normal; color: #989393;font-size: 12px;line-height: 150%;" >{{$transaction->Notes}}</td>
                <td style="background-color: #fff;padding:10px 5px;font-weight: normal; color: #989393;font-size: 12px;line-height: 150%;" >{{$transaction->Status}}</td>
                <td style="background-color: #fff;padding:10px 5px;font-weight: normal; color: #989393;font-size: 12px;line-height: 150%;" >{{$transaction->Amount}}</td>
            </tr>
            @endforeach
            </tbody>
            <tfoot>
                <tr>
                     <th style="background-color: #f9f9f9;padding:10px 5px;font-weight: bold; color: #717171;font-size: 12px;line-height: 150%;" ></th>
                     <th style="background-color: #f9f9f9;padding:10px 5px;font-weight: bold; color: #717171;font-size: 12px;line-height: 150%;" ></th>
                     <th style="background-color: #f9f9f9;padding:10px 5px;font-weight: bold; color: #717171;font-size: 12px;line-height: 150%;" ></th>
                     <th style="background-color: #f9f9f9;padding:10px 5px;font-weight: bold; color: #717171;font-size: 12px;line-height: 150%;" ></th>
                     <th style="background-color: #f9f9f9;padding:10px 5px;font-weight: bold; color: #717171;font-size: 12px;line-height: 150%;" ></th>
                     <th style="background-color: #f9f9f9;padding:10px 5px;font-weight: bold; color: #717171;font-size: 12px;line-height: 150%;" >Total</th>
                     <th style="background-color: #f9f9f9;padding:10px 5px;font-weight: bold; color: #717171;font-size: 12px;line-height: 150%;text-align: left" >{{$total}}</th>
                </tr>
            </tfoot>
            @else
            <tbody>
                   <tr><td style="background-color: #fff;padding:10px 5px;font-weight: bold; color: #989393;font-size: 12px;line-height: 150%;" colspan="7">No transactions found.</td></tr>
            </tbody>

            @endif
</table>
<br><br>
Best Regards <br>
{{$data['data']['CompanyName']}}
