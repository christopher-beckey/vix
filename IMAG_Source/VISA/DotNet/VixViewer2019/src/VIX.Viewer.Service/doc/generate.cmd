@echo off
::Generates HTML doc from openapi.json

echo INFO: current working directory is:
cd

set thisDirWithEndingBackslash=%~dp0

for /f %%a in ('..\..\..\srcToolsAndTest\Scripts\GetTempFilePath.cmd') do set TEMP_PATH=%%a
for /f %%a in ('..\..\..\srcToolsAndTest\Scripts\GetTempFilePath.cmd') do set TEMP_PATH2=%%a

::Check to see if NPM is installed (ERRORLEVEL is zero if it is not installed and 1 if it is installed)
call npm.cmd -v > "%TEMP_PATH%" 2>&1
findstr "not recognized" "%TEMP_PATH%" > "%TEMP_PATH2%"
if "%ERRORLEVEL%"=="1" goto ContinueGenerate
set msg=NPM is not installed. Please read PDF.

:ShowError
echo ERROR: %msg% Abandoning doc generation.
exit /b 1

:ContinueGenerate
echo INFO: NPM is installed with version:
type "%TEMP_PATH%"
set PV=..\..\..\build\patchVersion.txt
if exist %PV% goto GotPatchVersion
echo INFO: ..\..\..\build\patchVersion.txt does not exist
set BuildConfigFolderPath=..\..\..\..\..\..\..\IMAG_Build\Configuration\VisaBuildConfiguration
if not exist %BuildConfigFolderPath% goto NoBuildConfigFolder
..\..\..\srcToolsAndTest\Scripts\GetPatchVersion VIX %BuildConfigFolderPath% %thisDirWithEndingBackslash%..\..\..\build
if exist %PV% goto GotPatchVersion
set msg=%PV% does not exist even after running GetPatchVersion script. If you are a developer, run buildDev.cmd.
goto ShowError
:NoBuildConfigFolder
set msg=%BuildConfigFolderPath% does not exist.
goto ShowError

:GotPatchVersion
echo INFO: PV is %PV%
set /p versionNumber=<%PV%
echo INFO: versionNumber is %versionNumber%
set TEMP_PATHVBS=%TEMP_PATH2%.vbs
::Update the temporary doc source with the real patch version
echo str = WScript.Stdin.readall > "%TEMP_PATHVBS%"
echo WScript.StdOut.Write Replace(str, "REPLACE_VERSION_NUMBER", "%versionNumber%") >> "%TEMP_PATHVBS%"
set TEMP_PATHJSON=%TEMP_PATH2%.json
cscript "%TEMP_PATHVBS%" //nologo < openapi.json > "%TEMP_PATHJSON%"
echo INFO: replaced placeholder with version number, here is output from file compare:
fc openapi.json "%TEMP_PATHJSON%"

::Check to see if redoc-cli is installed and is in PATH (ERRORLEVEL is zero if it is not installed and 1 if it is installed)
call redoc-cli.cmd --version > "%TEMP_PATH%.r.txt" 2>&1
findstr "not recognized" "%TEMP_PATH%.r.txt" > "%TEMP_PATH2%.r2.txt"
if "%ERRORLEVEL%"=="1" goto CreateTheDoc
set msg=redoc-cli is not installed in PATH. Add %APPDATA%\npm to PATH environment variable.
goto ShowError

:CreateTheDoc
echo INFO: redoc-cli exists with version:
call redoc-cli --version
call redoc-cli bundle --title "Enhanced Image Viewer REST API" -t vvTemplate.txt --output VVSDoc.html "%TEMP_PATHJSON%"
exit /b 0
