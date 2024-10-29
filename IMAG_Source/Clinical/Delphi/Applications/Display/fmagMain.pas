Unit FmagMain;
{
 Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created:   1991
Site Name: Silver Spring, OIFO
Developers: Garrett Kirin
[==   unit fmagMain;
Description: Imageing Display Main Form.
      The main form is designed as a starting point, jumping point to
      other windows of the Application.
      It's main funtions are
      - User login, logout
      - Get User preferneces from DataBase
      - Save User preferences to DataBase
      - Patient selection.
      - Patient specific reports

      Menu options and toolbar buttons enable the user to switch the focus
      to other windows in the application.
       - Abstract Window, Group Abstract window, Image list window,
         any Report window that is open, Radiology Exam window, TIU Note window,
         MUSE Ekg window. window selection.

Pre Patch 8 design of the Display application had most of the application functionality
hardcoded into the Main Form (fmagMain.pas was formally named magvnetu.pas)
All other forms (windows) in the Application would call the functions that were
contained here.
Patch 8 is a First Step at a ReDesign of the Display application from Form
centered to object oriented design.  New Classes were created to move methods
and related data out of the Forms and encompass them in related Classes.
From high coupling and low cohesiveness to the oppoisite : low coupling and high cohesiveness
  coupling : is a measure of the dependency of objects on one another.
  cohesiveness : is a measure of the relation of the methods in a class to the
  data that the methods operate on.  i.e. in a Patient Class, if methods of the
  class are accessing data related to a Form or property of a form, the cohiveness
  is low.
Classes created for this purpose include Tmag4Viewer, TMag4VGear, Tmag4Pat,
TmagImageList and others.
Interfaces created to reduce the dependency of one form,object
on another form,object are ImagSubject, and ImagObserver.
//p149+ patch 149  7D Maintenance
 - Version switched to 30.75.149.1     from 30.65.131.21
     75 was used, becaue 130  had 70,  so we just skip 70 . 
 - Printing issue : some PDF's are pixilated when printed.  This is due to change in
   patch 131 that pixilated all PDF's to stop some other Printing Issue.  //p149.
 - EKG issue.  only 19 EKG's were listed.  
 - MUSE directory put in system path.. 

==]
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
// testing compile on Garrett's machine.
//{$DEFINE PROTOTYPE}
//{$DEFINE EUREKA TEST}

(* 149 Application ToDo Items here  or intersperced in code *)
         { TODO 5 -ogarrett -cp149 :
Image Properties available from Display - and In IIA (image Info Advanced)  }
  { TODO 5 -ogarrett -cp149 :
 Image Activity ZMAGGUT3 possible -  available in IIA }

{Bookmarks - in comments.}
{BM-ImagePrint-   BookMark Description:  this is put at all points that are about to print an image.
        Optimal is that all code calls the same print function... not quite there yet.}


Interface

Uses

  AppEvnts,
  Buttons,
  Classes,
    Menus,
  Stdctrls,
  SysUtils,

  WinTypes,
  ImgList,
  ToolWin,
  Graphics,
  FileCtrl ,
  ComCtrls,
  Controls,
  Dialogs,
  ExtCtrls,
  Forms,

  //cMagLogManager, {JK 10/5/2009 - Maggmsgu refactoring - deprecated unit}

  cMagMenu,
  cMagObserverLabel,
  cMagPat,
  cMagPatPhoto,
  ImagInterfaces,
  Magremoteinterface,
  UMagClasses, cMagPublishSubscribe
  ;

//Uses Vetted 20090929:Graphics, ToolWin, ImgList

//Uses Vetted 20090929:trpcb, cMagBrokerKeepAlive, cMagUtils, cMagDBDemo, cmagDBBroker, MagRemoteToolbar, filectrl, ToolWin, OleCtrls, ImgList, AxCtrls, FmxUtils, Graphics, WinProcs, fmagPatPhotoOnly, fMagFMSetSelect, fmagPasswordDlg, fmagWebHelpMapping, fmagWebHelp, fmagradviewer, magexewait, umagdefinitions, uMagKeyMgr, magRemoteBroker, magremotebrokerManager, MagImageManager, dmSingle, fmagFullRes, fmagprocedurelistform, fMagAbstracts, fmagVideoPlayer, magresources, magfileversion, umagutils, MagPrevInstance, magpositions, MagSYNCCprsu, magtimeout, fmagDeleteImage, MagAuto, Magguini, fmagUserPref, Maggrpcu, Maggrptu, Maggut1, activex, Inifiles, Messages

Type
    {  Testing.}
  EMyException = Class(Exception);

  TfrmMain = Class(TForm, IMagObserver, IMagRemoteinterface) // , ImagMsg)

    MainMenu1: TMainMenu;
    MnuFile: TMenuItem;
    N2: TMenuItem;
    MnuLogin: TMenuItem;
    MnuLogout: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Options1: TMenuItem;
    MnuViewPrefercences: TMenuItem;
    N3: TMenuItem;
    MnuToolbar: TMenuItem;
    View1: TMenuItem;
    MnuImagelist: TMenuItem;
    Reports1: TMenuItem;
    MnuPatientProfile: TMenuItem;
    MnuHealthSummary: TMenuItem;
    MnuRadiologyExams: TMenuItem;
    MnuHelp: TMenuItem;
    Contents1: TMenuItem;
    MnuAbout: TMenuItem;
    MnuSaveSettingsNow: TMenuItem;
    MnuSaveSettingsonExit: TMenuItem;
    MnuAbstracts: TMenuItem;
    MnuMedicineProcedures: TMenuItem;
    MnuLabExams: TMenuItem;
    MnuSurgicalOperations: TMenuItem;
    N6: TMenuItem;
    MnuClearPatient: TMenuItem;
    N4: TMenuItem;
    N7: TMenuItem;
    MnuShowHints: TMenuItem;
    N5: TMenuItem;
    ImagingDisplayWindow1: TMenuItem;
    MnuMUSEEKGlist: TMenuItem;
    MnuOpenDirectory: TMenuItem;
    MnuDemoImages: TMenuItem;
    N8: TMenuItem;
    MnuLocalMuse: TMenuItem;
    N9: TMenuItem;
    MSystemManager: TMenuItem;
    MSecurityON: TMenuItem;
    MessageSend1: TMenuItem;
    MagSecMsg: TMenuItem;
    MnuPreFetch: TMenuItem;
    MFormNames: TMenuItem;
    MnuFakeName: TMenuItem;
    KernelBrokerDEBUGMode1: TMenuItem;
    MWrksCacheOn: TMenuItem;
    MnuMainHint: TMenuItem;
    MnuRemoteLogin: TMenuItem;
    N10: TMenuItem;
    TimerTimeout: TTimer;
    ChangeTimeoutValue1: TMenuItem;
    MnuCPRSLinkOptions: TMenuItem;
    TestEnableDisable1: TMenuItem;
    MnuTurnHintsOFFforallwindows: TMenuItem;
    MnuTurnHintsONforallwindows: TMenuItem;
    N11: TMenuItem;
    MnuProgressNotes: TMenuItem;
    MnuDischargeSummaries: TMenuItem;
    MnuConsults: TMenuItem;
    SetWorkstationAlternaterVideoViewer1: TMenuItem;
    MMagINI: TMenuItem;
    ImglstMainToolbar: TImageList;
    Showhiddenmenuoptions1: TMenuItem;
    MnuRefreshPatientImages: TMenuItem;
    N14: TMenuItem;
    MnuSelectPatient: TMenuItem;
    MTest1: TMenuItem;
    MnuGroupWindow: TMenuItem;
    ErrorCodelookup1: TMenuItem;
    MImageDeleteHelp: TMenuItem;
    MSysManhelp: TMenuItem;
    Legal1: TMenuItem;
    MnuClinicalProcedures: TMenuItem;
    OpenAdobe1: TMenuItem;
    MnuScreenSettings1: TMenuItem;
    ExplorePatientProcedures1: TMenuItem;
    MnuImagelistFilters: TMenuItem;
    PMain: Tpanel;
    Panel2: Tpanel;
    Panel4: Tpanel;

    PToolbar: Tpanel;
    PMainToolbar: Tpanel;
    PPatInfo: Tpanel;
    PPatinfo2: Tpanel;
    PnlPatPhoto: Tpanel;
    MagPatPhoto1: TMagPatPhoto;
    LbImagecount: Tlabel;
    MnuSecurityKeyAddDelete: TMenuItem;
    MnuKeyMagdispclin: TMenuItem;
    GetCTPresets1: TMenuItem;
    SaveCTPresets1: TMenuItem;
    MnuDraggingSizing: TMenuItem;
    MnuEnableDemo: TMenuItem;
    MnuGroupBrowsePlay: TMenuItem;
    MnuFullRes: TMenuItem;
    ToolBar1: TToolBar;
    TbtnImageListWin: TToolButton;
    TbtnListFilterWin: TToolButton;
    TbtnAbstracts: TToolButton;
    TbtnDHCPRpt: TToolButton;
    TbtnEkg: TToolButton;
    TbtnUserPref: TToolButton;
    TbtnPatient: TToolButton;
    OpenImagebyID1: TMenuItem;
    MnuPrototypes: TMenuItem;
    N12: TMenuItem;
    Mag4Menu1: TMag4Menu;
    MnuSetDOSDir: TMenuItem;
    ChDir1: TMenuItem;
    Pnlbase: Tpanel;
    Pmsg: Tpanel;
    PnlMsgHistorybtn: Tpanel;
    btnMsgHistory: TBitBtn;
    PnlSiteCode: Tpanel;
    ICN1: TMenuItem;
    RemoteBrokerDetails1: TMenuItem;
    ManuallyConnecttoRemoteSite1: TMenuItem;
    TbtnRIVConfigure: TToolButton;

    VerifyImages1: TMenuItem;
    WebHelp1: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    UseOldHelp1: TMenuItem;
    ImglstMainMenu: TImageList;
    MnuRIV: TMenuItem;
    ListAppOpenForms1: TMenuItem;
    ImglstImageFunctions: TImageList;
    Windows1: TMenuItem;
    MnuIconShortCutKeyLegend: TMenuItem;
    MnuUseInternetExplorerforhelp: TMenuItem;
    MnuMessageLog: TMenuItem;
    MnukeyMagSystem: TMenuItem;
    PPatient: Tpanel;
    LbPatient: Tlabel;
    MagObserverLabel1: TMagObserverLabel;
    ImgCCOWLink: TImage;
    ImgCCOWchanging: TImage;
    ImgCCOWbroken: TImage;
    EdtPatient: TEdit;
    MnuContext: TMenuItem;
    MnuShowContext: TMenuItem;
    N13: TMenuItem;
    MnuSuspendContext: TMenuItem;
    MnuResumeGetContext: TMenuItem;
    MnuResumeSetContext: TMenuItem;
    DemoRemoteSites1: TMenuItem;
    MnuTestSimulateMessageFromCPRS1: TMenuItem;
    TimerStickToCPRS: TTimer;
    MnuStickToCPRS: TMenuItem;
    MnuLocal9300: TMenuItem;
    MnuLocal9400: TMenuItem;
    GetReason1: TMenuItem;
    Print1: TMenuItem;
    Copy1: TMenuItem;
    Delete1: TMenuItem;
    Status1: TMenuItem;
    GetFMSetSelections1: TMenuItem;
    ImagePackage1: TMenuItem;
    MnuTESTImageStatus1: TMenuItem;
    StripLeadTrailComma1: TMenuItem;
    UseOldImageListCallMAG4PATGETIMAGES1: TMenuItem;
    DreamWeverWebHelpFiles1: TMenuItem;
    MnuKeyMagdispadmin: TMenuItem;
    MnuKeyMagPatPhotoOnly: TMenuItem;
    MnuSelectKey: TMenuItem;
    MnuTestPatOnlyLookup1: TMenuItem;
    OpenDialog1: TOpenDialog;
    mnuMainUtilities: TMenuItem;
    mnuMainQAReview: TMenuItem;
    Label1: Tlabel;
    ImageStatusNoDeleteNoInProgress1: TMenuItem;
    //mnuHelpWhatsNewinPatch93: TMenuItem;
    mnuTestmagpubUnSelectAll: TMenuItem;
    mnuMainQAReviewReport: TMenuItem;
    SetTimeoutto2seconds1: TMenuItem;
    lstboxCache: TFileListBox;
    dirlstboxCache: TDirectoryListBox;
    MultiImagePrintROITest1: TMenuItem;
    testVersionChecking1: TMenuItem;
    MagSubscriber1: TMagSubscriber;
    mnuTestScript: TMenuItem;          {p149}
    mnuTestScriptDontUseCCOW: TMenuItem;          {p149}
    lbVersion: TLabel;          {p149}
    mnuFullResSpecial: TMenuItem;          {p149}
        //PrintDialog1: TPrintDialog;
    Procedure PatMenuitemSelected(Sender: Tobject);
    Procedure HelpMenuitemSelected(Sender: Tobject); //59
    Procedure ReportItemSelected(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure EdtPatientKeyDown(Sender: Tobject; Var Key: Word; Shift:
      TShiftState);
    Procedure FormPaint(Sender: Tobject);
    Procedure EdtPatientExit(Sender: Tobject);
    Procedure MnuLoginClick(Sender: Tobject);
    Procedure MnuLogoutClick(Sender: Tobject);
    Procedure Exit1Click(Sender: Tobject);
    Procedure MnuToolbarClick(Sender: Tobject);
    Procedure MnuImageListClick(Sender: Tobject);
    Procedure MnuPatientProfileClick(Sender: Tobject);
    Procedure MnuRadiologyExamsClick(Sender: Tobject);
    Procedure MnuViewPrefercencesClick(Sender: Tobject);
    Procedure MnuSaveSettingsOnExitClick(Sender: Tobject);
    Procedure MnuSaveSettingsNowClick(Sender: Tobject);
    Procedure MnuAboutClick(Sender: Tobject);
    Procedure MnuAbstractsClick(Sender: Tobject);

    Procedure MnuClearPatientClick(Sender: Tobject);
    Procedure MnuShowHintsClick(Sender: Tobject);
    Procedure Contents1Click(Sender: Tobject);
    Procedure ImagingDisplayWindow1Click(Sender: Tobject);
    Procedure MnuMUSEEKGlistClick(Sender: Tobject);
    Procedure MnuLocalMuseClick(Sender: Tobject);
    Procedure MSecurityONClick(Sender: Tobject);
    Procedure btnMsgHistoryClick(Sender: Tobject);
    Procedure MessageSend1Click(Sender: Tobject);
    Procedure MagSecMsgClick(Sender: Tobject);
    Procedure MnuPrefetchClick(Sender: Tobject);
    Procedure MFormNamesClick(Sender: Tobject);
    Procedure PmsgMouseMove(Sender: Tobject; Shift: TShiftState; x, y:
      Integer);
    Procedure MnuFakeNameClick(Sender: Tobject);
    Procedure KernelBrokerDEBUGMode1Click(Sender: Tobject);
    Procedure MWrksCacheOnClick(Sender: Tobject);
    Procedure MnuMainHintClick(Sender: Tobject);
    Procedure MnuRemoteLoginClick(Sender: Tobject);
    Procedure TimerTimeoutTimer(Sender: Tobject);
    Procedure ChangeTimeoutValue1Click(Sender: Tobject);
    Procedure MnuCPRSLinkOptionsClick(Sender: Tobject);
    Procedure TestEnableDisable1Click(Sender: Tobject);
    Procedure bPatientClick(Sender: Tobject);
    Procedure MnuTurnHintsOFFforallwindowsClick(Sender: Tobject);
    Procedure MnuTurnHintsONforallwindowsClick(Sender: Tobject);
    Procedure MnuProgressNotesClick(Sender: Tobject);
    Procedure MnuDischargeSummariesClick(Sender: Tobject);
    Procedure MnuConsultsClick(Sender: Tobject);
    Procedure SetWorkstationAlternaterVideoViewer1Click(Sender: Tobject);
    Procedure MMagINIClick(Sender: Tobject);
    Procedure Showhiddenmenuoptions1Click(Sender: Tobject);
    Procedure MnuRefreshPatientImagesClick(Sender: Tobject);
    Procedure MnuSelectPatientClick(Sender: Tobject);
    Procedure MnuHealthSummaryClick(Sender: Tobject);
    Procedure Reports1Click(Sender: Tobject);
    Procedure TbuttonsMouseMove(Sender: Tobject; Shift: TShiftState; x, y:
      Integer);
    Procedure TbpagecontrolsMouseMove(Sender: Tobject; Shift: TShiftState;
      x, y: Integer);
    Procedure TbslidersMouseMove(Sender: Tobject; Shift: TShiftState; x, y:
      Integer);
    Procedure FormResize(Sender: Tobject);
    Procedure View1Click(Sender: Tobject);
    Procedure MnuGroupWindowClick(Sender: Tobject);
    Procedure ErrorCodelookup1Click(Sender: Tobject);
    Procedure bDHCPrptClick(Sender: Tobject);
    Procedure LbPatientMouseDown(Sender: Tobject; Button: TMouseButton;
      Shift: TShiftState; x, y: Integer);
    Procedure MImageDeleteHelpClick(Sender: Tobject);
    Procedure MSysManhelpClick(Sender: Tobject);
    Procedure Legal1Click(Sender: Tobject);
    Procedure MnuClinicalProceduresClick(Sender: Tobject);
    Procedure OpenAdobe1Click(Sender: Tobject);
    Procedure MnuScreenSettings1Click(Sender: Tobject);
    Procedure ExplorePatientProcedures1Click(Sender: Tobject);
    Procedure MnuImagelistFiltersClick(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure MTest1Click(Sender: Tobject);
    Procedure MnuSecurityKeyAddDeleteClick(Sender: Tobject);
    Procedure MnuKeyMagdispclinClick(Sender: Tobject);
    Procedure GetCTPresets1Click(Sender: Tobject);
    Procedure SaveCTPresets1Click(Sender: Tobject);
    Procedure MSystemManagerClick(Sender: Tobject);
    Procedure MnuDemoImagesClick(Sender: Tobject);
    Procedure MnuDraggingSizingClick(Sender: Tobject);
    Procedure MnuEnableDemoClick(Sender: Tobject);
    Procedure MnuGroupBrowsePlayClick(Sender: Tobject);
    Procedure MnuFullResClick(Sender: Tobject);
    Procedure TbtnListFilterWinClick(Sender: Tobject);
    Procedure TbtnAbstractsClick(Sender: Tobject);
    Procedure TbtnDHCPrptClick(Sender: Tobject);
    Procedure TbtnEKGClick(Sender: Tobject);
    Procedure TbtnUserPrefClick(Sender: Tobject);
    Procedure TbtnPatientClick(Sender: Tobject);
    Procedure OpenImagebyID1Click(Sender: Tobject);
    Procedure OpenDialog1CanClose(Sender: Tobject; Var CanClose: Boolean);
    Procedure MnuPrototypesClick(Sender: Tobject);
    Procedure MnuSetDOSDirClick(Sender: Tobject);
    Procedure MnuOpenDirectoryClick(Sender: Tobject);
    Procedure ChDir1Click(Sender: Tobject);
    Procedure ICN1Click(Sender: Tobject);
    Procedure RemoteBrokerDetails1Click(Sender: Tobject);
    Procedure TbtnRIVConfigureClick(Sender: Tobject);
    Procedure ManuallyConnecttoRemoteSite1Click(Sender: Tobject);
        //59
    Procedure EdtPatientDblClick(Sender: Tobject);
    Procedure VerifyImages1Click(Sender: Tobject);
    Procedure WebHelp1Click(Sender: Tobject);
    Function ApplicationEvents1Help(Command: Word; Data: Integer;
      Var CallHelp: Boolean): Boolean;
    Procedure UseOldHelp1Click(Sender: Tobject);
    Procedure MnuRIVClick(Sender: Tobject);
    Procedure ListAppOpenForms1Click(Sender: Tobject);
    Procedure Windows1Click(Sender: Tobject);
    Procedure MnuIconShortCutKeyLegendClick(Sender: Tobject);
    Procedure MnuUseInternetExplorerforhelpClick(Sender: Tobject);
    Procedure MnuMessageLogClick(Sender: Tobject);
    Procedure MnukeyMagSystemClick(Sender: Tobject);
        //59
    Procedure MnuShowContextClick(Sender: Tobject);
    Procedure MnuSuspendContextClick(Sender: Tobject);
    Procedure MnuResumeGetContextClick(Sender: Tobject);
    Procedure MnuResumeSetContextClick(Sender: Tobject);
    Procedure DemoRemoteSites1Click(Sender: Tobject);
        //59
    Procedure MnuTestSimulateMessageFromCPRS1Click(Sender: Tobject);
    Procedure TimerStickToCPRSTimer(Sender: Tobject);
    Procedure MnuStickToCPRSClick(Sender: Tobject);
    Procedure btnTestResClick(Sender: Tobject);
    Procedure MnuLocal9300Click(Sender: Tobject);
    Procedure MnuLocal9400Click(Sender: Tobject);
    Procedure Print1Click(Sender: Tobject);
    Procedure Copy1Click(Sender: Tobject);
    Procedure Delete1Click(Sender: Tobject);
    Procedure Status1Click(Sender: Tobject);
    Procedure ImagePackage1Click(Sender: Tobject);
    Procedure MnuTESTImageStatus1Click(Sender: Tobject);
    Procedure StripLeadTrailComma1Click(Sender: Tobject);
    Procedure UseOldImageListCallMAG4PATGETIMAGES1Click(Sender: Tobject);
    Procedure DreamWeverWebHelpFiles1Click(Sender: Tobject);
    Procedure MnuKeyMagdispadminClick(Sender: Tobject);
    Procedure MnuKeyMagPatPhotoOnlyClick(Sender: Tobject);
    Procedure MnuSelectKeyClick(Sender: Tobject);
    Procedure MnuTestPatOnlyLookup1Click(Sender: Tobject);
    Procedure mnuMainQAReviewClick(Sender: Tobject);
    Procedure ImageStatusNoDeleteNoInProgress1Click(Sender: Tobject);
    Procedure mnuMainUtilitiesClick(Sender: Tobject);
    Procedure mnuTestmagpubUnSelectAllClick(Sender: Tobject);
    Procedure mnuMainQAReviewReportClick(Sender: Tobject);
    Procedure SetTimeoutto2seconds1Click(Sender: Tobject);
    Procedure mnuHelpWhatsNewinPatch93Click(Sender: Tobject);
    Procedure MnuHelpClick(Sender: Tobject);
    Procedure MultiImagePrintROITest1Click(Sender: Tobject);
    Procedure testVersionChecking1Click(Sender: Tobject);
    procedure MagSubscriber1SubscriberUpdate(NewsObj: TMagNewsObject);
    procedure mnuTestScriptDontUseCCOWClick(Sender: TObject);          {p149}
    procedure mnuFullResSpecialClick(Sender: TObject);          {p149}
  Private
    LastWindowsMessage: String;
    LastWindowsMessageHandle: Hwnd;
        {  The current patient information is refereced by this Object}
    FMagpat: TMag4Pat;
        {  Caption changes during session, this is the default }
    FMainCaption: String;

        {   Flag, querried by some winmsg method to determine whether to execute
            functionalily or just exit }
    FClosingImaging: Boolean;
        {   Dynamic Menu objects to list and give user access to all open reports}
    MagReportMenu: TMag4Menu;
        {   Dynamic Menu object to give user access to the last patients that
             were selected this session.}
    MagPatMenu: TMag4Menu;
        {   Dynamic Help menu.  Will create a Menu Option in the 'Help' Menu
            for any file that starts with MagReadMe*.*  or MagWhatsNew*.*
            The 'Mag' and the extension are not displayed on the Menu Item}
    MagHelpMenu: TMag4Menu;
        {  messages are sent to form Maggmsgf.dfm before, this holds those messages
           unitl the form is created, then displays them.
            - convert to messsage object, object will store until message history
               window is created.}
    QueMsgList: Tstringlist;

        {JMW 6/22/2005 p45 Directory to cache images in}
    ImageCacheDirectory: String;

    Procedure CreateDynamicHelpMenu; //59
    Procedure CreateDynamicReportMenu;
    Procedure CreateDynamicPatMenu;
    Procedure UpdateWindowcaption;
    Procedure CprsSyncDefaults;
        //procedure ChangeToPatient(xdfn: string; isicn: boolean = false);
        {   Not implemented.}
    Procedure IdleHandler(Sender: Tobject; Var Done: Boolean);
    Procedure ImagingDisplayLogoff;
    Procedure InitVariables;
    Procedure LoadWSSettings;

        {   application messages go through here.  This keeps time of inactivity
             so the TimeOut function will operate.}
    Procedure AppMessage(Var Msg: TMsg; Var Handled: Boolean);
{/p94t3  moved to umagdisplaymgr for fist level decouple.}
        {   transform date for RadList Win.}
        //        procedure transformdate(var dt: string);
        //procedure WMGetMinMaxInfo(var message: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;
        //procedure WMMOVE(var message: TWMMOVE); message WM_MOVE;
        {   erase all files in Imaging\Cache\   directory. When application terminates.}
    Procedure EraseCacheFiles;
        {   set from INI setting, or from VistA if INI setting is '0'}
    Procedure SetWorkstationTimeout(Minutes: String);
        {   Clears certain forms, controls, of Patient informatin, images and reports}
    Procedure ClearPatientImages(CloseGroup, ClearAbsWin: Boolean);
        {   OnResize Event and called other times.  It stops the Main window from
             becomming to large, or too small.}
    Procedure ResizePMain;
        {   Opens the MagSysKey.hlp file.}
    Procedure OpenSysManHelp;
        {   the 'setter' method of the forms MagPat object. 'setter' methods are
            called when the value of a property is changed}
    Procedure SetMagPat(Const Value: TMag4Pat);
        {   This form, attaches itself as an ImagObserver to the MagPat object.}
    Procedure AttachMyself;
        {   Opens the ImageList Filter window.
            ( this procedure calls ImageListWin method to open the ImageList Filter
              window.  Old vs New this needs changed to get rid of the coupling between
              main and imagelist windows. (if Main goes, not a problem) }
    Procedure ModifyImageListFilter;

    Procedure LoadHelpMenu;
    Procedure AttachtoCPRSTop;
        //procedure LogMsg(MsgType: string; Msg: string; Priority: TMagLogPriority= MagLogINFO); {JK 10/5/2009 - Maggmsgu refactoring - removed old methods}
    Procedure TestStartCloseProcess(Sender: Tobject);
    Procedure LoadDevMenu;
    Procedure Locallogin9300;
    Procedure Locallogin9400;
    Procedure SetRemoteSettings(Settingslist: TStrings);
    Procedure DoPatPhotoOnly;
    Procedure UprefToMainwindow(Var Upref: Tuserpreferences);
    Procedure OpenUprefWindow;
    Procedure EraseFilesInCache;

  Public
        {  Querried to determine if CP (Clinical Procedures) functionality should
            be enabled or not.}

        {   testing, Menu items have Popup windows when mouse moves over them.}
    FopenMenuPopups: Boolean;



    {/p94t2  Procedures to support ImagMsg Interface.   Only frmMain will need Maggmsgu.}
    {show the logger}
(* RCA the message interface procedures are now out of fmagmain.
    Procedure ShowLog;
    {   0 = user ,   1 = admin}
    Procedure SetPrivLevel(Level: Integer);
  // {if UserHasKey('MAG SYSTEM') then
  //  MagLogger.SetPrivLevel(plAdmin)
  //else
  //  MagLogger.SetPrivLevel(plUser);
  //  }
    {Log a single message }
    Procedure LogMsg(Code: String; Msg: String; msgprior: TMagMsgPriority = magmsgINFO);
    {Log a list of messages }
    Procedure LogMsgs(Code: String; Msgs: Tstringlist; msgprior: TMagMsgPriority = magmsgINFO);
    {Log a single message }
    Procedure MagMsg(Code: String; Msg: String);
    {Log a list of messages }
    Procedure MagMsgs(Code: String; Msgs: Tstringlist);
    {//p117 ? internal to Maglogger ? }
    Procedure Log(loglvl : TmagMsgLvl; msg : String); {p117}

    *)

     {/p94t2 gek 11/23/09   decouple main from umagDisplayMgr}
        {       After a User connects to the DataBase the RPC  RPMaggUser2
                is called.  One item of information that is returned, is if
                CP is installed on the VistA Server.
                If Clinical Procedures (CP) is installed on the Server, we
                enable the listing, and Viewing of a patients CP Notes.}
    Procedure mainEnableCPFunctions;
        {       Enables/Disabels Patient lookup options on the Main Window.
                Disabled when Application is opened from CPRS.  Because of the
                way we communicate with CPRS , (we listen they talk) we have
                to Disable the ability to open a patient.}
    Procedure mainEnablePatientLookupLogin(Setting: Boolean);
    Procedure mainEnablePatientButtonsAndMenus(Status: Boolean);
    Procedure mainImageCountDisplay(ClearCount: Boolean = False);
    Procedure mainImageCountUpdate(ctDesc, Fltname, Fltdesc: String); {JK 10/6/2009 - moved over from the deprecated version of MaggMsgu}
    Procedure mainInitializeKeyDependentObjects;

    Procedure HideMainForm;
    Procedure AppMinimize(Sender: Tobject);
    Procedure AppRestore(Sender: Tobject);
        {   Opens the Radiology Exam listing window.}
    Procedure LoadRadListWin;
    Procedure ShowEKGWindow;
        // moved here from Private Patch45 Julian.
        {   if windows message is from CPRS , handle it here}
    Procedure ProcessVistAMessage(XHandle: Hwnd; Vmsg: String);
        {   Change Patients.        }
    Procedure ChangeToPatient(Xdfn: String; IsIcn: Boolean = False);
        {   Do a lookup for the text entered by the user.}
    Procedure PatientSelect(Input: String);
        {   force a repaint of the Main Window.}
    Procedure ForceRepaint;
        {   Default Message Handler. Handles windows messages, decides if they are
            from CPRS }
    Procedure DefaultHandler(Var Message); Override;
        {   method to display a message ( and records in message history )}
    Procedure WinMsg(c, s: String);
        {   Prototype old menu popup windows}
    Procedure CheckPopups;
        {   Prototype Testing}
    Procedure DisplayHint(Sender: Tobject);
        {   This method is a meeting of the Old design with the new.
            Update_ is called when patient changes, Update_ method calls UpdPatGUIData.
            UpdPatGUIData is what is left of the old code that cleared patient images.
            Old code cleared patient info in all opened forms and windows.}
    Procedure UpdPatGUIData;
        {   This method is put on OnCreate method of last form in the creation sequence.
            Delphi support answer to code that depends on forms already being created.}
    Procedure DoOnceAtEnd;
        {   To give a certain form the input focus.}
    Procedure MoveFocusTo(XForm: TForm);
        {   When CPRS sends a Windows message or user Selects a TIU Note in magTIU window}
    Procedure ImagesForCPRSTIUNote(CprsString: String);
        {   Determines if 'FiletoOpen' is on a reachable server}
    Function CanOpenSecureFile(FiletoOpen: String; CloseSecurity,
      Enablewins: Boolean; User: String = ''; Pass: String = ''): Boolean;
        {   }
{/p94t2 gek 11/23/09 refactoring, moved to umagdisplaymgr}
//        function ImageJukeBoxOffLine(IObj: TImageData): Boolean;
    Procedure ShowAbstractWindow(Value: Boolean = True);
        // moved to umagdisplaymgr        procedure ShowimageinfoSys(IObj: TImageData);
         {   Windows message from CPRS.  A Rad exam has been selected.  We get all images for
             the Rad exam selected in CPRS.  (Future: CCOW  will act same way}
    Procedure ImagesForCPRSRadExam(CprsString: String);
        {   Login to DataBase.  Using RPC Broker connection to VistA
            vServer: TRPCBroker property Server
            vPort  : TRPCBroker property listenerport
            Forcethisconnection : TRUE will not display the selection list of VistA servers.
                                : FALSE will querry global variable 'allowremotelogin' to
                                  determine whether or not to show selection list. }
    Procedure ImagingDisplayLogin(Vserver, Vport: String;
      Forcethisconnection: Boolean);
        {   Delete the image referenced by Iobj.}
// moved to MgrImageDelete in umagDisplayMgr
//        procedure ImageDelete(Iobj: TImageData);
        {   Clear all Patient information from open windows
             Old vs New.  This remains from old design of this Main Form managing all
             open forms.  The New design gets away from that, but we are currently
             in the middle of that redesign.}
    Procedure ClearPatImages;
        {   Old-meets-New  Calls RPC to see if patient has Photo's or not.
            if not : hide the Panel that the TMagPatPhoto object is on.
            -- TmagPatPhoto also Calls RPC to get Patient photos.   }
    Procedure Patientphoto;
        {   Saves all current settings from the Display application as the User's
             preferences.}
    Procedure Saveusersettings;
        {   Gets all images for a Rad Exam (clicked in Rad Exam list window) and
            displays the images as abstracts in the Group Abstract window.}
//        procedure RadExamImagesToGroup(Radstring: string);
        {   Get a list of Radiology exams for the Patient RADFN. (Radiology Patient)}
    Function RadlistExams(RADFN: String): Integer;
        { loadlist of radiology exams into radiology list window }
        {TODO -c93+: this needs removed from main. MultiProc listing prototype tree view will do it.}
        {TODO -c93+: coupling RadExam list window to Main window.}
{/p94t3 gek 11-30-09  decouple from fmagamin.}
//        procedure ListToRadListWin;
        { Old design.  Only called from RadListWindow, it calls RadExamImagesToGroup()
           Main and RadExam List window are tightly coupled.     }
    Procedure Radexamselected(s: String);
        {   Called from other windows, (Ctrl-M) Hot Key, to bring focus back to Main form}
    Procedure Focustomain;
        {   implementation of the ImagObserver interface.  When TMag4Pat object changes state
            it calls this Update_ method.  Here we clear all patient images, in all forms that
            are dependent on the Main form to do so.}
    Procedure UpDate_(SubjectState: String; Sender: Tobject);
        {   Application AccessViolations can be handled here.}
    Class Procedure ImagingException(Sender: Tobject; e: Exception);

    Procedure RIVRecieveUpdate_(action: String; Value: String);
        // recieve updates from everyone


  Published
    Property MagPat: TMag4Pat Read FMagpat Write SetMagPat;
  End;

    {  Global variables, available to any Form, object that has TfrmMain in it's
       scope, (in it's 'uses' clause) }
    { In the object oriented world, global variables are not desired.
      more work (you should have seen the list before) needs to be done
      to get these globals out of the Main form and put in appropriate object}

Var
    {  CPRSSyncOptions is TRecord created for the interaction between CPRS and
        imaging.  The record was used in the first Imaging <-> CPRS design.
        In this design the user would get prompted if other CPRS window sent
        a message, or any CPRS window changed Patient.  Most of this functionality
        and properties are not used now but ... Care Management... CCOW... }
  CprsSync: CprsSyncOptions;
    //  used in old linking method with CPRS, and in Capture. not anymore.
  cprsFlag: Boolean;
    {     set to TRUE if CPRS starts imaging.}
  CprsStartedME: Boolean;
    {}
  MUSEconnectFailed: Boolean;
    { set from INI or DataBase  TIMEOUT WINDOWS DISPLAY: IMAGING SITE PARAMTERS Field : TIMEOUT WINDOWS DISPLAY}
  WorkStationTimeout: Longint;
  MUSEenabled: Boolean;
    {  if user want to see selection list when application starts up.}
  AllowRemoteLogin: Boolean;
    //p8t46 xmsg: string;
  QueImage: String;
    // (Stu: 'Sites don't use this Muse demo '
    //Stu: N/A UseMuseDemoDB: boolean;
    { TprocessInformation is a windows structure that we use to execute a program
      and keep a link to it.  We can tell if it is open, or closed, or we
      can close it }
  EKGExeProcessInfo: TprocessInformation;
  RadExeProcessInfo: TprocessInformation;
{    deletedimages: tstringlist;}
  Password: PChar;
  LogFile: Textfile;
  Frmmain: TfrmMain;
  DUZName, Duz: String;
    {  Flag set in OnPaint event, to stop certain code from being called more than once}
  Paramsearched: Boolean;
    {   Old vs New.   tRadList is the patient Radiology Exam list, this is used
       by Main window, and Radexam list window (and others) }
//    tradlist: Tstrings;

  FTestingStatus, FTestingPkg: String;
    { ------------ Global variables, from INI file ----------- }
    { from INI, Logged in IMAGING WINDOWS WORKSTATION File.
        Date/Time when MagSetup.exe (MagInstall.exe) was run. Set by MagInstall.exe}
  LastMagUpdate: String;
    //p8t46   LASTMUSEUPDATE: string;
  IniListenerPort: Integer;
  IniLocalServer: String;
  Loginonstartup, IniLogAction: Boolean;
    //p72    {IniRevOrder } {, IniViewJBox} : bool;
      //IniViewRemoteAbs : boolean;    //DBI // put in uMagDefinitions for scope
      { WrksLocation is a free text of where the computer is located.
         99% of INI files have 'UnKnown' as the value for this}
        {TODO -c93+: dialog window to ask user to complete this text }
  WrksLocation, WrksCompName: String[100];
    {  Used in old,old M routines.  Still sent when user logs on and still logged.}
    {TODO -c5: need to review, and determine if it's use can be stopped.}
  Wsid: String;
    //WrksID: String;
     //startmode : integer;
    {   Still in question, whether we are putting Save As back in...
         allows user to save image to hard drive.}
  AllowSave: Boolean;
    { JMW 8/13/08 P72t26 - hold value from mag308.ini if overriding security key
    to allow access to DOD images}
  AllowDODSites: Boolean;
    {/ P94 JMW 10/21/2009 - hold value from mag308.ini if blocking the client to use the VIX for VA sites /}
  BlockVixVASites: Boolean;
    { ------------ ------------------------------- ----------- }

    //p8t46 StopLoadingAbstracts: Boolean;
    //p8t46 abstractlist : tstringlist;
    //p8t46 AbsFile: string;
    //p8t46 PtList: TStringList;
    //p8t46 Imno: Integer;
    //p8t46 TIMER2TEXT: string;
    //p8t46 MagPtrList: TList;
    { think i was simulating a Partition variable, ... like M world}
    //p8t46 B: Byte;
    //p8t46 Y: Word;
    //p8t46   DemoDirectory: string;
    //p8t46 MuseOnline: Boolean;

     // for consolidation (search for Visn15 to find all changes)
    //   This is the 'code' field in the Site Parameter file.
    //  We will compare this against the new colomn entry in IMage LIsting
    //   And  magrecord's new field PlaceCode. to determine if this is
    //   a local or remote image.
  //  WrksPlaceCode,WrksPlaceIEN,WrksInst : string;      //p48t2 DBI // moved to umagdefinitions.
  (*  The next few lines were all the var's left after implementing the Session.
    object.
  var

   frmMain: TfrmMain;
   tradlist : Tstrings;
     EKGExeProcessInfo: TprocessInformation;
    RadExeProcessInfo: TprocessInformation;
    *)
Implementation

Uses
  ActiveX,
  ImagDMinterface,  //RCA
  DmSingle,
  FEKGDisplay,
  FMagAbout,
  FMagAbstracts,
  FmagDeleteImage,
  FMagFMSetSelect,

  FMagGroupAbs,
  FMagImageList,
  Fmagindexedit,
  FMagLegalNotice,
  FmagPasswordDlg,
  FmagPatPhotoOnly,
  //fmagprocedurelistform,
  FmagRadViewer,
  FmagUserPref,
  fmagVerify,
  FmagVideoPlayer,
  FmagWebHelp,
  FmagWebHelpMapping,
  Inifiles,
  //RCA     Magauto,
  MagExeWait,
  Magfileversion,
//RCA OUT    Maggmsgu,
cMagDisplayMsg, 
  Maggrpcu,
  Maggrptu,
  Magguini,
  Maggut1,
  Maggut9,
  MagImageManager,
  Magpositions,
  MagPrevInstance,
  Magradlistwinu,
//RCA OUT  MagRemoteBroker,
  MagRemoteBrokerManager,
  MagResources,
  MagSyncCPRSu,
  MagTimeout,
  MagTIUWinu,
  Magwkcnf,
  Messages,
  UMagAppMgr,
  UMagDefinitions,
  Umagdisplaymgr,
  //uMagDisplayUtils,
  UMagFltMgr,
  Umagkeymgr,
  Umagutils8,
  umagUtils8A,
//  fMagAnnotOptions,  {/ P122 - JK 6/7/2011 - global annotation settings form /}
  fMagAnnotationOptionsX {/p122 dmmn 7/9/11 /}
{$IFDEF TestWindows}
  ,
  frmTest
{$ENDIF}
  ,  fmagFullRes
  , fmagFullResSpecial;          {p149}

//Uses Vetted 20090929:fMagImageInfoSys, cMag4Viewer, fEKGDisplayOptions, fmagListFilter, TemplateToText, TemplateToHTML, RecentUpdatesu, fmagVideoOptions,

{$R *.DFM}
//{$R MagResource.res}
 { log application accessviolation messages.}

Class Procedure TfrmMain.ImagingException(Sender: Tobject; e: Exception);
Begin
    //maggmsgf.magmsg('s', 'Exception: ' + E.message);
  MagAppMsg('s', 'Exception: ' + e.Message); {JK 10/5/2009 - Maggmsgu refactoring}

    (*frmErrMsg := TfrmErrMsg.Create(Application);
    frmErrMsg.mmoErrorMessage.Lines.Add(E.Message);
    frmErrMsg.ShowModal;
    frmErrMsg.Free;*)
End;

{JK 10/5/2009 - Maggmsgu refactoring - removed old method}
//procedure TfrmMain.LogMsg(MsgType: string; Msg: string; Priority: TMagLogPriority
//    = MagLogINFO);
//begin
//    dmod.MagLogManager.LogEvent(self, MsgType, Msg, Priority);
//end;

{   application messages go through here.  This keeps time of inactivity
     so the TimeOut function will operate.}

Procedure TfrmMain.AppMessage(Var Msg: TMsg; Var Handled: Boolean);
Begin
  If ((Msg.Message = WM_KEYDOWN) or (Msg.Message = WM_MOUSEMOVE)) Then
  Begin
    TimerTimeout.Enabled := False;
    TimerTimeout.Enabled := True;
  End;
End;

{   Default Message Handler. Handles windows messages, decides if they are
    from CPRS }

Procedure TfrmMain.DefaultHandler(Var Message);
Var
  Buffer: Array[0..255] Of Char;
Begin
  Inherited DefaultHandler(Message);
  Try
    With TMessage(Message) Do
    Begin
      If Msg = WMIdentifier Then
      Begin
        If GlobalGetAtomName(LParam, Buffer, 255) = 0 Then
          Strpcopy(Buffer, 'NO TEXT SENT');
        If WParam = Application.Handle Then
          Frmmain.WinMsg('s', 'windows message from This Window - "' +
            Strpas(Buffer) + '"')
        Else
          Frmmain.WinMsg('s', 'windows message from Other Window - "'
            + Strpas(Buffer) + '"');
        Frmmain.WinMsg('s', 'h' + Inttostr(WParam)); //59
        ProcessVistAMessage(WParam, Strpas(Buffer));
      End;
    End;
  Except
        //showmessage('Error in Default Handler');
  End;
End;

Procedure TfrmMain.DisplayHint(Sender: Tobject);
Begin
    // though not using it now,   This works,  but Menu hints still do not show,
    //pmsg.Caption := Application.Hint;
End;

Procedure TfrmMain.ProcessVistAMessage(XHandle: Hwnd; Vmsg: String);
Var
  Xdfn: String;
  i: Integer;
  FirstPart, SecondPart: String;
  OldStyleMsg: String;
  MsgDomain: String;
Begin
  FirstPart := MagPiece(Vmsg, ';', 1);
  SecondPart := MagPiece(Vmsg, ';', 2);
  MsgDomain := MagPiece(SecondPart, '^', 1);

    {
        if VistADomain is empty, only continue if launched from CPRS
        if VistADomain not equal to MsgDomain and not launched from CPRS, exit
        if VistADomain not equal to MsgDomain but launched from CPRS, continue
    }
  If VistADomain = '' Then
  Begin
    If (Not CprsSync.SyncOn) Then
      Exit;
  End
  Else
    If (VistADomain <> Uppercase(MsgDomain)) And (Not CprsSync.SyncOn) Then
      Exit;

    {   convert the message to the old style way (without the domain)}
  OldStyleMsg := FirstPart;
  For i := 2 To Maglength(SecondPart, '^') Do
  Begin
    OldStyleMsg := OldStyleMsg + '^' + MagPiece(SecondPart, '^', i);
  End;
  WinMsg('s', 'Old Style Message=' + OldStyleMsg);

    {    FOR DISPLAY we default to always changing to selected note/ exam {}
  MagSyncCPRSf.RgSyncProc.ItemIndex := 0;
    {    If not from CPRS then forget it. {}
  If MagPiece(OldStyleMsg, '^', 2) <> 'CPRS' Then
    Exit;
    {    If not Linked to CPRS then forget it.{}
  WinMsg('s', 'Processing vista message CPRSSync.SyncON=' +
    Magbooltostr(CprsSync.SyncOn) + ', CCOWEnabled=' +
    Magbooltostr(idmodobj.GetCCOWManager.CCOWEnabled));
    {   if both CPRS Sync and CCOW are disabled, then exit}
  If (Not CprsSync.SyncOn) And (Not idmodobj.GetCCOWManager.CCOWEnabled) Then
    Exit;

    {    if CPRS is exiting we will ReSet things back to Imaging by itself{}
    {    12/21/99 if linked and CPRS is exiting, we will exit also.{}
    {    we are not accepting messages from Multiple CPRS Windows. just One.{}
  If (CprsSync.CprsHandle = 0) Then
  Begin
    If CprsSync.HexHand = IntToHex(XHandle, 8) Then
      CprsSync.CprsHandle := XHandle
    Else
      If (CprsSync.HexHand = '') And (idmodobj.GetCCOWManager.CCOWEnabled) And
        (Not CprsSync.SyncOn) Then
        CprsSync.CprsHandle := XHandle;
  End;
    {    this message was from a different  CPRS window.{}
    {   if not launched from CPRS AND CCOW disabled exit or,
        if launched from CPRS and message not from CPRS that launched Display and CCOW disabled, exit}
  If ((Not CprsSync.SyncOn) And (Not idmodobj.GetCCOWManager.CCOWEnabled)) Or
    ((CprsSync.SyncOn) And (CprsSync.CprsHandle <> XHandle) And (Not
    idmodobj.GetCCOWManager.CCOWEnabled)) Then
    Exit;
    {   at this point we know the message is from the CPRS instance that launched Display}
  LastWindowsMessage := Vmsg;
  LastWindowsMessageHandle := XHandle;
  If (MagPiece(OldStyleMsg, '^', 1) = 'END') Then
  Begin
        {       change logic, now if launched from CPRS (SyncOn) AND message from CPRS
        {       that launched Display, close on END message}
    If ((CprsSync.SyncOn) And (CprsSync.CprsHandle = XHandle)) Then
    Begin
            { get things back in a normal state before close}{ needed ? }
      mainEnablePatientLookupLogin(True);
      Close;
    End;
    CprsSync.CprsHandle := 0;
    Exit;
  End;

    { show the menu option to change CPRS Sync options}
  MnuCPRSLinkOptions.Visible := True;
  If ((CprsSync.SyncOn) And (Not idmodobj.GetCCOWManager.CCOWEnabled)) Then
    mainEnablePatientLookupLogin(False)
  Else
    mainEnablePatientLookupLogin(True);
  If (Not CprsSync.SyncOn) And (Not idmodobj.GetCCOWManager.CCOWEnabled) Then
    Exit;

    {   here we will switch to a new edtPatient. if patient from CPRS is different from Imaging's
         we don't test for XPT, because if Sync was turned off for a while, then back on, the patient
         could already be different, we could have missed the XPT message.}
  Xdfn := MagPiece(OldStyleMsg, '^', 3);
  If (Not idmodobj.GetCCOWManager.CCOWEnabled) Then
        {   only do this if we're not doing CCOW}
  Begin
    If ((idmodobj.GetMagPat1.M_DFN <> Xdfn) And (CprsSync.PatSyncPrompt)) Then
    Begin
      If (CprsSync.PatRejected = Xdfn) Then
        Exit;
      Application.BringToFront;
      If Messagedlg('OK to change Imaging Patient ? ', Mtconfirmation,
        [Mbok, Mbcancel], 0)
        = MrCancel Then
      Begin
        CprsSync.PatRejected := Xdfn;
        Exit;
      End;
      If Not idmodobj.GetMagDBBroker1.IsConnected Then
        ImagingDisplayLogin(IniLocalServer, Inttostr(IniListenerPort),
          True);
      If Application.Terminated Then
        Exit;
      If Not idmodobj.GetMagDBBroker1.IsConnected Then
        Exit;

      WinMsg('s', 'New patient selected [' + Xdfn +
        '] notifying Remote Broker Manager');
      If idmodobj.GetMagPat1.CurrentlySwitchingPatient Then
        RIVNotifyAllListeners(Self, 'NewPatientSelected', '');
      i := 0;
      While Length(Screen.Forms[i].Name) > 0 Do
      Begin
        If FsModal In Screen.Forms[i].FormState Then
        Begin
          Screen.Forms[i].ModalResult := MrCancel;
          i := i + 1;
        End
        Else // the fsModal forms always sequenced prior to the none-fsModal forms
          Break;
      End;
      ChangeToPatient(Xdfn);
    End;
    If ((idmodobj.GetMagPat1.M_DFN <> Xdfn) And (CprsSync.PatSync)) Then
    Begin
      If Not idmodobj.GetMagDBBroker1.IsConnected Then
        ImagingDisplayLogin(IniLocalServer, Inttostr(IniListenerPort),
          True);
      If Application.Terminated Then
        Exit;
      If Not idmodobj.GetMagDBBroker1.IsConnected Then
        Exit;

      WinMsg('s', 'New patient selected [' + Xdfn +
        '] notifying Remote Broker Manager');
      If idmodobj.GetMagPat1.CurrentlySwitchingPatient Then
        RIVNotifyAllListeners(Self, 'NewPatientSelected', '');
      i := 0;
      While Length(Screen.Forms[i].Name) > 0 Do
      Begin
        If FsModal In Screen.Forms[i].FormState Then
        Begin
          Screen.Forms[i].ModalResult := MrCancel;
          i := i + 1;
        End
        Else // the fsModal forms always sequenced prior to the none-fsModal forms
          Break;
      End;
      ExternalPatientChange := True;
      ChangeToPatient(Xdfn);
    End;
  End;

  If (idmodobj.GetMagPat1.M_DFN = Xdfn) Then
  Begin
        {   At this point we have same Patient.  In Display we are always switChing to Note/Exam{}
    If MagPiece(OldStyleMsg, '^', 1) = 'RPT' Then
    Begin
      If (MagPiece(OldStyleMsg, '^', 4) = 'RA') Then
        ImagesForCPRSRadExam(OldStyleMsg);
      If (MagPiece(OldStyleMsg, '^', 4) = 'TIU') Then
        ImagesForCPRSTIUNote(OldStyleMsg);
    End;
  End;
End;

Procedure TfrmMain.ImagesForCPRSRadExam(CprsString: String);
Var
  Rmsg, Grpinfo: String;
  Rlist: TStrings;
  Rstat: Boolean;
  Rnumstat: Integer;
Begin
  Rlist := Tstringlist.Create;
  Try
        // JMW 7/1/2005 p45t4 Don't clear patient images for CPRS IR
      //    clearpatientimages(false, false); //ImagesForCPRSRadExam
    idmodobj.GetMagDBBroker1.RPMaggCPRSRadExam(Rstat, Rmsg, Rlist, CprsString);
    Rnumstat := Strtoint(MagPiece(Rlist[0], '^', 1));
        {TODO -c2:  THIS CODE BELOW IS COPIED,NEED TO MAKE A CALL OUT OF THIS}
    Grpinfo := Rlist[0];
    Rlist.Delete(0);
    If Not Rstat Then
    Begin
      ClearPatientImages(True, False); //ImagesForCPRSRadExam
      If Rnumstat = -2 Then
      Begin
        WinMsg('DEQA', Rmsg);
        WinMsg('s', 'CPRS Data that generated the Error : ');
        WinMsg('s', '    ' + CprsString);
        Exit;
      End
      Else
        WinMsg('', Rmsg);
      Exit;
    End;
        {-------------------------------}
    If Not Doesformexist('frmGroupAbs') Then
      UprefToGroupWindow(Upref);
    FrmGroupAbs.Visible := True;
    Try
      FrmGroupAbs.SetInfo('Radiology Exam, Images -- ' +
        Frmmain.EdtPatient.Text,
        '  ' + MagPiece(Grpinfo, '^', 4) + '  ' + Inttostr(Rlist.Count) +
        '  Images',
        '', MagPiece(Grpinfo, '^', 5), MagPiece(Grpinfo, '^', 4));
      FrmGroupAbs.MagImageList1.LoadGroupList(Rlist, '', '');
      FrmGroupAbs.Show;
    Except
      On e: Exception Do
      Begin
        Showmessage('exception : ' + e.Message);
        FrmGroupAbs.FGroupIEN := '';
      End;
    End;
        {------------------------}
  Finally
    Rlist.Free;
  End;

End;

Procedure TfrmMain.FormCreate(Sender: Tobject);
Begin
  {JK 10/5/2009 - Maggmsgu refactoring - note: had to put MagLogger.Open in the main form destory method
   since FMagMain is "shared" across different projects through the shared units. This prevents me from
   putting this method in the main unit's finalization section where it belongs.  Maybe this can be done
   later when a full refactoring is completed.}
  MagDisplayMsg := TMagAppMessageLog.create();

  ImagInterfaces.IMsgObj := MagDisplayMsg;
(*RCA  can't do it here.  dmod is still NIL   *)
 // ImagDMinterface.idModObj := dmod;

 (*  RCA  OUT  .  now use magDisplayMsg
  MagLogger.Open(plUser,
    'Display_Log.zip',
    True,
    '',
    30,
    10000000,
    'VistA Imaging Clinical Display',
    False);
 *)

{/ P122 - JK 10/19/2011 - turned off internal testing features that write to local disk folder /}
//  MagLogger.Open(
//    plAdmin,
//    'Display_Log.zip',
//    True,
//    '',
//    30,
//    10000000,
//    'VistA Imaging Clinical Display',
//    true,
//    false);

  GSess := TSession.Create;
  QueMsgList := Tstringlist.Create;
  FTestingPkg := '';
  FTestingStatus := '';
  FSAppBackGroundColor := $00E0DFCF;
  MTest1.Visible := False;
    {  load additional cursors.{}
  Screen.Cursors[MagcrCrossHair] := LoadCursor(HInstance, 'TMAGCRCROSSHAIR');
  Screen.Cursors[MagcrMagnify] := LoadCursor(HInstance, 'TMAGCRMAGNIFY');
  Screen.Cursors[MagcrPan] := LoadCursor(HInstance, 'TMAGCRPAN');

  CoInitialize(Nil); { for using com objects }
  Application.OnException := ImagingException;
    { default window caption, it changes with User name and Login Site}
  FMainCaption := 'VistA Imaging Display : ';
  caption := FMainCaption;

  FClosingImaging := False;
    {Register the windows message that we will use to communicate with CPRS and
      other VistA applications}

    //WMIdentifier := RegisterWindowMessage('VistA Event - Clinical');
    //JMW 1/18/2006 p46 recieve newer windows message from CPRS
  WMIdentifier := RegisterWindowMessage('VistA Domain Event - Clinical');
  MuseSite := 1;

  Application.OnMessage := AppMessage;
  Application.OnIdle := IdleHandler;
    // Testing
  Application.OnHint := DisplayHint;
  Application.OnMinimize := AppMinimize;
  Application.OnRestore := AppRestore;
  WinMsg('s', 'GettingFormPosition(self as tform) frmMain T: ' + Inttostr(Self.Top) + ' L: ' +
    Inttostr(Self.Left));
  GetFormPosition(Self As TForm);
  WinMsg('s', 'GotFormPosition(self as tform) frmMain T: ' + Inttostr(Self.Top) + ' L: ' +
    Inttostr(Self.Left));
  CreateDynamicPatMenu;
  CreateDynamicReportMenu;
  CreateDynamicHelpMenu;

  LogActions('START SESSION', '', '');
    { out for now, but not forgotten             // AlignToLabel; }

  InitVariables;
  LoadWSSettings;
    { unitl the demo is back in and working, this is how it can be tested.{}
  MnuDemoImages.Enabled := (Uppercase(GetIniEntry('demo options',
    'IMAGE DEMO ENABLED')) = 'TRUE');
  LoadHelpMenu;

  {/ P122 - JK 6/23/2011 /}
  if not FileExists(GSess.AnnotationTempDir) then
    CreateDir(GSess.AnnotationTempDir);

End;

Procedure TfrmMain.LoadWSSettings;
Var
  s: String;
  Magini: TIniFile;
  altviewer: String;

Begin
    { create a MAG308.INI if there isn't any}
  CreateIFNeeded;
    {  if this version is different from the last time we updated the INI, then
       run the Update function}
  UpdateIfNeeded(MagGetFileVersionInfo(Application.ExeName));
    {    GetConfigFileName  is used through the App, it returns the name of the
        configuration file (mag308.ini for patch 8) {}
  Magini := TIniFile.Create(GetConfigFileName);
  Try
    With Magini Do
    Begin
       {p161 allow dev to stop restricting view  based on resolution}
       GNoRestrictView :=  Uppercase(ReadString('DEMO OPTIONS', 'NORESTRICTVIEW', 'FALSE')) = 'TRUE'  ;
       magappmsg('','GnoRestrictView = ' + magbooltostr(GnoRestrictView));
       if GnoRestrictView then AddDelKey('TEMP NO RESTRICT',TRUE);
       

       {p149 gek put DontUseCCOW in for testing.}
       mnuTestScript.visible := Uppercase(ReadString('DEV-TESTSCRIPT', 'TESTSCRIPTMENU', 'FALSE')) = 'TRUE'  ;
       mnuTestScriptDontUseCCOW.Checked := magini.ReadString('DEV-CONTEXT','DontUseCCOW','FALSE')='TRUE';
       GDontUseCCOW := mnuTestScriptDontUseCCOW.Checked;
       lbVersion.visible := mnuTestScript.visible ;
       {p161 developer has RestrictView OFF}
      if GnoRestrictView then 
        begin
          lbVersion.visible := true;
          lbVersion.Caption := 'Restrict View is OFF';
        end;
       {END of code for RestrictView OFF p161}
            //Alternate Video Viewer=C:\WINDOWS\system32\mplay32.exe
      s := MagGetWindowsDirectory;
            //93 gek qad to fix Alternate Video Viewer if it's been deleted.
      altviewer := ReadString('Workstation settings', 'Alternate Video Viewer', '');
      If altviewer = '' Then
        Writestring('Workstation settings', 'Alternate Video Viewer', s + '\system32\mplay32.exe');
            { }
      FWrksAbsCacheON := (Uppercase(ReadString('Workstation Settings', 'CacheAbstracts', 'TRUE')) = 'TRUE');
      AllowRemoteLogin := (Uppercase(ReadString('Login Options', 'AllowRemoteLogin', 'FALSE')) = 'TRUE');
      AllowSave := (Uppercase(ReadString('Workstation Settings', 'Allow Image SaveAs', 'FALSE')) = 'TRUE');
            //OpenDemo1.visible := ( allowsave or (UpperCase(ReadString('Workstation Settings','ViewDirectories','FALSE'))='TRUE'));
      WrksLocation := ReadString('Workstation Settings', 'Location', 'UNKnown');
            //WrksCompName := Uppercase(ReadString('SYS_AUTOUPDATE', 'ComputerName', 'NoComputerName'));
            { Read Computer Name from OS. later Send to VistA WINDOWS WORKSTATIONS File}
      WrksCompName := GetMagComputerName; //59
      WinMsg('s', 'Computer Name : ' + WrksCompName); //59
      Writestring('SYS_AUTOUPDATE', 'ComputerName', WrksCompName); //59
            {   Date/Time when MagSetup.exe (MagInstall.exe) was run. Set by MagInstall.exe}
      LastMagUpdate := Uppercase(ReadString('SYS_AUTOUPDATE', 'LASTUPDATE', '0'));
            //p8t46   LASTMUSEUPDATE := Uppercase(ReadString('SYS_AUTOUPDATE', 'LASTMUSEUPDATE', '0'));

          // // P8T14   Stop Displaying jukebox abstracts.
          //IniViewJBox := (UpperCase(ReadString('Workstation Settings', 'Display JukeBox Abstracts', 'TRUE')) = 'TRUE');

            // p72 IniViewJbox := FALSE;
      Upref.AbsViewJBox := False;
            // JMW 3/17/2005 p45
      MagRemoteBrokerManager.DemoRemoteSites := Magstrtobool(ReadString('Demo Options', 'DemoRemoteSites', 'FALSE'));
      DemoRemoteSites1.Checked := MagRemoteBrokerManager.DemoRemoteSites;
            //MagRemoteBrokerManager.SiteServiceURL := lowercase(readString('Remote Site Options','RemoteSiteLookupServer','http://vhaann26607.v11.med.va.gov/VistaWebSvcs/SiteService.asmx'));
      MagRemoteBrokerManager.RIVEnabled := Magstrtobool(ReadString('Remote Site Options', 'RemoteImageViewsEnabled', 'TRUE'));
            // JMW 4/26/2007 Patch 72
            // override the ViX server and port from the site service here
      MagRemoteBrokerManager.LocalVixServerOverride := ReadString('Remote Site Options', 'LocalVixServer', '');
      MagRemoteBrokerManager.LocalVixPortOverride := ReadInteger('Remote Site Options', 'LocalVixPort', 0);
            // JMW 8/13/08 p72t26 - check for override to allow access to DOD images
      AllowDODSites := (Uppercase(ReadString('Remote Site Options', 'AllowDODSites', 'FALSE')) = 'TRUE');
            {/ P94 JMW 10/20/2009 - read the value from the ini file /}
      BlockVixVASites := (Uppercase(ReadString('Remote Site Options', 'BlockVixVASites', 'FALSE')) = 'TRUE');

            //DBI
           //IniViewRemoteAbs := FALSE; //(UpperCase(ReadString('Workstation Settings', 'Display Remote Abstracts', 'TRUE')) = 'TRUE');
         //upref.absViewRemote := FALSE; // P72
      Loginonstartup := (Uppercase(ReadString('Login Options', 'LoginOnStartup', 'TRUE')) = 'TRUE');
      Wsid := Uppercase(ReadString('Workstation Settings', 'ID', 'UNKnown'));
      Wsid := Wsid + '_' + ReadString('Workstation Settings', 'Location', 'UNKnown');
      IniListenerPort := ReadInteger('Login Options', 'Local VistA port', 9200);
      IniLocalServer := ReadString('Login Options', 'Local VistA', 'BROKERSERVER');
      IniLogAction := (Uppercase(ReadString('Workstation Settings', 'Log Session Actions', 'FALSE')) = 'TRUE');
      MUSEenabled := (Uppercase(ReadString('Workstation Settings', 'MUSE Enabled', 'FALSE')) = 'TRUE');
      TbtnEkg.Visible := MUSEenabled;
      MnuMUSEEKGlist.Visible := MUSEenabled;
      MnuFakeName.Visible := (Uppercase(ReadString('Workstation Settings', 'Allow Fake Name', 'FALSE')) = 'TRUE');
            // report of a Name in the FakePatient field of INI was same as Real patient.
            // We always set to Lightyear, Buzz now.
            // idmodobj.GetMagPat1. M_FakePatientName := Uppercase(Readstring('Workstation Settings', 'Fake Name', 'McFarland,Billy'));

      MnuLocalMuse.Visible := (Uppercase(ReadString('Workstation Settings', 'MUSE Demo Mode', 'FALSE')) = 'TRUE');
      MnuLocalMuse.Checked := MnuLocalMuse.Visible;
            //Stu: N/A        UseMuseDemoDB := mnuLocalMuse.Checked;

      s := ReadString('Workstation Settings', 'WorkStation TimeOut minutes', '');
      SetWorkstationTimeout(s);
    End;
  Finally
    Magini.Free;
  End; {TRY}

End;

Procedure TfrmMain.InitVariables;
Var
  ApplicationDataFolder: String;
Begin
    //  UseAutoRealign := true;
      // LoadWSSettings must be called first,
  // moved to FormCreate     QueMsgList := TStringlist.create;
  AppPath := Copy(ExtractFilePath(Application.ExeName), 1,
    Length(ExtractFilePath(Application.ExeName)) - 1);
(* 10/11/12  gek 129t10 not for Windows 7, no longer using AppPath

  If Not Directoryexists(AppPath + '\temp') Then
    Forcedirectories(AppPath + '\temp');
  If Not Directoryexists(AppPath + '\image') Then
    Forcedirectories(AppPath + '\image');
  If Not Directoryexists(AppPath + '\cache') Then
    Forcedirectories(AppPath + '\cache');
  If Not Directoryexists(AppPath + '\import') Then
    Forcedirectories(AppPath + '\import');
    *)
    // JMW 6/22/2005 p45 Create a cache directories in the application path
 // win 7 out  ImageCacheDirectory := AppPath + '\cache';
  ApplicationDataFolder := GetEnvironmentVariable('AppData');
  If ApplicationDataFolder <> ''
    Then  ImageCacheDirectory := ApplicationDataFolder + '\icache'
    else  ImageCacheDirectory :=  'c:\temp' ;  //129t10 Shouldn't happen...
  If Not Directoryexists(ImageCacheDirectory) Then
    Forcedirectories(ImageCacheDirectory);
    //Security keys is now in uMagKeyMgr.pas, need to have a cMagkeymgr that can
    // create it's own SeurityKey list.
  SecurityKeys := Tstringlist.Create;
  Deletedimages := Tstringlist.Create;
  TRadList := Tstringlist.Create;
  Upref := Tuserpreferences.Create;
    //p8t46   MagPtrList := TList.Create;
  MUSEconnectFailed := False;
  CprsSyncDefaults;

  if frmAnnotOptionsX = nil then   {/P122 dmmn 7/9/11 - new simplified options }
    frmAnnotOptionsX := TfrmAnnotOptionsX.Create(Self);

End;

Procedure TfrmMain.SetWorkstationTimeout(Minutes: String);
Var
  i: Integer;
Begin
  Try
    i := Strtoint(Minutes);
  Except
    On e: Exception Do
      i := 0;
  End;
  WorkStationTimeout := i;
  If i > 0 Then
    MagTimeoutform.SetApplicationTimeOut(Inttostr(i), TimerTimeout);
End;

Procedure TfrmMain.CprsSyncDefaults;
Begin
    // defaults for CPRSSync options
    // 12/21/99   new changes for CPRS Link, only on if started by CPRS
    // so we default to CPRSSync.SyncON = FALSE
  CprsSync.Queried := True;
  CprsSync.SyncOn := False;
  CprsSync.PatSync := True;
  CprsSync.PatSyncPrompt := False;
    // we default to ProcSync := true for Display, user can't chnage it.
  CprsSync.ProcSync := True;
  CprsSync.ProcSyncPrompt := False;
End;

Procedure TfrmMain.FormPaint(Sender: Tobject);
Var
  i: Integer;
  t: TStrings;
  Allow2: String;
  CprsDFN: String;

Begin
  DebugFile('procedure TfrmMain.FormPaint Entered'); {JK 3/11/2009}
  Try
        { we are only doing this once }
    If Paramsearched Then
      Exit;
    ChDir(AppPath);
    Paramsearched := True;
//RCA here,  dmod has been created.
  ImagDMinterface.idModObj := dmod;

    MagPat := idmodobj.GetMagPat1;

    MagObserverLabel1.MagPat := idmodobj.GetMagPat1;

    Allow2 := GetIniEntry('Workstation settings', 'AllowMultipleInstances');
    If (Uppercase(Allow2) <> 'TRUE') Then
      If DoIExist('Vista Imaging Display') Then
      Begin
                //not in 93 frmMain.hide;
        Application.Processmessages;
        Showmessage('"VistA Imaging" is already running. ' + #13 + #13 +
          'A second instance will not be started.');
        DebugFile('procedure TfrmMain.FormPaint: "VistA Imaging" is already running. This second instance will not be started.');
                //halt;  {JK 3/11/2009 removed halt and exit}
                //exit;
        Application.Terminate; {JK 3/11/2009}
      End;
(* RCA out,  no longer doing AutoUpdating.
    t := Tstringlist.Create;
    If IsUpdateing('VistA Imaging', 'LASTUPDATE', t) Then
    Begin
      t.Free;
      Application.Terminate;
      Application.Processmessages;
      Exit;
    End;
    For i := 0 To t.Count - 1 Do
      WinMsg('s', t[i]);
    Application.Processmessages;
    t.Free;
    *)
  Finally
    DebugFile('procedure TfrmMain.FormPaint Exited'); {JK 3/11/2009}
  End;
End;

{ The procedure :  DoOnceAtEnd
  is called after all forms are created, it is in the FormCreate event
  of the last window created for the applicatoin 'MagUtilFormf'
  it does more initialization, There was a problem doing it here because
  all windows aren't actually created yet, (at this point in FormPaint )
  So we moved some Application initialization code to that event.
  This is only being called once. }

Procedure TfrmMain.DoOnceAtEnd;
Var
  Vserver, Paramup, Vport, Vpatid: String;
  Ts: TStrings;
  Forceconnect, Res: Boolean;
  i: Integer;
  CprsDFN: String;
  CprsTMP: String; //59
  Piecenum: Integer; //59

  Procedure CommandLineCodes(Var Res: Boolean);
  Var
    i: Integer;
  Begin
    Res := False;
    If ParamCount = 0 Then
      Exit;
    For i := 1 To ParamCount Do
      If Pos('=', ParamStr(i)) > 0 Then
      Begin
        Paramup := Uppercase(MagPiece(ParamStr(i), '=', 1));
        If (Paramup = 'S') or (Paramup = 'SERVER') Then
          Vserver := MagPiece(ParamStr(i), '=', 2);
        If (Paramup = 'P') or (Paramup = 'PORT') Then
          Vport := MagPiece(ParamStr(i), '=', 2);
        If (Paramup = 'I') or (Paramup = 'ID') Then
          Vpatid := MagPiece(ParamStr(i), '=', 2);
        If (Paramup = 'D') or (Paramup = 'DFN') Then
          Vpatid := '`' + MagPiece(ParamStr(i), '=', 2);
        Res := True;
      End;
  End;
Begin
  DebugFile('procedure TfrmMain.DoOnceAtEnd entered'); {JK 3/11/2009}
  {p149 - gek - Print options}
  GPrintOption :=   magpoNormal ;
 
  {Testing,  show version}          {p149}
   IF lbVersion.visible then 
     begin
       lbVersion.Caption  := MagGetFileVersionInfo(application.exename) ;
       if GNoRestrictView then lbVersion.Caption := lbVersion.Caption + ' Restrict View OFF';
     end;


//RCA here,  dmod has been created.
//  ImagDMinterface.idModObj := dmod;
    //  WinMsg('s','DEBUG--- DOnceAtEnd()');
    // these two copied from somewhere else for temporary debugging.
    //Citrix error 32      AssignFile(LogFile, Apppath + '\temp\' + Copy(WSID, 2, 2) + ' ' + '.log');
    //Citrix error 32      rewrite(LogFile);
  Vpatid := '';

    //MaggMsgf.InitializeLogManager(idmodobj.GetMagLogManager); {JK 10/5/2009 - Maggmsgu refactoring - removed old method}

    //59 frmImagelist := TfrmImageList.create(self);
  Application.CreateForm(TfrmImageList, FrmImageList);
  GmagPublish := FrmImageList.MagPublisher1;

    //idmodobj.GetMagLogManager.LogEvent(self, '', 'Log Manager has been initialized');  {JK 10/6/2009 - Maggmsgu refactoring}

  idmodobj.GetMagDBBroker1.CreateBroker;
    {TODO -c3: we need the next line, to sync the TRPCBrokers that are used, but
        it is duplicated in uMagDisplayMgr , need to check if we are stepping on toes.}
  idmodobj.GetMagDBSysUtils1.Broker := idmodobj.GetMagDBBroker1.GetBroker;
  CprsStartedME := False;
  Ts := Tstringlist.Create;
  CprsDFN := '';
  Try
    MagPatPhoto1.MagDBBroker := idmodobj.GetMagDBBroker1;
    MagPatPhoto1.MagSecurity := idmodobj.GetMagFileSecurity;
    MagPatPhoto1.MagPat := idmodobj.GetMagPat1;

    Vserver := IniLocalServer;
    Vport := Inttostr(IniListenerPort);
    Application.Processmessages;

        // JMW 6/23/08 - display the version of the application (useful for
        // debugging)
        //LogMsg('s', 'Application Version: ' +
        //    MagGetFileVersionInfo(application.ExeName, false), MagLogINFO);

 //   MagLogger.LogMsg('s', 'Application Version: ' + MagGetFileVersionInfo(Application.ExeName, False), MagLogINFO); {JK 10/5/2009 - Maggmsgu refactoring}
    MagAppMsg('s', 'Application Version: ' + MagGetFileVersionInfo(Application.ExeName, False), MagmsgINFO); {JK 10/5/2009 - Maggmsgu refactoring}

    If idmodobj.GetMagFileSecurity.SecurityOn Then
      WinMsg('', 'Imaging Network Security is ON')
    Else
      WinMsg('', 'Imaging Network Security is OFF');
    MSecurityON.Checked := idmodobj.GetMagFileSecurity.SecurityOn;
    FrmImageList.MnuImageFileNetSecurityON1.Checked :=
      idmodobj.GetMagFileSecurity.SecurityOn;
    WinMsg('s', 'Parameter String: ' + CmdLine);
    WinMsg('s', Inttostr(ParamCount) + ' Command line Parameters.');
    If ParamCount > 1 Then
    Begin
      Loginonstartup := True;
      For i := 1 To ParamCount Do
        WinMsg('s', '  - Param ' + Inttostr(i) + ' ' + ParamStr(i));
    End;
    try
      screen.Cursor := crHourGlass;          {p149}
    winmsg('','Attempting to Join CCOW Context...');
    idmodobj.GetCCOWManager.Attach_(Self);
        //    WinMsg('s','DEBUG--- in fmagMain, about to do JoinContext()');
    idmodobj.GetCCOWManager.JoinContext();
    finally
      screen.cursor := crdefault;          {p149}
    end;
    If Not Loginonstartup Then //// stop here if not LoginOnStartUp.
    Begin
      WinMsg('', 'Select menu option "File | Login" to connect to VistA');
      Exit;
    End;
        // Here is LoginOnStartup is true.  LoginOnStartUp is set to TRUE, if
        //  we are being started by CPRS.   or any parameters are on the command line.
    Forceconnect := False;
    CommandLineCodes(Res);
    If Not Res Then
      If ParamStr(3) <> '' Then
      Begin
        Forceconnect := True;
        Vserver := ParamStr(3);
        Vport := ParamStr(4);
        CprsDFN := ParamStr(1);
        idmodobj.GetMagPat1.M_CPRSDFN := CprsDFN;
        CprsTMP := MagPiece(ParamStr(2), ')', 1); //59
        Piecenum := Maglength(CprsTMP, ','); //59
        CprsSync.HexHand := MagPiece(CprsTMP, ',', Piecenum); //59
        cprsFlag := True;
        CprsStartedME := True;
      End;

    WinMsg('', 'Login to VistA...');
    ImagingDisplayLogin(Vserver, Vport, Forceconnect); {called from DoOnceAtEnd}
    If Application.Terminated Then
      Exit;
    If Not idmodobj.GetMagDBBroker1.IsConnected Then
    Begin
      CprsSync.SyncOn := False; // 12/21/99
      mainEnablePatientLookupLogin(Not CprsSync.SyncOn); // 12/21/99
      Exit;
    End;
        // Image List window is always created.  we load pref here.
        ////   moved to ImageDisplayLogin procedure
        //UprefToImageListWin(upref);
        //frmMain.Visible := false;  //No Main Window
        //frmImageList.Show;         //No Main Window.
    Application.Processmessages;
    DebugFile('procedure TfrmMain.ImagingDisplayLogin: "A" frmMain.Visible = '
      + Magbooltostr(Frmmain.Visible)); {JK 3/11/2009}
    If Frmmain.Visible Then
            {JK 3/11/2009 - added check for Visible before setting focus}
    Begin
      EdtPatient.SetFocus;
      EdtPatient.SelectAll;
    End;
    If (idmodobj.GetCCOWManager.CCOWEnabled) Then
    Begin
            //        WinMsg('s','DEBUG--- in fmagMain, about to do ContextorCommitted');
      idmodobj.GetCCOWManager.ContextOrCommitted(Self);
            // get patient from context
    End;
    idmodobj.GetMagPat1.M_CPRSDFN := '';
    If Copy(ParamStr(1), 1, 2) = '/D' Then
      Exit;
    If ParamCount = 0 Then
      Exit;
    If CprsDFN <> '' Then
    Begin
      CprsSync.SyncOn := True; // 12/21/99
            //mainEnablePatientLookupLogin(not CPRSSync.SyncOn); // 12/21/99
      mainEnablePatientLookupLogin(idmodobj.GetCCOWManager.CCOWEnabled);
      If (Not idmodobj.GetCCOWManager.CCOWEnabled) Then
        ChangeToPatient(CprsDFN); // 11/24/02
    End
    Else
      If Vpatid <> '' Then
        PatientSelect(Vpatid)
  Finally
    If (Not Application.Terminated) Then
    Begin
      Try
        DebugFile('procedure TfrmMain.DoOnceAtEnd: frmMain.Visible = ' +
          Magbooltostr(Frmmain.Visible)); {JK 3/11/2007}
        If Frmmain.Visible Then
        Begin
          ResizePMain;
          Ts.Free;
          If (EdtPatient.Enabled And EdtPatient.Visible) Then
            EdtPatient.SetFocus;
        End;
        Application.HelpFile := AppPath + '\magimaging.hlp';
                //OUT FOR 93 RELEASE  LoadDevMenu;
      Except
        On e: Exception Do
          DebugFile('procedure TfrmMain.DoOnceAtEnd: Handled EXCEPTION = '
            + e.Message);
      End;

    End;
  End;
  DebugFile('procedure TfrmMain.DoOnceAtEnd exited'); {JK 3/11/2009}
End;

Procedure TfrmMain.FormClose(Sender: Tobject; Var action: TCloseAction);
Var
  Xmsg: String;
Begin
  WinMsg('s', 'in TfrmMain.FormClose');
  DebugFile('procedure TfrmMain.FormClose Entered'); {JK 3/11/2009}
  Try

    If IsProcessRunning(MagVideoProcessInfo) Then
    Begin
      MagTerminateProcess(0, MagVideoProcessInfo);
    End;

    MagImageManager1.StopCache();
        //93, so that MagFileSecurity doesn't need MAGiMAGEmANAGER.
    idmodobj.GetMagFileSecurity.MagCloseSecurity(Xmsg);
    FClosingImaging := True;
        // lets Destroy all the Variables;
    WinMsg('s', 'SaveformPosition(self as Tform) frmMain');
    SaveFormPosition(Self As TForm);
        // ClearImgPtr;
       //    Raise EMyException.create('My error during closing');
      //p8t46     MagPtrList.free;
    TRadList.Free;
    SecurityKeys.Free;
    Deletedimages.Free;
    QueMsgList.Free;
    If MnuSaveSettingsonExit.Checked Then
      Saveusersettings;
    LogActions('END SESSION', '', Duz);
    idmodobj.GetMagDBBroker1.RPMaggLogOff;
  Except
    On e: Exception Do
    Begin
      Showmessage('E: Exception: while Closing Application:' + e.Message);
      DebugFile('procedure TfrmMain.FormClose UNHANDLED Exception: ' +
        e.Message);
    End;
  End;
    //moved above   MagImageManager1.stopCache();
  EraseCacheFiles;
  DebugFile('procedure TfrmMain.FormClose Exited'); {JK 3/11/2009}
End;

Procedure TfrmMain.ClearPatImages;
Var
  i: Integer;
Begin
    {here we clear all info on a patient.  i.e. images, info, panels, arrays etc}
  Try
    UpdateWindowcaption;
    WinMsg('', 'Clearing patient Images... ');
    Cursor := crHourGlass;
    Deletedimages.Clear;
    EdtPatient.Text := '';
        //p8t33 DemoMode := false;
      //p8t46     DemoDirectory := '';
    EnablePatientButtonsAndMenus(False, MUSEenabled);
    mainEnablePatientButtonsAndMenus(False);

        { Old vs New.  These method calls to other windows from the main window need
          to be refactored to an object oriented design, to stop the coupling from
          main form to other forms }
    If Doesformexist('MagTiuWinf') Then
    Begin
      MagTIUWinf.ClearTIUWin;
    End;
    If Doesformexist('RadListWin') Then
    Begin
      Radlistwin.Clear;
    End;
    If Doesformexist('MAGGRPTF') Then
      Maggrptf.Close;
    FrmImageList.ClearImageControls;

        {  Patch 8T 35 we put in Close, and Close for frmFullRes has action := cafree;}
        (* frmFullRes.Mag4Viewer1.ClearViewer;*)
    If Doesformexist('frmfullres') Then
      FrmFullRes.Close;
    TRadList.Clear;
    If Doesformexist('frmRadViewer') Then
      FrmRadViewer.Close();

    If Doesformexist('Maggrpcf') Then
      Maggrpcf.Close;
    For i := Screen.CustomFormCount - 1 Downto 0 Do
    Begin
      If (Pos('MAGGRPCF', Uppercase(Screen.CustomForms[i].Name)) > 0) Then
      Begin
        Screen.CustomForms[i].Destroy;
        Continue;
      End;
      If (Pos('FRMMAGIMAGEINFO', Uppercase(Screen.CustomForms[i].Name)) >
        0) Then
      Begin
        Screen.CustomForms[i].Destroy;
        Continue;
      End;
    End;
  Finally
        { more carry over from the old way}
    ClearPatientImages(True, True);
    Cursor := crDefault;
    WinMsg('', 'Patient Images cleared.');
    Application.Processmessages;
  End;
End;

Procedure TfrmMain.ClearPatientImages(CloseGroup, ClearAbsWin: Boolean);
Var
  i: Integer;
  Xmsg: String;
Begin
    { we're closing here, because a bug showed that security was still opened.
        This is quick and dirty, to get to the church on time}
  MagImageManager1.StopCache();
    //93, so that MagFileSecurity doesn't need MAGiMAGEmANAGER.

  idmodobj.GetMagFileSecurity.MagCloseSecurity(Xmsg);
  CloseRadiologyWindow();
  CloseEKGWin;
  If (Doesformexist('frmMagAbstracts') And ClearAbsWin) Then
  Begin
    FrmMagAbstracts.caption := 'Abstract View';
  End;
  For i := ComponentCount - 1 Downto 0 Do
  Begin
    If Components[i] Is TfrmGroupAbs Then
      If CloseGroup Then
      Begin
        (Components[i] As TfrmGroupAbs).Close;
        Continue;
      End;
    If Components[i] Is TfrmVideoPlayer Then
    Begin
      (Components[i] As TForm).Close;
      Continue;
    End;
  End;
End;

Procedure TfrmMain.EdtPatientKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_Return Then
  Begin
    If (EdtPatient.Text = '') Then
      idmodobj.GetMagPat1.Clear
    Else
      PatientSelect(EdtPatient.Text);

    If Frmmain.Visible Then
    Begin
      If (EdtPatient.Text = '') Then
        EdtPatient.SetFocus;
    End;
  End;
End;

Procedure TfrmMain.PatientSelect(Input: String);
Var
  Xmsg: String;
Begin
  Try
{debug94} WinMsg('s', '* * -- * *   - In PatientSelect ' + 'input: ' + Input);
    If CprsSync.SyncOn And (Not idmodobj.GetCCOWManager.CCOWEnabled) Then
    Begin
  {debug94} WinMsg('s', '* * -- * *   - Exiting PatientSelect ' + 'input: ' + Input + ' CCOWEnabled : ' + Magbooltostr(idmodobj.GetCCOWManager.CCOWEnabled));
      Exit; //59
    End;
    {       If using Fake Name, display it, not the input}
    If idmodobj.GetMagPat1.M_UseFakeName Then
      WinMsg('', 'Searching for ''' + idmodobj.GetMagPat1.M_FakePatientName + '''' +
        '...')
    Else
      WinMsg('', 'Searching for ''' + Input + '''' + '...');

    {       Login if not connected.}
    If Not idmodobj.GetMagDBBroker1.IsConnected Then
      ImagingDisplayLogin(IniLocalServer, Inttostr(IniListenerPort), True);

    If Application.Terminated Then
      Exit;

    {       Login was canceled, or wasn't accepted.}
    If Not idmodobj.GetMagDBBroker1.IsConnected Then
      Exit;
{debug94} WinMsg('s', '* * -- * *   - calling idmodobj.GetMagPat1.SelectPatient ' + 'input: ' + Input);

    {       user could have canceled the Lookup}
    If Not idmodobj.GetMagPat1.SelectPatient(Input, Xmsg) Then
    Begin
 {debug94} WinMsg('s', '* * -- * *   - In PatientSelect calling idmodobj.GetMagPat1.SelectPatient ' + 'input: ' + Input + ' Result := false, exiting.');
      WinMsg('', Xmsg);

    {...     There is no code here for a patient being selected or not. }
    { fmagMain implements IMagObserver. When notified that a patient has changed
       the _Update method will call UpdPatGUIData
       (to perform all code for patient change, that hasn't been moved out of Main form yet.)}
    End;
  Finally
 {debug94} WinMsg('s', '* * -- * *   - Exiting PatientSelect ' + 'input: ' + Input);
  End;
End;

Procedure TfrmMain.ChangeToPatient(Xdfn: String; IsIcn: Boolean = False);
Var
  Xmsg: String;
  Windowsmsg: String;
  MsgHandle: Hwnd;
Begin
  If Not FDisablePatSelection Then
  Begin
    Try
            { JMW 7/7/2009 P93T10 - clear the current sensitivity
             level only if the patient is different or the dfn is clear
             want to keep current level if only refreshing the current patient }
      If (idmodobj.GetMagPat1.M_DFN <> Xdfn) or (idmodobj.GetMagPat1.M_DFN = '') Then

        FCurrentPatientSensitiveLevel := 0;
      FDisablePatSelection := True;
            {p8t35  Quick fix. try stop access violations when selecting patients quickly. ?{}
      MnuFile.Enabled := False;
      LastWindowsMessage := '';
      LastWindowsMessageHandle := 0;
 {debug94} WinMsg('s', '* * -- * *   - frmMain in ChngToPat, about to idmodobj.Getmagpat1.switchtopatient ' + Xdfn);
      If Not idmodobj.GetMagPat1.SwitchTopatient(Xdfn, Xmsg, True, IsIcn) Then
      Begin
        WinMsg('', Xmsg);
 {debug94} WinMsg('s', '* * -- * *   - after idmodobj.Getmagpat1.switchtopatient ' + Xdfn + '  result was FALSE');

      End;
            {  fmagMain implements IMagObserver, and calls UpdPatGUIData
              from the _Update procedure  when patient changes.}

    Finally
      FDisablePatSelection := False;
      MnuFile.Enabled := True;
      If (Not idmodobj.GetCCOWManager.CCOWEnabled) Then
      Begin
        Windowsmsg := LastWindowsMessage;
        MsgHandle := LastWindowsMessageHandle;
        LastWindowsMessage := '';
        LastWindowsMessageHandle := 0;
        If Windowsmsg <> '' Then
        Begin
          WinMsg('s',
            'A windows message was recieved while loading patient information and has not been processed, processing VistA Message now');
          Self.ProcessVistAMessage(MsgHandle, Windowsmsg);
        End;
      End;

    End;
  End;
End;

Procedure TfrmMain.UpdateWindowcaption;
Var
  Tmpserver: String;
  NewsObj: TMagNewsObject;
Begin
  If idmodobj.GetMagDBBroker1.IsConnected Then
    Tmpserver := ' (' + idmodobj.GetMagDBBroker1.GetServer + ')'
  Else
  Begin
    Tmpserver := '';
        {   GSess is a TSession object.  It is a Global "G" object to hold variables that
            are used application wide.  Initally it will have the Wrks* variables that
            were being used.   i.e.
            WrksPlaceIEN, WrksPlaceCode,  WrksInst, WrksConsolidated,  WrksInstStationNumber }
        {It is OKAY to clear it here.  We're here if MagDBBroker1 is NOT connected
          so it should be clear.}
    GSess.Clear;
    LocalUserStationNumber := ''; // JMW 7/22/2005 p45t5
    PrimarySiteStationNumber := ''; // JMW 1/24/2007 p46t27

  End;
  caption := FMainCaption + idmodobj.GetMagPat1.M_NameDisplay + Tmpserver;
  PPatinfo2.caption := idmodobj.GetMagPat1.M_Demog;
  PnlSiteCode.caption := GSess.WrksPlaceCODE;
  If (DUZName <> '') Then
    caption := caption + ' in use by :' + MagPiece(DUZName, '^', 2);
  If Doesformexist('frmMagAbstracts') Then
    FrmMagAbstracts.caption := 'Abstracts: ' + idmodobj.GetMagPat1.M_NameDisplay;
  If Doesformexist('frmGroupAbs') Then
    FrmGroupAbs.caption := 'Group Abstracts: ' + idmodobj.GetMagPat1.M_NameDisplay;
  If Doesformexist('frmFullRes') Then
    FrmFullRes.caption := 'Full Resolution View: ' +  idmodobj.GetMagPat1.M_NameDisplay;
  If Doesformexist('frmImageList') Then
  Begin
    FrmImageList.caption := 'Image List: ' + idmodobj.GetMagPat1.M_NameDisplay;
    Begin
      NewsObj := TMagNewsObject.Create;
      NewsObj.Newscode := mpubMessages;
      NewsObj.NewsTopic := mmsgsitecode;
      NewsObj.NewsStrValue := '[ ' + GSess.WrksPlaceCODE + ' ]';
      FrmImageList.MagPublisher1.I_SetNews(NewsObj);
    End;
  End;
End;

Procedure TfrmMain.EdtPatientExit(Sender: Tobject);
Begin
  If idmodobj.GetMagPat1.M_NameDisplay = '' Then
    EdtPatient.Text := '';
  If Not (EdtPatient.Text = idmodobj.GetMagPat1.M_NameDisplay) Then
    EdtPatient.Text := idmodobj.GetMagPat1.M_NameDisplay;
End;

Procedure TfrmMain.MnuRemoteLoginClick(Sender: Tobject);
Begin
  If idmodobj.GetMagDBBroker1.IsConnected Then
    ImagingDisplayLogoff;
    { User selected to Not Logout.}
  If idmodobj.GetMagDBBroker1.IsConnected Then
    Exit;
  AllowRemoteLogin := True;
  ImagingDisplayLogin('', '', False);
End;

Procedure TfrmMain.MnuLoginClick(Sender: Tobject);
Begin
  If idmodobj.GetMagDBBroker1.IsConnected Then
    ImagingDisplayLogoff;
    { User selected to Not Logout.}
  If idmodobj.GetMagDBBroker1.IsConnected Then
    Exit;
  AllowRemoteLogin := False;
  ImagingDisplayLogin('', '', False);
End;

Procedure TfrmMain.ImagingDisplayLogin(Vserver, Vport: String; Forcethisconnection: Boolean);
Var
  Remotechoice: Boolean;
  ConnectMsg, Minutes: String;
  s: String;
  Shares: Tstringlist;
  RPmsg: String;
  Success: Boolean;
  Startmode, i: Integer;
  NewsObj: TMagNewsObject;
  Rmsg: String;
  Rlist: TStrings;
  Rstat: Boolean;
    // JMW p45
   (* vRemoteSitePrefStrings: TStrings; // p93  RemoteSitePreferences : TStrings;
    ServiceURL: string;  *)
  Msg: String; {/ P122 - JK 6/7/2011 /}
Begin
  MnuRIV.Enabled := True;
  Upref.UseGroupAbsWindow := True; {gek Tuscon Issue}
  Upref.UseNewRadiologyWindow := True;
  Upref.LoadStudyInSingleImageFullRes := True;
  DebugFile('procedure TfrmMain.ImagingDisplayLogin: Entered. VServer = ' +
    Vserver + ' , VPort = ' + Vport); {JK 3/11/2009}
  Rlist := Tstringlist.Create;
  Try
      // JMW 1/22/2010 P94T6 - tell CCOW login is not complete and don't do
      // anything until login is done.
    idmodobj.GetCCOWManager.LoginComplete := False;

        // JMW 6/26/08 p72t23 - stupid logic so that when the client logs into a
        // new system, we always reset the preferences for the rad viewer - this
        // really should be done in a better way.
    If Doesformexist('frmRADViewer') Then
            //GEK - This is opposite of other preferences.!
      FrmRadViewer.NewLogin := True;
    WinMsg('s', 'Imaging DisplayLogin  :');
    WinMsg('s', ' -> Server= ' + Vserver + ' Port= ' + Vport);
    WinMsg('s', ' -> Forcing this connection: ' +
      Magbooltostr(Forcethisconnection));
    Duz := '0';
    DUZName := '';
    SecurityKeys.Clear;

    If Forcethisconnection Then
      Remotechoice := False
    Else
      Remotechoice := AllowRemoteLogin;
    If ((Vserver = '') or (Vport = '')) Then
    Begin
            {  Use the server, port defined in INI file.}
      Vserver := IniLocalServer;
      Vport := Inttostr(IniListenerPort);
    End;
    If Remotechoice Then
    Begin
      WinMsg('', 'Connecting to VistA... ');
      If Not idmodobj.GetMagDBBroker1.DBSelect(Vserver, Vport) Then
      Begin { User canceled the VistA Server Selection.}
        WinMsg('', 'No Connection to VistA.');
        Exit;
      End;
    End
    Else
    Begin
      WinMsg('', 'Connecting to ' + Vserver + '... ');
      WinMsg('s', ' -> Server= ' + Vserver + ' Port= ' + Vport);
      If Not idmodobj.GetMagDBBroker1.DBConnect(Vserver, Vport, 'MAG WINDOWS') Then
      Begin
        WinMsg('', 'No Connection to VistA.');
        Exit;
      End;
    End;
    WinMsg('', 'Version Check...');
    CheckImagingVersion(MagappDisplay, idmodobj.GetMagDBBroker1); //59 added the param
    Application.Processmessages;

    If Application.Terminated Then
      Exit;
    WinMsg('', 'Verifying user access...');
        {
        *  --------- Params --------- MAGGUSER2
        * literal	UNKNOWN_UNKnown
        *  --------- Results ---------
        0 * 1^
        1 * 1216^KIRIN,GARRETT EDWARD^GEK
        2 * vhamaster\vhaiswIU^'bAAj&&0+&
        3 * 1
        4 * 1^SLC^660^SALT LAKE CITY^1^660
        5 * 1^1.0T22
        6 * 0
        7 * IMGDEM01.MED.VA.GOV
        8 * 660
        9 * 660
        *  --------- End Results  --------- MAGGUSER2
        }

    idmodobj.GetMagDBBroker1.RPMaggUser2(Rstat, Rmsg, Rlist, Wsid, GSess);
    If Not Rstat Then
    Begin
      WinMsg('DE',
        ': The Attempt to Verify User access,  Failed. Check VistA System Error Log.');
      Exit;
    End;
    Duz := MagPiece(Rlist[1], '^', 1);
    DUZName := MagPiece(Rlist[1], '^', 1) + '^' + MagPiece(Rlist[1], '^', 2);

    {/ P122 - JK 7/5/2011 - add more info to the GSess object. /}
    GSess.UserName := MagPiece(Rlist[1], '^', 2);
    GSess.UserDUZ  := MagPiece(Rlist[1], '^', 1);
    GSess.UserService := idmodobj.GetMagDBMVista1.GetBroker.User.ServiceSection;
    GSess.HasLocalAnnotatePermission := idmodobj.GetMagDBBroker1.RPKernelAnnotatePermission;

    if GSess.HasLocalAnnotatePermission then
//      GSess.SiteAnnotationInfo.Add(GSess.WrksPlaceCODE + '~' + VServer + ':' + VPort + '~Y')
      GSess.SiteAnnotationInfo.Add(GSess.WrksPlaceCODE + '~' + GSess.WrksInstStationNumber + '~' + VServer + ':' + VPort + '~Y')    //p122t6 dmmn 10/14 - add station number for local
    else
//      GSess.SiteAnnotationInfo.Add(GSess.WrksPlaceCODE + '~' + VServer + ':' + VPort + '~N');
      GSess.SiteAnnotationInfo.Add(GSess.WrksPlaceCODE + '~' + GSess.WrksInstStationNumber + '~' + VServer + ':' + VPort + '~N');


    {/ P123 - JK 8/8/2011 - Check what type of backend we're connected to: VA or IHS /}
    GSess.Agency.AgencyID := idmodobj.GetMagDBBroker1.RPMaggAgency;
    MagAppMsg('s', 'Agency is ' + GSess.Agency.AgencyName);

    MagAppMsg('s', 'Annotation Privilege (from the Kernal Parameter) = ' + MagBoolToStr(GSess.HasLocalAnnotatePermission));

    GSess.ROISaveDirectory := GetEnvironmentVariable('HOMEPATH');  {/ P130 - JK 5/6/2012 - initial location to save ROI jobs /}

    If Duz = '0' Then
    Begin
      DUZName := '';
      WinMsg('', MagPiece(Rlist[1], '^', 2) + ' Disconnecting from VistA.');
      idmodobj.GetMagDBBroker1.SetConnected(False);
      Exit;
    End;
    WinMsg('', MagPiece(DUZName, '^', 2) + ': ' + Vserver + ' access is verified. ');

        //    if not SetNetUsernamePassword(rlist[2], idmodobj.GetMagFileSecurity, s)
    If Not idmodobj.GetMagFileSecurity.SetNetUsernamePassword(Rlist[2], s) Then
      WinMsg('de', s)
    Else
      WinMsg('s', s);
    Try
      MuseSite := Strtoint(Rlist[3]);
    Except

      On EConvertError Do
        WinMsg('', 'Error converting MUSE Site  # ' + Rlist[3]);
      On EStringListError Do
        MuseSite := 1;
    Else
      WinMsg('', 'Error accessing MUSE Site #');
    End;
        {   [4] = IMAGE SITE PARAM IEN ^ SITECODE ^ USER INSTITUTION (DUZ(2) ^ SITE PARAM -INSTITUTION NAME
                    ^  Consolidated True/False   ^ STATION NUMBER
                       1  2   3        4        5  6
              example  1^SLC^660^SALT LAKE CITY^1^660      }
    Try
            (*  GSess is set in the RPC Call.  //p93t10
                        GSess.WrksPlaceIEN := magpiece(rlist[4], '^', 1);
                        GSess.WrksPlaceCode := magpiece(rlist[4], '^', 2);
                        GSess.WrksInst := magpiece(rlist[4], '^', 3) + '^' + magpiece(rlist[4], '^', 4);
                        GSess.WrksConsolidated := magstrtobool(magpiece(rlist[4], '^', 5));   *)

      LocalUserStationNumber := GSess.WrksInstStationNumber;
      If LocalUserStationNumber = '' Then
        LocalUserStationNumber := GSess.Wrksinst.ID;
       // JMW 2/15/2011 P117 - do not parse the local user station number, keep the full string
       // and try to use to find the local VIX (might include letters in local station number)
      //LocalUserStationNumber := ParseSiteCode(LocalUserStationNumber);

      idmodobj.GetCCOWManager.IsProdAccount := Magstrtobool(Rlist[8]);

            // JMW P46T27 1/24/2007
            // get the primary sites station number from VistA
            // use the users local station number if not found
      If Rlist.Count > 12 Then
      Begin
        PrimarySiteStationNumber := Rlist[12];
      End;
      If PrimarySiteStationNumber = '' Then
        PrimarySiteStationNumber := LocalUserStationNumber;

            //visn15 added new panel, to display Site Code of User.
      PnlSiteCode.caption := GSess.WrksPlaceCODE;
      PnlSiteCode.Hint := 'Institution: ' + GSess.Wrksinst.Name +
        ' (' + GSess.WrksPlaceCODE + ')';
      If Pmsg <> Nil Then

        WinMsg('s', 'IMAGING SITE PARAMETER: ' + GSess.WrksPlaceIEN + ' Site Code: ' +
          GSess.WrksPlaceCODE);
      WinMsg('s', 'IMAGING SITE PARAMETER Institution: ' + GSess.Wrksinst.Name);
      WinMsg('s', 'CONSOLIDATED SITE : ' + Magbooltostr(GSess.WrksConsolidated));
      WinMsg('s', 'DUZ(2): ' + GSess.Wrksinst.ID);
      WinMsg('s', 'LOCAL USER STATION NUMBER: ' + LocalUserStationNumber);
      WinMsg('s', 'PRIMARY SITE STATION NUMBER: ' + PrimarySiteStationNumber);

            (*
              ServiceURL := '';
              if rlist.Count > 9 then
              begin
                ServiceURL := rlist[9];
              end;
              VistADomain := '';
              if rlist.Count > 10 then
              begin
                VistADomain := uppercase(rlist[10]);
              end;
            *)

    Except
      On Exception Do
      Begin
        GSess.WrksPlaceIEN := '0';
        GSess.WrksPlaceCODE := 'Unk';
      End;
    End;

        {/ P94 JMW 9/30/2009 - get the security token from the local database /}
    gsess.SecurityToken := GetSecurityToken();

        //LogMsg('s', 'Received security token [' + GSess.SecurityToken + '] for this session.', MagLogINFO);
    MagAppMsg('s', 'Received security token [' + GSess.SecurityToken + '] for this session.', MagmsgINFO); {JK 10/5/2009 - Maggmsgu refactoring}

        // check for CP and Patch 7 installed on VistA
    If (Strtoint(MagPiece(Rlist[5], '^', 1)) > 0) Then
      mainEnableCPFunctions;
    UpdateWindowcaption;

    EdtPatient.Text := '';
    If CprsStartedME Then
      Startmode := 2
    Else
      Startmode := 1;
    idmodobj.GetMagDBBroker1.RPMaggWrksUpdate(AppPath, Application.ExeName, '',
      WrksCompName, WrksLocation, LastMagUpdate, Startmode);
        {  Need to research the possible errors in GetSetUserPrefs, for branching
           logic in the except.   But anycase we don't want to stop on Upref error.}
    Try
      GetSetUserPreferences;
      Self.MnuSaveSettingsonExit.Checked := Upref.SaveSettingsOnExit;
      FrmImageList.MnuSaveSettingsonExit1.Checked :=
        Upref.SaveSettingsOnExit;
    Except
            //
    End;

        { If user LogsOff then LogsIN, we need to do this again.{}
        { gets settings from INI.  (on startup, it will be done twice ? ) {}
    LoadWSSettings;
    WinMsg('', 'Connected to : ' + idmodobj.GetMagDBBroker1.GetServer + ' ' +
      Inttostr(idmodobj.GetMagDBBroker1.GetListenerPort));
    LogActions('MAIN', 'LOGIN', Duz);
    WarnResources('');

    GetUsersSecurityKeys;
    if GetINIEntry('Dev-Testing','AllowAnyResolution') = 'TRUE' then {p161}
    begin
    AddDelKey('TEMP NO RESTRICT',TRUE);
    GNoRestrictView := TRUE;
    end;
    
{ RCA, GEK move maglogger referenc from UmagKeyMgr.  uMagKeyMgr doesn't know about maggmsgu anymore.  }
 {Set the MagLogger privilege level based on the Mag System key}
  If Userhaskey('MAG SYSTEM') Then
    MagDisplayMsg.SetPrivLevel(magmsgprivAdmin)
  Else
    MagDisplayMsg.SetPrivLevel(magmsgprivUser);

    {/ P122 JK 7/11/2011 /}
    if UserHasKey('MAG ANNOTATE MGR') then
    begin
      GSess.HasLocalAnnotateMasterKey := True;
      GSess.SiteAnnotationInfo[0] := GSess.SiteAnnotationInfo[0] + '~Y';
    end
    else
    begin
      GSess.HasLocalAnnotateMasterKey := False;
      GSess.SiteAnnotationInfo[0] := GSess.SiteAnnotationInfo[0] + '~N';
    end;

    {/ P122 - JK 10/4/2011 /}
    GSess.SiteAnnotationInfo[0] := GSess.SiteAnnotationInfo[0] + '~' + DUZ;


        //self.mainInitializeKeyDependentObjects;
        {   This will make it so that the user doesn't have to enter Esig for print or Copy}
        //AddDelKey('TMP MAG ESIG',true);   // GEK Keep.

        {JK 4/20/2009 - hide abstract window if viewing in MAG PAT PHOTO ONLY mode}
        //IF USER IS ONLY INTERESTED IN LOCAL SITE, WE SET REMOTEBROKERMANAGER TO NIL
    If Userhaskey('MAG PAT PHOTO ONLY') Then
    Begin
      If Not Userhaskey('MAG SYSTEM') Then
        ShowAbstractWindow(False);
    End
    Else
    Begin

            { The UprefTo....Window functions need to be refactored.   They cause too much
               coupling between Main and all other forms.
                - Have a Publish, Subscribe style pattern.  Publisher notifies all
                  Subscribers of initial Upref at startup, then Subscribers can Querry
                  Publisher for a specific Preference.  i.e. The Abstract window would
                  querry the Preference Publisher when it was opened for 'ABS' preferences.
                  ** This is also better because each window,object etc, could do it
                     individually.  Now all are done at same time.}
      UprefToMainwindow(Upref);
      UprefToFullView(Upref);
      If Upref.AbsShowWindow Then
        ShowAbstractWindow;
      UprefToGroupWindow(Upref);
      UprefToImageListWin(Upref);
    End;

    mainInitializeKeyDependentObjects;

        { Get List of network locations and attributes and send them
             to the security component - SAF 2/16/2000 }
    Shares := Tstringlist.Create;
    idmodobj.GetMagDBBroker1.RPMagGetNetLoc(Success, RPmsg, Shares, 'ALL');
    idmodobj.GetMagFileSecurity.ShareList := Shares;
    Shares.Free;

        {  IF USER IS ONLY INTERESTED IN LOCAL SITE, WE SET REMOTEBROKERMANAGER TO NIL}
    If Userhaskey('MAG PAT PHOTO ONLY') Then
    Begin
      If Not Userhaskey('MAG SYSTEM') Then
      Begin
        MagRemoteBrokerManager1 := Nil;
        DoPatPhotoOnly;
        Exit;
      End
      Else
        MnuTestPatOnlyLookup1.Visible := True;
    End;
        {   Terminate the Application if User doesn't have either MAGDISP CLIN
            or MAGDISP ADMIN}
    If Not HasImagingKeys Then
    Begin
      NoKeyAbortMessage;
      Application.Terminate;
      Exit;
    End;
    FrmImageList.RefreshAllFilters;
    FrmImageList.SetDefaultImageFilter(Upref.ImageListDefautFilter);
    If (WorkStationTimeout = 0) Then
      idmodobj.GetMagDBBroker1.RPMaggGetTimeout('DISPLAY', Minutes);

    If Minutes <> '' Then
      MagTimeoutform.SetApplicationTimeOut(Minutes, TimerTimeout);

        (*   Get Shares was here.. 93t10 moved so that Photo Only can be called
             before check for Imaging Keys  .. MAGDISP CLIN etc.*)
    If (Assigned(EKGDisplayForm)) Then
      EKGDisplayForm.ServerChanged();
        //which one do i use ?
            //59
    WinMsg('s', 'Kernel Broker RPCTimeLimit=' + Inttostr(idmodobj.GetMagDBBroker1.GetBroker.RPCtimelimit));

    SetRemoteSettings(Rlist);

        {   set the cache directory for the image manager}
    MagImageManager1.CacheDirectory := ImageCacheDirectory;
    // JMW 6/25/2013 set the location where stylesheets are stored to copy to cache folders
    MagImageManager1.StylesheetsDirectory := ExtractFilePath(Application.ExeName) + '\stylesheets';
    TbtnRIVConfigure.Enabled := True;
        // enable the RIV configuration button since the user is connected
        {   tell the CCOW manager that the login process has completed (all RPC's run)}
    idmodobj.GetCCOWManager.LoginComplete := True;
    idmodobj.GetCCOWManager.ResumeGetContext();

    MnuRIV.Enabled := True;
    Upref.UseGroupAbsWindow := True;
    Upref.UseNewRadiologyWindow := True;
    Upref.LoadStudyInSingleImageFullRes := True;

//    {/ P122 - JK 6/7/2011 - Load Annotation user preferences /}
//    Msg := AnnotationOptions.LoadUserAnnotPreferences(Upref.ArtXSettingsDisplay);
//    if Msg <> '' then
//      MagLogger.LogMsg('s', 'Cannot load Annotation User Preferences: ' + Msg);
    {/p122 dmmn 7/9/11 }
//    AnnotationOptionsX.UserPreferences := Upref.ArtXSettingsDisplay;

  Finally {JK 3/11/2009 - set focus must be for a visible object}
    Rlist.Free;
    If Frmmain.Visible Then
    Begin
      Try
        If EdtPatient.Enabled And EdtPatient.Visible Then
          EdtPatient.SetFocus;
      Except
        On e: Exception Do
          DebugFile('procedure TfrmMain.ImagingDisplayLogin: Handled EXCEPTION = '
            + e.Message); {JK 3/11/2009}
      End;
    End;
    DebugFile('procedure TfrmMain.ImagingDisplayLogin: Exiting');
  End;
End;

Procedure TfrmMain.UprefToMainwindow(Var Upref: Tuserpreferences);
Begin
  WinMsg('s', 'In UpreftoMainWindow');
  If Not Upref.Getmain Then
    Exit;
  Frmmain.PToolbar.Visible := Upref.Maintoolbar;
  Frmmain.MnuToolbar.Checked := Upref.Maintoolbar;
  WinMsg('s', 'MagSetBounds frmMain T: ' + Inttostr(Self.Top) + ' L: ' + Inttostr(Self.Left));

  Magsetbounds(Frmmain, Upref.Mainpos);
  WinMsg('s', 'MagSetBounds frmMain T: ' + Inttostr(Self.Top) + ' L: ' + Inttostr(Self.Left));

  Frmmain.MnuSaveSettingsonExit.Checked := Upref.SaveSettingsOnExit;
    //02/10/2003
  Frmmain.MnuMainHint.Checked := Upref.Mainshowhint;
  WinMsg('s', 'Ending Upref to Mainwindow.');
End;

Procedure TfrmMain.SetRemoteSettings(Settingslist: TStrings);
Var
  VRemoteSitePrefStrings: TStrings; // p93  RemoteSitePreferences : TStrings;
  ServiceURL: String;
  VAppstartmode: Integer;
Begin

  If CprsStartedME Then
    VAppstartmode := 2
  Else
    VAppstartmode := 1;

  ServiceURL := '';
  If Settingslist.Count > 9 Then
  Begin
    ServiceURL := Settingslist[9];
  End;
  VistADomain := '';
  If Settingslist.Count > 10 Then
  Begin
    VistADomain := Uppercase(Settingslist[10]);
  End;

    // THIS CODE SHOULD PROBABLY BE MOVED FURTHER DOWN, CLOSER TO THE END OF THE LOGIN PROCESS.
  VRemoteSitePrefStrings := Tstringlist.Create();
    {
    RIVAutoConnectEnabled := true;
    ConnectVISNOnly := false;
    HideEmptySites := false;
    HideDisconnectedSites := false;
    }
    // should make an RPC call to get the remote site preferences.

    //vRemoteSitePrefStrings.Add('688^Washington, DC^N');
    //vRemoteSitePrefStrings.Add('402^Togus, ME^A'); // this doesn't work yet
    // setting always connect will not work right now because we need to have the user's SSN, DUZ and name (DUZ and name happen later)

    // JMW 7/22/2005 p45t5 retrieve the network location for the Site Service.
    // check to see if the user disabled the service in their Mag308.ini file
  If MagRemoteBrokerManager.IsRIVEnabled() Then
  Begin
    MagRemoteBrokerManager.RIVEnabled := False;
    If ServiceURL <> '' Then
    Begin
      MagRemoteBrokerManager.RIVEnabled := True;
      MagRemoteBrokerManager.SiteServiceURL := Lowercase(ServiceURL);
            // VistASiteServiceURL.Strings[0];
    End;
  End;
    {
    // use this part for testing on servers before p45t5
MagRemoteBrokerManager.RIVEnabled := true;
MagRemoteBrokerManager.SiteServiceURL := 'http://vhaann26607.v11.med.va.gov/VistaWebSvcs/SiteService.asmx';
     }
  WinMsg('s', 'Remote Image Views Enabled=' +
    BoolToStr(MagRemoteBrokerManager.IsRIVEnabled()));

    // JMW 3/29/2005 p45
    // the following lines of code should possibly be moved, currently they get
    // executed everytime a connection is made, should probably be done only once.
    // currently it seems to work, but perhaps should be investigated.
  Magremoteinterface.RIVInitialize();

    // initialize the RemoteBrokerInterface (used for context management)
  MagRemoteBrokerManager.Initialize(Wsid, AppPath, Application.ExeName, '',
    WrksCompName, WrksLocation, LastMagUpdate, VAppstartmode,
    VRemoteSitePrefStrings, idmodobj.GetMagDBBroker1.GetListenerPort(),
    UMagAppMgr.GetSecurityToken, idmodobj.GetMagDBBroker1.RPMagLogCapriRemoteLogin,
    magRemoteAppDisplay
          {, RIVAutoConnectEnabled, ConnectVISNOnly});
    // initialize the remote broker manager
//    MagRemoteBrokerManager1.OnLogEvent := idmodobj.GetMagLogManager.LogEvent; {JK 10/6/2009 - Maggmsgu refactoring}
    // JMW 3/18/2007 p72 - Add the keep alive broker thing to the listener to get events
  RIVAttachListener(idmodobj.GetMagBrokerKeepAlive);
    // JMW 5/8/08 P72 set property that determines if user can connect to DOD sites
    // JMW 1/12/10 P94 - allow all users access to DoD images regardless of key
  MagRemoteBrokerManager1.AllowedDODSites := True; //(AllowDODSites) or
//        (UserHasKey('MAG VIEW DOD IMAGES'));
    {/ P94 JMW 10/20/2009 - set block VIX value /}
  MagRemoteBrokerManager1.BlockVixVASites := BlockVixVASites;

    //LogMsg('', 'DoD Sites Allowed: ' +
    //    booltostr(MagRemoteBrokerManager1.AllowedDODSites), MagLogINFO);
 //RCA Out MagLogger.LogMsg('', 'DoD Sites Allowed: ' +  BoolToStr(MagRemoteBrokerManager1.AllowedDODSites), MagLogINFO); {JK 10/5/2009 - Maggmsgu refactoring}

  MagAppMsg('', 'DoD Sites Allowed: '
                +  BoolToStr(MagRemoteBrokerManager1.AllowedDODSites), magmsgINFO);

    //fMagRemoteToolbar1.RIV Attach_();
  RIVAttachListener(FrmImageList.FMagRemoteToolbar1);
  FrmImageList.FMagRemoteToolbar1.SetUserPreferences(VRemoteSitePrefStrings
        {, RIVAutoConnectEnabled, ConnectVISNOnly, HideEmptySites, HideDisconnectedSites});

    //RIV Attach_();
  RIVAttachListener(Self);

End;

Procedure TfrmMain.MnuLogoutClick(Sender: Tobject);
Begin
  ImagingDisplayLogoff;
End;

Procedure TfrmMain.ImagingDisplayLogoff;
Var
  s, Server: String;
  NewsObj: TMagNewsObject;
Begin
  If Not (idmodobj.GetMagDBBroker1.IsConnected) Then
    WinMsg('d', 'Connection to VistA is not Active')
  Else
  Begin
    Server := idmodobj.GetMagDBBroker1.GetServer;
    s := 'You are connected to: ' + Server + #13 +
      'Do you want to Logout ?';
    If Messagedlg(s, Mtconfirmation, [MbYes, MbNo], 0) = MrNo Then
      Exit;
  End;

  TbtnRIVConfigure.Enabled := False;
    // JMW 4/22/2005 p45 - disable the RIV configuration, do we like making buttons disabled?
  MnuRIV.Enabled := False;
  If MnuSaveSettingsonExit.Checked Then
    Saveusersettings;
  MagImageManager1.StopCache(); // JMW P72 - stop the cache on a logout!
  idmodobj.GetMagDBBroker1.RPMaggLogOff;
  MagPatMenu.ClearAll;
  FrmImageList.MagPatMenu.ClearAll;
  GSess.Clear;
  PnlSiteCode.caption := '';

  PnlSiteCode.Hint := '';

  {/ P117 - JK 8/30/2010 /}
  CloseMagReportMgrWin;

    // JMW P46T27 1/24/2007 reset station number values
  LocalUserStationNumber := '';
  PrimarySiteStationNumber := '';

  UpdateWindowcaption;
  Application.Processmessages;
    { TODO -c2:  research into this. Old way was destroying then creating a TRPCBroker.
                                               New way isn't ?   any problems with this. }
  idmodobj.GetMagDBBroker1.CreateBroker;

    // This is duplicated in uMagDisplayMgr   P8T45
    //idmodobj.GetMagDBSysUtils1.Broker := idmodobj.GetMagDBBroker1.GetBroker;
  MagPatMenu.ClearAll;
  FrmImageList.MagPatMenu.ClearAll;
  idmodobj.GetMagPat1.Clear;
  WinMsg('', ' Logout:  VistA disconnected');
  LogActions('LOGOUT', '', Duz);
  Duz := '0';
  DUZName := '';
  UpdateWindowcaption;
  SecurityKeys.Clear;
  FrmImageList.ClearAllFilters;
  FrmImageList.ClearPat;
  mainInitializeKeyDependentObjects; {in Procedure : ImagingDisplayLogoff()}
  EdtPatient.Text := '';

End;

Procedure TfrmMain.Exit1Click(Sender: Tobject);
Begin
  Close;
End;

(*procedure TfrmMain.LogMsgList(ts: Tstrings);
var i: integer;
begin
  exit;
  for i := 0 to ts.count - 1 do WinMsg('S', ts[i]);

end;
  *)

Procedure TfrmMain.WinMsg(c, s: String);
Var
  NewsObj: TMagNewsObject; {JK 6/5/2009}
Begin
  If Application.Terminated Then Exit;
  // application.processmessages;

  //  then   // 94t10  was getting access violations on terminate.  It was looking for QueMsgList.count
  //                              in MAGGMSGF, which shouldn't exist,  but does....
(*
  if DoesFormExist('MaggMsgf') then
  begin
    while QueMsglist.count > 0 do
    begin
      //MaggMsgf.magmsg(magpiece(QueMsglist[0], '~', 1),
      //    magpiece(QueMsglist[0], '~', 2), pmsg);
      MagLogger.MagMsg(magpiece(QueMsglist[0], '~', 1),
           magpiece(QueMsglist[0], '~', 2), pmsg);  {JK 10/5/2009 - Maggmsgu refactoring}
      // JMW 5/13/08 P72 - don't need to do this log event below, it just ends
      // up calling the one above. Eventually want to not use the log event above but can't
      // do that until we can handle using the proper pannel to display the message (when needed)
      //          LogMsg(magpiece(QueMsglist[0], '~', 1), magpiece(QueMsglist[0], '~', 2));
      QueMsglist.delete(0);
    end;
  end
  else
  begin
    QueMsgList.add(c + '~' + s);
    Exit;
  end;    *)

  //MaggMsgf.magmsg(c, s, pmsg);
  MagAppMsg(c, s) ; // Pmsg); {RCA  pmsg no longer supported by interface}

  {/ P130 - JK 9/19/2012 /}
  if c = '' then
    pmsg.Caption := s;
    pmsg.Update;

  {JK 6/5/2009 - Use Publisher/Subscriber technique to feed messages to the Image List form}
  Try
    Try
      If Pmsg <> Nil Then
      Begin
        NewsObj := TMagNewsObject.Create;
        NewsObj.Newscode := mpubMessages;
        NewsObj.NewsTopic := mmsgpublish;
        NewsObj.NewsStrValue := '[ ' + PnlSiteCode.caption + ' ]   ' + Pmsg.caption;
        If FrmImageList <> Nil Then {JK 10/5/2009 - added check for frmImageList not being nil}
          FrmImageList.MagPublisher1.I_SetNews(NewsObj);
      End;
    Except
      On e: Exception Do
        Showmessage('TfrmMain.WinMsg exception = ' + e.Message);
    End;
  Finally
//RCA this was only place that was 'Free' ing the NewsObj.
//      We're trying a FreeandNil in cMagPub... now.
//    NewsObj.Free;

   // RCA tryied  freeandNil instead of Free, but both give list index out
    // of bounds if this is freeAndNil in cMagPublishSubscribe
  End;
  // see above for reason to not do this here
  //  LogMsg(c, s);
End;

Procedure TfrmMain.MnuToolbarClick(Sender: Tobject);
Begin
  MnuToolbar.Checked := Not MnuToolbar.Checked;
  If MnuToolbar.Checked Then
    PToolbar.Show
  Else
    PToolbar.Hide;
  ResizePMain;
  ForceRepaint;
End;

Procedure TfrmMain.MnuImageListClick(Sender: Tobject);
Begin
  FormToNormalSize(FrmImageList);
    //not in 93   frmMain.Hide;
End;

Procedure TfrmMain.MnuPatientProfileClick(Sender: Tobject);
Begin
  idmodobj.GetMagUtilsDB1.OpenPatientProfile;
End;

Procedure TfrmMain.MnuRadiologyExamsClick(Sender: Tobject);
Begin
  LoadRadListWin;
End;

Procedure TfrmMain.LoadRadListWin;
Var
  Rmsg, s: String;
  Rlist: TStrings;
  Rstat: Boolean;
Begin
  If (idmodobj.GetMagPat1.M_DFN = '') Then
  Begin
    WinMsg('d', 'You must Select a Patient.');
    Exit;
  End;
  WinMsg('', 'Compiling ' + idmodobj.GetMagPat1.M_NameDisplay +
    ' Radiology Exams...');
  idmodobj.GetMagDBBroker1.RPMaggRadExams(Rstat, Rmsg, TRadList, idmodobj.GetMagPat1.M_DFN);
    //  Have to apply the Fake Name switch here too.
  If idmodobj.GetMagPat1.M_UseFakeName Then
  Begin
    MagReplaceString(idmodobj.GetMagPat1.M_PatName, idmodobj.GetMagPat1.M_NameDisplay,
      Rmsg);

    {/ P122 with P123 patient ID additions - JK 8/11/2011 /}
    if GSess.Agency.IHS then
    begin
      MagReplaceString(idmodobj.GetMagPat1.M_SSN, '000000', Rmsg);
      MagReplaceString(idmodobj.GetMagPat1.M_SSNdisplay, '000000', Rmsg);
    end
    else
    begin
      MagReplaceString(idmodobj.GetMagPat1.M_SSN, '000000000', Rmsg);
      MagReplaceString(idmodobj.GetMagPat1.M_SSNdisplay, '000-00-0000', Rmsg);
    end;
  End;

  {/ P130 - JK 12/17/2012 - Removing this for TFS Issue 52806 - see code below
     for the what is modified from this issue /}
//  If Not Rstat Then
//  Begin
//    WinMsg('de', Rmsg);
//    Exit;
//  End;

  If Not Doesformexist('RadListWin') Then
  Begin
    Application.CreateForm(Tradlistwin, Radlistwin);
        //59 radlistwin := tRadListWin.create(self);
    UprefToRadListWin(Upref);
  End
  Else
    Radlistwin.Clear;

  Radlistwin.DFN.Text := '';

  Radlistwin.Pinfo.Show;
  If idmodobj.GetMagPat1.M_UseFakeName Then
  Begin
    s := TRadList[0];
    MagReplaceString(idmodobj.GetMagPat1.M_PatName, idmodobj.GetMagPat1.M_NameDisplay, s);

    {/ P122 with P123 patient ID additions - JK 8/11/2011 /}
    if GSess.Agency.IHS then
    begin
      MagReplaceString(idmodobj.GetMagPat1.M_SSN, '000000', s);
      MagReplaceString(idmodobj.GetMagPat1.M_SSNdisplay, '000000', s);
    end
    else
    begin
      MagReplaceString(idmodobj.GetMagPat1.M_SSN, '000000000', s);
      MagReplaceString(idmodobj.GetMagPat1.M_SSNdisplay, '000-00-0000', s);
    end;

    TRadList[0] := s;
  End;
  Radlistwin.Pinfo.caption := MagPiece(TRadList[0], '^', 2);

  {/ P130 - JK 12/17/2012 - Modified code for TFS Issue 52806 - added an
     if/then/else to always put up the Radiology exam screen (when the user
     preference calls for it. However instead of putting up a modal message
     dialog, it puts up a non-modal radiology viewer that is empty. /}
  If Not Rstat Then
  Begin
    WinMsg('ce', Rmsg); {/ P130 - changed from "de" to "ce" /}
    FormToNormalSize(Radlistwin);
    Radlistwin.Show;
    Radlistwin.caption := 'Radiology Exam listing  : ' +
      idmodobj.GetMagPat1.M_NameDisplay;
    Radlistwin.DFN.Text := idmodobj.GetMagPat1.M_DFN;

    {/ P130 - stuff in the header titles to initialize the string grid columns.
       When opening Display, if the first patient who is opened
       happens to not have radiology exams, the column header of the control
       is collapsed unless first primed with the header data below. /}
    Radlistwin.Stg1.Cells[0,0] := '#';
    Radlistwin.Stg1.Cells[1,0] := 'Day Case';
    Radlistwin.Stg1.Cells[2,0] := 'Procedure';
    Radlistwin.Stg1.Cells[3,0] := 'Exam Date';
  end
  else
  begin

    TRadList.Delete(0);
    Listtoradlistwin;

    Radlistwin.caption := 'Radiology Exam listing  : ' +
      idmodobj.GetMagPat1.M_NameDisplay;
    Radlistwin.DFN.Text := idmodobj.GetMagPat1.M_DFN;
  end;

  FormToNormalSize(Radlistwin);
  Radlistwin.Show;
  Radlistwin.Sizethecolumns;
End;

{/p94t3 gek 11/30/09 decouple fmagmain from ... radexamlistwin  in shared.}
(*
procedure TfrmMain.RadExamImagesToGroup(Radstring: string);
var
    t: tstringlist;
    daycase: string;
    sysradstring: string;
    magien: string;
    rmsg: string;
    rstat: boolean;
begin
    WinMsg('', 'Checking Exam  : ' + magpiece(radstring, '^', 3) +
        '  for Images...');
    t := tstringlist.create;
    try
        daycase := magpiece(radstring, '^', 2);
        sysradstring := daycase + ' - ' + magpiece(radstring, '^', 3) + ' - ' +
            magpiece(radstring, '^', 4)
            + ' - RARPT: ' + magpiece(radstring, '^', 16);
        LogActions('RADEXAM', 'IMAGES', daycase);

        idmodobj.GetMagDBBroker1.RPMaggRadImage(rstat, rmsg, t, radstring);
        if not rstat then
        begin
            if magpiece(t[0], '^', 1) = '-2' then
                WinMsg('DEQA', rmsg)
            else
                winmsg('de', rmsg);
            winmsg('s', 'Rad Report info : ' + sysradstring);
            exit;
        end;
        WinMsg('', magpiece(t[0], '^', 1) + ' ' + magpiece(t[0], '^', 2));
        magien := magpiece(t[0], '^', 5);
        t.delete(0);
        {-------------------------------}
        if not DoesFormExist('frmGroupAbs') then
            upreftogroupwindow(upref);
        frmGroupAbs.visible := true;
        try
            frmGroupAbs.SetInfo('Radiology Exam, Images -- ' +
                frmMain.edtPatient.Text,
                '  ' + MagPiece(Radstring, '^', 2)
                + '  ' + MagPiece(Radstring, '^', 3) + ' '
                + MagPiece(Radstring, '^', 4)
                + '  ' + inttostr(t.count) + '  Images',
                '', magien,
                MagPiece(Radstring, '^', 2)
                + '  ' + MagPiece(Radstring, '^', 3) + ' '
                + MagPiece(Radstring, '^', 4));
            frmGroupAbs.magImageList1.LoadGroupList(t, '', '');
            frmGroupAbs.Show;
        except
            on e: exception do
            begin
                showmessage('exception : ' + e.message);
                frmGroupAbs.FGroupIEN := '';
            end;
        end;
        {------------------------}
    finally
        t.free;
    end;

end;    *)
{ DONE -c93+ : Get this type of function OUT OF HERE !!.  Put It In a Utilitites Unit (done in 94t3). }

Procedure TfrmMain.Patientphoto;
Var
  t: Tstringlist;
Begin
    { TODO -c5?: change this.  We're calling this when form is Notified by
       a call to Update_ that the patient has changed.  We are making the panel,
       that the TMagPatPhoto component is on, visible/invisible.
          The TMagPatPhoto Component should have a property, MakeInvisibleOnNull
          ( or something like that )}
  t := Tstringlist.Create;
  Try
    If Not idmodobj.GetMagDBBroker1.RPMaggGetPhotoIDs(FMagpat.M_DFN, t) Then
    Begin
      PnlPatPhoto.Visible := False;
      Exit;
    End;
    If (idmodobj.GetMagUtils1.MagPiece(t[0], '^', 3) = '') Then
      PnlPatPhoto.Visible := False
    Else
      PnlPatPhoto.Visible := True;
  Finally
    t.Free;
  End;
End;

Procedure TfrmMain.MnuViewPrefercencesClick(Sender: Tobject);
Begin
  OpenUprefWindow;
End;

Procedure TfrmMain.MnuSaveSettingsOnExitClick(Sender: Tobject);
Begin
    {this menu is AutoChecked, we also need to check the frmImageListmenu}
  FrmImageList.MnuSaveSettingsonExit1.Checked :=
    MnuSaveSettingsonExit.Checked;
End;

Procedure TfrmMain.MnuSaveSettingsNowClick(Sender: Tobject);
Begin
  Saveusersettings;
End;

{-------------    procedure TfrmMain.SaveUserSettings;    -----------}
 {TODO -C93+: We need to get all User Preferences code out of the forms and
            into a unit elsewhere.}
 { TODO -cRefactor :
  The User Pref mechanism needs changed:  We need to use Subject Observer pattern.
     The forms can get notified when they need to apply user prefs.
  Also, forms need a Function that returns their current user preferences... or to set the
    userpreferences object with the current settings. }
 { TODO -oanyone -crefactor :
There's got to be an easier way. Deferred to later patch P125876
 See Publish - Subscribe, or reverse of Subject Observer. }

    { The Upref object isn't kept current as the application runs.  Some Upref
     properties are kept up to date during the session, but you can't depend on
     all being current. The whole Upref Object is set here, before the call
      to VistA to save settings. }

Procedure TfrmMain.Saveusersettings;
Var
  ai: Integer;
  St: String[60];
  x, i: byte;
  Stbar: Char;
  Rpcstat: Boolean;
  tmpbool: Boolean;
  Rpcmsg: String;
  aFont, Gfont, Fullfont: String[10];
  Preflist: TStrings;
Begin
  try
  Preflist := Tstringlist.Create;

    {   ImageList window Upref settings: "LISTWIN1"}
  Preflist.Add('"LISTWIN1"|' +
    Magbooltostrint(FrmImageList.GetAbsPreview)
    + '^' + Magbooltostrint(FrmImageList.GetRptPreview)
    + '^' + GetCurrentFilter.FilterID // ID or NAME ???
    + '^' + Magbooltostrint(FrmImageList.PnlFilterTabs.Visible) //   mnuFiltersasTabs1.checked)
    + '^' + Magbooltostrint(FrmImageList.TabCtrlFilters.Multiline)); //mnuMultiLineTabs1.checked));

    {   App Preferences misc Upref settings: "APPPREFS"}
  aFont := '';
  Gfont := '';
  If Doesformexist('frmMagAbstracts') Then
    aFont := Inttostr(FrmMagAbstracts.Mag4Viewer1.ImageFontSize);
  If aFont = '0' Then
    aFont := '';
  If Doesformexist('frmGroupAbs') Then
    Gfont := Inttostr(FrmGroupAbs.Mag4Viewer1.ImageFontSize);
  If Gfont = '0' Then
    Gfont := '';
  If Doesformexist('frmFullRes') Then
    Fullfont := Inttostr(FrmFullRes.Mag4Viewer1.ImageFontSize);
  If Fullfont = '0' Then
    Fullfont := '';
    // idmodobj.GetMagDBBroker1.Broker.Param[1].MULT['"APPPREFS"']
  Preflist.Add('"APPPREFS"|' +
    Magbooltostrint(MnuSaveSettingsonExit.Checked)
    + '^' + aFont + '^' + Gfont + '^' + Fullfont + '^' +
    Upref.DispReleaseNotes
    + '^' + Magbooltostrint(Upref.UseAltViewerForVideo)
    + '^' + Magbooltostrint(Upref.PlayVideoOnOpen)
    + '^' + Magbooltostrint(Upref.UseAltViewerForPDF)
    + '^' + MagBoolToStrint(upref.UseDelImagePlaceHolder)      //p117
    + '^' + MagBoolToStrint(upref.SuppressPrintSummary));      //p117
    ;

    //Patch 72, new User Preferences :
      {UseAltViewerForVideo
       PlayVideoOnOpen
       UseAltViewerForPDF }

    {   Main Window Upref settings: "MAIN"}
  Upref.Mainstyle := 2;

  Upref.Mainpos.Left := Frmmain.Left;
  Upref.Mainpos.Top := Frmmain.Top; { top,  left , right, bottom  }
  Upref.Mainpos.Right := Frmmain.Width;
  Upref.Mainpos.Bottom := Frmmain.Height;
  If Frmmain.PToolbar.Visible Then
    Stbar := '1' // upref.maintoolbar := TRUE
  Else
    Stbar := '0'; //upref.maintoolbar := FALSE;

    //  idmodobj.GetMagDBBroker1.Broker.Param[1].MULT['"MAIN"'] :=
  Preflist.Add('"MAIN"|' + Inttostr(Upref.Mainstyle)
    + '^' + Inttostr(Upref.Mainpos.Left) + '^' + Inttostr(Upref.Mainpos.Top)
    + '^' + Inttostr(Upref.Mainpos.Right) + '^' +
    Inttostr(Upref.Mainpos.Bottom)
    + '^' + Stbar + '^' + Magbooltostrint(ShowHint));

    {   Main "0" node Upref settings: "0" }
    {^MAG(2006.18,D0,0)= (#.01) DESCRIPTION [1F] ^ (#1) USER [2P] ^ (#2) ABS COUNT
                     ==>[3N] ^ (#3) GROUP ABS COUNT [4N] ^ (#51) REMOTE CONNECT
                     ==>[F UTURE USE] [5S] ^ (#52) VIEWJBOX IMAGES [6S] ^ (#53)
                     ==>REVERSE ORDER [7S] ^}

  St := '^^^^'; //piece 1 thru 4

    {Piece 1-4:  are "", not used here.  These are old settings that have been moved

     Piece 5  :   always 0 (not used )
     Piece 6  :   view jukebox images always false, this is because of slow speed of
                 loading jukebox abstracts
     Piece 7  :   reverse order of abstracts is always true.  Other setting was
                 confusing users.}

  St := St + '0^'; //piece 5

  St := St + '0^'; //P8T14 piece 6
  Upref.AbsRevOrder := True;
  St := St + '1^'; // P8T21  piece 7 always reverse order.
  {this is used to determine if user wants to view remote abstracts.   In a consolidate site
    this could be False.  Especially if each site has own Image Servers.}
  If Upref.AbsViewRemote Then // piece 8 (not defined  ? )
    St := St + '1^'
  Else
    St := St + '0^';

    { TODO -c5: Check if we should continue to set these CPRS User preferences. }
   (* P48T5  we'll stop sending these, we dont' use them. *)
   (*    if CPRSSync.Queried then st := st + '1^' else st := st + '0^';
         if CPRSSync.SyncOn then st := st + '1^' else st := st + '0^';
         if CPRSSync.PatSync then st := st + '1^' else st := st + '0^';
         if CPRSSync.PatSyncPrompt then st := st + '1^' else st := st + '0^';
        idmodobj.GetMagDBBroker1.Broker.Param[1].MULT['"0"'] := st;    *)

  Preflist.Add('"0"|' + St);

    {    Abstracts window Upref settings: "ABS"}
  If Doesformexist('frmMagAbstracts') Then
  Begin
    Upref.AbsShowWindow := FrmMagAbstracts.Visible;
    Upref.AbsStyle := 2;
    Upref.AbsPos.Left := FrmMagAbstracts.Left;
    Upref.AbsPos.Top := FrmMagAbstracts.Top; { top,  left , right, bottom  }
    Upref.AbsPos.Right := FrmMagAbstracts.Width;
    Upref.AbsPos.Bottom := FrmMagAbstracts.Height;
    Upref.AbsHeight := FrmMagAbstracts.Mag4Viewer1.LockHeight;
    Upref.AbsWidth := FrmMagAbstracts.Mag4Viewer1.LockWidth;

    Upref.AbsToolBar := FrmMagAbstracts.Mag4Viewer1.TbViewer.Visible;
    Upref.AbsCols := FrmMagAbstracts.Mag4Viewer1.ColumnCount;
    Upref.AbsMaxLoad := FrmMagAbstracts.Mag4Viewer1.MaxCount;
    Upref.AbsRows := FrmMagAbstracts.Mag4Viewer1.RowCount;
    Upref.AbsLockSize := FrmMagAbstracts.Mag4Viewer1.LockSize;
    Upref.AbsToolBarPos :=
      MagBoolToInt(FrmMagAbstracts.Mag4Viewer1.TbViewer.Align = alLeft);
        {
       ^MAG(2006.18,D0,ABS)= (#9) ABS STYLE [1S] ^ (#10) ABS LEFT [2N] ^ (#11) ABS
                          ==>TOP [3N] ^ (#12) ABS WIDTH [4N] ^ (#13) ABS HEIGHT [5N]
                          ==>^ (#37) ABS IMAGE WIDTH [6N] ^ (#38) ABS IMAGE HEIGHT
                          ==>[7N] ^ (#49) ABS SHOW [8S] ^ (#148) ABS TOOLBAR [9N] ^

                          ==>(#137) ABS COLS [10N] ^ (#138) ABS MAXLOAD [11N] ^
                          ==>(#152) ABS ROWS [12N] ^ (#156) ABS LOCKSIZE [13N] ^
       }
  End
  Else
    Upref.AbsShowWindow := False;

  Preflist.Add('"ABS"|' +
    Inttostr(Upref.AbsStyle)
    + '^' + Inttostr(Upref.AbsPos.Left) + '^' + Inttostr(Upref.AbsPos.Top)
    + '^' + Inttostr(Upref.AbsPos.Right) + '^' +
    Inttostr(Upref.AbsPos.Bottom)
    + '^' + Inttostr(Upref.AbsWidth) + '^' + Inttostr(Upref.AbsHeight)
    + '^' + Magbooltostrint(Upref.AbsShowWindow) + '^' +
    Magbooltostrint(Upref.AbsToolBar)
    + '^' + Inttostr(Upref.AbsCols) + '^' + Inttostr(Upref.AbsMaxLoad)
    + '^' + Inttostr(Upref.AbsRows) + '^' +
    Magbooltostrint(Upref.AbsLockSize)
    + '^' + Inttostr(Upref.AbsToolBarPos));

    {   MUSE EKG window Upref settings:  "EKG"}
  If Doesformexist('EKGDisplayForm') Then
  Begin
    Upref.Musestyle := 2;
        {upref.absstyle := ORD(TFormStyle(frmMagAbstracts.formstyle)); }
    Upref.Musepos.Left := EKGDisplayForm.Left;
    Upref.Musepos.Top := EKGDisplayForm.Top; { top,  left , right, bottom  }
    Upref.Musepos.Right := EKGDisplayForm.Width;
    Upref.Musepos.Bottom := EKGDisplayForm.Height;

  End;
  If Upref.Showmuse Then
    x := 1
  Else
    x := 0;

  Preflist.Add('"EKG"|' +
    Inttostr(Upref.Musestyle)
    + '^' + Inttostr(Upref.Musepos.Left) + '^' + Inttostr(Upref.Musepos.Top)
    + '^' + Inttostr(Upref.Musepos.Right) + '^' +
    Inttostr(Upref.Musepos.Bottom)
    + '^' + Inttostr(x));

    {   Display TIU Notes Window Upref settings: "NOTES"}
  If Doesformexist('MagTIUWinf') Then
  Begin
    Upref.Notesstyle := 2;
        {upref.absstyle := ORD(TFormStyle(frmMagAbstracts.formstyle)); }
    Upref.Notespos.Left := MagTIUWinf.Left;
    Upref.Notespos.Top := MagTIUWinf.Top; { top,  left , right, bottom  }
    Upref.Notespos.Right := MagTIUWinf.Width;
    Upref.Notespos.Bottom := MagTIUWinf.Height;

  End;
  If Upref.Shownotes Then
    x := 1
  Else
    x := 0;

  Preflist.Add('"NOTES"|' +
    Inttostr(Upref.Notesstyle)
    + '^' + Inttostr(Upref.Notespos.Left) + '^' +
    Inttostr(Upref.Notespos.Top)
    + '^' + Inttostr(Upref.Notespos.Right) + '^' +
    Inttostr(Upref.Notespos.Bottom)
    + '^' + Inttostr(x));

    {   Group Abstract Window Upref settings: "GROUP"}
  If Doesformexist('frmGroupAbs') Then
  Begin
    Upref.Grpstyle := 2;
    Upref.Grppos.Top := FrmGroupAbs.Top;
    Upref.Grppos.Left := FrmGroupAbs.Left;
    Upref.Grppos.Right := FrmGroupAbs.Width;
    Upref.Grppos.Bottom := FrmGroupAbs.Height;

    If FrmGroupAbs.Mag4Viewer1.TbViewer.Visible Then
      Stbar := '1' // upref.abstoolbar := TRUE
    Else
      Stbar := '0'; //upref.abstoolbar := FALSE;

    Upref.Grpabsheight := FrmGroupAbs.Mag4Viewer1.LockHeight;
    Upref.Grpabswidth := FrmGroupAbs.Mag4Viewer1.LockWidth;

    Upref.GrpCols := FrmGroupAbs.Mag4Viewer1.ColumnCount;
    Upref.GrpMaxLoad := FrmGroupAbs.Mag4Viewer1.MaxCount;
    Upref.GrpRows := FrmGroupAbs.Mag4Viewer1.RowCount;
    Upref.GrpLockSize := FrmGroupAbs.Mag4Viewer1.LockSize;
    Upref.GrpToolBarPos :=
      MagBoolToInt(FrmGroupAbs.Mag4Viewer1.TbViewer.Align = alLeft);

    If Upref.GrpLockSize Then
      i := 1
    Else
      i := 0;

    Preflist.Add('"GROUP"|' +
      Inttostr(Upref.Grpstyle)
      + '^' + Inttostr(Upref.Grppos.Left) + '^' +
      Inttostr(Upref.Grppos.Top)
      + '^' + Inttostr(Upref.Grppos.Right) + '^' +
      Inttostr(Upref.Grppos.Bottom)
      + '^' + Inttostr(Upref.Grpabswidth) + '^' +
      Inttostr(Upref.Grpabsheight)
      + '^^' + Stbar
      + '^' + Inttostr(Upref.GrpCols) + '^' + Inttostr(Upref.GrpMaxLoad)
      + '^' + Inttostr(Upref.GrpRows) + '^' + Inttostr(i)
      + '^' + Inttostr(Upref.GrpToolBarPos));
  End;

    {TODO -C93+: Not Assuming in this version that Full is always opened.}

    {   Full Resolution window Upref settings: "FULL"  }
  If Doesformexist('frmFullRes') Then
  Begin
    Upref.Fullstyle := 2;
    Upref.Fullpos.Left := FrmFullRes.Left;
    Upref.Fullpos.Top := FrmFullRes.Top; { top,  left , right, bottom  }
    Upref.Fullpos.Right := FrmFullRes.Width;
    Upref.Fullpos.Bottom := FrmFullRes.Height;
    If FrmFullRes.MagViewerTB1.Visible Then
      Stbar := '1' // upref.abstoolbar := TRUE
    Else
      Stbar := '0'; //upref.abstoolbar := FALSE;

    Upref.Fullimageheight := FrmFullRes.Mag4Viewer1.LockHeight;
    Upref.Fullimagewidth := FrmFullRes.Mag4Viewer1.LockWidth;

    Upref.FullCols := FrmFullRes.Mag4Viewer1.ColumnCount;
    Upref.FullMaxLoad := FrmFullRes.Mag4Viewer1.MaxCount;
    Upref.FullRows := FrmFullRes.Mag4Viewer1.RowCount;
    Upref.FullLockSize := FrmFullRes.Mag4Viewer1.LockSize;
    Upref.FullFitMethod := FrmFullRes.Mag4Viewer1.FLastFit;
    St :=
      Magbooltostrint(FrmFullRes.MagViewerTB1.CoolBar1.Bands[0].Break) + ',' + // 11
      Magbooltostrint(FrmFullRes.MagViewerTB1.CoolBar1.Bands[1].Break) + ',' + // 12
      Magbooltostrint(FrmFullRes.MagViewerTB1.CoolBar1.Bands[2].Break); // 13
    Upref.FullControlPos := St;
    If Upref.FullLockSize Then
      x := 1
    Else
      x := 0;

        {

       ^MAG(2006.18,D0,FULL)= (#19) FULL STYLE [1S] ^ (#20) FULL LEFT [2N] ^ (#21)
                           ==>FULL TOP [3N] ^ (#22) FULL WIDTH [4N] ^ (#23) FULL
                           ==>HEIGHT [5N] ^  ^  ^  ^ (#149) FULL TOOLBAR [9N] ^
                           ==>(#140) FULL COLS [10N] ^ (#141) FULL MAXLOAD [11N] ^
             ==>(#153) FULL ROWS [12N] ^ (#157) FULL LOCKSIZE [13N] ^
        }

    Preflist.Add('"FULL"|' +
      Inttostr(Upref.Fullstyle)
      + '^' + Inttostr(Upref.Fullpos.Left)
      + '^' + Inttostr(Upref.Fullpos.Top)
      + '^' + Inttostr(Upref.Fullpos.Right)
      + '^' + Inttostr(Upref.Fullpos.Bottom)
      + '^' + Inttostr(Upref.Fullimagewidth)
      + '^' + Inttostr(Upref.Fullimageheight)
      + '^' + '^' + Stbar + '^' + Inttostr(Upref.FullCols)
      + '^' + Inttostr(Upref.FullMaxLoad)
      + '^' + Inttostr(Upref.FullRows) + '^' + Inttostr(x)
      + '^' + Inttostr(Upref.FullFitMethod)
      + '^' + St);
  End;

    {ImageList window Upref settings: "IMAGEGRID"}
        {  Imagelist window is always open, created at startup}
  Upref.ImageListWinstyle := 2;
  Upref.ImageListWinpos.Left := FrmImageList.Left; { top,  left , right, bottom  }
  Upref.ImageListWinpos.Top := FrmImageList.Top;
  Upref.ImageListWinpos.Right := FrmImageList.Width;
  Upref.ImageListWinpos.Bottom := FrmImageList.Height;
  If Upref.ShowImageListWin or FrmImageList.Visible Then
    x := 1
  Else
    x := 0;

  Preflist.Add('"IMAGEGRID"|' +
    Inttostr(Upref.ImageListWinstyle)
    + '^' + Inttostr(Upref.ImageListWinpos.Left) + '^' +
    Inttostr(Upref.ImageListWinpos.Top)
    + '^' + Inttostr(Upref.ImageListWinpos.Right) + '^' +
    Inttostr(Upref.ImageListWinpos.Bottom)
    + '^' + Inttostr(x)
        // next is colum width            //here 5/29/09  columnwidths
    + '^' + FrmImageList.MagListView1.GetColumnWidths + '^' +
    Magbooltostrint(FrmImageList.PnlMainToolbar.Visible));

    {     Patch 93 has some prefs for Image List window.  Some for Image Verify, Some for Image Edit}
 {We are starting to set the ISTYLE user preferences into the Upref object, and will save them
    to VistA in the ISTYLE node.}

    {   start Style Preferences Upref settings: "ISTYLE"}
  Upref.StyleShowTree := FrmImageList.PnlTree.Visible;
  Upref.StyleShowList := FrmImageList.PnlMagListView.Visible;

    {   This: AutoSelect and AutoSelectSpeed are already set, from the uprefs window.}
{upref.StyleAutoSelect }
//   MagListView1.HotTrack := true;
//   of   MagTreeView1.AutoSelect := true;
{upref.StyleAutoSelectSpeed }

{new in 93.  We'll always have it True.}
//upref.StyleSyncSelection := umagdefinitions.FSyncImageON;
  Upref.StyleSyncSelection := True;

    //Old    StyleWhereToShowAbs : integer ;   // 0 List Win,  1  Abs Window.
    //New    StyleWhetherToShowAbs : integer ;   // 0 No Show,  1  Show.
    //    StylePositionOfAbs : integer ; // 0 Left, 1 bottom, 2 in Tree, 3 Abs Window.

    // UPref.absshowwindow is set above, based on FrmMagAbstracts exists and visible.
    {     Set the User Preferences concerning abstract window from the GUI Settings}
    {Seperate Call to Get UPrefs for Abs position in List Window}
  FrmImageList.AbThmGetUprefFromGUI;
    //    StyleWhereToShowImage : integer; // 0 List Win,  1 Full Res.

  If Doesformexist('frmImageList') Then
  Begin
    Upref.StyleWhereToShowImage := MagBoolToInt(Not (FrmImageList.Pnlfullres.Visible));
  End
  Else
  Begin
    If Doesformexist('frmFullRes') Then Upref.StyleWhereToShowImage := 1;
  End;

    // this would incorrectly set it to open in image list window if user closed Full Res, before
    // closing app
    //upref.StyleWhereToShowImage := magbooltoint(doesformexist('frmFullRes'));
    //    StyleTreeSortButtonsShow : boolean;
  Upref.StyleTreeSortButtonsShow := FrmImageList.PgctrlTreeView.Visible;
    {    StyleTreeAutoExpand : boolean;   }
  Upref.StyleTreeAutoExpand := FrmImageList.MagTreeView1.AutoExpand;
    {    StyleListAbsScrollHoriz : boolean; }
    {    StyleListFullScrollHoriz : boolean;}
  Upref.StyleListAbsScrollHoriz := Not
    (FrmImageList.ListWinAbsViewer.ScrollVertical);
  Upref.StyleListFullScrollHoriz := Not
    (FrmImageList.ListWinFullViewer.ScrollVertical);
  If FrmImageList.Pnlfullres.Visible Then
    Upref.FullFitMethod := FrmImageList.ListWinFullViewer.FLastFit;
    {Seperate Call to get heights, widths of controls in List Window.}
  Upref.StyleControlPos := FrmImageList.GetUprefControlPositions;

  Preflist.Add('"ISTYLE"|' +
    Magbooltostrint(Upref.StyleShowTree) // 1
    + '^' + Magbooltostrint(Upref.StyleAutoSelect) // 2
    + '^' + Inttostr(Upref.StyleAutoSelectSpeed) // 3
    + '^' + Magbooltostrint(Upref.StyleSyncSelection) // 4
    + '^' + Inttostr(Upref.StyleWhetherToShowAbs) // 5 { 0 No Show, 1  Show. }
    + '^' + Inttostr(Upref.StylePositionOfAbs) // 6    { 0 Left, 1 bottom, 2 in Tree, 3 Abs Window }
    + '^' + Inttostr(Upref.StyleWhereToShowImage) // 7
    + '^' + Magbooltostrint(Upref.StyleTreeSortButtonsShow) // 8
    + '^' + Magbooltostrint(Upref.StyleTreeAutoExpand) // 9
    + '^' + Magbooltostrint(Upref.StyleListAbsScrollHoriz) // 10
    + '^' + Magbooltostrint(Upref.StyleListFullScrollHoriz) // 11
    + '^' + Magbooltostrint(Upref.StyleShowList) // 12
    + '^' + Upref.StyleControlPos); // 13

    {   New Verify Window Upref settings: "IVERIFY"}
    {   Here we set preferences a new way.  If the window is Open, we call the
        window to update the Upref Object then use that to save to VistA.
        Also : the Verify window updates its' userpreferences when it closes,
        by calling it's own procedure UpdateUserPrefeneces. So even if the window
        is not open, the settings in the Upref object is current for the Verify Window.}
  If Doesformexist('frmVerify') Then
  Begin
    frmVerify.UserPrefUpdate;
  End;
    {  }

  Preflist.Add('"IVERIFY"|' +
    Inttostr(Upref.VerifyStyle) // 1
    + '^' + Inttostr(Upref.VerifyPos.Left) // 2
    + '^' + Inttostr(Upref.VerifyPos.Top) // 3
    + '^' + Inttostr(Upref.VerifyPos.Right) // 4
    + '^' + Inttostr(Upref.VerifyPos.Bottom) // 5
    + '^' + Magbooltostrint(Upref.VerifyShowReport) // 6
    + '^' + Magbooltostrint(Upref.VerifyShowInfo) // 7
    + '^' + Magbooltostrint(Upref.VerifyHideQFonSearch) // 8
    + '^' + Magbooltostrint(Upref.VerifySingleView) // 9
    + '^' + Upref.VerifyColWidths // 10
    + '^' + Upref.VerifyControlPos); // 11

    {   New Edit Window Upref settings: "IEDIT"  }
  If Doesformexist('frmIndexEdit') Then
  Begin
    Upref.EditStyle := 2;
    Upref.EditPos.Left := FrmIndexEdit.Left;
    Upref.EditPos.Top := FrmIndexEdit.Top; { top,  left , right, bottom  }
    Upref.EditPos.Right := FrmIndexEdit.Width;
    Upref.EditPos.Bottom := FrmIndexEdit.Height;

    Preflist.Add('"IEDIT"|' +
      Inttostr(Upref.EditStyle) // 1
      + '^' + Inttostr(Upref.EditPos.Left) // 2
      + '^' + Inttostr(Upref.EditPos.Top) // 3
      + '^' + Inttostr(Upref.EditPos.Right) // 4
      + '^' + Inttostr(Upref.EditPos.Bottom)); // 5
  End;

    //// end p93 additions

    {   Radiology List window Upref settings: "RADLISTWIN"}
  If Doesformexist('radlistwin') Then
  Begin
    Upref.RadListWinstyle := 2;
        {upref.mainstyle :=  ORD(TFormStyle(frmMain.formstyle));}
    Upref.RadListWinpos.Left := Radlistwin.Left;
    Upref.RadListWinpos.Top := Radlistwin.Top;
        { top,  left , right, bottom  }
    Upref.RadListWinpos.Right := Radlistwin.Width;
    Upref.RadListWinpos.Bottom := Radlistwin.Height;
    Upref.RadListWinToolbar := Radlistwin.MnuToolbar.Visible
  End;
  If Upref.ShowRadListWin Then
    x := 1
  Else
    x := 0;

  Preflist.Add('"RADLISTWIN"|' +
    Inttostr(Upref.RadListWinstyle)
    + '^' + Inttostr(Upref.RadListWinpos.Left) + '^' +
    Inttostr(Upref.RadListWinpos.Top)
    + '^' + Inttostr(Upref.RadListWinpos.Right) + '^' +
    Inttostr(Upref.RadListWinpos.Bottom)
    + '^' + Inttostr(x) + '^' + Magbooltostrint(Upref.RadListWinToolbar));

    {   Radiology Viewer Upref settings: "DICOMWIN"}
    {   This is also being done the new way... but when window closes, we need
        to update the upref object.}
  If Doesformexist('frmRADViewer') Then
  Begin
    FrmRadViewer.GetFormUPrefs(Upref);
        // not implemented.  // 72gek now being used.

        (* upref.dicomstyle:= 2;
         upref.dicompos.left := frmRADViewer.left;
         upref.dicompos.top := frmRADViewer.top; { top,  left , right, bottom  }
         upref.dicompos.right := frmRADViewer.width;
         upref.dicompos.bottom := frmRADViewer.height;
          {    Get values for new 72 prefs  }
               upref.dicomScrollSpeed :=  frmRADViewer.t ; //int
               upref.dicomCineSpeed :=  ; //int
               upref.dicomStackPaging :=  ; //int
               upref.dicomLayoutSettings := ; //int
               upref.dicomStackPageTogether :=  ; //bool
               upref.dicomShowOrientationLabels :=  ; // bool
               upref.dicomShowPixelValues :=  ; //bool
               upref.dicomMeasureColor :=   ; //int
               upref.dicomMeasureLineWidth :=   ; // int
               upref.dicomMeasureUnits :=  ; // string;
               upref.dicomDeviceOptionsWinLev :=  ; // int;
               *)

          {}
    Preflist.Add('"DICOMWIN"|' +
      Inttostr(Upref.Dicomstyle)
      + '^' + Inttostr(Upref.Dicompos.Left)
      + '^' + Inttostr(Upref.Dicompos.Top)
      + '^' + Inttostr(Upref.Dicompos.Right)
      + '^' + Inttostr(Upref.Dicompos.Bottom)
      + '^' + Inttostr(Upref.DicomScrollSpeed)
      + '^' + Inttostr(Upref.DicomCineSpeed)
      + '^' + Inttostr(Upref.DicomStackPaging)
      + '^' + Inttostr(Upref.DicomLayoutSettings)
      + '^' + Magbooltostrint(Upref.DicomStackPageTogether)
      + '^' + Magbooltostrint(Upref.DicomShowOrientationLabels)
      + '^' + Magbooltostrint(Upref.DicomShowPixelValues)
      + '^' + Inttostr(Upref.DicomMeasureColor)
      + '^' + Inttostr(Upref.DicomMeasureLineWidth)
      + '^' + Upref.DicomMeasureUnits
      + '^' + Inttostr(Upref.DicomDeviceOptionsWinLev)
      + '^' + MagBoolToStrInt(Upref.DicomDisplayScoutLines)
      + '^' + MagBoolToStrInt(Upref.DicomDisplayScoutWindow)
      + '^' + IntToStr(Upref.DicomScoutLineColor))
      ;

  End;

    {   Report Window Upref settings: "REPORT" }
  If Doesformexist('maggrpcf') Then
  Begin
    Upref.Reportstyle := 2;
    Upref.Reportpos.Top := Maggrpcf.Top;
    Upref.Reportpos.Left := Maggrpcf.Left;
    Upref.Reportpos.Right := Maggrpcf.Width;
    Upref.Reportpos.Bottom := Maggrpcf.Height;
    Upref.Reportfont := Maggrpcf.Memo1.Font;

    Preflist.Add('"REPORT"|' +
      Inttostr(Upref.Reportstyle)
      + '^' + Inttostr(Upref.Reportpos.Left) + '^' +
      Inttostr(Upref.Reportpos.Top)
      + '^' + Inttostr(Upref.Reportpos.Right) + '^' +
      Inttostr(Upref.Reportpos.Bottom)
      + '^' + Upref.Reportfont.Name + '^^' +
      Inttostr(Upref.Reportfont.Size));
  End;

    {   Remote Image View  Upref settings: "RIVER"}
  Preflist.Add('"RIVER"|' + Magbooltostrint(Upref.RIVAutoConnectEnabled) + '^'
    + Magbooltostrint(Upref.RIVAutoConnectVISNOnly) + '^'
    + Magbooltostrint(Upref.RIVHideEmptySites) + '^'
    + Magbooltostrint(Upref.RIVHideDisconnectedSites) + '^'
    + Magbooltostrint(Upref.RIVAutoConnectDoD));  {/ P117 NCAT - JK 12/15/2010 /}

//  Preflist.Add('"ANNOTDISPLAY"|' + Upref.ArtXSettingsDisplay); {/ P122 - JK 6/10/2011 /}
//    PrefList.Add('"ANNOTDISPLAY"|' + AnnotationOptionsX.UserPreferences); {/p122 dmmn 7/11/11 /}
  {/p122 dmmn 8/2/11 /}
  Preflist.Add('"ANNOTDISPLAY"|' +                            // 1
      frmAnnotOptionsX.FontName                             // 2
      + '^' + IntToStr(frmAnnotOptionsX.FontStyle)          // 3
      + '^' + IntToStr(frmAnnotOptionsX.FontSize)           // 4
      + '^' + IntToStr(frmAnnotOptionsX.LineWidth)          // 5
      + '^' + IntToStr(frmAnnotOptionsX.AnnotLineColor)     // 6
      + '^' + IntToStr(frmAnnotOptionsX.Opacity)            // 7
      + '^' + IntToStr(frmAnnotOptionsX.ArrowPointerStyle)  // 8
      + '^' + IntToStr(frmAnnotOptionsX.ArrowPointerLength) // 9
      + '^' + IntToStr(frmAnnotOptionsX.ArrowPointerAngle)  // 10
      + '^' + IntToStr(frmAnnotOptionsX.Left)               // 11
      + '^' + IntToStr(frmAnnotOptionsX.Top)                // 12
      + '^' + frmAnnotOptionsX.AutoShowAnnots);             // 13

  {/p122t10 dmmn 12/6 - not being used /}
//  PrefList.Add('"ANNOTDISPLAYRAD"|' +                         // 1
//      AnnotationOptionsX.StrictRAD                            // 2
//      + '^' + AnnotationOptionsX.RADFontName                  // 3
//      + '^' + IntToStr(AnnotationOptionsX.RADFontStyle)       // 4
//      + '^' + IntToStr(AnnotationOptionsX.RADFontSize)        // 5
//      + '^' + IntToStr(AnnotationOptionsX.RADLineWidth)       // 6
//      + '^' + IntToStr(AnnotationOptionsX.RADColor)           // 7
//      + '^' + IntToStr(AnnotationOptionsX.RADOpacity));       // 8

    {     if we are closing imaging, the form maggmsgf may not exist.}
  If Not FClosingImaging Then
    WinMsg('', 'Saving View Preferences...');
  idmodobj.GetMagDBBroker1.RPMagSetUserPreferences(Rpcstat, Rpcmsg, Preflist);
  If Not FClosingImaging Then
    WinMsg('', Rpcmsg);
    {Not here : Upref settings: "DOC"  - This was for old Document Viewer, long Gone.}
    {Not here : Upref settings: "CAPTIU" - This is in Capture App}
    {Not here : Upref settings: "CAPCONFIG" - This is in Capture App}
    {Not here : Upref settings: "APPMSG" - Future}
  except
    on E:Exception do
      MagAppMsg('s', 'TfrmMain.Saveusersettings exception = ' + E.Message);
  end;
End;
{-- end save user settings }

Procedure TfrmMain.MnuAboutClick(Sender: Tobject);
Var
  Rstat: Boolean;
  Rlist: Tstringlist;
  Magver, Vstat: String; //59
Begin
  Rlist := Tstringlist.Create;
  Try
    idmodobj.GetMagDBBroker1.RPMaggInstall(Rstat, Rlist);
        //pre 59 frmAbout.execute('','',rlist);
        {p59 Display Version Status : Alpha/Beta or Released}
    Magver := MagGetFileVersionInfo(Application.ExeName); //59
    idmodobj.GetMagDBBroker1.RPMagVersionStatus(Vstat, Magver); //59
    FrmAbout.Execute('', '', Rlist, MagPiece(Vstat, '^', 2)); //59
  Finally
    Rlist.Free;
  End;
End;

Procedure TfrmMain.MnuAbstractsClick(Sender: Tobject);
Begin
  ShowAbstractWindow;
End;

Procedure TfrmMain.ShowAbstractWindow(Value: Boolean = True);
Begin
 {debug94} WinMsg('s', '* * -- * *   - in  ShowAbstractWindow:  value= ' + Magbooltostr(Value));
  Try
    If Value Then
    Begin
      If Not Doesformexist('frmMagAbstracts') Then
        UpreftoAbsWindow(Upref);
      If FrmMagAbstracts.Mag4Viewer1.MagImageList = Nil Then
      Begin
 {debug94} WinMsg('s', '* * -- * *   - in  ShowAbstractWindow:  Set Viewer1.magImageList = frmImageList.magImageList');

        FrmMagAbstracts.Mag4Viewer1.MagImageList := FrmImageList.MagImageList1;
                //frmImageList.magimagelist1.Attach_(frmMagAbstracts.Mag4Viewer1);
      End;
      FormToNormalSize(FrmMagAbstracts);
            //frmMagAbstracts.show;
      Application.Processmessages;
            {TODO -cRefactor: make a method in the Abstracts Form for this stuff.}
      FrmMagAbstracts.LbImagecount.caption := ' Loading Abstracts...';
      FrmMagAbstracts.Update;
      FrmMagAbstracts.Mag4Viewer1.UpDate_('1', Self);
      Application.Processmessages;
      ImageCountDisplay;
      mainImageCountDisplay;
    End
    Else {value is false, so we hide the window.}
    Begin
      If Not Doesformexist('frmMagAbstracts') Then
        Exit;
      If FrmMagAbstracts.Visible Then
        FrmMagAbstracts.Close;
      If FrmMagAbstracts.Mag4Viewer1.MagImageList <> Nil Then
      Begin
 {debug94} WinMsg('s', '* * -- * *   - in  ShowAbstractWindow:  Detach then - set Viewer1.magImageList = nil');
        FrmMagAbstracts.Mag4Viewer1.MagImageList.Detach_(FrmMagAbstracts.Mag4Viewer1);
        FrmMagAbstracts.Mag4Viewer1.MagImageList := Nil;
      End;
    End;

  Finally
    Screen.Cursor := crDefault;
    If Doesformexist('frmMagAbstracts') Then
      WinMsg('s', '* * -- * *   - in  ShowAbstractWindow:  Finally... Viewer1.magImageList is NIL = ' + Magbooltostr(FrmMagAbstracts.Mag4Viewer1.MagImageList = Nil))
    Else
      WinMsg('s', '* * -- * *   - in  ShowAbstractWindow:  Finally... frmMagAbstracts does not exist ... ');
  End;
  If Doesformexist('frmImageList') Then
    If (FrmImageList.TbtnAbstracts.Tag <> -1) Then
      FrmImageList.TbtnAbstracts.Down := FrmMagAbstracts.Visible;
    { TODO -c3: Might Need a ReAlignImages here }
End;

(*
now use MgrImageDelete in uMagDisplayMgr
procedure TfrmMain.ImageDelete(Iobj: TImageData);
var
    rmsg: string;
    i: integer;
    rstat: boolean;
    rlist: Tstrings;
    reason: string;
    sl: string;
    allowgrpdel: boolean;
begin
    {p59 MAG SYSTEM KEY no longer needed for Group Delete}
    allowgrpdel := (UserHasKey('MAG DELETE')); //AND UserHasKey('MAG SYSTEM'));
    if not allowgrpdel then
        allowgrpdel := (Iobj.GroupCount = 1);
    sl := '';
    rlist := tstringlist.create;
    try
        if not frmDeleteImage.confirmdeletion(rmsg, rlist, Iobj, reason) then
        begin
            sl := 'Deletion Canceled : ' + #13 + rmsg + #13 + 'Image ID#: ' +
                Iobj.mag0;
            winmsg('d', sl);
            exit;
        end;

        WinMsg('', 'Deleting Image ID# ' + Iobj.Mag0 + '...');

        idmodobj.GetMagDBBroker1.RPMaggImageDelete(rstat, rmsg, rlist, Iobj.Mag0, '',
            reason, allowGrpDel);
        if not rstat then
        begin
            for I := 0 to rlist.count - 1 do
                sl := sl + magpiece(rlist[i], '^', 2) + #13;

            winmsg('de', sl);
            for I := 0 to rlist.count - 1 do
                winmsg('s', rlist[i]);
            exit;
        end;

        winmsg('d', rmsg);
        {TODO -cRefactor: here we can notify anyone who wants to know that an Image has
               been deleted Have to use observer pattern.    }
        for i := 0 to rlist.count - 1 do
            deletedimages.add(rlist[i]);
    finally
        rlist.free;
    end;
end;
*)

Function TfrmMain.RadlistExams(RADFN: String): Integer;
Var
  x: String;
Begin

End;

(*
procedure TfrmMain.ListToRadListWin;
var
    j, k: integer;
    ST: string;
begin
    { this'll be gone with MultiProcedure listing which will use a TMagListView
       and/or TMagTreeView.}
    Radlistwin.DFN.text := idmodobj.GetMagPat1.M_DFN;

    radlistwin.stg1.rowcount := tradlist.count;
    radlistwin.stg1.colcount := maglength(tradlist[0], '^');
    for j := 0 to tradlist.count - 1 do
    begin
        for k := 1 to radlistwin.stg1.colcount do
        begin
            st := magpiece(tradlist[j], '^', k);
            if (k = 4) and (J > 0) then
                transformdate(st);
            radlistwin.stg1.cells[k - 1, j] := st;
        end;
    end;
end;
*)
{  Old vs New.  The RadExamlisting window calls a function in the Main window.
        It should be calling it itself.}

Procedure TfrmMain.Radexamselected(s: String);
Begin
  RadExamImagesToGroup(TRadList[Strtoint(s)]);
End;

Procedure TfrmMain.MnuClearPatientClick(Sender: Tobject);
Begin
  idmodobj.GetMagPat1.Clear;
  If Frmmain.Visible Then
  Begin
    If (EdtPatient.Enabled And EdtPatient.Visible) Then
      EdtPatient.SetFocus;
  End;
End;

{       Other forms call this, to give focus back to Main Form.}

Procedure TfrmMain.Focustomain;
Begin
  Try
    FormToNormalSize(Frmmain);
    If Frmmain.Visible <> True Then
      Frmmain.Show;
    Frmmain.SetFocus;
    If Not MnuToolbar.Checked Then
      MnuToolbar.Checked := True;
    If Not PMain.Visible Then
      PMain.Show;
    If Not CprsSync.SyncOn Then
    Begin
      If Frmmain.Visible Then
      Begin
        EdtPatient.Show;
        EdtPatient.SetFocus;
      End;
    End;
  Except
    On e: Exception Do
      DebugFile('procedure TfrmMain.FocusToMain. Handled EXCEPTION = ' +
        e.Message); {JK 3/11/2009}
  End;
End;

Procedure TfrmMain.MnuShowHintsClick(Sender: Tobject);
Begin
  MnuMainHint.Checked := ShowHint;
End;

Procedure TfrmMain.Contents1Click(Sender: Tobject);
Begin
  Application.HelpContext(0);
End;

Procedure TfrmMain.ImagingDisplayWindow1Click(Sender: Tobject);
Begin
  Application.HelpContext(10071);
End;

Procedure TfrmMain.MnuMUSEEKGlistClick(Sender: Tobject);
Begin
  ShowEKGWindow;
End;

Procedure TfrmMain.MnuLocalMuseClick(Sender: Tobject);
Begin
  MnuLocalMuse.Checked := Not MnuLocalMuse.Checked;
    //Stu: N/A  UseMuseDemoDB := mnuLocalMuse.checked;
End;

Procedure TfrmMain.MSecurityONClick(Sender: Tobject);
Begin
  MSecurityON.Checked := Not MSecurityON.Checked;
  idmodobj.GetMagFileSecurity.SecurityOn := MSecurityON.Checked;
  WinMsg('', '**Imaging Network Security is on : ' +
    Magbooltostr(MSecurityON.Checked));
End;

Procedure TfrmMain.btnMsgHistoryClick(Sender: Tobject);
Begin
    //maggmsgf.show; {JK 10/5/2009 - Maggmsgu refactoring - removed old method}
    //maggmsgf.BringToFront; {JK 10/5/2009 - Maggmsgu refactoring - removed old method}
  MagAppMsgShow; {JK 10/5/2009 - Maggmsgu refactoring}
End;

{PROTOTYPE TESTING}

Procedure TfrmMain.MessageSend1Click(Sender: Tobject);
Var
  Buffer: Array[0..255] Of Char;
  Atom: TAtom;
Begin

  CprsSync.CprsHandle := 0;
  CprsSync.SyncOn := True;
  SendWindowsMessage(EdtPatient.Text);
  Exit;

    (*  Atom := GlobalAddAtom(StrPCopy(Buffer, edtPatient.text));
      SendMessage(HWND_Broadcast, WMIdentifier, Handle, Atom);
      GlobalDeleteAtom(Atom);*)
End;

Procedure TfrmMain.MagSecMsgClick(Sender: Tobject);
Begin
  FrmImageList.LogSecurityMsgs;
    //maggmsgf.show;  {JK 10/5/2009 - Maggmsgu refactoring - removed old method}
  magAppMsgShow; {RCA use message intefaced object}
End;

{/ P130 - JK 9/19/2012 /}
procedure TfrmMain.MagSubscriber1SubscriberUpdate(NewsObj: TMagNewsObject);
begin
  if NewsObj.Newscode = MpubMainFormMsgs then
    pmsg.Caption := NewsObj.NewsStrValue;
end;

{TODO -cRefactor: this is one of the many remaining methods that have unwanted coupling issues.
   This method needs the Main Form to know about the Abstract window.
   enableabs operates on the abstract window.}
//function TfrmMain.CanOpenSecureFile(FiletoOpen: string; CloseSecurity, enablewins: boolean): boolean;   // JMW 3/22/2005 p45

Function TfrmMain.CanOpenSecureFile(FiletoOpen: String; CloseSecurity,
  Enablewins: Boolean; User: String = ''; Pass: String = ''): Boolean;
Var
  Xmsg: String;
  i: Integer;
Begin
  If Not idmodobj.GetMagFileSecurity.MagOpenSecurePath(FiletoOpen, Xmsg, User, Pass) Then
  Begin
    Result := False;
    WinMsg('', Xmsg);
    FrmImageList.LogSecurityMsgs;
    If CloseSecurity Then
      idmodobj.GetMagFileSecurity.MagCloseSecurity(Xmsg);
    If Enablewins Then //enableabs;
  End
  Else
    Result := True;
  FrmImageList.LogSecurityMsgs;
End;

Procedure TfrmMain.MnuPrefetchClick(Sender: Tobject);
Begin
  PrefetchPatientImages;
End;

{PROTOTYPE TESTING}

Procedure TfrmMain.MFormNamesClick(Sender: Tobject);
Begin
  Showopenforms;
End;

Procedure TfrmMain.PmsgMouseMove(Sender: Tobject; Shift: TShiftState; x, y:
  Integer);
Begin
  Pmsg.Hint := Pmsg.caption;
End;

Procedure TfrmMain.MnuFakeNameClick(Sender: Tobject);
Begin
  MnuFakeName.Checked := Not MnuFakeName.Checked;
  idmodobj.GetMagPat1.M_UseFakeName := MnuFakeName.Checked;
  ChangeToPatient(idmodobj.GetMagPat1.M_DFN);
End;

{PROTOTYPE TESTING}

Procedure TfrmMain.KernelBrokerDEBUGMode1Click(Sender: Tobject);
Var
  s: String[3];
Begin
    (*  idmodobj.GetMagDBBroker1.Broker.DEBUGMODE := not idmodobj.GetMagDBBroker1.Broker.DEBUGMODE;
      KernelBrokerDEBUGMode1.checked := idmodobj.GetMagDBBroker1.Broker.DEBUGMODE;
      if idmodobj.GetMagDBBroker1.Broker.DEBUGMODE then S := 'ON'
      else S := 'OFF';
      WinMsg('', 'Kernel Broker DEBUG Mode : ' + S);*)
End;

{PROTOTYPE TESTING}

Procedure TfrmMain.MWrksCacheOnClick(Sender: Tobject);
Begin
  MWrksCacheOn.Checked := Not MWrksCacheOn.Checked;
  FWrksAbsCacheON := MWrksCacheOn.Checked;
End;

Procedure TfrmMain.MnuMainHintClick(Sender: Tobject);
Begin
  MnuMainHint.Checked := Not MnuMainHint.Checked;
  ShowHint := MnuMainHint.Checked;
End;

Procedure TfrmMain.TimerTimeoutTimer(Sender: Tobject);
Begin
  If MagTimeoutform.Visible Then
    Exit;
  MagTimeoutform.Setapplication(MagappDisplay); //59 magappDisplay
  MagTimeoutform.Showmodal;
  If MagTimeoutform.ModalResult = MrOK Then
  Begin
    Frmmain.Close;
  End;
End;

Procedure TfrmMain.ChangeTimeoutValue1Click(Sender: Tobject);
Begin
  MagTimeoutform.SetApplicationTimeOut('', TimerTimeout);
End;

Procedure TfrmMain.IdleHandler(Sender: Tobject; Var Done: Boolean);
Begin
    //WinMsg('s','On Idle ');
End;

Procedure TfrmMain.MnuCPRSLinkOptionsClick(Sender: Tobject);
Begin
  MagSyncCPRSf.GetCPRSLinkOptions(CprsSync);
  If Not CprsSync.SyncOn Then
  Begin
    If MagSyncCPRSf.VerifyBreakCPRSLink Then
      mainEnablePatientLookupLogin(True)
    Else
      CprsSync.SyncOn := True;
  End;
End;

Procedure TfrmMain.TestEnableDisable1Click(Sender: Tobject);
Begin
  TestEnableDisable1.Checked := Not TestEnableDisable1.Checked;
  mainEnablePatientLookupLogin(TestEnableDisable1.Checked);
End;

Procedure TfrmMain.bPatientClick(Sender: Tobject);
Begin
  If Frmmain.Visible Then
    EdtPatient.SetFocus;
End;

Procedure TfrmMain.MnuTurnHintsOFFforallwindowsClick(Sender: Tobject);
Var
  i: Integer;
Begin
  For i := Screen.CustomFormCount - 1 Downto 0 Do
  Begin
    Screen.CustomForms[i].ShowHint := False;
  End;
  WinMsg('', 'Hints are OFF for all windows');
  If Doesformexist('frmGroupAbs') Then
    FrmGroupAbs.Mag4Viewer1.ShowHints(False);
  If Doesformexist('frmMagAbstracts') Then
    FrmMagAbstracts.Mag4Viewer1.ShowHints(False);
  If Doesformexist('frmFullRes') Then
    FrmFullRes.Mag4Viewer1.ShowHints(False);
End;

{  This is also not good, instead of having to know about specific forms,
    we could try looping through all forms of TMagForm (descendant of Tform) and
    call the TMagForms SetHint method.  We wouldn't need to know the specifics
    about individule forms.}

Procedure TfrmMain.MnuTurnHintsONforallwindowsClick(Sender: Tobject);
Var
  i: Integer;
Begin
  For i := Screen.CustomFormCount - 1 Downto 0 Do
  Begin
    Screen.CustomForms[i].ShowHint := True;
  End;
  WinMsg('', 'Hints are ON for all windows');
  If Doesformexist('frmGroupAbs') Then
    FrmGroupAbs.Mag4Viewer1.ShowHints(True);
  If Doesformexist('frmMagAbstracts') Then
    FrmMagAbstracts.Mag4Viewer1.ShowHints(True);
  If Doesformexist('frmFullRes') Then
  Begin
    FrmFullRes.Mag4Viewer1.ShowHints(True);
    FrmFullRes.MagViewerTB1.ShowHint := True;
  End;
End;

Procedure TfrmMain.MnuProgressNotesClick(Sender: Tobject);
Begin
  MagTIUWinf.SetPatientName(idmodobj.GetMagPat1.M_DFN, idmodobj.GetMagPat1.M_NameDisplay);
  MagTIUWinf.Getnotes;
  FormToNormalSize(MagTIUWinf);
  MagTIUWinf.Show;
End;

Procedure TfrmMain.MnuDischargeSummariesClick(Sender: Tobject);
Begin
  MagTIUWinf.SetPatientName(idmodobj.GetMagPat1.M_DFN, idmodobj.GetMagPat1.M_NameDisplay);
  MagTIUWinf.GetDischargeSummaries;
  FormToNormalSize(MagTIUWinf);
  MagTIUWinf.Show;
End;
{  This might not be what user expect.  This is a listing of Notes of CLASS
    Consult, not the Consult itself.  Different animals.}

Procedure TfrmMain.MnuConsultsClick(Sender: Tobject);
Begin
  MagTIUWinf.SetPatientName(idmodobj.GetMagPat1.M_DFN, idmodobj.GetMagPat1.M_NameDisplay);
  MagTIUWinf.GetConsults;
  FormToNormalSize(MagTIUWinf);
  MagTIUWinf.Show;
End;

Procedure TfrmMain.ImagesForCPRSTIUNote(CprsString: String);
Var
  t: Tstringlist;
  RPmsg: String;
  Success: Boolean;
  NewsObj: TMagNewsObject;
  grpIobj: TImageData;
  s, Sp, ctDesc: String;
Begin

    //p93t8.  Need to do a Sync with Image Object or unselect all.
  If FSyncImageON Then {FSyncImageOn from ImagesForCPRSTIUNote }
  Begin
    NewsObj := MakeNewsObject(mpubImageUnSelectAll, 0, '0', Nil, Nil);
        //logmsg('s', 'Publishing mpubImageUnSelectAll in ImagesForTIUNote');
    MagAppMsg('s', 'Publishing mpubImageUnSelectAll in ImagesForTIUNote'); {JK 10/5/2009 - Maggmsgu refactoring}
    FrmImageList.MagPublisher1.I_SetNews(NewsObj); //procedure ImagesForCPRSTIUNote
  End;

  If (CprsString = '') Then
    Exit;

    // JMW 7/1/2005 p45t4 Don't clear patient images for CPRS IR
    //  clearpatientimages(false, false); //ImagesForCPRSTIUNote
  t := Tstringlist.Create;
  Try
    idmodobj.GetMagDBBroker1.RPGetCPRSTIUNotes(MagPiece(CprsString, '^', 5), t, Success, RPmsg);
    WinMsg('', MagPiece(RPmsg, '^', 2) + MagPiece(CprsString, '^', 6));
    If Not Success Then
    Begin
      ClearPatientImages(True, False); //ImagesForCPRSTIUNote
      Exit;
    End;

        {----This code is duplicated 4 times, need to make a call-----}
    If Not Doesformexist('frmGroupAbs') Then
      UprefToGroupWindow(Upref);
    FrmGroupAbs.Visible := True;
    FormToNormalSize(FrmGroupAbs);
    Try
            (* frmGroupAbs.SetInfo('TIU Document, Images -- ' +
                 frmMain.edtPatient.Text,
                 '  ' + MagPiece(RPmsg, '^', 4) + '  ' + inttostr(t.count) +
                 '  Images',
                 '',
                 magpiece(RPmsg, '^', 5), MagPiece(RPmsg, '^', 4));*)
      FrmGroupAbs.MagImageList1.LoadGroupList(t, '', '');
      FrmGroupAbs.Show;
            {}
      s := MagPiece(RPmsg, '^', 4);
      Sp := EdtPatient.Text;
      MagReplaceString(Sp, '', s);
      MagReplaceString('@', ' ', s);
      If t.Count > 1 Then
        ctDesc := ' Images'
      Else
        ctDesc := ' Image';
      FrmGroupAbs.SetInfo('TIU Document, Images: ' +
        Frmmain.EdtPatient.Text,
        '  ' + s + ' - ' + Inttostr(t.Count) +
        ctDesc, '', MagPiece(RPmsg, '^', 5), MagPiece(RPmsg, '^', 4));
            {}
      grpIobj := FrmGroupAbs.Mag4Viewer1.GetCurrentImageObject();
      If (grpIobj <> Nil) Then
      Begin
                //formtonormalsize, doesn't go here.  if frmImageList.ListWinFullViewer.Visible then formtonormalsize(frmImageList);
        If FSyncImageON Then {FSyncImageOn from  ImagesForCPRSTIUNote }
        Begin
          NewsObj := MakeNewsObject(MpubImageSelected, 0, grpIobj.Mag0, grpIobj,
            FrmGroupAbs.Mag4Viewer1);
                    //logmsg('s', 'Publishing ImageSelect from ImagesForCPRSTIUNote');
          MagAppMsg('s', 'Publishing ImageSelect from ImagesForCPRSTIUNote'); {JK 10/5/2009 - Maggmsgu refactoring}
          FrmImageList.MagPublisher1.I_SetNews(NewsObj); //procedure AbsOpenSelectedImage
        End;
      End;
    Except
      On e: Exception Do
      Begin
        Showmessage('exception : ' + e.Message);
        FrmGroupAbs.FGroupIEN := '';
      End;
    End;
        {------------------------}
  Finally
    t.Free;
  End;

End;

Procedure TfrmMain.SetWorkstationAlternaterVideoViewer1Click(Sender: Tobject);
Var
  altviewer: String;
  Magini: TIniFile;
Begin
  OpenDialog1.FilterIndex := 3;
  Magini := TIniFile.Create(GetConfigFileName);
  Try
    altviewer := Magini.ReadString('Workstation settings',
      'Alternate Video Viewer', '');
    If altviewer <> '' Then
    Begin
      OpenDialog1.Filename := altviewer;
      OpenDialog1.InitialDir := ExtractFilePath(altviewer);
    End
    Else
      OpenDialog1.InitialDir := MagGetWindowsDirectory;
    If OpenDialog1.Execute Then
    Begin
      altviewer := OpenDialog1.Filename;
      Magini.Writestring('Workstation settings', 'Alternate Video Viewer',
        altviewer);
    End;
  Finally
    Magini.Free;
  End;
End;

Procedure TfrmMain.EraseCacheFiles;
Begin
    {    'manualcahce'  is for Stuart's demos.  This way the local cache isn't
          deleted each session, and demo will work faster.  like a local Server
          for images.  ... ? how big will the directory get ?    }
  try
    If Not (Uppercase(GetIniEntry('workstation settings', 'manualcache')) = 'TRUE') Then
    Begin
          {
          maggmsgf.filelistbox1.directory := apppath + '\cache\';
          maggmsgf.DirectoryListBox1.Directory := apppath + '\cache\';
          }
          // JMW 6/22/2005 p45 be sure to clear the correct cache directory
          //maggmsgf.filelistbox1.directory := ImageCacheDirectory;   {JK 10/5/2009 - Maggmsgu refactoring - removed old method}
      lstboxCache.Directory := ImageCacheDirectory; {JK 10/6/2009}
          //maggmsgf.DirectoryListBox1.Directory := ImageCacheDirectory;  {JK 10/5/2009 - Maggmsgu refactoring - removed old method}
      dirlstboxCache.Directory := ImageCacheDirectory; {JK 10/6/2009}
      If Doesformexist('frmVideoPlayer') Then
        FrmVideoPlayer.Close;
      Application.Processmessages;
          //maggmsgf.EraseCacheFiles;  {JK 10/5/2009 - Maggmsgu refactoring - removed old method}
      EraseFilesInCache; {JK 10/6/2009 - moved from the deprecated MaggMsgu unit and renamed here}
    End;
  except
    on E:Exception do
      MagAppMsg('s', 'TfrmMain.EraseCacheFiles exception = ' + E.Message);
  end;
End;

{JK 10/6/2009 - moved from the deprecated MaggMsgu unit and renamed here.  Was Tmaggmsgf.EraseCacheFiles...now TfrmMain.EraseFilesInCache}

Procedure TfrmMain.EraseFilesInCache;
Var
  i, j: Integer; //45 j
  Xfile: String;
  D1, D2: PChar; //45
  CurrentDir: String; //45
Begin
  {TODO:  We get error if Video File is opened}
  {file won't be erased if the mPlay32.exe is still open with a file.}
  For i := lstboxCache.Items.Count - 1 Downto 0 Do
  Begin
    Xfile := lstboxCache.Items[i];
    SysUtils.DeleteFile(Xfile);
  End;

  Application.Processmessages;

  //45 startchanges
  // JMW 6/17/2005 p45 delete all files in subdirectories
  D2 := PChar(AnsiUpperCase(dirlstboxCache.Directory));

  For i := dirlstboxCache.Items.Count - 1 Downto 1 Do
  Begin
    D1 := PChar(AnsiUpperCase(dirlstboxCache.Items[i]));
    If Strpos(D2, D1) = Nil Then
    Begin
      CurrentDir := dirlstboxCache.Directory + '\' + dirlstboxCache.Items[i];
      //filelistbox1.Directory := directorylistbox1.Directory + '\' + directorylistbox1.Items[i];
      lstboxCache.Directory := CurrentDir;
      For j := lstboxCache.Items.Count - 1 Downto 0 Do
      Begin
        SysUtils.DeleteFile(lstboxCache.Items[j]);
      End;
      lstboxCache.Directory := dirlstboxCache.Directory;
      RemoveDir(CurrentDir); // delete the directory the images were in
    End;
  End;

  Application.Processmessages();
  //45 endchanges

End;

Procedure TfrmMain.MMagINIClick(Sender: Tobject);
Begin
    // P8t35
  If MagWrksf.Execute(GetConfigFileName) Then //ApplyWorkstationSettings;

        //old  Executefile('magwrks.exe', 'letsdoit', apppath, SW_Show);
End;

Procedure TfrmMain.MoveFocusTo(XForm: TForm);
Begin
    //
End;

{PROTOTYPE TESTING}

Procedure TfrmMain.Showhiddenmenuoptions1Click(Sender: Tobject);
Begin
  MnuFakeName.Visible := True;
  MnuRefreshPatientImages.Visible := True;
  MnuClearPatient.Visible := True;
  MnuCPRSLinkOptions.Visible := True;
  MnuMUSEEKGlist.Visible := True;
  MnuRefreshPatientImages.Enabled := True;
  MnuClearPatient.Enabled := True;
  MnuPreFetch.Enabled := True;
  MnuCPRSLinkOptions.Enabled := True;
  MnuGroupWindow.Enabled := True;
End;

Procedure TfrmMain.MnuRefreshPatientImagesClick(Sender: Tobject);
Begin
    { change to same patient, forces a clear and reload.}{HERE}
  ChangeToPatient(idmodobj.GetMagPat1.M_DFN);
End;

Procedure TfrmMain.CreateDynamicHelpMenu; //59
Begin
  MagHelpMenu := TMag4Menu.Create(Self);
  With MagHelpMenu Do
  Begin
    MenuBarItem := MnuHelp;
    InsertAfterItem := MnuScreenSettings1;
    OnNewItemClick := HelpMenuitemSelected;
    MaxInsert := 10;
  End;
End;

Procedure TfrmMain.CreateDynamicPatMenu;
Begin
  MagPatMenu := TMag4Menu.Create(Self);
  With MagPatMenu Do
  Begin
        {         Insert on the File menu after seperator N14}
    MenuBarItem := MnuFile;
    InsertAfterItem := N14;
    OnNewItemClick := PatMenuitemSelected;
    MaxInsert := 10;
  End;
End;

Procedure TfrmMain.CreateDynamicReportMenu;
Begin
  MagReportMenu := TMag4Menu.Create(Self);
  With MagReportMenu Do
  Begin
        {    Insert on the Reports menu after DischargeSummaries item}
    MenuBarItem := Reports1;
    InsertAfterItem := MnuDischargeSummaries;
    OnNewItemClick := ReportItemSelected;
    MaxInsert := 20;
  End;
End;

Procedure TfrmMain.PatMenuitemSelected(Sender: Tobject);
Begin
    (*  P8t46  Mofified cMagMenu to accept an ID (string) this will stop the
       NIOS that reported a problem with '.' in dfn*)

  ChangeToPatient((Sender As TMagMenuItem).ID);
End;

Procedure TfrmMain.HelpMenuitemSelected(Sender: Tobject); //59
Begin
  Magexecutefile((Sender As TMagMenuItem).ID, '', '', SW_SHOW);
End;

Procedure TfrmMain.ReportItemSelected(Sender: Tobject);
Var
  WinHandle: Integer;
Begin
    {       Show the report window of clicked item }
  WinHandle := Strtoint((Sender As TMagMenuItem).ID); //TMagMenuItem is P8t46
  ShowWindow(WinHandle, SW_HIDE);
  ShowWindow(WinHandle, SW_SHOWNORMAL);
End;

Procedure TfrmMain.MnuSelectPatientClick(Sender: Tobject);
Begin
    { Access violations when Patient's selected too fast. }
    { Have to Retest 'developer testing', this was probably not the cause}
    { the LoadImagesMesssageWindow could have been only culprit}
  FDisablePatSelection := True;
  MnuFile.Enabled := False;
  Try
    Update;
 {debug94} WinMsg('s', '* * -- * *   - Patmenu click');
    PatientSelect('');
  Finally
    FDisablePatSelection := False;
    MnuFile.Enabled := True;
  End;
End;

Procedure TfrmMain.MnuHealthSummaryClick(Sender: Tobject);
Var
  t: Tstringlist;
Begin
  If (idmodobj.GetMagPat1.M_DFN = '') Then
  Begin
    WinMsg('d', 'You must first select a Patient ');
    Exit;
  End;
  If Not Doesformexist('MAGGRPTF') Then
  Begin
    Maggrptf := TMaggrptf.Create(Frmmain);
  End;
    {   Here we load information into Health Summary window.
         - Need to call a method of the window, not set info from Main Form.}
  Maggrptf.LoadHsTypeList;
  Maggrptf.PatDFN.caption := idmodobj.GetMagPat1.M_DFN; //inttostr(i); {DFN as String}
  Maggrptf.PatName.caption := idmodobj.GetMagPat1.M_NameDisplay;
  Maggrptf.PatDemog.caption := idmodobj.GetMagPat1.M_Demog;
  Maggrptf.caption := 'VistA Health Summary: ' + idmodobj.GetMagPat1.M_NameDisplay;
  FormToNormalSize(Maggrptf);
  Maggrptf.Show;
End;

Procedure TfrmMain.Reports1Click(Sender: Tobject);
Var
  i: Integer;
  Templist: TStrings;
Begin
  MagReportMenu.ClearAll;
  Templist := Tstringlist.Create;
  Try
    For i := Screen.CustomFormCount - 1 Downto 0 Do
    Begin
      If (Screen.CustomForms[i] Is TMaggrpcf) Then
                {'Report:' is the default caption for a blank form.}
        If (Screen.CustomForms[i].caption <> 'Report:') Then
          With TMaggrpcf(Screen.CustomForms[i]) Do
            MagReportMenu.AddItem(caption, Inttostr(Handle), caption
              + ': ' + PDesc.caption);
    End;
  Finally
    Templist.Free;
  End;

End;

Procedure TfrmMain.TbuttonsMouseMove(Sender: Tobject;
  Shift: TShiftState; x, y: Integer);
Begin
    {Keep. Gek.
    Prototype, out for now.  No longer doing the automatic display of little
      toolbars when mouse moves over the toolbutton.}
    //CheckPopups;
End;

Procedure TfrmMain.CheckPopups;
Begin
    {Prototype, out for now.  No longer doing the automatic display of little
      toolbars when mouse moves over the toolbutton.}
    (* if not FopenMenuPopups then
     begin
       if SliderWindowForm.visible then SliderWindowForm.Visible := false;
       if pagingcontrolsf.visible then pagingcontrolsf.visible := false;
     end;
     *)
End;

Procedure TfrmMain.TbpagecontrolsMouseMove(Sender: Tobject;
  Shift: TShiftState; x, y: Integer);
Begin
    // Not doing the automatich display of little toolbars when mouse moves over the toolbutton.
    (*if not Fopenpopups then if SliderWindowForm.visible then SliderWindowForm.Visible := false;
           if not pagingcontrolsf.visible Then
              begin
              dif := frmMain.height - frmMain.clientheight;
              case ToolBarMDI.align of
              altop : begin
                      L := frmMain.left+tbpagecontrols.left;
                      T := frmMain.top+ToolbarMDI.top+ToolbarMDI.height+dif-5;
                      end;
              alright : begin
                       L := frmMain.left+toolbarMDI.left-pagingcontrolsf.width;
                       T := frmMain.top+toolbarMDI.top+tbpagecontrols.top+dif-5;
                        end;
              alleft : begin
                       L := frmMain.left+toolbarMDI.left+toolbarMDI.width;
                       T := frmMain.top+toolbarMDI.top+tbpagecontrols.top+dif-5;
                       end;
              end; { case}
              pagingcontrolsf.setbounds(L,T,pagingcontrolsf.width,pagingcontrolsf.height);
              pagingcontrolsf.visible := true;
              end;
    pagingcontrolsf.bringtofront;*)
End;

Procedure TfrmMain.TbslidersMouseMove(Sender: Tobject;
  Shift: TShiftState; x, y: Integer);
Begin
    // Keep Code. Gek
   // Not doing the automatich display of little toolbars when mouse moves over the toolbutton.
   (*if not FopenMenuPopups then if pagingcontrolsf.visible then pagingcontrolsf.Visible := false;
          if not SliderWindowForm.visible Then
             begin
             dif := frmMain.height - frmMain.clientheight;
             case ToolBarMDI.align of
             altop : begin
                     L := frmMain.left+tbsliders.left;
                     T := frmMain.top+ToolbarMDI.top+ToolbarMDI.height+dif-5;
                     end;
             alright : begin
                      L := frmMain.left+toolbarMDI.left-SliderWindowForm.width;
                      T := frmMain.top+toolbarMDI.top+tbsliders.top+dif-5;
                       end;
             alleft : begin
                      L := frmMain.left+toolbarMDI.left+toolbarMDI.width;
                      T := frmMain.top+toolbarMDI.top+tbsliders.top+dif-5;
                      end;
             end; { case}
             SliderWindowForm.setbounds(L,T,SliderWindowForm.width,SliderWindowForm.height);
             SliderWindowForm.visible := true;
             end;
   sliderwindowform.bringtofront;
   *)
End;

Procedure TfrmMain.FormResize(Sender: Tobject);
Begin
  ResizePMain;
End;

Procedure TfrmMain.ResizePMain;
Var
  h: Integer;
Begin
    { When the window is resized, we compute the Min, Max, Height Width based on
      what toolbars are visible, and the length of text in the Demog info.
      Later, none too soon, we're getting rid of the 'Main window' putting the
      functionality into List Window. - - A window with a user defined layout of
      lists, abstracts, trees, Full Res.. }

  If (((PPatient.Width + PPatinfo2.Width + LbImagecount.Width) < Panel4.Width))
        {// and ( ppatinfo.parent = ppatinfo  ))then}Then
  Begin
    PPatinfo2.Visible := False;
    PPatinfo2.Align := alnone;
    PPatinfo2.Parent := Panel4;
    PPatinfo2.Left := LbImagecount.Left + LbImagecount.Width + 10;
    PPatinfo2.Align := alright;
    PPatinfo2.Visible := True;
    PPatInfo.Visible := False;
  End
  Else
  Begin
    PPatInfo.Visible := True;
    PPatinfo2.Parent := PPatInfo;
  End;
    ////////////
  h := Panel4.Height + 2;
  If PToolbar.Visible Then
    h := h + PToolbar.Height + 1;
  If PPatInfo.Visible Then
    h := h + PPatInfo.Height + 1;
  PMain.Height := h;

    //p48t2 dbi clientheight := PMSG.TOP+PMSG.HEIGHT;
  ClientHeight := Pnlbase.Top + Pnlbase.Height;
    // clientheight := h + pmsg.height;
End;

Procedure TfrmMain.View1Click(Sender: Tobject);
Begin
  If Doesformexist('frmGroupAbs') Then
    MnuGroupWindow.Enabled := (FrmGroupAbs.FGroupIEN <> '');
End;

Procedure TfrmMain.MnuGroupWindowClick(Sender: Tobject);
Begin
  FormToNormalSize(FrmGroupAbs);
End;

Procedure TfrmMain.ErrorCodelookup1Click(Sender: Tobject);
Begin
  Magexecutefile('ERRLOOK.EXE', '', '', SW_SHOW);
End;

Procedure TfrmMain.bDHCPrptClick(Sender: Tobject);
Begin
  MnuHealthSummaryClick(Self);
End;

Procedure TfrmMain.LbPatientMouseDown(Sender: Tobject; Button: TMouseButton;
  Shift: TShiftState; x, y: Integer);
Var
  PW, XPw: String;
Begin
    { prototype. UnDocumented, not for the faint of heart}
  If (Ssctrl In Shift) And (SsShift In Shift) Then
  Begin
    PW := Formatdatetime(' mm.dd.yy ', Now); //59
    XPw := FrmPasswordDlg.Execute;
    If PW = XPw Then
      LoadDevMenu;
  End;
  ForceRepaint;
End;

Procedure TfrmMain.ForceRepaint;
Begin
    { Invalidate didn't work. Update didn't work, this is funny, but it works.
       When we hide/show menu items, they don't always become visible so we need
       to refresh the window }
  Frmmain.Width := Frmmain.Width + 1;
  Update;
  Frmmain.Width := Frmmain.Width - 1;
  Update;
End;

Procedure TfrmMain.MImageDeleteHelpClick(Sender: Tobject);
Begin
  Magexecutefile(AppPath + '\MAGIMAGEDELETE.HLP', '', '', SW_SHOW);
End;

Procedure TfrmMain.MSysManhelpClick(Sender: Tobject);
Begin
  OpenSysManHelp;
End;

Procedure TfrmMain.OpenSysManHelp;
Begin
  Magexecutefile(AppPath + '\MagSysKey.hlp', '', '', SW_SHOW);
End;

Procedure TfrmMain.Legal1Click(Sender: Tobject);
Begin
  FrmMagLegalNotice.Execute;
End;

Procedure TfrmMain.MnuClinicalProceduresClick(Sender: Tobject);
Begin
  MagTIUWinf.SetPatientName(idmodobj.GetMagPat1.M_DFN, idmodobj.GetMagPat1.M_NameDisplay);
  MagTIUWinf.GetClinicalProcedures;
  FormToNormalSize(MagTIUWinf);
  MagTIUWinf.Show;
End;

{PROTOTYPE TESTING}

Procedure TfrmMain.OpenAdobe1Click(Sender: Tobject);
Begin
  Magexecutefile('AcroRd32.exe', '', '', SW_SHOW);
End;

Procedure TfrmMain.MnuScreenSettings1Click(Sender: Tobject);
Begin
  Magexecutefile(AppPath + '\MagScreen.hlp', '', '', SW_SHOW);
End;

{PROTOTYPE TESTING}

Procedure TfrmMain.ExplorePatientProcedures1Click(Sender: Tobject);
Var
  t: TStrings;
Begin
  t := Tstringlist.Create;
{/p94t2 gek, moved to no longer used.  This was the prototype for multi-Proc listing...  gone but not forgot.}
//    procedureListWindow.Loadfrombase(t, idmodobj.GetMagPat1);
//    procedureListWindow.show;

End;

Procedure TfrmMain.MnuImagelistFiltersClick(Sender: Tobject);
Begin
  ModifyImageListFilter;
End;

Procedure TfrmMain.ModifyImageListFilter;
Begin
  FrmImageList.GetFilter;
End;

Procedure TfrmMain.SetMagPat(Const Value: TMag4Pat);
Begin
    {  first Detach if we already have a patient Object}
  If (FMagpat <> Nil) Then
    FMagpat.Detach_(IMagObserver(Self));
  FMagpat := Value;
  If Value <> Nil Then
    AttachMyself();
End;

Procedure TfrmMain.AttachMyself;
Begin
  If Assigned(FMagpat) Then
  Begin
    FMagpat.Attach_(IMagObserver(Self));
  End;
End;

Procedure TfrmMain.FormDestroy(Sender: Tobject);
Begin
  Try
    DebugFile('TfrmMain.FormDestroy => At Beginning of FormDestroy');
        {JK 3/11/2009}
    If Assigned(FMagpat) Then
    Begin
      FMagpat.Detach_(IMagObserver(Self));
      FMagpat := Nil;
    End;
        // JMW p72 1/19/2007 - ensure the shared Image Gear components are destroyed
        // before closing the application. (prevents exception on close)
        // JMW P72 2/14/2007 - this is no longer needed here since each fMag4VGear14
        // component checks to see if it is last and then destroys the IG Manager as
        // needed
        //  destroyIGManager();
        //93 Free;
    DebugFile('TfrmMain.FormDestroy => At end of FormDestroy' + #13#10 +
      '================'); {JK 3/11/2009}
  Except
    On e: Exception Do
      DebugFile('TfrmMain.FormDestroy: UNHANDLED EXCEPTION = ' + e.Message
        + #13#10 + '================'); {JK 3/11/2009}
  End;

  {JK 10/5/2009 - Maggmsgu refactoring - note: had to put MagLogger.Close in the main form destory method
   since FMagMain is "shared" across different projects through the shared units. This prevents me from
   putting this method in the main unit's finalization section where it belongs.  Maybe this can be done
   later when a full refactoring is completed.}
// RCA close is not needed here. RCA  MagLogger.Close;
// the magDisplayMsg object closes maggmsgf
End;

Procedure TfrmMain.UpDate_(SubjectState: String; Sender: Tobject);
Var
  CCOWState: byte;
Begin
  Try
 {debug94} WinMsg('s', '* * -- * *   - frmMain.UPDATE_  SubjectState : ' + SubjectState);
    If (Sender = idmodobj.GetCCOWManager) Then
    Begin
  {debug94} WinMsg('s', '* * -- * *   - frmMain.UPDATE_  sender = idmodobj.GetCCOWManager');
      CCOWState := byte(Strtoint(SubjectState));

      ImgCCOWLink.Visible := CCOWState = 1;
      ImgCCOWchanging.Visible := CCOWState = 2;
      ImgCCOWbroken.Visible := CCOWState = 3;

      MnuContext.Visible := CCOWState > 0;
      MnuShowContext.Enabled := CCOWState = 1;
      MnuSuspendContext.Enabled := CCOWState = 1;
      MnuResumeGetContext.Enabled := CCOWState = 3;
      MnuResumeSetContext.Enabled := CCOWState = 3;
  {debug94} WinMsg('s', '* * -- * *   - frmMain.UPDATE_  sender = idmodobj.GetCCOWManager.' + ' exiting.');
      Exit;
    End;
    {TODO -cRefactor: This code and functionality needs to be moved out of Main Form }
    Try
  {debug94} WinMsg('s', '* * -- * *   - frmMain.UPDATE_  sender NOT idmodobj.GetCCOWManager');
      If (SubjectState = '') Then { '' => patient being Cleared}
      Begin
            {     HERE have to call all the close Patient functions.
                      from old Design, until new design is fully incorporated.{}
            //Patch 48 T5 only 1 esig per/patient.
            //93 AddDelKey('TMP MAG ESIG', false);
        mainInitializeKeyDependentObjects; {in Procedure : Update_()}
        PnlPatPhoto.Visible := False;
        ImageFilterMsgLoading('');
        ClearPatImages; // UpDate_   (Observer function)
        Application.Processmessages;
        UpdPatGUIData; //(FMagPat); // UpDate_   (Observer function)
      End
      Else
        If (SubjectState = '-1') Then { '-1' =>  MagPat1 is being destroyed}
        Begin
          PnlPatPhoto.Visible := False;
          FMagpat := Nil
        End
        Else { we have a new patient}
        Begin
            // HERE have to Update all the Patient windows to NEW Patient.
          If Doesformexist('EKGDisplayForm') Then
          Begin
            EKGDisplayForm.Close(); // p63
            EKGDisplayForm.Free(); // p63
          End;
          ImageFilterMsgLoading(FrmImageList.MagImageList1.ImageFilter.Name);
          LbImagecount.caption := FrmImageList.MagImageList1.ImageFilter.Name;
          LbImagecount.Hint := '';
          LbImagecount.Update;
          UpdPatGUIData; //(FMagPat); // UpDate_   (Observer function)
        End;
    Except
      On e: Exception Do
        Showmessage('Exception in Main Form: Patient Update_ ' + e.Message);
    End;
    ForceRepaint;
  Finally
  {debug94} WinMsg('s', '* * -- * *   - frmMain.update_  try finally- exiting.');

  End;
End;

Procedure TfrmMain.UpdPatGUIData;
Begin
  Try
  {debug94} WinMsg('s', '* * -- * *   - in UpdPatGUIData;');
    { TODO -cRefactor:  This'll will be taken care of later, when relevant objects are 'attached' to a
       Patient Object, and will clear themselves.  Instead of a form, having to 'Know'
          about all lists, forms, etc ,that are patient dependent. }

    {  checked for nil to stop  accessviolations;}
    If ((FMagpat = Nil) or (FMagpat.M_DFN = '')) Then
    Begin
  {debug94} WinMsg('s', '* * -- * *   -   ((FMagPat = nil) or (FMagPat.M_DFN = null))  exiting UpdPatGUIData;');
      PnlPatPhoto.Visible := False;
      ImageCountDisplay(True);
      mainImageCountDisplay;
      Exit;
    End;

    {/ P122 - JK 9/14/2011 P117 T6->T8 merged code. /}
    WinMsg('s', 'UpdPatGUIData: ' + FMagpat.M_NameDisplay + ' DFN: ' +   FMagpat.M_DFN);
    //WinMsg('s', 'UpdPatGUIData: ' + FMagpat.M_NameDisplay + ' SSN: ' +   FMagpat.M_SSN);

    {/ P122 with P123 patient ID additions - JK 8/11/2011 /}
    if GSess.Agency.IHS then
      WinMsg('s', 'UpdPatGUIData: ' + FMagpat.M_NameDisplay + ' SSN: ' + FMagpat.M_SSN)
    else
      WinMsg('s', 'UpdPatGUIData: ' + FMagpat.M_NameDisplay + ' HRN: ' + FMagpat.M_SSN);

    If CprsStartedME Then
    Begin
      MagPatMenu.MaxInsert := 1; // 03/22/2001
      FrmImageList.MagPatMenu.MaxInsert := 1;
    End;

    MagPatMenu.AddItem(FMagpat.M_NameDisplay, FMagpat.M_DFN, FMagpat.M_Demog);
    FrmImageList.MagPatMenu.AddItem(FMagpat.M_NameDisplay, FMagpat.M_DFN,
      FMagpat.M_Demog);
    UpdateWindowcaption;

    {  testing out -  ImageCountDisplay;  }
    EdtPatient.Text := FMagpat.M_NameDisplay;

    EdtPatient.Update;
    PPatinfo2.Update;
    EnablePatientButtonsAndMenus(True, MUSEenabled);
    mainEnablePatientButtonsAndMenus(True);
    Patientphoto;

  {debug94} WinMsg('s', '* * -- * *   - UpdPatGUIData: upref.AbsSHowWindow ' + Magbooltostr(Upref.AbsShowWindow));

(* gek 93 debug  stop opening windows when a patient is selected *)

    If Upref.AbsShowWindow Then {This is old setting. To Show Abs whenOpen Patient}
    Begin
        {we no longer want to show Abs Win if Abs is visible in Image List}
      If Not (FrmImageList.Visible And FrmImageList.PnlAbs.Visible) Then
        ShowAbstractWindow; //Testout in 93T10  Stop Abs window from showing if
      FrmImageList.AbThmGetMenuStateFromGUI; //gek 93t7
    End;
    If Upref.ShowImageListWin Then
    Begin
        //frmImageList.visible := true;
      FormToNormalSize(FrmImageList);
        //upreftoImageListWin(upref);
      FrmImageList.AbThmGetMenuStateFromGUI; //gek 93t7
    End;

    If (Userhaskey('MAGDISP CLIN')) Then
    Begin
      If Doesformexist('RadListWin') Then
      Begin
        if RadListWin.Visible then //117 had this, not sure why >> or upref.showRadListWin then  //117 querry upref also.
        Begin
          FormToNormalSize(Radlistwin);
          LoadRadListWin;
        End;
      End
      Else
        If Upref.ShowRadListWin Then
          LoadRadListWin;

      If Upref.Showmuse Then
        TbtnEKGClick(Self)
      Else
        If MUSEenabled Then
          WinMsg('', 'Click the ''EKG'' button to list patient EKG''s');

      If Upref.Shownotes Then
        MagTIUWinf.Visible := True;
      If MagTIUWinf.Visible Then
      Begin
        MagTIUWinf.SetPatientName(FMagpat.M_DFN, FMagpat.M_NameDisplay);
        MagTIUWinf.Refresh;
      End;
    End;
    WinMsg('', 'Patient: ' + FMagpat.M_NameDisplay);
  Finally
  {debug94} WinMsg('s', '* * -- * *   - Exiting UpdPatGUIData;');
  End;
End;

Procedure TfrmMain.MTest1Click(Sender: Tobject);
Begin
  MWrksCacheOn.Checked := FWrksAbsCacheON;
End;

{PROTOTYPE TESTING}

Procedure TfrmMain.MnuSecurityKeyAddDeleteClick(Sender: Tobject);
Begin
  MnukeyMagSystem.Checked := (Userhaskey('MAG SYSTEM'));
  MnuKeyMagdispadmin.Checked := (Userhaskey('MAGDISP ADMIN'));
  MnuKeyMagdispclin.Checked := (Userhaskey('MAGDISP CLIN'));
  MnuKeyMagPatPhotoOnly.Checked := (Userhaskey('MAG PAT PHOTO ONLY'));

End;

{PROTOTYPE TESTING}

Procedure TfrmMain.MnuKeyMagdispclinClick(Sender: Tobject);
Begin
    //SecurityKeyToggle
  AddDelKey('MAGDISP CLIN', MnuKeyMagdispclin.Checked);
  mainInitializeKeyDependentObjects; //59
End;

Procedure TfrmMain.MnukeyMagSystemClick(Sender: Tobject);
Begin

  AddDelKey('MAG SYSTEM', MnukeyMagSystem.Checked);
  mainInitializeKeyDependentObjects; //59
End;

{PROTOTYPE TESTING}



Procedure TfrmMain.GetCTPresets1Click(Sender: Tobject);
Var
  Rstat: Boolean;
  Rmsg, Presets: String;
Begin
  idmodobj.GetMagDBBroker1.RPCTPresetsGet(Rstat, Rmsg, Presets);
  Messagedlg('Get CT Presets: result = ' + Magbooltostr(Rstat) + '  ' + Rmsg +
    #13 + ' ' + Presets, Mtconfirmation, [Mbok], 0);
End;


{PROTOTYPE TESTING}

Procedure TfrmMain.SaveCTPresets1Click(Sender: Tobject);
Var
  Rstat: Boolean;
  Rmsg, Presets: String;
Begin
  Presets := InputBox('Enter Site CT Presets', 'Presets: ', '');
  idmodobj.GetMagDBBroker1.RPCTPresetsSave(Rstat, Rmsg, Presets);
  Messagedlg('Saved CT Presets: = ' + Presets + #13 + ' result = ' +
    Magbooltostr(Rstat) + ' ' + Rmsg, Mtconfirmation, [Mbok], 0);
End;

Procedure TfrmMain.MSystemManagerClick(Sender: Tobject);
Begin
  MSecurityON.Checked := idmodobj.GetMagFileSecurity.SecurityOn;
End;

Procedure TfrmMain.MnuDemoImagesClick(Sender: Tobject);
Begin
  If idmodobj.GetMagDBBroker1.IsConnected Then
    ImagingDisplayLogoff; //1b xbrokerx
    {   If user cancels the logoff, we cancel the switching of DataBases }
  If idmodobj.GetMagDBBroker1.IsConnected Then
    Exit; //1b xbrokerx

    {  Set to stop the Demo Login from showing the List of RPC Broker Servers to
       choose from }
  AllowRemoteLogin := False;
  MnuDemoImages.Checked := Not MnuDemoImages.Checked;
  If MnuDemoImages.Checked Then
  Begin
    SetDBDemo;
    MagPatPhoto1.MagDBBroker := idmodobj.GetMagDBBroker1;
    ImagingDisplayLogin('Demo DataBase', '1000', False);
    MnuLogin.Enabled := False;
    MnuLogout.Enabled := False;
    MnuRemoteLogin.Enabled := False;
    idmodobj.GetMagPat1.SelectPatient('Demo,Patient');
  End
  Else
  Begin
    SetDBMVista;
    MagPatPhoto1.MagDBBroker := idmodobj.GetMagDBBroker1;
    MnuLogin.Enabled := True;
    MnuLogout.Enabled := True;
    MnuRemoteLogin.Enabled := True;
  End;
End;
{PROTOTYPE }

Procedure TfrmMain.MnuDraggingSizingClick(Sender: Tobject);
Begin
  MnuDraggingSizing.Checked := Not MnuDraggingSizing.Checked;
  If Doesformexist('frmfullres') Then
  Begin
    FrmFullRes.MagViewerTB1.TbRefresh.Visible := MnuDraggingSizing.Checked;
        //    frmfullres.magViewerTB1.tbViewerSettings.visible := mnuDraggingSizing.Checked;
    FrmFullRes.Mag4Viewer1.IsSizeAble := MnuDraggingSizing.Checked;
  End;
  If Doesformexist('frmMagAbstracts') Then
    FrmMagAbstracts.Mag4Viewer1.IsDragAble := MnuDraggingSizing.Checked;
  If Doesformexist('frmGroupAbs') Then
    FrmGroupAbs.Mag4Viewer1.IsDragAble := MnuDraggingSizing.Checked;
  ChangeToPatient(idmodobj.GetMagPat1.M_DFN); // this does a refresh.
End;

{PROTOTYPE}

Procedure TfrmMain.MnuEnableDemoClick(Sender: Tobject);
Begin
  If MnuDemoImages.Checked Then
  Begin
    Messagebeep(MB_OK);
    If Not MnuEnableDemo.Checked Then
      MnuEnableDemo.Checked := True;
    Exit;
  End;
  MnuEnableDemo.Checked := Not MnuEnableDemo.Checked;
  MnuDemoImages.Visible := MnuEnableDemo.Checked;
End;

{PROTOTYPE}

Procedure TfrmMain.MnuGroupBrowsePlayClick(Sender: Tobject);
Begin
  MnuGroupBrowsePlay.Checked := Not MnuGroupBrowsePlay.Checked;
  FrmGroupAbs.MnuBrowsePlay.Visible := MnuGroupBrowsePlay.Checked;
End;

{PROTOTYPE}

Procedure TfrmMain.MnuFullResClick(Sender: Tobject);
Begin
  UprefToFullView(Upref);
End;

procedure TfrmMain.mnuFullResSpecialClick(Sender: TObject);          {p149}
begin

application.CreateForm(TfrmFullResSpecial,frmFullResSpecial);
frmFullResSpecial.Show;
end;

Procedure TfrmMain.TbtnListFilterWinClick(Sender: Tobject);
Begin
  ModifyImageListFilter;
End;

Procedure TfrmMain.TbtnAbstractsClick(Sender: Tobject);
Begin
  ShowAbstractWindow;
End;

Procedure TfrmMain.TbtnDHCPrptClick(Sender: Tobject);
Begin
  MnuHealthSummaryClick(Self);
End;

Procedure TfrmMain.TbtnEKGClick(Sender: Tobject);
Begin
  ShowEKGWindow;
End;

Procedure TfrmMain.ShowEKGWindow;
Var
  Tssn: String;
Begin
  If idmodobj.GetMagPat1.M_DFN = '' Then
  Begin
    WinMsg('d', 'You must enter a Patient before viewing MUSE EKGs.');
    Exit;
  End;

  //p130t11 dmmn 4/22/13
  if idmodobj.GetMagPat1.M_ISSN = '' then
  begin
    WinMsg('d', 'The patient doesn''t have a social security number for the MUSE EKGs.');
    Exit;
  end;

  TbtnEkg.Enabled := False;
  TbtnEkg.Cursor := crHourGlass;
  OpenEKGWin;
  UprefToMuseWindow(Upref);
  TbtnEkg.Enabled := True;
  TbtnEkg.Cursor := crDefault;

  //p130t11 dmmn 4/18/13 - use new SSN value for IHS sites since the usual SSN location is holding HRN
  // ISSN also have SSN for VA patients
  Tssn := Copy(idmodobj.GetMagPat1.M_ISSN, 1, 9);

  TbtnEkg.Enabled := False;
  TbtnEkg.Cursor := crHourGlass;
  WinMsg('', idmodobj.GetMagPat1.M_NameDisplay +
    ' : Searching MUSE Database for EKGs...');
  EKGDisplayForm.ChangePatient(idmodobj.GetMagPat1.M_NameDisplay, Tssn);
  TbtnEkg.Enabled := True;
  TbtnEkg.Cursor := crDefault;
  WinMsg('', '');
End; { end of bEKGClick }

Procedure TfrmMain.TbtnUserPrefClick(Sender: Tobject);
Begin
  OpenUprefWindow;
End;

Procedure TfrmMain.OpenUprefWindow;
Begin
    { TODO -cDialogs: Change this method to and Execute Method of the UserPref window }
  Application.CreateForm(TfrmUserPref, FrmUserPref);
  With FrmUserPref Do
  Begin
    UpreftoUprefwindow(Upref);
    Showmodal;
    UprefWindowSettingsToUpref(Upref);
    If Doesformexist('frmImageList') Then
    Begin
      If Upref.ShowImageListWin Then FormToNormalSize(FrmImageList);
      FrmImageList.ApplyFromUprefWindow;
    End;
    Free;
  End;
  LogActions('MAIN', 'UPREF', Duz);
End;

Procedure TfrmMain.TbtnPatientClick(Sender: Tobject);
{$IFDEF EUREKA TEST}
var     TESTOBJECT : TMag4menu;   {$ENDIF} // this is just for testing.    
Begin
    // Clicking patient button, doesn't do anything except put focus to patient edit field
    // Later, if ruth will allow, we'll get the edit field off on the window and open the lookup window
    // when button is clicked.

    {JK 2/11/2009 - changed from setting focus on the edtPatient TEdit to calling the
     P93 PatientSelect form}
    //-edtPatient.setfocus;
    //-edtPatient.SelectAll;

{$IFDEF EUREKA TEST}
//   FORCE ERROR,  TESTING EurekaLog  GEK;
TESTOBJECT.AddItem('Test','Test','Test');  // this is just for testing.
{$ENDIF}
  PatientSelect('');
End;

{PROTOTYPE}

Procedure TfrmMain.OpenImagebyID1Click(Sender: Tobject);
Begin
  OpenImageByID;
End;

{PROTOTYPE}

Procedure TfrmMain.OpenDialog1CanClose(Sender: Tobject;
  Var CanClose: Boolean);
Begin
    //Showmessage('open dialog1.canclose');
End;

Procedure TfrmMain.MnuPrototypesClick(Sender: Tobject);
Begin

End;

{PROTOTYPE TESTING}

Procedure TfrmMain.MnuSetDOSDirClick(Sender: Tobject);
Begin
    //
End;

Procedure TfrmMain.MnuOpenDirectoryClick(Sender: Tobject);
Begin
    // here we will allow to view directory images.
    // open in a New Viewer window ? keeping patient images open
    //   or
    // Close patient and open in Full Res window .? ?
End;

Procedure TfrmMain.ChDir1Click(Sender: Tobject);
Var
  s: String;
Begin
  GetDir(3, s);
  Showmessage('Current Directory : ' + s + #13 + 'Application  Path : ' +
    AppPath + #13 + #13 +
    'we will change current directory to Application Path');

  ChDir(AppPath);
End;

Procedure TfrmMain.ICN1Click(Sender: Tobject);
Var
  Dft, Str: String;
  Xmsg: String;
Begin
  Dft := '';
  Str := InputBox('Switch to ICN', 'ICN :  ', Dft);
  If Str <> '' Then
  Begin
    idmodobj.GetMagPat1.SwitchTopatient(Str, Xmsg, True, True);
    Showmessage('str : ' + Str + #13 + 'xmsg : ' + Xmsg);
  End;
End;

Procedure TfrmMain.RemoteBrokerDetails1Click(Sender: Tobject);
Var
  Info: String;
  i: Integer;
Begin
{RCA- This function is from testing menu.  I took out MagRemoteBroker access
  from main form .  So this doesn't give everything it used to.
  If needed,  then modify the called unit MagRemoteBrokerManater1 to return
    status description.
    }
  Info := '';
  Info := 'Remote Brokers: ' +
    Inttostr(MagRemoteBrokerManager1.GetBrokerCount()) + #13;
  Info := Info + 'Max Remote Brokers: ' +
    Inttostr(MagRemoteBrokerManager1.GetMaxBrokerCount()) + #13;
  For i := 0 To MagRemoteBrokerManager1.GetBrokerCount() - 1 Do
  Begin
    Info := Info + 'RemoteBroker[' + Inttostr(i) + ']: [' +
      MagRemoteBrokerManager1.RemoteBrokerArray[i].GetServerName + ',' +
      Inttostr(MagRemoteBrokerManager1.RemoteBrokerArray[i].GetServerPort) +
      '] ServerStatus: ' +
    //RCA OUT  MagRemoteBroker.GetStatusDetails(MagRemoteBrokerManager1.RemoteBrokerArray[i].GetServerStatus) +  ', PatientStatus: ' +
    //RCA OUT.  MagRemoteBroker.GetStatusDetails(MagRemoteBrokerManager1.RemoteBrokerArray[i].GetPatientStatus) +
         #13;
  End;

  Showmessage(Info);
End;

Procedure TfrmMain.RIVRecieveUpdate_(action: String; Value: String);
// recieve updates from everyone
Var
  Count: String;
Begin
  If action = 'RefreshPatient' Then
  Begin
    If idmodobj.GetMagPat1.M_DFN <> '' Then
      ChangeToPatient(idmodobj.GetMagPat1.M_DFN);
  End
  Else
    If action = 'ConnectingRemote' Then                          {brkpt 1}
    Begin
      WinMsg('', 'Connecting to remote site [' + Value + '] ...');
    End
    Else
      If action = 'DODSite' Then
      Begin
        WinMsg('', 'No interface to DOD site [' + Value + ']');
      End
      Else
        If action = 'Announcement' Then
        Begin
          WinMsg('', Value);
        End
        Else
          If action = 'UpdateImageCount' Then
          Begin
            If idmodobj.GetMagPat1 <> Nil Then
            Begin
              Count := MagPiece(Value, '^', 2);
              idmodobj.GetMagPat1.AddImagesToCount(Strtoint(Count));
              ImageCountDisplay(False);
              mainImageCountDisplay;
            End;
          //JMW 10/22/2010 P106/P117 Start
          End
          Else
            If action = '' Then
            Begin
              If idmodobj.GetMagPat1 <> Nil Then
              Begin
                idmodobj.GetMagPat1.clearVIXImageCount();
              End;
            End;
          //JMW 10/22/2010 P106/P117 End
End;

Procedure TfrmMain.TestStartCloseProcess(Sender: Tobject);
Var
  Proc_info: TprocessInformation;
  Startinfo: TStartupInfo;
  Exitcode: LongWord;
Begin
    // Initialize the structures
  FillChar(Proc_info, SizeOf(TprocessInformation), 0);
  FillChar(Startinfo, SizeOf(TStartupInfo), 0);
  Startinfo.cb := SizeOf(TStartupInfo);

    // Attempts to create the process
  If CreateProcess('C:\WINDOWS\system32\mplay32.exe', Nil, Nil,
    Nil, False, NORMAL_PRIORITY_CLASS, Nil, Nil,
    Startinfo, Proc_info) <> False Then
  Begin
        // The process has been successfully created
        // No let's wait till it ends...
    WaitForSingleObject(Proc_info.HProcess, INFINITE);
        // Process has finished. Now we should close it.
    GetExitCodeProcess(Proc_info.HProcess, Exitcode); // Optional
    CloseHandle(Proc_info.HThread);
    CloseHandle(Proc_info.HProcess);
    Application.MessageBox(
      PChar(Format('Notepad finished! (Exit code=%d)', [Exitcode])),
      'Info', MB_ICONINFORMATION);
  End
  Else
  Begin
        // Failure creating the process
    Application.MessageBox('Couldn''t execute the '
      + 'application', 'Error', MB_ICONEXCLAMATION);
  End; //if
End;

Procedure TfrmMain.TbtnRIVConfigureClick(Sender: Tobject);
Begin
  RIVNotifyAllListeners(Self, 'ShowConfiguration', '');
End;

Procedure TfrmMain.ManuallyConnecttoRemoteSite1Click(Sender: Tobject);
Var
  Sitecode: String;
  UserSSN: String;
Begin
    //^site code
  Sitecode := InputBox('Manually connect to remote site', 'Enter site code',
    '405');
  If Sitecode = '' Then
    Exit;

  If MagRemoteBrokerManager1.GetUserSSN() = '' Then
  Begin
    {/ P122 with P123 patient ID additions - JK 8/11/2011 /}
    if GSess.Agency.IHS then
      UserSSN := InputBox('Please enter your SSN: ', 'SSN Needed', '')
    else
      UserSSN := InputBox('Please enter your NRN: ', 'HRN Needed', '');

    If UserSSN = '' Then
      Exit;
    MagRemoteBrokerManager1.SetUserSSN(UserSSN);
  End;

  If MagRemoteBrokerManager1.GetUserLocalDUZ() = '' Then
    MagRemoteBrokerManager1.SetUserLocalDUZ(idmodobj.GetMagDBBroker1.GetBroker.User.Duz);
  If MagRemoteBrokerManager1.GetUserFullName() = '' Then
    MagRemoteBrokerManager1.SetUserFullName(idmodobj.GetMagDBBroker1.GetBroker.User.Name);

  If MagRemoteBrokerManager1.CreateBrokerFromSiteCodes(Sitecode) Then
  Begin
    Showmessage('connection created');
  End
  Else
  Begin
    Showmessage('there was an error connecting to your site');
  End;
End;

//45 end change

{p59 Display a menu item for any magWhatsNew* or magReadMe*}

Procedure TfrmMain.LoadHelpMenu; //59
Var
  Dir, Mask, Filters: String;
  Maskitem: Integer;
  Sr: TSearchRec;
  //whatsnew: String;
Begin
  //p130t10 dmmn 3/4/13 - this is no longer needed
  //whatsnew := AppPath + '\MagWhats New in Patch 93.pdf';

    {      the file is named : 'MagWhats New in Patch 93.pdf'}
  {If FileExists(whatsnew) Then
  Begin
    mnuHelpWhatsNewinPatch93.Visible := True;
  End;
  }

  If FindFirst(AppPath + '\MagImageDisplayHelpItem-*.*', FaAnyFile, Sr) = 0 Then
  Begin
    If FileExists(AppPath + '\' + Sr.Name) Then
      MagHelpMenu.AddItem(MagPiece(Copy(Sr.Name, 25, 999), '.', 1), AppPath +
        '\' + Sr.Name, '');
    While FindNext(Sr) = 0 Do
    Begin
      If FileExists(AppPath + '\' + Sr.Name) Then
        MagHelpMenu.AddItem(MagPiece(Copy(Sr.Name, 25, 999), '.', 1), AppPath
          + '\' + Sr.Name, '');
      WinMsg('s', 'Help Menu Added : ' + Sr.Name);
    End;
  End;

  If FindFirst(AppPath + '\MagREADME*.*', FaAnyFile, Sr) = 0 Then
  Begin
    If FileExists(AppPath + '\' + Sr.Name) Then
      MagHelpMenu.AddItem(MagPiece(Copy(Sr.Name, 4, 999), '.', 1), AppPath +
        '\' + Sr.Name, '');
    While FindNext(Sr) = 0 Do
    Begin
      If FileExists(AppPath + '\' + Sr.Name) Then
        MagHelpMenu.AddItem(MagPiece(Copy(Sr.Name, 4, 999), '.', 1), AppPath
          + '\' + Sr.Name, '');
      WinMsg('s', 'Help Menu Added : ' + Sr.Name);
    End;
  End;

  If FindFirst(AppPath + '\MagWhatsNew*.*', FaAnyFile, Sr) = 0 Then
  Begin
    If FileExists(AppPath + '\' + Sr.Name) Then
      MagHelpMenu.AddItem(MagPiece(Copy(Sr.Name, 4, 999), '.', 1), AppPath +
        '\' + Sr.Name, '');
    While FindNext(Sr) = 0 Do
    Begin
      If FileExists(AppPath + '\' + Sr.Name) Then
        MagHelpMenu.AddItem(MagPiece(Copy(Sr.Name, 4, 999), '.', 1), AppPath
          + '\' + Sr.Name, '');
      WinMsg('s', 'Help Menu Added : ' + Sr.Name);
    End;
  End;

End;

{PROTOTYPE TESTING}

Procedure TfrmMain.EdtPatientDblClick(Sender: Tobject);
Begin
  If DUZName = '1216^KIRIN,GARRETT EDWARD' Then
    PatientSelect('test');
End;

{PROTOTYPE TESTING}

Procedure TfrmMain.VerifyImages1Click(Sender: Tobject);
Var
  Frmallimages: TfrmImageList;
Begin
  Application.CreateForm(TfrmVerify, frmVerify);
  frmVerify.UserPrefsApply(Upref);
  Application.Processmessages;
  frmVerify.Showmodal;
End;

Procedure TfrmMain.WebHelp1Click(Sender: Tobject);
Begin
  FrmWebHelp.Show;
  FrmWebHelpMapping.Show;
End;

Function TfrmMain.ApplicationEvents1Help(Command: Word; Data: Integer;
  Var CallHelp: Boolean): Boolean;

Var
  s, Helpdoc: String;
  Fullhelppath: String;
  Flags: OLEVariant;
Begin

  Case Command Of
    HELP_COMMAND:
      Begin
        s := 'HELP_COMMAND' + ' ' + Inttostr(Data);
      End;
    HELP_CONTEXT:
      Begin
        If Data = 7 Then
        Begin
                     {from Workstation configuration form.  it uses Win HElp}
          Exit;
        End;
        s := 'HELP_CONTEXT' + ' ' + Inttostr(Data);
        If MnuUseInternetExplorerforhelp.Checked Then
        Begin
          If Data = 0 Then
          Begin
            Magexecutefile(AppPath + '\Help\Client\index.html', '', '', SW_SHOW)
          End
          Else
          Begin
            Helpdoc := FrmWebHelpMapping.ValueListEditor1.Values[Inttostr(Data)];
            Magexecutefile(AppPath + '\Help\Client\' + Helpdoc, '', '', SW_SHOW);
          End;
        End
        Else
        Begin
          FrmWebHelp.Show;
          Helpdoc := FrmWebHelpMapping.ValueListEditor1.Values[Inttostr(Data)];
                    //frmWebHelp.WebBrowser1.Navigate(WideString(AppPath + '\Help\Client\index.htm#' + helpdoc),Flags, Flags, Flags, Flags);
          Fullhelppath := AppPath + '\Help\Client\' + Helpdoc;
          FrmWebHelp.WebBrowser1.Navigate(WideString(Fullhelppath), Flags, Flags, Flags, Flags);
        End;
        CallHelp := False;
      End;
  Else
    s := 'SOMETHING_ELSE';
  End;

  WinMsg('s', 'Help : ' + s + '  ' + Inttostr(Data));
End;

(*  This copy below was in p93t12  *)
(* function TfrmMain.ApplicationEvents1Help(Command: Word; Data: Integer;
    var CallHelp: Boolean): Boolean;

var
    s, helpdoc: string;
    fullhelppath: string;
    flags: OLEVariant;
    VIhelpindex: string;
begin
    VIHelpindex := 'VIHelpv008.htm';
    case command of
        HELP_COMMAND:
            begin
                S := 'HELP_COMMAND' + ' ' + inttostr(data);
            end;
        HELP_CONTEXT:
            begin
                if data = 7 then
                begin
                    {from Workstation configuration form.  it uses Win HElp}
                    exit;
                end;
                S := 'HELP_CONTEXT' + ' ' + inttostr(data);
                if mnuUseInternetExplorerforhelp.Checked then
                begin
                    if data = 0 then
                    begin
                        //magExecuteFile(AppPath + '\Help\Client\index.html', '', '', SW_SHOW)
                        magExecuteFile(AppPath + '\Help\Client\VIHelpv008.htm', '', '', SW_SHOW)
                    end
                    else
                    begin
                        helpdoc :=  frmWebHelpMapping.valuelisteditor1.Values[inttostr(data)];
                        {    In patch 93, the HTML files are all in root directory}//patch 93
                           { greater than 10224 are new Topics for 93...  extract file name..  would probably still work, }
                        if (data < 10224) then helpdoc := extractfilename(helpdoc);   // this was the way for 93
                        helpdoc := VIhelpindex + '#' + helpdoc;
                        magExecuteFile(AppPath + '\Help\Client\' + helpdoc, '', '', SW_SHOW);
                    end;
                end
                else
                begin
                    frmWebHelp.Show;
                    helpdoc :=
                        frmWebHelpMapping.valuelisteditor1.Values[inttostr(data)];
                    //frmWebHelp.WebBrowser1.Navigate(WideString(AppPath + '\Help\Client\index.htm#' + helpdoc),Flags, Flags, Flags, Flags);
                    {   in patch 93 the help files are in the 'client' directory, not subdirectories.}
                    helpdoc := extractfilename(helpdoc);
                    fullhelppath := AppPath + '\Help\Client\' + helpdoc;
                    frmWebHelp.WebBrowser1.Navigate(WideString(fullhelppath), Flags, Flags, Flags, Flags);
                end;
                callhelp := false;
            end;
    else
        S := 'SOMETHING_ELSE';
    end;

    winmsg('s', 'Help : ' + s + '  ' + inttostr(data));
end;  *)

(*

     // Combine Help Direoctory path with topic filename associated with the Map #
  topicFileName := HelpDir+TopicMapNumber[mapNumber];
     // Load the Help topic into the WebBrowser component
  WebBrowser1.Navigate(WideString(topicFileName), Flags, Flags, Flags, Flags);
     // If Help frame is not displayed then display it
  ShowHelpFrame();
end;
*)

Procedure TfrmMain.UseOldHelp1Click(Sender: Tobject);
Begin
  Magexecutefile(AppPath + '\MagImaging.hlp', '', '', SW_SHOW);
End;

Procedure TfrmMain.MnuRIVClick(Sender: Tobject);
Begin
  RIVNotifyAllListeners(Self, 'ShowConfiguration', '');
    //  RIVNotifyAllListeners(self,'ShowConfiguration', '');
End;

Procedure TfrmMain.ListAppOpenForms1Click(Sender: Tobject);
Begin
  Showopenforms(False);
End;

Procedure TfrmMain.Windows1Click(Sender: Tobject);
Begin
  SwitchToForm;
End;

Procedure TfrmMain.MnuIconShortCutKeyLegendClick(Sender: Tobject);
Begin
  IconShortCutLegend;
End;

Procedure TfrmMain.MnuUseInternetExplorerforhelpClick(Sender: Tobject);
Begin
  MnuUseInternetExplorerforhelp.Checked := Not
    MnuUseInternetExplorerforhelp.Checked;
End;

Procedure TfrmMain.MnuMessageLogClick(Sender: Tobject);
Begin
    //maggmsgf.show;  {JK 10/5/2009 - Maggmsgu refactoring - removed old methods}
    //maggmsgf.BringToFront;  {JK 10/5/2009 - Maggmsgu refactoring - removed old methods}
  MagAppMsgShow; {JK 10/5/2009 - Maggmsgu refactoring}
End;

Procedure TfrmMain.MnuShowContextClick(Sender: Tobject);
Begin
  idmodobj.GetCCOWManager.ShowContextData;
    //if not (maggmsgf.Visible) then  {JK 10/5/2009 - Maggmsgu refactoring - removed old methods}
    //    maggmsgf.Visible := true;   {JK 10/5/2009 - Maggmsgu refactoring - removed old methods}
    // make the System messages scroll to the bottom to show the CCOW
    // context information
    //maggmsgf.sysmemo.SelStart := length(maggmsgf.sysmemo.Text);  {JK 10/5/2009 - Maggmsgu refactoring - removed old methods}
    //maggmsgf.sysmemo.SelLength := 0;   {JK 10/5/2009 - Maggmsgu refactoring - removed old methods}
End;

Procedure TfrmMain.MnuSuspendContextClick(Sender: Tobject);
Begin
  idmodobj.GetCCOWManager.SuspendContextLink;
  CprsSync.SyncOn := False;
    // JMW 2/3/2006 p46, turn off sync (to not listen to any windows messages)
End;

Procedure TfrmMain.MnuResumeGetContextClick(Sender: Tobject);
Begin
  idmodobj.GetCCOWManager.ResumeGetContext;
End;

Procedure TfrmMain.MnuResumeSetContextClick(Sender: Tobject);
Begin
  idmodobj.GetCCOWManager.ResumeSetContext;
End;

Procedure TfrmMain.DemoRemoteSites1Click(Sender: Tobject);
Begin
  DemoRemoteSites1.Checked := Not DemoRemoteSites1.Checked;
  MagRemoteBrokerManager.DemoRemoteSites := DemoRemoteSites1.Checked;
End;

Procedure TfrmMain.MnuTestSimulateMessageFromCPRS1Click(Sender: Tobject);
Var
  WinMsg: String;
Begin

End;

Procedure TfrmMain.TimerStickToCPRSTimer(Sender: Tobject);
Begin
  AttachtoCPRSTop;
End;

Procedure TfrmMain.AttachtoCPRSTop;
Var
  Wrect: Trect;
  Vhand: Integer;
Begin
  Vhand := 0;
  If CprsSync.CprsHandle > 0 Then
  Begin
    GetWindowRect(CprsSync.CprsHandle, Wrect);
    Top := Wrect.Top - Height;
    Left := Wrect.Left;
    If Top < 0 Then
    Begin
      Top := 0;
            // SetWindowPos(CPRSSync.CPRSHandle,CPRSSync.CPRSHandle,wrect.left+10,0+height,0,0,0);
    End;
    If Left < 0 Then
      Left := 0;
  End;

End;

Procedure TfrmMain.MnuStickToCPRSClick(Sender: Tobject);
Begin
  TimerStickToCPRS.Enabled := MnuStickToCPRS.Checked;
End;

Procedure TfrmMain.btnTestResClick(Sender: Tobject);
Var
  bBitmap: TBitmap;
Begin
    (* bBitmap := TBitmap.Create;
     try
      bBitmap.Handle := LoadBitmap(hInstance, 'IDMISMATCH');
      Image1.Width := bBitmap.Width;
      Image1.Height := bBitmap.Height;
      Image1.Canvas.Draw(0,0,bBitmap);
     finally
      bBitmap.Free;
     end;
     *)
End;
{   Load the dev menus if it is Garrett}

Procedure TfrmMain.LoadDevMenu;
Begin


End;

Procedure TfrmMain.MnuLocal9300Click(Sender: Tobject);
Begin
  Locallogin9300;
End;

Procedure TfrmMain.Locallogin9300;
Begin
  If idmodobj.GetMagDBBroker1.IsConnected Then
    ImagingDisplayLogoff;
    { User selected to Not Logout.}
  If idmodobj.GetMagDBBroker1.IsConnected Then
    Exit;
  AllowRemoteLogin := False;
  ImagingDisplayLogin('127.0.0.1', '9300', False);
End;

Procedure TfrmMain.MnuLocal9400Click(Sender: Tobject);
Begin
  Locallogin9400;
End;

Procedure TfrmMain.Locallogin9400;
Var
  Rmsg: String;
Begin
  If idmodobj.GetMagDBBroker1.IsConnected Then
    ImagingDisplayLogoff;
    { User selected to Not Logout.}
  If idmodobj.GetMagDBBroker1.IsConnected Then
    Exit;
  AllowRemoteLogin := False;
  ImagingDisplayLogin('127.0.0.1', '9400', False);
  MagPat.SwitchTopatient('1033', Rmsg)
End;

Procedure TfrmMain.Print1Click(Sender: Tobject);
Var
  Reason: String;
Begin
  idmodobj.GetMagUtilsDB1.GetReason(1, Reason);
  Self.WinMsg('', 'Reason : ' + Reason);
End;

Procedure TfrmMain.Copy1Click(Sender: Tobject);
Var
  Reason: String;
Begin
  idmodobj.GetMagUtilsDB1.GetReason(2, Reason);
  Self.WinMsg('', 'Reason : ' + Reason);
End;

Procedure TfrmMain.Delete1Click(Sender: Tobject);
Var
  Reason: String;
Begin
  idmodobj.GetMagUtilsDB1.GetReason(3, Reason);
  Self.WinMsg('', 'Reason : ' + Reason);
End;

Procedure TfrmMain.Status1Click(Sender: Tobject);
Var
  Reason: String;
Begin
  idmodobj.GetMagUtilsDB1.GetReason(4, Reason);
  Self.WinMsg('', 'Reason : ' + Reason);
End;

Procedure TfrmMain.ImageStatusNoDeleteNoInProgress1Click(Sender: Tobject);
Var
  FMSet: TImageFMSet;
  s, S1: String;
Begin
  FMSet := TImageFMSet.Create;
  s := XwbGetVarValue2('$P($G(^DD(2005,113,0)),U,3)');
  FMSet.DBSetDefinition := s;
  FMSet.DBSetName := 'Status';
  FTestingStatus := FrmFMSetSelect.Execute(FMSet, FTestingStatus, True,
    'Deleted,In Progress');
  If FTestingStatus = '' Then
    FTestingStatus := 'null';
  WinMsg('', FTestingStatus);
End;

Procedure TfrmMain.ImagePackage1Click(Sender: Tobject);
Var
  FMSet: TImageFMSet;
  s, S1: String;
Begin
  FMSet := TImageFMSet.Create;
  s := XwbGetVarValue2('$P($G(^DD(2005,40,0)),U,3)');
  FMSet.DBSetDefinition := s;
  FMSet.DBSetName := 'Package';
  FTestingPkg := FrmFMSetSelect.Execute(FMSet, FTestingPkg);
  If FTestingPkg = '' Then
    FTestingPkg := 'null';
  WinMsg('', FTestingPkg);
End;

Procedure TfrmMain.MnuTESTImageStatus1Click(Sender: Tobject);
Var
  FMSet: TImageFMSet;
  s, S1: String;
Begin
  FMSet := TImageFMSet.Create;
  s := XwbGetVarValue2('$P($G(^DD(2005,113,0)),U,3)');
  FMSet.DBSetDefinition := s;
  FMSet.DBSetName := 'Status';
  FTestingStatus := FrmFMSetSelect.Execute(FMSet, FTestingStatus);
  If FTestingStatus = '' Then
    FTestingStatus := 'null';
  WinMsg('', FTestingStatus);
End;

Procedure TfrmMain.StripLeadTrailComma1Click(Sender: Tobject);
Var
  s, S1: String;
Begin
  s := InputBox('s', 's', ',string,');
  Pmsg.caption := s;
  S1 := StripFirstLastComma(s);

  Pmsg.caption := s + '  :   ' + S1;
End;

Procedure TfrmMain.UseOldImageListCallMAG4PATGETIMAGES1Click(
  Sender: Tobject);
Begin
  DebugUseOldImageListCall := UseOldImageListCallMAG4PATGETIMAGES1.Checked;
End;

Procedure TfrmMain.DreamWeverWebHelpFiles1Click(Sender: Tobject);
Var
  Flags: OLEVariant;
  Val: String;
  Fullname: String;
Begin
    // Form2.Show;
   //  {this was in the example} Form2.WebBrowser1.Navigate(WideString(GetCurrentDir+'\CamaroHelp\WebHelp\camarohelp.htm'), Flags, Flags, Flags, Flags);
   //  {try getting from web}Form2.WebBrowser1.Navigate(WideString('\\10.2.29.231\helpfiles\site\VIHelpv001\!SSL!\WebHelp\index.htm#Capturing_images_&_documents_to_patient_records\Completing_the_Capture\Validate_Image_Data.htm'),Flags, Flags, Flags, Flags);
   //  {the subtopic to open} #Capturing_images_&_documents_to_patient_records\Completing_the_Capture\Acquiring_the_Image.htm
    {try getting from interactive}

   ///////////val := lstboxgood.Items[lstbxgood.itemindex];
   ////////// val := magpiece(val,'=',2);
   //frmWebHelp.WebBrowser1.Navigate(WideString(apppath +'\help\client\index.htm#'+val),Flags, Flags, Flags, Flags);

  Val :=
    'originalHelpSystem\what_s_new\patch_45_changes_for__remote_image_views_\remote_image_views_configuration_dialog_(teleophthalmology).htm';
  Fullname := AppPath + '\help\client\' + Val;
  FrmWebHelp.WebBrowser1.Navigate(WideString(Fullname), Flags, Flags, Flags,
    Flags);

  Application.Processmessages;
    //////lstbxgood.SetFocus;
    //////lstbxgood.Update;
End;

Procedure TfrmMain.MnuKeyMagdispadminClick(Sender: Tobject);
Begin

  AddDelKey('MAGDISP ADMIN', MnuKeyMagdispadmin.Checked);
  mainInitializeKeyDependentObjects; //59
End;

Procedure TfrmMain.MnuKeyMagPatPhotoOnlyClick(Sender: Tobject);
Begin
  AddDelKey('MAG PAT PHOTO ONLY', MnuKeyMagPatPhotoOnly.Checked);
  mainInitializeKeyDependentObjects;
End;

Procedure TfrmMain.MnuSelectKeyClick(Sender: Tobject);
Var
  Key: String;
Begin
  Key := InputBox('Security Key:', 'Select Security to Add/Del', '');
  If Key <> '' Then
  Begin
    AddDelKey(Key, (Not Userhaskey(Key)));
    mainInitializeKeyDependentObjects;
  End;
End;

Procedure TfrmMain.MnuTestPatOnlyLookup1Click(Sender: Tobject);
Begin
  FrmPatPhotoOnly.Execute(Duz, idmodobj.GetMagDBBroker1, idmodobj.GetMagFileSecurity);
  Messagedlg('For user''s that have the ''MAG PAT PHOTO ONLY'' security key '
    + #13 + 'the application would now exit.', Mtinformation, [Mbok], 0);
End;

procedure TfrmMain.mnuTestScriptDontUseCCOWClick(Sender: TObject);
begin
GDontUseCCOW := mnuTestScriptDontUseCCOW.checked;            {p149}
end;

Procedure TfrmMain.DoPatPhotoOnly;
Begin
  MagRemoteBrokerManager1 := Nil;
  Frmmain.Visible := False;
  FrmPatPhotoOnly.Execute(Duz, idmodobj.GetMagDBBroker1, idmodobj.GetMagFileSecurity);
  Application.Terminate;
End;

Procedure TfrmMain.mnuMainQAReviewClick(Sender: Tobject);
Begin
    //   Application.CreateForm(TfrmVerify, frmVerify);
    //   upreftoVerifywin(upref);
    //   Application.ProcessMessages;
    //   frmVerify.fduz := duz; {JK 1/2/2009 - fixed defect #36}
    //   frmVerify.ShowModal;

//  frmVerify.Execute(Upref, Duz);
  {/117  decouple frmVerify from idmodobj.Get}
    frmVerify.execute(upref, duz, idmodobj.GetMagDBBroker1); //117

End;

Procedure TfrmMain.mnuMainUtilitiesClick(Sender: Tobject);
Begin
{/p117 gek  T1   added MAG QA REVIEW key..   }
       { TODO -ogarrett -c117 : does MAG EDIT still give access to QA Review functions }
  mnuMainQAReview.Enabled := (Userhaskey('MAG EDIT')
                           or Userhaskey('MAG QA REVIEW')
                           or Userhaskey('MAG SYSTEM'));
  mnuMainQAReviewReport.Enabled := mnuMainQAReview.Enabled;
End;

Procedure TfrmMain.mnuTestmagpubUnSelectAllClick(Sender: Tobject);
Begin
  ImagesForCPRSTIUNote('');
End;

Procedure TfrmMain.HideMainForm;
Begin
  Self.WindowState := Wsminimized;
End;

Procedure TfrmMain.AppMinimize(Sender: Tobject);
Begin
    // application is minimizing;
  FIsAppMinimized := True;
End;

Procedure TfrmMain.AppRestore(Sender: Tobject);
Begin
    // application is restoring;
  FIsAppMinimized := False;
End;

Procedure TfrmMain.mnuMainQAReviewReportClick(Sender: Tobject);
Begin
  OpenVerifyReport(Self, '', '', ''); {/ P117 - JK 8/30/2010 - added the Self parameter /}
End;

Procedure TfrmMain.SetTimeoutto2seconds1Click(Sender: Tobject);
Begin
  TimerTimeout.Interval := 5000;
End;

Procedure TfrmMain.mnuHelpWhatsNewinPatch93Click(Sender: Tobject);
//Var
//  whatsnew: String;
Begin
  //p130t10 dmmn 3/4/13 - no longer needed
  {
  whatsnew := AppPath + '\MagWhats New in Patch 93.pdf';
          the file is named : 'MagWhats New in Patch 93.pdf'
  If FileExists(whatsnew) Then
  Begin
    Magexecutefile(whatsnew, '', '', SW_SHOW);
  End;
  }
End;

Procedure TfrmMain.mainImageCountDisplay(ClearCount: Boolean = False);
Var
  s: String;
Begin
  If ClearCount Then
  Begin
    mainImageCountUpdate('', '', '');
    Exit;
  End;
  If Application.Terminated Then Exit;
  If idmodobj.GetMagPat1.M_DFN = '' Then
    s := ''
  Else
    s := Inttostr(FrmImageList.MagListView1.Items.Count) + ' of ' +
      idmodobj.GetMagPat1.M_TotalImageCount + ' Images match Filter';
  mainImageCountUpdate(s, FrmImageList.MagImageList1.ListName, FrmImageList.MagImageList1.ListDesc);
End;

Procedure TfrmMain.mainImageCountUpdate(ctDesc, Fltname, Fltdesc: String);
Begin
  With Frmmain Do
  Begin
    LbImagecount.caption := ' ' + ctDesc + ': " ' + Fltname + ' "';
    LbImagecount.Hint := ctDesc;
    If ctDesc <> '' Then
    Begin
      MagAppMsg('', 'Image Filter: " ' + Fltname + ' "   ' + ctDesc); {JK 10/6/2009 - Maggmsgu refactoring}
      LbImagecount.Hint := '" ' + Fltname + ' "  ' + ctDesc + ' ' + ' Desc: ' + Fltdesc;
      MagAppMsg('s', 'Filter Desc: ' + Fltname); {JK 10/6/2009 - Maggmsgu refactoring}
      MagAppMsg('s', '   ' + Fltdesc); {JK 10/6/2009 - Maggmsgu refactoring}
    End;
  End;
End;

Procedure TfrmMain.mainEnablePatientButtonsAndMenus(Status: Boolean);
Begin

  TbtnImageListWin.Enabled := Status;
  TbtnAbstracts.Enabled := Status;
  TbtnEkg.Enabled := Status;
  TbtnDHCPRpt.Enabled := Status;

  MnuRefreshPatientImages.Enabled := Status;
  MnuClearPatient.Enabled := Status;
  MnuImagelist.Enabled := Status;
  MnuAbstracts.Enabled := Status;
  MnuHealthSummary.Enabled := Status;
  MnuPatientProfile.Enabled := Status;
  MnuDischargeSummaries.Enabled := Status;
  MnuPreFetch.Enabled := Status And (SecurityKeys.Indexof('MAG PREFETCH') > -1);
  {   The next menu items, etc depend on Patient and MAGDISP CLIN KEY
      so if Patient and Not MAGDISP CLIN Key,  then disable all. {}
  If Status And (SecurityKeys.Indexof('MAGDISP CLIN') = -1) Then Status := False;

  MnuRadiologyExams.Enabled := (Status And (SecurityKeys.Indexof('MAGDISP CLIN') > -1));
  MnuProgressNotes.Enabled := (Status And (SecurityKeys.Indexof('MAGDISP CLIN') > -1));
  MnuClinicalProcedures.Enabled := (Status And (SecurityKeys.Indexof('MAGDISP CLIN') > -1) And FisCPInstalled);
  MnuConsults.Enabled := (Status And (SecurityKeys.Indexof('MAGDISP CLIN') > -1));
  If MUSEenabled Then
  Begin
    MnuMUSEEKGlist.Enabled := Status;
    TbtnEkg.Enabled := Status;

  End;

End;

Procedure TfrmMain.mainEnablePatientLookupLogin(Setting: Boolean);
Begin
  EnablePatientLookupLogin(Setting);
  // now for main window.
  MnuSelectPatient.Enabled := Setting;
  //frmImageList.mnuSelectPatient.Enabled := setting;
  TbtnPatient.Enabled := Setting;
  //btnListFilterWin.enabled := setting;
  MnuLogin.Enabled := Setting;
  MnuLogout.Enabled := Setting;
  MnuRemoteLogin.Enabled := Setting;
  MagObserverLabel1.Visible := Not Setting;
  If MagObserverLabel1.Visible Then MagObserverLabel1.BringToFront;
  EdtPatient.Visible := Setting;
  MnuCPRSLinkOptions.Enabled := Not Setting;
  Application.Processmessages;
End;

Procedure TfrmMain.mainInitializeKeyDependentObjects;
Begin
  MSystemManager.Visible := Userhaskey('MAG SYSTEM') ;
  MSysManhelp.Visible := Userhaskey('MAG SYSTEM') ;
  { 10/18/00 GEK added menu option for the Image Delete help File }
  MImageDeleteHelp.Visible := Userhaskey('MAG DELETE') ;
  {06/04/2003 Design change : 2 keys MAGDISP ADMIN and MAGDISP CLIN}
  MnuRadiologyExams.Visible := Userhaskey('MAGDISP CLIN') ;
  MnuProgressNotes.Visible := Userhaskey('MAGDISP CLIN') ;
  MnuClinicalProcedures.Visible := Userhaskey('MAGDISP CLIN') ;
  MnuConsults.Visible := Userhaskey('MAGDISP CLIN') ;
  MnuMUSEEKGlist.Visible := Userhaskey('MAGDISP CLIN') and MUSEenabled;
  {/p117 gek   MAG QA REVIEW Key also.  }
  mnuMainUtilities.Enabled := (Userhaskey('MAG EDIT') or Userhaskey('MAG QA REVIEW') or Userhaskey('MAG SYSTEM'));
  mnuMainUtilities.Visible :=   mnuMainUtilities.Enabled;
  {This is a workaround, The menu options don't always refresh when changing
      visible settings.   This forcews a refresh.}
  ForceRepaint;

  FrmImageList.MnuManager.Visible := Userhaskey('MAG SYSTEM');
  //FrmImageList.mnuUtilities.Visible := (Userhaskey('MAG EDIT') or Userhaskey('MAG SYSTEM'));
  {/p117 gek QA REVIEW KEY}
    FrmImageList.mnuUtilities.Visible := (Userhaskey('MAG EDIT') or Userhaskey('MAG QA REVIEW') or Userhaskey('MAG SYSTEM') or UserHasKey('MAG ROI'));
  FrmImageList.mnuUtilities.Enabled := FrmImageList.mnuUtilities.Visible;
End;

(* pre /p117 gek.  changed all SecurityKeys...  to UserHasKey  also added test for
Procedure TfrmMain.mainInitializeKeyDependentObjects;
Begin
  MSystemManager.Visible := (SecurityKeys.Indexof('MAG SYSTEM') > -1);
  MSysManhelp.Visible := (SecurityKeys.Indexof('MAG SYSTEM') > -1);
  { 10/18/00 GEK added menu option for the Image Delete help File }
  MImageDeleteHelp.Visible := (SecurityKeys.Indexof('MAG DELETE') > -1);
  {06/04/2003 Design change : 2 keys MAGDISP ADMIN and MAGDISP CLIN}
  MnuRadiologyExams.Visible := (SecurityKeys.Indexof('MAGDISP CLIN') > -1);
  MnuProgressNotes.Visible := (SecurityKeys.Indexof('MAGDISP CLIN') > -1);
  MnuClinicalProcedures.Visible := (SecurityKeys.Indexof('MAGDISP CLIN') > -1);
  MnuConsults.Visible := (SecurityKeys.Indexof('MAGDISP CLIN') > -1);
  MnuMUSEEKGlist.Visible := (SecurityKeys.Indexof('MAGDISP CLIN') > -1) And MUSEenabled;
  mnuMainUtilities.Visible := (SecurityKeys.Indexof('MAG EDIT') > -1) or (SecurityKeys.Indexof('MAG SYSTEM') > -1);
  {This is a workaround, The menu options don't always refresh when changing
      visible settings.   This forcews a refresh.}
  ForceRepaint;

  FrmImageList.MnuManager.Visible := Userhaskey('MAG SYSTEM');
  FrmImageList.mnuUtilities.Visible := (Userhaskey('MAG EDIT') or Userhaskey('MAG SYSTEM'));
End;       *)

Procedure TfrmMain.mainEnableCPFunctions;
Begin
  FisCPInstalled := True;
  MagTIUWinf.EnableCP(FisCPInstalled);
End;

Procedure TfrmMain.MnuHelpClick(Sender: Tobject);
Begin
         { TODO -chelp fix :
Enable user to use Imaging Web Help viewer and not only Internet Explorer for
help.  93 forced using IE because active content on page was creating a 'Freezing' condition
of the application. }
End;

(*
    class procedure MagMsg(c, s: String;  pmsg: TPanel = nil);
    class procedure MagMsgs(c: String; t: TStringList);
    class procedure LogMsg(MsgType: string; Msg: string; Priority: TMagLogPriority = MagLogINFO);
    class procedure LogMsgs(MsgType: string; Msgs: TStringList; Priority: TMagLogPriority = MagLogINFO);
*)


Procedure TfrmMain.MultiImagePrintROITest1Click(Sender: Tobject);
Var
  Rlist: TStrings;
// vfilter : TImageFilter;
Begin
(*

  if not doesformexist('frmROIForm') then
     begin
      try
      screen.Cursor := crHourGlass;
//p94roi      frmROIForm.InitROI(idmodobj.GetMagDBBroker1,idmodobj.GetMagPat1,idmodobj.GetMagFileSecurity,dmagImageManager);
      frmROIForm.InitROI(idmodobj.GetMagDBBroker1,idmodobj.GetMagPat1,idmodobj.GetMagFileSecurity,magImageManager1);
         //    application.CreateForm(TfrmROIForm,frmROIForm);
      finally
      screen.cursor := crDefault;
      end;
      end;
exit;  // stop for p94roi..  for now, always create , when ROI closed. it is freeed.
{  with frmROIForm do
     begin
     show;
     rlist := tstringlist.Create; //p94roi
     umagFltMgr.GetAllFilters(duz,rlist);
     frmROIForm.showallfilters(rlist,duz);
     frmROIForm.Refresh;
     rlist.Free;
     MagPatPhoto1.Update;
     MagPatPhoto1.Update_('1',self);
     end;    }

*)
End;
(*
var  rlist : Tstrings;
// vfilter : TImageFilter;
begin
  if not doesformexist('frmROIForm') then
     begin
      try
      screen.Cursor := crHourGlass;
//p94roi      frmROIForm.InitROI(idmodobj.GetMagDBBroker1,idmodobj.GetMagPat1,idmodobj.GetMagFileSecurity,dmagImageManager);
      frmROIForm.InitROI(idmodobj.GetMagDBBroker1,idmodobj.GetMagPat1,idmodobj.GetMagFileSecurity,magImageManager1);
         //    application.CreateForm(TfrmROIForm,frmROIForm);
      finally
      screen.cursor := crDefault;
      end;
      end;
  with frmROIForm do
     begin
     show;
     rlist := tstringlist.Create; //p94roi
     umagFltMgr.GetAllFilters(duz,rlist);
     frmROIForm.showallfilters(rlist,duz);
     frmROIForm.Refresh;
     rlist.Free;
     MagPatPhoto1.Update;
     MagPatPhoto1.Update_('1',self);
     end;
end;
*)

Procedure TfrmMain.testVersionChecking1Click(Sender: Tobject);
Begin
{$IFDEF TestWindows}
  Application.CreateForm(TfrmTestVersionChecking, frmTestVersionChecking);
  frmTestVersionchecking.MagDBBroker := idmodobj.GetMagDBMVista1;
  frmTestVersionChecking.Showmodal;
{$ENDIF}
End;


Initialization
    //p8t46   DemoDirectory := '';
    //p8t46 StopLoadingAbstracts := false;
  Paramsearched := False;

    (*
      if rbPrint.checked
        then s := 'print'
        else s := 'open';
         // shellexecute(

           // then MagExecuteFile(altviewer, image, '', SW_SHOW)
           // else MagExecuteFile(image, '', '', SW_SHOW);

      res :=  magexecutefile(lbfilename.caption,'',extractfilepath(lbfilename.caption),SW_SHOW,s);
     lbresult.caption := inttostr(res);
      memresults.lines.Add(s+' - - - - ' + inttostr(res)+ ' - - - -' + extractfilename(lbfilename.caption));

     end;

     function Tform1.MagExecuteFile(const FileName, Params, DefaultDir: string; ShowCmd: Integer; oper : string): THandle;
    Return Values

    If the function succeeds, the return value is the instance handle of the application that was run, or the handle of a dynamic data exchange (DDE) server application.
    If the function fails, the return value is an error value that is less than or equal to 32. The following table lists these error values:

    Value	Meaning
    0	The operating system is out of memory or resources.
    ERROR_FILE_NOT_FOUND	The specified file was not found.
    ERROR_PATH_NOT_FOUND	The specified path was not found.
    ERROR_BAD_FORMAT	The .EXE file is invalid (non-Win32 .EXE or error in .EXE image).
    SE_ERR_ACCESSDENIED	The operating system denied access to the specified file.
    SE_ERR_ASSOCINCOMPLETE	The filename association is incomplete or invalid.
    SE_ERR_DDEBUSY	The DDE transaction could not be completed because other DDE transactions were being processed.
    SE_ERR_DDEFAIL	The DDE transaction failed.
    SE_ERR_DDETIMEOUT	The DDE transaction could not be completed because the request timed out.
    SE_ERR_DLLNOTFOUND	The specified dynamic-link library was not found.
    SE_ERR_FNF	The specified file was not found.
    SE_ERR_NOASSOC	There is no application associated with the given filename extension.
    SE_ERR_OOM	There was not enough memory to complete the operation.
    SE_ERR_PNF	The specified path was not found.
    SE_ERR_SHARE	A sharing violation occurred.

    Remarks

    function Tform1.MagExecuteFile(const FileName, Params, DefaultDir: string;
      ShowCmd: Integer; oper : string): THandle;
    var
      zOper, zFileName, zParams, zDir: array[0..279] of Char;

    begin
     //                              HWND                lpOperation
      Result := ShellExecute(Application.MainForm.Handle,strPcopy(zOper,oper),
      //      lpFile                      lpParameters
      StrPCopy(zFileName, FileName), StrPCopy(zParams, Params),
      //      lpDirectory          nShowCmd
       StrPCopy(zDir, DefaultDir), ShowCmd);
    end;

    *)

End.
