@echo off
::Perform .NET Image Viewer Fortify Scan and generate Fortif
::syntax for non-Jenkins job: thisScript fullPathToFortifyBinFolder
setlocal EnableExtensions DisableDelayedExpansion

if not "%isJenkinsJob%"=="" goto Proceed0b
set isJenkinsJob=No

if not "%~1"=="" goto Proceed0a
echo ERROR: Command-line argument must be the full path to the Fortify bin folder. Abandoning execution.
goto :eof

:Proceed0a
set FortifyBinFolder=%~1

:Proceed0b
set FolderToScan=C:\VV2019
if "%isJenkinsJob%"=="No" goto Proceed1
set FolderToScan=%WORKSPACE%\..\Fortify_1_PREP\VV2019

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

::Commented out because only for Jenkins builds; not really needed
::::Set the label to the format yyyymmddhhMM
::set LABEL=%CURR_YYYY%%CURR_MM%%CURR_DD%%CURR_HH%%CURR_NN%

::Set the suffix to the format yyyy_mm_dd
set SUFFIX=%CURR_YYYY%_%CURR_MM%_%CURR_DD%

::Do the scan
set F=C:\Fortify
if exist %F%\VV2019.log del %F%\VV2019.log

echo %date% %time% ***** SCAN BEGIN *****
pushd %FolderToScan%
"%FortifyBinFolder%\sourceanalyzer" -b VV2019 -Xmx96G -Xms4G -Xss24M -64 -logfile %F%\VV2019.log -scan -f %F%\VV2019_%SUFFIX%.fpr
popd
echo %date% %time% ***** SCAN COMPLETE *****

echo %date% %time% ***** WARNINGS/ERRORS BEGIN *****
"%FortifyBinFolder%\sourceanalyzer" -b VV2019 -show-build-warnings
echo %date% %time% ***** WARNINGS/ERRORS COMPLETE *****

pushd "%FortifyBinFolder%"

echo %date% %time% ***** REPORTS BEGIN *****
set OutputFile=%F%\VV2019_%SUFFIX%_DeveloperWorkbook.pdf
set OutputFormat=PDF
@echo on
call BIRTReportGenerator -template "Developer Workbook" -source %F%\VV2019_%SUFFIX%.fpr -format %OutputFormat% -output %OutputFile%
@echo off
echo %date% %time% ***** REPORTS COMPLETE *****

exit /b 0