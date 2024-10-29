unit fmagMagMakeAbs;

{
 Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created:   2014-12-01
Site Name: Silver Spring, OIFO
Developers: Garrett Kirin /Mantech
[==   unit fmagMagMakeAbs;
Description: Imaging Abstract/Thumbnail maker for BackGroundProcessor.
This application was designed to be called by Windows Messaging.
The BP currently calls an application mag_makeabs.exe to make thumbnails.
it uses windows shell call to wait for mag_makeabs to finish.
Then it checks for error file,  if no error file,  it checks for the Abstract.
..checks file size not zero...
Then considers it a success.

    WinExecAndWait32('Mag_MakeAbs.exe '+params,0,ExeProcessInfo);
      //Check AbsError.txt
   if fileExists(ErrorFile) then begin

This application is fairly large with all the Accusoft Components we use for creating
thumbs, and we don't want to start, Terminate, start, terminate this applicaiton.

So - we make a new "small" app , named (you guessed it ) mag_MakeAbs.exe
That small app will call this app to make the thumbnails.
This app will notify (via Windows Messaging) that the abstract is finished.
 - success or failure.
then that App, getting the message
  - if failure, we put text in the error file
Then Terminate.
When Small app terminates, BP will continue with the Processing of the Abstract.

================  NOTE ====================================================
This is a way to use new abstract maker, without Re-Compiling the BP
something we can't do at the moment
===========================================================================


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
(*  BP Function that calls mag_makeabs
function TMAGBTMF1.MakeAbs(abspath,sourcepath,qptr:string;var msg:string): boolean;
var
  Format: String;
  JPG_CQ,IWL,ErrorFile,text,params :string;
  logfile: textfile;
  ExeProcessInfo: TProcessInformation;
  FileRec:TSearchRec;
begin
    iwl := 'HISTO'; //Image Window Level
    ErrorFile := ExtractFilePath(Application.ExeName)+'MagAbsError.txt';
    Format := 'JPG';
    JPG_CQ := '100';
    params := sourcepath+ ' '+ abspath +' '+ Format + ' '+ JPG_CQ+ ' '+IWL+' '+char(34)+ErrorFile+char(34);
    WinExecAndWait32('Mag_MakeAbs.exe '+params,0,ExeProcessInfo);
      //Check AbsError.txt
   if fileExists(ErrorFile) then begin
     AssignFile(logfile,ErrorFile);
     Reset(logfile);
     Readln(logfile,text);
     msg := piece(text,'^',2);
     if pos('0',piece(text,'^',1)) <> 0 then begin
       msg := ExtractFileName(abspath)+' '+ piece(text,'^',2);
       result := true;
       end
     else begin
       result := false;
       msg :='Make AbstractError / '+ piece(text,'^',2);
       end;
     CloseFile(logfile);
     end;
   if FindFirst(abspath,(faAnyFile),FileRec) = 0 then begin
     result := true;
     if FileRec.Size = 0 then begin
       {$I-}DeleteFile(abspath){$I+};
        if not dmMain.RPCBroker1.Connected then
         dmMain.AutoLogin(dmMain.RPCBroker1,SilentAccess,SilentVerify,VServer,VPort,'SILENT',Division, 5, SELF);
       msg := 'File of size zero created then deleted';
       result := false;
       end;
     end
   else result := false;
   FindClose(FileRec);
end;  //MakeABS
*)

// 'VistA Imaging - Thumbnail Maker'
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, inifiles,
  TlHelp32, ShellApi,
  umagAbsUtil;

type
  TfrmMakeAbs = class(TForm)
    procedure FormCreate(Sender: TObject);
  private

   FParams : string;
   FFull, FAbs : string;
   FTerminateNow : boolean;
    procedure DefaultHandler(var Message);  override;
    procedure SendWindowsMessage(Txt: String);
    function IsExeRunning(const sExeName: String): Boolean;
    function  MagexecutefileFx(Const Filename, Params, DefaultDir: String; ShowCmd: Integer; Oper: String = 'open'): THandle;
    procedure HandleError(val: string);
    function StartThumbMaker(params : String): boolean;
    procedure memadd(s: string);
    procedure GetINISettings;


    { Private declarations }
  public
  Procedure ProcessVistAMessage(XHandle: Hwnd; Vmsg: String);
    procedure InitSetup;
  end;

var
WMIdentifier : word;
  frmMakeAbs: TfrmMakeAbs;
  FappPath, FLogFile , FabsErrorFile : string;
  FThumbMakerHandle : THandle;
  FDebugON : boolean;

implementation

{$R *.dfm}



procedure TfrmMakeAbs.FormCreate(Sender: TObject);
begin
  WMIdentifier := RegisterWindowMessage('VistA Imaging - Thumbnail Maker');
end;

procedure TfrmMakeAbs.InitSetup();
var
  thumbRun : string;
  i : Integer;
  ThumbsUp : boolean;
  sendParams : String;
begin
FAppPath := ExtractFilePath(Application.ExeName);
GetINISettings;
FabsErrorFile := FAppPath +  'MagAbsError.txt';

FLogFile := FAppPath+'log\utility\MagLogThumb.log';
 FFull := Paramstr(1);
 FAbs := Paramstr(2);
  // Before running this code, use the Run/parameters menu option
  // to set the following command line parameters : -parm1 -parm2

  // Show these parameters - note that the 0th parameter is the
  // execution command on Windows
  //memadd('WMIdentifier : ' + inttostr(WMIdentifier));
  Fparams := '';
  if paramcount > 1 then

  for i := 1 to ParamCount do
     begin
     Fparams := Fparams + ' ' + ParamStr(i);
     end;
///  memadd('Params: ' + Fparams);

ThumbsUp := IsEXERunning('MagThumbnailMaker.exe');

if NOT ThumbsUp then
  begin
    SendParams := 'MAKETHUMBNAIL^' + inttostr(self.Handle) + '^' +  FFull + '^' + FAbs;
    if not StartThumbMaker(sendParams) then
      begin
       { MagAbsError.txt     0^Error message or 1^Success}
       WriteToAbsError('0^Failed to start MagThumbMaker.exe', FabsErrorFile );
       memadd('0^Failed to start MagThumbMaker.exe');
       memadd('Terminating');
       application.Terminate;
      exit;
      end
      else
      begin
      memadd('Started Thumbnail Maker: ' + sendparams);
      application.processmessages;
      exit;
      end;
  end;
(*ThumbsUp := IsExeRunning('MagThumbnailMaker.exe');
if Not ThumbsUp then
  begin
    WriteToAbsError('0^Failed to start MagThumbMaker.exe', FabsErrorFile);
    memadd('0^Failed to start MagThumbMaker.exe');
    memadd('Terminating');
    application.Terminate;
    exit;
  end;
  *)

/// memadd('sending windows message to ThumbNailMaker');
 application.processmessages;
 sendwindowsmessage('MAKETHUMBNAIL^' + inttostr(self.Handle) + '^' +  FFull + '^' + FAbs);
end;

procedure TfrmMakeAbs.GetINISettings();
var thini : TiniFile;
debugon : String;
begin
///showmessage('Fapppath ' + Fapppath);
FCheckLog := false;
thini := TiniFile.Create(FApppath + 'MagThumbnailMaker.ini');
try
debugon := thini.ReadString('SETTINGS','DEBUGON','xx');
if (debugon = 'xx')  then
  begin
    debugon := 'FALSE';
    thini.WriteString('SETTINGS','DEBUGON','FALSE');
  end;
FDebugOn := UPPERCASE(debugon)='TRUE';
////showmessage(UPPERCASE(debugon));
finally
  thini.Free;
end;
end;

procedure TfrmMakeAbs.memadd(s : string);
begin
if FDebugON then
  begin
///  showmessage('mma write to log');
  writetolog('mma- '+s,FLogFile);
  end;
end;

function TfrmMakeAbs.StartThumbMaker(params : String): boolean;
var
  OSResult : integer;
begin
  result := true;
 // OSResult := MagExecuteFileFx('MagThumbnailMaker.exe','','',SW_SHOW);
  OSResult := MagExecuteFileFx(FappPath + 'MagThumbnailMaker.exe',params,'',SW_SHOW);
  if OSResult < 33 then
     begin
     result := false;
     //Error Starting the ThumbMaker
     HandleError(SysErrorMessage(OSResult)+ ' '+ IntToStr(OSResult));
     WriteToAbsError('0^Error ' + sysErrorMessage(OSResult) ,FabsErrorFile);
     end;
end;


procedure TfrmMakeAbs.HandleError(val : string);
begin
memadd('Error: ' + val);
end;

Procedure TfrmMakeAbs.DefaultHandler(Var Message);
Var
  Buffer: Array[0..255] Of Char;
Begin
  Inherited DefaultHandler(Message);
  Try
    FTerminateNow := false ;
    With TMessage(Message) Do
    Begin
      If Msg = WMIdentifier Then
      Begin
        result := 0;
        If GlobalGetAtomName(LParam, Buffer, 255) = 0
           Then Strpcopy(Buffer, 'NO TEXT SENT');

        If WParam = Application.Handle
           Then exit;

        ProcessVistAMessage(WParam, Strpas(Buffer));
      End;
    End;
  Except
        //showmessage('Error in Default Handler');
  End;
  if FTerminateNow then
    begin
    memadd('Terminating');
    application.Terminate;
    end;
End;

Procedure TfrmMakeAbs.ProcessVistAMessage(XHandle: Hwnd; Vmsg: String);
Begin
  memadd('Recieved  message:' +  Vmsg);
  if pos('THUMBNAILDONE',Vmsg) > 0
    then FterminateNow := true;
end;


Procedure TfrmMakeAbs.SendWindowsMessage(Txt: String);
Var
  Buffer: Array[0..255] Of Char;
  Atom: TAtom;
  res : integer;
  iHandle : Thandle;
  msg : string;
  begin
  FThumbMakerHandle := FindWindow(PChar('TfrmThumbnailMaker'),PChar('Imaging Thumbnail Maker')) ;
///  memadd('ThumbNailMaker Handle... ' + inttostr(FThumbMakerHandle));
  if FThumbMakerHandle = 0 then
    begin
      memadd('ThumbnailMaker handle not Found.');
      exit;
    end;

  Atom := GlobalAddAtom(Strpcopy(Buffer, Txt));
  if FThumbMakerHandle  >  0
      then
        begin
        iHandle := FThumbMakerHandle;
        msg := 'Message sent: ';
        end
      else
        begin
        iHandle := HWND_BROADCAST;
        msg := 'Message BROADCAST: ';
        end;
  //  SendMessage(HWND_Broadcast, WMIdentifier, Application.Handle, Atom);
  memadd(msg + txt);
  SendMessage(iHandle, WMIdentifier, Application.Handle, Atom);
  GlobalDeleteAtom(Atom);
End;

Function TfrmMakeAbs.IsExeRunning(const sExeName : String): Boolean;
var
SnapProcHandle: THandle;
ProcEntry: TProcessEntry32;
NextProc: Boolean;
begin
  result := False;
  SnapProcHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if SnapProcHandle = INVALID_HANDLE_VALUE
    then EXIT;

  ProcEntry.dwSize := SizeOf(ProcEntry);
  NextProc := Process32First(SnapProcHandle, ProcEntry);
  while NextProc do
  begin
    if UpperCase(StrPas(ProcEntry.szExeFile)) = UpperCase(sExeName)
      then
      begin
      result := True;
      break;
      end;
    NextProc := Process32Next(SnapProcHandle, ProcEntry);
  end;
  CloseHandle(SnapProcHandle);
end;


Function TfrmMakeAbs.MagexecutefileFx(Const Filename, Params, DefaultDir: String; ShowCmd: Integer; Oper: String = 'open'): THandle;
Var
  ZOper, ZFileName, ZParams, ZDir: Array[0..279] Of Char;
  myfilename, myparams: String;
Begin
  myfilename := Filename;
  myparams := Params;
  If Copy(myfilename, 1, 1) <> '"' Then myfilename := '"' + myfilename + '"';
  If Copy(myparams, 1, 1) <> '"' Then myparams := '"' + myparams + '"';

//v//  //                              HWND                lpOperation
//v//   Result := ShellExecute(Application.MainForm.Handle, Strpcopy(ZOper, Oper),

 //                              HWND                lpOperation
  Result := ShellExecute(self.Handle, Strpcopy(ZOper, Oper),
      //      lpFile                      lpParameters
      Strpcopy(ZFileName, myFileName), Strpcopy(ZParams, myParams),
      //      lpDirectory          nShowCmd
      Strpcopy(ZDir, DefaultDir), ShowCmd);
End;


end.

