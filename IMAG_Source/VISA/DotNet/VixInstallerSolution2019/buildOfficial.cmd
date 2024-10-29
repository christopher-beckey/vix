@echo off

set thisDirWithEndingBackslash=%~dp0

if not exist build mkdir build

::https://developercommunity.visualstudio.com/t/vs2019-building-vdproj-fails-prebuild-validation-w/715579
pushd C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\IDE\CommonExtensions\Microsoft\VSI\DisableOutOfProcBuild
DisableOutOfProcBuild.exe > %thisDirWithEndingBackslash%build\build.log
popd

echo "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\IDE\devenv.com"  /NoSplash /Rebuild "Release|Mixed Platforms" VixInstallerSolution.sln /out build\build.log >NUL
"C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\IDE\devenv.com"  /NoSplash /Rebuild "Release|Mixed Platforms" VixInstallerSolution.sln /out build\build.log >NUL

findstr " succeeded," build\build.log
