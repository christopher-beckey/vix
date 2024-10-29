#This script will get the process IDs for the VIX Viewer, Render and Tomcat services
#It will stop and restart each service and then generate a log file to email to admins

# relaunch as an elevated process if not currently in administrator mode
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    $PSHost = If ($PSVersionTable.PSVersion.Major -gt 5) {'PwSh'} else {'PowerShell'}
    Start-Process $PSHost -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$($PWD.Path)'; & '$PSCommandPath'`"";
    Exit 
}

$tomcatname = "Tomcat9"
$viewername = "VIX Viewer Service"
$rendername = "VIX Render Service"
$listenname = "ListenerTool"

$tomcatpid = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$tomcatname'" | Select-Object -ExpandProperty ProcessId
$tomcatstatus = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$tomcatname'" | Select-Object -ExpandProperty Status
$tomcatstate = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$tomcatname'" | Select-Object -ExpandProperty State
$tomcatuptime = New-Timespan -Start (Get-Process -Id $tomcatpid).StartTime | Select-Object -ExpandProperty TotalDays
echo "***** Tomcat9 Service *****"
echo "   Tomcat PID: $tomcatpid"
echo "Tomcat Status: $tomcatstatus"
echo " Tomcat State: $tomcatstate"
echo "Tomcat Uptime: $tomcatuptime"
echo ""

$viewerpid = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$viewername'" | Select-Object -ExpandProperty ProcessId
$viewerstatus = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$viewername'" | Select-Object -ExpandProperty Status
$viewerstate = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$viewername'" | Select-Object -ExpandProperty State
$vieweruptime = New-Timespan -Start (Get-Process -Id $viewerpid).StartTime | Select-Object -ExpandProperty TotalDays
echo "***** VIX Viewer Service *****"
echo "   Viewer PID: $viewerpid"
echo "Viewer Status: $viewerstatus"
echo " Viewer State: $viewerstate"
echo "Viewer Uptime: $vieweruptime"
echo ""

$renderpid = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$rendername'" | Select-Object -ExpandProperty ProcessId
$renderstatus = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$rendername'" | Select-Object -ExpandProperty Status
$renderstate = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$rendername'" | Select-Object -ExpandProperty State
$renderuptime = New-Timespan -Start (Get-Process -Id $renderpid).StartTime | Select-Object -ExpandProperty TotalDays
echo "***** VIX Render Service *****"
echo "   Render PID: $renderpid"
echo "Render Status: $renderstatus"
echo " Render State: $renderstate"
echo "Render Uptime: $renderuptime"
echo ""

$listenpid = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$listenname'" | Select-Object -ExpandProperty ProcessId
$listenstatus = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$listenname'" | Select-Object -ExpandProperty Status
$listenstate = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$listenname'" | Select-Object -ExpandProperty State
$listenuptime = New-Timespan -Start (Get-Process -Id $listenpid).StartTime | Select-Object -ExpandProperty TotalDays
echo "***** VIX listen Service *****"
echo "   Listen PID: $listenpid"
echo "Listen Status: $listenstatus"
echo " Listen State: $listenstate"
echo "Listen Uptime: $listenuptime"
echo ""
echo "***** DONE *****"

Write-Host "DONE with Service Info"
