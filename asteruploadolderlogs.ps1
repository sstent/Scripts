#get local systemname
$computer = gc env:computername


$iterations=@(-1,-2,-3,-4,-5,-6)

foreach ($i in $iterations)
{#get yesterdays date in mmddyyyy format
$yesterday=(get-date (get-date).AddDays($i) -uformat %m%d%Y)



#set filenames to use based on yesterdays date
$filename = "Recommendations_" +  $yesterday + ".log"
$newfilename = $computer + "_" +  $yesterday + ".log"

# FTP Config
$ftpuser = "asterftp"
$ftppass = "FTP4data"
$file = "D:\applog\StorePricingSvc\debuglogs\$filename"
$filenewname = "feeds/recommendation/recommendations/staging/$newfilename"
$ftpserver = "pnjtransfer02"
 
# FTP the log file matching $filename to the server using the $newfilename as the destination
$webclient = New-Object System.Net.WebClient
$ftp = "ftp://"+$ftpuser+":"+$ftppass+"@"+$ftpserver+"/"+$filenewname
$uri = New-Object System.Uri($ftp)
$webclient.UploadFile($uri,$file)
}