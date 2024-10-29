README FILE FOR VIX VIEWER 2019 Hydra3rdParty

Third-party packages used by VixViewer2019. TO DO: Move all third-party packages to packages.config.

MANUALLY DOWNLOADED - See ManualPackages. Unless noted otherwise: Manually unzip and delete what we don't need, but keep the .zip
zlibnet v1.3
  https://github.com/gdalsnes/zlibnet
  This came with zlib32.dll and zlib64.dll, but not zlibnet.dll. 
  Opened zlibnet.sln in VS 2019, and built the Release|x64 version.
  Moved the three DLLs under zlibnet folder, and deleted the other files, but kept the .zip (which has a .chm file for help and other doc)
ICSharpCode 0.86.0.518 is very old and is used by ExcelDataReader, perhaps we can upgrade this?
  https://github.com/icsharpcode/SharpZipLib/releases, simply download the DLL