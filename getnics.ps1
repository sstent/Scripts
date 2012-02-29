$strComputer = "PNYSLPRTWEB01"
$colItems = Get-wmiobject -class "Win32_NetworkAdapterConfiguration" -computername $strComputer | Where{$_.IpEnabled -Match "True"}


foreach ($objItem in $colItems) {
	$colAdapter  = Get-wmiobject -class "Win32_NetworkAdapter" -computername $strComputer | Where{$_.MACAddress -Match $objItem.MACAddress}
	foreach ($objAdapter in $colAdapter) {
	write-host "Adapter : " $objAdapter.NetConnectionId
	}

   write-host "MAC Address : " $objItem.MACAddress
   for ($i = 0; $i -le $objItem.IPAddress.getupperbound(0); $i++) {
    write-host "IPAddress : " $objItem.IPAddress[$i] 
	}
   write-host "DNS Servers : " $objItem.DNSServerSearchOrder
   Write-Host "WINSPrimaryServer:" $objItem.WINSPrimaryServer 
   Write-Host "WINSSecondaryServer:" $objItem.WINSSecondaryServer 
   Write-host ""
}


$colRoutes = Get-wmiobject -class "Win32_IP4PersistedRouteTable" -namespace "root\CIMV2" -computername $strComputer

foreach ($objRoute in $colRoutes) {

   write-host "route : " $objRoute.Destination
   write-host "mask : " $objRoute.Mask
   write-host "NextHop : " $objRoute.NextHop  
}