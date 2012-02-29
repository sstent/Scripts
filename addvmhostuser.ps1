
$VMhosts = Get-Content c:\error.txt
Foreach ($vmhost in $vmhosts){
connect-viserver $vmhost -user root -password 351iq814
connect-viserver $vmhost -user root -password s716X1aF
connect-viserver $vmhost -user root -password ^mIsC00l
connect-viserver $vmhost -user root -password "B@Rn3Z!)"

#rite-Output $vmhost.Name
#Get-VMHostAccount -Server $vmhost -ID sstent
Get-VMHostAccount -Server $vmhost -ID sstent | Remove-VMHostAccount -Confirm:$false
New-VMHostAccount -Server $vmhost -UserAccount sstent -Password "s4a9fN2]R" -AssignGroups "root" -GrantShellAccess
}



