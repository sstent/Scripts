function Register-VMX {
	param($entityName = $null,$dsNames = $null,$template = $true,$ignore = $null,$checkNFS = $false,$whatif=$false)

	function Get-Usage{
		Write-Host "Parameters incorrect" -ForegroundColor red
		Write-Host "Register-VMX -entityName  -dsNames [,...]"
		Write-Host "entityName   : a cluster-, datacenter or ESX hostname (not together with -dsNames)"
		Write-Host "dsNames      : one or more datastorename names (not together with -entityName)"
		Write-Host "ignore       : names of folders that shouldn't be checked"
		Write-Host "template     : register guests ($false)or templates ($true) - default : $false"
		Write-Host "checkNFS     : include NFS datastores - default : $false"
		Write-Host "whatif       : when $true will only list and not execute - default : $false"
	}

	if(($entityName -ne $null -and $dsNames -ne $null) -or ($entityName -eq $null -and $dsNames -eq $null)){
		Get-Usage
		break
	}

	if($dsNames -eq $null){
		switch((Get-Inventory -Name $entityName).GetType().Name.Replace("Wrapper","")){
			"Cluster"{
				$dsNames = Get-Cluster -Name $entityName | Get-VMHost | Get-Datastore | where {$_.Type -eq "VMFS" -or $checkNFS} | % {$_.Name}
			}
			"Datacenter"{
				$dsNames = Get-Datacenter -Name $entityName | Get-Datastore | where {$_.Type -eq "VMFS" -or $checkNFS} | % {$_.Name}
			}
			"VMHost"{
				$dsNames = Get-VMHost -Name $entityName | Get-Datastore | where {$_.Type -eq "VMFS" -or $checkNFS} | % {$_.Name}
			}
			Default{
				Get-Usage
				exit
			}
		}
	}
	else{
		$dsNames = Get-Datastore -Name $dsNames | where {$_.Type -eq "VMFS" -or $checkNFS} | Select -Unique | % {$_.Name}
	}

	$dsNames = $dsNames | Sort-Object
	$pattern = "*.vmx"
	if($template){
		$pattern = "*.vmtx"
	}

	foreach($dsName in $dsNames){
		Write-Host "Checking " -NoNewline; Write-Host -ForegroundColor red -BackgroundColor yellow $dsName
		$ds = Get-Datastore $dsName | Select -Unique | Get-View
		$dsBrowser = Get-View $ds.Browser
		$dc = Get-View $ds.Parent
		while($dc.MoRef.Type -ne "Datacenter"){
			$dc = Get-View $dc.Parent
		}
		$tgtfolder = Get-View $dc.VmFolder
		$esx = Get-View $ds.Host[0].Key
		$pool = Get-View (Get-View $esx.Parent).ResourcePool

		$vms = @()
		foreach($vmImpl in $ds.Vm){
			$vm = Get-View $vmImpl
			$vms += $vm.Config.Files.VmPathName
		}
		$datastorepath = "[" + $ds.Name + "]"

		$searchspec = New-Object VMware.Vim.HostDatastoreBrowserSearchSpec
		$searchspec.MatchPattern = $pattern

		$taskMoRef = $dsBrowser.SearchDatastoreSubFolders_Task($datastorePath, $searchSpec)

		$task = Get-View $taskMoRef
		while ("running","queued" -contains $task.Info.State){
			$task.UpdateViewData("Info.State")
		}
		$task.UpdateViewData("Info.Result")
		foreach ($folder in $task.Info.Result){
			if(!($ignore -and (&{$res = $false; $folder.FolderPath.Split("]")[1].Trim(" /").Split("/") | %{$res = $res -or ($ignore -contains $_)}; $res}))){
				$found = $FALSE
				if($folder.file -ne $null){
					foreach($vmx in $vms){
						if(($folder.FolderPath + $folder.File[0].Path) -eq $vmx){
							$found = $TRUE
						}
					}
					if (-not $found){
						if($folder.FolderPath[-1] -ne "/"){$folder.FolderPath += "/"}
						$vmx = $folder.FolderPath + $folder.File[0].Path
						if($template){
							$params = @($vmx,$null,$true,$null,$esx.MoRef)
						}
						else{
							$params = @($vmx,$null,$false,$pool.MoRef,$null)
						}
						if(!$whatif){
							$taskMoRef = $tgtfolder.GetType().GetMethod("RegisterVM_Task").Invoke($tgtfolder, $params)
							Write-Host "`t" $vmx "registered"
						}
						else{
							Write-Host "`t" $vmx "registered" -NoNewline; Write-Host -ForegroundColor blue -BackgroundColor white " ==> What If"
						}
					}
				}
			}
		}
		Write-Host "Done"
	}
}

Connect-VIServer bnjvcenter03
Register-VMX -entityName "Monroe Dev-SI" 
Register-VMX -entityName "Monroe Prod Clusters" 
Register-VMX -entityName "Production vHosts" 
Disconnect-Viserver -confirm:$false

Connect-VIServer bnjvcenter04
Register-VMX -entityName "Monroe Dev-QA"
Register-VMX -entityName "ProdVhosts"
Register-VMX -entityName "RenoVhosts"
Disconnect-Viserver -confirm:$false