:::
:: Number Pattern:  30.(Sequence#).(Patcht#).(Test#)
::
:: Check all inputs before for each build
::
:: Note: Output files: 
::	1. *_TeleReader_Setup.exe
::	2. *_TeleReader_Install.msi
::
msbuild build.TeleReader.proj /fl /flp:logfile=build.TeleReader.log /p:SequenceNumber=70 /p:PatchNumber=127 /p:TestNumber=6090 /p:StageToSQA=False /p:CodeBaseDir=E:\Workspace\Patch_All
:msbuild build.TeleReader.proj /fl /flp:logfile=build.TeleReader.log /p:SequenceNumber=70 /p:PatchNumber=127 /p:TestNumber=6090 /p:StageToSQA=False /p:CodeBaseDir=E:\Workspace\Patch_All /t:Compile_TEST
