@echo off
::Prepare for .NET Image Viewer Fortify Scan
::Syntax for non-Jenkins job: thisScript fullPathToVixViewer2019
::The Jenkins job must create three parameters: isJenkinsJob (Yes) fullPathToVixViewer2019 (the workspace's full path as the name says) buildId (CM_VV2019)
setlocal EnableExtensions DisableDelayedExpansion

if not "%isJenkinsJob%"=="" goto Proceed0b
set isJenkinsJob=No
set buildId=VV2019

if not "%~1"=="" goto Proceed0a
echo ERROR: Command-line argument must be the full path to your VixViewer2019 folder. Abandoning execution.
goto :eof

:Proceed0a
set fullPathToVixViewer2019=%~1

:Proceed0b
set SrcFolder=%fullPathToVixViewer2019%
if "%isJenkinsJob%"=="No" goto Proceed0c
echo ***** Environment variables
set

::Copy VixViewer2019 source code to %WORKSPACE%\%buildId% scanning location, removing files to omit from scan
:Proceed0c
set TargFolder=C:\VV2019
if "%isJenkinsJob%"=="Yes" set TargFolder=%WORKSPACE%\%buildId%
if not exist "%TargFolder%" goto Proceed1
echo ***** Removing %TargFolder%
rmdir /s /q "%TargFolder%"
if not exist "%TargFolder%" goto Proceed1
echo ERROR: %TargFolder% was not removed. (Could someone have the folder open in File Explorer?) Abandoning execution.
set result=1
goto VeryEndOfScript

:Proceed1
echo ***** Examining %SrcFolder%
if exist "%SrcFolder%" goto Proceed2
echo ERROR: %SrcFolder% does not exist. Abandoning execution.
set result=1
goto VeryEndOfScript

:Proceed2
if exist "%SrcFolder%\Hydra.sln" goto Proceed3
echo ERROR: Hydra.sln does not exist in %SrcFolder%. Abandoning execution.
set result=1
goto VeryEndOfScript

:Proceed3
echo ***** Copying %SrcFolder%\src to %TargFolder%
robocopy "%SrcFolder%\src" "%TargFolder%" /E /ETA /NC /NDL /NFL /NJH /NJS /NS

echo ***** Removing files and folders we need to exclude
pushd "%TargFolder%"

if exist "%SrcFolder%\srcToolsAndTest\Scripts\GetTempFilePath.cmd" goto GetTemp
echo ERROR: %SrcFolder%\srcToolsAndTest\Scripts\GetTempFilePath.cmd does not exist
set result=1
goto EndOfScript

:GetTemp
for /f %%a in ('%SrcFolder%\srcToolsAndTest\Scripts\GetTempFilePath.cmd') do set TEMP_PATH=%%a
if NOT "%TEMP_PATH%"=="" goto SetTemp
echo ERROR: Unable to set TEMP_PATH
set result=1
goto EndOfScript

:SetTemp
DIR /B /AD /S /O:N | findstr "\\Release$" >"%TEMP_PATH%" 2>NUL
DIR /B /AD /S /O:N | findstr "\\bin$" >>"%TEMP_PATH%" 2>NUL
DIR /B /AD /S /O:N | findstr "\\log$" >>"%TEMP_PATH%" 2>NUL
DIR /B /AD /S /O:N | findstr "\\obj$" >>"%TEMP_PATH%" 2>NUL
DIR /B /AD /S /O:N | findstr "\\Properties$" >>"%TEMP_PATH%" 2>NUL
DIR /B /AD /S /O:N | findstr "\\Resources$" >>"%TEMP_PATH%" 2>NUL

for /F "tokens=*" %%A in (%TEMP_PATH%) do RMDIR /S /Q "%%A" 2>NUL

@echo on
if exist Hydra.Web\Client\Build rmdir /s/q Hydra.Web\Client\Build
if exist HIX\Hydra.IX.Database\Db rmdir /s/q HIX\Hydra.IX.Database\Db
if exist Hydra.Web\Client\Build\lib rmdir /s/q Hydra.Web\Client\Build\lib
if exist Hydra.Web\Client\Develop\assets rmdir /s/q Hydra.Web\Client\Develop\assets
if exist Hydra.Web\Client\Develop\bootstrap rmdir /s/q Hydra.Web\Client\Develop\bootstrap
if exist Hydra.Web\Client\Develop\images rmdir /s/q Hydra.Web\Client\Develop\images
if exist Hydra.Web\Client\Develop\js\datatable rmdir /s/q Hydra.Web\Client\Develop\js\datatable
if exist Hydra.Web\Client\Develop\js\jquery-ui-1.8.23.custom rmdir /s/q Hydra.Web\Client\Develop\js\jquery-ui-1.8.23.custom
if exist Hydra.Web\Client\Develop\js\kendo rmdir /s/q Hydra.Web\Client\Develop\js\kendo
if exist Hydra.Web\Client\Develop\js\layouts rmdir /s/q Hydra.Web\Client\Develop\js\layouts
if exist Hydra.Web\Client\Develop\js\pdf rmdir /s/q Hydra.Web\Client\Develop\js\pdf
if exist Hydra.Web\Client\Develop\js\sessionscript rmdir /s/q Hydra.Web\Client\Develop\js\sessionscript
if exist Hydra.Web\Client\Develop\style rmdir /s/q Hydra.Web\Client\Develop\style
if exist Hydra.Web\Client\Release rmdir /s/q Hydra.Web\Client\Release
if exist Hydra.Web\Client\ToBeDetermined rmdir /s/q Hydra.Web\Client\ToBeDetermined
if exist VIX.Render.Service\Xsl rmdir /s/q VIX.Render.Service\Xsl
if exist VIX.Viewer.Service\doc rmdir /s/q VIX.Viewer.Service\doc
if exist VIX.Viewer.Service.Client rmdir /s/q VIX.Viewer.Service.Client

del *.config/s 2>NUL
del *.dll/s 2>NUL
del *.docx/s 2>NUL
del *.exe/s 2>NUL
del *.ps1/s 2>NUL
del *.cmd/s 2>NUL
del *.sql/s 2>NUL
del *.jpg/s 2>NUL
del *.bmp/s 2>NUL
del *.png/s 2>NUL
del *.ico/s 2>NUL
del *.gif/s 2>NUL
del *.cur/s 2>NUL
del *.csproj/s 2>NUL
del *.resx/s 2>NUL
del *.txt/s 2>NUL
del *.md/s 2>NUL
del *.jar/s 2>NUL
del *.pdf/s 2>NUL
del *.sdf /s 2>NUL
del *.xlsx/s 2>NUL
del *.xsl/s 2>NUL
del angular*.js /s 2>NUL
del bootstrap*.* /s 2>NUL
del datepicker*.js /s 2>NUL
del easyResponsiveTabs.js /s 2>NUL
del jquery*.* /s 2>NUL
del jquery-ui-*.*/s 2>NUL
del json2*.js/s 2>NUL
::vvv TODO-Remove after VAI-134 vvv
del ng-grid*.* /s 2>NUL
del pako.js/s 2>NUL
del pako.min.js/s 2>NUL
del purify.js/s 2>NUL
::^^^ TODO-Remove after VAI-134 ^^^
::For some weird reason, if this pause isn't here, the line 'del spectrum.min.js...' does not get executed
pause
del spectrum.min.js /s 2>NUL
del spin.js /s 2>NUL
del ui-bootstrap*.js /s 2>NUL

set result=0

:EndOfScript
popd
:VeryEndOfScript
exit /b %result%
