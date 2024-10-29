::
:: Number Pattern:  30.(Sequence#).(Patcht#).(Test#)
::
::----------------------------------------------------------------------------------------------------------
:: SPECIAL NOTE: Because Gateway is embedded Build Number inside of M code so need to keep the Build Number;
::               Thus using SequenceNumber as BuildNumber  
::----------------------------------------------------------------------------------------------------------
::
:: Not using SequenceNumber but using BuildNumber
::
:: Check all inputs before for each build
::
:: NOTE: For the Gateway, this is  the way that old script used: 3.0.$(PatchNumber).$(BuildNumber); thus, trying to use the same
::
::
:::msbuild build.Display.proj /fl /flp:logfile=build.Display.log /p:SequenceNumber=79 /p:PatchNumber=149 /p:TestNumber=6098 /p:StageToSQA=False /p:CodeBaseDir=E:\Workspace\NonVisaBld
:::msbuild build.Display.proj /fl /flp:logfile=build.Display.log /p:SequenceNumber=79 /p:PatchNumber=149 /p:TestNumber=6098 /p:StageToSQA=False /p:CodeBaseDir=E:\Workspace\NonVisaBld /t:TEST

:::msbuild build.Gateway.proj /fl /flp:logfile=build.Gateway.log /p:PatchNumber=156 /p:TestNumber=2 /p:BuildNumber=6006 /p:CodeBaseDir=E:\BuildsNonVisa

:msbuild build.Gateway.proj /fl /flp:logfile=build.Gateway.log /p:SequenceNumber=6098 /p:PatchNumber=156 /p:TestNumber=1000 /p:StageToSQA=False /p:CodeBaseDir=E:\Workspace\Patch_All /t:TEST
:msbuild build.Gateway.proj /fl /flp:logfile=build.Gateway.log /p:SequenceNumber=6098 /p:PatchNumber=160 /p:TestNumber=1000  /p:StageToSQA=False /p:CodeBaseDir=E:\Workspace\Patch_All

:: 12/08/2015
msbuild build.Gateway.proj /fl /flp:logfile=build.Gateway.log /p:SequenceNumber=6020 /p:PatchNumber=162 /p:TestNumber=1  /p:StageToSQA=True /p:CodeBaseDir=E:\Workspace\Patch162

