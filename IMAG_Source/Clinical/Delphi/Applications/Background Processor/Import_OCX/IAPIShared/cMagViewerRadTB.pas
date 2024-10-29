{
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: December, 2006
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  Julian Werfel
  Description:
    Toolbar used for functions specified to the Radiology Viewer. This extends
    the base viewer toolbar.

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
Unit cMagViewerRadTB;

Interface

Uses
  Classes,
  cMagViewerTB,
  IMagViewer,
  UMagDefinitions,
  Menus,
  ImgList,
  Controls,
  Stdctrls,
  ComCtrls,
  ExtCtrls,
  ToolWin
  ;

//Uses Vetted 20090929:cMag4VGear, ToolWin, ExtCtrls, ComCtrls, StdCtrls, ImgList, Menus, Dialogs, Controls, Graphics, Variants, Messages, Windows, cMagLogManager, Forms, SysUtils

Type
  TMagViewerRadTB = Class;

  // Event handler for updating the Rad Viewer that the apply to all state has
  // been changed - this is the only item on the Rad Viewer that shows with
  // the current state, so it needs to be updated
  TMagApplyToAllChangeEvent = Procedure(Sender: Tobject; ApplyToAll: Boolean) Of Object;

  TMagViewerRadTB = Class(TMagViewerTB)
    Procedure TbApplyToAllClick(Sender: Tobject);
    Procedure TbFitHeightClick(Sender: Tobject);
    Procedure TbReverseClick(Sender: Tobject);
    Procedure TbFitWidthClick(Sender: Tobject);
    Procedure Tb270Click(Sender: Tobject);
    Procedure Tb90Click(Sender: Tobject);
    Procedure TbMousePanClick(Sender: Tobject);
    Procedure TbMouseMagnifyClick(Sender: Tobject);
    Procedure TbMouseZoomRectClick(Sender: Tobject);
    Procedure TbPanWindow1Click(Sender: Tobject);
    Procedure TbTileClick(Sender: Tobject);
    Procedure TbFitWinClick(Sender: Tobject);
    Procedure TbFit1to1Click(Sender: Tobject);
    Procedure TbFlipVertClick(Sender: Tobject);
    Procedure TbFlipHorizClick(Sender: Tobject);
    Procedure StaticPages1Click(Sender: Tobject);
    Procedure Virtual1Click(Sender: Tobject);
    Procedure Dynamiccustom1Click(Sender: Tobject);
    Procedure TbViewerSettingsClick(Sender: Tobject);
    Procedure TbClearViewerClick(Sender: Tobject);
    Procedure TbicZoomChange(Sender: Tobject);
    Procedure btnPageFirstClick(Sender: Tobject);
    Procedure TbtnPagePrevClick(Sender: Tobject);
    Procedure TbtnPageNextClick(Sender: Tobject);
    Procedure TbtnPageLastClick(Sender: Tobject);
    Procedure TbResetClick(Sender: Tobject);
    Procedure MnuReAlignClick(Sender: Tobject);
    Procedure TbRefreshClick(Sender: Tobject);
    Procedure TbMousePointerClick(Sender: Tobject);
    Procedure btnAutoWinLevClick(Sender: Tobject);
    Procedure TbicWinChange(Sender: Tobject);
    Procedure TbicLevChange(Sender: Tobject);
    Procedure TbRulerClick(Sender: Tobject);
    Procedure TbRulerPointerClick(Sender: Tobject);
    Procedure TbProtractorClick(Sender: Tobject);
  Private

    FDICOMViewer: Boolean;

    FViewerArray: Array Of IMag4Viewer;
    FApplyToAllEvent: TMagApplyToAllChangeEvent;
    Procedure SetDICOMViewer(Value: Boolean);
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
    Procedure ApplyToAll(Value: Boolean);

    // JMW 2/20/2009 p93 - more options that were supposed to be done in P72
    Procedure Rotate90();
    Procedure Rotate180();
    Procedure Rotate270();
    Procedure FlipHorizontal();
    Procedure FlipVertical();

    Property OnApplyToAllEvent: TMagApplyToAllChangeEvent Read FApplyToAllEvent Write FApplyToAllEvent;

  Protected

  Published

    Property DICOMViewer: Boolean Read FDICOMViewer Write SetDICOMViewer;

  End;

{
var
  magViewerRadTB: TmagViewerRadTB;
}

Procedure Register;

Implementation
Uses
  //cMagLogManager,  {JK 10/5/2009 - Maggmsgu refactoring - deprecated unit}
  Maggmsgu,
  Forms,
  SysUtils
  ;

{$R *.dfm}

Procedure Register;
Begin
  RegisterComponents('Imaging', [TMagViewerRadTB]);
End;

Constructor TMagViewerRadTB.Create(AOwner: TComponent);
Begin
  Inherited;

  btnAutoWinLev.Visible := True;

  TbRemoveImage.Visible := False;
  TbTile.Visible := False;
  TbClearViewer.Visible := False;
  ToolButton10.Visible := False;

  // hide paging buttons in Rad Viewer
  btnPageFirst.Visible := False;
  TbtnPagePrev.Visible := False;
  TbtnPageNext.Visible := False;
  TbtnPageLast.Visible := False;
  TbePage.Visible := False;
  TblbPageCount.Visible := False;

  TbRuler.Visible := True;
  {//ruler// <- other changes in other routines. Search on //ruler//
         gek p72t13 Disable the Ruler.
         Also, The mnuToolsRulerEnabled menu item in the RadViewer is disabled
         in the form.  this will need Enabled when this 'Disable The Ruler' is changed.}
  TbRuler.Enabled := False; //ruler// gek - I added this line.

  TbProtractor.Visible := True;
  TbRulerPointer.Visible := True;

  TbMaximize.Visible := False;

  TbarViewer.Update;
End;

Procedure TMagViewerRadTB.AddViewerToToolbar(Viewer: IMag4Viewer);
Var
  NilIndex, Count, i, Len: Integer;
Begin
//  FViewerList.Add(@Viewer);

  //LogMsg('s','TmagViewerTB.addViewerToToolbar', MagLogDEBUG);
  MagLogger.LogMsg('s', 'TmagViewerTB.addViewerToToolbar', MagLogDebug); {JK 10/6/2009 - Maggmsgu refactoring}
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

Procedure TMagViewerRadTB.RemoveViewerFromToolbar(Viewer: IMag4Viewer);
Var
  Count, i: Integer;
Begin
  //LogMsg('s','TmagViewerTB.removeViewerFromToolbar', MagLogDEBUG);
  MagLogger.LogMsg('s', 'TmagViewerTB.removeViewerFromToolbar', MagLogDebug); {JK 10/6/2009 - Maggmsgu refactoring}
  Count := (High(FViewerArray));
  For i := 0 To Count Do
  Begin
    If (Viewer = FViewerArray[i]) Then
    Begin
      FViewerArray[i] := Nil;
      Exit;
    End;
  End;
//  FViewerList.Remove(@Viewer);
End;

Procedure TMagViewerRadTB.ClearViewersFromToolbar();
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
//  FViewerList.Remove(@Viewer);
End;

Procedure TMagViewerRadTB.TbApplyToAllClick(Sender: Tobject);
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

Procedure TMagViewerRadTB.TbReverseClick(Sender: Tobject);
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

Procedure TMagViewerRadTB.TbFitWidthClick(Sender: Tobject);
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

Procedure TMagViewerRadTB.Tb270Click(Sender: Tobject);
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

Procedure TMagViewerRadTB.Tb90Click(Sender: Tobject);
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

Procedure TMagViewerRadTB.TbMousePanClick(Sender: Tobject);
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

Procedure TMagViewerRadTB.TbMouseMagnifyClick(Sender: Tobject);
Var
  i: Integer;
Begin
  For i := 0 To (High(FViewerArray)) Do
  Begin
    If (FViewerArray[i] <> Nil) Then
      FViewerArray[i].MouseMagnify;
  End;
End;

Procedure TMagViewerRadTB.TbMouseZoomRectClick(Sender: Tobject);
Var
  i: Integer;
Begin
  For i := 0 To (High(FViewerArray)) Do
  Begin
    If (FViewerArray[i] <> Nil) Then
      FViewerArray[i].MouseZoomRect;
  End;
End;

Procedure TMagViewerRadTB.TbPanWindow1Click(Sender: Tobject);
Var
  i: Integer;
Begin
  // always apply to all viewers
  // JMW P72 12/5/2006
  For i := 0 To (High(FViewerArray)) Do
  Begin
    If (FViewerArray[i] <> Nil) Then
      FViewerArray[i].SetPanWindowWithActivateOption(TbPanWindow1.Down, False);
//      FViewerArray[i].PanWindow := tbPanWindow1.Down;
  End;
  If FCurViewer <> Nil Then
    FCurViewer.SetPanWindowWithActivateOption(TbPanWindow1.Down, True);
End;

Procedure TMagViewerRadTB.TbTileClick(Sender: Tobject);
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].TileAll;
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then FCurViewer.TileAll;
  End;
End;

Procedure TMagViewerRadTB.TbFitWinClick(Sender: Tobject);
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

Procedure TMagViewerRadTB.TbFit1to1Click(Sender: Tobject);
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

Procedure TMagViewerRadTB.TbFlipVertClick(Sender: Tobject);
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

Procedure TMagViewerRadTB.TbFlipHorizClick(Sender: Tobject);
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

Procedure TMagViewerRadTB.StaticPages1Click(Sender: Tobject);
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].ViewerStyle := MagvsStaticPage;
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then FCurViewer.ViewerStyle := MagvsStaticPage;
  End;
End;

Procedure TMagViewerRadTB.Virtual1Click(Sender: Tobject);
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].ViewerStyle := MagvsVirtual;
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then FCurViewer.ViewerStyle := MagvsVirtual;
  End;
End;

Procedure TMagViewerRadTB.Dynamiccustom1Click(Sender: Tobject);
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].ViewerStyle := MagvsDynamic;
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then FCurViewer.ViewerStyle := MagvsDynamic;
  End;
End;

Procedure TMagViewerRadTB.TbViewerSettingsClick(Sender: Tobject);
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].EditViewerSettings;
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then
    Begin
        //RowColSize.execute(FCurViewer);
      FCurViewer.EditViewerSettings;
    End;
  End;
End;

Procedure TMagViewerRadTB.TbClearViewerClick(Sender: Tobject);
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].ClearViewer();
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then FCurViewer.ClearViewer;
  End;
End;

Procedure TMagViewerRadTB.TbicZoomChange(Sender: Tobject);
Var
  i: Integer;
Begin
  LicZoom.caption := Inttostr(TbicZoom.Position);
  LicZoom.Update;
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
      Begin
        FViewerArray[i].ZoomValue(TbicZoom.Position);
//        FViewerArray[i].MousePan(); // JMW p72 12/6/2006 Don't go back to hand pan automatically
      End;
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then
    Begin
      FCurViewer.ZoomValue(TbicZoom.Position);
//        FcurViewer.MousePan; // JMW p72 12/6/2006 Don't go back to hand pan automatically
    End;
  End;
End;

Procedure TMagViewerRadTB.btnPageFirstClick(Sender: Tobject);
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].PageFirstImage;
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then FCurViewer.PageFirstImage;
  End;
  UpdateImageState;
End;

Procedure TMagViewerRadTB.TbtnPagePrevClick(Sender: Tobject);
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].PagePrevImage;
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then FCurViewer.PagePrevImage;
  End;
  UpdateImageState;
End;

Procedure TMagViewerRadTB.TbtnPageNextClick(Sender: Tobject);
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].PageNextImage;
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then FCurViewer.PageNextImage;
  End;
//  GoToNextPage;
  UpdateImageState;
End;

Procedure TMagViewerRadTB.TbtnPageLastClick(Sender: Tobject);
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].PageLastImage;
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then FCurViewer.PageLastImage;
  End;
//  GoToPage(9999999);
  UpdateImageState;
End;

Procedure TMagViewerRadTB.TbResetClick(Sender: Tobject);
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
End;

Procedure TMagViewerRadTB.MnuReAlignClick(Sender: Tobject);
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].ReAlignImages(True);
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then FCurViewer.ReAlignImages(True);
  End;
End;

Procedure TMagViewerRadTB.TbRefreshClick(Sender: Tobject);
Var
  i: Integer;
Begin
  If TbApplyToAll.Down Then
  Begin
    For i := 0 To (High(FViewerArray)) Do
    Begin
      If (FViewerArray[i] <> Nil) Then
        FViewerArray[i].ReFreshImages;
    End;
  End
  Else
  Begin
    If FCurViewer <> Nil Then FCurViewer.ReFreshImages;
  End;
End;

Procedure TMagViewerRadTB.TbMousePointerClick(Sender: Tobject);
Var
  i: Integer;
Begin
  For i := 0 To (High(FViewerArray)) Do
  Begin
    If (FViewerArray[i] <> Nil) Then
      FViewerArray[i].MouseReSet;
  End;
End;

Procedure TMagViewerRadTB.TbFitHeightClick(Sender: Tobject);
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

Procedure TMagViewerRadTB.SetDICOMViewer(Value: Boolean);
Begin
  FDICOMViewer := Value;
//  tbReport.Enabled := not FDICOMViewer;
  TbReport.Visible := Not FDICOMViewer;
End;

Procedure TMagViewerRadTB.btnAutoWinLevClick(Sender: Tobject);
Var
  i: Integer;
Begin
  For i := 0 To (High(FViewerArray)) Do
  Begin
    If (FViewerArray[i] <> Nil) Then
    Begin
      FViewerArray[i].AutoWinLevel();
    {
      if btnAutoWinLev.Down then
        FViewerArray[i].setCurrentTool(mactWinLev)
//        FViewerArray[i].AutoWinLevel
      else
        FViewerArray[i].setCurrentTool(mactPan);
//        FViewerArray[i].MousePan;
}
    End;
  End;

  {
  if tbApplyToAll.Down then
  for i := 0 to (high(FViewerArray)) do
  begin
    if(FViewerArray[i] <> nil) then
    begin
      if btnAutoWinLev.Down then
        FViewerArray[i].AutoWinLevel
      else
        FViewerArray[i].MousePan;
    end;
  end
  else
  begin
    if FcurViewer <> nil then
    begin
      if btnAutoWinLev.Down then
        FcurViewer.AutoWinLevel
      else
        FCurViewer.MousePan;
    end;
  end;
  }
  // this should be moved to a function!
  {
  tbRulerPointer.Down := false;
  tbRuler.Down := false;
  tbAnnotations.Down := false;
  }
End;

Procedure TMagViewerRadTB.TbicWinChange(Sender: Tobject);
Var
  i: Integer;
Begin
  If LblWin.caption = 'Win.' Then
  Begin
    LblWinValue.caption := Inttostr(TbicWin.Position);
    LblWinValue.Update();
    If Not FWinLevScrollEnabled Then Exit;
    If TbApplyToAll.Down Then
    Begin
      For i := 0 To (High(FViewerArray)) Do
      Begin
        If (FViewerArray[i] <> Nil) Then
          FViewerArray[i].WinLevValue(TbicWin.Position, TbicLev.Position);
      End;
    End
    Else
    Begin
      If FCurViewer <> Nil Then FCurViewer.WinLevValue(TbicWin.Position, TbicLev.Position);
    End;
  End
  Else
  Begin
    LblWinValue.caption := Inttostr(Trunc(TbicWin.Position / 10) + 90);
    LblWinValue.Update;
    If Not FWinLevScrollEnabled Then Exit;
    If TbApplyToAll.Down Then
    Begin
      For i := 0 To (High(FViewerArray)) Do
      Begin
        If (FViewerArray[i] <> Nil) Then
          FViewerArray[i].BrightnessValue(TbicWin.Position);
      End;
    End
    Else
    Begin
      If FCurViewer <> Nil Then FCurViewer.BrightnessValue(TbicWin.Position); //(trunc(tbicBrightness.Position / 10));
    End;
  End;
End;

Procedure TMagViewerRadTB.TbicLevChange(Sender: Tobject);
Var
  i: Integer;
Begin
  If Lbllev.caption = 'Lev.' Then
  Begin
    LblLevValue.caption := Inttostr(TbicLev.Position);
    LblLevValue.Update();
    If Not FWinLevScrollEnabled Then Exit;
    If TbApplyToAll.Down Then
    Begin
      For i := 0 To (High(FViewerArray)) Do
      Begin
        If (FViewerArray[i] <> Nil) Then
          FViewerArray[i].WinLevValue(TbicWin.Position, TbicLev.Position);
      End;
    End
    Else
    Begin
      If FCurViewer <> Nil Then FCurViewer.WinLevValue(TbicWin.Position, TbicLev.Position);
    End;
  End
  Else
  Begin
    LblLevValue.caption := Inttostr(TbicLev.Position);
    LblLevValue.Update;
    If Not FWinLevScrollEnabled Then Exit;
    If TbApplyToAll.Down Then
    Begin
      For i := 0 To (High(FViewerArray)) Do
      Begin
        If (FViewerArray[i] <> Nil) Then
          FViewerArray[i].ContrastValue(TbicLev.Position);
      End;
    End
    Else
    Begin
      If FCurViewer <> Nil Then FCurViewer.ContrastValue(TbicLev.Position); //(tbicContrast.Position / 100);
    End;
  End;
End;

Procedure TMagViewerRadTB.TbRulerClick(Sender: Tobject);
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

Procedure TMagViewerRadTB.TbRulerPointerClick(Sender: Tobject);
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

Procedure TMagViewerRadTB.TbProtractorClick(Sender: Tobject);
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

Procedure TMagViewerRadTB.DisablePanWindow();
Var
  i: Integer;
Begin
  TbPanWindow1.Down := False;
  For i := 0 To (High(FViewerArray)) Do
  Begin
    If (FViewerArray[i] <> Nil) Then
      FViewerArray[i].PanWindow := False;
  End;
End;

Procedure TMagViewerRadTB.SetCurrentTool(Tool: TMagImageMouse);
Begin
  Case Tool Of
    MactPan:
      TbMousePanClick(Self);
    MactMagnify:
      TbMouseMagnifyClick(Self);
    MactZoomRect:
      TbMouseZoomRectClick(Self);
    MactWinLev:
      btnAutoWinLevClick(Self);
    MactAnnotation:
      TbAnnotationsClick(Self);
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

Procedure TMagViewerRadTB.ScrollCornerTL();
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

Procedure TMagViewerRadTB.ScrollCornerTR();
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

Procedure TMagViewerRadTB.ScrollCornerBL();
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

Procedure TMagViewerRadTB.ScrollCornerBR();
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

Procedure TMagViewerRadTB.ScrollLeft();
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

Procedure TMagViewerRadTB.ScrollRight();
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

Procedure TMagViewerRadTB.ScrollUp();
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

Procedure TMagViewerRadTB.ScrollDown();
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

Procedure TMagViewerRadTB.PanWindow();
Begin
  TbPanWindow1.Down := Not TbPanWindow1.Down;
  TbPanWindow1Click(Self);
End;

Procedure TMagViewerRadTB.Inverse();
Begin
  TbReverseClick(Self);
End;

Procedure TMagViewerRadTB.ApplyToAll(Value: Boolean);
Begin
  TbApplyToAll.Down := Value;
  TbApplyToAllClick(Self);
End;

Procedure TMagViewerRadTB.Rotate90();
Begin
  Tb90Click(Self);
End;

Procedure TMagViewerRadTB.Rotate180();
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

Procedure TMagViewerRadTB.Rotate270();
Begin
  Tb270Click(Self);
End;

Procedure TMagViewerRadTB.FlipHorizontal();
Begin
  TbFlipHorizClick(Self);
End;

Procedure TMagViewerRadTB.FlipVertical();
Begin
  TbFlipVertClick(Self);
End;

End.
