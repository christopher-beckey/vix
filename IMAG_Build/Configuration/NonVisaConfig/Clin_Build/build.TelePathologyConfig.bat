::
:: Number Pattern:  30.(Sequence#).(Patcht#).(Test#)
::
:: Check all inputs before for each build
::

 msbuild build.TelePathologyConfig.proj /fl /flp:logfile=build.TelePathologyConfig.log /p:SequenceNumber=60 /p:PatchNumber=138 /p:TestNumber=6098 /p:StageToSQA=False /p:CodeBaseDir=E:\Workspace\Patch_All
:msbuild build.TelePathologyConfig.proj /fl /flp:logfile=build.TelePathologyConfig.log /p:SequenceNumber=60 /p:PatchNumber=138 /p:TestNumber=6098 /p:StageToSQA=False /p:CodeBaseDir=E:\Workspace\Patch_All /t:TestCompile
