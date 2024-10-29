#P348 Pre-Install Script to remove apachetomcat duplicate accounts

# relaunch as an elevated process if not currently in administrator mode
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    $PSHost = If ($PSVersionTable.PSVersion.Major -gt 5) {'PwSh'} else {'PowerShell'}
    Start-Process $PSHost -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$($PWD.Path)'; & '$PSCommandPath'`"";
    Exit
}

function deleteFolders($foldersToDelete)
{
    # Delete each folder
    foreach ($folder in $foldersToDelete)
    {
        $folderFullPath = Join-Path -Path $folderPath -ChildPath $folder.Name
        Remove-Item -Path $folderFullPath -Recurse -Force
        Write-Output "Deleted folder: $folderFullPath"
    }
}

function deleteUser($targetUser)
{
    # Check if the user exists before deleting
    if (Get-CimInstance -ClassName Win32_UserAccount -Filter "Name='$targetUser'")
    {
        # Remove the user from all groups
        Get-LocalGroup | ForEach-Object {
            $groupName = $_.Name
            if (Get-LocalGroupMember -Group $groupName -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq $targetUser })
            {
                Remove-LocalGroupMember -Group $groupName -Member $targetUser -Confirm:$false
                Write-Output "Removed user $targetUser from group $groupName"
            }
        }

        # Delete the user
        Remove-LocalUser -Name $targetUser -Confirm:$false
        Write-Output "Deleted user $targetUser"
    }
    else
    {
        Write-Output "User $targetUser does not exist"
    }
}

function deleteProfileList($profileImagePathPatternOne, $profileImagePathPatternTwo)
{
    # Iterate through each ProfileImagePath subkey in the registry and delete those matching the pattern
    foreach ($subkey in $profileListSubkeys)
    {
        $profileImagePath = Get-ItemPropertyValue -Path $subkey.PSPath -Name ProfileImagePath -ErrorAction SilentlyContinue
        if ($null -ne $profileImagePathPatternTwo)
        {
            if ($profileImagePath -like "$profileImagePathPatternOne" -or $profileImagePath -like "$profileImagePathPatternTwo")
            {
                Remove-Item -Path $subkey.PSPath -Recurse -Force
                Write-Output "Deleted registry entry: $($subkey.PSChildName)"
            }
        }
        else
        {
            if ($profileImagePath -like "$profileImagePathPatternOne")
            {
                Remove-Item -Path $subkey.PSPath -Recurse -Force
                Write-Output "Deleted registry entry: $($subkey.PSChildName)"
            }
        }
    }
}

function deleteAccountUnknownSecurity
{
    # Define the folder path
    $tomcatPath = "C:\Program Files\Apache Software Foundation\Tomcat 9.0"
	$dcfPath = "C:\DCF_RunTime_x64"
    $vixConfigPath = [System.Environment]::GetEnvironmentVariable('vixconfig') -replace "/", "\"
    if ($null -eq $vixConfigPath)
    {
        $vixConfigPath = "C:\VixConfig"
    }
	$vixCertPath = "C:\VixCertStore"
    $VixLocalCachePath = [System.Environment]::GetEnvironmentVariable('vixcache') -replace "/", "\"
    if ($VixLocalCachePath -eq "")
    {
        $driveLetters = Get-CimInstance Win32_LogicalDisk
        foreach ($drive in $driveLetters.DeviceID)
        {
            $VixLocalCachePath="$($Drive)\VixCache"
            if (Test-Path -Path $VixLocalCachePath)
            {
                break;
            }
        }
    }

    # Determine the folders that exist to use
    $allPaths = @("$($tomcatPath)", "$($dcfPath)", "$($vixConfigPath)", "$($vixCertPath)", "$($VixLocalCachePath)")
    $folders = @()
    foreach ($folderPath in $allPaths)
    {
        if (Test-Path -Path $folderPath)
        {
            $folders += $folderPath
        }
        else
        {
            Write-Output "Folder does not exist: $folderPath"
        }
    }

    foreach ($folderPath in $folders)
    {
        # Get the security descriptor for the folder
        $securityDescriptor = Get-Acl -Path $folderPath

        # Get the SIDs of unknown accounts
        $unknownSIDs = $securityDescriptor.Access | Where-Object { $_.IdentityReference.Value.StartsWith("S-1-") } | Select-Object -ExpandProperty IdentityReference

        #Remove access for accounts with unknown SIDs
        foreach ($sid in $unknownSIDs) {
            $securityDescriptor.Access | Where-Object { $_.IdentityReference -eq $sid } | ForEach-Object {
                $securityDescriptor.RemoveAccessRule($_) | Out-Null
                Write-Output "Removed access for account with SID: $sid from folder: $folderPath"
            }
        }

        # Set the updated security descriptor for the folder
        Set-Acl -Path $folderPath -AclObject $securityDescriptor
    }
}

$folderPath = "C:\Users"
$patternOne = "^apachetomcat\.[a-zA-Z0-9]+"
$patternTwo = "^apachetomcat$"

# Get a list of folders matching the pattern
$foldersToDelete = Get-ChildItem -Path $folderPath -Directory | Where-Object {$_.Name -match $patternOne}

$profileImagePathPatternOne = "C:\Users\apachetomcat.*"
$profileImagePathPatternTwo = "C:\Users\apachetomcat*"

# Get all subkeys in the registry path
$profileListPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"
$profileListSubkeys = Get-ChildItem -Path $profileListPath

if ($null -ne $foldersToDelete)
{
    Write-Output "Found extra apachetomcat folders, continuing to delete apachetomcat"

    # Define the username to be deleted
    $targetUser = "apachetomcat"
    deleteUser $targetUser

    # Get a list of folders matching the pattern
    $foldersToDelete = Get-ChildItem -Path $folderPath -Directory | Where-Object {$_.Name -match $patternOne -or $_.Name -match $patternTwo}

    # Delete each folder
    deleteFolders $foldersToDelete

    #Delete from the registry Profile list
    deleteProfileList $profileImagePathPatternOne $profileImagePathPatternTwo
}
else
{
    Write-Output "Did not find extra apachetomcat folders"
    
    #Delete from the registry Profile list
    deleteProfileList $profileImagePathPatternOne $null
}

#Delete SIDS no longer used from each folder's security
deleteAccountUnknownSecurity