#Post-Install Script to Update Previous config files and LB environment variables with changes for a P348 upgrade.

# relaunch as an elevated process if not currently in administrator mode
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    $PSHost = If ($PSVersionTable.PSVersion.Major -gt 5) {'PwSh'} else {'PowerShell'}
    Start-Process $PSHost -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$($PWD.Path)'; & '$PSCommandPath'`"";
    Exit
}

$VvConfigFilePath='C:\Program Files\VistA\Imaging\VIX.Config\VIX.Viewer.config'
$DicomSCPFilePath='C:\DCF_RunTime_x64\cfg\DicomScpConfig'

function IsExactStringInFile([string] $filePath, [string] $stringToMatch)
{
    $result = "False"
    if (Test-Path -path $filePath)
    {
        $selectedLine = Select-String -Path $filePath -SimpleMatch $stringToMatch
        if ($null -ne $selectedLine)
        {
            $result = "True"
        }
    }
    else
    {
        $result = "Error"
    }
    return $result
}

############################## Add new tool ##############################

function AddJavaVersionTool($filePath, $lineToAdd)
{
    $origLines = Get-Content $filePath
    $lines = @()
    $foundTool = 0

    Foreach ($line in $origLines)
    {
        if (0 -eq $foundTool)
        {
            if ($line.Contains("ssl/JavaLogs.jsp"))
            {
                $foundTool = 1
                $spacesPrefix = $line.split("<")[0]
                $lines += $line
                $lines += $spacesPrefix + $lineToAdd
            }
            else
            {
                $lines += $line
            }
        }
        else
        {
            $lines += $line
        }
    }
    Set-Content $filePath $lines
}

$lineToAdd='<add name="Java Versions|VJ|https://REPLACE-FQDN-RUNTIME:443/Vix/ssl/Versions.jsp" value="CVIX|VIX|SCIP" />'
$msg = "NO (ERROR)"

$myResult = IsExactStringInFile $VvConfigFilePath $lineToAdd
if ($myResult -eq "False")
{
    AddJavaVersionTool $VvConfigFilePath $lineToAdd
    $myResult = IsExactStringInFile $VvConfigFilePath $lineToAdd
}
if ($myResult -eq "True")
{
    $msg = "YES (SUCCESS)"
}
Write-Output "P348: Is 'Java Versions' tool in VIX.Viewer.config? $msg"


############################## Replace UtilPwd ##############################

function ReplaceViewerParameter
{
    Param
    (
         [Parameter(Mandatory=$true)]
         [string] $filePath,
         [Parameter(Mandatory=$true)]
         [string] $nodeName,
         [Parameter(Mandatory=$true)]
         [string] $attributeName,
         [Parameter(Mandatory=$true)]
         [string] $newString
    )
    [xml]$xmlDoc = Get-Content -Path $filePath
    if ($null -ne $xmlDoc)
    {
        $vistaNode = $xmlDoc.SelectSingleNode($nodeName)

        if (Get-Content $($filePath) | Where-Object {$_ -like "*$($attributeName)*"})
        {
            $vistaNode.setAttribute($attributeName, $newString)
            $xmlDoc.Save($filePath)
        }
    }
}

$newString='DEAJpoYRQO3JSDyOO7HXcA=='
$msg = "NO (ERROR)"

$myResult = IsExactStringInFile $VvConfigFilePath $newString
if ($myResult -eq "False")
{
    ReplaceViewerParameter -filePath $VvConfigFilePath -nodeName '//VistA' -attributeName 'UtilPwd' -newString $newString
    $myResult = IsExactStringInFile $VvConfigFilePath $newString
    if ($myResult -eq "True")
    {
        $msg = "YES (SUCCESS)"
    }
}
if ($myResult -eq "True")
{
    $msg = "YES (SUCCESS)"
}
Write-Output "P348: Is new UtilPwd in VIX.Viewer.config? $msg"


############################## Update DicomScpConfig ##############################

function UpdateDicomScpConfig($filePath, $lineFileName)
{
    $origLines = Get-Content $filePath
    $lines = @()
    $foundLine = 0

    Foreach ($line in $origLines)
    {
        if (0 -eq $foundLine)
        {
            if ($line -eq $lineFileName)
            {
                $foundLine = 1
                $lines += 'filename = C:/DCF_RunTime_x64/log/dicomscp.${CNT}.log'
            }
            else
            {
                $lines += $line
            }
        }
        else
        {
            $lines += $line
        }
    }
    Set-Content $filePath $lines
}

$lineFileName='filename = C:\DCF_RunTime_x64\tmp\log\vi_dicom_scp.${CNT}.log'
$msg = "YES (SUCCESS)"

$myResult = IsExactStringInFile $DicomSCPFilePath $lineFileName
if ($myResult -eq "True")
{
    Write-Output "P348: \tmp\log found in DicomScpConfig"
	UpdateDicomScpConfig $DicomSCPFilePath $lineFileName
    $myResult = IsExactStringInFile $VvConfigFilePath $newString
    if ($myResult -ne "True")
    {
        $msg = "No (Error)"
    }
}
else
{
	Write-Output "P348: \tmp\log not found in DicomScpConfig"
}
Write-Output "P348: Is tmp\log not in DicomScpConfig? $msg"


############################## Update Laurel Bridge Environment Variables ##############################

$dcflogEnv = [System.Environment]::GetEnvironmentVariable('DCF_LOG')
if ($dcflogEnv -ne 'C:\DCF_RunTime_x64\log')
{
	Write-Output "P348: Setting DCF_LOG environment variable"
	[System.Environment]::SetEnvironmentVariable('DCF_LOG','C:\DCF_RunTime_x64\log', [System.EnvironmentVariableTarget]::Machine)
}

$omnilibEnv = [System.Environment]::GetEnvironmentVariable('OMNI_LIB')
if ($omnilibEnv -ne 'C:\DCF_RunTime_x64\lib')
{
    Write-Output "P348: Setting OMNI_LIB environment variable"
    [System.Environment]::SetEnvironmentVariable('OMNI_LIB','C:\DCF_RunTime_x64\lib', [System.EnvironmentVariableTarget]::Machine)
}

$dcfplatEnv = [System.Environment]::GetEnvironmentVariable('DCF_PLATFORM')
if ($dcfplatEnv -ne 'Windows_x64_VisualStudio16.x')
{
    Write-Output "P348: Setting DCF_PLATFORM environment variable"
    [System.Environment]::SetEnvironmentVariable('DCF_PLATFORM','Windows_x64_VisualStudio16.x', [System.EnvironmentVariableTarget]::Machine)
}

$dcflibpathEnv = [System.Environment]::GetEnvironmentVariable('LD_LIBRARY_PATH')
if ($dcflibpathEnv -like '*x86_win32*')
{
    Write-Output "P348: Setting LD_LIBRARY_PATH environment variable"
    [System.Environment]::SetEnvironmentVariable('LD_LIBRARY_PATH','C:\DCF_RunTime_x64\lib', [System.EnvironmentVariableTarget]::Machine)
}
