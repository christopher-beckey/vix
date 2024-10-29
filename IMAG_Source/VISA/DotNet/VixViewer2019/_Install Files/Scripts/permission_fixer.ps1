# sets apachetomcat user permissions and also adds the windows service account

param(
    [parameter(Position=0)][string]$VixLocalCachePath="", # Local Cache Directory
    [parameter(Position=1)][string]$VixTxLogsDbPath="", # Vix Transaction Logs Db Directory
    [parameter(Position=2)][string]$RoleType, # Role Type as CVIX or VIX
    [parameter(Mandatory=$false)][bool]$DeleteCache=$false # true to delete the VixCache folder prior to setting permissions
)

$DeleteCacheInt = [int]$DeleteCache

# relaunch as an elevated process if not currently in administrator mode
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
	$PSHost = If ($PSVersionTable.PSVersion.Major -gt 5) {'PwSh'} else {'PowerShell'}
	Start-Process $PSHost -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$($PWD.Path)'; & '$PSCommandPath' $VixLocalCachePath $VixTxLogsDbPath $RoleType -DeleteCache $DeleteCacheInt`"";
	Exit 
}

#launch PowerShell as 64 bit mode if not already done to ensure commands for apachetomcat user and permissions works
if ($env:PROCESSOR_ARCHITEW6432 -eq "AMD64") {
    Write-Warning "Running 32 bit Powershell on 64 bit OS, restarting as 64 bit process..."
    $PSExe = if ($PSVersionTable.PSVersion.Major -gt 5) {"$env:ProgramW6432\PowerShell\7\pwsh.exe"} else {"$env:WINDIR\sysnative\windowspowershell\v1.0\powershell.exe"}
    Start-Process $PSHost -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$($PWD.Path)'; & '$PSCommandPath' $VixLocalCachePath $RoleType -DeleteCache $DeleteCacheInt`"";
	Exit $lastexitcode   
}

if ($RoleType -ne $null) {
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

	# transcript for apachetomcat user permission log
	# for VIX
	if ($RoleType -ne "CVIX") {
	Start-Transcript -Path ("C:\Program Files (x86)\Vista\Imaging\VixInstaller\vix-install-post-log.txt")
	}
	# for CVIX
	else {
	Start-Transcript -Path ("C:\Program Files (x86)\Vista\Imaging\CvixInstaller\vix-install-post-log.txt")
	}
	
	# file location for install scripts
	$scriptDirectory = "C:\Program Files\VistA\Imaging\Scripts"
}

function Fix-SIDS {
	# Removes all non resolvable SIDs to fix PowerShell Get-LocalGroupMember - Failed to compare two elements in the array issue
	# https://github.com/PowerShell/PowerShell/issues/2996
	# Gain permission to SAM, privilege token adjustment 
	$nttools = Add-Type -Member '[DllImport("ntdll.dll")] public static extern int RtlAdjustPrivilege(ulong a, bool b, bool c, ref bool d);' -Name nttools -PassThru 
	9,17,18 | %{$nttools::RtlAdjustPrivilege($_, 1, 0, [ref]0) | out-null} 
	$regKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("SAM\SAM", 'ReadWriteSubTree', 'ChangePermissions') 
	$acl = $regkey.GetAccessControl() 
	$rule = New-Object System.Security.AccessControl.RegistryAccessRule([System.Security.Principal.SecurityIdentifier]'S-1-5-32-544', 'FullControl',"ContainerInherit,ObjectInherit","None",'Allow') 
	$acl.SetAccessRule($rule) 
	$regKey.SetAccessControl($acl) 
	$regKey.Close() 
	 
	# get binary from SAM 
	[byte[]]$bytes = (Get-ItemProperty 'HKLM:\SAM\SAM\Domains\Builtin\Aliases\00000220' -Name c).c 
	# offset position of sids 
	$os = [bitconverter]::ToUInt32($bytes[40..43],0) + 52 
	# length of sid area 
	$count = [bitconverter]::ToUInt32($bytes[44..47],0) 
	# extract sid area 
	[byte[]]$memberbytes = $bytes[$os..($os+$count)] 
	 
	# filter out non resolvable sids 
	[byte[]]$newmemberbytes = 0..(($memberbytes.Count / 28)-1) | ?{try{(New-Object System.Security.Principal.SecurityIdentifier ([byte[]]$memberbytes[($_*28)..(($_*28)+27)]),0).Translate([System.Security.Principal.NTAccount]);$true}catch{$false}} | %{[byte[]]$memberbytes[($_*28)..(($_*28)+27)]} 
	 
	# update members area length in header 
	[bitconverter]::GetBytes($newmemberbytes.count).CopyTo($bytes,44) 
	 
	# update membercount in header 
	[bitconverter]::GetBytes(($newmemberbytes.count / 28)).CopyTo($bytes,48) 
	 
	# write back data 
	Set-ItemProperty 'HKLM:\SAM\SAM\Domains\Builtin\Aliases\00000220' -Name C -Value ([byte[]]($bytes[0..($os-1)] + $newmemberbytes)) -Force | out-null 
	 
	# restore permissions 
	$regKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("SAM\SAM", 'ReadWriteSubTree', 'ChangePermissions') 
	$acl = $regKey.GetAccessControl() 
	$rule = New-Object System.Security.AccessControl.RegistryAccessRule([System.Security.Principal.SecurityIdentifier]'S-1-5-32-544','ReadPermissions,ChangePermissions','ContainerInherit,ObjectInherit','None','Allow') 
	$acl.SetAccessRule($rule) 
	$regKey.SetAccessControl($acl) 
	$regKey.Close() 
	Write-Host "Done removing non resolvable SIDs."
}

function Set-AT-ApacheTomcat-GroupMembership {
    
	# sets "apachetomcat" user group membership and VA test or production domain account group membership
	$ErrorActionPreference = 'Stop'
    $VerbosePreference = 'Continue'

    # user and account to search for
    $USERNAMEAPACHE = "apachetomcat"
    $USERGROUPNAME = "Users"

    # declare LocalUser objects
    $ObjLocalUserGroupMember = $null
	
	# check for local apachetomcat user in Users group	
	Try {
        Write-Host "Searching for $($USERNAMEAPACHE) in LocalGroupMember Users DataBase"
        $ObjLocalUserGroupMember = Get-LocalGroupMember -Group $USERGROUPNAME -Member $USERNAMEAPACHE
        Write-Host "User $($USERNAMEAPACHE) was found"
    }

    Catch [Microsoft.PowerShell.Commands.PrincipalNotFoundException] {
        "User $($USERNAMEAPACHE) was not found in Users" | Write-Warning
        "Continuing to add $($USERNAMEAPACHE) to $USERGROUPNAME..." | Write-Warning
    }

    Catch {    
		"An unspecifed error occured - 1.1" | Write-Error
        Exit # Stop Powershell! 
    }
		
	if ($ObjLocalUserGroupMember -ne $null) {	
		Write-Host "User $($USERNAMEAPACHE) already exists in Group $($USERGROUPNAME)"
	}
	else {
		# add apachetomcat user to Users group
		Try {
			Write-Host "Adding $($USERNAMEAPACHE) to Local Group $USERGROUPNAME"
			$ObjLocalUserGroupMember = Add-LocalGroupMember -Group $USERGROUPNAME -Member $USERNAMEAPACHE
			Write-Host "User $($USERNAMEAPACHE) was successfully added to $USERGROUPNAME"
		}

		Catch [Microsoft.PowerShell.Commands.PrincipalNotFoundException] {
			"User $($USERNAMEAPACHE) was not found" | Write-Warning
			"Add of $($USERNAMEAPACHE) was not successful" | Write-Warning
			Exit
		}

		Catch [Microsoft.PowerShell.Commands.GroupNotFoundException] {
			"Group $($USERGROUPNAME) was not found" | Write-Warning
			"Add of $($USERNAMEAPACHE) was not successful" | Write-Warning
			Exit
		}

		Catch [Microsoft.PowerShell.Commands.MemberExistsException] {
			Write-Host "User $($USERNAMEAPACHE) already exists in Group $($USERGROUPNAME)"
			Write-Host "Continuing..." 
		}

		Catch {
			"An unspecifed error occured - 1.2" | Write-Error
			Exit # Stop Powershell! 
		}
	}
}

function Set-AT-VADomainAccount-GroupMembership {
    
	# sets "apachetomcat" user group membership and VA test or production domain account group membership
	$ErrorActionPreference = 'Stop'
    $VerbosePreference = 'Continue'

	$DOMAINNAMETESTPROD = "VA\OITSvCCVIXPROD"	
	$ADMINGROUPNAME = "Administrators"

    # declare LocalUser objects
	$ObjLocalAdminGroupMember = $null
	
	# check for domain account VA\OITSvCCVIXPROD in Administrators group
    Try {
        Write-Host "Searching for $($DOMAINNAMETESTPROD) in LocalGroupMember Administrators DataBase"
        $ObjLocalAdminGroupMember = Get-LocalGroupMember -Group $ADMINGROUPNAME -Member $DOMAINNAMETESTPROD
        Write-Host "User $($DOMAINNAMETESTPROD) was found"
    }

    Catch [Microsoft.PowerShell.Commands.PrincipalNotFoundException] {
        "User $($DOMAINNAMETESTPROD) was not found in Administrators" | Write-Warning
        "Continuing to add $($DOMAINNAMETESTPROD) to $ADMINGROUPNAME..." | Write-Warning
    }

    Catch {    
		"An unspecifed error occured - 2.1" | Write-Error
        Exit # Stop Powershell! 
    }

	if ($ObjLocalAdminGroupMember -ne $null) {	
		Write-Host "User $($DOMAINNAMETESTPROD) already exists in Group $($ADMINGROUPNAME)"
	}
	else {
		# add domain account VA\OITSvCCVIXPROD to Administrators group
		Try {
			Write-Host "Adding $($DOMAINNAMETESTPROD) to Local Group $ADMINGROUPNAME"
			$ObjLocalAdminGroupMember = Add-LocalGroupMember -Group $ADMINGROUPNAME -Member $DOMAINNAMETESTPROD
			Write-Host "User $($DOMAINNAMETESTPROD) was successfully added to $ADMINGROUPNAME"
		}

		Catch [Microsoft.PowerShell.Commands.PrincipalNotFoundException] {
			"User $($DOMAINNAMETESTPROD) was not found" | Write-Warning
			"Add of $($DOMAINNAMETESTPROD) was not successful" | Write-Warning
			Exit
		}

		Catch [Microsoft.PowerShell.Commands.GroupNotFoundException] {
			"Group $($ADMINGROUPNAME) was not found" | Write-Warning
			"Add of $($DOMAINNAMETESTPROD) was not successful" | Write-Warning
			Exit
		}

		Catch [Microsoft.PowerShell.Commands.MemberExistsException] {
			Write-Host "User $($DOMAINNAMETESTPROD) already exists in Group $($ADMINGROUPNAME)"
			Write-Host "Continuing to edit folder permissions..." 
		}

		Catch {
			"An unspecifed error occured - 2.2" | Write-Error
			Exit # Stop Powershell! 
		}
	}
}

function Set-AT-FolderPermissions {	
	# sets "apachetomcat" permissions for the folders:
	$tomcatPath = "C:\Program Files\Apache Software Foundation\Tomcat 9.0"
	$javaPath = "C:\Program Files\Java\jre1.8.0_371"
	$dcfPath = "C:\DCF_RunTime_x64"
    $vixConfigPath = [System.Environment]::GetEnvironmentVariable('vixconfig') -replace "/", "\"
    if ($null -eq $vixConfigPath)
    {
        $vixConfigPath = "C:\VixConfig"   
    }
	$vixCertPath = "C:\VixCertStore"
    
    if ($VixLocalCachePath -eq ""){
		# this portion is to support running this permission_fixer.ps1 standalone looping through the possible drive locations if the environment variable for vixcache does not exist      
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

    #if local VixCache folder exists set the permissions as well
    if (Test-Path -Path $VixLocalCachePath)
    {
        $allPaths = @("$($tomcatPath)", "$($javaPath)", "$($dcfPath)", "$($vixConfigPath)", "$($vixCertPath)", "$($VixLocalCachePath)") 

        #delete contents of the VixCache if the path exists and if the DeleteCache parameter is true
        if ($DeleteCache -eq $true)
        {
            $deleteCachePSFile=Get-ChildItem -Path ($scriptDirectory + "\" + "delete_vixcache.ps1")
            if ([System.IO.File]::Exists($deleteCachePSFile))
            {
                &"$deleteCachePSFile" $VixLocalCachePath
            }
            else
            {
                Write-Host "File $deleteCachePSFile did not run"
            }
        }
    }
    else {
        $allPaths = @("$($tomcatPath)", "$($javaPath)", "$($dcfPath)", "$($vixConfigPath)", "$($vixCertPath)")
    }

	$tomcatLibPath = "C:\Program Files\Apache Software Foundation\Tomcat 9.0\lib"
	$tomcatWebappsPath = "C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps"
	$tomcatConfPath = "C:\Program Files\Apache Software Foundation\Tomcat 9.0\conf"
	$tomcatLogsPath = "C:\Program Files\Apache Software Foundation\Tomcat 9.0\logs"
	$tomcatTempPath = "C:\Program Files\Apache Software Foundation\Tomcat 9.0\temp"
	$tomcatWorkPath = "C:\Program Files\Apache Software Foundation\Tomcat 9.0\work"
	$tomcatSubfoldersVixTXLogsDbPaths = @("$($tomcatConfPath)", "$($tomcatLogsPath)", "$($tomcatTempPath)", "$($tomcatWorkPath)", "$($VixTxLogsDbPath)")

    $powershellMajorVersion = $PSVersionTable.PSVersion.Major
    $powerShellVersionBool= $true
    if (($powershellMajorVersion -ne $null) -and ($powershellMajorVersion -gt "5")) {
        $powerShellVersionBool = $false
		Write-Host "PowerShell version 6 or greater detected using Set-Acl"
    }
    
    foreach ($path in $allPaths)
    {
        $ErrorActionPreference = 'Stop'
        $VerbosePreference = 'Continue'

        # user to search for
        $USERNAME = "apachetomcat"

        # declare LocalUser object
        $ObjLocalUser = $null

	    # check for user
        Try {
            Write-Host "`n****************************************"
            Write-Host "*** Searching for $($USERNAME) permissions in $($path)"
            Write-Host "****************************************"

            $ObjLocalUser = (Get-Acl "$path").Access | ?{$_.IdentityReference -like "*$USERNAME"} | Select IdentityReference,FileSystemRights
            if ($ObjLocalUser -ne $null)
            {
                Write-Host "       USER:  $($ObjLocalUser.IdentityReference)"
                Write-Host "PERMISSIONS:  $($ObjLocalUser.FileSystemRights)"
            } else {
                Write-Host "No User Permissions Found"
            }
            									
			Write-Host "--- Setting File Permissions"			
				
			if ($path -eq $tomcatPath) {			 
				$Rights = "ReadAndExecute"
				$InheritSettings = "Containerinherit, ObjectInherit"
				$PropogationSettings = "None"
				$RuleType = "Allow"

				$acl = Get-Acl $path
				$perm = $USERNAME, $Rights, $InheritSettings, $PropogationSettings, $RuleType
				$rule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $perm
				$acl.SetAccessRule($rule)
				#Set-Acl has a bug in PowerShell 5.1 		
			    if ($powerShellVersionBool -eq $true) {
                    (Get-Item $path).SetAccessControl($acl)         
                }
                else {
				    Set-Acl -Path $path  -AclObject $acl 
                }
				Write-Host "--- Applying File Permissions Edits"
				Write-Host "--- Verifying Permissions Edits in $($path)"

				$ObjLocalUser = (Get-Acl "$path").Access | ?{$_.IdentityReference -like "*$USERNAME"} | Select IdentityReference,FileSystemRights
				if ($ObjLocalUser -ne $null)
				{
					Write-Host "       USER:  $($ObjLocalUser.IdentityReference)"
					Write-Host "PERMISSIONS:  $($ObjLocalUser.FileSystemRights)"
				} else {
					Write-Host "No User Permissions Found"
				}
				
                if(Test-Path -path $tomcatLibPath) 
                {                
                    $RightsLib = "Write"
                    $InheritSettingsLib = "Containerinherit, ObjectInherit"
                    $PropogationSettingsLib = "None"
                    $RuleTypeLib = "Deny"
                    
                    # Retrieve new explicit set of permissions
                    $libACL  = Get-Acl $tomcatLibPath
                    $permLib = $USERNAME, $RightsLib, $InheritSettingsLib, $PropogationSettingsLib, $RuleTypeLib
                    $ruleLib = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $permLib
                    $libACL.SetAccessRule($ruleLib)
                    # Set ACL again - Set-Acl has a bug in PowerShell 5.1
                    if ($powerShellVersionBool -eq $true) {
                        (Get-Item $tomcatLibPath).SetAccessControl($libACL)         
                    }
                    else {
                        Set-Acl -Path $tomcatLibPath  -AclObject $libACL 
                    }
                    Write-Host "--- Verifying Permissions Edits in $($tomcatLibPath)"

                    $ObjLocalUser = (Get-Acl "$tomcatLibPath").Access | ?{$_.IdentityReference -like "*$USERNAME"} | Select IdentityReference,FileSystemRights
                    if ($ObjLocalUser -ne $null)
                    {
                        Write-Host "       USER:  $($ObjLocalUser.IdentityReference)"
                        Write-Host "PERMISSIONS:  $($ObjLocalUser.FileSystemRights)"
                    } else {
                        Write-Host "No User Permissions Found"
                    }
                }
                
                if(Test-Path -path $tomcatWebappsPath) 
                {  
                    $RightsWebapps = "Write, Delete, DeleteSubDirectoriesAndFiles"
                    $InheritSettingsWebapps = "Containerinherit, ObjectInherit"
                    $PropogationSettingsWebapps = "None"
                    $RuleTypeWebapps = "Allow"
                    
                    # Retrieve new explicit set of permissions
                    $webappsACL  = Get-Acl $tomcatWebappsPath
                    $permWebapps = $USERNAME, $RightsWebapps, $InheritSettingsWebapps, $PropogationSettingsWebapps, $RuleTypeWebapps
                    $ruleWebapps = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $permWebapps
                    $webappsACL.SetAccessRule($ruleWebapps)
                    # Set ACL again - Set-Acl has a bug in PowerShell 5.1
                    if ($powerShellVersionBool -eq $true) {
                        (Get-Item $tomcatWebappsPath).SetAccessControl($webappsACL)         
                    }
                    else {
                        Set-Acl -Path $tomcatWebappsPath  -AclObject $webappsACL 
                    }
                    Write-Host "--- Verifying Permissions Edits in $($tomcatWebappsPath)"

                    $ObjLocalUser = (Get-Acl "$tomcatWebappsPath").Access | ?{$_.IdentityReference -like "*$USERNAME"} | Select IdentityReference,FileSystemRights
                    if ($ObjLocalUser -ne $null)
                    {
                        Write-Host "       USER:  $($ObjLocalUser.IdentityReference)"
                        Write-Host "PERMISSIONS:  $($ObjLocalUser.FileSystemRights)"
                    } else {
                        Write-Host "No User Permissions Found"
                    }
                }

				$RightsOtherSubFolders = "Write, Modify"
				$InheritSettingsSubFolders = "Containerinherit, ObjectInherit"
				$PropogationSettingsSubFolders = "None"
				$RuleTypeSubFolders = "Allow"
				$permSubFolders = $USERNAME, $RightsOtherSubFolders, $InheritSettingsSubFolders, $PropogationSettingsSubFolders, $RuleTypeSubFolders
				$ruleSubFolders = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $permSubFolders
				
				foreach ($folderOther in $tomcatSubfoldersVixTXLogsDbPaths) {
                  if(Test-Path -path $folderOther) 
                  {  					
                        # Retrieve new explicit set of permissions
                        $otherSubFoldersACL  = Get-Acl $folderOther

                        $otherSubFoldersACL.SetAccessRule($ruleSubFolders)
                        # Set ACL again - Set-Acl has a bug in PowerShell 5.1
                        if ($powerShellVersionBool -eq $true) {
                            (Get-Item $folderOther).SetAccessControl($otherSubFoldersACL)         
                        }
                        else {
                            Set-Acl -Path $folderOther  -AclObject $otherSubFoldersACL 
                        }
                        Write-Host "--- Verifying Permissions Edits in $($folderOther)"

                        $ObjLocalUser = (Get-Acl "$folderOther").Access | ?{$_.IdentityReference -like "*$USERNAME"} | Select IdentityReference,FileSystemRights
                        if ($ObjLocalUser -ne $null)
                        {
                            Write-Host "       USER:  $($ObjLocalUser.IdentityReference)"
                            Write-Host "PERMISSIONS:  $($ObjLocalUser.FileSystemRights)"
                        } else {
                            Write-Host "No User Permissions Found"
                        }		
                   }
                }                
			}
			elseif ($path -eq $dcfPath) {						
				$Rights = "ExecuteFile, ReadData, ReadAttributes, ReadExtendedAttributes, CreateFiles, AppendData, WriteAttributes, WriteExtendedAttributes, DeleteSubDirectoriesAndFiles, Delete, Read"
				$InheritSettings = "Containerinherit, ObjectInherit"
				$PropogationSettings = "None"
				$RuleType = "Allow"

				$acl = Get-Acl $path
				$perm = $USERNAME, $Rights, $InheritSettings, $PropogationSettings, $RuleType
				$rule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $perm
				$acl.SetAccessRule($rule)
                # Set ACL again - Set-Acl has a bug in PowerShell 5.1
                if ($powerShellVersionBool -eq $true) {
                    (Get-Item $path).SetAccessControl($acl)         
                }
                else {
				    $acl | Set-Acl -Path $path
                }
				Write-Host "--- File Permissions Edits Complete"
				Write-Host "--- Verifying Permissions Edits"

				$ObjLocalUser = (Get-Acl "$path").Access | ?{$_.IdentityReference -like "*$USERNAME"} | Select IdentityReference,FileSystemRights
				if ($ObjLocalUser -ne $null)
				{
					Write-Host "       USER:  $($ObjLocalUser.IdentityReference)"
					Write-Host "PERMISSIONS:  $($ObjLocalUser.FileSystemRights)"
				} else {
					Write-Host "No User Permissions Found"
				}					
			}
			elseif ($path -eq $javaPath) {						
				$Rights = "Modify"
				$InheritSettings = "Containerinherit, ObjectInherit"
				$PropogationSettings = "None"
				$RuleType = "Allow"

				$acl = Get-Acl $path
				$perm = $USERNAME, $Rights, $InheritSettings, $PropogationSettings, $RuleType
				$rule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $perm
				$acl.SetAccessRule($rule)
				# Set ACL again - Set-Acl has a bug in PowerShell 5.1
                if ($powerShellVersionBool -eq $true) {
                    (Get-Item $path).SetAccessControl($acl)         
                }
                else {
				    $acl | Set-Acl -Path $path
                }
				Write-Host "--- File Permissions Edits Complete"
				Write-Host "--- Verifying Permissions Edits"

				$ObjLocalUser = (Get-Acl "$path").Access | ?{$_.IdentityReference -like "*$USERNAME"} | Select IdentityReference,FileSystemRights
				if ($ObjLocalUser -ne $null)
				{
					Write-Host "       USER:  $($ObjLocalUser.IdentityReference)"
					Write-Host "PERMISSIONS:  $($ObjLocalUser.FileSystemRights)"
				} else {
					Write-Host "No User Permissions Found"
				}					
			}		
			elseif (($path -eq $vixConfigPath) -or (($path -eq $vixCertPath) -or ($path -eq $VixLocalCachePath))) {				
				$Rights = "FullControl"
				$InheritSettings = "Containerinherit, ObjectInherit"
				$PropogationSettings = "None"
				$RuleType = "Allow"

				$acl = Get-Acl $path
				$perm = $USERNAME, $Rights, $InheritSettings, $PropogationSettings, $RuleType
				$rule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $perm
				$acl.SetAccessRule($rule)
                # Set ACL again - Set-Acl has a bug in PowerShell 5.1
                if ($powerShellVersionBool -eq $true) {
                    (Get-Item $path).SetAccessControl($acl)    
                }
                else {
				    $acl | Set-Acl -Path $path
                }
				Write-Host "--- File Permissions Edits Complete"
				Write-Host "--- Verifying Permissions Edits"

				$ObjLocalUser = (Get-Acl "$path").Access | ?{$_.IdentityReference -like "*$USERNAME"} | Select IdentityReference,FileSystemRights
				if ($ObjLocalUser -ne $null)
				{
					Write-Host "       USER:  $($ObjLocalUser.IdentityReference)"
					Write-Host "PERMISSIONS:  $($ObjLocalUser.FileSystemRights)"
				} else {
					Write-Host "No User Permissions Found"
				}					
			}			
			else {				
				Write-Host "No folder to set permissions for found"	
			}
        }

        Catch [Microsoft.PowerShell.Commands.UserNotFoundException] {
            "User $($USERNAME) was not found" | Write-Warning
            "Permissions Failed" | Write-Warning
            Exit
        }

        Catch {
			"An unspecifed error occured - 3" | Write-Error
            Exit # Stop Powershell! 
        }
    }
}

Fix-SIDS
Set-AT-ApacheTomcat-GroupMembership
Set-AT-FolderPermissions
Set-AT-VADomainAccount-GroupMembership

Write-Host "DONE with apachetomcat user and permissions"

if ($RoleType -ne $null) {
	
	Stop-Transcript 
}
