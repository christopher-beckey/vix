@echo off
::Restore the packages

if exist Hydra.sln goto DoRestore
echo ERROR: To run this script, you must be in the solution's root folder where Hydra.sln resides.
exit /B 1

:DoRestore
echo srcToolsAndTest\MockService\.nuget\nuget.exe restore srcToolsAndTest\MockService\MockService.sln
srcToolsAndTest\MockService\.nuget\nuget.exe restore srcToolsAndTest\MockService\MockService.sln
set result=%ERRORLEVEL%
if %result% EQU 0 goto NextRestore
exit /B %result%

:NextRestore
echo src3rdparty\hydra3rdparty\.nuget\nuget.exe restore src3rdParty\Hydra3rdParty\Hydra3rdParty.csproj -SolutionDirectory .
src3rdparty\hydra3rdparty\.nuget\nuget.exe restore src3rdParty\Hydra3rdParty\Hydra3rdParty.csproj -SolutionDirectory .
set result=%ERRORLEVEL%
if %result% EQU 0 goto DelMockFromRoot
exit /B %result%

:DelMockFromRoot
::If someone mistakenly did a restore on Hydra.sln, the MockService packages also get stored in the
::root\packages folder, so delete them
if exist packages\Antlr.* cscript srcToolsAndTest\Scripts\DelSlnPkgsInMock.vbs //nologo

::Example: where /Q /R "." .signature.p7s && echo found || echo not found
where /Q /R "." .signature.p7s && del .signature.p7s/q/s
