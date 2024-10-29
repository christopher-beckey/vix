Unit MagExeWait;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging Utilities for opening other application.
   Note:
   }
(*
   ;; +---------------------------------------------------------------------------------------------------+
   ;; Property of the US Government.
   ;; No permission to copy or redistribute this software is given.
   ;; Use of unreleased versions of this software requires the user
   ;;  to execute a written test agreement with the VistA Imaging
   ;;  Development Office of the Department of Veterans Affairs,
   ;;  telephone (301) 734-0100.
   ;;
   ;; The Food and Drug Administration classifies this software as
   ;; a medical device.  As such, it may not be changed
   ;; in any way.  Modifications to this software may result in an
   ;; adulterated medical device under 21CFR820, the use of which
   ;; is considered to be a violation of US Federal Statutes.
   ;; +---------------------------------------------------------------------------------------------------+
*)

Interface
Uses
  Windows
  ;

//Uses Vetted 20090929:StdCtrls, Dialogs, Forms, Controls, Graphics, Classes, Messages, SysUtils

Function WinExecAndWait32(Filename: String; Visibility: Integer; Var XProcessInfo: TprocessInformation): Integer;
Function WinExecNoWait32(Filename: String; Visibility: Integer; Var XProcessInfo: TprocessInformation): Integer;
Function GetExitCode(Var XProcessInfo: TprocessInformation): Integer;
Function MagTerminateProcess(Exitcode: Integer; Var XProcessInfo: TprocessInformation): Boolean;
Function IsProcessRunning(Var XProcessInfo: TprocessInformation): Boolean;

Implementation
Uses
  SysUtils
  ;

{ var
 xProcessInfo: TprocessInformation;}

Function WinExecAndWait32(Filename: String; Visibility: Integer; Var XProcessInfo: TprocessInformation): Integer;
Var
  ZAppName: Array[0..512] Of Char;
  ZCurDir: Array[0..255] Of Char;
  WorkDir: String;
  StartupInfo: TStartupInfo;
Begin
  Strpcopy(ZAppName, Filename);
  GetDir(0, WorkDir);
  Strpcopy(ZCurDir, WorkDir);
  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  StartupInfo.cb := SizeOf(StartupInfo);

  StartupInfo.DwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.WShowWindow := Visibility;
  If Not CreateProcess(Nil,
    ZAppName, { pointer to command line string }
    Nil, { pointer to process security attributes }
    Nil, { pointer to thread security attributes }
    False, { handle inheritance flag }
    CREATE_NEW_CONSOLE Or { creation flags }
    NORMAL_PRIORITY_CLASS,
    Nil, { pointer to new environment block }
    Nil, { pointer to current directory name }
    StartupInfo, { pointer to STARTUPINFO }
    XProcessInfo) Then
    Result := -1 { pointer to PROCESS_INF }

  Else
  Begin
    Result := 0; //Hints and Warnings
    WaitForSingleObject(XProcessInfo.HProcess, INFINITE);
    //3to5    GetExitCodeProcess(xProcessInfo.hProcess, Result);
  End;
End;

Function WinExecNoWait32(Filename: String; Visibility: Integer; Var XProcessInfo: TprocessInformation): Integer;
Var
  ZAppName: Array[0..512] Of Char;
  ZCurDir: Array[0..255] Of Char;
  WorkDir: String;
  StartupInfo: TStartupInfo;
  { ProcessInfo:TProcessInformation;}
Begin
  Strpcopy(ZAppName, Filename);
  GetDir(0, WorkDir);
  Strpcopy(ZCurDir, WorkDir);
  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  StartupInfo.cb := SizeOf(StartupInfo);

  StartupInfo.DwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.WShowWindow := Visibility;
  If Not CreateProcess(Nil,
    ZAppName, { pointer to command line string }
    Nil, { pointer to process security attributes }
    Nil, { pointer to thread security attributes }
    False, { handle inheritance flag }
    CREATE_NEW_CONSOLE Or { creation flags }
    NORMAL_PRIORITY_CLASS,
    Nil, { pointer to new environment block }
    Nil, { pointer to current directory name }
    StartupInfo, { pointer to STARTUPINFO }
    XProcessInfo) Then
    Result := -1 { pointer to PROCESS_INF }

  Else
  Begin
    Result := 0; //Hints and Warnings
    WaitForSingleObject(XProcessInfo.HProcess, 0);
    //3to5    GetExitCodeProcess(xProcessInfo.hProcess, Result);
  End;
End;

Function GetExitCode(Var XProcessInfo: TprocessInformation): Integer;
Var
  DwordResult: DWORD;
Begin
    //function GetExitCodeProcess(hProcess: THandle; var lpExitCode: DWORD): BOOL; stdcall;
  GetExitCodeProcess(XProcessInfo.HProcess, DwordResult);
  Result := DwordResult;
End;
{ This code came from Lloyd's help file! }

Function MagTerminateProcess(Exitcode: Integer; Var XProcessInfo: TprocessInformation): Boolean;
Begin
  Result := TerminateProcess(XProcessInfo.HProcess, Exitcode);
End;

Function IsProcessRunning(Var XProcessInfo: TprocessInformation): Boolean;
Var
  x: Integer;
Begin
  Result := True;
  x := GetExitCode(XProcessInfo);
  If x <> 259 Then
    Result := False

End;
End.
