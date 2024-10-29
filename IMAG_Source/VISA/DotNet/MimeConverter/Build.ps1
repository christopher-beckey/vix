Param (
    [Parameter(Position=0, Mandatory=$True)]
    [ValidateNotNullOrEmpty()]
    [string]$password,

    [Parameter(Position=1, Mandatory=$False)]
    [string]$commitId
)

$currentDir = $Global:MyInvocation.MyCommand.Definition | Split-Path -Parent | Resolve-Path;
$logPath = "$currentDir\logs\build.log";
$logErrorPath = "$currentDir\logs\build-error.log";
$shortenPath = "C:\tmp";

'Starting hydra build log' | Tee-Object -FilePath $logPath;
'Starting hydra build error log' | Tee-Object -FilePath $logErrorPath;


function ConsoleAndLog {
  Param(
    [Parameter(Mandatory=$true, Position=0)]
    [String] $message
  );
  Write-Host $message
  $message | Out-File $logPath -Append
}

function ZipFiles($zipfilename, $sourcedir)
{
   Add-Type -Assembly System.IO.Compression.FileSystem
   $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
   [System.IO.Compression.ZipFile]::CreateFromDirectory($sourcedir, $zipfilename, $compressionLevel, $false)
}

function Start-Process-Ex {
    param([string] $FilePath, [string[]] $ArgumentList, [string] $stdOutTempFile)

	$redirectStandardOutput = $false;

	if (!$stdOutTempFile) {
        $redirectStandardOutput = $true;
		$stdOutTempFile = "$shortenPath\$((New-Guid).Guid)"
	}
    $stdErrTempFile = "$shortenPath\$((New-Guid).Guid)"
	
    ConsoleAndLog "Running command $FilePath $ArgumentList Output:[$stdOutTempFile, $stdErrTempFile] ";

    if ($redirectStandardOutput) {
        $cmd = Start-Process -FilePath $FilePath -ArgumentList $ArgumentList -NoNewWindow -Wait -RedirectStandardOutput $stdOutTempFile -RedirectStandardError $stdErrTempFile -PassThru
    } else {
        $cmd = Start-Process -FilePath $FilePath -ArgumentList $ArgumentList -NoNewWindow -Wait -RedirectStandardError $stdErrTempFile -PassThru
    }

	
    $cmdOutput = Get-Content -Path $stdOutTempFile -Raw
    $cmdError = Get-Content -Path $stdErrTempFile -Raw
    if ($cmd.ExitCode -ne 0) {
        if ($cmdError) {
            $cmdError | Out-File $logErrorPath -Append
        }
        if ($cmdOutput) {
            $cmdOutput | Out-File $logPath -Append
        }
    } else {
        if ([string]::IsNullOrEmpty($cmdOutput) -eq $false) {
            $cmdOutput | Out-File $logPath -Append
        }
    }
    Remove-Item -Path $stdOutTempFile, $stdErrTempFile -Force -ErrorAction Ignore

	ConsoleAndLog "Completed running command $FilePath $ArgumentList";

    return $cmd.ExitCode;
}

#function Build-Viewer-Package {

    # create temp folder
#    $now = (Get-Date).tostring("yyyyMMdd-hhmmss");
#    $tmpDir = "$currentDir\tmp\$now";
#    New-Item -ItemType Directory -Path $tmpDir -Force
#    ConsoleAndLog "Created temp folder $tmpDir"

    # copy files to temp folder
    #$files = @{};
    #$files.Add('Vix.Viewer.Package\Patches\*', 'Files\Patches');
    #$files.Add('Vix.Viewer.Package\Scripts\*', 'Files\Scripts');
    #$files.Add('Vix.Viewer.Package\VIX.Config\*', 'Files\VIX.Config');
    #$files.Add('VIX.Viewer.Service\bin\x64\Release\*', 'Files\VIX.Viewer.Service');
    #$files.Add('VIX.Render.Service\bin\x64\Release\*', 'Files\VIX.Render.Service');
    #$files.Add('Vix.Viewer.Install\bin\Release\Vix.Viewer.Install.dll', 'Files\VIX.Installer');

    #$files.getEnumerator() | foreach {
    #    $src = Join-Path -Path $currentDir -ChildPath $_.key;
    #    $dest = Join-Path -Path $tmpDir -ChildPath $_.value;
    #    New-Item $dest -Type Directory
    #    ConsoleAndLog "Copying $src to $dest";
    #    Copy-Item -Path $src -Destination $dest -Recurse -Force;
    #}

    # delete all log files
    #ConsoleAndLog "Deleting log files"
    #Get-ChildItem $tmpDir -include *.log -recurse | foreach ($_) {remove-item $_.fullname}

    # delete all pdb files
    #ConsoleAndLog "Deleting pdb files"
    #Get-ChildItem $tmpDir -include *.pdb -recurse | foreach ($_) {remove-item $_.fullname}

    # delete irrelevant test date files
    #ConsoleAndLog "Deleting Oro.json"
    #Get-ChildItem $tmpDir -include Oro.json -recurse | foreach ($_) {remove-item $_.fullname}

    # change log level to warn
    #ConsoleAndLog "Setting log level to Warn"
    #Get-ChildItem $tmpDir -include Nlog.config,Processor.Nlog.Config,Worker.Nlog.Config -recurse | foreach ($_) { 
    #    Write-Host $_.fullname
    #    $xml = [xml](Get-Content $_.fullname)
    #    $node = $xml.nlog.rules.logger | where {$_.name -eq '*'}
    #    $node.minlevel = 'Warn'
    #    $xml.Save($_.fullname)
    #}

    # get version from dll used by the viewer
    #$VixViewerVersionDll = Get-ChildItem -recurse -Path $tmpDir -Filter "Hydra.Common.dll" | Select-Object -First 1
    #$Assembly = [Reflection.Assembly]::Load([System.IO.File]::ReadAllBytes($VixViewerVersionDll.FullName));
    #$AssemblyName = $Assembly.GetName()
    #$PackageVersion = $AssemblyName.version
    #ConsoleAndLog "Detected package version $PackageVersion"

    # write build info
    #$BuildInfoFile = Get-ChildItem -recurse -Path $tmpDir -Filter "BuildInfo.txt" | Select-Object -First 1
    #ConsoleAndLog "Writing build information $BuildInfoFile"
    #$TimeStamp = Get-Date -format g
    #$BuildInfoContent = [string]::Format("{0}`r`n{1}`r`n{2}", $PackageVersion, $TimeStamp, $commitId)
    #Out-File -FilePath $BuildInfoFile.FullName -InputObject $BuildInfoContent

    #ConsoleAndLog "Creating zip file"
    #$packageFilePath = Join-Path -Path $tmpDir -ChildPath $([string]::Format("Vix.Viewer.Service.{0}{1}.zip", $PackageVersion, $(if ($commitId) {"-$commitId"} else {""})));
    #ZipFiles $packageFilePath (Join-Path -Path $tmpDir -ChildPath 'Files')

    #ConsoleAndLog "Created zip file $packageFilePath"
#}

Remove-Item -Path $logPath, $logErrorPath -Force -ErrorAction Ignore

ConsoleAndLog "Setting up Visual Studio development environment"
Remove-Item -Path "$shortenPath\vcvars.txt" -ErrorAction Ignore
Start-Process-Ex -FilePath 'cmd.exe' -ArgumentList "/C call `"C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\VC\Auxiliary\Build\vcvarsall.bat`" x86_amd64 && set > $shortenPath\vcvars.txt"
if (-not (Test-Path -Path "$shortenPath\vcvars.txt" -PathType leaf)) {
    Write-Host "vcvars.txt not found. Exiting."
    exit 1;
}
Get-Content "$shortenPath\vcvars.txt" | Foreach-Object {
  if ($_ -match "^(.*?)=(.*)$") {
    Set-Content "env:\$($matches[1])" $matches[2]
  }
}

#ConsoleAndLog "Installing Pfx into Visual Studio Key Container for strong naming Vix.Viewer.Install assembly"
#Start-Process-Ex -FilePath '.\prerequisites\SnInstallPfx.exe' -ArgumentList ".\Vix.Viewer.Install\VIXInstall_Builder.pfx",$password

ConsoleAndLog "Restoring Nuget packages"
Start-Process-Ex -FilePath '.nuget\NuGet.exe' -ArgumentList "restore Hydra_VA.sln"

ConsoleAndLog "Building Hydra_VA solution"
$outputFile = "$env:TEMP\$((New-Guid).Guid)"
Start-Process-Ex -FilePath 'devenv.exe' -ArgumentList "Hydra_VA.sln","/Rebuild","`"Release|Mixed Platforms`"","/Out",$outputFile  -stdOutTempFile $outputFile

#ConsoleAndLog "Building viewer package"
#Build-Viewer-Package;

