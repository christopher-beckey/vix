# Microsoft Developer Studio Generated NMAKE File, Based on send_image.dsp
!IF "$(CFG)" == ""
CFG=send_image - Win32 Release
!MESSAGE No configuration specified. Defaulting to send_image - Win32 Release.
!ENDIF 

!IF "$(CFG)" != "send_image - Win32 Release" && "$(CFG)" != "send_image - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "send_image.mak" CFG="send_image - Win32 Release"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "send_image - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "send_image - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "send_image - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\send_image.exe"


CLEAN :
	-@erase "$(INTDIR)\send_image.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\send_image.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MT /W3 /GX /O2 /I "..\..\libwindows" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /Fp"$(INTDIR)\send_image.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\send_image.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=ctnlib.lib wsock32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:no /pdb:"$(OUTDIR)\send_image.pdb" /machine:I386 /out:"$(OUTDIR)\send_image.exe" /libpath:"..\..\libwindows\Release" 
LINK32_OBJS= \
	"$(INTDIR)\send_image.obj"

"$(OUTDIR)\send_image.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "send_image - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\send_image.exe"


CLEAN :
	-@erase "$(INTDIR)\send_image.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\send_image.exe"
	-@erase "$(OUTDIR)\send_image.ilk"
	-@erase "$(OUTDIR)\send_image.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MTd /W3 /Gm /GX /ZI /Od /I "..\..\libwindows" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /Fp"$(INTDIR)\send_image.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\send_image.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=ctnlib.lib wsock32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:yes /pdb:"$(OUTDIR)\send_image.pdb" /debug /machine:I386 /out:"$(OUTDIR)\send_image.exe" /libpath:"..\..\libwindows\debug" 
LINK32_OBJS= \
	"$(INTDIR)\send_image.obj"

"$(OUTDIR)\send_image.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("send_image.dep")
!INCLUDE "send_image.dep"
!ELSE 
!MESSAGE Warning: cannot find "send_image.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "send_image - Win32 Release" || "$(CFG)" == "send_image - Win32 Debug"
SOURCE=send_image.c

"$(INTDIR)\send_image.obj" : $(SOURCE) "$(INTDIR)"



!ENDIF 

