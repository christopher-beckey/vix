@echo off
setlocal EnableExtensions DisableDelayedExpansion
::Package the Hydra 2019 solution into the build\package\ZFViewerServices folder to be included in the installation
::The folder contains ViewerRender_%VERSION%.zip

set thisScriptsFileName=%~n0%~x0
set ABANDONED=Packaging abandoned.
goto GetArgs

::=============================================================== SHOW THIS SCRIPT'S CALLING SYNTAX AND ARGUMENTS
:ShowHelp
echo SYNTAX: %thisScriptsFileName% versionNumber [-d] [-h]
echo where:
echo -d = enable debug (Optional, default is *DISABLE*) If specified, shows blow-by-blow execution of this script
echo -h = help (Optional, default is *NOT* to show) If specified, shows this help info and exits
echo versionNumber = version number (Required, assumed in MAJORMINOR.PATCH.TEST.BUILD format, as shown in the examples below)
echo EXAMPLES:
echo %thisScriptsFileName% 30.249.2.7803
echo %thisScriptsFileName% 30.249.2.7803 -d
goto :EOF


:GetArgs
::Command line arguments
set VERSION=
set DEBUG=
::=============================================================== PARSE COMMAND LINE
:Loop
if "%1"=="" goto DoneArgs
if "%1"=="-d" goto GotDebug
if "%1"=="-h" goto ShowHelp
if "%1"=="-help" goto ShowHelp
if "%1"=="?" goto ShowHelp
if "%1"=="/?" goto ShowHelp
set VERSION=%1
:Next
shift
goto Loop
:GotDebug
set DEBUG=gotIt
echo on
goto Next
:DoneArgs

::VersionArg is a required command line argument
if "%VERSION%"=="" goto MissingArg
goto Prepare_01

:MissingArg
echo ERROR: Version number is a required command-line argument. %ABANDONED%
goto :ShowHelp

::=============================================================== PREPARE THE DELIVERABLE'S FOLDER AND WORKING FOLDER
:Prepare_01
::Windows session's current working directory
set CWD=%cd%
if exist Hydra.sln goto Prepare_02
echo ERROR: Please run this script from Hydra.sln's folder. %ABANDONED%
goto :EOF
:Prepare_02
::Deliverable parent/root folder
set DELIVERABLE_PATH_PARENT=%CWD%\build\package\ZFViewerServices
::Deliverable work-in-progress folder
set DELIVERABLE_PATH_WIP=%DELIVERABLE_PATH_PARENT%\ViewerRender_%VERSION%
::Clear package folder
if not exist %DELIVERABLE_PATH_PARENT% goto Prepare_03
::Make sure the package's deliverable folder is empty
PowerShell -NoLogo -NonInteractive -Command "Remove-Item -Recurse -Force %DELIVERABLE_PATH_PARENT%"
:Prepare_03
mkdir %DELIVERABLE_PATH_WIP%

::=============================================================== COPY THE FILES AND FOLDERS TO THE DELIVERABLE'S WORKING FOLDER
set TARG_DIR=%DELIVERABLE_PATH_WIP%\Scripts
set SRC_DIR=_Install Files\Scripts
if exist "%SRC_DIR%" goto CopyScripts
echo ERROR: %SRC_DIR% does not exist. %ABANDONED%
goto :EOF
:CopyScripts
robocopy "%SRC_DIR%" %TARG_DIR% /E >NUL

set TARG_DIR=%DELIVERABLE_PATH_WIP%\VIX.Config
set SRC_DIR=_Install Files\VIX.Config
if exist "%SRC_DIR%" goto CopyVixConfig
echo ERROR: %SRC_DIR% does not exist. %ABANDONED%
goto :EOF
:CopyVixConfig
robocopy "%SRC_DIR%" %TARG_DIR% /E >NUL

set TARG_DIR=%DELIVERABLE_PATH_WIP%\VIX.Render.Service
set SRC_DIR=src\VIX.Render.Service\bin\x64\Release
if exist %SRC_DIR% goto CopyVixRender
set SRC_DIR=src\VIX.Render.Service\bin\Release
if exist %SRC_DIR% goto CopyVixRender
echo ERROR: %SRC_DIR% does not exist. %ABANDONED%
goto :EOF
:CopyVixRender
robocopy %SRC_DIR% %TARG_DIR% /E >NUL
if not exist %TARG_DIR%\Configuration goto DoneCleanRenderConfig
del /Q %TARG_DIR%\Configuration\*.*
rmdir %TARG_DIR%\Configuration
:DoneCleanRenderConfig
if not exist %TARG_DIR%\de goto DoneCleanRenderDe
del /Q %TARG_DIR%\de\*.*
rmdir %TARG_DIR%\de
:DoneCleanRenderDe
if exist %TARG_DIR%\*.dll.config del /Q %TARG_DIR%\*.dll.config
if exist %TARG_DIR%\*.NLog.config del /Q %TARG_DIR%\*.NLog.config
if exist %TARG_DIR%\*.pdb del /Q %TARG_DIR%\*.pdb

set TARG_DIR=%DELIVERABLE_PATH_WIP%\VIX.Viewer.Service
set SRC_DIR=src\VIX.Viewer.Service\bin\x64\Release
if exist %SRC_DIR% goto CopyVixViewer
echo ERROR: %SRC_DIR% does not exist. %ABANDONED%
goto :EOF
:CopyVixViewer
robocopy %SRC_DIR% %TARG_DIR% /E >NUL
if exist srcToolsAndTest\SCIP_Tool\bin\x64\Release\SCIP_Tool.exe robocopy srcToolsAndTest\SCIP_Tool\bin\x64\Release %TARG_DIR%\SCIP_Tool /E >NUL
if not exist %TARG_DIR%\Configuration goto DoneCleanViewerConfig
del /Q %TARG_DIR%\Configuration\*.*
rmdir %TARG_DIR%\Configuration
:DoneCleanViewerConfig
if exist %TARG_DIR%\*.dll.config del /Q %TARG_DIR%\*.dll.config
if exist %TARG_DIR%\*.NLog.config del /Q %TARG_DIR%\*.NLog.config
if exist %TARG_DIR%\*.pdb del /Q %TARG_DIR%\*.pdb

if exist srcToolsAndTest\DeployedDesktopTools\Programs\TransactionEntryTracer\TransactionEntryTracer.exe copy srcToolsAndTest\DeployedDesktopTools\Programs\TransactionEntryTracer\TransactionEntryTracer.exe %TARG_DIR% >NUL

set TARG_DIR=%DELIVERABLE_PATH_WIP%\VIX.Viewer.Service.Client
set SRC_DIR=srcToolsAndTest\VIX.Viewer.Service.Client.Test\bin\Release
if exist %SRC_DIR% goto CopyVixViewerClient
echo ERROR: %SRC_DIR% does not exist. %ABANDONED%
goto :EOF
:CopyVixViewerClient
robocopy %SRC_DIR% %TARG_DIR% /E >NUL
if exist %TARG_DIR%\*.exe.config del /Q %TARG_DIR%\*.exe.config
if exist %TARG_DIR%\*.pdb del /Q %TARG_DIR%\*.pdb

PowerShell -NoLogo -NonInteractive -Command "Add-Type -assembly "system.io.compression.filesystem"; [System.IO.Compression.ZipFile]::CreateFromDirectory(\"%DELIVERABLE_PATH_WIP%\", \"%DELIVERABLE_PATH_WIP%.zip\")"
