param(
    [parameter(Mandatory=$False, Position=0)][string]$VixLocalCachePath="" # Local Cache Directory
)

# relaunch as an elevated process if not currently in administrator mode
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
	$PSHost = If ($PSVersionTable.PSVersion.Major -gt 5) {'PwSh'} else {'PowerShell'}
	Start-Process $PSHost -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$($PWD.Path)'; & '$PSCommandPath' $VixLocalCachePath`"";
	Exit
}

#launch PowerShell as 64 bit mode if not already done to ensure commands for apachetomcat user and permissions works
if ($env:PROCESSOR_ARCHITEW6432 -eq "AMD64") {
    Write-Warning "Running 32 bit Powershell on 64 bit OS, restarting as 64 bit process..."
    $PSExe = if ($PSVersionTable.PSVersion.Major -gt 5) {"$env:ProgramW6432\PowerShell\7\pwsh.exe"} else {"$env:WINDIR\sysnative\windowspowershell\v1.0\powershell.exe"}
    Start-Process $PSHost -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$($PWD.Path)'; & '$PSCommandPath' $VixLocalCachePath`"";
	Exit $lastexitcode
}

if ($VixLocalCachePath -eq "") {
    $VixLocalCachePath = [System.Environment]::GetEnvironmentVariable('vixcache') -replace "/", "\"
    if ($VixLocalCachePath -eq "")
    {
        $driveLetters = Get-CimInstance Win32_LogicalDisk
        foreach ($drive in $driveLetters.DeviceID) {
            $VixLocalCachePath="$($Drive)\VixCache"
            if (Test-Path -Path $VixLocalCachePath){
                break;
            }
        }
    }
}

# delete contents of the VixCache if the path exists
if (Test-Path -path $VixLocalCachePath)
{
    $vixCacheSizeGB = (Get-ChildItem -Path $VixLocalCachePath -Recurse -ErrorAction SilentlyContinue | Where-Object { -not $_.PSIsContainer } | Measure-Object -Property Length -Sum).Sum / 1GB
    Write-Output "VixCache directory size is $vixCacheSizeGB GB."
    Write-Output "Attempting to delete the contents of $VixLocalCachePath"
    Get-ChildItem -Path "$VixLocalCachePath" -Recurse | Foreach-object {Remove-item -Recurse -Force -path $_.FullName}
}
else
{
     Write-Output "Did not attempt to delete the contents of $VixLocalCachePath as folder did not exist."
}