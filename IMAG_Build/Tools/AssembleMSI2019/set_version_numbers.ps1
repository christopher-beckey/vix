# obtain full patch version number
$FullPatchNum=$args[0]

# obtain role type as CVIX or VIX 
$RoleType=$args[1]

# obtain if .NET Release or Debug build
$BuildType=$args[2]

#split full patch number into just major match number (ie. 269)
$FullNumSplit = $FullPatchNum.Split(".")
$MajorPatchNum = $FullNumSplit[1]
$TestReleaseNum = $FullNumSplit[2]
$VersionNum = $FullNumSplit[3]

#location of the build manifest file for the patch specified
$pathBuildManifest = ".\ic\IMAG_Build\Configuration\VisaBuildConfiguration\VixBuildManifestPatch$MajorPatchNum$RoleType.xml"
[xml]$pathBuildManifestXMLDoc = Get-Content -Path $pathBuildManifest		
$oldBuildPatchNumberElement = $pathBuildManifestXMLDoc.SelectSingleNode('/Build/Patch') 
$oldBuildPatchNumberElement.SetAttribute("number","$FullPatchNum")
$MSIPatchNumberElement = $oldBuildPatchNumberElement.GetAttribute("msiName")
$MSIPatchNumberSplit = $MSIPatchNumberElement.Split("T")
$MSIPatchFirst = $MSIPatchNumberSplit[0]
$MSIPatchSecond = $MSIPatchNumberSplit[1]
$MSIPatchSecondOne = $MSIPatchSecond.substring(1)
$MSIPatchThird = $MSIPatchNumberSplit[2]
$MSIT="T"
$oldBuildPatchNumberElement.SetAttribute("msiName","$MSIPatchFirst$MSIT$TestReleaseNum$MSIPatchSecondOne$MSIT$MSIPatchThird")
$MSIPatchNumberElementNew = $oldBuildPatchNumberElement.GetAttribute("msiName")
$pathBuildManifestXMLDoc.Save($pathBuildManifest)

#add MSI filename to env.properties file
"msiname=$MSIPatchNumberElementNew" | Out-File env.properties -Encoding ASCII

#location of the deploy manifest file for the patch specified
$pathDeployManifest = ".\ic\IMAG_Build\Configuration\VisaBuildConfiguration\VixManifestPatch$MajorPatchNum$RoleType.xml"
[xml]$pathDeployManifestXMLDoc = Get-Content -Path $pathDeployManifest		
$oldDeployPatchNumberElement = $pathDeployManifestXMLDoc.SelectSingleNode('/VixManifest/Patch') 
$oldDeployPatchNumberElement.SetAttribute("number","$FullPatchNum")
$oldZFViewerRenderZipElement1 = $pathDeployManifestXMLDoc.SelectSingleNode('/VixManifest/Prerequisites/Prerequisite[@name="Viewer Services"]') 
$oldZFViewerRenderZipElement1.SetAttribute("version","$FullPatchNum")	
$oldZFViewerRenderZipElement2 = $pathDeployManifestXMLDoc.SelectSingleNode('/VixManifest/Prerequisites/Prerequisite[@option="Active"]/ZFV') 
$oldZFViewerRenderZipElement2.InnerText="ViewerRender_$FullPatchNum.zip"
$pathDeployManifestXMLDoc.Save($pathDeployManifest)

#Update vdproj file to have the current version information for the patch (replaces prior portion of step 'buildMSI' in VixBuilder)
$vdprojFile = ".\ic\IMAG_Source\VISA\DotNet\VixInstallerSolution2019\VixInstallerSetup\VixInstallerSetup.vdproj"
$contentvdproj = Get-Content -Path $vdprojFile
$roleTypeCased = (Get-Culture).TextInfo.ToTitleCase($RoleType.ToLower())
$installerBasicText = "Installer"
$contentvdproj[370] = "            ""AssemblyAsmDisplayName"" = ""8:VixInstallerBusiness, Version=$FullPatchNum, Culture=neutral, processorArchitecture=MSIL"""
$contentvdproj[452] = "            ""AssemblyAsmDisplayName"" = ""8:Vix.Viewer.Install, Version=$FullPatchNum, Culture=neutral, processorArchitecture=MSIL"""
$contentvdproj[487] = "            ""DefaultLocation"" = ""8:[ProgramFilesFolder]\\Vista\\Imaging\\$roleTypeCased$installerBasicText"""
$contentvdproj[556]="        ""ProductName"" = ""8:$RoleType Service Installation Wizard $FullPatchNum"""
$newGuid1 = '{'+[System.guid]::NewGuid().ToString().ToUpper()+'}'
$contentvdproj[557]="        ""ProductCode"" = ""8:$newGuid1"""
$newGuid2 = '{'+[System.guid]::NewGuid().ToString().ToUpper()+'}'
$contentvdproj[558]="        ""PackageCode"" = ""8:$newGuid2"""
$installerWizardText= "Service Installation Wizard"
$contentvdproj[569]="        ""Title"" = ""8:$RoleType $installerWizardText Setup""";
$contentvdproj[680]="            ""Name"" = ""8:$RoleType $installerWizardText"""
$contentvdproj[694]="            ""Name"" = ""8:$RoleType $installerWizardText"""
$contentvdproj[912]="                            ""Value"" = ""8:To run the $RoleType $installerWizardText, follow the instructions in the Installation Guide."""
$contentvdproj | Set-Content -Path $vdprojFile

#Clean up and delete ZF ViewerRender zips for build increments
$zfpayloadpath = ".\ic\IMAG_$RoleType\common\ZFViewerServices"

if((Test-Path -path $zfpayloadpath))  
{
    $priorpayloadZFfiles = Get-ChildItem $zfpayloadpath ViewerRender_30.$MajorPatchNum.*.zip | Select-Object -ExpandProperty FullName
    foreach ($priorpayloadZFfile in $priorpayloadZFfiles)
    { 
        if (Test-Path $priorpayloadZFfile) 
        {
            Remove-Item $priorpayloadZFfile -Force 
            Write-Host "file $priorpayloadZFfile deleted"
        }
   }
}

#Update version number text file
$VersionNumInt= [int]$VersionNum
$VersionNumInc=$VersionNumInt + 1

$versionNumberPath = ".\ij\versions\P" + "$MajorPatchNum" + "_versions.txt"
$contentversionTxt = Get-Content -Path $versionNumberPath
$contentversionTxt[2] = "TEST_RELEASE=$TestReleaseNum"
$contentversionTxt[3] = "BUILD_VERSION=$VersionNumInc"
$contentversionTxt[4] = "BUILD_TYPE=$RoleType"

if($RoleType -ne "CVIX")  {
	$contentversionTxt[5] = "LAST_VIX=$VersionNumInt"
}
else {
	$contentversionTxt[6] = "LAST_CVIX=$VersionNumInt"
}

$contentversionTxt | Set-Content -Path $versionNumberPath