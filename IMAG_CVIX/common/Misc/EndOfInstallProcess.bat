"%ProgramFiles%\PowerShell\7\pwsh.exe" -command "Start-Process -verb runas pwsh -Wait" "'-File \"%~dp0\ViewerRenderConfigChecker.ps1\" \"%1\" \"%2\" \"%3\" \"%4\"'"