Unit fMagAnnot;

{
Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created:
Site Name: Silver Spring, OIFO
Developers: Jerry Kashtan, Duc Nguyen
[==   unit fMagAnnot;

Description: Annotation component for the image gear control.

     This unit provides annotation service to Clinical Display.  It provides
     the annotation tool bar and connects to a cMag4VGear as an AnnotationComponent.

     Annotations are provided by Accusoft ImageGear 16.2.11

     Originally written for Patch MAG3_0P122, May through August 2011

      ==]
Note:
  8/26 dmmn : see end of file for DICOM converstions documentation for ArtXRuler
  4/26/12 dmmn : As the result of meeting with HIMS and CLIN3, it's decided that:
  - Annotation features will be disable out of the box at system level
  - Users will not be able to edit saved annotations even their own unless they have
  the MAG ANNOTATE MGR key:
      - Delete: user can only delete their own unsaved annotations
      - Edit: user can only edit their own unsaved annotation
      - Ruler Calibration: will only affect unsaved rulers
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

Interface

Uses
  Windows,
  ActnList,
  Buttons,                                       
  Classes,
  Controls,
  Dialogs,
  ExtCtrls,
  fMagAnnotationOptionsX, //p122 dmmn 7/9/11
  Forms,
  GearArtXGUILib_TLB,
  GearArtXLib_TLB,
  GearCORELib_TLB,
  GearDIALOGSLib_TLB,
  GearDISPLAYLib_TLB,
  GearFORMATSLib_TLB,
  GearPROCESSINGLib_TLB,
  GearVIEWLib_TLB,
  Graphics,
  IGGUIDlgLib_TLB,
  ImgList,
  Menus,
  Messages,
  OleCtrls,
  Stdctrls,
  SysUtils,
  UMagClassesAnnot,
  Variants, ComCtrls, contnrs,
  uMagDefinitions,
  uMagClasses,
  cMagAnnotXMLControlsDisplay,
  XMLDoc,
  XMLIntf,
  xmldom,
  uMagUtils8,
  fMagAnnotationMarkProperty, {/P122 dmmn 7/11/11 - new property box for annotation marks /}
  imaginterfaces,
  ToolWin,
  CheckLst,
    ImagDMinterface, // DmSingle,, {/ P122 - JK 5/12/2011 /}
  uMagAnnotDisplayRAD, {/p122 dmmn 8/2/11 - utils to convert and display rad annotation /}
  GIFImg,
  StrUtils,  {/p122t2 dmmn 8/31 - string compare /}
  Math
  ;

{$DEFINE HIDENEXTGEN}

const
  ACurrentAnnotationSession = 'Current Annotation Session';
  AAsLastViewed             = 'As Last Viewed';
  ANoAnnotsSaved            = 'There are no saved annotations';

type
  {/p122t3 - dmmn 9/22/11 /}
  TRADinfo = Record
    iIEN : string;
    radAnnotCount : integer;
    radIGmapped : integer;
    radOutside : Boolean;
  end;
  
  {/ P122 - JK 6/27/2011 /}
  TAnnotWindowCloseAction = (awCloseSave, awCloseAbandon, awCancel);

  {/ P122 - JK 5/27/2011 /}
  TArtPageObject = class(TObject)
  private
    FArtPage: IIGArtXPage;
    FArtPageID: String;

    {/p122t3 dmmn 9/13 - fix save rotated artpages /}
    FFlipVer : Boolean;
    FFLipHor : Boolean;
    FRotateRight : integer;
    FRotateLeft : integer;
    FImgRight : integer;
    FImgBottom : integer;
 //RCA not used   FDevRight : integer;
 //RCA not used   FDevBottom : integer;

    FAnnotDeleted : boolean; //p122t7


  public
    {/p122t3 /}
    constructor Create;
    procedure FlipVer;
    procedure FlipHor;
    procedure RotateRight;
    procedure RotateLeft;
    procedure UpdateRects(ImgRight, ImgBottom: Integer);

    property FlippedVer : Boolean read FFlipVer;
    property FlippedHor : Boolean read FFlipHor;
    property RotatedRight : integer read FRotateRight;
    property RotatedLeft : integer read FRotateLeft;
    property ImgRight : integer read FImgRight write FImgRight;
    property ImgBottom : integer read FImgBottom write FImgBottom;

    property ArtPage: IIGArtXPage read FArtPage write FArtPage;
    property ArtPageID: String read FArtPageID write FArtPageID;
    property MarkDeleted : boolean read FAnnotDeleted write FAnnotDeleted;  //p122t7
  end;

  TArtPageObjectList = class(TObjectList)
  private
    function GetArtPageItem(AIndex: Integer): TArtPageObject;
    procedure SetArtPageItem(AIndex: Integer; const Value: TArtPageObject);
  public
    property Items[AIndex: Integer]: TArtPageObject read GetArtPageItem write SetArtPageItem; default;
    function Add(AArtPageItem: TArtPageObject): Integer;
    function GetArtPageID(Idx: Integer): String;
  end;

  TAnnotNodeData = class(TObject)
    private
      FSavedDateTime: String;
      FUserName: String;
      FVersion: String;
      FDUZ: String;
      FSiteID: String;
      FService: String;
      FSource: String;
      FDeletion: String;
      FResulted: String;
      FLayerNumber: String;
      FCachedFileName: String;
      function GetHistoryDateTime: String;
      function GetFormattedToolTip: String;
    public
      property SavedDateTime: String read GetHistoryDateTime write FSavedDateTime;
      property DUZ: String read FDUZ write FDUZ;
      property Service: String read FService write FService;
      property Source: String read FSource write FSource;
      property Deletion: String read FDeletion write FDeletion;
      property FormattedToolTip: String read GetFormattedToolTip;
      property LayerNumber: String read FLayerNumber write FLayerNumber;
      property CachedFileName: String read FCachedFileName write FCachedFileName;
      property UserName: String read FUserName write FUserName;
      property Version: String read FVersion write FVersion;
      property SiteID: String read FSiteID write FSiteID;
      property Resulted: String read FResulted write FResulted;   {'0' = False, '1' = True}
  end;

  TMagAnnotChoicesBox = class (TForm)
    lstChoice : TCustomListBox;
    btnOk : TButton;
    btnCancel : TButton;           // p122 7/28 - add cancel;

    Procedure InitForm;
    Procedure InitItems(items : string);
    Procedure btnOKOnClick(Sender : TObject);
    Procedure btnCancelOnClick(Sender : TObject);
  end;

  TMagAnnotRulerCalibrate = class(TForm)
    lblUnit : TLabel;
    measUnit : TCombobox;
    btnOK : TButton;
    btnCancel : TButton;      //p122 7/12/11 - added cancel option
    lblMeas : TLabel;  //p122 7/8/11
    lblDot : TLabel; 
    edtLeft : TEdit;
    edtRight : TEdit;

    Procedure InitForm;
    Procedure btnOKOnClick(Sender: TObject);
    Procedure btnCancelOnClick(Sender : TObject); //p122 7/12/11
    procedure EditKeyPress(Sender: TObject; var Key: Char);
  end;

  TAnnotationType = (
    Annot00_SELECT_,
    Annot01_IMAGE_EMBEDDED_,
    Annot02_IMAGE_REFERENCE_,
    Annot03_LINE_,
    Annot04_FREEHAND_LINE_,
    Annot05_HOLLOW_RECTANGLE_,
    Annot06_FILLED_RECTANGLE_,
    Annot07_TYPED_TEXT_,
    Annot08_TEXT_FROM_FILE_,
    Annot09_TEXT_STAMP_,
    Annot10_ATTACH_A_NOTE_,
    Annot11_FILLED_POLYGON_,
    Annot12_HOLLOW_POLYGON_,
    Annot13_POLYLINE_,
    Annot14_AUDIO_,
    Annot15_FILLED_ELLIPSE_,
    Annot16_HOLLOW_ELLIPSE_,
    Annot17_ARROW_,
    Annot18_HOTSPOT_,
    Annot19_REDACTION_,
    Annot20_ENCRYPTION_,
    Annot21_RULER_,
    Annot22_PROTRACTOR_,
    Annot23_BUTTON_,
    Annot24_PIN_UP_TEXT_,
    Annot25_HIGHLIGHTER_,
    Annot26_RICH_TEXT_,
    Annot27_CALLOUT_,
    Annot28_RECTANGLE_,
    Annot29_ELLIPSE_,
    Annot30_POLYGON_,
    Annot31_TEXT_,
    Annot32_IMAGE_,
    Annot33_HOLLOW_SQUARE_,
    Annot34_FILLED_SQUARE_,
    Annot35_HOLLOW_CIRCLE_,
    Annot36_FILLED_CIRCLE_,
    Annot60_Options_
    );

  {/ P122 - JK 5/9/2011 /}
  TRequiredAnnotation = (
    Annot00_SELECT,
    Annot03_LINE,
    Annot04_FREEHAND_LINE,
    Annot05_HOLLOW_RECTANGLE,
    Annot07_TYPED_TEXT,
    Annot13_POLYLINE,
    Annot16_HOLLOW_ELLIPSE,
    Annot21_RULER,
    Annot22_PROTRACTOR,
    Annot17_ARROW,
    Annot25_HIGHLIGHTER,
    Annot60_Options
    );

  {/ P122 - JK 5/9/2011 - removed /}
  TAdditionalAnnotation = (
    Annot01_IMAGE_EMBEDDED,
    Annot02_IMAGE_REFERENCE,
    Annot06_FILLED_RECTANGLE,
    Annot08_TEXT_FROM_FILE,
    Annot09_TEXT_STAMP,
    Annot10_ATTACH_A_NOTE,
    Annot11_FILLED_POLYGON,
    Annot12_HOLLOW_POLYGON,
    Annot14_AUDIO,
    Annot15_FILLED_ELLIPSE,
    Annot18_HOTSPOT,
    Annot19_REDACTION,
    Annot20_ENCRYPTION,
//    Annot21_RULER,
//    Annot22_PROTRACTOR,
    Annot23_BUTTON,
    Annot24_PIN_UP_TEXT,
//    Annot25_HIGHLIGHTER,
    Annot26_RICH_TEXT,
    Annot27_CALLOUT,
    Annot28_RECTANGLE,
    Annot29_ELLIPSE,
    Annot30_POLYGON,
    Annot31_TEXT,
    Annot32_IMAGE,
    Annot34_FILLED_SQUARE,
    Annot36_FILLED_CIRCLE
    );

  TAdditionalAnnotations = Set Of TAdditionalAnnotation;
  TRequiredAnnotations = Set Of TRequiredAnnotation;
  TMagAnnotClipboardActions =
    (
    AnnotCopyAll,
    AnnotCopyFirst,
    AnnotCopyLast,
    AnnotCutAll,
    AnnotCutFirst,
    AnnotCutLast,
    AnnotDeleteAll,
    AnnotDeleteFirst,
    AnnotDeleteLast
    );
  TMagAnnotationArrowType =
    (
    MagAnnArrowPointer,
    MagAnnArrowSolid,
    MagAnnArrowOpen,
    MagAnnArrowPointerSolid,
    MagAnnArrowNone
    );

  TMagAnnotationArrowSize =
    (
    MagAnnArrowSizeSmall = 20,
    MagAnnArrowSizeMedium = 40,
    MagAnnArrowSizeLarge = 60
    );

  TMagAnnotationLineWidth =
    (
    MagAnnLineWidthThin = 2,
    MagAnnLineWidthMedium = 5,
    MagAnnLineWidthThick = 10
    );

  TMagAnnotationToolType =
    (
    MagAnnToolArrow,
    MagAnnToolFilledEllipse,
    MagAnnToolFilledRectangle,
    MagAnnToolFreehandLine,
    MagAnnToolHollowEllipse,
    MagAnnToolHollowRectangle,
    MagAnnToolMinus,
    MagAnnToolPlus,
    MagAnnToolPointer,
    MagAnnToolProtractor,
    MagAnnToolRuler,
    MagAnnToolStraightLine,
    MagAnnToolTypedText,
    MagAnnTool_00_SELECT,
    MagAnnTool_01_IMAGE_EMBEDDED,
    MagAnnTool_02_IMAGE_REFERENCE,
    MagAnnTool_03_LINE,
    MagAnnTool_04_FREEHAND_LINE,
    MagAnnTool_05_HOLLOW_RECTANGLE,
    MagAnnTool_06_FILLED_RECTANGLE,
    MagAnnTool_07_TYPED_TEXT,
    MagAnnTool_08_TEXT_FROM_FILE,
    MagAnnTool_09_TEXT_STAMP,
    MagAnnTool_10_ATTACH_A_NOTE,
    MagAnnTool_11_FILLED_POLYGON,
    MagAnnTool_12_HOLLOW_POLYGON,
    MagAnnTool_13_POLYLINE,
    MagAnnTool_14_AUDIO,
    MagAnnTool_15_FILLED_ELLIPSE,
    MagAnnTool_16_HOLLOW_ELLIPSE,
    MagAnnTool_17_ARROW,
    MagAnnTool_18_HOTSPOT,
    MagAnnTool_19_REDACTION,
    MagAnnTool_20_ENCRYPTION,
    MagAnnTool_21_RULER,
    MagAnnTool_22_PROTRACTOR,
    MagAnnTool_23_BUTTON,
    MagAnnTool_24_PIN_UP_TEXT,
    MagAnnTool_25_HIGHLIGHTER,
    MagAnnTool_26_RICH_TEXT,
    MagAnnTool_27_CALLOUT,
    MagAnnTool_28_RECTANGLE,
    MagAnnTool_29_ELLIPSE,
    MagAnnTool_30_POLYGON,
    MagAnnTool_31_TEXT,
    MagAnnTool_32_IMAGE,
    MagAnnTool_33_HOLLOW_SQUARE,
    MagAnnTool_34_FILLED_SQUARE,
    MagAnnTool_35_HOLLOW_CIRCLE,
    MagAnnTool_36_FILLED_CIRCLE,
    MagAnnTool_60_Options
    );

  TMagAnnot = Class(TForm)
    actAnnot00_SELECT: TAction;
    actAnnot01_IMAGE_EMBEDDED: TAction;
    actAnnot02_IMAGE_REFERENCE: TAction;
    actAnnot03_LINE: TAction;
    actAnnot04_FREEHAND_LINE: TAction;
    actAnnot05_HOLLOW_RECTANGLE: TAction;
    actAnnot06_FILLED_RECTANGLE: TAction;
    actAnnot07_TYPED_TEXT: TAction;
    actAnnot08_TEXT_FROM_FILE: TAction;
    actAnnot09_TEXT_STAMP: TAction;
    actAnnot10_ATTACH_A_NOTE: TAction;
    actAnnot11_FILLED_POLYGON: TAction;
    actAnnot12_HOLLOW_POLYGON: TAction;
    actAnnot13_POLYLINE: TAction;
    actAnnot14_AUDIO: TAction;
    actAnnot15_FILLED_ELLIPSE: TAction;
    actAnnot16_HOLLOW_ELLIPSE: TAction;
    actAnnot17_ARROW: TAction;
    actAnnot18_HOTSPOT: TAction;
    actAnnot19_REDACTION: TAction;
    actAnnot20_ENCRYPTION: TAction;
    actAnnot21_RULER: TAction;
    actAnnot22_PROTRACTOR: TAction;
    actAnnot23_BUTTON: TAction;
    actAnnot24_PIN_UP_TEXT: TAction;
    actAnnot25_HIGHLIGHTER: TAction;
    actAnnot26_RICH_TEXT: TAction;
    actAnnot27_CALLOUT: TAction;
    actAnnot28_RECTANGLE: TAction;
    actAnnot29_ELLIPSE: TAction;
    actAnnot30_POLYGON: TAction;
    actAnnot31_TEXT: TAction;
    actAnnot32_IMAGE: TAction;
    actAnnot33_HOLLOW_SQUARE: TAction;
    actAnnot34_FILLED_SQUARE: TAction;
    actAnnot35_HOLLOW_CIRCLE: TAction;
    actAnnot36_FILLED_CIRCLE: TAction;
    actAnnot60_Options: TAction;
    actEditCopySelectedAll: TAction;
    actEditCopySelectedFirst: TAction;
    actEditCopySelectedLast: TAction;
    actEditCutSelectedAll: TAction;
    actEditCutSelectedFirst: TAction;
    actEditCutSelectedLast: TAction;
    actEditDeleteAll: TAction;
    actEditDeleteFirst: TAction;
    actEditDeleteLast: TAction;
    actEditDeleteSelectedAll: TAction;
    actEditDeleteSelectedFirst: TAction;
    actEditDeleteSelectedLast: TAction;
    actEditEditMode: TAction;
    actEditFlipHorizontally: TAction;
    actEditFlipVertically: TAction;
    actEditPaste: TAction;
    actEditRotate180: TAction;
    actEditRotate270CCW: TAction;
    actEditRotate270CW: TAction;
    actEditRotate90CCW: TAction;
    actEditRotate90CW: TAction;
    actEditSelectAll: TAction;
    actEditUndo: TAction;
    actEditUndoEnable: TAction;
    actEditUnSelectAll: TAction;
    actFileClose: TAction;
    actFileExportAnnotations: TAction;
    actFileImportXMLAnnotations: TAction;
    actFileLoad: TAction;
    actFileSave: TAction;
    ActionList: TActionList;
    actViewAntialiasingOff: TAction;
    actViewAntialiasingOn: TAction;
    actViewFitToActualSize: TAction;
    actViewFittoHeight: TAction;
    actViewFittoWidth: TAction;
    actViewFittoWindow: TAction;
    actViewHide: TAction;
    actViewZoomIn: TAction;
    actViewZoomOut: TAction;
    actViewZoomReset: TAction;
    lstImages: TImageList;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    actEditUserCanEdit: TAction;
    pmuEdit: TPopupMenu;
    mnuEditUndo: TMenuItem;
    mnuEditCut: TMenuItem;
    mnuEditCutSelected: TMenuItem;
    mnuEditCopy: TMenuItem;
    mnuEditCopyAll: TMenuItem;
    mnuEditCopySelected: TMenuItem;
    mnuPaste: TMenuItem;
    mnuEditDelete: TMenuItem;
    mnuEditDeleteAll: TMenuItem;
    mnuEditDeleteSelected: TMenuItem;
    mnuEditSelectAll: TMenuItem;
    pnuView: TPopupMenu;
    mnuViewHide: TMenuItem;
    mnuViewHideAll: TMenuItem;
    mnuViewHideSelected: TMenuItem;
    mnuViewHideUser: TMenuItem;
    mnuViewHideSpecialty: TMenuItem;
    mnuViewHideDate: TMenuItem;
    mnuViewShow: TMenuItem;
    mnuViewShowAll: TMenuItem;
    mnuViewShowUser: TMenuItem;
    mnuViewShowSpecialty: TMenuItem;
    mnuViewShowDate: TMenuItem;
    ToggleToolbarOrientation: TAction;
    actAuditHistory: TAction;
    actTool_ImageInformation: TAction;
    actTool_MarkPropertyEditor: TAction;
    actEditCutSelected: TAction;
    Cut1: TMenuItem;
    sbStatus: TStatusBar;
    pmuRuler: TPopupMenu;
    akeMeasurement1: TMenuItem;
    Calibrate1: TMenuItem;
    ClearCalibration1: TMenuItem;
    actRulerCalibrate: TAction;
    pnlButtons: TPanel;
    AnnotToolBar: TToolBar;
    tbEditAnnotMarks: TToolButton;
    tbSearchAnnotationMarks: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    btnLine: TToolButton;
    btnFreehand: TToolButton;
    btnRectangle: TToolButton;
    ToolButton7: TToolButton;
    btnText: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    btnPolyline: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    btnCircle: TToolButton;
    btnArrow: TToolButton;
    ToolButton19: TToolButton;
    ToolButton20: TToolButton;
    ToolButton21: TToolButton;
    btnRuler: TToolButton;
    btnProtractor: TToolButton;
    ToolButton24: TToolButton;
    ToolButton25: TToolButton;
    btnHighlighter: TToolButton;
    ToolButton27: TToolButton;
    ToolButton28: TToolButton;
    ToolButton29: TToolButton;
    ToolButton30: TToolButton;
    ToolButton31: TToolButton;
    ToolButton32: TToolButton;
    ToolButton33: TToolButton;
    ToolButton34: TToolButton;
    ToolButton35: TToolButton;
    ToolButton36: TToolButton;
    btnToolSettings: TToolButton;
    btnMarkSettings: TToolButton;
    btnHistory: TToolButton;
    btnImageInfo: TToolButton;
    btnToggleToolbarOrientation: TToolButton;
    pnlHistory: TPanel;
    ScrollBox1: TScrollBox;
    tvHistory: TTreeView;
    pnlInfo: TPanel;
    Splitter1: TSplitter;
    actRulerClearCalibration: TAction;
    pnl_OK_Indicator: TPanel;
    imgReadOnly: TImage;
    Procedure actAnnot00_SELECTExecute(Sender: Tobject);
    Procedure actAnnot01_IMAGE_EMBEDDEDExecute(Sender: Tobject);
    Procedure actAnnot02_IMAGE_REFERENCEExecute(Sender: Tobject);
    Procedure actAnnot03_LINEExecute(Sender: Tobject);
    Procedure actAnnot04_FREEHAND_LINEExecute(Sender: Tobject);
    Procedure actAnnot05_HOLLOW_RECTANGLEExecute(Sender: Tobject);
    Procedure actAnnot06_FILLED_RECTANGLEExecute(Sender: Tobject);
    Procedure actAnnot07_TYPED_TEXTExecute(Sender: Tobject);
    Procedure actAnnot08_TEXT_FROM_FILEExecute(Sender: Tobject);
    Procedure actAnnot09_TEXT_STAMPExecute(Sender: Tobject);
    Procedure actAnnot10_ATTACH_A_NOTEExecute(Sender: Tobject);
    Procedure actAnnot11_FILLED_POLYGONExecute(Sender: Tobject);
    Procedure actAnnot12_HOLLOW_POLYGONExecute(Sender: Tobject);
    Procedure actAnnot13_POLYLINEExecute(Sender: Tobject);
    Procedure actAnnot14_AUDIOExecute(Sender: Tobject);
    Procedure actAnnot15_FILLED_ELLIPSEExecute(Sender: Tobject);
    Procedure actAnnot16_HOLLOW_ELLIPSEExecute(Sender: Tobject);
    Procedure actAnnot17_ARROWExecute(Sender: Tobject);
    Procedure actAnnot18_HOTSPOTExecute(Sender: Tobject);
    Procedure actAnnot19_REDACTIONExecute(Sender: Tobject);
    Procedure actAnnot20_ENCRYPTIONExecute(Sender: Tobject);
    Procedure actAnnot21_RULERExecute(Sender: Tobject);
    Procedure actAnnot22_PROTRACTORExecute(Sender: Tobject);
    Procedure actAnnot23_BUTTONExecute(Sender: Tobject);
    Procedure actAnnot24_PIN_UP_TEXTExecute(Sender: Tobject);
    Procedure actAnnot25_HIGHLIGHTERExecute(Sender: Tobject);
    Procedure actAnnot26_RICH_TEXTExecute(Sender: Tobject);
    Procedure actAnnot27_CALLOUTExecute(Sender: Tobject);
    Procedure actAnnot28_RECTANGLEExecute(Sender: Tobject);
    Procedure actAnnot29_ELLIPSEExecute(Sender: Tobject);
    Procedure actAnnot30_POLYGONExecute(Sender: Tobject);
    Procedure actAnnot31_TEXTExecute(Sender: Tobject);
    Procedure actAnnot32_IMAGEExecute(Sender: Tobject);
    Procedure actAnnot33_HOLLOW_SQUAREExecute(Sender: Tobject);
    Procedure actAnnot34_FILLED_SQUAREExecute(Sender: Tobject);
    Procedure actAnnot35_HOLLOW_CIRCLEExecute(Sender: Tobject);
    Procedure actAnnot36_FILLED_CIRCLEExecute(Sender: Tobject);
    Procedure actAnnot60_OptionsExecute(Sender: Tobject);
    Procedure actEditCopySelectedAllExecute(Sender: Tobject);
    Procedure actEditCopySelectedFirstExecute(Sender: Tobject);
    Procedure actEditCopySelectedLastExecute(Sender: Tobject);
    Procedure actEditCutSelectedAllExecute(Sender: Tobject);
    Procedure actEditCutSelectedFirstExecute(Sender: Tobject);
    Procedure actEditCutSelectedLastExecute(Sender: Tobject);
    Procedure actEditDeleteAllExecute(Sender: Tobject);
    Procedure actEditDeleteFirstExecute(Sender: Tobject);
    Procedure actEditDeleteLastExecute(Sender: Tobject);
    Procedure actEditDeleteSelectedAllExecute(Sender: Tobject);
    Procedure actEditDeleteSelectedFirstExecute(Sender: Tobject);
    Procedure actEditDeleteSelectedLastExecute(Sender: Tobject);
    Procedure actEditEditModeExecute(Sender: Tobject);
    Procedure actEditFlipHorizontallyExecute(Sender: Tobject);
    Procedure actEditFlipVerticallyExecute(Sender: Tobject);
    Procedure actEditPasteExecute(Sender: Tobject);
    Procedure actEditRotate180Execute(Sender: Tobject);
    Procedure actEditRotate270CCWExecute(Sender: Tobject);
    Procedure actEditRotate270CWExecute(Sender: Tobject);
    Procedure actEditRotate90CCWExecute(Sender: Tobject);
    Procedure actEditRotate90CWExecute(Sender: Tobject);
    Procedure actEditSelectAllExecute(Sender: Tobject);
    Procedure actEditUndoEnableExecute(Sender: Tobject);
    Procedure actEditUndoExecute(Sender: Tobject);
    Procedure actEditUnSelectAllExecute(Sender: Tobject);
    Procedure actFileCloseExecute(Sender: Tobject);
    Procedure actFileExportAnnotationsExecute(Sender: Tobject);
    Procedure actFileImportXMLAnnotationsExecute(Sender: Tobject);
    Procedure actFileLoadExecute(Sender: Tobject);
    Procedure actFileSaveExecute(Sender: Tobject);
    Procedure actViewAntialiasingOffExecute(Sender: Tobject);
    Procedure actViewAntialiasingOnExecute(Sender: Tobject);
    Procedure actViewFitToActualSizeExecute(Sender: Tobject);
    Procedure actViewFittoHeightExecute(Sender: Tobject);
    Procedure actViewFittoWidthExecute(Sender: Tobject);
    Procedure actViewFittoWindowExecute(Sender: Tobject);
    Procedure actViewHideExecute(Sender: Tobject);
    Procedure actViewZoomInExecute(Sender: Tobject);
    Procedure actViewZoomOutExecute(Sender: Tobject);
    Procedure actViewZoomResetExecute(Sender: Tobject);
    Procedure FIGArtXCtlCreateMarkNotify(ASender: Tobject; Const Params: IIGArtXCreateMarkEventParams);
    Procedure FIGArtXCtlDeleteMarkNotify(ASender: Tobject; Const Params: IIGArtXDeleteMarkEventParams);
    procedure FIGArtXCtlModifyMarkNotify(ASender: Tobject; const Params: IIGArtXModifyMarkEventParams);
    Procedure FIGArtXCtlPreCreateMarkNotify(ASender: Tobject; Const Params: IIGArtXPreCreateMarkEventParams);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure FormCreate(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure actEditUserCanEditExecute(Sender: Tobject);
    procedure SaveUserPreferences1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actAuditHistoryExecute(Sender: TObject);
    procedure actTool_ImageInformationExecute(Sender: TObject);
    procedure actTool_MarkPropertyEditorExecute(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure mnuEditCutSelectedClick(Sender: TObject);
    procedure btnHistoryClick(Sender: TObject);
    procedure mnuEditCopyAllClick(Sender: TObject);
    procedure mnuEditCopySelectedClick(Sender: TObject);
    procedure mnuEditDeleteAllClick(Sender: TObject);
    procedure mnuEditDeleteSelectedClick(Sender: TObject);
    procedure mnuViewHideAllClick(Sender: TObject);
    procedure mnuViewHideSelectedClick(Sender: TObject);
    procedure mnuViewHideUserClick(Sender: TObject);
    procedure mnuViewHideSpecialtyClick(Sender: TObject);
    procedure mnuViewHideDateClick(Sender: TObject);
    procedure mnuViewShowAllClick(Sender: TObject);
    procedure mnuViewShowUserClick(Sender: TObject);
    procedure mnuViewShowSpecialtyClick(Sender: TObject);
    procedure mnuViewShowDateClick(Sender: TObject);
    procedure mnuEditSelectAllClick(Sender: TObject);
    procedure tvHistoryMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure actRulerCalibrateExecute(Sender: TObject);
    procedure tvHistoryClick(Sender: TObject);
    procedure actRulerClearCalibrationExecute(Sender: TObject);
    procedure imgReadOnlyMouseEnter(Sender: TObject);
    procedure AnnotToolBarMouseActivate(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y, HitTest: Integer;
      var MouseActivate: TMouseActivate);
  Private
    FAnnotsModified: Boolean;   {/ P122 - JK 6/6/2011 - Keep track of if the art page was modified with a new annot or one was edited/deleted /}
    FOldAnnotsDeleted : Boolean; {/p122t7 dmmn 10/31 - flagged if user deleted an old annotation /}
    FIsInHistoryView: Boolean; {/p122t2 dmmn 9/1/11 - flag to check if the user is in history view /}
    FAnnotSessionInitialized: Boolean;
    FArtPageList: TArtPageObjectList;    {/ P122 - JK 5/27/2011 /}
    FConsultResulted: String;
    FImageIEN: String;
    FMostRecentLayer: String;
    FPrevHistIndex : Integer;
    FPrevHistCheck : Boolean;
    FToolbarCaption: String; {/ P122 - JK 5/4/2011 /}
    FToolbarCoords: TPoint; {/ P122 - JK 5/4/2011 /}
    FServerName: String;
    FServerPort: Integer;
    FService: String;
    FSessionDateTime: String;
    Fusername: String;
    FDUZ : String; //p122t4 dmmn
    FSiteNum : String; //p122t4 dmmn

    lastHintNode : TTreeNode;
    LayerList : TStringList;  {holds a list of annotation history layer information for an ImageIEN}
    XMLCtl: TXMLCtl;  {/ P122 - JK 6/3/2011 - Duc's XML object /}

    FUseDICOMratio : Boolean; {/p122 dmmn 8/23 - this is to indicate that an image has value from Dicom header.
                                Rulers will use the DICOM aspectration until user clear calibration or recalibrate /}
//Was for RCA decouple magmsg, not now.    procedure MyLogMsg(msgType, msg: String; Priority: TMagMsgPriority = magmsgINFO);

    function CanUserModifyMark(IGMark: IIGArtXMark): boolean;
    function CanUserModifyAllMarks(IGMarks: IIGArtXMarkArray): boolean;
    function CanUserModifyPoint(IGPoint : IIGPoint) : boolean; //p122t4 dmmn 8 function to check if an user can modify a point

    procedure ChangeAnnotationPage(curPageNum, nextPageNum: Integer);
//RCA     procedure CreateMarkRulerNotify(Const RulerMark: IIGArtXRuler);
    procedure ClearAllAspectRatio;  //p122 7/13/11
    procedure CutSelected;
    Procedure CopySelected; {/p122 dmmn 7/28 - copy selected }
    Procedure DeleteSelected; {/p122 dmmn 7/28 - delete selected }
    Function FormatDatePiece(Str: String): String;
    Function FormatToolTip(S: String): String;
    procedure GetAnnotHistoryList(ImageIEN: String; var HistoryList: TStringList);
    function GetHiddenCount: integer;
    function GetHiddenMarkCount_CurrentPage: Integer;
//RCA    procedure GetHistories(fileList: TStringList; var HistoryList: TStringList);
    function GetMarkCount_CurrentPage: Integer;
    function GetNewAspectRatio(value: integer; currentRuler: IIGArtXRuler): IIGArtXAspectRatio;
    Function GetUserCanEdit: Boolean;
    function GetViewHideChoices(hide: Boolean; fieldNumber: Integer): string;
    function GetViewHideFieldValue(fieldNumber: integer; tooltips: string): string;
//RCA     function IsHistoryCached(NodeData: TAnnotNodeData): Boolean;
    procedure LoadAllArtPages;
//RCA    procedure LoadAnnotationHistory;
    procedure LoadCurrentSessionLayer;
    procedure LoadTempCurrentSessionLayer; {/p122t2 dmmn 9/1/11 /}
    procedure LoadAnnotationHistories(LayerList: TStringList);
    function LoadXmlHistory(ImageIEN: String; LayerNumber: String; CurrentLayer: Boolean): Boolean;
    function LoadXmlRadiology(ImageIEN: String; LayerNumber: String; CurrentLayer: Boolean): Boolean; //p122 dmmn 8/2 - load rad annotations
    function MarksSelected: Integer;
//RCA    function NodeHint(tn: TTreeNode): String;
    procedure RefreshAnnotInfoBar;
    procedure RefreshHistory;
    Function RemoveTabCharacters(XML: TStringList): String;   //p122 dmmn 8/2
    procedure SaveAllArtPages;
//p129 make public    procedure SaveAnnotations(forceIEN : string = '');
//RCA    procedure SaveSessionViewToTemp;
//RCA    procedure SaveCurrentSeesionAllArtPages;
    procedure SaveCurrentSessionToTemp;                 //p122t2 dmmn 9/2 - common save to temp when current session is modified
    procedure SaveXmlToVista(XmlFileName: String);
    procedure SetAnnotationOwnership(IGMark: IIGArtXMark);
    procedure EditAnnotationOwnership(IGMark : IIGArtXMark); //p122t2 dmmn 8/31
    procedure SetAnnotVisibilityByFieldValue(hide: Boolean; fieldNumber: Integer);
    procedure SetCompHorizontal;  {/ P122 - JK 5/30/2011 - Duc's toolbar orientation method /}
    procedure SetUserCanEdit(const Value: Boolean);
    procedure SetAnnotPrivileges;
//    procedure ShowAllMarks;
    procedure UpdateMarksWithTimeSaved(datetime: string);
    procedure UpdateEditedMarksWithNewOwnership; //p122t2 dmmn 8/31
    procedure UpdateNewAspectRatio;
    Function ValidateXML(const xmlFile : TFileName) : boolean;//p122 dmmn 8/2
    procedure DeleteAllMarks;

    function GetRadAnnotCount: Integer;
    function ContainOddRadAnnotations: boolean;
    function AnnotationIsOutside: boolean;//p122 dmmn 8/2
    procedure UpdateTooltipToStatusBar(IGMark : IIGArtXMark);
    function GetTempAnnotations: boolean; //p122t4 dmmn 9/27
    function IsCurrentPageChanged: boolean;
    function IsSessionChanged: boolean;   //p122t7 dmmn 10/28
    procedure FinalizeText; //p122t11 dmmn 1/18/12
    function RemoveIllegalChar(Value : string) : string; //p122t11 dmmn 1/24/12
  Protected
    createArrow : Boolean;             //P122 DMMN 6/27/2011 create line with arrow head if true
    createHighlighter : Boolean;       //P122 DMMN 6/27/2011 create rectangle with no border and fill
    createFill : Boolean;              //P122 DMMN 6/27/2011 create filled shapes
    FAdditionalAnnotations: TAdditionalAnnotations;
    FAnnotationStyle: TMagAnnotationStyle;
    FArrowLength: Integer;
    FArtPage: IIGArtXPage;
    FAnnotationStatus: String;
    FCurAnnot: TAnnotationType;
    FCurrentPage: IIGPage;
    FCurrentPageDisp: IIGPageDisplay;
    FCurrentPageNumber: Integer;
    FDcmCol : integer;  //p122 dmmn 8/3 - for scaling radiology annotations
    FDcmRow : integer;
    FEditMode: Boolean;
    FEditModeFalseReason: String;
    FEditModeFalseReasonShow: Boolean;
    FHasRADAnnotation : boolean; //p122 dmmn 8/5 - prevent double loading when opening up image
    FAnnotatedByVR : Boolean; //p122t15 dmmn 7/11/12 - indicate that the image is annotated
    FHasAnnotatePermission: Boolean; {/ P122 JK 10/3/2011 /}
    FHasMasterKey: Boolean;  {/ P122 JK 10/3/2011 /}
    FIGArtDrawParams: IIGArtXDrawParams;
    FIGPageViewCtl: TIGPageViewCtl;
    FIoLocation: IIGIOLocation;
    FIsAnnotationMode: Boolean;
    FIsRadVisible: Boolean; {/ P122 - JK 8/10/2011 - are vistarad annots showing or not /}
    FMagAnnotationStyleChangeEvent: TMagAnnotationStyleChangeEvent;
    FPage: Integer;
    FPageCount: Integer;
    FProtractorState: Integer;
//    FRADAnnotationCount : Integer; //p122 dmmn 8/9 - rad annotation count
    FRADAnnotationIGCount : Integer; //p122t3 dmmn 9/15 - IG marks needed to map vista rad
    FRadInfo : TRADinfo;

    FRADPack : Boolean ; //p122 dmmn 8/2/11 - identify if the annotation session is for RAD image or not
    FIsDODImage : Boolean ; //p122t15 dmmn 8/13/12 - identify if the image is from dod
    FToolbarInitialized: Boolean;
    FToolbarIsShowing: Boolean;
    FTotalLocationPageCount: Integer;
    FUserCanEdit: Boolean;
    FVistaRadMessage: String;  {/ P122 JK 8/10/2011 - communicate VR patient safety info to the gear pnlRadiology caption /}
    IgCurPoint: IGPoint;
    PageViewHwnd: Integer;

    DisablePPM : Boolean; //p122 dmmn 8/26 - scale text to zoom
    FCaptureNewImage : boolean; {/129 gek 5/2/12  flag for use captureing new images.  No IEN}

    Function GetAnnotationOptions : TfrmAnnotOptionsX;  //p122 dmmn 7/9/11
    Function GetAnnotationStyle: TMagAnnotationStyle;
    Function GetCurrentPage: IIGPage;
    Function GetEditMode: Boolean;
    Function GetIGArtXCtl: TIGArtXCtl;
    Function GetIGArtXGUICtl: TIGArtXGUICtl;
    Function GetIGCoreCtl: TIGCoreCtl;
    Function GetIGDisplayCtl: TIGDisplayCtl;
    Function GetIGDlgsCtl: TIGDlgsCtl;
    Function GetIGFormatsCtl: TIGFormatsCtl;
    Function GetIGGUIDlgCtl: TIGGUIDlgCtl;
    Function GetIGProcessingCtrl: TIGProcessingCtl;
    Function GetPage: Integer;
    Function GetPageCount: Integer;
    Procedure SetAnnotationStyle(Const Value: TMagAnnotationStyle);
    Procedure SetCurrentPage(Const Value: IIGPage);
    Procedure SetCurrentPageDisp(Const Value: IIGPageDisplay);
    Procedure SetEditMode(Value: Boolean);
    Procedure SetIGPageViewCtl(Const Value: TIGPageViewCtl);
    Procedure SetPage(Const Value: Integer);
    Procedure SetPageCount(Const Value: Integer);
//  Published
  Public

    Buttons: Array[0..37] Of TSpeedButton;
   /// moved to pupublic  140 gek,...  capture wouldn't compile.
    procedure DeleteAllMarksOnAllPages;     //p122t10
    constructor Create(AOwner: TComponent);  override;
    destructor Destroy; override;
    procedure AssociateArtPageWithImage(PageNum: Integer);  {/ P122 - JK 5/12/2011 /}
    Procedure CheckErrors();
    Procedure ClearAllAnnotations(); Virtual;
    Procedure ClearSelectedAnnotations(); Virtual;
    Function ClipboardAction(action: TMagAnnotClipboardActions): Boolean; Virtual;
    procedure ConnectArtPage(PageNum: Integer; CurrentPage_: IIGPage; CurrentPageDisp_: IIGPageDisplay);
    Function Copy(): Boolean; Virtual;
    Function CopyFirstSelected(): Boolean; Virtual;
    Function CopyLastSelected(): Boolean; Virtual;
    Function CreateArtPage(): IIGArtXPage; Overload;
    Function CreateArtPage(CurrentPage_: IIGPage; CurrentPageDisp_: IIGPageDisplay): IIGArtXPage; Overload;
    Function CreateCircle(IGRect: IIGRectangle; FillColor: IIGPixel; Border: IIGArtXBorder; Opacity: Integer): IIGArtXEllipse;
    Function CreateFilledSquare(IGRect: IIGRectangle; FillColor: IIGPixel; bHighlight: WordBool): IIGArtXFilledRectangle;
    Function CreateHollowCircle(IGRect: IIGRectangle; Border: IIGArtXBorder; bHighlight: WordBool): IIGArtXHollowEllipse;
    Function CreateHollowSquare(IGRect: IIGRectangle; Border: IIGArtXBorder; bHighlight: WordBool): IIGArtXHollowRectangle;
    Procedure CreateMarkEllipseToDefaults(IGMark: IIGArtXEllipse);
    Procedure CreateMarkRectangleToDefaults(IGMark: IIGArtXRectangle);
    Procedure CreatePage();
    Function CurrentPageClear(): Boolean;
    Function CreateSquare(IGRect: IIGRectangle; FillColor: IIGPixel; Border: IIGArtXBorder; Opacity: Integer): IIGArtXRectangle;
    Function Cut: Boolean; Virtual;
    Function CutFirstSelected(): Boolean; Virtual;
    Function CutLastSelected(): Boolean; Virtual;
    Function DeleteLastAnnotByType(mark: enumIGArtXMarkType): Boolean;
    Function DeleteLastArrow: Boolean;
    Function DeleteLastAudio: Boolean;
    Function DeleteLastButton: Boolean;
    function DeleteCachedFiles(const Path, Mask: string): integer;  {JK 6/26/2012 - moved from private section}
    Function DeleteLastEllipse: Boolean;
    Function DeleteLastFilledEllipse: Boolean;
    Function DeleteLastFilledPolygon: Boolean;
    Function DeleteLastFilledRectangle: Boolean;
    Function DeleteLastFreeline: Boolean;
    Function DeleteLastHighlighter: Boolean;
    Function DeleteLastHollowEllipse(): Boolean;
    Function DeleteLastHollowPolygon: Boolean;
    Function DeleteLastHollowRectangle(): Boolean;
    Function DeleteLastHotSpot: Boolean;
    Function DeleteLastImage: Boolean;
    Function DeleteLastImageEmb: Boolean;
    Function DeleteLastImageRef: Boolean;
    Function DeleteLastLine: Boolean;
    Function DeleteLastPolygon: Boolean;
    Function DeleteLastPolyline: Boolean;
    Function DeleteLastProtractor: Boolean;
    Function DeleteLastRectangle: Boolean;
    Function DeleteLastRedaction: Boolean;
    Function DeleteLastRuler: Boolean;
    Function DeleteLastText: Boolean;
    Function DeleteLastTextFromFile: Boolean;
    Function DeleteLastTextNote: Boolean;
    Function DeleteLastTextPinUp: Boolean;
    Function DeleteLastTextStamp: Boolean;
    Function DeleteLastTextTyped: Boolean;
    Procedure DisplayCurrentMarkProperties();
    Procedure DrawText(Left, Right, Top, Bottom, Red, Green, Blue: Integer; Text: String; FontSize: Integer); Virtual;
    Procedure EnableMeasurements(); Virtual;
    Function GetColor(): TColor; Virtual;
    Function GetFont(): TFont; Virtual;
    Function GetLastAnnotByType(mark: enumIGArtXMarkType): IIGArtXMark;
    Function GetLastAnnotRectByType(mark: enumIGArtXMarkType): IIGRectangle;
    Function GetLastArrow(): IIGArtXArrow;
    Function GetLastArrowRect(): IIGRectangle;
    Function GetLastAudio(): IIGArtXAudio;
    Function GetLastAudioRect(): IIGRectangle;
    Function GetLastButton(): IIGArtXButton;
    Function GetLastButtonRect(): IIGRectangle;
    Function GetLastEllipse(): IIGArtXEllipse;
    Function GetLastEllipseRect(): IIGRectangle;
    Function GetLastFilledEllipse(): IIGArtXFilledEllipse;
    Function GetLastFilledEllipseRect(): IIGRectangle;
    Function GetLastFilledPolygon(): IIGArtXFilledPolygon;
    Function GetLastFilledPolygonRect(): IIGRectangle;
    Function GetLastFilledRectangle(): IIGArtXFilledRectangle;
    Function GetLastFilledRectangleRect(): IIGRectangle;
    Function GetLastFreeline(): IIGArtXFreeline;
    Function GetLastFreelineRect(): IIGRectangle;
    Function GetLastHighlighter(): IIGArtXHighlighter;
    Function GetLastHighlighterRect(): IIGRectangle;
    Function GetLastHollowEllipse(): IIGArtXHollowEllipse;
    Function GetLastHollowEllipseRect(): IIGRectangle;
    Function GetLastHollowPolygon(): IIGArtXHollowPolygon;
    Function GetLastHollowPolygonRect(): IIGRectangle;
    Function GetLastHollowRectangle: IIGArtXHollowRectangle;
    Function GetLastHollowRectangleRect(): IIGRectangle;
    Function GetLastHotSpot(): IIGArtXHotSpot;
    Function GetLastHotSpotRect(): IIGRectangle;
    Function GetLastImage(): IIGArtXImage;
    Function GetLastImageEmb(): IIGArtXImageEmb;
    Function GetLastImageEmbRect(): IIGRectangle;
    Function GetLastImageRect(): IIGRectangle;
    Function GetLastImageRef(): IIGArtXImageRef;
    Function GetLastImageRefRect(): IIGRectangle;
    Function GetLastLine(): IIGArtXLine;
    Function GetLastLineRect(): IIGRectangle;
    Function GetLastPolygon(): IIGArtXPolygon;
    Function GetLastPolygonRect(): IIGRectangle;
    Function GetLastPolyline(): IIGArtXPolyline;
    Function GetLastPolylineRect(): IIGRectangle;
    Function GetLastProtractor(): IIGArtXProtractor;
    Function GetLastProtractorRect(): IIGRectangle;
    Function GetLastRectangle(): IIGArtXRectangle;
    Function GetLastRectangleRect(): IIGRectangle;
    Function GetLastRedaction(): IIGArtXRedaction;
    Function GetLastRedactionRect(): IIGRectangle;
    Function GetLastRuler(): IIGArtXRuler;
    Function GetLastRulerRect(): IIGRectangle;
    Function GetLastText(): IIGArtXText;
    Function GetLastTextFromFile(): IIGArtXTextFromFile;
    Function GetLastTextFromFileRect(): IIGRectangle;
    Function GetLastTextNote(): IIGArtXTextNote;
    Function GetLastTextNoteRect(): IIGRectangle;
    Function GetLastTextPinUp(): IIGArtXPin;
    Function GetLastTextPinUpRect(): IIGRectangle;
    Function GetLastTextRect(): IIGRectangle;
    Function GetLastTextStamp(): IIGArtXTextStamp;
    Function GetLastTextStampRect(): IIGRectangle;
    Function GetLastTextTyped(): IIGArtXTextTyped;
    Function GetLastTextTypedRect(): IIGRectangle;
    Function GetMarkCount(): Integer; Virtual;
    Function GetMenuItemByAction(action: TBasicAction): TMenuItem;
    function GetSelectedMarkCount_CurrentPage: Integer;
    procedure HideAllAnnotations(Initializing: Boolean);
    Procedure IGPageViewCtlMouseDown(ASender: Tobject; Button: Smallint; Shift: Smallint; x: Integer; y: Integer);
    Procedure IGPageViewCtlMouseMove(ASender: Tobject; Button, Shift: Smallint; x, y: Integer);
    Procedure IGPageViewCtlMouseUp(ASender: Tobject; Button, Shift: Smallint; x, y: Integer);
    procedure InitAnnotSession(ImageIEN: String; PageCount: Integer;
              DUZUserName: String; Service: String; Resulted: String; DUZ: String; SiteNum: String;
              ServerName: String; ServerPort: Integer; RadiologyReset: Boolean = False);
    Procedure InitButtonAlignLeft();
    Procedure InitButtonCaptions();
    Procedure InitButtonsArray();
    Procedure InitButtonVisibility();
    Procedure Initialize(CurPoint: IIGPoint; CurPage: IIGPage; CurPageDisp: IIGPageDisplay; PageViewHwnd: Integer; ForDiagramAnnotation: Boolean);
    Procedure InitializeToolbar(AnnotationComponent: TAnnotationType; x, y: Integer);
    Procedure InitializeVariables(); Virtual;
    Function IsValidEnv(): Boolean; Overload;
    Function IsValidEnv(CurPage: IIGPage): Boolean; Overload;
    Function IsValidForEdit(CurPage: IIGPage): Boolean;    
    function LoadAnnotations(HistXML: string): Boolean;  {/ P122 - JK 6/3/2011 /}
    procedure LoadCurrentAnnotations;  {/ P122 - JK 6/28/2011 /}
    Function LoadFile(Filename: String): String; Overload;
    Function LoadFile(): String; Overload;
    Function Paste(): Boolean; Virtual;
    Procedure PreCreateMarkArrowToDefaults(IGMark: IIGArtXArrow);
    Procedure PreCreateMarkEllipseToDefaults(IGMark: IIGArtXEllipse);
    Procedure PreCreateMarkFreehandLineToDefaults(IGMark: IIGArtXFreeline);
    Procedure PreCreateMarkHollowEllipseToDefaults(IGMark: IIGArtXHollowEllipse);
    Procedure PreCreateMarkHollowRectangleToDefaults(IGMark: IIGArtXHollowRectangle);
    Procedure PreCreateMarkLineToDefaults(IGMark: IIGArtXLine);
    Procedure PreCreateMarkPolylineToDefaults(IGMark: IIGArtXPolyline);
    Procedure PreCreateMarkProtractorToDefaults(IGMark: IIGArtXProtractor);
    Procedure PreCreateMarkRectangleToDefaults(IGMark: IIGArtXRectangle);
    Procedure PreCreateMarkRichTextToDefaults(IGMark: IIGArtXRichText);
    Procedure PreCreateMarkRulerToDefaults(IGMark: IIGArtXRuler);
    Procedure PreCreateMarkTextTypedToDefaults(IGMark: IIGArtXTextTyped);
    Procedure PreCreateMarkTextToDefaults(IGMark: IIGArtXText); //p122 dmmn 7/11/11 - art 3.0
    Procedure PostCreateMarkRuler(IGMark : IIGArtXMark); //p122 dmmn 7/12 - after process
    Procedure PostCreateMarkText(IGMark : IIGArtXMark); //p122 dmmn 8/22 - text entry

    Function RemoveAllAnnotations(): Boolean;
    Procedure RemoveOrientationLabel(); Virtual;
    Procedure ReplaceLastEllipseWithCircle(Filled: Boolean);
    Procedure ReplaceLastFilledRectangleWithFilledSquare();
    Procedure ReplaceLastRectangleWithSquare(Filled: Boolean);
    Procedure ResetPageGlobals();
    Procedure RotateImage(Value: enumIGRotationValues);
    Procedure RotateArtPageMarks(Page : integer; RotDir : integer);
    Procedure FlipMarks(FlipVal: enumIGFlipModes; imgRect, devRect : IGRectangle); //p122t3 dmmn
    Procedure FlipArtPageMarks(Page: integer; FlipType : enumIGFlipModes); //p122t3 dmmn

    function SaveAnnotationLayer(CloseWindow: Boolean = False): TAnnotWindowCloseAction; {/ P122 - JK 6/9/2011 /}
    procedure ScaleRadAnnotations(DcmCol : integer; DcmRow : integer);  //p122 dmmn 8/3
    Function SelectAll(): Boolean; Virtual;
    Function SelectedButtonIsDown(action: TAction): Boolean; Overload;
    Function SelectedButtonIsDown(action: TAnnotationType): Boolean; Overload;
    Function SelectFile(Var Filename: String; Var PageNum, PageCount: Integer): Boolean;
    Procedure SetAnnotationColor(aColor: TColor); Virtual;
    Procedure SetAnnotationStyles(); Virtual;
    Procedure SetArrowHead(IGMark: IIGArtXArrow); overload;   //p122 dmmn 7/11/11 - art 2.0
    Procedure SetArrowHead(IGMark: IIGArtXLine); overload;    //p122 dmmn 7.11.11 - art 3.0
    Procedure SetArrowLength(ArrowLength: TMagAnnotationArrowSize); Virtual;
    Procedure SetArrowPointer(aPointer: TMagAnnotationArrowType); Virtual;
    Procedure SetFont(TheFontName: String; TheFontSize: Integer; IsBold: Boolean; IsItalic: Boolean); Virtual;
    Procedure SetFontToDefaults(Var IGFont: IGArtXFont);
    Procedure SetLastArrowToDefaults();
    Procedure SetLastFreehandLineToDefaults();
    Procedure SetLastHollowEllipseToDefaults();
    Procedure SetLastHollowRectangleToDefaults();
    Procedure SetLastLineToDefaults();
    Procedure SetLastPolylineToDefaults(Button: Integer);
    Procedure SetLastProtractorToDefaults();
    Procedure SetLastRulerToDefaults();
    Procedure SetLineWidth(Width: TMagAnnotationLineWidth); Virtual;
    Procedure SetMenus();
    Procedure SetOpaque(IsOpaque: Boolean); Virtual;
    Procedure SetTool(NewTool: TMagAnnotationToolType); Virtual;
    procedure ShowAllAnnotations(Initializing: Boolean);
    procedure ShowArtPage(PageNum: Integer);  {/ P122 - 5/28/2011 /}
    Procedure UncheckAllAnnots();
    Function Undo(): Boolean; Virtual;
    Procedure UnselectAllMarks(); Virtual;
    procedure UpdateAnnotSessionInfo(ImageIEN: String; PageCount: Integer;
              DUZUserName, Service: String; Resulted: String; DUZ, SiteNum: String;
              ServerName: String; ServerPort: Integer);
    Procedure UpdateButtonEnabling();
    procedure UpdateMeasurementRatio(XRat,YRat : integer); //p122 dmmn 8/8 - precalibrated ruler from dicom header
    procedure ClearDICOMRation();
    procedure ClearActualRatio(); //p122t15 dmmn 7/11/12 - clear manual calibration for RAD image

    function GetDisplayResolution(var xDPI : double; var yDPI : double) : Boolean;
    function GetImageResolution(var xDPI : double; var yDPI : double) : Boolean;
    procedure ConverRealToFraction(realVal : Double; var pNum : integer; var pDem: integer);
    procedure ConfigureRulerForUnitMilimeter(IGMark : IIGArtXRuler);
    procedure UpdateOldRulerCalibrationToCurrent(IGMark : IIGArtXRuler); //p122t3 dmmn 9/19
    procedure SaveAnnotations(forceIEN : string = ''; fromCapture : boolean = false; isTRCImage :boolean = false);   //p129 make public
    procedure CapConvertAllAnnotationsToResulted(resulted : boolean = false);  //p129t19

  Published
    Property AdditionalAnnotations: TAdditionalAnnotations Read FAdditionalAnnotations Write FAdditionalAnnotations;
    Property AnnotationStyle: TMagAnnotationStyle Read GetAnnotationStyle Write SetAnnotationStyle;
    Property AnnotsModified: Boolean read FAnnotsModified write FAnnotsModified;
    Property AnnotSessionInitialized: Boolean read FAnnotSessionInitialized write FAnnotSessionInitialized;
    Property ArtPage: IIGArtXPage Read FArtPage Write FArtPage;
    Property ArtPageList: TArtPageObjectList read FArtPageList write FArtPageList; {/ P122 - JK 5/27/2011 /}
    Property AnnotationStatus: String read FAnnotationStatus write FAnnotationStatus;  {/ Holds the image data pieces for image status and image status description - WPR 3 33 /}
    Property ConsultResulted: String read FConsultResulted write FConsultResulted;
    Property CurAnnot: TAnnotationType Read FCurAnnot Write FCurAnnot;
    Property CurrentPage: IIGPage Read GetCurrentPage Write SetCurrentPage;
    Property CurrentPageDisp: IIGPageDisplay Read FCurrentPageDisp Write SetCurrentPageDisp;
    Property CurrentPageNumber: Integer Read FCurrentPageNumber Write FCurrentPageNumber;
    Property CurrentPoint: IGPoint Read IgCurPoint;
    Property EditMode: Boolean Read GetEditMode Write SetEditMode;
    Property HasRADAnnotation : boolean read FHasRADAnnotation write FHasRADAnnotation; //p122 dmmn 8/5
    Property AnnotatedByVR : Boolean read FAnnotatedByVR write FAnnotatedByVR; //p122t15 dmmn 7/11/12
    Property HasAnnotatePermission: Boolean read FHasAnnotatePermission write FHasAnnotatePermission; {/ P122 JK 10/3/2011 /}
    Property HasMasterKey: Boolean read FHasMasterKey write FHasMasterKey; {/ P122 JK 10/3/2011 /}
    Property HiddenCount : integer read GetHiddenCount;
    Property HiddenMarkCountCurrentPage: Integer Read GetHiddenMarkCount_CurrentPage;
    Property IGArtDrawParams: IIGArtXDrawParams Read FIGArtDrawParams;
    Property IGArtXCtl: TIGArtXCtl Read GetIGArtXCtl;
    Property IGArtXGUICtl: TIGArtXGUICtl Read GetIGArtXGUICtl;
    Property IGCoreCtl: TIGCoreCtl Read GetIGCoreCtl;
    Property IGDisplayCtrl: TIGDisplayCtl Read GetIGDisplayCtl;
    Property IGDlgsCtl: TIGDlgsCtl Read GetIGDlgsCtl;
    Property IGFormatsCtrl: TIGFormatsCtl Read GetIGFormatsCtl;
    Property IGGUIDlgCtl: TIGGUIDlgCtl Read GetIGGUIDlgCtl;
    Property IGPageViewCtl: TIGPageViewCtl Read FIGPageViewCtl Write SetIGPageViewCtl;
    Property IGProcessingCtrl: TIGProcessingCtl Read GetIGProcessingCtrl;
    Property ImageIEN : string read FImageIEN write FImageIEN;
    Property IsAnnotationMode: Boolean read FIsAnnotationMode write FIsAnnotationMode;
    Property isRadVisible: Boolean read FIsRadVisible write FIsRadVisible;
    Property MarkCount : Integer Read GetMarkCount;
    Property MarkCountCurrentPage: Integer Read GetMarkCount_CurrentPage;
    Property MostRecentLayer: String read FMostRecentLayer write FMostRecentLayer;
    Property OnMagAnnotationStyleChangeEvent: TMagAnnotationStyleChangeEvent Read FMagAnnotationStyleChangeEvent Write FMagAnnotationStyleChangeEvent;
    Property Page: Integer Read GetPage Write SetPage;
    Property PageCount: Integer Read GetPageCount Write SetPageCount;
    Property RADPackage : boolean read FRADPack write FRADPack;   //p122 dmmn 8/2
    Property RADDicomCol : integer read FDcmCol write FDcmCol;
    Property RADDicomRow : integer read FDcmRow write FDcmRow;
    Property RADAnnotationCount: Integer read GetRadAnnotCount;// write FRADAnnotationCount; {/ P122 JK 8/10/2011 /}
    Property Service : string read FService write FService;
    Property SessionDateTime : string read FSessionDateTime write FSessionDateTime;
    Property ToolbarIsShowing: Boolean read FToolbarIsShowing write FToolbarIsShowing;
    Property TotalLocationPageCount: Integer Read FTotalLocationPageCount Write FTotalLocationPageCount;
    Property UserCanEdit: Boolean Read GetUserCanEdit Write SetUserCanEdit;
    Property ToolbarCaption: String read FToolbarCaption write FToolbarCaption;   {/ P122 - JK 5/4/2011 /}
    Property ToolBarCoords: TPoint read FToolbarCoords write FToolbarCoords;   {/ P122 - JK 5/4/2011 /}
    Property Username : string read FUsername write Fusername;
    Property VistaRadMessage: String read FVistaRadMessage write FVistaRadMessage; {/ P122 JK 8/10/2011 /}
    Property RadInfo : TRadInfo read FRadInfo write FRadInfo;
    property HasOddRADMarks : boolean read ContainOddRadAnnotations;
    property HasOutsideAnnotations : boolean read AnnotationIsOutside;
    property HasTempAnnotations : boolean read GetTempAnnotations;
    property CurrentPageChanged : boolean read IsCurrentPageChanged;
    property SessionChanged : boolean read IsSessionChanged;
    property CaptureNewImage : boolean Read FCaptureNewImage write FCaptureNewImage;

    property IsDODImage : Boolean read FIsDODImage write FIsDODImage; //p122t15 dmmn 8/13/12 - indicate whether or not the image is from DOD
  End;

Implementation

uses
  cMagIGManager,
  ComObj,
  fmxutils;

{$R *.dfm}


var
  AnnotSessionDateTime: String;
  markTest : IIGArtXMark;
  offsetLeft : integer;
  offsetRight : integer;
  offsetTop : integer;
  offsetBottom : integer;
  RulerActualMeasured: Integer;
  RulerActualAspectRatio: IIGArtXAspectRatio;
  DicomAspectRatio : IIGArtXAspectRatio;  {/p122 dmmn 8/23 - aspect ratio used by images with measurement headers /}

  RulerMeasUnit : string;   //p122 dmmn 7/12/11
  PermissionInfo: String; {This is user information so it is probably ok to keep it global}
  ProtractorClickCount : integer; // count for protractor
  SelectedMarkArray : IIGArtXMarkArray; //p122 dmmn 7/26/11 - support for singly selected marks
  SelectedValue : string;


procedure TMagAnnot.FormCreate(Sender: TObject);
begin
  FUserCanEdit := True;
  FEditModeFalseReasonShow := False;
  tvHistory.Visible := False;
  InitializeVariables();
{$IFDEF HIDENEXTGEN}
  actEditCopySelectedAll.Visible := False;
  actEditCopySelectedFirst.Visible := False;
  actEditCopySelectedLast.Visible := False;
  actEditCutSelectedAll.Visible := False;
  actEditCutSelectedFirst.Visible := False;
  actEditCutSelectedLast.Visible := False;
    //actEditDeleteAll.Visible:=False;
  actEditDeleteFirst.Visible := False;
  actEditDeleteLast.Visible := False;
    //actEditDeleteSelectedAll.Visible:=False;
  actEditDeleteSelectedFirst.Visible := False;
  actEditDeleteSelectedLast.Visible := False;
  actEditEditMode.Visible := False;
  actEditFlipHorizontally.Visible := False;
  actEditFlipVertically.Visible := False;
  actEditPaste.Visible := True;
  actEditRotate180.Visible := False;
  actEditRotate270CCW.Visible := False;
  actEditRotate270CW.Visible := False;
  actEditRotate90CCW.Visible := False;
  actEditRotate90CW.Visible := False;
    //actEditSelectAll.Visible:=False;
  actEditUndo.Visible := False;
  actEditUndoEnable.Visible := False;
  actEditUnSelectAll.Visible := False;
  actEditUserCanEdit.Visible := False;
    //actFileClose.Visible:=False;
  actFileExportAnnotations.Visible := False;
  actFileImportXMLAnnotations.Visible := False;
    //actFileLoad.Visible:=False;
  actFileSave.Visible := False;
  actViewAntialiasingOff.Visible := False;
  actViewAntialiasingOn.Visible := False;
  actViewFitToActualSize.Visible := False;
  actViewFittoHeight.Visible := False;
  actViewFittoWidth.Visible := False;
  actViewFittoWindow.Visible := False;
    //actViewHide.Visible:=False;
  actViewZoomIn.Visible := False;
  actViewZoomOut.Visible := False;
  actViewZoomReset.Visible := False;

{$ENDIF}

  //p122 dmmn 7/26/2011 - store marks selected by the mouse click
  SelectedMarkArray := IGArtXCtl.CreateObject(IG_ARTX_OBJ_MARK_ARRAY) As IIGArtXMarkArray;

  //p122t3 dmmn 9/22
  with RadInfo do
  begin
    iIEN := '';
    radAnnotCount := 0;
    radIGmapped := 0;
    radOutside := false;
  end;
end;



procedure TMagAnnot.FormShow(Sender: TObject);
begin
  tvHistory.Visible := False;
  imgReadOnly.Visible := False;
  SetCompHorizontal;
  SetAnnotPrivileges;
  FIsAnnotationMode := True;

  btnMarkSettings.Enabled := False;     {p129 - annot info}{b1}

  {/p122t2 dmmn 9/1 - turn on tooltips /}
  IGArtXGUICtl.TooltipsVisible := False;  //p122t3 9/13 dmmn - group decided to turn off tooltips due to inaccuracy while hovering

(* all these lines commented out in 122 t 11
  //p122t11 dmmn - i don't thinkg we need to have this here since HasRadAnnotation
  //is set and cleared when loading annotation is called. It should be to reflect the correct information
  //just like what it's called
//  if RadPackage then
//    HasRADAnnotation := True
//  else
//    HasRADAnnotation := False;
*)
  {/p122t3 dmmn 9/19 - clear the status to current session when show /}
  sbStatus.Panels[0].Text := ACurrentAnnotationSession;

  {/ P122T3 DMMN 9/22/2011 /}
  RefreshAnnotInfoBar;
end;

Procedure TMagAnnot.FormClose(Sender: Tobject; Var action: TCloseAction);
var
  i: Integer;
  closeAction : TAnnotWindowCloseAction;
Begin
  {p129 gek  CaptureNewImage is a new property to determine that 'Capture' is the app.}
  if self.CaptureNewImage then
  begin
    FinalizeText;  {JK 6/26/2012 - need this in case the user added text and
                    immediately clicked to close the annotation toolbar without
                    clicking the canvas to close the text entry box.}
    magAppPublish(mpubAnnotWinHide);
    {Delete the art pages from the prior capture session if there are any.}
    magappmsg('s', '%%% ArtPageList count from this Capture session = ' + IntToStr(ArtPageList.Count));


    FIsAnnotationMode := False;  {JK 6/26/2012}
    action := caHide;  {JK 6/26/2012}
    magappmsg('s', 'TMagAnnot.FormClose CALLED'); {JK 6/26/2012}
//    hide;  {JK 6/26/2012}
    exit;
  end;
  
  {/p122t4 if the image belong to rad package then close abandon /}
  //p122t15 dmmn - also abandon if dod
  if RADPackage or IsDODImage then
  begin
    closeAction := awCloseAbandon;
    action := caHide;
    FIsAnnotationMode := false;
    FAnnotsModified := false;
    // p122t15 dmmn - put this here to remove calibrated information
    // since some RAD package image might not have measurement information
    // in the header which require manual calibration
    RulerActualMeasured := 1;
    RulerActualAspectRatio := nil;
    RulerMeasUnit := 'unit';
  end;

  {For VistARad annotations, always keep the ruler and protractor non-read only}
//  if not HasRADAnnotation then
  if not RADPackage then  //p122t4 dmmn
  begin
    {Ask if user wants to save or abandon annots if one or more have been drawn or changed }
    //p122t5 dmmn indicate the close action is initiate from formclose
    closeAction := SaveAnnotationLayer(True);   //dmmn easier to check multiple states
    if closeAction = awCancel then     // cancelled so do nothing
    begin
      action := caNone;
      FIsAnnotationMode := True;
    end
    else
    begin
      FIsAnnotationMode := False;

      {/p122t4 dmmn 9/28 - session ended so all calibration should be cleared except for DICOM/}
      {Ruler Aspect Ratio}
      RulerActualMeasured := 1;
      RulerActualAspectRatio := nil;
      RulerMeasUnit := 'unit'; //p122 dmmn 7/12/11
    end;
  end;

  {/p122t2 dmmn 9/1 - deselect all marks and turn of tooltips /}
  if action <> caNone then
  begin
    UnselectAllMarks;
    IGArtXGUICtl.TooltipsVisible := False;
  end;

  {JK 8/22/2011}
  if action <> caNone then
    FToolbarIsShowing := False
  else
  begin
    if Not FIsInHistoryView then  // if user is in history view then just leave them be
    begin
      if FAnnotsModified then  // if user has changed annotations then save it to temp
      begin
        SaveCurrentSessionToTemp;
      end;

      {/p122t2 dmmn 9/2 - if the user cancel then load temp layer /}
      LoadTempCurrentSessionLayer;
    end;
    Exit;
  end;

  {User closes the Annotation Toolbar. Restore to current session}
//  LoadCurrentSessionLayer;
//  if (closeAction = awCloseAbandon) then
  if (closeAction <> awCancel) then //p122t4
  begin
    LoadCurrentAnnotations; {/p122t2 dmmn 9/2 - since we already saved the annotations we should call the rpc and get the latest
                            rather than calling current session since the mostcurrentlayer value is not updated yet /}

    //p122t3 dmmn - if annotation is autoshown and nothing has been changed then reload the
    // state when image just opened up.
    if (frmAnnotOptionsX.AutoShowAnnots = '1') then
      ShowAllAnnotations(true)
    else
      HideAllAnnotations(true);

    FIsInHistoryView := False;
  end;
End;

Procedure TMagAnnot.FormDestroy(Sender: Tobject);
Begin
  FToolbarIsShowing := False;
  LayerList.Free;
  XMLCtl.Free;
  magappmsg('s', 'TMagAnnot.FormDestroy EXITED');
End;

procedure TMagAnnot.SetAnnotPrivileges;
begin
  {/p122t2 dmmn 9/6 - reenable delete menu if not in history view /}
  if Not FIsInHistoryView then                {p129 - annot info}{b1}
    mnuEditDelete.Enabled := True;

  {If the annotations on the image are from the RAD package (indicating VistARad as the origin,
   disable most features because it is read-only with not prior annotation history, and exit. }
   {/p122t15 - dmmn 8/13/12 - also do the same for DOD images /}
  if RadPackage or IsDODImage then
  begin
//    tbEditAnnotMarks.Enabled     := False;
//    mnuEditDelete.Enabled        := False; //p122t3 dmmn 9/15 - only disable the delete function, free select all
    {/ P122 T15 - JK 7/16/2012 - re-enable the delete function to let the user get rid of temporary annotations if desired. /}
    mnuEditDelete.Enabled        := True;
    btnLine.Enabled              := False;
    btnFreehand.Enabled          := False;
    btnRectangle.Enabled         := False;
    btnText.Enabled              := False;
    btnPolyline.Enabled          := False;
    btnCircle.Enabled            := False;
    btnArrow.Enabled             := False;
    btnHighlighter.Enabled       := False;
    btnHistory.Enabled           := False;
    btnToolSettings.Enabled      := True;
    btnMarkSettings.Enabled      := False;
    btnProtractor.Enabled        := True;
    btnRuler.Enabled             := True;
    btnImageInfo.Enabled         := True;

    mnuViewHideAll.Enabled       := True;
    mnuViewHideSelected.Enabled  := False;
    mnuViewHideUser.Enabled      := False;
    mnuViewHideSpecialty.Enabled := False;
    mnuViewHideDate.Enabled      := False;

    mnuViewShowAll.Enabled       := True;
    mnuViewHideSelected.Enabled  := False;
    mnuViewShowUser.Enabled      := False;
    mnuViewShowSpecialty.Enabled := False;
    mnuViewShowDate.Enabled      := False;

    if RadPackage then
      PermissionInfo := 'RAD Package'
    else if IsDODImage then
    begin
      //p122t15 dmmn 8/13/12 - DOD info
      PermissionInfo := 'DOD';
    end;
    imgReadOnly.Visible := True;
    EditMode := False;
    Exit;
  end
  else
  begin
    mnuViewHideAll.Enabled       := True;
    mnuViewHideSelected.Enabled  := True;
    mnuViewHideUser.Enabled      := True;
    mnuViewHideSpecialty.Enabled := True;
    mnuViewHideDate.Enabled      := True;

    mnuViewShowAll.Enabled       := True;
    mnuViewHideSelected.Enabled  := True;
    mnuViewShowUser.Enabled      := True;
    mnuViewShowSpecialty.Enabled := True;
    mnuViewShowDate.Enabled      := True;
  end;

  {Granting annotation permission is a hierarchy of checks with Master Key Permission being the highest.
   Start off with giving read/write permission. Then check kernel permissions, then check if
   a TIU or other reason from the database trumps kernel permission. Finally, give the holder
   of the MAG ANNOTATE MGR key all privileges. }
  tbEditAnnotMarks.Enabled        := True;
  mnuEditDelete.Enabled           := True;
  tbSearchAnnotationMarks.Enabled := True;
  btnLine.Enabled                 := True;
  btnFreehand.Enabled             := True;
  btnRectangle.Enabled            := True;
  btnText.Enabled                 := True;
//  btnPolyline.Enabled             := True;
  btnCircle.Enabled               := True;
  btnArrow.Enabled                := True;
  btnHighlighter.Enabled          := True;
  btnProtractor.Enabled           := True;
  btnRuler.Enabled                := True;
  btnHistory.Enabled              := True;
  btnToolSettings.Enabled         := True;
  PermissionInfo                  := 'Read/Write Permission';

//  if (GSess.HasLocalAnnotatePermission = False) and
//     (GSess.HasLocalAnnotateMasterKey = False) then

  {/ P122 JK 10/3/2011 /}

  if (FHasAnnotatePermission = False) and          {p129 - annot info}
     (FHasMasterKey = False) then
  begin
//    tbEditAnnotMarks.Enabled := False;
    mnuEditDelete.Enabled    := False; //9/15 only disable delete, enable select all
    btnLine.Enabled          := False;
    btnFreehand.Enabled      := False;
    btnRectangle.Enabled     := False;
    btnText.Enabled          := False;
    btnPolyline.Enabled      := False;
    btnCircle.Enabled        := False;
    btnArrow.Enabled         := False;
    btnHighlighter.Enabled   := False;
    btnProtractor.Enabled    := False;
    btnRuler.Enabled         := False;
    PermissionInfo := 'Read Only Permission';
  end;

  if MagPiece(FAnnotationStatus, '^', 1) >= '10' then  {If the IMAGE STATUS is >= 10 then the image is
                                                        not annotatable (Look at TImageData definition
                                                        for Annotation Status. Garrett says VistA passes back
                                                        a reason code and description that corresponds with
                                                        TIU business rules).}
  begin
//    tbEditAnnotMarks.Enabled := False;
    mnuEditDelete.Enabled    := False; //9/15 only disable delete, enable select all
    btnLine.Enabled          := False;
    btnFreehand.Enabled      := False;
    btnRectangle.Enabled     := False;
    btnText.Enabled          := False;
    btnPolyline.Enabled      := False;
    btnCircle.Enabled        := False;
    btnArrow.Enabled         := False;
    btnHighlighter.Enabled   := False;
    btnProtractor.Enabled    := False;
    btnRuler.Enabled         := False;
    PermissionInfo := 'Read Only';
    magAppMsg('s', 'Annotation mode is read only because ' + FAnnotationStatus);
  end;

//  if GSess.HasLocalAnnotateMasterKey then
  {/ P122 JK 10/3/2011 /}
  if FHasMasterKey then
    PermissionInfo := 'Master Key Permission';

end;

Procedure TMagAnnot.actAnnot00_SELECTExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot00_SELECT);
  inTBButton := IG_ARTX_MARK_SELECT;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot06_FILLED_RECTANGLEExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot06_FILLED_RECTANGLE);
  inTBButton := IG_ARTX_MARK_FILLED_RECTANGLE;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot05_HOLLOW_RECTANGLEExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  createHighlighter := False; {/p122 dmmn 7/11/11 - art3.0 support/}
  createFill := False;

  {/P122 DMMN 6/23/2011 - Change the mark type from hollow rectangle to
  rectangle because this is the actual type that IG16 save the mark as. By
  changing it here, we can solve the problem with individual mark property /}
  SelectedButtonIsDown(actAnnot05_HOLLOW_RECTANGLE);
//  inTBButton := IG_ARTX_MARK_HOLLOW_RECTANGLE;
//  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
  IGArtXGUICtl.DefaultInterface.PressTBButton(IG_ARTX_MARK_RECTANGLE, True); // Art3.0
End;

Procedure TMagAnnot.actAnnot25_HIGHLIGHTERExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  createHighlighter := True;   //p122 art 3.0
  createFill := True;

  SelectedButtonIsDown(actAnnot25_HIGHLIGHTER);
//  inTBButton := IG_ARTX_MARK_HIGHLIGHTER;
//  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
  IGArtXGUICtl.DefaultInterface.PressTBButton(IG_ARTX_MARK_RECTANGLE, True); // ART3.0
End;

Procedure TMagAnnot.actAnnot03_LINEExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  createArrow := False; {/p122 dmmn 7/11/11 - support art 3.0 lines /}
  SelectedButtonIsDown(actAnnot03_LINE);
  inTBButton := IG_ARTX_MARK_LINE;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot07_TYPED_TEXTExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot07_TYPED_TEXT);
//  inTBButton := IG_ARTX_MARK_TYPED_TEXT;                          // art 2.0
//  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
  IGArtXGUICtl.DefaultInterface.PressTBButton(IG_ARTX_MARK_TEXT, True); // Art3.0
End;

Procedure TMagAnnot.actAnnot10_ATTACH_A_NOTEExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot10_ATTACH_A_NOTE);
  inTBButton := IG_ARTX_MARK_ATTACH_A_NOTE;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot08_TEXT_FROM_FILEExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot08_TEXT_FROM_FILE);
  inTBButton := IG_ARTX_MARK_TEXT_FROM_FILE;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot09_TEXT_STAMPExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot09_TEXT_STAMP);
  inTBButton := IG_ARTX_MARK_TEXT_STAMP;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot04_FREEHAND_LINEExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot04_FREEHAND_LINE);
  inTBButton := IG_ARTX_MARK_FREEHAND_LINE;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot17_ARROWExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  createArrow := True;    //p122 for art 3.0
  SelectedButtonIsDown(actAnnot17_ARROW);
//  inTBButton := IG_ARTX_MARK_ARROW;
//  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
  IGArtXGUICtl.DefaultInterface.PressTBButton(IG_ARTX_MARK_LINE, True); // Arrow is a special line
End;

Procedure TMagAnnot.actAnnot16_HOLLOW_ELLIPSEExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  createFill := False; //p122 dmmn 7.11.11 art 3.0
  SelectedButtonIsDown(actAnnot16_HOLLOW_ELLIPSE);
//  inTBButton := IG_ARTX_MARK_HOLLOW_ELLIPSE;
//  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
  IGArtXGUICtl.DefaultInterface.PressTBButton(IG_ARTX_MARK_ELLIPSE, True);  // Art3.0
End;

Procedure TMagAnnot.actAnnot15_FILLED_ELLIPSEExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot15_FILLED_ELLIPSE);
  inTBButton := IG_ARTX_MARK_FILLED_ELLIPSE;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot18_HOTSPOTExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot18_HOTSPOT);
  inTBButton := IG_ARTX_MARK_HOTSPOT;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot12_HOLLOW_POLYGONExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot12_HOLLOW_POLYGON);
  inTBButton := IG_ARTX_MARK_HOLLOW_POLYGON;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot11_FILLED_POLYGONExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot11_FILLED_POLYGON);
  inTBButton := IG_ARTX_MARK_FILLED_POLYGON;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot13_POLYLINEExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot13_POLYLINE);
  inTBButton := IG_ARTX_MARK_POLYLINE;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot19_REDACTIONExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot19_REDACTION);
  inTBButton := IG_ARTX_MARK_REDACTION;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot14_AUDIOExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot14_AUDIO);
  inTBButton := IG_ARTX_MARK_AUDIO;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot24_PIN_UP_TEXTExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot24_PIN_UP_TEXT);
  inTBButton := IG_ARTX_MARK_PIN_UP_TEXT;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot01_IMAGE_EMBEDDEDExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot01_IMAGE_EMBEDDED);
  inTBButton := IG_ARTX_MARK_IMAGE_EMBEDDED;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot02_IMAGE_REFERENCEExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot02_IMAGE_REFERENCE);
  inTBButton := IG_ARTX_MARK_IMAGE_REFERENCE;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot23_BUTTONExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot23_BUTTON);
  inTBButton := IG_ARTX_MARK_BUTTON;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot20_ENCRYPTIONExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot20_ENCRYPTION);
  inTBButton := IG_ARTX_MARK_ENCRYPTION;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot21_RULERExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot21_RULER);
  inTBButton := IG_ARTX_MARK_RULER;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot22_PROTRACTORExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  //p122 dmmn 7/28/11 - add count for protractor tool
  ProtractorClickCount := 0;
  SelectedButtonIsDown(actAnnot22_PROTRACTOR);
  inTBButton := IG_ARTX_MARK_PROTRACTOR;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot26_RICH_TEXTExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot26_RICH_TEXT);
  inTBButton := IG_ARTX_MARK_RICH_TEXT;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot27_CALLOUTExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot27_CALLOUT);
  inTBButton := IG_ARTX_MARK_CALLOUT;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot28_RECTANGLEExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot28_RECTANGLE);
  inTBButton := IG_ARTX_MARK_RECTANGLE;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot29_ELLIPSEExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot29_ELLIPSE);
  inTBButton := IG_ARTX_MARK_ELLIPSE;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot30_POLYGONExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot30_POLYGON);
  inTBButton := IG_ARTX_MARK_POLYGON;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot31_TEXTExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot31_TEXT);
  inTBButton := IG_ARTX_MARK_TEXT;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot32_IMAGEExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot32_IMAGE);
  inTBButton := IG_ARTX_MARK_IMAGE;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot60_OptionsExecute(Sender: Tobject);
Begin
  SelectedButtonIsDown(actAnnot60_Options);
  If IsValidEnv() Then
  Begin
    frmAnnotOptionsX.ShowModal(); //p122 dmmn 7/9/11 - new global settings
    actAnnot00_SELECTExecute(Sender);
  End;
End;

procedure TMagAnnot.actAuditHistoryExecute(Sender: TObject);
begin
  tvHistory.Visible := not tvHistory.Visible;
  SetCompHorizontal;
end;

Procedure TMagAnnot.UncheckAllAnnots;
Begin
  FProtractorState := -1;
  actAnnot00_SELECT.Checked := False;
  actAnnot01_IMAGE_EMBEDDED.Checked := False;
  actAnnot02_IMAGE_REFERENCE.Checked := False;
  actAnnot03_LINE.Checked := False;
  actAnnot04_FREEHAND_LINE.Checked := False;
  actAnnot05_HOLLOW_RECTANGLE.Checked := False;
  actAnnot06_FILLED_RECTANGLE.Checked := False;
  actAnnot07_TYPED_TEXT.Checked := False;
  actAnnot08_TEXT_FROM_FILE.Checked := False;
  actAnnot09_TEXT_STAMP.Checked := False;
  actAnnot10_ATTACH_A_NOTE.Checked := False;
  actAnnot11_FILLED_POLYGON.Checked := False;
  actAnnot12_HOLLOW_POLYGON.Checked := False;
  actAnnot13_POLYLINE.Checked := False;
  actAnnot14_AUDIO.Checked := False;
  actAnnot15_FILLED_ELLIPSE.Checked := False;
  actAnnot16_HOLLOW_ELLIPSE.Checked := False;
  actAnnot17_ARROW.Checked := False;
  actAnnot18_HOTSPOT.Checked := False;
  actAnnot19_REDACTION.Checked := False;
  actAnnot20_ENCRYPTION.Checked := False;
  actAnnot21_RULER.Checked := False;
  actAnnot22_PROTRACTOR.Checked := False;
  actAnnot23_BUTTON.Checked := False;
  actAnnot24_PIN_UP_TEXT.Checked := False;
  actAnnot25_HIGHLIGHTER.Checked := False;
  actAnnot26_RICH_TEXT.Checked := False;
  actAnnot27_CALLOUT.Checked := False;
  actAnnot28_RECTANGLE.Checked := False;
  actAnnot29_ELLIPSE.Checked := False;
  actAnnot30_POLYGON.Checked := False;
  actAnnot31_TEXT.Checked := False;
  actAnnot32_IMAGE.Checked := False;
  actAnnot33_HOLLOW_SQUARE.Checked := False;
  actAnnot34_FILLED_SQUARE.Checked := False;
  actAnnot35_HOLLOW_CIRCLE.Checked := False;
  actAnnot36_FILLED_CIRCLE.Checked := False;
  actAnnot60_Options.Checked := False;
End;

procedure TMagAnnot.ShowArtPage(PageNum: Integer);
begin
  {/ P122 - JK 5/5/2011 /}
  FArtPage := ArtPageList[PageNum-1].ArtPage;
  GetIGManager.IGArtXGUICtl.ArtXPage := FArtPage;
  ArtPageList[PageNum-1].ArtPage.AssociatePageDisplay(CurrentPageDisp);

  magAppMsg('s', 'TMagAnnot.ShowArtPage: ' +
                   'This AnnotComponent=[' + IntToHex(Integer(Pointer(Self)),0) +
                   '] ArtPage (in ArtPageList at index ' + IntToStr(PageNum-1) + ')=[' + IntToHex(Integer(Pointer(ArtPageList[PageNum-1].ArtPage)),0) +
                   '] CurrentPageDisp=[' + IntToHex(Integer(Pointer(CurrentPageDisp)),0) + ']');

  IGPageViewCtl.UpdateView;

  {/ P122 - JK 5/4/2011 /}
  Self.Left := FToolbarCoords.X;
  Self.Top  := FToolbarCoords.Y;
  Self.Caption := 'Annotation Toolbar';
  Self.FormStyle := fsStayOnTop;
  Self.BringToFront;
  FToolbarIsShowing := True;
  Self.Show;
end;

procedure TMagAnnot.AssociateArtPageWithImage(PageNum: Integer);
begin
  {/ P122 - JK 5/5/2011 /}
  magAppMsg('s', 'TMagAnnot.AssociateArtPageWithImage: ' +
                   'ArtPage (in ArtPageList at index ' + IntToStr(PageNum) + ')=[' +
                   IntToHex(Integer(Pointer(ArtPageList[PageNum].ArtPage)),0) +
                   '] CurrentPageDisp=[' + IntToHex(Integer(Pointer(CurrentPageDisp)),0) + ']');

  IGArtXGUICtl.ArtXPage := ArtPageList[PageNum].ArtPage;
  ArtPageList[PageNum].ArtPage.AssociatePageDisplay(CurrentPageDisp);


  IGPageViewCtl.UpdateView;
end;

procedure TMagAnnot.btnHistoryClick(Sender: TObject);
begin
  tvHistory.Visible := not tvHistory.Visible;

  if tvHistory.Visible then
  begin
    RefreshHistory;

    if tvHistory.Items.Count = 0 then
    begin
      Showmessage('There is no annotation history for this image');
      Exit;
    end;

    tvHistory.Selected := tvHistory.Items[0];
    tvHistory.HideSelection := False;
  end
  else
  begin
    if FIsInHistoryView then   // if is in history view
    begin
      if FAnnotsModified then // if there are changes to the current layer then load temp
        LoadTempCurrentSessionLayer
      else
        LoadCurrentSessionLayer;

      FIsInHistoryView := False; // reset the flag to indicate in normal current view now
    end
    else
    begin
       {P129}
      if not CaptureNewImage then  {JK 6/27/2012 - don't do this during a Capture session}
      begin
      {User closes the history treeview. Restore to current session}
      if FAnnotsModified then  // load temporary file if there's changes
      begin
        {/p122t2 dmmn 9/2 - this is a check to see if the user just toggle the history button while changing annotations /}
        SaveCurrentSessionToTemp;
        LoadTempCurrentSessionLayer;
      end
      else
        LoadCurrentSessionLayer;
      end;
    end;
  end;

  SetCompHorizontal;

  RefreshAnnotInfoBar;

  btnMarkSettings.Enabled := False;

end;

Procedure TMagAnnot.actFileExportAnnotationsExecute(Sender: Tobject);
Begin
  SaveDialog.Filter := 'XML files (*.xml)|*.xml|All files (*.*)|*.*|';
  SaveDialog.FilterIndex := 1;
  If (IsValidEnv() and SaveDialog.Execute()) Then
    ArtPageList[Page-1].ArtPage.SaveFile(SaveDialog.Filename, 1, True, IG_ARTX_SAVE_XML);
End;

Procedure TMagAnnot.actFileImportXMLAnnotationsExecute(
  Sender: Tobject);
Begin
  If (IsValidEnv() and OpenDialog.Execute) Then
  Begin
    ArtPageList[Page-1].ArtPage.LoadFile(OpenDialog.Filename, 1, False);
    ArtPageList[Page-1].ArtPage.ApplyToImage(CurrentPage);
    IGPageViewCtl.UpdateView;
  End;
End;

Procedure TMagAnnot.actEditDeleteAllExecute(Sender: Tobject);
Var
  Count: Integer;
  CurMark: IIGArtXMark;
  iter: Integer;
  MarkArray: IIGArtXMarkArray;
Begin
  iter := 0;
  MarkArray := IGArtXCtl.CreateObject(IG_ARTX_OBJ_MARK_ARRAY) As IIGArtXMarkArray;
  If (IsValidEnv()) Then
  Begin
    Count := ArtPageList[Page-1].ArtPage.MarkCount;
    MarkArray.Resize(Count);

    CurMark := ArtPageList[Page-1].ArtPage.MarkFirst;
    While (Not (CurMark = Nil)) Do
    Begin
      MarkArray.Item[iter] := CurMark;
      CurMark := ArtPageList[Page-1].ArtPage.Marknext(CurMark);
      iter := iter + 1;
    End;
    ArtPageList[Page-1].ArtPage.RemoveMarksArray(MarkArray);
    IGPageViewCtl.UpdateView;
  End;
End;

Procedure TMagAnnot.actEditDeleteFirstExecute(Sender: Tobject);
Var
  CurMark: IIGArtXMark;
Begin
  If (IsValidEnv()) Then
  Begin
    CurMark := ArtPageList[Page-1].ArtPage.MarkFirst;
    If (Not (CurMark = Nil)) Then
    Begin
      ArtPageList[Page-1].ArtPage.MarkRemove(CurMark);
      IGPageViewCtl.UpdateView;
    End;
  End;
End;

Procedure TMagAnnot.actEditDeleteLastExecute(Sender: Tobject);
Var
  CurMark: IIGArtXMark;
  PriorMark: IIGArtXMark;
Begin
  PriorMark := Nil;
  If (IsValidEnv()) Then
  Begin
    CurMark := ArtPageList[Page-1].ArtPage.MarkFirst;
    While (Not (CurMark = Nil)) Do
    Begin
      PriorMark := CurMark;
      CurMark := ArtPageList[Page-1].ArtPage.Marknext(CurMark);
      If CurMark = Nil Then
        ArtPageList[Page-1].ArtPage.MarkRemove(PriorMark);
    End;
    IGPageViewCtl.UpdateView;
  End;
End;

Procedure TMagAnnot.actEditUndoEnableExecute(Sender: Tobject);
Begin
  ArtPageList[Page-1].ArtPage.UndoEnabled := Not ArtPageList[Page-1].ArtPage.UndoEnabled;
  actEditUndoEnable.Checked := ArtPageList[Page-1].ArtPage.UndoEnabled;
  If ArtPageList[Page-1].ArtPage.UndoEnabled Then
  Begin
    actEditUndoEnable.Hint := 'Disable Undo';
    actEditUndoEnable.caption := 'Disable Undo';
  End
  Else
  Begin
    actEditUndoEnable.Hint := 'Enable Undo';
    actEditUndoEnable.caption := 'Enable Undo';
  End;
End;

Procedure TMagAnnot.actViewHideExecute(Sender: Tobject);
Var
  boVisible: Boolean;
  CurMark: IIGArtXMark;
Begin
  If actViewHide.caption = '&Hide Annotations' Then
  Begin
    actViewHide.Hint := 'Show Annotations';
    actViewHide.caption := 'S&how Annotations';
    boVisible := False;
  End
  Else
  Begin
    actViewHide.Hint := 'Hide Annotations';
    actViewHide.caption := '&Hide Annotations';
    boVisible := True;
  End;
  If (IsValidEnv()) Then
  Begin
    CurMark := ArtPageList[Page-1].ArtPage.MarkFirst;
    While (Not (CurMark = Nil)) Do
    Begin
      CurMark.Visible := boVisible;
      CurMark := ArtPageList[Page-1].ArtPage.Marknext(CurMark);
    End;
    IGPageViewCtl.UpdateView;
  End;
End;

Function TMagAnnot.RemoveAllAnnotations: Boolean;
Begin
  Result := False;
  Try
    actEditDeleteAllExecute(Nil);
    Result := True;
  Except
  End;
End;
function TMagAnnot.RemoveIllegalChar(Value: string): string;
var
  temp : string;
begin
  {/p122t11 dmmn 1/24/12 - replace illegal characters that prevent Windows to create
  new files or not allowed in XML tag attributes with underscore _ /}
  // windows \ / : * ? " < > |
  // xml & < > " '
  temp := Value;
  temp := StringReplace(temp, '\', '_',[rfReplaceAll, rfIgnoreCase]);
  temp := StringReplace(temp, '/', '_',[rfReplaceAll, rfIgnoreCase]);
  temp := StringReplace(temp, ':', '_',[rfReplaceAll, rfIgnoreCase]);
  temp := StringReplace(temp, '*', '_',[rfReplaceAll, rfIgnoreCase]);
  temp := StringReplace(temp, '?', '_',[rfReplaceAll, rfIgnoreCase]);
  temp := StringReplace(temp, '"', '_',[rfReplaceAll, rfIgnoreCase]);
  temp := StringReplace(temp, '<', '_',[rfReplaceAll, rfIgnoreCase]);
  temp := StringReplace(temp, '>', '_',[rfReplaceAll, rfIgnoreCase]);
  temp := StringReplace(temp, '|', '_',[rfReplaceAll, rfIgnoreCase]);
  temp := StringReplace(temp, '&', '_',[rfReplaceAll, rfIgnoreCase]);
  temp := StringReplace(temp, '''', '_',[rfReplaceAll, rfIgnoreCase]);

  Result := temp;
end;

Function TMagAnnot.IsValidEnv: Boolean;
Begin
  Result := IsValidEnv(CurrentPage);
End;

Function TMagAnnot.IsValidEnv(CurPage: IIGPage): Boolean;
Begin
  Result := False;
  if Page = 0 then
    Exit;
  If ArtPage = Nil Then
    Exit;
  If CurPage = Nil Then
    Exit;
  If Not CurPage.IsValid Then
    Exit;
  Result := True;
End;

Procedure TMagAnnot.actFileCloseExecute(Sender: Tobject);
Begin
  Close;
End;

Function TMagAnnot.GetLastHollowRectangleRect: IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_HOLLOW_RECTANGLE);
End;

Function TMagAnnot.GetLastAnnotRectByType(mark: enumIGArtXMarkType): IIGRectangle;
Var
  boFound: Boolean;
  CurMark: IIGArtXMark;
  igRect: IIGRectangle;
  PriorMark: IIGArtXMark;
  PriorRect: IIGArtXMark;
Begin
  boFound := False;
  igRect := IGCoreCtl.CreateObject(IG_OBJ_RECTANGLE) As IIGRectangle;
  igRect.Left := -1;
  igRect.Top := -1;
  igRect.Width := 0;
  igRect.Height := 0;
  Result := igRect;
  PriorMark := Nil;
  PriorRect := Nil;
  If IsValidEnv() Then
  Begin
    CurMark := ArtPageList[Page-1].ArtPage.MarkFirst;
    While (Not (CurMark = Nil)) Do
    Begin
      PriorMark := CurMark;
      If PriorMark.Type_ = mark Then
      Begin
        PriorRect := PriorMark;
        boFound := True;
      End;
      CurMark := ArtPageList[Page-1].ArtPage.Marknext(CurMark);
      If CurMark = Nil Then
      Begin
        If boFound Then
        Begin
          Result := PriorRect.GetBounds;
        End;
      End;
    End;
  End;
End;

Function TMagAnnot.DeleteLastAnnotByType(mark: enumIGArtXMarkType): Boolean;
Var
  CurMark: IIGArtXMark;
  PriorMark: IIGArtXMark;
  PriorRect: IIGArtXMark;
Begin
  Result := False;
  PriorMark := Nil;
  PriorRect := Nil;
  If IsValidEnv() Then
  Begin
    CurMark := ArtPageList[Page-1].ArtPage.MarkFirst;
    While (Not (CurMark = Nil)) Do
    Begin
      PriorMark := CurMark;
      If PriorMark.Type_ = mark Then
      Begin
        PriorRect := PriorMark;
      End;
      CurMark := ArtPageList[Page-1].ArtPage.Marknext(CurMark);
      If CurMark = Nil Then
      Begin
        If PriorRect <> Nil Then
        Begin
          ArtPageList[Page-1].ArtPage.MarkRemove(PriorRect);
          Result := True;
        End;
      End;
    End;
    IGPageViewCtl.UpdateView;
  End;
End;

Procedure TMagAnnot.actAnnot33_HOLLOW_SQUAREExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot33_HOLLOW_SQUARE);
  inTBButton := IG_ARTX_MARK_RECTANGLE;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot34_FILLED_SQUAREExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot34_FILLED_SQUARE);
  inTBButton := IG_ARTX_MARK_RECTANGLE;
  //inTBButton := IG_ARTX_MARK_FILLED_RECTANGLE;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot35_HOLLOW_CIRCLEExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot35_HOLLOW_CIRCLE);
  inTBButton := IG_ARTX_MARK_ELLIPSE;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot36_FILLED_CIRCLEExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot36_FILLED_CIRCLE);
  inTBButton := IG_ARTX_MARK_ELLIPSE;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Function TMagAnnot.CreateHollowSquare(IGRect: IIGRectangle; Border: IIGArtXBorder; bHighlight: WordBool): IIGArtXHollowRectangle;
Var
  igMark: IGArtXHollowRectangle;
Begin
  Result := Nil;
  Try
    IGRect.Height := igRect.Width;
    igMark := IGArtXCtl.CreateHollowRectangle(IGRect, Border, bHighlight);
    ArtPageList[Page-1].ArtPage.AddMark(igMark, IG_ARTX_COORD_IMAGE);
    IGPageViewCtl.UpdateView;
    Result := igMark;
  Finally
  End;
End;

Function TMagAnnot.GetLastHollowEllipseRect: IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_HOLLOW_ELLIPSE);
End;

Function TMagAnnot.CreateHollowCircle(IGRect: IIGRectangle; Border: IIGArtXBorder; bHighlight: WordBool): IIGArtXHollowEllipse;
Var
  igMark: IIGArtXHollowEllipse; //<<<<<<<<<<<
  Center: TPoint;
  Radius: Integer;
Begin
  Result := Nil;
  Try
    Center.x := ((IGRect.Right - IGRect.Left) Div 2) + IGRect.Left;
    Center.y := ((IGRect.Bottom - IGRect.Top) Div 2) + IGRect.Top;
    If IGRect.Height > igRect.Width Then
    Begin
      Radius := IGRect.Height Div 2;
    End
    Else
    Begin
      Radius := IGRect.Width Div 2;
    End;
    IGRect.Left := Center.x - Radius;
    IGRect.Right := Center.x + Radius;
    IGRect.Top := Center.y - Radius;
    IGRect.Bottom := Center.y + Radius;
    igMark := IGArtXCtl.CreateHollowEllipse(IGRect, Border, bHighlight); //<<<<<<<<<<<
    ArtPageList[Page-1].ArtPage.AddMark(igMark, IG_ARTX_COORD_IMAGE);
    IGPageViewCtl.UpdateView;
    Result := igMark;
  Finally
  End;
End;

Function TMagAnnot.GetLastArrowRect(): IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_ARROW);
End;

Function TMagAnnot.GetLastAudioRect(): IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_AUDIO);
End;

Function TMagAnnot.GetLastButtonRect(): IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_BUTTON);
End;

Function TMagAnnot.GetLastEllipseRect(): IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_ELLIPSE);
End;

Function TMagAnnot.GetLastFilledEllipseRect(): IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_FILLED_ELLIPSE);
End;

Function TMagAnnot.GetLastFilledPolygonRect(): IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_FILLED_POLYGON);
End;

Function TMagAnnot.GetLastFilledRectangleRect(): IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_FILLED_RECTANGLE);
End;

Function TMagAnnot.GetLastFreelineRect(): IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_FREEHAND_LINE);
End;

Function TMagAnnot.GetLastHighlighterRect(): IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_HIGHLIGHTER);
End;

Function TMagAnnot.GetLastHollowPolygonRect(): IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_HOLLOW_POLYGON);
End;

Function TMagAnnot.GetLastHotSpotRect(): IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_HOTSPOT);
End;

Function TMagAnnot.GetLastImageRect(): IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_IMAGE);
End;

Function TMagAnnot.GetLastImageEmbRect(): IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_IMAGE_EMBEDDED);
End;

Function TMagAnnot.GetLastImageRefRect(): IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_IMAGE_REFERENCE);
End;

Function TMagAnnot.GetLastLineRect(): IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_LINE);
End;

Function TMagAnnot.GetLastPolygonRect(): IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_POLYGON);
End;

Function TMagAnnot.GetLastPolylineRect(): IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_POLYLINE);
End;

Function TMagAnnot.GetLastProtractorRect(): IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_PROTRACTOR);
End;

Function TMagAnnot.GetLastRectangleRect(): IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_RECTANGLE);
End;

Function TMagAnnot.GetLastRedactionRect(): IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_REDACTION);
End;

Function TMagAnnot.GetLastRulerRect(): IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_RULER);
End;

Function TMagAnnot.GetLastTextRect(): IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_TEXT);
End;

Function TMagAnnot.GetLastTextFromFileRect(): IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_TEXT_FROM_FILE);
End;

Function TMagAnnot.GetLastTextNoteRect(): IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_ATTACH_A_NOTE);
End;

Function TMagAnnot.GetLastTextPinUpRect(): IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_PIN_UP_TEXT);
End;

Function TMagAnnot.GetLastTextStampRect(): IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_TEXT_STAMP);
End;

Function TMagAnnot.GetLastTextTypedRect(): IIGRectangle;
Begin
  Result := GetLastAnnotRectByType(IG_ARTX_MARK_TYPED_TEXT);
End;

Function TMagAnnot.DeleteLastHollowEllipse(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_HOLLOW_ELLIPSE);
End;

Function TMagAnnot.DeleteLastHollowRectangle: Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_HOLLOW_RECTANGLE);
End;

Function TMagAnnot.DeleteLastArrow(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_ARROW);
End;

Function TMagAnnot.DeleteLastAudio(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_AUDIO);
End;

Function TMagAnnot.DeleteLastButton(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_BUTTON);
End;

Function TMagAnnot.DeleteLastEllipse(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_ELLIPSE);
End;

Function TMagAnnot.DeleteLastFilledEllipse(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_FILLED_ELLIPSE);
End;

Function TMagAnnot.DeleteLastFilledPolygon(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_FILLED_POLYGON);
End;

Function TMagAnnot.DeleteLastFilledRectangle(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_FILLED_RECTANGLE);
End;

Function TMagAnnot.DeleteLastFreeline(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_FREEHAND_LINE);
End;

Function TMagAnnot.DeleteLastHighlighter(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_HIGHLIGHTER);
End;

Function TMagAnnot.DeleteLastHollowPolygon(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_HOLLOW_POLYGON);
End;

Function TMagAnnot.DeleteLastHotSpot(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_HOTSPOT);
End;

Function TMagAnnot.DeleteLastImage(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_IMAGE);
End;

Function TMagAnnot.DeleteLastImageEmb(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_IMAGE_EMBEDDED);
End;

Function TMagAnnot.DeleteLastImageRef(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_IMAGE_REFERENCE);
End;

Function TMagAnnot.DeleteLastLine(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_LINE);
End;

Function TMagAnnot.DeleteLastPolygon(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_POLYGON);
End;

Function TMagAnnot.DeleteLastPolyline(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_POLYLINE);
End;

Function TMagAnnot.DeleteLastProtractor(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_PROTRACTOR);
End;

Function TMagAnnot.DeleteLastRectangle(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_RECTANGLE);
End;

Function TMagAnnot.DeleteLastRedaction(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_REDACTION);
End;

Function TMagAnnot.DeleteLastRuler(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_RULER);
End;

Function TMagAnnot.DeleteLastText(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_TEXT);
End;

Function TMagAnnot.DeleteLastTextFromFile(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_TEXT_FROM_FILE);
End;

Function TMagAnnot.DeleteLastTextNote(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_ATTACH_A_NOTE);
End;

Function TMagAnnot.DeleteLastTextPinUp(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_PIN_UP_TEXT);
End;

Function TMagAnnot.DeleteLastTextStamp(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_TEXT_STAMP);
End;

Function TMagAnnot.DeleteLastTextTyped(): Boolean;
Begin
  Result := DeleteLastAnnotByType(IG_ARTX_MARK_TYPED_TEXT);
End;

destructor TMagAnnot.Destroy;
var
  i: Integer;
begin
  if FArtPageList <> nil then
  begin
    for i := 0 to FArtPageList.Count - 1 do
      FArtPageList[i].ArtPage := nil;
    FreeAndNil(FArtPageList);
  end;
  magappmsg('s', 'TMagAnnot.Destroy CALLED'); {JK 6/26/2012}
  inherited;
end;

Function TMagAnnot.CreateFilledSquare(IGRect: IIGRectangle; FillColor: IIGPixel; bHighlight: WordBool): IIGArtXFilledRectangle;
Var
  igMark: IIGArtXFilledRectangle; //<<<<<<<<<<<
Begin
  Result := Nil;
  Try
    IGRect.Height := igRect.Width;
    igMark := IGArtXCtl.CreateFilledRectangle(IGRect, FillColor, bHighlight); //<<<<<<<<<<<
    ArtPageList[Page-1].ArtPage.AddMark(igMark, IG_ARTX_COORD_IMAGE);
    IGPageViewCtl.UpdateView;
    Result := igMark;
  Finally
  End;
End;

Procedure TMagAnnot.ReplaceLastFilledRectangleWithFilledSquare();
Var
  igColor: IGPixel;
  igRect: IIGRectangle;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
Begin
  igRect := GetLastFilledRectangleRect(); //<<<<<<<<<<<
  If igRect.Width = 0 Then Exit;
  igColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  igColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(frmAnnotOptionsX.AnnotFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  igColor.RGB_R := RGB_R;
  igColor.RGB_G := RGB_G;
  igColor.RGB_B := RGB_B;
  DeleteLastFilledRectangle(); //<<<<<<<<<<<
  CreateFilledSquare(IGRect, igColor, frmAnnotOptionsX.HighlightLine); //<<<<<<<<<<<
  actAnnot00_SELECTExecute(Nil);
End;

Procedure TMagAnnot.ReplaceLastRectangleWithSquare(Filled: Boolean);
Var
  IGBorder: IGArtXBorder;
  IGBorderColor: IGPixel;
  IGFillColor: IGPixel;
  igRect: IIGRectangle;
  inBorderColor: Integer;
  inFillColor: Integer;
  inLineWidth: Integer;
  inOpacity: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
Begin
  igRect := GetLastRectangleRect(); //<<<<<<<<<<<
  If igRect.Width = 0 Then Exit;
  inOpacity := frmAnnotOptionsX.Opacity;
  inLineWidth := frmAnnotOptionsX.LineWidth;

  //FillColor
  inFillColor := frmAnnotOptionsX.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := frmAnnotOptionsX.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;

  DeleteLastRectangle(); //<<<<<<<<<<<
  If Not Filled Then IGFillColor := Nil;
  CreateSquare(IGRect, IGFillColor, IGBorder, inOpacity); //<<<<<<<<<<<
  actAnnot00_SELECTExecute(Nil);
End;

Function TMagAnnot.CreateSquare(IGRect: IIGRectangle; FillColor: IIGPixel; Border: IIGArtXBorder; Opacity: Integer): IIGArtXRectangle;
Var
  igMark: IIGArtXRectangle; //<<<<<<<<<<<
Begin
  Result := Nil;
  Try
    IGRect.Height := igRect.Width;
    igMark := IGArtXCtl.CreateRectangle(IGRect, FillColor, Border, Opacity); //<<<<<<<<<<<
    ArtPageList[Page-1].ArtPage.AddMark(igMark, IG_ARTX_COORD_IMAGE);
    IGPageViewCtl.UpdateView;
    Result := igMark;
  Finally
  End;
End;

Function TMagAnnot.CreateCircle(IGRect: IIGRectangle; FillColor: IIGPixel; Border: IIGArtXBorder; Opacity: Integer): IIGArtXEllipse;
Var
  igMark: IIGArtXEllipse; //<<<<<<<<<<<
  Center: TPoint;
  Radius: Integer;
Begin
  Result := Nil;
  Try
    Center.x := ((IGRect.Right - IGRect.Left) Div 2) + IGRect.Left;
    Center.y := ((IGRect.Bottom - IGRect.Top) Div 2) + IGRect.Top;
    If IGRect.Height > igRect.Width Then
    Begin
      Radius := IGRect.Height Div 2;
    End
    Else
    Begin
      Radius := IGRect.Width Div 2;
    End;
    IGRect.Left := Center.x - Radius;
    IGRect.Right := Center.x + Radius;
    IGRect.Top := Center.y - Radius;
    IGRect.Bottom := Center.y + Radius;
    igMark := IGArtXCtl.CreateEllipse(IGRect, FillColor, Border, Opacity); //<<<<<<<<<<<
    ArtPageList[Page-1].ArtPage.AddMark(igMark, IG_ARTX_COORD_IMAGE);
    IGPageViewCtl.UpdateView;
    Result := igMark;
  Finally
  End;
End;

Procedure TMagAnnot.ReplaceLastEllipseWithCircle(Filled: Boolean);
Var
  IGBorder: IGArtXBorder;
  IGBorderColor: IGPixel;
  IGFillColor: IGPixel;
  igRect: IIGRectangle;
  inBorderColor: Integer;
  inFillColor: Integer;
  inLineWidth: Integer;
  inOpacity: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
Begin
  igRect := GetLastEllipseRect(); //<<<<<<<<<<<
  If igRect.Width = 0 Then Exit;
  inOpacity := frmAnnotOptionsX.Opacity;
  inLineWidth := frmAnnotOptionsX.LineWidth;

  //FillColor
  inFillColor := frmAnnotOptionsX.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := frmAnnotOptionsX.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;

  DeleteLastEllipse(); //<<<<<<<<<<<

  If Not Filled Then IGFillColor := Nil;
  CreateCircle(IGRect, IGFillColor, IGBorder, inOpacity); //<<<<<<<<<<<
  actAnnot00_SELECTExecute(Nil);
End;

Function TMagAnnot.GetLastHollowEllipse(): IIGArtXHollowEllipse;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_HOLLOW_ELLIPSE) As IIGArtXHollowEllipse;
End;

Function TMagAnnot.GetLastHollowRectangle: IIGArtXHollowRectangle;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_HOLLOW_RECTANGLE) As IIGArtXHollowRectangle;
End;

Function TMagAnnot.GetLastArrow(): IIGArtXArrow;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_ARROW) As IIGArtXArrow;
End;

Function TMagAnnot.GetLastAudio(): IIGArtXAudio;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_AUDIO) As IIGArtXAudio;
End;

Function TMagAnnot.GetLastButton(): IIGArtXButton;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_BUTTON) As IIGArtXButton;
End;

Function TMagAnnot.GetLastEllipse(): IIGArtXEllipse;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_ELLIPSE) As IIGArtXEllipse;
End;

Function TMagAnnot.GetLastFilledEllipse(): IIGArtXFilledEllipse;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_FILLED_ELLIPSE) As IIGArtXFilledEllipse;
End;

Function TMagAnnot.GetLastFilledPolygon(): IIGArtXFilledPolygon;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_FILLED_POLYGON) As IIGArtXFilledPolygon;
End;

Function TMagAnnot.GetLastFilledRectangle(): IIGArtXFilledRectangle;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_FILLED_RECTANGLE) As IIGArtXFilledRectangle;
End;

Function TMagAnnot.GetLastFreeline(): IIGArtXFreeline;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_FREEHAND_LINE) As IIGArtXFreeline;
End;

Function TMagAnnot.GetLastHighlighter(): IIGArtXHighlighter;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_HIGHLIGHTER) As IIGArtXHighlighter;
End;

Function TMagAnnot.GetLastHollowPolygon(): IIGArtXHollowPolygon;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_HOLLOW_POLYGON) As IIGArtXHollowPolygon;
End;

Function TMagAnnot.GetLastHotSpot(): IIGArtXHotSpot;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_HOTSPOT) As IIGArtXHotSpot;
End;

Function TMagAnnot.GetLastImage(): IIGArtXImage;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_IMAGE) As IIGArtXImage;
End;

Function TMagAnnot.GetLastImageEmb(): IIGArtXImageEmb;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_IMAGE_EMBEDDED) As IIGArtXImageEmb;
End;

Function TMagAnnot.GetLastImageRef(): IIGArtXImageRef;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_IMAGE_REFERENCE) As IIGArtXImageRef;
End;

Function TMagAnnot.GetLastLine(): IIGArtXLine;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_LINE) As IIGArtXLine;
End;

Function TMagAnnot.GetLastPolygon(): IIGArtXPolygon;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_POLYGON) As IIGArtXPolygon;
End;

Function TMagAnnot.GetLastPolyline(): IIGArtXPolyline;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_POLYLINE) As IIGArtXPolyline;
End;

Function TMagAnnot.GetLastProtractor(): IIGArtXProtractor;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_PROTRACTOR) As IIGArtXProtractor;
End;

Function TMagAnnot.GetLastRectangle(): IIGArtXRectangle;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_RECTANGLE) As IIGArtXRectangle;
End;

Function TMagAnnot.GetLastRedaction(): IIGArtXRedaction;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_REDACTION) As IIGArtXRedaction;
End;

Function TMagAnnot.GetLastRuler(): IIGArtXRuler;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_RULER) As IIGArtXRuler;
End;

Function TMagAnnot.GetLastText(): IIGArtXText;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_TEXT) As IIGArtXText;
End;

Function TMagAnnot.GetLastTextFromFile(): IIGArtXTextFromFile;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_TEXT_FROM_FILE) As IIGArtXTextFromFile;
End;

Function TMagAnnot.GetLastTextNote(): IIGArtXTextNote;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_ATTACH_A_NOTE) As IIGArtXTextNote;
End;

Function TMagAnnot.GetLastTextPinUp(): IIGArtXPin;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_PIN_UP_TEXT) As IIGArtXPin;
End;

Function TMagAnnot.GetLastTextStamp(): IIGArtXTextStamp;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_TEXT_STAMP) As IIGArtXTextStamp;
End;

Function TMagAnnot.GetLastTextTyped(): IIGArtXTextTyped;
Begin
  Result := GetLastAnnotByType(IG_ARTX_MARK_TYPED_TEXT) As IIGArtXTextTyped;
End;

Function TMagAnnot.GetLastAnnotByType(mark: enumIGArtXMarkType): IIGArtXMark;
Var
  CurMark: IIGArtXMark;
  PriorMark: IIGArtXMark;
  PriorRect: IIGArtXMark;
Begin
  Result := Nil;
  PriorMark := Nil;
  PriorRect := Nil;
  If IsValidEnv() Then
  Begin
    CurMark := ArtPageList[Page-1].ArtPage.MarkFirst;
    While (Not (CurMark = Nil)) Do
    Begin
      PriorMark := CurMark;
      If PriorMark.Type_ = mark Then
      Begin
        PriorRect := PriorMark;
      End;
      CurMark := ArtPageList[Page-1].ArtPage.Marknext(CurMark);
      If CurMark = Nil Then
      Begin
        If PriorRect <> Nil Then
        Begin
          Result := PriorRect;
        End;
      End;
    End;
  End;
End;

Function TMagAnnot.GetIGArtXCtl: TIGArtXCtl;
Begin
  Result := GetIGManager.IGArtXCtl;
End;

Function TMagAnnot.GetIGArtXGUICtl: TIGArtXGUICtl;
Begin
  Result := GetIGManager.IGArtXGUICtl;
End;

Function TMagAnnot.GetIGCoreCtl: TIGCoreCtl;
Begin
  Result := GetIGManager.IGCoreCtrl;
End;

Function TMagAnnot.GetIGDisplayCtl: TIGDisplayCtl;
Begin
  Result := GetIGManager.IGDisplayCtrl;
End;

Function TMagAnnot.GetIGDlgsCtl: TIGDlgsCtl;
Begin
  Result := GetIGManager.IGDlgsCtl;
End;

Function TMagAnnot.GetIGFormatsCtl: TIGFormatsCtl;
Begin
  Result := GetIGManager.IGFormatsCtrl;
End;

Function TMagAnnot.GetIGGUIDlgCtl: TIGGUIDlgCtl;
Begin
  Result := GetIGManager.IGGUIDlgCtl;
End;

Function TMagAnnot.GetIGProcessingCtrl: TIGProcessingCtl;
Begin
  Result := GetIGManager.IGProcessingCtrl;
End;

Procedure TMagAnnot.actEditEditModeExecute(Sender: Tobject);
Begin
  EditMode := Not EditMode;
  actEditEditMode.Checked := EditMode;
End;

Procedure TMagAnnot.InitButtonCaptions();
Var
  i: Integer;
Begin
  For i := 0 To High(Buttons) Do
    Buttons[i].caption := '';
End;

Procedure TMagAnnot.InitButtonsArray;
Begin
//  Buttons[0] := btnAnnot00_SELECT;
//  Buttons[1] := btnAnnot01_IMAGE_EMBEDDED;
//  Buttons[2] := btnAnnot02_IMAGE_REFERENCE;
//  Buttons[3] := btnAnnot03_LINE;
//  Buttons[4] := btnAnnot04_FREEHAND_LINE;
//  Buttons[5] := btnAnnot05_HOLLOW_RECTANGLE;
//  Buttons[6] := btnAnnot06_FILLED_RECTANGLE;
//  Buttons[7] := btnAnnot07_TYPED_TEXT;
//  Buttons[8] := btnAnnot08_TEXT_FROM_FILE;
//  Buttons[9] := btnAnnot09_TEXT_STAMP;
//  Buttons[10] := btnAnnot10_ATTACH_A_NOTE;
//  Buttons[11] := btnAnnot11_FILLED_POLYGON;
//  Buttons[12] := btnAnnot12_HOLLOW_POLYGON;
//  Buttons[13] := btnAnnot13_POLYLINE;
//  Buttons[14] := btnAnnot14_AUDIO;
//  Buttons[15] := btnAnnot15_FILLED_ELLIPSE;
//  Buttons[16] := btnAnnot16_HOLLOW_ELLIPSE;
//  Buttons[17] := btnAnnot17_ARROW;
//  Buttons[18] := btnAnnot18_HOTSPOT;
//  Buttons[19] := btnAnnot19_REDACTION;
//  Buttons[20] := btnAnnot20_ENCRYPTION;
//  Buttons[21] := btnAnnot21_RULER;
//  Buttons[22] := btnAnnot22_PROTRACTOR;
//  Buttons[23] := btnAnnot23_BUTTON;
//  Buttons[24] := btnAnnot24_PIN_UP_TEXT;
//  Buttons[25] := btnAnnot25_HIGHLIGHTER;
//  Buttons[26] := btnAnnot26_RICH_TEXT;
//  Buttons[27] := btnAnnot27_CALLOUT;
//  Buttons[28] := btnAnnot28_RECTANGLE;
//  Buttons[29] := btnAnnot29_ELLIPSE;
//  Buttons[30] := btnAnnot30_POLYGON;
//  Buttons[31] := btnAnnot31_TEXT;
//  Buttons[32] := btnAnnot32_IMAGE;
//  Buttons[33] := btnAnnot33_HOLLOW_SQUARE;
//  Buttons[34] := btnAnnot34_FILLED_SQUARE;
//  Buttons[35] := btnAnnot35_HOLLOW_CIRCLE;
//  Buttons[36] := btnAnnot36_FILLED_CIRCLE;
//  Buttons[37] := btnAnnot60_Options;
End;

procedure TMagAnnot.UpdateAnnotSessionInfo(ImageIEN: String; PageCount: Integer; DUZUserName,
  Service: String; Resulted: String; DUZ, SiteNum: String; ServerName: String; ServerPort: Integer);
var
  i : integer;
begin
  if XMLCtl <> nil then          {p129 - annot info}    {b3}
  begin
    FImageIEN := ImageIEN;
    FPageCount := PageCount;
    Username := RemoveIllegalChar(DUZUserName);    //p122t11
    Service := RemoveIllegalChar(Service);         //p122t11
    FServerName := ServerName;
    FServerPort := ServerPort;
    ConsultResulted := Resulted;
    FDUZ := DUZ;  //p122t4
    FSiteNum := SiteNum;  //p122t4
    XMLCtl.InitSessionInfo(PageCount, ImageIEN, Username, Service, ConsultResulted, DUZ, SiteNum);
  end;

  //p129t19 dmmn - update permission
  FHasAnnotatePermission := False;       {p129 - annot info}{b1}
  FHasMasterKey          := False;
  for i := 0 to GSess.SiteAnnotationInfo.Count - 1 do
  begin
    if MagPiece(GSess.SiteAnnotationInfo[i], '~', 3) = ServerName + ':' + IntToStr(ServerPort) then
    begin
      if MagPiece(GSess.SiteAnnotationInfo[i], '~', 4) = 'Y' then
        FHasAnnotatePermission := True;
      if MagPiece(GSess.SiteAnnotationInfo[i], '~', 5) = 'Y' then
        FHasMasterKey := True;
      Break;
    end;
  end;
end;

procedure TMagAnnot.InitAnnotSession(ImageIEN: String; PageCount: Integer; DUZUserName,
  Service: String; Resulted: String; DUZ, SiteNum: String; ServerName: String; ServerPort: Integer;
  RadiologyReset: Boolean = False);
var
  i: Integer;
begin             {p129 - annot info}
  magAppMsg('s', 'TMagAnnot.InitAnnotSession: Owner=[' + IntToHex(Integer(Pointer(Self.Owner)),0) + '] This AnnotComponent=[ ' +
    IntToHex(Integer(Pointer(Self)),0) + '] ImageIEN=[' + ImageIEN +
    '] PageCount=[' + IntToStr(PageCount) + '] DUZUserName=[' + DUZUserName + '] Service=[' + Service + '] Resulted=[' + Resulted +
    '] DUZ=[' + DUZ + '] SiteNum=[' + SiteNum + '] ServerName=[' + ServerName + '] ServerPort=[' + IntToStr(ServerPort) + '] RadiologyReset=[' +
    MagBoolToStr(RadiologyReset) + ']');

  FImageIEN       := ImageIEN;          {p129 - annot info} {b3}
  FPageCount      := PageCount;
  Username        := RemoveIllegalChar(DUZUserName); //p122t11
  Self.Service    := RemoveIllegalChar(Service);   //p122 dmmn 7/28 - same name
  FServerName     := ServerName;
  FServerPort     := ServerPort;
  ConsultResulted := Resulted;
   {p129 - annot info}
  {/ P122 - JK 10/3/2011 - Get permissions from the session object to be used for the image in use. /}
  FHasAnnotatePermission := False;       {p129 - annot info}{b1}
  FHasMasterKey          := False;
  for i := 0 to GSess.SiteAnnotationInfo.Count - 1 do
  begin
    if MagPiece(GSess.SiteAnnotationInfo[i], '~', 3) = ServerName + ':' + IntToStr(ServerPort) then
    begin
      if MagPiece(GSess.SiteAnnotationInfo[i], '~', 4) = 'Y' then
        FHasAnnotatePermission := True;
      if MagPiece(GSess.SiteAnnotationInfo[i], '~', 5) = 'Y' then
        FHasMasterKey := True;
      Break;
    end;
  end;

  {/ P122 - DMMN /}
  FDUZ := DUZ;               {p129 - annot info}{b1}
  FSiteNum := SiteNum;

  XMLCtl.InitSessionInfo(PageCount, ImageIEN, Username, Service, ConsultResulted, DUZ, SiteNum);

  XMLCtl.CreateCurrentHistory(RadiologyReset);

  FAnnotSessionInitialized := True;

  //9/13 - disable tooltips
  IGArtXGUICtl.TooltipsVisible := False; //p122 dmmn 7/26/11 - enable/disable showing tooltips for annotations

  FIsInHistoryView := False; //p122t2 dmmn 9/1/11 - current view is latest
  FOldAnnotsDeleted := False;
end;

Procedure TMagAnnot.InitButtonAlignLeft;
Var
  i: Integer;
Begin
//  For i := 0 To High(Buttons) Do
//    Buttons[i].Align := alLeft;
End;

Procedure TMagAnnot.InitButtonVisibility;
Begin
  actAnnot01_IMAGE_EMBEDDED.Visible := (Annot01_IMAGE_EMBEDDED In AdditionalAnnotations);
  actAnnot02_IMAGE_REFERENCE.Visible := (Annot02_IMAGE_REFERENCE In AdditionalAnnotations);
  actAnnot06_FILLED_RECTANGLE.Visible := (Annot06_FILLED_RECTANGLE In AdditionalAnnotations);
  actAnnot08_TEXT_FROM_FILE.Visible := (Annot08_TEXT_FROM_FILE In AdditionalAnnotations);
  actAnnot09_TEXT_STAMP.Visible := (Annot09_TEXT_STAMP In AdditionalAnnotations);
  actAnnot10_ATTACH_A_NOTE.Visible := (Annot10_ATTACH_A_NOTE In AdditionalAnnotations);
  actAnnot11_FILLED_POLYGON.Visible := (Annot11_FILLED_POLYGON In AdditionalAnnotations);
  actAnnot12_HOLLOW_POLYGON.Visible := (Annot12_HOLLOW_POLYGON In AdditionalAnnotations);
  actAnnot14_AUDIO.Visible := (Annot14_AUDIO In AdditionalAnnotations);
  actAnnot15_FILLED_ELLIPSE.Visible := (Annot15_FILLED_ELLIPSE In AdditionalAnnotations);
  actAnnot18_HOTSPOT.Visible := (Annot18_HOTSPOT In AdditionalAnnotations);
  actAnnot19_REDACTION.Visible := (Annot19_REDACTION In AdditionalAnnotations);
  actAnnot20_ENCRYPTION.Visible := (Annot20_ENCRYPTION In AdditionalAnnotations);
//  actAnnot21_RULER.Visible := (Annot21_RULER In AdditionalAnnotations);   {/ P122 - JK 5/9/2011 - Removed /}
//  actAnnot22_PROTRACTOR.Visible := (Annot22_PROTRACTOR In AdditionalAnnotations);  {/ P122 - JK 5/9/2011 - Removed /}
  actAnnot23_BUTTON.Visible := (Annot23_BUTTON In AdditionalAnnotations);
  actAnnot24_PIN_UP_TEXT.Visible := (Annot24_PIN_UP_TEXT In AdditionalAnnotations);
//  actAnnot25_HIGHLIGHTER.Visible := (Annot25_HIGHLIGHTER In AdditionalAnnotations);  {/ P122 - JK 5/9/2011 - Removed /}
  actAnnot26_RICH_TEXT.Visible := (Annot26_RICH_TEXT In AdditionalAnnotations);
  actAnnot27_CALLOUT.Visible := (Annot27_CALLOUT In AdditionalAnnotations);
  actAnnot28_RECTANGLE.Visible := (Annot28_RECTANGLE In AdditionalAnnotations);
  actAnnot29_ELLIPSE.Visible := (Annot29_ELLIPSE In AdditionalAnnotations);
  actAnnot30_POLYGON.Visible := (Annot30_POLYGON In AdditionalAnnotations);
  actAnnot31_TEXT.Visible := (Annot31_TEXT In AdditionalAnnotations);
  actAnnot32_IMAGE.Visible := (Annot32_IMAGE In AdditionalAnnotations);
  actAnnot34_FILLED_SQUARE.Visible := (Annot34_FILLED_SQUARE In AdditionalAnnotations);
  actAnnot36_FILLED_CIRCLE.Visible := (Annot36_FILLED_CIRCLE In AdditionalAnnotations);
//  btnAnnot01_IMAGE_EMBEDDED.Visible := (Annot01_IMAGE_EMBEDDED In AdditionalAnnotations);
//  btnAnnot02_IMAGE_REFERENCE.Visible := (Annot02_IMAGE_REFERENCE In AdditionalAnnotations);
//  btnAnnot06_FILLED_RECTANGLE.Visible := (Annot06_FILLED_RECTANGLE In AdditionalAnnotations);
//  btnAnnot08_TEXT_FROM_FILE.Visible := (Annot08_TEXT_FROM_FILE In AdditionalAnnotations);
//  btnAnnot09_TEXT_STAMP.Visible := (Annot09_TEXT_STAMP In AdditionalAnnotations);
//  btnAnnot10_ATTACH_A_NOTE.Visible := (Annot10_ATTACH_A_NOTE In AdditionalAnnotations);
//  btnAnnot11_FILLED_POLYGON.Visible := (Annot11_FILLED_POLYGON In AdditionalAnnotations);
//  btnAnnot12_HOLLOW_POLYGON.Visible := (Annot12_HOLLOW_POLYGON In AdditionalAnnotations);
//  btnAnnot14_AUDIO.Visible := (Annot14_AUDIO In AdditionalAnnotations);
//  btnAnnot15_FILLED_ELLIPSE.Visible := (Annot15_FILLED_ELLIPSE In AdditionalAnnotations);
//  btnAnnot18_HOTSPOT.Visible := (Annot18_HOTSPOT In AdditionalAnnotations);
//  btnAnnot19_REDACTION.Visible := (Annot19_REDACTION In AdditionalAnnotations);
//  btnAnnot20_ENCRYPTION.Visible := (Annot20_ENCRYPTION In AdditionalAnnotations);
//  btnAnnot21_RULER.Visible := (Annot21_RULER In AdditionalAnnotations);  {/ P122 - JK 5/9/2011 - Removed /}
//  btnAnnot22_PROTRACTOR.Visible := (Annot22_PROTRACTOR In AdditionalAnnotations); {/ P122 - JK 5/9/2011 - Removed /}
//  btnAnnot23_BUTTON.Visible := (Annot23_BUTTON In AdditionalAnnotations);
//  btnAnnot24_PIN_UP_TEXT.Visible := (Annot24_PIN_UP_TEXT In AdditionalAnnotations);
//  btnAnnot25_HIGHLIGHTER.Visible := (Annot25_HIGHLIGHTER In AdditionalAnnotations); {/ P122 - JK 5/9/2011 - Removed /}
//  btnAnnot26_RICH_TEXT.Visible := (Annot26_RICH_TEXT In AdditionalAnnotations);
//  btnAnnot27_CALLOUT.Visible := (Annot27_CALLOUT In AdditionalAnnotations);
//  btnAnnot28_RECTANGLE.Visible := (Annot28_RECTANGLE In AdditionalAnnotations);
//  btnAnnot29_ELLIPSE.Visible := (Annot29_ELLIPSE In AdditionalAnnotations);
//  btnAnnot30_POLYGON.Visible := (Annot30_POLYGON In AdditionalAnnotations);
//  btnAnnot31_TEXT.Visible := (Annot31_TEXT In AdditionalAnnotations);
//  btnAnnot32_IMAGE.Visible := (Annot32_IMAGE In AdditionalAnnotations);
//  btnAnnot34_FILLED_SQUARE.Visible := (Annot34_FILLED_SQUARE In AdditionalAnnotations);
//  btnAnnot36_FILLED_CIRCLE.Visible := (Annot36_FILLED_CIRCLE In AdditionalAnnotations);
End;

Procedure TMagAnnot.UpdateButtonEnabling;
Var
  action: TBasicAction;
  boEditMode: Boolean;
  i: Integer;
  MenuItem: TMenuItem;
Begin
  boEditMode := EditMode;              {p129 - annot info}{b1}
  For i := 0 To High(Buttons) Do
  Begin
    If Buttons[i] <> Nil Then
    Begin
      If Buttons[i].Visible Then
      Begin
        Buttons[i].Enabled := boEditMode;
        If Buttons[i].action <> Nil Then
        Begin
          action := Buttons[i].action;
          MenuItem := GetMenuItemByAction(action);
          If MenuItem <> Nil Then
          Begin
            MenuItem.Enabled := boEditMode;
          End;
        End;
      End;
    End;
  End;
End;

Function TMagAnnot.GetMenuItemByAction(action: TBasicAction): TMenuItem;
Var
  i: Integer;
  MenuItem: TMenuItem;
Begin
  Result := Nil;
  For i := 0 To ComponentCount - 1 Do
  Begin
    If Not (Components[i] Is TMenuItem) Then Continue;
    MenuItem := (Components[i] As TMenuItem);
    If MenuItem = Nil Then Continue;
    If MenuItem.action = Nil Then Continue;
    If Not (MenuItem.action = action) Then Continue;
    Result := MenuItem;
  End;
End;

Procedure TMagAnnot.SetIGPageViewCtl(Const Value: TIGPageViewCtl);
Begin
  If FIGPageViewCtl <> Value Then
    FIGPageViewCtl := Value;

  If FIGPageViewCtl <> Nil Then
  Begin
//    FIGPageViewCtl.OnMouseDown := IGPageViewCtlMouseDown;
//    FIGPageViewCtl.OnMouseMove := IGPageViewCtlMouseMove;
//    FIGPageViewCtl.OnMouseUp := IGPageViewCtlMouseUp;
    FIGArtDrawParams.Hwnd := FIGPageViewCtl.Hwnd;
    magAppMsg('s', 'TMagAnnot.SetIGPageViewCtl handle=[' + IntToStr(FIGPageViewCtl.Hwnd) + '] This AnnotComponent=[' + IntToHex(Integer(Pointer(Self)),0) + ']');
  End;
End;

Procedure TMagAnnot.SetCurrentPageDisp(Const Value: IIGPageDisplay);
Begin
  If FCurrentPageDisp <> Value Then FCurrentPageDisp := Value;
  If FCurrentPageDisp <> Nil Then
  Begin
    FIGArtDrawParams.IGPageDisplay := FCurrentPageDisp;
    magAppMsg('s', 'TMagAnnot.SetCurrentPageDisp FCurrentPageDisplay=[' + IntToHex(Integer(Pointer(FCurrentPageDisp)),0) + '] This AnnotComponent=[' + IntToHex(Integer(Pointer(Self)),0) + ']');
  End;
End;

Function TMagAnnot.CurrentPageClear: Boolean;
Begin
  Result := False;
  Try
    If CurrentPage = Nil Then Exit;
    CurrentPage.Clear;
    Result := True;
  Except
  End;
End;

constructor TMagAnnot.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FArtPageList := TArtPageObjectList.Create(True);  {/ P122 - JK 5/27/2010 - create an object list of pages in case the document is multipaged /}

  magAppMsg('s', '%%% TMagAnnot.Create: ArtPageList created. Annot FArtPageList=[' +
                   IntToHex(Integer(Pointer(FArtPageList)),0) + '] This AnnotComponent=[' + IntToHex(Integer(Pointer(Self)),0) + ']');
  FAnnotsModified := False;

  {/ P122 - JK 6/13/2011 - used to initialize the XML interfaced object for I/O /}
  if XMLCtl = nil then
    if GSess <> nil then      {GSESS IS NIL  CHECK}
      XMLCtl := TXMLCtl.Create(GSess.AnnotationTempDir);

  FAnnotSessionInitialized := False;
end;

Function TMagAnnot.CreateArtPage: IIGArtXPage;
Begin
//  FArtPage := IGArtXCtl.CreatePage;
//  IGArtXGUICtl.ArtXPage := FArtPage;
//  Result := FArtPage;

  Result := IGArtXCtl.CreatePage;
  IGArtXGUICtl.ArtXPage := Result;
End;

Function TMagAnnot.CreateArtPage(CurrentPage_: IIGPage; CurrentPageDisp_: IIGPageDisplay): IIGArtXPage;
Begin
  Result := nil;
    if GNoAnnots then EXIT;  {p151 p161}
  CurrentPage := CurrentPage_;
  CurrentPageDisp := CurrentPageDisp_;

  Result := CreateArtPage;

  Result.Load(CurrentPage, False);

  If CurrentPageDisp <> Nil Then
  Result.UndoEnabled := True;
  Begin
   {p129  122 change to Re-Enable Smoothing, Stop setting to NONE}
 //129   CurrentPageDisp.AntiAliasing.Method := IG_DSPL_ANTIALIAS_NONE;

    Result.AssociatePageDisplay(CurrentPageDisp);

  End;
End;

{/ P122 - JK 5/27/2011 /}
procedure TMagAnnot.ConnectArtPage(PageNum: Integer; CurrentPage_: IIGPage; CurrentPageDisp_: IIGPageDisplay);
var
  skipRerotate : boolean;
begin
  if GNoAnnots then EXIT;  {p151}
  
  try
    //p122t3 dmmn 9/22 - reset vista rad message when changing page
    //p122t15 dmmn - also dod
    if RadPackage or IsDODImage then
      VistaRadMessage := '';

    //p122 dmmn 7/26 - update currnet page number of the image too
    if (Page>0) then
    begin
      if (ArtPageList[Page-1].ArtPage.MarkCount > 0) then
    UnselectAllMarks;   //p122t2 dmmn 9/6 - unselect all annotations before changing page
    end;
    //p122t3 dmmn - undo rotating here since the page will revert back to normal when returned
    if (Page > 0) then
    begin

      //p129t18 dmmn 5/16 if this is from capture, skip rerotating when changing pages
      if (Assigned(GSess)) and (GSess.IsCaptureSession) then
        skipRerotate := true
      else
        skipRerotate := false;

      if Not skipRerotate then
      begin
        while (ArtPageList[Page-1].RotatedRight > 0) do
        begin
          RotateArtPageMarks(Page,3);   // rotate left back
        end;
        while (ArtPageList[Page-1].RotatedLeft > 0) do
        begin
          RotateArtPageMarks(Page,1);   // rotate right back
        end;

        if (ArtPageList[Page-1].FlippedVer) then
        begin
          FlipArtPagemarks(Page,IG_FLIP_VERTICAL);
        end;
        if (ArtPageList[Page-1].FlippedHor) then
        begin
          FlipArtPagemarks(Page,IG_FLIP_HORIZONTAL);
        end;
      end;
    end;
    

    Page := PageNum + 1;

    CurrentPageNumber := PageNum;
    
    CurrentPage := CurrentPage_;
    CurrentPageDisp := CurrentPageDisp_;

    FArtPage := ArtPageList[PageNum].ArtPage;
    FArtPage.UndoEnabled := True;

    btnMarkSettings.Enabled := False;  {Disable the mark property tool button}

    GetIGManager.IGArtXGUICtl.ArtXPage := FArtPage;

    if CurrentPageDisp <> nil then
    begin
      //p122t12 dmmn 2/22/12   /gek Change to Re-Enable Smoothing, Stop setting to NONE
      //p122 CurrentPageDisp.AntiAliasing.Method := IG_DSPL_ANTIALIAS_NONE;
      FArtPage.AssociatePageDisplay(CurrentPageDisp);
 //      IGPageViewCtl.UpdateView;    //p122t11 dmmn - commented out because it make radviewer flicker
      magAppMsg('s', 'TMagAnnot.ConnectArtPage ArtPage=[' + IntToHex(Integer(Pointer(FArtPage)),0) +
                            ']: Connected artpage to page #' + IntToStr(Page) +
                            ' CurrentPage=[' + IntToHex(Integer(Pointer(CurrentPage)),0) + ']' +
                            ' CurrentPageDisplay=[' + IntToHex(Integer(Pointer(CurrentPageDisp)),0) + ']');
    end
    else
      magAppMsg('s', 'TMagAnnot.ConnectArtPage: Cannot connect artpage to page #' + IntToStr(Page) +
                       ' because CurrentPageDisp = NIL');

  except
    on E:Exception do
      magAppMsg('s', 'TMagAnnot.ConnectArtPage: Cannot connect artpage to page #' + IntToStr(Page) +
                       ' msg = ' + E.Message);

  end;
end;

function TMagAnnot.ContainOddRadAnnotations: boolean;
begin
  //p122t3 dmmn
  Result := false;
    if GNoAnnots then EXIT;
  try
    Result := XMLCtl.ContainsRADEllipseAndFreeHand;
  except
    on E:Exception do
      magAppMsg('s', 'TMagAnnot.ContainOddRadAnnotations: Error msg = ' + E.Message);
  end;
end;


function TMagAnnot.AnnotationIsOutside: boolean;
var
  CurMark : IIGArtXMark;
begin
  //p122t3 - check a certain page to see if there's annotation outside the image
  Result := false;
    if GNoAnnots then EXIT;
  CurMark := ArtPageList[Page-1].ArtPage.MarkFirst;
  while (CurMark <> nil) do
  begin
    if (CurMark.GetBounds.Left < 0) or
        (CurMark.GetBounds.Right > CurrentPage.ImageWidth) or
        (CurMark.GetBounds.Top < 0) or
        (CurMark.GetBounds.Bottom > CurrentPage.ImageHeight) then
    begin
      Result := True;
      Exit;
    end;
    CurMark := ArtPageList[Page-1].ArtPage.MarkNext(CurMark);
  end;
end;
procedure TMagAnnot.AnnotToolBarMouseActivate(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y, HitTest: Integer;
  var MouseActivate: TMouseActivate);
begin
  //p122t11 dmmn - finalize any unfinished text only when there's nothing selected
  //so that we don't lose the handle to the white are and cause exceptions later
  if ArtPageList[Page-1].ArtPage <> nil then
    if ArtPageList[Page-1].ArtPage.MarkSelectedFirst = nil then
      FinalizeText;
end;

function TMagAnnot.GetTempAnnotations: boolean;
begin
  Result := False;
    if GNoAnnots then EXIT;
  {/p122t5 - return true if there are temp annotation for rad images/}
  // p122t15 - or dod
  if RADPackage or IsDODImage then           // only affect rad package
  begin
    if MarkCount > 0 then
    begin
      if (MarkCount - RadInfo.radAnnotCount) > 0 then   // if there's temp marks
        Result := true
      else                        // just normal rad annotationa =]
        Result := false;
    end;
  end
  else
    Result := false;

end;
function TMagAnnot.IsCurrentPageChanged: boolean;
var
  CurMark : IIGArtXMark;
  tooltips : string;
begin
  {/p122t7 dmmn 10/28 check for changes on current page for printing messages /}
  Result := false;
    if GNoAnnots then EXIT;
  try
    // exit and return true if there's old annotation deleted
    if ArtPageList[Page-1].MarkDeleted then
    begin
      Result := True;
      Exit;
    end;

    // if nothing is deleted and there's no marks, exit
    if ArtPageList[Page-1].ArtPage.MarkCount = 0 then
    begin
      Result := false;
      Exit;
    end;

    // if nothing is deleted and there's marks modified
    Curmark := ArtPageList[Page-1].ArtPage.MarkFirst;
    while (CurMark <> nil) do
    begin
      tooltips := CurMark.Tooltip;
      if (Pos('YYYYMMDDHHMMSS', tooltips) > 0) or
         (Pos('*edited', tooltips) > 0) then
      begin
        Result := True;
        Exit;
      end;
      CurMark := ArtPageList[Page-1].ArtPage.MarkNext(CurMark);
    end;
  except
    on E:Exception do
      MagAppMsg('s', 'TMagAnnot.IsCurrentPageChanged: Error msg = ' + E.Message);
  end;
end;

function TMagAnnot.IsSessionChanged: boolean;
var
  CurMark : IIGArtXMark;
  tooltip : string;
  I: Integer;
begin
  {/p122t7 dmmn 10/31 - check to see if the current session has new or edited annotations
  should ONLY be used in TMagAnnot.SaveAnnotationLayer /}

  Result := false;
    if GNoAnnots then EXIT;
  try
    // check if there's any old marks were deleted in the session
    if FOldAnnotsDeleted then
    begin
      Result := True;
    end
    else
    begin
      // go through all the pages and check to see if there any marks
      // that are tagged with *edited or YYYMMDDHHMMSS in its tooltip.
      // if there is then session is modified.
      for I := 0 to ArtPageList.Count-1 do
      begin
        CurMark := ArtPageList[I].ArtPage.MarkFirst;
        while (CurMark <> nil) do
        begin
          tooltip := CurMark.Tooltip;
          if (Pos('YYYYMMDDHHMMSS', tooltip) > 0) or
             (Pos('*edited', tooltip) > 0) then
          begin
            Result := True;
            Exit;
          end;
          CurMark := ArtPageList[I].ArtPage.MarkNext(CurMark);
        end;
      end;
    end;
  except
    on E:Exception do
      MagAppMsg('s', 'TMagAnnot.IsSessionChanged: Error msg = ' + E.Message);
  end;  
end;

procedure TMagAnnot.UpdateTooltipToStatusBar(IGMark: IIGArtXMark);
var
  sName, sServ, sDate, sEdit : string;
  sTooltip : string;
begin
  if GNoAnnots then EXIT;
  {/p122t4 dmmn 9/27 - update the status bar on annotation toolbar with the new tooltips/}
  sName := GetViewHideFieldValue(1, ArtPageList[Page-1].ArtPage.MarkSelectedFirst.Tooltip);
  sServ := GetViewHideFieldValue(2, ArtPageList[Page-1].ArtPage.MarkSelectedFirst.Tooltip);
  sDate := FormatDatePiece(GetViewHideFieldValue(3, ArtPageList[Page-1].ArtPage.MarkSelectedFirst.Tooltip));
  sEdit := GetViewHideFieldValue(6, ArtPageList[Page-1].ArtPage.MarkSelectedFirst.Tooltip);

  sTooltip := sName + '-' + sServ; // name and service will always be there  for both current and saved marks
  if sEdit = '' then    // mark not edited
  begin
    if sDate <> '' then    // add saved date
      sTooltip := sTooltip + '-' + sDate;
  end
  else                 // mark edited
  begin
    if sDate <> '' then
      sTooltip := sTooltip + '-' + sDate; // + '-' + sEdit
  end;

  sbStatus.Panels[0].Text := sTooltip;
  sbStatus.Hint := sbStatus.Panels[0].Text
end;

Procedure TMagAnnot.FIGArtXCtlCreateMarkNotify(ASender: Tobject;Const Params: IIGArtXCreateMarkEventParams);
Begin
  IGPageViewCtl.UpdateView;
    if GNoAnnots then EXIT;

  Case Params.Mark.Type_ Of
    IG_ARTX_MARK_RULER :           //p122 7/13/11 - add post processing to ruler
      PostCreateMarkRuler(Params.Mark);
//    IG_ARTX_MARK_TEXT :
//      PostCreateMarkText(Params.Mark);
  End;

  {JK 8/15/2011}
  //p122t15 - and not dod
  if (Not RADPackage) and (Not IsDODImage) then   //p122t4 dmmn 10/3
    FAnnotsModified := True;
End;

Procedure TMagAnnot.FIGArtXCtlDeleteMarkNotify(ASender: Tobject;
  Const Params: IIGArtXDeleteMarkEventParams);
Begin
  FAnnotsModified := True;
End;

Procedure TMagAnnot.FIGArtXCtlModifyMarkNotify(ASender: Tobject;
  Const Params: IIGArtXModifyMarkEventParams);
Begin
  case Params.Mark.type_ of            //p122t1 dmmn 8/30/11 - post processing for text /}
    IG_ARTX_MARK_TEXT:
      PostCreateMarkText(Params.Mark);
    IG_ARTX_MARK_RULER:
      begin
        {/p122t3 dmmn 9/19 - if the user modified an old ruler, the ruler is considered belong to the current
        session so it should apply the current calibration if available otherwise keep it the same/}
        UpdateOldRulerCalibrationToCurrent(Params.Mark as IIGArtXRuler);
      end;
  end;

  if Not FIsInHistoryView then    // only change if not in history view
  begin
    //p122t15 and not dod
    if (Not RadPackage) and (Not IsDODImage) then    //p122t4 dmmn
      FAnnotsModified := True;
    IGPageViewCtl.UpdateView;

    //p122 dmmn 7/27/11 - update owner information for the modified mark
    EditAnnotationOwnership(Params.Mark);  //p122t2 8/31
  end;
End;

(*RCA WARNINGS
procedure TMagAnnot.CreateMarkRulerNotify(Const RulerMark: IIGArtXRuler);
begin
;
end;      *)

Procedure TMagAnnot.FIGArtXCtlPreCreateMarkNotify(ASender: Tobject;
  Const Params: IIGArtXPreCreateMarkEventParams);
Begin
  Case Params.Mark.Type_ Of
//    IG_ARTX_MARK_SELECT: Showmessage('SELECT          ');
//    IG_ARTX_MARK_IMAGE_EMBEDDED: Showmessage('IMAGE_EMBEDDED  ');
//    IG_ARTX_MARK_IMAGE_REFERENCE: Showmessage('IMAGE_REFERENCE ');
    IG_ARTX_MARK_LINE:
      PreCreateMarkLineToDefaults(Params.Mark As IIGArtXLine);
    IG_ARTX_MARK_FREEHAND_LINE:
      PreCreateMarkFreehandLineToDefaults(Params.Mark As IIGArtXFreeline);
//    IG_ARTX_MARK_HOLLOW_RECTANGLE:    // p122 art 2.0
//      PreCreateMarkHollowRectangleToDefaults(Params.Mark As IIGArtXHollowRectangle);
//    IG_ARTX_MARK_FILLED_RECTANGLE: Showmessage('FILLED_RECTANGLE');
//    IG_ARTX_MARK_TYPED_TEXT:           //p122 art 2.0
//      PreCreateMarkTextTypedToDefaults(Params.Mark As IIGArtXTextTyped);
    IG_ARTX_MARK_TEXT:              //p122 art 3.0
      PreCreateMarkTextToDefaults(Params.Mark as IIGArtXText);
//    IG_ARTX_MARK_TEXT_FROM_FILE: Showmessage('TEXT_FROM_FILE  ');
//    IG_ARTX_MARK_TEXT_STAMP: Showmessage('TEXT_STAMP      ');
//    IG_ARTX_MARK_ATTACH_A_NOTE: Showmessage('ATTACH_A_NOTE   ');
//    IG_ARTX_MARK_FILLED_POLYGON: Showmessage('FILLED_POLYGON  ');
//    IG_ARTX_MARK_HOLLOW_POLYGON: Showmessage('HOLLOW_POLYGON  ');
//    IG_ARTX_MARK_POLYLINE:        //p122 dmmn 7/25/11 - take out polyline
//      PreCreateMarkPolylineToDefaults(Params.Mark As IIGArtXPolyline);
//    IG_ARTX_MARK_AUDIO: Showmessage('AUDIO           ');
//    IG_ARTX_MARK_FILLED_ELLIPSE: Showmessage('FILLED_ELLIPSE  ');
//    IG_ARTX_MARK_HOLLOW_ELLIPSE: PreCreateMarkHollowEllipseToDefaults(Params.Mark As IIGArtXHollowEllipse);
    IG_ARTX_MARK_ARROW:
//      PreCreateMarkArrowToDefaults(Params.Mark As IIGArtXArrow);  //p122 art 2.0
      PreCreateMarkLineToDefaults(Params.Mark As IIGArtXLine);      //p122 Art3.0
//    IG_ARTX_MARK_HOTSPOT: Showmessage('HOTSPOT         ');
//    IG_ARTX_MARK_REDACTION: Showmessage('REDACTION       ');
//    IG_ARTX_MARK_ENCRYPTION: Showmessage('ENCRYPTION      ');
    IG_ARTX_MARK_RULER:
      PreCreateMarkRulerToDefaults(Params.Mark As IIGArtXRuler);
    IG_ARTX_MARK_PROTRACTOR:
      PreCreateMarkProtractorToDefaults(Params.Mark As IIGArtXProtractor);
//    IG_ARTX_MARK_BUTTON: Showmessage('BUTTON          ');
//    IG_ARTX_MARK_PIN_UP_TEXT: Showmessage('PIN_UP_TEXT     ');
    //IG_ARTX_MARK_HIGHLIGHTER: Showmessage('HIGHLIGHTER     ');  {/ P122 - JK 5/9/2011 - Removed /}
//    IG_ARTX_MARK_RICH_TEXT: PreCreateMarkRichTextToDefaults(Params.Mark As IIGArtXRichText);
//    IG_ARTX_MARK_CALLOUT: Showmessage('CALLOUT         ');
    IG_ARTX_MARK_RECTANGLE:  //p122 art 3.0
      PreCreateMarkRectangleToDefaults(Params.Mark As IIGArtXRectangle);
    IG_ARTX_MARK_ELLIPSE:    //p122 art 3.0
      PreCreateMarkEllipseToDefaults(Params.Mark As IIGArtXEllipse);
//    IG_ARTX_MARK_POLYGON: Showmessage('POLYGON         ');
//    IG_ARTX_MARK_TEXT: Showmessage('TEXT            ');
//    IG_ARTX_MARK_IMAGE: Showmessage('IMAGE           ');
  End;
End;
procedure TMagAnnot.FinalizeText;
var
  tempPoint : IIGPoint;
begin
  try
    // p122t11 - finalizing text when user clicking something else
    // skip if no annotation on current artpage
    if (ArtPageList <> nil) and (ArtPageList.Count > 0) then
    begin
      if (ArtPageList[Page-1].ArtPage.MarkCount = 0) then
        Exit;
    end;

    tempPoint := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_POINT) As IIGPoint;
    tempPoint.XPos := 0;
    tempPoint.YPos := 0;
    IGPageViewCtl.PageDisplay.ConvertPointCoordinates(IGPageViewCtl.hWnd,
                                                       0,
                                                       tempPoint,
                                                       IG_DSPL_CONV_DEVICE_TO_IMAGE);
    SetTool(MagAnnToolPointer);
    tempPoint.XPos := 0;
    tempPoint.YPos := 0;
    GetIGManager.IGArtXGUICtl.MouseDown(IGArtDrawParams,
                                        WM_LBUTTONDOWN,
                                        tempPoint);
    GetIGManager.IGArtXGUICtl.MouseUp(IGArtDrawParams,
                                        WM_LBUTTONUP,
                                        tempPoint);
  except
    on E:Exception do
      MagAppMsg('s', 'TMagAnnot.FinalizeText. Error = ' + E.Message);
  end;
end;

Procedure TMagAnnot.SetLastLineToDefaults;
Var
  IGBorder: IGArtXBorder;
  IGBorderColor: IGPixel;
  IGFillColor: IGPixel;
  IGMark: IIGArtXLine;
  inBorderColor: Integer;
  inFillColor: Integer;
  inLineWidth: Integer;
  inOpacity: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
Begin
  If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then Exit;
  IGMark := GetLastLine();
  If IGMark = Nil Then Exit;
  inOpacity := frmAnnotOptionsX.Opacity;
  inLineWidth := frmAnnotOptionsX.LineWidth;
  //FillColor
  inFillColor := frmAnnotOptionsX.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := frmAnnotOptionsX.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;

  IGMark.SetBorder(IGBorder);
  IGMark.SetHeadFillColor(IGFillColor);
  IGMark.Opacity := inOpacity;
  IGPageViewCtl.UpdateView;
  actAnnot00_SELECTExecute(Nil);
End;

Procedure TMagAnnot.PreCreateMarkLineToDefaults(IGMark: IIGArtXLine);
Var
  IGBorder: IGArtXBorder;
  IGBorderColor: IGPixel;
  IGFillColor: IGPixel;
  inLineColor: Integer;
  inFillColor: Integer;
  inLineWidth: Integer;
  inOpacity: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
  IGArrowHead : IIGArtXArrowHead;      // P122 DMMN 6/27/2011 - Add arrow head to comply with Art3.0
Begin
  If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then Exit;
  If IGMark = Nil Then Exit;

  inOpacity := frmAnnotOptionsX.Opacity;               {p129 - annot info}{b1}
  inLineWidth := frmAnnotOptionsX.LineWidth;


  //BorderColor
  inLineColor := frmAnnotOptionsX.AnnotLineColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inLineColor, RGB_R, RGB_G, RGB_B);
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;
  if ConsultResulted = '1' then            //p122 dmmn 7/11/11 - change line style if the consult is resulted
    IGBorder.Style := IG_ARTX_PEN_DASH;

  IGMark.SetBorder(IGBorder);
  // Arrow Head
  // P122 DMMN 6/24/2011 - Added this section to created a proper Art3.0
  IGMark.SetHeadFillColor(IGBorderColor); //p122 7/12/11 - add fill color for head
  if Not createArrow then
  begin
    IGArrowHead := IGArtXCtl.CreateObject(IG_ARTX_OBJ_ARROWHEAD) as IIGArtXArrowHead;
    IGArrowHead.Style := IG_ARTX_ARROW_NONE;
    IGMark.SetHeadFillColor(IGBorderColor);
    IGMark.SetStartHead(IGArrowHead);
    IGMark.SetEndHead(IGArrowHead);
  end
  else
  begin
    SetArrowHead(IGMark);
  end;

  IGMark.Opacity := inOpacity;
  SetAnnotationOwnership(IGMark);
End;

Procedure TMagAnnot.SetLastPolylineToDefaults(Button: Integer);
Var
  IGBorder: IGArtXBorder;
  IGBorderColor: IGPixel;
  IGFillColor: IGPixel;
  IGMark: IIGArtXPolyline;
  inBorderColor: Integer;
  inFillColor: Integer;
  inLineWidth: Integer;
  inOpacity: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
Begin
  If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then Exit;
  If Button <> 2 Then Exit;
  IGMark := GetLastPolyline();
  If IGMark = Nil Then Exit;
  inOpacity := frmAnnotOptionsX.Opacity;
  inLineWidth := frmAnnotOptionsX.LineWidth;
  //FillColor
  inFillColor := frmAnnotOptionsX.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := frmAnnotOptionsX.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;

  IGMark.SetBorder(IGBorder);
  IGMark.Opacity := inOpacity;
  IGPageViewCtl.UpdateView;
  actAnnot00_SELECTExecute(Nil);
End;

Procedure TMagAnnot.PreCreateMarkPolylineToDefaults(IGMark: IIGArtXPolyline);
Var
  IGBorder: IGArtXBorder;
  IGBorderColor: IGPixel;
  IGFillColor: IGPixel;
  inBorderColor: Integer;
  inFillColor: Integer;
  inLineWidth: Integer;
  inOpacity: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
Begin
  //p122 dmmn 7/11/11 art 3.0
  If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then Exit;
  //If Button <> 2 Then Exit;
  //IGMark := GetLastPolyline();
  If IGMark = Nil Then Exit;

  inOpacity := frmAnnotOptionsX.Opacity;
  inLineWidth := frmAnnotOptionsX.LineWidth;

  //FillColor
//  inFillColor := AnnotationOptions.AnnotFillColor;
//  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
//  IGFillColor.ChangeType(IG_PIXEL_RGB);
//  AnnotationOptions.ColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
//  IGFillColor.RGB_R := RGB_R;
//  IGFillColor.RGB_G := RGB_G;
//  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := frmAnnotOptionsX.AnnotLineColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;
  if ConsultResulted = '1' then            //p122 dmmn 7/11/11 - change line style if the consult is resulted
    IGBorder.Style := IG_ARTX_PEN_DASH;

  IGMark.SetBorder(IGBorder);
  IGMark.Opacity := inOpacity;
//  IGPageViewCtl.UpdateView;
  SetAnnotationOwnership(IGMark);
End;

Procedure TMagAnnot.SetLastFreehandLineToDefaults();
Var
  IGBorder: IGArtXBorder;
  IGBorderColor: IGPixel;
  IGFillColor: IGPixel;
  IGMark: IIGArtXFreeline;
  inBorderColor: Integer;
  inFillColor: Integer;
  inLineWidth: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
Begin
  If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then Exit;
  IGMark := GetLastFreeline();
  If IGMark = Nil Then Exit;
  inLineWidth := frmAnnotOptionsX.LineWidth;
  //FillColor
  inFillColor := frmAnnotOptionsX.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := frmAnnotOptionsX.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;

  IGMark.SetBorder(IGBorder);
  IGMark.Set_Highlight(frmAnnotOptionsX.HighlightLine);
  IGPageViewCtl.UpdateView;
  actAnnot00_SELECTExecute(Nil);
End;

Procedure TMagAnnot.PreCreateMarkFreehandLineToDefaults(IGMark: IIGArtXFreeline);
Var
  IGBorder: IGArtXBorder;
  IGBorderColor: IGPixel;
  IGFillColor: IGPixel;
  inLineColor: Integer;
  inLineWidth: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
Begin
  If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then Exit;
  If IGMark = Nil Then Exit;

  inLineWidth := frmAnnotOptionsX.LineWidth;


  //BorderColor
  inLineColor := frmAnnotOptionsX.AnnotLineColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inLineColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;
  if ConsultResulted = '1' then            //p122 dmmn 7/11/11 - change line style if the consult is resulted
    IGBorder.Style := IG_ARTX_PEN_DASH;
    

  IGMark.SetBorder(IGBorder);

//  if frmAnnotOptionsX.Opacity < 127 then
  if frmAnnotOptionsX.Opacity <= 159 then //p122 dmmn 8/15/11 - new value for opacity
    IGMark.Set_Highlight(True)
  else
    IGMark.Set_Highlight(False);

  SetAnnotationOwnership(IGMark);
End;

Procedure TMagAnnot.SetLastArrowToDefaults;
Var
  IGBorder: IGArtXBorder;
  IGBorderColor: IGPixel;
  IGFillColor: IGPixel;
  IGMark: IIGArtXArrow;
  inBorderColor: Integer;
  inFillColor: Integer;
  inLineWidth: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
Begin
  If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then Exit;
  IGMark := GetLastArrow();
  If IGMark = Nil Then Exit;
  inLineWidth := frmAnnotOptionsX.LineWidth;
  //FillColor
  inFillColor := frmAnnotOptionsX.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := frmAnnotOptionsX.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;

  IGMark.SetBorder(IGBorder);
  IGPageViewCtl.UpdateView;
  actAnnot00_SELECTExecute(Nil);
End;

Procedure TMagAnnot.PreCreateMarkArrowToDefaults(IGMark: IIGArtXArrow);
Var
  IGBorder: IGArtXBorder;
  IGBorderColor: IGPixel;
  IGFillColor: IGPixel;
  inBorderColor: Integer;
  inFillColor: Integer;
  inLineWidth: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
Begin
  If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then Exit;
  If IGMark = Nil Then Exit;

  inLineWidth := frmAnnotOptionsX.LineWidth;

  //FillColor
  inFillColor := frmAnnotOptionsX.AnnotLineColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := frmAnnotOptionsX.AnnotLineColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;

  IGMark.SetBorder(IGBorder);

  //ArrowHead
  SetArrowHead(IGMark);

//  IGPageViewCtl.UpdateView;
  SetAnnotationOwnership(IGMark);

                    magAppMsg('s', 'PreCreateMarkArrowToDefaults: inLineWidth='+inttostr(inlinewidth) +
                    ' inFillColor='+inttostr(infillcolor) +
                    ' inBorderColor='+inttostr(inbordercolor) );
End;

Procedure TMagAnnot.SetLastHollowEllipseToDefaults();
Var
  IGBorder: IGArtXBorder;
  IGBorderColor: IGPixel;
  IGFillColor: IGPixel;
  IGMark: IIGArtXHollowEllipse;
  inBorderColor: Integer;
  inFillColor: Integer;
  inLineWidth: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
Begin
  If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then Exit;
  IGMark := GetLastHollowEllipse();
  If IGMark = Nil Then Exit;
  inLineWidth := frmAnnotOptionsX.LineWidth;
  //FillColor
  inFillColor := frmAnnotOptionsX.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := frmAnnotOptionsX.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;

  IGMark.SetBorder(IGBorder);
  IGMark.Set_Highlight(frmAnnotOptionsX.HighlightLine);
  IGPageViewCtl.UpdateView;
  actAnnot00_SELECTExecute(Nil);
End;

Procedure TMagAnnot.PreCreateMarkHollowEllipseToDefaults(IGMark: IIGArtXHollowEllipse);
Var
  IGBorder: IGArtXBorder;
  IGBorderColor: IGPixel;
  IGFillColor: IGPixel;
  inBorderColor: Integer;
  inFillColor: Integer;
  inLineWidth: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
Begin
  If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then Exit;
  If IGMark = Nil Then Exit;
  inLineWidth := frmAnnotOptionsX.LineWidth;
  //FillColor
  inFillColor := frmAnnotOptionsX.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := frmAnnotOptionsX.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;

  IGMark.SetBorder(IGBorder);
  IGMark.Set_Highlight(frmAnnotOptionsX.HighlightLine);
//  IGPageViewCtl.UpdateView;
  SetAnnotationOwnership(IGMark);
End;

Procedure TMagAnnot.SetLastHollowRectangleToDefaults();
Var
  IGBorder: IGArtXBorder;
  IGBorderColor: IGPixel;
  IGFillColor: IGPixel;
  IGMark: IIGArtXHollowRectangle;
  inBorderColor: Integer;
  inFillColor: Integer;
  inLineWidth: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
Begin
  If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then Exit;
  IGMark := GetLastHollowRectangle();
  If IGMark = Nil Then Exit;
  inLineWidth := frmAnnotOptionsX.LineWidth;
  //FillColor
  inFillColor := frmAnnotOptionsX.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := frmAnnotOptionsX.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;

  IGMark.SetBorder(IGBorder);
  IGMark.Set_Highlight(frmAnnotOptionsX.HighlightLine);
  IGPageViewCtl.UpdateView;
  actAnnot00_SELECTExecute(Nil);
End;

Procedure TMagAnnot.PreCreateMarkHollowRectangleToDefaults(IGMark: IIGArtXHollowRectangle);
Var
  IGBorder: IGArtXBorder;
  IGBorderColor: IGPixel;
  IGFillColor: IGPixel;
  inBorderColor: Integer;
  inFillColor: Integer;
  inLineWidth: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
Begin
  If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then Exit;
  If IGMark = Nil Then Exit;
  inLineWidth := frmAnnotOptionsX.LineWidth;
  //FillColor
  inFillColor := frmAnnotOptionsX.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := frmAnnotOptionsX.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;

  IGMark.SetBorder(IGBorder);
  IGMark.Set_Highlight(frmAnnotOptionsX.HighlightLine);
//  IGPageViewCtl.UpdateView;
  SetAnnotationOwnership(IGMark);
End;

Procedure TMagAnnot.SetLastProtractorToDefaults();
Var
  IGBorder: IGArtXBorder;
  IGBorderColor: IGPixel;
  IGFillColor: IGPixel;
  IGMark: IIGArtXProtractor;
  inBorderColor: Integer;
  inFillColor: Integer;
  inLineWidth: Integer;
  inOpacity: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
Begin
  If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then Exit;
  If FProtractorState = -1 Then
  Begin
    FProtractorState := 1;
    Exit;
  End;
  If FProtractorState = 1 Then
  Begin
    FProtractorState := 2;
    Exit;
  End;
  If FProtractorState = 2 Then
  Begin
    FProtractorState := -1;
  End;
  IGMark := GetLastProtractor();
  If IGMark = Nil Then Exit;
  inOpacity := frmAnnotOptionsX.Opacity;
  inLineWidth := frmAnnotOptionsX.LineWidth;

  //FillColor
  inFillColor := frmAnnotOptionsX.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := frmAnnotOptionsX.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;

  IGMark.SetBorder(IGBorder);
  IGMark.Opacity := inOpacity;
  IGPageViewCtl.UpdateView;
  actAnnot00_SELECTExecute(Nil);

End;

Procedure TMagAnnot.PreCreateMarkProtractorToDefaults(IGMark: IIGArtXProtractor);
Var
  IGBorder: IGArtXBorder;
  IGBorderColor: IGPixel;
  IGFont: IGArtXFont;
  inBorderColor: Integer;
  inLineWidth: Integer;
  inOpacity: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
Begin
  If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then Exit;
  If IGMark = Nil Then Exit;

  inOpacity := frmAnnotOptionsX.Opacity;
  //p122t4 9/28
  if RadPackage or IsDODImage then      //p122t15 dod option
    inOpacity := 255;

  inLineWidth := frmAnnotOptionsX.LineWidth;

  //Font
  IGFont := IGMark.GetFont;
//  IGFont.DisablePPM := True;
  IGFont.DisablePPM := DisablePPM;  //p122 8/26

  SetFontToDefaults(IGFont);
  //p122t4 9/27 - font 18 for rad images
  if RadPackage or IsDODImage then          //p122t15 dod
    IGFont.Size := 18;

  IGMark.SetFont(IGFont);


  //BorderColor
  inBorderColor := frmAnnotOptionsX.AnnotLineColor;
  //p122t4 dmmn 9/28 - blue color for temp protractor
  if RadPackage or IsDODImage then  //p122t15 dod
    inBorderColor := clBlue;

  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;
  if ConsultResulted = '1' then            //p122 dmmn 7/11/11 - change line style if the consult is resulted
  begin
    IGBorder.Style := IG_ARTX_PEN_DASH;
    IGFont.Style := IGFont.Style + IG_ARTX_FONT_UNDERLINE;
    IGMark.SetFont(IGFont);
  end;

  IGMark.SetBorder(IGBorder);
  IGMark.Opacity := inOpacity;
  
  SetAnnotationOwnership(IGMark);
End;

Procedure TMagAnnot.SetLastRulerToDefaults;
Var
  IGBorder: IGArtXBorder;
  IGBorderColor: IGPixel;
  IGFillColor: IGPixel;
  IGMark: IIGArtXRuler;
  inBorderColor: Integer;
  inFillColor: Integer;
  inLineWidth: Integer;
  inOpacity: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
  sgRulerLabel: String;
Begin
  If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then Exit;
  IGMark := GetLastRuler();
  If IGMark = Nil Then Exit;
  inOpacity := frmAnnotOptionsX.Opacity;
  inLineWidth := frmAnnotOptionsX.LineWidth;
  sgRulerLabel := frmAnnotOptionsX.RulerLabel;
  //FillColor
  inFillColor := frmAnnotOptionsX.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := frmAnnotOptionsX.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;

  IGMark.SetBorder(IGBorder);
  IGMark.Opacity := inOpacity;
  IGMark.Label_ := sgRulerLabel;

  IGPageViewCtl.UpdateView;
  actAnnot00_SELECTExecute(Nil);
End;

Procedure TMagAnnot.PreCreateMarkRichTextToDefaults(IGMark: IIGArtXRichText);
Var
  IGBorder: IGArtXBorder;
  IGBorderColor: IGPixel;
  inBorderColor: Integer;
  inOpacity: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
Begin
  If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then Exit;
  If IGMark = Nil Then Exit;
  inOpacity := frmAnnotOptionsX.Opacity;

  //BorderColor
  inBorderColor := frmAnnotOptionsX.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := 0;

  IGMark.SetBorder(IGBorder);
  IGMark.SetFillColor(Nil);
  IGMark.Opacity := inOpacity;

//  IGPageViewCtl.UpdateView;
  SetAnnotationOwnership(IGMark);
End;

Procedure TMagAnnot.PreCreateMarkRectangleToDefaults(IGMark: IIGArtXRectangle);
Var
  IGBorder: IGArtXBorder;
  IGBorderColor: IGPixel;
  IGFillColor: IGPixel;
  inLineColor: Integer;
  inLineWidth: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
begin
  {/P122 DMMN 6/27/2011 - Create Art3.0 Rectangle both Filled and Hollow /}

  If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then Exit;
  If IGMark = Nil Then Exit;

  inLineWidth := frmAnnotOptionsX.LineWidth;
  if createHighlighter then // very thin border for highlighter
    inLineWidth := 1;

  //BorderColor
  inLineColor := frmAnnotOptionsX.AnnotLineColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inLineColor, RGB_R, RGB_G, RGB_B);
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;
  if ConsultResulted = '1' then            //p122 dmmn 7/11/11 - change line style if the consult is resulted
  begin
    IGBorder.Style := IG_ARTX_PEN_DASH;
    if createHighlighter then
      IGBorder.Width := 5;                   //p122 dmmn 8/2 - added per request to better identify after resulted
  end;

  IGMark.SetBorder(IGBorder);

  if createFill then
    IGMark.SetFillColor(IGBorderColor)
  else
    IGMark.SetFillColor(nil);

  IGMark.Opacity := frmAnnotOptionsX.Opacity;

  SetAnnotationOwnership(IGMark);
end;

Procedure TMagAnnot.CreateMarkRectangleToDefaults(IGMark: IIGArtXRectangle);
Var
  igRect: IIGRectangle;
Begin
  igRect := IGMark.GetBounds();
  If igRect.Width = 0 Then Exit;
  igRect.Height := igRect.Width;
  IGMark.SetBounds(igRect);
End;

Procedure TMagAnnot.CreateMarkEllipseToDefaults(IGMark: IIGArtXEllipse);
Var
  Center: TPoint;
  igRect: IIGRectangle;
  Radius: Integer;
Begin
  Try
    igRect := IGMark.GetBounds();
    Center.x := ((IGRect.Right - IGRect.Left) Div 2) + IGRect.Left;
    Center.y := ((IGRect.Bottom - IGRect.Top) Div 2) + IGRect.Top;
    If IGRect.Height > igRect.Width Then
    Begin
      Radius := IGRect.Height Div 2;
    End
    Else
    Begin
      Radius := IGRect.Width Div 2;
    End;
    IGRect.Left := Center.x - Radius;
    IGRect.Right := Center.x + Radius;
    IGRect.Top := Center.y - Radius;
    IGRect.Bottom := Center.y + Radius;
    IGMark.SetBounds(IGRect);
  Except
  End;
End;

Procedure TMagAnnot.PreCreateMarkEllipseToDefaults(IGMark: IIGArtXEllipse);
var
  IGBorder: IGArtXBorder;
  IGBorderColor: IGPixel;
  inLineColor: Integer;
  inLineWidth: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
begin
  {/P122 DMMN 6/27/2011 - Create Art3.0 Ellipse both Filled and Hollow /}
  If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then Exit;
  If IGMark = Nil Then Exit;

  inLineWidth := frmAnnotOptionsX.LineWidth;

  IGMark.SetFillColor(nil);
  if createFill then
    IGMark.SetFillColor(IGBorderColor);

  //BorderColor
  inLineColor := frmAnnotOptionsX.AnnotLineColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inLineColor, RGB_R, RGB_G, RGB_B);
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;

  if ConsultResulted = '1' then            //p122 dmmn 7/11/11 - change line style if the consult is resulted
    IGBorder.Style := IG_ARTX_PEN_DASH;
  IGMark.SetBorder(IGBorder);

  IGMark.Opacity := frmAnnotOptionsX.Opacity;

  SetAnnotationOwnership(IGMark);
end;

procedure TMagAnnot.PreCreateMarkTextToDefaults(IGMark: IIGArtXText);
var
  IGFont : IGArtXFont;
  IGTextColor: IGPixel;
  inTextColor: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
//  IGBorder : IIGArtXBorder;
begin
  If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then Exit;
  If IGMark = Nil Then Exit;

  //TextColor
  inTextColor := frmAnnotOptionsX.AnnotLineColor;
  IGTextColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGTextColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inTextColor, RGB_R, RGB_G, RGB_B);
  IGTextColor.RGB_R := RGB_R;
  IGTextColor.RGB_G := RGB_G;
  IGTextColor.RGB_B := RGB_B;

  // Fill color
  IGMark.SetFillColor(nil);
  // Border
  IGMark.SetBorder(nil);
  // Font
  IGFont := IGMark.GetFont;
//  IGFont.DisablePPM := True;
  IGFont.DisablePPM := DisablePPM; //p122 8/26

  SetFontToDefaults(IGFont);
  IGMark.SetFont(IGFont);
  IGMark.SetTextColor(IGTextColor);

  IGMark.BoundsWrap := IG_ARTX_WRAP_NONE;
  IGMark.TextAlignment := IG_DSPL_ALIGN_X_LEFT or IG_DSPL_ALIGN_Y_TOP;

  //p122 dmmn 7/26/11 - change after resulted text from dahsed border to underline;

  //Border
//  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
//  IGBorder.SetColor(IGTextColor);
//  IGBorder.Width := 1;
//  if ConsultResulted = '1' then            //p122 dmmn 7/11/11 - change line style if the consult is resulted
//    IGBorder.Style := IG_ARTX_PEN_DASH;
//  IGMark.SetBorder(IGBorder);
  if ConsultResulted = '1' then
  begin
    IGFont.Style := IGFont.Style + IG_ARTX_FONT_UNDERLINE;
    IGMark.SetFont(IGFont);
  end;

  IGMark.Opacity := frmAnnotOptionsX.Opacity;  //p122 7/12/11
  SetAnnotationOwnership(IGMark);

  //p122t7 dmmn 10/31 - no need to put the text from the begining. only check when
  //user navigate away from the text with an empty field.
//  IGMark.Text := 'Enter Text Here'; //p122t3 9/19 - group decision to put a default text here
end;

Procedure TMagAnnot.PreCreateMarkTextTypedToDefaults(IGMark: IIGArtXTextTyped);
Var
  IGFont: IGArtXFont;
  IGTextColor: IGPixel;
  inTextColor: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
Begin
  If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then Exit;
  If IGMark = Nil Then Exit;

  //TextColor
  inTextColor := frmAnnotOptionsX.FontColor;
  IGTextColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGTextColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inTextColor, RGB_R, RGB_G, RGB_B);
  IGTextColor.RGB_R := RGB_R;
  IGTextColor.RGB_G := RGB_G;
  IGTextColor.RGB_B := RGB_B;

  IGFont := IGMark.GetFont;
  SetFontToDefaults(IGFont);
  IGMark.SetFont(IGFont);
  IGMark.SetTextColor(IGTextColor);
//  IGPageViewCtl.UpdateView;
  SetAnnotationOwnership(IGMark);
End;

Procedure TMagAnnot.SetFontToDefaults(Var IGFont: IGArtXFont);
Begin
  {/p122 dmmn 7/11/11 - new font settings /}

  //Font
  If IGFont = Nil Then Exit;
  IGFont.Size := frmAnnotOptionsX.FontSize;
  IGFont.Name := frmAnnotOptionsX.FontName;

//  IGFont.Style := IG_ARTX_FONT_REGULAR;
//  If AnnotationOptions.Fontbold Then IGFont.Style := IGFont.Style + IG_ARTX_FONT_BOLD;
//  If AnnotationOptions.FontItalic Then IGFont.Style := IGFont.Style + IG_ARTX_FONT_ITALIC;
//  If AnnotationOptions.FontUnderline Then IGFont.Style := IGFont.Style + IG_ARTX_FONT_UNDERLINE;
//  If AnnotationOptions.FontStrikeOut Then IGFont.Style := IGFont.Style + IG_ARTX_FONT_STRIKEOUT;
  if frmAnnotOptionsX.FontStyle = 0 then
    IGFont.Style := IG_ARTX_FONT_REGULAR
  else if frmAnnotOptionsX.FontStyle = 1 then
    IGFont.Style := IG_ARTX_FONT_BOLD
  else if frmAnnotOptionsX.FontStyle = 2 then
    IGFont.Style := IG_ARTX_FONT_ITALIC
  else if frmAnnotOptionsX.FontStyle = 3 then
    IGFont.Style := IG_ARTX_FONT_BOLD + IG_ARTX_FONT_ITALIC;
End;

Procedure TMagAnnot.PreCreateMarkRulerToDefaults(IGMark: IIGArtXRuler);
Var
  IGBorder: IGArtXBorder;
  IGBorderColor: IGPixel;
  IGFont: IGArtXFont;
  inBorderColor: Integer;
  inLineWidth: Integer;
  inOpacity: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
Begin
  If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then Exit;
  If IGMark = Nil Then Exit;

  inOpacity := frmAnnotOptionsX.Opacity;
  //p122t3 9/22
  if RadPackage or IsDODImage then     //p122t15 dod
    inOpacity := 255;
    
  inLineWidth := frmAnnotOptionsX.LineWidth;

  //Font
  IGFont := IGMark.GetFont;
//  IGFont.DisablePPM := True;
  IGFont.DisablePPM := DisablePPM;
  SetFontToDefaults(IGFont);
  //p122t3 9/22 - font 18 for rad images
  if RadPackage or IsDODImage then          //p122t15 dod
    IGFont.Size := 18;
  IGMark.SetFont(IGFont);


  //BorderColor
  inBorderColor := frmAnnotOptionsX.AnnotLineColor;
  //p122t3 dmmn 9/22 - blue color for temp ruler
  if RadPackage or IsDODImage then  //p122t15 dod
    inBorderColor := clBlue;

  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;

  if ConsultResulted = '1' then            //p122 dmmn 7/11/11 - change line style if the consult is resulted
  begin
    IGBorder.Style := IG_ARTX_PEN_DASH;

    IGFont.Style := IGFont.Style + IG_ARTX_FONT_UNDERLINE;
    IGMark.SetFont(IGFont);
  end;

  IGMark.SetBorder(IGBorder);
  IGMark.Opacity := inOpacity;

  {/p122 dmmn 8/17 - calculate the end line length based on the linewidth.
  Default width = 5, length = 20 => new linelength = width*4 /}
  IGMark.StartLineLength := IGBorder.Width*4;
  IGMark.EndLineLength := IGBorder.Width*4;

  if RulerActualAspectRatio <> nil then
  begin
    IGMark.SetAspectRatio(RulerActualAspectRatio);
    IGMark.Label_ := '%d ' + RulerMeasUnit; //p122 dmmn 7/12/11 - new units
  end
  else
    IGMark.Label_ := '%d unit';

  {/p122 dmmn 8/23 - Use DICOM ratio if available /}
  if FUseDICOMratio then
  begin
    if DicomAspectRatio <> nil then
    begin
      IGMark.SetAspectRatio(DicomAspectRatio);
      IGMark.Label_ := '%d ' + RulerMeasUnit;
    end;
//    ConfigureRulerForUnitMilimeter(IGMark);            //9/13 accusoft ruler calibrate
  end;

  SetAnnotationOwnership(IGMark);
//  IGPageViewCtl.UpdateView;
End;

procedure TMagAnnot.SetAnnotationOwnership(IGMark: IIGArtXMark);
var
  myDateTime : TDateTime;
begin
  if (Not RADPackage) and (Not IsDODImage) then   //p122t15 dod
  begin
    if Trim(Username) = '' then
      magAppMsg('s', 'TMagAnnot.SetAnnotationOwnership error. Tooltip ' +
      'values not set. Continuing. This AnnotComponent=[' + IntToHex(Integer(Pointer(Self)),0) + '] Values = ' +
      Username + '|' + Service + '|' + 'YYYYMMDDHHMMSS' +
      '|' + FDUZ + '|' + FSiteNum);

//    IGMark.Tooltip := Username + '|' + Service + '|' + 'YYYYMMDDHHMMSS'
//                      + '|' + GSess.UserDUZ + '|' + GSess.WrksInstStationNumber;  //p122 7/12/11

    IGMark.Tooltip := Username + '|' + Service + '|' + 'YYYYMMDDHHMMSS'
                      + '|' + FDUZ + '|' + FSiteNum;  //p122 7/12/11
  end
  else
  begin
    if IGMark.type_  = IG_ARTX_MARK_RULER then
      IGMark.Tooltip := 'Temporary Ruler Annotation'
    else if IGMark.type_ = IG_ARTX_MARK_PROTRACTOR then
      IGMark.Tooltip := 'Temporary Protractor Annotation';
  end;
end;

procedure TMagAnnot.EditAnnotationOwnership(IGMark: IIGArtXMark);
var
  MarkUserDUZ : string;
  MarkUserSite : string;
  MarkDate : string;
  toolt : AnsiString;
begin
  {/p122t2 dmmn 9/7 - CQ:IMAG00000782 - Annotations will have *edited* at the end
  of the tooltip when modified. And will be updated when save /}
   
  {/p122 dmmn 8/31 - this apply when a master user or user modify their own annotations -
  annotations with this tooltips will be updated to current session information at the end of
  the session right before saving to vista/}
  // if already edited then exit
  toolt := IGMark.Tooltip;
  if AnsiContainsStr(toolt, '|*edited*|') then
    Exit;

  MarkDate := GetViewHideFieldValue(3, IGMark.Tooltip);
  MarkUserDUZ := GetViewHideFieldValue(4, IGMark.Tooltip);
  MarkUserSite := GetViewHideFieldValue(5, IGMark.Tooltip);
  // for temporary annotations
  if (MarkUserDUZ = '') or (MarkUserSite = '') then
    Exit;
  // for non temporary annotations
  // user has master key then change for any mark with a not current date

//  if GSess.HasLocalAnnotateMasterKey then
  {/ P122 JK 10/3/2011 /}
  if FHasMasterKey then
  begin
    if MarkDate <> 'YYYYMMDDHHMMSS' then
      IGMark.Tooltip := IGMark.Tooltip + '|*edited*|';
  end
  else // user doesn't have master key so only change when duz+site same and not current date
  begin
//    if (MarkUserDUZ = GSess.UserDUZ) and (MarkUserSite = GSess.WrksInstStationNumber)
//        and (MarkDate <> 'YYYYMMDDHHMMSS') then
//      IGMark.Tooltip := IGMark.Tooltip + '|*edited*|';

    if (MarkUserDUZ = FDUZ) and (MarkUserSite = FSiteNum)
        and (MarkDate <> 'YYYYMMDDHHMMSS') then
      IGMark.Tooltip := IGMark.Tooltip + '|*edited*|';
  end;
end;

Procedure TMagAnnot.InitializeVariables;
Begin
  FToolbarIsShowing := Self.Showing;
  FAnnotationStyle := TMagAnnotationStyle.Create();
  FPageCount := 0;
  FAnnotsModified := False;  {/ JK 9/26/2011 - changed to false from true /}
  EditMode := True;
  FProtractorState := -1;

  FcurrentPage := Nil;
  FToolbarInitialized := False;

  InitButtonsArray();
  InitButtonCaptions();
  InitButtonAlignLeft();
  InitButtonVisibility();
  FIGArtDrawParams := IGArtXCtl.CreateObject(IG_ARTX_OBJ_DRAWPARAMS) As IIGArtXDrawParams;
  IGArtXCtl.OnCreateMarkNotify := FIGArtXCtlCreateMarkNotify;
  IGArtXCtl.OnDeleteMarkNotify := FIGArtXCtlDeleteMarkNotify;
  IGArtXCtl.OnModifyMarkNotify := FIGArtXCtlModifyMarkNotify;
  IGArtXCtl.OnPreCreateMarkNotify := FIGArtXCtlPreCreateMarkNotify;
  IgCurPoint := IGCoreCtl.CreateObject(IG_OBJ_POINT) As IIGPoint;

  {Ruler Aspect Ratio}
  RulerActualMeasured := 1;
  RulerActualAspectRatio := nil;
  RulerMeasUnit := 'unit'; //p122 dmmn 7/12/11

  {Dicom AspectRatio}
  DicomAspectRatio := nil;
  FUseDICOMRatio := false;

End;

Procedure TMagAnnot.actEditUnSelectAllExecute(Sender: Tobject);
Var
  CurMark: IIGArtXMark;
Begin
  // unselect all marks on current page
  If IsValidEnv(CurrentPage) Then
  Begin
    CurMark := ArtPageList[Page-1].ArtPage.MarkFirst;
    While (Not (CurMark = Nil)) Do
    Begin
      ArtPageList[Page-1].ArtPage.MarkSelect(CurMark, False);
      CurMark := ArtPageList[Page-1].ArtPage.Marknext(CurMark);
    End;

    {/p122t4 dmmn 9/30 - return the toolbar status to normal /}
    if FIsInHistoryView then
      sbStatus.Panels[0].Text := 'This History Layer is View Only'
    else
      sbStatus.Panels[0].Text := ACurrentAnnotationSession;
    sbStatus.Hint := '';
    btnMarkSettings.Enabled := False;
  End;
  IGPageViewCtl.UpdateView;
End;

Procedure TMagAnnot.UnselectAllMarks();
Begin
  actEditUnSelectAllExecute(Nil);
End;

Procedure TMagAnnot.DrawText(Left, Right, Top, Bottom, Red, Green,
  Blue: Integer; Text: String; FontSize: Integer);
Var
  IGFont: IGArtXFont;
  igMark: IIGArtXTextTyped;
  igRect: IIGRectangle;
  IGTextColor: IGPixel;
  inTextColor: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
Begin
  If Trim(Text) = '' Then Exit; //If Text = '' Then Exit;
  If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then Exit;
  Try
    ArtPageList[Page-1].ArtPage.GroupGet('RADCODE'); //ArtPage.GlobalAttrGroup := 'RADCODE';
    //ArtPage.GlobalAttrMeasurementUnits := UnitCentimeters;// Not supported in ARTX
    IGRect.Left := Left;
    IGRect.Right := Right;
    IGRect.Top := Top;
    IGRect.Bottom := Bottom;

    //TextColor
    inTextColor := frmAnnotOptionsX.RGBToColor(Red, Green, Blue);
    IGTextColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
    IGTextColor.ChangeType(IG_PIXEL_RGB);
    frmAnnotOptionsX.AnnotColorToRGB(inTextColor, RGB_R, RGB_G, RGB_B);
    IGTextColor.RGB_R := RGB_R;
    IGTextColor.RGB_G := RGB_G;
    IGTextColor.RGB_B := RGB_B;

    IGFont := IGMark.GetFont;

    If IGFont <> Nil Then
    Begin
      IGFont.Size := FontSize;
      IGFont.Name := 'Microsoft Sans Serif';
      IGFont.Style := IG_ARTX_FONT_REGULAR;
      IGMark.SetFont(IGFont);
      IGMark.SetTextColor(IGTextColor);
      IGPageViewCtl.UpdateView;
    End;

    igMark :=
      IGArtXCtl.CreateTextTyped(
      IGRect, //const pRect: IIGRectangle;
      Text, //const Text: WideString;
      IGTextColor, //const TextColor: IIGPixel;
      IGFont); //const Font: IIGArtXFont): IIGArtXTextTyped;

    ArtPageList[Page-1].ArtPage.AddMark(igMark, IG_ARTX_COORD_IMAGE);
    IGPageViewCtl.UpdateView;
  Finally
  End;
End;

Procedure TMagAnnot.SetAnnotationStyles;
Begin
  If IsValidEnv() = False Then Exit;
  (*
  SetArrowPointer(CurrentArrowPointer);
  SetArrowLength(CurrentArrowLength);
  SetFont(FontName, FontSize, Bold, Italic);
  SetAnnotationColor(CurrentAnnotationColor);
  SetLineWidth(LineWidth);
  SetOpaque(Opaque);
  SetAnnotationStyle(FAnnotationStyle);
  *)
End;

Procedure TMagAnnot.EnableMeasurements;
Begin
  actAnnot21_RULERExecute(Nil);
End;

Procedure TMagAnnot.SetFont(TheFontName: String; TheFontSize: Integer; IsBold, IsItalic: Boolean);
Begin
  If TheFontSize > 0 Then frmAnnotOptionsX.FontSize := TheFontSize;
  If Trim(TheFontName) <> '' Then frmAnnotOptionsX.FontName := TheFontName;
  frmAnnotOptionsX.Fontbold := IsBold;
  frmAnnotOptionsX.FontItalic := IsItalic;
End;

Procedure TMagAnnot.RemoveOrientationLabel();
Var
  GroupName: WideString;
  LabelGroup: IIGArtXGroup;
Begin
  If ArtPage = Nil Then Exit;
  GroupName := 'RADCODE';
  LabelGroup := ArtPageList[Page-1].ArtPage.GroupGet(GroupName);
  If LabelGroup = Nil Then Exit;
  ArtPageList[Page-1].ArtPage.GroupDelete(LabelGroup);
End;

Procedure TMagAnnot.Initialize(CurPoint: IIGPoint; CurPage: IIGPage;
  CurPageDisp: IIGPageDisplay; PageViewHwnd: Integer;
  ForDiagramAnnotation: Boolean);
Begin
  //reset the count for Vista rad annotations
//  FRADAnnotationIGCount := 0;
//  FRADAnnotationCount := 0;

  DisablePPM := False; //p122 dmmm 8/26 - scale text
//  DisablePPM := True;

  IgCurPoint := CurPoint;
  CurrentPageDisp   := CurPageDisp;
  CurrentPage       := CurPage;
  If ArtPage = Nil Then
    ArtPage := IGArtXCtl.CreatePage;
  CurrentPageDisp.OffScreenDrawing := True; {/ P122 - DN 6/14/2011 - Controls redraw flicker /}

  Self.PageViewHwnd := PageViewHwnd;

End;

Procedure TMagAnnot.SetPageCount(Const Value: Integer);
Begin
  FPageCount := Value;
End;

Function TMagAnnot.GetPageCount: Integer;
Begin
  Result := FPageCount;
End;

function TMagAnnot.GetRadAnnotCount: Integer;
begin                                            //p122t3
  Result := RadInfo.radAnnotCount;
end;

function TMagAnnot.GetSelectedMarkCount_CurrentPage: Integer;
begin

end;

Procedure TMagAnnot.SetPage(Const Value: Integer);
Begin
  FPage := Value;
End;

Function TMagAnnot.GetPage: Integer;
Begin
  Result := FPage;
End;

Procedure TMagAnnot.ClearAllAnnotations;
Begin
  actEditDeleteAllExecute(Nil);
End;

Function TMagAnnot.GetMarkCount: Integer;
var
  I: Integer;
Begin
  Result := 0;
  If Not IsValidEnv() Then Exit;
//  if Page > 0 then
  for I := 0 to PageCount - 1 do  //p122 dmmn 7/25/11 - update markcount for all available artpage
    Result := Result + ArtPageList[I].ArtPage.MarkCount;

  //p122 dmmn 8/9 - rad count
  if RADPackage then
  begin
    if (ImageIEN = RadInfo.iIEN) then  // same image
    begin
//      Result := (Result - FRADAnnotationIGCount) + FRADAnnotationCount; //p122t3 dmmn 9/15 = temps + rad
      Result := (Result - RadInfo.radIGmapped) + RadInfo.radAnnotCount;
    end
    else     //reuse component but differnt image
    begin
      Result := (Result - 0) + 0; //p122t3 dmmn 9/15 = temps + rad
    end;
  end;

End;

function TMagAnnot.GetMarkCount_CurrentPage: Integer;
var
  CurMark : IIGArtXMark;
begin
  try
    Result := 0;
    CurMark := ArtPageList[CurrentPageNumber].ArtPage.MarkFirst;
    while CurMark <> nil do
    begin
      Inc(Result);
      CurMark := ArtPageList[CurrentPageNumber].ArtPage.MarkNext(CurMark);
    end;

    //p122 dmmn 8/9 - rad count
    if RADPackage then
    begin
      if (ImageIEN = RadInfo.iIEN) then  // same image
      begin
        // current page count = total IG marks count - IGmarks used to map Rad + actual Rad count
        Result := (Result - RadInfo.radIGmapped) + RadInfo.radAnnotCount;
      end
      else     //reuse component but differnt image
      begin
        Result := (Result - 0) + 0; //p122t3 dmmn 9/15 = temps + rad
      end;
    end;
  except
    on E:Exception do
      magAppMsg('s', 'TMagAnnot.GetMarkCount_CurrentPage (pg # ' + IntToStr(CurrentPageNumber) + ') Error = ' + E.Message);
  end;
end;

function TMagAnnot.GetHiddenMarkCount_CurrentPage: Integer;
var
  CurMark : IIGArtXMark;
begin
  try
    Result := 0;
    CurMark := ArtPageList[CurrentPageNumber].ArtPage.MarkFirst;
    while CurMark <> nil do
    begin
      if not CurMark.Visible  then
        Inc(Result);
      CurMark := ArtPageList[CurrentPageNumber].ArtPage.MarkNext(CurMark);
    end;

    //p122t3 dmmn 9/22
    if Result > 0 then
    begin
      if RADPackage then
      begin
        if (ImageIEN = RadInfo.iIEN) then  // same image
        begin
          Result := (Result - RadInfo.radIGmapped) + RadInfo.radAnnotCount;
        end;
      end;
    end;
  except
    on E:Exception do
      magAppMsg('s', 'TMagAnnot.GetMarkCount_CurrentPage (pg # ' + IntToStr(CurrentPageNumber) + ') Error = ' + E.Message);
  end;
end;

Procedure TMagAnnot.SetAnnotationStyle(Const Value: TMagAnnotationStyle);
Begin
  FAnnotationStyle := Value;
End;

Function TMagAnnot.GetAnnotationStyle: TMagAnnotationStyle;
Begin
  Result := FAnnotationStyle;
End;

Procedure TMagAnnot.InitializeToolbar(AnnotationComponent: TAnnotationType; x, y: Integer);
Begin
  SelectedButtonIsDown(AnnotationComponent);
  Formstyle := Fsstayontop;
  Self.Left := x;
  Self.Top := y;
End;

Function TMagAnnot.SelectedButtonIsDown(action: TAction): Boolean;
Var
  FCurAnnotWas: TAnnotationType;
Begin
  Result := False;
  FCurAnnotWas := FCurAnnot;
  UncheckAllAnnots();

  If CurrentPage = Nil Then Exit;
  If IGArtXCtl = Nil Then Exit;
  If FIGPageViewCtl = Nil Then Exit;
  If Not CurrentPage.IsValid Then Exit;
  Try
    If Not FToolbarInitialized Then
    Begin
      IGArtXGUICtl.ToolbarVisible := True;
      IGArtXGUICtl.ToolbarVersion := True;
      IGArtXGUICtl.ToolbarVisible := False;
      FToolbarInitialized := True;
    End;
  Except
    On e: Exception Do
    Begin
      If Pos('The handle is invalid', e.Message) <> 0 Then
      Begin
        IGArtXGUICtl.ToolbarVisible := True;
        IGArtXGUICtl.ToolbarVersion := True;
        IGArtXGUICtl.ToolbarVisible := False;
      End
      Else
      Begin
        Raise;
      End;
    End;
  End;
  action.Checked := True;
//  btnAnnot00_SELECT.flat := actAnnot00_SELECT.Checked;
//  btnAnnot01_IMAGE_EMBEDDED.flat := actAnnot01_IMAGE_EMBEDDED.Checked;
//  btnAnnot02_IMAGE_REFERENCE.flat := actAnnot02_IMAGE_REFERENCE.Checked;
//  btnAnnot03_LINE.flat := actAnnot03_LINE.Checked;
//  btnAnnot04_FREEHAND_LINE.flat := actAnnot04_FREEHAND_LINE.Checked;
//  btnAnnot05_HOLLOW_RECTANGLE.flat := actAnnot05_HOLLOW_RECTANGLE.Checked;
//  btnAnnot06_FILLED_RECTANGLE.flat := actAnnot06_FILLED_RECTANGLE.Checked;
//  btnAnnot07_TYPED_TEXT.flat := actAnnot07_TYPED_TEXT.Checked;
//  btnAnnot08_TEXT_FROM_FILE.flat := actAnnot08_TEXT_FROM_FILE.Checked;
//  btnAnnot09_TEXT_STAMP.flat := actAnnot09_TEXT_STAMP.Checked;
//  btnAnnot10_ATTACH_A_NOTE.flat := actAnnot10_ATTACH_A_NOTE.Checked;
//  btnAnnot11_FILLED_POLYGON.flat := actAnnot11_FILLED_POLYGON.Checked;
//  btnAnnot12_HOLLOW_POLYGON.flat := actAnnot12_HOLLOW_POLYGON.Checked;
//  btnAnnot13_POLYLINE.flat := actAnnot13_POLYLINE.Checked;
//  btnAnnot14_AUDIO.flat := actAnnot14_AUDIO.Checked;
//  btnAnnot15_FILLED_ELLIPSE.flat := actAnnot15_FILLED_ELLIPSE.Checked;
//  btnAnnot16_HOLLOW_ELLIPSE.flat := actAnnot16_HOLLOW_ELLIPSE.Checked;
//  btnAnnot17_ARROW.flat := actAnnot17_ARROW.Checked;
//  btnAnnot18_HOTSPOT.flat := actAnnot18_HOTSPOT.Checked;
//  btnAnnot19_REDACTION.flat := actAnnot19_REDACTION.Checked;
//  btnAnnot20_ENCRYPTION.flat := actAnnot20_ENCRYPTION.Checked;
//  btnAnnot21_RULER.flat := actAnnot21_RULER.Checked;
//  btnAnnot22_PROTRACTOR.flat := actAnnot22_PROTRACTOR.Checked;
//  btnAnnot23_BUTTON.flat := actAnnot23_BUTTON.Checked;
//  btnAnnot24_PIN_UP_TEXT.flat := actAnnot24_PIN_UP_TEXT.Checked;
//  btnAnnot25_HIGHLIGHTER.flat := actAnnot25_HIGHLIGHTER.Checked;
//  btnAnnot26_RICH_TEXT.flat := actAnnot26_RICH_TEXT.Checked;
//  btnAnnot27_CALLOUT.flat := actAnnot27_CALLOUT.Checked;
//  btnAnnot28_RECTANGLE.flat := actAnnot28_RECTANGLE.Checked;
//  btnAnnot29_ELLIPSE.flat := actAnnot29_ELLIPSE.Checked;
//  btnAnnot30_POLYGON.flat := actAnnot30_POLYGON.Checked;
//  btnAnnot31_TEXT.flat := actAnnot31_TEXT.Checked;
//  btnAnnot32_IMAGE.flat := actAnnot32_IMAGE.Checked;
//  btnAnnot33_HOLLOW_SQUARE.flat := actAnnot33_HOLLOW_SQUARE.Checked;
//  btnAnnot34_FILLED_SQUARE.flat := actAnnot34_FILLED_SQUARE.Checked;
//  btnAnnot35_HOLLOW_CIRCLE.flat := actAnnot35_HOLLOW_CIRCLE.Checked;
//  btnAnnot36_FILLED_CIRCLE.flat := actAnnot36_FILLED_CIRCLE.Checked;
//  btnAnnot60_Options.flat := actAnnot60_Options.Checked;

  //Set CurAnnot Property
  If actAnnot00_SELECT.Checked Then FCurAnnot := Annot00_SELECT_;
  If actAnnot01_IMAGE_EMBEDDED.Checked Then FCurAnnot := Annot01_IMAGE_EMBEDDED_;
  If actAnnot02_IMAGE_REFERENCE.Checked Then FCurAnnot := Annot02_IMAGE_REFERENCE_;
  If actAnnot03_LINE.Checked Then FCurAnnot := Annot03_LINE_;
  If actAnnot04_FREEHAND_LINE.Checked Then FCurAnnot := Annot04_FREEHAND_LINE_;
  If actAnnot05_HOLLOW_RECTANGLE.Checked Then FCurAnnot := Annot05_HOLLOW_RECTANGLE_;
  If actAnnot06_FILLED_RECTANGLE.Checked Then FCurAnnot := Annot06_FILLED_RECTANGLE_;
  If actAnnot07_TYPED_TEXT.Checked Then FCurAnnot := Annot07_TYPED_TEXT_;
  If actAnnot08_TEXT_FROM_FILE.Checked Then FCurAnnot := Annot08_TEXT_FROM_FILE_;
  If actAnnot09_TEXT_STAMP.Checked Then FCurAnnot := Annot09_TEXT_STAMP_;
  If actAnnot10_ATTACH_A_NOTE.Checked Then FCurAnnot := Annot10_ATTACH_A_NOTE_;
  If actAnnot11_FILLED_POLYGON.Checked Then FCurAnnot := Annot11_FILLED_POLYGON_;
  If actAnnot12_HOLLOW_POLYGON.Checked Then FCurAnnot := Annot12_HOLLOW_POLYGON_;
  If actAnnot13_POLYLINE.Checked Then FCurAnnot := Annot13_POLYLINE_;
  If actAnnot14_AUDIO.Checked Then FCurAnnot := Annot14_AUDIO_;
  If actAnnot15_FILLED_ELLIPSE.Checked Then FCurAnnot := Annot15_FILLED_ELLIPSE_;
  If actAnnot16_HOLLOW_ELLIPSE.Checked Then FCurAnnot := Annot16_HOLLOW_ELLIPSE_;
  If actAnnot17_ARROW.Checked Then FCurAnnot := Annot17_ARROW_;
  If actAnnot18_HOTSPOT.Checked Then FCurAnnot := Annot18_HOTSPOT_;
  If actAnnot19_REDACTION.Checked Then FCurAnnot := Annot19_REDACTION_;
  If actAnnot20_ENCRYPTION.Checked Then FCurAnnot := Annot20_ENCRYPTION_;
  If actAnnot21_RULER.Checked Then FCurAnnot := Annot21_RULER_;
  If actAnnot22_PROTRACTOR.Checked Then FCurAnnot := Annot22_PROTRACTOR_;
  If actAnnot23_BUTTON.Checked Then FCurAnnot := Annot23_BUTTON_;
  If actAnnot24_PIN_UP_TEXT.Checked Then FCurAnnot := Annot24_PIN_UP_TEXT_;
  If actAnnot25_HIGHLIGHTER.Checked Then FCurAnnot := Annot25_HIGHLIGHTER_;
  If actAnnot26_RICH_TEXT.Checked Then FCurAnnot := Annot26_RICH_TEXT_;
  If actAnnot27_CALLOUT.Checked Then FCurAnnot := Annot27_CALLOUT_;
  If actAnnot28_RECTANGLE.Checked Then FCurAnnot := Annot28_RECTANGLE_;
  If actAnnot29_ELLIPSE.Checked Then FCurAnnot := Annot29_ELLIPSE_;
  If actAnnot30_POLYGON.Checked Then FCurAnnot := Annot30_POLYGON_;
  If actAnnot31_TEXT.Checked Then FCurAnnot := Annot31_TEXT_;
  If actAnnot32_IMAGE.Checked Then FCurAnnot := Annot32_IMAGE_;
  If actAnnot33_HOLLOW_SQUARE.Checked Then FCurAnnot := Annot33_HOLLOW_SQUARE_;
  If actAnnot34_FILLED_SQUARE.Checked Then FCurAnnot := Annot34_FILLED_SQUARE_;
  If actAnnot35_HOLLOW_CIRCLE.Checked Then FCurAnnot := Annot35_HOLLOW_CIRCLE_;
  If actAnnot36_FILLED_CIRCLE.Checked Then FCurAnnot := Annot36_FILLED_CIRCLE_;
  If actAnnot60_Options.Checked Then FCurAnnot := Annot60_Options_;
  Result := (FCurAnnot <> FCurAnnotWas);
  GetEditMode();
End;

Function TMagAnnot.SelectedButtonIsDown(action: TAnnotationType): Boolean;
Begin
  Result := False;
  Case action Of
    Annot00_SELECT_: Result := SelectedButtonIsDown(actAnnot00_SELECT);
    Annot01_IMAGE_EMBEDDED_: Result := SelectedButtonIsDown(actAnnot01_IMAGE_EMBEDDED);
    Annot02_IMAGE_REFERENCE_: Result := SelectedButtonIsDown(actAnnot02_IMAGE_REFERENCE);
    Annot03_LINE_: Result := SelectedButtonIsDown(actAnnot03_LINE);
    Annot04_FREEHAND_LINE_: Result := SelectedButtonIsDown(actAnnot04_FREEHAND_LINE);
    Annot05_HOLLOW_RECTANGLE_: Result := SelectedButtonIsDown(actAnnot05_HOLLOW_RECTANGLE);
    Annot06_FILLED_RECTANGLE_: Result := SelectedButtonIsDown(actAnnot06_FILLED_RECTANGLE);
    Annot07_TYPED_TEXT_: Result := SelectedButtonIsDown(actAnnot07_TYPED_TEXT);
    Annot08_TEXT_FROM_FILE_: Result := SelectedButtonIsDown(actAnnot08_TEXT_FROM_FILE);
    Annot09_TEXT_STAMP_: Result := SelectedButtonIsDown(actAnnot09_TEXT_STAMP);
    Annot10_ATTACH_A_NOTE_: Result := SelectedButtonIsDown(actAnnot10_ATTACH_A_NOTE);
    Annot11_FILLED_POLYGON_: Result := SelectedButtonIsDown(actAnnot11_FILLED_POLYGON);
    Annot12_HOLLOW_POLYGON_: Result := SelectedButtonIsDown(actAnnot12_HOLLOW_POLYGON);
    Annot13_POLYLINE_: Result := SelectedButtonIsDown(actAnnot13_POLYLINE);
    Annot14_AUDIO_: Result := SelectedButtonIsDown(actAnnot14_AUDIO);
    Annot15_FILLED_ELLIPSE_: Result := SelectedButtonIsDown(actAnnot15_FILLED_ELLIPSE);
    Annot16_HOLLOW_ELLIPSE_: Result := SelectedButtonIsDown(actAnnot16_HOLLOW_ELLIPSE);
    Annot17_ARROW_: Result := SelectedButtonIsDown(actAnnot17_ARROW);
    Annot18_HOTSPOT_: Result := SelectedButtonIsDown(actAnnot18_HOTSPOT);
    Annot19_REDACTION_: Result := SelectedButtonIsDown(actAnnot19_REDACTION);
    Annot20_ENCRYPTION_: Result := SelectedButtonIsDown(actAnnot20_ENCRYPTION);
    Annot21_RULER_: Result := SelectedButtonIsDown(actAnnot21_RULER);
    Annot22_PROTRACTOR_: Result := SelectedButtonIsDown(actAnnot22_PROTRACTOR);
    Annot23_BUTTON_: Result := SelectedButtonIsDown(actAnnot23_BUTTON);
    Annot24_PIN_UP_TEXT_: Result := SelectedButtonIsDown(actAnnot24_PIN_UP_TEXT);
    Annot25_HIGHLIGHTER_: Result := SelectedButtonIsDown(actAnnot25_HIGHLIGHTER);
    Annot26_RICH_TEXT_: Result := SelectedButtonIsDown(actAnnot26_RICH_TEXT);
    Annot27_CALLOUT_: Result := SelectedButtonIsDown(actAnnot27_CALLOUT);
    Annot28_RECTANGLE_: Result := SelectedButtonIsDown(actAnnot28_RECTANGLE);
    Annot29_ELLIPSE_: Result := SelectedButtonIsDown(actAnnot29_ELLIPSE);
    Annot30_POLYGON_: Result := SelectedButtonIsDown(actAnnot30_POLYGON);
    Annot31_TEXT_: Result := SelectedButtonIsDown(actAnnot31_TEXT);
    Annot32_IMAGE_: Result := SelectedButtonIsDown(actAnnot32_IMAGE);
    Annot33_HOLLOW_SQUARE_: Result := SelectedButtonIsDown(actAnnot33_HOLLOW_SQUARE);
    Annot34_FILLED_SQUARE_: Result := SelectedButtonIsDown(actAnnot34_FILLED_SQUARE);
    Annot35_HOLLOW_CIRCLE_: Result := SelectedButtonIsDown(actAnnot35_HOLLOW_CIRCLE);
    Annot36_FILLED_CIRCLE_: Result := SelectedButtonIsDown(actAnnot36_FILLED_CIRCLE);
    Annot60_Options_: Result := SelectedButtonIsDown(actAnnot60_Options);
  End;
End;

Procedure TMagAnnot.ClearSelectedAnnotations;
Begin
  actEditDeleteSelectedAllExecute(Nil);
End;

Procedure TMagAnnot.actEditUndoExecute(Sender: Tobject);
Begin
  Undo();
End;

Function TMagAnnot.Undo: Boolean;
Begin
  Result := False;
  If Not IsValidEnv() Then
    Exit;
  If Not ArtPageList[Page-1].ArtPage.UndoEnabled Then
    Exit;
  If ArtPageList[Page-1].ArtPage.UndoCount = 0 Then
    Exit;
  ArtPageList[Page-1].ArtPage.UndoRollBack();
  IGPageViewCtl.UpdateView();
  Result := True;
  RefreshAnnotInfoBar;
End;

Function TMagAnnot.ClipboardAction(action: TMagAnnotClipboardActions): Boolean;
Var
  boProcessed: Boolean;
  Count: Integer;
  CurMark: IIGArtXMark;
  iter: Integer;
  MarkArray: IIGArtXMarkArray;
Begin
  Result := False;
  If Not IsValidEnv() Then
    Exit;
  If ArtPageList[Page-1].ArtPage.MarkCount = 0 Then
  begin
    Showmessage('There are no annotations on this page to delete');
    Exit;
  end;

  //p122 dmmn 7/28 - these lines are not necessary since we only use this function
  //for cut all and copy all. no need to check for selected marks. Should cleanun
  // this function later
  Count := 0;
  iter := 0;
  MarkArray := IGArtXCtl.CreateObject(IG_ARTX_OBJ_MARK_ARRAY) As IIGArtXMarkArray;
//  CurMark := ArtPageList[Page-1].ArtPage.MarkSelectedFirst;
  CurMark := ArtPageList[Page-1].ArtPage.MarkFirst;
  If CurMark = nil Then
  begin
//    Showmessage('Select an annotation to delete');
    ShowMessage('There is no annotation to delete');
    Exit;
  end;

  ArtPageList[Page-1].ArtPage.SelectMarks(False);
  while (CurMark <> nil) do
  begin
    MarkArray.Resize(Count+1);
    MarkArray.Item[Count] := CurMark;
    ArtPageList[Page-1].ArtPage.MarkSelect(CurMark,True);
    CurMark := ArtPageList[Page-1].ArtPage.MarkNext(CurMark);
    Count := count + 1;
  end;
//
//  While (Not (CurMark = Nil)) Do
//  Begin
//    CurMark := ArtPageList[Page-1].ArtPage.MarkSelectedNext(CurMark);
//    Count := Count + 1;
//  End;
//  MarkArray.Resize(Count);
//
//  CurMark := ArtPageList[Page-1].ArtPage.MarkSelectedFirst;
//  While (Not (CurMark = Nil)) Do
//  Begin
//    MarkArray.Item[iter] := CurMark;
//    CurMark := ArtPageList[Page-1].ArtPage.MarkSelectedNext(CurMark);
//    iter := iter + 1;
//  End;
  boProcessed := True;

  Case action Of
    AnnotCopyAll:     ArtPageList[Page-1].ArtPage.CopyMarksArray(MarkArray);
//    AnnotCopyFirst:   ArtPageList[Page-1].ArtPage.MarkCopy(MarkArray.Item[0]);
//    AnnotCopyLast:    ArtPageList[Page-1].ArtPage.MarkCopy(MarkArray.Item[MarkArray.Size - 1]);
    AnnotCutAll:      begin
                        if CanUserModifyAllMarks(MarkArray) then
                          ArtPageList[Page-1].ArtPage.CutMarksArray(MarkArray)
                        else
                          Showmessage('You do not have privilege to cut annotations made by another user');
                      end;
//    AnnotCutFirst:    begin
//                        if CanUserModifyMark(MarkArray.Item[0]) then
//                          ArtPageList[Page-1].ArtPage.MarkCut(MarkArray.Item[0])
//                        else
//                          Showmessage('You do not have privilege to cut the selected annotation because it was created by another user');
//                      end;
//    AnnotCutLast:     ArtPageList[Page-1].ArtPage.MarkCut(MarkArray.Item[MarkArray.Size - 1]);
//    AnnotDeleteAll:   begin
//                        if CanUserModifyAllMarks(MarkArray) then
//                          ArtPageList[Page-1].ArtPage.RemoveMarksArray(MarkArray)
//                        else
//                          Showmessage('You do not have privilege to delete annotations made by another user');
//                      end;
//    AnnotDeleteFirst: begin
//                        if CanUserModifyMark(MarkArray.Item[0]) then
//                          ArtPageList[Page-1].ArtPage.MarkRemove(MarkArray.Item[0])
//                        else
//                          Showmessage('You do not have privilege to delete the selected annotation because it was created by another user');
//                      end;
//    AnnotDeleteLast:  ArtPageList[Page-1].ArtPage.MarkRemove(MarkArray.Item[MarkArray.Size - 1]);
  Else
    boProcessed := False;
  End;
  IGPageViewCtl.UpdateView;
  Result := boProcessed;
  RefreshAnnotInfoBar;
  FAnnotsModified := True;
End;

Function TMagAnnot.Cut: Boolean;
Begin
  Result := ClipboardAction(AnnotCutAll);
  RefreshAnnotInfoBar;
  FAnnotsModified := True;
End;

procedure TMagAnnot.Cut1Click(Sender: TObject);
begin
  Cut;
end;

Procedure TMagAnnot.actEditCutSelectedAllExecute(Sender: Tobject);
Begin
  Cut;
End;

Procedure TMagAnnot.actEditCutSelectedFirstExecute(Sender: Tobject);
Begin
  CutFirstSelected();
End;

Procedure TMagAnnot.actEditCutSelectedLastExecute(Sender: Tobject);
Begin
  CutLastSelected();
End;

Function TMagAnnot.CutFirstSelected: Boolean;
Begin
  Result := ClipboardAction(AnnotCutFirst);
End;

Function TMagAnnot.CutLastSelected: Boolean;
Begin
  Result := ClipboardAction(AnnotCutLast);
End;

Procedure TMagAnnot.actEditDeleteSelectedAllExecute(Sender: Tobject);
Begin
  ClipboardAction(AnnotDeleteAll);
End;

Procedure TMagAnnot.actEditDeleteSelectedFirstExecute(Sender: Tobject);
Begin
  ClipboardAction(AnnotDeleteFirst);
End;

Procedure TMagAnnot.actEditDeleteSelectedLastExecute(Sender: Tobject);
Begin
  ClipboardAction(AnnotDeleteLast);
End;

Function TMagAnnot.Copy: Boolean;
Begin
  Result := ClipboardAction(AnnotCopyAll);
End;

Function TMagAnnot.CopyFirstSelected: Boolean;
Begin
  Result := ClipboardAction(AnnotCopyFirst);
End;

Function TMagAnnot.CopyLastSelected: Boolean;
Begin
  Result := ClipboardAction(AnnotCopyLast);
End;

Procedure TMagAnnot.actEditCopySelectedAllExecute(Sender: Tobject);
Begin
  Copy();
End;

Procedure TMagAnnot.actEditCopySelectedFirstExecute(Sender: Tobject);
Begin
  CopyFirstSelected();
End;

Procedure TMagAnnot.actEditCopySelectedLastExecute(Sender: Tobject);
Begin
  CopyLastSelected();
End;

Procedure TMagAnnot.actEditPasteExecute(Sender: Tobject);
Begin
  Paste();
End;

Function TMagAnnot.Paste: Boolean;
Begin
  Result := False;
  If Not IsValidEnv() Then
    Exit;
  If ArtPageList[Page-1].ArtPage.PasteCount = 0 Then Exit;

  ArtPageList[Page-1].ArtPage.PasteMarks();
  Result := True;

  RefreshAnnotInfoBar;
  FAnnotsModified := True;

  //p122 dmmn 7/26/11 - update view after pasted
  IGPageViewCtl.UpdateView;
End;

procedure TMagAnnot.PostCreateMarkRuler(IGMark: IIGArtXMark);
begin
  {/p122 dmmn 7/12/11 - added post create method to launch calibration when there
  is no predefined aspect ratio for the ruler /}
//  if ArtPage <> nil then
  if ArtPageList[Page-1].ArtPage <> nil then
    if DicomAspectRatio = nil then  // only ask for calibration after create if not dicom image
      if RulerActualAspectRatio = nil then
      begin
        ArtPageList[Page-1].ArtPage.SelectMarks(False);
        ArtPageList[Page-1].ArtPage.MarkSelect(IGMark,True);
        IGPageViewCtl.UpdateView;
        actRulerCalibrateExecute(nil);

        //p122t3 dmmn 9/16 deselect the newly created ruler
        ArtPageList[Page-1].ArtPage.MarkSelect(IGMark,False);
      end;

  IGPageViewCtl.UpdateView;
end;

procedure TMagAnnot.PostCreateMarkText(IGMark: IIGArtXMark);
var
  temp : string;
begin
  {/p122t3 dmmn 9/19 - if the text is empty then put the default text in /}
  if (IGMark as IIGArtXText).Text = '' then
    (IGMark as IIGArtXText).Text := 'Enter Text Here';
  //p122t11b dmmn - popup a message say these characters are illegal
  if (AnsiPos('&', (IGMark as IIGArtXText).Text) > 0) or
     (AnsiPos('>', (IGMark as IIGArtXText).Text) > 0) or
     (AnsiPos('<', (IGMark as IIGArtXText).Text) > 0) then
  begin
    MagAppMsg('d','The following characters & < > are not supported. Please modify your input.');
    ArtPage.MarkSelect(IGMark, true);
    actTool_MarkPropertyEditorExecute(nil);
  end;

  //p122t11b - worst case the text escaped the editor somehow (open another image while annotating), we replace them
  if (AnsiPos('&', (IGMark as IIGArtXText).Text) > 0) or
     (AnsiPos('>', (IGMark as IIGArtXText).Text) > 0) or
     (AnsiPos('<', (IGMark as IIGArtXText).Text) > 0) then
  begin
    //p122t11 dmmn 1/24 - replace illegal text
    temp := (IGMark as IIGArtXText).Text;
    temp := StringReplace(temp, '<', 'less than',[rfReplaceAll, rfIgnoreCase]);
    temp := StringReplace(temp, '>', 'greater than',[rfReplaceAll, rfIgnoreCase]);
    temp := StringReplace(temp, '&', 'and',[rfReplaceAll, rfIgnoreCase]);
    (IGMark as IIGArtXText).Text := temp;
  end;

  {/p122t2 - wrap boundary of new text /}
  (IGMark as IIGArtXText).BoundsWrap :=  3;
end;

Procedure TMagAnnot.actEditSelectAllExecute(Sender: Tobject);
Begin
  SelectAll();
End;

procedure TMagAnnot.SaveUserPreferences1Click(Sender: TObject);
begin
  Showmessage('TBD: Saving user preferences to VistA');
end;

Function TMagAnnot.SelectAll: Boolean;
Var
  CurMark: IIGArtXMark;
Begin
  Result := False;
  If Not IsValidEnv() Then
    Exit;
  CurMark := ArtPageList[Page-1].ArtPage.MarkFirst;
  While (Not (CurMark = Nil)) Do
  Begin

    { If the user does a SelectAll go through every mark and determine
      if the user can modify it. Set the Readonly indicator if not and
      the mode to View Only - JK 8/31/2011 /}
    if CanUserModifyMark(CurMark) = False then
    begin
        GetIGManager.IGArtXGUICtl.Mode := IG_ARTX_GUI_MODE_VIEW;
        imgReadOnly.Visible := True;
    end;

    Result := True;
    ArtPageList[Page-1].ArtPage.MarkSelect(CurMark, True);
    CurMark := ArtPageList[Page-1].ArtPage.Marknext(CurMark);
  End;
  IGPageViewCtl.UpdateView;

  {/p122 dmmn 8/17 - disable the individual mark settings if multiple marks are selected /}
  btnMarkSettings.Enabled := False;
End;

Procedure TMagAnnot.SetArrowPointer(aPointer: TMagAnnotationArrowType);
Begin
  Case aPointer Of
    MagAnnArrowPointer: frmAnnotOptionsX.ArrowPointerStyle := 0;
    MagAnnArrowSolid: frmAnnotOptionsX.ArrowPointerStyle := 1;
    MagAnnArrowOpen: frmAnnotOptionsX.ArrowPointerStyle := 2;
    MagAnnArrowPointerSolid: frmAnnotOptionsX.ArrowPointerStyle := 3;
    MagAnnArrowNone: frmAnnotOptionsX.ArrowPointerStyle := 4;
  End;
End;

Procedure TMagAnnot.SetArrowLength(ArrowLength: TMagAnnotationArrowSize);
Begin
  Case ArrowLength Of
    MagAnnArrowSizeSmall: frmAnnotOptionsX.ArrowPointerLength := 20;
    MagAnnArrowSizeMedium: frmAnnotOptionsX.ArrowPointerLength := 40;
    MagAnnArrowSizeLarge: frmAnnotOptionsX.ArrowPointerLength := 60;
  End;
End;

Procedure TMagAnnot.SetOpaque(IsOpaque: Boolean);
Begin
  If frmAnnotOptionsX.Opacity <> 255 Then
  Begin
    If IsOpaque Then frmAnnotOptionsX.Opacity := 255;
  End
  Else
  Begin
    If Not IsOpaque Then frmAnnotOptionsX.Opacity := 128;
  End;
End;

Procedure TMagAnnot.SetLineWidth(Width: TMagAnnotationLineWidth);
Begin
  Case Width Of
    MagAnnLineWidthThin: frmAnnotOptionsX.LineWidth := 2;
    MagAnnLineWidthMedium: frmAnnotOptionsX.LineWidth := 5;
    MagAnnLineWidthThick: frmAnnotOptionsX.LineWidth := 10;
  End;
End;

Procedure TMagAnnot.SetTool(NewTool: TMagAnnotationToolType);
Begin
  Case NewTool Of
    MagAnnToolArrow: actAnnot17_ARROWExecute(Nil);
    MagAnnToolFilledEllipse: actAnnot15_FILLED_ELLIPSEExecute(Nil);
    MagAnnToolFilledRectangle: actAnnot06_FILLED_RECTANGLEExecute(Nil);
    MagAnnToolFreehandLine: actAnnot04_FREEHAND_LINEExecute(Nil);
    MagAnnToolHollowEllipse: actAnnot16_HOLLOW_ELLIPSEExecute(Nil);
    MagAnnToolHollowRectangle: actAnnot05_HOLLOW_RECTANGLEExecute(Nil);
    MagAnnToolMinus: actAnnot03_LINEExecute(Nil);
    MagAnnToolPlus: actAnnot03_LINEExecute(Nil);
    MagAnnToolPointer: actAnnot00_SELECTExecute(Nil);
    MagAnnToolProtractor: actAnnot22_PROTRACTORExecute(Nil);
    MagAnnToolRuler: actAnnot21_RULERExecute(Nil);
    MagAnnToolStraightLine: actAnnot03_LINEExecute(Nil);
    MagAnnToolTypedText: actAnnot07_TYPED_TEXTExecute(Nil);
    MagAnnTool_00_SELECT: actAnnot00_SELECTExecute(Nil);
    MagAnnTool_01_IMAGE_EMBEDDED: actAnnot01_IMAGE_EMBEDDEDExecute(Nil);
    MagAnnTool_02_IMAGE_REFERENCE: actAnnot02_IMAGE_REFERENCEExecute(Nil);
    MagAnnTool_03_LINE: actAnnot03_LINEExecute(Nil);
    MagAnnTool_04_FREEHAND_LINE: actAnnot04_FREEHAND_LINEExecute(Nil);
    MagAnnTool_05_HOLLOW_RECTANGLE: actAnnot05_HOLLOW_RECTANGLEExecute(Nil);
    MagAnnTool_06_FILLED_RECTANGLE: actAnnot06_FILLED_RECTANGLEExecute(Nil);
    MagAnnTool_07_TYPED_TEXT: actAnnot07_TYPED_TEXTExecute(Nil);
    MagAnnTool_08_TEXT_FROM_FILE: actAnnot08_TEXT_FROM_FILEExecute(Nil);
    MagAnnTool_09_TEXT_STAMP: actAnnot09_TEXT_STAMPExecute(Nil);
    MagAnnTool_10_ATTACH_A_NOTE: actAnnot10_ATTACH_A_NOTEExecute(Nil);
    MagAnnTool_11_FILLED_POLYGON: actAnnot11_FILLED_POLYGONExecute(Nil);
    MagAnnTool_12_HOLLOW_POLYGON: actAnnot12_HOLLOW_POLYGONExecute(Nil);
    MagAnnTool_13_POLYLINE: actAnnot13_POLYLINEExecute(Nil);
    MagAnnTool_14_AUDIO: actAnnot14_AUDIOExecute(Nil);
    MagAnnTool_15_FILLED_ELLIPSE: actAnnot15_FILLED_ELLIPSEExecute(Nil);
    MagAnnTool_16_HOLLOW_ELLIPSE: actAnnot16_HOLLOW_ELLIPSEExecute(Nil);
    MagAnnTool_17_ARROW: actAnnot17_ARROWExecute(Nil);
    MagAnnTool_18_HOTSPOT: actAnnot18_HOTSPOTExecute(Nil);
    MagAnnTool_19_REDACTION: actAnnot19_REDACTIONExecute(Nil);
    MagAnnTool_20_ENCRYPTION: actAnnot20_ENCRYPTIONExecute(Nil);
    MagAnnTool_21_RULER: actAnnot21_RULERExecute(Nil);
    MagAnnTool_22_PROTRACTOR: actAnnot22_PROTRACTORExecute(Nil);
    MagAnnTool_23_BUTTON: actAnnot23_BUTTONExecute(Nil);
    MagAnnTool_24_PIN_UP_TEXT: actAnnot24_PIN_UP_TEXTExecute(Nil);
    MagAnnTool_25_HIGHLIGHTER: actAnnot25_HIGHLIGHTERExecute(Nil);
    MagAnnTool_26_RICH_TEXT: actAnnot26_RICH_TEXTExecute(Nil);
    MagAnnTool_27_CALLOUT: actAnnot27_CALLOUTExecute(Nil);
    MagAnnTool_28_RECTANGLE: actAnnot28_RECTANGLEExecute(Nil);
    MagAnnTool_29_ELLIPSE: actAnnot29_ELLIPSEExecute(Nil);
    MagAnnTool_30_POLYGON: actAnnot30_POLYGONExecute(Nil);
    MagAnnTool_31_TEXT: actAnnot31_TEXTExecute(Nil);
    MagAnnTool_32_IMAGE: actAnnot32_IMAGEExecute(Nil);
    MagAnnTool_33_HOLLOW_SQUARE: actAnnot33_HOLLOW_SQUAREExecute(Nil);
    MagAnnTool_34_FILLED_SQUARE: actAnnot34_FILLED_SQUAREExecute(Nil);
    MagAnnTool_35_HOLLOW_CIRCLE: actAnnot35_HOLLOW_CIRCLEExecute(Nil);
    MagAnnTool_36_FILLED_CIRCLE: actAnnot36_FILLED_CIRCLEExecute(Nil);
    MagAnnTool_60_Options: actAnnot60_OptionsExecute(Nil);
  End;
End;

Function TMagAnnot.GetFont(): TFont;
Var
  aFont: TFont;
Begin
  aFont := TFont.Create();
  aFont.Size := frmAnnotOptionsX.FontSize;
  aFont.Name := frmAnnotOptionsX.FontName;
  If frmAnnotOptionsX.Fontbold And frmAnnotOptionsX.FontItalic Then
  Begin
    aFont.Style := [Fsbold, Fsitalic];
  End
  Else
    If frmAnnotOptionsX.Fontbold And (Not frmAnnotOptionsX.FontItalic) Then
    Begin
      aFont.Style := [Fsbold];
    End
    Else
      If (Not frmAnnotOptionsX.Fontbold) And frmAnnotOptionsX.FontItalic Then
      Begin
        aFont.Style := [Fsitalic];
      End;
  aFont.Color := frmAnnotOptionsX.FontColor;
  Result := aFont;
End;

Function TMagAnnot.GetColor: TColor;
Begin
  Result := frmAnnotOptionsX.AnnotBorderColor;
End;

Procedure TMagAnnot.SetAnnotationColor(aColor: TColor);
Begin
  frmAnnotOptionsX.AnnotBorderColor := aColor;
End;

Procedure TMagAnnot.SetArrowHead(IGMark: IIGArtXArrow);
Var
  IGArrowHead: IIGArtXArrowHead;
Begin
  try
    If frmAnnotOptionsX.ArrowPointerLength < 5 Then
      frmAnnotOptionsX.ArrowPointerLength := 5;
    If frmAnnotOptionsX.ArrowPointerLength > 200 Then
      frmAnnotOptionsX.ArrowPointerLength := 200;
    If frmAnnotOptionsX.ArrowPointerAngle < 5 Then
      frmAnnotOptionsX.ArrowPointerAngle := 5;
    If frmAnnotOptionsX.ArrowPointerAngle > 60 Then
      frmAnnotOptionsX.ArrowPointerAngle := 60;

      magAppMsg('s','SetArrowHead: ArrowPointerLength='+Inttostr(frmAnnotOptionsX.ArrowPointerLength) +
                       ' ArrowPointerAngle='+inttostr(frmAnnotOptionsX.arrowpointerangle) +
                       ' ArrowPointerStyle='+inttostr(frmAnnotOptionsX.arrowpointerstyle));

    IGArrowHead        := IGArtXCtl.CreateObject(IG_ARTX_OBJ_ARROWHEAD) As IIGArtXArrowHead;
    IGArrowHead.Style  := frmAnnotOptionsX.ArrowPointerStyle;
    IGArrowHead.Length := frmAnnotOptionsX.ArrowPointerLength;
    IGArrowHead.Angle  := frmAnnotOptionsX.ArrowPointerAngle;
    IGMark.SetHead(IGArrowHead);
  except
    on E:Exception do
      magAppMsg('s', 'TMagAnnot.SetArrowHead error = ' + E.Message);
  end;
End;

procedure TMagAnnot.SetArrowHead(IGMark: IIGArtXLine);
Var
  IGArrowHead: IIGArtXArrowHead;
  IGArrowEnd: IIGArtXArrowHead;
begin
  //p122 dmmn 7/12/11 - update values and style
  If frmAnnotOptionsX.ArrowPointerLength < 10 Then
    frmAnnotOptionsX.ArrowPointerLength := 10;
  If frmAnnotOptionsX.ArrowPointerLength > 200 Then
    frmAnnotOptionsX.ArrowPointerLength := 200;
  If frmAnnotOptionsX.ArrowPointerAngle < 10 Then
    frmAnnotOptionsX.ArrowPointerAngle := 10;
  If frmAnnotOptionsX.ArrowPointerAngle > 60 Then
    frmAnnotOptionsX.ArrowPointerAngle := 60;

  IGArrowHead := IGArtXCtl.CreateObject(IG_ARTX_OBJ_ARROWHEAD) As IIGArtXArrowHead;
  IGArrowHead.Style := frmAnnotOptionsX.ArrowPointerStyle;
  IGArrowHead.Length := frmAnnotOptionsX.ArrowPointerLength;
  IGArrowHead.Angle := frmAnnotOptionsX.ArrowPointerAngle;
  //p122 dmmn 8/2/11 - added on request that the arrow head will be at the end of the arrow
//  IGMark.SetStartHead(IGArrowHead);
  IGMark.SetEndHead(IGArrowHead);

  {/P122 DMMN 6/27/2011 - Set No EndHead /}
  IGArrowEnd := IGArtXCtl.CreateObject(IG_ARTX_OBJ_ARROWHEAD) As IIGArtXArrowHead;
  IGArrowEnd.Style := IG_ARTX_ARROW_NONE;
//  IGMark.SetEndHead(IGArrowEnd);
  IGMark.SetStartHead(IGArrowEnd);
end;

{/ P122 - JK 5/30/2011 - implementing Duc's technique to keep a mark in bounds of an image /}
procedure TMagAnnot.IGPageViewCtlMouseDown(ASender: Tobject; Button, Shift: Smallint; x, y: Integer);
var
  tempPoint : IIGPoint;
  inImage : Boolean;
  hitParams : IGArtXHitTestParams;
  nMessage: Integer;
  CurMark : IIGArtXMark;
begin
  inherited;

  imgReadOnly.Visible := False;

  if Not IsValidEnv then
    Exit;

  if Button = 2 then //p122 dmmn 7/13/11 - forbid right click
    Exit;

  igCurPoint.XPos := x;
  igCurPoint.YPos := y;

  // check to see if the click position is inside the image
  tempPoint := IGCoreCtl.CreateObject(IG_OBJ_POINT) As IIGPoint;
  tempPoint.XPos := x;
  tempPoint.YPos := y;

  IGPageViewCtl.PageDisplay.ConvertPointCoordinates(IGPageViewCtl.hWnd, 0, tempPoint, IG_DSPL_CONV_DEVICE_TO_IMAGE);

  inImage := not ((tempPoint.XPos < 0) or (tempPoint.XPos > CurrentPage.ImageWidth) or
                  (tempPoint.YPos < 0) or (tempPoint.YPos > CurrentPage.ImageHeight));

  // only act when the click is inside the image
  if inImage then
  begin
    {/p122t4 dmmn 9/30 - deselect all marks before creating new marks because in case there's
    a mark that you can't edit, the view won't be switch to viewonly mode and disable subsequence clicks /}
    if (CurAnnot <> Annot00_SELECT_) then
      UnSelectAllMarks;

    {/p122 dmmn 7/28/11 - prototyping on fixing the protractor tool /}
    if (CurAnnot = Annot22_PROTRACTOR_) and (ProtractorClickCount < 3) then
    begin
      {/p122t4 dmmn 9/28 - in case of vistaRAD, the view is read only so we have to turn
      it back to edit to be able to create new one. /}
      
      //p122t15 dod
      if (RADPackage or IsDODImage) and (GetIGManager.IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT)  then
        GetIGManager.IGArtXGUICtl.Mode := IG_ARTX_GUI_MODE_EDIT;
      
      inc(ProtractorClickCount);

      IgCurPoint.XPos := x;
      IgCurPoint.YPos := y;
      nMessage := WM_LBUTTONDOWN;
      If (Button = 2) Then
        nMessage := WM_RBUTTONDOWN;

      GetIGManager.IGArtXGUICtl.MouseDown(IGArtDrawParams, nMessage, IgCurPoint);

      Exit;
    end;

    if (CurAnnot = Annot22_PROTRACTOR_) and (ProtractorClickCount >= 3) then
    begin
      actAnnot00_SELECTExecute(nil);
      Exit;
    end;

    {Start off by assuming there are no permission restrictions}
    GetIGManager.IGArtXGUICtl.Mode := IG_ARTX_GUI_MODE_EDIT;

    hitParams := ArtPageList[Page-1].ArtPage.HitTest(igartDrawParams, igCurPoint, 0);

    if (hitParams.Result <> IG_ARTX_HITTEST_NONE) then //if click anywhere in or on a mark
    begin

      markTest := hitParams.Mark;
      offsetLeft := tempPoint.XPos - markTest.GetBounds.Left;
      offsetRight := markTest.GetBounds.Right - tempPoint.XPos;
      offsetTop := tempPoint.YPos - markTest.GetBounds.Top;
      offsetBottom := markTest.GetBounds.Bottom - tempPoint.YPos;


      {If the user clicks one mark, restrict moving or resizing some other user's
       mark unless they have the MagAnnotation key}
      if CanUserModifyMark(hitParams.Mark) = False then
      begin
        ArtPageList[Page-1].ArtPage.SelectMarks(False);
        ArtPageList[Page-1].ArtPage.MarkSelect(hitParams.Mark,True);  //p122t4 dmmn 9/30 show the outline for the hitmark
        GetIGManager.IGArtXGUICtl.Mode := IG_ARTX_GUI_MODE_VIEW;
        imgReadOnly.Visible := True;
        IGPageViewCtl.UpdateView;
        Exit; //p122 dmmn 8/19 - quit here
      end;

      {/ p122 dmmn 7/28/11 - show the selected outline on mark /}
      CurMark := ArtPageList[Page-1].ArtPage.MarkSelectedFirst;
      if CurMark = nil then     // if there's nothing selected before
      begin
        ArtPageList[Page-1].ArtPage.MarkSelect(hitParams.Mark,True);
        IGPageViewCtl.UpdateView;
      end
      else
      begin
        CurMark := ArtPageList[Page-1].ArtPage.MarkSelectedNext(CurMark);
        if CurMark = nil then    // if there's only one selected
        begin
          ArtPageList[Page-1].ArtPage.SelectMarks(False);
          ArtPageList[Page-1].ArtPage.MarkSelect(hitParams.Mark,True);
          IGPageViewCtl.UpdateView;
        end
        else
        begin
          // if there are multiple selected and click on a unselected mark will
          // deselect the other and select the new mark
          if Not ArtPageList[Page-1].ArtPage.MarkIsSelected(hitParams.Mark) then
          begin
            ArtPageList[Page-1].ArtPage.SelectMarks(False);
            ArtPageList[Page-1].ArtPage.MarkSelect(hitParams.Mark,True);
            IGPageViewCtl.UpdateView;
          end;
        end;
      end;
    end
    else                                                 // if click on image
      markTest := nil;


    IgCurPoint.XPos := x;
    IgCurPoint.YPos := y;
    nMessage := WM_LBUTTONDOWN;
    If (Button = 2) Then
      nMessage := WM_RBUTTONDOWN;

    {/p122t4 a check to see if the point belong to any of the selected marks /}
    if ArtPageList[Page-1].ArtPage.MarkSelectedFirst <> nil then
    begin
      if Not CanUserModifyPoint(IgCurPoint) then
        Exit;
    end;


    if Not FIsInHistoryView then        //p122t2 dmmn 9/2 - current history, no restriction
      GetIGManager.IGArtXGUICtl.MouseDown(IGArtDrawParams, nMessage, IgCurPoint)
    else
    begin
      {/p122t2 dmmn 9/6/11 - CQ:IMAG00000783 -
      in history view, only allow user to drag and select or click and select even for MGR key user /}
      if markTest = nil then
        GetIGManager.IGArtXGUICtl.MouseDown(IGArtDrawParams, nMessage, IgCurPoint)
    end;


  end;
//
  curMark := nil;
  tempPoint := nil;
end;




{/ P122 - JK 5/30/2011 - implementing Duc's technique to keep a mark in bounds of an image /}
procedure TMagAnnot.IGPageViewCtlMouseMove(ASender: Tobject; Button, Shift: Smallint; x, y: Integer);
var
  tempPoint : IIGPoint;
  inImage : Boolean;
  markIn : Boolean;
begin
  // check to see if the click position is inside the image
  tempPoint := IGCoreCtl.CreateObject(IG_OBJ_POINT) As IIGPoint;
  tempPoint.XPos := x;
  tempPoint.YPos := y;

  IGPageViewCtl.PageDisplay.ConvertPointCoordinates(IGPageViewCtl.hWnd, 0, tempPoint, IG_DSPL_CONV_DEVICE_TO_IMAGE);

  inImage := not ((tempPoint.XPos < 0) or (tempPoint.XPos > CurrentPage.ImageWidth) or
                  (tempPoint.YPos < 0) or (tempPoint.YPos > CurrentPage.ImageHeight));

  if inImage then
  begin
    if markTest <> nil then
    begin
      markIn := not ((tempPoint.XPos - offsetLeft < 0) or
                     (tempPoint.XPos + offsetRight > CurrentPage.ImageWidth) or
                     (tempPoint.YPos - offsetTop < 0) or
                     (tempPoint.YPos + offsetBottom > CurrentPage.ImageHeight));
      if markIn then
      begin
        //p122t11 dmmn 1/25 - check if the individual mark settings is enable
        //if not more than likely that the user cannot modify or group
        //this will remove the ability to move annotations as a group but in turn
        //prevent user move a groups outside image area and moving other people's marks
        if (CanUserModifyMark(MarkTest) = False) or (btnMarkSettings.Enabled = False) then
          Exit; {Prevent a user from moving or resizing some other user's mark unless they have the MagAnnotation key}

        //IGPageViewCtlMouseMove(ASender, Button, Shift, x, y);
        IgCurPoint.XPos := x;
        IgCurPoint.YPos := y;
        IGArtXGUICtl.MouseMove(IGArtDrawParams, WM_MOUSEMOVE, IgCurPoint);
      end;
    end
    else
    begin

      //IGPageViewCtlMouseMove(ASender, Button, Shift, x, y);
      IgCurPoint.XPos := x;
      IgCurPoint.YPos := y;
      IGArtXGUICtl.MouseMove(IGArtDrawParams, WM_MOUSEMOVE, IgCurPoint);
    end;
  end;

  tempPoint := nil;
end;


Procedure TMagAnnot.IGPageViewCtlMouseUp(ASender: TObject; Button, Shift: Smallint; x, y: Integer);
Var
  nMessage: Integer;
  CurMark : IIGArtXMark;
//  sName, sServ, sDate, sEdit : string;
//  sTooltip : string;
Begin
  IgCurPoint.XPos := x;
  IgCurPoint.YPos := y;
  nMessage := WM_LBUTTONUP;
  If (Button = 2) Then
    nMessage := WM_RBUTTONUP;

  {Send the MouseUp event to the ArtX GUI Control to handle}
  IGArtXGUICtl.MouseUp(IGArtDrawParams, nMessage, IgCurPoint);

  try
    {If the user selected one or more marks by dragging a marquee over one or more marks,
     see if any of the selected marks belong to someone else}
    CurMark := ArtPageList[Page-1].ArtPage.MarkSelectedFirst;
    While Not (CurMark = Nil) Do
    Begin
      if CanUserModifyMark(CurMark) = False then
      begin
        GetIGManager.IGArtXGUICtl.Mode := IG_ARTX_GUI_MODE_VIEW;
        imgReadOnly.Visible := True;
//        ArtPageList[Page-1].ArtPage.MarkSelect(CurMark, False); {/ P122 - JK 8/22/2011 - if the user doesn't own it but selects it anyway, deselect it upon mouse up /}
        CurMark := nil;
      end
      else
        CurMark := ArtPageList[Page-1].ArtPage.MarkSelectedNext(CurMark);
    End;

    {If a single mark is selected and the user is working with the
     current annotation layer, enable the mark properties tool. Otherwise disable it. }
    btnMarkSettings.Enabled := False;
    CurMark := ArtPageList[Page-1].ArtPage.MarkSelectedFirst;
    //p122t15 dod
    if ((MarksSelected = 1) and (EditMode = True)) and (not RadPackage) and (not IsDODImage) then
      {/p122 dmmn 8/17 - check if the user can modify the selected mark /}
      if CanUserModifyMark(CurMark) then
        btnMarkSettings.Enabled := True;

    {/p122t3 dmmn 9/15 - change the status bar of annotation to show the name and service of the
    annotation when there is only one annotation selected /}
    if (ArtPageList[Page-1].ArtPage.MarkSelectedFirst <> nil) then
    begin // [there are selected marks]
      if (ArtPageList[Page-1].ArtPage.MarkSelectedNext(CurMark) = nil) then   
      begin  // [single mark]
        if Not RadPackage and Not IsDODImage then
        begin  // [not RADPackage]
          UpdateTooltipToStatusBar(CurMark);    //p122t4 dmmn - 9/27 - consolidated into module
        end; // end [not RADPackage]
      end  //end [single mark]
      else  // if multiselect then return the text to normal
      begin   //[multimarks]
        if FIsInHistoryView then
          sbStatus.Panels[0].Text := 'This History Layer is View Only'
        else
          sbStatus.Panels[0].Text := ACurrentAnnotationSession;

        sbStatus.Hint := '';
      end;  // end[multimarks]
    end //end [there are selected marks]
    else  // return the text to what would be normal if there's nothing selected
    begin
      if FIsInHistoryView then
        sbStatus.Panels[0].Text := 'This History Layer is View Only'
      else
        sbStatus.Panels[0].Text := ACurrentAnnotationSession;

      sbStatus.Hint := '';
    end;

  finally
    CurMark := nil;
  end;

  {/ P122 - JK 5/10/2011 /}
  if (CurAnnot <> Annot00_SELECT_) and
     (CurAnnot <> Annot22_PROTRACTOR_) and
     (CurAnnot <> Annot13_POLYLINE_) then
    actAnnot00_SELECTExecute(nil);

  {/p122t4 dmmn 9/28 - after the user has created a temp protractor, set the view back to read only /}
  if (CurAnnot <> Annot22_PROTRACTOR_) and (RADPackage or IsDODImage) then //p122t15 dod
    GetIGManager.IGArtXGUICtl.Mode := IG_ARTX_GUI_MODE_VIEW;

  {/p122 dmmn 8/17/11 - reset after protractor has clicked 3 times /}
  if ProtractorClickCount = 3 then
  begin
      ProtractorClickCount := 0;
      actAnnot00_SELECTExecute(nil);
      // reset to view only for rad [and dod (p122t15)]
      if RADPackage or IsDODImage then
        GetIGManager.IGArtXGUICtl.Mode := IG_ARTX_GUI_MODE_VIEW;
  end;

  {/ P122 - Special handling for RAD package images when the user draws a temporary protractor or ruler /}
  // dmmn 9/28 dont think this will change anything for rad but we do need to check if this is a rad package mark
  //  if (CurAnnot = Annot22_PROTRACTOR_) or (CurAnnot = Annot21_RULER_) then
  //    btnMarkSettings.Enabled := True;
  if RadPackage or IsDODImage then //p122t15 dod
  begin
    CurMark := ArtPageList[Page-1].ArtPage.MarkSelectedFirst;
    // only show if a single mark is selected
    if (CurMark <> nil) and (MarksSelected = 1) then
    begin
      if (CurMark.type_ = IG_ARTX_MARK_PROTRACTOR) or (CurMark.type_ = IG_ARTX_MARK_RULER) then
        btnMarkSettings.Enabled := True;
      CurMark := nil;
    end;
  end;
End;

Procedure TMagAnnot.actEditFlipHorizontallyExecute(Sender: Tobject);
Var
  DeviceRect: IGRectangle;
  ImageRect: IGRectangle;
Begin
  If IsValidEnv(CurrentPage) Then
  Begin
    ImageRect := IGCoreCtl.CreateObject(IG_OBJ_RECTANGLE) As IGRectangle;
    ImageRect.Top := 0;
    ImageRect.Left := 0;
    ImageRect.Right := CurrentPage.ImageWidth;
    ImageRect.Bottom := CurrentPage.ImageHeight;

    DeviceRect := IGCoreCtl.CreateObject(IG_OBJ_RECTANGLE) As IGRectangle;
    DeviceRect.Top := 0;
    DeviceRect.Left := 0;
    DeviceRect.Right := IGPageViewCtl.Width;
    DeviceRect.Bottom := IGPageViewCtl.Height;

    GetIGManager.IGProcessingCtrl.Flip(CurrentPage, IG_FLIP_HORIZONTAL);
    ArtPageList[Page-1].ArtPage.FlipMarks(IG_FLIP_VERTICAL, ImageRect, DeviceRect);
    IGPageViewCtl.UpdateView;
  End;
End;

Procedure TMagAnnot.actEditFlipVerticallyExecute(Sender: Tobject);
Var
  DeviceRect: IGRectangle;
  ImageRect: IGRectangle;
Begin
  If IsValidEnv(CurrentPage) Then
  Begin
    ImageRect := IGCoreCtl.CreateObject(IG_OBJ_RECTANGLE) As IGRectangle;
    ImageRect.Top := 0;
    ImageRect.Left := 0;
    ImageRect.Right := CurrentPage.ImageWidth;
    ImageRect.Bottom := CurrentPage.ImageHeight;

    DeviceRect := IGCoreCtl.CreateObject(IG_OBJ_RECTANGLE) As IGRectangle;
    DeviceRect.Top := 0;
    DeviceRect.Left := 0;
    DeviceRect.Right := IGPageViewCtl.Width;
    DeviceRect.Bottom := IGPageViewCtl.Height;

    GetIGManager.IGProcessingCtrl.Flip(CurrentPage, IG_FLIP_VERTICAL);
    ArtPageList[Page-1].ArtPage.FlipMarks(IG_FLIP_VERTICAL, ImageRect, DeviceRect);
    IGPageViewCtl.UpdateView;
  End;
End;

procedure TMagAnnot.FlipMarks(FlipVal: enumIGFlipModes; imgRect,devRect: IGRectangle);
begin
  //p122t3
  ArtPageList[Page-1].ImgRight := imgRect.Right;
  ArtPageList[Page-1].ImgBottom := imgRect.Bottom;
  ArtPageList[Page-1].ArtPage.FlipMarks(FlipVal, imgRect, devRect);
  if FlipVal = IG_FLIP_VERTICAL then
    ArtPageList[Page-1].FlipVer
  else if FlipVal = IG_FLIP_HORIZONTAL then
    ArtPageList[Page-1].FlipHor;
end;

procedure TMagAnnot.FlipArtPageMarks(Page: integer; FlipType: enumIGFlipModes);
var
  DeviceRect: IGRectangle;
  ImageRect: IGRectangle;
begin
  //p122t3 flip individual art page
  ImageRect := IGCoreCtl.CreateObject(IG_OBJ_RECTANGLE) As IGRectangle;
  ImageRect.Top := 0;
  ImageRect.Left := 0;
  ImageRect.Right := ArtPageList[Page-1].ImgRight;
  ImageRect.Bottom := ArtPageList[Page-1].ImgBottom;

  DeviceRect := IGCoreCtl.CreateObject(IG_OBJ_RECTANGLE) As IGRectangle;
  DeviceRect.Top := 0;
  DeviceRect.Left := 0;
  DeviceRect.Right := IGPageViewCtl.Width;
  DeviceRect.Bottom := IGPageViewCtl.Height;

  ArtPageList[Page-1].ArtPage.FlipMarks(FlipType, ImageRect, DeviceRect);
  if FlipType = IG_FLIP_VERTICAL then
    ArtPageList[Page-1].FlipVer
  else if FlipType = IG_FLIP_HORIZONTAL then
    ArtPageList[Page-1].FlipHor;
end;

procedure TMagAnnot.RotateArtPageMarks(Page, RotDir: integer);
var
  DeviceRect: IGRectangle;
  ImageRect: IGRectangle;
begin
  // rotate individual art page
  ImageRect := IGCoreCtl.CreateObject(IG_OBJ_RECTANGLE) As IGRectangle;
  ImageRect.Top := 0;
  ImageRect.Left := 0;
  ImageRect.Right := ArtPageList[Page-1].ImgRight;
  ImageRect.Bottom := ArtPageList[Page-1].ImgBottom;

  DeviceRect := IGCoreCtl.CreateObject(IG_OBJ_RECTANGLE) As IGRectangle;
  DeviceRect.Top := 0;
  DeviceRect.Left := 0;
  DeviceRect.Right := IGPageViewCtl.Width;
  DeviceRect.Bottom := IGPageViewCtl.Height;
  //RotDir = 1 right, 3 left
  ArtPageList[Page-1].ArtPage.RotateMarks(RotDir, ImageRect, DeviceRect);
  if RotDir = 1 then  // rotate right
  begin
    ArtPageList[Page-1].RotateRight;
    ArtPageList[Page-1].UpdateRects(ImageRect.Right, ImageRect.Bottom);
  end
  else if RotDir = 3 then // rotate left
  begin
    ArtPageList[Page-1].RotateLeft;
    ArtPageList[Page-1].UpdateRects(ImageRect.Right, ImageRect.Bottom);
  end;
end;

Procedure TMagAnnot.RotateImage(Value: enumIGRotationValues);
Var
  DeviceRect: IGRectangle;
  ImageRect: IGRectangle;
Begin
  If Not IsValidEnv(CurrentPage) Then
    Exit;

  ImageRect := IGCoreCtl.CreateObject(IG_OBJ_RECTANGLE) As IGRectangle;
  ImageRect.Top := 0;
  ImageRect.Left := 0;
  ImageRect.Right := CurrentPage.ImageWidth;
  ImageRect.Bottom := CurrentPage.ImageHeight;

  DeviceRect := IGCoreCtl.CreateObject(IG_OBJ_RECTANGLE) As IGRectangle;
  DeviceRect.Top := 0;
  DeviceRect.Left := 0;
  DeviceRect.Right := IGPageViewCtl.Width;
  DeviceRect.Bottom := IGPageViewCtl.Height;

  GetIGManager.IGProcessingCtrl.Rotate90k(CurrentPage, Value);
  ArtPageList[Page-1].ArtPage.RotateMarks(Value, ImageRect, DeviceRect);
  //p122t3 fix rotating issues
  if Value = 1 then  // rotate right
  begin
    ArtPageList[Page-1].RotateRight;
    ArtPageList[Page-1].UpdateRects(ImageRect.Right, ImageRect.Bottom);
  end
  else if Value = 3 then // rotate left
  begin
    ArtPageList[Page-1].RotateLeft;
    ArtPageList[Page-1].UpdateRects(ImageRect.Right, ImageRect.Bottom);
  end;
  
  IGPageViewCtl.UpdateView;
End;

Procedure TMagAnnot.actEditRotate180Execute(Sender: Tobject);
Begin
  RotateImage(IG_ROTATE_180);
End;

Procedure TMagAnnot.actEditRotate270CCWExecute(Sender: Tobject);
Begin
  RotateImage(IG_ROTATE_90);
End;

Procedure TMagAnnot.actEditRotate270CWExecute(Sender: Tobject);
Begin
  RotateImage(IG_ROTATE_270);
End;

Procedure TMagAnnot.actEditRotate90CCWExecute(Sender: Tobject);
Begin
  RotateImage(IG_ROTATE_270);
End;

Procedure TMagAnnot.actEditRotate90CWExecute(Sender: Tobject);
Begin
  RotateImage(IG_ROTATE_90);
End;

Procedure TMagAnnot.actViewFittoWidthExecute(Sender: Tobject);
Begin
  CurrentPageDisp.Layout.FitMode := IG_DSPL_FIT_TO_WIDTH;
  IGPageViewCtl.UpdateView;
End;

Procedure TMagAnnot.actViewFittoWindowExecute(Sender: Tobject);
Begin
  CurrentPageDisp.Layout.FitMode := IG_DSPL_FIT_TO_DEVICE;
  IGPageViewCtl.UpdateView;
End;

Procedure TMagAnnot.actViewFitToActualSizeExecute(Sender: Tobject);
Begin
  CurrentPageDisp.Layout.FitMode := IG_DSPL_ACTUAL_SIZE;
  IGPageViewCtl.UpdateView;
End;

Procedure TMagAnnot.actViewFittoHeightExecute(Sender: Tobject);
Begin
  CurrentPageDisp.Layout.FitMode := IG_DSPL_FIT_TO_HEIGHT;
  IGPageViewCtl.UpdateView;
End;

Procedure TMagAnnot.actViewZoomInExecute(Sender: Tobject);
Var
  Zoomzoom: IGDisplayZoomInfo;
Begin
  Try
    Zoomzoom := CurrentPageDisp.GetZoomInfo(IGPageViewCtl.Hwnd);
    Zoomzoom.HZoom := Zoomzoom.HZoom * 1.25;
    Zoomzoom.VZoom := Zoomzoom.VZoom * 1.25;
    Zoomzoom.Mode := IG_DSPL_ZOOM_H_FIXED Or IG_DSPL_ZOOM_V_FIXED;
    CurrentPageDisp.UpdateZoomFrom(Zoomzoom);
    IGPageViewCtl.UpdateView;
  Except
  End;
End;

Procedure TMagAnnot.actViewZoomOutExecute(Sender: Tobject);
Var
  Zoomzoom: IGDisplayZoomInfo;
Begin
  Try
    Zoomzoom := CurrentPageDisp.GetZoomInfo(IGPageViewCtl.Hwnd);
    Zoomzoom.HZoom := Zoomzoom.HZoom / 1.25;
    Zoomzoom.VZoom := Zoomzoom.VZoom / 1.25;
    Zoomzoom.Mode := IG_DSPL_ZOOM_H_FIXED Or IG_DSPL_ZOOM_V_FIXED;
    CurrentPageDisp.UpdateZoomFrom(Zoomzoom);
    IGPageViewCtl.UpdateView;
  Except
  End;
End;

Procedure TMagAnnot.actViewZoomResetExecute(Sender: Tobject);
Var
  Zoomzoom: IGDisplayZoomInfo;
Begin
  Try
    Zoomzoom := CurrentPageDisp.GetZoomInfo(IGPageViewCtl.Hwnd);
    Zoomzoom.Mode := IG_DSPL_ZOOM_H_NOT_FIXED Or IG_DSPL_ZOOM_V_NOT_FIXED;
    CurrentPageDisp.UpdateZoomFrom(Zoomzoom);
    IGPageViewCtl.UpdateView;
  Except
  End;
End;

Procedure TMagAnnot.actViewAntialiasingOffExecute(Sender: Tobject);
Begin
  actViewAntialiasingOn.Checked := False;
  actViewAntialiasingOff.Checked := True;
  CurrentPageDisp.AntiAliasing.Method := IG_DSPL_ANTIALIAS_NONE;
  IGPageViewCtl.UpdateView;
End;

Procedure TMagAnnot.actViewAntialiasingOnExecute(Sender: Tobject);
Begin
  actViewAntialiasingOn.Checked := True;
  actViewAntialiasingOff.Checked := False;
  CurrentPageDisp.AntiAliasing.Method := IG_DSPL_ANTIALIAS_RESAMPLE_BILINE + IG_DSPL_ANTIALIAS_SCALE_TO_GRAY + IG_DSPL_ANTIALIAS_COLOR;
  CurrentPageDisp.AntiAliasing.Threshold := 50;
  IGPageViewCtl.UpdateView;
End;

Procedure TMagAnnot.ResetPageGlobals();
Begin
  If CurrentPage <> Nil Then CurrentPage := Nil;
  FCurrentPageNumber := -1;
  FIoLocation := Nil;
  FTotalLocationPageCount := 0;
End;

Procedure TMagAnnot.CheckErrors;
Var
  errorRecord: IGResultRecord;
  Errstring: String;
  igResult: IIGResult;
Begin
  igResult := IGCoreCtl.Result;

  If (Not igResult.IsOk) Then
  Begin
    errorRecord := igResult.GetRecord(0);
    Errstring :=
      'ImageGear Error: ' +
      Inttostr(errorRecord.ErrCode) + ' ' + // error code
      '[' + Inttostr(errorRecord.Value1) + ', ' +
      Inttostr(errorRecord.Value2) + ']' + Chr(13) + // value
      errorRecord.Filename + '(' + // file name
      Inttostr(errorRecord.LineNumber) + ')' + Chr(13) + // line number
      errorRecord.ExtraText; // description
  End
  Else
    Errstring := 'No ImageGear errors on the stack';

  //Application.MessageBox(PChar(Errstring), 'Error has been reported', MB_ICONINFORMATION Or MB_OK);

End;

Procedure TMagAnnot.actFileSaveExecute(Sender: Tobject);
Var
  dialogSaveOptions: IIGFileDlgPageSaveOptions;
  igFileDialog: IGFileDlg;
Begin
  igFileDialog := IGDlgsCtl.CreateFileDlg;
  Try
    Try
      dialogSaveOptions := IGDlgsCtl.CreateFileDlgOptions(IG_FILEDLGOPTIONS_PAGESAVEOBJ) As IIGFileDlgPageSaveOptions;
      dialogSaveOptions.Set_Page(CurrentPage);
      igFileDialog.ParentWindow := Handle;
      If (igFileDialog.Show(dialogSaveOptions)) Then
      Begin
        IGFormatsCtrl.SavePageToFile(
          CurrentPage,
          dialogSaveOptions.Filename,
          dialogSaveOptions.PageNum,
          IG_PAGESAVEMODE_DEFAULT,
          dialogSaveOptions.Format);
      End
    Except
      On EOleException Do CheckErrors;
    End;
  Finally
    igFileDialog := Nil;
  End;
End;

procedure TMagAnnot.actRulerCalibrateExecute(Sender: TObject);
var
  frmRulerCalib: TMagAnnotRulerCalibrate;
  refRuler: IIGArtXRuler;
begin
  // exit if no ruler mark selected
  if (ArtPage.MarkSelectedFirst = nil) or
     (ArtPage.MarkSelectedFirst.type_ <> IG_ARTX_MARK_RULER) then
    begin
//      if (FIsInHistoryView) or     // cannot calibrate in history view
//         (GetIGManager.IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT)    // cannot do anything in view only mode
//       then
//        MessageDlg('The ruler is view only. Calibration cannot be changed.', mtInformation, [mbOK], 0)
//      else

        {/p122t3 dmmn 9/16 - in this condition, if there is no mark selected or
        the selected mark is not a ruler, show the following message. The check
        above is not neccessary here /}
        MessageDlg('No reference ruler selected. Cannot calibrate.', mtInformation, [mbOK], 0);
      Exit;
    end;

    refRuler := ArtPage.MarkSelectedFirst as IIGArtXRuler;

    {/p122t3 dmmn 9/16 - after we've passed the first check, we know this mark is a
    ruler. Now we have to check for its date. Only rulers in the current session
    can be calibrated. /}
    if (FIsInHistoryView) or        // cannot calibrate in history layer
       (IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT) or      // cannot calibrate if view only mode
//       (FormatDatePiece(GetViewHideFieldValue(3,refRuler.Tooltip)) <> '') then   // cannot calibrate if ruler is not current
       (Not CanUserModifyMark(refRuler as IIGArtXMark)) then
    begin
      MessageDlg('The ruler is view only. Calibration cannot be changed.', mtInformation, [mbOK], 0);
      Exit;
    end;
    

    // get the actual measurement, in whole number only
    frmRulerCalib := TMagAnnotRulerCalibrate.CreateNew(nil,0);
    try
      frmRulerCalib.InitForm;
      frmRulerCalib.Left := ToolbarCoords.X + 10;
      frmRulerCalib.Top := ToolbarCoords.Y + 10;

      frmRulerCalib.ShowModal;
      if frmRulerCalib.ModalResult = mrOK then
      begin
        RulerActualAspectRatio := GetNewAspectRatio(RulerActualMeasured,refRuler);
        refRuler.SetAspectRatio(RulerActualAspectRatio);
        refRuler.Label_ := '%d ' + RulerMeasUnit; // p122 dmmn 7/12/11 - add new units

        //p122t3 dmmn 9/19 - update the ruler to be edited so that it will belonged to the current session
        EditAnnotationOwnership(refRuler as IIGArtXMark);
        sbStatus.Panels[0].Text := sbStatus.Panels[0].Text + '-*edited*';
        sbStatus.Hint := sbStatus.Panels[0].Text;

        UpdateNewAspectRatio; //p122 dmmn 7/8/11

        FAnnotsModified := True; //p122t3 dmmn 9/16 - I don't think this needed here but still put here to make sure for now
      end;
      IGPageViewCtl.UpdateView;
    finally
      frmRulerCalib.Destroy;
    end;
  end;

procedure TMagAnnot.actRulerClearCalibrationExecute(Sender: TObject);
var
  buttonSelected : Integer;
begin
  {/P122 JK 8/22/2011 - check before clearing the calibration /}
  if GetIGManager.IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT then
  begin
//    MessageDlg('The ruler is view only. Calibration cannot be cleared.', mtInformation, [mbOK], 0);
    MessageDlg('You are in view only mode. Calibrations cannot be cleared.', mtInformation, [mbOK], 0);  //p122t4 dmmn 9/27
    Exit;
  end;
  {/P122 dmmn 7/13/11 - clear any calibration /}
  try
    //p122t4 dmmn 9/27 - show a warning before user clear calibrations
    buttonSelected := MessageDlg('Are you sure you want to clear calibration for all rulers in the current session?',
                                 mtConfirmation,[mbYes,mbNo],0, mbNo);
    //quit if user changed mind and not want to delete
    if buttonSelected = mrNo then
      Exit;

    RulerActualAspectRatio := nil;
    RulerMeasUnit := 'unit';
    ClearAllAspectRatio;
  except
    on E:Exception do
    begin
      magAppMsg('s','In TMagAnnot.actRulerClearCalibrationExecute' );
      magAppMsg('s', E.ClassName + 'error raised, with message: '+ E.Message);
    end;
  end;
end;

{ TMagAnnotRulerCalibrate }

procedure TMagAnnotRulerCalibrate.btnCancelOnClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TMagAnnotRulerCalibrate.btnOKOnClick(Sender: TObject);
var
  left,right : integer;
begin
  if (Length(edtLeft.Text) = 0) or (Length(edtRight.Text) = 0) then
  begin
    ShowMessage('Please enter a valid value or cancel calibrating.');
    Exit;
  end;
  {/p122 dmmn 7/6/11 - add support for decimal number /}
  left := StrToInt(edtLeft.Text);
  if Length(edtRight.Text) = 1 then
    right := StrToInt(edtRight.Text)*10
  else
    right := StrToInt(edtRight.Text);

  //RulerActualMeasured := StrToInt(lblEdit.Text);
  RulerActualMeasured := left*100 + right;

  if RulerActualMeasured <= 0 then  //p122 dmmn 7/13/11 - promt for reenter if value is 0
  begin
    ShowMessage('Value must be greater than 0.00');
    Exit;
  end;

//  RulerMeasUnit := measUnit.ItemIndex;
  if measUnit.ItemIndex = 0 then              //p122 dmmn 7/12/11 RulerMeasUnit will take the unit directly
    RulerMeasUnit := 'cm'
  else if measUnit.ItemIndex = 1 then
    RulerMeasUnit := 'mm'
  else if measUnit.ItemIndex = 2 then
    RulerMeasUnit := 'in'
  else
    RulerMeasUnit := 'unit';

  ModalResult := mrOK;
end;

procedure TMagAnnotRulerCalibrate.EditKeyPress(Sender: TObject; var Key: Char);
begin
  if (not (Key in ['0'..'9',#8])) then
    Key := #0;
end;

procedure TMagAnnotRulerCalibrate.InitForm;
begin
  {/P122 dmmn 7/6/11 - change to allow decimal number /}
  Caption := 'Calibrate Ruler';              // form

  Width := 170;
  Height := 170;

  BorderStyle := bsToolWindow;

  lblUnit := TLabel.Create(self);
  lblUnit.Parent := self;
  lblUnit.Caption := 'What is the measurement unit?';
  lblUnit.Top := 10;
  lblUnit.Left := 10;

  measUnit := TComboBox.Create(self);
  measUnit.Parent := self;
  measUnit.Items.Add('Centimeter (cm)');   //p122 dmmn 7/12/11 - add new units
  measUnit.Items.Add('Millimeter (mm)');
  measUnit.Items.Add('Inches (in)');
  measUnit.Items.Add('Relative (unit)');
  measUnit.ItemIndex := 3;
  measUnit.Top := 25;
  measUnit.Left := 10;
  measUnit.Width := 145;
  measUnit.Height := 20;
  measUnit.Style := csDropDownList; //p122t7 dmmn 

//  lblEdit := TLabeledEdit.Create(self);
//  lblEdit.Parent := self;
//  lblEdit.EditLabel.Caption := 'What is the measurement?';
//  lblEdit.Width := 145;
//  lblEdit.Height := 20;
//  lblEdit.Top := 75;
//  lblEdit.Left := 10;
//  lblEdit.Text := '1';
//  lblEdit.OnKeyPress := EditKeyPress;

  lblMeas := TLabel.Create(self);
  lblMeas.Parent := self;
  lblMeas.Caption := 'What is the measurement?';
  lblMeas.Left := 10;
  lblMeas.Top := 55;

  lblDot := TLabel.Create(self);
  lblDot.Parent := self;
  lblDot.Caption := '.';
  lblDot.Font.Size := 16;
  lblDot.Left := 80;
  lblDot.Top := 70;

  edtLeft := TEdit.Create(self);
  edtLeft.Parent := self;
  edtLeft.Left := 10;
  edtLeft.Top := 75;
  edtLeft.Height := 20;
  edtLeft.Width := 65;
  edtLeft.OnKeyPress := EditKeyPress;
  edtLeft.MaxLength := 5;
  edtLeft.Text := '0';


  edtRight := TEdit.Create(self);
  edtRight.Parent := self;
  edtRight.Left := 90;
  edtRight.Top := 75;
  edtRight.Height := 20;
  edtRight.Width := 65;
  edtRight.OnKeyPress := EditKeyPress;
  edtRight.MaxLength := 2;
  edtRight.Text := '00';

  btnOK := TButton.Create(self);
  btnOK.Parent := self;
  btnOK.Width := 45;
  btnOK.Height := 25;
  btnOK.Caption := 'Set';
  btnOK.Top := 115;
  btnOK.Left := 35;
  btnOK.OnClick := btnOKOnClick;

  btnCancel := TButton.Create(self);
  btnCancel.Parent := self;
  btnCancel.Width := 45;
  btnCancel.Height := 25;
  btnCancel.Caption := 'Cancel';
  btnCancel.Top := 115;
  btnCancel.Left := 90;
  btnCancel.OnClick := btnCancelOnClick;
end;

procedure TMagAnnot.actTool_ImageInformationExecute(Sender: TObject);
var
  info : string;
  CurMark : IIGArtXMark;
  MarkArray : IIGArtXMarkArray;
  i, Count: Integer;
  VisibleMark: String;
  annotCount : integer;
begin
  try
    try

      info := 'User: ' + GSess.UserName + #13#10#13#10;

      if PageCount = 1 then
      begin
        if FAnnotatedByVR then
          info := info +
                'This image has been annotated in VistARad.' + sLineBreak +
                'To view the image with annotations, open this image in VistARad.' + #13#10#13#10
        else
          info := info +
                'Page Count: ' + IntToStr(PageCount) + sLineBreak +
                'Total Annotations: ' + IntToStr(MarkCount) + sLineBreak +
                'Total Hidden Annotations: ' + IntToStr(HiddenCount) + #13#10#13#10;
      end
      else
      begin
        //p122 dmmn 7/26/11 - show information for total page and current page
        info := info +
              'Page: ' + IntToStr(Page) + '/' + IntToStr(PageCount) + sLineBreak +
              'Total Annotations: ' + IntToStr(MarkCount) + sLineBreak +
              'Total Annotation on current page: ' + IntToStr(MarkCountCurrentPage) + sLineBreak +
              'Total Hidden Annotations: ' + IntToStr(HiddenCount) + sLineBreak +
              'Total Hidden Annotations on current page: ' + IntToStr(HiddenMarkCountCurrentPage) + #13#10#13#10;
      end;

      MarkArray := IGArtXCtl.CreateObject(IG_ARTX_OBJ_MARK_ARRAY) as IIGArtXMarkArray;

      // iterate through the marks and add to the marks array
      Count := 0;
      CurMark := ArtPageList[Page-1].ArtPage.MarkSelectedFirst;
      While (Not (CurMark = Nil)) Do
      Begin
        MarkArray.Resize(Count+1);
        MarkArray.Item[Count] := CurMark;
        CurMark := ArtPageList[Page-1].ArtPage.MarkSelectedNext(CurMark);
        Inc(Count);
      End;

      {For not VistARad annotations, do a normal display of information}
//      if HasRADAnnotation = False then
//    p122t15 dod
      if Not RADPackage and Not IsDODImage then  //p122t11 dmmn - better property to check
      begin
        if Count > 0 then
        begin
          if Count > 1 then
            info := Info + 'Owner information for ' + IntToStr(Count) + ' selected annotations:' + #13#10
          else
            info := Info + 'Owner information for the selected annotation:' + #13#10;

          for i := 0 to Count - 1 do
          begin
            if MarkArray.Item[i].Visible then
              VisibleMark := 'Visible: '
            else
              VisibleMark := 'Hidden:  ';

            if Trim(MarkArray.Item[i].Tooltip) = '' then
              Info := Info + VisibleMark + 'Information for selected annotation ' + IntToStr(i+1) + ' is unavailable' + #13#10
            else
              Info := Info + VisibleMark + FormatToolTip(MarkArray.item[i].Tooltip) + #13#10;
          end;
        end;
      end
      else if (RADPackage) then // rad package images
      begin
//        if FRADAnnotationCount > 0 then
        if RadInfo.radAnnotCount > 0 then
          info := info + 'The annotations showing here originated in VistARad. Annotations in green are exact mappings.'
                       + #13#10 + 'If there are annotations in yellow they are approximated mappings. For exact mapping'
                       + #13#10 + 'view the image and annotations in VistARad.' + #13#10#13#10;

        info := info + 'This radiology package image is read-only and cannot be annotated in Clinical Display.'
                     + #13#10 + 'However you can draw temporary rulers and protractor angles during this viewing session.'
                     + #13#10 + 'If you need to draw on this image with annotations that persist, you must do it in VistARad.'
                     + #13#10;
      end
      else if (IsDODImage) then //p122t15 DOD images
      begin
        info := info + 'This DOD image is read-only and cannot be annotated in Clinical Display.'
                     + #13#10 + 'However you can draw temporary rulers and protractor angles during this viewing session.'

      end;

      {If the image status is >= 10 then tell the user what is going on.}
      if MagPiece(FAnnotationStatus, '^', 1) >= '10' then
        info := info + 'The image status is: ' + MagPiece(FAnnotationStatus, '^', 2);
      
      MessageDlg(info, mtInformation, [mbOK], 0);
    except
      on E:Exception do
      begin
        magAppMsg('s', 'TMagAnnot.actTool_ImageInformationExecute error = ' + E.Message);
        MessageDlg('Cannot provide information at this time. See the system log for reason', mtWarning, [mbOK], 0);
      end;
    end;
  finally
    CurMark := nil;
    MarkArray := nil;
  end;
end;

procedure TMagAnnot.actTool_MarkPropertyEditorExecute(Sender: TObject);
{ Show the mark property }
var
  CurMark : IIGArtXMark;
  MarkPropertySheet : TfrmMagAnnotationMarkProperty;
//  MultSelected : boolean;  //p122 7/14
begin
  try
    if MarksSelected = 0 then
    begin
      ShowMessage('Select an annotation to edit');
      Exit;
    end;
    if MarksSelected > 1 then
    begin
      ShowMessage('Select one annotation at a time to edit');
      Exit;
    end;

    //p122 dmmn 7/13/11 - preventive check to see if there is valid selection
    CurMark := ArtPage.MarkSelectedFirst;
    if CurMark = nil then Exit;
//    MultSelected := False;           //p122 7/14
    if ArtPage.MarkSelectedNext(CurMark) <> nil then
    begin
//      MultSelected := True;          //p122 7/14
      // in case of multiple marks selected, go with the first one
      ArtPage.SelectMarks(False);
      ArtPage.MarkSelect(CurMark, True);
      IGPageViewCtl.UpdateView;
    end;                               

    MarkPropertySheet := TfrmMagAnnotationMarkProperty.Create(nil);
//    MarkPropertySheet.MultWarn := MultSelected; //p122 7/14
    MarkPropertySheet.SetCurrentMark(CurMark);
    MarkPropertySheet.IGPageViewCtl := IGPageViewCtl;
    MarkPropertySheet.IGCoreCtl := IGCoreCtl;
    MarkPropertySheet.ShowModal;

    //p122 dmmn 7/27/11 - update owner information for the modified mark
    if MarkPropertySheet.AnnotationChanged then
    begin
      FAnnotsModified := True;

      //p122t3 update old ruler to current session ruler calibration if available
      if (CurMark.type_ = IG_ARTX_MARK_RULER) then
        UpdateOldRulerCalibrationToCurrent(CurMark as IIGArtXRuler);

      EditAnnotationOwnership(CurMark); //p122t2 dmmn 8/31
    end;
  finally
    FreeAndNil(MarkPropertySheet);
  end;
end;

procedure TMagAnnot.DisplayCurrentMarkProperties;
var
  pg: Integer;
begin
  pg := Page-1;
  if ArtPageList[pg].ArtPage.MarkCount = 0 then
  begin
    MessageDlg('There are no annotation marks on this page', mtInformation, [mbOK], 0);
    Exit;
  end;
  

  if ArtPageList[pg].ArtPage.MarkSelectedFirst <> nil then
    IGArtXGUICtl.ShowAttributes(ArtPageList[pg].Artpage.MarkSelectedFirst, FIGArtDrawParams)
  else
    MessageDlg('Select an annotation to use this toolbar function', mtInformation, [mbOK], 0);
end;

function TMagAnnot.LoadXmlHistory(ImageIEN: String; LayerNumber: String; CurrentLayer: Boolean): Boolean;
var
  FStat: Boolean;
  rpcMsg: String;
  AnnotCnt : string;
  AnnotXML : TStringList;
  XmlString : TStringList;
  XmlTmp : TStringList;
  Layer: String;
  FN : String;
  PN : String;
  AnnotInfo : string;
  I : Integer;
  NodeData: TAnnotNodeData;
  sXML : String;
  isTemp : boolean;  // for loading temporary files
begin
  {/p122t4 dmmn 9/30 - reorganized method and loading files /}
  Result := False;

  AnnotXML := TStringList.Create;        // store the raw XML get from Vista
  XmlString := TStringList.Create;       // store the formatted XML for loading
  XmlTmp := TStringList.Create;          // temp storage for processing XML

  try
    {First look to see if the XML layer is in the local cache (icache/annotations/...) If not, get it
    from VistA and cache it.  We favor the cache over the backend when possible. This speeds up
    moving between histories, particularly if going over a remote connection. }

    isTemp := (MagPiece(LayerNumber, '^', 2) = 'T');
    LayerNumber := MagPiece(LayerNumber, '^', 1);

    if isUrn(LayerNumber) then              // VIX
      Layer := GSess.MagUrlMap.MapUrn(LayerNumber)
    else                                    // non VIX
      Layer := LayerNumber;

    if isTemp then      //p122t4 restore the T part in the name for temp load
      Layer := Layer + '^T';

    // name of the XML file
    if isUrn(ImageIEN) then
      FN := GSess.AnnotationTempDir + GSess.MagUrlMap.MapUrn(ImageIEN) + '^' + Layer
    else
      FN := GSess.AnnotationTempDir + ImageIEN + '^' + Layer;

    // there no file in the cache so go fetch from VistA
    if (Not FileExists(FN + '.xml')) then
    begin
      {/ P122 - JK 6/22/2011 - Get the XML from VistA}
      idmodobj.GetMagDBBroker1.RPMagAnnotGetXML(
         ImageIEN,
         LayerNumber,
         AnnotXML,
         FStat,
         rpcMsg,
         FServerName,
         FServerPort);

      // if fetched sucessfully
      if FStat then
      begin
        {If the AnnotXML string has a zero count then return false and exit}
//        AnnotCnt := MagPiece(AnnotXML[0], '^', 1);
        AnnotCnt := MagPiece(AnnotXML[0], '^', 2);  //p122t6 count is piece #2

        if AnnotCnt = '0' then
        begin
          Result := False;
          magAppMsg('s', 'TMagAnnot.LoadXmlHistory');    //p122t6
          magAppMsg('s', AnnotXML[0]);
          Exit;
        end;

        {Format the raw XML, if its valid, so that we can save it to icache}
        if AnnotXML.Count > 0 then
        begin
          AnnotXML.Delete(0);         // Remove the total line count
          AnnotInfo := AnnotXML[0];   // Information about the annotation layer
          AnnotXML.Delete(0);         // Remove the owner line
        end
        else   // empty fetching
        begin
          AnnotInfo := 'ERROR - empty load';
          Result := False;
          Exit;
        end;

        // after we removed the info lines, the rest is raw XML
        if AnnotXML.Count > 0 then
        begin
          {Format the XML}
          XmlString.Add(RemoveTabCharacters(AnnotXML));
          XmlString.SaveToFile(FN + '.xml');  // save the formatted XML layer to the cache folder

          // if the XML is well-formatted then proceed to load else false
          if ValidateXML(FN + '.xml') then
          begin
            if CurrentLayer then    // load annotation for current session
            begin
              // load the XML layer into XMLControl
              XMLCtl.LoadCurrentHistoryLayer(XMLString[0]);

              // go through all the pages and load the art page accordingly
              for I := 0 to PageCount - 1 do
              begin
                // name of the file contain the extracted XML page in the
                PN := FN + '^PXML.xml';
                if FileExists(PN) then
                  DeleteFile(PN);

                XMLCtl.LoadCurrentHistoryToArtPage(PN,I);

                CurrentPageDisp.OffScreenDrawing := True;       // Controls redraw flicker
                ArtPageList[I].ArtPage.RemoveMarks;             // clean up the page
                ArtPageList[I].ArtPage.LoadFile(PN, 1, False);  // load the page
              end;
            end
            else    // load history session
            begin
              // load the history XML layer into XMLControl
              XMLCtl.LoadHistoryView(XMLString[0]);

              // go through all the pages and load the art page accordingly
              for I := 0 to PageCount - 1 do
              begin
                PN := FN + '^PXML.xml';
                if FileExists(PN) then
                  DeleteFile(PN);
                  
                XMLCtl.LoadHistoryToArtPage(PN,I);
                CurrentPageDisp.OffScreenDrawing := True; {/ P122 - DN 6/14/2011 - Controls redraw flicker /}
                ArtPageList[I].ArtPage.RemoveMarks;
                ArtPageList[I].ArtPage.LoadFile(PN, 1, False);
              end;
            end;

            IGPageViewCtl.UpdateView;
            Result := True;
          end
          else
          begin
            Result := False;
            MessageDlg('Cannot load the current annotation layer. There is a ' +
                'problem with the annotation XML. Contact IRM', mtError, [mbOK], 0);
            Exit;
          end;
        end
        else // empty fetching
        begin
          AnnotInfo := 'ERROR - empty XML';
          Result := False;
          Exit;
        end;
      end;    {END FStat = TRUE}
    end  {END Not FileExists(FN)}
    else // there is a file in the cache
    begin
      AnnotXML.Clear;
      XMLString.Clear;
      XmlTmp.Clear;
      {The history file was found in the local cache. Use it instead of retrieving a new copy from VistA}
      // if the XML is well-formatted (should be) then proceed to load else false
      if ValidateXML(FN + '.xml') then
      begin
        // load back the cached XML
        XmlTmp.LoadFromFile(FN + '.xml');
        sXML := '';
        for I := 0 to XmlTmp.Count - 1 do
          sXML := sXML + XmlTmp[I] + #13#10;
        XMLString.Add(sXML);

        if CurrentLayer then    // load annotation for current session
        begin
          // load the XML layer into XMLControl
          XMLCtl.LoadCurrentHistoryLayer(XMLString[0]);

          // go through all the pages and load the art page accordingly
          for I := 0 to PageCount - 1 do
          begin
            // name of the file contain the extracted XML page in the
            PN := FN + '^PXML.xml';
            if FileExists(PN) then
              DeleteFile(PN);

            XMLCtl.LoadCurrentHistoryToArtPage(PN,I);

            CurrentPageDisp.OffScreenDrawing := True;       // Controls redraw flicker
            ArtPageList[I].ArtPage.RemoveMarks;             // clean up the page
            ArtPageList[I].ArtPage.LoadFile(PN, 1, False);  // load the page
          end;
        end
        else    // load history session
        begin
          {P129}
          if not CaptureNewImage then  {JK 6/26/2012 - don't show history during a Capture session}
          begin
          // load the history XML layer into XMLControl
          XMLCtl.LoadHistoryView(XMLString[0]);

          // go through all the pages and load the art page accordingly
          for I := 0 to PageCount - 1 do
          begin
            PN := FN + '^PXML.xml';
            if FileExists(PN) then
              DeleteFile(PN);
                  
            XMLCtl.LoadHistoryToArtPage(PN,I);
            CurrentPageDisp.OffScreenDrawing := True; {/ P122 - DN 6/14/2011 - Controls redraw flicker /}
            ArtPageList[I].ArtPage.RemoveMarks;
            ArtPageList[I].ArtPage.LoadFile(PN, 1, False);
          end;
        end;
        end;

        IGPageViewCtl.UpdateView;
        Result := True;
      end
      else
      begin
        Result := False;
        MessageDlg('Cannot load the current annotation layer. There is a ' +
            'problem with the annotation XML. Contact IRM', mtError, [mbOK], 0);
        Exit;
      end;
    end;

    {/ P122 - 7/27/2011
    If the selected history node has hidden marks, update the selected history tree
    node by adding a child node to let the user see "As Last Viewed" /}
    if GetHiddenCount > 0 then
    begin
      if tvHistory.Selected <> nil then
        if tvHistory.Selected.HasChildren = False then
          if tvHistory.Selected.Text <> AAsLastViewed then
          begin
            NodeData                := TAnnotNodeData.Create;
            NodeData.LayerNumber    := TAnnotNodeData(tvHistory.Selected.Data).LayerNumber;
            NodeData.UserName       := TAnnotNodeData(tvHistory.Selected.Data).UserName;
            NodeData.SavedDateTime  := TAnnotNodeData(tvHistory.Selected.Data).SavedDateTime;
            NodeData.Version        := TAnnotNodeData(tvHistory.Selected.Data).Version;
            NodeData.Source         := TAnnotNodeData(tvHistory.Selected.Data).Source;
            NodeData.Deletion       := TAnnotNodeData(tvHistory.Selected.Data).Deletion;
            NodeData.Resulted       := TAnnotNodeData(tvHistory.Selected.Data).Resulted;
            NodeData.Service        := TAnnotNodeData(tvHistory.Selected.Data).Service;
            NodeData.SiteID         := TAnnotNodeData(tvHistory.Selected.Data).SiteID;
            NodeData.DUZ            := TAnnotNodeData(tvHistory.Selected.Data).DUZ;
            NodeData.CachedFilename := TAnnotNodeData(tvHistory.Selected.Data).CachedFileName;
            tvHistory.Items.AddChildObject(tvHistory.Selected, AAsLastViewed, NodeData);
          end;
    end;
  finally
    FreeAndNil(AnnotXML);
    FreeAndNil(XmlString);
    FreeAndNil(XmlTmp);
  end;

end;

function TMagAnnot.LoadXmlRadiology(ImageIEN, LayerNumber: String; CurrentLayer: Boolean): Boolean;
var
  FStat: Boolean;
  rpcMsg: String;
  AnnotCnt: String;
  AnnotXML: TStringList;
  XmlString: TStringList;
  XMLTmp: TStringList;
  ScaleFactor : double;
  FN: string;
  AnnotInfo : string;
  I : Integer;
  sXML : String;
begin
  {/p122t11 dmmn 1/22 - straighthen some variable names/call up and put in more
  error controls /}
  Result := False;

  ScaleFactor := 0.5;
  {If not in the local cache, fetch it from VistA and save it in the local cache}

  AnnotXML := TStringList.Create;
  XmlString := TStringList.Create;
  XmlTmp := TStringList.Create;

  try
    {First look to see if the XML layer is in the local cache (icache/annotations/...) If not, get it
    from VistA and cache it.  We favor the cache over the backend when possible. This speeds up
    moving between histories, particularly if going over a remote connection. }

    // name of the XML file
    if isUrn(ImageIEN) then
      FN := GSess.AnnotationTempDir + GSess.MagUrlMap.MapUrn(ImageIEN) + '^' + GSess.MagUrlMap.MapUrn(LayerNumber)
    else
      FN := GSess.AnnotationTempDir + ImageIEN + '^' + LayerNumber;

    // there no file in the cache so go fetch from VistA
    if (Not FileExists(FN + '.xml')) then
    begin
      {/ P122 - JK 6/22/2011 - Get the XML from VistA}
      idmodobj.GetMagDBBroker1.RPMagAnnotGetXML(
         ImageIEN,
         LayerNumber,
         AnnotXML,
         FStat,
         rpcMsg,
         FServerName,
         FServerPort);

      // if fetched sucessfully
      if FStat then
      begin
        {If the AnnotXML string has a zero count then return false and exit}
        AnnotCnt := MagPiece(AnnotXML[0], '^', 2);  //p122t6 count is piece #2
        if AnnotCnt = '0' then
        begin
          FVistaRadMessage := '';
          HasRADAnnotation := False;
          Result := False;
          MagAppMsg('s', 'TMagAnnot.LoadXmlRadiology');    //p122t6
          MagAppMsg('s', AnnotXML[0]);
          Exit;
        end;

        {Format the raw XML, if its valid, so that we can save it to icache}
        if AnnotXML.Count > 0 then
        begin
          AnnotXML.Delete(0);         // Remove the total line count
          AnnotXML.Delete(0);         // Remove the owner line
        end
        else   // empty fetching
        begin
          FVistaRadMessage := '';
          HasRADAnnotation := False;
          AnnotInfo := 'ERROR - empty load';
          Result := False;
          Exit;
        end;

        // after we removed the info lines, the rest is raw XML
        if AnnotXML.Count > 0 then
        begin
          {Format the XML}
          XmlString.Add(RemoveTabCharacters(AnnotXML));
          XmlString.SaveToFile(FN + '.xml');  // save the formatted XML layer to the cache folder

          // if the XML is well-formatted then proceed to load else false
          if ValidateXML(FN + '.xml') then
          begin
            {Now store the xml into the control}
            LoadRADAnnotation(XMLCtl,XMLString[0]);
            HasRADAnnotation := True;

            {/ P122 JK 8/10/2011 - let the clinician know if some VR annots may be approximate /}
            if XMLCtl.ContainsRADEllipseAndFreeHand then
              FVistaRadMessage := ' -- Some annotations are approximate'
            else
              FVistaRadMessage := '';

            Result := True;
          end
          else
          begin
            FVistaRadMessage := '';
            Result := False;
            HasRADAnnotation := False;
            MagAppMsg('d','Cannot load the current annotation layer. There is a ' +
                              'problem with the radiology annotation XML. Contact IRM');
          end;
        end;
      end;
    end
    else   // there is a file in the cache
    begin
      AnnotXML.Clear;
      XMLString.Clear;
      XmlTmp.Clear;
      {The history file was found in the local cache. Use it instead of retrieving a new copy from VistA}
      // if the XML is well-formatted (should be) then proceed to load else false
      if ValidateXML(FN + '.xml') then
      begin
        // load back the cached XML
        XmlTmp.LoadFromFile(FN + '.xml');
        sXML := '';
        for I := 0 to XmlTmp.Count - 1 do
          sXML := sXML + XmlTmp[I] + #13#10;
        XMLString.Add(sXML);

        {Now store the xml into the control}
        LoadRADAnnotation(XMLCtl,XMLString[0]);
        HasRADAnnotation := True;

        {/ P122 JK 8/10/2011 - let the clinician know if some VR annots may be approximate /}
        if XMLCtl.ContainsRADEllipseAndFreeHand then
          FVistaRadMessage := ' -- Some annotations are approximate'
        else
          FVistaRadMessage := '';

        Result := True;
      end
      else
      begin
        FVistaRadMessage := '';
        Result := False;
        HasRADAnnotation := False;
        MagAppMsg('d','Cannot load the current annotation layer. There is a ' +
                              'problem with the radiology annotation XML. Contact IRM');
      end;
    end;
  finally
    FreeAndNil(AnnotXML);
    FreeAndNil(XmlString);
    FreeAndNil(XmlTmp);
  end;
end;
(*
function TMagAnnot.LoadXmlRadiology(ImageIEN, LayerNumber: String; CurrentLayer: Boolean): Boolean;
var
  FStat: Boolean;
  rpcMsg: String;
  AnnotXML: TStringList;
  XmlString: TStringList;
  XMLTmp: TStringList;
  AnnotCnt: String;
  AnnotInfo: String;
  xmlDoc: TXMLDocument;
  FN: String;
  i: Integer;
  sXML: String;
  Node: TTreeNode;
  NodeData: TAnnotNodeData;
  ScaleFactor : double;
begin
  Result := False;

  ScaleFactor := 0.5;
  {If not in the local cache, fetch it from VistA and save it in the local cache}

  AnnotXML := TStringList.Create;
  XmlString := TStringList.Create;
  XmlTmp := TStringList.Create;

  try
    {First look to see if the XML layer is in the local cache (icache/annotations/...) If not, get it
     from VistA and cache it.  We favor the cache over the backend when possible. This speeds up
     moving between histories, particularly if going over a remote connection. }

//    if not FileExists(GSess.AnnotationTempDir + UrnFix(ImageIEN) + '^' + UrnFix(LayerNumber) + '.xml') then
    if not FileExists(GSess.AnnotationTempDir + GSess.MagUrlMap.MapUrn(ImageIEN) + '^' + GSess.MagUrlMap.MapUrn(LayerNumber) + '.xml') then  {JK 8/24/2011}
    begin
      {/ P122 - JK 6/22/2011 - Get the XML from VistA}
      idmodobj.GetMagDBBroker1.RPMagAnnotGetXML(
         ImageIEN,
         LayerNumber,
         AnnotXML,
         FStat,
         rpcMsg,
         FServerName,
         FServerPort);

      if FStat = True then
      begin
        {If the AnnotXML string has a zero count then return false and exit}
        //        AnnotCnt := MagPiece(AnnotXML[0], '^', 1);
        AnnotCnt := MagPiece(AnnotXML[0], '^', 2);  //p122t6 count is piece #2

        if AnnotCnt = '0' then
        begin
          Result := False;
          magAppMsg('s', 'TMagAnnot.LoadXmlRadiology');    //p122t6
          magAppMsg('s', AnnotXML[0]);
          Exit;
        end;

        {Remove any |TAB| characters and then combine the entire stringlist into a simple
         string of XML before saving it to icache.}

        try
          if AnnotXML.Count > 0 then
            AnnotXML.Delete(0); {Remove the total line count}

          if AnnotXML.Count > 0 then
          begin
            AnnotInfo := AnnotXML[0];
            AnnotXML.Delete(0);  {Remove the owner line}
          end
          else
            AnnotInfo := 'ERROR - empty';

          if AnnotXML.Count > 0 then
          begin
            {Turn the XML stringlist into a string after removing any tab information}
            XmlString.Add(RemoveTabCharacters(AnnotXML));

//            FN := GSess.AnnotationTempDir + UrnFix(ImageIEN) + '^' + UrnFix(LayerNumber) + '.xml';
            FN := GSess.AnnotationTempDir + GSess.MagUrlMap.MapUrn(ImageIEN) + '^' + GSess.MagUrlMap.MapUrn(LayerNumber) + '.xml';  {JK 8/24/2011}
            XmlString.SaveToFile(FN);

            {Validate the XML}
            if ValidateXML(FN) then
            begin
              AnnotXML.SaveToFile(FN);

              {Now store the xml into the control}
              LoadRADAnnotation(XMLCtl,XMLString[0]);
//              FRADAnnotationCount := XMLCtl.GetRADAnnotationCount;
              HasRADAnnotation := True;

              {/ P122 JK 8/10/2011 - let the clinician know if some VR annots may be approximate /}
//              if FRADAnnotationCount > 0 then
              if XMLCtl.ContainsRADEllipseAndFreeHand then
                FVistaRadMessage := ' -- Some annotations are approximate'
              else
                FVistaRadMessage := '';

//              p122 dmmn 7/25/11 - add multipage tiff/pdf support
//              for I := 0 to PageCount - 1 do
//              begin
//                CurrentPageDisp.OffScreenDrawing := True; {/ P122 - DN 6/14/2011 - Controls redraw flicker /}
//                ArtPageList[I].ArtPage.RemoveMarks;
//                if FileExists(FN) = False then
//                  magAppMsg('s', 'LoadXmlRadiology: [1] Cannot load cached annotation file: ' + FN)
//                else   //p122 dmmn 8/11
//                  ConvertRADAnnotations(frmAnnotOptionsX.StrictRAD,ArtPageList[I].ArtPage,XMLCtl,1,1);
//              end;
//              IGPageViewCtl.UpdateView;
              Result := True;
            end
            else
            begin
              Result := False;
              MessageDlg('Cannot load the current annotation layer. There is a ' +
                'problem with the radiology annotation XML. Contact IRM', mtError, [mbOK], 0);
            end;
          end;
        except
          on E:Exception do
          begin
            Result := False;
            magAppMsg('s', 'TMagAnnot.LoadXmlRadiology (ImageIEN = ' + ImageIEN + ': Exception = ' + E.Message);
            magAppMsg('s', 'TMagAnnot.LoadXmlRadiology (ImageIEN = ' + ImageIEN + ': Exception = ' + E.Message);
          end;
        end;
      end;
    end
    else
    begin
      {The history file was found in the local cache. Use it instead of retrieving a new copy from VistA}
//      FN := GSess.AnnotationTempDir + UrnFix(ImageIEN) + '^' + UrnFix(LayerNumber) + '.xml';
      FN := GSess.AnnotationTempDir + GSess.MagUrlMap.MapUrn(ImageIEN) + '^' + GSess.MagUrlMap.MapUrn(LayerNumber) + '.xml';  {JK 8/24/2011}
      XmlTmp.Clear;
      XmlTmp.LoadFromFile(FN);

      sXML := '';
      XmlString.Clear;
      {Turn the structured XML file into one long string that is still valid xml}
      for i := 0 to XMLTmp.Count - 1 do
      begin
        sXML := sXML + XMLTmp[i];
      end;

      {Prepare to pass the XMLCtl object a stringlist with one entry. The zero index entry
      is the entire XML file in a string.}
      XmlString.Add(sXML);
      LoadRADAnnotation(XMLCtl,XMLString[0]);
//      FRADAnnotationCount := XMLCtl.GetRADAnnotationCount;

      //p122 dmmn 7/25 - added multipage support
//      for I := 0 to PageCount - 1 do
//      begin
//        CurrentPageDisp.OffScreenDrawing := True;
//        ArtPageList[I].ArtPage.RemoveMarks;
//        if FileExists(FN) = False then
//          magAppMsg('s', 'LoadXmlRadiology: [4] Cannot load cached annotation file: ' + FN)
//        else
//          ConvertRADAnnotations(frmAnnotOptionsX.StrictRAD,ArtPageList[I].ArtPage,XMLCtl,1,1);
//      end;

      IGPageViewCtl.UpdateView;

      Result := True;

    end;
  finally
    AnnotXML.Free;
    XmlString.Free;
    XmlTmp.Free;
  end;

end;   *)

{/ P122 - JK 6/17/2011 - get the history from VistA /}
procedure TMagAnnot.RefreshHistory;
begin
  if LayerList = nil then
    LayerList := TStringList.Create
  else
    LayerList.Clear;

  {Call RPC MAG GET IMAGE ANNOTATIONS LST to get a list of all layers (files) for this ImageIEN}
  GetAnnotHistoryList(ImageIEN, LayerList);

  {Load the most recent annotation history layer and draw it on the image}
  LoadAnnotationHistories(LayerList);

end;

procedure TMagAnnot.GetAnnotHistoryList(ImageIEN: String; var HistoryList: TStringList);
var
  FStat: Boolean;
  rpcMsg: String;
begin
  {/ P122 - JK 6/22/2011 - Get the XML History List from VistA}
  idmodobj.GetMagDBBroker1.RPMagAnnotGetHistory(
     ImageIEN,
     FStat,
     rpcMsg,
     HistoryList,
     FServerName,
     FServerPort);
end;

(* RCA WARNINGS
function TMagAnnot.IsHistoryCached(NodeData: TAnnotNodeData): Boolean;
begin
  if FileExists(GSess.AnnotationTempDir + NodeData.CachedFilename) then
    Result := True;
end;
      *)
procedure TMagAnnot.imgReadOnlyMouseEnter(Sender: TObject);
begin
  if imgReadOnly.Visible = False then
  begin
    Hint := '';
    ShowHint := False;
    Exit;
  end;

  ShowHint := True;

  if EditMode then
  begin
    if MarksSelected > 1 then
      Hint := 'You are in view only mode for the selected annotations'
    else
      Hint := 'You are in view only mode for the annotation just clicked'
  end
  else
  begin
    Hint := 'You are in view only mode'
  end;

end;

procedure TMagAnnot.LoadCurrentSessionLayer;
begin
  {/p122t2 dmmn 9/1 - reset the flag to reflect that user is no longer viewing history layer /}
  FIsInHistoryView := False;
  
  if isUrn(ImageIEN) then
  begin
    if MostRecentLayer <> '' then
      LoadXmlHistory(ImageIEN, MostRecentLayer, True)
    else
      LoadCurrentAnnotations;			{/p122t10 dmmn 12/7/11 - try to load the latest if layer is empty /}
  end                                        
  else
  begin
    if MostRecentLayer <> '' then
    begin
//    LoadXmlHistory(ImageIEN, '0', True);
    LoadXMLHistory(ImageIEN, MostRecentLayer, True);  // load most recent layer instead of 0
    end
    else
      LoadCurrentAnnotations;	{/p122t10 dmmn 12/7/11 - try to load the latest if layer is empty /}
  end;

  EditMode := True;

  {Turn on toolbar functionality because editmode = true}
  SetAnnotPrivileges;
//  btnMarkSettings.Enabled := True;
  btnToolSettings.Enabled := True;

  sbStatus.Panels[0].Text := ACurrentAnnotationSession;

  //p122t3 dmmn - if annotation is autoshown and nothing has been changed then reload the
  // state when image just opened up.
  if (frmAnnotOptionsX.AutoShowAnnots = '1') then
    ShowAllAnnotations(true)
  else
    HideAllAnnotations(true);

  IGPageViewCtl.UpdateView;
  RefreshAnnotInfoBar;
end;

procedure TMagAnnot.LoadTempCurrentSessionLayer;
var
  tempFileName: string;
begin
  {/p122t2 dmmn 9/1 - reset the flag to reflect that user is no longer viewing history layer /}
  FIsInHistoryView := False;
  //p122t4 dmmn 9/29
  if isUrn(ImageIEN) then
  begin
    tempFileName := GSess.AnnotationTempDir
                    + GSess.MagUrlMap.MapUrn(ImageIEN) + '^'
                    + GSess.MagUrlMap.MapUrn(MostRecentLayer) + '^T.xml';
  end
  else
  begin
    tempFileName := GSess.AnnotationTempDir
                    + ImageIEN + '^'
                    + MostRecentLayer + '^T.xml'
  end;

  EditMode := True;

  { if there is the cached file for temporary changes then load it else just load
  current layer like normal }
  if FileExists(tempFileName) then
  begin
    LoadXMLHistory(ImageIEN, MostRecentLayer + '^T', True);
  end
  else
    LoadXmlHistory(ImageIEN, MostRecentLayer, True);
  
  {Turn on toolbar functionality because editmode = true}
  SetAnnotPrivileges;
  btnToolSettings.Enabled := True;

  sbStatus.Panels[0].Text := ACurrentAnnotationSession;

  IGPageViewCtl.UpdateView;
  RefreshAnnotInfoBar;
end;

procedure TMagAnnot.tvHistoryClick(Sender: TObject);
var
  Filename : string;
begin
{P129}
  if CaptureNewImage then  {JK 6/26/2012 - don't show history during a Capture session}
    Exit;
  //p122t11 dmmn - finalize any unfinished text only when there's nothing selected
  //so that we don't lose the handle to the white are and cause exceptions later
  if ArtPageList[Page-1].ArtPage <> nil then
    if ArtPageList[Page-1].ArtPage.MarkSelectedFirst = nil then
      FinalizeText;
  { Click to current history layers which are either:
    - There's no saved annotations
    - Current history layers }
  if tvHistory.Selected.Data = nil then
  begin
    // only save when navigating from current to current or to something else
//    if sbStatus.Panels[0].Text = ACurrentAnnotationSession then
    if Not FIsInHistoryView then //9/14 use a differnt variable to check for current session instead of text
    begin
      //p122t14 dmmn - added this here to accomodate new rules by HIMS
      //since now delete only delete unsaved changes by normal user we need to recheck this
      //if the current session changed (add/delete/edit) then update the flag
      //if not, reset the flag
      FAnnotsModified := IsSessionChanged();
      // if user has made changes to the current layer then save temporary
      if FAnnotsModified then
        SaveCurrentSessionToTemp;
    end;

    // proceed to load the current session FAnnotsModified the load temp file else load latest
    if tvHistory.Selected.Text = ACurrentAnnotationSession then
    begin
      if FAnnotsModified then
        LoadTempCurrentSessionLayer
      else         // if nothing has changed in the current session then just load the latest like normally does
      begin
        LoadCurrentSessionLayer;
      end;
    end;
  end
  else     // generally the logic goes here when user navigate from current layer to another history layer when history tree is available
  begin
    {The user is about to load a history layer. Temporarily save the
     current session annotations to file in the iCache/Annotations folder in case the user made additional
     changes to the current layer}
//    if sbStatus.Panels[0].Text = ACurrentAnnotationSession then
    if Not FIsInHistoryView then
    begin
      //p122t14 dmmn - added this here to accomodate new rules by HIMS
      //since now delete only delete unsaved changes by normal user we need to recheck this
      //if the current session changed (add/delete/edit) then update the flag
      //if not, reset the flag
      FAnnotsModified := IsSessionChanged();
      if FAnnotsModified then
        SaveCurrentSessionToTemp;
    end;

    {Look to see if the file has been cached. The tvHistory data node has the
    name of the history file. If the file does not exist in the cache, get
    it from VistA and place it in the cache.}

    Filename := GSess.AnnotationTempDir + TAnnotNodeData(tvHistory.Selected.Data).FCachedFileName;
    LoadXmlHistory(ImageIEN, TAnnotNodeData(tvHistory.Selected.Data).LayerNumber, False);

    EditMode := False;
    FIsInHistoryView := True;   // turn on flag for history view

    {/p122t2 dmmn 9/6/11 - CQ:IMAG00000783 - AnnotMGR will not be able to modify marks in history view
    Turn off toolbar functionality that doesn't apply to editmode = false
    everything is strictly read only even for one with master key}
//    tbEditAnnotMarks.Enabled := False;
    mnuEditDelete.Enabled    := False;  {/p122t2 dmmn 9/6 - CQ:IMAG00000795 - enable edit menu and disable delete menus on history layer /}
    btnLine.Enabled          := False;
    btnFreehand.Enabled      := False;
    btnRectangle.Enabled     := False;
    btnText.Enabled          := False;
    btnPolyline.Enabled      := False;
    btnCircle.Enabled        := False;
    btnArrow.Enabled         := False;
    btnHighlighter.Enabled   := False;
    btnMarkSettings.Enabled  := False;
    btnProtractor.Enabled    := False;
    btnRuler.Enabled         := False;

    // if the item is not check then show all the annotations
    // else show the latest view of the previous session
    if tvHistory.Selected.Text <> AAsLastViewed then
//      ShowAllMarks;
      ShowAllAnnotations(true);

    sbStatus.Panels[0].Text := 'This History Layer is View Only';

    //p122t3 dmmn 9/14 - this should recount the number of annotations visible/hiddens
    //on every click on the history tree. So ideally, a parent node will have X total/0 hidden
    //while as last view will be X total/Y hidden if neccessary
    RefreshAnnotInfoBar;
  end;
end;

procedure TMagAnnot.tvHistoryMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
 var
   tree: TTreeView;
   hoverNode: TTreeNode;
   hitTest : THitTests;
   //ht : THitTest;
 begin
   if (Sender is TTreeView) then
     tree := TTreeView(Sender)
   else
     Exit;
 
   hoverNode := tree.GetNodeAt(X, Y) ;
   hitTest := tree.GetHitTestInfoAt(X, Y) ;
 
  (*
   //list the hitTest values
   Caption := '';
   for ht in hitTest do
   begin
     Caption := Caption + GetEnumName(TypeInfo(THitTest), integer(ht)) + ', ';
   end;
   *)
 
   if (lastHintNode <> hoverNode) then
   begin
     Application.CancelHint;

     if (hitTest <= [htOnItem, htOnIcon, htOnLabel, htOnStateIcon]) then
     begin
       lastHintNode := hoverNode;
       //tree.Hint := NodeHint(hoverNode);
     end;
   end;
end;

(* RCA WARNINGS
function TMagAnnot.NodeHint(tn: TTreeNode): String;
var
  sSavedDateTime, sDUZ, sService, sSource, sDeletion: String;
begin
  if tn.Data <> nil then
  begin
    sSavedDateTime := TAnnotNodeData(tn.Data).SavedDateTime;
    sDUZ           := TAnnotNodeData(tn.Data).DUZ;
    sService       := TAnnotNodeData(tn.Data).Service;
    sSource        := TAnnotNodeData(tn.Data).Source;
    sDeletion      := TAnnotNodeData(tn.Data).Deletion;

    Result := sSavedDateTime + ', ' + sDUZ + ', ' + sService + ', ' + sSource + ', ' + sDeletion;
  end
  else
    Result := 'no data to display';
end;
*)
procedure TMagAnnot.LoadAnnotationHistories(LayerList: TStringList);
var
  i: Integer;
  Root, Node: TTreeNode;
  NodeData: TAnnotNodeData;
  LayerCount: Integer;
begin
  tvHistory.Items.Clear;

  {If the LayerList count is 0, then nothing was previously saved for this image.
   If the LayerList count is 1 then we can restore the current session. There are no
   older history layers yet.}

   if LayerList.Count > 0 then
   begin
     try
       if MagPiece(LayerList[0], '^', 1) = '0' then
         Exit;
       LayerCount := StrToInt(MagPiece(LayerList[0], '^', 2));
     except
       LayerCount := 0;
     end;
   end
   else
     LayerCount := 0;

  case LayerCount of
    0: begin
         {Nothing was saved previously}
         Root := tvHistory.Items.Add(nil, ANoAnnotsSaved);

         Root := tvHistory.Items.Add(nil, ACurrentAnnotationSession);
         NodeData                := TAnnotNodeData.Create;
         NodeData.LayerNumber    := '1';
         NodeData.UserName       := idmodobj.GetMagDBBroker1.GetBroker.User.Name;
         NodeData.SavedDateTime  := '';
         NodeData.Version        := MagIGManager.Version;
         NodeData.Source         := 'CLINICAL_DISPLAY';
         NodeData.Deletion       := '0';  {'0' = False}
         NodeData.Resulted       := '';  {Don't know at this stage}
         NodeData.Service        := idmodobj.GetMagDBMVista1.GetBroker.User.ServiceSection; 
         NodeData.SiteID         := GSess.WrksInstStationNumber;
         NodeData.DUZ            := idmodobj.GetMagDBBroker1.GetBroker.User.DUZ;
         NodeData.CachedFileName := ImageIEN + '^CurrentSession.xml';
    end;
    1: begin
         {only one history (the current session) was saved previously}
         Root := tvHistory.Items.Add(nil, ACurrentAnnotationSession);
         NodeData                := TAnnotNodeData.Create;
         NodeData.LayerNumber    := MagPiece(LayerList[i+1], '^', 1);
         NodeData.UserName       := MagPiece(LayerList[i+1], '^', 2);
         NodeData.SavedDateTime  := MagPiece(LayerList[i+1], '^', 3);
         NodeData.Version        := MagPiece(LayerList[i+1], '^', 4);
         NodeData.Source         := MagPiece(LayerList[i+1], '^', 5);
         NodeData.Deletion       := MagPiece(LayerList[i+1], '^', 6);
         NodeData.Resulted       := MagPiece(LayerList[i+1], '^', 7);
         NodeData.Service        := MagPiece(LayerList[i+1], '^', 8);
         NodeData.SiteID         := MagPiece(LayerList[i+1], '^', 9);
         NodeData.DUZ            := MagPiece(LayerList[i+1], '^', 10);
         NodeData.CachedFileName := ImageIEN + '^1.xml';

//         tvHistory.Items.AddChildObject(Root, AAsLastViewed, NodeData);
        //p122 dmmn 7/27 - for only only one hisotry image, it should show the
        // current session and the entry for the previous session
        // the entry should show the Date,Name,Service
         Node := tvHistory.Items.AddChildObject(Root, '[All Annots] ' + NodeData.SavedDateTime + ', ' +
                                                      NodeData.UserName + ', ' +
                                                      NodeData.Service , NodeData);
    end;
    else begin
         {The LayerList orders the list in oldest to newest with the most recent session as
          index ..n }
         Root := tvHistory.Items.Add(nil, ACurrentAnnotationSession);
         for i := LayerList.Count - 1 downto 1 do
         begin
           NodeData                := TAnnotNodeData.Create;
           NodeData.LayerNumber    := MagPiece(LayerList[i], '^', 1);
           NodeData.UserName       := MagPiece(LayerList[i], '^', 2);
           NodeData.SavedDateTime  := MagPiece(LayerList[i], '^', 3);
           NodeData.Version        := MagPiece(LayerList[i], '^', 4);
           NodeData.Source         := MagPiece(LayerList[i], '^', 5);
           NodeData.Deletion       := MagPiece(LayerList[i], '^', 6);
           NodeData.Resulted       := MagPiece(LayerList[i], '^', 7);
           NodeData.Service        := MagPiece(LayerList[i], '^', 8);
           NodeData.SiteID         := MagPiece(LayerList[i], '^', 9);
           NodeData.DUZ            := MagPiece(LayerList[i], '^', 10);
           NodeData.CachedFilename := ImageIEN + '^' + IntToStr(i) + '.xml';

//           Node := tvHistory.Items.AddChildObject(Root, NodeData.SavedDateTime + ' [All Annots]', NodeData);
           Node := tvHistory.Items.AddChildObject(Root, '[All Annots] ' + NodeData.SavedDateTime + ', ' +
                                                        NodeData.UserName + ', ' +
                                                        NodeData.Service , NodeData);
         end;
    end;

    if tvHistory.Items[0] <> nil then
    begin
      tvHistory.Selected := tvHistory.Items[0];
      tvHistory.HideSelection := False;
    end;
  end;

end;

(* RCA WARNINGS
procedure TMagAnnot.SaveSessionViewToTemp;
begin
  XMLCtl.SaveCurrentHistoryToDB;
end;
*)
function TMagAnnot.LoadAnnotations(HistXML: string): Boolean;
{ Load history layer when user clicked on the audit history list }
begin
  XMLCtl.LoadHistoryView(HistXML);
  LoadAllArtPages;
  ChangeAnnotationPage(Page,Page);
end;

procedure TMagAnnot.LoadAllArtPages;
{ Load all the artpages with annotation from a history file }
var
  I : Integer;
  APTemp : IIGArtXPage;
  fName : string;
begin
  for i  := 0 to ArtPageList.Count - 1 do
    ArtPageList[i].ArtPage.RemoveMarks;

  fName := GSess.AnnotationTempDir + ImageIEN + '^PXML.xml';

  for I := 0 to PageCount - 1 do
  begin
    XMLCtl.LoadHistoryToArtPage(I);

    CurrentPageDisp.OffScreenDrawing := True; {/ P122 - DN 6/14/2011 - Controls redraw flicker /}

    APTemp := ArtPageList[i].ArtPage;
    APTemp.RemoveMarks;
    if FileExists(fName) = False then
      magAppMsg('s', 'LoadAllArtPages: Cannot load cached annotation file: ' + fName);
    APTemp.LoadFile(fName, 1, False);
    ArtPageList[i].ArtPage := APTemp;
    IGPageViewCtl.UpdateView;
    SysUtils.DeleteFile(fName);
  end;
end;

(* RCA WARNINGS
procedure TMagAnnot.GetHistories(FileList: TStringList; var HistoryList : TStringList);
var
  I: Integer;
  temp : TStringList;
  xmlDoc : IXMLDocument;
  tmpstr : string;
  valstr : string;
  onPos : integer;
begin
  temp := TStringList.Create;
  xmlDoc := TXMLDocument.Create(nil);

  HistoryList.Clear;
  for I := 0 to HistoryList.Count - 1 do
  begin
    tmpstr := HistoryList[i];
    HistoryList.Add(tmpstr);
  end;
  temp.Free;
  xmlDoc := nil;
end;
*)
procedure TMagAnnot.ChangeAnnotationPage(curPageNum,nextPageNum: Integer);
{ This function will change the active artpage according to the page navigating
set by Gear4V. This should work for both single page and multipage image although
single page image shouldn't have to use this function in the first place}
begin
//  // boundary check
//  if curPageNum < 0 then Exit;
//  if nextPageNum > PageCount then Exit;
//
//  // Check single page
//  if PageCount > 1 then
//  begin
//    // copy next artpage and change to current artpage
//    FArtPages[curPageNum] := ArtPage;
//    ArtPage := FArtPages[nextPageNum];
//    IGArtXGUICtl.ArtXPage := ArtPage;
//    ArtPage.AssociatePageDisplay(CurrentPageDisp);
//  end
//  else
//  begin
//    IGArtXGUICtl.ArtXPage := ArtPage;
//    ArtPage.AssociatePageDisplay(CurrentPageDisp);
//  end;
end;

Procedure TMagAnnot.actFileLoadExecute(Sender: Tobject);
Begin
  LoadFile();
End;

Procedure TMagAnnot.CreatePage;
Var
  LoadOptions: IIGLoadOptions;
  SaveOptions: IIGSaveOptions;
Begin
  ResetPageGlobals();
  CurrentPage := IGCoreCtl.CreatePage;
  CurrentPageDisp := IGDisplayCtrl.CreatePageDisplay(CurrentPage);
  IGPageViewCtl.PageDisplay := CurrentPageDisp;
  SaveOptions := IGFormatsCtrl.CreateObject(IG_FORMATS_OBJ_SAVEOPTIONS) As IIGSaveOptions;
  SaveOptions.Format := IG_SAVE_UNKNOWN;
  LoadOptions := IGFormatsCtrl.CreateObject(IG_FORMATS_OBJ_LOADOPTIONS) As IIGLoadOptions;
  LoadOptions.Format := IG_FORMAT_UNKNOWN;
  SetMenus;
End;

//Function TMagAnnot.GetIGPageViewCtl(Parent: TWinControl): TIGPageViewCtl;
//Begin
//  FIGPageViewCtl_.Parent := Parent;
//  FIGPageViewCtl_.Align := alClient;
//  SetIGPageViewCtl(FIGPageViewCtl_);
//  IGPageViewCtl.UpdateView();
//  CreatePage();
//  Result := FIGPageViewCtl;
//End;

//Function TMagAnnot.GetAnnotationOptions: TfrmAnnotOptions;
Function TMagAnnot.GetAnnotationOptions: TFrmAnnotOptionsX;
Begin
//  Result := AnnotationOptions;
  Result := frmAnnotOptionsX; //p122 dmmn 7/9/11
End;



{This routine is called from cMag4VGear when a loadImage call is made. This
 procedure loads the most recent XML layer over the newly loaded image.}
procedure TMagAnnot.LoadCurrentAnnotations;
var
  i: Integer;
begin
  {p129  If New Image,  no CurrentAnnotations, so exit;}
if ImageIEN = '' then exit; //p129 gek.  
  {Ensure that all cached files for this IEN are removed}
  if isUrn(ImageIEN) then
//    DeleteCachedFiles(GSess.AnnotationTempDir, UrnFix(ImageIEN) + '*.xml')
    DeleteCachedFiles(GSess.AnnotationTempDir, GSess.MagUrlMap.MapUrn(ImageIEN) + '*.xml')  {JK 8/24/2011}
  else
//    DeleteCachedFiles(GSess.AnnotationTempDir, ImageIEN + '*.xml');
    DeleteCachedFiles(GSess.AnnotationTempDir, GSess.MagUrlMap.MapUrn(ImageIEN) + '*.xml');  {JK 8/24/2011 - PM}

  {Get the list of history layers from VistA and populate the HistoryList object}
  if LayerList = nil then
    LayerList := TStringList.Create
  else
    LayerList.Clear;

  {Call RPC MAG GET IMAGE ANNOTATIONS LST to get a list of all layers (files) for this ImageIEN}
  //p122t15 dmmn 7/10/12 - Disable retrieving and displaying VistaRAD annotation
//  if Not RADPackage then
//  begin
//    GetAnnotHistoryList(ImageIEN, LayerList);
//  end;

  {/ P122 T5 - JK 7/13/2012 - Get the count of VistARad annotations, if any /}
  FAnnotatedByVR := False;
  GetAnnotHistoryList(ImageIEN, LayerList);
  if (LayerList.Count > 0) and RADPackage then
  begin
    if MagPiece(LayerList[0], '^', 2) > '0' then
    begin
      FAnnotatedByVR := True;
    end;
    for i := LayerList.Count - 1 downto 0 do
      LayerList.Delete(i);
  end;

  //p122 dmmn 8/5/11 - the number of layer actually at the secon piece now
//  if MagPiece(LayerList[0], '^', 1) = '0' then
//    magAppMsg('s', MagPiece(LayerList[0], '^', 2));

  {JK 9/8/2011}
  if LayerList.Count = 0 then
    Exit;

  if MagPiece(LayerList[0], '^', 2) = '0' then
  begin
    // no annotation
    magAppMsg('s', MagPiece(LayerList[0], '^', 3));
    //p122 dmmn reset the flag in case the annotation component is reused
    if RADPackage then
    begin
      HasRADAnnotation := False;
      XMLCtl.ClearRADAnnotation; //p122t4 dmmn 10/3 - clear old rad
      FVistaRadMessage := '';
      FRadInfo.iIEN := ImageIEN;
      FRadInfo.radAnnotCount := 0;
      FRadInfo.radIGmapped := 0;
      FRadInfo.radOutside := false;
    end;
  end;

  {Get the most recent saved history layer XML and display it on top of the image}
  if LayerList.Count > 0 then
  begin
    try
      {The first piece is the rpc status. Piece 2 is the layer count}
      if MagPiece(LayerList[0], '^', 2) = '0' then
      begin
        {Delete any existing marks. }
        DeleteAllMarksOnAllPages;      //p122t10 dmmn 12/6/11 - fix clearing multipage images for image that has no prior annot history
//        DeleteAllMarks;
        Exit; {There are no saved layers for this ImageIEN}
      end;

        MostRecentLayer := MagPiece(LayerList[0], '^', 2); {The first item in the list is the count of history layers and
                                                            the last one is the most recent (ordered from oldest to newest
                                                            as 1..n}

        if isUrn(MagPiece(LayerList[StrToInt(MostRecentLayer)], '^', 1)) then
          MostRecentLayer := MagPiece(LayerList[StrToInt(MostRecentLayer)], '^', 1);


      {p122 dmmn 8/2 - check to see which package is the image belonged to and load annotation accordingly /}
      if RADPackage then
      begin
        if LoadXmlRadiology(ImageIEN, MostRecentLayer, True) then
        begin
          AnnotSessionDateTime := Formatdatetime('YYYYMMDDHHNNSS', Now());
        end;
      end
      else      // loading non RAD package images
      begin
        // p122t15 dod
        if IsDODImage then
        begin
          AnnotSessionDateTime := Formatdatetime('YYYYMMDDHHNNSS', Now());
        end
        else
        begin
        if LoadXmlHistory(ImageIEN, MostRecentLayer, True) then
        begin
          AnnotSessionDateTime := Formatdatetime('YYYYMMDDHHNNSS', Now());
        end;
      end;
      end;

    except
      on E:Exception do
        magAppMsg('s', 'TMagAnnot.GetAnnotationOptions exception = ' + E.Message);
    end;
  end;
end;

procedure TMagAnnot.DeleteAllMarks;
var
  Count: Integer;
  CurMark: IIGArtXMark;
  iter: Integer;
  MarkArray: IIGArtXMarkArray;
begin
  iter := 0;
  MarkArray := IGArtXCtl.CreateObject(IG_ARTX_OBJ_MARK_ARRAY) As IIGArtXMarkArray;
  try

    If (IsValidEnv()) Then
    begin
      Count := ArtPageList[Page-1].ArtPage.MarkCount;
      MarkArray.Resize(Count);

      CurMark := ArtPageList[Page-1].ArtPage.MarkFirst;

      While (Not (CurMark = Nil)) Do
      Begin
        MarkArray.Item[iter] := CurMark;
        iter := iter + 1;
        CurMark := ArtPageList[Page-1].ArtPage.Marknext(CurMark);
      End;

      ArtPageList[Page-1].ArtPage.RemoveMarksArray(MarkArray);
      IGPageViewCtl.UpdateView;
    end;
  finally
    CurMark := nil;
    MarkArray := nil;
  end;

end;


procedure TMagAnnot.DeleteAllMarksOnAllPages;
var
  I: Integer;
begin
  {/p122t10 dmmn 12/6/11 - delete all marks on all pages when there's nothing saved before /}
  try
    If (IsValidEnv()) Then
    begin
      for I := 0 to ArtPageList.Count - 1 do
      begin
        ArtPageList[I].ArtPage.RemoveMarks;
      end;
    end;
  except
    on E:Exception do
    begin
      MagAppMsg('s', 'TMagAnnot.DeleteAllMarksOnAllPages exception = ' + E.Message);
      MagAppMsg('s', 'ArtPageList count ' + IntToStr(ArtPageList.Count) + ', I: ' + IntToStr(I));
    end;
  end;
end;

(* RCA Warnings
procedure TMagAnnot.LoadAnnotationHistory;
var
  MostRecentLayer: String;
begin
  {Get the list of history layers from VistA and populate the HistoryList object}
  RefreshHistory;

  {Get the most recent saved history layer XML and display it on top of the image}
  if LayerList.Count > 0 then
  begin
    try
      if MagPiece(LayerList[0], '^', 1) = '0' then
        Exit;

      MostRecentLayer := MagPiece(LayerList[0], '^', 2); {The first item in the list is the count of history layers and
                                                         the last one is the most recent (ordered from oldest to newest
                                                         as 1..n}

      if LoadXmlHistory(ImageIEN, MostRecentLayer, False) then
      begin
        AnnotSessionDateTime := Formatdatetime('YYYYMMDDHHNNSS', Now());
      end;
    except
      on E:Exception do
        magAppMsg('s', 'TMagAnnot.LoadAnnotationHistory exception = ' + E.Message);
    end;
  end;
end;
*)
{/ P122 - JK 6/10/2011 - this method saves the editable ArtX page as a the current annotation layer.
   Cancelling is complicated by the history layers.  If a user is displaying a history layer and
   new annotations were put on the current session layer (not currently in view), we must ask if the user intends to
   save the current session layer.  We want to protect against a history layer becoming the new
   current annotation layer that gets saved to VistA.  Also complicating this is the MAG ANNOTATE MGR
   key.  Can the key holder change history or just the latest layer?  I have it programmed to
   only let the manager save changes in the current layer.  I am basing this on functional
   requirement 2.4.1.13.  It says the manager can modify marks of other users without restriction
   but it does not say anything about modifying history layers. The way the save RPC works is that whatever it
   saves becomes a new history layer. I think that if we are going to let the Manager edit history layers, we
   need a special RPC that updates an existing layer while not adding a new layer. This would require editing
   the XML upon saving.  /}
{/p122 dmmn 10/7/11 - I'm using CloseWindow as an indicator to see if the method is called by form
close or not. If it's called by something that doesnt need to have annotation visibly updated or FormClose,
then the saving and reloading process is being done completely.
If it's called by others, then we need to reload the annotations if necessary /}
function TMagAnnot.SaveAnnotationLayer(CloseWindow: Boolean): TAnnotWindowCloseAction;
var
  i: Integer;
// Out in 122t11 tempPoint : IIGPoint;
begin
  //p122t11 dmmn 1/24 - call common procedure
  FinalizeText;


  {JK 9/21/2011 - add the default close action behavior. }
  Result := awCloseAbandon;

  {If the image does not have an annotation history and there are no annotation marks
   on the image when the user requests to exit annotation mode, don't save a history layer
   even if the user may have added marks and deleted them prior to exiting in this annotation session. }
 {p129 LayerList is nil.....}
   if (LayerList <> nil) and (LayerList.Count > 0) then          //p122t15 condition check
   begin

        if ((MarkCount + HiddenCount) = 0) and (MagPiece(LayerList[0], '^', 2) = '0') then
        begin
          FAnnotsModified := False;
          Result := awCloseSave;
          Exit;
        end;
   end;
  {/p122t7 dmmn 10/31 - check if there's new/edited/deleted annotation in the current session /}
  if Not FIsInHistoryView and Not IsSessionChanged then
  begin
    FAnnotsModified := False;
    FOldAnnotsDeleted := False;
    Exit;
  end;

//  if FAnnotsModified and (EditMode = False) then
  if FAnnotsModified and FIsInHistoryView then  //p122t4 better check for history view
  begin
    //p122t14 - change message to reflect new update
    {/ P122 T15 - JK 7/19/2012 - Added mbCancel as the default button that has focus when the dialog is displayed. Per Cliff Sorensen. /}
    case MessageDlg(
                  'You are viewing annotations from a read-only history layer.'#13#10 +
                  'You have made changes to the current annotation session. These changes will be saved'#13#10 +
                  'permanently to the patient record and can only be modified by authorized personnel once saved.' +
                  #13#10 + #13#10 + 'Click: ' + #13#10 + #13#10 +
                  '   YES to permanently save the changes and exit annotation mode.' + #13#10 +
                  '   NO to discard the changes and exit annotation mode.' + #13#10 +
                  '   CANCEL to resume working in annotation mode.',
      mtConfirmation, [mbYes, mbNo, mbCancel], 0, mbCancel) of
      mrYes:  begin
//                 LoadCurrentSessionLayer;
                 LoadTempCurrentSessionLayer; //p122t2 dmmn 9/2 - since we are in the history view,
                                              //if there are any changes then the latest will be in the temp file
                                                                                                    
                 SaveAnnotations;
                 FAnnotsModified := False;
                 FOldAnnotsDeleted := False;  //p122t7
                 Result := awCloseSave;
                 LoadCurrentAnnotations;	{/p122t10 load latest after save /}
               end;
      mrNo: begin
                FAnnotsModified := False;
                FOldAnnotsDeleted := False;   //p122t7
                Result := awCloseAbandon;
                LoadCurrentAnnotations;		{/p122t10 load latest and discard changes /}
              end;
      mrCancel:  Result := awCancel;
    end;
    if (Result <> awCancel) then
      FIsInHistoryView := False; //p122 dmmn 9/2 - reset the flag before exiting
  end
  else
  if FAnnotsModified then
  begin
    {/ P122 JK 10/3/2011 /}
    if not FHasMasterKey then
    begin
      if FHasAnnotatePermission = False then
      begin
//        ShowMessage('The annotation layout has been altered. Change(s) made to ' +
//                    'annotations that you didn''t originate will not be saved.');
        ShowMessage('You don''t have permission to save. Change(s) will not be saved.'); //p122t3 dmmn 9/13
        FAnnotsModified := False;
        Result := awCloseAbandon;
        Exit;
      end;
    end;
    {/ P122 T15 - JK 7/19/2012 - Added mbCancel as the default button that has focus when the dialog is displayed. Per Cliff Sorensen. /}

    case MessageDlg('You have made changes to the current annotation session. These changes will be saved'#13#10 +
                    'permanently to the patient record and can only be modified by authorized personnel once saved.' +
                    #13#10 + #13#10 + 'Click: ' + #13#10 + #13#10 +
                    '   YES to permanently save the changes and exit annotation mode.' + #13#10 +
                    '   NO to discard the changes and exit annotation mode.' + #13#10 +
                    '   CANCEL to resume working in annotation mode.',
      mtConfirmation, [mbYes, mbNo, mbCancel], 0, mbCancel) of
        mrYes: begin
                 SaveAnnotations;
                 FAnnotsModified := False;
                 FOldAnnotsDeleted := False;  //p122t7
                 Result := awCloseSave;
                 LoadCurrentAnnotations;		{/p122t10 load latest after save /}
               end;
        mrNo: begin
                {Reload the latest history}
//                LoadCurrentAnnotations;
                FAnnotsModified := False;
                FOldAnnotsDeleted := False;  //p122t7
                Result := awCloseAbandon;

                LoadCurrentAnnotations;

              end;
        mrCancel: Result := awCancel;
    end;
  end;
  {/p122t8 dmmn 11/11/11 - reset the boolean of delete if user reuse the gear /}
  if (Result = awCloseSave) or (Result = awCloseAbandon) then
  begin
    for I := 0 to ArtPageList.Count - 1 do
      ArtPageList[I].MarkDeleted := False;
  end;

  if (not FAnnotsModified) and (FIsInHistoryView) then
  begin
    Result := awCloseAbandon;
    FIsInHistoryView := False;

    if Not CloseWindow then     //p122t5 reload the latest if user close inadvertently (through proxy call)
      LoadCurrentAnnotations;
  end;
end;

{
129T18 dmmn 5/6/13 - Added two extra optional parameters:
  - fromCapture:  this is to distinguish betweeen a save from display and a save
                  from capture. Defaulted to Display
  - isTRCImage: this parameter only applies when saving from capture, because
                the converted DCM images is the orginal image, so we need matching
                annotaiton to the original image similar to display
}
procedure TMagAnnot.SaveAnnotations(forceIEN : string = ''; fromCapture : boolean = false; isTRCImage :boolean = false);   {p129 Stuff IEN and make this call.}
var
  XmlFileName: String;
begin
  if forceIEN <> '' then
    ImageIEN := forceIEN;

  if ImageIEN = '' then
  begin
    Showmessage('TMagAnnot.SaveAnnotations: ImageIEN is empty. Exiting');
    magAppMsg('s', 'TMagAnnot.SaveAnnotations: ImageIEN is empty. Exiting');
    Exit;
  end;

  AnnotSessionDateTime := Formatdatetime('YYYYMMDDHHNNSS', Now());
  UpdateEditedMarksWithNewOwnership; //p122t2 dmmn 8/31 - update new ownerships
  UpdateMarksWithTimeSaved(AnnotSessionDateTime);
  {7/12/12 gek Merge 130->129}
{ TODO -op129 :  we'll have to skip the rotate/ unrotate for capture .}
  {/p129t18 dmmn 5/6/13
    - Because Capture capture the images as is so all the the rotating, flipping
    will also stored into VistA. This make it unecessary to revert the changes
    unlike Display. So when IsCapture is true, we're going to skip this processing
    - However, if the save is from Capture and is a telereader consult DCM converted
    image, we still need to revert the changes because capture store the original
    images without the rotating/flipping changes
  }
  if (Not fromCapture) or ((fromCapture) and (isTRCImage)) then
  begin
    //p122t3 dmmn - undo rotating here since the page will revert back to normal when returned
    while (ArtPageList[Page-1].RotatedRight > 0) do
    begin
      RotateArtPageMarks(Page,3);   // rotate left back
    end;
    while (ArtPageList[Page-1].RotatedLeft > 0) do
    begin
      RotateArtPageMarks(Page,1);   // rotate right back
    end;

    if (ArtPageList[Page-1].FlippedVer) then
    begin
      FlipArtPagemarks(Page,IG_FLIP_VERTICAL);
    end;
    if (ArtPageList[Page-1].FlippedHor) then
    begin
      FlipArtPagemarks(Page,IG_FLIP_HORIZONTAL);
    end;
  end;

  //p122t4 make sure that the information is stored into vista correctly to the
  //current user
  XMLCtl.UpdateSessionInfo(ImageIEN,Username,Service,ConsultResulted,FDUZ,FSiteNum);
  SaveAllArtPages;

  XmlFileName := XMLCtl.SaveHistoryXML;

  SaveXmlToVista(XmlFileName);

end;

procedure TMagAnnot.SaveXmlToVista(XmlFileName: String);
const
  MaxLineLength = 200;
var
  FStat: Boolean;
  RPCMsg: String;
  AnnotXML: TStringList;
  i,j: Integer;
  LineLength: Integer;
  sList, dList: TStringList;
  FName: String;
  XMLLine: String;

  procedure ChopLine(S: String; MaxLen: Integer; var dList: TStringList);
  var
    idx: Integer;
    sTmp: String;
  begin
    idx := 0;
    sTmp := S;
    while Length(sTmp) > 0 do
    begin
      sTmp := System.Copy(sTmp, 1, MaxLen);
      dList.Add(sTmp);
      idx := idx + MaxLen;
      sTmp := System.Copy(S, idx+1, Length(sTmp));
    end;
  end;

begin
  if ImageIEN = '' then
  begin
    MessageDlg('Save Annotations: Image IEN is empty, exiting', mtError, [mbOK], 0);
    magAppMsg('s', 'TMagAnnot.SaveXmlToVista Error: IEN is empty - exiting. XmlFileName = ' + XmlFileName);
    Exit;
  end;

  AnnotXML := TStringList.Create;
  try
    {Load the XML from file...later from VistA}
    AnnotXML.LoadFromFile(XmlFileName);

    {Ensure there are no leading or trailing blanks that bloat the line length unnecessarily.}
    for i := 0 to AnnotXML.Count - 1 do
      AnnotXML[i] := Trim(AnnotXML[i]) + '^\r\n^';       //p122T1 dmmn - newline delim

    {Chop up lines and reassemble the XML line list if individual lines
     exceed the maximum line length.  Fileman line limit is an issue
     so I chop the lines at the MaxLineLength that is defined in the constant above. }
    sList := TStringList.Create;
    dList := TStringList.Create;
    try
      XMLLine := '';
      for i := 0 to AnnotXML.Count - 1 do
        XMLLine := XMLLine + AnnotXML[i];

      sList.Clear;
      ChopLine(XMLLine, MaxLineLength, sList);
      for j := 0 to sList.Count - 1 do
        dList.Add(sList[j]);

    finally
      AnnotXML.Clear;
      AnnotXML.Assign(dList);
      sList.Free;
      dList.Free;
    end;

    {Add the count of lines as index zero.  This is needed by the RPC call to M}
    AnnotXML.Insert(0, IntToStr(AnnotXML.Count));

    {This chopped file is optional in order to let the developer see what is written to VistA}

    {/ P112 - JK 7/15/2011 - strip of the urn portion of a remote image view IEN /}
//    FName := GSess.AnnotationTempDir + UrnFix(FImageIEN) + '-ChoppedXML.txt';
    FName := GSess.AnnotationTempDir + GSess.MagUrlMap.MapUrn(FImageIEN) + '-ChoppedXML.txt';  {JK 8/24/2011}

    if FileExists(FName) then
      DeleteFile(FName);

    AnnotXML.SaveToFile(FName);
    {Insert the XML into VistA}            {p129  Display to Capture }
    idmodobj.GetMagDBBroker1.RPMagAnnotSaveXML(
       ImageIEN,
       'CLINICAL_DISPLAY',
       MagIGManager.Version,
       AnnotXML,
       '0',
       FStat,
       RPCMsg,
       FServerName,
       FServerPort);

  finally
    AnnotXML.Free;
  end;
end;

procedure TMagAnnot.ScaleRadAnnotations(DcmCol, DcmRow: integer);
var
  XFactor : double;
  YFactor : double;
begin
  {JK 8/24/2011 - In some cases the input params are set to zero resulting in a divide by zero exception.
   If this happens, exit before division occurs. }
  if (DcmCol = 0) or (DcmRow = 0) then
  begin
    //p122t11 dmmn 1/24/12 - if col/row 0-0 then set factors to 1x1}
    RADDicomCol := CurrentPage.ImageWidth;
    RADDicomRow := CurrentPage.ImageHeight;
  end
  else
  begin

  {/p122 dmmn 8/3/11 - scale annotations made in VistaRAD to fit with the current
  loaded downsized and fulres images /}
  RADDicomCol := DcmCol;
  RADDicomRow := DcmRow;
  end;

  XFactor := CurrentPage.ImageWidth / RADDicomCol;
  YFactor := CurrentPage.ImageHeight / RADDicomRow;

  FRADAnnotationIGCount := ConvertRADAnnotations('0',       // strict rad = false
                                                 ArtPageList[CurrentPageNumber].ArtPage,
                                                 XMLCtl,
                                                 XFactor,
                                                 YFactor);
  //p122t3 dmmn 9/22
  with RadInfo do
  begin
    iIEN := ImageIEN;
    radAnnotCount := XMLCtl.GetRADAnnotationCount;
    radIGmapped := FRADAnnotationIGCount;
    radOutside := false;
  end;

  RefreshAnnotInfoBar;
  IGPageViewCtl.UpdateView;
end;


procedure TMagAnnot.SaveAllArtPages;
{ Go through all the available artpages in the image and store that page into
a main history file for the current session }
var
  i : integer;
  fName : string;
  markCount : Integer;
begin
  if ImageIEN = '' then
  begin
    Showmessage('TMagAnnot.SaveAllArtPages: ImageIEN is empty. Exiting');
    magAppMsg('s', 'TMagAnnot.SaveAllArtPages: ImageIEN is empty. Exiting');
    Exit;
  end;

  {/ P112 - JK 7/15/2011 - strip of the urn portion of a remote image view IEN /}
//  fName := GSess.MagUrlMap.MapUrn(ImageIEN) + '^PXML.xml';  {JK 8/24/2011}
  {/p122t4 dmmn 9/29 - make a more consistent format of the file name being saved and loaded /}
  if isUrn(ImageIEN) then
    fName := GSess.MagUrlMap.MapUrn(ImageIEN) + '^PXML.xml'
  else
    fName := ImageIEN + '^PXML.xml';

  // go through all the artpages in the image and export to XML
//  ForceDirectories(GSess.AnnotationTempDir);  {/p129 gek/duc stop access violation}    {JK - remove it from here and put it in FmagCapMain}
  try
  for i := 0 to PageCount-1 do
  begin
    markCount := ArtPageList[i].ArtPage.MarkCount;   //FArtPages[I].MarkCount;
    ArtPageList[i].ArtPage.SaveFile(GSess.AnnotationTempDir + fName, 1, True, IG_ARTX_SAVE_XML );
    XMLCtl.SaveArtPageToHistory(fName, i, markCount);
    SysUtils.DeleteFile(GSess.AnnotationTempDir + fName);
    end;
  except
    on E:Exception do  {JK 6/26/2012 - added to check for page count inaccuracy causing loop issues with artpage}
    begin
      Showmessage('TMagAnnot.SaveAllArtPages: MarkCount = ' + IntToStr(MarkCount) +
        ' PageCount = ' + IntToStr(PageCount) + ' ArtPageList.Count = ' + IntToStr(ArtPageList.Count) + ' *** exception = ' + E.Message);
      magappmsg('s', 'TMagAnnot.SaveAllArtPages: MarkCount = ' + IntToStr(MarkCount) +
        ' PageCount = ' + IntToStr(PageCount) + ' ArtPageList.Count = ' + IntToStr(ArtPageList.Count) + ' *** exception = ' + E.Message);
    end;
  end;
  FAnnotsModified := False;  {/ P122 - reset the flag to false after saving the work to VistA /}
end;
(* RCA WARNINGS
procedure TMagAnnot.SaveCurrentSeesionAllArtPages;
{ Go through all the available artpages in the image and store that page into
a main history file for the current session }
var
  i : integer;
  fName : string;
  markCount : Integer;
begin
  fName := ImageIEN + '~CS_PXML.xml';
  // go through all the artpages in the image and export to XML
  for i := 0 to PageCount-1 do
  begin
    // reset the flips, rotate before saving
    {TODO -oDuc -cImportant : Undo rotate/flip before saving }

    markCount := ArtPageList[i].ArtPage.MarkCount;   //FArtPages[I].MarkCount;
    ArtPageList[i].ArtPage.SaveFile(GSess.AnnotationTempDir + fName, 1, True, IG_ARTX_SAVE_XML );
    XMLCtl.SaveArtPageToHistory(fName, i, markCount);
//    SysUtils.DeleteFile(GSess.AnnotationTempDir + fName);
  end;
  FAnnotsModified := False;  {/ P122 - reset the flag to false after saving the work to VistA /}
end;
*)
procedure TMagAnnot.SaveCurrentSessionToTemp;
var
  tempFileName : string;
  sessionModified : boolean;
begin
  {/p122t2 dmmn 9/2 this is the common procedure to be called when user modified the current session
  and want to change views or actions /}
  sessionModified := FAnnotsModified;    //p122t2 dmmn 9/2 -check to see if user has made
                                         //changes to the current session
  //p122t4 stay same naming format
  if isUrn(ImageIEN) then
  begin
      tempFileName := GSess.AnnotationTempDir
                      + GSess.MagUrlMap.MapUrn(ImageIEN) + '^'
                      + GSess.MagUrlMap.MapUrn(MostRecentLayer) + '^T.xml';
  end
  else
  begin
    tempFileName := GSess.AnnotationTempDir
                    + ImageIEN + '^'
                    + MostRecentLayer + '^T.xml'
  end;

  // if there's is old temp copy then delete and save new one
  if FileExists(tempFileName) then
    DeleteFile(tempFileName);

  SaveAllArtPages;
  XMLCtl.SaveCurrentHistoryTemporary(tempFileName);
  FAnnotsModified := sessionModified; // restore the flag after temp save
end;

procedure TMagAnnot.SetCompHorizontal;
var
  FrameHeight: Integer;
begin
  Caption := 'Annotation Toolbar';
  imgReadOnly.Visible := False;

  pnlButtons.Height := 51;
  pnlInfo.Height := 20;
  FrameHeight := 50;

  if tvHistory.Visible = False then
  begin
    Self.Height := pnlButtons.Height + (pnlInfo.Height div 2) + Splitter1.Height + sbStatus.Height + 40;
    tvHistory.Visible := False;
  end
  else
  begin
    Self.Height := pnlButtons.Height + 100 + Splitter1.Height + sbStatus.Height + FrameHeight;
    tvHistory.Visible := True;
  end;

  Self.Width  := tbEditAnnotMarks.Width * 10;
end;

Procedure TMagAnnot.SetCurrentPage(Const Value: IIGPage);
Begin
  FcurrentPage := Value;
End;

Function TMagAnnot.GetCurrentPage: IIGPage;
Begin
  Result := FcurrentPage;
End;

Function TMagAnnot.IsValidForEdit(CurPage: IIGPage): Boolean;
Begin
  Result := False;
  If ArtPage = Nil Then
  Begin
    FEditModeFalseReason := FEditModeFalseReason + #13 + #10 + 'ArtPage is nil';
    Exit;
  End;
  If CurPage = Nil Then
  Begin
    FEditModeFalseReason := FEditModeFalseReason + #13 + #10 + 'CurrentPage is nil';
    Exit;
  End;
  If Not CurPage.IsValid Then
  Begin
    FEditModeFalseReason := FEditModeFalseReason + #13 + #10 + 'CurPage.IsValid returns false';
  End;
  Result := True;
End;

Function TMagAnnot.SelectFile(Var Filename: String; Var PageNum, PageCount: Integer): Boolean;
Var
  dialogLoadOptions: IIGFileDlgPageLoadOptions;
  igFileDialog: IGFileDlg;
  IoLocation: IIGIOLocation;
Begin
  Result := False;
  Filename := Trim(Filename);
  If Filename <> '' Then
  Begin
    If Not FileExists(Filename) Then Filename := '';
  End
  Else
  Begin
    Filename := '';
  End;
  PageCount := -1;
  PageNum := -1;
  igFileDialog := IGDlgsCtl.CreateFileDlg;
  IoLocation := IGFormatsCtrl.CreateObject(IG_FORMATS_OBJ_IOFILE) As IIGIOLocation;
  Try
    Try
      dialogLoadOptions := IGDlgsCtl.CreateFileDlgOptions(IG_FILEDLGOPTIONS_PAGELOADOBJ) As IIGFileDlgPageLoadOptions;
      igFileDialog.ParentWindow := Application.Handle;
      If Filename <> '' Then
      Begin
        dialogLoadOptions.Filename := Filename;
      End
      Else
      Begin
        If Not (igFileDialog.Show(dialogLoadOptions)) Then Exit;
      End;
      IoLocation := Nil;
      FCurrentPageNumber := -1;
      totalLocationPageCount := 0;
      IoLocation := IGFormatsCtrl.CreateObject(IG_FORMATS_OBJ_IOFILE) As IIGIOLocation;
      (IoLocation As IGIOFile).Filename := dialogLoadOptions.Filename;
      Filename := dialogLoadOptions.Filename;
      If Filename <> '' Then
      Begin
        If FileExists(Filename) Then
        Begin
          PageNum := dialogLoadOptions.PageNum;
           //caption := dialogLoadOptions.Filename;
          PageCount := IGFormatsCtrl.GetPageCount(IoLocation, IG_FORMAT_UNKNOWN);
          Result := True;
        End;
      End;
    Except
      On EOleException Do CheckErrors;
    End;
  Finally
    igFileDialog := Nil;
    IoLocation := Nil;
  End;
End;

Function TMagAnnot.LoadFile(Filename: String): String;
Var
  CurrentPageNew: IIGPage;
  PageCount: Integer;
  PageNum: Integer;
Begin
  Result := '';
  If Not SelectFile(Filename, PageNum, PageCount) Then Exit;
  Result := Filename;
  currentPageNew := IGCoreCtl.CreatePage;
  IGFormatsCtrl.LoadPageFromFile(currentPageNew, Filename, PageNum);
  IGGUIDlgCtl.ShowColorMismatchDlg(currentPageNew);
  RemoveAllAnnotations;
  CurrentPageClear();
  CurrentPageNew.DuplicateTo(CurrentPage);
  CurrentPageNumber := PageNum;
  totalLocationPageCount := PageCount;
//  CreateArtPage(CurrentPage, CurrentPageDisp);   {/ P122 - JK 6/23/2011 - removed for testing /}
  IGPageViewCtl.UpdateView;
End;

Function TMagAnnot.LoadFile(): String;
Var
  Filename: String;
Begin
  Filename := '';
  Result := LoadFile(Filename);
End;

procedure TMagAnnot.mnuEditCopyAllClick(Sender: TObject);
begin
  Copy();
end;

procedure TMagAnnot.mnuEditCopySelectedClick(Sender: TObject);
begin
//  CopyFirstSelected();
  CopySelected;
end;

procedure TMagAnnot.mnuEditCutSelectedClick(Sender: TObject);
begin
  MarkTest := nil;
  CutSelected;
end;

procedure TMagAnnot.mnuEditDeleteAllClick(Sender: TObject);
Var
  Count: Integer;
  CurMark: IIGArtXMark;
  iter: Integer;
  MarkArray: IIGArtXMarkArray;
  buttonSelected : Integer;
  tooltips : string; //p122t7
Begin
  {/p122t7 dmmn 10/28 - add more proper messages /}
  if (ArtPageList[Page-1].ArtPage.MarkCount = 0) then
  begin
    MessageDlg('Current page has no annotation to delete.',mtConfirmation,[mbOK],0);
    Exit;
  end;
  //p122 dmmn 8/10 - show a warning before user delete annotation marks
  {/ P122 T15 - JK 8/9/2012 - CR 1193 - Changed focus to Cancel button /}
  buttonSelected := MessageDlg('Are you sure you want to delete all annotations?',
                               mtConfirmation,[mbYes,mbNo],0, mbNo);
  //quit if user changed mind and not want to delete
  if buttonSelected = mrNo then
    Exit;

  iter := 0;
  MarkArray := IGArtXCtl.CreateObject(IG_ARTX_OBJ_MARK_ARRAY) As IIGArtXMarkArray;
  If (IsValidEnv()) Then
  Begin
    Count := ArtPageList[Page-1].ArtPage.MarkCount;
    MarkArray.Resize(Count);

    CurMark := ArtPageList[Page-1].ArtPage.MarkFirst;
    While (Not (CurMark = Nil)) Do
    Begin
      if CanUserModifyMark(CurMark) then {Prevent a user from deleting some other user's mark unless they have the MagAnnotation key}
      begin
        MarkArray.Item[iter] := CurMark;
        iter := iter + 1;
        //p122t7 check the tooltips, if one of the marks is old then flag the session
        tooltips := CurMark.Tooltip;
        if (AnsiPos('*edited', tooltips) = 0) and
           (AnsiPos('YYYYMMDDHHMMSS', tooltips) = 0) and
           (AnsiPos('Temporary', tooltips) = 0)   // p122t15 dmmn - add this condition since we are allowing delete in radiology images now
           then
        begin
          FOldAnnotsDeleted := True;
          ArtPageList[Page-1].MarkDeleted := True;
        end;
      end;
      CurMark := ArtPageList[Page-1].ArtPage.Marknext(CurMark);
    End;

    if iter = 0 then
      //p122t14 - change message
      MagAppMsg('d','You are not authorized to delete saved annotations.'#13#10 +
                          'Please contact Chief HIM or Privacy Act Officer if you need to delete saved annotations.')
    else
    begin
      if iter < Count then
        MagAppMsg('d','Only unsaved annotations were deleted.' + #13#10 +
                             'You are not authorized to delete saved annotations.'#13#10 +
                             'Please contact Chief HIM or Privacy Act Officer if you need to delete saved annotations.');
      ArtPageList[Page-1].ArtPage.RemoveMarksArray(MarkArray);

      //p122t3 9/16 move the modified flag here instead of outside the loop to better catch the changes.
      // only change when there's something actually deleted.
      FAnnotsModified := True;
      IGPageViewCtl.UpdateView;
    end;
  End;
  UnselectAllMarks;  //p122t4

  RefreshAnnotInfoBar;
end;

procedure TMagAnnot.mnuEditDeleteSelectedClick(Sender: TObject);
begin
//  ClipboardAction(AnnotDeleteFirst);
  DeleteSelected;
end;

procedure TMagAnnot.mnuEditSelectAllClick(Sender: TObject);
begin
  SelectAll();
end;

procedure TMagAnnot.mnuViewHideAllClick(Sender: TObject);
begin
  HideAllAnnotations(False);
end;

procedure TMagAnnot.HideAllAnnotations(Initializing: Boolean);
var
  CurMark : IIGArtXMark;
  i: Integer;
begin
  {/p122t4 dmmn 9/30 - add a no mark message /}
  if (Not Initializing) then
  begin
    if (MarkCount = 0) or (MarkCount = HiddenCount) then  // no marks to hide
    begin
      MessageDlg('There are no visible annotations to hide',mtCustom, [mbOK], 0);
      Exit;
    end;
  end;

  for i := 0 to PageCount - 1 do
  begin
    CurMark := ArtPageList[i].ArtPage.MarkFirst;
    while CurMark <> nil do
    begin
      if CurMark.Visible then   // move in here since the tester want to only change if there's something being hidden
      begin
        {/p122t7 dmmn 10/28 - hiding/showing will not be considered a change in annot layer /}
        {/p122t3 dmmn 9/16 - move the check here instead outside the loop.
        this way the flag will only change when there's something hidden in current
        session/}
//        if (not Initializing) and (not FIsInHistoryView) then   //p122t2 dmmn 9/2
//          FAnnotsModified := True;

        CurMark.Visible := False;
      end;
      CurMark := ArtPageList[i].ArtPage.MarkNext(CurMark);
    end;

    //p122t4 dmmn 9/30 - unselect all marks
    UnSelectAllMarks;
  end;
  IGPageViewCtl.UpdateView;
  RefreshAnnotInfoBar;

  if RadPackage then
  begin
//    FAnnotsModified := False;   // nothing should change for rad package either
//    FIsRadVisible := True;
    FIsRadVisible := False; //p122t3dmmn 9/16 shouldnt this be false since we are hiding all?
  end;
end;

procedure TMagAnnot.mnuViewHideDateClick(Sender: TObject);
begin
  SetAnnotVisibilityByFieldValue(True,3);
end;

procedure TMagAnnot.mnuViewHideSelectedClick(Sender: TObject);
var
  CurMark : IIGArtXMark;
  i: Integer;
  hideCount : Integer;
begin
  hideCount := 0;
  for i := 0 to PageCount - 1 do
  begin
    CurMark := ArtPageList[i].ArtPage.MarkSelectedFirst;
    while CurMark <> nil do
    begin
      if CurMark.Visible then   // if the mark is visible so hide it and inc the count
      begin
        {/p122t7 dmmn 10/28 - hiding/showing will not be considered a change in annot layer /}
        {/p122t3 dmmn 9/16 - only update when there's something actually hidden/}
// T10       if Not FIsInHistoryView then         //p122t2 9/2
// T10         FAnnotsModified := True;
        inc(hideCount);
      end;
      CurMark.Visible := False;

      CurMark := ArtPageList[i].ArtPage.MarkSelectedNext(CurMark);
    end;

    ArtPageList[i].ArtPage.SelectMarks(False);    //unselect marks after hide
//    UnselectAllMarks(); //p122t4     //t122t6 take this out since this function only change the current page
  end;

  if hideCount = 0 then
    MessageDlg('There are no visible annotations to hide',mtCustom, [mbOK], 0);

  UnselectAllMarks(); //p122t5
  IGPageViewCtl.UpdateView;
  RefreshAnnotInfoBar;

end;

procedure TMagAnnot.mnuViewHideSpecialtyClick(Sender: TObject);
begin
  SetAnnotVisibilityByFieldValue(True,2);
end;

procedure TMagAnnot.mnuViewHideUserClick(Sender: TObject);
begin
  SetAnnotVisibilityByFieldValue(True,1);
end;

procedure TMagAnnot.mnuViewShowAllClick(Sender: TObject);
//var
//  CurMark : IIGArtXMark;
//  i : Integer;
begin
 (* {/p122t4 dmmn 9/30 - add a no mark message /}
  if (Not Initializing) then
  begin
    if (MarkCount = 0) or (HiddenCount = 0) then  // no marks to show
    begin
      MessageDlg('There are no hidden annotations to show',mtCustom, [mbOK], 0);
      Exit;
    end;
  end;

  for i := 0 to PageCount - 1 do
  begin
    CurMark := ArtPageList[i].ArtPage.MarkFirst;  //FArtPages[I].MarkFirst;
    while CurMark <> nil do
    begin
      if Not CurMark.Visible then
      begin

      end;
      CurMark.Visible := True;

      if Not FIsInHistoryView then          //p122t2 9/2
        FAnnotsModified := True;

      CurMark := ArtPageList[i].ArtPage.MarkNext(CurMark);  //FArtPages[I].MarkNext(CurMark);
    end;
  end;
  IGPageViewCtl.UpdateView;
  RefreshAnnotInfoBar;   *)

  ShowAllAnnotations(False);  //p122t4 dmmn 9/30 - remove duplications
end;

procedure TMagAnnot.mnuViewShowDateClick(Sender: TObject);
begin
  SetAnnotVisibilityByFieldValue(False,3);
end;

procedure TMagAnnot.mnuViewShowSpecialtyClick(Sender: TObject);
begin
  SetAnnotVisibilityByFieldValue(False,2);
end;

procedure TMagAnnot.mnuViewShowUserClick(Sender: TObject);
begin
  SetAnnotVisibilityByFieldValue(False,1);
end;

procedure TMagAnnot.SetAnnotVisibilityByFieldValue(hide: Boolean; fieldNumber: Integer);
{ Core method to view and hide stuff }
var
  lstBox : TMagAnnotChoicesBox;
  choices : string;
  i: Integer;
  CurMark : IIGArtXMark;
  MarkValue : string;

  function getLongestEntryWidth(entries : string) : Integer;
  var
    I : Integer;
    bmp : TBitmap;
  begin
    {/p122t6 dmmn - get the width of the longest entries /}
    bmp := TBitmap.Create;
    Result := 200;
    try
      try
        bmp.Canvas.Font.Assign(self.Font);
        for I := 1 to Maglength(entries, '|') - 1 do
        begin
          if (bmp.Canvas.TextWidth(MagPiece(entries,'|',I)) > Result)  then
            Result := bmp.Canvas.TextWidth(MagPiece(entries,'|',I));
        end;
        Result := Result + 10;
      except
        On E : Exception do
        begin
          magAppMsg('s', 'TMagAnnot - getLongestEntryWidth ' + E.Message);
          magAppMsg('s', 'entries: ' + entries);
        end;
      end;
    finally
      bmp.Free;
    end;
  end;
begin
  // get the choices
  choices := GetViewHideChoices(hide, fieldNumber);
  if choices = '' then
  begin
    if hide then
      MessageDlg('There are no visible annotations to hide', mtCustom, [mbOK], 0)
    else
      MessageDlg('There are no hidden annotations to show', mtCustom, [mbOK], 0);
    Exit;
  end;

  // generate options list
  lstBox := TmagAnnotChoicesBox.CreateNew(nil,0);
  lstBox.InitForm;
  lstBox.Width := getLongestEntryWidth(choices);  //p122t6 - show the full length of longest entries
  lstBox.btnOk.Left := lstBox.btnOk.Left + ((lstBox.Width-200) div 2);
  lstBox.btnCancel.Left := lstBox.btnCancel.Left + ((lstBox.Width-200) div 2);

  lstBox.InitItems(choices);
  //p122 dmmn 7/28 - position the box closer to the form
  lstBox.Left := ToolbarCoords.X + 10;
  lstBox.Top := ToolbarCoords.Y + 10;

  lstBox.ShowModal;

  // if the user has selected a choice, proceed to change the visibility of
  // the marks if they match the choice
  if lstBox.ModalResult = mrOK then
  begin
    for i := 0 to PageCount - 1 do
    begin
      CurMark := ArtPageList[i].ArtPage.MarkFirst;  //FArtPages[I].MarkFirst;
      while CurMark <> nil do
      begin
        MarkValue := GetViewHideFieldValue(fieldNumber,CurMark.Tooltip);
        //p122 dmmn 7/28/11 - change the format of the value for time
        if fieldNumber = 3 then
        begin
          if MarkValue = 'YYYYMMDDHHMMSS' then
            MarkValue := 'Current Session'
          else
            MarkValue := FormatDatePiece(MarkValue);
        end;

        if MarkValue = SelectedValue then
          CurMark.Visible := Not hide;
        {/p122t7 dmmn 10/28 - hiding/showing will not be considered a change in annot layer /}

        //p122t3 dmmn 9/16 - again, moved this to a more proper location
//T10        if Not FIsInHistoryView then  //p122t2 9/2
//T10          FAnnotsModified := True;  //p122 dmmn 8/17/11 - move this to here to avoid the save prompt when exit after user canceled the choice

        CurMark := ArtPageList[i].ArtPage.MarkNext(CurMark);  //FArtPages[I].MarkNext(CurMark);
      end;

      UnselectAllMarks; //p122t4 dmmn 9/30
    end;
    IGPageViewCtl.UpdateView;
  end;

  lstBox.Destroy;
  RefreshAnnotInfoBar;

end;

function TMagAnnot.CanUserModifyMark(IGMark: IIGArtXMark): boolean;
var
  markUser : string;
  CurMark: IIGArtXMark;
  DUZ: String;
  Site: String;
  Date: string; //p122t14 check for date
begin
  try
    Result := False;


    {For VistARad annotations, always keep the ruler and protractor non-read only}
    if RADPackage or IsDODImage then        //p122t15 dod
    begin
      {/p122 dmmn 8/19 - check the tooltips of the marks first. if there's none or
      says approximate then user cannot modify, even with manager key /}
      if (IGMark.Tooltip = '') or (IGMark.Tooltip = 'Approximate') then
      begin
        Result := False;
        Exit;
      end;

      if (IGMark.type_ = IG_ARTX_MARK_RULER) or (IGMark.type_ = IG_ARTX_MARK_PROTRACTOR) then
      begin
        if (IGMark.type_ = IG_ARTX_MARK_RULER) then
          IGMark.Tooltip := 'Temporary Ruler Annotation';
        if (IGMark.type_ = IG_ARTX_MARK_PROTRACTOR) then
          IGMark.Tooltip := 'Temporary Protractor Annotation';

        Result := True;
      end
      else
        Result := False;
      Exit;
    end;

    {if not in the current session then disable mouse moves}
    //p122t5 dmmn - put this here to avoid bypassed by master key
    if FIsInHistoryView then      //9/16
    begin
      Result := False;
      Exit;
    end;

    {/ P122 JK 10/3/2011 /}
    if FHasMasterKey then
    begin
      Result := True;
      Exit;
    end;



    //check the mark to see ownership information

    if IGMark <> nil then
    begin
      //check for ownership of the annotation if made by different user or site
      //then they cannot edit the mark

      DUZ  := GetViewHideFieldValue(4, IGMark.Tooltip);
      Site := GetViewHideFieldValue(5, IGMark.Tooltip);
      if (FDUZ <> DUZ) or (FSiteNum <> Site) then  {JK/DMMN - 9/8/2011}
      begin
        Result := False;
      end
      else
      begin
        {p122t14 dmmn 4/26/2012 - as requested by HIMS and CLIN3, user should
        not be able to delete or edit anyone even self annotation if it's been
        saved. Can only modify/delete unsaved annotations.}
        Date := GetViewHideFieldValue(3, IGMark.Tooltip);
        if (FHasAnnotatePermission) and (Date = 'YYYYMMDDHHMMSS') then  {/ P122 JK 10/3/2011 /}
        begin
          Result := True;
        end
        else
        begin
          Result := False;
        end;
      end;
    end;

  finally
    CurMark := nil;
    RefreshAnnotInfoBar;
  end;
end;

function TMagAnnot.CanUserModifyPoint(IGPoint: IIGPoint): boolean;
{p122t4 dmmn 9/30 }
var
  CurMark : IIGArtXMark;
  inMark : boolean;
  imgPoint : IIGPoint;
const
  SAFETY_ZONE = 5;

  function PointInMark(IGPoint: IIGPoint; IGMark : IIGArtXMark) : Boolean;
  var
    I: Integer;
  begin
    Result := false;
    if IGMark = nil then
      Exit;

    // check to see if a point base mark contain the point in question
    // point base marks in this patch are : line, ruler, protractor, freeline, polyline
    case IGMark.type_ of
      IG_ARTX_MARK_LINE  :
      begin
        // is the end point or start point
        if (Abs((IGMark as IIGArtXLine).GetEndPoint.XPos - IGPoint.XPos) <= SAFETY_ZONE) and
           (Abs((IGMark as IIGArtXLine).GetEndPoint.YPos - IGPoint.YPos) <= SAFETY_ZONE) then
          Result := True
        else if (Abs((IGMark as IIGArtXLine).GetStartPoint.XPos - IGPoint.XPos) <= SAFETY_ZONE) and
                (Abs((IGMark as IIGArtXLine).GetStartPoint.YPos - IGPoint.YPos) <= SAFETY_ZONE) then
          Result := True
        else
          Result := False;
      end;
      IG_ARTX_MARK_RULER:
      begin
        // is the end point or start point
        if (Abs((IGMark as IIGArtXRuler).GetEndPoint.XPos - IGPoint.XPos) <= SAFETY_ZONE) and
           (Abs((IGMark as IIGArtXRuler).GetEndPoint.YPos - IGPoint.YPos) <= SAFETY_ZONE) then
          Result := True
        else if (Abs((IGMark as IIGArtXRuler).GetStartPoint.XPos - IGPoint.XPos) <= SAFETY_ZONE) and
                (Abs((IGMark as IIGArtXRuler).GetStartPoint.YPos - IGPoint.YPos) <= SAFETY_ZONE) then
          Result := True
        else
          Result := False;
      end;
      IG_ARTX_MARK_PROTRACTOR:
      begin
        // is the end point or start point or head point
        if (Abs((IGMark as IIGArtXProtractor).GetEndPoint.XPos - IGPoint.XPos) <= SAFETY_ZONE) and
           (Abs((IGMark as IIGArtXProtractor).GetEndPoint.YPos - IGPoint.YPos) <= SAFETY_ZONE) then
          Result := True
        else if (Abs((IGMark as IIGArtXProtractor).GetStartPoint.XPos - IGPoint.XPos) <= SAFETY_ZONE) and
                (Abs((IGMark as IIGArtXProtractor).GetStartPoint.YPos - IGPoint.YPos) <= SAFETY_ZONE) then
          Result := True
        else if (Abs((IGMark as IIGArtXProtractor).GetHeadPoint.XPos - IGPoint.XPos) <= SAFETY_ZONE) and
                (Abs((IGMark as IIGArtXProtractor).GetHeadPoint.YPos - IGPoint.YPos) <= SAFETY_ZONE) then
          Result := True
        else
          Result := False;
      end;
      IG_ARTX_MARK_FREEHAND_LINE:
      begin
        // is one of the point in the array
        for I := 0 to (IGMark as IIGArtXFreeLine).NumberOfPoints - 1 do
        begin
          if (Abs((IGMark as IIGArtXFreeLine).GetPoint(I).XPos - IGPoint.XPos) <= SAFETY_ZONE) and
             (Abs((IGMark as IIGArtXFreeLine).GetPoint(I).YPos - IGPoint.YPos) <= SAFETY_ZONE) then
          begin
            Result := True;
            Exit;
          end;
        end;
      end;
      IG_ARTX_MARK_POLYLINE:
      begin
        // is one of the point in the array
        for I := 0 to (IGMark as IIGArtXPolyline).NumberOfPoints - 1 do
        begin
          if (Abs((IGMark as IIGArtXPolyline).GetPoint(I).XPos - IGPoint.XPos) <= SAFETY_ZONE) and
             (Abs((IGMark as IIGArtXPolyline).GetPoint(I).YPos - IGPoint.YPos) <= SAFETY_ZONE) then
          begin
            Result := True;
            Exit;
          end;
        end;
      end;
    end;
  end;
begin
  Result := True;

  // no mark
  if MarkCount = 0 then
    Exit;

  // no mark selected
  CurMark := ArtPageList[Page-1].ArtPage.MarkSelectedFirst;
  if CurMark = nil then
    Exit;

  // convert the point to image coord
  // check to see if the click position is inside the image
  imgPoint := IGCoreCtl.CreateObject(IG_OBJ_POINT) As IIGPoint;
  imgPoint.XPos := IGPoint.XPos;
  imgPoint.YPos := IGPoint.YPos;
  IGPageViewCtl.PageDisplay.ConvertPointCoordinates(IGPageViewCtl.hWnd, 0, imgPoint, IG_DSPL_CONV_DEVICE_TO_IMAGE);

  // go through all selected marks and check
  while (CurMark <> nil) do
  begin
    inMark := PointInMark(imgPoint, CurMark);
    // if the point belongs to a mark then return false and exit else proceed til the end
    // of the mark selected array
    if inMark then
    begin
      if Not CanUserModifyMark(CurMark) then
        Result := false;
      Exit;
    end;
    CurMark := ArtPageList[Page-1].ArtPage.MarkSelectedNext(CurMark);
  end;

  
  //p122t5 dmmn 10/7 - in history view
//  if FIsInHistoryView then
//  begin
//    result := false;
//    Exit;
//  end;
end;

//p129t19 dmmn - merge capture only piece from 122 capture annotation component
//               to update annotations to resulted marks
procedure TMagAnnot.CapConvertAllAnnotationsToResulted(resulted : boolean = false);
var
  CurMark : IIGArtXMark;
  IGBorder : IIGArtXBorder;
  IGFont : IIGArtXFont;
  I : Integer;
  fontStyle : enumIGArtXFontStyle;
  borderStyle : enumIGArtXPenStyle;
begin
  {/p122 dmmn 8/11 - update the status of the image. If consult is resulted then
  annotations will have a different look than normal annotations. If the user hasn't
  loaded image yet then just update the status, once the annotation button is click
  annotation component will be created with appropriate status. If the user has
  loaded the image into the annotation panel, check to see if there are any annotations
  and update the looks base on the status. /}
  try
    // update status
    ConsultResulted := '0';
    if resulted then
      ConsultResulted := '1';

    {p122 dmmn 8/10 - go through all the annotation marks and change the style
    to match the status of the consult /}
    //XMLCtl.UpdateCapConsultStatus(resulted);
    if resulted then
    begin
      fontStyle := IG_ARTX_FONT_UNDERLINE;
      borderStyle := IG_ARTX_PEN_DASH;
    end
    else
    begin
      fontStyle := IG_ARTX_FONT_UNDERLINE;
      borderStyle := IG_ARTX_PEN_SOLID;
    end;

    // go through all the pages and update
    for I := 0 to PageCount - 1 do
    begin
      CurMark := ArtPageList[I].ArtPage.MarkFirst;
      while CurMark <> nil do
      begin
        case CurMark.type_ of
          IG_ARTX_MARK_LINE  :
          begin
            IGBorder := (CurMark as IIGArtXLine).GetBorder;
            IGBorder.Style := borderStyle;
            (CurMark as IIGArtXLine).SetBorder(IGBorder);
          end;
          IG_ARTX_MARK_RECTANGLE :
          begin
            IGBorder := (CurMark as IIGArtXRectangle).GetBorder;
            IGBorder.Style := borderStyle;
            (CurMark as IIGArtXRectangle).SetBorder(IGBorder);
          end;
          IG_ARTX_MARK_ELLIPSE :
          begin
            IGBorder := (CurMark as IIGArtXEllipse).GetBorder;
            IGBorder.Style := borderStyle;
            (CurMark as IIGArtXEllipse).SetBorder(IGBorder);
          end;
          IG_ARTX_MARK_FREEHAND_LINE:
          begin
            IGBorder := (CurMark as IIGArtXFreeline).GetBorder;
            IGBorder.Style := borderStyle;
            (CurMark as IIGArtXFreeline).SetBorder(IGBorder);
          end;
          IG_ARTX_MARK_TEXT:
          begin
            IGFont := (CurMark as IIGArtXText).GetFont;
            if Resulted then
            begin   //p122 dmmn 8/25 - prevent delphi from jumping to wrong case
              if IGFont.Style <= 3 then
                IGFont.Style := IGFont.Style + fontstyle;
            end
            else
            begin
              if IGFont.Style > 3 then
                IGFont.Style := IGFont.style - fontstyle;
            end;
            (CurMark as IIGArtXText).SetFont(IGFont);
          end;
          IG_ARTX_MARK_RULER:
          begin
            IGBorder := (CurMark as IIGArtXRuler).GetBorder;
            IGBorder.Style := borderStyle;
            (CurMark as IIGArtXRuler).SetBorder(IGBorder);

            IGFont := (CurMark as IIGArtXRuler).GetFont;
            if Resulted then
            begin   //p122 dmmn 8/25 - prevent delphi from jumping to wrong case
              if IGFont.Style <= 3 then
                IGFont.Style := IGFont.Style + fontstyle;
            end
            else
            begin
              if IGFont.Style > 3 then
                IGFont.Style := IGFont.style - fontstyle;
            end;
            (CurMark as IIGArtXRuler).SetFont(IGFont);
          end;
          IG_ARTX_MARK_PROTRACTOR:
          begin
            IGBorder := (CurMark as IIGArtXProtractor).GetBorder;
            IGBorder.Style := borderStyle;
            (CurMark as IIGArtXProtractor).SetBorder(IGBorder);

            IGFont := (CurMark as IIGArtXProtractor).GetFont;
            if Resulted then
            begin   //p122 dmmn 8/25 - prevent delphi from jumping to wrong case
              if IGFont.Style <= 3 then
                IGFont.Style := IGFont.Style + fontstyle;
            end
            else
            begin
              if IGFont.Style > 3 then
                IGFont.Style := IGFont.style - fontstyle;
            end;
            (CurMark as IIGArtXProtractor).SetFont(IGFont);
          end;
        end;
        CurMark := ArtPageList[I].ArtPage.MarkNext(CurMark);
      end;
    end;
    IGPageViewCtl.UpdateView;
  except
    on E:Exception do
    begin
      magAppMsg('s', 'TMagAnnot.UpdateCapConsultStatus error = ' + E.Message);
      magAppMsg('s', E.ClassName + 'error raised, with message: '+ E.Message);
    end;
  end;
end;

function TMagAnnot.CanUserModifyAllMarks(IGMarks: IIGArtXMarkArray): boolean;
var
  markUser : string;
  i: Integer;
  DUZ, Site: String;
begin
  Result := False;
  if FIsInHistoryView then // cannot modify in history view
    Exit;

  if IGMarks <> nil then
  begin
//    if GSess.HasLocalAnnotateMasterKey then
    {/ P122 JK 10/3/2011 /}
    if FHasMasterKey then
    begin
      Result := True;
    end
    else
    begin
      for i := 0 to IGMarks.Size - 1 do
      begin
//        markUser := GetViewHideFieldValue(1, IGMarks.Item[i].Tooltip);
        DUZ  := GetViewHideFieldValue(4, IGMarks.Item[i].Tooltip);
        Site := GetViewHideFieldValue(5, IGMarks.Item[i].Tooltip);
//        if MarkUser <> Username then
//        if (GSess.UserDUZ <> DUZ) or (GSess.WrksInstStationNumber <> Site) then  {JK/DMMN - 9/8/2011}
          if (FDUZ <> DUZ) or (FSiteNum <> Site) then  {JK/DMMN - 9/8/2011}
        begin
          Result := False;
          Break;
        end
        else
        begin
//          if GSess.HasLocalAnnotatePermission then
          if FHasAnnotatePermission then  {/ P122 JK 10/3/2011 /}          
            Result := True
          else
            Result := False;
        end;
      end;
    end;
  end;
end;


function TMagAnnot.GetViewHideFieldValue(fieldNumber : integer; tooltips: string): string;
{ Get the value of the field in a delimited string
  FieldNumber : Integer : 1=Username, 2=Service, 3=Date, 4=DUZ, 5=StationNumber }
Var
  Lst: TStringList;
Begin
  Result := '';
  If tooltips = '' Then Exit;
  {/p122t2 dmmn 8/31 - expanding the field /}
  if (fieldNumber < 1) or (fieldNumber > 6) then Exit;       // invalid bounds

  // parse the tooltip
  Lst := Tstringlist.Create;
  Try
    lst.StrictDelimiter := True;
    lst.Delimiter := '|';
    lst.DelimitedText := tooltips;
    if fieldNumber > lst.Count then
    begin
      Result := '';
    end
    else
    begin
      if Lst.Count > 1 then    {/ JK for temporary ruler which will only be 1/}
        Result := Lst[fieldNumber - 1];
    end;
  Finally
    FreeAndNil(Lst);
  End;
End;

procedure TMagAnnot.ShowAllAnnotations(Initializing: Boolean);
var
  CurMark : IIGArtXMark;
  i : Integer;
begin
//  p122 dmmn 7/27/11 - show all annotations (even hidden) when user first load
//  image
//  ShowAllMarks;
//  RefreshAnnotInfoBar;
//  if not Initializing then
//    FAnnotsModified := True;
//
//  if RadPackage then
//    FIsRadVisible := True;
  //p122t4 dmmn - look like  we have a duplicate functions here
  {/p122t4 dmmn 9/30 - add a no mark message /}

  if (Not Initializing) then
  begin
    if (MarkCount = 0) or (HiddenCount = 0) then  // no marks to show
    begin
      MessageDlg('There are no hidden annotations to show',mtCustom, [mbOK], 0);
      Exit;
    end;
  end;

  for i := 0 to PageCount - 1 do
  begin
    CurMark := ArtPageList[i].ArtPage.MarkFirst;  //FArtPages[I].MarkFirst;
    while CurMark <> nil do
    begin
      if Not CurMark.Visible then
      begin
        {/p122t7 dmmn 10/28 - hiding/showing will not be considered a change in annot layer /}
//        if (not Initializing) and (not FIsInHistoryView) then          //p122t2 9/2
//          FAnnotsModified := True;
        CurMark.Visible := True;
      end;
      CurMark := ArtPageList[i].ArtPage.MarkNext(CurMark);  //FArtPages[I].MarkNext(CurMark);
    end;
    
    UnselectAllMarks; //p122t4
  end;
  IGPageViewCtl.UpdateView;
  RefreshAnnotInfoBar;

  if RadPackage then
  begin
    FIsRadVisible := True;
// t10    FAnnotsModified := False;
  end;
end;

//procedure TMagAnnot.ShowAllMarks;
//var
//  CurMark : IIGArtXMark;
//  I : Integer;
//begin
//  for I := 0 to PageCount - 1 do
//  begin
//    CurMark := ArtPageList[i].ArtPage.MarkFirst;
//    while CurMark <> nil do
//    begin
//      CurMark.Visible := True;
//      CurMark := ArtPageList[i].ArtPage.MarkNext(CurMark);
//    end;
//  end;
//  IGPageViewCtl.UpdateView;
//end;

function TMagAnnot.GetViewHideChoices(hide: Boolean; fieldNumber: Integer): string;
{ Generate a list of choice for user to choose
  FieldNumber : Integer : 1=Username, 2=Service, 3=Date, 4=DUZ, 5=StationNumber }
var
  lstChoice : TStringList;
  i: Integer;
  CurMark : IIGArtXMark;

  choiceValue : string;
begin
  lstChoice := TStringList.Create;
  try
    lstChoice.Sorted := True;
    lstChoice.Duplicates := dupIgnore;

    // Go through all the art pages in the image and get
    // all the possible choices from all the marks
    for i := 0 to PageCount - 1 do
    begin
      CurMark := ArtPageList[i].ArtPage.MarkFirst;  //FArtPages[I].MarkFirst;
      while CurMark <> nil do
      begin
        if CurMark.Visible = hide then
        begin
          choiceValue := GetViewHideFieldValue(fieldNumber, CurMark.Tooltip);
          lstChoice.Add(choiceValue);
        end;

        CurMark := ArtPageList[i].ArtPage.MarkNext(CurMark);  //FArtPages[I].MarkNext(CurMark);
      end;
    end;

    Result := '';
    for i := 0 to lstChoice.Count - 1 do
    begin
      //p122 dmmn 7/28/11 - format the date time choices
      if fieldNumber = 3 then
      begin
        if lstChoice[i] = 'YYYYMMDDHHMMSS' then
          Result := Result + 'Current Session' + '|'
        else
          Result := Result + FormatDatePiece(lstChoice[i]) + '|'
      end
      else
        Result := Result + lstChoice[i] + '|';
    end;

  finally
    lstChoice.Free;
  end;
end;

Function TMagAnnot.GetEditMode: Boolean;
Begin
  FEditModeFalseReason := '';
  If IGArtXGUICtl = Nil Then
  Begin
    FEditMode := False;
    FEditModeFalseReason := FEditModeFalseReason + #13 + #10 + 'IGArtXGUICtl is nil';
  End
  Else
  Begin
    If IsValidForEdit(CurrentPage) Then
    Begin
      If FEditMode Then
      Begin
        If FToolbarIsShowing Then
        Begin
          //The way it should be
        End
        Else
        Begin
//          Self.Show();  {JK 8/4/2011 - removed}
        End;
      End
      Else
      Begin
        If FToolbarIsShowing Then
        Begin
          //Self.Close();
        End
        Else
        Begin
          //The way it should be
//T10          Self.Show();  {/ P122 - JK 5/4/2011 /}
        End;
      End;
    End
    Else
    Begin
      FEditModeFalseReason := FEditModeFalseReason + #13 + #10 + 'IsValidForEdit=False';
      If FToolbarIsShowing Then
      Begin
        FEditMode := False;
        //Self.Close();
      End
      Else
      Begin
        //The way it should be
      End;
    End;
  End;
  Result := FEditMode;
  If FEditMode Then
  Begin
    If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then
    Begin
      IGArtXGUICtl.Mode := IG_ARTX_GUI_MODE_EDIT;
    End;
  End
  Else
  Begin
    If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_VIEW Then
    Begin
      IGArtXGUICtl.Mode := IG_ARTX_GUI_MODE_VIEW;
      imgReadOnly.Visible := True;
    End;
  End;
  If FEditModeFalseReasonShow Then
  Begin
    If Not FEditMode Then Showmessage(FEditModeFalseReason);
  End;
  RefreshAnnotInfoBar;
End;

Procedure TMagAnnot.SetEditMode(Value: Boolean);
Begin
  If Value Then
  Begin
    If Not FUserCanEdit Then
    Begin
      Value := False;
    End;
  End;
  If IGArtXGUICtl = Nil Then
  Begin
    FEditMode := False;
    actEditEditMode.Checked := FEditMode;
    UpdateButtonEnabling();
    Exit;
  End;
  If FEditMode <> Value Then
  Begin
    FEditMode := Value;
  End;
  If FEditMode Then
  Begin
    If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then
    Begin
      IGArtXGUICtl.Mode := IG_ARTX_GUI_MODE_EDIT;
      imgReadOnly.Visible := False;
    End;
  End
  Else
  Begin
    If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_VIEW Then
    Begin
      IGArtXGUICtl.Mode := IG_ARTX_GUI_MODE_VIEW;
      imgReadOnly.Visible := True;
    End;
  End;
  actEditEditMode.Checked := FEditMode;
  UpdateButtonEnabling();
End;

Procedure TMagAnnot.SetMenus;
Var
  boEnable: Boolean;
Begin
  Exit;
  If (Not (CurrentPage = Nil)) Then
    boEnable := CurrentPage.IsValid
  Else
    boEnable := False;

//  mnuFileSave.Enabled := boEnable;
//  MnuView.Enabled := boEnable;
//  mnuEdit.Enabled := boEnable;
//  mnuFileExportAnnotations.Enabled := boEnable;
//  mnuFileImportAnnotations.Enabled := boEnable;
//  mnuAnnotation.Enabled := boEnable;
End;

Procedure TMagAnnot.SetUserCanEdit(Const Value: Boolean);
Begin
  FUserCanEdit := Value;
  SetEditMode(FUserCanEdit);
End;

Function TMagAnnot.GetUserCanEdit: Boolean;
Begin
  Result := FUserCanEdit;
End;

Procedure TMagAnnot.actEditUserCanEditExecute(Sender: Tobject);
Begin
  UserCanEdit := Not UserCanEdit;
  actEditUserCanEdit.Checked := UserCanEdit;
End;

procedure TMagAnnot.UpdateMarksWithTimeSaved(datetime: string);
var
  CurMark : IIGArtXMark;
  i: Integer;
  before : string;
begin
  for i := 0 to PageCount - 1 do
  begin
    CurMark := ArtPageList[i].ArtPage.MarkFirst;
    while CurMark <> nil do
    begin
      before := CurMark.Tooltip;
      CurMark.Tooltip := StringReplace(before, 'YYYYMMDDHHMMSS', datetime,[]);
      CurMark := ArtPageList[i].ArtPage.MarkNext(CurMark);
    end;
  end;
end;

procedure TMagAnnot.UpdateEditedMarksWithNewOwnership;
var
  CurMark : IIGArtXMark;
  i: integer;
  before : string;
begin
  {/p122t2 dmmn 8/31 - update all annotation that are marked |*edited*| to new ownership /}
  for i := 0 to PageCount - 1 do
  begin
    CurMark := ArtPageList[i].ArtPage.MarkFirst;
    while CurMark <> nil do
    begin
      before := CurMark.Tooltip;
      if AnsiContainsStr(before,'|*edited*|')  then
        SetAnnotationOwnership(CurMark);
      CurMark := ArtPageList[i].ArtPage.MarkNext(CurMark);
    end;
  end;
end;

function TMagAnnot.GetHiddenCount: integer;
var
  i: Integer;
  CurMark : IIGArtXMark;
begin
  //p122 dmmn 7/26/11 - show hidden count for all pages
  Result := 0;
  try
    for I := 0 to PageCount - 1 do
    begin
      CurMark := ArtPageList[i].ArtPage.MarkFirst;
      while CurMark <> nil do
      begin
        if Not CurMark.Visible  then
          Inc(Result);
        CurMark := ArtPageList[i].ArtPage.MarkNext(CurMark);
      end;
    end;

    //p122t3 dmmn 9/22
    if RADPackage then
    begin
      if (ImageIEN = RadInfo.iIEN) then  // same image
      begin
        if Result > 0 then
          Result := (Result - RadInfo.radIGmapped) + RadInfo.radAnnotCount;
      end;
    end;
  except
    on E:Exception do
      magAppMsg('s', 'TMagAnnot.GetHiddenCount error = ' + E.Message);
  end;

end;

procedure TMagAnnot.CutSelected;
{ Cut execution for all selected marks}
var
  CurMark : IIGArtXMark;
  MarkArray : IIGArtXMarkArray;
  Count, CantModifyCount: Integer;
begin
  if ArtPageList[Page-1].ArtPage.MarkCount = 0 then
    Exit;

  Count := 0;
  CantModifyCount := 0;

  MarkArray := IGArtXCtl.CreateObject(IG_ARTX_OBJ_MARK_ARRAY) as IIGArtXMarkArray;

  // iterate through the marks and add to the marks array
  CurMark := ArtPageList[Page-1].ArtPage.MarkSelectedFirst;
  While (Not (CurMark = Nil)) Do
  Begin
    if CanUserModifyMark(CurMark) then
    begin
      MarkArray.Resize(Count+1);
      MarkArray.Item[Count] := CurMark;
//      CurMark := ArtPageList[Page-1].ArtPage.MarkSelectedNext(CurMark); //p122 dmmn 8/1 - moved down to fix infinite loop when users dont have right to edit marks
      Count := count + 1;
    end
    else
      inc(CantModifyCount);
    CurMark := ArtPageList[Page-1].ArtPage.MarkSelectedNext(CurMark);
  End;

  ArtPageList[Page-1].ArtPage.CutMarksArray(MarkArray);

  IGPageViewCtl.UpdateView;
  RefreshAnnotInfoBar;
  FAnnotsModified := True;
  if CantModifyCount > 0 then
    Showmessage('Only your annotations were cut. You do not have permission to cut annotations made by others');
end;

procedure TMagAnnot.CopySelected;
{/p122 dmmn 7/28 - copy selected marks /}
var
  CurMark : IIGArtXMark;
  MarkArray : IIGArtXMarkArray;
  Count : Integer;
  CantModifyCount : integer;
begin
  if ArtPageList[Page-1].ArtPage.MarkCount = 0 then
    Exit;

  Count := 0;
  CantModifyCount := 0;

  MarkArray := IGArtXCtl.CreateObject(IG_ARTX_OBJ_MARK_ARRAY) as IIGArtXMarkArray;

  // iterate through the marks and add to the marks array
  CurMark := ArtPageList[Page-1].ArtPage.MarkSelectedFirst;
  While (Not (CurMark = Nil)) Do
  Begin
    if CanUserModifyMark(CurMark) then
    begin
      MarkArray.Resize(Count+1);
      MarkArray.Item[Count] := CurMark;
//      CurMark := ArtPageList[Page-1].ArtPage.MarkSelectedNext(CurMark); //p122 dmmn 8/1 - moved down to fix infinite loop when users dont have right to edit marks
      Count := count + 1;
    end
    else
      inc(CantModifyCount);
    CurMark := ArtPageList[Page-1].ArtPage.MarkSelectedNext(CurMark);
  End;

  ArtPageList[Page-1].ArtPage.CopyMarksArray(MarkArray);

  if CantModifyCount > 0 then
    Showmessage('Only your annotations were copied. You do not have permission to copied annotations made by others');
end;

procedure TMagAnnot.DeleteSelected;
{/p122 dmmn 7/28 - delete selected marks /}
var
  CurMark : IIGArtXMark;
  MarkArray : IIGArtXMarkArray;
  Count : Integer;
  CantModifyCount : integer;
  buttonSelected : Integer;
  tooltip : string;
begin
  {/p122t7 dmmn 10/28 - add more proper messages /}
  if (ArtPageList[Page-1].ArtPage.MarkCount = 0) then
  begin
    MessageDlg('Current page has no annotation to delete.',mtConfirmation,[mbOK],0);
    Exit;
  end;

  if (ArtPageList[Page-1].ArtPage.MarkSelectedFirst = nil) then
  begin
    MessageDlg('Nothing is selected.',mtConfirmation,[mbOK],0);
    Exit;
  end;
  //p122 dmmn 8/10 - show a warning before user delete annotation marks
  {/ P122 T15 - JK 8/9/2012 - CR 1193 - Changed focus to Cancel button /}
  buttonSelected := MessageDlg('Are you sure you want to delete the selected annotation(s)?',
                               mtConfirmation,[mbYes,mbNo],0, mbNo);
  //quit if user changed mind and not want to delete
  if buttonSelected = mrNo then
    Exit;

  if ArtPageList[Page-1].ArtPage.MarkCount = 0 then
    Exit;

  Count := 0;
  CantModifyCount := 0;
  MarkArray := IGArtXCtl.CreateObject(IG_ARTX_OBJ_MARK_ARRAY) as IIGArtXMarkArray;

  // iterate through the marks and add to the marks array
  CurMark := ArtPageList[Page-1].ArtPage.MarkSelectedFirst;
  While (Not (CurMark = Nil)) Do
  Begin
    if CanUserModifyMark(CurMark) then
    begin
      MarkArray.Resize(Count+1);
      MarkArray.Item[Count] := CurMark;
//      CurMark := ArtPageList[Page-1].ArtPage.MarkSelectedNext(CurMark); //p122 dmmn 8/1 - moved down to fix infinite loop when users dont have right to edit marks
      Count := count + 1;
      //p122t7 check the tooltips, if one of the marks is old then flag the session
      tooltip := CurMark.Tooltip;
      if (AnsiPos('*edited', tooltip) = 0) and
        (AnsiPos('YYYYMMDDHHMMSS', tooltip) = 0) and
        (AnsiPos('Temporary', tooltip) = 0) // p122t15 dmmn - update since we are allowing deletion of temp annotation in rad viewer
        then
      begin
        FOldAnnotsDeleted := True;
        ArtPageList[Page-1].MarkDeleted := True;
      end;
    end
    else
      inc(CantModifyCount);
    CurMark := ArtPageList[Page-1].ArtPage.MarkSelectedNext(CurMark);
  End;

  if Count = 0 then
    //p122t14 - change message
     magAppMsg('d','You are not authorized to delete saved annotations.'#13#10 +
                          'Please contact Chief HIM or Privacy Act Officer if you need to delete saved annotations.')
  else
  begin
    FAnnotsModified := True;
    ArtPageList[Page-1].ArtPage.RemoveMarksArray(MarkArray);
    IGPageViewCtl.UpdateView;

//    if Count < CantModifyCount then
    {/ P122 T5 - JK 10/5/2011 - fixes CR 820 /}
    if CantModifyCount > 0 then
      magAppMsg('d','Only unsaved annotations were deleted.' + #13#10 +
                           'You are not authorized to delete saved annotations.'#13#10 +
                           'Please contact Chief HIM or Privacy Act Officer if you need to delete saved annotations.');
  end;

  UnselectAllMarks; //p122t4 dmmn
  //p122t2 dmmn 9/7
  RefreshAnnotInfoBar;
end;

procedure TMagAnnot.RefreshAnnotInfoBar;
var
  Info: String;
begin
  if HasRADAnnotation then
//    if HiddenCount > 0 then
//      Info := IntToStr(FRADAnnotationCount) + ' total / ' + IntToStr(FRADAnnotationCount) + ' hidden'
//    else
//      Info := IntToStr(FRADAnnotationCount) + ' total / 0 hidden'
    if HiddenCount > 0 then      //p122t3 dmmn 9/15 - update count for vista rad images, even temporary marks
//      Info := IntToStr(MarkCount) + ' total / ' + IntToStr(HiddenCount-FRADAnnotationIGCount+FRADAnnotationCount) + ' hidden'
        Info := IntToStr(MarkCount) + ' total / ' + IntToStr(HiddenCount) + ' hidden'
    else
      Info := IntToStr(MarkCount) + ' total / 0 hidden'
  else
    Info := IntToStr(MarkCount) + ' total / ' + IntToStr(HiddenCount) + ' hidden';

  pnlInfo.Caption := '   ' + PermissionInfo + ' - ' + Info;
end;

function TMagAnnot.MarksSelected: Integer;
var
  CurMark : IIGArtXMark;
begin
  try
    // iterate through the marks to count selected marks
    Result := 0;
    if ArtPageList <> nil then
      if Page > 0 then

    if ArtPageList[Page-1].ArtPage <> nil then
    begin
      CurMark := ArtPageList[Page-1].ArtPage.MarkSelectedFirst;
      while (not (CurMark = nil)) Do
      begin
        Inc(Result);
        CurMark := ArtPageList[Page-1].ArtPage.MarkSelectedNext(CurMark);
      end;
    end;
  finally
    CurMark := nil;
  end;
end;

function TMagAnnot.GetNewAspectRatio(value : integer; currentRuler : IIGArtXRuler) : IIGArtXAspectRatio;
var
  startPoint: IIGPoint;
  endPoint: IIGPoint;
  hyp: Double;
begin
  Result := nil;
  // get actual length;
  startPoint := currentRuler.GetStartPoint;
  endPoint := currentRuler.GetEndPoint;
  hyp := Sqrt(Sqr(startPoint.XPos - endPoint.XPos) + Sqr(StartPoint.YPos - EndPoint.YPos));

  {/p122 dmmn 7/6/11 - add support to decimal number /}
  hyp := hyp * 100;

  // set new ratio
  Result := TIGArtXAspectRatio.Create(nil).DefaultInterface;
  Result.AspectNumeratorX := value;
  Result.AspectNumeratorY := value;
  Result.AspectDenominatorX := round(hyp);
  Result.AspectDenominatorY := round(hyp);

  {/p122 dmmn 8/23 - stop using dicom ratio if user decided to use custom ratio /}
  FUseDICOMratio := False;
end;

procedure TMagAnnot.ClearDICOMRation;
begin
  {/p122t6 dmmn 10/18 - clear dicom ratio if there's none in the header /}
  FUseDICOMratio := false;
  DicomAspectRatio := nil;
end;
procedure TMagAnnot.ClearActualRatio;
begin
  {/p122t15 dmmn 7/11/12 - clear actual calibration if the image is RAD package
  or DODImage and doesnt have DICOM calibration /}
  if (RADPackage or IsDODImage) and (RulerActualAspectRatio <> nil) then
  begin
    RulerActualMeasured := 1;
    RulerActualAspectRatio := nil;
    RulerMeasUnit := 'unit';
  end;
end;

procedure TMagAnnot.UpdateMeasurementRatio(XRat, YRat: integer);
var
  distance : Real;
  hyp : Real;
begin
  {/p122 dmmn 8/23/11 - set up the new aspect ratio for ruler from the value calculated
  from the dicom header of the image /}

  {/ calculate an arbitrary distance between two point in the image
     With Point 1 (C1,R1),Point 2 (C2,R2),Spacing (Cs,Rs)
        distance (mm) = sqrt( ((C2-C1)*Cs)**2 + ((R2-R1)*Rs)**2 )
     In this case P1(50,50) P2(200,200)/}
  distance := Sqrt(Sqr((50-200)*(XRat/100000)) + Sqr((50-200)*(YRat/100000)));
  distance := distance / 10; // convert to cm
  // distance between two points in image
  hyp := (Sqrt(Sqr(50-200) + Sqr(50-200)));
//  hyp := hyp / 10;

  DicomAspectRatio := nil;
  DicomAspectRatio := TIGArtXAspectRatio.Create(nil).DefaultInterface;
  DicomAspectRatio.AspectNumeratorX := Trunc(distance);
  DicomAspectRatio.AspectNumeratorY := Trunc(distance);
  DicomAspectRatio.AspectDenominatorX := Trunc(hyp);
  DicomAspectRatio.AspectDenominatorY := Trunc(hyp);

//  RulerMeasUnit := 'mm (DCM)';
  RulerMeasUnit := 'cm (DCM)';
(*  gek.  these next 4 were commented out in 122 t 15 
//  {/ P122 T15 - JK 7/30/2012 - added the check for XRat = 0 and YRat = 0 so that the calibration popup is shown /}
//  if (XRat = 0) and (YRat = 0) then
//    ClearDICOMRation
//  else
*)

  FUseDICOMratio := True;
end;

procedure TMagAnnot.UpdateNewAspectRatio;
var
//  CurRuler: IIGArtXRuler;
  CurMark : IIGArtXMark;
  i: Integer;
begin
  // go through all the pages in the image
  for i := 0 to PageCount - 1 do
  begin
    // go through all the ruler marks in the page
    CurMark := ArtPageList[i].ArtPage.MarkFirst;
    while CurMark <> nil do
    begin
      if (CurMark.type_ = IG_ARTX_MARK_RULER) then
      begin
        {/p122 dmmn 8/25 update temp rulers too /}
//        if (GetViewHideFieldValue(3, CurMark.Tooltip) = 'YYYYMMDDHHMMSS') or   // current session
//          (CurMark.Tooltip = 'Temporary Ruler Annotation') or       // temp ruler for VR
//          (AnsiContainsStr(CurMark.Tooltip, '|*edited*|'))     //p122t3 9/19 for old ruler that been updated to current session
//          then
        {/p122t4 dmmn 9/28 all the rulers that can be modified by the current user should be able to
        change calibration /}
        if (CanUserModifyMark(CurMark)) then
        begin
          (CurMark as IIGArtXRuler).SetAspectRatio(RulerActualAspectRatio);
          (CurMark as IIGArtXRuler).Label_ := '%d ' + RulerMeasUnit;  //p122 dmmn 7/12/11

          {/p122t4 dmmn 9/28 - all the updated old ruler should be mark as edited /}
          EditAnnotationOwnership(CurMark);
        end;
      end;
      CurMark := ArtPageList[i].ArtPage.MarkNext(CurMark);
    end;
  end;
end;

procedure TMagAnnot.UpdateOldRulerCalibrationToCurrent(IGMark: IIGArtXRuler);
begin
    {/p122t3 dmmn 9/19 - if the user modified an old ruler, the ruler is considered belong to the current
    session so it should apply the current calibration if available otherwise keep it the same/}
    if FormatDatePiece(GetViewHideFieldValue(3, IGMark.Tooltip)) <> '' then
    begin
      if Not FUseDICOMratio then  // image without dicom header
      begin
        if RulerActualAspectRatio <> nil then
        begin
          IGMark.SetAspectRatio(RulerActualAspectRatio);
          IGMark.Label_ := '%d ' + RulerMeasUnit; //p122 dmmn 7/12/11 - new units
        end;
      end
      else
      begin                       // image with dicom header
        if DicomAspectRatio <> nil then
        begin
          IGMark.SetAspectRatio(DicomAspectRatio);
          IGMark.Label_ := '%d ' + RulerMeasUnit; //p122 dmmn 7/12/11 - new units
        end;
      end;
    end;
end;

procedure TMagAnnot.ClearAllAspectRatio;
var
  CurMark : IIGArtXMark;
  I: Integer;
  newRatio : IIGArtXAspectRatio;
  yesClear, noClear : integer;
begin
  {/P122 dmmn 7/13/11 - clear all calibrated value for current session /}
  try
    {/p122t4 dmmn 9/27 - counting the ruler changed /}
    yesClear := 0;
    noClear := 0;

    for i := 0 to PageCount - 1 do
    begin
      CurMark := ArtPageList[i].ArtPage.MarkFirst;
      while CurMark <> nil do
      begin
        if (CurMark.type_ = IG_ARTX_MARK_RULER) then
        begin
          {/p122 added temp rulers for view only images /}
//          if (GetViewHideFieldValue(3, CurMark.Tooltip) = 'YYYYMMDDHHMMSS') or   // current sessio ruler
//             (CurMark.Tooltip = 'Temporary Ruler Annotation')  or // temporary ruler for vista rad
//             (AnsiContainsStr(CurMark.Tooltip, '|*edited*|')) or    //p122t3 9/19 for old ruler that been updated to current session
          {/p122t4 dmmn 9/28 - clear all ruler that are modifiable in the current session /}
          if   (CanUserModifyMark(CurMark as IIGArtXMark)) then
          begin
            {/p122 dmmn 8/23 - for normal image, clear ratio will revert to original 1-1.
            for image with dicom ratio, clear ratio will revvert to original dicom ratio /}
            if DicomAspectRatio = nil then
            begin
              RulerActualMeasured := 1;
              newRatio := TIGArtXAspectRatio.Create(nil).DefaultInterface;
              newRatio.AspectNumeratorX := 1;
              newRatio.AspectNumeratorY := 1;
              newRatio.AspectDenominatorX := 1;
              newRatio.AspectDenominatorY := 1;
              RulerMeasUnit := 'unit';  //p122 dmmn 8/23
              (CurMark as IIGArtXRuler).SetAspectRatio(newRatio);
              (CurMark as IIGArtXRuler).Label_ := '%d ' + RulerMeasUnit;  //p122 dmmn 7/12/11
            end
            else
            begin
              FUseDICOMratio := True;
  //            RulerMeasUnit := 'mm (DCM)';
              RulerMeasUnit := 'cm (DCM)';
              (CurMark as IIGartXRuler).SetAspectRatio(DicomAspectRatio);
              (CurMark as IIGArtXRuler).Label_ := '%d ' + RulerMeasUnit;
            end;
            EditAnnotationOwnership(CurMark as IIGArtXMark); //p122t4 dmmn 9/27 
            inc(yesClear);  //p122t4 dmmn 9/27
            FAnnotsModified := True;
          end
         else  // not permited to clear
         begin
          inc(noClear);
         end;
        end;
        CurMark := ArtPageList[i].ArtPage.MarkNext(CurMark);
      end;
    end;

    {/p122t4 dmmn 9/27 - confirmation message /}
    if yesClear = 0 then // if nothing were cleared.
      //p122t14 - change message to adapt changes in this build
      ShowMessage('You are not authorized to clear saved calibrations. Contact Chief HIM or Privacy Act Officer.')
    else
    begin
      //if yesClear < noClear then // some were not cleared
      if noClear > 0 then
        Showmessage('Only unsaved calibration was cleared.'#13#10 +
                    'You are not authorized to clear saved calibrations. Contact Chief HIM or Privacy Act Officer.');
    end;

    IGPageViewCtl.UpdateView;
  except
    on E:Exception do
    begin
      magAppMsg('s','In TMagAnnot.ClearAllAspectRatio' );
      magAppMsg('s', E.ClassName + 'error raised, with message: '+ E.Message);
    end;
  end;
end;

function TMagAnnot.DeleteCachedFiles(const Path, Mask: string): integer;
var
  FindResult: integer;
  SearchRec : TSearchRec;
begin
  result := 0;

  FindResult := FindFirst(Path + Mask, faAnyFile - faDirectory, SearchRec);
  while FindResult = 0 do
  begin
    { do whatever you'd like to do with the files found }
    DeleteFile(Path + SearchRec.Name);
    result := result + 1;

   FindResult := FindNext(SearchRec);
 end;
 { free memory }
 FindClose(SearchRec);
end;


function TMagAnnot.FormatDatePiece(Str: String): String;
var
  y, m, mth, d, hr, mn, sc, ampm: String;
  S: String;
begin
  Result := '';
  S := Str;

  if (S = '') or (System.Copy(Uppercase(S), 1, 1) = 'Y') then
    Exit;

  try
    y  := System.Copy(S, 1, 4);
    m  := System.Copy(S, 5, 2);
    d  := System.Copy(S, 7, 2);
    hr := System.Copy(S, 9, 2);
    mn := System.Copy(S, 11, 2);
    sc := System.Copy(S, 13, 2);

    if m = '01' then
      mth := 'Jan'
    else if m = '02' then
      mth := 'Feb'
    else if m = '03' then
      mth := 'Mar'
    else if m = '04' then
      mth := 'Apr'
    else if m = '05' then
      mth := 'May'
    else if m = '06' then
      mth := 'Jun'
    else if m = '07' then
      mth := 'Jul'
    else if m = '08' then
      mth := 'Aug'
    else if m = '09' then
      mth := 'Sep'
    else if m = '10' then
      mth := 'Oct'
    else if m = '11' then
      mth := 'Nov'
    else if m = '12' then
      mth := 'Dec'
    else
      mth := 'err';

    //p122t5 dmmn 10/6 - we are using 24h format, so there will be no am or pm
//    if StrToInt(hr) < 12 then
//      ampm := 'am'
//    else
//      ampm := 'pm';


    Result := mth + ' ' + d + ', ' + y + '@' + hr + ':' + mn + ':' + sc; // + ' ' + ampm;
  except
    on E:Exception do
    begin
      Result := 'Error';
      magAppMsg('s', 'FormatDatePiece error = ' + E.Message + ' / Str = ' + Str);
    end;
  end;              
end;

function TMagAnnot.FormatToolTip(S: String): String;
var
  UserName: String;
  UserService: String;
  DateStamp: String;
  UserDUZ: String;
  UserSite: String;
begin
  try
    UserName := MagPiece(S, '|', 1);
    UserService := MagPiece(S, '|', 2);
    DateStamp := FormatDatePiece(MagPiece(S, '|', 3));
    UserDUZ := MagPiece(S, '|', 4);
    UserSite := MagPiece(S, '|', 5);
    if DateStamp <> '' then
      Result := 'Owner:' + UserName + '  Service:' + UserService + '  Created:' + DateStamp
    else
      Result := 'Owner:' + UserName + '  Service:' + UserService; //p122t3 dmmn 9/13 - hide date field if it's a current session annotations
//                + ' DUZ:' + UserDUZ + ' Site:' + UserSite;  //p122 dmmn 7/27 - hide duz and site
  except
    on E:Exception do
    begin
      magAppMsg('s', 'FormatToolTip error = ' + E.Message + ' / S = ' + S);
      Result := S;
    end;

  end;
end;

function TMagAnnot.RemoveTabCharacters(XML: TStringList): String;
var
  i: Integer;
  temp : string;
begin
  Result := '';
  for i := 0 to XML.Count - 1 do
  begin
    //p122t5 dmmn - avoid accidently remove the correct new line characters 
    temp := SysUtils.StringReplace(XML[i], '|TAB|', '', [rfReplaceAll]);
    temp := SysUtils.StringReplace(temp, #10, '', [rfReplaceAll]);
    temp := SysUtils.StringReplace(temp, #13, '', [rfReplaceAll]);
    Result := Result + temp;
//    Result := Result + SysUtils.StringReplace(XML[i], '|TAB|', '', [rfReplaceAll]);
//    Result := SysUtils.StringReplace(Result, #10, '', [rfReplaceAll]);
//    Result := SysUtils.StringReplace(Result, #13, '', [rfReplaceAll]);
//    Result := SysUtils.StringReplace(Result, '^\r\n^',#13#10, [rfReplaceAll]);   //p122T1 dmmn - new line delim
  end;

  //p122t5 make sure that all the non standard control characters are out of the xml
  Result := SysUtils.StringReplace(Result, '^\r\n^',#13#10, [rfReplaceAll]);
end;

function TMagAnnot.ValidateXML(const xmlFile : TFileName) : boolean;
var
  xmlDoc: TXMLDocument;
begin
  result := false;
  xmlDoc := TXMLDocument.Create(nil);
  try
    xmlDoc.ParseOptions := [poResolveExternals, poValidateOnParse];
    try
      xmlDoc.LoadFromFile(xmlFile) ;
      xmlDoc.Active := true; //this will validate
      result := true;
   except
    on E:EDOMParseError do
    begin
      magAppMsg('s', 'ValidateXML ERROR: Invalid XML for ImageIEN ' + ImageIEN + ' Error: ' + E.Message);
    end;
  end;
  finally
    xmlDoc := nil;

  end;
end;

{$REGION 'ACCUSOFT''s DICOM Calibrate'}
function TMagAnnot.GetDisplayResolution(var xDPI : double; var yDPI : double) : Boolean;
var
 hDC : THandle;
begin
  hDC := GetDC(0);
  if (hDC <> 0) then
  begin
    xDPI := GetDeviceCaps(hDC,LOGPIXELSX);
    yDPI := GetDeviceCaps(hDC,LOGPIXELSY);
    ReleaseDC(0,hdc);
  end;
  Result := true;
end;

function TMagAnnot.GetImageResolution(var xDPI, yDPI: double): Boolean;
begin

end;

procedure TMagAnnot.ConverRealToFraction(realVal : Double; var pNum : integer; var pDem: integer);
const precision = 4;
var
  multiplier : double;
begin
  multiplier := Power(10, precision);
  pNum := Round(realVal * multiplier);
  pDem := Round(multiplier);
end;

procedure TMagAnnot.ConfigureRulerForUnitMilimeter(IGMark : IIGArtXRuler);
const
  precision = 2;
  MMPerIN = 25.4;
  MMPerCM = 10.0;
  CMPerIN = 2.54;
var
  szLabel : string;
  displayResXDPI : double;
  displayResYDPI : double;
  scaleX : double;
  scaleY : double;
  AspectRat : IIGArtXAspectRatio;
  numX,denX,numY,denY : Integer;
begin
  szLabel := 'mm (DCM)';
  displayResXDPI := 72.0;
  displayResYDPI := 72.0;
  scaleX := 1.0;
  scaleY := 1.0;

  DicomAspectRatio := nil;
  DicomAspectRatio := TIGArtXAspectRatio.Create(nil).DefaultInterface;

  // calculate scale factor to express screen pixels as millimeters
//  GetDisplayResolution(displayResXDPI,displayResYDPI);
//  scaleX := MMPerCM * CMPerIN / displayResXDPI ;
//  scaleY := MMPerCM * CMPerIN / displayResYDPI ;

  // identify resolution from most-reliable to least reliable:
	// 1. DICOM attribute (0028,0030) Pixel Spacing
	// 2. Image data
	// 3. Display device
	//

  // set aspect ratio to calculated scale factor
  numX := 1;
  denX := 1;
  numY := 1;
  denY := 1;
  ConverRealToFraction(scaleX , numX ,denX);
  ConverRealToFraction(scaleY , numY,denY);
  DicomAspectRatio.AspectNumeratorX := numX;
  DicomAspectRatio.AspectDenominatorX := denX;
  DicomAspectRatio.AspectNumeratorY := numY;
  DicomAspectRatio.AspectDenominatorY := denY;

  // update the ruler mark
  IGMark.SetAspectRatio(DICOMAspectRatio);
  IGMark.Precision := precision;
  IGMark.Label_ := szLabel;
end;
{$ENDREGION}

{$REGION 'TArtPageObjList'}
{ TArtPageObjectList }

function TArtPageObjectList.Add(AArtPageItem: TArtPageObject): Integer;
begin
  Result := inherited Add(AArtPageItem);
end;

function TArtPageObjectList.GetArtPageID(Idx: Integer): String;
begin
  Result := TArtPageObject(Items[Idx]).ArtPageID;
end;

function TArtPageObjectList.GetArtPageItem(AIndex: Integer): TArtPageObject;
begin
  Result := inherited Items[AIndex] as TArtPageObject;
end;

procedure TArtPageObjectList.SetArtPageItem(AIndex: Integer; const Value: TArtPageObject);
begin
  inherited Items[AIndex] := Value;
end;
{$ENDREGION}

{$REGION 'TMagAnnotChoicesBox}
{TMagAnnotChoicesBox }

procedure TMagAnnotChoicesBox.btnCancelOnClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TMagAnnotChoicesBox.btnOKOnClick(Sender: TObject);
begin
  SelectedValue := '';

  if lstChoice.ItemIndex = -1 then
    self.ModalResult := mrCancel
  else
  begin
    SelectedValue := lstChoice.Items[lstChoice.ItemIndex];
    self.ModalResult := mrOK;
  end;
end;

procedure TMagAnnotChoicesBox.InitForm;
begin
  self.Width := 200;
  self.ClientHeight := 155;
  self.BorderStyle := bsToolWindow;
  self.Caption := 'Choices Available';
//  self.Position := poMainFormCenter; //p122 7/27/ - center the forms

  lstChoice := TCustomListBox.Create(self);
  lstChoice.Parent := self;
  lstChoice.Align := alTop;
  lstChoice.Height := 130;

  btnOK := TButton.Create(self);
  btnOK.Parent := self;
  btnOK.Left := 55;
  btnOK.Top := 135;
  btnOK.Width := 40;
  btnOK.Height := 20;
  btnOK.Caption := 'OK';
  btnOK.OnClick := btnOKOnClick;

  //p122 dmmn 7/28 - add cancel
  btnCancel := TButton.Create(self);
  btnCancel.Parent := self;
  btnCancel.Left := 105;
  btnCancel.Top := 135;
  btnCancel.Width := 40;
  btnCancel.Height := 20;
  btnCancel.Caption := 'Cancel';
  btnCancel.OnClick := btnCancelOnClick;
end;

procedure TMagAnnotChoicesBox.InitItems(items: string);
var
  itemLst : TStringList;
  I: Integer;
begin
  itemLst := TStringList.Create;
  try
    itemLst.StrictDelimiter := True;
    itemLst.Delimiter := '|';
    itemLst.DelimitedText := items;
    itemLst.Delete(itemLst.Count-1);    // remove the empty item at the end
    for I := 0 to itemLst.Count - 1 do
    begin
      self.lstChoice.Items.Add(itemLst[I]);
    end;
  finally
    itemLst.Free;
  end;
end;

{$ENDREGION}

{$REGION 'TAnnotNodeData'}
{ TAnnotNodeData }

function TAnnotNodeData.GetHistoryDateTime: String;
begin
  Result := GetFormattedToolTip;
end;

function TAnnotNodeData.GetFormattedToolTip: String;
begin
  Result := FSavedDateTime;
end;
{$ENDREGION}

{$REGION 'DICOM conversion for ArtXRuler'}
{
Source : http://groups.google.com/group/comp.protocols.dicom/browse_thread/thread/7535d9a4bc547e7f?pli=1
Excerp :
  In general one needs to determine the distance in mm along the column
  axis between the two points, and the distance along the row axis
between the two points, using the appropriate pixel spacing
attribute values to convert the distance in pixels to mm, and then
compute the hypotenuse of the triangle so defined.
  Given:  Point 1 (C1,R1)
          Point 2 (C2,R2)
          Spacing (Cs,Rs)
    distance (mm) = sqrt( ((C2-C1)*Cs)**2 + ((R2-R1)*Rs)**2 )

Result from VistA Images with known measurements:
            Description	                Actual Measured
  Image	 	                  p117	                                  p122
 	 	                        Down 1-1	          Full 1-1	  Down 1-1	  Full 1-1
DM000909	  4.0 cm	      4.03 cm = 40.3 mm	  4.02 cm	      40.71 mm	  39.63 mm
DM000910	  4.5 cm	      4.54 cm = 45.4 mm	  4.52 cm	      45.17 mm	  44.45 mm
DM005665	  4.5 cm	      4.51 cm = 45.1 mm	  n/a	          45.17 mm	  n/a
DM005666	  3.4 cm	      3.36 cm = 33.6 mm	  n/a	          33.70 mm	  n/a
DM005667	  2.25 cm	      2.25 cm = 22.5 mm	  n/a	          22.23 mm	  n/a
DM005668	  2.25 cm	      2.24 cm = 22.4 mm	  n/a	          22.37 mm	  n/a
DM005669	  uncalibrated	n/a	                n/a	          calibrate	  n/a
Variations due to different pixel locations.
Here’s the method:
Take two points on the image (50,50) (200,200) and calculate the distance between them
Then calculate the distance(mm) by using this formula:
distance (mm) = sqrt( ((X2-X1)*XSpacing)^2 + ((Y2-Y1)*YSpacing)^2 )
XSpacing(XDenom) and YSpacing(YDenom) are calculated from the previous patch 117.
}
{$ENDREGION}


{$REGION 'ArtPageObject'}
{ TArtPageObject }

constructor TArtPageObject.Create;
begin
  FFlipVer := False;
  FFlipHor := False;
  FRotateRight := 0;
  FRotateLeft := 0;
  FAnnotDeleted := False; //p122t7
end;

procedure TArtPageObject.FlipHor;
begin
  FFlipHor := Not FFlipHor;
end;

procedure TArtPageObject.FlipVer;
begin
  FFlipVer := Not FFLipVer;
end;

procedure TArtPageObject.RotateLeft;
begin
  if FRotateRight > 0 then        // decrement the right because you are undoing it
    dec(FRotateRight)
  else
    inc(FRotateLeft);

  if (FRotateLeft = 4) and (FRotateRight = 0) then  // full loop left
    FRotateLeft := 0;
end;

procedure TArtPageObject.RotateRight;
begin
  if FRotateLeft > 0 then        // decrement the right because you are undoing it
    dec(FRotateLeft)
  else
    inc(FRotateRight);

  if (FRotateRight = 4) and (FRotateLeft = 0) then  // full loop right
    FRotateRight := 0;
end;

procedure TArtPageObject.UpdateRects(ImgRight, ImgBottom : integer);
begin
  FImgRight := ImgBottom;  // flips the values since we are aready rotated
  FImgBottom := ImgRight;
end;
{$ENDREGION}

end.
