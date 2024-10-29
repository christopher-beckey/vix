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

@ECHO OFF
SET OUTFILE="c:\program files\vista\imaging\temp\scantemp.tga"
MAGSCANFILE /F:%OUTFILE% /PD:8 /PPL:1024 /TIF
