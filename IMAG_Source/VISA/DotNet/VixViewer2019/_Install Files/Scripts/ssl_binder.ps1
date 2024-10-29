# obtain Role Type as CVIX or VIX from C# code

param
(
    [Parameter(Mandatory=$True, Position=0)][string]$RoleType, # CVIX or VIX
    [Parameter(Mandatory=$False, Position=1)][string]$StandAlone = "0"
)

# relaunch as an elevated process if not currently in administrator mode
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    $PSHost = If ($PSVersionTable.PSVersion.Major -gt 5) {'PwSh'} else {'PowerShell'}
    Start-Process $PSHost -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$($PWD.Path)'; & '$PSCommandPath' $RoleType $StandAlone`"";
    Exit
}

function Read-Viewer-Port ([xml] $xmlDocument) {

	# read the RootUrl and TrustedClientRootUrl port numbers from viewer config file
    $vixservicespolicy = $xmlDocument.SelectSingleNode("//VixServices")

    $viewerpolicy = $vixservicespolicy.SelectSingleNode("VixService[@ServiceType='Viewer']");

	$rootUrl = $viewerpolicy.RootUrl;
	$trustedUrl = $viewerpolicy.TrustedClientRootUrl;

	# 343 and 344 are default ports if reading port numbers is null
	if ($null -ne $rootUrl) {
		$myProps.PortNo = $rootUrl -replace '\D+(\d+)','$1';
	}
	else {
		$myProps.PortNo = 343
	}

	if ($null -ne $trustedUrl) {
		$myProps.TrustedPortNo = $trustedUrl -replace '\D+(\d+)','$1';
	}
	else {
		$myProps.TrustedPortNo = 344
	}

	Write-Output "RootUrl Port Number is $($myProps.PortNo)"
	Write-Output "TrustedClientRootUrl Port Number is $($myProps.TrustedPortNo)"
}

function SSLBinding() {

	# SSL Cert Binding - retrieves the thumbprint of the appropriate SSL certificate with client authentication being presented.
	# It checks the expiration dates and deletes the certificate if it is not the very latest one with the subject name the same
	# as the hostname and with client authentication. It then binds ports to the certificate in order to facilitate secure data
	# traffic between the CVIX and VIX servers

	Write-Output "getting computer name..."
	$myname = (Get-CimInstance win32_computersystem).DNSHostName+"."+(Get-CimInstance win32_computersystem).Domain
	Write-Output "computer name: $myname"

    # for VIX
	if ($RoleType -ne "CVIX") {

		$myThumbprintFilterFirstOne = Get-ChildItem -Path cert:\LocalMachine\My\* -EKU "*Client Authentication*" | Where-Object { $_.Subject -like "*$myname*" } | Sort-Object NotAfter -descending | Select-Object -ExpandProperty Thumbprint -First 1

		$myThumbprintAll = Get-ChildItem -Path cert:\LocalMachine\My\* -EKU "*Client Authentication*" | Where-Object { $_.Subject -like "*$myname*" } | Sort-Object NotAfter -descending | Select-Object -ExpandProperty Thumbprint

		foreach ($myThumb in $myThumbprintAll)
		{
			if ($myThumb -ne $myThumbprintFilterFirstOne)
			{
				Remove-Item cert:\LocalMachine\My\$myThumb -DeleteKey
				Write-Output "Deleted certificate $myThumb without the latest expiration date."
			}
		}

        $myuseThumbprintFilter = Get-ChildItem -Path cert:\LocalMachine\My\* -EKU "*Client Authentication*" | Where-Object { $_.Subject -like "*$myname**" } | Sort-Object NotAfter -descending | Select-Object -ExpandProperty Thumbprint -First 1
	}

    # for CVIX
	else  {

        $myThumbprintFilterFirstOne = Get-ChildItem -Path cert:\LocalMachine\My\* -EKU "*Client Authentication*" | Where-Object { $_.Subject -like "*VAWW.CVX*" } | Sort-Object NotAfter -descending | Select-Object -ExpandProperty Thumbprint -First 1

        $myThumbprintAll = Get-ChildItem -Path cert:\LocalMachine\My\* -EKU "*Client Authentication*" | Where-Object { $_.Subject -like "*VAWW.CVX*" } | Sort-Object NotAfter -descending | Select-Object -ExpandProperty Thumbprint

        foreach ($myThumb in $myThumbprintAll)
        {
            $certificateFromThumb = Get-ChildItem -Path cert:\LocalMachine\My\$myThumb
            if ($certificateFromThumb.Thumbprint -eq "f4d53c303e4aab2808efce146be776229039eddd")
            {
                Write-Output "Skipping removal of EDDD certificate."
            }
            elseif ($myThumb -ne $myThumbprintFilterFirstOne)
            {
                Remove-Item cert:\LocalMachine\My\$myThumb -DeleteKey
                Write-Output "Deleted certificate $myThumb without the latest expiration date."
            }
        }
        $myuseThumbprintFilter = Get-ChildItem -Path cert:\LocalMachine\My\* -EKU "*Client Authentication*" | Where-Object { $_.Subject -like "*VAWW.CVX*" } | Sort-Object NotAfter -descending | Select-Object -ExpandProperty Thumbprint -First 1
	}

	$portOutput = "netsh http show sslcert ipport=0.0.0.0:$($myProperties.PortNo)" | cmd | Write-Output
	$trustedPortOutput = "netsh http show sslcert ipport=0.0.0.0:$($myProperties.TrustedPortNo)" | cmd | Write-Output

	# check if root port is already bound to the cert
	if ($portOutput -like '*cannot*')
	{
		Write-Output "Port not bound. Binding current SSL thumbprint to port $($myProperties.PortNo)..."
		"netsh http add sslcert ipport=0.0.0.0:$($myProperties.PortNo) appid={00000000-0000-0000-0000-000000000000} certhash=$($myuseThumbprintFilter)" | cmd | Write-Output
	}
	else
	{
		Write-Output "SSL cert already bound to Port $($myProperties.PortNo)."
		$netsh343Output = [string](netsh.exe http show sslcert ipport=0.0.0.0:$($myProperties.PortNo))
		if ($netsh343Output.Contains('Certificate Hash') -and ($netsh343Output -match "Certificate Hash\s+:\s+(\w+)\s+")) {
			$thumbprint343Bound = [String[]]$Matches[1]
			if ($thumbprint343Bound.Trim() -ne $myuseThumbprintFilter.Trim()) {
				Write-Output "Rebinding on this port to the latest certificate."
				"netsh http delete sslcert ipport=0.0.0.0:$($myProperties.PortNo)" | cmd | Write-Output
				"netsh http add sslcert ipport=0.0.0.0:$($myProperties.PortNo) appid={00000000-0000-0000-0000-000000000000} certhash=$($myuseThumbprintFilter)" | cmd | Write-Output
			}
		}
	}

	# check if trusted port is already bound to the cert
	if ($trustedPortOutput -like '*cannot*')
	{
		Write-Output "Port not bound. Binding current SSL thumbprint to port $($myProperties.TrustedPortNo)..."
		"netsh http add sslcert ipport=0.0.0.0:$($myProperties.TrustedPortNo) appid={00000000-0000-0000-0000-000000000000} certhash=$($myuseThumbprintFilter)" | cmd | Write-Output
	}
	else
	{
		Write-Output "SSL cert already bound to Port $($myProperties.TrustedPortNo)."
		$netsh344Output = [string](netsh.exe http show sslcert ipport=0.0.0.0:$($myProperties.TrustedPortNo))
		if ($netsh344Output.Contains('Certificate Hash') -and ($netsh344Output -match "Certificate Hash\s+:\s+(\w+)\s+")) {
			$thumbprint344Bound = [String[]]$Matches[1]
			if ($thumbprint344Bound.Trim() -ne $myuseThumbprintFilter.Trim()) {
				Write-Output "Rebinding on this port to the latest certificate."
				"netsh http delete sslcert ipport=0.0.0.0:$($myProperties.TrustedPortNo)" | cmd | Write-Output
				"netsh http add sslcert ipport=0.0.0.0:$($myProperties.TrustedPortNo) appid={00000000-0000-0000-0000-000000000000} certhash=$($myuseThumbprintFilter)" | cmd | Write-Output
			}
		}
	}

	Write-Output "showing ssl bindings..."
	"netsh http show sslcert" | cmd | Write-Output
}


function Confirm-Default
{
    #Default menu to allows for deletion of expired certificates, determine current bindings, and re-binding of the certificate on ports 343 and 344
    Write-Output  "*****************************************************************************"
    Write-Output  "This script allows for deletion of expired certificates, determine current bindings, and re-binding of the certificate on ports 343 and 344."
    Do {$confirmDefaultOption = Read-Host "Please choose certificate option (1 for deletion, 2 to check current bindings, and  3 for re-binding) or Q to Quit"} while ($confirmDefaultOption -notmatch "1|2|3|A")

    switch ($confirmDefaultOption)
    {
        '1' {'Delete expired certificates'
               ExpiredCertificateCheck
            }
        '2' {'Check current bindings'
               DetermineCurrentBindings
            }
        '3' {'Re-bind SSL certificate'
               SSLReBinding
            }
        'Q' {'quitter...'
               Exit
            }
    }
}

function ExpiredCertificateCheck() {
	# Checks for expired client authentication certificates and prompts for deletion
	$today = Get-Date
	$certificates = Get-ChildItem -Path Cert:\LocalMachine\My\* -EKU "*Client Authentication*"
	$expiredCertificates = $certificates | Where-Object {($_.NotAfter -lt $today)} | Sort-Object NotAfter -descending | Select-Object  Thumbprint,FriendlyName,NotAfter
    if ($null -ne $expiredCertificates) {
        foreach ($expiredCertificate in $expiredCertificates)
        {
            $expiredCertThumprint = $expiredCertificate  | Select-Object -ExpandProperty Thumbprint
            $expiredCertName = $expiredCertificate  | Select-Object -ExpandProperty FriendlyName
            $expiredCertDate = $expiredCertificate  | Select-Object -ExpandProperty NotAfter

            $deleteConfirm = Read-Host -Prompt "Do you want to delete the expired cetificate $expiredCertName that expired on $expiredCertDate with thumprint $expiredCertThumprint (Y/N)?"
            if ($deleteConfirm -eq "Y")
            {
                Remove-Item cert:\LocalMachine\My\$expiredCertThumprint -DeleteKey
                Write-Output "Deleted certificate $expiredCertThumprint that has expired."
            } else {
                Write-Output "Did not delete certificate $expiredCertThumprint that has expired."
            }
        }
    }
    else {
        Write-Output "No expired certificates found."
    }
}

function DetermineCurrentBindings() {
    # Checks for the current thumbprints bound on ports 343 and 344
    $netsh343Output = [string](netsh.exe http show sslcert ipport=0.0.0.0:$($myProperties.PortNo))
    if ($netsh343Output.Contains('Certificate Hash')) {
        if ($netsh343Output -match "Certificate Hash\s+:\s+(\w+)\s+") {
            $thumbprint343 = [String[]]$Matches[1]
        }
        else {
            Write-Output "Certificate Hash not found for port $($myProperties.PortNo)"
        }
    }
    else
    {
        Write-Output "No SSL certificate binding found for port $($myProperties.PortNo)"
    }
    if (![string]::IsNullOrEmpty($thumbprint343))
    {
        Write-Output "Certificate bound on port $($myProperties.PortNo) with thumbprint $thumbprint343"
    }

    $netsh344Output = [string](netsh.exe http show sslcert ipport=0.0.0.0:$($myProperties.TrustedPortNo))
    if ($netsh344Output.Contains('Certificate Hash')) {
        if ($netsh344Output -match "Certificate Hash\s+:\s+(\w+)\s+") {
            $thumbprint344 = [String[]]$Matches[1]
        }
        else {
            Write-Output "Certificate Hash not found for port $($myProperties.TrustedPortNo)"
        }
    }
    else
    {
        Write-Output "No SSL certificate binding found for port $($myProperties.TrustedPortNo)"
    }
    if (![string]::IsNullOrEmpty($thumbprint344))
    {
        Write-Output "Certificate bound on port $($myProperties.TrustedPortNo) with thumbprint $thumbprint344"
    }
}

function SSLReBinding() {
	# SSL Cert Re-Binding - retrieves the thumbprint of the appropriate SSL certificate being presented. It then check the expiration dates
	# and provides prompts to delete the binding and binds ports to that certificate in order to facilitate secure data traffic
	# between the CVIX and VIX servers
	Write-Output "getting computer name..."
	$myname = (Get-CimInstance win32_computersystem).DNSHostName+"."+(Get-CimInstance win32_computersystem).Domain
	Write-Output "computer name: $myname"

	# for VIX
	if ($RoleType -ne "CVIX") {
		$mythumbarray = Get-Item cert:\LocalMachine\My\* | Where-Object {$_.Subject -like "*$myname*"} | Select-Object -ExpandProperty Thumbprint
	}
	# for CVIX
	else  {
		$mythumbarray = Get-Item cert:\LocalMachine\My\* | Where-Object {$_.Subject -like "*VAWW.CVX*"} | Select-Object -ExpandProperty Thumbprint
	}

    if ($null -ne $mythumbarray) {
        foreach ($mythumb in $mythumbarray)
        {
            Write-Output "`n******************************"
            Write-Output "Current Thumbprint: $($mythumb)"

            $myuse = Get-Item cert:\LocalMachine\My\$mythumb | Select-Object -ExpandProperty EnhancedKeyUsageList
            Write-Output $myuse

            if ("$myuse" -like "*Client Authentication*")
            {
                $myExpiration = Get-Item cert:\LocalMachine\My\$mythumb | Select-Object -ExpandProperty NotAfter
                Write-Output "Cert expires in:  $($myExpiration)"

                $varToday = Get-Date

                if ($myExpiration -lt $varToday){
                    Write-Output "This cert is past it's sell by date.  Next."
                }
                if ($myExpiration -ge $varToday){
                    Write-Output "Finally a valid client server cert, proceeding..."
                    Write-Output "showing curent ssl bindings..."
                    ##############################
                    # show current port bindings #
                    ##############################
                    "netsh http show sslcert" | cmd	| Write-Output
                    "netsh http show sslcert ipport=0.0.0.0:$($myProperties.PortNo)" | cmd | Write-Output
                    "netsh http show sslcert ipport=0.0.0.0:$($myProperties.TrustedPortNo)" | cmd | Write-Output

                    ##############################
                    # deleting port 343 $myProperties.PortNo bindings #
                    ##############################
                    $deleteConfirm1 = Read-Host -Prompt "Do you want to delete the existing SSL binding on port $($myProperties.PortNo) (Y/N)?"
                    if ($deleteConfirm1 -eq "Y")
                    {
                        Write-Output "Deleting SSL binding on port $($myProperties.PortNo)..."
                        "netsh http delete sslcert ipport=0.0.0.0:$($myProperties.PortNo)" | cmd | Write-Output
                    } else {
                        Write-Output "SSL binding on port $($myProperties.PortNo) NOT deleted."
                    }

                    ##############################
                    # deleting port 344 $myProperties.TrustedPortNo bindings #
                    ##############################
                    $deleteConfirm2 = Read-Host -Prompt "Do you want to delete the existing SSL binding on port $($myProperties.TrustedPortNo) (Y/N)?"
                    if ($deleteConfirm2 -eq "Y")
                    {
                        Write-Output "Deleting SSL binding on port $($myProperties.TrustedPortNo)..."
                        "netsh http delete sslcert ipport=0.0.0.0:$($myProperties.TrustedPortNo)" | cmd | Write-Output
                    } else {
                        Write-Output "SSL binding on port $($myProperties.TrustedPortNo) NOT deleted."
                    }

                    ##############################
                    # adding port 343 $myProperties.PortNo bindings   #
                    ##############################
                    $addConfirm1 = Read-Host -Prompt "Do you want to bind the new SSL cert $($mythumb) on port $($myProperties.PortNo) (Y/N)?"
                    if ($addConfirm1 -eq "Y")
                    {
                        Write-Output "Binding new SSL thumbprint to port $($myProperties.PortNo)..."
                        "netsh http add sslcert ipport=0.0.0.0:$($myProperties.PortNo) appid={00000000-0000-0000-0000-000000000000} certhash=`"$mythumb`"" | cmd | Write-Output
                    } else {
                        Write-Output "SSL binding on port $($myProperties.PortNo) NOT added."
                    }

                    ##############################
                    # adding port 344 $myProperties.TrustedPortNo bindings   #
                    ##############################
                    $addConfirm2 = Read-Host -Prompt "Do you want to bind the new SSL cert $($mythumb) on port $($myProperties.TrustedPortNo) (Y/N)?"
                    if ($addConfirm2 -eq "Y")
                    {
                        Write-Output "Binding new SSL thumbprint to port $($myProperties.TrustedPortNo)..."
                        "netsh http add sslcert ipport=0.0.0.0:$($myProperties.TrustedPortNo) appid={00000000-0000-0000-0000-000000000000} certhash=`"$mythumb`"" | cmd | Write-Output
                    } else {
                        Write-Output "SSL binding on port $($myProperties.TrustedPortNo) NOT added."
                    }

                    ##############################
                    # show updated port bindings #
                    ##############################
                     Write-Output "showing updated ssl bindings..."
                    "netsh http show sslcert" | cmd	| Write-Output
                    "netsh http show sslcert ipport=0.0.0.0:$($myProperties.PortNo)" | cmd | Write-Output
                    "netsh http show sslcert ipport=0.0.0.0:$($myProperties.TrustedPortNo)" | cmd | Write-Output
                }
            } else {
                Write-Output "This is not the cert we're looking for.  Next."
            }
        }
    }
    else {
        Write-Output "No valid client server certs exist."
    }
}

$myProps = @{}

if ($StandAlone -eq "0")
{
    $rootInstallationFolder = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::ProgramFiles)
    $configFolder = Join-Path $rootInstallationFolder 'VistA\Imaging\Vix.Config'

    # read viewer config file
    $viewerConfigFile = Join-Path $configFolder 'VIX.Viewer.Config'
    Write-Output 'Reading ' $viewerConfigFile
    if ([System.IO.File]::Exists($viewerConfigFile))
    {
        [xml]$ViewerXmlDoc = Get-Content -Path $viewerConfigFile
        # read port numbers
        Read-Viewer-Port $ViewerXmlDoc
		$myProperties = New-Object -TypeName PSObject -Property $myProps
    }
    else
    {
        Write-Output "ERROR! - $viewerConfigFile does not exist"
    }

    # peform SSL binding of certificate
    SSLBinding
    Write-Output "DONE with SSL binding of certificate"
}
else
{
	$myProps.PortNo = 343
	$myProps.TrustedPortNo = 344
	$myProperties = New-Object -TypeName PSObject -Property $myProps
	#menu prompt for deletion of expired certificates, checks for the current thumbprints bound, or peform SSL rebinding of certificate
	Confirm-Default
}