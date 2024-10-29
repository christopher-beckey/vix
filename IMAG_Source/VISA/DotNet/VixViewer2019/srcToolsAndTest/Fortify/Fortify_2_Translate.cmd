@echo off
::Perform .NET Image Viewer Fortify Translation
::Syntax for non-Jenkins job: thisScript fullPathToFortifyBinFolder
::The Jenkins job must create four parameters: isJenkinsJob (Yes) FortifyBinFolder (the full path) buildId (CM_VV2019) prepJobName (CM_Fortify_PREP)
::The folder to translate is non-Jenkins=C:\VV2019, Jenkins=%WORKSPACE%\..\CM_Fortify_PREP\CM_VV2019
setlocal EnableExtensions DisableDelayedExpansion

if not "%isJenkinsJob%"=="" goto Proceed0b
set isJenkinsJob=No
set buildId=VV2019
set prepJobName=

if not "%~1"=="" goto Proceed0a
echo ERROR: Command-line argument must be the full path to the Fortify bin folder. Abandoning execution.
goto :eof

:Proceed0a
set FortifyBinFolder=%~1

:Proceed0b
set FolderToScan=C:\%buildId%
if "%isJenkinsJob%"=="No" goto Proceed1
set FolderToScan=%WORKSPACE%\..\%prepJobName%\%buildId%

::Get the date and time into CURR_ variables
:Proceed1
set CURR_YYYY=%date:~10,4%
set CURR_MM=%date:~4,2%
set CURR_DD=%date:~7,2%
set CURR_HH=%time:~0,2%
if %CURR_HH% lss 10 (set CURR_HH=0%time:~1,1%)
set CURR_NN=%time:~3,2%
::set CURR_SS=%time:~6,2%
::set CURR_MS=%time:~9,2%

::Commented out because only for Jenkins; not really needed
::::Set the label to the format yyyymmddhhMM
::set LABEL=%CURR_YYYY%%CURR_MM%%CURR_DD%%CURR_HH%%CURR_NN%

::Set the suffix to the format yyyy_mm_dd
set SUFFIX=%CURR_YYYY%_%CURR_MM%_%CURR_DD%

pushd %FolderToScan%
echo %date% %time% ***** CLEAN BEGIN *****
sourceanalyzer -b VV2019 -clean
echo %date% %time% ***** CLEAN COMPLETE *****
echo %date% %time% ***** TRANSLATE BEGIN *****
"%FortifyBinFolder%\sourceanalyzer" -b %buildId% ./
echo %date% %time% ***** TRANSLATE COMPLETE
echo %date% %time% ***** WARNINGS/ERRORS BEGIN *****
"%FortifyBinFolder%\sourceanalyzer" -b %buildId% -show-build-warnings
echo %date% %time% ***** WARNINGS/ERRORS COMPLETE *****
popd
