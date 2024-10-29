# Microsoft Developer Studio Generated NMAKE File, Based on Decompressor.dsp
!IF "$(CFG)" == ""
CFG=Decompressor - Win32 Debug
!MESSAGE No configuration specified. Defaulting to Decompressor - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "Decompressor - Win32 Release" && "$(CFG)" != "Decompressor - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "Decompressor.mak" CFG="Decompressor - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Decompressor - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "Decompressor - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "Decompressor - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\MAG_Decompressor.exe"


CLEAN :
	-@erase "$(INTDIR)\App.obj"
	-@erase "$(INTDIR)\common.obj"
	-@erase "$(INTDIR)\Decompressor.obj"
	-@erase "$(INTDIR)\DelayedDirectoryChangeHandler.obj"
	-@erase "$(INTDIR)\DirectoryChanges.obj"
	-@erase "$(INTDIR)\DWDecomp.obj"
	-@erase "$(INTDIR)\imageIO.obj"
	-@erase "$(INTDIR)\ntserv.obj"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\MAG_Decompressor.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W4 /GX /O2 /D "NDEBUG" /D "WIN32" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\Decompressor.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\Decompressor.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=awj2k.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\MAG_Decompressor.pdb" /machine:I386 /out:"$(OUTDIR)\MAG_Decompressor.exe" 
LINK32_OBJS= \
	"$(INTDIR)\App.obj" \
	"$(INTDIR)\common.obj" \
	"$(INTDIR)\Decompressor.obj" \
	"$(INTDIR)\DelayedDirectoryChangeHandler.obj" \
	"$(INTDIR)\DirectoryChanges.obj" \
	"$(INTDIR)\DWDecomp.obj" \
	"$(INTDIR)\imageIO.obj" \
	"$(INTDIR)\ntserv.obj" \
	"$(INTDIR)\StdAfx.obj"

"$(OUTDIR)\MAG_Decompressor.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "Decompressor - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\DWDecomp.exe"


CLEAN :
	-@erase "$(INTDIR)\App.obj"
	-@erase "$(INTDIR)\common.obj"
	-@erase "$(INTDIR)\Decompressor.obj"
	-@erase "$(INTDIR)\DelayedDirectoryChangeHandler.obj"
	-@erase "$(INTDIR)\DirectoryChanges.obj"
	-@erase "$(INTDIR)\DWDecomp.obj"
	-@erase "$(INTDIR)\imageIO.obj"
	-@erase "$(INTDIR)\ntserv.obj"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\DWDecomp.exe"
	-@erase "$(OUTDIR)\DWDecomp.ilk"
	-@erase "$(OUTDIR)\DWDecomp.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /D "_DEBUG" /D "WIN32" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\Decompressor.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ d /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\Decompressor.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=awj2k.lib /nologo /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\DWDecomp.pdb" /debug /machine:I386 /out:"$(OUTDIR)\DWDecomp.exe" 
LINK32_OBJS= \
	"$(INTDIR)\App.obj" \
	"$(INTDIR)\common.obj" \
	"$(INTDIR)\Decompressor.obj" \
	"$(INTDIR)\DelayedDirectoryChangeHandler.obj" \
	"$(INTDIR)\DirectoryChanges.obj" \
	"$(INTDIR)\DWDecomp.obj" \
	"$(INTDIR)\imageIO.obj" \
	"$(INTDIR)\ntserv.obj" \
	"$(INTDIR)\StdAfx.obj"

"$(OUTDIR)\DWDecomp.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("Decompressor.dep")
!INCLUDE "Decompressor.dep"
!ELSE 
!MESSAGE Warning: cannot find "Decompressor.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "Decompressor - Win32 Release" || "$(CFG)" == "Decompressor - Win32 Debug"
SOURCE=.\App.cpp

"$(INTDIR)\App.obj" : $(SOURCE) "$(INTDIR)"


SOURCE=.\common.cpp

"$(INTDIR)\common.obj" : $(SOURCE) "$(INTDIR)"


SOURCE=.\Decompressor.cpp

"$(INTDIR)\Decompressor.obj" : $(SOURCE) "$(INTDIR)"


SOURCE=.\DelayedDirectoryChangeHandler.cpp

"$(INTDIR)\DelayedDirectoryChangeHandler.obj" : $(SOURCE) "$(INTDIR)"


SOURCE=.\DirectoryChanges.cpp

"$(INTDIR)\DirectoryChanges.obj" : $(SOURCE) "$(INTDIR)"


SOURCE=.\DWDecomp.cpp

"$(INTDIR)\DWDecomp.obj" : $(SOURCE) "$(INTDIR)"


SOURCE=.\imageIO.cpp

"$(INTDIR)\imageIO.obj" : $(SOURCE) "$(INTDIR)"


SOURCE=.\ntserv.cpp

"$(INTDIR)\ntserv.obj" : $(SOURCE) "$(INTDIR)"


SOURCE=.\StdAfx.cpp

"$(INTDIR)\StdAfx.obj" : $(SOURCE) "$(INTDIR)"


SOURCE=.\ntserv_msg.rc

!ENDIF 

