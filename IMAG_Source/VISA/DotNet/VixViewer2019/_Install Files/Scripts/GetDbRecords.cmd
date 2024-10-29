::GetDbRecords {Debug|Release} (no default)
::Get the table names and their records from the database
@echo off
setlocal EnableExtensions DisableDelayedExpansion

if not "%~1"=="" goto Proceed1
:BadArg
echo ERROR: Either Debug or Release must be a command line argument
exit /b 1

:Proceed1
set config=%~1
if "%config%"=="Debug" goto Proceed2
if "%config%"=="Release" goto Proceed2
goto BadArg

:Proceed2
set thisScriptsDirWithEndingBackslash=%~dp0
set slnDir=%thisScriptsDirWithEndingBackslash%..\..
set dbScriptDir=%slnDir%\_Install Files\Scripts
set configPath=%slnDir%\src\VIX.Render.Service\VIX.Render.config
if "%config%"=="Debug" goto GetDbPath
set configPath=C:\Program Files\VistA\Imaging\VIX.Config\VIX.Render.config
:GetDbPath
echo.>"%TEMP%\getDbRecs.txt
cscript //nologo "%thisScriptsDirWithEndingBackslash%GetDbPath.vbs" "%configPath%" > "%TEMP%\getDbRecs.txt"
set /p dbPath=<"%TEMP%\getDbRecs.txt"
if "%dbPath%"=="" goto :eof
call :getPsExe
if not "%PsExe%"=="" goto :runPs1
echo Cannot find pwsh.exe or powershell.exe
goto :eof
:runPs1
pushd "%dbScriptDir%"
call :getFileParts "%dbPath%"
set ExeParent=%fileDirPathWithEndingSlash%
if not exist "%ExeParent%Sqlite3.exe" goto NoExe
goto RunPs2
:NoExe
echo "%ExeParent%Sqlite3.exe" does not exist
goto :eof
:RunPs2
if "%PsExe%"=="powershell" goto RunPs3
%PsExe% -File .\CacheDbSelectRecords.ps1 -relativePath 0 -pathToSqlite3 "%ExeParent%Sqlite3.exe" -pathToDb "%dbPath%" >%temp%\temp.txt 2>&1
goto DoneRunPs
:RunPs3
echo %dbPath% >%temp%\temp.txt
%PsExe% .\CacheDbSelectRecords.ps1 -relativePath 0 -pathToSqlite3 '%fileDirPathWithEndingSlash%Sqlite3.exe' -pathToDb '%dbPath%' >>%temp%\temp.txt
:DoneRunPs
popd
notepad %temp%\temp.txt
goto :eof

::::SUBROUTINE - get the right powershell exe to run
:getPsExe
where pwsh.exe >nul 2>&1
if "%ERRORLEVEL%"=="0" goto GotPwsh
where powershell.exe >nul 2>&1
if "%ERRORLEVEL%"=="0" goto GotPowershell
set PsExe=
goto :eof
:GotPwsh
set PsExe=pwsh
goto :eof
:GotPowershell
set PsExe=powershell
goto :eof

::SUBROUTINE - Given a folder path, set variables for the parts of the path
:getFileParts
set filePath=%~f1
set fileDirPathWithEndingSlash=%~dp1
set fileOrBaseFolderNameNoExt=%~n1
set fileExtension=%~x1
goto :eof
