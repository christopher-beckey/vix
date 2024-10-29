@ECHO OFF
REM        ;; +---------------------------------------------------------------------------------------------------+
REM        ;; Property of the US Government.
REM        ;; No permission to copy or redistribute this software is given. 
REM        ;; Use of unreleased versions of this software requires the user
REM        ;;  to execute a written test agreement with the VistA Imaging
REM        ;;  Development Office of the Department of Veterans Affairs, 
REM        ;;  telephone (301) 734-0100.  
REM        ;;  
REM        ;; The Food and Drug Administration classifies this software as
REM        ;; a Class II medical device.  As such, it may not be changed   
REM        ;; in any way.  Modifications to this software may result in an 
REM        ;; adulterated medical device under 21CFR820, the use of which
REM        ;; is considered to be a violation of US Federal Statutes.  
REM        ;; +---------------------------------------------------------------------------------------------------+
SET OUTFILE=%1
SET ABSFILE=%2
SET MAKESMALL=%3
REM
MAGSCANFILM /F:C:\VISTA\IMAGING\TEMP\XRAY2.BIG /LUT:I /PPL:2048
echo Scanning Completed...
%MAKESMALL% C:\VISTA\IMAGING\TEMP\XRAY2.BIG %OUTFILE% /s:1024,1280 /8
echo TGA File Created
REM
REM **********  ABSTRACTS ARE NOW BEING CREATED IN THE IMAGING APPLICATION
REM **********  NOT BY THIS .BAT FILE 
REM
REM ABSTRTGA c:\VISTA\IMAGING\TEMP\xray2.big %ABSFILE% /s:189,122 /8 
REM echo Abstract File Created
PAUSE