# Microsoft Developer Studio Generated NMAKE File, Based on dicom.dsp
!IF "$(CFG)" == ""
CFG=dicom - Win32 Debug
!MESSAGE No configuration specified. Defaulting to dicom - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "dicom - Win32 Release" && "$(CFG)" != "dicom - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "dicom.mak" CFG="dicom - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "dicom - Win32 Release" (based on "Win32 (x86) Static Library")
!MESSAGE "dicom - Win32 Debug" (based on "Win32 (x86) Static Library")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "dicom - Win32 Release"

OUTDIR=.\WinRel
INTDIR=.\WinRel
# Begin Custom Macros
OutDir=.\WinRel
# End Custom Macros

ALL : "$(OUTDIR)\dicom.lib" "$(OUTDIR)\dicom.bsc"


CLEAN :
	-@erase "$(INTDIR)\aaac.obj"
	-@erase "$(INTDIR)\aaac.sbr"
	-@erase "$(INTDIR)\aarj.obj"
	-@erase "$(INTDIR)\aarj.sbr"
	-@erase "$(INTDIR)\aarq.obj"
	-@erase "$(INTDIR)\aarq.sbr"
	-@erase "$(INTDIR)\buffer.obj"
	-@erase "$(INTDIR)\buffer.sbr"
	-@erase "$(INTDIR)\deivr.obj"
	-@erase "$(INTDIR)\deivr.sbr"
	-@erase "$(INTDIR)\dimsec.obj"
	-@erase "$(INTDIR)\dimsec.sbr"
	-@erase "$(INTDIR)\dimsen.obj"
	-@erase "$(INTDIR)\dimsen.sbr"
	-@erase "$(INTDIR)\endian.obj"
	-@erase "$(INTDIR)\endian.sbr"
	-@erase "$(INTDIR)\filepdu.obj"
	-@erase "$(INTDIR)\filepdu.sbr"
	-@erase "$(INTDIR)\flpdu.obj"
	-@erase "$(INTDIR)\flpdu.sbr"
	-@erase "$(INTDIR)\pdata.obj"
	-@erase "$(INTDIR)\pdata.sbr"
	-@erase "$(INTDIR)\pdu.obj"
	-@erase "$(INTDIR)\pdu.sbr"
	-@erase "$(INTDIR)\qrsop.obj"
	-@erase "$(INTDIR)\qrsop.sbr"
	-@erase "$(INTDIR)\rtc.obj"
	-@erase "$(INTDIR)\rtc.sbr"
	-@erase "$(INTDIR)\safemem.obj"
	-@erase "$(INTDIR)\safemem.sbr"
	-@erase "$(INTDIR)\socket.obj"
	-@erase "$(INTDIR)\socket.sbr"
	-@erase "$(INTDIR)\storage.obj"
	-@erase "$(INTDIR)\storage.sbr"
	-@erase "$(INTDIR)\trnsyn.obj"
	-@erase "$(INTDIR)\trnsyn.sbr"
	-@erase "$(INTDIR)\uniq.obj"
	-@erase "$(INTDIR)\uniq.sbr"
	-@erase "$(INTDIR)\util.obj"
	-@erase "$(INTDIR)\util.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\verify.obj"
	-@erase "$(INTDIR)\verify.sbr"
	-@erase "$(OUTDIR)\dicom.bsc"
	-@erase "$(OUTDIR)\dicom.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MT /W3 /GX /O2 /D "NDEBUG" /D "WIN32" /D "_WINDOWS" /D "WINDOWS" /D NATIVE_ENDIAN=1 /FR"$(INTDIR)\\" /Fp"$(INTDIR)\dicom.pch" /YX"dicom.hpp" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\dicom.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\aaac.sbr" \
	"$(INTDIR)\aarj.sbr" \
	"$(INTDIR)\aarq.sbr" \
	"$(INTDIR)\buffer.sbr" \
	"$(INTDIR)\deivr.sbr" \
	"$(INTDIR)\dimsec.sbr" \
	"$(INTDIR)\dimsen.sbr" \
	"$(INTDIR)\endian.sbr" \
	"$(INTDIR)\filepdu.sbr" \
	"$(INTDIR)\flpdu.sbr" \
	"$(INTDIR)\pdata.sbr" \
	"$(INTDIR)\pdu.sbr" \
	"$(INTDIR)\qrsop.sbr" \
	"$(INTDIR)\rtc.sbr" \
	"$(INTDIR)\safemem.sbr" \
	"$(INTDIR)\socket.sbr" \
	"$(INTDIR)\storage.sbr" \
	"$(INTDIR)\trnsyn.sbr" \
	"$(INTDIR)\uniq.sbr" \
	"$(INTDIR)\util.sbr" \
	"$(INTDIR)\verify.sbr"

"$(OUTDIR)\dicom.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LIB32=link.exe -lib
LIB32_FLAGS=/nologo /out:"$(OUTDIR)\dicom.lib" 
LIB32_OBJS= \
	"$(INTDIR)\aaac.obj" \
	"$(INTDIR)\aarj.obj" \
	"$(INTDIR)\aarq.obj" \
	"$(INTDIR)\buffer.obj" \
	"$(INTDIR)\deivr.obj" \
	"$(INTDIR)\dimsec.obj" \
	"$(INTDIR)\dimsen.obj" \
	"$(INTDIR)\endian.obj" \
	"$(INTDIR)\filepdu.obj" \
	"$(INTDIR)\flpdu.obj" \
	"$(INTDIR)\pdata.obj" \
	"$(INTDIR)\pdu.obj" \
	"$(INTDIR)\qrsop.obj" \
	"$(INTDIR)\rtc.obj" \
	"$(INTDIR)\safemem.obj" \
	"$(INTDIR)\socket.obj" \
	"$(INTDIR)\storage.obj" \
	"$(INTDIR)\trnsyn.obj" \
	"$(INTDIR)\uniq.obj" \
	"$(INTDIR)\util.obj" \
	"$(INTDIR)\verify.obj"

"$(OUTDIR)\dicom.lib" : "$(OUTDIR)" $(DEF_FILE) $(LIB32_OBJS)
    $(LIB32) @<<
  $(LIB32_FLAGS) $(DEF_FLAGS) $(LIB32_OBJS)
<<

!ELSEIF  "$(CFG)" == "dicom - Win32 Debug"

OUTDIR=.\WinDebug
INTDIR=.\WinDebug
# Begin Custom Macros
OutDir=.\WinDebug
# End Custom Macros

ALL : "$(OUTDIR)\dicom.lib" "$(OUTDIR)\dicom.bsc"


CLEAN :
	-@erase "$(INTDIR)\aaac.obj"
	-@erase "$(INTDIR)\aaac.sbr"
	-@erase "$(INTDIR)\aarj.obj"
	-@erase "$(INTDIR)\aarj.sbr"
	-@erase "$(INTDIR)\aarq.obj"
	-@erase "$(INTDIR)\aarq.sbr"
	-@erase "$(INTDIR)\buffer.obj"
	-@erase "$(INTDIR)\buffer.sbr"
	-@erase "$(INTDIR)\deivr.obj"
	-@erase "$(INTDIR)\deivr.sbr"
	-@erase "$(INTDIR)\dimsec.obj"
	-@erase "$(INTDIR)\dimsec.sbr"
	-@erase "$(INTDIR)\dimsen.obj"
	-@erase "$(INTDIR)\dimsen.sbr"
	-@erase "$(INTDIR)\endian.obj"
	-@erase "$(INTDIR)\endian.sbr"
	-@erase "$(INTDIR)\filepdu.obj"
	-@erase "$(INTDIR)\filepdu.sbr"
	-@erase "$(INTDIR)\flpdu.obj"
	-@erase "$(INTDIR)\flpdu.sbr"
	-@erase "$(INTDIR)\pdata.obj"
	-@erase "$(INTDIR)\pdata.sbr"
	-@erase "$(INTDIR)\pdu.obj"
	-@erase "$(INTDIR)\pdu.sbr"
	-@erase "$(INTDIR)\qrsop.obj"
	-@erase "$(INTDIR)\qrsop.sbr"
	-@erase "$(INTDIR)\rtc.obj"
	-@erase "$(INTDIR)\rtc.sbr"
	-@erase "$(INTDIR)\safemem.obj"
	-@erase "$(INTDIR)\safemem.sbr"
	-@erase "$(INTDIR)\socket.obj"
	-@erase "$(INTDIR)\socket.sbr"
	-@erase "$(INTDIR)\storage.obj"
	-@erase "$(INTDIR)\storage.sbr"
	-@erase "$(INTDIR)\trnsyn.obj"
	-@erase "$(INTDIR)\trnsyn.sbr"
	-@erase "$(INTDIR)\uniq.obj"
	-@erase "$(INTDIR)\uniq.sbr"
	-@erase "$(INTDIR)\util.obj"
	-@erase "$(INTDIR)\util.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(INTDIR)\verify.obj"
	-@erase "$(INTDIR)\verify.sbr"
	-@erase "$(OUTDIR)\dicom.bsc"
	-@erase "$(OUTDIR)\dicom.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MTd /W3 /GX /ZI /Od /D "_DEBUG" /D "WIN32" /D "_WINDOWS" /D "WINDOWS" /D NATIVE_ENDIAN=1 /Fr"$(INTDIR)\\" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\dicom.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\aaac.sbr" \
	"$(INTDIR)\aarj.sbr" \
	"$(INTDIR)\aarq.sbr" \
	"$(INTDIR)\buffer.sbr" \
	"$(INTDIR)\deivr.sbr" \
	"$(INTDIR)\dimsec.sbr" \
	"$(INTDIR)\dimsen.sbr" \
	"$(INTDIR)\endian.sbr" \
	"$(INTDIR)\filepdu.sbr" \
	"$(INTDIR)\flpdu.sbr" \
	"$(INTDIR)\pdata.sbr" \
	"$(INTDIR)\pdu.sbr" \
	"$(INTDIR)\qrsop.sbr" \
	"$(INTDIR)\rtc.sbr" \
	"$(INTDIR)\safemem.sbr" \
	"$(INTDIR)\socket.sbr" \
	"$(INTDIR)\storage.sbr" \
	"$(INTDIR)\trnsyn.sbr" \
	"$(INTDIR)\uniq.sbr" \
	"$(INTDIR)\util.sbr" \
	"$(INTDIR)\verify.sbr"

"$(OUTDIR)\dicom.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LIB32=link.exe -lib
LIB32_FLAGS=/nologo /out:"$(OUTDIR)\dicom.lib" 
LIB32_OBJS= \
	"$(INTDIR)\aaac.obj" \
	"$(INTDIR)\aarj.obj" \
	"$(INTDIR)\aarq.obj" \
	"$(INTDIR)\buffer.obj" \
	"$(INTDIR)\deivr.obj" \
	"$(INTDIR)\dimsec.obj" \
	"$(INTDIR)\dimsen.obj" \
	"$(INTDIR)\endian.obj" \
	"$(INTDIR)\filepdu.obj" \
	"$(INTDIR)\flpdu.obj" \
	"$(INTDIR)\pdata.obj" \
	"$(INTDIR)\pdu.obj" \
	"$(INTDIR)\qrsop.obj" \
	"$(INTDIR)\rtc.obj" \
	"$(INTDIR)\safemem.obj" \
	"$(INTDIR)\socket.obj" \
	"$(INTDIR)\storage.obj" \
	"$(INTDIR)\trnsyn.obj" \
	"$(INTDIR)\uniq.obj" \
	"$(INTDIR)\util.obj" \
	"$(INTDIR)\verify.obj"

"$(OUTDIR)\dicom.lib" : "$(OUTDIR)" $(DEF_FILE) $(LIB32_OBJS)
    $(LIB32) @<<
  $(LIB32_FLAGS) $(DEF_FLAGS) $(LIB32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("dicom.dep")
!INCLUDE "dicom.dep"
!ELSE 
!MESSAGE Warning: cannot find "dicom.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "dicom - Win32 Release" || "$(CFG)" == "dicom - Win32 Debug"
SOURCE=.\aaac.cxx

"$(INTDIR)\aaac.obj"	"$(INTDIR)\aaac.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\aarj.cxx

"$(INTDIR)\aarj.obj"	"$(INTDIR)\aarj.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\aarq.cxx

"$(INTDIR)\aarq.obj"	"$(INTDIR)\aarq.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\buffer.cxx

"$(INTDIR)\buffer.obj"	"$(INTDIR)\buffer.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\deivr.cxx

"$(INTDIR)\deivr.obj"	"$(INTDIR)\deivr.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\dimsec.cxx

"$(INTDIR)\dimsec.obj"	"$(INTDIR)\dimsec.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\dimsen.cpp

"$(INTDIR)\dimsen.obj"	"$(INTDIR)\dimsen.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\endian.cxx

"$(INTDIR)\endian.obj"	"$(INTDIR)\endian.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\filepdu.cxx

"$(INTDIR)\filepdu.obj"	"$(INTDIR)\filepdu.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\flpdu.cxx

"$(INTDIR)\flpdu.obj"	"$(INTDIR)\flpdu.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\pdata.cxx

"$(INTDIR)\pdata.obj"	"$(INTDIR)\pdata.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\pdu.cxx

"$(INTDIR)\pdu.obj"	"$(INTDIR)\pdu.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\qrsop.cxx

"$(INTDIR)\qrsop.obj"	"$(INTDIR)\qrsop.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\rtc.cxx

"$(INTDIR)\rtc.obj"	"$(INTDIR)\rtc.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\safemem.cxx

"$(INTDIR)\safemem.obj"	"$(INTDIR)\safemem.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\socket.cxx

"$(INTDIR)\socket.obj"	"$(INTDIR)\socket.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\storage.cxx

"$(INTDIR)\storage.obj"	"$(INTDIR)\storage.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\trnsyn.cxx

"$(INTDIR)\trnsyn.obj"	"$(INTDIR)\trnsyn.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\uniq.cxx

"$(INTDIR)\uniq.obj"	"$(INTDIR)\uniq.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\util.cxx

"$(INTDIR)\util.obj"	"$(INTDIR)\util.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\verify.cxx

"$(INTDIR)\verify.obj"	"$(INTDIR)\verify.sbr" : $(SOURCE) "$(INTDIR)"



!ENDIF 

