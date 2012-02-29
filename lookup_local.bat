@echo off
SETLOCAL EnableDelayedExpansion
set servername=
for /f "DELIMS=/" %%s in (lookup_local.txt) do (
FOR /F "tokens=2 delims=: " %%J IN ('NSLOOKUP %%s ^| FIND "Name:    "') DO set servername=%%J
echo connected	%%s	!servername! >>lookup_local.log
)