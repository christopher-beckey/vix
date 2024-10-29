::
:: Number Pattern:  30.(Sequence#).(Patcht#).(Test#)
::
:: Check all inputs before for each build
::

 msbuild build.Capture.proj /fl /flp:logfile=build.Capture.log /p:SequenceNumber=75 /p:PatchNumber=140 /p:TestNumber=6095 /p:StageToSQA=False /p:CodeBaseDir=E:\Workspace\Patch_All
:msbuild build.Capture.proj /fl /flp:logfile=build.Capture.log /p:SequenceNumber=75 /p:PatchNumber=140 /p:TestNumber=6095 /p:StageToSQA=False /p:CodeBaseDir=E:\Workspace\Patch_All /t:TEST
