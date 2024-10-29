@echo off

set thisDirWithEndingBackslash=%~dp0
set FullVersionNum=%1
set CURR_YYYY=%date:~10,4%

if NOT "%FullVersionNum%"=="" goto Continue1
echo ERROR: Full version number must be a command-line argument. Abandoning build.
exit /b 1

:Continue1
if not exist build mkdir build

::https://developercommunity.visualstudio.com/t/vs2019-building-vdproj-fails-prebuild-validation-w/715579
pushd C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\IDE\CommonExtensions\Microsoft\VSI\DisableOutOfProcBuild
DisableOutOfProcBuild.exe > %thisDirWithEndingBackslash%build\build.log
popd

cscript CreateAssemblyInfoShared.vbs //nologo SharedAssemblyInfo.cs %FullVersionNum% %CURR_YYYY%

echo. > build\buildPre.log
echo "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\IDE\devenv.com"  /NoSplash /Rebuild "Release|Mixed Platforms" VixInstallerSolution.sln /Project "VIX.Viewer.Install\Vix.Viewer.Install.csproj" /out build\buildPre.log >NUL
"C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\IDE\devenv.com"  /NoSplash /Rebuild "Release|Mixed Platforms" VixInstallerSolution.sln /Project "VIX.Viewer.Install\Vix.Viewer.Install.csproj" /out build\buildPre.log >NUL

findstr " succeeded," build\buildPre.log
