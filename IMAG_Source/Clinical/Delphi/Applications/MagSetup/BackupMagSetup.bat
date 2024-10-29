@ECHO OFF
SETLOCAL
SET @Code="MagSetup\"
SET @BACKUPDIR="..\backup\"
IF NOT EXIST %@BACKUPDIR% MD %@BACKUPDIR%
FOR /F "DELIMS=" %%T IN ('TIME /T') DO SET @TIME=%%T
FOR /F "TOKENS=1" %%D IN ('DATE /T') DO SET @DAY=%%D
FOR /F "TOKENS=2" %%D IN ('DATE /T') DO SET @DATE=%%D
SET @DD=%@DATE:~3,2%
SET @MM=%@DATE:~0,2%
SET @YYYY=%@DATE:~6,4%
SET @HOUR=%@TIME:~0,2%
SET @SUFFIX=%@TIME:~6,1%
IF /I "%@SUFFIX%"=="A" IF %@HOUR% EQU 12 SET @HOUR=00
IF /I "%@SUFFIX%"=="P" IF %@HOUR% LSS 12 SET /A @HOUR+=12
SET @NOW=%@HOUR%%@TIME:~3,2%
SET @NOW=%@NOW: =0%
SET @TODAY=%@YYYY%%@MM%%@DD%
SET @FILESTAMP=%@TODAY%%@NOW%
REM FOR /F %%i in ("%0") DO SET CURPATH=%%~dpi
ECHO ON
XCOPY "..\%@Code%*.bat" "%@BACKUPDIR%%@Code%%@FILESTAMP%\*.bat" /E /Y > BackupDir.log
XCOPY "..\%@Code%*.bmp" "%@BACKUPDIR%%@Code%%@FILESTAMP%\*.bmp" /E /Y >> BackupDir.log
XCOPY "..\%@Code%*.dcr" "%@BACKUPDIR%%@Code%%@FILESTAMP%\*.dcr" /E /Y >> BackupDir.log
XCOPY "..\%@Code%*.dfm" "%@BACKUPDIR%%@Code%%@FILESTAMP%\*.dfm" /E /Y >> BackupDir.log
XCOPY "..\%@Code%*.dof" "%@BACKUPDIR%%@Code%%@FILESTAMP%\*.dof" /E /Y >> BackupDir.log
XCOPY "..\%@Code%*.dpk" "%@BACKUPDIR%%@Code%%@FILESTAMP%\*.dpk" /E /Y >> BackupDir.log
XCOPY "..\%@Code%*.dpr" "%@BACKUPDIR%%@Code%%@FILESTAMP%\*.dpr" /E /Y >> BackupDir.log
XCOPY "..\%@Code%*.drc" "%@BACKUPDIR%%@Code%%@FILESTAMP%\*.drc" /E /Y >> BackupDir.log
XCOPY "..\%@Code%*.dsk" "%@BACKUPDIR%%@Code%%@FILESTAMP%\*.dsk" /E /Y >> BackupDir.log
XCOPY "..\%@Code%*.exe" "%@BACKUPDIR%%@Code%%@FILESTAMP%\*.exe" /E /Y >> BackupDir.log
XCOPY "..\%@Code%*.ico" "%@BACKUPDIR%%@Code%%@FILESTAMP%\*.ico" /E /Y >> BackupDir.log
XCOPY "..\%@Code%*.map" "%@BACKUPDIR%%@Code%%@FILESTAMP%\*.map" /E /Y >> BackupDir.log
XCOPY "..\%@Code%*.pas" "%@BACKUPDIR%%@Code%%@FILESTAMP%\*.pas" /E /Y >> BackupDir.log
XCOPY "..\%@Code%*.properties" "%@BACKUPDIR%%@Code%%@FILESTAMP%\*.properties" /E /Y >> BackupDir.log
XCOPY "..\%@Code%*.res" "%@BACKUPDIR%%@Code%%@FILESTAMP%\*.res" /E /Y >> BackupDir.log
XCOPY "..\%@Code%*.txt" "%@BACKUPDIR%%@Code%%@FILESTAMP%\*.txt" /E /Y >> BackupDir.log
ENDLOCAL
