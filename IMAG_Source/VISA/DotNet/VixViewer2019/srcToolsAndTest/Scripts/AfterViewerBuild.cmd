::@echo off
setlocal EnableExtensions DisableDelayedExpansion
::MSBuild and VS build call this script to place files under the VIX Viewer Service's target folder (VAI-370)

::Set our variables removing the surrounding quotes from the command line (we'll add them later when needed)
set args=%*
set TargetDir=%~1
if "%~1"=="" goto BadArgs
shift
set SolutionDir=%~1
if "%~1"=="" goto BadArgs
shift
set ProjectDir=%~1
if "%~1"=="" goto BadArgs
shift
set OutDir=%~1
if "%~1"=="" goto BadArgs
shift
set Configuration=%~1
if "%~1"=="" goto BadArgs
goto GotArgs
:BadArgs
echo ERROR in syntax. You must supply TargetDir SolutionDir ProjectDir OutDir Configuration on the command line. (Given: %args%)
exit /b 1

:GotArgs
echo TargetDir is (%TargetDir%)
echo SolutionDir is (%SolutionDir%)
echo ProjectDir is (%ProjectDir%)
echo OutDir is (%OutDir%)
echo Configuration is (%Configuration%)
echo.

::Make the folders and files we need
if not exist %SolutionDir%build mkdir %SolutionDir%build
if not exist %SolutionDir%build\patchEnv.txt echo dev > %SolutionDir%build\patchEnv.txt
if exist "%TargetDir%Viewer" rmdir /q /s "%TargetDir%Viewer"
if exist "%TargetDir%Viewer" del "%TargetDir%Viewer"
echo mkdir "%TargetDir%Viewer"
mkdir "%TargetDir%Viewer"

::Generate the API doc if not on Jenkins
pushd %ProjectDir%doc
if not exist "skipGen.txt" call doGenInVs.cmd %SolutionDir%build\patchEnv.txt
popd
echo copy "%ProjectDir%doc\VVSDoc.html" "%TargetDir%Viewer\VVSDoc.html"
copy "%ProjectDir%doc\VVSDoc.html" "%TargetDir%Viewer\VVSDoc.html"
set result=%ERRORLEVEL%
if %result% neq 0 goto AllDone

::JavaScript, CSS, and HTML
if "%Configuration%"=="Release" goto DoRelease
::vvvvvvvvvvvvvvvvvvvv DEBUG vvvvvvvvvvvvvvvvvvvv
robocopy "%SolutionDir%src\Hydra.Web\Client\Develop" "%TargetDir%Viewer" /E /IS /NFL /NDL
set result=%ERRORLEVEL%
::echo result is (%result%)
::Less than 8 is a good result code from robocopy
if %result% lss 8 goto DoneJSDebug
set result=1
goto AllDone
:DoneJSDebug
echo move "%TargetDir%Viewer\assets\favicon.ico" "%TargetDir%Viewer"
move "%TargetDir%Viewer\assets\favicon.ico" "%TargetDir%Viewer"
set result=%ERRORLEVEL%
rmdir /q /s "%TargetDir%Viewer\assets"
if %result% neq 0 goto AllDone
goto DoneJS
::^^^^^^^^^^^^^^^^^^^^^ DEBUG ^^^^^^^^^^^^^^^^^^^^

::vvvvvvvvvvvvvvvvvvvv RELEASE vvvvvvvvvvvvvvvvvvvv
:DoRelease
robocopy "%SolutionDir%src\Hydra.Web\Client\Release" "%TargetDir%Viewer" /E /IS /NFL /NDL /MOVE
set result=%ERRORLEVEL%
::echo result is (%result%)
::Less than 8 is a good result code from robocopy
if %result% lss 8 goto DoneJS
set result=1
goto AllDone
::^^^^^^^^^^^^^^^^^^^^ RELEASE ^^^^^^^^^^^^^^^^^^^^

:DoneJS
if not exist "%TargetDir%Viewer\js\sessionscript" mkdir "%TargetDir%Viewer\js\sessionscript"
robocopy "%SolutionDir%packages\Microsoft.AspNet.SignalR.JS.2.2.0\content\Scripts" "%TargetDir%Viewer\js\sessionscript" /E /IS /NFL /NDL
set result=%ERRORLEVEL%
::echo result is (%result%)
::Less than 8 is a good result code from robocopy
if %result% lss 8 goto DoneJSSignalRDone1
set result=1
goto AllDone
:DoneJSSignalRDone1
echo copy "%SolutionDir%packages\json2.1.0.2\content\Scripts\json2.min.js" "%TargetDir%Viewer\js\sessionscript"
copy "%SolutionDir%packages\json2.1.0.2\content\Scripts\json2.min.js" "%TargetDir%Viewer\js\sessionscript"
set result=%ERRORLEVEL%
if %result% neq 0 goto AllDone

echo copy "%ProjectDir%..\Hydra.VistA.Worker\%OutDir%Hydra.VistA.Worker.exe" "%TargetDir%Hydra.VistA.Worker.exe"
copy "%ProjectDir%..\Hydra.VistA.Worker\%OutDir%Hydra.VistA.Worker.exe" "%TargetDir%Hydra.VistA.Worker.exe"
set result=%ERRORLEVEL%
if %result% neq 0 goto AllDone

echo copy "%ProjectDir%..\Hydra.VistA.Worker\%OutDir%Hydra.VistA.Worker.pdb" "%TargetDir%Hydra.VistA.Worker.pdb"
copy "%ProjectDir%..\Hydra.VistA.Worker\%OutDir%Hydra.VistA.Worker.pdb" "%TargetDir%Hydra.VistA.Worker.pdb"
set result=%ERRORLEVEL%

:AllDone
echo Exiting with code %result%
exit /b %result%
