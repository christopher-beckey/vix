IF EXIST "%ProgramFiles%\PowerShell\7\pwsh.exe" (    
  Call:PreConfigPSSeven %*
) ELSE (
 Call:PreConfigPSFive %*
)

GOTO:eof

:PreConfigPSSeven
 pwsh -command "Start-Process -verb runas pwsh -Wait" "'-File \"%~dp0\PreUninstallConfigBackups.ps1\" \"%1\" \"%2\" \"%3\"'"
 GOTO:eof

:PreConfigPSFive
 powershell -command "Start-Process -verb runas powershell -Wait" "'-File \"%~dp0\PreUninstallConfigBackups.ps1\" \"%1\" \"%2\" \"%3\"'"
 GOTO:eof