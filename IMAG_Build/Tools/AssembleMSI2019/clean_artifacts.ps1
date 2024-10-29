# obtain full patch version number
$FullPatchNum=$args[0]

#split full patch number into just major match number (ie. 269)
$FullNumSplit = $FullPatchNum.Split(".")
$MajorPatchNum = $FullNumSplit[1]

#extract latest VIX and CVIX build numbers
$versionNumberPath = ".\ij\versions\P" + "$MajorPatchNum" + "_versions.txt"
$file_data = Get-Content $versionNumberPath -Tail 2
$Last_VIX = $file_data.Split("=")[-3]
$Last_CVIX = $file_data.Split("=")[-1]

Write-Host "Last VIX Build Number $Last_VIX"
Write-Host "Last CIX Build Number $Last_CVIX"

#Clean up and delete old ZF ViewerRender zips for build increments (keeps the latest VIX and CVIX build zips)
$zfpayloadpath = ".\ij\artifacts\"

if((Test-Path -path $zfpayloadpath))  
{	
	$lastBuildFilter= @("*$Last_VIX.zip", "*$Last_CVIX.zip")
	
	$priorpayloadZFfiles = Get-ChildItem -Path $zfpayloadpath -recurse -include ViewerRender_30.$MajorPatchNum.*.zip -exclude $lastBuildFilter | Select-Object -ExpandProperty FullName
	
    foreach ($priorpayloadZFfile in $priorpayloadZFfiles)
    { 
        if (Test-Path $priorpayloadZFfile) 
        {
            Remove-Item $priorpayloadZFfile -Force 
            Write-Host "File $priorpayloadZFfile removed"
        }
   }
}