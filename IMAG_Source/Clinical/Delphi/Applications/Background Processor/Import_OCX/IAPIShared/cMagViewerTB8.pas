Unit cMagViewerTB8;
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
  cmag4viewer,
  ComCtrls,
  Controls,
  ExtCtrls,
  Forms,
  Menus,
  Stdctrls,
  UMagDefinitions, ImgList, Graphics, ToolWin
  ;

//Uses Vetted 20090929:cMagVUtils, Buttons, ImgList, ToolWin, Dialogs, Graphics, Messages, Windows, iMagViewer, SysUtils

Type
    {Print command to be executed by parent window, not ToolBar to Viewer}
  TMagPrintClickEvent = Procedure(Sender: Tobject; Viewer: TMag4Viewer) Of Object;
  TMagCopyClickEvent = Procedure(Sender: Tobject; Viewer: TMag4Viewer) Of Object;

  TMagViewerTB8 = Class(TFrame)
    PopupViewerStyles: TPopupMenu;
    StaticPages1: TMenuItem;
    Virtual1: TMenuItem;
    Dynamiccustom1: TMenuItem;
    PopupRowCol: TPopupMenu;
    MnuReAlign: TMenuItem;
    MnuToggleSelected: TMenuItem;
    MnuRemoveImages: TMenuItem;
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
    PopupImage: TPopupMenu;
    MnuCopyImage: TMenuItem;
    MnuPrintImage: TMenuItem;
    TbReportmnu: TMenuItem;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    PicBrightness: Tpanel;
    Label6: Tlabel;
    LicBrightness: Tlabel;
    TbicBrightness: TTrackBar;
    PicContrast: Tpanel;
    Label8: Tlabel;
    LicContrast: Tlabel;
    TbicContrast: TTrackBar;
    PicZoom: Tpanel;
    LicZoom: Tlabel;
    TbicZoom: TTrackBar;
    PageScroller1: TPageScroller;
    TbarViewer: TToolBar;
    TbApplyToAll: TToolButton;
    TbFitWin: TToolButton;
    Tb90: TToolButton;
    Tb180: TToolButton;
    TbMousePan: TToolButton;
    TbMouseMagnify: TToolButton;
    TbMouseZoomRect: TToolButton;
    TbMousePointer: TToolButton;
    TbMaximize: TToolButton;
    TbTile: TToolButton;
    ToolButton16: TToolButton;
    TbtnFittoWidth: TToolButton;
    MnuZoomPopup: TPopupMenu;
    MnuZ400: TMenuItem;
    MnuZ300: TMenuItem;
    MnuZ200: TMenuItem;
    MnuZ100: TMenuItem;
    MnuZ75: TMenuItem;
    MnuZ50: TMenuItem;
    MnuZ30: TMenuItem;
    MnuZ20: TMenuItem;
    MnuZFit: TMenuItem;
    MnuZWidth: TMenuItem;
    TbtnZoomPlus: TToolButton;
    TbtnZoomMinus: TToolButton;
    PageScroller2: TPageScroller;
    ToolBar2: TToolBar;
    TbRefresh: TToolButton;
    TbtnRemoveSelected: TToolButton;
    TbtnRemoveAll: TToolButton;
    TbtnVistA: TToolButton;
    btnPageFirst: TToolButton;
    TbtnPagePrev: TToolButton;
    Lbpage: Tlabel;
    TbtnPageNext: TToolButton;
    TbtnPageLast: TToolButton;
    TbFlipVert: TToolButton;
    TbFlipHoriz: TToolButton;
    TbReverse: TToolButton;
    TbPanWindow1: TToolButton;
    TbtnReset: TToolButton;
    IlTB24n1: TImageList;
    IlTB16n1: TImageList;
    Image1: TImage;
    IlTB24u1: TImageList;
    N2: TMenuItem;
    MnuZActual: TMenuItem;
    NextViewerPage1: TMenuItem;
    PreviousViewerPage1: TMenuItem;
    MaximizeImage1: TMenuItem;
    N1: TMenuItem;
    ViewerSettings1: TMenuItem;
    ilDots: TImageList;
    Procedure TbApplyToAllClick(Sender: Tobject);
    Procedure TbFitHeightClick(Sender: Tobject);
    Procedure Tb180Click(Sender: Tobject);
    Procedure Tb90Click(Sender: Tobject);
    Procedure TbMousePanClick(Sender: Tobject);
    Procedure TbMouseZoomRectClick(Sender: Tobject);
    Procedure TbMouseMagnifyClick(Sender: Tobject);
    Procedure TbTileClick(Sender: Tobject);
    Procedure TbarViewerResize(Sender: Tobject);
    Procedure TbFitWinClick(Sender: Tobject);
    Procedure StaticPages1Click(Sender: Tobject);
    Procedure Virtual1Click(Sender: Tobject);
    Procedure Dynamiccustom1Click(Sender: Tobject);
    Procedure MnuToggleSelectedClick(Sender: Tobject);
    Procedure MnuRemoveImagesClick(Sender: Tobject);
    Procedure TbicZoomChange(Sender: Tobject);
    Procedure TbicBrightnessChange(Sender: Tobject);
    Procedure TbicContrastChange(Sender: Tobject);
    Procedure MnuPrintImageClick(Sender: Tobject);
    Procedure MnuCopyImageClick(Sender: Tobject);
    Procedure TbReportmnuClick(Sender: Tobject);
    Procedure TbePageKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
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
    Procedure TbMousePointerClick(Sender: Tobject);
    Procedure TbBrightMoreClick(Sender: Tobject);
    Procedure TbBrightLessClick(Sender: Tobject);
    Procedure TbContrastMoreClick(Sender: Tobject);
    Procedure TbContrastLessClick(Sender: Tobject);
    Procedure TbtnImageFirstClick(Sender: Tobject);
    Procedure TbtnImagePrevClick(Sender: Tobject);
    Procedure TbtnImageNextClick(Sender: Tobject);
    Procedure TbtnImageLastClick(Sender: Tobject);
    Procedure TbtnRemoveSelectedClick(Sender: Tobject);
    Procedure ToolButton8Click(Sender: Tobject);
    Procedure TbtnRemoveAllClick(Sender: Tobject);
    Procedure TbRefreshClick(Sender: Tobject);
    Procedure ToolButton7Click(Sender: Tobject);
    Procedure btnPageFirstClick(Sender: Tobject);
    Procedure TbtnPagePrevClick(Sender: Tobject);
    Procedure TbtnPageNextClick(Sender: Tobject);
    Procedure TbtnPageLastClick(Sender: Tobject);
    Procedure TbtnResetClick(Sender: Tobject);
    Procedure TbtnZoomMinusClick(Sender: Tobject);
    Procedure TbtnFittoWidthClick(Sender: Tobject);
    Procedure MnuZ100Click(Sender: Tobject);
    Procedure MnuZ400Click(Sender: Tobject);
    Procedure MnuZ300Click(Sender: Tobject);
    Procedure MnuZ200Click(Sender: Tobject);
    Procedure MnuZ75Click(Sender: Tobject);
    Procedure MnuZ50Click(Sender: Tobject);
    Procedure MnuZ30Click(Sender: Tobject);
    Procedure MnuZ20Click(Sender: Tobject);
    Procedure MnuZFitClick(Sender: Tobject);
    Procedure MnuZWidthClick(Sender: Tobject);
    Procedure TbPanWindow1Click(Sender: Tobject);
    Procedure TbtnZoomPlusClick(Sender: Tobject);
    Procedure TbtnVistAClick(Sender: Tobject);
    Procedure TbFlipVertClick(Sender: Tobject);
    Procedure TbFlipHorizClick(Sender: Tobject);
    Procedure TbReverseClick(Sender: Tobject);
    Procedure NextViewerPage1Click(Sender: Tobject);
    Procedure PreviousViewerPage1Click(Sender: Tobject);
    Procedure MaximizeImage1Click(Sender: Tobject);
    Procedure MnuZActualClick(Sender: Tobject);
    Procedure ViewerSettings1Click(Sender: Tobject);
  Private
    FImagePageCount: Integer;
    FCurViewer: TMag4Viewer; { Private declarations }
//    FMagVUtils: TMagVUtils;
    FPrintClickEvent: TMagPrintClickEvent;
    FCopyClickEvent: TMagCopyClickEvent;
    Procedure GoToNextPage;
    Procedure GoToPage(Pg: Integer);
    Procedure GoToPrevPage;
    Procedure SetRowCol(Row, Col: Integer);
    Procedure ApplyImageState(VGear: TMag4VGear); // 01/21/03  was imagestate  : Timagestate
    Procedure DisablePageControls(Imagestate: TMagImageState);
    Procedure ApplyViewerState(Viewer: TMag4Viewer);

  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;

    {Called by associated form, or component :
    Viewer Toolbar will querry the Viewer then update it's controls,
    (brightness, Zoom value, page count etc) according to the state
    of the selected image }
    Procedure UpdateImageState;
  Published
    {Connect this Viewer Toolbar to a Viewer.}
    Property MagViewer: TMag4Viewer Read FCurViewer Write FCurViewer;
    Property OnPrintClick: TMagPrintClickEvent Read FPrintClickEvent Write FPrintClickEvent;
    Property OnCopyClick: TMagCopyClickEvent Read FCopyClickEvent Write FCopyClickEvent;

  End;

Procedure Register;

Implementation
Uses
  IMagViewer,
  SysUtils
  ;

{$R *.DFM}

Procedure Register;
Begin
  RegisterComponents('Imaging', [TMagViewerTB8]);
End;
{ TODO :
Enable Disable Buttons, based on if Fcurviewer is NIL.
and later, based on Selected Images in Fcurviewer. }

Procedure TMagViewerTB8.TbApplyToAllClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.ApplyToAll := TbApplyToAll.Down;
  ;
End;

Procedure TMagViewerTB8.TbFitHeightClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then
  Begin
    FCurViewer.FitToHeight;
    Application.Processmessages;
//gek 93 Stop Automatic Mouse Pan        FcurViewer.MousePan;
  End;

End;

Procedure TMagViewerTB8.Tb180Click(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.Rotate(90);

End;

Procedure TMagViewerTB8.Tb90Click(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.Rotate(270);
End;

Procedure TMagViewerTB8.TbMousePanClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.MousePan;
  (*  // If we want to lock button down depending on Cursor Action
      //    also have to group buttons, and call them CheckButtons.
    if FcurViewer <> nil then
  if tbMousePan.down
    then FcurViewer.MousePan
    else FCurViewer.MouseReset;*)
End;

Procedure TMagViewerTB8.TbMouseMagnifyClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.MouseMagnify;
  (*  // If we want to lock button down depending on Cursor Action
      //    also have to group buttons, and call them CheckButtons.
  if FcurViewer <> nil then
  if tbMouseMagnify.down
    then FcurViewer.MouseMagnify
    else FCurViewer.MouseReset;  *)
End;

Procedure TMagViewerTB8.TbMouseZoomRectClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.MouseZoomRect;
  (*  // If we want to lock button down depending on Cursor Action
      //    also have to group buttons, and call them CheckButtons.
  if FcurViewer <> nil then
  if tbMouseZoomRect.down
    then FcurViewer.MouseZoomRect
    else FCurViewer.MouseReset;*)
End;

Procedure TMagViewerTB8.TbTileClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.TileAll;
End;

Constructor TMagViewerTB8.Create(AOwner: TComponent);
Begin
  Inherited;
  AutoSize := True;
End;

Destructor TMagViewerTB8.Destroy;
Begin
  FCurViewer := Nil;
  Inherited;

End;

Procedure TMagViewerTB8.TbarViewerResize(Sender: Tobject);
Begin
  If (Align = altop) Then Height := TbarViewer.Height + 2;
  If (Width < TbarViewer.Width) Then
    If (Align = alLeft) Then Width := TbarViewer.Width + 2;

End;

Procedure TMagViewerTB8.TbFitWinClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.FitToWindow;
End;

Procedure TMagViewerTB8.StaticPages1Click(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.ViewerStyle := MagvsStaticPage;
End;

Procedure TMagViewerTB8.Virtual1Click(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.ViewerStyle := MagvsVirtual;
End;

Procedure TMagViewerTB8.Dynamiccustom1Click(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.ViewerStyle := MagvsDynamic;
End;

{ Open the Viewer Settings dialog window.}

Procedure TMagViewerTB8.MnuToggleSelectedClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.ToggleSelected;
End;

Procedure TMagViewerTB8.MnuRemoveImagesClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.RemoveFromList;
End;

Procedure TMagViewerTB8.TbicZoomChange(Sender: Tobject);
Begin
  LicZoom.caption := Inttostr(TbicZoom.Position);
  LicZoom.Update;
  If FCurViewer <> Nil Then
  Begin
    FCurViewer.ZoomValue(TbicZoom.Position);
//gek 93 Stop Automatic Mouse Pan   FcurViewer.MousePan;
  End;

End;

Procedure TMagViewerTB8.TbicBrightnessChange(Sender: Tobject);
Begin
  LicBrightness.caption := Inttostr(Trunc(TbicBrightness.Position / 10) + 90);
  LicBrightness.Update;
  If FCurViewer <> Nil Then FCurViewer.BrightnessValue(TbicBrightness.Position); //(trunc(tbicBrightness.Position / 10));
End;

Procedure TMagViewerTB8.TbicContrastChange(Sender: Tobject);
Begin
  LicContrast.caption := Inttostr(TbicContrast.Position);
  LicContrast.Update;
  If FCurViewer <> Nil Then FCurViewer.ContrastValue(TbicContrast.Position); //(tbicContrast.Position / 100);
End;

Procedure TMagViewerTB8.MnuPrintImageClick(Sender: Tobject);
Begin
  If (FCurViewer <> Nil) Then
  Begin
    If Assigned(OnPrintClick) Then
      Self.OnPrintClick(Self, FCurViewer)
    Else
      FCurViewer.ImagePrint;
  End;
End;

Procedure TMagViewerTB8.MnuCopyImageClick(Sender: Tobject);
Begin
  If (FCurViewer <> Nil) Then
  Begin
    If Assigned(OnCopyClick) Then
      Self.OnCopyClick(Self, FCurViewer)
    Else
      FCurViewer.ImageCopy;
  End;
End;

Procedure TMagViewerTB8.TbReportmnuClick(Sender: Tobject);
Begin
  If (FCurViewer <> Nil) Then FCurViewer.ImageReport;

End;

Procedure TMagViewerTB8.ApplyViewerState(Viewer: TMag4Viewer);
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

Procedure TMagViewerTB8.ApplyImageState(VGear: TMag4VGear);
Var
  Imagestate: TMagImageState;
Begin
  If VGear = Nil Then
    Imagestate := Nil
  Else
    Imagestate := VGear.GetState;
  DisablePageControls(Imagestate);
  If Imagestate = Nil Then Exit;
  FImagePageCount := Imagestate.PageCount;
  //tbepage.text := inttostr(imagestate.page);
  Lbpage.caption := Inttostr(Imagestate.Page) + '/' + Inttostr(Imagestate.PageCount);
  TbicBrightness.Position := (Imagestate.BrightnessValue);
  TbicContrast.Position := Imagestate.ContrastValue;
  TbicZoom.Position := Imagestate.ZoomValue;

//  tbicWin.Min := imagestate.WinMinValue;
//  tbicWin.Max := imagestate.WinMaxValue;
//  tbicWin.Position := imagestate.WinValue;
//  tbicLev.Min := imagestate.LevMinValue;
//  tbicLev.Max := imagestate.LevMaxValue;
//  tbicLev.Position := imagestate.LevValue;
//isi  tblbImageCount.Caption := inttostr(imagestate.ImageNumber)+'/'+inttostr(imagestate.ImageCount);

(*   //Horiz := Gear1.GetScrollPos(0);
  //Vert := Gear1.GetScrollPos(1);
  Gear1.SetScrollPos(0, 4, 0 );
  Gear1.SetScrollPos(1, 4, vert);  *)

  Self.MagViewer.SetScroll(Imagestate.ScrollHoriz, Imagestate.ScrollVert);
  (*  // future If we want to lock button down depending on Cursor Action
      //    also have to group buttons, and call them CheckButtons.

  case imagestate.MouseAction of
   mactPan:
     begin
     if not tbMousePan.Down then tbMousePan.down := true;
     end;
   mactDrag:
   begin
    // if not tbDrag.Down then tbDrag.down := true;
    end;
   mactMagnify:
   begin
     if not tbMouseMagnify.Down then tbMouseMagnify.down := true;
    end;
   mactZoomRect:
     begin
     if not tbMouseZoomRect.Down then tbMouseZoomRect.down := true;
      end;
   mactSelect:
   begin
    // if not tbSelect.Down then tbSelect.down := true;
    end;
   mactPointer:
     begin
     if not tbMousePointer.Down then tbMousePointer.down := true;
     end;
   end;
   *)
End;

Procedure TMagViewerTB8.UpdateImageState;
Begin
  If (FCurViewer <> Nil) Then
  Begin
    ApplyImageState(FCurViewer.GetCurrentImage);
    ApplyViewerState(FCurViewer);
  End;

End;

Procedure TMagViewerTB8.DisablePageControls(Imagestate: TMagImageState);
Begin
  If Imagestate = Nil Then // 01/21/03
  Begin
      //tbepage.enabled := false;
    Lbpage.Enabled := False;
    Lbpage.caption := '0/0';

    btnPageFirst.Enabled := False;
    TbtnPagePrev.Enabled := False;
    TbtnPageNext.Enabled := False;
    TbtnPageLast.Enabled := False;

(* isi      tbtnImageFirst.enabled := false;
      tbtnImagePrev.enabled := false;
      tbtnImageNext.enabled := false;
      tbtnImageLast.enabled := false;
      tblbImageCount.caption := '0/0';
      *)
  End
  Else
  Begin
      //tbepage.enabled := not (imagestate.PageCount = 1);
    Lbpage.Enabled := True;
    Lbpage.caption := Inttostr(Imagestate.Page) + '/' + Inttostr(Imagestate.PageCount);
    btnPageFirst.Enabled := (Imagestate.Page <> 1);
    TbtnPagePrev.Enabled := (Imagestate.Page <> 1);
    TbtnPageNext.Enabled := (Imagestate.Page <> Imagestate.PageCount);
    TbtnPageLast.Enabled := (Imagestate.Page <> Imagestate.PageCount);

(* isi     tbtnImageFirst.enabled := (imagestate.ImageNumber <> 1);
      tbtnImagePrev.enabled := (imagestate.ImageNumber <> 1);
      tbtnImageNext.enabled := (imagestate.ImageNumber <> imagestate.ImageCount);
      tbtnImageLast.enabled := (imagestate.ImageNumber <> imagestate.ImageCount);
      *)
  End;
End;

Procedure TMagViewerTB8.GoToPage(Pg: Integer);
Begin
  If (FCurViewer <> Nil) Then FCurViewer.ImagePage := Pg;
End;

Procedure TMagViewerTB8.GoToPrevPage;
Begin
  If (FCurViewer <> Nil) Then FCurViewer.ImagePage := FCurViewer.ImagePage - 1;
End;

Procedure TMagViewerTB8.GoToNextPage;
Begin
  If (FCurViewer <> Nil) Then FCurViewer.ImagePage := FCurViewer.ImagePage + 1;
End;

Procedure TMagViewerTB8.TbePageKeyDown(Sender: Tobject; Var Key: Word;
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

Procedure TMagViewerTB8.TbMaximizeClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.MaximizeImage := True;
End;

Procedure TMagViewerTB8.SetRowCol(Row, Col: Integer);
Begin
  If FCurViewer <> Nil Then
  Begin
    If FCurViewer.MaxCount < (Row * Col) Then FCurViewer.MaxCount := (Row * Col);
    Application.Processmessages;
    FCurViewer.SetRowColCount(Row, Col);
  End;
End;

Procedure TMagViewerTB8.N1x1Click(Sender: Tobject);
Begin
  SetRowCol(1, 1);
End;

Procedure TMagViewerTB8.N2x1Click(Sender: Tobject);
Begin
  SetRowCol(2, 1);
End;

Procedure TMagViewerTB8.N3x1Click(Sender: Tobject);
Begin
  SetRowCol(3, 1);
End;

Procedure TMagViewerTB8.N4x1Click(Sender: Tobject);
Begin
  SetRowCol(4, 1);
End;

Procedure TMagViewerTB8.N1x2Click(Sender: Tobject);
Begin
  SetRowCol(1, 2);
End;

Procedure TMagViewerTB8.N2x2Click(Sender: Tobject);
Begin
  SetRowCol(2, 2);
End;

Procedure TMagViewerTB8.N3x2Click(Sender: Tobject);
Begin
  SetRowCol(3, 2);
End;

Procedure TMagViewerTB8.N4x2Click(Sender: Tobject);
Begin
  SetRowCol(4, 2);
End;

Procedure TMagViewerTB8.N1x3Click(Sender: Tobject);
Begin
  SetRowCol(1, 3);
End;

Procedure TMagViewerTB8.N2x3Click(Sender: Tobject);
Begin
  SetRowCol(2, 3);
End;

Procedure TMagViewerTB8.N3x3Click(Sender: Tobject);
Begin
  SetRowCol(3, 3);
End;

Procedure TMagViewerTB8.N4x3Click(Sender: Tobject);
Begin
  SetRowCol(4, 3);
End;

Procedure TMagViewerTB8.N1x4Click(Sender: Tobject);
Begin
  SetRowCol(1, 4);
End;

Procedure TMagViewerTB8.N2x4Click(Sender: Tobject);
Begin
  SetRowCol(2, 4);
End;

Procedure TMagViewerTB8.N3x4Click(Sender: Tobject);
Begin
  SetRowCol(3, 4);
End;

Procedure TMagViewerTB8.N4x4Click(Sender: Tobject);
Begin
  SetRowCol(4, 4);
End;

Procedure TMagViewerTB8.MnuReAlignClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.ReAlignImages(True);
End;

Procedure TMagViewerTB8.TbMousePointerClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.MouseReSet;
End;

Procedure TMagViewerTB8.TbBrightMoreClick(Sender: Tobject);
Begin
  TbicBrightness.Position := TbicBrightness.Position + 10;
  If FCurViewer <> Nil Then FCurViewer.BrightnessValue(TbicBrightness.Position);
End;

Procedure TMagViewerTB8.TbBrightLessClick(Sender: Tobject);
Begin
  TbicBrightness.Position := TbicBrightness.Position - 10;
  If FCurViewer <> Nil Then FCurViewer.BrightnessValue(TbicBrightness.Position);
End;

Procedure TMagViewerTB8.TbContrastMoreClick(Sender: Tobject);
Begin
  TbicContrast.Position := TbicContrast.Position + 10;
  If FCurViewer <> Nil Then FCurViewer.BrightnessValue(TbicContrast.Position);
End;

Procedure TMagViewerTB8.TbContrastLessClick(Sender: Tobject);
Begin
  TbicContrast.Position := TbicContrast.Position - 10;
  If FCurViewer <> Nil Then FCurViewer.BrightnessValue(TbicContrast.Position);
End;

Procedure TMagViewerTB8.TbtnImageFirstClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.PageFirstViewer;
  UpdateImageState;
End;

Procedure TMagViewerTB8.TbtnImagePrevClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.PagePrevViewer;
  UpdateImageState;
End;

Procedure TMagViewerTB8.TbtnImageNextClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.PageNextViewer;
  UpdateImageState;
End;

Procedure TMagViewerTB8.TbtnImageLastClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.PageLastViewer;
  UpdateImageState;
End;

Procedure TMagViewerTB8.TbtnRemoveSelectedClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.RemoveFromList;

End;

Procedure TMagViewerTB8.ToolButton8Click(Sender: Tobject);
Begin
//  tbicZoom.Position := trunc(tbicZoom.Position * 0.9);
//  if FcurViewer <> nil then FcurViewer.ZoomValue(tbicZoom.Position);

End;

Procedure TMagViewerTB8.TbtnRemoveAllClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.ClearViewer;

End;

Procedure TMagViewerTB8.TbRefreshClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.ReFreshImages;
End;

Procedure TMagViewerTB8.ToolButton7Click(Sender: Tobject);
Begin
//  tbicZoom.Position := trunc(tbicZoom.Position * 1.1);
//  if FcurViewer <> nil then FcurViewer.ZoomValue(tbicZoom.Position);

End;

Procedure TMagViewerTB8.btnPageFirstClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.PageFirstImage;
//  GoToPage(1);
  UpdateImageState;
End;

Procedure TMagViewerTB8.TbtnPagePrevClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.PagePrevImage;
//  GoToPrevPage;
  UpdateImageState;
End;

Procedure TMagViewerTB8.TbtnPageNextClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.PageNextImage;
//  GoToNextPage;
  UpdateImageState;
End;

Procedure TMagViewerTB8.TbtnPageLastClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.PageLastImage;
//  GoToPage(9999999);
  UpdateImageState;
End;

Procedure TMagViewerTB8.TbtnResetClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.ResetImages;
End;

Procedure TMagViewerTB8.TbtnZoomMinusClick(Sender: Tobject);
Var
  Value: Integer;
Begin
  If FCurViewer <> Nil Then FCurViewer.ZoomValue(-1);
  Value := Trunc(Self.TbicZoom.Position * 0.9);
  If Value < 20 Then Value := 20;
  If FCurViewer <> Nil Then FCurViewer.ZoomValue(Value);
  Self.TbicZoom.Position := Value;

End;

Procedure TMagViewerTB8.TbtnFittoWidthClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then
  Begin
    FCurViewer.FitToWidth;
    Application.Processmessages;
//gek 93 Stop Automatic Mouse Pan       FcurViewer.MousePan;
  End;
End;

Procedure TMagViewerTB8.MnuZ100Click(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then
  Begin
    FCurViewer.ZoomValue(100);
    Application.Processmessages;
//gek 93 Stop Automatic Mouse Pan         FcurViewer.MousePan;
  End;
End;

Procedure TMagViewerTB8.MnuZ400Click(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then
  Begin
    FCurViewer.ZoomValue(400);
    Application.Processmessages;
//gek 93 Stop Automatic Mouse Pan         FcurViewer.MousePan;
  End;
End;

Procedure TMagViewerTB8.MnuZ300Click(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then
  Begin
    FCurViewer.ZoomValue(300);
    Application.Processmessages;
//gek 93 Stop Automatic Mouse Pan         FcurViewer.MousePan;
  End;
End;

Procedure TMagViewerTB8.MnuZ200Click(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then
  Begin
    FCurViewer.ZoomValue(200);
    Application.Processmessages;
//gek 93 Stop Automatic Mouse Pan         FcurViewer.MousePan;
  End;
End;

Procedure TMagViewerTB8.MnuZ75Click(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then
  Begin
    FCurViewer.ZoomValue(75);
    Application.Processmessages;
//gek 93 Stop Automatic Mouse Pan         FcurViewer.MousePan;
  End;
End;

Procedure TMagViewerTB8.MnuZ50Click(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then
  Begin
    FCurViewer.ZoomValue(50);
    Application.Processmessages;
//gek 93 Stop Automatic Mouse Pan         FcurViewer.MousePan;
  End;
End;

Procedure TMagViewerTB8.MnuZ30Click(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then
  Begin
    FCurViewer.ZoomValue(30);
    Application.Processmessages;
//gek 93 Stop Automatic Mouse Pan         FcurViewer.MousePan;
  End;
End;

Procedure TMagViewerTB8.MnuZ20Click(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then
  Begin
    FCurViewer.ZoomValue(20);
    Application.Processmessages;
//gek 93 Stop Automatic Mouse Pan         FcurViewer.MousePan;
  End;
End;

Procedure TMagViewerTB8.MnuZFitClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then
  Begin
    FCurViewer.FitToWindow;
    Application.Processmessages;
  End;
End;

Procedure TMagViewerTB8.MnuZWidthClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then
  Begin
    FCurViewer.FitToWidth;
    Application.Processmessages;
  End;
End;

Procedure TMagViewerTB8.TbPanWindow1Click(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.PanWindow := TbPanWindow1.Down;
End;

Procedure TMagViewerTB8.TbtnZoomPlusClick(Sender: Tobject);
Var
  Value: Integer;
Begin
//if FcurViewer <> nil then FcurViewer.ZoomValue(+1);
// change for tb8 in VA
  Value := Trunc(Self.TbicZoom.Position * 1.1);
  If FCurViewer <> Nil Then FCurViewer.ZoomValue(Value);
  Self.TbicZoom.Position := Value;
End;

Procedure TMagViewerTB8.TbtnVistAClick(Sender: Tobject);
Begin
  If (FCurViewer <> Nil) Then FCurViewer.ImageReport;
End;

Procedure TMagViewerTB8.TbFlipVertClick(Sender: Tobject);
Begin
  If (FCurViewer <> Nil) Then FCurViewer.FlipVert;
End;

Procedure TMagViewerTB8.TbFlipHorizClick(Sender: Tobject);
Begin
  If (FCurViewer <> Nil) Then FCurViewer.FlipHoriz;
End;

Procedure TMagViewerTB8.TbReverseClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.Inverse;
End;

Procedure TMagViewerTB8.NextViewerPage1Click(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.PageNextViewer(False);
End;

Procedure TMagViewerTB8.PreviousViewerPage1Click(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.PagePrevViewer(False);
End;

Procedure TMagViewerTB8.MaximizeImage1Click(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then FCurViewer.MaximizeImage := True;
End;

Procedure TMagViewerTB8.MnuZActualClick(Sender: Tobject);
Begin
  If FCurViewer <> Nil Then
  Begin
    FCurViewer.Fit1to1;
    Application.Processmessages;
  End;
End;

Procedure TMagViewerTB8.ViewerSettings1Click(Sender: Tobject);
Begin
  Self.MagViewer.EditViewerSettings;
End;

End.
