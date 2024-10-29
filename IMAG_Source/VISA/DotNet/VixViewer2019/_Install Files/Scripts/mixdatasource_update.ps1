# MIXDataSource config update

param
(
    [Parameter(Mandatory=$True)][string]$RoleType # CVIX or VIX
)

# relaunch as an elevated process if not currently in administrator mode
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    $PSHost = If ($PSVersionTable.PSVersion.Major -gt 5) {'PwSh'} else {'PowerShell'}
    Start-Process $PSHost -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$($PWD.Path)'; & '$PSCommandPath' $RoleType`"";
    Exit 
}

function updateMixDataTestorProd([xml] $xmlDocument) {
		# check MIXDataSource config file to see if it requires updating/manual user setting
		$EciaDicomSiteConfigurationHostElement = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.url.mix.configuration.EciaDicomSiteConfiguration/host') 
		$EciaDicomSiteConfigurationCallingAEElement = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.url.mix.configuration.EciaDicomSiteConfiguration/callingAE') 
		$EciaDicomSiteConfigurationCalledAEElement = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.url.mix.configuration.EciaDicomSiteConfiguration/calledAE') 
		$MIXSiteConfigurationHostElement = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.url.mix.configuration.MIXSiteConfiguration[mixApplication="AcuoRest"]/host') 
				
		$filledHostEciaTestContent = "10.247.210.12"
		$filledcallingAETestContent = "ACUO_TESTING"
		$filledcalledAETestContent = "VA_ECIA_TESTAPP2"
		$filledHostMIXSTestContent = "10.247.210.12"
		
		$filledHostEciaProdContent = "VAC10APPHIE201.va.gov"
		$filledcallingAEProdContent = "PROD_CVIX"	
		$filledcalledAEProdContent = "VA_ECIA"
		$filledHostMIXSProdContent = "VAC10APPHIE201.va.gov"
		
	if ($global:TestorProd -eq 1) {
	
		if ($EciaDicomSiteConfigurationHostElement.InnerText.Trim() -Like $filledHostEciaTestContent) {		
			Write-Host "Test EciaDicomSiteConfiguration Host found, edit aborted."				 		 								
		}	
		else 
		{		
		$EciaDicomSiteConfigurationHostElement.InnerText = $filledHostEciaTestContent
		$EciaDicomSiteConfigurationCallingAEElement.InnerText = $filledcallingAETestContent
		$EciaDicomSiteConfigurationCalledAEElement.InnerText = $filledcalledAETestContent
		$MIXSiteConfigurationHostElement.InnerText = $filledHostMIXSTestContent
		
		Write-Warning "Please make sure to check/set the MIXDataSource configuration edits to"
		Write-Warning "C:\VixConfig\MIXDataSource-1.0.Config"
		Write-Warning "If performing a new installation or verify for an upgrade"											
		}		
	}
				
	if ($global:TestorProd -eq 2) {
	
		if ($EciaDicomSiteConfigurationHostElement.InnerText.Trim() -Like $filledHostEciaProdContent) {		
			Write-Host "Prod EciaDicomSiteConfiguration Host found, edit aborted."				 		 								
		}	
		else 
		{	
		$EciaDicomSiteConfigurationHostElement.InnerText = $filledHostEciaProdContent
		$EciaDicomSiteConfigurationCallingAEElement.InnerText = $filledcallingAEProdContent
		$EciaDicomSiteConfigurationCalledAEElement.InnerText = $filledcalledAEProdContent
		$MIXSiteConfigurationHostElement.InnerText = $filledHostMIXSProdContent
		
		Write-Warning "Please make sure to check/set the MIXDataSource configuration edits to"
		Write-Warning "C:\VixConfig\MIXDataSource-1.0.Config"
		Write-Warning "If performing a new installation or verify for an upgrade"											
		}		
	}		
}

function updateMixDataConfig([xml] $xmlDocument) {
		# check MIXDataSource config file to see if it requires updating/manual user setting
		
		$staticImageElement = $xmlDocument.SelectSingleNode('//staticImageFile') 
		$mixConfigurationElement = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.url.mix.configuration.MIXConfiguration')
		
		if ($staticImageElement -ne $null) {		
			$staticImageElement.RemoveAll()
			$staticImageElement.ParentNode.RemoveChild($staticImageElement)			
			Write-Host "Removed staticImageFile tag."
			
			$imageTypeNotSupportText = 'C:/VixConfig/ImageTypeNotSupported.dcm'			
			$imageTypeNotSuppElementPrior = $xmlDocument.SelectSingleNode('//imageTypeNotSupportedFile') 
			
			if ($imageTypeNotSuppElementPrior -eq $null) {	
				$imageTypeNotSuppElement = $xmlDocument.CreateElement('imageTypeNotSupportedFile')
				$imageTypeNotSuppElement.InnerText = $imageTypeNotSupportText
				$mixConfigurationElement.AppendChild($imageTypeNotSuppElement)
				Write-Host "Adding imageTypeNotSupportedFile tag."				
			}
		}
		
		$eciaConfigurationElement = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.url.mix.configuration.EciaDicomSiteConfiguration')
		$eciaConfigurationElementConTimeOut = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.url.mix.configuration.EciaDicomSiteConfiguration/connectTimeOut')
		$eciaConfigurationElementCFindTimeOut = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.url.mix.configuration.EciaDicomSiteConfiguration/cfindRspTimeOut')
		
		if ($eciaConfigurationElementConTimeOut -eq $null) {
			$ConTimeOutText='60000'
			$ConTimeOutElement=$xmlDocument.CreateElement('connectTimeOut')
			$ConTimeOutElement.InnerText = $ConTimeOutText
			$eciaConfigurationElement.AppendChild($ConTimeOutElement)
			Write-Host "Adding connectTimeOut tag."					
		}
		else 
		{
			Write-Host "connectTimeOut tag already exists"	
		}
		
		if ($eciaConfigurationElementCFindTimeOut -eq $null) {
			$CFindTimeOutText='300000'
			$CFindTimeOutElement=$xmlDocument.CreateElement('cfindRspTimeOut')
			$CFindTimeOutElement.InnerText = $CFindTimeOutText
			$eciaConfigurationElement.AppendChild($CFindTimeOutElement)
			Write-Host "Adding cfindRspTimeOut tag."					
		}
		else 
		{
			Write-Host "cfindRspTimeOut tag already exists"	
		}
		
		$xmlDocument.SelectNodes('//emptyStudyModalities/string') | ForEach-Object {
			if ($_.InnerText -like "SR") {
				$_.ParentNode.RemoveChild($_)
			}
		}
		
		$sopBlacklistViewerElement = $xmlDocument.SelectSingleNode('//sopBlacklistForVixViewer') 
		$filledSOPContent = "*1.2.840.10008.5.1.4*"
						
		if (($sopBlacklistViewerElement -ne $null) -and ($sopBlacklistViewerElement.InnerText.Trim() -like $filledSOPContent)) {		
			Write-Host "SOP Class UID found, edit aborted."					 
		}						
		else
		{			
			# if SOP class UIDs missing then add them
			Write-Host "Adding SOP Class UIDs."
			$vistaRadModalityElement = $xmlDocument.SelectSingleNode('//vistaRadModalityBlacklist') 		
			$sopBlaclkistDisplayElement = $xmlDocument.SelectSingleNode('//sopBlacklistForClinicalDisplay') 
			$sopBlaclkistVistaRadElement = $xmlDocument.SelectSingleNode('//sopBlacklistForVistaRad') 
			
			$vistaRadModalityElement.RemoveAll()	
			
			$vistaRadModalityValues = 'DOC', 'IO', 'OAM', 'OCT', 'OP', 'OPM', 'OPT', 'OPV', 'OSS', 'PX'
			foreach ($vistaRadModalityValue_i in $vistaRadModalityValues) {
				$xmlStringvistRad1 = $xmlDocument.CreateElement("string")
				$xmlStringvistRad1.InnerText = $vistaRadModalityValue_i
				$vistaRadModalityElement.AppendChild($xmlStringvistRad1)
			}
				
			$sopBlaclkistDisplayElement.RemoveAll()			

			$sopBlacklistDisplayComment1=$xmlDocument.CreateComment("SR SOPs")
			$sopBlaclkistDisplayElement.AppendChild($sopBlacklistDisplayComment1)
			
			$sopBlacklistDisplaySRValues = '1.2.840.10008.5.1.4.1.1.88.11', '1.2.840.10008.5.1.4.1.1.88.22', '1.2.840.10008.5.1.4.1.1.88.33', '1.2.840.10008.5.1.4.1.1.88.40', '1.2.840.10008.5.1.4.1.1.88.50', '1.2.840.10008.5.1.4.1.1.88.59', '1.2.840.10008.5.1.4.1.1.88.65', '1.2.840.10008.5.1.4.1.1.88.67'
			
			foreach ($sopBlacklistDisplaySRValue_i in $sopBlacklistDisplaySRValues) {
				$xmlStringSR1 = $xmlDocument.CreateElement("string")
				$xmlStringSR1.InnerText = $sopBlacklistDisplaySRValue_i
				$sopBlaclkistDisplayElement.AppendChild($xmlStringSR1)
			}
			
			$sopBlacklistDisplayComment2=$xmlDocument.CreateComment("PR SOPs")
			$sopBlaclkistDisplayElement.AppendChild($sopBlacklistDisplayComment2)
			
			$sopBlacklistDisplayPRValues = '1.2.840.10008.5.1.4.1.1.11.1'
			
			foreach ($sopBlacklistDisplayPRValue_i in $sopBlacklistDisplayPRValues) {
				$xmlStringPR1 = $xmlDocument.CreateElement("string")
				$xmlStringPR1.InnerText = $sopBlacklistDisplayPRValue_i
				$sopBlaclkistDisplayElement.AppendChild($xmlStringPR1)
			}
						
			$sopBlaclkistVistaRadElement.RemoveAll()	

			$sopBlacklistVistaRadComment1=$xmlDocument.CreateComment("SR SOPs")
			$sopBlaclkistVistaRadElement.AppendChild($sopBlacklistVistaRadComment1)
			
			$sopBlacklistVistaRadSRValues = '1.2.840.10008.5.1.4.1.1.88.11', '1.2.840.10008.5.1.4.1.1.88.22', '1.2.840.10008.5.1.4.1.1.88.33', '1.2.840.10008.5.1.4.1.1.88.40', '1.2.840.10008.5.1.4.1.1.88.50', '1.2.840.10008.5.1.4.1.1.88.59', '1.2.840.10008.5.1.4.1.1.88.65', '1.2.840.10008.5.1.4.1.1.88.67'
			
			foreach ($sopBlacklistVistaRadSRValue_i in $sopBlacklistVistaRadSRValues) {
				$xmlStringSR3 = $xmlDocument.CreateElement("string")
				$xmlStringSR3.InnerText = $sopBlacklistVistaRadSRValue_i
				$sopBlaclkistVistaRadElement.AppendChild($xmlStringSR3)
			}
			
			$sopBlacklistVistaRadComment2=$xmlDocument.CreateComment("PR SOPs")
			$sopBlaclkistVistaRadElement.AppendChild($sopBlacklistVistaRadComment2)
			
			$sopBlacklistVistaRadPRValues = '1.2.840.10008.5.1.4.1.1.11.1'
			
			foreach ($sopBlacklistVistaRadPRValue_i in $sopBlacklistVistaRadPRValues) {
				$xmlStringPR3 = $xmlDocument.CreateElement("string")
				$xmlStringPR3.InnerText = $sopBlacklistVistaRadPRValue_i
				$sopBlaclkistVistaRadElement.AppendChild($xmlStringPR3)
			}
			
			$sopBlacklistVistaRadComment3=$xmlDocument.CreateComment("encapsulated PDF")
			$sopBlaclkistVistaRadElement.AppendChild($sopBlacklistVistaRadComment3)
			
			$sopBlacklistVistaRadPDFValues = '1.2.840.10008.5.1.4.1.1.104.1'
			
			foreach ($sopBlacklistVistaRadPDFValue_i in $sopBlacklistVistaRadPDFValues) {
				$xmlStringPDF1 = $xmlDocument.CreateElement("string")
				$xmlStringPDF1.InnerText = $sopBlacklistVistaRadPDFValue_i
				$sopBlaclkistVistaRadElement.AppendChild($xmlStringPDF1)
			}	
			
			if ($sopBlacklistViewerElement -ne $null) {				
				$sopBlacklistViewerElement.RemoveAll()
			
				$sopBlacklistViewerComment1=$xmlDocument.CreateComment("Punch list SOPs listed as Displayable 'Yes', but Viewer coded to display object 'No'")
				$sopBlacklistViewerElement.AppendChild($sopBlacklistViewerComment1)
						
				$sopBlacklistViewerValues = '1.2.840.10008.5.1.4.1.1.128.1', '1.2.840.10008.5.1.4.1.1.104.2', '1.2.840.10008.5.1.4.1.1.82.1', '1.2.840.10008.5.1.4.1.1.81.1', '1.2.840.10008.5.1.4.1.1.66.4', '1.2.840.10008.5.1.4.1.1.11.5', '1.2.840.10008.5.1.4.1.1.11.4', '1.2.840.10008.5.1.4.1.1.11.3', '1.2.840.10008.5.1.4.1.1.11.2', '1.2.840.10008.5.1.4.1.1.11.1', '1.2.840.10008.5.1.4.1.1.9.6.1', '1.2.840.10008.5.1.4.1.1.9.5.1', '1.2.840.10008.5.1.4.1.1.9.4.2', '1.2.840.10008.5.1.4.1.1.9.4.1', '1.2.840.10008.5.1.4.1.1.9.3.1', '1.2.840.10008.5.1.4.1.1.9.1.3', '1.2.840.10008.5.1.4.1.1.7.4', 
				'1.2.840.10008.5.1.4.1.1.7.3', '1.2.840.10008.5.1.4.1.1.7.2', '1.2.840.10008.5.1.4.1.1.7.1', '1.2.840.10008.5.1.4.1.1.4.4', '1.2.840.10008.5.1.4.1.1.2.2'
			
				foreach ($sopBlacklistViewerValue_i in $sopBlacklistViewerValues) {
					$xmlString2 = $xmlDocument.CreateElement("string")
					$xmlString2.InnerText = $sopBlacklistViewerValue_i
					$sopBlacklistViewerElement.AppendChild($xmlString2)
				}
			} 
			else 
			{		
				$sopBlackListText=''
				$sopBlackListElement=$xmlDocument.CreateElement('sopBlacklistForVixViewer')
				$sopBlackListElement.InnerText = $sopBlackListText
				$mixConfigurationElement.AppendChild($sopBlackListElement)
				Write-Host "Adding sopBlacklistViewerElement tag."
				
				$sopBlacklistViewerElement1 = $xmlDocument.SelectSingleNode('//sopBlacklistForVixViewer') 
				
				$sopBlacklistViewerComment1=$xmlDocument.CreateComment("Punch list SOPs listed as Displayable 'Yes', but Viewer coded to display object 'No'")
				$sopBlacklistViewerElement1.AppendChild($sopBlacklistViewerComment1)
						
				$sopBlacklistViewerValues = '1.2.840.10008.5.1.4.1.1.128.1', '1.2.840.10008.5.1.4.1.1.104.2', '1.2.840.10008.5.1.4.1.1.82.1', '1.2.840.10008.5.1.4.1.1.81.1', '1.2.840.10008.5.1.4.1.1.66.4', '1.2.840.10008.5.1.4.1.1.11.5', '1.2.840.10008.5.1.4.1.1.11.4', '1.2.840.10008.5.1.4.1.1.11.3', '1.2.840.10008.5.1.4.1.1.11.2', '1.2.840.10008.5.1.4.1.1.11.1', '1.2.840.10008.5.1.4.1.1.9.6.1', '1.2.840.10008.5.1.4.1.1.9.5.1', '1.2.840.10008.5.1.4.1.1.9.4.2', '1.2.840.10008.5.1.4.1.1.9.4.1', '1.2.840.10008.5.1.4.1.1.9.3.1', '1.2.840.10008.5.1.4.1.1.9.1.3', '1.2.840.10008.5.1.4.1.1.7.4', 
				'1.2.840.10008.5.1.4.1.1.7.3', '1.2.840.10008.5.1.4.1.1.7.2', '1.2.840.10008.5.1.4.1.1.7.1', '1.2.840.10008.5.1.4.1.1.4.4', '1.2.840.10008.5.1.4.1.1.2.2'
			
				foreach ($sopBlacklistViewerValue_i in $sopBlacklistViewerValues) {
					$xmlString2 = $xmlDocument.CreateElement("string")
					$xmlString2.InnerText = $sopBlacklistViewerValue_i
					$sopBlacklistViewerElement1.AppendChild($xmlString2)
				}
			}
						
			Write-Host "Done Adding SOP Class UIDs"		
		}
}

function Get-DoDSiteInfo {   
	# Check site service to see if *fhie.med.va.gov exists under DoD, if it does assume production otherwise assume test
     Write-Output "********************"
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

#1 for test 2 for production - assume prod if something fails with siteservice
$global:TestorProd=2;

$mixDataSourceFile = "C:\VixConfig\MIXDataSource-1.0.config"
$siteservice = "C:\VixConfig\VhaSites.xml"

if (!([System.IO.File]::Exists($siteservice)))
{  
	$siteservice = "C:\SiteService\VhaSites.xml"            
}

# for CVIX - MIXDataSource config update
if ($RoleType -eq "CVIX") {
	Get-DoDSiteInfo
	Write-Host "***** Editing MIXDataSource-1.0.Config File *****"	
	$mixDataXmlDocTestorProd = ( Select-Xml -Path $mixDataSourceFile -XPath / ).Node
	updateMixDataTestorProd $mixDataXmlDocTestorProd
    $mixDataXmlDocTestorProd.Save($mixDataSourceFile)	
	$mixDataXmlDocConfig = [XML] (Get-Content $mixDataSourceFile)
	updateMixDataConfig $mixDataXmlDocConfig
	$settingsConfig = new-object System.Xml.XmlWriterSettings
	$settingsConfig.CloseOutput = $true
	$settingsConfig.Indent = $true
	$writerConfig = [System.Xml.XmlWriter]::Create($mixDataSourceFile, $settingsConfig)
	$mixDataXmlDocConfig.Save($writerConfig)
	$writerConfig.Close()
	Write-Host "*** Done Editing MIXDataSource-1.0.Config File ***"
}