@ECHO OFF
SET INSTALLDIR=%1

REM Remove the quotes around the install dir if necessary
SET INSTALLDIR=%INSTALLDIR:"=%

REM Remove the trailing \ if necessary
IF "%INSTALLDIR:~-1%"=="\" SET INSTALLDIR=%INSTALLDIR:~0,-1%

REM Set the permissions on the win.ini
echo y|cacls.exe "%WINDIR%\Win.ini" /G Everyone:F

REM Set the permissions on the imaging directory and sub directories
echo y|cacls.exe "%INSTALLDIR%" /G Everyone:F
IF EXIST echo y|cacls.exe "%INSTALLDIR%\Bmp" /G Everyone:F
IF EXIST echo y|cacls.exe "%INSTALLDIR%\Cache" /G Everyone:F
IF EXIST echo y|cacls.exe "%INSTALLDIR%\Image" /G Everyone:F
IF EXIST echo y|cacls.exe "%INSTALLDIR%\Import" /G Everyone:F
IF EXIST echo y|cacls.exe "%INSTALLDIR%\Lib" /G Everyone:F
IF EXIST echo y|cacls.exe "%INSTALLDIR%\Muse" /G Everyone:F

REM Clear out old files beginning with patch 95 - remove Read-Only attribute first
REM ** This section is being turned on and off if build is pre or post P95
REM <BEGIN p95 change>
if exist "%INSTALLDIR%\imgvwp10.exe" attrib -r "%INSTALLDIR%\imgvwp10.exe"
if exist "%INSTALLDIR%\imgvwp10.exe" del "%INSTALLDIR%\imgvwp10.exe"
if exist "%INSTALLDIR%\tele19n.exe" attrib -r "%INSTALLDIR%\tele19n.exe"
if exist "%INSTALLDIR%\tele19n.exe" del "%INSTALLDIR%\tele19n.exe"
REM <END p95 change>