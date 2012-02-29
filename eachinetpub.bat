@echo off
set _ping_cmd=ping -n 1


rem Class
for %%a in (Pwpweb,Netcart,Mcart,Buybackweb,Srchres,Cpsrchres,Commweb,Mvp,Web,Mktplw,Eaiextgw,Slprtweb,Edsweb,Syncsvc,Edssvc,Dcdload,Spweb,Member,Strlocweb,Coreweb,Image,Websp,Digedweb,Cloudcart,Hpnetcart,Hpmcart,Hpweb,Hpcommweb,Hpcpsrchres,Hpsrchres,Ordsweb,Soaphub,pfssoap,Mercapp,Strevent,svcwapp,Payserv,Dcsvc,Coreservice,Pfssoap,Pwpsvc,Paytech,Vertex,Eaiorders,Eaisapgw,Eaifeeds,Eaivndrs,Bqvcs,Ugc,Store,Websvcs,Ivr,Cloudcart,Edssvc,Edsconv,Cdsapp,Memapp) do (

rem site
for %%c in (pny,pnj,pcw,ppa,pwb) do (

rem server number
for %%d in (01,02,03,04,05,06,07,08,09,10,11,12) do (
rem directories
echo TESTING: \\%%c%%a%%d\
for /f "tokens=4 delims=(=" %%y in ('%_ping_cmd% %%c%%a%%d ^|find "loss"') do (if "%%y"==" 0 " (for /f "delims=|" %%f in ('dir /A:D /b \\%%c%%a%%d\d$\inetpub') do (echo F | xcopy c:\simple.htm  \\%%c%%a%%d\d$\inetpub\%%f\simple.htm  /V /F /Y)))

)
)
)


rem & 

