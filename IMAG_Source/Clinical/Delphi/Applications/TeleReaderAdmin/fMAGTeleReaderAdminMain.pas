unit fMAGTeleReaderAdminMain;
{/
  <Unit> fMAGTeleReaderAdminMain;
  <Package> MAG - VistA Imaging
  <Warning> Per VHA Directive 10-93-142 this unit should not be modified.
  <Date Created> 08/01/2009
  <Site Name> Silver Spring, OIFO
  <Developers> Bill Balshem
  <Description>
    This is the main form for the application. VistA login occurs at startup.
    The user selects a menu item, button to one of the 3 componenets of the application (acquisition site setup, reader site setup, system setup).
    The 'About' is accsesd here, the unit gathers version information and passes it to the About Form.
  <Note> Originally part of P106, became main enhancement for P114
  <History>
    P106 n/a 08/01/2009 BB Form created
    P114 n/a 10/14/2009 BB Moved to P114, added logging and annotation standard
  <VA/FDA Statement>
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
/}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, StdCtrls, IniFiles,
  VA508AccessibilityManager,VA508AccessibilityRouter{, MagBrokerHistory};

type
  TfrmTeleReaderAdmin = class(TForm)
    amgrMain: TVA508AccessibilityManager;
    MainMenu1: TMainMenu;
    miFile: TMenuItem;
    miAcquisition: TMenuItem;
    miReader: TMenuItem;
    miExit: TMenuItem;
    miHelp: TMenuItem;
    pnlMainClient: TPanel;
    btnAcquisition: TButton;
    btnReader: TButton;
    btnExit: TButton;
    miAbout: TMenuItem;
    btnSettings: TButton;
    miSettings: TMenuItem;
    pnlTop: TPanel;
    miMessageLog: TMenuItem;
    miContents: TMenuItem;
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnAcquisitionClick(Sender: TObject);
    procedure btnReaderClick(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure GetInstallHistory(var bStatus: boolean; var slInstalls: TStringList);
    function GetVersionStatus(sVersion: string): string;
    procedure GetConnectInfo;
    procedure SelectDB;
    procedure miMessageLogClick(Sender: TObject);
    procedure miContentsClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GetConnectInfoFromRunParams(var sPort, sServer: string);
    function UserHasRightsToRunApp: boolean;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateConnectInfo;
  public
    { Public declarations }
  end;

var
  frmTeleReaderAdmin: TfrmTeleReaderAdmin;
  JobCTR: integer;
  dir : String;
  //History: TBrokerHistory;

const
  IniLoginSection = 'Login Options';
  IniServer = 'Local VistA';
  IniPort = 'Local VistA port';

implementation

uses
  dmMAGTeleReaderAdmin, fMAGAcquisitionSetup, fMAGReaderSetup, fMAGSystemSettings, fMagAbout,
   trpcb, MagFileVersion, fMagSelectDb, uMAGGlobalsTRA, WinTypes; //MaggMsgu;

{$R *.dfm}

{function SetWriteImmedtiate: boolean;
var i: integer;
begin
  result := false;
  for i := 0 to ParamCount do
  begin
    if ParamStr(i) = upper('WRITE_IMMEDIATE=Y') then
    begin
      result := true;
      exit;
    end;
  end;
end;}

procedure TfrmTeleReaderAdmin.SelectDB;
var frm: TfrmSelectDB;
begin
  frm := TfrmSelectDB.Create(nil);
  try
    frm.SelectDb(DataModule1.Broker.Server, IntToStr(DataModule1.Broker.ListenerPort));
    if frm.ModalResult = mrOK then
    begin
      DataModule1.Broker.Server := frm.Server;
      DataModule1.Broker.ListenerPort := frm.Port;
    end;
  finally
    frm.Free;
  end;
end;

procedure TfrmTeleReaderAdmin.GetConnectInfoFromRunParams(var sPort, sServer: string);
var i: integer; sParamStr, sParam: string;
begin
  sServer := '';
  sPort := '0';
  for i := 0 to ParamCount do
  begin
    sParamStr := UpperCase(ParamStr(i));
    sParam := copy(sParamStr, 1, pos('=', sParamStr) - 1);
    if (sParam = 'S') or (sParam = 'SERVER') then sServer := copy(sParamStr, pos('=', sParamStr) + 1, length(sParamStr) - pos('=', sParamStr));
    if (sParam = 'P') or (sParam = 'PORT') then sPort := copy(sParamStr, pos('=', sParamStr) + 1, length(sParamStr) - pos('=', sParamStr));
  end;
  try
    StrToInt(sPort);
  except
    sPort := '0';
  end;
end;

procedure TfrmTeleReaderAdmin.GetConnectInfo;
var INI: TIniFile; sPort, sServer: string;
begin
  //try run time parameters
  GetConnectInfoFromRunParams(sPort, sServer);
  if (sServer <> '') and (StrToInt(sPort) > 0) then
  begin
    DataModule1.Broker.Server := sServer;
    DataModule1.Broker.ListenerPort := StrToInt(sPort);
    MagLogger.Log('INFO', 'Obtained login info from run time params: ' + sServer + '/' + sPort);
    exit;
  end;
  //if no run time params get from ini file
  INI := TIniFile.Create(GetIniFileName);
  try
    DataModule1.Broker.Server := INI.ReadString(IniLoginSection, IniServer, '');
    DataModule1.Broker.ListenerPort := INI.ReadInteger(IniLoginSection, IniPort, 0);
    MagLogger.Log('INFO', 'Obtained login info from ini file: ' + DataModule1.Broker.Server + '/' + IntToStr(DataModule1.Broker.ListenerPort));
  finally
    INI.Free;
  end;
end;

procedure TfrmTeleReaderAdmin.UpdateConnectInfo;
var INI: TIniFile;
begin
  INI := TIniFile.Create(GetIniFileName);
  try
    INI.WriteString(IniLoginSection, IniServer, DataModule1.Broker.Server);
    INI.WriteInteger(IniLoginSection, IniPort, DataModule1.Broker.ListenerPort);
  finally
    INI.Free;
  end;
end;

function TfrmTeleReaderAdmin.UserHasRightsToRunApp: boolean;
var sl: TStringList;
begin
  result := false;
  sl := TStringList.Create;
  try
    DataModule1.Broker.REMOTEPROCEDURE := 'MAGGUSERKEYS';
    try
      DataModule1.Broker.LstCALL(sl);
      MagLogger.Log('INFO', 'User keys retrieved successfully.');
    except
      on e: exception do
      begin
        MessageDlg508('The following message occured while trying to authorize the user' + #13 + #10 + e.Message + #13 + #10 + 'The application is shutting down.',
         mtError, [mbOK], self.Handle);
        exit;
      end;
    end;
    if sl.IndexOf('MAG SYSTEM') > -1 then
    begin
      result := true;
      exit;
    end;
    ShowMessage508('User is not authorized. The application is shutting down.', self.Handle);
  finally
    sl.Free;
  end;
end;

procedure SetFormAsSplash(frm: TForm);
var lbl: TLabel; IMG: TImage;
begin
  lbl := TLabel.Create(frm);
  IMG := TImage.Create(frm);
  try
    frm.BorderStyle := bsDialog;
    frm.Position := poScreenCenter;
    frm.Caption := Application.Title;
    lbl.Caption := 'Loading Site information...';
    frm.BorderIcons := [];
    lbl.Top := 20;
    lbl.Left := 20;
    lbl.Font.Size := 16;
    frm.InsertControl(lbl);
    IMG.Picture.Icon := Application.Icon;
    IMG.Height := 40;
    IMG.Width := 40;
    IMG.Top := round(frm.Height/2) - 20;
    IMG.Left := round(frm.Width/2) - 20;
    frm.InsertControl(IMG);
  except
    lbl.Free;
    IMG.Free;
    raise;
  end;
end;

procedure TfrmTeleReaderAdmin.FormShow(Sender: TObject);
var bUpdateIni: boolean; frm: TForm; //splash screen
begin
  bUpdateIni := false;
  DataModule1.Broker.Connected := false;
  GetConnectInfo;
  if (DataModule1.Broker.Server = '') or (DataModule1.Broker.ListenerPort = 0) then
  begin
    SelectDB;
    bUpdateIni := true;
  end;
  if (DataModule1.Broker.Server = '') or (DataModule1.Broker.ListenerPort = 0) then close;
  try
    //History := TBrokerHistory.Create(MainMenu1);
    //History.Broker := DataModule1.Broker;
    DataModule1.Broker.Connected := true;
    MagLogger.Log('INFO', 'Successful login to Vista');
    if DataModule1.Broker.Connected then DataModule1.Broker.CreateContext('MAG WINDOWS');
    MagLogger.Log('INFO', 'Context set to "MAG WINDOWS"');
    if bUpdateIni then UpdateConnectInfo;
    if not UserHasRightsToRunApp then close;
    MagLogger.Log('INFO', 'User is authorized to run this application.');
  except on e: exception do begin
    if pos('Sign-on was not completed.', e.Message) = 0 then
      ShowMessage508('Login Failed', self.Handle);
    MagLogger.Log('ERROR', e.Message);
    close;
    end;
  end;

  frm := TForm.Create(nil);
  try
    SetFormAsSplash(frm);
    frm.Show;
    frm.Update;
    slStationNumbers := TStringList.Create;
    LoadSites;
    FlagLocalSites;
    FlagLoginSite;
    slStationNumbers.Sorted := true;
    GetFormPosition(self);
    sTriggers := GetTriggerValues;
    Caption := Caption + ' (' + DataModule1.Broker.Server + ')';
  finally
    frm.Free;
  end;

  JobCompleted := false;
  JobCTR := 0;
  slClinicData := TStringList.Create;
  MagLogger.Log('INFO', 'Kicked off clinic list retrieval background job on the server');
  sHandle := KickoffListerJob;
  Timer1.Enabled := true;

end;

procedure TfrmTeleReaderAdmin.btnExitClick(Sender: TObject);
begin
  if slStationNumbers <> nil then slStationNumbers.Free;
  Close;
end;

procedure TfrmTeleReaderAdmin.btnAcquisitionClick(Sender: TObject);
//Main Acquisition Site configuration form
var frm: TfrmAcquisitionSetup;
begin
  frm := TfrmAcquisitionSetup.Create(nil);
  try
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

procedure TfrmTeleReaderAdmin.btnReaderClick(Sender: TObject);
//Main Reader Site configuration for
var frm: TfrmReaderSetup;
begin
  frm := TfrmReaderSetup.Create(nil);
  try
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

procedure TfrmTeleReaderAdmin.GetInstallHistory(var bStatus: boolean; var slInstalls: TStringList);
//RPC Call to get Install History - passed to the about form
begin
  if (DataModule1.Broker = nil) or (not DataModule1.Broker.Connected) then
  begin
    slInstalls.add('0^No connection to the Server');
    exit;
  end;
  slInstalls.clear;
  bStatus := false;
  DataModule1.Broker.remoteprocedure := 'MAGG INSTALL';
  try
    DataModule1.Broker.lstCall(slInstalls);
    if (slInstalls.Count = 0) or (MagSTRPiece(slInstalls[0], '^', 1) = '0') then exit;
    bStatus := true;
    if GetFieldCount(slInstalls[0],'~') = 1 then  // This is old M code, not returning '~' codes for columns;
       slInstalls[0] := 'Server Versions  ^Install Date     ~S1'; // this sort code 'S1' says that this column is Dates.
  except
    on E: EXCEPTION do
      begin
        slInstalls.Insert(0, '0^' + MagSTRPiece(e.message, #$A, 2));
      end;
  end;
end;

function TfrmTeleReaderAdmin.GetVersionStatus(sVersion: string): string;
//RPC Call to get Version Status - passed to the about form
begin
  if (DataModule1.Broker = nil) or (not DataModule1.Broker.Connected) then
  begin
    result := '1^Status is unavailable.';
    exit;
  end;
  DataModule1.Broker.remoteprocedure := 'MAG4 VERSION STATUS';
  DataModule1.Broker.Param[0].PType := literal;
  DataModule1.Broker.Param[0].Value := sVersion;
  try
    result :=  DataModule1.Broker.strcall;
    if result = '' then result := '1^Error trying to determine status';
  except
    on e: exception do
      begin
        result := '1^Error trying to determine status' + #13 + #10 + e.Message;
      end;
  end;
end;

procedure TfrmTeleReaderAdmin.miAboutClick(Sender: TObject);
var frm: TfrmAbout; slInstalls: TStringList;
    sVersionStatus, sVersion: string;
    bStatus: boolean;
begin
  SpecifyFormIsNotADialog(TfrmAbout);
  frm := TfrmAbout.Create(nil);
  slInstalls := TStringList.Create;
  try
    GetInstallHistory(bStatus, slInstalls);
    sVersion := MagGetFileVersionInfo(Application.ExeName);
    //sVersionStatus := GetVersionStatus(sVersion);
    sVersionStatus := MagStrPiece(GetVersionStatus(sVersion),'^',2);
    frm.execute('', '', slInstalls, sVersionStatus);
  finally
    frm.Free;
    slInstalls.Free;           
  end;
end;

procedure TfrmTeleReaderAdmin.btnSettingsClick(Sender: TObject);
//System settings form
var frm: TfrmSystemSettings;
begin
  frm := TfrmSystemSettings.Create(nil);
  try
    frm.ShowModal;
  finally
    frm.Free
  end;
end;

procedure TfrmTeleReaderAdmin.miMessageLogClick(Sender: TObject);
var frm: TForm; Memo: TMemo; i: integer;
begin
  //MagLogger.Show;
  frm := TForm.Create(nil);
  Memo := TMemo.Create(nil);
  try
    frm.Position := poScreenCenter;
    frm.Caption := 'View Log File';
    frm.Width := round(screen.Width/3);
    frm.Height := round(screen.Height/1.25);
    frm.InsertControl(Memo);
    Memo.Align := alClient;
    Memo.ReadOnly := true;
    Memo.ScrollBars := ssBoth;
    for i := 0 to MagLogger.Count - 1 do Memo.Lines.Add(MagLogger.Strings[i]);
    frm.ShowModal;
  finally
    Memo.Free;
    frm.Free;
  end;
end;

procedure TfrmTeleReaderAdmin.miContentsClick(Sender: TObject);
begin
  OpenHelpFile;
end;

procedure TfrmTeleReaderAdmin.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = F1KEY then OpenHelpFile;
end;

procedure TfrmTeleReaderAdmin.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormPosition(self);
  MagLogger.Log('INFO', 'Closed the TeleReader Configuration application');
  if slClinicData <> nil then slClinicData.Free;
end;

procedure TfrmTeleReaderAdmin.Timer1Timer(Sender: TObject);
begin
  Timer1.enabled := false;
  Inc(JobCTR);
  if JobIsComplete(sHandle) then
  begin
    MagLogger.Log('INFO', 'CHECK ' + IntToStr(JobCTR) + ' Checked clinic list job on server: Job Complete');
    GetJobResults(sHandle, slClinicData);
    ClearJobResults(sHandle);
    JobCompleted := true;
    exit;
  end;
  MagLogger.Log('INFO', 'CHECK ' + IntToStr(JobCTR) + ' Checked clinic list job on server: Not Completed');
  Timer1.enabled := true;
end;

initialization
  MagLogger := TMagLogger.Create;
  //MagLogger.Open(plUser, ExtractFilePath(Application.Exename) + 'MagLog\MagTeleReaderConfig.zip', True, 'TRA', 30, 10000000, 'VistA Imaging TeleReader Administrator', SetWriteImmedtiate);
  In508Mode := CheckFor508Mode;

finalization

  begin
    // NST P127 09/21/2012 Windows 7 change - save the log in Application data folder
    dir :=  GetLogFileDir;
    MagLogger.SaveToFile(dir + 'MagTeleReaderConfig' + FormatDateTime('mmddyyyyhhmmssAM/PM', Now) + '.log');
    MagLogger.Free;
  end;
  //MagLogger.Close;


end.
