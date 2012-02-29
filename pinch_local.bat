@echo off
for /f "DELIMS=/" %%s in (pinch_local.txt) do (
c:\pinch.exe %%s
IF ERRORLEVEL 1 (echo failed	%%s >>pinch_local.log) else (echo connected	%%s >>pinch_local.log )
)