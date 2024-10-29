::
:: Number Pattern:  30.(Patch#).(Test#).(Build#)
::
::
:: Check all inputs for each build
::
::
::msbuild buildVisaComponent.proj /fl /flp:logfile=build.HDIG.log /p:ProductType=HDIG /p:PatchNumber=160 /p:TestNumber=6996 /p:BuildNumber=6996 /p:CodeBaseDir=E:\Tools\Workspace\VisaBuild /p:BuildJava=False /p:StageToSQA=True
::msbuild buildVisaComponent.proj /fl /flp:logfile=build.HDIG.log /p:ProductType=HDIG /p:PatchNumber=157 /p:TestNumber=6994 /p:BuildNumber=6994 /p:CodeBaseDir=E:\Tools\Workspace\VisaBuild /p:BuildJava=False /p:StageToSQA=True
::msbuild buildVisaComponent.proj /fl /flp:logfile=build.VIX.log /p:ProductType=VIX /p:PatchNumber=157 /p:TestNumber=6995 /p:BuildNumber=6995 /p:CodeBaseDir=E:\Tools\Workspace\VisaBuild /p:BuildJava=False /p:StageToSQA=True

::msbuild buildVisaComponent.proj /fl /flp:logfile=build.VIX.log  /p:ProductType=VIX  /p:PatchNumber=157 /p:TestNumber=6995 /p:BuildNumber=6995 /p:BuildJava=True /p:StageToSQA=False /p:CodeBaseDir=E:\Workspace\Patch_All
::msbuild buildVisaComponent.proj /fl /flp:logfile=build.HDIG.log /p:ProductType=HDIG /p:PatchNumber=160 /p:TestNumber=6996 /p:BuildNumber=6996 /p:BuildJava=True /p:StageToSQA=False /p:CodeBaseDir=E:\Workspace\Patch_All  /t:CleanPreviousJavaBuild


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: HDIG Section:
::===============
::msbuild buildVisaComponent.proj /fl /flp:logfile=build.HDIG.log /p:ProductType=HDIG /p:PatchNumber=160 /p:TestNumber=6994 /p:BuildNumber=6994 /p:BuildJava=True /p:StageToSQA=False /p:CodeBaseDir=E:\Workspace\Patch_All  
::::: 12/3/2015
::msbuild buildVisaComponent.proj /fl /flp:logfile=build.HDIG.log /p:ProductType=HDIG /p:PatchNumber=162 /p:TestNumber=1 /p:BuildNumber=6021 /p:BuildJava=True /p:StageToSQA=True /p:CodeBaseDir=E:\Workspace\Patch162


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: VIX Section:
::===============
::msbuild buildVisaComponent.proj /fl /flp:logfile=build.VIX.log  /p:ProductType=VIX  /p:PatchNumber=157 /p:TestNumber=6996 /p:BuildNumber=6996 /p:BuildJava=True /p:StageToSQA=False /p:CodeBaseDir=E:\Workspace\Patch_All
::::: 12/3/2015
msbuild buildVisaComponent.proj /fl /flp:logfile=build.VIX.log  /p:ProductType=VIX  /p:PatchNumber=162 /p:TestNumber=1 /p:BuildNumber=6022 /p:BuildJava=False /p:StageToSQA=True /p:CodeBaseDir=E:\Workspace\Patch162


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: CVIX Section:
::===============
::msbuild buildVisaComponent.proj /fl /flp:logfile=build.CVIX.log /p:ProductType=CVIX /p:PatchNumber=138 /p:TestNumber=6996 /p:BuildNumber=6996 /p:BuildJava=True /p:StageToSQA=False /p:CodeBaseDir=E:\Workspace\Patch_All
 
 
 