Hi <br><br>
<b> Job Title: </b>  {{$data['data']['job_data']['data']['JobData'][0]->JobTitle}}<br />
<b> Job Type: </b>  {{$data['data']['job_data']['data']['JobData'][0]->JobType}}<br />
<b> Job Status: </b> {{$data['data']['job_data']['data']['JobData'][0]->StatusTitle}}<br />
<b> Job Message: </b>@if($data['data']['job_data']['data']['JobData'][0]->JobStatusMessage == ""){{"Processed Successfully"}}
@else
 <p>   {{ str_replace('\n\r','<br>' ,$data['data']['job_data']['data']['JobData'][0]->JobStatusMessage)}} </p>
@endif

<br><br>
Best Regards<br>
{{$data['data']['CompanyName']}}
