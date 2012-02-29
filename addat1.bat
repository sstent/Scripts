rem ##########script for deleted and recreating the AT1 job on servers#########


@echo off
for %%i in (server1,server2) do (

schtasks /delete /tn "at1" /f /s %%i
schtasks /create /tn "at1" /sc daily /st 20:00:00 /sd 04/19/2011 /tr "c:\netgen\tools\logman.pl" /ru "nt authority\system"  /s %%i

)