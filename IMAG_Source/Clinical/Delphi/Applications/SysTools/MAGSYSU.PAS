Unit Magsysu;

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
  Trpcb,
  RPCconf1,
  Stdctrls,
  ExtCtrls,
  Fmxutils,
  Buttons,
  Inifiles,
  magsysbrokercall,
  ComCtrls,
  Umagutils8;
Type
  TMagsysf = Class(TForm)
    Msg: Tpanel;
    bsignon: TBitBtn;
    bwrks: TBitBtn;
    bWrkslist: TBitBtn;
    Label2: Tlabel;
    rbLastLogon: TRadioButton;
    rbAnyLogon: TRadioButton;
    GroupBox1: TGroupBox;
    Label1: Tlabel;
    Label3: Tlabel;
    dDtfr: TDateTimePicker;
    dDtto: TDateTimePicker;
    BitBtn1: TBitBtn;
    Procedure bsignonClick(Sender: Tobject);
    Procedure BWRKSClick(Sender: Tobject);
    Procedure brokerNetError(Sender: Tobject; Var Error: EBrokerError);
    Procedure bWrkslistClick(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure BitBtn1Click(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure FormShow(Sender: Tobject);
    Procedure dDtfrChange(Sender: Tobject);
    Procedure dDttoChange(Sender: Tobject);
    Procedure FormPaint(Sender: Tobject);
    Procedure LastOrAnyClick(Sender: Tobject);
    Procedure Label2MouseDown(Sender: Tobject; Button: TMouseButton;
      Shift: TShiftState; x, y: Integer);

  Private
    FBetaFlag: Boolean;
    Floaddefault: Boolean;
    Procedure LoadDefaultDates;
    Procedure GetFromToDates(Var Dtfr, Dtto, DisFrom, DisTo: String); { Private declarations }
  Public
    Procedure Dmsg(s: String);
    Procedure SaveSettings;
    Procedure NewUpdateTheWrksList;
  End;

Var
  Magsysf: TMagsysf;
  AppPath: String;
Implementation

Uses MagWrksListView,
  MagSessionInfo,
  Magguini,
  Maggut1;

{$R *.DFM}

Procedure TMagsysf.bsignonClick(Sender: Tobject);
Var
  capturekeys: Tstringlist;
  Duz, Username, TMsg: String;
  strServer, strPort: String;
Begin

//bsignon.enabled := false;
  Msg.caption := 'Attempting connection to VistA';
  Msg.Update;
  Duz := '0';
  capturekeys := Tstringlist.Create;

  strServer := '';
  strPort := '';
  If GetServerInfo(strServer, strPort) = MrCancel Then
  Begin
    Msg.caption := 'Login: CANCELED';
    Exit;
  End;
  Broker.Server := strServer;
  Broker.ListenerPort := Strtoint(strPort);

  Try
    Broker.Connected := True;

    If Not Broker.Connected Then
    Begin
      bsignon.Enabled := True;
      Exit;
    End;
    Broker.CreateContext('MAG WINDOWS');

    If Broker.Connected Then
    Begin
      Label2.caption := 'Server : ' + Broker.Server + '   Port : ' + Inttostr(Broker.ListenerPort);
      bsignon.Enabled := True;
      TMsg := 'Connection OK. ';
      Broker.PARAM[0].PTYPE := LITERAL;
      Broker.PARAM[0].Value := 'updating Mag.ini';
      Broker.REMOTEPROCEDURE := 'MAGGUSER2';
      Broker.Call;
      If Broker.Results.Count = 0 Then
      Begin
        Broker.Connected := False;
        Exit;
      End;
      Duz := MagPiece(Broker.Results[1], '^', 1);
      If Duz = '0' Then
      Begin
        TMsg := MagPiece(Broker.Results[1], '^', 2) + ' Disconnecting from DHCP';
        Broker.Connected := False;
      End
      Else
      Begin
        bsignon.Enabled := True;
        Username := MagPiece(Broker.Results[1], '^', 2);
        TMsg := Username + ':  connection OK. ';
        Capturekeys.Clear;
        Broker.REMOTEPROCEDURE := 'MAGGUSERKEYS';
        Broker.LstCALL(Capturekeys);
        If capturekeys.Indexof('MAG SYSTEM') > -1 Then
        Begin
          BWRKS.Enabled := True;
          bwrkslist.Enabled := True;
        End
        Else
        Begin
          TMsg := Username + ': You don''t have the proper Imaging Security Key ';
          Broker.Connected := False;
        End;

      End;
    End
    Else
      TMsg := ' connection: ERROR   ';
    Msg.caption := TMsg;
    Msg.Update;
    bsignon.Enabled := True;

  Finally
    capturekeys.Free;
  End;
End;

Procedure TMagsysf.BWRKSClick(Sender: Tobject);
Begin
{ExecuteFile('WORDPAD.EXE '+APPPATH+'\WNEWCAP.DOC','','', SW_SHOW);}
  EXECUTEfile(AppPath + '\MagWrks.exe', 'letsdoit', '', SW_SHOW);

End;

Procedure TMagsysf.brokerNetError(Sender: Tobject;
  Var Error: EBrokerError);
Begin
  Msg.caption := 'Connection to VistA : Failed.';
  Msg.Update;
End;

(*

*)

Procedure Tmagsysf.Dmsg(s: String);
Begin
  Msg.caption := s;
  Msg.Update;
End;

Procedure TMagsysf.bWrkslistClick(Sender: Tobject);
Begin
FBetaFlag := true;
  If Not FBetaFlag Then
  Begin
    Messagedlg('This function is not a part of the Imaging Version 2.5 Release.' + #13 +
      'To activate this function a Beta Test agreement must be signed'
      , Mtconfirmation, [Mbok], 0);
    Exit;
  End;

  NewUpdateTheWrksList;
  With MagWrksListForm Do
  Begin
    sdtfr.Date := ddtfr.Date;
    Sdtto.Date := ddtto.Date;
    dtpwdtfr.Date := ddtfr.Date;
    dtpwdtto.Date := ddtto.Date;
    sdtfrchange(Self);
    sdttochange(Self);
    dtpwdttochange(Self);
    dtpwdtfrchange(Self);
    Show;
  End;

//utilgrid.sizethecolumns;
End;

Procedure TMagSysf.GetFromToDates(Var Dtfr, Dtto, DisFrom, DisTo: String);
Var
  s, S1: String;
Begin
  Dtfr := '0';
  Dtto := '0';
  DateTimeToString(s, 'yyyy', MagWrksListForm.dtpwdtfr.Date);
  DateTimeToString(S1, 'mmdd', MagWrksListForm.dtpwdtfr.Date);
  Dtfr := Inttostr(Strtoint(s) - 1700) + S1;
  DateTimeToString(DisFrom, 'ddd mmm, dd yyyy', MagWrksListForm.dtpwdtfr.Date);
  DateTimeToString(s, 'yyyy', MagWrksListForm.dtpwdtto.Date);
  DateTimeToString(S1, 'mmdd', MagWrksListForm.dtpwdtto.Date);
  Dtto := Inttostr(Strtoint(s) - 1700) + S1;
  DateTimeToString(DisTo, 'ddd mmm, dd yyyy', MagWrksListForm.dtpwdtto.Date);

End;

Procedure TMagsysf.NewUpdateTheWrksList;
Var
  t: Tstringlist;
  Magini: TIniFile;
  WrksCompName: Shortstring;
  Dtto, Dtfr, s, DisplayFrom, DisPlayto: String;
  listtype: shortstring;
Begin
  Magini := TIniFile.Create(GetConfigFileName);
  Try
    WrksCompName := Uppercase(Magini.ReadString('SYS_AUTOUPDATE', 'ComputerName', 'NoComputerName'));
  Finally
    Magini.Free;
  End; {TRY}
  GetFromToDates(Dtfr, Dtto, DisplayFrom, DisplayTo);
  If rbLastLogon.Checked Then
  Begin
    listtype := 'last';
    s := 'Workstations whose Last Logon occured between : ' + DisplayFrom + ' and ' + DisplayTo;
  End
  Else
  Begin
    listtype := 'any';
    s := 'Workstations where Any logon occured between : ' + DisplayFrom + ' ' + DisplayTo;
  End;

  Broker.PARAM[0].Value := WrksCompName + '^' + Dtfr + '^' + Dtto + '^' + listtype;
  Broker.PARAM[0].PTYPE := LITERAL;
  Broker.REMOTEPROCEDURE := 'MAGG SYS WRKS DISPLAY';
  t := Tstringlist.Create;
  Try
    Broker.LstCALL(t);
    If ((t.Count = 0) Or (MagPiece(t[0], '^', 1) = '0')) Then
      Dmsg(MagPiece(t[0], '^', 2))
    Else
    Begin
      t.Delete(0);
      MagWrksListForm.DataToListView(t, MagWrksListForm.ListView1, s);
    End;
  Finally
    t.Free;
  End;
End;

Procedure TMagsysf.FormCreate(Sender: Tobject);
Begin
  FBetaFlag := False;
  Floaddefault := False;
  Broker := TRPCBroker.Create(Self);

  AppPath := Copy(ExtractFilePath(Application.ExeName), 1, Length(ExtractFilePath(Application.ExeName)) - 1);

End;

Procedure TMagsysf.LoadDefaultDates;
Begin
  ddtto.Date := Now;
  ddttochange(Self);
  ddtfr.Date := Now;
  ddtfrchange(Self);
End;

Procedure TMagsysf.BitBtn1Click(Sender: Tobject);
Begin
  Application.HelpJump('Site_Manager_Tools');
End;

Procedure TMagsysf.SaveSettings;
Var
  Tini: TIniFile;
  x: String;
Begin

  Tini := TIniFile.Create(AppPath + '\MAGSYS.INI');
  Try
    If WindowState = Wsnormal Then
    Begin
      x := Inttostr(Left) + ',' + Inttostr(Top) + ',' + Inttostr(Width) + ',' + Inttostr(Height);
      Tini.Writestring('POSITIONS', 'MAINPOSITION', x);
    End;

    With MagWrksListForm Do
    Begin
      x := Inttostr(Left) + ',' + Inttostr(Top) + ',' + Inttostr(Width) + ',' + Inttostr(Height);
      Tini.Writestring('POSITIONS', 'WORKSTATIONS', x);
    End;
    With MagSessionInfoForm Do
    Begin
      x := Inttostr(Left) + ',' + Inttostr(Top) + ',' + Inttostr(Width) + ',' + Inttostr(Height);
      Tini.Writestring('POSITIONS', 'SESSIONS', x);
    End;

  Finally
    Tini.Free;
  End;

End;

Procedure TMagsysf.FormClose(Sender: Tobject; Var action: TCloseAction);
Begin
  SaveSettings;
End;

Procedure TMagsysf.FormShow(Sender: Tobject);
Var
  x: String;
  Tini: TIniFile;
Begin
  Tini := TIniFile.Create(AppPath + '\MAGSYS.INI');
  With Tini Do
  Begin
    x := Uppercase(ReadString('POSITIONS', 'MAINPOSITION', 'FALSE'));
    If x <> 'FALSE' Then
    Begin
      SetBounds(Strtoint(MagPiece(x, ',', 1)), Strtoint(MagPiece(x, ',', 2)),
        Strtoint(MagPiece(x, ',', 3)), Strtoint(MagPiece(x, ',', 4)));
    End;
    x := Uppercase(ReadString('POSITIONS', 'WORKSTATIONS', 'FALSE'));
    If x <> 'FALSE' Then
    Begin
        {testing}
      MagWrksListForm.SetBounds(Strtoint(MagPiece(x, ',', 1)), Strtoint(MagPiece(x, ',', 2)),
        Strtoint(MagPiece(x, ',', 3)), Strtoint(MagPiece(x, ',', 4)));
    End;
    x := Uppercase(ReadString('POSITIONS', 'SESSIONS', 'FALSE'));
    If x <> 'FALSE' Then
    Begin
        {testing}
      MagSessionInfoForm.SetBounds(Strtoint(MagPiece(x, ',', 1)), Strtoint(MagPiece(x, ',', 2)),
        Strtoint(MagPiece(x, ',', 3)), Strtoint(MagPiece(x, ',', 4)));
    End;
  End;

End;

Procedure TMagsysf.dDtfrChange(Sender: Tobject);
Begin
  MagWrksListForm.dtpwdtfr.Date := ddtfr.Date;
  MagWrksListForm.dtpwdtfrchange(Self);
End;

Procedure TMagsysf.dDttoChange(Sender: Tobject);
Begin
  MagWrksListForm.dtpwdtto.Date := ddtto.Date;
  MagWrksListForm.dtpwdttochange(Self);
End;

Procedure TMagsysf.FormPaint(Sender: Tobject);
Begin
  If Not Floaddefault Then
  Begin
    Floaddefault := True;
    LoadDefaultDates;
  End
End;

Procedure TMagsysf.LastOrAnyClick(Sender: Tobject);
Begin
  MagWrksListForm.rbany.Checked := rbanylogon.Checked;
  MagWrksListForm.rblast.Checked := rblastlogon.Checked;
End;

Procedure TMagsysf.Label2MouseDown(Sender: Tobject; Button: TMouseButton;
  Shift: TShiftState; x, y: Integer);
Begin
  If ((Ssctrl In Shift) And (SsShift In Shift)) Then FBetaFlag := Not FbetaFlag;

  If FBetaFlag Then
    Label2.Color := clTeal
  Else
    Label2.Color := clBtnFace;
End;

End.
