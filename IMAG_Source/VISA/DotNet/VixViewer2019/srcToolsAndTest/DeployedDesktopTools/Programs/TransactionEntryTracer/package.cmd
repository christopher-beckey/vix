::@echo off
::Create a self-extracting EXE for TransactionEntryTracer
set result=1
if "%1"=="" goto eof
set result=0
if NOT "%1"=="Release" goto eof
set result=1
shift
if "%~1"=="" goto eof
if NOT EXIST "%~1" goto eof
set PROJECTDIR_WITH_ENDING_BACKSLASH=%~1
shift
if "%~1"=="" goto eof
set RELEASE_BIN_WITH_ENDING_BACKSLASH=%PROJECTDIR_WITH_ENDING_BACKSLASH%%~1
if NOT EXIST "%RELEASE_BIN_WITH_ENDING_BACKSLASH%" goto eof

::Does string have a trailing backslash? if so remove it 
IF %RELEASE_BIN_WITH_ENDING_BACKSLASH:~-1%==\ SET RELEASE_BIN=%RELEASE_BIN_WITH_ENDING_BACKSLASH:~0,-1%

SET TEMP_BIN_FOLDER=\temp\TransactionEntryTracer

if not exist "\temp" mkdir "\temp"
if exist "%TEMP_BIN_FOLDER%" rmdir /s /q "%TEMP_BIN_FOLDER%"
robocopy "%RELEASE_BIN%" "%TEMP_BIN_FOLDER%"
copy /Y %PROJECTDIR_WITH_ENDING_BACKSLASH%TransactionEntryTracer.sed "\temp\TransactionEntryTracer.sed"
pushd "\temp"
iexpress /N TransactionEntryTracer.sed
popd
move "\temp\TransactionEntryTracer.exe" "%PROJECTDIR_WITH_ENDING_BACKSLASH%"
set result=%ERRORLEVEL%

:eof
exit /b %result%