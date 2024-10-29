#Stop the VIX Viewer/Render services, clear the cache, and restart the services

param
(
    [Parameter(Mandatory=$False)][string]$relativePath # if relative path desired user enters 1
)

# relaunch as an elevated process if not currently in administrator mode
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    $PSHost = If ($PSVersionTable.PSVersion.Major -gt 5) {'PwSh'} else {'PowerShell'}
    Start-Process $PSHost -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$($PWD.Path)'; & '$PSCommandPath' $relativePath`"";
    Exit
}

$configPath = "C:\Program Files\VistA\Imaging\VIX.Config\VIX.Render.config"
$curentSQLiteDbfile="C:\Program Files\VistA\Imaging\VIX.Render.Service\Db\SqLiteDb.db"
$emptySQLiteDbfile="C:\Program Files\VistA\Imaging\VIX.Render.Service\Db\SqliteDbEmpty.db"

if ($relativePath -eq "1")
{
	$configPath = "..\VIX.Config\VIX.Render.config"
	$curentSQLiteDbfile="..\VIX.Render.Service\Db\SqLiteDb.db"
    $emptySQLiteDbfile="..\VIX.Render.Service\Db\SqliteDbEmpty.db"
}

 function GetCacheFolder {
    if (Test-Path -Path $configPath -PathType leaf) {
        $myLine = Select-String -Path $configPath -pattern "ImageStores Path"
        $parts = $myLine -split "`""
        return $parts[1]
    }
    return "NOPE"
}

$rendername = "VIX Render Service"
#Shut down and restart VIX Render Service
#Pre-shutdown statuses
$renderpid = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$rendername'" | Select-Object -ExpandProperty ProcessId
$renderstatus = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$rendername'" | Select-Object -ExpandProperty Status
$renderstate = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$rendername'" | Select-Object -ExpandProperty State
echo "***** VIX Render Service *****"
echo "Render PID:  $renderpid"
echo $renderstatus
echo $renderstate

#check state
#if "Running", proceed to shutdown.  if not log and alert.
if ($renderstate -eq 'Running') {
	echo "Render service is running.  Stopping service..."
	Stop-Service -Name "$rendername" -Force
	#verifying service stopped
	Start-Sleep -s 10
	$renderstate = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$rendername'" | Select-Object -ExpandProperty State
}

$viewername = "VIX Viewer Service"
#Shut down and restart VIX Viewer Service
#Pre-shutdown statuses
$viewerpid = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$viewername'" | Select-Object -ExpandProperty ProcessId
$viewerstatus = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$viewername'" | Select-Object -ExpandProperty Status
$viewerstate = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$viewername'" | Select-Object -ExpandProperty State
echo "***** VIX Viewer Service *****"
echo "Viewer PID:  $viewerpid"
echo $viewerstatus
echo $viewerstate

#check state
#if "Running", proceed to shutdown.  if not log and alert.
if ($viewerstate -eq 'Running') {
	echo "Viewer service is running.  Stopping service..."
	Stop-Service -Name "$viewername" -Force
	#verifying service stopped
	Start-Sleep -s 10
	$viewerstate = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$viewername'" | Select-Object -ExpandProperty State
}

if ($renderstate -eq 'Stopped') {
	echo "Render service successfully stopped.  Checking for orphaned processes..."
	$renderprocs = (Get-Process | Where-Object {$_.Name -eq 'Hydra.IX.Processor'}).count
	echo "Render process count: $renderprocs"
	if ($renderprocs -gt 0) {
		echo "There are existing orphaned processes."
		echo "Killing orphans...so sad."
		Stop-Process -Name "Hydra.IX.Processor" -Force
	}
	
	Start-Sleep -s 5
	#Delete current SQLite database and restore empty one with just the tables        
	Remove-Item $curentSQLiteDbfile -Force 
	Write-Host "Curent SQLite db $curentSQLiteDbfile deleted."
	Copy-Item -Path $emptySQLiteDbfile -Destination $curentSQLiteDbfile
	Write-Host "Restored empty SQLite db."    
	Start-Sleep -s 2 
 
	#Delete current cache folder     
	$cacheFolder = GetCacheFolder 
	if (Test-Path -Path $CacheFolder) {
		Write-Host -Message 'Deleting cache folder...'
		Remove-Item "$CacheFolder\*" -Recurse -Force
	}
	
	Start-Sleep -s 2 
	echo "Restarting service..."
	Start-Service -Name "$rendername"
	#verifying service started
	Start-Sleep -s 10
	$renderstate3 = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$rendername'" | Select-Object -ExpandProperty State
	echo "$rendername is $renderstate3"
	if ($renderstate3 -eq 'Running') {
	echo "Render service successfully restarted."
	}
}

#Post-restart statuses
$prs_renderpid = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$rendername'" | Select-Object -ExpandProperty ProcessId
$prs_renderstatus = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$rendername'" | Select-Object -ExpandProperty Status
$prs_renderstate = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$rendername'" | Select-Object -ExpandProperty State
echo "-NEW- Render PID:  $prs_renderpid"
echo $prs_renderstatus
echo $prs_renderstate
echo "**********"
 
if ($viewerstate -eq 'Stopped') 
{
	echo "Viewer service successfully stopped.  Checking for orphaned processes..."
	$viewerprocs = (Get-Process | Where-Object {$_.Name -eq 'Hydra.VistA.Worker'}).count
	echo "Viewer process count: $viewerprocs"
	if ($viewerprocs -gt 0) {
		echo "There are existing orphaned processes."
		echo "Killing orphans...so sad."
		Stop-Process -Name "Hydra.VistA.Worker" -Force
	}
	
	Start-Sleep -s 5
	echo "Restarting service..."
	Start-Service -Name "$viewername"
	#verifying service started
	Start-Sleep -s 10
	$viewerstate3 = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$viewername'" | Select-Object -ExpandProperty State
	echo "$viewername is $viewerstate3"
	if ($viewerstate3 -eq 'Running') {
		echo "Viewer service successfully restarted."
	}
}

#Post-restart statuses
$prs_viewerpid = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$viewername'" | Select-Object -ExpandProperty ProcessId
$prs_viewerstatus = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$viewername'" | Select-Object -ExpandProperty Status
$prs_viewerstate = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$viewername'" | Select-Object -ExpandProperty State
echo "-NEW- Viewer PID:  $prs_viewerpid"
echo $prs_viewerstatus
echo $prs_viewerstate
echo "**********"