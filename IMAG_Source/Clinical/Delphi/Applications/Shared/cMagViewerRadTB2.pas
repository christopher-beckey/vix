{
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: April, 2009
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  Julian Werfel
  Description:
    Updated toolbar used for Radiology Viewer. No longer based on TMagViewerTB
    so this toolbar can use different controls for brightness/contrast,
    window/level and zoom.
    The majority of the code for this component is from TMag4ViewerTB and
    TMagViewerRadTB.
    TMagViewerRadTB can now be depricated since it should not be used anywhere
    anymore.

        ;; +--------------------------------------------------------------------+
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
        ;; +--------------------------------------------------------------------+
}
Unit cMagViewerRadTB2;

Interface

Uses
  Classes,
  cMag4Vgear,
  ComCtrls,
  Controls,
  ExtCtrls,
  Forms,
  IMagViewer,
  Stdctrls,
  UMagDefinitions,
  ImgList,
  ToolWin ,
  imaginterfaces
  ;

//Uses Vetted 20090929:ImgList, ToolWin, Dialogs, Graphics, Variants, Messages, uMagClasses, SysUtils, Windows

Type
  // Event handler for updating the Rad Viewer that the apply to all state has
  // been changed - this is the only item on the Rad Viewer that shows with
  // the current state, so it needs to be updated
  TMagApplyToAllChangeEvent = Procedure(Sender: Tobject; ApplyToAll: Boolean) Of Object;

  TMagPrintClickEvent = Procedure(Sender: Tobject; Viewer: IMag4Viewer) Of Object;
  TMagCopyClickEvent = Procedure(Sender: Tobject; Viewer: IMag4Viewer) Of Object;

  TmagViewerRadTB2 = Class(TFrame)
    TbarViewer: TToolBar;
    TbApplyToAll: TToolButton;
    TbReset: TToolButton;
    TbFitWin: TToolButton;
    TbFitHeight: TToolButton;
    TbFitWidth: TToolButton;
    TbFit1to1: TToolButton;
    TbFlipVert: TToolButton;
    TbFlipHoriz: TToolButton;
    Tb270: TToolButton;
    Tb90: TToolButton;
    TbReverse: TToolButton;
    ToolButton1: TToolButton;
    ImageList1: TImageList;
    TbMousePan: TToolButton;
    TbMouseMagnify: TToolButton;
    TbMouseZoomRect: TToolButton;
    TbRuler: TToolButton;
    TbProtractor: TToolButton;
    TbRulerPointer: TToolButton;
    tbAutoWinLev: TToolButton;
    ToolButton2: TToolButton;
    tbPanWindow: TToolButton;
    ToolButton4: TToolButton;
    TbCopyImage: TToolButton;
    TbPrintImage: TToolButton;
    TbReport: TToolButton;
    PnlWinLev: Tpanel;
    LblWin: Tlabel;
    LblWinValue: Tlabel;
    sbWin: TScrollBar;
    Lbllev: Tlabel;
    LblLevValue: Tlabel;
    sbLev: TScrollBar;
    ToolButton3: TToolButton;
    pnlZoom: Tpanel;
    Label1: Tlabel;
    sbZoom: TScrollBar;
    tbAnnotToolBar: TToolButton;
    tbRGBChanger: TToolButton; {7/12/12 gek Merge 130->129}
    Procedure TbApplyToAllClick(Sender: Tobject);
    Procedure TbResetClick(Sender: Tobject);
    Procedure TbFitWinClick(Sender: Tobject);
    Procedure TbFitHeightClick(Sender: Tobject);
    Procedure TbFitWidthClick(Sender: Tobject);
    Procedure TbFit1to1Click(Sender: Tobject);
    Procedure TbFlipVertClick(Sender: Tobject);
    Procedure TbFlipHorizClick(Sender: Tobject);
    Procedure Tb270Click(Sender: Tobject);
    Procedure Tb90Click(Sender: Tobject);
    Procedure TbReverseClick(Sender: Tobject);
    Procedure TbMousePanClick(Sender: Tobject);
    Procedure TbMouseMagnifyClick(Sender: Tobject);
    Procedure TbMouseZoomRectClick(Sender: Tobject);
    Procedure TbRulerClick(Sender: Tobject);
    Procedure TbProtractorClick(Sender: Tobject);
    Procedure TbRulerPointerClick(Sender: Tobject);
    Procedure tbAutoWinLevClick(Sender: Tobject);
    Procedure tbPanWindowClick(Sender: Tobject);
    Procedure sbWinChange(Sender: Tobject);
    Procedure sbLevChange(Sender: Tobject);
    Procedure sbZoomChange(Sender: Tobject);
    Procedure TbarViewerResize(Sender: Tobject);
    Procedure TbCopyImageClick(Sender: Tobject);
    Procedure TbReportClick(Sender: Tobject);
    Procedure TbPrintImageClick(Sender: Tobject);
    procedure tbAnnotToolBarClick(Sender: TObject);
    procedure tbRGBChangerClick(Sender: TObject); {7/12/12 gek Merge 130->129}
  Private
    FNoClickOnZoom: Boolean;
    FDICOMViewer: Boolean;
    FCurViewer: IMag4Viewer;
    FImagePageCount: Integer;

    FViewerArray: Array Of IMag4Viewer;
    FApplyToAllEvent: TMagApplyToAllChangeEvent;


    FWinLevScrollEnabled: Boolean;

    FPrintClickEvent: TMagPrintClickEvent;
    FCopyClickEvent: TMagCopyClickEvent;

    FCurrentRGBState : Integer;   {/p122rgb dmmn 12/12/11 - RGBChanger state /} {7/12/12 gek Merge 130->129}


    Procedure SetDICOMViewer(Value: Boolean);
    Procedure UpdateImageZoomState();
    Procedure ApplyViewerState(Viewer: IMag4Viewer);
    Procedure ApplyImageFunctions(VGear: TMag4VGear);
    Procedure ApplyImageState(VGear: TMag4VGear);
    Procedure CheckMouseState(State: TMagImageMouse);
  Public
    Constructor Create(AOwner: TComponent); Override;
    Procedure AddViewerToToolbar(Viewer: IMag4Viewer);
    Procedure RemoveViewerFromToolbar(Viewer: IMag4Viewer);
    Procedure ClearViewersFromToolbar();
    Procedure DisablePanWindow();

    // JMW 8/11/08 p72t26 - the following functions are needed for 508
    // compliance so the Rad Viewer menus can set functions normally done
    // by the toolbar
    Procedure SetCurrentTool(Tool: TMagImageMouse);
    Procedure ScrollCornerTL();
    Procedure ScrollCornerTR();
    Procedure ScrollCornerBL();
    Procedure ScrollCornerBR();
    Procedure ScrollLeft();
    Procedure ScrollRight();
    Procedure ScrollUp();
    Procedure ScrollDown();
    Procedure PanWindow();
    Procedure Inverse();
    Procedure RGBChanger(CurrentState : Integer);
    Procedure ApplyToAll(Value: Boolean);

    // JMW 2/20/2009 p93 - more options that were supposed to be done in P72
    Procedure Rotate90();
    Procedure Rotate180();
    Procedure Rotate270();
    Procedure FlipHorizontal();
    Procedure FlipVertical();

    Procedure UpdateImageState();

    procedure SetCopyImageVisible(Visible : boolean);
    procedure SetPrintImageVisible(Visible : boolean);
    procedure SetApplyToAllVisible(Visible : boolean);
    procedure setRGBVisible(Visible : boolean);

    Property OnApplyToAllEvent: TMagApplyToAllChangeEvent Read FApplyToAllEvent Write FApplyToAllEvent;

    Property MagViewer: IMag4Viewer Read FCurViewer Write FCurViewer;

  Published

    Property DICOMViewer: Boolean Read FDICOMViewer Write SetDICOMViewer;
    Property OnPrintClick: TMagPrintClickEvent Read FPrintClickEvent Write FPrintClickEvent;
    Property OnCopyClick: TMagCopyClickEvent Read FCopyClickEvent Write FCopyClickEvent;

  End;

Procedure Register;

Implementation

Uses
  SysUtils,
  UMagClasses,
  Windows
  ;


{$R *.dfm}


Procedure Register;
Begin
  RegisterComponents('Imaging', [TmagViewerRadTB2]);
End;

Constructor TmagViewerRadTB2.Create(AOwner: TComponent);
Begin
  Inherited;
  AutoSize := True;
  FWinLevScrollEnabled := True;

  tbAutoWinLev.Visible := True;
 {7/12/12 gek Merge 130->129}
  FCurrentRGBState := 0; //p122rgb dmmn - rgb
{/ P122 - JK 7/19/2011 - removed. Logic inside of P122 Annotation Toolbar /}
//  TbRuler.Visible := True;
//  {//ruler// <- other changes in other routines. Search on //ruler//
//         gek p72t13 Disable the Ruler.
//         Also, The mnuToolsRulerEnabled menu item in the RadViewer is disabled
//         in the form.  this will need Enabled when this 'Disable The Ruler' is changed.}
//  TbRuler.Enabled := False; //ruler// gek - I added this line.
//
//  TbProtractor.Visible := True;
//  TbRulerPointer.Visible := True;

  TbarViewer.Update;
End;


Procedure TmagViewerRadTB2.AddViewerToToolbar(Viewer: IMag4Viewer);
Var
  NilIndex, Count, i, Len: Integer;
Begin

  magAppMsg('s', 'TmagViewerRadTB2.addViewerToToolbar', MagmsgDebug);
  NilIndex := -1;
  Count := (High(FViewerArray));
  For i := 0 To Count Do
  Begin
    If (Viewer = FViewerArray[i]) Then
    Begin
        // already in observer list, don't need a second instance
      Exit;
    End
    Else
      If (FViewerArray[i] = Nil) Then
        NilIndex := i;
    Begin
    End;
  End;
  // if there is an empty spot in the array, use that one
  If NilIndex >= 0 Then
  Begin
    FViewerArray[NilIndex] := Viewer;
    Exit;
  End;

  Len := Length(FViewerArray);
  SetLength(FViewerArray, Len + 1);
  FViewerArray[High(FViewerArray)] := Viewer;
End;

Procedure TmagViewerRadTB2.RemoveViewerFromToolbar(Viewer: IMag4Viewer);
Var
  Count, i: Integer;
Begin
  magAppMsg('s', 'TmagViewerRadTB2.removeViewerFromToolbar', MagmsgDebug);
  Count := (High(FViewerArray));
  For i := 0 To Count Do
  Begin
    If (Viewer = FViewerArray[i]) Then
    Begin
      FViewerArray[i] := Nil;
      Exit;
    End;
  End;
End;

Procedure TmagViewerRadTB2.ClearViewersFromToolbar();
Var
  Count, i: Integer;
Begin
//  LogMsg('s','TmagViewerTB.removeViewerFromToolbar', MagLogDEBUG);
  Count := (High(FViewerArray));
  For i := 0 To Count Do
  Begin
    FViewerArray[i] := Nil;
  End;
  // JMW 11/22/2006 p72
  // clear the current viewer now so that the destructor doesn't try to set it
  // nil after the current viewer has already been destroyed (was causing exceptions at closing)
  FCurViewer := Nil;
End;

Procedure TmagViewerRadTB2.ApplyViewerState(Viewer: IMag4Viewer);
Begin
  TbApplyToAll.Down := Viewer.ApplyToAll;
  tbPanWindow.Down := Viewer.PanWindow;
End;

Procedure TmagViewerRadTB2.SetDICOMViewer(Value: Boolean);
Begin
  FDICOMViewer := Value;
  TbReport.Visible := Not FDICOMViewer;
End;

Procedure TmagViewerRadTB2.DisablePanWindow();
Var
  i: Integer;
Begin
  tbPanWindow.Down := False;
  For i := 0 To (High(FViewerArray)) Do
  Begin
    If (FViewerArray[i] <> Nil) Then
      FViewerArray[i].PanWindow := False;
  End;
End;

Procedure TmagViewerRadTB2.SetCurrentTool(Tool: TMagImageMouse);
Begin
  Case Tool Of
    MactPan:
      TbMousePanClick(Self);
    MactMagnify:
      TbMouseMagnifyClick(Self);
    MactZoomRect:
      TbMouseZoomRectClick(Self);
    MactWinLev:
      tbAutoWinLevClick(Self);
//    mactAnnotation:
//      tbAnnotationsClick(self);
    MactMeasure:
      TbRulerClick(Self);
    MactProtractor:
      TbProtractorClick(Self);
    MactAnnotationPointer:
      TbRulerPointerClick(Self);
  End; {case}
  // JMW 8/11/08 - makes the button pressed down - maybe not the most efficient
  // way to do this...
  UpdateImageState();

End;

Procedure TmagViewerRadTB2.ScrollCornerTL();
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].ScrollCornerTL();
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then
      FCurViewer.ScrollCornerTL();
  End;
End;

Procedure TmagViewerRadTB2.ScrollCornerTR();
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].ScrollCornerTR();
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then
      FCurViewer.ScrollCornerTR();
  End;
End;

Procedure TmagViewerRadTB2.ScrollCornerBL();
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].ScrollCornerBL();
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then
      FCurViewer.ScrollCornerBL();
  End;
End;

Procedure TmagViewerRadTB2.ScrollCornerBR();
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].ScrollCornerBR();
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then
      FCurViewer.ScrollCornerBR();
  End;
End;

Procedure TmagViewerRadTB2.ScrollLeft();
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].ScrollLeft();
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then
      FCurViewer.ScrollLeft();
  End;
End;

Procedure TmagViewerRadTB2.ScrollRight();
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].ScrollRight();
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then
      FCurViewer.ScrollRight();
  End;
End;

Procedure TmagViewerRadTB2.ScrollUp();
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].ScrollUp();
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then
      FCurViewer.ScrollUp();
  End;
End;

Procedure TmagViewerRadTB2.ScrollDown();
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].ScrollDown();
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then
      FCurViewer.ScrollDown();
  End;
End;

Procedure TmagViewerRadTB2.PanWindow();
Begin
  tbPanWindow.Down := Not tbPanWindow.Down;
  tbPanWindowClick(Self);
End;

Procedure TmagViewerRadTB2.Inverse();
Begin
  TbReverseClick(Self);
End;

Procedure TmagViewerRadTB2.ApplyToAll(Value: Boolean);
Begin
  TbApplyToAll.Down := Value;
  TbApplyToAllClick(Self);
End;

Procedure TmagViewerRadTB2.Rotate90();
Begin
  Tb90Click(Self);
End;

Procedure TmagViewerRadTB2.Rotate180();
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].Rotate(180);
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then FCurViewer.Rotate(180);
  End;
End;

Procedure TmagViewerRadTB2.Rotate270();
Begin
  Tb270Click(Self);
End;

Procedure TmagViewerRadTB2.FlipHorizontal();
Begin
  TbFlipHorizClick(Self);
End;

Procedure TmagViewerRadTB2.FlipVertical();
Begin
  TbFlipVertClick(Self);
End;

Procedure TmagViewerRadTB2.UpdateImageZoomState();
Var
  VGear: TMag4VGear;
  State: TMagImageState;
Begin
  If FCurViewer = Nil Then Exit;
  VGear := FCurViewer.GetCurrentImage();
  If VGear = Nil Then Exit;
  State := VGear.GetState();

  sbZoom.Position := State.ZoomValue;
End;

// JMW 4/14/2006 p72 - apply Image Gear functions, IG14 can do more than IG99

Procedure TmagViewerRadTB2.ApplyImageFunctions(VGear: TMag4VGear);
Var
  ImgState: TMagImageState;
Begin
  // JMW 5/13/08 p72t22 - calling FreeAndNil below when this is not initialized
  // was causing the Rad viewer cMag4Viewer to become nil (no idea why...)
  // set imgState to nil to start (to avoid FreeAndNil below when not necessary)
  ImgState := Nil;
  If VGear = Nil Then
  Begin
//    tbAnnotations.Enabled := false;
    TbRuler.Enabled := False;
    TbProtractor.Enabled := False;
    TbRulerPointer.Enabled := False;
  End
  Else
  Begin
    If MagAnnotation In VGear.ComponentFunctions Then
    Begin
//      tbAnnotations.Enabled := true;
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
//      tbAnnotations.Enabled := false;
      TbRuler.Enabled := False;
      TbProtractor.Enabled := False;
      TbRulerPointer.Enabled := False;
    End;
  End;

  //TODO: apply more functions (DICOM, etC)
  If ImgState <> Nil Then
    FreeAndNil(ImgState);
End;

Procedure TmagViewerRadTB2.ApplyImageState(VGear: TMag4VGear);
Var
  Imagestate: TMagImageState;
  x, y: Integer;
  Imagept: TPoint;
Begin
  If (VGear = Nil) Then
    Imagestate := Nil
  // JMW 4/17/09 P93 if image is not loaded, don't apply values
  Else
    If (Not VGear.ImageLoaded) Then
      Imagestate := Nil
    Else
      Imagestate := VGear.GetState;
  If Imagestate = Nil Then Exit;
  FImagePageCount := Imagestate.PageCount;
  FNoClickOnZoom := True;
  Try
    sbZoom.Position := Imagestate.ZoomValue;
  Finally
    FNoClickOnZoom := False;
  End;
  If Imagestate.WinLevEnabled Then
  Begin
//    tbicWin.Min := -2048;
//    tbicLev.Min := -2048;
    Lbllev.caption := 'Lev.';
    LblWin.caption := 'Win.';
    sbwin.Hint := 'Change Window Value';
    sbLev.Hint := 'Change Level Value';

    FWinLevScrollEnabled := False;

    sbWin.Min := Imagestate.WinMinValue;
    If Imagestate.WinMaxValue < Imagestate.WinMinValue Then
      sbWin.Max := sbWin.Min
    Else
      sbWin.Max := Imagestate.WinMaxValue;
    sbWin.Position := Imagestate.WinValue;
    sbwin.SmallChange := 1;
    sbwin.LargeChange := 4;

    LblWinValue.caption := Inttostr(sbWin.Position);

    {/ P122 - JK 10/17/2011 - when bringing in a Full Res radiology image, the new levminvalue sometimes
       is greater than the sblev.max value, resulting in a scrollbar range exception. So what I do is
       reset the scrollbar's max value to the new Imagestate min value and a few lines further, the sbLev.Max
       value is set to the Imagestate max value. /}
    if Imagestate.Levminvalue > sbLev.Max then
      sbLev.Max := Imagestate.Levminvalue;

    sbLev.Min := Imagestate.Levminvalue;
    // JMW 4/30/2009 p93 - add check to make sure if the max value is 0, then
    // the set value is at least 1
    If Imagestate.Levmaxvalue < Imagestate.Levminvalue Then
      sbLev.Max := sbLev.Min
    Else
      If Imagestate.Levmaxvalue = 0 Then
        sblev.Max := 1
      Else
        sbLev.Max := Imagestate.Levmaxvalue;

    // JMW 12/1/06 - moved above re-enabling scroll events, not sure if this is correct or if it will break something else
    // seems like an update to the state should never actually efect the image, right?
    sbLev.Position := Imagestate.LevValue;

    // renable scroll bar for last event (12/1/06 - not anymore...)
    FWinLevScrollEnabled := True;
  End
  Else
  Begin
    //tbicWin.Min := 0;//JW's fix slider.
    //tbicLev.Min := 0;
    Lbllev.caption := 'Con.';
    LblWin.caption := 'Bri.';
    sbWin.Hint := 'Change Brightness Value';
    sbLev.Hint := 'Change Contrast Value';
    FWinLevScrollEnabled := False;
    sbWin.Min := -900;
    sbWin.Max := 1100;
    sbwin.SmallChange := 10;
    sbwin.LargeChange := 40;
    sbWin.Position := (Imagestate.BrightnessValue);

    sbLev.Min := 0;
    sbLev.Max := 255;
    FWinLevScrollEnabled := True;
    sbLev.Position := Imagestate.ContrastValue;
  End;
  LblLevValue.caption := Inttostr(sbLev.Position);
   { TODO 5 -c59 Merge : 59 merge item.  we need the SetScroll functions in MagViewer. }
   //self.MagViewer.SetScroll(imagestate.ScrollHoriz,imagestate.ScrollVert);//59
  Imagept := VGear.ClientOrigin;
  //x := imagept.x - 100 + vGear.Width;
  x := Imagept.x + VGear.Width;
  y := Imagept.y;

//  ToolBar1.Visible := imagestate.WinLevEnabled;

  tbAutoWinLev.Enabled := Imagestate.WinLevEnabled;

  // below allows the ruler pointer to be enabled/disabled based on the # of annotations (> 1)
//  tbRulerPointer.Enabled := imagestate.AnnotationsDrawn;

  // JMW 6/27/2006
  // if current mouse action on selected image is auto win lev, set button to down

  CheckMouseState(Imagestate.MouseAction);
 {7/12/12 gek Merge 130->129}
  {/p122rgb dmmn 12/13/11 - update the RBC icon to reflect appropriate state/}
  tbRGBChanger.Enabled := ImageState.RGBEnabled;
  FCurrentRGBState := ImageState.RGBState;
  if ImageState.RGBEnabled then
  begin
    case ImageState.RGBState of
      0: tbRGBChanger.ImageIndex := 25;
      1: tbRGBChanger.ImageIndex := 26;
      2: tbRGBChanger.ImageIndex := 27;
      3: tbRGBChanger.ImageIndex := 28;
    end;
  end
  else
    tbRGBChanger.ImageIndex := 25;

  If Imagestate <> Nil Then
    FreeAndNil(Imagestate);
End;

Procedure TmagViewerRadTB2.UpdateImageState;
Begin
  If (FCurViewer <> Nil) Then
  Begin
    ApplyImageState(FCurViewer.GetCurrentImage);
    ApplyViewerState(FCurViewer);
    ApplyImageFunctions(FCurViewer.GetCurrentImage);
  End;
End;

Procedure TmagViewerRadTB2.CheckMouseState(State: TMagImageMouse);
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
        tbAutoWinLev.Down := True;
      End;
    MactAnnotation:
      Begin
//      tbAnnotations.Down := true;
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

Procedure TmagViewerRadTB2.TbApplyToAllClick(Sender: Tobject);
Var
  i: Integer;
Begin
  For i := 0 To (High(FViewerArray)) Do
  Begin
    If (FViewerArray[i] <> Nil) Then
      FViewerArray[i].ApplyToAll := TbApplyToAll.Down;
  End;
  If Assigned(FApplyToAllEvent) Then
    FApplyToAllEvent(Self, TbApplyToAll.Down);

End;

Procedure TmagViewerRadTB2.TbResetClick(Sender: Tobject);
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].ResetImages();
    End;
    UpdateImageState();
  End
  Else
  Begin
    If FCurViewer <> Nil Then
    Begin
      FCurViewer.ResetImages;
    // Changing the next 3 controls, on this reset, is
    //  actually changing the property again.
    { TODO : Not Show Stopper, have to get way to stop the double processing. }

      If LblWin.caption = 'Bri.' Then
      Begin
        sbWin.Position := 100;
        sbLev.Position := 100;
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
 {7/12/12 gek Merge 130->129}
  tbRGBChanger.ImageIndex := 25;  {/ P130 - JK 4/21/2012 /}
End;

Procedure TmagViewerRadTB2.TbFitWinClick(Sender: Tobject);
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].FitToWindow;
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then FCurViewer.FitToWindow;
  End;
  UpdateImageZoomState();
End;

Procedure TmagViewerRadTB2.TbFitHeightClick(Sender: Tobject);
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
      Begin
        FViewerArray[i].FitToHeight;
        Application.Processmessages;
//gek 93 Stop Automatic Mouse Pan           FViewerArray[i].MousePan;
      End;
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then FCurViewer.FitToHeight;
    Application.Processmessages;
//gek 93 Stop Automatic Mouse Pan       if FcurViewer <> nil then FcurViewer.MousePan;
  End;
  UpdateImageZoomState();

End;

Procedure TmagViewerRadTB2.TbFitWidthClick(Sender: Tobject);
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
      Begin
        FViewerArray[i].FitToWidth;
        Application.Processmessages;
//gek 93 Stop Automatic Mouse Pan           FViewerArray[i].MousePan;
      End;
    End
  End
  Else
  Begin
    If FCurViewer <> Nil Then FCurViewer.FitToWidth;
    Application.Processmessages;
//gek 93 Stop Automatic Mouse Pan       if FcurViewer <> nil then FcurViewer.MousePan;
  End;
  UpdateImageZoomState();

End;

Procedure TmagViewerRadTB2.TbFit1to1Click(Sender: Tobject);
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
      Begin
        FViewerArray[i].Fit1to1;
        Application.Processmessages;
//gek 93 Stop Automatic Mouse Pan           FViewerArray[i].MousePan;
      End;
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then
    Begin
      FCurViewer.Fit1to1;
      Application.Processmessages;
//gek 93 Stop Automatic Mouse Pan           FcurViewer.MousePan;
    End;
  End;
  UpdateImageZoomState();

End;

Procedure TmagViewerRadTB2.TbFlipVertClick(Sender: Tobject);
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].FlipVert;
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then FCurViewer.FlipVert;
  End;
End;

Procedure TmagViewerRadTB2.TbFlipHorizClick(Sender: Tobject);
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].FlipHoriz;
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then FCurViewer.FlipHoriz;
  End;
End;

Procedure TmagViewerRadTB2.Tb270Click(Sender: Tobject);
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].Rotate(270);
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then FCurViewer.Rotate(270);
  End;
End;

Procedure TmagViewerRadTB2.Tb90Click(Sender: Tobject);
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].Rotate(90);
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then FCurViewer.Rotate(90);
  End;

End;

procedure TmagViewerRadTB2.tbAnnotToolBarClick(Sender: TObject);
Var
  i: Integer;
Begin
  If Not FWinLevScrollEnabled Then Exit;
  For i := 0 To (High(FViewerArray)) Do
  Begin
    If (FViewerArray[i] <> Nil) Then
      FViewerArray[i].AnnotationPointer();
  End;
end;

Procedure TmagViewerRadTB2.TbReverseClick(Sender: Tobject);
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].Inverse;
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then FCurViewer.Inverse;
  End;

End;
 {7/12/12 gek Merge 130->129}
procedure TmagViewerRadTB2.tbRGBChangerClick(Sender: TObject);
Var
  i: Integer;
begin
  {/p122rgb dmmn 12/7/11 - iterate through the RGB channels of the selected image /}
//  If TbApplyToAll.Down Then
//  Begin
//    For i := 0 To (High(FViewerArray)) Do
//    Begin
//      If (FViewerArray[i] <> Nil) Then
//        FCurrentRGBState := FViewerArray[i].RGBChanger(FCurrentRGBState, True);
//    End;
//  End
//  Else
//  Begin
//    If FCurViewer <> Nil Then
//      FCurrentRGBState := FCurViewer.RGBChanger(FCurrentRGBState, False);
//  End;
//
//  if FCurrentRGBState <> -1 then
//  begin
//    case FCurrentRGBState of
//      0: tbRGBChanger.ImageIndex := 25;
//      1: tbRGBChanger.ImageIndex := 26;
//      2: tbRGBChanger.ImageIndex := 27;
//      3: tbRGBChanger.ImageIndex := 28;
//    end;
//  end;
  RGBChanger(FCurrentRGBState);
end;

procedure TmagViewerRadTB2.RGBChanger(CurrentState : Integer);
Var
  i: Integer;
begin
  {/p130t11 dmmn 4/9/13 - iterate through the RGB channels of the selected image /}
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FCurrentRGBState := FViewerArray[i].RGBChanger(CurrentState, True);
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then
      FCurrentRGBState := FCurViewer.RGBChanger(CurrentState, False);
  End;

  if FCurrentRGBState <> -1 then
  begin
    case FCurrentRGBState of
      0: tbRGBChanger.ImageIndex := 25;
      1: tbRGBChanger.ImageIndex := 26;
      2: tbRGBChanger.ImageIndex := 27;
      3: tbRGBChanger.ImageIndex := 28;
    end;
  end;

end;

Procedure TmagViewerRadTB2.TbMousePanClick(Sender: Tobject);
Var
  i: Integer;
Begin
  For i := 0 To (High(FViewerArray)) Do
  Begin
    If (FViewerArray[i] <> Nil) Then
    Begin
      FViewerArray[i].MousePan;
    End;
  End;

End;

Procedure TmagViewerRadTB2.TbMouseMagnifyClick(Sender: Tobject);
Var
  i: Integer;
Begin
  For i := 0 To (High(FViewerArray)) Do
  Begin
    If (FViewerArray[i] <> Nil) Then
      FViewerArray[i].MouseMagnify;
  End;
End;

Procedure TmagViewerRadTB2.TbMouseZoomRectClick(Sender: Tobject);
Var
  i: Integer;
Begin
  For i := 0 To (High(FViewerArray)) Do
  Begin
    If (FViewerArray[i] <> Nil) Then
      FViewerArray[i].MouseZoomRect;
  End;

End;

Procedure TmagViewerRadTB2.TbRulerClick(Sender: Tobject);
Var
  i: Integer;
Begin
  If Not FWinLevScrollEnabled Then Exit;
  For i := 0 To (High(FViewerArray)) Do
  Begin
    If (FViewerArray[i] <> Nil) Then
      FViewerArray[i].Measurements();
  End;

End;

Procedure TmagViewerRadTB2.TbProtractorClick(Sender: Tobject);
Var
  i: Integer;
Begin
  If Not FWinLevScrollEnabled Then Exit;
  For i := 0 To (High(FViewerArray)) Do
  Begin
    If (FViewerArray[i] <> Nil) Then
      FViewerArray[i].Protractor();
  End;

End;

Procedure TmagViewerRadTB2.TbRulerPointerClick(Sender: Tobject);
Var
  i: Integer;
Begin
  If Not FWinLevScrollEnabled Then Exit;
  For i := 0 To (High(FViewerArray)) Do
  Begin
    If (FViewerArray[i] <> Nil) Then
      FViewerArray[i].AnnotationPointer();
  End;

End;

Procedure TmagViewerRadTB2.tbAutoWinLevClick(Sender: Tobject);
Var
  i: Integer;
Begin
  For i := 0 To (High(FViewerArray)) Do
  Begin
    If (FViewerArray[i] <> Nil) Then
    Begin
      FViewerArray[i].AutoWinLevel();
    End;
  End;
End;

Procedure TmagViewerRadTB2.tbPanWindowClick(Sender: Tobject);
Var
  i: Integer;
Begin
  // always apply to all viewers
  // JMW P72 12/5/2006
  For i := 0 To (High(FViewerArray)) Do
  Begin
    If (FViewerArray[i] <> Nil) Then
      FViewerArray[i].SetPanWindowWithActivateOption(tbPanWindow.Down, False);

  End;
  If FCurViewer <> Nil Then
    FCurViewer.SetPanWindowWithActivateOption(tbPanWindow.Down, True);
End;

Procedure TmagViewerRadTB2.sbWinChange(Sender: Tobject);
Var
  i: Integer;
Begin
  If LblWin.caption = 'Win.' Then
  Begin
    LblWinValue.caption := Inttostr(sbWin.Position);
    LblWinValue.Update();
    If Not FWinLevScrollEnabled Then Exit;
    If TbApplyToAll.Down Then
    Begin
      For i := 0 To (High(FViewerArray)) Do
      Begin
        If (FViewerArray[i] <> Nil) Then
          FViewerArray[i].WinLevValue(sbWin.Position, sbLev.Position);
      End;
    End
    Else
    Begin
      If FCurViewer <> Nil Then FCurViewer.WinLevValue(sbWin.Position, sbLev.Position);
    End;
  End
  Else
  Begin
    LblWinValue.caption := Inttostr(Trunc(sbWin.Position / 10) + 90);
    LblWinValue.Update;
    If Not FWinLevScrollEnabled Then Exit;
    If TbApplyToAll.Down Then
    Begin
      For i := 0 To (High(FViewerArray)) Do
      Begin
        If (FViewerArray[i] <> Nil) Then
          FViewerArray[i].BrightnessValue(sbWin.Position);
      End;
    End
    Else
    Begin
      If FCurViewer <> Nil Then FCurViewer.BrightnessValue(sbWin.Position); //(trunc(tbicBrightness.Position / 10));
    End;
  End;
End;

Procedure TmagViewerRadTB2.sbLevChange(Sender: Tobject);
Var
  i: Integer;
Begin
  If Lbllev.caption = 'Lev.' Then
  Begin
    LblLevValue.caption := Inttostr(sbLev.Position);
    LblLevValue.Update();
    If Not FWinLevScrollEnabled Then Exit;
    If TbApplyToAll.Down Then
    Begin
      For i := 0 To (High(FViewerArray)) Do
      Begin
        If (FViewerArray[i] <> Nil) Then
          FViewerArray[i].WinLevValue(sbWin.Position, sbLev.Position);
      End;
    End
    Else
    Begin
      If FCurViewer <> Nil Then FCurViewer.WinLevValue(sbWin.Position, sbLev.Position);
    End;
  End
  Else
  Begin
    LblLevValue.caption := Inttostr(sbLev.Position);
    LblLevValue.Update;
    If Not FWinLevScrollEnabled Then Exit;
    If TbApplyToAll.Down Then
    Begin
      For i := 0 To (High(FViewerArray)) Do
      Begin
        If (FViewerArray[i] <> Nil) Then
          FViewerArray[i].ContrastValue(sbLev.Position);
      End;
    End
    Else
    Begin
      If FCurViewer <> Nil Then FCurViewer.ContrastValue(sbLev.Position);
    End;
  End;
End;

Procedure TmagViewerRadTB2.sbZoomChange(Sender: Tobject);
Var
  i: Integer;
Begin
//  licZoom.caption := inttostr(sbZoom.position);
//  licZoom.update;
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
      Begin
        FViewerArray[i].ZoomValue(sbZoom.Position);
      End;
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then
    Begin
      FCurViewer.ZoomValue(sbZoom.Position);
    End;
  End;
End;

Procedure TmagViewerRadTB2.TbarViewerResize(Sender: Tobject);
Begin
  If (Align = altop) Then Height := TbarViewer.Height + 2;
  If (Width < TbarViewer.Width) Then
    If (Align = alLeft) Then Width := TbarViewer.Width + 2;
End;

Procedure TmagViewerRadTB2.TbCopyImageClick(Sender: Tobject);
Begin
  If (FCurViewer <> Nil) Then
  Begin
    If Assigned(OnCopyClick) Then
      Self.OnCopyClick(Self, FCurViewer)
    Else
      FCurViewer.ImageCopy;
  End;
End;

Procedure TmagViewerRadTB2.TbReportClick(Sender: Tobject);
Begin
  If (FCurViewer <> Nil) Then FCurViewer.ImageReport;
End;

Procedure TmagViewerRadTB2.TbPrintImageClick(Sender: Tobject);
Begin
  If (FCurViewer <> Nil) Then
  Begin
    If Assigned(OnPrintClick) Then
      Self.OnPrintClick(Self, FCurViewer)
    Else
      FCurViewer.ImagePrint;        {BM-ImagePrint-}
  End;
End;

procedure TmagViewerRadTB2.SetCopyImageVisible(Visible : boolean);
begin
  TbCopyImage.Visible := Visible;
end;

procedure TmagViewerRadTB2.SetPrintImageVisible(Visible : boolean);
begin
  TbPrintImage.Visible := Visible;
end;

procedure TmagViewerRadTB2.SetApplyToAllVisible(Visible : boolean);
begin
  TbApplyToAll.Visible := Visible;
end;

procedure TmagViewerRadTB2.setRGBVisible(Visible : boolean);
begin
  tbRGBChanger.Visible := Visible;
end;

End.
