Unit fMagAnnot;

Interface

Uses
  Windows,
  ActnList,
  Buttons,
  Classes,
  Controls,
  Dialogs,
  ExtCtrls,
  fMagAnnotOptions,
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
  Variants;

{ TODO -oDick Maley -cCleanup : DisplayCurrentMarkProperties is called from FMagRadViewer.  The method has no code in it.  Figure out what to do. }
{$DEFINE HIDENEXTGEN}

Type
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

  TRequiredAnnotation = (
    Annot00_SELECT,
    Annot03_LINE,
    Annot04_FREEHAND_LINE,
    Annot05_HOLLOW_RECTANGLE,
    Annot07_TYPED_TEXT,
    Annot13_POLYLINE,
    Annot16_HOLLOW_ELLIPSE,
    Annot17_ARROW,
    Annot33_HOLLOW_SQUARE,
    Annot35_HOLLOW_CIRCLE,
    Annot60_Options
    );

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
    Annot21_RULER,
    Annot22_PROTRACTOR,
    Annot23_BUTTON,
    Annot24_PIN_UP_TEXT,
    Annot25_HIGHLIGHTER,
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
    ActualSize1: TMenuItem;
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
    Antialiasing1: TMenuItem;
    btnAnnot00_SELECT: TSpeedButton;
    btnAnnot01_IMAGE_EMBEDDED: TSpeedButton;
    btnAnnot02_IMAGE_REFERENCE: TSpeedButton;
    btnAnnot03_LINE: TSpeedButton;
    btnAnnot04_FREEHAND_LINE: TSpeedButton;
    btnAnnot05_HOLLOW_RECTANGLE: TSpeedButton;
    btnAnnot06_FILLED_RECTANGLE: TSpeedButton;
    btnAnnot07_TYPED_TEXT: TSpeedButton;
    btnAnnot08_TEXT_FROM_FILE: TSpeedButton;
    btnAnnot09_TEXT_STAMP: TSpeedButton;
    btnAnnot10_ATTACH_A_NOTE: TSpeedButton;
    btnAnnot11_FILLED_POLYGON: TSpeedButton;
    btnAnnot12_HOLLOW_POLYGON: TSpeedButton;
    btnAnnot13_POLYLINE: TSpeedButton;
    btnAnnot14_AUDIO: TSpeedButton;
    btnAnnot15_FILLED_ELLIPSE: TSpeedButton;
    btnAnnot16_HOLLOW_ELLIPSE: TSpeedButton;
    btnAnnot17_ARROW: TSpeedButton;
    btnAnnot18_HOTSPOT: TSpeedButton;
    btnAnnot19_REDACTION: TSpeedButton;
    btnAnnot20_ENCRYPTION: TSpeedButton;
    btnAnnot21_RULER: TSpeedButton;
    btnAnnot22_PROTRACTOR: TSpeedButton;
    btnAnnot23_BUTTON: TSpeedButton;
    btnAnnot24_PIN_UP_TEXT: TSpeedButton;
    btnAnnot25_HIGHLIGHTER: TSpeedButton;
    btnAnnot26_RICH_TEXT: TSpeedButton;
    btnAnnot27_CALLOUT: TSpeedButton;
    btnAnnot28_RECTANGLE: TSpeedButton;
    btnAnnot29_ELLIPSE: TSpeedButton;
    btnAnnot30_POLYGON: TSpeedButton;
    btnAnnot31_TEXT: TSpeedButton;
    btnAnnot32_IMAGE: TSpeedButton;
    btnAnnot33_HOLLOW_SQUARE: TSpeedButton;
    btnAnnot34_FILLED_SQUARE: TSpeedButton;
    btnAnnot35_HOLLOW_CIRCLE: TSpeedButton;
    btnAnnot36_FILLED_CIRCLE: TSpeedButton;
    btnAnnot60_Options: TSpeedButton;
    Close1: TMenuItem;
    Copy1: TMenuItem;
    Copy2: TMenuItem;
    CopyFirst1: TMenuItem;
    CopyLast1: TMenuItem;
    Delete1: TMenuItem;
    DeleteAllSelected1: TMenuItem;
    DeleteFirst1: TMenuItem;
    DeleteFirstSelected1: TMenuItem;
    DeleteLastAnnotation1: TMenuItem;
    DeleteLastSelected1: TMenuItem;
    EditMode1: TMenuItem;
    EnableUndo1: TMenuItem;
    FIGPageViewCtl_: TIGPageViewCtl;
    FilledCircle1: TMenuItem;
    FilledSquare1: TMenuItem;
    Fit1: TMenuItem;
    FittoHeight1: TMenuItem;
    FittoWidth1: TMenuItem;
    FittoWindow1: TMenuItem;
    Flip1: TMenuItem;
    FlipHorizontally1: TMenuItem;
    FlipVertically1: TMenuItem;
    HideAnnotations1: TMenuItem;
    HollowCircle1: TMenuItem;
    HollowSquare1: TMenuItem;
    lstImages: TImageList;
    MainMenu: TMainMenu;
    mnuAnnotAddTextfromaFile: TMenuItem;
    mnuAnnotArrow: TMenuItem;
    mnuAnnotation: TMenuItem;
    mnuAnnotAttachaNote: TMenuItem;
    mnuAnnotAudio: TMenuItem;
    mnuAnnotButton: TMenuItem;
    mnuAnnotEmbeddedImage: TMenuItem;
    mnuAnnotEncryption: TMenuItem;
    mnuAnnotFilledEllipse: TMenuItem;
    mnuAnnotFilledPolygon: TMenuItem;
    mnuAnnotFilledRectangle: TMenuItem;
    mnuAnnotFreehandLine: TMenuItem;
    mnuAnnotHighlighter: TMenuItem;
    mnuAnnotHollowEllipse: TMenuItem;
    mnuAnnotHollowPolygon: TMenuItem;
    mnuAnnotHollowRectangle: TMenuItem;
    mnuAnnotHotspot: TMenuItem;
    mnuAnnotImageReference: TMenuItem;
    mnuAnnotLine: TMenuItem;
    mnuAnnotPinupText: TMenuItem;
    mnuAnnotPolyline: TMenuItem;
    mnuAnnotProtractor: TMenuItem;
    mnuAnnotRedaction: TMenuItem;
    mnuAnnotRichText: TMenuItem;
    mnuAnnotRuler: TMenuItem;
    mnuAnnotSelect: TMenuItem;
    mnuAnnotTextStamp: TMenuItem;
    mnuAnnotTypedText: TMenuItem;
    mnuDeleteAllAnnots: TMenuItem;
    mnuEdit: TMenuItem;
    MnuFile: TMenuItem;
    mnuFileExportAnnotations: TMenuItem;
    mnuFileImportAnnotations: TMenuItem;
    mnuFileSave: TMenuItem;
    MnuView: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    Off1: TMenuItem;
    On1: TMenuItem;
    OpenDialog: TOpenDialog;
    Options1: TMenuItem;
    Paste1: TMenuItem;
    pnlAnnots: Tpanel;
    Reset1: TMenuItem;
    Rotate1: TMenuItem;
    Rotate1801: TMenuItem;
    Rotate270CCW1: TMenuItem;
    Rotate90CW1: TMenuItem;
    RotateCCW901: TMenuItem;
    RotateCW2701: TMenuItem;
    SaveDialog: TSaveDialog;
    SelectAll1: TMenuItem;
    Undo1: TMenuItem;
    Zoom1: TMenuItem;
    ZoomIn1: TMenuItem;
    ZoomOut1: TMenuItem;
    actEditUserCanEdit: TAction;
    UserCanEdit1: TMenuItem;
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
    Procedure FIGArtXCtlModifyMarkNotify(ASender: Tobject; Const Params: IIGArtXModifyMarkEventParams);
    Procedure FIGArtXCtlPreCreateMarkNotify(ASender: Tobject; Const Params: IIGArtXPreCreateMarkEventParams);
    Procedure FormActivate(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure FormCreate(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure FormShow(Sender: Tobject);
    Procedure actEditUserCanEditExecute(Sender: Tobject);
  Private
    Function GetUserCanEdit: Boolean;

  Protected
    FAdditionalAnnotations: TAdditionalAnnotations;
    FAnnotationOptions: TfrmAnnotOptions;
    FAnnotationStyle: TMagAnnotationStyle;
    FArrowLength: Integer;
    FArtPage: IIGArtXPage;
    FCurAnnot: TAnnotationType;
    FcurrentPage: IIGPage;
    FCurrentPageDisp: IIGPageDisplay;
    FCurrentPageNumber: Integer;
    FEditMode: Boolean;
    FEditModeFalseReason: String;
    FEditModeFalseReasonShow: Boolean;
    FHasBeenModified: Boolean;
    FIGArtDrawParams: IIGArtXDrawParams;
    FIGPageViewCtl: TIGPageViewCtl;
    FIoLocation: IIGIOLocation;
    FMagAnnotationStyleChangeEvent: TMagAnnotationStyleChangeEvent;
    FPage: Integer;
    FPageCount: Integer;
    FProtractorState: Integer;
    FToolbarInitialized: Boolean;
    FToolbarIsShowing: Boolean;
    FTotalLocationPageCount: Integer;
    FUserCanEdit: Boolean;
    IgCurPoint: IGPoint;
    PageViewHwnd: Integer;
    Function GetAnnotationOptions: TfrmAnnotOptions;
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
    Procedure SetUserCanEdit(Const Value: Boolean);
  Published
  Public
    Buttons: Array[0..37] Of TSpeedButton;
    Function ClipboardAction(action: TMagAnnotClipboardActions): Boolean; Virtual;
    Function Copy(): Boolean; Virtual;
    Function CopyFirstSelected(): Boolean; Virtual;
    Function CopyLastSelected(): Boolean; Virtual;
    Function CreateArtPage(): IIGArtXPage; Overload;
    Function CreateArtPage(CurrentPage_: IIGPage; CurrentPageDisp_: IIGPageDisplay): IIGArtXPage; Overload;
    Function CreateCircle(IGRect: IIGRectangle; FillColor: IIGPixel; Border: IIGArtXBorder; Opacity: Integer): IIGArtXEllipse;
    Function CreateFilledSquare(IGRect: IIGRectangle; FillColor: IIGPixel; bHighlight: WordBool): IIGArtXFilledRectangle;
    Function CreateHollowCircle(IGRect: IIGRectangle; Border: IIGArtXBorder; bHighlight: WordBool): IIGArtXHollowEllipse;
    Function CreateHollowSquare(IGRect: IIGRectangle; Border: IIGArtXBorder; bHighlight: WordBool): IIGArtXHollowRectangle;
    Function CreateSquare(IGRect: IIGRectangle; FillColor: IIGPixel; Border: IIGArtXBorder; Opacity: Integer): IIGArtXRectangle;
    Function CurrentPageClear(): Boolean;
    Function Cut(): Boolean; Virtual;
    Function CutFirstSelected(): Boolean; Virtual;
    Function CutLastSelected(): Boolean; Virtual;
    Function DeleteLastAnnotByType(mark: enumIGArtXMarkType): Boolean;
    Function DeleteLastArrow: Boolean;
    Function DeleteLastAudio: Boolean;
    Function DeleteLastButton: Boolean;
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
    Function GetColor(): TColor; Virtual;
    Function GetFont(): TFont; Virtual;
    Function GetIGPageViewCtl(Parent: TWinControl): TIGPageViewCtl;
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
    Function IsValidEnv(): Boolean; Overload;
    Function IsValidEnv(CurPage: IIGPage): Boolean; Overload;
    Function IsValidForEdit(CurPage: IIGPage): Boolean;
    Function LoadFile(Filename: String): String; Overload;
    Function LoadFile(): String; Overload;
    Function Paste(): Boolean; Virtual;
    Function RemoveAllAnnotations(): Boolean;
    Function SelectAll(): Boolean; Virtual;
    Function SelectedButtonIsDown(action: TAction): Boolean; Overload;
    Function SelectedButtonIsDown(action: TAnnotationType): Boolean; Overload;
    Function SelectFile(Var Filename: String; Var PageNum, PageCount: Integer): Boolean;
    Function Undo(): Boolean; Virtual;
    Procedure CheckErrors();
    Procedure ClearAllAnnotations(); Virtual;
    Procedure ClearSelectedAnnotations(); Virtual;
    Procedure CreateMarkEllipseToDefaults(IGMark: IIGArtXEllipse);
    Procedure CreateMarkRectangleToDefaults(IGMark: IIGArtXRectangle);
    Procedure CreatePage();
    Procedure DisplayCurrentMarkProperties(); Virtual;
    Procedure DrawText(Left, Right, Top, Bottom, Red, Green, Blue: Integer; Text: String; FontSize: Integer); Virtual;
    Procedure EnableMeasurements(); Virtual;
    Procedure IGPageViewCtlMouseDown(ASender: Tobject; Button: Smallint; Shift: Smallint; x: Integer; y: Integer);
    Procedure IGPageViewCtlMouseMove(ASender: Tobject; Button, Shift: Smallint; x, y: Integer);
    Procedure IGPageViewCtlMouseUp(ASender: Tobject; Button, Shift: Smallint; x, y: Integer);
    Procedure InitButtonAlignLeft();
    Procedure InitButtonCaptions();
    Procedure InitButtonsArray();
    Procedure InitButtonVisibility();
    Procedure Initialize(CurPoint: IIGPoint; CurPage: IIGPage; CurPageDisp: IIGPageDisplay; PageViewHwnd: Integer; ForDiagramAnnotation: Boolean);
    Procedure InitializeToolbar(AnnotationComponent: TAnnotationType; x, y: Integer);
    Procedure InitializeVariables(); Virtual;
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
    Procedure RemoveOrientationLabel(); Virtual;
    Procedure ReplaceLastEllipseWithCircle(Filled: Boolean);
    Procedure ReplaceLastFilledRectangleWithFilledSquare();
    Procedure ReplaceLastRectangleWithSquare(Filled: Boolean);
    Procedure ResetPageGlobals();
    Procedure RotateImage(Value: enumIGRotationValues);
    Procedure SetAnnotationColor(aColor: TColor); Virtual;
    Procedure SetAnnotationStyles(); Virtual;
    Procedure SetArrowHead(IGMark: IIGArtXArrow);
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
    Procedure UncheckAllAnnots();
    Procedure UnselectAllMarks(); Virtual;
    Procedure UpdateButtonEnabling();
  Published
    Property AdditionalAnnotations: TAdditionalAnnotations Read FAdditionalAnnotations Write FAdditionalAnnotations;
    Property AnnotationOptions: TfrmAnnotOptions Read GetAnnotationOptions;
    Property AnnotationStyle: TMagAnnotationStyle Read GetAnnotationStyle Write SetAnnotationStyle;
    Property ArtPage: IIGArtXPage Read FArtPage Write FArtPage;
    Property CurAnnot: TAnnotationType Read FCurAnnot Write FCurAnnot;
    Property CurrentPage: IIGPage Read GetCurrentPage Write SetCurrentPage;
    Property CurrentPageDisp: IIGPageDisplay Read FCurrentPageDisp Write SetCurrentPageDisp;
    Property CurrentPageNumber: Integer Read FCurrentPageNumber Write FCurrentPageNumber;
    Property CurrentPoint: IGPoint Read IgCurPoint;
    Property EditMode: Boolean Read GetEditMode Write SetEditMode;
    Property HasBeenModified: Boolean Read FHasBeenModified Write FHasBeenModified;
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
    Property OnMagAnnotationStyleChangeEvent: TMagAnnotationStyleChangeEvent Read FMagAnnotationStyleChangeEvent Write FMagAnnotationStyleChangeEvent;
    Property Page: Integer Read GetPage Write SetPage;
    Property PageCount: Integer Read GetPageCount Write SetPageCount;
    Property TotalLocationPageCount: Integer Read FTotalLocationPageCount Write FTotalLocationPageCount;
    Property UserCanEdit: Boolean Read GetUserCanEdit Write SetUserCanEdit;
  End;

Implementation
Uses
  cMagIGManager,
  ComObj;

{$R *.dfm}

Procedure TMagAnnot.FormActivate(Sender: Tobject);
Var
  inTemp: Integer;
Begin
  FToolbarIsShowing := True;
  If Tag = 0 Then
  Begin

    //MagAnnot.Top
    If MagAnnotDefaults.Value('MagAnnot.Top') <> '' Then
    Begin
      Try
        inTemp := Strtoint(MagAnnotDefaults.Value('MagAnnot.Top'));
        If inTemp < 0 Then inTemp := 0;
        If inTemp > (Screen.Height - Height - 30) Then inTemp := Screen.Height - Height - 30;
        Top := inTemp;
      Except
      End;
    End;
    MagAnnotDefaults.Persist('MagAnnot.Top', Top);

    //MagAnnot.Left
    If MagAnnotDefaults.Value('MagAnnot.Left') <> '' Then
    Begin
      Try
        inTemp := Strtoint(MagAnnotDefaults.Value('MagAnnot.Left'));
        If inTemp < 0 Then inTemp := 0;
        If inTemp > (Screen.Width - Width) Then inTemp := Screen.Width - Width;
        Left := inTemp;
      Except
      End;
    End;
    MagAnnotDefaults.Persist('MagAnnot.Left', Left);
    MagAnnotDefaults.Persist();
    Tag := 1;
  End;
End;

Procedure TMagAnnot.FormClose(Sender: Tobject; Var action: TCloseAction);
Begin
  FToolbarIsShowing := False;
  MagAnnotDefaults.Persist('MagAnnot.Top', Top);
  MagAnnotDefaults.Persist('MagAnnot.Left', Left);
  MagAnnotDefaults.Persist();
  Tag := 0;

  actAnnot00_SELECTExecute(Sender);
  EditMode := False;
End;

Procedure TMagAnnot.FormCreate(Sender: Tobject);
Begin
  FUserCanEdit := True;
  FEditModeFalseReasonShow := False;
  InitializeVariables();
{$IFDEF HIDENEXTGEN}
    (*
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
    *)
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
  actEditPaste.Visible := False;
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
  Zoom1.Visible := False;
  Fit1.Visible := False;
  Antialiasing1.Visible := False;
  Flip1.Visible := False;
  Copy1.Visible := False;
  Rotate1.Visible := False;
{$ENDIF}
End;

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
  SelectedButtonIsDown(actAnnot05_HOLLOW_RECTANGLE);
  inTBButton := IG_ARTX_MARK_HOLLOW_RECTANGLE;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot25_HIGHLIGHTERExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot25_HIGHLIGHTER);
  inTBButton := IG_ARTX_MARK_HIGHLIGHTER;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot03_LINEExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot03_LINE);
  inTBButton := IG_ARTX_MARK_LINE;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot07_TYPED_TEXTExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot07_TYPED_TEXT);
  inTBButton := IG_ARTX_MARK_TYPED_TEXT;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
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
  SelectedButtonIsDown(actAnnot17_ARROW);
  inTBButton := IG_ARTX_MARK_ARROW;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
End;

Procedure TMagAnnot.actAnnot16_HOLLOW_ELLIPSEExecute(Sender: Tobject);
Var
  inTBButton: Integer;
Begin
  SelectedButtonIsDown(actAnnot16_HOLLOW_ELLIPSE);
  inTBButton := IG_ARTX_MARK_HOLLOW_ELLIPSE;
  IGArtXGUICtl.DefaultInterface.PressTBButton(inTBButton, True);
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
    FAnnotationOptions.Showmodal();
    actAnnot00_SELECTExecute(Sender);
  End;
End;

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

Procedure TMagAnnot.FormShow(Sender: Tobject);
Begin
  FToolbarIsShowing := True;
  Width := btnAnnot60_Options.Left + btnAnnot60_Options.Width + 7;
  Height := pnlAnnots.Height + 53;
End;

Procedure TMagAnnot.actFileExportAnnotationsExecute(Sender: Tobject);
Begin
  SaveDialog.Filter := 'XML files (*.xml)|*.xml|All files (*.*)|*.*|';
  SaveDialog.FilterIndex := 1;
  If (IsValidEnv() And SaveDialog.Execute()) Then
    ArtPage.SaveFile(SaveDialog.Filename, 1, True, IG_ARTX_SAVE_XML);
End;

Procedure TMagAnnot.actFileImportXMLAnnotationsExecute(
  Sender: Tobject);
Begin
  If (IsValidEnv() And OpenDialog.Execute) Then
  Begin
    ArtPage.LoadFile(OpenDialog.Filename, 1, False);
    ArtPage.ApplyToImage(CurrentPage);
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
    Count := ArtPage.MarkCount;
    MarkArray.Resize(Count);

    CurMark := ArtPage.MarkFirst;
    While (Not (CurMark = Nil)) Do
    Begin
      MarkArray.Item[iter] := CurMark;
      CurMark := ArtPage.Marknext(CurMark);
      iter := iter + 1;
    End;
    ArtPage.RemoveMarksArray(MarkArray);
    IGPageViewCtl.UpdateView;
  End;
End;

Procedure TMagAnnot.actEditDeleteFirstExecute(Sender: Tobject);
Var
  CurMark: IIGArtXMark;
Begin
  If (IsValidEnv()) Then
  Begin
    CurMark := ArtPage.MarkFirst;
    If (Not (CurMark = Nil)) Then
    Begin
      ArtPage.MarkRemove(CurMark);
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
    CurMark := ArtPage.MarkFirst;
    While (Not (CurMark = Nil)) Do
    Begin
      PriorMark := CurMark;
      CurMark := ArtPage.Marknext(CurMark);
      If CurMark = Nil Then ArtPage.MarkRemove(PriorMark);
    End;
    IGPageViewCtl.UpdateView;
  End;
End;

Procedure TMagAnnot.actEditUndoEnableExecute(Sender: Tobject);
Begin
  ArtPage.UndoEnabled := Not ArtPage.UndoEnabled;
  actEditUndoEnable.Checked := ArtPage.UndoEnabled;
  If ArtPage.UndoEnabled Then
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
    CurMark := ArtPage.MarkFirst;
    While (Not (CurMark = Nil)) Do
    Begin
      CurMark.Visible := boVisible;
      CurMark := ArtPage.Marknext(CurMark);
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

Function TMagAnnot.IsValidEnv: Boolean;
Begin
  Result := IsValidEnv(CurrentPage);
End;

Function TMagAnnot.IsValidEnv(CurPage: IIGPage): Boolean;
Begin
  Result := False;
  If ArtPage = Nil Then Exit;
  If CurPage = Nil Then Exit;
  If Not CurPage.IsValid Then Exit;
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
    CurMark := ArtPage.MarkFirst;
    While (Not (CurMark = Nil)) Do
    Begin
      PriorMark := CurMark;
      If PriorMark.Type_ = mark Then
      Begin
        PriorRect := PriorMark;
        boFound := True;
      End;
      CurMark := ArtPage.Marknext(CurMark);
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
    CurMark := ArtPage.MarkFirst;
    While (Not (CurMark = Nil)) Do
    Begin
      PriorMark := CurMark;
      If PriorMark.Type_ = mark Then
      Begin
        PriorRect := PriorMark;
      End;
      CurMark := ArtPage.Marknext(CurMark);
      If CurMark = Nil Then
      Begin
        If PriorRect <> Nil Then
        Begin
          ArtPage.MarkRemove(PriorRect);
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
    ArtPage.AddMark(igMark, IG_ARTX_COORD_IMAGE);
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
    ArtPage.AddMark(igMark, IG_ARTX_COORD_IMAGE);
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

Function TMagAnnot.CreateFilledSquare(IGRect: IIGRectangle; FillColor: IIGPixel; bHighlight: WordBool): IIGArtXFilledRectangle;
Var
  igMark: IIGArtXFilledRectangle; //<<<<<<<<<<<
Begin
  Result := Nil;
  Try
    IGRect.Height := igRect.Width;
    igMark := IGArtXCtl.CreateFilledRectangle(IGRect, FillColor, bHighlight); //<<<<<<<<<<<
    ArtPage.AddMark(igMark, IG_ARTX_COORD_IMAGE);
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
  FAnnotationOptions.ColorToRGB(FAnnotationOptions.AnnotFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  igColor.RGB_R := RGB_R;
  igColor.RGB_G := RGB_G;
  igColor.RGB_B := RGB_B;
  DeleteLastFilledRectangle(); //<<<<<<<<<<<
  CreateFilledSquare(IGRect, igColor, FAnnotationOptions.HighlightLine); //<<<<<<<<<<<
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
  inOpacity := FAnnotationOptions.Opacity;
  inLineWidth := FAnnotationOptions.LineWidth;

  //FillColor
  inFillColor := FAnnotationOptions.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := FAnnotationOptions.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
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
    ArtPage.AddMark(igMark, IG_ARTX_COORD_IMAGE);
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
    ArtPage.AddMark(igMark, IG_ARTX_COORD_IMAGE);
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
  inOpacity := FAnnotationOptions.Opacity;
  inLineWidth := FAnnotationOptions.LineWidth;

  //FillColor
  inFillColor := FAnnotationOptions.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := FAnnotationOptions.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
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
    CurMark := ArtPage.MarkFirst;
    While (Not (CurMark = Nil)) Do
    Begin
      PriorMark := CurMark;
      If PriorMark.Type_ = mark Then
      Begin
        PriorRect := PriorMark;
      End;
      CurMark := ArtPage.Marknext(CurMark);
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
  Buttons[0] := btnAnnot00_SELECT;
  Buttons[1] := btnAnnot01_IMAGE_EMBEDDED;
  Buttons[2] := btnAnnot02_IMAGE_REFERENCE;
  Buttons[3] := btnAnnot03_LINE;
  Buttons[4] := btnAnnot04_FREEHAND_LINE;
  Buttons[5] := btnAnnot05_HOLLOW_RECTANGLE;
  Buttons[6] := btnAnnot06_FILLED_RECTANGLE;
  Buttons[7] := btnAnnot07_TYPED_TEXT;
  Buttons[8] := btnAnnot08_TEXT_FROM_FILE;
  Buttons[9] := btnAnnot09_TEXT_STAMP;
  Buttons[10] := btnAnnot10_ATTACH_A_NOTE;
  Buttons[11] := btnAnnot11_FILLED_POLYGON;
  Buttons[12] := btnAnnot12_HOLLOW_POLYGON;
  Buttons[13] := btnAnnot13_POLYLINE;
  Buttons[14] := btnAnnot14_AUDIO;
  Buttons[15] := btnAnnot15_FILLED_ELLIPSE;
  Buttons[16] := btnAnnot16_HOLLOW_ELLIPSE;
  Buttons[17] := btnAnnot17_ARROW;
  Buttons[18] := btnAnnot18_HOTSPOT;
  Buttons[19] := btnAnnot19_REDACTION;
  Buttons[20] := btnAnnot20_ENCRYPTION;
  Buttons[21] := btnAnnot21_RULER;
  Buttons[22] := btnAnnot22_PROTRACTOR;
  Buttons[23] := btnAnnot23_BUTTON;
  Buttons[24] := btnAnnot24_PIN_UP_TEXT;
  Buttons[25] := btnAnnot25_HIGHLIGHTER;
  Buttons[26] := btnAnnot26_RICH_TEXT;
  Buttons[27] := btnAnnot27_CALLOUT;
  Buttons[28] := btnAnnot28_RECTANGLE;
  Buttons[29] := btnAnnot29_ELLIPSE;
  Buttons[30] := btnAnnot30_POLYGON;
  Buttons[31] := btnAnnot31_TEXT;
  Buttons[32] := btnAnnot32_IMAGE;
  Buttons[33] := btnAnnot33_HOLLOW_SQUARE;
  Buttons[34] := btnAnnot34_FILLED_SQUARE;
  Buttons[35] := btnAnnot35_HOLLOW_CIRCLE;
  Buttons[36] := btnAnnot36_FILLED_CIRCLE;
  Buttons[37] := btnAnnot60_Options;
End;

Procedure TMagAnnot.InitButtonAlignLeft;
Var
  i: Integer;
Begin
  For i := 0 To High(Buttons) Do
    Buttons[i].Align := alLeft;
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
  actAnnot21_RULER.Visible := (Annot21_RULER In AdditionalAnnotations);
  actAnnot22_PROTRACTOR.Visible := (Annot22_PROTRACTOR In AdditionalAnnotations);
  actAnnot23_BUTTON.Visible := (Annot23_BUTTON In AdditionalAnnotations);
  actAnnot24_PIN_UP_TEXT.Visible := (Annot24_PIN_UP_TEXT In AdditionalAnnotations);
  actAnnot25_HIGHLIGHTER.Visible := (Annot25_HIGHLIGHTER In AdditionalAnnotations);
  actAnnot26_RICH_TEXT.Visible := (Annot26_RICH_TEXT In AdditionalAnnotations);
  actAnnot27_CALLOUT.Visible := (Annot27_CALLOUT In AdditionalAnnotations);
  actAnnot28_RECTANGLE.Visible := (Annot28_RECTANGLE In AdditionalAnnotations);
  actAnnot29_ELLIPSE.Visible := (Annot29_ELLIPSE In AdditionalAnnotations);
  actAnnot30_POLYGON.Visible := (Annot30_POLYGON In AdditionalAnnotations);
  actAnnot31_TEXT.Visible := (Annot31_TEXT In AdditionalAnnotations);
  actAnnot32_IMAGE.Visible := (Annot32_IMAGE In AdditionalAnnotations);
  actAnnot34_FILLED_SQUARE.Visible := (Annot34_FILLED_SQUARE In AdditionalAnnotations);
  actAnnot36_FILLED_CIRCLE.Visible := (Annot36_FILLED_CIRCLE In AdditionalAnnotations);
  btnAnnot01_IMAGE_EMBEDDED.Visible := (Annot01_IMAGE_EMBEDDED In AdditionalAnnotations);
  btnAnnot02_IMAGE_REFERENCE.Visible := (Annot02_IMAGE_REFERENCE In AdditionalAnnotations);
  btnAnnot06_FILLED_RECTANGLE.Visible := (Annot06_FILLED_RECTANGLE In AdditionalAnnotations);
  btnAnnot08_TEXT_FROM_FILE.Visible := (Annot08_TEXT_FROM_FILE In AdditionalAnnotations);
  btnAnnot09_TEXT_STAMP.Visible := (Annot09_TEXT_STAMP In AdditionalAnnotations);
  btnAnnot10_ATTACH_A_NOTE.Visible := (Annot10_ATTACH_A_NOTE In AdditionalAnnotations);
  btnAnnot11_FILLED_POLYGON.Visible := (Annot11_FILLED_POLYGON In AdditionalAnnotations);
  btnAnnot12_HOLLOW_POLYGON.Visible := (Annot12_HOLLOW_POLYGON In AdditionalAnnotations);
  btnAnnot14_AUDIO.Visible := (Annot14_AUDIO In AdditionalAnnotations);
  btnAnnot15_FILLED_ELLIPSE.Visible := (Annot15_FILLED_ELLIPSE In AdditionalAnnotations);
  btnAnnot18_HOTSPOT.Visible := (Annot18_HOTSPOT In AdditionalAnnotations);
  btnAnnot19_REDACTION.Visible := (Annot19_REDACTION In AdditionalAnnotations);
  btnAnnot20_ENCRYPTION.Visible := (Annot20_ENCRYPTION In AdditionalAnnotations);
  btnAnnot21_RULER.Visible := (Annot21_RULER In AdditionalAnnotations);
  btnAnnot22_PROTRACTOR.Visible := (Annot22_PROTRACTOR In AdditionalAnnotations);
  btnAnnot23_BUTTON.Visible := (Annot23_BUTTON In AdditionalAnnotations);
  btnAnnot24_PIN_UP_TEXT.Visible := (Annot24_PIN_UP_TEXT In AdditionalAnnotations);
  btnAnnot25_HIGHLIGHTER.Visible := (Annot25_HIGHLIGHTER In AdditionalAnnotations);
  btnAnnot26_RICH_TEXT.Visible := (Annot26_RICH_TEXT In AdditionalAnnotations);
  btnAnnot27_CALLOUT.Visible := (Annot27_CALLOUT In AdditionalAnnotations);
  btnAnnot28_RECTANGLE.Visible := (Annot28_RECTANGLE In AdditionalAnnotations);
  btnAnnot29_ELLIPSE.Visible := (Annot29_ELLIPSE In AdditionalAnnotations);
  btnAnnot30_POLYGON.Visible := (Annot30_POLYGON In AdditionalAnnotations);
  btnAnnot31_TEXT.Visible := (Annot31_TEXT In AdditionalAnnotations);
  btnAnnot32_IMAGE.Visible := (Annot32_IMAGE In AdditionalAnnotations);
  btnAnnot34_FILLED_SQUARE.Visible := (Annot34_FILLED_SQUARE In AdditionalAnnotations);
  btnAnnot36_FILLED_CIRCLE.Visible := (Annot36_FILLED_CIRCLE In AdditionalAnnotations);
End;

Procedure TMagAnnot.UpdateButtonEnabling;
Var
  action: TBasicAction;
  boEditMode: Boolean;
  i: Integer;
  MenuItem: TMenuItem;
Begin
  boEditMode := EditMode;
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
  If FIGPageViewCtl <> Value Then FIGPageViewCtl := Value;
  If FIGPageViewCtl <> Nil Then
  Begin
    FIGPageViewCtl.OnMouseDown := IGPageViewCtlMouseDown;
    FIGPageViewCtl.OnMouseMove := IGPageViewCtlMouseMove;
    FIGPageViewCtl.OnMouseUp := IGPageViewCtlMouseUp;
    FIGArtDrawParams.Hwnd := FIGPageViewCtl.Hwnd;
  End;
End;

Procedure TMagAnnot.SetCurrentPageDisp(Const Value: IIGPageDisplay);
Begin
  If FCurrentPageDisp <> Value Then FCurrentPageDisp := Value;
  If FCurrentPageDisp <> Nil Then
  Begin
    FIGArtDrawParams.IGPageDisplay := FCurrentPageDisp;
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

Function TMagAnnot.CreateArtPage: IIGArtXPage;
Begin
  FArtPage := IGArtXCtl.CreatePage;
  IGArtXGUICtl.ArtXPage := FArtPage;
  Result := FArtPage;
End;

Function TMagAnnot.CreateArtPage(CurrentPage_: IIGPage; CurrentPageDisp_: IIGPageDisplay): IIGArtXPage;
Begin
  Result := Nil;
  CurrentPage := CurrentPage_;
  CurrentPageDisp := CurrentPageDisp_;
  If (Not (CurrentPage = Nil) And CurrentPage.IsValid) Then
  Begin
    Result := CreateArtPage;
    FArtPage.Load(CurrentPage, False);
    FArtPage.UndoEnabled := True;
    If CurrentPageDisp <> Nil Then
    Begin
      CurrentPageDisp.AntiAliasing.Method := IG_DSPL_ANTIALIAS_NONE;
      FArtPage.AssociatePageDisplay(CurrentPageDisp);
    End;
    Result := FArtPage;
  End;
End;

Procedure TMagAnnot.FIGArtXCtlCreateMarkNotify(ASender: Tobject;
  Const Params: IIGArtXCreateMarkEventParams);
Begin
  Case Params.Mark.Type_ Of
  //IG_ARTX_MARK_SELECT           :ShowMessage('SELECT          ');
  //IG_ARTX_MARK_IMAGE_EMBEDDED   :ShowMessage('IMAGE_EMBEDDED  ');
  //IG_ARTX_MARK_IMAGE_REFERENCE  :ShowMessage('IMAGE_REFERENCE ');
  //IG_ARTX_MARK_LINE             :PreCreateMarkLineToDefaults(Params.Mark As IIGArtXLine);
  //IG_ARTX_MARK_FREEHAND_LINE    :PreCreateMarkFreehandLineToDefaults(Params.Mark As IIGArtXFreeline);
  //IG_ARTX_MARK_HOLLOW_RECTANGLE :PreCreateMarkHollowRectangleToDefaults(Params.Mark As IIGArtXHollowRectangle);
  //IG_ARTX_MARK_FILLED_RECTANGLE :ShowMessage('FILLED_RECTANGLE');
  //IG_ARTX_MARK_TYPED_TEXT       :ShowMessage('TYPED_TEXT      ');
  //IG_ARTX_MARK_TEXT_FROM_FILE   :ShowMessage('TEXT_FROM_FILE  ');
  //IG_ARTX_MARK_TEXT_STAMP       :ShowMessage('TEXT_STAMP      ');
  //IG_ARTX_MARK_ATTACH_A_NOTE    :ShowMessage('ATTACH_A_NOTE   ');
  //IG_ARTX_MARK_FILLED_POLYGON   :ShowMessage('FILLED_POLYGON  ');
  //IG_ARTX_MARK_HOLLOW_POLYGON   :ShowMessage('HOLLOW_POLYGON  ');
  //IG_ARTX_MARK_POLYLINE         :PreCreateMarkPolylineToDefaults(Params.Mark As IIGArtXPolyline);
  //IG_ARTX_MARK_AUDIO            :ShowMessage('AUDIO           ');
  //IG_ARTX_MARK_FILLED_ELLIPSE   :ShowMessage('FILLED_ELLIPSE  ');
  //IG_ARTX_MARK_HOLLOW_ELLIPSE   :PreCreateMarkHollowEllipseToDefaults(Params.Mark As IIGArtXHollowEllipse);
  //IG_ARTX_MARK_ARROW            :PreCreateMarkArrowToDefaults(Params.Mark As IIGArtXArrow);
  //IG_ARTX_MARK_HOTSPOT          :ShowMessage('HOTSPOT         ');
  //IG_ARTX_MARK_REDACTION        :ShowMessage('REDACTION       ');
  //IG_ARTX_MARK_ENCRYPTION       :ShowMessage('ENCRYPTION      ');
  //IG_ARTX_MARK_RULER            :PreCreateMarkRulerToDefaults(Params.Mark As IIGArtXRuler);
  //IG_ARTX_MARK_PROTRACTOR       :PreCreateMarkProtractorToDefaults(Params.Mark As IIGArtXProtractor);
  //IG_ARTX_MARK_BUTTON           :ShowMessage('BUTTON          ');
  //IG_ARTX_MARK_PIN_UP_TEXT      :ShowMessage('PIN_UP_TEXT     ');
  //IG_ARTX_MARK_HIGHLIGHTER      :ShowMessage('HIGHLIGHTER     ');
  //IG_ARTX_MARK_RICH_TEXT        :PreCreateMarkRichTextToDefaults(Params.Mark As IIGArtXRichText);
  //IG_ARTX_MARK_CALLOUT          :ShowMessage('CALLOUT         ');
    IG_ARTX_MARK_RECTANGLE: CreateMarkRectangleToDefaults(Params.Mark As IIGArtXRectangle);
    IG_ARTX_MARK_ELLIPSE: CreateMarkEllipseToDefaults(Params.Mark As IIGArtXEllipse);
  //IG_ARTX_MARK_POLYGON          :ShowMessage('POLYGON         ');
  //IG_ARTX_MARK_TEXT             :ShowMessage('TEXT            ');
  //IG_ARTX_MARK_IMAGE            :ShowMessage('IMAGE           ');
  End;
End;

Procedure TMagAnnot.FIGArtXCtlDeleteMarkNotify(ASender: Tobject;
  Const Params: IIGArtXDeleteMarkEventParams);
Begin
  //Caption:='Delete Mark';
End;

Procedure TMagAnnot.FIGArtXCtlModifyMarkNotify(ASender: Tobject;
  Const Params: IIGArtXModifyMarkEventParams);
Begin
  //Caption:='Modify Mark';
End;

Procedure TMagAnnot.FIGArtXCtlPreCreateMarkNotify(ASender: Tobject;
  Const Params: IIGArtXPreCreateMarkEventParams);
Begin
  Case Params.Mark.Type_ Of
    IG_ARTX_MARK_SELECT: Showmessage('SELECT          ');
    IG_ARTX_MARK_IMAGE_EMBEDDED: Showmessage('IMAGE_EMBEDDED  ');
    IG_ARTX_MARK_IMAGE_REFERENCE: Showmessage('IMAGE_REFERENCE ');
    IG_ARTX_MARK_LINE: PreCreateMarkLineToDefaults(Params.Mark As IIGArtXLine);
    IG_ARTX_MARK_FREEHAND_LINE: PreCreateMarkFreehandLineToDefaults(Params.Mark As IIGArtXFreeline);
    IG_ARTX_MARK_HOLLOW_RECTANGLE: PreCreateMarkHollowRectangleToDefaults(Params.Mark As IIGArtXHollowRectangle);
    IG_ARTX_MARK_FILLED_RECTANGLE: Showmessage('FILLED_RECTANGLE');
    IG_ARTX_MARK_TYPED_TEXT: PreCreateMarkTextTypedToDefaults(Params.Mark As IIGArtXTextTyped);
    IG_ARTX_MARK_TEXT_FROM_FILE: Showmessage('TEXT_FROM_FILE  ');
    IG_ARTX_MARK_TEXT_STAMP: Showmessage('TEXT_STAMP      ');
    IG_ARTX_MARK_ATTACH_A_NOTE: Showmessage('ATTACH_A_NOTE   ');
    IG_ARTX_MARK_FILLED_POLYGON: Showmessage('FILLED_POLYGON  ');
    IG_ARTX_MARK_HOLLOW_POLYGON: Showmessage('HOLLOW_POLYGON  ');
    IG_ARTX_MARK_POLYLINE: PreCreateMarkPolylineToDefaults(Params.Mark As IIGArtXPolyline);
    IG_ARTX_MARK_AUDIO: Showmessage('AUDIO           ');
    IG_ARTX_MARK_FILLED_ELLIPSE: Showmessage('FILLED_ELLIPSE  ');
    IG_ARTX_MARK_HOLLOW_ELLIPSE: PreCreateMarkHollowEllipseToDefaults(Params.Mark As IIGArtXHollowEllipse);
    IG_ARTX_MARK_ARROW: PreCreateMarkArrowToDefaults(Params.Mark As IIGArtXArrow);
    IG_ARTX_MARK_HOTSPOT: Showmessage('HOTSPOT         ');
    IG_ARTX_MARK_REDACTION: Showmessage('REDACTION       ');
    IG_ARTX_MARK_ENCRYPTION: Showmessage('ENCRYPTION      ');
    IG_ARTX_MARK_RULER: PreCreateMarkRulerToDefaults(Params.Mark As IIGArtXRuler);
    IG_ARTX_MARK_PROTRACTOR: PreCreateMarkProtractorToDefaults(Params.Mark As IIGArtXProtractor);
    IG_ARTX_MARK_BUTTON: Showmessage('BUTTON          ');
    IG_ARTX_MARK_PIN_UP_TEXT: Showmessage('PIN_UP_TEXT     ');
    IG_ARTX_MARK_HIGHLIGHTER: Showmessage('HIGHLIGHTER     ');
    IG_ARTX_MARK_RICH_TEXT: PreCreateMarkRichTextToDefaults(Params.Mark As IIGArtXRichText);
    IG_ARTX_MARK_CALLOUT: Showmessage('CALLOUT         ');
    IG_ARTX_MARK_RECTANGLE: PreCreateMarkRectangleToDefaults(Params.Mark As IIGArtXRectangle);
    IG_ARTX_MARK_ELLIPSE: PreCreateMarkEllipseToDefaults(Params.Mark As IIGArtXEllipse);
    IG_ARTX_MARK_POLYGON: Showmessage('POLYGON         ');
    IG_ARTX_MARK_TEXT: Showmessage('TEXT            ');
    IG_ARTX_MARK_IMAGE: Showmessage('IMAGE           ');
  End;
End;

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
  inOpacity := FAnnotationOptions.Opacity;
  inLineWidth := FAnnotationOptions.LineWidth;
  //FillColor
  inFillColor := FAnnotationOptions.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := FAnnotationOptions.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
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
  inBorderColor: Integer;
  inFillColor: Integer;
  inLineWidth: Integer;
  inOpacity: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
Begin
  If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then Exit;
  If IGMark = Nil Then Exit;
  inOpacity := FAnnotationOptions.Opacity;
  inLineWidth := FAnnotationOptions.LineWidth;
  //FillColor
  inFillColor := FAnnotationOptions.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := FAnnotationOptions.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
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
  inOpacity := FAnnotationOptions.Opacity;
  inLineWidth := FAnnotationOptions.LineWidth;
  //FillColor
  inFillColor := FAnnotationOptions.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := FAnnotationOptions.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
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
  If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then Exit;
  //If Button <> 2 Then Exit;
  //IGMark := GetLastPolyline();
  If IGMark = Nil Then Exit;
  inOpacity := FAnnotationOptions.Opacity;
  inLineWidth := FAnnotationOptions.LineWidth;
  //FillColor
  inFillColor := FAnnotationOptions.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := FAnnotationOptions.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
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
  inLineWidth := FAnnotationOptions.LineWidth;
  //FillColor
  inFillColor := FAnnotationOptions.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := FAnnotationOptions.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;

  IGMark.SetBorder(IGBorder);
  IGMark.Set_Highlight(FAnnotationOptions.HighlightLine);
  IGPageViewCtl.UpdateView;
  actAnnot00_SELECTExecute(Nil);
End;

Procedure TMagAnnot.PreCreateMarkFreehandLineToDefaults(IGMark: IIGArtXFreeline);
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
  inLineWidth := FAnnotationOptions.LineWidth;
  //FillColor
  inFillColor := FAnnotationOptions.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := FAnnotationOptions.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;

  IGMark.SetBorder(IGBorder);
  IGMark.Set_Highlight(FAnnotationOptions.HighlightLine);
  IGPageViewCtl.UpdateView;
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
  inLineWidth := FAnnotationOptions.LineWidth;
  //FillColor
  inFillColor := FAnnotationOptions.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := FAnnotationOptions.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
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
  inLineWidth := FAnnotationOptions.LineWidth;
  //FillColor
  inFillColor := FAnnotationOptions.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := FAnnotationOptions.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;

  //ArrowHead
  SetArrowHead(IGMark);

  IGMark.SetBorder(IGBorder);
  IGPageViewCtl.UpdateView;
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
  inLineWidth := FAnnotationOptions.LineWidth;
  //FillColor
  inFillColor := FAnnotationOptions.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := FAnnotationOptions.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;

  IGMark.SetBorder(IGBorder);
  IGMark.Set_Highlight(FAnnotationOptions.HighlightLine);
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
  inLineWidth := FAnnotationOptions.LineWidth;
  //FillColor
  inFillColor := FAnnotationOptions.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := FAnnotationOptions.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;

  IGMark.SetBorder(IGBorder);
  IGMark.Set_Highlight(FAnnotationOptions.HighlightLine);
  IGPageViewCtl.UpdateView;
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
  inLineWidth := FAnnotationOptions.LineWidth;
  //FillColor
  inFillColor := FAnnotationOptions.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := FAnnotationOptions.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;

  IGMark.SetBorder(IGBorder);
  IGMark.Set_Highlight(FAnnotationOptions.HighlightLine);
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
  inLineWidth := FAnnotationOptions.LineWidth;
  //FillColor
  inFillColor := FAnnotationOptions.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := FAnnotationOptions.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;

  IGMark.SetBorder(IGBorder);
  IGMark.Set_Highlight(FAnnotationOptions.HighlightLine);
  IGPageViewCtl.UpdateView;
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
  inOpacity := FAnnotationOptions.Opacity;
  inLineWidth := FAnnotationOptions.LineWidth;

  //FillColor
  inFillColor := FAnnotationOptions.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := FAnnotationOptions.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
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
  IGFillColor: IGPixel;
  IGFont: IGArtXFont;
  inBorderColor: Integer;
  inFillColor: Integer;
  inLineWidth: Integer;
  inOpacity: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
Begin
  If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then Exit;
  If IGMark = Nil Then Exit;
  inOpacity := FAnnotationOptions.Opacity;
  inLineWidth := FAnnotationOptions.LineWidth;

  //Font
  IGFont := IGMark.GetFont;
  SetFontToDefaults(IGFont);
  IGMark.SetFont(IGFont);

  //FillColor
  inFillColor := FAnnotationOptions.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := FAnnotationOptions.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
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
  inOpacity := FAnnotationOptions.Opacity;
  inLineWidth := FAnnotationOptions.LineWidth;
  sgRulerLabel := FAnnotationOptions.RulerLabel;
  //FillColor
  inFillColor := FAnnotationOptions.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := FAnnotationOptions.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
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
  inOpacity := FAnnotationOptions.Opacity;

  //BorderColor
  inBorderColor := FAnnotationOptions.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
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

  IGPageViewCtl.UpdateView;
End;

Procedure TMagAnnot.PreCreateMarkRectangleToDefaults(IGMark: IIGArtXRectangle);
Var
  IGBorder: IGArtXBorder;
  IGBorderColor: IGPixel;
  inBorderColor: Integer;
  inLineWidth: Integer;
  inOpacity: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
Begin
  If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then Exit;
  If IGMark = Nil Then Exit;
  inOpacity := FAnnotationOptions.Opacity;
  inLineWidth := FAnnotationOptions.LineWidth;

  //BorderColor
  inBorderColor := FAnnotationOptions.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;

  IGMark.SetBorder(IGBorder);
  IGMark.Opacity := inOpacity;
  IGMark.SetFillColor(Nil);
  IGPageViewCtl.UpdateView;
End;

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
Var
  IGBorder: IGArtXBorder;
  IGBorderColor: IGPixel;
  inBorderColor: Integer;
  inLineWidth: Integer;
  inOpacity: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
Begin
  If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_EDIT Then Exit;
  If IGMark = Nil Then Exit;
  inOpacity := FAnnotationOptions.Opacity;
  inLineWidth := FAnnotationOptions.LineWidth;

  //BorderColor
  inBorderColor := FAnnotationOptions.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  //Border
  IGBorder := IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER) As IIGArtxBorder;
  IGBorder.SetColor(IGBorderColor As IIGPixel);
  IGBorder.Width := inLineWidth;

  IGMark.SetFillColor(Nil);
  IGMark.SetBorder(IGBorder);
  IGMark.Opacity := inOpacity;
  IGPageViewCtl.UpdateView;
End;

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
  inTextColor := FAnnotationOptions.FontColor;
  IGTextColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGTextColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inTextColor, RGB_R, RGB_G, RGB_B);
  IGTextColor.RGB_R := RGB_R;
  IGTextColor.RGB_G := RGB_G;
  IGTextColor.RGB_B := RGB_B;

  IGFont := IGMark.GetFont;
  SetFontToDefaults(IGFont);
  IGMark.SetFont(IGFont);
  IGMark.SetTextColor(IGTextColor);
  IGPageViewCtl.UpdateView;
End;

Procedure TMagAnnot.SetFontToDefaults(Var IGFont: IGArtXFont);
Begin
  //Font
  If IGFont = Nil Then Exit;
  IGFont.Size := FAnnotationOptions.FontSize;
  IGFont.Name := FAnnotationOptions.FontName;
  IGFont.Style := IG_ARTX_FONT_REGULAR;
  If FAnnotationOptions.Fontbold Then IGFont.Style := IGFont.Style + IG_ARTX_FONT_BOLD;
  If FAnnotationOptions.FontItalic Then IGFont.Style := IGFont.Style + IG_ARTX_FONT_ITALIC;
  If FAnnotationOptions.FontUnderline Then IGFont.Style := IGFont.Style + IG_ARTX_FONT_UNDERLINE;
  If FAnnotationOptions.FontStrikeOut Then IGFont.Style := IGFont.Style + IG_ARTX_FONT_STRIKEOUT;
End;

Procedure TMagAnnot.PreCreateMarkRulerToDefaults(IGMark: IIGArtXRuler);
Var
  IGBorder: IGArtXBorder;
  IGBorderColor: IGPixel;
  IGFillColor: IGPixel;
  IGFont: IGArtXFont;
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
  If IGMark = Nil Then Exit;
  inOpacity := FAnnotationOptions.Opacity;
  inLineWidth := FAnnotationOptions.LineWidth;
  sgRulerLabel := FAnnotationOptions.RulerLabel;

  //Font
  IGFont := IGMark.GetFont;
  SetFontToDefaults(IGFont);
  IGMark.SetFont(IGFont);

  //FillColor
  inFillColor := FAnnotationOptions.AnnotFillColor;
  IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGFillColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inFillColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGFillColor.RGB_R := RGB_R;
  IGFillColor.RGB_G := RGB_G;
  IGFillColor.RGB_B := RGB_B;

  //BorderColor
  inBorderColor := FAnnotationOptions.AnnotBorderColor;
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  FAnnotationOptions.ColorToRGB(inBorderColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
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
End;

Procedure TMagAnnot.InitializeVariables;
Begin
  FToolbarIsShowing := Self.Showing;
  If FAnnotationOptions = Nil Then FAnnotationOptions := TfrmAnnotOptions.Create(Nil);
  FAnnotationStyle := TMagAnnotationStyle.Create();
  FPageCount := 0;
  FHasBeenModified := False;
  EditMode := True;
  FProtractorState := -1;
  //FAdditionalAnnotations := [Annot21_RULER, Annot22_PROTRACTOR];
  FAdditionalAnnotations := [Annot21_RULER];
  (*
  [
  Annot01_IMAGE_EMBEDDED,
  Annot06_FILLED_RECTANGLE,
  Annot08_TEXT_FROM_FILE,
  Annot09_TEXT_STAMP,
  Annot11_FILLED_POLYGON,
  Annot12_HOLLOW_POLYGON,
  Annot15_FILLED_ELLIPSE,
  Annot19_REDACTION,
  Annot21_RULER,
  Annot22_PROTRACTOR,
  Annot24_PIN_UP_TEXT,
  Annot25_HIGHLIGHTER,
  Annot34_FILLED_SQUARE,
  Annot36_FILLED_CIRCLE
  ];
  *)

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

  //SetIGPageViewCtl(FIGPageViewCtl_);
  //SetIGPageViewCtl(TIGPageViewCtl.Create(Self));
  //CreatePage();

End;

Procedure TMagAnnot.actEditUnSelectAllExecute(Sender: Tobject);
Var
  CurMark: IIGArtXMark;
Begin
  If IsValidEnv(CurrentPage) Then
  Begin
    CurMark := ArtPage.MarkFirst;
    While (Not (CurMark = Nil)) Do
    Begin
      ArtPage.MarkSelect(CurMark, False);
      CurMark := ArtPage.Marknext(CurMark);
    End;
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
    ArtPage.GroupGet('RADCODE'); //ArtPage.GlobalAttrGroup := 'RADCODE';
    //ArtPage.GlobalAttrMeasurementUnits := UnitCentimeters;// Not supported in ARTX
    IGRect.Left := Left;
    IGRect.Right := Right;
    IGRect.Top := Top;
    IGRect.Bottom := Bottom;

    //TextColor
    inTextColor := FAnnotationOptions.RGBToColor(Red, Green, Blue);
    IGTextColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
    IGTextColor.ChangeType(IG_PIXEL_RGB);
    FAnnotationOptions.ColorToRGB(inTextColor, RGB_R, RGB_G, RGB_B);
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

    ArtPage.AddMark(igMark, IG_ARTX_COORD_IMAGE);
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
  If TheFontSize > 0 Then FAnnotationOptions.FontSize := TheFontSize;
  If Trim(TheFontName) <> '' Then FAnnotationOptions.FontName := TheFontName;
  FAnnotationOptions.Fontbold := IsBold;
  FAnnotationOptions.FontItalic := IsItalic;
End;

Procedure TMagAnnot.RemoveOrientationLabel();
Var
  GroupName: WideString;
  LabelGroup: IIGArtXGroup;
Begin
  If ArtPage = Nil Then Exit;
  GroupName := 'RADCODE';
  LabelGroup := ArtPage.GroupGet(GroupName);
  If LabelGroup = Nil Then Exit;
  ArtPage.GroupDelete(LabelGroup);
End;

Procedure TMagAnnot.Initialize(CurPoint: IIGPoint; CurPage: IIGPage;
  CurPageDisp: IIGPageDisplay; PageViewHwnd: Integer;
  ForDiagramAnnotation: Boolean);
Begin
  IgCurPoint := CurPoint;
  If ArtPage <> Nil Then ArtPage := Nil;
  ArtPage := IGArtXCtl.CreatePage;
  Self.PageViewHwnd := PageViewHwnd;
  CurrentPageDisp := CurPageDisp;
  CurrentPage := CurPage;
End;

Procedure TMagAnnot.SetPageCount(Const Value: Integer);
Begin
  FPageCount := Value;
End;

Function TMagAnnot.GetPageCount: Integer;
Begin
  Result := FPageCount;
End;

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
Begin
  Result := 0;
  If Not IsValidEnv() Then Exit;
  Result := ArtPage.MarkCount;
End;

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
  btnAnnot00_SELECT.flat := actAnnot00_SELECT.Checked;
  btnAnnot01_IMAGE_EMBEDDED.flat := actAnnot01_IMAGE_EMBEDDED.Checked;
  btnAnnot02_IMAGE_REFERENCE.flat := actAnnot02_IMAGE_REFERENCE.Checked;
  btnAnnot03_LINE.flat := actAnnot03_LINE.Checked;
  btnAnnot04_FREEHAND_LINE.flat := actAnnot04_FREEHAND_LINE.Checked;
  btnAnnot05_HOLLOW_RECTANGLE.flat := actAnnot05_HOLLOW_RECTANGLE.Checked;
  btnAnnot06_FILLED_RECTANGLE.flat := actAnnot06_FILLED_RECTANGLE.Checked;
  btnAnnot07_TYPED_TEXT.flat := actAnnot07_TYPED_TEXT.Checked;
  btnAnnot08_TEXT_FROM_FILE.flat := actAnnot08_TEXT_FROM_FILE.Checked;
  btnAnnot09_TEXT_STAMP.flat := actAnnot09_TEXT_STAMP.Checked;
  btnAnnot10_ATTACH_A_NOTE.flat := actAnnot10_ATTACH_A_NOTE.Checked;
  btnAnnot11_FILLED_POLYGON.flat := actAnnot11_FILLED_POLYGON.Checked;
  btnAnnot12_HOLLOW_POLYGON.flat := actAnnot12_HOLLOW_POLYGON.Checked;
  btnAnnot13_POLYLINE.flat := actAnnot13_POLYLINE.Checked;
  btnAnnot14_AUDIO.flat := actAnnot14_AUDIO.Checked;
  btnAnnot15_FILLED_ELLIPSE.flat := actAnnot15_FILLED_ELLIPSE.Checked;
  btnAnnot16_HOLLOW_ELLIPSE.flat := actAnnot16_HOLLOW_ELLIPSE.Checked;
  btnAnnot17_ARROW.flat := actAnnot17_ARROW.Checked;
  btnAnnot18_HOTSPOT.flat := actAnnot18_HOTSPOT.Checked;
  btnAnnot19_REDACTION.flat := actAnnot19_REDACTION.Checked;
  btnAnnot20_ENCRYPTION.flat := actAnnot20_ENCRYPTION.Checked;
  btnAnnot21_RULER.flat := actAnnot21_RULER.Checked;
  btnAnnot22_PROTRACTOR.flat := actAnnot22_PROTRACTOR.Checked;
  btnAnnot23_BUTTON.flat := actAnnot23_BUTTON.Checked;
  btnAnnot24_PIN_UP_TEXT.flat := actAnnot24_PIN_UP_TEXT.Checked;
  btnAnnot25_HIGHLIGHTER.flat := actAnnot25_HIGHLIGHTER.Checked;
  btnAnnot26_RICH_TEXT.flat := actAnnot26_RICH_TEXT.Checked;
  btnAnnot27_CALLOUT.flat := actAnnot27_CALLOUT.Checked;
  btnAnnot28_RECTANGLE.flat := actAnnot28_RECTANGLE.Checked;
  btnAnnot29_ELLIPSE.flat := actAnnot29_ELLIPSE.Checked;
  btnAnnot30_POLYGON.flat := actAnnot30_POLYGON.Checked;
  btnAnnot31_TEXT.flat := actAnnot31_TEXT.Checked;
  btnAnnot32_IMAGE.flat := actAnnot32_IMAGE.Checked;
  btnAnnot33_HOLLOW_SQUARE.flat := actAnnot33_HOLLOW_SQUARE.Checked;
  btnAnnot34_FILLED_SQUARE.flat := actAnnot34_FILLED_SQUARE.Checked;
  btnAnnot35_HOLLOW_CIRCLE.flat := actAnnot35_HOLLOW_CIRCLE.Checked;
  btnAnnot36_FILLED_CIRCLE.flat := actAnnot36_FILLED_CIRCLE.Checked;
  btnAnnot60_Options.flat := actAnnot60_Options.Checked;

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
  If Not IsValidEnv() Then Exit;
  If Not ArtPage.UndoEnabled Then Exit;
  If ArtPage.UndoCount = 0 Then Exit;
  ArtPage.UndoRollBack();
  IGPageViewCtl.UpdateView();
  Result := True;
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
  If Not IsValidEnv() Then Exit;
  If ArtPage.MarkCount = 0 Then Exit;

  Count := 0;
  iter := 0;
  MarkArray := IGArtXCtl.CreateObject(IG_ARTX_OBJ_MARK_ARRAY) As IIGArtXMarkArray;
  CurMark := ArtPage.MarkSelectedFirst;
  If CurMark = Nil Then Exit;
  While (Not (CurMark = Nil)) Do
  Begin
    CurMark := ArtPage.MarkSelectedNext(CurMark);
    Count := Count + 1;
  End;
  MarkArray.Resize(Count);

  CurMark := ArtPage.MarkSelectedFirst;
  While (Not (CurMark = Nil)) Do
  Begin
    MarkArray.Item[iter] := CurMark;
    CurMark := ArtPage.MarkSelectedNext(CurMark);
    iter := iter + 1;
  End;
  boProcessed := True;
  Case action Of
    AnnotCopyAll: ArtPage.CopyMarksArray(MarkArray);
    AnnotCopyFirst: ArtPage.MarkCopy(MarkArray.Item[0]);
    AnnotCopyLast: ArtPage.MarkCopy(MarkArray.Item[MarkArray.Size - 1]);
    AnnotCutAll: ArtPage.CutMarksArray(MarkArray);
    AnnotCutFirst: ArtPage.MarkCut(MarkArray.Item[0]);
    AnnotCutLast: ArtPage.MarkCut(MarkArray.Item[MarkArray.Size - 1]);
    AnnotDeleteAll: ArtPage.RemoveMarksArray(MarkArray);
    AnnotDeleteFirst: ArtPage.MarkRemove(MarkArray.Item[0]);
    AnnotDeleteLast: ArtPage.MarkRemove(MarkArray.Item[MarkArray.Size - 1]);
  Else
    boProcessed := False;
  End;
  IGPageViewCtl.UpdateView;
  Result := boProcessed;
End;

Function TMagAnnot.Cut(): Boolean;
Begin
  Result := ClipboardAction(AnnotCutAll);
End;

Procedure TMagAnnot.actEditCutSelectedAllExecute(Sender: Tobject);
Begin
  Cut();
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
  If Not IsValidEnv() Then Exit;
  If ArtPage.PasteCount = 0 Then Exit;
  ArtPage.PasteMarks();
  Result := True;
End;

Procedure TMagAnnot.actEditSelectAllExecute(Sender: Tobject);
Begin
  SelectAll();
End;

Function TMagAnnot.SelectAll: Boolean;
Var
  CurMark: IIGArtXMark;
Begin
  Result := False;
  If Not IsValidEnv() Then Exit;
  CurMark := ArtPage.MarkFirst;
  While (Not (CurMark = Nil)) Do
  Begin
    Result := True;
    ArtPage.MarkSelect(CurMark, True);
    CurMark := ArtPage.Marknext(CurMark);
  End;
  IGPageViewCtl.UpdateView;
End;

Procedure TMagAnnot.SetArrowPointer(aPointer: TMagAnnotationArrowType);
Begin
  Case aPointer Of
    MagAnnArrowPointer: FAnnotationOptions.ArrowPointerStyle := 0;
    MagAnnArrowSolid: FAnnotationOptions.ArrowPointerStyle := 1;
    MagAnnArrowOpen: FAnnotationOptions.ArrowPointerStyle := 2;
    MagAnnArrowPointerSolid: FAnnotationOptions.ArrowPointerStyle := 3;
    MagAnnArrowNone: FAnnotationOptions.ArrowPointerStyle := 4;
  End;
End;

Procedure TMagAnnot.SetArrowLength(ArrowLength: TMagAnnotationArrowSize);
Begin
  Case ArrowLength Of
    MagAnnArrowSizeSmall: FAnnotationOptions.ArrowPointerLength := 20;
    MagAnnArrowSizeMedium: FAnnotationOptions.ArrowPointerLength := 40;
    MagAnnArrowSizeLarge: FAnnotationOptions.ArrowPointerLength := 60;
  End;
End;

Procedure TMagAnnot.SetOpaque(IsOpaque: Boolean);
Begin
  If FAnnotationOptions.Opacity <> 255 Then
  Begin
    If IsOpaque Then FAnnotationOptions.Opacity := 255;
  End
  Else
  Begin
    If Not IsOpaque Then FAnnotationOptions.Opacity := 128;
  End;
End;

Procedure TMagAnnot.SetLineWidth(Width: TMagAnnotationLineWidth);
Begin
  Case Width Of
    MagAnnLineWidthThin: FAnnotationOptions.LineWidth := 2;
    MagAnnLineWidthMedium: FAnnotationOptions.LineWidth := 5;
    MagAnnLineWidthThick: FAnnotationOptions.LineWidth := 10;
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
  aFont.Size := FAnnotationOptions.FontSize;
  aFont.Name := FAnnotationOptions.FontName;
  If FAnnotationOptions.Fontbold And FAnnotationOptions.FontItalic Then
  Begin
    aFont.Style := [Fsbold, Fsitalic];
  End
  Else
    If FAnnotationOptions.Fontbold And (Not FAnnotationOptions.FontItalic) Then
    Begin
      aFont.Style := [Fsbold];
    End
    Else
      If (Not FAnnotationOptions.Fontbold) And FAnnotationOptions.FontItalic Then
      Begin
        aFont.Style := [Fsitalic];
      End;
  aFont.Color := FAnnotationOptions.FontColor;
  Result := aFont;
End;

Function TMagAnnot.GetColor: TColor;
Begin
  Result := FAnnotationOptions.AnnotBorderColor;
End;

Procedure TMagAnnot.SetAnnotationColor(aColor: TColor);
Begin
  FAnnotationOptions.AnnotBorderColor := aColor;
End;

Procedure TMagAnnot.DisplayCurrentMarkProperties;
Begin
  //Not supported
End;

Procedure TMagAnnot.SetArrowHead(IGMark: IIGArtXArrow);
Var
  IGArrowHead: IIGArtXArrowHead;
Begin
  If FAnnotationOptions.ArrowPointerLength < 5 Then FAnnotationOptions.ArrowPointerLength := 5;
  If FAnnotationOptions.ArrowPointerLength > 200 Then FAnnotationOptions.ArrowPointerLength := 200;
  If FAnnotationOptions.ArrowPointerAngle < 5 Then FAnnotationOptions.ArrowPointerAngle := 5;
  If FAnnotationOptions.ArrowPointerAngle > 60 Then FAnnotationOptions.ArrowPointerAngle := 60;
  IGArrowHead := IGArtXCtl.CreateObject(IG_ARTX_OBJ_ARROWHEAD) As IIGArtXArrowHead;
  IGArrowHead.Style := FAnnotationOptions.ArrowPointerStyle;
  IGArrowHead.Length := FAnnotationOptions.ArrowPointerLength;
  IGArrowHead.Angle := FAnnotationOptions.ArrowPointerAngle;
  IGMark.SetHead(IGArrowHead);
End;

Procedure TMagAnnot.IGPageViewCtlMouseDown(ASender: Tobject; Button, Shift: Smallint; x, y: Integer);
Var
  nMessage: Integer;
Begin
  IgCurPoint.XPos := x;
  IgCurPoint.YPos := y;
  nMessage := WM_LBUTTONDOWN;
  If (Button = 2) Then
    nMessage := WM_RBUTTONDOWN;
  IGArtXGUICtl.MouseDown(IGArtDrawParams, nMessage, IgCurPoint);
End;

Procedure TMagAnnot.IGPageViewCtlMouseMove(ASender: Tobject; Button, Shift: Smallint; x, y: Integer);
Var
  boRun: Boolean;
Begin
  boRun := False;
  If IgCurPoint = Nil Then boRun := True;
  If Not boRun Then
  Begin
    If IgCurPoint.XPos <> x Then
      boRun := True
    Else
      If IgCurPoint.YPos <> y Then boRun := True;
  End;

  If boRun Then
  Begin
    IgCurPoint.XPos := x;
    IgCurPoint.YPos := y;
    IGArtXGUICtl.MouseMove(IGArtDrawParams, WM_MOUSEMOVE, IgCurPoint);
  End;
End;

Procedure TMagAnnot.IGPageViewCtlMouseUp(ASender: Tobject; Button, Shift: Smallint; x, y: Integer);
Var
  nMessage: Integer;
Begin
  IgCurPoint.XPos := x;
  IgCurPoint.YPos := y;
  nMessage := WM_LBUTTONUP;
  If (Button = 2) Then
    nMessage := WM_RBUTTONUP;
  IGArtXGUICtl.MouseUp(IGArtDrawParams, nMessage, IgCurPoint);
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

    IGProcessingCtrl.Flip(CurrentPage, IG_FLIP_HORIZONTAL);
    ArtPage.FlipMarks(IG_FLIP_VERTICAL, ImageRect, DeviceRect);
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

    IGProcessingCtrl.Flip(CurrentPage, IG_FLIP_VERTICAL);
    ArtPage.FlipMarks(IG_FLIP_VERTICAL, ImageRect, DeviceRect);
    IGPageViewCtl.UpdateView;
  End;
End;

Procedure TMagAnnot.RotateImage(Value: enumIGRotationValues);
Var
  DeviceRect: IGRectangle;
  ImageRect: IGRectangle;
Begin
  If Not IsValidEnv(CurrentPage) Then Exit;
  Case Value Of
    IG_ROTATE_90: ;
    IG_ROTATE_180: ;
    IG_ROTATE_270: ;
  Else
    Exit;
  End;
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
  IGProcessingCtrl.Rotate90k(CurrentPage, Value);
  ArtPage.RotateMarks(Value, ImageRect, DeviceRect);
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

Function TMagAnnot.GetIGPageViewCtl(Parent: TWinControl): TIGPageViewCtl;
Begin
  FIGPageViewCtl_.Parent := Parent;
  FIGPageViewCtl_.Align := alClient;
  SetIGPageViewCtl(FIGPageViewCtl_);
  IGPageViewCtl.UpdateView();
  CreatePage();
  Result := FIGPageViewCtl;
End;

Function TMagAnnot.GetAnnotationOptions: TfrmAnnotOptions;
Begin
  Result := FAnnotationOptions;
End;

Procedure TMagAnnot.FormDestroy(Sender: Tobject);
Begin
  FToolbarIsShowing := False;
  FreeAndNil(FAnnotationOptions);
End;

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
  CreateArtPage(CurrentPage, CurrentPageDisp);
  IGPageViewCtl.UpdateView;
End;

Function TMagAnnot.LoadFile(): String;
Var
  Filename: String;
Begin
  Filename := '';
  Result := LoadFile(Filename);
End;

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
          Self.Show();
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
    End;
  End;
  If FEditModeFalseReasonShow Then
  Begin
    If Not FEditMode Then Showmessage(FEditModeFalseReason);
  End;
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
    End;
  End
  Else
  Begin
    If IGArtXGUICtl.Mode <> IG_ARTX_GUI_MODE_VIEW Then
    Begin
      IGArtXGUICtl.Mode := IG_ARTX_GUI_MODE_VIEW;
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

  mnuFileSave.Enabled := boEnable;
  MnuView.Enabled := boEnable;
  mnuEdit.Enabled := boEnable;
  mnuFileExportAnnotations.Enabled := boEnable;
  mnuFileImportAnnotations.Enabled := boEnable;
  mnuAnnotation.Enabled := boEnable;
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

End.
