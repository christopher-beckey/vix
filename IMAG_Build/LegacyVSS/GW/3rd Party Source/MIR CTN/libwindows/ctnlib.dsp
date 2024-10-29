# Microsoft Developer Studio Project File - Name="ctnlib" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Static Library" 0x0104

CFG=ctnlib - Win32 Release
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "ctnlib.mak".
!MESSAGE 
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

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""$/ctnlib", IACAAAAA"
# PROP Scc_LocalPath "."
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "ctnlib - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir ".\Release"
# PROP BASE Intermediate_Dir ".\Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir ".\Release"
# PROP Intermediate_Dir ".\Release"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /YX /c
# ADD CPP /nologo /MTd /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /YX /FD /c
# ADD BASE RSC /l 0x409
# ADD RSC /l 0x409
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo

!ELSEIF  "$(CFG)" == "ctnlib - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir ".\Debug"
# PROP BASE Intermediate_Dir ".\Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir ".\Debug"
# PROP Intermediate_Dir ".\Debug"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /Z7 /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /YX /c
# ADD CPP /nologo /MTd /W3 /GX /Z7 /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /FR /YX /FD /c
# ADD BASE RSC /l 0x409
# ADD RSC /l 0x409
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo

!ENDIF 

# Begin Target

# Name "ctnlib - Win32 Release"
# Name "ctnlib - Win32 Debug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat;for;f90"
# Begin Source File

SOURCE=.\build.c
# End Source File
# Begin Source File

SOURCE=.\cmd_valid.c
# End Source File
# Begin Source File

SOURCE=.\condition.c
# End Source File
# Begin Source File

SOURCE=.\control.c
# End Source File
# Begin Source File

SOURCE=.\ctnthread.c
# End Source File
# Begin Source File

SOURCE=.\dcm.c
# End Source File
# Begin Source File

SOURCE=.\dcm1.c
# End Source File
# Begin Source File

SOURCE=.\dcmcond.c
# End Source File
# Begin Source File

SOURCE=.\dcmdict.c
# End Source File
# Begin Source File

SOURCE=.\dcmsupport.c
# End Source File
# Begin Source File

SOURCE=.\delete.c
# End Source File
# Begin Source File

SOURCE=.\dulcond.c
# End Source File
# Begin Source File

SOURCE=.\dulconstruct.c
# End Source File
# Begin Source File

SOURCE=.\dulfsm.c
# End Source File
# Begin Source File

SOURCE=.\dulparse.c
# End Source File
# Begin Source File

SOURCE=.\dulpresent.c
# End Source File
# Begin Source File

SOURCE=.\dulprotocol.c
# End Source File
# Begin Source File

SOURCE=.\dump.c
# End Source File
# Begin Source File

SOURCE=.\event.c
# End Source File
# Begin Source File

SOURCE=.\find.c
# End Source File
# Begin Source File

SOURCE=.\fis.c
# End Source File
# Begin Source File

SOURCE=.\fiscond.c
# End Source File
# Begin Source File

SOURCE=.\fisdelete.c
# End Source File
# Begin Source File

SOURCE=.\fisget.c
# End Source File
# Begin Source File

SOURCE=.\fisinsert.c
# End Source File
# Begin Source File

SOURCE=.\get.c
# End Source File
# Begin Source File

SOURCE=.\gq.c
# End Source File
# Begin Source File

SOURCE=.\iap.c
# End Source File
# Begin Source File

SOURCE=.\iapcond.c
# End Source File
# Begin Source File

SOURCE=.\idb.c
# End Source File
# Begin Source File

SOURCE=.\idbcond.c
# End Source File
# Begin Source File

SOURCE=.\ie.c
# End Source File
# Begin Source File

SOURCE=.\iecond.c
# End Source File
# Begin Source File

SOURCE=.\insert.c
# End Source File
# Begin Source File

SOURCE=.\lst.c
# End Source File
# Begin Source File

SOURCE=.\mancond.c
# End Source File
# Begin Source File

SOURCE=.\messages.c
# End Source File
# Begin Source File

SOURCE=.\move.c
# End Source File
# Begin Source File

SOURCE=.\msgcond.c
# End Source File
# Begin Source File

SOURCE=.\naction.c
# End Source File
# Begin Source File

SOURCE=.\ncreate.c
# End Source File
# Begin Source File

SOURCE=.\ndelete.c
# End Source File
# Begin Source File

SOURCE=.\nget.c
# End Source File
# Begin Source File

SOURCE=.\nset.c
# End Source File
# Begin Source File

SOURCE=.\print.c
# End Source File
# Begin Source File

SOURCE=.\printcond.c
# End Source File
# Begin Source File

SOURCE=.\private.c
# End Source File
# Begin Source File

SOURCE=.\record.c
# End Source File
# Begin Source File

SOURCE=.\ref_item.c
# End Source File
# Begin Source File

SOURCE=.\select.c
# End Source File
# Begin Source File

SOURCE=.\send.c
# End Source File
# Begin Source File

SOURCE=.\sequences.c
# End Source File
# Begin Source File

SOURCE=.\set.c
# End Source File
# Begin Source File

SOURCE=.\sqcond.c
# End Source File
# Begin Source File

SOURCE=.\srv1.c
# End Source File
# Begin Source File

SOURCE=.\srv2.c
# End Source File
# Begin Source File

SOURCE=.\srvcond.c
# End Source File
# Begin Source File

SOURCE=.\storage.c
# End Source File
# Begin Source File

SOURCE=.\tbl_sqlserver.c
# End Source File
# Begin Source File

SOURCE=.\tblcond.c
# End Source File
# Begin Source File

SOURCE=.\thrcond.c
# End Source File
# Begin Source File

SOURCE=.\uid.c
# End Source File
# Begin Source File

SOURCE=.\uidcond.c
# End Source File
# Begin Source File

SOURCE=.\update.c
# End Source File
# Begin Source File

SOURCE=.\utility.c
# End Source File
# Begin Source File

SOURCE=.\verify.c
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl;fi;fd"
# Begin Source File

SOURCE=.\condition.h
# End Source File
# Begin Source File

SOURCE=.\ctnthread.h
# End Source File
# Begin Source File

SOURCE=.\dbquery.h
# End Source File
# Begin Source File

SOURCE=.\dcmprivate.h
# End Source File
# Begin Source File

SOURCE=.\dicom.h
# End Source File
# Begin Source File

SOURCE=.\dicom_ie.h
# End Source File
# Begin Source File

SOURCE=.\dicom_messages.h
# End Source File
# Begin Source File

SOURCE=.\dicom_objects.h
# End Source File
# Begin Source File

SOURCE=.\dicom_platform.h
# End Source File
# Begin Source File

SOURCE=.\dicom_print.h
# End Source File
# Begin Source File

SOURCE=.\dicom_services.h
# End Source File
# Begin Source File

SOURCE=.\dicom_sq.h
# End Source File
# Begin Source File

SOURCE=.\dicom_uids.h
# End Source File
# Begin Source File

SOURCE=.\dmanprivate.h
# End Source File
# Begin Source File

SOURCE=.\dulfsm.h
# End Source File
# Begin Source File

SOURCE=.\dulprivate.h
# End Source File
# Begin Source File

SOURCE=.\dulprotocol.h
# End Source File
# Begin Source File

SOURCE=.\dulstructures.h
# End Source File
# Begin Source File

SOURCE=.\fis.h
# End Source File
# Begin Source File

SOURCE=.\fis_private.h
# End Source File
# Begin Source File

SOURCE=.\gq.h
# End Source File
# Begin Source File

SOURCE=.\iap.h
# End Source File
# Begin Source File

SOURCE=.\idb.h
# End Source File
# Begin Source File

SOURCE=.\lst.h
# End Source File
# Begin Source File

SOURCE=.\lstprivate.h
# End Source File
# Begin Source File

SOURCE=.\manage.h
# End Source File
# Begin Source File

SOURCE=.\msgprivate.h
# End Source File
# Begin Source File

SOURCE=.\private.h
# End Source File
# Begin Source File

SOURCE=.\tables.h
# End Source File
# Begin Source File

SOURCE=.\tbl.h
# End Source File
# Begin Source File

SOURCE=.\tbl_sqlserver.h
# End Source File
# Begin Source File

SOURCE=.\tblprivate.h
# End Source File
# Begin Source File

SOURCE=.\utility.h
# End Source File
# End Group
# Begin Group "Resource Files"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;cnt;rtf;gif;jpg;jpeg;jpe"
# End Group
# End Target
# End Project
