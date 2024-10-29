@echo off

echo Setting environment for Laurel Bridge DCF tools.

set DCF_USER_ROOT=C:\DCF_DEV
set DCF_ROOT=C:\DCF_DEV
set DCF_PLATFORM=Windows_NT_4_x86_VisualStudio8.x
set DOMAINNAME=kinetixtesting.com 
set OMNI_ROOT=C:\DCF_DEV\omni
set OMNI_BIN=C:\DCF_DEV\bin
set OMNI_LIB=C:\DCF_DEV\omni\lib\x86_win32
set JAVA_ROOT=C:\Program Files\Java\jdk1.6.0_02
set JAVA_BIN=C:\Program Files\Java\jdk1.6.0_02\bin
set JAVA_CLASSES=.
set APACHE_ROOT=C:\Program Files\Apache Group\Apache
set APACHE_BIN=C:\Program Files\Apache Group\Apache\bin
set DCF_APACHE_PORT=8080
set DCF_CFGSRC=C:\DCF_DEV\devel\cfgsrc
set DCF_BIN=C:\DCF_DEV\bin
set DCF_USER_CLASSES=C:\DCF_DEV\classes
set DCF_HTTPD_ROOT=C:\DCF_DEV\httpd
set DCF_USER_INC=C:\DCF_DEV\include
set DCF_INC=C:\DCF_DEV\include
set DCF_LOG=C:\DCF_DEV\tmp\log
set DCF_USER_DOC=C:\DCF_DEV\doc
set DCF_DOC=C:\DCF_DEV\doc
set DCF_USER_LIB=C:\DCF_DEV\lib
set DCF_USER_BIN=C:\DCF_DEV\bin
set DCF_CFG=C:\DCF_DEV\cfg
set DCF_LIB=C:\DCF_DEV\lib
set DCF_PERL_BIN=C:\DCF_DEV\perl\bin
set DCF_CLASSES=C:\DCF_DEV\classes;C:\DCF_DEV\devel\jsrcgen
set DCF_CFGGEN=C:\DCF_DEV\devel\cfggen
set DCF_TMP=C:\DCF_DEV\tmp


set HOSTNAME=Seneca
set PATH=C:\DCF_DEV\bin;C:\Program Files\Java\jdk1.6.0_02\bin;C:\Program Files\Apache Group\Apache\bin;C:\DCF_DEV\lib;C:\DCF_DEV\perl\bin;%PATH%
set LD_LIBRARY_PATH=C:\DCF_DEV\omni\lib\x86_win32;C:\DCF_DEV\lib;%LD_LIBRARY_PATH%
set INFOPATH=%INFOPATH%
set CLASSPATH=.;C:\DCF_DEV\classes;C:\DCF_DEV\devel\jsrcgen;%CLASSPATH%
set MANPATH=%MANPATH%


REM Adding Visual Studio environment variables
call "C:\Program Files\Microsoft Visual Studio\VC98\Bin\VCVARS32.BAT "


