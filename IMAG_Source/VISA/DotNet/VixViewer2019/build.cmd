@echo off
setlocal EnableExtensions DisableDelayedExpansion
::Build the Hydra 2019 solution

::***** For syntax, see the ShowHelp subroutine *****

::************************************************************************************************
::                                     INITIALIZE VARIABLES
::************************************************************************************************
::Which solution(s) we will build
set slnDefault=Hydra.sln
set sln=
::Unique temp file path for running this script in multiple concurrent processes
for /f %%a in ('srcToolsAndTest\Scripts\GetTempFilePath.cmd') do set TEMP_PATH=%%a
call :getFileParts %TEMP_PATH%
::Only use these two vars in DoClean
set TEMP_PATH2=%fileDirPath%%fileName%2%fileExtension%
set TEMP_PATH3=%fileDirPath%%fileName%3%fileExtension%

::Some general variables
set thisScriptsFileName=%~n0%~x0
set thisDirWithEndingBackslash=%~dp0
set result=0

::Command line arguments/parameters
set BuildEnvArg=
set ConfigArg=
set DebugArg=
set GitPathArg=
set IgnoreFolderArg=
set PkgPublishArg=
set RebuildArg=
set SkipBuildArg=
set ProductTitle=
set UltraCleanArg=
set VersionArg=

::************************************************************************************************
::          PARSE COMMAND LINE (remove any surrounding double-quotes from each argument)
::************************************************************************************************
:Loop
if "%~1"=="" goto DoneArgs
::if "%~1"=="-a" goto GetTargets
if "%~1"=="-c" goto GetConfig
if "%~1"=="-d" goto GotDebug
if "%~1"=="-e" goto GetBuildEnv
if "%~1"=="-g" goto GetGit
if "%~1"=="-h" goto ShowHelp
if "%~1"=="-i" goto GetIgnoreFolder
if "%~1"=="-k" goto GotSkipBuild
if "%~1"=="-p" goto GotPkgPublish
if "%~1"=="-r" goto GotRebuild
if "%~1"=="-s" goto GetSolution
if "%~1"=="-t" goto GetTitle
if "%~1"=="-u" goto GotUltraClean
if "%~1"=="-v" goto GetVersion
if "%~1"=="?" goto ShowHelp
if "%~1"=="/?" goto ShowHelp
:Next
shift
goto Loop
:GetConfig
shift
if "%~1"=="" goto BadArgs
set ConfigArg=%1
echo %ConfigArg% > %thisDirWithEndingBackslash%build\patchConfig.txt
goto Next
:GotDebug
set DebugArg=gotIt
if NOT "%DebugArg%"=="" echo on
goto Next
:GetBuildEnv
shift
if "%~1"=="" goto BadArgs
set BuildEnvArg=%1
echo %BuildEnvArg% > %thisDirWithEndingBackslash%build\patchEnv.txt
goto Next
:GetGit
shift
if "%~1"=="" goto BadArgs
set GitPathArg=%1
goto Next
:GetIgnoreFolder
shift
if "%~1"=="" goto BadArgs
setlocal enabledelayedexpansion
set x=0
For %%a In (%~1) DO (
  set /a x+=1
  set "IgnoreFolderArg!x!=%%a"
)
set IgnoreFolderArg
::Uncomment for debugging this script
::echo %IgnoreFolderArg1%
::echo %IgnoreFolderArg2%
::echo %IgnoreFolderArg3%
::echo %IgnoreFolderArg4%
::if "%IgnoreFolderArg5%"=="" echo yes
::pause
setlocal DisableDelayedExpansion
goto Next
:GotSkipBuild
set SkipBuildArg=gotIt
goto Next
:GotPkgPublish
set PkgPublishArg=gotIt
goto Next
:GotRebuild
set RebuildArg=gotIt
goto Next
:GetSolution
shift
if "%~1"=="" goto BadArgs
set sln=%1
goto Next
:GetTitle
shift
if "%~1"=="" goto BadArgs
set ProductTitle=%1
goto Next
:GotUltraClean
set UltraCleanArg=gotIt
goto Next
:GetVersion
shift
if "%~1"=="" goto BadArgs
set VersionArg=%1
echo %VersionArg% > %thisDirWithEndingBackslash%build\patchVersion.txt
goto Next
:BadArgs
echo ERROR: Syntax error. Please run %thisScriptsFileName% -h. Abandoning build. 1>&2
EXIT /B -1
:DoneArgs

::************************************************************************************************
::                           IDENTIFY SOLUTION & PRODUCT WE WILL BUILD
::************************************************************************************************
if NOT "%sln%"=="" goto GotSln
set sln=%slnDefault%

:GotSln
call:CheckWorkingFolder result
if NOT "%result%"=="0" EXIT /B %result%

call :getFileParts %sln%
set slnNoExt=%fileName%

if NOT "%ProductTitle%"=="" goto GotProductTitle
set ProductTitle=VIX
:GotProductTitle
if "%ProductTitle%"=="VIX" goto LocateMsbuild
if "%ProductTitle%"=="CVIX" goto LocateMsbuild
echo ERROR: Syntax error. -t is %ProductTitle%, and it must be VIX or CVIX. Abandoning build. 1>&2
EXIT /B -1

::***********************************************************************************************
::                                       LOCATE MSBUILD.EXE
::***********************************************************************************************
:LocateMsbuild
call:GetMsBuildPath result
if NOT "%result%"=="0" EXIT /B %result%

::***********************************************************************************************
::                   DECIDE IF WE ARE DOING DEBUG AND/OR RELEASE CONFIGURATION
::***********************************************************************************************
set msbDebugConfig=Debug
set msbReleaseConfig=Release
if "%ConfigArg%"=="" goto DoneConfig
if NOT "%ConfigArg%"=="Debug" goto SetReleaseConfig
if NOT "%ConfigArg%"=="Release" goto SetDebugConfig
echo ERROR: The -c value must be either Debug or Release. Abandoning the build. 1>&2
goto :EOF
:SetDebugConfig
set msbReleaseConfig=
goto DoneConfig
:SetReleaseConfig
set msbDebugConfig=

:DoneConfig
set ExitCode=0

::***********************************************************************************************
::                                    GET CURRENT DATE AND TIME
::***********************************************************************************************
call:DateTime date_time

::***********************************************************************************************
::                                             CLEAN
::***********************************************************************************************
if NOT "%RebuildArg%"=="" call:DoClean

::***********************************************************************************************
::                                CHECK IF WE ARE SKIPPING THE BUILD
::***********************************************************************************************
if NOT "%SkipBuildArg%"=="" goto DoneBuildRelease

::***********************************************************************************************
::                            GET THE VERSION AND UPDATE ASSEMBLY INFO
::***********************************************************************************************
if NOT "%VersionArg%"=="" goto GotVersionNumber
set xmlDir=..\..\..\..\IMAG_Build\Configuration\VisaBuildConfiguration
if exist "%xmlDir%" goto GetVersionNumber
set gitPath=%GitPathArg%
if NOT "%gitPath%"=="" goto TryGit
set gitPath=C:\git
:TryGit
::Get the most recent patch number
::Output the patch folder (branch) names in reverse alphabetical order, that is, Z-A
set PatchNumsFilePath=%TEMP_PATH%
dir "%gitPath%\p???" /B /O:-N > "%PatchNumsFilePath%" 2>nul
::get the latest patch folder, in our case it is the first folder name due to Z-A, which is actually the last one if it had been in alphabetical order A-Z
set /p latestPatchNum= < "%PatchNumsFilePath%"
set errorMsg=%gitPath%\p???\%latestPatchNum%\IMAG_Build\Configuration\VisaBuildConfiguration
if "%latestPatchNum%"=="" goto ErrorVersion
set xmlPatchDir=%gitPath%\%latestPatchNum%\IMAG_Build\Configuration\VisaBuildConfiguration
if exist "%xmlPatchDir%" goto GetVersionNumber
errorMsg=%errorMsg% or %xmlPatchDir%
:ErrorVersion
ECHO ERROR: Cannot find Patch number in latest "%xmlDir%\VixBuildManifestPatch???%ProductTitle%.xml"
ECHO ERROR: Also cannot find %errorMsg%
goto :eof

:GetVersionNumber
::GetPatchVersion outputs the version number to build\patchVersion.txt
CALL %thisDirWithEndingBackslash%srcToolsAndTest\Scripts\GetPatchVersion %ProductTitle% %xmlPatchDir% %thisDirWithEndingBackslash%build
set /p VersionArg= < %thisDirWithEndingBackslash%build\patchVersion.txt
:GotVersionNumber
call:BackupFile SharedAssemblyInfo.cs %thisDirWithEndingBackslash%build\backup SharedAssemblyInfo%date_time%.cs SharedAssemblyInfo*.cs
::replace the version and copyright year
cscript "%thisDirWithEndingBackslash%srcToolsAndTest\Scripts\CreateAssemblyInfoShared.vbs" //nologo "%thisDirWithEndingBackslash%SharedAssemblyInfo.cs" %VersionArg% %CURR_YYYY%

::***********************************************************************************************
::                                 BUILD THE SOLUTION / DO THE BUILD
::***********************************************************************************************
::Finally run MSBUILD (see https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-command-line-reference?view=vs-2019)
if not exist build\log mkdir build\log
set targetArg=
if NOT "%targets%"=="" set targetArg=/t:%targets%
:BuildDebug
if "%msbDebugConfig%"=="" goto BuildRelease
::MSBuild command-line reference: https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-command-line-reference?view=vs-2019
::MSBuild properties: https://docs.microsoft.com/en-us/visualstudio/msbuild/common-msbuild-project-properties?view=vs-2019
::Example "C:\Program Files (x86)\MSBuild\12.0\Bin\amd64\MSBuild.exe" /p:RestorePackages=false /p:Configuration=Debug /out build\log\2020040800-XYZDebug.txt "XYZ.sln"
::/verbosity:diagnostic = 90MB, /verbosity:detailed = 8MB, /verbosity:normal (default), /verbosity:minimal, or /verbosity:quiet
"%msbuildPath%" /p:RestorePackages=false /p:Configuration=Debug /p:DefineConstants="%BuildEnvArg%;UNIT_TESTS;GDI;UseGdiObjects" /p:Platform="Mixed Platforms" /verbosity:normal "%targetArg%" "%sln%" >build\log\%date_time%-%slnNoExt%Debug.txt 2>&1
echo build\log\%date_time%-%slnNoExt%Debug.txt: && findstr "Error(s)" build\log\%date_time%-%slnNoExt%Debug.txt
:BuildRelease
if "%msbReleaseConfig%"=="" goto DoneBuildRelease
"%msbuildPath%" /p:RestorePackages=false /p:Configuration=Release /p:DefineConstants="%BuildEnvArg%;UNIT_TESTS;GDI;UseGdiObjects" /p:Platform="Mixed Platforms" "%targetArg%" "%sln%" >build\log\%date_time%-%slnNoExt%Release.txt 2>&1
echo build\log\%date_time%-%slnNoExt%Release.txt: && findstr "Error(s)" build\log\%date_time%-%slnNoExt%Release.txt
::Only package if told to and no errors
if "%PkgPublishArg%"==""  goto DoneBuildRelease
::For some reason, findstr " 0 Error(s)" does not work
set CheckAnyBuildErrorsPath=%TEMP_PATH%
echo This file stays if there was an error > "%CheckAnyBuildErrorsPath%"
::Remove the %CheckAnyBuildErrorsPath% file if we have 0 Error(s). Keep it if we do not.
cscript "%thisDirWithEndingBackslash%srcToolsAndTest\Scripts\CheckForZeroErrors.vbs" //nologo "%thisDirWithEndingBackslash%build\log\%date_time%-%slnNoExt%Release.txt" "%CheckAnyBuildErrorsPath%"
set ExitCode=0
if not exist "%CheckAnyBuildErrorsPath%" goto PackageTheRelease
set ExitCode=1
goto DoneBuildRelease
:PackageTheRelease
call srcToolsAndTest\Scripts\PackageForRelease.cmd %VersionArg%
set ExitCode=%ERRORLEVEL%
:DoneBuildRelease
EXIT /B %ExitCode%

::***********************************************************************************************
::              SUBROUTINE: SHOW THIS SCRIPT'S CALLING SYNTAX AND ARGUMENTS/PARAMETERS
::***********************************************************************************************
:ShowHelp
echo Syntax is shown below where the Xs represent the values of each argument
echo - %thisScriptsFileName% -h
echo   or
echo   %thisScriptsFileName% -c X -d -e X -g X -h -i X -k -p -r -s X -t CVIX -v X
echo   where:
::The following line is commented out as a reminder that we might want to add this option.
::echo   -a = target(s)
echo   -c = configuration (Optional, default is both Debug and Release) If specified, X must be either Debug or Release
echo   -d = debug mode (Optional, default is off) If specified, enables debugging (to show blow-by-blow execution of this script)
echo   -e = environment (Optional, default is dev) If specified, X must be dev or prod (no staging), where dev = GFE or dev server and prod = build server
echo   -g = git path (Optional, default is C:\git\X, where X is the latest pNNN on your machine)
echo   -h = help (Optional, default is *NOT* to show) If specified, shows this help info and exits
echo   -i = ignore specified folder for cleaning (as in -k or -k -r) (Optional, default is *NOT* to ignore any folder) Can be used up to five times
echo   -k = skip the build (Optional, default is *NOT* to skip) If specified, the build is not done, but other actions will be
echo   -p = package for publishing/releasing (Optional, default is *NOT* to package) If specified, packages into .zip file in build\pkg folder ***ONLY for Release Configuration***
echo   -r = rebuild/clean (Optional, default is *NOT* to rebuild/clean) If specified, a clean is done before the build
echo   -s = solution to build (Optional, default is Hydra.sln) If specified, X must be in the form s.sln (where s is the solution name, like Hydra)
echo   -t = product title (Optional, default is VIX) If specified, must be VIX or CVIX
echo   -u = ultra-clean (Optional, default is *NOT* ultra-clean) If specified, clean also removes the packages folders
echo   -v = version (Optional, default is obtained from latest VixBuildManifestPatchNNN{VIX or CVIX}.xml file) If specified, must be in MAJORMINOR.PATCH.TEST.BUILD format (see Example below)
echo - The build fails if you see ERROR output (that goes to STDERR). It succeeds if you do not see ERROR output.
echo - The log is stored in build\log\*.txt with the current date and time per the configuration
echo - Examples:
echo   - %thisScriptsFileName%
echo     Build with all the defaults
echo   - %thisScriptsFileName% -c Release -v 30.230.3.6670 -t CVIX
echo     Build the Release configuration with the version set to 30.230.3.6670 which corresponds to MAG3_0P230T3_VIX_Setup.msi,
echo     where MAJOR = 3, MINOR = 0, PATCH = 230, TEST = 3, and BUILD = 6670
echo   - %thisScriptsFileName% -r -k
echo     Clean all folders without doing a build
goto :EOF

::***********************************************************************************************
::SUBROUTINE: ENSURE IN THE RIGHT FOLDER/DIR, AND RETURN RESULT IN GIVEN ARG VARIABLE ON ERROR
::***********************************************************************************************
:CheckWorkingFolder
::Make sure working directory has the right solution file in it
if exist "%sln%" goto GoodSlnDir
echo ERROR: The working directory does not contain the %sln% file. Abandoning build. 1>&2
set "%~1=-1"
:GoodSlnDir
if "%targets%"=="" goto GoodTargetDir
echo ERROR: -a is not yet implemented. Abandoning build. 1>&2
goto :EOF
if exist "%target%" goto GoodTargetDir
echo ERROR: The target (%target%) does not exist. Abandoning build. 1>&2
set "%~1=-1"
:GoodTargetDir
goto :EOF

::***********************************************************************************************
::               SUBROUTINE: LOCATE MSBUILD.EXE, AND RETURN RESULT IN GIVEN ARG VARIABLE
::***********************************************************************************************
:GetMsBuildPath
::Hardcode to Visual Studio 2019
set msbuildPath=%programfiles(x86)%\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\msbuild.exe
if exist "%msbuildPath%" goto DoneFindingMSBUILD
set msbuildPath=%programfiles(x86)%\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\msbuild.exe
if exist "%msbuildPath%" goto DoneFindingMSBUILD
set msbuildPath=%programfiles(x86)%\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\msbuild.exe
if exist "%msbuildPath%" goto DoneFindingMSBUILD
set msbuildPath=%programfiles(x86)%\Microsoft Visual Studio\2019\BuildTools\MSBuild\Current\Bin\msbuild.exe
if exist "%msbuildPath%" goto DoneFindingMSBUILD
set msbuildPath=%programfiles(x86)%\MSBuild\14.0\Bin\msbuild.exe
if exist "%msbuildPath%" goto DoneFindingMSBUILD
set msbuildPath=%programfiles(x86)%\MSBuild\13.0\Bin\msbuild.exe
if exist "%msbuildPath%" goto DoneFindingMSBUILD
set msbuildPath=%programfiles(x86)%\MSBuild\12.0\Bin\msbuild.exe
if exist "%msbuildPath%" goto DoneFindingMSBUILD
echo ERROR: Cannot find MSBUILD.EXE. Abandoning build. 1>&2
set "%~1=-1"
:DoneFindingMSBUILD
goto :EOF

::***********************************************************************************************
::   SUBROUTINE: GET THE DATE&TIME, SET CURR_X VARS, AND RETURN RESULT IN GIVEN ARGUMENT VAR
::***********************************************************************************************
:DateTime
set CURR_YYYY=%date:~10,4%
set CURR_MM=%date:~4,2%
set CURR_DD=%date:~7,2%
set CURR_HH=%time:~0,2%
if %CURR_HH% lss 10 (set CURR_HH=0%time:~1,1%)
set CURR_NN=%time:~3,2%
set CURR_SS=%time:~6,2%
set CURR_MS=%time:~9,2%

set %~1=%CURR_YYYY%%CURR_MM%%CURR_DD%%CURR_HH%%CURR_NN%%CURR_SS%
exit /B 0

::***********************************************************************************************
::  SUBROUTINE: DELETE FILES AND FOLDERS FOR: 1) A FRESH BUILD; AND 2) NOT WANTED IN SOURCE REPO
::***********************************************************************************************
:DoClean
if not exist build\log mkdir build\log
set CL=build\log\clean.txt
set result=0

::user-specific files that do not get checked in
DEL /S *.user 2>&1 | findstr /v "Could Not Find" | findstr /v "Deleted file" >%CL% 2>&1
::VS IDE files/folders we do not checkin
RMDIR /S /Q "Visual Studio 2019" 2>&1 | findstr /v "cannot find the file" >>%CL% 2>&1
::Intellisense files we do not checkin
DEL /S Hydra.sdf 2>&1 | findstr /v "Could Not Find" | findstr /v "Deleted file" >>%CL% 2>&1

::VS creates these on the fly, no reason to checkin
DEL /S /Q *.datasource 2>&1 | findstr /v "Could Not Find" | findstr /v "Deleted file" >>%CL% 2>&1

::Diff programs sometimes leave these files hanging around, do not checkin
DEL /S /Q *.bak 2>&1 | findstr /v "Could Not Find" | findstr /v "Deleted file" >>%CL% 2>&1
DEL /S /Q *.orig 2>&1 | findstr /v "Could Not Find" | findstr /v "Deleted file" >>%CL% 2>&1

::From github that we don't want
DEL /S /Q .signature.p7s 2>&1 | findstr /v "Could Not Find" | findstr /v "Deleted file" >>%CL% 2>&1

::folders to remove
set dirPath=%TEMP_PATH2%
set dirPath2=%TEMP_PATH3%
echo DoClean's dirPath is (%dirPath%)
echo DoClean's dirPath2 is (%dirPath2%) should not exist on a good clean
echo DoClean's CL is (%CL%) should be empty on a good clean

DIR /B /AD /S /O:N | findstr "\\.vs$" >"%dirPath%" 2>>%CL%
DIR /B /AD /S /O:N | findstr "\\bin\\" >>"%dirPath%" 2>>%CL%
DIR /B /AD /S /O:N | findstr "\\bin$" >>"%dirPath%" 2>>%CL%
DIR /B /AD /S /O:N | findstr "\\Debug\\" >>"%dirPath%" 2>>%CL%
DIR /B /AD /S /O:N | findstr "\\Debug$" >>"%dirPath%" 2>>%CL%
DIR /B /AD /S /O:N | findstr "\\log\\" >>"%dirPath%" 2>>%CL%
DIR /B /AD /S /O:N | findstr "\\log$" >>"%dirPath%" 2>>%CL%
DIR /B /AD /S /O:N | findstr "\\obj\\" >>"%dirPath%" 2>>%CL%
DIR /B /AD /S /O:N | findstr "\\obj$" >>"%dirPath%" 2>>%CL%
if "%UltraCleanArg%"=="" goto DonePackages
DIR /B /AD /S /O:N | findstr "\\packages\\" >>"%dirPath%" 2>>%CL%
DIR /B /AD /S /O:N | findstr "\\packages$" >>"%dirPath%" 2>>%CL%
:DonePackages
DIR /B /AD /S /O:N | findstr "\\Release$" >>"%dirPath%" 2>>%CL%
DIR /B /AD /S /O:N | findstr "\\x64\\" | findstr /v "\\packages\\" | findstr /v "\\packages$" >>"%dirPath%" 2>>%CL%
DIR /B /AD /S /O:N | findstr "\\x64$" | findstr /v "\\packages\\" | findstr /v "\\packages$" >>"%dirPath%" 2>>%CL%
::Do not clean ant's bin folder
type "%dirPath%" | findstr /v "\\NAnt" > "%dirPath2%"
move "%dirPath2%" "%dirPath%" | findstr /v "file(s) moved" >>%CL% 2>&1
::Do not clean folders the user has asked to ignore
type "%dirPath%" | findstr /v "\\%IgnoreFolderArg1%$" > "%dirPath2%"
move "%dirPath2%" "%dirPath%" | findstr /v "file(s) moved" >>%CL% 2>&1
if "%IgnoreFolderArg1%"=="" goto DoClean2
type "%dirPath%" | findstr /v "\\%IgnoreFolderArg1%\\" > "%dirPath2%"
move "%dirPath2%" "%dirPath%" | findstr /v "file(s) moved" >>%CL% 2>&1
type "%dirPath%" | findstr /v "\\%IgnoreFolderArg1%$" > "%dirPath2%"
move "%dirPath2%" "%dirPath%" | findstr /v "file(s) moved" >>%CL% 2>&1
if "%IgnoreFolderArg2%"=="" goto DoClean2
type "%dirPath%" | findstr /v "\\%IgnoreFolderArg2%\\" > "%dirPath2%"
move "%dirPath2%" "%dirPath%" | findstr /v "file(s) moved" >>%CL% 2>&1
type "%dirPath%" | findstr /v "\\%IgnoreFolderArg2%$" > "%dirPath2%"
move "%dirPath2%" "%dirPath%" | findstr /v "file(s) moved" >>%CL% 2>&1
if "%IgnoreFolderArg3%"=="" goto DoClean2
type "%dirPath%" | findstr /v "\\%IgnoreFolderArg3%\\" > "%dirPath2%"
move "%dirPath2%" "%dirPath%" | findstr /v "file(s) moved" >>%CL% 2>&1
type "%dirPath%" | findstr /v "\\%IgnoreFolderArg3%$" > "%dirPath2%"
move "%dirPath2%" "%dirPath%" | findstr /v "file(s) moved" >>%CL% 2>&1
if "%IgnoreFolderArg4%"=="" goto DoClean2
type "%dirPath%" | findstr /v "\\%IgnoreFolderArg4%\\" > "%dirPath2%"
move "%dirPath2%" "%dirPath%" | findstr /v "file(s) moved" >>%CL% 2>&1
type "%dirPath%" | findstr /v "\\%IgnoreFolderArg4%$" > "%dirPath2%"
move "%dirPath2%" "%dirPath%" | findstr /v "file(s) moved" >>%CL% 2>&1
if "%IgnoreFolderArg5%"=="" goto DoClean2
type "%dirPath%" | findstr /v "\\%IgnoreFolderArg5%\\" > "%dirPath2%"
move "%dirPath2%" "%dirPath%" | findstr /v "file(s) moved" >>%CL% 2>&1
type "%dirPath%" | findstr /v "\\%IgnoreFolderArg5%$" > "%dirPath2%"
move "%dirPath2%" "%dirPath%" | findstr /v "file(s) moved" >>%CL% 2>&1

:DoClean2
call :checkFileStatusNotEmpty %dirPath%
if "%ErrStatus%"=="" goto :DoClean3
echo dirPath's ErrorStatus is %ErrStatus%
set result=1
goto :DoClean4

:DoClean3
set "fileToProcess=%dirPath%"
for /F "usebackq tokens=* delims=" %%A in ("%fileToProcess%") do RMDIR /S /Q "%%A" 2>&1 | findstr /v "cannot find the file" >>%CL% 2>&1

:DoClean4
if not exist "%dirPath2%" echo dirPath2 does not exist (good)
if exist "%dirPath2%" dir "%dirPath2%" | findstr ".tmp" & echo (bad)
call :checkFileStatusEmpty %CL%
if "%ErrStatus%"=="" echo CL is empty (good) & goto :DoClean5
echo CL's ErrorStatus is %ErrStatus%
set result=1

:DoClean5
exit /B %result%

::***********************************************************************************************
:: SUBROUTINE: CHECK A FILE's STATUS (ErrStatus is empty if file is OK) FILE IS OK IF NOT EMPTY
::***********************************************************************************************
:checkFileStatusNotEmpty
set ErrStatus=
if not "%~1"=="" goto checkFileStatus2
ErrStatus=The file path is not specified as an argument. 
goto :eof
:checkFileStatus2
if "%~z1" == "" ( 
    set ErrStatus=%1 does not exist. 
) else if "%~z1" == "0" ( 
    set ErrStatus=The file is empty.
)
::) else ( 
::    echo The file is not empty.
::)
goto :eof

::***********************************************************************************************
:: SUBROUTINE: CHECK A FILE's STATUS (ErrStatus is empty if file is OK) FILE IS OK IF EMPTY
::***********************************************************************************************
:checkFileStatusEmpty
set ErrStatus=
if not "%~1"=="" goto checkFileStatus2
ErrStatus=The file path is not specified as an argument. 
goto :eof
:checkFileStatus2
if "%~z1" == "" ( 
    set ErrStatus=%1 does not exist. 
) else if not "%~z1" == "0" ( 
    set ErrStatus=The file is not empty.
)
::) else ( 
::    echo The file is empty.
::)
goto :eof

::***********************************************************************************************
::    SUBROUTINE: SET file* VARIABLES TO THE PARTS OF A GIVEN ARGUMENT'S VALUE (A FILE PATH)
::***********************************************************************************************
:getFileParts
set filePath=%~f1
set fileDirPath=%~dp1
set fileName=%~n1
set fileExtension=%~x1
goto :eof

::***********************************************************************************************
::                 SUBROUTINE: GET THE FIRST FILE IN A FOLDER MATCHING A PATTERN
::***********************************************************************************************
:GetFirstFileInFolder
dir "%1" /B /O:N > "%TEMP_PATH%" 2>nul
set /p firstFile= < "%TEMP_PATH%"
goto :eof

::***********************************************************************************************
::                  SUBROUTINE: GET THE LAST FILE IN A FOLDER MATCHING A PATTERN
::***********************************************************************************************
:GetLastFileInFolder
dir "%1" /B /O:-N > "%TEMP_PATH%" 2>nul
::get the latest patch folder, in our case it is the first folder name due to Z-A, which is actually the last one if it had been in alphabetical order A-Z
set /p lastFile= < "%TEMP_PATH%"
goto :eof

::***********************************************************************************************
::        SUBROUTINE: BACKUP A FILE ONLY IF IT IS NOT DIFFERENT THAN THE PREVIOUS VERSION
::***********************************************************************************************
:BackupFile
set originalFile=%1
set myDir=%2
set newFile=%3
set filePattern=%4
if not exist "%myDir%" mkdir "%myDir%"
copy "%originalFile%" "%myDir%\%newFile%" >NUL 2>&1
::Output all files except the last one
dir "%myDir%\%filePattern%" /B /O:N | findstr /v "%newFile%" > "%TEMP_PATH%" 2>nul
set /p prevFile= < "%TEMP_PATH%"
if "%prevFile%"=="" goto :eof
fc "%myDir%\%prevFile%" "%myDir%\%newFile%" >nul 2>&1
if NOT "%ERRORLEVEL%"=="0" goto :eof
del "%myDir%\%newFile%"
goto :eof
