# deploy_installer.ps1

param
(
    [parameter(Mandatory=$True, Position=0)][string]$utilPwd, #pwd for the Imaging Utility
    [parameter(Mandatory=$True, Position=1)][string]$InstallerVersionNum, # Patch Version Number without the P
    [parameter(Mandatory=$True, Position=2)][string]$RoleType, #Role Type as CVIX or VIX
    [parameter(Mandatory=$True, Position=3)][string]$JobFolder, #Jenkins job folder to use (overrides current Job Folder)
    [parameter(Mandatory=$True, Position=4)][string]$JobName, #Current Jenkins job folder
    [parameter(Mandatory=$True, Position=5)][string]$DeployServersName, #Server(s) to Deploy to
    [parameter(Mandatory=$False, Position=6)][string]$servicePwd #pwd for the Service Account
)

#If the user did not provide the password, explain why it is needed and get it
if([string]::IsNullOrWhiteSpace($utilPwd))
{
    Write-Output "`nThis script updates the VixInstallerConfig.xml file based on the if the server is dev, silver, or gold."
    Write-Output "`nThis script deploy the nightly VIX/CVIX installation and requires the imaging utility pwd."
    while ([string]::IsNullOrWhiteSpace($utilPwd)) {$utilPwd = Read-Host -Prompt "utilPwd"}
}

# relaunch as an elevated process if not currently in administrator mode
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    $PSHost = If ($PSVersionTable.PSVersion.Major -gt 5) {'PwSh'} else {'PowerShell'}
    Start-Process $PSHost -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$($PWD.Path)'; & '$PSCommandPath' $utilPwd $InstallerVersionNum $RoleType $JobFolder $JobName $DeployServersName $servicePwd`"";
    Exit
}

function DecryptedVixJava($encrypted)
{
    $decryptedOutput = & java -jar ..\..\$job\ic\IMAG_Source\VISA\Java\ImagingUtilities\target\ImagingUtilities-0.1.jar -operation=decrypt -password="$utilPwd" -input="$encrypted"
    #Sample is (Decrypted string is:    foo)
    $parts = $decryptedOutput -split ": "
    if([string]::IsNullOrWhiteSpace($parts[1]))
    {
        Write-Output "The decryption utility failed. Perhaps the password is incorrect. This script cannot proceed."
        Exit
    }
    $theValue = $parts[1].TrimStart()
    return $theValue
}

function DetermineServerType($myServer)
{
	Write-Output $myServer
    #DEV VIX
    $devVIX = @("VHACRRAPPSCPIM2.VHA.MED.VA.GOV","VHACRRAPPSCPIM6.VHA.MED.VA.GOV","VAC10VIXHIE801.VA.GOV","VAC10VIXHIE803.VA.GOV")
    if ($devVIX -contains $myServer)
    {
        Write-Output "Match on DEV VIX"
        $myProps.ServerType = "DEV"

        $devVIXAWS = @("VAC10VIXHIE801.VA.GOV","VAC10VIXHIE803.VA.GOV")
        if ($devVIXAWS -contains $myServer)
        {
            $myProps.SiteServiceUriHost  = "VAC10CVXHIE801.VA.GOV"
        }
		else
        {
            $myProps.SiteServiceUriHost  = "VHACRRAPPSCPIM4.VHA.MED.VA.GOV"
        }
        return
    }

    #DEV CVIX
    $devCVIX = @("VHACRRAPPSCPIM4.VHA.MED.VA.GOV", "VAC10CVXHIE801.VA.GOV","VAC10CVXHIE803.VA.GOV")
    if ($devCVIX -contains $myServer)
    {
        Write-Output "Match on DEV CVIX"
        $myProps.ServerType = "DEV"

        $devCVIXAWS = @("VAC10CVXHIE801.va.gov","VAC10CVXHIE803.VA.GOV")
        if ($devCVIXAWS -contains $myServer)
        {
			if ("VAC10CVXHIE803.VA.GOV" -eq $myServer)
			{
				$myProps.SiteServiceUriHost  = "VAC10CVXHIE803.VA.GOV"
			}
			else
			{
				$myProps.SiteServiceUriHost  = "VAC10CVXHIE801.VA.GOV"
			}
		}
        else
        {
            $myProps.SiteServiceUriHost = "VHACRRAPPSCPIM4.VHA.MED.VA.GOV"
        }
        return
    }

    #SILVER VIX
    $silverVIX = @("VHAISPAPPVIXIP4.VHA.MED.VA.GOV","VHAISPAPPVIXIP5.VHA.MED.VA.GOV")
    if ($silverVIX -contains $myServer)
    {
        Write-Output "Match on SILVER VIX"
        $myProps.ServerType = "SILVER"
        $myProps.SiteServiceUriHost = "VAC10CVXHIE601.VA.GOV"
        return
    }

    #AWS SILVER TEST CVIX
    $silverCVIX = @("VAC10CVXHIE601.VA.GOV","VAC10CVXHIE602.VA.GOV","VAC10CVXHIE613.VA.GOV")
    if ($silverCVIX -contains $myServer)
    {
        Write-Output "Match on SILVER CVIX"
        $myProps.ServerType = "SILVER"
        $myProps.SiteServiceUriHost = "VAC10CVXHIE611.VA.GOV"
        return
    }

    #GOLD VIX
    $goldVIX = @("VHAISPAPPVIXIP1.VHA.MED.VA.GOV","VHAISPAPPVIXIP2.VHA.MED.VA.GOV")
    if ($goldVIX -contains $myServer)
    {
        Write-Output "Match on GOLD VIX"
        $myProps.ServerType = "GOLD"
        $myProps.SiteServiceUriHost = "VAC10CVXHIE611.VA.GOV"
        return
    }

    #AWS GOLD TEST CVIX
    $goldCVIX = @("VAC10CVXHIE611.VA.GOV","VAC10CVXHIE612.VA.GOV","VAC10CVXHIE603.VA.GOV")
    if ($goldCVIX -contains $myServer)
    {
        Write-Output "Match on GOLD CVIX"
        $myProps.ServerType = "GOLD"
        $myProps.SiteServiceUriHost = "VAC10CVXHIE611.VA.GOV"
        return
    }
}

function ReadInstallerConfig([xml] $xmlDocument)
{
    # read access code
	$vistaAccessorNode = $xmlDocument.SelectSingleNode('//VixConfigurationParameters/VistaAccessor')
    if ($null -ne $vistaAccessorNode)
    {
        $accessCode = $vistaAccessorNode.InnerText
        [string] $accessCode2 = DecryptedVixJava("$accessCode")
        $myProps.AccessCode = $accessCode2.trim()
    }

    # read verify code
	$vistaVerifyNode = $xmlDocument.SelectSingleNode('//VixConfigurationParameters/VistaVerifier')
    if ($null -ne $vistaVerifyNode)
    {
        $verifyCode = $vistaVerifyNode.InnerText
        [string] $verifyCode2 = DecryptedVixJava("$verifyCode")
        $myProps.VerifyCode = $verifyCode2.trim()
    }

    # read station200 User Name
	$station200Node = $xmlDocument.SelectSingleNode('//VixConfigurationParameters/Station200UserName')
    if ($null -ne $station200Node)
    {
        $station200UserName = $station200Node.InnerText
        [string] $station200UserName2 = DecryptedVixJava("$station200UserName")
        $myProps.Station200UserName = $station200UserName2.trim()
    }

    # read apachetomcat password
	$apacheTomcatPasswordNode = $xmlDocument.SelectSingleNode('//VixConfigurationParameters/ApacheTomcatPassword1')
    if ($null -ne $apacheTomcatPasswordNode)
    {
        $apacheTomcatPassword = $apacheTomcatPasswordNode.InnerText
        [string] $apacheTomcatPassword2 = DecryptedVixJava("$apacheTomcatPassword")
        $myProps.ApacheTomcatPassword = $apacheTomcatPassword2.trim()
    }

    # read tomcat admin password
	$tomcatAdminPasswordNode = $xmlDocument.SelectSingleNode('//VixConfigurationParameters/TomcatAdminPassword')
    if ($null -ne $tomcatAdminPasswordNode)
    {
        $tomcatAdminPassword = $tomcatAdminPasswordNode.InnerText
        [string] $tomcatAdminPassword2 = DecryptedVixJava("$tomcatAdminPassword")
        $myProps.TomcatAdminPassword = $tomcatAdminPassword2.trim()
    }

    # read federation truststore password
	$federationtrustPasswordNode = $xmlDocument.SelectSingleNode('//VixConfigurationParameters/FederationTruststorePassword')
    if ($null -ne $federationtrustPasswordNode)
    {
        $federationTruststorePassword = $federationtrustPasswordNode.InnerText
        [string] $federationTruststorePassword2 = DecryptedVixJava("$federationTruststorePassword")
        $myProps.FederationTruststorePassword = $federationTruststorePassword2.trim()
    }

    # read federation keystore password
	$federationkeyPasswordNode = $xmlDocument.SelectSingleNode('//VixConfigurationParameters/FederationKeystorePassword')
    if ($null -ne $federationkeyPasswordNode)
    {
        $federationKeystorePassword = $federationkeyPasswordNode.InnerText
        [string] $federationKeystorePassword2 = DecryptedVixJava("$federationKeystorePassword")
        $myProps.FederationKeystorePassword = $federationKeystorePassword2.trim()
    }

    # read bia password
	$biaPasswordNode = $xmlDocument.SelectSingleNode('//VixConfigurationParameters/BiaPassword')
    if ($null -ne $biaPasswordNode)
    {
        $biaPassword = $biaPasswordNode.InnerText
        [string] $cvixCertPassword2 = DecryptedVixJava("$biaPassword")
        $myProps.BiaPassword = $cvixCertPassword2.trim()
    }

    # read bia username
	$biaUserNameNode = $xmlDocument.SelectSingleNode('//VixConfigurationParameters/BiaUsername')
    if ($null -ne $biaUserNameNode)
    {
        $biaUserName = $biaUserNameNode.InnerText
        [string] $biaUserName2 = DecryptedVixJava("$biaUserName")
        $myProps.BiaUserName = $biaUserName2.trim()
    }
}

function UpdateInstallerConfig([xml] $xmlDocument, $myServer)
{
    # set access code
	$vistaAccessorNode = $xmlDocument.SelectSingleNode('//VixConfigurationParameters/VistaAccessor')
    if ($null -ne $vistaAccessorNode)
    {
        $vistaAccessorNode.InnerText = $myProperties.AccessCode.trim()
    }

    # set verify code
	$vistaVerifyNode = $xmlDocument.SelectSingleNode('//VixConfigurationParameters/VistaVerifier')
    if ($null -ne $vistaVerifyNode)
    {
        $vistaVerifyNode.InnerText = $myProperties.VerifyCode.trim()
    }

    # set station200 User Name
	$station200Node = $xmlDocument.SelectSingleNode('//VixConfigurationParameters/Station200UserName')
    if ($null -ne $station200Node)
    {
        $station200Node.InnerText = $myProperties.Station200UserName.trim()
    }

    # set apachetomcat password
	$apacheTomcatPasswordNode = $xmlDocument.SelectSingleNode('//VixConfigurationParameters/ApacheTomcatPassword1')
    if ($null -ne $apacheTomcatPasswordNode)
    {
        $apacheTomcatPasswordNode.InnerText = $myProperties.ApacheTomcatPassword.trim()
    }

    # set tomcat admin password
	$tomcatAdminPasswordNode = $xmlDocument.SelectSingleNode('//VixConfigurationParameters/TomcatAdminPassword')
    if ($null -ne $tomcatAdminPasswordNode)
    {
        $tomcatAdminPasswordNode.InnerText = $myProperties.TomcatAdminPassword.trim()
    }

     # set federation truststore password
	$federationtrustPasswordNode = $xmlDocument.SelectSingleNode('//VixConfigurationParameters/FederationTruststorePassword')
    if ($null -ne $federationtrustPasswordNode)
    {
        $federationtrustPasswordNode.InnerText = $myProperties.FederationTruststorePassword.trim()
    }

    # set federation keystore password
	$federationkeyPasswordNode = $xmlDocument.SelectSingleNode('//VixConfigurationParameters/FederationKeystorePassword')
    if ($null -ne $federationkeyPasswordNode)
    {
        $federationkeyPasswordNode.InnerText = $myProperties.FederationKeystorePassword.trim()
    }

    # site service URI
	$siteServiceUriNode = $xmlDocument.SelectSingleNode('//VixConfigurationParameters/SiteServiceUri')
    if ($null -ne $siteServiceUriNode)
    {
        $siteServiceUriNode.InnerText = "http://$($myProperties.SiteServiceUriHost.trim())/VistaWebSvcs/ImagingExchangeSiteService.asmx"
    }

    # set build number
    $productVersionNode = $xmlDocument.SelectSingleNode('//VixConfigurationParameters/ProductVersion1')
    if ($null -ne $productVersionNode)
    {
        $productVersionNode.InnerText = $myProps.BuildNumber.trim()
    }

    # set bia password
	$biaPasswordNode = $xmlDocument.SelectSingleNode('//VixConfigurationParameters/BiaPassword')
    if ($null -ne $biaPasswordNode)
    {
        $biaPasswordNode.InnerText = $myProps.BiaPassword.trim()
    }

    # set bia username
	$biaUserNameNode = $xmlDocument.SelectSingleNode('//VixConfigurationParameters/BiaUsername')
    if ($null -ne $biaUserNameNode)
    {
        $biaUserNameNode.InnerText = $myProps.BiaUserName.trim()
    }

    # set vix role
	$vixRoleNode = $xmlDocument.SelectSingleNode('//VixConfigurationParameters/VixRole')
    if ($null -ne $vixRoleNode)
    {
        $vixRoleNode.InnerText = $myProps.SiteVix.trim()
    }

    # set server name
    $serverNameNode = $UpdateInstallerXMLFile.SelectSingleNode('//VixConfigurationParameters/VixServerName1')
    if ($null -ne $serverNameNode)
    {
       $currentServerNameSplit = $myServer.Split(".")
       $currentServerName = $currentServerNameSplit[0]
       $serverNameNode.InnerText = $currentServerName
    }
}

function Deploy-Installer
{
	param ($myServer, $InstallerVersionNum, $RoleType, $servicePwd, $job3)

    Write-Output "Working on $myServer."
    $username = "VA\OITSvCCVIXPROD"
    $securePwd2 = ConvertTo-SecureString -String $servicePwd -AsPlainText -Force

    $cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $securePwd2

    Write-Output "$myServer - Trying to esablish PS session..."
    $Session = New-PSSession -ComputerName $myServer -ErrorAction Continue -Credential $cred

    if ($Session.State -ne "Opened")
    {
        Write-Error "$myServer - Cannot establish PS session."
    }
    else
    {
        Write-Output "$myServer - Successfully establish PSSession, will be running command in PS session."

        $updatedRemoteSite = Invoke-Command -Session $Session -ArgumentList $myServer,$InstallerVersionNum,$RoleType,$job3 -ScriptBlock{
           $args

            # ScriptBlocks don't allow for functions so this is all splated here #
            #================================================================================================================
            #==================================================== PREP ======================================================
            #================================================================================================================
            #get arguments remotely and split full patch number into just major match number (ie. 348) and split server name to
            #not include any extension like va.gov
            $DeployedServerName=$args[0]
            $FullNum = $args[1]
            $FullNumSplit = $FullNum.Split(".")
            $MajorPatchNum = $FullNumSplit[1]
            $TverNum = $FullNumSplit[2]
            $RoleType2=$args[2]
            $job2=$args[3]

            Write-Output "Job internal is $job2"
            #================================================================================================================
            #================================= Uninstall prior MSI file(s) ==================================================
            #================================================================================================================
            $serviceInstallWizard = "Service Installation Wizard"
            $uninstallPaths = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
                     'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
            $uninstallProps = @(
                @{n='Architecture';
                  e={
                        if($_.PsParentPath -match 'SysWow'){
                            '32-bit'
                        }else{
                            '64-bit'
                        }
                    }
                },
                'DisplayName',
                'UninstallString'
            )

            Write-Output "Checking for prior versions of the Service Installation Wizard on $DeployedServerName."

            $serviceInstallProducts = Get-ItemProperty $uninstallPaths | Where-Object {$_.DisplayName -match $serviceInstallWizard} | Select-Object $uninstallProps

            foreach ($serviceInstallProduct in $serviceInstallProducts)
            {
                $uninstallString = $serviceInstallProduct.UninstallString
                $uninstallStringSplit = $uninstallString.Split("I")
                $uninstallStringGUID = $uninstallStringSplit[1]

                Write-Output "Removing: $serviceInstallProduct.DisplayName with $uninstallStringGUID"

                cmd /c "msiexec /x $uninstallStringGUID /qn & exit" /wait
            }
            #for VIX
            if ($RoleType2 -ne "CVIX")
            {
                $installPath = "C:\Program Files (x86)\Vista\Imaging\VixInstaller\"
            }
            # for CVIX
            else
            {
                $installPath = "C:\Program Files (x86)\Vista\Imaging\CvixInstaller\"
            }

            if (Test-Path $installPath)
            {
                Write-Output "Install folder exists, removing VIX subdirectory."
                # remove old folder ViX in install path if exists
                if (Test-Path "$installPath\ViX")
                {
                    Remove-Item -Recurse -Force "$installPath\ViX"
                }
            }
            else
            {
                Write-Output "Install folder did not exist"
            }
            #================================================================================================================
            #========================================== MSI Install =========================================================
            #================================================================================================================
            Invoke-WebRequest http://10.247.228.13/job/$job2/ws/ic/IMAG_Source/VISA/DotNet/VixInstallerSolution2019/VixInstallerSetup/Release/MAG3_0P$($MajorPatchNum)T$($TverNum)_$($RoleType2)_Setup.msi -OutFile "C:\temp\MAG3_0P$($MajorPatchNum)T$($TverNum)_$($RoleType2)_Setup.msi"

            Write-Output "Attempting to run Install Service Installation Wizard on $DeployedServerName..."

            cmd /c "msiexec /i `"C:\temp\MAG3_0P$($MajorPatchNum)T$($TverNum)_$($RoleType2)_Setup.msi`" /qn & exit" /wait
            #================================================================================================================
            #==================================== Install Config Update  ====================================================
            #================================================================================================================
            Write-Output "Cleaning up VixInstallerConfig.xml and updating new version on $DeployedServerName..."

            $filePaths =  "$installPath\VixInstallerConfig.xml", "C:\temp\MAG3_0P$($MajorPatchNum)T$($TverNum)_$($RoleType2)_Setup.msi"
            foreach($filePath in $filepaths)
            {
                if (Test-Path $filePath)
                {
                    Remove-Item -Path $filePath -Force
                }
            }

            Invoke-WebRequest http://10.247.228.13/job/$job2/ws/ic/IMAG_Source/VISA/DotNet/VixInstallerSolution2019/VixInstallerNightly/bin/Release/VixInstallerConfig.xml -OutFile "$installPath\VixInstallerConfig.xml"

            Write-Output "Updating VixInstallerConfig.xml file."
            $installerConfigFile = "$installPath\VixInstallerConfig.xml"
            if (Test-Path -Path $installerConfigFile -PathType Leaf)
            {
                $UpdateInstallerXMLFile  = [XML](Get-Content $installerConfigFile)

                $serverFile = "C:\Program Files\Apache Software Foundation\Tomcat 9.0\conf\server.xml"
                if (Test-Path -Path $serverFile -PathType Leaf)
                {
                    $tomcatServerXMLFile = [XML](Get-Content $serverFile)
                    $webAppsRealmNode = $tomcatServerXMLFile.SelectSingleNode('//Server/Service[@name="Catalina"]/Engine[@name="Catalina"]/Host[@appBase="webapps"]/Realm')
                    $siteNumber = $webAppsRealmNode.siteNumber
                    $siteAbbreviation = $webAppsRealmNode.siteAbbreviation
                    $siteName = $webAppsRealmNode.siteName
                    $vistaServer = $webAppsRealmNode.vistaServer
                    $vistaPort = $webAppsRealmNode.vistaPort

                    # set site name
                    $siteNameNode = $UpdateInstallerXMLFile.SelectSingleNode('//VixConfigurationParameters/SiteName')
                    if ($null -ne $siteNameNode)
                    {
                        $siteNameNode.InnerText = $siteName
                        Write-Output "Updated SiteName to $siteName"
                    }

                    # set site number
                    $siteNumberNode = $UpdateInstallerXMLFile.SelectSingleNode('//VixConfigurationParameters/SiteNumber')
                    if ($null -ne $siteNumberNode)
                    {
                        $siteNumberNode.InnerText = $siteNumber
                        Write-Output "Updated SiteNumber to $siteNumber"
                    }

                    # set site abbreviation
                    $siteAbbreviationNode = $UpdateInstallerXMLFile.SelectSingleNode('//VixConfigurationParameters/SiteAbbreviation')
                    if ($null -ne $siteAbbreviationNode)
                    {
                        $siteAbbreviationNode.InnerText = $siteAbbreviation
                        Write-Output "Updated SiteAbbreviation to $siteAbbreviation"
                    }

                    # set vista server
                    $vistaServerNode = $UpdateInstallerXMLFile.SelectSingleNode('//VixConfigurationParameters/VistaServerName')
                    if ($null -ne $vistaServerNode)
                    {
                        $vistaServerNode.InnerText = $vistaServer
                        Write-Output "Updated VistaServerName to $vistaServer"
                    }

                    # set vista port
                    $vistaServerPortNode = $UpdateInstallerXMLFile.SelectSingleNode('//VixConfigurationParameters/VistaServerPort')
                    if ($null -ne $vistaServerPortNode)
                    {
                        $vistaServerPortNode.InnerText = $vistaPort
                        Write-Output "Updated VistaServerPort to $vistaPort"
                    }
                }

                $vixConfigFile = "C:\VixConfig\ViXConfig.xml"
                if (Test-Path -Path $vixConfigFile -PathType Leaf)
                {
                    $vixConfigXMLFile = [XML](Get-Content $vixConfigFile)
                    $vixSoftwareNodeText = $vixConfigXMLFile.SelectSingleNode('//java/object/void[@property="vixSoftwareVersion"]/string').'#text'

                    # set previous product version
                    $previousProductVersionNode = $UpdateInstallerXMLFile.SelectSingleNode('//VixConfigurationParameters/PreviousProductVersion1')
                    if ($null -ne $previousProductVersionNode)
                    {
                        $previousProductVersionNode.InnerText = $vixSoftwareNodeText
                        Write-Output "Updated PreviousProductVersion1 to $vixSoftwareNodeText"
                    }
                }
                
                $UpdateInstallerXMLFile.save($installerConfigFile)
            }
            else
            {
                Write-Warning "VixInstallerConfig.xml file did not exist!"
            }

            #================================================================================================================
            #========================================  Nightly Install  =====================================================
            #================================================================================================================
            Write-Output "Attempting to run Nightly Install on $DeployedServerName..."
            try
            {
                if ($RoleType2 -ne "CVIX")
                {
                    Set-Location "C:\Program Files (x86)\Vista\Imaging\VixInstaller"

                    cmd /c "`"C:\Program Files (x86)\Vista\Imaging\VixInstaller\VixInstallerNightly.exe`" `"C:\Program Files (x86)\Vista\Imaging\VixInstaller`" & exit"
                }
                # for CVIX
                else
                {
                    Set-Location "C:\Program Files (x86)\Vista\Imaging\CvixInstaller"

                    cmd /c "`"C:\Program Files (x86)\Vista\Imaging\CvixInstaller\VixInstallerNightly.exe`" `"C:\Program Files (x86)\Vista\Imaging\CvixInstaller`" & exit"
                }
            }
            catch
            {
                Write-Output "Exit Code is $LASTEXITCODE"
                exit 1
            }
         }

        $lastsuccess = Invoke-Command -Session $Session -ScriptBlock {$?}

        Remove-PSSession -Session $Session
    }

    Write-Output $updatedRemoteSite

    if($lastsuccess)
    {
        Write-Output "Deployment on $myServer completed"
    }
    else
    {
        Write-Output "Deployment on $myServer had errors"
        $myProperties.exitCode = 1
    }
}

Write-Output "Version:$InstallerVersionNum"
Write-Output "Role:$RoleType"
Write-Output "JobFolder:$JobFolder"
Write-Output "JobName:$JobName"
Write-Output "DeployServersName:$DeployServersName"

# if job folder is not provided (default empty) use the current job folder otherwise use the provided one from Jenkins
if (($JobFolder -eq "empty"))
{
    $JobWorkspaceSplit = $JobName.Split("/")
    $JobWorkspace1 = $JobWorkspaceSplit[0]
    $JobWorkspace2 = $JobWorkspaceSplit[1]

    # parameter for the source files (job) from jenkins
    Set-Variable -Name "job3" -Value "$JobWorkspace1/job/$JobWorkspace2"
    Set-Variable -Name "job" -Value "$JobWorkspace1\$JobWorkspace2"
    Write-Output "JobFolder is empty"
}
else
{
    $JobWorkspaceSplit = $JobFolder.Split("/")
    $JobWorkspace1 = $JobWorkspaceSplit[0]
    $JobWorkspace2 = $JobWorkspaceSplit[1]
    # parameter for the source files (job) from jenkins
    Set-Variable -Name "job3" -Value "$JobWorkspace1/job/$JobWorkspace2"
    Set-Variable -Name "job" -Value "$JobWorkspace1\$JobWorkspace2"
}

if([string]::IsNullOrWhiteSpace($servicePwd))
{
    Write-Output "`nUsing default service pwd."
	$servicePwd = DecryptedVixJava("g1LNLaHpYORTvNRJfdZBskozAGSIs-DG-sR8eIlD")
}

Write-Output "Job name is $job3"
#VIX AND CVIX list from Jenkins
$devVIXCVIXen = $DeployServersName.Split(",")
$script:myComputer = $devVIXCVIXen
#initialize exit code to 0
$myProps = @{}
$myProps.exitCode = 0
$myProps.BuildNumber = $InstallerVersionNum
$myProps.DeployServerName = $devVIXCVIXen

foreach ($myServer in $myComputer)
{
    DetermineServerType $myServer

    if ($RoleType -ne "CVIX")
    {
        $myProps.SiteVix = "SiteVix"
    }
    else
    {
        $myProps.SiteVix = "EnterpriseGateway"
    }

    if ($myProps.ServerType  -match "DEV")
    {
        $installerConfigFileType = "..\..\$job\ic\IMAG_Build\Tools\InstallerDeploy\VixInstallerConfig_Dev.xml"
    }
    elseif ($myProps.ServerType -match "SILVER")
    {
        $installerConfigFileType = "..\..\$job\ic\IMAG_Build\Tools\InstallerDeploy\VixInstallerConfig_Silver.xml"
    }
    elseif ($myProps.ServerType  -match "GOLD")
    {
        $installerConfigFileType = "..\..\$job\ic\IMAG_Build\Tools\InstallerDeploy\VixInstallerConfig_Gold.xml"
    }
    else
    {
        Write-Output "Server did not match to Dev, Silver, or Gold. This script cannot proceed."
        Exit
    }

    Write-Output "Reading VixInstallerConfig.xml file."
    if (Test-Path -Path $installerConfigFileType -PathType Leaf)
    {
        $UpdateInstallerXMLFile  = [XML](Get-Content $installerConfigFileType)
        ReadInstallerConfig $UpdateInstallerXMLFile
        Write-Output "Done reading VixInstallerConfig.xml file."
    }
    else
    {
        Write-Warning "VixInstallerConfig.xml file did not exist!"
    }

	$myProperties = New-Object -TypeName PSObject -Property $myProps

    Write-Output "***** Updating VixInstallerConfig.xml File *****"
    $installerConfigFile = "C:\J\WS\$job\ic\IMAG_Source\VISA\DotNet\VixInstallerSolution2019\VixInstallerNightly\bin\Release\VixInstallerConfig.xml"
    if (Test-Path -Path $installerConfigFile -PathType Leaf)
    {
        $UpdateInstallerXMLFile  = [XML](Get-Content $installerConfigFile)
        UpdateInstallerConfig $UpdateInstallerXMLFile $myServer
        $UpdateInstallerXMLFile.save($installerConfigFile)
        Write-Output "***** Done Updating VixInstallerConfig.xml File *****"
    }
    else
    {
        Write-Warning "VixInstallerConfig.xml file did not exist!"
    }

    #Write-Output $myProperties  #show properties if needed for debugging

    Deploy-Installer $myServer $InstallerVersionNum $RoleType $servicePwd $job3
}

Exit $myProperties.exitCode