@ECHO OFF
SET INSTALLDIR=%1

REM Remove the quotes around the install dir if necessary
SET INSTALLDIR=%INSTALLDIR:"=%

REM Remove the trailing \ if necessary
IF "%INSTALLDIR:~-1%"=="\" SET INSTALLDIR=%INSTALLDIR:~0,-1%

REM Set the permissions on mag.ini
echo y|cacls.exe "%INSTALLDIR%\mag.ini" /G Everyone:F
