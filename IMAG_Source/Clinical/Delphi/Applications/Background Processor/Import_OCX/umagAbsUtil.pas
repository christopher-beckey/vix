unit umagAbsUtil;

{
 Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created:   2014-12-10
Site Name: Silver Spring, OIFO
Developers: Garrett Kirin/Mantech
[==   unit umagAbsUtil;
Description: util routine for Imaging Thumbnail maker for BackGroundProcessor.

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

interface
Uses
   SysUtils
   ,fmxutils
   ,dateutils
   ;

procedure WriteToAbsError(msg : string; absErrorFile : string);
procedure writetoLog(msg : string; absLogFile : string);
Function MagPiece(Str, Del: String; Piece: Integer): String;
procedure checklog(absLogFile : string);
procedure ManageLogFiles(logdir : string);

 var
 FlogsizeKB : integer;
 FcheckLog :  boolean;
implementation



{ *******************    MagAbsError.txt ********************
  This utility writes to MagAbsError.txt.   this is querried after mag_MakeAbs is finished
  processing
    - it has one line of text.
    0^ Error message
    or
    1^Success.
}
procedure WriteToAbsError(msg : string; AbsErrorFile: string);
var errFile :Textfile;
OSError : integer;
begin
{$I-}
  OSError := GetLastError;
  AssignFile(errFile,AbsErrorFile);
  ReWrite(errFile);
  Writeln(errFile,msg);
  CloseFile(errFile);
{$I+}
  OSError := GetLastError;
  if OSError <> 0 then
   //Windows.MessageBox(frmMagPurge.Handle,PChar('Error writing to the log file 2: '+IntToStr(Error)),'',MB_SYSTEMMODAL);
end;

procedure writetoLog(msg : string; absLogFile : String);
var logFile :Textfile;
OSError : integer;
when : string;
begin
if FCheckLog then checklog(absLogFile);
when := FormatDateTime('dd hh:nn:ss', now);
msg := when + ' - ' + msg;
{$I-}
  AssignFile(logFile,absLogFile);
  if not fileexists(absLogFile)
    then  ReWrite(LogFile)
    else  Append(logFile);
  Writeln(LogFile,msg);
  CloseFile(LogFile);
{$I+}
  OSError := GetLastError;
  if OSError <> 0 then
   //Windows.MessageBox(frmMagPurge.Handle,PChar('Error writing to the log file 2: '+IntToStr(Error)),'',MB_SYSTEMMODAL);
end;





Function MagPiece(Str, Del: String; Piece: Integer): String;
Var
  i, k: Integer;
  s: String;
Begin
  i := Pos(Del, Str);
  If (i = 0) And (Piece = 1) Then
  Begin
    Result := Str;
    Exit;
  End;
  For k := 1 To Piece Do
  Begin
    i := Pos(Del, Str);
    If (i = 0) Then i := Length(Str) + 1;
    s := Copy(Str, 1, i - 1);
    Str := Copy(Str, i + 1, Length(Str));
  End;
  Result := s;
End;


procedure checklog(absLogFile : string);
var
  vDebugLogFile :  TextFile;
   curLogfilesize : integer;
   LogDir : string;
   LogFile : string ;
   NewName: string;

begin
LogDir :=   extractFileDir(absLogFile);
LogFile := extractfileName(absLogFile);

   if not directoryexists(LogDir)  then  forcedirectories(LogDir);
   if not DirectoryExists(LogDir) then   EXIT;
     begin
       //lgm('Failed to Create Directory : ' + LogDir + ' Debug To Log File is off.');
       //self.FDebugToFileON := false;
       //EXIT;
     end;


   if fileexists(absLogFile) then
      begin
          curLogfilesize := (fmxutils.GetFileSize(absLogFile) Div 1024) + 1 ;
          if curLogfilesize > FlogsizeKB then    //100
             begin
             newName := logDir + '\MagLogThumb'+ FormatDateTime('yymmdd_hhnnss', NOW)+'.log';
             RenameFile(absLogFile,newname);
             end ;
    end;
 ManageLogFiles(LogDir);
end;


procedure ManageLogFiles(logdir : string);
Var
  DT : TDateTime;
  DaysOld : integer;

  SearchRec: TSearchRec;
begin

if NOT directoryexists(LogDir) then EXIT;
     if (copy(LogDir,length(LogDir),1) <> '\')
       then LogDir := LogDir +'\';

{ Clean out the Log directory any file more than 1 day  old. }



  If FindFirst(LogDir + 'MagLogThumb*.*', FaAnyFile, SearchRec) = 0 Then
  Begin
    DT := FileDateToDateTime(SearchRec.time);
    //s := formatdatetime('yyyy/mm/dd hh:nn:ss',dt);
    DaysOLD := DaysBetween(Now, DT);
    if (DaysOld > 1 ) then DeleteFile(logdir + SearchRec.Name);
    While FindNext(SearchRec) = 0 Do
       begin
         DT := FileDateToDateTime(SearchRec.time);
       //s := formatdatetime('yyyy/mm/dd hh:nn:ss',dt);
       DaysOLD := DaysBetween(Now, DT);
       if (DaysOld > 1 ) then DeleteFile(logdir + SearchRec.Name);
       end;
  End;
end;
end.
