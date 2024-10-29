@echo off
::Script to minify the client-side/front-end code using modern JS/ES.
::NOTE: THIS SCRIPT IS AUTOMATICALLY CALLED WHEN THE SOLUTION CONFIGURATION IS Release, AND MUST BE CALLED BEFORE doBuildPreEs6*.cmd.
::ARGUMENTS: dateTimeStamp or filePath
::dobuild only calls this with the dateTimeStamp. The filePath arg is only used for debugging this script for possibly adding the file in here.
setlocal

if not "%~1"=="" goto GotArgs
echo ERROR: Missing date/time-stamp command line argument in the yyyymmddhhmmss format. Abandoning build. 1>&2
set result=1
goto BuildIsDone

:GotArgs
::Unique temp file path for running this script in multiple concurrent processes
set ToolsFolder=..\..\..\..\srcToolsAndTest
for /f %%a in ('%ToolsFolder%\Scripts\GetTempFilePath.cmd') do set TEMP_FILE=%%a

::dateTimeStamp is used for setting the version in some .cshtml files to force browser not to use cached version
::if the first arg is only digits, we assume it is a dateTimeStamp and not a filePath
set dateTimeStamp=%~1
set allDigits=0
call :removeDigits %dateTimeStamp% allDigitsRemoved
if "%allDigitsRemoved%"=="" set allDigits=1
set allFiles=1
if "%allDigits%"=="0" set allFiles=0
if "%allFiles%"=="1" goto CheckFolder
set oneFile=%dateTimeStamp%
::Need to get absolute file path if relative
call :getFileParts "%oneFile%"
set oneFileIn=%filePath%
set oneFileOut=%filePath:.js=.min.js%
if exist "%oneFileIn%" goto CheckFolder
echo ERROR: File not found: "%oneFile%". Abandoning minification. 1>&2
set result=1
goto BuildIsDone

::Make sure we are running in the Client\Build folder
:CheckFolder
set WasInScriptDirAtStart=true
set thisScriptsDirWithEndingBackslash=%~dp0
if "%cd%\"=="%thisScriptsDirWithEndingBackslash%" goto SetEsbuild
pushd "%thisScriptsDirWithEndingBackslash%"
set WasInScriptDirAtStart=false

:SetEsbuild
::Transitioned from old minification of Ant with build.xml and yuicompressor to new using CMD and esbuild (targeting ES10=ES2019 per https://trm.oit.va.gov/StandardPage.aspx?tid=5061#).
::Add  --log-level=verbose for troubleshooting
set esArgs=--minify --sourcemap --target=es2019
if exist "%ToolsFolder%\EXEs\esbuild.exe" goto GetESBuildPath
echo ERROR: File not found: "%ToolsFolder%\EXEs\esbuild.exe". Abandoning minification. 1>&2
set result=1
goto BuildIsDone
:GetESBuildPath
call :SetAbsolutePathOfRelative %ToolsFolder%\EXEs absoluteExesPath
set esbuildPath=%absoluteExesPath%\esbuild.exe

::Handle one file specified on command line
if "%oneFileIn%"=="" goto AllFiles
"%esbuildPath%" "%oneFileIn%" --outfile="%oneFileOut%" %esArgs%
set result=%ERRORLEVEL%
goto ReallyReallyDone

:AllFiles
if exist ..\Develop goto CheckNext1
echo ERROR: Folder not found: "..\Develop". Abandoning minification. 1>&2
set result=1
goto BuildIsDone
:CheckNext1
if exist ..\Release goto CheckNext2
echo ERROR: Folder not found: "..\Release". Please run dobuild.cmd. Abandoning minification. 1>&2
set result=1
goto BuildIsDone
:CheckNext2
call :SetAbsolutePathOfRelative ..\..\..\..\build\log  LOGDIR
call :SetAbsolutePathOfRelative ..\Develop srcFolder
call :SetAbsolutePathOfRelative ..\Release destFolder

echo ==================== dobuildPostEs6.cmd - BEGIN
echo Source Folder:      %srcFolder%
echo Destination Folder: %destFolder%
echo Log Folder:         %LOGDIR%

if exist "%LOGDIR%\buildClientStdout.txt" del "%LOGDIR%\buildClientStdout.txt"
if exist "%LOGDIR%\buildClientStderr.txt" del "%LOGDIR%\buildClientStderr.txt"

echo %dateTimeStamp% > "%LOGDIR%\buildClientStdout.txt"
echo Source Folder:      %srcFolder%     >> "%LOGDIR%\buildClientStdout.txt"
echo Destination Folder: %destFolder%    >> "%LOGDIR%\buildClientStdout.txt"
echo Log Folder:         %LOGDIR%        >> "%LOGDIR%\buildClientStdout.txt"

::************************************************** Minify ********************************************
"%esbuildPath%" "%srcFolder%\js\basic.js" --outfile="%destFolder%\js\basic.min.js" %esArgs%
if not "%ERRORLEVEL%"=="0" goto BuildFailed

"%esbuildPath%" "%srcFolder%\js\session.js" --outfile="%destFolder%\js\session.min.js" %esArgs%
if not "%ERRORLEVEL%"=="0" goto BuildFailed

echo SUCCESS >> "%LOGDIR%\buildClientStdOut.txt"
echo.
echo SUCCESS
set result=0

:BuildIsDone
if not exist "%LOGDIR%\buildClientStdOut.txt" goto FinallyDone
dir "%LOGDIR%\buildClientStd???.txt" | findstr /V "Volume is" | findstr /V "Volume Serial" | findstr /V "bytes free"
:FinallyDone
if "%WasInScriptDirAtStart%"=="false" popd
echo ==================== dobuildPostEs6.cmd - END
:ReallyReallyDone
exit /b %result%

:BuildFailed
echo FAILURE >> %LOGDIR%\buildClientStdOut.txt
echo .
echo FAILURE
set result=1
goto BuildIsDone


::SUBROUTINE - Given a string (arg 1 value), set var (arg 2 is the name) to empty string if arg 1 only contained digits
:removeDigits
setlocal
::Do NOT add a space after %~1
echo %~1| findstr /V /C:"[0-9]*" /R /X >%TEMP_FILE%
set /p tmpvar=<%TEMP_FILE%
endlocal & set "%~2=%tmpvar%"
goto :eof

::SUBROUTINE - Given a folder path, set variables for the parts of the path
:getFileParts
set filePath=%~f1
set fileDirPathWithEndingSlash=%~dp1
set fileOrBaseFolderNameNoExt=%~n1
set fileExtension=%~x1
goto :eof

::SUBROUTINE - Given a relativePath (arg 1 value), set var (arg 2 is the name) to the absolute path
:SetAbsolutePathOfRelative
setlocal
pushd "%~1"
echo %cd%>%TEMP_FILE%
set /p tmpvar=<%TEMP_FILE%
endlocal & set "%~2=%tmpvar%"
popd
goto :eof

