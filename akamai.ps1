#input should finish at inetpub\images\ \\inystg01\inetpub\software-releases\NookApps-06-29\Images-06-29-NookApps21-Final\InetPub\images"

$find = $Args[0]

$rep="http://images.barnesandnoble.com"
get-childitem -recurse $args[0] | foreach-object -process { $_.FullName } | %{$_ -replace [regex]::Escape($find), $rep} |  %{$_ -replace '\\','/'} > c:\akamai.txt


$rep="http://simg1.imagesbn.com"
get-childitem -recurse $Args[0] | foreach-object -process { $_.FullName } | %{$_ -replace [regex]::Escape($find), $rep} |  %{$_ -replace '\\','/'} >> c:\akamai.txt


$rep="http://simg2.imagesbn.com"
get-childitem -recurse $Args[0] | foreach-object -process { $_.FullName } | %{$_ -replace [regex]::Escape($find), $rep} |  %{$_ -replace '\\','/'} >> c:\akamai.txt


$rep="http://sjs.barnesandnoble.com"
get-childitem -recurse $Args[0] | foreach-object -process { $_.FullName } | %{$_ -replace [regex]::Escape($find), $rep} |  %{$_ -replace '\\','/'} >> c:\akamai.txt