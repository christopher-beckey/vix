{*------------------------------------------------------------------------------
  Main form for VistA Imaging TeleReader Application.

  @author Robert Graves, Julian Werfel
  @version 3/6/2006 VistA Imaging Version 3.0 Patch 46
-------------------------------------------------------------------------------}
Unit fmagTRMain;
{
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: December 2005
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  Robert Graves, Julian Werfel
  Description: This is the main form for the TeleReader application.
    It displays the read/unread lists and provides options for the
    user.
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
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;;+---------------------------------------------------------------------------------------------------+
*)

Interface

Uses
  Buttons,
  Classes,
  cMagDBBroker,
  cMagWorkItem,
  ComCtrls,
  Controls,
  ExtCtrls,
  Forms,
  Graphics,
  Magremoteinterface,
  MagRemoteToolbar,
  Menus,
  Stdctrls,
  VERGENCECONTEXTORLib_TLB,
  Windows,
  ImgList, ToolWin ,
  imaginterfaces
  ;

//Uses Vetted 20090930:cMagLogManager, ImgList, maggut1, cMagDBMVistA, MagRemoteBroker, OleCtrls, CCOWRPCBroker, Variants, uMagClasses, comObj, fMagNumberSelect, magResources, cMagHashmap, shellapi, u-Mag-AppMgr, Maggut9, cMagTRUtils, MagPrevInstance, uMagDisplayMgr, magFileVersion, magguini, MagTimeout, magPositions, fMagAbout, cMagUserSpecialty, fMagTeleReaderOptions, dmsingle, MaggMsgu, uMagUtils, MagRemoteBrokerManager, uMagDefinitions, IniFiles, Trpcb, Dialogs, SysUtils, Messages

Type
  /// Form object that contains all other members of the form
  TfrmTRMain = Class(TForm, IMagRemoteinterface)
    /// tab control
    PageControl1: TPageControl;
    /// unread list sheet
    tsUnreadList: TTabSheet;
    /// read list sheet
    tsReadList: TTabSheet;
    /// unread list
    lvUnreadList: TListView;
    /// read list
    lvReadList: TListView;
    /// main menu obbject
    MainMenu1: TMainMenu;
    /// File menu item
    File1: TMenuItem;
    /// timer object
    Timer1: TTimer;
    /// refresh menu item
    Refresh1: TMenuItem;
    Exit1: TMenuItem;
    PnlDetails: Tpanel;
    lblPatient: Tlabel;
    lblPatientData: Tlabel;
    LblStatus: Tlabel;
    lblStatusData: Tlabel;
    lblAcqSite: Tlabel;
    lblAcqSiteData: Tlabel;
    lblReadingSite: Tlabel;
    lblReadingSiteData: Tlabel;
    lblQPID: Tlabel;
    lblShortIDData: Tlabel;
    lblAcqStart: Tlabel;
    lblAcqStartData: Tlabel;
    lblLastImageTime: Tlabel;
    lblLastImageTimeData: Tlabel;
    lblNumImages: Tlabel;
    lblNumImagesData: Tlabel;
    lblUrgency: Tlabel;
    lblUrgencyData: Tlabel;
    lblConsultNum: Tlabel;
    lblConsultNumData: Tlabel;
    lblIFCNum: Tlabel;
    lblIFCNumData: Tlabel;
    btnLock: TButton;
    btnView: TButton;
    lblReader: Tlabel;
    lblReaderData: Tlabel;
    Options1: TMenuItem;
    ilCCOWIcons: TImageList;
    imgCCOWState: TImage;
    lblContextWarning: Tlabel;
    ImageList1: TImageList;
    FMagRemoteToolbar1: TfMagRemoteToolbar;
    pnlStatusBar: Tpanel;
    Pnlmsg: Tpanel;
    PnlSiteCode: Tpanel;
    pnlMsgHistory: Tpanel;
    btnMsgHistory: TBitBtn;
    N1: TMenuItem;
    Login1: TMenuItem;
    Logout1: TMenuItem;
    N2: TMenuItem;
    RemoteLogin1: TMenuItem;
    N3: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Options2: TMenuItem;
    ViewAllStudies1: TMenuItem;
    ShowSpecialtiesDialogatStartup1: TMenuItem;
    N4: TMenuItem;
    SaveSettingsNow1: TMenuItem;
    SaveSettingsOnExit1: TMenuItem;
    lblSpecialty: Tlabel;
    lblProcedure: Tlabel;
    lblSpecialtyData: Tlabel;
    lblProcedureData: Tlabel;
    TimerTimeout: TTimer;
    mnuTest: TMenuItem;
    ReadListDays1: TMenuItem;
    AutoLaunchDisplayCPRS1: TMenuItem;
    SetWorkstationTimeout1: TMenuItem;
    SetCPRSLocation1: TMenuItem;
    DisplayPrimaryDivisonHashmap1: TMenuItem;
    Contents1: TMenuItem;
    Lock1: TMenuItem;
    View1: TMenuItem;
    Study1: TMenuItem;
    mnuOptionsReadListDays: TMenuItem;
    mnuOptionsFitColumnsToText: TMenuItem;
    N5: TMenuItem;
    mnuOptionsFitColumnsToWindow: TMenuItem;
    Columns1: TMenuItem;
    mnuColumnsStatus: TMenuItem;
    mnuColumnsUrgency: TMenuItem;
    mnuColumnsReader: TMenuItem;
    mnuColumnsAcqSite: TMenuItem;
    mnuColumnsReadingSite: TMenuItem;
    mnuColumnsAcqCon: TMenuItem;
    mnuColumnsIFC: TMenuItem;
    mnuColumnsPatient: TMenuItem;
    mnuColumnsLastImage: TMenuItem;
    mnuColumnsNumImages: TMenuItem;
    mnuColumnsCompletedDate: TMenuItem;
    Procedure Timer1Timer(Sender: Tobject);
    Procedure Exit1Click(Sender: Tobject);
    Procedure Refresh1Click(Sender: Tobject);
    Procedure ReadingListSelectItem(Sender: Tobject; Item: TListItem;
      Selected: Boolean);
    Procedure PageControl1Change(Sender: Tobject);
    Procedure btnViewClick(Sender: Tobject);
    Procedure btnLockClick(Sender: Tobject);
    Procedure ReadingListDblClick(Sender: Tobject);
    Procedure ReadingListColumnClick(Sender: Tobject; Column: TListColumn);
    Procedure ReadingListCompare(Sender: Tobject; Item1, Item2: TListItem;
      Data: Integer; Var Compare: Integer);
    Procedure FormCreate(Sender: Tobject);
    Procedure Specialties1Click(Sender: Tobject);
    Procedure imgCCOWStateDblClick(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure ReadingListCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Var DefaultDraw: Boolean);
    Procedure btnMsgHistoryClick(Sender: Tobject);
    Procedure Login1Click(Sender: Tobject);
    Procedure RemoteLogin1Click(Sender: Tobject);
    Procedure Logout1Click(Sender: Tobject);
    Procedure About1Click(Sender: Tobject);
    Procedure ViewAllStudies1Click(Sender: Tobject);
    Procedure TimerTimeoutTimer(Sender: Tobject);
    Procedure ShowSpecialtiesDialogatStartup1Click(Sender: Tobject);
    Procedure lblPatientMouseDown(Sender: Tobject; Button: TMouseButton;
      Shift: TShiftState; x, y: Integer);
    Procedure ReadListDays1Click(Sender: Tobject);
    Procedure AutoLaunchDisplayCPRS1Click(Sender: Tobject);
    Procedure SaveSettingsNow1Click(Sender: Tobject);
    Procedure SaveSettingsOnExit1Click(Sender: Tobject);
    Procedure SetWorkstationTimeout1Click(Sender: Tobject);
    Procedure SetCPRSLocation1Click(Sender: Tobject);
    Procedure DisplayPrimaryDivisonHashmap1Click(Sender: Tobject);
    Procedure Contents1Click(Sender: Tobject);
    Procedure Lock1Click(Sender: Tobject);
    Procedure View1Click(Sender: Tobject);
    Procedure mnuOptionsReadListDaysClick(Sender: Tobject);
    Procedure mnuOptionsFitColumnsToTextClick(Sender: Tobject);
    Procedure mnuOptionsFitColumnsToWindowClick(Sender: Tobject);
    Procedure Columns1Click(Sender: Tobject);
    Procedure mnuColumnsStatusClick(Sender: Tobject);
    Procedure mnuColumnsUrgencyClick(Sender: Tobject);
    Procedure mnuColumnsReaderClick(Sender: Tobject);
    Procedure mnuColumnsAcqSiteClick(Sender: Tobject);
    Procedure mnuColumnsReadingSiteClick(Sender: Tobject);
    Procedure mnuColumnsAcqConClick(Sender: Tobject);
    Procedure mnuColumnsIFCClick(Sender: Tobject);
    Procedure mnuColumnsPatientClick(Sender: Tobject);
    Procedure mnuColumnsLastImageClick(Sender: Tobject);
    Procedure mnuColumnsNumImagesClick(Sender: Tobject);
    Procedure mnuColumnsCompletedDateClick(Sender: Tobject);
    procedure FormPaint(Sender: TObject);

  Private
    {RCA  flag to initialize once in the onPaint}
    FPaintedOnce : boolean;
    HideDiscontinuedConsults: Boolean; ///If True Cancelled Consults are not shown, otherwise they are shown on the Read list
    /// Sentillion Contextor control for receiving/posting context changes
    ContextorControl1: TContextorControl;
    /// broker object for local connection
    LocalBroker: TMagDBBroker;
    /// determines if the local VistA is a production account or test account
    IsProdAccount: Boolean;
    /// is First timer event (for initialization)
    IsFirstTick: Boolean;
    /// Sort Column to use
    SortColumn: Integer;
    /// determines if sort should be ascending
    SortAscending: Boolean;

    // values read from the mag308.ini file
    /// Workstation ID from Mag308.ini
    Wsid: String;
    /// Workstation Location from Mag308.ini
    WrksLocation: String;
    /// workstation computer name from Mag308.ini
    WrksCompName: String;
    /// Last MAG update from Mag308.ini
    LastMagUpdate: String;
    /// Local Server from Mag308.ini
    LocalServer: String;
    /// Local port from Mag308.ini
    LocalPort: String;
    /// Determines if login should occur at startup from Mag308.ini
    Loginonstartup: Boolean;
    /// Determines if Remote Logins are enabled - from Mag308.ini
    AllowRemoteLogin: Boolean;
    /// Security Keys the logged in user has
    SecurityKeys: Tstringlist;
    /// the amount of time until the application terminates due to inactivity
    WorkStationTimeout: Integer;
    /// number of days to display on the ReadList
    ReadDays: Integer;
    /// maximum number of days allowed to view on the ReadList
    ReadDaysMax: Integer;
    /// determines if this is the first time loading the Read List
    FirstReadListLoad: Boolean;
    /// Location where CPRS is installed
    CPRSLocation: String;
    /// determines if the application closed because of the timeout
    ApplicationTimedOut: Boolean;
    FMagINITimeout: String;

    {   application messages go through here.  This keeps time of inactivity
         so the TimeOut function will operate.}
    Procedure AppMessage(Var Msg: TMsg; Var Handled: Boolean);
    Procedure SetWorkstationTimeout(Minutes: String);

    Procedure UpdateReadingLists();
    Procedure AddWorkItem(WorkItem: TMagWorkItem);
    Procedure UpdateWorkItem(Listitem: TListItem; WorkItem: TMagWorkItem);
    Function FindListItem(WorkItem: TMagWorkItem): TListItem;
    Function ChangePatientContext(WorkItem: TMagWorkItem): Boolean;
    Function ShowSelectedPatient(CheckSensitivePatient: Boolean = True): Boolean;
    Function UserCanLock(WorkItem: TMagWorkItem): Boolean;
    Procedure LockSelectedItem();
    Function GetActiveReadingList(): TListView;
    Procedure OnPageChange();
    Procedure UpdateLockButton(WorkItem: TMagWorkItem);
    Function SignOn(RemoteLogin: Boolean = False): Boolean;
    Procedure GetSitesSpecialties();
    Procedure SetFormCaption(InContext: Boolean);
    Function IsInContext(WorkItem: TMagWorkItem): Boolean;
    Procedure VerifyContextConnected();
    Procedure ConnectToRemoteSites();
    Procedure InitializeReader();
    Procedure setMenus();
    // this function displays a message in the statusbar and logs the message
    Procedure DisplayMessage(Msg: String; MsgType: String = '');
    Procedure ViewTeleReaderOptions();

    Procedure ContextorCanceled(Sender: Tobject);
    Procedure ContextOrCommitted(Sender: Tobject);
    Procedure ContextOrPending(Sender: Tobject;
      Const aContextItemCollection: IDispatch);

    Function DisplayOptionsOnStartup(): Boolean;
    Procedure InitializeSecurityKeyObjects();
    Function checkLockedWorkItems(): Boolean;
    Procedure checkDisplayCPRSLaunched();
    Procedure getApplyUserPreferences();
    Procedure saveUserPreferences();

    Function Logout(): Boolean;
    Function checkPatientSensitiveContinue(WorkItem: TMagWorkItem): Boolean;
    /// checks to see if user is on a thin client, if so it terminates the app
    Function isThinClient(): Boolean;
    /// fit columns of read and unread list to the text
    Procedure FitColumnsToText();
    /// fit columns of read and unread list to the window size
    Procedure fitColumnsToWindow();
    /// fit columns of list to text
    Procedure fitListViewColumnsToText(List: TListView);
    /// fit columns of list to window
    Procedure fitListViewColumnsToWindow(List: TListView);
    // sorts the columns of the selected list by the column index (used by menu)
    Procedure SortBycolumn(ColumnIndex: Integer);
    // determines if the work item should be auto-unlocked
    Function CanAutoUnlockWorkItem(WorkItem: TMagWorkItem): Boolean;

  Public
    Procedure RIVRecieveUpdate_(action: String; Value: String); // recieve updates from everyone
  End;

Var
  frmTRMain: TfrmTRMain;

Const
  ITF_E_CONTEXT_MANAGER_ERROR = HRESULT($80040206);

Implementation

Uses
  cMagHashmap,
  cMagTRUtils,
  cMagUserSpecialty,
  ComObj,
  Dialogs,
  DmSingle,
  ImagDMinterface,  // RCA this for idmodobj (interfaced object)
  FMagAbout,
  fMagNumberSelect,
  FMagPatAccess,
  fMagTeleReaderOptions,
  Inifiles,
  Magfileversion,
//  Maggmsgu,
cMagTRMsg,
  Magguini,
//RCA FIX HERE   Maggut9,
  Magpositions,
  MagPrevInstance,
  MagRemoteBrokerManager,
  MagResources,
  MagTimeout,
  Math,
  Messages,
  Shellapi,
  SysUtils,
  Trpcb,
//RCA FIX HERE   u Mag AppMgr,
uMagTRAppMgr,
  uMagClasses,
  uMagDefinitions,
//RCA FIX HERE  umagdisplaymgr,
  umagutils8
  ;

//Uses Vetted 20090930:DateUtils

{$R *.dfm}

{*------------------------------------------------------------------------------
  Creates the form.

  @author Robert Graves, Julian Werfel
  @param Sender Object which sent this create message
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.FormCreate(Sender: Tobject);
Begin
  MagTRMsg := TMagAppMessageLog.create();

  ImagInterfaces.IMsgObj := MagTRMsg;

 FPaintedOnce := False;
PageControl1.Align := alClient;
  GSess := TSession.Create;
  Timer1.Enabled := False;
  HideDiscontinuedConsults := True;
  Try
    ContextorControl1 := TContextorControl.Create(Nil);
    ContextorControl1.OnCommitted := ContextOrCommitted;
    ContextorControl1.OnCanceled := ContextorCanceled;
    ContextorControl1.OnPending := ContextOrPending;
  Except
    On e: Exception Do
    Begin
      Self.Hide();
      Application.Processmessages();
      Showmessage('Failed to initialize CCOW Connection, verify CCOW Client is installed.' + #13 + 'Exception=[' + e.Message + ']');
      // no real reason to log message since application is terminating
      // leave this as terminate since nothing has happened, nothing to cleanup?

      Close();
      Application.Terminate();
      Application.Processmessages();
      //MagTeleReader.Close();
      Exit;
    End;
  End;

  Application.OnMessage := AppMessage;

  // default to sort by last acquired image date
  SortColumn := 7; //8;
  SortAscending := True;
  IsFirstTick := True;
  ilCCOWIcons.GetIcon(0, imgCCOWState.Picture.Icon);
  btnMsgHistory.Align := alClient;
  InitializeReader();
  GetFormPosition(Self As TForm);
End;

procedure TfrmTRMain.FormPaint(Sender: TObject);
begin
 if  FPaintedOnce then exit;
  FPaintedOnce := true;
 //RCA here,  dmod has been created.
  ImagDMinterface.idModObj := dmod;

end;

Procedure TfrmTRMain.checkDisplayCPRSLaunched();
Var
  AppPath: String;
  Hwnd: THandle;
  ServerName, PortNumber: String;
  DisplayExecutable: String;
  allOK: Boolean;
Begin
  allOK := True;
  If Not AutoLaunchDisplayCPRS1.Checked Then Exit;
  AppPath := Copy(ExtractFilePath(Application.ExeName), 1, Length(ExtractFilePath(Application.ExeName)) - 1);
  // check to see if Imaging is running
  ServerName := LocalBroker.GetServer;
  PortNumber := Inttostr(LocalBroker.GetListenerPort);
  DisplayMessage('Launching VistA Imaging Display and CPRS');
  If Not IsAppRunning('Vista Imaging Display', True) Then
  Begin
    //MaggMsgf.MagMsg('s', 'Imaging Display is not currently running, launching Display from location [' + AppPath + '] with parameters "s=' + ServerName + '" "p=' + PortNumber + '"');
    MagAppMsg('s', 'Imaging Display is not currently running, launching Display from location [' +
      AppPath + '] with parameters "s=' + ServerName + '" "p=' + PortNumber + '"'); {JK 10/7/2009 - MagMsgu refactoring}
    DisplayExecutable := AppPath + '\MagImageDisplay.exe';
    If FileExists(DisplayExecutable) Then
    Begin
      Hwnd := Magexecutefile('MagImageDisplay.exe', '"s=' + ServerName + '" "p=' + PortNumber + '"', AppPath, SW_SHOW);
      If Hwnd <> 0 Then
        SetForegroundWindow(Hwnd);
    End
    Else
    Begin
      DisplayMessage('Imaging Display Application not found');
      //MaggMsgf.MagMsg('s', 'Imaging Display Application not found in [' + DisplayExecutable + ']');
      MagAppMsg('s', 'Imaging Display Application not found in [' + DisplayExecutable + ']'); {JK 10/7/2009 - MagMsgu refactoring}
      allOK := False;
    End;
  End;
  If Not IsAppRunning('CPRS - Patient Chart', True) Then
  Begin
    // if TR couldn't get the location of CPRS from the registry, use
    // this default location (program files/vista/CPRS/CPRSChart.exe)
    If CPRSLocation = '' Then
    Begin
      CPRSLocation := getParentDir(AppPath) + '\CPRS\CPRSChart.exe';
    End;
    //MaggMsgf.MagMsg('s', 'CPRS is not currently running, launching CPRS from location [' + CPRSLocation + '] with parameters "s=' + ServerName + '" "p=' + PortNumber + '"');
    MagAppMsg('s', 'CPRS is not currently running, launching CPRS from location [' + CPRSLocation +
      '] with parameters "s=' + ServerName + '" "p=' + PortNumber + '"'); {JK 10/7/2009 - MagMsgu refactoring}
    If FileExists(CPRSLocation) Then
    Begin
      Hwnd := Magexecutefile(ExtractFileName(CPRSLocation), '"s=' + ServerName + '" "p=' + PortNumber + '"', ExtractFilePath(CPRSLocation), SW_SHOW);
      If Hwnd <> 0 Then
        SetForegroundWindow(Hwnd);
    End
    Else
    Begin
      DisplayMessage('CPRS Application not found');
      //MaggMsgf.MagMsg('s', 'CPRS Application not found in [' + CPRSLocation + ']');
      MagAppMsg('s', 'CPRS Application not found in [' + CPRSLocation + ']'); {JK 10/7/2009 - MagMsgu refactoring}
      allOK := False;
    End;
  End;
  If allOK Then DisplayMessage('');
End;

{*------------------------------------------------------------------------------
  application messages go through here.  This keeps time of inactivity
      so the TimeOut function will operate.

  @author Julian Werfel
  @param Msg
  @param Handled If this message has been handled
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.AppMessage(Var Msg: TMsg; Var Handled: Boolean);
Begin
  If ((Msg.Message = WM_KEYDOWN) Or (Msg.Message = WM_MOUSEMOVE)) Then
  Begin
    TimerTimeout.Enabled := False;
    TimerTimeout.Enabled := True;
  End;
End;

{*------------------------------------------------------------------------------
  Sends an update to the RIV Context manager.

  @author Julian Werfel
  @param Action The action to do
  @param Value The value of the action
-------------------------------------------------------------------------------}

{*------------------------------------------------------------------------------
  Receives updates from the RIV Context manager

  @author Julian Werfel
  @param Action The action to do
  @param Value The value of the action
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.RIVRecieveUpdate_(action: String; Value: String);
Begin
  If action = 'ConnectingRemote' Then
  Begin
    DisplayMessage('Connecting to remote site [' + Value + '] ...', '');
  End
  Else
    If action = 'DODSite' Then
    Begin
      DisplayMessage('No interface to DOD site [' + Value + ']', '');
    End
    Else
      If action = 'RefreshPatient' Then // occurs after a site is reconnected, called by toolbar to force a refresh of the data
      Begin
    // should maybe clear the read/unread lists?
    // this needs to do a full refresh of the lists
        Timer1.Enabled := False;
        ConnectToRemoteSites();
        lvUnreadList.Clear();
        lvReadList.Clear();
        FirstReadListLoad := True;
        frmMagTeleReaderOptions.ClearLastUpdated();
        Timer1Timer(Self);
      End;
End;

{*------------------------------------------------------------------------------
  Initializes variables for the TeleReader, also loads information from the
  mag308.ini file and joins CCOW Context

  @author Julian Werfel
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.InitializeReader();
Var
  Magini: TIniFile;
  AllowMultiple, Paramup: String;
  i: Integer;
Begin
  // check if thin client
  // p46t11
  {If isThinClient() Then
  Begin
    Self.Hide();
    Application.Processmessages;
    Showmessage('VistA Imaging TeleReader cannot be used on a thin client configuration.' + #13 + #13 + 'TeleReader will close.');
    Close();
    Application.Terminate();
    Application.Processmessages();
    Exit;
  End;}

  ApplicationTimedOut := False;
  // create the security key list
  SecurityKeys := Tstringlist.Create();
  // Create the logging object
  //MaggMsgf := TMaggMsgf.Create(self); {JK 10/7/2009 - MagMsgu refactoring}
  //MaggMsgf.MagMsg('','VistA Imaging TeleReader');
  MagAppMsg('', 'VistA Imaging TeleReader'); {JK 10/7/2009 - MagMsgu refactoring}
  // JMW 4/1/08 P72 - set the log manager
  //MaggMsgf.InitializeLogManager(DMod.MagLogManager);  {JK 10/7/2009 - MagMsgu refactoring}
  // don't need to make this call, automatically created by app (JMW 5/8/06)
  //dmod.DataModuleCreate(self);

  { create a MAG308.INI if there isn't any}
  CreateIFNeeded;
  {  if this version is different from the last time we updated the INI, then
     run the Update function}
  UpdateIfNeeded(MagGetFileVersionInfo(Application.ExeName));

  //MagIni := TIniFile.Create(ExtractFilePath(application.exename) + 'mag308.ini');
  Magini := TIniFile.Create(GetConfigFileName());
  DemoRemoteSites := Magstrtobool(Magini.ReadString('Demo Options', 'DemoRemoteSites', 'FALSE'));
  If Magini.ReadString('TeleReader Options', 'HideDiscontinuedConsults', '') = '' Then
    Magini.Writestring('TeleReader Options', 'HideDiscontinuedConsults', 'TRUE');
  HideDiscontinuedConsults := Magstrtobool(Magini.ReadString('TeleReader Options', 'HideDiscontinuedConsults', 'TRUE'));
  Loginonstartup := (Uppercase(Magini.ReadString('Login Options', 'LoginOnStartup', 'TRUE')) = 'TRUE');
  AllowRemoteLogin := (Uppercase(Magini.ReadString('Login Options', 'AllowRemoteLogin', 'FALSE')) = 'TRUE');
  LocalServer := Magini.ReadString('Login Options', 'Local VistA', 'BROKERSERVER');
  LocalPort := Magini.ReadString('Login Options', 'Local VistA port', '9200');

  WrksLocation := Magini.ReadString('Workstation Settings', 'Location', 'UNKnown');
  WrksCompName := Uppercase(Magini.ReadString('SYS_AUTOUPDATE', 'ComputerName', 'NoComputerName'));
  LastMagUpdate := Uppercase(Magini.ReadString('SYS_AUTOUPDATE', 'LASTUPDATE', '0'));

  AllowMultiple := Uppercase(Magini.ReadString('Workstation settings', 'AllowMultipleInstances', 'FALSE'));

  FMagINITimeout := Magini.ReadString('Workstation Settings', 'WorkStation TimeOut minutes', '');
  SetWorkstationTimeout(FMagINITimeout);

  Magini.Free();

  // check to see if multiple instances of TeleReader are allowed
  If (Uppercase(AllowMultiple) <> 'TRUE') Then
  Begin
    // check to see if multiple instances of TR are running
    If DoIExist('Vista Imaging TeleReader') Then
    Begin
      // notify the user and terminate the 2nd instance of the applications
      Self.Hide();
      Application.Processmessages;
      Showmessage('"VistA Imaging TeleReader" is already running. ' + #13 + #13 + 'A second instance will not be started.');
      Close();
      Application.Terminate();
  // RCA    Application.Processmessages();
     Exit;   //  ? without exit..  the function continues below...
    End;
  End;

  // load command line parameters
  If ParamCount > 1 Then
  Begin
    For i := 1 To ParamCount Do
    Begin
      If Pos('=', ParamStr(i)) > 0 Then
      Begin
        Paramup := Uppercase(MagPiece(ParamStr(i), '=', 1));
        If (Paramup = 'S') Or (Paramup = 'SERVER') Then LocalServer := MagPiece(ParamStr(i), '=', 2);
        If (Paramup = 'P') Or (Paramup = 'PORT') Then LocalPort := MagPiece(ParamStr(i), '=', 2);
      End;
      //MaggMsgf.MagMsg('s', '  - Param ' + inttostr(i) + ' ' + paramstr(i));
      MagAppMsg('s', '  - Param ' + Inttostr(i) + ' ' + ParamStr(i)); {JK 10/7/2009 - MagMsgu refactoring}
    End;
    Loginonstartup := True;
    AllowRemoteLogin := False;
  End;

  // JMW 5/21/08 P72 - user preferences now need to be created here
  Upref := Tuserpreferences.Create();
  Upref.RIVAutoConnectEnabled := True;
  Upref.RIVHideEmptySites := False;
  Upref.RIVHideDisconnectedSites := False;
  Upref.RIVAutoConnectVISNOnly := False;

  CPRSLocation := '';

  RIVEnabled := True;
  //MaggMsgf.MagMsg('','Joining Context...');
  MagAppMsg('', 'Joining Context...'); {JK 10/7/2009 - MagMsgu refactoring}
  Try
    ContextorControl1.Run(Application.Title + '#' //'SampleApp1#'
      , '' //   no security, we can send own name APP_PASSCODE
      , True // VARIANT_TRUE == -1 in COM
      , '*');
    ilCCOWIcons.GetIcon(2, imgCCOWState.Picture.Icon);
    //MaggMsgf.MagMsg('s','Successfully joined context on first try');
    MagAppMsg('s', 'Successfully joined context on first try'); {JK 10/7/2009 - MagMsgu refactoring}
  Except
    On OleExc: EOleException Do
    Begin

      //MaggMsgf.MagMsg('s', 'Exception in 1st attempt to join context, Exception=[(' + inttostr(OleExc.ErrorCode) + ') ' + OleExc.Message + ']');
      MagAppMsg('s', 'Exception in 1st attempt to join context, Exception=[(' +
        Inttostr(OleExc.ErrorCode) + ') ' + OleExc.Message + ']'); {JK 10/7/2009 - MagMsgu refactoring}
      Showmessage('Failed to join CCOW Context - Exiting application, Exception=[' + OleExc.Message + ']');
            // log message? (For when messages are logged to a file)
      //MaggMsgf.MagMsg('s','Failed to join CCOW context on 2nd attempt, Exception=[(' + inttostr(OleExc.ErrorCode) + ') ' + OleExc.Message + ']');
      MagAppMsg('s', 'Failed to join CCOW context on 2nd attempt, Exception=[(' +
        Inttostr(OleExc.ErrorCode) + ') ' + OleExc.Message + ']'); {JK 10/7/2009 - MagMsgu refactoring}
      Close();
      Application.Terminate();
      Exit;
        {
        try
          ContextorControl1.Run(application.Title + '#'  //'SampleApp1#'
                  , '' //   no security, we can send own name APP_PASSCODE
                  , TRUE  // VARIANT_TRUE == -1 in COM
                  , '*');
          ilCCOWIcons.GetIcon(2, imgCCOWState.Picture.Icon);
          MaggMsgf.MagMsg('s','Successfully set user context on 2nd attempt');

        except
          on OleExc : EOleException do
          begin
            ShowMessage('Failed to join CCOW Context - Exiting application, Exception=[' + OleExc.message + ']');
            // log message? (For when messages are logged to a file)
            MaggMsgf.MagMsg('s','Failed to join CCOW context on 2nd attempt, Exception=[(' + inttostr(OleExc.ErrorCode) + ') ' + OleExc.Message + ']');
            Close();
            Application.Terminate();
            exit;
          end;
        end;
        }
    End;
  End;
      {

    on e : Exception do
    begin
      ShowMessage('Failed to join CCOW Context - Exiting application, Exception=[' + e.message + ']');
      // log message? (For when messages are logged to a file)
      Close();
      Application.Terminate();
      exit;
    end;
  end;
  }

  CPRSLocation := getCPRSLocationFromRegistry();
  //MaggMsgf.MagMsg('s', 'Current CPRS Location=[' + CPRSLocation + ']');
  MagAppMsg('s', 'Current CPRS Location=[' + CPRSLocation + ']'); {JK 10/7/2009 - MagMsgu refactoring}

  FitColumnsToText();
  setMenus();
  ViewAllStudies1.Checked := True;
  ShowSpecialtiesDialogatStartup1.Checked := True;
  AutoLaunchDisplayCPRS1.Checked := True;
  ReadDays := 7; // number of days to show on the read list (might want to change default!)
  ReadDaysMax := 90; //max number of days users can view on read list
  DisplayMessage('No Connection to VistA', '');
  If Loginonstartup Then Timer1.Enabled := True;
End;

{*------------------------------------------------------------------------------
  Sets the application workstation timeout

  @author Julian Werfel
  @param minutes The number of minutes to allow the application to sit idle
    before it is closed
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.SetWorkstationTimeout(Minutes: String);
Var
  i: Integer;
Begin
  Try
    i := Strtoint(Minutes);
  Except
    On e: Exception Do i := 0;
  End;
  WorkStationTimeout := i;
  If i > 0 Then
  Begin
    //MaggMsgf.MagMsg('s', 'Setting workstation timeout to ' + inttostr(i));
    MagAppMsg('s', 'Setting workstation timeout to ' + Inttostr(i)); {JK 10/7/2009 - MagMsgu refactoring}
    MagTimeoutform.SetApplicationTimeOut(Inttostr(i), TimerTimeout);
  End;
End;

{*------------------------------------------------------------------------------
  Signs on to VistA, initializes the RemoteBrokerManager

  @author Robert Graves, Julian Werfel
  @param RemoteLogin Determines if this is a remote login or a direct login to the local VistA
  @return TRUE if login successful, FALSE otherwise
-------------------------------------------------------------------------------}

Function TfrmTRMain.SignOn(RemoteLogin: Boolean = False): Boolean;
Var
  Rmsg, UserSSN, ServiceURL: String;
  Rlist: TStrings;
  Rstat: Boolean;
  FBroker: TRPCBroker;
  Minutes: String;
  i: Integer;
Begin
  ApplicationTimedOut := False;
  If PrimaryDivisionMap = Nil Then
    PrimaryDivisionMap := TMagHashmap.Create()
  Else
    PrimaryDivisionMap.Clear();
  FBroker := Nil;
  DisplayMessage('Connecting to VistA...', '');

  LocalBroker := idmodobj.GetMagDBBroker1;
  LocalBroker.CreateBroker();

  LocalBroker.SetServer(LocalServer);
  LocalBroker.SetListenerPort(Strtoint(LocalPort));
  LocalBroker.SetContextor(ContextorControl1);
  Try
    If RemoteLogin Then
    Begin
      If Not LocalBroker.DBSelect(LocalServer, LocalPort, 'MAG WINDOWS') Then
      Begin
        DisplayMessage('No Connection to VistA.', '');
        Timer1.Enabled := False;
        Result := False;
        Exit;
      End;
    End
    Else
    Begin
      {GEK MAIN Testing. Error here on initial login..}
      If Not LocalBroker.DBConnect(LocalBroker.GetServer(), Inttostr(LocalBroker.GetListenerPort()), 'MAG WINDOWS') Then
      Begin
        DisplayMessage('No Connection to VistA.', '');
        Timer1.Enabled := False;
        Result := False;
        Exit;
      End;
    End;
    DisplayMessage('Connected to : ' + LocalBroker.GetServer + ' ' + Inttostr(LocalBroker.GetListenerPort()));
    // check installed Imaging Versions.
//RCA FIX HERE
   CheckImagingVersion(MagappTeleReader, idmodobj.GetMagDBBroker1);

    Rlist := Tstringlist.Create();
    //MaggMsgf.MagMsg('','Retrieving workstation settings');
    MagAppMsg('', 'Retrieving workstation settings'); {JK 10/7/2009 - MagMsgu refactoring}
    LocalBroker.RPMaggUser2(Rstat, Rmsg, Rlist, Wsid, GSess);
    // Set up the broker
  //RCA FIX HERE
    MagRemoteBrokerManager.Initialize(
      Wsid,
      ExtractFilePath(Application.ExeName),
      Application.ExeName,
      '',
      WrksCompName,
      WrksLocation,
      LastMagUpdate,
      1,
      Tstringlist.Create(),
      LocalBroker.GetListenerPort(),
//RCA OUT     U Mag AppMgr.GetSecurityToken,
uMagTRAppMgr.GetSecurityToken,
     idmodobj.GetMagDBBroker1.RPMagLogCapriRemoteLogin,
     magRemoteAppTeleReader);

    // JMW 4/1/08 P72 - set the log manager
    //MagRemoteBrokerManager1.OnLogEvent := dmod.MagLogManager.LogEvent;  {JK 10/7/2009 - MagMsgu refactoring}
    // JMW 4/1/08 P72 - don't use WS brokers
    MagRemoteBrokerManager1.UseWSBrokers := False;
    MagRemoteBrokerManager1.SetUserLocalDUZ(MagPiece(Rlist[1], '^', 1));
    MagRemoteBrokerManager1.SetUserFullName(MagPiece(Rlist[1], '^', 2));
    MagRemoteBrokerManager1.SetUserInitials(MagPiece(Rlist[1], '^', 3));
    MagRemoteBrokerManager1.LocalSiteCode := MagPiece(Rlist[4], '^', 3);
    MagRemoteBrokerManager1.LocalSiteStationNumber := MagPiece(Rlist[4], '^', 6);   // P127T1 NST 04/06/2012 Set Reader Site Station number
                                                                                    //                       We will use Srtion number instead of Site IEN (localsitecode)
    IsProdAccount := Magstrtobool(Rlist[8]);
    ServiceURL := '';
    If Rlist.Count > 9 Then
      ServiceURL := Rlist[9];
    //MaggMsgf.MagMsg('s','VistA Site Service URL: ' + ServiceURL);
    MagAppMsg('s', 'VistA Site Service URL: ' + ServiceURL); {JK 10/7/2009 - MagMsgu refactoring}
    If ServiceURL = '' Then
    Begin
      MagRemoteBrokerManager.RIVEnabled := False;
      //MaggMsgf.MagMsg('s','VistA Site Service has been disabled, system will ' +
      //  'not be able to connect to remote acquisition sites');
      MagAppMsg('s', 'VistA Site Service has been disabled, system will ' +
        'not be able to connect to remote acquisition sites'); {JK 10/7/2009 - MagMsgu refactoring}
    End;

    If Rlist.Count > 12 Then    //P127T1 NST 04/16/2012  Use Station Number instead of site IEN
      MagRemoteBrokerManager1.LocalPrimaryDivision := Rlist[12]
    Else
      MagRemoteBrokerManager1.LocalPrimaryDivision := MagRemoteBrokerManager1.LocalSiteCode;

    //MaggMsgf.MagMsg('s', 'Current Primary Division=[' + MagRemoteBrokerManager1.LocalPrimaryDivision + ']');
    MagAppMsg('s', 'Current Primary Division=[' + MagRemoteBrokerManager1.LocalPrimaryDivision + ']'); {JK 10/7/2009 - MagMsgu refactoring}

    // not sure this should be here, need the local site in the map so it maps properly
    // P127T1 NST - 04/06/2012  Use Site Station Number instead of Site IEN.
    PrimaryDivisionMap.put(MagRemoteBrokerManager1.LocalSiteStationNumber, MagRemoteBrokerManager1.LocalPrimaryDivision);

    MagRemoteBrokerManager.SiteServiceURL := Lowercase(ServiceURL);
    (* 93t10  Now GSess (Tsession) is set in RPC call,
     GSess.WrksInst := magpiece(rlist[4], '^',3) + '^'+ magpiece(rlist[4],'^',4) ;
    GSess.WrksPlaceIEN :=  magpiece(rlist[4], '^', 1);
    GSess.WrksPlaceCode := magpiece(rlist[4],'^', 2); *)
    LocalUserStationNumber := ''; // JMW 1/25/2007 P46T27 clear variable first (in case not found from rpc)
    LocalUserStationNumber := GSess.WrksInstStationNumber; //magpiece(rlist[4], '^', 6);

    If LocalUserStationNumber = '' Then LocalUserStationNumber := GSess.Wrksinst.ID; //93t10  magpiece(rlist[4], '^', 3);
    LocalUserStationNumber := MagRemoteBrokerManager.ParseSiteCode(LocalUserStationNumber);

    // from p46 clinical display SAF 4/16/08
    // get the primary sites station number from VistA
    // use the users local station number if not found
    If Rlist.Count > 12 Then
    Begin
      PrimarySiteStationNumber := Rlist[12];
    End;
    If PrimarySiteStationNumber = '' Then PrimarySiteStationNumber := LocalUserStationNumber;
    PnlSiteCode.caption := GSess.WrksPlaceCODE;

    //MaggMsgf.MagMsg('s','IMAGING SITE PARAMETER: '+ GSess.WrksPlaceIEN+' Site Code: '+GSess.WrksPlaceCode);
    MagAppMsg('s', 'IMAGING SITE PARAMETER: ' + GSess.WrksPlaceIEN + ' Site Code: ' + GSess.WrksPlaceCODE); {JK 10/7/2009 - MagMsgu refactoring}
    //MaggMsgf.MagMsg('s','IMAGING SITE PARAMETER Institution: '+  GSess.WrksInst.Name);   //magpiece(rlist[4],'^',4));
    MagAppMsg('s', 'IMAGING SITE PARAMETER Institution: ' + GSess.Wrksinst.Name); //magpiece(rlist[4],'^',4)); {JK 10/7/2009 - MagMsgu refactoring}
    //MaggMsgf.MagMsg('s','CONSOLIDATED SITE : '+  magbooltostr(GSess.WrksConsolidated)); // magpiece(rlist[4],'^',5));
    MagAppMsg('s', 'CONSOLIDATED SITE : ' + Magbooltostr(GSess.WrksConsolidated)); // magpiece(rlist[4],'^',5)); {JK 10/7/2009 - MagMsgu refactoring}
    //MaggMsgf.MagMsg('s','DUZ(2): '+ GSess.WrksInst.ID);
    MagAppMsg('s', 'DUZ(2): ' + GSess.Wrksinst.ID); {JK 10/7/2009 - MagMsgu refactoring}
    //MaggMsgf.MagMsg('s','LOCAL USER STATION NUMBER: ' + LocalUserStationNumber);
    MagAppMsg('s', 'LOCAL USER STATION NUMBER: ' + LocalUserStationNumber); {JK 10/7/2009 - MagMsgu refactoring}
    //MaggMsgf.MagMsg('s','PRIMARY DIVISION IEN: ' + MagRemoteBrokerManager1.LocalPrimaryDivision);
    MagAppMsg('s', 'PRIMARY DIVISION IEN: ' + MagRemoteBrokerManager1.LocalPrimaryDivision); {JK 10/7/2009 - MagMsgu refactoring}
    //MaggMsgf.MagMsg('s','PRIMARY STATION NUMBER: ' + PrimarySiteStationNumber);
    MagAppMsg('s', 'PRIMARY STATION NUMBER: ' + PrimarySiteStationNumber); {JK 10/7/2009 - MagMsgu refactoring}

    For i := 5 To Rlist.Count - 1 Do
    Begin
      //MaggMsgf.MagMsg('s',rlist[i]);
      MagAppMsg('s', Rlist[i]); {JK 10/7/2009 - MagMsgu refactoring}
    End;

    // Get the user's SSN and set it in the remote broker manager
    UserSSN := LocalBroker.GetUserSSN();
    MagRemoteBrokerManager1.SetUserSSN(UserSSN);

    SetFormCaption(False);
    //self.RIV Attach_();
    RIVAttachListener(Self);
//    fMagRemoteToolbar1.RIV Attach_();
    RIVAttachListener(FMagRemoteToolbar1);

    {/ P94 JMW 9/30/2009 - get the security token from the local database /}
//RCA FIX HERE    gsess.SecurityToken := GetSecurityToken();
    //MaggMsgf.MagMsg('s', 'Received security token [' + GSess.SecurityToken + '] for this session.');
    MagAppMsg('s', 'Received security token [' + GSess.SecurityToken + '] for this session.'); {JK 10/7/2009 - MagMsgu refactoring}

    FMagRemoteToolbar1.ForTeleReader := True;

    // get the security keys for the user
    SecurityKeys.Clear();
    //maggmsgf.MagMsg('s', 'Retrieving user''s security keys: ');
    MagAppMsg('s', 'Retrieving user''s security keys: '); {JK 10/7/2009 - MagMsgu refactoring}
    idmodobj.GetMagDBBroker1.RPMaggUserKeys(SecurityKeys);
    InitializeSecurityKeyObjects();

    {JK 10/7/2009 - MagMsgu refactoring}
    If SecurityKeys.Indexof('MAG SYSTEM') > -1 Then
      MagTRMsg.SetPrivLevel(magmsgprivAdmin)
    Else
      MagTRMsg.SetPrivLevel(magmsgprivUser);

    // Get the user preferences from VistA
    getApplyUserPreferences();

    // Retrieve the specialties for the user
    //GetSitesSpecialties();

    // JMW 11/20/2006 T26
    // reset the timeout from the MAG308, then if that value is 0 (or empty),
    // it will run the rpc and get the value from VistA
    SetWorkstationTimeout(FMagINITimeout);

    If (WorkStationTimeout = 0) Then LocalBroker.RPMaggGetTimeout('TELEREADER', Minutes);
    If (Minutes <> '') Then SetWorkstationTimeout(Minutes); //  MagTimeoutform.SetApplicationTimeOut(minutes, timerTimeout);

    Pnlmsg.caption := '';
  Except On e: Exception Do
    Begin
      Showmessage(e.Message);
//      application.Terminate();
      Result := False;
      Timer1.Enabled := False;
      DisplayMessage('Error connecting to VistA', '');
      If FBroker <> Nil Then FBroker.Connected := False;
      Exit;
    End;
  End;
  setMenus();
  Result := True;
  FirstReadListLoad := True;
End;

{*------------------------------------------------------------------------------
  Determines if the system messages can be displayed in the log dialog.

  @author Julian Werfel
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.InitializeSecurityKeyObjects();
Begin
  //MaggMsgf.EnableSysMemo((SecurityKeys.indexof('MAG SYSTEM') > -1));
  {JK 10/7/2009 - MagMsgu refactoring}
  If SecurityKeys.Indexof('MAG SYSTEM') > -1 Then
    MagTRMsg.SetPrivLevel(magmsgprivAdmin)
  Else
    MagTRMsg.SetPrivLevel(magmsgprivUser);
  // could also check if user has MAG SYSTEM to allow more than 60 days on read list
End;

{*------------------------------------------------------------------------------
  Sets the enabled menu options based on the connectivity status to VistA

  @author Julian Werfel
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.setMenus();
Begin
  If (LocalBroker = Nil) Or (Not LocalBroker.IsConnected) Then
  Begin
    Options1.Enabled := False;
    Refresh1.Enabled := False;
    Logout1.Enabled := False;
    ViewAllStudies1.Enabled := False;
  End
  Else
  Begin
    Options1.Enabled := True;
    Refresh1.Enabled := True;
    Logout1.Enabled := True;
    ViewAllStudies1.Enabled := True;
  End;
End;

{*------------------------------------------------------------------------------
  Retrieves the site specialties for the current user.  Updates the Specialties
  dialog with these values

  @author Robert Graves, Julian Werfel
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.GetSitesSpecialties();
Var
  Msg: String;
  Specialties: TStrings;
  specCount: Integer;
Begin
  DisplayMessage('Getting your remote sites\specialties\procedures', '');
  Specialties := Tstringlist.Create();
  If LocalBroker.RPMagGetTeleReader(Specialties, Msg) Then
  Begin
    SpecCount := Specialties.Count;
    If SpecCount <= 1 Then
      SpecCount := 0
    Else
      SpecCount := SpecCount - 1;
    //MaggMsgf.MagMsg('', 'User has [' + inttostr(SpecCount) + '] procedures assigned');
    MagAppMsg('', 'User has [' + Inttostr(SpecCount) + '] procedures assigned'); {JK 10/7/2009 - MagMsgu refactoring}
    frmMagTeleReaderOptions.SetSpecialtyList(Specialties);
  End
  Else
  Begin
    //MaggMsgf.MagMsg('', 'Error retrieving your assigned procedures, Exception=[' + msg + ']');
    MagAppMsg('', 'Error retrieving your assigned procedures, Exception=[' + Msg + ']'); {JK 10/7/2009 - MagMsgu refactoring}
    Showmessage('Error retrieving your assigned procedures, Exception=[' + Msg + ']');
    Specialties.Free();
    Exit;
  End;
  Specialties.Free();
End;

{*------------------------------------------------------------------------------
  Connects to the remote sites specified in the Specialties dialog (does not
  create a remote connection to the local site.  Only creates 1 connection for
  each site regardless of how many specialties are from that site.

  @author Julian Werfel
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.ConnectToRemoteSites();
Var
  i: Integer;
  SiteCodes: String;
  Specialty: TMagUserSpecialty;
  SpecialtyList: Tlist;
  TreatingList: TStrings;
  j: Integer;
  tempSpecialty: TMagUserSpecialty;
  Found: Boolean;
Begin
  //MaggMsgf.MagMsg('','Determining remote sites to use to retrieve selected specialties');
  MagAppMsg('', 'Determining remote sites to use to retrieve selected specialties'); {JK 10/7/2009 - MagMsgu refactoring}
  TreatingList := Tstringlist.Create();
  SpecialtyList := frmMagTeleReaderOptions.getSelectedSpecialties();
  For i := 0 To SpecialtyList.Count - 1 Do
  Begin
    Specialty := SpecialtyList.Items[i];
   {/ P127T1 NST 04/06/2012 Refactor Property name to reflect the meaning /}
    If Not (MagRemoteBrokerManager1.LocalPrimaryDivision = Specialty.PrimaryDivisionStationNumber) Then
      SiteCodes := addUniquePiece(SiteCodes, Specialty.PrimaryDivisionStationNumber, '^');
    // add entry to treating list stringlist in case the site does not exist it
    // can still show its full name in RIV Toolbar

    // JMW 6/14/2006 p46t17
    // The following ensures that the site name in the toolbar will show either
    // the current division being used or the primary divison if that is selected
    // if the primary division is not selected, it will use the division that is selected
    // if multiple divisions are selected (none primary) then it will show a random division
    {/ P127T1 NST 04/06/2012 Refactor Property name to reflect the meaning /}
    If Specialty.PrimaryDivisionStationNumber = Specialty.SiteStationNumber Then
      TreatingList.Add(Specialty.PrimaryDivisionStationNumber + '^' + Specialty.SiteName)
    Else
    Begin

      Found := False;
      For j := 0 To SpecialtyList.Count - 1 Do
      Begin
        tempSpecialty := SpecialtyList.Items[j];
        {/ P127T1 NST 04/06/2012 Refactor Property name to reflect the meaning /}
        If tempSpecialty.SiteStationNumber = Specialty.PrimaryDivisionStationNumber Then
          Found := True;
      End;
      If Not Found Then
      Begin
        {/ P127T1 NST 04/06/2012 Refactor Property name to reflect the meaning /}
        TreatingList.Add(Specialty.PrimaryDivisionStationNumber + '^' + Specialty.SiteName)
      End;
    End;

  End;
  If SiteCodes = '' Then
  Begin
    //MaggMsgf.MagMsg('s', 'No remotes sites selected, not making any remote connections');
    MagAppMsg('s', 'No remotes sites selected, not making any remote connections'); {JK 10/7/2009 - MagMsgu refactoring}
    MagRemoteBrokerManager1.ClearActiveRemoteBrokers();
  End
  Else
  Begin
    //MaggMsgf.MagMsg('s','Creating connections to remote sites [' + SiteCodes + ']');
    MagAppMsg('s', 'Creating connections to remote sites [' + SiteCodes + ']'); {JK 10/7/2009 - MagMsgu refactoring}
    MagRemoteBrokerManager1.CreateBrokerFromSiteCodes(SiteCodes, TreatingList);
  End;
  TreatingList.Free();
End;

{*------------------------------------------------------------------------------
  Determines if the user has any locked work items, if so prompts the user to
    unlock them automatically.

  @author Julian Werfel
  @returns True if the user wants to continue closing, false otherwise
-------------------------------------------------------------------------------}

Function TfrmTRMain.checkLockedWorkItems(): Boolean;
Var
  Listitem: TListItem;
  i, msgBoxResult, LockedCount: Integer;
  WorkItem: TMagWorkItem;
  LockedItems: Tlist;
  unlockResult: String;
Begin
  LockedCount := 0;
  LockedItems := Tlist.Create();
  For i := 0 To lvUnreadList.Items.Count - 1 Do
  Begin
    Listitem := lvUnreadList.Items[i];
    WorkItem := Listitem.Data; // TMagWorkItem(ListItem.Data);
     // check to see if work item is locked, locked by current user at local site
    If CanAutoUnlockWorkItem(WorkItem) Then
    Begin
      LockedCount := LockedCount + 1;
      LockedItems.Add(WorkItem);
    End;
  End;
  WorkItem := Nil;
  Result := True;
  If LockedCount > 0 Then
  Begin
    msgBoxResult := Messagedlg('You have ' + Inttostr(LockedCount) + ' Work Item(s) locked, would you like to automatically unlock them before you disconnect?',
      //Mtinformation, [MbYes, MbNo, Mbcancel], 0, {, mbYes}); // = mrYes
      Mtinformation, [MbYes, MbNo, Mbcancel], 0); // = mrYes
    If msgBoxResult = MrYes Then
    Begin
      // unlock all work items and continue logging off/closing application
      For i := 0 To LockedItems.Count - 1 Do
      Begin
        WorkItem := LockedItems.Items[i];
        unlockResult := WorkItem.Lock();
        If (MagPiece(unlockresult, '|', 1) = '0') Then // lock succeeded
        Begin
          //MaggMsgf.MagMsg('','Unlocked work item consult # [' + inttostr(WorkItem.AcquisitionSiteConsultNumber) + ']');
          MagAppMsg('', 'Unlocked work item consult # [' + Inttostr(WorkItem.AcquisitionSiteConsultNumber) + ']'); {JK 10/7/2009 - MagMsgu refactoring}
        End
        Else
        Begin
          //MaggMsgf.MagMsg('s','Failed to unlock work item [' + inttostr(WorkItem.AcquisitionSiteConsultNumber) + '], Error is [' + magpiece(unlockResult, '|', 2) + ']');
          MagAppMsg('s', 'Failed to unlock work item [' + Inttostr(WorkItem.AcquisitionSiteConsultNumber) + '], Error is [' +
            MagPiece(unlockResult, '|', 2) + ']'); {JK 10/7/2009 - MagMsgu refactoring}
        End;
      End; {For}
      Result := True;
    End
    Else
      If msgBoxResult = MrNo Then
      Begin
      // do nothing, continue logging off/closing application
        Result := True;
      End
      Else
        If msgBoxResult = MrCancel Then
        Begin
      // user canceled operation, don't close/logoff
          Result := False;
        End;
  End;
End;

{*------------------------------------------------------------------------------
  Determines if a work item is locked and can be auto-unlocked by the user
   (if they own the rights to the item)

  @author Julian Werfel
-------------------------------------------------------------------------------}

Function TfrmTRMain.CanAutoUnlockWorkItem(WorkItem: TMagWorkItem): Boolean;
Begin
  Result := False;
  If WorkItem.Status <> 'L' Then Exit;
  If WorkItem.ReaderDUZ <> MagRemoteBrokerManager1.GetUserLocalDUZ Then Exit;
  // P127T1 NST 04/09/2012 - Refactor Property Names
  If (WorkItem.ReadingSitePrimaryDivisionStationNumber = MagRemoteBrokerManager1.LocalPrimaryDivision) Or
    ((WorkItem.ReadingSiteCode = '') And (WorkItem.AcquisitionSitePrimaryDivisionStationNumber = MagRemoteBrokerManager1.LocalPrimaryDivision)) Then     {/ P127T1 NST - Refactored Property name /}
    Result := True;
End;

{*------------------------------------------------------------------------------
  Updates the data from each remote site. Modifies the values of work items for
  any work item that has changed since the last update of the list.

  @author Robert Graves, Julian Werfel
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.UpdateReadingLists();
Var
  i, j: Integer;
  Results: TStrings;
  WorkItem: TMagWorkItem;
  Listitem: TListItem;
  Specialty: TMagUserSpecialty;
  SpecialtyList: Tlist;
  RPCIterationCount, RPCIterationTotal: Integer;
  MDate: String;
  DUZValue, StatusValue, LastUpdateValue, Msg: String;
Begin
  //MaggMsgf.MagMsg('','Updating specialty work items');
  MagAppMsg('', 'Updating specialty work items'); {JK 10/7/2009 - MagMsgu refactoring}
  SpecialtyList := frmMagTeleReaderOptions.getSelectedSpecialties();

  If FirstReadListLoad Then
    RPCIterationTotal := 2
  Else
    RPCIterationTotal := 1;

  If ViewAllStudies1.Checked Then
    DUZValue := '0'
  Else
    DUZValue := MagRemoteBrokerManager1.GetUserLocalDUZ();

  For i := 0 To SpecialtyList.Count - 1 Do
  Begin
    Specialty := SpecialtyList.Items[i];
    DisplayMessage('Getting the reading list from ' + Specialty.SiteName + ' for Specialty [' + Specialty.SpecialtyName + ']', '');
    //MaggMsgf.MagMsg('s', 'Acquisition Site=[' + Specialty.SiteName + '], SiteTimeOut=[' + inttostr(Specialty.SiteTimeOut) + ']');
    MagAppMsg('s', 'Acquisition Site=[' + Specialty.SiteName + '], SiteTimeOut=[' +
      Inttostr(Specialty.SiteTimeOut) + ']'); {JK 10/7/2009 - MagMsgu refactoring}

    For RPCIterationCount := 1 To RPCIterationTotal Do
    Begin
      Results := Tstringlist.Create();
      LastUpdateValue := Specialty.LastUpdate;
      If FirstReadListLoad Then
      Begin
        If RPCIterationCount = 1 Then
        Begin
          StatusValue := 'UWL'
        End
        Else
        Begin
          //p106 rlm 20100806 start
          If HideDiscontinuedConsults Then
          Begin
            StatusValue := 'R';
          End
          Else
          Begin
            StatusValue := 'CR';
          End;
          //p106 rlm 20100806 end
          MDate := BuildMDate(ReadDays);
          LastUpdateValue := MDate; // BuildMDate(ReadDays); //'3051220.120101';//  'T-' + inttostr(ReadDays);
        End;
      End
      Else
      Begin
        // if the LastUpdateValue is empty, then there were no studies from this
        // site, only retrieve the ReadDays # of days
        If LastUpdateValue = '' Then
          LastUpdateValue := BuildMDate(ReadDays);
        // retrieve work items for any status type
        //p106 rlm 20100806 start
        If HideDiscontinuedConsults Then
        Begin
          StatusValue := 'UWLR';
        End
        Else
        Begin
          StatusValue := 'UWLCR';
        End;
        //p106 rlm 20100806 end
      End;

      //MaggMsgf.MagMsg('s', 'StatusValue=' + StatusValue);
      MagAppMsg('s', 'StatusValue=' + StatusValue); {JK 10/7/2009 - MagMsgu refactoring}
      //MaggMsgf.MagMsg('s','LastUpdateValue=' + LastUpdateValue);
      MagAppMsg('s', 'LastUpdateValue=' + LastUpdateValue); {JK 10/7/2009 - MagMsgu refactoring}
      If Not LocalBroker.RPMagTeleReaderUnreadlistGet(Results, Msg, Specialty.PrimaryDivisionStationNumber, Specialty.SiteStationNumber, Inttostr(Specialty.SpecialtyCode),
        Specialty.ProcedureStrings, LastUpdateValue, DUZValue, MagRemoteBrokerManager1.LocalSiteCode, Inttostr(Specialty.SiteTimeOut),
        StatusValue, MagRemoteBrokerManager1.LocalSiteStationNumber) Then   // P127T1 NST 04/09/2012  Added  LocalSiteStationNumber parameter
      Begin
        //MaggMsgf.MagMsg('s', msg);
        MagAppMsg('s', Msg); {JK 10/7/2009 - MagMsgu refactoring}
        Continue;
      End;
      // JMW 6/14/06 p46 set image count for the site (based on primary divison)
      RIVNotifyAllListeners(Self, 'SetImageCount', Specialty.PrimaryDivisionStationNumber + '^-1');  // P127T1 NST 04/09/2012 Refactor Property Name
      For j := 1 To Results.Count - 1 Do
      Begin
        WorkItem := TMagWorkItem.Create(Results[j], LocalBroker);
        Listitem := FindListItem(WorkItem);
        If (Listitem <> Nil) Then
          UpdateWorkItem(Listitem, WorkItem)
        Else
          AddWorkItem(WorkItem);
        // since we run the RPC twice (on first attempt) the last DateReceivedTime
        // might not be the latest value (if the first list had an older update)
        If WorkItem.DataReceivedTime > Specialty.LastUpdate Then
          Specialty.LastUpdate := WorkItem.DataReceivedTime;
      End;
    End;
    lvUnreadList.AlphaSort();
  End; {End of for loop for specialties}
  lvUnreadList.AlphaSort();
  lvReadList.AlphaSort();
  // need to sort read list too?
  RIVNotifyAllListeners(Self, 'ServerConnectionsComplete', ''); // adds connect all button...
  Pnlmsg.caption := '';
  FirstReadListLoad := False;
End;

{*------------------------------------------------------------------------------
  Finds the work item in either the read or unread list based on the WorkItem.ID

  @author Robert Graves
  @param WorkItem The workitem to find in the read/unread list
  @return The TListItem that corresponds to the work item, nil if not found.
-------------------------------------------------------------------------------}

Function TfrmTRMain.FindListItem(WorkItem: TMagWorkItem): TListItem;
Var
  i: Integer;
  Listitem: TListItem;
  ListWorkItem: TMagWorkItem;
Begin
  Result := Nil;
  For i := 0 To lvUnreadList.Items.Count - 1 Do
  Begin
    Listitem := lvUnreadList.Items[i];
    ListWorkItem := TMagWorkItem(Listitem.Data);
    If ((ListWorkItem.ID = WorkItem.ID)
      And (ListWorkItem.AcquisitionSiteStationNumber = WorkItem.AcquisitionSiteStationNumber)) Then  {/ P127T1 NST 04/09/2012 - Refactored Property name /}
    Begin
      Result := Listitem;
      Break;
    End;
  End;
  If ((Result = Nil) And ((WorkItem.Status = 'R') Or (WorkItem.Status = 'C'))) Then
  Begin
    For i := 0 To lvReadList.Items.Count - 1 Do
    Begin
      Listitem := lvReadList.Items[i];
      ListWorkItem := TMagWorkItem(Listitem.Data);
      If ((ListWorkItem.ID = WorkItem.ID)
        And (ListWorkItem.AcquisitionSiteStationNumber = WorkItem.AcquisitionSiteStationNumber)) Then  {/ P127T1 NST 04/09/2012 - Refactored Property name /}
      Begin
        Result := Listitem;
        Break;
      End;
    End;
  End;
End;

{*------------------------------------------------------------------------------
  Adds the work item to the read list or unread list based on the
  WorkItem.Status

  @author Robert Graves
  @param WorkItem The Work Item to add
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.AddWorkItem(WorkItem: TMagWorkItem);
Var
  List: TListView;
  Listitem: TListItem;
  i: Integer;
Begin
  // do not add items with status of D (Deleted)
  If WorkItem.Status = 'D' Then
  Begin
    //MaggMsgf.MagMsg('s', 'WorkItem [' + inttostr(WorkItem.ID) + '] has status deleted, will not add to list');
    MagAppMsg('s', 'WorkItem [' + Inttostr(WorkItem.ID) + '] has status deleted, will not add to list'); {JK 10/7/2009 - MagMsgu refactoring}
    Exit;
  End;
  If (WorkItem.Status = 'R') Or (WorkItem.Status = 'C') Then
    List := lvReadList
  Else
    List := lvUnreadList;
  Listitem := List.Items.Add();
  For i := 1 To List.Columns.Count Do
    Listitem.SubItems.Add('');
  Listitem.ImageIndex := -1;
  UpdateWorkItem(Listitem, WorkItem);
End;

{*------------------------------------------------------------------------------
  Updates the work Item specififed along with the associated TLisTItem

  @author Robert Graves
  @param ListItem The list object that represents the Work item in the read/unread list
  @param WorkItem the work item that has been updated
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.UpdateWorkItem(Listitem: TListItem; WorkItem: TMagWorkItem);
Begin
  // special case for items with status of D (Deleted)
  // remove from either list
  If WorkItem.Status = 'D' Then
  Begin
    //MaggMsgf.MagMsg('s', 'Work Item [' + inttostr(WorkItem.ID) + '] has been deleted, removing from list');
    MagAppMsg('s', 'Work Item [' + Inttostr(WorkItem.ID) + '] has been deleted, removing from list'); {JK 10/7/2009 - MagMsgu refactoring}
    If (Listitem.ListView = lvUnreadList) Then
      lvUnreadList.Items.Delete(lvUnreadList.Items.Indexof(Listitem))
    Else
      lvReadList.Items.Delete(lvReadList.Items.Indexof(Listitem));
    Exit;
  End;
  If ((Listitem.ListView = lvUnreadList) And ((WorkItem.Status = 'R') Or (WorkItem.Status = 'C'))) Then
  Begin
    If (WorkItem <> TMagWorkItem(Listitem.Data)) Then
      TMagWorkItem(Listitem.Data).Free();
    lvUnreadList.Items.Delete(lvUnreadList.Items.Indexof(Listitem));
    AddWorkItem(WorkItem);
  End
  Else
  Begin
    If ((UserCanLock(WorkItem))
      And (WorkItem.ReaderDUZ = MagRemoteBrokerManager1.GetUserLocalDUZ)
      And (WorkItem.Status = 'L')) Then
      Listitem.ImageIndex := 0
    Else
      Listitem.ImageIndex := -1;
    Listitem.caption := WorkItem.StatusName;
    Listitem.SubItems[0] := WorkItem.Urgency;
    Listitem.SubItems[1] := WorkItem.ReaderInitials;
    Listitem.SubItems[2] := WorkItem.AcquisitionSiteShort;
    {TODO: consider using something other than Local for local consults}
    If (WorkItem.ReadingSiteShort = '') Then
      Listitem.SubItems[3] := 'Local'
    Else
      Listitem.SubItems[3] := WorkItem.ReadingSiteShort;
    Listitem.SubItems[4] := Inttostr(WorkItem.AcquisitionSiteConsultNumber);
    If (WorkItem.IFCConsultNumber <> 0) Then
      Listitem.SubItems[5] := Inttostr(WorkItem.IFCConsultNumber);
    Listitem.SubItems[6] := WorkItem.PatientName;
    Listitem.SubItems[7] := WorkItem.LastImageAcquiredTime;
    Listitem.SubItems[8] := Inttostr(WorkItem.NumberOfImages);
    If (Listitem.ListView = lvReadList) Then
      Listitem.SubItems[9] := WorkItem.EndReadingTime;

    If ((Listitem.Data <> Nil) And (WorkItem <> TMagWorkItem(Listitem.Data))) Then
      TMagWorkItem(Listitem.Data).Free();
    Listitem.Data := WorkItem;

    If (Listitem = lvUnreadList.Selected) Or (Listitem = lvReadList.Selected) Then
    Begin
//      lvUnreadList.Selected := nil;
//      lvReadList.Selected := nil;
      UpdateLockButton(WorkItem);
    End;

  End;
End;

{ }
{*------------------------------------------------------------------------------
  Displays the TeleReader option dialog, connects to the remote sites and stores
  the preferences for the user

  @author Julian Werfel
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.ViewTeleReaderOptions();
Var
  i: Integer;
  Specialty: TMagUserSpecialty;
  UserWantValue: String;
  Res: String;
  Node: TTreeNode;
  CheckedValue: Boolean;
Begin
  //MaggMsgf.MagMsg('','Displaying Specialty Options Dialog');
  MagAppMsg('', 'Displaying Specialty Options Dialog'); {JK 10/7/2009 - MagMsgu refactoring}
  frmMagTeleReaderOptions.Showmodal();
  If frmMagTeleReaderOptions.SaveSettings Then
  Begin
    For i := 0 To frmMagTeleReaderOptions.treSpecialties.Items.Count - 1 Do
    Begin
      Node := frmMagTeleReaderOptions.treSpecialties.Items[i];
      Specialty := Node.Data;
      If Node.Level = fMagTeleReaderOptions.cNodeTypeProcedure Then
      Begin
        CheckedValue := fMagTeleReaderOptions.StateChecked(Node.StateIndex);
        If (Specialty.UserWants <> CheckedValue) Then
        Begin
          Specialty.UserWants := CheckedValue; // frmMagTeleReaderOptions.lvSpecialtiesList.Items[i].Checked;
          UserWantValue := Magbooltostrint(Specialty.UserWants);
          {/ P127T1 NST 04/06/2012 Refactor Property name to reflect the meaning /}
          If LocalBroker.RPMagSetTeleReader(Res, Specialty.SiteStationNumber, Inttostr(Specialty.SpecialtyCode), Inttostr(Specialty.ProcedureCode), UserWantValue) Then
          Begin
            //MaggMsgf.MagMsg('s','Result of updating specialty[' + Specialty.SpecialtyIEN + '] preference: ' + res);
            MagAppMsg('s', 'Result of updating specialty[' + Specialty.SpecialtyIEN + '] preference: ' + Res); {JK 10/7/2009 - MagMsgu refactoring}
          End
          Else
          Begin
            Showmessage('Exception updating specialty, Exception=[' + Res + ']');
            //MaggMsgf.MagMsg('s','Exception updating specialty[' + Specialty.SpecialtyIEN + '] preference, Exception=[' + res + ']');
            MagAppMsg('s', 'Exception updating specialty[' + Specialty.SpecialtyIEN + '] preference, Exception=[' + Res + ']'); {JK 10/7/2009 - MagMsgu refactoring}
          End;
        End; {value changed}
      End; {is procedure?}
    End; {for}
  End; {save settings}
  ConnectToRemoteSites();
End;

{*------------------------------------------------------------------------------
  Executed for each timer event.  If not connected it will attempt to login and
    initialize the system

  @author Robert Graves, Julian Werfel
  @param Sender Object which called this function
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.Timer1Timer(Sender: Tobject);
Begin
  Timer1.Enabled := False;
  If (Self.IsFirstTick) Then
  Begin

    If SignOn(AllowRemoteLogin) Then
    Begin

      If (isThinClient()) And (Not LocalBroker.RPMag3TRThinClientAllowed) Then
      Begin
        Self.Hide();
        Application.Processmessages;
        ShowMessage508('User does not have thin client rights for VistA Imaging TeleReader.' +
          #13 + #13 + 'TeleReader will close.', Self.Handle);
        Close();
        Application.Terminate();
        Application.Processmessages();
        Exit;
      End;

      GetSitesSpecialties();

      If DisplayOptionsOnStartup() Then
        ViewTeleReaderOptions()
      Else
        ConnectToRemoteSites();
      IsFirstTick := False;
      Timer1.Interval := 120000; // This should be comming out of a configuration file or VistA

    End

    Else
    Begin
      Timer1.Interval := 100;
      Exit;
    End;

  End;
  UpdateReadingLists();
  Timer1.Enabled := True;
End;

Function TfrmTRMain.DisplayOptionsOnStartup(): Boolean;
Var
  Rlist: Tlist;
Begin
  Result := False;
  // also check in here to see if no specialties are selected, if none are
  // selected then the dialog should be displayed
  Rlist := frmMagTeleReaderOptions.getSelectedSpecialties();
  If (ShowSpecialtiesDialogatStartup1.Checked) Or (Rlist.Count = 0) Then
  Begin
    Result := True;
  End;
End;

{*------------------------------------------------------------------------------
  Executed when the menu option is clicked by the user, closes the application

  @author Robert Graves
  @param Sender Object which called this function
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.Exit1Click(Sender: Tobject);
Begin
  Close();
  Application.Terminate();
End;

{*------------------------------------------------------------------------------
  Executed when the menu option is clicked by the user, refreshes the items in
    the read/unread lists

  @author Robert Graves
  @param Sender Object which called this function
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.Refresh1Click(Sender: Tobject);
Begin
  Timer1Timer(Self);
End;

{*------------------------------------------------------------------------------
  Determines if a work item can be locked by the current user

  @author Robert Graves
  @param WorkItem item to determine if can be locked
  @return True if the work item can be locked, false otherwise
-------------------------------------------------------------------------------}

Function TfrmTRMain.UserCanLock(WorkItem: TMagWorkItem): Boolean;
Begin
  Result := False;
  {/ P127T1 NST 04/06/2012 Refactor Property name to reflect the meaning /}
  If (WorkItem.Status = 'U') Then
  Begin
    If ((WorkItem.ReadingSitePrimaryDivisionStationNumber = MagRemoteBrokerManager1.LocalPrimaryDivision)
      Or
        ((WorkItem.ReadingSiteCode = '') And (WorkItem.AcquisitionSitePrimaryDivisionStationNumber = MagRemoteBrokerManager1.LocalPrimaryDivision))) Then
      Result := True;
  End
  Else
    If ((WorkItem.Status = 'L')
      And
        (WorkItem.ReaderDUZ = MagRemoteBrokerManager1.GetUserLocalDUZ())
      And
        ((WorkItem.ReadingSitePrimaryDivisionStationNumber = MagRemoteBrokerManager1.LocalPrimaryDivision)
         Or
         (((WorkItem.ReadingSiteCode = '') And (WorkItem.AcquisitionSitePrimaryDivisionStationNumber = MagRemoteBrokerManager1.LocalPrimaryDivision))))) Then
      Result := True;
End;

{*------------------------------------------------------------------------------
  Event occurs when the user selects an item in either the read or unread list

  @author Robert Graves
  @param Sender Object which called this function
  @param Item The Item in the list which is selected
  @param Selected Determines if the item is selected
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.ReadingListSelectItem(Sender: Tobject;
  Item: TListItem; Selected: Boolean);
Var
  WorkItem: TMagWorkItem;
  inContext: Boolean;
Begin
  WorkItem := Nil;
  inContext := False;
  If (Selected) Then
  Begin
    WorkItem := TMagWorkItem(Item.Data);
    inContext := IsInContext(WorkItem);
    lblPatientData.caption := WorkItem.PatientName;
    lblShortIDData.caption := WorkItem.PatientShortID;
    lblAcqSiteData.caption := WorkItem.AcquisitionSiteShort;
    If (WorkItem.ReadingSiteShort = '') Then
      lblReadingSiteData.caption := 'Local'
    Else
      lblReadingSiteData.caption := WorkItem.ReadingSiteShort;
    If (lblReadingSiteData.caption = '0') Then
      lblReadingSiteData.caption := '';
    lblConsultNumData.caption := Inttostr(WorkItem.AcquisitionSiteConsultNumber);
    lblIFCNumData.caption := Inttostr(WorkItem.IFCConsultNumber);
    If (lblIFCNumData.caption = '0') Then
      lblIFCNumData.caption := '';
    lblStatusData.caption := WorkItem.StatusName;
    lblUrgencyData.caption := WorkItem.Urgency;
    lblAcqStartData.caption := WorkItem.ImageAcquisitionStartTime;
    lblLastImageTimeData.caption := WorkItem.LastImageAcquiredTime;
    lblNumImagesData.caption := Inttostr(WorkItem.NumberOfImages);
    lblReaderData.caption := WorkItem.ReaderName;
    lblContextWarning.Visible := Not inContext;
    lblSpecialtyData.caption := WorkItem.SpecialtyName;
    lblProcedureData.caption := WorkItem.ProcedureName;
  End
  Else
  Begin
    lblPatientData.caption := '';
    lblShortIDData.caption := '';
    lblReadingSiteData.caption := '';
    lblConsultNumData.caption := '';
    lblIFCNumData.caption := '';
    lblStatusData.caption := '';
    lblUrgencyData.caption := '';
    lblAcqStartData.caption := '';
    lblLastImageTimeData.caption := '';
    lblNumImagesData.caption := '';
    lblReaderData.caption := '';
    lblContextWarning.Visible := False;
    lblSpecialtyData.caption := '';
    lblProcedureData.caption := '';
    lblAcqSiteData.caption := '';
  End;
  SetFormCaption(inContext);
  UpdateLockButton(WorkItem);
End;

{*------------------------------------------------------------------------------
  Updates the ability of the lock button to be pressed Based on the WorkItem

  @author Robert Graves
  @param WorkItem Item to use to determine status of lock button
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.UpdateLockButton(WorkItem: TMagWorkItem);
Begin
  btnLock.caption := 'Lock';
  btnLock.Hint := 'Click here to lock the study and change context to selected patient';
  If (WorkItem <> Nil) Then
  Begin
    btnLock.Enabled := UserCanLock(WorkItem);
    If ((WorkItem.Status = 'L') And (btnLock.Enabled)) Then
    Begin
      btnLock.caption := 'Unlock';
      btnLock.Hint := 'Click here to unlock the study';
    End;
    btnView.Enabled := True;
  End
  Else
  Begin
    btnLock.Enabled := False;
    btnView.Enabled := False; // disable the view button if nothing is selected
  End;
  // set the menu options properly based on the buttons
  lock1.caption := btnLock.caption;

  lock1.Enabled := btnLock.Enabled;
  View1.Enabled := btnView.Enabled;
End;

{*------------------------------------------------------------------------------
  Event occurs when the user selects a page(tab) in the page control

  @author Robert Graves
  @param Sender Object which called this function
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.PageControl1Change(Sender: Tobject);
Begin
  OnPageChange();
End;

Procedure TfrmTRMain.OnPageChange();
Var
  ActiveList, InactiveList: TListView;
Begin
  ActiveList := GetActiveReadingList();
  If ActiveList = lvUnreadList Then
    InactiveList := lvReadList
  Else
    InactiveList := lvUnreadList;
  InActiveList.Selected := Nil;
  ReadingListSelectItem(ActiveList, ActiveList.Selected, ActiveList.Selected <> Nil);
End;

{*------------------------------------------------------------------------------
  Event occurs when the user clicks the view button

  @author Robert Graves
  @param Sender Object which called this function
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.btnViewClick(Sender: Tobject);
Begin
  ShowSelectedPatient();
  VerifyContextConnected
End;

{*------------------------------------------------------------------------------
  Returns the list which is visible to the user (read or unread list)

  @author Robert Graves
  @return The TListView object which is active
-------------------------------------------------------------------------------}

Function TfrmTRMain.GetActiveReadingList(): TListView;
Var
  ActiveList: TListView;
Begin
  If (PageControl1.ActivePageIndex = 0) Then
    ActiveList := lvUnreadList
  Else
    ActiveList := lvReadList;
  Result := ActiveList;
End;

{*------------------------------------------------------------------------------
  Displays the patient for the selected work item.  Changes the patient context
    and updates the patient information in the TeleReader

  @author Robert Graves
  @return True if the patient context change was successful, false otherwise
-------------------------------------------------------------------------------}

Function TfrmTRMain.ShowSelectedPatient(CheckSensitivePatient: Boolean = True): Boolean;
Var
  WorkItem: TMagWorkItem;
Begin
  WorkItem := TMagWorkItem(GetActiveReadingList().Selected.Data);
  If CheckSensitivePatient Then
  Begin
    If Not checkPatientSensitiveContinue(WorkItem) Then Exit;
  End;
  Result := ChangePatientContext(WorkItem);
  If (Result) Then
  Begin
    SetFormCaption(Result);
    lblContextWarning.Visible := False;
  End;
  checkDisplayCPRSLaunched();
End;

{*------------------------------------------------------------------------------
  Changes the patient context based on the information in the Work Item

  @author Robert Graves
  @param WorkItem The item to use to get the patient information from
  @return True if the patient context change was successful, false otherwise
-------------------------------------------------------------------------------}

Function TfrmTRMain.ChangePatientContext(WorkItem: TMagWorkItem): Boolean;
Var
  Data: IContextItemCollection;
  DataItem: IContextItem;
  Response: UserResponse;
Begin
  Result := False;
  If (ContextorControl1.State = csNotRunning) Then
    Exit;
  If (ContextorControl1.State = csSuspended) Then
    ContextorControl1.Resume();

  ContextorControl1.StartContextChange();
  Data := CoContextItemCollection.Create();

  DataItem := CoContextItem.Create();
  DataItem.Set_Name('patient.co.patientname');
  DataItem.Set_Value(WorkItem.PatientName);
  Data.Add(DataItem);

  DataItem := CoContextItem.Create();
  If (IsProdAccount) Then
    DataItem.Set_Name('patient.id.mrn.nationalidnumber')
  Else
    DataItem.Set_Name('patient.id.mrn.nationalidnumber_test');
  DataItem.Set_Value(WorkItem.PatientICN);
  Data.Add(DataItem);

  DataItem := CoContextItem.Create();
  If (IsProdAccount) Then
    DataItem.Set_Name('patient.id.mrn.dfn_' + PrimarySiteStationNumber)
  Else
    DataItem.Set_Name('patient.id.mrn.dfn_' + PrimarySiteStationNumber + '_test');
  DataItem.Set_Value(WorkItem.LocalPatientDFN);
  Data.Add(DataItem);

  // End the context change transaction.
  //MaggMsgf.MagMsg('s','Attempting to switch patient context to [' +  WorkItem.PatientName + ']');
  MagAppMsg('s', 'Attempting to switch patient context to [' + WorkItem.PatientName + ']'); {JK 10/7/2009 - MagMsgu refactoring}
  Response := ContextorControl1.EndContextChange(True, Data);

  If (Response = UrBreak) Then
  Begin
    //MaggMsgf.MagMsg('s','Context change response=break');
    MagAppMsg('s', 'Context change response=break'); {JK 10/7/2009 - MagMsgu refactoring}
    ilCCOWIcons.GetIcon(0, imgCCOWState.Picture.Icon);
  End
  Else
    If (Response = UrCommit) Then
    Begin
    //MaggMsgf.MagMsg('s','Context change response=commit');
      MagAppMsg('s', 'Context change response=commit'); {JK 10/7/2009 - MagMsgu refactoring}
      Result := True;
    End;
End;

{*------------------------------------------------------------------------------
  Event occurs when the user clicks the lock button

  @author Robert Graves
  @param Sender Object which called this function
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.btnLockClick(Sender: Tobject);
Begin
  LockSelectedItem();
  VerifyContextConnected();
End;

{*------------------------------------------------------------------------------
  Attempt to lock the current item in the unread list

  @author Robert Graves
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.LockSelectedItem();
Var
  ActiveReadingList: TListView;
  WorkItem: TMagWorkItem;
  Result: String;
Begin
  ActiveReadingList := GetActiveReadingList();
  If (ActiveReadingList.Selected <> Nil) Then
  Begin
    WorkItem := TMagWorkItem(ActiveReadingList.Selected.Data);
    //MaggMsgf.MagMsg('','Attempting to lock/unlock work item consult #[' + inttostr(WorkItem.AcquisitionSiteConsultNumber) + ']');
    MagAppMsg('', 'Attempting to lock/unlock work item consult #[' + Inttostr(WorkItem.AcquisitionSiteConsultNumber) + ']'); {JK 10/7/2009 - MagMsgu refactoring}
    Cursor := crHourGlass;
    Result := WorkItem.Lock();
    Cursor := crDefault;
    If (MagPiece(Result, '|', 1) = '0') Then // lock succeeded
    Begin
      //MaggMsgf.MagMsg('','Locked/Unlocked work item consult # [' + inttostr(WorkItem.AcquisitionSiteConsultNumber) + ']');
      MagAppMsg('', 'Locked/Unlocked work item consult # [' + Inttostr(WorkItem.AcquisitionSiteConsultNumber) + ']'); {JK 10/7/2009 - MagMsgu refactoring}
      UpdateWorkItem(ActiveReadingList.Selected,
        TMagWorkItem(ActiveReadingList.Selected.Data));
      ReadingListSelectItem(ActiveReadingList,
        ActiveReadingList.Selected,
        ActiveReadingList.Selected <> Nil);
      UpdateLockButton(WorkItem);
      If (WorkItem.Status = 'L') Then // Show only if you locked it
      Begin
        // if user didn't want to view sensitive data, unlock item
        If Not checkPatientSensitiveContinue(WorkItem) Then
        Begin
          LockSelectedItem();
          Exit;
        End;
        If (Not ShowSelectedPatient(False)) Then
          LockSelectedItem(); // Unlock it again
      End;
    End
    Else
    Begin
      //MaggMsgf.MagMsg('','Failed to lock work item [' + inttostr(WorkItem.ID) + ']');
      MagAppMsg('', 'Failed to lock work item [' + Inttostr(WorkItem.ID) + ']'); {JK 10/7/2009 - MagMsgu refactoring}
      Showmessage('Failed to obtain lock: ' + MagPiece(Result, '|', 2))
    End;
  End;
End;

{*------------------------------------------------------------------------------
  Sets the caption for the form (TeleReader)

  @author Robert Graves
  @param InContext If true the patient name is displayed, otherwise false
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.SetFormCaption(InContext: Boolean);
Var
  Text: String;
  WorkItem: TMagWorkItem;
Begin
  Text := 'VistA Imaging TeleReader: (' + Self.LocalBroker.GetServer + ')';
  If (InContext) Then
  Begin
    WorkItem := TMagWorkItem(GetActiveReadingList().Selected.Data);
    Text := Text + ' ' + WorkItem.PatientName;
  End;
  Text := Text + ' in use by ' + MagRemoteBrokerManager1.GetUserFullName();
  caption := Text;
End;

{*------------------------------------------------------------------------------
  Determines if the patient for the work item is in the current CCOW context

  @author Robert Graves
  @param WorkItem The work item with the user information to determine the context
  @return True if the patient is in context, false otherwise
-------------------------------------------------------------------------------}

Function TfrmTRMain.IsInContext(WorkItem: TMagWorkItem): Boolean;
Var
  ItemCollection: IContextItemCollection;
  ContextItem: IContextItem;
Begin
  Result := False;
  If (ContextorControl1.State <> csParticipating) Then
    Exit;

  ItemCollection := ContextorControl1.CurrentContext;
  ContextItem := ItemCollection.Present('patient.id.mrn.nationalidnumber');
  If (ContextItem = Nil) Then
    ContextItem := ItemCollection.Present('patient.id.mrn.nationalidnumber_test');
  If (ContextItem <> Nil) Then
    If (WorkItem.PatientICN = ContextItem.Get_Value()) Then
      Result := True;
End;

{*------------------------------------------------------------------------------
  Event occurs when the user double clicks on an item in the read/unread list.
    The client attempts to lock the work item, if it cannot lock the item then
    it suggests viewing the work item.

  @author Robert Graves
  @param Sender Object which sent this command
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.ReadingListDblClick(Sender: Tobject);
Var
  ActiveList: TListView;
Begin
  ActiveList := TListView(Sender);
  If (UserCanLock(TMagWorkItem(ActiveList.Selected.Data))) Then
    LockSelectedItem()
  Else
  Begin
    If (Application.MessageBox('You can''t obtain a lock for the selected patient.' + #13 + #10 + 'Do you want to view the patient anyway?', 'View patient?', MB_YESNO) = IdYes) Then
      ShowSelectedPatient();
  End;
  VerifyContextConnected();
End;

{*------------------------------------------------------------------------------
  Event occurs when the user clicks on a column in the read/unread list.  The
    items in the list are sorted by the column selected.

  @author Robert Graves
  @param Sender Object which sent this command
  @param Column The column to sort by.
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.ReadingListColumnClick(Sender: Tobject;
  Column: TListColumn);
Var
  ActiveList: TListView;
  NewSortColumn: Integer;
Begin
  ActiveList := TListView(Sender);
  newSortColumn := Column.Index - 1;
  If (NewSortColumn <> SortColumn) Then
    SortAscending := True
  Else
    SortAscending := Not SortAscending;
  SortColumn := NewSortColumn;
  ActiveList.AlphaSort();
End;

{*------------------------------------------------------------------------------
  Compares two items of the same list to determine which comes first.

  @author Robert Graves
  @param Sender Object which sent this command
  @param Item1 The first item.
  @param Item2 The second item.
  @param Data
  @param Compare
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.ReadingListCompare(Sender: Tobject; Item1,
  Item2: TListItem; Data: Integer; Var Compare: Integer);
Begin
  If ((Item1.Data = Nil) Or (Item2.Data = Nil)) Then
    Exit;
  Case SortColumn Of
    -1:
      Compare := CompareText(Item1.caption, Item2.caption);
    0..3, 6: //, 8..9:
      Compare := CompareText(Item1.SubItems.Strings[SortColumn],
        Item2.SubItems.Strings[SortColumn]);
    4:
      Compare := CompareValue(TMagWorkItem(Item1.Data).AcquisitionSiteConsultNumber,
        TMagWorkItem(Item2.Data).AcquisitionSiteConsultNumber);
    5:
      Compare := CompareValue(TMagWorkItem(Item1.Data).IFCConsultNumber,
        TMagWorkItem(Item2.Data).IFCConsultNumber);
    7:
      Compare := CompareText(TMagWorkItem(Item1.Data).MLastImageAcquiredTime,
        TMagWorkItem(Item2.Data).MLastImageAcquiredTime);
    8:
      Compare := CompareValue(TMagWorkItem(Item1.Data).NumberOfImages,
        TMagWorkItem(Item2.Data).NumberOfImages);
    9:
      Compare := CompareText(TMagWorkItem(Item1.Data).MEndReadingTime,
        TMagWorkItem(Item2.Data).MEndReadingTime)
    {
    0..5, 8..9:
      Compare := CompareText(Item1.SubItems.Strings[SortColumn],
                       Item2.SubItems.Strings[SortColumn]);
    6:
      Compare := CompareText(TMagWorkItem(Item1.Data).MImageAcquisitionStartTime,
                       TMagWorkItem(Item2.Data).MImageAcquisitionStartTime);
    7:
      Compare := CompareText(TMagWorkItem(Item1.Data).MLastImageAcquiredTime,
                       TMagWorkItem(Item2.Data).MLastImageAcquiredTime);
    10:
      Compare := CompareText(TMagWorkItem(Item1.Data).MEndReadingTime,
                       TMagWorkItem(Item2.Data).MEndReadingTime)
                       }
  End;

  If (Not SortAscending) Then
    Compare := Compare * -1;
End;

{*------------------------------------------------------------------------------
  Event occurs when the user clicks on the Specialties menu item.  Displays the
    specialties dialog.

  @author Robert Graves, Julian Werfel
  @param Sender Object which sent this command
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.Specialties1Click(Sender: Tobject);
Begin
  // GetSiteSpecialties passes the specialties to the options dialog, that
  // dialog merges the data to ensure old preferences are stored along with new
  // values

  // disable the timer so the worklist doesn't keep updating while displaying
  // the Specialties dialog.
  Timer1.Enabled := False;
  GetSitesSpecialties();
  ViewTeleReaderOptions();
  lvUnreadList.Clear;
  lvReadList.Clear;
  FirstReadListLoad := True;
  UpdateReadingLists();
  Timer1.Enabled := True;
End;

{*------------------------------------------------------------------------------
  Event occurs when the a CCOW context change request is canceled.

  @author Robert Graves, Julian Werfel
  @param Sender Object which sent this command
  @param Column The column to sort by.
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.ContextorCanceled(Sender: Tobject);
Begin
  ilCCOWIcons.GetIcon(2, imgCCOWState.Picture.Icon);
End;

{*------------------------------------------------------------------------------
  Event occurs when the a CCOW context change request is committed.

  @author Robert Graves, Julian Werfel
  @param Sender Object which sent this command
  @param Column The column to sort by.
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.ContextOrCommitted(Sender: Tobject);
Var
  ReadingList: TListView;
Begin
  ilCCOWIcons.GetIcon(2, imgCCOWState.Picture.Icon);
  ReadingList := GetActiveReadingList();
  If (ReadingList.Selected <> Nil) Then
    ReadingList.Selected.Selected := False;
End;

{*------------------------------------------------------------------------------
  Event occurs when the a CCOW context change request is pending.

  @author Robert Graves, Julian Werfel
  @param Sender Object which sent this command
  @param Column The column to sort by.
  @param aContextItemCollection
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.ContextOrPending(Sender: Tobject;
  Const aContextItemCollection: IDispatch);
Begin
  ilCCOWIcons.GetIcon(1, imgCCOWState.Picture.Icon);
End;

{*------------------------------------------------------------------------------
  Event occurs when the the user double clicks on the CCOW state image.
    If TeleReader's CCOW state is suspended, it attempts to resume context.

  @author Robert Graves
  @param Sender Object which sent this command
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.imgCCOWStateDblClick(Sender: Tobject);
Begin
  If (ContextorControl1.State = csSuspended) Then
  Begin
    ContextorControl1.Resume();
    ContextOrCommitted(Self);
  End;
End;

{*------------------------------------------------------------------------------
  Event occurs when the the application terminates.  Saves the form position,
    clears the client form context, disconnects the local broker and any remote
    broker connections.

  @author Robert Graves, Julian Werfel
  @param Sender Object which sent this command
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.FormClose(Sender: Tobject;
  Var action: TCloseAction);
Begin
  If Not ApplicationTimedOut Then
  Begin
    If Not checkLockedWorkItems() Then
    Begin
      // user press cancel, doesn't want to close app
      action := caNone;
      Exit;
    End;
  End;
  // if user wants to save settings on exit, save the settings
  If SaveSettingsOnExit1.Checked Then saveUserPreferences();

  SaveFormPosition(Self As TForm);
  ContextorControl1.Free();
  If (Not (LocalBroker = Nil)) And (LocalBroker.IsConnected) Then
    LocalBroker.GetBroker().Connected := False;
  If Not (MagRemoteBrokerManager1 = Nil) Then
    MagRemoteBrokerManager1.LogoffRemoteBrokers();
End;

{*------------------------------------------------------------------------------
  Verifies TeleReader is still in context, if TeleReader has broker context for
    any reason, notify user and rejoin context.  TeleReader is not functional
    without being part of context.

  @author Robert Graves
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.VerifyContextConnected();
Var
  ReadingList: TListView;
Begin
  If (ContextorControl1.State <> csParticipating) Then
  Begin
    Showmessage('CCOW Link Broken.  Click OK to rejoin context and continue reading.');
    ContextorControl1.Resume();
    ilCCOWIcons.GetIcon(2, imgCCOWState.Picture.Icon);
    ReadingList := GetActiveReadingList();
    If (ReadingList.Selected <> Nil) Then
      ReadingList.Selected.Selected := False;
  End;
End;

{*------------------------------------------------------------------------------
  Uses information from the list item to determine how the list item should be
    drawn.  Gray indicates the user cannot lock the item.  Bold indicates the
    item can be locked by the user.  Blue indicates the item is locked by the
    user.  Red indicates the urgency of the work item is STAT.

  @author Robert Graves
  @param Sender Object which sent this command
  @param Item List Item being created
  @param State The State of the item
  @param DefaultDraw
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.ReadingListCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  Var DefaultDraw: Boolean);
Var
  WorkItem: TMagWorkItem;
Begin
  // put item in gray if reading site cannot read item or another person is
  // already reading item
  // put item in blue if current user is reading
  // put item in red if not currently being read an is urgency STAT

  WorkItem := TMagWorkItem(Item.Data);
  If (Not UserCanLock(WorkItem)) Then
  Begin
    Sender.Canvas.Font.Style := [];
    Sender.Canvas.Font.Color := clGray;
    Exit;
  End;
  Sender.Canvas.Font.Style := [Fsbold];
  {TODO: Might need to reorder this logic, if STAT always want red?
    Maybe not since blue means user is currently reading the study, not needed
    to be red for emphasis}

  // not needed to check sites here since already done above, if UserCanLock
  //  fails, then exit (above)
  If (WorkItem.ReaderDUZ = MagRemoteBrokerManager1.GetUserLocalDUZ) Then
  Begin
    Sender.Canvas.Font.Color := clBlue;
    Exit;
  End;
  If (WorkItem.Urgency = 'STAT') Then
    Sender.Canvas.Font.Color := clRed
  Else
    Sender.Canvas.Font.Color := clBlack;
End;

{*------------------------------------------------------------------------------
  Event occurs when the user clicks on the message history button.

  @author Julian Werfel
  @param Sender The object which sent this event
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.btnMsgHistoryClick(Sender: Tobject);
Begin
  //if MaggMsgf.Visible then MaggMsgf.Hide()
  //else MaggMsgf.Show();
  {JK 10/7/2009 - MagMsgu refactoring}
  MagAppMsgShow;
End;

{*------------------------------------------------------------------------------
  Event occurs when the user clicks on the Login menu item.  The TeleReader will
    attempt to login to the local VistA server

  @author Julian Werfel
  @param Sender The object which sent this event
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.Login1Click(Sender: Tobject);
Begin
  If idmodobj.GetMagDBBroker1.IsConnected Then
  Begin
    //Logout1Click(self);
    If Not Logout() Then Exit;
  End;
  //MaggMsgf.MagMsg('s','Logging into local VistA');
  MagAppMsg('s', 'Logging into local VistA'); {JK 10/7/2009 - MagMsgu refactoring}
  IsFirstTick := True;
  Timer1.Interval := 100;
  Timer1.Enabled := True;
  AllowRemoteLogin := False;
End;

{*------------------------------------------------------------------------------
  Event occurs when the user clicks on the Remote Login menu item.  The
    TeleReader will attempt to login remotely to VistA

  @author Julian Werfel
  @param Sender The object which sent this event
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.RemoteLogin1Click(Sender: Tobject);
Begin

  If idmodobj.GetMagDBBroker1.IsConnected Then
  Begin
    If Not Logout() Then Exit;
  End;
  //MaggMsgf.MagMsg('s','Logging into remote VistA');
  MagAppMsg('s', 'Logging into remote VistA'); {JK 10/7/2009 - MagMsgu refactoring}
  IsFirstTick := True;
  Timer1.Interval := 100;
  Timer1.Enabled := True;
  AllowRemoteLogin := True;
End;

{*------------------------------------------------------------------------------
  Logs the user out from VistA. Checks to see if they should unlock items,
    disconnects from VistA and resets the state of the TeleReader.

  @author Julian Werfel
  @return True if the use wants to continue to logout, false if the user
    cancelled the logout process
-------------------------------------------------------------------------------}

Function TfrmTRMain.Logout(): Boolean;
Begin
  Result := False;
  If Not checkLockedWorkItems() Then Exit;
  Result := True;
  If SaveSettingsOnExit1.Checked Then saveUserPreferences();
  //MaggMsgf.MagMsg('s','Logging out from VistA');
  MagAppMsg('s', 'Logging out from VistA'); {JK 10/7/2009 - MagMsgu refactoring}
  PnlSiteCode.caption := '';
  Timer1.Enabled := False;
  Timer1.Interval := 100;
  If (Not (LocalBroker = Nil)) And (LocalBroker.IsConnected) Then
    LocalBroker.GetBroker().Connected := False;
  If Not (MagRemoteBrokerManager1 = Nil) Then
    MagRemoteBrokerManager1.LogoffRemoteBrokers();
  setMenus();
  DisplayMessage('No Connection to VistA', '');
  lvUnreadList.Clear();
  lvReadList.Clear();
  frmMagTeleReaderOptions.ClearSpecialties();
  WorkStationTimeout := 0;
  If SecurityKeys <> Nil Then SecurityKeys.Clear();
  Self.caption := 'VistA Imaging TeleReader';
End;

{*------------------------------------------------------------------------------
  Event occurs when the user clicks on the Logout menu item.  The TeleReader
    will logout from VistA if connected.

  @author Julian Werfel
  @param Sender The object which sent this event
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.Logout1Click(Sender: Tobject);
Begin
  Logout();
End;

{*------------------------------------------------------------------------------
  Event occurs when the user clicks on the About menu item.  The TeleReader will
    display the About dialog containing information about the TeleReader

  @author Julian Werfel
  @param Sender The object which sent this event
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.About1Click(Sender: Tobject);
Var
  Rstat: Boolean;
  Rlist: Tstringlist;
Begin
  Rlist := Tstringlist.Create;
  Try
    idmodobj.GetMagDBBroker1.RPMaggInstall(Rstat, Rlist);
    FrmAbout.Execute('', '', Rlist);
  Finally
    Rlist.Free;
  End;
End;

{*------------------------------------------------------------------------------
  Displays the Msg in the messsage panel and logs the message in the message
    history.

  @author Julian Werfel
  @param Msg Message to display and log
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.DisplayMessage(Msg: String; MsgType: String = '');
Begin
  Pnlmsg.caption := Msg;
  Pnlmsg.Update();
  //MaggMsgf.MagMsg(MsgType, Msg);
  MagAppMsg(MsgType, Msg); {JK 10/7/2009 - MagMsgu refactoring}
  // log message to file?
End;

{*------------------------------------------------------------------------------
  Event occurs when the user clicks on the View All studies menu item.  The
    TeleReader will enable/disable the viewing of all work items based on this
    option.  It will also refresh the worklist items.

  @author Julian Werfel
  @param Sender The object which sent this event
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.ViewAllStudies1Click(Sender: Tobject);
Begin
  ViewAllStudies1.Checked := Not ViewAllStudies1.Checked;
  lvUnreadList.Clear();
  lvReadList.Clear();
  FirstReadListLoad := True;
  frmMagTeleReaderOptions.ClearLastUpdated();
  Timer1Timer(Self);
End;

{*------------------------------------------------------------------------------
  Event occurs when the timeout timer event occurs.

  @author Julian Werfel
  @param Sender The object which sent this event
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.TimerTimeoutTimer(Sender: Tobject);
Begin
  ApplicationTimedOut := False;
  If MagTimeoutform.Visible Then Exit;
  MagTimeoutform.Setapplication(MagappTeleReader);
  MagTimeoutform.Showmodal;
  If MagTimeoutform.ModalResult = MrOK Then
  Begin
    ApplicationTimedOut := True;
    Close();
    Application.Terminate();
  End;
End;

{*------------------------------------------------------------------------------
  Event occurs when the user clicks on the Show Specialties Dialog at Startup
    menu item.  If this option is unchecked, the Specialties dialog will not
    appear when the user logs in unless they have 0 procedures selected.

  @author Julian Werfel
  @param Sender The object which sent this event
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.ShowSpecialtiesDialogatStartup1Click(
  Sender: Tobject);
Begin
  ShowSpecialtiesDialogatStartup1.Checked := Not ShowSpecialtiesDialogatStartup1.Checked;
End;

Procedure TfrmTRMain.lblPatientMouseDown(Sender: Tobject;
  Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Begin
  If (Ssctrl In Shift) And (SsShift In Shift) Then
  Begin
    If Uppercase(InputBox('', '', '')) <> 'TESTING' Then Exit;
    ReadListDays1.caption := 'Read List Days - ' + Inttostr(ReadDays);
    mnuTest.Visible := Not mnuTest.Visible;
  End;
End;

{ Used for test purposes}

Procedure TfrmTRMain.ReadListDays1Click(Sender: Tobject);
Var
  Days: String;
  rDays: Integer;
Begin
  Days := InputBox('Read List Days', '# of days to show on the unread list', Inttostr(ReadDays));
  If Days = '' Then Exit;
  Try
    rDays := Strtoint(Days);
    If rDays < 0 Then Exit;
    ReadDays := rDays; // strtoint(days);
    ReadListDays1.caption := 'Read List Days - ' + Inttostr(ReadDays);
  Except
    On e: Exception Do
    Begin
      //MaggMsgf.MagMsg('s', 'Invalid value for read list days [' + days + '], retaining previous value [' + inttostr(ReadDays) + ']');
      MagAppMsg('s', 'Invalid value for read list days [' + Days + '], retaining previous value [' + Inttostr(ReadDays) + ']'); {JK 10/7/2009 - MagMsgu refactoring}
    End;
  End;
End;

{*------------------------------------------------------------------------------
  Event occurs when the user clicks on the Auto Launch Display\CPRS menu item.
    The TeleReader will automatically launch CPRS and Display when this option
    is checked.

  @author Julian Werfel
  @param Sender The object which sent this event
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.AutoLaunchDisplayCPRS1Click(Sender: Tobject);
Begin
  AutoLaunchDisplayCPRS1.Checked := Not AutoLaunchDisplayCPRS1.Checked;
End;

{*------------------------------------------------------------------------------
  Initializes the user preferences and loads the user preferences from VistA.
    Then applies the preferences to the TeleReader

  @author Julian Werfel
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.getApplyUserPreferences();
Var
  t: Tstringlist;
  Rpcstat: Boolean;
  Rpcmsg: String;
  i: Integer;
Begin
  DisplayMessage('Loading user preferences...', '');
  // initialize user preference values
  Upref.TRAutoLaunchCPRSImaging := True;
  Upref.TRViewAllStudies := True;
  Upref.TRShowSpecialtiesAtStartup := True;
  Upref.TRSaveSettingsOnExit := False;
  Upref.TRgetTeleReader := False;
  Upref.TRWinStyle := 2;
  Upref.TRUnreadColumnWidths := '';
  Upref.TRReadColumnWidths := '';
  Upref.TRPos.Left := 0;
  Upref.TRPos.Top := 0;
  Upref.TRPos.Right := 731;
  Upref.TRPos.Bottom := 541;

  // load user preferences from VistA
  t := Tstringlist.Create();
  LocalBroker.RPMagGetUserPreferences(Rpcstat, Rpcmsg, t, 'TELEREADER_1');
  If Not Rpcstat Then
  Begin
    //MaggMsgf.MagMsg('s','Error retrieving user preferences from VistA: ' + rpcmsg);
    MagAppMsg('s', 'Error retrieving user preferences from VistA: ' + Rpcmsg); {JK 10/7/2009 - MagMsgu refactoring}
    Exit;
  End;
  // read preferences from VistA
  For i := 0 To t.Count - 1 Do
  Begin
    Try
      If MagPiece(t[i], '^', 1) = 'TELEREADER_1' Then
      Begin
        If Maglength(t[i], '^') > 2 Then
        Begin
          Upref.TRWinStyle := Strtoint(MagPiece(t[i], '^', 2));
          Upref.TRPos.Left := Strtoint(MagPiece(t[i], '^', 3));
          Upref.TRPos.Top := Strtoint(MagPiece(t[i], '^', 4));
          Upref.TRPos.Right := Strtoint(MagPiece(t[i], '^', 5));
          Upref.TRPos.Bottom := Strtoint(MagPiece(t[i], '^', 6));

          Upref.TRUnreadColumnWidths := MagPiece(t[i], '^', 8);
          Upref.TRAutoLaunchCPRSImaging := Magstrtobool(MagPiece(t[i], '^', 9));
          Upref.TRViewAllStudies := Magstrtobool(MagPiece(t[i], '^', 10));
          Upref.TRShowSpecialtiesAtStartup := Magstrtobool(MagPiece(t[i], '^', 11));
          Upref.TRSaveSettingsOnExit := Magstrtobool(MagPiece(t[i], '^', 12));
          Upref.TRReadColumnWidths := MagPiece(t[i], '^', 13);
        End;
      End;
    Except
      On e: Exception Do
      Begin
        //MaggMsgf.MagMsg('s','Error applying user preferences: ' + e.Message);
        MagAppMsg('s', 'Error applying user preferences: ' + e.Message); {JK 10/7/2009 - MagMsgu refactoring}
      End;
    End;
  End;

  // apply user preferences:
  SaveSettingsOnExit1.Checked := Upref.TRSaveSettingsOnExit;
  ShowSpecialtiesDialogatStartup1.Checked := Upref.TRShowSpecialtiesAtStartup;
  AutoLaunchDisplayCPRS1.Checked := Upref.TRAutoLaunchCPRSImaging;
  ViewAllStudies1.Checked := Upref.TRViewAllStudies;

  Try
    // set form position
    Magsetbounds(Self, Upref.TRPos);
    // set column widths
    If Upref.TRUnreadColumnWidths <> '' Then
    Begin
      For i := 2 To Maglength(Upref.TRUnreadColumnWidths, ',') Do
      Begin
        If (lvUnreadList.Columns.Count > (i - 2)) Then lvUnreadList.Column[i - 2].Width := Strtoint(MagPiece(Upref.TRUnreadColumnWidths, ',', i));
      End;
    End;
    If Upref.TRReadColumnWidths <> '' Then
    Begin
      For i := 2 To Maglength(Upref.TRReadColumnWidths, ',') Do
      Begin
        If (lvreadList.Columns.Count > (i - 2)) Then lvreadList.Column[i - 2].Width := Strtoint(MagPiece(Upref.TRReadColumnWidths, ',', i));
      End;
    End;
  Except
    On e: Exception Do
    Begin
        //maggmsgf.MagMsg('s','Error applying user preferences to form or columns, Error=[' + e.Message + ']');
      MagAppMsg('s', 'Error applying user preferences to form or columns, Error=[' + e.Message + ']'); {JK 10/7/2009 - MagMsgu refactoring}
    End;
  End;
End;

{*------------------------------------------------------------------------------
  Saves user preferences to VistA for the current user.

  @author Julian Werfel
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.saveUserPreferences();
Var
  Preflist: TStrings;
  Rpcstat: Boolean;
  Rpcmsg: String;
  i: Integer;
  listColumns: String;
Begin
  // update the user preference object with current preferences
  Upref.TRWinStyle := 2;
  Upref.TRPos.Left := Self.Left;
  Upref.TRPos.Top := Self.Top;
  Upref.TRPos.Right := Self.Width;
  Upref.TRPos.Bottom := Self.Height;
  listColumns := '';
  For i := 0 To lvUnreadList.Columns.Count - 1 Do
  Begin
    listColumns := listColumns + ',' + Inttostr(lvUnreadList.Column[i].Width);
  End;
  Upref.TRUnreadColumnWidths := listColumns;
  listColumns := '';
  For i := 0 To lvReadList.Columns.Count - 1 Do
  Begin
    listColumns := listColumns + ',' + Inttostr(lvReadList.Column[i].Width);
  End;
  Upref.TRReadColumnWidths := listColumns;
  Upref.TRAutoLaunchCPRSImaging := AutoLaunchDisplayCPRS1.Checked;
  Upref.TRViewAllStudies := ViewAllStudies1.Checked;
  Upref.TRShowSpecialtiesAtStartup := ShowSpecialtiesDialogatStartup1.Checked;
  Upref.TRSaveSettingsOnExit := SaveSettingsOnExit1.Checked;

  // create the preference list
  Preflist := Tstringlist.Create();
  Preflist.Add('"TELEREADER_1"|' + Inttostr(Upref.TRWinStyle) + '^' + Inttostr(Upref.TRPos.Left) + '^' + Inttostr(Upref.TRPos.Top) + '^' +
    Inttostr(Upref.TRPos.Right) + '^' + Inttostr(Upref.TRPos.Bottom) + '^1^' + Upref.TRUnreadColumnWidths + '^' +
    Magbooltostrint(Upref.TRAutoLaunchCPRSImaging) + '^' + Magbooltostrint(Upref.TRViewAllStudies) + '^' +
    Magbooltostrint(Upref.TRShowSpecialtiesAtStartup) + '^' + Magbooltostrint(Upref.TRSaveSettingsOnExit) + '^' + Upref.TRReadColumnWidths);
  DisplayMessage('Saving user preferences to VistA');
  LocalBroker.RPMagSetUserPreferences(Rpcstat, Rpcmsg, Preflist);
  If Not Rpcstat Then
  Begin
    DisplayMessage('Error saving user preferences to VistA, ' + Rpcmsg);
  End
  Else
  Begin
    DisplayMessage('User preferences saved to VistA');
  End;

End;

{*------------------------------------------------------------------------------
  Event occurs when the user clicks on the Save Settings Now menu item.  The
    TeleReader saves the current user preferences to VistA.

  @author Julian Werfel
  @param Sender The object which sent this event
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.SaveSettingsNow1Click(Sender: Tobject);
Begin
  saveUserPreferences();
End;

{*------------------------------------------------------------------------------
  Event occurs when the user clicks on the Save Settings Now menu item.  When
    checked the TeleReader will save the user preferences to VistA when the
    TeleReader closes or the user logs out from the current database.

  @author Julian Werfel
  @param Sender The object which sent this event
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.SaveSettingsOnExit1Click(Sender: Tobject);
Begin
  SaveSettingsOnExit1.Checked := Not SaveSettingsOnExit1.Checked;
End;

{ Used for test purposes}

Procedure TfrmTRMain.SetWorkstationTimeout1Click(Sender: Tobject);
Var
  Minutes: String;
Begin
  Minutes := InputBox('Workstation Timeout', 'Workstation Timeout in Minutes', Inttostr(WorkStationTimeout));
  If Minutes = '' Then Exit;
  SetWorkstationTimeout(Minutes);
End;

{ Used for test purposes}

Procedure TfrmTRMain.SetCPRSLocation1Click(Sender: Tobject);
Var
  Location: String;
Begin
  Location := InputBox('CPRS Directory', 'Set CPRS Installed Location', CPRSLocation);
  If Location = '' Then Exit;
  CPRSLocation := Location;
End;

{ Used for test purposes}

Procedure TfrmTRMain.DisplayPrimaryDivisonHashmap1Click(
  Sender: Tobject);
Var
  mapDetails: String;
Begin
  mapDetails := PrimaryDivisionMap.DisplayMap();
  //MaggMsgf.MagMsg('s', 'Hashmap Details: ' + mapDetails);
  MagAppMsg('s', 'Hashmap Details: ' + mapDetails); {JK 10/7/2009 - MagMsgu refactoring}
  //if not(maggmsgf.Visible) then maggmsgf.Visible := true;
  //maggmsgf.sysmemo.SelStart := length(maggmsgf.sysmemo.Text);
  //maggmsgf.sysmemo.SelLength := 0;
  {JK 10/7/2009 - MagMsgu refactoring}
  MagAppMsgShow;
End;

{*------------------------------------------------------------------------------
  Determines if the patient is sensitive, if so checks to see if the user wants
    wants to view the patient data.  If so, it is logged.  If the patient is not
    sensitive, function returns true

  @author Julian Werfel
  @param WorkItem The work item containing the patient to check sensitivity
  @result True if the patient should be displayed, false otherwise.
-------------------------------------------------------------------------------}

Function TfrmTRMain.checkPatientSensitiveContinue(WorkItem: TMagWorkItem): Boolean;
Var
  Msg: String;
  SensitiveCode: Integer;
  sensitiveMsg: Tstringlist;
  Notused: Boolean;
Begin
  Result := True;
  If WorkItem = Nil Then Exit;
  //msg := LocalBroker.
  If WorkItem.LocalPatientDFN = '' Then
  Begin
    If Not LocalBroker.RPMagGetPatientDFNFromICN(Msg, workItem.PatientICN) Then
    Begin
      Showmessage('Error retrieving local patient DFN to check patient sensitivity at local site' + #13 + Msg);
      Exit;
    End;
    WorkItem.LocalPatientDFN := Msg;
  End;
  sensitiveMsg := Tstringlist.Create();
  localBroker.RPDGSensitiveRecordAccess(WorkItem.LocalPatientDFN, SensitiveCode, sensitiveMsg);
  Case SensitiveCode Of
    -1:
      Begin
      //MaggMsgf.MagMsg('s', 'Error checking sensitive patient at local site, Error=[' + sensitiveMsg.GetText + ']');
        MagAppMsg('s', 'Error checking sensitive patient at local site, Error=[' + sensitiveMsg.GetText + ']'); {JK 10/7/2009 - MagMsgu refactoring}
        Exit;
      End;
    0:
      Begin
      //MaggMsgf.MagMsg('s', 'Access is allowed to patient [' + WorkItem.PatientICN + ']');
        MagAppMsg('s', 'Access is allowed to patient [' + WorkItem.PatientICN + ']'); {JK 10/7/2009 - MagMsgu refactoring}
      End;
    1:
      Begin
        FrmPatAccess.Execute(Self, sensitiveMsg, 1, Notused);
      //MaggMsgf.MagMsg('s', 'Access to restricted patient has been logged');
        MagAppMsg('s', 'Access to restricted patient has been logged'); {JK 10/7/2009 - MagMsgu refactoring}
      End;
    2:
      Begin
        If FrmPatAccess.Execute(Self, sensitiveMsg, 2, Notused) Then
        Begin
        //MaggMsgf.MagMsg('s', 'Access to restricted patient has been logged');
          MagAppMsg('s', 'Access to restricted patient has been logged'); {JK 10/7/2009 - MagMsgu refactoring}
          LocalBroker.RPDGSensitiveRecordBulletin(WorkItem.LocalPatientDFN);
        End
        Else
        Begin
          Result := False;
        //MaggMsgf.MagMsg('s', 'User has Canceled access to the patient.');
          MagAppMsg('s', 'User has Canceled access to the patient.'); {JK 10/7/2009 - MagMsgu refactoring}
          Exit;
        End;
      End;
    3:
      Begin
        Result := False;
        FrmPatAccess.Execute(Self, sensitiveMsg, 3, Notused);
      //MaggMsgf.MagMsg('s', 'Access to this restricted patient is Not Allowed');
        MagAppMsg('s', 'Access to this restricted patient is Not Allowed'); {JK 10/7/2009 - MagMsgu refactoring}
        Exit;
      End;
  End; {case}
End;

{*------------------------------------------------------------------------------
  Opens the help file at the default location

  @author Julian Werfel
  @param Sender Object which sent the request
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.Contents1Click(Sender: Tobject);
Var
  HelpLocation, AppPath: String;
Begin
  AppPath := Copy(ExtractFilePath(Application.ExeName), 1, Length(ExtractFilePath(Application.ExeName)) - 1);
  HelpLocation := AppPath + '\Help\TeleReader\index.htm';
//  Application.HelpContext(1);
  //MaggMsgf.MagMsg('s','Help File Location [' + HelpLocation + ']');
  MagAppMsg('s', 'Help File Location [' + HelpLocation + ']'); {JK 10/7/2009 - MagMsgu refactoring}
  If FileExists(HelpLocation) Then
    ShellExecute(Handle, 'open', PChar(HelpLocation), Nil, Nil, SW_SHOWNORMAL)
  Else
    //MaggMsgf.MagMsg('s','Help file does not exist');
    MagAppMsg('s', 'Help file does not exist'); {JK 10/7/2009 - MagMsgu refactoring}
  //application.HelpCommand(HELP_FINDER, 0);
End;

{*------------------------------------------------------------------------------
  Keyboard shortcut for lock/unlock button

  @author Julian Werfel
  @param Sender Object which sent the request
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.Lock1Click(Sender: Tobject);
Begin
  btnLockClick(Self);
End;

{*------------------------------------------------------------------------------
  Keyboard shortcut for view button

  @author Julian Werfel
  @param Sender Object which sent the request
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.View1Click(Sender: Tobject);
Begin
  btnViewClick(Self);
End;

Function TfrmTRMain.isThinClient(): Boolean;
Var
  SysResources: TDisplayResources;
Begin
  Result := False;
  GetColorDepth(SysResources);
  CheckTerminalServer(SysResources);
  If (SysResources.ThinClient) = 'TC' Then // user is on thin client...
  Begin
    Result := True;
  End;

End;

{*------------------------------------------------------------------------------
  Menu option to change the number of days on the Read List

  @author Julian Werfel
  @param Sender Object which sent the request
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.mnuOptionsReadListDaysClick(Sender: Tobject);
Var
  Days: String;
  rDays: Integer;
  numSelect: TfrmNumberSelect;
Begin
  Try
    numSelect := TfrmNumberSelect.Create(Self);
    rDays := numSelect.Execute('Read List Days', 'Select the number of days to show on the Read List', 0, ReadDaysMax, ReadDays);
    If rDays = ReadDays Then
    Begin
      //MaggMsgf.MagMsg('s','Selected read days is equal to current read days');
      MagAppMsg('s', 'Selected read days is equal to current read days'); {JK 10/7/2009 - MagMsgu refactoring}
      Exit;
    End;
    //MaggMsgf.MagMsg('s','Setting read days value to [' + inttostr(rDays) + ']');
    MagAppMsg('s', 'Setting read days value to [' + Inttostr(rDays) + ']'); {JK 10/7/2009 - MagMsgu refactoring}
    ReadDays := rDays;
    lvUnreadList.Clear();
    lvReadList.Clear();
    FirstReadListLoad := True;
    frmMagTeleReaderOptions.ClearLastUpdated();
    Timer1Timer(Self);
  Finally
    If numSelect <> Nil Then
      numSelect.Free();
  End;
End;

{*------------------------------------------------------------------------------
  Sets the columns of the list to the width of the items in the list

  @author Julian Werfel
  @param List the list to modify
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.fitListViewColumnsToText(List: TListView);
Var
  i: Integer;
  Li: TListItem;
  tWidth: Integer;
Begin
  // be sure the column headers are all visible
  For i := 0 To List.Columns.Count - 1 Do
  Begin
    tWidth := Trunc(List.Canvas.Textwidth(List.Columns[i].caption) * 1.85);
    If List.Columns[i].Width < tWidth Then
    Begin
      List.Columns[i].Width := tWidth;
    End;
  End;
  Li := Nil;
  Li := List.Getnextitem(Li, Sdall, [IsNone]);
  While Li <> Nil Do
  Begin
    tWidth := Trunc(List.Canvas.Textwidth(Li.caption) * 1.85);
    If (List.Column[0].Width < tWidth) Then List.Column[0].Width := tWidth;
    For i := 1 To List.Columns.Count - 1 Do
    Begin
      tWidth := Trunc(List.Canvas.Textwidth(Li.SubItems[i - 1]) * 1.55);
      If (List.Column[i].Width < tWidth) Then List.Column[i].Width := tWidth;
    End;
    Li := List.Getnextitem(Li, Sdall, [IsNone]);
  End;
  List.Update();
End;

{*------------------------------------------------------------------------------
  Sets the column width of the read and unread lists to the width the list

  @author Julian Werfel
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.FitColumnsToText();
Begin
  fitListViewColumnsToText(lvUnreadList);
  fitListViewColumnsToText(lvReadList);
End;

{*------------------------------------------------------------------------------
  Sets the columns of the list to the width of the list

  @author Julian Werfel
  @param List the list to modify
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.fitListViewColumnsToWindow(List: TListView);
Var
  i, Viscolct, colwidth: Integer;
Begin
  Viscolct := 0;
  //get count of visible columns
  For i := 0 To List.Columns.Count - 1 Do
    If (List.Columns[i].Width > 0) Then Viscolct := Viscolct + 1;
  colwidth := (List.Width - 15) Div Viscolct;
  For i := 0 To List.Columns.Count - 1 Do
  Begin
      //if FColVisible[i] then listview1.columns[i].width := colwidth;
    List.Columns[i].Width := colwidth;
  End;
  List.Update();
End;

{*------------------------------------------------------------------------------
  Sets the columns of the read and unread lists to the width of the list

  @author Julian Werfel
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.fitColumnsToWindow();
Begin
  fitListViewColumnsToWindow(lvUnreadList);
  fitListViewColumnsToWindow(lvReadList);
End;

{*------------------------------------------------------------------------------
  Menu event to set the column width to the size of the text

  @author Julian Werfel
  @param Sender Object which sent the request
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.mnuOptionsFitColumnsToTextClick(Sender: Tobject);
Begin
  FitColumnsToText();
End;

{*------------------------------------------------------------------------------
  Menu event to set the column width to the list

  @author Julian Werfel
  @param Sender Object which sent the request
-------------------------------------------------------------------------------}

Procedure TfrmTRMain.mnuOptionsFitColumnsToWindowClick(Sender: Tobject);
Begin
  fitColumnsToWindow();
End;

Procedure TfrmTRMain.Columns1Click(Sender: Tobject);
Begin
  If PageControl1.ActivePageIndex = 0 Then
    mnuColumnsCompletedDate.Enabled := False
  Else
    mnuColumnsCompletedDate.Enabled := True;
End;

Procedure TfrmTRMain.SortBycolumn(ColumnIndex: Integer);
Var
  ActiveList: TListView;
  NewSortColumn: Integer;
Begin
  If PageControl1.ActivePageIndex = 0 Then
    ActiveList := lvUnreadList
  Else
    ActiveList := lvReadList;
  newSortColumn := ColumnIndex - 1;
  If (NewSortColumn <> SortColumn) Then
    SortAscending := True
  Else
    SortAscending := Not SortAscending;

  Self.SortColumn := NewSortColumn;
  ActiveList.AlphaSort();

End;

Procedure TfrmTRMain.mnuColumnsStatusClick(Sender: Tobject);
Begin
  SortBycolumn(0);
End;

Procedure TfrmTRMain.mnuColumnsUrgencyClick(Sender: Tobject);
Begin
  SortBycolumn(1);
End;

Procedure TfrmTRMain.mnuColumnsReaderClick(Sender: Tobject);
Begin
  SortBycolumn(2);
End;

Procedure TfrmTRMain.mnuColumnsAcqSiteClick(Sender: Tobject);
Begin
  SortBycolumn(3);
End;

Procedure TfrmTRMain.mnuColumnsReadingSiteClick(Sender: Tobject);
Begin
  SortBycolumn(4);
End;

Procedure TfrmTRMain.mnuColumnsAcqConClick(Sender: Tobject);
Begin
  SortBycolumn(5);
End;

Procedure TfrmTRMain.mnuColumnsIFCClick(Sender: Tobject);
Begin
  SortBycolumn(6);
End;

Procedure TfrmTRMain.mnuColumnsPatientClick(Sender: Tobject);
Begin
  SortBycolumn(7);
End;

Procedure TfrmTRMain.mnuColumnsLastImageClick(Sender: Tobject);
Begin
  SortBycolumn(8);
End;

Procedure TfrmTRMain.mnuColumnsNumImagesClick(Sender: Tobject);
Begin
  SortBycolumn(9);
End;

Procedure TfrmTRMain.mnuColumnsCompletedDateClick(Sender: Tobject);
Begin
  SortBycolumn(10);
End;

Initialization



Finalization



End.
