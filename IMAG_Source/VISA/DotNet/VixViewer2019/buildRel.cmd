::Developer build for Release config
if exist build\logBAK rmdir /Q /S build\logBAK
if exist build\log (pushd build && rename log logBAK && popd)
if not exist build\log mkdir build\log
call build -d -e dev -v 30.999.9.9999 -c Release -p 1>build\log\buildStdout.txt 2>build\log\buildStderr.txt
dir build\log
findstr "Warning(s)" build\log\*Release.txt && findstr "Error(s)" build\log\*Release.txt && findstr /b "Time Elapsed " build\log\*Release.txt
