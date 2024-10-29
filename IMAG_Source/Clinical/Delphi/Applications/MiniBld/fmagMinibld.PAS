Unit fmagMinibld;

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
//{$DEFINE TESTING}
Interface

Uses
  SysUtils,
  WinTypes,
  WinProcs,
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Magguini,
  Fmxutils,
  Stdctrls,
  ExtCtrls,
  Inifiles,
  Buttons;

Type
  TfrmMiniBld = Class(TForm)
    Panel1: Tpanel;
    msglb: Tlabel;
    Label1: Tlabel;
    Bevel1: TBevel; //
    Timer1: TTimer;
    bClose: TBitBtn;
    btnViewMsg: TBitBtn;
    Memo1: TMemo;
    Procedure FormCreate(Sender: Tobject);
    Procedure Timer1Timer(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure btnViewMsgClick(Sender: Tobject);
    Procedure bCloseClick(Sender: Tobject);
  Private
    Procedure Msg(s: String); { Private declarations }
  Public
    Procedure CheckForUpdates;
    { Public declarations }
  End;

Var
  frmMiniBld: TfrmMiniBld;
  Windir: PChar;
  UPDIR: String;
Const
  checkcomplete: Boolean = False;
Const
  rebooting: Boolean = False;
Implementation

{$R *.DFM}
{function GetComputerName(lpBuffer: PChar; var nSize: DWORD): BOOL; stdcall;}

Procedure TfrmMiniBld.Msg(s: String);
Begin
  Memo1.Lines.Add(s);
  msglb.caption := s;
  msglb.Update;
End;

Procedure TfrmMiniBld.CheckForUpdates;
Var
  Magini, UPDATEINI: TIniFile;
  DATEUPDIR, s: String;
  p: PChar;
  dw: DWORD;
  INIENTRY, UPDATEFILE: String;
Begin
  bCLOSE.Enabled := True;
  bClose.SetFocus;
  p := Stralloc(100);
  dw := 100;

  UPDATEFILE := ParamStr(1);
  INIENTRY := ParamStr(2);

  Msg('Input parameters  : ');
  Msg('    Updatefile  - ' + updatefile);
  Msg('    inientry    - ' + INIENTRY);

  If UPDATEFILE = '' Then UPDATEFILE := 'MAGSETUP.EXE';
  If INIENTRY = '' Then INIENTRY := 'LASTUPDATE';
  Msg(' param default check : ');
  Msg('    Updatefile  - ' + updatefile);
  Msg('    inientry    - ' + INIENTRY);

  Try
{:=Copy(securitylist.Items[i],1,(Length(securitylist.Items[i])-1));
    size:=length(t);
    path := stralloc(size+1);
    x:=StrPCopy(path,t);}{ from magvnetu}
    Screen.Cursor := crHourGlass;

    If GetComputerName(p, dw) Then
    Begin
      Msg('GetComupterName - OK - ' + Strpas(p));
      CreateIfNeeded;
      Magini := TIniFile.Create(GetConfigFileName);
      //129t16  UPDATEINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'magupdate.ini');
{
    UPDIR := magini.ReadString('SYS_AUTOUPDATE', 'DIRECTORY', 'ERROR');
    msg('Update Directory '+UPDIR);
    IF COPY(UPDIR,LENGTH(UPDIR),1) = '\' THEN UPDIR := COPY(UPDIR,1,LENGTH(UPDIR)-1);
    msg('Update Directory '+UPDIR);
}
      s := Strpas(p);
      Magini.Writestring('SYS_AUTOUPDATE', 'ComputerName', s);
      DATEUPDIR := 'NONE'; // 129 T16 UPDATEINI.ReadString('SYS_AUTOUPDATE', INIENTRY, 'NONE');
      Magini.Writestring('SYS_AUTOUPDATE', INIENTRY, DATEUPDIR);
(*
    if fileexists(UPDIR+'\'+UPDATEFILE) then
       begin
       msg('File Exists - '+UPDIR+'\'+UPDATEFILE);
       DATEUPDIR := formatdatetime('yyyymmdd.hhnn',filedatetime(UPDIR+'\'+UPDATEFILE));
       DATEUPDIR := floattostr(strtofloat(dateupdir)-17000000.0000);
       MAGini.WRITEString('SYS_AUTOUPDATE', INIENTRY, DATEUPDIR);
       msg('Written to ConfigFile : SYS_AUTOUPDATE : '+INIENTRY );
       MSG('   value written = '+DATEUPDIR);
       end
       else
       msg('File Doesn''t exist - '+UPDIR+'\'+UPDATEFILE);

    MAGINI.FREE;
    if fileexists(UPDIR+'\'+'magnet.ini') then
       begin
       msg('MAGNET.INI exists.');
       msg('Reading MUSE Data from MAGNET.INI, writing into ConfigFile');
       MAGINI := TINIFILE.CREATE(UPDIR+'\'+'magnet.ini');
       if UpperCase(magini.readstring('update_mode','RebootAfterSetup','TRUE'))='TRUE'
            then  rebooting := true;
       MUSEDATA := TRUE;
       MUSESERVER := magini.readstring('MUSE','MainServerName','NONE');
       msg('MUSESERVER : '+museserver);
       IF (MUSESERVER = 'NONE') or  (MUSESERVER = '') THEN MUSEDATA := FALSE;
       MUSEVOL := magini.readstring('MUSE','MainVolName','NONE');
       msg('MUSEVOL : '+musevol);
       IF (MUSEVOL = 'NONE') or (MUSEVOL = '')   THEN MUSEDATA := FALSE;
       MUSELETTER := magini.readstring('MUSE','MainLetter','H');
       msg('MUSELETTER : '+MUSELETTER);
       MAGINI.FREE;
       IF MUSEDATA
          THEN
          BEGIN
          MSG('MUSEDATA EXISTS, writting to ConfigFile');
          MAGINI := TINIFILE.CREATE(strpas(windir)+'\WIN.INI');
          MAGINI.WRITESTRING('MUSE','MainServerName',MUSESERVER );
          MAGINI.WRITESTRING('MUSE','MainVolName',MUSEVOL );
          MAGINI.WRITESTRING('MUSE','MainLetter',MUSELETTER );
          MAGINI.FREE;
          END
          ELSE
          MSG('MUSEDATA does NOT EXIST, MUSE DATA NOT written to ConfigFile');

                   {    MainServerName=\\musefs0
                         MainVolName=\meidata0
                         MainLetter=H           }
       END   {if fileexists MAGNET.INI}
       ELSE
       MSG('MAGNET.INI does NOT EXIST');
*)

    End { IF GET COMPUTERNAME }
    Else
      Msg('ERROR : GETCOMPUTERNAME FAILED');

    StrDispose(p);

    Msg('Running ''CheckMagINI''...');
    CheckMagINI;
    Screen.Cursor := crDefault;
    Msg('Check Complete.');
  Finally
    Screen.Cursor := crDefault;
  End;

End;

Procedure TfrmMiniBld.FormCreate(Sender: Tobject);
Begin
{$IFDEF TESTING}
  btnViewMsg.Visible := True;
  BorderStyle := bsSizeable;
{$ENDIF}
  If Not FileExists(GetConfigFileName) Then
    Msg('Creating Imaging Configuration file...')
  Else
    Msg('Checking Imaging Configuration file...');
  Timer1.Enabled := True;
End;

Procedure TfrmMiniBld.Timer1Timer(Sender: Tobject);
Begin
  Timer1.Enabled := False;

  CheckForUpdates;
{$IFDEF TESTING} //
{$ELSE}Close;
{$ENDIF}
// if we are testing, we would comment the close above, and make the view messages button visible;
End;

Procedure TfrmMiniBld.FormClose(Sender: Tobject; Var action: TCloseAction);
Begin
  StrDispose(Windir);
(*{   EWX_FORCE     , EWX_LOGOFF  }
if rebooting then
   begin
   ExitWindowsEX(EWX_LOGOFF,0);
   END;
            *)
End;

Procedure TfrmMiniBld.btnViewMsgClick(Sender: Tobject);
Begin
  frmMiniBld.Height := 380;
End;

Procedure TfrmMiniBld.bCloseClick(Sender: Tobject);
Begin
  Close;
End;

End.
