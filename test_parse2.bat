@echo off
setlocal
SETLOCAL EnableDelayedExpansion
set strtype=
set "stringtotest=p<ny,pa,wb>test<01-9>"
for /f "DELIMS=<> TOKENS=1" %%i in ("%stringtotest%") do (set servertype=%%i)
for /f "DELIMS=<> TOKENS=3" %%i in ("%stringtotest%") do (set servername=%%i)

	for /f "DELIMS=<> TOKENS=2" %%i in ("%stringtotest%") do (
		for /f "DELIMS=, TOKENS=1,2,3" %%j in ("%%i") do (
			set site1=%%j
			set site2=%%k
			set site3=%%l
		)
	)

	for /f "DELIMS=<> TOKENS=4" %%a in ("%stringtotest%") do (
		for /f "tokens=1 delims=" %%p in ('echo %%a ^| find "-" /c') do set result=%%p
											set serverteststr=%%a
											if !result! == 1 (
												set strtype=1
											) else (
												for /f "delims=" %%q in ('echo %%a ^| find "," /c') do set result2=%%q
													If !result2! == 1 ( 
														set strtype=2 
													)
												)
				
				if !strtype!==1 (
					for /f "DELIMS=- TOKENS=1,2" %%j in ("!serverteststr!") do (
					set server1=%%j
					set server2=%%k
					)
				) else (
					for /f "DELIMS=, TOKENS=1-8" %%j in ("!serverteststr!") do (
					set server1=%%j
					set server2=%%k
					set server3=%%l
					set server4=%%m
					set server5=%%n
					set server6=%%o
					set server7=%%p
					set server8=%%q
					
					)
				)
		)
			



IF DEFINED site1 echo %site1%
IF DEFINED site2 echo %site2%
IF DEFINED site3 echo %site3%
IF DEFINED server1 echo %server1%
IF DEFINED server2 echo %server2%
REM strtype1 = range strtype2 = list
if !strtype!==1 (
FOR /L %%p IN (%server1%,1,%server2%) DO (echo %servertype%%site1%%servername%%%p)
FOR /L %%p IN (%server1%,1,%server2%) DO (echo %servertype%%site2%%servername%%%p)
) else (
if defined site1 (
	if defined server1 echo %servertype%%site1%%servername%%server1%
	if defined server2 echo %servertype%%site1%%servername%%server2%
	if defined server3 echo %servertype%%site1%%servername%%server3%
	if defined server4 echo %servertype%%site1%%servername%%server4%
	if defined server5 echo %servertype%%site1%%servername%%server5%
	if defined server6 echo %servertype%%site1%%servername%%server6%
	if defined server7 echo %servertype%%site1%%servername%%server7%
	if defined server8 echo %servertype%%site1%%servername%%server8%
	)
if defined site2 (
	if defined server1 echo %servertype%%site2%%servername%%server1%
	if defined server2 echo %servertype%%site2%%servername%%server2%
	if defined server3 echo %servertype%%site2%%servername%%server3%
	if defined server4 echo %servertype%%site2%%servername%%server4%
	if defined server5 echo %servertype%%site2%%servername%%server5%
	if defined server6 echo %servertype%%site2%%servername%%server6%
	if defined server7 echo %servertype%%site2%%servername%%server7%
	if defined server8 echo %servertype%%site2%%servername%%server8%
	)
if defined site3 (
	if defined server1 echo %servertype%%site3%%servername%%server1%
	if defined server2 echo %servertype%%site3%%servername%%server2%
	if defined server3 echo %servertype%%site3%%servername%%server3%
	if defined server4 echo %servertype%%site3%%servername%%server4%
	if defined server5 echo %servertype%%site3%%servername%%server5%
	if defined server6 echo %servertype%%site3%%servername%%server6%
	if defined server7 echo %servertype%%site3%%servername%%server7%
	if defined server8 echo %servertype%%site3%%servername%%server8%
	)
	
)

endlocal