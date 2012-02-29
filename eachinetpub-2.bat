@echo off
set _ping_cmd=ping -n 1
for %%a in (hpmvp) do (
for %%c in (pny,pnj,pcw,ppa,pwb) do (
for %%d in (1,2,3,4,5,6,7,8,9) do (
echo TESTING: \\%%c%%a%%d\
for /f "tokens=4 delims=(=" %%y in ('%_ping_cmd% %%c%%a%%d ^|find "loss"') do (if "%%y"==" 0 " (for /f "delims=|" %%f in ('dir /A:D /b \\%%c%%a%%d\d$\inetpub') do (echo F | xcopy c:\simple.htm  \\%%c%%a%%d\d$\inetpub\%%f\simple.htm  /V /F /Y)))
)
)
)



PNYACSAPP03
bnfraud???


pnjedssvc06





