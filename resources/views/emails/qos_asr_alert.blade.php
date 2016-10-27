<p>
    {{$Alert->Name}}  raised due to following criteria not satisfied
</p>

<ul>
    @if(!empty($settings['GatewayNames']))
        <li>Gateway : {{$settings['GatewayNames']}}</li>
    @endif
    @if(!empty($settings['CountryNames']))
        <li>Country : {{$settings['CountryNames']}}</li>
    @endif
    @if(!empty($settings['TrunkNames']))
        <li>Trunk : {{$settings['TrunkNames']}}</li>
    @endif
    @if(!empty($settings['Prefix']))
        <li>Trunk : {{$settings['Prefix']}}</li>
    @endif
    @if(!empty($settings['AccountName']))
        <li>Account : {{$settings['AccountName']}}</li>
    @endif
</ul>

<p>
    Current ASR : {{$ACD_ASR_alert->ASR}}
    <br/>
    Expected ASR Between : {{$Alert->LowValue}} To {{$Alert->HighValue}}
</p>