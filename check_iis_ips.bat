@echo off
xcopy c:\adsutil.vbs \\%1\c$\adsutil.vbs /y
psexec \\%1 cscript /nologo c:\adsutil.vbs GET W3SVC/1/ServerBindings 
psexec \\%1 cscript /nologo c:\adsutil.vbs GET W3SVC/2/ServerBindings 
psexec \\%1 cscript /nologo c:\adsutil.vbs GET W3SVC/3/ServerBindings 
psexec \\%1 cscript /nologo c:\adsutil.vbs GET W3SVC/4/ServerBindings 
psexec \\%1 cscript /nologo c:\adsutil.vbs GET W3SVC/5/ServerBindings 
psexec \\%1 cscript /nologo c:\adsutil.vbs GET W3SVC/6/ServerBindings
psexec \\%1 cscript /nologo c:\adsutil.vbs GET W3SVC/7/ServerBindings
psexec \\%1 cscript /nologo c:\adsutil.vbs GET W3SVC/8/ServerBindings
psexec \\%1 cscript /nologo c:\adsutil.vbs GET W3SVC/9/ServerBindings
psexec \\%1 cscript /nologo c:\adsutil.vbs ENUM /P W3SVC