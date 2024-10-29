::@echo off
setlocal EnableExtensions DisableDelayedExpansion
::Get the patch version number from the following files into %buildFolderPath%\patchVersion.txt (called by build.cmd)
::  VixBuildManifestPatch???CVIX.xml
::or
::  VixBuildManifestPatch???VIX.xml

set thisScriptsDirWithEndingBackslash=%~dp0
set thisScriptsFileName=%~n0%~x0
set syntax=%thisScriptsFileName% VIXorCVIX folderPathToVixBuildManifestPatch???X.xml folderPathToBuildFolder (where X is VIX or CVIX)

for /f %%a in ('%thisScriptsDirWithEndingBackslash%\GetTempFilePath.cmd') do set TEMP_PATH=%%a
for /f %%a in ('%thisScriptsDirWithEndingBackslash%\GetTempFilePath.cmd') do set TEMP_PATH2=%%a

if "%1"=="" goto BadArgs
set ProductTitle=%1
if "%ProductTitle%"=="VIX" goto NextArg1
if "%ProductTitle%"=="CVIX" goto NextArg1
echo ERROR: first argument must be VIX or CVIX
goto BadArgs
:NextArg1
shift
if "%1"=="" goto BadArgs
set xmlFolderPath=%1
if exist "%xmlFolderPath%\VixBuildManifestPatch???%ProductTitle%.xml" goto NextArg2
echo ERROR: "%xmlFolderPath%\VixBuildManifestPatch???%ProductTitle%.xml" (from second argument) does not exist
goto BadArgs
:NextArg2
shift
if "%1"=="" goto BadArgs
set buildFolderPath=%1
if exist "%buildFolderPath%" goto DoIt
echo ERROR: "%buildFolderPath%" (from third argument) does not exist
:BadArgs
echo ERROR: syntax is %syntax%
goto :eof

:DoIt
::Get the most recent %xmlFolderPath%\VixBuildManifestPatch???%ProductTitle%.xml's Patch number
::Output the patch file names in reverse alphabetical order, that is, Z-A
dir "%xmlFolderPath%\VixBuildManifestPatch???%ProductTitle%.xml" /B /O:-N > "%TEMP_PATH%" 2>nul
::get the latest xml file name, in our case it is the first file name, which is actually the last one if it had been in alphabetical order A-Z
set /p latestPatchXml= < "%TEMP_PATH%
if NOT "%latestPatchXml%"=="" goto GetPatchNumFromFile
echo ERROR: Unable to get the latest .xml file from the VixBuildManifestPatch???%ProductTitle%.xml
goto :eof

::get the patch version number from the xml file
:GetPatchNumFromFile
type "%xmlFolderPath%\%latestPatchXml%" | findstr "<Patch number=" > "%TEMP_PATH%"
call:ReplaceTmpExtensionWithVbs
echo str = WScript.Stdin.readline > "%TEMP_PATHVBS%"
echo parts = Split(str, """") >> "%TEMP_PATHVBS%"
echo WScript.StdOut.Write parts(1) >> "%TEMP_PATHVBS%"
cscript "%TEMP_PATHVBS%" //nologo < "%TEMP_PATH%" > %buildFolderPath%\patchVersion.txt
exit /b 0

:ReplaceTmpExtensionWithVbs
setlocal EnableDelayedExpansion
set TEMP_PATHVBS=!TEMP_PATH2:%tmp%=%vbs%!
setlocal DisableDelayedExpansion
goto :eof