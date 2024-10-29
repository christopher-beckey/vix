::Recursively list the files in the current directory and its descendants, including any folders that are empty, to a .txt file that you can open in Excel using the pipe symbol (|) as a delimiter
::If a directory argument/parameter is specified on the command line, switch to that directory first as a temporary working folder
::If you open the .txt file in Excel and want to sort by date&time, specify the second date&time field (the one that looks like yyyyMMddHHmmss) to be Text
@echo off
setlocal
set thisDirWithEndingBackslash=%~dp0

::================================= SEE IF COMMAND-LINE ARGUMENT IS SPECIFIED, AND IF SO, PUSHD THERE
if "%1"=="" goto DoneArg
set argDir=%1
pushd "%1"

:DoneArg
set myDir=%cd%
Call:RemoveSpecialCharacters "%myDir%" myDirNoSpecialChars
Call:DateTime dateTime

::================================= RUN THE PROGRAM SAVING OUTPUT
@echo on
%thisDirWithEndingBackslash%RecursiveFoldersFiles.exe > %thisDirWithEndingBackslash%%myDirNoSpecialChars%%dateTime%.txt
@echo off
if "%argDir%"=="" goto :DoneRun
popd
:DoneRun
goto :EOF

::================================= SUBROUTINE: GIVEN A STRING, REPLACE SPECIAL CHARACTERS WITH AN UNDERSCORE (_) AND RETURN RESULT IN GIVEN ARGUMENT VARIABLE
:RemoveSpecialCharacters
SET string=%1
::SET string1=%string:,=COMMA%
::SET string2=%string1:;=SEMICOLON%
::SET string3=%string2::=FULLCOLON%
::SET string4=%string2:\=BACKSLASH%
SET stringNoDoubleQuotes=%string:"=%
SET string1=%stringNoDoubleQuotes::=_%
SET string2=%string1:\=_%
::echo string2 is %string2%
SET %~2=%string2%
exit /B 0

::============================================================================================= SUBROUTINE: GET THE DATE AND TIME, SET CURR_X VARIABLES, AND RETURN RESULT IN GIVE ARGUMENT VARIABLE
:DateTime
set CURR_YYYY=%date:~10,4%
set CURR_MM=%date:~4,2%
set CURR_DD=%date:~7,2%
set CURR_HH=%time:~0,2%
if %CURR_HH% lss 10 (set CURR_HH=0%time:~1,1%)

set CURR_NN=%time:~3,2%
set CURR_SS=%time:~6,2%
set CURR_MS=%time:~9,2%

set %~1=%CURR_YYYY%%CURR_MM%%CURR_DD%%CURR_HH%%CURR_NN%%CURR_SS%
exit /B 0