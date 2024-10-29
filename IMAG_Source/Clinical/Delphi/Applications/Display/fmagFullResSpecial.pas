Unit fmagFullResSpecial;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:  12/2003
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   [==
   Description: Image Window that displays Color or Scanned Documents.
   The Full Resolution window will be changed to allow viewing multiple images
   and Document  Images.  This functionality replaces the MDI
   (Multiple Document Interface) functionality and the separate Document Image Viewer.

   This window has been completly redesigned from previous patches.
   Toward the goal of object OOD and Model View desing pattern. The guts of the
   window have been removed.  This window is now just a container of objects that
   handle the functionality of displaying and manipulating images and
   a main menu to make the functionality available.

   New Imaging components are used to view and manipulate images.
   Tmag4Viewer, TMag4VGear, TMagImagelist, TmagViewerTB,

   The code in this form is just the menu and object event handlers, and
   Create and Destroy initialzation and clean up.
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
{Full Color Image Display Form}
Interface
// {$DEFINE PROTOUNDO}
Uses
  Classes,
  cMag4Vgear,
  cmag4viewer,
  //cMagLogManager, {JK 10/5/2009 - Maggmsgu refactoring - deprecated unit}
 // Maggmsgu,
//  cMagViewerTB,
  cMagViewerTB8,
  ComCtrls,
  Controls,
  Dialogs,
  ExtCtrls,
{$IFDEF UseNewAnnots}
  fMagAnnot,
{$ELSE}
  //RCA  FmagAnnotation,
{$ENDIF}
  Forms,
  Graphics,
  IMagViewer,
  Menus,
  Stdctrls, ToolWin, Buttons
  ,  umagutils8
  , umagclasses
  , inifiles
  ;


//Uses Vetted 20090929:ImgList, ToolWin, Gauges, OleCtrls, AxCtrls, Buttons, Messages, WinProcs, imaginterfaces, MAGIMAGEMANAGER, umagAppMgr, uMagKeyMgr, umagdefinitions, uMagClasses, dmsingle, magpositions, activex, WinTypes, SysUtils

Type
  TfrmFullResSpecial = Class(TForm)
    FullEdit1: Tpanel;
    ImageDesc: Tlabel;
    Label4: Tlabel;
    StbarInfo: TStatusBar;
    PopupVImage: TPopupMenu;
    MnuImageDelete2: TMenuItem;
    MnuImageReport2: TMenuItem;
    MnuImageInformation2: TMenuItem;
    MnuImageInformationAdvanced2: TMenuItem;
    MenuItem6: TMenuItem;
    MnuToolbar2: TMenuItem;
    MnuShowHints2: TMenuItem;
    MenuItem12: TMenuItem;
    MnuGotoMainWindow2: TMenuItem;
    MnuHelp2: TMenuItem;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    MnuImage1: TMenuItem;
    NewViewer1: TMenuItem;
    PnlDockTarget: Tpanel;
    Splitter1: TSplitter;
    MnuRemoveImage2: TMenuItem;
    MnuView1: TMenuItem;
    Tools1: TMenuItem;
    Help1: TMenuItem;
    MnuOpenacopy1: TMenuItem;
    MnuReport1: TMenuItem;
    MnuDelete1: TMenuItem;
    MnuClose1: TMenuItem;
    MnuImageInformation1: TMenuItem;
    MnuImageInformationAdvanced1: TMenuItem;
    MnuExit1: TMenuItem;
    N1: TMenuItem;
    MnuShowHints1: TMenuItem;
    mnuHelpFullResSpecial: TMenuItem;
    GotoMainWindow1: TMenuItem;
    MnuZoom2: TMenuItem;
    MnuFitToHeight2: TMenuItem;
    MnuFitToWidth2: TMenuItem;
    MmuFitToWindow2: TMenuItem;
    MnuActualSize2: TMenuItem;
    MnuMouse2: TMenuItem;
    MnuMousePan2: TMenuItem;
    MnuMouseZoom2: TMenuItem;
    MnuMouseMagnify2: TMenuItem;
    MnuCloseAll1: TMenuItem;
    MnuRotate2: TMenuItem;
    MnuReset2: TMenuItem;
    MnuInvert2: TMenuItem;
    N2: TMenuItem;
    MnuRotateRight2: TMenuItem;
    MnuRotateLeft2: TMenuItem;
    MnuRotate1802: TMenuItem;
    MnuTileAll1: TMenuItem;
    MnuToolBar1: TMenuItem;
    PagingControls1: TMenuItem;
    ZoomBrightnessContrast1: TMenuItem;
    N3: TMenuItem;
    MnuApplytoAll1: TMenuItem;
    MnuRotate1: TMenuItem;
    MnuPanWindow1: TMenuItem;
    MnuReset1: TMenuItem;
    MnuInvert1: TMenuItem;
    MnuZoom1: TMenuItem;
    ZoomIn1: TMenuItem;
    ZoomOut1: TMenuItem;
    MnuFittoWidht1: TMenuItem;
    MnuFittoHeight1: TMenuItem;
    MnuFittoWindow1: TMenuItem;
    MnuActualSize1: TMenuItem;
    MnuMouse1: TMenuItem;
    MnuPan2: TMenuItem;
    MnuSelect2: TMenuItem;
    MnuMagnify2: TMenuItem;
    Rightclockwise2: TMenuItem;
    Left2: TMenuItem;
    N1802: TMenuItem;
    ViewerSettings1: TMenuItem;
    RowCol1: TMenuItem;
    N1x1: TMenuItem;
    N2x1: TMenuItem;
    N3x1: TMenuItem;
    N4x1: TMenuItem;
    N2x2: TMenuItem;
    N2x3: TMenuItem;
    N3x2: TMenuItem;
    N4x2: TMenuItem;
    N1x2: TMenuItem;
    N2x4: TMenuItem;
    N3x3: TMenuItem;
    N4x3: TMenuItem;
    N1x3: TMenuItem;
    N2x5: TMenuItem;
    N3x4: TMenuItem;
    N4x4: TMenuItem;
    MnuLockImageSize1: TMenuItem;
    MnuMaximize1: TMenuItem;
    MnuDefaultLayout1: TMenuItem;
    N4: TMenuItem;
    RealignImages1: TMenuItem;
    MnuPage1: TMenuItem;
    MnuFirstPage: TMenuItem;
    MnuPreviousPage: TMenuItem;
    MnuNextPage: TMenuItem;
    MnuLastPage: TMenuItem;
    MnuCopy1: TMenuItem;
    MnuPrint1: TMenuItem;
    MnuFlipVertical1: TMenuItem;
    MnuFlipHoriz1: TMenuItem;
    MnuNextViewerPage1: TMenuItem;
    MnuPreviousViewerPage1: TMenuItem;
    N5: TMenuItem;
    ZoomIn2: TMenuItem;
    ZoomOutShiftCtrlO1: TMenuItem;
    MnuFontSize2: TMenuItem;
    Mnu6pt: TMenuItem;
    Mnu7pt: TMenuItem;
    Mnu8pt: TMenuItem;
    Mnu10pt: TMenuItem;
    Mnu12pt: TMenuItem;
    MnuPointer2: TMenuItem;
    MnuMousePointer2: TMenuItem;
    MnuCTPresets: TMenuItem;
    MnuAbdomen: TMenuItem;
    MnuBone: TMenuItem;
    MnuDisk: TMenuItem;
    MnuHead: TMenuItem;
    MnuMediastinum: TMenuItem;
    MnuLung: TMenuItem;
    Mnuundoaction: TMenuItem;
    TimerReSize: TTimer;
    MnuRefresh: TMenuItem;
    DeSkewSmooth1: TMenuItem;
    MnuImageSaveAs1: TMenuItem;
    MnuConBri: TMenuItem;
    MnuScroll: TMenuItem;
    MnuContrastP: TMenuItem;
    MnuContrastM: TMenuItem;
    MnuBrightnessP: TMenuItem;
    MnuBrightnessM: TMenuItem;
    MnuScrollToCornerTL: TMenuItem;
    MnuScrollToCornerTR: TMenuItem;
    MnuScrollToCornerBL: TMenuItem;
    MnuScrollToCornerBR: TMenuItem;
    MnuScrollLeft: TMenuItem;
    MnuScrollRight: TMenuItem;
    MnuScrollUp: TMenuItem;
    MnuScrollDown: TMenuItem;
    NextImage1: TMenuItem;
    PreviousImage1: TMenuItem;
    FlipHorizontal1: TMenuItem;
    FlipVertical1: TMenuItem;
    ShortcutMenu1: TMenuItem;
    ActiveForms1: TMenuItem;
    Annotations1: TMenuItem;
    Edit1: TMenuItem;
    Undo1: TMenuItem;
    N6: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    SelectAll1: TMenuItem;
    N7: TMenuItem;
    ClearSelecetd1: TMenuItem;
    ClearAll1: TMenuItem;
    Options1: TMenuItem;
    ExtFont1: TMenuItem;
    AnnotationColor1: TMenuItem;
    N8: TMenuItem;
    ArrowType1: TMenuItem;
    ArrowHeadLength1: TMenuItem;
    N9: TMenuItem;
    AnnotationsOpaque1: TMenuItem;
    AnnotationsTranslucent1: TMenuItem;
    Open1: TMenuItem;
    Pointer1: TMenuItem;
    SolidPointer1: TMenuItem;
    Solid1: TMenuItem;
    Small1: TMenuItem;
    Medium1: TMenuItem;
    Long1: TMenuItem;
    LineWidth1: TMenuItem;
    Hin1: TMenuItem;
    Medium2: TMenuItem;
    Hick1: TMenuItem;
    Annotation1: TMenuItem;
    MnuAnnotationPointer: TMenuItem;
    MnuAnnotationFreehandLine: TMenuItem;
    MnuAnnotationStraightLine: TMenuItem;
    MnuAnnotationFilledRectangle: TMenuItem;
    MnuAnnotationFilledEllipse: TMenuItem;
    MnuAnnotationHollowEllipse: TMenuItem;
    MnuAnnotationTypedText: TMenuItem;
    MnuAnnotationArrow: TMenuItem;
    MnuAnnotationProtractor: TMenuItem;
    MnuAnnotationRuler: TMenuItem;
    MnuAnnotationPlus: TMenuItem;
    MnuAnnotationMinus: TMenuItem;
    MnuAnnotationHollowRectangle: TMenuItem;
    FontDialog1: TFontDialog;
    ColorDialog1: TColorDialog;
    MagViewerTB1: TMagViewerTB8;
    Mag4Viewer1: TMag4Viewer;
    mnuRGBChanger: TMenuItem;
    mnuRGBFull: TMenuItem;
    mnuRGBRed: TMenuItem;
    mnuRGBGreen: TMenuItem;
    mnuRGBBlue: TMenuItem;
    pnlLeft: TPanel;
    Panel2: TPanel;
    lbPrintPreview1: TLabel;
    RadioGroup1: TRadioGroup;
    btnPrint: TSpeedButton;
    lvimageinfo: TListView;
    Splitter2: TSplitter;
    lbOptionsMsg: TLabel;

    Procedure FormCreate(Sender: Tobject);
    Procedure FormKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure FormDestroy(Sender: Tobject);
    Procedure Mag4Viewer1ViewerImageClick(Sender: Tobject);
    Procedure MnuImageDelete2Click(Sender: Tobject);
    Procedure PopupVImagePopup(Sender: Tobject);
    Procedure MnuImageReport2Click(Sender: Tobject);
    Procedure MnuImageInformation2Click(Sender: Tobject);
    Procedure MnuImageInformationAdvanced2Click(Sender: Tobject);
    Procedure MnuToolbar2Click(Sender: Tobject);
    Procedure MnuShowHints2Click(Sender: Tobject);
    Procedure MnuGotoMainWindow2Click(Sender: Tobject);
    Procedure MnuHelp2Click(Sender: Tobject);
    Procedure NewViewer1Click(Sender: Tobject);
    Procedure CurrentViewerClick(Sender: Tobject;
      Viewer: TMag4Viewer; MagImage: TMag4VGear);
    Procedure PnlDockTargetDockOver(Sender: Tobject; Source: TDragDockObject; x,
      y: Integer; State: TDragState; Var Accept: Boolean);
    Procedure PnlDockTargetDockDrop(Sender: Tobject; Source: TDragDockObject; x,
      y: Integer);
    Procedure PnlDockTargetUnDock(Sender: Tobject; Client: TControl;
      NewTarget: TWinControl; Var Allow: Boolean);
    Procedure FormPaint(Sender: Tobject);
    Procedure ResizeAllImages(Sender: Tobject);
    Procedure MnuRemoveImage2Click(Sender: Tobject);
    Procedure ViewerSettings1Click(Sender: Tobject);
    Procedure MnuOpenacopy1Click(Sender: Tobject);
    Procedure MnuReport1Click(Sender: Tobject);
    Procedure MnuDelete1Click(Sender: Tobject);
    Procedure MnuClose1Click(Sender: Tobject);
    Procedure MnuCloseAll1Click(Sender: Tobject);
    Procedure MnuImageInformation1Click(Sender: Tobject);
    Procedure MnuImageInformationAdvanced1Click(Sender: Tobject);
    Procedure MnuExit1Click(Sender: Tobject);
    Procedure File1Click(Sender: Tobject);
    Procedure GoToMainWindow1Click(Sender: Tobject);
    Procedure N1x1Click(Sender: Tobject);
    Procedure N2x2Click(Sender: Tobject);
    Procedure N1x2Click(Sender: Tobject);
    Procedure N1x3Click(Sender: Tobject);
    Procedure N2x1Click(Sender: Tobject);
    Procedure N2x3Click(Sender: Tobject);
    Procedure N2x4Click(Sender: Tobject);
    Procedure N2x5Click(Sender: Tobject);
    Procedure N3x1Click(Sender: Tobject);
    Procedure N3x2Click(Sender: Tobject);
    Procedure N3x3Click(Sender: Tobject);
    Procedure N3x4Click(Sender: Tobject);
    Procedure N4x1Click(Sender: Tobject);
    Procedure N4x2Click(Sender: Tobject);
    Procedure N4x3Click(Sender: Tobject);
    Procedure N4x4Click(Sender: Tobject);
    Procedure MnuToolBar1Click(Sender: Tobject);
    Procedure MnuView1Click(Sender: Tobject);
    Procedure MnuShowHints1Click(Sender: Tobject);
    Procedure MnuApplytoAll1Click(Sender: Tobject);
    Procedure MnuTileAll1Click(Sender: Tobject);
    Procedure MnuImage1Click(Sender: Tobject);
    Procedure MnuMousePan2Click(Sender: Tobject);
    Procedure MnuMouseZoom2Click(Sender: Tobject);
    Procedure MnuMouseMagnify2Click(Sender: Tobject);
    Procedure MnuRotateRight2Click(Sender: Tobject);
    Procedure MnuRotateLeft2Click(Sender: Tobject);
    Procedure MnuRotate1802Click(Sender: Tobject);
    Procedure MnuReset2Click(Sender: Tobject);
    Procedure MnuInvert2Click(Sender: Tobject);
    Procedure MnuPan2Click(Sender: Tobject);
    Procedure MnuSelect2Click(Sender: Tobject);
    Procedure MnuMagnify2Click(Sender: Tobject);
    Procedure Rightclockwise2Click(Sender: Tobject);
    Procedure Left2Click(Sender: Tobject);
    Procedure N1802Click(Sender: Tobject);
    Procedure MnuPanWindow1Click(Sender: Tobject);
    Procedure MnuReset1Click(Sender: Tobject);
    Procedure MnuInvert1Click(Sender: Tobject);
    Procedure MnuFitToHeight2Click(Sender: Tobject);
    Procedure MnuFitToWidth2Click(Sender: Tobject);
    Procedure MmuFitToWindow2Click(Sender: Tobject);
    Procedure MnuActualSize2Click(Sender: Tobject);
    Procedure MnuZoom1Click(Sender: Tobject);
    Procedure MnuFittoWidht1Click(Sender: Tobject);
    Procedure MnuFittoHeight1Click(Sender: Tobject);
    Procedure MnuFittoWindow1Click(Sender: Tobject);
    Procedure MnuActualSize1Click(Sender: Tobject);
    Procedure mnuHelpFullResSpecialClick(Sender: Tobject);
    Procedure MnuLockImageSize1Click(Sender: Tobject);
    Procedure RowCol1Click(Sender: Tobject);
    Procedure MnuMaximize1Click(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure RealignImages1Click(Sender: Tobject);
    Procedure MnuPage1Click(Sender: Tobject);
    Procedure MnuCopy1Click(Sender: Tobject);
    Procedure MnuFirstPageClick(Sender: Tobject);
    Procedure MnuPreviousPageClick(Sender: Tobject);
    Procedure MnuNextPageClick(Sender: Tobject);
    Procedure MnuLastPageClick(Sender: Tobject);
    Procedure MnuFlipVertical1Click(Sender: Tobject);
    Procedure MnuFlipHoriz1Click(Sender: Tobject);
    Procedure MnuPrint1Click(Sender: Tobject);
    Procedure MnuDefaultLayout1Click(Sender: Tobject);
    Procedure ZoomIn1Click(Sender: Tobject);
    Procedure ZoomOut1Click(Sender: Tobject);
    Procedure MnuNextViewerPage1Click(Sender: Tobject);
    Procedure MnuPreviousViewerPage1Click(Sender: Tobject);
    Procedure ZoomIn2Click(Sender: Tobject);
    Procedure ZoomOutShiftCtrlO1Click(Sender: Tobject);
    Procedure Mnu6ptClick(Sender: Tobject);
    Procedure Mnu7ptClick(Sender: Tobject);
    Procedure Mnu8ptClick(Sender: Tobject);
    Procedure Mnu10ptClick(Sender: Tobject);
    Procedure Mnu12ptClick(Sender: Tobject);
    Procedure MnuFontSize2Click(Sender: Tobject);
    Procedure MnuPointer2Click(Sender: Tobject);
    Procedure MnuMousePointer2Click(Sender: Tobject);
    Procedure Mag4Viewer1EndDock(Sender, Target: Tobject; x, y: Integer);
    Procedure MnuDiskClick(Sender: Tobject);
    Procedure MnuAbdomenClick(Sender: Tobject);
    Procedure MnuBoneClick(Sender: Tobject);
    Procedure MnuHeadClick(Sender: Tobject);
    Procedure MnuLungClick(Sender: Tobject);
    Procedure MnuMediastinumClick(Sender: Tobject);
    Procedure MnuundoactionClick(Sender: Tobject);
    Procedure Mag4Viewer1ListChange(Sender: Tobject);
    Procedure TimerReSizeTimer(Sender: Tobject);
    Procedure MnuRefreshClick(Sender: Tobject);
    Procedure DeSkewSmooth1Click(Sender: Tobject);
//    procedure magViewerTB1PrintClick(sender: TObject; Viewer: TMag4Viewer);  //59 used TMag4Viewer
//    procedure magViewerTB1CopyClick(sender: TObject; Viewer: TMag4Viewer);
    Procedure MnuContrastPClick(Sender: Tobject);
    Procedure MnuContrastMClick(Sender: Tobject);
    Procedure MnuBrightnessPClick(Sender: Tobject);
    Procedure MnuBrightnessMClick(Sender: Tobject);
    Procedure MnuScrollToCornerBLClick(Sender: Tobject);
    Procedure MnuScrollToCornerBRClick(Sender: Tobject);
    Procedure MnuScrollToCornerTLClick(Sender: Tobject);
    Procedure MnuScrollToCornerTRClick(Sender: Tobject);
    Procedure PreviousImage1Click(Sender: Tobject);
    Procedure NextImage1Click(Sender: Tobject);
    Procedure MnuScrollLeftClick(Sender: Tobject);
    Procedure MnuScrollRightClick(Sender: Tobject);
    Procedure MnuScrollUpClick(Sender: Tobject);
    Procedure MnuScrollDownClick(Sender: Tobject);
    Procedure FlipHorizontal1Click(Sender: Tobject);
    Procedure FlipVertical1Click(Sender: Tobject);
    Procedure ActiveForms1Click(Sender: Tobject);
    Procedure ShortcutMenu1Click(Sender: Tobject);
    Procedure ClearAll1Click(Sender: Tobject);
    Procedure ClearSelecetd1Click(Sender: Tobject);
    Procedure Undo1Click(Sender: Tobject);
    Procedure Cut1Click(Sender: Tobject);
    Procedure Copy1Click(Sender: Tobject);
    Procedure Paste1Click(Sender: Tobject);
    Procedure SelectAll1Click(Sender: Tobject);
    Procedure Open1Click(Sender: Tobject);
    Procedure Pointer1Click(Sender: Tobject);
    Procedure SolidPointer1Click(Sender: Tobject);
    Procedure Solid1Click(Sender: Tobject);
    Procedure Small1Click(Sender: Tobject);
    Procedure Medium1Click(Sender: Tobject);
    Procedure Long1Click(Sender: Tobject);
    Procedure AnnotationsOpaque1Click(Sender: Tobject);
    Procedure AnnotationsTranslucent1Click(Sender: Tobject);
    Procedure Hin1Click(Sender: Tobject);
    Procedure Medium2Click(Sender: Tobject);
    Procedure Hick1Click(Sender: Tobject);
    Procedure MnuAnnotationPointerClick(Sender: Tobject);
    Procedure MnuAnnotationFreehandLineClick(Sender: Tobject);
    Procedure MnuAnnotationStraightLineClick(Sender: Tobject);
    Procedure MnuAnnotationFilledRectangleClick(Sender: Tobject);
    Procedure MnuAnnotationHollowRectangleClick(Sender: Tobject);
    Procedure MnuAnnotationFilledEllipseClick(Sender: Tobject);
    Procedure MnuAnnotationHollowEllipseClick(Sender: Tobject);
    Procedure MnuAnnotationTypedTextClick(Sender: Tobject);
    Procedure MnuAnnotationArrowClick(Sender: Tobject);
    Procedure MnuAnnotationProtractorClick(Sender: Tobject);
    Procedure MnuAnnotationRulerClick(Sender: Tobject);
    Procedure MnuAnnotationPlusClick(Sender: Tobject);
    Procedure MnuAnnotationMinusClick(Sender: Tobject);
    Procedure ExtFont1Click(Sender: Tobject);
    Procedure AnnotationColor1Click(Sender: Tobject);
    Procedure MagViewerTB1oldCopyClick(Sender: Tobject; Viewer: IMag4Viewer);
    Procedure MagViewerTB1oldPrintClick(Sender: Tobject; Viewer: IMag4Viewer);
    Procedure MagViewerTB1CopyClick(Sender: Tobject; Viewer: TMag4Viewer);
    Procedure MagViewerTB1PrintClick(Sender: Tobject; Viewer: TMag4Viewer);
    procedure mnuRGBFullClick(Sender: TObject);
    procedure mnuRGBRedClick(Sender: TObject);
    procedure mnuRGBGreenClick(Sender: TObject);
    procedure mnuRGBBlueClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  Private
    //FOnLogEvent : TMagLogEvent; {JK 10/5/2009 - Maggmsgu refactoring}
    FSpecialIobj : TimageData;
    Procedure SetRowCol(VRow, VCol: Integer);
    Procedure UpdateMenuState(VGear: TMag4VGear);
    Procedure ImageCopyFullWin;

{$IFNDEF UseNewAnnots}
    Procedure ApplyAnnotationState(AnnotationState: TMagAnnotationState);
{$ENDIF}

    Procedure clearAnnotationChecks();
    //procedure LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO); {JK 10/5/2009 - Maggmsgu refactoring - remove old method}
    //procedure SetLogEvent(LogEvent : TMagLogEvent); {JK 10/5/2009 - Maggmsgu refactoring - remove old method}
    Procedure PanWindowCloseEvent(Sender: Tobject);
    function CheckIfAnnotsModified: Boolean;
    procedure SetFullResSpecialProperties;
    procedure DisplayNormal;
    procedure DisplayRasterized;
    procedure ImagePrintSpecial;
    procedure ShowImageInfo;
    procedure winmsg(stbarPanel: integer; s: string);
    procedure GetINISettings;
    procedure SaveINISettings;


//     procedure Winmsg(s: string);
  Public
    procedure Execute(vIobj: TimageData; option: string);
    //property OnLogEvent : TMagLogEvent read FOnLogEvent write SetLogEvent;  {JK 10/5/2009 - Maggmsgu refactoring}
  End;

Var
  frmFullResSpecial: TfrmFullResSpecial;

Implementation
Uses
  ActiveX,
ImagDMinterface, //RCA  DmSingle,
  // fmagImageList,
  // fmagMain,
  ImagInterfaces,
  MagImageManager,
  Magpositions,
  SysUtils,
  UMagAppMgr,

  UMagDefinitions,
  Umagdisplaymgr,
  //uMagDisplayUtils,
  Umagkeymgr,
  WinTypes,
  umagutils8A
  ;

{$R *.DFM}

(*procedure TFull.Winmsg(s: string);
begin
  sb1.panels[0].text := s;
end;
    *)

procedure TfrmFullResSpecial.SetFullResSpecialProperties;
begin
   // Magsetbounds(FrmFullRes, Upref.Fullpos);
   lbOptionsmsg.caption := 'Image Display is Normal';

    MagViewerTB1.Visible := true; // Upref.Fulltoolbar;    t
    Mag4Viewer1.ColumnCount := 1; //Upref.FullCols;        1
    Mag4Viewer1.MaxCount :=  1; //Upref.FullMaxLoad;       2
    Mag4Viewer1.RowCount := 1; //Upref.FullRows;           1
    Mag4Viewer1.FLastFit := 1; //Upref.FullFitMethod;      1
    Mag4Viewer1.LockHeight := Upref.Fullimageheight;        //609
    Mag4Viewer1.LockWidth := Upref.Fullimagewidth;          //1428
        // A Way to ReAlignImages, with new rows and columns, and then LockSize if needed.
    Mag4Viewer1.LockSize := False;
    Mag4Viewer1.ImageFontSize := 8; //Upref.Fullfontsize;   8

        //OnLogEvent := idmodobj.GetMagLogManager.LogEvent;  {JK 10/6/2009 - Maggmsgu refactoring}

    Mag4Viewer1.ReAlignImages;
    Mag4Viewer1.LockSize := false; //Upref.FullLockSize;    FALSE
    //                                    1               1              2                FALSE                     1
    //Mag4Viewer1.SetDefaultLayout(Upref.FullRows, Upref.FullCols, Upref.FullMaxLoad, Upref.FullLockSize, Upref.FullFitMethod);
    Mag4Viewer1.SetDefaultLayout(1,1, 1, true, 1);

            {   If Defaults are not defined for the Toolbar in M, then
//             we defalut CoolBar Bands to Break = true (for 2nd two) }         //   //  0,1,1
    MagViewerTB1.CoolBar1.Bands[0].Break := false; // Magstrtobool(MagPiece(Upref.FullControlPos, ',', 1), 'false');
    MagViewerTB1.CoolBar1.Bands[1].Break := false;  //Magstrtobool(MagPiece(Upref.FullControlPos, ',', 2), 'true');
    MagViewerTB1.CoolBar1.Bands[2].Break := false ; // Magstrtobool(MagPiece(Upref.FullControlPos, ',', 3), 'true');
end;



procedure TfrmFullResSpecial.ShowImageInfo();
var
msghint : string;

t  : tstrings;
i : integer;
lit : Tlistitem;
begin
  msghint := '';

  winmsg(1, FSpecialIobj.ExpandedDescription);

  //Mag4VGear1.ImageDescription := Iobj.ExpandedDescription(false);
  //Mag4VGear1.ImageDescriptionHint(Iobj.ExpandedIdDateDescription());

  t := tstringlist.create;
  try                                                    //FCurrentFilter.ShowDeletedImageInfo
    idmodobj.GetMagDBBroker1.RPMag4GetImageInfo(FSpecialIobj, t, false); {/ P117 - JK 9/20/2010 - Added 3rd parameter /}
    lvimageinfo.Items.BeginUpdate;

    lvImageInfo.Items.Clear;
    for i := 0 to t.Count - 1 do
    begin
      lit := lvImageInfo.Items.Add;
      lit.Caption := magpiece(t[i], ':', 1) + ':';
      lit.SubItems.Add(trim(magpiece(t[i], ':', 2) + ':' + magpiece(t[i],
        ':', 3)));
    end;
    lvimageinfo.Items.EndUpdate;
  finally
    t.free;
  end;
end;

procedure TfrmFullResSpecial.winmsg(stbarPanel: integer; s: string);
begin
  if (maglength(s, '^') > 1) then
    s := magpiece(s, '^', 1);
  if uppercase(s) = 'OKAY' then
    s := '';
  stbarInfo.Panels[stbarpanel].Text := s;
  stbarInfo.update;
end;



procedure TfrmFullResSpecial.execute(vIobj : TimageData; option : string);
var
  ObjList: Tlist;
begin
         ObjList := Tlist.Create;
  //Rlist := Tstringlist.Create;
     try
      if not DoesFormExist('frmFullResSpecial')
          then application.createform(TfrmFullResSpecial,frmFullResSpecial);
        //FullResSpec := TfrmFullResSpecial.Create(Nil);
        frmFullResSpecial.caption := 'Image Print Options';
        frmFullResSpecial.Mag4Viewer1.ClearViewer;
        frmFullResSpecial.displaynormal;
//        frmFullResSpecial.FormStyle := fsStayOnTop; //new

        frmFullResSpecial.FSpecialIobj := vIobj;

        frmFullResSpecial.ShowImageInfo;
        Application.Processmessages;
        ObjList.Add(vIobj);
        frmFullResSpecial.Mag4Viewer1.ClearBeforeAddDrop := true;
        frmFullResSpecial.Mag4Viewer1.ImagesToMagView(ObjList);
               frmFullResSpecial.Showmodal;

      finally
     objlist.Free;
     end;
end;

procedure TfrmFullResSpecial.GetINISettings();
var previewsettings : string;
begin
  previewsettings := GetIniEntry('Workstation Settings','PrintPreview');
  if previewsettings = ''  then  exit;

  self.lvimageinfo.Column[0].Width := strtoint(magpiece(previewsettings,'^',1));
  self.lvimageinfo.Column[1].Width := strtoint(magpiece(previewsettings,'^',2));
  pnlleft.Width := strtoint(magpiece(previewsettings,'^',3));

end;

procedure TfrmFullResSpecial.SaveINISettings;
var
  previewsettings : string;
  magini : Tinifile;
begin

  previewsettings := inttostr(lvimageinfo.Column[0].Width) + '^'
                    + inttostr(lvimageinfo.Column[1].Width) +'^'
                    + inttostr(pnlleft.Width) ;

  SetIniEntry('Workstation Settings','PrintPreview',previewsettings);
end;



Procedure TfrmFullResSpecial.FormCreate(Sender: Tobject);

Begin
SetFullResSpecialProperties;

  Color := FSAppBackGroundColor;
  CoInitialize(Nil);
//{$IFDEF PROTOUNDO} mnuUndoAction.Visible := true; {$ENDIF}
  Mag4Viewer1.Align := alClient;
  Mag4Viewer1.SetRemember(True);
  GetFormPosition(Self As TForm);
  GetINISettings;


  If Not Assigned(Mag4Viewer1.MagUtilsDB) Then
  Begin
    Mag4Viewer1.MagUtilsDB := idmodobj.GetMagUtilsDB1;
    idmodobj.GetMagUtilsDB1.MagPat := idmodobj.GetMagPat1;
  End;
  MnuFirstPage.ShortCut := ShortCut(VK_LEFT, [Ssctrl, SsAlt]);
  MnuPreviousPage.ShortCut := ShortCut(VK_DOWN, [Ssctrl, SsAlt]);
  MnuNextPage.ShortCut := ShortCut(VK_UP, [Ssctrl, SsAlt]);
  MnuLastPage.ShortCut := ShortCut(VK_RIGHT, [Ssctrl, SsAlt]);

  MnuContrastP.ShortCut := ShortCut(Ord('J'), [SsShift, Ssctrl]);
  MnuContrastM.ShortCut := ShortCut(Ord('K'), [SsShift, Ssctrl]);
  MnuBrightnessP.ShortCut := ShortCut(Ord('N'), [SsShift, Ssctrl]);
  MnuBrightnessM.ShortCut := ShortCut(Ord('M'), [SsShift, Ssctrl]);

  MnuScrollLeft.ShortCut := ShortCut(VK_LEFT, [SsShift, Ssctrl]); //[ssShift,ssCtrl]
  MnuScrollRight.ShortCut := ShortCut(VK_RIGHT, [SsShift, Ssctrl]);
  MnuScrollUp.ShortCut := ShortCut(VK_UP, [SsShift, Ssctrl]);
  MnuScrollDown.ShortCut := ShortCut(VK_DOWN, [SsShift, Ssctrl]);

  MnuScrollToCornerTL.ShortCut := ShortCut(VK_HOME, [SsShift, Ssctrl]);
  MnuScrollToCornerTR.ShortCut := ShortCut(VK_PRIOR, [SsShift, Ssctrl]);
  MnuScrollToCornerBL.ShortCut := ShortCut(VK_END, [SsShift, Ssctrl]);
  MnuScrollToCornerBR.ShortCut := ShortCut(VK_NEXT, [SsShift, Ssctrl]);

  // JMW 7/14/08 p72t23 - add event for when the user closes the pan window
  // using the X in the dialog
  Mag4Viewer1.OnPanWindowClose := PanWindowCloseEvent;

   // JMW p72 12/7/2006 - add the one viewer to the toolbar
   // this is a bit of a kluge because the toolbar doesn't use the MagViewer variable as much anymore
   // shouldn't need this kludge anymore since the magViewerTB is seperate from magViewerRadTB
//   magViewerTB1.addViewerToToolbar(Mag4Viewer1);

  MagViewerTB1.RefreshButtonVisible(false);
End;

{JK 10/5/2009 - Maggmsgu refactoring - remove old method}
//procedure TfrmFullRes.SetLogEvent(LogEvent : TMagLogEvent);
//begin
//  FOnLogEvent := LogEvent;
//  Mag4Viewer1.OnLogEvent := OnLogEvent;
//end;

{JK 10/5/2009 - Maggmsgu refactoring - remove old method}
//procedure TfrmFullRes.LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);
//begin
//  if assigned(OnLogEvent) then
//    OnLogEvent(self, MsgType, Msg, Priority);
//end;

Procedure TfrmFullResSpecial.FormKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If (Shift = [Ssctrl]) And (Key = VK_tab) Then
    PopupVImage.Popup(Left + 20, Top + 50);
End;

Procedure TfrmFullResSpecial.FormDestroy(Sender: Tobject);
Begin
  SaveFormPosition(Self As TForm);
End;

Procedure TfrmFullResSpecial.CurrentViewerClick(Sender: Tobject; Viewer: TMag4Viewer;
  MagImage: TMag4VGear);
Begin
  MagViewerTB1.MagViewer := Viewer;
End;

Procedure TfrmFullResSpecial.Mag4Viewer1ViewerImageClick(Sender: Tobject);
Var
  VIobj: TImageData;
  NewsObj: TMagNewsObject;
Begin
  UpdateMenuState(Mag4Viewer1.GetCurrentImage);
  MagViewerTB1.UpdateImageState;

  If FSyncImageON Then {FSyncImageOn from  Mag4Viewer1 click}
  Begin
    VIobj := Mag4Viewer1.GetCurrentImageObject;
    If VIobj <> Nil Then
    Begin
      NewsObj := MakeNewsObject(MpubImageSelected, 0, VIobj.Mag0, VIobj, Mag4Viewer1);
       //logmsg('s','Publishing ImageSelect from FullRes window');
      MagAppMsg('s', 'Publishing ImageSelect from FullRes window'); {JK 10/6/2009 - Maggmsgu refactoring}
       {p94t3 gek 11/30/09  decouple frmimagelist,  create gblobal publisher GmagPublish}
       //frmImageList.MagPublisher1.I_SetNews(newsobj);   //Mag4Viewer1ViewerImageClick
      GmagPublish.I_SetNews(NewsObj); //Mag4Viewer1ViewerImageClick
    End;
  End;
End;

Procedure TfrmFullResSpecial.UpdateMenuState(VGear: TMag4VGear);
Var
  Imagestate: TMagImageState;
Begin
  MnuZoom1.Enabled := Not (VGear = Nil);
  MnuImage1.Enabled := Not (VGear = Nil);
  If VGear = Nil Then
  Begin
    MnuPage1.Enabled := False;
    Annotations1.Enabled := False;
    mnuRGBChanger.Enabled :=False;  // p130t11 dmmn 4/5/12 - disable the mnu if there's no images selected
  End
  Else
  Begin
    Imagestate := VGear.GetState;
    MnuPage1.Enabled := (Imagestate.PageCount > 1);
    Annotations1.Enabled := (Imagestate.MouseAction = MactAnnotation);
    mnuRGBChanger.Enabled := ImageState.RGBEnabled;  // p130t11 dmmn 4/5/12 - enable the mnu based on the image state
{$IFNDEF UseNewAnnots}
    If (Imagestate.MouseAction = MactAnnotation) And (VGear.AnnotationComponent <> Nil) Then
    Begin
      ApplyAnnotationState(VGear.AnnotationComponent.GetAnnotationState());
    End;
{$ENDIF}
  End;

End;

{$IFNDEF UseNewAnnots}

Procedure TfrmFullRes.ApplyAnnotationState(AnnotationState: TMagAnnotationState);
Begin
  If AnnotationState = Nil Then Exit;
  clearAnnotationChecks();
  If AnnotationState.IsOpaque Then
    AnnotationsOpaque1.Checked := True
  Else
    AnnotationsTranslucent1.Checked := True;
  {
  case AnnotationState.ToolType of
    MagAnnToolPointer: mnuAnnotationPointer.Checked := true;
    MagAnnToolFreehandLine: mnuAnnotationFreehandLine.Checked := true;
    MagAnnToolStraightLine: mnuAnnotationStraightLine.Checked := true;
    MagAnnToolFilledRectangle: mnuAnnotationFilledRectangle.Checked := true;
    MagAnnToolHollowRectangle: mnuAnnotationHollowRectangle.Checked := true;
    MagAnnToolFilledElipse: mnuAnnotationFilledEllipse.Checked := true;
    MagAnnToolHollowElipse: mnuAnnotationHollowEllipse.Checked := true;
    MagAnnToolTypedText: mnuAnnotationTypedText.Checked := true;
    MagAnnToolArrow: mnuAnnotationArrow.Checked := true;
    MagAnnToolProtractor: mnuAnnotationProtractor.Checked := true;
    MagAnnToolRuler: mnuAnnotationRuler.Checked := true;
    MagAnnToolPlus: mnuAnnotationPlus.Checked := true;
    MagAnnToolMinus: mnuAnnotationMinus.Checked := true;

  end;
  }

End;
{$ENDIF}

Procedure TfrmFullResSpecial.clearAnnotationChecks();
Begin
{
  mnuAnnotationPointer.Checked := false;
  mnuAnnotationFreehandLine.Checked := false;
  mnuAnnotationStraightLine.Checked := false;
  mnuAnnotationFilledRectangle.Checked := false;
  mnuAnnotationHollowRectangle.Checked := false;
  mnuAnnotationFilledEllipse.Checked := false;
  mnuAnnotationHollowEllipse.Checked := false;
  mnuAnnotationTypedText.Checked := false;
  mnuAnnotationArrow.Checked := false;
  mnuAnnotationProtractor.Checked := false;
  mnuAnnotationRuler.Checked := false;
  mnuAnnotationPlus.Checked := false;
  mnuAnnotationMinus.Checked := false;
  }
  AnnotationsOpaque1.Checked := False;
  AnnotationsTranslucent1.Checked := False;

End;

Procedure TfrmFullResSpecial.MnuImageDelete2Click(Sender: Tobject);
Var
  IObj: TImageData;
  Rmsg: String;
  rstat: Boolean; {/ P122 T15 - JK 7/18/2012 /}
  rmsg2: String;  {/ P122 T15 - JK 7/25/2012 /}
  NeedsReview: Boolean; {/ P122 T15 - JK 7/18/2012 - add from discussions with Cliff Sorensen /}

  NewsObj: TMagNewsObject;
Begin
  IObj := TMag4VGear(PopupVImage.PopupComponent).PI_ptrData;
  If MnuImageDelete2.Tag = -1 Then Exit;
  // JMW 6/24/2005 p45t3 compare based on server and port (more accurate)
  If (IObj.ServerName <> idmodobj.GetMagDBBroker1.GetServer) Or (IObj.ServerPort <> idmodobj.GetMagDBBroker1.GetListenerPort) Then
//  if (iobj.PlaceCode <> wrksplacecode) then    // JMW 3/2/2005 p45
  Begin
    Showmessage('You cannot delete an image from a remote site');
    Exit;
  End;
  magAppMsg('s', 'Attempting deletion of ' + IObj.FFile + '  IEN ' + IObj.Mag0);

  {p94t2 gek refactoring, decoupling fmagmain.}
//  frmMain.ImageDelete(Iobj);
//  LogActions('FULL', 'DELETE', Iobj.Mag0);
  {/ P122 T15 - JK 7/18/2012 /}
  if MgrImageDelete(Iobj, rmsg, NeedsReview) then
  begin
    if NeedsReview then
    begin
      if not IObj.Annotated then
        CurrentImageStatusChange(Iobj, umagdefinitions.MistNeedsReview, rstat, rmsg2);

      {/ P122 T15 - JK 8/9/2012 /}
      If FSyncImageON Then {FSyncImageOn from  Mag4Viewer1 click}
      Begin
//        VIobj := Mag4Viewer1.GetCurrentImageObject;
        If Iobj <> Nil Then
        Begin
          NewsObj := MakeNewsObject(MpubImageNeedsReview, 0, Iobj.Mag0, Iobj, Mag4Viewer1);
          magAppMsg('s', 'TfrmFullRes.MnuImageDelete2Click: Publishing "Image Needs Review" from FullRes window');
           {p94t3 gek 11/30/09  decouple frmimagelist,  create gblobal publisher GmagPublish}
           //frmImageList.MagPublisher1.I_SetNews(newsobj);   //Mag4Viewer1ViewerImageClick
          GmagPublish.I_SetNews(NewsObj); //Mag4Viewer1ViewerImageClick
        End;
      End;
    end
    else
  Begin
    LogActions('FULL', 'DELETE', IObj.Mag0);
    { TODO -cpatch 94 : do we need here to update (sync) status of other image lists. tree, list etc }
      {/ P122 T15 - JK 8/9/2012 - the image has been deleted in the full res viewer, now close the full res viewer form /}
      Close;
  End;
  MagAppMsg('s', 'Delete Result: ' + Rmsg);
  end;
End;

Procedure TfrmFullResSpecial.PopupVImagePopup(Sender: Tobject);
Var
  Imageclicked: Boolean;
Begin
  magAppMsg('', '');
  MnuToolbar2.Checked := MagViewerTB1.Visible;
  MnuShowHints2.Checked := ShowHint;
  MnuImageDelete2.Visible := (Userhaskey('MAG DELETE')); // and (mnuImageDelete2.tag <> -1));
  MnuImageInformationAdvanced2.Visible := (Userhaskey('MAG SYSTEM'));

  Imageclicked := (PopupVImage.PopupComponent Is TMag4VGear);
  MnuZoom2.Enabled := Imageclicked;
  MnuMouse2.Enabled := Imageclicked;
  MnuRotate2.Enabled := Imageclicked;
  MnuInvert2.Enabled := Imageclicked;
  MnuReset2.Enabled := Imageclicked;
  MnuRemoveImage2.Enabled := Imageclicked;
  MnuImageReport2.Enabled := Imageclicked;
  MnuImageDelete2.Enabled := Imageclicked;
  MnuImageInformation2.Enabled := Imageclicked;
  MnuImageInformationAdvanced2.Enabled := Imageclicked;
End;

Procedure TfrmFullResSpecial.MnuImageReport2Click(Sender: Tobject);
Begin
  Mag4Viewer1.ImageReport;
End;

Procedure TfrmFullResSpecial.MnuImageInformation2Click(Sender: Tobject);
Var
  VGear: TMag4VGear;
  IObj: TImageData;
  Sellist: Tlist;
  i: Integer;
        {       from popup menu, we send all selected to the Image info window}
Begin
  Sellist := Mag4Viewer1.GetSelectedImageList;
  For i := Sellist.Count - 1 Downto 0 Do
  Begin
    IObj := Sellist[i];
    ShowImageInformation(IObj);
  End;
End;

Procedure TfrmFullResSpecial.MnuImageInformationAdvanced2Click(Sender: Tobject);
Var // VGear : Tmag4Vgear;
  IObj: TImageData;
Begin
//vGear :=TMag4Vgear(popupVImage.PopupComponent);
  IObj := TMag4VGear(PopupVImage.PopupComponent).PI_ptrData;
//

// advanced information for sysmanagers.
  If MnuImageInformationAdvanced2.Tag = -1 Then Exit;
  OpenImageInfoSys(IObj);
  LogActions('ABS', 'IMAGE INFO', IObj.Mag0);
End;

Procedure TfrmFullResSpecial.MnuToolbar2Click(Sender: Tobject);
Begin
//01/06/03    This is now Invisible on Full Res Window.
  MnuToolbar2.Checked := Not MnuToolbar2.Checked;
//not same as abs
//mag4Viewer1.tbViewer.Visible := mnuToolbar.checked;
  MagViewerTB1.Visible := MnuToolbar2.Checked;
  Mag4Viewer1.ReAlignImages();
End;

Procedure TfrmFullResSpecial.MnuShowHints2Click(Sender: Tobject);
Begin
  MnuShowHints2.Checked := Not MnuShowHints2.Checked;
  ShowHint := MnuShowHints2.Checked;
End;

Procedure TfrmFullResSpecial.MnuGotoMainWindow2Click(Sender: Tobject);
Begin
  Application.MainForm.SetFocus;
End;

Procedure TfrmFullResSpecial.MnuHelp2Click(Sender: Tobject);
Begin
  Application.HelpContext(HelpContext);
End;

Procedure TfrmFullResSpecial.NewViewer1Click(Sender: Tobject);
Begin
  With TMag4Viewer.Create(Self) Do
  Begin
    Showmessage(Name);
    Parent := Self;
    Show;

    Width := Self.Width Div 2;
    Left := Self.Width Div 2;
    Align := alright;
    OnViewerClick := CurrentViewerClick;
  End;
End;

Procedure TfrmFullResSpecial.PnlDockTargetDockOver(Sender: Tobject; Source: TDragDockObject;
  x, y: Integer; State: TDragState;
  Var Accept: Boolean);
Begin
  Accept := True;
End;

Procedure TfrmFullResSpecial.PnlDockTargetDockDrop(Sender: Tobject; Source: TDragDockObject;
  x, y: Integer);
Begin
  PnlDockTarget.Width := 200;
  Splitter1.Left := 203;
  Splitter1.Width := 5;
End;

Procedure TfrmFullResSpecial.PnlDockTargetUnDock(Sender: Tobject; Client: TControl;
  NewTarget: TWinControl; Var Allow: Boolean);
Begin
//showmessage('something is undocking');
  Allow := True;
  PnlDockTarget.Width := 0;
  Splitter1.Width := 0;

End;

Procedure TfrmFullResSpecial.FormPaint(Sender: Tobject);
Begin

(*  p8t35, we now use a timer, to delay realigning, and we modified realign
    to not cause a problem if loaded images = 0. So we put new call in
    OnResize event.*)
{ setting it here, stops the resize being called when the form is created.}
  If Not Assigned(OnResize) Then OnResize := ResizeAllImages;

End;

Procedure TfrmFullResSpecial.ResizeAllImages(Sender: Tobject);
Begin
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
    If Mag4Viewer1.UseAutoReAlign Then TimerReSize.Enabled := True;
                        // Mag4Viewer1.ReAlignImages;
  End;
End;

Procedure TfrmFullResSpecial.TimerReSizeTimer(Sender: Tobject);
Begin
{ This is the ReAligncalled from the Window Timer.
  There is also a timer associated with the Scrlv : TMagEventScrollBox
    {}
  If Not Application.Terminated Then
  Begin
    TimerReSize.Enabled := False;
    Application.Processmessages;
    If Mag4Viewer1 <> Nil Then {JK 6/5/2009 - added guard}
      If Mag4Viewer1.UseAutoReAlign Then
        Mag4Viewer1.ReAlignImages(False, False, Mag4Viewer1.GetCurrentImageIndex);
  End;
End;

Procedure TfrmFullResSpecial.MnuRemoveImage2Click(Sender: Tobject);
//var  VGear : Tmag4Vgear;
//Iobj : TImageData;
Begin
//vGear :=TMag4Vgear(popupVImage.PopupComponent);
//Iobj := TMag4Vgear(popupVImage.PopupComponent).PI_ptrData;
//
  Mag4Viewer1.RemoveFromList;
End;

Procedure TfrmFullResSpecial.ViewerSettings1Click(Sender: Tobject);
Begin
 // RowColSize.execute(Mag4Viewer1);
  Mag4Viewer1.EditViewerSettings;
End;

Procedure TfrmFullResSpecial.MnuOpenacopy1Click(Sender: Tobject);
Var
  IObj: TImageData;
  Xmsg: String;
Begin
// MAIN MENU IS DIFFERENT THAN POPUOP
  IObj := Mag4Viewer1.GetCurrentImageObject;
  If IObj <> Nil Then
  Begin
    OpenSelectedImage(IObj, 1, 0, 1, 0, True);
    If Not MagImageManager1.IsImageCurrentlyCaching() Then idmodobj.GetMagFileSecurity.MagCloseSecurity(Xmsg);
//  Dmod.MagFileSecurity.MagCloseSecurity(xmsg); {frmMain.CloseSecurity;}
  End;
End;

Procedure TfrmFullResSpecial.MnuReport1Click(Sender: Tobject);
//var
//Iobj : TImageData;
Begin
  Mag4Viewer1.ImageReport;
  // below is replaced by above.
(*
// MAIN MENU IS DIFFERENT THAN POPUOP
//Iobj := Mag4Viewer1.GetCurrentImageObject;
//if Iobj <> nil then
//  begin
//  buildreport(Iobj.Mag0, '', 'Image Report');
//  frmMain.LogActions('ABS', 'REPORT', Iobj.Mag0);
  end;  *)
End;

Procedure TfrmFullResSpecial.MnuDelete1Click(Sender: Tobject);
Var
  IObj: TImageData;
  Rmsg: String;
  rstat: Boolean;  {/ P122 T15 - 7/18/2012 /}
Begin
// MAIN MENU IS DIFFERENT THAN POPUOP
  IObj := Mag4Viewer1.GetCurrentImageObject;
  If IObj <> Nil Then
  Begin
    If MnuImageDelete2.Tag = -1 Then Exit;
    // JMW 6/24/2005 p45t3 compare based on server and port (more accurate)
    If (IObj.ServerName <> idmodobj.GetMagDBBroker1.GetServer) Or (IObj.ServerPort <> idmodobj.GetMagDBBroker1.GetListenerPort) Then
     {TODO: Need to use the function IsRemoteImage.. }
    //if (iobj.PlaceCode <> wrksplacecode) then    // JMW 3/2/2005 p45
    Begin
      Showmessage('You cannot delete an image from a remote site');
      Exit;
    End;
  {p94t2 gek refactoring, decoupling fmagmain.}
//  frmMain.ImageDelete(Iobj);
//  LogActions('FULL', 'DELETE', Iobj.Mag0);
    If MgrImageDelete(IObj, Rmsg, rstat) Then
    Begin
      LogActions('FULL', 'DELETE', IObj.Mag0);
    { TODO -cpatch 94 : do we need here to update (sync) status of other image lists. tree, list etc }
    End;
    MagAppMsg('s', 'Delete Result: ' + Rmsg);
  End;

End;

Procedure TfrmFullResSpecial.MnuClose1Click(Sender: Tobject);
//var
//Iobj : TImageData;
Begin
// MAIN MENU IS DIFFERENT THAN POPUOP
//Iobj := Mag4Viewer1.GetCurrentImageObject;
  Mag4Viewer1.RemoveFromList;
End;

Procedure TfrmFullResSpecial.MnuCloseAll1Click(Sender: Tobject);
//var
//Iobj : TImageData;
Begin
// MAIN MENU IS DIFFERENT THAN POPUOP
//Iobj := Mag4Viewer1.GetCurrentImageObject;
  Mag4Viewer1.ClearViewer;

End;

Procedure TfrmFullResSpecial.MnuImageInformation1Click(Sender: Tobject);
Var
  VGear: TMag4VGear;
  IObj: TImageData;
  Sellist: Tlist;
  i: Integer;
        {       we send all selected to the Image info window}
Begin
  Sellist := Mag4Viewer1.GetSelectedImageList;
  For i := Sellist.Count - 1 Downto 0 Do
  Begin
    IObj := Sellist[i];
    ShowImageInformation(IObj);
  End;
End;
(* old code that only displayed info for one image not all selected*)
{// MAIN MENU IS DIFFERENT THAN POPUOP
vGear := Mag4Viewer1.GetCurrentImage;
Iobj := Mag4Viewer1.GetCurrentImageObject;
if Iobj <> nil then ShowImageInformation(Iobj,vGear);
end;}

Procedure TfrmFullResSpecial.MnuImageInformationAdvanced1Click(Sender: Tobject);
Var
  IObj: TImageData;
Begin
// MAIN MENU IS DIFFERENT THAN POPUOP
  IObj := Mag4Viewer1.GetCurrentImageObject;
  If IObj <> Nil Then
  Begin
    // advanced information for sysmanagers.
    If MnuImageInformationAdvanced2.Tag = -1 Then Exit;
    OpenImageInfoSys(IObj);
    LogActions('ABS', 'IMAGE INFO', IObj.Mag0);
  End;
End;

Procedure TfrmFullResSpecial.MnuExit1Click(Sender: Tobject);
Begin
  Close;
End;

Procedure TfrmFullResSpecial.File1Click(Sender: Tobject);
Var
  IObj: TImageData;
Begin
  IObj := Mag4Viewer1.GetCurrentImageObject;
  MnuOpenacopy1.Enabled := (IObj <> Nil);
  MnuCopy1.Enabled := (IObj <> Nil);
  MnuPrint1.Enabled := (IObj <> Nil);
  MnuReport1.Enabled := (IObj <> Nil);

  MnuDelete1.Visible := (Userhaskey('MAG DELETE'));
  If MnuDelete1.Visible Then MnuDelete1.Enabled := (IObj <> Nil);

//    mnuImageDelete1.enabled  :=   mnuImageDelete1.visible  ;
  MnuDelete1.caption := 'Image Delete...';
  If Userhaskey('MAG DELETE') And (IObj <> Nil) And (IObj.ImgType = 11) Then
  Begin
    MnuDelete1.caption := 'Image Group Delete...';
    MnuDelete1.Enabled := (Userhaskey('MAG SYSTEM'));
  End;

  MnuClose1.Enabled := (IObj <> Nil);
  MnuCloseAll1.Enabled := (Mag4Viewer1.GetImageCount > 0);
  MnuImageInformation1.Enabled := (IObj <> Nil);
  MnuImageInformationAdvanced1.Visible := (Userhaskey('MAG SYSTEM'));
  If MnuImageInformationAdvanced1.Visible Then MnuImageInformationAdvanced1.Enabled := (IObj <> Nil);
//  this only needs a dialog to ask where to save it, and we can save it.
//  not in 93...    mnuImageSaveAs1.visible := (UserHasKey('MAG EDIT'));
  If MnuImageSaveAs1.Visible Then MnuImageSaveAs1.Enabled := (IObj <> Nil);
End;

Procedure TfrmFullResSpecial.GoToMainWindow1Click(Sender: Tobject);
Begin
  Application.MainForm.SetFocus;
End;

Procedure TfrmFullResSpecial.SetRowCol(VRow, VCol: Integer);
Begin
  If Mag4Viewer1.MaxCount < (VRow * VCol) Then Mag4Viewer1.MaxCount := (VRow * VCol);
  Application.Processmessages;
  Mag4Viewer1.SetRowColCount(VRow, VCol);
  Application.Processmessages;
End;

Procedure TfrmFullResSpecial.N1x1Click(Sender: Tobject);
Begin
  SetRowCol(1, 1);
End;

Procedure TfrmFullResSpecial.N2x2Click(Sender: Tobject);
Begin
  SetRowCol(1, 2);
End;

Procedure TfrmFullResSpecial.N1x2Click(Sender: Tobject);
Begin
  SetRowCol(1, 3);
End;

Procedure TfrmFullResSpecial.N1x3Click(Sender: Tobject);
Begin
  SetRowCol(1, 4);
End;

Procedure TfrmFullResSpecial.N2x1Click(Sender: Tobject);
Begin
  SetRowCol(2, 1);
End;

Procedure TfrmFullResSpecial.N2x3Click(Sender: Tobject);
Begin
  SetRowCol(2, 2);
End;

Procedure TfrmFullResSpecial.N2x4Click(Sender: Tobject);
Begin
  SetRowCol(2, 3);
End;

Procedure TfrmFullResSpecial.N2x5Click(Sender: Tobject);
Begin
  SetRowCol(2, 4);
End;

Procedure TfrmFullResSpecial.N3x1Click(Sender: Tobject);
Begin
  SetRowCol(3, 1);
End;

Procedure TfrmFullResSpecial.N3x2Click(Sender: Tobject);
Begin
  SetRowCol(3, 2);
End;

Procedure TfrmFullResSpecial.N3x3Click(Sender: Tobject);
Begin
  SetRowCol(3, 3);
End;

Procedure TfrmFullResSpecial.N3x4Click(Sender: Tobject);
Begin
  SetRowCol(3, 4);
End;

Procedure TfrmFullResSpecial.N4x1Click(Sender: Tobject);
Begin
  SetRowCol(4, 1);
End;

Procedure TfrmFullResSpecial.N4x2Click(Sender: Tobject);
Begin
  SetRowCol(4, 2);
End;

Procedure TfrmFullResSpecial.N4x3Click(Sender: Tobject);
Begin
  SetRowCol(4, 3);
End;

Procedure TfrmFullResSpecial.N4x4Click(Sender: Tobject);
Begin
  SetRowCol(4, 4);
End;

Procedure TfrmFullResSpecial.MnuToolBar1Click(Sender: Tobject);
Begin
  MnuToolBar1.Checked := Not MnuToolBar1.Checked;
  MagViewerTB1.Visible := MnuToolBar1.Checked;
  Mag4Viewer1.ReAlignImages();
End;

Procedure TfrmFullResSpecial.MnuView1Click(Sender: Tobject);
Begin
(*if self.mnuundoaction.Visible then
  begin
    if mag4Viewer1.UnDoActionGetText = '' then
      begin
        mnuundoaction.Caption := 'Can''t &Undo';
        mnuundoaction.Enabled := false;
      end
      else
      begin
        mnuundoaction.Caption := '&'+Mag4Viewer1.UnDoActionGetText;
        mnuundoaction.Enabled := true;
      end;
  end;  *)
  MnuToolBar1.Checked := MagViewerTB1.Visible;
  MnuShowHints1.Checked := ShowHint;
  MnuLockImageSize1.Checked := Mag4Viewer1.LockSize;
  MnuPanWindow1.Checked := Mag4Viewer1.PanWindow;
End;

Procedure TfrmFullResSpecial.MnuShowHints1Click(Sender: Tobject);
Begin
  MnuShowHints1.Checked := Not MnuShowHints1.Checked;
  ShowHint := MnuShowHints1.Checked;
End;

Procedure TfrmFullResSpecial.MnuApplytoAll1Click(Sender: Tobject);
Begin
  MnuApplytoAll1.Checked := Not MnuApplytoAll1.Checked;
  Mag4Viewer1.ApplyToAll := MnuApplytoAll1.Checked;
  MagViewerTB1.UpdateImageState;
End;

Procedure TfrmFullResSpecial.MnuTileAll1Click(Sender: Tobject);
Begin
  Mag4Viewer1.TileAll;
End;

Procedure TfrmFullResSpecial.MnuImage1Click(Sender: Tobject);
Var
  IObj: TImageData;
  Enableable: Boolean;
Begin
          {   Main Menu is different that popup,  Here we have to check for NIL}
  IObj := Mag4Viewer1.GetCurrentImageObject;
  Enableable := (IObj <> Nil) Or ((Mag4Viewer1.GetImageCount > 0) And (Mag4Viewer1.ApplyToAll));
  MnuApplytoAll1.Checked := Mag4Viewer1.ApplyToAll;
  MnuMouse1.Enabled := Enableable;
  MnuRotate1.Enabled := Enableable;
  MnuPanWindow1.Enabled := Enableable;
  MnuReset1.Enabled := Enableable;
  MnuInvert1.Enabled := Enableable;
  MnuMaximize1.Enabled := Enableable;
  MnuFlipVertical1.Enabled := Enableable;
  MnuFlipHoriz1.Enabled := Enableable;
End;

Procedure TfrmFullResSpecial.MnuMousePan2Click(Sender: Tobject);
Begin
  Mag4Viewer1.MousePan;
End;

Procedure TfrmFullResSpecial.MnuMouseZoom2Click(Sender: Tobject);
Begin
  Mag4Viewer1.MouseZoomRect;
End;

Procedure TfrmFullResSpecial.MnuMouseMagnify2Click(Sender: Tobject);
Begin
  Mag4Viewer1.MouseMagnify;
End;

Procedure TfrmFullResSpecial.MnuRotateRight2Click(Sender: Tobject);
Begin
  Mag4Viewer1.Rotate(90);

End;

Procedure TfrmFullResSpecial.MnuRotateLeft2Click(Sender: Tobject);
Begin
  Mag4Viewer1.Rotate(270);
End;

Procedure TfrmFullResSpecial.MnuRotate1802Click(Sender: Tobject);
Begin
  Mag4Viewer1.Rotate(180);
End;

Procedure TfrmFullResSpecial.MnuReset2Click(Sender: Tobject);
Begin
  Mag4Viewer1.ResetImages;
    // Changing the next 3 controls, on this reset, is
    //  actually changing the property again.
    { TODO : Not Show Stopper, have to get way to stop the double processing. }
  MagViewerTB1.TbicBrightness.Position := 100;
  MagViewerTB1.TbicContrast.Position := 100;
//MagViewerTB1.tbicWin.Position := 100;
//MagViewerTB1.tbicLev.Position := 100;
  MagViewerTB1.TbicZoom.Position := 100;
  MagViewerTB1.UpdateImageState;
End;

Procedure TfrmFullResSpecial.MnuInvert2Click(Sender: Tobject);
Begin
  Mag4Viewer1.Inverse;
End;

Procedure TfrmFullResSpecial.MnuPan2Click(Sender: Tobject);
Begin
  Mag4Viewer1.MousePan;
End;

Procedure TfrmFullResSpecial.MnuSelect2Click(Sender: Tobject);
Begin
  Mag4Viewer1.MouseZoomRect;
End;

Procedure TfrmFullResSpecial.MnuMagnify2Click(Sender: Tobject);
Begin
  Mag4Viewer1.MouseMagnify;
End;

Procedure TfrmFullResSpecial.Rightclockwise2Click(Sender: Tobject);
Begin
  Mag4Viewer1.Rotate(90);
End;

Procedure TfrmFullResSpecial.Left2Click(Sender: Tobject);
Begin
  Mag4Viewer1.Rotate(270);
End;

Procedure TfrmFullResSpecial.N1802Click(Sender: Tobject);
Begin
  Mag4Viewer1.Rotate(180);
End;

Procedure TfrmFullResSpecial.MnuPanWindow1Click(Sender: Tobject);
Begin
  MnuPanWindow1.Checked := Not MnuPanWindow1.Checked;
  Mag4Viewer1.PanWindow := MnuPanWindow1.Checked;
  MagViewerTB1.UpdateImageState;
End;

Procedure TfrmFullResSpecial.MnuReset1Click(Sender: Tobject);
Begin
  Mag4Viewer1.ResetImages;
End;

Procedure TfrmFullResSpecial.MnuInvert1Click(Sender: Tobject);
Begin
  Mag4Viewer1.Inverse;
End;

procedure TfrmFullResSpecial.mnuRGBFullClick(Sender: TObject);
begin
  //p130t11 dmmn 4/8/12 - change the selected image(s) color channel to full colors
  // Current State: 0 1 2 3 4 - RGB R G B
  Mag4Viewer1.RGBChanger(3, false);
  MagViewerTB1.UpdateImageState;
end;

procedure TfrmFullResSpecial.mnuRGBBlueClick(Sender: TObject);
begin
  //p130t11 dmmn 4/8/12 - change the selected image(s) color channel to blue
  // Current State: 0 1 2 3 - RGB R G B
  Mag4Viewer1.RGBChanger(2, false);
  MagViewerTB1.UpdateImageState;
end;
          

procedure TfrmFullResSpecial.mnuRGBGreenClick(Sender: TObject);
begin
  //p130t11 dmmn 4/8/12 - change the selected image(s) color channel to green
  // Current State: 0 1 2 3 4 - RGB R G B
  Mag4Viewer1.RGBChanger(1, false);
  MagViewerTB1.UpdateImageState;
end;

procedure TfrmFullResSpecial.mnuRGBRedClick(Sender: TObject);
begin
  //p130t11 dmmn 4/8/12 - change the selected image(s) color channel to red
  // Current State: 0 1 2 3 4 - RGB R G B
  Mag4Viewer1.RGBChanger(0, false);
  MagViewerTB1.UpdateImageState;
end;

Procedure TfrmFullResSpecial.MnuFitToHeight2Click(Sender: Tobject);
Begin
  Mag4Viewer1.FitToHeight;
  Application.Processmessages;
//gek 93 Stop Automatic Mouse Pan   Mag4Viewer1.MousePan;
End;

Procedure TfrmFullResSpecial.MnuFitToWidth2Click(Sender: Tobject);
Begin
  Mag4Viewer1.FitToWidth;
  Application.Processmessages;
//gek 93 Stop Automatic Mouse Pan   Mag4Viewer1.MousePan;
End;

Procedure TfrmFullResSpecial.MmuFitToWindow2Click(Sender: Tobject);
Begin
  Mag4Viewer1.FitToWindow;
End;

Procedure TfrmFullResSpecial.MnuActualSize2Click(Sender: Tobject);
Begin
  Mag4Viewer1.Fit1to1;
//93 application.processmessages;
//gek 93 Stop Automatic Mouse Pan   Mag4Viewer1.MousePan;
End;

Procedure TfrmFullResSpecial.MnuZoom1Click(Sender: Tobject);
Var
  IObj: TImageData;
  Enableable: Boolean;
Begin
        {   Main Menu is different that popup,  Here we have to check for NIL}
  IObj := Mag4Viewer1.GetCurrentImageObject;
  Enableable := (IObj <> Nil) Or ((Mag4Viewer1.GetImageCount > 0) And (Mag4Viewer1.ApplyToAll));
  MnuFittoWidht1.Enabled := Enableable;
  MnuFittoHeight1.Enabled := Enableable;
  MnuFittoWindow1.Enabled := Enableable;
  MnuActualSize1.Enabled := Enableable;
End;

Procedure TfrmFullResSpecial.MnuFittoWidht1Click(Sender: Tobject);
Begin
  Mag4Viewer1.FitToWidth;
End;

Procedure TfrmFullResSpecial.MnuFittoHeight1Click(Sender: Tobject);
Begin
  Mag4Viewer1.FitToHeight;
End;

Procedure TfrmFullResSpecial.MnuFittoWindow1Click(Sender: Tobject);
Begin
  Mag4Viewer1.FitToWindow;
End;

Procedure TfrmFullResSpecial.MnuActualSize1Click(Sender: Tobject);
Begin
  Mag4Viewer1.Fit1to1;
End;

Procedure TfrmFullResSpecial.mnuHelpFullResSpecialClick(Sender: Tobject);
Begin
  Application.HelpContext(HelpContext);
End;

Procedure TfrmFullResSpecial.MnuLockImageSize1Click(Sender: Tobject);
Begin
  MnuLockImageSize1.Checked := Not MnuLockImageSize1.Checked;
  Mag4Viewer1.LockSize := MnuLockImageSize1.Checked;
End;

Procedure TfrmFullResSpecial.RowCol1Click(Sender: Tobject);
Begin
  MnuTileAll1.Enabled := (Mag4Viewer1.GetImageCount > 0);
  {
  maggmsgf.MagMsg('s','horizScroll pos = '+  inttostr(mag4viewer1.scrlV.HorzScrollBar.Position));
  maggmsgf.MagMsg('s','horizScroll ScrollPos = '+  inttostr(mag4viewer1.scrlV.HorzScrollBar.ScrollPos ));
  maggmsgf.MagMsg('s','horizScroll range = '+  inttostr(mag4viewer1.scrlV.HorzScrollBar.Range ));
  maggmsgf.MagMsg('s','ScrollBox width = '+  inttostr(mag4viewer1.scrlV.Width ));
  }
  //LogMsg('s','horizScroll pos = '+  inttostr(mag4viewer1.scrlV.HorzScrollBar.Position));
  MagAppMsg('s', 'horizScroll pos = ' + Inttostr(Mag4Viewer1.Scrlv.HorzScrollBar.Position)); {JK 10/6/2009 - Maggmsgu refactoring}
  //LogMsg('s','horizScroll ScrollPos = '+  inttostr(mag4viewer1.scrlV.HorzScrollBar.ScrollPos ));
  MagAppMsg('s', 'horizScroll ScrollPos = ' + Inttostr(Mag4Viewer1.Scrlv.HorzScrollBar.ScrollPos)); {JK 10/6/2009 - Maggmsgu refactoring}
  //LogMsg('s','horizScroll range = '+  inttostr(mag4viewer1.scrlV.HorzScrollBar.Range ));
  MagAppMsg('s', 'horizScroll range = ' + Inttostr(Mag4Viewer1.Scrlv.HorzScrollBar.Range)); {JK 10/6/2009 - Maggmsgu refactoring}
  //LogMsg('s','ScrollBox width = '+  inttostr(mag4viewer1.scrlV.Width ));
  MagAppMsg('s', 'ScrollBox width = ' + Inttostr(Mag4Viewer1.Scrlv.Width)); {JK 10/6/2009 - Maggmsgu refactoring}

//mnuPreviousViewerPage1.enabled := (mag4viewer1.scrlV.HorzScrollBar.Position > 0);
//mnuNextViewerPage1.enabled := (mag4viewer1.scrlV.HorzScrollBar.Position > 0);

End;

{/ P122 - JK 8/1/2011 /}
function TfrmFullResSpecial.CheckIfAnnotsModified: Boolean;
var
  SaveAnnotResult: TAnnotWindowCloseAction;
begin
  Result := True;

  if Mag4Viewer1.GetCurrentImage.AnnotationComponent.AnnotsModified then
  begin
    SaveAnnotResult := Mag4Viewer1.GetCurrentImage.AnnotationComponent.SaveAnnotationLayer(True);
    if SaveAnnotResult = awCancel then
      Result := False;
  end;

end;

Procedure TfrmFullResSpecial.MnuMaximize1Click(Sender: Tobject);
Begin
  Mag4Viewer1.MaximizeImage := True;
End;

Procedure TfrmFullResSpecial.FormClose(Sender: Tobject; Var action: TCloseAction);
Begin
  {/ P122 - JK 8/1/2011 /}
  if Mag4Viewer1.GetCurrentImage <> nil then
    if Mag4Viewer1.GetCurrentImage.AnnotationComponent <> nil then
      if Mag4Viewer1.GetCurrentImage.AnnotationComponent.IsAnnotationMode then
        if CheckIfAnnotsModified then
          Mag4Viewer1.GetCurrentImage.AnnotationComponent.Hide
        else
        begin
          action := caNone;
          Exit;
        end;


  Mag4Viewer1.ClearViewer;
  SaveINISettings;
//Mag4Viewer1.UnDoListClear;
  action := caFree;
End;

procedure TfrmFullResSpecial.RadioGroup1Click(Sender: TObject);
begin
case RadioGroup1.ItemIndex  of
 0: DisplayNormal;
 1: DisplayRasterized;
 else DisplayNormal;
 end;
end;


Procedure TfrmFullResSpecial.RealignImages1Click(Sender: Tobject);
Begin
  TimerReSize.Enabled := False;
  Application.Processmessages;
  Mag4Viewer1.ReAlignImages();
End;

Procedure TfrmFullResSpecial.MnuPage1Click(Sender: Tobject);
Var
  Imagestate: TMagImageState;
Begin
  Imagestate := (Mag4Viewer1.GetCurrentImage).GetState;
  MnuFirstPage.Enabled := (Imagestate = Nil) Or (Imagestate.Page > 1);
  MnuPreviousPage.Enabled := (Imagestate = Nil) Or (Imagestate.Page > 1);
  MnuNextPage.Enabled := (Imagestate = Nil) Or (Imagestate.Page < Imagestate.PageCount);
  MnuLastPage.Enabled := (Imagestate = Nil) Or (Imagestate.Page < Imagestate.PageCount);
End;

Procedure TfrmFullResSpecial.MnuFirstPageClick(Sender: Tobject);
Begin
  Mag4Viewer1.PageFirstImage;
  MagViewerTB1.UpdateImageState;
End;

Procedure TfrmFullResSpecial.MnuPreviousPageClick(Sender: Tobject);
Begin
  Mag4Viewer1.PagePrevImage;
  MagViewerTB1.UpdateImageState;
End;

Procedure TfrmFullResSpecial.MnuNextPageClick(Sender: Tobject);
Begin
  Mag4Viewer1.PageNextImage;
  MagViewerTB1.UpdateImageState;
End;

Procedure TfrmFullResSpecial.MnuLastPageClick(Sender: Tobject);
Begin
  Mag4Viewer1.PageLastImage;
  MagViewerTB1.UpdateImageState;
End;

Procedure TfrmFullResSpecial.MnuFlipVertical1Click(Sender: Tobject);
Begin
  Mag4Viewer1.FlipVert;
End;

Procedure TfrmFullResSpecial.MnuFlipHoriz1Click(Sender: Tobject);
Begin
  Mag4Viewer1.FlipHoriz;
End;

Procedure TfrmFullResSpecial.MnuPrint1Click(Sender: Tobject);
Begin
  ImagePrintSpecial;
End;



Procedure TfrmFullResSpecial.ImagePrintSpecial;              {BM-ImagePrint- calls ImagePrintEsigReason}
Var
  s: String;
  VGear: TMag4VGear;
Begin
  VGear := Mag4Viewer1.GetCurrentImage;
  If VGear <> Nil Then
  Begin
    StbarInfo.Panels[1].Text := 'Printing: ' + VGear.PI_ptrData.ExpandedDescription + ' . . . ';
    ImagePrintEsigReason(VGear);      
    StbarInfo.Panels[1].Text := '';
    MagViewerTB1.UpdateImageState;  //p122t7 update the toolbar after printing multipage image
    VGear.UpdateImageDescriptionAfterPrint; //p122t7
  End;
End;

Procedure TfrmFullResSpecial.MnuCopy1Click(Sender: Tobject);
Begin
  ImageCopyFullWin;
End;

Procedure TfrmFullResSpecial.ImageCopyFullWin;
Var
  s: String;
  VGear: TMag4VGear;
Begin
  VGear := Mag4Viewer1.GetCurrentImage;
  If VGear <> Nil Then
  Begin
    StbarInfo.Panels[1].Text := 'Copying: ' + VGear.PI_ptrData.ExpandedDescription + ' . . . ';
    Try
      ImageCopyEsigReason(VGear);
      StbarInfo.Panels[1].Text := '';
    Except
      On e: Exception Do
      Begin
        StbarInfo.Panels[1].Text := 'Error Copying: ' + e.Message;
      End;
    End;
  End;
End;

Procedure TfrmFullResSpecial.MnuDefaultLayout1Click(Sender: Tobject);
Begin
  Mag4Viewer1.ApplyDefaultLayout;
End;

Procedure TfrmFullResSpecial.ZoomIn1Click(Sender: Tobject);
Begin
  MagViewerTB1.TbicZoom.Position := MagViewerTB1.TbicZoom.Position + 20;
End;

Procedure TfrmFullResSpecial.ZoomOut1Click(Sender: Tobject);
Begin
  MagViewerTB1.TbicZoom.Position := MagViewerTB1.TbicZoom.Position - 20;
  MagViewerTB1.UpdateImageState;
End;

Procedure TfrmFullResSpecial.MnuNextViewerPage1Click(Sender: Tobject);
Begin
  Mag4Viewer1.PageNextViewerFocus;
End;

Procedure TfrmFullResSpecial.MnuPreviousViewerPage1Click(Sender: Tobject);
Begin
  Mag4Viewer1.PagePrevViewerFocus;
End;

Procedure TfrmFullResSpecial.ZoomIn2Click(Sender: Tobject);
Begin
  MagViewerTB1.TbicZoom.Position := MagViewerTB1.TbicZoom.Position + 20;
End;

Procedure TfrmFullResSpecial.ZoomOutShiftCtrlO1Click(Sender: Tobject);
Begin
  MagViewerTB1.TbicZoom.Position := MagViewerTB1.TbicZoom.Position - 20;
End;

Procedure TfrmFullResSpecial.Mnu6ptClick(Sender: Tobject);
Begin
  Mag4Viewer1.ImageFontSize := 6;
End;

Procedure TfrmFullResSpecial.Mnu7ptClick(Sender: Tobject);
Begin
  Mag4Viewer1.ImageFontSize := 7;
End;

Procedure TfrmFullResSpecial.Mnu8ptClick(Sender: Tobject);
Begin
  Mag4Viewer1.ImageFontSize := 8;
End;

Procedure TfrmFullResSpecial.Mnu10ptClick(Sender: Tobject);
Begin
  Mag4Viewer1.ImageFontSize := 10;
End;

Procedure TfrmFullResSpecial.Mnu12ptClick(Sender: Tobject);
Begin
  Mag4Viewer1.ImageFontSize := 12;
End;

Procedure TfrmFullResSpecial.MnuFontSize2Click(Sender: Tobject);
Var
  i, Size: Integer;
Begin
// Check the submenu item that is relevant;
  Size := Mag4Viewer1.ImageFontSize;
  For i := 0 To MnuFontSize2.Count - 1 Do
    If MnuFontSize2[i].Tag = Size Then
    Begin
      If Not (MnuFontSize2[i].Checked) Then MnuFontSize2[i].Checked := True;
    End
    Else
      If MnuFontSize2[i].Checked Then MnuFontSize2[i].Checked := False;
End;

Procedure TfrmFullResSpecial.MnuPointer2Click(Sender: Tobject);
Begin
  Mag4Viewer1.MouseReSet;
End;

Procedure TfrmFullResSpecial.MnuMousePointer2Click(Sender: Tobject);
Begin
  Mag4Viewer1.MouseReSet;
End;

Procedure TfrmFullResSpecial.Mag4Viewer1EndDock(Sender, Target: Tobject; x, y: Integer);
Begin
  Mag4Viewer1.FrameEndDock(Sender, Target, x, y);
End;

Procedure TfrmFullResSpecial.MnuAbdomenClick(Sender: Tobject);
Begin
  Mag4Viewer1.WinLevValue(350, 1040);
End;

Procedure TfrmFullResSpecial.MnuBoneClick(Sender: Tobject);
Begin
  Mag4Viewer1.WinLevValue(500, 1274);
//applyctpreset('Bone|500|1274'
End;

Procedure TfrmFullResSpecial.MnuDiskClick(Sender: Tobject);
Begin
//applyctpreset('Disk|950|1240'
  Mag4Viewer1.WinLevValue(950, 1240);
End;

Procedure TfrmFullResSpecial.MnuHeadClick(Sender: Tobject);
Begin
//applyctpreset('Head|80|1040'
  Mag4Viewer1.WinLevValue(80, 1040);
End;

Procedure TfrmFullResSpecial.MnuLungClick(Sender: Tobject);
Begin
//applyctpreset('Lung|1000|300'
  Mag4Viewer1.WinLevValue(1000, 300);
End;

Procedure TfrmFullResSpecial.MnuMediastinumClick(Sender: Tobject);
Begin
//applyctpreset('Mediastinum|500|1040'
  Mag4Viewer1.WinLevValue(500, 1040);
End;

(*  applyctpreset...
minvar, maxvar: olevariant;
begin
paged := 0; {RED 02/02/03}
nochange := 1; {RED 02/21/03}
//changeonly1 := -1; {apply win, level changes to 1 window only}
  for i := startct to endct do
    begin
    setwindowlevel(adicomrec[i].gearcontrol,adicomrec[i].medcontrol, window, level, i, maxvar, minvar, true);
*)

(*
  function setwindowlevel(gearcontrol: tgear; medcontrol: tmed; window, level: longint; winnum: integer; var max, min: olevariant; setstate: boolean): integer;
{setstate = true then set position on scrollbars}
var
reserved: olevariant;
j: longint;
begin
j := level - round(window/2);
min := j;              {black}
j := level + round(window/2);
max := j;              {white}
DisplayCenterWidth(gearcontrol, medcontrol, level, window, winnum);
//Medcontrol.DisplayWindowLevel(min, max, reserved);
gearcontrol.redraw := true;
*)

(*
function DisplayCenterWidth(gearcontrol: TGear; medcontrol: TMed; center, width: longint; winnum: integer): integer;
var
black1, white1, reserved: olevariant;

begin
    black1 := center - (width div 2); {RED 01/21/03 added round}
    white1 := center + (width div 2);
    TrMedDisplayWindowLevel(adicomrec[winnum].medcontrol, black1, white1, reserved)
end;
*)

(*
function TrMedDisplayWindowLevel(medcontrol: TMed; Var Min, Max, Reserved: olevariant): integer;
begin
medcontrol.DisplayWindowLevel(min, max, reserved);
end;
*)

Procedure TfrmFullResSpecial.MnuundoactionClick(Sender: Tobject);
Begin
//mag4Viewer1.UnDoActionExecute;
End;

Procedure TfrmFullResSpecial.Mag4Viewer1ListChange(Sender: Tobject);
Var
  i: Integer;
  s: String;
Begin

  i := Mag4Viewer1.GetImageCount;
  If i = 1 Then
    s := ' Image'
  Else
    s := ' Images';
  StbarInfo.Panels[0].Text := Inttostr(i) + s;
End;

Procedure TfrmFullResSpecial.MnuRefreshClick(Sender: Tobject);
Begin
 // Mag4Viewer1.ReFreshImages;
 Displaynormal;
End;

Procedure TfrmFullResSpecial.DeSkewSmooth1Click(Sender: Tobject);
Begin
  Mag4Viewer1.DeSkewAndSmooth;
End;

Procedure TfrmFullResSpecial.MagViewerTB1oldPrintClick(Sender: Tobject;
  Viewer: IMag4Viewer);
Begin
  ImagePrintSpecial();
End;

Procedure TfrmFullResSpecial.MagViewerTB1oldCopyClick(Sender: Tobject;
  Viewer: IMag4Viewer);
Begin
  ImageCopyFullWin();
End;

{JK 3/30/2009 - procedures mnuContrastPClick, mnuContrastMClick,
 mnuBrightnessPClick, and mnuBrightnessMClick were swapped and
 altered to fix IR dated 3-2-09
}

Procedure TfrmFullResSpecial.MnuContrastPClick(Sender: Tobject);
Begin
  With MagViewerTB1 Do
  Begin
    If ((TbicContrast.Position + 5) > TbicContrast.Max) Then
      TbicContrast.Position := TbicContrast.Max
    Else
      TbicContrast.Position := TbicContrast.Position + 5;

  End;
End;

Procedure TfrmFullResSpecial.MnuContrastMClick(Sender: Tobject);
Begin
  With MagViewerTB1 Do
  Begin
    If ((TbicContrast.Position - 5) < TbicContrast.Min) Then
      TbicContrast.Position := TbicContrast.Min
    Else
      TbicContrast.Position := TbicContrast.Position - 5;

  End;
End;

Procedure TfrmFullResSpecial.MnuBrightnessPClick(Sender: Tobject);
Begin
  With MagViewerTB1 Do
  Begin
    If ((TbicBrightness.Position + 15) > TbicBrightness.Max) Then
      TbicBrightness.Position := TbicBrightness.Max
    Else
      TbicBrightness.Position := TbicBrightness.Position + 15;
  End;
End;

Procedure TfrmFullResSpecial.MnuBrightnessMClick(Sender: Tobject);
Begin
  With MagViewerTB1 Do
  Begin
    If ((TbicBrightness.Position - 15) < TbicBrightness.Min) Then
      TbicBrightness.Position := TbicBrightness.Min
    Else
      TbicBrightness.Position := TbicBrightness.Position - 15;

  End;
End;

Procedure TfrmFullResSpecial.MnuScrollToCornerBLClick(Sender: Tobject);
Begin
  Mag4Viewer1.ScrollCornerBL;
End;

Procedure TfrmFullResSpecial.MnuScrollToCornerBRClick(Sender: Tobject);
Begin
  Mag4Viewer1.ScrollCornerBR;
End;

Procedure TfrmFullResSpecial.MnuScrollToCornerTLClick(Sender: Tobject);
Begin
  Mag4Viewer1.ScrollCornerTL;
End;

Procedure TfrmFullResSpecial.MnuScrollToCornerTRClick(Sender: Tobject);
Begin
  Mag4Viewer1.ScrollCornerTR
End;

Procedure TfrmFullResSpecial.PreviousImage1Click(Sender: Tobject);
Begin
  Mag4Viewer1.SelectNextImage(-1);
End;

Procedure TfrmFullResSpecial.NextImage1Click(Sender: Tobject);
Begin
  Mag4Viewer1.SelectNextImage;
End;

Procedure TfrmFullResSpecial.MnuScrollLeftClick(Sender: Tobject);
Begin
  Mag4Viewer1.ScrollLeft
End;

Procedure TfrmFullResSpecial.MnuScrollRightClick(Sender: Tobject);
Begin
  Mag4Viewer1.ScrollRight
End;

Procedure TfrmFullResSpecial.MnuScrollUpClick(Sender: Tobject);
Begin
  Mag4Viewer1.ScrollUp
End;

Procedure TfrmFullResSpecial.MnuScrollDownClick(Sender: Tobject);
Begin
  Mag4Viewer1.ScrollDown
End;

Procedure TfrmFullResSpecial.FlipHorizontal1Click(Sender: Tobject);
Begin
  Mag4Viewer1.FlipHoriz;
End;

Procedure TfrmFullResSpecial.FlipVertical1Click(Sender: Tobject);
Begin
  Mag4Viewer1.FlipVert;
End;

Procedure TfrmFullResSpecial.ActiveForms1Click(Sender: Tobject);
Begin
  SwitchToForm;
End;

Procedure TfrmFullResSpecial.ShortcutMenu1Click(Sender: Tobject);
Var
  Pt: TPoint;
Begin
  Pt.x := Mag4Viewer1.Left;
  Pt.y := Mag4Viewer1.Top;
  Pt := Mag4Viewer1.ClientToScreen(Pt);
  PopupVImage.PopupComponent := Mag4Viewer1.GetCurrentImage;
  PopupVImage.Popup(Pt.x, Pt.y);
End;

Procedure TfrmFullResSpecial.ClearAll1Click(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.ClearAllAnnotations();
End;

Procedure TfrmFullResSpecial.ClearSelecetd1Click(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.ClearSelectedAnnotations();
End;

Procedure TfrmFullResSpecial.Undo1Click(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.Undo();
End;

Procedure TfrmFullResSpecial.Cut1Click(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.Cut();
End;

Procedure TfrmFullResSpecial.Copy1Click(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.Copy();
End;

Procedure TfrmFullResSpecial.Paste1Click(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.Paste();
End;

Procedure TfrmFullResSpecial.SelectAll1Click(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SelectAll();
End;

Procedure TfrmFullResSpecial.Open1Click(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SetArrowPointer(MagAnnArrowOpen);
End;

Procedure TfrmFullResSpecial.Pointer1Click(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SetArrowPointer(MagAnnArrowPointer);
End;

Procedure TfrmFullResSpecial.SolidPointer1Click(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SetArrowPointer(MagAnnArrowPointerSolid);
End;

procedure TfrmFullResSpecial.btnPrintClick(Sender: TObject);
begin
  ImagePrintSpecial;
  Close;
end;

procedure TfrmFullResSpecial.DisplayNormal;
begin
  // non rasterize
if radioGroup1.itemindex <> 0 then
   begin
    RadioGroup1.ItemIndex := 0;
    exit;
   end;
lbOptionsMsg.Caption := 'Refreshing Image...';
lbOptionsMsg.Update;
mag4Viewer1.ReFreshImages;
application.ProcessMessages;
lbOptionsmsg.Caption := 'Image Display is Normal';

end;

procedure TfrmFullResSpecial.DisplayRasterized;
var vGear : Tmag4Vgear;
begin
lbOptionsMsg.Caption := 'converting to Bitmap Image...';
lbOptionsMsg.Update;
//rasterize
vGear :=  Mag4Viewer1.GetCurrentImage;
vGear.rasterizeview;
vGear.ReDrawImage;
//Mag4Viewer1.Repaint;
lbOptionsmsg.Caption := 'Image is converted to Bitmap';
end;



Procedure TfrmFullResSpecial.Solid1Click(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SetArrowPointer(MagAnnArrowSolid);
End;

Procedure TfrmFullResSpecial.Small1Click(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SetArrowLength(MagAnnArrowSizeSmall);
End;

Procedure TfrmFullResSpecial.Medium1Click(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SetArrowLength(MagAnnArrowSizeMedium);
End;

Procedure TfrmFullResSpecial.Long1Click(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SetArrowLength(MagAnnArrowSizeLarge);
End;

Procedure TfrmFullResSpecial.AnnotationsOpaque1Click(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SetOpaque(True);
  AnnotationsOpaque1.Checked := True;
  AnnotationsTranslucent1.Checked := False;
End;

Procedure TfrmFullResSpecial.AnnotationsTranslucent1Click(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SetOpaque(False);
  AnnotationsOpaque1.Checked := False;
  AnnotationsTranslucent1.Checked := True;
End;

Procedure TfrmFullResSpecial.Hin1Click(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SetLineWidth(MagAnnLineWidthThin);
End;

Procedure TfrmFullResSpecial.Medium2Click(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SetLineWidth(MagAnnLineWidthMedium);
End;

Procedure TfrmFullResSpecial.Hick1Click(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SetLineWidth(MagAnnLineWidthThick);
End;

Procedure TfrmFullResSpecial.MnuAnnotationPointerClick(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SetTool(MagAnnToolPointer);
End;

Procedure TfrmFullResSpecial.MnuAnnotationFreehandLineClick(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SetTool(MagAnnToolFreehandLine);
End;

Procedure TfrmFullResSpecial.MnuAnnotationStraightLineClick(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SetTool(MagAnnToolStraightLine);
End;

Procedure TfrmFullResSpecial.MnuAnnotationFilledRectangleClick(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SetTool(MagAnnToolFilledRectangle);
End;

Procedure TfrmFullResSpecial.MnuAnnotationHollowRectangleClick(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SetTool(MagAnnToolHollowRectangle);
End;

Procedure TfrmFullResSpecial.MnuAnnotationFilledEllipseClick(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SetTool(MagAnnToolFilledEllipse);
End;

Procedure TfrmFullResSpecial.MnuAnnotationHollowEllipseClick(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SetTool(MagAnnToolHollowEllipse);
End;

Procedure TfrmFullResSpecial.MnuAnnotationTypedTextClick(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SetTool(MagAnnToolTypedText);
End;

Procedure TfrmFullResSpecial.MnuAnnotationArrowClick(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SetTool(MagAnnToolArrow);
End;

Procedure TfrmFullResSpecial.MnuAnnotationProtractorClick(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SetTool(MagAnnToolProtractor);
End;

Procedure TfrmFullResSpecial.MnuAnnotationRulerClick(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SetTool(MagAnnToolRuler);
End;

Procedure TfrmFullResSpecial.MnuAnnotationPlusClick(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SetTool(MagAnnToolPlus);
End;

Procedure TfrmFullResSpecial.MnuAnnotationMinusClick(Sender: Tobject);
Begin
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SetTool(MagAnnToolMinus);
End;

Procedure TfrmFullResSpecial.ExtFont1Click(Sender: Tobject);
Var
  FontName: String;
  FontSize: Integer;
  IsBold, IsItalic: Boolean;
Begin
  If Mag4Viewer1.GetCurrentImage = Nil Then Exit;
  If Mag4Viewer1.GetCurrentImage.AnnotationComponent = Nil Then Exit;
  FontDialog1.Font := Mag4Viewer1.GetCurrentImage.AnnotationComponent.GetFont();
  If Not FontDialog1.Execute() Then Exit;
  FontSize := FontDialog1.Font.Size;
  FontName := FontDialog1.Font.Name;
  If Fsbold In FontDialog1.Font.Style Then
    IsBold := True
  Else
    IsBold := False;
  If Fsitalic In FontDialog1.Font.Style Then
    IsItalic := True
  Else
    IsItalic := False;
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SetFont(FontName, FontSize, IsBold, IsItalic);
End;

Procedure TfrmFullResSpecial.AnnotationColor1Click(Sender: Tobject);
Begin
  If Mag4Viewer1.GetCurrentImage = Nil Then Exit;
  If Mag4Viewer1.GetCurrentImage.AnnotationComponent = Nil Then Exit;
  ColorDialog1.Color := Mag4Viewer1.GetCurrentImage.AnnotationComponent.GetColor();
  If Not ColorDialog1.Execute() Then Exit;
  Mag4Viewer1.GetCurrentImage.AnnotationComponent.SetAnnotationColor(ColorDialog1.Color);

End;

Procedure TfrmFullResSpecial.PanWindowCloseEvent(Sender: Tobject);
Begin
//out in 93 with isi TB  magViewerTB1.DisablePanWindow();
End;

Procedure TfrmFullResSpecial.MagViewerTB1CopyClick(Sender: Tobject;
  Viewer: TMag4Viewer);
Begin
  ImageCopyFullWin;
End;

Procedure TfrmFullResSpecial.MagViewerTB1PrintClick(Sender: Tobject;
  Viewer: TMag4Viewer);
Begin
  ImagePrintSpecial;
End;

End.
