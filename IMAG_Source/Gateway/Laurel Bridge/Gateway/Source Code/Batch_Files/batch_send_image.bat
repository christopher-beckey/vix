@echo off
rem Pete Kuzmak, Silver Spring OI&T Field Office, last edited Sept 10, 2008 at 6:55 am 
rem 3.0;IMAGING;*53*;10 Sept 2008
rem Per VHA Directive 2004-038, this routine should not be modified.
rem +---------------------------------------------------------------+
rem | Property of the US Government.                                |
rem | No permission to copy or redistribute this software is given. |
rem | Use of unreleased versions of this software requires the user |
rem | to execute a written test agreement with the VistA Imaging    |
rem | Development Office of the Department of Veterans Affairs,     |
rem | telephone (301) 734-0100.                                     |
rem | The Food and Drug Administration classifies this software as  |
rem | a medical device.  As such, it may not be changed in any way. |
rem | Modifications to this software may result in an adulterated   |
rem | medical device under 21CFR820, the use of which is considered |
rem | to be a violation of US Federal Statutes.                     |
rem +---------------------------------------------------------------+
rem
echo Batch DICOM File Sender
echo.
set dicom_host=%1
set dicom_port=%2
set dicom_path=%3
set extension=%4
if %dicom_host%x==x set dicom_host=help
if %dicom_host%==? set dicom_host=help
if %dicom_host%==help (
echo This batch file can be used to send a set of DICOM to a local C-Store process.
echo.
echo batch_send_image {C-Store host} {port number} {input path} [ {extension} ]
echo.
echo The {input path} can be either a directory on disk or one on portable media.
echo Only DICOM files should be in the {input path} directory tree.
echo This will try to send every file in the {input path} to the C-Store process.
echo An optional extension may be specified -- include the dot, as in ".ext".
echo If an extension is not specified, none will be used -- DICOM Part-10 compliant.
echo.
set dicom_host=
)
if %dicom_host%x==x echo First Argument is the host ip address or name for the C-Store process.
if %dicom_port%x==x echo Second Argument is the port number for the C-Store process.
if %dicom_path%x==x echo Third Argument is the path to the folder containing the images, like "D:\DICOM".
if %dicom_host%x==x goto :eof
if %dicom_port%x==x goto :eof
if %dicom_path%x==x goto :eof
if %extension%x==x (
	set file_mask=*.
) else (
	set file_mask=*%extension%
)
for /R %dicom_path% %%d in ("%file_mask%") do send_image -c VistA_Storage -q -Z %dicom_host% %dicom_port% "%%d"
