$strFilter = "computer"
 
$objDomain = New-Object System.DirectoryServices.DirectoryEntry
$objOU = New-Object System.DirectoryServices.DirectoryEntry("LDAP://DC=bnwww,DC=prod,DC=bn")
 
 
$objSearcher = New-Object System.DirectoryServices.DirectorySearcher
$objSearcher.SearchRoot = $objOU
$objSearcher.SearchScope = "Subtree" 
$objSearcher.PageSize = 1000 

$objSearcher.Filter = "(objectCategory=$strFilter)"

$colResults = $objSearcher.FindAll()

foreach ($i in $colResults) 
    {
        $objComputer = $i.GetDirectoryEntry()
	if ((gwmi Win32_PingStatus -Filter "Address='$objComputer.Name'").StatusCode –eq 0){      
	 write-host $objComputer.Name
	 }
    }