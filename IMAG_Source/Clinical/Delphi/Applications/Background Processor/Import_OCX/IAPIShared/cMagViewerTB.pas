{$A8,B-,C-,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00008000}
{$MAXSTACKSIZE $00180000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE ON}
{$WARN UNSAFE_CODE ON}
{$WARN UNSAFE_CAST ON}
Unit cMagViewerTB;
  {
   Package: MAG - VistA Imaging
 WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
 Date Created:
 Site Name: Silver Spring, OIFO
 Developers: Garrett Kirin
[== unit cMagViewerTB;
 Description: Image Viewer ToolBar.
 The Viewer toolbar is designed as a standalone component rather than be encomposed
 in the Viewer itself.  It has a property MagViewer: TMag4Viewer that connects the
 Viewer Toolbar to an Image Viewer.  The Viewer Toolbar can control multiple
 viewers by changing the MagViewer property, and querrying the Viewer for current
 state.
 The original design of TMag4Viewer and TMagViewerTB was to have multiple toolbar
 components, each specific to an image Type. When Images are loaded into a viewer,
 certain Toolbars would be enabled/disabled or made visible/nonVisible depending on
 what types of Images were being viewed.
 That design isn't implemented.  The Viewer Toolbar component has controls that
 execute functions for document and color images.  i.e. Non - Dicom.
 The RadWindow has all functionality to handle Dicom Images.

 The Toolbuttons execute methods of the Viewer.  The Viewer is responsible for
 applying the methods to the appropriate images.

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
Interface

Uses
  Classes,
  cMag4Vgear,
  //cmagLogManager, {JK 10/5/2009 - Maggmsgu refactoring - deprecated unit}
  ComCtrls,
  Controls,
  ExtCtrls,
{$IFDEF USENEWANNOTS}
  FMagAnnot,
{$ELSE}
  FMagAnnotationToolbar,
{$ENDIF}
  Forms,
  IMagViewer,
  Menus,
  Stdctrls,
  UMagDefinitions,
  ImgList,
  ToolWin
  ;

//Uses Vetted 20090929:Buttons, cMagVUtils, ImgList, ToolWin, Dialogs, Graphics, Messages, uMagClasses, SysUtils, Windows

Type
    {Print command to be executed by parent window, not ToolBar to Viewer}
  TMagPrintClickEvent = Procedure(Sender: Tobject; Viewer: IMag4Viewer) Of Object;
  TMagCopyClickEvent = Procedure(Sender: Tobject; Viewer: IMag4Viewer) Of Object;

  TMagViewerTB = Class(TFrame)
    TbarViewer: TToolBar;
    Tbpagecontrols: TToolButton;
    Tbsliders: TToolButton;
    TbApplyToAll: TToolButton;
    TbReset: TToolButton;
    TbFitWin: TToolButton;
    TbFitHeight: TToolButton;
    TbFitWidth: TToolButton;
    TbReverse: TToolButton;
    Tb270: TToolButton;
    Tb90: TToolButton;
    TbMousePan: TToolButton;
    TbPanWindow1: TToolButton;
    TbMouseZoomRect: TToolButton;
    TbMouseMagnify: TToolButton;
    TbReport: TToolButton;
    TbNew: TToolButton;
    TbTile: TToolButton;
    ImageList3: TImageList;
    TbFit1to1: TToolButton;
    TbFlipVert: TToolButton;
    TbFlipHoriz: TToolButton;
    TbViewerSettings: TToolButton;
    PopupViewerStyles: TPopupMenu;
    StaticPages1: TMenuItem;
    Virtual1: TMenuItem;
    Dynamiccustom1: TMenuItem;
    TbClearViewer: TToolButton;
    TbRemoveImage: TToolButton;
    PopupRowCol: TPopupMenu;
    MnuLockSize: TMenuItem;
    MnuReAlign: TMenuItem;
    MnuToggleSelected: TMenuItem;
    MnuRemoveImages: TMenuItem;
    N1: TMenuItem;
    MnuNewViewerX: TMenuItem;
    MnuShowAllX: TMenuItem;
    MnuClearbeforeAddImage: TMenuItem;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    PicZoom: Tpanel;
    Label10: Tlabel;
    LicZoom: Tlabel;
    TbicZoom: TTrackBar;
    TbPrintImage: TToolButton;
    TbCopyImage: TToolButton;
    PnlPage: Tpanel;
    TblbPageCount: Tlabel;
    TbePage: TEdit;
    TbtnPagePrev: TToolButton;
    TbtnPageLast: TToolButton;
    TbtnPageNext: TToolButton;
    btnPageFirst: TToolButton;
    ToolButton14: TToolButton;
    TbMaximize: TToolButton;
    ToolButton10: TToolButton;
    N1x1: TMenuItem;
    N2x1: TMenuItem;
    N3x1: TMenuItem;
    N4x1: TMenuItem;
    N1x2: TMenuItem;
    N2x2: TMenuItem;
    N3x2: TMenuItem;
    N4x2: TMenuItem;
    N1x3: TMenuItem;
    N2x3: TMenuItem;
    N3x3: TMenuItem;
    N4x3: TMenuItem;
    N1x4: TMenuItem;
    N2x4: TMenuItem;
    N3x4: TMenuItem;
    N4x4: TMenuItem;
    TbRefresh: TToolButton;
    ToolButton1: TToolButton;
    TbMousePointer: TToolButton;
    TbtnImageFirst: TToolButton;
    TbtnImagePrev: TToolButton;
    TbtnImageNext: TToolButton;
    TbtnImageLast: TToolButton;
    Panel2: Tpanel;
    TblbImageCount: Tlabel;
    TbBrightMore: TToolButton;
    TbBrightLess: TToolButton;
    TbContrastMore: TToolButton;
    TbContrastLess: TToolButton;
    TrbZoomIn: TToolButton;
    TbZoomOut: TToolButton;
    ToolButton9: TToolButton;
    ToolButton16: TToolButton;
    ToolBar1: TToolBar;
    PanelProtytype: Tpanel;
    Panel1: Tpanel;
    ComboBox1: TComboBox;
    TbAnnotations: TToolButton;
    ToolButton2: TToolButton;
    PnlWinLev: Tpanel;
    TbicWin: TTrackBar;
    TbicLev: TTrackBar;
    Lbllev: Tlabel;
    LblWin: Tlabel;
    btnAutoWinLev: TToolButton;
    LblWinValue: Tlabel;
    LblLevValue: Tlabel;
    TbRuler: TToolButton;
    TbRulerPointer: TToolButton;
    TbProtractor: TToolButton;
    Procedure TbApplyToAllClick(Sender: Tobject);
    Procedure TbFitHeightClick(Sender: Tobject);
    Procedure TbReverseClick(Sender: Tobject);
    Procedure TbFitWidthClick(Sender: Tobject);
    Procedure Tb270Click(Sender: Tobject);
    Procedure Tb90Click(Sender: Tobject);
    Procedure TbMousePanClick(Sender: Tobject);
    Procedure TbPanWindow1Click(Sender: Tobject);
    Procedure TbMouseZoomRectClick(Sender: Tobject);
    Procedure TbMouseMagnifyClick(Sender: Tobject);
    Procedure TbTileClick(Sender: Tobject);
    Procedure TbarViewerResize(Sender: Tobject);
    Procedure TbFitWinClick(Sender: Tobject);
    Procedure TbFit1to1Click(Sender: Tobject);
    Procedure TbFlipVertClick(Sender: Tobject);
    Procedure TbFlipHorizClick(Sender: Tobject);
    Procedure StaticPages1Click(Sender: Tobject);
    Procedure Virtual1Click(Sender: Tobject);
    Procedure Dynamiccustom1Click(Sender: Tobject);
    Procedure TbViewerSettingsClick(Sender: Tobject);
    Procedure TbRemoveImageClick(Sender: Tobject);
    Procedure TbClearViewerClick(Sender: Tobject);
    Procedure PopupRowColPopup(Sender: Tobject);
    Procedure MnuLockSizeClick(Sender: Tobject);
    Procedure MnuToggleSelectedClick(Sender: Tobject);
    Procedure MnuRemoveImagesClick(Sender: Tobject);
    Procedure MnuClearbeforeAddImageClick(Sender: Tobject);
    Procedure TbicZoomChange(Sender: Tobject);
    Procedure TbPrintImageClick(Sender: Tobject);
    Procedure TbCopyImageClick(Sender: Tobject);
    Procedure TbReportClick(Sender: Tobject);
    Procedure btnPageFirstClick(Sender: Tobject);
    Procedure TbtnPagePrevClick(Sender: Tobject);
    Procedure TbtnPageNextClick(Sender: Tobject);
    Procedure TbtnPageLastClick(Sender: Tobject);
    Procedure TbePageClick(Sender: Tobject);
    Procedure TbePageEnter(Sender: Tobject);
    Procedure TbePageKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure TbePageKeyUp(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure TbResetClick(Sender: Tobject);
    Procedure TbMaximizeClick(Sender: Tobject);
    Procedure N1x1Click(Sender: Tobject);
    Procedure N2x1Click(Sender: Tobject);
    Procedure N3x1Click(Sender: Tobject);
    Procedure N4x1Click(Sender: Tobject);
    Procedure N1x2Click(Sender: Tobject);
    Procedure N2x2Click(Sender: Tobject);
    Procedure N3x2Click(Sender: Tobject);
    Procedure N4x2Click(Sender: Tobject);
    Procedure N1x3Click(Sender: Tobject);
    Procedure N2x3Click(Sender: Tobject);
    Procedure N3x3Click(Sender: Tobject);
    Procedure N4x3Click(Sender: Tobject);
    Procedure N1x4Click(Sender: Tobject);
    Procedure N2x4Click(Sender: Tobject);
    Procedure N3x4Click(Sender: Tobject);
    Procedure N4x4Click(Sender: Tobject);
    Procedure MnuReAlignClick(Sender: Tobject);
    Procedure TbRefreshClick(Sender: Tobject);
    Procedure TbMousePointerClick(Sender: Tobject);
    Procedure TbBrightMoreClick(Sender: Tobject);
    Procedure TbBrightLessClick(Sender: Tobject);
    Procedure TbContrastMoreClick(Sender: Tobject);
    Procedure TbContrastLessClick(Sender: Tobject);
    Procedure TrbZoomInClick(Sender: Tobject);
    Procedure TbZoomOutClick(Sender: Tobject);
    Procedure TbtnImageFirstClick(Sender: Tobject);
    Procedure TbtnImagePrevClick(Sender: Tobject);
    Procedure TbtnImageNextClick(Sender: Tobject);
    Procedure TbtnImageLastClick(Sender: Tobject);
    Procedure TbAnnotationsClick(Sender: Tobject);
    Procedure ToolButton2Click(Sender: Tobject);
    Procedure btnAutoWinLevClick(Sender: Tobject);
    Procedure TbicWinChange(Sender: Tobject);
    Procedure TbicLevChange(Sender: Tobject);
    Procedure TbRulerClick(Sender: Tobject);
    Procedure TbRulerPointerClick(Sender: Tobject);
    Procedure TbProtractorClick(Sender: Tobject);
  Protected
    FNoClickOnZoom: Boolean;
    FImagePageCount: Integer;
    FCurViewer: IMag4Viewer;

    //    FMagVUtils: TMagVUtils;
    FPrintClickEvent: TMagPrintClickEvent;
    FCopyClickEvent: TMagCopyClickEvent;
{$IFDEF USENEWANNOTS}
    AnnotationToolbar: TMagAnnot;
{$ELSE}
    AnnotationToolbar: TMagAnnotationToolbar;
{$ENDIF}
//    FRadiologyFunctions : boolean;

    //FOnLogEvent : TMagLogEvent; {JK 10/5/2009 - Maggmsgu refactoring}

    FWinLevScrollEnabled: Boolean;
    Procedure GoToNextPage;
    Procedure GoToPage(Pg: Integer);
    Procedure GoToPrevPage;
    Procedure SetRowCol(Row, Col: Integer);
    Procedure ApplyImageState(VGear: TMag4VGear); // 01/21/03  was imagestate  : Timagestate
    Procedure DisablePageControls(Imagestate: TMagImageState);
    Procedure ApplyViewerState(Viewer: IMag4Viewer);
    Procedure ApplyImageFunctions(VGear: TMag4VGear);
//    procedure setRadiologyFunctions(Value : boolean);

    //procedure LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);  {JK 10/6/2009 - Maggmsgu refactoring - remove old method}
    /// call after changing zoom w/ zoom to window, zoom to width, etc, updates the zoom scroll bar
    Procedure UpdateImageZoomState();
  Public

    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;

    {Called by associated form, or component :
    Viewer Toolbar will querry the Viewer then update it's controls,
    (brightness, Zoom value, page count etc) according to the state
    of the selected image }
    Procedure UpdateImageState;

    Procedure CheckMouseState(State: TMagImageMouse);
    Procedure DisablePanWindow();
  Published
    {Connect this Viewer Toolbar to a Viewer.}

    Property OnPrintClick: TMagPrintClickEvent Read FPrintClickEvent Write FPrintClickEvent;
    Property OnCopyClick: TMagCopyClickEvent Read FCopyClickEvent Write FCopyClickEvent;
//    property RadiologyFunctions : boolean read FRadiologyFunctions write setRadiologyFunctions;
    //property OnLogEvent : TMagLogEvent read FOnLogEvent write FOnLogEvent; {JK 10/5/2009 - Maggmsgu refactoring}
    Property MagViewer: IMag4Viewer Read FCurViewer Write FCurViewer;

  End;

Procedure Register;

Implementation
Uses
  SysUtils,
  UMagClasses,
  Windows
  ;

{$R *.DFM}

Procedure Register;
Begin
  RegisterComponents('Imaging', [TMagViewerTB]);
End;
{ TODO :
Enable Disable Buttons, based on if Fcurviewer is NIL.
and later, based on Selected Images in Fcurviewer. }

Procedure TMagViewerTB.TbApplyToAllClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.ApplyToAll := TbApplyToAll.Down;
End;

Procedure TMagViewerTB.TbFitHeightClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.FitToHeight;
  Application.Processmessages;
//gek 93 Stop Automatic Mouse Pan     if FcurViewer <> nil then FcurViewer.MousePan;
  FNoClickOnZoom := True;
  UpdateImageZoomState();
  FNoClickOnZoom := False;
End;

Procedure TMagViewerTB.TbReverseClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.Inverse;
End;

Procedure TMagViewerTB.TbFitWidthClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.FitToWidth;
  Application.Processmessages;
//gek 93 Stop Automatic Mouse Pan     if FcurViewer <> nil then FcurViewer.MousePan;
  FNoClickOnZoom := True;
  UpdateImageZoomState();
  FNoClickOnZoom := False;
End;

Procedure TMagViewerTB.Tb270Click(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.Rotate(270);
End;

Procedure TMagViewerTB.Tb90Click(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.Rotate(90);
End;

Procedure TMagViewerTB.TbMousePanClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then
    FCurViewer.MousePan;
  (*  // If we want to lock button down depending on Cursor Action
      //    also have to group buttons, and call them CheckButtons.
    if FcurViewer <> nil then
  if tbMousePan.down
    then FcurViewer.MousePan
    else FCurViewer.MouseReset;*)
  // if auto window/level was being used, change win/lev button to not down
  {
  if btnAutoWinLev.Down then
    btnAutoWinLev.Down := false;

    // this should be moved to a function!
  btnAutoWinLev.Down := false;
  tbRuler.Down := false;
  tbAnnotations.Down := false;
  tbRulerPointer.Down := false;
  }
End;

Procedure TMagViewerTB.TbMouseMagnifyClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then
    FCurViewer.MouseMagnify;
    {
  end
  else
  begin
    if FcurViewer <> nil then FcurViewer.MouseMagnify;
  end;
  }
  (*  // If we want to lock button down depending on Cursor Action
      //    also have to group buttons, and call them CheckButtons.
  if FcurViewer <> nil then
  if tbMouseMagnify.down
    then FcurViewer.MouseMagnify
    else FCurViewer.MouseReset;  *)
End;

Procedure TMagViewerTB.TbMouseZoomRectClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.MouseZoomRect;
End;

Procedure TMagViewerTB.TbPanWindow1Click(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.PanWindow := TbPanWindow1.Down;
End;

Procedure TMagViewerTB.TbTileClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.TileAll;
End;

Constructor TMagViewerTB.Create(AOwner: TComponent);
Begin
  Inherited;
  AutoSize := True;
{$IFDEF USENEWANNOTS}
  AnnotationToolbar := TMagAnnot.Create(Self);
{$ELSE}
  AnnotationToolbar := TMagAnnotationToolbar.Create(Self);
{$ENDIF}
  FWinLevScrollEnabled := True;
  // disable annotations for patch 72 (JMW 8/28/2006)
  TbAnnotations.Visible := False;

  btnAutoWinLev.Visible := False;

  TbRemoveImage.Visible := True;
  TbTile.Visible := True;
  TbClearViewer.Visible := True;
  ToolButton10.Visible := True;

  // hide paging buttons in Rad Viewer
  btnPageFirst.Visible := True;
  TbtnPagePrev.Visible := True;
  TbtnPageNext.Visible := True;
  TbtnPageLast.Visible := True;
  TbePage.Visible := True;
  TblbPageCount.Visible := True;

  TbRuler.Visible := False;
  TbProtractor.Visible := False;
  TbRulerPointer.Visible := False;

  TbMaximize.Visible := True;

  TbarViewer.Update;
   // JMW 7/24/08 p72t23 - not displaying the zoom value anymore for either
   // the rad viewer or full res viewer
  LicZoom.Visible := False;

End;

Destructor TMagViewerTB.Destroy;
Begin
//  LogMsg('s','TmagViewerTB.destroy', MagLogDEBUG);
//  if application.Terminated then exit;
//  inherited;
//  application.ProcessMessages();
 {

  count := (high(FViewerArray));
  for i := 0 to count do
  begin

    FViewerArray[i].getCurrentImage();
    FViewerArray[i] := nil;
  end;

  setLength(FViewerArray, 0);

//  FviewerArray := nil;

}
  FCurViewer := Nil;
  Inherited;
End;

Procedure TMagViewerTB.TbarViewerResize(Sender: Tobject);
Begin
  If (Align = altop) Then Height := TbarViewer.Height + 2;
  If (Width < TbarViewer.Width) Then
    If (Align = alLeft) Then Width := TbarViewer.Width + 2;

End;

Procedure TMagViewerTB.TbFitWinClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.FitToWindow;
  FNoClickOnZoom := True;
  UpdateImageZoomState();
  FNoClickOnZoom := False;
End;

Procedure TMagViewerTB.TbFit1to1Click(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then
  Begin
    FCurViewer.Fit1to1;
    Application.Processmessages;
//gek 93 Stop Automatic Mouse Pan       FcurViewer.MousePan;
  End;
  FNoClickOnZoom := True;
  UpdateImageZoomState();
  FNoClickOnZoom := False;
End;

Procedure TMagViewerTB.TbFlipVertClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.FlipVert;
End;

Procedure TMagViewerTB.TbFlipHorizClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.FlipHoriz;
End;

Procedure TMagViewerTB.StaticPages1Click(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.ViewerStyle := MagvsStaticPage;
End;

Procedure TMagViewerTB.Virtual1Click(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.ViewerStyle := MagvsVirtual;
End;

Procedure TMagViewerTB.Dynamiccustom1Click(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.ViewerStyle := MagvsDynamic;
End;

{ Open the Viewer Settings dialog window.}

Procedure TMagViewerTB.TbViewerSettingsClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then
  Begin
    //RowColSize.execute(FCurViewer);
    FCurViewer.EditViewerSettings;
  End;
End;

Procedure TMagViewerTB.TbRemoveImageClick(Sender: Tobject);
Begin
  // probably don't ever want to do this to all viewers
  If FCurViewer <> Nil Then FCurViewer.RemoveFromList;
End;

Procedure TMagViewerTB.TbClearViewerClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.ClearViewer;
End;

Procedure TMagViewerTB.PopupRowColPopup(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then
    MnuLockSize.Checked := FCurViewer.LockSize
  Else
    MnuLockSize.Checked := False;
End;

Procedure TMagViewerTB.MnuLockSizeClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then
  Begin
    MnuLockSize.Checked := Not MnuLockSize.Checked;
    FCurViewer.LockSize := MnuLockSize.Checked;
  End;
End;

Procedure TMagViewerTB.MnuToggleSelectedClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.ToggleSelected;
End;

Procedure TMagViewerTB.MnuRemoveImagesClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.RemoveFromList;
End;

Procedure TMagViewerTB.MnuClearbeforeAddImageClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then
  Begin
    MnuClearbeforeAddImage.Checked := Not MnuClearbeforeAddImage.Checked;
    FCurViewer.ClearBeforeAddDrop := MnuClearbeforeAddImage.Checked;
  End;
End;

Procedure TMagViewerTB.TbicZoomChange(Sender: Tobject);
Begin
  LicZoom.caption := Inttostr(TbicZoom.Position);
  LicZoom.Update;
  If FNoClickOnZoom Then Exit;
  If FCurViewer <> Nil Then
  Begin
    FCurViewer.ZoomValue(TbicZoom.Position);
//gek 93 Stop Automatic Mouse Pan       FcurViewer.MousePan;
  End;
End;

Procedure TMagViewerTB.TbPrintImageClick(Sender: Tobject);
Begin
  If (FCurViewer <> Nil) Then
  Begin
    If Assigned(OnPrintClick) Then
      Self.OnPrintClick(Self, FCurViewer)
    Else
      FCurViewer.ImagePrint;
  End;
End;

Procedure TMagViewerTB.TbCopyImageClick(Sender: Tobject);
Begin
  If (FCurViewer <> Nil) Then
  Begin
    If Assigned(OnCopyClick) Then
      Self.OnCopyClick(Self, FCurViewer)
    Else
      FCurViewer.ImageCopy;
  End;
End;

Procedure TMagViewerTB.TbReportClick(Sender: Tobject);
Begin
  If (FCurViewer <> Nil) Then FCurViewer.ImageReport;
End;

Procedure TMagViewerTB.ApplyViewerState(Viewer: IMag4Viewer);
Begin
  TbApplyToAll.Down := Viewer.ApplyToAll;
  TbPanWindow1.Down := Viewer.PanWindow;
  {TODO: these calls worked,  but we still need buttons for Group Images.}
  { Multipage documents            Buttons  yes
    MultiPage of the Viewer.       Buttons  YES (below, not enabled)
    MultiPage images in a Group    Buttons NO    }
  //  tbtnImageFirst.Enabled := not Viewer.ViewerScrollAtStart;
//  tbtnImagePrev.Enabled := not Viewer.ViewerScrollAtStart;
//  tbtnImageNext.Enabled := not Viewer.ViewerScrollAtEnd;
//  tbtnImageLast.Enabled := not Viewer.ViewerScrollAtEnd;

End;
 // 01/21/03  was (imagestate : Timagestate);

// JMW 4/14/2006 p72 - apply Image Gear functions, IG14 can do more than IG99

Procedure TMagViewerTB.ApplyImageFunctions(VGear: TMag4VGear); //imageOptions : TMag4VGearFunctions);
Var
  ImgState: TMagImageState;
Begin
  // JMW 5/13/08 p72t22 - calling FreeAndNil below when this is not initialized
  // was causing the Rad viewer cMag4Viewer to become nil (no idea why...)
  // set imgState to nil to start (to avoid FreeAndNil below when not necessary)
  ImgState := Nil;
  If VGear = Nil Then
  Begin
    TbAnnotations.Enabled := False;
    TbRuler.Enabled := False;
    TbProtractor.Enabled := False;
    TbRulerPointer.Enabled := False;
  End
  Else
  Begin
    If MagAnnotation In VGear.ComponentFunctions Then
    Begin
      TbAnnotations.Enabled := True;
      // enable/disable the ruler based on information from the header
      ImgState := VGear.GetState;
      If ImgState <> Nil Then
        TbRuler.Enabled := ImgState.MeasurementsEnabled
      Else
        TbRuler.Enabled := True;
      TbProtractor.Enabled := True;
    End
    Else
    Begin
      TbAnnotations.Enabled := False;
      TbRuler.Enabled := False;
      TbProtractor.Enabled := False;
      TbRulerPointer.Enabled := False;
    End;
  End;

  //TODO: apply more functions (DICOM, etC)
  If ImgState <> Nil Then
    FreeAndNil(ImgState);
End;

Procedure TMagViewerTB.ApplyImageState(VGear: TMag4VGear);
Var
  Imagestate: TMagImageState;
  x, y: Integer;
  Imagept: TPoint;
Begin
  If VGear = Nil Then
    Imagestate := Nil
  Else
    Imagestate := VGear.GetState;
  DisablePageControls(Imagestate);
  If Imagestate = Nil Then Exit;
  FImagePageCount := Imagestate.PageCount;
  TbePage.Text := Inttostr(Imagestate.Page);
  TblbPageCount.caption := 'of ' + Inttostr(Imagestate.PageCount);
  FNoClickOnZoom := True;
  Try
    TbicZoom.Position := Imagestate.ZoomValue;
  Finally
    FNoClickOnZoom := False;
  End;
  If Imagestate.WinLevEnabled Then
  Begin
//    tbicWin.Min := -2048;
//    tbicLev.Min := -2048;
    Lbllev.caption := 'Lev.';
    LblWin.caption := 'Win.';
    TbicWin.Hint := 'Change Window Value';
    TbicLev.Hint := 'Change Level Value';

    FWinLevScrollEnabled := False;

    TbicWin.Min := Imagestate.WinMinValue;
    TbicWin.Max := Imagestate.WinMaxValue;
    TbicWin.Position := Imagestate.WinValue;

    LblWinValue.caption := Inttostr(TbicWin.Position);

    TbicLev.Min := Imagestate.Levminvalue;
    TbicLev.Max := Imagestate.Levmaxvalue;

    // JMW 12/1/06 - moved above re-enabling scroll events, not sure if this is correct or if it will break something else
    // seems like an update to the state should never actually efect the image, right?
    TbicLev.Position := Imagestate.LevValue;

    // renable scroll bar for last event (12/1/06 - not anymore...)
    FWinLevScrollEnabled := True;

  End
  Else
  Begin
    //tbicWin.Min := 0;//JW's fix slider.
    //tbicLev.Min := 0;
    Lbllev.caption := 'Con.';
    LblWin.caption := 'Bri.';
    TbicWin.Hint := 'Change Brightness Value';
    TbicLev.Hint := 'Change Contrast Value';
    FWinLevScrollEnabled := False;
    TbicWin.Min := -900;
    TbicWin.Max := 1100;
    TbicWin.Position := (Imagestate.BrightnessValue);

    TbicLev.Min := 0;
    TbicLev.Max := 255;
    FWinLevScrollEnabled := True;
    TbicLev.Position := Imagestate.ContrastValue;
  End;
  LblLevValue.caption := Inttostr(TbicLev.Position);
  TblbImageCount.caption := Inttostr(Imagestate.ImageNumber) + '/' + Inttostr(Imagestate.ImageCount);
   { TODO 5 -c59 Merge : 59 merge item.  we need the SetScroll functions in MagViewer. }
   //self.MagViewer.SetScroll(imagestate.ScrollHoriz,imagestate.ScrollVert);//59
  Imagept := VGear.ClientOrigin;
  //x := imagept.x - 100 + vGear.Width;
  x := Imagept.x + VGear.Width;
  y := Imagept.y;

{$IFDEF USENEWANNOTS}
  AnnotationToolbar.InitializeToolbar(Annot00_SELECT_, x, y);
{$ELSE}
  AnnotationToolbar.Initialize(VGear.AnnotationComponent, x, y);
{$ENDIF}
//  ToolBar1.Visible := imagestate.WinLevEnabled;

  btnAutoWinLev.Enabled := Imagestate.WinLevEnabled;

  // below allows the ruler pointer to be enabled/disabled based on the # of annotations (> 1)
//  tbRulerPointer.Enabled := imagestate.AnnotationsDrawn;

  // JMW 6/27/2006
  // if current mouse action on selected image is auto win lev, set button to down

  CheckMouseState(Imagestate.MouseAction);

  // if annotations are enabled for this component, show toolbar
  If TbAnnotations.Down = False Then
    AnnotationToolbar.Visible := False;
  If Imagestate <> Nil Then
    FreeAndNil(Imagestate);
End;

Procedure TMagViewerTB.UpdateImageState;
Begin
  If (FCurViewer <> Nil) Then
  Begin
    ApplyImageState(FCurViewer.GetCurrentImage);
    ApplyViewerState(FCurViewer);
    ApplyImageFunctions(FCurViewer.GetCurrentImage);
  End;

End;

Procedure TMagViewerTB.DisablePageControls(Imagestate: TMagImageState);
Begin
  If Imagestate = Nil Then // 01/21/03
  Begin
    TbePage.Enabled := False;
    btnPageFirst.Enabled := False;
    TbtnPagePrev.Enabled := False;
    TbtnPageNext.Enabled := False;
    TbtnPageLast.Enabled := False;

    TbtnImageFirst.Enabled := False;
    TbtnImagePrev.Enabled := False;
    TbtnImageNext.Enabled := False;
    TbtnImageLast.Enabled := False;
    TblbImageCount.caption := '0/0';
  End
  Else
  Begin
    TbePage.Enabled := Not (Imagestate.PageCount = 1);
    btnPageFirst.Enabled := (Imagestate.Page <> 1);
    TbtnPagePrev.Enabled := (Imagestate.Page <> 1);
    TbtnPageNext.Enabled := (Imagestate.Page <> Imagestate.PageCount);
    TbtnPageLast.Enabled := (Imagestate.Page <> Imagestate.PageCount);

    TbtnImageFirst.Enabled := (Imagestate.ImageNumber <> 1);
    TbtnImagePrev.Enabled := (Imagestate.ImageNumber <> 1);
    TbtnImageNext.Enabled := (Imagestate.ImageNumber <> Imagestate.ImageCount);
    TbtnImageLast.Enabled := (Imagestate.ImageNumber <> Imagestate.ImageCount);
  End;
End;

Procedure TMagViewerTB.GoToPage(Pg: Integer);
Begin
  If (FCurViewer <> Nil) Then FCurViewer.ImagePage := Pg;
End;

Procedure TMagViewerTB.GoToPrevPage;
Begin
  If (FCurViewer <> Nil) Then FCurViewer.ImagePage := FCurViewer.ImagePage - 1;
End;

Procedure TMagViewerTB.GoToNextPage;
Begin
  If (FCurViewer <> Nil) Then FCurViewer.ImagePage := FCurViewer.ImagePage + 1;
End;

Procedure TMagViewerTB.btnPageFirstClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.PageFirstImage;
  UpdateImageState;
End;

Procedure TMagViewerTB.TbtnPagePrevClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.PagePrevImage;
  UpdateImageState;
End;

Procedure TMagViewerTB.TbtnPageNextClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.PageNextImage;
  UpdateImageState;
End;

Procedure TMagViewerTB.TbtnPageLastClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.PageLastImage;
  UpdateImageState;
End;

Procedure TMagViewerTB.TbePageClick(Sender: Tobject);
Begin
  TbePage.SELSTART := 0;
  TbePage.SelLength := 9;
End;

Procedure TMagViewerTB.TbePageEnter(Sender: Tobject);
Begin
  TbePage.SELSTART := 0;
  TbePage.SelLength := 9;
End;

Procedure TMagViewerTB.TbePageKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  { 33 is Page UP,   34 is Page Down }
  Case Key Of
    33:
      If Ssctrl In Shift Then
        GoToPage(1)
      Else
        GoToPrevPage;
    34:
      If Ssctrl In Shift Then
        GoToPage(999999999)
      Else
        GoToNextPage;
  End;
End;

Procedure TMagViewerTB.TbePageKeyUp(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Var
  Pg: Integer;
Begin
  { 33 is Page UP,   34 is Page Down }
  If ((Key = 33) Or (Key = 34)) Then Exit;
  Try
    If (Strtoint(TbePage.Text + '0') > FImagePageCount) Then
    Begin
      GoToPage(Strtoint(TbePage.Text));
      Exit;
    End;

    If (Length(TbePage.Text)) > (Length(Inttostr(FImagePageCount))) Then
    Begin
      //InvalidPage;

      Exit;
    End;
    If (Length(TbePage.Text)) = (Length(Inttostr(FImagePageCount))) Then
    Begin
      Pg := Strtoint(TbePage.Text);
      If Pg > FImagePageCount Then
      Begin
        //old InvalidPage;
        Pg := FImagePageCount;
        TbePage.Text := Inttostr(FImagePageCount);
           // exit;
      End;
      GoToPage(Pg);
      TbePage.SELSTART := 0;
      TbePage.SelLength := Length(TbePage.Text);
    End;
  Except
    //InvalidPage;
  End; { try}
End;

Procedure TMagViewerTB.TbResetClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then
  Begin
    FCurViewer.ResetImages;
    // Changing the next 3 controls, on this reset, is
    //  actually changing the property again.
    { TODO : Not Show Stopper, have to get way to stop the double processing. }

    If LblWin.caption = 'Bri.' Then
    Begin
      TbicWin.Position := 100;
      TbicLev.Position := 100;
    End;

//      tbicBrightness.Position := 100;
//      tbicContrast.Position := 100;

      // fit to window, don't want to set position since 100 might not fit to window
      // don't need this, resize done in vGear, update image state updates toolbar values
      //tbFitWinClick(self);
    UpdateImageState();
//      tbicZoom.Position := 100;
  End;
End;

Procedure TMagViewerTB.TbMaximizeClick(Sender: Tobject);
Begin
  // only done to selected image
  If FCurViewer <> Nil Then FCurViewer.MaximizeImage := True;
End;

Procedure TMagViewerTB.SetRowCol(Row, Col: Integer);
Begin
  If FCurViewer <> Nil Then
  Begin
    If FCurViewer.MaxCount < (Row * Col) Then FCurViewer.MaxCount := (Row * Col);
    Application.Processmessages;
    FCurViewer.SetRowColCount(Row, Col);
  End;
End;

Procedure TMagViewerTB.N1x1Click(Sender: Tobject);
Begin
  SetRowCol(1, 1);
End;

Procedure TMagViewerTB.N2x1Click(Sender: Tobject);
Begin
  SetRowCol(2, 1);
End;

Procedure TMagViewerTB.N3x1Click(Sender: Tobject);
Begin
  SetRowCol(3, 1);
End;

Procedure TMagViewerTB.N4x1Click(Sender: Tobject);
Begin
  SetRowCol(4, 1);
End;

Procedure TMagViewerTB.N1x2Click(Sender: Tobject);
Begin
  SetRowCol(1, 2);
End;

Procedure TMagViewerTB.N2x2Click(Sender: Tobject);
Begin
  SetRowCol(2, 2);
End;

Procedure TMagViewerTB.N3x2Click(Sender: Tobject);
Begin
  SetRowCol(3, 2);
End;

Procedure TMagViewerTB.N4x2Click(Sender: Tobject);
Begin
  SetRowCol(4, 2);
End;

Procedure TMagViewerTB.N1x3Click(Sender: Tobject);
Begin
  SetRowCol(1, 3);
End;

Procedure TMagViewerTB.N2x3Click(Sender: Tobject);
Begin
  SetRowCol(2, 3);
End;

Procedure TMagViewerTB.N3x3Click(Sender: Tobject);
Begin
  SetRowCol(3, 3);
End;

Procedure TMagViewerTB.N4x3Click(Sender: Tobject);
Begin
  SetRowCol(4, 3);
End;

Procedure TMagViewerTB.N1x4Click(Sender: Tobject);
Begin
  SetRowCol(1, 4);
End;

Procedure TMagViewerTB.N2x4Click(Sender: Tobject);
Begin
  SetRowCol(2, 4);
End;

Procedure TMagViewerTB.N3x4Click(Sender: Tobject);
Begin
  SetRowCol(3, 4);
End;

Procedure TMagViewerTB.N4x4Click(Sender: Tobject);
Begin
  SetRowCol(4, 4);
End;

Procedure TMagViewerTB.MnuReAlignClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.ReAlignImages(True);
End;

Procedure TMagViewerTB.TbRefreshClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.ReFreshImages;
End;

Procedure TMagViewerTB.TbMousePointerClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.MouseReSet;
End;

Procedure TMagViewerTB.TbBrightMoreClick(Sender: Tobject);
Begin
  TbicWin.Position := TbicWin.Position + 10;
  If FCurViewer <> Nil Then FCurViewer.BrightnessValue(TbicWin.Position);
End;

Procedure TMagViewerTB.TbBrightLessClick(Sender: Tobject);
Begin
  TbicWin.Position := TbicWin.Position - 10;
  If FCurViewer <> Nil Then FCurViewer.BrightnessValue(TbicWin.Position);
End;

Procedure TMagViewerTB.TbContrastMoreClick(Sender: Tobject);
Begin
  TbicLev.Position := TbicLev.Position + 10;
  If FCurViewer <> Nil Then FCurViewer.BrightnessValue(TbicLev.Position);
End;

Procedure TMagViewerTB.TbContrastLessClick(Sender: Tobject);
Begin
  TbicLev.Position := TbicLev.Position - 10;
  If FCurViewer <> Nil Then FCurViewer.BrightnessValue(TbicLev.Position);
End;

Procedure TMagViewerTB.TrbZoomInClick(Sender: Tobject);
Begin
  TbicZoom.Position := Trunc(TbicZoom.Position * 1.1);

  If FCurViewer <> Nil Then FCurViewer.ZoomValue(TbicZoom.Position);
End;

Procedure TMagViewerTB.TbZoomOutClick(Sender: Tobject);
Begin
  TbicZoom.Position := Trunc(TbicZoom.Position * 0.9);

  If FCurViewer <> Nil Then FCurViewer.ZoomValue(TbicZoom.Position);
End;

Procedure TMagViewerTB.TbtnImageFirstClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.PageFirstViewer;
  UpdateImageState;
End;

Procedure TMagViewerTB.TbtnImagePrevClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.PagePrevViewer;
  UpdateImageState;
End;

Procedure TMagViewerTB.TbtnImageNextClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.PageNextViewer;
  UpdateImageState;
End;

Procedure TMagViewerTB.TbtnImageLastClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.PageLastViewer;
  UpdateImageState;
End;

Procedure TMagViewerTB.TbAnnotationsClick(Sender: Tobject);
Var
  x, y: Integer;
  Imagept: TPoint;
Begin
{ this is not done yet!}
  If FCurViewer <> Nil Then
  Begin
    FCurViewer.Annotations();
    AnnotationToolbar.Visible := TbAnnotations.Down;
    // could use FCurViewer.GetCurrentImage here instead of passing the component through the viewer
    //if AnnotationToolbar.Visible then AnnotationToolbar.Initialize(FCurViewer.AnnotationComponent);

    If AnnotationToolbar.Visible Then
    Begin
      Imagept := FCurViewer.GetCurrentImage.ClientOrigin;
      //x := imagept.x - 100 + FCurViewer.GetCurrentImage.Width;
      x := Imagept.x + FCurViewer.GetCurrentImage.Width;
      y := Imagept.y;
{$IFDEF USENEWANNOTS}

{$ELSE}
      AnnotationToolbar.Initialize(FCurViewer.GetCurrentImage.AnnotationComponent, x, y);
{$ENDIF}
    End;

    //FCurViewer
  End;

  // should probably disable some viewer options (like pan window) when
  // annotations are in use
End;

Procedure TMagViewerTB.ToolButton2Click(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.AutoWinLevel;
End;
                     {
procedure TmagViewerTB.setRadiologyFunctions(Value : boolean);
begin
  btnAutoWinLev.Visible := value;

  tbRemoveImage.Visible := not value;
  tbTile.Visible := not value;
  tbClearViewer.Visible := not value;
  ToolButton10.Visible := not value;

  // hide paging buttons in Rad Viewer
  btnpagefirst.Visible := not Value;
  tbtnPagePrev.Visible := not Value;
  tbtnPageNext.Visible := not Value;
  tbtnPageLast.Visible := not Value;
  tbePage.Visible := not Value;
  tblbPageCount.Visible := not Value;

  tbRuler.Visible := value;
  tbRulerPointer.Visible := value;

  tbMaximize.Visible := not Value;

  tbarViewer.Update;
end;
}

Procedure TMagViewerTB.btnAutoWinLevClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.AutoWinLevel();
End;

Procedure TMagViewerTB.TbicWinChange(Sender: Tobject);
Var
  i: Integer;
Begin
  If LblWin.caption = 'Win.' Then
  Begin
    LblWinValue.caption := Inttostr(TbicWin.Position);
    LblWinValue.Update();
    If Not FWinLevScrollEnabled Then Exit;
    If FCurViewer <> Nil Then FCurViewer.WinLevValue(TbicWin.Position, TbicLev.Position);
  End
  Else
  Begin
    LblWinValue.caption := Inttostr(Trunc(TbicWin.Position / 10) + 90);
    LblWinValue.Update;
    If Not FWinLevScrollEnabled Then Exit;
    If FCurViewer <> Nil Then FCurViewer.BrightnessValue(TbicWin.Position);
  End;
End;

Procedure TMagViewerTB.TbicLevChange(Sender: Tobject);
Var
  i: Integer;
Begin
  If Lbllev.caption = 'Lev.' Then
  Begin
    LblLevValue.caption := Inttostr(TbicLev.Position);
    LblLevValue.Update();
    If Not FWinLevScrollEnabled Then Exit;
    If FCurViewer <> Nil Then FCurViewer.WinLevValue(TbicWin.Position, TbicLev.Position);
  End
  Else
  Begin
    LblLevValue.caption := Inttostr(TbicLev.Position);
    LblLevValue.Update;
    If Not FWinLevScrollEnabled Then Exit;
    If FCurViewer <> Nil Then FCurViewer.ContrastValue(TbicLev.Position);
  End;
End;

Procedure TMagViewerTB.TbRulerClick(Sender: Tobject);
Begin
  If Not FWinLevScrollEnabled Then Exit;
  If FCurViewer <> Nil Then
    FCurViewer.Measurements();
End;

{JK 10/6/2009 - Maggmsgu refactoring - remove old method}
//procedure TmagViewerTB.LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);
//begin
//  if assigned(OnLogEvent) then
//    OnLogEvent(self, MsgType, Msg, Priority);
//
//end;

Procedure TMagViewerTB.TbRulerPointerClick(Sender: Tobject);
Begin
  If Not FWinLevScrollEnabled Then Exit;
  If FCurViewer <> Nil Then
    FCurViewer.AnnotationPointer();
End;

Procedure TMagViewerTB.CheckMouseState(State: TMagImageMouse);
Begin
  // don't need to set false since the buttons are part of a group
{
  btnAutoWinLev.Down := false;
  tbRuler.Down := false;
  tbRulerPointer.Down := false;
  tbAnnotations.Down := false;
  tbMousePan.Down := false;
  }

  Case State Of
    MactPan:
      TbMousePan.Down := True;
    MactMagnify:
      TbMouseMagnify.Down := True;
    MactZoomRect:
      TbMouseZoomRect.Down := True;
    MactWinLev:
      Begin
        btnAutoWinLev.Down := True;
      End;
    MactAnnotation:
      Begin
        TbAnnotations.Down := True;
        AnnotationToolbar.Visible := True;
      End;
    MactMeasure:
      Begin
        TbRuler.Down := True;
      End;
    MactAnnotationPointer:
      Begin
        TbRulerPointer.Down := True;
      End;
    MactProtractor:
      Begin
        TbProtractor.Down := True;
      End;
  End;

End;

Procedure TMagViewerTB.UpdateImageZoomState();
Var
  VGear: TMag4VGear;
  State: TMagImageState;
Begin
  If FCurViewer = Nil Then Exit;
  VGear := FCurViewer.GetCurrentImage();
  If VGear = Nil Then Exit;
  State := VGear.GetState();

  TbicZoom.Position := State.ZoomValue;
End;

Procedure TMagViewerTB.TbProtractorClick(Sender: Tobject);
Begin
  If Not FWinLevScrollEnabled Then Exit;
  If FCurViewer <> Nil Then
    FCurViewer.Protractor();
End;

Procedure TMagViewerTB.DisablePanWindow();
Begin
  TbPanWindow1.Down := False;
  If FCurViewer <> Nil Then
    FCurViewer.PanWindow := False;
End;

End.
