#script to set required read permissions on jmxremote.password for apachetomcat and to revert the permissions to full control for administrators

# relaunch as an elevated process if not currently in administrator mode
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    $PSHost = If ($PSVersionTable.PSVersion.Major -gt 5) {'PwSh'} else {'PowerShell'}
    Start-Process $PSHost -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$($PWD.Path)'; & '$PSCommandPath' $RoleType $StandAlone`"";
    Exit
}

$jmxPasswordPath = "C:\Program Files\Apache Software Foundation\Tomcat 9.0\conf\jmxremote.password"
if (![System.IO.File]::Exists($jmxPasswordPath)) {
    "$jmxPasswordPath does not exist."
    Exit
}

function SetJMXPermissions {
    param(
        [Parameter(Mandatory=$true)] [String]$userName,
        [Parameter(Mandatory=$true)] [String]$rights,
        [Parameter(Mandatory=$true)] [String]$onlyOne
    )

    try {
        $inheritSettings = "None"
        $propogationSettings = "None"
        $ruleType = "Allow"
        $acl = Get-Acl $jmxPasswordPath
        $perm = $userName, $rights, $inheritSettings, $propogationSettings, $ruleType
        $rule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $perm
        $acl.SetAccessRuleProtection($true,$false)
        if ($onlyOne -eq "1") {
            Foreach($access in $acl.access){
                $acl.RemoveAccessRule($access) | Out-Null
            }
        }
        $acl.SetOwner([System.Security.Principal.NTAccount]$userName)
        $acl.SetAccessRule($rule)
        $acl | Set-Acl -Path $jmxPasswordPath
    }
    catch {
        "An error occurred during setting of the permissions on jmxremote.password."
        $_.Exception
    }
}

function Confirm-Default
{
    #Default menu to allows for setting permissions on jmxremote.password in the Tomcat\conf directory
    Write-Output  "*****************************************************************************"
    Write-Output  "This script lets you set permissions on the Tomcat\conf\jmxremote.password file."
    Do {$confirmDefaultOption = Read-Host "Please choose option (1 to set Read for apachetomcat only, 2 to set Full Control for administrators, or Q to Quit)"} while ($confirmDefaultOption -notmatch "1|2|Q")

    switch ($confirmDefaultOption)
    {
        '1' {'Set Read permissions on jmxremote.password for apachetomcat'
               SetJMXPermissions -userName "apachetomcat" -rights "Read" -onlyOne "1"
            }
        '2' {'Set Full Control permissions on jmxremote.password for administrators'
               SetJMXPermissions -userName "administrators" -rights "FullControl" -onlyOne "0"
            }
        'Q' {'quitter...'
               Exit
            }
    }
}

Confirm-Default