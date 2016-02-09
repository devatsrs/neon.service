Hi <br><br>

New invoice {{$data['data']['InvoiceNumber']}} from {{$data['data']['CompanyName']}}.<br><br>


To view your invoice from {{$data['data']['CompanyName']}} for {{$data['data']['InvoiceGrandTotal']}} {{$data['data']['CurrencyCode']}}, or to download
a PDF copy for your records, click the link bellow<br><br>


<div><!--[if mso]>
  <v:roundrect xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="urn:schemas-microsoft-com:office:word" href="{{$data['data']['InvoiceLink']}}" style="height:30px;v-text-anchor:middle;width:100px;" arcsize="10%" strokecolor="#ff9600" fillcolor="#ff9600">
    <w:anchorlock/>
    <center style="color:#ffffff;font-family:sans-serif;font-size:13px;font-weight:bold;">View</center>
  </v:roundrect>
<![endif]-->
<a href="{{$data['data']['InvoiceLink']}}" style="background-color:#ff9600;border:1px solid #ff9600;border-radius:4px;color:#ffffff;display:inline-block;font-family:sans-serif;font-size:13px;font-weight:bold;line-height:30px;text-align:center;text-decoration:none;width:100px;-webkit-text-size-adjust:none;mso-hide:all;">View</a></div>
<br><br>

Best Regards<br>
{{$data['data']['CompanyName']}}