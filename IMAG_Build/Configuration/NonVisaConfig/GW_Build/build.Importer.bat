::
:: Number Pattern:  30.(Sequence#).(Patcht#).(Test#)
::
:: Not using SequenceNumber but using BuildNumber
::
:: Debug option
::msbuild build.Importer.proj /fl /flp:logfile=build.Importer.log /verbosity:diag /p:SequenceNumber=6098 /p:PatchNumber=136 /p:TestNumber=1000 /p:StageToSQA=False /p:CodeBaseDir=E:\Workspace\NonVisaBld

:msbuild build.Importer.proj /fl /flp:logfile=build.Importer.log /p:SequenceNumber=6098 /p:PatchNumber=136 /p:TestNumber=1000 /p:StageToSQA=False /p:CodeBaseDir=E:\Workspace\Patch_All /t:TEST
msbuild build.Importer.proj /fl /flp:logfile=build.Importer.log /p:SequenceNumber=6098 /p:PatchNumber=136 /p:TestNumber=1000 /p:StageToSQA=False /p:CodeBaseDir=E:\Workspace\Patch_All
