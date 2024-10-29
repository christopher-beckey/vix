#Post-Install Script to Remove Previous Patch-specific files and folders, but keep the scripts for the current patch.
#For each new release, simply rename this script. It is dynamic, so no other changes are necessary.

# relaunch as an elevated process if not currently in administrator mode
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    $PSHost = If ($PSVersionTable.PSVersion.Major -gt 5) {'PwSh'} else {'PowerShell'}
    Start-Process $PSHost -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$($PWD.Path)'; & '$PSCommandPath'`"";
    Exit
}

$thisScriptsName = $myInvocation.myCommand.name #Example: pNNN_post_scripts_delete.ps1, where N is a digit
$parts = $thisScriptsName -split "_"
$thisPatchNumberWithP = $parts[0] #pNNN prefix
$scriptspath = "C:\Program Files\VistA\Imaging\Scripts"
$patchScriptsPath = "C:\Program Files\VistA\Imaging\Scripts\p[0-9][0-9][0-9]_*.ps1"
$doNotDeleteThisPatch = "${thisPatchNumberWithP}_*.ps1"
$oldLaurelBridgePath = "C:\DCF_RunTime_x64_3_3_40c"

if(Test-Path -path $scriptspath)
{
    $prevFiles = Get-ChildItem -Path $patchScriptsPath |
        Where-Object { $_.Name -notlike $doNotDeleteThisPatch } |
        Select-Object -ExpandProperty FullName |
        Sort-Object
    foreach ($prevfile in $prevfiles)
    {
        if (Test-Path $prevfile)
        {
            Remove-Item $prevfile -Force
            Write-Output "file $prevfile deleted"
        }
   }
}

if (Test-Path $oldLaurelBridgePath)
{
    Remove-Item -Path $oldLaurelBridgePath -Recurse -Force
    if (Test-Path $oldLaurelBridgePath)
    {
        Write-Output "The folder $oldLaurelBridgePath was not deleted"
    }
    else
    {
		Write-Output "The folder $oldLaurelBridgePath was deleted"
	}
}
else
{
    Write-Output "The folder $oldLaurelBridgePath did not exist"
}

