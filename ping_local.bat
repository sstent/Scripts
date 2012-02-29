@echo off
for /f "DELIMS=/" %%s in (ping_local.txt) do (
ping -n 1 %%s

IF ERRORLEVEL 1 (echo failed	%%s >>ping_local.log) else (echo connected	%%s >>ping_local.log )
)