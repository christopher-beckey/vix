@echo off
::THIS SCRIPT IS ONLY RUN ON THE BUILD SERVER
::Three positional command line arguments: VersionNumber ProductType GitPath, all optional (but since they're positional, you need to consider that)
set VersionNumber=30.999.9.9999
set ProductType=-t VIX
set GitWorkingFolder=
::%~1 means to take the first argument and remove any surrounding double quotes
if "%~1"=="" goto DoneArgs
set VersionNumber=%1
shift
if "%~1"=="" goto DoneArgs
set ProductType=-t %1
shift
if "%~1"=="" goto DoneArgs
set GitWorkingFolder=%~1
set GitWorkingFolder=-g "%GitWorkingFolder%"
:DoneArgs
if exist build\logBAK rmdir /Q /S build\logBAK
if exist build\log (pushd build && rename log logBAK && popd)
if not exist build\log mkdir build\log
@echo call build -d -e prod -v %VersionNumber% %ProductType% -c Release -p %GitWorkingFolder% 1>build\log\buildStdout.txt 2>build\log\buildStderr.txt
call build.cmd -d -e prod -v %VersionNumber% %ProductType% -c Release -p %GitWorkingFolder% 1>build\log\buildStdout.txt 2>build\log\buildStderr.txt
set myErrorLevel=%ERRORLEVEL%
if not %myErrorLevel% equ 0 EXIT /B %myErrorLevel%
dir build\log
@echo.
@echo **************************************** RELEASE ****************************************
@echo.
type build\log\*Release.txt
@echo.
@echo **************************************** STDERR ****************************************
@echo.
type build\log\buildStderr.txt
@echo.
@echo **************************************** STDOUT ****************************************
@echo.
type build\log\buildStdout.txt 
@echo.
@echo **************************************** RESULT ****************************************
@echo.
findstr "Warning(s)" build\log\*Release.txt && findstr "Error(s)" build\log\*Release.txt && findstr /b "Time Elapsed " build\log\*Release.txt
