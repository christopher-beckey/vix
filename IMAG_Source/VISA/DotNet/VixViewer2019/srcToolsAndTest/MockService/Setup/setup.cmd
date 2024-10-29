@echo off
::Setup to run the MockService
net.exe session 1>NUL 2>NUL || (Echo You need to run this script as an Administrator. & exit /b 1)

setlocal
set result=0

set D=src\VIX.Render.Service\VIX.Render.config

::Make sure we are running in the MockService\Setup folder
set WasInScriptDirAtStart=true
set thisScriptsDirWithEndingBackslash=%~dp0
if "%cd%"=="C:\" goto GetInTheRightFolder
if "%cd%\"=="%thisScriptsDirWithEndingBackslash%" goto Proceed1
:GetInTheRightFolder
pushd "%thisScriptsDirWithEndingBackslash%"
set WasInScriptDirAtStart=false

:Proceed1
set vixCacheFolder=C:\VixCache\va-image-region\660\icn(1008861107V475740)\26732Mock
call :MakeDir %vixCacheFolder%
call :MakeDir C:\VixConfig\MockService\imageImport
set xmlFolder=C:\VixConfig\MockService\xml
if exist %xmlFolder% rmdir /q /s %xmlFolder%
call :MakeDir %xmlFolder%

robocopy XML %xmlFolder% /E /IS /NFL /NDL /NJS
if %ERRORLEVEL% lss 8 goto Proceed2
echo ERROR: robocopy failed for XML folder. Abandoning script. 1>&2
set result=1
goto ScriptIsDone

:Proceed2
robocopy XML\ImagesToImport %vixCacheFolder% /E /IS /NFL /NDL /NJS
if %ERRORLEVEL% lss 8 goto Proceed3
echo ERROR: robocopy failed for XML folder. Abandoning script. 1>&2
set result=1
goto ScriptIsDone

:Proceed3
call:GetTargetDbPath
set warning=
call :MakeDir "%targetDbPath%" "empty"
set emptyDbParent=..\..\..\src\HIX\Hydra.IX.Database\Db
if exist "%emptyDbParent%" goto Proceed4
echo WARNING: "%emptyDbParent%" does not exist, so it cannot be copied.
set warning= (with warnings)
goto ScriptIsDone

:Proceed4
rmdir /q/s "%targetDbPath%"
if not exist "%targetDbPath%" goto Proceed5
echo Cannot delete "%targetDbPath%"
set result=1
goto ScriptIsDone

:Proceed5
::mkdir "%targetDbPath%"
robocopy %emptyDbParent% %targetDbPath% /E /IS /NFL /NDL /NJS
if %ERRORLEVEL% lss 8 goto DbIsDone
echo ERROR: robocopy failed for XML folder. Abandoning script. 1>&2
set result=1
:DbIsDone
set sqlExe=..\..\..\src3rdParty\sqlite3.exe
if exist "%sqlExe%" copy /Y "%sqlExe%" "%targetDbPath%" >nul

:ScriptIsDone
if "%result%"=="0" echo SUCCESS%warning%
if NOT "%result%"=="0" echo Make sure you are not running VIX.Render.Service
if "%WasInScriptDirAtStart%"=="false" popd
pause
exit /b %result%

::Given a folder path and optional action, make sure the folder path exists. If the action is "empty", delete all files in the folder.
:MakeDir
if not exist "%~1" goto CreateIt
if not "%~2"=="empty" goto :eof
del /q "%~1\*.*"
goto :eof
:CreateIt
mkdir "%~1"
if "%ERRORLEVEL%"=="0" goto :eof
echo ERROR: mkdir failed for "%1". Abandoning script. 1>&2
set result=1
goto ScriptIsDone

::SUBROUTINE-Given a folder path, set variables for the parts of the path
:getFileParts
set filePath=%~f1
set fileDirPath=%~dp1
set fileOrBaseFolderName=%~n1
set fileExtension=%~x1
goto :eof

::SUBROUTINE-Get the database folder from src\VIX.Render.Service\VIX.Render.config
:GetTargetDbPath
::Example: <Database DataSource="S:\Claire\___WIP\Db\SQLiteDb.db" CommandTimeout="300">
findstr /i "<Database DataSource" ..\..\..\src\VIX.Render.Service\VIX.Render.config | findstr /v "<!" > %TEMP%\temp1.txt
echo str = WScript.Stdin.Readline > %TEMP%\temp.vbs
echo ary = Split(str, chr(34)) >> %TEMP%\temp.vbs
echo pos = InstrRev(ary(1), "\") >> %TEMP%\temp.vbs
echo WScript.Stdout.Writeline Left(ary(1), pos) >> %TEMP%\temp.vbs
cscript "%TEMP%\temp.vbs" //nologo <"%TEMP%\temp1.txt" >"%TEMP%\temp2.txt"
set /p targetDbPath=<"%TEMP%\temp2.txt"
goto :eof