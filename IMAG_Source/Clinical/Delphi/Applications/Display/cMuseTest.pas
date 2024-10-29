Unit cMuseTest;
{
  Package: EKG Display
  Date Created: 06/11/2003
  Site Name: Silver Spring
  Developers: Robert Graves
  Description: TMuseTest contains the test data and images loaded from the MUSE.
                The images are loaded into a ScrollBox for display on the screen.
                This unit also contains TEKGImage which is an internal class that
                should only ever be referenced directly from TMuseTest.
}
Interface

Uses
  cEvtScroll,
  Classes,
  Controls,
  DMuseConnection,
  ExtCtrls,
  Forms,
  Graphics,
  Messages,
  MuseDeclarations,
  Stdctrls
  ;

//Uses Vetted 20090929:Printers, Sysutils, Dialogs, Windows

Type
  TMuseTest = Class(TEventScrollBox)
  Protected
    Procedure WMHScroll(Var Message: TWMHScroll); Override;
    Procedure WMVScroll(Var Message: TWMHScroll); Override;
    Procedure Resize(); Override;
  Public
    Loaded: Boolean;
    PatientID: String;
    TestInfo: MUSE_TEST_INFORMATION_PTR;
    TestFileInfo: ImgPage;
    MuseConnection: TMagMuseBaseConnection;
    Zoom: Integer;
    GridOn: Boolean;
    TextOverlayOn: Boolean;
    Images: Tlist;
    LblLoading: Tlabel;
    LblTestDate: Tlabel;
    LblTestType: Tlabel;
    LblTestSite: Tlabel;
    LblTestConfirmed: Tlabel;
    LblTestConfirmedWatermark: Tlabel;
    GridLandscapePicure, DottedGrid: TPicture;
    OnLoad: TNotifyEvent;
    DragPosX, DragPosY: Integer;
    Dragging: Boolean;

    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
    Procedure Load();
    Procedure ResizeImages();
    Procedure Print(WithGrid: Boolean; UseDottedGrid: Boolean);
    Function GetVisiblePageNumber(): Integer;
    Procedure ShowPage(Page: Integer);
    Procedure AddUnconfirmedUnderlay(BaseMF: TMetaFile);
    Function GetName(): String;
    Function GetDate(): String;
    Procedure UpdateLabels();
    Procedure Scroll(Delta: Integer; Kind: TScrollBarKind);
  End;

  TEKGImage = Class(TImage)
  Private
  Public
    Grid: TImage;
    Overlay: TImage;
    Constructor Create(Owner: TComponent); Override;
    Destructor Destroy; Override;
    Procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); Override;
    Procedure ImageMouseDown(Sender: Tobject;
      Button: TMouseButton; Shift: TShiftState; x, y: Integer);
    Procedure ImageMouseUp(Sender: Tobject;
      Button: TMouseButton; Shift: TShiftState; x, y: Integer);
    Procedure ImageMouseMove(Sender: Tobject; Shift: TShiftState; x, y: Integer);
  End;

//  var
//    ThreadingLogFile: TextFile;

Implementation
Uses
  Dialogs,
  Printers,
  SysUtils,
  Windows
  ;

Function PaddedIntToStr(Num: Integer; StringLength: Integer): String;
{
  turn an 'n' digit number into an 'x' character string prepended
  with '0's as needed.
}
Var
  Temp: String;
Begin
  Temp := Inttostr(Num);
  While Length(Temp) < StringLength Do
    Temp := '0' + Temp;
  Result := Temp;
End;

Constructor TMuseTest.Create(AOwner: TComponent);
// initialize test data
Begin
  Inherited Create(AOwner);
  DoubleBuffered := True;
  Zoom := 50;
  Images := Tlist.Create();
  HorzScrollBar.Tracking := True;
  VertScrollBar.Tracking := True;
  LblTestDate := Tlabel.Create(Self);
  LblTestType := Tlabel.Create(Self);
  LblTestSite := Tlabel.Create(Self);
  LblTestConfirmed := Tlabel.Create(Self);
  LblTestConfirmedWatermark := Tlabel.Create(Self);
  LblLoading := Tlabel.Create(Self);
  LblLoading.caption := 'Loading...';
  LblLoading.Parent := Self;
  LblTestDate.Parent := Self;
  LblTestType.Parent := Self;
  LblTestSite.Parent := Self;
  LblTestConfirmed.Parent := Self;
  LblTestConfirmedWatermark.Parent := Self;
  LblTestDate.Visible := False;
  LblTestType.Visible := False;
  LblTestSite.Visible := False;
  LblTestConfirmed.Visible := False;
  LblTestConfirmedWatermark.Visible := False;
  LblTestDate.Transparent := True;
  LblTestType.Transparent := True;
  LblTestSite.Transparent := True;
  LblTestConfirmed.Transparent := True;
  LblTestConfirmedWatermark.Transparent := True;
  LblTestDate.Font.Color := clBlue;
  LblTestType.Font.Color := clBlue;
  LblTestSite.Font.Color := clBlue;
  LblTestConfirmed.Font.Color := clBlue;
  LblTestConfirmedWatermark.Font.Color := clRed;
  LblTestDate.Font.Style := [Fsbold];
  LblTestType.Font.Style := [Fsbold];
  LblTestSite.Font.Style := [Fsbold];
  LblTestConfirmed.Font.Style := [Fsbold];
  LblTestConfirmedWatermark.Font.Style := [Fsbold];
  LblTestConfirmedWatermark.Font.Name := 'Verdana';
  LblTestConfirmedWatermark.Font.Size := 36;
  LblTestConfirmedWatermark.alignment := TaCenter;
End;

Destructor TMuseTest.Destroy();
// clean up before destruction
Var
  Image: TEKGImage;
Begin
  While (Images.Count > 0) Do
  Begin
    Image := Images[0];
    Images.Remove(Image);
    Image.Free();
  End;
  Images.Free();
  Inherited Destroy();
End;

Procedure TMuseTest.Resize();
// override's parent's Resize event to make sure the internal contents get
// resized appropriately
Begin
  ResizeImages();
End;

Procedure TMuseTest.ResizeImages();
// loop through and resize all the images within
Var
  i, YOffset, IHeight, IWidth, PicHeight, PicWidth: Integer;
  InitialScollHorizontal, InitialScrollVertical: Integer;
  EKG: TEKGImage;
Begin
  If ((Loaded) And (Parent <> Nil)) Then
  Begin
    {
       Reset the scroll box to the top left corner.
       Otherwise it will start the drawing operation at
       top left corner of the visible section of the scrollbox
    }
    InitialScollHorizontal := HorzScrollBar.Position;
    InitialScrollVertical := VertScrollBar.Position;
    HorzScrollBar.Position := 0;
    VertScrollBar.Position := 0;
    // Now loop through the images and stack them on top of eachother
    YOffset := 0;
    IWidth := ((ClientWidth) * Zoom) Div 100;
    For i := 0 To (Images.Count - 1) Do
    Begin
      Try
        EKG := TEKGImage(Images[i]);
        // this calculation of iHeight is designed to preserve the aspect ratio
        // of the original image during the scaling.
        PicHeight := EKG.Picture.Graphic.Height;
        PicWidth := EKG.Picture.Graphic.Width;
        IHeight := MulDiv(IWidth, PicHeight, PicWidth);
        EKG.SetBounds(0, YOffset, IWidth, IHeight);
        EKG.Visible := True;
        EKG.Grid.Visible := GridOn;
        YOffset := YOffset + IHeight;
      Except
        Continue;
      End;
    End;
    // move the scroll box back to where it started
    HorzScrollBar.Position := InitialScollHorizontal;
    VertScrollBar.Position := InitialScrollVertical;
    UpdateLabels();
  End;
End;

Procedure TMuseTest.Load();
// load the test and it's images into memory and add them to the scroll box
Var
  EKG: TEKGImage;
  i: Integer;
  Filename: String;
Begin
  Try
    // pull the test from the MUSE server
    TestFileInfo := MuseConnection.GetTest(TestInfo, PatientID);
    // load each page into memory
    For i := 1 To TestFileInfo.Pages Do
    Begin
      EKG := TEKGImage.Create(Self);
      Filename := MuseConnection.ConstructFileName(TestInfo);
      Filename := MuseConnection.OutputFolder + Filename + '-'
        + Inttostr(i) + '.emf';
      EKG.Picture.LoadFromFile(Filename);
      // check for unconfirmed tests
      If (TestInfo.Status = 0) Or (TestInfo.Status = 128) Then
      Begin
      //  AddUnconfirmedUnderlay(EKG.Picture.MetaFile);
        LblTestConfirmed.caption := 'Unconfirmed';
        LblTestConfirmedWatermark.caption := 'Unconfirmed';
      End;
      EKG.Grid.Picture := Self.GridLandscapePicure;
      EKG.Grid.Parent := Self;
      EKG.Parent := Self;
      EKG.Overlay.Picture := EKG.Picture;
      Images.Add(EKG);
    End;
    LblLoading.Visible := False;
    RemoveComponent(LblLoading);
    LblTestType.caption := GetName();
    LblTestDate.caption := GetDate();
    LblTestSite.caption := MuseConnection.Site;
    Loaded := True;
  Except On e: Exception Do
    Begin
      Application.Processmessages();
      Showmessage(e.Message);
      Application.Processmessages();
    End;
  End;
End;

Procedure TMuseTest.UpdateLabels();
// move the labels to their correct positions
Begin
  LblTestConfirmed.Top := ClientHeight - 80;
  LblTestConfirmedWatermark.Top := (ClientHeight Div 4); //change this to center of metafile (above grid)
  LblTestType.Top := ClientHeight - 60;
  LblTestDate.Top := ClientHeight - 40;
  LblTestSite.Top := ClientHeight - 20;
  LblTestConfirmed.Left := 4;
  LblTestConfirmedWatermark.Left := ((ClientWidth Div 2) - 160);
  LblTestType.Left := 4;
  LblTestDate.Left := 4;
  LblTestSite.Left := 4;
  LblTestConfirmed.Visible := TextOverlayOn;
  LblTestConfirmedWatermark.Visible := True;
  LblTestType.Visible := TextOverlayOn;
  LblTestDate.Visible := TextOverlayOn;
  LblTestSite.Visible := TextOverlayOn;
  If (Parent <> Nil) Then
  Begin
    // this throws an exception when it isn't on a form, so make sure it is
    LblTestConfirmed.BringToFront();
    LblTestConfirmedWatermark.BringToFront();
    LblTestType.BringToFront();
    LblTestDate.BringToFront();
    LblTestSite.BringToFront();
  End;
End;

Procedure TMuseTest.Print(WithGrid: Boolean; UseDottedGrid: Boolean);
// loop through and print each page of a test
Var
  i: Integer;
Begin
  For i := 0 To Images.Count - 1 Do
  Begin
    If Printer.Aborted Then
      Break;
    If i > 0 Then
      Printer.Newpage();
    If (WithGrid) Then
    Begin
      If (UseDottedGrid) Then
        Printer.Canvas.StretchDraw(Rect(0, 0, Printer.PageWidth, Printer.PageHeight),
          DottedGrid.MetaFile)
      Else
        Printer.Canvas.StretchDraw(Rect(0, 0, Printer.PageWidth, Printer.PageHeight),
          GridLandscapePicure.MetaFile);
    End;
    Printer.Canvas.StretchDraw(Rect(0, 0, Printer.PageWidth, Printer.PageHeight),
      TImage(Images[i]).Picture.MetaFile);
  End;
End;

Function TMuseTest.GetVisiblePageNumber(): Integer;
// return the page number that is currently visible to the user
Var
  i: Integer;
Begin
  For i := 0 To Images.Count - 1 Do
  Begin
    // if this one is greater than 0, then the previous one is the one on the screen
    If (TEKGImage(Images[i]).Top > 0) Then
      Break;
  End;
  If (i = 0) Then
    i := 1;
  Result := i;
End;

Procedure TMuseTest.ShowPage(Page: Integer);
// scroll to the page specified
Begin
  VertScrollBar.Position := 0;
  VertScrollBar.Position := TEKGImage(Images[Page - 1]).Top;
End;

Procedure TMuseTest.AddUnconfirmedUnderlay(BaseMF: TMetaFile);
// add the word "UNCONFIRMED" in large print under the image
// to make sure the user knows this is not confirmed yet
Var
  TempMF: TMetaFile;
  MFCanvas: TCanvas;
Begin
  // store the existing mf in a temp location for now.
  TempMF := TMetaFile.Create();
  TempMF.Height := BaseMF.Height;
  TempMF.Width := BaseMF.Width;
  MFCanvas := TMetafileCanvas.Create(TempMF, 0);
  MFCanvas.Draw(0, 0, BaseMF);
  MFCanvas.Free();

  MFCanvas := TMetafileCanvas.Create(BaseMF, 0);
  MFCanvas.Font.Color := clFuchsia;
  MFCanvas.Font.Style := [Fsbold];
  MFCanvas.Font.Height := 2000;
  MFCanvas.Textout((TempMF.Width - MFCanvas.Textwidth('UNCONFIRMED')) Div 2, 3000, 'UNCONFIRMED');
  // put the original MF on top of the UNCONFIRMED text
  MFCanvas.Draw(0, 0, TempMF);
  MFCanvas.Free();
  TempMF.Free();
End;

Function TMuseTest.GetName(): String;
// return the name of the test as a string
Begin
  Case TestInfo.cseType Of
    1: Result := 'Resting';
    2: Result := 'PACE';
    3: Result := 'HIRES';
    4: Result := 'STRESS';
    5: Result := 'HOLTER';
    6: Result := 'CATH';
    7: Result := 'ECHO';
    8: Result := 'DEFIB';
    9: Result := 'DISCHARGE';
    10: Result := 'HISTORY';
    11: Result := 'EVR';
    12: Result := 'NUCLEAR';
    13: Result := 'STS';
    14: Result := 'EP';
    15: Result := 'CPM';
  Else
    Result := 'ALL TESTS';
  End; {case}
End;

Function TMuseTest.GetDate(): String;
// return the date of the test as a string in MM/DD/YYYY format
Begin
  Result := PaddedIntToStr(TestInfo.AcqDate.Month, 2)
    + '/' + PaddedIntToStr(TestInfo.AcqDate.Day, 2)
    + '/' + PaddedIntToStr(TestInfo.AcqDate.Year, 4)
    + ' ' + PaddedIntToStr(TestInfo.AcqTime.Hour, 2)
    + ':' + PaddedIntToStr(TestInfo.AcqTime.Minute, 2)
    + ':' + PaddedIntToStr(TestInfo.AcqTime.Second, 2)
End;

Procedure TMuseTest.WMHScroll(Var Message: TWMHScroll);
// override parent's scroll event to update the labels' positions
Begin
  Inherited;
  UpdateLabels();
End;

Procedure TMuseTest.WMVScroll(Var Message: TWMHScroll);
// override parent's scroll event to update the labels' positions
Begin
  Inherited;
  UpdateLabels();
End;

Procedure TMuseTest.Scroll(Delta: Integer; Kind: TScrollBarKind);
// allow other objects to force this scrollbox to scroll distance delta
// in a direction.  Kind controls vertical vs horizontal axis scrolling, and
// -/+ delta determines which direction to scroll upon the specified axis.
Begin
  If (Kind = SbHorizontal) Then
  Begin
    PreviousHorzPosition := HorzScrollBar.Position;
    HorzScrollBar.Position := HorzScrollBar.Position + Delta;
  End
  Else
  Begin
    PreviousVertPosition := VertScrollBar.Position;
    VertScrollBar.Position := VertScrollBar.Position + Delta;
  End;
  UpdateLabels();
End;

{ TEKGImage }

Constructor TEKGImage.Create(Owner: TComponent);
{ Initialize the image and it's asociated background grid }
Begin
  Inherited Create(Owner);
  Stretch := True;
  Visible := False;
  OnMouseDown := ImageMouseDown;
  OnMouseUp := ImageMouseUp;
  OnMouseMove := ImageMouseMove;
  Grid := TImage.Create(Self);
  Grid.Stretch := True;
  Grid.Visible := False;
  Overlay := TImage.Create(Self);
  Overlay.Stretch := True;
  Overlay.Visible := False;
End;

Destructor TEKGImage.Destroy();
// clean up before destruction
Begin
  If (Grid <> Nil) Then
    Grid.Parent.RemoveControl(Grid);
  Grid.Free();
  Overlay.Free();
  Parent := Nil;
  Inherited Destroy();
End;

Procedure TEKGImage.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
{
  Override this so that when the image's size/position changes,
  it's grid is also updated to match it.
}
Begin
  // override this so that when the image is moved/resized, the
  // grid is also moved/resized
  Inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  If Grid <> Nil Then
    Grid.SetBounds(ALeft, ATop, AWidth, AHeight);
//  if Overlay <> nil then
    // overlay needs to change the height/width without changing the left or
    // top.
    //Overlay.SetBounds(Overlay.Left, Overlay.Top, AWidth, AHeight);
End;

Procedure TEKGImage.ImageMouseDown(Sender: Tobject;
  Button: TMouseButton; Shift: TShiftState; x, y: Integer);
// begin dragging the image
Var
  Test: TMuseTest;
Begin
  Test := TMuseTest(Parent);
  Test.Dragging := True;
  Test.DragPosX := Mouse.CursorPos.x;
  Test.DragPosY := Mouse.CursorPos.y;
  Screen.Cursor := crHandPoint;
End;

Procedure TEKGImage.ImageMouseUp(Sender: Tobject;
  Button: TMouseButton; Shift: TShiftState; x, y: Integer);
// stop dragging the image
Var
  Test: TMuseTest;
Begin
  Test := TMuseTest(Parent);
  Test.Dragging := False;
  Screen.Cursor := crDefault;
End;

Procedure TEKGImage.ImageMouseMove(Sender: Tobject;
  Shift: TShiftState; x, y: Integer);
// dragging the images causes the parent scroll box to be dragged
Var
  Test: TMuseTest;
  DeltaX, DeltaY: Integer;
Begin
  Test := TMuseTest(Parent);
  If Test.Dragging Then
  Begin
    // calculate the position change
    DeltaX := Test.DragPosX - Mouse.CursorPos.x;
    DeltaY := Test.DragPosY - Mouse.CursorPos.y;
    Test.DragPosX := Mouse.CursorPos.x;
    Test.DragPosY := Mouse.CursorPos.y;
    // scroll the scrollbox
    Test.HorzScrollBar.Position := Test.HorzScrollBar.Position + DeltaX;
    Test.VertScrollBar.Position := Test.VertScrollBar.Position + DeltaY;
    // call eventhandlers if they've been set
    If (Assigned(Test.OnScrollHorz)) Then
    Begin
      Test.HorzDelta := DeltaX;
      Test.OnScrollHorz(Test);
    End;
    If (Assigned(Test.OnScrollVert)) Then
    Begin
      Test.VertDelta := DeltaY;
      Test.OnScrollVert(Test);
    End;
    Test.UpdateLabels();
  End;
End;

End.
