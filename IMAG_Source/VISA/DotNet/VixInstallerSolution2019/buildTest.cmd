@echo off

set thereToBeginWith=No
set vixDist=VixInstallerSetup\VixDistribution.zip
set vixDistPlaceholder=VixInstallerSetup\VixDistributionSeeReadme.zip

if not exist %vixDist% goto CopyFirst
echo %vixDist% already exists, using that one. REMEMBER NOT TO CHECK IT IN.
set thereToBeginWith=Yes
goto Proceed

:CopyFirst
copy %vixDistPlaceholder% %vixDist% >NUL

:Proceed
call clean
call buildOfficial

if "%thereToBeginWith%"=="No" del %vixDist%
