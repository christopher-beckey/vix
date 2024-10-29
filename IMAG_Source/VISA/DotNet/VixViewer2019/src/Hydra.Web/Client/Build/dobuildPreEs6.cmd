@echo off
::Script to build Client-side/Front-end before ES6. Gradually transitioning all of the files here and in build.xml to post-ES6.
::NOTE: THIS SCRIPT IS AUTOMATICALLY CALLED WHEN THE SOLUTION CONFIGURATION IS Release.
::ARGUMENT: dateTimeStamp
setlocal

if not "%~1"=="" goto GotArgs
echo ERROR: Missing date/time-stamp command line argument in the yyyymmddhhmmss format. Abandoning build. 1>&2
set result=1
goto ReallyReallyDone

:GotArgs
::This is used for setting the version in some .cshtml files to force browser not to use cached version
set dateTimeStamp=%~1

if exist %ANT_HOME%\bin\ant.cmd goto Proceed
echo %ANT_HOME%\bin\ant.cmd does not exist. Build abandoned.
goto :eof

:Proceed
set LOGDIR=..\..\..\..\build\log
if not exist %LOGDIR% mkdir %LOGDIR%

echo ==================== dobuildPreEs6.cmd - BEGIN
echo %dateTimeStamp% > "%LOGDIR%\buildClientStdoutPreEs6.txt"
::NOTE: YOU CAN ADD -verbose TO ANT TO SEE MORE INFO
echo call %ANT_HOME%\bin\ant ^> %LOGDIR%\buildClientStdoutPreEs6.txt 2^> %LOGDIR%\buildClientStdErrPreEs6.txt
call %ANT_HOME%\bin\ant -DcurrentDateTime=%dateTimeStamp% >> %LOGDIR%\buildClientStdoutPreEs6.txt 2> %LOGDIR%\buildClientStdErrPreEs6.txt

dir %LOGDIR%\buildClient*PreEs6.txt | findstr /V "Volume is" | findstr /V "Volume Serial" | findstr /V "bytes free"
findstr "ERROR" %LOGDIR%\buildClientStdoutPreEs6.txt >nul
set result=%ERRORLEVEL%
if "%result%"=="1" goto NoErrors
echo ERRORs found in %LOGDIR%\buildClientStdoutPreEs6.txt
echo.
echo BUILD FAILED
set result=1
goto BuildDone
:NoErrors
echo.
findstr "SUCCESSFUL" %LOGDIR%\buildClientStdOutPreEs6.txt
set result=%ERRORLEVEL%
findstr "FAILED" %LOGDIR%\buildClientStdErrPreEs6.txt
:BuildDone
echo ==================== dobuildPreEs6.cmd - END
:ReallyReallyDone
exit /b %result%