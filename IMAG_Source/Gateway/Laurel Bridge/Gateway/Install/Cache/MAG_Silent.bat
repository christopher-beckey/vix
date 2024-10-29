@echo off
Set action=not specified
if /i "%1" equ "Install" set action=Installation
if /i "%1" equ "Upgrade" set action=Upgrade
if "%action%" equ "not specified" goto :nospec

set MAGcd=%~dp0
set MAGlog=%temp%\MAG_Ins.log
cd %MAGcd%..\..\CacheCD\nt
if exist "%MAGlog%" del "%MAGlog%"
echo %date%, %time% -- Start Cache %action%
if /i "%1" equ "Install" .\setup.exe -s -f1"%MAGcd%FirstCache.iss" -f2"%MAGlog%"
if /i "%1" equ "Upgrade" .\setup.exe -s -f1"%MAGcd%UpdateCache.iss" -f2"%MAGlog%"
set action=
cd %MAGcd%

:loop
Set check=%temp%\MAG_Check.tmp
if exist "%check%" del "%check%"
%MAGcd%locate "ResultCode" "%MAGlog%" >"%check%"

for %%V in ("%check%") do call :check %%~zV
goto :end

:check
if %1 gtr 12 goto :found

echo %date%, %time% -- Still waiting for Cache to be Installed
%MAGcd%sleep 5
goto :loop

:found
echo %date%, %time% -- Installation of Cache is ready
type "%check%"
del "%check%"
rename "%MAGlog%" "MAG_Install.done"
goto :end

:nospec
echo No action specified.
echo Action must be either "Install"
echo                    or "Upgrade"
set action=
goto :end

:end
