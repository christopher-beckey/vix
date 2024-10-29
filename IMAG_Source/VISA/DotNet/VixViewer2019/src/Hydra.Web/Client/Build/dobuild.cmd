@echo off
::Main script to minify the client-side/front-end code using new and old JS/ES
::NOTE: THIS SCRIPT IS AUTOMATICALLY CALLED WHEN THE SOLUTION CONFIGURATION IS Release
::NOTE: THIS SCRIPT GENERATES THE VIX.Viewer.Service\bin\x64\Release\Viewer FOLDER USING Client\Release AND Release.Temp AS TEMP FOLDERS
setlocal

call :getDateTime
set dateTimeStamp=%year%%month%%day%%hour%%min%%sec%

::Make sure we are running in the Client\Build folder
set WasInScriptDirAtStart=true
set thisScriptsDirWithEndingBackslash=%~dp0
if "%cd%\"=="%thisScriptsDirWithEndingBackslash%" goto PrepTheBuild
pushd "%thisScriptsDirWithEndingBackslash%"
set WasInScriptDirAtStart=false

:PrepTheBuild
::Clear out the client-side logs and the Release folder, then create it
set LOGDIR=..\..\..\..\build\log
if not exist %LOGDIR% mkdir %LOGDIR%
if exist "%LOGDIR%\buildClient*.txt" del "%LOGDIR%\buildClient*.txt"
if exist ..\Release rmdir /s/q ..\Release
mkdir ..\Release

::VAI-622: Split modern and legacy ECMAScript builds. Post must be run before Pre.
call dobuildPostEs6.cmd %dateTimeStamp%
  set ExitCode=%ERRORLEVEL%
  if not "%ExitCode%"=="0" goto BuildIsDone
call dobuildPreEs6.cmd %dateTimeStamp%
  set ExitCode=%ERRORLEVEL%

::End the script. The called scripts output the reports.
:BuildIsDone
if "%WasInScriptDirAtStart%"=="false" popd
exit /b %ExitCode%

::SUBROUTINE - Get the current date and time and set variables to the pieces of it
:getDateTime
for /f "tokens=2 delims==" %%G in ('wmic os get localdatetime /value') do set datetime=%%G
set year=%datetime:~0,4%
set month=%datetime:~4,2%
set day=%datetime:~6,2%
set hour=%datetime:~8,2%
set min=%datetime:~10,2%
set sec=%datetime:~12,2%
goto :eof
