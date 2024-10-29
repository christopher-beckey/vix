# Pre-uninstall configuration backups

param(
    [parameter(Mandatory=$True, Position=0)][string]$InstallerVersionNum, # Patch Version Number without the P
    [parameter(Mandatory=$True, Position=1)][string]$RoleType, # Role Type as CVIX or VIX
    [parameter(Mandatory=$True, Position=2)][string]$PriorInstallerVersionNum # Prior Patch Version Number without the P
)

$global:countBackup=0
$global:countBackupExclude=0

# file location for critical config files
$scriptDirectory = "C:\Program Files\VistA\Imaging\Scripts"

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

function backupFileConfig($sourcePath1, $destinationPath1, $fileName1) {
	
	#create backup copy of install logs
	if (!(Test-Path $destinationPath1)) {
		New-Item -Path $destinationPath1 -ItemType Directory
	}
    
    if ([System.IO.File]::Exists("$sourcePath1\$fileName1")) {
        Copy-Item -Path $sourcePath1\$fileName1 -Destination $destinationPath1  
    }
}

$myTimestamp = Get-Date -Format 'yyyyMMddHHmmss'

#VAI 448 - back-up for Installer logs
$preBackVixInstallerPath = "C:\VIXbackup\P$PriorInstallerVersionNum\$myTimestamp\VixInstaller"
# for VIX
if ($RoleType -ne "CVIX") {
    $sourceFolderInstallLog = "C:\Program Files (x86)\Vista\Imaging\VixInstaller"
}
# for CVIX
else {
    $sourceFolderInstallLog = "C:\Program Files (x86)\Vista\Imaging\CvixInstaller"
}
$preBackVixInstallerLog= "vix-install-log.txt"
$sourceFolderTempInstallLog = "C:\VIXbackup\temp"
if ([System.IO.Directory]::Exists($sourceFolderTempInstallLog)) 
{ 
    backupFileConfig $sourceFolderTempInstallLog $preBackVixInstallerPath $preBackVixInstallerLog
} 
$preBackVixInstallerPreLog= "vix-install-pre-log.txt"
$preBackVixInstallerPostLog= "vix-install-post-log.txt"
$preBackVixInstallerPrePostFiles = @($preBackVixInstallerPreLog, $preBackVixInstallerPostLog)
# perform install log back-ups before creating the new vix-install-pre-log.txt
foreach ($preBackVixInstallerPrePostFile in $preBackVixInstallerPrePostFiles) {	
	# check if folders to be backed-up exist before backing up
	if ([System.IO.Directory]::Exists($sourceFolderInstallLog)) 
	{ 
		backupFileConfig $sourceFolderInstallLog $preBackVixInstallerPath $preBackVixInstallerPrePostFile
	} 
}
$preBackVixInstallerAllFiles = @($preBackVixInstallerPreLog, $preBackVixInstallerLog, $preBackVixInstallerPostLog)
																		   
# check if transcript path exists otherwise create the folder
# for VIX
if ($RoleType -ne "CVIX") {
	$transcriptPath = "C:\Program Files (x86)\Vista\Imaging\VixInstaller\"
}
# for CVIX
else {
	$transcriptPath = "C:\Program Files (x86)\Vista\Imaging\CvixInstaller\"
}

if(!(Test-Path -path $transcriptPath))  
{  
    New-Item -ItemType directory -Path $transcriptPath
    Write-Host "Folder path has been created successfully at: " $transcriptPath               
}

# for VIX
if ($RoleType -ne "CVIX") {
	Start-Transcript -Path ("C:\Program Files (x86)\Vista\Imaging\VixInstaller\vix-install-pre-log.txt")
}
# for CVIX
else {
	Start-Transcript -Path ("C:\Program Files (x86)\Vista\Imaging\CvixInstaller\vix-install-pre-log.txt")
}

# config backup
Write-Host "****************************************************"
Write-Host "****************************************************"
Write-Host "               VIX Backup"
Write-Host "****************************************************"
Write-Host "****************************************************"
Write-Host $myTimestamp

#report status of install log back-ups, now that the transcript has started since back-ups occured prior to starting a new vix-install-pre-log.txt
foreach ($preBackVixInstallerFile in $preBackVixInstallerAllFiles) {		
    if ([System.IO.File]::Exists("$preBackVixInstallerPath\$preBackVixInstallerFile")) 
    {
        Write-Host "Install log backup $preBackVixInstallerPath\$preBackVixInstallerFile was created."   
    }
    else
    {
        Write-Host "Install log backup $preBackVixInstallerPath\$preBackVixInstallerFile was not created!" 
    }
}

# source folder location for VixConfig
$sourceFolderVixConfig = [System.Environment]::GetEnvironmentVariable('vixconfig') -replace "/", "\"
if ($null -eq $sourceFolderVixConfig)
{
    $sourceFolderVixConfig = "C:\VixConfig"   
}

#VAI 365 automate manual step of VixConfig\logs deletion for JAVA conflict
$vixTxLogsDbPath = [System.Environment]::GetEnvironmentVariable('vixtxdb') -replace "/", "\"
if ("" -eq $vixTxLogsDbPath)
{
    $vixTxLogsPathOld ='C:\VixConfig\logs'
    if (Test-Path -path $vixTxLogsPathOld)
    {
        $newLogsName="logs_$myTimestamp"
        Rename-Item -Path $vixTxLogsPathOld -NewName $newLogsName
        Write-Output "Removing back-ups of $vixTxLogsPathOld"
        Get-ChildItem -Path $sourceFolderVixConfig -Filter logs* | Remove-Item -force -recurse
    }
    else
    {
       Write-Output "vixtxlogs environment variable and $vixTxLogsPathOld folder did not exist"
    }
}
else
{
    if (Test-Path -path $vixTxLogsDbPath)
    {
        $vixTxPath = Split-Path -Path $vixTxLogsDbPath -Parent
        $newTxDbName="VixTxDb_$myTimestamp"
        Rename-Item -Path $vixTxLogsDbPath -NewName $newTxDbName
        Write-Output "Removing back-ups of $vixTxLogsDbPath"
        Get-ChildItem -Path $vixTxPath -Filter VixTxDb* | Remove-Item -force -recurse
    }
    if (!(Test-Path -path $vixTxLogsDbPath))
    {
        New-Item -ItemType directory -Path $vixTxLogsDbPath
        Write-Output "Folder path has been created successfully at: " $vixTxLogsDbPath     
    }
}

#VAI-1259 - revert the permissions on jmxremote.password to full control for administrators prior to back-up
$jmxPasswordPath = 'C:\Program Files\Apache Software Foundation\Tomcat 9.0\conf\jmxremote.password'
if ([System.IO.File]::Exists($jmxPasswordPath))
{
    try {
        Write-Output "Setting permissions on jmxremote.password"
        $userName = 'administrators'
        $rights = "FullControl"
        $inheritSettings = "None"
        $propogationSettings = "None"
        $ruleType = "Allow"
        $acl = Get-Acl $jmxPasswordPath
        $perm = $userName, $rights, $inheritSettings, $propogationSettings, $ruleType
        $rule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $perm
        $acl.SetAccessRuleProtection($true,$false)        
        $acl.SetOwner([System.Security.Principal.NTAccount]$userName)
        $acl.SetAccessRule($rule)
        $acl | Set-Acl -Path $jmxPasswordPath
    }
    catch {
        "An error occurred during setting of the permissions on jmxremote.password."
        $_.Exception
    }   
}
else
{
    "$jmxPasswordPath does not exist."
}

# folder location for pre-install backups if they exist 
$preBackPath = "C:\VIXbackup\P$PriorInstallerVersionNum\"

# folder location for backups (except VixConfig and DCF_RunTime_x64)
$preBackVIXDotConfigPath = "C:\VIXbackup\P$PriorInstallerVersionNum\$myTimestamp\VIX.Config"
$preBackApacheConfPath = "C:\VIXbackup\P$PriorInstallerVersionNum\$myTimestamp\Tomcat 9.0\conf"
$preBackVixCertStorePath = "C:\VIXbackup\P$PriorInstallerVersionNum\$myTimestamp\VixCertStore"
$preBackPath = @($preBackVIXDotConfigPath, $preBackApacheConfPath, $preBackVixCertStorePath)

# source folder locations to be backed-up
$sourceFoldeVIXDotConfigPath = "C:\Program Files\VistA\Imaging\VIX.Config"
$sourceFolderApacheConfPath = "C:\Program Files\Apache Software Foundation\Tomcat 9.0\conf"
$sourceFolderVixCertStorePath= "C:\VixCertStore\"
$sourceFolderPath = @($sourceFoldeVIXDotConfigPath, $sourceFolderApacheConfPath, $sourceFolderVixCertStorePath)

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
$backPathArchivedLogs = "C:\VIXbackup\P$PriorInstallerVersionNum\$myTimestamp\Tomcat 9.0\logs"
if(Test-Path "$sourceFolderApacheLogs\$folderNameApacheLogsLink")
{
   backupSymLinkFolder $sourceFolderApacheLogs $folderNameApacheLogsLink $backPathArchivedLogs
}

# folder location for backups for VixConfig
$preBackVixConfigPath = "C:\VIXbackup\P$PriorInstallerVersionNum\$myTimestamp\VixConfig"
# sub-folders to exclude from backing up for VixConfig
$excludeVixConfig = @('logs*', 'ROI', 'thumbnailMaker', 'images')

# check if VixConfig folder exists before backing up
if ([System.IO.Directory]::Exists($sourceFolderVixConfig)) 
{ 
	#create backup copy of critical config file folders for VixConfig
	Write-Host "Backing up $preBackVixConfigPath from $sourceFolderVixConfig"
	
	if (!(Test-Path $preBackVixConfigPath)) {
		New-Item -Path $preBackVixConfigPath -ItemType Directory
	}
	
	Copy-Item -Path (Get-Item -Path "$sourceFolderVixConfig\*" -Exclude ($excludeVixConfig)).FullName -Destination $preBackVixConfigPath -Recurse -Force				
} 
else 
{ 
	Write-Host "File $sourceFolderVixConfig was not found! No backup created!"  -foregroundcolor red 
}

# folder location for backups for DCF_RunTime_x64
$preBackDCFRuntimeCFGPath = "C:\VIXbackup\P$PriorInstallerVersionNum\$myTimestamp\DCF_RunTime_x64\cfg"
# source folder location for DCF_RunTime_x64
$DCF_CFG_Path = [System.Environment]::GetEnvironmentVariable('DCF_CFG')
if($DCF_CFG_Path -eq $null)
{
	$DCF_CFG_Path = "C:\DCF_RunTime_x64\cfg"
	Write-Host "Using $DCF_CFG_Path"
}
# sub-folders to exclude from backing up for DCF_RunTime_x64
$excludeDCFCFGConfig = @('apps', 'components', 'procs')

$preBackPathExclude = @($preBackVixConfigPath, $preBackDCFRuntimeCFGPath)
$sourceFolderPathExclude = @($sourceFolderVixConfig, $DCF_CFG_Path)
$excludeFolderPathExclude = @($excludeVixConfig, $excludeDCFCFGConfig)

# loop and check if folder exists before backing up
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

#run any patch specific pre-scripts that may exist (ie. p269_pre_script.ps1)
Write-Host "****************************************************"
Write-Host "****************************************************"
Write-Host "              Patch" $InstallerVersionNum "Scripts"
Write-Host "****************************************************"
Write-Host "****************************************************"
$patchFiles=Get-ChildItem -Path ($scriptDirectory + "\p" + $InstallerVersionNum + "_pre*.ps1")
if (!$patchFiles)
{
	Write-Host "No Patch Specific Pre-Scripts Found"
}
else
{
	foreach($patchspecfile in $patchFiles)
	{
		if ([System.IO.File]::Exists($patchspecfile)) 
		{
            Write-Host "Executing $patchspecfile"
            &"$patchspecfile"		          
        }
		else
		{
			Write-Host "File $patchspecfile was not found! Script not run!"  -foregroundcolor red 
		}
	}
	Write-Host "DONE executing additional patch specific scripts"
}

Stop-Transcript 