# relaunch as an elevated process if not currently in administrator mode
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    $PSHost = If ($PSVersionTable.PSVersion.Major -gt 5) {'PwSh'} else {'PowerShell'}
    Start-Process $PSHost -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$($PWD.Path)'; & '$PSCommandPath'`"";
    Exit 
}

Write-Host "This creates a scheduled task to restart Tomcat and VIX services."
Write-Host "It defaults to run at 4:00AM.  Site admins can change this if desired."

function scheduleRestart() {	
    # create a scheduled task for the VIX services restarts (Restart_VIX_Services.ps1) and sets the daily restart time to 04:00. 
	$user = "NT AUTHORITY\SYSTEM"
	$taskName = "Imaging Services Auto Daily Restart"
	$privileges = "Highest"
	$description = "VistA Imaging Exchange (VIX)"
	
	# Check if the Windows OS Version is newer than Server 2012 R2 and if so use PowerShell approach to schedule task otherwise 
	# use Windows command approach due to bug, https://github.com/PowerShell/PowerShell/issues/13645
	if ([System.Environment]::OSVersion.Version.Major -gt 6)
	{
		$action = New-ScheduledTaskAction -Execute "C:\Program Files\PowerShell\7\pwsh.exe" -Argument  "-file `"C:\Program Files\VistA\Imaging\Scripts\Restart_VIX_Services.ps1`""
		$trigger = New-ScheduledTaskTrigger -Daily -At 4:00am
		Register-ScheduledTask -Action $action -Trigger $trigger -User $user -TaskName $taskName -Description $description -RunLevel $privileges
	}
	else
	{
		$actionCMD = "'C:\Program Files\PowerShell\7\pwsh.exe' -File 'C:\Program Files\VistA\Imaging\Scripts\Restart_VIX_Services.ps1'"		
		SCHTASKS /CREATE /TR $actionCMD /SC DAILY /ST 04:00 /RU $user /TN $taskName /RL $privileges	
		# fetch task just created to update the description using Powershell cmdlets
		$task = Get-ScheduledTask $taskName
		# update the description
		$task.Description = $description
		$task | Set-ScheduledTask
	}
}

$taskName = "Imaging Services Auto Daily Restart"
$taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like $taskName }
# check if Imaging Services Auto Daily Restart task exists and add if it does not
if (!$taskExists) 
{
	Write-Host "Scheduled Task Not Found"
	Write-Host "Installing Auto Daily Restart Scheduled Task..."
	scheduleRestart
}

Write-Host "DONE with Task Scheduling"