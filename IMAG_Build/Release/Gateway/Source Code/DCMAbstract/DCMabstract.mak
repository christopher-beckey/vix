# Microsoft Developer Studio Generated NMAKE File, Based on DCMabstract.dsp
!IF "$(CFG)" == ""
CFG=DCMabstract - Win32 Debug
!MESSAGE No configuration specified. Defaulting to DCMabstract - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "DCMabstract - Win32 Release" && "$(CFG)" != "DCMabstract - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "DCMabstract.mak" CFG="DCMabstract - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "DCMabstract - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "DCMabstract - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "DCMabstract - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\DCMabstract.exe"


CLEAN :
	-@erase "$(INTDIR)\DCMabstract.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\Version.res"
	-@erase "$(OUTDIR)\DCMabstract.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /ML /W4 /GX /O2 /Ob0 /D "NDEBUG" /D "WIN32" /D "_CONSOLE" /D "_MBCS" /D "AM_PROGOLD" /D "STRICT" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\Version.res" /d "NDEBUG"

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
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\DCMabstract.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib igcore15d.lib /nologo /subsystem:console /incremental:no /pdb:"$(OUTDIR)\DCMabstract.pdb" /machine:I386 /out:"$(OUTDIR)\DCMabstract.exe" 
LINK32_OBJS= \
	"$(INTDIR)\DCMabstract.obj" \
	"$(INTDIR)\Version.res"

"$(OUTDIR)\DCMabstract.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "DCMabstract - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\DCMabstract.exe"


CLEAN :
	-@erase "$(INTDIR)\DCMabstract.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(INTDIR)\Version.res"
	-@erase "$(OUTDIR)\DCMabstract.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MLd /W4 /GX /ZI /Od /D "_DEBUG" /D "WIN32" /D "_CONSOLE" /D "_MBCS" /D "AM_PROGOLD" /D "STRICT" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\Version.res" /d "_DEBURSG"
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
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\DCMabstract.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=igcore15d.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /profile /debug /machine:I386 /out:"$(OUTDIR)\DCMabstract.exe" 
LINK32_OBJS= \
	"$(INTDIR)\DCMabstract.obj" \
	"$(INTDIR)\Version.res"

"$(OUTDIR)\DCMabstract.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("DCMabstract.dep")
!INCLUDE "DCMabstract.dep"
!ELSE 
!MESSAGE Warning: cannot find "DCMabstract.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "DCMabstract - Win32 Release" || "$(CFG)" == "DCMabstract - Win32 Debug"
SOURCE=.\DCMabstract.cpp

"$(INTDIR)\DCMabstract.obj" : $(SOURCE) "$(INTDIR)"

SOURCE=.\Version.rc

"$(INTDIR)\Version.res" : $(SOURCE) "$(INTDIR)"
        $(RSC) $(RSC_PROJ) $(SOURCE)

!ENDIF 

