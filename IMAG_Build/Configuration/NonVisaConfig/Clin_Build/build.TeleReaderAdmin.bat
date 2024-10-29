::
:: Number Pattern:  30.(Sequence#).(Patcht#).(Test#)
::
:: Check all inputs before for each build
::
:: Note: Output files: 
::	1. *_TeleReaderConfigurator_Setup.exe
::	2. *_TeleReaderConfigurator_Install.msi
::
 msbuild build.TeleReaderAdmin.proj /fl /flp:logfile=build.TeleReaderAdmin.log /p:SequenceNumber=70 /p:PatchNumber=110 /p:TestNumber=6098 /p:StageToSQA=False /p:CodeBaseDir=E:\Workspace\Patch_All
:msbuild build.TeleReaderAdmin.proj /fl /flp:logfile=build.TeleReaderAdmin.log /p:SequenceNumber=70 /p:PatchNumber=110 /p:TestNumber=6098 /p:StageToSQA=False /p:CodeBaseDir=E:\Workspace\Patch_All /t:TEST
