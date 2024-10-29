unit fmagThumbnailMaker;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs ,   Shellapi,
  extctrls  , inifiles
  , umagThumbMgr,umagAbsUtil,  fmxUtils,  fmagAbout, umagutils8,
  OleCtrls, GearVIEWLib_TLB, StdCtrls, FileCtrl, Menus
  , magfileversion;

type
  TfrmThumbnailMaker = class(TForm)
    Memo1: TMemo;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Panel3: TPanel;
    IGPageViewCtl1Thumb: TIGPageViewCtl;
    Panel4: TPanel;
    Label1: TLabel;
    lbStatus: TLabel;
    lbFull: TLabel;
    Splitter2: TSplitter;
    Label2: TLabel;
    Label3: TLabel;
    lbCurImage: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    Label5: TLabel;
    lbNetPath: TLabel;
    MainMenu1: TMainMenu;
    mnuFile: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Options1: TMenuItem;
    Clearmemo1: TMenuItem;
    mnuVersions: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure About1Click(Sender: TObject);
    procedure Clearmemo1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure mnuVersionsClick(Sender: TObject);
  private
   FWinMsg : string;
    procedure memadd(s: string ; ShowDtTm : boolean = False);
    procedure SendWindowsMessage(Txt: String);
    procedure ProcessVistAMessage(XHandle: Hwnd; Vmsg: String);
    procedure DefaultHandler(var Message);    override;
    function MagPiece(Str, Del: String; Piece: Integer): String;
    function Magexecutefile(Const Filename, Params, DefaultDir: String; ShowCmd: Integer; Oper: String = 'open'): THandle;
    procedure CallMakeThumbForImage(image, abs: string);
    procedure GetINISettings;
    procedure GetFormPosition(Form: TForm; XDirectory: String = '');
    procedure SaveFormPosition(Form: TForm; XDirectory: String = '');

    { Private declarations }
  public
    AppPath : string;
    FThumbClosing : boolean;
    { Public declarations }
  end;

var
  frmThumbnailMaker: TfrmThumbnailMaker;
  WMIdentifier : word;
  FAbsHandle : integer;
  FisPaintedAlready : boolean;
  FThumbINI : string;
  FDebugOn : boolean;

implementation

{$R *.dfm}

procedure TfrmThumbnailMaker.CallMakeThumbForImage(image, abs : string);
var absOk : boolean;
 emsg , retmsg : string;
 netpath : string;
begin
  absOk := false;
  retmsg := '';
  emsg := '1^Error Creating abstract';
try
  lbFull.Caption := image;
  if not MakeThumbForImage(image, abs, IGPageViewCtl1Thumb , retmsg) then
     begin
       if retmsg <> '' then emsg := '1^' + retmsg;
     end;
  IGPageViewCtl1thumb.UpdateView;
  if fileexists(abs) then
      begin
      if GetFileSize(abs) > 0  // fmxUtils
         then absOk := true
         else emsg := '1^Abstract size is 0';
      end;
  if absOk
    then emsg := '0^Success';
  netpath := ExtractFilePath(abs);
  if lbNetPath.caption <> netpath then
    begin
    memadd(' ------------------------------------');
    lbnetPath.caption := netpath;
    lbNetPath.update;
    memadd('Network Share:   ' + lbNetPath.caption);
    memadd('  ');

    end;

  lbfull.Caption := image;
  lbStatus.Caption := emsg;

finally
  lbCurImage.caption := 'waiting....';
  lbCurImage.Update;
  memadd('      ' + ExtractFileName(abs) + '         ' + emsg,True);
  writeToAbsError(emsg, AppPath + 'MagAbsError.txt');
end;
end;


procedure TfrmThumbnailMaker.Clearmemo1Click(Sender: TObject);
begin
memo1.lines.Clear;
end;

procedure TfrmThumbnailMaker.About1Click(Sender: TObject);
begin
  frmAbout.Execute(AppPath + 'MagThumbnailMaker.exe');
end;

procedure TfrmThumbnailMaker.memadd(s : string; ShowDtTm : boolean = False);
var logfile : string;
 i : integer;
begin
  if ShowDtTm then
  s := formatdatetime('mm/dd/yy   hh:nn:ss         ',now) + s;
  memo1.lines.add(s);
  if FDebugON then
     begin
///     showmessage('writing to log file' );
     logfile := AppPath + 'log\Utility\MagLogThumb.log';
     writetolog(s,logfile);
     end;
 if memo1.Lines.Count > 500 then    //800
   begin
     memo1.Visible := false;
     for i := 0 to  99 do memo1.Lines.Delete(0);   //200
     memo1.visible := true;

   end;


end;

procedure TfrmThumbnailMaker.mnuVersionsClick(Sender: TObject);
var s,appname : string;
  x,y,z : string;
  pf, ipath : string;
  bp, verifier, purge, thumb, mma, iocx  : string;
  fdesc : string;
begin
x :=  GetEnvironmentVariable('COMMONPROGRAMFILES');
pf :=  GetEnvironmentVariable('PROGRAMFILES');
ipath :=   pf +'\vista\imaging\backproc';

  //frmAbout.Execute(AppPath + 'MagThumbnailMaker.exe');
 appname := ipath + '\magbtm.exe';
   x := AppName;
   if fileexists(x) then
   begin
   y := Inttostr((Getfilesize(AppName) Div 1024) + 1) + ' KB';
   z := Formatdatetime('mm/dd/yy  h:nn  am/pm', FILEDATETIME(AppName));
    s := MagGetFileVersionInfo(AppName, False);
    fdesc :=  'BP Queue Processor' ;
    //fdesc := MagGetFileDescription(AppName);
   BP := fdesc + #13 +  x + #13 + y + '    ' + z + #13 + s;
   end
   else
   BP := 'File Does''t exist : ' + x;


  appname := ipath + '\magVerifier.exe';
   x := AppName;
   if fileexists(x) then
   begin
   y := Inttostr((Getfilesize(AppName) Div 1024) + 1) + ' KB';
   z := Formatdatetime('mm/dd/yy  h:nn  am/pm', FILEDATETIME(AppName));
    s := MagGetFileVersionInfo(AppName, False);
    fdesc :=  'Mag Verifier' ; //MagGetFileDescription(AppName);
    //fdesc :=  MagGetFileDescription(AppName);
   verifier := fdesc + #13 +  x + #13 + y + '    ' + z + #13 + s;
   end
   else
   verifier := 'File Does''t exist : ' + x;


 appname := ipath + '\magPurge.exe';
   x := AppName;
   if fileexists(x) then
   begin
   y := Inttostr((Getfilesize(AppName) Div 1024) + 1) + ' KB';
   z := Formatdatetime('mm/dd/yy  h:nn  am/pm', FILEDATETIME(AppName));
    s := MagGetFileVersionInfo(AppName, False);
    fdesc :=  'Mag Purge' ; //MagGetFileDescription(AppName);
    //fdesc :=  MagGetFileDescription(AppName);
   Purge := fdesc + #13 +  x + #13 + y + '    ' + z + #13 + s;
   end
   else
   Purge := 'File Does''t exist : ' + x;


    appname := ipath + '\MagThumbnailmaker.exe';
   x := AppName;
   if fileexists(x) then
   begin
   y := Inttostr((Getfilesize(AppName) Div 1024) + 1) + ' KB';
   z := Formatdatetime('mm/dd/yy  h:nn  am/pm', FILEDATETIME(AppName));
    s := MagGetFileVersionInfo(AppName, False);
    fdesc :=  MagGetFileDescription(AppName);
   Thumb := fdesc + #13 + x + #13 + y + '    ' + z + #13 + s;
   end
   else
   thumb := 'File Does''t exist : ' + x;

    appname := ipath + '\mag_makeabs.exe';
   x := AppName;
   if fileexists(x) then
   begin
   y := Inttostr((Getfilesize(AppName) Div 1024) + 1) + ' KB';
   z := Formatdatetime('mm/dd/yy  h:nn  am/pm', FILEDATETIME(AppName));
    s := MagGetFileVersionInfo(AppName, False);
    fdesc :=  MagGetFileDescription(AppName);
   mma := fdesc + #13 + x + #13 + y + '    ' + z + #13 + s;
   end
   else
   mma := 'File Does''t exist : ' + x;

    appname := pf  + '\vista\imaging\lib\magimportxcontrol1.ocx';
   x := AppName;
   if fileexists(x) then
   begin
   y := Inttostr((Getfilesize(AppName) Div 1024) + 1) + ' KB';
   z := Formatdatetime('mm/dd/yy  h:nn  am/pm', FILEDATETIME(AppName));
    s := MagGetFileVersionInfo(AppName, False);
    fdesc :=  MagGetFileDescription(AppName);
   iocx := fdesc + #13 +  x + #13 + y + '    ' + z + #13 + s;
   end
   else
   iocx := 'File Does''t exist : ' + x;

showmessage('VistA Imaging - Background Processor (BP)  '
            + #13 + '      and BP Utility Versions:'
            + #13 + #13 + BP
            + #13 + #13 + verifier
            + #13 + #13 + purge
            + #13 + #13 + THUMB
            + #13 + #13 + MMA
            + #13 + #13 + iocx );


end;

procedure TfrmThumbnailMaker.FormClose(Sender: TObject; var Action: TCloseAction);
var
 s : string;
begin
 s := 'Make sure the Background Processor is "Stopped" '+ #13
   + 'before Closing the Thumbnail Maker'     ;
if messagedlg(s,mtconfirmation,[mbOk,mbCancel],0) = mrcancel
  then
  begin
  action := caNone;
  exit;
  end;
FThumbClosing := True;
//application.processmessages;
//sendwindowsmessage('THUMBNAILDONE');
application.processmessages;
saveformposition(self as Tform);
end;

procedure TfrmThumbnailMaker.FormCreate(Sender: TObject);
begin
FThumbClosing := false;
 lbCurImage.Caption := '';
 lbFull.caption := '';
 lbStatus.Caption := '';
 lbNetPath.caption  := '';
  WMIdentifier := RegisterWindowMessage('VistA Imaging - Thumbnail Maker');
  Apppath := extractfilepath(application.ExeName);
  memo1.align := alclient;
  FisPaintedAlready := false;


end;

procedure TfrmThumbNailmaker.GetINISettings();
var thini : TiniFile;
debugon : String;
kbs : string;
begin
thini := TiniFile.Create(Apppath + 'MagThumbnailMaker.ini');
try
debugon := thini.ReadString('SETTINGS','DebugON','xx');
///showmessage('debug on from ini: ' + debugon);
if (debugon = 'xx')  then
  begin
    debugon := 'FALSE';
    thini.WriteString('SETTINGS','DebugON','FALSE');
  end;
FDebugOn := UPPERCASE(debugon)='TRUE';

kbs := thini.ReadString('SETTINGS','LogFileSizeKB','0');
 if kbs='0' then
   begin
   kbs := '300';
   thini.writestring('SETTINGS','LogFileSizeKB',kbs);
   end;
try
Flogsizekb := strtoint(kbs);
FCheckLog := true;
except
  FlogsizeKB := 300;
  kbs := '300';
  thini.writestring('SETTINGS','LogFileSizeKB',kbs);
end;


finally
  thini.Free;
end;
end;

procedure TfrmThumbnailMaker.FormDestroy(Sender: TObject);
begin

//saveformposition(self as Tform);
end;

procedure TfrmThumbnailMaker.FormPaint(Sender: TObject);
Var
 msg, Full, Abs : string;
 vmsg : string;
 absHandle : integer;
 i : integer;
begin
  if FisPaintedAlready
     then exit;
  FisPaintedAlready := true;
  GetINISettings;
  GetFormPosition(self as Tform);
  if paramcount > 0  then
    begin
    //for i := 0 to Paramcount do
    //  begin
    //  memadd('Param(' + inttostr(i) + ')  ' + paramstr(i));
    //  end;
    vmsg := paramstr(1);
    FAbsHandle := 0;
    memadd('Command Line Params: ' + Vmsg)        ;
    if Vmsg = ''
      then exit;
    
    msg  := magpiece(Vmsg,'^',1);
    absHandle := strtoint(magpiece(Vmsg,'^',2));
    Full := magpiece(Vmsg,'^',3);
    abs  := magpiece(Vmsg,'^',4);
    if UPPERCASE(msg) = 'MAKETHUMBNAIL' then
       begin
       FabsHandle := abshandle;
       CallMakeThumbForImage(full, abs);
       end;
    if FAbsHandle > 0
      then  sendwindowsmessage('THUMBNAILDONE^'+abs);
    end;
end;

Procedure TfrmThumbnailMaker.DefaultHandler(Var Message);
Var
  Buffer: Array[0..255] Of Char;
Begin
  Inherited DefaultHandler(Message);
  if FThumbClosing then exit;
  Try
    With TMessage(Message) Do
    Begin
      If Msg = WMIdentifier Then
      Begin
        result := 0;
        If GlobalGetAtomName(LParam, Buffer, 255) = 0 Then
          Strpcopy(Buffer, 'NO TEXT SENT');
        If WParam = Application.Handle
            //'windows message from This Window - "' + Strpas(Buffer) + '"'
           Then Exit
           Else
             begin
              if NOT FThumbClosing then
                ProcessVistAMessage(WParam, Strpas(Buffer));
             end;
      End;
    End;
  Except
        //showmessage('Error in Default Handler');
  End;
End;

procedure TfrmThumbnailMaker.Exit1Click(Sender: TObject);
begin
close;
end;

Procedure TfrmThumbnailMaker.ProcessVistAMessage(XHandle: Hwnd; Vmsg: String);
Var
 msg, Full, Abs : string;
 absHandle : integer;
Begin

FAbsHandle := 0;
//memAdd('WinMsg: ' + Vmsg)        ;
msg  := magpiece(Vmsg,'^',1);
absHandle := strtoint(magpiece(Vmsg,'^',2));
Full := magpiece(Vmsg,'^',3);
abs  := magpiece(Vmsg,'^',4);
if UPPERCASE(msg) = 'MAKETHUMBNAIL' then
  begin
    lbCurImage.Caption := Full;
    lbCurImage.Update;
    FabsHandle := abshandle;
    CallMakeThumbForImage(full, abs);
  end;
 if FAbsHandle > 0  then  sendwindowsmessage('THUMBNAILDONE^' + abs);
end;

Procedure TfrmThumbnailMaker.SendWindowsMessage(Txt: String);
Var
  Buffer: Array[0..255] Of Char;
  Atom: TAtom;
  receiverHandle : THandle;
  res : integer;
  (*  THUMBNAILDONE  is what needs sent to mag_MakeAbs.  *)
  begin
  if FAbsHandle > 0
     then receiverHandle := FabsHandle
     else receiverHandle := HWND_BROADCAST;
  Atom := GlobalAddAtom(Strpcopy(Buffer, Txt));
  SendMessage(receiverHandle, WMIdentifier, Application.Handle, Atom);
  GlobalDeleteAtom(Atom);
End;

{*  --------------------------
 next functions are copies of needed functions.  ..keep all in one small pas file
    -------------------------- }

Function TfrmThumbnailMaker.MagPiece(Str, Del: String; Piece: Integer): String;
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


Function TfrmThumbnailMaker.Magexecutefile(Const Filename, Params, DefaultDir: String; ShowCmd: Integer; Oper: String = 'open'): THandle;
Var
  ZOper, ZFileName, ZParams, ZDir: Array[0..279] Of Char;
  myfilename, myparams: String;
Begin
  myfilename := Filename;
  myparams := Params;
  If Copy(myfilename, 1, 1) <> '"' Then myfilename := '"' + myfilename + '"';
  If Copy(myparams, 1, 1) <> '"' Then myparams := '"' + myparams + '"';

 //                              HWND                lpOperation
  Result := ShellExecute(Application.MainForm.Handle, Strpcopy(ZOper, Oper),
  //      lpFile                      lpParameters
    Strpcopy(ZFileName, myFileName), Strpcopy(ZParams, myParams),
  //      lpDirectory          nShowCmd
    Strpcopy(ZDir, DefaultDir), ShowCmd);
End;

Procedure TfrmThumbnailMaker.SaveFormPosition(Form: TForm; XDirectory: String = '');
var ismin : boolean;
Begin
  ismin := (frmThumbnailmaker.WindowState = wsMinimized);
  if application.Terminated then exit;

  try
  //If Form.WindowState <> Wsnormal Then Exit;
  //thini := TiniFile.Create(Apppath + 'MagThumbnailMaker.ini');
  With TIniFile.Create(Apppath + 'MagThumbnailMaker.ini') Do
  Begin
    Try
      Writestring('SYS_LastPositions', Form.Name, Inttostr(Form.Left) + ',' + Inttostr(Form.Top) + ',' +
        Inttostr(Form.Width) + ',' + Inttostr(Form.Height));
      WriteString('SYS_PanelPositions','Panels',inttostr(panel2.Height)+','+ inttostr(panel3.width));
      WriteBool('SYS_PanelPositions','Minimized',ismin);
    Finally
      Free;
    End;
  End;
  except
    on E:Exception do
      memadd('MagPositions.SaveFormPosition (Form.Name = ' + Form.Name + ') exception = ' + E.Message);
  end;
End;

Procedure TfrmThumbnailMaker.GetFormPosition(Form: TForm; XDirectory: String = '');
Var
  FORMpos, PanelPos: String;
  IsMinimized : boolean;
  Wrksarea: TMagScreenArea;
Begin
  With TIniFile.Create(Apppath + 'MagThumbnailMaker.ini') Do
  Begin
    Try
      FORMpos := ReadString('SYS_LastPositions', Form.Name, 'NONE');
      Panelpos := ReadString('SYS_PanelPositions','Panels','0');
      IsMinimized := ReadBool('SYS_PanelPositions','Minimized',FALSE);
    Finally
      Free;
    End;
  End;
  If FORMpos <> 'NONE' Then
  Begin
    If ((Form.BorderStyle = bsSizeToolWin) Or (Form.BorderStyle = bsSizeable)) Then
      Form.SetBounds(Strtoint(MagPiece(FORMpos, ',', 1)), Strtoint(MagPiece(FORMpos, ',', 2)),
        Strtoint(MagPiece(FORMpos, ',', 3)), Strtoint(MagPiece(FORMpos, ',', 4)))
    Else
    Begin
      Form.Left := Strtoint(MagPiece(FORMpos, ',', 1));
      Form.Top := Strtoint(MagPiece(FORMpos, ',', 2));
    End;
  End;
  Wrksarea := GetScreenArea;
  Try
    If (Form.Left + Form.Width) > Wrksarea.Right Then Form.Left := Wrksarea.Right - Form.Width;
    If (Form.Top + Form.Height) > Wrksarea.Bottom Then Form.Top := Wrksarea.Bottom - Form.Height;
    If (Form.Top < Wrksarea.Top) Then Form.Top := Wrksarea.Top;
    If (Form.Left < Wrksarea.Left) Then Form.Left := Wrksarea.Left;

  Finally
    Wrksarea.Free;
  End;
  if panelpos <> '0' then
    begin
    panel2.Height := strtoint(magpiece(panelpos,',',1));
    panel3.Width := strtoint(magpiece(panelpos,',',2));
    end;
  if IsMinimized then self.WindowState := wsMinimized;

End;

end.
