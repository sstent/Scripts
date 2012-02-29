$erroractionpreference = "SilentlyContinue"
$a = New-Object -comobject Excel.Application
$a.visible = $True 

$b = $a.Workbooks.Add()
$c = $b.Worksheets.Item(1)

$c.Cells.Item(1,1) = "Server"
$c.Cells.Item(1,2) = "IP Address"
$c.Cells.Item(1,3) = "WB Ping Status"
$c.Cells.Item(1,4) = "NY Ping Status"

$d = $c.UsedRange
$d.Interior.ColorIndex = 19
$d.Font.ColorIndex = 11
$d.Font.Bold = $True
$d.EntireColumn.AutoFit($True)

$intRow = 2

$list = Import-Csv C:\Serverlist1.txt
#$colComputers = get-content C:\Serverlist1.txt
foreach($entry in $list)
#foreach ($strComputer in $colComputers)
{
$entry.IPAddress
$c.Cells.Item($intRow, 1) = $entry.ServerName
$c.Cells.Item($intRow, 2) = $entry.IPAddress

#ServerName,IPAddress
$ping = new-object System.Net.NetworkInformation.Ping
$Reply = $ping.send($entry.ServerName)
if ($Reply.status –eq “Success”) 
{
$c.Cells.Item($intRow, 4) = “Online”
}
else 
{
$c.Cells.Item($intRow, 4) = "Offline"
}
$Reply = ""




# $Reply = $ping.send($entry.IPAddress)
# if ($Reply.status –eq “Success”) 
# {
# $c.Cells.Item($intRow, 3) = “Online”
# }
# else 
# {
# $c.Cells.Item($intRow, 3) = "Offline"
# }
# $Reply = ""


 $intRow = $intRow + 1

# }
$d.EntireColumn.AutoFit()
}