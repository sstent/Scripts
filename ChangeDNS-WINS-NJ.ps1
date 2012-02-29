# Paste the script below into a PowerShell prompt

get-content c:\computernamesnj.txt | foreach {

$Server = $_
$NICs = Get-WMIObject Win32_NetworkAdapterConfiguration -computername $Server -filter "IpEnabled=True"

Foreach ($NIC in $NICs) {

	if ($NIC.DNSServerSearchOrder -ne $null) {	
		#Gets the individual NIC adapter name based on the index number of the NIC
		$Adapter = Get-WMIObject Win32_NetworkAdapter -computername $Server | where {$_.index -eq $NIC.index} 
		write-host "name " $Adapter.NetConnectionID

		#we need to convert this to a normal variable so that we can use it nicely later
		$interface = $Adapter.NetConnectionID
		
		#sets wins based on the NIC name
		#compiles scriptblocks first to allow us to add a varible into the command
		$sb1 = [scriptblock]::create('psexec \\$Server netsh interface ip add wins $Interface 10.4.72.40 index=1')
		$sb2 = [scriptblock]::create('psexec \\$Server netsh interface ip add wins $Interface 10.4.72.41 index=2')
		$sb3 = [scriptblock]::create('psexec \\$Server netsh interface ip add wins $Interface 10.0.0.1 index=3')		

		#invokes the compiled commadn on the remote server		
		Invoke-Command -ScriptBlock $sb1
		Invoke-Command -ScriptBlock $sb2
		Invoke-Command -ScriptBlock $sb3
		}
	}
}
