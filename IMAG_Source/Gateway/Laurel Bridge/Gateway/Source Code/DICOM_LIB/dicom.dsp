# Microsoft Developer Studio Project File - Name="dicom" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Static Library" 0x0104

CFG=dicom - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "dicom.mak".
!MESSAGE 
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

# Begin Project
# PROP AllowPerConfigDependencies 1
# PROP Scc_ProjName ""$/Experiments/UCDAVIS/dicom", LQNCAAAA"
# PROP Scc_LocalPath "."
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "dicom - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "WinRel"
# PROP BASE Intermediate_Dir "WinRel"
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "WinRel"
# PROP Intermediate_Dir "WinRel"
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /FR /YX /c
# ADD CPP /nologo /MT /W3 /GX /O2 /D "NDEBUG" /D "WIN32" /D "_WINDOWS" /D "WINDOWS" /D NATIVE_ENDIAN=1 /FR /YX"dicom.hpp" /FD /c
# ADD BASE RSC /l 0x409
# ADD RSC /l 0x409
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo

!ELSEIF  "$(CFG)" == "dicom - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "WinDebug"
# PROP BASE Intermediate_Dir "WinDebug"
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "WinDebug"
# PROP Intermediate_Dir "WinDebug"
# ADD BASE CPP /nologo /W3 /GX /Z7 /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /FR /YX /c
# ADD CPP /nologo /MTd /W3 /GX /ZI /Od /D "_DEBUG" /D "WIN32" /D "_WINDOWS" /D "WINDOWS" /D NATIVE_ENDIAN=1 /Fr /FD /c
# SUBTRACT CPP /YX
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

# Name "dicom - Win32 Release"
# Name "dicom - Win32 Debug"
# Begin Group "Core Library"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;hpj;bat;for;f90"
# Begin Source File

SOURCE=.\aaac.cxx
# End Source File
# Begin Source File

SOURCE=.\aarj.cxx
# End Source File
# Begin Source File

SOURCE=.\aarq.cxx
# End Source File
# Begin Source File

SOURCE=.\buffer.cxx
# End Source File
# Begin Source File

SOURCE=.\deivr.cxx
# End Source File
# Begin Source File

SOURCE=.\dimsec.cxx
# End Source File
# Begin Source File

SOURCE=.\dimsen.cpp
# End Source File
# Begin Source File

SOURCE=.\endian.cxx
# End Source File
# Begin Source File

SOURCE=.\filepdu.cxx
# End Source File
# Begin Source File

SOURCE=.\flpdu.cxx
# End Source File
# Begin Source File

SOURCE=.\pdata.cxx
# End Source File
# Begin Source File

SOURCE=.\pdu.cxx
# End Source File
# Begin Source File

SOURCE=.\qrsop.cxx
# End Source File
# Begin Source File

SOURCE=.\rtc.cxx
# End Source File
# Begin Source File

SOURCE=.\safemem.cxx
# End Source File
# Begin Source File

SOURCE=.\socket.cxx
# End Source File
# Begin Source File

SOURCE=.\storage.cxx
# End Source File
# Begin Source File

SOURCE=.\trnsyn.cxx
# End Source File
# Begin Source File

SOURCE=.\uniq.cxx
# End Source File
# Begin Source File

SOURCE=.\util.cxx
# End Source File
# Begin Source File

SOURCE=.\verify.cxx
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl;fi;fd"
# Begin Source File

SOURCE=.\aaac.hpp
# End Source File
# Begin Source File

SOURCE=.\aarj.hpp
# End Source File
# Begin Source File

SOURCE=.\aarq.hpp
# End Source File
# Begin Source File

SOURCE=.\base.hpp
# End Source File
# Begin Source File

SOURCE=.\cctypes.h
# End Source File
# Begin Source File

SOURCE=.\constant.h
# End Source File
# Begin Source File

SOURCE=.\dc3tags.h
# End Source File
# Begin Source File

SOURCE=.\deivr.hpp
# End Source File
# Begin Source File

SOURCE=.\dicom.hpp
# End Source File
# Begin Source File

SOURCE=.\dimsec.hpp
# End Source File
# Begin Source File

SOURCE=.\dimsen.hpp
# End Source File
# Begin Source File

SOURCE=.\endian.hpp
# End Source File
# Begin Source File

SOURCE=.\flpdu.hpp
# End Source File
# Begin Source File

SOURCE=.\macsock.h
# End Source File
# Begin Source File

SOURCE=.\pdata.hpp
# End Source File
# Begin Source File

SOURCE=.\pdu.hpp
# End Source File
# Begin Source File

SOURCE=.\qrsop.hpp
# End Source File
# Begin Source File

SOURCE=.\rtc.hpp
# End Source File
# Begin Source File

SOURCE=.\safemem.h
# End Source File
# Begin Source File

SOURCE=.\socket.hpp
# End Source File
# Begin Source File

SOURCE=.\storage.hpp
# End Source File
# Begin Source File

SOURCE=.\unixsock.h
# End Source File
# Begin Source File

SOURCE=.\util.h
# End Source File
# Begin Source File

SOURCE=.\verify.hpp
# End Source File
# Begin Source File

SOURCE=.\version.h
# End Source File
# End Group
# Begin Group "Resource Files"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;cnt;rtf;gif;jpg;jpeg;jpe"
# End Group
# Begin Group "Task List"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Future.txt
# End Source File
# Begin Source File

SOURCE=.\Tasks.txt
# End Source File
# End Group
# Begin Source File

SOURCE=.\array.tcc
# End Source File
# Begin Source File

SOURCE=.\array.thh
# End Source File
# Begin Source File

SOURCE=.\buffer.thh
# End Source File
# Begin Source File

SOURCE=.\endian.cpd
# End Source File
# Begin Source File

SOURCE=.\endian.hpd
# End Source File
# Begin Source File

SOURCE=.\farray.thh
# End Source File
# Begin Source File

SOURCE=.\pqueue.tcc
# End Source File
# Begin Source File

SOURCE=.\pqueue.thh
# End Source File
# End Target
# End Project
