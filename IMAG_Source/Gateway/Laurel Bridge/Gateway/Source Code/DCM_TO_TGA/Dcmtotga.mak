# Microsoft Developer Studio Generated NMAKE File, Based on Dcmtotga.dsp
!IF "$(CFG)" == ""
CFG=DCMTOTGA - Win32 Debug
!MESSAGE No configuration specified. Defaulting to DCMTOTGA - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "DCMTOTGA - Win32 Release" && "$(CFG)" != "DCMTOTGA - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "Dcmtotga.mak" CFG="DCMTOTGA - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "DCMTOTGA - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "DCMTOTGA - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "DCMTOTGA - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\Dcmtotga.exe"


CLEAN :
	-@erase "$(INTDIR)\DCMTOTGA.OBJ"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\Version.res"
	-@erase "$(OUTDIR)\Dcmtotga.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /ML /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\Dcmtotga.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\Version.res" /d "NDEBUG" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\Dcmtotga.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:no /pdb:"$(OUTDIR)\Dcmtotga.pdb" /machine:I386 /out:"$(OUTDIR)\Dcmtotga.exe" 
LINK32_OBJS= \
	"$(INTDIR)\DCMTOTGA.OBJ" \
	"$(INTDIR)\Version.res"

"$(OUTDIR)\Dcmtotga.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "DCMTOTGA - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\Dcmtotga.exe"


CLEAN :
	-@erase "$(INTDIR)\DCMTOTGA.OBJ"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(INTDIR)\Version.res"
	-@erase "$(OUTDIR)\Dcmtotga.exe"
	-@erase "$(OUTDIR)\Dcmtotga.ilk"
	-@erase "$(OUTDIR)\Dcmtotga.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /MLd /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\Dcmtotga.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\Version.res" /d "_DEBUG" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\Dcmtotga.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:yes /pdb:"$(OUTDIR)\Dcmtotga.pdb" /debug /machine:I386 /out:"$(OUTDIR)\Dcmtotga.exe" /pdbtype:sept 
LINK32_OBJS= \
	"$(INTDIR)\DCMTOTGA.OBJ" \
	"$(INTDIR)\Version.res"

"$(OUTDIR)\Dcmtotga.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 

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


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("Dcmtotga.dep")
!INCLUDE "Dcmtotga.dep"
!ELSE 
!MESSAGE Warning: cannot find "Dcmtotga.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "DCMTOTGA - Win32 Release" || "$(CFG)" == "DCMTOTGA - Win32 Debug"
SOURCE=.\DCMTOTGA.C

"$(INTDIR)\DCMTOTGA.OBJ" : $(SOURCE) "$(INTDIR)"


SOURCE=.\Version.rc

"$(INTDIR)\Version.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)



!ENDIF 

