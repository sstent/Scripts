
import-module servermanager

#Function to Check Registry values and change them to desired value
Function CheckSetRegValue ($RegKey, $Name, $DesiredValue, $Type) {
$values = Get-ItemProperty $RegKey
	if ($values.$Name -ne $DesiredValue) {
		Set-ItemProperty -path $RegKey -name $Name -value $DesiredValue -type $Type
		"$RegKey$Name Set to $DesiredValue" >> $Logfile
		} else {
		"$RegKey$Name Already Set to $DesiredValue" >> $Logfile
		}
}

#Function to check if registry key exists and if not create it
Function CheckCreateRegKey ($RegPath) {
if ((Test-path $RegPath) -ne "True") {
	new-item -path $RegPath
	"$RegKey$Name Set to $DesiredValue" >> $Logfile
	} else {
	"$RegPath Already Exists" >> $Logfile
	}
}

#Function to check if Windows feature isntalled and if not install it
function CheckInstallFeature ($Feature) {
	$check = Get-WindowsFeature | Where-Object {$_.Name -eq $Feature}
	If ($check.Installed -ne "True") {
			#Install/Enable feature
			Add-WindowsFeature $Feature | Out-Null
			"$Feature installed" >> $LogFile
	} else {
	"$Feature already installed" >> $LogFile
	}
}



CheckInstallFeature SNMP-Services
CheckInstallFeature PowerShell-ISE


CheckCreateRegKey hklm:\SYSTEM\CurrentControlSet\services\SNMP\Parameters\TrapConfiguration\ckilog
CheckSetRegValue hklm:\SYSTEM\CurrentControlSet\services\SNMP\Parameters\TrapConfiguration\ckilog 1 10.4.72.85 string
CheckSetRegValue hklm:\SYSTEM\CurrentControlSet\services\SNMP\Parameters\TrapConfiguration\ckilog 2 10.231.74.35 string
CheckSetRegValue hklm:\SYSTEM\CurrentControlSet\services\SNMP\Parameters\ValidCommunities ckilog 4 dword
remove-itemproperty -path hklm:\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers -name 1