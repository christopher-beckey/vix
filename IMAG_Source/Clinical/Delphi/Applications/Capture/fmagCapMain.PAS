Unit FmagCapMain;
{
Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created:  1992
Site Name: Silver Spring, OIFO
Developers: Dr. Ruth Dayhoff,  Garrett Kirin
Description: Main Capture Window
Note:
[[   unit fmagCapMain;
Description: Imageing Capture Main Form.
      Overview :
      The main form of the capture application is designed as the single window
      neede to capture images to a Patient Record.  It has differnet panels for
      for Data Entry, Image Viewing, Import Image selection, device selection,
      confuration etc.
      Typically, a User would  select a patient, capture an Image, enter values for the
      required input fields and then save the Image. An Entry is made in the
      VistA IMAGE File (#2005), and the Image is copied to the Network Write Location.
      Fields are cleared, and the User is ready to capture another image.

//p94t1 gek 9/25/09  PSI Issue when change Patient with a loaded image.
  we need to warn the user that the Patient has changed after the Image has been loaded.
//p94t1 gek 9/29/09  Stop Support for MS Word Documents.  This is an M change.  I've made
  changes to M files, and to IMAGE FILE TYPES File.  Added new field FORMAT IS SUPPORTED
  all entries have 1 as value,  DOC has 0.  DOC won't be listed in the resulting list of
  the RPC to get supported File Formats.
//p94t1 gek 9/29/09 Stop Multiple Esigs
  When capturing a Group of images to a New Signed Note, esig was asked for on each image.

/p117T3-CH1 gek 1/24/11  taking out all 'hard coded' handling of Dicom, Import and TRC.
    The Capture App gives settings that a site can select.  Sites select sets of values,
      and create 'Configuration Buttons' for their users.
      Input source can enable/disable certain image formats.
      Image Formats are the format of the image file created/used by the device.
      Associations are Package Reports where the Images are attached.  A package report is not
      dependant on Image Format.  An Image (any format) is attached to the package.
      106 created a dependency between Association and Format and Association and Inupt Source
      i.e  Telederm Consults have to be DICOM and have to be Imported.
      This dependency is hard coded.  and forces code exceptions based on this one dependency
      We want to get rid of the hard coded dependency.   The requirements of TRC Association
      and Dicom format can be met by the use of existing cofiguration button design
      Sites can proceed as always : select values and creat a Configuration button.
      Since TRC needs Dicom and Dicom is only ready for TRC, we'll create one check before Image
      is Confirmed.  ... before 'Image OK'.
     CH2
     The INIT functions for Source, Format, Association :
     The functions are intended to Initialize the Source, Format or Association.  The selected
     source does not 'know' about Associations.

     Patch RCA
     Patch 129
     New Accuosft .  Use Display Annotations and get rid of capture annotations.
        use Cmag4VGear for the ImageCompoent.
        use new Accusoft controls for TWAIN
        Add CCOW functionality .. same as Display.
        TIU Fixes : Addendum to Addendum
        
]]
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

//{$DEFINE MeteorBoard}
{$DEFINE IMAGING CAPTURE}

{       P48T1
          Add DOD, FEE to possible values for Origin}
{DONE: Get values of Origin from VistA}
     {DONE : Added ability to get Origin Values from VistA in 93 }
  {redisign of message coupling.  decouple all units and forms from MagLogger}
     {JK 10/7/2009 - Maggmsgu refactoring}{<< redesigned Garrett RCA}
{DONE : message history refactoring. //RCA
  in the refactoring patch,  we redesigned the resdesign of application messages.
  a Message interface was created.  and Message procedures were created in uMagdefinitions.
  this design does away with the MagLogger design of all units and forms Requiring maggmsgu.pas in
  the uses clause.  Jerry's "JK 10/7/2009 - Maggmsgu refactoring" design.
   Now, units and forms do not depend on the maglogger component.
   Application only need to know of the IMagMsg interface,  and Implement an object that
   supports the interface.     all units' and forms make logmessage calls to the

  ImagInterface unit.
   ---- example ----

   Procedure MagAppMsg(MsgType: String; Msg: String; Priority: TMagMsgPriority = magmsgINFO); Overload;
     Begin
       if ImsgObj <> nil then  ImsgObj.LogMsg(msgtype,msg,priority);
     End;
   ----- end example ----

  and IF the application has defined the global Object "ImsgObj" Then the  message is logged.

  interface
     Type
     IMagMsg =  Interface(IInterface) //Interface(IDispatch)

  Each Application has it's own object that implements the IMagMsg interface
  ... for now they all happen to created the Maggmsgu form, (maglogger) but ..
  do NOT HAVE to.
  and only the Main form of the application needs to 'use' the pascal file that implements the
  iMagMsg interface.
  In Capture it's cMagCapMsg
  }
  {P140 - START testing 5-18-13
    Save to PDF
    Configurations to VistA.  Editable from any Workstation when user has Key.


  {}
Interface


Uses
  WinTypes,
  WinProcs,
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Stdctrls,
  ExtCtrls,
  Menus,
  Buttons,
  ComCtrls,
  ImgList,
  ToolWin,
  AxCtrls,
  Gauges,
  OleCtrls,
  AppEvnts,
  Trpcb,

//p129   GEARLib_TLB,
//p129  MEDXLib_TLB,

 GearVIEWLib_TLB,
 GearFORMATSlib_TLB, //p129
 GearCORElib_TLB,  //p129
  cMagPublishSubscribe,   //129
  cmag4VGear,   //p129

  cMagLVutils,
  cMagMenu,
  cMagLabelNoClear,
  cMagCapClinMgr,
  cMagObserverLabel,
  {/p117 gek  this needed for Cached Directory variable. but this needs looked into.}
  { TODO  -cRefactor : cmagIGManager and magimagemanager bring a lot of unneeded dependency on
                remote image that isn't needed in capture. look into when we Refactor }
  cmagIGManager,
  MagSelectImportDiru,
  uMagDefinitions,
  uMagCapDef,
  uMagClasses,
  ImagInterfaces,
  ImagDMinterface,
  uMagCapUtil,
  magTRConsultf,
  uMagDICOMUtils   ,
   MagSyncCPRSu,
  magimagemanager,      {/p117 gek  this needed for Cached Directory variable.  }
//p129  fMagCapAnnot,          {/P122 - DMMN - 6/20/2011 - new form to do annotation /}
//p129  fMagAnnotationOptionsX , {/p122 dmmn 7/5/11/}
 (*//ccowout
 CCOWRPCBroker,          {/Telepathology - /TP jsl 2/19/2012}
  Magremoteinterface,     {/TP}
  cMagCCOWManager,        {/TP}
  VERGENCECONTEXTORLib_TLB, {/TP}
*)
  cMagCapMsg,                {RCA gek.  Object to implement the ImagMsg interface.  This
                             object then uses maggmsgf to save and show messages.}
  cMagTWAIN, GearDISPLAYLib_TLB              {p129 TWAIN functions}

  ;

//U s e s Vetted 20090929:fmagVerify, fmagIGctls3, umagThumbmgr, cMag4Viewer, fmagcapsettings, cMagListView, ShellCtrls, MPlayer, umagutils, types, DateUtils, cMag4VGear, umagkeymgr, fmagGetEsigDialog, uMagAppMgr, uMagGearUtils, cMagPat, magfileversion, fmagVideoPlayer, magprevinstance, uMagTIUUtil, magtimeout, gear, GEARDEF7, GEARdef, magpositions, MagBroker, dmsingle, hash, MagExeWait, Spin, fmxutils, MAGAUTO, maggsuru, magguini, fmagCapGrpComplete, fmagCapConfig, magglabu, maggridu, maggut1, maggmcu, maggplku, rpcconf1, Inifiles, ShellAPI, ddeml, FileCtrl, SysUtils
{P129t13}


Type
{P129t13.  New TMagRunMode, instead of Flags all over the place.
    when created  capRunMode : TMagRunMode will default to 0, magrmAlone}
  TMagRunMode = (magrmAlone, magrmCPRS, magrmCCOW );    { magrmAlone= 0, magrmCPRS= 1, magrmCCOW= 2}
  TmagDescSource = (magdescPkg, magdescType);
//  TfrmMain = Class(TForm, IMagObserver, IMagRemoteinterface, ImagMsg)
//ccowout    TfrmCapMain = Class(TForm, IMagObserver,IMagRemoteinterface) //TP //CCOW
    TfrmCapMain = Class(TForm) //,  ImagMsg)

    ACCU321INFO: Tlabel;
    ActiveControl1: TMenuItem;
    ActualSize1: TMenuItem;
    AdminMeansTest1: TMenuItem;
    ApplicationDataFolder1: TMenuItem;
    ApplicationEvents1: TApplicationEvents; //used for OnHelp command to display Web Help
    ApplyWorkstationSettings1: TMenuItem;
    Association1: TMenuItem;
    Autosettings1: TMenuItem;
    BatchCapDescriptionWindow1: TMenuItem;
    bmsgbutton: TBitBtn;
    bottom1: TMenuItem;
    btnCancelScan: TButton;
    btnCapture: TBitBtn;
    btnDocImageDate: TBitBtn; // button for access to Date Dialog
    btnImageOK: TButton;
    btnLongDesc: TToolButton;
    btnLookupdata: TButton; //User confirms they read the warning
    btnOpenFile: TBitBtn;
    btnPatient: TButton;
    btnProcDate: TBitBtn; //open Date Dialog window
    btnProcEvent: TBitBtn;
    btnSpecSubSpec: TBitBtn;
    btnStudyComplete: TButton;
    btnType: TBitBtn;
    btnVLDef: TBitBtn;
    btnxDateTime: Tlabel;
    Buttons1: TMenuItem;
    bvlDocImage: TBevel; // seperator
    bvlImgDesc: TBevel; // seperator
    bvlPkg: TBevel; // seperator, easier on the eyes
    CapDeviceExecute: TButton;
    cbALLPages: TCheckBox;
    cbBatch: TCheckBox;
    cbMicro: TComboBox;
    cbOrigin: TComboBox;
    cbStain: TComboBox;             {pnlDicomByUser defined below}
    cbwordwrap: TCheckBox;
    ChangeTimeoutValue1: TMenuItem;
    Clear1: TMenuItem;
    ClearImage1: TMenuItem;
    ConfigButtonsLeft1: TMenuItem;
    ConfigbuttonsTop1: TMenuItem;
    Configurationlist1: TMenuItem;
    Configurations1: TMenuItem;
    ConfigurationSettings1: TMenuItem;
    Contents1: TMenuItem;
    ContrastBrightness2: TMenuItem;
    CopyImagetoClipboard1: TMenuItem;
    CopytoClipboard1: TMenuItem;
    Defaults1: TMenuItem;
    DeSkew1: TMenuItem;
    DeSkew2: TMenuItem;
    DeSpeckle1: TMenuItem;
    DeSpeckle2: TMenuItem;
    DestroyTIUNoteWindow1: TMenuItem;
    Details1: TMenuItem;
    Dimensions1: TMenuItem;
    Dimensions2: TMenuItem;
    DocumentScanning1: TMenuItem;
    EAccessionNo: TEdit;
    EDayCaseNo: TEdit;
    EdtDocImageDate: TEdit; // displays Doc/Image Date, allows edits.
    EdtImageDesc: TEdit;
    Edtnoteinfo: TEdit; // displays textual note Information
    EdtPatName: TEdit;
    EdtProcDate: TEdit; // display Procedure Date
    EdtProcEvent: TEdit;
    EdtSpecSubSpec: TEdit;
    EdtStudy: TEdit;
    EdtType: TEdit;
    EnableImageOKCapture1: TMenuItem; //Testing menu
    enableMultiPage1: TMenuItem;
    enableOKCancelStudycomplete1: TMenuItem;
    ErrorCodelookup1: TMenuItem;
    Exit1: TMenuItem;
    File1: TMenuItem;
    FilpHorizontal1: TMenuItem;
    findfirstfileshowinfo1: TMenuItem;
    FitActualSize1: TMenuItem;
    Fitto1: TMenuItem;
    FittoHeight1: TMenuItem;
    FittoWidth1: TMenuItem;
    FittoWindow1: TMenuItem;
    FitToWindow2: TMenuItem;
    FlipHorizontal1: TMenuItem;
    FlipVertical1: TMenuItem;
    FlipVertical2: TMenuItem;
    Format1: TMenuItem;
    Gauge1: TGauge;
    pnlGearPat: Tpanel;
    GetUserPreferences1: TMenuItem;
    GroupSingle1: TMenuItem;
    GroupSingle2: TMenuItem;
    GrpLongdesc: TMemo;
    Height1: TMenuItem;
    Help1: TMenuItem;
    Help2: TMenuItem;
    Hidepanel: Tpanel;
    hiGear1: TMenuItem;
    HoldValue1: TMenuItem;
    ImageBoxPanel: Tpanel;
    Imagegroupdesc: Tlabel;
    ImageList1: TImageList;
    ImageList3: TImageList;
    ImageList4: TImageList;
    Imagelongdesc: TMemo;
    imagepanel: Tpanel;
    Imageptrlst: TListBox;
    ImagingCaptureWindow1: TMenuItem;
    imeout10seconds1: TMenuItem;
    img3dot: TImage;
    ImgAccessionNo: TImage;
    ImgDayCaseNo: TImage;
    ImgDblDnBatch: TImage;
    imgdbldnImportdir: TImage; // show list of import directories
    ImgdblDown: TImage; //collapse Long Desc word processing field.
    ImgdblUp: TImage; //expand Long Desc word processing field.
    ImgDblUpBatch: TImage;
    imgdblupImportdir: TImage; //hide list of Import Directories
    ImgDnBatch: TImage;
    ImgDocImageDate: TImage; //glyph on button
    ImgImageDesc: TImage;
    ImgIndexProcEvent: TImage;
    ImgIndexSpecSubSpec: TImage;
    ImgIndexType: TImage; //Icon - Status in Unsigned.
    ImgMicro: TImage;
    ImgNoteBoiler: TImage; // glyph, Note has Boiler text
    ImgNoteInfo: TImage; // displays Icons for Note information
    ImgNoteNoText: TImage; // glyph, means the New Note has NO text.
    ImgNoteText: TImage; // glyph, means the New Note has text.
    ImgOrigin: TImage;  
    //imgOverlay: TImage;  out in p129 maybe later.
    ImgPatName: TImage;
    ImgProcDate: TImage;
    ImgStain: TImage;
    ImgStudy: TImage;
    ImgUpBatch: TImage;
    ImportDir1: TMenuItem;
    ImportDirectory1: TMenuItem;
    ImportDirectoryOptions3: TMenuItem; //Opens Options Tab to manage Import Directories.
    Invert1: TMenuItem;
    Invert2: TMenuItem;
    IsGearControlClearofImages1: TMenuItem; //testing menu
    KeepAliveRPCCall1: TMenuItem;
    Label1: Tlabel;
    Label10: Tlabel;
    Label3: Tlabel;
    Label4: Tlabel;
    Label6: Tlabel;
    Label8: Tlabel;
    LbAccessionNo: TmagLabelNoClear;
    LbAssocDesc: Tlabel;
    lbBlankfill: Tlabel;
    lbControlledImage: Tlabel;
    LbDayCaseNo: TmagLabelNoClear;
    LbDicom: Tlabel;
    LbDocImageDate: TmagLabelNoClear; //Field Label
    lbfilter: Tlabel;
    Lbformatdesc: Tlabel; // bitmap on 'Select Visit Location' button.
    LbImageDesc: TmagLabelNoClear;
    LbImport: Tlabel;
    lbImportb: Tpanel;
    LbIndexProcEvent: TmagLabelNoClear;
    LbIndexSpecSubSpec: TmagLabelNoClear;
    LbIndexType: TmagLabelNoClear;
    LbInputSourceDesc: Tlabel;
    LbMicro: TmagLabelNoClear;
    lbNonViewableImage: Tlabel;
    LbNoteInfo: TmagLabelNoClear; // Field Label
    LbOrigin: TmagLabelNoClear;
    LbPatName: TmagLabelNoClear;
    LbProcDate: TmagLabelNoClear;
    LbPtSSN: Tlabel;
    lbSiteCode: Tlabel;
    LbStain: TmagLabelNoClear;
    LbStudy: TmagLabelNoClear;
    Lbviewingimage: Tlabel;
    left1: TMenuItem;
    Left2: TMenuItem;
    LicBrightness: Tlabel;
    LicContrast: Tlabel;
    LicZoom: Tlabel;
    List1: TMenuItem;
    LockedFields1: TMenuItem;
    Login1: TMenuItem;
    Lvbatch: TListView;
    LvImport1: TListView;
    MagLvUtils1: TMagLVutils;
    Magnify1: TMenuItem;
    mnuTESTINGMAGNOTEEFILE1: TMenuItem;
    mnuTESTINGMAGSYSTEM1: TMenuItem;
    MainMenu1: TMainMenu;
    mAlternateVideoViewer: TMenuItem;
    mBatchOptions: TMenuItem;
    mConfiguration: TMenuItem;
    mConfirmmsg: TMenuItem;
    mCPRSLinkOptions: TMenuItem;
    mDicomNumbers: TMenuItem;
    MergeName1: TMenuItem;
    messagedlg1: TMenuItem; //Testing Menu
    mimportdir: TMenuItem;
    mimportdir1: TMenuItem;
    mImportDir2: TMenuItem;
    mLoadPatientImages: TMenuItem;
    mLogin: TMenuItem;
    MLogout: TMenuItem;
    mMagSys: TMenuItem;
    MnuAbout: TMenuItem;
    mnuBatchAdvanced: TMenuItem;
    mnuBrightnessLess1: TMenuItem; //508 menu option for Image Function.
    mnuBrightnessMore1: TMenuItem; //508 menu option for Image Function.
    mnuCapControlledImage: TMenuItem;
    mnuCapUtilities: TMenuItem;
    mnuClearConfigurationvalues: TMenuItem; //clears all values from input fields.
    mnuConfigListSeperator: TMenuItem;
    mnuConfigToolBar: TMenuItem;
    mnuContrastLess1: TMenuItem; //508 menu option for Image Function.
    mnuContrastMore1: TMenuItem; //508 menu option for Image Function.
    mnuCurrentSettingsTB: TMenuItem;
    MnuContext: TMenuItem;          //telepathology - /TP
    MnuShowContext: TMenuItem;      //TP
    MnuSuspendContext: TMenuItem;   //TP
    MnuResumeGetContext: TMenuItem; //TP
    MnuResumeSetContext: TMenuItem; //TP
    mnuDebugON: TMenuItem;
    mnuDeleteConfiguration: TMenuItem;
    mnuFitToWidth1: TMenuItem;
    mnufrmCapMaintablist: TMenuItem;
    mnuGetDateTime: TMenuItem;
    mnuHideToolbarConfigs: TMenuItem;
    mnuHoldValue: TMenuItem;
    mnuIconLegend: TMenuItem; //Opens IconLegend Window
    MnuImage: TMenuItem;
    mnuImageProperties: TMenuItem;
    MnuImageToolbar: TMenuItem;
    mnuImportDirectoryOptions: TMenuItem;
    mnuImportDirectoryOptions2: TMenuItem;
    MnuMessageLog: TMenuItem;
    mnuMultiLinebuttons: TMenuItem;
    mnumultilinebuttons2: TMenuItem;
    mnuOriginHoldValue: TPopupMenu;
    mnuOriginHoldValueItem: TMenuItem;
    mnuPage: TMenuItem; //508 menu option for Image Function.
    mnuPageFirst1: TMenuItem; //508 menu option for Image Function.
    mnuPageLast1: TMenuItem; //508 menu option for Image Function.
    mnuPageNext1: TMenuItem; //508 menu option for Image Function.
    mnuPagePrev1: TMenuItem; //508 menu option for Image Function.
    mnuProcHoldValue: TPopupMenu;
    mnuRealignIndexFields: TMenuItem;
    MnuRefresh: TMenuItem;
    mnuRemoveAllBatchList: TMenuItem; // remove entries in Batch List.
    mnuSaveBigFile: TMenuItem;
    mnuSaveConfiguration: TMenuItem;
    MnuScroll: TMenuItem; //508 menu option for Image Function.
    MnuScrollDown: TMenuItem; //508 menu option for Image Function.
    MnuScrollLeft: TMenuItem; // 508 menu option for Image Function.
    MnuScrollRight: TMenuItem; //508 menu option for Image Function.
    MnuScrollToCornerBL: TMenuItem; //508 menu option for Image Function.
    MnuScrollToCornerBR: TMenuItem; //508 menu option for Image Function.
    MnuScrollToCornerTL: TMenuItem; //508 menu option for Image Function.
    MnuScrollToCornerTR: TMenuItem; //508 menu option for Image Function.
    MnuScrollUp: TMenuItem; //508 menu option for Image Function.
    mnuSelectLocation1: TMenuItem;
    MnuShowHints: TMenuItem;
    mnuTEST1: TMenuItem;
    mnuTEST2: TMenuItem;
    mnutestPatientOverlay: TMenuItem;
    mnuTheOthers: TMenuItem;
    mnuThumbnails: TMenuItem;
    mnutoggleHoldValue: TPopupMenu;
    MnuUseInternetExplorerforhelp: TMenuItem; //Display Web Help in IE, not Imaging Help window.
    mnuUserPref: TMenuItem;
    mnuviewDetails: TMenuItem;
    mnuviewList: TMenuItem;
    Modedesc: Tlabel;
    MouseMagnify1: TMenuItem;
    MousePan1: TMenuItem;
    MousePan2: TMenuItem;
    Mouses1: TMenuItem;
    MouseZoom1: TMenuItem;
    MoveAll1: TMenuItem;
    MoveSelected1: TMenuItem;
    MoveSelectedToBatch1: TMenuItem; //508 menu option for Image Function.
    mRemoteLogin: TMenuItem;
    mSelectPatient: TMenuItem;
    mSysMan: TMenuItem;
    MSysManhelp: TMenuItem;
    mtbAlignleft: TMenuItem;
    mtbAlignright: TMenuItem;
    mtbAligntop: TMenuItem;
    mTestWriteDir: TMenuItem;
    mVideoOptions: TMenuItem;
    N0scrollbar1: TMenuItem;
    N1: TMenuItem;
    N10: TMenuItem;
    N101: TMenuItem;
    N1024x7681: TMenuItem;
    N11: TMenuItem;
    N111: TMenuItem;
    N1152x8641: TMenuItem;
    N12: TMenuItem;
    N121: TMenuItem;
    N1280x10241: TMenuItem;
    N13: TMenuItem;
    N131: TMenuItem;
    N14: TMenuItem;
    N141: TMenuItem;
    N15: TMenuItem;
    N151: TMenuItem;
    N16: TMenuItem;
    N1600x12001: TMenuItem;
    N161: TMenuItem;
    N17: TMenuItem;
    N171: TMenuItem;
    N18: TMenuItem;
    N181: TMenuItem;
    N18901: TMenuItem;
    N19: TMenuItem;
    N191: TMenuItem;
    N2: TMenuItem;
    N20: TMenuItem;
    N201: TMenuItem;
    N21: TMenuItem;
    N211: TMenuItem;
    N22: TMenuItem;
    N221: TMenuItem;
    N23: TMenuItem;
    N231: TMenuItem;
    N24: TMenuItem;
    N241: TMenuItem;
    N25: TMenuItem;
    N251: TMenuItem;
    N261: TMenuItem;
    N271: TMenuItem;
    N281: TMenuItem;
    N291: TMenuItem;
    N3: TMenuItem;
    N301: TMenuItem;
    N31: TMenuItem;
    N311: TMenuItem;
    N321: TMenuItem;
    N331: TMenuItem;
    N341: TMenuItem;
    N351: TMenuItem;
    N361: TMenuItem;
    N371: TMenuItem;
    N381: TMenuItem;
    N391: TMenuItem;
    N4: TMenuItem;
    N401: TMenuItem;
    N41: TMenuItem;
    N5: TMenuItem;
    N51: TMenuItem;
    N6: TMenuItem;
    N61: TMenuItem;             
    N7: TMenuItem;
    N71: TMenuItem;
    N8: TMenuItem;
    N800x6001: TMenuItem;
    N81: TMenuItem;
    N9: TMenuItem;
    N91: TMenuItem;
    NetSecurityON1: TMenuItem;
    NewNoteDefaults1: TMenuItem;
    oolbars1: TMenuItem;
    opendialog2: TOpenDialog;
    OpenDialogImport: TOpenDialog;
    OpenPanWindow1: TMenuItem;
    OpenPanWindow2: TMenuItem;
    OpenViewerSortWindow1: TMenuItem;
    Options: TMenuItem;
    Other1: TMenuItem;
    Otherdesc: Tlabel;
    Pan1: TMenuItem;
    Panel1: Tpanel;
    Panel4: Tpanel;
    Panel5: Tpanel;
    Panel6: Tpanel;
    Panel7: Tpanel;
    pArrows: Tpanel;
    PastefromClipboard1: TMenuItem;
    PasteImagefromClipboard1: TMenuItem;
    pBatch: Tpanel;
    PicBrightness: Tpanel;
    PicContrast: Tpanel;
    PicZoom: Tpanel;
    pLongDesc: Tpanel;
    Pmsg: Tpanel;
    pMsgpanel: Tpanel;
    pnlData: Tpanel;
    pnlImport: Tpanel;
    pnlimporttop: Tpanel;
    pnlNonGearSupported: Tpanel;
    PnlNoteBtns: Tpanel; // holds icons for Note Actions and Status
    PnlReqMsg: Tlabel; //Panel displays Patient Changed, Image is same warning.
    Pointer1: TMenuItem;
    Pointer2: TMenuItem;
    popupBatchImportlist: TPopupMenu;
    PopupImageControls: TPopupMenu;
    popupImportList: TPopupMenu;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    PopupMenuToolbar: TPopupMenu;
    PopupSettings: TPopupMenu;
    popupTabctr: TPopupMenu;
    PtSSN: TEdit;
    RefreshIndexlists1: TMenuItem;
    RemoveSelected1: TMenuItem;
    Reset1: TMenuItem;
    Reset2: TMenuItem;
    right1: TMenuItem;
    Right2: TMenuItem;
    Rotate1: TMenuItem;
    Rotate1801: TMenuItem;
    Rotate2: TMenuItem;
    RotateLeft2: TMenuItem;
    RotateRight1: TMenuItem;
    SaveDialog1: TSaveDialog;
    SaveImageAs1: TMenuItem;
    SaveImageAs2: TMenuItem;
    SavePatientNametoFile1: TMenuItem;
    SavePreferencesNow1: TMenuItem;
    SavePreferencesOnExit2: TMenuItem;
    savetoapppath1: TMenuItem;
    SbxEditFields: TScrollBox;
    selectevent1: TMenuItem;
    ShowCPRSLinkMenuoption1: TMenuItem;
    showdim: TMenuItem;
    ShowImageGearInfotomsgwindow1: TMenuItem;
    ShowImageHDIB1: TMenuItem;
    ShowOpenForms1: TMenuItem;
    ShowTestMessages1: TMenuItem;
    mnuTESTINGSimulatePatientSwitchfromCPRS1: TMenuItem;
    Source1: TMenuItem;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Splitter4: TSplitter;
    Splitter5: TSplitter;
    spltConfigbuttons: TSplitter;
    TabbingSequence1: TMenuItem;
    TabCtr: TTabControl;
    TbePage: TEdit;
    TbicBrightness: TTrackBar;
    TbicContrast: TTrackBar;
    TbicZoom: TTrackBar;
    TblbPageCount: Tlabel;
    tbPlayVideo: TBitBtn;
    tbwsAssoc: TToolButton;
    tbwsFormat: TToolButton;
    tbwsMode: TToolButton;
    tbwsOther: TToolButton;
    tbwsSaving: TToolButton;
    tbwsSource: TToolButton;
    TestCapObj1: TMenuItem; //Testing menu
    TestDataWindow1: TMenuItem;
    TimeoutTimer: TTimer;
    Timer1: TTimer;
    timerStayAlive: TTimer;
    tlbarImage: TToolBar;
    tlbrbtnActual: TToolButton;
    tlbrbtnBriteMinus: TToolButton;
    tlbrbtnBritePlus: TToolButton;
    tlbrbtnDeSkew: TToolButton;
    tlbrbtnDeSpeckle: TToolButton;
    tlbrbtnFitHeight: TToolButton;
    tlbrbtnFitToWin: TToolButton;
    tlbrbtnFitWidth: TToolButton;
    tlbrbtnFlipHoriz: TToolButton;
    tlbrbtnFlipVert: TToolButton;
    tlbrbtnHandPan: TToolButton;
    tlbrbtnInvert: TToolButton;
    tlbrbtnMagnify: TToolButton;
    tlbrbtnPageFirst: TToolButton;
    tlbrbtnPageLast: TToolButton;
    tlbrbtnPageNext: TToolButton;
    tlbrbtnPagePrev: TToolButton;
    tlbrbtnPanWindow: TToolButton;
    tlbrbtnPointer: TToolButton;
    tlbrbtnReset: TToolButton;
    tlbrbtnRotate90: TToolButton;
    tlbrbtnRotatem90: TToolButton;
    tlbrbtnZoomSelect: TToolButton;
    tlbrSettings: TToolBar;
    tlbrbtnAnnotation: TToolButton;     {/P122 - DMMN - 6/20/2011 - button to launch annotation /}
    tool1: TMenuItem;
    ToolBar1: TToolBar;
    ToolBarCaptions1: TMenuItem;
    toolbarleft1: TMenuItem;
    ToolButton1: TToolButton;
    ToolButton10: TToolButton;
    tlbrbtnAnnotationClose: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    Tools1: TMenuItem;
    top1: TMenuItem;
    try1: TMenuItem;
    UseOldHelp1: TMenuItem;
    Version25testingupdates1: TMenuItem;
    WebHelp1: TMenuItem;
    Window1: TMenuItem;
    writedir1: TMenuItem;
    Zoom1: TMenuItem;
    ZoomIn1: TMenuItem;
    ZoomIn3: TMenuItem;
    ZoomIn4: TMenuItem; //508 menu option for Image Function.
    ZoomOut1: TMenuItem;
    ZoomOut3: TMenuItem;
    ZoomOut4: TMenuItem; //508 menu option for Image Function.
    ZoomScrollBarsettings1: TMenuItem;
    TESTAccusoftVersion1: TMenuItem;
    mnuDicomDataTest: TMenuItem;  //Test Menu item not visible to sites.

    {/p117 T3 gek-  panel instead of 3 seperate controls. This way only 1 control needs 
      hidden, positioned and inserted/removed from tab sequence. }
    pnlDicomByUser: TPanel;     
    lbDicomByUser: TmagLabelNoClear;  //contained on panel
    imgDicomByUser: TImage;           //contained on panel
    edtDicomByUser: TEdit;            //contained on panel
    btnDicomByUser: TButton;
    mnuAnnotationSettings1: TMenuItem;
    ForceErrortestEurekaLog1: TMenuItem;    //CCOW

    pnlGearCanned: TPanel;
    IGPageViewCtl1Thumb: TIGPageViewCtl;
    mnuTESTINGCloseTwainSource1: TMenuItem;
    N26: TMenuItem;
    mnuTESTINGIsSessionChanged: TMenuItem;
    mnuTESTINGAnnotQuickInit: TMenuItem;
    mnuTESTINGSaveAnnot: TMenuItem;
    N27: TMenuItem;
    mnuClearAllAnnotations: TMenuItem;
 
   pnlCCOW: TPanel;  //CCOW  /TP  put in 129 for CCOW bitmaps
    imgCCOWLink: TImage;  //CCOW  /TP
    imgCCOWchanging: TImage;  //CCOW  /TP
    imgCCOWbroken: TImage;  //CCOW  /TP

    imgCanned: TImage;
    mnuTESTINGAnnotParentnil1: TMenuItem;
    MagSubscriber1: TMagSubscriber;
    mnuTestSaveImageAs: TMenuItem;
    {p129t10 gek  TestMenu items... not visible to user.}
    testMNUmg1FREE1: TMenuItem;
    mnuResetPanWindow: TMenuItem;
    TestMnuRELoadGear: TMenuItem;
    mnuTESTShowContextData: TMenuItem;
    Splitter6: TSplitter;
    lbRunMode: TLabel;
    Splitter7: TSplitter;
    mnuTestScript: TMenuItem;
    mnuTestScriptForceAccusoftErrors: TMenuItem;
    mnuTestScriptDontUseCCOW: TMenuItem;
    N28: TMenuItem;
    mnuTestScriptForceCopyExceptions: TMenuItem;
    sLEEP301: TMenuItem;
    InsertPages1: TMenuItem;
    DeletePages1: TMenuItem;
    N29: TMenuItem;
    PositionButtonsLeft1: TMenuItem;
    PositionButtonsTop1: TMenuItem;
    PositionButtonsToolWindow1: TMenuItem;
    N30: TMenuItem;
    N32: TMenuItem;
    mnuLoadDSSources: TMenuItem;
    pnlNoteGlyph: TPanel;
    Bevel1: TBevel;
    imglyNoteNew: TImage;
    imglyNoteAddendum: TImage;
    imglyNoteComplete: TImage;
    imglyNoteUnSigned: TImage;
    imglyStatusComplete: TImage;
    imglyStatusEFiled: TImage;
    imglyStatusSigned: TImage;
    imglyStatusUnSigned: TImage;
    lbglyLocation: TLabel;
    btnVLDef1: TBitBtn;
    pnlSwitchPatientsWarn: TPanel;
    Image2: TImage;
    Image8: TImage;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label15: TLabel;
    lbWarnTitle: TLabel;
    Label17: TLabel;
    Image9: TImage;
    magobslbSwitchPatientsWarn: TMagObserverLabel;
    lbWarnTitle2: TLabel;
    btnOKPatientChangeWarning: TBitBtn;
    BitBtn1: TBitBtn;
    pnllstImport: TPanel;
    imgdbluppnllstimport: TImage;
    Label5: TLabel;
    lstboxImport: TListBox;
    lvProcEvent: TListView;
    lvSpecSubSpec: TListView;
    lvType: TListView;
    mnuTESTAccuVersion: TMenuItem;
    Info1: TMenuItem;
    mnuSaveAsPDF1: TMenuItem;
    mnu140test: TMenuItem;
    mnu140ClearPDFfile: TMenuItem;
    N33: TMenuItem;
    mnu140RLE: TMenuItem;
    mnu140JPG: TMenuItem;
    pnlWrksCfg: TPanel;
    btnReview: TButton;
    mnuTestEnableMultipage: TMenuItem;
    mnuCombineTIFscans: TMenuItem;
    mnuCombinePDFScans: TMenuItem;
    N34: TMenuItem;
    mnuTestOpenTempDirectoryinExplorer: TMenuItem;
    N35: TMenuItem;
    ShowCapXFalse1: TMenuItem;
    AllPagesCheckedTrue1: TMenuItem;
    ShowCapXtrue1: TMenuItem;
    N36: TMenuItem;

  Procedure PanWindowCloseEvent(Sender: Tobject);   //try anything

    Function ApplicationEvents1Help(Command: Word; Data: Integer; Var CallHelp: Boolean): Boolean;
    Procedure ACCU321INFOClick(Sender: Tobject);
    Procedure ACCU321INFOMouseEnter(Sender: Tobject);
    Procedure ACCU321INFOMouseLeave(Sender: Tobject);
    Procedure Accu321Repaint(Sender: Tobject);
    Procedure ActiveControl1Click(Sender: Tobject);
    Procedure ActualSize1Click(Sender: Tobject);
    Procedure AdminMeansTest1Click(Sender: Tobject);
    Procedure ApplicationDataFolder1Click(Sender: Tobject);
    Procedure ApplicationEvents1ShowHint(Var HintStr: String; Var CanShow: Boolean; Var HintInfo: THintInfo);
    Procedure ApplyWorkstationSettings1Click(Sender: Tobject);
    Procedure AppOnHint(Sender: Tobject);
    Procedure Association1Click(Sender: Tobject);
    Procedure Autosettings1Click(Sender: Tobject);
    Procedure BatchCapDescriptionWindow1Click(Sender: Tobject);
    Procedure bBatchClick(Sender: Tobject);
    Procedure bImportDirectoryClick(Sender: Tobject);
    Procedure BitBtn1Click(Sender: Tobject);
    Procedure bmsgbuttonClick(Sender: Tobject);
    Procedure bottom1Click(Sender: Tobject);
    Procedure btnCancelScanClick(Sender: Tobject);
    Procedure btnCaptureClick(Sender: Tobject);
    Procedure btnDocImageDateClick(Sender: Tobject);
    Procedure btnImageOKClick(Sender: Tobject);
    Procedure btnLongDescClick(Sender: Tobject);
    Procedure btnLookupdataclick(Sender: Tobject);
    Procedure btnOKPatientChangeWarningClick(Sender: Tobject);
    Procedure btnOpenFileClick(Sender: Tobject);
    Procedure btnPatientClick(Sender: Tobject);
    Procedure btnProcDateClick(Sender: Tobject);
    Procedure btnProcEventClick(Sender: Tobject);
    Procedure btnSpecSubSpecClick(Sender: Tobject);
    Procedure btnStudyCompleteClick(Sender: Tobject);
    Procedure btnTypeClick(Sender: Tobject);
    Procedure btnVLDef1Click(Sender: Tobject);
    Procedure btnVLDefClick(Sender: Tobject);
    Procedure CAPDeviceExecuteClick(Sender: Tobject);
    Procedure cbALLPagesClick(Sender: Tobject);
    Procedure cbBatchClick(Sender: Tobject);
    Procedure cbOriginKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure cbwordwrapClick(Sender: Tobject);
    Procedure ChangeTimeoutValue1Click(Sender: Tobject);
    //ccowout  Procedure CHKCCOW;                             //TP -Telepathology
    Procedure CommandLineCodes(Var Res: Boolean);  //TP -Telepathology
    Procedure Clear1Click(Sender: Tobject);
    Procedure ClearImage1Click(Sender: Tobject);
    Procedure ConfigButtonsLeft1Click(Sender: Tobject);
    Procedure ConfigbuttonsTop1Click(Sender: Tobject);
    Procedure ConfigMenuItemSelected(Sender: Tobject);
    Procedure Configurationlist1Click(Sender: Tobject);
    Procedure Configurations1Click(Sender: Tobject);
    Procedure ConfigurationSettings1Click(Sender: Tobject);
    Procedure Contents1Click(Sender: Tobject);
    Procedure CopyImagetoClipboard1Click(Sender: Tobject);
    Procedure CopytoClipboard1Click(Sender: Tobject);
    Procedure Defaults1Click(Sender: Tobject);
    Procedure DeSkew1Click(Sender: Tobject);
    Procedure DeSkew2Click(Sender: Tobject);
    Procedure DeSpeckle1Click(Sender: Tobject);
    Procedure DeSpeckle2Click(Sender: Tobject);
    Procedure DestroyTIUNoteWindow1Click(Sender: Tobject);
    Procedure Details1Click(Sender: Tobject);
    Procedure Dimensions1Click(Sender: Tobject);
    Procedure DocumentScanning1Click(Sender: Tobject);
    Procedure eAccessionNoMouseDown(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
    Procedure eDayCaseNoMouseDown(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
    Procedure edtDocImageDateDblClick(Sender: Tobject); //on Dbl Click, put Today in field.
    Procedure edtDocImageDateEnter(Sender: Tobject); //P59 Doc  If empty when entered, it defaults to ProcDateTime
    Procedure edtDocImageDateExit(Sender: Tobject); //Validate and strip Time.
    Procedure edtDocImageDateKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState); //Validate and strip Time.
    Procedure edtDocImageDateMouseDown(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
    Procedure edtImageDescEnter(Sender: Tobject);
    Procedure edtImageDescKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure edtImageDescMouseDown(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
    Procedure edtNoteInfoMouseDown(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
    Procedure edtPatNameDblClick(Sender: Tobject);
    Procedure edtPatNameMouseDown(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
    Procedure edtProcDateDblClick(Sender: Tobject); //on Dbl Click, put Today in field.
    Procedure edtProcDateEnter(Sender: Tobject);
    Procedure edtProcDateExit(Sender: Tobject);
    Procedure edtProcDateKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure edtProcDateMouseDown(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
    Procedure edtProcEventClick(Sender: Tobject);
    Procedure edtProcEventEnter(Sender: Tobject);
    Procedure edtProcEventExit(Sender: Tobject);
    Procedure edtProcEventKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure edtProcEventKeyUp(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure edtProcEventMouseDown(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
    Procedure edtSpecSubSpecClick(Sender: Tobject);
    Procedure edtSpecSubSpecEnter(Sender: Tobject);
    Procedure edtSpecSubSpecExit(Sender: Tobject);
    Procedure edtSpecSubSpecKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure edtSpecSubSpecKeyUp(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure edtSpecSubSpecMouseDown(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
    Procedure edtStudyMouseDown(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
    Procedure edtTypeClick(Sender: Tobject);
    Procedure edtTypeEnter(Sender: Tobject);
    Procedure edtTypeExit(Sender: Tobject);
    Procedure edtTypeKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure edtTypeKeyUp(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure edtTypeMouseDown(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
    Procedure EnableImageOKCapture1Click(Sender: Tobject);
    Procedure enableOKCancelStudycomplete1Click(Sender: Tobject);
    Procedure ErrorCodelookup1Click(Sender: Tobject);
    Procedure Exit1Click(Sender: Tobject);
    Procedure FilpHorizontal1Click(Sender: Tobject);
    Procedure findfirstfileshowinfo1Click(Sender: Tobject);
    Procedure FitToWindow2Click(Sender: Tobject);
    Procedure FlipHorizontal1Click(Sender: Tobject);
    Procedure FlipVertical1Click(Sender: Tobject);
    Procedure FlipVertical2Click(Sender: Tobject);
    Procedure Format1Click(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure FormCloseQuery(Sender: Tobject; Var CanClose: Boolean);
    Procedure FormCreate(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure FormPaint(Sender: Tobject);
    Procedure FormResize(Sender: Tobject);
    Procedure Gear1ErrorEvent(Sender: Tobject; nErrCount: Smallint);
    {/p129  Gear1 is gone.....}
    //    Procedure Gear1KeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    { DONE -o129 : get these next 3  calls out.. Gear1 related}
    //129t17 out  Procedure Gear1ScanAfterDoc(ASender: Tobject; PageCount, ADFLoaded: Integer);
    //129t17 out  Procedure Gear1ScanAfterPage(Sender: Tobject; PageNumber, PendCount: Integer; Const Filename: WideString); //Image has Been Scrolled.
    //129t17 out  Procedure Gear1SelectEvent(Sender: Tobject; Var LplLeft, LplTop, LplRight, LplBottom: Integer);
    Procedure GetUserPreferences1Click(Sender: Tobject);
    Procedure GroupSingle1Click(Sender: Tobject);
    Procedure GroupSingle2Click(Sender: Tobject);
    Procedure Height1Click(Sender: Tobject);
    Procedure Help1Click(Sender: Tobject);
    Procedure HelpMenuitemSelected(Sender: Tobject);
    Procedure hiGear1Click(Sender: Tobject);
    Procedure HoldValue1Click(Sender: Tobject);
    Procedure Image9Click(Sender: Tobject);
    Procedure ImagingCaptureWindow1Click(Sender: Tobject);
    Procedure imeout10seconds1Click(Sender: Tobject);
    Procedure img3dotClick(Sender: Tobject); //Open Settings Tab to Manage Import Directories
    Procedure ImgDblDnBatchClick(Sender: Tobject); //move all images to batch list
    Procedure imgdbldnImportdirClick(Sender: Tobject); //close Import Directory list
    Procedure imgdbldownClick(Sender: Tobject); //hide Import directory panel/list
    Procedure ImgDblUpBatchClick(Sender: Tobject); //remove all images from batch list
    Procedure imgdblUPClick(Sender: Tobject); // open Import Director panel/list
    Procedure imgdblupImportdirClick(Sender: Tobject); //close import directory list
    Procedure imgdbluppnllstimportClick(Sender: Tobject);
    Procedure ImgDnBatchClick(Sender: Tobject); // move selected images to batch list
    Procedure ImgUpBatchClick(Sender: Tobject); //remove selected images from batch list
    Procedure ImportDir1Click(Sender: Tobject);
    Procedure ImportDirectory1Click(Sender: Tobject);
    Procedure Invert2Click(Sender: Tobject);
    Procedure IsGearControlClearofImages1Click(Sender: Tobject);
    Procedure KeepAliveRPCCall1Click(Sender: Tobject);
    Procedure Label3DblClick(Sender: Tobject);
    Procedure lbBlankfillMouseEnter(Sender: Tobject);
    Procedure lbBlankfillMouseLeave(Sender: Tobject);
    Procedure lbImportClick(Sender: Tobject);
    Procedure lbImportMouseEnter(Sender: Tobject);
    Procedure lbImportMouseLeave(Sender: Tobject);
    Procedure lbPatNameMouseDown(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
    Procedure lbviewingImageMouseEnter(Sender: Tobject);
    Procedure lbviewingImageMouseLeave(Sender: Tobject);
    Procedure left1Click(Sender: Tobject);
    Procedure Left2Click(Sender: Tobject);
    Procedure List1Click(Sender: Tobject);
    Procedure LockedFields1Click(Sender: Tobject);
    Procedure Login1Click(Sender: Tobject);
    Procedure lstboxImportClick(Sender: Tobject);
    Procedure lstboxImportKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure lvBatchClick(Sender: Tobject);
    Procedure lvBatchColumnClick(Sender: Tobject; Column: TListColumn);
    Procedure lvBatchCompare(Sender: Tobject; Item1, Item2: TListItem; Data: Integer; Var Compare: Integer);
    Procedure lvBatchDragDrop(Sender, Source: Tobject; x, y: Integer);
    Procedure lvBatchDragOver(Sender, Source: Tobject; x, y: Integer; State: TDragState; Var Accept: Boolean);
    Procedure lvBatchKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure lvImport1Columnlick(Sender: Tobject; Column: TListColumn);
    Procedure lvImport1Compare(Sender: Tobject; Item1, Item2: TListItem; Data: Integer; Var Compare: Integer);
    Procedure lvImport1DragDrop(Sender, Source: Tobject; x, y: Integer);
    Procedure lvImport1DragOver(Sender, Source: Tobject; x, y: Integer; State: TDragState; Var Accept: Boolean);
    Procedure lvImport1Enter(Sender: Tobject);
    Procedure lvImport1KeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure lvImport1MouseUp(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
    Procedure lvImport1Resize(Sender: Tobject);
    Procedure lvProcEventClick(Sender: Tobject);
    Procedure lvProcEventExit(Sender: Tobject);
    Procedure lvProcEventKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure lvProcEventSelectItem(Sender: Tobject; Item: TListItem; Selected: Boolean);
    Procedure lvSpecSubSpecClick(Sender: Tobject);
    Procedure lvSpecSubSpecExit(Sender: Tobject);
    Procedure lvSpecSubSpecKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure lvSpecSubSpecSelectItem(Sender: Tobject; Item: TListItem; Selected: Boolean);
    Procedure lvTypeClick(Sender: Tobject);
    Procedure lvTypeExit(Sender: Tobject);
    Procedure lvTypeKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure lvTypeSelectItem(Sender: Tobject; Item: TListItem; Selected: Boolean);
    Procedure Magnify1Click(Sender: Tobject);
    Procedure mnuTESTINGMAGNOTEEFILE1Click(Sender: Tobject);
    Procedure mnuTESTINGMAGSYSTEM1Click(Sender: Tobject);
    Procedure mAlternateVideoViewerClick(Sender: Tobject);
    Procedure mBatchOptionsClick(Sender: Tobject);
    Procedure mConfirmmsgClick(Sender: Tobject);
    Procedure mCPRSLinkOptionsClick(Sender: Tobject);
    Procedure mDicomNumbersClick(Sender: Tobject);
    Procedure messagedlg1Click(Sender: Tobject);
    Procedure mimportdir1Click(Sender: Tobject);
    Procedure mImportDir2Click(Sender: Tobject);
    Procedure mimportdirClick(Sender: Tobject);
    Procedure mimportdirXoldClick(Sender: Tobject);
    Procedure mLoadPatientImagesClick(Sender: Tobject);
    Procedure mLoginClick(Sender: Tobject);
    Procedure MLogoutClick(Sender: Tobject);
    Procedure mMagSysClick(Sender: Tobject);
    Procedure MnuAboutClick(Sender: Tobject);
    Procedure mnuBatchAdvancedClick(Sender: Tobject);
    Procedure mnuBrightnessLess1Click(Sender: Tobject); //Decrease Brightness in Image
    Procedure mnuBrightnessMore1Click(Sender: Tobject); //Increase Brightness in Image
    Procedure mnuCapControlledImageClick(Sender: Tobject);
    Procedure mnuCapUtilitiesClick(Sender: Tobject);
    Procedure mnuClearConfigurationvaluesClick(Sender: Tobject);
    Procedure mnuConfigToolBarClick(Sender: Tobject);
    Procedure mnuContrastLess1Click(Sender: Tobject); //Decrease Contrast in Image
    Procedure mnuContrastMore1Click(Sender: Tobject); //Increase Contrast in Image
    Procedure mnuCurrentSettingsTBClick(Sender: Tobject);
    Procedure mnuDebugONClick(Sender: Tobject);
    Procedure mnuFitToWidth1Click(Sender: Tobject);
    Procedure mnufrmCapMaintablistClick(Sender: Tobject);
    Procedure mnuGetDateTimeClick(Sender: Tobject);
    Procedure mnuHideToolbarConfigsClick(Sender: Tobject);
    Procedure mnuHoldValueClick(Sender: Tobject);
    Procedure mnuIconLegendClick(Sender: Tobject); //Open Icon Legend window
    Procedure mnuImageClick(Sender: Tobject);
    Procedure mnuImagePropertiesClick(Sender: Tobject);
    Procedure MnuImageToolbarClick(Sender: Tobject);
    Procedure mnuImportDirectoryOptionsClick(Sender: Tobject); //Open Import Directory Options Tab on Settings Window
    Procedure MnuMessageLogClick(Sender: Tobject);
    Procedure mnumultilinebuttons2Click(Sender: Tobject);
    Procedure mnuMultiLinebuttonsClick(Sender: Tobject);
    Procedure mnuOriginHoldValueItemClick(Sender: Tobject);
    Procedure mnuOriginHoldValuePopup(Sender: Tobject);
    Procedure mnuPageFirst1Click(Sender: Tobject); //Open first page of multipage doc.
    Procedure mnuPageLast1Click(Sender: Tobject); //Open Last page of multipage doc.
    Procedure mnuPageNext1Click(Sender: Tobject); //Open next page of multipage doc.
    Procedure mnuPagePrev1Click(Sender: Tobject); //Open Previous page of multipage doc.
    Procedure mnuProcHoldValuePopup(Sender: Tobject);
    Procedure mnuRealignIndexFieldsClick(Sender: Tobject);
    Procedure MnuRefreshClick(Sender: Tobject);
    Procedure mnuRemoveAllBatchListClick(Sender: Tobject);
    Procedure mnuSaveBigFileClick(Sender: Tobject);
    Procedure mnuSaveConfigurationClick(Sender: Tobject);
    Procedure MnuScrollDownClick(Sender: Tobject); //Scroll Image Down
    Procedure MnuScrollLeftClick(Sender: Tobject); //Scroll Image Left
    Procedure MnuScrollRightClick(Sender: Tobject); //Scroll Image Right
    Procedure MnuScrollToCornerBLClick(Sender: Tobject); //Scroll to Corner Bottom Left
    Procedure MnuScrollToCornerBRClick(Sender: Tobject); //Scroll to Corner Bottom Right
    Procedure MnuScrollToCornerTLClick(Sender: Tobject); //Scroll to Corner Top Left
    Procedure MnuScrollToCornerTRClick(Sender: Tobject); //Scroll to Corner Top Right
    Procedure MnuScrollUpClick(Sender: Tobject); //Scroll Image Up
    Procedure mnuSelectLocation1Click(Sender: Tobject); //Select Visit Location
    Procedure MnuShowHintsClick(Sender: Tobject);
    Procedure MnuShowContextClick(Sender: Tobject);      //TP
    Procedure MnuSuspendContextClick(Sender: Tobject);   //TP
    Procedure MnuResumeGetContextClick(Sender: Tobject); //TP
    Procedure MnuResumeSetContextClick(Sender: Tobject); //TP
    Procedure mnuTEST2Click(Sender: Tobject);
    Procedure mnuTESTPatientOverlayClick(Sender: Tobject);
    Procedure mnutoggleHoldValuePopup(Sender: Tobject);
    Procedure MnuUseInternetExplorerforhelpClick(Sender: Tobject); //Use IE to display Web Help if checked
    Procedure mnuviewDetailsClick(Sender: Tobject);
    Procedure mnuviewListClick(Sender: Tobject);
    Procedure MousePan2Click(Sender: Tobject);
    Procedure MoveAll1Click(Sender: Tobject);
    Procedure MoveSelected1Click(Sender: Tobject);
    Procedure MoveSelectedToBatch1Click(Sender: Tobject);
    Procedure mRemoteLoginClick(Sender: Tobject);
    Procedure mSelectPatientClick(Sender: Tobject);
    Procedure mSysManClick(Sender: Tobject);
    Procedure MSysManhelpClick(Sender: Tobject);
    Procedure mtbAlignleftClick(Sender: Tobject);
    Procedure mtbAlignrightClick(Sender: Tobject);
    Procedure mtbAligntopClick(Sender: Tobject);
    Procedure mTestWriteDirClick(Sender: Tobject);
    Procedure mVideoOptionsClick(Sender: Tobject);
    Procedure N0scrollbar1Click(Sender: Tobject);
    Procedure N1024x7681Click(Sender: Tobject);
    Procedure N1152x8641Click(Sender: Tobject);
    Procedure N1280x10241Click(Sender: Tobject);
    Procedure N1600x12001Click(Sender: Tobject);
    Procedure N18901Click(Sender: Tobject);
    Procedure N800x6001Click(Sender: Tobject);
    Procedure NetSecurityON1Click(Sender: Tobject);
    Procedure NewNoteDefaults1Click(Sender: Tobject); //Apply Defaults for creating New Note
    Procedure oolbars1Click(Sender: Tobject);
    Procedure OpenDialogImportCanClose(Sender: Tobject; Var CanClose: Boolean);
    Procedure OpenPanWindow1Click(Sender: Tobject);
    Procedure OpenPanWindow2Click(Sender: Tobject);
    Procedure OpenViewerSortWindow1Click(Sender: Tobject);
    Procedure Other1Click(Sender: Tobject);
    Procedure Pan1Click(Sender: Tobject);
    Procedure PastefromClipboard1Click(Sender: Tobject);
    Procedure PasteImagefromClipboard1Click(Sender: Tobject);
    Procedure PatMenuitemSelected(Sender: Tobject);
    Procedure pLongDescResize(Sender: Tobject); //other actions happen when Long Desc panel is resized
    Procedure pnlImportResize(Sender: Tobject);
    Procedure Pointer1Click(Sender: Tobject);
    Procedure Pointer2Click(Sender: Tobject);
    Procedure PopupImageControlsPopup(Sender: Tobject);
    Procedure popupImportListPopup(Sender: Tobject);
    Procedure PopupMenuToolbarPopup(Sender: Tobject);
    Procedure popupTabctrPopup(Sender: Tobject);
    Procedure RefreshIndexlists1Click(Sender: Tobject);
    Procedure RemoveSelected1Click(Sender: Tobject);
    Procedure ReqTelChange(Sender: Tobject);
    Procedure Reset1Click(Sender: Tobject);
    Procedure Reset2Click(Sender: Tobject);
    Procedure right1Click(Sender: Tobject);
    Procedure Right2Click(Sender: Tobject);
    Procedure Rotate1801Click(Sender: Tobject);
    Procedure RotateLeft1Click(Sender: Tobject);
    Procedure RotateLeft2Click(Sender: Tobject);
    Procedure RotateRight1Click(Sender: Tobject);
    Procedure SaveImageAs1Click(Sender: Tobject);
    Procedure SaveImageAs2Click(Sender: Tobject);
    Procedure SavePatientNametoFile1Click(Sender: Tobject);
    Procedure SavePreferencesNow1Click(Sender: Tobject);
    Procedure SavePreferencesOnExit2Click(Sender: Tobject);
    Procedure savetoapppath1Click(Sender: Tobject);
    Procedure sbxEditFieldsClick(Sender: Tobject);
    Procedure sbxEditFieldsDockDrop(Sender: Tobject; Source: TDragDockObject; x, y: Integer);
    Procedure selectevent1Click(Sender: Tobject);
    Procedure ShowCPRSLinkMenuoption1Click(Sender: Tobject);
    Procedure showdimClick(Sender: Tobject);
    Procedure ShowImageGearInfotomsgwindow1Click(Sender: Tobject);
    Procedure ShowImageHDIB1Click(Sender: Tobject);
    Procedure ShowOpenForms1Click(Sender: Tobject);
    Procedure ShowTestMessages1Click(Sender: Tobject);
    Procedure mnuTESTINGSimulatePatientSwitchfromCPRS1Click(Sender: Tobject);
    Procedure Source1Click(Sender: Tobject);
    Procedure Stg1KeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure TabbingSequence1Click(Sender: Tobject);
    Procedure tabctrChange(Sender: Tobject);
    Procedure tabctrMouseDown(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer); //used in Dragging Buttons to new location
    Procedure tabctrMouseMove(Sender: Tobject; Shift: TShiftState; x, y: Integer); //used in Dragging Buttons to new location
    Procedure tabctrMouseUp(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer); //used in Dragging Buttons to new location
    Procedure TbePageClick(Sender: Tobject);
    Procedure TbePageEnter(Sender: Tobject);
    Procedure TbePageKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure TbePageKeyUp(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure TbicBrightnessChange(Sender: Tobject);
    Procedure TbicContrastChange(Sender: Tobject);
    Procedure TbicZoomChange(Sender: Tobject);
    Procedure tbPlayVideoClick(Sender: Tobject);
    Procedure tbwsAssocClick(Sender: Tobject);
    Procedure tbwsAssocMouseMove(Sender: Tobject; Shift: TShiftState; x, y: Integer);
    Procedure tbwsFormatClick(Sender: Tobject);
    Procedure tbwsFormatMouseMove(Sender: Tobject; Shift: TShiftState; x, y: Integer);
    Procedure tbwsModeClick(Sender: Tobject);
    Procedure tbwsModeMouseMove(Sender: Tobject; Shift: TShiftState; x, y: Integer);
    Procedure tbwsOtherClick(Sender: Tobject);
    Procedure tbwsOtherMouseDown(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
    Procedure tbwsOtherMouseMove(Sender: Tobject; Shift: TShiftState; x, y: Integer);
    Procedure tbwsSavingClick(Sender: Tobject);
    Procedure tbwsSavingMouseMove(Sender: Tobject; Shift: TShiftState; x, y: Integer);
    Procedure tbwsSourceClick(Sender: Tobject);
    Procedure tbwsSourceMouseMove(Sender: Tobject; Shift: TShiftState; x, y: Integer);
    Procedure TestCapObj1Click(Sender: Tobject);
    Procedure TimeoutTimerTimer(Sender: Tobject);
    Procedure Timer1Timer(Sender: Tobject);
    Procedure timerStayAliveTimer(Sender: Tobject);
    Procedure tlbrbtnActualClick(Sender: Tobject);
    Procedure tlbrbtnBriteMinusClick(Sender: Tobject);
    Procedure tlbrbtnBritePlusClick(Sender: Tobject);
    Procedure tlbrbtnDeSkewClick(Sender: Tobject);
    Procedure tlbrbtnDeSpeckleClick(Sender: Tobject);
    Procedure tlbrbtnFitHeightClick(Sender: Tobject);
    Procedure tlbrbtnFitToWinClick(Sender: Tobject);
    Procedure tlbrbtnFitWidthClick(Sender: Tobject);
    Procedure tlbrbtnFlipHorizClick(Sender: Tobject);
    Procedure tlbrbtnFlipVertClick(Sender: Tobject);
    Procedure tlbrbtnHandPanClick(Sender: Tobject);
    Procedure tlbrbtnInvertClick(Sender: Tobject);
    Procedure tlbrbtnMagnifyClick(Sender: Tobject);
    Procedure tlbrbtnPageFirstClick(Sender: Tobject);
    Procedure tlbrbtnPageLastClick(Sender: Tobject);
    Procedure tlbrbtnPageNextClick(Sender: Tobject);
    Procedure tlbrbtnPagePrevClick(Sender: Tobject);
    Procedure tlbrbtnPanWindowClick(Sender: Tobject);
    Procedure tlbrbtnPointerClick(Sender: Tobject);
    Procedure tlbrbtnResetClick(Sender: Tobject);
    Procedure tlbrbtnRotate90Click(Sender: Tobject);
    Procedure tlbrbtnRotatem90Click(Sender: Tobject);
    Procedure tlbrbtnZoomSelectClick(Sender: Tobject);
    Procedure tool1Click(Sender: Tobject);
    Procedure ToolBarCaptions1Click(Sender: Tobject);
    Procedure toolbarleft1Click(Sender: Tobject);
    Procedure top1Click(Sender: Tobject);
    Procedure UseOldHelp1Click(Sender: Tobject);
    Procedure Version25testingupdates1Click(Sender: Tobject);
    Procedure WebHelp1Click(Sender: Tobject);
    Procedure Window1Click(Sender: Tobject);
    Procedure writedir1Click(Sender: Tobject);
    Procedure Zoom1Click(Sender: Tobject);
    Procedure ZoomIn1Click(Sender: Tobject);
    Procedure ZoomIn3Click(Sender: Tobject);
    Procedure ZoomOut1Click(Sender: Tobject);
    Procedure ZoomOut3Click(Sender: Tobject);
    Procedure ZoomScrollBarsettings1Click(Sender: Tobject);
    //106 FormKeyDown
    Procedure FormKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);   {//117  TEST Menu item}
    procedure btnDicomFieldsGetDataClick(Sender: TObject);  {//117}
    procedure mnuDicomDataTestClick(Sender: TObject);  {//117}
    procedure btnDicomByUserClick(Sender: TObject);    {//117}
    procedure tlbrbtnAnnotationClick(Sender: TObject);    {/p122 /}
    procedure mnuAnnotationSettings1Click(Sender: TObject);  {/p122 /}
{  this will be out in p129  ResizeAnnotOverlay}
  (* p129
    procedure ResizeAnnotOverlay;
  *)
    {/p129  menu options for 129 and testing. Test Menu Items are
             not shown to sites.}
    procedure ForceErrortestEurekaLog1Click(Sender: TObject);
    procedure mg1ImageZoomScroll(Sender: TObject; VertScrollPos, HorizScrollPos: Integer);
    procedure mg1ImageKeyDown(Sender: TObject; var Key, Shift: Smallint);
    procedure mg1IGCoreCtlIGError(ASender: TObject; const ResRec: IIGResultRecord);
    procedure mg1ImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
    procedure mnuTESTINGCloseTwainSource1Click(Sender: TObject);
    procedure mnuTESTINGIsSessionChangedClick(Sender: TObject);
    procedure mnuTESTINGAnnotQuickInitClick(Sender: TObject);
    procedure mnuClearAllAnnotationsClick(Sender: TObject);
    procedure MagSubscriber1SubscriberUpdate(NewsObj: TMagNewsObject);
    procedure tlbrbtnAnnotationCloseClick(Sender: TObject);
    procedure Mg1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure mnuTestSaveImageAsClick(Sender: TObject);
    {p129t10 gek  TestMenu items... not visible to user.}
    procedure testMNUmg1FREE1Click(Sender: TObject);
    procedure mnuResetPanWindowClick(Sender: TObject);
    procedure mnuTESTShowContextDataClick(Sender: TObject);
    procedure mnuTestScriptForceAccusoftErrorsClick(Sender: TObject);
    procedure mnuTestScriptDontUseCCOWClick(Sender: TObject);
    procedure mnuTestScriptForceCopyExceptionsClick(Sender: TObject);
    procedure sLEEP301Click(Sender: TObject);
    procedure mnuLoadDSSourcesClick(Sender: TObject);
    procedure mnuTESTAccuVersionClick(Sender: TObject);
    procedure Info1Click(Sender: TObject);
    procedure mnuSaveAsPDF1Click(Sender: TObject);
    procedure mnu140ClearPDFfileClick(Sender: TObject);
    procedure mnu140RLEClick(Sender: TObject);
    procedure mnu140JPGClick(Sender: TObject);
    procedure btnReviewClick(Sender: TObject);
    procedure mnuTestEnableMultipageClick(Sender: TObject);
    procedure mnuCombineTIFscansClick(Sender: TObject);
    procedure OptionsClick(Sender: TObject);
    procedure mnuCombinePDFScansClick(Sender: TObject);
    procedure mnuTestOpenTempDirectoryinExplorerClick(Sender: TObject);
    procedure ShowCapXFalse1Click(Sender: TObject);
    procedure AllPagesCheckedTrue1Click(Sender: TObject);
    procedure ShowCapXtrue1Click(Sender: TObject);
    procedure mnuTESTClosePDFFileClick(Sender: TObject);
  private
    CapRunMode : TMagRunMode;
    {p129t10 gek  Flag, to allow workaround of Resetting the PanWindow only once.}
    FPanWindowReset : boolean;
    FTestShowContextData : boolean;
//ccowout      FCapContextor: TContextorControl;    //TP
//ccowout     //? why here ?  LastWindowsMessage: String;      //TP
//ccowout     //? why here ?  LastWindowsMessageHandle: Hwnd;  //TP
//ccowout      Vpatid: String;                  //TP
//ccowout  //XTPCCOWdfn: string;                    //TP

    CapDFN   : string  ;   {/gek 129T5  try fix CCOW Patient problem.}

//TESTING
     {This is for Testing at the moment.  not yet complete }
  procedure BrokerOnPulseError(peBroker : TRPCBroker ; peErr : string);
 {129 t18   new procedure for Checking the mag.ini to see if capture copied it. }
  Procedure  CreateIFNeededFromCapture();
{p129t18  put the Mark of 'Capture ' in the INI}
  procedure MarkOfCapture(value : string);
{p129t18 DidCapAppMarkINI :   this tells us if the Capture application was the app
                              that copied the INI to the new Path and renamed to mag.ini}
  function DidCapAppMarkINI(value : String): boolean;

//ccowout    Function GetContextValue(Key: String): String; //TP
    procedure CheckForAnnotationFontResource;
{/p129 functions for changes to Annotations, Gear1 out.}
    procedure ShowScrollSettings;
    procedure MagAspectRatio(mode: integer; value : integer = 0 );
    procedure MagResetPanWindow;

    function AnnotationsExist: boolean;
    procedure AnnotationsClose;
    procedure AnnotationsUpdateSessionInfo(UserCapName, UserServiceSection, Magien, UserDUZ,
      WrksInstStationNumber: string);
    function AnnotationsSaveAnnotationsToDB(newMagIEN : string): boolean ;


    function AcquireGear16: Boolean;
    procedure AnnotationQuickInit(magIEN : string);
    procedure AnnotationsEnableForSessionCompute;
    procedure AnnotationGetConsultResulted();  //duc in 
    procedure mg1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CapAnnotationHide;
    procedure CapAnnotationShow;
    procedure DisableComponentsDuringAnnot(value: boolean);
    procedure DisableImageManips(value : boolean);  //duc in

    procedure CreateGearComponent;  {JK 6/27/2012 - encapsulate the gear creation process into a method}
    {gek/ not sure if this is needed. mg1DragOver}
     procedure mg1DragOver(Sender, Source: Tobject; x, y: Integer;  State: TDragState; var Accept: Boolean);
    procedure ForceRepaint;
    procedure AnnotationsEnableforImage(value: boolean);
    procedure AnnotationsEnableForSession(value: boolean);
    {p129t10 gek PanWindow issue .}
    procedure RELoadGear;
    procedure PanWindowReset;
    procedure CapImageVClick(Sender: Tobject; VGear: TMag4VGear);
    procedure SetPanWindowWithActivateOption(Value, Activate: Boolean);
    procedure CaptureFinalInit;
    procedure CCOWIconMenuUpdate(ccowstate: integer);
    procedure ChangeToCCOWPatient;
    function DoesCCOWConflictCRPS: boolean;
    procedure SetCapRunMode(runmode: TMagRunMode);
    procedure ErrorInGearClear;
    procedure RmvSlash(num: integer; var Dir: string);
    procedure SaveImageASpdf;
    procedure CopyMultiPagePDF(Xmagien: string);
    procedure OpenConfigurationSettingsWindow;
    procedure ShowReviewButton(value: boolean);
    procedure ShowCapX(tomsghistory : boolean);




 //   procedure MagCapSubscriberUpdate(NewsObj: TMagNewsObject);

(*
    procedure Log(loglvl: TmagMsgLvl; msg: String);
    procedure LogMsg(Code: String; Msg: String; msgprior: TMagMsgPriority = magmsgINFO) ;
    procedure LogMsgs(Code: String; Msgs: Tstringlist; msgprior: TMagMsgPriority = magmsgINFO);
    procedure MagMsg(Code, Msg: String);
    procedure MagMsgs(Code: String; Msgs: Tstringlist);
    procedure ShowLog;
    Procedure SetPrivLevel(Level: Integer);
*)



  Protected
     NeedToCheckCPRSParams : boolean;
     NeedToCheckCPRSPatientDFN : string;
    { DONE -o129 : this was a property on the form.  FCapAnnot.ConsultResulted
        we need to make a varialbe,  set it and test it to see if Display's Annotation
        form needs to be changed  line to dash line, or other way.
        fix: the value of this variable FCapAnnotconsultResulted. is computed elsewhere.  when TIU Notes are
         in the Mix.}
    FCapAnnotConsultResulted : boolean;
    mgPatImage: TMag4VGear; // p129
    FAlreadyTurnedPage: Boolean;
    {/p129 AltViewer is now decided on by user for DCM, TXT, PDF.
         so it can change during the session, New variable to see if
         user has selecte    Using Alt Viewer for certain formats.}
    //p129    FAltViewerNeeded: Boolean;
    FUsingAltViewer : boolean; {FUsingAltVIewer  p129}
    FAutoDeSkew: Boolean;
    FAutoDeSpeckle: Boolean;
    FAutoPreviewNote: Boolean;
    FBatchDelete: Boolean;
    FBatchEditDescOnSave: Boolean;
    FBatchShowOptions: Boolean;
    FCapClinMgr: TMagCapClinMgr; {p59 new object}
    FCapSaveBIG: Boolean;
    Fconfirmmsg: Boolean;
    FCurrentSettingsTB: Boolean;
    FdftAssoc: String;
    FdragTab: Integer;
    FDragtabx: Integer; {p59}
    FDragTaby: Integer; {p59}
    FDragTo: Integer;
    FErrorInGearFlagShowDups : boolean;
    FErrorInGearFlagShowALL : boolean;
    FErrorInGear: Boolean;
    FErrorInGearList: Tstringlist;
    FErrorInGearListCode: Tstringlist;
    FGearScrollHoriz: Integer;
    FGearScrollVert: Integer;
    FGearZoomValuePositional: Integer;
    FGearZoomValueStatic: Integer;
    FImageCaptureDate: String;
    FImageChanged: Boolean;
    FImageTB: Boolean;
    FLockScrollBarPos: Integer;
    FLockScrollBarsAlways: Boolean;
    FLockScrollBarsFitToWin: Boolean;
    FLockScrollBarsPositional: Boolean;
    FLockScrollBarsStatic: Boolean;
    FLoginOnStartup: Boolean;
    FModFLIP: Boolean;
    FModINV: Boolean;
    FModROT: Integer; // FlipROT: integer;
    FoldAutoDescPkg: String;
    FoldAutoDescType: String;
    Fplayvideofile: Boolean;
    FSavedConfigsMultiLine: Boolean;
    FSavedConfigsTB: Boolean;
    FSaveUserSettingsOnExit: Boolean; // Not Done
    FShowHints: Boolean;
    FuprefCapTIU: TuprefCapTIU; {p59 changed}
    Fusealtviewer: Boolean;
    {p129  new for users to choose to use alternate viewers. }
    FAltViewerPDF : boolean;
    FAltViewerDCM : boolean;
    FAltViewerTXT : boolean;
    FAnnotInitForImage : boolean;
    originalPanelWindowProc: TWndMethod;
    procedure PanelWindowProc(var Msg: TMessage);
    procedure PanelImageDrop(var Msg: TWMDROPFILES);

    //
    Function FileImageAndCopyImage(Var Magien: String): Boolean;
    Function FileTypeSupported(Ext: String; Var Itype: String; Var idesc: String): Boolean;
    Function FileTypeSupported2(Ext: String; Var Itype: String; Var idesc: String): Boolean;
    Function GetAbsToShow(Image: String): String;
    Function GetDirImport: String;
    Function ImageChangedOther: Boolean;
    Function ImageTypeNeedsAbs(Filename: String): Boolean;
    Function IsGearClear(mVGear: TMag4VGear): Boolean; // function called from various methods. Tells if Viewable image is loaded.
    Function IsImageChanged: Boolean;
    Function IsImageclear(mVGear: TMag4VGear): Boolean; // function called from various methods. Tells if Image (viewable or not viewable) is loaded
    Function IsImageCleared: Boolean;
    Function IsValidAdvanceDirective: Boolean; // checks that Type Index is AdvDir if Note is AdvDir.
    //Function Magexecutefile(Const Filename, Params, DefaultDir: String; ShowCmd: Integer): THandle;
    {P129T17   Modify the MagExecutefile to add "" around file and parameters., default 'open' as OPeration}
    Function Magexecutefile(Const Filename, Params, DefaultDir: String; ShowCmd: Integer; Oper: String = 'open'): THandle;
    Function PasteGear: Boolean;
        {//p94t1 gek 9/25/09  Change name of function from PatientChangeWarning  to PatientChangeWarningIfNeeded}
    function PatientChangeWarningIfNeeded(): boolean; //called when patient changes, to see if warning is necessary
    Function ResolveDateTime(): Boolean;
    Function StripTime(datetime: String): String; // Doc Image Date.  We don't want a time.
    Function TIUAuthorized(Var Rmsg: String; VClinDataobj: TClinicalData): Boolean;
    Procedure AccusoftPropertiesLog(Desc: String);
    Procedure AdvancedBatchCopyAll(bcNewdir, bcFileNamene: String); //FileName has no extension
    Procedure AlignlstBoxImport;
    Procedure ApplyImportDirFromList; // New Function.  Load Images from a selected Import Directory.
    Procedure ApplySavedWindowSettings;
    Procedure AppMessage(Var Msg: TMsg; Var Handled: Boolean);
    Procedure AssocFilingError(Spec, serr, specdesc, sysinf, magptr: String; Var oktocontinue: Boolean);
    Procedure AutoImageDesc(Desc: String; descsource: TmagDescSource); // modified to use TmagDescSource as the Default
    Procedure CallBrokerX;
    Procedure CancelCapture(ClearImage: Boolean = True);
    Procedure CAPPreCap;
    Procedure ChangeToPatient(newdfn: String);
    Procedure CheckCurAssoc;
    Procedure ColapseLongDesc; // minimize the Long Desc field when button pushed.
    Procedure ComputeZoomLevel(Left, Top, Right, Bottom: Integer);
    Procedure ControlledImage(Value: Boolean);
    Procedure ControlledImageToggle;
    Procedure CopyMultiPageFile(Xmagien: String);
    Procedure CprsSyncDefaults;
    Procedure CreateDynamicHelpMenu; //Later if any dynamic help files are in the directory, they will be placed on the Help Menu
    Procedure CreateDynamicMenu;
    Procedure CreateDynamicPatMenu;
    Procedure CreateVideoWindow;
    Procedure DisableKeyDependentObjects;
    Procedure DisplayConfigValues(Xobj: TWinControl; oleft, otop: Integer; Desc: String);
    Procedure DragAndDropFiles(Value: Boolean);
    Procedure EnableCPFunctionsCAP(isCPInstalled: Boolean);
    Procedure EnableKeyDependentObjects;
    Procedure EnablePatientLookupLogin(Setting: Boolean);
    Procedure EnableTestFunctions(Tf: Boolean);
    Procedure EnableTIFFunctions(Tf: Boolean);
    Procedure FileToListView(AddFile: String; Var LV: TListView; Insertat: Integer);
    Procedure GearCapPasteFromClip; //method created from existing code. called from menu, buttons and other methods
    Procedure GearCopy;
    Procedure GearFitToActualSize; //method created from existing code. called from menu, buttons and other methods.
    Procedure GearFitToHeight; //method created from existing code. called from menu, buttons and other methods.
    Procedure GearFitToWidth; //method created from existing code. called from menu, buttons and other methods.
    Procedure GearFitToWin;
    Procedure GearFlipH;
    Procedure GearFlipV;
    Procedure GearInvert; //method created from existing code. called from menu, buttons and other methods.
    Procedure GearMouseMagnify; //method created from existing code. called from menu, buttons and other methods.
    Procedure GearMousePan; //method created from existing code. called from menu, buttons and other methods.
    Procedure GearMousePointer; //method created from existing code. called from menu, buttons and other methods.
    Procedure GearMouseZoomSelect; //method created from existing code. called from menu, buttons and other methods.
    Procedure GearPanWindow; //method created from existing code. called from menu, buttons and other methods.
    Procedure GearReset;
    Procedure GearRotate(degree: Integer); //method created from existing code. called from menu, buttons and other methods.
    Procedure GearScrollTL;
    Procedure GetImportDirsFromINI; // New Function. Get list of saved Directories to Import images.
    Procedure GetIndexLists;
    Procedure GetpatientPhoto(Xdfn: String);
    Procedure GetUserCapPref;
    Procedure GetViewerFlags(Image: String; Itype: String; Var altviewerfile, avifile: Boolean);
    Procedure GoToPage(i: Integer);
    Procedure HideBatchListView;
    Procedure HideImportDirList; //Hide the list of Import Directories when user selects one, or clicks Up Arrow.
    Procedure HideRequiredMsg;
    Procedure ImageEntryDelete(Var Ien: String; NoImage : string = '');
    Procedure ImagingCaptureLogin(Vserver, Vport: String; Forcethisconnection: Boolean);
    Procedure ImagingCaptureLogoff;
    Procedure ImportBatchMoveAll; //called from menu and button, moves all ImageFiles from Batch list
    Procedure ImportBatchRemoveAll; //called from menu and button, removes all ImageFiles from Batch list
    Procedure ImportFile(LV1: TListView; Inc: Integer);
    Procedure InvalidPage;
    Procedure LinkHoldValues(hold: Boolean);
    Procedure LoadHelpMenu; // This checks Imaging dir, and loads any MagWhatsNew* or MagReadMe* as items on the Help menu.
    Procedure loadimportfiles(MagSelectImportDirf: TMagSelectImportDirf);
    Procedure LoadOriginSet;
    Procedure MoveSelected(FromLV, ToLV: TListView; Li: TListItem = Nil);
    Procedure msgslist(Ts: TStrings);
    Procedure NewLoadImportFiles(FileList: TStrings; Filter: String = '');
    Procedure Nextpage;
    Procedure NoteDateCheck; // checks the Date of the Note. for New Notes and User supplied Date.
    Procedure OpenAllFiles;
    Procedure OpenBatchOptions;
    Procedure OpenImageMenu(x, y: Integer);
    Procedure OpenHoldMenu(x, y: Integer; Source: TControl; magNoClear: TmagLabelNoClear);
    Procedure OpenProcHoldMenu(x, y: Integer; Source: TControl; magNoClear: TmagLabelNoClear);
    Procedure OpenSysManHelp;
    Procedure OpenVideoOptions;
//RCA OUT    Procedure OpenViewerSortWindow;
    Procedure OptionWindowSetSettings; {p59 Form name change}
//p129 out.    Procedure OverlayPatInfo;
    Procedure PatientChangeWarningHide; //  Warning is confirmed, hide warning panel
    Procedure PatientChangeWarningShow; //Patient has changed but image remains, show warning
    Procedure Prevpage;
    Procedure ProcessVistAMessage(XHandle: Hwnd; Vmsg: String);
    Procedure Resetcontrols;
    Procedure ResetOther;
    Procedure SaveDefaultDirectory(Dir: String); // New Function to save Import Dir to configuration
    Procedure SaveImageAS;
    procedure SaveLoadPastedImage;
    Procedure SaveImportDirsToIni; // New Function save ImportDir list to INI for reload next session
    Procedure SaveWindowSettings;
    Procedure ScrollToItem(LV: TListView; ListIndex: Integer);
    Procedure SelectImportDirectory5(pdir: String = ''; pallFiles: Boolean = False);
    Procedure SelectVisitLocation; // new function for user to select a visit Location.
    Procedure SetConfigBtnsLeft;
    Procedure SetConfigBtnsTop;
    Procedure SetDirImport(Const Value: String);
    Procedure SetImageOK;
    Procedure SetImportLabelDesc(VDir: String);
    Procedure SetPageControls;
    Procedure SetSettingsToNull;
    Procedure SetStudyComplete;
    Procedure SettingsEditAssociation;
    Procedure SettingsEditFormat;
    Procedure SettingsEditMode;
    Procedure SettingsEditSavingAs;
//    Procedure SettingsEditSource;
    Procedure SetUserAssociations;
    Procedure SetUserCapPref;
    Procedure SetViewAbleImage(Value: Boolean; Image: String = '');
    Procedure SetWorkstationTimeout(Minutes: String);
    {/p129  Using Tmag4VGear, so the zoom function needs changed.}
    Procedure SetZoomLevel(Value: Integer;  DoClickEvent : boolean = true);
    Procedure ShowBatchListView;
    Procedure ShowCapObj(vCapObj: TCaptureObject);
    Procedure showgeardimensions;
    Procedure ShowImageProperties(Filename: String; ashint: Boolean = False);
    Procedure ShowImportDirList; // Show the list of Import Directories when user clicks Down Arrow.
    Procedure SmoothImage;
    Procedure StartWithParameters;
    Procedure SyncBatch;
    Procedure ToggleMultiLineButtons;
    Procedure toolbartop(Value: Boolean);
    Procedure UnCheckAllAssoc;
    Procedure UpdateWindowcaption;
    Procedure WMGetMinMaxInfo(Var Message: TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
    Procedure WMMOVE(Var Message: TWMMOVE); Message WM_MOVE;
    Procedure ZoomScrollInitialSettings;
    Procedure ZoomScrollSave;
    function  AreUsingAltViewer(image : string) : boolean;
    	{p94t2 gek out for decouple}
    //        procedure OpenVerifyReport(dtfrom, dtto, desc: string);
  Public

    FIsProdAccount: boolean;

    {/p129  TGear out ->>  mg1:TMag4VGear replaces Gear1:TGear;}
    mg1 : TMag4VGear;

    FAddDirOnSelect: Boolean;
    FALOProcEvent: Boolean; {AutoListOpen Event}
    FALOSpecSubSpec: Boolean; {AutoListOpen Spec}
    FALOType: Boolean; {AutoListOpen Type}
    FCapClinDataObj: TClinicalData; {p59 new object in place of TiuPtr}
    FClass: String;
    FCloseQuickSetting: Boolean;
    FConfigButtonsMoved: Boolean;
    FControlledImage: Boolean; //p93t8
    FisCPInstalled: Boolean;
    FLastSelectedConfig: String;
    FLockStudy: Boolean;
    FmagAssoc: String;
    Fminimumseperation: Boolean;
    FViewingLatestImage: Boolean;
    MagFileObj: TCaptureObject;
    MagHelpMenu: TMag4Menu;
    MagMenuConfig: TMag4Menu;
    MagPatMenu: TMag4Menu;
    TempFileObj: TCaptureObject; {p59 new object}
//p129t11  gek 'UserDir' definition  moved to uMagDefinitions
//  and renamed to GUserDir so other forms apps can use if needed.
   // UserDir: TSessionDirectories; {p59 new object}

    { in p106 were protected,  in 117 moved to public.
    {/p117 gek Renamed DicomData to FDicomDataArray.   'DicomData' used in mag4VGear. 
        split one array, into two. One for user selected, One for generated - and added starting 'F'}
    
    FDicomDataArray: Tstringlist;
    FDicomDataUserArray : Tstringlist;
    {/p117 gek Renamed TRCDICOMDefaults to FDicomDefaultsArray. - starting 'F', and similiar to above.}
    FDicomDefaultsArray: Tstringlist;
    //p122t11 dmmn - list keep track of image orientation manipulation like rotate/flip so that
    //we can undo these action before saving for TRC images since we have existing problems with 106 dicom
    //conversion
    FAnnotationManips : TStringList;
    //FTRCImageManips : Boolean;         //p122t12 this is no longer needed because we already have a function to track this

    TIFWarnFirst : Boolean; //p122t11 flag to warn multipage tif TRC
{duc 131 change }
    FoImgPath, FbImgPath, FwImgPath: string; //p129t18 paths for Original image in the import folder
                                  //                  Working image in the temp folder



    procedure AllPagesChecked(val: boolean);

    Procedure CanCaptureChangePatient(var msg: string; var status : boolean);//gek 9/7/12 CCOW

    Function AbleToTeleconsult: Boolean;
//p129    Function AcquireGear: Boolean;
    Function BrokerError: Boolean;
    Function CanUserCapture(capspec: String): Boolean;
    Function CopyTheFile(FromFile, ToDir: String): Boolean;
    Function ErrorInGear(mgGear: TMag4VGear; Filename: String; action: String; noshow: Boolean = False): Boolean;
    Function FileAssocPointers(ImagePointer: String; Var Retmsg: String; Var contOnError: Boolean): Boolean;
    Function GearClear: Boolean;
    Function GetDefaultOriginIndex: Integer;
    Function IsAssocTRCOK: Boolean; //106t10
    Function IsPatientSelected(showwinmsg: Boolean = True): Boolean;
    Function IsStudyGroupComplete: Boolean;
    Function LoadGear(Image, displaytext: String): Boolean;
    Function OKToChangeSpec(newspec: String): Boolean;
    Function ReadableAssoc(Magassoc: String): String;
    Function ReadableShortAssoc(Magassoc: String): String;
    {/p117 gek, need a function to display readable name of selected RadioButton.}
    { TODO : look into this function, might not need it due to name change in 106
              not urgent}
    function ReadableShortAssocRBName(rbname: String): String;
    Function SaveGear(Image: String): Boolean;
    Function SaveImageTextFile(Var Xmsg: String): Boolean;
    Function ShowFmDate(fmdate: String): String;
    Function ShowFmDateMMMNoTime(fmdate: String): String;//p106 rlm CR604
    Function ShowFmDateDetail(fmdate, Format: String): String;//p106 rlm CR604
    Function TRCGetSOPIEN(SOPAlias: String; Out SOP_CLASS_UID, SOPIEN, ERROR: String): Boolean; //p106 rlm 20101008, Result is SOP IEN
    Function TRCSaveAsDICOM(): Boolean;
    Function UpdateTeleReaderConsult(ImagePointer: String; Count: Integer): Boolean;
    Function WriteGroupDescriptions(ShortDesc, LongDesc: String): Boolean; //p106 rlm 20101011
    Procedure AcceptFiles(Var Msg: TMessage); Message WM_DROPFILES;
    Procedure AccusoftPropertiesShow;
    Procedure AdvancedBatchEnable(Value: Boolean);
    Procedure AfterMultiPageScan;
    Procedure ApplyWorkstationSettings;
    Procedure ButtonSettings(i: Integer);
    { The Cap* procedures are specific to the Selected  Input Source }
    Procedure CapClipboard(Sender: Tobject);
    Procedure CapImport(Sender: Tobject);
    Procedure Caplumisys150(Sender: Tobject);
    Procedure Caplumisys75(Sender: Tobject);
    Procedure CapMeteor(Sender: Tobject);
    Procedure CapScannedDocument(Sender: Tobject);
    Procedure CapTwain(Sender: Tobject);
    Procedure CAPtestscan(Sender: Tobject);
     //
    Procedure CaptureIsValid;
    Procedure ClearAllText;
    Procedure ClearCurrentPatient(Ignorenoclear: Boolean = False);
    Procedure ConfigButtonClick(Sender: Tobject);
    Procedure DefaultHandler(Var Message); Override;
    Procedure DisableProcDate;
    Procedure EnableMultiPageScan;
    Procedure EnableProcDate;
    Procedure EndProgress;
    Procedure FileGroup(Var imagefiled: Boolean);
    Procedure FileImage(Var imagefiled: Boolean; Var Magien: String; Var vNewImageFile: String);
    Procedure GearDeSkew();
    Procedure GearDeSpeckle();
    Procedure GetTabSettingsFromINI(Var t: Tstringlist);
    Procedure HideImportDir;
    Procedure hotbuttonClick(Sender: Tobject);
    Procedure IncProgress;
    Procedure InitProgress(Max: Integer);
    Procedure LoadClinicalDataFromConfiguration(vClinDataStr: String); // modified to include Import Dir. data now loaded into Object.
    Procedure LoadFieldsFromClinicalData(VClinDataobj: TClinicalData); // Display data contained in the TclinData Object
    Procedure LoadFieldsFromClinProcData(DataString: String);
    Procedure LoadFieldsFromTIUData(VClinDataobj: TClinicalData); //  Display data contained in the TIUDate field of the TClinData Object
    Procedure LoadFieldsFromTRConsultData(DataString: String);
    Procedure loadlablists;
    Procedure LoadNoteGlyphs(VClinDataobj: TClinicalData); // new Bitmaps for Note Actions and Status
    Procedure LoadStaticFields;
    Procedure LOOKUPClinProc(Sender: Tobject);
    Procedure LOOKUPIndexType;
    Procedure LOOKUPlaboratory(Sender: Tobject);
    Procedure LOOKUPmedicine(Sender: Tobject);
    Procedure LOOKUPradiology(Sender: Tobject);
    Procedure LOOKUPSurgery(Sender: Tobject);
    Procedure LOOKUPtiu(Sender: Tobject);
    Procedure LOOKUPTRConsult(Sender: Tobject);
    Procedure MakeAbs(ImageFilename, AbsFileName: String);
    Procedure MakeStudyReadOnly;
    Procedure NewStudy(Ignorenoclear: Boolean = False);
    Procedure OpenAllFilesX(pdir: String);
    Procedure OpenConfigList;
    Procedure OpenPatient;
    Procedure OptionWindowGetSettings;
    Procedure PlayPatVideoImage(Image, Desc: String; Magien: String = '');
    Procedure PlayTheFile(Run: Boolean);
    Procedure RedisplayMultiline;
    Procedure RefreshIndexLists;
    Procedure SaveButtonConfigsToINI;
    Procedure SaveTabSettingsToINI(Var t: Tstringlist);
    Procedure SelectImportDirectory4(pdir: String = ''; pallFiles: Boolean = False);
    Procedure SetDefaultAssociation(dftAssociation: String);
    Procedure SetDefaultImageFormat(DFTimageFormat: String);
    Procedure SetDefaultInputSource(dftinputsource: String);
    Procedure SetImportBatchMaxHeight;
    Procedure SetImportMaxHeight;
    Procedure SetMedProc(s: String);
    Procedure SetSelected(LV: TListView; Value: String);
    Procedure ShowImportDir;
    Procedure ShowNoteGlyphs(VClinDataobj: TClinicalData); //  display the Note bitmaps, not Text
    Procedure Testmsg(s: String);
    Procedure ToolbuttonsUp;
    Procedure UpdateProcFromSpec;
    Procedure UpdateSpecFromProc;
    Procedure VistaWrite(CaptName: String);
    Procedure WinMsg(c, s: String; msgpanel : Tpanel = nil);
    Procedure ZoomScrollApply;
    {/p117gek testing.  On Testing menu, not visible to sites.}
    procedure TESTDicomGetUserData;
    procedure TESTDicomGetGeneratedData;

//ccowout      Procedure UpDate_(SubjectState: String; Sender: Tobject);  //TP
//ccowout  Procedure RIVRecieveUpdate_(action: String; Value: String);  //TP


    Procedure SettingsEditSource;    //moved to public p129
  Published
    Property DirImport: String Read GetDirImport Write SetDirImport;
  End;

Var
  //p129  fCapAnnot : TfrmMagCapAnnotation; {/P122 - DMMN - 6/21/2011 - overlay form to allow annotate /}
  //p129  FCapConfigRadiologyState : boolean; //p122t5 10/10 dmmn keep the state for rad association
  FTestScriptForceAccusoftErrors : boolean;
  FTestScriptForceCopyFileException : boolean;
  FCapDevTest : boolean;     // flag, that when True, will show the Testing Menu's

  ABSbyJB: Boolean;
  ABSCreated: Boolean;
  ABSForImage: Boolean;
  AllowRemoteLogin: Boolean;
  Angle: Integer;
  //  AppPath: String;
  batchimagedescription: String;
  BlankImage: String;
  CategorylistAll: TStrings;
  cmd: String;
  Count: Integer;
  CPPtr: String;
  CPRSChangePatient: Boolean;
  //CprsStartedME: Boolean;
  CprsSync: CprsSyncOptions;
  CtgByClass: TStrings;
  curcolumnindex: byte;
  DateTimeProc: String;
  dftimportdirloaded: Boolean;
  Exeprocessinfo: TprocessInformation;
  FGfiletoImport: String;
  Fignorechange: Boolean;
  // 140  CapX Format: String;
  //  GCapFormat: String;
  Frmcapmain: TfrmCapMain;
  glbParam: String;
  GroupFile: String[30];
  GrpDesc: String[60];
  GrpPtr: String;
  //140 CapX    ImageType: Integer;
  ImgProcEventPtr: String;
  ImgSpecSubSpecPtr: String;
  ImgTypePtr: String;
  ImportIni: String;
  IniColorscan256: Boolean;
  IniFormat: INIImageFormat;
  IniImageDescCurEnd: Boolean;
  CapIsInitialized: Boolean;
  IniUseImageDesc: Boolean;
  LabPtr: String;
  LastMagUpdate: String;
  lastProcEventEntry: String;
  lastSpecSubSpecEntry: String;
  ListenerPort: Integer;
  LocalServer: String;
  loginflag: Boolean;
  Magassoc: String;
  MagSysProcessInfo: TprocessInformation;
  MedPtr: String;
  Mylist: Tlist;
  NmTsks: Integer;
  Nullsetting: String;
  //129t11 gek out.      OldTempDir: String;
  Patintinf: String;
  Pdemog: String;
  PtType: String;
  QueMsgList: Tstringlist;
  RadPtr: String;
  Result: THandle;
  savefiletype: Integer;
 // Scanmode: String;
  scanstatus: Integer;
  SortInverse: Boolean;
  SurPtr: String;
  TabSeqList: Tstringlist;
  TempFile: String;
  timerclose: Boolean;
 //p106    TRC
  TRCImageCtr: Integer;
  TRConsultDataString: String;
  TRConsultDate: String;
  TRConsultPtr: String;
  TRConsultService: String;
  TRCSeriesNum: String;
  TRCSeriesUID: String;  
  TRCSOPClass: String; 
  TRCSOPClassIEN: String;
  TRCErrorMsg: String;
  TRCSOPInstanceUID: String;
  TRCStudyUID: String;
  TxtFile: Text;
  UserCapDuz: String;
  UserCapName: String; //UserCapName: String[30]; //106
  Windir: String;
  WindowsMessageID: Word;
  winsysdir: String;
  WorkStationTimeout: Longint;
  writedir: String;
  WrksCompName: String;
  WrksLocation: String;
  Wsid: String;
 
  {/p129 new Object to handle Twain scanning functions for Capture.}
  MagTwain1 : TMagTwain;
//  MagCapSubscriber : TmagSubscriber;
Implementation


Uses

  Shellapi,
  ShellCtrls,
  Spin,
  SysUtils,
  Types,
  DateUtils,
  ddeml,
  FileCtrl,
  Inifiles,
  MPlayer,
   //Broker files.
  Hash,
    //imaging files.
// RCA out  cMag4Vgear,
// RCA out cmag4viewer,
  cMagListView,
  cMagPat,
  dmsingle,
  FEdtLVlink,
  FMagAbout,
  FmagCapBatchAdv,
  FmagCapBatchImageDesc,
  FmagCapBatchOptions,
  FmagCapConfig,
  FmagCapDragTab,
  fmagCapGrpComplete,
  FmagCapIconLegend,
  fmagCapInfoWindow,
  FmagCapSaveConfig,
  FmagCapSettings,
  FmagCapTabOrder,
  FmagCapTIU,
  FmagConfigList,
  FmagDateTimeDialog,
  FmagDoNotClear,
  FmagGetEsigDialog,
//FmagIGCtls3,  //P106 rlm 201009021225
  FmagPasswordDlg,
//RCA out  fmagVerify,
//RCA out    fmagVerifyStats,
  FmagVideoOptions,
  FmagVideoPlayer,
//RCA OUT  Fmagviewersort,
  FmagVistALookup,
  FmagWebHelp,
  FmagWebHelpMapping,
  Fmxutils,
//p129    GEAR,
//p129    Geardef,
//p129    Geardef7,
  //RCA  Magauto,
  MagBroker,
  MagClinProcf,
  MagExeWait,
  Magfileversion,
  MagFloatConfigu,
  Magglabu,
  Maggmcu,
  Maggridu,
  Maggsuru,
  Magguini,
  Maggut1,
  MagLastImages,
  Magpositions,
  MagPrevInstance,

  MagTestDicomNumbers,
  MagTimeout,
  Magwkcnf,
//140 Refactor  RecentUpdatesu,
  RPCconf1,

 // uMagAppMgr,
  uMagAppMgrCap,
  uMagGearUtils,
  uMagKeymgr,
  uMagThumbmgr,
  uMagTIUutil,
  uMagutils8
        {$IFDEF MeteorBoard}
        , MagMeteor1
        {$ENDIF}
  ,fmagTESTDicomData       //p117  Dicom Data selection
 ,  fmagCapUtilForm  //p117 function from Display, clear directories (Photo cache)
  //TP moved up   ,  ImagDMinterface
  {/p129  Annotation functions that were created for Display are now used in capture.}
  , fMagAnnotationOptionsX;

{$R *.DFM}

procedure TfrmCapMain.SetCapRunMode(runmode : TMagRunMode);
var ccowstate : string;
     ccowint : integer;
begin
 CapRunMode := runmode;
 case runmode of
   magrmAlone:
     begin
     lbRunMode.Caption := 'TESTING: No Context ';
     lbRunMode.Hint := 'The Patient is NOT synchronized with any application';
     end;
   magrmCPRS:
     begin
     lbRunMode.Caption := 'TESTING: CPRS Sync ';
     lbRunMode.Hint := 'The Patient is synchronized with CRPS Patient.';
     end;
   magrmCCOW:
     begin
     lbRunMode.Caption := 'TESTING: CCOW Context ';
     lbRunMode.Hint := 'The Patient is synchronized with CCOW Context.';
     idmodobj.GetCCOWManager.GetState_(ccowstate);
     ccowint := strtoint(ccowstate);
     case ccowint of
    // 0-NO CCow, 1-In Contxt, 2-Changing, 3- Broken}
        0 :
          begin
            {if run mode is magrmCCOW , CCOW State should never be 0, but put in anyway}
            lbRunMode.Caption := 'TESTING: CCOW OFF ';
            lbRunMode.Hint := 'CCOW Contextor is not available.';
          end;
        1 :
          begin
            lbRunMode.Caption := 'TESTING: CCOW Context ';
            lbRunMode.Hint := 'Patient is synchronized with CCOW Context.';
          end;
        2 :
          begin
            lbRunMode.Caption := 'TESTING: Context Changing ';
            lbRunMode.Hint := 'CCOW Context is Changing...';
          end;
        3 :
          begin
            lbRunMode.Caption := 'TESTING:Context Suspended ';
            lbRunMode.Hint := 'CCOW Context is Suspended. Patient can be different that other Applications.';
          end;
     end;
     end;
 end;
end;



Function TeleMedSingle: Boolean;    //p106
Begin
  Result := False;
  If (FrmCapConfig.TeleReaderConsult.Checked) And (FrmCapConfig.SingleImage.Checked) Then Result := True;
End;

Function TfrmCapMain.CopyTheFile(FromFile, ToDir: String): Boolean;
Begin

  Try

  ////////////////   TESTING  TEST TEST
  if FTestScriptForceCopyFileException then
          Raise exception.Create('FORCE ''CopyTheFile Exception'' FOR TESTING');
  ///////////////   TESTING TEST TEST

   {This CopyFile is from FmxUtils : Delphi interface to Windows OS Calls.}
    CopyFile(FromFile, ToDir);
    MagAppMsg('s', 'Copyfile: ' + FromFile + ' to ' + ToDir);

    Result := True;
  Except
    MagAppMsg('s', 'Exception Copyfile: ' + FromFile + ' to ' + ToDir);
    MagAppMsg('s', 'System - GetLastError: ' + SysErrorMessage(Getlasterror));
    Result := False;
  End;

End;

Procedure TfrmCapMain.AppMessage(Var Msg: TMsg; Var Handled: Boolean);
Begin
  If ((Msg.Message = WM_KEYDOWN) Or (Msg.Message = WM_MOUSEMOVE)) Then
  Begin
        (*  if MagTimeOutform.visible then
             begin
             TimeoutTimer.ENABLED := FALSE;
             exit;
             end; *)
    TimeoutTimer.Enabled := False;
    TimeoutTimer.Enabled := True;
        //Handled := True;
  End;
    { for all other messages, Handled remains False }
    { so that other message handlers can respond }
End;

Procedure TfrmCapMain.DefaultHandler(Var Message);
Var
  Buffer: Array[0..255] Of Char;
  myHandle: Longint;
Begin
  myHandle := Handle;
  Inherited DefaultHandler(Message);
  Try
        //if application.terminated then exit;
    With TMessage(Message) Do
    Begin
      If Msg = WindowsMessageID Then
      Begin
        If GlobalGetAtomName(LParam, Buffer, 255) = 0 Then
          Strpcopy(Buffer, 'NO TEXT SENT');
        If (WParam = myHandle) {//Handle)} Then
          WinMsg('s', 'windows message from This Window - "' + Strpas(Buffer) + '"')
        Else
          WinMsg('s', 'windows message from Other Window - "' + Strpas(Buffer) + '"');
        ProcessVistAMessage(WParam, Strpas(Buffer));
      End;
    End;

  Except
        //messagedlg('Error in Default Handler',mtconfirmation,[mbok],0);
  End;
End;

Procedure TfrmCapMain.ProcessVistAMessage(XHandle: Hwnd; Vmsg: String);
Var                   //TP
Xdfn: String;   
Begin
 
    {    FOR DISPLAY we default to always changing to selected note/ exam
         BUT FOR Capture we Don't allow Sync With Note;}
   // MagSyncCPRSf.rgSyncProc.itemindex := 0 ;

   {     If not from CPRS then forget it.}
  If MagPiece(Vmsg, '^', 2) <> 'CPRS' Then
      Exit;
    {     12/20/99  if we aren't sychronized with  CPRS, we disregard the message;}
  If Not CprsSync.SyncOn Then
    Exit;
    { Link to correct CPRS}
  If (CprsSync.CprsHandle = 0) Then
  Begin
    If CprsSync.HexHand = IntToHex(XHandle, 8) Then
      CprsSync.CprsHandle := XHandle
  End;
 {   at this point we know the message is from the CPRS instance that launched Capture}


  If (MagPiece(Vmsg, '^', 1) = 'END') And (CprsSync.CprsHandle = XHandle) Then
  Begin
        { if Capture doesn't close, we want it to look Normal, because CPRS is already closed.
         so we will break the link first, then do the Close processing. }
    CprsSync.SyncOn := False;
    CprsSync.CprsHandle := 0;
    Frmcapmain.EnablePatientLookupLogin(True);
    Close;
    Exit;
  End;

    {     show the menu option to change CPRS Sync options}
  mCPRSLinkOptions.Enabled := True;
    (*  12/21/99  Not worried about CPRSSync.queried, we now are linked at startup, and don't
        change unless we break the link from menu option, or by not switching patients when
        CPRS changes.
       { We always bring up the Sync options window once.  And we'll quit if Sync is off}
    if not CPRSSync.Queried then GetCPRSLinkOptions(CPRSSync);
     *)
  EnablePatientLookupLogin(Not CprsSync.SyncOn);
  If Not CprsSync.SyncOn Then
    Exit;

    { we are not accepting messages from Multiple CPRS Windows. just One.}
  If (CprsSync.CprsHandle = 0) Then
  Begin
    If CprsSync.HexHand = IntToHex(XHandle, 8) Then
      CprsSync.CprsHandle := XHandle;
  End;
  If (CprsSync.CprsHandle <> XHandle) Then
    Exit;

    (* if magpiece(vmsg,'^',1)='XPT' then
       begin*)
    {     we will switch to a new patient. if patient from CPRS is different from Imaging's
          we don't test for XPT, because if Sync was turned off for a while, then back on, the patient
          could already be different, we could have missed the XPT message.}
  Xdfn := MagPiece(Vmsg, '^', 3);
    {     12/21/99  we will no longer care about PatSyncPrompt, we always change if linked}
  If ((iDModObj.GetMagPat1.M_DFN <> Xdfn) And (CprsSync.PatSync)) Then
  Begin
    If Not XBROKERX.Connected Then
      ImagingCaptureLogin(localserver, Inttostr(ListenerPort), True);       {ProcessVistAMessage}
    If Not XBROKERX.Connected Then
      Exit;
        {         set a flag ( quick and dirty ) so c hangetopatient procedure
                  knows if CPRS is changing the patient. }
    CPRSChangePatient := True;

    ChangeToPatient(Xdfn);                                {ProcessVistaMessage}

        //PatientChangeWarning;// this was out before  CCOW

  End;
    {end;}

  { At this point we have same patient.  In Display we are always swithing to Note/Exam
  // BUT For capture we are Never doing this }
  (*if magpiece(vmsg,'^',1)='RPT' THEN
    BEGIN
    IF (magpiece(vmsg,'^',4) = 'RA') THEN ImagesForCPRSRadExam(VMSG);
    IF (magpiece(vmsg,'^',4) = 'TIU') THEN ImagesForCPRSTIUNote(VMSG);
    end; *)

  { See saved copy of fmagCapMain, and Magvnetu for old code dealing with CPRS Sync stuff.
   the rest of this code is here because we will want to rethink this later.
    also, this code and the code in Capture should be moved to a sharable object.}

End;

Procedure TfrmCapMain.EnablePatientLookupLogin(Setting: Boolean);
Begin
    // the setting is CPRSSync.SyncOn   (True or False )
  mLogin.Enabled := Setting;
  mLogout.Enabled := Setting;
  mRemoteLogin.Enabled := Setting;

  mCPRSLinkOptions.Enabled := Not Setting;
  btnPatient.Visible := Setting;
  mSelectPatient.Enabled := Setting;
  mSelectPatient.Visible := Setting;
  Application.Processmessages;
  If Setting Then
    MagPatMenu.MaxInsert := 10;
End;

Function TfrmCapMain.IsPatientSelected(showwinmsg: Boolean = True): Boolean;
Begin
  If iDModObj.GetMagPat1.M_DFN = '' Then
  Begin
    Result := False;
    If showwinmsg Then
      WinMsg('d', 'You need to Select a Patient');
  End
  Else
    Result := True;
End;

Procedure TfrmCapMain.UpdateWindowcaption;
Begin
  if FCapDevTest
     then Caption := 'Capture 140 Prototype: ' +  MagGetFileVersionInfo(Application.ExeName)
     else Caption := 'VistA Imaging Capture ';
 //p140 Prototype
 //Caption :=  +  MagGetFileVersionInfo(Application.ExeName);

  If XBROKERX.Connected Then
    caption := caption + ': ' + iDModObj.GetMagPat1.M_NameDisplay + ' (' + XBROKERX.Server + ')';
  If (userCapname <> '') Then
    caption := caption + '  in use by: ' + userCapname;
End;

Procedure TfrmCapMain.btnStudyCompleteClick(Sender: Tobject);
Begin
  SetStudyComplete;
End;

Procedure TfrmCapMain.SetStudyComplete;
Begin
  If Imageptrlst.Items.Count = 0 Then
  Begin
    WinMsg('d', 'No Images have been captured for this study.');
    ButtonSettings(1);
    Exit;
  End;
  If Not IsStudyGroupComplete Then
    Exit;
  NewStudy; //{in SetStudyComplete  (btn Click)}
End;


{/pre 106 IsStudyGroupComplete saved for comparison at end.}
Function TfrmCapMain.IsStudyGroupComplete: Boolean;
Var
  boSuccess: Boolean;
  callstat: String;
  gcomp: TfrmCapGrpComplete;
  i: Integer;
  ss: String;
Begin
    {Stop DATABASE updates if in TEST Mode.}

  If FModeTest Then
  Begin
    Result := True;
    WinMsg('', 'Test Mode is ON.  No DataBase updates.');
    Exit;
  End;
  If Imageptrlst.Items.Count = 0 Then
  Begin
    Result := True;
    Exit;
  End;
  gcomp := TfrmCapGrpComplete.Create(Self);
  Try
    gcomp.LbDicom.caption := ''; {clear the DICOMID when window created }
    gcomp.LbPrompt.caption := 'Study Group: "' + EdtStudy.Text + '"' + #13
      + 'Patient    : "' + iDModObj.GetMagPat1.M_NameDisplay + '"' + #13
      + 'Image Count:  ' + Inttostr(Imageptrlst.Items.Count) + #13
      + 'CLOSE the Study Group ?';
    gcomp.Egroupdesc.Text := grpdesc;
    gcomp.Egroupdesc.Modified := False;
      //gcomp.grouplongdesc.wordwrap := frmCapMain.GrpLongdesc.wordwrap;
      //gcomp.grouplongdesc.scrollbars := frmCapMain.GrpLongdesc.scrollbars;
    gcomp.GroupLongDesc.Lines := GrpLongdesc.Lines;
    gcomp.GroupLongDesc.Modified := False;
    If LbDicom.caption <> '' Then
      gcomp.LbDicom.caption := LbDicom.caption;
    If Not TeleMedSingle Then
    Begin
      gcomp.Showmodal;
      Result := (gcomp.ModalResult = MrOK);
    End
    Else
    Begin
      Result := True;
    End;

    If Result Then
    Begin
      If ((CPPtr <> '') And (MagPiece(CPPtr, '^', 5) = '2')) Then
      Begin
        iDModObj.GetMagDBBroker1.RPUpdateConsult(MagPiece(CPPtr, '^', 4), MagPiece(CPPtr, '^', 1), '2', callstat);
        WinMsg('s', callstat);
      End;
      {/p117 use magAssoc}
      If (TRConsultPtr <> '') And (magAssoc = 'TRC') then //FrmCapConfig.TeleReaderConsult.Checked Then
      Begin
        UpdateTeleReaderConsult(GrpPtr, Imageptrlst.Items.Count);
      End;

      LbDicom.caption := ''; { put in for Lucilles's DICOMID Medicine procedur needs}
      If TeleMedSingle Then
      Begin
        WriteGroupDescriptions(grpdesc, grpdesc) //p106 rlm 20101011
      End
      Else
      Begin
        WriteGroupDescriptions(gcomp.Egroupdesc.Text, gcomp.GroupLongDesc.Text); //p106 rlm 20101011
      End;
    End; {else}

  Finally
    FreeAndNil(gcomp);
  End;
End;



Procedure TfrmCapMain.CallBrokerX;
Begin
  Try
    XBROKERX.Call;
  Except
    On e: Exception Do
    Begin
      XBROKERX.Results.Insert(0, '0^' + e.Message);
    End;
  End;
End;

Function TfrmCapMain.FileAssocPointers(ImagePointer: String; Var Retmsg: String; Var contOnError: Boolean): Boolean;
Var
  s, x, Rmsg, tmpptr: String;
    //vcontOnError : boolean;

  ContUnsign: Boolean;
  Vesig: String;
Begin
  contOnError := True; // this is the way it always defaulted.
  Screen.Cursor := crHourGlass;
  Try
    If FrmCapConfig.Medicine.Checked Then
    Begin
            { REMEMBER getprocdata.caption := maggmcf.datastring.caption;
              this is the string of 4 '^' pieces that I need in MAGGPROCIMAGE }
      WinMsg('', 'Filing the Images to Medicine Package...');
      XBROKERX.REMOTEPROCEDURE := 'MAGGPROCIMAGE';
      XBROKERX.PARAM[0].Value := MedPtr; {GETPROCDATA.CAPTION;}
      XBROKERX.PARAM[0].PTYPE := LITERAL;
            { for MULT's you have to set '.value' parameter  to '.X' it's a KERNEL thing }
      XBROKERX.PARAM[1].Value := '.X';
            {  SET IMAGE INTERNAL ^MAG(2005,ImgPtr into the MULT[ string ]
               where string is ImgPtr and value is always '1' }
      XBROKERX.PARAM[1].Mult[ImagePointer] := '1';
      XBROKERX.PARAM[1].PTYPE := List;
      CallBrokerX; //xBrokerx.Call;
      s := XBROKERX.Results[0];
      If MagPiece(s, '^', 1) = '1' Then
        WinMsg('', 'Images added to Medicine Package OK');

      If ((MagPiece(s, '^', 1) = '') Or (MagPiece(s, '^', 1) = '0')) Then
      Begin
        AssocFilingError('Medicine', MagPiece(s, '^', 2), EdtImageDesc.Text, MedPtr, ImagePointer, contonerror);
                //winmsg('', 'ERROR adding images to Medicine: ' + magpiece(s, '^', 2));
        Result := False;
        Exit;
      End;
    End; {IF magassoc = 'MED' then }

        { Note, and CP are different for now, need their own code.}
           {New design for additional TIU Functions in p59}
          {wpr}
    If FrmCapConfig.Tiu.Checked Then
    Begin
      Vesig := FCapClinDataObj.EncryptedEsig;
            {Status can be 0,1,2    un-signed,AdminClosed,Signed}
            {if not attaching to a signed doc and intended status is Signed and Esig is empty
              then CheckEsig gets new esig.  If not, then ask if want to save it as unsigned.}
      If (Not FCapClinDataObj.AttachToSigned)
        And (FCapClinDataObj.NewStatus = '2')
        And (Vesig = '') Then
      Begin
        If Not CheckEsig(FCapClinDataObj.NewAuthor, Retmsg, Vesig, ContUnsign) Then
        Begin
          If Not ContUnsign Then
          Begin
            Result := False;
            Exit;
          End
          Else
          Begin
            WinMsg('', 'Status changed Unsigned.  Continuing save...');
                        {Set Status in ClinDataObj}
            FCapClinDataObj.NewStatus := '0';
                        {display the Selected Status and Action when saved}
            Edtnoteinfo.Text := FCapClinDataObj.GetActStatLong;
            Edtnoteinfo.Hint := Edtnoteinfo.Text;
            LoadNoteGlyphs(FCapClinDataObj);
          End;
        End
        Else
          FCapClinDataObj.EncryptedEsig := Vesig;
      End;
            {  In the call to ResolveTIUNote we create the Addendum, or New Note ,
              and associate with that. Or if Existing Note, we may change Status
              and/or add text.}
      tmpptr := ResolveTIUNote(FCapClinDataObj, Rmsg);

            {Even If user cancelled, we treat it like an error}
      If tmpptr = '' Then
      Begin
        Retmsg := 'Failed to Resolve TIU Note.';
        AssocFilingError('TIU', Rmsg, ' any Note.', Retmsg, ImagePointer, contOnError);
        Result := False;
        Exit;
      End;

      WinMsg('', 'Filing the Images to TIU...');
      XBROKERX.REMOTEPROCEDURE := 'MAG3 TIU IMAGE';
      XBROKERX.PARAM[0].Value := ImagePointer;
      XBROKERX.PARAM[0].PTYPE := LITERAL;
      XBROKERX.PARAM[1].Value := tmpptr; //FCapClinDataObj.ReportData.tiuda; // magpiece(tmpptr, '^', 1);
      XBROKERX.PARAM[1].PTYPE := LITERAL;
      CallBrokerX; //xBrokerx.Call;
      s := XBROKERX.Results[0];

      If (Strtoint(MagPiece(s, '^', 1)) > 0) Then
        WinMsg('', 'Images added to TIU OK');
      If ((MagPiece(s, '^', 1) = '') Or (MagPiece(s, '^', 1) = '0')) Then
      Begin
        x := 'TIUDA: ' + FCapClinDataObj.ReportData.TiuDA
          + ' DFN: ' + FCapClinDataObj.ReportData.DFN;
        AssocFilingError('TIU', MagPiece(s, '^', 2), EdtImageDesc.Text, x, ImagePointer, contOnError);
                //      winmsg('', 'ERROR adding images to TIU: ' + magpiece(s, '^', 2));
        Result := False;
        Exit;
      End;

      If ContUnsign Then {an Esig Failed, but we saveded it unsigned, so stop here}
      Begin {     because we don't have a valid esig}
        Result := True;
        Exit;
      End;
            {HERE WE SIGN OR E-FILE THE NOTE.  This is after we made the link to the Image, so link is first
              and Esig or Efile is after link, this is what we want.}
      Result := True; {true even if we fail to update the Status, because we are linked to the Note.}
      If FCapClinDataObj.NewStatus = '0' Then
        Exit;
      If Not UpdateStatus(iDModObj.GetMagPat1.M_DFN, tmpptr, FCapClinDataObj.NewStatus, Vesig, Rmsg) Then
      Begin
        MagAppMsg('de', Rmsg + '- Note was saved as UnSigned');
      End;
    End; {END of - IF magassoc = 'TIU' then }

    If FrmCapConfig.ClinProc.Checked Then
    Begin
      tmpptr := CPPtr;
      WinMsg('', 'Filing the Images to TIU...');
      XBROKERX.REMOTEPROCEDURE := 'MAG3 TIU IMAGE';
      XBROKERX.PARAM[0].Value := ImagePointer;
      XBROKERX.PARAM[0].PTYPE := LITERAL;
      XBROKERX.PARAM[1].Value := MagPiece(tmpptr, '^', 1);
      XBROKERX.PARAM[1].PTYPE := LITERAL;
      CallBrokerX; //xBrokerx.Call;
      s := XBROKERX.Results[0];
      If (Strtoint(MagPiece(s, '^', 1)) > 0) Then
        WinMsg('', 'Images added to TIU OK');
      If ((MagPiece(s, '^', 1) = '') Or (MagPiece(s, '^', 1) = '0')) Then
      Begin
        x := 'TIUDA: ' + FCapClinDataObj.ReportData.TiuDA
          + ' DFN: ' + FCapClinDataObj.ReportData.DFN;
        AssocFilingError('TIU', MagPiece(s, '^', 2), EdtImageDesc.Text, x, ImagePointer, contOnError);
                //      winmsg('', 'ERROR adding images to TIU: ' + magpiece(s, '^', 2));
        Result := False;
        Exit;
      End;
    End; {END of - IF magassoc = 'TIU' then }
    If FrmCapConfig.TeleReaderConsult.Checked Then
    Begin
      //Result:=UpdateTeleReaderConsult(MagFileObj.ID,1);
      Result := True;
      Exit;
    End; {END of - IF TeleReaderConsult.Checked then }

    If FrmCapConfig.Radiology.Checked Then
    Begin
      WinMsg('', 'Filing the Images to Radiology Package...');
      XBROKERX.REMOTEPROCEDURE := 'MAGGRADPTR';
      XBROKERX.PARAM[0].Value := UserCapDUZ;
      XBROKERX.PARAM[0].PTYPE := LITERAL;
      XBROKERX.PARAM[1].Value := ImagePointer;
      XBROKERX.PARAM[1].PTYPE := LITERAL;
      XBROKERX.PARAM[2].Value := RadPtr;
      XBROKERX.PARAM[2].PTYPE := LITERAL;
      CallBrokerX; //xBrokerx.Call;
      s := XBROKERX.Results[0];
      If MagPiece(s, '^', 1) = '1' Then
        WinMsg('', 'Images added to Radiology Package OK');
      If ((MagPiece(s, '^', 1) = '') Or (MagPiece(s, '^', 1) = '0')) Then
      Begin
        AssocFilingError('Radiology', MagPiece(s, '^', 2), EdtImageDesc.Text, RadPtr, ImagePointer, contOnError);
                //      winmsg('', 'ERROR adding images to Radiology: ' + magpiece(s, '^', 2));
        Result := False;
        Exit;
      End;
    End; {END of - IF magassoc = 'RAD' then }

    If FrmCapConfig.Laboratory.Checked Then
    Begin
      WinMsg('', 'Filing the Images to Lab Package...');
      XBROKERX.REMOTEPROCEDURE := 'MAGGLAB FILE';
      XBROKERX.PARAM[0].Value := ImagePointer;
      XBROKERX.PARAM[0].PTYPE := LITERAL;
      XBROKERX.PARAM[1].Value := '^^' + LabPtr;
      XBROKERX.PARAM[1].PTYPE := LITERAL;
      CallBrokerX; //xBrokerx.Call;
      s := XBROKERX.Results[0];
      If MagPiece(s, '^', 1) = '1' Then
        WinMsg('', 'Images added to Lab Package OK');
      If ((MagPiece(s, '^', 1) = '') Or (MagPiece(s, '^', 1) = '0')) Then
      Begin
        AssocFilingError('Lab', MagPiece(s, '^', 2), EdtImageDesc.Text, LabPtr, ImagePointer, contOnError);
                //      winmsg('', 'ERROR adding images to Lab: ' + magpiece(s, '^', 2));
        Result := False;
        Exit;
      End;
    End; {END of - IF magassoc = 'LAB' then }

    If FrmCapConfig.Surgery.Checked Then
    Begin
      WinMsg('', 'Filing the Images to Surgery Package...');
      XBROKERX.REMOTEPROCEDURE := 'MAGGSUR FILE';
      XBROKERX.PARAM[0].Value := ImagePointer;
      XBROKERX.PARAM[0].PTYPE := LITERAL;
      XBROKERX.PARAM[1].Value := SurPtr;
      XBROKERX.PARAM[1].PTYPE := LITERAL;
      CallBrokerX; //xBrokerx.Call;
      s := XBROKERX.Results[0];
      If MagPiece(s, '^', 1) = '1' Then
        WinMsg('', 'Images added to Surgery Package OK');
      If ((MagPiece(s, '^', 1) = '') Or (MagPiece(s, '^', 1) = '0')) Then
      Begin
        AssocFilingError('Surgery', MagPiece(s, '^', 2), EdtImageDesc.Text, SurPtr, ImagePointer, contOnError);
                //      winmsg('', 'ERROR adding images to Surgery: ' + magpiece(s, '^', 2));
        Result := False;
        Exit;
      End;
    End; {END of - IF magassoc = 'SUR' then }

        { Everything is okay if we get to this line. we'll get to this line
           for an Association 'CLINIMAGE', 'ADMINDOC' and 'PhotoID' cause these
           either aren't implemented yet, or have no magassoc to file images in.}

    Result := True;
  Finally
	//p117 gek  skipped in 106, put in 117 from 94
    {   //p94t1 gek 9/29/09 Stop Multiple Esigs}
    {   Here we only clear the esig from the Clinical Data Object if it's NOT a Group.}
    if not frmCapConfig.ImageGroup.Checked then  FCapClinDataObj.EncryptedEsig := '';

    Screen.Cursor := crDefault;
  End;
End;

Procedure TfrmCapMain.AssocFilingError(Spec, serr, specdesc, sysinf, magptr: String; Var oktocontinue: Boolean);
Begin
  oktocontinue := Messagedlg('ERROR attaching images to ' + Spec + #13 +
    serr + #13 + #13 +
    'The Image can be saved as a Patient Image, ' + #13 +
    'not associated with ' + specdesc + #13 + #13 +
    'OK to save Image, not associated with ' + specdesc + ' ?'
    , Mterror, [Mbok, Mbcancel], 0) = MrOK;

  WinMsg('s', 'Error adding pointers in ' + Spec + ' package.');
  WinMsg('s', Spec + ' data : ' + sysinf);
  WinMsg('s', 'Image IEN ' + magptr);
  WinMsg('s', 'User elected to Save Image as Standalone => ' + Magbooltostr(oktocontinue));
End;

Procedure TfrmCapMain.CAPPreCap;


Begin
  Testmsg('in  CAPPreCap' + #13 + #13 + 'FLockScrollBarsAlways =  ' + magbooltostr(FLockScrollBarsAlways));
  If FLockScrollBarsAlways Then  ZoomScrollSave;






End;

Procedure TfrmCapMain.ZoomScrollSave;
Var
  s: String;
Begin
  s := 'Not saving Positions.';
    // ImageGear control doesn't tell us if it is cleared. the If is my QAD way
    //  to tell.

  Testmsg('Function:  ZoomScrollSave');
 // If Not (IsImageCleared And (Gear 1.GetScrollPos(0) = 0) And (Gear 1.GetScrollPos(1) = 0)) Then
// mg1.GetScrollInfo.H_Pos
{ DONE -o129 -ccheck : 
Need to check on this funciton... the 0 of Gear 1.  is differnet that 0 of
TMag4VGear...  0 now, means middle. }
//If Not (IsImageCleared And (mg1.GetScrollInfo.H_Pos = 0) And (mg1.GetScrollInfo.V_Pos = 0)) Then
If Not IsImageCleared then  {p129 change for above if.  IF Image is loaded, save Scroll positions.} 
  Begin
    Testmsg('Function:  ZoomScrollSave - Saving positions.');
    s := 'saving Positions...';
    FGearScrollHoriz := mg1.GetScrollInfo.H_Pos; //Gear 1.GetScrollPos(0);
    FGearScrollVert := mg1.GetScrollInfo.V_Pos ;//Gear 1.GetScrollPos(1);
    FGearZoomValueStatic := mg1.GetZoomValue; //Gear 1.ZoomLevel;
    FGearZoomValuePositional := mg1.GetZoomValue;    //Gear 1.ZoomLevel;

  End;
  Testmsg('Function:  ZoomScrollSave - Leaving' + #13 + s + #13 + #13 +
    'TMag4VGear Loaded image = ' + mg1.ImageFilename   +  #13 + // Gear 1.LoadImage + #13 +
    'FGearScrollHoriz ' + Inttostr(FGearScrollHoriz) + #13 +
    'FGearScrollVert ' + Inttostr(FGearScrollVert) + #13 +
    'FGearZoomValueStatic ' + Inttostr(FGearZoomValueStatic) + #13 +
    'FGearZoomValuePositional ' + Inttostr(FGearZoomValuePositional));

End;

Function TfrmCapMain.IsImageCleared(): Boolean;
Begin
 // Testmsg('IsImageCleared');
 // Testmsg('LoadDocument  ' + Gear 1.loaddocument);
 // Testmsg('LoadImage  ' + Gear 1.LoadImage);
 // Testmsg('HiGear        ' + Inttostr(Gear 1.HiGear));
 //   Result := ((Gear 1.LoadDocument = '') Or (Gear 1.LoadDocument = BlankImage)) And
 //    ((Gear 1.LoadImage = BlankImage) Or (Gear 1.LoadImage = ''))

{p129 below.  This assumes the code isn't using BlankImage anymore.}
// result := not mg1.ImageLoaded;
testmsg('IsImageCleared ' );
testmsg('NOT mg1.IsValidImage   ' + magbooltostr(not mg1.IsValidImage));
Result := Not mg1.IsValidImage; //p129 this call checks IGPage directly.
End;

//gek 9/7/12
procedure TfrmCapMain.CanCaptureChangePatient(var msg: string; var status: boolean);
begin
status := true;
        If Not IsStudyGroupComplete Then
         begin
         status := false;
         msg :=  ' Study Group is not Complete. Cannot Change Patient ';
         end;
end;


procedure TfrmCapMain.ShowReviewButton(value : boolean);
begin
 btnReview.visible := value;
end;


Procedure TfrmCapMain.CaptureIsValid;
Begin
//140 test..  o   if CapX.m140MultSources and (CapX.m140PDFConvert)then
      {TODO - 140 : Only want to Save Image if Import...  if Scanned,  then PDF already exists}
  if CapX.m140PDFConvert
      then
      begin
          if not ((CapX.mSourceID = mcSrcTwain) or (CapX.mSourceID = mcSrcScanDoc))  then SaveImageASpdf;
           ShowReviewButton(true);
      end
      else
      begin
        ShowReviewButton(false);
      end;
    //SourceFormatEnable(false);
  MagAppMsg('s', 'CaptureIsValid  ' + Inttostr(mg1.GetZoomValue) + '  slider ' + Inttostr(TbicZoom.Position));
  ZoomScrollApply;
    {Set it true here, decide later in LoadGear, (used by Import) if abs are made.}
  absforimage := True;
  ABSbyJB := False;
    {each device calls this procedure when it's capture is valid.
     We'll enable the Image OK button , and Cancel Button disable all others}

  if (mg1.GetBitsPerPixel = 1) then
    EnableTIFFunctions(True);

  ButtonSettings(2);
  EdtImageDesc.SetFocus;
  SetPageControls;

  {/P122 DMMN 6/24/2011 - If the capture is valid then enable the annotation button /}
  {/p122t6 dmmn 10/14 - only enable when not in batch mode /}
  (*if cbBatch.Checked then
    t lbrbtnAnnotation.Enabled := False
  else
    t lbrbtnAnnotation.Enabled := True;   *)
   { gek 129t9  make a function AnnotationsEnableforImage.  this enable/disable is called from
               multiple places. }
   self.AnnotationsEnableforImage(not cbBatch.checked);
End;

Procedure TfrmCapMain.ZoomScrollApply;
Var
  Tf: String;
Begin
          If FLockScrollBarsFitToWin Then
            Tf := 'TRUE' //WPR AUTO
          Else
            Tf := 'FALSE';
          Testmsg('in ApplyLockedZoomedScroll' + #13 + #13 +
            'FLockScrollBarsFitToWin =  ' + Tf + #13 +
            'FGearScrollHoriz =  ' + Inttostr(FGearScrollHoriz) + #13 +
            'FGearScrollVert =  ' + Inttostr(FGearScrollvert) + #13 +
            'FLockScrollBarPos =  ' + Inttostr(FLockScrollBarPos));
  If FLockScrollBarsFitToWin Then
  Begin
    GearFitToWin;
    Exit;
  End;


   if FLockScrollBarsAlways then
      begin
         { This is to Use Settings of Last Displayed image...
            for V16, we do nothing,  and let the last FitSetting be automatically
            applied.}
        //exit;
      end;


    // we're using saved Zoom value and maybe saved Scroll pos's





  if not FLockScrollBarsAlways then
  begin
  If (FLockScrollBarPos = 0) Then
  Begin

    If TbicZoom.Position <> FGearZoomValueStatic Then
     SetZoomLevel(FGearZoomValueStatic);

//p129    If Gear 1.ZoomLevel <> TbicZoom.Position Then
//p129      Gear 1.ZoomLevel := TbicZoom.Position;

        // Now we use saved scroll positions if FlockScrollBarPos = 0
        //   else we use the positional Scrollbar selected.
    if mg1.GetZoomValue <> TbicZoom.Position then
        mg1.ZoomValue(tbicZoom.position);

//p129    Gear 1.SetScrollPos(0, 4, FGearScrollHoriz);
//p129    Gear 1.SetScrollPos(1, 4, FGearScrollVert);

    mg1.SetScrollPos(FGearScrollVert, FGearScrollHoriz);
  End
  Else
  Begin
    If TbicZoom.Position <> FGearZoomValuePositional Then
       SetZoomLevel(FGearZoomValuePositional);
//p129    If Gear 1.ZoomLevel <> TbicZoom.Position Then
//p129      Gear 1.ZoomLevel := TbicZoom.Position;

    if mg1.GetZoomValue <> TbicZoom.Position then
        mg1.ZoomValue(tbicZoom.position);

        { DONE -o129 -cview :
            mag4VGear need equivilent of these functions : GetMaxScrollBarRange 
            ... use 999999 which is same as computing Max Horiz and Max Vert}

    Case FLockScrollBarPos Of
      1:
        Begin
          mg1.SetScrollPos(-999999,-999999);

        End;
      2:
        Begin
          {/p129  pre 129, the TGear function GetMaxScrollRange(vert|horiz) was used}
            //p129 Gear 1.SetScrollPos(0, 4, Gear 1.GetMaxScrollRange(0));
            //p129 Gear 1.SetScrollPos(1, 4, 0);
          mg1.SetScrollPos(-999999,999999);
        End;
      3:
        Begin
          mg1.SetScrollPos(999999,-999999);
        End;
      4:
        Begin
          mg1.SetScrollPos(999999,999999);
        End;
      5:
        Begin
          { By not settings the ScrollBars, a new 'loaded' image
             in Gear 1 will default to center.
           p8t25 wasn't working on an existing image.}
           { DONE -o129 -cview :
          Tmag4VGear equivilent of these function  IsScrollBarPresent -  is needed.
          Ans: V16 doesn't have issue if setting to middle if scrollbars are not visible.   }

         //p129 If Gear 1.IsScrollbarPresent(1) Then
         //p129   Tf := 'True'
         //p129 Else
         //p129   Tf := 'False';
          Testmsg('Case 5 (Center) ' + #13 + #13 +
            'GetScrollPos =  ' + Inttostr(mg1.GetScrollInfo.V_Pos) + #13 +
            'GetMinScrollRange =  ' + Inttostr(mg1.GetScrollInfo.V_Min) + #13 +
            'GetMaxScrollRange =  ' + Inttostr(mg1.GetScrollInfo.V_Max) + #13 );

            mg1.SetScrollPos(0,0);     {p129 gek.  V16 Scrollbar middle is 0}
        End;
    End;
        (* This was out in 122
       //  if Gear 1.PanWindow then
       //     begin
       //       Gear 1.PanWindow := FALSE; // these 2 lines refresh the pan window
       //       gEAR 1.pANwINDOW := TRUE;
       //     end;
         *)
  End;
  end;
End;

Procedure TfrmCapMain.btnCaptureClick(Sender: Tobject);
Var
  s: String;
Begin

  If Not IsAssocTRCOK Then Exit; //106t10    p106 rlm 20101129

                                (*  out in 106t10
                                //p106  start 106
                                  If FrmCapConfig.TeleReaderConsult.Checked Then
                                  Begin
                                    If Not FrmCapConfig.DICOMFormat.Checked Then
                                    Begin
                                      Showmessage(
                                        'An association of TeleReader Consult' + #13 + #10 +
                                        'must use a Format of' + #13 + #10 +
                                        'DICOM(VL Photo Image Storage)');
                                      Exit;
                                    End;
                                    If Not FrmCapConfig.Import.Checked Then
                                    Begin
                                      Showmessage(
                                        'An association of TeleReader Consult' + #13 + #10 +
                                        'must use a Source of "Import".');
                                      Exit;
                                    End;
                                  End;
                                //p106   end 106
                                *)
  //p140t1
  if (not CapX.m140MultSources)  and (not CapX.m140CombineScans)
    then btnCapture.Enabled := False;    //p140t1

  WinMsg('', 'Starting Capture...');
    {WPR}
    {UserDir is TSessionDirectories, get rid of multitude of variables for file, directory, etc}
  if (not CapX.m140MultSources) and (not CapX.m140CombineScans) then
    begin
    s := GUserDir.Temp + 'scantemp.tga';
    DeleteFile(PChar(s));
    s := GUserDir.Temp + 'resetfile.tif';
    DeleteFile(PChar(s));
    s := GUserDir.Temp + 'multipage.tif';
    DeleteFile(PChar(s));
    s := GUserDir.Temp + 'magPDF.pdf';
    DeleteFile(PChar(s));
    end;

  If Not CanUserCapture(Magassoc) Then
  Begin
    btnCapture.Enabled := True;
    Exit;
  End;
    { any processing to be done for all captures before the actual
      capture is executed  is done here.  Then the CAPDeviceExecute
      is called.  This is changed to the CAPdevice call of the device
      when the device's radiobutton is checked.
      i.e.  when Vista radiobutton is checked, INITVista is called, in
      INITVista  the CAPDeviceOnclick is changed to CAPVista.}

 if (not CapX.m140MultSources)  and (not CapX.m140CombineScans)
    then  btnCapture.Enabled := False; //p140t1

  btnImageOK.Enabled := False;
  btnStudyComplete.Enabled := False;
  if not CapX.m140MultSources
    then pnlimport.Enabled := False;  //p140t1

  btnCancelScan.Enabled := True;
  btnCancelScan.SetFocus;

  if CapX.mSourceID = 0  then   // 140 Stop basing decisions on the'text' of a field.
 // If LbInputSourceDesc.caption = '' Then
  Begin
    WinMsg('d', 'You must Select an Input Source ' + #13 + 'from the Configuration window !');
    btnCapture.Enabled := True;
    Exit;
  End;
  Application.Processmessages;
  CAPPreCap;
  CapDeviceExecute.Click;
      //p129  FAltViewerNeeded := False;
  FUsingAltViewer := false;
    { each device will call the procedure CAPtureIsValid if capture was okay,
    the CAPtureisValid procedure will enable the Image OK and Cancel buttons.}
End;
procedure TfrmCapMain.mnuTESTINGCloseTwainSource1Click(Sender: TObject);
begin
//mg1.
   magtwain1.SourceClose;
end;

{   function TfrmCapMain.CanUserCapture(capspec: string): boolean; }
{   Test for Required Capture Key, if site is using Captures Keys. }

Function TfrmCapMain.CanUserCapture(capspec: String): Boolean;
Begin
  Result := True;
  If Userhaskey('CAPTURE KEYS OFF') Then
    Exit;
    //if (SecurityKeys.indexof('CAPTURE KEYS OFF') > -1) then EXIT;
  If FModeTest Then
    Exit;

  If (Uppercase(capspec) = 'RAD') And (Not Userhaskey('MAGCAP RAD')) Then
    Result := False;
  If (Uppercase(capspec) = 'LAB') And (Not Userhaskey('MAGCAP LAB')) Then
    Result := False;
  If (Uppercase(capspec) = 'MED') And (Not Userhaskey('MAGCAP MED')) Then
    Result := False;
  If (Uppercase(capspec) = 'SUR') And (Not Userhaskey('MAGCAP SUR')) Then
    Result := False;
  If (Uppercase(capspec) = 'ADMINDOC') And (Not Userhaskey('MAGCAP ADMIN')) Then
    Result := False; //WPR KEY
  If (Uppercase(capspec) = 'CLINIMAGE') And (Not Userhaskey('MAG CAPTURE')) Then
    Result := False;
  If (Uppercase(capspec) = 'NOTES') And (Not Userhaskey('MAGCAP TIU')) Then
    Result := False;
  If (Uppercase(capspec) = 'CP') And (Not Userhaskey('MAGCAP CP')) Then
    Result := False;
  If (Uppercase(capspec) = 'PHOTOID') And (Not Userhaskey('MAGCAP PHOTOID')) Then
    Result := False;
  If (Uppercase(capspec) = 'TRC') And (Not Userhaskey('MAGCAP TRC')) Then //p106 rlm 20101228 CR646 "Use Capture Keys feature not updated"
    Result := False; //p106 rlm 20101228 CR646 "Use Capture Keys feature not updated"

    (*if (uppercase(capspec) = 'RAD') and (SecurityKeys.indexof('MAGCAP RAD') = -1) then RESULT := FALSE;
    if (uppercase(capspec) = 'LAB') and (SecurityKeys.indexof('MAGCAP LAB') = -1) then RESULT := FALSE;
    if (uppercase(capspec) = 'MED') and (SecurityKeys.indexof('MAGCAP MED') = -1) then RESULT := FALSE;
    if (uppercase(capspec) = 'SUR') and (SecurityKeys.indexof('MAGCAP SUR') = -1) then RESULT := FALSE;
    if (uppercase(capspec) = 'ADMINDOC') and (SecurityKeys.indexof('MAGCAP ADMIN') = -1) then RESULT := FALSE; //WPR KEY
    if (uppercase(capspec) = 'CLINIMAGE') and (SecurityKeys.indexof('MAG CAPTURE') = -1) then RESULT := FALSE;
    if (uppercase(capspec) = 'NOTES') and (SecurityKeys.indexof('MAGCAP TIU') = -1) then RESULT := FALSE;
    if (uppercase(capspec) = 'CP') and (SecurityKeys.indexof('MAGCAP CP') = -1) then RESULT := FALSE;
    if (uppercase(capspec) = 'PHOTOID') and (SecurityKeys.indexof('MAGCAP PHOTOID') = -1) then RESULT := FALSE;*)
  If Not XBROKERX.Connected Then
  Begin
    WinMsg('d', 'You must Login to VISTA to capture Images.  ' + #13 + '( you can capture images in ''Test Mode'', or ''Off-Line'' ) also');
    Result := False;
    Exit;
  End;
  If Not Result Then
  Begin
        // make the message more readable.
    WinMsg('d', 'You don''t have the proper Security Keys' + #13 +
      'to capture ' + ReadableShortAssoc(capspec) + ' Images.'); //WPR KEY
  End;
End;

Function TfrmCapMain.BrokerError: Boolean;
Begin
  If XBROKERX.Results.Count = 0 Then
  Begin
    WinMsg('de', 'RPCBroker Error, use ^XTER to examine error info.');
    BrokerError := True;
    Exit;
  End;
  If MagPiece(XBROKERX.Results[0], '^', 1) = '0' Then
  Begin
    WinMsg('', (MagPiece(XBROKERX.Results[0], '^', 2)));
    BrokerError := True;
    Exit;
  End;
  WinMsg('', (MagPiece(XBROKERX.Results[0], '^', 1) + ' Entries returned'));
  XBROKERX.Results.Delete(0);
  BrokerError := False;
End;

Procedure TfrmCapMain.ReqTelChange(Sender: Tobject);
Begin
  Imagelongdesc.Lines.Clear;
End;

Procedure TfrmCapmain.GetUserCapPref;
Var
  t: Tstringlist;
  Rpcstat: Boolean;
  Rpcmsg, stmp, s: String;
  i: Integer;
Begin
  If Upref = Nil Then
    Upref := Tuserpreferences.Create;
  t := Tstringlist.Create;
  Try
    iDModObj.GetMagDBBroker1.RPMagGetUserPreferences(Rpcstat, Rpcmsg, t, 'CAPCONFIG');
    If Not Rpcstat Then
      Exit;

    If MagPiece(t[0], '^', 1) = 'CAPCONFIG' Then
    Begin
      FGearZoomValueStatic := Strtoint(MagPiece(t[0], '^', 2));
      If (FGearZoomValueStatic < 25) Then
        FGearZoomValueStatic := 100;
            //  FGearZoomValueStatic is being set to 1
      FGearZoomValuePositional := Strtoint(MagPiece(t[0], '^', 3));
      FGearScrollHoriz := Strtoint(MagPiece(t[0], '^', 4));
      FGearScrollVert := Strtoint(MagPiece(t[0], '^', 5));
      FLockScrollBarPos := Strtoint(MagPiece(t[0], '^', 6));

      FLockScrollBarsFitToWin := Magstrtobool(MagPiece(t[0], '^', 7));
      FLockScrollBarsStatic := Magstrtobool(MagPiece(t[0], '^', 8));
      FLockScrollBarsAlways := Magstrtobool(MagPiece(t[0], '^', 9));
      FLockScrollBarsPositional := Magstrtobool(MagPiece(t[0], '^', 10));

      FEdtLV.FAutoTab := Magstrtobool(MagPiece(t[0], '^', 11));
      FEdtLV.FAutoSelect := Magstrtobool(MagPiece(t[0], '^', 12));
      FEdtLV.FShowListOnEnter := Magstrtobool(MagPiece(t[0], '^', 13));

            // Batch Capture Options
      FBatchEditDescOnSave := Magstrtobool(MagPiece(t[0], '^', 14));
      FBatchShowOptions := Magstrtobool(MagPiece(t[0], '^', 15));
      FBatchDelete := Magstrtobool(MagPiece(t[0], '^', 16));
            // video file options
      Fusealtviewer := Magstrtobool(MagPiece(t[0], '^', 17));
      Fplayvideofile := Magstrtobool(MagPiece(t[0], '^', 18));
            /////////////
      FShowHints := Magstrtobool(MagPiece(t[0], '^', 19));
      Frmcapmain.ShowHint := FShowHints;
      MnuShowHints.Checked := FShowHints;
      Fconfirmmsg := Magstrtobool(MagPiece(t[0], '^', 20));
      mconfirmmsg.Checked := Fconfirmmsg;
      FSavedConfigsTB := Magstrtobool(MagPiece(t[0], '^', 21));
      mnuConfigToolBar.Checked := FSavedConfigsTB;
      TabCtr.Visible := FSavedConfigsTB;

      FCurrentSettingsTB := Magstrtobool(MagPiece(t[0], '^', 22));
      mnuCurrentSettingsTB.Checked := FCurrentSettingsTB;
      tlbrSettings.Visible := FCurrentSettingsTB;
      FSaveUserSettingsOnExit := Magstrtobool(MagPiece(t[0], '^', 23));
      SavePreferencesOnExit2.Checked := FSaveUserSettingsOnExit;
            // Tab SequenceList

      If MagPiece(t[0], '^', 24) <> '' Then
      Begin
        If (Pos(MagPiece(t[0], '^', 24), '100200300400500') < 1) Then
          Exit;
        TabSeqList.Clear;
        TabSeqList.Add('_' + MagPiece(t[0], '^', 24));
        TabSeqList.Add('_' + MagPiece(t[0], '^', 25));
        TabSeqList.Add('_' + MagPiece(t[0], '^', 26));
        TabSeqList.Add('_' + MagPiece(t[0], '^', 27));
        TabSeqList.Add('_' + MagPiece(t[0], '^', 28));

        ShowTagFields;
      End;
      FAutoDeSkew := Magstrtobool(MagPiece(t[0], '^', 29));
      FAutoDeSpeckle := Magstrtobool(MagPiece(t[0], '^', 30));
      FAutoPreviewNote := Magstrtobool(MagPiece(t[0], '^', 31));
      stmp := MagPiece(t[0], '^', 31) + '^' + MagPiece(t[0], '^', 32);
      FSavedConfigsMultiLine := Magstrtobool(MagPiece(t[0], '^', 32));
      TabCtr.Multiline := FSavedConfigsMultiLine;

      FImageTB := Magstrtobool(MagPiece(t[0], '^', 33));
      MnuImageToolbar.Checked := FImageTB;
      tlbarImage.Visible := MnuImageToolbar.Checked; {/p122 /gek 9/1/11  fix ImageToolbar Issue}
      RedisplayMultiline;

    End;

        (*    s := inttostr(FuprefCapTIU.Top) + '^' +  inttostr(FuprefCapTIU.Left) + '^' +
               inttostr(FuprefCapTIU.Height) + '^' +  inttostr(FuprefCapTIU.Width) + '^' +
               inttostr(FuprefCapTIU.ListPanelHeight) + '^' +
               inttostr(FuprefCapTIU.ListEditTextHeight) + '^' +
               inttostr(FuprefCapTIU.ListPreviewHeight) + '^' +
               magboolToStrInt(FuprefCapTIU.PreviewON) + '^' +
               magboolToStrInt(FuprefCapTIU.ShowRelatedNotes) + '^' +
                     FuprefCapTIU.DefaultLoc;
          t.add('"CAPTIU"|' + s);
          *)
    t.Clear;
    iDModObj.GetMagDBBroker1.RPMagGetUserPreferences(Rpcstat, Rpcmsg, t, 'CAPTIU');
    If Not Rpcstat Then
      Exit;

    If MagPiece(t[0], '^', 1) = 'CAPTIU' Then
    Begin
      FuprefCapTIU.Top := Strtoint(MagPiece(t[0], '^', 2));
      FuprefCapTIU.Left := Strtoint(MagPiece(t[0], '^', 3));
      FuprefCapTIU.Height := Strtoint(MagPiece(t[0], '^', 4));
      FuprefCapTIU.Width := Strtoint(MagPiece(t[0], '^', 5));
      FuprefCapTIU.PanelPreviewHeight := Strtoint(MagPiece(t[0], '^', 6));
      FuprefCapTIU.ListEditTextHeight := Strtoint(MagPiece(t[0], '^', 7));
      FuprefCapTIU.PanelTitleHeight := Strtoint(MagPiece(t[0], '^', 8));
      FuprefCapTIU.PreviewON := Magstrtobool(MagPiece(t[0], '^', 9));
      FuprefCapTIU.ShowRelatedNotes := Magstrtobool(MagPiece(t[0], '^', 10));
      FuprefCapTIU.DefaultLoc := MagPiece(t[0], '^', 11);
      FuprefCapTIU.UseStatusIcons := Magstrtobool(MagPiece(t[0], '^', 12));

      FuprefCapTIu.Listcount := Strtoint(MagPiece(t[0], '^', 13));
      FuprefCapTIu.Listmonthsback := Strtoint(MagPiece(t[0], '^', 14));
      If FuprefCapTIU.Listmonthsback >= 0 Then
        FuprefCapTIU.Listmonthsback := -99;
            //FuprefCapTIu.listDateFrom := ''; //out in  P59T19+ FMtoDispDt(magpiece(t[0],'^',15));
            //FuprefCapTIu.listDateTo := '';   //out in  P59T19+ FMtoDispDt(magpiece(t[0],'^',16));
      FuprefCapTIu.UseNoteGlyphs := Magstrtobool(MagPiece(t[0], '^', 17));
      FuprefCapTIu.UseDefaultLoc := Magstrtobool(MagPiece(t[0], '^', 18));
      FuprefCapTIU.NoteColumnWidths := MagPiece(t[0], '^', 19);   // p129 dmmn 12/20/12 - restore note col widths
            //
    End;
    t.Clear;
    iDModObj.GetMagDBBroker1.RPMagGetUserPreferences(Rpcstat, Rpcmsg, t, 'IVERIFY');
    If Not Rpcstat Then
      Exit;

    If MagPiece(t[0], '^', 1) = 'IVERIFY' Then
    Begin
      i := 0;
      Upref.VerifyStyle := MagStrToInt(MagPiece(t[i], '^', 2)); //   inttostr()
      Upref.VerifyPos.Left := MagStrToInt(MagPiece(t[i], '^', 3)); //         + '^' + inttostr()
      Upref.VerifyPos.Top := MagStrToInt(MagPiece(t[i], '^', 4)); //      + '^' + inttostr()
      Upref.VerifyPos.Right := MagStrToInt(MagPiece(t[i], '^', 5)); //        + '^' + inttostr()
      Upref.VerifyPos.Bottom := MagStrToInt(MagPiece(t[i], '^', 6)); //         + '^' + inttostr()
      Upref.VerifyShowReport := Magstrtobool(MagPiece(t[i], '^', 7)); //        + '^' + magbooltostrint()
      Upref.VerifyShowInfo := Magstrtobool(MagPiece(t[i], '^', 8)); //      + '^' + magbooltostrint()
      Upref.VerifyHideQFonSearch := Magstrtobool(MagPiece(t[i], '^', 9)); //        + '^' + magbooltostrint()
      Upref.VerifySingleView := Magstrtobool(MagPiece(t[i], '^', 10)); //       + '^' + magbooltostrint());

       (*
            //p93t13  s := magpiece(t[i], '^', 11) + ',,,,,';
            s := magpiece(t[i], '^', 11) ; // + ',,,,,';  93t13 took out ,,,,
            while copy(s,length(s),1) = ',' do s := copy(s,1,length(s)-1);  //p93t13
             *)
       //Dick in 106 changed the above to the below......  they are NOT the same result !!!
        (*  need to go back to 94, untill 's' is looked into
         s := MagPiece(t[i], '^', 11) + ',,,,,';
         s := StringReplace(s, ',,,', '', [RfReplaceAll]); //rlm  zzz
          *)
       //p117 gek  back to 93's way until this is looked into.
            s := magpiece(t[i], '^', 11) ; // + ',,,,,';  93t13 took out ,,,,
            while copy(s,length(s),1) = ',' do s := copy(s,1,length(s)-1);  //p93t13
      
      Upref.VerifyColWidths := s;
    End;

    {/p122 dmmn 7/5/11 - retrieve user setting for annotation components /}
    t.Clear;
    iDModObj.GetMagDBBroker1.RPMagGetUserPreferences(Rpcstat, Rpcmsg, t, 'ANNOTCAPTURE');
    If Not Rpcstat Then
      Exit;
      {JK 6/27/2012 - uncommented the following section for annotation settings}

    // if there is previous annotation settings then apply else default;
//    If (MagPiece(t[0], '^', 1) = 'ANNOTCAPTURE') and
//       (MagLength(t[0],'^') > 2) Then   //p122 dmmn 8/1
    If (MagPiece(t[0], '^', 1) = 'ANNOTCAPTURE') then
    Begin
      MagAppMsg('s', 'There are user preferences for annotation in VistA. Begin applying preferences.');
//      AnnotationOptionsX.UserPreferences := t[0];
      //p122 dmmn 8/1 - more proper way to initialize
      frmAnnotOptionsX.FontName           := MagPiece(t[i], '^', 2);
      frmAnnotOptionsX.FontStyle          := MagStrToInt(MagPiece(t[i], '^', 3));
      frmAnnotOptionsX.FontSize           := MagStrToInt(MagPiece(t[i], '^', 4));
      frmAnnotOptionsX.LineWidth          := MagStrToInt(MagPiece(t[i], '^', 5));
      frmAnnotOptionsX.AnnotLineColor     := MagStrToInt(MagPiece(t[i], '^', 6));
      frmAnnotOptionsX.Opacity            := MagStrToInt(MagPiece(t[i], '^', 7));
      frmAnnotOptionsX.ArrowPointerStyle  := MagStrToInt(MagPiece(t[i], '^', 8));
      frmAnnotOptionsX.ArrowPointerLength := MagStrToInt(MagPiece(t[i], '^', 9));
      frmAnnotOptionsX.ArrowPointerAngle  := MagStrToInt(MagPiece(t[i], '^', 10));
      frmAnnotOptionsX.Left               := MagStrToInt(MagPiece(t[i], '^', 11));
      frmAnnotOptionsX.Top                := MagStrToInt(MagPiece(t[i], '^', 12));

      MagAppMsg('s', 'Finish applying annotation settings');
    End;

  Except
        // exception getting CapUserPref
  End;
  t.Free;
End;

(*function TfrmCapmain.BoolToInt(value: boolean): integer;
begin
  if value then result := 1
  else result := 0;
end;*)

(*function TfrmCapmain.IntToBool(value: integer): boolean;
begin
  if value > 0 then result := TRUE
  else result := FALSE;
end; *)

Procedure TfrmCapmain.SetUserCapPref;
Var
  s, stmp: String;
  Rpcstat: Boolean;
  Rpcmsg: String;
  t: TStrings;
Begin
  t := Tstringlist.Create;
  Try
        { TODO : change these inttostr.... calls to use the magbooltoint etc calls. }

          {   Capture Configuration Upref settings: "CAPCONFIG"}
    s := //CapConfig is $p 1
      Inttostr(FGearZoomValueStatic) + '^' + //$p 1
      Inttostr(FGearZoomValuePositional) + '^' + //$p 2
      Inttostr(FGearScrollHoriz) + '^' + //$p 3
      Inttostr(FGearScrollVert) + '^' + //$p 4
      Inttostr(FLockScrollBarPos) + '^' + //$p 5
      Magbooltostrint(FLockScrollBarsFitToWin) + '^' + //$p 6
      Magbooltostrint(FLockScrollBarsStatic) + '^' + //$p 7
      Magbooltostrint(FLockScrollBarsAlways) + '^' + //$p 8
      Magbooltostrint(FLockScrollBarsPositional) + '^' + //$p 9

        // Auto-  choices
    Magbooltostrint(FEdtLV.FAutoTab) + '^' + //$p 10
      Magbooltostrint(FEdtLV.FAutoSelect) + '^' + //$p 11
      Magbooltostrint(FEdtLV.FShowListOnEnter) + '^' + //$p 12
        // batch options.
    Magbooltostrint(FBatchEditDescOnSave) + '^' + //$p 13
      Magbooltostrint(FBatchShowOptions) + '^' + //$p 14
      Magbooltostrint(FBatchDelete) + '^' + //$p 15
        // video file options
    Magbooltostrint(Fusealtviewer) + '^' + //$p 16
      Magbooltostrint(Fplayvideofile) + '^' + //$p 17

    Magbooltostrint(FShowHints) + '^' + //$p 18
      Magbooltostrint(Fconfirmmsg) + '^' + //$p 19
      Magbooltostrint(FSavedConfigsTB) + '^' + //$p 20
      Magbooltostrint(FCurrentSettingsTB) + '^' + //$p 21
      Magbooltostrint(FSaveUserSettingsOnExit) + '^' + //$p 22

        //Tabbing sequence for inut fields
    MagPiece(TabSeqList[0], '_', 2) + '^' + //$p 23
      MagPiece(TabSeqList[1], '_', 2) + '^' + //$p 24
      MagPiece(TabSeqList[2], '_', 2) + '^' + //$p 25
      MagPiece(TabSeqList[3], '_', 2) + '^' + //$p 26
      MagPiece(TabSeqList[4], '_', 2) + '^' + //;    //$p 27     ($p 28 in return)
        //t.add('"CAPCONFIG"|' + s);
      //p8t29
      //iDModObj.GetMagDBBroker1.Broker.Param[1].MULT['"CAPCONFIG"'] := s;
    Magbooltostrint(FAutoDeSkew) + '^' +
      Magbooltostrint(FAutoDeSpeckle) + '^' +
      Magbooltostrint(FAutoPreviewNote);
        //p48t
    
    stmp := Magbooltostrint(FSavedConfigsMultiLine);

    s := s + '^' + Magbooltostrint(FSavedConfigsMultiLine)
      + '^' + Magbooltostrint(FImageTB);
    t.Add('"CAPCONFIG"|' + s + '^');

        {   Capture TIU Upref settings: "CAPTIU"}
            {T59T19+ Stop saving the Date Range, now treat it as a one time thing, not saved.}
    If FuprefCapTIU.Listmonthsback >= 0 Then
      FuprefCapTIU.Listmonthsback := -99;

    s := Inttostr(FuprefCapTIU.Top) + '^' + Inttostr(FuprefCapTIU.Left) + '^' +
      Inttostr(FuprefCapTIU.Height) + '^' + Inttostr(FuprefCapTIU.Width) + '^' +
      Inttostr(FuprefCapTIU.PanelPreviewHeight) + '^' +
      Inttostr(FuprefCapTIU.ListEditTextHeight) + '^' +
      Inttostr(FuprefCapTIU.PanelTitleHeight) + '^' +
      Magbooltostrint(FuprefCapTIU.PreviewON) + '^' +
      Magbooltostrint(FuprefCapTIU.ShowRelatedNotes) + '^' +
      FuprefCapTiu.DefaultLoc + '^' +
      Magbooltostrint(FuprefCapTIU.UseStatusIcons) + '^' +
      Inttostr(FuprefCapTIu.Listcount) + '^' +
      Inttostr(FuprefCapTIu.Listmonthsback) + '^' +
      '' + '^' + //DispDttoFM(FuprefCapTIu.listDateFrom) + '^' +      //out in T59T19+
      '' + '^' + //DispDttoFM(FuprefCapTIu.listDateTo) + '^' +        //out in T59T19+
      Magbooltostrint(FuprefCapTIu.UseNoteGlyphs) + '^' +
      Magbooltostrint(FuprefCapTIu.UseDefaultLoc) + '^' +
      FuprefCapTIU.NoteColumnWidths + '^';        //p129 dmmn 12/20/12 - store notes column widths
      

        {New user Pref for p59  WPR}

    t.Add('"CAPTIU"|' + s);
        (*
              public
         Top,Left,Height,Width : integer;
         ListPanelHeight, ListEditTextHeight, ListPreviewHeight : integer;
         PreviewON : boolean;
         ShowRelatedNotes : boolean;
       end;
        *)


 (*  //RCA out.
         {   Capture Verify Window Upref settings: "IVERIFY"}
    If Doesformexist('frmVerify') Then
    Begin
      frmVerify.UserPrefUpdate;
    End;
        {   The Verify window updates its' userpreferences when it closes, by calling it's
              own procedure UpdateUserPrefeneces.}

    t.Add('"IVERIFY"|' +
      Inttostr(Upref.VerifyStyle) // 1
      + '^' + Inttostr(Upref.VerifyPos.Left) // 2
      + '^' + Inttostr(Upref.VerifyPos.Top) // 3
      + '^' + Inttostr(Upref.VerifyPos.Right) // 4
      + '^' + Inttostr(Upref.VerifyPos.Bottom) // 5
      + '^' + Magbooltostrint(Upref.VerifyShowReport) // 6
      + '^' + Magbooltostrint(Upref.VerifyShowInfo) // 7
      + '^' + Magbooltostrint(Upref.VerifyHideQFonSearch) // 8
      + '^' + Magbooltostrint(Upref.VerifySingleView) // 9
      + '^' + Upref.VerifyColWidths); // 10
*)
    {JK 6/27/2012 - uncommented the following section for annotation settings}
    // p122 dmmn 7/5/11 - add annotation settings
//    s := AnnotationOptionsX.UserPreferences;
//    t.Add('"ANNOTCAPTURE"|' + s);
    {/p122 dmmn 8/1/11 - proper way to save user settings /}
    t.Add('"ANNOTCAPTURE"|' +
      frmAnnotOptionsX.FontName                             // 1
      + '^' + IntToStr(frmAnnotOptionsX.FontStyle)          // 2
      + '^' + IntToStr(frmAnnotOptionsX.FontSize)           // 3
      + '^' + IntToStr(frmAnnotOptionsX.LineWidth)          // 4
      + '^' + IntToStr(frmAnnotOptionsX.AnnotLineColor)     // 5
      + '^' + IntToStr(frmAnnotOptionsX.Opacity)            // 6
      + '^' + IntToStr(frmAnnotOptionsX.ArrowPointerStyle)  // 7
      + '^' + IntToStr(frmAnnotOptionsX.ArrowPointerLength) // 8
      + '^' + IntToStr(frmAnnotOptionsX.ArrowPointerAngle)  // 9
      + '^' + IntToStr(frmAnnotOptionsX.Left)               // 10
      + '^' + IntToStr(frmAnnotOptionsX.Top));              // 11

    iDModObj.GetMagDBBroker1.RPMagSetUserPreferences(Rpcstat, Rpcmsg, t);
  Finally
    t.Free;
  End;
End;

Procedure TfrmCapMain.ClearCurrentPatient(Ignorenoclear: Boolean = False);
Begin
  magappmsg('s','* * --FmagCapMain.ClearCurrentPatient - Start.  IgnoreNoClear=' + magbooltostr(Ignorenoclear));
  If (Ignorenoclear) Or (Not Frmcapmain.LbPatName.NoClear) Then
  Begin
    magappmsg('s','              ClearCurrentPatient is calling MagPat1.Clear');
    iDModObj.GetMagPat1.Clear;
    self.CapDFN := '';   //129 T7.   need to clear this (was XDFN) so same patient can be selected.
    PtSSN.Text := '';
    EdtPatName.Text := '';
//ccowout    edtImageDesc.Text := ''; //TP
    EAccessionNo.Text := '';//TP
    If pnlGearPat.Visible Then
    Begin
      mgPatImage.ClearImage;
      //mg1PatImage.ClearImage;
      //PatImage.LoadImage := BlankImage;
      pnlGearPat.Visible := False;
    End;
    UpdateWindowcaption; //clear title bar when form is cleared SAF 7/13/05
    MagLastImagesForm.ClearPatient;
    MagLastImagesForm.Hide;
  End;

End;

Procedure TfrmCapMain.LoadStaticFields;
Var
  i: Integer;
Begin
    // if RPFileManDate(xmsg,'N', FImageCaptureDate)
    //   then FImageCaptureDate :=  magpiece(FImageCaptureDate,'^',1)
    //   else FImageCaptureDate :=  edtProcDate.Text;

  XBROKERX.PARAM[0].Mult['"magDFN"'] := '5^' + iDModObj.GetMagPat1.M_DFN; {patient dfn}
    //3.0.8 xBrokerx.Param[0].Mult['"DATETIME"'] := '7^NOW'; {date/time image collected}

  If MagPiece(DateTimeProc, ':', 3) <> '' Then
    DateTimeProc := MagPiece(DateTimeProc, ':', 1) + ':' + MagPiece(DateTimeProc, ':', 2);
  XBROKERX.PARAM[0].Mult['"DOCDTTM"'] := '110^' + EdtDocImageDate.Text;
  If DateTimeProc = ''
        {   For Admin, Clin, Photo ID, we set the ProcDateTime equal to the
        Document Image Date Time, we need ProcDateTime for Image File Cross Ref.}Then
    XBROKERX.PARAM[0].Mult['"DATETIMEPROC"'] := '15^' + EdtDocImageDate.Text
  Else
    XBROKERX.PARAM[0].Mult['"DATETIMEPROC"'] := '15^' + DateTimeProc;
    // 3.0.8 now we are saving DateTimeImageCaptured in the Text File,
    // Same as the Capture Date Time.  Was the Procedure Date Time.
    //  NOT SAVING CAPTURE DATE TIME, LETTING THIS BE COMPUTED BY THE SYSTEM AS THE
    //   IMAGE FILE ENTRY IS BEING MADE.
    //xBrokerx.Param[0].Mult['"CAPTUREDATE"'] := '7^' + FImageCaptureDate; {Date/Time Image Captured}

    //check to see if modality (procedure) text should change saf 12/8/98
    // 3.2.99 GEK change code, to work.   i.e. cboModality.items[0] is always 'CT'
    // 3.2.99 GEK and it's style is  DropDown so TEXT must be checked.  if it was DropDownList then ItemIndex could be checked
    // 3.2.99 GEK  if cboModality.items[0] <> '<Select Modality>' then
  If FrmCapBatchAdv.FBatchAdvEnable And (FrmCapBatchAdv.FBatchAdvModality <> '') Then
  Begin
    XBROKERX.PARAM[0].Mult['"PROC"'] := '6^' + FrmCapBatchAdv.FBatchAdvModality;
  End
  Else
  Begin
        {For Notes, or Surgery we display the title, but save 'NOTE', 'SUR'}
    If FmagAssoc = 'NOTE' Then
      XBROKERX.PARAM[0].Mult['"PROC"'] := '6^' + 'NOTE'
    Else
      If FmagAssoc = 'SUR' Then
        XBROKERX.PARAM[0].Mult['"PROC"'] := '6^' + 'SUR'
      Else
        XBROKERX.PARAM[0].Mult['"PROC"'] := '6^' + EdtStudy.Text;
  End;
  XBROKERX.PARAM[0].Mult['"DESC"'] := '10^' + EdtImageDesc.Text; {image description}

  If (cbOrigin.ItemIndex = -1) Then
    cbOrigin.ItemIndex := GetDefaultOriginIndex;
  XBROKERX.PARAM[0].Mult['"ORIGIN"'] := '45^' + cbOrigin.Items[cbOrigin.ItemIndex]; // p8t21
  XBROKERX.PARAM[0].Mult['"DUZ"'] := '8^' + UserCapDUZ; {Duz}
    {     In 'M' we compute the Image Index Class from the Image Index Type
          don't need this here - xBrokerx.Param[0].Mult['"CLASS"'] := '41^' + FClass;  }
  If (FmagAssoc = 'CLINIMAGE') Or (FmagAssoc = 'ADMINDOC') Then
    XBROKERX.PARAM[0].Mult['"PACKAGE"'] := '40^' + 'NONE'
  Else
    XBROKERX.PARAM[0].Mult['"PACKAGE"'] := '40^' + FmagAssoc;

  If Imagelongdesc.Lines.Count > 0 Then {LONG DESCRIPTION}
  Begin
    For i := 0 To Imagelongdesc.Lines.Count - 1 Do
    Begin
      XBROKERX.PARAM[0].Mult[('"LONGDES' + Copy('000', 1, 3 - Length(Inttostr(i))) + Inttostr(i) + '"')] := '11^' + Imagelongdesc.Lines[i];
    End;

  End;
End;

Procedure TfrmCapMain.InitProgress(Max: Integer);
Begin
  gauge1.progress := 0;
  gauge1.maxvalue := Max;
  gauge1.minvalue := 0;
  gauge1.Visible := True;
End;

Procedure TfrmCapMain.IncProgress;
Begin
  gauge1.progress := gauge1.progress + 1;
  gauge1.Update;
End;
procedure TfrmCapMain.Info1Click(Sender: TObject);
var  vIGManager: TMagIGManager;
begin
 vIGManager := GetIGManager();
  Showmessage('Accusoft : ImageGear Version ' + GetIGManager().Version);

end;

Procedure TfrmCapMain.EndProgress;
Begin
  While gauge1.progress < gauge1.maxvalue Do
    gauge1.progress := gauge1.progress + 1;
End;

Procedure TfrmCapMain.ImageEntryDelete(Var Ien: String; NoImage : string = '');
Var
  s: String;
  i: Integer;
  ienstr : string;
Begin
  ienstr:= '';
  s := '';
  ienstr := magsetpiece(ienstr,'^',1,ien);
  ienstr :=   magsetpiece(ienstr,'^',2,'1');
  if UPPERCASE(NoImage) = 'NOIMAGE'  then   ienstr := magsetpiece(ienstr,'^',3,'NOIMAGE');

  //ienstr := Ien + '^1'; { the '^1' says to force delete, don't test for MAG DELETE KEY }
  //if UPPERCASE(NoImage) = 'NOIMAGE'  then ienstr := ienstr + '^NOIMAGE';
  
  XBROKERX.PARAM[0].Value := ienStr;
  XBROKERX.PARAM[0].PTYPE := LITERAL;
  XBROKERX.REMOTEPROCEDURE := 'MAGG IMAGE DELETE';
  WinMsg('e', 'ERROR: Saving Image to Imaging NetWork.  Deleting Image Entry from Vista Image File...');
  CallBrokerX; //xBrokerx.call;
  s := XBROKERX.Results[0];
  If ((s = '') Or (XBROKERX.Results.Count = 0)) Then
  Begin
    WinMsg('de', 'ERROR: Saving Image to Imaging NetWork.  Attempt to Delete Image Entry Failed. Broker Error on Vista System');
    WinMsg('', '');
    Ien := '';
    Exit;
  End;
  If (MagPiece(s, '^', 1) = '0') Then
  Begin
    WinMsg('de', 'ERROR: Saving Image to Imaging NetWork.  Attempt to Delete Image Entry Failed. ' + MagPiece(s, '^', 2));
    WinMsg('', '');
    Ien := '';
    Exit;
  End;
  WinMsg('de', 'ERROR: Saving Image to Imaging NetWork. '
    + #13 + 'Image Entry Deleted from VistA Image File. '
    + #13 + #13 + 'click '
    + #13 + '      ''Image OK'' to try saving the Image again'
    + #13 + '           or '
    + #13 + '       ''Cancel''  to enable capturing a new image.');
    // This message is new 8/21/00
  WinMsg('', 'Click ''Image OK'' to save Image, or ''Cancel'' to discard Image');
  For i := 0 To Imageptrlst.Items.Count - 1 Do
  Begin
    If MagPiece(Imageptrlst.Items[i], '^', 1) = Ien Then
    Begin
      Imageptrlst.Items.Delete(i);
      Break;
    End;
  End;
End;



Procedure TfrmCapMain.btnImageOKClick(Sender: Tobject);
Begin
  SetImageOK;
End;

Procedure TfrmCapMain.SetImageOK;
Var
  Magien, s, Retmsg, callstat: String;
  newmagien: String; //ADMINDOC
  imagefiled, continueOnError: Boolean;
  i: Integer;
    //  newli: Tlistitem;
      //ADMINDOC
  CIFlag: Boolean;
  Fstat: Boolean;
  annotated : boolean;
  Flist: Tstringlist;
  batchmsgs: Tstringlist;
  batchfile: String;
  batchcount: Integer;
  batcherr: Integer;
  batchwarn: Integer;
  startdfn: String;
  trcFlag : string;
  annotXMLPath : string; // P122
Begin
  batcherr := -1;
  batchwarn := -1;
  CIFlag := False;

  if CapX.m140MultSources then
    begin
     if messagedlg('This will complete the MultiSource Capture to a PDF.' + #13 +
                    ' Are you Sure ? ',mtconfirmation,[mbok,mbcancel],0) = mrCancel
                    then  exit;
     
    end;

  frmCapConfig.EnableMultipleCaptures(false); // 140 get to field.
// next is 106t10
  If Not IsAssocTRCOK Then Exit; //p106t10     p106 rlm 20101129

  If IsImageclear(mg1) Then
  Begin
    If ((cbBatch.Checked) And (Lvbatch.Items.Count > 0)) Then {group batch, and Items in the list, and no item is seleted,
            we select the first one and continue.}
    Begin
      ImportFile(Lvbatch, 0);
    End
    Else {is not group batch, and no item is seleted, we don't continue}
    Begin
      ButtonSettings(1);
      Exit;
    End;
  End;
  batchmsgs := Tstringlist.Create;
  Testmsg('in  btnImageOKClick' + #13 + #13 + 'FLockScrollBarsAlways =  ' + Magbooltostr(FLockScrollBarsAlways));
  If FLockScrollBarsAlways Then
    ZoomScrollSave;
  WinMsg('', 'STARTING: btnImageOKClick...');
  Flist := Tstringlist.Create;
  Screen.Cursor := crHourGlass;
  Try
    Magien := '';
    AccusoftPropertiesLog('Before OKToSaveImageAsIs: btnImageOKClick');
        {       checks for attempts to save 24 bit, as 1 bit, etc.}
    If Not OkToSaveImageAsIs Then
    Begin
      WinMsg('', 'Saving Image: "' + EdtImageDesc.Text + '" is Cancelled.');        {/p122 dmmn WPR Capture Item #20 /}
      gauge1.Hide;
      ButtonSettings(2);
      Exit;
    End;

        {       checks users Imaging Security Keys.}
    If Not CanUserCapture(Magassoc) Then
    Begin
      ButtonSettings(2);
      Exit;
    End;

//a/    If ((Scanmode = 'Import') And (ImportIni = 'COPY'))
    If ((CapX.mSourceID = mcSrcImport ) And (ImportIni = 'COPY'))
            {   check to see if we need to make an abstract later.}Then
      absforimage := ImageTypeNeedsAbs(FGfiletoImport); //ScanOKClick
        {           TODO : Need RPC Call for ImageTypeNeedsABS }
    InitProgress(35 + Lvbatch.Items.Count);

        {           Validate the input data.}
    WinMsg('', 'Validating Image data...');
    incprogress;
        {WPR, next conditionals will set button enable/disable property in a consistant way }
    If Not ValidAssociationFields Then
    Begin
      ButtonSettings(2);
      Exit;
    End;
    incprogress;
    {/p117 gek 
            the code in ValidStaticFields can't be dependent on an Association, so we add
            a parameter to the ValidStaticFields function, so Static Fields can be 
            Required based on the parameter.}
    if magassoc = 'TRC'
        then  trcFlag := 'PS'
        else  trcFlag := '';

    If Not ValidStaticFields(trcFlag) Then
    Begin
      ButtonSettings(2);
      Exit;
    End;
    incprogress;
        {Special Check for Advance Directive, we need an Adv Dir TIU Note}
    If Not IsValidAdvanceDirective Then
    Begin
      ButtonSettings(2);
      Exit;
    End;
    WinMsg('', 'Image data is Valid.  Saving Image...');
        {           ImageOK button can be clicked (i.e. is 'enabled') only if CAPdevice
                    has called CaptureIsValid.
                    If it is ok to save an image, the Image OK button is enabled}
    startdfn := iDModObj.GetMagPat1.M_DFN;
    If Fconfirmmsg And (Not ConfirmSavingImage) Then
    Begin
      If Application.Terminated Then
        Exit;
      WinMsg('', 'Saving Image: "' + EdtImageDesc.Text + '" is Cancelled.'); {/p122 dmmn WPR Capture Item #20 /}
      If iDModObj.GetMagPat1.M_DFN = startdfn Then
        CancelCapture(False);
      Exit;
    End;
    incprogress;

        {       if This is the first image of a Group, Create Image Group entry }
    //If ((Imageptrlst.Items.Count = 0) And (FrmCapConfig.ImageGroup.Checked)) Then
    {/p106  put in TeleMedSingle.}
    If ((Imageptrlst.Items.Count = 0) And ((FrmCapConfig.ImageGroup.Checked) Or TeleMedSingle)) Then

    Begin
                  {   IF HERE, Then we are processing
                        THE FIRST IMAGE IN A NEW GROUP.}
                   incprogress;
                        {   If not Batch,  and 'Controlled Image is set' we want to
                            set the CI Flag for the Image not the GRoup.
                            If Batch, then the CI Flag is set for Group, not the First Image.}
                  CIFlag := False;
                  If (Not cbBatch.Checked) And FControlledImage Then
                  Begin
                            {   we turn off CI for the Group}
                    CIFlag := True;
                    Self.ControlledImage(False);
                  End;
                  FileGroup(imagefiled);
                  If CIFlag Then
                  Begin
                            {   if we turned off CI for the Group, we turn it back on for First Image}
                    Self.ControlledImage(True);
                    CIFlag := False;
                  End;

                  If Not imagefiled Then
                  Begin
                    ButtonSettings(2);
                    Exit;
                  End;
                  incprogress;
                        {       TODO : What to do if an Association Pointer fails.
                                Flag Image as something and have an AdPac look at it later. ? ?
                                Need a Status Field.  P93.... }
                        {WPR in FileAssoc.... we ask user to continue if there was an Error
                            continue means saving image with no association.}
                  If Not FileAssocPointers(GrpPtr, Retmsg, continueOnError) Then
                  Begin
                            {       A MessageDialog has already been displayed if the FileSpecPointers fails.
                                   Here we could set a Status Field, somehow flag the Image for an AdPac to
                                   look at it later.}
                    If Not continueOnError Then
                    Begin
                      If MagFileObj.ID <> '' Then
                        imageentrydelete(MagFileObj.ID,'NoImage') {in SetImageOK}
                      Else  If grpPtr <> '' Then
                            imageentrydelete(GrpPtr,'NoImage');
                                {This is from Display: iDModObj.GetMagDBBroker1.RPMaggImageDelete(rstat, rmsg, rlist, Iobj.Mag0, '', reason, allowGrpDel);}
                     //     Begin   129t17  this begin end.  not needed.
                     ButtonSettings(2);
                     EdtImageDesc.SetFocus;
                     Exit;
                     //    End;
                    End;
                  End;
    End;
    incprogress;
        {       reset magien to null, because this might have been a group,
                now we need seperate image entry }
    Magien := '';

        {       3.2.99 Here we have to check for Batch Save.
                If list view control lvBatch has entries, then
                we have to loop through all and save them to the Group.}
    If ((cbBatch.Checked) And (Lvbatch.Items.Count > 0)) Then
    Begin
      batcherr := 0;
      batchwarn := 0;
      batchcount := 0;
      batchmsgs.Clear;
      MagAppMsg('s', ' ******* STARTING Batch Capture ******* ');
      For i := 0 To Lvbatch.Items.Count - 1 Do
      Begin
        incprogress;
                {       DONE :
                    If FAIL to load an Image, we CONTINUE,  Is this what we want.
                    Also, we are not saving the fact that This image Failed.
                    But, We aren't deleting the Image from directory, if this fails}
                    //SupportedFiles bmk                 ScanOKClick
        Lvbatch.Selected := Nil;
        Lvbatch.Items[batchcount].ImageIndex := 32;
        Lvbatch.ItemIndex := batchcount;
        ScrollToItem(Lvbatch, batchcount);

        batchfile := Lvbatch.Items[batchcount].SubItems[3] + '\' + Lvbatch.Items[batchcount].caption;
        FGfiletoImport := Lvbatch.Items[batchcount].caption;
        If Not LoadGear(batchfile, batchfile) {btnImageOKClick} Then
        Begin
          batchmsgs.Add('- Error. Failed to load file: ' + batchfile + '  ' + FErrorInGearlist[0]);
                    // fix => Skip Image doesn't work.
                    (*
                    newli := lvbatch.Items.Add;
                    newli.Assign(lvbatch.items[0]);
                    lvBatch.Items.Delete(0);
                    *)
                    {Set a Warning Icon in Import List.}
          Lvbatch.Items[batchcount].ImageIndex := 5;
          batcherr := batcherr + 1;
          batchcount := batchcount + 1;
          Continue;
        End;
        FGfiletoImport := Lvbatch.Items[batchcount].caption;
        batchimagedescription := EdtImageDesc.Text;
        If FBatchEditDescOnSave Then
        Begin
                    // try other  if frmCapBatchImageDesc.execute(frmCapMain.Left, frmCapMain.imageboxpanel.top + frmCapMain.top, batchimagedescription)
          If FrmCapBatchImageDesc.Execute(0, 0, batchimagedescription, False) Then
            EdtImageDesc.Text := batchimagedescription
                            {           TODO :    Check to make sure user knows that they are
                              discarding this image   from the batch import. }
          Else
          Begin
                        { this is where we are skipping}
            Lvbatch.Items[batchcount].ImageIndex := 4;
            batchcount := batchcount + 1;
            batchmsgs.Add('- Skipped ' + batchfile);
            batchwarn := batchwarn + 1;
            Continue;
          End;
        End;
                {       ADMINDOC}
        If FileImageAndCopyImage(newMagien) Then
        Begin
          winmsg('s','NewMagien (Group)  ' + newMagien);
          batchmsgs.Add('- Capture OK : ' + batchfile);
          iDModObj.GetMagDBBroker1.RPMag4PostProcessActions(Fstat, Flist, newMagien);
          If Not Fstat Then
          Begin
            WinMsg('DE', 'Error executing Post Process Action: ' + Flist[0]);
            batcherr := Batcherr + 1;
            batchmsgs.Add('- Error executing Post Process Action in VistA.')
          End;
          If FBatchDelete Then
          Begin
            If DeleteFile(PChar(batchfile)) Then
            Begin
              WinMsg('s', 'Deleted File : ' + batchfile);
              batchmsgs.Add('- - Deleted File : ' + batchfile);
            End
            Else
            Begin
              batchmsgs.Add('- - Delete Failed for file: ' + batchfile);
              batchwarn := batchwarn + 1;
            End;
          End;
          Lvbatch.Items.Delete(batchcount);
        End
        Else
        Begin
          batchmsgs.Add('- - Failed : Filing/Copying file: ' + batchfile);
          batcherr := batcherr + 1;
          batchmsgs.Add('- - - Batch Copy has been halted.');
          Break;
        End;
                {TODO :
                      Here we're breaking out of the loop on an error Filing or Copying.  ?
                      Does the user know that some made it and some didn't  ? }
      End; { for I := 0 to lvbatch.items.count - 1 do}

      batchmsgs.Insert(0, ' ******* Batch Capture Messages *******');
      batchmsgs.Add(' ******* Batch Capture Messages *******');
      MagAppMsg('', batchmsgs);

      GearClear;
    End {       if batch and batchlist > 0 }
            {       else if this isn't a batch,
                  It is a groupimage  or a single image}
    Else
      If FileImageAndCopyImage(newMagIEN) Then
      Begin
      CapX.m140CombineScans := false;
            {       If Clin Proc, Single and 'Complete' flag is set.
                        Update the Consult to 'pr' Partial results.}
        If ((CPPtr <> '') And (grpptr = '') And (MagPiece(CPPtr, '^', 5) = '2')) Then
        Begin
          WinMsg('s', '* Calling Update Consult');
          iDModObj.GetMagDBBroker1.RPUpdateConsult(MagPiece(CPPtr, '^', 4), MagPiece(CPPtr, '^', 1), '2', callstat);
          WinMsg('s', '*Result : ' + callstat);
        End;
        //(magAssoc = 'TRC') then
        // If (TRConsultPtr <> '') And FrmCapConfig.TeleReaderConsult.Checked And (grpptr = '') Then
        {/p117 gek use magAssoc}
        If (TRConsultPtr <> '') And (magAssoc = 'TRC')  And (grpptr = '') Then
        Begin
          //UpdateTeleReaderConsult(MagFileObj.ID, 1);
          UpdateTeleReaderConsult(newMagIEN, 1);
        End;
            {       ADMINDOC        POST PROCESSING}
        iDModObj.GetMagDBBroker1.RPMag4PostProcessActions(Fstat, Flist, newMagien);
        If Not Fstat Then
          WinMsg('DE', 'Error executing Post Process Action: ' + Flist[0])
        Else
          WinMsg('s', 'Post Process Action: ' + Flist[0]);

    {/p129  Start check and save new Annotation  }
    {   we're in this Block because FileandCopy is true..
        so just check for annotations and save. }

                  winmsg('s','New Image Magien (Group)  ' + newMagien);
                  annotated := mg1.CheckIsSessionChanged;
                  // p129t16 gek .   made this a system message to stop confussion . Jemmy suggestion. 
                  winmsg('s',' Annotations modified : ' + magbooltostr(annotated));
                  if annotated then
                     begin
                     AnnotationsSaveAnnotationsToDB(newMagien);
                     end;


{/p129  END new check for annotation and save.}

        {/P122 check magien here /}
        {/P122 DMMN 6/24/2011 - if there is annotation for the current image, save that annotation
                     to vista and associate the annotation file to the image /}
(* out in 122       if Not fCapAnnot.NoAnnotaionComponent then
        begin
            fCapAnnot.UpdateImageIEN(newMagIEN);
            MagAppMsg('s', 'Begin saving annotation session:');
            if fCapAnnot.SaveAnnotationToDB(annotXMLPath) then
            begin
              MagAppMsg('s', 'Annotation for ImageIEN: ' + newMagIEN + ' was saved to:');
              MagAppMsg('s','***' + annotXMLPath);
            end
            else
              MagAppMsg('s', 'Failed to save annotations to VistA');

            // clear annotations and disable the button util a diferent image is loaded
            {/P122 DMMN 6/28/2011 - Changed to only clear the annotation component and hide the panel /}
            //            FreeAndNil(fCapAnnot);
            fCapAnnot.Close;

            t lbrbtnAnnotation.Enabled := False;
        end;      end out 122   *)

        If Not FrmCapConfig.ImageGroup.Checked Then
        Begin
          NewStudy; //{in SetImageOK  (single image has been saved)}
        End;
      End {if FileImageAndCopyImage then}
      Else {if FileImageAndCopyImage then..else  }
      Begin
           

     /// TEST TEST TESTING   showmessage('FileAndCopyImage Failed....')
            {       nothing needed here now.  Messages are displayed in the
                        FileImageAndCopyImage procedure.}
      End; {       if FileImageAndCopyImage else}

     {JK 6/27/2012 - free the gear and instantiate a new one for the new image.}
  mg1.Free;
  CreateGearComponent;   {This was quickfix workaround
                           done for Annotation pages not being created/freed... }

  Finally
       //p117 gek.  this was skipped in 106, I put in from 94
       {   //p94t1 gek 9/29/09 Stop Multiple Esigs}
       {   Here we only clear the esig from the Clinical Data Object if it's NOT a Group.}
          { TODO -oGarrett -cFuture : p94t1
           Look Into having it cleared on 'NewStudy' call.  which is called for single or study being complete.}
        if  not frmCapConfig.imagegroup.checked Then FCapClinDataObj.EncryptedEsig := '';
    iDModObj.GetMagFileSecurity.MagCloseSecurity(s);
    Screen.Cursor := crDefault;
    gauge1.Visible := False;
    Flist.Free;
        {  Here we check for warnings and errors.}
    If (batcherr > 0) Or (batchwarn > 0) Then
    Begin
      WinMsg('', 'Batch: Warnings ' + Inttostr(batchwarn) + '  Errors: ' + Inttostr(batcherr));
    End;
    batchmsgs.Free;
  End; {try}
End;
//ADMINDOC

Function TfrmCapMain.FileImageAndCopyImage(Var Magien: String): Boolean;
Var
  continueOnError: Boolean;
  Errors: String;
  i,j: Integer;
  imagefiled: Boolean;
  ImportIniWas: String;
  multipagescan: Boolean;
  multipgmod: String;
  newimagefile: String;
  PARAM: String;
  Retmsg: String;
  Rmsg: String;
  tempstr: String;
  Test: String;
  annotXMLPath : string;

Begin
  Result := False;
  Screen.Cursor := crHourGlass;

  Try
        {	File the Image data to VistA, making new Image File entry.
            Returning MAGIEN.  EXIT if failure. }
//p117 added comment from 94 skipped by 106...   I need my comments in.
             { DONE -oGarrett -crefactor : pass MagFileObj..  rather than keeping a Global variable..
                    is MagFileObj used outside of this function }

     { MagFileObj is created in FileImage                                     we are in beginning of      FileImageAndCopyImage}
    FileImage(imagefiled, Magien, NewImageFile); {  we are calling FileImage, from the  beginning of      FileImageAndCopyImage }

    {p129, make a method of all Duc's logic for computing ConsultResulted.}
    AnnotationGetConsultResulted(); {duc took out (magien) parameter.}

    If Not imagefiled Then
    begin
      {/p122 dmmn WPR Capture Item #8 /}
       //    if fCapAnnot.HasAnnotationComponent and (fCapAnnot.MarkCount > 0) then
      if AnnotationsExist() then
      begin
        //p122 dmmn 8/22 if the image didnt file, discard annotations
        {/p122 dmmn WPR Item #15, 3 /}
        MagAppMsg('d', 'Could not save annotations to VistA because image did not file correctly. Contact IRM');
        AnnotationsClose;
      end;
      Exit;
    end;


    incprogress; { Show progress of capture.}

        {	if this is single image, file the  Association pointers }
    If Not FrmCapConfig.ImageGroup.Checked Then
            //59 if not FileAssocPointers(ImgPtr, retmsg)
       { Passing MagFileObj, no longer using string: wpr}
      If Not FileAssocPointers(MagFileObj.ID, Retmsg, continueOnError) Then
      Begin
                { TODO:  Here again, if the an Association pointers fail to File.
                  We need to alert the user,and Flag this image for 'Needs Review'. p60}
        If Not continueOnError Then
        Begin
          imageentrydelete(MagFileObj.ID,'NoImage');
          Exit;
        End;
      End;
    incprogress;

        {       NOW COPY THE FILE TO THE ( Image Network Server )}
        {       Quit if we can't connect}
    WinMsg('', 'Connecting to Network Image Server...');
//p117 comment from 94, skipped in 106
         { TODO -oGarrett -crefactor : Get DMOD out of here.  Have reference to MagSecurity in form ? }
    If Not iDModObj.GetMagFileSecurity.MagOpenSecurePath(Magfileobj.FullFileName, Rmsg, '', '', True) Then
    Begin
    
      WinMsg('s', 'Failed to open security to : ' + Magfileobj.FullFileName);
      WinMsg('', 'MagSecurity: ' + Rmsg);
            {        Close connection.}
      iDModObj.GetMagFileSecurity.MagCloseSecurity(Rmsg, True);
            {        Add all messages to message log}
      For i := 0 To iDModObj.GetMagFileSecurity.Msglist.Count - 1 Do
        WinMsg('s', iDModObj.GetMagFileSecurity.Msglist[i]);
            {        Delete the entry from the Image File (2005)}
      ImageEntryDelete(Magien,'NoImage');
      ENDPROGRESS;
      Exit;
    End;

        { Quit if we need to create the directory, but can't.}
    Test := MagFileObj.GetPath;
    If Not Directoryexists(MagFileObj.GetPath) Then
            //if not DirectoryExists(DIRX) then
    Begin
      Forcedirectories(MagFileObj.GetPath);
      If Not Directoryexists(MagFileObj.GetPath) Then
      Begin
        WinMsg('', 'Can''t create directory');
        WinMsg('s', 'Can''t create ' + MagFileObj.GetPath);
        ImageEntryDelete(Magien,'NoImage');
        ENDPROGRESS;
        Exit;
      End;
    End;
    incprogress;

        {        Changed to a function, Quit if can't copy}
    If Not SaveImageTextFile(Rmsg) Then
    Begin
      WinMsg('', 'Failure to copy .txt file to Image Network Server');
      WinMsg('s', 'File : ' + MagFileObj.GetFileName); //FileSave);
      ImageEntryDelete(Magien,'NoImage');
      ENDPROGRESS;
      Exit;
    End;
    WinMsg('', 'Saving the captured file to the Image Server...');
    incprogress;

        //////////////////////////////////////////
        //   This code was copied to Import API and cleaned up.  A future patch will
        //   implement the Import API from Capture, so this code will be cut. thankgoodness
        //////////////////////////////////////////



   // if F140MultSources then
    if  CapX.m140PDFConvert  then
    begin
    If FileExists(GUserDir.Temp + 'magPDF.PDF') Then
    Begin
    multipagescan := True;
      Try
        CopyMultiPagePDF(Magien);
      Except
        Exit;
      End;
    //MakeAbs(MagFileObj.FullFileName, MagFileObj.GetAbsFullFileName); {in procedure FileImageAndCopyImage}
    End;
    end;
    If (CapX.mSourceID = mcSrcImport) and (NOT CapX.m140PDFConvert) Then
    Begin
      If ImportIni = 'COPY' Then
      Begin
        incprogress;
        //
        { TODO -ogarrett -c106 merge : Might Need to change to depend on Format and Association }
        { TODO : Not saving any changes to the image  ? if Dicom image. }
        If LbAssocDesc.caption = 'TRC' Then
        Begin
          //  THIS is where Dicom Fields are prompted for, Image converted, saved etc.
          { DONE : 117 fix design, modify to existing design : All data entered before Confirmation window.}
(*        if mnuDicom106.Checked Then  //TESTing  the 106 way - get this conditional, and menu item out Before Release
          begin
          FDicomdataArray.Clear;
          // in 106, the array was clear when app went to get all Dicom Data and Save Image
          Result := TRCSaveAsDICOM;  //106
          Exit;                      //106
          end
          else //p117
*)
          begin
          {/p117 we have FDicomDataUserArray from User selected values, and TESTDicomGetGeneratedData will
              merge in the generated data from the modified call.
              in 117 the FDicomDataArray is cleared before we call GetUserData.
              if User didn't call GetUserData, then we won't get here. }
          FDicomDataArray.Clear;  // Clear to be sure.  (Clarified 2-1-11.  User Data Not Required Now);
          TESTDicomGetGeneratedData; //117 this is generated each image.
          { TODO : NEED TO HAVE RESULT ON GETTING GENERATED DATA, STOP WITH ERROR MSG IF NEEDED}
          //MergeUserWithGenerated;
          if FDicomDataUserArray.Count > 0 then  FDicomDataArray.AddStrings(FDicomDataUserArray);
          Result := TRCSaveAsDicom;
          exit;
          end;                      //117
        End;   {end IF 'TRC' }

        If IsImageChanged Then //FileImageandCopyImage   Import = 'Copy'
        Begin
          If ImageChangedOther Then
          Begin
            (* p129
            //Gear 1.SettingMode := MODE_CONTRAST;
            //Gear 1.SettingValue := IG_CONTRAST_PIXEL;
            //Gear 1.Contrast := Gear 1.DisplayContrast;
            //Gear 1.Brightness := Gear 1.DisplayBrightness;
            *)
            { DONE -o129 : This Contrast Brightness doesn't work same as 99
                    We don't need to Set Contrast and Brightness from DisplayContrast,
                    DisplayBrightness.  Simply save the image ....}
          End;

        if mg1.PageCount > 1
          then
          Begin
          multipgmod := GUserDir.Temp + ExtractFileName(FGfiletoImport);
          DeleteFile(PChar(multipgmod));
            For i := 1 To mg1.PageCount do
            Begin
             (* p129
                Gear 1.Page := i;
                Gear 1.SaveImage := multipgmod;
             *)
              { DONE -o129 : Look into SaveDocumentToFile.  This works.}
              mg1.Page := i;
              GetIGManager.IGFormatsCtrl.SavePageToFile(mg1.GetCurrentPage
                                                        ,multipgmod
                                                        ,i
                                                        ,IG_PAGESAVEMODE_APPEND
                                                        ,CapX.mIGSaveFormat);

            End;
          End
          Else {here if  mg1.pagecount = 1}
          If Not SaveGear(GUserDir.Temp + ExtractFileName(FGfiletoImport))
            Then
            Begin
              ImageEntryDelete(Magien,'NoImage');
              ENDPROGRESS;
              Exit;
            End;
        End { If IsImageChanged Then}
        Else
          {DONE: p129t17  Need to check this....CopyTheFile failed, but processing continued.}
        CopyTheFile(LbImport.caption + '\' + FGfiletoImport, GUserDir.Temp);
                {wpr using TSession and TCapObj}
        If FileExists(GUserDir.Temp + ExtractFileName(FGfiletoImport))
          then
          Begin
          incprogress;
          RenameFile(GUserDir.Temp + ExtractFileName(FGfiletoImport), GUserDir.Temp + MagFileObj.GetFileName);
          CopyTheFile(GUserDir.Temp + MagFileObj.GetFileName, MagFileObj.GetPath);
          If FileExists(MagFileObj.FullFileName)
            Then
            WinMsg('', 'Imported File copied to Image Server OK.')
            Else
              Begin
              WinMsg('e', 'ERROR Imported File not Copied Correctly. Notify IRM');
              ImageEntryDelete(Magien,'NoImage');
              ENDPROGRESS;
              Exit;
              End;
                    {               try to copy .txt,.big, and .abs to server
                                    if requested and they exist - saf 12/8/98      }
          If FrmCapBatchAdv.FBatchAdvEnable And FrmCapBatchAdv.FBatchAdvCopyAll
            Then AdvancedBatchCopyAll(MagFileObj.GetPath, MagFileObj.GetFileNameNoExt);

          If Not DeleteFile(PChar(GUserDir.Temp + MagFileObj.GetFileName)) Then
            Begin
                    if not (Uppercase(MagFileObj.GetFileName) = 'MAGPDF.PDF') then
            WinMsg('d', 'Local file: ' + GUserDir.Temp + MagFileObj.GetFileName + '  not deleted.  Notify IRM');
            End;
          End
          else
          begin
          {129t17   This Exception was being Skipped. ImageEntryDelete was not here}
          WinMsg('e', 'ERROR Copying to : '+ GUserDir.Temp + '. Notify IRM.');
          ImageEntryDelete(Magien,'NoImage');
          ENDPROGRESS;
          Exit;
          end;
        incprogress;

      End ;{END of -  if import = copy then }
      {p129t17  ABSCreated was attempted even if CopyTheImage  failed ? ? }
      If ABSCreated Then
        MakeAbs(MagFileObj.FullFileName, MagFileObj.GetAbsFullFileName); {in procedure FileImageAndCopyImage}
    End; {ENDOF-   If ScanMode='Import' then}

        ////////////////////////////////////////////

    incprogress;
  /// 140 out    was resetting after PDF set it to TRUE      multipagescan := False;
        // QaD multipage Twain scan flag.
    If FileExists(GUserDir.Temp + 'multipage.tif') Then
    Begin
    multipagescan := True;
      Try
        CopyMultiPageFile(Magien);
      Except
        Exit;
      End;
    MakeAbs(MagFileObj.FullFileName, MagFileObj.GetAbsFullFileName); {in procedure FileImageAndCopyImage}
    End;
    If (CapX.mSourceID <> mcSrcImport) And (Not multipagescan) Then
    Begin
      incprogress;
      MagAspectRatio(1);
            // Question   Meteor, TWAIN, SCanned Doc (Rotates won't be saved ? ? ? )
            //            Clipboard.
      If ImageChangedOther Then
      Begin
      
        (* p129  Do We need This Answer : No,  Contrast/Brightness saved on save.
        Gear 1.SettingMode := MODE_CONTRAST;
        Gear 1.SettingValue := IG_CONTRAST_PIXEL;
        Gear 1.Contrast := Gear 1.DisplayContrast;
        Gear 1.Brightness := Gear 1.DisplayBrightness;
        *)
      End;
            { All Captures other than Import and Multi Page TWAIN will get here.
                The Image is saved from the Gear Control.
                Rotate's Flips etc ( changes ) are thus saved also.
                SO no need to check for FImageChanged.   }
      AccusoftPropertiesLog('Before SaveGear: NONImport - FileAndCopyImage');

      If Not SaveGear(magfileobj.FullFileName) Then
      Begin
        ImageEntryDelete(MagFileObj.ID,'NoImage');
        ENDPROGRESS;
        Exit;
      End;
      If Not FileExists(magfileobj.FullFileName) Then
      Begin
        WinMsg('e', 'Captured File NOT saved to Image Server.  Notify IRM');
        ImageEntryDelete(MagFileObj.ID,'NoImage');
        ENDPROGRESS;
        Exit;
      End
      Else
        WinMsg('', 'Captured File saved to Image Server.');

      incprogress;
      If ABSCreated Then
        MakeAbs(MagFileObj.FullFileName, MagFileObj.GetAbsFullFileName); {in procedure FileImageAndCopyImage}
    End; {ENDOF-  If not(ScanMode='Import') then}
    incprogress;
        {rename xray2.big}{this should be an option}

 /////////////  Lumisys is in ScanMode    ////////////////////////////////

//    If Pos('Lum', Scanmode) > 0 Then {lumisys150 and  lumisys75} {RED 9/17/96}
    If (CapX.mSourceID = mcSrcLumisys75) or (CapX.mSourceID = mcSrcLumisys150) Then
    Begin
      incprogress;
      If FCapSaveBIG Then
      Begin
        WinMsg('s', 'Saving BIG File.. ');
        If Not (RenameFile(GUserDir.Temp + 'xray2.big', (GUserDir.Temp + MagFileObj.GetFileNameNoExt + '.big'))) Then
        Begin
          incprogress;
          WinMsg('de', 'ERROR handling scanned file - Failed to Rename BIG File.');
          gauge1.Visible := False;
          Exit;
        End
        Else
          WinMsg('', 'Rename of BIG File Successful');
        Application.Processmessages;

        Test := magfileobj.GetPath;
        {HERE HERE}
        CopyTheFile(GUserDir.Temp + MagFileObj.GetFileNameNoExt + '.big', magfileobj.GetPath);
        Application.Processmessages;

        If FileExists(MagFileObj.GetBIGFullFileName) Then
        Begin
          incprogress;
          WinMsg('', 'Captured 2k x 2k ''BIG'' File Saved to Image Server');
          PARAM := GUserDir.Temp + MagFileObj.GetFileNameNoExt + '.big';
          If Not DeleteFile(PChar(PARAM)) Then
            WinMsg('d', 'Local file: ' + PARAM + '  not deleted.  Notify IRM');
        End
        Else
        Begin
          {PRE 129 ..  we contine if BIG file isn't copied.  This is as designed. }
          WinMsg('d', 'Failed to Copy 2k x 2k ''BIG'' File to Image Server');
        End;
        incprogress;
      End; {ENDOF-  If FCapSaveBIG then}
      Application.Processmessages;
      incprogress;
      If FileExists(GUserDir.Temp + 'xray2.big') Then
      Begin
        PARAM := GUserDir.Temp + 'xray2.big';
        If Not DeleteFile(PChar(PARAM)) Then
          WinMsg('d', 'Local file: ' + PARAM + '  not deleted.  Notify IRM');
      End;
      Application.Processmessages;
      incprogress;
            (* The following section taken out on 6/5/97 GEK, because we are no longer
             making abstracts in the Lumisys BAT files.  Abstracts are made above,
             ALSO all calls in the Lumisys...BAT files to create abstracts are REM'd out*)
    End; {ENDOF-  Pos('Lum',ScanMode)>0 then}

 ///////////// end IF Lumisys is in ScanMode    ////////////////////////////////
  
    incprogress;

        {   CopyToJUKEBOX and Create ABSTRACT QUEUES for the BACKGROUND PROCESSOR are
             made by this call:  , we always set the CopyToJukeBox  Queue,
                               and sometimes set the Create Abstract Queue}
    tempstr := '';
    Test := magfileobj.ID;
    {p129t17  if Copy fails, this needs to be skipped}
    If ((Not ABScreated) And (ABSforImage)) Then
      tempstr := MagFileObj.ID; //imgptr // Calling 'MAG ABSJB'
    If ABSbyJB Then
      tempstr := MagFileObj.ID; // Patch 59, we'll Que DCM Abstracts.
    WinMsg('', 'Filing Abstract information...');
    XBROKERX.PARAM[0].Value := tempstr + '^' + MagFileObj.ID; //imgptr
    XBROKERX.PARAM[0].PTYPE := LITERAL;
    XBROKERX.REMOTEPROCEDURE := 'MAG ABSJB';
    Try
      CallBrokerX; //xBrokerx.Call;
      incprogress;
      If ((MagPiece(XBROKERX.Results[0], '^', 1) = '0')
        Or (MagPiece(XBROKERX.Results[0], '^', 1) = '')) Then
        WinMsg('de', 'ERROR: Filing Abstract information. ' +
          MagPiece(XBROKERX.Results[0], '^', 2))
      Else
      Begin
        WinMsg('', 'Abstract information Filed.');
        WinMsg('s', XBROKERX.Results[0]);
      End;
    Except
      On e: Exception Do
      Begin
        WinMsg('de', 'ERROR: Filing Abstract information:' + #13 + e.Message + #13 +
          'NOT Fatal.  Application Will Continue.')
      End;
    End;
    incprogress;

    If FileExists(GUserDir.Temp + 'scantemp' + CapX.mFormat) Then {var format} {FileImageAndCopyImage} {DelTempFile}
    Begin
      PARAM := GUserDir.Temp + 'scantemp' + CapX.mFormat; {var format} {FileImageAndCopyImage} {DelTempFile}
      If Not DeleteFile(PChar(PARAM)) Then
        WinMsg('d', 'Local file: ' + PARAM + '  not deleted.  Notify IRM');
    End;
    incprogress;
    If (ABSCreated And FileExists(GUserDir.Temp + 'scantemp.abs')) Then
    Begin
      WinMsg('', 'Deleting Temporary Abstract File.');
      PARAM := GUserDir.Temp + 'scantemp.abs';
      If Not DeleteFile(PChar(PARAM)) Then
        WinMsg('d', 'Temporary Abstract File: ' + PARAM + ' not deleted.  Notify IRM');
    End;

        { DONE Capturing and Cleaning up of temp images }

    endprogress;
    ButtonSettings(1);
    Result := True;
    WinMsg('', 'Image scan/capture is completed.');
    GearClear;
{$IFDEF MeteorBoard}
    If FrmCapConfig.Meteor.Checked And Doesformexist('MagMeteorForm') Then
      MagMeteorForm1.SetFocus;
{$ENDIF}
    Imagelongdesc.Lines.Clear;
    If Not FrmCapConfig.ImageGroup.Checked Then
      ClearImageDescFields;
    If (Magassoc = 'PHOTOID') Then
    Begin
      ClearImageDescFields;
      ClearCurrentPatient;

    End;


  {always get here  }
  Finally
    iDModObj.GetMagFileSecurity.MagCloseSecurity(Rmsg);
        {	Set everything to null, to initialize for next capture.}
    {129t17 if the copy to Network fails... we don't want to clear a Scanned Image.}
    {       only clear on successful copy.
      If succesful, then must change .NewAddendum to false.  }
    if Result then
        begin
        FCapClinDataObj.NewAddendum := false;
        if (Pos('Addendum',lbProcDate.Caption) > 0) then lbProcDate.Caption := '*Note Date';

        MagFileObj.Clear; {in the last 'Finally' block of    FileImageAndCopyImage}
        end;
    Screen.Cursor := crDefault;
    gauge1.Visible := False;
    endprogress;
  End; {try}
End; {END OF FUNCTION FileImageAndCopyImage}




procedure TfrmCapMain.AnnotationGetConsultResulted();  {duc change }
begin
  {/p129  made seperate call to get status of Consult Resulted}
{duc change start}
  //p129t19 - don't need the ien here
  //if  (newMagien <> '') then
  //begin
{duc change end}
  //p122 dmmn 7/28 - only save when there's actual annotation
  {/p122 dmmn WPR Capture Item #8 /}
  if AnnotationsExist() then
  begin
    (* p129 out.  THE TRCImageManips and FAnnotationManips won't be in this window.  They'll
                   be handled now in the new Mag4VGear used in capture. *)

    {/p122 dmmn 8/24 - check again before save if the picture is being captured
        as a progress note and the status is completed or not, in case capturer
        didn't put in esignature /}
    
    //  NOTES is trickey, (gek 140)... no change for now, unless error  /////if MagAssoc = 'NOTES' then      //p129t19 dmnn - avoid using visual component
if lbAssocDesc.Caption = 'TIU' then // if progress note then check for status
    begin
      if (FCapClinDataObj <> nil) then
      begin
        {/p122 dmmn WPR Capture Item #21 /}
        if FCapClinDataObj.NewNote then  // new note
        begin
          // 1 efiled, 2 signed, 0 unsigned
          if (FCapClinDataObj.NewStatus = '1') or (FCapClinDataObj.NewStatus = '2') then
            FCapAnnotConsultResulted := True
          else
            FCapAnnotConsultResulted := False;
        end
        else  // attached to old note
        begin
          //p122t7
          if FCapClinDataObj.ReportData = nil then
          begin
            FCapAnnotConsultResulted := False;
          end
          else
          begin
            if UpperCase(FCapClinDataObj.ReportData.Status) = 'COMPLETED' then {/p122 dmmn WPR Capture Item#14/}
              FCapAnnotConsultResulted := True
            else
              FCapAnnotConsultResulted := False;
          end;
        end;
      end
      else
        FCapAnnotConsultResulted := False;
    end
    else
      FCapAnnotConsultResulted := False;

      // dmmn 6/30 Update everything instead of just IEN
      // fCapAnnot.UpdateImageIEN(Magien);
      // fCapAnnot.UpdateSessionInfo(UserCapName,

      //p129 NOT saving Annotations in this call.

  end;
  //end;  {compute AnnotationGetConsultResulted} {duc change}
end;




procedure TfrmCapMain.mg1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //Mg1.FrameMouseUp(Sender, Button, Shift, X, Y);
  if Button = mbright then
    begin
    winmsg('s','mg1MouseUp');  //p129 t2  made this a system 's' message.
    OpenImageMenu(x, y);
    end;
end;

procedure TfrmCapMain.mg1DragDrop(Sender, Source: TObject; X, Y: Integer);
begin
// This isn't surfaced.. doesn't get called.  this would be the Frame,  but Frame
//  isn't reachable under FMag4Vgear14... might need to surface the OnDragDrop of
//  FMag4VGear14 to get this to work.
showmessage('on Drag Drop mg1');
end;

{/gek  not sure if this is needed... I put in the EXIT,. to  see.. }
Procedure TfrmCapMain.mg1DragOver(Sender, Source: Tobject; x, y: Integer; State: TDragState; Var Accept: Boolean);
Begin
   exit;
    //59  if source = lvBatch then accept := true
    //59  else accept := false;
  Accept := (Source Is TMag4VGear);
End;

    {p129t10 gek TestMenu items.  not visible to user}
procedure TfrmCapMain.testMNUmg1FREE1Click(Sender: TObject);
begin
//  TESTING Menu
  mg1.Free;
  CreateGearComponent;   
end;

procedure TfrmCapMain.MagAspectRatio(mode : integer;  value : integer = 0 );
begin
{ 1 is for : IG_DSPL_ASPECT_FIXED which was replacement for    IG_ASPECT_DEFAULT  }
{ 2  is for   ??                                        IG_ASPECT_MINDIMENSION    }
//
     { TODO : aspect ratio for mg1  (Tmag4VGear) }
//mg1.
(*
// Constants for enum enumIGDsplAspectModes
type
  enumIGDsplAspectModes = TOleEnum;
const
  IG_DSPL_ASPECT_FIXED = $00000000;
  IG_DSPL_ASPECT_NOT_FIXED = $00000001;


AspectRatioValue : double;
  *)
end;

Procedure TfrmCapMain.btnCancelScanClick(Sender: Tobject);
Begin
  CancelCapture;
End;

Procedure TfrmCapMain.CancelCapture(ClearImage: Boolean = True);
var s : string;
Begin
  CapX.m140CombineScans := false;
  frmCapConfig.EnableMultipleCaptures(false);  // 140 get to field . Do this always.


{Need to check this  if m140Combined,  we don't want to Disable the ImageOK, or Delete the magpdf.pdf or multipage.tif...
...  but they have the current image, that user may want to Cancel...

...   may need to switch to Saving PDF on Image OK Click,
and have a PDF Complete, or SCAN Complete button similiar to Study Group Complete. }
  

  Screen.Cursor := crDefault;
  If ClearImage Then //02/27/03
  Begin
(* P129   Annotations are cleared When GearClear is called.
    {/p122 dmmn WPR Capture Item #8,10 /}
    if fCapAnnot.HasAnnotationComponent then
      MagAppMsg('s', 'Capturing process was cancelled. Annotations were cleared');    {/p122 dmmn WPR Capture Item #20 /}
*)
    GearClear;
    ButtonSettings(1);

   if (not CapX.m140MultSources) and (not CapX.m140CombineScans) then
    begin
    s := GUserDir.Temp + 'scantemp.tga';
    DeleteFile(PChar(s));
    s := GUserDir.Temp + 'resetfile.tif';
    DeleteFile(PChar(s));
    s := GUserDir.Temp + 'multipage.tif';
    DeleteFile(PChar(s));
    s := GUserDir.Temp + 'magPDF.pdf';
    DeleteFile(PChar(s));
    end;

  End
  Else
  Begin
    ButtonSettings(2);
    EdtImageDesc.SetFocus;
  End;
  Timer1.Enabled := False;
  MagTerminateProcess(0, Exeprocessinfo);
  If LvImport1.Selected <> Nil Then
    LvImport1.Selected := Nil;
  If Lvbatch.Selected <> Nil Then
    LvImport1.Selected := Nil;
    //02/27/03 buttonsettings(1);

(* out 122  p122 dmmn 8/22 - not needed anymore //
  {/P122 DMMN 6/24/2011 - Clear annotation component if available and disable annotation button /}
//  if fCapAnnot <> nil then
  //p122 dmmn 6/30 - only clear annotation if clear image is true
  //p122 dmmn 8/22 - remove double neg condition
 if fCapAnnot.HasAnnotationComponent and ClearImage then   //P122 DMMN 6/28/2011 - let the panel live and kill the annotation component
  begin
    //    FreeAndNil(fCapAnnot);
    fCapAnnot.Close;
    MagAppMsg('s', 'Capture Process was cancelled. Annotations were cleared');
  end;      end out 122 *)
///// This is being disabled/enabled in GearClear  t lbrbtnAnnotation.Enabled := False;

End;

Function TfrmCapMain.SaveImageTextFile(Var Xmsg: String): Boolean;
Var
  ImageTXTFile: String;
  i: Integer;
  t: Tstringlist;
Begin
  Result := False;
  Xmsg := 'Attempting to save .txt file...';
  t := Tstringlist.Create;
  Try
    ImageTXTFile := ChangeFileExt(magfileobj.FullFileName, '.TXT'); {in SaveImageTextFile}
    t.Add('$$BEGIN IMAGE DATA');
    t.Add('PATIENTS_NAME=' + iDModObj.GetMagPat1.M_NameDisplay);
        {Add new Data to the TXT file.}
    t.Add('PATIENTS_DFN=' + iDModObj.GetMagPat1.M_DFN);
    t.Add('INTEGRATION_CONTROL_NUMBER=' + iDModObj.GetMagPat1.M_ICN);
    t.Add('PATIENTS_BIRTH_DATE=' + iDModObj.GetMagPat1.M_DOBdisplay);
    t.Add('PATIENTS_AGE=' + iDModObj.GetMagPat1.M_Age);
    t.Add('PATIENTS_SEX=' + iDModObj.GetMagPat1.M_Sex);
    t.Add('PATIENTS_ID=' + iDModObj.GetMagPat1.M_SSN);
        {//93t8       The Station Number Field (#99) from Inst File (#4), from VistA}
    t.Add('STATION_NUMBER=' + GSess.WrksInstStationNumber);
        //t.Add('IMAGE_DATE' + DateTime.Caption);
        { DONE :  DataTime was set as Start up , it was never the image Date.
            So either get the date from VistA Image file, or send DateTime as
            parameter. unitll then use this. }
    t.Add('IMAGE_DATE=' + FImageCaptureDate);
    t.Add('CAPTURED BY=' + userCapname);
    t.Add('SHORT DESCRIPTION=' + EdtImageDesc.Text);
    t.Add('MANUFACTURER=VISTA IMAGING');
    t.Add('MANUFACTURERS_MODEL_NAME=CAPTURE WORKSTATION ' + MagGetFileVersionInfo(Application.ExeName));

    If Imagelongdesc.Lines.Count > 0 Then
    Begin
      t.Add('LONG DESCRIPTION');
      For i := 0 To Imagelongdesc.Lines.Count - 1 Do
      Begin
        t.Add(Imagelongdesc.Lines[i]);
      End;
    End;
    t.Add('$$END IMAGE DATA');

    Try
      t.SaveToFile(ImageTXTFile);
      WinMsg('', 'Notes saved to .txt file: ' + ImageTXTFile);
      Result := True;
    Except
      Xmsg := 'Failed to copy .txt File to Imaging Network';
      WinMsg('de', Xmsg);
      Exit;
    End;
  Finally
    t.Free;
  End;
End;

Procedure TfrmCapMain.AdvancedBatchCopyAll(bcNewdir, bcFileNamene: String); //FileName has no extension
Var
  PARAM: String;
Begin
 {TODO : 129t18 ...
      Issue 1  using Magpiece (FGfiletoImport,".",1)  won't work for all files.
      Issue 2  CopytheFile isn't being checked for Failure. }
      // gek Patch 59  Changed all newdir to bcNewDir
  If FileExists(LbImport.caption + '\' + MagPiece(FGfiletoImport, '.', 1) + '.txt') Then
  Begin
        {  In the scheme of things, this will overwrite the txt file that is created,
           this is a good thing.}
    PARAM := bcNewdir + '\' + bcFileNamene + '.txt';
    DeleteFile(PChar(PARAM));
    CopyTheFile(LbImport.caption + '\' + MagPiece(FGfiletoImport, '.', 1) + '.txt', GUserDir.Temp);
    RenameFile(GUserDir.Temp + MagPiece(FGfiletoImport, '.', 1) + '.txt', GUserDir.Temp + bcFileNamene + '.txt');
    CopyTheFile(GUserDir.Temp + bcFileNamene + '.txt', bcNewdir);
    PARAM := GUserDir.Temp + bcFileNamene + '.txt';
    DeleteFile(PChar(PARAM)); //delete /temp/.txt file

  End;
  If FileExists(LbImport.caption + '\' + MagPiece(FGfiletoImport, '.', 1) + '.big') Then
  Begin
    CopyTheFile(LbImport.caption + '\' + MagPiece(FGfiletoImport, '.', 1) + '.big', GUserDir.Temp);
    RenameFile(GUserDir.Temp + MagPiece(FGfiletoImport, '.', 1) + '.big', GUserDir.Temp + bcFileNamene + '.big');
    CopyTheFile(GUserDir.Temp + bcFileNamene + '.big', bcNewdir);
    PARAM := GUserDir.Temp + bcFileNamene + '.big';
    DeleteFile(PChar(PARAM)); //delete /temp/.big file
    FCapSaveBIG := False; //Reset FCapSaveBIG pointer
  End;
  If FileExists(LbImport.caption + '\' + MagPiece(FGfiletoImport, '.', 1) + '.abs') Then
  Begin
    PARAM := bcNewdir + '\' + bcFileNamene + '.abs';
    DeleteFile(PChar(PARAM));
    CopyTheFile(LbImport.caption + '\' + MagPiece(FGfiletoImport, '.', 1) + '.abs', GUserDir.Temp);
    RenameFile(GUserDir.Temp + MagPiece(FGfiletoImport, '.', 1) + '.abs', GUserDir.Temp + bcFileNamene + '.abs');
    CopyTheFile(GUserDir.Temp + bcFileNamene + '.abs', bcNewdir);
    PARAM := GUserDir.Temp + bcFileNamene + '.abs';
    DeleteFile(PChar(PARAM)); //delete /temp/.abs file
        {have to stop the creation of Abstracts and the Queing of Abs to be created by JB}
    AbsForImage := False;
    AbsByJB := False;
        //update abs pointer
  End; //copy abstract file
End;

Procedure TfrmCapMain.NewStudy(Ignorenoclear: Boolean = False);
Begin
  ClearCurrentPatient(Ignorenoclear);
  ClearAssociationFields(Ignorenoclear); //{  in   NewStudy}
  ClearIndexFields(Ignorenoclear);
  ClearImageDescFields(Ignorenoclear); // 4/12/00

  btnxDateTime.caption := '';
  Imageptrlst.Items.Clear;

  GrpPtr := '';
  GrpDesc := '';
  GrpLongDesc.Clear;

  GearClear;
  mg1.UpdatePageView;
  ButtonSettings(1);

End;

Procedure TfrmCapMain.ClearAllText;
Begin

End;

Procedure TfrmCapMain.FileImage(Var imagefiled: Boolean; Var Magien: String; Var vNewImageFile: String);
Var
  Xmsg, vFileEXT, Status, Itype: String;
  tempimagetype: Shortint;
    //  fstat: boolean;
  t: Tstringlist;
    //  rmsg: string;
Begin
    {Stop any updates to VistA if TEST Mode is ON}
  If FModeTest Then
  Begin
    imagefiled := False;
    WinMsg('', 'Test Mode is ON.  No DataBase updates.');
    Exit;
  End;
  t := Tstringlist.Create; //WPR         (FileImage method)
  Try
        {       Get date from VistA. Workstation date could be much different}
    If RPFileManDate(Xmsg, 'N', FImageCaptureDate) Then
      FImageCaptureDate := MagPiece(FImageCaptureDate, '^', 1)
    Else
      FImageCaptureDate := EdtProcDate.Text;

        (*   ?? why is this commented out     {       Patch 8 Photo ID}
           if magassoc = 'PHOTOID' then
             begin
               {       Get Internal Entry number for PHOTO ID from IMAGE INDEX FOR TYPES }
               iDModObj.GetMagDBBroker1.RPMag3LookupAny(fstat, rmsg, t, '2005.83^1^PHOTO ID^');
               if fstat then imgtypeptr := magpiece(t[1], '^', 2);
             end;   *)

    tempimagetype := CapX.mImageType;
    WinMsg('', 'Filing the Image data...');
    If Not XBROKERX.Connected Then
    Begin
      imagefiled := False;
      WinMsg('d', 'No VistA Connection. Cannot Save Image.');
      Exit;
    End;
    //p106 start
   {/p117 Note : app waits until here to get TRCSOPInstanceUID instead of getting it earlier.
                    ... TRCSOPInstanceUID, is unique per image and is based on time. }
    {/p117 gek use magAssoc}
    If (magAssoc = 'TRC') then  //FrmCapConfig.TeleReaderConsult.Checked Then
    Begin
      TRCSOPInstanceUID := GetSOPInstanceUID(XBROKERX, iDModObj.GetMagPat1.M_DFN, MagPiece(TRConsultPtr, '^', 1), TRCStudyUID, TRCSeriesUID);
      If TRCSOPInstanceUID = '' Then
      Begin
        WinMsg('', 'Image data NOT FILED : ' + 'TRCSOPInstanceUID is empty');
        Messagebeep(0);
        imagefiled := False;
        Magien := '';
        Exit;
      End;
    End;
    //p106 end
    Screen.Cursor := crHourGlass;
    XBROKERX.PARAM[0].Value := '.X';
    XBROKERX.PARAM[0].PTYPE := List;
    LoadStaticFields;
    LoadAssociationFields; //WPR INDEX

    If FrmCapConfig.ImageGroup.Checked Or TeleMedSingle Then    //p106 TeleMedSingle
    Begin
      XBROKERX.PARAM[0].Mult['"GROUP"'] := '14^' + GrpPtr;
      If Doesformexist('DicomNumbers') Then
      Begin
        XBROKERX.PARAM[0].Mult['"DICOMSN"'] := 'DICOMSN^' + DicomNumbers.EDSN.Text;
        XBROKERX.PARAM[0].Mult['"DICOMIN"'] := 'DICOMIN^' + DicomNumbers.EDIN.Text;
      End;
    End;
        {       If we get here with a File Format (Extension EXE... etc) that
                we do not support.  Message (xmsg)and Exit. }
    If (FGfiletoImport <> '') And Not filetypesupported(ExtractFileExt(FGfiletoImport), Itype, Xmsg) Then
    Begin
      imagefiled := False;
      Exit;
    End
            {       itype is the Image Type. Set in fileTypeSupported method. }
    Else
      If ((CapX.mSourceID = mcSrcImport) And (ImportIni = 'COPY') And (Itype <> '')) Then
        tempimagetype := Strtoint(Itype);
    if CapX.m140PDFConvert then tempImageType := 104;

    If FrmCapConfig.PhotoID.Checked Then
    Begin
      tempimagetype := 18;
    End;
    //p106 rlm 20100929 start
    {/p117 gek use magAssoc}
    If (magAssoc = 'TRC') then //FrmCapConfig.TeleReaderConsult.Checked Then
    Begin
      tempimagetype := 100;
      XBROKERX.PARAM[0].Mult['"SOPClass"'] := '251^' + TRCSOPClassIEN; //SOP Class.

      If TRCSeriesUID = '' Then
      Begin
        WinMsg('', 'Image data NOT FILED : ' + 'TRCSeriesUID is empty');
        Messagebeep(0);
        imagefiled := False;
        Magien := '';
        Exit;
      End;
      XBROKERX.PARAM[0].Mult['"SERIESUID"'] := '253^' + TRCSeriesUID;

      //populate 2005 field 60 with SOP_Instance_UID
      XBROKERX.PARAM[0].Mult['"IMAGEUID"'] := '60^' + TRCSOPInstanceUID;

      //populate 2005.04
      If TRCSeriesNum = '' Then
      Begin
        WinMsg('', 'Image data NOT FILED : ' + 'TRCSeriesNum is empty');
        Messagebeep(0);
        imagefiled := False;
        Magien := '';
        Exit;
      End;
      XBROKERX.PARAM[0].Mult['"DICOMSN"'] := 'DICOMSN^' + TRCSeriesNum;
      XBROKERX.PARAM[0].Mult['"DICOMIN"'] := 'DICOMIN^' + Inttostr(TRCImageCtr + 1);

    End;
     //   if F140MultSources and (F140PDFConvert)then
    if CapX.m140PDFConvert then
      begin
      tempimagetype := 104;
      end;
    XBROKERX.PARAM[0].Mult['"CAPAPP"'] := '8.1^C';
    //p106 rlm 20100929 end
    XBROKERX.PARAM[0].Mult['"OBJTYPE"'] := '3^' + Inttostr(tempimagetype);
        // P48T3
    XBROKERX.PARAM[0].Mult['"INSTITUTION"'] := '.05^' + GSess.Wrksinst.ID;

    vFileEXT := Copy(CapX.mFormat, 2, 99); {var format} {fileimage}
    if  (CapX.m140PDFConvert) then
      begin
      vFileExt := 'PDF';
      end;

    If (CapX.mSourceID = mcSrcImport) and (not CapX.m140PDFConvert )  Then
    Begin
      If ImportIni = 'COPY' Then
      Begin
        If LbAssocDesc.caption = 'TRC' Then
          vFileEXT := 'DCM'
        Else
          vFileEXT := Uppercase(Copy(ExtractFileExt(FGfiletoImport), 2, 99));

      End;
     // Convert to Dicom could work like the Convert to TGA Worked.  or Like Convert to PDF.
     (* //p117   ->  in Patch 93 we disabled TGA.  but code wasn't commented out.
     {/p117 comment out the code, and we'll clean up, delete this unused code after testing}
      If Import_Ini = 'TGA' Then vFileEXT := 'TGA';
      *)
    End;
    If vFileEXT = 'TXT' Then vFileEXT := 'ASC';
    XBROKERX.PARAM[0].Mult['"FileExt"'] := 'EXT^' + vFileExt;
        (*  gek 2/18/97 { TEST PETE'S "WRITE^PACS"  }
        {--  xBrokerx.Param[0].Mult['"PACSWRITE"']:='WRITE^PACS';   gek 2/18/97}
        {-- the TEST worked OK, but DON'T uncomment these lines}  gek 2/18/97*)
        { test the BIG File flag  }

        // If importing w/copy all and big file exists, set fbig node in 2005 saf 12/8/98
    If (FrmCapBatchAdv.FBatchAdvEnable And FrmCapBatchAdv.FBatchAdvCopyAll And FileExists(LbImport.caption + '\' + MagPiece(FGfiletoImport, '.', 1) +
      '.big'))
            {Gek Patch 59 Only want save big for AdvBatchCap, not for everything }
        {// then FCapSaveBIG := True;}Then
      XBROKERX.PARAM[0].Mult['"bigfile"'] := 'BIG^1';
      {/ P122 T7 - JK 11/2/2011 - commenting out the next two lines to correct the error
                                  reported in Remedy Ticket 527026 (Big File Pointers) /}
//    If FCapSaveBIG Then
//      XBROKERX.PARAM[0].Mult['"bigfile"'] := 'BIG^1';

        {ABS created on ws}
    If (ABSCreated And ABSforImage) Then
      XBROKERX.PARAM[0].Mult['"NETLOCABS"'] := 'ABS^STUFFONLY';

        {TODO: if ABS exist, then the ABSJB call will 'set/not set' the appropriate pointer
               this is probably not needed.}
    If (AbsCreated And FrmCapBatchAdv.FBatchAdvEnable And FrmCapBatchAdv.FBatchAdvCopyAll) Then
      XBROKERX.PARAM[0].Mult['"NETLOCABS"'] := 'ABS^STUFFONLY';
        { If saving to a directory other than Image Write location}
    If (Writedir <> '') Then
      XBROKERX.PARAM[0].Mult['"WRITEDIR"'] := '2^' + WRITEDIR;

    Screen.Cursor := crHourGlass;
    If (Not IsGearClear(mg1)) Then
      If (mg1.PageCount > 1) Then
        XBROKERX.PARAM[0].Mult['"PAGECOUNT"'] := '114^' + Inttostr(mg1.PageCount);
    If FControlledImage Then
      XBROKERX.PARAM[0].Mult['"CONTROLLED"'] := '112^1';
        ///////////////////////////////////////////
    XBROKERX.REMOTEPROCEDURE := 'MAGGADDIMAGE'; //FileImage
    Status := XBROKERX.STRCALL;
        ///////////////////////////////////////////

        {   ien^full path^filename.ext}
    Screen.Cursor := crDefault;
    WinMsg('s', Status);
        //ImgPtr := MagPiece(status, '^', 1);
    Magien := MagPiece(Status, '^', 1);
    If ((Magien = '0') Or (Magien = '')) Then
    Begin
      WinMsg('', 'Image data NOT FILED : ' + MagPiece(Status, '^', 2));
      Messagebeep(0);
      imagefiled := False;
      Magien := '';
      Exit;
    End;
        {We populate MagFileObj with the new file name.  MagFileObj only has the two}{In FileImage}
        {   properties   FullFileName and ID.  everything else is a function using these two values.}{In FileImage}
    MagFileObj.FullFileName := MagPiece(Status, '^', 2) + MagPiece(Status, '^', 3); {In FileImage}
    MagFileObj.ID := Magien; {In FileImage}
    WinMsg('', 'The Image data was filed OK');
    WinMsg('s', 'Image IEN ' + MagFileObj.ID); {In FileImage}
        //dirx := MagPiece(status, '^', 2);
       // FileSave := MagPiece(status, '^', 3);
        //MagImageFullPathAndName := dirx + filesave;
       // FileSave := MagPiece(FileSave, '.', 1);
       // if frmCapConfig.imagegroup.checked then ImagePtrLst.Items.Add(magien + '^' + FileSave);
    If FrmCapConfig.ImageGroup.Checked Or TeleMedSingle Then //p106 rlm 20101011
      Imageptrlst.Items.Add(MagFileObj.ID + '^' + MagFileObj.GetFileNameNoExt); {In FileImage}
    imagefiled := True;
  Finally
    t.Free;
  End;
End;

Procedure TfrmCapMain.FileGroup(Var imagefiled: Boolean);
Var
  Resstr, Xmsg: String;
Begin
  If FModeTest Then
  Begin
    imagefiled := False;
    WinMsg('', 'Test Mode is ON.  No DataBase updates.');
    Exit;
  End;
  If RPFileManDate(Xmsg, 'N', FImageCaptureDate) Then
    FImageCaptureDate := MagPiece(FImageCaptureDate, '^', 1)
  Else
    FImageCaptureDate := EdtProcDate.Text;

  WinMsg('', 'Filing the Image Study Group...');
  If Not XBROKERX.Connected Then
  Begin
    imagefiled := False;
    WinMsg('d', 'No VistA Connection. Can not create Image Group.');
    Exit;
  End;
  GrpDesc := EdtImageDesc.Text;
  GrpLongDesc.Lines := Imagelongdesc.Lines;

  WinMsg('', 'Filing the ' + EdtStudy.Text + ' ' + GrpDesc + ' Study Group...');
  Screen.Cursor := crHourGlass;
  XBROKERX.PARAM[0].Value := '.X';
  XBROKERX.PARAM[0].PTYPE := List;
  LoadStaticFields;
  LoadGroupAssociationFields;
  XBROKERX.PARAM[0].Mult['"GROUPDESC"'] := '10^' + GrpDesc;
  XBROKERX.PARAM[0].Mult['"CHILDOFGROUP"'] := '2005.04^0';
  XBROKERX.PARAM[0].Mult['"OBJTYPE"'] := '3^11';
  If FControlledImage Then
    XBROKERX.PARAM[0].Mult['"CONTROLLED"'] := '112^1';
  //p106 rlm 20100929 start
{/p117 gek.  use magAssoc }
  If (magAssoc = 'TRC') then //FrmCapConfig.TeleReaderConsult.Checked Then
  Begin
    XBROKERX.PARAM[0].Mult['"GROUPHEADER"'] := '60^' + TRCStudyUID;
    XBROKERX.PARAM[0].Mult['"SOPClass"'] := '251^' + TRCSOPClassIEN; //SOP Class.
  End;

  XBROKERX.PARAM[0].Mult['"CAPAPP"'] := '8.1^C'; //p106 rlm 20101021
  //p106 rlm 20100929 end

  XBROKERX.REMOTEPROCEDURE := 'MAGGADDIMAGE'; //FileGroup
  Resstr := XBROKERX.STRCALL;
  Screen.Cursor := crDefault;
  GrpPtr := MagPiece(Resstr, '^', 1);
  If ((GrpPtr = '0') Or (GrpPtr = '')) Then
  Begin
    WinMsg('e', 'Error creating Image Group : ' + MagPiece(Resstr, '^', 2) + MagPiece(Resstr, '^', 3));
    Messagebeep(0);
    imagefiled := False;
    Exit;
  End;

  GroupFile := 'GP' + GrpPtr;
  WinMsg('', GrpDesc + ' Study Group Filed OK');

    //  FileSave := GroupFile; {ien}

  imagefiled := True;
End;

Procedure TfrmCapMain.VistaWrite(CaptName: String);
Var
  cmd, PARAM: String;
Begin
    {WRITE image to temporary file}
  cmd := AppPath + '\vistawN.pif';
  If CaptName = '' Then
    CaptName := GUserDir.Temp + 'scantemp.tga';
  PARAM := CaptName;
  Result := Magexecutefile(cmd, PARAM, AppPath, SW_SHOWMINIMIZED);
  Timer1.Enabled := True;
  WinMsg('', 'Starting Vista Write...');
End;

Procedure TfrmCapMain.Timer1Timer(Sender: Tobject);
Begin
    { 2/17/99  NOW only Vista Board and (all) Lumisys use the Timer to determine if
      the capture process is finished, and the CaptureIsValid }
  WinMsg('s', 'Timer1Timer');
  If IsProcessRunning(Exeprocessinfo) Then
  Begin
    WinMsg('', 'Capture Process is running...');
    Exit;
  End;
  WinMsg('s', 'Timer , ScanMode : ' + CapX.GetSourceDesc);

  Timer1.Enabled := False;
    { 2.18.99  ALL LUMISYS code was the same , so i modified to be 1 IF instead of
      3 IF's exactly the same }
 //a/  If (Pos('LUMISYS', Uppercase(Scanmode)) > 0) Then
  If (CapX.mSourceID = mcSrcLumisys75) or (CapX.mSourceID = mcSrcLumisys150) Then
  Begin //dirx  + FileSave          , dirx  + FileSave
        //     if not LoadGear(GUserDir.Temp + tempfile + Format, GUserDir.Temp + tempfile + Format) then exit; {Timer1Timer}
        //   lumisys would need the .PIF files (.BAT) files modified.  we didn't do that, so use old dir
        //   this will cause problems at site if multiple Lumisys Scanners are being used over a Thinclient.
 //pre 129t11   If Not LoadGear(oldtempdir + tempfile + Format, oldtempdir + tempfile + Format) Then
//pre 129t11      Exit; {var format} {Timer1Timer}
{129t11 gek change old Temp Dir to new (win 7) temp dir.}
   If Not LoadGear(GUserDir.temp + tempfile + CapX.mFormat, GUserDir.temp + tempfile + CapX.mFormat) Then
     Exit; {var format} {Timer1Timer}


{ TODO -o129 : Lumisys scanning... do we still support it. ? }
{  emailed to Stu, Kathryn.... awaiting sites reply.}
  (* Lumisys....
    Gear 1.Gray := True;
    Gear 1.Update;
  *)
    WinMsg('', CapX.GetSourceDesc + ' : Scanning completed.');
    Screen.Cursor := crDefault;
    CaptureIsValid;      {Timer1Timer _ }
  End;

End;

Procedure TfrmCapMain.btnLookupdataclick(Sender: Tobject);
Begin
  WinMsg('d', 'You need to select an Association.');
    { when an Association data is initialized this ONClick call is changed to the
      call specific to the Association, if Association doesn't need a call then
      this Button isn't visible.}
End;

Procedure tfrmCapMain.loadlablists;
Var
  s: String[60];
Begin
  WinMsg('', 'Loading Lab Stains,Objectives lists.');
  XBROKERX.REMOTEPROCEDURE := 'MAGGLAB STAIN';
  CallBrokerX; //xBrokerx.Call;
  s := '';
  If Not BrokerError Then
  Begin
    s := 'Histological Stain list loaded,';
    WinMsg('', s);
    cbStain.Items := XBROKERX.Results;
  End;
  XBROKERX.REMOTEPROCEDURE := 'MAGGLAB MICRO';
  CallBrokerX; //xBrokerx.Call;
  If Not BrokerError Then
  Begin
    s := s + ' Microscopic Objective list loaded.';
    WinMsg('', s);
    cbMicro.Items := XBROKERX.Results;
  End;
End;

Procedure TfrmCapMain.SetMedProc(s: String);
Begin
  MedPtr := s;
End;

Function TfrmCapMain.FileTypeSupported2(Ext: String; Var Itype: String; Var idesc: String): Boolean;
//- FileTypeSupported - accepts an Image file name or just extension
//- returns - true/false and Image Type (FM ObjectType )
//- returns - sets value of Gear 1.saveformat
//- Param - ext - could be Full File Path including ext or just ext.

Var
    //xext, supportedtypes: string;
  i: Integer;
Begin
    // commented out, until we resolve the One Broker problem.
    //   we're building Params[0] as we go, and any broker call will destroy existing data.
    //    we get error No Data Sent....
    // This will go away when we switch to using the Import API.
     (* if iDModObj.GetMagDBBroker1.IsConnected then
        begin
        ext := uppercase(ext);
        if (pos('.', EXT) > 0) then ext := iDModObj.GetMagUtils1.dP(ext, '.', 2);
        result := iDModObj.GetMagDBBroker1.RPMag4GetFileFormatInfo(ext,xmsg);
        //        ;"Ext^Description^Imaging Viewer^Abs Bitmap^Abs Created"
        //        ;                            "|" IEN ^ NAME ^ Default Object Type [6P]
        //
        if not result  then exit;
        itype := iDModObj.GetMagUtils1.dP(xmsg,'^',7);
        idesc := iDModObj.GetMagUtils1.dP(xmsg,'^',2);
        exit;
        end; *)

{ We are here because  FExtensionlist.Count > 0 }
  Result := False;
  Itype := '0';
  Ext := Uppercase(Ext);
  If (Pos('.', Ext) > 0) Then
    Ext := MagPiece(Ext, '.', Maglength(Ext, '.'));
  For i := 0 To FExtensionlist.Count - 1 Do
  Begin
    If Uppercase(MagPiece(FExtensionlist[i], '^', 1)) = Uppercase(Ext) Then
    Begin
      Result := True;
      Itype := MagPiece(MagPiece(FExtensionlist[i], '|', 2), '^', 3);
      idesc := MagPiece(FExtensionlist[i], '^', 2);
      Break;
    End;
  End;
    // Files with these extensions can be imported.
    //  supportedtypes :=
    //',MPEG,MP3,MP4,MPG,ASC,AVI,DOC,HTM,HTML,MHTML,MHT,JPG,PDF,RTF,TGA,TIF,WAV,TXT,DCM,PAC,BIG,ABS,BW,756,BMP,';
End;

Function TfrmCapMain.FileTypeSupported(Ext: String; Var Itype: String; Var idesc: String): Boolean;
//- FileTypeSupported - accepts an Image file name or just extension
//- returns - true/false and Image Type (FM ObjectType )
//- returns - sets value of Gear 1.saveformat
//- Param - ext - could be Full File Path including ext or just ext.
{DONE: This call is doing work that it shouldn't .  setting Gear 1.SaveFormat.}

Var
  xext, supportedtypes: String;
Begin
  {p129  we cant' get list from VistA.   It is Pre patch p129.  and DCM, PDF, TXT are not viewable
  in capture }
 (* woas out for p129,  put back in in 140,   modified viewable type for DCM PDF TXT (hardcoded) *)
  if FExtensionlist.Count > 0 Then

  Begin
    Result := FileTypeSupported2(Ext, Itype, idesc);
   {/p117  this call isn't specific to an association, or Format.  it tells us if this
  format is supported via the file IMAGE FILE TYPES in VistA}

    { /p117 gek take out hard coded handling for one association
    If FrmCapConfig.TeleReaderConsult.Checked Then idesc:='DICOM(VL Photo Image Storage)';//p106 rlm 20101021 CR559
    }
    Exit;
  End;
EXIT;
//   WE will HARDCODE THE VIEWABLE SETTIGN FOR DCM PDF AND TXT IN FileTypeSupported2.
    // Files with these extensions can be imported.
    {TODO -oPost129 : Next patch,  should have a way to decide Supported Image types based on Patch.}
{ DONE -o129 : need to go by HardCoded list.  The List from VistA is based on ImageGear99}
//p129 out  supportedtypes := ',MPEG,MP3,MP4,MPG,ASC,AVI,DOC,HTM,HTML,MHTML,MHT,JPG,PDF,RTF,TGA,TIF,WAV,TXT,DCM,PAC,BIG,ABS,BW,756,BMP,';
{p129 This is the changed List of Supported Types.}
 //                  ',MPEG,MP3,MP4,MPG,ASC,AVI,DOC,HTM,HTML,MHTML,MHT,JPG,PDF,RTF,TGA,TIF,WAV,TXT,DCM,PAC,BIG,ABS,BW,756,BMP,';
 {p129 T9  took out DOC}
  supportedtypes := ',MPEG,MP3,MP4,MPG,ASC,AVI,HTM,HTML,MHTML,MHT,XML,JPG,PDF,RTF,TGA,TIF,WAV,TXT,DCM,PAC,BIG,ABS,BW,756,BMP,';

 (*  below doesn't get executed now *)
 (*    *************   DON'T DELETE YET

  Ext := Uppercase(Ext);
    // p8t25 Change test to maglength, file could include '.'
    //if (pos('.', EXT) > 0) then ext := magpiece(ext, '.', 2);
  If (Pos('.', Ext) > 0) Then
    Ext := MagPiece(Ext, '.', Maglength(Ext, '.'));
  xext := ',' + Ext + ',';
  Result := (Pos(xext, supportedtypes) > 0);
  Itype := '0';
{FTestScriptForceAccusoftErrors:  Flag that is set to True when user 'Test Team' checks their TestScript|ForceAccuError menu item.}
if ( (Not Result) and FTestScriptForceAccusoftErrors) then
  begin
    Result := true;
    EXT := 'ERR';   // fake extension
    Itype := '1';  //try to open in Full Res
    exit;
  end;

  If Result Then

  Begin
    idesc := Ext;
    If Ext = 'MPG' Then
      Itype := '21'
    Else
      If Ext = 'ASC' Then
        Itype := '103'
      Else
        If Ext = 'AVI' Then
          Itype := '21'
        Else
          If Ext = 'DOC' Then
            Itype := '102'
          Else
            If Ext = 'HTM' Then
              Itype := '101'
            Else
              If Ext = 'HTML' Then
                Itype := '101'
              Else
                If Ext = 'MHT' Then
                  Itype := '101'
                Else
                  If Ext = 'MHTML' Then
                    Itype := '101'
                //,MHT,MHTM,MHTML
                  Else
                    If Ext = 'PDF' Then
                      Itype := '104'
                    Else
                      If Ext = 'RTF' Then
                        Itype := '105'
                      Else
                        If Ext = 'WAV' Then
                          Itype := '106'
                        Else
                          If Ext = 'TXT' Then
                            Itype := '103'
                          Else
                            If Ext = 'DCM' Then
                              Itype := '100'
                            Else
                              If Ext = 'BIG' Then
                                Itype := '3'
                              Else
                                If Ext = 'PAC' Then
                                  Itype := '3'
                                Else
                                  If Ext = 'MP3' Then
                                    Itype := '21'
                                  Else
                                    If Ext = 'MP4' Then
                                      Itype := '21'
                                    Else
                                      If Ext = 'MPEG' Then
                                        Itype := '21'
                                      Else
                                        If Ext = 'JPG' Then
                                          Itype := '1'
                                        Else
                                          If Ext = '756' Then
                                            Itype := '1'
                                          Else
                                            If Ext = 'TIF' Then
                                              Itype := '15'
                                            Else
                                              If Ext = 'BMP' Then
                                                Itype := '1'
                                              Else
                                                If Ext = 'BW' Then
                                                  Itype := '3'
                                                Else
                                                  If Ext = 'ABS' Then
                                                    Itype := '1'
                                                Else
                                                  If Ext = 'XML' Then
                                                    Itype := '101'
                                                   // Itype := '107'
                                                  Else
                                                    If Ext = 'TGA' Then
                                                      Itype := '3';
  End;
*)
{ TODO -o129 : this was commented out Pre-129...  need to check to see why }
    (*
    magg msgf.mag msg('s','Switching SaveFormat:  Itype: ' + itype);
    AccusoftPropertiesLog('Before Switch: FileTypeSupported');
      case strtoint(itype) of
        0: gear 1.saveformat := IG_SAVE_UNKNOWN;
        1: gear 1.SaveFormat := IG_SAVE_JPG;
        3: gear 1.SaveFormat := IG_SAVE_TGA;
        15: gear 1.SaveFormat := IG_SAVE_TIF_G4;

      // If scanned image is modified, we need these settings
      //  so Gear1 will know what to save as.
      //  The other Itypes, don't get loaded into Gear, so
      //  can't be saved by Gear.
      end;
    AccusoftPropertiesLog('After Switch: FileTypeSupported');
      *)
End;

Function TfrmCapMain.GetAbsToShow(Image: String): String;
Var
  Ext: String;
  i: Integer;
Begin
{TODO -oGek : find this bmp}
  Result := AppPath + '\bmp\magabsgeneric.bmp';
  Ext := ExtractFileExt(Image);
  For i := 0 To FExtensionlist.Count - 1 Do
  Begin
    If Uppercase(MagPiece(FExtensionlist[i], '^', 1)) = Uppercase(Copy(Ext, 2, 99)) Then
    Begin
      Result := AppPath + '\bmp\' + MagPiece(FExtensionlist[i], '^', 4);
      Break;
    End;
  End;
End;

{DONE: Use FExtensionlist (it's from VistA to determine this.}
{       XX(0)="1^Okay"
        XX(1)="Ext^Description^Imaging Viewer^Abs Bitmap^Abs Created"
        XX(2)="TGA^Targa Image TGA^1^^1|1^TGA^1"
        XX(3)="TIF^Scanned Document TIF^1^^1|2^TIF^15" }

Function TfrmCapMain.ImageTypeNeedsAbs(Filename: String): Boolean;
Var
  xext, noabsfortypes, Ext: String;
  i: Integer;
  pGear : Tmag4VGear;
Begin
  Ext := Uppercase(ExtractFileExt(Filename));
  If (Pos('.', Ext) > 0) Then
    Ext := MagPiece(Ext, '.', 2);
(* p129,  out for now.  VistA function that populates FExtensionList is based on ImageGear 99
  If FExtensionlist.Count > 0 Then {This is compiled from an RPC Call.}
  Begin
    Result := False;
    For i := 0 To FExtensionlist.Count - 1 Do
    Begin
      If Uppercase(MagPiece(FExtensionlist[i], '^', 1)) = Uppercase(Ext) Then
      Begin
        Result := MagPiece(MagPiece(FExtensionlist[i], '|', 1), '^', 5) = '1';
        Break;
      End;
    End;
  End
  Else   *)
  Begin
    { TODO -o129 : p129 - didn't change the list yet.  We'll let this (abscreated) work as usual.}
    noabsfortypes := ',MPEG,MPG,MP3,MP4,ASC,AVI,DOC,HTM,HTML,MHTML,MHT,PDF,RTF,WAV,TXT,DCM,XML,';
    xext := ',' + Ext + ',';
    If (Pos(xext, noabsfortypes) > 0) Then
      Result := False
    Else
      Result := True;
  End;
    //{a) Patch 59, if DCM then ABSbyJB}
    //if (not result) and (ext = 'DCM') then ABSbyJB := true;
    {b) with Extension List from VistA.
        Patch 59 Special case DCM, we can't view it here yet.  so Result needs to be False
      but we need Abs, so set Queue by ABSbyJB = True;}
  If Ext = 'DCM' Then
  Begin
    ABSbyJB := True;
    Result := False;
  End;
    {Patch 59, if TGA and we get error, set like DCM and Continue.}
    {Problem with TGA was old Gear.  p129 Error Trap in make Abs function
       will change any problem  image to AbsByJB}

(*     on e:exception do
      Begin
      Result := False;
      ABSbyJB := True;
      End;
  *)
End;

Procedure TfrmCapMain.MakeAbs(ImageFilename, AbsFileName: String);
Var
  NewWidth, NewHeight: Integer;
  Factor1: Real;
  s: String;
Begin
  Try
    If AbsForImage Then
      s := ''
    Else
      s := 'NOT ';
    WinMsg('', s + 'Creating Abstract for image : ' + ImageFilename); {In MakeAbs}
        {need to check proportions now first}
    If Not ABSforImage Then
      Exit; // MakeAbs

    Try
            {         don't overwrite the abs if it exists}
      If Not FileExists(AbsFileName) Then {In MakeAbs}
      Begin
        AccusoftPropertiesLog('Before MakeABS');
                // MAKE THE ABSTRACT
        MakeThumbForImage(ImageFilename, AbsFileName, IGPageViewCtl1Thumb);

        If Not FileExists(AbsFileName) Then {In MakeAbs}
        Begin
          WinMsg('d', 'Image Abstract NOT Created.  Notify IRM');
        End
        Else
          WinMsg('', 'Image Abstract Created.');
      End
      Else
        WinMsg('', 'Image Abstract Copied.');
    Except
            //
    End;
  Finally
        //
  End;
End;


Procedure TfrmCapMain.Help1Click(Sender: Tobject);
Begin
  Application.HelpCommand(Help_Contents, 0);
End;

Procedure TfrmCapMain.mLoginClick(Sender: Tobject);
Begin
  If XBROKERX.Connected Then
    ImagingCaptureLogoff;
  If XBROKERX.Connected Then
    Exit;
    //ListenerPort :  integer;
    //  LocalServer : string;
  ImagingCaptureLogin(LocalServer, Inttostr(ListenerPort), True);          {mLoginClick}
End;

Procedure TfrmCapMain.ImagingCaptureLogin(Vserver, Vport: String; Forcethisconnection: Boolean);
Var
  TMsg, Minutes: String;
  i, Startmode: Integer;
  Stat, Remotechoice: Boolean;

  loginrslt: TStrings;
  CPFlag: String;
  Rmsg: String;

  SiteAnnotInfo : String;
Begin
  // xBrokerx.destroy;
  // Createbroker(self);
  // iDModObj.GetMagDBBroker1.SetBroker(xBrokerx);

  loginrslt := Tstringlist.Create;
  Try
    UserCapDUZ := '0';
    SecurityKeys.Clear;
    MagPatMenu.ClearAll;
    FExtensionlist.Clear;
    userCapname := '';
    Remotechoice := True;
    If Forcethisconnection Then
      Remotechoice := False;
    If ((Vserver = '') Or (Vport = '')) Then
    Begin
      Vserver := LocalServer;
      Vport := Inttostr(ListenerPort);
    End;
    WinMsg('', 'Connecting to VistA...');
    idmodobj.GetCCOWManager.LoginComplete := false;  //129t13  magCCOW Mgr uses this.

    If Not BrokerConnect(Vserver, Vport, Remotechoice, TMsg) Then
    Begin
      WinMsg('', TMsg);
      UpdateWindowcaption;
      Exit;
    End;
    XBROKERX.CreateContext('MAG WINDOWS');
    Application.Processmessages;
    //p8t29
    //iDModObj.GetMagDBBroker1.Broker := xBrokerx;
    iDModObj.GetMagDBBroker1.SetBroker(XBROKERX);
    iDModObj.GetMagUtilsDB1.MagPat := iDModObj.GetMagPat1;
    //p8t29
    //Vserver := iDModObj.GetMagDBBroker1.Broker.Server;
    Vserver := iDModObj.GetMagDBBroker1.GetServer;
    CheckImagingVersion(MagappCapture, iDModObj.GetMagDBBroker1);
    If Application.Terminated Then
      Exit;

    {/p117 gek 1-17-11,  remedy ticket 426919 and 392150
            JPG of patient photo in user network folder}
    MagImageManager1.CacheDirectory := GUserDir.Cache  ;
    //  iDModObj.GetMagDBBroker1.RPMaggUser2(stat, Loginrslt, WSID, vserver, vport);
    iDModObj.GetMagDBBroker1.RPMaggUser2(Stat, Rmsg, Loginrslt, Wsid, GSess); // vserver, vport);

    { oot 6/29/02 xBrokerx.param[0].ptype := literal;
    xBrokerx.param[0].value := WSID;
    xBrokerx.remoteprocedure := 'MAGGUSER2';
    xBrokerx.lstcall(loginrslt); }
    If Not Stat Then
    Begin
      WinMsg('', MagPiece(loginrslt[0], '^', 2));
      Exit
    End;
    magappmsg('s','PRODUCTION ACCOUNT :  IsProdAccount Flag : ' +  Loginrslt[8] + '  ' + magbooltostr(magstrtobool(Loginrslt[8])));
    idmodobj.GetCCOWManager.IsProdAccount := Magstrtobool(Loginrslt[8]);
    FisProdAccount := Magstrtobool(Loginrslt[8]);

    UserCapDUZ := MagPiece(loginrslt[1], '^', 1);
    {//P122 DMMN 6/28/2011 get the primary site station number to store in annotation xml/}
    //PrimarySiteStationNumber := loginrslt[12] ;         //p122 dmmn WPR Capture Item #11
    {THIS PrimarySiteStationNumber was Commented out in 122. but needed for CCOW}
    PrimarySiteStationNumber := loginrslt[12] ;       {/gek 129T5  }

    // Patch 8
    If Not iDModObj.GetMagFileSecurity.SetNetUsernamePassword(loginrslt[2], TMsg) Then
      WinMsg('de', TMsg);

    (*iDModObj.GetMagFileSecurity.Username := magpiece(xBrokerx.RESULTS[2],'^',1);
    iDModObj.GetMagFileSecurity.Password := decrypt(magpiece(xBrokerx.RESULTS[2],'^',2));*)

    {   [4] = IMAGE SITE PARAM IEN ^ SITECODE ^ USER INSTITUTION (DUZ(2) ^ SITE PARAM -INSTITUTION NAME
                ^  Consolidated True/False   ^ STATION NUMBER
                   1  2   3        4        5  6
          example  1^SLC^660^SALT LAKE CITY^1^660      }
    Try
    { TODO -oGarrett : The Gsess TSession object was meant to be populated in the MagDBMVista...
               So it's the same for each appp.   not each  application setting only what they
               need...   like documented below.  Some Deveoplers didnt' realize that, and set
        different properties of Gsess in differnet appls.   Needs back to the intended way}

            (* p93t10  Now set in DBMVista, when the RPC Call is made
            GSess.WrksPlaceIEN :=  magpiece(loginrslt[4], '^', 1);
            GSess.WrksPlaceCODE := magpiece(loginrslt[4], '^', 2) ;
            GSess.WrksInst := magpiece(loginrslt[4], '^', 3) ;
            GSess.WrksConsolidated := magstrtobool(magpiece(loginrslt[4], '^', 5));
            GSess.WrksInstStationNumber := magpiece(loginrslt[4], '^', 6) ;
            *)

      lbsitecode.caption := GSess.WrksPlaceCODE;
      lbsitecode.Hint := 'Institution: ' + Gsess.Wrksinst.Name + ' (' + GSess.WrksPlaceCODE + ')';
      WinMsg('s', 'IMAGING SITE PARAMETER: ' + GSess.WrksPlaceIEN + ' Site Code: ' + GSess.WrksPlaceCODE);
      WinMsg('s', 'IMAGING SITE PARAMETER Institution: ' + GSess.Wrksinst.Name);
      WinMsg('s', 'DUZ(2): ' + GSess.Wrksinst.ID);
      For i := 5 To loginrslt.Count - 1 Do
        WinMsg('s', loginrslt[i]);
    Except
      On Exception Do
      Begin
        GSess.Clear;
        GSess.WrksPlaceCODE := 'Unk';
        Messagedlg('The System could not resolve the Users Division' + #13 +
          ' into an Imaging Site Parameter.' + #13 +
          ' Image Capture is Disabled.  Call IRM !!.', Mtconfirmation,
          [Mbok], 0);
      End;
    End;

    If UserCapDUZ = '0' Then
    Begin
      TMsg := MagPiece(loginrslt[1], '^', 2) + ' Disconnecting from VistA';
      XBROKERX.Connected := False;
    End
    Else
    Begin
      UserCapName := MagPiece(loginrslt[1], '^', 2);
      UpdateWindowcaption;
      GetUserCapPref;
      //NOT NEEDED  Req.Text := Username;
      TMsg := UserCapName + ': ' + Vserver + ' connection OK. ';

      Try
        cpflag := loginrslt[5];
        EnableCPFunctionsCAP(Strtoint(MagPiece(cpflag, '^', 1)) > 0);
      Except
                // maggtup not up to date.
      End;

      GetIndexLists; //patch 8
      SecurityKeys.Clear;
      RPMaggUserKeys(SecurityKeys);
      For i := 0 To SecurityKeys.Count - 1 Do
        WinMsg('s', SecurityKeys[i]);
      SetUserAssociations;

      If (capRunMode = magrmCPRS) Then   {ImagingCaptureLogin}
        Startmode := 2
      Else
        Startmode := 1;
            //ImagingCaptureLogin
      RPMaggWrksUpdate(AppPath, '', Application.ExeName, WrksCompName, WrksLocation, LastMagUpdate, Startmode);
      (*  This was in Consolidated, but causing errors here. out for now.
      if (loginrslt.count > 5) then
       begin
        RPMagLogErrorText(loginrslt,loginrslt.count);
       end;*)
      SetDefaultAssociation(FdftAssoc);
      If (WorkStationTimeout = 0) Then
        RPMaggGetTimeout('CAPTURE', Minutes);
      If Minutes <> '' Then
        MagTimeoutform.SetApplicationTimeOut(Minutes, TimeoutTimer);
      RPGetFileExtensions(FExtensionlist);
    End;

    {/p129  end of Gsess additions from Display.  }
    { TODO -oGarrett : The Gsess TSession object was meant to be populated in the MagDBMVista...  not each
     application.  Needs back to the intended way}
    {/ P122 - JK 7/5/2011 - add more info to the GSess object. /}
    GSess.UserName := MagPiece(loginrslt[1], '^', 2);
    GSess.UserDUZ  := MagPiece(loginrslt[1], '^', 1);
    GSess.UserService := idmodobj.GetMagDBMVista1.GetBroker.User.ServiceSection;
    GSess.HasLocalAnnotatePermission := idmodobj.GetMagDBBroker1.RPKernelAnnotatePermission;
    GSess.HasLocalAnnotateMasterKey := UserHasKey('MAG ANNOTATE MGR');  // p129t19 dmmn - also check for master key permission here
    SiteAnnotInfo := GSess.WrksPlaceCODE + '~' + GSess.WrksInstStationNumber + '~' + VServer + ':' + VPort;

    if GSess.HasLocalAnnotatePermission then
//      GSess.SiteAnnotationInfo.Add(GSess.WrksPlaceCODE + '~' + GSess.WrksInstStationNumber + '~' + VServer + ':' + VPort + '~Y')    //p122t6 dmmn 10/14 - add station number for local
      SiteAnnotInfo := SiteAnnotInfo + '~Y'
    else
//      GSess.SiteAnnotationInfo.Add(GSess.WrksPlaceCODE + '~' + GSess.WrksInstStationNumber + '~' + VServer + ':' + VPort + '~N');
      SiteAnnotInfo := SiteAnnotInfo + '~N';

    //p129t19 dmmn add missing piece for master key permission
    if GSess.HasLocalAnnotateMasterKey then
      SiteAnnotInfo := SiteAnnotInfo + '~Y'
    else
      SiteAnnotInfo := SiteAnnotInfo + '~N';

    GSess.SiteAnnotationInfo.Add(SiteAnnotInfo);
    {/p129  end of Gsess additions from Display.  }

    WinMsg('', TMsg);
    Show;
    EnableKeyDependentObjects;
        // quick fix, if photo id is default, we need to reclick it after we login , so that
        // a default date will display.
    If (Magassoc = 'PHOTOID') Then
      InitPhotoID;

    {Seperate code for Annotations enable}
    AnnotationsEnableForSessionCompute;         {brk-1}

    {/ P123 - JK 8/8/2011 - Check what type of backend we're connected to: VA or IHS /}
    {/p122 dmmn WPR Capture Item #12 /}
    GSess.Agency.AgencyID := iDModObj.GetMagDBBroker1.RPMaggAgency;
    MagAppMsg('s', 'Agency is ' + GSess.Agency.AgencyName);

    {/ P122 - JK 8/30/2011 /}
    CheckForAnnotationFontResource;
    ///
    idmodobj.GetCCOWManager.LoginComplete := True; //gek p129t13  CCOW managment.
    idmodobj.GetCCOWManager.ResumeGetContext();  //gek p129t13  CCOW managment.
  Finally
    UpdateWindowcaption;
    loginrslt.Free;
  End;
End;

{129 T9   gek.  Enable / Disable for individule Image formats... i.e. TXT ASC.
                that we are not allowing to annotate.
                if User can't annotate, then buttons are made invisible  and we exit;

               if user can annotate
                 then Annotate button  is visible,  Close button Hidden
                and enable disable the Annotate button for this image.
               }

procedure TfrmCapMain.AnnotationsEnableforImage(value : boolean);
begin
  {p129t10 gek fix design of determining if user can annotate.}
  {if can't annotate for session,  just quit.}
  if  not (Gsess.HasLocalAnnotatePermission or Gsess.HasLocalAnnotateMasterKey) then
     begin
       AnnotationsEnableForSession(false);
       exit;
     end;
 {here, user can Annotate, so enable/disable the Annotate button for image, based on 'Value'}
   if tlbrbtnAnnotationclose.visible  then   tlbrbtnAnnotationclose.visible := false;
   if not tlbrbtnAnnotation.Visible then  tlbrbtnAnnotation.Visible := true;
   tlbrbtnAnnotation.Enabled := value;

end;


procedure TfrmCapMain.AnnotationsEnableForSession(value : boolean);
begin
      tlbrbtnAnnotation.Visible := value;
      tlbrbtnAnnotationClose.Visible := false;
      mnuAnnotationSettings1.Visible := value;
end;



procedure TfrmCapMain.AnnotationsEnableForSessionCompute;
begin
     {/P122 dmmn 7/12/11 add a kernel check to see if the user can annotate. If
    the return is false then annotation button will be hidden /}
    {/p122 dmmn 9/6/11 add user manager key check to match display /}
    if (not GSess.HasLocalAnnotatePermission) and (not UserHasKey('MAG ANNOTATE MGR')) then
    begin
      {/p122 dmmn 8/16/11 - close existing annotations if the user doesnt have
      rights after loging in after a timeout /}
      AnnotationsClose(); //  if fCapAnnot.Visible = True then    fCapAnnot.Close;
{ DONE -o129 : make function for hiding/showing Annotation controls.
       should tie into  EnableKeyDependentObjects.}

      AnnotationsEnableForSession(false);  {gek 129T9 function, instead of set from multiple places.}
              // tlbrbtnAnnotation.Visible := False;
              // tlbrbtnAnnotationClose.Visible := false;
              // mnuAnnotationSettings1.Visible := False; //p122 dmmn 7/28 - hide options if cannot annotate

//RCA (and T10) OUT     TrueBoolStrs[0] := 'True';
//RCA (and T10) OUT      FalseBoolStrs[0] := 'False';
      MagAppMsg('', 'User doesn''t have permission to annotate.');      //p122t6 dmmn
      MagAppMsg('s','Annotation functions are hidden.' );
 //(t10)     MagAppMsg('s','Kernel Permission: ' + BoolToStr(iDModObj.GetMagDBBroker1.RPKernelAnnotatePermission,true));
 //(t10)     MagAppMsg('s','Has Master Key: ' + BoolToStr(UserHasKey('MAG ANNOTATE MGR'),true));
      //p122t7 dmmn - changes to use VistA defined functions
      MagAppMsg('s','Kernel Permission: ' + MagBoolToStr(GSess.HasLocalAnnotatePermission));
      MagAppMsg('s','Has Master Key: ' + MagBoolToStr(UserHasKey('MAG ANNOTATE MGR')));
    end
    else
    begin
      AnnotationsEnableForSession(true);  {gek 129T9 function, instead of set from multiple places.}
              //tlbrbtnAnnotation.Visible := True;
              //tlbrbtnAnnotationClose.visible := false;
              //mnuAnnotationSettings1.Visible := True;

//RCA (and T10) OUT       TrueBoolStrs[0] := 'True';
//RCA (and T10) OUT       FalseBoolStrs[0] := 'False';
      MagAppMsg('', 'User has permission to annotate.');      //p122t6 dmmn
      MagAppMsg('s','Annotation functions are visible.' );
 //(t10)     MagAppMsg('s','Kernel Permission: ' + BoolToStr(iDModObj.GetMagDBBroker1.RPKernelAnnotatePermission,true));
//(t10)      MagAppMsg('s','Has Master Key: ' + BoolToStr(UserHasKey('MAG ANNOTATE MGR'),true));
      //p122t7 dmmn - changes to use VistA defined functions
      MagAppMsg('s','Kernel Permission: ' + MagBoolToStr(GSess.HasLocalAnnotatePermission));
      MagAppMsg('s','Has Master Key: ' + MagBoolToStr(UserHasKey('MAG ANNOTATE MGR')));
    end;

end;

Procedure TfrmCapMain.SetUserAssociations;
Var
  editkey: Boolean;

Begin
    {  this is called once, After user logon, and before Setting Default Association.
      it will disable any association the user doesn't have a key for. }

        {   //93 QA Functions aren't dependent on the 'CAPTURE KEYS ON/OFF}
  editkey := Userhaskey('MAG EDIT') Or Userhaskey('MAG SYSTEM');

  If (SecurityKeys.Indexof('CAPTURE KEYS OFF') > -1) Then
    Exit;
  If FModeTest Then
    Exit;

  With FrmCapConfig Do
  Begin
    If (SecurityKeys.Indexof('MAG CAPTURE') = -1) Then ClinImage.Enabled := False;
    If (SecurityKeys.Indexof('MAGCAP ADMIN') = -1) Then AdminDoc.Enabled := False; //WPR KEY
    If (SecurityKeys.Indexof('MAGCAP CP') = -1) Then ClinProc.Enabled := False;
    If (SecurityKeys.Indexof('MAGCAP LAB') = -1) Then Laboratory.Enabled := False;
    If (SecurityKeys.Indexof('MAGCAP MED') = -1) Then Medicine.Enabled := False;
    If (SecurityKeys.Indexof('MAGCAP PHOTOID') = -1) Then PhotoID.Enabled := False;
    If (SecurityKeys.Indexof('MAGCAP RAD') = -1) Then Radiology.Enabled := False;
    If (SecurityKeys.Indexof('MAGCAP SUR') = -1) Then Surgery.Enabled := False;
    If (SecurityKeys.Indexof('MAGCAP TIU') = -1) Then Tiu.Enabled := False;
    If (SecurityKeys.Indexof('MAGCAP TRC') = -1) Then TeleReaderConsult.Enabled := False; //p106 rlm 20101228 CR646 "Use Capture Keys feature not updated"

  End;

End;

Procedure TfrmCapMain.EnableCPFunctionsCAP(isCPInstalled: Boolean);
Var
  capkeyindex: Integer;
  addedCaptureKEy: Boolean;
Begin
  addedCaptureKey := False;
  capkeyindex := -1;
  FisCPInstalled := isCPInstalled;
  FrmCapConfig.ClinProc.Visible := isCPInstalled;
  If (Not isCPInstalled) And (FrmCapConfig.ClinProc.Checked) Then
  Begin
    If (Not Userhaskey('MAG CAPTURE')) Then
    Begin
            // add it , so we can change from CP

      AddDelKey('MAG CAPTURE', True);
      capkeyindex := SecurityKeys.Count - 1;
      addedCaptureKey := True;
    End;

    FrmCapConfig.ClinProc.Checked := False;
    SetDefaultAssociation('CLINIMAGE');
  End;
    //  if (capkeyindex <> -1) then SecurityKeys.Delete(capkeyindex);
  If addedCaptureKey Then
    AddDelKey('MAG CAPTURE', False);
End;

Procedure TfrmCapMain.MLogoutClick(Sender: Tobject);
Begin
  ImagingCaptureLogoff;
End;

Procedure TfrmCapMain.ImagingCaptureLogoff;
Var
  s: String;
Begin
  If Not IsStudyGroupComplete Then
    Exit;
  If Not (XBROKERX.Connected) Then
    WinMsg('d', 'Connection to VistA is not Active')
  Else
  Begin
    s := 'You are connected to: ' + XBROKERX.Server + #13 + 'Do you want to Logout of VistA. ?';
    If Messagedlg(s, Mtconfirmation, [MbYes, MbNo], 0) = MrNo Then
      Exit;
  End;
  If FSaveUserSettingsOnExit Then
    SetUserCapPref;
  RPMaggLogOff(XBROKERX);
     {  8-8-00 GEK  The list of allowable Medicine procedure for a user wasn't
        being reloaded if different user logs on.  So we clear the list at logoff,
        this will force a reloading of the list when the medicine window is reopened. } 
  MAGGMCF.ListBox1.Clear;

  If Not Application.Terminated Then
    XBROKERX.Connected := False;

    //o iDModObj.GetMagDBBroker1.CreateBroker; //p59
    //o xBrokerx := iDModObj.GetMagDBBroker1.GetBroker;    //p59

    //o2  Createbroker(self);
    //o2 {RPCBremote.connected:= false;}
  iDModObj.GetMagPat1.Clear;
  MagPatMenu.ClearAll;
  WinMsg('', userCapname + ' Logout:  VistA disconnected');
  UserCapDUZ := '0';
  UserCapName := '';
  UpdateWindowcaption;
  SecurityKeys.Clear;
  NewStudy(True); //{in ImagingCaptureLogoff}
  ClearIndexFields(True);
  DisableKeyDependentObjects;

  {/p122 dmmn 8/1 - hide options related to annotation when user logout /}
  {gek/ 129 t 9 make function.  These properties are set from different places.}
  AnnotationsEnableForSession(false);

  FAnnotInitForImage := false;    //p129t19 dmmn 6/17/13 - once the user has logged out, clear this flag so the
                                  //application will have to reinitialized the annotation component in case of
                                  //the use logged out and login again instead of quitting the application
  GSess.SiteAnnotationInfo.Clear;

End;

Procedure TfrmCapMain.Exit1Click(Sender: Tobject);
Begin
  Application.Processmessages;
  Close;
End;

Procedure TfrmCapMain.FormCloseQuery(Sender: Tobject; Var CanClose: Boolean);
Begin
  CanClose := False;
  If Not (XBROKERX.Connected) Or timerclose Then
  Begin
    CanClose := True;
    Exit;
  End;
  If Not IsStudyGroupComplete Then
    Exit;
  If Not (XBROKERX.Connected) Then
    CanClose := True
  Else
    CanClose := True;
    // take out Logout Dialog box, causes problems with CPRS.
    (*else if (messagedlg('Logout of VistA, are you sure. ?....... *)
End;

Procedure TfrmCapMain.Contents1Click(Sender: Tobject);
Begin
    {Application.Helpfile:='capture.hlp';}{197}
  Application.HelpContext(0);
    // Application.HelpCommand(HELP_CONTENTS, 0);
End;

Procedure TfrmCapMain.MnuAboutClick(Sender: Tobject);
Var
  Rstat: Boolean;
  Rlist: Tstringlist;
  Magver, Vstat: String;
Begin
  Rlist := Tstringlist.Create;
  Try
    iDModObj.GetMagDBBroker1.RPMaggInstall(Rstat, Rlist);
    Magver := MagGetFileVersionInfo(Application.ExeName);
    iDModObj.GetMagDBBroker1.RPMagVersionStatus(Vstat, Magver);
    FrmAbout.Execute('', '', Rlist, MagPiece(Vstat, '^', 2));
  Finally
    Rlist.Free;
  End;
End;


(*
TAG property of the radiobutton controls is set in Design phase.

  magcfgFormat : integer = 51 ;
  magcfgSource : integer = 50 ;
  magcfgAssociation : integer = 50 ;
  magcfgMode : integer = 50 ;
  magcfgSaveAs : integer = 50 ;
  magcfgMultipleSource : integer = 50 ;
  magcfgPDFConvert : integer = 50 ;
*)

Procedure TfrmCapMain.SetDefaultInputSource(dftinputsource: String);
Var
  i: Integer;
   magtag : integer;
Begin
magtag := magcfgSource;
   { p117 the lbInputSourceDesc.caption is set only when the InputSource RadioButton
        is checked,  this way we know which input source has been checked. or Selected
        from a configuration.  gek -> Take this back out    LbInputSourceDesc.caption := Nullsetting; }//p106 rlm 20101228 CR606

  If Uppercase(dftinputsource) = 'NONE'
       Then  dftinputsource := 'Import';
    {set the default input type from ini file}
    {inputtype as a string should match the name of the radiobutton}
  With FrmCapConfig Do
  Begin
    FrmCapConfig.DisableAllFormats; // 8/29/00 gek

    if FCapdevTest then for I := 0 to frmCapConfig.ComponentCount - 1 do   magappmsg('','Components  : ' + frmCapConfig.Components[i].Name + '   TAG: ' + inttostr(frmCapConfig.Components[i].tag));

    For i := 0 To ComponentCount - 1 Do
    Begin
      if Components[i].Tag = magtag then
      If Uppercase(Components[i].Name) = Uppercase(dftinputsource) Then
      Begin
        magappmsg('s', 'Component Found : '  + Components[i].Name + ' = ' +  dftinputsource);
        If Not TRadioButton(Components[i]).Enabled Then
          TRadioButton(Components[i]).Enabled := True;
        Begin
          {if a button was already checked.  then this wouldn't fire the
                      event, so uncheck it first.}
          If TRadioButton(Components[i]).Checked
             Then TRadioButton(Components[i]).Checked := False;
          TRadioButton(Components[i]).Checked := True;
        //p117 out, same as above:  lbInputSourceDesc is set only when the RadioButton is checked,
        //p117 LbInputSourceDesc.caption := TRadioButton(GInputSource.Controls[i]).caption; //p106 rlm 20101228 CR606
        End;
        Break;
      End;
    End;
  End; {with frmCapConfig do }

End;

Procedure TfrmCapMain.SetDefaultImageFormat(DFTimageFormat: String);
var
   magtag : integer;
Begin
magtag := magcfgFormat;

  If Uppercase(DFTimageFormat) = 'NONE' Then  DFTImageFormat := 'Document TIF G4 FAX';

  With FrmCapConfig Do
  Begin
    If (DFTimageFormat = 'True Color JPG') Then
    Begin
      If Not IniFormat.TCJPG Then
        IniFormat.TCJPG := True;
      If Not TrueColorJPG.Enabled Then
        TrueColorJPG.Enabled := True;
      If TrueColorJPG.Checked Then
        TrueColorJPG.Checked := False;
      TrueColorJPG.Checked := True;
      Exit;
    End;

    If (DFTimageFormat = 'Document TIF G4 FAX') Then
    Begin
      If Not IniFormat.TIFG4 Then
        IniFormat.TIFG4 := True;
      If Not DocumentG4.Enabled Then
        DocumentG4.Enabled := True;
      If DocumentG4.Checked Then
        DocumentG4.Checked := False;
      DocumentG4.Checked := True;
      Exit;
    End;

    If (DFTimageFormat = 'Xray') Then
    Begin
      If Not IniFormat.x Then
        IniFormat.x := True;
      If Not Xray.Enabled Then
        Xray.Enabled := True;
      If Xray.Checked Then
        Xray.Checked := False;
      Xray.Checked := True;
      Exit;
    End;

    If (DFTimageFormat = 'Xray JPG') Then
    Begin
      If Not IniFormat.XJPG Then
        IniFormat.XJPG := True;
      If Not XrayJPG.Enabled Then
        XrayJPG.Enabled := True;
      If XrayJPG.Checked Then
        XrayJPG.Checked := False;
      XrayJPG.Checked := True;
      Exit;
    End;

    If (DFTimageFormat = 'True Color TGA') Then
    Begin
      If Not IniFormat.TCTGA Then
        IniFormat.TCTGA := True;
      If Not Color.Enabled Then
        Color.Enabled := True;
      If Color.Checked Then
        Color.Checked := False;
      Color.Checked := True;
      Exit;
    End;

    If (DFTimageFormat = 'Black and White') Then
    Begin
      If Not IniFormat.bw Then
        IniFormat.bw := True;
      If Not BlackAndWhite.Enabled Then
        BlackAndWhite.Enabled := True;
      If BlackAndWhite.Checked Then
        BlackAndWhite.Checked := False;
      BlackAndWhite.Checked := True;
      Exit;
    End;

    If (DFTimageFormat = 'Document TIF Uncompressed') Then
    Begin
      If Not IniFormat.TIFUN Then
        IniFormat.TIFUN := True;
      If Not Document.Enabled Then
        Document.Enabled := True;
      If Document.Checked Then
        Document.Checked := False;
      Document.Checked := True;
      Exit;
    End;

    If (DFTimageFormat = 'Bitmap') Then
    Begin
      If Not IniFormat.BMP Then
        IniFormat.BMP := True;
      If Not Bitmap.Enabled Then
        Bitmap.Enabled := True;
      If Bitmap.Checked Then
        Bitmap.Checked := False;
      Bitmap.Checked := True;
      Exit;
    End;

    If (DFTimageFormat = '256 Color') And IniColorscan256 Then
    Begin
      If Not IniFormat.C256 Then
        IniFormat.C256 := True;
      If Not ColorScan.Enabled Then
        ColorScan.Enabled := True;
      If ColorScan.Checked Then
        ColorScan.Checked := False;
      ColorScan.Checked := True;
      Exit;
    End;
    //p106 rlm 20101230 CR644 "TRC Workstation Defaults" START
    If (DFTimageFormat = 'DICOM') Then
    Begin
      If Not IniFormat.DICOM Then
        IniFormat.DICOM := True;
      If Not DICOMFormat.Enabled Then
        DICOMFormat.Enabled := True;
      If DICOMFormat.Checked Then
        DICOMFormat.Checked := False;
      DICOMFormat.Checked := True;
      Exit;
    End;
    //p106 rlm 20101230 CR644 "TRC Workstation Defaults" END

  End; {with frmCapConfig do }
End;

Procedure TfrmCapMain.SetDefaultAssociation(dftAssociation: String);
Var
  i: Integer;
  backtoDisabled: Boolean;
  Tst: String;
   magtag : integer;
Begin
magtag := magcfgAssociation;

  backtoDisabled := False;
    {set the default Association from ini file}
    {Association as a string won't match the radiobutton name LATER need to change ConfigFile file entries
       to match then radiobutton name}
  If dftAssociation = '' Then
    dftAssociation := 'CLINIMAGE';
  dftAssociation := Uppercase(dftAssociation);
  If dftAssociation = 'SUR' Then
    dftAssociation := 'surgery';
  If dftAssociation = 'PHOTOID' Then
    dftAssociation := 'PhotoID';
  If dftAssociation = 'LAB' Then
    dftAssociation := 'laboratory';
  If dftAssociation = 'RAD' Then
    dftAssociation := 'radiology';
  If dftAssociation = 'MED' Then
    dftAssociation := 'medicine';
  If dftAssociation = 'NOTES' Then
    dftAssociation := 'tiu';
    //CLINPROC    added 12/04/2001
  If dftAssociation = 'CLINPROC' Then
    dftAssociation := 'ClinProc';
  If dftAssociation = 'TRCONSULT' Then
{ DONE -o117 : Garrett NEED TO CHECK THE RENAMING OF THIS dftAssociation.  DOES IT
       AFFECT ANYTHING ?.  Answer :  So far so good.  p117}
    //dftAssociation := 'TRConsult';      //p106 rlm 20101230 CR644 "TRC Workstation Defaults"
    dftAssociation := 'TeleReaderConsult';//p106 rlm 20101230 CR644 "TRC Workstation Defaults"

    //ADMINDOC               12/04/2001
  If dftAssociation = 'ADMINDOC' Then
    dftAssociation := 'AdminDoc';
  If dftAssociation = 'CLINIMAGE' Then
    dftAssociation := 'ClinImage';

  With FrmCapConfig Do
  Begin
    For i := 0 To ComponentCount - 1 Do
    Begin
      if Components[i].tag = magtag then
      
      Tst := Components[i].Name;
      If Uppercase(Components[i].Name) = Uppercase(dftAssociation) Then
      Begin
                {    The radiobutton is enabled/disabled before this call based on
                     ini settings and User Security Keys}
        If Not TRadioButton(Components[i]).Enabled Then
        Begin
          TRadioButton(Components[i]).Enabled := True;
          backtoDisabled := True;
        End;
                {     force the OnClick event for the radiobutton.}
        If TRadioButton(Components[i]).Checked Then
          TRadioButton(Components[i]).Checked := False;
        TRadioButton(Components[i]).Checked := True;
        If backtodisabled Then
          TRadioButton(Components[i]).Enabled := False;
        Break;
      End;
    End;
  End; {with frmCapConfig do }
End;

Procedure TfrmCapMain.DragAndDropFiles(Value: Boolean);
Begin
    //>>>draganddropfiles
    //
    // tell Windows that you're
    // accepting drag and drop files
    //
  DragAcceptFiles(Handle, Value);
    //<<<draganddropfiles
End;

Procedure TfrmCapMain.FormCreate(Sender: Tobject);
Var
  writeimmediate: Boolean;
  strval: String;
  ApplicationDataFolder: String;
  Rmsg: String;
Begin
{   ********************  p140 additions}

CapX := TCapConfigObj.Create;
CapX.m140RLE := true;
CapX.m140JPG := false;

{-------------------------}
pnlNoteGlyph.Parent := sbxEditFields;
pnlSwitchPatientsWarn.Parent := sbxEditFields;
pnllstImport.parent := frmCapMain;
lvSpecSubSpec.parent := frmCapMain;
lvProcEvent.parent := frmCapMain;
lvType.parent := frmCapMain;
// G140Test := false;

{   ********************  p140 Additions End;}

 FIsProdAccount := false;

CapDFN := '';  {/gek 129t5  try new DFN control variable for CCOW sync.}
SetCapRunMode(magrmAlone) ; {;129T13  default to StandAlone mode.
                             now check parameters for magrmCPRS
                             and check CCOW
                             and If}
 // MagCapSubscriber := TMagSubscriber.Create(self);
//  MagCapSubscriber.OnSubscriberUpdate := MagCapSubscriberUpdate;
  GMagPublish := TMagPublisher.Create(self);
  MagSubscriber1.Publisher := GMagPublish;

  pnlCCOW.ParentBackground := true;
    {94 had this    GSess := TSession.Create;}
  If GSess = Nil Then GSess := TSession.Create;
  FControlledImage := False;
  GSess.WrksInstStationNumber := ''; {//p93t8 gek  Stored in TXT file.}
  GSess.SkipColorChannel  := true;  {SkipColorChannel   129T10 Gek/dmmn}
  GSess.IsCaptureSession := true;
//GSess.AnnotationTempDir :=

CreateGearComponent; {JK 6/27/2012 - create a gear at startup}


mgPatImage := TMag4VGear.Create(self, '', MagGearAbilityRadiology);
mgPatImage.Parent := pnlGearPat;
mgPatImage.AnnotationComponent.CaptureNewImage := true;

mgPatImage.ShowImageOnly := true;
mgPatImage.Align := alclient;
mgPatImage.SelectionWidth := 1;
mgPatImage.MouseReSet;
///mgPatImage.SetSkipColorChannel(true);
imgcanned.Align := alclient;

pnlGearCanned.BevelOuter := bvNone;
{/p129  Create new TMagTwain Control for 129 Twain functions}
MagTwain1 := TmagTwain.create();
MagTwain1.InitTwainControls(self as TWinControl);

 MagCapMsg := TMagAppMessageLog.create();
  {RCA see if dmod is created yet.}
//  ImagDMinterface.idModObj := dmod;   //RCA dmod is not created yet...
  {RCA we'll do this in the OnPaint event}

  ImagInterfaces.IMsgObj := MagCapMsg; // Self;   //RCA

  pnlDicomByUser.ParentColor := true; //p117

  TabSeqList := Tstringlist.Create;
  FDicomdataArray := Tstringlist.Create;
  FDicomDataUserArray := Tstringlist.Create;
  FDicomDefaultsArray := Tstringlist.Create;

  strval := GetIniEntry('Workstation settings', 'writeimmediate');
  writeimmediate := (Uppercase(strval) = 'TRUE');

  {/ P122T10 JK 11/21/2011 - moved from FormPaint /}
  If (Uppercase(GetIniEntry('Workstation settings', 'AllowMultipleInstances')) <> 'TRUE') Then
    If DoIExist('Vista Imaging Capture') Then
    Begin
      Frmcapmain.Hide;
      Application.Processmessages;
      Messagedlg('"VistA Imaging Capture" is already running. ' + #13 + #13 + 'A second instance will not be started.', Mtconfirmation, [Mbok], 0);
      {/ P122 - JK 11/21/2011 - Get rid of Halt and Exit.  Application.Terminate will do the same but it will work better
         with the shutdown logic throughout Clinical Capture.  In cMagLVutils.Destroy it was looking for Application.Terminate=true.
         Halt did not set this at the time the destructor ran so the clearitems method ran causing an access violation. /}
      Application.Terminate;
      //ccowout        Halt;
      //ccowout        Exit;
    End;

{/P129 setting GSess properties was moved higher up in this function.}



  FSAppBackGroundColor := $00E0DFCF;
  PnlNoteGlyph.BevelOuter := bvNone;
  PnlNoteGlyph.Height := 22;
  PnlNoteGlyph.Top := Edtnoteinfo.Top;

  PnlNoteGlyph.Left := Edtnoteinfo.Left;
    //  btnVLDef.Left := edtNoteInfo
  FAddDirOnSelect := True;
  LvSpecSubSpec.Height := 225;
  LvProcEvent.Height := 225;
  LvType.Height := 225;
    //DisableKeyDependentObjects;
    //>>>draganddropfiles
  DragAndDropFiles(True);
    //<<<draganddropfiles
  ImagePanel.Align := alClient;
    { Create new objects for image processing}
    { WPR }
  MSetWrks1 := TMagSettingsWrks.Create;
  FuprefCapTIU := TuprefCapTIU.Create;
  TempFileObj := TCaptureObject.Create;
  MagFileObj := TCaptureObject.Create; {In  FormCreate}
  FCapClinDataObj := TClinicalData.Create;
  FCapClinMgr := TMagCapClinMgr.Create;
  GUserDir := TSessionDirectories.Create;
  FErrorInGear := False;
  FErrorInGearList := Tstringlist.Create;
  FErrorInGearListCode := Tstringlist.create;
//  Gear 1.Guiwindow := GUIPAN;
  msysman.Visible := False;
  ZoomScrollInitialSettings;
  Nullsetting := '  ______  ';
  QueMsgList := Tstringlist.Create;
  SetSettingsToNull;
  CreateDynamicMenu;
  CreateDynamicPatMenu;
  CreateDynamicHelpMenu;
  FLockScrollBarsFitToWin := True;
  FCloseQuickSetting := False;
  FViewingLatestImage := False;
  Fminimumseperation := False;
  cbALLPages.Left := cbBatch.Left;
  cbALLPages.Top := cbBatch.Top;
  CprsSyncDefaults;
//  CprsStartedME := False;              {FormCreate}
  WindowsMessageID := RegisterWindowMessage('VistA Event - Clinical');
  Application.OnMessage := AppMessage;
  Application.ShowHint := True;
  Application.OnHint := AppOnHint;
  timerclose := False;
  batchimagedescription := '';
  FBatchEditDescOnSave := True;
  FBatchShowOptions := True;
  FBatchDelete := False;

  HideBatchListView;
  CPRSChangePatient := False;
    //  iDModObj.GetMagDBMVista1.CreateBroker; //p59
    //  xBrokerx := iDModObj.GetMagDBMVista1.GetBroker; // RPCBroker1;    //p59
    //  CreateBroker(self);

  sortinverse := True;
  FExtensionlist := Tstringlist.Create;

  CategorylistAll := Tstringlist.Create;
  CtgByClass := Tstringlist.Create;

    {     GetTabSettingsFromINI(TabSeqList);    now called in the Paint event;}
    {     CheckMagINI;                          now called in the Paint Event}
  writedir := '';
  CapIsInitialized := False;
  loginflag := False;
  AppPath := Copy(ExtractFilePath(Application.ExeName), 1, Length(ExtractFilePath(Application.ExeName)) - 1);
  //129t11 gek out.      Oldtempdir := AppPath + '\temp\';
  BlankImage := AppPath + '\bmp\blank.bmp';
  DateTimeProc := '';
    {  59 if not directoryexists(apppath + '\temp') then forcedirectories(apppath + '\temp');
       GEK P59 Create a TEMP directory in the users folder , so ThinClients don't holler.}
  Try  {P117 for the bug with Patient Photo's showing.}
//129T11 gek Win 7 directory change.  NO Longer using  AppPath  for 'Writes'
(* 129t11 gek
   If Not GUserDir.SetDirectories(AppPath, Rmsg) Then
      MagAppMsg('', Rmsg); *)
    ApplicationDataFolder := GetEnvironmentVariable('AppData');
        // TESTING   raise Exception.Create('force error for testing');
    if ApplicationDataFolder = '' then
     begin
       MagAppMsg('d','Application Date Folder undefined.  Application cannot run.');
       exit;
     end;

    If Not GUserDir.SetDirectories(ApplicationDataFolder + '\VistA\Imaging\', Rmsg) Then
        WinMsg('', Rmsg);

  Except
    On e: Exception Do
    Begin
      WinMsg('', e.Message);
    End;
  End;

    {we're not totally changed to using the 'users temp folder' p117}
(* for win7 we need to be .... no more writing to AppPath.
  Try
        //TESTING   raise Exception.Create('force error for testing');
    If Not Directoryexists(AppPath + '\temp') Then
      Forcedirectories(AppPath + '\temp');
    If Not Directoryexists(AppPath + '\image') Then
      Forcedirectories(AppPath + '\image');
    If Not Directoryexists(AppPath + '\cache') Then
      Forcedirectories(AppPath + '\cache');
    If Not Directoryexists(AppPath + '\import') Then
      Forcedirectories(AppPath + '\import');
  Except
    On e: Exception Do
    Begin
      WinMsg('', e.Message);
    End;
  End; *)
  CapX.mImageType := 0;
  UserCapDUZ := '0';
  btnxDateTime.caption := DateTimeToStr(Now);
  Angle := 0;
  FdragTab := -1;
  FDragTo := -1;
  FModINV := False;
  FModFLIP := False;
  FModROT := 0;

  MagAspectRatio(2);
  mgPatImage.FitToWindow;

  ResetControls;
  mg1.MousePan  ;
  SecurityKeys := Tstringlist.Create;
  GetFormPosition(Self As TForm);
  FrmCapSettings := TfrmCapSettings.Create(Self); // Application.CreateForm(TfrmCapSettings,frmCapSettings);
  FrmDoNotClear := TfrmDoNotClear.Create(Self); // Application.CreateForm(TfrmDoNotClear, frmDoNotClear);
  SetPageControls;
  LoadHelpMenu;

  ColapseLongDesc;

  ZoomIn3.ShortCut := ShortCut(Ord('I'), [SsShift, Ssctrl]); //[ssAlt,ssCtrl]
  ZoomOut3.ShortCut := ShortCut(Ord('O'), [SsShift, Ssctrl]);
  ZoomIn4.ShortCut := ShortCut(Ord('I'), [SsShift, Ssctrl]); //[ssAlt,ssCtrl]
  ZoomOut4.ShortCut := ShortCut(Ord('O'), [SsShift, Ssctrl]);

  mnuFitToWidth1.ShortCut := ShortCut(Ord('W'), [SsShift, Ssctrl]);
  FitToWidth1.ShortCut := ShortCut(Ord('W'), [SsShift, Ssctrl]);
  Reset2.ShortCut := ShortCut(Ord('S'), [SsShift, Ssctrl]);
  Reset1.ShortCut := ShortCut(Ord('S'), [SsShift, Ssctrl]);

  ActualSize1.ShortCut := ShortCut(Ord('A'), [SsShift, Ssctrl]);
  FitActualSize1.ShortCut := ShortCut(Ord('A'), [SsShift, Ssctrl]);

  Right2.ShortCut := ShortCut(Ord('R'), [SsShift, Ssctrl]);
  Right1.ShortCut := ShortCut(Ord('R'), [SsShift, Ssctrl]);

  mnuPageFirst1.ShortCut := ShortCut(VK_LEFT, [Ssctrl, SsAlt]); //[ssAlt]
  mnuPagePrev1.ShortCut := ShortCut(VK_DOWN, [Ssctrl, SsAlt]);
  mnuPageNext1.ShortCut := ShortCut(VK_UP, [Ssctrl, SsAlt]);
  mnuPageLast1.ShortCut := ShortCut(VK_RIGHT, [Ssctrl, SsAlt]);

  MnuScrollLeft.ShortCut := ShortCut(VK_LEFT, [SsShift, Ssctrl]); //[ssShift,ssCtrl]
  MnuScrollRight.ShortCut := ShortCut(VK_RIGHT, [SsShift, Ssctrl]);
  MnuScrollUp.ShortCut := ShortCut(VK_UP, [SsShift, Ssctrl]);
  MnuScrollDown.ShortCut := ShortCut(VK_DOWN, [SsShift, Ssctrl]);

  MnuScrollToCornerTL.ShortCut := ShortCut(VK_HOME, [SsShift, Ssctrl]);
  MnuScrollToCornerTR.ShortCut := ShortCut(VK_PRIOR, [SsShift, Ssctrl]);
  MnuScrollToCornerBL.ShortCut := ShortCut(VK_NEXT, [SsShift, Ssctrl]);
  MnuScrollToCornerBR.ShortCut := ShortCut(VK_END, [SsShift, Ssctrl]);

  mnuContrastMore1.ShortCut := ShortCut(Ord('J'), [SsShift, Ssctrl]);
  mnuContrastLess1.ShortCut := ShortCut(Ord('K'), [SsShift, Ssctrl]);
  mnuBrightnessMore1.ShortCut := ShortCut(Ord('N'), [SsShift, Ssctrl]);
  mnuBrightnessLess1.ShortCut := ShortCut(Ord('M'), [SsShift, Ssctrl]);

  MoveSelectedToBatch1.ShortCut := ShortCut(Ord('B'), [SsShift, Ssctrl]);
  MoveSelected1.ShortCut := ShortCut(Ord('B'), [SsShift, Ssctrl]);
  gDebugUser := GetDebugMode; //P106 BB debug added to capture, value kept in .ini

    //Contrast5.ShortCut := shortcut(VK_NUMPAD5,[ssAlt]);
    //Contrast4.ShortCut := shortcut(VK_NUMPAD4,[ssAlt]);
    (*   Virtual Key Codes
      VK_NUMPAD8
      VK_NUMPAD7
          VK_LEFT	Left Arrow key
          VK_UP	Up Arrow key
          VK_RIGHT	Right Arrow key
          VK_DOWN	Down Arrow key
   *)

  {/P122 DMMN 6/28/2011 - Create an overlay form over imagepanel to do annotation.
  The panel will live throughout the live of Capture application /}
//p129  fCapAnnot := TfrmMagCapAnnotation.Create(self);
  {/p122 dmmn WPR Capture Item #13 - set the annotation form to align to the owner client area /}


//p129   fCapAnnot.OnClose := OnAnnotationPanelClose;
  if frmAnnotOptionsX = nil then  {/p122 dmmn 7/5/11}
    frmAnnotOptionsX := TfrmAnnotOptionsX.Create(self);
  FAnnotationManips := Tstringlist.Create();   //p122t11 dmmn - tracking image orientation changes
  //FTRCImageManips := False;        //p122t12
  ForceDirectories(GSess.AnnotationTempDir);  {/p129 gek/duc stop access violation}    {JK - moved it from here from fMagAnnot}
End;
{JK 6/28/2012}{drag and drop}
procedure TfrmCapMain.PanelWindowProc(var Msg: TMessage);
begin
  if Msg.Msg = WM_DROPFILES then
    PanelImageDrop(TWMDROPFILES(Msg))
  else
    originalPanelWindowProc(Msg);
end;

{JK 6/28/2012}
procedure TfrmCapMain.PanelImageDrop(var Msg: TWMDROPFILES);
var
  numFiles: longInt;
  buffer: array[0..MAX_PATH] of char;
  M: TMessage;
begin
(*  numFiles := DragQueryFile(Msg.Drop, $FFFFFFFF, nil, 0) ;
  if numFiles > 1 then
    MessageDlg('You can drag and drop one image file at a time.', mtInformation, [mbOK], 0)
  else *)
  begin
    //DragQueryFile(Msg.Drop, 0, @buffer, sizeof(buffer));
    try
      M := TMessage(Msg);
      AcceptFiles(M);
    except
      on EInvalidGraphic do
        ShowMessage('Unsupported image file, or not an image!');
    end;
  end;
end;

{JK 6/27/2012 - encapsulate the gear creation process in a method}
procedure TfrmCapMain.CreateGearComponent;
begin
  FAnnotInitForImage := false;  {cludge...  this is so we only Init the Annotation component once for
                               the TMag4VGear.  ...   work in progress
                               }
  mg1 := TMag4VGear.Create(self, '', MagGearAbilityRadiology);
  mg1.Parent := imageboxpanel;
  mg1.AnnotationComponent.CaptureNewImage := true;
  mg1.showimageonly := true;
  mg1.Color := clGray;
  mg1.OnImageMouseUP :=    mg1MouseUp;
  ///// Jerry had this out.   mg1.OnDragDrop := Mg1DragDrop;
  mg1.Align := alclient;
  mg1.OnPanWindowClose := PanWindowCloseEvent;

  {JK 6/28/2012 - support Drag-n-Drop from Windows Explorer to the Accusoft IGPageViewCtl}
  { creates another dependency on Accusoft Control from capture main.}
  originalPanelWindowProc := mg1.GetImageViewCtl.WindowProc;
  mg1.GetImageViewCtl.WindowProc := PanelWindowProc;
  DragAcceptFiles(mg1.GetImageViewCtl.Handle, True);


  //  was put in for testing 129     mg1.ViewStyle :=  MagGearViewRadiology;
  //  mg1.SetSkipColorChannel(true);   
  {129T10 gek.  Stop error of color channel.  This is changed to Tsession variable.
      stop color split for whole session.  so PatientImages don't throw error . Workaround, not a long term fix. }
  //  was put in for 129 TESTING      mg1.Visible := true;
  //  was put in for 129 TESTING     mg1.OnPanWindowClose := PanWindowCloseEvent;    //try anything


end;



Procedure TfrmCapMain.CapImageVClick(Sender: Tobject; VGear: TMag4VGear);
Begin

 If mg1.panwindow
     Then  SetPanWindowWithActivateOption(true,True);

(*   this is copied from display, for the PanWinError  Pan Widnow.
     I'm only enabling the Pan Window functions of this Image Click callback.
  {/ P122 - JK 10/18/2011 - check if the current image is changing. If it is and the
    annotation toolbar is open, see if annotation changes need to be saved before
    moving on. /}
  if Cur4Image <> nil then
    if not Cur4Image.AbstractImage then
      if Cur4Image.AnnotationComponent <> nil then
        begin
          if not Cur4Image.CheckIfAnnotsModified then        {p129 - annot info}
          begin
            Cur4Image.Selected := True;
            Exit;
          end;
        end;
  Cur4Image := VGear;
  Cur4Image.BringToFront;
  Update;
  UnSelectAll;
    { TODO -cRedundantly Called ?: This could be redundant, have to check flow after mouse down. }
  Cur4Image.Selected := True;
 If FPanWindow
     Then  SetPanWindow(FPanWindow);                  { !!  this is called on mouse click IN Display...  NOT in Capture ?   PanWinError.}
  If Assigned(OnViewerImageClick)
     Then  OnViewerImageClick(Cur4Image);
  If Assigned(OnViewerClick)
     Then  OnViewerClick(Self, Self, Cur4Image);
  CheckButtons();
*)
End;


Procedure TfrmCapMain.SetPanWindowWithActivateOption(Value: Boolean; Activate: Boolean);
Var
  x, y: Integer;
  Viewerpt, Imagept: TPoint;
  h, w: Integer;
Begin
  mg1.panwindow := Value;        { Called in Display, each mouse click  not in capture PanWinError}
    //  PanCloseAll;
      {    below, we are only appling PanWindow to the Current Image{}
  If mg1 = Nil Then
    Exit;
  Viewerpt := Parent.ClientOrigin;
  Imagept := mg1.ClientOrigin;
  x := Imagept.x - 100 + mg1.Width; // Cur4Image.Gear1.Width;
  y := Imagept.y;
  h := Trunc(mg1.Height / 2.5);
  w := Trunc(mg1.Width / 2);
  If (Value) And (Activate) Then
    mg1.PanWindowSettings(h, w, x, y)           {This is called IN Display each click, Not Capture PanWinError}
  Else
    mg1.PanWindow := Value;

End;





Procedure TfrmCapMain.PanWindowCloseEvent(Sender: Tobject);
Begin
mg1.panwindow := false;    //129t10  have the panwindow close event defined.  Try anything.
End;



{/ P122 - JK 8/30/2011 - Check to be sure the client machine has type family ARIAL installed.
   The call to Screen.Fonts is a wrapper to the Windows function EnumFontFamiliesEx. /}
{TODO -ogarrett -cRCA2 : why is this here,  why not in the Annotation component ? }
{TODO -ogarrett -cRCA2 : GSess was designed for properties to be set from DataBase,
                 and not application specific.If app specific,
                 then make a GSessCap,  GSessDisplay }
procedure TfrmCapMain.CheckForAnnotationFontResource;
var
  FontList: TStringList;
begin
  FontList := TStringList.Create;
  try
    FontList.Assign(Screen.Fonts);
    {/p122 dmmn WPR Capture Item #36 /}
    if (Screen.Fonts.IndexOf(MagAnnotationFont) = -1) then
    begin
      MagAppMsg('d', 'This workstation does not have the ' + MagAnnotationFont + ' font installed. ' +
                       'Text annotations require ' + MagAnnotationFont + '. Creation of annotations is disabled on this computer.');
      GSess.AnnotationFontAvailable := False;
    end
    else
      GSess.AnnotationFontAvailable := True;
  finally
    FontList.Free;
  end;
end;

Procedure TfrmCapMain.SetSettingsToNull;
Begin
  LbInputSourceDesc.caption := Nullsetting;
  Lbformatdesc.caption := Nullsetting;
  LbAssocDesc.caption := Nullsetting;
  Imagegroupdesc.caption := Nullsetting;
  Modedesc.caption := Nullsetting;
  Otherdesc.caption := Nullsetting;
End;

Procedure TfrmCapMain.msgslist(Ts: TStrings);
Var
  i: Integer;
Begin
  For i := 0 To Ts.Count - 2 Do
    WinMsg('S', Ts[i]);
  WinMsg('', Ts[Ts.Count - 1]);
End;

Procedure TfrmCapMain.CreateDynamicPatMenu;
Begin
  MagPatMenu := TMag4Menu.Create(Self);
  With MagPatMenu Do
  Begin
    MenuBarItem := File1;
    InsertAfterItem := N6;
    OnNewItemClick := PatMenuitemSelected;
    MaxInsert := 10;
  End;
End;

Procedure TfrmCapMain.CreateDynamicHelpMenu;
Begin
  MagHelpMenu := TMag4Menu.Create(Self);
  With MagHelpMenu Do
  Begin
    MenuBarItem := Help1;
    InsertAfterItem := ErrorCodelookup1;
    OnNewItemClick := HelpMenuitemSelected;
    MaxInsert := 10;
  End;
End;

Procedure TfrmCapMain.PatMenuitemSelected(Sender: Tobject);
Begin
    {     dynamic patient menu item clicked;}
  ChangeToPatient((Sender As TMagMenuItem).ID); //name, 2, 99));
End;

Procedure TfrmCapMain.HelpMenuitemSelected(Sender: Tobject);
Begin
    //TMag4Menu.AddItem(xcaption: string; xID: string; xhint: string);
  Magexecutefile((Sender As TMagMenuItem).ID, '', '', SW_SHOW);
End;

Procedure TfrmCapMain.CreateDynamicMenu;
Begin
  MagMenuConfig := TMag4Menu.Create(Self);
  With MagMenuConfig Do
  Begin
    MenuBarItem := Configurations1;
    InsertAfterItem := mnuConfigListSeperator;
    OnNewItemClick := ConfigMenuItemSelected;
    MaxInsert := 20;
  End;
End;

Procedure TfrmCapMain.ConfigMenuItemSelected(Sender: Tobject);
Var
  Rmsg: String;
Begin
    {     Display makes use of the ID property, we'll do it here also
          changetopatient((Sender as TMagmenuItem).id);}
  FrmConfigList.ApplyConfiguration((Sender As TMagMenuItem).ID, Rmsg);
End;

Procedure TfrmCapMain.FormPaint(Sender: Tobject);
Begin
  If CapIsInitialized Then
      Begin
      Exit;
      End;
CaptureFinalInit;
end;


{p129t13  organize code.  This is called last, from OnPaint Once,  all other objects and Forms have been created.}
procedure TfrmCapMain.CaptureFinalInit;
  begin
  CapIsInitialized := True;
  IsOkayToChangePatient := CanCaptureChangePatient;//gek 9/7/12      //12/20/12 ? why is this here ?

  ImagDMinterface.iDModObj := dmod;

 {/p117 gek 1-17-11 test the FCacheDirectory}
//  MagImageManager1.SetCacheDirectory(GUserDir.Cache)  ;
//  MagImageManager1.CacheDirectory := GUserDir.Cache  ;
  magobslbSwitchPatientsWarn.MagPat := iDModObj.GetMagPat1;
  iDModObj.GetMagDBBroker1.CreateBroker; //p59
  XBROKERX := iDModObj.GetMagDBBroker1.GetBroker; // RPCBroker1;    //p59
 // This Needs defined to solve the timeout issue. Not Yet Complete.
/// XBROKERX.OnPulseError := BrokerOnPulseError;
  iDModObj.GetMagDBSysUtils1.Broker := iDModObj.GetMagDBBroker1.GetBroker; //93

    //p8t48  This applies the AntiAliasing to the Image Gear Control.
  SmoothImage;

{/p129  below we called SetAutoDetects.. (106 I think) for configuring TGear.
        we don't need this function with Accusoft 16}
//p129   SetAutoDetects(Gear1);
  Application.Processmessages;
  ShowTagFields;
  {/ P122T10 - JK 11/21/2011 - move this code section to FormCreate. There is a rare access violation situation that occurs when
     multiple instances attempt to run. Do not call HALT.  Call Application.Terminate /}
//  If (Uppercase(GetIniEntry('Workstation settings', 'AllowMultipleInstances')) <> 'TRUE') Then
//   etc, etc.


(* RCA out.  This is autoupdating.   This is not used anymore
  Try
    Ts := Tstringlist.Create;
    WinMsg('', 'Checking for current version...');
        {   If user elects to  AUTOUPDATE, then we'll terminate }
    If IsUpdateing('VistA Imaging', 'LASTUPDATE', Ts) Then
    Begin
      Application.Processmessages;
      Application.Terminate;
      Exit;
    End;
    msgslist(Ts);
    Ts.Clear;
  Finally
    Ts.Free
  End;
  *)
  //Maggmsgf.InitializeLogManager(iDModObj.GetMagLogManager); //p93t8
  Show;
  Update;
    //CapFileName := 'scantemp';
    //CapFileExt := '.TGA';
  ApplyWorkstationSettings;

  btnPatient.SetFocus;
{p129t13  CCOW change}

  { First just JoinContext,  The CCOW icons will get updated when we get message from SubScriber}
  screen.Cursor := crHourGlass;
  winmsg('','Attempting to Join CCOW Context ...');
  update;
    idmodobj.GetCCOWManager.JoinContext();
  screen.Cursor := crDefault;
  magappmsg('s','Joining CCOW Context  Done.');
  if idmodobj.GetCCOWManager.CCOWEnabled
     then
       begin
        SetCapRunMode(magrmCCOW) ;
        winmsg('','CCOW Context Active')
       end
     else winmsg('','CCOW Context Not Active');
   SetCapRunMode(magrmAlone);
  If ParamCount > 0 Then
     begin
{capRunMode : by default it is 0 - magrmAlone.
   with Parameters, RunMode may  stay Alone, or change to CPRS,
     or CCOW (if CPRS started us, CCOW is active , and CPRS has the Patient in Context}
    StartWithParameters ;      {FormPaint - this is Only place this is called. }
    {p129.  If  caprunMode is magrmCPRS, then we connected by using the CPRS
           parameters,  now check if CCOW Is active, and if Yes,  change mode
            to magrmCCOW}
    end
  Else
    begin
   { capRunMode :   here because there are no Parameters.
      RunMode could be magrmAlone or magrmCCOW (if CCOW is active)}
    If FLoginOnStartup Then
      ImagingCaptureLogin(localserver, Inttostr(ListenerPort), (Not AllowRemoteLogin));   {FormPaint}
    end;

  Application.HelpFile := AppPath + '\MagImaging.hlp';
  If (cbOrigin.ItemIndex = -1) Then
    cbOrigin.ItemIndex := GetDefaultOriginIndex; //93 For IHS  This is the setting from the INI or '0' ( for VA sites,  0='VA' )
{ DONE -O129 : Error handling for V16 needs tested}
GetIGManager.IGCoreCtrl.OnIGError :=  mg1IGCoreCtlIGError;
 // IG_ERR_EVENT_ERROR  , IG_ERR_EVENT_WARNING , IG_ERR_NO_ACTION,  IG_ERR_OLE_ERROR (cMag4VGear uses IG_ERR_OLE_ERROR}
GearClear; {to initialize Gear for processing. }
if  NeedToCheckCPRSParams then
  begin
   if DoesCCOWConflictCRPS then
      begin
       application.Terminate;
       exit;
      end;
  end;
frmCapConfig.SetTWAINSourceFromINI();
  If (Uppercase(GetIniEntry('Workstation settings', 'EnableMultipleSourceCapture')) <> 'TRUE') Then
     begin
     frmCapConfig.cbMultipleCapture.Visible := False;
     CapX.m140MultSources := False;
     end;
End;
//========================= /TP ============  /TP
Procedure TfrmCapMain.CommandLineCodes(Var Res: Boolean);
  Var
    i: Integer;
    Vserver, Paramup, Vport, Vpatid: String;
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

{ p129T13   this is called if CCOW is Running, and CPRS has started the Capture application.
             We have already logged in with the CCOW Patient.
             So now we compare the CPRS Patient with the CCOW patient.}
function TfrmCapMain.DoesCCOWConflictCRPS(): boolean;
var
  xContextKey : string;
  xContextDFN : string;
  xContextICN : string;
  WarningMsg: string;
  isProdAccount : boolean;
  xstat : boolean;
  xPatinfo : string;
  xCPRSDFN, xCPRSICN : string;
begin
   winmsg('','Validating CPRS - CCOW Patients...');
   result := false;
     idmodobj.GetCCOWManager.ShowContextData();
     xCPRSDFN := NeedToCheckCPRSPatientDFN;
     idmodobj.GetMagDBBroker1.RPMagPatInfoQuiet(xstat, xpatinfo, xCPRSDFN);
     winmsg('s','RPMagPatInfoQuiet: ' + xpatinfo);
     //xCPRSDFN := magpiece(xpatinfo,'^',2);
     xCPRSICN := MagPiece(MagPiece(xpatinfo, '^', 11), 'V', 1);

   begin
     {p129T13. gek.  If here, Check CCOW patient against CRPS Patient, and
     if not same, we Show Dialog and Quit.  This is situation where CPRS started us
      and CCOW is active, but CPRS patient is not the patient in context.
       }
      // isProdAccount :=  idmodobj.GetMagPat1.M_ProdAcct;
      isProdAccount := FisProdAccount;
       winmsg('s','Production Account: ' + magbooltostr(isProdAccount));


       if (IsProdAccount)  then
          begin
          xContextKey := 'patient.id.mrn.dfn_' + PrimarySiteStationNumber ;
          xContextDFN := idmodobj.GetCCOWManager.GetContextValue(xContextKey);
          xContextKey := 'patient.id.mrn.nationalidnumber' ;
          xContextICN := idmodobj.GetCCOWManager.GetContextValue(xContextKey);
          end
          else
          begin
          xContextKey := 'patient.id.mrn.dfn_' + PrimarySiteStationNumber + '_test';
          xContextDFN := idmodobj.GetCCOWManager.GetContextValue(xContextKey);
          xContextKey := 'patient.id.mrn.nationalidnumber' + '_test';
          xContextICN := idmodobj.GetCCOWManager.GetContextValue(xContextKey);
          end;


       if ((xContextDFN = xCPRSDFN) or (xContextICN = xCPRSICN))
         then
           begin
                  //129 TESTING.  MORGAN ,  TAKE OUT FOR RELEASE
      (* showmessage('Validating CCOW Context and CPRS patient.' + #13
                    + 'CPRS DFN: ' + xCPRSDFN + ' CCOW DFN: ' + xContextDFN +  #13
                    + 'CPRS ICN: ' +xCPRSICN + ' CCOW ICN: ' + xContextICN  + #13 + #13
                    + 'CPRS Patient Confirmed as patient in Context.' + #13
                    + '  Application will continue');    *)


           winmsg('s','CPRS Patient Confirmed as patient in Context.') ;
           winmsg('','');
           exit;
           end
         else
         begin
           result := true;
                             //129 TESTING.  MORGAN ,  TAKE OUT FOR RELEASE
(*       showmessage('Validating CCOW Context and CPRS patient.' + #13
                    + 'CPRS DFN: ' + xCPRSDFN + ' CCOW DFN: ' + xContextDFN +  #13
                    + 'CPRS ICN: ' +xCPRSICN + ' CCOW ICN: ' + xContextICN  + #13 + #13
                    + 'CPRS Patient Is NOT same as patient in Context.' + #13
                    + '  Application will Terminate.');  *)
           // warning message to display if CPRS launches Display and CPRS is not in context
           winmsg('s','CPRS Patient isn''t patient in context. Terminating Application');
           winmsg('s','CPRS DFN: ' + xCPRSDFN + ' CCOW DFN: ' + xContextDFN + '.  CPRS ICN: ' +xCPRSICN + ' CCOW ICN: ' + xContextICN );
           winmsg('','');
           WarningMsg := 'WARNING - VistA Imaging Capture CANNOT RUN' + #13 +
            #13 +
            'The CPRS from which you just launched VistA Imaging Capture is not participating in patient synchronization.' + #13 +
            #13 +
            'For patient safety reasons, VistA Imaging Capture cannot run in this mode.' + #13 +
            #13 +
            'To use VistA Imaging Capture, please make CPRS join patient synchronization, and then relaunch VistA Imaging Capture from the Tools menu' + #13 +
            #13 +
            'To make CPRS join patient synchronization: in CPRS, chose File/Rejoin patient link.' + #13 +
            #13 +
            'Note: if you have more than one CPRS running, this action may cause other CPRS windows to try to match your patient' + #13 +
            #13 +
            'Please contact your local IRM help desk for further assistance';

             messagedlg(WarningMsg,mtconfirmation,[mbok],0);
         end;
   end;
end;



Procedure TfrmCapMain.StartWithParameters;
Var
  CprsTMP: String;
  Piecenum: Integer;


Begin
    { CPRS Started this Capture session
       1) DFN 2)    LINK GLOBAL, ( WE NO LONGER USE THIS )     3) SITE    4) PORT
       1) 16 2) ^TMP('ORWCHART',350,'152.127.160.141',1966578) 3) LocalHost 4) 9300 {}

  WinMsg('s', ' 1) ' + ParamStr(1) + ' 2) ' + ParamStr(2) + ' 3) ' + ParamStr(3) + ' 4) ' + ParamStr(4));
  localserver := ParamStr(3);
  ListenerPort := Strtoint(ParamStr(4));

  ImagingCaptureLogin(localserver, Inttostr(ListenerPort), True);    {StartWithParameters}
  If Not XBROKERX.Connected Then
    Exit;
  CprsTMP := MagPiece(ParamStr(2), ')', 1);
  Piecenum := Maglength(CprsTMP, ',');
  CprsSync.HexHand := MagPiece(CprsTMP, ',', Piecenum);

  if capRunMode <> magrmCCOW
     then
     begin
     ChangeToPatient(ParamStr(1));
     SetCapRunMode(magrmCPRS);
     CprsSync.SyncOn := True;
     EnablePatientLookupLogin(Not CprsSync.SyncOn);
     end
     else
     begin
         //gek p129t13  CCOW managment.
         //p129t13  These variables are set, to tell code, later, that we need to compare
         //         the CPRS Patient against the CCOW patient
        NeedToCheckCPRSParams := true;  
        NeedToCheckCPRSPatientDFN := ParamStr(1);
     end;
End;

Procedure TfrmCapMain.SetWorkstationTimeout(Minutes: String);
Var
  i: Integer;
Begin
  If Minutes = '' Then
    Minutes := '0';
  Try
    i := Strtoint(Minutes);
  Except
    On e: Exception Do
      i := 0;
  End;
  WorkStationTimeout := i;
  If i > 0 Then
    MagTimeoutform.SetApplicationTimeOut(Inttostr(i), TimeoutTimer);

End;

Procedure TfrmCapMain.Caplumisys75(Sender: Tobject);
Begin
  WinMsg('', 'Lumisys 75 Scanning...');

    //TempFileObj.FullFileName := apppath+'\'+ScanTemp
    //FileSave := 'Scantemp';
  TempFile := 'ScanTemp';
    //dirx := tempdir;
  GearClear;
  Screen.Cursor := crHourGlass;

    // Cmd and Param are only things different between the 3 CAPLumisys procedures
  cmd := '"' + AppPath + '\MagScan75N.bat' + '"';
    //  Param := dirx + FileSave + Format + ' ' + dirx + FileSave + '.abs'; we no longer send param

  If IsProcessRunning(Exeprocessinfo) Then
  Begin
    WinMsg('D', 'Capture Process is running');
    Exit;
  End;
  WinExecNoWait32(cmd, 1, Exeprocessinfo);
  Timer1.Enabled := True;
  MagAspectRatio(1);
    {CAPtureIsValid;}{ THIS IS DONE IN THE TIMER1.TIMER EVENT }{197}
End;

Procedure TfrmCapMain.Caplumisys150(Sender: Tobject);
Var
  PARAM: String;
Begin
  WinMsg('', 'Lumisys 150 Scanning...');

    //FileSave := 'Scantemp';
  TempFile := 'ScanTemp';
    //59 dirx := tempdir;
  GearClear;
  Screen.Cursor := crHourGlass;

    // Cmd and Param are only things different between the 3 CAPLumisys procedures
  cmd := AppPath + '\MagScan150N.bat';
    //Param := tempdir + FileSave + Format + ' ' + tempdir + FileSave + '.abs' + ' ' + apppath + '\abstrtga.exe';
  //  Param := GUserDir.Temp + TempFile + Format + ' ' + GUserDir.Temp + TempFile + '.abs' + ' ' + apppath + '\abstrtga.exe';
//pre 129 has this ->   PARAM := oldtempdir + TempFile + Format + ' ' + oldtempdir + TempFile + '.abs' + ' ' + AppPath + '\abstrtga.exe'; {var format} {CapLumisys150}
  PARAM := GUserDir.Temp + TempFile + CapX.mFormat + ' ' + GUserDir.Temp + TempFile + '.abs' + ' ' + AppPath + '\abstrtga.exe'; {var format} {CapLumisys150}
  If IsProcessRunning(Exeprocessinfo) Then
  Begin
    WinMsg('D', 'Capture Process is running');
    Exit;
  End;
  WinExecNoWait32(cmd + ' ' + PARAM, 1, Exeprocessinfo);
  Timer1.Enabled := True;
  MagAspectRatio(1);
    {CAPtureIsValid;}{ CAPtureIsValid -> THIS IS DONE IN THE TIMER1.TIMER EVENT }
End;

Procedure TfrmCapMain.CapMeteor(Sender: Tobject);
Begin
{$IFDEF MeteorBoard}
    { TODO :
    Have to add back the METEOR form to the capture project.
    and uncommentout the meteor entries. }
    //{
    // modified for new METEOR FORM, using meteor ActiveX Controls.
  // 129T11   this is no longer used.  Tempdir := GUserDir.Temp;
  If Not Doesformexist('MagMeteorForm1') Then
  Begin
    MagMeteorForm1 := TMagMeteorForm1.Create(Self);
    Application.Processmessages;
  End;
    // test frmCapConfig.cbmeteorint.checked
  If FrmCapConfig.cbMeteorInt.Checked Then
  Begin
    MagMeteorForm1.Show;
    MagMeteorForm1.BringToFront;
    MagMeteorForm1.SetFocus;
    WinMsg('', 'Meteor Capture is Activated.');
  End
  Else
  Begin
    MagMeteorForm1.Show;
    MagMeteorForm1.TbOKClick(Self);
  End;
{$ENDIF}
End;

Procedure TfrmCapMain.CapTwain(Sender: Tobject);
Var
  s: String;
  isopen :boolean;
   bitsPix : integer;
Begin
 s := 'Scanning Document, this may take a minute...';
 if CapX.m140PDFConvert then

    s := 'Scanning Document and Saving as PDF, this may take a minute...';

  WinMsg('', s);

      if Not MagTWain1.IsSourceOpen then
      Begin
      isopen := MagTwain1.SourceOpenDefault;
      if not isopen then
        begin
        WinMsg('de', 'TWAIN Device is not open.' + #13
                    + 'select a TWAIN Source from the Configuration Window.') ;
        Exit;
        end;
      End;

  WinMsg('', 'Twain Device is Activated...');
      GearClear;
      MagTwain1.UseUI := TRUE; //  Gear 1.ScanShowUI := False;
      MagTwain1.SetResolution('300','300');

      MagTwain1.MagSetCapability('4386',mag_AM_TID_META_UINT16,mag_IG_DATA_LONG,'3');
      //MagTwain1.MagSetCapability(inttostr(ICAP_SUPPORTEDSIZES),mag_AM_TID_META_UINT16,mag_IG_DATA_LONG,inttostr(IG_TW_SS_LETTER));

    {Patch 59 stop the TIF JPG fiasco.}
     {out, need to allow MultiPage TIF (other than 1 bit) for now  if cb AllPages.Checked then cb AllPages.Checked := false;}


  If Not AcquireGear16 Then            {in CapTwain}
    Exit;



 mg1.Updatepageview;
 bitsPix := mg1.GetBitsPerPixel;
  s := 'File Type int : ' + '___'  //Inttostr(Gear 1.Filetype)
    { TODO -o129 : information. ...This is for a Test Message shown in Message History.  Low Priority }
    (* out for p129 compile

    + #13 + ' Save Format int  : ' + Inttostr(FmIGSaveFormat)
    + #13 + ' Save format      : ' + GetSaveFormat(Gear 1)

    *)
       +  #13 + 'ImageFormat: ' +  mg1.GetFileFormatAbbr()
       +  #13 + 'Bits       : ' +  inttostr(bitsPix) ;
{  still need this info converted to V16    Low Priority
     If bitspix = 1 Then
      y := Inttostr(xRes) + ' x ' + Inttostr(yRes) + ' dpi  '
    Else
      y := Inttostr(mg1.GetImageWidth) + 'W x ' + Inttostr(mg1.GetImageHeight) + 'H ';
    Desc := '  ' + y + '  ' + Inttostr(BitsPix) + ' bit.  ' + AccuImageType;}

  If mg1.GetCurrentPage.ImageIsGray Then
    s := s + ' IsGray'
  Else
    s := s + ' NotGray';

  Testmsg(s);
    {	First version of Capture, forced the user to tell us what type of format the image was.
      8-48 stopped that in import.  60 needs to stop other problems with TWAIN Window.
      Patch 60 fix, couldn't wait. We need to stop having the user tell us what type of file
      it is.  Nothing but problems}

  Case  mg1.GetBitsPerPixel of
    1:
      If CapX.mIGSaveFormat <> IG_SAVE_TIF_G4 Then
      Begin
        WinMsg('s', 'After Scan: Convert saveformat from: ' + mg1.GetFileFormatAbbr);
        WinMsg('s', 'to:  IG_SAVE_TIF_G4');
        FrmCapConfig.INITdocumentG4;

      End;
    8:
      Begin                              
        If CapX.mMultipage Then
        Begin
          If (CapX.mIGSaveFormat <> IG_SAVE_TIF_PACKED) Then     //WAS UNCOMP
          Begin
            WinMsg('s', 'After Scan Multipage: Convert saveformat from: ' + mg1.GetFileFormatAbbr);
            WinMsg('s', 'to:  IG_SAVE_TIF_PACKED');
            FrmCapConfig.INITcolorscan; // 8 bit color TIF  (PACKED IN p129)
          End;
        End
        Else
        Begin {scan is not multiple page (shouldn't be)}

          If mg1.GetCurrentPage.ImageIsGray Then
          Begin
            If (CapX.mIGSaveFormat <> IG_SAVE_JPG)
              And (CapX.mIGSaveFormat <> IG_SAVE_TIF_UNCOMP)
              And (CapX.mIGSaveFormat <> IG_SAVE_TGA) Then
            Begin
              WinMsg('s', 'After Scan: Convert saveformat from: ' + mg1.GetFileFormatAbbr);
              WinMsg('s', 'to:  IG_SAVE_JPG');
              FrmCapConfig.INITXrayJPG ; // was INITblackandwhite;  (TGA)

            End;

          End;

          If Not mg1.GetCurrentPage.ImageIsGray Then
            If (CapX.mIGSaveFormat <> IG_SAVE_TIF_PACKED)  // WAS UNCOMP
              And (CapX.mIGSaveFormat <> IG_SAVE_TGA) Then
            Begin
                            { If 8 bit color and Format isn't TGA or TIF, change to TIF}
              WinMsg('s', 'After Scan: Convert saveformat from: ' + mg1.GetFileFormatAbbr);
              WinMsg('s', 'to:  IG_SAVE_TIF_PACKED');
              FrmCapConfig.INITcolorscan; // 8 bit color TIF


                         {  winmsg('s','After Scan: Convert saveformat from: ' + GetSaveFormat(Gear1));
                            winmsg('s','to:  IG_SAVE_JPG');
                            frmCapConfig.INITtruecolorJPG;
                            //Gear 1.SaveFormat := IG_SAVE_JPG;
                            Gear 1.PromoteColor := IG_PROMOTE_TO_24;}
            End;
        End; {if not CapX.mMultipage Else begin}
      End;
    24:
      Begin
        If CapX.mMultipage Then
        Begin
          If (CapX.mIGSaveFormat <> IG_SAVE_TIF_PACKED) Then       //was UNCOMP
          Begin
            WinMsg('s', 'After Scan Multipage: Convert saveformat from: ' +  mg1.GetFileFormatAbbr );
            WinMsg('s', 'to:  IG_SAVE_TIF_PACKED');
            FrmCapConfig.INITcolorscan ;  // pre p129 was   INITdocument;
          //  Frmcapmain.Gear 1.Scanbits := 24;   // INITcolorscan sets it to 8.
          End;
        End
        Else
        Begin {scan is not multiple page (shouldn't be)}
          If CapX.mIGSaveFormat <> IG_SAVE_JPG Then
          Begin
            WinMsg('s', 'After Scan: Convert saveformat from: ' + mg1.GetFileFormatAbbr);
            WinMsg('s', 'to:  IG_SAVE_JPG');
            FrmCapConfig.INITtruecolorJPG;
                        //Gear 1.SaveFormat := IG_SAVE_JPG;
          End;
        End;
      End;
  Else
    Begin
      WinMsg('s', 'After Scan Not 1,8,24 bit: Image is ' + Inttostr(mg1.GetBitsPerPixel) + 'Bits.');
      WinMsg('s', 'Save format is: ' + mg1.GetFileFormatAbbr);
    End;

  End;

    ////////////////////
  AccusoftPropertiesShow;
  If mg1.PageCount = 1 Then
   { TODO -o129 : DO WE NEED TO SAVE IMAAGE...  YES.. }
   // OUT IN p129  Gear 1.SaveImage := GUserDir.Temp + 'resetfile.tif';

   //  The AspectRatio might cause problems with the new LockImageScrollBars
   (*if ErrorInGear(gear1,'Saving Scanned Image','Function : SaveImage') then
    begin
      exit;
    end; *)// Was in for 59, Errors were caught, Cant find Compress type, Cant file File type
            // but Ignore error and image is still saved okay. ?
            // it wasn't in previous versions, so... we'll wait until new accusoft to fix this.
            // below, New Parameter, says log it, but don't show it.
  ErrorInGear(mg1, 'Saving Scanned Image', 'Function : SaveImage', True);

  MagAspectRatio(1);
  mg1.update;

(*   This was clearing the mg1 control ?    
   left over from pre Accu16.  ? ?    
   This was out in 129.t17.. or 16 ?    
 // If mg1.PageCount = 1 Then
 //  mg1.LoadTheImage(GUserDir.Temp + 'resetfile.tif');
*)
    //p129 need to CHECK the LoadDocument
   //  Gear 1.LoadDocument := GUserDir.Temp + 'resetfile.tif';
  AccusoftPropertiesShow;
    { call accusoft
    If bits >1
    If 256 colors then .popularity
    If xray or bw then .gray
    If ImageType=15 then autoreduce or halftone
     }

  WinMsg('', 'TWAIN Scan completed.');

 CaptureIsValid;   {CapTwain _ }
End;

Procedure TfrmCapMain.CapClipboard(Sender: Tobject);
Begin
  WinMsg('', 'Pasting Image from Clipboard');
    //  FileSave := 'Scantemp';
    //  dirx := tempdir;
 {/p129 06/26/12  gek.  Clear annoattions before pasting in new image...}
  mg1.AnnotationComponent.ClearAllAnnotations;
  application.ProcessMessages;

  GearClear;

  If Not PasteGear Then
    Exit;

  MagAspectRatio(1);
  mg1.update;
  mg1.UpdatePageView;    //129 06/26/gek
    { call accusoft
    If bits >1
    If 256 colors then .popularity
    If xray or bw then .gray
    If ImageType=15 then autoreduce or halftone
     }
  WinMsg('', 'Clipboard Paste complete.');
  CaptureIsValid;    {CapClipboard _ }

End;

Procedure TfrmCapMain.CapImport(Sender: Tobject);
Begin
  If Lvbatch.Items.Count = 0 Then
  Begin
    WinMsg('', 'Importing Image...');
   //p129   If Not FAltViewerNeeded Then
   { Now it's up to the User if they want to user Alt Viewer for Certain Extensions.}
   if not FUsingAltViewer then
    Begin
    (*p129 out  If ((Gear 1.LoadDocument = '') Or (Gear 1.LoadDocument = BlankImage)) And
        ((Gear 1.LoadImage = BlankImage) Or (Gear 1.LoadImage = '')) Then*)
     if IsGearClear(mg1) then
        Begin
                {winmsg('','Select an Image from Import directory file listing, Then ''Capture'' Image');}
        WinMsg('', 'Click ''Cancel'' to enable Importing.  Import an Image by selecting a list entry.');
        Exit;
      End;
    End;

    MagAspectRatio(1);
    CaptureIsValid;      {CapImport _ }
  End;
    // 12/21/99 Stuart wants to stop showing this diaolg box, because it is redundant , the Image Ok
    //  dialog box accomplishes the same thing. ?
    (* if lvBatch.items.count > 0 then
       begin
       S := UPPERCASE(magpiece(lbformatdesc.Caption,'(',1));
       if POS('TRUE COLOR',S) > 0 THEN S := 'TRUE COLOR';
       if Pos('TIFF',S) > 0 THEN S := 'DOCUMENT';
       winmsg('','Batch Capture of '+inttostr(lvBatch.items.count)+ ' images. ');
       if messagedlg('Batch Capture of '+inttostr(lvBatch.items.count)+ ' images. '+#13+
                   'ALL Images will be considered '+s+' images.'+#13+
                   'OK to Continue  ? ',mtconfirmation, [mbok,mbcancel],0) = mrcancel
                   then
                   begin
                   CancelCapture;
                   winmsg('','Click ''Cancel'' to enable Importing.  Import an Image by selecting a list entry.');
                   exit;
                   end
                   else
                   CAPtureIsValid;   {  N/A  this is comment}

       end;  *)
    {   in Import, the user has already seen the imported image. It's not like
        scanning, or Meteor Freeze image where the user hasn't seen the image yet.
        So we'll save a couple mouse clicks and Click the Image Ok button
         for the user. ( on import only.)
    }
 if not CapX.m140MultSources then  //p140t1
  SetImageOK;
End;

Procedure TfrmCapMain.CapScannedDocument(Sender: Tobject);
var isopen : boolean;
var s , sfile : string;
Begin
//BEGIN Gear 1.C    CAPSCANNEDDOCUMENT ----------------------------------------CAPSCANNEDDOC
 s := 'Scanning Document, this may take a minute...';
 if CapX.m140PDFConvert then
    s := 'Scanning Document and Saving as PDF, this may take a minute...';
  WinMsg('', s);
      // ? need for mg1 ?  Gear 1.AutoReduce := IG_LOAD_COLOR_DEFAULT; { 297 GEK  }
      // No.  We are able to Set BitDepth and Compression before.
      if Not MagTWain1.IsSourceOpen then
      Begin
      isopen := MagTwain1.SourceOpenDefault;
      if not isopen then
        begin
        WinMsg('de', 'TWAIN Device is not open.' + #13
                    + 'select a TWAIN Source from the Configuration Window.') ;
        Exit;
        end;
      End;

      GearClear;
      MagTwain1.UseUI := false; //  Gear 1.ScanShowUI := False;
      { DONE -o129 : Set Bits from FmIG... variable,  and Save..... Not Here.. It's done in the Init___ methods.}    //Gear 1.ScanBits:=1;
      // 2.22.99 ScanBits are set in the ImageType INIT call i.e. INITXray, INITDocument...

        MagTwain1.SetResolution('300','300');

      MagTwain1.MagSetCapability('4386',mag_AM_TID_META_UINT16,mag_IG_DATA_LONG,'3');
      //MagTwain1.MagSetCapability(inttostr(ICAP_SUPPORTEDSIZES),mag_AM_TID_META_UINT16,mag_IG_DATA_LONG,inttostr(IG_TW_SS_LETTER));

    if (not CapX.m140MultSources) and (not CapX.m140CombineScans) then
    begin
     sfile := GUserDir.Temp + 'magPDF.pdf';
    DeleteFile(PChar(sfile));
    if fileexists(sfile)  then
      begin
        magappmsg('sd','temp File exists. ' + sfile + ' action Canceled');
        exit;
      end;
   end;



      If Not AcquireGear16 Then            {in CapScannedDocument}
         Exit; //CAPscanneddocument

     mg1.Updatepageview;

       AccusoftPropertiesShow;
      If mg1.pagecount = 1 then
       { mg1.SaveImage := GUserDir.Temp + 'resetfile.tif';}   ;

      // if Gear 1.PageCount = 1 Then
      //  Gear 1.SaveImage := GUserDir.Temp + 'resetfile.tif';

      WinMsg('', 'Document Scan complete');
      Lbviewingimage.caption := 'Image Acquired';
     // If Gear 1.PageCount = 1 Then
     //   Gear 1.LoadDocument := GUserDir.Temp + 'resetfile.tif';
      AccusoftPropertiesShow;

    (* s := '';
     if FAutoDeSkew then
       begin
        DeSkewGear();
        s := 'DeSkew '
        end;
     if FAutoDeSpeckle then
       begin
        DeSpeckleGear();
        s := s + 'DeSpeckle ';
       end;
     if s <> '' then
       begin
         s := s + 'Applied.';
         winmsg('',s);
       end;
       *)
  CaptureIsValid;     {CapScannedDocument _ }
//END Gear 1.    CAPSCANNEDDOCUMENT ----------------------------------------CAPSCANNEDDOC
End;

Procedure TfrmCapMain.CAPtestscan(Sender: Tobject);
Begin

  WinMsg('', 'Test Scan');

  MagAspectRatio(1);

  CaptureIsValid;   {CAPtestscan  _ }
End;

{here are the INIT's for input source, image format, Association, etc.}

procedure TfrmCapMain.ShowScrollSettings;
var magScrollInfo: TMagScrollInfo;
pHoriz : integer;
begin
pHoriz := mg1.GetScrollInfo.H_Pos;
magScrollInfo := mg1.GetScrollInfo();
winmsg('s','MagScrollInfo ' + #13 +
                '  H_min, H_Max , H_pos :  ' +   #13 +  '   '  +
                inttostr(magscrollinfo.H_Min) + ' ' +
                inttostr(magscrollinfo.H_Max) + ' ' +
                inttostr(magscrollinfo.H_Pos)  +   #13 +
                 ' V_min, V_Max , V_pos :  '   + #13 +  '   '   +
                inttostr(magscrollinfo.V_Min) + ' ' +
                inttostr(magscrollinfo.V_Max) + ' ' +
                inttostr(magscrollinfo.V_Pos));

magScrollInfo.Destroy;

end;

Procedure TfrmCapMain.ButtonSettings(i: Integer);
Begin
  Screen.Cursor := crDefault;
  Case i Of
    1:
      Begin
        WinMsg('', '');
                {       scanstatus := 0;}
        ImageBoxPanel.BevelOuter := bvRaised;
        btnCapture.Enabled := True;
        cbBatch.Enabled := True;
        btnCapture.SetFocus;
        btnImageOK.Enabled := False;
        btnImageOK.Default := False;
        btnCancelScan.Enabled := False;
 //old old cleanup bSendimage.Enabled := False;
        pnlimport.Enabled := True;
        pBatch.Enabled := True;

                {       bImportdir.enabled := true; }{mag32}
        MagLastImagesForm.LvLatest.Enabled := True;
        btnStudyComplete.Enabled := False;
        FrmCapConfig.GAssociation.Enabled := True;
        FrmCapConfig.GAssociation.Font.Color := clBlack;
        FrmCapConfig.GMode.Enabled := True;
        FrmCapConfig.GMode.Font.Color := clBlack;
        FrmCapConfig.GImageGroup.Enabled := True;
        FrmCapConfig.GImageGroup.Font.Color := clBlack;
        btnPatient.Enabled := True;
        If FrmCapConfig.ClinImage.Checked Then
          EnableProcDate;
        If FrmCapConfig.AdminDoc.Checked Then
          EnableProcDate;
        mSelectpatient.Enabled := True;
        LbAssocDesc.Enabled := True;
        Imagegroupdesc.Enabled := True;
        mnuClearConfigurationvalues.Enabled := True;
        Modedesc.Enabled := True;
        btnLookupdata.Enabled := True;
        If (FrmCapConfig.ImageGroup.Checked) And (Imageptrlst.Items.Count > 0) Then
                    // we are in the middle of a Group capture ..
        Begin
          btnStudyComplete.Enabled := True;
          FrmCapConfig.GAssociation.Enabled := False;
          FrmCapConfig.GAssociation.Font.Color := clGray;
          FrmCapConfig.GMode.Enabled := False;
          FrmCapConfig.GMode.Font.Color := clGray;
          FrmCapConfig.GImageGroup.Enabled := False;
          FrmCapConfig.GImageGroup.Font.Color := clGray;
          btnPatient.Enabled := False;
          DisableProcDate;
          mSelectpatient.Enabled := False;
          LbAssocDesc.Enabled := False;
          Imagegroupdesc.Enabled := False;
          mnuClearConfigurationvalues.Enabled := False;
          Modedesc.Enabled := False;
          btnLookupdata.Enabled := False;
          If FrmCapConfig.Laboratory.Checked Then
          Begin
            btnLookupdata.Enabled := True;
          End;
        End;
        WinMsg('', 'Click ''Capture'' to capture/import the Image from the input source');
        If FrmCapConfig.Import.Checked Then
        Begin
          LvImport1.Enabled := True;
          LvImport1.SetFocus;
          If cbBatch.Checked Then
            Lvbatch.Enabled := True;

          If mImportdir1.Visible Then
            mImportdir.Enabled := True;
                    {Post59}
                    //if mnuImportDirectory.visible then mnuImportDirectory.Enabled := true;
                  { winmsg('','Click ''Capture'' or select image and press ''<Enter>'' to import the Image.');}
          WinMsg('', 'Import an Image by selecting a list entry.  Click ''Capture'' or press ''<Enter>'' to capture the Image.');
        End;

      End;
    2:
      Begin
                {        Scanstatus := 1;}
        WinMsg('', 'Click ''Image OK'' to save Image, or ''Cancel'' to discard Image');
        ImageBoxPanel.BevelOuter := bvLowered;
        if (not CapX.m140MultSources)  and (not CapX.m140CombineScans) then
        btnCapture.Enabled := False;
        btnImageOK.Enabled := True;
        cbBatch.Enabled := False;
        btnCancelScan.Enabled := True;
        btnStudyComplete.Enabled := False;
if not CapX.m140MultSources then  //p140t1
        pnlimport.Enabled := False;
        pBatch.Enabled := False;
                { bImportdir.enabled := false;}{mag32}
        If mImportdir1.Visible Then
          mImportdir.Enabled := False;
                {post59}
                //if mnuImportDirectory.visible then mnuImportDirectory.Enabled := false;
        MagLastImagesForm.LvLatest.Enabled := False;
                {btnImageOK.setfocus;}{ 4/2/97 gek , for tabbing sequence change }
                  //3.0.8   with new fields, this causes problems.
                 //  btnImageOK.default := true;
                /////////edtImageDesc.setfocus;
        If FModeTest Then
        Begin
          btnImageOK.Enabled := False;
          btnCancelScan.SetFocus;
          WinMsg('', 'TEST MODE  Click ''Cancel'' to discard Image');
        End;
      End;
    3:          {3 is never used...  was in original design patch 8.}
      Begin
                {        ScanStatus := 2;}
        btnStudyComplete.Enabled := False;
        btnCancelScan.Enabled := False;
 //old old cleanup bSendimage.Enabled := True;
      End;
  End; {case}
End;

Function tfrmCapMain.OKToChangeSpec(newspec: String): Boolean;
Var
  inResult: Integer; //p106 rlm 20101022 CR562,563,564
Begin
  Result := False; {gek mag32}
// next is 106t10
{  TODO : need to check and make Import Description only the 'selectable imports'
    not any 'text' that the app puts there...  i.e. keep it as is, user selected }

//p117 gek not needed -   ImportIniDesc(); //p106 rlm 20101124 Fix Garrett's "Infinite loop dialogs"
    { TODO :
  If Not Connected and Mode = On-Line (Live) then Should we Stop the
  changing of Associations.  the Index Lists will not be loaded if we switch
  Associations with no connection to database. }
  If (UserCapDUZ <> '0') And (Not CanUserCapture(newspec)) Then
  Begin
        //ADMINDOC
    CheckCurAssoc; { fix, if user checks an Association that they can't capture to,
        the old Association (radio button) is checked again.}
    Exit;
  End;
    //if iDModObj.GetMagPat1.M_DFN = '' then begin result := true; exit; end;
    // 4/1/00
  If ((Magassoc = newspec) And (newspec = 'PHOTOID')) Then
  Begin
    Result := True;
    Exit;
  End;
    // NEXT LINE IS FOR WHEN WE ARE CHANGING BACK TO PREVIOUS ASSOCIATION.
  If Magassoc = newspec Then
  Begin
    Result := False;
    Exit;
  End;
  If Magassoc = '' Then
  Begin
    Result := True;
    Exit;
  End;
  If (Magassoc = 'LAB') And (LabPtr = '') Then
  Begin
    Result := True;
    Exit;
  End;
  If (Magassoc = 'RAD') And (RadPtr = '') Then
  Begin
    Result := True;
    Exit;
  End;
  If (Magassoc = 'NOTES') And (FCapClinDataObj.IsClear) Then
  Begin
    Result := True;
    Exit;
  End;
  If (Magassoc = 'CP') And (CPPtr = '') Then
  Begin
    Result := True;
    Exit;
  End;

  If (Magassoc = 'MED') And (MedPtr = '') Then
  Begin
    Result := True;
    Exit;
  End;
  If (Magassoc = 'SUR') And (SurPtr = '') Then
  Begin
    Result := True;
    Exit;
  End;
  If (Magassoc = 'PHOTOID') Then
  Begin
    Result := True;
    Exit;
  End;
  If (Magassoc = 'TRC') And (TRConsultPtr = '')  Then //p106 rlm 20101022 CR562,563,564
  Begin
    Result := True;
    Exit;
  End;
    // ADMINDOC
    // p8t25 ADMIN and CLIN : imgTypePtr isn't patient specific, we'll allow the change.
  If ((Magassoc = 'ADMINDOC') Or (Magassoc = 'CLINIMAGE')) Then
  Begin
    Result := True;
    Exit;
  End;
    (*if (magassoc = 'ADMINDOC') and (imgTypePtr = '') then begin result := true; exit; end;
    if (magassoc = 'CLINIMAGE') and (imgTypePtr = '') then begin result := true; exit; end;*)
    { TODO :   Could (should ? ) put a test here for If ShowConfirmation messages then }
    //p8t25 test for ShowConfirmation, before asking user if they want to confirm change.

(*  before 106 *)
  If Fconfirmmsg Then
    If Messagedlg('You already have a ' + ReadableAssoc(Magassoc) + ' selection.  Do you want to change the Association ?', Mtconfirmation, [Mbok,
      Mbcancel], 0)
      = MrCancel Then
    Begin
            //ADMINDOC
      CheckCurAssoc;
      Result := False;
      Exit;
    End;
  Result := True;
 (*     *)

EXIT;  //p117, gek  back to existing design, take out hard coded specific to TRC.
      // uncomment the 'If FConfirmmsg.... block above. 106 commented it out and used below.
(*
//This was 106.. but isn't needed.  The CheckCurAssoc function will Check the appropriate button
// and that action of checking, will display the correct descriptions.
  If Fconfirmmsg Then
    inResult:=Messagedlg('You already have a ' + ReadableAssoc(Magassoc) + ' selection.  Do you want to change the Association ?', Mtconfirmation, [Mbok,Mbcancel], 0);
    If inResult= MrCancel Then //p106 rlm 20101022 CR562,563,564
    Begin
            //ADMINDOC
      CheckCurAssoc;
      //p106 rlm 20101022 start CR562,563,564
    //106 put in the IF's ... is this where want it   .. or qad change that needs fixed.
{ TODO : the flow of this funciton... .. or qad change that needs fixed.  }
      If Magassoc = 'TRC' Then
      Begin
        If Not FrmCapConfig.TeleReaderConsult.Checked Then FrmCapConfig.TeleReaderConsult.Checked:=True;
        If Not FrmCapConfig.DICOMFormat.Checked Then FrmCapConfig.DICOMFormat.Checked:=True;
        If Not FrmCapConfig.Import.Checked Then FrmCapConfig.Import.Checked:=True;
        If Not (lbformatdesc.Caption='DICOM(VL Photo Image Storage)') Then lbformatdesc.Caption:='DICOM(VL Photo Image Storage)';
      End;
      //p106 rlm 20101022 end CR562,563,564
      Result := False;
      Exit;
    End;
    If inResult= MrOK Then  //p106 rlm 20101105 CR562
    Begin
    //p117 out.  back to existing design.  FrmCapConfig.INITAssociationVars();
    End;
  Result := True;
  *)
End;
//ADMINDOC

Function TfrmCapMain.ReadableShortAssoc(Magassoc: String): String;
Begin
  Magassoc := Uppercase(Magassoc);
  Result := 'Unknown';
  If Magassoc = 'MED' Then
    Result := 'Medicine';
  If Magassoc = 'RAD' Then
    Result := 'Radiology';
  If Magassoc = 'LAB' Then
    Result := 'Laboratory';
  If Magassoc = 'SUR' Then
    Result := 'Surgery';
  If Magassoc = 'NOTES' Then
    Result := 'Progress Note';
  If Magassoc = 'CLINIMAGE' Then
    Result := 'Clinical';
  If Magassoc = 'PHOTOID' Then
    Result := 'Photo ID';
  If Magassoc = 'CLINPROC' Then
    Result := 'Clinical Procedure';
  If Magassoc = 'TRC' Then  //p106 rlm 20101021 CR561 //If Magassoc = 'TRCONSULT' Then
    Result := 'TeleReader Consult';
  If Magassoc = 'ADMINDOC' Then
    Result := 'Administrative';

End;

Function TfrmCapMain.ReadableAssoc(Magassoc: String): String;
Begin
  Result := 'Unknown';
  If Magassoc = 'MED' Then
    Result := 'Medicine Procedure';
  If Magassoc = 'RAD' Then
    Result := 'Radiology Exam';
  If Magassoc = 'LAB' Then
    Result := 'Laboratory Specimen';
  If Magassoc = 'SUR' Then
    Result := 'Surgery Case';
  If Magassoc = 'NOTES' Then
    Result := 'Progress Note';
  If Magassoc = 'CLINIMAGE' Then
    Result := 'Clinical Image';
  If Magassoc = 'PHOTOID' Then
    Result := 'Photo ID';
  If Magassoc = 'CLINPROC' Then
    Result := 'Clinical Procedure';
  If Magassoc = 'TRC' Then //p106 rlm 20101021 CR561 //If Magassoc = 'TRCONSULT' Then
    Result := 'TeleReader Consult';
  If Magassoc = 'ADMINDOC' Then
    Result := 'Administrative Document';

End;
Function TfrmCapMain.ReadableShortAssocRBName(rbname: String): String;
Begin
rbname := uppercase(rbname);
  Result := rbname;
  If rbname = 'MEDICINE' Then      //
    Result := 'Medicine';

  If rbname = 'RADIOLOGY' Then   //
    Result := 'Radiology';

  If rbname = 'LABORATORY' Then      //
    Result := 'Laboratory';

  If rbname = 'SURGERY' Then    //
    Result := 'Surgery';

  If rbname = 'TIU' Then          //
    Result := 'Progress Note';

  If rbname = 'CLINIMAGE' Then     //
    Result := 'Clinical';

  If rbname = 'PHOTOID' Then      //
    Result := 'Photo ID';

  If rbname = 'CLINPROC' Then       //
    Result := 'Clinical Procedure';

  If rbname = 'TELEREADERCONSULT' Then      //
    Result := 'TeleReader Consult';

  If rbname = 'ADMINDOC' Then        //
    Result := 'Administrative';

End;


Procedure TfrmCapMain.CheckCurAssoc;
Begin
  If Magassoc = '' Then
  Begin
    UnCheckAllAssoc;
    Exit;
  End;
  If Magassoc = 'LAB' Then
    FrmCapConfig.Laboratory.Checked := True;
  If Magassoc = 'RAD' Then
    FrmCapConfig.Radiology.Checked := True;
  If Magassoc = 'MED' Then
    FrmCapConfig.Medicine.Checked := True;
  If Magassoc = 'NOTES' Then
    FrmCapConfig.Tiu.Checked := True;
  If Magassoc = 'CP' Then
    FrmCapConfig.ClinProc.Checked := True;
  If Magassoc = 'SUR' Then
    FrmCapConfig.Surgery.Checked := True;
  If Magassoc = 'PHOTOID' Then
    FrmCapConfig.PhotoID.Checked := True;
  If Magassoc = 'TRC' Then
    FrmCapConfig.TeleReaderConsult.Checked := True;//p106 rlm 20101022 CR562,563,564
    // ADMINDOC
  If Magassoc = 'ADMINDOC' Then
    FrmCapConfig.AdminDoc.Checked := True;
  If Magassoc = 'CLINIMAGE' Then
    FrmCapConfig.ClinImage.Checked := True;
End;

Procedure TfrmCapMain.UnCheckAllAssoc;
Begin
  With FrmCapConfig Do
  Begin
    Laboratory.Checked := False;
    Radiology.Checked := False;
    Medicine.Checked := False;
    Tiu.Checked := False;
    ClinProc.Checked := False;
    Surgery.Checked := False;
    PhotoID.Checked := False;
    AdminDoc.Checked := False;
    ClinImage.Checked := False;
    TeleReaderConsult.Checked := False;//p106 rlm 20101022 CR562,563,564
  End;
End;

Procedure TfrmCapMain.DisableProcDate;
Begin

    //10.16.2002 edtProcDate.enabled := false;
  EdtProcDate.TabStop := False;
  EdtProcDate.ReadOnly := True;
  EdtProcDate.Enabled := False;
  btnProcDate.Enabled := False;
  EdtProcDate.Color := clBtnFace;
End;

Procedure TfrmCapMain.EnableProcDate;
Begin

  EdtProcDate.Enabled := True;
  EdtProcDate.TabStop := True;
  EdtProcDate.ReadOnly := False;
  EdtProcDate.Enabled := True;
  btnProcDate.Enabled := True;
  EdtProcDate.Color := clWindow;
End;

Procedure TfrmCapMain.MakeStudyReadOnly;
Begin
  EdtStudy.Text := '';
  Edtnoteinfo.Text := '';
  Edtnoteinfo.Hint := 'Type of Selected Note - Intended Status - Location';
  PnlNoteGlyph.Visible := False;

  EdtStudy.TabStop := False;
  EdtStudy.ReadOnly := True;
  EdtProcDate.Text := '';
  EdtProcDate.TabStop := False;
  EdtProcDate.ReadOnly := True;
  EdtProcDate.Enabled := False; //5/16/2006  /p59
  btnProcDate.Enabled := False;
  EdtProcDate.Color := clBtnFace;
  mnuProcHoldValue.PopupComponent := (LbStudy);
  LinkHoldValues(LbStudy.NoClear);
End;

Function TfrmCapMain.AbleToTeleconsult;
Begin
  Result := True;
End;

Function TfrmCapMain.ShowFmDate(fmdate: String): String;
Var
  x: String;
Begin
  Result := 'Error converting date';
  x := MagPiece(fmdate, '.', 1);
  Result := Copy(x, 4, 2) + '/' + Copy(x, 6, 2) + '/' + Copy(x, 2, 2);
End;

Procedure TfrmCapMain.LOOKUPmedicine(Sender: Tobject);
Var
  s: String;
Begin
  DateTimeProc := '';
  EdtProcDate.Text := '';

  If Not IsPatientSelected Then
    Exit;
  If Not CanUserCapture(Magassoc) Then
    Exit;
  If MAGGMCF.DFN.caption <> iDModObj.GetMagPat1.M_DFN Then
    MAGGMCF.SetPatientName(iDModObj.GetMagPat1);
  MAGGMCF.Showmodal;
  If MAGGMCF.ModalResult = MrOK Then
  Begin
    MedPtr := MAGGMCF.DataString.caption;
    EdtStudy.Text := MagPiece(MedPtr, '^', 5); // THIS is the abbrev of SubSpeciatly
    DateTimeProc := MagPiece(MedPtr, '^', 1);
        {edtProcDate.Text  := MAGPIECE(DateTimeProc,'@',1);}{ gek 6/04/97}
    EdtProcDate.Text := DateTimeProc;
    AutoImageDesc(MagPiece(MedPtr, '^', 5) + '  ' + MagPiece(EdtProcDate.Text, '@', 1), magdescPkg);
        { NEW FOR DICOMID NEEDED FOR LUCILLE }
    XBROKERX.PARAM[0].Value := MedPtr;
    XBROKERX.PARAM[0].PTYPE := LITERAL;
    XBROKERX.REMOTEPROCEDURE := 'MAGG MED DICOMID';
    Try
      s := XBROKERX.STRCALL;
    Except
      WinMsg('', 'Error attempting MAGG MED DICOMID Call');
    End;
    If MagPiece(s, '^', 1) = '0' Then
    Begin
      WinMsg('s', 'DicomID =>  ' + MagPiece(s, '^', 2));
      LbDicom.caption := ''; {here, mon 4/27/98}
    End
    Else
    Begin
      LbDicom.caption := MagPiece(s, '^', 2);
      WinMsg('s', LbDicom.caption + '   ' + EdtStudy.Text + '  ' + EdtProcDate.Text);
    End;
        {end new stuff for DICOMID  for lucille}
    FEdtLV.GenGoToNextControl(btnLookupdata);
  End
  Else
  Begin
        {MedPtr := '';
        lbDicom.caption := '';
        }
  End;

End;

{WPR ? There are many changes to the LookupTIU Call to
  implement all the changes to TIU interface}

Procedure TfrmCapMain.LOOKUPtiu(Sender: Tobject);
Var
  s, Rmsg: String;
  VClinDataobj: TClinicalData;
  CanEFile: Boolean;
Begin
  VClinDataobj := TClinicalData.Create;
  Try
    Try
            { TODO : Do we want to do this?  We do it now for all LOOKUP's
             Answer NO, we don't want to clear this}
            //	FCapClinDataObj :=  nil;// .clear
            //{59 stop clearing these} DateTimeProc := '';   // have to rethink this.
            //{59 stop clearing these} edtProcDate.Text := '';     // have to rethink this.
            {}
      If Not IsPatientSelected(False) Then
      Begin
        OpenPatient;
        If Not IsPatientSelected(False) Then
          Exit;
      End;
      If Not CanUserCapture(Magassoc) Then
        Exit;
            {1   	Assign current settings from FCapClinDataObj
                        to vClinDataObj to set defaults in the TIU window.}
      VClinDataobj.Assign(FCapClinDataObj);
      VClinDataobj.Pkg := '8925';
      If VClinDataobj.NewAuthorDUZ = '' Then
      Begin
        VClinDataobj.NewAuthorDUZ := UserCapDUZ;
        VClinDataobj.NewAuthor := userCapname;
      End;
            {2 			late addition, use Key to allow E-File}
      CanEFile := Userhaskey('MAG NOTE EFILE');
            {3 			This opens the window, allows user to select TIU Note properties.
                The ClinDataObj is up dated to reflect what the user has choosen.
                then we continue.}
      {129t17  fix the Addendum Date label.  Now it is always set to Note Date, and Changed
               to Addendum Date, if the user has selected 'Make Addendum ' checkbox in TIU Window.}
      if VClinDataObj.NewAddendum then VClinDataObj.NewAddendum := false;
      if (Pos('Addendum',lbProcDate.Caption) > 0) then lbProcDate.Caption := '*Note Date';

{ ********************   Call the Progress Note window,  send VClinDataObj, ******************** }
{                         and use VClinDataObj on return to  see what the                        }
{ ********************       User Selected in the Progress Note Window      ******************** }

      If FCapClinMgr.OpenNoteWindow(iDModObj.GetMagPat1, VClinDataobj, FuprefCapTIU, CanEFile) Then
      Begin {  user has selected a note, or is creating a new note, or
                is attaching an Addendum to an existing Note}
        If Not TIUAuthorized(Rmsg, VClinDataobj) Then
        Begin
          If Not VClinDataobj.AttachOnly Then
          Begin
            s := Rmsg + #13 + #13
              + 'Action on the Note is Cancelled.';  {/p122 dmmn WPR Capture Item #20 /}
            Messagedlg(s, MtWarning, [Mbok], 0);
            WinMsg('', Rmsg + #13 + ' Action Cancelled.');
          End;
        End
        Else
        Begin
          If VClinDataobj.NewAddendum Or VClinDataobj.NewNote Then
          Begin
            {Allow the editing of the Note Date for New Notes/Addenda}
            {HERE HERE}
            EnableProcDate;
          End;
          WinMsg('', 'Note Selection complete.');
          FCapClinDataObj.Assign(VClinDataobj);
          LoadFieldsFromTIUData(FCapClinDataObj);
          FEdtLV.GenGoToNextControl(btnLookupdata);
        End;
      End
      Else
      Begin
                {  User clicks Cancel, we don't want to erase previous
                   selected Note, but we were before  i.e. tiuptr := '';}
                // FCapClinDataObj := nil;
        WinMsg('', 'Cancelled Note Selection.');    {/p122 dmmn WPR Capture Item #20 /}
      End;
    Except
            // FCapClinDataObj := nil;
    End;
  Finally
    VClinDataobj.Free;
  End;
End; {lookuptiu }
(*
  NewAuthor: string;          {File 200 New Person: Author's Name}
  NewAuthorDUZ: string;       {File 200 New Person: Author's DUZ}
  NewDate: string;            {Date internal or external}
  NewLocation: string;        {Hospital Location File  44 Name}
  NewLocationDA: string;      {Hospital Location File  44 DA}
  NewStatus: string;          {un-signed,AdminClosuer,Signed}
  NewTitle: string;           {TIU DOCUMENT DEFINITION 8925.1   Name }
  NewTitleDA: string;         {TIU DOCUMENT DEFINITION 8925.1   DA}
  NewTitleIsConsult: boolean; {Title is a Consult, must have Consult DA}
  NewTitleConsultDA : string; {The Patient Consult DA, we link to the Note.}
  NewVisit: string;           { NOT USED, THE TIU CALL, computes Visit}
  NewAddendum: Boolean;      {}
  NewAddendumNote: string;   {TIU Doucment 8925 IEN}
  NewNote: Boolean;          {}
  NewNoteDate: string;        {}
  NewText : Tstringlist;      { If user is adding text.}
  Pkg: string;                {8925 for TIU.}
  PkgData1: string;           {not used}
  PkgData2: string;           {not used}
  ReportData: TMagTIUData;    {if a selected note, this is the data}
  *)

Function TfrmCapMain.TIUAuthorized(Var Rmsg: String; VClinDataobj: TClinicalData): Boolean;
Var
  Vstat: Boolean;
  Vmsg: String;
Begin
  Rmsg := 'Verifying Authorization...';
  Result := False;
  Try
        {1			 Verify different actions depending on the TClinicalData object.}
    If VClinDataobj.NewAddendum Then
    Begin
            { 		Verify that user can MAKE ADDENDUM to the selected Note}
      iDModObj.GetMagDBBroker1.RPTIUAuthorization(Vstat, Vmsg, VClinDataobj.NewAddendumNote, 'MAKE ADDENDUM');
      If Vstat Then
        Result := True
      Else
        Rmsg := 'Authorization Failure:  ' + Vmsg;
      Exit;
    End;
    If VClinDataobj.AttachToSigned Then
    Begin
            {	 An Image attached to a Signed Note is considered an Addendum itself}
            { 	 Same as above, but maybe not for long.}
            { 	Verify that user can MAKE ADDENDUM to the selected Note}
             (*  59 IN 59 OUT  This was causing problems and isn't in the SRS, so this extra Authorization
                 check is out for now.
            iDModObj.GetMagDBBroker1.RPTIUAuthorization(vstat,vmsg,vClinDataObj.ReportData.TIUDA,'MAKE ADDENDUM');
            if vstat
                then result := true
                else rmsg := 'Authorization Failure:  '+vmsg;
            exit;
            *)
    End;
    If VClinDataobj.AttachToUnSigned Then
    Begin
            {	Verify that the user can EDIT this RECORD, i.e. Change Status.}
            { 	If the Note has just been created, and is locked, this will
              STOP us from changing status, or attaching an Image.}
      iDModObj.GetMagDBBroker1.RPTIUAuthorization(Vstat, Rmsg, VClinDataobj.ReportData.TiuDA, 'EDIT RECORD');
      If Not Vstat Then
      Begin
                { .... Above Stops the same user from opening Note in CPRS, Attaching
                an image.  Finishing note in CPRS and exiting... So  If User is same as
                Author of Note, and Note is 'unsigned' or 'uncosigned' We'll let user
                Attach Image, but not change status.}
        If VClinDataobj.ReportData.AuthorDUZ = UserCapDUZ Then
        Begin
          If Messagedlg('Your Document:  ' + VClinDataobj.ReportData.Title + #13
            + 'Status:         ' + Rmsg + #13 + #13
            + 'You cannot make changes to the Document, only attach the Image.' + #13
            + #13 + 'Continue attaching Image ? ', MtWarning, [MbYes, Mbcancel]
            , 0) = MrYes Then
          Begin
                        {    Flag that says only attach Image, no other changes.}
                        {     AttachOnly is true, if Note is Locked For Editing,
                              user has been prompted,  and elected to override
                              lock and attach Image to their Unsigned Note anyway}
            VClinDataobj.AttachOnly := True;
            VClinDataobj.NewStatus := '0'; { change to UnSigned}
            VClinDataobj.NewText.Clear; { Clear any Text}
            Rmsg := 'Continue attaching Image.';
          End
          Else
          Begin
                        { Flag that says user wants to cancel the selection }
            VClinDataobj.AttachOnly := False;
            Rmsg := 'Note selection was cancelled by user.';    {/p122 dmmn WPR Capture Item #20 /}
            Exit;
          End;
        End
        Else
        Begin

          Exit;
        End;
      End; {IF not Rstat}
    End; {if vClinDataObj.Attach To Un Signed then}

        {We dont' test for Authorization to Create a New Note
           That test is done by TIU Utilities, and .. anyone can create a note.}
        (*   if vClinDataObj.NewNote then
               begin
               { Verify that user can MAKE ADDENDUM to the selected Note}
               iDModObj.GetMagDBBroker1.RPTIUAuthorization(vstat,vmsg,vClinDataObj.NewAddendumNote,'MAKE ADDENDUM');
               if vstat
                   then result := true
                   else rmsg := 'Authorization Failure:  '+vmsg;
               exit;
               end; *)

        {Other Actions to verify Here ? }
    Result := True;
    Rmsg := 'Ok';
  Except
    On e: Exception Do
    Begin
      Rmsg := e.Message;
      Result := False;
    End;
  End;
End;

{     There will be a need to know if we are Loading Fields from a
      Saved Configuration, or from a Return from the CapTIU Window.
      This call is made when applying a Saved Configuration.}

Procedure TfrmCapMain.LoadFieldsFromClinicalData(VClinDataobj: TClinicalData);
Begin
    {     We're here because we are applying a Saved Configuration.}
  LoadFieldsFromTIUData(VClinDataobj);
  WinMsg('s', '>> Loading Note Data from Saved Configuration...');
  If (VClinDataobj.NewText.Count > 0) Then
    WinMsg('s', 'In a Saved Config: vClinDataObj.NewText HAS TEXT !!')
  Else
    WinMsg('s', 'In a Saved Config: vClinDataObj.NewText is empty. OK');

    {     from a Configuration for an Existing Note, the Date Time will incorrectly
          be set to NOW, this fixes that. }
  If (VClinDataobj.NewAddendum Or VClinDataobj.NewNote) Then
  Begin
    DateTimeProc := '';
    EdtProcDate.Text := '';
  End;

End;
{HERE HERE COMPARING 122RCA  with 129 }
Procedure TfrmCapMain.ShowNoteGlyphs(VClinDataobj: TClinicalData);
Var
  Rstat: Boolean;
  Rmsg: String;
  t: Tstringlist;
  i: Integer;
Begin

  ImgNoteNoText.Visible := False;
  ImgNoteText.Visible := False;
  ImgNoteText.Hint := '';
  ImgNoteBoiler.Visible := False;
  ImgNoteBoiler.Hint := '';
  PnlNoteBtns.Visible := False;
{/p129 gek fix the annoying blank edit box that shows gray over other editboxes.  Not a Remedy}
  if VClinDataObj.Pkg <> '8925' then exit;
  PnlNoteBtns.Visible := true;

  If (VClinDataobj.NewNote Or VClinDataobj.NewAddendum) Then
  Begin
    PnlNoteBtns.Visible := true;
    ImgNoteNoText.Visible := (VClinDataobj.NewText.Count = 0);
    ImgNoteText.Visible := (VClinDataobj.NewText.Count > 0);
    If ImgNoteText.Visible Then
    Begin
      ImgNoteText.Hint := 'Text has been entered in the New Note/Addendum: ' + #13;
      For i := 0 To 25 Do
      Begin
        If i > (VClinDataobj.NewText.Count - 1) Then
          Break;
        ImgNoteText.Hint := ImgNoteText.Hint + VClinDataobj.NewText[i] + #13;
      End;
      If VClinDataobj.NewText.Count > 26 Then
        ImgNoteText.Hint := ImgNoteText.Hint + '. . . <there is more> '
    End
    Else
      ImgNoteText.Hint := 'Text has been entered in the New Note/Addendum';
  End;
  If VClinDataobj.NewNote And ImgNoteNoText.Visible Then
  Begin
    If iDModObj.GetMagPat1.M_DFN = '' Then
      Exit;
    Try
      t := Tstringlist.Create;
            {check for BoilerPlate Text}
      iDModObj.GetMagDBBroker1.RPTIULoadBoilerplateText(Rstat, Rmsg, t, VClinDataobj.NewTitleDA,
        iDModObj.GetMagPat1.M_DFN);
      ImgNoteBoiler.Visible := Rstat;
        PnlNoteBtns.Visible := Rstat;
      If ImgNoteBoiler.Visible Then
        ImgNoteBoiler.Hint := 'There is BoilerPlate text for this Note: ' + #13 + t.Text; //
    Finally
      t.Free;
    End;
  End;
End;

Procedure TfrmCapMain.LoadFieldsFromTIUData(VClinDataobj: TClinicalData);
Var
  Xmsg, ResDateTime: String;
//    i : integer;
Begin
    {TODO: Still want NOTE in Procedure Field.  Just Display
           the title, but save 'NOTE'}
     {if vClinDataObj = nil, we shouldn't get here}

    {       PROCEDURE  .LoadFieldsFromTIUData(vClinDataObj : TClinicaldata);}

  DateTimeProc := '';
  EdtStudy.Text := '';
  Edtnoteinfo.Text := '';
  Edtnoteinfo.Hint := 'Type of Selected Note - Intended Status - Location';

  PnlNoteGlyph.Visible := False;
  btnVLDef.Visible := False;

  EdtProcDate.Text := '';
  ShowNoteGlyphs(VClinDataobj);
  If VClinDataobj.IsClear Then
    Exit;
  If VClinDataobj.ReportData <> Nil Then
  Begin
    EdtStudy.Text := VClinDataobj.ReportData.Title;
        //  DateTimeProc := showfmdate( vClinDataObj.ReportData.intDT);
    If Not (VClinDataobj.NewAddendum Or VClinDataobj.NewNote) Then
    Begin
      DateTimeProc := FmtoDispDt(VClinDataobj.ReportData.IntDT, True, '@');
      If RPFileManDate(Xmsg, DateTimeProc, ResDateTime, True) Then
      Begin
                {try allowing TIME}
        DateTimeProc := MagPiece(ResDateTime, '^', 1);
      End;
      EdtProcDate.Text := DateTimeProc;
    End;
    If VClinDataobj.NewAddendum Then
      LbProcDate.caption := '*Addendum Date';
  End
  Else
  Begin
    LbProcDate.caption := '*Note Date';
    EdtStudy.Text := VClinDataobj.NewTitle;
        //5/16/2006  //p59 Not defaulting to NOW.
        (*  if edtProcDate.Text = '' then
            begin
            DateTimeProc := formatdatetime('mm/dd/yyyy@hh:mm',Now);
            if RPFileManDate(xmsg, DateTimeProc, resDateTime,TRUE) then
                  begin
                  {try allowing TIME}
                  DateTimeProc := magpiece(resDateTime, '^', 1);
                  end   ;
            edtProcDate.Text := DateTimeProc;
            end;
         *)
  End;
  AutoImageDesc(EdtStudy.Text, magdescPkg);
  Edtnoteinfo.Text := VClinDataobj.GetActStatLong;
  Edtnoteinfo.Hint := Edtnoteinfo.Text;

  LoadNoteGlyphs(VClinDataobj);
  If VClinDataobj.NewNote Then
    btnVLDef.Visible := True;
  If VClinDataobj.NewAddendum Or VClinDataobj.NewNote Then
  Begin
    EnableProcDate;
    NoteDateCheck;
  End
  Else
    disableProcDate;
    (*  Types that we use now:
                            type TmagTIUData = class(Tobject)
                              public
                                tiuda: integer;
                                intDT: string;
                                DispDT: string;
                                title: string;
                                AuthorDUZ: string;
                                AuthorName: string;
                                PatientName: string;
                                DFN: integer;
                                status: string;
                              end;

                              datastring := inttostr(TIUObj.tiuda) + '^' +
                                TIUObj.TItle + '^' +
                                TIUObj.intDT + '^' +
                                TIUObj.PatientName + '^' +
                                TIUObj.AuthorDUZ + ';' +
                                TIUObj.AuthorName; //+'^'+  *)



  {/p122 dmmn 8/11 - Check to see if the ProgressNote is completed or not. If
  annotation panel is visible then check and update all existing annotation marks,
  then update AnnotationComponent to reflect the TIU status. If the status is changed
  to something else then undo the changes /}
{TODO -o129 : there is a new function in 129 to compute ConsultResulted,,  check to 
         see if it can be called here.}
//  if (Not fCapAnnot.NoAnnotaionComponent) and (fCapAnnot.MarkCount > 0)
//  if Edtnoteinfo.Text = 'Completed-Completed' then
  if VClinDataObj.NewNote then  // new note
  begin
    // 1 efiled, 2 signed, 0 unsigned
    if (VClinDataObj.NewStatus = '1') or (VClinDataObj.NewStatus = '2') then
      FCapAnnotConsultResulted := True
    else
      FCapAnnotConsultResulted := False;
  end
  else  // attached to old note
  begin
    //p122t7 dmmn 10/23 - fix exception error when use use a saved configuration
    // that has TIU fields
    if VClinDataobj.ReportData = nil then
    begin
      FCapAnnotConsultResulted := False;
      Exit;
    end;
    if UpperCase(VClinDataobj.ReportData.Status) = 'COMPLETED' then {/p122 dmmn WPR Capture Item #14/}
      FCapAnnotConsultResulted := True
    else
      FCapAnnotConsultResulted := False;
  end;

End;

Procedure TfrmCapMain.LoadNoteGlyphs(VClinDataobj: TClinicalData);
Var
  l1, l2: Integer;
Begin
  l1 := 0;
  l2 := 0;

    //pnlNoteGlyph.visible := false;
    {TODO: somewhere, maybe a new Label control next to Note Date, will show
           the Author, if the Author is different than User.
           Also, need to show author if edtNoteInfo.text is used instead of Glyphs.}
  If Not FuprefCapTIU.UseNoteGlyphs Then
    Exit;
  btnVLdef1.Visible := False;
  lbglyLocation.caption := '';
  lbglyLocation.Hint := 'Hospital Location';

  imglyNoteNew.Visible := False;
  imglyNoteAddendum.Visible := False;
  imglyNoteComplete.Visible := False;
  imglyNoteUnSigned.Visible := False;
  imglyNoteNew.Top := 2;
  imglyNoteAddendum.Top := 2;
  imglyNoteComplete.Top := 2;
  imglyNoteUnSigned.Top := 2;

  imglyStatusSigned.Visible := False;
  imglyStatusEFiled.Visible := False;
  imglyStatusComplete.Visible := False;
  imglyStatusUnSigned.Visible := False;
  imglyStatusSigned.Top := 2;
  imglyStatusEFiled.Top := 2;
  imglyStatusComplete.Top := 2;
  imglyStatusUnSigned.Top := 2;

  If VClinDataobj.NewAddendum Then
  Begin
    imglyNoteAddendum.Visible := True;
    l1 := imglyNoteAddendum.Left + imglyNoteAddendum.Width;
  End;
  If VClinDataobj.NewNote Then
  Begin
    imglyNoteNew.Visible := True;
    l1 := imglyNoteNew.Left + imglyNoteNew.Width;
    btnVLDef1.Visible := True;
  End;
  If VClinDataobj.AttachToSigned Then
  Begin
    imglyNoteComplete.Visible := True;
    l1 := imglyNoteComplete.Left + imglyNoteComplete.Width;
  End;
  If VClinDataobj.AttachToUnSigned Then
  Begin
    imglyNoteUnSigned.Visible := True;
    l1 := imglyNoteUnSigned.Left + imglyNoteUnSigned.Width;
  End;

  If VClinDataobj.NewStatus = '0' Then
  Begin
    imglyStatusUnSigned.Visible := True;
    imglyStatusUnSigned.Left := l1;
    l2 := imglyStatusUnSigned.Left + imglyStatusUnSigned.Width;
  End;
  If VClinDataobj.NewStatus = '1' Then
  Begin
    imglyStatusEFiled.Visible := True;
    imglyStatusEFiled.Left := l1;
    l2 := imglyStatusEFiled.Left + imglyStatusEFiled.Width;
  End;
  If VClinDataobj.NewStatus = '2' Then
  Begin
    If VClinDataobj.AttachToSigned Then
    Begin
      imglyStatusComplete.Visible := True;
      imglyStatusComplete.Left := l1;
      l2 := imglyStatusComplete.Left + imglyStatusComplete.Width;
    End
    Else
    Begin
      imglyStatusSigned.Visible := True;
      imglyStatusSigned.Left := l1;
      l2 := imglyStatusSigned.Left + imglyStatusSigned.Width;
    End;
  End;

  If (VClinDataobj.NewLocation <> '') Then
  Begin
    lbglyLocation.caption := VClinDataobj.NewLocation;
    lbglyLocation.Hint := 'Hospital Location - ' + VClinDataobj.NewLocation;
    lbglyLocation.Left := l2;
  End;
  PnlNoteGlyph.Visible := True;

End;

Procedure TfrmCapMain.LOOKUPClinProc(Sender: Tobject);
Begin
  Try
    DateTimeProc := '';
    EdtProcDate.Text := '';
    If Not IsPatientSelected Then
      Exit;
    If Not CanUserCapture(Magassoc) Then
      Exit;
    MagClinProc.SetPatientName(iDModObj.GetMagPat1);
    If (MagClinProc.NumberOfRequests = 0) Then
      Exit;
    MagClinProc.Showmodal;
        //winwinmsg('s','Opening Clinical Procedures Request selection...');
    If MagClinProc.ModalResult = MrOK Then
    Begin
      LoadFieldsFromClinProcData(MagClinProc.DataString);
            //winwinmsg('s','OK clicked: data = '+magClinProc.datastring);
      //winwinmsg('s','OK clicked: cpPtr now = '+cpPtr);
      FEdtLV.GenGoToNextControl(btnLookupdata);
    End
    Else
    Begin
      CPPtr := '';
            //winwinmsg('s','ClinProc Cancel clicked: cpPtr now = '+cpPtr);
    End;
  Except
    CPPtr := '';
  End;
End; {lookuptiu }

Procedure TfrmCapMain.LoadFieldsFromClinProcData(DataString: String);
Var
  consentform: String; //CPMOD
Begin
  CPPtr := DataString;
    //CPMOD
  If (MagPiece(CPPtr, '^', 6) = '1') Then
    consentform := 'CONSENT '
  Else
    consentform := '';
    // patch 7 Ruth doesn't want long Procedure Text names.
  EdtStudy.Text := 'CP '; // + Magpiece(cpPtr, '^', 2);
  AutoImageDesc(consentform + MagPiece(CPPtr, '^', 2), magdescpkg);
  DateTimeProc := MagPiece(CPPtr, '^', 3);
    // we are already in External format
    //datetimeproc := showfmdate(datetimeproc);
  // a new date function put in 106
  DateTimeProc := ShowFmDateMMMNoTime(DateTimeProc); //p106 rlm CR604
  EdtProcDate.Text := DateTimeProc;
End;

Procedure TfrmCapMain.LOOKUPlaboratory(Sender: Tobject);
Var
  Xmsg: String;
Begin
  DateTimeProc := '';
  EdtProcDate.Text := '';
  If Not CanUserCapture(Magassoc) Then
    Exit;
    { If MagDFN = '' then
        begin
        winmsg('d','You need to Select a Patient');
        exit;
        end;  }
  If cbMicro.Items.Count = 0 Then
    loadlablists;

  Magglabf.InitPatient(iDModObj.GetMagPat1.M_DFN);

    { if a group do we have to disable the section, accession yr, accesion number ?  }

  Magglabf.Showmodal;
  If Magglabf.ModalResult = MrOK Then
  Begin
    If iDModObj.GetMagPat1.M_DFN <> Magglabf.Ldfn.Text Then
    Begin
//TP - IF CPRS START ME w/ selected patient
      if caprunMode = magrmCPRS then                 {LOOKUPlaboratory}
      Begin
        { TODO -o129 : change the messagedlg to use MagAppMsg to it's tracked.}
        Messagedlg('Selected Accession different from CPRS patient, No change.', Mtconfirmation, [Mbok, Mbcancel], 0); //TP
        Exit;
      End
      Else
        OpenPatient;
//TP
      ClearCurrentPatient(True);
            //magDFN:=magglabf.ldfn.text;
      { DONE : Have to Clear MagPat1 in Dmod, then Switch to Patient LABDFN }
         //00t 6/30/02   if not GetPatientInfo(magglabf.ldfn.text) then exit;
      If Not iDModObj.GetMagPat1.SwitchTopatient(Magglabf.Ldfn.Text, Xmsg) Then
      Begin
        WinMsg('', Xmsg);
        Exit;
      End;
      MagPatMenu.AddItem(iDModObj.GetMagPat1.M_NameDisplay, iDModObj.GetMagPat1.M_DFN, iDModObj.GetMagPat1.M_Demog);
      PtSSN.Text := iDModObj.GetMagPat1.M_SSNdisplay;
      EdtPatName.Text := iDModObj.GetMagPat1.M_NameDisplay;
      UpdateWindowcaption;
    End;
    LabPtr := Magglabf.Selection.caption;
    If EAccessionNo.Text <> MagPiece(LabPtr, '^', 4) Then
    Begin
      cbMicro.ItemIndex := -1;
      cbStain.ItemIndex := -1;
    End;
    EAccessionNo.Text := MagPiece(LabPtr, '^', 4); { assession # i.e. S93-1 }
    AutoImageDesc(EAccessionNo.Text, magdescpkg); { + '  ' + MagPiece(LabPtr,'^',6);} {gek 4/2/97}
    EdtStudy.Text := 'LAB';
    DateTimeProc := MagPiece(LabPtr, '^', 3);
    EdtProcDate.Text := DateTimeProc;
    FEdtLV.GenGoToNextControl(btnLookupdata);
  End
  Else
  Begin
    LabPtr := '';
  End;

    {magglabf.destroy;}
End;

Procedure TfrmCapMain.LOOKUPradiology(Sender: Tobject);
Begin
  DateTimeProc := '';
  EdtProcDate.Text := '';
  If Not IsPatientSelected Then
    Exit;
  If Not CanUserCapture(Magassoc) Then
    Exit;
  If Maggridf.RadExamlist(iDModObj.GetMagPat1.M_DFN) = 0 Then
    Exit;
  Maggridf.Panel1.caption := iDModObj.GetMagPat1.M_NameDisplay;
  Maggridf.Showmodal;
  If Maggridf.ModalResult = MrOK Then
  Begin
    RadPtr := Maggridf.Selection.caption;
    EDayCaseNo.Text := MagPiece(RadPtr, '^', 2);
    AutoImageDesc(MagPiece(RadPtr, '^', 3), magdescPkg);
    EdtStudy.Text := 'XRAY';
    DateTimeProc := MagPiece(RadPtr, '^', 13);
    EdtProcDate.Text := MagPiece(RadPtr, '^', 12);
    FEdtLV.GenGoToNextControl(btnLookupdata);
  End
  Else
  Begin
    RadPtr := '';
  End;
End;



Procedure TfrmCapMain.LOOKUPSurgery(Sender: Tobject);
Begin
  DateTimeProc := '';
  EdtProcDate.Text := '';
  If Not IsPatientSelected Then
    Exit;
  If Not CanUserCapture(Magassoc) Then
    Exit;
  If Maggsur.SurgeryCaselist(iDModObj.GetMagPat1.M_DFN) = 0 Then
    Exit;
  Maggsur.Panel1.caption := iDModObj.GetMagPat1.M_NameDisplay;
  Maggsur.Showmodal;
  If Maggsur.ModalResult = MrOK Then
  Begin
    SurPtr := Maggsur.Selection.caption;
    AutoImageDesc(MagPiece(SurPtr, '^', 2) + '  ' + Copy(MagPiece(SurPtr, '^', 3), 1, 45), magdescpkg);
    EdtStudy.Text := 'SUR';
    EdtStudy.Text := MagPiece(SurPtr, '^', 3);
    EdtStudy.Hint := MagPiece(SurPtr, '^', 3);
    If Maglength(SurPtr, '|') = 2 Then
      DateTimeProc := MagPiece(MagPiece(SurPtr, '|', 2), '^', 2)
    Else
      DateTimeProc := MagPiece(SurPtr, '^', 5);
    EdtProcDate.Text := MagPiece(SurPtr, '^', 2);
    FEdtLV.GenGoToNextControl(btnLookupdata);
  End
  Else
  Begin
    SurPtr := '';
  End;

End;

Procedure TfrmCapMain.MnuShowHintsClick(Sender: Tobject);
Begin
  FShowHints := MnuShowHints.Checked;
  Frmcapmain.ShowHint := FShowHints;
End;

Procedure TfrmCapMain.FileToListView(AddFile: String; Var LV: TListView; Insertat: Integer);
Var
  j, i: Integer;
  FSize: String;
  FileDt: String;
    //  ext: string;
  pformat, pformatdesc: String;
Begin
  Try
    i := Insertat;
    FileDT := Formatdatetime('mm/dd/yyyy  h:mm am/pm', FILEDATETIME(AddFile));
    If i > -1 Then
      LV.Items.Insert(i)
    Else
    Begin
      LV.Items.Add;
      i := LV.Items.Count - 1;
    End;
    LV.Items[i].caption := ExtractFileName(AddFile);
    LV.Items[i].ImageIndex := -1;
        //ext := extractfileext(addfile);
    If Not FileTypeSupported(AddFile, pformat, pformatdesc) Then
    Begin
      LV.Items[i].ImageIndex := 5;
      WinMsg('', pformatdesc);
    End;
    FSize := Inttostr((Getfilesize(AddFile) Div 1024) + 1) + 'KB';
    For j := 10 - Length(FSize) Downto 0 Do
      FSize := ' ' + FSize;

    LV.Items[i].SubItems.Add(FSize);
    LV.Items[i].SubItems.Add(ExtractFileExt(AddFile));
    LV.Items[i].SubItems.Add(FileDt);
    LV.Items[i].SubItems.Add(ExtractFileDir(AddFile));
  Except
    MagAppMsg('s', 'File wasn''t added to List: ' + AddFile);
  End;
End;

Procedure TfrmCapMain.ShowImportDir;
Var
  MagSelectImportDirf: TMagSelectImportDirf;
Const
  choosedir: Boolean = False;
Begin
  pnlimport.Show;
  Splitter4.Top := pnlimport.Top - 2;
  pnlimport.Enabled := True;
  If mImportdir1.Visible Then
    mimportdir.Enabled := True;
    {Post59}
    //if mnuImportDirectory.visible then mnuImportDirectory.Enabled := true;
  If Not dftimportdirloaded Then
  Begin
    dftimportdirloaded := True;
        //mimportdirclick(self);

    MagSelectImportDirf := TMagSelectImportDirf.Create(Self);
    loadimportfiles(MagSelectImportDirf);
    ChDir(AppPath);
    MagSelectImportDirf.Release;
  End;

    // Show batch, copy All, and modality saf 12/8/98
  cbBatch.Visible := True;
  mBatchOptions.Visible := True;
    // enable the advanced Batch Import options on the System Manager Menu.
  mnuBatchAdvanced.Enabled := True;

End;

Procedure TfrmCapMain.HideImportDir;
Begin
  pnlimport.Hide;
  If pnllstImport.Visible Then
    pnllstImport.Visible := False;
  If mImportdir1.Visible Then
    mImportdir.Enabled := False;

    {Post59}
  //  if mnuImportDirectory.visible then mnuImportDirectory.Enabled := false;
    {bImportdir.hide;}{mag32}
  Hidepanel.Hide;

    (* // hide batch, copy All, and modality saf 11/25/98
    bBatch.Visible := False;
    cboModality.Visible := False;
    CopyAll.Visible := False;  *)
    // gek 3.1.99  we commented out stuarts and added the following
  cbBatch.Checked := False;

  cbBatch.Hide;
  mBatchOptions.Visible := False;
  mnuBatchAdvanced.Checked := False;
  mnuBatchAdvanced.Enabled := False;
  HideBatchListView;

End;

Procedure TfrmCapMain.FormResize(Sender: Tobject);
//var
//p129  annotPoint : TPoint;
Begin

  If Application.Terminated Then
    Exit;
  Otherdesc.Width := ClientWidth - Otherdesc.Left;
    //otherbevel.width := otherdesc.width;
  If Doesformexist('fmagConfigList') Then
    FrmConfigList.ShowAsButtons(TabCtr);

  If ((Height < 650) And (Not Fminimumseperation)) Then
  Begin
    Fminimumseperation := True;
    if CapIsInitialized then ShowTagFields;    //p117 gek. stop AccViol when 800x600
  End;
  RedisplayMultiline;
  If pnlImport.Visible Then
  Begin
    SetImportMaxHeight;
    SetImportBatchMaxHeight;
  End;



  {/p122 WPR Capture Item #7,16 - 8/25 re-enable/}
  
  //p122 dmmn 8/18 - this part is not necessary anymore since we are now aligning
  // the annotation form to the client area of the imagepanel
  {/P122 - DMMN - 6/21/2011 - Move the annotation ovelay to match the imagepanel /}

  (* p129
  if fCapAnnot <> nil then
  begin
    ResizeAnnotOverlay;
  end;
 *)
End;

Procedure TfrmCapMain.SetImportMaxHeight;
Begin
  pnlImport.Constraints.MaxHeight := Panel1.Height - (SbxEditFields.Constraints.MinHeight + plongdesc.Height + splitter4.Height + Splitter3.Height + 5);
  pnlImport.Constraints.MinHeight := 150;
End;

Procedure TfrmCapMain.SetImportBatchMaxHeight;
Begin
  pBatch.Constraints.MaxHeight := pnlImport.Height - (lbImportb.Height + LvImport1.Constraints.MinHeight + splitter5.Height + 2);

End;


Procedure TfrmCapMain.WMGetMinMaxInfo(Var Message: TWMGetMinMaxInfo);
Var
  Hy, Wx: Integer;
Begin
  Hy := Trunc(445 * (Pixelsperinch / 96));
  Wx := Trunc(620 * (Pixelsperinch / 96));
  With Message.Minmaxinfo^ Do
  Begin
    PtMinTrackSize.x := Wx;
    PtMinTrackSize.y := Hy;
  End;
  Message.Result := 0;
  Inherited;

End;


Procedure TfrmCapMain.WinMsg(c, s: String; msgpanel : Tpanel = nil);
var
  i : integer;
  t : string;
Begin
  Application.Processmessages;

 {Fix RCA  Errors were not being displayed in Red.  This is because Maggmsgu does not set
   a caption property of an outside panel.   so we move that code here.}
  If Application.Terminated Then Exit;
  c := Uppercase(c);
  If (Pos('S', c) = 0) Then
    Pmsg.Font.Color := clBlack;

  If Doesformexist('MaggMsgf') Then
  Begin
    While QueMsgList.Count > 0 Do
    Begin
      MagAppMsg(MagPiece(QueMsgList[0], '~', 1), MagPiece(QueMsgList[0], '~', 2));
      pmsg.Caption := MagPiece(QueMsgList[0], '~', 2);
      QueMsgList.Delete(0);
    End;
  End
  Else
  Begin
    QueMsgList.Add(c + '~' + s);
    Exit;
  End;


  MagAppMsg(c, s);
  {Fix RCA errors displayed in Red}
  While Pos(#13, s) > 0 Do
  Begin
    i := Pos(#13, s);
    t := s;
    t := Copy(s, 1, i - 1) + ' ' + Copy(s, i + 1, 240);
    s := t;
  End;

  if pos('S',c) = 0 then      {only dispaying Non-system messages on StatusBar}
     begin
     If Pos('E', c) > 0 Then
     Pmsg.Font.Color := clRed;
     pmsg.Caption := s;
     end;


  if msgpanel <> nil then msgPanel.caption := s ;
  
    {need to update because any call to broker suspends window
     processing.  i.e. the message won't be seen until the broker call is finished}
End;

Procedure TfrmCapMain.mLoadPatientImagesClick(Sender: Tobject);
Begin
  {/P122 DMMN 7/5/11 - Show warning that annotated images will not be displayed
    when user click on previously captured images /}
  {/p122 dmmn WPR Capture Item #15 /}
//129 T11 dialog out.  MagAppMsg('d', 'Annotations will not be displayed.');

    //3.3.99  if not pHotButtons.visible then pHotButtons.visible := true;
    //if not panel4.visible then panel4.visible := true;
    {mloadpatientImages.checked := not mloadpatientimages.checked;
    if mloadpatientimages.checked then }{   }
    //3.3.99 GetPatientImages;
  MagLastImagesForm.Show;
  MagLastImagesForm.ReLoadImageList;
  MagLastImagesForm.ExtraWinAppMsg('Annotations will not be displayed.');

End;

Procedure TfrmCapMain.bImportDirectoryClick(Sender: Tobject);
Begin
  SelectImportDirectory4;
End;

Procedure TfrmCapMain.Stg1KeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If ((Key = VK_Return) And btnCapture.Enabled) Then
    btnCapture.Click;
  Inherited;
End;

Procedure TfrmCapMain.Accu321Repaint(Sender: Tobject);
Begin
  AccusoftPropertiesShow;
End;

Procedure TfrmCapMain.ACCU321INFOClick(Sender: Tobject);
Begin
  AccusoftPropertiesShow;
End;

Procedure TfrmCapMain.AccusoftPropertiesShow;
Var
  AccuImageType, y: String;
  bitspix: Integer;
  Desc: String;
          vImageResolution : IIGImageResolution;
          Xres , YRes : integer;

Begin

  if IsGearClear(mg1) then
  Desc := '_______________'
  Else
  Begin

               vImageResolution := mg1.GetCurrentPage.GetImageResolutionCopy;
               if VImageResolution = nil then
                 begin
                 winmsg('s','Error in Resolution information.');
                 exit;
                 end;

               Xres := trunc(vImageResolution.XNumerator/vImageResolution.XDenominator);
               yres := trunc(vImageResolution.YNumerator/vImageResolution.YDenominator);

    { DONE -o129 : Need mg1 replacement for... .imagetype.}
    AccuImageType := mg1.GetFileFormatAbbr()  ; //'___' ;// mg1. //Gear 1.ImageType;
    bitsPix := mg1.GetBitsPerPixel;
    If bitspix = 1 Then
      y := Inttostr(xRes) + ' x ' + Inttostr(yRes) + ' dpi  '
    Else
      y := Inttostr(mg1.GetImageWidth) + 'W x ' + Inttostr(mg1.GetImageHeight) + 'H ';
    Desc := '  ' + y + '  ' + Inttostr(BitsPix) + ' bit.  ' + AccuImageType;
    If mg1.GetCurrentPage.ImageIsGray Then
      Desc := Desc + '(grayscale)';
  End;
  ACCU321INFO.caption := Desc;

    { the next part takes too long to get a file size from the server}
    { try
     x := inttostr((getfilesize(Gear 1.image) div 1024)+1)+ ' KB  '+Gear 1.image;
     accu321info.caption:= accu321info.caption +x;
     except
     on E: exception do  accu321info.caption:= accu321info.caption +e.message;
     end; }{try except}

End;


Procedure TfrmCapMain.FormClose(Sender: Tobject; Var action: TCloseAction);
//var cachelist : string;
Begin
  application.ProcessMessages; {6/27/12  gek  quick fix, try stop AccViola on MagTwain when close}
  MagTwain1.SourceClose;

  If XBROKERX.Connected Then
  Begin
    If FSaveUserSettingsOnExit Then
      SetUserCapPref;

    RPMaggLogOff(XBROKERX);
  End;
  If IsProcessRunning(MagSysProcessInfo) Then
    MagTerminateProcess(0, MagSysProcessInfo);
   {/p117 gek Erase Cached photos }
   frmCapUtilForm.EraseCaptureTempFiles(GUserDir.Cache);

    {/p117 gek 1-17-11  : we don't do this now (pre 117),  so I don't know if users will welcome it or not.
       So we make it a INI file boolean test.  If it causes problems at existing site, we can stop the cleaning out of
       the TEMP directory by changing the INI Setting. }
    {The /temp directory should be cleaned out by other code during the copy files to network, So THis
       should actually do nothing...but if not, we'll give it a  second try here.}
  if uppercase(GetIniEntry('Workstation Settings','KeepCaptureTempFiles')) <>  'TRUE' then
      frmCapUtilForm.EraseCaptureTempFiles(GUserDir.temp);

  Application.Processmessages;
  SecurityKeys.Free;
  TabSeqList.Free;
  QueMsgList.Free;
  FExtensionlist.Free;
  GUserDir.Free;

    //ADMINDOC
  CategorylistAll.Free;
  CtgByClass.Free;

  If (WindowState = Wsnormal) Then
    SaveFormPosition(Self As TForm);
  TempFileObj.Free;
  MagFileObj.Free; {In  FormClose}
  FCapClinDataObj.Free;
  SaveWindowSettings;
  FuprefCapTIU.Free;
    {TODO: we need the Generic call to delete all files and directories in
      this Application Temp Directory (GUserDir.Temp).  We'll get it from Patch 45
      in a Later Patch of Capture }

(*P129
//p122 dmm 7/13/11 - clean up
  {/p122 dmmn WPR Capture Item #8 /}
  if fCapAnnot.HasAnnotationComponent then
    fCapAnnot.Close;
*)
if AnnotationsExist() then AnnotationsClose();

End;

Procedure TfrmCapMain.OpenPatient;
Var
  Xmsg: String;
Begin
  If CprsSync.SyncOn Then
    Exit;
  If Not XBROKERX.Connected Then
    ImagingCaptureLogin(localserver, Inttostr(ListenerPort), True);         {OpenPatient}
  If Not XBROKERX.Connected Then
    Exit;
  If Not IsStudyGroupComplete Then
    Exit;
  If Not CanUserCapture(Magassoc) Then
    Exit;

  FSAppBackGroundColor := $00E0DFCF;
  If Not iDModObj.GetMagPat1.SelectPatient('', Xmsg) Then
    Exit;

  ChangeToPatient(iDModObj.GetMagPat1.M_DFN);                         {OpenPatient. If TmagPat.SelectPatient was succesful}

End;
procedure TfrmCapMain.ErrorInGearClear();
begin
      FErrorInGear := False;
      FErrorInGearList.Clear;
      FErrorInGearListCode.Clear;
end;
Procedure TfrmCapMain.GetpatientPhoto(Xdfn: String);
Var
  t: Tstringlist;
  s, Image: String;
Begin
  mgPatImage.ClearImage;
  pnlGearPat.Visible := False;
  mgPatImage.UpdatePageView;

  t := Tstringlist.Create;
  Try
    If Not iDModObj.GetMagDBBroker1.RPMaggGetPhotoIDs(Xdfn, t) Then
      Exit;

    Image := MagPiece(t[0], '^', 4); // abstract
    If Not iDModObj.GetMagFileSecurity.MagOpenSecurePath(Image, s) Then
    Begin
      // 03/11/02 IR Elsie : connection not being closed
      WinMsg('', s);
      iDModObj.GetMagFileSecurity.MagCloseSecurity(s, True);
      WinMsg('', s);
      Exit;
    End
    Else
    Begin
      ErrorInGearClear;
      pnlGearPat.Visible := True;

      mgPatImage.loadtheimage(image);
      mgPatImage.MouseReSet;

    If ErrorInGear(mgPatImage, 'image', 'ImageGear: loading patient Image') Then               {in GetPatPhoto}
      Begin
        mgPatImage.ClearImage;
        pnlGearPat.Visible := False;
      End;
    End;
  Finally
    t.Free;
  End;
End;

Procedure TfrmCapMain.ChangeToPatient(newdfn: String);
Var
  cprsFlag: Boolean;
  Xmsg: String;

  xContextKey : string;
         cmgrConDfn : string;

Begin
{//p120t13 gek  the CapDFN variable is put in so we can compare against the CCow patient
           and not update if they are equal}
try
screen.Cursor := crHourGlass;
  WinMsg('s', '* * --FmagCapMain.ChangeToPatient Start:  NewDFN =' + newdfn);
  {this check is also below.  moved here to stop some CCOW connecting to check values.}
if (not (caprunMode = magrmCPRS)) and (CapDFN = newdfn)  then        {ChangeToPatient}
    begin
        WinMSg('s', '* * --FmagCapMain.ChangeToPatient NewDFN= ' + newdfn + '  CapDFN= ' + CapDFN ) ;
        WinMsg('s', '* * --FmagCapMain.ChangeToPatient Exiting  NOChange');
        Exit;
    end;

//129T5 gek here can't call this,  the ContextManagerLink isn't made yet.  get access violation.
// so if cprsstarted me, we bave to skip the Contextor Call.
(*
if (caprunMode = magrmCPRS) then             {ChangeToPatient}
  begin
    //
  end
  else
      begin
      if FTestShowContextData then  idmodobj.GetCCOWManager.ShowContextData;
      if false then  {Here we need to test for sCapCCOWState , see if contextor is running.}
      begin
      xContextKey  := 'patient.id.mrn.dfn_' + PrimarySiteStationNumber + '_test';

      cmgrConDfn := idmodobj.GetCCOWManager.GetContextValue(xContextKey);

      end;
      end;

*)

//ccowout  if CapDFN = newdfn then Exit; //TP - no change DFN   {/TP chng wasn't in 129T4}
//ccowout    {with the above line out... then the Display client won't change.}

///// *****   END OF :  THIS IS NEW   NOT Jemmy's change, I put this in.

  Try
    If FViewingLatestImage Then
      GearClear;
    If (FrmCapTIU <> Nil) Then
      FrmCapTIU.Close();

    cprsFlag := CPRSChangePatient;
    CPRSChangePatient := False;

    If Not XBROKERX.Connected Then
      Exit;
        { Check first to see if we are in middle of study }
    If Imageptrlst.Items.Count > 0 Then
    Begin
      If Not IsStudyGroupComplete Then
      Begin
        If cprsFlag Then
        Begin
          MagSyncCPRSf.InformBreakCPRSLink;
          CprsSync.SyncOn := False;
          Frmcapmain.EnablePatientLookupLogin(True);
        End;
                {   study isn't complete, Exit}
        Exit;
      End;
            {       study group is complete  }
      NewStudy; {in C hangeToPatient}
    End;
        { User needs MAG CAPTURE Key to be able to capture images.
        If site is using 'CAPTURE KEYS' we check for certain MAGCAP ... keys}
    If Not CanUserCapture(Magassoc) Then
      Exit;
    ClearCurrentPatient(True);
    mLoadPatientImages.Enabled := True;
        //

        //
    magappmsg('s','* * --FmagCapMain.ChangeToPatient Calling SwitchToPatient with DFN=' + newDfn);
/////    newdfn := ''; /// for Testing set to '',  we get same error as Morgan  '0^Entry not found in Patient file.'
    If iDModObj.GetMagPat1.SwitchTopatient(newDFN, Xmsg) Then
    Begin

      WinMsg('s', '* * --FmagCapMain.ChangeToPatient  SwitchToPatient = TRUE : ');

    {/ P122 with P123 patient ID additions - JK 8/11/2011 /}
    if GSess.Agency.IHS then
      WinMsg('s', '* * --FmagCapMain.ChangeToPatient HRN: ' + iDModObj.GetMagPat1.M_SSN + '  DFN ' + iDModObj.GetMagPat1.M_DFN)
    else
      WinMsg('s', '* * --FmagCapMain.ChangeToPatient SSN: ' + iDModObj.GetMagPat1.M_SSN + '  DFN ' + iDModObj.GetMagPat1.M_DFN);

      MagLastImagesForm.PatientInfo(iDModObj.GetMagPat1);
      If (caprunMode = magrmCPRS) Then               {ChangeToPatient}
        Begin
        MagPatMenu.MaxInsert := 1;
            //p117 put in 94 change skipped by 106
            //94t1 gek comment out.
            //    PatientChangeWarningIfNeeded;
        end;
            //94t1 gek  put PCWIfNeeded here,(after 'end;') for all changes of patient
      PatientChangeWarningIfNeeded;

            //MagPatMenu.additem(iDModObj.GetMagPat1.M_NameDisplay, strtoint(iDModObj.GetMagPat1.M_DFN), iDModObj.GetMagPat1.M_Demog);
            //         code is in Patch 5 for DFNINTFIX
      MagPatMenu.AddItem(iDModObj.GetMagPat1.M_NameDisplay, iDModObj.GetMagPat1.M_DFN, iDModObj.GetMagPat1.M_Demog);
      // infinite loop if ->    CHKCCOW;   here.    tried during T5 testing.
      PtSSN.Text := iDModObj.GetMagPat1.M_SSNdisplay;
      EdtPatName.Text := iDModObj.GetMagPat1.M_NameDisplay;
      // new try...  here is where cap patient is changed... so set a new CapDFN var Here.
      CapDFN :=  iDModObj.GetMagPat1.M_DFN;
    End
    Else
    Begin
      WinMsg('s','* * --FmagCapMain.ChangeToPatient  SwitchToPatient = FALSE.');
      WinMsg('', Xmsg);
      Exit;
    End;
    If (Magassoc <> 'CLINIMAGE')
      And (Magassoc <> 'PHOTOID')
      And (Magassoc <> 'ADMINDOC') {//ADMINDOC} Then
    Begin
            {         when we change patients, we are clearing fields if the Association
                      is a patient specific procedure, exam, specimen, note, case.  }
      ClearAssociationFields(True); //{in  C hangeToPatient}
    End;
    If (Magassoc = 'PHOTOID') Then
    Begin
            { Fill in fields for PHOTO ID}
      InitPhotoID;
    End;
    GetPatientPhoto(iDModObj.GetMagPat1.M_DFN);
  Finally
    UpdateWindowcaption;
  End;
  finally
    WinMsg('s', '* * --FmagCapMain.C hangeToPatient  EXITING.');
  //infinite loop   ForceRepaint;
  screen.cursor := crdefault;
  end;
End;

Procedure TfrmCapMain.ConfigbuttonClick(Sender: Tobject);
Var
  Rmsg: String;
Begin
  FrmConfigList.ApplyConfiguration((Sender As TButton).caption, Rmsg);
End;

Procedure TfrmCapMain.hotbuttonClick(Sender: Tobject);
Begin
    //frmCapConfig.applyhotbutton((Sender as Tbutton).tag);
End;

Procedure TfrmCapMain.CAPDeviceExecuteClick(Sender: Tobject);
Begin
  WinMsg('d', 'You must Select an Input Source ' + #13 + 'from the Configuration window !');
End;

Procedure TfrmCapMain.mConfirmmsgClick(Sender: Tobject);
Begin
  Fconfirmmsg := mconfirmmsg.Checked;
End;

Procedure TfrmCapMain.edtImageDescEnter(Sender: Tobject);
Begin
  If IniImageDescCurEnd Then
  Begin
    (Sender As TEdit).SELSTART := Length((Sender As TEdit).Text);
    (Sender As TEdit).SelLength := 0;
  End;
End;

Procedure TfrmCapMain.ImagingCaptureWindow1Click(Sender: Tobject);
Begin
  Application.HelpContext(10029);
End;

Procedure TfrmCapMain.WMMOVE(Var Message: TWMMOVE);

Begin
  Message.Result := 0;
  Inherited;
End;

Procedure TfrmCapMain.ZoomIn1Click(Sender: Tobject);
Begin
  Frmcapmain.Scaleby(100, 110)
End;

Procedure TfrmCapMain.ZoomOut1Click(Sender: Tobject);
Begin
  Frmcapmain.Scaleby(110, 100)
End;

procedure TfrmCapMain.mnuTestSaveImageAsClick(Sender: TObject);
begin
 SaveLoadPastedImage;
end;

procedure TfrmCapMain.mnuTestScriptDontUseCCOWClick(Sender: TObject);
var
 val : string;
begin
      mnuTestScriptDontUseCCOW.Checked :=  NOT mnuTestScriptDontUseCCOW.Checked;
      
      val := uppercase(magbooltostr(mnuTestScriptDontUseCCOW.Checked));
      SetIniEntry('DEV-CONTEXT','DontUseCCOW',val);
      messagedlg( 'This is for TESTING Only' + #13 + #13
                  + ' you must Restart Capture for the Change to take Effect'
                  + #13 + #13
                  + 'Value is now: ' + val + #13
                  + ' True =  Capture Will NOT Attempt to Join CCOW Context' + #13
                  + 'False =  Capture will attempt to Join CCOW Context like normal.'
                  , mtconfirmation, [mbok],0);

end;

procedure TfrmCapMain.mnuTestScriptForceAccusoftErrorsClick(Sender: TObject);
begin
FTestScriptForceAccusoftErrors := mnuTestScriptForceAccusoftErrors.Checked;
end;

procedure TfrmCapMain.mnuTestScriptForceCopyExceptionsClick(Sender: TObject);
begin
// the menu has AutoCheck = TRUE
FTestScriptForceCopyFileException := mnuTestScriptForceCopyExceptions.checked;
end;

procedure TfrmCapMain.mnuTESTShowContextDataClick(Sender: TObject);
begin
FTestShowContextData := mnuTESTShowContextData.Checked;
end;

Procedure TfrmCapMain.SaveImageAs2Click(Sender: Tobject);
Begin
  SaveImageAS;
End;

Procedure TfrmCapMain.SaveImageAs1Click(Sender: Tobject);
Begin
  SaveImageAS;
End;

Procedure TfrmCapMain.SaveImageAS;
Var
  Tfilename: String;
  Ext: String;
  i: Integer;
  lp : integer;
  curfilename : string;
Begin
curfilename := mg1.ImageFilename;
lp := maglength(curfilename,'.');

 if mg1.IsValidImage then
    SaveDialog1.Filename := MagPiece(ExtractFileName(mg1.ImageFilename), '.', 1);
    //10-16-03 savedialog1.defaultExt := magpiece(format, '.', 2);
  SaveDialog1.DefaultExt := MagPiece(curfilename, '.', 2);

    //savedialog1.filter := '*' + format;

  If SaveDialog1.Execute Then
  Begin
    If (ofExtensionDifferent In SaveDialog1.Options) Then
    Begin
      {/p122 dmmn WPR Capture Item #20 /}
      Messagedlg('Save CANCELLED.  To change the format of the images you are saving, ' + #13 +
        'you must change the Image Format in the Configuration Window' + #13 +
        'select the menu ''Options|Configuration'' to change the Image Format', Mtconfirmation, [Mbok], 0);
            (* showmes sage('Save CANCELLED.  To change the format of the images you are saving, ' + #13 +
               'you must change the Image Format in the Configuration Window' + #13 +
               'select the menu ''Options|Configuration'' to change the Image Format');*)
      WinMsg('e', 'Save CANCELLED');
      Exit;
    End;
    SaveDialog1.InitialDir := ExtractFilePath(SaveDialog1.Filename);
    WinMsg('', 'Saving as ' + SaveDialog1.Filename);
    Tfilename := SaveDialog1.Filename;
      {/p129  contrast brightness are saved with save function.}
    //Gear 1.SettingMode := MODE_CONTRAST;
    //Gear 1.SettingValue := IG_CONTRAST_PIXEL;
    //Gear 1.Brightness := Gear 1.DisplayBrightness;
    //Gear 1.Contrast := Gear 1.DisplayContrast;
    AccusoftPropertiesLog('Before SaveGear : SaveImageAs');
    If mg1.PageCount > 1 Then
    Begin
      Ext := Uppercase(ExtractFileExt(Tfilename));
      If Ext <> '.TIF' Then
      Begin
        WinMsg('', 'MultiPage must be in TIF Format. Save Cancelled.');    {/p122 dmmn WPR Capture Item #20 /}
        Exit;
      End;
      For i := 1 To mg1.PageCount Do
      Begin
        mg1.Page := i;
        getIGManager.IGFormatsCtrl.savePageToFile(mg1.GetCurrentPage,tfilename,0,IG_PAGESAVEMODE_APPEND,IG_SAVE_UNKNOWN);

      End;

    End
    Else
    Begin
      If SaveGear(Tfilename) Then
        WinMsg('', 'Save complete.')
      Else
        WinMsg('', 'Save Image FAILED.');
    End;
  End;
End;
Procedure TfrmCapMain.SaveImageASpdf;
Var
  Tfilename: String;
  Ext: String;
  i: Integer;
  lp : integer;
  curfilename : string;
  BitCount : integer;
Begin
  try
  magappmsg('','Saving as PDF...');
  screen.Cursor   := crHourGlass;
  update;

  curfilename := mg1.ImageFilename;
  lp := maglength(curfilename,'.');

  if not mg1.IsValidImage then
    begin
    magappmsg('d','Invalid Image. Capture the image again.');
    exit;
    end;
                      ////    SaveDialog1.Filename := MagPiece(ExtractFileName(mg1.ImageFilename), '.', 1);
                      //10-16-03 savedialog1.defaultExt := magpiece(format, '.', 2);
                      ////  SaveDialog1.DefaultExt := MagPiece(curfilename, '.', 2);

                      //savedialog1.filter := '*' + format;

                      //// If SaveDialog1.Execute Then
                      //// Begin

                      //// SaveDialog1.InitialDir := ExtractFilePath(SaveDialog1.Filename);
                      //// WinMsg('', 'Saving as ' + SaveDialog1.Filename);
                      ////    Tfilename := SaveDialog1.Filename;
                                    {/p129  contrast brightness are saved with save function.}
                                  //Gear 1.SettingMode := MODE_CONTRAST;
                                  //Gear 1.SettingValue := IG_CONTRAST_PIXEL;
                                  //Gear 1.Brightness := Gear 1.DisplayBrightness;
                                  //Gear 1.Contrast := Gear 1.DisplayContrast;
  AccusoftPropertiesLog('Before SaveGear : SaveImageAs');
  //Tfilename := 'C:\Documents and Settings\vhaisakiring\Application Data\VistA\Imaging\temp\magPDF.PDF';
  Tfilename := GUserDir.Temp + 'magpdf.pdf';

  BitCount := mg1.GetBitsPerPixel ;
  CapX.m140RLE := (BitCount = 1);
  CapX.m140JPG := (BitCount > 1);

  If mg1.PageCount > 1 Then
    Begin
      Ext := Uppercase(ExtractFileExt(Tfilename));

      For i := 1 To mg1.PageCount Do          //IG_SAVE_PDF_JPG;  IG_SAVE_PDF_RLE, IG_SAVE_PDF_G4;  IG_SAVE_TIF_G4; IG_SAVE_TIF_PACKED;
      Begin
        mg1.Page := i;
        if CapX.m140RLE
          then getIGManager.IGFormatsCtrl.savePageToFile(mg1.GetCurrentPage,tfilename,0,IG_PAGESAVEMODE_APPEND,IG_SAVE_PDF_RLE)
          else getIGManager.IGFormatsCtrl.savePageToFile(mg1.GetCurrentPage,tfilename,0,IG_PAGESAVEMODE_APPEND,IG_SAVE_PDF_JPG);
      End;
    End
  Else
    Begin
                  //    GetIGManager.IGFormatsCtrl.savepagetofile(mg1.GetCurrentPage,image,0,
                  //                                          IG_PAGESAVEMODE_OVERWRITE,
                  //                                          FmIGSaveFormat);

    if CapX.m140RLE
          then getIGManager.IGFormatsCtrl.savePageToFile(mg1.GetCurrentPage,tfilename,0,IG_PAGESAVEMODE_APPEND,IG_SAVE_PDF_RLE)
          else getIGManager.IGFormatsCtrl.savePageToFile(mg1.GetCurrentPage,tfilename,0,IG_PAGESAVEMODE_APPEND,IG_SAVE_PDF_JPG);

    If ErrorInGear(mg1, tfilename, 'ImageGear: Save To Network') Then          {in SaveGear}
        begin
        // Result := False ;
        WinMsg('d', 'Save Image FAILED.');
        end;
    End;
  finally
    magappmsg('','Continue Capturing images');
    screen.Cursor   := crDefault;
    update;
  end;
End;


Procedure TfrmCapMain.SaveLoadPastedImage;
Var
  Tfilename: String;
Begin
      tfilename := GUserDir.Temp +   'pasteGear.jpg';
      DeleteFile(PChar(tfilename));
      getIGManager.IGFormatsCtrl.savePageToFile(mg1.GetCurrentPage,tfilename,0,IG_PAGESAVEMODE_OVERWRITE,IG_SAVE_JPG);
      application.processmessages;
      magappmsg('s','--Saved Pasted Image-- Complete -');
      mg1.LoadTheImage(tfilename);
      magappmsg('s','--Load Pasted Image-- Complete');
End;


Procedure TfrmCapMain.mSelectPatientClick(Sender: Tobject);
Begin
  OpenPatient;
End;

Procedure TfrmCapMain.btnPatientClick(Sender: Tobject);
Begin
  OpenPatient;
  If iDModObj.GetMagPat1.M_DFN <> '' Then
    If FEdtLV.FAutoTab Then
      FEdtLV.GenGoToNextControl(btnPatient);

End;
procedure TfrmCapMain.mnuSaveAsPDF1Click(Sender: TObject);
begin
SaveImageASpdf;
end;


Procedure TfrmCapMain.mnuSaveBigFileClick(Sender: Tobject);
Begin
  mnuSaveBigFile.Checked := Not mnuSaveBigFile.Checked;
  FCapSaveBIG := mnuSaveBigFile.Checked;
End;




Procedure TfrmCapMain.writedir1Click(Sender: Tobject);
Var
  s: String;
Begin
  If Not SearchVistAFile('2005.2', 'Select : ', '  Capture Images to Directory: ', 'Select the Write Directory', '', False, s) Then
    Exit;
  WriteDir := MagPiece(s, '^', 1);
End;

Procedure TfrmCapMain.NetSecurityON1Click(Sender: Tobject);
Begin
  NetSecurityON1.Checked := Not NetSecurityON1.Checked;
  iDModObj.GetMagFileSecurity.SecurityOn := NetSecurityON1.Checked;
End;

Procedure TfrmCapMain.mTestWriteDirClick(Sender: Tobject);
Begin
  mTestWriteDir.Checked := Not mTestWriteDir.Checked;
End;

Procedure TfrmCapMain.mimportdirXoldClick(Sender: Tobject);
Begin
  SelectImportDirectory4;

End;


Procedure TfrmCapMain.ImportDir1Click(Sender: Tobject);
Begin
  SelectImportDirectory4;
End;

procedure TfrmCapMain.RmvSlash(num : integer; var Dir: string);
begin
  { num is 0 or 1.  this is number of Slashes to keep at end of this Directory string;}
while dir[length(dir)] = '\' do  dir := copy(dir,1,length(dir)-1);
if num = 1  then dir := dir + '\';
end;

Procedure TfrmCapMain.SelectImportDirectory4(pdir: String = ''; pallFiles: Boolean = False);
Var
  x: String;
Begin

 RmvSlash(0,pdir);
  If pdir = '' Then
  Begin
    x := GetIniEntry('Import Options', 'DefaultImportDir');
    If (x = '') Then
      x := AppPath + '\import';
    If opendialogImport.InitialDir = '' Then
      OpenDialogImport.InitialDir := x;
    OpenDialogImport.Filename := 'All Files'; //<Ctrl-A> selects all.';
    x := GetIniEntry('Import Options', 'DefaultMask');
    If (x = '') Then
      x := '*.*';
  End
  Else
  Begin
    opendialogImport.InitialDir := pdir;
    OpenDialogImport.Filename := 'All Files';
    x := '*.*';
  End;
    {',MPEG,MPG,MP3,MP4,ASC,AVI,DOC,HTM,HTML,MHT,MHTML,JPG,PDF,RTF,TGA,TIF,WAV,TXT,DCM,PAC,BIG,ABS,BW,756,BMP,';}
    //OpenDialogImport.filter := 'All *.*|*.*|Video(mpg;avi)|*.mpeg;*.mpg;*.avi|Text(txt;asc)|*.txt;*.asc|Documents(doc;rtf;pdf)|*.doc;*.rtf;*.pdf|Color(jpg;tga;bmp)|*.jpg;*.jpeg;*.tga;*.bmp|TIF(tif)|*.tif|Other(dcm;pac;big;bw;756;wav;htm)|*.dcm;*.pac;*.big;*.bw;*.756;*.wav;*.htm';
    { filter has 255 limit (string limit ?)  Filters and filterindex are entered via the component.}
  If pallfiles Then
  Begin

    // out for testing... getting rid of \\\\\  in file name. pdir := pdir + '\';
   RmvSlash(0,pdir);
    OpenAllFilesX(pdir);
    Exit;
  End;
  If OpenDialogImport.Execute Then
  Begin
    If (Uppercase(ExtractFileName(OpenDialogImport.Filename)) = 'ALL FILES') Or (Uppercase(ExtractFileName(OpenDialogImport.Filename)) = 'ALL') Then
    Begin
      If FAddDirOnSelect And (lstboxImport.Items.Indexof(ExtractFilePath(opendialogImport.Filename)) = -1) Then
        lstboxImport.Items.Add(ExtractFilePath(opendialogImport.Filename));
      OPenAllFiles;
      Exit;
    End;
    If FAddDirOnSelect And (lstboxImport.Items.Indexof(ExtractFilePath(opendialogImport.Filename)) = -1) Then
      lstboxImport.Items.Add(ExtractFilePath(opendialogImport.Filename));
    NewloadImportfiles(OpendialogImport.Files);
    opendialogImport.InitialDir := ExtractFilePath(opendialogImport.Filename);
  End;
  ChDir(AppPath); // needed this before to set current directory to Appath.
    // The OpenDialog Options: ofNoChangeDir = True. should do the same thing.

End;

Procedure TfrmCapMain.SelectImportDirectory5(pdir: String = ''; pallFiles: Boolean = False);
Var //tini: tinifile;
  x: String;
Begin
 RmvSlash(0,pdir);
  If pdir = '' Then
  Begin
    x := GetIniEntry('Import Options', 'DefaultImportDir');
    If (x = '') Then
      x := AppPath + '\import';
    If opendialogImport.InitialDir = '' Then
      OpenDialogImport.InitialDir := x;
    OpenDialogImport.Filename := 'All Files'; //<Ctrl-A> selects all.';
    x := GetIniEntry('Import Options', 'DefaultMask');
    If (x = '') Then
      x := '*.*';
  End
  Else
  Begin
    opendialogImport.InitialDir := pdir;
    OpenDialogImport.Filename := 'All Files';
    x := '*.*';
  End;
    {',MPEG,MPG,MP3,MP4,ASC,AVI,DOC,HTM,HTML,MHT,MHTML,JPG,PDF,RTF,TGA,TIF,WAV,TXT,DCM,PAC,BIG,ABS,BW,756,BMP,';}
    //OpenDialogImport.filter := 'All *.*|*.*|Video(mpg;avi)|*.mpeg;*.mpg;*.avi|Text(txt;asc)|*.txt;*.asc|Documents(doc;rtf;pdf)|*.doc;*.rtf;*.pdf|Color(jpg;tga;bmp)|*.jpg;*.jpeg;*.tga;*.bmp|TIF(tif)|*.tif|Other(dcm;pac;big;bw;756;wav;htm)|*.dcm;*.pac;*.big;*.bw;*.756;*.wav;*.htm';
    { filter has 255 limit (string limit ?)  Filters and filterindex are entered via the component.}
  If pallfiles Then
  Begin
     // out for testing... getting rid of \\\\\  in file name.
    // pdir := pdir + '\';
    RmvSlash(0,pdir);
    OpenAllFilesX(pdir);
    Exit;
  End;
  If OpenDialogImport.Execute Then
  Begin
    If (Uppercase(ExtractFileName(OpenDialogImport.Filename)) = 'ALL FILES') Or (Uppercase(ExtractFileName(OpenDialogImport.Filename)) = 'ALL') Then
    Begin
      If FAddDirOnSelect And (lstboxImport.Items.Indexof(ExtractFilePath(opendialogImport.Filename)) = -1) Then
        lstboxImport.Items.Add(ExtractFilePath(opendialogImport.Filename));
      OPenAllFiles;
      Exit;
    End;
    If FAddDirOnSelect And (lstboxImport.Items.Indexof(ExtractFilePath(opendialogImport.Filename)) = -1) Then
      lstboxImport.Items.Add(ExtractFilePath(opendialogImport.Filename));
    NewloadImportfiles(OpendialogImport.Files);
    opendialogImport.InitialDir := ExtractFilePath(opendialogImport.Filename);
  End;
  ChDir(AppPath); // needed this before to set current directory to Appath.
    // The OpenDialog Options: ofNoChangeDir = True. should do the same thing.

End;

Procedure TfrmCapMain.OpenAllFilesX(pdir: String);
Var
   Mask: String;
    // maskitem : integer;
  Sr: TSearchRec;
Begin
  GearClear;
  RmvSlash(1,pdir);
    // if dir[length(dir)
  Mask := '*.*';
  If FindFirst(pDir + Mask, FaAnyFile, Sr) <> 0 Then
    Exit;
  SetImportLabelDesc(pDir);
  LvImport1.Items.Clear;
  WinMsg('', 'Loading images from : ' + pDir + '...');
  If FileExists(pDir + Sr.Name) Then
    FileToListView(pDir + Sr.Name, LvImport1, -1);
  While FindNext(Sr) = 0 Do
  Begin
    If FileExists(pDir + Sr.Name) Then
      FileToListView(pDir + Sr.Name, LvImport1, -1);
  End;
  WinMsg('', Inttostr(LvImport1.Items.Count) + ' Images loaded from ' + pDir + '.');
End;

Procedure TfrmCapMain.OpenAllFiles;
Var
  Dir, Mask, Filters: String;
  Maskitem: Integer;
  Sr: TSearchRec;
Begin
  GearClear;
  Dir := ExtractFilePath(OpenDialogImport.Filename);
  Filters := OpendialogImport.Filter;
  Maskitem := opendialogImport.FilterIndex;
  Mask := MagPiece(Filters, '|', Maskitem * 2);
  If FindFirst(Dir + Mask, FaAnyFile, Sr) <> 0 Then
    Exit;
  SetImportLabelDesc(Dir);
  LvImport1.Items.Clear;
  WinMsg('', 'Loading images from : ' + Dir + '...');
  If FileExists(Dir + Sr.Name) Then
    FileToListView(Dir + Sr.Name, LvImport1, -1);
  While FindNext(Sr) = 0 Do
  Begin
    If FileExists(Dir + Sr.Name) Then
      FileToListView(Dir + Sr.Name, LvImport1, -1);
  End;
  WinMsg('', Inttostr(LvImport1.Items.Count) + ' Images loaded from ' + Dir + '.');
End;

Procedure TfrmCapMain.SetImportLabelDesc(VDir: String);
Begin
  RmvSlash(0,Vdir);
  LbImport.caption := VDir;
  LbImport.Hint := VDir;
  If LbImport.Canvas.Textwidth(VDir) > (LbImport.Width - 10) Then
    LbImport.alignment := TaRightJustify
  Else
    LbImport.alignment := TaCenter;
End;

Procedure TfrmCapMain.loadimportfiles(MagSelectImportDirf: TMagSelectImportDirf);
Var
  i: Integer;
Begin
  GearClear;
  SetImportLabelDesc(MagSelectImportDirf.FileListBox1.Directory);
    //GetPixelLengthLongestEntry(lstBoxImport.Items,lstboxImport.Canvas)+ 60;

  lbfilter.caption := MagSelectImportDirf.ComboBox1.Text;
  LvImport1.Items.Clear;
  initprogress(MagSelectImportDirf.FileListBox1.Items.Count);
  WinMsg('', 'Loading ' + Inttostr(MagSelectImportDirf.FileListBox1.Items.Count) + ' images from : ' + LbImport.caption + '...');
  Screen.Cursor := crHourGlass;
  For i := 0 To MagSelectImportDirf.FileListBox1.Items.Count - 1 Do
  Begin
    FileToListView(MagSelectImportDirf.FileListBox1.Directory + '\' + MagSelectImportDirf.FileListBox1.Items[i], LvImport1, -1);
    incprogress;
  End;
    //p8t29 Stop the Main Form from getting focus, when Import is clicked in Config Window
    //if lvImport1.enabled and lvImport1.visible then lvImport1.setfocus;
  gauge1.Hide;
  WinMsg('', 'Import Directory  -  ' + LbImport.caption + ' : ' + Inttostr(LvImport1.Items.Count) + ' images.');
  Screen.Cursor := crDefault;
End;

Procedure TfrmCapMain.Newloadimportfiles(FileList: TStrings; Filter: String = '');
Var
  i: Integer;
Begin
  GearClear;
  SetImportLabelDesc(ExtractFilePath(FileList[0]));
  lbfilter.caption := Filter;
  LvImport1.Items.Clear;
  initprogress(FileList.Count);
  WinMsg('', 'Loading ' + Inttostr(FileList.Count) + ' images from : ' + LbImport.caption + '...');
  Screen.Cursor := crHourGlass;
  For i := 0 To FileList.Count - 1 Do
  Begin
    FileToListView(FileList[i], LvImport1, -1);
    incprogress;
  End;
  If LvImport1.Enabled And LvImport1.Visible Then
    LvImport1.SetFocus;
  gauge1.Hide;
  WinMsg('', 'Import Directory  -  ' + LbImport.caption + ' : ' + Inttostr(LvImport1.Items.Count) + ' images.');
  Screen.Cursor := crDefault;
End;

Procedure TfrmCapMain.mDicomNumbersClick(Sender: Tobject);
Begin
  If Not Doesformexist('DicomNumbers') Then
    DicomNumbers := TDicomNumbers.Create(Self);
  DicomNumbers.Visible := True;
End;

procedure TfrmCapMain.mnuCombinePDFScansClick(Sender: TObject);
begin
if CapX.m140CombineScans then
  begin
    frmCapConfig.EnableCombinePDF(False);
    Exit;
  end;

  frmCapMain.AllPagesChecked(true);



if FileExists (GUserDir.Temp + 'magpdf.pdf')  then
  begin
   frmCapConfig.EnableCombinePDF(true);
  exit;
  end
  else
  begin
    magappmsg('d','Scan your first Image, then click the ''Combine PDF Scans'' menu.');
  end;

EXIT;

end;

procedure TfrmCapMain.mnuCombineTIFscansClick(Sender: TObject);
begin
if CapX.m140CombineScans then
  begin
    frmCapConfig.EnableCombineTIF(False);
    Exit;
  end;


if FileExists(GUserDir.Temp + 'resetfile.tif') then
  begin
    copyfile(GUserDir.Temp + 'resetfile.tif',GUserDir.Temp + 'multipage.tif');
    //frmCapConfig.EnableCombineTIF(true);
  end;
if not FileExists(GUserDir.Temp + 'multipage.tif') then
  begin
    magappmsg('d','Scan your first Document, then click the  ''Combine TIF Scans'' menu.');
    exit;
  end;

 frmCapConfig.EnableCombineTIF(true);

end;

Procedure TfrmCapMain.mnuConfigToolBarClick(Sender: Tobject);
Begin
  mnuConfigToolBar.Checked := Not mnuConfigToolBar.Checked;
  FSavedConfigsTB := mnuConfigToolBar.Checked;
  TabCtr.Visible := FSavedConfigsTB;
End;

Procedure TfrmCapMain.edtProcDateExit(Sender: Tobject);
Begin
  If EdtProcDate.Text = '' Then
    Exit;
  If EdtProcDate.Modified Then
    NoteDateCheck;

End;

Procedure TfrmCapMAin.NoteDateCheck;
Begin
  If Not ResolveDateTime Then
    EdtProcDate.SetFocus
  Else
  Begin
    If FCapClinDataObj.NewAddendum Or FCapClinDataObj.NewNote Then
    Begin
            {    if user modifies Note Date, we need to update
                 this field.}
      FCapClinDataObj.NewDate := EdtProcDate.Text;
      FCapClinDataObj.NewNoteDate := EdtProcDate.Text;
    End;
  End;
End;

Function TfrmCapMain.ResolveDateTime(): Boolean;
Var
  Xmsg: String;
  ResDateTime: String;
Begin
  DateTimeProc := '';
  If EdtProcDate.Text = '' Then
  Begin
    Result := False;
    Exit;
  End;
  If RPFileManDate(Xmsg, EdtProcDate.Text, ResDateTime, True) Then
  Begin
    Result := True;
    EdtProcDate.Text := MagPiece(ResDateTime, '^', 1);
        {try allowing TIME}
    DateTimeProc := MagPiece(ResDateTime, '^', 1);
  End
  Else
  Begin
    Result := False;
    EdtProcDate.Text := '';
    DateTimeProc := '';
    WinMsg('d', Xmsg, Pmsg);
  End;

End;

Procedure TfrmCapMain.edtProcDateKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
begin
  If (SsAlt In Shift) And (Key = 40) Then
  Begin
    btnProcDateClick(Self);
    Exit;
  End;
  If (Key <> VK_Return) Then
    Exit;
  If EdtProcDate.Text = '' Then
  Begin
    DateTimeProc := '';
    FEdtLV.GenGoToNextControl(EdtProcDate);
  End
  Else
  Begin
    NoteDateCheck;
    If (DateTimeProc <> '') Then
      FEdtLV.GenGoToNextControl(EdtProcDate);
  End;
End;

Procedure TfrmCapMain.enableOKCancelStudycomplete1Click(Sender: Tobject);
Begin
  btnImageOK.Enabled := True;
  btnCancelScan.Enabled := True;
  btnStudyComplete.Enabled := True;
End;

Procedure TfrmCapMain.TabbingSequence1Click(Sender: Tobject);
Begin
  With TfrmCapTabOrder.Create(Self) Do
  Begin
    ListBox1.Items.Assign(TabSeqList);
    Applyfromlist;
    Showmodal;
    If (ModalResult = MrOK) Or (ModalResult = MrAll) Then
    Begin
      TabSeqList.Assign(ListBox1.Items);
      ShowTagFields;
    End;
    If ModalResult = MrAll Then
      SaveTabSettingsToINI(TabSeqList);
    Free;
  End;
End;

{WPR ? new p59 saves a list of Import Directories}

Procedure TfrmCapMain.SaveImportDirsToIni;
Var
  Magini: TIniFile;
  i: Integer;
Begin
  Magini := TIniFile.Create(GetConfigFileName);
  Try
    Magini.Erasesection('Import Directories');
    For i := 0 To lstboxImport.Items.Count - 1 Do
      Magini.Writestring('Import Directories', lstboxImport.Items[i], 'TRUE');
  Finally
    Magini.Free;
  End;
End;

Procedure TfrmCapMain.GetImportDirsFromINI;
Var
  Magini: TIniFile;
  t: TStrings;
  i: Integer;
Begin
  t := Tstringlist.Create;
  Magini := TIniFile.Create(GetConfigFileName);
  Try
    Magini.ReadSectionValues('Import Directories', t);
    lstboxImport.Clear;
    For i := 0 To t.Count - 1 Do
      lstboxImport.Items.Add(MagPiece(t[i], '=', 1))
  Finally
    Magini.Free;
    t.Free;
  End;
End;

Procedure TfrmCapMain.SaveTabSettingsToINI(Var t: Tstringlist);
Var
  Magini: TIniFile;
  i: Integer;
Begin
  Magini := TIniFile.Create(GetConfigFileName);
  Try
    Magini.Erasesection('CHOICE_TABSEQUENCE');
    For i := 0 To t.Count - 1 Do
      Magini.Writestring('CHOICE_TABSEQUENCE', Inttostr(i + 1), t[i]);
  Finally
    Magini.Free;
  End;
End;

Procedure TfrmCapMain.GetTabSettingsFromINI(Var t: Tstringlist);
Var
  Magini: TIniFile;
Begin
  Magini := TIniFile.Create(GetConfigFileName);
  Try
    Magini.ReadSectionValues('CHOICE_TABSEQUENCE', t);
    If t.Count = 0 Then
    Begin
      t.Add('PatientFields_200');
      t.Add('SpecFields_400');
      t.Add('DescField_300');
      t.Add('capturebuttons_100');
      t.Add('OkCancel_500');
    End;
  Finally
    Magini.Free;
  End;
End;

Procedure TfrmCapMain.bBatchClick(Sender: Tobject);
Begin
  If Not CanUserCapture(Magassoc) Then
  Begin
    btnCapture.Enabled := True;
    Exit;
  End;
  If Messagedlg('Are you sure you want to capture all ' + Inttostr(9999999)
    + ' images in the import directory? ',
    Mtconfirmation, [Mbok, Mbcancel], 0) <> MrOK Then
  Begin
    Exit;
  End
  Else
  Begin
        (*     for i := 1 to stg1.rowcount-1 do
             begin
               stg1Click(Self);
               SCANClick(self);
               ScanOKClick(self);
               for j := 1 to stg1.rowcount-1 do
                  stg1.cells[0,j] := stg1.cells[0,j+1];
               stg1.cells[0,j] := '';
             end;  *)
  End;
End;

Procedure TfrmCapMain.bmsgbuttonClick(Sender: Tobject);
Begin
  magAppMsgShow;
End;

Procedure TfrmCapMain.EnableKeyDependentObjects;
Begin
  mSysman.Visible := (SecurityKeys.Indexof('MAG SYSTEM') > -1);
  MSysManhelp.Visible := (SecurityKeys.Indexof('MAG SYSTEM') > -1);
  If Userhaskey('MAG SYSTEM') Then
      MagCapMsg.SetPrivLevel(magmsgprivAdmin)    {   1 = user ,   0 = admin}
  Else
    MagCapMsg.SetPrivLevel(magmsgprivUser);
    {  /p129 enabled disable the Annotation button  based On User Permissions.}
    {  TODO -o129 : check for other places in the code, to make this call.
        other code enables disables a menu item also...  }
    {   gek 129T9 function, instead of setting from multiple places.}
        AnnotationsEnableForSessionCompute;
End;

Procedure TfrmCapMain.DisableKeyDependentObjects;
Begin
  MagCapMsg.SetPrivLevel(magmsgprivAdmin);
  mSysman.Visible := False;
  MSysManhelp.Visible := False;
  mnuTest1.Visible := False;
  mnuTest2.Visible := False;
End;


Procedure TfrmCapMain.Testmsg(s: String);
Begin
  FCapClinMgr.TestMessage(s);
End;


{ IsGearClear:   This tests the Accusoft control only.}
Function TfrmCapMain.IsGearClear(mVGear: TMag4VGear): Boolean;
Begin
// old -> Result := (Vgear.HiGear = 0)
    { ... the TMagVGear function :   function ImageLoaded().
         will not work correctly, if there isn't image loaded from VistA }

  result := NOT mVGear.IsValidImage; {p129 - Accusoft's function}
  winmsg('s','IsGearClear(mg1) =  ' + magbooltostr(result));
End;

{ IsImageclear:   This tests the Accusoft Control and the Non-Accuosft images that may
   be the current image, Just not in the ImageGear Control. }
Function TfrmCapMain.IsImageclear(mVGear: TMag4VGear): Boolean;
Begin
  Result := False;
 //p129 If (pGear.HiGear = 0) And (pnlNonGearSupported.Visible = False) Then
 //p129    Result := True;

{p129  just msg,  later use this, not above }
 if (isGearClear(mVGear)) and (NOT pnlNonGearSupported.Visible) Then
    begin
    Result := True;
    winmsg('S','Is Image Clear = TRUE');
    end
    else  winmsg('S','Is Image Clear = FALSE');
End;

Function TfrmCapMain.GearClear: Boolean;
Var
  tempimage, s: String;
  hdl: Integer;
Begin
  TIFWarnFirst := False; //p122t11
  {/P122 DMMN 6/24/2011 - Disable annotation button when the gear is empty /}
//  tlbrbtnAnnotation.Enabled := False;
//  tlbrbtnAnnotationclose.Enabled := false;
  AnnotationsEnableforImage(false); {make function call.  chnage property in one place in code.}

  Disableimagemanips(false); //p129t18 reenable the tools

(* P129
  {/p122 dmmn WPR Capture Item #8 /}
  if fCapAnnot.HasAnnotationComponent then
  begin
    MagAppMsg('s', 'Annotations discarded');
    fCapAnnot.Close;
  end;
  //p122t11 clear image manips track
  if FAnnotationManips = nil then
    FAnnotationManips := TStringList.Create;
  FAnnotationManips.Clear;
  //FTRCImageManips := False; //p122t12
 *)
  Result := True;
  If Application.Terminated Then
    Exit;
   {p129  : current save formats, for current image.  Need Cleared.}
  {........  no they dont'   we only change this when a config is changed...}
 // FmIGSaveMode := IG_PAGESAVEMODE_DEFAULT ; //  enumIGPageSaveModes;   IG_PAGESAVEMODE_DEFAULT = $00000000;
 // FmIGSaveFormat:= IG_SAVE_UNKNOWN ; // enumIGSaveFormats;    IG_SAVE_UNKNOWN = $00000000;
 // FmIGScanBits := 0 ; // integer;

  ControlledImage(False);
  ErrorInGearClear;

  //p129t18 dmmn - delete the copied mulipage files
  DeleteFile(FwImgPath);
  DeleteFile(FbImgPath);
  FwImgPath := '';
  FbImgPath := '';
  FoImgPath := '';

    //SourceFormatEnable(true);
  tempimage := GUserDir.Temp + 'multipage.tif';
    //59 s := apppath + '\temp\resetfile.tif';
  s := GUserDir.Temp + 'resetfile.tif';
if CapX.m140CombineScans then
   begin
   if not Fileexists(GUserDir.Temp + 'multipage.tif') and Fileexists(GUserDir.Temp + 'resetfile.tif') then
   CopyFile(GUserDir.Temp + 'resetfile.tif', GUserDir.Temp + 'multipage.tif');
   end;
  DeleteFile(PChar(s));
    { we are doing all Clearing of the Gear1 component here
      We are loading a Blank Image as a way of clearing the component.
      Accusoft's functions : clearimage, and delimage don't do what we want.
      If we want to do any extra processing every time we clear the Gear1
      we can do it in one spot }
  Testmsg('in GearClear');
  FViewingLatestImage := False;
    //p8t35   SetViewAbleImage(true);  {this is done when viewable image is computed}
                           {in loadgear function.  this causes blinking}
     //pnlNonGearSupported.visible := false;
     //tbPlayVideo.visible := false;
  FImageChanged := False;
  Lbviewingimage.caption := '';

  EnableTIFFunctions(False);

    { DONE : Figure out a way to clear Gear, without using the Bitmap }

    //p8t35 Gear 1.loadimage := Blankimage; {TfrmCapMain.GearClear}
    // we're hoping that the Delimage works below.
    //Gear 1.LoadDocument := Blankimage;
  AccusoftPropertiesShow;
    //SetPageControls; // P8T25  //VeHU p8t44 moved to end.
  If FileExists(tempimage) and (not CapX.m140CombineScans) and (not CapX.m140MultSources) Then
    DeleteFile(PChar(tempimage));
  Result := True;
    //p8t35 Gear 1.DelImage := true;
    {Only Deletes the Current Page (if a multipage Image, was loaded using LoadDocument. }
  mg1.ClearImage;
  mg1.updatepageview;
  AnnotationsClose();
//mg1.AnnotationComponent.ClearAllAnnotations;
{ DONE -o129 : The DelDoc below,  may need to use that type of function.
     mg1.ClearImage works like DelDoc}
{ DelDoc : Deleted whole image (all pages) no matter which way the image was loaded }
//p129  Gear 1.DelDoc := True;

//p8t35 Gear 1.ClearImage := true;

(* p129
  hdl := Gear 1.HiGear;
  Testmsg('hi gear after DelDoc = ' + Inttostr(hdl));
  Gear 1.LoadImage := '';
  Gear 1.Update;
  *)
(* before 106
 If ((Scanmode = 'Import') And (Import_Ini = 'COPY')) Then
    Lbformatdesc.caption := Nullsetting;
*)
 (*   If ((Scanmode = 'Import') And (Import_Ini = 'COPY')) Then
 Begin
{/p117 SETTING THE lbFormatDesc.caption here is wrong. It's set when Radio button is clicked
    other variables are also set on the OnClick.  Leave it all done in the Click Event }
 p117 out.
    If FrmCapConfig.TeleReaderConsult.Checked Then
      Lbformatdesc.caption:='DICOM(VL Photo Image Storage)'  //p106 rlm 20101021 CR559
      Else
      Lbformatdesc.caption := Nullsetting;
  End; *)

  AccusoftPropertiesShow; // in : GearClear()
  SetPageControls; //VeHU p8t44 moved to end.
    {       P48T1  Hide the Open Image button for non accusoft images. }
  pnlNonGearSupported.Visible := False;
  {JK 6/27/2012}
  magappmsg('s', '! ! !  G E A R C L E A R   C A L L E D');
End;

{ we are doing all loading of the Gear1 component here
 If we want to do any extra processing for all images loaded, or
 not loaded, we can do it in one spot }

Procedure TfrmCapMain.EnableTIFFunctions(Tf: Boolean);
Begin
  tlbrbtnDeSpeckle.Enabled := Tf;
  tlbrbtnDeSkew.Enabled := Tf;

  DeSpeckle2.Enabled := Tf;
  DeSpeckle1.Enabled := Tf;

  DeSkew2.Enabled := Tf;
  DeSkew1.Enabled := Tf;
End;

{p129t10 gek   this is for the PanWindow issue workaround.}
procedure TfrmCapMain.RELoadGear ;
var image : string;
begin
image := mg1.ImageFilename;
LoadGear(image,'');
end;

Function TfrmCapMain.LoadGear(Image, displaytext: String): Boolean;
Var
    avifile: Boolean;
    imgformat, imgformatdesc,
    unsupmsg: String;
    tempvar : string;
    curNotificationFlags : integer;
Begin
  { 0 - NO_DEBUG: No error dialog box or event
  1 - FIRE_AND_REPORT: Displays an error dialog box when an
  error or warning occurs
  2 - FIRE_ERROR_EVENT: Generates an event when an error or
  warning occurs}
  ControlledImage(False);

  //Gear 1.DebugLevel := 2;    { TODO -o129 -cview : Find equivalent of DebugLevel = 2 for V16 }
  ErrorInGearClear;
  GetIGManager.IGCoreCtrl.Result.Clear;  // 129     {in LoadGear}
  if not GetIGManager.IGCoreCtrl.Result.IsOk then
    showmessage('IGCoreCtl.Result NOT OKAY after Clear ? ');

  curNotificationFlags :=  GetIGManager.IGCoreCtrl.result.NotificationFlags   ;
  GetIGManager.IGCoreCtrl.result.NotificationFlags   := IG_ERR_EVENT_ERROR or IG_ERR_EVENT_WARNING ; //129 T14 // Get Error Dialog Object...

  //129 testing
  (*showmessage('Result.Clear:  notification flags   Before = ' + inttostr(curNotificationFlags)
              +  ' After = ' + inttostr(GetIGManager.IGCoreCtrl.Result.NotificationFlags)
               + #13 + ' .Result.IsOk () = ' + magbooltostr(GetIGManager.IGCoreCtrl.Result.IsOk));*)
  //129 testing End

  Screen.Cursor := crHourGlass;

  WinMsg('', 'LoadGear : ' + Image + '...');
  Try
    If Displaytext = '' Then
      displaytext := Image;

    {/p129  changes for 'supported file format' changes.}
    {p129... out, might be cause of flashing.}
    //p129 Resetcontrols; }
    GearMousePan;
    Result := True;
    AbsByJB := False;  {p129.  need to reset this here because of other changes to
                        to determin functions for a certain extension (file format)}

    { DONE -o129 : FileTypeSupported will be changed, to allow DCM, TXT, PDF...}
    If Not FileTypeSupported(Image, imgformat, imgformatdesc) Then
    Begin
      GearClear;
      {/p94t2 gek 11/20/09  new message for DOC Types.}
      If Uppercase(ExtractFileExt(Image)) = '.DOC' Then
        unsupmsg := 'Word documents no longer supported.  Document could be converted and stored as PDF file.' + #13 + Image
      Else
        unsupmsg := 'Unsupported File Format: ' + Uppercase(ExtractFileExt(Image)) + #13 + Image;

      WinMsg('e', unsupmsg, Pmsg);
      FErrorInGear := True;                                   {in LoadGear  we Add to FErrorInGearList}
      FErrorInGearList.Add('Unsupported File Format: ' + Uppercase(ExtractFileExt(Image)));
      Result := False;
      Exit
    End;

    { TODO -o129 : Error handling..  the Error Event doesn't work like the old Control, at least
           it seems to through errors, continuouly when one is thrown.}
    { so need to try IG_ERROR_NO_ACTION  and then count errors in IGResult.}

    // imgformat is a result of Call to FileTypeSupported.

    { DONE -o129 : ImagTypeNeedsAbs will be changed,  ... maybe to allow DCM, TXT, PDF...
                  not changed.  Below, the FUsingAltViewer will decide to show or not show
                  we will make abs, same as before.}
    absforimage := ImageTypeNeedsAbs(Image); // LoadGear

    //Gear 1.DebugLevel := 2;
    ErrorInGearClear;

    //p129, below    GetViewerFlags(Image, imgformat, Faltviewerneeded, avifile);
    GetViewerFlags(Image, imgformat, FUsingAltViewer, avifile);
    {WPR P59 Quick FIX, if ABSbyJB then this is DCM or TGA(that can't be loaded)
                 so for now, we need to pretend we can't view them, and the code will
                 not try to load it, and give us errors.}
    {p129  AbsByJB, no longer determines if an AltViewer is needed. New Function to
           determine is AltViewer is needed. or just Wanted.}
    { TODO -o129 : FusingAltViewer is a global variable
        so change Function  set FUsingAltViewer, and return true or false.
        Low Priority}
    FUsingAltViewer := AreUsingAltViewer(image);
    if FUsingAltViewer then
    begin
      GearClear;
      absforImage := false;
    end;

   (* If AbsbyJB Then
    Begin
      FaltViewerNeeded := True;
      GearClear;
    End;
    *)
    {Note : In IMPORT, the Format is changed to the format of the selected Image.}
    If CapX.mSourceID = mcSrcImport Then
    Begin
      {/p117 gek 1/28/11 Need the IF in 117, because now Dicom Is a possibility}
      if frmCapConfig.importformat.Checked then
        Lbformatdesc.caption := imgformatdesc;
    End;

    //if ((Scanmode = 'Import') AND (Import_Ini = 'COPY') and (not absforimage))   //LoadGear
    //  then if imgformat <> '' then imagetype := strtoint(imgformat);
    //p129   If absforimage Then //LoadGear
    If not FUsingAltViewer Then //LoadGear
    Begin
      SetViewAbleImage(True);
      //pnlNonGearSupported.visible := false;
      try
        //// ****************** //// ***********************
        //P129t18 dmmn 5/16 make copies of the image for multipage document tif
        if (Uppercase(ExtractFileExt(Image)) = '.TIF') then
        begin
          FoImgPath := image;
          FwImgPath := GUserDir.Temp + 'W^' + ExtractFileName(Image);
          FbImgPath := FwImgPath; // indicate that the image has been copied

          try
            if (image =  (GUserDir.Temp + 'resetfile.tif')) or
               (image = (GUserDir.Temp + 'multipage.tif')) then
            begin
              // if this is a scanned image, the working image will be Fo while Fw will be
              // the back up because those filenames are set to be captured.
              DeleteFile(FoImgPath);
              CopyFile(FwImgPath,FoImgPath);
              mg1.LoadTheImage(FoImgPath);
            end
            else
            begin
              DeleteFile(FwImgPath);
              CopyFile(FoImgPath,FwImgPath);
              mg1.LoadTheImage(FwImgPath);
            end;
          except
            On e: Exception Do
            begin
               WinMsg('s', 'File not copied, error code = '+ IntToStr(GetLastError));
               mg1.LoadTheImage(image);
            end;
          end;
        end { if FileExt = TIF }
        else
        begin
          // no need to copy for other files types
          FoImgPath := '';
          FwImgPath := '';
          FbImgPath := ''; // indicate there's isnt any copy
          mg1.LoadTheImage(image);
        end;

        //// ****************** //// ***********************
        //  winmsg('','In LoadGear:  after LoadTheImage(' + image + ')   Result.IsOK = ' + magbooltostr(GetIGManager.IGCoreCtrl.Result.IsOk));
        mg1.UpdatePageView;
        {t10Check}
        if UPPERCASE(extractfileext(image)) = '.TXT' then
          AnnotationsEnableforImage(false)
          {129t9 Note: the above procedure to Enable for an Image,  first Checks if annotations buttons
                are allowed for the Session (if they are Visible) . So It won't
                enable if the User Doesn't have Privilages. so it's safe to call.
                It doesn't override AnnotationsEnableForSession  }
        else
          AnnotationsEnableforImage(true);

        // If imgformat = '15' {//document} Then
        //   Gear 1.loaddocument := Image
        // Else
        //   Gear 1.LoadImage := Image; {TfrmCapMain.LoadGear}

        Application.Processmessages;
        ZoomScrollApply; //WPR AUTO  (from LoadGear method)
        SetPageControls;

        MagResetPanWindow;
      Except
        On e: Exception Do
        Begin
          GearClear;
          Result := False;
          WinMsg('e', 'Error loading Image: ' + Image);
          WinMsg('s', e.Message);
          FErrorInGear := True;           {Exception calling MagREsetPanWindow  we add to FErrorInGearList}
          FErrorInGearlist.Add(e.Message);
          Exit;
        End;
      End;

      If ErrorInGear(mg1, Image, 'ImageGear: Loading Image') Then       {in LoadGear}
      Begin
        GearClear;
        Result := False; //// gek test ignore error
        Exit; //// gek test ignore error
      End {if erroringear then}
      Else
      Begin
        {  Here we just loaded an Image from Import.  If it is modified, we
            need to know what .saveformat is the correct one.}
        //p129 out        AccusoftPropertiesLog('before setting save format');
        {P129  Need to get format of loaded image, and save in FmIG.. variable.}

        //p129 out Gear 1.Saveformat := Gear 1.Filetype;
{duc change start}
        //p129t18 dmmn since this section used by not only import, like scanning,
        // we need to follow the format scanned in.  ... THE If ScanMode = 'Import'  put in 129t19 by Duc
        if CapX.mSourceID = mcSrcImport then
          CapX.mIGSaveFormat := mg1.GetFileFormatID;
{duc change end}

        //p129 out        AccusoftPropertiesLog('after setting save format');
        AccusoftPropertiesShow;
        { DONE -o129 : we commented out setting of the Zoom..  we may need to verify
                      that this is working as desired.
        Zoom works now, so we can't set to 100 whenever we Load.  it may
                             be other zoom factor,  100 will be actual size.}
        (* p129 out
        If (TbicZoom.Position <> 100) Then
          TbicZoomChange(Self);*)
      End; {if erroringear}

      If mg1.GetBitsPerPixel = 1 then   //(Gear 1.Imagebitsperpixel = 1) Then
        EnableTIFFunctions(True);
    End { If not FUsingAltViewer }
    Else {alternate viewer, here so absforimage = false}
    Begin
      GearClear;
      If avifile Then
      Begin
        btnOpenFile.Visible := False;
        tbPlayVideo.Visible := True;
        SetViewAbleImage(False, Image);

        //pnlNonGearSupported.visible := true;
        tempvar := GetAbsToShow(Image);
        imgCanned.Picture.LoadFromFile(tempvar);

        If FPlayVideoFile Then
          PlayTheFile(True)
        Else
        begin
          /// 3.0.8T33 PlayTheFile(false);
        end;
      End
      Else
      Begin
        { DONE -o129 : This isn't working correctly  the canned bitmap exists.. but isn't shown.
              fixed.  Used TImage instead of TMag4VGear for the simple bmp's}
        btnOpenFile.Visible := True;
        SetViewAbleImage(False, Image);
        //pnlNonGearSupported.visible := true;

        tempvar := GetAbsToShow(Image);
        imgCanned.Picture.LoadFromFile(tempvar);

        tbPlayVideo.Visible := False;
      End;

      mg1.update;
      mg1.UpdatePageView;
    End;

    Lbviewingimage.caption := displaytext;
  Finally
    GetIGManager.IGCoreCtrl.result.NotificationFlags  := curNotificationFlags;   // 129 Reset to current at begging of this call;/
    SetZoomLevel(mg1.GetZoomValue,false);
    Screen.Cursor := crDefault;
    mg1.UpdatePageView;
  End;
End;

function TfrmCapMain.AreUsingAltViewer(image : string): boolean;
Var
  xext, AltViewerFor , Ext: String;
  i: Integer;
  pGear : Tmag4VGear;
Begin
  Ext := Uppercase(ExtractFileExt(image));
  If (Pos('.', Ext) > 0) Then
    Ext := MagPiece(Ext, '.', 2);

  Begin
 //   AltViewerFor := ',MPEG,MPG,MP3,MP4,ASC,AVI,DOC,HTM,HTML,MHTML,MHT,PDF,RTF,WAV,TXT,DCM,';
   AltViewerFor := ',MPEG,MPG,MP3,MP4,ASC,AVI,DOC,HTM,HTML,MHTML,MHT,RTF,WAV,XML,';
   if FAltViewerPDF then AltViewerFor := AltViewerFor + 'PDF,';
   if FAltViewerDCM then AltViewerFor := AltViewerFor + 'DCM,';
   if FAltViewerTXT then AltViewerFor := AltViewerFor + 'TXT,';

   {p129 took out PDF,  TXT ,  DCM}
   { DONE -o129 : Also,  check the NEW INI settings for Use AltViewer for DCM, PDF, TXT}
    xext := ',' + Ext + ',';
    If (Pos(xext, AltViewerFor) > 0) Then
      Result := true
    Else
      Result := false;
  End;
end;

Procedure TfrmCapMain.SetViewAbleImage(Value: Boolean; Image: String = '');
Begin
  mg1.Visible := value; //new
  panel6.Visible := value; //new
  lbnonviewableimage.caption := ''; //p59
  pnlNonGearSupported.Visible := Not Value;
  accu321info.Visible := Value;
  If (Not Value) And (Image <> '') Then
  Begin
    lbnonviewableimage.caption := ExtractFileName(Image) + #13
      + Inttostr((Getfilesize(Image) Div 1024) + 1) + ' KB' + #13
      + DateTimeToStr(FILEDATETIME(Image));
  End;
End;

Procedure TfrmCapMain.GetViewerFlags(Image: String; Itype: String; Var altviewerfile: Boolean; Var avifile: Boolean);
Var
  inttype: Integer;
Begin
  inttype := Strtoint(Itype);

  avifile := (Uppercase(ExtractFileExt(Image)) = '.AVI');
  Case inttype Of
    21, 100..107: altviewerfile := True;
  Else
    altviewerfile := False;
  End;
    (*
          if ext = 'MPG' then itype := '21'
          else if ext = 'ASC' then itype := '103'
          else if ext = 'AVI' then itype := '21'
          else if ext = 'DOC' then itype := '102'
          else if ext = 'HTM' then itype := '101'
          else if ext = 'HTML' then itype := '101'
          else if ext = 'MHT' then itype := '101'
          else if ext = 'MHTML' then itype := '101'
          //,MHT,MHTM,MHTML
          else if ext = 'PDF' then itype := '104'
          else if ext = 'RTF' then itype := '105'
          else if ext = 'WAV' then itype := '106'
          else if ext = 'TXT' then itype := '103'
          else if ext = 'DCM' then itype := '100'
          else if ext = 'BIG' then itype := '3'
          else if ext = 'PAC' then itype := '3'
          else if ext = 'MP3' then itype := '21'
          else if ext = 'MP4' then itype := '21'
          else if ext = 'MPEG' then itype := '21'
          else if ext = 'JPG' then itype := '1'
          else if ext = '756' then itype := '1'
          else if ext = 'TIF' then itype := '15'
          else if ext = 'BMP' then itype := '1'
          else if ext = 'BW' then itype := '3'
          else if ext = 'ABS' then itype := '1'
          else if ext = 'TGA' then itype := '3'; *)
End;

Function TfrmCapMain.SaveGear(Image: String): Boolean;
//var I : integer;
Begin
  If mTestWriteDir.Checked Then
  Begin
    Result := False;
    Exit;
  End;
    { we are doing all Saving of the Gear1 component here
      If we want to do any extra processing for all Saved Images,  we can
      do it in one spot }
    //  Try to stop the automatic Cropping of a Zoomed image
    //      when the image is zoomed using Selection Rectangle Zoom
    // Gear 1.DebugLevel := 2;
  ErrorInGearClear;

  mg1.FitToWindow; //Gear 1.FitMethod := IG_DISPLAY_FIT_TO_WINDOW;
  mg1.update;
  Result := True;
  Try
{ TODO -o129 : This needs back in ...  check first,   }
        (* This was out in 122.... I  think it needs back in .?
        if Gear 1.PageCount > 1 then
          begin
            //  save each page.
           for i := 1 to Gear 1.Pagecount do
             begin
               Gear 1.Page := 1;
               Gear 1.SaveImage := image;
             end;
          end
          else *)
//p129    Gear 1.SaveImage := Image;               //IG_PAGESAVEMODE_OVERWRITE, IG_SAVE_UNKNOWN
//showmessage('about to SavePageToFile: ' + image);
GetIGManager.IGFormatsCtrl.savepagetofile(mg1.GetCurrentPage,image,0,
                                          IG_PAGESAVEMODE_OVERWRITE,
                                          CapX.mIGSaveFormat);
    If ErrorInGear(mg1, Image, 'ImageGear: Save To Network') Then          {in SaveGear}
      Result := False
  Except
    Result := False;
  End;
  mg1.update;
End;


Function TfrmCapMain.AcquireGear16: Boolean;
Var
  DefaultTwainSource: String;
  tempimage: String;
  teststr: String;
  isopen : boolean;
  pagecount : integer;

Begin

pagecount := 1;
 if Not MagTWain1.IsSourceOpen then
      Begin
      isopen := MagTwain1.SourceOpenDefault;
      if not isopen then
        begin
        WinMsg('de', 'TWAIN Device is not open.' + #13
                    + 'select a TWAIN Source from the Configuration Window.') ;
        Result := False;
        Exit;
        end;
      End;

 (* DefaultTwainSource := Gear 1.ScanDefaultDS;
  If DefaultTwainSource = '' Then
  Begin
    If (Gear 1.ScanfirstDS = '') Then
    Begin
      WinMsg('de', 'Cannot find a TWAIN Device installed on this Workstation.');
      Result := False;
      Exit;
    End;
    WinMsg('d', 'You must select a TWAIN Source from the Configuration Window');
    Result := False;
    Exit;
  End;
  *)
    { we are doing all TWAIN capture of the Gear1 component here
      If we want to do any extra processing for all TWAIN Captured Images,  we can
      do it in one spot }

  //  Gear 1.DebugLevel := 2;
  MagTwain1.MagIGErrorInit();
  ErrorInGearClear;
  MagAppMsg('s', ' Before MagAcquireToFile: - ScanShowUI = ' + Magbooltostr(MagTwain1.UseUI) + '  AllPages= ' + Magbooltostr(capX.mMultipage));
  Testmsg('Before MagAcquireToFile  mg1.imagefilename ' + mg1.ImageFilename + '  Valid: ' +  magbooltostr(mg1.IsValidImage));
  Lbviewingimage.caption := 'Acquiring TWAIN  Image...';
  Try
  If Not FModeTest then  iDModObj.GetMagDBBroker1.RPMaggGetTimeout('CAPTURE', teststr);
     //timerStayAlive.Enabled := true;
   tempimage :=  GUserDir.Temp + 'resetfile.tif';    /// single page Tif 

   if CapX.m140CombineScans and (Not CapX.m140PDFConvert)
          then tempimage := GUserDir.Temp + 'multipage.tif';

   if CapX.m140PDFConvert
          then tempimage := GUserDir.Temp + 'magpdf.pdf' ;

    If CapX.mMultipage and NOT CapX.m140PDFConvert
          then tempimage := GUserDir.Temp + 'multipage.tif';

    if (Not CapX.mMultipage) and (not CapX.m140PDFConvert)  and (not CapX.m140CombineScans)
          then tempimage := GUserDir.Temp + 'resetfile.tif';

    if (not CapX.m140MultSources)  and (not CapX.m140CombineScans)
          then  DeleteFile(PChar(tempimage));

    If CapX.mMultipage Then
    Begin
      pagecount := -1;  {p129 }
       /// moved above if (not CapX.m140MultSources)  and (not CapX.m140CombineScans) then  DeleteFile(PChar(tempimage));
            {  for the next 2 lines, we have to set a callback on the OnScanAfterDoc event}
      //      Gear1 .ScanEventActivate(IG_SCANCB_AFTER_PAGE,0);
      //      Gear 1.ScanEventActivate(IG_SCANCB_AFTER_DOC,0);
      AccusoftPropertiesLog('Before 16 ScanPages:  AquireGear');
      teststr := DateTimeToStr(Now);

  {
         MagTwain1.SetCapGroup1(FmIGScanFormat,FmIGScanPixelType,FmIGScanCompression,FmIGScanBitDepth);
         MagTwain1.MagAcquireToFile(<filename> ,  <numpages:int> , FmIGSaveFormat);
         MagTwainLastErrorCheck;
 }
        // SetCapGroup1(FmIGScanFormat,FmIGScanPixelType,FmIGScanCompression,FmIGScanBitDepth);


      MagTwain1.SetCapGroup1(CapX.mIGScanFormat,CapX.mIGScanPixelType,CapX.mIGScanCompression,CapX.mIGScanBitDepth);
///p140test      MagTwain1.MagAcquireToFile(tempimage, pagecount, FmIGSaveFormat)    ; // this is a function Boolean;/
///we will save all scans as PDF'.s s    it can't be this easy...can it. ?

(*   .. this is now done in cMagTwain
 if  ImageType = 104
   then
   begin
   if FmIGScanBitDepth = 1
         then
            fmIGSaveFormat := IG_SAVE_PDF_G4
         else
             fmIGSaveFormat := IG_SAVE_PDF_JPG;
   end;
*)

      magappmsg('s','Before MagAcquireToFile ');
      showCapX(true);
      MagTwain1.MagAcquireToFile(tempimage, pagecount, CapX.mIGSaveFormat)    ; // this is a function Boolean;/
///p140test end
      if MagTwain1.GetLastErrorCount > 0  then
      begin
         winmsg('de','Acquire To File Error');
         result := false;
         exit;
        /// need error handling;
      end;



      Testmsg('Scan 16 Start : ' + teststr + #13 + 'End ' + DateTimeToStr(Now));
      //timerStayAlive.Enabled := False;
      Testmsg('After 16 MagAcquireToFile  mg1.imagefilename ' + mg1.ImageFilename + '  Valid: ' +  magbooltostr(mg1.IsValidImage));
          //   START Duc's CHANGES.  140 Refactor needed.
          //p129t18 dmmn copy for scanned docs also
          FoImgPath := tempimage;
          FwImgPath := GUserDir.Temp + 'W^' + ExtractFileName(tempimage);
          FbImgPath := FwImgPath; // indicate that the image has been copied

          try
            DeleteFile(FwImgPath);
            CopyFile(FoImgPath,FwImgPath);
          except
            On e: Exception Do
            begin
               WinMsg('s', 'File not copied, error code = '+ IntToStr(GetLastError));
            end;
          end;
          
      if FileExists(FwImgPath) then
       //   END Duc's CHANGES.  140 Refactor needed.
      //If FileExists(tempimage) Then
      Begin
        Result := True;
        Mg1.LoadTheImage(FoImgPath);  // this is different than import tif so load original
       /// already loaded.  Gear 1.LoadDocument := tempimage; { TfrmCapMain.AcquireGear}
        SetPageControls;
        Testmsg('SetPageControls 16 after loaddocument');
        Lbviewingimage.caption := 'Image 16 Acquired';
      Testmsg('After 16 LoadTheImage  mg1.imagefilename ' + mg1.ImageFilename + '  Valid: ' +  magbooltostr(mg1.IsValidImage));
        Exit;
      End
      Else
      Begin
        WinMsg('d', 'Scan 16 was unsuccessful');
        btnCancelScanClick(Self);
        Result := False;
        Lbviewingimage.caption := 'Error 16 Acquiring Image';
        Exit;
      End;
    End {  if cb ALLpages.checked}
    Else
    Begin
       pagecount := 1;
     // moved above    if CapX.m140CombineScans
     // moved above      then tempimage := GUserDir.Temp + 'multipage.tif'
     // moved above      else tempimage := GUserDir.Temp + 'resetfile.tif';
     // moved above    if (not CapX.m140MultSources)  and (not CapX.m140CombineScans) then  DeleteFile(PChar(tempimage));



     Testmsg('Before 16 (1 page) MagAcquireToFile  mg1.imagefilename ' + mg1.ImageFilename + '  Valid: ' +  magbooltostr(mg1.IsValidImage));

      AccusoftPropertiesLog('Before  16 MagAcquireToFile: AcquireGear16');
      { Still need the Bits/Per Pixel}
       if MagTwain1.MagAcquireToFile(tempimage, pagecount, CapX.mIGSaveFormat)   // this is a function Boolean;/
          then
            ///  //   START Duc's CHANGES.  140 Refactor needed.
          begin
          //p129t18 dmmn copy for scanned docs also
          FoImgPath := tempimage;
          FwImgPath := GUserDir.Temp + 'W^' + ExtractFileName(tempimage);
          FbImgPath := FwImgPath; // indicate that the image has been copied

          try
            DeleteFile(FwImgPath);
            CopyFile(FoImgPath,FwImgPath);
            mg1.loadtheimage(FoImgPath);
          except
            On e: Exception Do
            begin
               WinMsg('s', 'File not copied, error code = '+ IntToStr(GetLastError));
               mg1.loadtheimage(tempimage);
            end;
          end;


          end;
         //   END Duc's CHANGES.  140 Refactor needed.
         //Gear 1.ScanAcquire := True;
      //timerStayAlive.Enabled := False;
      AccusoftPropertiesLog('After 16  ScanAcquire: AcquireGear');


 Testmsg('After 16 (1 page) MagAcquireToFile  mg1.imagefilename ' + mg1.ImageFilename + '  Valid: ' +  magbooltostr(mg1.IsValidImage));

    End;
    mg1.update;
    If ErrorInGear(mg1, 'TWAIN Image', 'ImageGear: TWAIN Acquiring Image') or ( not mg1.IsValidImage) Then        {in AcquireGear16}
    Begin
      Result := False;
      Lbviewingimage.caption := 'TWAIN 16 Acquisition failed.';
      WinMsg('', 'TWAIN 16  Acquisition failed.');
    End
            // the above is a TEST for Image File that was scanned.
            //   IF THE Scanner was disconnected, we don't get ErrorInGear
            //   so we test for ImageHdib = 0) i.e. nothing in memory.
    Else
    Begin
      Result := True;
      Lbviewingimage.caption := 'Image 16 Acquired';
    End;
        // we can't return true, because CaptureIsValid is called if we do.
        // we have to wait untill the document is finished scanning
        // so we'll call it in the 'AfterMulitPageScan' event;
        (* program execution stops untill the ScanPages is complete, so we
           can process result after the ScanPages command, we don't need the
               Callback.
           *)

        //if cb Allpages.checked then result := false;
    SetPageControls;

    mg1.update;
  Finally
    //timerStayAlive.Enabled := False;
  End;

End;

{/p129  for now, saving the complete old AcquireGear function for comparison}
(* Function TfrmCapMain.zzzzzAcquireGear: Boolean;
Var
  DefaultTwainSource: String;
  tempimage: String;
  teststr: String;
Begin
  DefaultTwainSource := Gear 1.ScanDefaultDS;
  If DefaultTwainSource = '' Then
  Begin
    If (Gear 1.ScanfirstDS = '') Then
    Begin
      WinMsg('de', 'Cannot find a TWAIN Device installed on this Workstation.');
      Result := False;
      Exit;
    End;
    WinMsg('d', 'You must select a TWAIN Source from the Configuration Window');
    Result := False;
    Exit;
  End;
    { we are doing all TWAIN capture of the Gear1 component here
      If we want to do any extra processing for all TWAIN Captured Images,  we can
      do it in one spot }
  Gear 1.DebugLevel := 2;
  FErrorInGear := False;
  FErrorInGearList.Clear;
  MagAppMsg('s', 'Before ScanAcquire - ScanShowUI = ' + Magbooltostr(Gear 1.ScanShowUI) + '  AllPages= ' + Magbooltostr(cb ALLPages.Checked));
  Testmsg('Before ScanAcquire HiGear= ' + Inttostr(Gear 1.HiGear) + '  ImageHdib= ' + Inttostr(Gear 1.ImageHdib));
  Lbviewingimage.caption := 'Acquiring TWAIN Image...';
  Try
    iDModObj.GetMagDBBroker1.RPMaggGetTimeout('CAPTURE', teststr);
        //timerStayAlive.Enabled := true;
    If cb ALLPages.Checked Then
    Begin
      tempimage := G UserDir.Temp + 'm ultipage.tif';
      DeleteFile(PChar(tempimage));
            {  for the next 2 lines, we have to set a callback on the OnScanAfterDoc event}
      //      Gear 1.ScanEventActivate(IG_SCANCB_AFTER_PAGE,0);
      //      Gear 1.ScanEventActivate(IG_SCANCB_AFTER_DOC,0);
      AccusoftPropertiesLog('Before ScanPages:  AquireGear');
      teststr := DateTimeToStr(Now);
      Gear 1.Scanpages := tempimage;
      Testmsg('Scan Start : ' + teststr + #13 + 'End ' + DateTimeToStr(Now));
      //timerStayAlive.Enabled := False;
      Testmsg('After ScanPages HiGear= ' + Inttostr(Gear 1.HiGear) + '  ImageHdib= ' + Inttostr(Gear 1.ImageHdib));
      If FileExists(tempimage) Then
      Begin
        Result := True;
        Gear 1.LoadDocument := tempimage; { TfrmCapMain.AcquireGear}
        SetPageControls;
        Testmsg('SetPageControls after loaddocument');
        Lbviewingimage.caption := 'Image Acquired';

        Exit;
      End
      Else
      Begin
        WinMsg('d', 'Scan was unsuccessful');
        btnCancelScanClick(Self);
        Result := False;
        Lbviewingimage.caption := 'Error Acquiring Image';
        Exit;
      End;
    End {  if cb ALLpages.checked}
    Else
    Begin
      Testmsg('BEFORE SCAN ACQUIRE');
      AccusoftPropertiesLog('Before ScanAcquire: zzzzzAcquireGear');
      Gear 1.ScanAcquire := True;
      //timerStayAlive.Enabled := False;
      AccusoftPropertiesLog('After ScanAcquire: zzzzzAcquireGear');
            // below instead of ScanAcquire
          //////////////////
      {
           //tempimage :=  tempdir + 'scanpage.jpg';
            Gear 1.ScanCapsType := IG_SCAN_CAP_XREFCOUNT;  //‘scan 5 pages
            Gear 1.ScanCapsIntValue := 1;
            Gear 1.ScanPages  := tempimage;

            if fileexists(tempimage) then
              begin
                result := true;
                Gear 1.LoadDocument := tempimage; { TfrmCapMain.zzzzzAcquireGear}
                SetPageControls;
                testmsg('SetPageControls after loaddocument');
                lbviewingimage.caption := 'Image Acquired';
                exit;
              end
            else
              begin
                winmsg('d', 'Scan was unsuccessful');
                btnCancelScanClick(Self);
                result := false;
                lbviewingimage.caption := 'Error Acquiring Image';
                exit;
              end;

        }
       ////////////////////////

      Testmsg('After ScanAcquire HiGear= ' + Inttostr(Gear 1.HiGear) + '  ImageHdib= ' + Inttostr(Gear 1.ImageHdib));
    End;
    mg1.update;
    If E rrorInGear(mg1, 'TWAIN Image', 'Acquiring TWAIN Image') Or (Gear 1.ImageHdib = 0) Then
    Begin
      Result := False;
      Lbviewingimage.caption := 'TWAIN Acquisition failed.';
      WinMsg('', 'TWAIN Acquisition failed.');
    End
            // the above is a TEST for Image File that was scanned.
            //   IF THE Scanner was disconnected, we don't get ErrorInGear
            //   so we test for ImageHdib = 0) i.e. nothing in memory.
    Else
    Begin
      Result := True;
      Lbviewingimage.caption := 'Image Acquired';
    End;
        // we can't return true, because CaptureIsValid is called if we do.
        // we have to wait untill the document is finished scanning
        // so we'll call it in the 'AfterMulitPageScan' event;
        { program execution stops untill the ScanPages is complete, so we
           can process result after the ScanPages command, we don't need the
               Callback.
           }

        //if cb Allpages.checked then result := false;
    SetPageControls;

    mg1.update;
  Finally
    //timerStayAlive.Enabled := False;
  End;

End;   *)

Procedure TfrmCapMain.AfterMultiPageScan;
Begin
  (*  //  wiNmsg('','After MultiPage Scan');
    //  winmsg('',' --');
  Gear1.LoadDocument := UserDir.Temp + 'mulitpage.tif'; {TfrmCapMain.AfterMultiPageScan;}
  If E rrorInGear(Gear1, 'TWAIN Image', 'Acquiring TWAIN Image') Then
  Begin
    WinMsg('', 'Error Loading the Scanned MultiPage file ');
    Exit;  *)

End;

  { TODO -o129 : this ErrorInGear needs modified to V16}
Function TfrmCapMain.ErrorInGear(mgGear: TMag4VGear; Filename: String; action: String; noshow: Boolean = False): Boolean;
Var
  i: Integer;
  s, S2: String;
  c: String;
  ocxerror: Boolean;
  ///  errorRecord As IGResultRecord
  errorRecord : IGResultRecord;
Begin
  Result :=  GetIGManager.IGCoreCtrl.Result.IsOk(); //p129             {in ErrorInGear}

  //129 TEST Start next line  not for release.
  winmsg('s','Function ErrInGear: IsOk - '+ magbooltostr(result));

  (*showmessage('Error In Gear  Result.IsOk : ' + magbooltostr(result) + #13
              + 'notification flags  = ' + inttostr(int) + #13
              + 'RecordsTotal : ' + inttostr(GetIGManager.IGCoreCtrl.Result.RecordsTotal)
              + #13 + #13
              + 'FErrorInGear : ' + magbooltostr(FErrorInGear)) ; *)
  //129 Test End

  ///////////// &********************   this below is before 129 and Accusoft Exception Updates.
  ocxerror := False;
  {  We set Result equal to FErrorInGear, bacause FErrorInGear can be set by other functions.   this way the ErrorInGear
     function is aware of other errors set by app}
  Result := FErrorInGear;

  If FErrorInGear Then
  Begin
    s := ' *** ' + Inttostr(FErrorInGearlist.Count) + ' Accusoft Errors ***';
    S2 := ' ***   for File :' + Filename + '   Action was: ' + action;
    If noshow Then
      c := 's'
    Else
      c := '';

    WinMsg(c, s);
    WinMsg(c, S2);
    s := s + #13 + S2;
    For i := FErrorInGearlist.Count - 1 Downto 0 Do
    Begin
      S2 := '*** Error  - ' + Inttostr(i + 1) + ' of ' + Inttostr(FErrorInGearlist.Count) + '  ' + FErrorInGearlist[i];
      If Pos(' OCX ', S2) > 0 Then
        OCXError := True;
      If Pos(' LZW ', S2) > 0 Then
        OCXError := False;

      If noshow Then
        c := 's'
      Else
        c := 'E';

      WinMsg(c, S2);
      s := s + #13 + S2;
    End;

    If OCXerror Then
    Begin
      noshow := True;
      Result := False;
      WinMsg('s', 'Ignoring - Accusoft OCX Error');
      WinMsg('s', s);
            // ignoring OCX Errors
      WinMsg('', 'OCX Warning');
    End;

    If Not noshow Then
      Messagedlg(s, Mterror, [Mbok], 0);
  End;
End;

Procedure PageGear(xpage: Integer);
Begin

End;

Procedure TfrmCapMain.AccusoftPropertiesLog(Desc: String);
Begin
  WinMsg('s', Desc);
  WinMsg('s', 'MagFileObj.FullFileName: ' + MagFileObj.FullFileName); {In  AccusoftPropertiesLog}
    // winmsg('s', '  - dirx=     ' + dirx);
   //  winmsg('s', '  - filesave= ' + filesave);
  WinMsg('s', '  - glbvar Format =     ' + CapX.mFormat);
  WinMsg('s', '  - glbvar ScanMode= ' + CapX.GetSourceDesc );
  WinMsg('s', '  - lbInputSourceDesc=  ' + LbInputSourceDesc.caption);
  WinMsg('s', '  - lbFormatDesc= ' + Lbformatdesc.caption);
//P129   WinMsg('s', '  - .saveformat=   ' + '(' + Inttostr(Gear 1.Saveformat) + ')' + GetSaveFormat(Gear 1 ));
//P129   WinMsg('s', '  - .compresstype= ' + Gear 1.CompressType);
//P129   WinMsg('s', '  - .filetype    =   ' + '(' + Inttostr(Gear 1.Filetype) + ')' + GetLoadedFormat(Gear 1));
//P129   WinMsg('s', '  - .scanbits=     ' + Inttostr(Gear 1.Scanbits));
//P129   WinMsg('s', '  - .bits/pixel    ' + Inttostr(Gear 1.Imagebitsperpixel));

   WinMsg('s', '  - CapX.mIGSaveFormat =   ' + '(' + Inttostr(CapX.mIGSaveFormat) + ')' + ' <format desc>');
if mg1.IsValidImage then
     begin
     WinMsg('s', '  - .compression= ' + inttostr( mg1.GetCurrentPage.Compression) + mg1.GetCompression  );
     WinMsg('s', '  - GetBitsPerPixel    ' + inttostr(mg1.GetBitsPerPixel ));
     end
     else winmsg('s','  - MagVGear - No Image loaded');


  // WinMsg('s', '  - .scanbits=     ' + Inttostr(Gear 1.Scanbits));

End;

Procedure TfrmCapMain.ShowImageGearInfotomsgwindow1Click(Sender: Tobject);
Begin
  AccusoftPropertiesLog('From Menu Option : ');
  MagAppMsgShow;
End;

Procedure TfrmCapMain.ImportFile(LV1: TListView; Inc: Integer);
Var
  Selecteditem: TListItem;
  importdir: String;
  Gearstat: Boolean;
Begin
  lv1.Update;
if not CapX.m140MultSources then  //p140t1
  pnlimport.Enabled := False;
  pnlimport.Update;
  Try
    If lv1.Selcount = 0 Then
    Begin

      LV1.Selected := LV1.Items[0];
      lv1.ItemFocused := lv1.Items[0];
      Inc := 0;
    End;
    Selecteditem := lv1.Selected;
    Case Inc Of
      1: Selecteditem := lv1.Getnextitem(Selecteditem, sdLeft, [IsNone]);
      2: Selecteditem := lv1.Getnextitem(Selecteditem, SdAbove, [IsNone]);
      3: Selecteditem := lv1.Getnextitem(Selecteditem, sdRight, [IsNone]);
      4: Selecteditem := lv1.Getnextitem(Selecteditem, sdBelow, [IsNone]);
      99: Selecteditem := lv1.Items[lv1.Items.Count - 1];
    End;
    If Selecteditem = Nil Then
      Selecteditem := lv1.Selected;
    FGfiletoImport := Selecteditem.caption;
    importdir := Selecteditem.SubItems[3];
    If FGfiletoImport = '' Then
    Begin
      WinMsg('', 'No file selected. Select an Import directory from the ''Options'' Menu');
      Exit;
    End;
    If FlockScrollBarsAlways Then
      ZoomScrollSave;
        //   GearClear;  out for  P59t25 see if blinking

    // p129t18 disable image manips for PDF files
    if (UpperCase(ExtractFileExt(FGFiletoImport)) = '.PDF') then
      DisableImageManips(true)
    else
      DisableImageManips(false);

    gearstat := LoadGear(importdir + '\' + FGfiletoImport, importdir + '\' + FGfiletoImport);
    pnlimport.Enabled := True;
    lv1.Enabled := True;
    lv1.SetFocus;
    {/P122 DMMN 6/24/2011 - Enable annotation button if the image loaded fine, otherwise, stay disabled/}
    {/p122t6 dmmn 10/14 - only enable when not in batch mode /}
               { DONE -ogarrett-c129 : TEST }
    { DONE -ogarrett-c129 :  gek 129t9...  this needs looked into..  now some image formats (txt, asc) can't be annotated...
                 and the button may be NOT visible, and we'll get error if try to enable...}

    {the LoadGear function enabled/disables annotation based on some criteria.  we don't want to ReEnable
          based on Batch mode, only Disable for this image.}
    if cbBatch.Checked then
    begin
      AnnotationsEnableforImage(false) // tlbrbtnAnnotation.Enabled := False
    end;
{129T10  gek took out the Else..  not needed here.  t10Check}
//    else
//      AnnotationsEnableforImage(true) ; // tlbrbtnAnnotation.Enabled := True;

    TIFWarnFirst := True;   //p122t11
    If Not gearstat Then
    Begin
      //tlbrbtnAnnotation.Enabled := False; //P122  -->  129t9 this is enabled/disabled in GearClear
      Selecteditem.ImageIndex := 5;
      GearClear;
      Exit;
    End;
    WinMsg('', 'Click ''Capture'' or press ''<Enter>'' to capture the Image.');
  Except
    On e: Exception Do
    Begin
      WinMsg('e', 'ERROR Loading  ' + e.Message + ' ' + FGfiletoImport);
      GearClear;
      lv1.Enabled := True;
      pnlimport.Enabled := True;
    End;
  End; {try except}
End;

(*function TfrmCapMain.ConvertTextExt(filename: string): string;
begin
  result := ExtractFileExt(filename);
  if uppercase(result) = '.TXT' then result := '.ASC';
end; *)

Procedure TfrmCapMain.lvImport1KeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
Begin
  If Not btnCapture.Enabled Then
    Exit;
  Case Key Of
    VK_Return:
      Begin
        ImportFile(TListView(Sender), 0);
        If Not cbBatch.Checked Then
          btnCapture.Click
      End;
    37: ImportFile(TListView(Sender), 1); // left arrow
    38: ImportFile(TListView(Sender), 2); // up arrow
    39: ImportFile(TListView(Sender), 3); // right arrow
    40: ImportFile(TListView(Sender), 4); // down arrow
  End;
End;

Procedure TfrmCapMain.mnuviewListClick(Sender: Tobject);
Begin
  LvImport1.ViewStyle := Vslist;
  mnuviewList.Checked := True;
End;

Procedure TfrmCapMain.mnuviewDetailsClick(Sender: Tobject);
Begin
  LvImport1.ViewStyle := Vsreport;
  mnuviewDetails.Checked := True;
End;

Procedure TfrmCapMain.lvImport1Columnlick(Sender: Tobject; Column: TListColumn);
Begin
  sortinverse := Not sortinverse;
  curcolumnindex := Column.Index;
  LvImport1.CustomSort(Nil, 0);
End;

Procedure TfrmCapMain.lvImport1Compare(Sender: Tobject; Item1,Item2: TListItem; Data: Integer; Var Compare: Integer);

Var
  Lic1, Lic2: String;
Begin
  Case curcolumnindex Of
    0:
      Begin
        Lic1 := Item1.caption;
        Lic2 := Item2.caption;
      End;
    3:
      Begin
        Lic1 := Formatdatetime('yy/mm/dd hh:mm', Strtodatetime(Item1.SubItems[curcolumnindex - 1]));
        Lic2 := Formatdatetime('yy/mm/dd hh:mm', Strtodatetime(Item2.SubItems[curcolumnindex - 1]));
      End;
  Else
    Begin
      Lic1 := Item1.SubItems[curcolumnindex - 1];
      Lic2 := Item2.SubItems[curcolumnindex - 1];
    End;
  End;
  If sortinverse Then
    Compare := -Lstrcmp(PChar(Lic1), PChar(Lic2))
  Else
    Compare := Lstrcmp(PChar(Lic1), PChar(Lic2));
End;

Procedure TfrmCapMain.mnuBatchAdvancedClick(Sender: Tobject);
Begin
  FrmCapBatchAdv.Show;
End;

Procedure TfrmCapMain.AdvancedBatchEnable(Value: Boolean);
Begin
    (*  FBatchAdvEnable := value;
      if value
        then
        begin
          frmCapBatchAdv.show;
          FbatchAdvCopyAll := frmCapBatchAdv.CopyAll.Checked;
          if frmCapBatchAdv.cboModality.ItemIndex = frmCapBatchAdv.cboModality.Items.IndexOf('<Select Modality>');

          FbatchAdvModality := magpiece(frmCapBatchAdv.cbxModality.items[frmCapBatchAdv.cbxModality.itemindex], ' ', 1); {procedure}
        end
      else
        begin
          frmCapBatchAdv.cboModality.ItemIndex := frmCapBatchAdv.cboModality.Items.IndexOf('<Select Modality>');
          frmCapBatchAdv.copyall.checked := false;
          frmCapBatchAdv.hide;
        end;
      *)
End;

Procedure TfrmCapMain.cbBatchClick(Sender: Tobject);
Begin
    {Ask them if they want to switch to a Group}
  If (cbBatch.Checked And (Not FrmCapConfig.ImageGroup.Checked)) Then
  Begin
    If Messagedlg('You must be capturing to an Image Group to enable Batch Import' + #13 +
      'Switch to Image Group and continue ? ', Mtconfirmation, [Mbok, Mbcancel], 0)
      = MrCancel Then
    Begin
      cbBatch.Checked := False;
      SyncBatch;
      Exit;
    End
    Else
    Begin
      FrmCapConfig.ImageGroup.Checked := True; //
    End;

  End;

  If cbBatch.Checked Then
  Begin
    MagAppMsg('', 'Annotations are disabled in batch mode.');

    {/P122 DMMN 6/24/2011 - Disable Annotation if the user decided to capture a
    batch images /}
 { DONE -oGARRETT -c129 : 
         also need to check this ...  annotation can be now disabled because of Image 
         format.  i.e. TXT,  ASC... }   
    AnnotationsEnableforImage(false); // tlbrbtnAnnotation.Enabled := False
//    if fCapAnnot <> nil then
    {/p122 dmmn WPR Capture Item #8 /}
//p129   if fCapAnnot.HasAnnotationComponent then     //P122 DMMN 6/28/2011 - Keep the panel kill annotation comp
    if AnnotationsExist() then
    begin
      AnnotationsClose();
      MagAppMsg('', 'User entered batch mode. Annotations were cleared');
    end;

    SyncBatch;
    ShowBatchListView;
    If FBatchShowOptions Then
      OpenBatchOptions;
  End
  Else
  begin
    {the following call will enable only if Annotations are enabled for session. 
     it is safe to call at any time.}
    AnnotationsEnableforImage(true); // tlbrbtnAnnotation.Enabled := true
    //P122 enable annotation if not in batch mode
    HideBatchListView;
  end;
  SyncBatch;
End;

Procedure TfrmCapMain.SyncBatch;
Begin
  If FrmCapConfig.cbImportBatch.Checked <> cbBatch.Checked Then
    FrmCapConfig.cbImportBatch.Checked := cbBatch.Checked;
End;

Procedure TfrmCapMain.OpenBatchOptions;
Begin
  FrmCapBatchOptions.Execute(FBatchEditDescOnSave, FBatchShowOptions, FBatchDelete);
End;

Procedure TfrmCapMain.ShowBatchListView;
Begin
    //pBatch.visible := true;
  LvImport1.MultiSelect := True;
  If pnlimport.Height < 200 Then
    pnlimport.Height := 200;
  Splitter5.Height := 8;
  pBatch.Height := Trunc(pnlimport.Height / 2);
End;

Procedure TfrmCapMain.HideBatchListView;
Begin
    //pBatch.visible := false;
  LvImport1.MultiSelect := False;
  Splitter5.Height := 1;
  pBatch.Height := 1;
End;

Procedure TfrmCapMain.MoveSelectedToBatch1Click(Sender: Tobject);
Begin
  If ((LvImport1.MultiSelect = True)
    And (Splitter5.Height > 1)
    And (pBatch.Height > 1)
    And (LvImport1.Selcount > 0)) Then
    MoveSelected(LvImport1, Lvbatch);

End;

Procedure TfrmCapMain.lvBatchDragOver(Sender, Source: Tobject; x, y: Integer; State: TDragState; Var Accept: Boolean);
Begin
    //59  if source = lvImport1 then accept := true
    //59  else accept := false;

  Accept := (Source Is TListView);
End;

Procedure TfrmCapMain.lvImport1DragOver(Sender, Source: Tobject; x, y: Integer; State: TDragState; Var Accept: Boolean);
Begin
    //59  if source = lvBatch then accept := true
    //59  else accept := false;
  Accept := (Source Is TListView);
End;

Procedure TfrmCapMain.lvImport1DragDrop(Sender, Source: Tobject; x, y: Integer);
Var
  Li, Linew: TListItem;
  liold: TListItem;
Begin
  If (Source = Lvbatch) Then
  Begin
    Li := LvImport1.GetItemAt(x, y);
    MoveSelected(TListView(Source), TListView(Sender), Li);
    Exit;
  End;
  If Source = LvImport1 Then
  Begin
    liold := LvImport1.Selected;
    WinMsg('', liold.caption + '  old');
    Li := LvImport1.GetItemAt(x, y);
    If Li = Nil Then
      Linew := LvImport1.Items.Add
    Else
      Linew := LvImport1.Items.Insert(Li.Index);
    Linew.Assign(liold);
    liold.Delete;
  End;
End;

Procedure TfrmCapMain.lvBatchDragDrop(Sender, Source: Tobject; x, y: Integer);
Var
  Li, Linew: TListItem;
  liold: TListItem;
    //t: tstrings;
Begin
  If (Source = LvImport1) Then
  Begin
    Li := Lvbatch.GetItemAt(x, y);
    MoveSelected(TListView(Source), TListView(Sender), Li);
    Exit;
  End;
  If Source = Lvbatch Then
  Begin
    liold := Lvbatch.Selected;
    WinMsg('', liold.caption + '  old');
    Li := Lvbatch.GetItemAt(x, y);
    If Li = Nil Then
      Linew := Lvbatch.Items.Add
    Else
      Linew := Lvbatch.Items.Insert(Li.Index);
    Linew.Assign(liold);
    liold.Delete;
  End;



End;

Procedure TfrmCapMain.MoveSelected(FromLV, ToLV: TListView; Li: TListItem = Nil);
Var
  Listitem: TListItem;
  indx: Integer;
Begin
  If Li <> Nil Then
    indx := Li.Index
  Else
    indx := -1;
  While FromLV.Selcount > 0 Do
  Begin
    Listitem := FromLV.Selected;
    FileToListView(Listitem.SubItems[3] + '\' + Listitem.caption, ToLV, indx);
    If indx <> -1 Then
      indx := indx + 1;
    Listitem.Delete;
    FromLV.Update;
  End;
End;

Procedure TfrmCapMain.lvBatchClick(Sender: Tobject);
Begin
  If (TListView(Sender).Selected = Nil) Then
    Exit;
  ImportFile(TListView(Sender), 0);
End;

Procedure TfrmCapMain.lvBatchColumnClick(Sender: Tobject;
  Column: TListColumn);
Begin
  sortinverse := Not sortinverse;
  curcolumnindex := Column.Index;
  Lvbatch.CustomSort(Nil, 0);
End;

Procedure TfrmCapMain.lvBatchCompare(Sender: Tobject; Item1, Item2: TListItem; Data: Integer; Var Compare: Integer);

Var
  Lic1, Lic2: String;
Begin
  Case curcolumnindex Of
    0:
      Begin
        Lic1 := Item1.caption;
        Lic2 := Item2.caption;
      End;
    3:
      Begin
        Lic1 := Formatdatetime('yy/mm/dd hh:mm', Strtodatetime(Item1.SubItems[curcolumnindex - 1]));
        Lic2 := Formatdatetime('yy/mm/dd hh:mm', Strtodatetime(Item2.SubItems[curcolumnindex - 1]));
      End;
  Else
    Begin
      Lic1 := Item1.SubItems[curcolumnindex - 1];
      Lic2 := Item2.SubItems[curcolumnindex - 1];
    End;
  End;
  If sortinverse Then
    Compare := -Lstrcmp(PChar(Lic1), PChar(Lic2))
  Else
    Compare := Lstrcmp(PChar(Lic1), PChar(Lic2));
End;

Procedure TfrmCapMain.lvBatchKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
Begin
  If Not btnCapture.Enabled Then
    Exit;
  Case Key Of
    VK_Return: ImportFile(TListView(Sender), 0);
    37: ImportFile(TListView(Sender), 1); // left arrow
    38: ImportFile(TListView(Sender), 2); // up arrow
    39: ImportFile(TListView(Sender), 3); // right arrow
    40: ImportFile(TListView(Sender), 4); // down arrow
  End;
End;

Procedure TfrmCapMain.List1Click(Sender: Tobject);
Begin
  Lvbatch.ViewStyle := Vslist;
  List1.Checked := True;
End;

Procedure TfrmCapMain.Details1Click(Sender: Tobject);
Begin
  Lvbatch.ViewStyle := Vsreport;
  Details1.Checked := True;
End;

Procedure TfrmCapMain.lvImport1MouseUp(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
var
  buttonSelected : Integer;
  mess : string;
Begin
    (*if Tlistview(sender).selcount = 0 then exit;
    if Tlistview(sender).selcount > 1 then exit;
    if not (Tlistview(sender).selected = nil) then ImportFile(Tlistview(sender), 0);
    *)

  {/P122 DMMN 6/23/2011 - Warn user with possible lost of annotation made for the
  loaded image /}
  {/p122 dmmn WPR Capture Item #17- I checked and still think this should still be here /}
  {/p122 dmmn WPR Capture Item #8 /}
 (* if (fCapAnnot.HasAnnotationComponent) then //P122 DMMN 6/28/2011 - check the actual thing to do annotations
  begin
    if fCapAnnot.MarkCount > 0 then //p122 dmmn 7/28 - only ask if there's actual annotation
    *)
  if AnnotationsExist() then

    begin
      {/p122 dmmn WPR Capture Item #18 /}
      mess := 'You are loading a new image. Annotations will be discarded.' + slinebreak +
              'Click "OK" to proceed.';
      buttonSelected := MessageDlg(mess,mtCustom,mbOKCancel,0);

      // user decided not to change the image
      if buttonSelected = mrCancel then Exit;
      if buttonSelected = mrOK then
      begin
        AnnotationsClose(); //fCapAnnot.Close;  // P122 DMMN 6/28/2011 - only clear the annotation component
        {JK 6/27/2012 - free the gear and instantiate a new one for the new image.}
        GearClear;
        MagAppMsg('s', 'User switched image. Annotations Discarded');
      end;
    end
    else
     AnnotationsClose(); // fCapAnnot.Close;
 //end;
   If (TListView(Sender).Selcount = 1) Then
    ImportFile(TListView(Sender), 0);
End;

Procedure TfrmCapMain.mBatchOptionsClick(Sender: Tobject);
Begin
  OpenBatchOptions;
End;

Procedure TfrmCapMain.lbImportClick(Sender: Tobject);
Begin
  SelectImportDirectory4(LbImport.caption);
End;

Procedure TfrmCapMain.mImportDir2Click(Sender: Tobject);
Begin
  SelectImportDirectory4(LbImport.caption);
End;

Procedure TfrmCapMain.edtProcDateEnter(Sender: Tobject);
Begin
  btnImageOK.Default := False;
  EdtProcDate.Modified := False;
End;

Procedure TfrmCapMain.TimeoutTimerTimer(Sender: Tobject);
Begin
    //if application.terminated then exit;
  TimeOutTimer.Enabled := False;

  If MagTimeoutform.Visible Then
    Exit;
  MagTimeoutform.Setapplication(MagappCapture);
  MagTimeoutform.Showmodal;
  If MagTimeoutform.ModalResult = MrOK Then
  Begin
        // need this flag to bypass any check in OnCloseQuery.
    timerclose := True;
    Frmcapmain.Close;
    Exit;
  End
  Else
    TimeoutTimer.Enabled := True;
End;

Procedure TfrmCapMain.ChangeTimeoutValue1Click(Sender: Tobject);
Begin
  MagTimeoutform.SetApplicationTimeOut('', TimeoutTimer);
End;

Procedure TfrmCapMain.GearCopy;
Begin
mg1.CopyToClipboard;
winmsg('','mg1 - copy to clipboard.');
End;

Function TfrmCapMain.PasteGear: Boolean;
Begin
    //Gear 1.DebugLevel := 2;
    ErrorInGearClear;
    GetIGManager.IGCoreCtrl.Result.Clear;

application.ProcessMessages;  {also to initialize... first Paste not showing }
magappmsg('s',' *** Starting PasteGear function ***');  {also to initialize... first Paste not showing }
result := true;
mg1.ClearImage;
{ DONE -o129 :  need a Paste function.}
//mg1.GetCurrentPage.
mg1.PasteFromClipboard;
  { DONE -o129 -cRF : Need to return True or false if successful/error.}

  //p129 Gear 1.Delimage := True;
  //p129  Gear 1.ClipboardPaste := True;
  If ErrorInGear(mg1, 'Paste', 'ImageGear: Paste from Clipboard') Then        {in PasteGear}
    Result := False
  Else
    Result := True;

if mg1.GetBitsPerPixel = 0  then

    Result := False;
 (*   PasteFromClip throws error when getting properties
  because the ImageDisplay TMag4VGear assumes the file is on harddrive. *)
       //// AccusoftPropertiesShow;
  WinMsg('', 'Paste Complete.');
SaveLoadPastedImage;
magappmsg('s',' *** End -  PasteGear function ***'); 
End;

Procedure TfrmCapMain.mCPRSLinkOptionsClick(Sender: Tobject);
Begin
  MagSyncCPRSf.GetCPRSLinkOptions(CprsSync);
  If Not CprsSync.SyncOn Then
  Begin
    If MagSyncCPRSf.VerifyBreakCPRSLink Then
    Begin
      EnablePatientLookupLogin(True);
      CprsSync.SyncOn := False;
      SetCapRunMode(magrmAlone);
      //CprsStartedME := False;                {mCPRSLinkOptionsClick}
    End
    Else
      CprsSync.SyncOn := True;
  End;
  Exit;
End;

Procedure TfrmCapMain.MnuRefreshClick(Sender: Tobject);
Var
  MagSelectImportDirf: TMagSelectImportDirf;
Begin
  MagSelectImportDirf := TMagSelectImportDirf.Create(Self);
  MagSelectImportDirf.DirectoryListBox2.Directory := LbImport.caption;
    //MagSelectImportDirf.filelistbox1.mask := lbfilter.caption;
  MagSelectImportDirf.ComboBox1.Text := lbfilter.caption;
  MagSelectImportDirf.Update;

    //MagSelectImportDirF.showmodal;
    //if MagSelectImportDirF.modalresult = mrOK then
    //   begin
  loadimportfiles(MagSelectImportDirf);
    //   end;
  ChDir(AppPath);
  MagSelectImportDirf.Release;
End;

Procedure TfrmCapMain.CreateVideoWindow;
Begin
  If Not Doesformexist('frmVideoPlayer') Then
  Begin
    FrmVideoPlayer := TfrmVideoPlayer.Create(Self);
    FrmVideoPlayer.Top := Top + Height - ClientHeight + imagepanel.Top + tlbarImage.Height + Panel6.Height + 20;
    FrmVideoPlayer.Left := Left + pnldata.Width + Width - ClientWidth + 20;
  End;

End;

Procedure TfrmCapMain.PlayPatVideoImage(Image, Desc: String; Magien: String = '');
Var
  altviewer: String;
Begin
  If Not FuseAltViewer Then
  Begin
    If Not Doesformexist('VideoF') Then
      CreateVideoWindow;
    Application.Processmessages;
        //frmVideoPlayer.ImageData.Mag0 := iDModObj.GetMagPat1.M_DFN;
    FrmVideoPlayer.Show;

    FrmVideoPlayer.InitFile(Image, Desc, Magien);
    FrmVideoPlayer.caption := 'Video Player : ' + iDModObj.GetMagPat1.M_NameDisplay;
    FrmVideoPlayer.Update;
    Application.Processmessages;
        //if run then frmVideoPlayer.StartPlay;
    Screen.Cursor := crDefault;
    Exit;
  End;
   { TODO -cp129 : check OS for default Alt Viewer. }
  altviewer := GetIniEntry('Workstation settings', 'Alternate Video Viewer');
  winmsg('s','using Alternate Video Viewer : ' + altviewer);
  If (altviewer <> '')
    Then
      if not fileexists(altviewer)  then
           begin
             SetIniEntry('Workstation settings', 'Alternate Video Viewer','');
             winmsg('s','INVALID. Application does not exist :    ' + altviewer );
             winmsg('s',' -- removing INVALID Video Viewer from configuration  :   ' + GetConfigFileName);
             altviewer := '';
           end;
  if (altviewer <> '')
    then
      Magexecutefile(altviewer, Image, '', SW_SHOW)
    Else
      Magexecutefile(Image, '', '', SW_SHOW);

    {procedure InitFile(videofile,desc : string);
        procedure StartPlay;
      end;
    var
      VideoF: TVideoF;}
End;

Procedure TfrmCapMain.PlayTheFile(Run: Boolean);
Var
  altviewer: String;
  image : string;
  dir : string;
Begin
  dir := lbImport.caption;
  RmvSlash(0,dir);
  image := dir + '\' + FGfiletoImport;
    //SupportedFiles bmk
  If Not FuseAltViewer Then
  Begin
    If Not Doesformexist('VideoF') Then
      CreateVideoWindow;
    Application.Processmessages;
    FrmVideoPlayer.ImageData := Nil;

        //frmVideoPlayer.ImageData.Mag0 := iDModObj.GetMagPat1.M_DFN;
    FrmVideoPlayer.Show;

    FrmVideoPlayer.InitFile(image, image );
    FrmVideoPlayer.caption := 'Video Player : ' + image;
        //frmVideoPlayer.caption := 'Video Player : ' + iDModObj.GetMagPat1.M_NameDisplay;
    FrmVideoPlayer.Update;
    Application.Processmessages;
    If Run Then
      FrmVideoPlayer.StartPlay;
    Screen.Cursor := crDefault;
    Exit;
  End;
  altviewer := GetIniEntry('Workstation settings', 'Alternate Video Viewer');
  winmsg('s','using Alternate Video Viewer : ' + altviewer);
  If (altviewer <> '')
    Then
      if not fileexists(altviewer)  then
           begin
             SetIniEntry('Workstation settings', 'Alternate Video Viewer','');
             winmsg('s','INVALID. Application does not exist :    ' + altviewer );
             winmsg('s',' -- removing INVALID Video Viewer from configuration  :   ' + GetConfigFileName);
             altviewer := '';
           end;
  if (altviewer <> '')
    then
      Magexecutefile(altviewer, Image, '', SW_SHOW)
    Else
      Magexecutefile(Image, '', '', SW_SHOW);


(*  If (altviewer <> '') Then
    Magexecutefile(altviewer, LbImport.caption + '\' + FGfiletoImport, '', SW_SHOW)
  Else
    Magexecutefile(LbImport.caption + '\' + FGfiletoImport, '', '', SW_SHOW);
*)

    {procedure InitFile(videofile,desc : string);
        procedure StartPlay;
      end;
    var
      VideoF: TVideoF;}
End;

Procedure TfrmCapMain.DisplayConfigValues(Xobj: TWinControl; oleft, otop: Integer; Desc: String);
Var
  Xobject: TWinControl;
  xleft, xtop: Integer;
Begin
  xobject := Xobj.Parent;
  xleft := Xobj.Left;
  xtop := Xobj.Top;
  MagFloatConfig.Init(Xobj, xobject, xleft, xtop);
  Xobj.Parent := MagFloatConfig;
  Xobj.Top := 20;
  Xobj.Left := 20;
  MagFloatConfig.ClientWidth := Xobj.Width + 40;
  MagFloatConfig.ClientHeight := Xobj.Height + 40 + MagFloatConfig.Panel1.Height;
  MagFloatConfig.Left := oleft + Left - 57;
  MagFloatConfig.Top := otop + Top + Height - ClientHeight;
  MagFloatConfig.caption := Desc;
  MagFloatConfig.POK.Left := ((MagFloatConfig.ClientWidth - MagFloatConfig.POK.Width) Div 2);
  MagFloatConfig.Show;

End;

Procedure TfrmCapMain.mRemoteLoginClick(Sender: Tobject);
Begin
  If XBROKERX.Connected Then
    ImagingCaptureLogoff;
  If XBROKERX.Connected Then
    Exit;
    //ListenerPort :  integer;
    //  LocalServer : string;
  ImagingCaptureLogin(LocalServer, Inttostr(ListenerPort), False);      {mRemoteLoginClick}
End;

Procedure TfrmCapMain.mVideoOptionsClick(Sender: Tobject);
Begin
  OpenVideoOptions;
End;

Procedure TfrmCapMain.OpenVideoOptions;
Begin
{/129 new parameters for Atlernate Viewer options;
        FAltViewerPDF, FAltViewerDCM,  FAltViewerTXT  }
  FrmVideoOptions.GetOptions(Fusealtviewer, Fplayvideofile, FAltViewerPDF, FAltViewerDCM,  FAltViewerTXT);

    //  MagVideoOptionsf.showmodal;
End;
{ DONE -o129 : Need a similiare Key Down for ...mg1...  maybe not... Popup Menu could be all we need.
               this may be a little overkill for 508.
               Popup menu is fixed for Tmag4VGear 'mg1' elsewhere.   Control keys codes for 'hidden' menu items
               already enable the 'Ctrl-<key>'  combinatinos...  think it was in 93..94}

(*  Gear1  2000 going... 2002 going...2004 going.... 2006 going...2008 going....2010 going....2012 GONE*)
(*
Procedure TfrmCapMain.Gear1KeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
Begin
  If (Key = VK_LEFT) Then
  Begin
    Horiz := Gear1.GetScrollPos(0);
   . . .
   . . .
   . . .
End;
2012 - Patch 129 Gear1 GONE*)

Procedure TfrmCapMain.PasteImagefromClipboard1Click(Sender: Tobject);
Begin
  GearCapPasteFromClip;
End;

Procedure TfrmCapMain.GearCapPasteFromClip;
Begin
  {/P122 DMMN 6/24/2011 - Enable annotation for clipboard image /}
// out 122 tlbrbtnAnnotation.Enabled := True;   {/p122 dmmn WPR Capture Item #19 /}

  FrmCapConfig.Clipboard.Checked := True;
    //INITClipboard;
  btnCaptureClick(Self);
End;

Procedure TfrmCapMain.CopyImagetoClipboard1Click(Sender: Tobject);
Begin
  GearCopy;
End;

Procedure TfrmCapMain.Configurationlist1Click(Sender: Tobject);
Begin
  OpenConfigList;
End;

Procedure TfrmCapmain.OpenConfigList;
Begin
  If FConfigButtonsMoved Then
  Begin
    SaveButtonConfigsToINI;
    FrmConfigList.GetSavedConfigs;
        //frmConfigList.LoadListView(frmConfiglist.fConfiglist);
  End;
  FrmConfigList.Show;
End;

{p59 also called when order of buttons changes.}

Procedure TfrmCapMain.SaveButtonConfigsToINI;
Var
  i: Integer;
  Tini: TIniFile;
    //  li : Tlistitem;
    //  configlistb : Tstrings;
Begin
    {       Save all defined configs to INI}
  If Not FConfigButtonsMoved Then
    Exit;
  FConfigButtonsMoved := False;
  Tini := TIniFile.Create(GetConfigFileName);
  Try
    Tini.Erasesection('SYS_CONFIGURATIONS');
    For i := 0 To TabCtr.Tabs.Count - 1 Do
    Begin
      Tini.Writestring('SYS_CONFIGURATIONS', Inttostr(i + 1), FrmConfigList.Fconfiglist[FrmConfigList.CfgIndexFromDesc(TabCtr.Tabs[i])]);
    End;
  Finally
    Tini.Free;
  End;
End;

Procedure TfrmCapMain.EnableMultiPageScan;
Var
  wasChecked: Boolean;
  Okay : Boolean;
Begin
    {Patch 59  put in the conditional IF...
      before this cbAll.. was always enabled, visible}
  wasChecked := CapX.mMultipage ;
  //140 If Not FrmCapConfig.TrueColorJPG.Checked Then
  case CapX.mIGSaveFormat of
   IG_SAVE_PDF_JPG, IG_SAVE_PDF_RLE, IG_SAVE_PDF_G4, IG_SAVE_TIF_G4, IG_SAVE_TIF_PACKED, IG_SAVE_TIF_UNCOMP :  Okay := true;
   else Okay := false;
  end;
  if CapX.m140PDFConvert and ((CapX.mSourceID = mcSrcTwain) or (CapX.mSourceID = mcSrcScanDoc))
    then Okay := true;

  

  if Okay then
  Begin
    cbALLPages.Visible := True;
    FrmCapConfig.cbTwainALLPages.Visible := True;

    ALLPagesChecked(False);

    cbALLPages.Enabled := True;
    FrmCapConfig.cbTwainALLPages.Enabled := True;
    If wasChecked Then
      Begin
      AllPagesChecked(true);
      //a/ FrmCapConfig.cb TwainALLPages.Checked := True;
      End;

  End
  Else
    begin
      frmCapConfig.DisableMultiPage;
    end;

End;

procedure TfrmCapMain.AllPagesChecked(val : boolean);
begin
cbALLPages.Checked := val;  { Procedure:  AllPagesChecked}
frmCapConfig.cbTwainALLPages.Checked := val;   { Procedure:  AllPagesChecked}
CapX.mMultipage := val;




//    If Frmcapmain.cb ALLPages.Checked <> cb TwainALLPages.Checked Then Frmcapmain.cb ALLPages.Checked := cb TwainALLPages.Checked;
//  CapX.mMultipage := cb TwainAllPages.Checked;
end;


procedure TfrmCapMain.AllPagesCheckedTrue1Click(Sender: TObject);
begin
AllPagesChecked(true);
//a/FRMCAPMAIN.cbBatch.Checked := TRUE;
//a/frmCapMain.cbALLPages.Checked := true;
end;

procedure TfrmCapMain.CopyMultiPagePDF(Xmagien : string);
Var
  PARAM, multipgmod: String;
  i: Integer;
Begin
  MagTwain1.SourceClose;            //140 close Source 
    { }
  FGfiletoImport := 'magPDF.pdf';
  incprogress;

  (*   KEEP THIS COMMENT.
   p129t18    This is the confusion of Image Display Controls and IMage Capture controls...
               Now that Capture has to do things to Support Image Display functions... this functionality
                will NOT work.  The Gear Control Now is a not a Document(multiple IG Pages) it's an Image, only
                  one page at a time,  so this function from capture deletes the Image before saving changes.
                  Changes were in the IGDocument, and saved from there, but now..  no.
  If IsImageChanged Then
    Begin
    MagAspectRatio(1);
    If ImageChangedOther Then
      Begin
      { Not clear if needed in mg1
      Gear 1.SettingMode := MODE_CONTRAST;
      Gear 1.SettingValue := IG_CONTRAST_PIXEL;
      Gear 1.Contrast := Gear 1.DisplayContrast;
      Gear 1.Brightness := Gear 1.DisplayBrightness;
      }
      End;
    multipgmod := GUserDir.Temp + ExtractFileName(FGfiletoImport);
    DeleteFile(PChar(multipgmod));
    For i := 1 To mg1.PageCount Do
      Begin
      mg1.Page := i;
      getIGManager.IGFormatsCtrl.savePageToFile(mg1.GetCurrentPage,multipgmod,0,IG_PAGESAVEMODE_APPEND,IG_SAVE_UNKNOWN);
      End;
    End;
    *)

  If FileExists(GUserDir.Temp + ExtractFileName(FGfiletoImport)) Then
    Begin
    incprogress;
    {the Rename and Copy isn't working now,  so we were copy to New Name, then Copy to Network.}
    { now we'll try just copy to network.}
     {  this was copy to new name, then  copy to newtwork.
    CopyFile(GUserDir.Temp + ExtractFileName(FGfiletoImport),GUserDir.Temp + MagFileObj.GetFileName);}

    //CopyFile(GUserDir.Temp + ExtractFileName(FGfiletoImport),MagFileObj.GetPath + MagFileObj.GetFileName);
    CopyFile(GUserDir.Temp + ExtractFileName(FGfiletoImport), MagFileObj.FullFileName);
  //  RenameFile Not Working....Accusoft Still has file opened...
      { TODO -ogek -c140+ : Find method to close file from accusoft }
  //  RenameFile(GUserDir.Temp + ExtractFileName(FGfiletoImport), GUserDir.Temp + MagFileObj.GetFileName); {In CopyMultiPageFile}
  //  CopyTheFile(GUserDir.Temp + MagFileObj.GetFileName, MagFileObj.GetPath); {In CopyMultiPageFile}
    If FileExists(MagFileObj.FullFileName) {In CopyMultiPageFile}
      Then
      WinMsg('', 'MultiPage PDF File copied to Image Server OK.')
      Else
      Begin
      WinMsg('e', 'ERROR MultiPage PDF File not Copied Correctly. Notify IRM');
      ImageEntryDelete(MagFileOBj.ID,'NoImage'); {In CopyMultiPageFile}
      ENDPROGRESS;
      Exit;
      End;
    MagTwain1.SourceClose;
   (*  THis is out, because we copy temp file straight to Network now }
    cmd := 'DEL'; {include path and extension}
    PARAM := GUserDir.Temp + MagFileObj.GetFileName; {In CopyMultiPageFile}
    If Not DeleteFile(PChar(PARAM)) Then
    Begin
      W inMsg('d', 'Local file: ' + PARAM + '  not deleted.  Notify IRM');
    End;
    *)
    cmd := 'DEL'; {include path and extension}
    PARAM := GUserDir.Temp + ExtractFileName(FGfiletoImport); {In CopyMultiPageFile}
    If Not DeleteFile(PChar(PARAM)) Then
    Begin
            if not (Uppercase(FGfiletoImport) = 'MAGPDF.PDF') then
      WinMsg('d', 'Local file: ' + PARAM + '  not deleted.  Notify IRM');
    End;
  End;
  incprogress;
  if not fileexists(GUserDir.Temp + 'magpdf.pdf') then   ShowReviewButton(false);

    {END;}
End; { CopyMultiPagePDF}

Procedure TfrmCapMain.copymultipagefile(Xmagien: String);
Var
  PARAM, multipgmod: String;
  i: Integer;
Begin
    { we're here because  local user +\temp\multipage.tif exists.}
  FGfiletoImport := 'multipage.tif';
  incprogress;
    (*   KEEP THIS COMMENT.
     p129t18    This is the confusion of Image Display Controls and IMage Capture controls...
               Now that Capture has to do things to Support Image Display functions... this functionality
                will NOT work.  The Gear Control Now is a not a Document(multiple IG Pages) it's an Image, only
                  one page at a time,  so this function from capture deletes the Image before saving changes.
                  Changes were in the IGDocument, and saved from there, but now..  no.
  If IsImageChanged Then
    Begin
    MagAspectRatio(1);
    If ImageChangedOther Then
      Begin
      { Not clear if needed in mg1
      Gear 1.SettingMode := MODE_CONTRAST;
      Gear 1.SettingValue := IG_CONTRAST_PIXEL;
      Gear 1.Contrast := Gear 1.DisplayContrast;
      Gear 1.Brightness := Gear 1.DisplayBrightness;
      }
      End;
    multipgmod := GUserDir.Temp + ExtractFileName(FGfiletoImport);
    DeleteFile(PChar(multipgmod));
    For i := 1 To mg1.PageCount Do
      Begin
      mg1.Page := i;
      getIGManager.IGFormatsCtrl.savePageToFile(mg1.GetCurrentPage,multipgmod,0,IG_PAGESAVEMODE_APPEND,IG_SAVE_UNKNOWN);
      End;
    End;
    *)

  If FileExists(GUserDir.Temp + ExtractFileName(FGfiletoImport)) Then
    Begin
        incprogress;
        (* Not renaming now, just copy.   140 t21 +
        RenameFile(GUserDir.Temp + ExtractFileName(FGfiletoImport), GUserDir.Temp + MagFileObj.GetFileName); {In CopyMultiPageFile}
        CopyTheFile(GUserDir.Temp + MagFileObj.GetFileName, MagFileObj.GetPath); {In CopyMultiPageFile}
        *)
        CopyFile(GUserDir.Temp + ExtractFileName(FGfiletoImport),MagFileObj.FullFileName);
        If FileExists(MagFileObj.FullFileName) {In CopyMultiPageFile}
          Then
          WinMsg('', 'MultiPage File copied to Image Server OK.')
          Else
          Begin
          WinMsg('e', 'ERROR MultiPage File not Copied Correctly. Notify IRM');
          ImageEntryDelete(MagFileOBj.ID,'NoImage'); {In CopyMultiPageFile}
          ENDPROGRESS;
          Exit;
          End;

        cmd := 'DEL'; {include path and extension}
        //PARAM := GUserDir.Temp + MagFileObj.GetFileName; {In CopyMultiPageFile}
        PARAM := GUserDir.Temp + ExtractFileName(FGfiletoImport);
        If Not DeleteFile(PChar(PARAM)) Then
            Begin
              if not(Uppercase(FGfiletoImport) = 'MAGPDF.PDF') then
                WinMsg('d', 'Local file: ' + PARAM + '  not deleted.  Notify IRM');
            End;
    End;
  incprogress;
    {END;}
End; { copymultipagefile}

(*
Procedure TfrmCapMain.Gear1ScanAfterPage(Sender: Tobject; PageNumber, PendCount: Integer; Const Filename: WideString);
Begin
  If KeepAliveRPCCall1.Checked Then
  Begin
    XBROKERX.REMOTEPROCEDURE := 'XWB IM HERE'; // this is restricted call.
    MagAppMsg('s', 'IM HERE Result: ' + XBROKERX.STRCALL);
  End;
    // RPMaggUserKeys(SecurityKeys);
    // maggmsgf.magmsgs('s',SecurityKeys);
    //  maggmsgf.magmsgs('s',SecurityKeys);
  WinMsg('s', 'Gear1ScanAfterPage ');
  WinMsg('s', ' - ');
  AfterMultiPageScan;
End;
*)
Procedure TfrmCapMain.CprsSyncDefaults;
Begin

    // defaults for CPRSSync options
  CprsSync.Queried := True;
  CprsSync.SyncOn := False;
  CprsSync.PatSync := True;
  CprsSync.PatSyncPrompt := False;
    // we default to ProcSync := false for capture, user can't chnage it.
    //   user has to select from Notes Listing.
  CprsSync.ProcSync := False;
  CprsSync.ProcSyncPrompt := False;

  
  Frmcapmain.EnablePatientLookupLogin(Not CprsSync.SyncOn);
End;

Procedure TfrmCapMain.pnlImportResize(Sender: Tobject);
Begin
  If Height < 75 Then
    Height := 75;
  SetImportMaxHeight;
  SetImportBatchMaxHeight;
End;

Procedure TfrmCapMain.ShowCPRSLinkMenuoption1Click(Sender: Tobject);
Begin
  mCPRSLinkOptions.Enabled := True;
  mCPRSLinkOptions.Visible := True;
End;

Procedure TfrmCapMain.SaveWindowSettings;
Var
  Tf, s: String;
Begin
{/129 alternate viewer setting to INI file.}

      SetIniEntry('Workstation Settings', 'CaptureAlternatePDFviewer', magbooltostr(FAltViewerPDF));
      SetIniEntry('Workstation Settings', 'CaptureAlternateDCMviewer',magbooltostr(FAltViewerDCM));
      SetIniEntry('Workstation Settings', 'CaptureAlternateTXTviewer',  magbooltostr(FAltViewerTXT));

  SetIniEntry('Workstation settings', 'Import List height', Inttostr(pnlimport.Height));

  SetIniEntry('Workstation settings', 'LongDesc height', Inttostr(plongdesc.Height));
  SetIniEntry('Workstation settings', 'Configuration List width', Inttostr(FrmConfigList.LvwCfgList.Width));
  SetIniEntry('Workstation settings', 'Default Visit Location', MSetWrks1.VLoc);
  If TabCtr.Visible Then
    Tf := 'TRUE'
  Else
    Tf := 'FALSE';
  SetIniEntry('Workstation settings', 'Config Toolbar', Tf);

  If TabCtr.Multiline Then
    Tf := 'TRUE'
  Else
    Tf := 'FALSE';
  SetIniEntry('Workstation settings', 'Config Toolbar MultiLine', Tf);

  If tlbrSettings.Visible Then
    Tf := 'TRUE'
  Else
    Tf := 'FALSE';
  SetIniEntry('Workstation settings', 'Settings Toolbar', Tf);

    // if BiggerSliderControls1.checked then TF := 'TRUE'
   //  else TF := 'FALSE';
   //s  SetIniEntry('Workstation settings', 'Large Slider Controls', TF);

  If FCloseQuickSetting Then
    Tf := 'TRUE'
  Else
    Tf := 'FALSE';
  SetIniEntry('Workstation settings', 'Close Quick Setting', Tf);

  If FImageTB Then
    Tf := 'TRUE'
  Else
    Tf := 'FALSE';
  SetIniEntry('Workstation settings', 'Image Toolbar', Tf);

  If Frmcapmain.ShowHint Then
    Tf := 'TRUE'
  Else
    Tf := 'FALSE';
  SetIniEntry('Workstation settings', 'Capture Hints', Tf);

  If Fconfirmmsg Then
    Tf := 'TRUE'
  Else
    Tf := 'FALSE';
  SetIniEntry('Workstation settings', 'Capture Confirmation', Tf);

  If Frmcapmain.WindowState = WsMaximized Then
    Tf := 'TRUE'
  Else
    Tf := 'FALSE';
  SetIniEntry('Workstation settings', 'Capture Maximized', Tf);

  SetIniEntry('Workstation settings', 'Data Entry Width', Inttostr(Panel1.Width));

  If tlbarImage.Align = altop Then
    s := 'TOP';
  If tlbarImage.Align = alright Then
    s := 'RIGHT';
  If tlbarImage.Align = alLeft Then
    s := 'LEFT';

  SetIniEntry('Workstation settings', 'ToolBarPosition', s);

  SetIniEntry('Workstation settings', 'Default Visit Location', MSetWrks1.VLoc);

  s := GetIniEntry('Workstation settings', 'LongDesc height');
  If (s <> '') Then
    plongdesc.Height := Strtoint(s);

  SaveImportDirsToIni;
End;

Procedure TfrmCapMain.ApplySavedWindowSettings;
Var
  s: String;
Begin
  s := GetIniEntry('Workstation settings', 'Import List height');
  If s = '' Then
    s := '200';
  pnlimport.Height := Strtoint(s);

  s := GetIniEntry('Workstation settings', 'LongDesc height');
  If (s <> '') Then
    plongdesc.Height := Strtoint(s);
  colapseLongDesc;

  s := GetIniEntry('Workstation settings', 'Data Entry Width');
  If (s <> '') Then
    Panel1.Width := Strtoint(s);

  s := GetIniEntry('Workstation settings', 'Configuration List width');
  If (s <> '') Then
    FrmConfigList.LvwCfgList.Width := Strtoint(s);

    //('Workstation settings', 'Configuration List width',inttostr(frmConfigList.lvwCfgList.width));

  s := GetIniEntry('Workstation settings', 'ToolBarPosition');
  If (s <> '') Then
  Begin
        // The default is alTop, so we don't have to test for that.
        //p8  if s = 'RIGHT' then tlbarImage.align := alright;
        //p8   if s = 'LEFT' then tlbarImage.align := alleft;
  End;

  s := GetIniEntry('Workstation settings', 'Config Toolbar');
  FSavedConfigsTB := Not (Uppercase(s) = 'FALSE');
  TabCtr.Visible := FSavedConfigsTB;
  mnuConfigToolBar.Checked := FSavedConfigsTB;

  s := GetIniEntry('Workstation settings', 'Image Toolbar');
  FImageTB := Not (Uppercase(s) = 'FALSE');
  MnuImageToolbar.Checked := FImageTB;
  tlbarImage.Visible := FImageTB;

    (*    if FImageToolbar then TF := 'TRUE'
      else TF := 'FALSE';
      SetIniEntry('Workstation settings', 'Image Toolbar', TF);*)

  s := GetIniEntry('Workstation settings', 'Config Toolbar MultiLine');
  FSavedConfigsMultiLine := Not (Uppercase(s) = 'FALSE');
  TabCtr.Multiline := FSavedConfigsMultiLine;

  s := GetIniEntry('Workstation settings', 'Settings Toolbar');
  FCurrentSettingsTB := Not (Uppercase(s) = 'FALSE');
  mnuCurrentSettingsTB.Checked := FCurrentSettingsTB;
  tlbrSettings.Visible := FCurrentSettingsTB;

  s := GetIniEntry('Workstation settings', 'Capture Hints');
  FShowHints := Not (Uppercase(s) = 'FALSE');
  Frmcapmain.ShowHint := FShowHints;
  FShowHints := FShowHints;

  s := GetIniEntry('Workstation settings', 'Capture Confirmation');
  mconfirmmsg.Checked := Not (Uppercase(s) = 'FALSE');
  Fconfirmmsg := mconfirmmsg.Checked;
    //
  //p129  unused code out
  (*s := Uppercase(GetIniEntry('Workstation settings', 'Large Slider Controls'));
  SizeSliders(Not (Uppercase(s) = 'FALSE'));*)

  s := Uppercase(GetIniEntry('Workstation settings', 'Close Quick Setting'));
  FCloseQuickSetting := Not (Uppercase(s) = 'FALSE');
  MagFloatConfig.cbQuickClose.Checked := FCloseQuickSetting;

  s := Uppercase(GetIniEntry('Workstation settings', 'Capture Maximized'));
  If (s = 'TRUE') Then
    Frmcapmain.WindowState := WsMaximized;

End;

Procedure TfrmCapMain.Configurations1Click(Sender: Tobject);
Var
  i: Integer;
Begin
  MagMenuConfig.ClearAll;

  If FrmConfigList.Fconfiglist.Count = 0 Then
    Exit;
  For i := 0 To FrmConfigList.Fconfiglist.Count - 1 Do
  Begin
        // MagMenuConfig.additem(magpiece(frmConfigList.configlist[i], '^', 1), i, '');
         // code here is in Patch 5 for DFNINTFIX
    MagMenuConfig.AddItem(MagPiece(FrmConfigList.Fconfiglist[i], '^', 1), MagPiece(FrmConfigList.Fconfiglist[i], '^', 1), '');
        (*    tbut := tbutton.create(bp);
            tbut.top := 1;
            tbut.left := cl; inc(cl,bw);
            tbut.parent := bp;
            tbut.caption := magpiece(configlist[i],'^',1);
            tbut.tag := i;
            tbut.height := bh;
            tbut.width := bw;
            tbut.onclick := frmCapMain.ConfigButtonClick;
            tbut.show;
            tbut.tabstop := false;  *)
  End;

End;

Procedure TfrmCapMain.mnuRealignIndexFieldsClick(Sender: Tobject);
Begin
  ShowTagFields;
End;

Procedure TfrmCapMain.N800x6001Click(Sender: Tobject);
Begin
  Frmcapmain.Height := 600;
  Frmcapmain.Width := 800;
End;

Procedure TfrmCapMain.cbwordwrapClick(Sender: Tobject);
Begin
  Imagelongdesc.Wordwrap := cbwordwrap.Checked;
  If Not Imagelongdesc.Wordwrap Then
    Imagelongdesc.ScrollBars := SsBoth
  Else
    Imagelongdesc.ScrollBars := SsVertical;
End;

Procedure TfrmCapMain.ErrorCodelookup1Click(Sender: Tobject);
Begin
  Magexecutefile('ERRLOOK.EXE', '', '', SW_SHOW);
End;

Procedure TfrmCapMain.tlbrbtnRotate90Click(Sender: Tobject);
Begin
  GearRotate(90);
End;

Procedure TfrmCapMain.tlbrbtnInvertClick(Sender: Tobject);
Begin
  GearInvert;
End;

Procedure TfrmCapMain.GearInvert;
Var
  invStr : string;
  invPg : integer;
  invFilename: string;
Begin
  Try
    If isgearClear(mg1)      then   Exit;
    if not mg1.isvalidimage  then exit;
    mg1.update;
    Application.Processmessages;

    AccusoftPropertiesLog('Before Invert: GearInvert');

  FImageChanged := True;
  mg1.Inverse;
  mg1.UpdatePageView;
  FModINV := Not (FModINV);


{129t10   NOTE:: we didn't use this cMag4VGear control in previous capture Apps.
      For Multipage images we used a Gear99 version of LoadDocument.
      Now we're using LoadPage, due to using cMag4VGear,
      this workaround is not efficient.  but will work for now..}

    invStr := 'Invert Page: ' + inttostr(mg1.Page) + '  PageCount: '   + inttostr(mg1.PageCount);
    magappmsg('s',invStr);
        if (mg1.PageCount > 1) then
           begin
            invPg := mg1.Page - 1 ;
            invFilename := mg1.ImageFilename;
           // getIGManager.IGFormatsCtrl.savePageToFile(mg1.GetCurrentPage,rotatefilename,rotatepg,IG_PAGESAVEMODE_REPLACE,IG_SAVE_UNKNOWN);
             getIGManager.IGFormatsCtrl.savePageToFile(mg1.GetCurrentPage,invFilename,invPg,IG_PAGESAVEMODE_REPLACE,CapX.mIGSaveFormat);
           end;

 (*  example code :
       getIGManager.IGFormatsCtrl.savePageToFile(mg1.GetCurrentPage,tfilename,0,IG_PAGESAVEMODE_APPEND,IG_SAVE_UNKNOWN);
  // Constants for enum enumIGPageSaveModes
type
  enumIGPageSaveModes = TOleEnum;
const
  IG_PAGESAVEMODE_DEFAULT = $00000000;
  IG_PAGESAVEMODE_OVERWRITE = $00000001;
  IG_PAGESAVEMODE_APPEND = $00000002;
  IG_PAGESAVEMODE_INSERT = $00000003;
  IG_PAGESAVEMODE_REPLACE = $00000004;
  *)

  Finally
    If ErrorInGear(mg1, 'Rotate', 'ImageGear: Rotating Image') Then        {in GearRotate}
      WinMsg('', 'Accusoft error during Rotate.');
  End;
End;

  (* this is copy of 129t17 code for GearInvert
Procedure TfrmCapMain.GearInvert;
Begin
  If isgearClear(mg1) Then
    Exit;

  if not mg1.isvalidimage  then exit;


  FImageChanged := True;
  mg1.Inverse;
  mg1.UpdatePageView;
  FModINV := Not (FModINV);

{ DONE -o129 : This will come out.;}
 // FTRCImageManips := True; //p122t11  //p122t12 - no longer needed
End;
*)

Procedure TfrmCapMain.tlbrbtnRotatem90Click(Sender: Tobject);
Begin
  GearRotate(270);
End;


Procedure TfrmCapMain.Dimensions1Click(Sender: Tobject);
Var
  s: String;
Begin
  s := 'Width : ' + Inttostr(Width) + ' Height : ' + Inttostr(Height);
  Pmsg.caption := s;
End;

Procedure TfrmCapMain.N1024x7681Click(Sender: Tobject);
Begin
  Frmcapmain.Width := 1024;
  Frmcapmain.Height := 768;

End;

Procedure TfrmCapMain.N1152x8641Click(Sender: Tobject);
Begin
  Frmcapmain.Width := 1152;
  Frmcapmain.Height := 864;

End;

Procedure TfrmCapMain.N1280x10241Click(Sender: Tobject);
Begin
  Frmcapmain.Width := 1280;
  Frmcapmain.Height := 1024;

End;

Procedure TfrmCapMain.N1600x12001Click(Sender: Tobject);
Begin
  Frmcapmain.Width := 1600;
  Frmcapmain.Height := 1200;

End;

Procedure TfrmCapMain.tlbrbtnFitToWinClick(Sender: Tobject);
Begin
  GearFitToWin;
End;

Procedure TfrmCapMain.GearFitToWin;
Begin
  mg1.FitToWindow;
  mg1.UpdatePageView;
  { p129 Use zoom value  of the control}
  SetZoomLevel(mg1.GetZoomValue, false);


  (* p129
  Gear 1.AspectRatio := IG_ASPECT_DEFAULT;
  Gear 1.SelectEvent := 0;
  Gear 1.FitMethod := IG_DISPLAY_FIT_TO_WINDOW;
    //Gear 1.AspectRatio := IG_ASPECT_NONE;
  SetZoomLevel(100);
*)



End;

Procedure TfrmCapMain.SetZoomLevel(Value: Integer; DoClickEvent : boolean = true);
var ZoomChangeNotify : TNotifyEvent;
Begin

ZoomChangeNotify := TBicZoom.onchange;
if not DoClickEvent then
  begin
    TBicZoom.OnChange := nil;
    If TbicZoom.Position <> Value
           Then  TbicZoom.Position := Value;
    liczoom.caption :=  inttostr(value);
    TBicZoom.Onchange := ZoomChangeNotify;
  end
  else
  begin
  If TbicZoom.Position <> Value Then
     Begin
        //Gear 1.Zoomlevel := value;
     TbicZoom.Position := Value;
     liczoom.caption :=  inttostr(value);
     End;
  end;
End;

Procedure TfrmCapMain.tlbrbtnHandPanClick(Sender: Tobject);
Begin
  GearMousePan;
End;

Procedure TfrmCapMain.tlbrbtnPanWindowClick(Sender: Tobject);
Begin
  GearPanWindow;
End;

Procedure TfrmCapMain.GearPanWindow;
Var
  x, y: Integer;
Begin
{p129t10 gek move this test above ResetControls.  Helps with new PanWindowIssue Flag FPanWindowReset}
if mg1.panwindow then
   begin
     mg1.PanWindow := false;
     exit;
   end;

 ResetControls; 

{TODO -oGarrett : do we still need the test here, after copying it to above 'ResetContols'}
  if mg1.PanWindow
     then
        mg1.PanWindow := false
     else
     begin
       y := Top;
       If (y < 0) Then
         y := 0;
      x := Left + Width + 20;
      If ((x + 100) > Screen.Width) Then
         x := Screen.Width - 100;

     application.processmessages;
     mg1.PanWindowSettings(100,100,X,Y);
     mg1.PanWindow := true;

     end;


{p129t10 gek  New Flag to assure we only do 'PanWindowReset'   one time.  }
if mg1.PanWindow and (not FPanWindowReset) then
  begin
    FPanWindowReset := true;
    PanWindowReset;
  end;
(* p129 out.
  If Gear 1.PanWindow Then
    Gear 1.PanWindow := False
  Else
  Begin
    y := Top;
    If (y < 0) Then
      y := 0;
    x := Left + Width + 20;
    If ((x + 100) > Screen.Width) Then
      x := Screen.Width - 100;
    Gear 1.GUIWINDOW := GUIPAN;
    Gear 1.GUIHeight := 100;
    Gear 1.GUIWIDTH := 100;
    Gear 1.GUIXPOS := x;
    Gear 1.GUIYPOS := y;
    Gear 1.PanWindow := True;
  End;
  *)
End;

{patch 129t10  gek.   a workaround for the pan window bug.  
                      Pan Window Scrollbar throws 'invalid floating point' First Time.}
Procedure TfrmCapMain.PanWindowReset;
begin
RELoadGear;
GearPanWindow;
end;

{ SelectEvent [ description ]
This property sets the select event that occurs when the user depresses the left mouse button.
If set to zero, there is no selection rectangle.
If you set this property greater than 0, a rubber rectangle is drawn
in the control when the user depresses the left mouse button and drags the mouse.
When set to 1, the rectangle values are sent to the container application.
Setting to 2 is similar to setting to 1, except that ImageGear auto-zooms the rectangle as well.
When the AspectRatio property is non-zero,
the selection rectangle automatically maintain an accurate aspect ratio for the image.}

Procedure TfrmCapMain.tlbrbtnZoomSelectClick(Sender: Tobject);
Begin
  GearMouseZoomSelect;
End;

Procedure TfrmCapMain.TbicBrightnessChange(Sender: Tobject);
Begin
  LicBrightness.caption := Inttostr(Trunc(TbicBrightness.Position / 10) + 90);
  LicBrightness.Update;
 // Gear 1.DisplayBrightness := Trunc(TbicBrightness.Position / 10);
mg1.BrightnessValue(TbicBrightness.Position);
//mg1.BrightnessContrastValue(Trunc(TbicBrightness.Position / 10), trunc(TbicContrast.Position / 100));
mg1.UpdatePageView;
End;

Procedure TfrmCapMain.TbicContrastChange(Sender: Tobject);
Begin
  LicContrast.caption := Inttostr(TbicContrast.Position);
  LicContrast.Update;
 //p129  Gear 1.DisplayContrast := TbicContrast.Position / 100;

  mg1.ContrastValue(TbicContrast.Position);
//mg1.BrightnessContrastValue(Trunc(TbicBrightness.Position / 10), Trunc(TbicContrast.Position / 100));
mg1.UpdatePageView;
End;

Procedure TfrmCapMain.TbicZoomChange(Sender: Tobject);
Begin
  LicZoom.caption := Inttostr(TbicZoom.Position);
  LicZoom.Update;
//p129  If Gear 1.ZoomLevel <> TbicZoom.Position Then
//p129     Gear 1.ZoomLevel := TbicZoom.Position;
if mg1.GetZoomValue <> tbicZoom.position then
  begin
  mg1.ZoomValue(tbiczoom.position);
  mg1.UpdatePageView;
  end;
End;

Procedure TfrmCapMain.tbPlayVideoClick(Sender: Tobject);
Begin
  playthefile(True);
End;

Procedure TfrmCapMain.mMagSysClick(Sender: Tobject);
Var
  cmd: String;
Begin
  If MagWrksf.Execute(GetConfigFileName) Then
    ApplyWorkstationSettings;
  Exit;

  If IsProcessRunning(MagSysProcessInfo) Then
  Begin
    WinMsg('', 'Workstation Configuration Editor is running...');
    Exit;
  End;

  cmd := AppPath + '\magwrks.exe letsdoit';
    (* comment out the line, not using /n  SAF*)
    (* Param:='/i /n'; {i/ = interaction, /n = don't save file} *)

  WinExecNoWait32(cmd, 1, MagSysProcessInfo);

End;
procedure TfrmCapMain.mnu140ClearPDFfileClick(Sender: TObject);
begin
deletefile(GUserDir.Temp + 'magpdf.pdf');
end;

procedure TfrmCapMain.mnu140JPGClick(Sender: TObject);
begin
mnu140JPG.Checked   := not  mnu140JPG.Checked ;
mnu140RLE.Checked :=  not  mnu140JPG.Checked ;
CapX.m140RLE := mnu140RLE.Checked   ;
CapX.m140JPG := mnu140JPG.Checked;
end;

procedure TfrmCapMain.mnu140RLEClick(Sender: TObject);
begin
mnu140RLE.Checked   := not  mnu140RLE.Checked ;
mnu140JPG.Checked :=  not  mnu140RLE.Checked ;
CapX.m140RLE := mnu140RLE.Checked   ;
CapX.m140JPG := mnu140JPG.Checked;
end;

Procedure TfrmCapMain.ApplyWorkstationSettings;
Var
  s: String;
  Magini: TIniFile;
  newini : string;
Begin
 (*  win7 move this down below the calls to Create and Update
 //GetTabSettingsFromINI(TabSeqList); *)





 //p129t15 ? CheckMagIni; // out in 129t15 Now only create it from App if it doesn't exist
 //  the If Not Fileexists.... below replaces the   CheckMagIni Above.
newini := GetConfigFileName;

  If Not FileExists(newini) Then
  Begin
    WinMsg('', 'Creating Workstation configuration...');
    CreateIFNeeded;
    if not DidCapAppMarkINI(newini) then MarkOfCapture(newini);
  End;

{p129T18.. Capture will do it's check for newINI having MarkOf=Capture here..  no change to 
           the Magguini.pas functions that are called by all Applications.
            this will check for the MarkOfCapture,}
CreateIFNeededFromCapture();

   // New function UpdateIfNeeded.  03/12/02 Patch 7

  If IsUpdateNeeded(MagGetFileVersionInfo(Application.ExeName)) Then
  Begin
    WinMsg('', 'Updating Workstation configuration...');
    UpdateIfNeeded(MagGetFileVersionInfo(Application.ExeName));
  End;
 //win7 move from above to here.
 GetTabSettingsFromINI(TabSeqList);

  WinMsg('', 'Applying Workstation default settings...');
  FrmCapConfig.LoadLum100Choice;
  s := GetIniEntry('Workstation settings', 'ConfigFix59');
  If s = '' Then
    ConfigFix59;
  Magini := TIniFile.Create(GetConfigFileName);
    {Format:='.TGA';}{GEK 2/28/97}

  Try

    With Magini Do
    Begin
    {/p129 gek TestScript menu}
    {MAG.INI file needs Section and entry like below.
    [TESTSCRIPT]
     TESTSCRIPTMENU=TRUE
     }
      if Uppercase(ReadString('DEV-TESTSCRIPT', 'TESTSCRIPTMENU', 'FALSE')) = 'TRUE'
         then
           begin
           mnuTestScript.visible := true;
          // lbRunMode.Visible := mnuTestScript.Visible;
           end;

      mnuTestScriptDontUseCCOW.Checked := magini.ReadString('DEV-CONTEXT','DontUseCCOW','FALSE')='TRUE';
       GDontUseCCOW := mnuTestScriptDontUseCCOW.Checked;
      { [ERROR HANDLING] }
      FErrorInGearFlagShowDups := UPPERCASE(magini.ReadString('DEV-ERROR HANDLING','FlagShowDups','FALSE'))='TRUE';
      FErrorInGearFlagShowAll := UPPERCASE(magini.ReadString('DEV-ERROR HANDLING','FlagShowAll','FALSE'))='TRUE';
      {/p129 alternate viewer settings.}
      {FCapSaveBIG := Uppercase(ReadString('Workstation Settings', 'Save Radiology BIG File', 'FALSE')) = 'TRUE';}
      FAltViewerPDF := Uppercase(ReadString('Workstation Settings', 'CaptureAlternatePDFviewer', 'FALSE')) = 'TRUE';
      FAltViewerDCM := Uppercase(ReadString('Workstation Settings', 'CaptureAlternateDCMviewer', 'FALSE')) = 'TRUE';
      FAltViewerTXT := Uppercase(ReadString('Workstation Settings', 'CaptureAlternateTXTviewer', 'FALSE')) = 'TRUE';

      MSetWrks1.VLoc := ReadString('Workstation settings', 'Default Visit Location', '');
      FCapDevTest := Uppercase(ReadString('Dev-Testing', 'ShowTestingMenu', 'FALSE')) = 'TRUE';
      mnuTest1.Visible := FCapDevTest;
      mnuTest2.Visible := FCapDevTest;
      AllowRemoteLogin := (Uppercase(ReadString('Login Options', 'AllowRemoteLogin', 'FALSE')) = 'TRUE');
      ListenerPort := ReadInteger('Login Options', 'Local VistA port', 9200);
      LocalServer := ReadString('Login Options', 'Local VistA', 'DHCPSERVER');

      IniColorscan256 := Uppercase(ReadString('Input Source Options', '256 Color Enabled', 'FALSE')) = 'TRUE';
      {/p117 T3 gek - make default = 'COPY';}
      ImportINI := 'COPY';  //ImportIni := 'TGA';
      IniUseImageDesc := ReadString('Button/Field Options', 'CreateDefaultImageDesc', 'TRUE') = 'TRUE';

      s := ReadString('Button/Field Options', 'ImageDesc', 'Selected (Windows default)');
      If Pos('NoSelect', s) > 0 Then
        EdtImageDesc.AutoSelect := False;
      If s = 'NoSelectCursorEnd' Then
        IniImageDescCurEnd := True;
      If Not (ReadString('Input Source', 'Lumisys100 FilmSize', 'NONE') = 'NONE') Then
        FrmCapConfig.Lum100choice.ItemIndex :=
          FrmCapConfig.Lum100choice.Items.Indexof(ReadString('Input Source', 'Lumisys100 FilmSize', 'NONE'));
            // 8/30/00 We don't want this to show unless Lumis100 is the default , this will happen below
            //frmCapConfig.Lum100choiceChange(self);

      Wsid := Uppercase(ReadString('Workstation Settings', 'ID', 'UNKnown'));
      Wsid := Wsid + '_' + ReadString('Workstation Settings', 'Location', 'UNKnown');
      WrksLocation := ReadString('Workstation Settings', 'Location', 'UNKnown');
            // WrksCompName := Uppercase(ReadString('SYS_AUTOUPDATE', 'ComputerName', 'NoComputerName'));
      WrksCompName := GetMagComputerName; //59
      WinMsg('s', 'Computer Name : ' + WrksCompName); //59
      Writestring('SYS_AUTOUPDATE', 'ComputerName', WrksCompName); //59
      LastMagUpdate := Uppercase(ReadString('SYS_AUTOUPDATE', 'LASTUPDATE', '0'));
      {  Patch 93 disabled 'Convert to TGA', and Convert to File Format
         /p117 comment out unused code.  Delete it later.}
      ImportINI := 'COPY';

      If ReadString('Medicine Options', 'Create New/List Existing', 'Create New') = 'Create New' Then
        MAGGMCF.Rbnewproc.Checked := True
      Else
        MAGGMCF.Rblistproc.Checked := True;
      MAGGMCF.cbMakeProcStub.Checked :=
        Uppercase(ReadString('Medicine Options', 'Create Procedure stub first', 'FALSE')) = 'TRUE';

      s := ReadString('Workstation Settings', 'WorkStation TimeOut minutes', '');
      SetWorkstationTimeout(s);

      With FrmCapConfig Do
      Begin
        OnLine.Checked := True;
        ImageGroup.Checked := True;
        SingleImage.Checked := Uppercase(ReadString('SaveOptions', 'default', 'GROUP')) = 'SINGLE';
        Color.Enabled := Uppercase(ReadString('Image Format', 'True Color TGA', 'IniError')) = 'TRUE';
        TrueColorJPG.Enabled := Uppercase(ReadString('Image Format', 'True Color JPG', 'IniError')) = 'TRUE';
        ColorScan.Enabled := Uppercase(ReadString('Image Format', '256 Color', 'IniError')) = 'TRUE';
        Xray.Enabled := Uppercase(ReadString('Image Format', 'Xray', 'IniError')) = 'TRUE';
        XrayJPG.Enabled := Uppercase(ReadString('Image Format', 'Xray JPG', 'IniError')) = 'TRUE';

        BlackAndWhite.Enabled := Uppercase(ReadString('Image Format', 'Black and White', 'IniError')) = 'TRUE';
        Document.Enabled := Uppercase(ReadString('Image Format', 'Document TIF Uncompressed', 'IniError')) = 'TRUE';

        TrueColorJPG.Enabled := Uppercase(ReadString('Image Format', 'True Color JPG', 'IniError')) = 'TRUE';
        DocumentG4.Enabled := Uppercase(ReadString('Image Format', 'Document TIF G4 FAX', 'IniError')) = 'TRUE';
        Bitmap.Enabled := Uppercase(ReadString('Image Format', 'Bitmap', 'IniError')) = 'TRUE';
        DICOMFormat.Enabled := Uppercase(ReadString('Image Format', 'DICOM', 'IniError')) = 'TRUE';
                { we're setting flags as to what ImageTypes are enabled in the INI file, so
                  when we switch devices , and the new device enables it's possible ImageTypes, we
                  won't enable an ImageType that has been disabled in the INI.  }
        With IniFormat Do
        Begin
          TCTGA := Color.Enabled;
          TCJPG := TrueColorJPG.Enabled;
          C256 := ColorScan.Enabled;
          x := Xray.Enabled;
          XJPG := XrayJPG.Enabled;
          bw := BlackAndWhite.Enabled;
          TIFUN := Document.Enabled;
          TIFG4 := DocumentG4.Enabled;
          BMP := Bitmap.Enabled;
          DICOM := DICOMFormat.Enabled;
                    //MV := MotionVideo.enabled;
                    //AUD := Audio.enabled;
        End;

        Lumisys75.Enabled := Uppercase(ReadString('Input Source', 'Lumisys75', 'FALSE')) = 'TRUE';
        Lumisys100.Enabled := Uppercase(ReadString('Input Source', 'Lumisys100', 'FALSE')) = 'TRUE';
        Lumisys150.Enabled := Uppercase(ReadString('Input Source', 'Lumisys150', 'FALSE')) = 'TRUE';
        Vidar.Enabled := Uppercase(ReadString('Input Source', 'Vidar', 'FALSE')) = 'TRUE';
        Vista.Enabled := Uppercase(ReadString('Input Source', 'Vista', 'FALSE')) = 'TRUE';
        Meteor.Enabled := Uppercase(ReadString('Input Source', 'Meteor', 'FALSE')) = 'TRUE';
        Clipboard.Enabled := Uppercase(ReadString('Input Source', 'ClipBoard', 'FALSE')) = 'TRUE';
        Twain.Enabled := Uppercase(ReadString('Input Source', 'TWAIN', 'FALSE')) = 'TRUE';
        Import.Enabled := Uppercase(ReadString('Input Source', 'Import', 'FALSE')) = 'TRUE';
        mimportdir1.Visible := Import.Enabled;
        ImportDirectoryOptions3.Visible := Import.Enabled;
        VistaInteractive.Enabled := Uppercase(ReadString('Input Source', 'Vistainteractive', 'FALSE')) = 'TRUE';
        ScanECG.Enabled := Uppercase(ReadString('Input Source', 'SCANECG', 'FALSE')) = 'TRUE';
        ScannedDocument.Enabled := Uppercase(ReadString('Input Source', 'ScannedDocument', 'FALSE')) = 'TRUE';
        ScanJetXray.Enabled := Uppercase(ReadString('Input Source', 'ScanJetXray', 'FALSE')) = 'TRUE';
        HideImportDir; //p8t25  hide import dir, incase it is disabled.
        SetDefaultInputSource(ReadString('Input Source', 'Default', 'NONE')); {197}
        //a/ If Scanmode <> 'Import' Then
        if CapX.mSourceID <> mcSrcImport then
        Begin
          If (ImportIni = 'TGA') And (CapX.mSourceID = mcSrcImport) Then
            SetDefaultImageFormat('True Color TGA')      // ?? this will never execute
          Else
            SetDefaultImageFormat(ReadString('Image Format', 'Default', 'Document TIF G4 FAX'));
        End;
        OnLine.Checked := True;

        { btnLOOKUPdata.visible:=False; }{ this is the lookup to medicine procedure, lab specimens, rad report}

        Medicine.Enabled := Uppercase(ReadString('Image Association', 'Medicine', 'IniError')) = 'TRUE';
        Laboratory.Enabled := Uppercase(ReadString('Image Association', 'Laboratory', 'IniError')) = 'TRUE';
        Radiology.Enabled := Uppercase(ReadString('Image Association', 'Radiology', 'IniError')) = 'TRUE';
        Surgery.Enabled := Uppercase(ReadString('Image Association', 'Surgery', 'IniError')) = 'TRUE';
        Tiu.Enabled := Uppercase(ReadString('Image Association', 'Progress Notes', 'IniError')) = 'TRUE';
        AdminDoc.Enabled := Uppercase(ReadString('Image Association', 'Admin Documents', 'IniError')) = 'TRUE';
        ClinProc.Enabled := Uppercase(ReadString('Image Association', 'Clinical Procedures', 'IniError')) = 'TRUE';
        TeleReaderConsult.Enabled := Uppercase(ReadString('Image Association', 'TeleReader Consult', 'IniError')) = 'TRUE';
        ClinImage.Enabled := Uppercase(ReadString('Image Association', 'Clinical Image', 'IniError')) = 'TRUE';
        PhotoID.Enabled := Uppercase(ReadString('Image Association', 'PhotoID', 'IniError')) = 'TRUE';
                // have to do this after a logon, it has RPC Calls.
                // ApplyWorkstationSettings
        FdftAssoc := Uppercase(ReadString('Image Association', 'Default', 'ClinImage'));
                // SetDefaultAssociation(FdftAssoc); {197}
        If XBROKERX.Connected Then
        Begin
          SetUserAssociations;
          SetDefaultAssociation(fdftAssoc);
        End;
      End; {with frmCapConfig do }
      ABScreated := Uppercase(ReadString('Workstation Settings', 'Abstracts created', 'FALSE')) = 'TRUE';
      //FCapSaveBIG := Uppercase(ReadString('Workstation Settings', 'Kernel Debug ON', 'FALSE')) = 'TRUE';
      // mnuSaveBigFile.Checked := FCapSaveBIG;
      //mnuDebugON.Visible := Uppercase(ReadString('Workstation Settings', 'Save Radiology BIG File', 'FALSE')) = 'TRUE';
       {/p117 T5   gek  4/1/11 the above 3 lines were mixed up, changed below.}
      FCapSaveBIG := Uppercase(ReadString('Workstation Settings', 'Save Radiology BIG File', 'FALSE')) = 'TRUE';
       mnuSaveBigFile.Checked := FCapSaveBIG;
      mnuDebugON.Visible :=  Uppercase(ReadString('Workstation Settings', 'Kernel Debug ON', 'FALSE')) = 'TRUE';
      FLoginOnStartup := Uppercase(ReadString('Login Options', 'LoginOnStartup', 'TRUE')) = 'TRUE';
      FrmConfigList.GetSavedConfigs;
    End; {with magini do begin }
  Finally
    Magini.Free;
    WinMsg('', '');
  End;
  GetImportDirsFromINI;
  FrmConfigList.ShowAsButtons(TabCtr);

  ApplySavedWindowSettings; { this call will get the saved heights of pnlimport and pLongDesc }

End;


{p129t18
 New Function.  this was just easier that modifying the old function in Magguini.pas
           this is only called from the Capture Application}
Procedure TfrmCapMain.CreateIFNeededFromCapture();
var
oldINI, newINI : string;
magini : Tinifile;
Begin
magappmsg('','INI - Check from Capture Application');
oldINI := ExtractFilePath(Application.ExeName) + 'mag308.ini';
newINI := GetConfigFileName;
if HasAttr(newINI,1) then
  begin
   Magappmsg('D','Configuration File: ' + newini +  #13
                + 'is Read Only !!! ' + #13  + #13
                + 'The File Attributes will be changed to enable writing to this file.');
  // application.Terminate;
   setfileattributes(pchar(newINI),0);   {change attributes to allow writing.} {???}

  end;

//getfileattributes(
  If ( FileExists(newINI) and  FileExists(oldINI) and ( NOT DidCapAppMarkINI(newINI)) ) Then
    begin
    magappmsg('','INI - Overwrite mag.ini from Capture Application starting...');

    { 129t18 This is the only situation we will Copy the oldINI and give it the MarkOf Capture. }

    { NewINI exists but wasn't copied by Capture,  AND we have an oldINI. so we copy it.
       This will get any newly created capture configurations that might not have been copied.
       Then give the INI the Mark of Capture, and done}

    try
      (* {$I+}
       deletefile(pchar(newini));
       {$I-}
     if getlasterror <> 0 then
       begin
       magappmsg('ED','Error during Delete of : ' + newini );
       magappmsg('s','System - GetLastError: ' + SysErrorMessage(Getlasterror));
       exit;
       end;
       *)
       {$I+}
       //  copyfile(pchar(oldINI),pchar(newINI),true);
       copyfile(oldINI,newINI);
       {$I-}
    (* if getlasterror <> 0 then
       begin
       magappmsg('ED','Error during Copy of : ' + oldINI );
       magappmsg('s','System - GetLastError: ' + SysErrorMessage(Getlasterror));
       exit;
       end; *)
     application.ProcessMessages;
     if HasAttr(newINI,1) then
       begin
       magappmsg('','Changeing File Attributes to enable writing to configuration file.');
       setfileattributes(pchar(newINI),0);   {change attributes to allow writing.}
       end;
     MarkOfCapture(newINI);
     magappmsg('','INI - Overwrite mag.ini Complete. ');
    except
     on e:exception do
       begin
       magappmsg('ed','Exception during processing INI file: ' + e.message);
       exit;
       end;
    end;
    end
    else
    begin
      magappmsg('','INI - Check complete.  INI okay.');
    end;
End;

{p129t18 / gek  DidCapAppMarkINI
          This will tell if Capture was the app
                           that copied the mag308.ini to mag.ini}
function TfrmCapMain.DidCapAppMarkINI(value : String): boolean;
Var
  Magini: TIniFile;
  appname : string;
Begin
  try
    result := true;
    if value = ''  then value := GetConfigFileName;
    Magini := TIniFile.Create(value);
    appname := uppercase(Magini.ReadString('SYS_SETTINGS','MARKOF', ''));
    magini.Free;
    if appname <> 'CAPTURE' then result := false;
  except
  on e:exception do
    begin
      result := true;
    end;
  end;
end;

procedure TfrmCapMain.MarkOfCapture(value : string);
Var
  Magini: TIniFile;
begin
     Magini := TIniFile.Create(value);
     Magini.WriteString('SYS_SETTINGS','MARKOF', 'CAPTURE');
     Magini.Free;
end;




Procedure TfrmCapMain.ApplyWorkstationSettings1Click(Sender: Tobject);
Begin
  ApplyWorkstationSettings;
  If iDModObj.GetMagDBBroker1.IsConnected Then
  Begin
    SetUserAssociations;
    SetDefaultAssociation(FdftAssoc);
  End;

End;

Procedure TfrmCapMain.tbwsFormatClick(Sender: Tobject);
Begin
OpenConfigurationSettingsWindow;
exit;

//  FrmCapConfig.FormStyle := fsStayOnTop;
//  FrmCapConfig.Show;
//  FrmCapConfig.BringToFront;
//  exit;
  SettingsEditFormat;

End;

Procedure TfrmCapMain.SettingsEditFormat;
Begin
(* no longer applicable *)
exit;
(*
  If FrmCapConfig.Visible Then
    FrmCapConfig.SetFocus
  Else
    DisplayConfigValues(FrmCapConfig.GImageFormat, Lbformatdesc.Left,
      Lbformatdesc.Top + Lbformatdesc.Height,
      'Select Image Format');
      *)
End;

Procedure TfrmCapMain.tbwsAssocClick(Sender: Tobject);
Begin
  SettingsEditAssociation;
End;

Procedure TfrmCapMain.SettingsEditAssociation;
Begin
  If FrmCapConfig.Visible Then
    FrmCapConfig.SetFocus
  Else
    DisplayConfigValues(FrmCapConfig.GAssociation, LbAssocDesc.Left,
      LbAssocDesc.Top + LbAssocDesc.Height,
      'Select Image Association');

{DONE : Get rid of conditional code when we're just displaying the Association panel.}
(*   stop the 'hard coded exceptions everywhere for TeleReader Consult;
  If Not FrmCapConfig.TeleReaderConsult.Checked Then
  Begin
    If FrmCapConfig.DICOMFormat.Checked Then
    Begin
      FrmCapConfig.DICOMFormat.Checked:=False;
    End;
  End;
  *)
  //end 106
End;

Procedure TfrmCapMain.tbwsSavingClick(Sender: Tobject);
Begin
  SettingsEditSavingAs;
End;

Procedure TfrmCapMain.SettingsEditSavingAs;
Begin
  If FrmCapConfig.Visible Then
    FrmCapConfig.SetFocus
  Else
    DisplayConfigValues(FrmCapConfig.GImageGroup, Imagegroupdesc.Left,
      Imagegroupdesc.Top + Imagegroupdesc.Height,
      'Saving as : ');
End;

Procedure TfrmCapMain.tbwsModeClick(Sender: Tobject);
Begin
  SettingsEditMode;
End;

Procedure TfrmCapMain.SettingsEditMode;
Begin
  If FrmCapConfig.Visible Then
    FrmCapConfig.SetFocus
  Else
    DisplayConfigValues(FrmCapConfig.GMode, Modedesc.Left, Modedesc.Top + Modedesc.Height,
      'Select Capture Mode');
End;

Procedure TfrmCapMain.tbwsSourceClick(Sender: Tobject);
Begin
OpenConfigurationSettingsWindow ;
exit;
  SettingsEditSource;
End;

Procedure TfrmCapMain.SettingsEditSource;
Begin
(*  No Longer Applicable   *)
exit;
(*  If FrmCapConfig.Visible Then
    FrmCapConfig.Visible := False;

  DisplayConfigValues(FrmCapConfig.GInputSource, LbInputSourceDesc.Left,
    LbInputSourceDesc.Top + LbInputSourceDesc.Height,
    'Select Input Source');
  *)
End;

Procedure TfrmCapMain.mnuCurrentSettingsTBClick(Sender: Tobject);
Begin
  mnuCurrentSettingsTB.Checked := Not mnuCurrentSettingsTB.Checked;
  FCurrentSettingsTB := mnuCurrentSettingsTB.Checked;
  tlbrSettings.Visible := FCurrentSettingsTB;
End;

Procedure TfrmCapMain.SavePatientNametoFile1Click(Sender: Tobject);
Var
  abmp: TBitmap;
{ TODO : not sure what this was used for}
Begin
  abmp := TBitmap.Create;
  abmp.Height := 30;
  abmp.Width := 100;
  abmp.monochrome := True;
  abmp.Canvas.Textout(2, 2, EdtPatName.Text);
  abmp.SaveToFile(AppPath + '\pname.bmp');
  Sleep(1000);
  abmp.Destroy;
End;


Procedure TfrmCapMain.Label3DblClick(Sender: Tobject);
Begin
  mSysman.Visible := Not msysman.Visible;
End;

Procedure TfrmCapMain.mtbAlignleftClick(Sender: Tobject);
Begin
  tlbarImage.Align := alLeft;
End;

Procedure TfrmCapMain.mtbAlignrightClick(Sender: Tobject);
Begin
  tlbarImage.Align := alright;
End;

Procedure TfrmCapMain.mtbAligntopClick(Sender: Tobject);
Begin
  tlbarImage.Align := altop;
  tlbarImage.Top := -1;
End;

Procedure TfrmCapMain.PopupMenuToolbarPopup(Sender: Tobject);
Begin
  mtbalignleft.Enabled := True;
  mtbalignright.Enabled := True;
  mtbaligntop.Enabled := True;
  If tlbarImage.Align = alright Then
    mtbalignright.Enabled := False;
  If tlbarImage.Align = alLeft Then
    mtbalignleft.Enabled := False;
  If tlbarImage.Align = altop Then
    mtbaligntop.Enabled := False;
End;

Procedure TfrmCapMain.showgeardimensions;
Var
  s: String;
Begin
(*
  s := Inttostr(Gear 1.Height) + '=GH ' + Inttostr(Gear 1.ImageHeight) + '=IH        ' + Inttostr(Gear 1.Width) + '=GW ' + Inttostr(Gear 1.ImageWidth) + '=IW '
    + #13 + Inttostr(Gear 1.ImageRectBottom) + 'IRbot  ' + Inttostr(Gear 1.ImageRectTop) + 'IRtop  '
    + Inttostr(Gear 1.ImageRectLeft) + 'IRleft  ' + Inttostr(Gear 1.ImageRectRight) + 'IRright  ';
    //ImageRectLeft,ImageRectRight, ImageRectTop,ImageRectBottom,
*)
  s := Inttostr(mg1.PnlImage.Height) + ' = panelH '
          + Inttostr(mg1.GetImageHeight) + ' = IGPage Height '+ #13
      + Inttostr(mg1.PnlImage.width) + ' = panelW '
          + Inttostr(mg1.GetImageWidth) + ' = IGPage Width ' + #13 ;


  Messagedlg(s, Mtconfirmation, [Mbok], 0);

End;

Procedure TfrmCapMain.showdimClick(Sender: Tobject);
Begin
  showgeardimensions;
End;

(*Procedure TfrmCapMain.Gear1SelectEvent(Sender: Tobject; Var LplLeft, LplTop,
  LplRight, LplBottom: Integer);
Begin
{p129.  this is to allow the selection rectangle go to any size,  the old way was
   that the rectangle kept the dimensions of the image, so all image inside rectangle
   would be zoomed.  Display now does it the old way,  so we'll do it the old way also.
     keeping rectangle to the aspect ratio dimentions.  Its automatic that way.}
{p129.  So this won't be converted to TMag4VGear.  (mg1)}
//p129  computeZoomLevel(LplLeft, LplTop, LplRight, LplBottom);

    {Gear 1.ImageRectLeft := lplLeft;
    Gear 1.ImageRectTop := lplTop;
    Gear 1.ImageRectRight := lplRight;
    Gear 1.ImageRectBottom := lplBottom;}
//p129  Gear 1.AspectRatio := IG_ASPECT_MINDIMENSION;
End;
*)

Procedure TfrmCapMain.ComputeZoomLevel(Left, Top, Right, Bottom: Integer);
Var
  devh, devw: Integer;
  selwidth: Integer;
Begin
  (* not used in p129.  commented out so we can compile.
  Gear 1.ZoomLevel := 100;
  Gear 1.Update;
  Gear 1.Invalidate;
  Gear 1.SelectEvent := 0;
  Gear 1.HandPanning := True;
    //Gear 1.Cursor := crHandPoint;

  selwidth := Right - Left;
  SetZoomLevel(Trunc((Gear 1.ImageWidth / SelWidth) * Gear 1.ZoomLevel));
  devw := (-1 * Gear 1.devicerectleft) + Gear 1.devicerectright;
  devh := (-1 * Gear 1.devicerecttop) + Gear 1.devicerectbottom;
  Gear 1.SetScrollPos(0, 4, Trunc((Left / Gear 1.ImageWidth) * devw));
  Gear 1.SetScrollPos(1, 4, Trunc((Top / Gear 1.ImageHeight) * devh));

  Gear 1.Update;
  Gear 1.Invalidate;
  Exit;
  *)
End;

Procedure TfrmCapMain.selectevent1Click(Sender: Tobject);
Begin
 (* p129 out
  ResetControls;
  Gear 1.SelectEvent := 1;
  *)
End;

Procedure TfrmCapMain.Version25testingupdates1Click(Sender: Tobject);
Begin
    //  RecentUpdates.loadupdates;
End;

Procedure TfrmCapMain.tlbrbtnResetClick(Sender: Tobject);
Begin
  GearReset;
End;

Procedure TfrmCapMain.GearReset;
Var
  cap, Stat: String;
  pgnum : integer;
Begin
  pgnum := mg1.Page;

  //p129t18 dmmn - clear annotation when reset also
  AnnotationsClose(); // fCapAnnot.Close;  *)

  {DONE: Save copy of image, to allow a Cancel function for Deskew and Despeckle}
  If FileExists(GUserDir.Temp + 'resetfile.tif') Then
  Begin
    cap := Lbviewingimage.caption;
    Stat := Pmsg.caption;
    LoadGear(GUserDir.Temp + 'resetfile.tif', GUserDir.Temp + 'resetfile.tif'); {ResetImage}
    Lbviewingimage.caption := cap;
    Pmsg.caption := Stat;
  {129t18 Duc  start}
    FModFLip := false;    //129t18 since we reload the image, it's better to reset all the flag
    FModRot := 0;
    fModINV := false;
    If ImageChangedOther Then
      ResetOther;
    FImageChanged := False;
    exit;
  {129t18 Duc  start end}
  End;

  If FileExists(GUserDir.Temp + 'multipage.tif') Then
  Begin
    cap := Lbviewingimage.caption;
    Stat := Pmsg.caption;
    LoadGear(GUserDir.Temp + 'multipage.tif', GUserDir.Temp + 'multipage.tif'); {ResetImage}
    Lbviewingimage.caption := cap;
    Pmsg.caption := Stat;
  {129t18 Duc  start}
    GoToPage(pgnum);
    FModFLip := false;    //129t18
    FModRot := 0;
    fModINV := false;
    If ImageChangedOther Then
      ResetOther;
    FImageChanged := False;
    exit;
  {129t18 Duc  start end}
  End;
   //   START Duc's CHANGES.  140 Refactor needed.
  //p129t18 dmmn - if there is a backup file, we need to reload the original image
  if FileExists(FbImgPath) and (UpperCase(ExtractFileExt(FbImgPath)) = '.TIF') then
  begin
    //DeleteFile(FwImgPath);

    cap := lbviewingimage.caption;
    Stat := pmsg.caption;
    LoadGear(FoImgPath, FoImgPath);
    Pmsg.caption := stat;
    GoToPage(pgnum);     // restore location

    FModFLip := false;
    FModRot := 0;
    fModINV := false;
    If ImageChangedOther Then
      ResetOther;
    FImageChanged := False;
    exit;
  end;
 //   END Duc's CHANGES.  140 Refactor needed.

    // New way isn't complete yet.
  If FModFLIP Then
    GearFlipH;
    // FlipGearH and FlipGearY are yet to be written, they will update the
    // FModROT counter, to correctly maintain the rotation of the image.
    //  NOTE : FModROT will never be negative.
  If ((FModROT Mod 4) > 0) Then
    begin
    //p129 Gear 1.Rotate := (90 * (4 - (FModROT Mod 4)));
    mg1.Rotate(90 * (4 - (FModROT Mod 4)));
    end;
  If FModINV Then
    begin
    //p129 Gear 1.invert := True;
    mg1.inverse;
    end;
  FModINV := False;
  FModFLIP := False;
  FModROT := 0;
    //if MagDocControlsf.imagemodified then MagDocControlsf.ResetContrastBrightness;
  If ImageChangedOther Then
    ResetOther;
  FImageChanged := False;

  //p129  Gear 1.FitMethod := IG_DISPLAY_FIT_TO_WINDOW;
  mg1.FitToWindow;
  //p129   ZoomLevel works in V16,, so this won't work.  SetZoomLevel(100);
  //p129   Gear 1.Redraw := True;
  mg1.UpdatePageView;
{ TODO -o129 : check to make sure we are/are not using FAnn..Manips}
  if FAnnotationManips <> nil then   // p122t11
    FAnnotationManips := TStringList.Create;
  FAnnotationManips.Clear;
  //FTRCImageManips := False;   //p122t12
End;

Function TfrmCapMain.IsImageChanged: Boolean;
Begin
  Result := (FImageChanged Or ImageChangedOther);
End;

Function TfrmCapMain.ImageChangedOther: Boolean;
Begin
    // We check this once, don't set a flag if value changes because if the user,
    //   changes back to 100, (there has been no change) we don't want to save
    //   Contrast and Brightness are 100 for a freshly captured image.
  Result := (TbicBrightness.Position <> 100) Or (TbicContrast.Position <> 100);
    //   not saving if am image is zoomed.
    //   or (tbicZoom.position <> 100));
End;

Procedure TfrmCapMain.ResetOther;
Begin
  TbicContrast.Position := 100;
  TbicBrightness.Position := 100;
  TbicBrightness.OnChange(Self);
  TbicContrast.OnChange(Self);
  SetZoomLevel(100);

End;

Procedure TfrmCapMain.tlbrbtnFlipHorizClick(Sender: Tobject);
Begin
  GearFlipH;
End;

Procedure TfrmCapMain.GearFlipH;
var
  flipPage : integer;
  flipFileName : string;
Begin
  If isgearClear(mg1) Then
    Exit;
 if not mg1.IsValidImage
    then exit;

  FModROT := (FModROT Mod 4);
  Case FModROT Of
    0: FModROT := 1;
    1: FModROT := 0;
    2: FModROT := 3;
    3: FModROT := 2;
  End;
  FImageChanged := True;
//p129   Gear 1.Flip := IG_FLIP_HORIZONTAL;
  mg1.FlipHoriz;
  mg1.UpdatePageView;
  FModFLIP := Not (FModFLIP);

  { TODO -o129 : This annotation will come out.
     need to check with Duc. }


  //p122t11 dmmn - tracking manip
  if FAnnotationManips = nil then
    FAnnotationManips := TStringList.Create();
  FAnnotationManips.Add('IG_FLIP_HORIZONTAL');
  //FTRCImageManips := True;   //p122t12
     {129t18 Duc  start  }    
  if (mg1.PageCount > 1) or (FileExists(GUserDir.Temp + 'multipage.tif')) then
  begin
    flipPage := mg1.Page - 1 ;
    flipFileName := mg1.ImageFilename;
    getIGManager.IGFormatsCtrl.savePageToFile(mg1.GetCurrentPage,flipFileName,flipPage,IG_PAGESAVEMODE_REPLACE,CapX.mIGSaveFormat);
  end;
     {129t18 Duc  start end }  
End;

Procedure TfrmCapMain.tlbrbtnFlipVertClick(Sender: Tobject);
Begin
  GearFlipV;
End;

Procedure TfrmCapMain.GearFlipV;
     {129t18 Duc  start  }  
var
  flipPage : integer;
  flipFileName : string;
     {129t18 Duc  start end }  
Begin
  If isgearClear(mg1) Then
    Exit;
  if not mg1.isvalidimage
    then exit;

  FModROT := (FModROT Mod 4);
  Case FModROT Of
    0: FModROT := 3;
    1: FModROT := 2;
    2: FModROT := 1;
    3: FModROT := 0;
  End;
  FImageChanged := True;
//  Gear 1.Flip := IG_FLIP_VERTICAL;
  mg1.FlipVert;
  mg1.UpdatePageView;
  FModFLIP := Not (FModFLIP);

{ TODO -o129 : This annotation wil come out.
   need to check with Duc.}
  //p122t11 dmmn - tracking manip
  if FAnnotationManips = nil then
    FAnnotationManips := TStringList.Create();
  FAnnotationManips.Add('IG_FLIP_VERTICAL');
  //FTRCImageManips := True;   //p122t12
     {129t18 Duc  start }
  //p129t18 dmmn 5/21/13 add multipage scanning in case it's a single page scan as multipage
  if (mg1.PageCount > 1) or (FileExists(GUserDir.Temp + 'multipage.tif')) then
  begin
    flipPage := mg1.Page - 1 ;
    flipFileName := mg1.ImageFilename;
    getIGManager.IGFormatsCtrl.savePageToFile(mg1.GetCurrentPage,flipFileName,flipPage,IG_PAGESAVEMODE_REPLACE,CapX.mIGSaveFormat);
  end;
     {129t18 Duc  start end }
End;

Procedure TfrmCapMain.mAlternateVideoViewerClick(Sender: Tobject);
Var
  altviewer: String;
  Magini: TIniFile;
Begin
  Magini := TIniFile.Create(GetConfigFileName);
  Try
    altviewer := Magini.ReadString('Workstation settings', 'Alternate Video Viewer', '');
    If altviewer <> '' Then
    Begin
      opendialog2.Filename := altviewer;
      opendialog2.InitialDir := ExtractFilePath(altviewer);
    End
    Else
      Opendialog2.InitialDir := MagGetWindowsDirectory;
    If opendialog2.Execute Then
    Begin
      altviewer := OPendialog2.Filename;
      Magini.Writestring('Workstation settings', 'Alternate Video Viewer', altviewer);
    End;
  Finally
    Magini.Free;
  End;
End;

Procedure TfrmCapMain.MSysManhelpClick(Sender: Tobject);
Begin
  OpenSysManHelp;
End;

Procedure TfrmCapMain.OpenSysManHelp;
Begin
  Magexecutefile(AppPath + '\MagSysKey.hlp', '', '', SW_SHOW);
End;

Procedure TfrmCapMain.lbPatNameMouseDown(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Begin
  If (Ssctrl In Shift) And (SsShift In Shift) Then
  Begin
    mnuTest1.Visible := Not mnuTest1.Visible;
    mnuTest2.Visible := mnuTest1.Visible;
    msysman.Visible := Userhaskey('MAG SYSTEM') Or mnuTest1.Visible;
  End;
End;

Procedure TfrmCapMain.findfirstfileshowinfo1Click(Sender: Tobject);
Var
  s: String;
  x: Integer;
  Sr: TSearchRec;
Begin
  s := Imagelongdesc.Lines[0];
  x := FindFirst(s, FaAnyFile, Sr);
  If x <> 0 Then
    Imagelongdesc.Lines.Add('Error code: ' + Inttostr(x))
  Else
    Imagelongdesc.Lines.Add('Size: ' + Inttostr(Sr.Size));

End;

Procedure TfrmCapMain.btnOpenFileClick(Sender: Tobject);
Begin

    //MagExecuteFile(image, '', '', SW_SHOW);
  Magexecutefile(Lbviewingimage.caption, '', '', SW_SHOW);

End;

Procedure TfrmCapMain.GetIndexLists;
Var
  t: TStrings;
Begin
  t := Tstringlist.Create;
  Try
    MagLvUtils1.ListView := LvProcEvent;
    iDModObj.GetMagDBBroker1.RPIndexGetEvent(t); //cbIndexProcEvent.items);
    MagLvUtils1.LoadListFromStrings(t, False);
    t.Clear;
    MagLvUtils1.ListView := LvSpecSubSpec;
    iDModObj.GetMagDBBroker1.RPIndexGetSpecSubSpec(t); //(cbIndexSpecSubSpec.items);
    MagLvUtils1.LoadListFromStrings(t, False);
    LoadOriginSet;
  Finally
    t.Free;
  End;
End;

Procedure TfrmCapMain.LoadOriginSet;
Var
  FMSet: TImageFMSet;
Begin
  FMSet := TImageFMSet.Create;
  Try
    FMSet.DBSetDefinition := XwbGetVarValue2('$P($G(^DD(2005,45,0)),U,3)');
    cbOrigin.Items.Assign(FMSet.GetListOfExternalValues);
  Finally
    FreeAndNil(FMSet);
  End;
End;

Procedure TfrmCapMain.tbwsOtherMouseDown(Sender: Tobject;
  Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Var
  inputpw, PW: String;
Begin
  If (Ssctrl In Shift) And (SsShift In Shift) Then
  Begin
    inputpw := FrmPasswordDlg.Execute;
    PW := Formatdatetime(' mm.dd.yy ', Now);
    If Uppercase(inputpw) = PW
      Then  EnableTestFunctions(True)
      else  EnableTestFunctions(false);
  End;
End;
 {****  procedure TfrmMain.ForceRepaint;  ****}
     { Invalidate didn't work. Update didn't work, this is funny, but it works.
        When we hide/show menu items, they don't always become visible so we need
        to refresh the window }
 procedure TfrmCapMain.ForceRepaint;
    begin
     winmsg('s', ' Forcing Repaint..... Current Patient' + idmodObj.GetMagPat1.M_DFN);
      frmCapMain.width := frmCapMain.width + 1;
      update;
      frmCapMain.width := frmCapMain.width - 1;
      update;
    end;


Procedure TfrmCapmain.EnableTestFunctions(TF: Boolean);
Begin
  FTesting := TF;

    mnuTest1.Visible := TF;
    mnuTest2.Visible := TF;
    msysman.Visible := Userhaskey('MAG SYSTEM') Or TF;
    EnableTestFunctions(TF);
    ShowTestMessages1.Checked := TF;
    FCapClinMgr.FtestmessagesOn := TF;
  DeSkew2.Visible := Tf;
  DeSkew1.Visible := Tf;

  DeSpeckle1.Visible := Tf;
  DeSpeckle2.Visible := Tf;
  tlbrbtnDeSkew.Visible := Tf;
  tlbrbtnDeSpeckle.Visible := Tf;
End;

Procedure TfrmCapMain.edtPatNameMouseDown(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Begin
  If (Ssctrl In Shift) And (SsShift In Shift) Then
  Begin
    mnuTest1.Visible := Not mnuTest1.Visible;
    mnuTest2.Visible := mnuTest1.Visible;
    msysman.Visible := Userhaskey('MAG SYSTEM') Or mnuTest1.Visible;
  End;
  If Button = Mbright Then
    OpenProcHoldMenu(x, y, TControl(EdtPatName), LbPatName);
End;

Procedure TfrmCapMain.AdminMeansTest1Click(Sender: Tobject);
Var
  hFile: String;
Begin
  hFile := 'MEANSTEST.HLP';
  If Not FileExists(AppPath + '\' + hFile) Then
    WinMsg('d', 'File ' + hFile + ' doesn''t exist in Imaging Directory.')
  Else
  Begin
    Try
      Magexecutefile(AppPath + '\' + hFile, '', '', SW_SHOW);
    Except
      On e: Exception Do
        WinMsg('d', e.Message);
    End;
  End;
End;

Procedure TfrmCapMain.PopupImageControlsPopup(Sender: Tobject);
Begin
    // ClipBoard FIX 7/06/01 GEK
  CopyImageToClipboard1.Enabled := FrmCapConfig.Clipboard.Enabled;
  PasteImageFromClipboard1.Enabled := FrmCapConfig.Clipboard.Enabled;
  OpenPanWindow1.Checked := mg1.PanWindow;
End;

Procedure TfrmCapMain.DocumentScanning1Click(Sender: Tobject);
Var
  hFile: String;
Begin
  hFile := 'DOCSCAN.HLP';
  If Not FileExists(AppPath + '\' + hFile) Then
    WinMsg('d', 'File ' + hFile + ' doesn''t exist in Imaging Directory.')
  Else
  Begin
    Try
      Magexecutefile(AppPath + '\' + hFile, '', '', SW_SHOW);
    Except
      On e: Exception Do
        WinMsg('d', e.Message);
    End;
  End;
End;

Procedure TfrmCapMain.btnTypeClick(Sender: Tobject);
Begin
  LvProcEvent.Visible := False;
  LvSpecSubSpec.Visible := False;
  LvType.Visible := Not LvType.Visible;
  If LvType.Visible Then
    LvType.SetFocus;

  (* p129
  {/p122t2 dmmn 9/7 - change the parent so that the listview can stay on top while
  visible if annotation is visible /}
  if LvType.Visible then
  begin
    if fCapAnnot.visible then
    begin
      fCapAnnot.Parent := imagepanel;
      fCapAnnot.Align := alClient;
    end;
  end
  else
  begin
    if fCapAnnot.Visible then
    begin
      fCapAnnot.parent := nil;
      fCapAnnot.align := alNone;
      ResizeAnnotOverlay;
    end;
  end;
  *)
End;

Procedure TfrmCapMain.btnProcEventClick(Sender: Tobject);
Begin
  LvType.Visible := False;
  LvSpecSubSpec.Visible := False;
  LvProcEvent.Visible := Not LvProcEvent.Visible;
  If LvProcEvent.Visible Then
    LvProcEvent.SetFocus;
(*
  {/p122t2 dmmn 9/7 - change the parent so that the listview can stay on top while
  visible if annotation is visible /}
  if LvProcEvent.Visible then
  begin
    if fCapAnnot.visible then
    begin
      fCapAnnot.Parent := imagepanel;
      fCapAnnot.Align := alClient;
    end;
  end
  else
  begin
    if fCapAnnot.Visible then
    begin
      fCapAnnot.parent := nil;
      fCapAnnot.align := alNone;
      ResizeAnnotOverlay;
    end;
  end;
  *)
End;

procedure TfrmCapMain.btnReviewClick(Sender: TObject);
begin
if fileexists(GUserDir.Temp + 'magpdf.pdf') then
  begin
   // mg1.LoadTheImage(GUserDir.Temp + 'magpdf.pdf');
    magexecuteFile(GUserDir.Temp + 'magpdf.pdf', '', '', SW_SHOW);
  end
  else
  if fileexists(GUserDir.Temp + 'multipage.tif') then                                       
       begin
          magexecuteFile(GUserDir.Temp + 'multipage.tif', '', '', SW_SHOW);
       end
       else
        begin
          magappmsg('d','PDF File does not exist');
        end;
end;

Procedure TfrmCapMain.btnSpecSubSpecClick(Sender: Tobject);
Begin
  LvType.Visible := False;
  LvProcEvent.Visible := False;
  LvSpecSubSpec.Visible := Not LvSpecSubSpec.Visible;
  If LvSpecSubSpec.Visible Then
    LvSpecSubSpec.SetFocus;
  (* p129

  {/p122t2 dmmn 9/7 - change the parent so that the listview can stay on top while
  visible if annotation is visible /}
  if LvSpecSubSpec.Visible then
  begin
    if fCapAnnot.visible then
    begin
      fCapAnnot.Parent := imagepanel;
      fCapAnnot.Align := alClient;
    end;
  end
  else
  begin
    if fCapAnnot.Visible then
    begin
      fCapAnnot.parent := nil;
      fCapAnnot.align := alNone;
      ResizeAnnotOverlay;
    end;
  end;
*)
End;

Procedure TfrmCapMain.edtTypeEnter(Sender: Tobject);
Begin
  If FEdtLV.FShowListOnEnter Then //WPR AUTO
  Begin
        // The TMag
    FEdtLV.GenShowlistview(EdtType, LvType);
    FALOType := True; // Global variable tells other functions which LV is in play.
  End;
End;

Procedure TfrmCapMain.edtTypeExit(Sender: Tobject);
Begin
  FALOType := False;
  FEdtLV.GenExiting(EdtType, LvType);
  If ((Screen.activecontrol.Name <> 'btnType') And (Screen.activecontrol.Name <> 'lvtype'))
        {//  if not ((activecontrol.Name = 'btnType') or (activecontrol.name = 'lvtype'))}Then
  begin
    LvType.Visible := False;

    (* p129
  {/p122t2 dmmn 9/7/11 /}
    if fCapAnnot.parent <> nil then
    begin
      fCapAnnot.parent := nil;
      fCapAnnot.Align := alNone;
      ResizeAnnotOverlay;
    end;
    *)

  end;
  LOOKUPIndexType;
  AutoImageDesc(EdtType.Text, magdescType); // GetImageDescFromType;

End;

Procedure TfrmCapMain.edtProcEventEnter(Sender: Tobject);
Begin
  lastProcEventEntry := EdtProcEvent.Text;
  If FEdtLV.FShowListOnEnter Then
  Begin
    FEdtLV.GenShowlistview(EdtProcEvent, LvProcEvent);
    FALOProcEvent := True;
  End;
End;

Procedure TfrmCapMain.edtProcEventExit(Sender: Tobject);
Begin
  FALOProcEvent := False; //WPR INDEX
  If ((Screen.activecontrol.Name <> 'btnProcEvent') And (Screen.activecontrol.Name <> 'lvProcEvent'))
        {//  if not ((activecontrol.Name = 'btnProcEvent') or (activecontrol.name = 'lvProcEvent'))}Then
  begin
    LvProcEvent.Visible := False;

    (* p129

    {/p122t2 dmmn 9/7/11 /}
    if fCapAnnot.parent <> nil then
    begin
      fCapAnnot.parent := nil;
      fCapAnnot.Align := alNone;
      ResizeAnnotOverlay;
    end;

  *)

  end;
  FEdtLV.GenExiting(EdtProcEvent, LvProcEvent);

  If (lastProcEventEntry <> EdtProcEvent.Text) Then
    UpdateSpecFromProc; //WPR INDEX

End;

Procedure TfrmCapMain.UpdateSpecFromProc;
Var
  ProcEventPtr, lastspec: String;
  t: TStrings;
Begin
  If Not iDModObj.GetMagDBBroker1.IsConnected Then
    Exit; //WPR INDEX
    // Spec has chaned, need to update the ProcEvent List
  If LvProcEvent.Selected = Nil Then
    ProcEventPtr := ''
  Else
    ProcEventPtr := MagPiece(TMagLVData(LvProcEvent.Selected.Data).Data, '^', 1);
  lastspec := EdtSpecSubSpec.Text;
  t := Tstringlist.Create;
  Try
    MagLvUtils1.ListView := LvSpecSubSpec; //WPR INDEX
    iDModObj.GetMagDBBroker1.RPIndexGetSpecSubSpec(t, FClass, ProcEventPtr); //cbIndexProcEvent.items);
    If (t.Count > 0) Then
      MagLvUtils1.LoadListFromStrings(t, False);
    LvSpecSubSpec.Selected := Nil;
    EdtSpecSubSpec.Text := '';
        // Now see if the lastSpec, is in the new list, and select it if it is.   //WPR INDEX
    If (lastspec <> '') And FEdtLV.GenOldTextInNewLV(lastspec, LvSpecSubSpec) Then
    Begin
      EdtSpecSubSpec.Text := LvSpecSubSpec.Selected.caption;
    End;
    If LvSpecSubSpec.Selcount > 0 Then
      ImgSpecSubSpecPtr := MagPiece(TMagLVData(LvSpecSubSpec.Selected.Data).Data, '^', 1);

  Finally
    t.Free
  End;
  LvSpecSubSpec.Update;
  Application.Processmessages;
End;

Procedure TfrmCapMain.edtProcEventKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
Begin
  FEdtLV.SelectByArrow := True;
  If Key = 27 Then
  Begin
    LvProcEvent.Hide;
    EdtProcEvent.Text := '';
  End
  Else
    FEdtLV.GenKeyDown(EdtProcEvent, LvProcEvent, Key);

  (* p129
  {/p122t2 dmmn 9/7 - keep the listview on top /}
  if LvProcEvent.Visible then
  begin
    if fCapAnnot.visible then
    begin
      fCapAnnot.Parent := imagepanel;
      fCapAnnot.Align := alClient;
    end;
  end
  else
  begin
    if fCapAnnot.Visible then
    begin
      fCapAnnot.parent := nil;
      fCapAnnot.align := alNone;
      ResizeAnnotOverlay;
    end;
  end;
  *)
End;

Procedure TfrmCapMain.edtSpecSubSpecEnter(Sender: Tobject);
Begin
  lastSpecSubSpecEntry := EdtSpecSubSpec.Text;
  If FEdtLV.FShowListOnEnter Then
  Begin
    FEdtLV.GenShowlistview(EdtSpecSubSpec, LvSpecSubSpec);
    FALOSpecSubSpec := True;
  End;

End;

Procedure TfrmCapMain.edtSpecSubSpecExit(Sender: Tobject);
Begin
  FALOSpecSubSpec := False;
  If ((Screen.activecontrol.Name <> 'btnSpecSubSpec') And (Screen.activecontrol.Name <> 'lvSpecSubSpec'))
        {//  if not ((activecontrol.Name = 'btnSpecSubSpec') or (activecontrol.name = 'lvSpecSubSpec'))}Then
  begin
    LvSpecSubSpec.Visible := False;

  (* p129
    {/p122t2 dmmn 9/7/11 /}
    if fCapAnnot.parent <> nil then
    begin
      fCapAnnot.parent := nil;
      fCapAnnot.Align := alNone;
      ResizeAnnotOverlay;
    end;
    *)

  end;
  FEdtLV.GenExiting(EdtSpecSubSpec, LvSpecSubSpec);
  If (lastSpecSubSpecEntry <> EdtSpecSubSpec.Text) Then
    UpdateProcFromSpec;
End;

{   Specialty has changed, need to update the Proc list filterning on the Spec value}

Procedure TfrmCapMain.UpdateProcFromSpec;
Var
  specptr, lastProc: String;
  t: TStrings;
Begin
  If Not iDModObj.GetMagDBBroker1.IsConnected Then
    Exit;
    // Spec has chaned, need to update the ProcEvent List
  If LvSpecSubSpec.Selected = Nil Then
    specptr := ''
  Else
    specptr := MagPiece(TMagLVData(LvSpecSubSpec.Selected.Data).Data, '^', 1);
  lastproc := EdtProcEvent.Text;
  t := Tstringlist.Create;
  Try
    MagLvUtils1.ListView := LvProcEvent;
    iDModObj.GetMagDBBroker1.RPIndexGetEvent(t, FClass, specptr); //cbIndexProcEvent.items);
    If (t.Count > 0) Then
      MagLvUtils1.LoadListFromStrings(t, False);
    LvProcEvent.Selected := Nil;
    EdtProcEvent.Text := '';
        // Now see if the lastProc, is in the new list, and select it if it is.
    If (lastproc <> '') And FEdtLV.GenOldTextInNewLV(lastproc, LvProcEvent) Then
    Begin
      EdtProcEvent.Text := LvProcEvent.Selected.caption;
    End;
    If LvProcEvent.Selcount > 0 Then
      ImgProcEventPtr := MagPiece(TMagLVData(LvProcEvent.Selected.Data).Data, '^', 1);

  Finally
    t.Free
  End;
  LvProcEvent.Update;
  Application.Processmessages;
End;

Procedure TfrmCapMain.edtTypeKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
Begin
  FEdtLV.SelectByArrow := True;
  Testmsg('main KeyDown Key: ' + Inttostr(Key) + '  .text' + EdtType.Text);
  If Key = 27 Then // 27 = ESC
  Begin
    LvType.Hide;
    EdtType.Text := '';
  End
  Else
  Begin
    FEdtLV.GenKeyDown(EdtType, LvType, Key);
  End;
  (* p129

  {/p122t2 dmmn 9/7 - keep the listview on top of annotation overlay /}
  if LvType.Visible then
  begin
    if fCapAnnot.visible then
    begin
      fCapAnnot.Parent := imagepanel;
      fCapAnnot.Align := alClient;
    end;
  end
  else
  begin
    if fCapAnnot.Visible then
    begin
      fCapAnnot.parent := nil;
      fCapAnnot.align := alNone;
      ResizeAnnotOverlay;
    end;
  end;
*)

End;

Procedure TfrmCapMain.edtSpecSubSpecKeyDown(Sender: Tobject; Var Key: Word;  Shift: TShiftState);
Begin
  FEdtLV.SelectByArrow := True;
  If Key = 27 Then
  Begin
    LvSpecSubSpec.Hide;
    EdtSpecSubSpec.Text := '';
  End
  Else
    FEdtLV.GenKeyDown(EdtSpecSubSpec, LvSpecSubSpec, Key);
  (* p129

  {/p122t2 dmmn 9/7 - keep the listview on top of annotation overlay /}
  if LvSpecSubSpec.Visible then
  begin
    if fCapAnnot.visible then
    begin
      fCapAnnot.Parent := imagepanel;
      fCapAnnot.Align := alClient;
    end;
  end
  else
  begin
    if fCapAnnot.Visible then
    begin
      fCapAnnot.parent := nil;
      fCapAnnot.align := alNone;
      ResizeAnnotOverlay;
    end;
  end;
*)
End;

Procedure TfrmCapMain.lvTypeClick(Sender: Tobject);
Begin
  FEdtLV.GenClicked(EdtType, LvType);
  LOOKUPIndexType;
  AutoImageDesc(EdtType.Text, magdescType); //GetImageDescFromType;
  If FEdtLV.FAutoTab Then
    FEdtLV.GenGoToNextControl(EdtType);
End;

Procedure TfrmCapMain.lvProcEventClick(Sender: Tobject);
Begin
  FEdtLV.GenClicked(EdtProcEvent, LvProcEvent);
  UpdateSpecFromProc;
  If FEdtLV.FAutoTab Then
    FEdtLV.GenGoToNextControl(EdtProcEvent);

End;

Procedure TfrmCapMain.lvSpecSubSpecClick(Sender: Tobject);
Begin
  FEdtLV.GenClicked(EdtSpecSubSpec, LvSpecSubSpec);
  UpdateProcFromSpec;
  If FEdtLV.FAutoTab Then
    FEdtLV.GenGoToNextControl(EdtSpecSubSpec);
End;

(*
procedure TfrmCapMain.GetImageDescFromType;
var s, newcattext: string;
begin
  { TODO :
  PATCH 8, if image desc, is not a category ,or doesn't have the old Type in it.
  then it ALL gets erased and the New Type is set as Image des. }
  //o showmes sage('On Change '+imgcat.text+'  '+CtgByClass[imgcat.itemindex]);
  //o Here always change Image Description to .Text
IF IniUseImageDesc then    // this is new for p8t37
  begin
  newcattext := edttype.text;
  s := newcattext;
  if (edtImageDesc.Text = oldcattext) then edtImageDesc.Text := ''
  else if (Pos(oldcattext, edtImageDesc.Text) > 0) then
    edtImageDesc.Text := copy(edtImageDesc.Text, 0, Pos(oldcattext, edtImageDesc.Text) - 1) + newcattext + copy(edtImageDesc.Text, (Pos(oldcattext, edtImageDesc.Text) + length(oldcattext)), length(edtImageDesc.Text));
  oldcattext := newcattext;
  if edtImageDesc.text = '' then edtImageDesc.Text := s;
  end;
end;
*)

Procedure TfrmCapMain.LOOKUPIndexType;
Var
  Li: TListItem;
  s: String;
Begin

    //o Set ImgCatPtr
    //  ImgCatptr := magpiece(CtgByClass[imgcat.itemindex], '^', 2);
  If LvType.Selcount > 0 Then
  Begin
    Li := LvType.Selected;
    s := TMagLVData(Li.Data).Data;
    ImgTypePtr := s;
  End;
    //o Here always change procedure to $p 3
    //o  If $p 3 = ''  then use .TEXT
     // edtStudy.Text := magpiece(CtgByClass[imgcat.itemindex], '^', 3);
    //o This is to keep sites that don't have 'DocImaging Patch 9 KIDs' working.
     // if (edtStudy.Text = '') then edtStudy.Text := edtImageDesc.Text;

End;

Procedure TfrmCapMain.lvProcEventKeyDown(Sender: Tobject; Var Key: Word;  Shift: TShiftState);
Begin
  If Key = 27 Then
  Begin
    TListView(Sender).Hide;
    EdtProcEvent.SetFocus;
  End
  Else
    If (Key = VK_Return) Then
      FEdtLV.GenClicked(EdtProcEvent, LvProcEvent);
End;

Procedure TfrmCapMain.lvSpecSubSpecKeyDown(Sender: Tobject; Var Key: Word;  Shift: TShiftState);
Begin
  If Key = 27 Then
  Begin
    TListView(Sender).Hide;
    EdtSpecSubSpec.SetFocus;
  End
  Else
    If (Key = VK_Return) Then
      FEdtLV.GenClicked(EdtSpecSubSpec, LvSpecSubSpec);
End;

Procedure TfrmCapMain.lvTypeKeyDown(Sender: Tobject; Var Key: Word;  Shift: TShiftState);
Begin
  If Key = 27 Then
  Begin
    TListView(Sender).Hide;
    EdtType.SetFocus;
  End
  Else
    If (Key = VK_Return) Then
    Begin
      FEdtLV.GenClicked(EdtType, LvType);
      LOOKUPIndexType;
      AutoImageDesc(EdtType.Text, magdescType); //GetImageDescFromType;
    End;
End;

Procedure TfrmCapMain.edtImageDescKeyDown(Sender: Tobject; Var Key: Word;  Shift: TShiftState);
Begin
  If (Key = VK_Return) Then
    FEdtLV.GenGoToNextControl(EdtImageDesc);
End;

Procedure TfrmCapMain.edtTypeKeyUp(Sender: Tobject; Var Key: Word; Shift: TShiftState);
Var
  Txt, Fulltext: String;
  Hits: Integer;
  searchinglist: Boolean;
Begin
  Hits := 0;
  FEdtLV.SelectByArrow := True;
  Testmsg('1- main start kup- ' + EdtType.Text + ' sel:' + EdtType.Seltext);
  If ((Key = 38) Or (Key = 40)) Then
  Begin
    EdtType.SelectAll;
    Exit;
  End;
  If (Key = 37) Or (Key = 39) Then
    Exit;

  Txt := EdtType.Text;
  Fulltext := '';
  If Key = 8 Then
  Begin
    Txt := Copy(Txt, 1, Length(Txt) - 1);
    Testmsg('1-bksp ' + Txt);
  End;

  If ((Key > 31) And (Key < 256)) Or (Key = 8) Then
  Begin
    If (EdtType.Seltext <> '') Then
    Begin
      Txt := Copy(EdtType.Text, 1, Pos(EdtType.Seltext, EdtType.Text) - 1);
    End;
    FEdtLV.SelectByArrow := False;
    searchinglist := True;
    While searchinglist Do
    Begin
      Hits := FEdtLV.GenKeyUp(EdtType, Txt, Fulltext, LvType, False); //key = 8);
      If (Hits = 0) Then
      Begin
        Txt := Copy(Txt, 1, Length(Txt) - 1);
        If Length(Txt) = 0 Then
        Begin
          Fulltext := '';
          LvType.Selected := Nil;
          Break;
        End
        Else
          Continue;
      End;
      searchinglist := False;
    End;
    EdtType.Text := Fulltext;
    EdtType.SELSTART := Length(Txt);
    EdtType.SelLength := 999;
    If FEdtLV.FAutoSelect And (Hits = 1) Then
    Begin
            //today edt.text := lv.Selected.caption;
      FEdtLV.GenGoToNextControl(EdtType);
            //today lv.visible := false;
    End;
    Testmsg('5- main end  sel' + EdtType.Seltext);
  End;
  Testmsg('  ');
End;

Procedure TfrmCapMain.lvTypeExit(Sender: Tobject);
Begin
  If activecontrol = Nil Then
    LvType.Hide
  Else
    If Not (activecontrol.Name = 'btnType') Then
      LvType.Hide;

  (* p129
  {/p122t2 dmmn 9/7/11 /}
  if fCapAnnot.parent <> nil then
  begin
    fCapAnnot.parent := nil;
    fCapAnnot.Align := alNone;
    ResizeAnnotOverlay;
  end;
*)


End;

Procedure TfrmCapMain.lvProcEventExit(Sender: Tobject);
Begin
  If activecontrol = Nil Then
    LvProcEvent.Hide
  Else
    If Not (activecontrol.Name = 'btnProcEvent') Then
      LvProcEvent.Hide;

  (* p129
  {/p122t2 dmmn 9/7/11 /}
  if fCapAnnot.parent <> nil then
  begin
    fCapAnnot.parent := nil;
    fCapAnnot.Align := alNone;
    ResizeAnnotOverlay;
  end;
  *)

End;

Procedure TfrmCapMain.lvSpecSubSpecExit(Sender: Tobject);
Begin
  If activecontrol = Nil Then
    LvSpecSubSpec.Hide
  Else
    If Not (activecontrol.Name = 'btnSpecSubSpec') Then
      LvSpecSubSpec.Hide;

  (* p129
  {/p122t2 dmmn 9/7/11 /}
  if fCapAnnot.parent <> nil then
  begin
    fCapAnnot.parent := nil;
    fCapAnnot.Align := alNone;
    ResizeAnnotOverlay;
  end;
  *)

End;

Procedure TfrmCapMain.edtSpecSubSpecKeyUp(Sender: Tobject; Var Key: Word;  Shift: TShiftState);
Var
  Txt, Fulltext: String;
  Hits: Integer;
  searchinglist: Boolean;
Begin
  Hits := 0;
  FEdtLV.SelectByArrow := True;
  Testmsg('1- main start kup- ' + EdtSpecSubSpec.Text + ' sel:' + EdtSpecSubSpec.Seltext);
  If ((Key = 38) Or (Key = 40)) Then
  Begin
    EdtSpecSubSpec.SelectAll;
    Exit;
  End;
  If (Key = 37) Or (Key = 39) Then
    Exit;

  Txt := EdtSpecSubSpec.Text;
  Fulltext := '';
  If Key = 8 Then
  Begin
    Txt := Copy(Txt, 1, Length(Txt) - 1);
    Testmsg('1-bksp ' + Txt);
  End;

  If ((Key > 31) And (Key < 256)) Or (Key = 8) Then
  Begin
    If (EdtSpecSubSpec.Seltext <> '') Then
    Begin
      Txt := Copy(EdtSpecSubSpec.Text, 1, Pos(EdtSpecSubSpec.Seltext, EdtSpecSubSpec.Text) - 1);
    End;
    FEdtLV.SelectByArrow := False;
    searchinglist := True;
    While searchinglist Do
    Begin
      Hits := FEdtLV.GenKeyUp(EdtSpecSubSpec, Txt, Fulltext, LvSpecSubSpec, False); //key = 8);
      If (Hits = 0) Then
      Begin
        Txt := Copy(Txt, 1, Length(Txt) - 1);
        If Length(Txt) = 0 Then
        Begin
          Fulltext := '';
          LvSpecSubSpec.Selected := Nil;
          Break;
        End
        Else
          Continue;
      End;
      searchinglist := False;
    End;
    EdtSpecSubSpec.Text := Fulltext;
    EdtSpecSubSpec.SELSTART := Length(Txt);
    EdtSpecSubSpec.SelLength := 999;
    If FEdtLV.FAutoSelect And (Hits = 1) Then
    Begin
            //today edt.text := lv.Selected.caption;
      FEdtLV.GenGoToNextControl(EdtSpecSubSpec);
            //today lv.visible := false;
    End;
    Testmsg('5- main end  sel' + EdtSpecSubSpec.Seltext);
  End;
  Testmsg('  ');
End;

Procedure TfrmCapMain.edtProcEventKeyUp(Sender: Tobject; Var Key: Word;  Shift: TShiftState);
Var
  Txt, Fulltext: String;
  Hits: Integer;
  searchinglist: Boolean;
Begin
  Hits := 0;
  FEdtLV.SelectByArrow := True;
  Testmsg('1- main start kup- ' + EdtProcEvent.Text + ' sel:' + EdtProcEvent.Seltext);
  If ((Key = 38) Or (Key = 40)) Then
  Begin
    EdtProcEvent.SelectAll;
    Exit;
  End;
  If (Key = 37) Or (Key = 39) Then
    Exit;

  Txt := EdtProcEvent.Text;
  Fulltext := '';
  If Key = 8 Then
  Begin
    Txt := Copy(Txt, 1, Length(Txt) - 1);
    Testmsg('1-bksp ' + Txt);
  End;

  If ((Key > 31) And (Key < 256)) Or (Key = 8) Then
  Begin
    If (EdtProcEvent.Seltext <> '') Then
    Begin
      Txt := Copy(EdtProcEvent.Text, 1, Pos(EdtProcEvent.Seltext, EdtProcEvent.Text) - 1);
    End;
    FEdtLV.SelectByArrow := False;
    searchinglist := True;
    While searchinglist Do
    Begin
      Hits := FEdtLV.GenKeyUp(EdtProcEvent, Txt, Fulltext, LvProcEvent, False); //key = 8);
      If (Hits = 0) Then
      Begin
        Txt := Copy(Txt, 1, Length(Txt) - 1);
        If Length(Txt) = 0 Then
        Begin
          Fulltext := '';
          LvProcEvent.Selected := Nil;
          Break;
        End
        Else
          Continue;
      End;
      searchinglist := False;
    End;
    EdtProcEvent.Text := Fulltext;
    EdtProcEvent.SELSTART := Length(Txt);
    EdtProcEvent.SelLength := 999;
    If FEdtLV.FAutoSelect And (Hits = 1) Then
    Begin
            //today edt.text := lv.Selected.caption;
      FEdtLV.GenGoToNextControl(EdtProcEvent);
            //today lv.visible := false;
    End;
    Testmsg('5- main end  sel' + EdtProcEvent.Seltext);
  End;
  Testmsg('  ');
End;

Procedure TfrmCapMain.RefreshIndexLists;
Var
  t: Tstringlist;
Begin
  //p117 (Jemmy in 113 found a problem.)) We need to assure a connection before calling RPC.
  if not xbrokerx.Connected then  exit;  

  RefreshIndexType(FClass);
  LvProcEvent.Visible := False;
  LvSpecSubSpec.Visible := False;
  t := Tstringlist.Create;
  Try
    MagLvUtils1.ListView := LvSpecSubSpec;
    iDModObj.GetMagDBBroker1.RPIndexGetSpecSubSpec(t, FClass, ''); //cbIndexProcEvent.items);
    If (t.Count > 0) Then
      MagLvUtils1.LoadListFromStrings(t, False);
    LvSpecSubSpec.Selected := Nil;
    EdtSpecSubSpec.Text := '';
    t.Clear;
    MagLvUtils1.ListView := LvProcEvent;
    iDModObj.GetMagDBBroker1.RPIndexGetEvent(t, FClass, ''); //cbIndexProcEvent.items);
    If (t.Count > 0) Then
      MagLvUtils1.LoadListFromStrings(t, False);
    LvProcEvent.Selected := Nil;
    EdtProcEvent.Text := '';
  Finally
    t.Free;
  End;

End;

Procedure TfrmCapMain.lvTypeSelectItem(Sender: Tobject; Item: TListItem;  Selected: Boolean);
Begin
  If Selected And FEdtLV.SelectByArrow Then
  Begin
    EdtType.Text := Item.caption;
    Testmsg(Magbooltostr(FEdtLV.SelectByArrow));
  End;
End;

Procedure TfrmCapMain.lvSpecSubSpecSelectItem(Sender: Tobject;  Item: TListItem; Selected: Boolean);
Begin
  If Selected And FEdtLV.SelectByArrow Then
    EdtSpecSubSpec.Text := Item.caption;
End;

Procedure TfrmCapMain.lvProcEventSelectItem(Sender: Tobject;  Item: TListItem; Selected: Boolean);
Begin
  If Selected And FEdtLV.SelectByArrow Then
    EdtProcEvent.Text := Item.caption;
End;

Procedure TfrmCapMain.edtTypeClick(Sender: Tobject);
Begin
  LvProcEvent.Visible := False;
  LvSpecSubSpec.Visible := False;
  EdtType.SelectAll;
  If Not FALOType Then
    LvType.Visible := Not LvType.Visible
  Else
    FALOType := False;

  (* p129
  {/p122t2 dmmn 9/7 - change the parent so that the listview can stay on top while
  visible if annotation is visible /}
  if LvType.Visible then
  begin
    if fCapAnnot.visible then
    begin
      fCapAnnot.Parent := imagepanel;
      fCapAnnot.Align := alClient;
    end;
  end
  else
  begin
    if fCapAnnot.Visible then
    begin
      fCapAnnot.parent := nil;
      fCapAnnot.align := alNone;
      ResizeAnnotOverlay;
    end;
  end;
  *)

End;

Procedure TfrmCapMain.edtSpecSubSpecClick(Sender: Tobject);
Begin
  LvType.Visible := False;
  LvProcEvent.Visible := False;
  EdtSpecSubSpec.SelectAll;
  If Not FALOSpecSubSpec Then
    LvSpecSubSpec.Visible := Not LvSpecSubSpec.Visible
  Else
    FALOSpecSubSpec := False;

  (* p129
  {/p122t2 dmmn 9/7 - change the parent so that the listview can stay on top while
  visible if annotation is visible /}
  if LvSpecSubSpec.Visible then
  begin
    if fCapAnnot.visible then
    begin
      fCapAnnot.Parent := imagepanel;
      fCapAnnot.Align := alClient;
    end;
  end
  else
  begin
    if fCapAnnot.Visible then
    begin
      fCapAnnot.parent := nil;
      fCapAnnot.align := alNone;
      ResizeAnnotOverlay;
    end;
  end;
  *)

End;

Procedure TfrmCapMain.edtProcEventClick(Sender: Tobject);
Begin
  LvType.Visible := False;
  LvSpecSubSpec.Visible := False;
  EdtProcEvent.SelectAll;
  If Not FALOProcEvent Then
    LvProcEvent.Visible := Not LvProcEvent.Visible
  Else
    FALOProcEvent := False;

  (* p129
  {/p122t2 dmmn 9/7 - change the parent so that the listview can stay on top while
  visible if annotation is visible /}
  if LvProcEvent.Visible then
  begin
    if fCapAnnot.visible then
    begin
      fCapAnnot.Parent := imagepanel;
      fCapAnnot.Align := alClient;
    end;
  end
  else
  begin
    if fCapAnnot.Visible then
    begin
      fCapAnnot.parent := nil;
      fCapAnnot.align := alNone;
      ResizeAnnotOverlay;
    end;
  end;
  *)

End;

Procedure TfrmCapMain.RefreshIndexlists1Click(Sender: Tobject);
Begin
  RefreshIndexLists;
End;

Procedure TfrmCapMain.tbwsOtherClick(Sender: Tobject);
//var x, y: integer;
var Control : Tcontrol;
Begin

control := nil;
//control.Enabled := true;  // force error, see if eurekalog is on.
    // messagedlg('"Other" refers to the settings for the Input Source.' + #13 + 'Changes are made in the Configuration Settings Window' + #13 + 'or the Workstation Configuration Editor.', mtconfirmation, [mbok], 0);
   (*   MagFloatConfig.left := oleft + left - 57;
     MagFloatConfig.top := otop + top + height - clientheight; *)

    (*x := OtherDesc.left + left - 57;
    y := OtherDEsc.Top + OtherDEsc.Height + top + height - clientheight;

    messagedlgpos('"Other" refers to the settings for the Input Source.' + #13 + 'Changes are made in the Configuration Settings Window' + #13 + 'or the Workstation Configuration Editor.', mtconfirmation, [mbok], 0,x,y);
    *)

 DisplayConfigValues(FrmCapConfig.GOther, Otherdesc.Left, Otherdesc.Top + Otherdesc.Height, 'Other:');

End;

(* out in p129   maybe later.
Procedure TfrmCapMain.OverlayPatInfo;
Var
  Rect: Trect;
  S1, S2, S3: String;
Begin
  Rect.Left := 0;
  Rect.Top := 0;
  Rect.Right := imgOverlay.Width;
  Rect.Bottom := imgOverlay.Height;
  imgOverlay.Canvas.Font.Color := clRed;
  imgOverlay.Canvas.Font.Style := [Fsbold];
  S1 := iDModObj.GetMagPat1.M_NameDisplay;
  imgOverlay.Canvas.TextRect(Rect, 10, 10, S1);
  S2 := iDModObj.GetMagPat1.M_SSNdisplay + '  ' + iDModObj.GetMagPat1.M_DOBdisplay;
  imgOverlay.Canvas.Textout(10, 30, S2);
  S3 := iDModObj.GetMagPat1.M_Age + '  ' + iDModObj.GetMagPat1.M_Sex;
  imgOverlay.Canvas.Textout(10, 50, S3);

  lbOverLay.Visible := True;
  lbOverLay.caption := S1 + #13 + S2 + #13 + S3;

End;

*)
Procedure TfrmCapMain.lvImport1Enter(Sender: Tobject);
//var li : Tlistitem;
Begin

    // winmsg('s', 'Entering Import listview, selcount = ' + inttostr(lvImport1.selcount));
     //if lvImport1.SelCount = 0 then
     //  begin
     //  li := lvimport1.Items[0];
       // get access violation here li.Selected := true;
     //  end;
End;

Procedure TfrmCapMain.AppOnHint(Sender: Tobject);
Begin
    // This works fine, and is immediate, doesn't have the wait that the regular
    //   hint has.
    //pmsg.Caption := (GetLongHint(application.hint));

    // Also FYI
    //      Application.HintPause;
    //      Application.HintHidePause;
    //      Application.HintShortPause;
    //      Application.Hint;
End;

Procedure TfrmCapMain.tlbrbtnPageFirstClick(Sender: Tobject);
Begin
  GoToPage(1);
End;

Procedure TfrmCapMain.tlbrbtnPagePrevClick(Sender: Tobject);
Begin
  GoToPage(mg1.Page - 1);
End;

Procedure TfrmCapMain.tlbrbtnPageNextClick(Sender: Tobject);
Begin
  GoToPage(mg1.Page + 1);
End;

Procedure TfrmCapMain.tlbrbtnPageLastClick(Sender: Tobject);
Begin
  GoToPage(mg1.PageCount);
End;

Procedure TfrmCapMain.TbePageEnter(Sender: Tobject);
Begin
  TbePage.SELSTART := 0;
  TbePage.SelLength := 9;
End;

Procedure TfrmCapMain.TbePageClick(Sender: Tobject);
Begin
  TbePage.SELSTART := 0;
  TbePage.SelLength := 9;
End;

Procedure TfrmCapMain.TbePageKeyDown(Sender: Tobject; Var Key: Word;  Shift: TShiftState);
var pgct : integer;
Begin
//pgct := Gear 1.PageCount;
pgct :=  mg1.PageCount;
    { 33 is Page UP,   34 is Page Down }
  Case Key Of
    33:
      If Ssctrl In Shift Then
         GoToPage(1)
       Else
        prevpage;
    34:
      If Ssctrl In Shift Then
        GoToPage(mg1.PageCount)
      Else
        nextpage;
  End;
End;

Procedure TfrmCapMain.TbePageKeyUp(Sender: Tobject; Var Key: Word; Shift: TShiftState);
Var
  Pg: Integer;
Begin
    { 33 is Page UP,   34 is Page Down }
  If ((Key = 33) Or (Key = 34)) Then
    Exit;
  Try
    If (Strtoint(TbePage.Text + '0') > mg1.PageCount) Then
    Begin
      GoToPage(Strtoint(TbePage.Text));
      Exit;
    End;

    If (Length(TbePage.Text)) > (Length(Inttostr(mg1.PageCount))) Then
    Begin
      InvalidPage;
      Exit;
    End;
    If (Length(TbePage.Text)) = (Length(Inttostr(mg1.PageCount))) Then
    Begin
      Pg := Strtoint(TbePage.Text);
      If Pg > mg1.PageCount Then
      Begin
        InvalidPage;
        Exit;
      End;
      GoToPage(Pg);
      TbePage.SELSTART := 0;
      TbePage.SelLength := Length(TbePage.Text);
    End;
  Except
    InvalidPage;
  End; { try}
End;

Procedure TfrmCapMain.tlbrbtnFitWidthClick(Sender: Tobject);
Begin
  GearFitToWidth;
End;

Procedure TfrmCapMain.GearFitToWidth;
Begin
//  Resetcontrols;

  mg1.fittowidth;
  mg1.UpdatePageView;
  { p129 Use zoom value  of the control}
  SetZoomLevel(mg1.GetZoomValue, false);

    (* p129
  MagAspectRatio(IG_ASPECT_DEFAULT;
  Gear 1.SelectEvent := 0;
  Gear 1.FitMethod := IG_DISPLAY_FIT_TO_WIDTH;
    //Gear 1.AspectRatio := IG_ASPECT_NONE;
  SetZoomLevel(100);
  *)
End;

Procedure TfrmCapMain.tlbrbtnFitHeightClick(Sender: Tobject);
Begin
  GearFitToHeight;

End;

Procedure TfrmCapMain.GearFitToHeight;
Begin

//  Resetcontrols;
  mg1.FitToHeight;
  mg1.UpdatePageView;
  { p129 Use zoom value  of the control}
  SetZoomLevel(mg1.GetZoomValue, false);

  (* p129
  Gear 1.AspectRatio := IG_ASPECT_DEFAULT;
  Gear 1.SelectEvent := 0;
  Gear 1.FitMethod := IG_DISPLAY_FIT_TO_HEIGHT;
    //Gear 1.AspectRatio := IG_ASPECT_NONE;
  SetZoomLevel(100);
  *)
End;

Procedure TfrmCapMain.tlbrbtnMagnifyClick(Sender: Tobject);
Begin
  GearMouseMagnify;
End;

Procedure TfrmCapMain.GearMousePan;
Begin
  ResetControls;
//p129 Gear 1.handpanning := True;
  mg1.MousePan;
End;

Procedure TfrmCapMain.GearMouseMagnify;
Begin
  Resetcontrols;
(*p129
  Gear 1.Guiwindow := GUIMAG;
  Gear 1.GUIHeight := 300;
  Gear 1.GUIWIDTH := 600;
  Gear 1.GUIXPOS := 100;

  Gear 1.GUIYPOS := 100;

  Gear 1.MagnifyWindow := 1;
*)

mg1.MouseMagnify;

    //Gear 1.Cursor := crUparrow;
End;

Procedure TfrmCapMain.GearMouseZoomSelect;
Begin
  ResetControls;
    {  Gear 1.SelectEvent := 2;
     change to stop the automatic Zooming when Select Rectangle
      this way, we control it by setting ZoomValue.  Hence ZoomValue
      should always have a correct (as close as we can get) value.}

(*p129
  Gear 1.AspectRatio := IG_ASPECT_NONE;
  Gear 1.SelectEvent := 1;
  *)

mg1.MouseZoomRect;
    //Gear 1.Cursor := crCross;
End;

Procedure TfrmCapMain.GearMousePointer;
Begin
(*p129
  Gear 1.SelectEvent := 0;
  Gear 1.magnifywindow := 0;
  Gear 1.HandPanning := False;
  Gear 1.Cursor := crDefault;
*)
  mg1.MouseReSet;

End;

Procedure TfrmCapMain.SetPageControls;
Var
  pgct: Integer;
Begin
  Try
(*p129
    If Gear 1.higear = 0 Then
      pgct := 0 //p8t44 vehu
    Else
      pgct := Gear 1.PageCount; //p8t44 vehu
*)

    If not mg1.isvalidimage Then
      pgct := 0 //p8t44 vehu
    Else
      pgct := mg1.PageCount; //p8t44 vehu

  Except
    pgct := 1;
  End;
  Try
    TblbPageCount.caption := ' of ' + Inttostr(pgct);

    tlbrbtnPageFirst.Enabled := False;
    tlbrbtnPageNext.Enabled := False;
    tlbrbtnPagePrev.Enabled := False;
    tlbrbtnPageLast.Enabled := False;
    TbePage.Enabled := False;
    If (pgct = 0) Then
    Begin
      TbePage.Text := '0';
            //GoTopage(1);
    End
    Else
      If (pgct = 1) Then
      Begin
        TbePage.Text := '1';
        GoToPage(1);
      End
      Else
      Begin
        tlbrbtnPageFirst.Enabled := True;
        tlbrbtnPageNext.Enabled := True;
        tlbrbtnPagePrev.Enabled := True;
        tlbrbtnPageLast.Enabled := True;
        TbePage.Enabled := True;
        GoToPage(1);
      End;
  Except
    On e: Exception Do
      Messagedlg('exception in SetPageControls', Mtconfirmation, [Mbok], 0);
  End;
  Application.Processmessages;
End;

Procedure TfrmCapMain.GoToPage(i: Integer);
Var
  pgct: Integer;
Begin
  Try
   //p129 pgct := Gear 1.PageCount
   pgct := mg1.PageCount;
  Except
    pgct := 1;
  End;
  TblbPageCount.caption := ' of ' + Inttostr(pgct);
  If FLockScrollBarsAlways Then
    ZoomScrollSave;
  If pgct = 1 Then
    Exit;
  WinMsg('s', 'Image.Pagecount ' + Inttostr(pgct) + '.  going to page ' + Inttostr(i));
  Try
    If ((i < 1) Or (i > pgct)) Then
    Begin
      invalidpage;
      Exit;
    End;

    tlbrbtnPageFirst.Enabled := (i > 1);
    tlbrbtnPageprev.Enabled := (i > 1);

    tlbrbtnPagenext.Enabled := (i < pgct);
    tlbrbtnPagelast.Enabled := (i < pgct);

    Try
      mg1.Page := i;
     //p129 Gear 1.Page := i;
    Except
      WinMsg('', 'Exception turning page.');
    End;
    If ErrorInGear(mg1, 'Turning page', 'ImageGear: Turning page') Then                                     {in GotoPage}
      Messagedlg('Error ImageGear:, Turning Page.', Mtconfirmation, [Mbok], 0);
  MagResetPanWindow;
(*p129
    If Gear 1.PanWindow Then
    Begin
      Gear 1.PanWindow := False;
      Gear 1.Redraw := True;
      Gear 1.PanWindow := True;
    End;
*)
    FAlreadyTurnedPage := True;
    TbePage.SELSTART := 0;
    TbePage.SelLength := Length(TbePage.Text);
    TbePage.Text := Inttostr(i);
    TblbPageCount.caption := 'of ' + Inttostr(pgct);
    ZoomScrollApply;
  mg1.UpdatePageView;
  Except
    InvalidPage;
  End;
End;

procedure TfrmCapMain.MagResetPanWindow;
begin
    if mg1.PanWindow then
    begin
      mg1.PanWindow := false;
      mg1.ReDrawImage ;
      mg1.PanWindow := true;
    end;
end;

procedure TfrmCapMain.CCOWIconMenuUpdate(ccowstate : integer);
begin
       {p129t13 called from the SubscriberNews Event  CCOWStates recieved
          this way are 7010 + CCOW State of the CCOWmanager.}
      ImgCCOWLink.Visible := CCOWState = 7011;
      ImgCCOWchanging.Visible := CCOWState = 7012;
      ImgCCOWbroken.Visible := CCOWState = 7013;
      MnuContext.Visible := CCOWState > 7010;
      MnuShowContext.Enabled := CCOWState = 7011;
      MnuSuspendContext.Enabled := CCOWState = 7011;
      MnuResumeGetContext.Enabled := CCOWState = 7013;
      MnuResumeSetContext.Enabled := CCOWState = 7013;

end;

procedure TfrmCapMain.ChangeToCCOWPatient;
var CCOWPatDFN: string;
  isicn : boolean;
  isProdAccount : boolean;
  suffix : string;
begin
  isicn := false;
//  isProdAccount :=  idmodobj.GetMagPat1.M_ProdAcct;
isProdAccount := FisProdAccount;
  Suffix := '';
  If (Not IsProdAccount) Then   Suffix := '_test';
       CCOWPatDFN := IdmodObj.GetCCOWmanager.GetContextValue('patient.id.mrn.dfn_' + PrimarySiteStationNumber + Suffix);

  ChangeToPatient(CCOWPatDFN);
end;

procedure TfrmCapMain.MagSubscriber1SubscriberUpdate(NewsObj: TMagNewsObject);
begin
 winmsg('s','SUBSCRIBER UPDATE:  NewsObj.Newscode='+inttostr(NewsObj.Newscode));
  case NewsObj.Newscode of
    mpubAnnotWinShow :      // 6001;
      begin
        //
      end;
    mpubAnnotWinHide :    // 6002;
      begin
        //
         DisableComponentsDuringAnnot(false);
      end;

    {p129  New Codes for CCOW events
      CCOW manager calls Capture via GMagPublish when event occurs.
       this will enable Capture to proceed as before (mostly).
       When patient Change occurs,  Capture will call same ChangeToPat as Before..
       When Captuer Changes patients,  it will send CCOW msg.
       If Capture gets back certain messages.  it will enable/Disable menu items, and
       CCOW Bitmaps to be appropriate.}

    7000..7999 :
        begin
          CCOWIconMenuUpdate(NewsObj.Newscode);
          SetCapRunMode(magrmCCOW);  // this function will update the descriptive run mode panel
          case NewsObj.Newscode of
          mpubCCOWPatientChange : winmsg('s','NewsCode : ' + inttostr(NewsObj.Newscode) + ' PatientChange.'); //=7001
          mpubCCOWStateNoCCOW  : winmsg('s','NewsCode : ' + inttostr(NewsObj.Newscode) + ' CCOWState NoCCOW.');  //= 7010 ;
          mpubCCOWStateInContext  :
               begin
               winmsg('s','NewsCode : ' + inttostr(NewsObj.Newscode) + ' CCOWState InContext.'); //= 7011 ;
               ChangeToCCOWPatient;
               end;
          mpubCCOWStateChanging  : winmsg('s','NewsCode : ' + inttostr(NewsObj.Newscode) + ' CCOWState Changing.'); //= 7012 ;
          mpubCCOWStateBroken  : winmsg('s','NewsCode : ' + inttostr(NewsObj.Newscode) + ' CCOWState Broken.'); //= 7013 ;
          end;
        end;
 end;
end;

(*
procedure TfrmCapMain.MagCapSubscriberUpdate(NewsObj: TMagNewsObject);
begin
 case NewsObj.Newscode of
    mpubAnnotWinShow :      // 6001;
      begin
        //
      end;
  mpubAnnotWinHide :    // 6002;
      begin
        //
        showmessage('Annot Window Hide');
      end;

 end;

end;
    *)
Procedure TfrmCapMain.Prevpage;
Begin
(*p129
If (Gear 1.Page > 1) Then
    GoToPage(Gear 1.Page - 1);*)

if mg1.page > 1 then GoToPage(mg1.Page - 1)    ;

End;

Procedure TfrmCapMain.Nextpage;
Begin
(* p129 If (Gear 1.Page < Gear 1.PageCount) Then
    GoToPage(Gear 1.Page + 1);*)
if mg1.page < mg1.pagecount then GoToPage(mg1.Page + 1) ;
End;

Procedure TfrmCapMain.InvalidPage;
Var
  Pg: Integer;
Begin
  Try
//p129    Pg := Gear 1.Page;
  pg := mg1.page;
  Except
    Pg := 1;
  End;
  Messagedlg('Invalid Page Number ' + TbePage.Text, Mtconfirmation, [Mbok], 0);
  TbePage.Text := Inttostr(Pg);

End;

Procedure TfrmCapMain.Resetcontrols;
Begin
(*  Gear 1.MagnifyWindow := 0;
  Gear 1.SelectEvent := 0;
  Gear 1.Cursor := crDefault;
  *)
  {129t10  Note: if next line is out, then access violation}
  mg1.PanWindow  := false;
  mg1.MouseReSet;
End;

Procedure TfrmCapMain.tlbrbtnActualClick(Sender: Tobject);
Begin
  GearFitToActualSize;
End;

Procedure TfrmCapMain.GearFitToActualSize;
Begin
Resetcontrols;
  mg1.fit1to1;
  mg1.UpdatePageView;
  { p129 Use zoom value  of the control}
  SetZoomLevel(mg1.GetZoomValue, false);


  (* p129
  Gear 1.AspectRatio := IG_ASPECT_DEFAULT;
  Gear 1.SelectEvent := 0;
  Gear 1.FitMethod := IG_DISPLAY_FIT_1_TO_1;
    //Gear 1.AspectRatio := IG_ASPECT_NONE;
  SetZoomLevel(100);
  *)
End;

Procedure TfrmCapMain.Autosettings1Click(Sender: Tobject);
Begin
  OptionWindowSetSettings;
  FrmCapSettings.PgctrlSettings.ActivePage := FrmCapSettings.PgctrlSettings.Pages[0];
  FrmCapSettings.Showmodal;
  OptionWindowGetSettings;
End;

Procedure TfrmCapMain.OptionWindowSetSettings;
Var
  s: String;
Begin
  With FrmCapSettings Do
  Begin
    SetBroker(iDModObj.GetMagDBBroker1);
    chkFitToWin.Checked := FLockScrollBarsFitToWin;
    chkSaveOnCapture.Checked := FLockScrollBarsAlways;
    chkUseStatic.Checked := FLockScrollBarsStatic;
    chkPositional.Checked := FLockScrollBarsPositional;

    FCurHoriz :=  mg1.GetScrollInfo.H_Pos  ;//Gear 1.GetScrollPos(0);
    FCurVert := mg1.GetScrollInfo.V_Pos ;//Gear 1.GetScrollPos(1);
    FCurZoom := mg1.GetZoomValue  ;//Gear 1.ZoomLevel;

    Case FLockScrollBarPos Of
      0: chkPosC.Checked := True; // default to Center;
      1: chkPosTL.Checked := True;
      2: chkPosTR.Checked := True;
      3: chkPosBL.Checked := True;
      4: chkPosBR.Checked := True;
      5: chkPosC.Checked := True;
    End;

    chkAutoTab.Checked := FEdtLV.FAutoTab;
    chkAutoSelect.Checked := FEdtLV.FAutoSelect;
    chkAutoOpen.Checked := FEdtLV.FShowListOnEnter;

        //p8t41
    chkAutoDeskew.Checked := FAutoDeskew;
    chkAutoDeSpeckle.Checked := FAutoDeSpeckle;
    chkAutoPreviewNote.Checked := FAutoPreviewNote;

        // import TabSheet tbshImport
    cbAddDirONSelect.Checked := FAddDirOnSelect;
    Pnloptlstboximport.Items.Assign(lstboximport.Items);
    Pnloptlstboximport.ScrollWidth := GetPixelLengthLongestEntry(lstBoxImport.Items, lstboxImport.Canvas) + 60;

    s := GetIniEntry('Import Options', 'DefaultImportDir');
    If s[Length(s)] <> '\' Then
      s := s + '\';
    Lbdefault.caption := s;

        {Default Workstation Visit Location for New Notes.}
    FrmCapSettings.SetWrksVisitLocation(MSetWrks1);
    FrmCapSettings.SetUserTIUDefaults(FuPrefCapTiu);

  End;
End;

procedure TfrmCapMain.OptionsClick(Sender: TObject);
begin
mnuCombineTIFscans.Enabled := false;
mnuCombinePDFscans.Enabled := false;
mnuCombineTIFscans.Checked := false;
mnuCombinePDFscans.Checked := false;


if (not CapX.mSourceID = mcSrcTwain) and (not CapX.mSourceID = mcSrcScanDoc) then Exit;

if CapX.m140PDFConvert then
  begin
    mnuCombinePDFscans.Enabled := true;
    if CapX.m140CombineScans then  mnuCombinePDFscans.Checked := true;
    exit;
  end;

  if CapX.mIGScanFormat = mag_IG_FORMAT_TIF then
  begin
    mnuCombineTIFscans.Enabled := true;
    if CapX.m140CombineScans then mnuCombineTIFscans.Checked := true;
    exit;
  end;


end;

Procedure TfrmCapMain.OptionWindowGetSettings;
Var
  s: String;
Begin
  With FrmCapSettings Do
  Begin
    FEdtLV.FAutoTab := chkAutoTab.Checked;
    FEdtLV.FAutoSelect := chkAutoSelect.Checked;
    FEdtLV.FShowListOnEnter := chkAutoOpen.Checked;

    FLockScrollBarsFitToWin := chkFitToWin.Checked;
    FLockScrollBarsAlways := chkSaveOnCapture.Checked;
    FLockScrollBarsStatic := chkUseStatic.Checked;
    FLockScrollBarsPositional := chkPositional.Checked;

        //if FLockScrollBarsFitToWin then GearFitToWin;

    If FLockScrollBarsStatic Then
    Begin
      FGearScrollHoriz := Strtoint(LblHorizD.caption);
      FGearScrollVert := Strtoint(LblVertD.caption);
      FGearZoomValueStatic := Strtoint(LblZoomD.caption);
            //SaveScrollPositions;
    End;
    FLockScrollBarPos := 0; //
    If FLockScrollBarsPositional Then
    Begin
      FGearZoomValuePositional := Strtoint(LblZoomposD.caption);
      If chkPosTL.Checked Then
        FLockScrollBarPos := 1;
      If chkPosTR.Checked Then
        FLockScrollBarPos := 2;
      If chkPosBL.Checked Then
        FLockScrollBarPos := 3;
      If chkPosBR.Checked Then
        FLockScrollBarPos := 4;
      If chkPosC.Checked Then
        FLockScrollBarPos := 5;
    End;
        //p8t41
    FAutoDeskew := chkAutoDeskew.Checked;
    FAutoDeSpeckle := chkAutoDeSpeckle.Checked;
    FAutoPreviewNote := chkAutoPreviewNote.Checked;

        // import TabSheet tbshImport
    FAddDirOnSelect := cbAddDirONSelect.Checked;
    lstboximport.Items.Assign(Pnloptlstboximport.Items);
    s := GetIniEntry('Import Options', 'DefaultImportDir');
    //TESTING TEST TEST
    //showmessage('s=' + s + '     s[length(s)]='+ s[length(s)]); 
    If s[Length(s)] <> '\' Then
      s := s + '\';

    If s <> FrmCapSettings.Lbdefault.caption Then
      SetIniEntry('Import Options', 'DefaultImportDir', FrmCapSettings.Lbdefault.caption);
    If Pnloptlstboximport.ItemIndex > -1 Then
      s := Pnloptlstboximport.Items[Pnloptlstboximport.ItemIndex];

    If LbImport.caption <> s Then
      OpenAllFilesX(s);

    If (FWrksVisitLocDA <> '') And (FWrksVisitLocName <> '') Then
      MSetWrks1.VLoc := FWrksVisitLocDA + '~' + FWrksVisitLocName
    Else
      MSetWrks1.VLoc := '';
    If (FMyVisitLocDA <> '') And (FMyVisitLocName <> '') Then
      FuPrefCapTIU.DefaultLoc := FMyVisitLocDA + '~' + FMyVisitLocName
    Else
      FuPrefCapTIU.DefaultLoc := '';
    FuPrefCapTIU.UseDefaultLoc := RbUseDefaults.Checked;
  End;
End;

Procedure TfrmCapMain.ZoomScrollInitialSettings;
Begin
    // this will be called from statup, and settings either hard
    // coded for now, or from INI file will be initialized.
    { DONE -o129 : This zoom 100 will need to be checked.  It is differnet now.
                    it works in V16,  and this will make FitToWin NOT EQUAL to Zoom 100}
  FGearZoomValueStatic := 100;
  FGearZoomValuePositional := 100;
  FGearScrollHoriz := 0;
  FGearScrollVert := 0;

    // fEdtLv.FAutoTab := True; //frmCapSettings.chkAutoTab.checked;
    // Fedtlv.FAutoSelect := false; //frmCapSettings.chkAutoSelect.checked;
    // fEdtLv.FShowListOnEnter :=  false; //frmCapSettings.chkAutoOpen.checked;

  FLockScrollBarsFitToWin := True; //frmCapSettings.chkFitToWin.checked;
  FLockScrollBarsAlways := False; // frmCapSettings.chkSaveOnCapture.Checked;
  FLockScrollBarsStatic := False; // frmCapSettings.chkUseStatic.checked;
  FLockScrollBarsPositional := False; // frmCapSettings.chkPositional.checked;

    //if FLockScrollBarsFitToWin then GearFitToWin;

  (*  if FLockScrollBarsStatic then
    begin
      FGearScrollHoriz := strtoint(frmCapSettings.lblHorizD.caption);
      FGearScrollVert := strtoint(frmCapSettings.lblVertD.caption);
      FGearZoomValueStatic := strtoint(frmCapSettings.lblZoomD.caption);
      //SaveScrollPositions;
    end;
    *)
  FLockScrollBarPos := 0; //
    (*  if FLockScrollBarsPositional  then
        begin
      if frmCapSettings.chkPosTL.checked then FLockScrollBarPos := 1;
      if frmCapSettings.chkPosTR.checked then FLockScrollBarPos := 2;
      if frmCapSettings.chkPosBL.checked then FLockScrollBarPos := 3;
      if frmCapSettings.chkPosBR.checked then FLockScrollBarPos := 4;
      if frmCapSettings.chkPosC.Checked then FLockScrollBarPos := 5;
         end;
         *)
End;

Procedure TfrmCapMain.LockedFields1Click(Sender: Tobject);
Begin
  FrmDoNotClear.Showmodal;
End;

Procedure TfrmCapMain.ZoomScrollBarsettings1Click(Sender: Tobject);
Begin
  OptionWindowSetSettings;
  FrmCapSettings.PgctrlSettings.ActivePage := FrmCapSettings.PgctrlSettings.Pages[1];
  FrmCapSettings.Showmodal;
  OptionWindowGetSettings;
End;

Procedure TfrmCapMain.ShowTestMessages1Click(Sender: Tobject);
Begin
  ShowTestMessages1.Checked := Not ShowTestMessages1.Checked;
  FCapClinMgr.FtestmessagesOn := ShowTestMessages1.Checked;
End;

procedure TfrmCapMain.sLEEP301Click(Sender: TObject);
begin
sleep(30000)           ;
winmsg('','after sleep 30 secs');
end;

Procedure TfrmCapMain.GetUserPreferences1Click(Sender: Tobject);
Begin
  GetUserCapPref;
End;

Procedure TfrmCapMain.SavePreferencesNow1Click(Sender: Tobject);
Begin
  SetUserCapPref;
End;

Procedure TfrmCapMain.SavePreferencesOnExit2Click(Sender: Tobject);
Begin
  SavePreferencesOnExit2.Checked := Not SavePreferencesOnExit2.Checked;
  FSaveUserSettingsOnExit := SavePreferencesOnExit2.Checked;
End;

Procedure TfrmCapMain.cbALLPagesClick(Sender: Tobject);
Begin
  AllPagesChecked(cbAllPages.Checked);    {cbAllPagesClick}
//all/  If FrmCapConfig.cb TwainALLPages.Checked <> cb ALLPages.Checked Then
//all/    FrmCapConfig.cb TwainALLPages.Checked := cb ALLPages.Checked;
//all/   CapX.mMultipage := cb ALLPages.Checked;
End;

Procedure TfrmCapMain.mnuSaveConfigurationClick(Sender: Tobject);
Var
  Config: String;
Begin
  Config := FLastSelectedConfig;
  If FrmCapSaveConfig.Execute(FrmConfigList.Fconfiglist, Config) {//WPR CONFIG} Then
  Begin
    FrmConfigList.SaveNewConfig(Config); //WPR CONFIG
    FLastSelectedConfig := Config;
  End;
End;

Procedure TfrmCapMain.N0scrollbar1Click(Sender: Tobject);
Begin
  Frmcapmain.SbxEditFields.VertScrollBar.Position := 0;
End;

Procedure TfrmCapMain.ConfigurationSettings1Click(Sender: Tobject);
Begin
OpenConfigurationSettingsWindow;
end;

procedure TfrmCapMain.OpenConfigurationSettingsWindow;
begin
    {frmCapConfig.showmodal;}
  FrmCapConfig.FormStyle := fsStayOnTop;
  FrmCapConfig.Show;
  FrmCapConfig.BringToFront;
//  FrmCapConfig.ShowModal; //p122 dmmn 8/16 - shouln't open up and let it go plus show above the annotation panel
End;

Procedure TfrmCapMain.Source1Click(Sender: Tobject);
Begin
  SettingsEditSource;
End;

procedure TfrmCapMain.ForceErrortestEurekaLog1Click(Sender: TObject);
var  myformAbout: TfrmAbout;
    w : integer;
    t : Tstrings;
begin
w := myformAbout.width;  {form is not created, this should be error}
try
myformabout.SetFocus;
except
showmessage(inttostr(w) + ' = frmAbout.width  + frmAbout.setfocus - > to form not created');
end;
//try
w := t.count;
//except
//showmessage(' = t.count -> Tstrings not created');
//end;


end;

Procedure TfrmCapMain.Format1Click(Sender: Tobject);
Begin
  SettingsEditFormat;
End;

Procedure TfrmCapMain.Association1Click(Sender: Tobject);
Begin
  SettingsEditAssociation;
End;

Procedure TfrmCapMain.GroupSingle2Click(Sender: Tobject);
Begin
  SettingsEditSavingAs;
End;

Procedure TfrmCapMain.GroupSingle1Click(Sender: Tobject);
Begin
  SettingsEditMode;
End;

Procedure TfrmCapMain.left1Click(Sender: Tobject);
Begin
  tlbarImage.Align := alLeft;
End;

Procedure TfrmCapMain.top1Click(Sender: Tobject);
Begin
  tlbarImage.Align := altop;
End;

Procedure TfrmCapMain.bottom1Click(Sender: Tobject);
Begin
  tlbarImage.Align := alBottom;
End;

Procedure TfrmCapMain.right1Click(Sender: Tobject);
Begin
  tlbarImage.Align := alright;
End;

Procedure TfrmCapMain.mnuHoldValueClick(Sender: Tobject);
Begin
    //WPR HOLD
         {   all TmagLabelNoClear fields call the same PopupMenu.
                  TypeCast to get proper control to change.}
  TmagLabelNoClear(mnutoggleHoldValue.PopupComponent).NoClear := Not TmagLabelNoClear(mnutoggleHoldValue.PopupComponent).NoClear;
End;

Procedure TfrmCapMain.mnutoggleHoldValuePopup(Sender: Tobject);
Begin
  mnuHoldValue.Checked := TmagLabelNoClear(mnutoggleHoldValue.PopupComponent).NoClear;
End;

Procedure TfrmCapMain.edtImageDescMouseDown(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Begin
  If Button = Mbright Then
    OpenHoldMenu(x, y, TControl(EdtImageDesc), LbImageDesc);
End;

Procedure TfrmCapMain.OpenProcHoldMenu(x, y: Integer; Source: TControl; magNoClear: TmagLabelNoClear);
Var
  mpt: TPoint;
Begin
  mpt.x := x;
  mpt.y := y;
  mpt := Source.ClientToScreen(mpt);
    //this works fine. // try1.Visible := (magnoclear.Name = 'lbNoteInfo');

  mnuProcHoldValue.PopupComponent := magNoClear;
  mnuProcHoldValue.Popup(mpt.x, mpt.y);
End;

Procedure TfrmCapMain.OpenHoldMenu(x, y: Integer; Source: TControl; magNoClear: TmagLabelNoClear);
Var
  mpt: TPoint;
Begin
  mpt.x := x;
  mpt.y := y;
  mpt := Source.ClientToScreen(mpt);
    {  edtboxes, listboxes... call this, and send their TmagLabelNoClear as param}

  mnutoggleHoldValue.PopupComponent := magNoClear; //WPR HOLD
  mnuToggleHoldValue.Popup(mpt.x, mpt.y);
End;

procedure TfrmCapMain.OpenImageMenu(x, y: Integer);
Var
  mpt: TPoint;
Begin
  mpt.x := x;
  mpt.y := y;
  mpt := mg1.ClientToScreen(mpt);
  PopupImageControls.PopupComponent := mg1;
  PopupImageControls.Popup(mpt.x, mpt.y);
End;
(*
procedure TfrmCapMain.OpenHoldProcMenu(x, y: integer; source: TControl; magNoClear: TMaglabelNoClear);
var
  mpt: Tpoint;
begin
  mpt.x := x; mpt.y := y;
  mpt := source.clienttoscreen(mpt);

  mnuProcHoldValue.PopupComponent := magNoClear;
  mnuProcHoldValue.Popup(mpt.x, mpt.y);
end;
*)

Procedure TfrmCapMain.edtTypeMouseDown(Sender: Tobject;  Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Begin
  If Button = Mbright Then //WPR HOLD
        // the edit boxes don't have popup menus, we open the PopupMenu by simulating
        //  a popup from the associated TmagLabelNoClear label
    OpenHoldMenu(x, y, TControl(EdtType), LbIndexType);
End;

Procedure TfrmCapMain.edtProcDateMouseDown(Sender: Tobject;   Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Begin
    //5/16/2006  /p59    if button = mbright then
    //5/16/2006  /p59    OpenProcHoldMenu(x, y, TControl(edtProcDAte), lbProcDAte);

End;

Procedure TfrmCapMain.edtStudyMouseDown(Sender: Tobject; button: TMouseButton; Shift: TShiftState; x, y: Integer);
Begin
  If Button = Mbright Then
    OpenProcHoldMenu(x, y, TControl(EdtStudy), LbStudy);
End;

Procedure TfrmCapMain.edtNoteInfoMouseDown(Sender: Tobject;  Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Begin
  If Button = Mbright Then
    OpenProcHoldMenu(x, y, TControl(Edtnoteinfo), LbNoteInfo);
End;

Procedure TfrmCapMain.edtSpecSubSpecMouseDown(Sender: Tobject;   Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Begin
  If Button = Mbright Then
    OpenHoldMenu(x, y, TControl(EdtSpecSubSpec), LbIndexSpecSubSpec);
End;

Procedure TfrmCapMain.edtProcEventMouseDown(Sender: Tobject;     Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Begin
  If Button = Mbright Then
    OpenHoldMenu(x, y, TControl(EdtProcEvent), LbIndexProcEvent);
End;

Procedure TfrmCapMain.eDayCaseNoMouseDown(Sender: Tobject;    Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Begin
  If Button = Mbright Then
    OpenProcHoldMenu(x, y, TControl(EDayCaseNo), LbDayCaseNo);
End;

Procedure TfrmCapMain.eAccessionNoMouseDown(Sender: Tobject;   Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Begin
  If Button = Mbright Then
    OpenProcHoldMenu(x, y, TControl(EAccessionNo), LbAccessionNo);
End;

Procedure TfrmCapMain.sbxEditFieldsClick(Sender: Tobject);
Begin
  LvProcEvent.Visible := False;
  LvSpecSubSpec.Visible := False;
  LvType.Visible := False;

  (* p129
  {/p122t2 dmmn 9/7/11 /}
  if fCapAnnot.parent <> nil then
  begin
    fCapAnnot.parent := nil;
    fCapAnnot.Align := alNone;
    ResizeAnnotOverlay;
  end;
  *)
End;

Procedure TfrmCapMain.mnufrmCapMaintablistClick(Sender: Tobject);
Var
  Tl: Tlist;
  i: Integer;
Begin
  Tl := Tlist.Create;
  Frmcapmain.GetTabOrderList(Tl);
  i := Tl.Indexof(EdtProcEvent);
  i := i + 1;
  If i >= Tl.Count Then
    i := 0;
  While i < Tl.Count Do
  Begin
    If TWinControl(Tl[i]).Enabled
      And TWinControl(Tl[i]).Visible
      And TWinControl(Tl[i]).TabStop Then
    Begin
            //showmes sage(TWincontrol(tl[i]).name);
      Try
        TWinControl(Tl[i]).SetFocus;
        Break;
      Except
        On e: Exception Do //
      End;
    End;
    i := i + 1;
  End;
End;

Procedure TfrmCapMain.mnuProcHoldValuePopup(Sender: Tobject);
Begin
  HoldValue1.Checked := TmagLabelNoClear(mnuProcHoldValue.PopupComponent).NoClear;
End;

Procedure TfrmCapMain.HoldValue1Click(Sender: Tobject);
Begin
  HoldValue1.Checked := Not HoldValue1.Checked;
  LinkHoldValues(HoldValue1.Checked);
End;

Procedure TfrmCapMain.LinkHoldValues(hold: Boolean);
Begin
    // called from Popup Menu by different components.  code is conditional on
    //   which component
    // if Date field, and it is ReadOnly then this is a Patient Package report
  If (mnuProcHoldValue.PopupComponent <> LbProcDate) Or
    ((mnuProcHoldValue.PopupComponent = LbProcDate) And (EdtProcDate.ReadOnly)) Then
  Begin
        // if Locking Patient others do not have to be locked.
    If (mnuProcHoldValue.PopupComponent = LbPatName) Then
    Begin
      TmagLabelNoClear(LbPatName).NoClear := hold;
      If (hold) Then
        Exit;
      If Not EdtProcDate.ReadOnly Then
        Exit;
    End;
    TmagLabelNoClear(LbStudy).NoClear := Hold;
    TmagLabelNoClear(LbNoteInfo).NoClear := Hold;
    If EdtProcDate.ReadOnly Then
    Begin
      TmagLabelNoClear(LbProcDate).NoClear := hold;
      If hold {// from other than Patient. then} Then
        TmagLabelNoClear(LbPatName).NoClear := hold;
    End;
    TmagLabelNoClear(LbDayCaseNo).NoClear := hold;
    TmagLabelNoClear(LbAccessionNo).NoClear := hold;
  End
  Else
    If ((mnuProcHoldValue.PopupComponent = LbProcDate) And (Not EdtProcDate.ReadOnly)) Then
      TmagLabelNoClear(LbProcDate).NoClear := hold;
End;

Procedure TfrmCapMain.ShowImageHDIB1Click(Sender: Tobject);
Begin
//p129  Testmsg('Gear 1.ImageHdib: ' + Inttostr(Gear 1.ImageHdib));
End;

Procedure TfrmCapMain.cbOriginKeyDown(Sender: Tobject; Var Key: Word;  Shift: TShiftState);
Begin
  If (Key = VK_Return) Then
    FEdtLV.GenGoToNextControl(cbOrigin);
End;

Procedure TfrmCapMain.OpenDialogImportCanClose(Sender: Tobject;  Var CanClose: Boolean);
Begin
  CanClose := True;
End;

Procedure TfrmCapMain.GearDeSkew;
Var
  i, curPg: Integer;
  DeskewStr : string;
  DeskewPg : integer;
  DeskewFilename: string;
Begin
    {DONE: Save copy of image, to allow a Cancel function for Deskew and Despeckle}
      { if importing, we have an Image file to copy
        if TWAIN Scan, we have to create a tmp image before doing operation.
        before we create the tmp image, we have to ReSet the image.
        THE Reset function could search for a tmp image with .tmp and same name
        if exist, then load it, }
  If isgearClear(mg1) Then
    Exit;
  Application.Processmessages;
  AccusoftPropertiesLog('Before Deskew: GearDeskew');
  {129t10   NOTE:: we didn't use this cMag4VGear control in previous capture Apps.
      For Multipage images we used a Gear99 version of LoadDocument.
      Now we're using LoadPage, due to using cMag4VGear,
      this workaround is not efficient.  but will work for now..}

  curPg := mg1.page;
  FImageChanged := True;            //p122t12 dmmn - look like this was missing
  For i := 1 To  mg1.pagecount do

  Begin
    mg1.page := i;
    mg1.DeSkewImage;

    DeskewPg := mg1.page-1;
    DeskewFilename := mg1.ImageFilename;
    getIGManager.IGFormatsCtrl.savePageToFile(mg1.GetCurrentPage,DeskewFilename,DeskewPg,IG_PAGESAVEMODE_REPLACE,CapX.mIGSaveFormat);
  End;
  If mg1.page <> curPg then
    mg1.page := curPg;
mg1.UpdatePageView;
End;

Procedure TfrmCapMain.GearDeSpeckle;
Var
  i, curPg: Integer;
  DesspecStr : string;
  DespecPg : integer;
  DespecFilename: string;
Begin
    {DONE: Save copy of image, to allow a Cancel function for Deskew and Despeckle}
      { if importing, we have an Image file to copy
        if TWAIN Scan, we have to create a tmp image before doing operation.
        before we create the tmp image, we have to ReSet the image.
        THE Reset function could search for a tmp image with .tmp and same name
        if exist, then load it, }
  If isgearClear(mg1) Then
    Exit;
  Application.Processmessages;
  AccusoftPropertiesLog('Before DeSpeckle: GearDeSpeckle');
  {129t10   NOTE:: we didn't use this cMag4VGear control in previous capture Apps.
      For Multipage images we used a Gear99 version of LoadDocument.
      Now we're using LoadPage, due to using cMag4VGear,
      this workaround is not efficient.  but will work for now..}

  curPg := mg1.page;
  FImageChanged := True;        
  For i := 1 To  mg1.pagecount do
  Begin
    mg1.page := i;
    mg1.DeSpeckleImage;

    DespecPg := mg1.page-1;
    DespecFilename := mg1.ImageFilename;
    getIGManager.IGFormatsCtrl.savePageToFile(mg1.GetCurrentPage,DespecFilename,DespecPg,IG_PAGESAVEMODE_REPLACE,CapX.mIGSaveFormat);
  End;
  If mg1.page <> curPg then
    mg1.page := curPg;
mg1.UpdatePageView;
End;

Procedure TfrmCapMain.tlbrbtnDeSpeckleClick(Sender: Tobject);
Begin
  GearDeSpeckle();
  //FTRCImageManips := True ; //p122t12
End;

Procedure TfrmCapMain.tlbrbtnDeSkewClick(Sender: Tobject);
Begin
  GearDeSkew();
  //FTRCImageManips := True ; //p122t12
End;

Procedure TfrmCapMain.mnuOriginHoldValuePopup(Sender: Tobject);
Begin
  mnuOriginHoldValueItem.Checked := TmagLabelNoClear(LbOrigin).NoClear;

End;

Procedure TfrmCapMain.mnuOriginHoldValueItemClick(Sender: Tobject);
Begin
  TmagLabelNoClear(LbOrigin).NoClear := Not TmagLabelNoClear(LbOrigin).NoClear;

End;

Procedure TfrmCapMain.mnuImagePropertiesClick(Sender: Tobject);
Var
  selFile: String;
  Li: TListItem;
    //  gray : string;
Begin
  Li := LvImport1.Selected;
  If Li <> Nil Then
  Begin

    selfile := Li.SubItems[3] + '\' + Li.caption;
    showImageProperties(selfile);
  End;
End;







Procedure TfrmCapMain.ShowImageProperties(Filename: String; ashint: Boolean = False);
Var
//p129   tmpGear: TGear;
  Prop: String;
  x, y: Integer;
               //p129
             { TODO -o129 : This IGIOLocation in CapMain is a temp.
                     A call in TMag4VGear to get info for a Filename,
                      and/or an IGPage.}
           vFormatPgInfo: IIGFormatPageInfo;
           vIoLocation: IIGIOLocation;
           venumImageFormat: enumIGFormats;
           venumIGCompression :  enumIGCompressions;
           vImageChannelInfo :   IIGImageChannelInfo ;
           vImageTileInfo : IIGImageTileInfo;
           vDIBInfo  : IIGDIBInfo;
           vImageResolution : IIGImageResolution;
           vFilename : string;
           vPage : integer;
           vPageCount : integer;
           i : integer;
Begin

{ temp  ---------------  }

   vFileName := filename;
        //  PageInfo: IGFormatPageInfo;
        //  IoLocation: IIGIOLocation;
        //  FImageFormat: enumIGFormats;
      vIoLocation := GetIGManager.IGFormatsCtrl.CreateObject(IG_FORMATS_OBJ_IOFILE) As IIGIOLocation;
      (vIoLocation As IGIOFile).Filename := vFilename;
        //     IGFormatsCtrl.LoadPageFromFile(CurrentPage, Filename, 0); //dialogLoadOptions.PageNum);

      vPage := 1;
      vPageCount := GetIGManager.IGFormatsCtrl.GetPageCount(vIoLocation, IG_FORMAT_UNKNOWN);
      vFormatPgInfo := GetIGManager.IGFormatsCtrl.GetPageInfo(vIoLocation, vPage - 1, IG_FORMAT_UNKNOWN);
      venumImageFormat := vFormatPgInfo.Format;
      venumIGCompression := vFormatPgInfo.Compression;

     Prop := Filename + #13 + #13

    + inttostr(vFormatPgInfo.ImageWidth) + 'w x '
      + inttostr(vFormatPgInfo.ImageHeight) + 'h  '
      + '     ' + inttostr(vFormatPgInfo.BitDepth) + ' Bits.' + #13
      + 'Compression: ' + inttostr(venumIGCompression) +  ' = '  + magtwain1.GetCompressionDesc(venumIGCompression) + #13
      + 'Image Format: ' + inttostr(venumImageFormat) + ' = '  + magtwain1.GetFormatDesc(venumImageFormat)  + #13

    + 'Size   : ' + Inttostr((Getfilesize(Filename) Div 1024) + 1) + ' KB' + #13
      + 'Date   : ' + DateTimeToStr(FILEDATETIME(Filename));

     x := Mouse.CursorPos.x;
    y := Mouse.CursorPos.y;
    If x + 400 > Screen.Width Then
      x := Screen.Width - 400;
    If y + 200 > Screen.Height Then
      y := Screen.Height - 200;
{ TODO -o129 this was deleted. not sure why}
 (*    If ashint Then
    Begin
            //frmInfoWindow := TfrmInfoWindow.create;
      frmCapInfoWindow.LbImageProperties.caption := Prop;
      frmCapInfoWindow.Left := x;
      frmCapInfoWindow.Top := y + 18;
      frmCapInfoWindow.Show;
    End
    Else
*)


      Messagedlgpos(Prop, Mtinformation, [Mbok], 0, x, y);


End;

Procedure TfrmCapMain.Gear1ErrorEvent(Sender: Tobject;  nErrCount: Smallint);
Var
  i: Integer;
Begin
{This is OLD GearError event   Gear 99   leave comments and code for now.}
{ DONE -c129 : Error handling.}   {FErrorInGear}
{p129   This won't work anymore as is.  Don't know if we can modify for TMag4VGear.
    we don't have visibility to the IGPage from our functions here.
    the function calls to mg1. (Tmag4VGear) need to have own error traps
    ... maybe like prototype,  test for Error Count after the call.
    .. but still need a way to set the Error Handling method of Mag4VGear.
    and return error messages.}
    // On Error Event for Gear 1.  (Debug Level must be 2);



  FErrorInGear := True;
  For i := 1 To nErrCount Do
  Begin
 { TODO -o129 : Need Error Code convert to V16}
   //p129  Gear 1.ErrorCode := i;
   //p129  FErrorInGearList.Add(Gear 1.Errstring);
  End;
End;

Procedure TfrmCapMain.tbwsSourceMouseMove(Sender: Tobject; Shift: TShiftState; x, y: Integer);
Begin
(* p140   *)
exit;
(*
  If MagFloatConfig.Visible Then
  Begin
    If MagFloatConfig.CurObject <> TWinControl(FrmCapConfig.GInputSource) Then
    Begin
      MagFloatConfig.Close;
      ToolbuttonsUp;
      tbwsSource.Click;
      tbwsSource.Down := True;
    End;
  End;
*)
End;

Procedure TfrmCapMain.tbwsFormatMouseMove(Sender: Tobject;  Shift: TShiftState; x, y: Integer);
Begin
(* p140   *)
exit;
(*
  If MagFloatConfig.Visible Then
  Begin
    If MagFloatConfig.CurObject <> TWinControl(FrmCapConfig.GImageFormat) Then
    Begin
      MagFloatConfig.Close;
      ToolbuttonsUp;
      tbwsFormat.Click;
      tbwsFormat.Down := True;
    End;
  End;
*)
End;


procedure TfrmCapMain.ShowCapX(tomsghistory : boolean);
var s : string;
begin
 with CapX do
  begin
  s :=
    'mSourceID   ' + inttostr(mSourceID) + #13 +
    'mScanMode   ' + mScanMode    + #13 +
    'mBatch   ' + magbooltostr(mBatch)  + #13 +
    'mMultipage   ' + magbooltostr(mMultipage)  + #13 +
    'mTwain   ' + magbooltostr(mTwain )  + #13 +
    'mTwainWindow   ' + magbooltostr(mTwainWindow)  + #13 +
    'm140RLE   ' + magbooltostr( m140RLE )  + #13 +
    'm140JPG   ' + magbooltostr(m140JPG)  + #13 +
    'm140MultSources   ' + magbooltostr(m140MultSources)  + #13 +
    'm140PDFConvert   ' + magbooltostr(m140PDFConvert )  + #13 +
    'mOtherDesc   ' + mOtherDesc   + #13 +
    'mFormatDesc   ' + mFormatDesc   + #13 +
    'mFormat   ' + mFormat   + #13 +
    'mImageType   ' + inttostr(mImageType)     + #13 +
    'mIGSaveFormat   ' + inttostr(mIGSaveFormat )  + #13 +
    'mIGScanFormat   ' + inttostr(mIGScanFormat )  + #13 +
    'mIGScanPixelType   ' + inttostr(mIGScanPixelType )  + #13 +
    'mIGScanCompression   ' + inttostr(mIGScanCompression )  + #13 +
    'mIGScanBitDepth   ' + inttostr(mIGScanBitDepth)  + #13 +
    'mIGSaveJPEGQuality   ' + inttostr(mIGSaveJPEGQuality ) ;

    if not tomsghistory then Showmessage(s)
      else magappmsg('s',s);
  end;


end;

procedure TfrmCapMain.ShowCapXFalse1Click(Sender: TObject);
begin
ShowCapX(false);
end;

procedure TfrmCapMain.ShowCapXtrue1Click(Sender: TObject);
begin
ShowCapX(true);
end;

Procedure TfrmCapMain.ToolbuttonsUp;
Begin
  tbwsSource.Down := False;
  tbwsFormat.Down := False;
  tbwsAssoc.Down := False;
  tbwsSaving.Down := False;
  tbwsMode.Down := False;
  tbwsOther.Down := False;

End;

Procedure TfrmCapMain.tbwsAssocMouseMove(Sender: Tobject;    Shift: TShiftState; x, y: Integer);
Begin
  If MagFloatConfig.Visible Then
  Begin
    If MagFloatConfig.CurObject <> TWinControl(FrmCapConfig.GAssociation) Then
    Begin
      MagFloatConfig.Close;
      ToolbuttonsUp;
      tbwsAssoc.Click;
      tbwsAssoc.Down := True;
    End;
  End;
End;

Procedure TfrmCapMain.tbwsSavingMouseMove(Sender: Tobject;   Shift: TShiftState; x, y: Integer);
Begin
  If MagFloatConfig.Visible Then
  Begin
    If MagFloatConfig.CurObject <> TWinControl(FrmCapConfig.GImageGroup) Then
    Begin
      MagFloatConfig.Close;
      ToolbuttonsUp;
      tbwsSaving.Click;
      tbwsSaving.Down := True;
    End;
  End;
End;

Procedure TfrmCapMain.tbwsModeMouseMove(Sender: Tobject;   Shift: TShiftState; x, y: Integer);
Begin
  If MagFloatConfig.Visible Then
  Begin
    If MagFloatConfig.CurObject <> TWinControl(FrmCapConfig.GMode) Then
    Begin
      MagFloatConfig.Close;
      ToolbuttonsUp;
      tbwsMode.Click;
      tbwsMode.Down := True;
    End;
  End;
End;

Procedure TfrmCapMain.tbwsOtherMouseMove(Sender: Tobject;  Shift: TShiftState; x, y: Integer);
Begin
  If MagFloatConfig.Visible Then
  Begin
    If MagFloatConfig.CurObject <> TWinControl(FrmCapConfig.GOther) Then
    Begin
      MagFloatConfig.Close;
      ToolbuttonsUp;
      tbwsOther.Click;
      tbwsOther.Down := True;
    End;
  End;
End;

Procedure TfrmCapMain.hiGear1Click(Sender: Tobject);
Begin
//p129   FCapClinMgr.TestMessage(Inttostr(Gear 1.hiGear));
End;

Procedure TfrmCapMain.ToolBarCaptions1Click(Sender: Tobject);
Begin
  toolbarcaptions1.Checked := Not toolbarcaptions1.Checked;
  tlbarImage.ShowCaptions := toolbarcaptions1.Checked;
End;

//>>>draganddropfiles

Procedure TfrmCapMain.AcceptFiles(Var Msg: TMessage);
Const
  cnMaxFileNameLen = 255;
Var
  i,
    nCount: Integer;
  acFileName: Array[0..cnMaxFileNameLen] Of Char;
  Files: TStrings;
  converttodicom: boolean;  //p122t12 dmmn - Garrett's Fix for DragAndDrop
Begin
  //p122t12 dmmn - Garrett's Fix for DragAndDrop13681
  //( (Format = '.DCM') and  (ImageType = 100)  )
  (*   Tried  Format := '.DCM', ImageType := 100;
       but  at this point in process,(if user clicked Import Copy)it is still '.DCM',
       it is switched later in the process.*)
  converttodicom := (CapX.mSourceID = mcSrcImport) and (frmCapConfig.cmbImportmode.ItemIndex = 1 );
  Files := Tstringlist.Create;
  Try
    INITimport;
    if converttodicom then
      frmCapConfig.INITDICOMformat;   //Fix for DragAndDrop

        // find out how many files we're accepting
    nCount := DragQueryFile(Msg.WParam,
      $FFFFFFFF,
      acFileName,
      cnMaxFileNameLen);

        // query Windows one at a time for the file name
    For i := 0 To nCount - 1 Do
    Begin
      DragQueryFile(Msg.WParam, i,
        acFileName, cnMaxFileNameLen);

            // do your thing with the acFileName
      Files.Add(acfilename);
    End;

    newLoadImportFiles(Files);
    ChDir(AppPath);
        // let Windows know that you're done
    DragFinish(Msg.WParam);

  Finally
    Files.Free;
  End;
  LvImport1.Selected := LvImport1.Items[0];
  ImportFile(LvImport1, 0);
  LvImport1.SetFocus;
End;
//<<<draganddropfiles

Procedure TfrmCapMain.ImportDirectory1Click(Sender: Tobject);
Begin
  SelectImportDirectory5;
    //  SelectImportDirectory4;
End;

Procedure TfrmCapMain.ClearImage1Click(Sender: Tobject);
Begin
  { p129 6/26/12 - ClearAllAnnotations was put in.  wasn't here before }
  mg1.AnnotationComponent.ClearAllAnnotations;
  application.ProcessMessages;

  GearClear;
End;

Procedure TfrmCapMain.SmoothImage;
Begin

    {IG_DSPL_ANTIALIAS_SCALE_TO_GRAY
    The scale to gray algorithm is used and the output image becomes 4
    bits per pixel.}

    {
    If AliasMode is set to IG_DSPL_ANTIALIAS_SCALE_TO_GRAY,
    AliasThreshold determines the number of black and white pixels in
    the destination gray pixel value. A value of 100 directs ImageGear to
    take 100% of white pixels. A value of 0 directs ImageGear to take
    100% of black pixels. The default value, which is 50, directs
    ImageGear to take 50% white and 50% black pixels.
    }
{ TODO -o129 :  We think this is taken care of in TMag4VGear.  }
  //p129 Gear 1.AliasQuality := 100;
  //p129  Gear 1.AliasMode := IG_DISPLAY_ALIAS_SCALE_TO_GRAY;


  End;

{       P48T1 Created MagExecuteFile as quick fix for Accessviolation when
        opening images with long file names (path + filename).
        The file fmxutils has the ExecuteFile funtion,and delclares variables to
        be Array[0..79]
        I created MagExecuteFile copied Execute File, and increase 79 to 279.
        Problem gone.}

{P129T17   Modify the MagExecutefile to add "" around file and parameters., default 'open' as OPeration}
Function TfrmCapMain.Magexecutefile(Const Filename, Params, DefaultDir: String; ShowCmd: Integer; Oper: String = 'open'): THandle;
Var
  ZOper, ZFileName, ZParams, ZDir: Array[0..279] Of Char;
  myfilename, myparams: String;
Begin
  myfilename := Filename;
  myparams := Params;
  {New P129t17}
  If Copy(myfilename, 1, 1) <> '"' Then myfilename := '"' + myfilename + '"';
  If Copy(myparams, 1, 1) <> '"' Then myparams := '"' + myparams + '"';

  winmsg('s','ShellExecute File : ' + myfilename);
  winmsg('s','Parameters   :      ' + myparams);
  winmsg('s','Default Dir  :      ' + defaultDir);

  Strpcopy(ZOper, Oper);
  Strpcopy(ZFileName, myFileName);
  Strpcopy(ZParams, myParams) ;
  Strpcopy(ZDir, DefaultDir) ;

  Result := ShellExecute(Application.MainForm.Handle, ZOper, ZFilename, ZParams, Zdir, ShowCmd);
End;



Procedure TfrmCapMain.ActiveControl1Click(Sender: Tobject);
Var
  s: String;
Begin
  Try
    s := Frmcapmain.ActiveControl.Name;
  Except
    s := 'exception controlname';
  End;
  MagAppMsg('', s);

End;

{TODO: Get rid of this}

Procedure TfrmCapMain.savetoapppath1Click(Sender: Tobject);
Begin
  Imagelongdesc.Lines.Add('1  Saving Long Desc to DOS File,');
  Imagelongdesc.Lines.Add('2  Saving Long Desc to DOS File,');
  Imagelongdesc.Lines.Add('3  Saving Long Desc to DOS File,');
  Imagelongdesc.Lines.Add('End  Saving Long Desc to DOS File.');
  Imagelongdesc.Lines.SaveToFile(GUserDir.Temp + 'testing.txt');
  MagAppMsg('', 'Saved to File : ' + GUserDir.Temp + 'testing.txt');
End;

Procedure TfrmCapMain.tabctrChange(Sender: Tobject);
Var
  Rmsg: String;
Begin
  If TabCtr.TabIndex <> -1 Then
  Begin
    FrmConfigList.ApplyConfiguration(TabCtr.Tabs[TabCtr.TabIndex], Rmsg);
    TabCtr.TabIndex := -1;
  End;
End;

Procedure TfrmCapMain.popupTabctrPopup(Sender: Tobject);
Begin
  mnumultilinebuttons.Checked := TabCtr.Multiline;
  mnuHideToolbarConfigs.Checked := Not TabCtr.Visible;
End;

Procedure TfrmCapMain.mnuMultiLinebuttonsClick(Sender: Tobject);
Begin
  ToggleMultiLineButtons;
End;

procedure TfrmCapMain.mnuTESTINGIsSessionChangedClick(Sender: TObject);
var annotated : boolean;
begin
      {p129 - annot info}{b2}

// annotated :=  mg1.CheckIfAnnotsModified;
{the CheckIfAnnotsModified always returned True for me.
     Duc, suggested  Testing the property "IsSessionChanges"  of  FmagAnnot directly
I make new function in TMag4VGear to check the "IsSessionChanged"  property "  }
{ I called it ...  CheckIsSessionChanged  }

annotated := mg1.CheckIsSessionChanged;
winmsg('',' Annotations modified : ' + magbooltostr(annotated));
end;

Procedure TfrmCapMain.ToggleMultiLineButtons;
Begin
  mnuMultiLineButtons.Checked := Not mnuMultilinebuttons.Checked;
  TabCtr.Multiline := mnuMultiLineButtons.Checked;
  FSavedConfigsMultiLine := mnuMultiLineButtons.Checked;
  RedisplayMultiline;
End;

Procedure TfrmCapMain.RedisplayMultiline;
Begin
  FSavedConfigsMultiLine := TabCtr.Multiline;
  If TabCtr.Multiline Then
    TabCtr.Height := (3 * TabCtr.RowCount) + (TabCtr.RowCount * TabCtr.TabHeight)
  Else
    TabCtr.Height := 3 + TabCtr.TabHeight;
End;

Procedure TfrmCapMain.TestCapObj1Click(Sender: Tobject);
Var
  cob: TCaptureObject;
  sin: String;
Begin
  cob := TCaptureObject.Create;
  Try
    sin := InputBox('Testing', 'click OK to show TCaptureObject properties', '\\server\share\filename.ext');

    cob.FullFileName := sin;
    showcapobj(cob);
  Finally
    cob.Free;
  End;
End;

Procedure TfrmCapmain.ShowCapObj(vCapObj: TCaptureObject);
Var
  s: String;
Begin
  s := vCapObj.FullFileName + #13 +
    vCapObj.GetPath + #13 +
    vCapObj.GetFileName + #13 +
    vCapObj.GetFileNameNoExt + #13 +
    vCapObj.GetExt + #13 +
    vCapObj.GetAbsFullFileName;
  //Showmessage(s); // this is a multiline message
  //p106 rlm 20101229 CR640 "Title of Dialog box"
  MagAppMsg('d',s);
End;

Procedure TfrmCapMain.EnableImageOKCapture1Click(Sender: Tobject);
Begin
  btnImageOK.Enabled := True;
  btnCapture.Enabled := True;
End;

Procedure TfrmCapMain.messagedlg1Click(Sender: Tobject);
Begin
  Messagedlg('"VistA Imaging Capture" is already running. ' + #13 + #13 + 'A second instance will not be started.', Mtconfirmation, [Mbok], 0);
  {/p122 dmmn WPR Capture Item #20 /}
  Messagedlg('Save CANCELLED.  To change the format of the images you are saving, ' + #13 +
    'you must change the Image Format in the Configuration Window' + #13 +
    'select the menu ''Options|Configuration'' to change the Image Format', Mtconfirmation, [Mbok], 0);

End;

{p129  this copied from Gear 1.Keydown and modified for the TMag4VGear KeyDown method.
        parameter Shift is different...integer here, was a Set in Gear 1.
        }
{ DONE -o129 -ccheck :
need to rethink this.  maybe not need it, just make a note for documentation.
 Copy and Paste are available from PopupMenu...
508...  keyboard controls to scroll image... ?
... Yes.  forget this, and use Ctrl Codes for Hidden Menu items. }
procedure TfrmCapMain.mg1ImageKeyDown(Sender: TObject; var Key, Shift: Smallint);
Var
  horiz, vert: Integer;
  mgh, mgv : integer;
Begin
  if (key = VK_RIGHT)  then
  begin
    popupImageControls.OnPopup(mg1);
  end;
  If (Key = VK_LEFT) Then
  Begin
(* p129
   Horiz := Gear 1.GetScrollPos(0);
    Vert := Gear 1.GetScrollPos(1);
    Gear 1.SetScrollPos(0, 4, Horiz - 10);
    Gear 1.SetScrollPos(1, 4, Vert - 10); *)

   Horiz := mg1.GetScrollInfo.H_Pos;
    Vert := mg1.GetScrollInfo.V_Pos;
    mg1.SetScrollPos(Horiz - 10, Vert - 10);


  End;
(*  If Not (Ssctrl In Shift) Then
    Exit;
  If (Key = Ord('V')) Or (Key = Ord('v')) Then
  Begin
    If Not FrmCapConfig.Clipboard.Enabled Then // ClipBoard FIX 7/06/01 GEK
    Begin
      WinMsg('', 'Clipboard functions are disabled.');
      Exit;
    End;
    FrmCapConfig.Clipboard.Checked := True;
        //INITClipboard;
    btnCaptureClick(Self);
  End;
  If (Key = Ord('C')) Or (Key = Ord('c')) Then
  Begin
    If Not FrmCapConfig.Clipboard.Enabled Then // ClipBoard FIX 7/06/01 GEK
    Begin
      WinMsg('', 'Clipboard functions are disabled.');
      Exit;
    End;
    GearCopy;
  End; *)
  (* p129.. duplicate of above... whole function is being taken out anyway.
  If (Key = VK_LEFT) Then
  Begin
    Horiz := Gear 1.GetScrollPos(0);
    Vert := Gear 1.GetScrollPos(1);
    Gear 1.SetScrollPos(0, 4, Horiz - 10);
    Gear 1.SetScrollPos(1, 4, Vert - 10);
 mgh := horiz ;//mg1. ; //  { TODO -o129 -cview : need function for mg1 to get ScrollBar Position.... }
 mgv := vert; //mg1. ; //  { TODO -o129 -cview : need function for mg1 to get ScrollBar Position.... }
mg1.SetScrollPos(mgv - 10, mgh - 10);
  End;*)
End;

procedure TfrmCapMain.mg1ImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Var  mpt: TPoint;
Begin
winmsg('', 'Here ImageMouseDown');
exit;
end;

procedure TfrmCapMain.mg1ImageZoomScroll(Sender: TObject; VertScrollPos, HorizScrollPos: Integer);
begin
winmsg('','on ImageZoomScroll  Vert : ' + inttostr(VertScrollPos) + '  Horiz: ' + inttostr(HorizScrollPos));
end;

Procedure TfrmCapMain.mnuGetDateTimeClick(Sender: Tobject);
Var
  datetime: String;
  dDttm: Tdatetime;
Begin

  If FrmDateTimeDialog.Execute(datetime, dDttm) Then
    MagAppMsg('d', 'datetime : ' + datetime)
  Else
    MagAppMsg('d', 'cancelled');     {/p122 dmmn WPR Capture Item #20 /}
End;


Procedure TfrmCapMain.LoadHelpMenu;
Var
  Sr: TSearchRec;
Begin
//p93T12  We're looking for a specific file here
(* /p129t17 we will stop Loading this file  '\MagWhats New in Patch 93.pdf'*)


    {   Search for files that are prefixed with certain 'code words' and add
        them to the help menu}
  If FindFirst(AppPath + '\MagImageCaptureHelpItem-*.*', FaAnyFile, Sr) = 0 Then
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
      MagHelpMenu.AddItem(MagPiece(Copy(Sr.Name, 4, 999), '.', 1), AppPath + '\' + Sr.Name, '');
    While FindNext(Sr) = 0 Do
    Begin
      If FileExists(AppPath + '\' + Sr.Name) Then
        MagHelpMenu.AddItem(MagPiece(Copy(Sr.Name, 4, 999), '.', 1), AppPath + '\' + Sr.Name, '');
      WinMsg('s', 'Help Menu Added : ' + Sr.Name);
    End;
  End;

  If FindFirst(AppPath + '\MagWhatsNew*.*', FaAnyFile, Sr) = 0 Then
  Begin
    If FileExists(AppPath + '\' + Sr.Name) Then
      MagHelpMenu.AddItem(MagPiece(Copy(Sr.Name, 4, 999), '.', 1), AppPath + '\' + Sr.Name, '');
    While FindNext(Sr) = 0 Do
    Begin
      If FileExists(AppPath + '\' + Sr.Name) Then
        MagHelpMenu.AddItem(MagPiece(Copy(Sr.Name, 4, 999), '.', 1), AppPath + '\' + Sr.Name, '');
      WinMsg('s', 'Help Menu Added : ' + Sr.Name);
    End;
  End;

End;

Procedure TfrmCapMain.AutoImageDesc(Desc: String; descsource: TmagDescSource);
Var
  olddesc: String;
Begin
  If Not iniUseImageDesc Then
    Exit;
  Case descsource Of
    magdescPkg: oldDesc := FoldAutoDescPkg;
    magdescType: oldDesc := FoldAutoDescType;
  End;
  Desc := Trim(Desc);
    {P8, if image desc, the last default ,or doesn't have the last default in it.
    then it ALL gets erased and the New default is set as Image desc. }
  If (EdtImageDesc.Text = oldDesc) Or (EdtImageDesc.Text = '') Then
    EdtImageDesc.Text := Desc
  Else
    If (Pos(oldDesc, EdtImageDesc.Text) > 0) Then
      EdtImageDesc.Text := Copy(EdtImageDesc.Text, 0, Pos(oldDesc, EdtImageDesc.Text) - 1) + Desc + Copy(EdtImageDesc.Text, (Pos(oldDesc, EdtImageDesc.Text)
        + Length(oldDesc)), 999);

  Case descsource Of
    magdescPkg: FoldAutoDescPkg := Desc;
    magdescType: FoldAutoDescType := Desc;
  End;
End;

Procedure TfrmCapMain.btnProcDateClick(Sender: Tobject);
Var
  Dttm: String;

  dDttm: Tdatetime;
  Pt: TPoint;
Begin

(* /p117 gek.  This isn't needed.  MakeStudyReadOnly is called for Association.
//p106 start
  If (TRConsultPtr <> '') And FrmCapConfig.TeleReaderConsult.Checked Then Exit;
//p106 end.
*)

    //dttm := edtProcDate.Text;
    //dttm := magpiece(edtProcDate.text,'@',1) + ' '+ magpiece(edtProcDate.text,'@',2);
  Dttm := '';
  Pt.x := btnProcDate.Left + btnProcDate.Width;
  Pt.y := btnProcDate.Top + btnProcDate.Height;
  Pt := SbxEditFields.ClientToScreen(Pt);
  If FrmDateTimeDialog.Execute(Pt, Dttm, dDtTm) Then
  Begin
    If compareDateTime(Now, ddttm) = -1 Then
    Begin
      MagAppMsg('d', 'A Future Date/Time is not allowed.');
      Exit;
    End;
    EdtProcDate.Text := Dttm;
    DateTimeProc := Dttm;
    If iDModObj.GetMagDBBroker1.IsConnected Then
      NoteDateCheck;
    If EdtProcDate.Text <> '' Then
    Begin
      If EdtProcDate.Visible Then
      Begin
        If EdtProcDate.Enabled Then
        Begin
          EdtProcDate.SetFocus;
        End;
      End;
      EdtProcDate.Update;
      EdtProcDate.Modified := True;
      Exit;
    End;
  End;
  If EdtProcDate.Visible Then
  Begin
    If EdtProcDate.Enabled Then
    Begin
      EdtProcDate.SetFocus;
    End;
  End;
End;

Procedure TfrmCapMain.mSysManClick(Sender: Tobject);
Begin
    {TODO:  Stop the reference to other forms, move the property to a
            singleton object (MagCapMgr ? ) Stop dependence of forms on forms}
  mnuBatchAdvanced.Checked := FrmCapBatchAdv.FBatchAdvEnable;
End;

{function TfrmCapMain.IsValidAdvanceDirective: boolean;
  We are forcing any IMAGE that has INDEX TYPE = ADVANCE DIRECTIVE
  to be associated with a Progress Note of Doc Class ADVANCE DIRECTIVE
  And any Note that is an ADVANCE DIRECTIVE to have an INDEX TYPE of ADVANCE DIRECTIVE }

Function TfrmCapMain.IsValidAdvanceDirective: Boolean;
Var
  Li: TListItem;
  Rmsg: String;
  ADVNote: Boolean;
  ADVImage: Boolean;
  Rstat: Boolean;
Begin
  ADVImage := False; //106  uncomment
  ADVNote := False;  //106  uncomment 
    //ADVImage := false;
    //ADVNote := false;
  Result := True;

  Li := LvType.Selected;
  If Li = Nil Then
    Exit;

  ADVImage := Li.caption = 'ADVANCE DIRECTIVE';
  If (ADVImage And (Magassoc <> 'NOTES')) Then
  Begin
    MagAppMsg('de', 'ADVANCE DIRECTIVE scanned documents must be associated ' + #13 +
      '               with an ADVANCE DIRECTIVE Note.'
      + #13 + #13 +
      'Select an ADVANCE DIRECTIVE Note to continue.');
    WinMsg('', 'Need ADVANCE DIRECTIVE Note Title', Pmsg);
    Result := False;
    Exit;
  End;
  If (Magassoc = 'NOTES') Then
  Begin
    If FCapClinDataObj.NewNote Then
      ADVNote := iDModObj.GetMagDBBroker1.RPMaggIsDocClass(FCapClinDataObj.NewTitleDA, '8925.1', 'ADVANCE DIRECTIVE', Rstat, Rmsg)
    Else
      ADVNote := iDModObj.GetMagDBBroker1.RPMaggIsDocClass(FCapClinDataObj.ReportData.TiuDA, '8925', 'ADVANCE DIRECTIVE', Rstat, Rmsg);
    If Not Rstat Then
    Begin
      MagAppMsg('de', 'Exception: ' + Rmsg);
      Result := False;
      Exit;
    End;
    If (((Not ADVNote) And (Not ADVImage)) Or (ADVNote And ADVImage)) Then
    Begin
      Exit;
    End;

    Result := False;
    If Not ADVNote Then
    Begin
      MagAppMsg('de', 'ADVANCE DIRECTIVE scanned documents must be associated ' + #13 +
        '               with an ADVANCE DIRECTIVE Note.'
        + #13 + #13 +
        'Select an ADVANCE DIRECTIVE Note to continue.');
      WinMsg('', 'Need ADVANCE DIRECTIVE Note Title', Pmsg);
    End;
    If Not ADVImage Then
    Begin
      MagAppMsg('de', 'Scanned Documents that are associated with ADVANCE DIRECTIVE Notes.' + #13 +
        'Must have Doc/Image Type of: "ADVANCE DIRECTIVE" '
        + #13 + #13 +
        'Select Doc/Image Type: "ADVANCE DIRECTIVE"  to continue.');
      WinMsg('', 'Need ADVANCE DIRECTIVE Doc/Image Type', Pmsg);
      Exit;
    End;
  End;
End;

Procedure TfrmCapMain.ConfigbuttonsTop1Click(Sender: Tobject);
Begin
  SetConfigBtnsTop;
End;

Procedure TfrmCapMain.ConfigButtonsLeft1Click(Sender: Tobject);
Begin
  SetConfigBtnsLeft;
End;

Procedure TfrmCapMain.SetConfigBtnsTop;
Begin
  ;
  spltConfigbuttons.Width := 0;
  spltConfigbuttons.Left := 0;
  TabCtr.Align := altop;
End;

Procedure TfrmCapMain.SetConfigBtnsLeft;
Begin
  ;
  TabCtr.Align := alLeft;
  spltConfigbuttons.Left := TabCtr.Width - 5;
  spltConfigbuttons.Width := 4;
  spltConfigbuttons.Visible := True;
End;

Procedure TfrmCapMain.sbxEditFieldsDockDrop(Sender: Tobject;  Source: TDragDockObject; x, y: Integer);
Begin
    // not using this.  it didn't work right away.
  TabCtr.parentwindow := pnlData.Handle;
  TabCtr.Align := altop;
End;

Procedure TfrmCapMain.ScrollToItem(LV: TListView; ListIndex: Integer);
Var
  Vrc: Integer;
Begin
  With LV Do
  Begin
    Try
      Items.BeginUpdate;
      Vrc := VisibleRowCount;

      If ((TopItem.Index + Vrc) <= ListIndex) Then
      Begin
        While ((TopItem.Index + Vrc) <= ListIndex) Do
        Begin
          Scroll(0, 20);
          Update;
        End;
                //for i := 1 to (vrc div 2) do Scroll(0,20);
                //for i := 1 to (vrc ) do Scroll(0,20);
        Exit;
      End;
      If (TopItem.Index > ListIndex) Then
      Begin
        While (TopItem.Index <> ListIndex) Do
        Begin
          Scroll(0, -20);
          Update;
        End;
                //for i := 1 to (tv div 2) do Scroll(0,-20);
                //fRIDAY   for i := 1 to 1 do Scroll(0,-20);
      End;
    Finally
      Items.EndUpdate;
    End;
  End;
End;

Procedure TfrmCapMain.BatchCapDescriptionWindow1Click(Sender: Tobject);
Begin
    // this is from the testing menu
  Application.CreateForm(TfrmCapBatchImageDesc, FrmCapBatchImageDesc);
  FrmCapBatchImageDesc.Showmodal;
  FrmCapBatchImageDesc.Release;
End;

Procedure TfrmCapMain.mnuRemoveAllBatchListClick(Sender: Tobject);
Begin
  ImportBatchRemoveAll;
End;

{p129t10 gek  Test Menu item.  Not visible to user}
procedure TfrmCapMain.mnuResetPanWindowClick(Sender: TObject);
begin
self.MagResetPanWindow;
end;

Procedure TfrmCapMain.tool1Click(Sender: Tobject);
Begin
  toolbartop(True);
End;

Procedure TfrmCapMain.toolbarleft1Click(Sender: Tobject);
Begin
  toolbartop(False);
End;

Procedure TfrmCapmain.toolbartop(Value: Boolean);
Begin
    //btnBrightPlus.visible := not value;
    //btnBrightMinus.visible := not value;
    //btnContrastPlus.visible := not value;
    //btnContrastMinus.visible := not value;
    //btnZoomPlus.visible := not value;
    //btnZoomMinus.visible := not value ;

  PicBrightness.Visible := Value;
  PicContrast.Visible := Value;
  PicZoom.Visible := Value;

  If Value Then
    tlbarImage.Align := altop
  Else
    tlbarImage.Align := alLeft;
End;

Procedure TfrmCapMain.edtDocImageDateEnter(Sender: Tobject);
Begin
  btnImageOK.Default := False;
  If (FCapClinDataObj.NewDate <> '') And (EdtDocImageDate.Text = '') Then
    EdtDocImageDate.Text := StripTime(FCapClinDataObj.NewDate);
End;

Procedure TfrmCapMain.HideRequiredMsg;
Begin
  If PnlReqMsg.Visible Then
  Begin
        { we have a message window that isn't a dialog,
          (user doesn't have to click) and  it will   disappear }
    PnlReqMsg.Hide;
  End;
End;

Procedure TfrmCapMain.edtDocImageDateExit(Sender: Tobject);
Var
  ResDateTime, Xmsg: String;
Begin
    {3.0.8   with new fields, this causes problems. btnImageOK.default := true;}
  If FTesting Then
    HideRequiredMsg;
  If EdtDocImageDate.Text = '' Then
    Exit;
  If EdtDocImageDate.Modified Then
        // Patch 45  if not ResolveDateTime then edtProcDate.SetFocus
        // is Above line out in Patch 45 ? we need it here. below.

    If RPFileManDate(Xmsg, EdtDocImageDate.Text, ResDateTime, True) Then
      EdtDocImageDate.Text := StripTime(MagPiece(ResDateTime, '^', 1))
    Else
    Begin
      EdtDocImageDate.Text := '';
      EdtDocImageDate.SetFocus;
    End;
End;

Procedure TfrmCapMain.edtDocImageDateKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
Var
  Xmsg, ResDateTime: String;
Begin
  If FTesting Then
    HideRequiredMsg;
  If (SsAlt In Shift) And (Key = 40) Then
  Begin
    btnDocImageDateClick(Self);
    Exit;
  End;
  If (Key <> VK_Return) Then
    Exit;
  If EdtDocImageDate.Text = '' Then
  Begin
    FEdtLV.GenGoToNextControl(EdtDocImageDate);
  End
  Else
  Begin
    If RPFileManDate(Xmsg, EdtDocImageDate.Text, ResDateTime, True) Then
    Begin
      EdtDocImageDate.Text := StripTime(MagPiece(ResDateTime, '^', 1));
      FEdtLV.GenGoToNextControl(EdtDocImageDate);
    End
    Else
    Begin
      EdtDocImageDate.Text := '';
      EdtDocImageDate.SetFocus;
    End;
  End;
End;

Procedure TfrmCapMain.edtDocImageDateMouseDown(Sender: Tobject;  Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Begin
    //5/16/2006  /p59  if button = mbright then
    //5/16/2006  /p59    OpenHoldMenu(x, y, TControl(edtDocImageDate), lbDocImageDate);

End;



Procedure TfrmCapMain.btnDocImageDateClick(Sender: Tobject);
Var
  Dttm: String;

  dDttm: Tdatetime;
  Xmsg, ResDateTime: String;
  Pt: TPoint;
Begin
    //dttm := edtProcDate.Text;
    //dttm := magpiece(edtProcDate.text,'@',1) + ' '+ magpiece(edtProcDate.text,'@',2);
  Dttm := '';
  Pt.x := btnDocImageDate.Left + btnDocImageDate.Width;
  Pt.y := btnDocImageDate.Top + btnDocImageDate.Height;
  Pt := SbxEditFields.ClientToScreen(Pt);
  If FrmDateTimeDialog.Execute(Pt, Dttm, dDtTm) Then
  Begin
    If compareDateTime(Now, ddttm) = -1 Then
    Begin
      MagAppMsg('d', 'A Future Date/Time is not allowed.');
      Exit;
    End;
    EdtDocImageDate.Text := StripTime(Dttm);
    If iDModObj.GetMagDBBroker1.IsConnected Then
    Begin
      If RPFileManDate(Xmsg, EdtDocImageDate.Text, ResDateTime, True) Then
      Begin
        EdtDocImageDate.Text := StripTime(MagPiece(ResDateTime, '^', 1));
      End
      Else
      Begin
        EdtDocImageDate.Text := '';
      End;
    End;
  End;
  EdtDocImageDate.SetFocus;
End;

Procedure TfrmCapMain.tabctrMouseMove(Sender: Tobject; Shift: TShiftState;  x, y: Integer);
Var
  Xh: Integer;
  winpt: TPoint;
  cpt: TPoint;
Begin
  cpt.x := x;
  cpt.y := y;
  If Ssleft In Shift Then
  Begin
    If Fdragtab > -1 Then
    Begin
      FdragTo := TabCtr.IndexOfTabAt(x, y);
      FrmCapDragTab.btnDrag.caption := TabCtr.Tabs[FDragTab] + 'to  . . ';
      If FdragTo > -1 Then
      Begin
        winpt := ClientToScreen(cpt);
        If (Abs(fDragtabx - x) > 10) Or (Abs(fDragTaby - y) > 10) Then
        Begin
          FrmCapDragTab.Show;
          If tlbrsettings.Visible Then
            Xh := tlbrsettings.Height
          Else
            Xh := 0;
          FrmCapDragTab.btnDrag.caption := TabCtr.Tabs[Fdragtab];
          FrmCapDragTab.Left := winpt.x + 5;
          FrmCapDragTab.Top := winpt.y + Xh - 5;
          If Not FrmCapDragTab.Visible Then
            FrmCapDragTab.Show;
          WinMsg('', 'move ' + TabCtr.Tabs[Fdragtab] + ' after ' + TabCtr.Tabs[FdragTo]);
        End;
      End
      Else
        FrmCapDragTab.btnDrag.caption := '';

    End;
  End;
End;

Procedure TfrmCapMain.tabctrMouseDown(Sender: Tobject;  Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Begin
  fDragTab := TabCtr.IndexOfTabAt(x, y);
  fDragtabx := x;
  Fdragtaby := y;
End;

Procedure TfrmCapMain.tabctrMouseUp(Sender: Tobject; Button: TMouseButton;  Shift: TShiftState; x, y: Integer);
Var
  i: Integer;
  newtab: String;

Begin
  FrmCapDragTab.Visible := False;
  fDragtabx := 0;
  fDragtaby := 0;
  If ((FdragTab > -1) And (FDragTo > -1)) Then
  Begin
    If (fdragtab <> fDragTo) Then
    Begin
      TabCtr.TabIndex := -1;
      newtab := TabCtr.Tabs[Fdragtab];
      TabCtr.Tabs.Delete(Fdragtab);
      If FdragTab < Fdragto Then
        TabCtr.Tabs.Insert(Fdragto, newtab)
      Else
        TabCtr.Tabs.Insert(Fdragto + 1, newtab);
      WinMsg('', 'Configuration Buttons have been Reordered.');
      FConfigButtonsMoved := True;
    End;
  End;
  fDragtab := -1;
  FdragTo := -1;

  TabCtr.TabIndex := -1;
End;

Procedure TfrmCapMain.mnuDebugONClick(Sender: Tobject);
Var
  rpcb: TRPCBroker;
Begin
  mnuDebugOn.Checked := Not mnuDebugOn.Checked;
  rpcb := iDModObj.GetMagDBBroker1.GetBroker;
  rpcb.DebugMode := mnuDebugOn.Checked;
  If rpcb.DebugMode Then
    Messagedlg('You will have to log out of VistA, and log back in for debugging to take effect', Mtconfirmation, [Mbok], 0);
End;

procedure TfrmCapMain.mnuDicomDataTestClick(Sender: TObject);       {//  testing}
begin
if not doesFormExist('frmTESTDicomData') then
       application.CreateForm(TfrmTESTDicomData,frmTESTDicomData);
frmTESTDicomData.Show;
end;

Procedure TfrmCapMain.mnuIconLegendClick(Sender: Tobject);
Begin
  If Not Doesformexist('frmCapIconLegend') Then
        //if not assigned(frmCapIconLegend) then
    Application.CreateForm(TfrmCapIconLegend, FrmCapIconLegend);
  FrmCapIconLegend.Show;
  FrmCapIconLegend.BringToFront;
End;

Procedure TfrmCapMain.mimportdirClick(Sender: Tobject);
Begin
  SelectImportDirectory4;
End;

Procedure TfrmCapMain.mimportdir1Click(Sender: Tobject);
Begin
    // Get Current Directory, change mnuSaveAsDefault Menu title to reflect it.
End;

Procedure TfrmCapMain.edtDocImageDateDblClick(Sender: Tobject);
Var
  Xmsg: String;
  ResDateTime: String;
Begin
  If RPFileManDate(Xmsg, 'now', ResDateTime, True) Then
  Begin
    EdtDocImageDate.Text := StripTime(MagPiece(ResDateTime, '^', 1));
    FEdtLV.GenGoToNextControl(EdtDocImageDate);
  End
  Else
  Begin
    EdtDocImageDate.Text := '';
    EdtDocImageDate.SetFocus;
  End;
End;

Function TfrmCapMain.StripTime(datetime: String): String;
Begin
    {for now, we only take the 1st '@' piece, later we may need more checking.}
  Result := MagPiece(datetime, '@', 1);
End;

Procedure TfrmCapMain.edtProcDateDblClick(Sender: Tobject);
Begin
  DateTimeProc := '';
  EdtProcDate.Text := 'n';
  NoteDateCheck;
  If (DateTimeProc <> '') Then
    FEdtLV.GenGoToNextControl(EdtProcDate);
End;

Procedure TfrmCapMain.SaveDefaultDirectory(Dir: String);
Begin
  SetIniEntry('Import Options', 'DefaultImportDir', Dir);
  WinMsg('', Dir + ' saved as default Directory');
    // SetIniEntry('Import Directories', dir, 'TRUE');
End;

Procedure TfrmCapMain.imgdblUPClick(Sender: Tobject);
Begin
  If plongDesc.Height < 100 Then
    plongDesc.Height := 100;
  plongDesc.SetFocus;
  Imagelongdesc.TabStop := True;
  cbWordWrap.TabStop := True;
  ImgdblUp.Hide;
  ImgdblDown.Show;
End;

Procedure TfrmCapMain.imgdbldownClick(Sender: Tobject);
Begin
  If plongDesc.Height > 22 Then
    plongDesc.Height := 22;
  Imagelongdesc.TabStop := False;
  cbWordWrap.TabStop := False;

  ImgdblUp.Show;
  ImgdblDown.Hide;
End;

Procedure TfrmCapMain.ColapseLongDesc;
Begin
  plongDesc.Height := 22;
  ImgdblUp.Show;
  ImgdblDown.Hide;
End;

Procedure TfrmCapMain.pLongDescResize(Sender: Tobject);
Begin
  cbwordwrap.Visible := (Imagelongdesc.Height > 5);
  If Tpanel(Sender).Height > 100 Then
  Begin
    If Not ImgdblDown.Visible Then
    Begin
      ImgdblUp.Hide;
      ImgdblDown.Show;
    End;
  End
  Else
  Begin
    If Not ImgdblUp.Visible Then
    Begin
      ImgdblUp.Show;
      ImgdblDown.Hide;
    End;
  End;
End;

Procedure TfrmCapMain.img3dotClick(Sender: Tobject);
Begin
  SelectImportDirectory4(LbImport.caption);
End;

Procedure TfrmCapMain.ImgDnBatchClick(Sender: Tobject);
Begin
  MoveSelected(LvImport1, Lvbatch);
End;

Procedure TfrmCapMain.ImgDblDnBatchClick(Sender: Tobject);
Begin
  ImportBatchMoveAll;
End;

Procedure TfrmCapMain.ImportBatchMoveAll;
Var
  i: Integer;
Begin
  LvImport1.MultiSelect := True;
  For i := LvImport1.Items.Count - 1 Downto 0 Do
    LvImport1.Items[i].Selected := True;

  MoveSelected(LvImport1, Lvbatch);
End;

Procedure TfrmCapMain.ImgUpBatchClick(Sender: Tobject);
Begin
  MoveSelected(Lvbatch, LvImport1);
End;

Procedure TfrmCapMain.ImgDblUpBatchClick(Sender: Tobject);
Begin
  ImportBatchRemoveAll;
End;

Procedure TfrmCapMain.ImportBatchRemoveAll;
Var
  i: Integer;
Begin
  Lvbatch.MultiSelect := True;
  For i := Lvbatch.Items.Count - 1 Downto 0 Do
    Lvbatch.Items[i].Selected := True;
  MoveSelected(Lvbatch, LvImport1);
End;

Procedure TfrmCapMain.lstboxImportKeyDown(Sender: Tobject; Var Key: Word;  Shift: TShiftState);
Begin
  If Key = VK_Return Then
    ApplyImportDirFromList;
  If Key = VK_ESCAPE Then
    HideImportDirList;
End;

Procedure TfrmCapMain.ApplyImportDirFromList;
Begin
  If lstboxImport.ItemIndex <> -1 Then
  Begin
    SelectImportDirectory4(lstboxImport.Items[lstboxImport.ItemIndex]);
    HideImportDirList;
  End;
End;

Procedure TfrmCapMain.HideImportDirList;
Begin
  pnllstImport.Visible := False;
  imgdbldnImportdir.BringToFront;
End;

Procedure TfrmCapMain.ShowImportDirList;

Begin
  AlignlstBoxImport;
  lstboxImport.ScrollWidth := GetPixelLengthLongestEntry(lstBoxImport.Items, lstboxImport.Canvas) + 60;

  pnllstImport.Visible := True;
  imgdblupImportdir.BringToFront;
End;

Procedure TfrmCapMain.AlignlstBoxImport;
Var
  Pt: TPoint;
Begin
  Pt.x := pnllstimport.Left;
  Pt.y := pnllstimport.Top;
  Pt := pnllstImport.ScreenToClient(LvImport1.ClientToScreen(Pt));

  pnllstimport.Left := Pt.x; //left;
  pnllstimport.Top := Pt.y; //top;
  pnllstimport.Width := LvImport1.Width - 3;
  pnllstimport.Height := LvImport1.Height - 3;
End;

procedure TfrmCapMain.mnuAnnotationSettings1Click(Sender: TObject);
begin
  if mg1.AnnotationComponent.Visible
    then CapAnnotationHide
    else CapAnnotationShow;
  frmAnnotOptionsX.ShowModal;  {JK 6/27/2012 - added this call to access the global property editor}
end;

Procedure TfrmCapMain.lvImport1Resize(Sender: Tobject);
Begin
  AlignlstBoxImport;
End;

Procedure TfrmCapMain.lstboxImportClick(Sender: Tobject);
Begin
  ApplyImportDirFromList;
End;

Procedure TfrmCapMain.imgdbldnImportdirClick(Sender: Tobject);
Begin
  ShowImportDirList;
End;

Procedure TfrmCapMain.imgdblupImportdirClick(Sender: Tobject);
Begin
  HideImportDirList;
End;

Procedure TfrmCapMain.imgdbluppnllstimportClick(Sender: Tobject);
Begin
  HideImportDirList;
End;

Procedure TfrmCapMain.mnuImportDirectoryOptionsClick(Sender: Tobject);
Begin
    {Three Menu Options Call Here, mnuImportDirectoryOptions and mnuImportDirectoryOptions2,
                                                    and  mnuImportDirectoryOptions3}
  OptionWindowSetSettings;
  FrmCapSettings.PgctrlSettings.ActivePage := FrmCapSettings.TbshImport;
  FrmCapSettings.Showmodal;
  OptionWindowGetSettings;
End;

procedure TfrmCapMain.mnuLoadDSSourcesClick(Sender: TObject);
begin
magtwain1.LoadDSSources;
end;




{TODO: These functions are to alert user that patient has changed, since the
       image was loaded.  This will be activated when patient is switched through
       CPRS or CCOW, won't be activated if User himself, changes patients.}

Procedure TfrmCapMain.btnOKPatientChangeWarningClick(Sender: Tobject);
Begin
  PatientChangeWarningHide;
End;

{This is the OnIGError Event for IGCoreCtl }
procedure TfrmCapMain.mg1IGCoreCtlIGError(ASender: TObject; const ResRec: IIGResultRecord);     {OnIGError Event}
VAR
  errrec : IGResultRecord;
  I : integer;
  errcode : integer;
begin
  {   The following can be Set to True in INI for testing.
      They default to False .
      FErrorInGearFlagShowDups : boolean;
      FErrorInGearFlagShowALL : boolean;
  }

  { DONE -o129 : This goes along with the Error handling of v16}
  For i := 0 To GetIGManager.IGCoreCtrl.Result.RecordsTotal - 1   do
  begin
    //129 Similiar to VB Example. from Accusoft Manual. . yeah, I found something in their help. !
    errrec := GetIGManager.IGCoreCtrl.Result.GetRecord(i);

    {Certain Errors and Warnings are skipped.  Expecially in Accu 16, warnings fill up the message history}
    if NOT FErrorInGearFlagShowALL then
    begin
      if errrec.ErrCode = IGE_GUI_LAYOUT_GET_OBJ_FAILED then continue;     //IGE_GUI_GET_DLG_CTL_FAILED
      if errrec.ErrCode = IGE_GUI_GET_DLG_CTL_FAILED then continue;
     {129t18 Duc  start }
      if errrec.ErrCode = IGE_PDF_FAILURE then
      begin
        // p129t18 dmmn - we're getting font not found error from accusoft for PDF
        // but the truth is accusoft found an alternate font to display the image
        // We are skipping this error message, but since IGE_PDF_FAILURE is
        // a general PDF error, we want to check specifically for the font issue and not others.
        if Pos('Cannot find or create the font', errrec.ExtraText) > 0  then
          continue;
      end;
     {129t18 Duc  start end}
    end;
    
    {Same error is listed many many times. 64 in come cases...  It's unnecessary to report all}
    {If Same error,  skip logging it. }
    if NOT FErrorInGearFlagShowDups then
      if FErrorInGearListCode.IndexOf(inttostr(errrec.ErrCode)) > -1  then continue;   // Accusoft give us many, many of same error for same Exception

    FErrorInGearListCode.Add(inttostr(errrec.ErrCode)) ;
    FErrorInGearList.Add('* '+ errrec.ExtraText);
    FErrorInGear := true;
  end;
end;

procedure TfrmCapMain.BrokerOnPulseError(peBroker: TRPCBroker; peErr: string);
begin
winmsg('s','BROKER - ON PULSE ERROR: ' + peErr);
end;

Procedure TfrmCapMain.Image9Click(Sender: Tobject);
Begin
  PatientChangeWarningHide;
End;

//p117 gek put in changes from 94 skipped by 106.
{[ function TfrmCapMain.PatientChangeWarningIfNeeded()
   Patient has been switched, from CPRS windows message (or CCOW Later)
   If an Image exists in the Image Box, display the warning ]
//p94t1 gek 9/25/09  This is now called anytime a patient changes. }

function TfrmCapMain.PatientChangeWarningIfNeeded(): boolean;
begin
  Result := False;  //106  ... the result s never used pre 106, that's probably why this wasn't an issue
  //result := false  // this was here in 106.. need to test.
   //  although a function,  the 'result' was never needed ... or used.
{ TODO : check the above... is result from this function ever used...  
   it may have been in prev version when design was different.}
    if not IsImageclear(mg1) then
    begin
        PatientChangeWarningShow;
    Result := True;  
    end;
end;

Procedure TfrmCapMain.PatientChangeWarningHide;
Begin
  Frmcapmain.Enabled := True;
  pnlSwitchPatientsWarn.Visible := False;
  lbWarnTitle.caption := 'Warning';
  lbWarnTitle2.caption := '';
End;

Procedure TfrmCapMain.PatientChangeWarningShow;
Var
    //pt : Tpoint;         //btnImageOK
  xmodalhwnd: Integer;
    //wintitle : string;
Begin
    // Below worked fine, when the panel had the main window for a parent
   (* pt.X := pnlSwitchPatientsWarn.Left;
   pt.Y := pnlSwitchPatientsWarn.Top;
   pt := pnlSwitchPatientsWarn.ScreenToClient(btnImageOK.ClientToScreen(pt));
      pnlSwitchPatientsWarn.Left := pt.X - 10 ; //left;
      pnlSwitchPatientsWarn.Top := pt.Y - 30 ; //top;
      pnlSwitchPatientsWarn.Width := 475 ;
      pnlSwitchPatientsWarn.Height := 175 ;
      lbSwitchPatientsWarn.Caption := iDModObj.GetMagPat1.M_NameDisplay;
      pnlSwitchPatientsWarn.Visible := true;
      *)

  xmodalhwnd := IsModalOpen();
  If xmodalhwnd > -1 Then
  Begin
        (* // this worked, but the Title was always ''
        getwindowtext(xmodalhwnd,pchar(wintitle),512);
        testmsg(wintitle); *)
    DestroyWindow(xmodalhwnd);
    lbWarnTitle2.caption := ' Save was Cancelled.';    {/p122 dmmn WPR Capture Item #20 /}
  End;
  pnlSwitchPatientsWarn.Left := 0;
    //pnlSwitchPatientsWarn.Top := btnImageOk.Top - 30;
  pnlSwitchPatientsWarn.Top := btnImageOK.Top - 30;
  If (pnlSwitchPatientsWarn.Top + pnlSwitchPatientsWarn.Height) > SbxEditFields.Height Then
    pnlSwitchPatientsWarn.Top := SbxEditFields.Height - pnlSwitchPatientsWarn.Height;
  If pnlSwitchPatientsWarn.Top < 0 Then
    pnlSwitchPatientsWarn.Top := 0;
  pnlSwitchPatientsWarn.Width := SbxEditFields.Width;
  pnlSwitchPatientsWarn.Visible := True;
End;

Procedure TfrmCapMain.lbImportMouseEnter(Sender: Tobject);
Begin
  LbImport.Font.Color := clBlue;
End;

Procedure TfrmCapMain.lbImportMouseLeave(Sender: Tobject);
Begin
  LbImport.Font.Color := clBlack;
End;

Procedure TfrmCapMain.IsGearControlClearofImages1Click(Sender: Tobject);
Begin
  WinMsg('', 'Is Image Box clear of an Image : ' + Magbooltostr(IsImageclear(mg1)));
End;

Procedure TfrmCapMain.mnuTESTINGSimulatePatientSwitchfromCPRS1Click(Sender: Tobject);
Var
  Xmsg, newdfn: String;
Begin
  newdfn := '1033';
  If iDModObj.GetMagPat1.SwitchTopatient(newDFN, Xmsg) Then
  Begin
    WinMsg('', 'Patient : ' + iDModObj.GetMagPat1.M_NameDisplay);

    {/ P122 with P123 patient ID additions - JK 8/11/2011 /}
    if GSess.Agency.IHS then
      WinMsg('s', '***  HRN: ' + iDModObj.GetMagPat1.M_SSN + '  DFN ' + iDModObj.GetMagPat1.M_DFN)
    else
      WinMsg('s', '***  SSN: ' + iDModObj.GetMagPat1.M_SSN + '  DFN ' + iDModObj.GetMagPat1.M_DFN);

    MagLastImagesForm.PatientInfo(iDModObj.GetMagPat1);
    Begin
      //MagPatMenu.MaxInsert := 1;
      //p117   a 94 change skipped by 106
      PatientChangeWarningIfNeeded;
    End;
        //MagPatMenu.additem(iDModObj.GetMagPat1.M_NameDisplay, strtoint(iDModObj.GetMagPat1.M_DFN), iDModObj.GetMagPat1.M_Demog);
        //         code is in Patch 5 for DFNINTFIX
    MagPatMenu.AddItem(iDModObj.GetMagPat1.M_NameDisplay, iDModObj.GetMagPat1.M_DFN, iDModObj.GetMagPat1.M_Demog);
    PtSSN.Text := iDModObj.GetMagPat1.M_SSNdisplay;
    EdtPatName.Text := iDModObj.GetMagPat1.M_NameDisplay;
  End
  Else
    WinMsg('', Xmsg);

End;

procedure TfrmCapMain.mnuTestOpenTempDirectoryinExplorerClick(Sender: TObject);
begin
magexecutefile(GUserDir.Temp, '', '', SW_SHOW);
end;

Procedure TfrmCapMain.mnuTEST2Click(Sender: Tobject);
Begin
  mnuTESTINGMAGNOTEEFILE1.Checked := Userhaskey('MAG NOTE EFILE');
  mnuTESTINGMAGSYSTEM1.Checked := Userhaskey('MAG SYSTEM');  //this TESTing menu not visible by sites.
End;
procedure TfrmCapMain.mnuTESTAccuVersionClick(Sender: TObject);
var  vIGManager: TMagIGManager;
begin
 vIGManager := GetIGManager();
  Showmessage('Accusoft : ImageGear Version ' + GetIGManager().Version);
end;

procedure TfrmCapMain.mnuTESTClosePDFFileClick(Sender: TObject);
begin
//fileclose(
end;

procedure TfrmCapMain.mnuTestEnableMultipageClick(Sender: TObject);
begin
Frmcapmain.cbALLPages.Enabled := true;       // p140 testing
AllPagesChecked(true);
end;

Procedure TfrmCapMain.mnuTESTINGMAGNOTEEFILE1Click(Sender: Tobject);
Begin
  mnuTESTINGMAGNOTEEFILE1.Checked := Not mnuTESTINGMAGNOTEEFILE1.Checked;
  AddDelKey('MAG NOTE EFILE', mnuTESTINGMAGNOTEEFILE1.Checked);
End;

Procedure TfrmCapMain.BitBtn1Click(Sender: Tobject);
Begin
  {/P122 DMMN 6/24/2011 - Close annotation panel if available when user click on cancel /}
  {/p122 dmmn WPR Capture Item #8 /}
 if AnnotationsExist then // if fCapAnnot.HasAnnotationComponent then      // P122 6/28
  begin
    {/p122 dmmn WPR Capture Item #20 /}
    MagAppMsg('s', 'Capture process was cancelled. Annotations were cleared');
  end;

  GearClear;

  // this is done in GearClear    tlbrbtnAnnotation.Enabled := False;

  PatientChangeWarningHide;
End;

Procedure TfrmCapMain.btnLongDescClick(Sender: Tobject);
Begin
  If plongDesc.Height > 22 Then
  Begin
    plongDesc.Height := 22;
    Imagelongdesc.TabStop := False;
    cbWordWrap.TabStop := False;
    ImgdblUp.Show;
    ImgdblDown.Hide;
  End
  Else
  Begin
    plongDesc.Height := 100;
    plongDesc.SetFocus;
    Imagelongdesc.TabStop := True;
    cbWordWrap.TabStop := True;
    ImgdblUp.Hide;
    ImgdblDown.Show;
  End;
End;

Procedure TfrmCapMain.RemoveSelected1Click(Sender: Tobject);
Begin
  MoveSelected(Lvbatch, LvImport1);
End;

Procedure TfrmCapMain.MoveSelected1Click(Sender: Tobject);
Begin
  MoveSelected(LvImport1, Lvbatch);
End;

Procedure TfrmCapMain.MoveAll1Click(Sender: Tobject);
Begin
  ImportBatchMoveAll;
End;

Procedure TfrmCapMain.popupImportListPopup(Sender: Tobject);
Begin
  mnuviewDetails.Visible := Not pnllstImport.Visible;
  mnuviewList.Visible := Not pnllstImport.Visible;
  MnuRefresh.Visible := Not pnllstImport.Visible;
  mnuImageProperties.Visible := Not pnllstImport.Visible;
End;

Procedure TfrmCapMain.edtPatNameDblClick(Sender: Tobject);
Var
  Rmsg: String;
Begin
  If ((userCapname = 'KIRIN,GARRETT EDWARD') And (UserCapDUZ = '1216'))
    Or
    ((userCapname = 'USER,IMAGINGONE') And (UserCapDUZ = '1216')) Then
  Begin
    If Not iDModObj.GetMagPat1.SwitchTopatient('1033', Rmsg) Then
      Exit;
    MagPatMenu.AddItem(iDModObj.GetMagPat1.M_NameDisplay, iDModObj.GetMagPat1.M_DFN, iDModObj.GetMagPat1.M_Demog);
    PtSSN.Text := iDModObj.GetMagPat1.M_SSNdisplay;
    EdtPatName.Text := iDModObj.GetMagPat1.M_NameDisplay;
    UpdateWindowcaption;
  End;
End;

Procedure TfrmCapMain.Reset1Click(Sender: Tobject);
Begin
  GearReset;
End;

Procedure TfrmCapMain.FlipVertical1Click(Sender: Tobject);
Begin
  GearFlipV;
End;

Procedure TfrmCapMain.FlipHorizontal1Click(Sender: Tobject);
Begin
  GearFlipH;
End;

Procedure TfrmCapMain.RotateLeft1Click(Sender: Tobject);
Begin
  GearRotate(270);
End;

Procedure TfrmCapMain.RotateRight1Click(Sender: Tobject);
Begin
  GearRotate(90);
End;

Procedure TfrmCapMain.DeSpeckle1Click(Sender: Tobject);
Begin
  GearDeSpeckle();
End;

Procedure TfrmCapMain.DeSkew1Click(Sender: Tobject);
Begin
  GearDeSkew();
End;

Procedure TfrmCapMain.RotateLeft2Click(Sender: Tobject);
Begin
  GearRotate(270);
End;

Procedure TfrmCapMain.FitToWindow2Click(Sender: Tobject);
Begin
  GearFitToWin;
End;

Procedure TfrmCapMain.MousePan2Click(Sender: Tobject);
Begin
  GearMousePan;
    //Gear 1.Cursor := crHandPoint;
End;

Procedure TfrmCapMain.Rotate1801Click(Sender: Tobject);
Begin
  GearRotate(180);
End;

Procedure TfrmCapMain.Pointer1Click(Sender: Tobject);
Begin
  GearMousePointer;
End;

Procedure TfrmCapMain.MnuImageToolbarClick(Sender: Tobject);
Begin
  MnuImageToolbar.Checked := Not MnuImageToolbar.Checked;
  tlbarImage.Visible := MnuImageToolbar.Checked;
  FImageTB := MnuImageToolbar.Checked;
End;

Procedure TfrmCapMain.GearRotate(degree: Integer);
Var
  Xdeg: Integer;
  rotatestr : string;
  rotatepg : integer;
  rotatefilename: string;
Begin
  Try
    If isgearClear(mg1) Then
      Exit;
    Xdeg := (degree Div 90);
    mg1.update;
    MagAspectRatio(1);
    Application.Processmessages;
    AccusoftPropertiesLog('Before Rotate: RotateGear');
    mg1.Rotate(degree);
    FModROT := FModROT + Xdeg;
    FImageChanged := True;

    {129t10   NOTE:: we didn't use this cMag4VGear control in previous capture Apps.
      For Multipage images we used a Gear99 version of LoadDocument.
      Now we're using LoadPage, due to using cMag4VGear,
      this workaround is not efficient.  but will work for now..}

    rotatestr := 'Roatate Page: ' + inttostr(mg1.Page) + '  PageCount: '   + inttostr(mg1.PageCount);
    magappmsg('s',rotatestr);
    //showmessage(inttostr(FmIGSaveFormat));  //  FmIGSaveFormat := mag_IG_SAVE_TIF_G4;
    //PRE 129T18   if (mg1.PageCount > 1)   ....   will multipage.tif   cause issues
     //   Duc's CHANGES.  140 Refactor might be needed.
    if (mg1.PageCount > 1) or (FileExists(GUserDir.Temp + 'multipage.tif')) then
    begin
      rotatepg := mg1.Page - 1 ;
      rotatefilename := mg1.ImageFilename;
           // getIGManager.IGFormatsCtrl.savePageToFile(mg1.GetCurrentPage,rotatefilename,rotatepg,IG_PAGESAVEMODE_REPLACE,IG_SAVE_UNKNOWN);
      getIGManager.IGFormatsCtrl.savePageToFile(mg1.GetCurrentPage,rotatefilename,rotatepg,IG_PAGESAVEMODE_REPLACE,CapX.mIGSaveFormat);
    end;
    (*  example code :
        getIGManager.IGFormatsCtrl.savePageToFile(mg1.GetCurrentPage,tfilename,0,IG_PAGESAVEMODE_APPEND,IG_SAVE_UNKNOWN);
        // Constants for enum enumIGPageSaveModes
        type
          enumIGPageSaveModes = TOleEnum;
        const
          IG_PAGESAVEMODE_DEFAULT = $00000000;
          IG_PAGESAVEMODE_OVERWRITE = $00000001;
          IG_PAGESAVEMODE_APPEND = $00000002;
          IG_PAGESAVEMODE_INSERT = $00000003;
          IG_PAGESAVEMODE_REPLACE = $00000004;
    *)

    //p122t11 dmmn - tracking manip
    { TODO -o129 : this is another Fannot..Manip, that we're not using ..Check}
    if FAnnotationManips = nil then
      FAnnotationManips := TStringList.Create();

    if degree = 270 then
      FAnnotationManips.Add('IG_ROTATE_270')
    else if degree = 90 then
      FAnnotationManips.Add('IG_ROTATE_90');
    //FTRCImageManips := True;    //p122t12
  Finally
    If ErrorInGear(mg1, 'Rotate', 'ImageGear: Rotating Image') Then        {in GearRotate}
      WinMsg('', 'Accusoft error during Rotate.');
  End;
End;

Procedure TfrmCapMain.PastefromClipboard1Click(Sender: Tobject);
Begin
  GearCapPasteFromClip;
End;

Procedure TfrmCapMain.CopytoClipboard1Click(Sender: Tobject);
Begin
  Self.GearCopy;
End;

Procedure TfrmCapMain.DeSkew2Click(Sender: Tobject);
Begin
  Self.GearDeSkew;
End;

Procedure TfrmCapMain.DeSpeckle2Click(Sender: Tobject);
Begin
  Self.GearDeSpeckle;
End;

Procedure TfrmCapMain.OpenPanWindow2Click(Sender: Tobject);
Begin
  Self.GearPanWindow;
End;

Procedure TfrmCapMain.Invert2Click(Sender: Tobject);
Begin
  Self.GearInvert;
End;

Procedure TfrmCapMain.Reset2Click(Sender: Tobject);
Begin
  Self.GearReset;
  {/p122 dmmn 8/16 - reset/close all annotation
  {/p122 dmmn WPR Capture Item #8 /}
  if AnnotationsExist() then  //    if fCapAnnot.HasAnnotationComponent then
        AnnotationsClose(); // fCapAnnot.Close;  *)
End;

Procedure TfrmCapMain.Clear1Click(Sender: Tobject);
Begin
  Self.GearClear;
End;

Procedure TfrmCapMain.Pan1Click(Sender: Tobject);
Begin
  Self.GearMousePan;
End;

Procedure TfrmCapMain.Magnify1Click(Sender: Tobject);
Begin
  Self.GearMouseMagnify;
End;

Procedure TfrmCapMain.Zoom1Click(Sender: Tobject);
Begin
  Self.GearMouseZoomSelect;
End;

Procedure TfrmCapMain.Pointer2Click(Sender: Tobject);
Begin
  Self.GearMousePointer;
End;

Procedure TfrmCapMain.Window1Click(Sender: Tobject);
Begin
(*p129 out
  if fCapAnnot.Visible then
  begin
    {/p122 dmmn 8/16/11 - fit height annotation panel /}
    fCapAnnot.tlbrbtnFitAllClick(Sender);
  end
  else
  *)

  begin
    Self.GearFitToWin;
  end;
End;

Procedure TfrmCapMain.Height1Click(Sender: Tobject);
Begin
(*p129 out
  if fCapAnnot.Visible then
  begin
    {/p122 dmmn 8/16/11 - fit height annotation panel /}
    fCapAnnot.tlbtnFitHeightClick(Sender);
  end
  else
  *)
  begin
    Self.GearFitToHeight;
  end;
End;

Procedure TfrmCapMain.mnuFitToWidth1Click(Sender: Tobject);
Begin
(*p129 out
  if fCapAnnot.Visible then
  begin
    {/p122 dmmn 8/16/11 - fit width annotation panel /}
    fCapAnnot.tlbrbtnFitWidthClick(Sender);
  end
  else
  *)

  begin
    Self.GearFitToWidth;
    GearScrollTL;
  end;
End;

Procedure TfrmCapMain.ActualSize1Click(Sender: Tobject);
Begin
(*p129 out
  if fCapAnnot.Visible then
  begin
    {/p122 dmmn 8/16/11 - fit width annotation panel /}
    fCapAnnot.tlbrbtnFitActualClick(Sender);
  end
  else
*)

  begin
    Self.GearFitToActualSize;
  end;
End;

Procedure TfrmCapMain.Right2Click(Sender: Tobject);
Begin
  Self.GearRotate(90);
End;

Procedure TfrmCapMain.Left2Click(Sender: Tobject);
Begin
  Self.GearRotate(270);
End;

Procedure TfrmCapMain.N18901Click(Sender: Tobject);
Begin
  Self.GearRotate(180);
End;

Procedure TfrmCapMain.FilpHorizontal1Click(Sender: Tobject);
Begin
  Self.GearFlipH;
End;

Procedure TfrmCapMain.FlipVertical2Click(Sender: Tobject);
Begin
  Self.GearFlipV;
End;

Procedure TfrmCapMain.tlbrbtnPointerClick(Sender: Tobject);
Begin
  GearMousePointer;
End;

Procedure TfrmCapMain.mnuImageClick(Sender: Tobject);
Begin
  OpenPanWindow2.Checked := mg1.PanWindow;
End;

Procedure TfrmCapMain.OpenPanWindow1Click(Sender: Tobject);
Begin
  GearPanWindow;
End;

Procedure TfrmCapMain.mnuHideToolbarConfigsClick(Sender: Tobject);
Begin
  mnuHideToolbarConfigs.Checked := Not mnuHideToolbarConfigs.Checked;
  FSavedConfigsTB := Not mnuHideToolbarConfigs.Checked;
  TabCtr.Visible := FSavedConfigsTB;
End;

Procedure TfrmCapMain.ShowOpenForms1Click(Sender: Tobject);
Begin
  Showopenforms;
End;
(*

      xmodalhwnd := IsModalOpen();
      if  xmodalhwnd > -1 then
         begin
           //testmsg('Modal is Open');
           // here we can kill the Open Dialog.
           DestroyWindow(xmodalhwnd);
           lbWarnTitle2.Caption := ' Save was Cancelled.';
         end ;

*)

Procedure TfrmCapMain.oolbars1Click(Sender: Tobject);
Begin
    //Multi-Line Config Buttons
  mnumultilinebuttons2.Checked := TabCtr.Multiline;
End;

Procedure TfrmCapMain.mnumultilinebuttons2Click(Sender: Tobject);
Begin
  mnumultilinebuttons2.Checked := Not mnumultilinebuttons2.Checked;
  TabCtr.Multiline := mnumultilinebuttons2.Checked;
  FSavedConfigsMultiLine := mnumultilinebuttons2.Checked;
  RedisplayMultiline;
End;

Procedure TfrmCapMain.tlbrbtnBritePlusClick(Sender: Tobject);
Var
  s: String;
Begin
(* This function was never implemented in Capture.
  //FTRCImageManips := True; // p122t12
  If Gear 1.DisplayBrightness = 0 Then
    Gear 1.Brightness := 0.1;
  If Gear 1.DisplayBrightness < 0 Then
    Gear 1.DisplayBrightness := Gear 1.DisplayBrightness - (Gear 1.DisplayBrightness * 0.1)
  Else
    Gear 1.DisplayBrightness := (Gear 1.DisplayBrightness * 1.1);
  s := Inttostr(Trunc(100 * Gear 1.DisplayBrightness));
  WinMsg('', s);
  *)
End;

Procedure TfrmCapMain.tlbrbtnBriteMinusClick(Sender: Tobject);
Var
  s: String;
Begin
(* This function was never implemented in Capture.
  //FTRCImageManips := True; // p122t12
  If Gear 1.DisplayBrightness = 0 Then
    Gear 1.Brightness := -0.1;
  If Gear 1.DisplayBrightness > 0 Then
    Gear 1.DisplayBrightness := Gear 1.DisplayBrightness - (Gear 1.DisplayBrightness * 0.1)
  Else
    Gear 1.DisplayBrightness := (Gear 1.DisplayBrightness * 1.1);
  s := Inttostr(Trunc(100 * Gear 1.DisplayBrightness));
  WinMsg('', s);
*)
End;

Procedure TfrmCapMain.mnuTESTINGMAGSYSTEM1Click(Sender: Tobject);
Begin
  mnuTESTINGMAGSYSTEM1.Checked := Not mnuTESTINGMAGSYSTEM1.Checked;
  AddDelKey('MAG SYSTEM', mnuTESTINGMAGSYSTEM1.Checked);
End;

Procedure TfrmCapMain.btnVLDef1Click(Sender: Tobject);
Var
  visloc: String;
Begin
  If SearchVistAFile('44', 'Visit Location', 'Enter a few characters of the name, press <Enter>'
    , 'Search for Visit Location', '', True, visloc) Then
  Begin
    FCapClinDataObj.NewLocation := MagPiece(visloc, '^', 2);
    FCapClinDataObj.NewLocationDA := MagPiece(visloc, '^', 1);
    LoadFieldsFromTIUData(FCapClinDataObj);
  End;
End;

Procedure TfrmCapMain.btnVLDefClick(Sender: Tobject);
Begin
  SelectVisitLocation;
End;

Procedure TfrmCapMain.SelectVisitLocation;
Var
  visloc: String;
Begin
  If SearchVistAFile('44', 'Visit Location', 'Enter a few characters of the name, press <Enter>'
    , 'Search for Visit Location', '', True, visloc) Then
  Begin
    FCapClinDataObj.NewLocation := MagPiece(visloc, '^', 2);
    FCapClinDataObj.NewLocationDA := MagPiece(visloc, '^', 1);
    LoadFieldsFromTIUData(FCapClinDataObj);
  End;
End;

Procedure TfrmCapMain.LoadClinicalDataFromConfiguration(vClinDataStr: String);
Begin
  FCapClinDataObj.LoadFromClinDataStr(vClinDataStr);
    {a Configuration has just been applied to the FCapClinDataObj
      now we must check the Visit Location default order if appropriate.}
  FCapClinMgr.SetVLocDefault2(FCapClinDataObj, FuPrefCapTIU, MSetWrks1);
    //testmsg(FCapClinDataoBJ.NewAuthor);
    (*    if FCapClinDataObj.Pkg <> '8925' then exit;
        {       If not using defaults, we erase the VLoc}
    if not FuPrefCapTiu.UseDefaultLoc then
      begin
      FCapClinDataObj.NewLocation := '';
      FCapClinDataObj.NewLocationDA := '';
      exit;
      end;
        {       We're using Defaults.  If null, then there wasn't any Location
                defined in the Configuration.  So 1st try User default then Wrks.}
    if FCapClinDataObj.NewLocation = '' then
      begin
      if FUprefCapTiu.DefaultLoc <> '' then
         begin
         FCapClinDataObj.NewLocation := FuPrefCapTiu.DefaultLocName;
         FCapClinDataObj.NewLocationDA := FuPrefCapTiu.DefaultLocDA;
         end
         else { user's Default Location is '' try wrks default}
         if MSetWrks1.VLoc <> '' then
            begin
            FCapClinDataObj.NewLocation := MsetWrks1.VLocName;
            FCapClinDataObj.NewLocationDA := MsetWrks1.VLocDA;
            end;

      end;

  *)

End;

Procedure TfrmCapMain.ApplicationEvents1ShowHint(Var HintStr: String;  Var CanShow: Boolean; Var HintInfo: THintInfo);
Begin
  hintinfo.HideTimeout := 14000;
  hintinfo.ReshowTimeout := 500;
End;

Function TfrmCapMain.ApplicationEvents1Help(Command: Word; Data: Integer; Var CallHelp: Boolean): Boolean;

Var
  s, Helpdoc: String;
  Flags: OLEVariant;
  fullfile: String;
Begin
  Result := False;
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
                       // This was 93, now we're back to above,  for 72
                       //magExecuteFile(AppPath + '\Help\Client\VIHelpv008.htm', '', '', SW_SHOW)
          End
          Else
          Begin
            Helpdoc := FrmWebHelpMapping.ValueListEditor1.Values[Inttostr(Data)];
                        // This was 93, now we're back to above,  for 72
                        // {p93  In patch 93, the HTML files are all in root directory}
                        //helpdoc := extractfilename(helpdoc);
            Magexecutefile(AppPath + '\Help\Client\' + Helpdoc, '', '', SW_SHOW);
          End;
        End
        Else
        Begin
          FrmWebHelp.execute;
          Helpdoc := FrmWebHelpMapping.ValueListEditor1.Values[Inttostr(Data)];
                    // frmWebHelp.WebBrowser1.Navigate(WideString(AppPath + '\Help\Client\index.htm#' + helpdoc),Flags, Flags, Flags, Flags);
                    // This was 93, now we're back to above,  for 72
                    {   in patch 93 the help files are in the 'client' directory, not subdirectories.}
                    //helpdoc := extractfilename(helpdoc);
          fullfile := AppPath + '\Help\Client\' + Helpdoc;
          FrmWebHelp.WebBrowser1.Navigate(WideString(fullfile), Flags, Flags, Flags, Flags);
        End;
        CallHelp := False;
      End;
  Else
    s := 'SOMETHING_ELSE';
  End;

  WinMsg('s', 'Help : ' + s + '  ' + Inttostr(Data));
  Result := True;
End;

procedure TfrmCapMain.mnuClearAllAnnotationsClick(Sender: TObject);
begin
mg1.AnnotationComponent.ClearAllAnnotations;
end;

Procedure TfrmCapMain.mnuClearConfigurationvaluesClick(Sender: Tobject);
Var
  Rmsg: String;
Begin
  FrmConfigList.ApplyClearConfiguration(Rmsg);
End;

(*
Procedure TfrmCapMain.Gear1ScanAfterDoc(ASender: Tobject; PageCount,  ADFLoaded: Integer);
Begin
    //
  WinMsg('', 'Gear1ScanAfterDoc ');
  WinMsg('', ' - ');
    // test rpc after Doc
    // RPMaggUserKeys(SecurityKeys);
    //  maggmsgf.magmsgs('s',SecurityKeys);
End;
*)
Procedure TfrmCapMain.KeepAliveRPCCall1Click(Sender: Tobject);
Begin
  KeepAliveRPCCall1.Checked := Not KeepAliveRPCCall1.Checked;
End;

Procedure TfrmCapMain.Other1Click(Sender: Tobject);
Begin

  DisplayConfigValues(FrmCapConfig.GOther, Otherdesc.Left, Otherdesc.Top + Otherdesc.Height,
    'Other:');

End;

Procedure TfrmCapMain.Defaults1Click(Sender: Tobject);
Begin
  OptionWindowSetSettings;
  FrmCapSettings.PgctrlSettings.ActivePage := FrmCapSettings.PgctrlSettings.Pages[3];
  FrmCapSettings.Showmodal;
  OptionWindowGetSettings;
End;

Procedure TfrmCapMain.mnuSelectLocation1Click(Sender: Tobject);
Begin
  SelectVisitLocation;
End;

Procedure TfrmCapMain.NewNoteDefaults1Click(Sender: Tobject);
Begin
  mnuSelectLocation1.Enabled := (btnVLDef.Enabled And btnVLDef.Visible);
End;

Procedure TfrmCapMain.mnuPageFirst1Click(Sender: Tobject);
Begin
  GoToPage(1);

  {/p122 dmmn 8/16/11 - page control for annotation panel /}
(*p129 out
  if fCapAnnot.Visible then
    fCapAnnot.tlbrbtnPageFirstClick(nil);
*)
End;

Procedure TfrmCapMain.mnuPagePrev1Click(Sender: Tobject);
Begin
  if mg1.Page > 1 then

  begin
    GoToPage(mg1.Page - 1);

    {/p122 dmmn 8/16/11 - page control for annotation panel /}
(*p129 out
    if fCapAnnot.Visible then
      fCapAnnot.tlbrbtnPagePrevClick(nil);
    *)
  end;
End;

Procedure TfrmCapMain.mnuPageNext1Click(Sender: Tobject);
Begin

  if mg1.page < mg1.pagecount then

  begin
    GoToPage(mg1.Page + 1);
    {/p122 dmmn 8/16/11 - page control for annotation panel /}
(*p129 out
    if fCapAnnot.Visible then
      fCapAnnot.tlbrbtnPageNextClick(nil);
      *)
  end;
End;

Procedure TfrmCapMain.mnuPageLast1Click(Sender: Tobject);
Begin
//GoToPage(Gear 1.pagecount);
  GoToPage(mg1.PageCount);
  {/p122 dmmn 8/16/11 - page control for annotation panel /}
(*p129 out
  if fCapAnnot.Visible then
    fCapAnnot.tlbrbtnPageLastClick(nil);
    *)

End;


//p129 dmmn 12/11/12
// Scrolling for the new Accusoft Gear
//              -99999
//                 |
//                 |
//  -99999--------0,0----------99999
//                 |
//                 |
//               99999

Procedure TfrmCapMain.MnuScrollLeftClick(Sender: Tobject);
Begin
  //p129 dmmn 12/11/12 - using same mechanism as display for scrolling
  mg1.ScrollLeft();

End;

Procedure TfrmCapMain.MnuScrollUpClick(Sender: Tobject);
Begin
  //p129 dmmn 12/11/12 - using same mechanism as display for scrolling
  mg1.ScrollUp();
End;

Procedure TfrmCapMain.MnuScrollDownClick(Sender: Tobject);
Begin
  //p129 dmmn 12/11/12 - using same mechanism as display for scrolling
  mg1.ScrollDown();
End;

Procedure TfrmCapMain.MnuScrollRightClick(Sender: Tobject);
Begin
  //p129 dmmn 12/11/12 - using same mechanism as display for scrolling
  mg1.ScrollRight();
End;

Procedure TfrmCapMain.MnuScrollToCornerBLClick(Sender: Tobject);
Begin
  mg1.SetScrollPos(999999,-999999);   // p129 dmmn 12/11/12 BL is min hor, max vert

(*//p129  vert := Gear 1.ImageHeight;
//p129  Gear 1.SetScrollPos(0, 4, 0);
//p129  Gear 1.SetScrollPos(1, 4, vert);
     mg1.SetScrollPos(-999999,-999999);*)
End;

Procedure TfrmCapMain.MnuScrollToCornerBRClick(Sender: Tobject);
Begin
  mg1.SetScrollPos(999999,999999);    // p129 dmmn 12/11/12 BR is max hor, max vert
(*
//p129  vert := Gear 1.ImageHeight;
//p129  horiz := Gear 1.ImageWidth;
//p129  Gear 1.SetScrollPos(0, 4, horiz);
//p129  Gear 1.SetScrollPos(1, 4, vert);
     mg1.SetScrollPos(999999,-999999);*)
End;

Procedure TfrmCapMain.MnuScrollToCornerTLClick(Sender: Tobject);
Begin
  GearScrollTL;
End;

Procedure TfrmCapMain.GearScrollTL;
Begin
  mg1.SetScrollPos(-999999,-999999);    // p129 dmmn 12/11/12 TL is negative on both axis

(*
//p129  Gear 1.SetScrollPos(0, 4, 0);
//p129  Gear 1.SetScrollPos(1, 4, 0);
     mg1.SetScrollPos(-999999,999999);
*)

End;

Procedure TfrmCapMain.MnuScrollToCornerTRClick(Sender: Tobject);
Begin
  mg1.SetScrollPos(-999999,999999);    // p129 dmmn 12/11/12 TR is min vertical max horizontal

(*
//p129  horiz := Gear 1.ImageWidth;
//p129  Gear 1.SetScrollPos(0, 4, horiz);
//p129  Gear 1.SetScrollPos(1, 4, 0);
       mg1.SetScrollPos(999999,999999);
*)
End;

Procedure TfrmCapMain.mnuContrastMore1Click(Sender: Tobject);
Begin
  If ((TbicContrast.Position + 5) > TbicContrast.Max) Then
    TbicContrast.Position := TbicContrast.Max
  Else
    TbicContrast.Position := TbicContrast.Position + 5;
End;

Procedure TfrmCapMain.mnuContrastLess1Click(Sender: Tobject);
Begin
  If ((TbicContrast.Position - 5) < 0) Then
    TbicContrast.Position := 0
  Else
    TbicContrast.Position := TbicContrast.Position - 5;
End;

Procedure TfrmCapMain.mnuBrightnessMore1Click(Sender: Tobject);
Begin
  If ((TbicBrightness.Position + 15) > TbicBrightness.Max) Then
    TbicBrightness.Position := TbicBrightness.Max
  Else
    TbicBrightness.Position := TbicBrightness.Position + 15;
End;

Procedure TfrmCapMain.mnuBrightnessLess1Click(Sender: Tobject);
Begin
  If ((TbicBrightness.Position - 15) < TbicBrightness.Min) Then
    TbicBrightness.Position := TbicBrightness.Min
  Else
    TbicBrightness.Position := TbicBrightness.Position - 15;
End;

Procedure TfrmCapMain.ZoomIn3Click(Sender: Tobject);
Begin
(*p129 out
  if fCapAnnot.Visible then
  begin
    {/p122 dmmn 8/16/11 - zoom in annotation panel /}
    fCapAnnot.tlbrZoomInClick(Sender);
  end
  else
  *)

  begin
    If ((TbicZoom.Position + 15) > TbicZoom.Max) Then
        SetZoomLevel(TbicZoom.Max)
    Else
      SetZoomLevel(TbicZoom.Position + 15);
  end;
End;

Procedure TfrmCapMain.ZoomOut3Click(Sender: Tobject);
Begin
(*p129 out
  if fCapAnnot.Visible then
  begin
    {/p122 dmmn 8/16/11 - zoom out annotation panel /}
    fCapAnnot.tlbrZoomOutClick(Sender);
  end
  else
  *)

  begin
    If ((TbicZoom.Position - 15) < 0) Then
      SetZoomLevel(0)
    Else
      SetZoomLevel(TbicZoom.Position - 15);
  end;
End;

Procedure TfrmCapMain.DestroyTIUNoteWindow1Click(Sender: Tobject);
Begin
  If Doesformexist('frmCapTIU') Then
    FrmCapTIU.Release;
End;

Procedure TfrmCapMain.WebHelp1Click(Sender: Tobject);
Begin
  FrmWebHelp.Execute;
  FrmWebHelpMapping.Execute;
End;

Procedure TfrmCapMain.UseOldHelp1Click(Sender: Tobject);
Begin
  Magexecutefile(AppPath + '\MagImaging.hlp', '', '', SW_SHOW);
End;

Procedure TfrmCapMain.MnuUseInternetExplorerforhelpClick(Sender: Tobject);
Begin
  MnuUseInternetExplorerforhelp.Checked := Not MnuUseInternetExplorerforhelp.Checked;
End;

Procedure TfrmCapMain.MnuMessageLogClick(Sender: Tobject);
Begin
  MagAppMsgShow;
End;

Procedure TfrmCapMain.lbviewingImageMouseEnter(Sender: Tobject);
Begin
  If Not FCapClinMgr.FtestmessagesOn Then
    Exit;
  If FileExists(Lbviewingimage.caption) Then
    ShowImageProperties(Lbviewingimage.caption, True);
End;

Procedure TfrmCapMain.lbviewingImageMouseLeave(Sender: Tobject);
Begin
  If Not FCapClinMgr.FtestmessagesOn Then
    Exit;
  frmCapInfoWindow.LbImageProperties.caption := '';
  frmCapInfoWindow.Hide;
End;

Procedure TfrmCapMain.lbBlankfillMouseEnter(Sender: Tobject);
Begin
  If Not FCapClinMgr.FtestmessagesOn Then
    Exit;
  If FileExists(Lbviewingimage.caption) Then
    ShowImageProperties(Lbviewingimage.caption, True);
End;

Procedure TfrmCapMain.lbBlankfillMouseLeave(Sender: Tobject);
Begin
  If Not FCapClinMgr.FtestmessagesOn Then
    Exit;
  frmCapInfoWindow.LbImageProperties.caption := '';
  frmCapInfoWindow.Hide;
End;

Procedure TfrmCapMain.ACCU321INFOMouseEnter(Sender: Tobject);
Begin
  If Not FCapClinMgr.FtestmessagesOn Then
    Exit;
  If FileExists(Lbviewingimage.caption) Then
    ShowImageProperties(Lbviewingimage.caption, True);
End;

Procedure TfrmCapMain.ACCU321INFOMouseLeave(Sender: Tobject);
Begin
  If Not FCapClinMgr.FtestmessagesOn Then
    Exit;
  frmCapInfoWindow.LbImageProperties.caption := '';
  frmCapInfoWindow.Hide;
End;

Procedure TfrmCapMain.Login1Click(Sender: Tobject);
Var
  vs, vp, Xmsg: String;
Begin
{ DONE  -o129 : quick backdoor to connect...been here forever, 
                        do we need to get it out ?  }

End;

(*  RCA out.
Procedure TfrmCapMain.OpenViewerSortWindow;
Var
  i: Integer;
  Li: TListItem;
  t: TStrings;
Begin

  If Not Assigned(FrmViewerSort) Then
    Application.CreateForm(TfrmViewerSort, FrmViewerSort);
  FrmViewerSort.Show;
  t := Tstringlist.Create;
  Try


        //li := nil;
    For i := 0 To LvImport1.Items.Count - 1 Do
    Begin
      Li := LvImport1.Items[i];
      t.Add(Li.SubItems[3] + '\' + Li.caption);
            //  li.delete;
    End;
    FrmViewerSort.Mag4ViewerImport.ViewDirectoryImages(t);
    For i := 0 To Lvbatch.Items.Count - 1 Do
    Begin
      Li := Lvbatch.Items[i];
      t.Add(Li.SubItems[3] + '\' + Li.caption);
            //  li.delete;
    End;
    FrmViewerSort.Mag4ViewerBatch.ViewDirectoryImages(t);
  Finally
    t.Free;
  End;

End;
*)

Procedure TfrmCapMain.OpenViewerSortWindow1Click(Sender: Tobject);
Begin
//RCA out OpenViewerSortWindow;
End;

Procedure TfrmCapMain.timerStayAliveTimer(Sender: Tobject);
Var
  Min: String;
Begin
  MagAppMsg('', 'StayAliveTimer call ' + DateTimeToStr(Now));
  iDModObj.GetMagDBBroker1.RPMaggGetTimeout('CAPTURE', Min);
End;

Procedure TfrmCapMain.mnutestPatientOverlayClick(Sender: Tobject);
Begin
  //p129 out  OverlayPatInfo;
End;



Function TfrmCapMain.GetDefaultOriginIndex: Integer;
Var
  Magini: TIniFile;
  i: Integer;
  s: String;
Begin
  Magini := TIniFile.Create(GetConfigFileName);
  Try

    s := GetIniEntry('Workstation settings', 'DefaultOriginIndexValue');
    If s = '' Then
      s := 'VA';
    i := cbOrigin.Items.Indexof(s);
    If i = -1 Then
      i := 0;
    Result := i;
  Finally
    Magini.Destroy;
  End;
End;

Procedure TfrmCapMain.mnuCapControlledImageClick(Sender: Tobject);
Begin
  ControlledImageToggle;
End;

Procedure TfrmCapMain.ControlledImageToggle;
Begin
  FcontrolledImage := Not FcontrolledImage;
  lbControlledImage.Top := btnCapture.Top + 3;
  lbControlledImage.Visible := FcontrolledImage;

End;

Procedure TfrmCapMain.ControlledImage(Value: Boolean);
Begin
  FcontrolledImage := Value;
  lbControlledImage.Top := btnCapture.Top + 3;
  lbControlledImage.Visible := FcontrolledImage;
End;

Procedure TfrmCapMain.mnuCapUtilitiesClick(Sender: Tobject);
Begin
  mnuCapControlledImage.Checked := FControlledImage;
End;

Procedure TfrmCapMain.imeout10seconds1Click(Sender: Tobject);
Begin
  timeouttimer.Interval := 10000;
End;

Procedure TfrmCapMain.LOOKUPTRConsult(Sender: Tobject);
Begin
  Try
    {/106  needs Spec and Proc required.}
(*  this is done in the 'INIT...' function for the Association, the labels are already
      visible before this call.
    LbIndexSpecSubSpec.caption := '*Specialty';
    LbIndexProcEvent.caption := '*Proc/Event'; *)
    //p106 end.
    { TODO -ogek -cConsistancy : .. all 'Lookups' need to work same.  This isn't a  TRC
            issue, it something to look into after 117.
             we need to make sure all Assoc lookups either clear on button click or not.  }

    DateTimeProc := '';
    EdtProcDate.Text := '';
    TRConsultDataString := '';
    TRConsultDate := '';
    TRConsultPtr := '';
    TRConsultService := '';
    (* p117 if patient not selected,  open Patient selection
      If Not IsPatientSelected Then Exit; *)
      If Not IsPatientSelected(False) Then
      Begin
        OpenPatient;
        If Not IsPatientSelected(False) Then
          Exit;
      End;

    If Not CanUserCapture(Magassoc) Then Exit;
    If TRConsultExecute(iDModObj.GetMagPat1, TRConsultDataString, TRConsultDate, TRConsultService) Then
    Begin
      TRCImageCtr := 0;
      edtDicombyUser.Clear;
      FDicomDataUserArray.Clear;
      FDicomdataArray.Clear;
      //p117  do we want to Clear Default array ?  ...No,  not here.
      //FDicomDefaultsArray.Clear;
      //  TRConsultPtr := DataString;  This (TRConsultPtr)is set in next Call. ;
      LoadFieldsFromTRConsultData(TRConsultDataString);
      FEdtLV.GenGoToNextControl(btnLookupdata);
    End;
  Except
    TRConsultPtr := '';
  End;
End;

Procedure TfrmCapMain.LoadFieldsFromTRConsultData(DataString: String);
Var
  consentform: String;
  sgConsultDate: String;
  dtDate: Tdatetime;
Begin
  sgConsultDate := '';
  If TRConsultDate <> '' Then
  Begin
    //p106 rlm CR604 Start
    //Try
      //dtDate := Strtodate(TRConsultDate);
      //sgConsultDate := Formatdatetime('mmm d, YYYY', dtDate);
    sgConsultDate := ShowFmDateMMMNoTime(TRConsultDate);
    //Except
    //End;
    //p106 rlm CR604 End
  End;
  TRConsultPtr := DataString;
  //106T11 start
  //106 out  EdtStudy.Text := 'TRC ';
  TRConsultService := MagPiece(DataString, '^', 4); //p106 rlm 20101228 CR642 "Study Performed : info displayed"
  EdtStudy.Text := TRConsultService; //p106 rlm 20101228 CR642 "Study Performed : info displayed"
  EdtImageDesc.Text := TRConsultService; //p106 rlm 20101228 CR642 "Study Performed : info displayed"
  //106T11 end 
  DateTimeProc := TRConsultDate;
  EdtProcDate.Text := sgConsultDate;
  {/p117 t5(6)  'ShowTagFields' is a call made by each 'INITxxxxxxx' call. It is the method that Enables/Disables
                 the fields in the GUI based on Association.  individual fields shouldn't be enabled/disabled
                 outside that method. }
  // btnProcDate.Visible := True;   //117 out,  disaled/enabled is done in the INIT ..ShowTagFields call
  {/p117 T5(6) gek 4/21/11  - stop enabling the Proc Date Selection  when a Consult is selected !}
  //btnProcDate.Enabled := True;   //117 out. Stop allowing Date Change for a Selected Consult.
  //117t5 EdtType.Enabled := True;    //117 out,  disaled/enabled is done in the INIT ..ShowTagFields call
  //EdtType.Text := 'Image'; //p106 rlm 20070804
  //SetSelected(LvType, 'Image');//p106 rlm 20070804
  //EdtSpecSubSpec.Enabled := True;      //117 out,  disaled/enabled is done in the INIT ..ShowTagFields call
  //106T11 out  TRConsultService := 'DERMATOLOGY';
  TRCStudyUID := GetStudyUID(XBROKERX, iDModObj.GetMagPat1.M_DFN, MagPiece(TRConsultPtr, '^', 1));
  TRCSeriesUID := GetSeriesUID(XBROKERX, iDModObj.GetMagPat1.M_DFN, MagPiece(TRConsultPtr, '^', 1), TRCStudyUID);
  TRCSeriesNum := GetSeriesNumber(XBROKERX);
  TRCSOPInstanceUID := '';
  //If Not
  TRCGetSOPIEN('TELEDERM', TRCSOPClass, TRCSOPClassIEN, TRCErrorMsg);
  //Then ;
  //SetSelected(LvSpecSubSpec, TRConsultService);//p106 rlm 20070804
  //EdtSpecSubSpec.Text := TRConsultService;//p106 rlm 20070804
  //edtSpecSubSpecExit(Nil);//p106 rlm 20070804
  Application.Processmessages();
  EdtProcEvent.Enabled := True;
  //SetSelected(LvProcEvent, 'PHOTOGRAPHY');//p106 rlm 20070804
  //EdtProcEvent.Text := 'PHOTOGRAPHY';//p106 rlm 20070804
  edtProcEventExit(Nil);
  //EdtImageDesc.Text := TRConsultService;//p106 rlm 20070804
End;


Procedure TfrmCapMain.SetSelected(LV: TListView; Value: String);
Var
  i: Integer;
  Item: TListItem;
Begin
  If Trim(Value) = '' Then Exit;
  For i := 0 To LV.Items.Count - 1 Do
  Begin
    Item := LV.Items[i];
    If Lowercase(Item.caption) = Lowercase(Value) Then
    Begin
      LV.Items[i].Selected := True;
      Break;
    End;
  End;
End;

Function TfrmCapMain.UpdateTeleReaderConsult(ImagePointer: String; Count: Integer): Boolean;
Var
  s, tmpptr: String;
  sgCount: String;
Begin
  Result := True;
  Try
    tmpptr := TRConsultPtr;
    If Count < 1 Then Count := 1;
    sgCount := Inttostr(Count);
    WinMsg('', 'Filing the Images to TeleReader Consult...');
    XBROKERX.REMOTEPROCEDURE := 'MAG3 TELEREADER READ/UNRD ADD';
    XBROKERX.PARAM[0].Value := ImagePointer;
    XBROKERX.PARAM[0].PTYPE := LITERAL;
    XBROKERX.PARAM[1].Value := sgCount;
    XBROKERX.PARAM[1].PTYPE := LITERAL;
    XBROKERX.PARAM[2].Value := MagPiece(tmpptr, '|', 2);
    XBROKERX.PARAM[2].PTYPE := LITERAL;

    CallBrokerX; //xBrokerx.Call;
    s := XBROKERX.Results[0];
    If (Strtoint(MagPiece(s, '^', 1)) > 0) Then WinMsg('', 'Images added to TELEREADER READ/UNRD OK');
    If ((MagPiece(s, '^', 1) = '') Or (MagPiece(s, '^', 1) = '0')) Then
    Begin
      Result := False;
    End;
  Except
    Result := False;
  End;
End;

Function TfrmCapMain.GetDirImport: String;
Var
  sgResult: String;
Begin
  Result := '';
  sgResult := LbImport.caption;
  sgResult := Trim(sgResult);
  If sgResult = '' Then Exit;
  If sgResult = '<import directory>' Then Exit;
  While True Do
  Begin
    If Copy(sgResult, Length(sgResult), 1) = '\' Then
    Begin
      sgResult := Copy(sgResult, 1, Length(sgResult) - 1);
    End
    Else
    Begin
      Break;
    End;
  End;
  If Not Directoryexists(sgResult) Then Exit;
  If LbImport.caption <> sgResult Then LbImport.caption := sgResult;
  Result := sgResult;
End;

Procedure TfrmCapMain.SetDirImport(Const Value: String);
Var
  sgDir: String;
Begin
  sgDir := Trim(Value);
  If (sgDir = '<import directory>') Or (sgDir = '') Then
  Begin
    LbImport.caption := sgDir;
    Exit;
  End;
  If Not Directoryexists(sgDir) Then
  Begin
    While True Do
    Begin
      If Copy(sgDir, Length(sgDir), 1) = '\' Then
      Begin
        sgDir := Copy(sgDir, 1, Length(sgDir) - 1);
      End
      Else
      Begin
        Break;
      End;
    End;
    If Not Directoryexists(sgDir) Then Exit;
  End;
  LbImport.caption := sgDir;
End;

Function TfrmCapMain.TRCSaveAsDICOM: Boolean;

Var
  DestDICOMFile: String;
  Errors: String;
  i: Integer;
  IsTeleReaderConsult: Boolean;
  lstErrors: Tstringlist;
  SOPAlias: String;
  SourceFile: String;
  WinMsg1: String;
  WinMsg2: String;
Begin
  Result := False;
  Try
    If FrmCapConfig.SingleImage.Checked Then
      TRCImageCtr := 1
    Else
      TRCImageCtr := TRCImageCtr + 1;
    DestDICOMFile := ExtractFilePath(MagFileObj.FullFileName) + MagFileObj.GetFileNameNoExt + '.dcm';
    Errors := '';
    IsTeleReaderConsult := (magAssoc = 'TRC') ; //FrmCapConfig.TeleReaderConsult.Checked;
    SOPAlias := 'TELEDERM';
    SourceFile := DirImport + '\' + FGfiletoImport;
  {/117 FDicomdataArray has computed and user entered values before this call.
   ConvertToDICOMandSave, now will not try and populate FDicomdataArray if it already
        has values. It will just call SaveToDicom
        TESTING : Code can still be run p106 way, to compare.}
    Result :=
      ConvertToDICOMAndSave(
      FDicomdataArray, //Var Data: Tstringlist;
      FDicomDefaultsArray, //Var DICOMDefaults: Tstringlist;
      Errors, //Var Errors: String;
      TRCSeriesNum, //Var TRCSeriesNum: String;
      TRCSeriesUID, //Var TRCSeriesUID: String;  //p106rlm 20100930
      TRCSOPInstanceUID, //Var TRCSOPInstanceUID: String;  //p106rlm 20100930
      TRCStudyUID, //Var TRCStudyUID: String;
      WinMsg1, //Var WinMsg1: String;
      WinMsg2, //Var WinMsg2: String;
      TRCImageCtr, //Var TRCImageCtr: Integer;
      XBROKERX, //Broker: TRPCBroker;
      mg1, // TMag4VGear    Pre p129 was -> //Gear: TGear;
      iDModObj.GetMagPat1, //Patient: TMag4Pat;
      IsTeleReaderConsult, //IsTeleReaderConsult: Boolean;
      Height - 136, //Height: Integer;
      Left, //Left: Integer;
      Top + 105, //Top: Integer;
      FGfiletoImport, //Caption: String;
      DestDICOMFile, //DestDICOMFile: String;
      SOPAlias, //SOPAlias: String;
      SourceFile, //SourceFile: String;
      TRConsultPtr, //TRConsultPtr: String;
      UserCapName, //UserName: String
      EdtImageDesc.Text //Desc: String //p106 rlm 20070804
      ); //): Boolean;
      // gek 117 TESTING.  Take out before Release.
      if mnuTest1.visible then
        begin
        if doesformexist('frmTestDicomData') then
        begin
        frmTestDicomData.memDicom106.Lines.Add('----*********--------------');
        frmTestDicomData.memDicom106.Lines.AddStrings(FDicomdataArray);
        end;
        end;

    If Result Then
    Begin
      //If TeleMedSingle Then UpdateTeleReaderConsultq(GrpPtr, Imageptrlst.Items.Count); //p106 rlm 20101011
      If TeleMedSingle Then IsStudyGroupComplete; //p106 rlm 20101011
      MagFileObj.FullFileName := DestDICOMFile;
      MakeAbs(MagFileObj.FullFileName, MagFileObj.GetAbsFullFileName);
    End;
    If Errors <> '' Then
    Begin
      lstErrors := Tstringlist.Create();
      Try
        lstErrors.SetText(PAnsiChar(Errors));
        For i := 0 To lstErrors.Count - 1 Do
        Begin
          WinMsg('e', lstErrors[i]);
        End;
      Finally
        FreeAndNil(lstErrors);
      End;
    End;
    If WinMsg2 <> '' Then WinMsg(WinMsg1, WinMsg2);
    If Result Then
    Begin
      ButtonSettings(1);
      GearClear;
    End
    Else
    Begin
      ImageEntryDelete(MagFileObj.ID,'NoImage');
    End;
    ENDPROGRESS;
  Except
  End;
End;

Procedure TfrmCapMain.FormDestroy(Sender: Tobject);
Begin
  MagTwain1.SourceClose;

  FreeAndNil(GSess);
  FreeAndNil(MSetWrks1);
  FreeAndNil(FCapClinMgr);
  FreeAndNil(FErrorInGearList);
  FreeAndNil(FErrorInGearListCode);
  FreeAndNil(FDicomdataArray);
  FreeAndNil(FDicomDataUserArray);
  FreeAndNil(FDicomDefaultsArray);
  FreeAndNil(Upref);

  {/p122 dmmn 7/13/11 - clean up /}
(*p129 out
  FreeAndNil(fCapAnnot);
  FreeAndNil(frmAnnotOptionsX);
*)
{ TODO -o129 : this is new..  not sure if was testing or is needed.}
  if frmAnnotOptionsX <> nil then  freeandNil(frmAnnotOptionsX);
  // in create method ->  frmAnnotOptionsX := TfrmAnnotOptionsX.Create(self);

End;

procedure TfrmCapMain.ApplicationDataFolder1Click(Sender: TObject);
var     
  ApplicationDataFolder : String;
begin
  ApplicationDataFolder := getEnvironmentVariable('AppData');
  //showmessage('ApplicationDataFolder  ' + ApplicationDataFolder);
Messagedlg('ApplicationDataFolder  ' + ApplicationDataFolder, Mtconfirmation, [Mbok,
      Mbcancel], 0)  ;
  winmsg('s','ApplicationDataFolder  ' + ApplicationDataFolder);
end;
Procedure TfrmCapMain.FormKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  //p106 rlm 20101118 Fix Garrett's "Control Key- for Date Selection" Start
  (*
  //p106 rlm CR 530 start
  If Shift = [Ssctrl] Then
  Begin
    If (Key = Ord('S')) Or (Key = Ord('s')) Then
    Begin
      If ActiveControl = EdtDocImageDate Then
        edtDocImageDateDblClick(Sender);
      Key := Ord(#0);
    End;
    If (Key = Ord('I')) Or (Key = Ord('i')) Then
    Begin
      If LvImport1.Visible And LvImport1.Enabled Then ActiveControl := LvImport1;
      Key := Ord(#0);
    End;
  End;
  If Shift = [Ssctrl, SsAlt] Then
  Begin
    If (Key = Ord('S')) Or (Key = Ord('s')) Then
    Begin
      If ActiveControl = EdtDocImageDate Then
        btnDocImageDateClick(Sender);
      Key := Ord(#0);
    End;
  End;
  //p106 rlm CR 530 end
*)
  //p106 rlm 20101118 Fix Garrett's "Control Key- for Date Selection" End
End;

Function TfrmCapMain.TRCGetSOPIEN(SOPAlias: String; Out SOP_CLASS_UID, SOPIEN, ERROR: String): Boolean;
Var
  Status: String;
  Stat: String;
Begin
  Result := False;
  Try
    SopAlias := Uppercase(Trim(SopAlias));
    SOP_CLASS_UID := '';
    Error := '';
    If Not XBROKERX.Connected Then
    Begin
      WinMsg('d', 'No VistA Connection. Cannot get SOP Class UID.');
      Exit;
    End;
    Screen.Cursor := crHourGlass;
    XBROKERX.PARAM[0].PTYPE := LITERAL;
    XBROKERX.PARAM[0].Value := SopAlias;
    XBROKERX.REMOTEPROCEDURE := 'MAG3 DICOM CAPTURE SOP CLASS';
    Status := XBROKERX.STRCALL;
    Screen.Cursor := crDefault;
    WinMsg('s', Status);
    Result := (MagPiece(Status, '^', 1) = '1');
    If Result Then
    Begin
      SOPIEN := MagPiece(Status, '^', 2);
      SOP_CLASS_UID := MagPiece(Status, '^', 3);
    End
    Else
    Begin
      Error := 'SOP data not retrieved : ' + MagPiece(Status, '^', 2);
      WinMsg('', 'SOP data not retrieved : ' + MagPiece(Status, '^', 2));
      Messagebeep(0);
    End;
  Except
  End;
End;

Function TfrmCapMain.WriteGroupDescriptions(ShortDesc, LongDesc: String): Boolean; //p106 rlm 20101011
Var
  i: Integer;
  Lst: Tstringlist;
  ss: String;
Begin
  Result := False;
  ShortDesc := Trim(ShortDesc);
  LongDesc := Trim(LongDesc);
  If (ShortDesc = '') And (LongDesc = '') Then
  Begin
    Result := True;
    Exit;
  End;
  If Not XBROKERX.Connected Then Exit;
  XBROKERX.PARAM[0].Value := '.X';
  XBROKERX.PARAM[0].PTYPE := List;
  XBROKERX.REMOTEPROCEDURE := 'MAGGADDIMAGE';
  XBROKERX.PARAM[0].Mult['"MODIFY"'] := 'IEN^' + GRPPTR;
  If ShortDesc <> '' Then
  Begin
    Screen.Cursor := crHourGlass;
    WinMsg('', 'Modifying the Study Group''s description...');
    XBROKERX.PARAM[0].Mult['"GRPDESC"'] := '10^' + ShortDesc;
  End;
  If LongDesc <> '' Then
  Begin
    Lst := Tstringlist.Create();
    Try
      Lst.SetText(PAnsiChar(LongDesc));
      Screen.Cursor := crHourGlass;
      WinMsg('', 'Modifying the Study Group''s Long description...');
      For i := 0 To Lst.Count - 1 Do
        XBROKERX.PARAM[0].Mult[('"LONGDES' + Copy('000', 1, 3 - Length(Inttostr(i))) + Inttostr(i) + '"')] := '11^' + Lst[i];
    Finally
      FreeAndNil(Lst);
    End;
  End;
  ss := XBROKERX.STRCALL;
  If ((MagPiece(ss, '^', 1) = '0') Or (MagPiece(ss, '^', 1) = '')) Then
    WinMsg('', 'ERROR Modifying the Study Group Description. : ' + MagPiece(ss, '^', 2))
  Else
    WinMsg('', 'Study Group''s description Modified.');
  Screen.Cursor := crDefault;
  Result := (MagPiece(ss, '^', 1) <> '0');
End;


{ 	Function IsAssocTRCOK new in 106t10.      this is sort of what I meant by
      isAssocOk function, but the intent is to call this, similiar to other Asso.
         lab, tiu, rad..  from the IsAssocOk .. call.   }
{ TODO : need to look into moving this to be called liek other assoc's }
Function TfrmCapMain.IsAssocTRCOK: Boolean;
Var
  FileExt: String; //p106 rlm 20101129 Fix Garrett's "Notify user when an Image can't be used"
Begin
  Result := True;
  //If FrmCapConfig.TeleReaderConsult.Checked Then
  if magAssoc = 'TRC' then
  Begin
    If Not FrmCapConfig.DICOMFormat.Checked Then
    Begin
      //p106 rlm 20101129 Fix Garrett's "Title of Dialog box"
      MagAppMsg(
        'd',
        'An association of TeleReader Consult (TRC)' + #13 + #10  +
        'must use a Format of:' + #13 + #10 +
        'DICOM(VL Photo Image Storage).' +#13 + #10 +#13 + #10 +
        'Change the format or association to continue image capture.');
      Result := False;
      Exit;
    End;
  End;
  if  FrmCapConfig.DICOMFormat.Checked  then
  Begin
    If Not (magAssoc = 'TRC') Then
    Begin
      //p106 rlm 20101129 Fix Garrett's "Title of Dialog box"
      MagAppMsg(
        'd', 'The format DICOM(VL Photo Image Storage)'  +#13 + #10   +
        'is only implemented for ' +#13 + #10  +
        'an association of TeleReader Consult.' +#13 + #10 +#13 + #10 +
        'Change the format or association to continue image capture.');
      Result := False;
      Exit;
    End;
  End;
(* /p117 gek out.
     If Not FrmCapConfig.Import.Checked Then
    Begin
      //p106 rlm 20101129 Fix Garrett's "Title of Dialog box"
      MagAppMsg(
        'd',
        'An association of TeleReader Consult' + #13 + #10 +
        'must use a Source of "Import".',
        Nil);
      Result := False;
      Exit;
    End;
*)
    //p106 rlm 20101129 Fix Garrett's "Notify user when an Image can't be used" START
      { TODO -ogarrett -cfilesCantBeImported : 
we want to flag the file in the Import list with the 'warning' sign.  This indicates
that the image can't be imported.  We do it now for files with Ext that we don't support.
That should to be done in a different method not here.  this does the job, but would be good
to look into doing it earlier.}
    if magAssoc = 'TRC' then
    begin
    FileExt := Uppercase(ExtractFileExt(DirImport + '\' + FGfiletoImport));
    If FileExt <> '' Then
    begin

      If Not ((FileExt = '.JPG') Or (FileExt = '.TIF')) Then
      begin
        //p106 rlm 20101129 Fix Garrett's "Title of Dialog box"
        MagAppMsg(
          'd',
          'An association of TeleReader Consult' + #13 + #10 +  #13 + #10 +
          'can only import JPG or TIF images".' +  #13 + #10);
        Result := False;
        Exit;
      end;
      //p122t11 dmmn prompt user that multipage tiff is not supported
      if ((FileExt = '.TIF') and (mg1.PageCount > 1) and (TIFWarnFirst)) then
      begin
        TIFWarnFirst := False;
        magappmsg('d','Multipage TIF is not supported for Telereader Consult. Only the first page will be captured.');
      end;
    end;
    end;
    //p106 rlm 20101129 Fix Garrett's "Notify user when an Image can't be used" END

    //p106 rlm 20101130 Fix CR 603 "You need to select a TeleReader Consult" START
(*  {/p117 T3 gek,
                    DateTimeProc is checked in ValidAssociationFields.
                    TRConsultPtr is checked in ValidTRCData.}
    If (TRConsultPtr = '') Or (DateTimeProc = '') Then
    Begin
      MagAppMsg(
        'd',
        'You need to select a "TeleReader Consult"',
        Nil);
      If btnLookupdata.Visible Then
      Begin
        If btnLookupdata.Enabled Then
        Begin
          ActiveControl := btnLookupdata;
        End;
      End;
      Result := False;
      Exit;
    End;
    *)
    //p106 rlm 20101130 Fix CR 603 "You need to select a TeleReader Consult" END
  End;

//p106 rlm 20110105 CR604 "Consult Date and Doc/Image Date Format Differences" Start
//ShowFmDateMMMNoTime formats a date string as 'mmm dd, yyyy'
//An example is Dec 07, 1941
Function TfrmCapMain.ShowFmDateMMMNoTime(fmdate: String): String;
Begin
  Result := ShowFmDateDetail(fmdate, 'mmm dd, yyyy');
End;
//p106 rlm 20110105 CR604 "Consult Date and Doc/Image Date Format Differences" End

//p106 rlm 20110105 CR604 "Consult Date and Doc/Image Date Format Differences" Start
//ShowFmDateDetail allows an existing date string to be reformated.
//For example ShowFmDateDetail('12/7/1941', 'mmm dd, yyyy') results in 'Dec 07, 1941'
//The full range of format options available through Formatdatetime can
//be used with ShowFmDateDetail.
Function TfrmCapMain.ShowFmDateDetail(fmdate, Format: String): String;
Var
  Dt: Tdatetime;
Begin
  Result := fmdate;
  Try
    Dt := Strtodatetime(fmdate);
    Result := Formatdatetime(Format, Dt);
  Except
  End;
End;
//p106 rlm 20110105 CR604 "Consult Date and Doc/Image Date Format Differences" End



procedure TfrmCapMain.btnDicomByUserClick(Sender: TObject);
begin
   TESTDicomGetUserData;
   FEdtLV.GenGoToNextControl(btnDicomByUser);
end;

procedure TfrmCapMain.btnDicomFieldsGetDataClick(Sender: TObject);
begin

end;

{/p117 This call will just get the Dicom Data that the User Selects.
  called before TRCSaveAsDicom, we just set/get the properties needed for the User Selected fields.}
procedure TfrmCapMain.TESTDicomGetUserData;
Var
  value : string; //p117
  j: Integer;
  ResultValue : boolean ; //gek
Begin
  Try
    {/p117 gek - In this Patch, the design is again that user data is entered before 'Image OK'
      is called.  there is a 'GetDicomData' Button. (like the Select Procedure Button...
      visible when Dicom Data is needed (When TeleReader Conust is the Association.)
      User clicks the button to enter the User selected Dicom Data. (fmagDicomEntry form.
      There are two arrays.  FDicomDataUserArray, and FDicomDataGeneratedArray. These are merged
      right before SaveAsDicom is called.  }

   {/p117 TESTDicomGetUserDataS2 (which is a modified copy of populatedicomfields to just get user data
     instead of  ConvertToDicomAndSave which calls populateDicomDfields to get User and Generated.}
    Resultvalue :=
          TESTDicomGetUserDataS2( FDicomDataUserArray, //Var Data: Tstringlist;
                                  FDicomDefaultsArray, //Var DICOMDefaults: Tstringlist;
                                  XBROKERX ) ; //Broker: TRPCBroker;

      if Resultvalue then
        begin
        edtDicomByUser.Clear;
        edtDicomByUser.Hint := '';
        for j := 0 to FDicomDataUserArray.Count - 1 do
        begin
           value :=  magpiece(FDicomDataUserArray[j],'=',2);
        if value <> '' then
           begin
           edtDicomByUser.Text := edtDicomByUser.Text + value + ' , ';
           edtDicomByUser.hint := edtDicomByUser.hint + copy(FDicomDataUserArray[j],11,99) + #13;
           end;
        end;
        if edtDicomByUser.text <> '' then edtDicomByUser.Text := copy(edtDicomByUser.Text,0,length(edtDicomByUser.Text)-3);
        end
        else
        begin
          //  message to say ... what, need return msg from getuserdata
        end;

   {TESTING}
   if  doesFormExist('frmTESTDicomData') then
   begin
     frmTESTDicomData.memdicomTest.Lines.Add('-------------------------------');
     frmTESTDicomData.memdicomTest.Lines.Addstrings(FDicomDataUserArray);
     frmTESTDicomData.memdicomTest.Lines.Add('-------------------------------');
   end;

finally
    //
  end;
end;

procedure TfrmCapMain.TESTDicomGetGeneratedData;
Var
  DestDICOMFile: String;
  Errors: String;
  i: Integer;
  IsTeleReaderConsult: Boolean;
  lstErrors: Tstringlist;
  SOPAlias: String;
  SourceFile: String;
  WinMsg1: String;
  WinMsg2: String;
  ResultValue : boolean ; //gek
Begin
{/p117 gek - clean up the code after testing.  before release.}
{/p117 gek TESTDicomGetGeneratedData was copied from  Function TfrmCapMain.TRCSaveAsDICOM: Boolean;}
  //Result := False;
  Try
         { TODO :   Have to figure out where this goes...  since Generated Data will only be called once,
                     then this is probably the place.   We will generate and save in the same function. }
 //   If FrmCapConfig.SingleImage.Checked
 //   Then   TRCImageCtr := 1
 //   Else   TRCImageCtr := TRCImageCtr + 1;


    DestDICOMFile := ExtractFilePath(MagFileObj.FullFileName) + MagFileObj.GetFileNameNoExt + '.dcm';
    Errors := '';
    IsTeleReaderConsult := (magassoc = 'TRC'); //FrmCapConfig.TeleReaderConsult.Checked;
    SOPAlias := 'TELEDERM';
    SourceFile := DirImport + '\' + FGfiletoImport;
    Resultvalue :=   { now, TESTDicomGetUserDataS2 (which is a copy of populatedicomfields
     instead of  ConvertToDicomAndSave
     ConvertToDicomAndSave calls populateDicomDfields.}

        TESTDicomGetGeneratedDataS2( FDicomdataArray, //Var Data: Tstringlist;
                FDicomDefaultsArray, //Var DICOMDefaults: Tstringlist;
                Errors, //Var Errors: String;
                TRCSeriesNum, //Var TRCSeriesNum: String;
                TRCSeriesUID, //Var TRCSeriesUID: String;  //p106rlm 20100930
                TRCSOPInstanceUID, //Var TRCSOPInstanceUID: String;  //p106rlm 20100930
                TRCStudyUID, //Var TRCStudyUID: String;
                WinMsg1, //Var WinMsg1: String;
                WinMsg2, //Var WinMsg2: String;
                TRCImageCtr, //Var TRCImageCtr: Integer;
                XBROKERX, //Broker: TRPCBroker;
                mg1, //Mag4VGear  pre p129  was -> Gear1, //Gear: TGear;
                iDModObj.GetMagPat1, //Patient: TMag4Pat;
                IsTeleReaderConsult, //IsTeleReaderConsult: Boolean;
                Height - 136, //Height: Integer;
                Left, //Left: Integer;
                Top + 105, //Top: Integer;
                FGfiletoImport, //Caption: String;
                DestDICOMFile, //DestDICOMFile: String;
                SOPAlias, //SOPAlias: String;
                SourceFile, //SourceFile: String;
                TRConsultPtr, //TRConsultPtr: String;
                UserCapName, //UserName: String
                EdtImageDesc.Text //Desc: String //p106 rlm 20070804
                ); //): Boolean;);


      (*(Dicomdata, //Var Data: Tstringlist;
      TRCDICOMDefaults, //Var DICOMDefaults: Tstringlist;
      Errors, //Var Errors: String;
      TRCSeriesNum, //Var TRCSeriesNum: String;
      TRCSeriesUID, //Var TRCSeriesUID: String;  //p106rlm 20100930
      TRCSOPInstanceUID, //Var TRCSOPInstanceUID: String;  //p106rlm 20100930
      TRCStudyUID, //Var TRCStudyUID: String;
      WinMsg1, //Var WinMsg1: String;
      WinMsg2, //Var WinMsg2: String;
      TRCImageCtr, //Var TRCImageCtr: Integer;
      XBROKERX, //Broker: TRPCBroker;
      Gear1, //Gear: TGear;
      iDModObj.GetMagPat1, //Patient: TMag4Pat;
      IsTeleReaderConsult, //IsTeleReaderConsult: Boolean;
      Height - 136, //Height: Integer;
      Left, //Left: Integer;
      Top + 105, //Top: Integer;
      FGfiletoImport, //Caption: String;
      DestDICOMFile, //DestDICOMFile: String;
      SOPAlias, //SOPAlias: String;
      SourceFile, //SourceFile: String;
      TRConsultPtr, //TRConsultPtr: String;
      UserCapName, //UserName: String
      EdtImageDesc.Text //Desc: String //p106 rlm 20070804
      ); //): Boolean;
      *)

(*      ConvertToDicomAndSave(
      Dicomdata, //Var Data: Tstringlist;
      TRCDICOMDefaults, //Var DICOMDefaults: Tstringlist;
      Errors, //Var Errors: String;
      TRCSeriesNum, //Var TRCSeriesNum: String;
      TRCSeriesUID, //Var TRCSeriesUID: String;  //p106rlm 20100930
      TRCSOPInstanceUID, //Var TRCSOPInstanceUID: String;  //p106rlm 20100930
      TRCStudyUID, //Var TRCStudyUID: String;
      WinMsg1, //Var WinMsg1: String;
      WinMsg2, //Var WinMsg2: String;
      TRCImageCtr, //Var TRCImageCtr: Integer;
      XBROKERX, //Broker: TRPCBroker;
      Gear1, //Gear: TGear;
      iDModObj.GetMagPat1, //Patient: TMag4Pat;
      IsTeleReaderConsult, //IsTeleReaderConsult: Boolean;
      Height - 136, //Height: Integer;
      Left, //Left: Integer;
      Top + 105, //Top: Integer;
      FGfiletoImport, //Caption: String;
      DestDICOMFile, //DestDICOMFile: String;
      SOPAlias, //SOPAlias: String;
      SourceFile, //SourceFile: String;
      TRConsultPtr, //TRConsultPtr: String;
      UserCapName, //UserName: String
      EdtImageDesc.Text //Desc: String //p106 rlm 20070804
      ); //): Boolean;  *)
      if doesformexist('frmTESTDicomData')  then
        begin
        frmTESTDicomData.memdicomTest.Lines.Add('-------------------------------');
        frmTESTDicomData.memdicomTest.Lines.Addstrings(FDicomdataArray);
        frmTESTDicomData.memdicomTest.Lines.Add('-------------------------------');
        end;

finally
    //
  end;
end;


procedure TfrmCapMain.mnuTESTINGAnnotQuickInitClick(Sender: TObject);
begin
  AnnotationQuickInit('');     //{p129 testing}
end;

procedure TfrmCapMain.AnnotationQuickInit(magIEN : string);
var vServer  : string;
  vServerPort : integer;
  vSiteNum : string;
begin
  FAnnotInitForImage := true;
   {trying to make this call...  because of null data and the XML control isn't being
      created, so the 'Save' (below)   is dying.   Done. }
  {/p129  COMPLETE quickInitAnnotationSesssion to send the needed data...  }
  {  also, there is an UPDATE call, that is also called from mg1.QuickInit...
                 can be used to change the IEN... }

  vServer := iDModObj.GetMagDBBroker1.GetServer;           {p129 annot} {b3}
  vServerPort := iDmodObj.GetMagDBBroker1.GetListenerPort;
  vSiteNum := Gsess.WrksInstStationNumber;

  (*
      procedure TMag4VGear.QuickInitAnnotationSession(vImageIEN: String;  vPageCount: Integer;
                  vDUZUserName, vService: String;
                  vResulted: String; vDUZ,
                  vSiteNum: String; vServerName: String; vServerPort: Integer;
                  vRadiologyReset: Boolean = False);
  *)

  MG1.QuickInitAnnotationSession(magien, mg1.PageCount,
             GSess.UserName,GSess.UserService,
             magbooltostr(FCapAnnotConsultResulted), GSess.UserDUZ,
             vSiteNum,  vServer, vServerPort);
end;

//function TfrmCapMain.AnnotationsSaveAnnotationsToDB(xmlpath : string) : boolean;
function TfrmCapMain.AnnotationsSaveAnnotationsToDB(newMagIEN : string): boolean ;
var
  isTRCImage : boolean;     //p129t18 dmmn - indicate wether or not the capture is for TRC
begin
     {129t18 Duc  start }
  // p129t19 dmmn - make sure that all annotation are dashed and underline if associated
  // with a signed note
  if (MagAssoc = 'NOTES') and (FCapAnnotConsultResulted) then
    mg1.AnnotationComponent.CapConvertAllAnnotationsToResulted(FCapAnnotConsultResulted)
  else
    mg1.AnnotationComponent.CapConvertAllAnnotationsToResulted(false);
     {129t18 Duc  start END}
  // p129t18 check and make sure that this is annotation for converted DICOM or not
  // Only revert the annotation change (rotates, flips) if the image is for TRC
  ////  this was pre >> if (magAssoc = 'TRC') and (FmIGSaveFormat = mag_IG_SAVE_DCM) Then
  ////129t18   Check in 140 refactor  
     {129t18 Duc  CHANGE }
  if (magAssoc = 'TRC') Then
    isTRCImage := true
  else
    isTRCImage := false;

  AnnotationQuickInit(newMagien);
  mg1.SaveAnnotations(newMagien, true, isTRCImage);
  {JK 6/26/2012 - clean up the local \Application Data\icache\annotations directory after a capture is complete and annotations written to VistA}
  mg1.AnnotationComponent.DeleteCachedFiles(GSess.AnnotationTempDir, '*.*');
end;

procedure TfrmCapMain.AnnotationsUpdateSessionInfo(UserCapName : string;  UserServiceSection : string;  Magien : string; UserDUZ : string; WrksInstStationNumber : string);
var
 I : integer;
 begin
   {  DONE -o129 : need to make this call.
      -> Not needed as seperate call, this is handled in AnnotationQuickInit}

(*
          fCapAnnot.UpdateSessionInfo(UserCapName,                    // annotator
                                    iDModObj.GetMagDBMVista1.GetBroker.User.ServiceSection, // p122 dmmn 7/28 - new rpc call
                                    Magien,                         // imageIEN
                                    iDModObj.GetMagDBMVista1.GetBroker.User.DUZ, //p122 dmmn 8/16
                                    GSess.WrksInstStationNumber);
*)
 end;


  //    if (fCapAnnot.HasAnnotationComponent) and (fCapAnnot.MarkCount > 0) then
function TfrmCapmain.AnnotationsExist() : boolean;
var
 I : integer;
begin
Result :=  mg1.CheckIsSessionChanged;
{ DONE -o129 : new function instead of checking Old Annotation Form property.}
//122 had ->    if (fCapAnnot.HasAnnotationComponent) and (fCapAnnot.MarkCount > 0) then
end;

procedure TfrmCapMain.AnnotationsClose() ;
begin
  magappmsg('s', 'TfrmCapMain.AnnotationsClose ENTERED');
   //129 GEK mg1.AnnotationComponent.ClearAllAnnotations;     //HERE HERE.   MAYBE NEED THIS ELSEWHERE
       {129t18 Duc  Change to : } 
  //p129t18 dmmn - delete all to clear all pages,
  mg1.AnnotationComponent.DeleteAllMarksOnAllPages;     

  {gek 0624  change to CLOSE. so Published message is sent.}
  mg1.AnnotationComponent.CLOSE;
  { DONE -o129 : new function to close whatever Annotation form we have. .
  //122 had ->  fCapAnnot.Close; }

{.. Duc had covered the , the log in after timeout..  if users permissions change. to
then hide the annotations... .}
  magappmsg('s', 'TfrmCapMain.AnnotationsClose EXITED');

end;
procedure TfrmCapMain.tlbrbtnAnnotationClick(Sender: TObject);
begin
  CapAnnotationShow;
end;

procedure TfrmCapMain.tlbrbtnAnnotationCloseClick(Sender: TObject);
begin
  CapAnnotationHide;
end;

procedure TfrmCapMain.CapAnnotationShow;
var
  annotvis : boolean;
begin
  if btnReview.Visible then
   begin
      magappmsg('d','Annotation while creating a PDF image is not available');
      exit;
   end;
   if CapX.m140CombineScans or CapX.m140PDFConvert or CapX.m140MultSources then
   begin
      magappmsg('d','Annotation while creating a PDF image is not available');
      exit;
   end;
   
  
  if not FAnnotInitForImage then
  begin
    AnnotationQuickInit('');
  end;

  {if annotation Window already visible, then just close it  ... this shouldn't happen, it's the old logic.}
  annotvis := mg1.AnnotationComponent.visible ;
  if IsGearClear(mg1) then
  begin
    if annotvis then CapAnnotationHide;
    exit;
  end;
     {129t18 Duc  start }
  //p129t19 update any existing and new annotation to resulted mode if neceessary
  AnnotationGetConsultResulted();
  if (MagAssoc = 'NOTES') and (FCapAnnotConsultResulted) then
    mg1.AnnotationComponent.CapConvertAllAnnotationsToResulted(FCapAnnotConsultResulted)
  else
    mg1.AnnotationComponent.CapConvertAllAnnotationsToResulted(false);
       {129t18 Duc  start end}  
  mg1.annotationcomponent.visible := true;
  //p129t9  garrett  added check from User Key
  //mg1.AnnotationComponent.UserCanEdit := GSess.HasLocalAnnotatePermission  or UserHasKey('MAG ANNOTATE MGR') ;
     {129t18 Duc change to }
  //p129t19 dmmn - check session property instead, initialized when user logged in
  mg1.AnnotationComponent.UserCanEdit := GSess.HasLocalAnnotatePermission  or GSess.HasLocalAnnotateMasterKey ;
  mg1.StartAnnotations;
  DisableComponentsDuringAnnot(true);
end;


procedure TfrmCapMain.CapAnnotationHide;
var
annotvis : boolean;
begin
try
annotvis := mg1.AnnotationComponent.visible ;
(*if IsGearClear(mg1) then
     begin
    if annotvis then mg1.annotationcomponent.close;
     exit;
     end;*)
if annotvis then
   begin
   mg1.annotationcomponent.Close;
   exit;
   end;
finally
DisableComponentsDuringAnnot(false);
end;
end;

procedure TfrmCapMain.DisableComponentsDuringAnnot(value : boolean);
begin
{Tammy problem with Acceleratof keys when Edit box of annotation is open.}
btnLongDesc.Enabled := not value;   //p129 T1 this was missed on first T2.  Try this for 'L'
plongdesc.enabled := not value;    //p129 T1 this was missed on first T2.
tlbrSettings.enabled :=  not value;
sbxeditfields.Enabled := not value;


{10/15/12  129T10 gek  this is unnneded. } // AnnotationsEnableforImage(not value);  {gek 129t10   stop the enable of the Annot button}
{10/15/12, but need to enabled the 'Close Annotation button'; }

(* The procedure:  AnnotationsEnableforImage, will check if annotations are available for this
                 Session, and won't enable the buttons if not. 
     so below (two)  back in 10/15/12. *)
     tlbrbtnAnnotationClose.Visible :=  value;
     tlbrbtnAnnotation.Visible :=   not value;

end;

procedure TfrmCapMain.DisableImageManips(value: boolean);
begin
  //p129t18 dmmn having trouble saveing the changes and reseting the changes for pdf
  //disable all the image manipulatio for now with pdf
  tbicBrightness.Enabled := Not value;
  tbicContrast.Enabled := Not value;
  tlbrbtnFlipVert.Enabled := Not value;
  tlbrbtnFlipHoriz.Enabled := Not value;
  tlbrbtnRotatem90.Enabled := Not Value;
  tlbrbtnRotate90.Enabled := Not Value;
  tlbrbtnInvert.Enabled := Not Value;

  Rotate2.Enabled := Not Value;
  Invert2.Enabled := Not Value;
  ContrastBrightness2.Enabled := Not Value;
end;


//TP CCOW  - 4 new menu option calls.
Procedure TfrmCapMain.MnuShowContextClick(Sender: Tobject);
Begin
  idmodobj.GetCCOWManager.ShowContextData;
End;

Procedure TfrmCapMain.MnuSuspendContextClick(Sender: Tobject);
Begin
  magappmsg('s','calling SuspendContextLink');
  idmodobj.GetCCOWManager.SuspendContextLink;
    // JMW 2/3/2006 p46, turn off sync (to not listen to any windows messages)
End;

Procedure TfrmCapMain.MnuResumeGetContextClick(Sender: Tobject);
Begin
  magappmsg('s','calling ResumeGetContext');
  idmodobj.GetCCOWManager.ResumeGetContext;
End;

Procedure TfrmCapMain.MnuResumeSetContextClick(Sender: Tobject);
var curpatientdfn : string;
Begin
curpatientdfn := idmodobj.GetMagPat1.M_DFN;
self.ClearCurrentPatient(true);
 { 19t13 gek ResumeContextOnly is a new function that Only Resumes context,
    it doesn't Get Current Patient.  Capture and Display differ in the design of CCOW SetContext}
idmodobj.GetCCOWManager.ResumeContextOnly(); 
self.ChangeToPatient(curpatientdfn);
End;





   {//Mychng END}
//**************************  END  TEST ********************************

//================  TP CCOW update ========================
(* TP CCOW  - the whole UpDate_ procedure is put in with CCOW
           this forces changes in Capture ChangeToPatient.   Capture previously was the one to 'Set'
           or 'Call' cmag4Pat.  Now TP Change,  a CCOW Context change will call Update_, which calls
            changepatient,  which checks cmag4Pat , but sometimes cmag4Pat isn't updated with
            Context Patient.... then the Refresh.. delay..  to update the patient
            if the changePatient didn't do it timewise.  Rework needed.

            also, In the  Procedure Update_  the contextDFN was set, but a call to GetContextValue
            .. but the value was incorrect,  so this caused a problem.  the correct value is returned
            when a call is made to  idmodobj.GetCCOWManager.GetContextValue(cmgrConKey);
            this has to be further flused out, and code changed to assure the correct value
             returned.
              *)






  { P94T4  moved to Destroy method /gek    }
  
  //MagLogger.Close;


initialization
 {  this section is done before Create, before other forms are available }

{ moved to Create. }

{  MagLogger.Open(plUser,
                 'Capture_Log.zip',
                 True,
                 '',
                 30,
                 10000000,
                 'VistA Imaging Clinical Capture',
                 False);
}

finalization



End.
//Gear 1.  -----000000000000000000 END  OF CODE ---000000000000000000000000000-- END  OF CODE ----- END  OF CODE ---000000000000000000000-- END  OF CODE ----000000000000000000000000- END  OF CODE -----
(*  old IsStudyGroupComplete
function TfrmCapMain.IsStudyGroupComplete: boolean;
var
    gcomp: TfrmCapGrpComplete;
    ss, callstat: string;
    i: integer;
begin
    {Stop DATABASE updates if in TEST Mode.}

    if FModeTest then
    begin
        result := true;
        winmsg('', 'Test Mode is ON.  No DataBase updates.');
        exit;
    end;
    if imageptrlst.items.count = 0 then
    begin
        result := true;
        exit;
    end;
    gcomp := TfrmCapGrpComplete.create(self);
    gcomp.lbdicom.caption := ''; {clear the DICOMID when window created }
    gcomp.lbPrompt.caption := 'Study Group: "' + edtStudy.Text + '"' + #13
        + 'Patient    : "' + iDModObj.GetMagPat1.M_NameDisplay + '"' + #13
        + 'Image Count:  ' + inttostr(imageptrlst.items.count) + #13
        + 'CLOSE the Study Group ?';
    gcomp.egroupdesc.text := grpdesc;
    gcomp.egroupdesc.modified := false;
    //gcomp.grouplongdesc.wordwrap := frmCapMain.GrpLongdesc.wordwrap;
    //gcomp.grouplongdesc.scrollbars := frmCapMain.GrpLongdesc.scrollbars;
    gcomp.grouplongdesc.lines := GrpLongdesc.lines;
    gcomp.grouplongdesc.modified := false;
    if lbdicom.caption <> '' then
        gcomp.lbdicom.caption := lbdicom.Caption;
    gcomp.showmodal;
    if gcomp.modalresult = mrcancel then
        result := false
    else
    begin
        result := true;
        if ((cpptr <> '') and (magpiece(cpptr, '^', 5) = '2')) then
        begin
            iDModObj.GetmagDBBroker1.RPUpdateConsult(magpiece(cpptr, '^', 4), magpiece(cpptr, '^', 1), '2', callstat);
            winmsg('s', callstat);
        end;

        lbDicom.caption := ''; { put in for Lucilles's DICOMID Medicine procedur needs}

        if gcomp.egroupdesc.modified or gcomp.grouplongdesc.modified then
        begin
            xBrokerx.Param[0].Value := '.X';
            xBrokerx.Param[0].PType := list;
            xBrokerx.remoteprocedure := 'MAGGADDIMAGE'; //IsStudyGroupComplete
            xBrokerx.Param[0].Mult['"MODIFY"'] := 'IEN^' + GRPPTR;
            if gcomp.egroupdesc.modified then
            begin
                screen.cursor := crHourGlass;
                winmsg('', 'Modifying the Study Group''s description...');
                xBrokerx.Param[0].Mult['"GRPDESC"'] := '10^' + gcomp.egroupdesc.text;
            end;
            if gcomp.grouplongdesc.modified then
            begin
                screen.cursor := crHourGlass;
                winmsg('', 'Modifying the Study Group''s Long description...');
                for i := 0 to gcomp.grouplongdesc.lines.count - 1 do
                    xBrokerx.Param[0].Mult[('"LONGDES' + COPY('000', 1, 3 - LENGTH(INTTOSTR(I))) + IntToStr(i) + '"')] := '11^' + gcomp.grouplongdesc.lines[i];
            end;
            ss := xBrokerx.STRcall;
            if ((magpiece(ss, '^', 1) = '0') or (magpiece(ss, '^', 1) = '')) then
                winmsg('', 'ERROR Modifying the Study Group Description. : ' + magpiece(sS, '^', 2))
            else
                winmsg('', 'Study Group''s description Modified.');
            screen.cursor := crDefault;
        end;
    end; {else}
    gcomp.release;
end;






*)



