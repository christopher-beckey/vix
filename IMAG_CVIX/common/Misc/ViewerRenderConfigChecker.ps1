# Patch 348 Released All-In-One Post-Installation Script

param(
    [parameter(Mandatory=$True, Position=0)][string]$InstallerVersionNum, # Patch Version Number without the P
    [parameter(Mandatory=$True, Position=1)][string]$RoleType, # Role Type as CVIX or VIX
    [parameter(Mandatory=$True, Position=2)][string]$PriorInstallerVersionNum, # Prior Patch Version Number without the P
    [parameter(Mandatory=$True, Position=3)][int]$ConfigCheck # Check box value to update configs (true) or not (false)
)

#launch PowerShell as 64 bit mode if not already done to ensure commands for apachetomcat user and permissions works
if ($env:PROCESSOR_ARCHITEW6432 -eq "AMD64") {
    Write-Warning "Running 32 bit Powershell on 64 bit OS, restarting as 64 bit process..."
    $PSExe = if ($PSVersionTable.PSVersion.Major -gt 5) {"$env:ProgramW6432\PowerShell\7\pwsh.exe"} else {"$env:WINDIR\sysnative\windowspowershell\v1.0\powershell.exe"}
    Start-Process $PSExe -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$($PWD.Path)'; & '$PSCommandPath' $InstallerVersionNum $RoleType $PriorInstallerVersionNum $ConfigCheck`"";
    Exit $lastexitcode   
}

$rootInstallationFolder = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::ProgramFiles) 
$configFolder = Join-Path $rootInstallationFolder 'VistA\Imaging\Vix.Config'

function Check-Log ([xml] $xmlDocument, $logFileName) {
    
    # check log section and adjust if needed - existed prior to Patch 254
    $configSections = $xmlDocument.SelectSingleNode('//configSections')
    if ($configSections -ne $null)
    {
        $logSection = $configSections.SelectSingleNode("section[@name = 'Log']")
        if ($logSection -eq $null)
        {
            Write-Host 'Log config section does not exist'

            [xml]$logSectionXml = @"
            <section name="Log" type="Hydra.Log.LogConfigurationSection, Hydra.Log" />
"@

            $configSections.AppendChild($xmlDocument.ImportNode($logSectionXml.section, $true))
            Write-Host 'Log config section created'
        }
        else
        {
            Write-Host 'Log config section already exists'
        }

        # check log level
        $log = $xmlDocument.SelectSingleNode('//Log')
        if ($log -eq $null)
        {
            Write-Host 'Log does not exist'

            [xml]$logXml = @"
                <Log LogLevel="Warn" LogFilePrefix="$logFileName" LogFileIncludeDate="false"></Log>
"@

            $xmlDocument.configuration.InsertAfter($xmlDocument.ImportNode($logXml.Log, $true), $configSections);
            Write-Host 'Log created'
        }
        else
        {
            $log.SetAttribute('LogLevel', 'Warn')
            Write-Host 'Log level set to WARN'
        }
    }
    else 
    {
        Write-Host 'ERROR! - ConfigSections not found'
    }
}

function Check-Render-Purge ([xml] $xmlDocument) {

	# check render purge policy and adjust if needed - existed prior to Patch 254
    $purge = $xmlDocument.SelectSingleNode('//Purge')
    if ($purge -eq $null) 
    {
        [xml]$purgeXml = @"
            <Purge PurgeTimes="00:00" MaxAgeDays="2" MaxCacheSizeMB="1024" Enabled="true"></Purge>
"@

        $xmlDocument.configuration.Hix.AppendChild($xmlDocument.ImportNode($purgeXml.Purge, $true))
        Write-Host 'Purge created'
    }
}

function Update-Render-Parameters ([xml] $xmlDocument) {
	# check render config file to see if Database CommandTimeout introduced in Patch 254 exists 
	$databaseNode = $xmlDocument.SelectSingleNode('//Database') 	
	$databaseCommandTimeout = $databaseNode.CommandTimeout
	
	# add Database CommandTimeout set to the value of 300 if parameter does not yet exist
	if (!$databaseCommandTimeout) {
		 Write-Host "P254 Database CommandTimeout edit not found"
         $databaseCommandTimeoutAttr = $xmlDocument.CreateAttribute("CommandTimeout")
         $databaseCommandTimeoutAttr.Value = "300"
		 $databaseNode.Attributes.Append($databaseCommandTimeoutAttr)
	
		 Write-Host "Added P254 Database CommandTimeout set to 300"		
	} 
	else {
		Write-Host "P254 Database CommandTimeout parameter found"
	}  
}

function Check-Render-TIFF-TimeOut ([xml] $xmlDocument) {
	# check render config file to see if TIFF settings introduced in Patch 254 (OpTimeOutMins) exist 
	# update to value of 5 respectively if missing to improve performance in TIFF to PDF conversions.
	$tifftimeout = $xmlDocument.SelectSingleNode('//Processor')
	$varTiffNew = "    <Processor WorkerPoolSize=`"10`" UseSeparateProcess=`"true`" ReprocessFailedImages=`"false`" OpTimeOutMins=`"5`">"
	 
	if (Get-Content $($renderConfigFile) | Where-Object {$_ -like "*$($varTiffNew)*"})
	{
		Write-Host "P254 TIFF edit found, edit aborted."
	}
	else
	{
		Write-Host "Default TIFF edit not found.  Proceeding with VIX.Render.config check."
		$opTimeOutMins = $tifftimeout.OpTimeOutMins
		if (!$opTimeOutMins) {
			$opTimeOutMinsAttr = $xmlDocument.CreateAttribute("OpTimeOutMins")
			$opTimeOutMinsAttr.Value = "5"
			$tifftimeout.Attributes.Append($opTimeOutMinsAttr)
			Write-Output "Missing TIFF edit. Added missing Processor.OpTimeOutMins attribute."
		}
	}
}

# Function to remove the legacy VIX Render TIFF option attributes and add Files folder to 
# VIX.Render.config (VAI-307)
function VrConfigRemoveTiffOptions([xml] $xmlDocument) {
	# Removes the legacy TIFF option attributes (VAI-307)
	$xmlElement = $xmlDocument.SelectSingleNode('//Processor')
	if ($xmlElement -ne $null)
    {
        $xmlElement.RemoveAttribute('ConvertTiffToPdf')
        $xmlElement.RemoveAttribute('MaxPagesTiffToPdf')
		Write-Output "Removed legacy TIFF attributes from VIX.Render.config"
	}
    
    $imageStoresElement = $xmlDocument.SelectNodes('//configuration/Hix/ImageStores')
    if ($imageStoresElement -ne $null)
    {
        $imageStoresFilesElement = $xmlDocument.SelectNodes('//configuration/Hix/ImageStores/ImageStore[@Path="Files"]')
        if ($imageStoresFilesElement -ne $null)
        {  
            Write-Output "ImageStore Files attribute already exists in VIX.Render.config"
        }
        else
        {
            [xml]$filesSectionXml = @"
            <ImageStore Id="8" Type="Files" Path="Files" />
"@
            $imageStoresElement.AppendChild($xmlDocument.ImportNode($filesSectionXml.ImageStore, $true)) | Out-Null
            Write-Output "Added ImageStore Files attribute to VIX.Render.config"
        }
    }
}

function Check-Viewer-Policies ([xml] $xmlDocument) {

	# check viewer policies and adjust if needed - existed prior to Patch 254
    $policies = $xmlDocument.SelectSingleNode("//Policies")

    $policy = $policies.SelectSingleNode("add[@name='Viewer.EnableTestPage']");
    if ($policy -ne $null) 
    { 
        $policies.RemoveChild($policy)
         Write-Host 'Policy Viewer.EnableTestPage removed' 
    }

    $policy = $policies.SelectSingleNode("add[@name='Security.EnablePromiscuousMode']");
    if ($policy -ne $null) 
    { 
        $policy.setAttribute('value', 'false') 
         Write-Host 'Policy Security.EnablePromiscuousMode set to false' 
    }
    else 
    {
        [xml]$xml = @"
            <add name="Security.EnablePromiscuousMode" value="false" />
"@ 
        $policies.AppendChild($xmlDocument.ImportNode($xml.add, $true))
        Write-Host 'Added policy Security.EnablePromiscuousMode'

    }

    $policy = $policies.SelectSingleNode("add[@name='Viewer.EnableDashboard']");
    if ($policy -ne $null) 
    { 
        if ($RoleType -ne "CVIX") 
        {
            $policy.setAttribute('value', 'false') 
            Write-Host 'Policy Viewer.EnableDashboard set to false' 
        }
        else 
        {
            $policy.setAttribute('value', 'true') 
            Write-Host 'Policy Viewer.EnableDashboard set to true' 
        }
    }
    else
    {       
        if ($RoleType -ne "CVIX")
        {
            [xml]$xml = @"
            <add name="Viewer.EnableDashboard" value="false" />
"@ 
            $policies.AppendChild($xmlDocument.ImportNode($xml.add, $true))
            Write-Host 'Added policy Viewer.EnableDashboard set to false' 
        }
        else
        {
            [xml]$xml = @"
            <add name="Viewer.EnableDashboard" value="true" />
"@ 
            $policies.AppendChild($xmlDocument.ImportNode($xml.add, $true))
            Write-Host 'Added policy Viewer.EnableDashboard set to true' 
        }
    }

    $policy = $policies.SelectSingleNode("add[@name='Viewer.ImageInformationLink']");
    if ($policy -ne $null) 
    { 
        $policy.setAttribute('value', 'Popup') 
         Write-Host 'Policy Viewer.ImageInformationLink set to Popup' 
    }
    else 
    {
        [xml]$xml = @"
            <add name="Viewer.ImageInformationLink" value="Popup" />
"@ 
        $policies.AppendChild($xmlDocument.ImportNode($xml.add, $true))
        Write-Host 'Added policy Viewer.ImageInformationLink'

    }

    $policy = $policies.SelectSingleNode("add[@name='Viewer.QAReviewLink']");
    if ($policy -ne $null) 
    { 
        $policy.setAttribute('value', 'Popup') 
        Write-Host 'Policy Viewer.QAReviewLink set to Popup' 
    }
    else 
    {
        [xml]$xml = @"
            <add name="Viewer.QAReviewLink" value="Popup" />
"@ 
        $policies.AppendChild($xmlDocument.ImportNode($xml.add, $true))
        Write-Host 'Added policy Viewer.QAReviewLink'

    }

    $policy = $policies.SelectSingleNode("add[@name='Viewer.QAReportLink']");
    if ($policy -ne $null) 
    { 
        $policy.setAttribute('value', 'Popup')
        Write-Host 'Policy Viewer.QAReportLink set to Popup' 
    }
    else 
    {
        [xml]$xml = @"
            <add name="Viewer.QAReportLink" value="Popup" />
"@ 
        $policies.AppendChild($xmlDocument.ImportNode($xml.add, $true))
        Write-Host 'Added policy Viewer.QAReportLink'

    }

    $policy = $policies.SelectSingleNode("add[@name='Viewer.ROIStatusLink']");
    if ($policy -ne $null) 
    { 
        $policy.setAttribute('value', 'Popup') 
        Write-Host 'Policy Viewer.ROIStatusLink set to Popup'
    }
    else 
    {
        [xml]$xml = @"
            <add name="Viewer.ROIStatusLink" value="Popup" />
"@ 
        $policies.AppendChild($xmlDocument.ImportNode($xml.add, $true))
        Write-Host 'Added policy Viewer.ROIStatusLink'

    }


    $policy = $policies.SelectSingleNode("add[@name='Viewer.ROISubmissionLink']");
    if ($policy -ne $null) 
    { 
        $policy.setAttribute('value', 'Popup') 
        Write-Host 'Policy Viewer.ROISubmissionLink set to Popup'
    }
    else 
    {
        [xml]$xml = @"
            <add name="Viewer.ROISubmissionLink" value="Popup" />
"@ 
        $policies.AppendChild($xmlDocument.ImportNode($xml.add, $true))
        Write-Host 'Added policy Viewer.ROISubmissionLink'
    }

    $policy = $policies.SelectSingleNode("add[@name='Viewer.UserGuideLink']");
    if ($policy -ne $null) 
    { 
        $policy.setAttribute('value', 'New') 
        Write-Host 'Policy Viewer.UserGuideLink set to New'
    }
    else 
    {
        [xml]$xml = @"
            <add name="Viewer.UserGuideLink" value="New" />
"@ 
        $policies.AppendChild($xmlDocument.ImportNode($xml.add, $true))
        Write-Host 'Added policy Viewer.UserGuideLink'

    }
    
    $policy = $policies.SelectSingleNode("add[@name='Viewer.OverrideExportKeys']");
    if ($policy -ne $null)
    {
        $policy.setAttribute('value', 'true')
        Write-Output 'Policy Viewer.OverrideExportKeys set to true'
    }
    else
    {
        [xml]$xml = @"
        <add name="Viewer.OverrideExportKeys" value="true" />
"@
        $policies.AppendChild($ViewerXmlDoc.ImportNode($xml.add, $true))
        Write-Output 'Added policy Viewer.OverrideExportKeys set to true'
    }    
}

function updateServerXML($path) {

    $xml = [xml](get-content $path)
    $xml.Load($path)

    # verify server.xml file does not display tomcat version information resulting in a Nessus Vulnerability 
    # set valve element if missing

    $target = ((($xml.Server.Service|where {$_.name -eq "Catalina"}).Engine|where {$_.name -eq "Catalina"}).Host|where {$_.appBase -eq "webapps"})
		
	$valveElement = ($target.Valve|where {$_.className -eq "org.apache.catalina.valves.ErrorReportValve"})

    if ($valveElement) {
         Write-Output "Valve elelment already exists in Host config."
            
         $showReport = $valveElement.showReport
         $showServerInfo = $valveElement.showServerInfo
                        
         if ($showReport -eq "false" -and $showServerInfo -eq "false") {
             Write-Output "Valve element is correctly configured. No changes have been made."
             return
         }
            
         if (!$showReport) {
             $showReport = $xml.CreateAttribute("showReport")
             $showReport.Value = "false"
             $valveElement.Attributes.Append($showReport)
             Write-Output "Added missing Valve.showReport attribute."
         }
         elseif ($showReport -ne "false") {
             $valveElement.showReport = "false"
             Write-Output "Corrected value of Valve.showReport attribute."
         }

         if (!$showServerInfo) {
             $showServerInfo = $xml.CreateAttribute("showServerInfo")
             $showServerInfo.Value = "false"
             $valveElement.Attributes.Append($showServerInfo)
             Write-Output "Added missing Valve.showServerInfo attribute."
         }
         elseif ($showServerInfo -ne "false") {
             $valveElement.showServerInfo = "false"
             Write-Output "Corrected value of Valve.showServerInfo attribute."
         }
     }
     else {
         Write-Output "Valve elelment was not found in Host config."
         $valveElement = $xml.CreateElement("Valve")
        
         $className = $xml.CreateAttribute("className")
         $className.Value = "org.apache.catalina.valves.ErrorReportValve"

         $showReport = $xml.CreateAttribute("showReport")
         $showReport.Value = "false"

         $showServerInfo = $xml.CreateAttribute("showServerInfo")
         $showServerInfo.Value = "false"

         $valveElement.Attributes.Append($className)
         $valveElement.Attributes.Append($showReport)
         $valveElement.Attributes.Append($showServerInfo)

         $target.AppendChild($valveElement)
         Write-Output "Valve element added."
     }

    $xml.Save($path)
    Write-Output "$path updated" 
}

function updateTomcatServer([xml] $xmlDocument) 
{
    # check Tomcat server.xml and update if needed

	# Update Connector maxHttpHeaderSize attributes to allow large HTTP headers
	# For VAI-740. This is necessary for providing STS tokens via HTTP headers
	Write-Output "Updating server.xml Connector maxHttpHeaderSize attributes to 25600"
    foreach ($connectorNode in $xmlDocument.SelectNodes("//Connector"))
    {
		Write-Output ("Updating Connector for port " + $connectorNode.GetAttribute("port") + "'s maxHttpHeaderSize")
        $connectorNode.SetAttribute("maxHttpHeaderSize", "25600");
    }

    # set startStopThreads for Engine and Hosts
	$engineNode = $xmlDocument.SelectSingleNode('//Server/Service[@name="Catalina"]/Engine[@name="Catalina"]')
	$webAppsNode = $xmlDocument.SelectSingleNode('//Server/Service[@name="Catalina"]/Engine[@name="Catalina"]/Host[@appBase="webapps"]')   
    $startStopThreads1 = $engineNode.startStopThreads
    $startStopThreads2 = $webAppsNode.startStopThreads  
    if ($startStopThreads1 -eq $null)
    {  
        $startStopThreads1 = $xmlDocument.CreateAttribute("startStopThreads")
        $startStopThreads1.Value= "0"
        $engineNode.Attributes.Append($startStopThreads1) | Out-Null
        Write-Output "Added missing startStopThreads attribute to Engine."
    }   
    if ($startStopThreads2 -eq $null)
    {
        $startStopThreads2 = $xmlDocument.CreateAttribute("startStopThreads")
        $startStopThreads2.Value= "0"
        $webAppsNode.Attributes.Append($startStopThreads2) | Out-Null
        Write-Output "Added missing startStopThreads attribute to Host."
    }

    # set gzip compression for connector on port 8442
    $connector8442Node = $xmlDocument.SelectSingleNode('//Server/Service[@name="Catalina"]/Connector[@port="8442"]')
    $connector8442Compression = $connector8442Node.compression
    $connector8442MimeType = $connector8442Node.compressibleMimeType  
    if ($connector8442Compression -eq $null)
    {  
        $connector8442Compression = $xmlDocument.CreateAttribute("compression")
        $connector8442Compression.Value= "on"
        $connector8442Node.Attributes.Append($connector8442Compression) | Out-Null
        Write-Output "Added missing compression attribute to Connector on 8442."
    }   
    if ($connector8442MimeType -eq $null)
    {  
        $connector8442MimeType = $xmlDocument.CreateAttribute("compressibleMimeType")
        $connector8442MimeType.Value= "text/html,text/xml,text/plain,text/css,text/javascript,application/javascript,application/json,application/xml,application/dicom,application/pdf"
        $connector8442Node.Attributes.Append($connector8442MimeType) | Out-Null
        Write-Output "Added missing compressibleMimeType attribute to Connector on 8442."
    }    
    
    # set gzip compression for connector on port 8443
    $connector8443Node = $xmlDocument.SelectSingleNode('//Server/Service[@name="Catalina"]/Connector[@port="8443"]')
    $connector8443Compression = $connector8443Node.compression
    $connector8443MimeType = $connector8443Node.compressibleMimeType  
    if ($connector8443Compression -eq $null)
    {  
        $connector8443Compression = $xmlDocument.CreateAttribute("compression")
        $connector8443Compression.Value= "on"
        $connector8443Node.Attributes.Append($connector8443Compression) | Out-Null
        Write-Output "Added missing compression attribute to Connector on 8443."
    }   
    if ($connector8443MimeType -eq $null)
    {  
        $connector8443MimeType = $xmlDocument.CreateAttribute("compressibleMimeType")
        $connector8443MimeType.Value= "text/html,text/xml,text/plain,text/css,text/javascript,application/javascript,application/json,application/xml,application/dicom,application/pdf"
        $connector8443Node.Attributes.Append($connector8443MimeType) | Out-Null
        Write-Output "Added missing compressibleMimeType attribute to Connector on 8443."
    }

    #VAI-118 confgure and activate tomcat access log
    $hostWebAppsaccessNode = $xmlDocument.SelectSingleNode('//Server/Service/Engine/Host[@appBase="webapps"]/Valve[@className="org.apache.catalina.valves.AccessLogValve"]')
    if ($hostWebAppsaccessNode -eq $null)
    {
        Write-Output "Adding AccessLogValve in server.xml."
        $hostWebAppsNode = $xmlDocument.SelectSingleNode('//Server/Service/Engine/Host[@appBase="webapps"]')

        #build newAccessLogValve node by hand and force it to be an XML object
$newAccessLogNode = @'
<Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs" 
		prefix="localhost_access_log" suffix=".log" maxDays="7"				
		pattern="%h %{X-Forwarded-For}i %t %I &quot;%m %U&quot; %{local}p %s %b %D" resolveHosts="false"/>
'@

        $tempAccessXmlDoc = new-object System.Xml.XmlDocument
        $tempAccessXmlDoc.LoadXml($newAccessLogNode)
        $newAccessLogNode = $xmlDocument.ImportNode($tempAccessXmlDoc.DocumentElement, $true)
        $hostWebAppsNode.AppendChild($newAccessLogNode) | Out-Null
    }    
}


function UpdateTomcatWebXML([xml] $xmlDocument)
{       
    # HSTS Tomcat web xml update   
    $nsMgr = New-Object System.Xml.XmlNamespaceManager($xmlDocument.NameTable)
    $nsMgr.AddNamespace("ns", "http://xmlns.jcp.org/xml/ns/javaee")    
    $webAppNode = $xmlDocument.SelectSingleNode("//ns:web-app[count(ns:filter[ns:filter-name = 'httpHeaderSecurity']) = 0]",$nsMgr)        
    if ($webAppNode -ne $null)
    {        
        $elementFilter = $xmlDocument.createElement('filter', 'http://xmlns.jcp.org/xml/ns/javaee')
        $elementFilterName = $xmlDocument.createElement('filter-name', 'http://xmlns.jcp.org/xml/ns/javaee')
        $elementFilterName.InnerText = 'httpHeaderSecurity'
        $elementFilter.AppendChild($elementFilterName) | Out-Null

        $elementFilterClass = $xmlDocument.createElement('filter-class', 'http://xmlns.jcp.org/xml/ns/javaee')
        $elementFilterClass.InnerText = 'org.apache.catalina.filters.HttpHeaderSecurityFilter'
        $elementFilter.AppendChild($elementFilterClass) | Out-Null

        $elementAsyncSupported = $xmlDocument.createElement('async-supported', 'http://xmlns.jcp.org/xml/ns/javaee')
        $elementAsyncSupported.InnerText = 'true'
        $elementFilter.AppendChild($elementAsyncSupported) | Out-Null

        $elementInitParam = $xmlDocument.createElement('init-param', 'http://xmlns.jcp.org/xml/ns/javaee')
        $elementFilter.AppendChild($elementInitParam) | Out-Null

        $elementParamName = $xmlDocument.createElement('param-name', 'http://xmlns.jcp.org/xml/ns/javaee')
        $elementParamName.InnerText = 'hstsEnabled'
        $elementInitParam.AppendChild($elementParamName) | Out-Null
        
        $elementParamValue = $xmlDocument.createElement('param-value', 'http://xmlns.jcp.org/xml/ns/javaee')
        $elementParamValue.InnerText = 'true'
        $elementInitParam.AppendChild($elementParamValue) | Out-Null

        $elementInitParam = $xmlDocument.createElement('init-param', 'http://xmlns.jcp.org/xml/ns/javaee')
        $elementFilter.AppendChild($elementInitParam) | Out-Null

        $elementParamName = $xmlDocument.createElement('param-name', 'http://xmlns.jcp.org/xml/ns/javaee')
        $elementParamName.InnerText = 'hstsMaxAgeSeconds'
        $elementInitParam.AppendChild($elementParamName) | Out-Null

        $elementParamValue = $xmlDocument.createElement('param-value', 'http://xmlns.jcp.org/xml/ns/javaee')
        $elementParamValue.InnerText = '31536000'
        $elementInitParam.AppendChild($elementParamValue) | Out-Null

        $elementInitParam = $xmlDocument.createElement('init-param', 'http://xmlns.jcp.org/xml/ns/javaee')
        $elementFilter.AppendChild($elementInitParam) | Out-Null

        $elementParamName = $xmlDocument.createElement('param-name', 'http://xmlns.jcp.org/xml/ns/javaee')
        $elementParamName.InnerText = 'hstsIncludeSubDomains'
        $elementInitParam.AppendChild($elementParamName) | Out-Null

        $elementParamValue = $xmlDocument.createElement('param-value', 'http://xmlns.jcp.org/xml/ns/javaee')
        $elementParamValue.InnerText = 'true'
        $elementInitParam.AppendChild($elementParamValue) | Out-Null

        $webAppNode.AppendChild($elementFilter) | Out-Null              

        $elementFilterMapping = $xmlDocument.createElement('filter-mapping', 'http://xmlns.jcp.org/xml/ns/javaee')

        $elementFilterName = $xmlDocument.createElement('filter-name', 'http://xmlns.jcp.org/xml/ns/javaee')
        $elementFilterName.InnerText = 'httpHeaderSecurity'
        $elementFilterMapping.AppendChild($elementFilterName) | Out-Null

        $elementUrlPattern = $xmlDocument.createElement('url-pattern', 'http://xmlns.jcp.org/xml/ns/javaee')
        $elementUrlPattern.InnerText = '/*'
        $elementFilterMapping.AppendChild($elementUrlPattern) | Out-Null

        $elementDispatcher = $xmlDocument.createElement('dispatcher', 'http://xmlns.jcp.org/xml/ns/javaee')
        $elementDispatcher.InnerText = 'REQUEST'
        $elementFilterMapping.AppendChild($elementDispatcher) | Out-Null

        $webAppNode.AppendChild($elementFilterMapping) | Out-Null          

         Write-Output "Web XML did not have HSTS edits, edits completed."        
    }    	
    else 
    {	                  
         Write-Output "Web XML does have HSTS edits, edits aborted."	        
    }
}

#VAI-1259 - set required read permissions on jmxremote.password for apachetomcat
function SetJMXPermissions
{    
    $jmxPasswordPath = 'C:\Program Files\Apache Software Foundation\Tomcat 9.0\conf\jmxremote.password'
    if ([System.IO.File]::Exists($jmxPasswordPath))
    {
        try {
            Write-Output "Setting permissions on jmxremote.password"
            $userName = 'apachetomcat'
            $rights = "Read"
            $inheritSettings = "None"
            $propogationSettings = "None"
            $ruleType = "Allow"
            $acl = Get-Acl $jmxPasswordPath
            $perm = $userName, $rights, $inheritSettings, $propogationSettings, $ruleType
            $rule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $perm
            $acl.SetAccessRuleProtection($true,$false)
            Foreach($access in $acl.access){
                $acl.RemoveAccessRule($access) | Out-Null
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
    else
    {
        "$jmxPasswordPath does not exist."
    }
}

function UpdateImagingExchangeCacheXML([xml] $xmlDocument)
{
    # force vixcache path in ImagingExchangeCache-cache.xml to be as the environment variable in case it changed during install
	$locationUriNode = $xmlDocument.SelectSingleNode('//object/void[@property="locationUri"]')
    $locationUriString = $locationUriNode.string
    if ($null -ne $locationUriString)
    {
        $installFile = "C:\VixConfig\VixInstallerConfig.xml"
        $installerXMLFile = [XML](Get-Content $installFile)
        $localCacheNode = $installerXMLFile.SelectSingleNode('//VixConfigurationParameters/LocalCacheDir')
        $localCacheNodeText = $localCacheNode.InnerText.Trim()
        $filledlocationUriContent = "file://$localCacheNodeText"
        $locationUriNode.string = $filledlocationUriContent
        Write-Output "Updated locationUri in ImagingExchangeCache-cache.xml."
    }

    $regionMementoStringNameNodes = $xmlDocument.SelectNodes('//object/void[@property="regionMementos"]/void/object/void[@property="name"]')
    $scpRegionbool = $false
    foreach ($regionMementoStringNameNode in $regionMementoStringNameNodes)
    {
        $regionMementoString = $regionMementoStringNameNode.string
        if (($null -ne $regionMementoString) -and (($regionMementoString -eq "scp-region")))
        {
            $scpRegionbool = $true
            Write-Output "scp-region found in ImagingExchangeCache-cache.xml, not adding"
            break
        }
    }

    if ($scpRegionbool -eq $false)
    {
        Write-Output "Adding scp-region in ImagingExchangeCache-cache.xml."
        $regionMementoNode = $xmlDocument.SelectSingleNode('//object/void[@property="regionMementos"]')

        #build new scp region node by hand and force it to be an XML object
$newScpRegionNode = @'
<void method="add">
    <object class="gov.va.med.imaging.storage.cache.impl.memento.PersistentRegionMemento">
          <void property="evictionStrategyNames">
            <array class="java.lang.String" length="1">
                <void index="0">
                    <string>thirty-day-lifespan</string>
                </void>
            </array>
          </void>
        <void property="name">
            <string>scp-region</string>
        </void>
        <void property="secondsReadWaitsForWriteCompletion">
            <int>60</int>
        </void>
    </object>
</void>
'@

        $tempScpXmlDoc = new-object System.Xml.XmlDocument
        $tempScpXmlDoc.LoadXml($newScpRegionNode)
        $newScpRegionNode = $xmlDocument.ImportNode($tempScpXmlDoc.DocumentElement, $true)
        $regionMementoNode.AppendChild($newScpRegionNode) | Out-Null
    }
	
	
	# VAI-1084
	# Check if the first new void element already exists
	$newPutElement1 = $xmlDocument.SelectSingleNode("//object[@id='EvictionTimerImplMemento0']/void[@property='sweepIntervalMap']/void[@method='put' and long='604800000' and string='0000:00:01:00:00:00@0000:00:00:01:00:00']")

	# Check if the second new void element already exists
	$newPutElement2 = $xmlDocument.SelectSingleNode("//object[@id='EvictionTimerImplMemento0']/void[@property='sweepIntervalMap']/void[@method='put' and long='2592000000' and string='0000:00:01:00:00:00@0000:00:00:01:00:00']")

	# Add the first new void element if it doesn't exist
	if ($newPutElement1 -eq $null) {
		$sweepIntervalMapNode = $xmlDocument.SelectSingleNode("//object[@id='EvictionTimerImplMemento0']/void[@property='sweepIntervalMap']")
		$put1 = $xmlDocument.CreateElement("void")
		$put1.SetAttribute("method", "put")
		$long1 = $xmlDocument.CreateElement("long")
		$long1.InnerText = "604800000"
		$string1 = $xmlDocument.CreateElement("string")
		$string1.InnerText = "0000:00:01:00:00:00@0000:00:00:01:00:00"
		$put1.AppendChild($long1) | Out-Null
		$put1.AppendChild($string1) | Out-Null
		$sweepIntervalMapNode.AppendChild($put1) | Out-Null
	}

	# Add the second new void element if it doesn't exist
	if ($newPutElement2 -eq $null) {
		$sweepIntervalMapNode = $xmlDocument.SelectSingleNode("//object[@id='EvictionTimerImplMemento0']/void[@property='sweepIntervalMap']")
		$put2 = $xmlDocument.CreateElement("void")
		$put2.SetAttribute("method", "put")
		$long2 = $xmlDocument.CreateElement("long")
		$long2.InnerText = "2592000000"
		$string2 = $xmlDocument.CreateElement("string")
		$string2.InnerText = "0000:00:01:00:00:00@0000:00:00:01:00:00"
		$put2.AppendChild($long2) | Out-Null
		$put2.AppendChild($string2) | Out-Null
		$sweepIntervalMapNode.AppendChild($put2) | Out-Null
	}
}

function createBackup($path) {

	# create backup copy of critical config files
	Write-Host "getting computer name..."
	$myname = (Get-CimInstance win32_computersystem).DNSHostName+"."+(Get-CimInstance win32_computersystem).Domain
	Write-Host "computer name: $myname"

	$myTimestamp = Get-Date -Format 'yyyyMMdd.HHmmss'
	Write-Host $myTimestamp

	foreach ($configf in $path)
	{	
		if ([System.IO.File]::Exists($configf)) 
		{
			Write-Host "Backing up $($configf) ..."

			$destFile = "$($configf)_$($myTimestamp)"

			Copy-Item "$($configf)" "$($destFile)"
			if (Test-Path "$($destFile)") {
				Write-Host "backup successful"
			} else {
				Write-Host "backup failed!!!!"
			}		
		}
	}
}

function restoreBackup {
	# restore backup copy of critical config files
    
    if (($PriorInstallerVersionNum -ne "0") -and ($ConfigCheck -eq 0))
	{
        # restore backup copy of critical config files
        # check if backed-up file of the server file exist before copying over 
        if ([System.IO.File]::Exists($preServerFile)) 
        { 
            Write-Host "***** Restoring Pre-Install Tomcat Server File *****"
            Write-Host "copying pre-install backup..."
            Copy-Item "$($preServerFile)" "$($serverFile)"
        } 
        else 
        { 
            Write-Host "File $preServerFile was not found! No backup was created!"  -foregroundcolor red 
        }
    }

	# check if backed-up file of the cache file exist before copying over 
	if ([System.IO.File]::Exists($preCacheFile)) 
	{
		Write-Host "***** Restoring Pre-Install Cache Config File *****"
		Write-Host "copying pre-install backup..."
		Copy-Item "$($preCacheFile)" "$($cacheFile)"
	}
	else 
	{ 
		Write-Host "File $preCacheFile was not found! No backup was created!"  -foregroundcolor red 
	}
	
	if ((Test-Path -path $preBackPath) -and ((Get-ChildItem -Path $preBackPath -Directory -Recurse -Force).Count -gt 0)) {
		# check if backed-up file of the vista connection file exist before copying over 
		if ([System.IO.File]::Exists($preVistaConnectionFile)) 
		{ 
			Write-Host "***** Restoring Pre-Install Vista Connection Config File *****"
			Write-Host "copying pre-install backup..."
			Copy-Item "$($preVistaConnectionFile)" "$($vistaConnectionFile)"
		} 
		else 
		{ 
			Write-Host "File $preVistaConnectionFile was not found! No backup was created!"  -foregroundcolor red 
		}
		
		# check if backed-up file of the ae title mappings file exist before copying over 		
		if ([System.IO.File]::Exists($preAETitleFile)) 
		{ 
			Write-Host "***** Restoring Pre-Install AE Title Mappings File *****"
			Write-Host "copying pre-install backup..."
			Copy-Item "$($preAETitleFile)" "$($aeTitleFile)"
		} 
		else 
		{ 
			Write-Host "File $preAETitleFile was not found! No backup was created!"  -foregroundcolor red 
		}
	}
}

function updateIdConversionTestorProd([xml] $xmlDocument) {
    # check IdConversionConfiguration.config config file to see if it requires updating/manual user setting
    # Declare test and production values
    $iDSiteConfigurationHostElement = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.facade.configuration.IdConversionConfiguration/host') 
    $iDSiteConfigurationUsernameElement = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.facade.configuration.IdConversionConfiguration/username') 
    $iDSiteConfigurationPasswordElement = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.facade.configuration.IdConversionConfiguration/password') 
    $iDSiteConfigurationTrustStoreElement = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.facade.configuration.IdConversionConfiguration/trustStorePassword') 
       
    $filledHostIDTestContent = "10.247.228.106"
    $filledUsernameIDTestContent = "xxf3FL3NPoZyCDx2n3IWCSM6nvDLNg=="
    $filledPasswordIDTestContent = "8SDDMqvaUb1Uq9eylrEhtH7TZeOFT2NHulA="
    $filledHostIDProdContent = "vaec.lvs.va.gov"
    $filledUsernameIDProdContent = "xxf3FL3NPoZyCDx2n3IWCSM6nvDLNg=="
    $filledPasswordIDProdContent = "x0bqV7mIDf4C7m8Mc8TLxn21hXEZq0ZX-04="
    $filledPasswordTrustStoreContent = "40ayE7raRv4u-_TOh9p_PsV1Cm-NTi-H"
	
	if ($global:TestorProd -eq 1)
    {
        $iDSiteConfigurationHostElement.InnerText = $filledHostIDTestContent
        $iDSiteConfigurationUsernameElement.InnerText = $filledUsernameIDTestContent
        $iDSiteConfigurationPasswordElement.InnerText = $filledPasswordIDTestContent
        $iDSiteConfigurationTrustStoreElement.InnerText = $filledPasswordTrustStoreContent
        Write-Host "Setting test host, username, and password values #1."
        Write-Host "For the IdConversionConfiguration file C:\VixConfig\IdConversionConfiguration.config"  
	}
				
	if ($global:TestorProd -eq 2)
    {
        $iDSiteConfigurationHostElement.InnerText = $filledHostIDProdContent
        $iDSiteConfigurationUsernameElement.InnerText = $filledUsernameIDProdContent
        $iDSiteConfigurationPasswordElement.InnerText = $filledPasswordIDProdContent
        $iDSiteConfigurationTrustStoreElement.InnerText = $filledPasswordTrustStoreContent
        Write-Host "Setting production host, username, and password values #1."
        Write-Host "For the IdConversionConfiguration file C:\VixConfig\IdConversionConfiguration.config"     
    }
}

function Get-DoDSiteInfo-CVIX {   
	# Check site service to see if *fhie.med.va.gov exists under DoD, if it does assume production otherwise assume test
	 Write-Output "*****************************************"
     Write-Output "reading $($siteservice)"

     # Getting site information  
     [xml]$xmlDoc = Get-Content $siteservice

     $xml_VhaSites = $xmlDoc.VhaVisnTable.VhaVisn.VhaSite

     foreach ($site in $xml_VhaSites) 
     {
        $sitename = "$($site.name)"
        $siteid = "$($site.ID)"
        $sitemoniker = "$($site.moniker)"

		if($sitemoniker -eq "DoD") {		
		$fhieVIX =  $site.DataSource | Where{$_.source -like "*fhie.med.va.gov"}			
		$DODsitevix = $fhieVIX.source	
			if ($DODsitevix -ne $null) {
			$global:TestorProd=2;					
			Write-Host "*fhie.med.va.gov found setting to Production"
			}			
			else {
			$global:TestorProd=1;					
			Write-Host "*fhie.med.va.gov not found setting to Test"	
			}	
		}
     }
}

function Get-DoDSiteInfo-VIX {   
	# Check site service cache to see if *fhie.med.va.gov exists under DoD, if it does assume production otherwise assume test
     Write-Output "*****************************************"
     Write-Output "reading $($siteserviceCache)"
	 
	 # Getting site information  
     [xml]$xmlDoc = Get-Content $siteserviceCache
	 
	 $DoDServerElementVIX = $xmlDoc.SelectSingleNode('//list/gov.va.med.imaging.exchange.business.SiteImpl[siteName="DoD"]/siteConnections/entry[string="VISTA"]/gov.va.med.imaging.exchange.business.SiteConnection/server') 
	 
	if(($DoDServerElementVIX -eq $null) -or ($DoDServerElementVIX.InnerText.Trim() -like "*fhie.med.va.gov")) {		
		$global:TestorProd=2;
		if($DoDServerElementVIX -eq $null) 
		{
			Write-Host "server tag not found setting to default Production"	
		}
		else 
		{
			Write-Host "*fhie.med.va.gov found setting to Production"	
		}	
	}			
	else 
	{
		$global:TestorProd=1;					
		Write-Host "*fhie.med.va.gov not found setting to Test"	
	}	    
}

# folder location for pre-install backups if they exist 
$preBackPath = "C:\VIXbackup\P$PriorInstallerVersionNum\"

# file location for pre-install backups if they exist - for P254 only 
$preOldBackPath = "C:\temp\P$PriorInstallerVersionNum"

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

# file location for pre-install backups if they exist otherwise for log
# for VIX
if ($RoleType -ne "CVIX") {
Start-Transcript -Path ("C:\Program Files (x86)\Vista\Imaging\VixInstaller\vix-install-post-log.txt") -Append
}
# for CVIX
else {
Start-Transcript -Path ("C:\Program Files (x86)\Vista\Imaging\CvixInstaller\vix-install-post-log.txt") -Append
}

# config editor
Write-Output "****************************************************"
Write-Output "****************************************************"
Write-Output "               VIX Config Editor"
Write-Output "****************************************************"
Write-Output "****************************************************"

# read render config file
$renderConfigFile = Join-Path $configFolder 'VIX.Render.Config'
Write-Output 'Reading ' $renderConfigFile
if ([System.IO.File]::Exists($renderConfigFile))
{ 
    try
    {
        [xml]$renderXmlDoc = Get-Content -Path $renderConfigFile
        Check-Log $renderXmlDoc 'VixRender' 
        Check-Render-Purge $renderXmlDoc
        # Database CommandTimeout Addition for patch 254 
        Update-Render-Parameters $renderXmlDoc
        $renderXmlDoc.Save($renderConfigFile)	
        Check-Render-TIFF-TimeOut $renderXmlDoc
        $renderXmlDoc.Save($renderConfigFile)
        VrConfigRemoveTiffOptions $renderXmlDoc
        $renderXmlDoc.Save($renderConfigFile)
    }
    catch
    {
        Write-Output "An error occurred:" -foregroundcolor red
        Write-Output $_.Exception.Message -foregroundcolor red
        Write-Output $_.ScriptStackTrace -foregroundcolor red
    }    
}
else 
{
    Write-Output 'ERROR! - ' $renderConfigFile ' does not exist'
}

# read viewer config file
$viewerConfigFile = Join-Path $configFolder 'VIX.Viewer.Config'
Write-Host 'Reading ' $viewerConfigFile
if ([System.IO.File]::Exists($viewerConfigFile))
{
    [xml]$ViewerXmlDoc = Get-Content -Path $viewerConfigFile

    Check-Log $ViewerXmlDoc 'VixViewer'
    Check-Viewer-Policies $ViewerXmlDoc

    $ViewerXmlDoc.Save($viewerConfigFile)
}
else 
{
    Write-Host 'ERROR! - ' $viewerConfigFile ' does not exist'
}

# file location for critical config files
$scriptDirectory = "C:\Program Files\VistA\Imaging\Scripts"
$renderFile = "C:\Program Files\VistA\Imaging\VIX.Config\VIX.Render.config"
$viewerFile = "C:\Program Files\VistA\Imaging\VIX.Config\VIX.Viewer.config"
$serverFile = "C:\Program Files\Apache Software Foundation\Tomcat 9.0\conf\server.xml"
$cacheFile = "C:\VixConfig\cache-config\ImagingExchangeCache-cache.xml"
$aeTitleFile = "C:\DCF_RunTime_x64\cfg\dicom\ae_title_mappings"
$idConversionConfigFile = "C:\VixConfig\IdConversionConfiguration.config"
$vistaConnectionFile = "C:\VixConfig\VistaConnectionConfiguration.config"
$webXMLFile = "C:\Program Files\Apache Software Foundation\Tomcat 9.0\conf\web.xml"

# for VIX
if ($RoleType -ne "CVIX") {
	# file location for critical config files
	$configFiles = @($renderFile, $viewerFile, $serverFile, $webXMLFile, $cacheFile, $idConversionConfigFile)
}
# for CVIX
else {
	# file location for critical config files
	$mixDataSourceFile = "C:\VixConfig\MIXDataSource-1.0.config"

	$configFiles = @($renderFile, $viewerFile, $serverFile, $webXMLFile, $cacheFile, $idConversionConfigFile, $mixDataSourceFile)
 
    #VAI 548 - MUSE file not needed on the CVIX
    $museFile = "C:\VixConfig\MuseDataSource-1.0.Config"   
    if ([System.IO.File]::Exists($museFile)) 
    { 
        Remove-Item $museFile -Force 
        Write-Host "file $museFile deleted"
    }      
}

Get-ChildItem $scriptDirectory -recurse -Filter *.ps1 | Unblock-File

# create additional backup of config files for files that come out of the installer
Write-Host "***** Backing up copies of config files *****"
createBackup $configFiles 

# ensure at least one back-ups of configuration file folders exists in folder location for pre-install backups
if ((Test-Path -path $preBackPath) -and ((Get-ChildItem -Path $preBackPath -Directory -Recurse -Force).Count -gt 0)) {
	#obtain the most recently accessed folder backup folder by listing in descending order 
	$lastBackup = Get-ChildItem -Path $preBackPath | Sort-Object Name -Descending | Select-Object -First 1
	
	# file location for pre-install backups from the backup folder
    $preServerFile = $lastBackup.ToString()  + "\Tomcat 9.0\conf\server.xml"
    Write-Host "$preServerFile"
	$preCacheFile = $lastBackup.ToString()  + "\VixConfig\cache-config\ImagingExchangeCache-cache.xml"	
    Write-Host "$preCacheFile"
	$preAETitleFile = $lastBackup.ToString()  + "\DCF_RunTime_x64\cfg\dicom\ae_title_mappings"	
	$preIdConversionSourceFile = $lastBackup.ToString()  + "\VixConfig\IdConversionConfiguration.config"
	$preVistaConnectionFile = $lastBackup.ToString()  + "\VixConfig\VistaConnectionConfiguration.config"	
	# restore backup of config files from pre-install backup
	Write-Host "***** Restoring back-up copies in case of upgrade *****"
	restoreBackup
	Write-Host "DONE backing up and restoring config files"	
}
else {
	Write-Host "NO backups being restored."
}

Write-Host "***** Editing Tomcat Files *****"
updateServerXML $serverFile
$tomcatServerXMLFile = [XML](Get-Content $serverFile)
updateTomcatServer $tomcatServerXMLFile
$tomcatServerXMLFile.save($serverFile)
Write-Host "DONE updating Tomcat server.xml"
$tomcatWebXMLFile = [XML](Get-Content $webXMLFile)
UpdateTomcatWebXML $tomcatWebXMLFile
$tomcatWebXMLFile.save($webXMLFile)
Write-Host "DONE updating Tomcat web.xml"
SetJMXPermissions
Write-Host "DONE updating JMX password permissions"

Write-Host "***** Editing ImagingExchangeCache-cache.xml File *****"
$imagingExchangeCacheXMLFile = [XML](Get-Content $cacheFile)
UpdateImagingExchangeCacheXML $imagingExchangeCacheXMLFile
[System.Xml.XmlWriterSettings] $exchangeCacheXmlSettings = New-Object System.Xml.XmlWriterSettings
#Preserve Windows formating
$exchangeCacheXmlSettings.Indent = $true
#Set encoding to UTF-8 without BOM
$exchangeCacheXmlSettings.Encoding = New-Object System.Text.UTF8Encoding($false)
[System.Xml.XmlWriter] $exchangeCacheXmlWriter = [System.Xml.XmlWriter]::Create($cacheFile, $exchangeCacheXmlSettings)
$imagingExchangeCacheXMLFile.Save($exchangeCacheXmlWriter)
#Close handle and flush
$exchangeCacheXmlWriter.Dispose()
Write-Host "DONE updating ImagingExchangeCache-cache.xml"

# perform SSL binding of certificate
Write-Host "****************************************************"
Write-Host "****************************************************"
Write-Host "           SSL Cert and Port Binding"
Write-Host "****************************************************"
Write-Host "****************************************************"
$sslBindingPSFile=Get-ChildItem -Path ($scriptDirectory + "\" + "ssl_binder.ps1")
if ([System.IO.File]::Exists($sslBindingPSFile)) 
{ 
	&"$sslBindingPSFile" $RoleType 
} 
else 
{ 
	Write-Host "File $sslBindingPSFile was not found! Script not run!"  -foregroundcolor red 
}

# scheduled restart task scheduler
Write-Host "****************************************************"
Write-Host "****************************************************"
Write-Host "          Service Restart Task Scheduler"
Write-Host "****************************************************"
Write-Host "****************************************************"
$taskSchedulerPSFile=Get-ChildItem -Path ($scriptDirectory + "\" + "task_scheduler.ps1")
if ([System.IO.File]::Exists($taskSchedulerPSFile)) 
{ 
	&"$taskSchedulerPSFile" 
} 
else 
{ 
	Write-Host "File $taskSchedulerPSFile was not found! Script not run!"  -foregroundcolor red 
}

# port settings update and check
Write-Host "****************************************************"
Write-Host "****************************************************"
Write-Host "        Port Settings"
Write-Host "****************************************************"
Write-Host "****************************************************"
$portSettingsPSFile=Get-ChildItem -Path ($scriptDirectory + "\" + "port_setting.ps1")
if ([System.IO.File]::Exists($portSettingsPSFile)) 
{ 
	&"$portSettingsPSFile" 
} 
else 
{ 
	Write-Host "File $portSettingsPSFile was not found! Script not run!"  -foregroundcolor red 
}

# registry update and check
Write-Host "****************************************************"
Write-Host "****************************************************"
Write-Host "        Registry Update"
Write-Host "****************************************************"
Write-Host "****************************************************"
$registryUpdatePSFile=Get-ChildItem -Path ($scriptDirectory + "\" + "registry_update.ps1")
if ([System.IO.File]::Exists($registryUpdatePSFile)) 
{ 
	&"$registryUpdatePSFile" 
} 
else 
{ 
	Write-Host "File $registryUpdatePSFile was not found! Script not run!"  -foregroundcolor red 
}

#1 for test 2 for production - assume prod if something fails with siteservice
$global:TestorProd=2;

# determine if test or prod from site service or cached site service
if ($RoleType -ne "CVIX") {
	#for VIX determine from SiteServiceCache.xml if exists
	$siteserviceCache = "C:\VixConfig\SiteServiceCache.xml"
	if ([System.IO.File]::Exists($siteserviceCache))
	{  
		Get-DoDSiteInfo-VIX
	} 
	else
	{
		Write-Host "Site service cache does not yet exist"          
	}
}
else {
	#for CVIX determine from VhaSites.xml
	$siteservice = "C:\VixConfig\VhaSites.xml"

	if (!([System.IO.File]::Exists($siteservice)))
	{  
		$siteservice = "C:\SiteService\VhaSites.xml"            
	}
	
	Get-DoDSiteInfo-CVIX
}

# for CVIX - MIXDataSource config update
if ($RoleType -eq "CVIX") {
    if (($PriorInstallerVersionNum -eq "0") -or ($ConfigCheck -eq 1))
	{ 
        Write-Host "****************************************************"
        Write-Host "****************************************************"
        Write-Host "                 MIXDataSource Update"
        Write-Host "****************************************************"
        Write-Host "****************************************************"
        $mixDataSourcePSFile=Get-ChildItem -Path ($scriptDirectory + "\" + "mixdatasource_update.ps1")
		Write-Host "New installation or update requested."  -foregroundcolor red
		if ([System.IO.File]::Exists($mixDataSourcePSFile))
		{
			&"$mixDataSourcePSFile" $RoleType
		}
		else
		{
			Write-Host "File $mixDataSourcePSFile was not found! Script not run!"  -foregroundcolor red
		}
	}
}

Write-Host "****************************************************"
Write-Host "****************************************************"
Write-Host "                 IdConversionConfiguration Update"
Write-Host "****************************************************"
Write-Host "****************************************************"	
Write-Host "***** Editing IdConversionConfiguration.Config File *****"	
if ([System.IO.File]::Exists($preIdConversionSourceFile))
{
	#Get xml data
	[xml]$preIDConversionSourceFileXmlDoc = Get-Content -Path $preIdConversionSourceFile

    $preIDHostNameElement = $preIDConversionSourceFileXmlDoc.SelectSingleNode('//host')
    $preIDUsernameElement = $preIDConversionSourceFileXmlDoc.SelectSingleNode('//username')     
	$preIDPasswordElement = $preIDConversionSourceFileXmlDoc.SelectSingleNode('//password')
    $oldHostIDProdContent = "10.208.228.10"
    $defaultIDProdContent = "NEED.TO.CHANGE.HOST"

	if (($preIDHostNameElement -eq $null) -or ($preIDUsernameElement -eq $null) -or ($preIDPasswordElement -eq $null))
    {
		Write-Host "Default username and password template is missing, not restoring prior IdConversionConfiguration config file"
		#Get xml data
		$idConversionXmlDocTestorProd = ( Select-Xml -Path $idConversionConfigFile -XPath / ).Node
		#Attempt to apply updates
		updateIdConversionTestorProd $idConversionXmlDocTestorProd
		#Save file
		$idConversionXmlDocTestorProd.Save($idConversionConfigFile)
		Write-Host "*** Done Editing IdConversionConfiguration.Config File ***"
	}
    # check if like the template values for the host and if like the on prem LVS and default
    # only restore back-up if not like template host and not like the on prem LVS and default
	elseif((($preIDHostNameElement -ne $null) -and ($preIDHostNameElement.InnerText.Trim() -NotLike $oldHostIDProdContent) -and ($preIDHostNameElement.InnerText.Trim() -NotLike $defaultIDProdContent)))
    {
		Write-Host "Default host and old host do not exist, restoring Pre-Install IdConversionConfiguration config file"
		Write-Host "copying pre-install backup..."
		Copy-Item "$($preIdConversionSourceFile)" "$($idConversionConfigFile)"
	}
	else
    {
		Write-Host "Default host or old host exists, not restoring prior IdConversionConfiguration config file"
		#Get xml data
		$idConversionXmlDocTestorProd = ( Select-Xml -Path $idConversionConfigFile -XPath / ).Node
		#Attempt to apply updates
		updateIdConversionTestorProd $idConversionXmlDocTestorProd
		#Save file
		$idConversionXmlDocTestorProd.Save($idConversionConfigFile)
		Write-Host "*** Done Editing IdConversionConfiguration.Config File ***"
	}
}
else
{
	Write-Host "File $preIdConversionSourceFile was not found! No backup was created!"  -foregroundcolor red
	if ([System.IO.File]::Exists($idConversionConfigFile))
	{
		[xml]$IDConversionSourceFileXmlDoc = Get-Content -Path $idConversionConfigFile
		$iDHostNameElement = $IDConversionSourceFileXmlDoc.SelectSingleNode('//host')
		$defaultIDProdContent = "NEED.TO.CHANGE.HOST"
		if (($iDHostNameElement -ne $null) -and ($iDHostNameElement.InnerText.Trim() -Like $defaultIDProdContent))
        {
			Write-Host "Default host exists."
			#Get xml data
			$idConversionXmlDocTestorProd = ( Select-Xml -Path $idConversionConfigFile -XPath / ).Node
			#Attempt to apply updates
			updateIdConversionTestorProd $idConversionXmlDocTestorProd
			#Save file
			$idConversionXmlDocTestorProd.Save($idConversionConfigFile)
			Write-Host "*** Done Editing IdConversionConfiguration.Config File ***"
		}
        else
        {
           Write-Host "*** Edit of IdConversionConfiguration.Config File Aborted ***"
        }
	}
}

# perform AE Title Mappings update for DICOM SCP
Write-Host "****************************************************"
Write-Host "****************************************************"
Write-Host "               AE Title Mappings Update"
Write-Host "****************************************************"
Write-Host "****************************************************"	
$aeTitlePSFile=Get-ChildItem -Path ($scriptDirectory + "\" + "dicom_scp_update.ps1")
if ([System.IO.File]::Exists($aeTitlePSFile) -and ($PriorInstallerVersionNum -eq "0")) 
{ 
	&"$aeTitlePSFile" $RoleType $global:TestorProd
} 
else 
{ 
	Write-Host "File $aeTitlePSFile did not run, not a new installation." 
}

# run any patch specific post-scripts that may exist (ie. p303_post_script.ps1)
Write-Host "****************************************************"
Write-Host "****************************************************"
Write-Host "              Patch" $InstallerVersionNum "Scripts"
Write-Host "****************************************************"
Write-Host "****************************************************"
$patchFiles=Get-ChildItem -Path ($scriptDirectory + "\p" + $InstallerVersionNum + "_post*.ps1")
if (!$patchFiles )
	 { 
		Write-Host "No Patch" $InstallerVersionNum "Specific Post-Scripts Found"
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