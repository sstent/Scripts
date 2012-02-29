'    list IP config of remote computer 
' 
' 
strcomputer = Inputbox("Name of Computer","Computer IP Query") 
 
Set objWMIService = GetObject("winmgmts:" _ 
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2") 
 
Set colAdapters = objWMIService.ExecQuery _ 
    ("SELECT * FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled = True") 
  
n = 1 
WScript.Echo 
  
For Each objAdapter in colAdapters 
   WScript.Echo "Network Adapter " & n 
   WScript.Echo "=================" 
   WScript.Echo "  Description: " & objAdapter.Description 
  
   WScript.Echo "  Physical (MAC) address: " & objAdapter.MACAddress 
   WScript.Echo "  Host name:              " & objAdapter.DNSHostName 
  
   If Not IsNull(objAdapter.IPAddress) Then 
      For i = 0 To UBound(objAdapter.IPAddress) 
         WScript.Echo "  IP address:             " & objAdapter.IPAddress(i) 
      Next 
   End If 
  
   If Not IsNull(objAdapter.IPSubnet) Then 
      For i = 0 To UBound(objAdapter.IPSubnet) 
         WScript.Echo "  Subnet:                 " & objAdapter.IPSubnet(i) 
      Next 
   End If 
  
   If Not IsNull(objAdapter.DefaultIPGateway) Then 
      For i = 0 To UBound(objAdapter.DefaultIPGateway) 
         WScript.Echo "  Default gateway:        " & _ 
             objAdapter.DefaultIPGateway(i) 
      Next 
   End If 
  
   WScript.Echo 
   WScript.Echo "  DNS" 
   WScript.Echo "  ---" 
   WScript.Echo "    DNS servers in search order:" 
  
   If Not IsNull(objAdapter.DNSServerSearchOrder) Then 
      For i = 0 To UBound(objAdapter.DNSServerSearchOrder) 
         WScript.Echo "      " & objAdapter.DNSServerSearchOrder(i) 
      Next 
   End If 
  
   WScript.Echo "    DNS domain: " & objAdapter.DNSDomain 
  
   If Not IsNull(objAdapter.DNSDomainSuffixSearchOrder) Then 
      For i = 0 To UBound(objAdapter.DNSDomainSuffixSearchOrder) 
         WScript.Echo "    DNS suffix search list: " & _ 
             objAdapter.DNSDomainSuffixSearchOrder(i) 
      Next 
   End If 
  
   WScript.Echo 
   WScript.Echo "  DHCP" 
   WScript.Echo "  ----" 
   WScript.Echo "    DHCP enabled:        " & objAdapter.DHCPEnabled 
   WScript.Echo "    DHCP server:         " & objAdapter.DHCPServer 
  
   If Not IsNull(objAdapter.DHCPLeaseObtained) Then 
      utcLeaseObtained = objAdapter.DHCPLeaseObtained 
      strLeaseObtained = WMIDateStringToDate(utcLeaseObtained) 
   Else 
      strLeaseObtained = "" 
   End If 
   WScript.Echo "    DHCP lease obtained: " & strLeaseObtained 
  
   If Not IsNull(objAdapter.DHCPLeaseExpires) Then 
      utcLeaseExpires = objAdapter.DHCPLeaseExpires 
      strLeaseExpires = WMIDateStringToDate(utcLeaseExpires) 
   Else 
      strLeaseExpires = "" 
   End If 
   WScript.Echo "    DHCP lease expires:  " & strLeaseExpires 
  
   WScript.Echo 
   WScript.Echo "  WINS" 
   WScript.Echo "  ----" 
   WScript.Echo "    Primary WINS server:   " & objAdapter.WINSPrimaryServer 
   WScript.Echo "    Secondary WINS server: " & objAdapter.WINSSecondaryServer 
   WScript.Echo 
  
   n = n + 1 
  
Next 
  
Function WMIDateStringToDate(utcDate) 
   WMIDateStringToDate = CDate(Mid(utcDate, 5, 2)  & "/" & _ 
       Mid(utcDate, 7, 2)  & "/" & _ 
           Left(utcDate, 4)    & " " & _ 
               Mid (utcDate, 9, 2) & ":" & _ 
                   Mid(utcDate, 11, 2) & ":" & _ 
                      Mid(utcDate, 13, 2)) 
End Function 