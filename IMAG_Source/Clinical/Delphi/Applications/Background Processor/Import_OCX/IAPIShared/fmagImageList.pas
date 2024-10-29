unit fmagImageList;
{
Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created:  Modified Ver 3 Patch 8 (8/1/2002)
Site Name: Silver Spring, OIFO
Developers: Garrett Kirin
[==  unit fmagImageList;
Description: Displays a filtered list of a patients images.

    Lists SubSet of All Images as determined by selected Image Filter.
    Allows user to view Abstract of selected list entry.
    Allows user to view associated report of selected list entry.
    Adds toolwindow for user to show/hide selected columns of the cMagListView component
    Adds a menu for easy and familiar access to options and functions.

    Implements the ImagObserver interface and attaches itself to the TmagImageList object.
        ( The TmagImageList object (not the frmImageList Window) maintains a list
          of the filtered images for the current patient and filter.  It notifies all
          of it's observers whenever the list changes)

    Whenever user selects a new filter, code in the Image List window sets
    the Filter property and forces a refresh of the TmagImageList Object.
    The Update method will notify all observers of the change and the
    Image List window will get notified.

    When notified of a change in the cmagImageList component,
    the Image list window will
         Update the cMagListView component with the new list of images from TmagImagelist.
         Select the first Image in the cMagListView control.
            ( The OnSelect Event of the TmagListView control will
              Refresh the Abstract Preview and Report Preview)
         Call umagDisplayMgr.ImageCountDisplay to update the Filter description
            ( ImageCountDisplay updates the filter description in frmMain,
              frmMagAbstracts and frmImageList (this form))

    Note: the Image List window is a blend of old style Form Centered design and
    the current refactoring into an object oriented Model View design.

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
    ;; a Class II medical device.  As such, it may not be changed
    ;; in any way.  Modifications to this software may result in an
    ;; adulterated medical device under 21CFR820, the use of which
    ;; is considered to be a violation of US Federal Statutes.
    ;; +---------------------------------------------------------------------------------------------------+

*)

interface

uses
  Classes,
  cMag4VGear,
  cMag4Viewer,
  cMagImageList,
  cMagListView,
  //cMagLogManager, {JK 10/5/2009 - Maggmsgu refactoring - deprecated unit}
  cMagMenu,
  cmagObserverLabel,
  cMagPatPhoto,
  cMagPublishSubscribe,
  cMagTreeView,
  cMagViewerTB8,
  ComCtrls,
  Controls,
  Dialogs,
  ExtCtrls,
  Forms,
  Imaginterfaces,
  MagRemoteInterface,
  MagRemoteToolbar,
  Menus,
  StdCtrls,
  uMagClasses,
  fmagMain,
  umagdefinitions, ImgList, ToolWin, Graphics, Buttons
  ;

//Uses Vetted 20090929:GearVIEWLib_TLB, OleCtrls, AxCtrls, MagRemoteBrokerManager, trpcb, cMagPat, maggut1, Tabs, Grids, ImgList, Toolwin, Buttons, Graphics, Messages, Magguini, Magwkcnf, magfileversion, umagAppMgr, umagutils, uMagKeyMgr, dmsingle, maggrpcu, MagImageManager, magpositions, inifiles, SysUtils, Windows

type
  TfrmImageList = class(TForm, ImagObserver, IMagRemoteinterface)
    stbarImagelist: TStatusBar;
    menuMagListView: TPopupMenu;
    mmuImageReport2: TMenuItem;
    N4: TMenuItem;
    mnuFitColToText2: TMenuItem;
    mnuImageInfoAdv2: TMenuItem;
    mnuOpenImage2: TMenuItem;
    imglstToolbar: TImageList;
    magImageList1: TmagImageList;
    mnuImageInformation2: TMenuItem;
    mnuFitColToWin2: TMenuItem;
    fontDlgReport: TPopupMenu;
    mnuFont: TMenuItem;
    FontDialog1: TFontDialog;
    MainMenu1: TMainMenu;
    mnuFile: TMenuItem;
    mnuOpenImage1: TMenuItem;
    mnuImageReport1: TMenuItem;
    mnuExit1: TMenuItem;
    mnuOptions: TMenuItem;
    N5: TMenuItem;
    mnuBrowseImageList: TMenuItem;
    mnuShowHints1: TMenuItem;
    mnuStayonTop1: TMenuItem;
    mnuUtilities: TMenuItem;
    mnuImageInformation1: TMenuItem;
    mnuImageInformationAdvanced1: TMenuItem;
    GotoMainWindow1: TMenuItem;
    mnuHelp: TMenuItem;
    ImageListingwindow1: TMenuItem;
    ImageFilter1: TMenuItem;
    mnuImageDelete2: TMenuItem;
    mnuImageDelete1: TMenuItem;
    mnuOpenImagein2ndRadiologyWindow2: TMenuItem;
    mnuOpenImagein2ndRadiologyWindow1: TMenuItem;
    MagMenuPublic: TMag4Menu;
    MagMenuPrivate: TMag4Menu;
    mnuNFile1: TMenuItem;
    mnuRefreshFilterlist: TMenuItem;
    mnuMultiLineTabs1: TMenuItem;
    mnuSelectPatient1: TMenuItem;
    pnlAbs: TPanel;
    pnlMain: TPanel;
    pnlMagListView: TPanel;
    pnlAbsPreview: TPanel;
    splpnlAbs: TSplitter;
    slppnlAbsPreview: TSplitter;
    mnuOpenImageID: TMenuItem;
    mnuTesting: TMenuItem;
    mnuImageSaveAs2: TMenuItem;
    mnuIndexEdit: TMenuItem;
    mnuMultiLine: TMenuItem;
    mnuRefreshPatientImages: TMenuItem;
    N13: TMenuItem;
    UpreftoImageListWin1: TMenuItem;
    mnuCacheGroup2: TMenuItem;
    mnuCacheGroup1: TMenuItem;
    ActiveForms1: TMenuItem;
    ShortCutMenu1: TMenuItem;
    FilterTabPopup: TPopupMenu;
    mnuFilterInfo2: TMenuItem;
    mnuROI: TMenuItem;
    mnuReports1: TMenuItem;
    mnuPatientProfile1: TMenuItem;
    mnuHealthSummary1: TMenuItem;
    mnuDischargeSummary1: TMenuItem;
    FilterDetails1: TMenuItem;
    mnuFiltersasTabs1: TMenuItem;
    mnuListQAReview: TMenuItem;
    fMagRemoteToolbar1: TfMagRemoteToolbar;
    pnlTree: TPanel;
    MagTreeView1: TMagTreeView;
    pgctrlTreeView: TPageControl;
    tabshPkg2: TTabSheet;
    tabshSpec2: TTabSheet;
    tabshType2: TTabSheet;
    tabshClass2: TTabSheet;
    mnuTree: TMenuItem;
    mnuShowTree: TMenuItem;
    mnuTreeTabs1: TMenuItem;
    mnuAlphaSort: TMenuItem;
    mnuTreeSpecEvent: TMenuItem;
    mnuTreeTypeSpec: TMenuItem;
    mnuTreePkgType: TMenuItem;
    mnuTreeCustom: TMenuItem;
    mnuExpandAll: TMenuItem;
    mnuExpand1Level: TMenuItem;
    mnuCollapseAll: TMenuItem;
    mnuTreeRefresh1: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    splMemInfo: TSplitter;
    splpnlTree: TSplitter;
    ListWinAbsViewer: TMag4Viewer;
    pnlfullres: TPanel;
    ListWinFullViewer: TMag4Viewer;
    magViewerTB81: TmagViewerTB8;
    pnlMagListView1: TPanel;
    splmemReport: TSplitter;
    MagListView1: TMagListView;
    memReport: TMemo;
    splpnlFullRes: TSplitter;
    mnuList: TMenuItem;
    mnuShowList: TMenuItem;
    N18: TMenuItem;
    mnuSelectColumns: TMenuItem;
    mnuFitColToText: TMenuItem;
    mnuFitColToWin: TMenuItem;
    N19: TMenuItem;
    mnuShowGrid: TMenuItem;
    mnuPreviewAbstract: TMenuItem;
    mnuPreviewReport: TMenuItem;
    mnuThumbnails1: TMenuItem;
    mnuShowThumbNail: TMenuItem;
    mnuThumbNailWindow: TMenuItem;
    mnuThumbsBottom2: TMenuItem;
    mnuThumbsLeft2: TMenuItem;
    mnuThumbsBottomTree2: TMenuItem;
    N21: TMenuItem;
    mnuThumbsRefresh2: TMenuItem;
    splpnlabstree: TSplitter;
    mnuFilters: TMenuItem;
    mnuNFilter1: TMenuItem;
    mnuNFilter2: TMenuItem;
    timerSyncTimer: TTimer;
    mnuLayouts: TMenuItem;
    ExplorerStyle1: TMenuItem;
    TreeList1: TMenuItem;
    TreeAbs1: TMenuItem;
    Filmstrip1: TMenuItem;
    mnuFilmStripLeft: TMenuItem;
    AbsList1: TMenuItem;
    ListwithPreviews1: TMenuItem;
    N6: TMenuItem;
    mnuFullImageViewerWindow: TMenuItem;
    mnuOpenGroupThumbnailPreview: TMenuItem;
    ilMain24n: TImageList;
    ilMain16n: TImageList;
    ilMain24u: TImageList;
    pnlMainToolbar: TPanel;
    Panel2: TPanel;
    magObserverLabel1: TmagObserverLabel;
    Label2: TLabel;
    pnlFilterDesc: TLabel;
    Label1: TLabel;
    mnuNReports1: TMenuItem;
    N10: TMenuItem;
    mnuNHelp1: TMenuItem;
    mnuListAbout: TMenuItem;
    mnuSyncSelectedImage: TMenuItem;
    N2: TMenuItem;
    View1: TMenuItem;
    mnuMUSEEKGlistIL: TMenuItem;
    mnuGroupWindow1: TMenuItem;
    N11: TMenuItem;
    mnuRadiologyExams1: TMenuItem;
    mnuMedicineProcedures1: TMenuItem;
    mnuLabExams1: TMenuItem;
    mnuSurgicalOperations1: TMenuItem;
    mnuProgressNotes1: TMenuItem;
    mnuClinicalProcedures1: TMenuItem;
    mnuConsults1: TMenuItem;
    N12: TMenuItem;
    mnuToolbars: TMenuItem;
    mnuListToolbarList: TMenuItem;
    mnuImageToolbar: TMenuItem;
    mnuVTtreesortbuttons: TMenuItem;
    mnuVTFilterTabs: TMenuItem;
    MainToolbarinTree1: TMenuItem;
    mnuIconShortCutKeyLegend1: TMenuItem;
    mnuMessageLog: TMenuItem;
    mnuListContext: TMenuItem;
    mnuSuspendContext1: TMenuItem;
    mnuResumeSetContext1: TMenuItem;
    mnuResumeGetContext1: TMenuItem;
    mnuShowContext1: TMenuItem;
    N8: TMenuItem;
    pnlContext: TPanel;
    imgCCOWbroken1: TImage;
    imgCCOWchanging1: TImage;
    imgCCOWLink1: TImage;
    mnuUserPreferences1: TMenuItem;
    MagPublisher1: TMagPublisher;
    N22: TMenuItem;
    N20: TMenuItem;
    RemoteImageViewsConfiguration1: TMenuItem;
    ConfigureUserPreferences1: TMenuItem;
    SaveSettingsNow1: TMenuItem;
    mnuSaveSettingsonExit1: TMenuItem;
    ShowHintsonThiswindow1: TMenuItem;
    N23: TMenuItem;
    HintsOFFforallwindows1: TMenuItem;
    HintsONforallwindows1: TMenuItem;
    N24: TMenuItem;
    mnuManager: TMenuItem;
    mnuWorkstationConfigurationwindow1: TMenuItem;
    mnuClearCurrentPatient1: TMenuItem;
    mnuShowMessagesfromlastOpenSecureFileCall1: TMenuItem;
    mnuImageFileNetSecurityON1: TMenuItem;
    mnuPatientLookupLoginEnabled1: TMenuItem;
    mnuSetWorkstationsAlternateVideoViewer1: TMenuItem;
    mnuChangeTimeoutvalue1: TMenuItem;
    OpenDialogListWin: TOpenDialog;
    mnuCPRSSyncOptions1: TMenuItem;
    N25: TMenuItem;
    lvImageInfo: TListView;
    mnuAutoExpandCollapse: TMenuItem;
    listwinResizeTimer: TTimer;
    MagSubscriber1: TMagSubscriber;
    ColorDialog1: TColorDialog;
    Color1: TMenuItem;
    pnlFilterTabs: TPanel;
    tabctrlFilters: TTabControl;
    mnuPrefetch1: TMenuItem;
    mnuRemoteConnections1: TMenuItem;
    mnuSelectColumnSet: TMenuItem;
    mnuSaveColumnSet: TMenuItem;
    N27: TMenuItem;
    mnuIndexEdit2: TMenuItem;
    mnuImageListFilters2: TMenuItem;
    mnuRefreshFilterList2: TMenuItem;
    mnuFiltersasTabs2: TMenuItem;
    mnuMultiLineTabs2: TMenuItem;
    popupAbstracts: TPopupMenu;
    mnuOpen3: TMenuItem;
    mnuViewImagein2ndRadiologyWindow3: TMenuItem;
    mnuImageReport3: TMenuItem;
    mnuImageDelete3: TMenuItem;
    mnuImageInformation3: TMenuItem;
    mnuImageInformationAdvanced3: TMenuItem;
    mnuCacheGroup3: TMenuItem;
    MenuItem2: TMenuItem;
    mnuRefresh3: TMenuItem;
    mnuResizetheAbstracts3: TMenuItem;
    MenuItem3: TMenuItem;
    mnuFontSize3: TMenuItem;
    mnuFont6: TMenuItem;
    mnuFont7: TMenuItem;
    mnuFont8: TMenuItem;
    mnuFont10: TMenuItem;
    mnuFont12: TMenuItem;
    mnuToolbar3: TMenuItem;
    MenuItem12: TMenuItem;
    Mag4Vgear1: TMag4Vgear;
    popupImage: TPopupMenu;
    mnuZoom4: TMenuItem;
    ZoomIn4: TMenuItem;
    ZoomOut4: TMenuItem;
    mnuFitToWidth4: TMenuItem;
    mmuFitToWindow4: TMenuItem;
    mnuActualSize4: TMenuItem;
    mnuMouse4: TMenuItem;
    mnuMousePan4: TMenuItem;
    mnuMouseMagnify4: TMenuItem;
    mnuMouseZoom4: TMenuItem;
    mnuMousePointer4: TMenuItem;
    mnuRotate4: TMenuItem;
    mnuRotateRight4: TMenuItem;
    mnuRotateLeft4: TMenuItem;
    mnuRotate1804: TMenuItem;
    FlipHorizontal4: TMenuItem;
    FlipVertical4: TMenuItem;
    mnuInvert4: TMenuItem;
    mnuReset4: TMenuItem;
    mnuRemoveImage4: TMenuItem;
    MenuItem1: TMenuItem;
    mnuImageReport4: TMenuItem;
    mnuImageDelete4: TMenuItem;
    mnuImageInformation4: TMenuItem;
    mnuImageInformationAdvanced4: TMenuItem;
    MenuItem7: TMenuItem;
    mnuFontSize4: TMenuItem;
    mnu6pt: TMenuItem;
    mnu7pt: TMenuItem;
    mnu8pt: TMenuItem;
    mnu10pt: TMenuItem;
    mnu12pt: TMenuItem;
    mnuToolbar4: TMenuItem;
    GetZoomLevelOfSelectedImage1: TMenuItem;
    PopupTree: TPopupMenu;
    mnuOpenImage6: TMenuItem;
    mnuImageReport6: TMenuItem;
    mnuImageDelete6: TMenuItem;
    mnuImageInformation6: TMenuItem;
    mnuImageInformationAdvanced6: TMenuItem;
    N1: TMenuItem;
    mnuSortButtons6: TMenuItem;
    N7: TMenuItem;
    mnuExpandAll6: TMenuItem;
    mnuExpand1level6: TMenuItem;
    mnuCollapseAll6: TMenuItem;
    mnuSorts6: TMenuItem;
    mnuAlphabeticSort6: TMenuItem;
    mnuRefresh6: TMenuItem;
    mnuPackage6: TMenuItem;
    mnuSpecialty6: TMenuItem;
    mnuClass6: TMenuItem;
    mnuType6: TMenuItem;
    N28: TMenuItem;
    mnuSpecialtyEvent6: TMenuItem;
    mnuTypeSpecialty6: TMenuItem;
    mnuPackageType6: TMenuItem;
    mnuCustom6: TMenuItem;
    mnuCacheGroup6: TMenuItem;
    mnuOpenin2ndRadWindow6: TMenuItem;
    N29: TMenuItem;
    N26: TMenuItem;
    AutoExpandCollapse1: TMenuItem;
    Panel1: TPanel;
    PageScroller1: TPageScroller;
    tlbrImageListMain: TToolBar;
    tbtnPatient: TToolButton;
    tbtnRefresh: TToolButton;
    tbtnFilter: TToolButton;
    tbtnUserPref: TToolButton;
    tbtnAbstracts: TToolButton;
    tbtnImage: TToolButton;
    tbtnReport: TToolButton;
    tbtnPrevAbs: TToolButton;
    tbtnPrevReport: TToolButton;
    tbtnFitCol: TToolButton;
    tbtnFitColWin: TToolButton;
    tbtnSelectColumn: TToolButton;
    pnlPatPhoto: TPanel;
    MagPatPhoto1: TMagPatPhoto;
    mnuClose1: TMenuItem;
    lbSpacer: TLabel;
    mnuRptWordWrap: TMenuItem;
    mnuEvent6: TMenuItem;
    empTestAbs1: TMenuItem;
    mnuTESTAbsButtonDown1: TMenuItem;
    mnuTESTAbsButtonUp1: TMenuItem;
    mnuTESTShowAbschecked1: TMenuItem;
    mnuTESTShowAbsNotChecked1: TMenuItem;
    enableAbsButton1: TMenuItem;
    DisableAbsButton1: TMenuItem;
    ToolButton2: TToolButton;
    N30: TMenuItem;
    N31: TMenuItem;
    mnuListRefresh: TMenuItem;
    mnuSetImageStatusQAReviewed: TMenuItem;
    N34: TMenuItem;
    mnuVerifyFull4: TMenuItem;
    mnuImageIndexEditAbs3: TMenuItem;
    mnuImageIndexEditTree6: TMenuItem;
    mnuImageIndexEditFull4: TMenuItem;
    estingAddImagetoViewer1: TMenuItem;
    mnuTestSyncAll: TMenuItem;
    N32: TMenuItem;
    mnuSetImageStatus: TMenuItem;
    mnuSetImageStatusNeedsReview: TMenuItem;
    mnuSetImageStatusViewable: TMenuItem;
    mnuSetControlledImage: TMenuItem;
    mnuSetControlledImageFalse: TMenuItem;
    mnuSetControlledImageTrue: TMenuItem;
    mnuImageIndexEdit1: TMenuItem;
    mnuAbsViewerScroll: TMenuItem;
    mnuAbsViewerScrollHoriz: TMenuItem;
    mnuAbsViewerScrollVert: TMenuItem;
    mnuTestsetcoolbandBreak: TMenuItem;
    MagSubscriber_Msgs: TMagSubscriber;
    mnuTestFixFullRespanel: TMenuItem;
    mnuFileImageCopy: TMenuItem;
    mnuFileImagePrint: TMenuItem;
    mnuListQAReviewReport: TMenuItem;
    colorcontrol1: TMenuItem;
    mnuFocusTree: TMenuItem;
    mnuFocusAbs: TMenuItem;
    mnuFocusList: TMenuItem;
    mnuFocusFull: TMenuItem;
    mnuFocusShow: TMenuItem;
    mnuImage1: TMenuItem;
    PagingControls1: TMenuItem;
    ZoomBrightnessContrast1: TMenuItem;
    N9: TMenuItem;
    mnuApplytoAll1: TMenuItem;
    mnuZoom1: TMenuItem;
    ZoomIn1: TMenuItem;
    ZoomOut1: TMenuItem;
    mnuFittoWidht1: TMenuItem;
    mnuFittoHeight1: TMenuItem;
    mnuFittoWindow1: TMenuItem;
    mnuActualSize1: TMenuItem;
    mnuMouse1: TMenuItem;
    mnuPan1: TMenuItem;
    mnuMagnify1: TMenuItem;
    mnuSelect1: TMenuItem;
    mnuPointer1: TMenuItem;
    mnuRotate1: TMenuItem;
    Rightclockwise1: TMenuItem;
    Left1: TMenuItem;
    N33: TMenuItem;
    mnuFlipHoriz1: TMenuItem;
    mnuFlipVertical1: TMenuItem;
    mnuConBri1: TMenuItem;
    mnuContrastP1: TMenuItem;
    mnuContrastM1: TMenuItem;
    mnuBrightnessP1: TMenuItem;
    mnuBrightnessM1: TMenuItem;
    mnuInvert1: TMenuItem;
    mnuReset1: TMenuItem;
    mnuScroll1: TMenuItem;
    mnuScrollToCornerTL1: TMenuItem;
    mnuScrollToCornerTR1: TMenuItem;
    mnuScrollToCornerBL1: TMenuItem;
    mnuScrollToCornerBR1: TMenuItem;
    mnuScrollLeft1: TMenuItem;
    mnuScrollRight1: TMenuItem;
    mnuScrollUp1: TMenuItem;
    mnuScrollDown1: TMenuItem;
    mnuMaximize1: TMenuItem;
    DeSkewSmooth1: TMenuItem;
    N35: TMenuItem;
    PreviousImage1: TMenuItem;
    NextImage1: TMenuItem;
    pnlfocus: TPanel;
    FocusNextControl1: TMenuItem;
    NextControl1: TMenuItem;
    mnuFocusBar: TMenuItem;
    N3: TMenuItem;
    N36: TMenuItem;
    dimensions1: TMenuItem;
    mnuD: TMenuItem;
    setto1280x10241: TMenuItem;
    mnuCurrentSettings: TMenuItem;
    mnuListHelpWhatNew93: TMenuItem;
    mnuROIPrintOptions: TMenuItem;
    pnlROIoptions: TPanel;
    lbCheckedImageCount: TLabel;
    N37: TMenuItem;
    mnuROISelectImagestoPrint: TMenuItem;
    Printalllistedimages1: TMenuItem;
    lbCheckAll: TLabel;
    lbCheckNone: TLabel;
    btnContinueToROIPrintWindow: TBitBtn;
    btnCancelCheckBoxSelection: TBitBtn;
    mnuShowDeletedImageInformation: TMenuItem;
    Label3: TLabel;
    Shape1: TShape;
    NCATTesting1: TMenuItem;
    mnu_ShowUrlMap: TMenuItem;
    btnCheckAll: TBitBtn;
    btnCheckNone: TBitBtn;
    lbCheckButtons: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mmuImageReport2Click(Sender: TObject);
    procedure mnuOpenImage2Click(Sender: TObject);
    procedure mnuImageInfoAdv2Click(Sender: TObject);
    procedure XlvImageListKeyDown(Sender: TObject; var Key: Word; Shift:
      TShiftState);
    procedure FormResize(Sender: TObject);
    procedure mnuImageDelete2Click(Sender: TObject);
    procedure mnuFitColToText2Click(Sender: TObject);
    procedure SelectColumns2Click(Sender: TObject);
    procedure MagListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure MagListView1DblClick(Sender: TObject);
    procedure MagListView1KeyDown(Sender: TObject; var Key: Word; Shift:
      TShiftState);
    procedure tbtnImageClick(Sender: TObject);
    procedure tbtnReportClick(Sender: TObject);
    procedure tbtnFitColClick(Sender: TObject);
    procedure tbtnPrevAbsClick(Sender: TObject);
    procedure tbtnPrevReportClick(Sender: TObject);
    procedure tbtnUserPrefClick(Sender: TObject);
    procedure tbtnFilterClick(Sender: TObject);
    procedure mnuFitColToWin2Click(Sender: TObject);
    procedure tbtnFitColWinClick(Sender: TObject);
    procedure mnuImageInformation2Click(Sender: TObject);
    procedure mnuFontClick(Sender: TObject);
    procedure mnuExit1Click(Sender: TObject);
    procedure mnuImageReport1Click(Sender: TObject);
    procedure mnuOpenImage1Click(Sender: TObject);
    procedure mnuBrowseImageListClick(Sender: TObject);
    procedure mnuOptionsClick(Sender: TObject);
    procedure menuMagListViewPopup(Sender: TObject);
    procedure mnuImageInformation1Click(Sender: TObject);
    procedure mnuImageInformationAdvanced1Click(Sender: TObject);
    procedure GotoMainWindow1Click(Sender: TObject);
    procedure mnuUtilitiesClick(Sender: TObject);
    procedure mnuStayonTop1Click(Sender: TObject);
    procedure ImageFilter1Click(Sender: TObject);
    procedure mnuImageDelete1Click(Sender: TObject);
    procedure mnuFileClick(Sender: TObject);
    procedure ImageListingwindow1Click(Sender: TObject);
    procedure mnuOpenImagein2ndRadiologyWindow1Click(Sender: TObject);
    /////////////////
    procedure MagMenuFilterClick(sender: TObject);
    procedure mnuRefreshFilterlistClick(Sender: TObject);
    procedure tabctrlFiltersChange(Sender: TObject);
    procedure mnuMultiLineTabs1Click(Sender: TObject);
    procedure mnuSelectPatient1Click(Sender: TObject);
    procedure Mag4VGear1Click(Sender: TObject);
    procedure Mag4VGear1ImageClick(sender: TObject; Gearclicked:
      TMag4Vgear);
    procedure pnlDockDockDrop(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer);
    procedure mnuOpenImageIDClick(Sender: TObject);
    procedure tbtnHelpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure mnuShowFilterDetailsClick(Sender: TObject);
    procedure Mag4VGear1ImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mnuIndexEditClick(Sender: TObject);
    procedure mnuMultiLineClick(Sender: TObject);
    procedure mnuRefreshPatientImagesClick(Sender: TObject);
    procedure tbtnAbstractsClick(Sender: TObject);
    procedure UpreftoImageListWin1Click(Sender: TObject);
    procedure mnuCacheGroup2Click(Sender: TObject);
    procedure mnuCacheGroup1Click(Sender: TObject);
    procedure tbtnPatientClick(Sender: TObject);
    procedure mnuViewAbstractsClick(Sender: TObject);
    procedure MagListView1GetSubItemImage(Sender: TObject; Item: TListItem;
      SubItem: Integer; var ImageIndex: Integer);
    procedure ActiveForms1Click(Sender: TObject);
    procedure ShortCutMenu1Click(Sender: TObject);
    procedure tbtnRefreshClick(Sender: TObject);
    procedure mnuFilterInfo2Click(Sender: TObject);

    procedure Mag4VGear1ImageMouseDown(Sender: TObject; Button:
      TMouseButton; Shift: TShiftState; X, Y: Integer);
    //    procedure Label1Click(Sender: TObject);
    procedure mnuPatientProfile1Click(Sender: TObject);
    procedure mnuHealthSummary1Click(Sender: TObject);
    procedure mnuDischargeSummary1Click(Sender: TObject);
    procedure FilterDetails1Click(Sender: TObject);
    procedure mnuFiltersasTabs1Click(Sender: TObject);
    procedure ListWinFullViewerViewerImageClick(sender: TObject);
    procedure pgctrlTreeViewChange(Sender: TObject);
    procedure mnuTreeClick(Sender: TObject);
    procedure mnuShowListClick(Sender: TObject);
    procedure mnuSelectColumnsClick(Sender: TObject);
    procedure mnuFitColToTextClick(Sender: TObject);
    procedure mnuFitColToWinClick(Sender: TObject);
    procedure mnuShowGridClick(Sender: TObject);
    procedure mnuPreviewAbstractClick(Sender: TObject);
    procedure mnuPreviewReportClick(Sender: TObject);
    procedure tbtnSelectColumnClick(Sender: TObject);
    procedure mnuShowThumbNailClick(Sender: TObject);
    procedure mnuThumbNailWindowClick(Sender: TObject);
    procedure mnuThumbsBottom2Click(Sender: TObject);
    procedure mnuThumbsLeft2Click(Sender: TObject);
    procedure mnuThumbsBottomTree2Click(Sender: TObject);
    procedure mnuThumbsRefresh2Click(Sender: TObject);
    procedure mnuShowTreeClick(Sender: TObject);
    procedure mnuAlphaSortClick(Sender: TObject);
    procedure mnuTreeSpecEventClick(Sender: TObject);
    procedure mnuTreeTypeSpecClick(Sender: TObject);
    procedure mnuTreePkgTypeClick(Sender: TObject);
    procedure mnuTreeCustomClick(Sender: TObject);
    procedure mnuExpandAllClick(Sender: TObject);
    procedure mnuExpand1LevelClick(Sender: TObject);
    procedure mnuCollapseAllClick(Sender: TObject);
    procedure mnuTreeRefresh1Click(Sender: TObject);
    procedure MagTreeView1Click(Sender: TObject);
    procedure MagTreeView1Collapsed(Sender: TObject; Node: TTreeNode);
    procedure MagTreeView1Expanded(Sender: TObject; Node: TTreeNode);
    procedure MagTreeView1GetSelectedIndex(Sender: TObject; Node:
      TTreeNode);
    procedure MagTreeView1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure timerSyncTimerTimer(Sender: TObject);
    procedure ListWinAbsViewerViewerImageClick(sender: TObject);
    procedure mnuLayoutsClick(Sender: TObject);
    procedure ExplorerStyle1Click(Sender: TObject);
    procedure TreeList1Click(Sender: TObject);
    procedure TreeAbs1Click(Sender: TObject);
    procedure Filmstrip1Click(Sender: TObject);
    procedure mnuFilmStripLeftClick(Sender: TObject);
    procedure AbsList1Click(Sender: TObject);
    procedure ListwithPreviews1Click(Sender: TObject);
    procedure mnuFullImageViewerWindowClick(Sender: TObject);
    procedure mnuOpenGroupThumbnailPreviewClick(Sender: TObject);
    procedure pnlfullresDockOver(Sender: TObject; Source: TDragDockObject;
      X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure mnuListAboutClick(Sender: TObject);
    procedure mnuReports1Click(Sender: TObject);
    procedure MagListView1Click(Sender: TObject);
    procedure mnuSyncSelectedImageClick(Sender: TObject);
    procedure mnuListClick(Sender: TObject);
    procedure View1Click(Sender: TObject);
    procedure mnuListToolbarListClick(Sender: TObject);
    procedure mnuImageToolbarClick(Sender: TObject);
    procedure mnuVTtreesortbuttonsClick(Sender: TObject);
    procedure mnuVTFilterTabsClick(Sender: TObject);
    procedure MainToolbarinTree1Click(Sender: TObject);
    procedure mnuThumbnails1Click(Sender: TObject);
    procedure mnuMessageLogClick(Sender: TObject);
    procedure mnuIconShortCutKeyLegend1Click(Sender: TObject);
    procedure mnuTreeTabs1Click(Sender: TObject);
    procedure mnuToolbarsClick(Sender: TObject);
    procedure MagSubscriber1SubscriberUpdate(newsObj: TMagNewsObject);
    procedure ConfigureUserPreferences1Click(Sender: TObject);
    procedure mnuWorkstationConfigurationwindow1Click(Sender: TObject);
    procedure mnuClearCurrentPatient1Click(Sender: TObject);
    procedure mnuImageFileNetSecurityON1Click(Sender: TObject);
    procedure mnuManagerClick(Sender: TObject);
    procedure mnuShowMessagesfromlastOpenSecureFileCall1Click(Sender:
      TObject);
    procedure mnuChangeTimeoutvalue1Click(Sender: TObject);
    procedure mnuPatientLookupLoginEnabled1Click(Sender: TObject);
    procedure mnuSetWorkstationsAlternateVideoViewer1Click(Sender: TObject);
    procedure mnuCPRSSyncOptions1Click(Sender: TObject);
    procedure SaveSettingsNow1Click(Sender: TObject);
    procedure mnuSaveSettingsonExit1Click(Sender: TObject);
    procedure RemoteImageViewsConfiguration1Click(Sender: TObject);
    procedure mnuShowHints1Click(Sender: TObject);
    procedure ShowHintsonThiswindow1Click(Sender: TObject);
    procedure HintsOFFforallwindows1Click(Sender: TObject);
    procedure HintsONforallwindows1Click(Sender: TObject);
    procedure btnFilterImageListClick(Sender: TObject);
    procedure mnuAutoExpandCollapseClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure Color1Click(Sender: TObject);
    procedure mnuShowContext1Click(Sender: TObject);
    procedure mnuSuspendContext1Click(Sender: TObject);
    procedure mnuResumeGetContext1Click(Sender: TObject);
    procedure mnuResumeSetContext1Click(Sender: TObject);
    procedure mnuListContextClick(Sender: TObject);
    procedure mnuGroupWindow1Click(Sender: TObject);
    procedure mnuMUSEEKGlistILClick(Sender: TObject);
    procedure mnuPrefetch1Click(Sender: TObject);
    procedure mnuRadiologyExams1Click(Sender: TObject);
    procedure mnuProgressNotes1Click(Sender: TObject);
    procedure mnuClinicalProcedures1Click(Sender: TObject);
    procedure mnuConsults1Click(Sender: TObject);
    procedure mnuRemoteConnections1Click(Sender: TObject);
    procedure mnuSelectColumnSetClick(Sender: TObject);
    procedure mnuSaveColumnSetClick(Sender: TObject);
    procedure ListWinAbsViewerDragOver(Sender, Source: TObject; X, Y:
      Integer; State: TDragState; var Accept: Boolean);
    procedure ListWinAbsViewerDragDrop(Sender, Source: TObject; X, Y:
      Integer);
    procedure mnuIndexEdit2Click(Sender: TObject);
    procedure mnuImageListFilters2Click(Sender: TObject);
    procedure mnuRefreshFilterList2Click(Sender: TObject);
    procedure mnuFiltersasTabs2Click(Sender: TObject);
    procedure mnuMultiLineTabs2Click(Sender: TObject);
    procedure FilterTabPopupPopup(Sender: TObject);
    procedure popupAbstractsPopup(Sender: TObject);
    procedure mnuViewImagein2ndRadiologyWindow3Click(Sender: TObject);
    procedure mnuOpen3Click(Sender: TObject);
    procedure mnuImageReport3Click(Sender: TObject);
    procedure mnuImageDelete3Click(Sender: TObject);
    procedure mnuImageInformation3Click(Sender: TObject);
    procedure mnuImageInformationAdvanced3Click(Sender: TObject);
    procedure mnuCacheGroup3Click(Sender: TObject);
    procedure popupImagePopup(Sender: TObject);
    procedure mnuActualSize4Click(Sender: TObject);
    procedure mmuFitToWindow4Click(Sender: TObject);
    procedure mnuFitToWidth4Click(Sender: TObject);
    procedure ZoomOut4Click(Sender: TObject);
    procedure ZoomIn4Click(Sender: TObject);
    procedure mnuMousePan4Click(Sender: TObject);
    procedure mnuMouseMagnify4Click(Sender: TObject);
    procedure mnuMouseZoom4Click(Sender: TObject);
    procedure mnuMousePointer4Click(Sender: TObject);
    procedure mnuRotateRight4Click(Sender: TObject);
    procedure mnuRotateLeft4Click(Sender: TObject);
    procedure mnuRotate1804Click(Sender: TObject);
    procedure FlipHorizontal4Click(Sender: TObject);
    procedure FlipVertical4Click(Sender: TObject);
    procedure mnuInvert4Click(Sender: TObject);
    procedure mnuReset4Click(Sender: TObject);
    procedure mnuRemoveImage4Click(Sender: TObject);
    procedure mnuImageReport4Click(Sender: TObject);
    procedure mnuImageDelete4Click(Sender: TObject);
    procedure mnuImageInformation4Click(Sender: TObject);
    procedure mnuImageInformationAdvanced4Click(Sender: TObject);
    procedure mnuFont6Click(Sender: TObject);
    procedure mnuFont7Click(Sender: TObject);
    procedure mnuFont8Click(Sender: TObject);
    procedure mnuFont10Click(Sender: TObject);
    procedure mnuFont12Click(Sender: TObject);
    procedure mnuToolbar3Click(Sender: TObject);
    procedure mnuToolbar4Click(Sender: TObject);
    procedure mnu6ptClick(Sender: TObject);
    procedure mnu7ptClick(Sender: TObject);
    procedure mnu8ptClick(Sender: TObject);
    procedure mnu10ptClick(Sender: TObject);
    procedure mnu12ptClick(Sender: TObject);
    procedure PopupTreePopup(Sender: TObject);
    procedure mnuOpenImage6Click(Sender: TObject);
    procedure mnuImageReport6Click(Sender: TObject);
    procedure mnuImageDelete6Click(Sender: TObject);
    procedure mnuImageInformation6Click(Sender: TObject);
    procedure mnuImageInformationAdvanced6Click(Sender: TObject);
    procedure mnuCacheGroup6Click(Sender: TObject);
    procedure mnuOpenin2ndRadWindow6Click(Sender: TObject);
    procedure MagTreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure MagTreeView1DblClick(Sender: TObject);
    procedure MagTreeView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure listwinResizeTimerTimer(Sender: TObject);
    procedure AutoExpandCollapse1Click(Sender: TObject);
    procedure mnuSortButtons6Click(Sender: TObject);
    procedure mnuSpecialtyEvent6Click(Sender: TObject);
    procedure mnuTypeSpecialty6Click(Sender: TObject);
    procedure mnuPackageType6Click(Sender: TObject);
    procedure mnuCustom6Click(Sender: TObject);
    procedure mnuExpandAll6Click(Sender: TObject);
    procedure mnuExpand1level6Click(Sender: TObject);
    procedure mnuCollapseAll6Click(Sender: TObject);
    procedure mnuAlphabeticSort6Click(Sender: TObject);
    procedure mnuRefresh6Click(Sender: TObject);
    procedure mnuPackage6Click(Sender: TObject);
    procedure mnuSpecialty6Click(Sender: TObject);
    procedure mnuClass6Click(Sender: TObject);
    procedure mnuType6Click(Sender: TObject);
    procedure mnuResizetheAbstracts3Click(Sender: TObject);
    procedure MagPatPhoto1Click(Sender: TObject);
    procedure mnuClose1Click(Sender: TObject);
    procedure fontDlgReportPopup(Sender: TObject);
    procedure mnuRptWordWrapClick(Sender: TObject);
    procedure mnuEvent6Click(Sender: TObject);
    procedure mnuTESTAbsButtonDown1Click(Sender: TObject);
    procedure mnuTESTAbsButtonUp1Click(Sender: TObject);
    procedure mnuTESTShowAbschecked1Click(Sender: TObject);
    procedure mnuTESTShowAbsNotChecked1Click(Sender: TObject);
    procedure enableAbsButton1Click(Sender: TObject);
    procedure DisableAbsButton1Click(Sender: TObject);
    procedure tabctrlFiltersChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure mnuListRefreshClick(Sender: TObject);
    procedure mnuSetImageStatusQAReviewedClick(Sender: TObject);
    procedure mnuVerifyFull4Click(Sender: TObject);
    procedure MagTreeView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mnuImageIndexEditAbs3Click(Sender: TObject);
    procedure mnuImageIndexEditFull4Click(Sender: TObject);
    procedure estingAddImagetoViewer1Click(Sender: TObject);
    procedure mnuTestSyncAllClick(Sender: TObject);
    procedure ImageIndexEdit1Click(Sender: TObject);
    procedure mnuImageIndexEditTree6Click(Sender: TObject);
    procedure mnuSetImageStatusClick(Sender: TObject);
    procedure mnuSetControlledImageClick(Sender: TObject);
    procedure mnuSetImageStatusViewableClick(Sender: TObject);
    procedure mnuSetImageStatusNeedsReviewClick(Sender: TObject);
    procedure mnuSetControlledImageFalseClick(Sender: TObject);
    procedure mnuSetControlledImageTrueClick(Sender: TObject);
    procedure mnuAbsViewerScrollHorizClick(Sender: TObject);
    procedure mnuAbsViewerScrollVertClick(Sender: TObject);
    procedure mnuAbsViewerScrollClick(Sender: TObject);
    procedure mnuTestsetcoolbandBreakClick(Sender: TObject);
    procedure MagSubscriber_MsgsSubscriberUpdate(newsObj: TMagNewsObject);
    procedure FormShow(Sender: TObject);
    procedure mnuTestFixFullRespanelClick(Sender: TObject);
    procedure mnuFileImagePrintClick(Sender: TObject);
    procedure magViewerTB81CopyClick(sender: TObject; Viewer: TMag4Viewer);
    procedure magViewerTB81PrintClick(sender: TObject;
      Viewer: TMag4Viewer);
    procedure mnuFileImageCopyClick(Sender: TObject);
    procedure mnuListQAReviewClick(Sender: TObject);
    procedure mnuListQAReviewReportClick(Sender: TObject);
    procedure mnuFocusTreeClick(Sender: TObject);
    procedure mnuFocusAbsClick(Sender: TObject);
    procedure mnuFocusListClick(Sender: TObject);
    procedure mnuFocusFullClick(Sender: TObject);
    procedure mnuFocusShowClick(Sender: TObject);
    procedure FocusNextControl1Click(Sender: TObject);
    procedure mnuFocusBarClick(Sender: TObject);
    procedure NextControl1Click(Sender: TObject);
    procedure mnuDClick(Sender: TObject);
    procedure setto1280x10241Click(Sender: TObject);
    procedure dimensions1Click(Sender: TObject);
    procedure mnuListHelpWhatNew93Click(Sender: TObject);
    procedure mnuROIPrintOptionsClick(Sender: TObject);
    procedure btnContinueToROIPrintWindowClick(Sender: TObject);
    procedure mnuROISelectImagestoPrintClick(Sender: TObject);
    procedure Printalllistedimages1Click(Sender: TObject);
    procedure lbCheckAllClick(Sender: TObject);
    procedure lbCheckAllMouseEnter(Sender: TObject);
    procedure lbCheckAllMouseLeave(Sender: TObject);
    procedure lbCheckNoneClick(Sender: TObject);
    procedure btnCancelCheckBoxSelectionClick(Sender: TObject);
    procedure lbCheckNoneMouseEnter(Sender: TObject);
    procedure lbCheckNoneMouseLeave(Sender: TObject);
    procedure mnuShowDeletedImageInformationClick(Sender: TObject);
    procedure mnu_ShowUrlMapClick(Sender: TObject);
    procedure btnCheckAllClick(Sender: TObject);
    procedure btnCheckNoneClick(Sender: TObject);
    procedure MagListView1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    {   Save the top index in the Info List View, and apply after reload}
    FUseFocusBar: boolean;
    FLastActive: Twincontrol;
    FlvInfoTopIndex: integer;
    Fimagelistsyncprocessing: boolean;
    {   Flag set in OnPaint event, to stop certain code from being called more than once}
    FHitX, FHitY: integer;
    FCurTreeNode: TTreenode;

    FAbsPrev: boolean;
    FPreviewReportIList: boolean;
    Fdisplaying: boolean;
    Fdfn: string;
    Fdftheight: integer;
    FMaintainfocus: boolean;
    FLastFilterInfo: integer;
    //FOnLogEvent: TMagLogEvent; {JK 10/5/2009 - Maggmsgu refactoring}
    {//117 gek 8/18  FROIwasSingleClickEnabled :
      keep value of single or double click upref.  may need to reset it after ROI is finished.}
    FROIwasSingleClickEnabled :  boolean; // 117
    function CreateAdminFilter: string;
    function CreateClinFilter: string;
    function IsListItemSingleRadImage: boolean;
    procedure ViewSelectedItemImage(radcode: integer = 1);
    procedure ViewSelectedItemReport(preview: boolean = false; li: Tlistitem = nil);
    procedure FitColumnsToText;

    //    function GetImageObject(LI: Tlistitem): TImageData;
    procedure PreviewAbs(LI: TListitem);
    procedure PreviewRpt(item: Tlistitem);
    //    procedure ShowFullResViewer(stat: boolean);
    //    procedure AddImageToViewer;
    procedure ClearPreviews;
    procedure StretchWindow;

    procedure DeleteSelectedImage;
    procedure SetCurrentFilter(fltstring: string); overload;
    procedure SetCurrentFilter(filter: Timagefilter); overload;
    procedure ClearCurrentFilter;
    procedure ReDisplayMultiLine;
    procedure SetMultilineTabs(value: boolean);
    procedure SelectFirstListImage;

    procedure RefreshAbstract;
    procedure winmsg(stbarPanel: integer; s: string);
    procedure WinMsgClear();
    function IsGroupImageSelectedInList: boolean;
    procedure MultiEntryEdit(magienlist: TStrings);
    procedure OneEntryEdit(magien: string);

    procedure RIVRecieveUpdate_(Action: string; Value: string);
    // recieve updates from everyone

    procedure ShowSelectedImageInfo;
    procedure ShowSelectedImageInfoSys;
    function DetailedDesc2(filter: TImagefilter): Tstrings;
    //moved to uMagDisplayMgr
    //    function XwbGetVarValue(value: string): string;
    procedure SetFilterHint;
    procedure FilterDetailsInInfoWindow;
	//out in 94, but keep comments in code. gek.
    //procedure SetLogEvent(LogEvent: TMagLogEvent);  {JK 10/6/2009 - Maggmsgu refactoring - remove old method}
    //procedure LogMsg(MsgType: string; Msg: string; Priority: TMagLogPriority = MagLogINFO);{JK 10/5/2009 - Maggmsgu refactoring - removed old method}
    procedure RefreshLocalTree;
    procedure ListViewShow(value: boolean);
    procedure ShowHideThumbNails(value: boolean);

    procedure SetDefaultThumbNailAlignment;

    procedure OpenSelectedTreeImage(radcode: integer);
    procedure AbsOpenSelectedImage(Iobj: TImagedata; RadCode: integer);
    procedure FullResLocalShow(value: boolean);
    procedure ForceRepaint;
    procedure CreateDynamicHelpMenu;
    procedure CreateDynamicPatMenu;
    procedure CreateDynamicReportMenu;
    procedure HelpMenuitemSelected(sender: Tobject);
    procedure LoadHelpMenu;
    procedure PatMenuitemSelected(sender: Tobject);
    procedure ReportItemSelected(sender: Tobject);
    procedure DefaultToSyncOnAutoSelect;
    procedure OpenMainWinStyleSettings;
    procedure LoadLocalTree;
    procedure SetAllHintsOn(value: boolean = true);

    procedure TreeHide;
    procedure TreeShow;

    procedure SetDefaultFullViewerAlignment;
    procedure LoadFilterImageList;
    procedure ResizeAllImages(Sender: TObject);

    procedure CheckMark(Item: TMenuItem); {JK 1/4/2009 - fixes D31}
    procedure UnCheckMarkLayoutStyles;
    procedure FiltersAsTabs(value: boolean);
    procedure FilterTabsMultiLine(value: boolean);
    procedure SetAutoSelect(vautoon: boolean; vspeed: integer);
    procedure SetUprefControlPositions(value: string);

    procedure CacheFromImageListWindow(iobj: TImageData);
    procedure CurrentImageCache;
    procedure CurrentImageInformationAdvanced;
    procedure CurrentImageDelete;
    procedure CurrentImageReport;
    procedure CurrentImageOpen(displayflag: integer = 1);
    procedure TestMsg(value: string);
    procedure CurrentImageStatusChange(value: integer);
    procedure CurrentImageIndexEdit;
    function GetFocusedControl: TWincontrol;
    procedure SyncAllWithCurrent;
    procedure CurrentImageSensitiveChange(value: boolean);
    procedure TestFixFullRes;
    procedure savetopIndex;
    procedure ClearImageInfoControl;
    procedure ReSetTopIndex;
    procedure ImagePrintListWin;
    procedure ImageCopyListWin;
    procedure ActiveControlChangedListWin(Sender: TObject);
    procedure GenGoToNextControl(edt: TWinControl = nil);

    //    procedure CursorChange(var oldcurs : TCursor; newcurs : Tcursor);
    //    procedure CursorRestore(oldcurs : TCursor);

   //    procedure AddImageToViewer;
  //117 Gek  - new proecedures
  {/117t1  new procedures.    }
  procedure ImageListCheckBoxEnable(value : boolean);
  procedure ImageListCheckBoxCheckAll();
  procedure ImageListCheckBoxCheckNone();
  procedure CountCheckedImagesToPrint;
    procedure ROISelectionPanelShow(value: boolean);

  public
    {   Dynamic Menu objects to list and give user access to all open reports}
    MagReportMenu: TMag4Menu;
    {   Dynamic Menu object to give user access to the last patients that
         were selected this session.}
    MagPatMenu: TMag4Menu;
    {   Dynamic Help menu.  Will create a Menu Option in the 'Help' Menu
        for any file that starts with MagReadMe*.*  or MagWhatsNew*.*
        The 'Mag' and the extension are not displayed on the Menu Item}
    MagHelpMenu: TMag4Menu;
    { FCurSelectedImageObj : TImageData;  is defined in uMagDisplayMgr}
    FDefaultImageFilter: string;
    FCurrentFilter: TImageFilter;
    FFilerLast: TImageFilter; //p93t8
    FLastColumns: string; //p93t8
    //procedure Loadfrombase(baseimagelist: Tstrings; MagPat1: TMag4Pat);
    {   Adds all messages from MagSecurity object to the system message history list.
        Mainly for debugging}
    procedure FixFullResPosition;

    procedure AbThmLINKThumbNails(value: boolean; vmagimagelist:
      Tmagimagelist); //many
    procedure AbThmGetMenuStateFromUpref; //0
    procedure AbThmGetUprefFromMenuState; //0
    procedure AbThmGetMenuStateFromGUI; //0
    procedure AbThmGetUprefFromMenu; //0
    procedure AbThmGetUprefFromGUI; //1 frmMain
    procedure AbThmHideThm; //many
    procedure AbThmShowThm; //1 frmImageList

    procedure AbThmUseThumbNailWindow(value: boolean);
    procedure AbThmThumbsBottomTree;
    procedure AbThmThumbsBottom;
    procedure AbThmThumbsLeft;

    procedure ApplyFromUprefWindow;
    procedure LogSecurityMsgs;

    procedure setFilterOptions(tabs, multiline: boolean);
    procedure ShowAllFilters(fltList: Tstrings; duz: string);
    procedure ShowFilters(fltList: Tstrings; duz: string = '');
    procedure SetDefaultImageFilter(fltien: string);
    procedure ClearAllFilters;
    procedure RefreshAllFilters;
    procedure GetFilter;
    procedure ClearPat;
    procedure EnableKeyDependentClasses(hasClinKey, hasAdminKey: boolean);
    procedure SetAbsPreview(stat: boolean);
    procedure SetRptPreview(stat: boolean);
    function GetAbsPreview(): boolean;
    function GetRptPreview(): boolean;
    procedure UpdateFilteredList;
    procedure ClearImageControls;
    procedure Update_(SubjectState: string; sender: TObject);
    procedure SetDefaultHeight(ht: integer);

    //property OnLogEvent: TMagLogEvent read FOnLogEvent write SetLogEvent; {JK 10/5/2009 - Maggmsgu refactoring}
    //93
    {/p117 take this out,  so we don't get confused.  This is call that was moved to ImageINdex window.}
    //p117 procedure ImageIndexEdit(ListView: TMagListView; var editresult: boolean); {JK 1/6/2009 - fixed D19}
    procedure OpenUserPrefs;
    procedure UserPrefsApply(upref: Tuserpreferences);
    {JK 1/6/2009 - fixes D31}
    function GetUprefControlPositions(): string;

  end;

var
  frmImageList: TfrmImageList;
  {   This is the Panel of the StatusBar that the message will display in.}

implementation

uses
  dmsingle,
  fMagAbout,
  fmagAbsResize,
  fMagAbstracts,
  fmagFullRes,
  fMagGroupAbs,
  fmagindexedit,
  fmagListFilter,

  fmagReasonSelect,
  fmagUserPref,
  fmagVerify,
  inifiles,
  magfileversion,
  MaggMsgu,
  maggrpcu,
  Maggrptu,
  Magguini,
  maggut9,
  MagImageManager,
  magpositions,
  MagSyncCPRSu,
  MagTimeout,
  MagTIUWinu,
  Magwkcnf,
  SysUtils,
  umagAppMgr,
  uMagDisplayMgr,
//  uMagDisplayUtils,
  uMagFltMgr,
  uMagKeyMgr,
  umagutils8,
  umagUtils8A,
  Windows,
  fMagReleaseOfInfoPrint, //*** BB 08/24/2010 ***
  fMagURLMemoryMapViewer  {/ P117 NCAT - JK 12/13/2010 - for debug internal use only /}
  ;

//Uses Vetted 20090929:fMagImageInfo,

{$R *.DFM}
/// HERE , To set the autorealign for listwinABS and listwinFULLRES

procedure TfrmImageList.ResizeAllImages(Sender: TObject);
begin
  listwinResizeTimer.Enabled := false;
  application.processmessages;
  listwinResizeTimer.Enabled := true;
end;

procedure TfrmImageList.FormCreate(Sender: TObject);
begin
  FUseFocusBar := false;
  self.PageScroller1.TabStop := false;

  tlbrImageListMain.tabstop := false;
  FlvInfoTopIndex := 0;

  // this is 'Event' tab for Tree View.
  pnlMain.Visible := true;
  FSyncImageON := True;
  FUseThumbNailWindow := false;
  {This needs checked... for now Image List is always created with app.
      but in future, maybe not, then setting to NIL, will be wrong.}
{$IFDEF testmessages}
  winmsg(umagdefinitions.mmsglistwin, 'Fimagelistsyncprocessing: ' + magbooltostr(Fimagelistsyncprocessing));
{$ENDIF}
  SetCurSelectedImageObj(nil); {TfrmImageList.FormCreate}

  FCurTreeNode := nil;

  mag4vgear1.FontSize := 8;
  mag4vgear1.FitToWindow;
  mag4vgear1.AutoRedraw := true;

  magTreeview1.Align := alclient;
  magTreeview1.AutoSelect := false;

  ListWinAbsViewer.Align := alclient;
  if ListWinAbsViewer.MaxCount < 24 then
    ListWinAbsViewer.MaxCount := 24;
  listwinabsviewer.MagImageList := nil; {initialized in FormCreate.}
  newviewer := nil; {initialized in FormCreate.}

  RIVAttachListener(self);
  FLastFilterInfo := -1;
  FcurrentFilter := TImageFilter.create;
  pnlMain.Align := alclient;
  Mag4VGear1.Align := altop;
  Mag4VGear1.FontSize := 8;
  lvimageinfo.align := alclient;

  GetFormPosition(self as Tform);
  Fdftheight := 153;
  maglistview1.Align := alclient;
  pnlMagListView.align := alclient;
  pnlMagListView1.align := alclient;
  magImageList1.Attach_(IMagObserver(self));
  dmod.CCOWManager.Attach_(self); //93

  ListWinFullViewer.Align := alclient;
  if listwinfullviewer.MaxCount < 9 then
    listwinfullviewer.MaxCount := 9;
  pnlTree.Width := 250;
  self.ForceRepaint;
  pnlmaglistview.Height := 176;

  SetDefaultThumbNailAlignment;
  self.ListWinFullViewer.MagUtilsDB := dmod.MagUtilsDB1;

  {  Properties sometimes get lost during compile in IDE. Assure properties are set. }
  if not assigned(self.magImageList1.magdbbroker) then
    self.magImageList1.magdbbroker := dmod.MagDBBroker1;
  if not assigned(self.magImageList1.magPat) then
    self.magImageList1.magPat := dmod.MagPat1;
  if not assigned(self.magObserverLabel1.MagPat) then
    self.magObserverLabel1.MagPat := dmod.MagPat1;
  SetDefaultFullViewerAlignment;

  if self.MagPatPhoto1.MagDBBroker = nil then
  begin
    self.magpatphoto1.MagDBBroker := dmod.MagDBBroker1;
    self.magpatphoto1.MagSecurity := dmod.MagFileSecurity;
    self.magpatphoto1.MagPat := dmod.MagPat1;
  end;
  //TEST
  magpatphoto1.Enabled := false;

  CreateDynamicPatMenu;
  CreateDynamicReportMenu;
  CreateDynamicHelpMenu;

  self.magViewerTB81.PageScroller1.TabStop := false; //93t10
  self.magViewerTB81.PageScroller2.TabStop := false; //93t10

  {//117}
  pnlROIoptions.BevelOuter := bvNone;

end;

procedure TfrmImageList.CreateDynamicHelpMenu; //59
begin
  MagHelpMenu := TMag4Menu.create(self);
  with MagHelpMenu do
  begin
    MenuBarItem := mnuHelp;
    InsertAfterItem := mnuNHelp1;
    OnNewItemClick := HelpMenuItemSelected;
    MaxInsert := 10;
  end;
end;

procedure TfrmImageList.CreateDynamicPatMenu;
begin
  MagPatMenu := TMag4Menu.create(self);
  with MagPatMenu do
  begin
    {         Insert on the File menu after seperator N14}
    MenuBarItem := mnuFile;
    InsertAfterItem := mnuNFile1;
    OnNewItemClick := PatMenuItemSelected;
    MaxInsert := 10;
  end;
end;

procedure TfrmImageList.CreateDynamicReportMenu;
begin
  MagReportMenu := TMag4Menu.create(self);
  with MagReportMenu do
  begin
    {    Insert on the Reports menu after DischargeSummaries item}
    MenuBarItem := mnuReports1;
    InsertAfterItem := mnuNReports1;
    OnNewItemClick := ReportitemSelected;
    MaxInsert := 20;
  end;
end;

procedure TfrmImageList.PatMenuitemSelected(sender: Tobject);
begin
  (*  P8t46  Mofified cMagMenu to accept an ID (string) this will stop the
     NIOS that reported a problem with '.' in dfn*)

  frmmain.ChangeToPatient((Sender as TMagmenuItem).id);
end;

procedure TfrmImageList.HelpMenuitemSelected(sender: Tobject); //59
begin
  MagExecuteFile((Sender as TmagMenuItem).id, '', '', SW_SHOW);
end;

procedure TfrmImageList.ReportItemSelected(sender: Tobject);
var
  WinHandle: INTEGER;
begin
  {       Show the report window of clicked item }
  WinHandle := strtoint((Sender as TMagMenuItem).id); //TMagMenuItem is P8t46
  showWindow(WinHandle, SW_HIDE);
  showWindow(WinHandle, SW_SHOWNORMAL);
end;

procedure TfrmImageList.LoadHelpMenu; //59
var
  dir, mask, filters: string;
  maskitem: integer;
  sr: TsearchRec;
begin

  if findfirst(apppath + '\ImageDisplayHelpItem-*.*', faAnyFile, sr) <> 0 then
    exit;
  if fileexists(apppath + '\' + sr.name) then
    maghelpmenu.AddItem(magpiece(copy(sr.name, 22, 999), '.', 1), apppath +
      '\' + sr.Name, '');
  while findnext(sr) = 0 do
  begin
    if fileexists(apppath + '\' + sr.name) then
      maghelpmenu.AddItem(magpiece(copy(sr.name, 22, 999), '.', 1), apppath
        + '\' + sr.Name, '');
    winmsg(mmsglistwin, 'Help Menu Added : ' + sr.name);
  end;
end;

procedure TfrmImageList.ClearPat;
begin
  self.ClearAllFilters;
  self.ClearImageControls;
  self.ClearPreviews;
  self.MagPatMenu.ClearAll;
  self.MagReportMenu.ClearAll;
end;

procedure TfrmImageList.ForceRepaint;
begin
  { Invalidate didn't work. Update didn't work, this is funny, but it works.
     When we hide/show menu items, they don't always become visible so we need
     to refresh the window }
  frmImageList.width := frmImageList.width + 1;
  update;
  frmImageList.width := frmImageList.width - 1;
  update;
end;

{JK 10/5/2009 - Maggmsgu refactoring - remove old method}
//procedure TfrmImageList.SetLogEvent(LogEvent: TMagLogEvent);
//begin
//    FOnLogEvent := LogEvent;
//    // probably have to initialize children here (TMag4VGear)
//    //Mag4Viewer1.OnLogEvent := OnLogEvent;
//end;

{JK 10/5/2009 - Maggmsgu refactoring - removed old methods}
//procedure TfrmImageList.LogMsg(MsgType: string; Msg: string; Priority:
//    TMagLogPriority = MagLogINFO);
//begin
//    if assigned(OnLogEvent) then
//        OnLogEvent(self, MsgType, Msg, Priority);
//end;

procedure TfrmImageList.ClearImageInfoControl;
begin
  SaveTopIndex;
  lvImageInfo.Items.Clear;
end;

procedure TfrmImageList.ReSetTopIndex;
var
  scrollct: integer;
begin
  scrollct := 0;
  while lvimageinfo.TopItem.Index <> FlvInfoTopIndex do
  begin
    if lvimageinfo.topitem.Index > FlvInfoTopIndex then
      break;
    lvimageinfo.Scroll(0, 20);
    lvImageInfo.Update;
    inc(scrollct);
    if scrollct > 500 then
      break;
  end;
end;

procedure TfrmImageList.SaveTopIndex;
begin
  if lvImageInfo.TopItem = nil then
    FlvInfoTopIndex := 0
  else
  begin
    FlvInfoTopIndex := lvimageinfo.TopItem.Index;
    if FlvInfoTopIndex = -1 then
      FlvInfoTopIndex := 0;
  end;
end;

procedure TfrmImageList.ClearImageControls;
begin
  if application.Terminated then
    exit;
{$IFDEF testmessages}
  winmsg(umagdefinitions.mmsglistwin, 'Fimagelistsyncprocessing: ' + magbooltostr(Fimagelistsyncprocessing));
{$ENDIF}
  SetCurSelectedImageObj(nil); {TfrmImageList.ClearImageControls;}
  ClearImageInfoControl; {this also saves top index}
  MagListView1.ClearItems;
  pnlFilterDesc.caption := '';
  ClearPreviews;
  self.MagTreeView1.ClearItems;
  self.ListWinAbsViewer.ClearViewer;
  self.ListWinFullViewer.ClearViewer;
  winmsg(mmsglistwin, '');
  winmsg(0, '');
end;

procedure TfrmImageList.RIVRecieveUpdate_(Action: string; Value: string);
// recieve updates from everyone
var
  // ImageIEN, PlaceIEN : String;
  NetworkFilename: string;
  i: integer;
  IObj: TImageData;
begin
  //  PlaceIEN := magPiece(Value, '|', 1);
  //  ImageIEN := magpiece(Value, '|', 2);
  NetworkFilename := Value;                            {brkpt 1}
  if Action = 'ImageStart' then
  begin
    for i := 0 to maglistview1.Items.count - 1 do
    begin
      Iobj :=
        TMagListViewData(TListItem(MagListView1.Items.Item[i]).Data).Iobj;
      //if (iobj.Mag0 = ImageIEN) and (iobj.PlaceIEN = PlaceIEN) then
      if iobj.FFile = NetworkFilename then
      begin
        MagListView1.Items.Item[i].StateIndex := mistateCaching; //93
        self.MagTreeView1.ImageStateChange(IObj, mistateCaching);
        exit;
      end;
    end;
  end
  else if Action = 'ImageComplete' then
  begin
    for i := 0 to maglistview1.Items.count - 1 do
    begin
      Iobj :=
        TMagListViewData(TListItem(MagListView1.Items.Item[i]).Data).Iobj;
      //if (iobj.Mag0 = ImageIEN) and (iobj.PlaceIEN = PlaceIEN) then
      if iobj.FFile = NetworkFilename then
      begin
        MagListView1.Items.Item[i].StateIndex := mistatecached; //93
        self.MagTreeView1.ImageStateChange(IObj, mistateCached);
        exit;
      end;
    end;
  end;

end;

(*procedure TfrmImageList.CursorChange(var oldcurs : TCursor; newcurs : Tcursor);
begin
oldcurs := screen.cursor;
if screen.Cursor <> newcurs then screen.Cursor := newcurs;
end;
*)
(*procedure TfrmImageList.CursorRestore(oldcurs : TCursor);
begin
if screen.Cursor <> oldcurs then screen.Cursor := oldcurs;
end;
*)

procedure TfrmImageList.ViewSelectedItemImage(radcode: integer = 1);
var
  IObj: TImageData;
  xmsg: string;
  retmsg: string;
  ocurs: Tcursor;
begin

  if Fdisplaying then
  begin
    messagebeep(MB_OK);
    exit;
  end;

  if MagListView1.Selected = nil then
    exit;
  Iobj := TMagListViewData(TListItem(MagListView1.Selected).Data).Iobj;
  if (Iobj = nil) then
  begin
    xmsg := 'Data for selected Image is null';
    winmsg(mmsglistwin, 'Data for selected Image is null');
    exit;
  end;
  xmsg := Iobj.ExpandedDescription();
  Fdisplaying := true;
  update;
  try
    //?? lvImageList.enabled := false; lvImageList.update;
    tlbrImageListMain.enabled := false;
    tlbrImageListMain.update;

    LogActions('IMAGE-LIST', 'IMAGE', 'DFN-' + Fdfn);

    CursorChange(ocurs, crHourGlass); //        Screen.cursor := crHourGlass;
    if pnlfullres.Visible then
      retmsg := OpenSelectedImage(Iobj, RadCode, 0, 1, 0, false, false,
        self.ListWinFullViewer)
    else
      retmsg := OpenSelectedImage(Iobj, radcode, 0, 1, 0);
    if magpiece(retmsg, '^', 1) = '0' then
      xmsg := Iobj.ExpandedDescription(false) + ' ' +
        magpiece(retmsg, '^', 2);
  finally
    //??lvImageList.enabled := true; lvImageList.update;
    cursorRestore(ocurs); // Screen.cursor := crDefault;
    tlbrImageListMain.enabled := true;
    Fdisplaying := false;
    winmsg(mmsglistwin, xmsg);
    if FMaintainfocus then
      MagListView1.setfocus;
  end;
end;

procedure TfrmImageList.ViewSelectedItemReport(preview: boolean = false; li:
  Tlistitem = nil);
var
  Iobj: TImageData;
  rstat: boolean;
  rmsg: string;
begin
  if li = nil then
    li := MagListView1.Selected;
  if li = nil then
    exit;
  Iobj := TMagListViewData(li.Data).Iobj;
  if (Iobj = nil) then
    exit;
  LogActions('IMAGE-LIST', 'REPORT', 'DFN-' + Fdfn);
  if ImageDeletedThisSession(Iobj, false) then
  begin
    messagebeep(0);
    winmsg(mmsglistwin, 'Image has been deleted this session :   ' +
      Iobj.ExpandedDescription);
    if preview then
    begin
      memreport.Lines.Add('Image :   ' + Iobj.ExpandedIDDescription);
      memreport.Lines.Add('Has been Deleted this session.');
    end
    else
      //LogMsg('s', 'Image : ' + Iobj.ExpandedDescription + #13 +
      //    'Has beed Deleted this session.');
      MagLogger.LogMsg('s', 'Image : ' + Iobj.ExpandedDescription + #13 +
        'Has beed Deleted this session.'); {JK 10/6/2009 - Maggmsgu refactoring}
    //maggmsgf.MagMsg('s','Image : '+ Iobj.ExpandedDescription + #13 + 'Has beed Deleted this session.',nil);
    exit;
  end;
  if preview then //buildreport(Iobj.Mag0, '', 'Image Report', memReport)
    dmod.MagUtilsDB1.ImageReport(IObj, rstat, rmsg, memReport)
  else //buildreport(Iobj.Mag0, '', 'Image Report');
    dmod.MagUtilsDB1.ImageReport(IObj, rstat, rmsg);
  if FMaintainfocus then
    frmImageList.setfocus;
end;

procedure TfrmImageList.FormDestroy(Sender: TObject);
begin
  Screen.OnActiveControlChange := nil;
  SaveFormPosition(Self as Tform);
  RIVDetachListener(self);
  //FcurrentFilter.Free;  This is pointer to Magimagelist.filter.  We kill it there.
end;

procedure TfrmImageList.FitColumnsToText;
begin
  MagListView1.FitColumnsToText;
end;

procedure TfrmImageList.mmuImageReport2Click(Sender: TObject);
begin
  ViewSelectedItemReport;
end;

procedure TfrmImageList.mnuOpenImage2Click(Sender: TObject);
begin
  //ViewSelectedItemImage;
  CurrentImageOpen();
end;

procedure TfrmImageList.mnuImageInfoAdv2Click(Sender: TObject);
begin
  ShowSelectedImageInfoSys;
end;

procedure TfrmImageList.ShowSelectedImageInfoSys;
var
  Iobj: TImageData;
  LI: Tlistitem;
begin
  {TODO: Have to modify to allow multiple selected to go to Image Info
  window.}
  { - needs a Tmag4Viewer to show abs of all selected items}
  { - What do we do with Report preview when multiple items are selected}
//li := MagListView1.Selected ;
  if (MagListView1.Selected = nil) then
    exit;
  Iobj := TMagListViewData(MagListView1.Selected.Data).Iobj;
  if (Iobj <> nil) then
    //frmMain.ShowimageinfoSys(IObj);
    OpenImageInfoSys(IObj);

end;

procedure TfrmImageList.XlvImageListKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (key = VK_Return) then
  begin
    //ViewSelectedItemImage;
    CurrentImageOpen();
  end;

end;

procedure TfrmImageList.FormResize(Sender: TObject);
begin
  ReDisplayMultiLine; //
  FixFullResPosition;
end;

procedure TfrmImageList.setFilterOptions(tabs, multiline: boolean);
begin
  mnuFiltersAsTabs1.checked := tabs;
  pnlFilterTabs.visible := tabs;
  SetMultiLineTabs(multiline);
  ReDisplayMultiLine;
end;

procedure TfrmImageList.mnuImageDelete2Click(Sender: TObject);
begin
  DeleteSelectedImage;
end;

procedure TfrmImageList.mnuFitColToText2Click(Sender: TObject);
begin
  MagListView1.FitColumnsToText;
end;

procedure TfrmImageList.SelectColumns2Click(Sender: TObject);
begin
  MagListView1.SelectColumns;
end;

(*function TfrmImageList.GetImageObject(Li: Tlistitem): TImageData;
begin
  result := TMagListViewData(li.data).IObj;
end;
  *)

procedure TfrmImageList.SetAbsPreview(stat: boolean);
begin
  FAbsPrev := stat;
  slppnlAbsPreview.visible := FAbsPrev;
  pnlAbsPreview.Visible := FAbsPrev;
  if not tbtnPrevAbs.Down = FAbsPrev then
    tbtnPrevAbs.Down := FAbsPrev;

  if FAbsPrev then
  begin
    slppnlAbsPreview.left := pnlAbsPreview.left + 5;
    if pnlAbsPreview.Width < 100 then
      pnlAbsPreview.Width := 100;
    if magListView1.Selected <> nil then
      PreviewAbs(maglistview1.selected);
  end
  else
    Mag4VGear1.ClearImage;
end;

procedure TfrmImageList.SetRptPreview(stat: boolean);
begin

  FPreviewReportIList := stat;
  //memreport.align := alnone;
  //if (memreport.top > (height - 100))
  if not (tbtnPrevReport.Down = FPreviewReportIList) then
    tbtnPrevReport.Down := FPreviewReportIList;
  if stat then
  begin
    frmImagelist.constraints.MinHeight := 400;
    memreport.align := alnone;
    memReport.top := self.pnlMagListView1.Top +
      trunc(self.pnlMagListView1.Height div 2);
    memReport.height := trunc(self.pnlMagListView1.Height div 2);
    memreport.visible := true;
    memreport.Enabled := true;
    memreport.align := albottom;
    splmemreport.top := memreport.top - 10;
    splmemreport.visible := true;
    update;
    if maglistview1.selected <> nil then
    begin
      PreviewRpt(maglistview1.selected);
      //scrolltoitem(maglistview1.Selected.Index);
    end;
  end
  else
  begin
    frmImagelist.constraints.MinHeight := 200;
    memreport.visible := false;
    memreport.Enabled := false;
    splmemreport.visible := false;
    memreport.Clear;
  end;

end;

procedure TfrmImageList.PreviewRpt(item: Tlistitem);
begin
  memReport.Clear;
  if FPreviewReportIList then
    ViewSelectedItemReport(true, item);
end;



procedure TfrmImageList.PreviewAbs(LI: TListitem);
var
  Iobj: TImageData;
  t: tstrings;
  xmsg, msghint, onefile: string;
  CacheFile: string;
  lvtopidx, i, scrollct: integer;
  lit: Tlistitem;
begin
  Mag4VGear1.ClearImage;
  if not FAbsPrev then
    exit;

  scrollct := 0;
  msghint := '';
  Iobj := TMagListViewData(li.Data).Iobj;
  if (Iobj = nil) then
    exit;
  winmsg(mmsglistwin, Iobj.ExpandedDescription);

  Mag4VGear1.ImageDescription := Iobj.ExpandedDescription(false);
  Mag4VGear1.ImageDescriptionHint(Iobj.ExpandedIdDateDescription());

  t := tstringlist.create;
  try
    dmod.MagDBBroker1.RPMag4GetImageInfo(Iobj, t, FCurrentFilter.ShowDeletedImageInfo); {/ P117 - JK 9/20/2010 - Added 3rd parameter /}
    lvimageinfo.Items.BeginUpdate;

    ClearImageInfoControl;
    for i := 0 to t.Count - 1 do
    begin
      lit := lvImageInfo.Items.Add;
      lit.Caption := magpiece(t[i], ':', 1) + ':';
      lit.SubItems.Add(trim(magpiece(t[i], ':', 2) + ':' + magpiece(t[i],
        ':', 3)));
    end;
    lvimageinfo.Items.EndUpdate;
    ReSetTopIndex;
  finally
    t.free;
  end;
  {  JMW     getImageGuaranteed always returns an Image, (canned bitmap)
            and it will work for ViX Images}
  onefile := MagImageManager1.getImageGuaranteed(iobj, MagImageTypeAbs,
    false).FDestinationFilename;
  Mag4VGear1.LoadTheImage(onefile); // was Iobj.Afile
  Mag4VGear1.ImageHint(msghint);
  {     JMW 7/30/08 p72 - not necessary. Image Network share access is
           handled in the image manager }
    //   MagImageManager1.SafeCloseNetworkConnections(); // JMW 6/17/2005 p45t3 safely close network connections
    //   old way =>   dmod.MagFileSecurity.MagCloseSecurity(xmsg);
  winmsg(mmsglistwin, Iobj.ExpandedDescription);
end;

procedure TfrmImageList.MagListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  newsobj: TMagNewsObject;
  vIobj: TimageData;
  ocurs: tcursor;
begin
  if application.terminated then
    exit;
  if not selected then
    exit;

  try
    screen.Cursor := crdefault;
    CursorChange(ocurs, crHourGlass);
    application.processmessages;
    PreviewAbs(item);
    PreviewRpt(item);
    if FSyncImageON then {FSyncImageOn from  MagListView1 SelectItem}
    begin
      vIobj := TMagListViewData(TListItem(MagListView1.Selected).Data).Iobj;
      if vIobj <> nil then
      begin
{$IFDEF testmessages}
        winmsg(umagdefinitions.mmsglistwin, 'Fimagelistsyncprocessing: ' + magbooltostr(Fimagelistsyncprocessing));
{$ENDIF}
        if not FImageListSyncProcessing then
        begin
          //NewsSubscribe Does this- SetCurSelectedImageObj(vIobj);        {MagListView1SelectItem}
          NewsObj := MakeNewsObject(mpubImageSelected, 0, vIobj.Mag0, vIobj, MagListView1);
          self.MagPublisher1.I_SetNews(newsobj); //MagListView1SelectItem
        end;
      end;

    end;
    if doesformexist('frmMagImageInfo') then
    begin
      ShowSelectedImageinfo;
      if FMaintainfocus then
        MagListView1.setfocus;
    end;
  finally
    cursorRestore(ocurs); //         screen.Cursor := crdefault;
  end;
end;

procedure TfrmImageList.MagListView1DblClick(Sender: TObject);
begin
  //ViewSelectedItemImage;
  CurrentImageOpen();
end;

procedure TfrmImageList.MagListView1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if key = VK_return then
  begin
    //ViewSelectedItemImage;
    CurrentImageOpen();
  end;
end;

procedure TfrmImageList.MagListView1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
if pnlROIoptions.Visible then   CountCheckedImagesToPrint ;
end;

procedure TfrmImageList.tbtnImageClick(Sender: TObject);
begin
  ViewSelectedItemImage;
end;

procedure TfrmImageList.tbtnReportClick(Sender: TObject);
begin
  ViewSelectedItemReport;
end;

procedure TfrmImageList.tbtnFitColClick(Sender: TObject);
begin
  FitColumnsToText;
end;

procedure TfrmImageList.StretchWindow;
begin
end;

procedure TfrmImageList.tbtnPrevAbsClick(Sender: TObject);
begin
  SetAbsPreview(tbtnPrevAbs.Down);
end;

procedure TfrmImageList.tbtnPrevReportClick(Sender: TObject);
begin
  SetRptPreview(tbtnPrevReport.down);
end;

procedure TfrmImageList.tbtnUserPrefClick(Sender: TObject);
begin
  OpenUserPrefs;
end;

(*procedure TfrmImageList.AddImageToViewer;
var li: Tlistitem;
  Iobj: TImageData;
  tl: Tlist;
begin
  tl := Tlist.create;
  try
    li := MagListView1.Selected;
    if li = nil then exit;
    Iobj := GetImageObject(li);
    tl.Add(Iobj);
    // frmViewerWindow.Mag4Viewer1.ImagesToMagView(tl);
    // frmViewerWindow.Mag4Viewer2.ImagesToMagView(tl);
  finally
    tl.free;
  end;
end;   *)

procedure TfrmImageList.tbtnFilterClick(Sender: TObject);
begin
  GetFilter;
end;

procedure TfrmImageList.GetFilter;
var
  vfilter, oldfilter: TImageFilter;

begin
  oldFilter := FCurrentFilter;
  vfilter := frmListFilter.Execute(magImageList1.ImageFilter, duz);
  if vFilter = nil then
    exit; // new 93
  RefreshAllFilters;
  tabctrlFilters.TabIndex := -1;
  if (vfilter = nil) and (oldfilter <> nil) then
  begin
    tabctrlFilters.TabIndex := tabctrlFilters.Tabs.IndexOf(oldFilter.Name);
    if tabctrlFilters.TabIndex = -1 then
      tabctrlFilters.TabIndex := tabctrlFilters.Tabs.IndexOf('#' +
        oldFilter.Name)
  end;
  if vfilter <> nil then
    SetCurrentFilter(vfilter); // HERE, bug
  //   vfilter has '' name and ID from the frmListFilter window.
  //  and SetCurrentFilter stops when this is true.  So no list is upatged.
  if (dmod.MagPat1.M_DFN <> '') and (vFilter <> nil) then
  begin
    UpdateFilteredList;
  end;
  //RefreshAllFilters;
end;

procedure TfrmImageList.UpdateFilteredList;
begin
  {   TImageList gets an Update Call from MagPat when patient changes, or
      from here, when a filter changes.
      TImageList then calls notify which calls update on the ImageList window.}
  ClearImageControls;
  pnlFilterDesc.Caption := ' Searching...';
  magImageList1.Update_('1', self);
end;

procedure TfrmImageList.ClearPreviews;
begin
  memReport.Lines.Clear;
  Mag4VGear1.ClearImage;
  // out in 93t8 gek
  //   Mag4VGear1.LoadTheImage(apppath + '\bmp\blank2.bmp');
end;

procedure TfrmImageList.Update_(SubjectState: string; sender: TObject);
var
  i: integer;
  Iobj: Timagedata;
  vCCOWState: byte;
begin
{debug94 } MagLogger.LogMsg('s','**--**-- -- -- TfrmImageList.Update_  state ' + subjectstate);
  if (sender = dmod.CCOWManager) then
  begin
    vCCOWState := byte(StrToInt(SubjectState));

    imgCCOWLink1.Visible := vCCOWState = 1;
    imgCCOWchanging1.Visible := vCCOWState = 2;
    imgCCOWbroken1.Visible := vCCOWState = 3;

    mnulistContext.Visible := vCCOWState > 0;
    mnuShowContext1.Enabled := vCCOWState = 1;
    mnuSuspendContext1.Enabled := vCCOWState = 1;
    mnuResumeGetContext1.Enabled := vCCOWState = 3;
    mnuResumeSetContext1.Enabled := vCCOWState = 3;
    exit;
  end;
  { TODO : Get this code out of the form. }
  { The form (FOR now) is an observer of the TImageFltrList, the form (for now)
     will update the abstracts, maglistview, and full viewer, ( for now)}
  //oot 6/17/02  MagListView1.LoadListFromStrings(frmViewerWindow.magImageList1.Baselist);
  if (SubjectState = '-1') then
    exit;
  if (SubjectState = '') then
  begin
    ClearImageControls; //MagListView1.ClearItems;
    // Group window TmagImageList component isn't attached to MagPat1
    //  we have to clear him by hand.
    if DoesFormExist('frmGroupAbs') then
    begin
      // group window has TMagImageList which drives the MagViewer on the form.
      //  groupwindow.magImageList1.Update_(SubjectState);
      frmGroupAbs.ClearAll; // ClearAll, also clears the magImageList1.
    end;
    ImageCountDisplay;
    frmmain.mainImageCountDisplay;
    exit;
  end;
  if copy(SubjectState, 1, 1) = '0' then
  begin
    pnlFilterDesc.Caption := '0 Images. ' + magImageList1.ListName;
    winmsg(0, inttostr(magimagelist1.Objlist.Count));
    winmsg(mmsglistwin, magImageList1.ListDesc); //magImageList1. ListDesc;
    ImageCountDisplay;
    frmmain.mainImageCountDisplay;
    exit;
  end;
  { update MagListView1 with the new image list}
  MagListView1.LoadListFromMagImageList(magImageList1.BaseList,
    magimagelist1.Objlist); //Update_

  pnlFilterDesc.Caption := magImageList1.ListName;
  winmsg(0, inttostr(magimagelist1.Objlist.Count));
  winmsg(mmsglistwin, magImageList1.ListDesc); //magImageList1. ListDesc;
  ImageCountDisplay;
  frmmain.mainImageCountDisplay;
  //93t12 testing - take out next line
  // SelectFirstListImage;
  for i := 0 to MagListView1.items.count - 1 do
  begin
    Iobj :=
      TMagListViewData(TListItem(MagListView1.Items.Item[i]).Data).Iobj;
    if Iobj.QAMsg <> '' then
      MagListView1.Items[i].ImageIndex := mistQI; //93
  end;
  if self.pnlAbs.Visible then
  begin
    // ListWinAbsViewer has it's own Update_ call.
  end;
  if self.pnlTree.Visible then
  begin
    MagTreeView1.LoadListFromMagImageList(magimagelist1);
    RefreshLocalTree;
  end;
end;

procedure TfrmImageList.winmsg(stbarPanel: integer; s: string);
begin
  if (maglength(s, '^') > 1) then
    s := magpiece(s, '^', 1);
  if uppercase(s) = 'OKAY' then
    s := '';
  stbarImagelist.Panels[stbarpanel].Text := s;
  stbarImagelist.update;
end;

procedure TfrmImageList.WinMsgClear();
var
  i: integer;
begin
  for i := 0 to stbarimagelist.panels.Count - 1 do
    stbarImagelist.Panels[i].Text := '';
  stbarImagelist.update;
end;

procedure TfrmImageList.SelectFirstListImage;
begin
  if (MagListView1.Items.Count > 0) then
    MagListView1.Items[0].Selected := true;
end;


procedure TfrmImageList.SetDefaultHeight(ht: integer);
begin
  FdftHeight := ht;
end;

procedure TfrmImageList.mnuFitColToWin2Click(Sender: TObject);
begin
  maglistview1.FitColumnsToForm;
end;

procedure TfrmImageList.tbtnFitColWinClick(Sender: TObject);
begin
  maglistview1.FitColumnsToForm;
end;

procedure TfrmImageList.mnuImageInformation2Click(Sender: TObject);
//var//LI: Tlistitem;
 // IObj: TImageData;
begin
  ShowSelectedImageinfo;
end;

procedure TfrmImageList.ShowSelectedImageinfo;
//var//LI: Tlistitem;
 // IObj: TImageData;
begin
  //  li := MagListView1.Selected;
  //  if li = nil then exit;
  //  Iobj := TMagListViewData(li.Data).Iobj;
  //  if (Iobj = nil) then exit;
  if (MagListView1.Selected <> nil) and
    (TMagListViewData(MagListView1.Selected.Data).Iobj <> nil) then
    ShowImageInformation(TMagListViewData(MagListView1.Selected.Data).Iobj);

end;

procedure TfrmImageList.mnuFontClick(Sender: TObject);
begin
  fontdialog1.Font := memreport.Font;
  if fontdialog1.Execute then
    memreport.font := fontdialog1.Font;
end;

procedure TfrmImageList.mnuExit1Click(Sender: TObject);
begin
  close;
  application.processmessages;
  frmMain.Close;
  //  Terminating here, and the Close functions of frmMain aren't run.
  //   i.e.  SaveUserSettingapplication.Terminate;
end;

procedure TfrmImageList.mnuImageReport1Click(Sender: TObject);
begin
  CurrentImageReport;
end;

procedure TfrmImageList.mnuOpenImage1Click(Sender: TObject);
begin
  //ViewSelectedItemImage;
  CurrentImageOpen();
end;

procedure TfrmImageList.mnuBrowseImageListClick(Sender: TObject);
begin
  FMaintainfocus := mnuBrowseImageList.checked;
end;

procedure TfrmImageList.mnuOptionsClick(Sender: TObject);
begin

  {//93out for now this is always hidden, and FSyncImageOn is always True.}
  //93out   mnuSyncSelectedImage.Checked := FSyncImageON;
  mnuBrowseImageList.checked := FMaintainfocus;
  // mnuShowHints1.checked := frmImageList.ShowHint;
  mnuStayonTop1.checked := (frmImageList.formstyle = fsStayOnTop);
end;

procedure TfrmImageList.menuMagListViewPopup(Sender: TObject);
var iobj : TImageData;
wasimageclicked, isdel : boolean;    {isdel : CodeCR710}
begin
{  gek p117 testing 11-1-2010
Iobj := self.MagListView1.GetSelectedImageObj;
if Iobj = nil then exit;   // shouldn't happen.....
if Iobj.IsImageDeleted then
   begin
    //
   end;
                             }


  mnuImageInfoAdv2.visible := (UserHasKey('MAG SYSTEM'));
  {     Delete is disabled if single and no MAG DELETE key. or if group and not MAG DELETE }
  mnuImageDelete2.visible := (UserHasKey('MAG DELETE'));
  mnuIndexEdit2.Visible := (UserHasKey('MAG EDIT') or UserHasKey('MAG SYSTEM'));

  // moved below, we need isDel to determine visibility
  //mnuOpenImagein2ndRadiologyWindow2.visible := IsListItemSingleRadImage();

  Iobj := maglistview1.GetSelectedImageObj;    //(popupAbstracts.PopupComponent is TMag4Vgear);
  wasimageclicked := (Iobj <> nil);
  if wasimageclicked then
    begin
    isdel := Iobj.IsImageDeleted;
    if not isdel then isdel := imagedeletedthissession(iobj,false);
    end;


   mnuOpenImage2.Enabled := wasimageclicked and (not isdel);
   mmuImageReport2.Enabled := wasimageclicked and (not isdel);
   mnuImageDelete2.Enabled := wasimageclicked and (not isdel);
   mnuIndexEdit2.Enabled := wasimageclicked and (not isdel);
   mnuCacheGroup2.Enabled := wasimageclicked and (not isdel);


  mnuImageDelete2.caption := 'Image Delete...';
  if Iobj.IsImageGroup then
    mnuImageDelete2.caption := 'Image Group Delete...';

 {/p117 mnuOpenImagein2ndRadiologyWindow2 was visible and enabled for Deleted images. }
  mnuOpenImagein2ndRadiologyWindow2.visible := false;
   if not isdel then
    mnuOpenImagein2ndRadiologyWindow2.visible := IsListItemSingleRadImage();
  // mnuImageDelete2.enabled := (UserHasKey('MAG SYSTEM'));
  // mnuImageSaveAs2.visible := (UserHasKey('MAG EDIT'));
   {TODO: allow opening of Group Image, not just Group Abstract }
   {   >> expanded user preferences <tabs> Group Open options
            Rad Group - Open first Image in viewer.
                      - open Group Abstracts in layout.
                      - Open Group Abstracts in cine style
            Image Group - (not Rad)
                         - open first image in viewer
                         - open first X images in viewer
                         - Open Group Abstracts in layout
                         - Open Group Abstracts in SlideShoe mode}
   {     This stops user from selecting a Group to go to Rad Window with}
   {     Quick change could have
                 menu            Open Group Abstracts
                 menu <new>      Open Group Images       }





end;

function TfrmImageList.IsListItemSingleRadImage(): boolean;
var
  LI: Tlistitem;
  IObj: TImageData;
begin
  result := false;
  if Fdisplaying then
  begin
    messagebeep(MB_OK);
    exit;
  end;
  li := MagListView1.Selected;
  if li = nil then
    exit;
  Iobj := TMagListViewData(li.Data).Iobj;
  if (Iobj = nil) then
    exit;
  result := (not Iobj.IsImageGroup) and Iobj.IsRadImage;
end;



function TfrmImageList.IsGroupImageSelectedInList(): boolean;
var
  LI: Tlistitem;
  IObj: TImageData;
begin
  result := false;
  if Fdisplaying then
  begin
    messagebeep(MB_OK);
    exit;
  end;
  li := MagListView1.Selected;
  if li = nil then
    exit;
  Iobj := TMagListViewData(li.Data).Iobj;
  if (Iobj = nil) then
    exit;
  result := Iobj.IsImageGroup; //(Iobj.ImgType = 11)
end;

procedure TfrmImageList.mnuImageInformation1Click(Sender: TObject);
begin
  if FCurSelectedImageObj <> nil then
    ShowImageInformation(FCurSelectedImageObj);
end;

procedure TfrmImageList.mnuImageInformationAdvanced1Click(Sender: TObject);
begin
  CurrentImageInformationAdvanced;
end;

procedure TfrmImageList.GotoMainWindow1Click(Sender: TObject);
begin
 application.MainForm.SetFocus;
//  frmMain.focustomain;

end;

procedure TfrmImageList.mnuUtilitiesClick(Sender: TObject);
var
  usercanedit: boolean;
  LocalImage: boolean;
  selectedImage: boolean;
  statdesc: string;
  controlled: string;
  rmsg: string;
begin
{$IFDEF TESTMESSAGES}maggmsgf.MagMsg('', 'In mnuUtilitiesClick(...');
{$ENDIF}
  usercanedit := (UserHasKey('MAG EDIT') or UserHasKey('MAG SYSTEM'));
  selectedImage := umagdisplaymgr.FCurSelectedImageObj <> nil;

  if selectedImage then
    localimage := IsThisImageLocaltoDB(FcurSelectedImageObj, dmod.MagDBBroker1, rmsg);
{$IFDEF TESTMESSAGES}
  maggmsgf.MagMsg('', 'usercanedit: ' + magbooltostr(usercanedit));
  maggmsgf.MagMsg('', 'selectedImage: ' + magbooltostr(selectedimage));
  maggmsgf.MagMsg('', 'IsThisImageLocaltoDB: ' + magbooltostr(localimage));
{$ENDIF}

  mnuIndexEdit.enabled := usercanedit and localimage;
  mnuSetImageStatus.Enabled := mnuIndexEdit.Enabled;
  mnuSetControlledImage.Enabled := mnuIndexEdit.Enabled;
{/p117 gek  added QA REVIEW check}
  mnuListQAReview.Enabled := usercanedit or UserHasKey('MAG QA REVIEW');    //P117 QA REVIEW
  mnuListQAReviewReport.Enabled := usercanedit or UserHasKey('MAG QA REVIEW'); //P117  QA REVIEW
  mnuROIPrintOptions.Enabled := (UserHasKey('MAG SYSTEM') or UserHasKey('MAG ROI'))  ;
  if ((FCurSelectedImageObj = nil) or (not localimage)) then
  begin
    mnuSetImageStatus.Caption := 'Image Status () =';
    mnuSetImageStatus.Enabled := false;
    mnuSetImageStatus.ImageIndex := -1;
    mnuSetControlledImage.Caption := '"Controlled Image" () =';
    mnuSetControlledImage.Enabled := false;
    mnuSetControlledImage.ImageIndex := -1;
  end
  else
  begin
    mnuSetImageStatus.ImageIndex := 20 + FcurSelectedImageObj.MagStatus;
    {   1:Viewable;2:QA Reviewed;10:In Progress;11:Needs Review;12:Deleted}

    statdesc := FcurSelectedImageObj.GetStatusDesc;

    mnuSetImageStatus.Caption := 'Image Status (' + statdesc + ')';
    mnuSetImageStatus.Enabled := usercanedit or UserHasKey('MAG QA REVIEW');
    if mnuSetImageStatus.Enabled
          then mnuSetImageStatus.Enabled := (FcurSelectedImageObj.MagStatus <> 12);

    mnuSetControlledImage.Enabled := usercanedit or UserHasKey('MAG QA REVIEW');
    if mnuSetControlledImage.Enabled  then
            mnuSetControlledImage.Enabled := (FcurSelectedImageObj.MagStatus <> 12);
    controlled := MagBooltostr(fcurselectedimageobj.MagSensitive);
    mnuSetControlledImage.Caption := '"Controlled Image" (' + controlled + ')';

    if fcurselectedimageobj.MagSensitive then
      mnusetcontrolledimage.ImageIndex := 20 + umagdefinitions.mistSensitive
    else
      mnusetcontrolledimage.ImageIndex := 21;
  end;
end;

procedure TfrmImageList.mnuStayonTop1Click(Sender: TObject);
begin
  Exit;
  // we are disabling this function in 93.  .... for now.
  (* mnuStayOnTop1.Checked := not mnuStayOnTop1.Checked;
    if mnuStayOnTop1.Checked
      then frmImageList.formstyle := fsStayOnTop
    else frmImageList.formstyle := fsNormal;
    frmImageList.update;*)
end;

procedure TfrmImageList.ImageFilter1Click(Sender: TObject);
begin
  GetFilter;
end;

procedure TfrmImageList.mnuImageDelete1Click(Sender: TObject);
begin
  CurrentImageDelete;
end;

procedure TfrmImageList.DeleteSelectedImage;

var
  LI: Tlistitem;
  IObj: TImageData;
  rmsg: string;
begin
//   IOBJ := MagListView1.GetSelectedImageObj   // TESTING 117
  li := MagListView1.Selected;
  if li = nil then
    exit;
  Iobj := TMagListViewData(li.Data).Iobj;
  if (Iobj = nil) then
    exit;

  // JMW 6/24/2005 p45t3 compare based on server and port (more accurate)
  if not IsThisImageLocaltoDB(iobj, dmod.MagDBBroker1, rmsg) then
    // if (iobj.ServerName <> dmod.MagDBBroker1.GetServer) or (iobj.ServerPort <>
    //     dmod.MagDBBroker1.GetListenerPort) then
  begin
    showmessage('You cannot delete an image from a remote site');
    exit;
  end;

  //LogMsg('s', 'Attempting deletion of ' + Iobj.ffile + '  IEN ' + Iobj.Mag0);
  MagLogger.LogMsg('s', 'Attempting deletion of ' + Iobj.ffile + '  IEN ' + Iobj.Mag0);
    {JK 10/6/2009 - Maggmsgu refactoring}
  //  frmMain.ImageDelete(Iobj);
  if MgrImageDelete(Iobj, rmsg) then
  begin
    LogActions('IMAGELIST', 'DELETE', Iobj.Mag0);
    li.ImageIndex := mistDeleted; //93
    li.SubItems[1] := 'Deleted-' + li.SubItems[1];
    li.SubItems[5] := 'Deleted-' + li.SubItems[5];
  end;
end;

procedure TfrmImageList.mnuFileClick(Sender: TObject);
var isdel : boolean;    {CodeCR710}
    {This tells us that the selected Image Object (FCurSelectedImageObj)  is open in the
    ListWinFullViewer or not.}
    IsOpen : boolean;
begin
    {/p117 gek 3-21-11}
  try
  if (listwinfullviewer.GetCurrentImageObject = nil)
            or (FCurSelectedImageobj = nil)
            or (not self.pnlfullres.Visible)
   then IsOpen := false
   else isOpen := (FCurSelectedImageobj.Mag0 = listWinFullViewer.GetCurrentImageObject.Mag0);
  except
  // continue
  isOpen := false;
  end;
  winmsg(2,'Selected Image Open : ' + magbooltostr(isOpen));

  mnuImageDelete1.visible := (UserHasKey('MAG DELETE'));
  mnuImageIndexEdit1.Visible := (UserHasKey('MAG SYSTEM') or UserHasKey('MAG EDIT'));
  mnuImageInformationAdvanced1.Visible := UserHasKey('MAG SYSTEM');

  if FCurSelectedImageObj = nil then         {nothing is selected. disable image functions.}
  begin

    mnuOpenImage1.Enabled := false;
    mnuOpenImagein2ndRadiologyWindow1.Visible := false;
    mnuImageReport1.Enabled := false;
    mnuImageDelete1.Enabled := false;
    mnuImageIndexEdit1.Enabled := false;
    mnuImageInformation1.Enabled := false;
    mnuImageInformationAdvanced1.Enabled := false;
    mnuCacheGroup1.Enabled := false;
    mnuFileImageCopy.Enabled := false;
    mnuFileImagePrint.Enabled := false;
  end
  else
  begin
    {}

    {}
    isdel := FcurSelectedImageObj.IsImageDeleted;
    if not isdel then isdel := imagedeletedthissession(FcurSelectedImageObj,false);

    {gek 3-21-11 base the Copy and Print on if Image is not Deleted
      and Is Open in this ImageList window.  }
    mnuFileImageCopy.Enabled := (not isdel) and isOpen ; //pnlfullres.Visible;
    mnuFileImagePrint.Enabled := (not isdel) and isOpen ; //pnlfullres.Visible;

    {/ P117 NCAT - JK 1/20/2011 /}{gek 3-21-11 need to also check if it's open}
    if FCurSelectedImageObj.ImgType = 501 then
    begin
     if mnuFileImageCopy.Enabled then  mnuFileImageCopy.Enabled  := UserHasKey('MAG REVIEW NCAT');
     if mnuFileImagePrint.Enabled then mnuFileImagePrint.Enabled := UserHasKey('MAG REVIEW NCAT');
    end;
    {/p117 gek 3-21-11 added check for isDel}
    if FCurSelectedImageObj.IsRadImage
        and not (FCurSelectedImageObj.IsImageGroup)
        and not isdel
        then  mnuOpenImagein2ndRadiologyWindow1.visible := true
        else mnuOpenImagein2ndRadiologyWindow1.visible := false;
    //mnuOpenImagein2ndRadiologyWindow1.visible := IsListItemSingleRadImage();

    EnableKeyDependentClasses((UserHasKey('MAGDISP CLIN')),(UserHasKey('MAGDISP ADMIN')));
    //  mnuImageSaveAs1.visible := (UserHasKey('MAG EDIT'));
    mnuOpenImage1.Enabled := not isdel;
    mnuImageReport1.Enabled := not isdel;
    if mnuImageDelete1.visible then mnuImageDelete1.enabled := not isdel;
    if mnuImageIndexEdit1.visible then mnuImageIndexEdit1.Enabled := not isdel;
    mnuImageInformation1.Enabled := true;
    if mnuImageInformationAdvanced1.visible then mnuImageInformationAdvanced1.Enabled := true;
    mnuCacheGroup1.Enabled := not isdel;

    if mnuImageDelete1.Visible then
      begin
      mnuImageDelete1.caption := 'Image Delete...';
      if FCurSelectedImageObj.IsImageGroup() then
        mnuImageDelete1.caption := 'Image Group Delete...';
      end;
    end;





end;

procedure TfrmImageList.ImageListingwindow1Click(Sender: TObject);
begin
  Application.helpcontext(helpcontext);
end;

procedure TfrmImageList.mnuOpenImagein2ndRadiologyWindow1Click(Sender: TObject);
begin
  //ViewSelectedItemImage(2);
  CurrentImageOpen(2);
end;

function TfrmImageList.GetAbsPreview: boolean;
begin
  result := FAbsPrev;
end;

function TfrmImageList.GetRptPreview: boolean;
begin
  result := FPreviewReportIList;
end;

procedure TfrmImageList.EnableKeyDependentClasses(hasClinKey, hasAdminKey:
  boolean);
begin
  //?
end;

procedure TfrmImageList.ShowFilters(fltList: Tstrings; duz: string);
var
  i: integer;
begin
  if duz = '' then
    MagMenuPublic.ClearAll
  else
  begin
    MagmenuPrivate.ClearAll;
    tabctrlFilters.tabs.Clear;
  end;
  for i := 0 to fltlist.count - 1 do
  begin
    if duz = '' then
      MagmenuPublic.AddItem(magpiece(fltlist[i], '^', 2),
        magpiece(fltlist[i], '^', 1), magpiece(fltlist[i], '^', 2))
    else
    begin
      magmenuPrivate.AddItem(magpiece(fltlist[i], '^', 2),
        magpiece(fltlist[i], '^', 1), magpiece(fltlist[i], '^', 2));
      tabctrlFilters.Tabs.Insert(0, magpiece(fltlist[i], '^', 2));
    end;
  end;
end;

procedure TfrmImageList.ShowAllFilters(fltList: Tstrings; duz: string);
var
  i: integer;
  tabname, tduz: string;
begin
  MagMenuPublic.ClearAll;
  MagmenuPrivate.ClearAll;
  tabctrlFilters.tabs.Clear;

  for i := 0 to fltlist.count - 1 do
  begin
    tduz := magpiece(fltlist[i], '^', 3);
    if tduz = '' then
      MagmenuPublic.AddItem(magpiece(fltlist[i], '^', 2),
        magpiece(fltlist[i], '^', 1), magpiece(fltlist[i], '^', 2))
    else
      MagmenuPrivate.AddItem(magpiece(fltlist[i], '^', 2),
        magpiece(fltlist[i], '^', 1), magpiece(fltlist[i], '^', 2));
    if tduz = '' then
      tabname := '#' + magpiece(fltlist[i], '^', 2)
    else
      tabname := magpiece(fltlist[i], '^', 2);
    tabctrlFilters.Tabs.Insert(0, tabname);
  end;
  tabctrlFilters.tabindex := -1;
end;

procedure TfrmImageList.SetDefaultImageFilter(fltien: string);
var
  rstat: boolean;
  rmsg: string;
  fltdetails: string;
begin
  if (fltien <> '') then
    dmod.MagDBBroker1.RPFilterDetailsGet(rstat, rmsg, fltdetails, fltien);
  if (not rstat) or (fltien = '') then
  begin
    // the Default Filter (fltien) returned zilch or There wasn't a Default Filter.
    rstat := true;
    if userhaskey('MAGDISP CLIN') then
      fltdetails := CreateClinFilter
    else if userhaskey('MAGDISP ADMIN') then
      fltdetails := CreateAdminFilter
    else
      rstat := false;

  end;
  SetCurrentFilter(fltdetails);
end;

function TfrmImageList.CreateAdminFilter: string;
begin
  {TODO: search list of ADMIN filters, take first ADMIN filter}
  result := '0^Default filter: Admin 1 yr^^ADMIN^^^^^^-12^';

end;

function TfrmImageList.CreateClinFilter: string;
begin
  {TODO: search list of CLIN filters, take first CLIN filter}
  result := '0^Default filter: Clinical 1 yr^^CLIN^^^^^^-12^';
  ;
end;

procedure TfrmImageList.SetCurrentFilter(fltstring: string);
var
  filter: TImageFilter;
begin
  filter := StringToFilter(fltstring);
  frmMain.WinMsg('', 'Current Image Filter: " ' + filter.Name + ' "');
  if (filter.filterID <> '0') then
    if (filter.filterID = '') or (FCurrentFilter.FilterID = Filter.FilterID) then
      exit; //No Change so exit;
  FcurrentFilter := Filter;

  {/ P117 - JK 9/30/2010 - Reapply the ShowDeletedImagePlaceholder menu selection to the new FCurrentFilter/}
  FCurrentFilter.ShowDeletedImageInfo := upref.UseDelImagePlaceHolder;

  MagImageList1.ImageFilter := FcurrentFilter;

  tabctrlFilters.TabIndex := tabctrlFilters.Tabs.IndexOf(FcurrentFilter.Name);
  if tabctrlFilters.TabIndex = -1 then
    tabctrlFilters.TabIndex := tabctrlFilters.Tabs.IndexOf('#' +
      FcurrentFilter.Name)
end;

procedure TfrmImageList.SetCurrentFilter(filter: TImageFilter);
begin
  frmMain.WinMsg('', 'Current Image Filter: " ' + filter.Name + ' "');
  if (filter.filterID = '') then
    exit;
  FcurrentFilter := Filter;

  {/ P117 - JK 10/2/2010 - Reapply the ShowDeletedImagePlaceholder menu selection to the new FCurrentFilter/}
  FCurrentFilter.ShowDeletedImageInfo := upref.UseDelImagePlaceHolder;

  MagImageList1.ImageFilter := filter;

  tabctrlFilters.TabIndex := tabctrlFilters.Tabs.IndexOf(Filter.Name);
  if tabctrlFilters.TabIndex = -1 then
    tabctrlFilters.TabIndex := tabctrlFilters.Tabs.IndexOf('#' + Filter.Name)
end;

procedure TfrmImageList.ClearCurrentFilter;
begin
  FcurrentFilter := nil;
  pnlFilterDesc.caption := '';
end;

procedure TfrmImageList.MagMenuFilterClick(sender: TObject);
var
  fltien: string;
  rmsg: string;
  rstat: boolean;
  fltdetails: string;
  filter: TImageFilter;
begin //here 5/29/09     click a filter from the menu
  fltien := ((Sender as TMagMenuItem).id);
  dmod.MagDBBroker1.RPFilterDetailsGet(rstat, rmsg, fltdetails, fltien);
  if not rstat then
    exit;
  SetCurrentFilter(fltdetails);
  if (dmod.MagPat1.M_DFN <> '') then
  begin
    UpdateFilteredList;
  end;
end;

procedure TfrmImageList.mnuRefreshFilterlistClick(Sender: TObject);
begin
  RefreshAllFilters;
end;

procedure TfrmImageList.RefreshAllFilters;
begin
  //GetPublicFilters;
  //GetPrivateFilters(duz);
  GetAllFilters(duz);
end;

procedure TfrmImageList.ClearAllFilters;
begin
  MagMenuPublic.ClearAll;
  MagMenuPrivate.ClearAll;
  tabctrlFilters.Tabs.Clear;

end;

procedure TfrmImageList.tabctrlFiltersChange(Sender: TObject);
var
  fltname: string;
  fltien: string;
  rmsg: string;
  rstat: boolean;
  fltdetails: string;
  filter: TImageFilter;
  fDuz: string;
begin
  fDuz := duz;
  // here comes the code.
  //fltien := (COPY((Sender as TMenuItem).name, 2, 99));
  fltname := tabctrlFilters.Tabs[tabctrlFilters.tabindex];
  if (pos('#', fltname) = 1) then
  begin
    fDuz := '';
    fltname := copy(fltname, 2, 999);
  end;
  dmod.MagDBBroker1.RPFilterDetailsGet(rstat, rmsg, fltdetails, '', fltname,
    fduz);
  if not rstat then
  begin
    //      maggmsgf.magmsg('d', rmsg + #13 + #13 +
    //LogMsg('d', rmsg + #13 + #13 +
    //    'Refresh the Filter List and if the Problem' + #13 +
    //    'persists, contact Imaging Coordinator');
    MagLogger.LogMsg('d', rmsg + #13 + #13 +
      'Refresh the Filter List and if the Problem' + #13 +
      'persists, contact Imaging Coordinator'); {JK 10/6/2009 - Maggmsgu refactoring}
    tabctrlFilters.TabIndex := -1;
    exit;
  end;
  try
    SetCurrentFilter(fltdetails);
    if (dmod.MagPat1.M_DFN <> '') then
    begin
      tabctrlFilters.Enabled := false;
      UpdateFilteredList;
    end;
  finally
    if not tabctrlFilters.Enabled then
      tabctrlFilters.Enabled := true;
  end;
  SetFilterHint;
end;

procedure TfrmImageList.SetFilterHint;
var
  t: Tstrings;
  s: string;
  i: integer;
begin
  if not mnutesting.visible then
    exit;
  s := '';
  t := Tstringlist.create;
  //t := DetailedDesc2(fcurrentFilter);
  t := DetailedDescGen(fcurrentFilter);
  for i := 0 to t.count - 1 do
  begin
    s := s + #13 + t[i]
  end;
  //  could have hint on either
  tabctrlFilters.hint := s;
  pnlFilterDesc.Hint := s;
end;

procedure TfrmImageList.SetMultilineTabs(value: boolean);
begin

  mnuMultiLineTabs1.checked := value;
  tabctrlFilters.multiline := mnuMultiLineTabs1.checked;
  ReDisplayMultiLine;
end;

procedure TfrmImageList.ReDisplayMultiLine;
begin
  if tabctrlFilters.multiline then
    tabctrlFilters.Height := 5 + (tabctrlFilters.RowCount *
      tabctrlFilters.TabHeight)
  else
    tabctrlFilters.Height := 5 + tabctrlFilters.TabHeight;
  self.pnlFilterTabs.Height := tabctrlfilters.Height + 5;
end;

procedure TfrmImageList.mnuMultiLineTabs1Click(Sender: TObject);
begin
  FilterTabsMultiLine(mnuMultiLineTabs1.checked);
end;

procedure TfrmImageList.FilterTabsMultiLine(value: boolean);
begin
  tabctrlFilters.MultiLine := value;
  SetMultiLineTabs(value);
end;

procedure TfrmImageList.mnuSelectPatient1Click(Sender: TObject);
begin
  frmMain.PatientSelect('');
end;

procedure TfrmImageList.Mag4VGear1Click(Sender: TObject);
begin
  // ViewSelectedItemImage;
end;

procedure TfrmImageList.Mag4VGear1ImageClick(sender: TObject;
  Gearclicked: TMag4Vgear);
begin
  //  ViewSelectedItemImage;
end;

procedure TfrmImageList.pnlDockDockDrop(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer);
begin
  pnlAbsPreview.Visible := false;
end;

procedure TfrmImageList.mnuOpenImageIDClick(Sender: TObject);
begin
  OpenImageByID;
end;

procedure TfrmImageList.tbtnHelpMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (ssctrl in shift) and (ssshift in shift) then
  begin
    mnutesting.visible := true;

    mnuTesting.Visible := true;
    with frmmagAbstracts do
    begin

      DragKind := dkDock;
      DragMode := dmautomatic;
    end;
  end;
end;

procedure TfrmImageList.FormActivate(Sender: TObject);
begin
  Screen.OnActiveControlChange := ActiveControlChangedListWin;
  RefreshAbstract;

end;

procedure TfrmImageList.ActiveControlChangedListWin(Sender: TObject);
var
  wc: tWincontrol;

begin
  if screen.ActiveForm <> frmImageList then
    exit;
  if not FUseFocusBar then
    exit;

  wc := screen.ActiveControl;
  //FLastActive
  try
    if wc = nil then
      exit;
    if wc.Name <> '' then
    begin
      winmsg(mmsglistwin, 'Active Control : ' + wc.Name);
      if wc.Name = 'PageScroller1' then
      begin
        //cmbDateRange.SetFocus;
        //winmsg(pfm,' cmbDateRange.SetFocus' ) ;
      end;

      pnlfocus.Align := alnone;
      pnlfocus.Parent := wc.Parent;
      pnlfocus.Width := 5;
      pnlfocus.Top := wc.Top;
      pnlfocus.Left := wc.Left - 5;
      if pnlfocus.Left < 0 then
        pnlfocus.Left := 0;
      pnlfocus.Height := wc.Height;
      if not pnlfocus.Visible then
        pnlfocus.Visible := true;
    end
    else
    begin
      winmsg(mmsglistwin, 'Active Control :  No Name');
    end;

  except
    //
  end;

end;

procedure TfrmImageList.RefreshAbstract;
begin
  Mag4VGear1.RefreshImage;
end;

procedure TfrmImageList.mnuShowFilterDetailsClick(Sender: TObject);
begin
  FilterDetailsInInfoWindow;
end;

procedure TfrmImageList.FilterDetailsInInfoWindow;
var
  t: TStrings;
  s: string;
  i: Integer;
begin
  s := '';
  t := TStringList.Create;
  //t := DetailedDesc2(fcurrentFilter);
  t := DetailedDescGen(fCurrentFilter, True);
  for i := 0 to t.count - 1 do
  begin
    s := s + #13 + t[i]
  end;
  MessageDlg(s, mtInformation, [mbOK], 0);
end;

function TfrmImageList.DetailedDesc2(filter: TImagefilter): Tstrings;
var
  s, stype, sspec, sproc: string;
  ixien: string;
  i, ixp, ixl, ixi: integer;

begin
  // Not yet called by Application.
  result := Tstringlist.create;
  Result.add('                * Filter Details *');
  result.add('');
  result.add('                Name :  ' + filter.Name);
  result.add('******************************');
  //  result.add('');

  s := ClassesToString(filter.Classes);
  if s = '' then
    s := 'Any';
  result.add('Class :        ' + s);
  //  result.add('');

  s := filter.Origin;
  if s = '' then
    s := 'Any';
  if pos(',', s) = 1 then
    s := copy(s, 2, 999);
  result.add('Origin :       ' + s);
  //  result.add('');

    // we have a few if, rather that if then else for a reason
    //  we want to make sure the date properties are getting cleared when
    //  they should.  Only one of the IF's below, should be TRUE.
    //   If not, then we'll see it and know of a problem.
  if ((filter.FromDate <> '') or (filter.ToDate <> '')) then
  begin
    result.add('Dates:        ' + 'from: ' + filter.FromDate + '  thru  ' +
      filter.ToDate);
  end;
  if (filter.MonthRange <> 0) then
  begin
    result.add('Dates:        for the last ' +
      inttostr(abs(filter.MonthRange)) + ' months.');
  end;
  if (filter.MonthRange = 0) and (filter.FromDate = '') and (filter.ToDate =
    '') then
    result.add('Dates:        All Dates.');
  //  result.add('');

  s := PackagesToString(filter.Packages);
  if s = '' then
    s := 'Any';
  result.add('Packages:   ' + s);
  result.add('');

  result.add('Types: ');
  stype := filter.Types;
  s := '';
  if stype = '' then
    s := '        Any'
  else
  begin
    ixl := maglength(stype, ',');
    for ixi := 1 to ixl do
    begin
      ixien := magpiece(stype, ',', ixi);
      if ixien <> '' then
        S := S + '        ' + XwbGetVarValue2('$P($G(^MAG(2005.83,' +
          ixien + ',0)),U,1)') + #13;
    end;
  end;
  result.add(s);
  //  result.add('');

  result.add('Specialty/SubSpecialty:');
  sspec := filter.SpecSubSpec;
  s := '';
  if sspec = '' then
    s := '        Any'
  else
  begin
    ixl := maglength(sspec, ',');
    for ixi := 1 to ixl do
    begin
      ixien := magpiece(sspec, ',', ixi);
      if ixien <> '' then
        S := S + '        ' + XwbGetVarValue2('$P($G(^MAG(2005.84,' +
          ixien + ',0)),U,1)') + #13;
    end;
  end;
  result.add(s);
  //  result.add('');

  result.add('Procedure/Event:');
  sproc := filter.ProcEvent;
  s := '';
  if sproc = '' then
    s := '        Any'
  else
  begin
    ixl := maglength(sproc, ',');
    for ixi := 1 to ixl do
    begin
      ixien := magpiece(sproc, ',', ixi);
      if ixien <> '' then
        S := S + '        ' + XwbGetVarValue2('$P($G(^MAG(2005.85,' +
          ixien + ',0)),U,1)') + #13;
    end;
  end;
  result.add(s);
  //  result.add('');

end;

(*  moved to uMagDisplayMgr
function TfrmImageList.XwbGetVarValue(value : string): string;
begin
dmod.MagDBBroker1.GetBroker.RemoteProcedure := 'XWB GET VARIABLE VALUE';
dmod.MagDBBroker1.GetBroker.Param[0].PType := reference;
dmod.MagDBBroker1.GetBroker.Param[0].Value := value;
result := dmod.MagDBBroker1.GetBroker.strCall;
end;                       *)

procedure TfrmImageList.Mag4VGear1ImageMouseUp(Sender: TObject; Button:
  TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // JMW p72 1/22/2007 - this event doesn't fire, it occurs on ImageMouseDown
  //if (button  = mbLeft) and (shift =  [ssleft]) then
  //  ViewSelectedItemImage;
end;

{JK 1/6/2009 - Generalized the Image Term Editor method so the Verify Images and the Image List forms can both use it respectively.}

procedure TfrmImageList.mnuIndexEditClick(Sender: TObject);
begin
  CurrentImageIndexEdit;
end;

procedure TfrmImageList.OneEntryEdit(magien: string);
begin
  //
end;

procedure TfrmImageList.MultiEntryEdit(magienlist: TStrings);
begin
  //
end;

procedure TfrmImageList.mnuMultiLineClick(Sender: TObject);
begin
  mnuMultiLine.checked := not mnuMultiLine.checked;
  Maglistview1.MultiSelect := mnuMultiLine.checked;
end;

procedure TfrmImageList.mnuRefreshPatientImagesClick(Sender: TObject);
begin
  { change to same patient, forces a clear and reload.}
  frmMain.ChangeToPatient(dMod.MagPat1.M_DFN);
end;

procedure TfrmImageList.UpreftoImageListWin1Click(Sender: TObject);
begin
  UprefToImageListWin(upref);
end;

procedure TfrmImageList.mnuCacheGroup1Click(Sender: TObject);
begin
  CurrentImageCache;
end;

procedure TfrmImageList.mnuCacheGroup2Click(Sender: TObject);
{ JMW 4/19/2005 RIV p45}
var
  IObj: TImageData;
begin
  IObj := TMagListViewData(TListItem(MagListView1.Selected).Data).Iobj;
  CacheFromImageListWindow(Iobj);
end;

procedure TfrmImageList.CacheFromImageListWindow(iobj: TImageData);
var
  temp: TStringList;
  ConvertedList: TStrings;
begin
  if iobj.IsImageGroup then
  begin
    temp := TSTringlist.create;
    try
      begin
        dmod.MagDBBroker1.RPMaggGroupImages(Iobj, temp);
        ConvertedList := MagImageManager1.extractGroupImages(iobj.FFile,
          iobj.GroupCount, temp);
        if (convertedlist = nil) or (convertedlist.Count = 0) then
          exit; // JMW p46 9/5/06 bug fix for caching study twice
        MagImageManager1.startCache(ConvertedList);
      end;
    except
      on e: exception do
      begin
        //LogMsg('s', 'Exception auto-caching group images. Error=[' +
        //    e.message + ']');
        MagLogger.LogMsg('s', 'Exception auto-caching group images. Error=[' +
          E.message + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
      end;
    end;
  end
  else
  begin
    ConvertedList := MagImageManager1.extractSingleImage(iobj);
    if (convertedlist = nil) or (convertedlist.Count = 0) then
      exit; // JMW p46 9/5/06 bug fix for caching study twice
    MagImageManager1.startCache(ConvertedList);
  end;

end;

procedure TfrmImageList.tbtnPatientClick(Sender: TObject);
begin
  frmMain.PatientSelect('');
end;

procedure TfrmImageList.mnuViewAbstractsClick(Sender: TObject);
begin
  AbThmUseThumbNailWindow(true);
end;

procedure TfrmImageList.MagListView1GetSubItemImage(Sender: TObject;
  Item: TListItem; SubItem: Integer; var ImageIndex: Integer);
begin
  //    if subitem = 3 then imageindex := 2;
end;

procedure TfrmImageList.ActiveForms1Click(Sender: TObject);
begin
  SwitchToForm;
end;

procedure TfrmImageList.ShortCutMenu1Click(Sender: TObject);
var
  pt: Tpoint;
begin
  if self.ListWinAbsViewer.Focused then
  begin
    pt.x := ListWinAbsViewer.left;
    pt.y := ListWinAbsViewer.Top;
    pt := ListWinAbsViewer.ClientToScreen(pt);
    popupAbstracts.PopupComponent := ListWinAbsViewer;
    popupAbstracts.popup(pt.x, pt.y);
    exit;
  end;
  if self.ListWinFullViewer.Focused then
  begin
    pt.x := ListWinFullViewer.left;
    pt.y := ListWinFullViewer.Top;
    pt := ListWinFullViewer.ClientToScreen(pt);
    popupImage.PopupComponent := ListWinFullViewer;
    popupImage.popup(pt.x, pt.y);
    exit;
  end;
  if self.MagTreeView1.Focused then
  begin
    pt.x := MagTreeView1.left;
    pt.y := MagTreeView1.Top;
    pt := MagTreeView1.ClientToScreen(pt);
    PopupTree.PopupComponent := MagTreeView1;
    PopupTree.popup(pt.x, pt.y);
    exit;
  end;
  if self.MagListView1.Focused then
  begin
    //
  end;
  { TODO :
Patch 93.  Here need to popup the short cut menu for the Control that is in
focus.  This old code simply opens the ShortCut Menu for the magListView control.
We have to account for magTreeView, ListWinFullViewer, ListWinAbsViewer also.}
 { TODO :
Patch 93, we also need the Ctrl N or Ctrl P (next, prev) whatever shortcut menu item
they are given, to first Determine which control has the focus, and then move it
to the Next or Prev. }
  pt.x := maglistview1.left;
  pt.y := maglistview1.Top;
  pt := maglistview1.ClientToScreen(pt);
  menuMagListView.PopupComponent := maglistview1;
  menuMagListView.popup(pt.x, pt.y);
end;

procedure TfrmImageList.tbtnRefreshClick(Sender: TObject);
begin
  { change to same patient, forces a clear and reload.}
  if dmod.MagPat1.M_DFN <> '' then
    frmMain.ChangeToPatient(dMod.MagPat1.M_DFN);
end;

procedure TfrmImageList.mnuFilterInfo2Click(Sender: TObject);
begin
  FilterDetailsInInfoWindow;
end;

procedure TfrmImageList.Mag4VGear1ImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (button = mbLeft) and (shift = [ssleft]) then
  begin
    //ViewSelectedItemImage;
    CurrentImageOpen();
  end;

end;

(*procedure TfrmImageList.Label1Click(Sender: TObject);
var deci,i,j : integer;
begin
  deci := 10;
 // if pnlctl.Width < panel2.Width then pnlctl.Width := panel2.Width;
  if pnlstuff.Width > pnlctl.Width then
    begin
    if (pnlstuff.Width - 10) < pnlctl.Width then deci := (pnlstuff.Width - pnlctl.Width);
    for i := 1 to 180000 do
       begin
       if (i mod 1000) <> 0 then continue;
       pnlstuff.Width := pnlstuff.Width - deci;
       if (pnlstuff.Width - 10) < pnlctl.Width then deci := (pnlstuff.Width - pnlctl.Width);
       if pnlstuff.Width = pnlctl.Width then break;
       end;
    end
    else

  for i := 1 to 20000 do
    begin
      if (i mod 1000) = 0 then pnlstuff.Width := pnlstuff.Width + 10;

    end;

end;  *)

procedure TfrmImageList.mnuPatientProfile1Click(Sender: TObject);
begin
  dmod.MagUtilsDB1.openpatientprofile;
end;

procedure TfrmImageList.mnuHealthSummary1Click(Sender: TObject);
var
  t: tstringlist;
begin
  if (dMod.MagPat1.M_DFN = '') then
  begin
    //maggmsgf.MagMsg('d', 'You must first select a Patient ');
    MagLogger.MagMsg('d', 'You must first select a Patient '); {JK 10/5/2009 - Maggmsgu refactoring}
    winmsg(mmsglistwin, 'You must first select a Patient ');
    exit;
  end;
  if not doesformexist('MAGGRPTF') then
  begin
    maggrptf := tmaggrptf.create(frmMain);
  end;
  {   Here we load information into Health Summary window.
       - Need to call a method of the window, not set info from Main Form.}
  maggrptf.loadHsTypeList;
  maggrptf.PatDFN.caption := dMod.MagPat1.M_DFN; //inttostr(i); {DFN as String}
  maggrptf.PatName.caption := dMod.MagPat1.M_NameDisplay;
  maggrptf.PatDemog.caption := dMod.MagPat1.M_Demog;
  maggrptf.caption := 'VistA Health Summary: ' + dMod.MagPat1.M_NameDisplay;
  FormToNormalSize(MaggrpTf);
  maggrptf.show;
end;

procedure TfrmImageList.mnuDischargeSummary1Click(Sender: TObject);
begin
  MagTIUWinf.SetPatientName(dMod.MagPat1.M_DFN, dMod.MagPat1.M_NameDisplay);
  MagTIUWinf.GetDischargeSummaries;
  FormToNormalSize(MagTIUWinf);
  MagTIUWinf.show;
end;

procedure TfrmImageList.FilterDetails1Click(Sender: TObject);
begin
  FilterDetailsInInfoWindow;
end;

procedure TfrmImageList.mnuFiltersasTabs1Click(Sender: TObject);
begin
  FiltersAsTabs(mnuFiltersasTabs1.Checked);
end;

procedure TfrmImageList.FiltersAsTabs(value: boolean);
begin
  pnlFilterTabs.visible := value;
  //p93, not sure why these are here.
  tabctrlFilters.MultiLine := mnuMultiLineTabs1.checked;
  SetMultiLineTabs(tabctrlFilters.MultiLine);
end;

procedure TfrmImageList.ListWinFullViewerViewerImageClick(sender: TObject);
var
  vIobj: Timagedata;
  newsObj: TMagNewsObject;
  ocurs: Tcursor;
begin
  try
    CursorChange(ocurs, crHourGlass); //        screen.Cursor := crHourGlass;
    listWinFullViewer.Enabled := false;
    self.magViewerTB81.UpdateImageState;
    if FSyncImageON then {FSyncImageOn from  ListWinFullViewerViewer click}
    begin
      vIobj := listwinfullviewer.GetCurrentImageObject;
      if vIobj <> nil then
        {JK 1/6/2009 - Fixed D22 by uncommenting this line}
      begin
        newsObj := MakeNewsObject(mpubImageSelected, 0, vIobj.Mag0, vIobj,
          ListWinFullViewer);
{$IFDEF testmessages}
        winmsg(umagdefinitions.mmsglistwin, 'Fimagelistsyncprocessing: ' + magbooltostr(Fimagelistsyncprocessing));
{$ENDIF}
        //NewsSubscribe Does this- SetCurSelectedImageObj(vIobj);    {ListWinFullViewerViewerImageClick}
        self.MagPublisher1.I_SetNews(newsobj);
        //ListWinFullViewerViewerImageClick Click
      end;
    end;
  finally
    cursorRestore(ocurs); // screen.Cursor := crDefault;
    listWinFullViewer.Enabled := true;
  end;
end;

procedure TfrmImageList.pgctrlTreeViewChange(Sender: TObject);
begin
  LoadLocalTree;
end;

procedure TfrmImageList.LoadLocalTree;
var
  ocurs: Tcursor;
begin
  try
    CursorChange(ocurs, crHourGlass); //        screen.Cursor := crHourGlass;
    with pgctrlTreeView do
    begin
      if Activepage = tabshPkg2 then
      begin
        magtreeview1.LoadListFromMagImageList(magimagelist1, 'pkg-8');
      end
      else if Activepage = tabshSpec2 then
      begin
        magtreeview1.LoadListFromMagImageList(magimagelist1, 'spec-11');
      end
        //else if Activepage = tabshEvent2 then
        //begin
        //  magtreeview1.LoadListFromMagImageList(magimagelist1, 'Event-12');
        //end
      else if Activepage = tabshType2 then
      begin
        magtreeview1.LoadListFromMagImageList(magimagelist1, 'type-10');
      end
      else if Activepage = tabshClass2 then
      begin
        magtreeview1.LoadListFromMagImageList(magimagelist1, 'class-9');
      end;
    end;
    RefreshLocalTree;
  finally
    cursorRestore(ocurs); //         screen.Cursor := crdefault;
  end;

end;

procedure TfrmImageList.RefreshLocalTree;
var
  ocurs: Tcursor;
begin
  try
    CursorChange(ocurs, crHourGlass); //        screen.Cursor := crhourglass;
    self.FCurTreeNode := nil;
    magtreeview1.Invalidate;
  finally
    cursorRestore(ocurs); //         screen.Cursor := crdefault;
  end;
end;

procedure TfrmImageList.mnuTreeClick(Sender: TObject);
begin
  mnuTreeTabs1.Enabled := pnltree.Visible;
  mnuAlphaSort.enabled := pnltree.visible;
  mnuTreeSpecEvent.enabled := pnltree.visible;
  mnuTreeTypeSpec.enabled := pnltree.visible;
  mnuTreePkgType.enabled := pnltree.visible;
  mnuTreeCustom.enabled := pnltree.visible;
  mnuExpand1Level.enabled := pnltree.visible;
  mnuExpandAll.enabled := pnltree.visible;
  mnuCollapseAll.enabled := pnltree.visible;
  mnuAutoExpandCollapse.Enabled := pnltree.visible;
  mnuTreeRefresh1.Enabled := pnltree.visible;

  mnuTreeTabs1.Checked := pgctrlTreeView.Visible;
  mnuShowTree.Checked := pnlTree.Visible;
  mnuVTtreesortbuttons.Checked := pgctrlTreeView.Visible;
  mnuAutoExpandCollapse.Checked := magtreeview1.AutoExpand;

end;

procedure TfrmImageList.mnuShowListClick(Sender: TObject);
begin
  ListViewShow(mnuShowList.checked);
end;



procedure TfrmImagelist.ListViewShow(value: boolean);
begin
  tbtnPrevAbs.Enabled := value;
  tbtnPrevReport.Enabled := value;
  tbtnFitCol.enabled := value;
  tbtnFitColWin.Enabled := value;
  tbtnSelectColumn.Enabled := value;
  if value then
  begin
    pnlMagListView.Align := Alnone;
    pnlMagListView.Height := trunc(pnlMain.Height div 3);
    pnlMaglistView.Visible := true;
    if pnlFullRes.Visible then
    begin
      pnlMaglistView.Align := Altop;
      splpnlFullRes.Align := alnone;
      splpnlfullres.Top := pnlmaglistview.Height + 10;
      splpnlfullres.Visible := true;
      splpnlFullRes.Align := altop;
    end
    else
    begin
      pnlMagListView.Align := alclient;
      splpnlFullRes.Visible := false;
    end;
  end
  else
  begin
    pnlMagListView.visible := false;
    pnlMagListView.Align := alnone;
    splpnlfullres.Visible := false;
    splpnlfullres.Align := alnone;
    if pnlfullres.Visible then
      pnlfullres.Align := alclient;
  end;

end;

procedure TfrmImageList.mnuSelectColumnsClick(Sender: TObject);
begin
  MagListView1.SelectColumns;
end;

procedure TfrmImageList.mnuFitColToTextClick(Sender: TObject);
begin
  maglistview1.FitColumnsToText;
end;

procedure TfrmImageList.mnuFitColToWinClick(Sender: TObject);
begin
  maglistview1.FitColumnsToForm;
end;

procedure TfrmImageList.mnuShowGridClick(Sender: TObject);
begin
  MagListView1.GridLines := mnuShowGrid.checked;
end;

procedure TfrmImageList.mnuPreviewAbstractClick(Sender: TObject);
begin
  tbtnPrevAbs.down := mnuPreviewAbstract.checked;
  SetAbsPreview(tbtnPrevAbs.Down);
end;

procedure TfrmImageList.mnuPreviewReportClick(Sender: TObject);
begin
  tbtnPrevReport.down := mnuPreviewReport.checked;
  SetRptPreview(tbtnPrevReport.down);
end;

procedure TfrmImageList.tbtnSelectColumnClick(Sender: TObject);
begin
  MagListView1.SelectColumns;
end;

procedure TfrmImageList.tbtnAbstractsClick(Sender: TObject);
begin
  ShowHideThumbNails(tbtnAbstracts.down);
end;

procedure TfrmImageList.mnuShowThumbNailClick(Sender: TObject);
begin
  ShowHideThumbNails(mnuShowThumbNail.checked);
end;

procedure TfrmImageList.ShowHideThumbNails(value: boolean);
begin
  if ((tbtnAbstracts.Down) <> value) then
    tbtnAbstracts.Down := value;
  if ((mnuShowThumbNail.Checked) <> value) then
    mnuShowThumbNail.Checked := value;
  tbtnAbstracts.Update;
  try
    tbtnAbstracts.tag := -1;
    UnCheckMarkLayoutStyles;
    if value then
    begin
      if FUseThumbNailWindow then
      begin
        AbThmHideThm;
        AbThmLINKThumbNails(false, self.magImageList1);
        AbThmUseThumbNailWindow(true);
      end
      else
      begin
        AbThmShowThm;
        //AbThmLINKThumbNails(true,self.magImageList1);
        //AbThmUseThumbNailWindow(false);
      end;
      SyncAllWithCurrent;
    end
    else
    begin
      {  we don't want to 'NOT USE' it, we want to use it next time 'ShowAbs' is clicked
         we just want to hide it for now.}
      frmMain.ShowAbstractWindow(false); //AbThmUseThumbNailWindow(false);
      AbThmHideThm;
      AbThmLINKThumbNails(false, self.magImageList1);
    end;
  finally
    tbtnAbstracts.tag := 0;
  end;
end;

procedure TfrmImageList.AbThmUseThumbNailWindow(value: boolean);
begin
  FUseThumbNailWindow := value;
  //tbtnAbstracts.Down := value;
  frmMain.ShowAbstractWindow(value);
end;

procedure TfrmImageList.AbThmThumbsBottomTree;
begin
  AbThmUseThumbNailWindow(false);
  if (pnlabs.Parent = pnlTree) and pnltree.Visible and pnlabs.Visible then
  begin
    ListwinAbsviewer.ReAlignImages();
    exit;
  end;
  pnlabs.visible := false;
  if pnlabs.Parent <> pnlTree then
    pnlabs.Parent := pnlTree;
  if not pnlTree.Visible then
    TreeShow;
  if pnlabs.Align <> albottom then
  begin
    pnlabs.Align := albottom;
    pnlabs.Height := 200;
  end;
  splpnlAbstree.Height := 5;
  splpnlAbstree.Top := pnlabs.Top - 5;
  splpnlAbstree.Align := albottom;
  pnlabs.Visible := true;
  splpnlAbstree.Visible := true;

  AbThmUseThumbNailWindow(false);
  AbThmLINKThumbNails(true, self.magImageList1);
  listwinabsviewer.ReAlignImages();

end;

procedure TfrmImagelist.AbThmThumbsBottom;
begin
  ;
  AbThmUseThumbNailWindow(false);
  if pnlabs.Visible and (pnlabs.Parent <> pnltree) and (pnlabs.Align =
    albottom) then
  begin
    listwinabsviewer.ReAlignImages();
    exit;
  end;

  if pnlabs.Visible then
    AbThmHideThm;
  if pnlabs.Parent <> self then
    pnlabs.Parent := self;
  if pnlabs.Align <> albottom then
  begin
    pnlabs.Align := albottom;
    pnlabs.Height := 200;
  end;
  splpnlabs.Height := 5;
  splpnlabs.Top := pnlabs.Top - 5;
  splpnlabs.Align := albottom;
  pnlabs.Visible := true;
  splpnlabs.Visible := true;

  AbThmUseThumbNailWindow(false);
  AbThmLINKThumbNails(true, self.magImageList1);
  listwinabsviewer.ReAlignImages();
end;

procedure TfrmImageList.AbThmThumbsLeft;
var
  treevis: boolean;
begin
  AbThmUseThumbNailWindow(false);
  if pnlabs.Visible and (pnlabs.Parent <> pnltree) and (pnlabs.Align = alleft) then
  begin
    listwinabsviewer.ReAlignImages();
    exit;
  end;

  if pnlabs.Visible then
    AbThmHideThm;
  if pnlabs.Parent = pnlTree then
    pnlabs.parent := self;

  treevis := pnlTree.Visible;
  if treevis then
    TreeHide;

  pnlabs.Align := alleft;
  pnlabs.Width := 150;
  splpnlabs.width := 5;
  splpnlabs.Left := pnlabs.Left + pnlabs.Width;
  splpnlabs.Align := alleft;

  pnlabs.Visible := true;
  splpnlabs.visible := true;

  if treevis then
  begin
    TreeShow;
  end;

  AbThmUseThumbNailWindow(false);
  AbThmLINKThumbNails(true, self.magImageList1);
  listwinabsviewer.ReAlignImages();
end;

procedure TfrmImageList.mnuThumbNailWindowClick(Sender: TObject);
begin
  AbThmHideThm;
  AbThmLINKThumbNails(false, self.magImageList1);
  UnCheckMarkLayoutStyles; {JK 1/6/2009}
  AbThmUseThumbNailWindow(mnuThumbNailWindow.Checked);
  application.processmessages;

end;

procedure TfrmImageList.mnuThumbsBottom2Click(Sender: TObject);
begin
  AbThmThumbsBottom;
  if not tbtnAbstracts.Down then
    if (frmImageList.tbtnAbstracts.Tag <> -1) then
      tbtnAbstracts.Down := true;
  UnCheckMarkLayoutStyles; {JK 1/6/2009}
  tbtnAbstracts.Down := true;
end;

procedure TfrmImageList.mnuThumbsLeft2Click(Sender: TObject);
begin
  AbThmThumbsLeft;
  if not tbtnAbstracts.Down then
    if (frmImageList.tbtnAbstracts.Tag <> -1) then
      tbtnAbstracts.Down := true;
  UnCheckMarkLayoutStyles; {JK 1/6/2009}
  tbtnAbstracts.Down := true;
end;

procedure TfrmImageList.mnuThumbsBottomTree2Click(Sender: TObject);
begin
  AbThmThumbsBottomTree;
  if not tbtnAbstracts.Down then
    if (frmImageList.tbtnAbstracts.Tag <> -1) then
      tbtnAbstracts.Down := true;
  UnCheckMarkLayoutStyles; {JK 1/6/2009}
  tbtnAbstracts.Down := true;
end;

procedure TfrmImageList.SetDefaultThumbNailAlignment;
begin
  ListWinAbsViewer.ReSizeAndAlign(150, 95);
  ListWinAbsViewer.ReFreshImages;
end;

procedure TfrmImageList.SetDefaultFullViewerAlignment;
begin
  ListWinFullViewer.SetRowColCount(1, 1);
  ListWinFullViewer.ReFreshImages;
end;

procedure TfrmImageList.mnuThumbsRefresh2Click(Sender: TObject);
begin
  if mnuThumbNailWindow.Checked then
    frmMagAbstracts.Mag4Viewer1.ReFreshImages
  else
    ListWinAbsViewer.ReFreshImages;
end;

procedure TfrmImageList.mnuShowTreeClick(Sender: TObject);
begin
  UnCheckMarkLayoutStyles; {JK 1/6/2009}
  if mnuShowTree.checked then
    TreeShow
  else
    TreeHide;
end;

procedure TfrmImageList.TreeShow;
var
  refresh: boolean;
begin

  TreeHide;
  if pnlabs.Parent <> pnlTree then
  begin
    if (pnlabs.Align = alleft) and (pnlabs.Visible = true) then
      pnlTree.Left := splpnlAbs.Left + splpnlAbs.Width + 2;
  end;
  pnlTree.Align := alleft;
  pnlTree.Visible := true;
  splpnlTree.Left := pnlTree.Left + pnlTree.Width;
  splpnlTree.Width := 5;
  splpnlTree.Align := alleft;
  splpnlTree.Visible := true;

  RefreshLocalTree;
  self.LoadLocalTree;
end;

procedure TfrmImageList.TreeHide;
var
  refresh: boolean;
begin
  pnlTree.Visible := false;
  pnlTree.Align := alnone;
  SplPnltree.Visible := false;
  SplPnltree.Align := alnone;
  if pnlabs.Parent = pnlTree then
  begin
    //AbsHide;
  end;
end;

procedure TfrmImageList.mnuAlphaSortClick(Sender: TObject);
begin
  {   magtreeview1.AlphaSort(recursive : boolean)
                     Recursive says to sort all levels.}
  magtreeview1.AlphaSort(false);
  RefreshLocalTree;
end;

procedure TfrmImageList.mnuTreeSpecEventClick(Sender: TObject);
begin
  magtreeview1.LoadListFromMagImageList(magimagelist1, 'spec-11,event-12');
  pgctrlTreeView.TabIndex := -1;
  RefreshLocalTree;
end;

procedure TfrmImageList.mnuTreeTypeSpecClick(Sender: TObject);
begin
  magtreeview1.LoadListFromMagImageList(magimagelist1, 'type-10,spec-11');
  pgctrlTreeView.TabIndex := -1;
  RefreshLocalTree;
end;

procedure TfrmImageList.mnuTreePkgTypeClick(Sender: TObject);
begin
  magtreeview1.LoadListFromMagImageList(magimagelist1, 'pkg-8,type-10');
  pgctrlTreeView.TabIndex := -1;
  RefreshLocalTree;
end;

procedure TfrmImageList.mnuTreeCustomClick(Sender: TObject);
begin
  if MagTreeView1.SelectBranches(MagImageList1) then
    pgctrlTreeView.TabIndex := -1;
  RefreshLocalTree;
end;

procedure TfrmImageList.mnuExpandAllClick(Sender: TObject);
begin
  magtreeview1.FullExpand;
end;

procedure TfrmImageList.mnuExpand1LevelClick(Sender: TObject);
var
  I: integer;
begin
  magtreeview1.FullCollapse;
  for i := 0 to magtreeview1.Items.count - 1 do
  begin
    if magtreeview1.items[i].Level = 0 then
      magtreeview1.Items[i].Expand(false);
  end;

end;

procedure TfrmImageList.mnuCollapseAllClick(Sender: TObject);
begin
  magtreeview1.FullCollapse
end;

procedure TfrmImageList.mnuTreeRefresh1Click(Sender: TObject);
begin
  RefreshLocalTree;
end;

procedure TfrmImageList.MagTreeView1Click(Sender: TObject);
begin
{$IFDEF TESTMESSAGES}maggmsgf.MagMsg('', 'In MagTreeView1click(...');
{$ENDIF}
  timersynctimer.Enabled := false;
  if magtreeview1.AutoSelect then
    self.OpenSelectedTreeImage(1);

end;

procedure TfrmImageList.OpenSelectedTreeImage(radcode: integer);
var
  viewer: Tmag4viewer;
  tn: TTreenode;
  vIobj: TimageData;
  newsobj: TMagNewsObject;
  retmsg: string;
  ocurs: Tcursor;
begin
{$IFDEF TESTMESSAGES}maggmsgf.MagMsg('', 'In OpenSelectedTreeImage(...');
{$ENDIF}
  try
    CursorChange(ocurs, crHourGlass); //        screen.cursor := crHourGlass;
    if assigned(newviewer) then
      viewer := newviewer
    else
      viewer := frmFullRes.Mag4Viewer1;

    TN := magtreeview1.selected;
    { TODO -cRefactor :  Create a function that validates that the Tree Node has a
      valid linked TImageData object.  These 3-4 lines of code are used about 8 places.
        tn=nil
        tn.haschildren
        tn.data.iobj <> nil }
    if tn = nil then
      exit;
    if tn.HasChildren then
      exit;
    if FSyncImageON then {FSyncImageOn from TreeView click}
    begin
      vIobj := (TMagTreeViewData(tn.Data).Iobj);
      if vIobj <> nil then
      begin
        newsObj := MakeNewsObject(mpubImageSelected, 0, vIobj.Mag0, vIobj,
          MagTreeView1);
        self.MagPublisher1.I_SetNews(newsobj);
        //  procedure OpenSelectedTreeImage
      end;

    end;
    { TODO -c93+ :
  wow, this is backwards, calling the tree to call openselectedimage.  Need to get
  selected images from tree, then call openselectedimages from here. }
    if (magtreeview1.SelectionCount > 1) then
      magtreeview1.SelectedTreeItemsToMagViewer(magtreeview1, viewer)
    else
    begin
      {93t12 here, we want to always use same call to open an image from the image list window.
             not a seperate call for each component on the form.  OpenSelectedImage is called
             from CurrentImageOpen.  }
      if umagdisplaymgr.FCurSelectedImageObj.Mag0 = vIobj.Mag0 then
        self.CurrentImageOpen();
      exit;
      retmsg := OpenSelectedImage(vIobj, radcode, 0, 1, 0);
      //if magpiece(retmsg, '^', 1) = '0' then xmsg := magpiece(retmsg, '^', 2);
{$IFDEF TESTMESSAGES}maggmsgf.MagMsg('', 'called OpenSelectImage(IEN: ' + vIobj.Mag0);
      maggmsgf.magmsg('', 'result OpenSelectImage.. ' + retmsg);
{$ENDIF}
      //winmsg(mmsglistwin, retmsg);
    end;
  finally
    cursorRestore(ocurs); //         screen.cursor := crdefault;
  end;
end;

procedure TfrmImageList.DefaultToSyncOnAutoSelect;
var
  autospeed: integer;
begin
  FSyncImageON := true;
  // menu item is now invisivle, and is checked by defalut
  //out in 93   mnuSyncSelectedImage.Checked := true;
  MagListView1.HotTrack := true;
  MagTreeView1.AutoSelect := true;
  autospeed := 1;
  case AutoSpeed of
    0:
      begin
        MagListView1.HoverTime := 750;
        self.timerSyncTimer.Interval := 750;
      end;
    1:
      begin
        MagListView1.HoverTime := 500;
        self.timerSyncTimer.Interval := 500;
      end;
    2:
      begin
        MagListView1.HoverTime := 250;
        self.timerSyncTimer.Interval := 250;
      end;
  end;
end;

procedure TfrmImageList.MagTreeView1Collapsed(Sender: TObject;
  Node: TTreeNode);
begin
  node.ImageIndex := mistFolderClosed; //93
end;

procedure TfrmImageList.MagTreeView1Expanded(Sender: TObject;
  Node: TTreeNode);
begin
  node.ImageIndex := mistFolderOpen; //93
end;

procedure TfrmImageList.MagTreeView1GetSelectedIndex(Sender: TObject;
  Node: TTreeNode);
begin
  if node.Selected then
  begin
    if node.HasChildren then
      node.SelectedIndex := mistFolderWithDoc
    else
      node.SelectedIndex := node.ImageIndex;
  end
  else
    node.SelectedIndex := -1;

end;

procedure TfrmImageList.MagTreeView1MouseMove(Sender: TObject; Shift:
  TShiftState; X, Y: Integer);
var
  tn: TTreenode;
begin
  FHitX := 0;
  FHitY := 0;
  if timersynctimer.Enabled then
    timersynctimer.Enabled := false;
  if not magtreeview1.AutoSelect then
    exit;

  (*
  tn := magtreeview1.GetNodeAt(X, Y);
  if tn = nil then
  begin
              //gmaglog.LogMsg_('MOuse Move  TN = NIL');
    maggmsgf.MagMsg('s', 'Mouse Move  TreeNode = NIL');
    exit;
  end
  else maggmsgf.MagMsg('s', 'Mouse Move ' + tn.Text); //gmaglog.LogMsg_('Mouse Move ' + tn.Text);
  *)

  FHitX := x;
  FHitY := y;
  timersynctimer.Enabled := true;

end;

procedure TfrmImageList.timerSyncTimerTimer(Sender: TObject);
var
  viObj: TImageData;
  tn: Ttreenode;
  curx, cury: integer;
  curm: Tpoint;
  temp: tpoint;
  newsObj: TMagNewsObject;
  ocurs: Tcursor;
begin
  try
    CursorChange(ocurs, crHourGlass);
    timersynctimer.Enabled := false;
    if not magtreeview1.autoselect then
      exit;
    if (FHitX = 0) and (FHitY = 0) then
      exit;
    /////////////////
    curm := magtreeview1.ScreenToClient(mouse.CursorPos);
    {   the mouse has moved since the timer started.  This happens when the curson moves off of
       the MagTreeView control.  Nothing to disable the Timer.  }
    if (curm.X <> FHitX) or (curm.Y <> FHitY) then
      exit;

    tn := magtreeview1.GetNodeAt(FHitX, FHitY);
    //  gmaglog.LogMsg_('s', 'Timer Timer ' + tn.Text);
    if FCurTreeNode = tn then
      exit; //ISI is this working ?
    //  gmaglog.LogMsg_('AFter " = " test Timer Timer ' + tn.Text);
    if tn = nil then
      exit;
    if tn.HasChildren then
      exit;
    if TMagTreeViewData(TN.Data) = nil then
      exit;
    { here so tn is a valid Node with a valid Iobj.}
    if FCurTreeNode = nil then
      FCurTreeNode := tn
    else if TMagTreeViewData(FCurTreenode.Data) = nil then
      FCurTreeNode := tn
    else if TMagTreeViewData(TN.Data).Iobj.Mag0 <>
      TMagTreeViewData(FCurTreenode.Data).Iobj.Mag0 then
      FCurTreeNode := tn;

    {FcurTreeNode is different than old, and is Valid}
         // gmaglog.LogMsg_(FcurTreeNode.Text);

      {   We are only here because AutoSelect = true}
    FcurTreeNode.Selected := true;

    if FSyncImageON then { timerSyncTimerTimer }
    begin
      vIobj := (TMagTreeViewData(FCurTreeNode.Data).Iobj);
      if vIobj <> nil then
      begin
        newsObj := MakeNewsObject(mpubImageSelected, 0, vIobj.Mag0, vIobj, MagTreeView1);
        self.MagPublisher1.I_SetNews(newsobj);
        //TreeView mouse (timerSyncTimerTimer)
      end;
    end;
  finally
    cursorRestore(ocurs);
  end;
end;

procedure TfrmImageList.ListWinAbsViewerViewerImageClick(sender: TObject);
begin
  if sender = nil then
    exit;
  self.AbsOpenSelectedImage(Tmag4vGear(sender).PI_ptrData, 1); //, 0, 1, 0);
end;
    {/MD gek
    procedure AbsOpenSelectedImage(}
procedure TfrmImageList.AbsOpenSelectedImage(Iobj: TImagedata; RadCode: integer);
var
  xmsg, retmsg: string;
  vIobj: TImageData;
  newsObj: TMagNewsObject;
  ocurs: Tcursor;
  temp: string;
begin
  {     Setting to nil was causing Access violations...  reworked this function,  old code is
        below for comparison (for awhile gek).}
  xmsg := '';
  try
    CursorChange(ocurs, crHourGlass);
    update;
    ListWinAbsViewer.Enabled := false;
    ListWInAbsViewer.Update;      //94t10
    application.ProcessMessages;  //94t10
    ListWinAbsViewer.StopLoadingImages := true;

    // from Abs window
     //retmsg := OpenSelectedImage(Iobj, RadCode, 0, 1, 0,false,false);
    //
    {/p94t1 gek 10/26/09  Setting to nil was causing AccViol problems ... found during BSE testing
            but probably not BSE related.}
    //SetCurSelectedImageObj(nil);
    {   FSyncImageON is always true...  leaving for now, maybe have reason later for False setting.}
    if FSyncImageON then {FSyncImageOn from  ListWinAbsViewer click}
    begin
      vIobj := ListWinAbsViewer.GetCurrentImageObject;
      if vIobj = nil then
        exit;
        {   if same image being selected, don't send another mpubImageSelected message.}
    //// out for 94T10 Testing          if umagdisplaymgr.FCurSelectedImageObj <> nil then
    //// out for 94T10 Testing    if umagdisplaymgr.FCurSelectedImageObj.Mag0 = vIobj.Mag0 then
    //// out for 94T10 Testing    exit;

    { this need looked at.  It won't refresh the Group Abs window like the clicking a grp abs
        from the Abs 'window' (old way) does.
     {we don't want to exit the function, just skip the newobj,
     but we still want to currentimageopen below..... I think.  Needs compared to Abs Window.}


      newsObj := MakeNewsObject(mpubImageSelected, 0, vIobj.Mag0, vIobj, ListWinAbsViewer);
      {   News Subscribe method does this => SetCurSelectedImageObj(vIobj);   }{frmImageList.AbsOpenSelectedImage}
      self.MagPublisher1.I_SetNews(newsobj); //ListWinAbsViewer Click

    end;

    {This is what we want,  to open the Current Image Object.
       old way is below, which the flow of code should now never reach}
    if umagdisplaymgr.FCurSelectedImageObj.Mag0 = vIobj.Mag0 then
    begin
      self.CurrentImageOpen();
      exit;
    end;

    { should never get to lines below.  But keeping in for awhile...}
    {=============}
    MagLogger.LogMsg('s', 'Section of code shouldn''t execute.'); {JK 10/6/2009 - Maggmsgu refactoring}
    retmsg := OpenSelectedImage(Iobj, radcode, 0, 1, 0);
    if magpiece(retmsg, '^', 1) = '0' then
      xmsg := magpiece(retmsg, '^', 2);
    {=============}

  finally
    ListWinAbsViewer.Enabled := true;
    cursorRestore(ocurs);
  end;

  (*   xmsg := '';
       try
          CursorChange(ocurs, crHourGlass); //        Screen.Cursor := crHourGlass;
          update;
          ListWinAbsViewer.Enabled := false;
          ListWinAbsViewer.StopLoadingImages := true;
          //isi retmsg := MagMgrImage.OpenSelectedImage(Iobj);
      {$ifdef testmessages}
      winmsg(umagdefinitions.mmsglistwin,'Fimagelistsyncprocessing: ' +  magbooltostr(Fimagelistsyncprocessing));
      {$endif}
          SetCurSelectedImageObj(nil);     {frmImageList.AbsOpenSelectedImage}
          if FSyncImageON then {FSyncImageOn from  ListWinAbsViewer click}
          begin
              vIobj := ListWinAbsViewer.GetCurrentImageObject;
              if vIobj <> nil then
              begin
                  newsObj := MakeNewsObject(mpubImageSelected, 0, vIobj.Mag0, vIobj,
                      ListWinAbsViewer);
      {$ifdef testmessages}
      winmsg(umagdefinitions.mmsglistwin,'Fimagelistsyncprocessing: ' +  magbooltostr(Fimagelistsyncprocessing));
      {$endif}
                  //NewsSubscribe Does this- SetCurSelectedImageObj(vIobj);     {frmImageList.AbsOpenSelectedImage}
                  self.MagPublisher1.I_SetNews(newsobj); //ListWinAbsViewer Click
              end;
          end;
          {This is what we want,  to open the Current Image Object.
             old way is below, which the flow of code should now never reach}

          if umagdisplaymgr.FCurSelectedImageObj.Mag0 = vIobj.Mag0 then
            begin
             self.CurrentImageOpen();
             exit;
           end;
           // should never get to lines below.
           //logmsg('s','Section of code shouldn''t execut.');
           MagLogger.LogMsg('s', 'Section of code shouldn''t execute.'); {JK 10/6/2009 - Maggmsgu refactoring}
          retmsg := OpenSelectedImage(Iobj, radcode, 0, 1, 0);
          if magpiece(retmsg, '^', 1) = '0' then
              xmsg := magpiece(retmsg, '^', 2);
      finally
          ListWinAbsViewer.Enabled := true;
          cursorRestore(ocurs); //         Screen.Cursor := crdefault;
      end; *)
end;

procedure TfrmImageList.mnuLayoutsClick(Sender: TObject);
begin
  mnuFullImageViewerWindow.Checked := not pnlfullres.Visible;
  //fix mnuOpenGroupThumbnailPreview.checked :=  upref.GrpOpenGrp;
end;

{JK 1/4/2009 - fixes D31}

procedure TfrmImageList.CheckMark(Item: TMenuItem);
begin
  ExplorerStyle1.Checked := False;
  TreeList1.Checked := False;
  TreeAbs1.Checked := False;
  FilmStrip1.Checked := False;
  MnuFilmStripLeft.Checked := False;
  AbsList1.Checked := False;
  ListWithPreviews1.Checked := False;

  Item.Checked := True;
end;

{JK 1/6/2009 - Fixes D31}

procedure TfrmImageList.UnCheckMarkLayoutStyles;
begin
  ExplorerStyle1.Checked := False;
  TreeList1.Checked := False;
  TreeAbs1.Checked := False;
  FilmStrip1.Checked := False;
  MnuFilmStripLeft.Checked := False;
  AbsList1.Checked := False;
  ListWithPreviews1.Checked := False;
end;

procedure TfrmImageList.ExplorerStyle1Click(Sender: TObject);
begin
  CheckMark(TMenuItem(Sender)); {JK 1/4/2009 - fixes D31}

  FullResLocalShow(true);
  TreeShow;
  AbThmHideThm;
  ListViewShow(false);
end;

procedure TfrmImageList.TreeList1Click(Sender: TObject);
begin
  CheckMark(TMenuItem(Sender)); {JK 1/4/2009 - fixes D31}

  self.FullResLocalShow(true);
  TreeShow;
  AbThmHideThm;
  ListViewShow(true);
  // leave where ever it is  FullResLocalShow(true);
end;

procedure TfrmImageList.TreeAbs1Click(Sender: TObject);
begin
  CheckMark(TMenuItem(Sender)); {JK 1/4/2009 - fixes D31}

  self.FullResLocalShow(true);
  TreeShow;
  AbThmThumbsBottomTree;
  ListViewShow(false);
  // leave where ever it is  FullResLocalShow(true);
end;

procedure TfrmImageList.Filmstrip1Click(Sender: TObject);
begin
  CheckMark(TMenuItem(Sender)); {JK 1/4/2009 - fixes D31}

  self.FullResLocalShow(true);
  self.TreeHide;
  self.ListViewShow(false);
  self.AbThmThumbsBottom;
end;

procedure TfrmImageList.mnuFilmStripLeftClick(Sender: TObject);
begin
  CheckMark(TMenuItem(Sender)); {JK 1/4/2009 - fixes D31}

  self.FullResLocalShow(true);
  TreeHide;
  ListViewShow(false);

  self.AbThmThumbsLeft;
end;

procedure TfrmImageList.AbsList1Click(Sender: TObject);
begin
  CheckMark(TMenuItem(Sender)); {JK 1/4/2009 - fixes D31}

  self.FullResLocalShow(true);
  TreeHide;

  self.AbThmThumbsLeft;
  ListViewShow(true);
end;

procedure TfrmImageList.ListwithPreviews1Click(Sender: TObject);
begin
  CheckMark(TMenuItem(Sender)); {JK 1/4/2009 - fixes D31}

  self.FullResLocalShow(true);
  self.TreeHide;
  self.ListViewShow(true);
  self.AbThmHideThm;
  self.SetAbsPreview(true);
  self.SetRptPreview(true);
  self.Update;
  self.ForceRepaint;
  self.Update;
end;

procedure TfrmImageList.mnuFullImageViewerWindowClick(Sender: TObject);
begin
  FullResLocalShow(not mnuFullImageViewerWindow.checked);
  if mnuFullImageViewerWindow.checked then
    frmFullRes.Show;
end;

procedure TfrmImageList.mnuOpenGroupThumbnailPreviewClick(Sender: TObject);
begin
  //fix   upref.GrpOpenGrp := mnuOpenGroupThumbnailPreview.checked;
end;

procedure TfrmImageList.FullResLocalShow(value: boolean);
begin
  if value then
  begin
    if not pnlfullres.Visible then
    begin
      newviewer := listwinfullviewer;

      listwinfullviewer.ClearViewer;

      pnlfullres.Align := alclient;
      pnlfullres.visible := true;

      if pnlMagListView.Visible then
        self.ListViewShow(true);
      FixFullResPosition;
      //            listwinfullviewer.SetRemember(true); //93t10
      if doesformexist('frmFullRes') then
      begin
        if frmFullRes.Mag4Viewer1.GetImageCount > 0 then
          self.ListWinFullViewer.ImagesToMagView(frmFullRes.Mag4Viewer1.GetImageObjectList);
        frmFullRes.Mag4Viewer1.ClearViewer;
        FullResClose;
      end;
    end;
  end
  else {value = false, so hide local FullRes Viewer}
  begin
    newviewer := nil;
    pnlfullres.Visible := false;
    pnlfullres.Align := alnone;
    splpnlfullres.Align := alnone;
    splpnlfullres.Visible := false;
    FullResWindowOpen;
    if listwinfullViewer.GetImageCount > 0 then
      frmFullRes.Mag4Viewer1.ImagesToMagView(self.ListWinFullViewer.GetImageObjectList);
    if pnlmaglistview.Visible then
      pnlMaglistView.Align := alclient;
  end;

end;

procedure TfrmImageList.FixFullResPosition;
var
  usedh, availh: integer;
  oldpnlmaglistviewH: integer;
begin
  if application.Terminated then
    exit;
  {This isn't complete. the height ListViewPanel in the Image list window
    is sometimes equal to the height of the window, and the full res is visible
      but below the visible area of the ListWindow. }
  if pnlfullres.Visible and pnlMagListView.Visible then
  begin
    self.Constraints.MinHeight := 500;
    availh := pnlMain.Height;
    usedh := pnlmaglistview.Height + splpnlfullres.Height + magviewerTB81.Height;
    while ((availh - usedh < 200)) do
    begin
      oldpnlmaglistviewH := pnlMagListView.Height;
      pnlMagListView.Height := pnlMagListView.Height - 10;
      if pnlMagListView.Height = oldpnlMagListViewH then
      begin
        while ((pnlMagListView.Height + splpnlfullres.Height + MagViewerTB81.Height + 200) >
          pnlMain.height) do
          self.Height := self.Height + 20;
        break;
      end;

      availh := pnlMain.Height;
      usedh := pnlmaglistview.Height + splpnlfullres.Height + magviewerTB81.Height;
    end;
  end
  else
  begin
    self.Constraints.MinHeight := 250;
  end;
  //
end;

procedure TfrmImageList.pnlfullresDockOver(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
begin
  accept := true;
end;

procedure TfrmImageList.mnuListAboutClick(Sender: TObject);
var
  rstat: boolean;
  rlist: Tstringlist;
  magver, vstat: string;
begin
  rlist := Tstringlist.create;
  try
    dmod.MagDBBroker1.RPMaggInstall(rstat, rlist);
    magver := MagGetFileVersionInfo(application.exename);
    dmod.MagDBBroker1.RPMagVersionStatus(vstat, magver);
    frmAbout.execute('', '', rlist, magpiece(vstat, '^', 2));
  finally
    rlist.free;
  end;
end;

procedure TfrmImageList.mnuReports1Click(Sender: TObject);
var
  I: integer;
  templist: Tstrings;
begin
  MagReportMenu.ClearAll;
  templist := tStringlist.create;
  try
    for I := screen.CustomFormCount - 1 downto 0 do
    begin
      if (screen.customforms[i] is TMaggrpcf) then
        {'Report:' is the default caption for a blank form.}
        if (screen.customforms[i].caption <> 'Report:') then
          with Tmaggrpcf(screen.customforms[i]) do
            MagReportMenu.AddItem(caption, inttostr(handle), caption
              + ': ' + pdesc.Caption);
    end;
  finally
    templist.free;
  end;

end;

procedure TfrmImageList.MagListView1Click(Sender: TObject);
begin
  {//117T1  gek add count of checked iamges.}
  {/p117 This could be changed to a test of 'Applicaton State' flag.
  i.e.   if Application State(appstateMultiImagePrint)  then....
          this Applicatio State  idea could be used for skipping Blocked images
          also... it's an idea}
  if self.pnlROIoptions.Visible  then
    begin
     CountCheckedImagesToPrint;
     exit;  {/p117 we're exiting here, because we dont wan't to open an image
                    when a checkbox is checked.}
    end;

  //  if upref.StyleAutoSelect   then

  if MagListView1.HotTrack then
  begin
    //ViewSelectedItemImage;
    CurrentImageOpen();
  end;
end;

procedure TfrmImageList.mnuSyncSelectedImageClick(Sender: TObject);
begin
  //out in 93  FSyncImageON := mnuSyncSelectedImage.Checked;
end;

procedure TfrmImageList.mnuListClick(Sender: TObject);
var
  isvis: boolean;
begin
  isvis := pnlMagListView.Visible;
  mnuShowList.Checked := isvis;

  //fix  mnuListToolbarList.checked := tlbrImageListMain.visible;

  mnuSelectColumns.Enabled := isvis;
  //not 93 mnuSelectColumnSet.Enabled := isvis;
  //not 93 mnuSaveColumnSet.Enabled := isvis;
  mnuFitColToText.Enabled := isvis;
  mnuFitColToWin.Enabled := isvis;
  mnuShowGrid.Enabled := isvis;
  mnuPreviewAbstract.Enabled := isvis;
  mnuPreviewReport.Enabled := isvis;

  mnuShowGrid.Checked := self.MagListView1.GridLines;
  mnuPreviewAbstract.Checked := FAbsPrev;
  mnuPreviewReport.Checked := FPreviewReportIList;

end;

procedure TfrmImageList.View1Click(Sender: TObject);
begin
  if DoesFormexist('frmGroupAbs') then
    mnuGroupwindow1.ENABLED := (frmGroupAbs.FGroupIEN <> '');
end;

procedure TfrmImageList.mnuListToolbarListClick(Sender: TObject);
begin
  pnlMaintoolbar.Visible := mnuListToolbarList.Checked;
  ForceRepaint;
end;

procedure TfrmImageList.mnuImageToolbarClick(Sender: TObject);
begin
  magViewerTB81.Visible := mnuImageToolbar.Checked;
end;

procedure TfrmImageList.mnuVTtreesortbuttonsClick(Sender: TObject);
begin
  pgctrlTreeView.Visible := mnuVTtreesortbuttons.Checked;
end;

procedure TfrmImageList.mnuVTFilterTabsClick(Sender: TObject);
begin
  pnlFilterTabs.visible := mnuVTFilterTabs.Checked;
end;

procedure TfrmImageList.MainToolbarinTree1Click(Sender: TObject);
begin
  pnlmaintoolbar.Visible := false;

  if pnlmaintoolbar.Parent = pnlTree then
  begin
    pnlmaintoolbar.Parent := self;
    pnlFilterTabs.visible := false;
    tabctrlFilters.Top := pnlmaintoolbar.Height + pnlmaintoolbar.Top + 2;
    pnlFilterTabs.visible := true;
  end
  else
  begin
    pnlmaintoolbar.Parent := pnlTree;
  end;

  pnlmaintoolbar.visible := true;
  update;

end;

procedure TfrmImageList.mnuThumbnails1Click(Sender: TObject);
var
  absvis, abswin, abstree, absWindowVisible: boolean;
begin
  abswin := false;
  abstree := false;
  absvis := false;
  if doesformexist('frmMagAbstracts') then
    absWindowVisible := (frmMagAbstracts.Visible)
  else
    absWindowVisible := false;

  mnuThumbsBottom2.Checked := false;
  mnuThumbsLeft2.Checked := false;
  mnuThumbsBottomTree2.Checked := false;
  mnuThumbNailWindow.Checked := false;

  if pnlabs.Parent = pnltree then
    abstree := true;
  if FUseThumbNailWindow then
    abswin := true;
  if pnlabs.Visible then
    absvis := true;
  if (abswin and absWindowVisible) then
    absvis := true;

  if abswin then
    mnuThumbNailWindow.Checked := true;

  mnuShowThumbNail.Checked := absvis;

  if (abstree and (not abswin)) then
    mnuThumbsBottomTree2.Checked := true;

  if (not (abswin) and not (abstree)) then
  begin
    if pnlabs.Align = albottom then
      mnuthumbsbottom2.Checked := true;
    if pnlabs.Align = alleft then
      mnuthumbsleft2.checked := true;
  end;

  mnuThumbsRefresh2.Enabled := mnuShowThumbNail.Checked;

end;

procedure TfrmImageList.OpenMainWinStyleSettings;
begin

end;

procedure TfrmImageList.mnuMessageLogClick(Sender: TObject);
begin
  //maggmsgf.show;  {JK 10/5/2009 - Maggmsgu refactoring - removed old method}
  //maggmsgf.BringToFront; {JK 10/5/2009 - Maggmsgu refactoring - removed old method}
  MagLogger.Show; {JK 10/5/2009 - Maggmsgu refactoring}
end;

procedure TfrmImageList.mnuIconShortCutKeyLegend1Click(Sender: TObject);
begin
  IconShortCutLegend;
end;

procedure TfrmImageList.mnuTreeTabs1Click(Sender: TObject);
begin
  pgctrlTreeView.Visible := mnuTreeTabs1.Checked;
end;

procedure TfrmImageList.mnuToolbarsClick(Sender: TObject);
var
  intree, vis: boolean;
begin
  intree := (pnlmaintoolbar.Parent = pnlTree);
  vis := pnlmaintoolbar.Visible;

  mnulisttoolbarlist.Enabled := (not intree);
  mnuListToolbarList.Checked := ((not intree) and vis);
  mnuImageToolbar.Checked := self.magViewerTB81.Visible;
  mnuVTtreesortbuttons.Checked := pgctrlTreeView.Visible;
  mnuVTFilterTabs.Checked := pnlFilterTabs.visible;

  if not pnltree.Visible then
  begin
    MainToolbarinTree1.Checked := false;
    MainToolbarinTree1.Enabled := false;
  end
  else
  begin
    MainToolbarinTree1.Enabled := true;
    MainToolbarinTree1.Checked := (intree and vis);
  end;

end;

procedure TfrmImageList.MagSubscriber1SubscriberUpdate(newsObj: TMagNewsObject);
var
  vIobj: TImageData;
  s: string;
begin
{$IFDEF TESTMESSAGES}
  s := newsObj.NewsStrValue + '  ' + inttostr(newsobj.NewsCode);
  {JK 2/4/2009 - Fixes D69 by adding a check for nil}
  if newsobj.NewsChangeObj <> nil then
    if (newsobj.NewsChangeObj is TImageData) then
      s := s + ' TImageData  ' + TImageData(newsobj.NewsChangeObj).Mag0;
  if newsobj.NewsInitiater <> nil then
  begin
    if (newsobj.NewsInitiater is TMagListView) then
      s := s + ' TMaglistView ' + TMagListView(newsobj.NewsInitiater).Name;
    if (newsobj.NewsInitiater is TMag4Viewer) then
      s := s + ' TMag4Viewer ' + TMag4Viewer(newsobj.NewsInitiater).Name;
    if (newsobj.NewsInitiater is TMagTreeView) then
      s := s + ' TMagTreeView ' + TMagTreeView(newsobj.NewsInitiater).Name;
  end;
  maggmsgf.magmsg('s', s);
{$ENDIF}
  { newscodes for TmagNewsObject
mpubPatientSelected = 1000;
mpubImageSelected = 2000;
mpubImageStateChange = 2001;
mpubImageStatusChange = 2002;
mpubImageUnSelectAll = 2003;  }

  case NewsObj.NewsCode of
    mpubImageUnSelectAll:
      begin
        // Here need to make all selected = null
        self.ListWinAbsViewer.UnSelectAll;
        self.ListWinFullViewer.UnSelectAll;
        self.MagTreeView1.ClearSelection;
        self.MagListView1.ClearSelection; // Selected := nil;
        if doesformexist('frmFullRes') then
          if frmFullRes.Visible then
            frmFullRes.Mag4Viewer1.UnSelectAll;
        if doesformexist('frmMagAbstracts') then
          if frmMagAbstracts.Visible then
            frmMagAbstracts.Mag4Viewer1.UnSelectAll;
        if doesformexist('frmGroupAbs') then
          if frmGroupAbs.Visible then
            frmGroupAbs.Mag4Viewer1.UnSelectAll;
{$IFDEF testmessages}
        winmsg(umagdefinitions.mmsglistwin, 'Fimagelistsyncprocessing: ' + magbooltostr(Fimagelistsyncprocessing));
{$ENDIF}
        SetCurSelectedImageObj(nil); {TfrmImageList.MagSubscriber1SubscriberUpdate}
        winmsg(mmsglistwin, '');
      end;
    mpubImageSelected:
      begin
        if Fimagelistsyncprocessing then
        begin
          winmsg(1, 'FImageListSyncProcessing = true, exiting SubScribe event');
          exit;
        end;
        try
          Fimagelistsyncprocessing := true;
          vIobj := TImageData(NewsObj.NewsChangeObj);
          winmsg(mmsglistwin, 'Image Selected: ' + vIobj.ExpandedDescription(false));  //In Subscribe:
{$IFDEF testmessages}
          winmsg(umagdefinitions.mmsglistwin, 'Fimagelistsyncprocessing: ' + magbooltostr(Fimagelistsyncprocessing));
{$ENDIF}
          SetCurSelectedImageObj(vIObj); {TfrmImageList.MagSubscriber1SubscriberUpdate}
          if vIobj = nil then
            exit;
          if newsobj.NewsInitiater <> MagTreeView1 then
            MagTreeView1.SyncWithImage(viobj);
          TestMsg('After MagTreeView1.sync...');
          application.ProcessMessages;
          if newsobj.NewsInitiater <> self.MagListView1 then
            self.MagListView1.SyncWithImage(vIobj);
          TestMsg('After MagListView1.sync...');
          application.ProcessMessages;
          if newsobj.NewsInitiater <> ListWinAbsViewer then
            ListWinAbsViewer.SyncWithIMage(vIobj);
          TestMsg('After ListWinAbsViewer.sync...');
          application.ProcessMessages;
          if newsobj.NewsInitiater <> ListWinFullViewer then
            ListWinFullViewer.SyncWithIMage(vIobj);
          TestMsg('After ListWinFullViewer.sync...');
          application.ProcessMessages;
          if doesformexist('frmMagAbstracts') then
          begin
            if frmMagAbstracts.Visible then
            begin
              if newsobj.NewsInitiater <> frmMagAbstracts.Mag4Viewer1 then
                frmMagAbstracts.Mag4Viewer1.SyncWithIMage(vIobj);
              TestMsg('After frmMagAbstracts.sync...');
              application.ProcessMessages;
            end;
          end;
          if doesformexist('frmFullRes') then
          begin
            if frmFullRes.Visible then
            begin
              if newsobj.NewsInitiater <> frmFullRes.Mag4Viewer1 then
                frmFullRes.Mag4Viewer1.SyncWithIMage(vIobj);
              TestMsg('After frmFullRes.sync...');
              application.ProcessMessages;
            end;
          end;
          if doesformexist('frmGroupAbs') then
          begin
            if newsobj.NewsInitiater <> frmGroupAbs.Mag4Viewer1 then
              frmGroupAbs.Mag4Viewer1.SyncWithIMage(vIobj, false);
          end;
        finally
          Fimagelistsyncprocessing := false;
        end;
      end;

  end;
end;

procedure TfrmImageList.SyncAllWithCurrent();
var
  vIobj: TImageData;
begin
  if Fimagelistsyncprocessing then
    exit;
  try
    Fimagelistsyncprocessing := true;
    {   pubstPatientSelected = 1000;
        pubstImageSelected = 2000;
        pubstImageStateChange = 2001;
        pubstImageStatusChange = 2002;
        pubstRIVImage  =  3000;    }

    vIobj := FCurSelectedImageObj;

    if vIobj = nil then
      exit;
    MagTreeView1.SyncWithImage(viobj);
    TestMsg('After MagTreeView1.sync...');
    application.ProcessMessages;
    MagListView1.SyncWithImage(vIobj);
    TestMsg('After MagListView1.sync...');
    application.ProcessMessages;
    ListWinAbsViewer.SyncWithIMage(vIobj);
    TestMsg('After ListWinAbsViewer.sync...');
    application.ProcessMessages;
    ListWinFullViewer.SyncWithIMage(vIobj);
    TestMsg('After ListWinFullViewer.sync...');
    application.ProcessMessages;
    if doesformexist('frmMagAbstracts') then
    begin
      if frmMagAbstracts.Visible then
      begin
        frmMagAbstracts.Mag4Viewer1.SyncWithIMage(vIobj);
        TestMsg('After frmMagAbstracts.sync...');
        application.ProcessMessages;
      end;
    end;
    if doesformexist('frmFullRes') then
    begin
      if frmFullRes.Visible then
      begin
        frmFullRes.Mag4Viewer1.SyncWithIMage(vIobj);
        TestMsg('After frmFullRes.sync...');
        application.ProcessMessages;
      end;
    end;
    if doesformexist('frmGroupAbs') then
    begin
      frmGroupAbs.Mag4Viewer1.SyncWithIMage(vIobj, false);
    end;

  finally
    Fimagelistsyncprocessing := false;
  end;
end;

procedure TfrmImageList.TestMsg(value: string);
begin
{$IFDEF TESTMESSAGES}
  maggmsgf.magmsg('', value);
{$ENDIF}
end;

procedure TfrmImageList.ConfigureUserPreferences1Click(Sender: TObject);
begin
  OpenUserPrefs;
end;

procedure TfrmImageList.OpenUserPrefs;
begin
  { TODO : Change this method to an Execute Method of the UserPref window
                  and call UserPref.Execute }
  application.CreateForm(TfrmUserPref, frmUserPref);
  with frmUserPref do
  begin
    upreftoUprefwindow(upref);
    showmodal;
    UprefWindowSettingsToUpref(upref);
    ApplyFromUprefWindow;
    free;
  end;
  LOGACTIONS('MAIN', 'UPREF', DUZ);
end;

procedure TfrmImageList.ApplyFromUprefWindow;
var
  FAdminOnly: boolean;
  vautoselect: boolean;
  autospeed: integer;
  li: Tlistitem;
begin
  { TODO 1 -oGarrett -c93 :  This needs going over in Relation to ABSTRACTS,.....  and all others should
     be tested. }

  FAdminOnly := (not UserHasKey('MAGDISP CLIN'));
  if not FAdminOnly then
  begin
    upref.showmuse := frmUserPref.cbShowMUSE.Checked;
    upref.shownotes := frmUserPref.cbShowNotes.Checked;
    upref.showRadListWin := frmUserPref.cbShowRadListwin.Checked;
  end;
  SetAbsPreview(frmUserPref.cbPreviewThumbnail.Checked);
  SetRptPreview(frmUserPref.cbPreviewReport.checked);

  with frmUserPref do
  begin
    //  if cbshowabswindow.checked
    // then upref.StyleWhereToShowAbs := 1
    // else upref.StyleWhereToShowAbs := 0;
    if cbShowThumbs.Checked then
    begin
      upref.StyleWhetherToShowAbs := 1; {0 no show,  1 show}
      case rgrpThumbs.ItemIndex of
        0:
          begin
            upref.AbsShowWindow := false;
            { it now says Abs Window, we need to change to List Win}
            {we'll default to 0; 0 Left, 1 bottom, 2 in Tree, 3 Abs Window }
            if upref.StylePositionOfAbs = 3 then
              upref.StylePositionOfAbs := 0;
          end;
        1:
          begin
            upref.AbsShowWindow := true;
            upref.StylePositionOfAbs := 3;
          end;
      end; {case}
    end
    else
    begin
      upref.StyleWhetherToShowAbs := 0; {0 no show,  1 show}
      upref.AbsShowWindow := false;
    end;

    vAutoSelect := cbAutoSelect.Checked;
    //fix    upref.StyleAutoSelect := vAutoSelect;
    MagListView1.HotTrack := vAutoSelect;
    MagTreeView1.AutoSelect := vAutoSelect;
    autoSpeed := frmUserPref.rgrpAutoSpeed.ItemIndex;
    case AutoSpeed of
      0:
        begin
          MagListView1.HoverTime := 750;
          self.timerSyncTimer.Interval := 750;
        end;
      1:
        begin
          MagListView1.HoverTime := 500;
          self.timerSyncTimer.Interval := 500;
        end;
      2:
        begin
          MagListView1.HoverTime := 250;
          self.timerSyncTimer.Interval := 250;
        end;
    end;
    ListViewShow(cbShowList.checked);
    if cbShowList.Checked then
      { TODO -c93+ : NEED TO GET RID OF THE DEPENDENCY OF Preview Abs and Preview REport on the Image List Window.... }
    begin
      li := MagListView1.Selected;
      if li <> nil then
      begin
        PreviewAbs(li);
        PreviewRpt(li);
      end;
    end;

    if cbShowTree.checked then
      TreeShow
    else
      TreeHide;
    //FSyncImageON := cbSyncSelection.Checked;
    FSyncImageOn := true; //93 we are not giving the user a choice. now
    //93      keep this to always True.
    case rgrpImages.ItemIndex of
      0:
        begin
          newviewer := listwinfullviewer;
          FullResLocalShow(true);
          FullResClose;
        end;
      1:
        begin
          newviewer := nil;
          FullResLocalShow(false);
          FullResWindowOpen;
        end;
    end;
    { Where are abstracts to be Shown, if anywhere }
    if cbShowThumbs.Checked then {ApplyFromUprefWindow}
    begin
      case rgrpThumbs.ItemIndex of {ApplyFromUprefWindow}
        0:
          begin
            AbThmUseThumbNailWindow(false);
            AbThmShowThm;
            //ShowHideThumbNails(true);
          end;
        1:
          begin
            AbThmUseThumbNailWindow(true); {ApplyFromUprefWindow}
            AbThmHideThm;
            //ShowHideThumbNails(false);
          end;
      end; {end Case}
      tbtnAbstracts.Down := true;
    end
    else {so... ShowThubms is not checked.}
    begin {Here we hide both Thumbnail viewers.}
      AbThmUseThumbNailWindow(false);
      AbThmHideThm;
      tbtnAbstracts.Down := false;
    end;
  end; {with frmUserPref}

end;

procedure TfrmImageList.mnuWorkstationConfigurationwindow1Click(Sender:
  TObject);
begin
  // P8t35
  if MagWrksf.Execute(GetConfigFileName) then //ApplyWorkstationSettings;

    //old  Executefile('magwrks.exe', 'letsdoit', apppath, SW_Show);
end;

procedure TfrmImageList.mnu_ShowUrlMapClick(Sender: TObject);
begin
  if frmURLMemoryMapViewer = nil then
    frmURLMemoryMapViewer := TfrmURLMemoryMapViewer.Create(Self);
  frmURLMemoryMapViewer.Execute(MagImageList1);
//  frmURLMemoryMapViewer.Show;
end;

procedure TfrmImageList.mnuClearCurrentPatient1Click(Sender: TObject);
begin
  dmod.MagPat1.Clear;
  ClearImageInfoControl;
end;

procedure TfrmImageList.mnuImageFileNetSecurityON1Click(Sender: TObject);
begin

  Dmod.MagFileSecurity.SecurityOn := mnuImageFileNetSecurityON1.checked;
  winmsg(mmsglistwin, '**Imaging Network Security is on : ' +
    magbooltostr(mnuImageFileNetSecurityON1.checked));
end;

procedure TfrmImageList.mnuManagerClick(Sender: TObject);
begin
  mnuImageFileNetSecurityON1.checked := Dmod.MagFileSecurity.SecurityOn;
end;

procedure TfrmImageList.mnuShowMessagesfromlastOpenSecureFileCall1Click(Sender:
  TObject);
begin
  LogSecurityMsgs;
  //maggmsgf.show;  {JK 10/5/2009 - Maggmsgu refactoring - removed old method}
  MagLogger.Show; {JK 10/5/2009 - Maggmsgu refactoring}
end;

procedure TfrmImageList.LogSecurityMsgs;
var
  I: integer;
begin
  for i := 0 to Dmod.MagFileSecurity.msglist.count - 1 do
    //Maggmsgf.magmsg('s', Dmod.MagFileSecurity.msglist[i]);
    MagLogger.MagMsg('s', Dmod.MagFileSecurity.msglist[i]);
  {JK 10/5/2009 - Maggmsgu refactoring}
end;

procedure TfrmImageList.mnuChangeTimeoutvalue1Click(Sender: TObject);
begin
  MagTimeoutform.SetApplicationTimeOut('', frmMain.timerTimeout);
end;

procedure TfrmImageList.mnuPatientLookupLoginEnabled1Click(Sender: TObject);
begin
  frmmain.mainEnablePatientLookupLogin(mnuPatientLookupLoginEnabled1.Checked);
end;

procedure TfrmImageList.mnuSetWorkstationsAlternateVideoViewer1Click(Sender:
  TObject);
var
  altviewer: string;
  magini: Tinifile;
begin
  OpenDialogListWin.FilterIndex := 3;
  magini := tinifile.create(GetConfigFileName);
  try
    altviewer := magini.readstring('Workstation settings',
      'Alternate Video Viewer', '');
    if altviewer <> '' then
    begin
      OpenDialogListWin.filename := altviewer;
      OpenDialogListWin.initialDir := ExtractFilePath(altviewer);
    end
    else
      OpenDialogListWin.InitialDir := MagGetWindowsDirectory;
    if OpenDialogListWin.execute then
    begin
      altviewer := OpenDialogListWin.FileName;
      magini.writestring('Workstation settings', 'Alternate Video Viewer',
        altviewer);
    end;
  finally
    magini.free;
  end;
end;

procedure TfrmImageList.mnuCPRSSyncOptions1Click(Sender: TObject);
begin
  GetCPRSLinkOptions(CPRSSync);
  if not CPRSSync.SyncOn then
  begin
    if MagSyncCPRSf.VerifyBreakCPRSLink then
      frmMain.mainEnablePatientLookupLogin(true)
    else
      CPRSSync.SyncOn := true;
  end;
end;

procedure TfrmImageList.SaveSettingsNow1Click(Sender: TObject);
begin
  frmmain.saveusersettings;
end;

procedure TfrmImageList.mnuSaveSettingsonExit1Click(Sender: TObject);
begin
  {this menu is AutoChecked, we also need to check the frmMain menu}
  frmMain.mnuSaveSettingsonExit.checked := mnuSaveSettingsOnExit1.checked;
end;

procedure TfrmImageList.RemoteImageViewsConfiguration1Click(Sender: TObject);
//var
//configForm : TfrmMagRIVUserConfig;
begin
  // Out in 93.  We don't want the Configuration window dependant on Toolbar.
  //  not out in 93, the toolbar is too tied to the remote functions.
  RIVNotifyAllListeners(self, 'ShowConfiguration', '');

  (*  configForm := TfrmMagRIVUserConfig.Create(self);
    configForm.Execute(RemoteSites);//, RIVAutoConnectEnabled, ConnectVISNOnly, FHideEmptySites, FHideDisconnectedSites);
    freeandnil(configForm);
    *)
  {
    configForm.Destroy();
    configForm := nil;
    }
end;

procedure TfrmImageList.mnuShowHints1Click(Sender: TObject);
begin
  ShowHintsonThiswindow1.Checked := self.ShowHint;
end;

procedure TfrmImageList.ShowHintsonThiswindow1Click(Sender: TObject);
begin
  self.ShowHint := ShowHintsonThiswindow1.Checked;

  // removed from ImageList Popup menu.
  //  mnuShowHints2.checked := not mnuShowHints2.checked;
  //  frmImageList.ShowHint := mnuShowHints2.checked;

end;

procedure TfrmImageList.HintsOFFforallwindows1Click(Sender: TObject);
begin
  SetAllHintsOn(false);
end;

{  We could make this more generic, by searching for Tmag4Viewer...
   We wouldn't need to know the specifics about individual forms.}

procedure TfrmImageList.SetAllHintsOn(value: boolean = true);
var
  I: integer;
  dval: string;
begin
  if value then
    dval := 'On'
  else
    dval := 'Off';
  for I := screen.CustomFormCount - 1 downto 0 do
  begin
    screen.customforms[i].showhint := value;
  end;

  winmsg(mmsglistwin, 'Hints are ' + dval + ' for all windows');
  if DoesFormExist('frmGroupAbs') then
    frmGroupAbs.Mag4Viewer1.ShowHints(value);
  if DoesFormExist('frmMagAbstracts') then
    frmMagAbstracts.Mag4Viewer1.ShowHints(value);
  if DoesFormExist('frmFullRes') then
    frmFullRes.Mag4Viewer1.ShowHints(value);
end;

(*
procedure TfrmMain.mnuTurnHintsOFFforallwindowsClick(Sender: TObject);
var I: integer;
begin
  for I := screen.CustomFormCount - 1 downto 0 do
  begin
    screen.customforms[i].showhint := false;
  end;
  WinMsg('', 'Hints are OFF for all windows');
  if DoesFormExist('frmGroupAbs') then frmGroupAbs.Mag4Viewer1.ShowHints(false);
  if DoesFormExist('frmMagAbstracts') then frmMagAbstracts.Mag4Viewer1.ShowHints(false);
  if DoesFormExist('frmFullRes') then frmFullRes.Mag4Viewer1.ShowHints(false);
end;

{  This is also not good, instead of having to know about specific forms,
    we could try looping through all forms of TMagForm (descendant of Tform) and
    call the TMagForms SetHint method.  We wouldn't need to know the specifics
    about individule forms.}

procedure TfrmMain.mnuTurnHintsONforallwindowsClick(Sender: TObject);
var I: integer;
begin
  for I := screen.CustomFormCount - 1 downto 0 do
  begin
    screen.customforms[i].showhint := true;
  end;
  WinMsg('', 'Hints are ON for all windows');
  if DoesFormExist('frmGroupAbs') then frmGroupAbs.Mag4Viewer1.ShowHints(true);
  if DoesFormExist('frmMagAbstracts') then frmMagAbstracts.Mag4Viewer1.ShowHints(true);
  if DoesFormExist('frmFullRes') then
  begin
    frmFullRes.Mag4Viewer1.ShowHints(true);
    frmFullRes.magViewerTB1.ShowHint := true;
  end;
end;

*)

procedure TfrmImageList.HintsONforallwindows1Click(Sender: TObject);
begin
  SetAllHintsOn();
end;



procedure TfrmImageList.btnFilterImageListClick(Sender: TObject);
begin
  //if maglistview1.Parent = pnlMagListView then
  //  begin
  //  maglistview1.Parent := self;
  //  maglistview1.Top :=

  (*if lvFilterImages.Visible
    then
    begin
    lvFilterImages.Visible := false;
    lvFilterImages.Clear;
    end
    else
    begin
    LoadFilterImageList;
    lvFilterImages.Visible :=true;
    end;
    *)
end;
{/117T1  gek.}
procedure TfrmImageList.btnContinueToROIPrintWindowClick(Sender: TObject);
var i,ct : integer;
begin
ct := 0;
if   maglistview1.Checkboxes  then
  begin
    //
    for I := 0 to maglistview1.Items.Count - 1 do if maglistview1.items[i].Checked then inc(ct);
    if ct=0  then
       begin
       messagedlg('No images are checked.  Check the images that you want to print',mtconfirmation,[mbOK],0);
       end
       else
       begin
       { The user has checked some images, and we will continue to the ROI Print
         window to print only the checked images}
       winmsg(mmsglistwin, 'ROI Print initializing.');
       frmReleaseOfInfoPrint.Execute(true, MagListView1, self.FCurrentFilter, upref); //*** BB 08/24/2010 ***

       end;
  end
  else
  begin
    //
  end;
end;

procedure TfrmImageList.LoadFilterImageList;
var
  i: integer;
begin
  (*lvFilterImages.Clear;
  lvFilterImages.Items.Assign(maglistview1.Items);
  for I := 0 to magimagelist1.Objlist.Count - 1 do
    begin
  //  showmessage(TImageDAta(magimagelist1.Objlist).ImgDes);
  //  lvFilterImages.Items.Add(TImageData(magimagelist1.objlist[i]).ImgDes);
    end;  *)
end;

procedure TfrmImageList.mnuAutoExpandCollapseClick(Sender: TObject);
begin
  magtreeview1.AutoExpand := mnuAutoExpandCollapse.Checked;
end;

procedure TfrmImageList.FormPaint(Sender: TObject);
begin
  // setting it here, stops the resize being called when the form is created.
  //from abswindow => //  if not assigned(onresize) then onresize := ResizeAllImages;
  if not assigned(pnlAbs.onresize) then
    pnlabs.OnResize := ResizeAllImages;
  if not assigned(pnlfullres.onresize) then
    pnlfullres.OnResize := ResizeAllImages;
end;

procedure TfrmImageList.FormHide(Sender: TObject);
begin
  if not frmMain.Visible then
    frmMain.Show;
end;

procedure TfrmImageList.Color1Click(Sender: TObject);
begin
  if ColorDialog1.execute then
  begin
    self.Color := self.ColorDialog1.Color;
    FSAppBackGroundColor := self.Color;
  end;
end;

procedure TfrmImageList.mnuShowContext1Click(Sender: TObject);
begin
  dmod.CCOWManager.ShowContextData;
  //if not (maggmsgf.Visible) then  {JK 10/5/2009 - Maggmsgu refactoring - removed old method}
  //    maggmsgf.Visible := true;   {JK 10/5/2009 - Maggmsgu refactoring - removed old method}
  // make the System messages scroll to the bottom to show the CCOW
  // context information
  //maggmsgf.sysmemo.SelStart := length(maggmsgf.sysmemo.Text); {JK 10/5/2009 - Maggmsgu refactoring - removed old method}
  //maggmsgf.sysmemo.SelLength := 0;  {JK 10/5/2009 - Maggmsgu refactoring - removed old method}
end;

procedure TfrmImageList.mnuSuspendContext1Click(Sender: TObject);
begin
  dmod.CCOWManager.SuspendContextLink;
  CPRSSync.SyncOn := false;
  // JMW 2/3/2006 p46, turn off sync (to not listen to any windows messages)

end;

procedure TfrmImageList.mnuResumeGetContext1Click(Sender: TObject);
begin
  dmod.CCOWManager.ResumeGetContext;
end;

procedure TfrmImageList.mnuResumeSetContext1Click(Sender: TObject);
begin
  dmod.CCOWManager.ResumeSetContext;
end;

procedure TfrmImageList.mnuListContextClick(Sender: TObject);
var
  ccowstr: string;
  ccowint: integer;
begin
  //  if (sender = dmod.CCOWManager) then
  //  begin
  //    CCOWState := byte(StrToInt(SubjectState));
  //ccowstate := dmod.CCOWManager.
  dmod.CCOWManager.GetState_(ccowstr);
  ccowint := strtoint(ccowstr);
  pnlContext.Visible := ccowint > 0;
  imgCCOWLink1.Visible := ccowint = 1;
  imgCCOWchanging1.Visible := ccowint = 2;
  imgCCOWbroken1.Visible := ccowint = 3;
  //   mnuContext.Visible := ccowint > 0;
  mnuShowContext1.Enabled := ccowint = 1;
  mnuSuspendContext1.Enabled := ccowint = 1;
  mnuResumeGetContext1.Enabled := ccowint = 3;
  mnuResumeSetContext1.Enabled := ccowint = 3;
  //    exit;
  //  end;
end;

procedure TfrmImageList.mnuGroupWindow1Click(Sender: TObject);
begin
  formtonormalsize(frmGroupAbs);
end;

procedure TfrmImageList.mnuMUSEEKGlistILClick(Sender: TObject);
begin
  frmMain.ShowEKGWindow;
end;

procedure TfrmImageList.mnuPrefetch1Click(Sender: TObject);
begin
  PrefetchPatientImages;
end;

procedure TfrmImageList.mnuRadiologyExams1Click(Sender: TObject);
begin
  frmmain.LoadRadListWin;
end;

procedure TfrmImageList.mnuProgressNotes1Click(Sender: TObject);
begin
  MagTIUWinf.SetPatientName(dMod.MagPat1.M_DFN, dMod.MagPat1.M_NameDisplay);
  MagTIUWinf.GetNotes;
  FormToNormalSize(MagTIUWinf);
  MagTIUWinf.show;
end;

procedure TfrmImageList.mnuClinicalProcedures1Click(Sender: TObject);
begin
  MagTIUWinf.SetPatientName(dMod.MagPat1.M_DFN, dMod.MagPat1.M_NameDisplay);
  MagTIUWinf.GetClinicalProcedures;
  FormToNormalSize(MagTIUWinf);
  MagTIUWinf.show;
end;

procedure TfrmImageList.mnuConsults1Click(Sender: TObject);
begin
  MagTIUWinf.SetPatientName(dMod.MagPat1.M_DFN, dMod.MagPat1.M_NameDisplay);
  MagTIUWinf.GetConsults;
  FormToNormalSize(MagTIUWinf);
  MagTIUWinf.show;
end;

procedure TfrmImageList.mnuRemoteConnections1Click(Sender: TObject);
begin
  fMagRemoteToolbar1.Visible := mnuRemoteConnections1.Checked;
end;

procedure TfrmImageList.mnuSelectColumnSetClick(Sender: TObject);
var
  value: string;
begin
  value := ColumnSetGet(self.MagListView1);
  {JK 1/6/2009 - Fixes D42}
  if value <> '' then
  begin
    ColumnSetApply(Self.MagListView1, value);
    Self.MagListView1.FitColumnsToForm;
  end;
end;

procedure TfrmImageList.mnuSaveColumnSetClick(Sender: TObject);
begin
  ColumnSetSave(Self.MagListView1);
end;

procedure TfrmImageList.ListWinAbsViewerDragOver(Sender, Source: TObject;
  X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  if (source is Tlistview) then
  begin
    if (source as Tlistview).Name = 'lvImageInfo' then
    begin
      accept := true;
    end;
  end;
end;

procedure TfrmImageList.ListWinAbsViewerDragDrop(Sender, Source: TObject;
  X, Y: Integer);
begin
  if (source is Tlistview) then
  begin
    if (source as Tlistview).Name = 'lvImageInfo' then
    begin
      lvimageinfo.visible := false;
      lvimageinfo.Parent := pnlAbs;
      lvimageinfo.top := pnlabs.Height div 3;
      lvimageinfo.Align := albottom;
      lvimageinfo.Show;

    end;
  end;

end;

{JK 1/6/2009 - Generalized this routine and fixes D19;}
{GEK 5/4/2009  Decouple this function from the Image List window and TmagListView component
               we need the Edit function callable from anywhere }

procedure TfrmImageList.CurrentImageIndexEdit;
var
  vresult: boolean;
  i: integer;
  Iobj: TImageData;
  magienlist: Tstrings;
  rmsg: string;
begin
  try
    if not Dmod.MagDBBroker1.IsConnected then
      raise exception.Create('You need to Login to VistA.');
    if FcurSelectedImageObj = nil then
      raise exception.Create('You need to select an Image.');
    if FcurSelectedImageObj.Mag0 = '' then
      raise exception.Create('Image IEN is invalid');

    {/ P117 - JK 9/7/2010 - Check for if the image has been deleted /}
    if FcurSelectedImageObj.IsImageDeleted then
      MagLogger.LogMsg('DI', FcurSelectedImageObj.GetViewStatusMsg, MagLogINFO)
    else
    begin

      if not IsThisImageLocaltoDB(FCurSelectedImageObj, dmod.MagDBBroker1, rmsg) then

        // if ((FCurSelectedImageObj.ServerName <> dmod.MagDBBroker1.GetServer)
         //    or (FCurSelectedImageObj.ServerPort <> dmod.MagDBBroker1.GetListenerPort)) then
        raise exception.Create('You cannot edit an Image from a Remote Site.');

      //rlist := Tstringlist.create;
     // t := Tstringlist.create;
      magienlist := tstringlist.create;
      magienlist.Add(FcurSelectedImageObj.Mag0);
      if frmIndexEdit.Execute(dmod.MagDBBroker1, FCurSelectedImageObj, rmsg) then
      begin
        //Success.
  // How to Refresh the current Filter.
  (*93 we are deciding ... do we update the list on each edit, or
  just mark it as 'needing refresh'  and let the user do it.*)
  //UpdateFilteredList;
  //  OR JUST mark as needs refreshed , like the Verify Window
  //ListView.ImageStatusChange(Iobj, umagdefinitions.mistNeedsRefresh);
        MagListView1.ImageStateChange(FCurSelectedImageObj, umagdefinitions.mistateNeedsRefresh);
        MagTreeView1.ImageStateChange(FCurSelectedImageObj, umagdefinitions.mistateNeedsRefresh);
      end;
      winmsg(mmsglistwin, rmsg);
      //maggmsgf.MagMsg('', rmsg);
      MagLogger.MagMsg('', rmsg); {JK 10/5/2009 - Maggmsgu refactoring}
    end;
  except
    on e: exception do
    begin
      //maggmsgf.MagMsg('dI', e.Message);
      MagLogger.MagMsg('dI', E.Message); {JK 10/5/2009 - Maggmsgu refactoring}
    end;
  end;
end;


(*  {/p117 take this out,  so we don't get confused.  This is call that was moved to
     ImageINdex window.}
procedure TfrmImageList.ImageIndexEdit(ListView: TMagListView; var editresult: boolean);
//(var rstat: boolean;  var rmsg: string;  var rlist: tstrings; ien,params : string);
var
  magien: string;
  rlist, t: Tstrings;
  magienlist: Tstrings;
  Iobj: TImageData;
  chngct, i: integer;
  Rmsg, ctmsg, chmsg: string;
  Rstat: boolean;
  flgs: string;
  flds: string;
  IIndexObj: TimageIndexValues;
begin
  editresult := false;
  chngct := 0;
  try
    if not Dmod.MagDBBroker1.IsConnected then
      raise exception.Create('You need to Login to VistA.');
    if ListView.SelCount = 0 then
      raise exception.Create('You need to select an Image.');

    rlist := Tstringlist.create;
    t := Tstringlist.create;
    magienlist := tstringlist.create;
    IIndexObj := TimageIndexValues.create;

    IObj := nil;
    try
      for i := 0 to ListView.Items.Count - 1 do
      begin
        if ListView.Items[i].Selected then
        begin
          { TODO : FIX THIS.  This is a cludge to get the Iobj. to use ImageDescription function. }
          Iobj := (TmagListViewData(ListView.items[i].data).Iobj);
          magienlist.add((TmagListViewData(ListView.items[i].data).Iobj).mag0);
          break;
          // Iobj := (TmagListViewData(maglistview1.items[i].data).Iobj);
          // magienlist.Add(iobj.Mag0);
        end;
      end;

      if magienlist.Count > 0 then
      begin
        //OneEntryEdit(magienlist[0])
        //oldprototype  dmod.MagDBBroker1.RPMag4FieldValueGet(rstat,rmsg,rlist,magienlist[0],'IENR','10;40:45');
        //93
        //  dmod.MagDBBroker1.RPMag4FieldValueGet(rstat,rmsg,rlist,magienlist[0],'IENR','10;40:45');

        //HERE
        dmod.MagDBBroker1.RPMaggImageGetProperties(rstat, rmsg, rlist,
          magienlist[0], '*');
        rlist.Delete(0); //  do we need to test for   '0^...' }
        //// This is OLD procedure.  IT's moved to ImageEdit Form.              ListToIValObj(rlist, IIndexObj);
        IIndexObj.ImageDescription :=
          Iobj.ExpandedIdDateDescription(false);
        IIndexObj.ImageIEN := Iobj.Mag0;
        IIndexObj.Patient := Iobj.PtName;
        rstat := false;
        rmsg := '';
        rlist.clear;

        if magienlist.count > 1 then
          ctmsg := inttostr(magienlist.count) + ' Selected Images.'
        else
          ctmsg := ' Selected Image.';

        { Both of the next two lines do same thing.  DBBroker is generic.}
        {  if frmIndexEdit.execute(IIndexObj,dmod.MagDBMVista1,ctmsg) then  }
        chmsg := #13 + #13;

        /// frmIndex Edit has been modified, not called like this now...      if frmIndexEdit.Execute(IIndexObj, dmod.MagDBBroker1, ctmsg, Iobj) then
        if true then
        begin
          { TODO -ogarrett -cindex edit : add new fields for index edit }
          if (IIndexObj.TypeIndex.Ext <> '<no change>') and
            (IIndexObj.TypeIndex.Ext <> '') then
          begin
            inc(chngct);
            t.add('IXTYPE^^' + IIndexObj.TypeIndex.Ext);
            chmsg := chmsg + #13 + 'Type:                 ' +
              IIndexObj.TypeIndex.Ext;
          end;
          {  Only Spec and Proc properties can be deleted.}
          if (IIndexObj.ProcEventIndex.Ext <> '<no change>') then
          begin
            inc(chngct);
            if IIndexObj.ProcEventIndex.Ext = '<delete>' then
            begin
              IIndexObj.ProcEventIndex.Ext := '@';
              t.add('IXPROC^^' + IIndexObj.ProcEventIndex.Ext);
              chmsg := chmsg + #13 + 'Proc/Event:     Delete.';
            end
            else
            begin
              t.add('IXPROC^^' + IIndexObj.ProcEventIndex.Ext);
              chmsg := chmsg + #13 + 'Proc/Event:       ' +
                IIndexObj.ProcEventIndex.Ext;
            end;
          end;
          if (IIndexObj.SpecSubSpecIndex.Ext <> '<no change>') then
          begin
            inc(chngct);
            if IIndexObj.SpecSubSpecIndex.Ext = '<delete>' then
            begin
              IIndexObj.SpecSubSpecIndex.Ext := '@';
              t.add('IXSPEC^^' + IIndexObj.SpecSubSpecIndex.Ext);
              chmsg := chmsg + #13 + 'Spec/SubSpec:     Delete.';
            end
            else
            begin
              t.add('IXSPEC^^' + IIndexObj.SpecSubSpecIndex.Ext);
              chmsg := chmsg + #13 + 'Spec/SubSpec:  ' +
                IIndexObj.SpecSubSpecIndex.Ext;
            end;
          end;

          if (IIndexObj.OriginIndex.Ext <> '<no change>') and
            (IIndexObj.OriginIndex.Ext <> '') then
          begin
            inc(chngct);
            t.add('IXORIGIN^^' + IIndexObj.OriginIndex.Ext);
            chmsg := chmsg + #13 + 'Origin:                ' +
              IIndexObj.OriginIndex.Ext;
          end;
          if (IIndexObj.ShortDesc.Ext <> '<no change>') and
            (IIndexObj.ShortDesc.Ext <> '') then
          begin
            inc(chngct);
            t.add('GDESC^^' + IIndexObj.ShortDesc.Ext);
            chmsg := chmsg + #13 + 'Desc:                 ' +
              IIndexObj.ShortDesc.Ext;
          end;
          if (IIndexObj.Controlled.Ext <> '<no change>') and
            (IIndexObj.Controlled.Ext <> '') then
            //93 new fields    {Controlled Status StatusReason ImageCreationDate}
          begin
            inc(chngct);
            t.add('SENSIMG^^' + IIndexObj.Controlled.Ext);
            chmsg := chmsg + #13 + 'Controlled:           ' +
              IIndexObj.Controlled.Ext;
          end;
          if (IIndexObj.Status.Ext <> '<no change>') and
            (IIndexObj.Status.Ext <> '') then
          begin
            inc(chngct);
            t.add('ISTAT^^' + IIndexObj.Status.Ext);
            chmsg := chmsg + #13 + 'Status:               ' +
              IIndexObj.Status.Ext;
          end;
          if (IIndexObj.StatusReason.Ext <> '<no change>') and
            (IIndexObj.StatusReason.Ext <> '') then
          begin
            inc(chngct);
            t.add('ISTATRSN^^' + IIndexObj.StatusReason.Ext);
            chmsg := chmsg + #13 + 'Status Reason:  ' +
              IIndexObj.StatusReason.Ext;
          end;
          if (IIndexObj.ImageCreationDate.Ext <> '<no change>') and
            (IIndexObj.ImageCreationDate.Ext <> '') then
          begin
            inc(chngct);
            t.add('CRTNDT^^' + IIndexObj.ImageCreationDate.Ext);
            chmsg := chmsg + #13 + 'Image Date:      ' +
              IIndexObj.ImageCreationDate.Ext;
          end;

          if chngct = 0 then
          begin
            messagedlg('No changes were made.', mtconfirmation,
              [mbOK], 0);
            exit;
          end;
          //IIndexObj, has the new index fields selected in the window.
          //    + #13 + 'For Image ID: ' + IIndexObj.ImageIEN    + #13
          if messagedlg('The following changes will be made ' + #13 +
            'to the ' + ctmsg + chmsg, mtconfirmation, mbokcancel, 0) =
            mrCancel then
            Exit;

          //out temporarily to get 93 to compile
          //     dmod.MagDBBroker1.RPMag4FieldValueSet(rstat,rmsg,rlist,t);
          //RPMaggImageSetProperties(var rstat: boolean;  var rmsg: string; var rlist: tstrings; fieldlist : Tstrings; ien, params: string);

          dmod.MagDBBroker1.RPMaggImageSetProperties(rstat, rmsg,
            rlist, t, magienlist[0], '');
          if not rstat then
          begin
            { TODO : Need to display all messages, need to modify to get a list of messages. }
            //MAGGMSGF.MagMsg('D', rmsg);
            MagLogger.MagMsg('D', rmsg); {JK 10/5/2009 - Maggmsgu refactoring}
          end
          else
          begin
            //Success.
            // How to Refresh the current Filter.
            {93 we are deciding ... do we update the list on each edit, or
            just mark it as 'needing refresh'  and let the user do it.}
            //UpdateFilteredList;
            //  OR JUST mark as needs refreshed , like the Verify Window
            //ListView.ImageStatusChange(Iobj, umagdefinitions.mistNeedsRefresh);
            ListView.ImageStateChange(Iobj,
              umagdefinitions.mistateNeedsRefresh);

            editresult := true;
          end;

        end {if frmIndexEdit.execute }
        else
        begin
          winmsg(mmsglistwin, 'Index changes were canceled.');
        end;
      end {if magienlist.Count = 1 }
      else
      begin
        //MultiEntryEdit(magienlist);
      end;
    finally
      t.free;
      rlist.free;
      magienlist.free;
      IIndexObj.free; // ?

      if MagListView1.MultiSelect then
      begin
        MagListView1.MultiSelect := false;
        mnuMultiLine.Checked := false;
      end;
    end;
  except
    on E: Exception do
      winmsg(mmsglistwin, E.Message);
  end;

  {
    for I := 0 to magienlist.Count-1 do t.add('IEN^'+magienlist[i]);
          //t.ADD('$$DATA');
          if (IIndexObj.TypeIndex.Ext <> '<no change>')
            then t.add('42^'+IIndexObj.TypeIndex.Ext);
          if (IIndexObj.ProcEventIndex.Ext <> '<no change>')
            then t.add('43^'+IIndexObj.ProcEventIndex.Ext);
          if (IIndexObj.SpecSubSpecIndex.Ext <> '<no change>')
            then t.add('44^'+IIndexObj.SpecSubSpecIndex.Ext);
          if (IIndexObj.OriginIndex.Ext <> '<no change>')
            then t.add('45^'+IIndexObj.OriginIndex.Ext);
          if (IIndexObj.ShortDesc.Ext <> '<no change>')
            then t.add('10^'+IIndexObj.ShortDesc.Ext);
          //IIndexObj, has the new index fields selected in the window.
            //    + #13 + 'For Image ID: ' + IIndexObj.ImageIEN    + #13
            messagedlg('The Following ' + ctmsg
                + #13 + #13
                + #13 + 'Origin:               ' + IIndexObj.OriginIndex.Ext
                + #13 + 'Type:                 ' + IIndexObj.TypeIndex.Ext
                + #13 + 'Spec/SubSpec:  ' + IIndexObj.SpecSubSpecIndex.Ext
                + #13 + 'Proc/Event:       ' + IIndexObj.ProcEventIndex.Ext
                + #13 + 'Desc:                 ' + IIndexObj.ShortDesc.Ext,mtconfirmation,mbokcancel,0);
     //out temporarily to get 93 to compile
     //     dmod.MagDBBroker1.RPMag4FieldValueSet(rstat,rmsg,rlist,t);

  }

end;
*)

procedure TfrmImageList.mnuIndexEdit2Click(Sender: TObject);
//var
//    editstat: boolean;
begin
  CurrentImageIndexEdit;

  //    ImageIndexEdit(MagListView1, editstat);
end;

procedure TfrmImageList.mnuImageListFilters2Click(Sender: TObject);
begin
  GetFilter;
end;

procedure TfrmImageList.mnuRefreshFilterList2Click(Sender: TObject);
begin
  RefreshAllFilters;
end;

procedure TfrmImageList.mnuFiltersasTabs2Click(Sender: TObject);
begin
  FiltersAsTabs(mnuFiltersasTabs2.Checked);
end;

procedure TfrmImageList.mnuMultiLineTabs2Click(Sender: TObject);
begin
  FilterTabsMultiLine(mnuMultiLineTabs2.checked);
end;

procedure TfrmImageList.FilterTabPopupPopup(Sender: TObject);
begin
  mnuFiltersasTabs2.Checked := self.pnlFilterTabs.Visible;
  mnuMultiLineTabs2.Checked := self.tabctrlFilters.MultiLine;
end;

procedure TfrmImageList.SetAutoSelect(vautoon: boolean; vspeed: integer);
begin
  MagListView1.HotTrack := vautoon;
  MagTreeView1.AutoSelect := vautoon;
  case vspeed of
    0:
      begin
        MagListView1.HoverTime := 750;
        self.timerSyncTimer.Interval := 750;
      end;
    1:
      begin
        MagListView1.HoverTime := 500;
        self.timerSyncTimer.Interval := 500;
      end;
    2:
      begin
        MagListView1.HoverTime := 250;
        self.timerSyncTimer.Interval := 250;
      end;
  end;
end;

procedure TfrmImageList.UserPrefsApply(upref: Tuserpreferences);
var
  i: integer;
begin
  MagSetBounds(frmImageList, Upref.ImageListWinpos);
  self.setdefaultheight(Upref.ImageListWinpos.Bottom);
  self.MagListView1.SetColumnWidths(Upref.ImageListWincolwidths);
  self.SetAbsPreview(upref.ImageListPrevAbs);
  self.SetRptPreview(upref.ImageListPrevReport);
  self.SetDefaultImageFilter(upref.ImageListDefautFilter);
  self.SetFilterOptions(upref.ImageListFilterAsTabs, upref.ImageListMultiLineTabs);
  self.pnlMainToolbar.Visible := upref.ImageListToolbar;
  self.mnuShowDeletedImageInformation.Checked := upref.UseDelImagePlaceHolder;      //p117 gek

  FCurrentFilter.ShowDeletedImageInfo             := upref.UseDelImagePlaceHolder;
  dmod.MagPat1.M_IncDeletedImageCount             := upref.UseDelImagePlaceHolder;

  if upref.StyleShowTree then
    self.TreeShow
  else
    self.TreeHide;
  {   }
  Self.SetAutoSelect(upref.StyleAutoSelect, upref.StyleAutoSelectSpeed);

  {       StyleSyncSelection : boolean; }
  //93 out for now, always true  umagdefinitions.FSyncImageON :=  upref.StyleSyncSelection;
  umagdefinitions.FSyncImageON := true; {Force Always True, but leave, design may change}
  //old  {     StyleWhereToShowAbs : integer ; // 0 List Win,  1  Abs Window. }
         {     StylePositionOfAbs : integer ;  // 0 Left, 1 bottom, 2 in Tree. }
  // new {     StyleWHETHERToShowAbs : integer ;   0 No Show,  1  Show. }
         {     StylePositionOfAbs : integer ;      0 Left, 1 bottom, 2 in Tree, 3 Abs Window }
  FUseThumbNailWindow := upref.StylePositionOfAbs = 3;
  if FUseThumbNailWindow and (upref.StyleWhetherToShowAbs = 1) then
    AbThmUseThumbNailWindow(true);
  if (not FUseThumbNailWindow) and (upref.StyleWhetherToShowAbs = 1) then
    case upref.StylePositionOfAbs of
      0: self.AbThmThumbsLeft;
      1: self.AbThmThumbsBottom;
      2: self.AbThmThumbsBottomTree;
      3: ; //
    else
      self.AbThmThumbsLeft;
    end;

  {    StyleTreeSortButtonsShow : boolean;  }
  self.pgctrlTreeView.Visible := upref.StyleTreeSortButtonsShow;

  {    StyleTreeAutoExpand : boolean;  }
  self.magtreeview1.AutoExpand := upref.StyleTreeAutoExpand;

  {    StyleListAbsScrollHoriz : boolean;  }
  self.ListWinAbsViewer.ScrollVertical := not upref.StyleListAbsScrollHoriz;
  {    StyleListFullScrollHoriz : boolean;  }
  self.ListWinFullViewer.ScrollVertical := not upref.StyleListFullScrollHoriz;
  self.ListWinFullViewer.MaxCount := upref.FullMaxLoad;
  self.ListViewShow(upref.StyleShowList);
  {    StyleWhereToShowImage : integer; // 0 List Win,  1 Full Res.  }
  self.FullResLocalShow(upref.StyleWhereToShowImage = 0);

  Self.SetUprefControlPositions(upref.StyleControlPos);
end;

procedure TfrmImageList.SetUprefControlPositions(value: string);
var
  I: integer;
begin
          (*
              result := ',' +
            inttostr(self.memReport.Height) + ',' + // 1
          inttostr(self.pnlAbs.Height) + ',' + // 2
          inttostr(self.pnlAbs.Width) + ',' + // 3
          inttostr(self.ListWinAbsViewer.RowCount) + ',' + // 4
          inttostr(self.ListWinAbsViewer.ColumnCount) + ',' + // 5
          inttostr(self.pnlTree.Width) + ',' + // 6
          inttostr(self.pnlMagListView.Height) + ',' + // 7
          inttostr(self.pnlAbsPreview.Width) + ',' + // 8
          inttostr(self.Mag4Vgear1.Height) + ',' + // 9
          //  p93t8  more control positions
          inttostr(self.pnlfullres.Height) + ',' + //  10
          magbooltostrint(magViewerTB81.CoolBar1.Bands[0].Break) + ',' + // 11
          magbooltostrint(magViewerTB81.CoolBar1.Bands[1].Break) + ',' + // 12
          magbooltostrint(magViewerTB81.CoolBar1.Bands[2].Break) + ',' + // 13
          // p93t11
          magbooltostrint(magViewerTB81.Visible) + ',' + //   14
          // p93t12
          inttostr(self.ListWinFullViewer.FLastFit) + ','; //15
          *)
  value := stripfirstlastcomma(value);
  {   If any of these are 0 or small, then GUI will look bad.
      I put constraints on the controls, but that causes problems too.}

      {       Report Memo height}
  i := magstrtoint(magpiece(value, ',', 1));
  if i < 50 then
    i := 50;
  self.memReport.Height := i;

  {       Abstract panel Height}
  i := magstrtoint(magpiece(value, ',', 2));
  if i < 90 then
    i := 90;
  self.pnlAbs.Height := i;

  {       Abstract Panel width}
  i := magstrtoint(magpiece(value, ',', 3));
  if i < 90 then
    i := 90;
  self.pnlAbs.Width := i;

  {       Abstracts viewer Row Count}
  i := magstrtoint(magpiece(value, ',', 4));
  if i < 1 then
    i := 1;
  self.ListWinAbsViewer.RowCount := i;

  {       Abstract Viewer Column Count}
  i := magstrtoint(magpiece(value, ',', 5));
  if i < 1 then
    i := 1;
  self.ListWinAbsViewer.ColumnCount := i;
  self.ListWinAbsViewer.SetDefaultLayout(ListWinAbsViewer.RowCount, ListWinAbsViewer.ColumnCount, 48, true);

  {       Tree Panel width}
  i := magstrtoint(magpiece(value, ',', 6));
  if i < 85 then
    i := 85;
  self.pnlTree.Width := i;

  {      panel Image List (list view) height }
  i := magstrtoint(magpiece(value, ',', 7));
  if i < 30 then
    i := 30;
  self.pnlMagListView.Height := i;

  {       panel Abstract Preview width}
  i := magstrtoint(magpiece(value, ',', 8));
  if i < 100 then
    i := 100;
  self.pnlAbsPreview.Width := i;

  {       Abstract Preview height... the info panel is under the Abstract
           on the abstract Panel.}
  i := magstrtoint(magpiece(value, ',', 9));
  if i < 50 then
    i := 50;
  self.Mag4Vgear1.Height := i;

  //p93t8   gek.  put extra settings in upref.StyleControlPos property.
 /// nothing after here is in Default Prefs for New User.....
  i := magstrtoint(magpiece(value, ',', 10));
  if i < 400 then
    i := 400;
  self.pnlfullres.Height := i;
  if magpiece(value, ',', 11) = '' then
  begin
    //  here this is the first time this user has used 93 Client,
    //or has used it, but Not saved Settings.
    // we'll force him to save settings this first time.
    upref.SaveSettingsOnExit := true;
  end;
  {   If Defaults are not defined for the Toolbar in M, then
           we defalut CoolBar Bands to Break = true (for 2nd two) }
  magViewerTB81.CoolBar1.Bands[0].Break := magstrtobool(magpiece(value, ',', 11), 'false');
  magViewerTB81.CoolBar1.Bands[1].Break := magstrtobool(magpiece(value, ',', 12), 'true');
  magViewerTB81.CoolBar1.Bands[2].Break := magstrtobool(magpiece(value, ',', 13), 'true');
  // p93t11
  magviewerTB81.Visible := magstrtobool(magpiece(value, ',', 14), 'true');
 {p117 T5+   gek   this is where the Upref for Last Fit is set in Image List Window full viewer}
 { values for nFitMethod parameter of IG_display_fit_method }

{/p117 T5+ Constants the Accusoft provides, and we save as User Pref.
  IG_DISPLAY_FIT_TO_WINDOW = 0;
  IG_DISPLAY_FIT_TO_WIDTH = 1;
  IG_DISPLAY_FIT_TO_HEIGHT = 2;
  IG_DISPLAY_FIT_1_TO_1 = 3; }

  self.ListWinFullViewer.FLastFit := magStrtoInt(magpiece(value, ',', 15), 1);
  self.ListWinFullViewer.SetDefaultLayout(1, 1, 2, false, self.ListWinFullViewer.FLastFit);
  self.ListWinFullViewer.SetRemember(true);

end;

function TfrmImageList.GetUprefControlPositions: string;
begin
  {    StyleReportH : integer;
      StyleAbsPanelH : integer;
      StyleAbsPanelW : integer;
      StyleAbsRows : integer;
      StyleAbsCols : integer;
      StyleTreeW : integer;
      StyleListPanelH : integer;
      StyleAbsPrevPanelW : integer;
      StyleAbsPrevH : integer;

      Toolbarvisible
      LastFit Method}

  result := ',' +
    inttostr(self.memReport.Height) + ',' + // 1
  inttostr(self.pnlAbs.Height) + ',' + // 2
  inttostr(self.pnlAbs.Width) + ',' + // 3
  inttostr(self.ListWinAbsViewer.RowCount) + ',' + // 4
  inttostr(self.ListWinAbsViewer.ColumnCount) + ',' + // 5
  inttostr(self.pnlTree.Width) + ',' + // 6
  inttostr(self.pnlMagListView.Height) + ',' + // 7
  inttostr(self.pnlAbsPreview.Width) + ',' + // 8
  inttostr(self.Mag4Vgear1.Height) + ',' + // 9
  //  p93t8  more control positions
  inttostr(self.pnlfullres.Height) + ',' + //  10
  magbooltostrint(magViewerTB81.CoolBar1.Bands[0].Break) + ',' + // 11
  magbooltostrint(magViewerTB81.CoolBar1.Bands[1].Break) + ',' + // 12
  magbooltostrint(magViewerTB81.CoolBar1.Bands[2].Break) + ',' + // 13
  // p93t11
  magbooltostrint(magViewerTB81.Visible) + ',' + //   14
  // p93t12
  inttostr(self.ListWinFullViewer.FLastFit) + ','; //15
end;

procedure TfrmImageList.popupAbstractsPopup(Sender: TObject);
var
  Iobj: TImageData;
  wasimageclicked: boolean;
  newsobj: TMagNewsObject;
  isdel : boolean;      {CodeCR710}
begin
  {  PopUpmenu could be activated by the window or VGear Component
     so If not any current Image, in Viewer, then disable some menu options.}

  mnutoolbar3.Checked := ListWinAbsViewer.tbViewer.Visible;

  mnuImageInformationAdvanced3.visible := (UserHasKey('MAG SYSTEM'));
  mnuImageDelete3.visible := (UserHasKey('MAG DELETE'));
  mnuImageIndexEditAbs3.Visible := (UserHasKey('MAG SYSTEM') or UserHasKey('MAG EDIT'));

  wasimageclicked := (popupAbstracts.PopupComponent is TMag4Vgear);
  if wasimageclicked then
    begin
    Iobj := TMag4Vgear(popupAbstracts.PopupComponent).PI_ptrData;
    isdel := Iobj.IsImageDeleted;
    if not isdel then isdel := imagedeletedthissession(iobj,false);
    end;


  mnuOpen3.Enabled := wasimageclicked and (not isdel);
  mnuImageReport3.Enabled := wasimageclicked and (not isdel);
  mnuImageDelete3.enabled := wasimageclicked and (not isdel);
  mnuImageIndexEditAbs3.Enabled := wasimageclicked and (not isdel);
  mnuImageInformation3.Enabled := wasimageclicked;
  mnuImageInformationAdvanced3.enabled := wasimageclicked;
  mnuCacheGroup3.Enabled := wasimageclicked and (not isdel);

  // another condition needed for enabling these 3.
  mnuViewImagein2ndRadiologyWindow3.visible := false;
  // another condition needed for enable

  if not wasimageclicked then
    exit;
  if FSyncImageON then {FSyncImageOn from  ListWinAbsViewer click}
  begin
    if Iobj <> nil then
    begin
      newsObj := MakeNewsObject(mpubImageSelected, 0, Iobj.Mag0, Iobj,
        ListWinAbsViewer);
      self.MagPublisher1.I_SetNews(newsobj); //ListWin  popupAbstractsPopup
    end;
  end;
  //vGear :=TMag4Vgear(popupVImage.PopupComponent);
  {   p8t21  an idea is this =>  Iobj := Mag4Viewer1.GetCurrentImageObject;
        But menu items send VGear  so that wouldn't work See mnuOpenClick
        all menu items would need to be changed to be calling a function of the
        Mag4Viewer.   also because later when multiple images can be opened at
        same time, the specifiec VGear isn't necessary, (or Mag4Viewer could
        get it itself) }

//gek  mnuViewImagein2ndRadiologyWindow3.enabled := ((Iobj.ImgType <> 11) and (Iobj.Imgtype = 3)) or (Iobj.ImgType = 100);  {JK 2/19/2009 - Fixes D83}
  if not isdel then  {/p117  gek  the menu option was showing for deleted images.}
      mnuViewImagein2ndRadiologyWindow3.visible := ((not Iobj.IsImageGroup) and Iobj.IsRadImage);

  mnuImageDelete3.caption := 'Image Delete...';
  if Iobj.IsImageGroup then
    mnuImageDelete3.caption := 'Image Group Delete...';

  application.processmessages;
  winmsgClear;

end;

procedure TfrmImageList.mnuOpen3Click(Sender: TObject);
//var
//  VGear: Tmag4Vgear;
//  viewer: TMag4Viewer;
begin
  AbsOpenSelectedImage(TMag4Vgear(popupAbstracts.PopupComponent).PI_ptrData,
    1);
  {   Rethink this... the menu item is only enabled if the PopupComponent is a TMag4VGear
      and it doesn't matter if it's from a viewer or not..  not sure why the viewer was
      a part of this conditional..... old code. maybe just was a QAD change}
//  vGear := TMag4Vgear(popupAbstracts.PopupComponent);
//  Viewer := TMag4Viewer(vGear.parent);
//  if viewer <> nil
//      then AbsOpenSelectedImage(TMag4Vgear(popupAbstracts.PopupComponent).PI_ptrData, 1);
end;

procedure TfrmImageList.mnuViewImagein2ndRadiologyWindow3Click(Sender: TObject);
begin
  {/ P117 - JK 9/7/2010 - Check for if the image has been deleted /}
  if TMag4Vgear(popupAbstracts.PopupComponent).PI_ptrData.IsImageDeleted then
  begin
    MagLogger.LogMsg('DI', TMag4Vgear(popupAbstracts.PopupComponent).PI_ptrData.GetViewStatusMsg, MagLogINFO);
  end
  else
  begin
    AbsOpenSelectedImage(TMag4Vgear(popupAbstracts.PopupComponent).PI_ptrData, 2);
  end;
end;

procedure TfrmImageList.mnuImageReport3Click(Sender: TObject);
var
  Iobj: TImageData;
  rstat: boolean;
  rmsg: string;
begin
  Iobj := TMag4Vgear(popupAbstracts.PopupComponent).PI_ptrData;
  dmod.MagUtilsDB1.ImageReport(Iobj, rstat, rmsg);
  LogActions('ABS', 'REPORT', Iobj.Mag0);
end;

procedure TfrmImageList.mnuImageDelete3Click(Sender: TObject);
var
  Iobj: TImageData;
  rmsg: string;
begin
  Iobj := TMag4Vgear(popupAbstracts.PopupComponent).PI_ptrData;

  {/ P117 - JK 9/7/2010 - Check for if the image has been deleted /}
  if TMag4Vgear(popupAbstracts.PopupComponent).PI_ptrData.IsImageDeleted then
  begin
    MagLogger.LogMsg('DI', IObj.GetViewStatusMsg, MagLogINFO);
  end
  else
  begin
    { JMW 6/24/2005 p45t3 compare based on server and port (more accurate)}
    if (iobj.ServerName <> dmod.MagDBBroker1.GetServer) or (iobj.ServerPort <>
      dmod.MagDBBroker1.GetListenerPort) then
    begin
      showMessage('You cannot delete an image from a remote site');
      exit;
    end;
    //logmsg('s', 'Attempting deletion of ' + Iobj.ffile + '  IEN ' + Iobj.Mag0);
    MagLogger.LogMsg('s', 'Attempting deletion of ' + Iobj.ffile + '  IEN ' + Iobj.Mag0);
      {JK 10/6/2009 - Maggmsgu refactoring}

    //  frmMain.ImageDelete(Iobj);
    if MgrImageDelete(Iobj, rmsg) then
    begin
      LogActions('IMAGELIST', 'DELETE', Iobj.Mag0);
      { TODO -cSynchronize Status : NEED TO REFRESH THE ICONS IN THE IMAGE TREE VIEW
        ListView, TreeView, FullRes Local, Full Res Window  etc.... AbsLocal, Abs Window
      need to use the Publish Subscribe for changing status, state, etc.}
      { TODO -cSynchronize Status : NEED TO DO SOMETHING WHEN THE ABSTRACT IS DELETED.  }

      if self.pnlMagListView.visible then
        Self.MagListView1.ImageStatusChange(Iobj,
          umagdefinitions.mistDeleted);
      // self.MagTreeView1.
      self.ListWinAbsViewer.RemoveOneFromList(Iobj);
      if pnlfullres.Visible then
        self.ListWinFullViewer.RemoveOneFromList(Iobj);
      //// abs window, full window... need to use the Publish Subscribe for changing status, state, etc.
    end;
  end;
end;

procedure TfrmImageList.mnuImageInformation3Click(Sender: TObject);
var
  Iobj: TImageData;
  sellist: Tlist;
  i: integer;
begin
  sellist := self.ListWinAbsViewer.GetSelectedImageList;
  for i := sellist.count - 1 downto 0 do
  begin
    Iobj := sellist[i];
    ShowImageInformation(Iobj);
  end;
end;

procedure TfrmImageList.mnuImageInformationAdvanced3Click(Sender: TObject);
var
  Iobj: TImageData;
begin
  Iobj := TMag4Vgear(popupAbstracts.PopupComponent).PI_ptrData;
  { advanced information for sysmanagers.}
  //frmMain.ShowimageinfoSys(Iobj);
  OpenImageInfoSys(IObj);
  LogActions('ABS', 'IMAGE INFO', Iobj.Mag0);
end;

procedure TfrmImageList.mnuCacheGroup3Click(Sender: TObject);
var
  IObj: TImageData;
begin
  Iobj := TMag4Vgear(popupAbstracts.PopupComponent).PI_ptrData;

  {/ P117 - JK 9/7/2010 - Check for if the image has been deleted /}
  if TMag4Vgear(popupAbstracts.PopupComponent).PI_ptrData.IsImageDeleted then
    MagLogger.LogMsg('DI', Iobj.GetViewStatusMsg, MagLogINFO)
  else
    CacheFromImageListWindow(Iobj);
end;

procedure TfrmImageList.popupImagePopup(Sender: TObject);
var
  iobj: TImageData;
  imageclicked: boolean;
  newsObj: TMagNewsObject;
begin
  frmMain.Winmsg('', '');
  mnuToolbar4.checked := magViewerTB81.Visible;

  mnuImageDelete4.visible := (UserHasKey('MAG DELETE'));
  mnuImageInformationAdvanced4.visible := (UserHasKey('MAG SYSTEM'));
  mnuVerifyFull4.Visible := (UserHasKey('MAG SYSTEM') or UserHasKey('MAG EDIT') or UserHasKey('MAG QA REVIEW'));
  mnuImageIndexEditFull4.Visible := (UserHasKey('MAG SYSTEM') or UserHasKey('MAG EDIT'));
  imageclicked := (popupImage.PopupComponent is TMag4Vgear);

  IF mnuVerifyFull4.Visible THEN mnuVerifyFull4.Enabled := imageclicked;
  mnuImageIndexEditFull4.Enabled := imageclicked;
  mnuZoom4.Enabled := imageclicked;
  mnuMouse4.Enabled := imageclicked;
  mnuRotate4.Enabled := imageclicked;
  mnuInvert4.Enabled := imageclicked;
  mnuReset4.Enabled := imageclicked;
  mnuRemoveImage4.Enabled := imageclicked;
  mnuImageReport4.Enabled := imageclicked;
  mnuImageDelete4.Enabled := imageclicked;
  mnuImageInformation4.Enabled := imageclicked;
  mnuImageInformationAdvanced4.Enabled := imageclicked;
  if not imageclicked then
    exit;

  Iobj := TMag4Vgear(popupImage.PopupComponent).PI_ptrData;
  if FSyncImageON then {FSyncImageOn from  ListWinFullviewer click}
  begin
    if Iobj <> nil then
    begin
      newsObj := MakeNewsObject(mpubImageSelected, 0, Iobj.Mag0, Iobj,
        self.ListWinFullViewer);
      self.MagPublisher1.I_SetNews(newsobj); //ListWin  popupImagePopup
    end;
  end;

end;

procedure TfrmImageList.mnuActualSize4Click(Sender: TObject);
begin
  self.ListWinFullViewer.Fit1to1;
end;

procedure TfrmImageList.mmuFitToWindow4Click(Sender: TObject);
begin
  self.ListWinFullViewer.FitToWindow
end;

procedure TfrmImageList.mnuFitToWidth4Click(Sender: TObject);
begin
  ListWinFullViewer.FitToWidth
end;

procedure TfrmImageList.ZoomOut4Click(Sender: TObject);
var
  value: integer;
begin
  value := TMag4Vgear(PopupImage.PopupComponent).GetZoomValue;
  ListWinFullViewer.ZoomValue(trunc(value * 0.9));
end;

procedure TfrmImageList.ZoomIn4Click(Sender: TObject);
var
  value: integer;
begin
  value := TMag4Vgear(PopupImage.PopupComponent).GetZoomValue;
  ListWinFullViewer.ZoomValue(trunc(value * 1.1));
end;

procedure TfrmImageList.mnuMousePan4Click(Sender: TObject);
begin
  ListWinFullViewer.MousePan
end;

procedure TfrmImageList.mnuMouseMagnify4Click(Sender: TObject);
begin
  ListWinFullViewer.MouseMagnify
end;

procedure TfrmImageList.mnuMouseZoom4Click(Sender: TObject);
begin
  ListWinFullViewer.MouseZoomRect
end;

procedure TfrmImageList.mnuMousePointer4Click(Sender: TObject);
begin
  ListWinFullViewer.MouseReset
end;

procedure TfrmImageList.mnuRotateRight4Click(Sender: TObject);
begin
  ListWinFullViewer.Rotate(90);
end;

procedure TfrmImageList.mnuRotateLeft4Click(Sender: TObject);
begin
  ListWinFullViewer.Rotate(270);
end;

procedure TfrmImageList.mnuRotate1804Click(Sender: TObject);
begin
  ListWinFullViewer.Rotate(180);
end;

procedure TfrmImageList.FlipHorizontal4Click(Sender: TObject);
begin
  ListWinFullViewer.FlipHoriz
end;

procedure TfrmImageList.FlipVertical4Click(Sender: TObject);
begin
  ListWinFullViewer.FlipVert;
end;

procedure TfrmImageList.mnuInvert4Click(Sender: TObject);
begin
  ListWinFullViewer.Inverse;
end;

procedure TfrmImageList.mnuReset4Click(Sender: TObject);
begin
  ListWinFullViewer.ResetImages();
  self.magViewerTB81.UpdateImageState;
end;

procedure TfrmImageList.mnuRemoveImage4Click(Sender: TObject);
begin
  ListWinFullViewer.RemoveFromList;
end;

procedure TfrmImageList.mnuImageReport4Click(Sender: TObject);
begin
  ListWinFullViewer.ImageReport
end;

procedure TfrmImageList.mnuImageDelete4Click(Sender: TObject);
var
  Iobj: TImageData;
  rmsg: string;
begin
  Iobj := TMag4Vgear(popupImage.PopupComponent).PI_ptrData;
  { JMW 6/24/2005 p45t3 compare based on server and port (more accurate)}
  if (iobj.ServerName <> dmod.MagDBBroker1.GetServer) or (iobj.ServerPort <>
    dmod.MagDBBroker1.GetListenerPort) then
  begin
    showMessage('You cannot delete an image from a remote site');
    exit;
  end;
  //logmsg('s', 'Attempting deletion of ' + Iobj.ffile + '  IEN ' + Iobj.Mag0);
  MagLogger.LogMsg('s', 'Attempting deletion of ' + Iobj.ffile + '  IEN ' + Iobj.Mag0);
    {JK 10/6/2009 - Maggmsgu refactoring}

  //  frmMain.ImageDelete(Iobj);
  if MgrImageDelete(Iobj, rmsg) then
  begin
    LogActions('IMAGELIST', 'DELETE', Iobj.Mag0);
    { TODO -cSynchronize Status : NEED TO REFRESH THE ICONS IN THE IMAGE TREE VIEW
      ListView, TreeView, FullRes Local, Full Res Window  etc.... AbsLocal, Abs Window
    need to use the Publish Subscribe for changing status, state, etc.}
    { TODO -cSynchronize Status : NEED TO DO SOMETHING WHEN THE ABSTRACT IS DELETED.  }

    if self.pnlMagListView.visible then
      Self.MagListView1.ImageStatusChange(Iobj,
        umagdefinitions.mistDeleted);
    // self.MagTreeView1.
    if self.pnlAbs.Visible then
      self.ListWinAbsViewer.RemoveOneFromList(Iobj);
    self.ListWinFullViewer.RemoveOneFromList(Iobj);
    //// abs window, full window... need to use the Publish Subscribe for changing status, state, etc.
  end;
end;

procedure TfrmImageList.mnuImageInformation4Click(Sender: TObject);
var
  Iobj: TImageData;
  sellist: Tlist;
  i: integer;
begin
  sellist := self.ListWinFullViewer.GetSelectedImageList;
  for i := sellist.count - 1 downto 0 do
  begin
    Iobj := sellist[i];
    ShowImageInformation(Iobj);
  end;
end;

procedure TfrmImageList.mnuImageInformationAdvanced4Click(Sender: TObject);
var
  Iobj: TImageData;
begin
  Iobj := TMag4Vgear(popupImage.PopupComponent).PI_ptrData;
  { advanced information for sysmanagers.}
//    frmMain.ShowimageinfoSys(Iobj);
  OpenImageInfoSys(IObj);
  LogActions('ABS', 'IMAGE INFO', Iobj.Mag0);
end;

procedure TfrmImageList.mnuFont6Click(Sender: TObject);
begin
  listwinabsviewer.ImageFontSize := 6;
end;

procedure TfrmImageList.mnuFont7Click(Sender: TObject);
begin
  listwinabsviewer.ImageFontSize := 7;
end;

procedure TfrmImageList.mnuFont8Click(Sender: TObject);
begin
  listwinabsviewer.ImageFontSize := 8;
end;

procedure TfrmImageList.mnuFont10Click(Sender: TObject);
begin
  listwinabsviewer.ImageFontSize := 10;
end;

procedure TfrmImageList.mnuFont12Click(Sender: TObject);
begin
  listwinabsviewer.ImageFontSize := 12;
end;

procedure TfrmImageList.mnuToolbar3Click(Sender: TObject);
begin
  ListWinAbsViewer.tbViewer.Visible := mnutoolbar3.Checked;
end;

procedure TfrmImageList.mnuToolbar4Click(Sender: TObject);
begin
  magViewerTB81.Visible := mnuToolbar4.checked;
end;

procedure TfrmImageList.mnu6ptClick(Sender: TObject);
begin
  listwinfullviewer.ImageFontSize := 6;
end;

procedure TfrmImageList.mnu7ptClick(Sender: TObject);
begin
  listwinfullviewer.ImageFontSize := 7;
end;

procedure TfrmImageList.mnu8ptClick(Sender: TObject);
begin
  listwinfullviewer.ImageFontSize := 8;
end;

procedure TfrmImageList.mnu10ptClick(Sender: TObject);
begin
  listwinfullviewer.ImageFontSize := 10;
end;

procedure TfrmImageList.mnu12ptClick(Sender: TObject);
begin
  listwinfullviewer.ImageFontSize := 12;
end;

procedure TfrmImageList.PopupTreePopup(Sender: TObject);
var
  Iobj: TImageData;
  wasimageclicked: boolean;
  tn: TTreenode;
  isdel : boolean;    {CodeCR710}
begin
{$IFDEF TESTMESSAGES}maggmsgf.MagMsg('', 'In PopupTreePopup(...');
{$ENDIF}
  {  PopUpmenu could be activated by the Tree if or If not an item is selected
     so If not any current Image, in Tree, then disable some menu options.}

  mnuSortButtons6.Checked := self.pgctrlTreeView.Visible;

  mnuImageInformationAdvanced6.visible := (UserHasKey('MAG SYSTEM'));
  mnuImageDelete6.visible := (UserHasKey('MAG DELETE'));
  mnuImageIndexEditTree6.Visible := (UserHasKey('MAG SYSTEM') or UserHasKey('MAG EDIT'));

  wasimageclicked := true;
  TN := magtreeview1.selected;
  if tn = nil then
    wasimageclicked := false
  else if tn.HasChildren then
    wasimageclicked := false;

  if wasimageclicked then
    begin
    Iobj := (TMagTreeViewData(tn.Data).Iobj);
    isdel := Iobj.IsImageDeleted;
    if not isdel then isdel := imagedeletedthissession(iobj,false);
    end;


  mnuOpenImage6.Enabled := wasimageclicked and (not isdel);
  mnuImageReport6.Enabled := wasimageclicked and (not isdel);
  mnuImageDelete6.enabled := wasimageclicked and (not isdel);
  mnuImageIndexEditTree6.Enabled := wasimageclicked and (not isdel);
  mnuImageInformation6.Enabled := wasimageclicked;
  mnuImageInformationAdvanced6.enabled := wasimageclicked;
  mnuCacheGroup6.Enabled := wasimageclicked and (not isdel);

  // another condition needed for enabling these 3.
  mnuOpenin2ndRadWindow6.visible := false;
  // another condition needed for enable

  if not wasimageclicked then
    exit;
  Iobj := (TMagTreeViewData(tn.Data).Iobj);

  //vGear :=TMag4Vgear(popupVImage.PopupComponent);
  {   p8t21  an idea is this =>  Iobj := Mag4Viewer1.GetCurrentImageObject;
        But menu items send VGear  so that wouldn't work See mnuOpenClick
        all menu items would need to be changed to be calling a function of the
        Mag4Viewer.   also because later when multiple images can be opened at
        same time, the specifiec VGear isn't necessary, (or Mag4Viewer could
        get it itself) }

//gek  mnuOpenin2ndRadWindow6.enabled := ((Iobj.ImgType <> 11) and (Iobj.Imgtype = 3)) or (Iobj.ImgType = 100);  {JK 2/19/2009 - Fixes D83}

  if not isdel then  {/p117  gek  the menu option was showing for deleted images.}
      mnuOpenin2ndRadWindow6.visible := (not Iobj.IsImageGroup) and Iobj.IsRadImage; {JK 2/19/2009 - Fixes D83}
  AutoExpandCollapse1.Checked := self.MagTreeView1.AutoExpand;
  mnuImageDelete6.caption := 'Image Delete...';
  if (Iobj.IsImageGroup) then
    mnuImageDelete6.caption := 'Image Group Delete...';
  application.processmessages;
  winmsgClear;

end;

procedure TfrmImageList.mnuOpenImage6Click(Sender: TObject);
begin
  OpenSelectedTreeImage(1);
end;

procedure TfrmImageList.mnuImageReport6Click(Sender: TObject);
var
  Iobj: TImageData;
  rstat: boolean;
  rmsg: string;
begin
  Iobj := (TMagTreeViewData(magtreeview1.selected.Data).Iobj);
  dmod.MagUtilsDB1.ImageReport(Iobj, rstat, rmsg);
  LogActions('ABS', 'REPORT', Iobj.Mag0);
end;

procedure TfrmImageList.mnuImageDelete6Click(Sender: TObject);
var
  Iobj: TImageData;
  rstat: boolean;
  rmsg: string;

begin
  Iobj := (TMagTreeViewData(magtreeview1.selected.Data).Iobj);

  { JMW 6/24/2005 p45t3 compare based on server and port (more accurate)}
  if (iobj.ServerName <> dmod.MagDBBroker1.GetServer) or (iobj.ServerPort <>
    dmod.MagDBBroker1.GetListenerPort) then
  begin
    showMessage('You cannot delete an image from a remote site');
    exit;
  end;
  //logmsg('s', 'Attempting deletion of ' + Iobj.ffile + '  IEN ' + Iobj.Mag0);
  MagLogger.LogMsg('s', 'Attempting deletion of ' + Iobj.ffile + '  IEN ' + Iobj.Mag0);
    {JK 10/6/2009 - Maggmsgu refactoring}

  //  frmMain.ImageDelete(Iobj);
  if MgrImageDelete(Iobj, rmsg) then
  begin
    LogActions('IMAGELIST', 'DELETE', Iobj.Mag0);
    { TODO -cSynchronize Status : NEED TO REFRESH THE ICONS IN THE IMAGE TREE VIEW
      ListView, TreeView, FullRes Local, Full Res Window  etc.... AbsLocal, Abs Window
    need to use the Publish Subscribe for changing status, state, etc.}
    { TODO -cSynchronize Status : NEED TO DO SOMETHING WHEN THE ABSTRACT IS DELETED.  }

    if self.pnlMagListView.visible then
      Self.MagListView1.ImageStatusChange(Iobj,
        umagdefinitions.mistDeleted);
    // self.MagTreeView1.
    self.ListWinAbsViewer.RemoveOneFromList(Iobj);
    if pnlfullres.Visible then
      self.ListWinFullViewer.RemoveOneFromList(Iobj);
    //// abs window, full window... need to use the Publish Subscribe for changing status, state, etc.
  end;
end;

procedure TfrmImageList.mnuImageInformation6Click(Sender: TObject);
var
  Iobj: TImageData;
  rstat: boolean;
  rmsg: string;
begin
  Iobj := (TMagTreeViewData(magtreeview1.selected.Data).Iobj);
  ShowImageInformation(Iobj);

  //sellist := self.ListWinAbsViewer.GetSelectedImageList;
  //for i := sellist.count -1 downto 0 do
  //  begin
  //  Iobj := sellist[i];
  //  ShowImageInformation(Iobj);
  //  end;
  //end;
end;

procedure TfrmImageList.mnuImageInformationAdvanced6Click(Sender: TObject);
var
  Iobj: TImageData;
  rstat: boolean;
  rmsg: string;
begin
  Iobj := (TMagTreeViewData(magtreeview1.selected.Data).Iobj);
  //  Iobj := TMag4Vgear(popupAbstracts.PopupComponent).PI_ptrData;
    { advanced information for sysmanagers.}
//    frmMain.ShowimageinfoSys(Iobj);
  OpenImageInfoSys(IObj);
  LogActions('ABS', 'IMAGE INFO', Iobj.Mag0);
end;

procedure TfrmImageList.mnuCacheGroup6Click(Sender: TObject);
var
  IObj: TImageData;
begin
  Iobj := (TMagTreeViewData(magtreeview1.selected.Data).Iobj);
  CacheFromImageListWindow(Iobj);

end;

procedure TfrmImageList.mnuOpenin2ndRadWindow6Click(Sender: TObject);
begin
  OpenSelectedTreeImage(2);
end;

procedure TfrmImageList.MagTreeView1Change(Sender: TObject; Node: TTreeNode);
var
  viobj: TImagedata;
  newsobj: TMagNewsObject;
begin
  // out in 93t8 gek.    SetCurSelectedImageObj(nil);
  if node = nil then
    exit;
  if not node.Selected then
    exit;
  if node.HasChildren then
    exit;
  // out of scope   if FDiscardSelect then exit;
  if Fimagelistsyncprocessing then
    exit;
  if FSyncImageON then {FSyncImageOn from TreeView click}
  begin
    vIobj := (TMagTreeViewData(node.Data).Iobj);
{$IFDEF testmessages}
    winmsg(umagdefinitions.mmsglistwin, 'Fimagelistsyncprocessing: ' + magbooltostr(Fimagelistsyncprocessing));
{$ENDIF}
    if vIobj <> nil then
    begin
      newsObj := MakeNewsObject(mpubImageSelected, 0, vIobj.Mag0, vIobj, MagTreeView1);
      //NewsSubscribe Does this- SetCurSelectedImageObj(vIobj);     {frmImageList.MagTreeView1Change}
      self.MagPublisher1.I_SetNews(newsobj); //TreeView MagTreeView1Change
    end;

  end;
end;

procedure TfrmImageList.MagTreeView1DblClick(Sender: TObject);
begin
  self.OpenSelectedTreeImage(1);
end;

procedure TfrmImageList.MagTreeView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_return then
    self.OpenSelectedTreeImage(1);
end;

procedure TfrmImageList.listwinResizeTimerTimer(Sender: TObject);
begin
  listwinResizeTimer.Enabled := false;
  application.processmessages;
  if self.ListWinAbsViewer.UseAutoRealign then
    ListWinAbsViewer.ReAlignImages;
  if self.ListWinFullViewer.UseAutoRealign then
    ListWinFullViewer.ReAlignImages;

end;

procedure TfrmImageList.AutoExpandCollapse1Click(Sender: TObject);
begin
  magtreeview1.AutoExpand := AutoExpandCollapse1.Checked;
end;

procedure TfrmImageList.mnuSortButtons6Click(Sender: TObject);
begin
  pgctrlTreeView.Visible := mnuSortButtons6.Checked;
end;

procedure TfrmImageList.mnuSpecialtyEvent6Click(Sender: TObject);
begin
  magtreeview1.LoadListFromMagImageList(magimagelist1, 'spec-11,event-12');
  pgctrlTreeView.TabIndex := -1;
  RefreshLocalTree;
end;

procedure TfrmImageList.mnuTypeSpecialty6Click(Sender: TObject);
begin
  magtreeview1.LoadListFromMagImageList(magimagelist1, 'type-10,spec-11');
  pgctrlTreeView.TabIndex := -1;
  RefreshLocalTree;
end;

procedure TfrmImageList.mnuPackageType6Click(Sender: TObject);
begin
  magtreeview1.LoadListFromMagImageList(magimagelist1, 'pkg-8,type-10');
  pgctrlTreeView.TabIndex := -1;
  RefreshLocalTree;
end;

procedure TfrmImageList.mnuCustom6Click(Sender: TObject);
begin
  if MagTreeView1.SelectBranches(MagImageList1) then
    pgctrlTreeView.TabIndex := -1;
  RefreshLocalTree;
end;

procedure TfrmImageList.mnuExpandAll6Click(Sender: TObject);
begin
  magtreeview1.FullExpand;
end;

procedure TfrmImageList.mnuExpand1level6Click(Sender: TObject);
var
  I: integer;
begin
  magtreeview1.FullCollapse;
  for i := 0 to magtreeview1.Items.count - 1 do
  begin
    if magtreeview1.items[i].Level = 0 then
      magtreeview1.Items[i].Expand(false);
  end;
end;

procedure TfrmImageList.mnuCollapseAll6Click(Sender: TObject);
begin
  magtreeview1.FullCollapse;
end;

procedure TfrmImageList.mnuAlphabeticSort6Click(Sender: TObject);
begin
  magtreeview1.AlphaSort(false);
  RefreshLocalTree;
end;

procedure TfrmImageList.mnuRefresh6Click(Sender: TObject);
begin
  RefreshLocalTree;
end;

procedure TfrmImageList.mnuPackage6Click(Sender: TObject);
begin
  magtreeview1.LoadListFromMagImageList(magimagelist1, 'pkg-8');
end;

procedure TfrmImageList.mnuSpecialty6Click(Sender: TObject);
begin
  magtreeview1.LoadListFromMagImageList(magimagelist1, 'spec-11');
end;

procedure TfrmImageList.mnuClass6Click(Sender: TObject);
begin
  magtreeview1.LoadListFromMagImageList(magimagelist1, 'class-9');
end;

procedure TfrmImageList.mnuType6Click(Sender: TObject);
begin
  magtreeview1.LoadListFromMagImageList(magimagelist1, 'type-10');
end;

procedure TfrmImageList.mnuResizetheAbstracts3Click(Sender: TObject);
begin
  frmAbsResize.Execute(self.ListWinAbsViewer.GetCurrentImage,
    self.ListWinAbsViewer, top, left);
end;

procedure TfrmImageList.MagPatPhoto1Click(Sender: TObject);
begin
  dmod.MagUtilsDB1.openpatientprofile;
end;

function TfrmImageList.GetFocusedControl(): TWincontrol;
var
  i: integer;
begin
  result := nil;
  for i := 0 to self.ControlCount - 1 do
  begin
    if (self.Controls[i] as TWincontrol).focused then
    begin
      result := TWinControl(self.Controls[i]);
      break;
    end;
  end;
end;

procedure TfrmImageList.CurrentImageOpen(displayflag: integer = 1);
var
  IObj: TImageData;
  xmsg, grpmsg: string;
  retmsg: string;
  curcontrol: TWincontrol;
  ocurs: Tcursor;
begin
  //////   curcontrol := GetFocusedControl;
  if Fdisplaying then
  begin
    messagebeep(MB_OK);
    exit;
  end;
  if umagdisplaymgr.FcurSelectedImageObj = nil then
  begin
    winmsg(mmsglistwin, 'Need to select an Image before ''Open''.');
    exit;
  end;
  Iobj := umagdisplaymgr.FCurSelectedImageObj;
  if (Iobj = nil) then
  begin
    winmsg(mmsglistwin, 'Error : Data Object for selected Image is empty.');
    exit;
  end;
  xmsg := Iobj.ExpandedDescription();
  if Iobj.IsImageGroup then
    grpmsg := 'Group '
  else
    grpmsg := '';
  Fdisplaying := true;
  update;
  try

    tlbrImageListMain.enabled := false;
    tlbrImageListMain.update;
    winmsg(mmsglistwin, ' Opening ' + grpmsg + ': ' + Iobj.ExpandedDescription(false) + '  ...');

    LogActions('IMAGE-LIST', 'IMAGE', 'DFN-' + Fdfn);
    CursorChange(ocurs, crHourGlass); //        Screen.cursor := crHourGlass;
    if pnlfullres.Visible then
      retmsg := OpenSelectedImage(Iobj, displayflag, 0, 1, 0, false, false, self.ListWinFullViewer)
    else
      retmsg := OpenSelectedImage(Iobj, displayflag, 0, 1, 0);
    if magpiece(retmsg, '^', 1) = '0' then
      xmsg := grpmsg + Iobj.ExpandedIDDescription(false) + ' ' + magpiece(retmsg, '^', 2)
    else
      xmsg := grpmsg + Iobj.ExpandedDescription(false) + '  Opened.';
    winmsg(mmsglistwin, xmsg);

  finally
    cursorRestore(ocurs); //         Screen.cursor := crDefault;
    tlbrImageListMain.enabled := true;
    Fdisplaying := false;
    //winmsg(mmsglistwin, xmsg);
    if FMaintainfocus then
      self.SetFocus; ////curcontrol.SetFocus;
  end;
end;

procedure TfrmImageList.CurrentImageReport;
var
  Iobj: TImageData;
  rstat: boolean;
  rmsg: string;
begin
  Iobj := umagdisplaymgr.FCurSelectedImageObj;
  if (Iobj = nil) then
    exit;
  LogActions('IMAGE-LIST', 'REPORT', 'DFN-' + Fdfn);
  if ImageDeletedThisSession(Iobj, false) then
  begin
    messagebeep(0);
    winmsg(mmsglistwin, 'Image has been deleted this session :   ' +
      Iobj.ExpandedIDDescription);
    exit;
  end;
  dmod.MagUtilsDB1.ImageReport(IObj, rstat, rmsg);
  //if FMaintainfocus then frmImageList.setfocus;
end;

procedure TfrmImageList.CurrentImageDelete;
var
  rstat: boolean;
  rmsg: string;
begin
  if FCurSelectedImageObj <> nil then
  begin
    if (FCurSelectedImageObj.ServerName <> dmod.MagDBBroker1.GetServer) or
      (FCurSelectedImageObj.ServerPort <> dmod.MagDBBroker1.GetListenerPort) then
    begin
      //maggmsgf.MagMsg('DI', 'You cannot delete an image from a remote site');
      MagLogger.MagMsg('DI', 'You cannot delete an image from a remote site'); {JK 10/5/2009 - Maggmsgu refactoring}
      exit;
    end;
    //logmsg('s', 'Attempting deletion of ' + FCurSelectedImageObj.ffile +
    //    '  IEN ' + FCurSelectedImageObj.Mag0);
    MagLogger.LogMsg('s', 'Attempting deletion of ' + FCurSelectedImageObj.ffile +
      '  IEN ' + FCurSelectedImageObj.Mag0); {JK 10/6/2009 - Maggmsgu refactoring}
    if MgrImageDelete(FCurSelectedImageObj, rmsg) then
    begin
      LogActions('IMAGELIST', 'DELETE', FCurSelectedImageObj.Mag0);
      { TODO -cSynchronize Status : NEED TO REFRESH THE ICONS IN THE IMAGE TREE VIEW
        ListView, TreeView, FullRes Local, Full Res Window  etc.... AbsLocal, Abs Window
      need to use the Publish Subscribe for changing status, state, etc.}
      { TODO -cSynchronize Status : NEED TO DO SOMETHING WHEN THE ABSTRACT IS DELETED.  }

      if self.pnlMagListView.visible then
        Self.MagListView1.ImageStatusChange(FCurSelectedImageObj,
          umagdefinitions.mistDeleted);
      // self.MagTreeView1.
      self.ListWinAbsViewer.RemoveOneFromList(FCurSelectedImageObj);
      if pnlfullres.Visible then
        self.ListWinFullViewer.RemoveOneFromList(FCurSelectedImageObj);
      //// abs window, full window... need to use the Publish Subscribe for changing status, state, etc.
    end;
  end
  else
    winmsg(mmsglistwin, 'Select an Image, then select the ''Delete'' option');
end;

procedure TfrmImageList.CurrentImageInformationAdvanced;
begin
  if FCurSelectedImageObj <> nil then
    //        frmMain.ShowimageinfoSys(FCurSelectedImageObj);
    OpenImageInfoSys(FCurSelectedImageObj);
end;

procedure TfrmImageList.CurrentImageCache;
begin
  if FCurSelectedImageObj <> nil then
    CacheFromImageListWindow(FCurSelectedImageObj)
  else
    winmsg(mmsglistwin, 'Current Selected Image = nil');
end;

procedure TfrmImageList.mnuClose1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmImageList.fontDlgReportPopup(Sender: TObject);
begin
  mnuRptWordWrap.Checked := memreport.WordWrap;
end;

procedure TfrmImageList.mnuRptWordWrapClick(Sender: TObject);
begin
  memreport.WordWrap := mnuRptWordWrap.Checked;
end;

procedure TfrmImageList.mnuEvent6Click(Sender: TObject);
begin
  magtreeview1.LoadListFromMagImageList(magimagelist1, 'Event-12');
end;

///////////////////   end  ////////////////

(*
if key = VK_Return then
   begin
   i := strtoint(edit1.Text);
   self.MagListView1.ImageStateChange(maglistview1.GetSelectedImageObj,i);

   end;

if key = VK_Return then
   begin
   i := strtoint(edit2.Text);
   self.MagListView1.ImageStatusChange(maglistview1.GetSelectedImageObj,i);
   imglstListIcons.GetBitmap(i,speedbutton1.Glyph);
      imglstListIcons.GetBitmap(i,Image1.Picture.Bitmap);
   end;
*)

procedure TfrmImageList.mnuTESTAbsButtonDown1Click(Sender: TObject);
begin
  self.tbtnAbstracts.Down := true;
end;

procedure TfrmImageList.mnuTESTAbsButtonUp1Click(Sender: TObject);
begin
  self.tbtnAbstracts.Down := false;
end;

procedure TfrmImageList.mnuTESTShowAbschecked1Click(Sender: TObject);
begin
  mnuShowThumbNail.Checked := true;
end;

procedure TfrmImageList.mnuTESTShowAbsNotChecked1Click(Sender: TObject);
begin
  mnuShowThumbNail.Checked := false;
end;

procedure TfrmImageList.AbThmGetUprefFromMenuState;
var
  ai: integer;
begin
  if mnuShowThumbNail.Checked then
    upref.AbsShowWindow := mnuThumbNailWindow.Checked
  else
    upref.AbsShowWindow := false;
  if upref.AbsShowWindow then
  begin
    upref.StyleWhetherToShowAbs := 1; { 0 No Show,  1  Show. }
    upref.StylePositionOfAbs := 3;
    { 0 Left, 1 bottom, 2 in Tree.  - 3 Abs Window }
  end
  else
  begin
    if mnuShowThumbNail.Checked then
      upref.StyleWhetherToShowAbs := 1
    else
      upref.StyleWhetherToShowAbs := 0;
    if mnuThumbsBottomTree2.Checked then
      ai := 2
    else if mnuThumbsLeft2.Checked then
      ai := 0
    else
      ai := 1;
    upref.StylePositionOfAbs := ai;
  end;
end;

procedure TfrmImageList.AbThmGetUprefFromGUI;
var
  ai: integer;
begin
  if DoesFormExist('frmMagAbstracts') then
    upref.AbsShowWindow := frmMagAbstracts.Visible
  else
    upref.AbsShowWindow := false;
  if upref.AbsShowWindow then
  begin
    upref.StyleWhetherToShowAbs := 1; { 0 No Show,  1  Show. }
    upref.StylePositionOfAbs := 3;
    { 0 Left, 1 bottom, 2 in Tree.  - 3 Abs Window }
  end
  else
  begin
    if self.pnlAbs.Visible then
      upref.StyleWhetherToShowAbs := 1
    else
      upref.StyleWhetherToShowAbs := 0;
    if self.pnlAbs.Parent = self.pnlTree then
      ai := 2
    else if self.pnlAbs.Align = alleft then
      ai := 0
    else
      ai := 1;
    upref.StylePositionOfAbs := ai;
  end;
end;

procedure TfrmImageList.AbThmGetMenuStateFromGUI;
var
  ai: integer;
begin
  mnuShowThumbNail.Checked := false;
  mnuThumbsBottom2.Checked := false;
  mnuThumbsLeft2.Checked := false;
  mnuThumbsBottomTree2.Checked := false;
  mnuThumbNailWindow.Checked := false;
  mnuThumbsRefresh2.Checked := false;

  if DoesFormExist('frmMagAbstracts') then
    mnuShowThumbNail.Checked := frmMagAbstracts.Visible;
  if mnuShowThumbNail.Checked then
  begin
    {   The abs window is visible }
    mnuThumbNailWindow.Checked := true;
    tbtnAbstracts.Down := true;
  end
    {   The abs window isn't visible.}
  else
  begin
    mnuShowThumbNail.Checked := self.pnlAbs.Visible;
    tbtnAbstracts.Down := self.pnlAbs.Visible;

    mnuThumbsBottomTree2.Checked := (pnlAbs.Parent = self.pnlTree);
    if not mnuThumbsBottomTree2.Checked then
    begin
      mnuThumbsBottom2.Checked := (pnlabs.Align = albottom);
      mnuThumbsLeft2.Checked := (pnlabs.Align = alleft);
    end;
  end;
end;

procedure TfrmImageList.AbThmGetMenuStateFromUpref;
var
  ai: integer;
begin
  mnuShowThumbNail.Checked := false;
  mnuThumbsBottom2.Checked := false;
  mnuThumbsLeft2.Checked := false;
  mnuThumbsBottomTree2.Checked := false;
  mnuThumbNailWindow.Checked := false;
  mnuThumbsRefresh2.Enabled := false;

  mnuShowThumbNail.Checked := (upref.StyleWhetherToShowAbs = 1);
  tbtnAbstracts.Down := (upref.StyleWhetherToShowAbs = 1);
  mnuThumbsRefresh2.Enabled := (upref.StyleWhetherToShowAbs = 1);
  mnuThumbNailWindow.checked := (upref.StylePositionOfAbs = 3);
  mnuThumbsBottomTree2.Checked := (upref.StylePositionOfAbs = 2);
  mnuThumbsBottom2.Checked := (upref.StylePositionOfAbs = 1);
  mnuThumbsLeft2.Checked := (upref.StylePositionOfAbs = 0);

end;

procedure TfrmImageList.AbThmShowThm;
begin
  if pnlAbs.Parent = pnlTree then
    AbThmThumbsBottomTree
  else if pnlAbs.Align = albottom then
    AbThmThumbsBottom
  else
    AbThmThumbsLeft;
  if not tbtnAbstracts.Down then
    if (tbtnAbstracts.Tag <> -1) then
      tbtnAbstracts.Down := true;
end;

procedure TfrmImageList.AbThmHideThm;
begin
  pnlAbs.Visible := false;
  splpnlabs.Visible := false;
  splpnlabs.Align := alnone;
  splpnlabstree.Visible := false;
  splpnlabstree.Align := alnone;
end;

procedure TfrmImageList.AbThmLINKThumbNails(value: boolean; vmagimagelist:
  Tmagimagelist);
begin
  {   value = false, we are unlinking the ThumbViewer }
  if not value then
  begin
    if listwinabsviewer.MagImageList <> nil then
    begin
      listWinAbsViewer.MagImageList.Detach_(listwinabsviewer);
      listwinabsviewer.MagImageList := nil;
    end;
    {   always clear a viewer when unlinking.}
    ListWinAbsViewer.ClearViewer;
    exit;
  end;

  {    value = true, we are Linking the ThumbViewer}
  {   Assure the MagViewer for Abs is attached to magimagelist in this window.}
  if listwinabsviewer.MagImageList <> nil then
    if listwinabsviewer.magimagelist <> vmagimagelist then
    begin
      listWinAbsViewer.MagImageList.Detach_(listwinabsviewer);
      listwinabsviewer.MagImageList := nil;
      ListWinAbsViewer.ClearViewer;
    end;

  if listwinabsviewer.magimagelist <> vmagimagelist then
  begin
    {    we don't need to 'Attach'.  The Property setter 'SetMagImageList..', does that for us.}
    ListWinAbsViewer.MagImageList := vmagimagelist;
  end;
  ListWinAbsViewer.UpDate_('1', self);

end;

procedure TfrmImageList.AbThmGetUprefFromMenu;
begin

end;

procedure TfrmImageList.enableAbsButton1Click(Sender: TObject);
begin
  self.tbtnAbstracts.Enabled := true;
end;

procedure TfrmImageList.DisableAbsButton1Click(Sender: TObject);
begin
  self.tbtnAbstracts.Enabled := false;
end;

procedure TfrmImageList.tabctrlFiltersChanging(Sender: TObject; var AllowChange:
  Boolean);
var
  vfilter, oldfilter: TImageFilter;
  s: string;
  isvis: boolean;
begin
  isvis := pnlMagListView.Visible;
  oldFilter := FCurrentFilter;
  if isvis then
    self.FLastColumns := maglistview1.GetColumnWidths;
  //here  Friday 5/29/09
end;

procedure TfrmImageList.mnuListRefreshClick(Sender: TObject);
begin
  { change to same patient, forces a clear and reload.}
  if dmod.MagPat1.M_DFN <> '' then
    frmMain.ChangeToPatient(dMod.MagPat1.M_DFN);
end;

procedure TfrmImageList.CurrentImageSensitiveChange(value: boolean);
var
  rstat: boolean;
  rmsg: string;
  rlist: tStrings;
  fieldlist: tstrings;
  Iobj: TImageData;

  ocurs: Tcursor;
begin
  if FCurSelectedImageObj = nil then
  begin
    //maggmsgf.MagMsg('DI', 'You need to select an Image.');
    MagLogger.MagMsg('DI', 'You need to select an Image.'); {JK 10/5/2009 - Maggmsgu refactoring}
    exit;
  end;

  Iobj := FCurSelectedImageObj;
  try
    WinMsgClear;
    if messagedlg('Change ''Controlled Image'' to: ' + uppercase(magbooltostr(value)), mtconfirmation,
      [mbok, mbcancel], 0) = mrcancel then
    begin
      exit;
    end;
    CursorChange(ocurs, crHourGlass); //        screen.Cursor := crhourglass;

    rlist := Tstringlist.create;
    fieldlist := Tstringlist.create;

    fieldlist.Add('SENSIMG^^' + uppercase(magbooltostrint(value)));

    dmod.MagDBBroker1.RPMaggImageSetProperties(rstat, rmsg, rlist, fieldlist, FCurSelectedImageObj.Mag0,
      '');
    WinMsgClear;
    winmsg(mmsglistwin, rmsg);
    if rstat then
    begin
      maglistview1.ImageStateChange(FCurSelectedImageObj, umagdefinitions.mistateNeedsRefresh);
      magTreeview1.ImageStateChange(FCurSelectedImageObj, umagdefinitions.mistateNeedsRefresh);
    end
    else
    begin
      messagedlg('Change ''Controlled Image'' Failed : ' + rmsg, mtconfirmation, [mbok], 0);
    end;
  finally
    cursorRestore(ocurs); //         screen.Cursor := crDefault;
  end;
end;

procedure TfrmImageList.CurrentImageStatusChange(value: integer);
var
  miscparams: Tstrings;
  rstat: boolean;
  rmsg: string;
  rlist: tStrings;
  fieldlist: tstrings;
  Iobj: TImageData;
  toStatus: string;
  resmsg, reason: string;
  ocurs: Tcursor;
begin
  reason := '';
  if FCurSelectedImageObj = nil then
  begin
    //maggmsgf.MagMsg('DI', 'You need to select an Image.');
    MagLogger.MagMsg('DI', 'You need to select an Image.'); {JK 10/5/2009 - Maggmsgu refactoring}
    exit;
  end;

  Iobj := FCurSelectedImageObj;
  try
    WinMsgClear;
    tostatus := magStatusDesc(value);
    //if messagedlg('Change Status of Image to : ' + tostatus, mtconfirmation, [mbok, mbcancel], 0) =
    //    mrcancel then
    //begin
    //    exit;
    //end;
    resmsg := '';
    if value <> mistVerified then
    begin
      winmsg(0, '');
      winmsg(1, 'Opening Status Reason selection...');
      reason := '';
      reason := frmReasonSelect.execute('S', dmod.MagDBBroker1,
        'Reason for Status Change:', 'Select Reason for change to: ' + tostatus,
        resmsg);
      if reason = '' then
        exit;
    end; // raise exception.Create(resmsg);
    CursorChange(ocurs, crHourGlass); //        screen.Cursor := crhourglass;
    rlist := Tstringlist.create;
    fieldlist := Tstringlist.create;
    case value of
      umagdefinitions.mistViewable: fieldlist.Add('ISTAT^^Viewable');
      umagdefinitions.mistVerified: fieldlist.Add('ISTAT^^QA Reviewed');
      umagdefinitions.mistNeedsReview: fieldlist.Add('ISTAT^^Needs Review');
    end;
    if reason <> '' then
      fieldlist.Add('ISTATRSN^^' + reason);

    dmod.MagDBBroker1.RPMaggImageSetProperties(rstat, rmsg, rlist, fieldlist, FCurSelectedImageObj.Mag0,
      '');
    WinMsgClear;
    winmsg(mmsglistwin, rmsg);
    if rstat then
    begin
      maglistview1.ImageStateChange(FCurSelectedImageObj, umagdefinitions.mistateNeedsRefresh);
      maglistview1.ImageStatusChange(FCurSelectedImageObj, value);
      magTreeview1.ImageStateChange(FCurSelectedImageObj, umagdefinitions.mistateNeedsRefresh);
      magTreeview1.ImageStatusChange(FCurSelectedImageObj, value);

    end
    else
    begin
      messagedlg('Change Status Failed : ' + rmsg, mtconfirmation, [mbok], 0);
    end;

  finally
    cursorRestore(ocurs); //         screen.Cursor := crDefault;
  end;
end;

procedure TfrmImageList.mnuSetImageStatusQAReviewedClick(Sender: TObject);
begin
  CurrentImageStatusChange(umagdefinitions.mistVerified);
end;

procedure TfrmImageList.mnuVerifyFull4Click(Sender: TObject);
begin
  CurrentImageStatusChange(umagdefinitions.mistVerified);
end;

procedure TfrmImageList.MagTreeView1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  viObj: TImageData;
  tn: Ttreenode;
  curx, cury: integer;
  curm: Tpoint;
  temp: tpoint;
  newsObj: TMagNewsObject;
  ocurs: Tcursor;
begin

  temp := magtreeview1.clienttoscreen(point(x, y));
  if not (ssright in Shift) then
    exit; //inForrightclick
{$IFDEF TESTMESSAGES}maggmsgf.MagMsg('', 'In MagTreeView1MouseDown(...');
{$ENDIF}
  try
    CursorChange(ocurs, crHourGlass);
    timersynctimer.Enabled := false;
    //outInRightClick    if not magtreeview1.autoselect then
    //outInRightClick        exit;
    //outInRightClick    if (FHitX = 0) and (FHitY = 0) then
    //outInRightClick        exit;
        /////////////////
     // we have client x and y now in parameters.   curm := magtreeview1.ScreenToClient(mouse.CursorPos);
    curm := point(x, y);
    {   the mouse has moved since the timer started.  This happens when the curson moves off of
       the MagTreeView control.  Nothing to disable the Timer.  }
//outInRightClick    if (curm.X <> FHitX) or (curm.Y <> FHitY) then
//outInRightClick        exit;

//outInRightClick    tn := magtreeview1.GetNodeAt(FHitX, FHitY);
    tn := magtreeview1.GetNodeAt(curm.x, curm.Y); //InForRightClick;

    if FCurTreeNode = tn then
      exit; //ISI is this working ?

    if tn = nil then
      exit;
    if tn.HasChildren then
      exit;
    if TMagTreeViewData(TN.Data) = nil then
      exit;
    { here so tn is a valid Node with a valid Iobj.}
    if FCurTreeNode = nil then
      FCurTreeNode := tn
    else if TMagTreeViewData(FCurTreenode.Data) = nil then
      FCurTreeNode := tn
    else if TMagTreeViewData(TN.Data).Iobj.Mag0 <>
      TMagTreeViewData(FCurTreenode.Data).Iobj.Mag0 then
      FCurTreeNode := tn;

    {FcurTreeNode is different than old, and is Valid}

    if FSyncImageON then { timerSyncTimerTimer }
    begin
      vIobj := (TMagTreeViewData(FCurTreeNode.Data).Iobj);
      if vIobj <> nil then
      begin
        newsObj := MakeNewsObject(mpubImageSelected, 0, vIobj.Mag0, vIobj, MagTreeView1);
        self.MagPublisher1.I_SetNews(newsobj);
      end;
    end;
    FcurTreeNode.Selected := true; //  this fires the Popup event.
{$IFDEF TESTMESSAGES}maggmsgf.MagMsg('', 'End of MagTreeView1MouseDown(...');
{$ENDIF}

  finally
    //  popupVImage.PopupComponent := Mag4Viewer1.GetCurrentImage;
    //  popupVImage.popup(pt.x,pt.y);
    cursorRestore(ocurs); //         screen.Cursor := crdefault;
    PopupTree.PopupComponent := MagTreeView1;
    PopupTree.popup(temp.x + 5, temp.y + 5);
  end;
end;

procedure TfrmImageList.mnuImageIndexEditAbs3Click(Sender: TObject);
begin
  CurrentImageIndexEdit;
end;

procedure TfrmImageList.mnuImageIndexEditFull4Click(Sender: TObject);
begin
  CurrentImageIndexEdit;
end;

procedure TfrmImageList.estingAddImagetoViewer1Click(Sender: TObject);
var
  col, row: integer;
begin

  col := self.ListWinFullViewer.ColumnCount + 1;
  row := self.ListWinFullViewer.RowCount;
  {        procedure SetRowColCount(r, c: integer; ImageToDisplayIndex: integer =
              -1);}
  self.ListWinFullViewer.SetRowColCount(row, col);

  //ViewSelectedItemImage;
  CurrentImageOpen();
end;

procedure TfrmImageList.mnuTestSyncAllClick(Sender: TObject);
begin
  SyncAllWithCurrent
end;

procedure TfrmImageList.ImageIndexEdit1Click(Sender: TObject);
begin
  CurrentImageIndexEdit;
end;

procedure TfrmImageList.mnuImageIndexEditTree6Click(Sender: TObject);
begin
  CurrentImageIndexEdit;
end;

procedure TfrmImageList.mnuSetImageStatusClick(Sender: TObject);
begin

  {   1:Viewable;2:QA Reviewed;10:In Progress;11:Needs Review;12:Deleted}

  mnuSetImageStatusViewable.Enabled := (FcurSelectedImageObj.MagStatus > 1);
  mnuSetImageStatusQAReviewed.Enabled := FcurSelectedImageObj.MagStatus <> 2;
  mnuSetImageStatusNeedsReview.Enabled := FcurSelectedImageObj.MagStatus <> 11;

end;

procedure TfrmImageList.mnuSetControlledImageClick(Sender: TObject);
begin
  //
  mnuSetControlledImageFalse.Enabled := fcurselectedimageobj.MagSensitive;
  mnuSetControlledImageTrue.Enabled := not mnuSetControlledImageFalse.Enabled;
end;

procedure TfrmImageList.mnuSetImageStatusViewableClick(Sender: TObject);
begin
  CurrentImageStatusChange(umagdefinitions.mistViewable);
end;

procedure TfrmImageList.mnuSetImageStatusNeedsReviewClick(Sender: TObject);
begin
  CurrentImageStatusChange(umagdefinitions.mistNeedsReview);
end;

procedure TfrmImageList.mnuSetControlledImageFalseClick(Sender: TObject);
begin
  CurrentImageSensitiveChange(false);
end;

procedure TfrmImageList.mnuSetControlledImageTrueClick(Sender: TObject);
begin
  CurrentImageSensitiveChange(true);
end;

procedure TfrmImageList.mnuAbsViewerScrollHorizClick(Sender: TObject);
begin
  ListWinAbsViewer.ScrollVertical := false;
  listwinabsviewer.scrlv.HorzScrollBar.Position := 0;
  listwinabsviewer.scrlv.VertScrollBar.Position := 0;
  listwinabsviewer.ReAlignImages();
end;

procedure TfrmImageList.mnuAbsViewerScrollVertClick(Sender: TObject);
begin
  ListWinAbsViewer.ScrollVertical := true;
  listwinabsviewer.scrlv.HorzScrollBar.Position := 0;
  listwinabsviewer.scrlv.VertScrollBar.Position := 0;
  listwinabsviewer.ReAlignImages();
end;

procedure TfrmImageList.mnuAbsViewerScrollClick(Sender: TObject);
begin
  mnuAbsViewerScrollHoriz.Checked := not ListWinAbsViewer.ScrollVertical;
  mnuAbsViewerScrollVert.Checked := ListWinAbsViewer.ScrollVertical;
end;

procedure TfrmImageList.mnuTestsetcoolbandBreakClick(Sender: TObject);
begin
  self.magViewerTB81.CoolBar1.Bands[1].Break := not self.magViewerTB81.CoolBar1.Bands[1].Break;
end;

procedure TfrmImageList.MagSubscriber_MsgsSubscriberUpdate(newsObj: TMagNewsObject);
var
  pnl: integer;
begin

  try
    //if Self.Visible then
    if newsObj.NewsCode = mpubMessages then
    begin
      pnl := mmsgpublish;
      if newsobj.NewsTopic <> 0 then
        pnl := newsobj.NewsTopic;
      winmsg(pnl, newsObj.NewsStrValue);
    end;
  except
    on E: Exception do
      Showmessage('TfrmImageList.MagSubscriber_MsgsSubscriberUpdate exception = ' + E.Message);
  end;
end;

procedure TfrmImageList.TestFixFullRes;
var
  frt, lvt, lvh, frh, winh, wint, before: string;
begin
  frt := inttostr(self.pnlfullres.Top);
  frh := inttostr(self.pnlfullres.Height);
  lvt := inttostr(self.pnlMagListView.Top);
  lvh := inttostr(self.pnlMagListView.Height);
  wint := inttostr(self.Top);
  winh := inttostr(self.Height);

  before := 'lvt' + lvt + #13 +
    'lvh' + lvh + #13 +
    'frt' + frt + #13 +
    'frh' + frh + #13 +
    'wint' + wint + #13 +
    'winh' + winh;

  self.fixFullResPosition;
  frt := inttostr(self.pnlfullres.Top);
  frh := inttostr(self.pnlfullres.Height);
  lvt := inttostr(self.pnlMagListView.Top);
  lvh := inttostr(self.pnlMagListView.Height);
  wint := inttostr(self.Top);
  winh := inttostr(self.Height);

  showmessage('Before : ' + #13 + before + #13 +
    'After : ' + #13 +
    'lvt' + lvt + #13 +
    'lvh' + lvh + #13 +
    'frt' + frt + #13 +
    'frh' + frh + #13 +
    'wint' + wint + #13 +
    'winh' + winh);
end;

procedure TfrmImageList.FormShow(Sender: TObject);
begin
  self.FixFullResPosition;

end;

procedure TfrmImageList.mnuTestFixFullRespanelClick(Sender: TObject);
begin
  self.FixFullResPosition;
end;

procedure TfrmImageList.mnuFileImagePrintClick(Sender: TObject);
begin
  ImagePrintListWin;
end;

procedure TfrmImageList.ImagePrintListWin;
var
  s: string;
  vgear: TMag4VGear;
  haveGear: boolean;
begin
  havegear := false;
  if self.pnlfullres.Visible then
    vgear := self.listwinfullviewer.GetCurrentImage;
  havegear := (vgear <> nil);
  if havegear then
  begin
    //  stBarInfo.Panels[1].Text := 'Printing: ' + vgear.PI_ptrData.ExpandedDescription + ' . . . ';
    ImagePrintEsigReason(vgear);
    //  stBarInfo.Panels[1].Text := '';
  end
  else
  begin
    //maggmsgf.MagMsg('di','To Print, you need to select an Open Image.');
    MagLogger.MagMsg('di', 'To Print, you need to select an Open Image.'); {JK 10/5/2009 - Maggmsgu refactoring}
  end;
end;

procedure TfrmImageList.mnuShowDeletedImageInformationClick(Sender: TObject);
begin
  {/ P117 - JK 8/31/2010 /}
  {/p117 gek 11/23/2010  use UserPreference to determine if show Deleted Images.}
 upref.UseDelImagePlaceHolder :=   mnuShowDeletedImageInformation.Checked ;    //p117 gek

 FCurrentFilter.ShowDeletedImageInfo             := upref.UseDelImagePlaceHolder;
 dmod.MagPat1.M_IncDeletedImageCount             := upref.UseDelImagePlaceHolder;
//p117 gek  no need to set this now. umagdisplaymgr.ShowDeletedImagePlaceholderInfo  := upref.UseDelImagePlaceHolder;

 frmmain.ChangeToPatient(dmod.MagPat1.M_DFN);


(*  if mnuShowDeletedImageInformation.Checked then
    FCurrentFilter.ShowDeletedImageInfo := True
  else
    FCurrentFilter.ShowDeletedImageInfo := False;

  dmod.MagPat1.M_IncDeletedImageCount := FCurrentFilter.ShowDeletedImageInfo; {/ P117 - JK 10/5/2010 /}
  frmmain.ChangeToPatient(dmod.MagPat1.M_DFN);

  umagdisplaymgr.ShowDeletedImagePlaceholderInfo := FCurrentFilter.ShowDeletedImageInfo;  {/ P117 - JK 9/21/2010 /}
  *)
end;

procedure TfrmImageList.ImageCopyListWin;
var
  s: string;
  vgear: TMag4VGear;
  haveGear: boolean;
begin
  havegear := false;
  if self.pnlfullres.Visible then
    vgear := self.listwinfullviewer.GetCurrentImage;
  havegear := (vgear <> nil);
  if havegear then
  begin
    // stBarInfo.Panels[1].Text := 'Copying: ' + vgear.PI_ptrData.ExpandedDescription + ' . . . ';
    ImageCopyEsigReason(vgear);
    //  stBarInfo.Panels[1].Text := '';
  end
  else
  begin
    //maggmsgf.MagMsg('di','To Copy, you need to select an Open Image.');
    MagLogger.MagMsg('di', 'To Copy, you need to select an Open Image.'); {JK 10/5/2009 - Maggmsgu refactoring}
  end;
end;

procedure TfrmImageList.magViewerTB81CopyClick(sender: TObject;
  Viewer: TMag4Viewer);
begin
  ImageCopyListWin;
end;

procedure TfrmImageList.magViewerTB81PrintClick(sender: TObject;
  Viewer: TMag4Viewer);
begin
  ImagePrintListWin;
end;

procedure TfrmImageList.mnuFileImageCopyClick(Sender: TObject);
begin
  ImageCopyListWin;
end;

procedure TfrmImageList.mnuListQAReviewClick(Sender: TObject);
var
  newsobj: TmagNewsObject;
begin
  //    application.CreateForm(TfrmGenImageList, frmGenImageList);
  //    upreftoVerifywin(upref);
  //    application.ProcessMessages;
  //    {JK 1/5/2009 - fixed defect #36}
  //    frmGenImageList.fduz := duz;
  //    frmGenImageList.Showmodal;
  newsObj := MakeNewsObject(mpubImageUnSelectAll, 0, '0', nil, nil);
  //logmsg('s', 'Publishing mpubImageUnSelectAll in ImagesForTIUNote');
  MagLogger.LogMsg('s', 'Publishing mpubImageUnSelectAll in ImagesForTIUNote'); {JK 10/6/2009 - Maggmsgu refactoring}
  frmImageList.MagPublisher1.I_SetNews(newsobj); //procedure ImagesForCPRSTIUNote
	{/117 gek  decouple frmVerify from dmod.}
  frmVerify.execute(upref, duz, dmod.MagDBBroker1);  //117

end;

procedure TfrmImageList.mnuListQAReviewReportClick(Sender: TObject);
begin
  OpenVerifyReport(Self, '', '', '');  {/ P117 - JK 8/30/2010 - added Self param /}
end;

procedure TfrmImageList.mnuFocusTreeClick(Sender: TObject);
begin
  if not pnlTree.Visible then
  begin
    TreeShow;
    self.Update;
    application.ProcessMessages;
  end;
  self.MagTreeView1.SetFocus;
end;

procedure TfrmImageList.mnuFocusAbsClick(Sender: TObject);
begin
  ShowHideThumbNails(true);
  self.Update;
  application.ProcessMessages;

  if doesformexist('frmMagAbstracts') and frmMagAbstracts.Visible then
  begin
    frmMagAbstracts.SetFocus;
    frmmagAbstracts.BringToFront;
    exit;
  end;
  if pnlAbs.Visible then
  begin
    ListWinAbsViewer.SetFocus;
  end;

end;

procedure TfrmImageList.mnuFocusListClick(Sender: TObject);
begin
  if not pnlMagListView.Visible then
  begin
    ListViewShow(true);
    self.Update;
    application.ProcessMessages;
  end;
  self.MagListView1.SetFocus;
end;

procedure TfrmImageList.mnuFocusFullClick(Sender: TObject);
begin
  mnuFullImageViewerWindowClick(self);
  exit;
  FullResLocalShow(true);
  self.Update;
  application.ProcessMessages;

  if doesformexist('frmFullRes') and frmFullRes.Visible then
  begin
    frmFullRes.SetFocus;
    frmFullRes.BringToFront;
    exit;
  end;
  if pnlfullres.Visible then
  begin
    ListWinfullviewer.SetFocus;
  end;

end;

procedure TfrmImageList.mnuFocusShowClick(Sender: TObject);
begin
  self.pnlfocus.Visible := true;
  ActiveControlChangedListWin(nil);
end;

procedure TfrmImageList.FocusNextControl1Click(Sender: TObject);
var
  wc: TWincontrol;
  wcn: string;
begin
  wc := screen.ActiveControl;
  wcn := wc.Name;

  if wcn = 'MagListView1' then
    ListWinAbsViewer.SetFocus
  else if wcn = 'MagTreeView1' then
    MagListView1.SetFocus
  else if wcn = 'ListWinAbsViewer' then
    MagTreeView1.SetFocus

end;

procedure TfrmImageList.GenGoToNextControl(edt: TWinControl = nil);
var
  tl: Tlist;
  i: integer;
  smsg, s: string;
  nextctrlok: boolean;
begin
  //cap  if not FAutoTab then Exit;      //WPR AUTO
  //FindNextControl(edt, true, true, true).setfocus;
  tl := Tlist.create;
  smsg := '';
  try
    self.GetTabOrderList(tl);
    if edt = nil then
    begin
      // self.pnlLeft.GetTabOrderList(tl);

    (* testing see ctrls in list *)
//             memo1.Lines.Add('Gen Control List     -------------------- ') ;
      for i := 0 to tl.count - 1 do
      begin
        s := TWincontrol(tl[i]).name;

        if TWincontrol(tl[i]).enabled then
          s := s + ' --Enbld';
        if TWincontrol(tl[i]).visible then
          s := s + ' --Vsble';
        if TWincontrol(tl[i]).TabStop then
          s := s + ' -- TabStop';

        //           memo1.lines.Add(s);
      end;
      //smsg := smsg+(TWincontrol(tl[i]).name)+#13;
      //showmessage(smsg);
      exit;
    end;

    i := tl.indexof(edt);
    nextctrlok := false;
    while not nextctrlok do
    begin
      i := i + 1;
      if (i > (tl.count - 1)) then
        break; // don't want to go around
      // testing see ctrls in list     showmessage(TWincontrol(tl[i]).name);
      if TWincontrol(tl[i]).enabled
        and TWincontrol(tl[i]).visible
        and TWincontrol(tl[i]).TabStop then
      begin
        nextctrlok := true;
        TWincontrol(tl[i]).setfocus;
      end;
    end;
  finally
    tl.free;
  end;
end;

procedure TfrmImageList.mnuFocusBarClick(Sender: TObject);
begin
  FUseFocusBar := mnuFocusBar.Checked;
  if not FUseFocusBar then
    pnlFocus.Visible := false;
end;

procedure TfrmImageList.NextControl1Click(Sender: TObject);

begin
  if self.ActiveControl.Name = 'igPageViewCtrl1' then
  begin
    if self.pnlMagListView.Visible then
    begin
      maglistview1.SetFocus;
      exit;
    end;
    if self.pnlTree.Visible then
    begin
      magtreeview1.SetFocus;
      exit;
    end;
    if self.pnlAbs.Visible then
    begin
      self.ListWinAbsViewer.SetFocus;
      exit;
    end;
    exit;
  end;

  self.GenGoToNextControl(self.ActiveControl);
end;

procedure TfrmImageList.mnuDClick(Sender: TObject);
begin
  self.Width := 1024;
  self.Height := 768;
end;

procedure TfrmImageList.setto1280x10241Click(Sender: TObject);
begin
  self.Width := 1280;
  self.Height := 1024;

end;

procedure TfrmImageList.dimensions1Click(Sender: TObject);
begin
  mnuCurrentSettings.Caption := 'Current :  w: ' + inttostr(self.Width) + 'h: ' + inttostr(self.Height);
end;

procedure TfrmImageList.mnuListHelpWhatNew93Click(Sender: TObject);
//begin
var
  whatsnew: string;
begin
  whatsnew := apppath + '\MagWhats New in Patch 93.pdf';
  {      the file is named : 'MagWhats New in Patch 93.pdf'}
  if fileexists(whatsnew) then
  begin
    MagExecuteFile(whatsnew, '', '', SW_SHOW);
  end
  else
    messagedlg('Help file for Patch 93 is missing.', mtconfirmation, [mbok], 0);
end;

{//p117 gek}
procedure TfrmImageList.mnuROIPrintOptionsClick(Sender: TObject);
begin
mnuROISelectImagestoPrint.Checked :=  pnlROIoptions.Visible;
end;

procedure TfrmImageList.mnuROISelectImagestoPrintClick(Sender: TObject);
begin
  if self.mnuROISelectImagestoPrint.Checked then
    {//117T1 gek,  User wants to see check box selection options on panel
                   So, we enable the checkbox property, and CheckAll images.}
    begin
      ROISelectionPanelShow(true);
      CountCheckedImagesToPrint;
    end
    else
    {//117T1 gek,  User wants to Hide check box selection options on panel
                   So, we check all images then Hide the Selection panel.}
    {//117 gek.  Design is that If we're not using CheckBox option,  all Images
                 will be printed.   The Code should not use 'checked' value if user
                 has clicked 'Print All'.}
    begin
      ROISelectionPanelShow(false);
    end;
end;

procedure TfrmImageList.ImageListCheckBoxCheckAll;
var i : integer;
begin
  for i := 0 to maglistview1.Items.Count - 1 do maglistview1.Items[i].Checked := true;
end;

procedure TfrmImageList.ImageListCheckBoxCheckNone;
var i : integer;
begin
  for i := 0 to maglistview1.Items.Count - 1 do maglistview1.Items[i].Checked := false;
end;

procedure TfrmImageList.ROISelectionPanelShow(value : boolean);
begin
     {When we first Enable the Check Box option, we check all images.}
      if value  then
      begin
      pnlROIoptions.Visible := True;
      ImageListCheckBoxEnable(True);
      ImageListCheckBoxCheckAll;
      end
      else
      begin
      ImageListCheckBoxCheckAll;
      ImageListCheckBoxEnable(False);
      pnlROIoptions.Visible := False;
    end;

end;

procedure TfrmImageList.ImageListCheckBoxEnable(value : boolean);
begin
if value then
  begin
  maglistview1.Checkboxes := true;
  maglistview1.StateImages := nil;
  maglistview1.SmallImages := nil;
  maglistview1.Invalidate;
  end
  else
  begin
  maglistview1.Checkboxes := false;
  maglistview1.StateImages := DMod.ImageListStateIcons;
  maglistview1.SmallImages := DMod.ImageListStatusIcons;
  maglistview1.Invalidate;
  end;
end;

procedure TfrmImageList.Printalllistedimages1Click(Sender: TObject);
begin
   {//117  Here, the user isn't using checboxes to select images from the list
   so we are going to print all images in the list.}
       winmsg(mmsglistwin, 'ROI Print initializing.');
         begin
         ROISelectionPanelShow(false);
         end;
       frmReleaseOfInfoPrint.Execute(false, MagListView1, self.FCurrentFilter,upref); //*** BB 08/24/2010 ***
end;

procedure TfrmImageList.lbCheckAllClick(Sender: TObject);
begin
  ImageListCheckBoxCheckAll;
  CountCheckedImagesToPrint
end;

procedure TfrmImageList.lbCheckNoneClick(Sender: TObject);
begin
  ImageListCheckBoxCheckNone;
  CountCheckedImagesToPrint
end;

procedure TfrmImageList.lbCheckAllMouseEnter(Sender: TObject);
begin
  lbCheckAll.font.Color := CLBlue;
end;

procedure TfrmImageList.lbCheckAllMouseLeave(Sender: TObject);
begin
  lbCheckAll.font.color := clblack;
end;

procedure TfrmImageList.lbCheckNoneMouseEnter(Sender: TObject);
begin
  lbCheckNone.Font.Color := CLBlue;
end;

procedure TfrmImageList.lbCheckNoneMouseLeave(Sender: TObject);
begin
  lbCheckNone.font.color := clblack;
end;

procedure TfrmImageList.btnCancelCheckBoxSelectionClick(Sender: TObject);
begin
  ImageListCheckBoxCheckAll;
  ImageListCheckBoxEnable(False);
  pnlROIoptions.Visible := False;
end;

procedure TfrmImageList.btnCheckAllClick(Sender: TObject);
begin
  ImageListCheckBoxCheckAll;
  MagListView1.Update;
  CountCheckedImagesToPrint
end;

procedure TfrmImageList.btnCheckNoneClick(Sender: TObject);
begin
  ImageListCheckBoxCheckNone;
  MagListView1.Update;
  CountCheckedImagesToPrint ;
end;

procedure TfrmImageList.CountCheckedImagesToPrint();
var i, ctr: integer;
begin
  {/117T1  add count of number of checked images.}
  ctr := 0;
  for i := 0 to MagListView1.Items.Count - 1 do
    if MagListView1.Items[i].Checked then ctr := ctr + 1;
  lbCheckedImageCount.Caption := inttostr(ctr) + ' Item(s) selected to print';
  lbCheckedImageCount.Update;
end;
end.

