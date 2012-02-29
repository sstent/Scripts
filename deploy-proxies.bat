for %%i in (1,2,3,4,5,6,7,8,9) do (
rem p<ny,nj>mvp<01..n>
rem ---------------------------------
robocopy \\inystg01\inetpub\software-releases\mvp-0428-navRedesign\InetPub\Gifts\proxies \\pnymvp0%%i\d$\inetpub\gifts\proxies *.* /z /e  /r:1 /w:1
robocopy \\inystg01\inetpub\software-releases\mvp-0428-navRedesign\InetPub\music\proxies \\pnymvp0%%i\d$\inetpub\music\proxies *.* /z /e  /r:1 /w:1
robocopy \\inystg01\inetpub\software-releases\mvp-0428-navRedesign\InetPub\video\proxies \\pnymvp0%%i\d$\inetpub\video\proxies *.* /z /e  /r:1 /w:1
robocopy \\inystg01\inetpub\software-releases\mvp-0428-navRedesign\InetPub\videogames\proxies \\pnymvp0%%i\d$\inetpub\videogames\proxies *.* /z /e  /r:1 /w:1
rem p<ny,pa>srchres<01..n>
rem ---------------------------------
robocopy \\inystg01\inetpub\software-releases\searchres-0428-navRedesign\InetPub\SEARCHRES\proxies \\pnysrchres0%%i\d$\inetpub\searchres\proxies *.* /z /e  /r:1 /w:1
robocopy \\inystg01\inetpub\software-releases\searchres-0428-navRedesign\InetPub\SEARCHRES\bookproduct\proxies \\pnysrchres0%%i\d$\inetpub\searchres\bookproduct\proxies *.* /z /e  /r:1 /w:1

rem p<ny,nj>commweb<01..n>
rem ---------------------------------
robocopy \\inystg01\inetpub\software-releases\commweb-0428-navRedesign\InetPub\Community\proxies \\pnycommweb0%%i\d$\inetpub\community\proxies *.* /z /e  /r:1 /w:1
)


for %%i in (1,2,3,4,5,6,7,8,9) do (
rem p<ny,nj>mvp<01..n>
rem ---------------------------------
robocopy \\inystg01\inetpub\software-releases\mvp-0428-navRedesign\InetPub\Gifts\proxies \\pnjmvp0%%i\d$\inetpub\gifts\proxies *.* /z /e  /r:1 /w:1
robocopy \\inystg01\inetpub\software-releases\mvp-0428-navRedesign\InetPub\music\proxies \\pnjmvp0%%i\d$\inetpub\music\proxies *.* /z /e  /r:1 /w:1
robocopy \\inystg01\inetpub\software-releases\mvp-0428-navRedesign\InetPub\video\proxies \\pnjmvp0%%i\d$\inetpub\video\proxies *.* /z /e  /r:1 /w:1
robocopy \\inystg01\inetpub\software-releases\mvp-0428-navRedesign\InetPub\videogames\proxies \\pnjmvp0%%i\d$\inetpub\videogames\proxies *.* /z /e  /r:1 /w:1
rem p<ny,pa>srchres<01..n>
rem ---------------------------------
robocopy \\inystg01\inetpub\software-releases\searchres-0428-navRedesign\InetPub\SEARCHRES\proxies \\ppasrchres0%%i\d$\inetpub\searchres\proxies *.* /z /e  /r:1 /w:1
robocopy \\inystg01\inetpub\software-releases\searchres-0428-navRedesign\InetPub\SEARCHRES\bookproduct\proxies \\ppasrchres0%%i\d$\inetpub\searchres\bookproduct\proxies *.* /z /e  /r:1 /w:1

rem p<ny,nj>commweb<01..n>
rem ---------------------------------
robocopy \\inystg01\inetpub\software-releases\commweb-0428-navRedesign\InetPub\Community\proxies \\pnjcommweb0%%i\d$\inetpub\community\proxies *.* /z /e /r:1 /w:1
)