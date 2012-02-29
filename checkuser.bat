for %%i in (pnywebsp03) do (
psexec \\%%i net user 47ecrivez
ECHO.%ERRORLEVEL%
)