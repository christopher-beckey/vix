::
:: Number Pattern:  30.(Sequence#).(Patcht#).(Test#)
::
:: Check all inputs before for each build
::

 msbuild build.BP.proj /fl /flp:logfile=build.BP.log /p:SequenceNumber=100 /p:PatchNumber=135 /p:TestNumber=6097 /p:StageToSQA=False /p:CodeBaseDir=E:\Workspace\Patch_All
:msbuild build.BP.proj /fl /flp:logfile=build.BP.log /p:SequenceNumber=100 /p:PatchNumber=135 /p:TestNumber=6097 /p:StageToSQA=False /p:CodeBaseDir=E:\Workspace\Patch_All /t:TEST