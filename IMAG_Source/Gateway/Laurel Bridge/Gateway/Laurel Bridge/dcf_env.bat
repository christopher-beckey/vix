REM ###
REM ### Create a minimal configuration directory.
REM ###
cd \DCF_RunTime
mkdir tmp
cd tmp
mkdir log
mkdir scp_images
cd ..\cfg
mkdir apps
mkdir apps\defaults
mkdir procs
cd ..
rename *.key systeminfo
copy systeminfo .\cfg
del /F systeminfo


