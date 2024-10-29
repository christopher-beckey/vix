@echo off
::Perform .NET Image Viewer Fortify Scan and generate Fortify report
::Syntax for non-Jenkins job: thisScript fullPathToFortifyBinFolder
::The Jenkins job must create four parameters: isJenkinsJob (Yes) FortifyBinFolder (the full path) buildId (CM_VV2019) prepJobName (CM_Fortify_PREP)
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

::Do the scan
set F=C:\Fortify
if exist %F%\%buildId%.log del %F%\%buildId%.log

echo %date% %time% ***** SCAN BEGIN *****
pushd %FolderToScan%
"%FortifyBinFolder%\sourceanalyzer" -b %buildId% -Xmx96G -Xms4G -Xss24M -64 -logfile %F%\%buildId%.log -scan -f %F%\%buildId%_%SUFFIX%.fpr
popd
echo %date% %time% ***** SCAN COMPLETE *****

echo %date% %time% ***** WARNINGS/ERRORS BEGIN *****
"%FortifyBinFolder%\sourceanalyzer" -b %buildId% -show-build-warnings
echo %date% %time% ***** WARNINGS/ERRORS COMPLETE *****

pushd "%FortifyBinFolder%"

echo %date% %time% ***** REPORTS BEGIN *****
set OutputFile=%F%\%buildId%_%SUFFIX%_DeveloperWorkbook.pdf
set OutputFormat=PDF
@echo on
call BIRTReportGenerator -template "Developer Workbook" -source %F%\%buildId%_%SUFFIX%.fpr -format %OutputFormat% -output %OutputFile%
@echo off
echo %date% %time% ***** REPORTS COMPLETE *****

exit /b 0
