# Pre-Installation VIX Config Backup

param
(
    [Parameter(Mandatory=$True, Position=0)][string]$InstallerVersionNum, # Patch Number without the P (such as 249, not P249)
    [Parameter(Mandatory=$True, Position=1)][string]$RoleType # CVIX or VIX
)

# relaunch as an elevated process if not currently in administrator mode
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    $PSHost = If ($PSVersionTable.PSVersion.Major -gt 5) {'PwSh'} else {'PowerShell'}
    Start-Process $PSHost -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$($PWD.Path)'; & '$PSCommandPath' $InstallerVersionNum $RoleType`"";
    Exit 
}

$global:countBackup=0
$global:countBackupExclude=0

function backupFolderConfig($sourcePath1, $destinationPath1) {

    #create backup copy of critical config file folders
    Write-Host "Backing up $destinationPath1 from $sourcePath1"

    if (!(Test-Path $destinationPath1)) {
        New-Item -Path $destinationPath1 -ItemType Directory
    }

    Copy-Item -Path $sourcePath1\* -Destination $destinationPath1 -Recurse
}

function backupFolderConfigExclude($sourcePath2, $destinationPath2, $excludePath2) {

    #create backup copy of critical config file folders and exclude certain folders
    Write-Host "Backing up $destinationPath2 from $sourcePath2"

    if (!(Test-Path $destinationPath2)) {
        New-Item -Path $destinationPath2 -ItemType Directory
    }

    Copy-Item -Path (Get-Item -Path "$sourcePath2\*" -Exclude ($excludePath2)).FullName -Destination $destinationPath2 -Recurse -Force
}

function backupSymLinkFolder($sourcePath3, $sourceLinkFolder, $destinationPath3) {
    
    #create backup of a symbolic link folder
    Write-Host "Backing up $destinationPath3\$sourceLinkFolder from $sourcePath3\$sourceLinkFolder"
    if(!(Test-Path $destinationPath3))
    {
         New-Item -Path $destinationPath3 -ItemType Directory
    }
    
    xcopy /b /i "$sourcePath3\$sourceLinkFolder" "$destinationPath3\$sourceLinkFolder" | Out-Null
}

$myTimestamp = Get-Date -Format 'yyyyMMddHHmmss'
Write-Host $myTimestamp

#VAI 365 automate manual step of VixConfig\logs deletion for JAVA conflict
$vixConfigPath = 'C:\VixConfig'
$vixConfigLogsPath='C:\VixConfig\logs'
Write-Host "Removing existing back-ups of VixConfig\logs"
Get-ChildItem -Path $vixConfigPath -Filter logs_* | Remove-Item -force -recurse
$newLogsName="logs_$myTimestamp"
Write-Host "Backing up current VixConfig\logs"
Rename-Item -Path $vixConfigLogsPath -NewName $newLogsName
if(!(Test-Path -path $vixConfigLogsPath))  
{  
    New-Item -ItemType directory -Path $vixConfigLogsPath
    Write-Host "Folder path has been created successfully at: " $vixConfigLogsPath
}

# folder location for pre-install backups if they exist 
$preBackPath = "C:\VIXbackup\P$InstallerVersionNum\"

# folder location for backups (except VixConfig and DCF_RunTime_x64)
$preBackVIXDotConfigPath = "C:\VIXbackup\P$InstallerVersionNum\$myTimestamp\VIX.Config"
$preBackApacheConfPath = "C:\VIXbackup\P$InstallerVersionNum\$myTimestamp\Tomcat 9.0\conf"
$preBackVixCertStorePath = "C:\VIXbackup\P$InstallerVersionNum\$myTimestamp\VixCertStore"
$preBackPath = @($preBackVIXDotConfigPath, $preBackApacheConfPath, $preBackVixCertStorePath)

# source folder locations to be backed-up
$sourceFolderVIXDotConfigPath = "C:\Program Files\VistA\Imaging\VIX.Config"
$sourceFolderApacheConfPath = "C:\Program Files\Apache Software Foundation\Tomcat 9.0\conf"
$sourceFolderVixCertStorePath= "C:\VixCertStore\"
$sourceFolderPath = @($sourceFolderVIXDotConfigPath, $sourceFolderApacheConfPath, $sourceFolderVixCertStorePath)

foreach ($sourceFolder in $sourceFolderPath) {
    $backPath=$preBackPath[$global:countBackup]
    $global:countBackup = $global:countBackup + 1

    # check if folders to be backed-up exist before backing up
    if ([System.IO.Directory]::Exists($sourceFolder)) 
    { 
        Write-Host "Folder $sourceFolder was found."
        backupFolderConfig $sourceFolder $backPath
    }
    else 
    { 
        Write-Host "File $sourceFolder was not found! No backup created!"  -foregroundcolor red 
    }
}

# source folder location for Tomcat logs containing symbolic link for ImagingArchivedLogsLink
$sourceFolderApacheLogs= "C:\Program Files\Apache Software Foundation\Tomcat 9.0\logs"
# folder name for symbolic link for ImagingArchivedLogsLink
$folderNameApacheLogsLink= "ImagingArchivedLogsLink"
# folder location for backups for Tomcat logs containing symbolic link for ImagingArchivedLogsLink
$backPathArchivedLogs = "C:\VIXbackup\P$InstallerVersionNum\$myTimestamp\Tomcat 9.0\logs"
if(Test-Path "$sourceFolderApacheLogs\$folderNameApacheLogsLink")
{
    backupSymLinkFolder $sourceFolderApacheLogs $folderNameApacheLogsLink $backPathArchivedLogs
}

# folder location for backups for VixConfig
$preBackVixConfigPath = "C:\VIXbackup\P$InstallerVersionNum\$myTimestamp\VixConfig"
# source folder location for VixConfig
$sourceFolderVixConfig = "C:\VixConfig"
# sub-folders to exclude from backing up for VixConfig
$excludeVixConfig = @('logs*', 'ROI', 'thumbnailMaker', 'images', 'ImageConversion')

# folder location for backups for DCF_RunTime_x64
$preBackDCFRuntimeCFGPath = "C:\VIXbackup\P$InstallerVersionNum\$myTimestamp\DCF_RunTime_x64\cfg"
# source folder location for DCF_RunTime_x64
$DCF_CFG_Path = [System.Environment]::GetEnvironmentVariable('DCF_CFG')
# sub-folders to exclude from backing up for DCF_RunTime_x64
$excludeDCFCFGConfig = @('apps', 'components', 'procs')

$preBackPathExclude = @($preBackVixConfigPath, $preBackDCFRuntimeCFGPath)
$sourceFolderPathExclude = @($sourceFolderVixConfig, $DCF_CFG_Path)
$excludeFolderPathExclude = @($excludeVixConfig, $excludeDCFCFGConfig)

# check if VixConfig folder exists before backing up
foreach ($sourceFolderExclude in $sourceFolderPathExclude) {
    $backPathExclude=$preBackPathExclude[$global:countBackupExclude]
    $excludePathExclude=$excludeFolderPathExclude[$global:countBackupExclude]
    $global:countBackupExclude = $global:countBackupExclude + 1

    # check if folders to be backed-up exist before backing up
    if ([System.IO.Directory]::Exists($sourceFolderExclude))
    { 
        Write-Host "Folder $sourceFolderExclude was found."
        backupFolderConfigExclude $sourceFolderExclude $backPathExclude $excludePathExclude
    } 
    else 
    { 
        Write-Host "File $sourceFolderExclude was not found! No backup created!"  -foregroundcolor red 
    }
}

Write-Host "DONE backing up config file folders"
