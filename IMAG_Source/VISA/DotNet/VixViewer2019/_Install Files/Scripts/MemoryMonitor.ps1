param (
    [int]$MemoryThreshold = 125, #in MB
    [bool]$ScheduleTask = $false,
    [string]$ServiceName = "VIX Viewer Service"
)

$ScheduleTaskInt = [int]$ScheduleTask
# relaunch as an elevated process if not currently in administrator mode
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    $PSHost = If ($PSVersionTable.PSVersion.Major -gt 5) {'PwSh'} else {'PowerShell'}
    Start-Process $PSHost -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$($PWD.Path)'; & '$PSCommandPath' -MemoryThreshold $MemoryThreshold -ScheduleTask $ScheduleTaskInt -ServiceName $ServiceName`"";
    Exit 
}

Add-Type –AssemblyName System.Security

function Get-ScriptDirectory { Split-Path $MyInvocation.ScriptName }

$script = Join-Path (Get-ScriptDirectory) 'Write-Log.ps1'
. $script

$logPath = Join-Path (Get-ScriptDirectory) 'MemoryMonitor.log'

$menuColor = "Yellow"
$msgColor = "Magenta"
$cmdColor = "DarkMagenta"
$errorColor = "Red"

function Task-Schedule($Time, $RepeatInterval) {
    try {
        $action = New-ScheduledTaskAction -Execute 'pwsh.exe' -Argument "-ExecutionPolicy Bypass -File $($MyInvocation.ScriptName)" -WorkingDirectory (Get-ScriptDirectory)
        $settings = New-ScheduledTaskSettingsSet -Compatibility Win8
        if ($RepeatInterval -eq 0) {
            Write-Log -Message ("Scheduling task to run once at " + $Time + " daily") -Path $logPath
            $trigger = New-ScheduledTaskTrigger -At $Time -Daily
        } else {
            Write-Log -Message ("Scheduling the task to run at " + $Time + " with repeat interval for every " + $RepeatInterval + " hours") -Path $logPath
            $trigger = New-ScheduledTaskTrigger -At $Time -Once -RepetitionInterval (New-TimeSpan -Hours $RepeatInterval) 
        }

        $principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
        Register-ScheduledTask -TaskName "VIX Viewer Memory Monitor" -Description "VIX Viewer Memory Monitor" -Action $action -Trigger $trigger -Principal $principal -Settings $settings
        
        Write-Log -Message 'Task scheduled' -Path $logPath
    }
    catch [Exception] {
        Write-Log -Message ('Failed to schedule task,' + "`n " + 'Exception:{0}' -f $_.Exception.Message) -Path $logPath
    }
}

function Test-Running($Exes) {
    foreach ($exe in $Exes) {
        if (Get-Process -Name $exe -ErrorAction SilentlyContinue) {
            return $true
        }
    }

    return $false
}

function Test-ServiceIsRunning($ServiceName) {

    if (Get-Service $ServiceName -ErrorAction SilentlyContinue) {
        if ((Get-Service $ServiceName).Status -eq 'Running') {
            return $true;
        }
    }

    return $false;
}

function Stop-ServiceProcesses($Name, $Exes) {
    if (Get-Service -Name $Name  -ErrorAction SilentlyContinue) {

        $scexe = "sc.exe"

        # stop service
        $arglist = @("stop", $Name)
        Write-Log -Message ('{0} {1}' -f $scexe, "$arglist") -Path $logPath
        & $scexe $arglist
        Start-Sleep -Seconds 5

        # wait if processes are running
        $val = 0
        while ($true) {
            if (!(Test-Running -Exes $Exes)) {
                Write-Log -Message "Service completely stopped." -Path $logPath
                break
            }
            Write-Log -Message "Service still running." -Path $logPath
            Start-Sleep -Seconds 5
            $Val++

            if ($val -eq 6) {
                Write-Log -Message "Error stopping service. Some processes are still running." -Path $logPath
                exit        
            }
        } 
    }
}

function Get-MemoryUsageinMB($Exes) {
    return Get-Counter "\Process(*VIX.Viewer.Service)\Working Set" | Foreach-Object {$_.CounterSamples[0].CookedValue/1mb}
}

function Show-Menu
{
    param (
        [string]$Title = 'Daily Schedule'
    )
    Write-Host -ForegroundColor $menuColor "================ $Title ================"
    
    $session = Read-Host "AM/PM"
    switch ($session)
    {
        'AM' {

        } 
         
        'PM' {

        }
        Default {
            Write-Host -ForegroundColor $msgColor "Please enter valid input"
            Show-Menu 
        }
    }
    [uint16]$daily = Read-Host "Run once at (1 - 12)"
    if ((($daily -gt 0) -and ($daily -lt 13))) {
        $time = ($daily.ToString() + ":26" + $session.ToUpper())
        $repeat = Read-Host "Do you want the task to repeat hourly, (y/n) ?"
        switch ($repeat)
        {
            Y {
                Show-HourlyMenu -Runtime $time
            }
            Default {
                Task-Schedule -Time $time -RepeatInterval 0
            }
        }
        
    } else {
        Write-Host -ForegroundColor $msgColor "Please enter valid input"
        Show-Menu
    }
    
}

function Show-HourlyMenu($runtime)
{
    [uint16]$hourly = Read-Host "Repeat after every (1 - 12)"
    if (($hourly -gt 0) -and ($hourly -lt 13)) {
        Task-Schedule -Time $runtime -RepeatInterval $hourly
    } else {
        Write-Host -ForegroundColor $msgColor "Please enter valid input"
        Show-HourlyMenu
    }
}

if ($ScheduleTask) {
    Show-Menu
} else {
    # get the state of services
    Write-Log -Message 'Checking service state...' -Path $logPath
    $servicesRunning = (Test-ServiceIsRunning $ServiceName)
    Write-Log -Message ('Viewer:{0}' -f $servicesRunning)  -Path $logPath

    $exeName = $ServiceName -replace ' ','.'

    $serviceMemoryUsage = Get-MemoryUsageinMB -Exes $exeName
    Write-Log -Message ('Viewer - Working Set:{0}' -f $serviceMemoryUsage) -Path $logPath
    $memoryLimitReached = $serviceMemoryUsage -ge $MemoryThreshold

    if ($servicesRunning -and $memoryLimitReached) {
        Write-Log -Message "Memory limit reaches threshold" -Path $logPath
        # stop services
        Write-Log -Message 'Stopping service...' -Path $logPath
        Stop-ServiceProcesses -Name $ServiceName -Exes @($exeName)

        # start services
        Write-Log -Message 'Starting service...' -Path $logPath
        Start-Service -Name $ServiceName
    } else {
        Write-Log -Message "Memory limit within threshold" -Path $logPath
    }
}