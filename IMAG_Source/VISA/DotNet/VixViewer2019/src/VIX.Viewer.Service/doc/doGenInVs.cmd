::This script is called from Visual Studio
::If we are in the dev environment, this script calls generate.cmd (assuming we have already cd'd to the doc folder)
::If we are in the prod environemnt (the build server), this script does not call generate.cmd, because a build job does
::syntax: goGenInVs.cmd pathToFileContainingTheBuildEnvironment

::Turn on echo so Jenkins can see what's happening
@echo on
if NOT "%1"=="" goto CheckBuildEnv
echo ERROR: Missing command-line argument 
goto :eof

:CheckBuildEnv
set /p BuildEnv=<%SolutionDir%build\PatchEnv.txt
::remove trailing whitepace
set "BuildEnv=%BuildEnv: =%"
echo Build environment is .%BuildEnv%.
if NOT "%BuildEnv%"=="dev" goto DoneRun
echo Generate API doc
cmd /c generate.cmd
:DoneRun
exit /b 0
