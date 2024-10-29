@echo off
setlocal

set TEMP_PATH=%temp%\dir.txt
if exist ..\VixViewer2019\srcToolsAndTest\Scripts\GetTempFilePath.cmd for /f %%A in ('..\VixViewer2019\srcToolsAndTest\Scripts\GetTempFilePath.cmd') do set TEMP_PATH=%%A

if not exist build\log mkdir build\log
set CL=build\log\clean.txt
set result=0

echo TEMP_PATH is (%TEMP_PATH%) Contains folders to delete, if any
echo CL is (%CL%) Should be empty on a good clean 

::Remove all bin obj x64 and log folders (recursive from here)
DIR /B /AD /S /O:N | findstr "\\bin\\" >%TEMP_PATH% 2>%CL%
DIR /B /AD /S /O:N | findstr "\\bin$" >>%TEMP_PATH% 2>>%CL%
DIR /B /AD /S /O:N | findstr "\\build\\" >>%TEMP_PATH% 2>>%CL%
DIR /B /AD /S /O:N | findstr "\\build$" >>%TEMP_PATH% 2>>%CL%
DIR /B /AD /S /O:N | findstr "\\log\\" >>%TEMP_PATH% 2>>%CL%
DIR /B /AD /S /O:N | findstr "\\log$" >>%TEMP_PATH% 2>>%CL%
DIR /B /AD /S /O:N | findstr "\\obj\\" >>%TEMP_PATH% 2>>%CL%
DIR /B /AD /S /O:N | findstr "\\obj$" >>%TEMP_PATH% 2>>%CL%
DIR /B /AD /S /O:N | findstr "\\x64\\" >>%TEMP_PATH% 2>>%CL%
DIR /B /AD /S /O:N | findstr "\\x64$" >>%TEMP_PATH% 2>>%CL%
DIR /B /AD /S /O:N | findstr "\\VixInstallerSetup\\Debug\\" >>%TEMP_PATH% 2>>%CL%
DIR /B /AD /S /O:N | findstr "\\VixInstallerSetup\\Debug$" >>%TEMP_PATH% 2>>%CL%
DIR /B /AD /S /O:N | findstr "\\VixInstallerSetup\\Nightly\\" >>%TEMP_PATH% 2>>%CL%
DIR /B /AD /S /O:N | findstr "\\VixInstallerSetup\\Nightly$" >>%TEMP_PATH% 2>>%CL%
DIR /B /AD /S /O:N | findstr "\\VixInstallerSetup\\Release\\" >>%TEMP_PATH% 2>>%CL%
DIR /B /AD /S /O:N | findstr "\\VixInstallerSetup\\Release$" >>%TEMP_PATH% 2>>%CL%

for /F "tokens=*" %%A in (%TEMP_PATH%) do RMDIR /S /Q "%%A" 2>>%CL%

call :checkFileStatusEmpty %CL%
if "%ErrStatus%"=="" echo CL is empty (good) & goto :CleanDone
echo CL's ErrorStatus is %ErrStatus%
set result=1

:CleanDone
exit /B %result%

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
