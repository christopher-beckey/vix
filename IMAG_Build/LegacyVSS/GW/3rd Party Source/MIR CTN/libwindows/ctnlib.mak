# Microsoft Developer Studio Generated NMAKE File, Based on ctnlib.dsp
!IF "$(CFG)" == ""
CFG=ctnlib - Win32 Release
!MESSAGE No configuration specified. Defaulting to ctnlib - Win32 Release.
!ENDIF 

!IF "$(CFG)" != "ctnlib - Win32 Release" && "$(CFG)" != "ctnlib - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "ctnlib.mak" CFG="ctnlib - Win32 Release"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "ctnlib - Win32 Release" (based on "Win32 (x86) Static Library")
!MESSAGE "ctnlib - Win32 Debug" (based on "Win32 (x86) Static Library")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "ctnlib - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\ctnlib.lib"


CLEAN :
	-@erase "$(INTDIR)\build.obj"
	-@erase "$(INTDIR)\cmd_valid.obj"
	-@erase "$(INTDIR)\condition.obj"
	-@erase "$(INTDIR)\control.obj"
	-@erase "$(INTDIR)\ctnthread.obj"
	-@erase "$(INTDIR)\dcm.obj"
	-@erase "$(INTDIR)\dcm1.obj"
	-@erase "$(INTDIR)\dcmcond.obj"
	-@erase "$(INTDIR)\dcmdict.obj"
	-@erase "$(INTDIR)\dcmsupport.obj"
	-@erase "$(INTDIR)\delete.obj"
	-@erase "$(INTDIR)\dulcond.obj"
	-@erase "$(INTDIR)\dulconstruct.obj"
	-@erase "$(INTDIR)\dulfsm.obj"
	-@erase "$(INTDIR)\dulparse.obj"
	-@erase "$(INTDIR)\dulpresent.obj"
	-@erase "$(INTDIR)\dulprotocol.obj"
	-@erase "$(INTDIR)\dump.obj"
	-@erase "$(INTDIR)\event.obj"
	-@erase "$(INTDIR)\find.obj"
	-@erase "$(INTDIR)\fis.obj"
	-@erase "$(INTDIR)\fiscond.obj"
	-@erase "$(INTDIR)\fisdelete.obj"
	-@erase "$(INTDIR)\fisget.obj"
	-@erase "$(INTDIR)\fisinsert.obj"
	-@erase "$(INTDIR)\get.obj"
	-@erase "$(INTDIR)\gq.obj"
	-@erase "$(INTDIR)\iap.obj"
	-@erase "$(INTDIR)\iapcond.obj"
	-@erase "$(INTDIR)\idb.obj"
	-@erase "$(INTDIR)\idbcond.obj"
	-@erase "$(INTDIR)\ie.obj"
	-@erase "$(INTDIR)\iecond.obj"
	-@erase "$(INTDIR)\insert.obj"
	-@erase "$(INTDIR)\lst.obj"
	-@erase "$(INTDIR)\mancond.obj"
	-@erase "$(INTDIR)\messages.obj"
	-@erase "$(INTDIR)\move.obj"
	-@erase "$(INTDIR)\msgcond.obj"
	-@erase "$(INTDIR)\naction.obj"
	-@erase "$(INTDIR)\ncreate.obj"
	-@erase "$(INTDIR)\ndelete.obj"
	-@erase "$(INTDIR)\nget.obj"
	-@erase "$(INTDIR)\nset.obj"
	-@erase "$(INTDIR)\print.obj"
	-@erase "$(INTDIR)\printcond.obj"
	-@erase "$(INTDIR)\private.obj"
	-@erase "$(INTDIR)\record.obj"
	-@erase "$(INTDIR)\ref_item.obj"
	-@erase "$(INTDIR)\select.obj"
	-@erase "$(INTDIR)\send.obj"
	-@erase "$(INTDIR)\sequences.obj"
	-@erase "$(INTDIR)\set.obj"
	-@erase "$(INTDIR)\sqcond.obj"
	-@erase "$(INTDIR)\srv1.obj"
	-@erase "$(INTDIR)\srv2.obj"
	-@erase "$(INTDIR)\srvcond.obj"
	-@erase "$(INTDIR)\storage.obj"
	-@erase "$(INTDIR)\tbl_sqlserver.obj"
	-@erase "$(INTDIR)\tblcond.obj"
	-@erase "$(INTDIR)\thrcond.obj"
	-@erase "$(INTDIR)\uid.obj"
	-@erase "$(INTDIR)\uidcond.obj"
	-@erase "$(INTDIR)\update.obj"
	-@erase "$(INTDIR)\utility.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\verify.obj"
	-@erase "$(OUTDIR)\ctnlib.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MTd /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /Fp"$(INTDIR)\ctnlib.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\ctnlib.bsc" 
BSC32_SBRS= \
	
LIB32=link.exe -lib
LIB32_FLAGS=/nologo /out:"$(OUTDIR)\ctnlib.lib" 
LIB32_OBJS= \
	"$(INTDIR)\build.obj" \
	"$(INTDIR)\cmd_valid.obj" \
	"$(INTDIR)\condition.obj" \
	"$(INTDIR)\control.obj" \
	"$(INTDIR)\ctnthread.obj" \
	"$(INTDIR)\dcm.obj" \
	"$(INTDIR)\dcm1.obj" \
	"$(INTDIR)\dcmcond.obj" \
	"$(INTDIR)\dcmdict.obj" \
	"$(INTDIR)\dcmsupport.obj" \
	"$(INTDIR)\delete.obj" \
	"$(INTDIR)\dulcond.obj" \
	"$(INTDIR)\dulconstruct.obj" \
	"$(INTDIR)\dulfsm.obj" \
	"$(INTDIR)\dulparse.obj" \
	"$(INTDIR)\dulpresent.obj" \
	"$(INTDIR)\dulprotocol.obj" \
	"$(INTDIR)\dump.obj" \
	"$(INTDIR)\event.obj" \
	"$(INTDIR)\find.obj" \
	"$(INTDIR)\fis.obj" \
	"$(INTDIR)\fiscond.obj" \
	"$(INTDIR)\fisdelete.obj" \
	"$(INTDIR)\fisget.obj" \
	"$(INTDIR)\fisinsert.obj" \
	"$(INTDIR)\get.obj" \
	"$(INTDIR)\gq.obj" \
	"$(INTDIR)\iap.obj" \
	"$(INTDIR)\iapcond.obj" \
	"$(INTDIR)\idb.obj" \
	"$(INTDIR)\idbcond.obj" \
	"$(INTDIR)\ie.obj" \
	"$(INTDIR)\iecond.obj" \
	"$(INTDIR)\insert.obj" \
	"$(INTDIR)\lst.obj" \
	"$(INTDIR)\mancond.obj" \
	"$(INTDIR)\messages.obj" \
	"$(INTDIR)\move.obj" \
	"$(INTDIR)\msgcond.obj" \
	"$(INTDIR)\naction.obj" \
	"$(INTDIR)\ncreate.obj" \
	"$(INTDIR)\ndelete.obj" \
	"$(INTDIR)\nget.obj" \
	"$(INTDIR)\nset.obj" \
	"$(INTDIR)\print.obj" \
	"$(INTDIR)\printcond.obj" \
	"$(INTDIR)\private.obj" \
	"$(INTDIR)\record.obj" \
	"$(INTDIR)\ref_item.obj" \
	"$(INTDIR)\select.obj" \
	"$(INTDIR)\send.obj" \
	"$(INTDIR)\sequences.obj" \
	"$(INTDIR)\set.obj" \
	"$(INTDIR)\sqcond.obj" \
	"$(INTDIR)\srv1.obj" \
	"$(INTDIR)\srv2.obj" \
	"$(INTDIR)\srvcond.obj" \
	"$(INTDIR)\storage.obj" \
	"$(INTDIR)\tbl_sqlserver.obj" \
	"$(INTDIR)\tblcond.obj" \
	"$(INTDIR)\thrcond.obj" \
	"$(INTDIR)\uid.obj" \
	"$(INTDIR)\uidcond.obj" \
	"$(INTDIR)\update.obj" \
	"$(INTDIR)\utility.obj" \
	"$(INTDIR)\verify.obj"

"$(OUTDIR)\ctnlib.lib" : "$(OUTDIR)" $(DEF_FILE) $(LIB32_OBJS)
    $(LIB32) @<<
  $(LIB32_FLAGS) $(DEF_FLAGS) $(LIB32_OBJS)
<<

!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\ctnlib.lib" "$(OUTDIR)\ctnlib.bsc"


CLEAN :
	-@erase "$(INTDIR)\build.obj"
	-@erase "$(INTDIR)\build.sbr"
	-@erase "$(INTDIR)\cmd_valid.obj"
	-@erase "$(INTDIR)\cmd_valid.sbr"
	-@erase "$(INTDIR)\condition.obj"
	-@erase "$(INTDIR)\condition.sbr"
	-@erase "$(INTDIR)\control.obj"
	-@erase "$(INTDIR)\control.sbr"
	-@erase "$(INTDIR)\ctnthread.obj"
	-@erase "$(INTDIR)\ctnthread.sbr"
	-@erase "$(INTDIR)\dcm.obj"
	-@erase "$(INTDIR)\dcm.sbr"
	-@erase "$(INTDIR)\dcm1.obj"
	-@erase "$(INTDIR)\dcm1.sbr"
	-@erase "$(INTDIR)\dcmcond.obj"
	-@erase "$(INTDIR)\dcmcond.sbr"
	-@erase "$(INTDIR)\dcmdict.obj"
	-@erase "$(INTDIR)\dcmdict.sbr"
	-@erase "$(INTDIR)\dcmsupport.obj"
	-@erase "$(INTDIR)\dcmsupport.sbr"
	-@erase "$(INTDIR)\delete.obj"
	-@erase "$(INTDIR)\delete.sbr"
	-@erase "$(INTDIR)\dulcond.obj"
	-@erase "$(INTDIR)\dulcond.sbr"
	-@erase "$(INTDIR)\dulconstruct.obj"
	-@erase "$(INTDIR)\dulconstruct.sbr"
	-@erase "$(INTDIR)\dulfsm.obj"
	-@erase "$(INTDIR)\dulfsm.sbr"
	-@erase "$(INTDIR)\dulparse.obj"
	-@erase "$(INTDIR)\dulparse.sbr"
	-@erase "$(INTDIR)\dulpresent.obj"
	-@erase "$(INTDIR)\dulpresent.sbr"
	-@erase "$(INTDIR)\dulprotocol.obj"
	-@erase "$(INTDIR)\dulprotocol.sbr"
	-@erase "$(INTDIR)\dump.obj"
	-@erase "$(INTDIR)\dump.sbr"
	-@erase "$(INTDIR)\event.obj"
	-@erase "$(INTDIR)\event.sbr"
	-@erase "$(INTDIR)\find.obj"
	-@erase "$(INTDIR)\find.sbr"
	-@erase "$(INTDIR)\fis.obj"
	-@erase "$(INTDIR)\fis.sbr"
	-@erase "$(INTDIR)\fiscond.obj"
	-@erase "$(INTDIR)\fiscond.sbr"
	-@erase "$(INTDIR)\fisdelete.obj"
	-@erase "$(INTDIR)\fisdelete.sbr"
	-@erase "$(INTDIR)\fisget.obj"
	-@erase "$(INTDIR)\fisget.sbr"
	-@erase "$(INTDIR)\fisinsert.obj"
	-@erase "$(INTDIR)\fisinsert.sbr"
	-@erase "$(INTDIR)\get.obj"
	-@erase "$(INTDIR)\get.sbr"
	-@erase "$(INTDIR)\gq.obj"
	-@erase "$(INTDIR)\gq.sbr"
	-@erase "$(INTDIR)\iap.obj"
	-@erase "$(INTDIR)\iap.sbr"
	-@erase "$(INTDIR)\iapcond.obj"
	-@erase "$(INTDIR)\iapcond.sbr"
	-@erase "$(INTDIR)\idb.obj"
	-@erase "$(INTDIR)\idb.sbr"
	-@erase "$(INTDIR)\idbcond.obj"
	-@erase "$(INTDIR)\idbcond.sbr"
	-@erase "$(INTDIR)\ie.obj"
	-@erase "$(INTDIR)\ie.sbr"
	-@erase "$(INTDIR)\iecond.obj"
	-@erase "$(INTDIR)\iecond.sbr"
	-@erase "$(INTDIR)\insert.obj"
	-@erase "$(INTDIR)\insert.sbr"
	-@erase "$(INTDIR)\lst.obj"
	-@erase "$(INTDIR)\lst.sbr"
	-@erase "$(INTDIR)\mancond.obj"
	-@erase "$(INTDIR)\mancond.sbr"
	-@erase "$(INTDIR)\messages.obj"
	-@erase "$(INTDIR)\messages.sbr"
	-@erase "$(INTDIR)\move.obj"
	-@erase "$(INTDIR)\move.sbr"
	-@erase "$(INTDIR)\msgcond.obj"
	-@erase "$(INTDIR)\msgcond.sbr"
	-@erase "$(INTDIR)\naction.obj"
	-@erase "$(INTDIR)\naction.sbr"
	-@erase "$(INTDIR)\ncreate.obj"
	-@erase "$(INTDIR)\ncreate.sbr"
	-@erase "$(INTDIR)\ndelete.obj"
	-@erase "$(INTDIR)\ndelete.sbr"
	-@erase "$(INTDIR)\nget.obj"
	-@erase "$(INTDIR)\nget.sbr"
	-@erase "$(INTDIR)\nset.obj"
	-@erase "$(INTDIR)\nset.sbr"
	-@erase "$(INTDIR)\print.obj"
	-@erase "$(INTDIR)\print.sbr"
	-@erase "$(INTDIR)\printcond.obj"
	-@erase "$(INTDIR)\printcond.sbr"
	-@erase "$(INTDIR)\private.obj"
	-@erase "$(INTDIR)\private.sbr"
	-@erase "$(INTDIR)\record.obj"
	-@erase "$(INTDIR)\record.sbr"
	-@erase "$(INTDIR)\ref_item.obj"
	-@erase "$(INTDIR)\ref_item.sbr"
	-@erase "$(INTDIR)\select.obj"
	-@erase "$(INTDIR)\select.sbr"
	-@erase "$(INTDIR)\send.obj"
	-@erase "$(INTDIR)\send.sbr"
	-@erase "$(INTDIR)\sequences.obj"
	-@erase "$(INTDIR)\sequences.sbr"
	-@erase "$(INTDIR)\set.obj"
	-@erase "$(INTDIR)\set.sbr"
	-@erase "$(INTDIR)\sqcond.obj"
	-@erase "$(INTDIR)\sqcond.sbr"
	-@erase "$(INTDIR)\srv1.obj"
	-@erase "$(INTDIR)\srv1.sbr"
	-@erase "$(INTDIR)\srv2.obj"
	-@erase "$(INTDIR)\srv2.sbr"
	-@erase "$(INTDIR)\srvcond.obj"
	-@erase "$(INTDIR)\srvcond.sbr"
	-@erase "$(INTDIR)\storage.obj"
	-@erase "$(INTDIR)\storage.sbr"
	-@erase "$(INTDIR)\tbl_sqlserver.obj"
	-@erase "$(INTDIR)\tbl_sqlserver.sbr"
	-@erase "$(INTDIR)\tblcond.obj"
	-@erase "$(INTDIR)\tblcond.sbr"
	-@erase "$(INTDIR)\thrcond.obj"
	-@erase "$(INTDIR)\thrcond.sbr"
	-@erase "$(INTDIR)\uid.obj"
	-@erase "$(INTDIR)\uid.sbr"
	-@erase "$(INTDIR)\uidcond.obj"
	-@erase "$(INTDIR)\uidcond.sbr"
	-@erase "$(INTDIR)\update.obj"
	-@erase "$(INTDIR)\update.sbr"
	-@erase "$(INTDIR)\utility.obj"
	-@erase "$(INTDIR)\utility.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\verify.obj"
	-@erase "$(INTDIR)\verify.sbr"
	-@erase "$(OUTDIR)\ctnlib.bsc"
	-@erase "$(OUTDIR)\ctnlib.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MTd /W3 /GX /Z7 /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\ctnlib.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\ctnlib.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\build.sbr" \
	"$(INTDIR)\cmd_valid.sbr" \
	"$(INTDIR)\condition.sbr" \
	"$(INTDIR)\control.sbr" \
	"$(INTDIR)\ctnthread.sbr" \
	"$(INTDIR)\dcm.sbr" \
	"$(INTDIR)\dcm1.sbr" \
	"$(INTDIR)\dcmcond.sbr" \
	"$(INTDIR)\dcmdict.sbr" \
	"$(INTDIR)\dcmsupport.sbr" \
	"$(INTDIR)\delete.sbr" \
	"$(INTDIR)\dulcond.sbr" \
	"$(INTDIR)\dulconstruct.sbr" \
	"$(INTDIR)\dulfsm.sbr" \
	"$(INTDIR)\dulparse.sbr" \
	"$(INTDIR)\dulpresent.sbr" \
	"$(INTDIR)\dulprotocol.sbr" \
	"$(INTDIR)\dump.sbr" \
	"$(INTDIR)\event.sbr" \
	"$(INTDIR)\find.sbr" \
	"$(INTDIR)\fis.sbr" \
	"$(INTDIR)\fiscond.sbr" \
	"$(INTDIR)\fisdelete.sbr" \
	"$(INTDIR)\fisget.sbr" \
	"$(INTDIR)\fisinsert.sbr" \
	"$(INTDIR)\get.sbr" \
	"$(INTDIR)\gq.sbr" \
	"$(INTDIR)\iap.sbr" \
	"$(INTDIR)\iapcond.sbr" \
	"$(INTDIR)\idb.sbr" \
	"$(INTDIR)\idbcond.sbr" \
	"$(INTDIR)\ie.sbr" \
	"$(INTDIR)\iecond.sbr" \
	"$(INTDIR)\insert.sbr" \
	"$(INTDIR)\lst.sbr" \
	"$(INTDIR)\mancond.sbr" \
	"$(INTDIR)\messages.sbr" \
	"$(INTDIR)\move.sbr" \
	"$(INTDIR)\msgcond.sbr" \
	"$(INTDIR)\naction.sbr" \
	"$(INTDIR)\ncreate.sbr" \
	"$(INTDIR)\ndelete.sbr" \
	"$(INTDIR)\nget.sbr" \
	"$(INTDIR)\nset.sbr" \
	"$(INTDIR)\print.sbr" \
	"$(INTDIR)\printcond.sbr" \
	"$(INTDIR)\private.sbr" \
	"$(INTDIR)\record.sbr" \
	"$(INTDIR)\ref_item.sbr" \
	"$(INTDIR)\select.sbr" \
	"$(INTDIR)\send.sbr" \
	"$(INTDIR)\sequences.sbr" \
	"$(INTDIR)\set.sbr" \
	"$(INTDIR)\sqcond.sbr" \
	"$(INTDIR)\srv1.sbr" \
	"$(INTDIR)\srv2.sbr" \
	"$(INTDIR)\srvcond.sbr" \
	"$(INTDIR)\storage.sbr" \
	"$(INTDIR)\tbl_sqlserver.sbr" \
	"$(INTDIR)\tblcond.sbr" \
	"$(INTDIR)\thrcond.sbr" \
	"$(INTDIR)\uid.sbr" \
	"$(INTDIR)\uidcond.sbr" \
	"$(INTDIR)\update.sbr" \
	"$(INTDIR)\utility.sbr" \
	"$(INTDIR)\verify.sbr"

"$(OUTDIR)\ctnlib.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LIB32=link.exe -lib
LIB32_FLAGS=/nologo /out:"$(OUTDIR)\ctnlib.lib" 
LIB32_OBJS= \
	"$(INTDIR)\build.obj" \
	"$(INTDIR)\cmd_valid.obj" \
	"$(INTDIR)\condition.obj" \
	"$(INTDIR)\control.obj" \
	"$(INTDIR)\ctnthread.obj" \
	"$(INTDIR)\dcm.obj" \
	"$(INTDIR)\dcm1.obj" \
	"$(INTDIR)\dcmcond.obj" \
	"$(INTDIR)\dcmdict.obj" \
	"$(INTDIR)\dcmsupport.obj" \
	"$(INTDIR)\delete.obj" \
	"$(INTDIR)\dulcond.obj" \
	"$(INTDIR)\dulconstruct.obj" \
	"$(INTDIR)\dulfsm.obj" \
	"$(INTDIR)\dulparse.obj" \
	"$(INTDIR)\dulpresent.obj" \
	"$(INTDIR)\dulprotocol.obj" \
	"$(INTDIR)\dump.obj" \
	"$(INTDIR)\event.obj" \
	"$(INTDIR)\find.obj" \
	"$(INTDIR)\fis.obj" \
	"$(INTDIR)\fiscond.obj" \
	"$(INTDIR)\fisdelete.obj" \
	"$(INTDIR)\fisget.obj" \
	"$(INTDIR)\fisinsert.obj" \
	"$(INTDIR)\get.obj" \
	"$(INTDIR)\gq.obj" \
	"$(INTDIR)\iap.obj" \
	"$(INTDIR)\iapcond.obj" \
	"$(INTDIR)\idb.obj" \
	"$(INTDIR)\idbcond.obj" \
	"$(INTDIR)\ie.obj" \
	"$(INTDIR)\iecond.obj" \
	"$(INTDIR)\insert.obj" \
	"$(INTDIR)\lst.obj" \
	"$(INTDIR)\mancond.obj" \
	"$(INTDIR)\messages.obj" \
	"$(INTDIR)\move.obj" \
	"$(INTDIR)\msgcond.obj" \
	"$(INTDIR)\naction.obj" \
	"$(INTDIR)\ncreate.obj" \
	"$(INTDIR)\ndelete.obj" \
	"$(INTDIR)\nget.obj" \
	"$(INTDIR)\nset.obj" \
	"$(INTDIR)\print.obj" \
	"$(INTDIR)\printcond.obj" \
	"$(INTDIR)\private.obj" \
	"$(INTDIR)\record.obj" \
	"$(INTDIR)\ref_item.obj" \
	"$(INTDIR)\select.obj" \
	"$(INTDIR)\send.obj" \
	"$(INTDIR)\sequences.obj" \
	"$(INTDIR)\set.obj" \
	"$(INTDIR)\sqcond.obj" \
	"$(INTDIR)\srv1.obj" \
	"$(INTDIR)\srv2.obj" \
	"$(INTDIR)\srvcond.obj" \
	"$(INTDIR)\storage.obj" \
	"$(INTDIR)\tbl_sqlserver.obj" \
	"$(INTDIR)\tblcond.obj" \
	"$(INTDIR)\thrcond.obj" \
	"$(INTDIR)\uid.obj" \
	"$(INTDIR)\uidcond.obj" \
	"$(INTDIR)\update.obj" \
	"$(INTDIR)\utility.obj" \
	"$(INTDIR)\verify.obj"

"$(OUTDIR)\ctnlib.lib" : "$(OUTDIR)" $(DEF_FILE) $(LIB32_OBJS)
    $(LIB32) @<<
  $(LIB32_FLAGS) $(DEF_FLAGS) $(LIB32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("ctnlib.dep")
!INCLUDE "ctnlib.dep"
!ELSE 
!MESSAGE Warning: cannot find "ctnlib.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "ctnlib - Win32 Release" || "$(CFG)" == "ctnlib - Win32 Debug"
SOURCE=.\build.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\build.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\build.obj"	"$(INTDIR)\build.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\cmd_valid.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\cmd_valid.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\cmd_valid.obj"	"$(INTDIR)\cmd_valid.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\condition.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\condition.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\condition.obj"	"$(INTDIR)\condition.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\control.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\control.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\control.obj"	"$(INTDIR)\control.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\ctnthread.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\ctnthread.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\ctnthread.obj"	"$(INTDIR)\ctnthread.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\dcm.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\dcm.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\dcm.obj"	"$(INTDIR)\dcm.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\dcm1.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\dcm1.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\dcm1.obj"	"$(INTDIR)\dcm1.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\dcmcond.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\dcmcond.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\dcmcond.obj"	"$(INTDIR)\dcmcond.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\dcmdict.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\dcmdict.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\dcmdict.obj"	"$(INTDIR)\dcmdict.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\dcmsupport.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\dcmsupport.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\dcmsupport.obj"	"$(INTDIR)\dcmsupport.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\delete.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\delete.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\delete.obj"	"$(INTDIR)\delete.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\dulcond.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\dulcond.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\dulcond.obj"	"$(INTDIR)\dulcond.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\dulconstruct.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\dulconstruct.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\dulconstruct.obj"	"$(INTDIR)\dulconstruct.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\dulfsm.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\dulfsm.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\dulfsm.obj"	"$(INTDIR)\dulfsm.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\dulparse.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\dulparse.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\dulparse.obj"	"$(INTDIR)\dulparse.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\dulpresent.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\dulpresent.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\dulpresent.obj"	"$(INTDIR)\dulpresent.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\dulprotocol.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\dulprotocol.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\dulprotocol.obj"	"$(INTDIR)\dulprotocol.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\dump.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\dump.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\dump.obj"	"$(INTDIR)\dump.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\event.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\event.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\event.obj"	"$(INTDIR)\event.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\find.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\find.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\find.obj"	"$(INTDIR)\find.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\fis.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\fis.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\fis.obj"	"$(INTDIR)\fis.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\fiscond.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\fiscond.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\fiscond.obj"	"$(INTDIR)\fiscond.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\fisdelete.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\fisdelete.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\fisdelete.obj"	"$(INTDIR)\fisdelete.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\fisget.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\fisget.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\fisget.obj"	"$(INTDIR)\fisget.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\fisinsert.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\fisinsert.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\fisinsert.obj"	"$(INTDIR)\fisinsert.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\get.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\get.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\get.obj"	"$(INTDIR)\get.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\gq.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\gq.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\gq.obj"	"$(INTDIR)\gq.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\iap.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\iap.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\iap.obj"	"$(INTDIR)\iap.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\iapcond.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\iapcond.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\iapcond.obj"	"$(INTDIR)\iapcond.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\idb.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\idb.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\idb.obj"	"$(INTDIR)\idb.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\idbcond.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\idbcond.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\idbcond.obj"	"$(INTDIR)\idbcond.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\ie.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\ie.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\ie.obj"	"$(INTDIR)\ie.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\iecond.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\iecond.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\iecond.obj"	"$(INTDIR)\iecond.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\insert.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\insert.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\insert.obj"	"$(INTDIR)\insert.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\lst.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\lst.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\lst.obj"	"$(INTDIR)\lst.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\mancond.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\mancond.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\mancond.obj"	"$(INTDIR)\mancond.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\messages.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\messages.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\messages.obj"	"$(INTDIR)\messages.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\move.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\move.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\move.obj"	"$(INTDIR)\move.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\msgcond.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\msgcond.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\msgcond.obj"	"$(INTDIR)\msgcond.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\naction.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\naction.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\naction.obj"	"$(INTDIR)\naction.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\ncreate.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\ncreate.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\ncreate.obj"	"$(INTDIR)\ncreate.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\ndelete.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\ndelete.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\ndelete.obj"	"$(INTDIR)\ndelete.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\nget.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\nget.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\nget.obj"	"$(INTDIR)\nget.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\nset.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\nset.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\nset.obj"	"$(INTDIR)\nset.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\print.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\print.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\print.obj"	"$(INTDIR)\print.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\printcond.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\printcond.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\printcond.obj"	"$(INTDIR)\printcond.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\private.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\private.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\private.obj"	"$(INTDIR)\private.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\record.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\record.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\record.obj"	"$(INTDIR)\record.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\ref_item.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\ref_item.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\ref_item.obj"	"$(INTDIR)\ref_item.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\select.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\select.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\select.obj"	"$(INTDIR)\select.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\send.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\send.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\send.obj"	"$(INTDIR)\send.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\sequences.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\sequences.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\sequences.obj"	"$(INTDIR)\sequences.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\set.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\set.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\set.obj"	"$(INTDIR)\set.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\sqcond.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\sqcond.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\sqcond.obj"	"$(INTDIR)\sqcond.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\srv1.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\srv1.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\srv1.obj"	"$(INTDIR)\srv1.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\srv2.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\srv2.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\srv2.obj"	"$(INTDIR)\srv2.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\srvcond.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\srvcond.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\srvcond.obj"	"$(INTDIR)\srvcond.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\storage.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\storage.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\storage.obj"	"$(INTDIR)\storage.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\tbl_sqlserver.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\tbl_sqlserver.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\tbl_sqlserver.obj"	"$(INTDIR)\tbl_sqlserver.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\tblcond.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\tblcond.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\tblcond.obj"	"$(INTDIR)\tblcond.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\thrcond.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\thrcond.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\thrcond.obj"	"$(INTDIR)\thrcond.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\uid.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\uid.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\uid.obj"	"$(INTDIR)\uid.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\uidcond.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\uidcond.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\uidcond.obj"	"$(INTDIR)\uidcond.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\update.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\update.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\update.obj"	"$(INTDIR)\update.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\utility.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\utility.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\utility.obj"	"$(INTDIR)\utility.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\verify.c

!IF  "$(CFG)" == "ctnlib - Win32 Release"


"$(INTDIR)\verify.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"


"$(INTDIR)\verify.obj"	"$(INTDIR)\verify.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 


!ENDIF 

