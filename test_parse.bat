REM @echo off
setlocal
SETLOCAL EnableDelayedExpansion
set strtype=

	for /f "DELIMS=<> TOKENS=2" %%i in ("p<ny,nj>test<01-04>") do (
		for /f "DELIMS=, TOKENS=1,2" %%j in ("%%i") do (
			echo %%j  %%k
			set site1=%%j
			set site2=%%k
			IF DEFINED l set site3=%%l
		)
	)
	
	echo testa
	
	for /f "DELIMS=<> TOKENS=4" %%m in ("p<ny,nj>test<01,04>") do ( 
		echo test1
		echo %%m
		for /f "tokens=1 delims=" %%p in ('echo %%m ^| find "-" /c') do (set result=%%p)

		if !result! == 1 (
			set strtype=1
			echo strtype=1
		) else (
			echo "else"
			for /f "delims=" %%q in ('echo '%%m' ^| find "," /c') do (set result=%%q)

			If !result! == 1 ( 
				set strtype=2 
				echo strtype=2 
			)
		)
			
		echo %strtype%
		echo ooo
		REM if %strtype%==1 (
			REM for /f "DELIMS=- TOKENS=1,2" %%j in ("%%m") do (
				REM set server1=%%j
				REM set server2=%%k
			REM )
		REM ) else 	( 
			REM if %strtype%==2 (
				REM for /f "DELIMS=, TOKENS=1,2" %%j in ("%%i") do (
				REM set server1=%%j
				REM set server2=%%k
				REM )
				REM )
			REM )

IF DEFINED site1 echo %site1%
IF DEFINED site2 echo %site2%
IF DEFINED site3 echo %site3%
IF DEFINED server1 echo %server1%
IF DEFINED server2 echo %server2%
endlocal