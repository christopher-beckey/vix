# DICOM SCP config update

param
(
    [Parameter(Mandatory=$False, Position=0)][string]$RoleType, # CVIX or VIX
    [Parameter(Mandatory=$False, Position=1)][string]$TestOrProd, # Test or Prod (Test is 1 and Prod is 2)
    [Parameter(Mandatory=$False, Position=2)][string]$AZOneOrTwo # AZ Zone (1 or 2)
)

# relaunch as an elevated process if not currently in administrator mode
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    $PSHost = If ($PSVersionTable.PSVersion.Major -gt 5) {'PwSh'} else {'PowerShell'}
    Start-Process $PSHost -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$($PWD.Path)'; & '$PSCommandPath' $RoleType $TestOrProd $AZOneOrTwo`"";
    Exit 
}

if ($AZOneOrTwo -eq $null)
{
   #default AZ to Zone One if not input as parameter
   $AZOneOrTwo=1
}

# NOTE: This function deletes the file if it already exists but is not set for VistA
function CheckIfAeSetForVistA($aeTitlePath) 
{
    $aetitleHasVistA = 0
    if (!([System.IO.File]::Exists($aeTitlePath)))
    {
        Write-Host "ae_title_mappings file does not exist"
    }
    else
    {
        $aetitleHasVistA = Select-String -Path $aeTitlePath -Pattern "# VistA Imaging map"
        if ($aetitleHasVistA -ne $null)
        {
            Write-Host "ae_title_mappings file for Laurel Bridge already set for VistA Imaging"
            $aetitleHasVistA = 1
        }
        else
        {
            Write-Host "ae_title_mappings file exists, but not set for VistA Imaging"
            Remove-Item -Path $aeTitlePath -Force
        }
    }
    return $aetitleHasVistA
}

# NOTE: This function deletes the file if it already exists but is not set for VistA and Test or Prod
function CheckIfAeSetForTestOrProd($aeTitlePath) 
{
    $aetitleHasTestOrProd = 0
 
    if (!([System.IO.File]::Exists($aeTitlePath)))
    {
        Write-Host "ae_title_mappings file does not exist"
    }
    else
    {  
      if ($TestOrProd -eq 1)
      {
           $aetitleHasTestOrProd = Select-String -Path $aeTitFile -Pattern "# VistA Imaging map", "NILAETEST"
      }
      if ($TestOrProd -eq 2)
      {
           $aetitleHasTestOrProd = Select-String -Path $aeTitFile -Pattern "# VistA Imaging map", "NILAEDARK"
      }
      if ($aetitleHasTestOrProd.Matches.Length -gt "2")
      {
            Write-Host "ae_title_mappings file for Laurel Bridge already set for VistA Imaging and Test or Prod"
            $aetitleHasTestOrProd = 1
      }
      else
      {
            Write-Host "ae_title_mappings file exists, but not set for VistA Imaging and Test or Prod"
            $aetitleHasTestOrProd = 0
            Remove-Item -Path $aeTitlePath -Force
      }   
    }
    return $aetitleHasTestOrProd
}

function UpdateAETitleTestOrProd($aeTitFile) 
{
    #Bring in Laurel Bridge files for DICOM SCP
    if (-Not (($DCF_CFG_Path -ne $null) -and (Test-Path -path $DCF_CFG_Path)))
    {
        Write-Host "Did not find DCF_CFG Path #1 $DCF_CFG_Path"
        Write-Warning "Verify Laurel Bridge is installed #1"
    }
    else 
    {
        if ($RoleType -ne "CVIX") 
        {
            if (-Not (CheckIfAeSetForVistA($aeTitFile)))
            {
                Write-Host "Creating new ae_title_mappings file"
                New-Item "$aeTitFile" -ItemType File -Value "#"
                Add-Content "$aeTitFile"  "`n# VistA Imaging map between an Application Entity Title and a full address"
                Add-Content "$aeTitFile"  "# i.e. host:port:called-ae-title"
                Add-Content "$aeTitFile"  "#"
                Add-Content "$aeTitFile"  "# [ **Insert AE Title the Commercial PACS client is using to communicate with the DICOM SCP** ]"
                Add-Content "$aeTitFile"  "# host = **Insert IP Address for the host for the Commercial PACS client**"
                Add-Content "$aeTitFile"  "# port = **Insert port for the Commercial PACS client where the DICOM SCP is used for the C-STORE operation**"
                Add-Content "$aeTitFile"  "# ae_title = **Insert AE Title the Commercial PACS client is using to communicate with the DICOM SCP**"
                Write-Host "Done creating Laurel Bridge ae_title_mappings file for VIX"
            }
        }
        else
        {
            if (-Not (CheckIfAeSetForTestOrProd($aeTitFile))) 
            {
                if ($TestOrProd -eq 1) 
                {            
                #NOTE: the function call to CheckIfAeSetForTestOrProd can be replaced with CheckIfAeSetForVistA at a later date               
                    Write-Host "Creating new ae_title_mappings file"
                    New-Item "$aeTitFile" -ItemType File -Value "#"
                    Add-Content "$aeTitFile"  "`n# VistA Imaging map between an Application Entity Title and a full address"
                    Add-Content "$aeTitFile"  "# i.e. host:port:called-ae-title"
                    Add-Content "$aeTitFile"  "#"
                    Add-Content "$aeTitFile"  "# [ **Insert AE Title the NilRead client is using to communicate with the DICOM SCP** ]"
                    Add-Content "$aeTitFile"  "# host = **Insert IP Address for the host for the NilRead client**"
                    Add-Content "$aeTitFile"  "# port = **Insert port for the NilRead client where the DICOM SCP is used for the C-STORE operation**"
                    Add-Content "$aeTitFile"  "# ae_title = **Insert AE Title the NilRead client is using to communicate with the DICOM SCP**"
                    Add-Content "$aeTitFile"  "`n[ VAC10APPHIE602 ]"
                    Add-Content "$aeTitFile"  "host = 10.247.210.12"
                    Add-Content "$aeTitFile"  "port = 1104"
                    Add-Content "$aeTitFile"  "ae_title = VAC10APPHIE602"
                    Add-Content "$aeTitFile"  "`n[ NILAETEST ]"
                    Add-Content "$aeTitFile"  "host = 10.247.210.12"
                    Add-Content "$aeTitFile"  "port = 1100"
                    Add-Content "$aeTitFile"  "ae_title = NILAETEST"
                    Add-Content "$aeTitFile"  "`n[ NILVIEWER-D.ECIA.LOCAL ]"
                    Add-Content "$aeTitFile"  "host = 4.14.201.181"
                    Add-Content "$aeTitFile"  "port = 1104"
                    Add-Content "$aeTitFile"  "ae_title = NILVIEWER-D.ECIA.LOCAL"
                    Add-Content "$aeTitFile"  "`n[ NILAEECIA ]"
                    Add-Content "$aeTitFile"  "host = 4.14.201.181"
                    Add-Content "$aeTitFile"  "port = 1100"
                    Add-Content "$aeTitFile"  "ae_title = NILAEECIA"
                    Write-Host "Done creating Laurel Bridge ae_title_mappings file for CVIX (Test)"
                }           
                if ($TestOrProd -eq 2) 
                #NOTE: the function call to CheckIfAeSetForTestOrProd can be replaced with CheckIfAeSetForVistA at a later date
                {
                    if ($AZOneOrTwo -eq 1)
                    {
                        Write-Host "Creating new ae_title_mappings file"
                        New-Item "$aeTitFile" -ItemType File -Value "#"
                        Add-Content "$aeTitFile"  "`n# VistA Imaging map between an Application Entity Title and a full address"
                        Add-Content "$aeTitFile"  "# i.e. host:port:called-ae-title"
                        Add-Content "$aeTitFile"  "#"
                        Add-Content "$aeTitFile"  "# [ **Insert AE Title the NilRead client is using to communicate with the DICOM SCP** ]"
                        Add-Content "$aeTitFile"  "# host = **Insert IP Address for the host for the NilRead client**"
                        Add-Content "$aeTitFile"  "# port = **Insert port for the NilRead client where the DICOM SCP is used for the C-STORE operation**"
                        Add-Content "$aeTitFile"  "# ae_title = **Insert AE Title the NilRead client is using to communicate with the DICOM SCP**"
                        Add-Content "$aeTitFile"  "`n[ SATXDATACENTER ]"
                        Add-Content "$aeTitFile"  "host = 146.73.9.62" 
                        Add-Content "$aeTitFile"  "port = 1104"
                        Add-Content "$aeTitFile"  "ae_title = SATXDATACENTER"                   
                        Add-Content "$aeTitFile"  "`n[ NILAE]"
                        Add-Content "$aeTitFile"  "host = 146.73.9.62"
                        Add-Content "$aeTitFile"  "port = 1100"
                        Add-Content "$aeTitFile"  "ae_title = NILAE"                      
                        Add-Content "$aeTitFile"  "`n[ VAC10APPHIE204]"
                        Add-Content "$aeTitFile"  "host = 10.247.11.12"
                        Add-Content "$aeTitFile"  "port = 1104"
                        Add-Content "$aeTitFile"  "ae_title = VAC10APPHIE204"
                        Add-Content "$aeTitFile"  "`n[ NILAEDARK ]"
                        Add-Content "$aeTitFile"  "host = 10.247.11.12"
                        Add-Content "$aeTitFile"  "port = 1100"
                        Add-Content "$aeTitFile"  "ae_title = NILAEDARK"
                        Add-Content "$aeTitFile"  "`n[ VAC10CVXHIE215]"
                        Add-Content "$aeTitFile"  "host = 10.247.10.215"
                        Add-Content "$aeTitFile"  "port = 2761"
                        Add-Content "$aeTitFile"  "ae_title = VAC10CVXHIE215"
                    }
                    
                    if ($AZOneOrTwo -eq 2)
                    {
                        Write-Host "Creating new ae_title_mappings file"
                        New-Item "$aeTitFile" -ItemType File -Value "#"
                        Add-Content "$aeTitFile"  "`n# VistA Imaging map between an Application Entity Title and a full address"
                        Add-Content "$aeTitFile"  "# i.e. host:port:called-ae-title"
                        Add-Content "$aeTitFile"  "#"
                        Add-Content "$aeTitFile"  "# [ **Insert AE Title the NilRead client is using to communicate with the DICOM SCP** ]"
                        Add-Content "$aeTitFile"  "# host = **Insert IP Address for the host for the NilRead client**"
                        Add-Content "$aeTitFile"  "# port = **Insert port for the NilRead client where the DICOM SCP is used for the C-STORE operation**"
                        Add-Content "$aeTitFile"  "# ae_title = **Insert AE Title the NilRead client is using to communicate with the DICOM SCP**" 
                        Add-Content "$aeTitFile"  "`n[ ACUODATACENTER ]"
                        Add-Content "$aeTitFile"  "host = 146.73.9.71"
                        Add-Content "$aeTitFile"  "port = 1104"
                        Add-Content "$aeTitFile"  "ae_title = ACUODATACENTER"                   
                        Add-Content "$aeTitFile"  "`n[ NILAE]"
                        Add-Content "$aeTitFile"  "host = 146.73.9.71"
                        Add-Content "$aeTitFile"  "port = 1104"
                        Add-Content "$aeTitFile"  "ae_title = NILAE"                      
                        Add-Content "$aeTitFile"  "`n[ VAC10APPHIE204]"
                        Add-Content "$aeTitFile"  "host = 10.247.11.12"
                        Add-Content "$aeTitFile"  "port = 1104"
                        Add-Content "$aeTitFile"  "ae_title = VAC10APPHIE204"
                        Add-Content "$aeTitFile"  "`n[ NILAEDARK ]"
                        Add-Content "$aeTitFile"  "host = 10.247.11.12"
                        Add-Content "$aeTitFile"  "port = 1100"
                        Add-Content "$aeTitFile"  "ae_title = NILAEDARK"
                        Add-Content "$aeTitFile"  "`n[ VAC10CVXHIE215]"
                        Add-Content "$aeTitFile"  "host = 10.247.10.215"
                        Add-Content "$aeTitFile"  "port = 2761"
                        Add-Content "$aeTitFile"  "ae_title = VAC10CVXHIE215"                       
                    }
                    
                    Write-Host "Done creating Laurel Bridge ae_title_mappings file for CVIX (Prod)"
                }
            }
        }
    }
}

function UpdateScpConfigCVIXProd([xml] $xmlDocument)
{
    # check ScpConfiguration config file to see if it requires updating/manual user setting in CVIX Production ONLY
    $scpConfigurationaeTitleElement = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.facade.configuration.ScpCallingAE/aeTitle') 
                
    $defaultaeTitleElement = "ALL"
    
    $filledaeTitleElement204 = "VAC10APPHIE204"
    $filledcallingAeIp1112Element204 = "10.247.11.12"	  
    $filledcallingAeIp102220Element204 = "10.247.10.220"	  
    $filledcallingAeIp11220Element204 = "10.247.11.220"	  
    $filledaeTitleElement205 = "VAC10CVXHIE215"
    $filledcallingAeIpElement205 = "10.247.10.215"	

    if ($scpConfigurationaeTitleElement.InnerText.Trim() -NotLike $defaultaeTitleElement) 
    {		
        Write-Host "Prod ScpConfiguration does not have default aeTitle, edit aborted."				 		 								
    }	
    else 
    {	 
        $scpConfigurationScpCallingAE204All = $xmlDocument.SelectNodes('//gov.va.med.imaging.facade.configuration.ScpCallingAE[aeTitle="ALL"]')
        foreach($nodeALL in $scpConfigurationScpCallingAE204All)
        {
            $nodeALL.RemoveAll()
            $nodeALL.ParentNode.RemoveChild($nodeALL) | Out-Null    
        }
        
    
        $scpConfigurationScpCallingAE204All = $xmlDocument.SelectNodes('//gov.va.med.imaging.facade.configuration.ScpCallingAE[aeTitle="VAC10APPHIE204"]')
        foreach($node204 in $scpConfigurationScpCallingAE204All)
        {
            $node204.RemoveAll()
            $node204.ParentNode.RemoveChild($node204) | Out-Null    
        }
        
        $scpConfigurationScpCallingAE205All = $xmlDocument.SelectNodes('//gov.va.med.imaging.facade.configuration.ScpCallingAE[aeTitle="VAC10APPHIE205"]')
        foreach($node205 in $scpConfigurationScpCallingAE205All)
        {
            $node205.RemoveAll()
            $node205.ParentNode.RemoveChild($node205) | Out-Null    
        }      
           
        $scpConfigurationScpCallingAEElement = $xmlDocument.SelectSingleNode('//callingAEConfigs')
        
        #set VAC10CVXHIE204 - 10.247.11.12 IP
        $childScpCallingAE = $xmlDocument.CreateElement("gov.va.med.imaging.facade.configuration.ScpCallingAE")
        $childScpCallingAE.InnerText = ""
        $scpConfigurationScpCallingAEElement.AppendChild($childScpCallingAE) | Out-Null
        
        $scpConfigurationaeTitleElementTwo = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.facade.configuration.ScpCallingAE[last()]')
        
        $childaeTitle = $xmlDocument.CreateElement("aeTitle")
        $childaeTitle.InnerText = $filledaeTitleElement204
        $scpConfigurationaeTitleElementTwo.AppendChild($childaeTitle) | Out-Null
        
        $childcallingAeIp = $xmlDocument.CreateElement("callingAeIp")
        $childcallingAeIp.InnerText = $filledcallingAeIp1112Element204
        $scpConfigurationaeTitleElementTwo.AppendChild($childcallingAeIp) | Out-Null
        
        $childbuildSCReport = $xmlDocument.CreateElement("buildSCReport")
        $childbuildSCReport.InnerText = "true"
        $scpConfigurationaeTitleElementTwo.AppendChild($childbuildSCReport) | Out-Null

        $childreturnQueryLevel = $xmlDocument.CreateElement("returnQueryLevel")
        $childreturnQueryLevel.InnerText = "false"
        $scpConfigurationaeTitleElementTwo.AppendChild($childreturnQueryLevel) | Out-Null
        
        $childstudyQueryFilter = $xmlDocument.CreateElement("studyQueryFilter")
        $childstudyQueryFilter.InnerText = "all"
        $scpConfigurationaeTitleElementTwo.AppendChild($childstudyQueryFilter) | Out-Null

        $childmodalityBlockList = $xmlDocument.CreateElement("modalityBlockList")
        $childmodalityBlockList.InnerText = ""
        $scpConfigurationaeTitleElementTwo.AppendChild($childmodalityBlockList) | Out-Null
        
        $scpConfigurationmodalityBlockListElementTwo = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.facade.configuration.ScpCallingAE[last()]/modalityBlockList')
        
        $childScpModalityList = $xmlDocument.CreateElement("gov.va.med.imaging.facade.configuration.ScpModalityList")
        $childScpModalityList.InnerText = ""
        $scpConfigurationmodalityBlockListElementTwo.AppendChild($childScpModalityList) | Out-Null
        
        $scpConfigurationScpModalityListElementTwo = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.facade.configuration.ScpCallingAE[last()]/modalityBlockList/gov.va.med.imaging.facade.configuration.ScpModalityList')
        
        $childdataSource = $xmlDocument.CreateElement("dataSource")
        $childdataSource.InnerText = "ALL"
        $scpConfigurationScpModalityListElementTwo.AppendChild($childdataSource) | Out-Null
        
        $childaddImageLevelFilter = $xmlDocument.CreateElement("addImageLevelFilter")
        $childaddImageLevelFilter.InnerText = "false"
        $scpConfigurationScpModalityListElementTwo.AppendChild($childaddImageLevelFilter) | Out-Null
        
        $childmodalities = $xmlDocument.CreateElement("modalities")
        $childmodalities.InnerText = ""
        $scpConfigurationScpModalityListElementTwo.AppendChild($childmodalities) | Out-Null
        
        $scpConfigurationScpModalityListmodalitiesElementTwo = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.facade.configuration.ScpCallingAE[last()]/modalityBlockList/gov.va.med.imaging.facade.configuration.ScpModalityList/modalities')

        $childmodalitiesstring = $xmlDocument.CreateElement("string")
        $childmodalitiesstring.InnerText = "none"
        $scpConfigurationScpModalityListmodalitiesElementTwo.AppendChild($childmodalitiesstring) | Out-Null
        
        $childsitecodeBlackList = $xmlDocument.CreateElement("siteCodeBlackList")
        $childsitecodeBlackList.InnerText = ""
        $scpConfigurationaeTitleElementTwo.AppendChild($childsitecodeBlackList) | Out-Null
        
        $scpConfigurationsitecodeBlackListElementTwo = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.facade.configuration.ScpCallingAE[last()]/siteCodeBlackList')
        
        $childsiteCodeString200 = $xmlDocument.CreateElement("string")
        $childsiteCodeString200.InnerText = "200"
        $scpConfigurationsitecodeBlackListElementTwo.AppendChild($childsiteCodeString200) | Out-Null
        
        $childsiteCodeString100 = $xmlDocument.CreateElement("string")
        $childsiteCodeString100.InnerText = "100"
        $scpConfigurationsitecodeBlackListElementTwo.AppendChild($childsiteCodeString100) | Out-Null
        
        $childsiteCodeString200CLMS = $xmlDocument.CreateElement("string")
        $childsiteCodeString200CLMS.InnerText = "200CLMS"
        $scpConfigurationsitecodeBlackListElementTwo.AppendChild($childsiteCodeString200CLMS) | Out-Null
        
        $childsiteCodeString200CORP = $xmlDocument.CreateElement("string")
        $childsiteCodeString200CORP.InnerText = "200CORP"
        $scpConfigurationsitecodeBlackListElementTwo.AppendChild($childsiteCodeString200CORP) | Out-Null
        
        $childsiteCodeString741 = $xmlDocument.CreateElement("string")
        $childsiteCodeString741.InnerText = "741"
        $scpConfigurationsitecodeBlackListElementTwo.AppendChild($childsiteCodeString741) | Out-Null

        #set VAC10CVXHIE204 10.247.10.220
        $childScpCallingAE = $xmlDocument.CreateElement("gov.va.med.imaging.facade.configuration.ScpCallingAE")
        $childScpCallingAE.InnerText = ""
        $scpConfigurationScpCallingAEElement.AppendChild($childScpCallingAE) | Out-Null
        
        $scpConfigurationaeTitleElementTwo = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.facade.configuration.ScpCallingAE[last()]')
        
        $childaeTitle = $xmlDocument.CreateElement("aeTitle")
        $childaeTitle.InnerText = $filledaeTitleElement204
        $scpConfigurationaeTitleElementTwo.AppendChild($childaeTitle) | Out-Null

        $childcallingAeIp = $xmlDocument.CreateElement("callingAeIp")
        $childcallingAeIp.InnerText =  $filledcallingAeIp102220Element204
        $scpConfigurationaeTitleElementTwo.AppendChild($childcallingAeIp) | Out-Null

        $childbuildSCReport = $xmlDocument.CreateElement("buildSCReport")
        $childbuildSCReport.InnerText = "true"
        $scpConfigurationaeTitleElementTwo.AppendChild($childbuildSCReport) | Out-Null

        $childreturnQueryLevel = $xmlDocument.CreateElement("returnQueryLevel")
        $childreturnQueryLevel.InnerText = "false"
        $scpConfigurationaeTitleElementTwo.AppendChild($childreturnQueryLevel) | Out-Null
        
        $childstudyQueryFilter = $xmlDocument.CreateElement("studyQueryFilter")
        $childstudyQueryFilter.InnerText = "all"
        $scpConfigurationaeTitleElementTwo.AppendChild($childstudyQueryFilter) | Out-Null

        $childmodalityBlockList = $xmlDocument.CreateElement("modalityBlockList")
        $childmodalityBlockList.InnerText = ""
        $scpConfigurationaeTitleElementTwo.AppendChild($childmodalityBlockList) | Out-Null

        $scpConfigurationmodalityBlockListElementTwo = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.facade.configuration.ScpCallingAE[last()]/modalityBlockList')

        $childScpModalityList = $xmlDocument.CreateElement("gov.va.med.imaging.facade.configuration.ScpModalityList")
        $childScpModalityList.InnerText = ""
        $scpConfigurationmodalityBlockListElementTwo.AppendChild($childScpModalityList) | Out-Null
        
        $scpConfigurationScpModalityListElementTwo = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.facade.configuration.ScpCallingAE[last()]/modalityBlockList/gov.va.med.imaging.facade.configuration.ScpModalityList')
        
        $childdataSource = $xmlDocument.CreateElement("dataSource")
        $childdataSource.InnerText = "ALL"
        $scpConfigurationScpModalityListElementTwo.AppendChild($childdataSource) | Out-Null
        
        $childaddImageLevelFilter = $xmlDocument.CreateElement("addImageLevelFilter")
        $childaddImageLevelFilter.InnerText = "false"
        $scpConfigurationScpModalityListElementTwo.AppendChild($childaddImageLevelFilter) | Out-Null
        
        $childmodalities = $xmlDocument.CreateElement("modalities")
        $childmodalities.InnerText = ""
        $scpConfigurationScpModalityListElementTwo.AppendChild($childmodalities) | Out-Null
        
        $scpConfigurationScpModalityListmodalitiesElementTwo = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.facade.configuration.ScpCallingAE[last()]/modalityBlockList/gov.va.med.imaging.facade.configuration.ScpModalityList/modalities')

        $childmodalitiesstring = $xmlDocument.CreateElement("string")
        $childmodalitiesstring.InnerText = "none"
        $scpConfigurationScpModalityListmodalitiesElementTwo.AppendChild($childmodalitiesstring) | Out-Null
        
        $childsitecodeBlackList = $xmlDocument.CreateElement("siteCodeBlackList")
        $childsitecodeBlackList.InnerText = ""
        $scpConfigurationaeTitleElementTwo.AppendChild($childsitecodeBlackList) | Out-Null
        
        $scpConfigurationsitecodeBlackListElementTwo = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.facade.configuration.ScpCallingAE[last()]/siteCodeBlackList')
        
        $childsiteCodeString200 = $xmlDocument.CreateElement("string")
        $childsiteCodeString200.InnerText = "200"
        $scpConfigurationsitecodeBlackListElementTwo.AppendChild($childsiteCodeString200) | Out-Null
        
        $childsiteCodeString100 = $xmlDocument.CreateElement("string")
        $childsiteCodeString100.InnerText = "100"
        $scpConfigurationsitecodeBlackListElementTwo.AppendChild($childsiteCodeString100) | Out-Null
        
        $childsiteCodeString200CLMS = $xmlDocument.CreateElement("string")
        $childsiteCodeString200CLMS.InnerText = "200CLMS"
        $scpConfigurationsitecodeBlackListElementTwo.AppendChild($childsiteCodeString200CLMS) | Out-Null
        
        $childsiteCodeString200CORP = $xmlDocument.CreateElement("string")
        $childsiteCodeString200CORP.InnerText = "200CORP"
        $scpConfigurationsitecodeBlackListElementTwo.AppendChild($childsiteCodeString200CORP) | Out-Null
        
        $childsiteCodeString741 = $xmlDocument.CreateElement("string")
        $childsiteCodeString741.InnerText = "741"
        $scpConfigurationsitecodeBlackListElementTwo.AppendChild($childsiteCodeString741) | Out-Null

        #set VAC10CVXHIE204 10.247.11.220
        $childScpCallingAE = $xmlDocument.CreateElement("gov.va.med.imaging.facade.configuration.ScpCallingAE")
        $childScpCallingAE.InnerText = ""
        $scpConfigurationScpCallingAEElement.AppendChild($childScpCallingAE) | Out-Null
        
        $scpConfigurationaeTitleElementTwo = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.facade.configuration.ScpCallingAE[last()]')
        
        $childaeTitle = $xmlDocument.CreateElement("aeTitle")
        $childaeTitle.InnerText = $filledaeTitleElement204
        $scpConfigurationaeTitleElementTwo.AppendChild($childaeTitle) | Out-Null
        
        $childcallingAeIp = $xmlDocument.CreateElement("callingAeIp")
        $childcallingAeIp.InnerText = $filledcallingAeIp11220Element204
        $scpConfigurationaeTitleElementTwo.AppendChild($childcallingAeIp) | Out-Null

        $childbuildSCReport = $xmlDocument.CreateElement("buildSCReport")
        $childbuildSCReport.InnerText = "true"
        $scpConfigurationaeTitleElementTwo.AppendChild($childbuildSCReport) | Out-Null

        $childreturnQueryLevel = $xmlDocument.CreateElement("returnQueryLevel")
        $childreturnQueryLevel.InnerText = "false"
        $scpConfigurationaeTitleElementTwo.AppendChild($childreturnQueryLevel) | Out-Null
        
        $childstudyQueryFilter = $xmlDocument.CreateElement("studyQueryFilter")
        $childstudyQueryFilter.InnerText = "all"
        $scpConfigurationaeTitleElementTwo.AppendChild($childstudyQueryFilter) | Out-Null

        $childmodalityBlockList = $xmlDocument.CreateElement("modalityBlockList")
        $childmodalityBlockList.InnerText = ""
        $scpConfigurationaeTitleElementTwo.AppendChild($childmodalityBlockList) | Out-Null

        $scpConfigurationmodalityBlockListElementTwo = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.facade.configuration.ScpCallingAE[last()]/modalityBlockList')

        $childScpModalityList = $xmlDocument.CreateElement("gov.va.med.imaging.facade.configuration.ScpModalityList")
        $childScpModalityList.InnerText = ""
        $scpConfigurationmodalityBlockListElementTwo.AppendChild($childScpModalityList) | Out-Null
        
        $scpConfigurationScpModalityListElementTwo = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.facade.configuration.ScpCallingAE[last()]/modalityBlockList/gov.va.med.imaging.facade.configuration.ScpModalityList')
        
        $childdataSource = $xmlDocument.CreateElement("dataSource")
        $childdataSource.InnerText = "ALL"
        $scpConfigurationScpModalityListElementTwo.AppendChild($childdataSource) | Out-Null
        
        $childaddImageLevelFilter = $xmlDocument.CreateElement("addImageLevelFilter")
        $childaddImageLevelFilter.InnerText = "false"
        $scpConfigurationScpModalityListElementTwo.AppendChild($childaddImageLevelFilter) | Out-Null
        
        $childmodalities = $xmlDocument.CreateElement("modalities")
        $childmodalities.InnerText = ""
        $scpConfigurationScpModalityListElementTwo.AppendChild($childmodalities) | Out-Null
        
        $scpConfigurationScpModalityListmodalitiesElementTwo = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.facade.configuration.ScpCallingAE[last()]/modalityBlockList/gov.va.med.imaging.facade.configuration.ScpModalityList/modalities')

        $childmodalitiesstring = $xmlDocument.CreateElement("string")
        $childmodalitiesstring.InnerText = "none"
        $scpConfigurationScpModalityListmodalitiesElementTwo.AppendChild($childmodalitiesstring) | Out-Null
        
        $childsitecodeBlackList = $xmlDocument.CreateElement("siteCodeBlackList")
        $childsitecodeBlackList.InnerText = ""
        $scpConfigurationaeTitleElementTwo.AppendChild($childsitecodeBlackList) | Out-Null
        
        $scpConfigurationsitecodeBlackListElementTwo = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.facade.configuration.ScpCallingAE[last()]/siteCodeBlackList')
        
        $childsiteCodeString200 = $xmlDocument.CreateElement("string")
        $childsiteCodeString200.InnerText = "200"
        $scpConfigurationsitecodeBlackListElementTwo.AppendChild($childsiteCodeString200) | Out-Null
        
        $childsiteCodeString100 = $xmlDocument.CreateElement("string")
        $childsiteCodeString100.InnerText = "100"
        $scpConfigurationsitecodeBlackListElementTwo.AppendChild($childsiteCodeString100) | Out-Null
        
        $childsiteCodeString200CLMS = $xmlDocument.CreateElement("string")
        $childsiteCodeString200CLMS.InnerText = "200CLMS"
        $scpConfigurationsitecodeBlackListElementTwo.AppendChild($childsiteCodeString200CLMS) | Out-Null
        
        $childsiteCodeString200CORP = $xmlDocument.CreateElement("string")
        $childsiteCodeString200CORP.InnerText = "200CORP"
        $scpConfigurationsitecodeBlackListElementTwo.AppendChild($childsiteCodeString200CORP) | Out-Null
        
        $childsiteCodeString741 = $xmlDocument.CreateElement("string")
        $childsiteCodeString741.InnerText = "741"
        $scpConfigurationsitecodeBlackListElementTwo.AppendChild($childsiteCodeString741) | Out-Null

        #set VAC10CVXHIE215
        $childScpCallingAE = $xmlDocument.CreateElement("gov.va.med.imaging.facade.configuration.ScpCallingAE")
        $childScpCallingAE.InnerText = ""
        $scpConfigurationScpCallingAEElement.AppendChild($childScpCallingAE) | Out-Null

        $scpConfigurationaeTitleElementTwo = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.facade.configuration.ScpCallingAE[last()]')

        $childaeTitle = $xmlDocument.CreateElement("aeTitle")
        $childaeTitle.InnerText = $filledaeTitleElement205
        $scpConfigurationaeTitleElementTwo.AppendChild($childaeTitle) | Out-Null
        
        $childcallingAeIp = $xmlDocument.CreateElement("callingAeIp")
        $childcallingAeIp.InnerText = $filledcallingAeIpElement205
        $scpConfigurationaeTitleElementTwo.AppendChild($childcallingAeIp) | Out-Null

        $childbuildSCReport = $xmlDocument.CreateElement("buildSCReport")
        $childbuildSCReport.InnerText = "true"
        $scpConfigurationaeTitleElementTwo.AppendChild($childbuildSCReport) | Out-Null

        $childreturnQueryLevel = $xmlDocument.CreateElement("returnQueryLevel")
        $childreturnQueryLevel.InnerText = "false"
        $scpConfigurationaeTitleElementTwo.AppendChild($childreturnQueryLevel) | Out-Null
        
        $childstudyQueryFilter = $xmlDocument.CreateElement("studyQueryFilter")
        $childstudyQueryFilter.InnerText = "all"
        $scpConfigurationaeTitleElementTwo.AppendChild($childstudyQueryFilter) | Out-Null        

        $childmodalityBlockList = $xmlDocument.CreateElement("modalityBlockList")
        $childmodalityBlockList.InnerText = ""
        $scpConfigurationaeTitleElementTwo.AppendChild($childmodalityBlockList) | Out-Null
        
        $scpConfigurationmodalityBlockListElementTwo = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.facade.configuration.ScpCallingAE[last()]/modalityBlockList')
        
        $childScpModalityList = $xmlDocument.CreateElement("gov.va.med.imaging.facade.configuration.ScpModalityList")
        $childScpModalityList.InnerText = ""
        $scpConfigurationmodalityBlockListElementTwo.AppendChild($childScpModalityList) | Out-Null
        
        $scpConfigurationScpModalityListElementTwo = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.facade.configuration.ScpCallingAE[last()]/modalityBlockList/gov.va.med.imaging.facade.configuration.ScpModalityList')
        
        $childdataSource = $xmlDocument.CreateElement("dataSource")
        $childdataSource.InnerText = "ALL"
        $scpConfigurationScpModalityListElementTwo.AppendChild($childdataSource) | Out-Null
        
        $childaddImageLevelFilter = $xmlDocument.CreateElement("addImageLevelFilter")
        $childaddImageLevelFilter.InnerText = "false"
        $scpConfigurationScpModalityListElementTwo.AppendChild($childaddImageLevelFilter) | Out-Null
        
        $childmodalities = $xmlDocument.CreateElement("modalities")
        $childmodalities.InnerText = ""
        $scpConfigurationScpModalityListElementTwo.AppendChild($childmodalities) | Out-Null
        
        $scpConfigurationScpModalityListmodalitiesElementTwo = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.facade.configuration.ScpCallingAE[last()]/modalityBlockList/gov.va.med.imaging.facade.configuration.ScpModalityList/modalities')

        $childmodalitiesstring = $xmlDocument.CreateElement("string")
        $childmodalitiesstring.InnerText = "none"
        $scpConfigurationScpModalityListmodalitiesElementTwo.AppendChild($childmodalitiesstring) | Out-Null
        
        $childsitecodeBlackList = $xmlDocument.CreateElement("siteCodeBlackList")
        $childsitecodeBlackList.InnerText = ""
        $scpConfigurationaeTitleElementTwo.AppendChild($childsitecodeBlackList) | Out-Null
        
        $scpConfigurationsitecodeBlackListElementTwo = $xmlDocument.SelectSingleNode('//gov.va.med.imaging.facade.configuration.ScpCallingAE[last()]/siteCodeBlackList')
        
        $childsiteCodeString200 = $xmlDocument.CreateElement("string")
        $childsiteCodeString200.InnerText = "200"
        $scpConfigurationsitecodeBlackListElementTwo.AppendChild($childsiteCodeString200) | Out-Null
        
        $childsiteCodeString100 = $xmlDocument.CreateElement("string")
        $childsiteCodeString100.InnerText = "100"
        $scpConfigurationsitecodeBlackListElementTwo.AppendChild($childsiteCodeString100) | Out-Null
        
        $childsiteCodeString200CLMS = $xmlDocument.CreateElement("string")
        $childsiteCodeString200CLMS.InnerText = "200CLMS"
        $scpConfigurationsitecodeBlackListElementTwo.AppendChild($childsiteCodeString200CLMS) | Out-Null
        
        $childsiteCodeString200CORP = $xmlDocument.CreateElement("string")
        $childsiteCodeString200CORP.InnerText = "200CORP"
        $scpConfigurationsitecodeBlackListElementTwo.AppendChild($childsiteCodeString200CORP) | Out-Null
        
        $childsiteCodeString741 = $xmlDocument.CreateElement("string")
        $childsiteCodeString741.InnerText = "741"
        $scpConfigurationsitecodeBlackListElementTwo.AppendChild($childsiteCodeString741) | Out-Null

        Write-Host "Prod ScpConfiguration Dark Launch Nil Host not found, edits complete."		                         
    }            
}

function Get-DoDSiteInfo
{   
     # Check site service to see if *fhie.med.va.gov exists under DoD, if it does assume production otherwise assume test
     Write-Output "reading $($siteservice)"

     # Getting site information  
     [xml]$xmlDoc = Get-Content $siteservice

     $xml_VhaSites = $xmlDoc.VhaVisnTable.VhaVisn.VhaSite

     foreach ($site in $xml_VhaSites) 
     {
        $sitename = "$($site.name)"
        $siteid = "$($site.ID)"
        $sitemoniker = "$($site.moniker)"

        if(($sitemoniker -eq "DoD") -or (($siteid -eq "2001") -and ($sitemoniker -eq "CVIX")))
        {
            $fhieVIX =  $site.DataSource | Where{$_.source -like "*fhie.med.va.gov"}
            $DODsitevix = $fhieVIX.source
 
            if ($TestOrProd -ne $null)
            {
                #don't set based on site service if the value for test or prod was entered as an argument
            }
            else
            {
                if ($DODsitevix -ne $null) 
                {
                    $TestOrProd=2;
                    Write-Host "*fhie.med.va.gov found setting to Production"
                }
                else 
                {
                    $TestOrProd=1;
                    Write-Host "*fhie.med.va.gov not found setting to Test"
                }
            }
        }
    }
}

function determineAZZone
{    
    #determine if Amazon Zone (AZ) 1 or 2. AZ 1 uses load balancer of SATX Data Center. AZ 2 uses load balancer of AUCO Data Center.
    
    #determine hostname of the server - used to match if AZ1 or AZ2 for on-prem CVIX production servers
    $hostName = [System.Net.Dns]::GetHostByName($env:computerName).HostName
	
	Write-Host "$hostName"
   
    $prodAITC = @("vaausappcvx200C.aac.dva.va.gov","vaausappcvx201C.aac.dva.va.gov","vaausappcvx202C.aac.dva.va.gov","vaausappcvx203C.aac.dva.va.gov","vaausappcvx204C.aac.dva.va.gov","vaausappcvx205C.aac.dva.va.gov","vaausappcvx206C.aac.dva.va.gov","vaausappcvx207C.aac.dva.va.gov", "vaausappcvx208C.aac.dva.va.gov","vaausappcvx209C.aac.dva.va.gov")
	$prodPITC = @("vaphcappcvx210C.aac.dva.va.gov","vaphcappcvx211C.aac.dva.va.gov","vaphcappcvx212C.aac.dva.va.gov","vaphcappcvx213C.aac.dva.va.gov","vaphcappcvx214C.aac.dva.va.gov","vaphcappcvx215C.aac.dva.va.gov","vaphcappcvx216C.aac.dva.va.gov","vaphcappcvx217C.aac.dva.va.gov")
	$prodDarkLaunch = @("vaphcappcvx218C.aac.dva.va.gov","vaphcappcvx219C.aac.dva.va.gov")
    $prodAZOne= $prodAITC 
    $prodAZTwo= $prodPITC + $prodDarkLaunch
	
	if ($prodAZOne -match "^$hostname")
	{
		$AZOneOrTwo=1
		Write-Host "$hostName matches AZ1 criteria"
	}
	
    if ($prodAZTwo -match "^$hostname")
	{
		$AZOneOrTwo=2
		Write-Host "$hostName matches AZ2 criteria"
	}

    #determine IP of the server - used to match if AZ1 or AZ2 for AWS CVIXproduction servers
	$ipv4 = (Test-Connection -ComputerName $env:ComputerName -Count 1).IPV4Address.IPAddressToString

	Write-Host "$ipv4"	
    	
	$prodAWSAZOne = @("10.247.10.201","10.247.10.202","10.247.10.203","10.247.10.204","10.247.10.205","10.247.10.206","10.247.10.207","10.247.10.208", "10.247.10.209")
    $prodAWSAZTwo = @("10.247.11.201","10.247.11.202","10.247.11.203","10.247.11.204","10.247.11.205","10.247.11.206","10.247.11.207","10.247.11.208", "10.247.11.209")

	if ($prodAWSAZOne -match "^$ipv4")
	{
		$AZOneOrTwo=1
		Write-Host "$hostName matches AZ1 criteria"
	}
	
    if ($prodAWSAZTwo -match "^$ipv4")
	{
		$AZOneOrTwo=2
		Write-Host "$hostName matches AZ2 criteria"
	}
}

$siteservice = "C:\VixConfig\VhaSites.xml"

if (!([System.IO.File]::Exists($siteservice)))
{  
    $siteservice = "C:\SiteService\VhaSites.xml"            
}

# for CVIX 
if (($RoleType -eq "CVIX") -and (Test-Path -path $siteservice)) 
{
    Get-DoDSiteInfo
    if ($TestOrProd -eq 2) 
    {         
        determineAZZone
    }
}

#Bring in Laurel Bridge files for DICOM SCP
$DCF_CFG_Path = [System.Environment]::GetEnvironmentVariable('DCF_CFG')

if($DCF_CFG_Path -eq $null)
{
    $DCF_CFG_Path = "C:\DCF_RunTime_x64\cfg"
    Write-Host "Using $DCF_CFG_Path"
}

$aeTitleFile="$DCF_CFG_Path\dicom\ae_title_mappings"
UpdateAETitleTestOrProd $aeTitleFile

# Pre-populate SCP Config on CVIX if production
$scpConfigFile="C:\VixConfig\ScpConfiguration.config"
$scpXMLFile = [XML](Get-Content $scpConfigFile)
if ($RoleType -eq "CVIX")
{
    if ($TestOrProd -eq 2) 
    {             
        $scpXMLFile = [XML](Get-Content $scpConfigFile)
        UpdateScpConfigCVIXProd $scpXMLFile
        $scpXMLFile.save($scpConfigFile)
    }  
}
 
if(($DCF_CFG_Path -ne $null) -and (Test-Path -path $DCF_CFG_Path))  
{
    $dicomSCPConfigFile="$DCF_CFG_Path\DicomScpConfig"
    if (!([System.IO.File]::Exists($dicomSCPConfigFile))) 
    {
        Copy-Item -Path "C:\Program Files\VistA\Imaging\Scripts\DICOMSCP\DicomScpConfig"  "$dicomSCPConfigFile" 
        Write-Host "Updated DicomScpConfig file for Laurel Bridge"
    }
    else
    {		
		Write-Host "DicomScpConfig file for Laurel Bridge already exists"
				
		$dicomSCPContent =  Get-Content $dicomSCPConfigFile
		
		$dicomSCPConfigPatternDebugOne = Select-String -Path $dicomSCPConfigFile -Pattern "per-instance information for the DCS component"
			
		$dicomSCPConfigPatternDebugTwo = Select-String -Path $dicomSCPConfigFile -Pattern "default name of extended data dictionary configuration group"
	
      for($ii=$dicomSCPConfigPatternDebugOne.LineNumber+1; $ii -lt $dicomSCPConfigPatternDebugTwo.LineNumber-1; $ii++)
       {
            if ($dicomSCPContent[$ii] -match "^debug_flag")
            {
                $dicomSCPContent[$ii]="debug_flags = 0x360040"
                Write-Host "Updated DicomScpConfig file for Laurel Bridge debug_flag."
            }
        }

      # Disable the Patient Level queries in Laurel Bridge so that things renegotiate to Study Level 
      $dicomSCPConfigPatternPatientOne = Select-String -Path $dicomSCPConfigFile -Pattern "UID_SOPPATIENTQUERY_FIND"
			
		  $dicomSCPConfigPatternPatientTwo = Select-String -Path $dicomSCPConfigFile -Pattern "UID_SOPPATIENTQUERY_MOVE"
	
		  for($jj=$dicomSCPConfigPatternPatientOne.LineNumber; $jj -lt $dicomSCPConfigPatternPatientTwo.LineNumber-1; $jj++)
		   {		
			    if ($dicomSCPContent[$jj] -match "^sop_class") 
			    {
				    $dicomSCPContent[$jj]="#sop_class = 1.2.840.10008.5.1.4.1.2.1.1"	
				    Write-Host "Updated DicomScpConfig file for Laurel Bridge Patient Query sop_class."			
			    }				
		   }
        
       $dicomSCPContent | Set-Content -Path $dicomSCPConfigFile	      
    }
}
else
{
    Write-Host "Did not find DCF_CFG Path #2 $DCF_CFG_Path"
    Write-Warning "Verify Laurel Bridge is installed #2"
}