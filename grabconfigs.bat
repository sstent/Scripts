@echo off
REM GRAB configs

call:COPYCONFIGS pnyugc03
call:COPYCONFIGS pnymktplweb01
call:COPYCONFIGS pnyordsweb01
call:COPYCONFIGS pnyivr01
call:COPYCONFIGS pnycloudcart01



GOTO:EOF

:COPYCONFIGS
robocopy \\%1\c$\windows\system32\drivers\etc \\Bnyfsfile04\serverconnections\configs\%1 hosts /e /r:1 /w:1
robocopy \\%1\c$\winnt\system32\drivers\etc \\Bnyfsfile04\serverconnections\configs\%1 hosts /e /r:1 /w:1
robocopy \\%1\d$\Oracle \\Bnyfsfile04\serverconnections\configs\%1\Oracle tnsnames* /s /XD assistants BIN cdata cfgtoollogs css diagnostics has install inventory jdbc jdk jlib jre ldap lib nls oci ODP.NET oledb OPatch oracore oui owm plsql precomp RDBMS relnotes slax sqlplus srvm sysman uix xdk SAMPLE tools
robocopy \\%1\d$\Components \\Bnyfsfile04\serverconnections\configs\%1\Components *.* /e 
robocopy \\%1\d$\dotnetconfig \\Bnyfsfile04\serverconnections\configs\%1\dotnetconfig *.* /e 
robocopy \\%1\d$ \\Bnyfsfile04\serverconnections\%1\configs web.config /s
robocopy \\%1\d$ \\Bnyfsfile04\serverconnections\%1\configs global.asa /s
GOTO:EOF