@echo off
for /f "DELIMS=/" %%q in (serverlist.txt) do (
xcopy /y c:\pinch.exe \\%%q\c$\pinch.exe
for /f "DELIMS=/" %%s in (%%q.txt) do (
psexec \\%%q c:\pinch.exe %%s
IF ERRORLEVEL 1 (echo %%q,failed,%%s >>pinch.log) else (echo %%q,connected,%%s >>pinch.log )
)

)