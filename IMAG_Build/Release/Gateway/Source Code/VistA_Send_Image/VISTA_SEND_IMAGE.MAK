# Microsoft Developer Studio Generated NMAKE File, Based on VISTA_SEND_IMAGE.DSP
!IF "$(CFG)" == ""
CFG=VISTA_SEND_IMAGE - Win32 Release
!MESSAGE No configuration specified. Defaulting to VISTA_SEND_IMAGE - Win32 Release.
!ENDIF 

!IF "$(CFG)" != "VISTA_SEND_IMAGE - Win32 Release" && "$(CFG)" != "VISTA_SEND_IMAGE - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "VISTA_SEND_IMAGE.MAK" CFG="VISTA_SEND_IMAGE - Win32 Release"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "VISTA_SEND_IMAGE - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "VISTA_SEND_IMAGE - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "VISTA_SEND_IMAGE - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\VISTA_SEND_IMAGE.exe" "$(OUTDIR)\VISTA_SEND_IMAGE.bsc"


CLEAN :
	-@erase "$(INTDIR)\DCM_NETF.OBJ"
	-@erase "$(INTDIR)\DCM_NETF.SBR"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\Version.res"
	-@erase "$(INTDIR)\VISTA_SEND_IMAGE.OBJ"
	-@erase "$(INTDIR)\VISTA_SEND_IMAGE.SBR"
	-@erase "$(OUTDIR)\VISTA_SEND_IMAGE.bsc"
	-@erase "$(OUTDIR)\VISTA_SEND_IMAGE.exe"
	-@erase "$(OUTDIR)\VISTA_SEND_IMAGE.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /ML /W3 /GX /Od /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\VISTA_SEND_IMAGE.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

RSC=rc.exe
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\Version.res" /d "NDEBUG" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\VISTA_SEND_IMAGE.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\DCM_NETF.SBR" \
	"$(INTDIR)\VISTA_SEND_IMAGE.SBR"

"$(OUTDIR)\VISTA_SEND_IMAGE.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib wsock32.lib /nologo /subsystem:console /incremental:no /pdb:"$(OUTDIR)\VISTA_SEND_IMAGE.pdb" /debug /machine:I386 /out:"$(OUTDIR)\VISTA_SEND_IMAGE.exe" 
LINK32_OBJS= \
	"$(INTDIR)\DCM_NETF.OBJ" \
	"$(INTDIR)\VISTA_SEND_IMAGE.OBJ" \
	"$(INTDIR)\Version.res"

"$(OUTDIR)\VISTA_SEND_IMAGE.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "VISTA_SEND_IMAGE - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\VISTA_SEND_IMAGE.exe" "$(OUTDIR)\VISTA_SEND_IMAGE.bsc"


CLEAN :
	-@erase "$(INTDIR)\DCM_NETF.OBJ"
	-@erase "$(INTDIR)\DCM_NETF.SBR"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\Version.res"
	-@erase "$(INTDIR)\VISTA_SEND_IMAGE.OBJ"
	-@erase "$(INTDIR)\VISTA_SEND_IMAGE.SBR"
	-@erase "$(OUTDIR)\VISTA_SEND_IMAGE.bsc"
	-@erase "$(OUTDIR)\VISTA_SEND_IMAGE.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /ML /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\VISTA_SEND_IMAGE.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

RSC=rc.exe
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\Version.res" /d "NDEBUG" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\VISTA_SEND_IMAGE.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\DCM_NETF.SBR" \
	"$(INTDIR)\VISTA_SEND_IMAGE.SBR"

"$(OUTDIR)\VISTA_SEND_IMAGE.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib wsock32.lib /nologo /subsystem:console /incremental:no /pdb:"$(OUTDIR)\VISTA_SEND_IMAGE.pdb" /machine:I386 /out:"$(OUTDIR)\VISTA_SEND_IMAGE.exe" 
LINK32_OBJS= \
	"$(INTDIR)\DCM_NETF.OBJ" \
	"$(INTDIR)\VISTA_SEND_IMAGE.OBJ" \
	"$(INTDIR)\Version.res"

"$(OUTDIR)\VISTA_SEND_IMAGE.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("VISTA_SEND_IMAGE.DEP")
!INCLUDE "VISTA_SEND_IMAGE.DEP"
!ELSE 
!MESSAGE Warning: cannot find "VISTA_SEND_IMAGE.DEP"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "VISTA_SEND_IMAGE - Win32 Release" || "$(CFG)" == "VISTA_SEND_IMAGE - Win32 Debug"
SOURCE=.\DCM_NETF.C

"$(INTDIR)\DCM_NETF.OBJ"	"$(INTDIR)\DCM_NETF.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\VISTA_SEND_IMAGE.C

"$(INTDIR)\VISTA_SEND_IMAGE.OBJ"	"$(INTDIR)\VISTA_SEND_IMAGE.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\Version.rc

"$(INTDIR)\Version.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)



!ENDIF 

