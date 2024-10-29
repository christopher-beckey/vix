# Microsoft Developer Studio Generated NMAKE File, Based on Compressor.dsp
!IF "$(CFG)" == ""
CFG=Compressor - Win32 Release
!MESSAGE No configuration specified. Defaulting to Compressor - Win32 Release.
!ENDIF 

!IF "$(CFG)" != "Compressor - Win32 Release" && "$(CFG)" != "Compressor - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "Compressor.mak" CFG="Compressor - Win32 Release"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Compressor - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "Compressor - Win32 Debug" (based on "Win32 (x86) Console Application")
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

!IF  "$(CFG)" == "Compressor - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\MAG_Compressor.exe" "$(OUTDIR)\Compressor.bsc"


CLEAN :
	-@erase "$(INTDIR)\Compressor.obj"
	-@erase "$(INTDIR)\Compressor.sbr"
	-@erase "$(INTDIR)\driver.obj"
	-@erase "$(INTDIR)\driver.sbr"
	-@erase "$(INTDIR)\ImageIO.obj"
	-@erase "$(INTDIR)\ImageIO.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\Version.res"
	-@erase "$(OUTDIR)\Compressor.bsc"
	-@erase "$(OUTDIR)\MAG_Compressor.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /ML /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\Compressor.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\Version.res" /d "NDEBUG" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\Compressor.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\Compressor.sbr" \
	"$(INTDIR)\driver.sbr" \
	"$(INTDIR)\ImageIO.sbr"

"$(OUTDIR)\Compressor.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib awj2k.lib /nologo /subsystem:console /incremental:no /pdb:"$(OUTDIR)\MAG_Compressor.pdb" /machine:I386 /out:"$(OUTDIR)\MAG_Compressor.exe" 
LINK32_OBJS= \
	"$(INTDIR)\Compressor.obj" \
	"$(INTDIR)\driver.obj" \
	"$(INTDIR)\ImageIO.obj" \
	"$(INTDIR)\Version.res"

"$(OUTDIR)\MAG_Compressor.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "Compressor - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\Compressor.exe" "$(OUTDIR)\Compressor.bsc"


CLEAN :
	-@erase "$(INTDIR)\Compressor.obj"
	-@erase "$(INTDIR)\Compressor.sbr"
	-@erase "$(INTDIR)\driver.obj"
	-@erase "$(INTDIR)\driver.sbr"
	-@erase "$(INTDIR)\ImageIO.obj"
	-@erase "$(INTDIR)\ImageIO.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(INTDIR)\Version.res"
	-@erase "$(OUTDIR)\Compressor.bsc"
	-@erase "$(OUTDIR)\Compressor.exe"
	-@erase "$(OUTDIR)\Compressor.ilk"
	-@erase "$(OUTDIR)\Compressor.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /ML /W3 /Gm /GX /ZI /Od /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\Compressor.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\Version.res" /d "_DEBUG" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\Compressor.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\Compressor.sbr" \
	"$(INTDIR)\driver.sbr" \
	"$(INTDIR)\ImageIO.sbr"

"$(OUTDIR)\Compressor.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=awj2k.lib /nologo /subsystem:console /incremental:yes /pdb:"$(OUTDIR)\Compressor.pdb" /debug /machine:I386 /out:"$(OUTDIR)\Compressor.exe" /pdbtype:sept 
LINK32_OBJS= \
	"$(INTDIR)\Compressor.obj" \
	"$(INTDIR)\driver.obj" \
	"$(INTDIR)\ImageIO.obj" \
	"$(INTDIR)\Version.res"

"$(OUTDIR)\Compressor.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
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
!IF EXISTS("Compressor.dep")
!INCLUDE "Compressor.dep"
!ELSE 
!MESSAGE Warning: cannot find "Compressor.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "Compressor - Win32 Release" || "$(CFG)" == "Compressor - Win32 Debug"
SOURCE=.\Compressor.cpp

"$(INTDIR)\Compressor.obj"	"$(INTDIR)\Compressor.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\driver.cpp

"$(INTDIR)\driver.obj"	"$(INTDIR)\driver.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\ImageIO.cpp

"$(INTDIR)\ImageIO.obj"	"$(INTDIR)\ImageIO.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\Version.rc

"$(INTDIR)\Version.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)



!ENDIF 

