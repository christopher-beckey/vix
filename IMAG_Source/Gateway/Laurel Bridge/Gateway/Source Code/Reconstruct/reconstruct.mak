# Microsoft Developer Studio Generated NMAKE File, Based on reconstruct.dsp
!IF "$(CFG)" == ""
CFG=reconstruct - Win32 Debug
!MESSAGE No configuration specified. Defaulting to reconstruct - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "reconstruct - Win32 Release" && "$(CFG)" != "reconstruct - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "reconstruct.mak" CFG="reconstruct - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "reconstruct - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "reconstruct - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "reconstruct - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\MAGDrecon.exe" "$(OUTDIR)\reconstruct.pch"


CLEAN :
	-@erase "$(INTDIR)\EnDICOM.obj"
	-@erase "$(INTDIR)\Exception.obj"
	-@erase "$(INTDIR)\LineEntry.obj"
	-@erase "$(INTDIR)\Parser.obj"
	-@erase "$(INTDIR)\PDUServ.obj"
	-@erase "$(INTDIR)\reconstruct.obj"
	-@erase "$(INTDIR)\reconstruct.pch"
	-@erase "$(INTDIR)\Reconstructor.obj"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\Stdout.obj"
	-@erase "$(INTDIR)\TagLine.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\VERSION.res"
	-@erase "$(OUTDIR)\MAGDrecon.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MT /W3 /GX /I "c:\usr\ucdavis\dicom" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /D "WINDOWS" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\VERSION.res" /i "c:\usr\ucdavis\dicom" /d "NDEBUG" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\reconstruct.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=wsock32.lib dicom.lib /nologo /version:1.0 /subsystem:console /pdb:none /machine:I386 /out:"$(OUTDIR)\MAGDrecon.exe" /libpath:"c:\usr\ucdavis\dicom\WinRel" 
LINK32_OBJS= \
	"$(INTDIR)\EnDICOM.obj" \
	"$(INTDIR)\Exception.obj" \
	"$(INTDIR)\LineEntry.obj" \
	"$(INTDIR)\Parser.obj" \
	"$(INTDIR)\PDUServ.obj" \
	"$(INTDIR)\reconstruct.obj" \
	"$(INTDIR)\Reconstructor.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\Stdout.obj" \
	"$(INTDIR)\TagLine.obj" \
	"$(INTDIR)\VERSION.res"

"$(OUTDIR)\MAGDrecon.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "reconstruct - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\MAGDrecon.exe" "$(OUTDIR)\reconstruct.pch" "$(OUTDIR)\reconstruct.bsc"


CLEAN :
	-@erase "$(INTDIR)\EnDICOM.obj"
	-@erase "$(INTDIR)\Exception.obj"
	-@erase "$(INTDIR)\LineEntry.obj"
	-@erase "$(INTDIR)\Parser.obj"
	-@erase "$(INTDIR)\PDUServ.obj"
	-@erase "$(INTDIR)\reconstruct.obj"
	-@erase "$(INTDIR)\reconstruct.pch"
	-@erase "$(INTDIR)\Reconstructor.obj"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\Stdout.obj"
	-@erase "$(INTDIR)\TagLine.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(INTDIR)\VERSION.res"
	-@erase "$(OUTDIR)\MAGDrecon.exe"
	-@erase "$(OUTDIR)\MAGDrecon.ilk"
	-@erase "$(OUTDIR)\MAGDrecon.map"
	-@erase "$(OUTDIR)\MAGDrecon.pdb"
	-@erase "$(OUTDIR)\reconstruct.bsc"
	-@erase "c:\usr\reconstruct\Debug\EnDICOM.sbr"
	-@erase "c:\usr\reconstruct\Debug\Exception.sbr"
	-@erase "c:\usr\reconstruct\Debug\LineEntry.sbr"
	-@erase "c:\usr\reconstruct\Debug\Parser.sbr"
	-@erase "c:\usr\reconstruct\Debug\PDUServ.sbr"
	-@erase "c:\usr\reconstruct\Debug\reconstruct.sbr"
	-@erase "c:\usr\reconstruct\Debug\Reconstructor.sbr"
	-@erase "c:\usr\reconstruct\Debug\StdAfx.sbr"
	-@erase "c:\usr\reconstruct\Debug\Stdout.sbr"
	-@erase "c:\usr\reconstruct\Debug\TagLine.sbr"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MTd /W3 /GX /ZI /Od /I "c:\usr\ucdavis\dicom" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /D "WINDOWS" /FAs /Fa"$(INTDIR)\\" /FR"c:\usr\reconstruct\Debug\\" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\VERSION.res" /i "c:\usr\ucdavis\dicom" /d "_DEBUG" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\reconstruct.bsc" 
BSC32_SBRS= \
	"c:\usr\reconstruct\Debug\EnDICOM.sbr" \
	"c:\usr\reconstruct\Debug\Exception.sbr" \
	"c:\usr\reconstruct\Debug\LineEntry.sbr" \
	"c:\usr\reconstruct\Debug\Parser.sbr" \
	"c:\usr\reconstruct\Debug\PDUServ.sbr" \
	"c:\usr\reconstruct\Debug\reconstruct.sbr" \
	"c:\usr\reconstruct\Debug\Reconstructor.sbr" \
	"c:\usr\reconstruct\Debug\StdAfx.sbr" \
	"c:\usr\reconstruct\Debug\Stdout.sbr" \
	"c:\usr\reconstruct\Debug\TagLine.sbr"

"$(OUTDIR)\reconstruct.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=wsock32.lib dicom.lib /nologo /version:1.0 /subsystem:console /incremental:yes /pdb:"$(OUTDIR)\MAGDrecon.pdb" /map:"$(INTDIR)\MAGDrecon.map" /debug /machine:I386 /out:"$(OUTDIR)\MAGDrecon.exe" /pdbtype:sept /libpath:"c:\usr\ucdavis\dicom\WinDebug" 
LINK32_OBJS= \
	"$(INTDIR)\EnDICOM.obj" \
	"$(INTDIR)\Exception.obj" \
	"$(INTDIR)\LineEntry.obj" \
	"$(INTDIR)\Parser.obj" \
	"$(INTDIR)\PDUServ.obj" \
	"$(INTDIR)\reconstruct.obj" \
	"$(INTDIR)\Reconstructor.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\Stdout.obj" \
	"$(INTDIR)\TagLine.obj" \
	"$(INTDIR)\VERSION.res"

"$(OUTDIR)\MAGDrecon.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("reconstruct.dep")
!INCLUDE "reconstruct.dep"
!ELSE 
!MESSAGE Warning: cannot find "reconstruct.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "reconstruct - Win32 Release" || "$(CFG)" == "reconstruct - Win32 Debug"
SOURCE=.\EnDICOM.cpp

!IF  "$(CFG)" == "reconstruct - Win32 Release"


"$(INTDIR)\EnDICOM.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "reconstruct - Win32 Debug"


"$(INTDIR)\EnDICOM.obj"	"c:\usr\reconstruct\Debug\EnDICOM.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\Exception.cpp

!IF  "$(CFG)" == "reconstruct - Win32 Release"


"$(INTDIR)\Exception.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "reconstruct - Win32 Debug"


"$(INTDIR)\Exception.obj"	"c:\usr\reconstruct\Debug\Exception.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\LineEntry.cpp

!IF  "$(CFG)" == "reconstruct - Win32 Release"


"$(INTDIR)\LineEntry.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "reconstruct - Win32 Debug"


"$(INTDIR)\LineEntry.obj"	"c:\usr\reconstruct\Debug\LineEntry.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\Parser.cpp

!IF  "$(CFG)" == "reconstruct - Win32 Release"


"$(INTDIR)\Parser.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "reconstruct - Win32 Debug"


"$(INTDIR)\Parser.obj"	"c:\usr\reconstruct\Debug\Parser.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\PDUServ.cpp

!IF  "$(CFG)" == "reconstruct - Win32 Release"


"$(INTDIR)\PDUServ.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "reconstruct - Win32 Debug"


"$(INTDIR)\PDUServ.obj"	"c:\usr\reconstruct\Debug\PDUServ.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\reconstruct.cpp

!IF  "$(CFG)" == "reconstruct - Win32 Release"


"$(INTDIR)\reconstruct.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "reconstruct - Win32 Debug"


"$(INTDIR)\reconstruct.obj"	"c:\usr\reconstruct\Debug\reconstruct.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\Reconstructor.cpp

!IF  "$(CFG)" == "reconstruct - Win32 Release"


"$(INTDIR)\Reconstructor.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "reconstruct - Win32 Debug"


"$(INTDIR)\Reconstructor.obj"	"c:\usr\reconstruct\Debug\Reconstructor.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\StdAfx.cpp

!IF  "$(CFG)" == "reconstruct - Win32 Release"

CPP_SWITCHES=/nologo /MT /W3 /GX /I "c:\usr\ucdavis\dicom" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /D "WINDOWS" /Fp"$(INTDIR)\reconstruct.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\reconstruct.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ELSEIF  "$(CFG)" == "reconstruct - Win32 Debug"

CPP_SWITCHES=/nologo /MTd /W3 /GX /ZI /Od /I "c:\usr\ucdavis\dicom" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /D "WINDOWS" /FAs /Fa"$(INTDIR)\\" /FR"c:\usr\reconstruct\Debug\\" /Fp"$(INTDIR)\reconstruct.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

"$(INTDIR)\StdAfx.obj"	"c:\usr\reconstruct\Debug\StdAfx.sbr"	"$(INTDIR)\reconstruct.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ENDIF 

SOURCE=.\Stdout.cpp

!IF  "$(CFG)" == "reconstruct - Win32 Release"


"$(INTDIR)\Stdout.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "reconstruct - Win32 Debug"


"$(INTDIR)\Stdout.obj"	"c:\usr\reconstruct\Debug\Stdout.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\TagLine.cpp

!IF  "$(CFG)" == "reconstruct - Win32 Release"


"$(INTDIR)\TagLine.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "reconstruct - Win32 Debug"


"$(INTDIR)\TagLine.obj"	"c:\usr\reconstruct\Debug\TagLine.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\VERSION.RC

"$(INTDIR)\VERSION.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)



!ENDIF 

