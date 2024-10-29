::
:: Number Pattern:  30.(Sequence#).(Patcht#).(Test#)
::
:: Check all inputs before for each build
::

:msbuild build.Display.proj /fl /flp:logfile=build.Display.log /p:SequenceNumber=79 /p:PatchNumber=149 /p:TestNumber=6098 /p:StageToSQA=False /p:CodeBaseDir=E:\Workspace\NonVisaBld
:msbuild build.Display.proj /fl /flp:logfile=build.Display.log /p:SequenceNumber=79 /p:PatchNumber=149 /p:TestNumber=6098 /p:StageToSQA=False /p:CodeBaseDir=E:\Workspace\NonVisaBld /t:TEST

:: 06/16/2015 - T1
:: 09/02/2015 - T2
msbuild build.Display.proj /fl /flp:logfile=build.Display.log /p:SequenceNumber=85 /p:PatchNumber=161 /p:TestNumber=2 /p:StageToSQA=False /p:CodeBaseDir=E:\Workspace\Patch_All