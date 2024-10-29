echo off
%MAG_QR_DRIVE%
cd \DICOM\Java
set CLASSPATH=
for %%f in (*.jar) do call :AddJar %%~ff

start javaw -classpath "%CLASSPATH%" gov.va.med.imaging.dicom.dcftoolkit.common.license.LicenseInstaller
goto :Return

:AddJar
if not "%CLASSPATH%" equ "" set CLASSPATH=%CLASSPATH%;
set CLASSPATH=%CLASSPATH%%1
goto :Return

:Return
