
REM COMMWEB1
for /f %%1 in (commweb.txt) do (
robocopy \\inystg01\inetpub\software-releases\cpsrchres-0201-SolrSearch303040\InetPub\books\quicksearch\bin \\%%1\d$\InetPub\Community\quicksearch\bin bn.webutils.dll.config /log+:deploy1.log /r:1 /w:1
robocopy \\inystg01\inetpub\software-releases\cpsrchres-0201-SolrSearch303040\InetPub\books\quicksearch\bin \\%%1\d$\InetPub\Wizard\quicksearch\bin bn.webutils.dll.config /log+:deploy1.log /r:1 /w:1
)

REM STRLOCWEB
for /f %%1 in (strlocweb.txt) do (
robocopy \\inystg01\inetpub\software-releases\cpsrchres-0201-SolrSearch303040\InetPub\books\quicksearch\bin \\%%1\d$\InetPub\Kids\quicksearch\bin bn.webutils.dll.config /log+:deploy1.log /r:1 /w:1
robocopy \\inystg01\inetpub\software-releases\cpsrchres-0201-SolrSearch303040\InetPub\books\quicksearch\bin \\%%1\d$\InetPub\StoreLocator\quicksearch\bin bn.webutils.dll.config /log+:deploy1.log /r:1 /w:1
)
REM NETCART
for /f %%1 in (netcart.txt) do (
robocopy \\inystg01\inetpub\software-releases\cpsrchres-0201-SolrSearch303040\InetPub\books\quicksearch\bin \\%%1\d$\InetPub\Cart\quicksearch\bin bn.webutils.dll.config /log+:deploy1.log /r:1 /w:1
)
REM SRCHRES
for /f %%1 in (srchres.txt) do (
robocopy \\inystg01\inetpub\software-releases\cpsrchres-0201-SolrSearch303040\InetPub\books\quicksearch\bin \\%%1\d$\InetPub\SEARCHRES\quicksearch\bin bn.webutils.dll.config /log+:deploy1.log /r:1 /w:1
)
REM SRCHRES
for /f %%1 in (mvp.txt) do (

robocopy \\inystg01\inetpub\software-releases\cpsrchres-0201-SolrSearch303040\InetPub\books\quicksearch\bin \\%%1\d$\InetPub\Gifts\QuickSearch\bin bn.webutils.dll.config /log+:deploy1.log /r:1 /w:1

)