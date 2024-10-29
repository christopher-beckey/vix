::
:: Number Pattern:  30.(Sequence#).(Patcht#).(Test#)
::
:: Check all inputs before for each build
::
:: NOTE: For the VRAD, this is  the way that old script used: 3.0.$(PatchNumber).$(TestNumber); 
::       Thus, trying to use the same. So SequenceNumber is not used (SequenceNumber=00)
::

:msbuild build.VRAD.proj /fl /flp:logfile=build.VRAD.log /p:PatchNumber=158 /p:TestNumber=3 /p:SequenceNumber=6005  /p:CodeBaseDir=E:\BuildsNonVisa
msbuild build.VRAD.proj /fl /flp:logfile=build.VRAD.log /p:PatchNumber=1111 /p:TestNumber=2222 /p:SequenceNumber=3333 /p:CodeBaseDir=E:\Workspace\Patch_All

::----------------------------------------------------
:: 07/01/2015
::msbuild build.VRAD.proj /fl /flp:logfile=build.VRAD.log /p:SequenceNumber=00 /p:PatchNumber=153 /p:TestNumber=1 /p:StageToSQA=True /p:CodeBaseDir=E:\Workspace\Patch_All