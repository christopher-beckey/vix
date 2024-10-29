@ECHO OFF
SETLOCAL
FOR %%A IN (.) DO (
SET @Code=%%~nA
)
SET @Code=%@Code%\
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
MD "%@BACKUPDIR%%@Code%%@FILESTAMP%\"
XCOPY "..\%@Code%*.bat*" "%@BACKUPDIR%%@Code%%@FILESTAMP%\" /E /Y > "%@BACKUPDIR%%@Code%%@FILESTAMP%\BackupDir.log"
XCOPY "..\%@Code%*.bmp*" "%@BACKUPDIR%%@Code%%@FILESTAMP%\" /E /Y >> "%@BACKUPDIR%%@Code%%@FILESTAMP%\BackupDir.log"
XCOPY "..\%@Code%*.cfg*" "%@BACKUPDIR%%@Code%%@FILESTAMP%\" /E /Y >> "%@BACKUPDIR%%@Code%%@FILESTAMP%\BackupDir.log"
XCOPY "..\%@Code%*.dcr*" "%@BACKUPDIR%%@Code%%@FILESTAMP%\" /E /Y >> "%@BACKUPDIR%%@Code%%@FILESTAMP%\BackupDir.log"
XCOPY "..\%@Code%*.dfm*" "%@BACKUPDIR%%@Code%%@FILESTAMP%\" /E /Y >> "%@BACKUPDIR%%@Code%%@FILESTAMP%\BackupDir.log"
XCOPY "..\%@Code%*.dof*" "%@BACKUPDIR%%@Code%%@FILESTAMP%\" /E /Y >> "%@BACKUPDIR%%@Code%%@FILESTAMP%\BackupDir.log"
XCOPY "..\%@Code%*.dpk*" "%@BACKUPDIR%%@Code%%@FILESTAMP%\" /E /Y >> "%@BACKUPDIR%%@Code%%@FILESTAMP%\BackupDir.log"
XCOPY "..\%@Code%*.dpr*" "%@BACKUPDIR%%@Code%%@FILESTAMP%\" /E /Y >> "%@BACKUPDIR%%@Code%%@FILESTAMP%\BackupDir.log"
XCOPY "..\%@Code%*.drc*" "%@BACKUPDIR%%@Code%%@FILESTAMP%\" /E /Y >> "%@BACKUPDIR%%@Code%%@FILESTAMP%\BackupDir.log"
XCOPY "..\%@Code%*.dsk*" "%@BACKUPDIR%%@Code%%@FILESTAMP%\" /E /Y >> "%@BACKUPDIR%%@Code%%@FILESTAMP%\BackupDir.log"
XCOPY "..\%@Code%*.exe*" "%@BACKUPDIR%%@Code%%@FILESTAMP%\" /E /Y >> "%@BACKUPDIR%%@Code%%@FILESTAMP%\BackupDir.log"
XCOPY "..\%@Code%*.hlp*" "%@BACKUPDIR%%@Code%%@FILESTAMP%\" /E /Y >> "%@BACKUPDIR%%@Code%%@FILESTAMP%\BackupDir.log"
XCOPY "..\%@Code%*.ico*" "%@BACKUPDIR%%@Code%%@FILESTAMP%\" /E /Y >> "%@BACKUPDIR%%@Code%%@FILESTAMP%\BackupDir.log"
XCOPY "..\%@Code%*.ide*" "%@BACKUPDIR%%@Code%%@FILESTAMP%\" /E /Y >> "%@BACKUPDIR%%@Code%%@FILESTAMP%\BackupDir.log"
XCOPY "..\%@Code%*.ini*" "%@BACKUPDIR%%@Code%%@FILESTAMP%\" /E /Y >> "%@BACKUPDIR%%@Code%%@FILESTAMP%\BackupDir.log"
XCOPY "..\%@Code%*.map*" "%@BACKUPDIR%%@Code%%@FILESTAMP%\" /E /Y >> "%@BACKUPDIR%%@Code%%@FILESTAMP%\BackupDir.log"
XCOPY "..\%@Code%*.pas*" "%@BACKUPDIR%%@Code%%@FILESTAMP%\" /E /Y >> "%@BACKUPDIR%%@Code%%@FILESTAMP%\BackupDir.log"
XCOPY "..\%@Code%*.pro*" "%@BACKUPDIR%%@Code%%@FILESTAMP%\" /E /Y >> "%@BACKUPDIR%%@Code%%@FILESTAMP%\BackupDir.log"
XCOPY "..\%@Code%*.res*" "%@BACKUPDIR%%@Code%%@FILESTAMP%\" /E /Y >> "%@BACKUPDIR%%@Code%%@FILESTAMP%\BackupDir.log"
XCOPY "..\%@Code%*.txt*" "%@BACKUPDIR%%@Code%%@FILESTAMP%\" /E /Y >> "%@BACKUPDIR%%@Code%%@FILESTAMP%\BackupDir.log"
XCOPY "..\%@Code%*.xls*" "%@BACKUPDIR%%@Code%%@FILESTAMP%\" /E /Y >> "%@BACKUPDIR%%@Code%%@FILESTAMP%\BackupDir.log"
ENDLOCAL 

