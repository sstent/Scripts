function MAIN {
InitialiseSheet
$totest = New-Object System.DirectoryServices.DirectoryEntry("LDAP://DC=bnwww,DC=prod,DC=bn")
ProcessDomain $totest BNWWW
$totest = New-Object System.DirectoryServices.DirectoryEntry("LDAP://DC=bnsi,DC=dev,DC=bn")
ProcessDomain $totest BNSI
$totest = New-Object System.DirectoryServices.DirectoryEntry("LDAP://DC=bndev,DC=dev,DC=bn")
ProcessDomain $totest BNDEV


}

Function Test-MachineCredentials {
	Param($domainx)
	Add-Type -AssemblyName System.DirectoryServices.AccountManagement
	$ct = [System.DirectoryServices.AccountManagement.ContextType]::Machine
	$pc = New-Object System.DirectoryServices.AccountManagement.PrincipalContext($ct, $domainx)
	New-Object PSObject -Property @{
		UserName = $usernamex;
		IsValid = $pc.ValidateCredentials("47ecrivez", "gR@v1tY0").ToString()
		}
}

function InitialiseSheet{
$erroractionpreference = "SilentlyContinue"
$a = New-Object -comobject Excel.Application
$a.visible = $True 

$b = $a.Workbooks.Add()
$global:c = $b.Worksheets.Item(1)

$global:c.Cells.Item(1,1) = "Server"
$global:c.Cells.Item(1,2) = "Password"
$global:c.Cells.Item(1,3) = "Domain"
$global:c.Cells.Item(1,4) = "OS Version"

$global:c.Cells.Item(1,5) = "NIC Name1"
$global:c.Cells.Item(1,6) = "MAC"
$global:c.Cells.Item(1,7) = "IP"
$global:c.Cells.Item(1,8) = "IP2"
$global:c.Cells.Item(1,9) = "IP3"
$global:c.Cells.Item(1,10) = "DNS"
$global:c.Cells.Item(1,11) = "DNS2"
$global:c.Cells.Item(1,12) = "WINS1"
$global:c.Cells.Item(1,13) = "WINS2"
$global:c.Cells.Item(1,14) = "Speed/Duplex"

$global:c.Cells.Item(1,15) = "NIC Name3"
$global:c.Cells.Item(1,16) = "MAC"
$global:c.Cells.Item(1,17) = "IP"
$global:c.Cells.Item(1,18) = "IP2"
$global:c.Cells.Item(1,19) = "IP3"
$global:c.Cells.Item(1,20) = "DNS"
$global:c.Cells.Item(1,21) = "DNS2"
$global:c.Cells.Item(1,22) = "WINS1"
$global:c.Cells.Item(1,23) = "WINS2"
$global:c.Cells.Item(1,24) = "Speed/Duplex"

$global:c.Cells.Item(1,25) = "NIC Name3"
$global:c.Cells.Item(1,26) = "MAC"
$global:c.Cells.Item(1,27) = "IP"
$global:c.Cells.Item(1,28) = "IP2"
$global:c.Cells.Item(1,29) = "IP3"
$global:c.Cells.Item(1,30) = "DNS"
$global:c.Cells.Item(1,31) = "DNS2"
$global:c.Cells.Item(1,32) = "WINS1"
$global:c.Cells.Item(1,33) = "WINS2"

$global:c.Cells.Item(1,35) = "Route1"
$global:c.Cells.Item(1,36) = "Mask1"
$global:c.Cells.Item(1,37) = "Destination1"

$global:c.Cells.Item(1,39) = "Route2"
$global:c.Cells.Item(1,40) = "Mask2"
$global:c.Cells.Item(1,41) = "Destination2"

$global:c.Cells.Item(1,43) = "Route3"
$global:c.Cells.Item(1,44) = "Mask3"
$global:c.Cells.Item(1,45) = "Destination3"

$global:c.Cells.Item(1,46) = "P or V"


$global:d = $global:c.UsedRange
$global:d.Interior.ColorIndex = 19
$global:d.Font.ColorIndex = 11
$global:d.Font.Bold = $True
$global:d.EntireColumn.AutoFit($True)

$global:intRow = 2
}

Function ProcessDomain {
	Param($objOU, $dom)

$strFilter = "computer"
 
$objDomain = New-Object System.DirectoryServices.DirectoryEntry
 
$objSearcher = New-Object System.DirectoryServices.DirectorySearcher
$objSearcher.SearchRoot = $objOU
$objSearcher.SearchScope = "Subtree" 
$objSearcher.PageSize = 1000 

$objSearcher.Filter = "(objectCategory=$strFilter)"

$colResults = $objSearcher.FindAll()


foreach($i in $colResults)
{
$entry = $i.GetDirectoryEntry()

echo $global:intRow $entry.Name
$x = [String] $entry.Name

$global:c.Cells.Item($global:intRow, 1) = $x
$global:c.Cells.Item($global:intRow, 3) = $dom
 if ((gwmi Win32_PingStatus -Filter "Address='$x'").StatusCode –eq 0) 
		 {
		
		#$global:c.Cells.Item($global:intRow, 4) = “Up”
		$Build = Get-wmiobject -class "Win32_OperatingSystem" -computername $entry.Name
		$global:c.Cells.Item($global:intRow, 4) = $Build.Caption
		
$socket = new-object Net.Sockets.TcpClient
$socket.Connect($x, 3389)

if ($socket.connected -eq $true ){

		
			if ((Test-MachineCredentials $entry.Name).IsValid –eq $True) 
			{
			$global:c.Cells.Item($global:intRow, 2) = “Accepted”
			}
			else {
			$global:c.Cells.Item($global:intRow, 2) = “Denied”
			}

			
			
			# Uncomment to copy files to system32
			# if ((test-path "\\$x\c$\windows\system32") -eq $true)
			# {
			# $global:c.Cells.Item($global:intRow, 2) = “windows”
			# copy-item c:\pinch.exe \\$x\c$\windows\system32
			# }
			# else {
				# if ((test-path "\\$x\c$\winnt\system32") -eq $true){
				# $global:c.Cells.Item($global:intRow, 2) = “winnt”
				# copy-item c:\pinch.exe \\$x\c$\winnt\system32
				# }
			
			# }
			
			
			

		
		$nic = 0
		$colItems = Get-wmiobject -class "Win32_NetworkAdapterConfiguration" -computername $entry.Name | Where{$_.IpEnabled -Match "True"}
		
		foreach ($objItem in $colItems) {
			$colAdapter  = Get-wmiobject -class "Win32_NetworkAdapter" -computername $entry.Name | Where{$_.MACAddress -Match $objItem.MACAddress}
			foreach ($objAdapter in $colAdapter) {
			$global:c.Cells.Item($global:intRow, 5 + $nic) = $objAdapter.NetConnectionId
						
				$registry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $entry.Name)
				$baseKey = $registry.OpenSubKey("SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}")
				$subKeyNames = $baseKey.GetSubKeyNames()
				ForEach ($subKeyName in $subKeyNames)
				{
					$subKey = $baseKey.OpenSubKey("$subKeyName")
					$ID = $subKey.GetValue("NetCfgInstanceId")
					If ($ID -eq $objItem.SettingId)
					{
						$componentID = $subKey.GetValue("ComponentID")
						If ($componentID -match "ven_14e4")
						{
							# $myObj.NICModel = "Broadcom"
							$requestedMediaType = $subKey.GetValue("RequestedMediaType")
							$enum = $subKey.OpenSubKey("Ndi\Params\RequestedMediaType\Enum")
							$global:c.Cells.Item($global:intRow, 14 + $nic) = $enum.GetValue("$requestedMediaType")
						}
						ElseIf ($componentID -match "ven_8086")
						{
							# $myObj.NICModel = "Intel"
							$SD = $subKey.GetValue("SpeedDuplex")
							$enum = $subKey.OpenSubKey("Ndi\Params\SpeedDuplex\Enum")
							$global:c.Cells.Item($global:intRow, 14 + $nic) = $enum.GetValue("$SD")
						}
						ElseIf ($componentID -match "b06bdrv")
						{
							# $myObj.NICModel = "HP"
							$SD = $subKey.GetValue("req_medium")
							$enum = $subKey.OpenSubKey("Ndi\Params\req_medium\Enum")
							$global:c.Cells.Item($global:intRow, 14 + $nic) = $enum.GetValue("$SD")
						}
						Else
						{
							# $myObj.NICModel = "unknown"
							$global:c.Cells.Item($global:intRow, 14 + $nic) = "unknown"
						}
					}
				}
			}
				$m = [String] $objItem.MACAddress
				if ($m.StartsWith("00:50:56")) {
				$global:c.Cells.Item($global:intRow,46) = "virtual"
				}
				Else 
				{$global:c.Cells.Item($global:intRow,46) = "physical"}
			
				$global:c.Cells.Item($global:intRow, 6 + $nic) = $objItem.MACAddress
				
				$global:c.Cells.Item($global:intRow, 7 + $nic ) = $objItem.IPAddress[0]
				$global:c.Cells.Item($global:intRow, 8 + $nic ) = $objItem.IPAddress[1]
				$global:c.Cells.Item($global:intRow, 9 + $nic ) = $objItem.IPAddress[2]
				$global:c.Cells.Item($global:intRow, 10+ $nic) = $objItem.DNSServerSearchOrder[0]
				$global:c.Cells.Item($global:intRow, 11+ $nic) = $objItem.DNSServerSearchOrder[1]
				$global:c.Cells.Item($global:intRow, 12+ $nic) = $objItem.WINSPrimaryServer 
				$global:c.Cells.Item($global:intRow, 13 + $nic) = $objItem.WINSSecondaryServer 
		   
				$nic = $nic + 10 
		   
		}
		
		

		
		$colRoutes = Get-wmiobject -class "Win32_IP4PersistedRouteTable" -namespace "root\CIMV2" -computername $entry.Name
		$route = 0
			foreach ($objRoute in $colRoutes) {

			$global:c.Cells.Item($global:intRow, 35 + $route) = $objRoute.Destination
			$global:c.Cells.Item($global:intRow, 36 + $route) = $objRoute.Mask
			$global:c.Cells.Item($global:intRow, 37 + $route) = $objRoute.NextHop 

			$route = $route + 4
			}
		

		}
		else 
		{
		$global:c.Cells.Item($global:intRow, 4) = "Other OS"
		}
 } 
 else 
{
 $global:c.Cells.Item($global:intRow, 4) = "Offline"
}

$global:intRow = $global:intRow + 1
$global:d.EntireColumn.AutoFit()
}
}
#}
#execute the script
Main