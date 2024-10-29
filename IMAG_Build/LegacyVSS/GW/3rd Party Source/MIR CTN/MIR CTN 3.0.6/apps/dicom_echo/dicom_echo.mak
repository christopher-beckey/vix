# Microsoft Developer Studio Generated NMAKE File, Based on dicom_echo.dsp
!IF "$(CFG)" == ""
CFG=dicom_echo - Win32 Release
!MESSAGE No configuration specified. Defaulting to dicom_echo - Win32 Release.
!ENDIF 

!IF "$(CFG)" != "dicom_echo - Win32 Release" && "$(CFG)" != "dicom_echo - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "dicom_echo.mak" CFG="dicom_echo - Win32 Release"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "dicom_echo - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "dicom_echo - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "dicom_echo - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\dicom_echo.exe"


CLEAN :
	-@erase "$(INTDIR)\dicom_echo.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\dicom_echo.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MT /W3 /GX /O2 /I "..\..\libwindows" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /Fp"$(INTDIR)\dicom_echo.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\dicom_echo.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=ctnlib.lib wsock32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:no /pdb:"$(OUTDIR)\dicom_echo.pdb" /machine:I386 /out:"$(OUTDIR)\dicom_echo.exe" /libpath:"..\..\LIBWINDOWS\RELEASE" 
LINK32_OBJS= \
	"$(INTDIR)\dicom_echo.obj"

"$(OUTDIR)\dicom_echo.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "dicom_echo - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\dicom_echo.exe"


CLEAN :
	-@erase "$(INTDIR)\dicom_echo.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\dicom_echo.exe"
	-@erase "$(OUTDIR)\dicom_echo.ilk"
	-@erase "$(OUTDIR)\dicom_echo.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MTd /W3 /Gm /GX /ZI /Od /I "..\..\libwindows" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /Fp"$(INTDIR)\dicom_echo.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\dicom_echo.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=ctnlib.lib wsock32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:yes /pdb:"$(OUTDIR)\dicom_echo.pdb" /debug /machine:I386 /out:"$(OUTDIR)\dicom_echo.exe" /libpath:"..\..\libwindows\debug" 
LINK32_OBJS= \
	"$(INTDIR)\dicom_echo.obj"

"$(OUTDIR)\dicom_echo.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("dicom_echo.dep")
!INCLUDE "dicom_echo.dep"
!ELSE 
!MESSAGE Warning: cannot find "dicom_echo.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "dicom_echo - Win32 Release" || "$(CFG)" == "dicom_echo - Win32 Debug"
SOURCE=.\dicom_echo.c

"$(INTDIR)\dicom_echo.obj" : $(SOURCE) "$(INTDIR)"



!ENDIF 

