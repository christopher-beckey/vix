Unit FmagRadViewer;
(*
        ;; +---------------------------------------------------------------------------------------------------+
        ;;  MAG - IMAGING
        ;;  Property of the US Government.
        ;;  WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
        ;;  No permission to copy or redistribute this software is given.
        ;;  Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;;
        ;;  Date created: June 2006
        ;;  Site Name:  Washington OI Field Office, Silver Spring, MD
        ;;  Developer:  Julian Werfel
        ;;  Description: This is the Radiology/DICOM Viewer container. It holds
        ;;  the Mag4Viewer and MagStackViewer components for Radiology use.
        ;;
        ;;+---------------------------------------------------------------------------------------------------+
*)

Interface

Uses
  Classes,
  cMag4Vgear,
  cmag4viewer,
  //cMagLogManager, {JK 10/5/2009 - Maggmsgu refactoring - deprecated unit}
//RCA  Maggmsgu,
  imaginterfaces,
  cMagPat,
  cMagStackViewer,
  cMagUtilsDB,
  cMagViewerRadTB2,
  Controls,
  Dialogs,
  ExtCtrls,
  Forms,
  Graphics,
  IMagViewer,
  Menus,
  SysUtils,
  UMagClasses,
  UMagClassesAnnot,
  UMagDefinitions,
  ImgList    ,
  XRefUtilsLib_TLB,
  fMagRadScoutViewer,  
  uMagRadHeaderLoader,
  IMagPanWindow  ,
  fmagFullResSpecial          {p149}
  ;

//Uses Vetted 20090929:ImgList, cMagIGManager, cMagViewerTB, StdCtrls, ExtDlgs, maggut1, fMagImageInfoSys, cMagImageList, Variants, Messages, Windows, umagutils, printers, fMagAnnotationoptions, magRemoteInterface, fMagLog, cMagImageUtility, magImageManager, fmagDicomTxtFile, fmagDicomdir, fMagAbout, fMagRadiologyImageInfo, fMagCineView, fMagRadImageInfo, MagPositions

Type
  TMagRadViewMode = (MagrvStack1, MagrvStack2, MagrvLayout32, MagrvLayout43);

Type
  TMagStudyDetails = Class
  Public
    StudyList: Tlist;
    RootImg: TImageData;
    Studydesc: String;
    CurrentImage: Integer;
  End;

Type
  TfrmRadViewer = Class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    ViewSettings1: TMenuItem;
    MnuViewSettings1x1: TMenuItem;
    MnuViewSettings2x1: TMenuItem;
    MnuViewSettings3x2: TMenuItem;
    MnuViewSettings4x3: TMenuItem;
    TimerReSize: TTimer;
    MnuFullRes: TMenuItem;
    MnuFullResView: TMenuItem;
    MnuViewInfo: TMenuItem;
    MnuViewInfoImageInfo: TMenuItem;
    MnuBar1: TMenuItem;
    OpenDialog1: TOpenDialog;
    MnuTools: TMenuItem;
    MnuToolsCine: TMenuItem;
    MnuFileCopy: TMenuItem;
    MnuFilePrint: TMenuItem;
    MnuFileReport: TMenuItem;
    N1: TMenuItem;
    MnuViewInfoRadiologyImageInfo: TMenuItem;
    MnuImage: TMenuItem;
    MnuImageInvert: TMenuItem;
    MnuImageResetImage: TMenuItem;
    MnuRotate: TMenuItem;
    MnuRotateClockwise90: TMenuItem;
    MnuRotateMinus90: TMenuItem;
    MnuRotate180: TMenuItem;
    MnuRotateBar1: TMenuItem;
    MnuRotateFlipHorizontal: TMenuItem;
    MnuRotateFlipVertical: TMenuItem;
    MnuCTPresets: TMenuItem;
    MnuCTPresetsAbdomen: TMenuItem;
    MnuCTPresetsBone: TMenuItem;
    MnuCTPresetsDisk: TMenuItem;
    MnuCTPresetsHead: TMenuItem;
    MnuCTPresetsLung: TMenuItem;
    MnuCTPresetsMediastinum: TMenuItem;
    MnuViewInfoInformationAdvanced: TMenuItem;
    MnuCTBar1: TMenuItem;
    MnuCTBar2: TMenuItem;
    MnuCTConfigure: TMenuItem;
    MnuCTCustom1: TMenuItem;
    MnuCTCustom2: TMenuItem;
    MnuCTCustom3: TMenuItem;
    MnuFileOpenImage: TMenuItem;
    MnuFileCloseSelected: TMenuItem;
    MnuFileDirectory: TMenuItem;
    MnuFileClearAll: TMenuItem;
    MnuHelp: TMenuItem;
    MnuHelpAbout: TMenuItem;
    MnuOptions: TMenuItem;
    MnuOptionsStackView: TMenuItem;
    MnuOptionsLayoutView: TMenuItem;
    MnuOptionsStackPageTogether: TMenuItem;
    MnuOptionsLayoutSelectedWindowSettings: TMenuItem;
    MnuOptionsLayoutIndividualImageSettings: TMenuItem;
    MnuOptionsStackBar1: TMenuItem;
    MnuOptionsStackPageWithDifferentSettings: TMenuItem;
    MnuOptionsStackPageWithSameSettings: TMenuItem;
    MnuOptionsStackPageWithImageSettings: TMenuItem;
    Openin2ndStack1: TMenuItem;
    MnuViewInfoDICOMHeader: TMenuItem;
    MnuImageBar1: TMenuItem;
    MnuImageCacheStudy: TMenuItem;
    MnuViewInfotxtFile: TMenuItem;
    MnuToolsRuler: TMenuItem;
    MnuToolsRulerEnabled: TMenuItem;
    MnuToolsRulerPointer: TMenuItem;
    MnuToolsRulerBar1: TMenuItem;
    MnuToolsRulerDeleteSelected: TMenuItem;
    MnuToolsrulerClearAll: TMenuItem;
    MnuToolsPixelValues: TMenuItem;
    MnuOptionsImageSettings: TMenuItem;
    MnuOptionsImageSettingsDevice: TMenuItem;
    MnuOptionsImageSettingsHistogram: TMenuItem;
    OpenURL1: TMenuItem;
    MnuOptionsLabelsOn: TMenuItem;
    MnuToolsLog: TMenuItem;
    MnuImageResetAll: TMenuItem;
    MnuToolsProtractorEnabled: TMenuItem;
    Mag4StackViewer1: TMag4StackViewer;
    Mag4StackViewer2: TMag4StackViewer;
    Mag4Viewer1: TMag4Viewer;
    MnuToolsRulerBar2: TMenuItem;
    MnuToolsRulerMeasurementOptions: TMenuItem;
    MnuHelpRadiologyViewer: TMenuItem;
    MnuView: TMenuItem;
    MnuViewGoToMainWindow: TMenuItem;
    MnuViewActivewindows: TMenuItem;
    MnuImageApplyToAll: TMenuItem;
    MnuImageZoom: TMenuItem;
    MnuImageMouse: TMenuItem;
    MnuImageMaximizeImage: TMenuItem;
    MnuImageZoomZoomIn: TMenuItem;
    MnuImageZoomZoomOut: TMenuItem;
    MnuImageZoomFittoWidth: TMenuItem;
    MnuImageZoomFittoHeight: TMenuItem;
    MnuImageZoomFittoWindow: TMenuItem;
    MnuImageZoomActualSize: TMenuItem;
    MnuImageMousePan: TMenuItem;
    MnuImageMouseMagnify: TMenuItem;
    MnuImageMouseZoom: TMenuItem;
    MnuImageMouseRuler: TMenuItem;
    MnuImageMouseAngleTool: TMenuItem;
    MnuImageMouseRulerAnglePointer: TMenuItem;
    MnuImageMouseAutoWindowLevel: TMenuItem;
    MnuImageBriCon: TMenuItem;
    MnuImageWinLev: TMenuItem;
    MnuImageBriConContrastUp: TMenuItem;
    MnuImageBriConContrastDown: TMenuItem;
    MnuImageBriConBrightnessUp: TMenuItem;
    MnuImageBriConBrightnessDown: TMenuItem;
    MnuImageWinLevWindowUp: TMenuItem;
    MnuImageWinLevWindowDown: TMenuItem;
    MnuImageWinLevLevelUp: TMenuItem;
    MnuImageWinLevLevelDown: TMenuItem;
    MnuViewBar1: TMenuItem;
    MnuViewPanWindow: TMenuItem;
    MnuImageScroll: TMenuItem;
    MnuImageScrollTopRight: TMenuItem;
    MnuImageScrollTopLeft: TMenuItem;
    MnuImageScrollBottomLeft: TMenuItem;
    MnuImageScrollBottomRight: TMenuItem;
    MnuImageScrollLeft: TMenuItem;
    MnuImageScrollRight: TMenuItem;
    MnuImageScrollUp: TMenuItem;
    MnuImageScrollDown: TMenuItem;
    ImageList1: TImageList;
    MnuImageBar2: TMenuItem;
    MnuImagePreviousImage: TMenuItem;
    MnuImageNextImage: TMenuItem;
    MnuViewBar2: TMenuItem;
    MnuViewStack2: TMenuItem;
    PopupMenu1: TPopupMenu;
    MnuImageFirstImage: TMenuItem;
    MnuImageLastImage: TMenuItem;
    MnuImageStackCine: TMenuItem;
    MnuImageStackCineStart: TMenuItem;
    MnuImageStackCineStop: TMenuItem;
    MnuImageStackCineBar1: TMenuItem;
    MnuImageStackCineSpeedUp: TMenuItem;
    MnuImageStackCineSlowDown: TMenuItem;
    MnuViewStack1: TMenuItem;
    MnuToolsRulerMeasurementProperties: TMenuItem;
    CineToolFocus1: TMenuItem;
    MnuImageStackCineBar2: TMenuItem;
    MnuImageStackCineRangeStart: TMenuItem;
    MnuImageStackCineRangeEnd: TMenuItem;
    MnuImageStackCineRangeClear: TMenuItem;
    MagViewerTB1: TmagViewerRadTB2;
    mnuOptionsMouseMagnifyShape: TMenuItem;
    mnuOptionsMouseMagnifyShapeCircle: TMenuItem;
    mnuOptionsMouseMagnifyShapeRectangle: TMenuItem;
    ImageGearVersion1: TMenuItem;
    TimerScreenShot: TTimer;
    Annotations1: TMenuItem;
    mnuScout: TMenuItem;
    mnuScoutDisplayScoutLines: TMenuItem;
    mnuScoutShowScoutWindow: TMenuItem;
    mnuScoutAutoDetectScoutImages: TMenuItem;
    mnuScoutBar1: TMenuItem;
    mnuTestStudyHolderStatus: TMenuItem;
    mnuScoutAddImagetoScoutWindow: TMenuItem;
    mnuScoutColor: TMenuItem;
    mnuScoutBar2: TMenuItem;
    mnuScoutColorRed: TMenuItem;
    mnuScoutColorBlue: TMenuItem;
    mnuScoutColorGreen: TMenuItem;
    mnuScoutColorYellow: TMenuItem;
    mnuTest: TMenuItem;
    mnuRGBChanger: TMenuItem;
    mnuRGBFull: TMenuItem;
    mnuRGBRed: TMenuItem;
    mnuRGBGreen: TMenuItem;
    mnuRGBBlue: TMenuItem;
    PrintOptions1: TMenuItem;          {p149}
    Procedure FormCreate(Sender: Tobject);
    Procedure FormResize(Sender: Tobject);
    Procedure MnuViewSettings1x1Click(Sender: Tobject);
    Procedure MnuViewSettings2x1Click(Sender: Tobject);
    Procedure MnuViewSettings3x2Click(Sender: Tobject);
    Procedure MnuViewSettings4x3Click(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure Mag4Viewer1ViewerImageClick(Sender: Tobject);
    Procedure Mag4Viewer1ViewerClick(Sender: Tobject; Viewer: TMag4Viewer;
      MagImage: TMag4VGear);
    Procedure TimerReSizeTimer(Sender: Tobject);
    Procedure MnuFullResViewClick(Sender: Tobject);
    Procedure MnuViewInfoImageInfoClick(Sender: Tobject);
    Procedure MnuToolsCineClick(Sender: Tobject);
    Procedure MnuFileCopyClick(Sender: Tobject);
    Procedure MnuFilePrintClick(Sender: Tobject);
    Procedure MnuFileReportClick(Sender: Tobject);
    Procedure MnuViewInfoRadiologyImageInfoClick(Sender: Tobject);
    Procedure Exit1Click(Sender: Tobject);
    Procedure MnuImageInvertClick(Sender: Tobject);
    Procedure MnuImageResetImageClick(Sender: Tobject);
    Procedure MnuRotateClockwise90Click(Sender: Tobject);
    Procedure MnuRotateMinus90Click(Sender: Tobject);
    Procedure MnuRotate180Click(Sender: Tobject);
    Procedure MnuRotateFlipHorizontalClick(Sender: Tobject);
    Procedure MnuRotateFlipVerticalClick(Sender: Tobject);
    Procedure MnuCTPresetsAbdomenClick(Sender: Tobject);
    Procedure MnuCTPresetsBoneClick(Sender: Tobject);
    Procedure MnuCTPresetsDiskClick(Sender: Tobject);
    Procedure MnuCTPresetsHeadClick(Sender: Tobject);
    Procedure MnuCTPresetsLungClick(Sender: Tobject);
    Procedure MnuCTPresetsMediastinumClick(Sender: Tobject);
    Procedure MnuViewInfoInformationAdvancedClick(Sender: Tobject);
    Procedure MnuCTCustom1Click(Sender: Tobject);
    Procedure MnuCTCustom2Click(Sender: Tobject);
    Procedure MnuCTCustom3Click(Sender: Tobject);
    Procedure MnuCTConfigureClick(Sender: Tobject);
    Procedure MnuFileOpenImageClick(Sender: Tobject);
    Procedure MnuFileClearAllClick(Sender: Tobject);
    Procedure MnuFileCloseSelectedClick(Sender: Tobject);
    Procedure MnuHelpAboutClick(Sender: Tobject);
    Procedure MnuOptionsLayoutIndividualImageSettingsClick(
      Sender: Tobject);
    Procedure MnuOptionsStackPageTogetherClick(Sender: Tobject);
    Procedure MnuOptionsLayoutSelectedWindowSettingsClick(Sender: Tobject);
    Procedure Openin2ndStack1Click(Sender: Tobject);
    Procedure MnuFileDirectoryClick(Sender: Tobject);
    Procedure MnuOptionsStackPageWithSameSettingsClick(Sender: Tobject);
    Procedure MnuOptionsStackPageWithImageSettingsClick(Sender: Tobject);
    Procedure MnuOptionsStackPageWithDifferentSettingsClick(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure MnuViewInfoDICOMHeaderClick(Sender: Tobject);
    Procedure MagViewerTB1CopyClick(Sender: Tobject; Viewer: IMag4Viewer);
    Procedure MagViewerTB1PrintClick(Sender: Tobject; Viewer: IMag4Viewer);
    Procedure MnuViewInfotxtFileClick(Sender: Tobject);
    Procedure MnuImageCacheStudyClick(Sender: Tobject);
    Procedure MnuToolsRulerEnabledClick(Sender: Tobject);
    Procedure MnuToolsRulerPointerClick(Sender: Tobject);
    Procedure MnuToolsRulerDeleteSelectedClick(Sender: Tobject);
    Procedure MnuToolsrulerClearAllClick(Sender: Tobject);
    Procedure MnuToolsPixelValuesClick(Sender: Tobject);
    Procedure MnuOptionsImageSettingsDeviceClick(Sender: Tobject);
    Procedure MnuOptionsImageSettingsHistogramClick(Sender: Tobject);
    Procedure OpenURL1Click(Sender: Tobject);
    Procedure MnuOptionsLabelsOnClick(Sender: Tobject);
    Procedure MnuToolsLogClick(Sender: Tobject);
    Procedure MnuImageResetAllClick(Sender: Tobject);
    Procedure MnuToolsProtractorEnabledClick(Sender: Tobject);
    Procedure MnuToolsRulerMeasurementOptionsClick(Sender: Tobject);
    Procedure MnuHelpRadiologyViewerClick(Sender: Tobject);
    Procedure MnuViewActivewindowsClick(Sender: Tobject);
    Procedure MnuViewGoToMainWindowClick(Sender: Tobject);
    Procedure MnuImageApplyToAllClick(Sender: Tobject);
    Procedure MnuImageBriConContrastUpClick(Sender: Tobject);
    Procedure MnuImageZoomZoomInClick(Sender: Tobject);
    Procedure MnuImageZoomZoomOutClick(Sender: Tobject);
    Procedure MnuImageZoomFittoWidthClick(Sender: Tobject);
    Procedure MnuImageZoomFittoHeightClick(Sender: Tobject);
    Procedure MnuImageZoomFittoWindowClick(Sender: Tobject);
    Procedure MnuImageZoomActualSizeClick(Sender: Tobject);
    Procedure MnuImageMousePanClick(Sender: Tobject);
    Procedure MnuImageMouseMagnifyClick(Sender: Tobject);
    Procedure MnuImageMouseZoomClick(Sender: Tobject);
    Procedure MnuImageMouseRulerClick(Sender: Tobject);
    Procedure MnuImageScrollTopLeftClick(Sender: Tobject);
    Procedure MnuImageScrollTopRightClick(Sender: Tobject);
    Procedure MnuImageNextImageClick(Sender: Tobject);
    Procedure MnuImagePreviousImageClick(Sender: Tobject);
    Procedure MnuImageScrollBottomRightClick(Sender: Tobject);
    Procedure MnuImageScrollBottomLeftClick(Sender: Tobject);
    Procedure MnuImageScrollLeftClick(Sender: Tobject);
    Procedure MnuImageScrollRightClick(Sender: Tobject);
    Procedure MnuImageScrollUpClick(Sender: Tobject);
    Procedure MnuImageScrollDownClick(Sender: Tobject);
    Procedure MnuImageMouseAngleToolClick(Sender: Tobject);
    Procedure MnuImageMouseRulerAnglePointerClick(Sender: Tobject);
    Procedure MnuImageMouseAutoWindowLevelClick(Sender: Tobject);
    Procedure MnuImageWinLevLevelUpClick(Sender: Tobject);
    Procedure MnuImageWinLevWindowUpClick(Sender: Tobject);
    Procedure MnuImageBriConContrastDownClick(Sender: Tobject);
    Procedure MnuImageBriConBrightnessDownClick(Sender: Tobject);
    Procedure MnuImageBriConBrightnessUpClick(Sender: Tobject);
    Procedure MnuImageWinLevWindowDownClick(Sender: Tobject);
    Procedure MnuImageWinLevLevelDownClick(Sender: Tobject);
    Procedure MnuViewPanWindowClick(Sender: Tobject);
    Procedure MnuViewStack1Click(Sender: Tobject);
    Procedure MnuViewStack2Click(Sender: Tobject);
    Procedure MnuImageFirstImageClick(Sender: Tobject);
    Procedure MnuImageLastImageClick(Sender: Tobject);
    Procedure MnuImageStackCineStartClick(Sender: Tobject);
    Procedure MnuImageStackCineStopClick(Sender: Tobject);
    Procedure MnuImageStackCineSpeedUpClick(Sender: Tobject);
    Procedure MnuImageStackCineSlowDownClick(Sender: Tobject);
    Procedure MnuImageMaximizeImageClick(Sender: Tobject);
    Procedure MnuToolsRulerMeasurementPropertiesClick(Sender: Tobject);
    Procedure CineToolFocus1Click(Sender: Tobject);
    Procedure MnuImageStackCineRangeStartClick(Sender: Tobject);
    Procedure MnuImageStackCineRangeEndClick(Sender: Tobject);
    Procedure MnuImageStackCineRangeClearClick(Sender: Tobject);
    Procedure mnuOptionsMouseMagnifyShapeCircleClick(Sender: Tobject);
    Procedure mnuOptionsMouseMagnifyShapeRectangleClick(Sender: Tobject);
    Procedure ImageGearVersion1Click(Sender: Tobject);
    Procedure FormShow(Sender: Tobject);
    Procedure TimerScreenShotTimer(Sender: Tobject);
    procedure Annotations1Click(Sender: TObject);
    procedure mnuRGBFullClick(Sender: TObject);
    procedure mnuRGBRedClick(Sender: TObject);
    procedure mnuRGBGreenClick(Sender: TObject);
    procedure mnuRGBBlueClick(Sender: TObject);
    procedure mnuScoutShowScoutWindowClick(Sender: TObject);
    procedure mnuTestStudyHolderStatusClick(Sender: TObject);
    procedure mnuScoutDisplayScoutLinesClick(Sender: TObject);
    procedure mnuScoutAutoDetectScoutImagesClick(Sender: TObject);
    procedure mnuImageAddToScoutWindowClick(Sender: TObject);
    procedure mnuScoutAddImagetoScoutWindowClick(Sender: TObject);
    procedure mnuScoutColorRedClick(Sender: TObject);
    procedure mnuScoutColorBlueClick(Sender: TObject);
    procedure mnuScoutColorGreenClick(Sender: TObject);
    procedure mnuScoutColorYellowClick(Sender: TObject);
    procedure PrintOptions1Click(Sender: TObject);          {p149}
  Private
    FViewMode: TMagRadViewMode;
    //FOnLogEvent : TMagLogEvent;  {JK 10/5/2009 - Maggmsgu refactoring}
    //FCurrentViewer : TMag4Viewer;
    FCurrentViewer: IMag4Viewer;
    FForDICOMViewer: Boolean;
    FOpenCompleted: Boolean;

    FCTPresets: TStrings;
    FConfigureCTEnabled: Boolean;
    FCurrentPatient: TMag4Pat;

    FStudy1: TMagStudyDetails;
    FStudy2: TMagStudyDetails;

    FisClosing: Boolean;
    DebugOn: Boolean;
    Msglist: TStrings;

    FMagAnnotationStyle: TMagAnnotationStyle;

    FNewLogin: Boolean;
    FPanWindowClose: TMagPanWindowCloseEvent;

    FScoutWindow1 : TfrmScoutViewer;
    FScoutWindow2 : TfrmScoutViewer;
    FScoutLineColor : TColor;

    FPanWindowHolder : TMagPanWindowHolder;

    Procedure SetViewMode(Value: TMagRadViewMode);
    Procedure ClearChecks();
    //procedure LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = magmsginfo);  {JK 10/6/2009 - Maggmsgu refactoring - remove old method}
    Procedure LogDICOMViewerMsg(Sender: Tobject; MsgType: String; Msg: String; Priority: TMagmsgPriority = MagmsgINFO);
    //procedure SetLogEvent(LogEvent : TMagLogEvent);  {JK 10/5/2009 - Maggmsgu refactoring - remove old method}
    Procedure UpdateMenuState(Img: TMag4VGear);
    Procedure SetForDICOMViewer(Value: Boolean);
    Procedure CopyImage();
    Procedure PrintImage();
    Function SetCineViewerForCurrentImage(): Boolean;
    Procedure AutoViewCineTool();
    Procedure SetCTPresets(Value: TStrings);
    Procedure SetConfigureCTEnabled(Value: Boolean);
    Procedure SetCurrentPatient(Value: TMag4Pat);

    Procedure Mag4StackViewer1ClickEvent(Sender: Tobject; StackViewer: TMag4StackViewer; MagImage: TMag4VGear);
    Procedure Mag4StackViewer2ClickEvent(Sender: Tobject; StackViewer: TMag4StackViewer; MagImage: TMag4VGear);

    Procedure Mag4StackViewerPageNextViewerClick(Sender: Tobject);
    Procedure Mag4StackViewerPagePrevViewerClick(Sender: Tobject);
    Procedure Mag4StackViewerPageLastViewerClick(Sender: Tobject);
    Procedure Mag4StackViewerPageFirstViewerClick(Sender: Tobject);

    Procedure Mag4StackViewer1ImageZoomScroll(Sender: Tobject; VertScrollPos: Integer; HorizScrollPos: Integer);
    Procedure Mag4StackViewer2ImageZoomScroll(Sender: Tobject; VertScrollPos: Integer; HorizScrollPos: Integer);

    Procedure Mag4StackViewerImageChanged(Sender: Tobject; MagImage: TMag4VGear);

    // DICOM Viewer Directory view
    Procedure DicomDirChangeView(Sender: Tobject; StackView: Boolean);
    Procedure DicomDirImageLoad(Sender: Tobject; IObj: TImageData; ViewerNum: Integer = 1);

    Procedure CopyImagesToStackList(Images: Tlist; StackList: Tlist);
//    procedure LoadStudyInViewer(imgIndex : integer = -1);
    Function IsStudyAlreadyLoaded(RootImg: TImageData; ImgCount: Integer; Study: TMagStudyDetails): Boolean;

    Procedure Mag4ViewerImageDoubleClick(Sender: Tobject; MagImage: TMag4VGear);
    Procedure StackViewerImageDoubleClick(Sender: Tobject; StackViewer: TMag4StackViewer; MagImage: TMag4VGear);

    {/ P122 - JK 7/28/2011 /}
    procedure AnnotateButtonClickEvent(Sender: TObject);
    {/p122t8 - dmmn 11/11/11 /}
    procedure CineViewStartEvent(Sender : TObject; var CanStart : Boolean);

    Procedure DICOMViewerExceptionHandler(Sender: Tobject; e: Exception);
    Procedure SetupDICOMViewer();
    Function GetCurrentStudy(): TMagStudyDetails;
    Procedure ImageWinLevChange(Sender: Tobject; WindowValue: Integer; LevelValue: Integer);
    Procedure ImageBriConChange(Sender: Tobject; BrightnessValue: Integer; ContrastValue: Integer);
    Procedure ImageToolChange(Sender: Tobject; Tool: TMagImageMouse);
    Procedure ImageZoomChange(Sender: Tobject; ZoomValue: Integer);

    Procedure OnCineViewChangePage(Sender: Tobject; Const PageNumber: Integer);
    Procedure SetStackPageWithDiffernetSettings(Value: Boolean);
    Procedure SetStackPageWithSameSettings(Value: Boolean);
    Procedure SetStackPageWithImageSettings(Value: Boolean);
    Procedure SetLayoutSettings(Value: Integer);
    Procedure SetOptionsStackPage(Value: Boolean);
    Procedure SetOptionsOrientationLabels(Value: Boolean);
    Procedure SetOptionsPixelValues(Value: Boolean);
    Procedure SetOptionsWinLev(Value: Integer);
    Procedure MagAnnotationStyleChangeEvent(Sender: Tobject; AnnotationStyle: TMagAnnotationStyle);
    Procedure PatientIDMismatchEvent(Sender: Tobject; Mag4VGear: TMag4VGear);
    Procedure PanWindowCloseEvent(Sender: Tobject);
    Procedure ViewerImageChangeEvent(Sender: Tobject);
    Procedure ApplyToAllChangeEvent(Sender: Tobject; ApplyToAll: Boolean);
    Function GetCurrentStack(): TMag4StackViewer;
    // JMW 4/17/2013 P131
    Function GetCurrentStackIndex(): integer;
    Procedure CineSetParentFocusEvent(Sender: Tobject);
    Procedure PrintImageInternal();
    Procedure SetMouseZoomShape(Shape: TMagMouseZoomShape);
    procedure CloseAnnotationToolbar(ViewerName: String);
    function CheckIfAnnotsModified(Viewer: TMag4StackViewer): Boolean;
    // JMW 4/16/2013 P131
    procedure FindAndDisplayScoutImages(radiologyStudy : TMagRadiologyStudy;
      ScoutWindow : TfrmScoutViewer; ImageToAddAsScout : TImageData = nil);
    Procedure ScoutImageMouseUp(Sender: Tobject; Button: TMouseButton;
      Shift: TShiftState; x, y: Integer; RootImg : TImageData;
      ScoutImage : TImageData);
    procedure ImageSelectedDrawAssociatedScoutLines(vGear : TMag4VGear;
      ViewerNumber : integer = 1);
    procedure DisplayScoutWindow(RootImg : TImageData; ViewerNumber : integer;
      RadiologyStudy : TMagRadiologyStudy = nil);
    procedure Mag4Viewer1ImageChangedEvent(Sender : TObject; MagImage: TMag4VGear);
    function CreateScoutWindow() : TfrmScoutViewer;
    Procedure SetOptionsDisplayScoutLines(Value: Boolean);
    Procedure SetOptionsDisplayScoutWindow(Value: Boolean);
    function ScoutLoadStudy(RootImg: TImageData; ImgList: Tlist) : TMagRadiologyStudy;
    function GetCurrentlyDisplayedStudies() : TList;
    procedure ClearAllScoutLines();
    function IsProcedureForScoutLines(StudyProcedure : String; SiteNumber : String) : boolean;
    procedure AddImageToScoutWindow(vGear : TMag4VGear; Study : TMagStudyDetails;
      ViewerNumber : integer);
    function GetCurrentViewerIndex() : integer;
    procedure UserCancelledHeaderLoading(Sender : TObject);
    procedure SetOptionsScoutLineColor(Color : TColor);
    procedure ScoutColorChangeEvent(Sender : TObject; Color : TColor);
    procedure CloseScoutWindow(WindowNumber : integer);
    procedure ScoutViewerImageChange(Sender : TObject);

    procedure OpenPrintPreviewRadViewer;          {p149}
  Public
    ScreenShotDir: String;
    ScreenShotName: String;
    Procedure SetWindowLevel(Win, Lev: Integer); Overload;
    Procedure SetWindowLevel(Win, Lev: String); Overload;

    Procedure OpenStudy(RootImg: TImageData; ImgList: Tlist; Studydesc: String = ''; ViewerNum: Integer = 1; ImgIndex: Integer = -1; AppendImages: Boolean = False);

    Procedure ClearViewer();
    Procedure SetUtilsDB(UtilsDb: TMagUtilsDB);

    Property ViewMode: TMagRadViewMode Read FViewMode Write SetViewMode;
    //property OnLogEvent : TMagLogEvent read FOnLogEvent write setLogEvent; {JK 10/5/2009 - Maggmsgu refactoring}
    Property ForDicomViewer: Boolean Read FForDICOMViewer Write SetForDICOMViewer;
    Property OpenCompletd: Boolean Read FOpenCompleted Write FOpenCompleted;
    Property CTPresets: TStrings Read FCTPresets Write SetCTPresets;
    Property CTConfigureEnabled: Boolean Read FConfigureCTEnabled Write SetConfigureCTEnabled;
    Property CurrentPatient: TMag4Pat Read FCurrentPatient Write SetCurrentPatient;
    Procedure GetFormUPrefs(VUpref: Tuserpreferences);
    Procedure SetFormUPrefs(VUpref: Tuserpreferences);

    Property NewLogin: Boolean Read FNewLogin Write FNewLogin;
    //procedure Execute
    { Public declarations }
  End;

Const
  ImageFilter = 'Radiology Images (*.dcm,*.tga,*.756,*.pac,*.big)|*.dcm;*.tga;*.756;*.pac;*.big|DICOM Files (*.dcm)|*.dcm|TGA Files (*.tga)|*.tga|Abstract Files (*.abs)|*.abs|All Files (*.*)|*.*';
  /// Set of button options that only contains OK button
  TOKButtonOnly = [Mbok];

Var
  FrmRadViewer: TfrmRadViewer;

Implementation

Uses
  cMagIGManager,
  cMagImageUtility,
  FMagAbout,
{$IFDEF USENEWANNOTS}
  fMagAnnot,
{$ELSE}

{$ENDIF}
  //RCA  FMagAnnotationOptions,
  FmagcineView,
  FMagCTConfigure,
  FMagDICOMDir,
  FMagDicomTxtfile,
  FMagLog,
  FMagRadImageInfo,
  FMagRadiologyImageInfo,
  MagImageManager,
  Magpositions,
  Magremoteinterface,
  Printers,
  Umagdisplaymgr,
//  uMagDisplayUtils,
  Umagutils8,
  umagutils8A,
  fmagRadHeaderProgress
  ;

{$R *.dfm}

Procedure TfrmRadViewer.FormCreate(Sender: Tobject);
var
  radViewerTest : string;
Begin
  ScreenShotDir := '';
  ScreenShotName := '';
  GetFormPosition(Self);

  FStudy1 := TMagStudyDetails.Create();
  FStudy1.StudyList := Tlist.Create();
  FStudy1.RootImg := TImageData.Create();

  FStudy2 := TMagStudyDetails.Create();
  FStudy2.StudyList := Tlist.Create();
  FStudy2.RootImg := TImageData.Create();

  FOpenCompleted := False;
  MagViewerTB1.Align := altop;
  MagViewerTB1.Update;
  Mag4Viewer1.Align := alClient;
  Mag4StackViewer1.Align := alClient;
  ViewMode := MagrvStack1;

//  Mag4Viewer1.RadiologyView := true;
//  Mag4Viewer2.RadiologyView := true;
  Mag4Viewer1.ViewStyle := MagViewerViewRadiology;
  {
  if not assigned(mag4viewer1.magutilsDB) then
  begin
    Mag4Viewer1.MagUtilsDB := dmod.MagUtilsDB1;
//    dmod.MagUtilsDB1.MagPat := dmod.MagPat1;
  end;
  if not assigned(mag4viewer2.magutilsDB) then
  begin
    Mag4Viewer2.MagUtilsDB := dmod.MagUtilsDB1;
//    dmod.MagUtilsDB1.MagPat := dmod.MagPat1;
  end;
  }

  FCurrentViewer := Mag4StackViewer1;
  MagViewerTB1.MagViewer := FCurrentViewer;

  MagViewerTB1.AddViewerToToolbar(Mag4StackViewer1);

  Mag4StackViewer1.OnStackViewerClick := Mag4StackViewer1ClickEvent;
  Mag4StackViewer2.OnStackViewerClick := Mag4StackViewer2ClickEvent;

  Mag4StackViewer1.OnPageNextStackViewerClick := Mag4StackViewerPageNextViewerClick;
  Mag4StackViewer1.OnPagePreviousStackViewerClick := Mag4StackViewerPagePrevViewerClick;
  Mag4StackViewer1.OnPageFirstStackViewerClick := Mag4StackViewerPageFirstViewerClick;
  Mag4StackViewer1.OnPageLastStackViewerClick := Mag4StackViewerPageLastViewerClick;

  Mag4StackViewer2.OnPageNextStackViewerClick := Mag4StackViewerPageNextViewerClick;
  Mag4StackViewer2.OnPagePreviousStackViewerClick := Mag4StackViewerPagePrevViewerClick;
  Mag4StackViewer2.OnPageFirstStackViewerClick := Mag4StackViewerPageFirstViewerClick;
  Mag4StackViewer2.OnPageLastStackViewerClick := Mag4StackViewerPageLastViewerClick;

   // JMW 8/7/08 p72t24 - Set event to handle when the image is changed
   // this occurs when scrolling through images or when pressing the image change
   // buttons. Can use same event handler since don't need to do anything
   // different for each button type, just updating the toolbar
  Mag4Viewer1.OnPageNextViewerClick := ViewerImageChangeEvent;
  Mag4Viewer1.OnPagePreviousViewerClick := ViewerImageChangeEvent;
  Mag4Viewer1.OnPageFirstViewerClick := ViewerImageChangeEvent;
  Mag4Viewer1.OnPageLastViewerClick := ViewerImageChangeEvent;

  Mag4StackViewer1.OnImageChanged := Mag4StackViewerImageChanged;
  Mag4StackViewer2.OnImageChanged := Mag4StackViewerImageChanged;

  Mag4Viewer1.OnImageDoubleClick := Mag4ViewerImageDoubleClick;
  Mag4StackViewer1.OnStackImaegDoubleClick := StackViewerImageDoubleClick;

  Mag4StackViewer1.OnImageZoomScroll := Mag4StackViewer1ImageZoomScroll;
  Mag4StackViewer2.OnImageZoomScroll := Mag4StackViewer2ImageZoomScroll;

  Mag4StackViewer1.OnImageWinLevChange := ImageWinLevChange;
  Mag4StackViewer2.OnImageWinLevChange := ImageWinLevChange;

  Mag4StackViewer1.OnImageBriConChange := ImageBriConChange;
  Mag4StackViewer2.OnImageBriConChange := ImageBriConChange;

  Mag4StackViewer1.OnImageToolChange := ImageToolChange;
  Mag4StackViewer2.OnImageToolChange := ImageToolChange;

  Mag4StackViewer1.OnImageZoomChange := ImageZoomChange;
  Mag4StackViewer2.OnImageZoomChange := ImageZoomChange;

  Mag4StackViewer1.OnMagAnnotationStyleChangeEvent := MagAnnotationStyleChangeEvent;
  Mag4StackViewer2.OnMagAnnotationStyleChangeEvent := MagAnnotationStyleChangeEvent;
  Mag4Viewer1.OnMagAnnotationStyleChangeEvent := MagAnnotationStyleChangeEvent;

  Mag4StackViewer1.OnPatientIDMismatchEvent := PatientIDMismatchEvent;
  Mag4StackViewer2.OnPatientIDMismatchEvent := PatientIDMismatchEvent;
  Mag4Viewer1.OnPatientIDMismatchEvent := PatientIDMismatchEvent;

  Mag4StackViewer1.OnPanWindowClose := PanWindowCloseEvent;
  Mag4StackViewer2.OnPanWindowClose := PanWindowCloseEvent;

  Mag4Viewer1.OnPanWindowClose := PanWindowCloseEvent;
  MagViewerTB1.OnApplyToAllEvent := ApplyToAllChangeEvent;

  {/ P122- JK 7/28/2011 - attach the local event handler to the stack viewer annotate event /}
  Mag4StackViewer1.OnAnnotateButtonClick := AnnotateButtonClickEvent;
  Mag4StackViewer2.OnAnnotateButtonClick := AnnotateButtonClickEvent;

  // JMW 4/17/2013 p131 - get updates when the selected image is changed
  Mag4Viewer1.OnImageChanged := Mag4Viewer1ImageChangedEvent;

  FisClosing := False;

  If Application.Title = 'MagDICOMViewer' Then
  Begin
    SetupDICOMViewer();
  End
  Else
  Begin
    ForDicomViewer := False;
     // set the help context only for the Rad Viewer, not DICOM Viewer
    Self.HelpContext := 10213;
  End;

  MnuOptionsImageSettingsHistogram.Checked := True;

  Mag4Viewer1.ColumnCount := 3;
  MnuOptionsLabelsOn.Checked := True;
  FNewLogin := True;
   // JMW 8/11/08 - not sure if this is the best place for it, but don't want
   // both win/lev and bri/con to be open at same time - this might move...
  MnuImageWinLev.Visible := False;
   // same with the stack options - not sure if this is a good place for this...
  MnuViewStack1.Visible := False;
  MnuViewStack2.Visible := False;
  MnuViewBar2.Visible := False;

   // set the default shape to circle (stack view always defaults to circle)
  Mag4Viewer1.SetMouseZoomShape(MagMouseZoomShapeCircle);

   // set page with different settings as default in stack (not sure if this should be default?)
//   SetStackPageWithDiffernetSettings(true);

  FScoutWindow1 := nil;
  FScoutWindow2 := nil;
  FScoutLineColor := clRed;
  uMagRadHeaderLoader.Initialize();

  // show test menu options based on setting in ini file
  radViewerTest := GetIniEntry('Workstation Settings', 'RadViewerTest');
  mnuTest.Visible := (UpperCase(radViewerTest) = 'TRUE');

  FPanWindowHolder := TMagPanWindowHolder.Create;
  Mag4StackViewer1.SetPanWindowHolder(FPanWindowHolder);
  Mag4StackViewer2.SetPanWindowHolder(FPanWindowHolder);
  Mag4Viewer1.SetPanWindowHolder(FPanWindowHolder);

End;

Procedure TfrmRadViewer.SetupDICOMViewer();
Var
  FPassedFilename: String;
  i: Integer;
  ImgList: Tlist;
  inPos: Integer;
  IObj, FirstImg: TImageData;
  SgTemp: String;
  sgExt: String;
Begin
  FMagAnnotationStyle := TMagAnnotationStyle.Create(clYellow, 2, 6);

  Msglist := Tstringlist.Create();
  FCTPresets := Tstringlist.Create();

  FCTPresets.Add('Abdomen|350|1040');
  FCTPresets.Add('Bone|500|1274');
  FCTPresets.Add('Disk|950|1240');
  FCTPresets.Add('Head|80|1040');
  FCTPresets.Add('Lung|1000|300');
  FCTPresets.Add('Mediastinum|500|1040');
  {
  // values from el Paso
  FCTPresets.add('Abdomen|350|40');
  FCTPresets.add('Bone|976|430');
  FCTPresets.add('Disk|900|250');
  FCTPresets.add('Head|80|40');
  FCTPresets.add('Lung|976|-546');
  FCTPresets.add('Mediastinum|500|40');
  }
  FCTPresets.Add('');
  FCTPresets.Add('');
  FCTPresets.Add('');

  MnuCTCustom1.Visible := False;
  MnuCTCustom2.Visible := False;
  MnuCTCustom3.Visible := False;
  MnuCTBar1.Visible := False;

  MnuViewBar1.Visible := False;
  MnuViewGoToMainWindow.Visible := False;
  MnuViewActivewindows.Visible := False;

  AppPath := Copy(ExtractFilePath(Application.ExeName), 1, Length(ExtractFilePath(Application.ExeName)) - 1);

  ForDicomViewer := True;
  Self.caption := 'DICOM Viewer';
  MagImageManager.Initialize();

  // tell the image manager to only cache images that are from HTTP locations
  MagImageManager1.CacheOnlyHttpImages := True;
  MagImageManager1.CacheDirectory := AppPath + '\temp';

  // P72 12/3/2007 enable for DICOM Viewer
  CTConfigureEnabled := True; //false;

  OpenCompletd := True;

  //OnLogEvent := LogDICOMViewerMsg;  {JK 10/6/2009 - Maggmsgu refactoring}

  ImgList := Tlist.Create();
  Try
    FirstImg := Nil;
    For i := 1 To ParamCount Do
    Begin
      If Pos('-SCREENSHOT=', Uppercase(ParamStr(i))) = 1 Then
      Begin
        SgTemp := ParamStr(i);
        inPos := Pos('=', SgTemp);
        If inPos = 0 Then Continue;
        SgTemp := Copy(SgTemp, inPos + 1, Length(SgTemp) - (inPos + 1) + 1);
        SgTemp := Trim(SgTemp);
        If Not Directoryexists(SgTemp) Then Forcedirectories(SgTemp);
        If Not Directoryexists(SgTemp) Then Continue;
        ScreenShotDir := SgTemp;
        Continue;
      End;
      If Uppercase(ParamStr(i)) = '-DEBUG' Then
      Begin
        DebugOn := True;
        Continue;
      End;
      FPassedFilename := ParamStr(i);
      IObj := TImageData.Create();
      IObj.FFile := FPassedFilename;
      IObj.Mag0 := FPassedFilename;
      IObj.ImgDes := FPassedFilename;
      ImgList.Add(IObj);
      // need to keep track of the first image
      If FirstImg = Nil Then
        FirstImg := IObj;
    End;
    // turn on for now...
    DebugOn := True;

    // if the first image was assigned, open it
    If (FirstImg <> Nil) And (GetImageUtility.MagFileExists(FirstImg.FFile)) Then
    Begin
      If ScreenShotDir <> '' Then
      Begin
        ScreenShotName := ExtractFileName(FirstImg.FFile);
        sgExt := ExtractFileExt(ScreenShotName);
        sgExt := StringReplace(sgExt, '.', '', [RfReplaceAll]);
        //ScreenShotName:=Copy(ScreenShotName,1,Length(ScreenShotName)-Length(sgExt))+'.bmp';
        ScreenShotName := sgExt + '.' + ScreenShotName + '.' + GetIGManager().Version + '.bmp';
      End;
      OpenStudy(FirstImg, ImgList, 'Displaying');
      //FreeAndNil(ImgList);
      FreeAndNil(IObj);
  //    FirstImg.Free; // this causes an exception when images are supposed to open in DIcOM Viewer (frmo Windows)
      FirstImg := Nil;
    End;
    MagAnnotationStyleChangeEvent(Self, FMagAnnotationStyle);
  Finally
    FreeAndNil(ImgList);
  End;
End;

Procedure TfrmRadViewer.LogDICOMViewerMsg(Sender: Tobject; MsgType: String; Msg: String; Priority: TMagmsgPriority = MagmsgINFO);
Var
  m: String;
Begin
  If FrmLog <> Nil Then
    FrmLog.LogMsg(Sender, MsgType, Msg, Priority);
  m := Formatdatetime('hh:mm:ss', Now);
  If Sender <> Nil Then
    m := m + ' [' + Sender.ClassName + ']';
  m := m + '(' + MsgType + ',' + MagAppPriorityString(Priority) + ') - ' + Msg;
  Msglist.Add(m);

End;

{JK 10/5/2009 - Maggmsgu refactoring - remove old method}
//procedure TfrmRadViewer.LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = magmsginfo);
//begin
//  if assigned(OnLogEvent) then
//    OnLogEvent(self, MsgType, Msg, Priority);
//end;

{JK 10/5/2009 - Maggmsgu refactoring - remove old method}
//procedure TfrmRadViewer.SetLogEvent(LogEvent : TMagLogEvent);
//begin
//  FOnLogEvent := LogEvent;
//  Mag4Viewer1.OnLogEvent := OnLogEvent;
//  Mag4StackViewer1.OnLogEvent := OnLogEvent;
//  Mag4StackViewer2.OnLogEvent := OnLogEvent;
//  magViewerTB1.OnLogEvent := OnLogEvent;
//end;

Procedure TfrmRadViewer.SetForDICOMViewer(Value: Boolean);
Begin
  FForDICOMViewer := Value;
  MnuFileOpenImage.Visible := FForDICOMViewer;
  MnuFileDirectory.Visible := FForDICOMViewer;
  MnuFileCloseSelected.Visible := FForDICOMViewer;
  MnuFileClearAll.Visible := FForDICOMViewer;
  MnuBar1.Visible := FForDICOMViewer;
  MnuFileReport.Visible := Not FForDICOMViewer;
  MnuFullResView.Enabled := Not FForDICOMViewer;
  MagViewerTB1.DICOMViewer := FForDICOMViewer;
  MnuViewInfoInformationAdvanced.Visible := Not FForDICOMViewer;
  MnuHelpAbout.Visible := FForDICOMViewer;
  MnuHelpRadiologyViewer.Visible := Not FForDICOMViewer;
  Openin2ndStack1.Visible := FForDICOMViewer;
  MnuViewInfoDICOMHeader.Visible := FForDICOMViewer;
  MnuViewInfotxtFile.Visible := True;
  // JMW 8/29/08 p72t26 - was always on, now only on for DICOM Viewer
  MnuViewInfotxtFile.Visible := FForDICOMViewer;

  // make this function work
  MnuImageCacheStudy.Visible := Not FForDICOMViewer;
  MnuToolsLog.Visible := FForDICOMViewer;

  If FForDICOMViewer Then
  Begin
    Application.OnException := DICOMViewerExceptionHandler;
  End;

End;

Procedure TfrmRadViewer.SetViewMode(Value: TMagRadViewMode);
Var
  ImgIndex: Integer;
  ImgState: TMagImageState;
  WasStack1: Boolean;
  CurViewer: IMag4Viewer;
  PrevViewMode: TMagRadViewMode;
Begin
  If (FViewMode = Value) And (FOpenCompleted) Then Exit;
  ImgState := Nil;
  PrevViewMode := FViewMode;
  FViewMode := Value;
  Mag4StackViewer1.Visible := False;
  Mag4Viewer1.Align := alClient;
  Mag4StackViewer1.Align := alClient;
  Mag4StackViewer2.Visible := False;
  WasStack1 := False;
  ClearChecks();
  If FCurrentViewer = Nil Then
    ImgIndex := 0
  Else
    ImgIndex := FCurrentViewer.GetCurrentImageIndex();
  Case FViewMode Of
    MagrvStack1:
      Begin
      //Mag4Viewer1.ViewerStyle := magvsLayout;
        MnuViewSettings1x1.Checked := True;
        MnuViewSettings1x1.Checked := True;
        Mag4Viewer1.MaxAutoLoad := 1;
        FCurrentViewer := Mag4Viewer1;

        Mag4StackViewer1.Visible := True;
        Mag4Viewer1.Visible := False;
        CurViewer := Mag4StackViewer1;

        If (FCurrentViewer <> CurViewer) And (FOpenCompleted) Then
        Begin
          FCurrentViewer := Mag4StackViewer1;
        // check to see if coming from a layout or a stack
        // if from layout, want to get current image from layout
          If (PrevViewMode = MagrvLayout32) Or (PrevViewMode = MagrvLayout43) Then
          Begin
            ImgIndex := Mag4Viewer1.GetCurrentImageIndex();
            If Mag4Viewer1.GetCurrentImage <> Nil Then
            Begin
              ImgState := Mag4Viewer1.GetCurrentImage.GetState();
              ImgState.ZoomValue := -1;
            End;
            Mag4StackViewer1.SetCurrentTool(Mag4Viewer1.GetCurrentTool());
            Mag4StackViewer1.ApplyViewerState(Mag4Viewer1);
          End
          Else // if from statck (2x1) to (1x1), then get stack1 settings
          Begin
            ImgIndex := Mag4StackViewer1.GetCurrentImageIndex();
            ImgState := Nil;
          End;

          Mag4StackViewer1.SetDefaultState(ImgState); // set before opening to prevent multiple refreshes
          OpenStudy(FStudy1.RootImg, FStudy1.StudyList, FStudy1.Studydesc, 1, ImgIndex);
//        FCurrentViewer.applyImageState(imgState);
        End;
        MagViewerTB1.RemoveViewerFromToolbar(Mag4Viewer1);
        MagViewerTB1.RemoveViewerFromToolbar(Mag4StackViewer2);
        MagViewerTB1.AddViewerToToolbar(Mag4StackViewer1);
      End;
    MagrvStack2:
      Begin

        MnuViewSettings2x1.Checked := True;
        MagViewerTB1.AddViewerToToolbar(Mag4StackViewer2);
      // this seems stupid - makes sure that if apply to all was on and then
      // view set to layout and apply to all turned off, the setting is set in
      // second viewer

        Mag4StackViewer1.Align := alLeft;
        Mag4StackViewer2.Align := alright;
        Mag4StackViewer2.Visible := True;
        Mag4StackViewer1.Visible := True;
        Mag4Viewer1.Visible := False;
        CurViewer := Mag4StackViewer1;
        If (FCurrentViewer = CurViewer) Then
          WasStack1 := True;
        CurViewer := Mag4StackViewer2;
        If (FCurrentViewer <> CurViewer) Then
        Begin
        // if not coming from a stack, then need to get current image for stack1 to use
        // such as if from viewer1 then stack, stack1 needs viewer1 image
          If WasStack1 Then
          Begin
          // JMW 7/11/08 p72t23 - set the viewer state also if coming from stack1
            Mag4StackViewer2.ApplyViewerState(Mag4StackViewer1);
            Mag4StackViewer2.SetCurrentTool(Mag4StackViewer1.GetCurrentTool());
          End
          Else
          Begin
            ImgIndex := FCurrentViewer.GetCurrentImageIndex();
            Mag4StackViewer1.ApplyViewerState(FCurrentViewer);
            Mag4StackViewer2.ApplyViewerState(FCurrentViewer);
            OpenStudy(FStudy1.RootImg, FStudy1.StudyList, FStudy1.Studydesc, 1, ImgIndex);
            MagViewerTB1.AddViewerToToolbar(Mag4StackViewer1);
            Mag4StackViewer1.SetCurrentTool(Mag4Viewer1.GetCurrentTool());
            Mag4StackViewer2.SetCurrentTool(Mag4Viewer1.GetCurrentTool());

          End;
          FCurrentViewer := Mag4StackViewer2;
          Mag4StackViewer1.UnSelectAll();
          Mag4StackViewer2.SetSelected();
        // does this need to be done?
        // maybe only needed to refresh so still visible?

        //ImgIndex := Mag4StackViewer2.getCurrentImageIndex();
        // JMW 4/15/2007 P72
        // I think this will solve the problem where the first time the 4th image from the group abs window is selected for the 2nd stack
        // the first image was loading and not the 4th.
          ImgIndex := FStudy2.CurrentImage;
          OpenStudy(FStudy2.RootImg, FStudy2.StudyList, FStudy2.Studydesc, 2, ImgIndex);
        End;
        MagViewerTB1.RemoveViewerFromToolbar(Mag4Viewer1);
      End;
    MagrvLayout32:
      Begin
        Mag4Viewer1.ColumnCount := 3;
        Mag4Viewer1.RowCount := 2;
        MnuViewSettings3x2.Checked := True;
        Mag4Viewer1.MaxAutoLoad := 6;

        Mag4StackViewer1.Visible := False;
        Mag4StackViewer2.Visible := False;
        Mag4Viewer1.Visible := True;
        MagViewerTB1.AddViewerToToolbar(Mag4Viewer1);

        CurViewer := Mag4Viewer1;
        If (FCurrentViewer <> CurViewer) Then
        Begin
          FCurrentViewer := Mag4Viewer1;
          ImgIndex := Mag4StackViewer1.GetCurrentImageIndex();
          If Mag4StackViewer1.GetCurrentImage() <> Nil Then
            ImgState := Mag4StackViewer1.GetCurrentImage.GetState();
          OpenStudy(FStudy1.RootImg, FStudy1.StudyList, FStudy1.Studydesc, 1, ImgIndex);
          FCurrentViewer.ApplyViewerState(Mag4StackViewer1);
          FCurrentViewer.ApplyImageState(ImgState);
          Mag4Viewer1.SetCurrentTool(Mag4StackViewer1.GetCurrentTool());
        End;
        MagViewerTB1.RemoveViewerFromToolbar(Mag4StackViewer1);
        MagViewerTB1.RemoveViewerFromToolbar(Mag4StackViewer2);
      End;
    MagrvLayout43:
      Begin
        Mag4Viewer1.ColumnCount := 4;
        Mag4Viewer1.RowCount := 3;
        MnuViewSettings4x3.Checked := True;
        Mag4Viewer1.MaxAutoLoad := 12;

        Mag4StackViewer1.Visible := False;
        Mag4StackViewer2.Visible := False;
        Mag4Viewer1.Visible := True;
        MagViewerTB1.AddViewerToToolbar(Mag4Viewer1);

        CurViewer := Mag4Viewer1;
        If (FCurrentViewer <> CurViewer) Then
        Begin
          FCurrentViewer := Mag4Viewer1;
          ImgIndex := Mag4StackViewer1.GetCurrentImageIndex();
          If Mag4StackViewer1.GetCurrentImage() <> Nil Then
            ImgState := Mag4StackViewer1.GetCurrentImage.GetState();
          OpenStudy(FStudy1.RootImg, FStudy1.StudyList, FStudy1.Studydesc, 1, ImgIndex);
          FCurrentViewer.ApplyViewerState(Mag4StackViewer1);
          FCurrentViewer.ApplyImageState(ImgState);
          Mag4Viewer1.SetCurrentTool(Mag4StackViewer1.GetCurrentTool());

        End;
        MagViewerTB1.RemoveViewerFromToolbar(Mag4StackViewer1);
        MagViewerTB1.RemoveViewerFromToolbar(Mag4StackViewer2);
      End;
  End;
  // JMW 12/7/2006 p72 set the current viewer in the toolbar
  MagViewerTB1.MagViewer := FCurrentViewer;
  CurViewer := Nil;
  UpdateMenuState(Nil);
  TimerReSizeTimer(Self);
End;
{
  // JMW 5/14/08 P72t22 - I believe this function is no longer needed,
  // if so then it should be removed
procedure TfrmRadViewer.LoadStudyInViewer(imgIndex : integer = -1);
begin
  if Mag4Viewer1.isStudyAlreadyLoaded(FStudy1.RootImg.Mag0, FStudy1.RootImg.ServerName, FStudy1.RootImg.ServerPort, FStudy1.StudyList.Count) then
  begin
    if ImgIndex < 0 then ImgIndex := 0;
    Mag4Viewer1.ShowImage(ImgIndex);
  end
  else
  begin
    Mag4Viewer1.ClearViewer();
    FOpenCompleted := false;
    Mag4Viewer1.pnlTop.Caption := '';
    Mag4Viewer1.SetViewerDesc(FStudy1.RootImg.ExpandedDescription(false), true);
    Mag4Viewer1.ImagesToMagView(FStudy1.StudyList, false, ImgIndex);
    FOpenCompleted := true;

  end;
end;
}

Procedure TfrmRadViewer.ClearChecks();
Begin
  MnuViewSettings1x1.Checked := False;
  MnuViewSettings2x1.Checked := False;
  MnuViewSettings3x2.Checked := False;
  MnuViewSettings4x3.Checked := False;
End;

Procedure TfrmRadViewer.FormResize(Sender: Tobject);
Begin
  //LogMsg('s', 'FormResize()', MAGMSGDebug);
  MagAppMsg('s', 'FormResize()', MAGMSGDebug); {JK 10/6/2009 - Maggmsgu refactoring}

{
  Mag4Viewer1.ReAlignImages();
  if Mag4Viewer2.Visible then
  begin
    Mag4Viewer2.ReAlignImages();
    Mag4Viewer1.Width := trunc(self.ClientWidth / 2);
    Mag4Viewer2.Width := trunc(self.ClientWidth / 2);
    Mag4Viewer2.Left := Mag4Viewer1.Left + Mag4Viewer1.Width;
  end;

  }
  If Application.Terminated Then Exit;
  If FisClosing Then Exit;

  If Mag4Viewer1.LockSize Then
  Begin
    TimerReSize.Enabled := False;
    Application.Processmessages;
    TimerReSize.Enabled := True;
  End
  Else
  Begin
    TimerReSize.Enabled := False;
    Application.Processmessages;
    TimerReSize.Enabled := True;
  End;
End;

Procedure TfrmRadViewer.MnuViewSettings1x1Click(Sender: Tobject);
var
  Stack: TMag4StackViewer;
Begin
  {/ P122 - JK 9/21/2011 - Close annotation toolbar in the other stack if it is open}
  if GetCurrentStack <> nil then
  begin
    Stack := GetCurrentStack;
    CloseAnnotationToolbar(Stack.Name);
    Stack.Mag4Vgear1.AnnotationComponent.LoadCurrentAnnotations;
  end;

  ViewMode := MagrvStack1;
//  timerReSizeTimer(self);
End;

Procedure TfrmRadViewer.MnuViewSettings2x1Click(Sender: Tobject);
var
  Stack: TMag4StackViewer;
Begin
  {/ P122 - JK 9/21/2011 - Close annotation toolbar in the other stack if it is open}
  if GetCurrentStack <> nil then
  begin
    Stack := GetCurrentStack;
    CloseAnnotationToolbar(Stack.Name);
    Stack.Mag4Vgear1.AnnotationComponent.LoadCurrentAnnotations;
  end;

  ViewMode := MagrvStack2;
  TimerReSizeTimer(Self);
End;

Procedure TfrmRadViewer.MnuViewSettings3x2Click(Sender: Tobject);
var
  Stack: TMag4StackViewer;
Begin
  {/ P122 - JK 9/21/2011 - Close annotation toolbar in the other stack if it is open}
  if GetCurrentStack <> nil then
  begin
    Stack := GetCurrentStack;
    CloseAnnotationToolbar(Stack.Name);
    Stack.Mag4Vgear1.AnnotationComponent.LoadCurrentAnnotations;
  end;

  ViewMode := MagrvLayout32;
  TimerReSizeTimer(Self);
End;

Procedure TfrmRadViewer.MnuViewSettings4x3Click(Sender: Tobject);
var
  Stack: TMag4StackViewer;
Begin
  {/ P122 - JK 9/21/2011 - Close annotation toolbar in the other stack if it is open}
  if GetCurrentStack <> nil then
  begin
    Stack := GetCurrentStack;
    CloseAnnotationToolbar(Stack.Name);
    Stack.Mag4Vgear1.AnnotationComponent.LoadCurrentAnnotations;
  end;

  ViewMode := MagrvLayout43;
  TimerReSizeTimer(Self);
End;

{/ P122 - JK 8/16/2011 /}
function TfrmRadViewer.CheckIfAnnotsModified(Viewer: TMag4StackViewer): Boolean;
var
  SaveAnnotResult: TAnnotWindowCloseAction;
begin
  Result := True;

  if Viewer.GetCurrentImage.AnnotationComponent.RADPackage then
  begin
    Viewer.GetCurrentImage.AnnotationComponent.IsAnnotationMode := False;
    Result := False;
    Exit;
  end;

  if Viewer.GetCurrentImage.AnnotationComponent.AnnotsModified then
  begin
    SaveAnnotResult := Viewer.GetCurrentImage.AnnotationComponent.SaveAnnotationLayer(True);
    if SaveAnnotResult = awCancel then
      Result := False
    else
      Viewer.GetCurrentImage.AnnotationComponent.IsAnnotationMode := False;
  end;

end;

Procedure TfrmRadViewer.FormClose(Sender: Tobject;
  Var action: TCloseAction);
Begin

  //LogMsg('s', 'FormClose()', MAGMSGDebug);
  MagAppMsg('s', 'FormClose()', MAGMSGDebug); {JK 10/6/2009 - Maggmsgu refactoring}

  {/ P122 - JK 8/1/2011 /}

  if Mag4StackViewer1.GetCurrentImage <> nil then
    if Mag4StackViewer1.GetCurrentImage.AnnotationComponent <> nil then
      if Mag4StackViewer1.GetCurrentImage.AnnotationComponent.IsAnnotationMode then
      begin
        if CheckIfAnnotsModified(Mag4StackViewer1) then
          Mag4StackViewer1.GetCurrentImage.AnnotationComponent.Hide
        else
          if Mag4StackViewer1.GetCurrentImage.AnnotationComponent.RADPackage then
          begin
 // pre 122 had only    action := caFree    in the begin end
//            action := caFree
            Mag4StackViewer1.GetCurrentImage.AnnotationComponent.Hide;    //p122t7 dmmn 10/24
//            action := caHide;
          end
          else
            action := caNone;
      end;

  if Mag4StackViewer2.GetCurrentImage <> nil then
    if Mag4StackViewer2.GetCurrentImage.AnnotationComponent <> nil then
      if Mag4StackViewer2.GetCurrentImage.AnnotationComponent.IsAnnotationMode then
      begin
        if CheckIfAnnotsModified(Mag4StackViewer2) then
          Mag4StackViewer2.GetCurrentImage.AnnotationComponent.Hide
        else
          if Mag4StackViewer2.GetCurrentImage.AnnotationComponent.RADPackage then
          begin
// pre 122 has only         action :caFree;          in the begin end
//            action := caFree
            Mag4StackViewer2.GetCurrentImage.AnnotationComponent.Hide;    //p122t7 dmmn 10/24
//            action := caHide;
          end
          else
            action := caNone;
      end;

  {/p122t5 dmmn 10/7 - escape if user click cancel on the annotation save prompts. avoid clearing the image /}
  if action = caNone then
    Exit;

  FisClosing := True;
  TimerReSize.Enabled := False;

  // why was this here!?
  // seems to have been cause of exceptions!?
//  magViewerTB1.Invalidate();

  If FrmCineView <> Nil Then
  Begin
    FrmCineView.StopCineView();
    FrmCineView.Close();
  End;

(*  RCA OUT  If FrmAnnotationOptions <> Nil Then
    FrmAnnotationOptions.Close;*)

  // only would be nil in Display client
  If FrmDicomTxtfile <> Nil Then
  Begin
    FrmDicomTxtfile.Visible := False;
  End;

  If FrmCTConfigure <> Nil Then
    FrmCTConfigure.Visible := False;

          {
  if frmDICOMDir <> nil then
  begin
    frmDICOMDir.Free();
  end;
  }

  Try
    // JMW 7/17/08 p72t23 - disable the pan window when closing so the
    // pan window doesn't stay open after the rad viewer is closed (crappy)
    MagViewerTB1.DisablePanWindow();

    If Mag4Viewer1 <> Nil Then
      Mag4Viewer1.ClearViewer();
    If Mag4StackViewer1 <> Nil Then
    Begin
      Mag4StackViewer1.StopScrolling();
      Mag4StackViewer1.ClearViewer();
    End;
    If Mag4StackViewer2 <> Nil Then
    Begin
      Mag4StackViewer2.StopScrolling();
      Mag4StackViewer2.ClearViewer();
    End;

    If FStudy1.StudyList <> Nil Then
      FStudy1.StudyList.Clear();
    If FStudy1.RootImg <> Nil Then
      FStudy1.RootImg.Clear();
    If FStudy2.StudyList <> Nil Then
      FStudy2.StudyList.Clear();
    If FStudy2.RootImg <> Nil Then
      FStudy2.RootImg.Clear();

  // prevents exception on close!
//  FCurrentViewer := nil;

    //p122rgb dmmn 12/12/11 - reset the toolbar back to full color when close
    magViewerTB1.tbRGBChanger.ImageIndex := 25;

    CloseScoutWindow(1);
    CloseScoutWindow(2);

    uMagRadHeaderLoader.ClearPatient();
    
    SaveFormPosition(Self);

  Except
    On e: Exception Do
    Begin
      Showmessage(e.Message);
      //LogMsg('s', e.Message, MAGMSGDebug);
      MagAppMsg('s', e.Message, MAGMSGDebug); {JK 10/6/2009 - Maggmsgu refactoring}
    End;
  End;

{
  if FForDICOMViewer then
    ModalResult := mrOK;

    }
//  Action := caFree;

End;

Procedure TfrmRadViewer.Mag4Viewer1ViewerImageClick(Sender: Tobject);
Begin
  //ViewClick event is always called (after this event), not sure if this event needed
//  MagViewerTB1.UpdateImageState;
  //ViewClick event is always called (after this event), not sure if this event needed
End;

Procedure TfrmRadViewer.Mag4Viewer1ViewerClick(Sender: Tobject;
  Viewer: TMag4Viewer; MagImage: TMag4VGear);
Var
  VGear: TMag4VGear;
Begin
  FCurrentViewer := Mag4Viewer1;
  VGear := FCurrentViewer.GetCurrentImage;
  If VGear <> Nil Then
    UpdateMenuState(VGear);
  MagViewerTB1.MagViewer := Mag4Viewer1;
  MagViewerTB1.UpdateImageState;
  If Mag4Viewer1.Visible Then
    Mag4Viewer1.SetFocus();
  If SetCineViewerForCurrentImage() Then
    AutoViewCineTool();

  // this is a special check to see if the user set layout and then double
  // clicked on an image and changed to 1x1 stack (can only happen on viewer1)

//  CheckCheckMarks();

              {
  if (FCurrentViewer.ColumnCount = 1) and (FCurrentViewer.RowCount = 1) then
  begin
    if (FViewMode = MagrvLayout32) or (FViewMode = magrvLayout43) then
    begin
      mnuViewSettings1x1Click(self);
      (*
      ClearChecks();
      mnuViewSettings1x1.Checked := true;
      Mag4Viewer1.MaxAutoLoad := 1;
      // this should not do anything... (not bad but not needed)
      magViewerTB1.removeViewerFromToolbar(Mag4Viewer2);
      *)
    end;
  end;
  }
End;

Procedure TfrmRadViewer.TimerReSizeTimer(Sender: Tobject);
Var
  VGear: TMag4VGear;
  ImgIndex: Integer;
Begin
  If Not Application.Terminated And FOpenCompleted Then
  Begin
    TimerReSize.Enabled := False;
    Application.Processmessages;

    Case FViewMode Of
      MagrvStack1:
        Begin
          Mag4StackViewer1.FitToWindow();
        End;
      MagrvStack2:
        Begin
          Mag4StackViewer1.Width := Trunc(Self.ClientWidth / 2);
          Mag4StackViewer2.Width := Trunc(Self.ClientWidth / 2);
          Mag4StackViewer2.Left := Mag4StackViewer1.Left + Mag4StackViewer1.Width;
          Mag4StackViewer1.Realign();
          Mag4StackViewer2.Realign();

          Mag4StackViewer1.FitToWindow();
          Mag4StackViewer2.FitToWindow();
        End;
      MagrvLayout32, MagrvLayout43:
        Begin
          VGear := Mag4Viewer1.GetCurrentImage;
          If VGear = Nil Then
            ImgIndex := -1
          Else
            ImgIndex := VGear.ListIndex;
        // JMW P72 8/2/2006 pass the current selected image so it is visible
          Mag4Viewer1.ReAlignImages(False, False, ImgIndex);
        End;
    End;
    // update the state so the toolbar has the proper zoom value
    // (if it changed during a resize)
    MagViewerTB1.UpdateImageState();
  End;
  If Application.Terminated Then TimerReSize.Enabled := False;
End;

Procedure TfrmRadViewer.MnuFullResViewClick(Sender: Tobject);
Begin
  If FCurrentViewer = Nil Then Exit;
  FCurrentViewer.ViewFullResImage();
  // update the menu state - updates the title bar to remove the reference quality warning
  UpdateMenuState(FCurrentViewer.GetCurrentImage());
  MagViewerTB1.UpdateImageState();
End;

Procedure TfrmRadViewer.UpdateMenuState(Img: TMag4VGear);
Var
  ImgState: TMagImageState;
  PatName: String;
  CurStack: TMag4StackViewer;
  windowIndex : integer;
Begin
  // these items are not based on image or image state
  windowIndex := 1;
  If (FViewMode = MagrvStack1) Or (FViewMode = MagrvStack2) Then
  Begin
    MnuImageStackCine.Visible := True;
    If FViewMode = MagrvStack2 Then
    Begin
      MnuViewStack1.Visible := True;
      MnuViewStack2.Visible := True;
      MnuViewBar2.Visible := True;
    End
    Else
    Begin
      MnuViewStack1.Visible := False;
      MnuViewStack2.Visible := False;
      MnuViewBar2.Visible := False;
    End;
  End
  Else // layout mode
  Begin
    MnuImageStackCine.Visible := False;
    MnuViewStack1.Visible := False;
    MnuViewStack2.Visible := False;
    MnuViewBar2.Visible := False;
  End;

  CurStack := GetCurrentStack();
  If CurStack = Nil Then
  Begin
    // layout view
    MnuImageMaximizeImage.Enabled := True;
  End
  Else
    If CurStack = Mag4StackViewer2 Then
    Begin
    // stack 2 is selected
      MnuImageMaximizeImage.Enabled := False;
      windowIndex := 2;
    End
    Else
    Begin
    // stack 1 is selected
      MnuImageMaximizeImage.Enabled := True;
    End;

  If Img = Nil Then Exit;
  ImgState := Img.GetState;
  //p130t11 dmmn 4/9/13 update the rgb menu state
  if ImgState <> nil then
    mnuRGBChanger.Enabled := ImgState.RGBEnabled;

  If FForDICOMViewer Then
  Begin
    MnuFullRes.Enabled := False;
  End
  Else
  Begin
    MnuFullRes.Enabled := ImgState.ReducedQuality;
    {
    if img.PI_ptrData <> nil then
      patName := img.PI_ptrData.PtName
    else
      patName := '';
      }
    PatName := FCurrentPatient.M_PatName;
    Self.caption := 'Radiology Viewer: ' + PatName;
    If ImgState.ReducedQuality Then
      Self.caption := Self.caption + ' -- Reduced Size, reference quality image';
  End;
  MnuCTPresets.Enabled := ImgState.CTPresetsEnabled;
  If ImgState.MeasurementsEnabled Then
  Begin
    MnuToolsRulerEnabled.Enabled := True;
    If ImgState.MouseAction = MactMeasure Then
     // JMW 4/15/08 - reset to true, why was false?
      MnuToolsRulerEnabled.Checked := True //false //true  //ruler// gek - I changed this to false.
    Else
      MnuToolsRulerEnabled.Checked := False;
  End
  Else
  Begin
    MnuToolsRulerEnabled.Enabled := False;
  End;
  If ImgState.MouseAction = MactAnnotationPointer Then
    MnuToolsRulerPointer.Checked := True
  Else
    MnuToolsRulerPointer.Checked := False;
  If ImgState.MouseAction = MactProtractor Then
    MnuToolsProtractorEnabled.Checked := True
  Else
    MnuToolsProtractorEnabled.Checked := False;

  // JMW 8/11/08 - set properties for the 508 menus
  MnuImageBriCon.Visible := Not ImgState.WinLevEnabled;
  MnuImageWinLev.Visible := ImgState.WinLevEnabled;
  MnuViewPanWindow.Checked := Img.PanWindow;
  // JMW 8/12/08
  // not good - the property should come from the image but the image does not
  // contain this property, so getting it from the viewer - crappy
  MnuImageApplyToAll.Checked := FCurrentViewer.ApplyToAll;

  if (img.PI_ptrData <> nil)
    and (IsProcedureForScoutLines(img.PI_ptrData.Proc, img.PI_ptrData.PlaceIEN)) then
  begin
    mnuScout.Enabled := true;
  end
  else
  begin
    // image is not relevant for scout lines, disable menu
    mnuScout.Enabled := false;
  end;

  // can full res ever be enabled in DICOM Viewer mode?

  If ImgState <> Nil Then
    FreeAndNil(ImgState);
End;

//UpdateMenuState(Mag4Viewer1.GetCurrentImage);

Procedure TfrmRadViewer.MnuViewInfoImageInfoClick(Sender: Tobject);
Var
  VGear: TMag4VGear;
  FrmRadImageInfo: TfrmRadImageInfo;
Begin

  If FViewMode = MagrvStack1 Then
  Begin
    VGear := Mag4StackViewer1.GetCurrentImage();
  End
  Else
  Begin
    If FCurrentViewer = Nil Then Exit;
    VGear := FCurrentViewer.GetCurrentImage;
  End;
  If VGear = Nil Then Exit;
  FrmRadImageInfo := TfrmRadImageInfo.Create(Self);
  FrmRadImageInfo.Execute(VGear, FForDICOMViewer);
  FreeAndNil(FrmRadImageInfo);
End;

Procedure TfrmRadViewer.MnuToolsCineClick(Sender: Tobject);
Begin
  SetCineViewerForCurrentImage();
  FrmCineView.Execute();
End;

Function TfrmRadViewer.SetCineViewerForCurrentImage(): Boolean;
Var
  VGear: TMag4VGear;
Begin
  Result := False;
  If FCurrentViewer = Nil Then Exit;
  VGear := FCurrentViewer.GetCurrentImage;
  If VGear = Nil Then Exit;
  If FrmCineView = Nil Then
  Begin
    FrmCineView := TfrmCineView.Create(Self);
    FrmCineView.OnSetParentFocus := CineSetParentFocusEvent;
    FrmCineView.SetFormUPrefs(Upref);
  End;
  {/p122t8 dmmn 11/11/11 - use this to check for annotation changes before starting cine view /}
  if frmCineView <> nil then
    frmCineView.OnCineViewStartEvent := CineViewStartEvent;
  If FrmCineView.GetCurrentGearControl = VGear Then Exit;
  FrmCineView.AssociateGearControl(VGear, FCurrentViewer);
  FrmCineView.OnCineViewChangePage := OnCineViewChangePage;
  {/p122t8 dmmn 11/11/11 - just to make sure that the pointer is correct /}
   frmCineView.OnCineViewStartEvent := CineViewStartEvent;
  // check to make sure main form is visible (DICOM Viewer when loading file as
  // parameter, viewer not visible yet)
  If Self.Visible Then
    Self.SetFocus();
  Result := True;

  // this was kinda annoying because you can't quickly scroll through images with the CINE tool open
//  if vGear.PageCount > 1 then
//    frmCineView.Execute();

  // having this hide here makes it so whenever you click on an image that has 1
  // page, the CINE tools disappears even if you wanted it there
//  else
//    frmCineView.SetHidden();
End;

Procedure TfrmRadViewer.OnCineViewChangePage(Sender: Tobject; Const PageNumber: Integer);
Var
  TViewer: IMag4Viewer;
Begin
  If FCurrentViewer.ApplyToAll Then
  Begin
    If FViewMode = MagrvStack2 Then
    Begin
      TViewer := Mag4StackViewer1;
      If TViewer = FCurrentViewer Then
      Begin
        Mag4StackViewer2.SetImagePageUseApplyToAll(PageNumber);
      End
      Else
      Begin
        Mag4StackViewer1.SetImagePageUseApplyToAll(PageNumber);
      End;
    End;
  End;
End;

Procedure TfrmRadViewer.CopyImage();
Var
  Msg: String;
  VGear: TMag4VGear;
Begin
  If FCurrentViewer = Nil Then Exit;
  VGear := FCurrentViewer.GetCurrentImage;
  If VGear = Nil Then Exit;

  If FForDICOMViewer Then
  Begin
    VGear.CopyToClipboard();
    // copy the image, no logging needed
    Msg := 'Image copy completed.' + #13#10#13#10 + 'The image that was copied has now changed.' + #13#10#13#10 + 'To view original image, please reload.';
  End
  Else
  Begin
//    stBarInfo.Panels[1].Text := 'Copying: ' + vgear.PI_ptrData.ExpandedDescription + ' . . . ';
    ImageCopyEsigReason(VGear);
//    stBarInfo.Panels[1].Text := '';
    Msg := 'Image copy completed.' + #13#10#13#10 + 'The image that was copied has now changed.' + #13#10#13#10 + 'To view original image, please reload by clicking on abstract.';
  End;

  // JMW P72 2/14/2007 - I don't think we need to display this warning message anymore
  // I don't think IG 15 messes up the image like IG 99 did
//  MessageDlgPos(msg, mtWarning, [mbOK], 0, self.left, self.top);
  // show confirmation message?
End;

Procedure TfrmRadViewer.PrintImage();
Var
  VGear: TMag4VGear;
Begin
  If FCurrentViewer = Nil Then Exit;
  VGear := FCurrentViewer.GetCurrentImage;
  If VGear = Nil Then Exit;
  If FForDICOMViewer Then
  Begin
    PrintImageInternal();
  End
  Else
  Begin
//    stBarInfo.Panels[1].Text := 'Printing: ' + vgear.PI_ptrData.ExpandedDescription + ' . . . ';
    ImagePrintEsigReason(VGear);      {BM-ImagePrint-}
//    stBarInfo.Panels[1].Text := '';
  End;
End;

Procedure TfrmRadViewer.PrintImageInternal();
Var
  VGear: TMag4VGear;
  Printmsg: String;
  Myprintdialog: TPrintDialog;
  Reason: String;
  i, y: Integer;
Begin
  //if GetEsig(xmsg) then //TODO ESIG
  Begin
    VGear := FCurrentViewer.GetCurrentImage;
    (* Add SSN Take out Image IEN
    printmsg := vGear.PI_ptrData.PtName + ' ' + vGear.PI_ptrData.ExpandedIDDescription(false);*)
    Printmsg := VGear.PI_ptrData.PtName + ' ' + VGear.PI_ptrData.SSN + ' ' + VGear.PI_ptrData.ExpandedDescription(False);
    Myprintdialog := TPrintDialog.Create(Self);
    Screen.Cursor := crHourGlass;
    Try
      Myprintdialog.Options := [PoPageNums];
      Myprintdialog.MinPage := 1;
      Myprintdialog.MaxPage := VGear.PageCount; // vGear.Gear1.pagecount;
      Myprintdialog.FromPage := 1; //p48T3 vGear.Gear1.page;
      Myprintdialog.ToPage := VGear.PageCount; // vGear.Gear1.pagecount; //p48t3 page;
      Myprintdialog.PrintRange := PrPageNums;
      If Myprintdialog.Execute Then
      Begin
        Try
          Try
            If Myprintdialog.PrintRange = PrAllPages Then
            Begin
              Myprintdialog.FromPage := 1;
              Myprintdialog.ToPage := VGear.PageCount;
            End;
            {
            vGear.Gear1.SettingMode := MODE_PRINTDRIVER;
            vGear.Gear1.SettingValue := 1;
            vGear.Gear1.Printsize := IG_PRINT_FULL_PAGE;
            }
            VGear.SetSettingMode(7);
            VGear.SetSettingValue(1);
            VGear.SetPrintSize(0);
            Printer.Title := Printmsg;
            Printer.BeginDoc;        {BM-ImagePrint-   Calls TMag4VGear.PrintImage}
            For i := Myprintdialog.FromPage To Myprintdialog.ToPage Do
            Begin
              // JMW 4/10/06 p72 moved up to display title properly
              Printer.Canvas.Textout(10, 0, Printmsg + '    --- page ' + Inttostr(i) + ' of ' + Inttostr(VGear.PageCount) + '  ---');
              //vGear.Gear1.page := I;
              //vGear.Gear1.printimage := printer.Handle;
              VGear.Page := i;
              VGear.PrintImage(Printer.Handle);
              If i < Myprintdialog.ToPage Then
                Printer.Newpage
            End;
            //LogMsg('','Image Printed.', magmsginfo);
            MagAppMsg('', 'Image Printed.', magmsginfo); {JK 10/6/2009 - Maggmsgu refactoring}
          Except
            On e: Exception Do
            Begin
                //LogMsg('','ERROR Printing: ' + E.Message, magmsgError);
              MagAppMsg('', 'ERROR Printing: ' + e.Message, magmsgError); {JK 10/6/2009 - Maggmsgu refactoring}
            End;
          End;
        Finally
          Printer.Enddoc
        End;
      End;
    Finally
      Myprintdialog.Free;
      Screen.Cursor := crDefault
    End;
  End;

End;

procedure TfrmRadViewer.PrintOptions1Click(Sender: TObject);          {p149}
begin
OpenPrintPreviewRadViewer();
end;

Procedure TfrmRadViewer.MnuFileCopyClick(Sender: Tobject);
Begin
  CopyImage();
End;

Procedure TfrmRadViewer.MnuFilePrintClick(Sender: Tobject);
Begin
  PrintImage();
End;

Procedure TfrmRadViewer.MnuFileReportClick(Sender: Tobject);
Begin
  If FCurrentViewer = Nil Then Exit;
  FCurrentViewer.ImageReport();

End;

Procedure TfrmRadViewer.MnuViewInfoRadiologyImageInfoClick(
  Sender: Tobject);
Var
  VGear: TMag4VGear;
  FrmRadiologyImageInfo: TfrmRadiologyImageInfo;
Begin
  If FCurrentViewer = Nil Then Exit;
  VGear := FCurrentViewer.GetCurrentImage;
  If VGear = Nil Then Exit;
  FrmRadiologyImageInfo := TfrmRadiologyImageInfo.Create(Self);
  FrmRadiologyImageInfo.Execute(VGear);
  FreeAndNil(FrmRadiologyImageInfo);
End;

Procedure TfrmRadViewer.Exit1Click(Sender: Tobject);
Begin
  Self.Close();
End;

Procedure TfrmRadViewer.MnuImageInvertClick(Sender: Tobject);
Begin
  MagViewerTB1.Inverse();
  {
  if FCurrentViewer = nil then exit;
  FCurrentViewer.Inverse();
  }
End;

procedure TfrmRadViewer.mnuRGBFullClick(Sender: TObject);
begin
  //p130t11 dmmn 4/8/12 - change the selected image(s) color channel to full colors
  // Current State: 0 1 2 3 4 - RGB R G B
  MagViewerTB1.RGBChanger(3);
end;

procedure TfrmRadViewer.OpenPrintPreviewRadViewer();          {p149}
Var
  Magien: String;
  TempIobj: TImageData;
  VGear: TMag4VGear;
  FullResSpec: TfrmFullResSpecial;
Begin
  If FCurrentViewer = Nil Then Exit;
  VGear := FCurrentViewer.GetCurrentImage;
  If VGear = Nil Then Exit;
  tempIobj := VGear.PI_ptrData;
  Try
    Magien := '';
     if TempIobj = nil then
              begin
              showmessage('First: Select an Image.');
              exit;
         end;
     magien := tempIobj.Mag0;
    Begin
      If Magien <> '' Then
      begin
      frmFullResSpecial.execute(TempIobj,'Print');
      End
      Else
      Begin
        showmessage('First: Select an Image.');
      End;
    End;

  Finally
  //

  End;
End;

procedure TfrmRadViewer.mnuRGBBlueClick(Sender: TObject);
begin
  //p130t11 dmmn 4/8/12 - change the selected image(s) color channel to blue
  // Current State: 0 1 2 3 - RGB R G B
  MagViewerTB1.RGBChanger(2);
end;

procedure TfrmRadViewer.mnuRGBGreenClick(Sender: TObject);
begin
  //p130t11 dmmn 4/8/12 - change the selected image(s) color channel to green
  // Current State: 0 1 2 3 4 - RGB R G B
  MagViewerTB1.RGBChanger(1);
end;

procedure TfrmRadViewer.mnuRGBRedClick(Sender: TObject);
begin
  //p130t11 dmmn 4/8/12 - change the selected image(s) color channel to red
  // Current State: 0 1 2 3 4 - RGB R G B
  MagViewerTB1.RGBChanger(0);
end;

Procedure TfrmRadViewer.MnuImageResetImageClick(Sender: Tobject);
Begin
  If FCurrentViewer = Nil Then Exit;
  FCurrentViewer.ResetImages();
  MagViewerTB1.UpdateImageState();
End;

Procedure TfrmRadViewer.MnuRotateClockwise90Click(Sender: Tobject);
Begin
  MagViewerTB1.Rotate90();
End;

Procedure TfrmRadViewer.MnuRotateMinus90Click(Sender: Tobject);
Begin
  MagViewerTB1.Rotate270();
End;

Procedure TfrmRadViewer.MnuRotate180Click(Sender: Tobject);
Begin
  MagViewerTB1.Rotate180();
End;

Procedure TfrmRadViewer.MnuRotateFlipHorizontalClick(Sender: Tobject);
Begin
  MagViewerTB1.FlipHorizontal();
End;

Procedure TfrmRadViewer.MnuRotateFlipVerticalClick(Sender: Tobject);
Begin
  MagViewerTB1.FlipVertical();
End;

Procedure TfrmRadViewer.MnuCTPresetsAbdomenClick(Sender: Tobject);
Begin
  //setWindowLevel(350, 1040);
  SetWindowLevel(MagPiece(CTPresets[0], '|', 2), MagPiece(CTPresets[0], '|', 3));
  SetStackPageWithDiffernetSettings(True);
End;

Procedure TfrmRadViewer.MnuCTPresetsBoneClick(Sender: Tobject);
Begin
//  setWindowLevel(500, 1274);
  SetWindowLevel(MagPiece(CTPresets[1], '|', 2), MagPiece(CTPresets[1], '|', 3));
  SetStackPageWithDiffernetSettings(True);
End;

Procedure TfrmRadViewer.MnuCTPresetsDiskClick(Sender: Tobject);
Begin
//  setWindowLevel(950, 1240);
  SetWindowLevel(MagPiece(CTPresets[2], '|', 2), MagPiece(CTPresets[2], '|', 3));
  SetStackPageWithDiffernetSettings(True);

End;

Procedure TfrmRadViewer.MnuCTPresetsHeadClick(Sender: Tobject);
Begin
//  setWindowLevel(80, 1040);
  SetWindowLevel(MagPiece(CTPresets[3], '|', 2), MagPiece(CTPresets[3], '|', 3));
  SetStackPageWithDiffernetSettings(True);
End;

Procedure TfrmRadViewer.MnuCTPresetsLungClick(Sender: Tobject);
Begin
//  setWindowLevel(1000, 300);
  SetWindowLevel(MagPiece(CTPresets[4], '|', 2), MagPiece(CTPresets[4], '|', 3));
  SetStackPageWithDiffernetSettings(True);
End;

Procedure TfrmRadViewer.MnuCTPresetsMediastinumClick(Sender: Tobject);
Begin
//  setWindowLevel(500, 1040);
  SetWindowLevel(MagPiece(CTPresets[5], '|', 2), MagPiece(CTPresets[5], '|', 3));
  SetStackPageWithDiffernetSettings(True);
End;

Procedure TfrmRadViewer.SetWindowLevel(Win, Lev: Integer);
Begin
  If FCurrentViewer = Nil Then Exit;
  If (FViewMode = MagrvStack2) And (FCurrentViewer.ApplyToAll) Then
  Begin
    Mag4StackViewer1.WinLevValue(Win, Lev);
    Mag4StackViewer2.WinLevValue(Win, Lev);
  End
  Else
  Begin
    FCurrentViewer.WinLevValue(Win, Lev);
  End;
  MagViewerTB1.UpdateImageState;
End;

Procedure TfrmRadViewer.SetWindowLevel(Win, Lev: String);
Var
  Window, Level: Integer;
Begin
  Try
    Window := Strtoint(Win);
    Level := Strtoint(Lev);
    SetWindowLevel(Window, Level);
  Except
    On e: Exception Do
    Begin
      //LogMsg('s',e.Message, magmsgError);
      MagAppMsg('s', e.Message, magmsgError); {JK 10/6/2009 - Maggmsgu refactoring}
      // do nothing
    End;
  End;

End;

{Menu for displaying the scout window}
procedure TfrmRadViewer.mnuScoutAddImagetoScoutWindowClick(Sender: TObject);
var
  study : TMagStudyDetails;
begin
  study := GetCurrentStudy();
  if (FCurrentViewer <> nil) and (study <> nil) then
    AddImageToScoutWindow(FCurrentViewer.GetCurrentImage(), study,
      GetCurrentViewerIndex());

end;

procedure TfrmRadViewer.mnuScoutAutoDetectScoutImagesClick(Sender: TObject);
begin
  SetOptionsDisplayScoutWindow(mnuScoutAutoDetectScoutImages.Checked);
  if (mnuScoutAutoDetectScoutImages.Checked) and
    (mnuScoutAutoDetectScoutImages.Enabled) then
    mnuScoutShowScoutWindowClick(self);
end;

procedure TfrmRadViewer.mnuScoutColorBlueClick(Sender: TObject);
begin
  SetOptionsScoutLineColor(clBlue);
end;

procedure TfrmRadViewer.mnuScoutColorGreenClick(Sender: TObject);
begin
  SetOptionsScoutLineColor(clGreen);
end;

procedure TfrmRadViewer.mnuScoutColorRedClick(Sender: TObject);
begin
  SetOptionsScoutLineColor(clRed);
end;

procedure TfrmRadViewer.mnuScoutColorYellowClick(Sender: TObject);
begin
  SetOptionsScoutLineColor(clYellow);
end;

procedure TfrmRadViewer.mnuScoutDisplayScoutLinesClick(Sender: TObject);
var
  curStudy : TMagStudyDetails;
  i : integer;
  currentlyDisplayedStudies : TList;
begin
  SetOptionsDisplayScoutLines(mnuScoutDisplayScoutLines.Checked);
  { DONE -oJMW -cP131 : Determine if the study has been loaded fully and display scout lines if applicable }

  if mnuScoutDisplayScoutLines.Checked then
  begin
    currentlyDisplayedStudies := GetCurrentlyDisplayedStudies();
    for i := 0 to currentlyDisplayedStudies.Count - 1 do
    begin
      // ensure all displayed studies are loaded
      curStudy := currentlyDisplayedStudies[i];
      ScoutLoadStudy(curStudy.RootImg, curStudy.StudyList);
    end;
    FreeAndNil(currentlyDisplayedStudies);
    // display the scout window if checked
    if (mnuScoutAutoDetectScoutImages.Checked)
      and (mnuScoutAutoDetectScoutImages.Enabled) then
    begin
      mnuScoutShowScoutWindowClick(self);
    end;
  end
  else
  begin
    // scout lines disabled, hide them in all viewers
    ClearAllScoutLines();
  end;
end;

procedure TfrmRadViewer.mnuScoutShowScoutWindowClick(Sender: TObject);
var
  study : TMagStudyDetails;
  ViewerNumber : integer;
begin
  study := GetCurrentStudy();
  ViewerNumber := 1;
  if study = FStudy2 then
    ViewerNumber := 2;

  // ensure this study is loaded properly
  ScoutLoadStudy(study.RootImg, study.StudyList);

  // this opens the scout window
  DisplayScoutWindow(study.RootImg, ViewerNumber);
  // this sets the line to the currently displayed image
  ImageSelectedDrawAssociatedScoutLines(FCurrentViewer.GetCurrentImage(),
    ViewerNumber);
end;

Procedure TfrmRadViewer.AutoViewCineTool();
Var
  VGear: TMag4VGear;
Begin
  // check user preference to see if user wants to auto-view cine tool
//  exit; // don't want it to auto load right now...
  If FCurrentViewer = Nil Then Exit;
  VGear := FCurrentViewer.GetCurrentImage;
  If VGear = Nil Then Exit;
  If FrmCineView = Nil Then Exit;
  If (VGear.PageCount > 1) Or (FrmCineView.Visible) Then
  Begin
    FrmCineView.Execute();
    If Self.Visible Then
      Self.SetFocus();
  End;

End;

Procedure TfrmRadViewer.MnuViewInfoInformationAdvancedClick(
  Sender: Tobject);
Var
  VGear: TMag4VGear;
Begin
  If FCurrentViewer = Nil Then Exit;
  VGear := FCurrentViewer.GetCurrentImage;
  If VGear = Nil Then Exit;
(*  P93T8   Modify this Dialog to implement the execute method.  Low Coupling.
    if not DoesFormExist('frmMagImageInfoSys') then
    begin
      Application.CreateForm(TfrmMagImageInfoSys, frmMagImageInfoSys) ;// := TfrmMagImageInfoSys.create(self);
    end;
  frmMagImageInfoSys.DisplayImageInfo(vGear.PI_ptrData);
  frmMagImageInfoSys.show;
  *)
//frmMagImageInfoSys.execute(vGear.PI_ptrData);
  OpenImageInfoSys(VGear.PI_ptrData);
End;

Procedure TfrmRadViewer.SetCTPresets(Value: TStrings);
Var
  CustomUsed: Boolean;
Begin
  If FCTPresets = Nil Then
    FCTPresets := Tstringlist.Create()
  Else
    FCTPresets.Clear();

  FCTPresets.AddStrings(Value);
  CustomUsed := False;
  If FCTPresets[6] = '' Then
  Begin
    MnuCTCustom1.Visible := False;
  End
  Else
  Begin
    CustomUsed := True;
    MnuCTCustom1.caption := MagPiece(FCTPresets[6], '|', 1);
    MnuCTCustom1.Visible := True;
  End;
  If FCTPresets[7] = '' Then
  Begin
    MnuCTCustom2.Visible := False;
  End
  Else
  Begin
    CustomUsed := True;
    MnuCTCustom2.caption := MagPiece(FCTPresets[7], '|', 1);
    MnuCTCustom2.Visible := True;
  End;
  If FCTPresets[8] = '' Then
  Begin
    MnuCTCustom3.Visible := False;
  End
  Else
  Begin
    CustomUsed := True;
    MnuCTCustom3.caption := MagPiece(FCTPresets[8], '|', 1);
    MnuCTCustom3.Visible := True;
  End;

  If Not CustomUsed Then
  Begin
    MnuCTBar1.Visible := False;
  End;

  // JMW 4/30/2013 P131 ensure Scout Windows have the latest CT Preset values
  if FScoutWindow1 <> nil then
  begin
    FScoutWindow1.SetCTPresets(FCTPresets);
  end;
  if FScoutWindow2 <> nil then
  begin
    FScoutWindow2.SetCTPresets(FCTPresets);
  end;             
End;

Procedure TfrmRadViewer.SetConfigureCTEnabled(Value: Boolean);
Begin
  FConfigureCTEnabled := Value;
  MnuCTBar2.Visible := FConfigureCTEnabled;
  MnuCTConfigure.Visible := FConfigureCTEnabled;
End;

Procedure TfrmRadViewer.MnuCTCustom1Click(Sender: Tobject);
Begin
  SetWindowLevel(MagPiece(CTPresets[6], '|', 2), MagPiece(CTPresets[6], '|', 3));
  SetStackPageWithDiffernetSettings(True);
End;

Procedure TfrmRadViewer.MnuCTCustom2Click(Sender: Tobject);
Begin
  SetWindowLevel(MagPiece(CTPresets[7], '|', 2), MagPiece(CTPresets[7], '|', 3));
  SetStackPageWithDiffernetSettings(True);
End;

Procedure TfrmRadViewer.MnuCTCustom3Click(Sender: Tobject);
Begin
  SetWindowLevel(MagPiece(CTPresets[8], '|', 2), MagPiece(CTPresets[8], '|', 3));
  SetStackPageWithDiffernetSettings(True);
End;

Procedure TfrmRadViewer.MnuCTConfigureClick(Sender: Tobject);
Begin
  FrmCTConfigure.Execute(Self, FCTPresets);
End;

Procedure TfrmRadViewer.SetCurrentPatient(Value: TMag4Pat);
Begin
  FCurrentPatient := Value;
  Mag4Viewer1.CurrentPatientSSN := FCurrentPatient.M_SSN;
  Mag4StackViewer1.CurrentPatientSSN := FCurrentPatient.M_SSN;
  Mag4StackViewer2.CurrentPatientSSN := FCurrentPatient.M_SSN;

  Mag4Viewer1.CurrentPatientICN := FCurrentPatient.M_ICN;
  Mag4StackViewer1.CurrentPatientICN := FCurrentPatient.M_ICN;
  Mag4StackViewer2.CurrentPatientICN := FCurrentPatient.M_ICN;

End;

Procedure TfrmRadViewer.MnuFileOpenImageClick(Sender: Tobject);
Var
  IObj: TImageData;
  Filename: String;
  ImgToShow, i: Integer;
  t: Tlist;
Begin
  OpenDialog1.Filter := ImageFilter;
  OpenDialog1.Title := 'Open Image';
  If Not OpenDialog1.Execute Then Exit;
  t := Tlist.Create();
  For i := 0 To OpenDialog1.Files.Count - 1 Do
  Begin
    Filename := OpenDialog1.Files[i];
    IObj := TImageData.Create();
    IObj.FFile := Filename;
    IObj.Mag0 := Filename;
    IObj.ImgDes := Filename;

    If (i = 0) And (FStudy1.StudyList.Count = 0) Then
    Begin
      FStudy1.RootImg := IObj;
      FStudy1.Studydesc := 'Displaying';
    End;
    FStudy1.StudyList.Add(IObj);
    t.Add(IObj);
  End;
  ImgToShow := FStudy1.StudyList.Count - OpenDialog1.Files.Count; // - 1;

  OpenStudy(FStudy1.RootImg, t, FStudy1.Studydesc, 1, ImgToShow, True);
  SetCineViewerForCurrentImage();
  FreeAndNil(t);
End;

Procedure TfrmRadViewer.MnuFileClearAllClick(Sender: Tobject);
Begin
  //clear all visible viewers! need to check current view for visible components
  {
  if Mag4StackViewer1.Visible then
    Mag4StackViewer1.ClearViewer();
  if Mag4Viewer1.Visible then
    Mag4Viewer1.ClearViewer();
  if Mag4StackViewer2.Visible then
    Mag4StackViewer2.ClearViewer();
  }
  Mag4StackViewer1.ClearViewer();
  Mag4StackViewer2.ClearViewer();
  Mag4Viewer1.ClearViewer();

  FStudy1.StudyList.Clear();
  FStudy1.RootImg.Clear();
  FStudy1.Studydesc := '';

  FStudy2.StudyList.Clear();
  FStudy2.RootImg.Clear();
  FStudy2.Studydesc := '';

End;

Procedure TfrmRadViewer.MnuFileCloseSelectedClick(Sender: Tobject);
Var
  CurIndex: Integer;
  IObj: TImageData;
  CurViewer: IMag4Viewer;
Begin
  CurIndex := FCurrentViewer.GetCurrentImageIndex();
  FCurrentViewer.RemoveFromList;
  FCurrentViewer.ReAlignImages();

  CurViewer := Mag4Viewer1;
  If CurViewer = FCurrentViewer Then
  Begin
    If CurIndex >= FStudy1.StudyList.Count Then Exit;
    IObj := FStudy1.StudyList.Items[CurIndex];
    FStudy1.StudyList.Remove(IObj);
    CurViewer := Nil;
    Exit;
  End;
  CurViewer := Mag4StackViewer1;
  If CurViewer = FCurrentViewer Then
  Begin
    If CurIndex >= FStudy1.StudyList.Count Then Exit;
    IObj := FStudy1.StudyList.Items[CurIndex];
    FStudy1.StudyList.Remove(IObj);
    CurViewer := Nil;
    Exit;
  End;
  CurViewer := Mag4StackViewer2;
  If CurViewer = FCurrentViewer Then
  Begin
    If CurIndex >= FStudy2.StudyList.Count Then Exit;
    IObj := FStudy2.StudyList.Items[CurIndex];
    FStudy2.StudyList.Remove(IObj);
    CurViewer := Nil;
    Exit;
  End;
End;

Procedure TfrmRadViewer.MnuHelpAboutClick(Sender: Tobject);
Begin
  FrmAbout := TfrmAbout.Create(Self);
  FrmAbout.Execute('', '', Nil);
  FreeAndNil(FrmAbout);
End;

Procedure TfrmRadViewer.MnuOptionsStackPageTogetherClick(Sender: Tobject);
Begin
  SetOptionsStackPage(MnuOptionsStackPageTogether.Checked);
End;

Procedure TfrmRadViewer.SetOptionsStackPage(Value: Boolean);
Begin
  If (MnuOptionsStackPageTogether.Checked) <> Value Then MnuOptionsStackPageTogether.Checked := Value;
  // if not paging together
  If Not Value Then
  Begin
            // if paging with the same settings
    If MnuOptionsStackPageWithSameSettings.Checked Then
    Begin
              // change to paging with image settings (since not paging together)
      SetStackPageWithImageSettings(True);
    End;
  End;
  MnuOptionsStackPageWithSameSettings.Enabled := MnuOptionsStackPageTogether.Checked;
End;

Procedure TfrmRadViewer.MnuOptionsLayoutIndividualImageSettingsClick(Sender: Tobject);
Begin { = 2}
  SetLayoutSettings(2);
End;

Procedure TfrmRadViewer.MnuOptionsLayoutSelectedWindowSettingsClick(Sender: Tobject);
Begin {  =1}
  SetLayoutSettings(1);
End;

Procedure TfrmRadViewer.SetLayoutSettings(Value: Integer);
Begin
  If (Value < 1) Or (Value > 2) Then Value := 2; // jmw default to individual image settings
  Case Value Of
    1:
      Begin
        MnuOptionsLayoutSelectedWindowSettings.Checked := True;
        MnuOptionsLayoutIndividualImageSettings.Checked := False;
        Mag4Viewer1.WindowLevelSettings := MagWinLevFromCurrentImage
      End;
    2:
      Begin
        MnuOptionsLayoutSelectedWindowSettings.Checked := False;
        MnuOptionsLayoutIndividualImageSettings.Checked := True;
        Mag4Viewer1.WindowLevelSettings := MagWinLevImageSettings;
      End;
  End;

End;

Procedure TfrmRadViewer.Openin2ndStack1Click(Sender: Tobject);
Var
  IObj: TImageData;
  Filename: String;
  ImgToShow, i: Integer;
  t: Tlist;
Begin
  OpenDialog1.Filter := ImageFilter;
  OpenDialog1.Title := 'Open in 2nd Stack';
  If Not OpenDialog1.Execute Then Exit;
  t := Tlist.Create();
  For i := 0 To OpenDialog1.Files.Count - 1 Do
  Begin
    Filename := OpenDialog1.Files[i];
    IObj := TImageData.Create();
    IObj.FFile := Filename;
    IObj.Mag0 := Filename;
    IObj.ImgDes := Filename;

    If (i = 0) And (FStudy2.StudyList.Count = 0) Then
    Begin
      FStudy2.RootImg := IObj;
      FStudy2.Studydesc := 'Displaying';
    End;
    FStudy2.StudyList.Add(IObj);
    t.Add(IObj);
  End;
  ImgToShow := FStudy2.StudyList.Count - OpenDialog1.Files.Count; // - 1;
  OpenStudy(FStudy2.RootImg, t, FStudy2.Studydesc, 2, ImgToShow, True);
  SetCineViewerForCurrentImage();
  FreeAndNil(t);
End;

Procedure TfrmRadViewer.DicomDirChangeView(Sender: Tobject; StackView: Boolean);
Begin
  MnuViewSettings2x1Click(Self);
End;

Procedure TfrmRadViewer.DicomDirImageLoad(Sender: Tobject; IObj: TImageData; ViewerNum: Integer = 1);
Var
  CurStudy: TMagStudyDetails;
  NewImgs: Tlist;
Begin
  If ViewerNum = 1 Then
    CurStudy := FStudy1
  Else
    CurStudy := FStudy2;
  NewImgs := Tlist.Create();

  If CurStudy.StudyList.Count = 0 Then
  Begin
    CurStudy.RootImg := IObj;
    CurStudy.Studydesc := 'Displaying';
  End;
  CurStudy.StudyList.Add(IObj);
  NewImgs.Add(IObj);
  OpenStudy(CurStudy.RootImg, NewImgs, CurStudy.Studydesc, ViewerNum, CurStudy.StudyList.Count - 1, True);
  SetCineViewerForCurrentImage();
  FreeAndNil(NewImgs);

End;

Procedure TfrmRadViewer.MnuFileDirectoryClick(Sender: Tobject);
Begin

  If FrmDICOMDir = Nil Then
    FrmDICOMDir := TfrmDICOMDir.Create(Self);
  FrmDICOMDir.OnChangeViewEvent := DicomDirChangeView;
  FrmDICOMDir.OnOpenImageEvent := DicomDirImageLoad;
  FrmDICOMDir.Execute();
End;

Procedure TfrmRadViewer.OpenStudy(RootImg: TImageData; ImgList: Tlist;
  Studydesc: String = ''; ViewerNum: Integer = 1; ImgIndex: Integer = -1;
  AppendImages: Boolean = False);
Var
  CurStudy: TMagStudyDetails;
  ListToUse: Tlist;
//  RootImgProcedure : String;
  radiologyStudy : TMagRadiologyStudy;
Begin
  FisClosing := False;

  If (ViewerNum = 2) Then
  Begin
    CurStudy := FStudy2;
    CurStudy.CurrentImage := ImgIndex; // JMW 11/30/06 makes the selected image appear from the directory for the 2nd stack (might also fix problem from group abs window?)
    If ViewMode <> MagrvStack2 Then
    Begin
      If Not IsStudyAlreadyLoaded(RootImg, ImgList.Count, CurStudy) Then
      Begin
        CurStudy.RootImg.MagAssign(RootImg);
        CopyImagesToStackList(ImgList, CurStudy.StudyList);
        CurStudy.Studydesc := Studydesc;
        CloseScoutWindow(ViewerNum); // ensure the scout window is reset to not show the previous images

        // only load scout data if want to display scout lines
        if mnuScoutDisplayScoutLines.Checked then
        begin
          radiologyStudy := ScoutLoadStudy(RootImg, ImgList);
          // find scout images only if the user wants to see them
          if (mnuScoutAutoDetectScoutImages.Checked)
            and (mnuScoutAutoDetectScoutImages.Enabled) then
          begin
            if radiologyStudy <> nil then
              DisplayScoutWindow(RootImg, ViewerNum, radiologyStudy);
          end;
        end;
               {
        uMagRadHeaderLoader.Initialize(); // just in case
        RootImgProcedure := RootImg.Proc;
        if (Pos('CT', RootImgProcedure) > 0) or (Pos('MR', RootImgProcedure) > 0) then
        begin
          radiologyStudy := uMagRadHeaderLoader.LoadStudyImages(RootImg, imgList);
          uMagRadHeaderLoader.GetStudyHolder().AddUniqueStudy(radiologyStudy);
      //if Pos('CT', RootImgProcedure) > 0 then
      //begin
          DisplayScoutWindow(RootImg, ViewerNum, radiologyStudy);
      //end;
        end;
        }
      End;
      CurStudy.CurrentImage := ImgIndex;
      ViewMode := MagrvStack2; // this should cause resize event
      Exit;
    End;
  End
  Else
  Begin
    CurStudy := FStudy1;
    CurStudy.CurrentImage := ImgIndex;
  End;

  If (Not IsStudyAlreadyLoaded(RootImg, ImgList.Count, CurStudy)) And (Not AppendImages) Then
  Begin
    CurStudy.RootImg.MagAssign(RootImg);
    CopyImagesToStackList(ImgList, CurStudy.StudyList);
    CurStudy.Studydesc := Studydesc;
    CloseScoutWindow(ViewerNum); // ensure the scout window is reset to not show the previous images

    // only load scout data if want to display scout lines
    if mnuScoutDisplayScoutLines.Checked then
    begin
      radiologyStudy := ScoutLoadStudy(RootImg, ImgList);
      // find scout images only if the user wants to see them
      if (mnuScoutAutoDetectScoutImages.Checked)
        and (mnuScoutAutoDetectScoutImages.Enabled) then
      begin
        if radiologyStudy <> nil then
          DisplayScoutWindow(RootImg, ViewerNum, radiologyStudy);
      end;
    end;

    {
    uMagRadHeaderLoader.Initialize(); // just in case
    RootImgProcedure := RootImg.Proc;
    if (Pos('CT', RootImgProcedure) > 0) or (Pos('MR', RootImgProcedure) > 0) then
    begin
      radiologyStudy := uMagRadHeaderLoader.LoadStudyImages(RootImg, imgList);
      uMagRadHeaderLoader.GetStudyHolder().AddUniqueStudy(radiologyStudy);
      //if Pos('CT', RootImgProcedure) > 0 then
      //begin
        DisplayScoutWindow(RootImg, ViewerNum, radiologyStudy);
      //end;
    end;
    }
  End;

  If AppendImages Then
    ListToUse := ImgList
  Else
    ListToUse := CurStudy.StudyList;

  If FrmCineView <> Nil Then
    FrmCineView.AssociateGearControl(Nil, Nil);

  If (FViewMode = MagrvStack1) Or (FViewMode = MagrvStack2) Then
  Begin
    If ViewerNum = 1 Then
    Begin
      Mag4StackViewer1.OpenStudy(CurStudy.RootImg, ListToUse, CurStudy.Studydesc, CurStudy.CurrentImage, AppendImages);
      Mag4StackViewer1.SetSelected();
      // unselect other viewer item and set the current viewer to this viewer
      Mag4StackViewer2.UnSelectAll();
      FCurrentViewer := Mag4StackViewer1;
    End
    Else
      If ViewerNum = 2 Then
      Begin
        Mag4StackViewer2.OpenStudy(CurStudy.RootImg, ListToUse, CurStudy.Studydesc, CurStudy.CurrentImage, AppendImages);
        Mag4StackViewer2.SetSelected();
      // unselect other viewer item and set the current viewer to this viewer
        Mag4StackViewer1.UnSelectAll();
        FCurrentViewer := Mag4StackViewer2;
      End;
    MagViewerTB1.UpdateImageState();
  End
  Else
  Begin
//    if Mag4Viewer1.isStudyAlreadyLoaded(RootImg.Mag0, RootImg.ServerName, RootImg.ServerPort, imgList.Count) then
    If Mag4Viewer1.IsStudyAlreadyLoaded(RootImg.Mag0, RootImg.ServerName, RootImg.ServerPort, CurStudy.StudyList.Count) Then
    Begin
      If CurStudy.CurrentImage < 0 Then
        CurStudy.CurrentImage := 0;
      Mag4Viewer1.ShowImage(CurStudy.CurrentImage);
    End
    Else
    Begin
      If AppendImages Then
      Begin
        FOpenCompleted := False;
        // 11/30/06 changed allow dup to true, not sure if this is what we want?
        Mag4Viewer1.ImagesToMagView(ImgList, True, CurStudy.CurrentImage);
        FOpenCompleted := True;
      End
      Else
      Begin
//      if not FForDICOMViewer then
        Mag4Viewer1.ClearViewer();
        FOpenCompleted := False;
        Mag4Viewer1.PnlTop.caption := '';
      //Mag4Viewer1.SetViewerDesc(RootImg.ExpandedDescription(false), true);
        Mag4Viewer1.SetViewerDesc(CurStudy.Studydesc, True);
        Mag4Viewer1.ImagesToMagView(ImgList, False, CurStudy.CurrentImage);
        FOpenCompleted := True;
      End;
    End;
  End;

  If FCurrentViewer <> Nil Then
    UpdateMenuState(FCurrentViewer.GetCurrentImage);

  If SetCineViewerForCurrentImage() Then
    AutoViewCineTool();

End;

Function TfrmRadViewer.IsStudyAlreadyLoaded(RootImg: TImageData; ImgCount: Integer; Study: TMagStudyDetails): Boolean;
Begin
  Result := False;
  If Study.RootImg = Nil Then Exit;
  If Study.StudyList = Nil Then Exit;
  If RootImg.Mag0 <> Study.RootImg.Mag0 Then Exit;
  If RootImg.ServerName <> Study.RootImg.ServerName Then Exit;
  If RootImg.ServerPort <> Study.RootImg.ServerPort Then Exit;
  If ImgCount <> Study.StudyList.Count Then Exit;
  Result := True;
End;

Procedure TfrmRadViewer.CopyImagesToStackList(Images: Tlist; StackList: Tlist);
Var
  i: Integer;
  NewImg, IObj: TImageData;
Begin
  If StackList = Nil Then
    StackList := Tlist.Create()
  Else
    StackList.Clear();
  For i := 0 To Images.Count - 1 Do
  Begin
    IObj := Images.Items[i];
    NewImg := TImageData.Create();
    NewImg.MagAssign(IObj);
    StackList.Add(NewImg);
  End;
End;

Procedure TfrmRadViewer.Mag4StackViewer1ClickEvent(Sender: Tobject; StackViewer: TMag4StackViewer; MagImage: TMag4VGear);
Var
  VGear: TMag4VGear;
  newViewer : boolean;
Begin
  {/p122 dmmn 8/15/11 - change stack view while in annotation mode for the other stack /}
  if Mag4StackViewer2.Mag4Vgear1.AnnotationComponent.IsAnnotationMode then
  begin
    CloseAnnotationToolbar('Mag4StackViewer2');
  end
  else
  begin
    if GetCurrentStackIndex() = 1 then
      newViewer := false
    else
      newViewer := true;
    FCurrentViewer := Mag4StackViewer1;
    VGear := FCurrentViewer.GetCurrentImage;
    Mag4StackViewer1.CanShowAnnotToolbar := True;     //p122t7 dmmn 11/2/11 - fix focus problem for stacks with annotation mode is false
    If VGear <> Nil Then
      UpdateMenuState(VGear);
    MagViewerTB1.MagViewer := FCurrentViewer;
    If Mag4StackViewer2.Visible Then
      Mag4StackViewer2.UnSelectAll();
    MagViewerTB1.UpdateImageState;
    If SetCineViewerForCurrentImage() Then
      AutoViewCineTool();
    if newViewer then
        ImageSelectedDrawAssociatedScoutLines(FCurrentViewer.GetCurrentImage(),
          1);    
  end;

End;

Procedure TfrmRadViewer.Mag4StackViewer2ClickEvent(Sender: Tobject; StackViewer: TMag4StackViewer; MagImage: TMag4VGear);
Var
  VGear: TMag4VGear;
  newViewer : boolean;
Begin
  {/p122 dmmn 8/15/11 - change stack view while in annotation mode for the other stack /}
  if Mag4StackViewer1.Mag4Vgear1.AnnotationComponent.IsAnnotationMode then
  begin
    CloseAnnotationToolbar('Mag4StackViewer1');
  end
  else
  begin
    if GetCurrentStackIndex() = 2 then
      newViewer := false
    else
      newViewer := true;
    FCurrentViewer := Mag4StackViewer2;
    VGear := FCurrentViewer.GetCurrentImage;
    Mag4StackViewer2.CanShowAnnotToolbar := True;     //p122t7 dmmn 11/2/11 - fix focus problem for stacks with annotation mode is false
    If VGear <> Nil Then
      UpdateMenuState(VGear);
    MagViewerTB1.MagViewer := FCurrentViewer;
    Mag4StackViewer1.UnSelectAll();
    MagViewerTB1.UpdateImageState;
    If SetCineViewerForCurrentImage() Then
      AutoViewCineTool();
    if newViewer then
        ImageSelectedDrawAssociatedScoutLines(FCurrentViewer.GetCurrentImage(),
          2);
  end;
End;

Procedure TfrmRadViewer.Mag4StackViewerPageNextViewerClick(Sender: Tobject);
Var
  Stack: TMag4StackViewer;
  State: TMagImageState;
Begin
  If Not MnuOptionsStackPageTogether.Checked Then Exit;
  Stack := TMag4StackViewer(Sender);
  If (Stack = Mag4StackViewer1) Then
  Begin
    If FViewMode = MagrvStack2 Then
    Begin
      If MnuOptionsStackPageWithSameSettings.Checked Then
      Begin
        // error check if no image in viewer1
        State := Stack.GetCurrentImage.GetState();
        Mag4StackViewer2.SetDefaultState(State);
      End;
      Mag4StackViewer2.PageNextViewer(False);
    End;
  End
  Else
    If (Stack = Mag4StackViewer2) Then
    Begin
      If MnuOptionsStackPageWithSameSettings.Checked Then
      Begin
      // error check if no image in viewer1
        State := Stack.GetCurrentImage.GetState();
        Mag4StackViewer1.SetDefaultState(State);
      End;
      Mag4StackViewer1.PageNextViewer(False);
    End;
End;

Procedure TfrmRadViewer.Mag4StackViewerPagePrevViewerClick(Sender: Tobject);
Var
  Stack: TMag4StackViewer;
  State: TMagImageState;
Begin
  If Not MnuOptionsStackPageTogether.Checked Then Exit;
  Stack := TMag4StackViewer(Sender);
  If (Stack = Mag4StackViewer1) Then
  Begin
    If FViewMode = MagrvStack2 Then
    Begin
      If MnuOptionsStackPageWithSameSettings.Checked Then
      Begin
        // error check if no image in viewer1
        State := Stack.GetCurrentImage.GetState();
        // need to set both since neither will use last image settings
        // don't think we need to set both anymore (one that set is done in stack viewer)
        Mag4StackViewer2.SetDefaultState(State);
//        Mag4StackViewer1.setDefaultWinLev(state.WinValue, state.LevValue);
      End;
      Mag4StackViewer2.PagePrevViewer(False);
    End;
  End
  Else
    If (Stack = Mag4StackViewer2) Then
    Begin
      If MnuOptionsStackPageWithSameSettings.Checked Then
      Begin
      // error check if no image in viewer1
        State := Stack.GetCurrentImage.GetState();
        // need to set both since neither will use last image settings
        // don't think we need to set both anymore (one that set is done in stack viewer)
        Mag4StackViewer1.SetDefaultState(State);
//        Mag4StackViewer1.setDefaultWinLev(state.WinValue, state.LevValue);
      End;
      Mag4StackViewer1.PagePrevViewer(False);
    End;
End;

Procedure TfrmRadViewer.Mag4StackViewerPageLastViewerClick(Sender: Tobject);
Var
  Stack: TMag4StackViewer;
  State: TMagImageState;
Begin
  If Not MnuOptionsStackPageTogether.Checked Then Exit;
  Stack := TMag4StackViewer(Sender);
  If (Stack = Mag4StackViewer1) Then
  Begin
    If FViewMode = MagrvStack2 Then
    Begin
      If MnuOptionsStackPageWithSameSettings.Checked Then
      Begin
        // error check if no image in viewer1
        State := Stack.GetCurrentImage.GetState();
        // need to set both since neither will use last image settings
        // don't think we need to set both anymore (one that set is done in stack viewer)
        Mag4StackViewer2.SetDefaultState(State);
//        Mag4StackViewer1.setDefaultWinLev(state.WinValue, state.LevValue);
      End;
      Mag4StackViewer2.PageLastViewer(False);
    End;
  End
  Else
    If (Stack = Mag4StackViewer2) Then
    Begin
      If MnuOptionsStackPageWithSameSettings.Checked Then
      Begin
      // error check if no image in viewer1
        State := Stack.GetCurrentImage.GetState();
      // need to set both since neither will use last image settings
      // don't think we need to set both anymore (one that set is done in stack viewer)
        Mag4StackViewer1.SetDefaultState(State);
//        Mag4StackViewer1.setDefaultWinLev(state.WinValue, state.LevValue);
      End;
      Mag4StackViewer1.PageLastViewer(False);
    End;
End;

Procedure TfrmRadViewer.Mag4StackViewerPageFirstViewerClick(Sender: Tobject);
Var
  Stack: TMag4StackViewer;
  State: TMagImageState;
Begin
  If Not MnuOptionsStackPageTogether.Checked Then Exit;
  Stack := TMag4StackViewer(Sender);
  If (Stack = Mag4StackViewer1) Then
  Begin
    If FViewMode = MagrvStack2 Then
    Begin
      If MnuOptionsStackPageWithSameSettings.Checked Then
      Begin
        // error check if no image in viewer1
        State := Stack.GetCurrentImage.GetState();
        // need to set both since neither will use last image settings
        // don't think we need to set both anymore (one that set is done in stack viewer)
        Mag4StackViewer2.SetDefaultState(State);
//        Mag4StackViewer1.setDefaultWinLev(state.WinValue, state.LevValue);
      End;
      Mag4StackViewer2.PageFirstViewer(False);
    End;
  End
  Else
    If (Stack = Mag4StackViewer2) Then
    Begin
      If MnuOptionsStackPageWithSameSettings.Checked Then
      Begin
        // error check if no image in viewer1
        State := Stack.GetCurrentImage.GetState();
        // need to set both since neither will use last image settings
        // don't think we need to set both anymore (one that set is done in stack viewer)
        Mag4StackViewer1.SetDefaultState(State);
//        Mag4StackViewer1.setDefaultWinLev(state.WinValue, state.LevValue);
      End;
      Mag4StackViewer1.PageFirstViewer(False);
    End;
End;

Procedure TfrmRadViewer.MnuOptionsStackPageWithSameSettingsClick(
  Sender: Tobject);
Begin
  SetStackPageWithSameSettings(True);
End;

Procedure TfrmRadViewer.SetStackPageWithSameSettings(Value: Boolean);
Begin
  If Value Then
  Begin
    MnuOptionsStackPageWithSameSettings.Checked := True;
    MnuOptionsStackPageWithDifferentSettings.Checked := False;
    MnuOptionsStackPageWithImageSettings.Checked := False;
    Mag4StackViewer1.ApplyGivenWindowSettings := True;
    Mag4StackViewer2.ApplyGivenWindowSettings := True;
  End;
  {else...  no else yet,  may not need it.}
End;

Procedure TfrmRadViewer.MnuOptionsStackPageWithImageSettingsClick(
  Sender: Tobject);
Begin
  SetStackPageWithImageSettings(True);
End;

Procedure TfrmRadViewer.SetStackPageWithImageSettings(Value: Boolean);
Begin
  If Value Then
  Begin
    MnuOptionsStackPageWithImageSettings.Checked := True;
    MnuOptionsStackPageWithSameSettings.Checked := False;
    MnuOptionsStackPageWithDifferentSettings.Checked := False;
  // turn both off
    Mag4StackViewer1.PageSameSettings := False;
    Mag4StackViewer2.PageSameSettings := False;
    Mag4StackViewer1.ApplyGivenWindowSettings := False;
    Mag4StackViewer2.ApplyGivenWindowSettings := False;
  End;
  {else...  not yet, maybe need later}

End;

Procedure TfrmRadViewer.MnuOptionsStackPageWithDifferentSettingsClick(Sender: Tobject);
Begin
  SetStackPageWithDiffernetSettings(True);

  (*
  mnuOptionsStackPageWithDifferentSettings.Checked := true;
  mnuOptionsStackPageWithImageSettings.Checked := false;
  mnuOptionsStackPageWithSameSettings.Checked := false;
  Mag4StackViewer1.PageSameSettings := true;
  Mag4StackViewer2.PageSameSettings := true;
  *)
End;

Procedure TfrmRadViewer.SetStackPageWithDiffernetSettings(Value: Boolean);
Begin
  If Value Then
  Begin
    MnuOptionsStackPageWithDifferentSettings.Checked := True;
    MnuOptionsStackPageWithImageSettings.Checked := False;
    MnuOptionsStackPageWithSameSettings.Checked := False;
    Mag4StackViewer1.PageSameSettings := True;
    Mag4StackViewer2.PageSameSettings := True;
  End;
       {else...  no else yet,  may not need it.}
End;

Procedure TfrmRadViewer.Mag4ViewerImageDoubleClick(Sender: Tobject; MagImage: TMag4VGear);
Begin
  MnuViewSettings1x1Click(Self);
End;

Procedure TfrmRadViewer.StackViewerImageDoubleClick(Sender: Tobject; StackViewer: TMag4StackViewer; MagImage: TMag4VGear);
Begin
  {/ P122 - JK 7/28/2011 /}
  if Mag4StackViewer1.Mag4Vgear1.AnnotationComponent <> nil then
    if Mag4StackViewer1.Mag4Vgear1.AnnotationComponent.IsAnnotationMode then
      Mag4StackViewer1.Mag4Vgear1.AnnotationComponent.Hide;

  if Mag4StackViewer2.Mag4Vgear1.AnnotationComponent <> nil then
    if Mag4StackViewer2.Mag4Vgear1.AnnotationComponent.IsAnnotationMode then
      Mag4StackViewer2.Mag4Vgear1.AnnotationComponent.Hide;

  If Mag4Viewer1.ColumnCount = 3 Then
    MnuViewSettings3x2Click(Self)
  Else
    MnuViewSettings4x3Click(Self)
End;

procedure TfrmRadViewer.mnuTestStudyHolderStatusClick(Sender: TObject);
begin
  showmessage(uMagRadHeaderLoader.GetStudyHolder().GetStatus);
end;

Procedure TfrmRadViewer.FormDestroy(Sender: Tobject);
var
  panWindow : TObject;
Begin
  If (FForDICOMViewer) Then
  Begin
    If (Msglist <> Nil) And (Msglist.Count > 0) And (DebugOn) Then
    Begin
      Msglist.SaveToFile(Application.ExeName + '.txt');
    End;
    GetImageUtility.DeleteFilesAndDirs(AppPath + '\temp');
    {
    JMW P72 2/14/2007
    No longer need to destroy the IG Manager explicitly, each fMag4VGear14
    component checks to see if it is last and then destroys the IG Manager
    as needed
    destroyIGManager();
    }
    FreeAndNil(MagImageManager1);
    DestroyObserverList();

  End;
  FCurrentViewer := Nil;
  //SetLogEvent(nil);  {JK 10/6/2009 - Maggmsgu refactoring}
  FStudy1.StudyList.Free();
  FStudy1.RootImg.Free();
  FStudy2.StudyList.Free();
  FStudy2.RootImg.Free();
  MagViewerTB1.ClearViewersFromToolbar();

//  SaveFormPosition(self);

  If FrmDICOMDir <> Nil Then
  Begin
    FrmDICOMDir.Free();
    FrmDICOMDir := Nil;
  End;
  If FrmDicomTxtfile <> Nil Then
  Begin
    FrmDicomTxtfile.Free();
    FrmDicomTxtfile := Nil;
  End;
  If FCTPresets <> Nil Then
    FreeAndNil(FCTPresets);
  If FStudy1 <> Nil Then
    FreeAndNil(FStudy1);
  If FStudy2 <> Nil Then
    FreeAndNil(FStudy2);
  If Msglist <> Nil Then
    FreeAndNil(Msglist);
  // JMW P72 11/29/2007
  // if the cine view was created, free it and set it to nil
  If FrmCineView <> Nil Then
    FreeAndNil(FrmCineView);

  If FMagAnnotationStyle <> Nil Then FreeAndNil(FMagAnnotationStyle);
  //If FStudy1<>nil Then If FStudy1.RootImg<>nil Then
  //FreeAndNil(FStudy1.RootImg);

  if FPanWindowHolder.PanWindow <> nil then
  begin
    panWindow := GetImplementingObject(FPanWindowHolder.PanWindow);
    panWindow.Free;
    FPanWindowHolder.PanWindow := nil;
  end;
End;

Procedure TfrmRadViewer.MnuViewInfoDICOMHeaderClick(Sender: Tobject);
Begin
  FCurrentViewer.DisplayDICOMHeader();
End;

Procedure TfrmRadViewer.DICOMViewerExceptionHandler(Sender: Tobject; e: Exception);
Begin
  Showmessage('Exception [' + e.Message + '] from [' + Sender.ClassName + ']');
  //LogMsg('s', 'Exception [' + e.Message + '] from [' + sender.ClassName + ']', MAGMSGDebug);
  MagAppMsg('s', 'Exception [' + e.Message + '] from [' + Sender.ClassName + ']', MAGMSGDebug); {JK 10/6/2009 - Maggmsgu refactoring}

End;

Procedure TfrmRadViewer.MagViewerTB1CopyClick(Sender: Tobject;
  Viewer: IMag4Viewer);
Begin
  CopyImage();
End;

Procedure TfrmRadViewer.MagViewerTB1PrintClick(Sender: Tobject;
  Viewer: IMag4Viewer);
Begin
  PrintImage();
End;

Procedure TfrmRadViewer.MnuViewInfotxtFileClick(Sender: Tobject);
Var
  TxtfName: String;
  VGear: TMag4VGear;
Begin
  If FCurrentViewer = Nil Then Exit;
  VGear := FCurrentViewer.GetCurrentImage();
  If VGear = Nil Then Exit;
  TxtfName := ChangeFileExt(VGear.ImageFilename, '.txt');

  If FrmDicomTxtfile = Nil Then
    FrmDicomTxtfile := TfrmDicomTxtfile.Create(Self);
  FrmDicomTxtfile.LoadTxtFile(TxtfName);
End;

Procedure TfrmRadViewer.MnuImageCacheStudyClick(Sender: Tobject);
Var
  CurStudy: TMagStudyDetails;
  ConvertedList: TStrings;
Begin
  CurStudy := GetCurrentStudy();
  If CurStudy = Nil Then Exit;
  Try
    Begin
      ConvertedList := MagImageManager1.ExtractGroupImagesFromImageData(CurStudy.RootImg.FFile, CurStudy.StudyList.Count, CurStudy.StudyList);
      If (ConvertedList = Nil) Or (ConvertedList.Count <= 0) Then Exit;
      MagImageManager1.StartCache(ConvertedList);
    End;
  Except
    On e: Exception Do
    Begin
      //LogMsg('s', 'Exception auto-caching group images. Error=[' + e.message + ']', magmsgError);
      MagAppMsg('s', 'Exception auto-caching group images. Error=[' + e.Message + ']', magmsgError); {JK 10/6/2009 - Maggmsgu refactoring}
    End;
  End;
End;

Function TfrmRadViewer.GetCurrentStudy(): TMagStudyDetails;
Var
  CurViewer: IMag4Viewer;
Begin
  Result := Nil;
  CurViewer := Mag4StackViewer1;
  If CurViewer = FCurrentViewer Then
  Begin
    CurViewer := Nil;
    Result := FStudy1;
    Exit;
  End;
  CurViewer := Mag4StackViewer2;
  If CurViewer = FCurrentViewer Then
  Begin
    CurViewer := Nil;
    Result := FStudy2;
    Exit;
  End;
  CurViewer := Mag4Viewer1;
  If CurViewer = FCurrentViewer Then
  Begin
    CurViewer := Nil;
    Result := FStudy1;
    Exit;
  End;
  CurViewer := Nil;
End;

Procedure TfrmRadViewer.MnuToolsRulerEnabledClick(Sender: Tobject);
Var
  VGear: TMag4VGear;
Begin
  If FCurrentViewer = Nil Then Exit;
  VGear := FCurrentViewer.GetCurrentImage;
  If VGear = Nil Then Exit;
  // JMW 4/15/08 - changed to true, why was false?
  MnuToolsRulerEnabled.Checked := True; //true; //ruler// gek 4/10/08 - I changed this to false.
  MnuToolsRulerPointer.Checked := False;
  MnuToolsProtractorEnabled.Checked := False;
  VGear.Measurements();
End;

Procedure TfrmRadViewer.MnuToolsRulerPointerClick(Sender: Tobject);
Var
  VGear: TMag4VGear;
Begin
  If FCurrentViewer = Nil Then Exit;
  VGear := FCurrentViewer.GetCurrentImage;
  If VGear = Nil Then Exit;
  MnuToolsRulerEnabled.Checked := False;
  MnuToolsProtractorEnabled.Checked := False;
  MnuToolsRulerPointer.Checked := True;
  VGear.AnnotationPointer();

End;

Procedure TfrmRadViewer.MnuToolsRulerDeleteSelectedClick(Sender: Tobject);
Var
  VGear: TMag4VGear;
Begin
  If FCurrentViewer = Nil Then Exit;
  VGear := FCurrentViewer.GetCurrentImage;
  If VGear = Nil Then Exit;
  If VGear.AnnotationComponent = Nil Then Exit;
  VGear.AnnotationComponent.ClearSelectedAnnotations();
End;

Procedure TfrmRadViewer.MnuToolsrulerClearAllClick(Sender: Tobject);
Var
  VGear: TMag4VGear;
Begin
  If FCurrentViewer = Nil Then Exit;
  VGear := FCurrentViewer.GetCurrentImage;
  If VGear = Nil Then Exit;
  If VGear.AnnotationComponent = Nil Then Exit;
  VGear.AnnotationComponent.ClearAllAnnotations();
End;

Procedure TfrmRadViewer.MnuToolsPixelValuesClick(Sender: Tobject);
Begin
  SetOptionsPixelValues(MnuToolsPixelValues.Checked);
End;

Procedure TfrmRadViewer.SetOptionsPixelValues(Value: Boolean);
Begin
  If Not (MnuToolsPixelValues.Checked = Value) Then MnuToolsPixelValues.Checked := Value;
  Mag4Viewer1.SetShowPixelValues(Value);
  Mag4StackViewer1.SetShowPixelValues(Value);
  Mag4StackViewer2.SetShowPixelValues(Value);
End;

Procedure TfrmRadViewer.MnuOptionsImageSettingsDeviceClick(Sender: Tobject);
Begin {= 1 }
  SetOptionsWinLev(1);
End;

Procedure TfrmRadViewer.SetOptionsWinLev(Value: Integer);
Begin { 1 = ImageSettingsDevice
                  2 = ImageSettingsHistogram}
  If ((Value < 1) Or (Value > 2)) Then Value := 2; // want histogram as default
  Case Value Of
    1:
      Begin
        MnuOptionsImageSettingsDevice.Checked := True;
        MnuOptionsImageSettingsHistogram.Checked := False;
        Mag4Viewer1.SetHistogramWindowLevel(MnuOptionsImageSettingsHistogram.Checked);
        Mag4StackViewer1.SetHistogramWindowLevel(MnuOptionsImageSettingsHistogram.Checked);
        Mag4StackViewer2.SetHistogramWindowLevel(MnuOptionsImageSettingsHistogram.Checked);
      End;
    2:
      Begin
        MnuOptionsImageSettingsDevice.Checked := False;
        MnuOptionsImageSettingsHistogram.Checked := True;
        Mag4Viewer1.SetHistogramWindowLevel(MnuOptionsImageSettingsHistogram.Checked);
        Mag4StackViewer1.SetHistogramWindowLevel(MnuOptionsImageSettingsHistogram.Checked);
        Mag4StackViewer2.SetHistogramWindowLevel(MnuOptionsImageSettingsHistogram.Checked);
      End;
  End;
End;

Procedure TfrmRadViewer.MnuOptionsImageSettingsHistogramClick(Sender: Tobject);
Begin { = 2 }
  SetOptionsWinLev(2);
End;

Procedure TfrmRadViewer.Mag4StackViewerImageChanged(Sender: Tobject; MagImage: TMag4VGear);
Begin
  If (Sender Is TMag4StackViewer) Then
    FCurrentViewer := (Sender As TMag4StackViewer);

  SetCineViewerForCurrentImage();
  AutoViewCineTool();

  ImageSelectedDrawAssociatedScoutLines(FCurrentViewer.GetCurrentImage(),
    GetCurrentStackIndex());
End;

Procedure TfrmRadViewer.OpenURL1Click(Sender: Tobject);
Var
  IObj: TImageData;
  Filename: String;
  ImgToShow: Integer;
  t: Tlist;
Begin
  t := Tlist.Create();
  Filename := 'http://i.a.cnn.net/cnn/2006/WORLD/meast/11/14/iran.nuclear/newt1.1440.ahmadinejad.ap.jpg';
  IObj := TImageData.Create();
  IObj.FFile := Filename;
  IObj.Mag0 := Filename;
  IObj.ImgDes := Filename;

  If (FStudy1.StudyList.Count = 0) Then
  Begin
    FStudy1.RootImg := IObj;
    FStudy1.Studydesc := 'Displaying';
  End;
  FStudy1.StudyList.Add(IObj);
  t.Add(IObj);

  ImgToShow := FStudy1.StudyList.Count - 1;
  OpenStudy(FStudy1.RootImg, t, FStudy1.Studydesc, 1, ImgToShow, True);
  SetCineViewerForCurrentImage();
  FreeAndNil(t);
End;

Procedure TfrmRadViewer.MnuOptionsLabelsOnClick(Sender: Tobject);
Var
  DialogResult: Integer;
Begin
  If Not MnuOptionsLabelsOn.Checked Then
  Begin
    DialogResult := Messagedlg('WARNING: The automated Orientation Labels ' +
      'will not be displayed for the rest of the session.' { + #13 +
      'Please refer to the online help for more information about the automated orientation labels.'},
      Mtconfirmation, MbOKCancel, -1);
    If DialogResult <> 1 Then // 1 indicates OK button
    Begin
      MnuOptionsLabelsOn.Checked := True;
      Exit;
    End;
  End;
  SetOptionsOrientationLabels(MnuOptionsLabelsOn.Checked);
End;

Procedure TfrmRadViewer.SetOptionsOrientationLabels(Value: Boolean);
Begin
  MnuOptionsLabelsOn.Checked := Value;
  Mag4Viewer1.SetShowLabels(Value);
  Mag4StackViewer1.SetShowLabels(Value);
  Mag4StackViewer2.SetShowLabels(Value);
End;

Procedure TfrmRadViewer.Mag4StackViewer1ImageZoomScroll(Sender: Tobject; VertScrollPos: Integer; HorizScrollPos: Integer);
Begin
  If Mag4StackViewer2.Visible Then
    Mag4StackViewer2.ApplyImageZoomScroll(Sender, VertScrollPos, HorizScrollPos);
End;

Procedure TfrmRadViewer.Mag4StackViewer2ImageZoomScroll(Sender: Tobject; VertScrollPos: Integer; HorizScrollPos: Integer);
Begin
  Mag4StackViewer1.ApplyImageZoomScroll(Sender, VertScrollPos, HorizScrollPos);
End;

Procedure TfrmRadViewer.ImageWinLevChange(Sender: Tobject; WindowValue: Integer; LevelValue: Integer);
Begin
  If Sender = Mag4StackViewer1 Then
  Begin
    Mag4StackViewer2.WinLevValue(WindowValue, LevelValue);
  End
  Else
  Begin
    Mag4StackViewer1.WinLevValue(WindowValue, LevelValue);
  End;
End;

Procedure TfrmRadViewer.ImageBriConChange(Sender: Tobject; BrightnessValue: Integer; ContrastValue: Integer);
Begin
  If Sender = Mag4StackViewer1 Then
  Begin
    Mag4StackViewer2.BrightnessContrastValue(BrightnessValue, ContrastValue);
  End
  Else
  Begin
    Mag4StackViewer1.BrightnessContrastValue(BrightnessValue, ContrastValue);
  End;
End;

Procedure TfrmRadViewer.ImageGearVersion1Click(Sender: Tobject);
Begin
  Showmessage(GetIGManager().Version);
End;

Procedure TfrmRadViewer.ImageZoomChange(Sender: Tobject; ZoomValue: Integer);
Begin
  If Sender = Mag4StackViewer1 Then
  Begin
    Mag4StackViewer2.ZoomValue(ZoomValue);
  End
  Else
  Begin
    Mag4StackViewer1.ZoomValue(ZoomValue);
  End;
End;

Procedure TfrmRadViewer.ClearViewer();
Begin
  Mag4Viewer1.ClearViewer();
  Mag4StackViewer1.ClearViewer();
  Mag4StackViewer2.ClearViewer();
End;

Procedure TfrmRadViewer.SetUtilsDB(UtilsDb: TMagUtilsDB);
Begin
  Mag4Viewer1.MagUtilsDB := UtilsDb;
  Mag4StackViewer1.MagUtilsDB := UtilsDb;
  Mag4StackViewer2.MagUtilsDB := UtilsDb;
End;

Procedure TfrmRadViewer.ImageToolChange(Sender: Tobject; Tool: TMagImageMouse);
Begin
  If Sender = Mag4StackViewer1 Then
  Begin
    Mag4StackViewer2.SetCurrentTool(Tool);
  End
  Else
  Begin
    Mag4StackViewer1.SetCurrentTool(Tool);
  End;
End;

Procedure TfrmRadViewer.MnuToolsLogClick(Sender: Tobject);
Begin
  If FrmLog <> Nil Then
    FrmLog.Show();
End;

Procedure TfrmRadViewer.MnuImageResetAllClick(Sender: Tobject);
Begin
  If FViewMode = MagrvStack1 Then
  Begin
    Mag4StackViewer1.ResetImages();
  End
  Else
    If FViewMode = MagrvStack2 Then
    Begin
      Mag4StackViewer1.ResetImages();
      Mag4StackViewer2.ResetImages();
    End
    Else
      If (FViewMode = MagrvLayout32) Or (FViewMode = MagrvLayout43) Then
      Begin
        Mag4Viewer1.ResetImages(True);
      End;
  MagViewerTB1.UpdateImageState();
End;

Procedure TfrmRadViewer.MnuToolsProtractorEnabledClick(Sender: Tobject);
Var
  VGear: TMag4VGear;
Begin
  If FCurrentViewer = Nil Then Exit;
  VGear := FCurrentViewer.GetCurrentImage;
  If VGear = Nil Then Exit;
  MnuToolsRulerEnabled.Checked := False;
  MnuToolsRulerPointer.Checked := False;
  MnuToolsProtractorEnabled.Checked := True;
  VGear.Protractor();
End;

Procedure TfrmRadViewer.GetFormUPrefs(VUpref: Tuserpreferences);
Begin
  VUpref.Dicomstyle := 2;
  VUpref.Dicompos.Left := Left;
  VUpref.Dicompos.Top := Top; { top,  left , right, bottom  }
  VUpref.Dicompos.Right := Width;
  VUpref.Dicompos.Bottom := Height;
       {    Get values for new 72 prefs  }
  VUpref.DicomScrollSpeed := Self.Mag4StackViewer1.TbStudySpeed.Position; //int

  If Doesformexist('frmCineView') Then VUpref.DicomCineSpeed := FrmCineView.TrkbrCineSpeed.Position; //int

            {       mnuOptionsStackPageWithDifferentSettings.Checked := true;
                    mnuOptionsStackPageWithImageSettings.Checked := false;
                    mnuOptionsStackPageWithSameSettings.Checked := false;}
  If Self.MnuOptionsStackPageWithDifferentSettings.Checked Then
    VUpref.DicomStackPaging := 1 //int
  Else
    If Self.MnuOptionsStackPageWithImageSettings.Checked Then
      VUpref.DicomStackPaging := 2
    Else
      If Self.MnuOptionsStackPageWithSameSettings.Checked Then
        VUpref.DicomStackPaging := 3
      Else
        VUpref.DicomStackPaging := 1; {<< if nothing is checked}

             {          mnuOptionsLayoutSelectedWindowSettings.Checked := true;
                        mnuOptionsLayoutIndividualImageSettings.Checked := false;}
  If Self.MnuOptionsLayoutSelectedWindowSettings.Checked Then
    VUpref.DicomLayoutSettings := 1 //int
  Else
    VUpref.DicomLayoutSettings := 2;

  VUpref.DicomStackPageTogether := MnuOptionsStackPageTogether.Checked; //bool

            // always show orientation labels
  VUpref.DicomShowOrientationLabels := True; // mnuOptionsLabelsOn.Checked  ; // bool
  VUpref.DicomShowPixelValues := MnuToolsPixelValues.Checked; //bool
           // vUpref.dicomMeasureColor :=   ???  ; //int
           // vUpref.dicomMeasureLineWidth := ???   ; // int
           // vUpref.dicomMeasureUnits :=  ???  ; // string;
           {    ???   use below to get the values ? ?
    DisplayInterface.AnnotationComponent.setAnnotationColor();
    DisplayInterface.AnnotationComponent.getColor;

    DisplayInterface.AnnotationComponent.getAnnotationState.LineWidth;
    DisplayInterface.AnnotationComponent.getAnnotationState.AnnotationColor;
    DisplayInterface.AnnotationComponent.getAnnotationState.  ??? measurment units

           }

  If Self.MnuOptionsImageSettingsDevice.Checked Then
    VUpref.DicomDeviceOptionsWinLev := 1 //int
  Else
    VUpref.DicomDeviceOptionsWinLev := 2;

    // measurement preference options
  VUpref.DicomMeasureColor := ColorToRGB(FMagAnnotationStyle.AnnotationColor);   {This calls ColorToRGB from Graphics Unit}
  VUpref.DicomMeasureLineWidth := FMagAnnotationStyle.LineWidth;
  VUpref.DicomMeasureUnits := Inttostr(FMagAnnotationStyle.MeasurementUnits);

  VUPref.DicomDisplayScoutLines := mnuScoutDisplayScoutLines.Checked;
  VUPref.DicomDisplayScoutWindow := mnuScoutAutoDetectScoutImages.Checked;
  VUPref.DicomScoutLineColor := ColorToRGB(FScoutLineColor);

End;

Procedure TfrmRadViewer.SetFormUPrefs(VUpref: Tuserpreferences);
Var
  AnnotationStyle: TMagAnnotationStyle;
  Wrksarea: TMagScreenArea;
//var   : integer;
Begin
  // JMW 6/25/08 p72t23 - if the window was maximized then don't use the position
  // property of the user preferences (will make size very strange).
  // want to just set back to maximized view
  If Self.WindowState <> WsMaximized Then
    Self.SetBounds(VUpref.Dicompos.Left, VUpref.Dicompos.Top,
      VUpref.Dicompos.Right, VUpref.Dicompos.Bottom);
  // JMW 4/6/09 P93 - add checks to make sure viewer is not placed off of the
  // screen - need to TEST!
  Try
    Wrksarea := GetScreenArea;
    If (Self.Left + Self.Width) > Wrksarea.Right Then Self.Left := Wrksarea.Right - Self.Width;
    If (Self.Top + Self.Height) > Wrksarea.Bottom Then Self.Top := Wrksarea.Bottom - Self.Height;
    If (Self.Top < Wrksarea.Top) Then Self.Top := Wrksarea.Top;
    If (Self.Left < Wrksarea.Left) Then Self.Left := Wrksarea.Left;
  Except
    On e: Exception Do
    Begin
      //logmsg('s', 'Error setting form position, ' + e.Message, magmsgError);
      MagAppMsg('s', 'Error setting form position, ' + e.Message, magmsgError); {JK 10/6/2009 - Maggmsgu refactoring}
    End;
  End;

//self.FormStyle := vUpref.dicomstyle;
//EXIT;
       {    Get values for new 72 prefs  }
  Self.Mag4StackViewer1.TbStudySpeed.Position := VUpref.DicomScrollSpeed;
  Self.Mag4StackViewer2.TbStudySpeed.Position := VUpref.DicomScrollSpeed;

  If Doesformexist('frmCineView') Then FrmCineView.SetFormUPrefs(VUpref);

{            if self.mnuOptionsStackPageWithDifferentSettings.Checked
              then  vUpref.dicomStackPaging := 1        //int
              else if self.mnuOptionsStackPageWithImageSettings.Checked
                   then vUpref.dicomStackPaging := 2
                   else if self.mnuOptionsStackPageWithSameSettings.Checked
                        then vUpref.dicomStackPaging := 3
                        else vUpref.dicomStackPaging := 1; }{<< if nothing is checked}
  Case VUpref.DicomStackPaging Of
    1:
      Begin
        SetStackPageWithDiffernetSettings(True);
      End;
    2:
      Begin
        SetStackPageWithImageSettings(True);
      End;
    3:
      Begin
        SetStackPageWithSameSettings(True);
      End;
  Else
    Begin
      SetStackPageWithDiffernetSettings(True);
    End;
  End;

             {          mnuOptionsLayoutSelectedWindowSettings.Checked := true;
                        mnuOptionsLayoutIndividualImageSettings.Checked := false;}
  SetLayoutSettings(VUpref.DicomLayoutSettings);
  SetOptionsStackPage(VUpref.DicomStackPageTogether);
              //SetOptionsOrientationLabels(vUpref.dicomShowOrientationLabels);
              // setting this here ensures the labels are always displayed and turned on after logging into VistA
              // even after re-logging into a site
  SetOptionsOrientationLabels(True);
  SetOptionsPixelValues(VUpref.DicomShowPixelValues);

           //   ???  :=  vUpref.dicomMeasureColor   ; //int
           //  ???   := vUpref.dicomMeasureLineWidth    ; // int
           // ???  :=  vUpref.dicomMeasureUnits   ; // string;
           {
    DisplayInterface.AnnotationComponent.setAnnotationColor();
    DisplayInterface.AnnotationComponent.getColor;

    DisplayInterface.AnnotationComponent.getAnnotationState.LineWidth;
    DisplayInterface.AnnotationComponent.getAnnotationState.AnnotationColor;
    DisplayInterface.AnnotationComponent.getAnnotationState.  ??? measurment units

           }
  SetOptionsWinLev(VUpref.DicomDeviceOptionsWinLev);

  If VUpref.DicomMeasureColor <= 0 Then
    VUpref.DicomMeasureColor := ColorToRGB(clYellow);    {This calls ColorToRGB from Graphics Unit}
  If VUpref.DicomMeasureLineWidth <= 0 Then
    VUpref.DicomMeasureLineWidth := 2;
  If VUpref.DicomMeasureUnits = '' Then
    VUpref.DicomMeasureUnits := '6'; // default CM

  AnnotationStyle := TMagAnnotationStyle.Create();
  AnnotationStyle.LineWidth := VUpref.DicomMeasureLineWidth;
  AnnotationStyle.MeasurementUnits := Strtoint(VUpref.DicomMeasureUnits);

  AnnotationStyle.AnnotationColor := VUpref.DicomMeasureColor;
  MagAnnotationStyleChangeEvent(Self, AnnotationStyle);

  SetOptionsDisplayScoutLines(vupref.DicomDisplayScoutLines);
  SetOptionsDisplayScoutWindow(vupref.DicomDisplayScoutWindow);
  if VUpref.DicomScoutLineColor <= 0 then
    SetOptionsScoutLineColor(clRed)
  else
    SetOptionsScoutLineColor(VUpref.DicomScoutLineColor);

    (*
      SetOptionsWinLev(value : integer);
          { 1 = ImageSettingsDevice
             2 = ImageSettingsHistogram}

 *)
End;

Procedure TfrmRadViewer.MagAnnotationStyleChangeEvent(Sender: Tobject; AnnotationStyle: TMagAnnotationStyle);
Begin
  FMagAnnotationStyle := AnnotationStyle;
  // send to stack viewers and viewer
  If Sender = Mag4StackViewer1 Then
  Begin
    Mag4StackViewer2.SetAnnotationStyle(FMagAnnotationStyle);
    Mag4Viewer1.SetAnnotationStyle(FMagAnnotationStyle);
  End
  Else
    If Sender = Mag4StackViewer2 Then
    Begin
      Mag4StackViewer1.SetAnnotationStyle(FMagAnnotationStyle);
      Mag4Viewer1.SetAnnotationStyle(FMagAnnotationStyle);
    End
    Else
      If Sender = Mag4Viewer1 Then
      Begin
        Mag4StackViewer1.SetAnnotationStyle(FMagAnnotationStyle);
        Mag4StackViewer2.SetAnnotationStyle(FMagAnnotationStyle);
      End
      Else
      Begin
        Mag4StackViewer1.SetAnnotationStyle(FMagAnnotationStyle);
        Mag4StackViewer2.SetAnnotationStyle(FMagAnnotationStyle);
        Mag4Viewer1.SetAnnotationStyle(FMagAnnotationStyle);
      End;
  // send to stack viewers and viewer
End;

Procedure TfrmRadViewer.MnuToolsRulerMeasurementOptionsClick(
  Sender: Tobject);
Begin
//RCA OUT  FrmAnnotationOptions.OnMagAnnotationStyleChangeEvent := MagAnnotationStyleChangeEvent;
//RCA OUT   FrmAnnotationOptions.ShowAnnotationOptionsDialog(FMagAnnotationStyle);
 //(was out before RCA) MagAnnotationStyleChangeEvent(self, FMagAnnotationStyle);
End;

Procedure TfrmRadViewer.PatientIDMismatchEvent(Sender: Tobject; Mag4VGear: TMag4VGear);
Begin
  If Not FForDICOMViewer Then
    PatientIDMismatchLog(Mag4VGear);
End;

Procedure TfrmRadViewer.MnuHelpRadiologyViewerClick(Sender: Tobject);
Begin
  Application.HelpContext(HelpContext);
End;

procedure TfrmRadViewer.mnuImageAddToScoutWindowClick(Sender: TObject);
var
  study : TMagStudyDetails;
begin
  study := GetCurrentStudy();
  if (FCurrentViewer <> nil) and (study <> nil) then
    AddImageToScoutWindow(FCurrentViewer.GetCurrentImage(), study,
      GetCurrentViewerIndex());
end;

Procedure TfrmRadViewer.PanWindowCloseEvent(Sender: Tobject);
Begin
  MagViewerTB1.DisablePanWindow();
End;

Procedure TfrmRadViewer.ViewerImageChangeEvent(Sender: Tobject);
Begin
  MagViewerTB1.UpdateImageState();
End;

Procedure TfrmRadViewer.MnuViewActivewindowsClick(Sender: Tobject);
Begin
  SwitchToForm();
End;

Procedure TfrmRadViewer.MnuViewGoToMainWindowClick(Sender: Tobject);
Begin
  Application.MainForm.SetFocus();
End;

Procedure TfrmRadViewer.MnuImageApplyToAllClick(Sender: Tobject);
Begin
  // slight flaw in this logic - this calls the toolbar to turn on apply to all
  // then the toolbar calls the event to alert the rad viewer that apply to all
  // has changed, which again sets the checkmark, but this event does not fire
  // again, so its ok - just a bit strange.
  MnuImageApplyToAll.Checked := Not MnuImageApplyToAll.Checked;
  MagViewerTB1.ApplyToAll(MnuImageApplyToAll.Checked);
End;

Procedure TfrmRadViewer.MnuImageBriConContrastUpClick(Sender: Tobject);
Begin
  With MagViewerTB1 Do
  Begin
    If ((sbLev.Position + 5) > sbLev.Max) Then
      sbLev.Position := sbLev.Max
    Else
      sbLev.Position := sbLev.Position + 5;
  End;
End;

Procedure TfrmRadViewer.MnuImageZoomZoomInClick(Sender: Tobject);
Begin
  MagViewerTB1.sbZoom.Position := MagViewerTB1.sbZoom.Position + 20;
  MagViewerTB1.UpdateImageState;
End;

Procedure TfrmRadViewer.MnuImageZoomZoomOutClick(Sender: Tobject);
Begin
  MagViewerTB1.sbZoom.Position := MagViewerTB1.sbZoom.Position - 20;
  MagViewerTB1.UpdateImageState;
End;

Procedure TfrmRadViewer.MnuImageZoomFittoWidthClick(Sender: Tobject);
Begin
  If FCurrentViewer = Nil Then
    Exit;
  FCurrentViewer.FitToWidth;
  MagViewerTB1.UpdateImageState;
End;

Procedure TfrmRadViewer.MnuImageZoomFittoHeightClick(Sender: Tobject);
Begin
  If FCurrentViewer = Nil Then
    Exit;
  FCurrentViewer.FitToHeight;
  MagViewerTB1.UpdateImageState;
End;

Procedure TfrmRadViewer.MnuImageZoomFittoWindowClick(Sender: Tobject);
Begin
  If FCurrentViewer = Nil Then
    Exit;
  FCurrentViewer.FitToWindow;
  MagViewerTB1.UpdateImageState;
End;

Procedure TfrmRadViewer.MnuImageZoomActualSizeClick(Sender: Tobject);
Begin
  If FCurrentViewer = Nil Then
    Exit;
  FCurrentViewer.Fit1to1;
  MagViewerTB1.UpdateImageState;
End;

Procedure TfrmRadViewer.MnuImageMousePanClick(Sender: Tobject);
Begin
  MagViewerTB1.SetCurrentTool(MactPan);
End;

Procedure TfrmRadViewer.MnuImageMouseMagnifyClick(Sender: Tobject);
Begin
  MagViewerTB1.SetCurrentTool(MactMagnify);
End;

Procedure TfrmRadViewer.MnuImageMouseZoomClick(Sender: Tobject);
Begin
  MagViewerTB1.SetCurrentTool(MactZoomRect);
End;

Procedure TfrmRadViewer.MnuImageMouseRulerClick(Sender: Tobject);
Begin
  MagViewerTB1.SetCurrentTool(MactMeasure);
End;

Procedure TfrmRadViewer.MnuImageScrollTopLeftClick(Sender: Tobject);
Begin
  MagViewerTB1.ScrollCornerTL();
End;

Procedure TfrmRadViewer.MnuImageScrollTopRightClick(Sender: Tobject);
Begin
  MagViewerTB1.ScrollCornerTR();
End;

Procedure TfrmRadViewer.MnuImageNextImageClick(Sender: Tobject);
Var
  CurViewer: IMag4Viewer;
Begin
  CurViewer := Mag4Viewer1;
  If CurViewer = FCurrentViewer Then
  Begin
    Mag4Viewer1.PageNextViewer(True);
  End
  Else
  Begin
    FCurrentViewer.PageNextViewer(True);
    CurViewer := Mag4StackViewer1;
    If CurViewer = FCurrentViewer Then
      Mag4StackViewerPageNextViewerClick(Mag4StackViewer1)
    Else
      Mag4StackViewerPageNextViewerClick(Mag4StackViewer2);
  End;
End;

Procedure TfrmRadViewer.MnuImagePreviousImageClick(Sender: Tobject);
Var
  CurViewer: IMag4Viewer;
Begin
  CurViewer := Mag4Viewer1;
  If CurViewer = FCurrentViewer Then
  Begin
    Mag4Viewer1.PagePrevViewer(True);
//    Mag4Viewer1.SelectNextImage(-1);
  End
  Else
  Begin
    FCurrentViewer.PagePrevViewer(True);
    CurViewer := Mag4StackViewer1;
    If CurViewer = FCurrentViewer Then
      Mag4StackViewerPagePrevViewerClick(Mag4StackViewer1)
    Else
      Mag4StackViewerPagePrevViewerClick(Mag4StackViewer2);
  End;
End;

Procedure TfrmRadViewer.MnuImageScrollBottomRightClick(Sender: Tobject);
Begin
  MagViewerTB1.ScrollCornerBR;
End;

Procedure TfrmRadViewer.MnuImageScrollBottomLeftClick(Sender: Tobject);
Begin
  MagViewerTB1.ScrollCornerBL;
End;

Procedure TfrmRadViewer.MnuImageScrollLeftClick(Sender: Tobject);
Begin
  MagViewerTB1.ScrollLeft
End;

Procedure TfrmRadViewer.MnuImageScrollRightClick(Sender: Tobject);
Begin
  MagViewerTB1.ScrollRight;
End;

Procedure TfrmRadViewer.MnuImageScrollUpClick(Sender: Tobject);
Begin
  MagViewerTB1.ScrollUp;
End;

Procedure TfrmRadViewer.MnuImageScrollDownClick(Sender: Tobject);
Begin
  MagViewerTB1.ScrollDown;
End;

Procedure TfrmRadViewer.MnuImageMouseAngleToolClick(Sender: Tobject);
Begin
  MagViewerTB1.SetCurrentTool(MactProtractor);
End;

Procedure TfrmRadViewer.MnuImageMouseRulerAnglePointerClick(
  Sender: Tobject);
Begin
  MagViewerTB1.SetCurrentTool(MactAnnotationPointer);
End;

Procedure TfrmRadViewer.MnuImageMouseAutoWindowLevelClick(Sender: Tobject);
Begin
  MagViewerTB1.SetCurrentTool(MactWinLev);
End;

Procedure TfrmRadViewer.MnuImageWinLevLevelUpClick(Sender: Tobject);
Begin
  With MagViewerTB1 Do
  Begin
    If ((sbLev.Position + 5) > sbLev.Max) Then
      sbLev.Position := sbLev.Max
    Else
      sbLev.Position := sbLev.Position + 5;
  End;
End;

Procedure TfrmRadViewer.MnuImageWinLevWindowUpClick(Sender: Tobject);
Begin
  With MagViewerTB1 Do
  Begin
    If ((sbWin.Position + 5) > sbWin.Max) Then
      sbWin.Position := sbWin.Max
    Else
      sbWin.Position := sbWin.Position + 5;
  End;
End;

Procedure TfrmRadViewer.MnuImageBriConContrastDownClick(Sender: Tobject);
Begin
  With MagViewerTB1 Do
  Begin
    If ((sbLev.Position - 5) < 0) Then
      sbLev.Position := 0
    Else
      sbLev.Position := sbLev.Position - 5;
  End;
End;

Procedure TfrmRadViewer.MnuImageBriConBrightnessDownClick(Sender: Tobject);
Begin
  With MagViewerTB1 Do
  Begin
    If ((sbWin.Position - 15) < sbWin.Min) Then
      sbWin.Position := sbWin.Min
    Else
      sbWin.Position := sbWin.Position - 15;
  End;
End;

Procedure TfrmRadViewer.MnuImageBriConBrightnessUpClick(Sender: Tobject);
Begin
  With MagViewerTB1 Do
  Begin
    If ((sbWin.Position + 15) > sbWin.Max) Then
      sbWin.Position := sbWin.Max
    Else
      sbWin.Position := sbWin.Position + 15;
  End;
End;

Procedure TfrmRadViewer.MnuImageWinLevWindowDownClick(Sender: Tobject);
Begin
  With MagViewerTB1 Do
  Begin
    If ((sbWin.Position - 5) < sbWin.Min) Then
      sbWin.Position := sbWin.Min
    Else
      sbWin.Position := sbWin.Position - 5;
  End;
End;

Procedure TfrmRadViewer.MnuImageWinLevLevelDownClick(Sender: Tobject);
Begin
  With MagViewerTB1 Do
  Begin
    If ((sbLev.Position - 5) < sbLev.Min) Then
      sbLev.Position := sbLev.Min
    Else
      sbLev.Position := sbLev.Position - 5;
  End;
End;

Procedure TfrmRadViewer.MnuViewPanWindowClick(Sender: Tobject);
Begin
  MagViewerTB1.PanWindow();
End;

Procedure TfrmRadViewer.MnuViewStack1Click(Sender: Tobject);
Begin
  // only allow these to function if in the correct mode
  If (FViewMode = MagrvStack1) Or (FViewMode = MagrvStack2) Then
  Begin
    Mag4StackViewer1ClickEvent(Self, Mag4StackViewer1, Nil);
    Mag4StackViewer1.SetSelected();
  End;
End;

Procedure TfrmRadViewer.MnuViewStack2Click(Sender: Tobject);
Begin
  // only allow these to function if in the correct mode
  If (FViewMode = MagrvStack2) Then
  Begin
    Mag4StackViewer2ClickEvent(Self, Mag4StackViewer2, Nil);
    Mag4StackViewer2.SetSelected();
  End;
End;

{/ P122 - JK 7/28/2011 /}
procedure TfrmRadViewer.AnnotateButtonClickEvent(Sender: TObject);
begin
  if frmCineView.Visible then
    if frmCineView.Timer1.Enabled then
      frmCineView.btnStopClick(sender);

  {/p122t10 dmmn 12/6 - make the behavior similar to fullres viewer when user click on annotation
  button for same stack containing a visible annotation toolbar /}
  if TMag4StackViewer(Sender).Mag4Vgear1.AnnotationComponent <> nil then
    if TMag4StackViewer(Sender).Mag4Vgear1.AnnotationComponent.Visible then
    begin
      if TMag4StackViewer(Sender).Mag4Vgear1.CheckIfAnnotsModified then
        begin
          TMag4StackViewer(Sender).Mag4Vgear1.AnnotationComponent.Hide;
          TMag4StackViewer(Sender).Mag4Vgear1.AnnotationComponent.IsANnotationMode := False; //p122 dmmn 8/15/11
          TMag4StackViewer(Sender).CanShowAnnotToolbar := True;   //p122t6 fix cancel 2 stack
        end
        else //p122 dmmn 8/15/11 - if the user decide to cancel and stay on the current stack
        begin
          TMag4StackViewer(Sender).CanShowAnnotToolbar := False; //p122t10 dmmn 12/7
          Exit;
        end;
    end;
  {Close the other stack viewer toolbar}
  if TMag4StackViewer(Sender).Name = 'Mag4StackViewer1' then
    CloseAnnotationToolbar('Mag4StackViewer2')
  else if TMag4StackViewer(Sender).Name = 'Mag4StackViewer2' then
    CloseAnnotationToolbar('Mag4StackViewer1');
end;

{/p122t8 - dmmn 11/11/11/}
procedure TfrmRadViewer.CineViewStartEvent(Sender: TObject; var CanStart: Boolean);
var
  AnnotSaveCancelled : Boolean;
begin
  AnnotSaveCancelled := False;
  if Mag4StackViewer1.Visible then
  begin
    if Mag4StackViewer1.Mag4Vgear1 <> nil then
    begin
      if Mag4StackViewer1.Mag4Vgear1.AnnotationComponent <> nil then
      begin
        if Mag4StackViewer1.Mag4Vgear1.AnnotationComponent.IsAnnotationMode then
        begin
          if Mag4StackViewer1.Mag4Vgear1.CheckIfAnnotsModified then
          begin
            Mag4StackViewer1.Mag4Vgear1.AnnotationComponent.Hide;
            Mag4StackViewer1.Mag4Vgear1.AnnotationComponent.IsANnotationMode := False;
            CanStart := True;
            Exit;
          end
          else
          begin
            CanStart := False;
            Exit;
          end;
        end;
      end;
    end;
  end; //end Mag4StackViewer1.Visible

  if Mag4StackViewer2.Visible then
  begin
    if Mag4StackViewer2.Mag4Vgear1 <> nil then
    begin
      if Mag4StackViewer2.Mag4Vgear1.AnnotationComponent <> nil then
      begin
        if Mag4StackViewer2.Mag4Vgear1.AnnotationComponent.IsAnnotationMode then
        begin
          if Mag4StackViewer2.Mag4Vgear1.CheckIfAnnotsModified then
          begin
            Mag4StackViewer2.Mag4Vgear1.AnnotationComponent.Hide;
            Mag4StackViewer2.Mag4Vgear1.AnnotationComponent.IsANnotationMode := False;
            CanStart := True;
            Exit;
          end
          else
          begin
            CanStart := False;
            Exit;
          end;
        end;
      end;
    end;
  end; //end Mag4StackViewer2.Visible
end;

procedure TfrmRadViewer.CloseAnnotationToolbar(ViewerName: String);
Var
  VGear: TMag4VGear;
  AnnotSaveCancelled : Boolean;
begin
  AnnotSaveCancelled := False;
  if ViewerName = 'Mag4StackViewer1' then
  begin
    if Mag4StackViewer1.Mag4Vgear1.AnnotationComponent <> nil then
    begin
      if Mag4StackViewer1.Mag4Vgear1.AnnotationComponent.IsAnnotationMode then
      begin
        if Mag4StackViewer1.Mag4Vgear1.CheckIfAnnotsModified then
        begin
          Mag4StackViewer1.Mag4Vgear1.AnnotationComponent.Hide;
          Mag4StackViewer1.Mag4Vgear1.AnnotationComponent.IsANnotationMode := False; //p122 dmmn 8/15/11
          Mag4StackViewer2.CanShowAnnotToolbar := True;   //p122t6 fix cancel 2 stack
        end
        else //p122 dmmn 8/15/11 - if the user decide to cancel and stay on the current stack
        begin
//          Exit;
          AnnotSaveCancelled := True;
          Mag4StackViewer2.CanShowAnnotToolbar := false;
        end;
      end
      else
        Mag4StackViewer2.CanShowAnnotToolbar := True;
    end;

    if Not AnnotSaveCancelled then
    begin
      {/p122 dmmn 8/15/11 - attempt to sync the annotation toolbar to the viewer/}
      FCurrentViewer := Mag4StackViewer2;
      VGear := FCurrentViewer.GetCurrentImage;
      If VGear <> Nil Then
        UpdateMenuState(VGear);
      MagViewerTB1.MagViewer := FCurrentViewer;
      If Mag4StackViewer1.Visible Then
        Mag4StackViewer1.UnSelectAll();
      MagViewerTB1.UpdateImageState;
      If SetCineViewerForCurrentImage() Then
        AutoViewCineTool();
    end;
  end
  else if ViewerName = 'Mag4StackViewer2' then
  begin
    if Mag4StackViewer2.Mag4Vgear1.AnnotationComponent <> nil then
    begin
      if Mag4StackViewer2.Mag4Vgear1.AnnotationComponent.IsAnnotationMode then
      begin
        if Mag4StackViewer2.Mag4Vgear1.CheckIfAnnotsModified then
        begin
          Mag4StackViewer2.Mag4Vgear1.AnnotationComponent.Hide;
          Mag4StackViewer2.Mag4Vgear1.AnnotationComponent.IsANnotationMode := False; //p122 dmmn 8/15/11
          Mag4StackViewer1.CanShowAnnotToolbar := True;       //p122t6 fix cancel 2 stack
        end
        else
        begin
//          Exit;
          AnnotSaveCancelled := True;
          Mag4StackViewer1.CanShowAnnotToolbar := false;
        end;
      end
      else
        Mag4StackViewer1.CanShowAnnotToolbar := True;
    end;

    if Not AnnotSaveCancelled then
    begin
      {/p122 dmmn 8/15/11 - attempt to sync the annotation toolbar to the viewer /}
      FCurrentViewer := Mag4StackViewer1;
      VGear := FCurrentViewer.GetCurrentImage;
      If VGear <> Nil Then
        UpdateMenuState(VGear);
      MagViewerTB1.MagViewer := FCurrentViewer;
        If Mag4StackViewer2.Visible Then
      Mag4StackViewer2.UnSelectAll();
      MagViewerTB1.UpdateImageState;
      If SetCineViewerForCurrentImage() Then
        AutoViewCineTool();
    end;
  end;

  if Not AnnotSaveCancelled then
  begin
  if VGear = nil then
    Exit;
  if VGear.AnnotationComponent = nil then
    Exit;
    
  {/p122 dmmn 8/15/11 - reassign artxctl events to current Annotation Component /}
  VGear.AnnotationComponent.IGArtXCtl.OnCreateMarkNotify := VGear.AnnotationComponent.FIGArtXCtlCreateMarkNotify;
  VGear.AnnotationComponent.IGArtXCtl.OnDeleteMarkNotify := VGear.AnnotationComponent.FIGArtXCtlDeleteMarkNotify;
  VGear.AnnotationComponent.IGArtXCtl.OnModifyMarkNotify := VGear.AnnotationComponent.FIGArtXCtlModifyMarkNotify;
  VGear.AnnotationComponent.IGArtXCtl.OnPreCreateMarkNotify := VGear.AnnotationComponent.FIGArtXCtlPreCreateMarkNotify;
  end;
end;

procedure TfrmRadViewer.Annotations1Click(Sender: TObject);
var
  Stack : TMag4StackViewer;
begin
  {/ P122 T15 - JK 7/18/2012 - added this to replace the P117 mouse ruler/protractor/pointing submenu items. /}
  Stack := GetCurrentStack;
  //p122t15 - dmmn 8/13/12 - put a block check to make sure that
  //user can only annotate in stack viewer mode and not layout mode. also using
  //existing function in the stackviewer to launch annotation
  if Stack = nil then
  begin
    MessageDlg('You can only annotate in stack view.', mtInformation, [mbOK], 0);
  end
  else
  begin
    //Stack.Mag4Vgear1.btnAnnotationsClick(Self);
    Stack.btnAnnotationsClick(Sender);
  end;
end;

Procedure TfrmRadViewer.ApplyToAllChangeEvent(Sender: Tobject;
  ApplyToAll: Boolean);
Begin
  MnuImageApplyToAll.Checked := ApplyToAll;
End;

Procedure TfrmRadViewer.MnuImageFirstImageClick(Sender: Tobject);
Var
  CurViewer: IMag4Viewer;
Begin
  CurViewer := Mag4Viewer1;
  If CurViewer = FCurrentViewer Then
  Begin
    Mag4Viewer1.PageFirstViewer(True);
  End
  Else
  Begin
    FCurrentViewer.PageFirstViewer(True);
    CurViewer := Mag4StackViewer1;
    If CurViewer = FCurrentViewer Then
      Mag4StackViewerPageFirstViewerClick(Mag4StackViewer1)
    Else
      Mag4StackViewerPageFirstViewerClick(Mag4StackViewer2);
  End;
End;

Procedure TfrmRadViewer.MnuImageLastImageClick(Sender: Tobject);
Var
  CurViewer: IMag4Viewer;
Begin
  CurViewer := Mag4Viewer1;
  If CurViewer = FCurrentViewer Then
  Begin
    Mag4Viewer1.PageLastViewer(True);
  End
  Else
  Begin
    FCurrentViewer.PageLastViewer(True);
    CurViewer := Mag4StackViewer1;
    If CurViewer = FCurrentViewer Then
      Mag4StackViewerPageLastViewerClick(Mag4StackViewer1)
    Else
      Mag4StackViewerPageLastViewerClick(Mag4StackViewer2);
  End;
End;

Procedure TfrmRadViewer.MnuImageStackCineStartClick(Sender: Tobject);
Var
  CurStack: TMag4StackViewer;
Begin
  CurStack := GetCurrentStack();
  If CurStack <> Nil Then
    CurStack.StartStackCine();
End;

Procedure TfrmRadViewer.MnuImageStackCineStopClick(Sender: Tobject);
Var
  CurStack: TMag4StackViewer;
Begin
  CurStack := GetCurrentStack();
  If CurStack <> Nil Then
    CurStack.StopStackCine();
End;

Procedure TfrmRadViewer.MnuImageStackCineSpeedUpClick(Sender: Tobject);
Var
  CurStack: TMag4StackViewer;
Begin
  CurStack := GetCurrentStack();
  If CurStack <> Nil Then
    CurStack.SpeedUpStackCine();
End;

Procedure TfrmRadViewer.MnuImageStackCineSlowDownClick(Sender: Tobject);
Var
  CurStack: TMag4StackViewer;
Begin
  CurStack := GetCurrentStack();
  If CurStack <> Nil Then
    CurStack.SlowDownStackCine();
End;

{If one of the two stacks is the current viewer,return the stack, otherwise
  return nil}

Function TfrmRadViewer.GetCurrentStack(): TMag4StackViewer;
Var
  CurViewer: IMag4Viewer;
Begin
  Result := Nil;
  CurViewer := Mag4StackViewer1;
  If CurViewer = FCurrentViewer Then // stack 1
  Begin
    Result := Mag4StackViewer1;
    Exit;
  End;
  CurViewer := Mag4StackViewer2;
  If CurViewer = FCurrentViewer Then // stack 1
  Begin
    Result := Mag4StackViewer2;
    Exit;
  End;
End;

Function TfrmRadViewer.GetCurrentStackIndex(): integer;
Var
  CurViewer: IMag4Viewer;
Begin
  Result := 1;
  CurViewer := Mag4StackViewer1;
  If CurViewer = FCurrentViewer Then // stack 1
  Begin
    Result := 1;
    curViewer := nil;
    Exit;
  End;
  CurViewer := Mag4StackViewer2;
  If CurViewer = FCurrentViewer Then // stack 1
  Begin
    Result := 2;
    curViewer := nil;
    Exit;
  End;
  curViewer := nil;
End;

{Maximize the currently selected image (if layout or stack1 view - not stack2)}

Procedure TfrmRadViewer.MnuImageMaximizeImageClick(Sender: Tobject);
Var
  CurStack: TMag4StackViewer;
Begin
  CurStack := GetCurrentStack();
  If CurStack = Nil Then
  Begin
    // layout view
    Mag4ViewerImageDoubleClick(Self, Nil);
  End
  Else
    If CurStack = Mag4StackViewer1 Then
    Begin
      StackViewerImageDoubleClick(Self, Nil, Nil);
    End;
  // do nothing if stack 2 is selected
End;

{Display the properties of the currently selected annotations}

Procedure TfrmRadViewer.MnuToolsRulerMeasurementPropertiesClick(
  Sender: Tobject);
Var
  VGear: TMag4VGear;
Begin
  VGear := FCurrentViewer.GetCurrentImage;
  If VGear <> Nil Then
  Begin
    // I don't think the annotation component will ever be nil, but just to
    // be sure...
    If VGear.AnnotationComponent <> Nil Then
      VGear.AnnotationComponent.DisplayCurrentMarkProperties();
  End;
End;

{Set the focus to the cine control}

Procedure TfrmRadViewer.CineToolFocus1Click(Sender: Tobject);
Begin
  If FrmCineView <> Nil Then
  Begin
    // if the user closed the cine tool, don't set focus to it!
    If FrmCineView.Visible Then
      FrmCineView.SetFocus();
  End;
End;

{Event comes from the cine control when switching focus back to the main Rad
Viewer}

Procedure TfrmRadViewer.CineSetParentFocusEvent(Sender: Tobject);
Begin
  Self.SetFocus();
End;

Procedure TfrmRadViewer.MnuImageStackCineRangeStartClick(Sender: Tobject);
Var
  CurStack: TMag4StackViewer;
Begin
  CurStack := GetCurrentStack();
  If CurStack <> Nil Then
    CurStack.SetStackCineStartPosition();
End;

Procedure TfrmRadViewer.MnuImageStackCineRangeEndClick(Sender: Tobject);
Var
  CurStack: TMag4StackViewer;
Begin
  CurStack := GetCurrentStack();
  If CurStack <> Nil Then
    CurStack.SetStackCineStopPosition();
End;

Procedure TfrmRadViewer.MnuImageStackCineRangeClearClick(Sender: Tobject);
Var
  CurStack: TMag4StackViewer;
Begin
  CurStack := GetCurrentStack();
  If CurStack <> Nil Then
    CurStack.ClearStackCinePosition();
End;

Procedure TfrmRadViewer.SetMouseZoomShape(Shape: TMagMouseZoomShape);
Begin
  Mag4StackViewer1.SetMouseZoomShape(shape);
  Mag4StackViewer2.SetMouseZoomShape(shape);
  Mag4Viewer1.SetMouseZoomShape(shape);
  If shape = MagMouseZoomShapeCircle Then
  Begin
    mnuOptionsMouseMagnifyShapeCircle.Checked := True;
    mnuOptionsMouseMagnifyShapeRectangle.Checked := False;
  End
  Else
  Begin
    mnuOptionsMouseMagnifyShapeCircle.Checked := False;
    mnuOptionsMouseMagnifyShapeRectangle.Checked := True;
  End;
End;

Procedure TfrmRadViewer.mnuOptionsMouseMagnifyShapeCircleClick(
  Sender: Tobject);
Begin
  SetMouseZoomShape(MagMouseZoomShapeCircle);
End;

Procedure TfrmRadViewer.mnuOptionsMouseMagnifyShapeRectangleClick(
  Sender: Tobject);
Begin
  SetMouseZoomShape(MagMouseZoomShapeRectangle);
End;

Procedure TfrmRadViewer.TimerScreenShotTimer(Sender: Tobject);
Var
  FormImage: TBitmap;
Begin
  TimerScreenShot.Enabled := False;
  FormImage := GetFormImage;
  Try
    FormImage.SaveToFile(ScreenShotDir + ScreenShotName);
  Finally
    FormImage.Free;
  End;
  Close;
End;

Procedure TfrmRadViewer.FormShow(Sender: Tobject);
Begin
  If ScreenShotDir <> '' Then
  Begin
    If Directoryexists(ScreenShotDir) Then
    Begin
      If Copy(ScreenShotDir, Length(ScreenShotDir), 1) <> '\' Then ScreenShotDir := ScreenShotDir + '\';
      If ScreenShotName <> '' Then
      Begin
        WindowState := WsMaximized;
        TimerScreenShot.Enabled := True;
      End;
    End;
  End;
End;

procedure TfrmRadViewer.DisplayScoutWindow(RootImg : TImageData;
  ViewerNumber : integer; RadiologyStudy : TMagRadiologyStudy = nil);
var
  scoutWindow : TfrmScoutViewer;
begin
  if ViewerNumber = 2 then
  begin
    if FScoutWindow2 = nil then
    begin
      FScoutWindow2 := CreateScoutWindow();
    end;
    scoutWindow := FScoutWindow2
  end
  else
  begin
    if FScoutWindow1 = nil then
    begin
      FScoutWindow1 := CreateScoutWindow();
    end;
    scoutWindow := FScoutWindow1;
  end;

  if RadiologyStudy = nil then
  begin
    radiologyStudy := uMagRadHeaderLoader.GetStudyHolder().getStudy(RootImg);
  end;

  FindAndDisplayScoutImages(radiologyStudy, scoutWindow);
end;

procedure TfrmRadViewer.FindAndDisplayScoutImages(radiologyStudy : TMagRadiologyStudy;
  ScoutWindow : TfrmScoutViewer; ImageToAddAsScout : TImageData = nil);
var
  i : integer;
  img : TMagRadiologyImage;
//  imgType : String;
  LocalizerImages : TList;
  radiologyImages : TList;
begin
  radiologyImages := radiologyStudy.Images;
  LocalizerImages := TList.Create;

  if ImageToAddAsScout = nil then
  begin
    // if ImageToAddAsScout is nil then find the scout images in the study
    for i := 0 to radiologyImages.Count - 1 do
    begin
      img := radiologyImages[i];
      if img.DicomData.IsImageTypeLocalizer then

//      imgType := img.DicomData.ToDelimitedString(img.DicomData.ImageType, '\');
//      if pos('LOCALIZER', imgType) > 0 then
      begin
        // found the scout image, although there really could be more than one
        LocalizerImages.Add(img.Img);
      end;
    end;
  end
  else
  begin
    // scout image was specified, use that one
    LocalizerImages.Add(ImageToAddAsScout);
  end;

  if LocalizerImages.Count > 0 then  
    ScoutWindow.DisplayScoutImages(FCurrentPatient, radiologyStudy.RootImg, 
      LocalizerImages); 
end;

{ When a scout image is clicked this event occurs. Find the nearest image and display that image}
Procedure TfrmRadViewer.ScoutImageMouseUp(Sender: Tobject; Button: TMouseButton;
      Shift: TShiftState; x, y: Integer; RootImg : TImageData;
      ScoutImage : TImageData);
var
  study : TMagRadiologyStudy;
  i : integer;
  curImg, RadScoutImage, nearestImage : TMagRadiologyImage;
  scoutWindow : TfrmScoutViewer;
  vGear : TMag4VGear;
begin
  RadScoutImage := nil;
  study := uMagRadHeaderLoader.GetStudyHolder().getStudy(RootImg);

  { JMW 5/22/2013 P131 - user feedback indicated we should only find the nearest
   image in the currently selected series, not the entire study. Find the image
   for the scout image in the Rad Viewer, then provide the series number and
   series UID to find only images in that series when searching
   }

  vGear := nil;
  scoutWindow := TfrmScoutViewer(Sender);
  If (scoutWindow = FScoutWindow1) Then
  begin
    If (FViewMode = MagrvStack1) or (FViewMode = MagrvStack2) Then
    begin
      vGear := Mag4StackViewer1.GetCurrentImage();
    end
    else
    begin
      vGear := Mag4Viewer1.GetCurrentImage();
    end;
  end
  else
  begin
    If (FViewMode = MagrvStack2) Then
    begin
      vGear := Mag4StackViewer2.GetCurrentImage();
    end;
  end;

  //vGear.PI_ptrData.DicomSequenceNumber;
  //vGear.Dicomdata.Seriesno


  RadScoutImage := study.FindRadiologyImage(ScoutImage);
  if RadScoutImage <> nil then
  begin
    nearestImage := uMagRadHeaderLoader.FindNearestImage(RadScoutImage, study,
      x, y, vGear.Dicomdata.Seriesno, vGear.PI_ptrData.DicomSequenceNumber);
    if nearestImage <> nil then
    begin

      // if the scout window is scout 1, then show in stack1 or viewer1
      // if the scout window is scout 2, then show in stack 2
      scoutWindow := TfrmScoutViewer(Sender);
      If (scoutWindow = FScoutWindow1) Then
      begin
        // scout window 1 sent the selected image, need to find the right viewer
         If (FViewMode = MagrvStack1) or (FViewMode = MagrvStack2) Then
         begin
           // draw in stack 1 window
           Mag4StackViewer1.SetDisplayedImage(nearestImage.Index, true);
         end
         else
         begin
           Mag4Viewer1.SetDisplayedImage(nearestImage.Index, true);
         end;
      end
      else
      begin
        // the scout window 2 was selected, make sure the viewer is visible
        // if not visible then the scout window is open without a linked viewer
        If (FViewMode = MagrvStack2) Then
        begin
          Mag4StackViewer2.SetDisplayedImage(nearestImage.Index, true);
        end;
      end;
      // not necessarily current viewer, need to be viewer associated with the scout window
      {DONE: need to use the viewer appropriate to the scout window that the message came from, do NOT use FCurrentViewer! }
//      FCurrentViewer.SetDisplayedImage(nearestImage.Index, true);
      // select that image
    end;
  end;
end;

{ When an image is changed, this method is called to draw the scout line associated with this image
}
procedure TfrmRadViewer.ImageSelectedDrawAssociatedScoutLines(vGear : TMag4VGear;
  ViewerNumber : integer = 1);
var
  scoutWindow : TfrmScoutViewer;
  selectedImage, rootImg : TImageData;
begin
  selectedImage := nil;
  { DONE -oJMW -cP131 : Check here to be sure scout lines should be drawn (are enabled) }
  if (mnuScoutDisplayScoutLines.Checked) and
    (IsProcedureForScoutLines(vGear.Dicomdata.Modality, vGear.PI_ptrData.PlaceIEN)) then//   (vGear.Dicomdata.Modality = 'CT')
//    or (vGear.Dicomdata.Modality = 'MR')) then
  begin
    vGear.HideScoutLine(); // not sure if this is the best place for this but it should work everywhere
    // find the scout window to draw the line on
    if viewerNumber = 2 then
      scoutWindow := FScoutWindow2
    else
      scoutWindow := FScoutWindow1;

    // if the scout window is not nil and is visible
    if (scoutWindow <> nil) and (scoutWindow.Visible) then
    begin
      // call the event to draw the line on the scout window image
      selectedImage := vGear.PI_ptrData;
      scoutWindow.SelectedImageChanged(selectedImage);
    end;

    // now look for other open images to draw the line
    { DONE -oJMW -cP131 : if two stacks are currently open then need to examine the other stack to see if it relates and draw scout lines there too }
    If FViewMode = MagrvStack2 Then
    begin
      selectedImage := vGear.PI_ptrData;
      // look at the other stack and try to draw there as well (if appropriate)
      if ViewerNumber = 1 then
      begin
        // draw in viewer 2
        Mag4StackViewer2.DrawScoutLineFromSelectedImage(selectedImage, FStudy1.RootImg);
      end
      else
      begin
        Mag4StackViewer1.DrawScoutLineFromSelectedImage(selectedImage, FStudy2.RootImg);
      end;
    end
    else if (FViewMode = MagrvLayout32) or (FViewMode = MagrvLayout43) then
    begin
      // an image was selected in the layout viewer, need to see if a scout line needs to be drawn on other associated images
      Mag4Viewer1.DrawScoutLineFromSelectedImage(FStudy1.RootImg); // only study1 in viewer
    end;         
  end
  else
  begin
    // scout lines are disabled either entireley or for this image, make sure no scout line is drawn
    if viewerNumber = 2 then
      scoutWindow := FScoutWindow2
    else
      scoutWindow := FScoutWindow1;

    // if the scout window is not nil and is visible
    if (scoutWindow <> nil) and (scoutWindow.Visible) then
    begin
      // call the scout window to clear the scout line
      scoutWindow.HideScoutLine();
    end;
  end;               

  selectedImage := nil;
  scoutWindow := nil;
end;

{This event fires when the selected image in the layout viewer changes}
procedure TfrmRadViewer.Mag4Viewer1ImageChangedEvent(Sender : TObject; MagImage: TMag4VGear);
begin
  // layout viewer is always viewer 1
  ImageSelectedDrawAssociatedScoutLines(MagImage, 1);
end;

{ Create a new scout window instance and initialize it properly }
function TfrmRadViewer.CreateScoutWindow() : TfrmScoutViewer;
begin
  result := TfrmScoutViewer.Create(self, FForDICOMViewer);
  result.OnScoutImageMouseUp := ScoutImageMouseUp;
  result.SetUtilsDB(Mag4StackViewer1.MagUtilsDB);
  result.SetCTPresets(FCTPresets);
  result.SetScoutLineColor(FScoutLineColor);
  result.OnScoutColorChange := ScoutColorChangeEvent;
  result.OnScoutViewerImageChange := ScoutViewerImageChange;
  result.ShowTestMenu(mnuTest.Visible);
end;

Procedure TfrmRadViewer.SetOptionsDisplayScoutLines(Value: Boolean);
begin
  If Not (mnuScoutDisplayScoutLines.Checked = Value) Then
  begin
    mnuScoutDisplayScoutLines.Checked := Value;
  end;
  // if scout lines are not checked, disable other scout related options
  mnuScoutAutoDetectScoutImages.Enabled := value;
  mnuScoutShowScoutWindow.Enabled := value;
  mnuScoutColor.Enabled := value;
  mnuScoutAddImagetoScoutWindow.Enabled := value;
end;

Procedure TfrmRadViewer.SetOptionsDisplayScoutWindow(Value: Boolean);
begin
  If Not (mnuScoutAutoDetectScoutImages.Checked = Value) Then
    mnuScoutAutoDetectScoutImages.Checked := Value;
end;

{ Ensures the study is loaded into the LUT, does nothing if already loaded }
function TfrmRadViewer.ScoutLoadStudy(RootImg: TImageData; ImgList: Tlist) : TMagRadiologyStudy;
var
  RootImgProcedure : String;
  frmRadHeaderProgress : TfrmRadHeaderProgress;
begin
  result := nil;
  uMagRadHeaderLoader.Initialize(); // just in case
  RootImgProcedure := RootImg.Proc;
  if IsProcedureForScoutLines(RootImgProcedure, RootImg.PlaceIEN) then
//  if (Pos('CT', RootImgProcedure) > 0) or (Pos('MR', RootImgProcedure) > 0) then
  begin
    result := uMagRadHeaderLoader.GetStudyHolder().getStudy(RootImg);
    if result = nil then
    begin
      // not loaded, need to load
      frmRadHeaderProgress := TfrmRadHeaderProgress.Create(self);
      frmRadHeaderProgress.OnImageHeaderLoadingCancelClick := UserCancelledHeaderLoading;
      result := uMagRadHeaderLoader.LoadStudyImages(RootImg, imgList,
        frmRadHeaderProgress.ReceiveImageHeaderLoadedEvent);
      FreeAndNil(frmRadHeaderProgress);
      if result <> nil then
        uMagRadHeaderLoader.GetStudyHolder().AddUniqueStudy(result);
    end;
  end;
end;

{ Event occurs when a user cancells loading the scout lines }
procedure TfrmRadViewer.UserCancelledHeaderLoading(Sender : TObject);
begin
  uMagRadHeaderLoader.CancelHeaderLoading();
end;

{ Returns a list of the currently displayed studies }
function TfrmRadViewer.GetCurrentlyDisplayedStudies() : TList;
begin
  result := TList.Create;
  result.Add(FStudy1); // study1 is always visible
  if FViewMode = MagrvStack2 then
  begin
    // only if 2 stacks are open is study2 used
    if FStudy2.RootImg <> nil then
      result.Add(FStudy2);
  end;
end;

{ Clear all scout lines from the currently displayed viewers }
procedure TfrmRadViewer.ClearAllScoutLines();
begin
  // not quite sure if this should only do displayed viewers or all viewers
  // all displayed should be ok since when displayed again the data is refreshed (I think)

  CloseScoutWindow(1);
  CloseScoutWindow(2);

  if FViewMode = MagrvStack1 then
  begin
    Mag4StackViewer1.HideScoutLines();
  end
  else if FViewMode = MagrvStack2 then
  begin
    Mag4StackViewer1.HideScoutLines();
    Mag4StackViewer2.HideScoutLines();
  end
  else
  begin
    Mag4Viewer1.HideScoutLines();
  end;
end;

function TfrmRadViewer.IsProcedureForScoutLines(StudyProcedure : String;
  SiteNumber : String) : boolean;
begin
  result := false;                                 
  { scout lines are disabled for site 200 - the DoD}
  //if SiteNumber = '200' then
  //  exit;
  {TODO: remove site number from this method since DoD images now supported}


  if (Pos('CT', StudyProcedure) > 0) or (Pos('MR', StudyProcedure) > 0) then
    result := true;
end;

procedure TfrmRadViewer.AddImageToScoutWindow(vGear : TMag4VGear; Study : TMagStudyDetails;
  ViewerNumber : integer);
var
  scoutWindow : TfrmScoutViewer;
  addToExisting : boolean;
  radiologyStudy : TMagRadiologyStudy;
begin
  if (vGear = nil) or (vGear.PI_ptrData = nil) then
    exit;
  addToExisting := true;
  if ViewerNumber = 2 then
  begin
    if FScoutWindow2 = nil then
    begin
      FScoutWindow2 := CreateScoutWindow();
      addToExisting := false;
    end;
    scoutWindow := FScoutWindow2
  end
  else
  begin
    if FScoutWindow1 = nil then
    begin
      FScoutWindow1 := CreateScoutWindow();
      addToExisting := false;
    end;
    scoutWindow := FScoutWindow1;
  end;

  // calling this ensures the study is loaded into the LUT
  radiologyStudy := ScoutLoadStudy(Study.RootImg, Study.StudyList);
  if radiologyStudy = nil then
  begin
    MagAppMsg('', 'Did not load study [' + Study.RootImg.Mag0 + '] into LUT, cannot add to scout window.', MAGMSGDebug);
    exit;
  end;
//  radiologyStudy := uMagRadHeaderLoader.GetStudyHolder().getStudy(RootImg);
  if (addToExisting) and (scoutWindow.IsStudyLoaded) then
  begin
    // scout window is already open, add image to the scout window
    scoutWindow.AddImageToScoutWindow(vGear.PI_ptrData);
  end
  else
  begin
    // scout window was not open, open a new one and set this image as the scout
    FindAndDisplayScoutImages(radiologyStudy, scoutWindow, vGear.PI_ptrData);
  end;
end;

{ Returns the index (viewer number) for the current viewer}
function TfrmRadViewer.GetCurrentViewerIndex() : integer;
Var
  CurViewer: IMag4Viewer;
Begin
  Result := 1;
  CurViewer := Mag4StackViewer2;
  If CurViewer = FCurrentViewer Then
  Begin
    CurViewer := Nil;
    Result := 2;
    Exit;
  End;
  CurViewer := Nil;
end;

procedure TfrmRadViewer.SetOptionsScoutLineColor(Color : TColor);
begin
  FScoutLineColor := Color;
  Mag4Viewer1.SetScoutLineColor(Color);
  Mag4StackViewer1.SetScoutLineColor(Color);
  Mag4StackViewer2.SetScoutLineColor(Color);

  mnuScoutColorRed.Checked := false;
  mnuScoutColorBlue.Checked := false;
  mnuScoutColorGreen.Checked := false;
  mnuScoutColorYellow.Checked := false;

  case color of
    clRed : mnuScoutColorRed.Checked := true;
    clBlue : mnuScoutColorBlue.Checked := true;
    clGreen : mnuScoutColorGreen.Checked := true;
    clYellow : mnuScoutColorYellow.Checked := true;  
  end;                      

  if FScoutWindow1 <> nil then
  begin
    FScoutWindow1.SetScoutLineColor(color);
  end;
  if FScoutWindow2 <> nil then
  begin
    FScoutWindow2.SetScoutLineColor(color);
  end;
end;

procedure TfrmRadViewer.ScoutColorChangeEvent(Sender : TObject; Color : TColor);
begin
  SetOptionsScoutLineColor(Color);
end;

procedure TfrmRadViewer.CloseScoutWindow(WindowNumber : integer);
begin
  if WindowNumber = 1 then
  begin
    if FScoutWindow1 <> nil then
    begin
      FScoutWindow1.Close;
      FreeAndNil(FScoutWindow1);
    end;
  end;

  if WindowNumber = 2 then
  begin
    if FScoutWindow2 <> nil then
    begin
      FScoutWindow2.Close;
      FreeAndNil(FScoutWindow2);
    end;
  end;
end;

{ Occurs when the scout viewer changes its image, need to send to the scout
  viewer the current image again so it can show the scout line for the current
  rad viewer image}
procedure TfrmRadViewer.ScoutViewerImageChange(Sender : TObject);
var
  scoutWindow : TfrmScoutViewer;
  vGear : TMag4VGear;
  viewerNumber : integer;
begin
  // get right current image (from stack1 or stack2) and apply that image to the
  // scout window (sender)

  vGear := nil;
  scoutWindow := TfrmScoutViewer(Sender);
  If (scoutWindow = FScoutWindow1) Then
  begin
    viewerNumber := 1;
    If (FViewMode = MagrvStack1) or (FViewMode = MagrvStack2) Then
    begin
      vGear := Mag4StackViewer1.GetCurrentImage();
    end
    else
    begin
      vGear := Mag4Viewer1.GetCurrentImage();
    end;
  end
  else
  begin
    viewerNumber := 2;
    If (FViewMode = MagrvStack2) Then
    begin
      vGear := Mag4StackViewer2.GetCurrentImage();
    end;
  end;

  ImageSelectedDrawAssociatedScoutLines(vGear, viewerNumber);
end;

End.
