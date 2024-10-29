Unit cEkgOverlay;

Interface

Uses
  Classes,
  cMuseTest,
  Controls,
  ExtCtrls,
  Forms
  ;

//Uses Vetted 20090929:Windows

Type
  TEKGOverlay = Class(TScrollBox)
  Private
    TestList: Tlist;
    DragImage: TImage;
    DragPosX, DragPosY: Integer;
  Public
    Grid: TImage;
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy(); Override;
    Procedure Add(Test: TMuseTest);
    Procedure Remove(Test: TMuseTest);
    Procedure Clear();
    Procedure AddImages(Test: TMuseTest);
    Procedure ResizeGrid(Zoom: Integer);
    Procedure ImageMouseDown(Sender: Tobject; Button: TMouseButton;
      Shift: TShiftState; x, y: Integer);
    Procedure ImageMouseUp(Sender: Tobject; Button: TMouseButton;
      Shift: TShiftState; x, y: Integer);
    Procedure ImageMouseMove(Sender: Tobject; Shift: TShiftState; x, y: Integer);
  End;

Implementation
Uses
  Windows
  ;

Constructor TEKGOverlay.Create(AOwner: TComponent);
Begin
  Inherited Create(AOwner);
  TestList := Tlist.Create();
  HorzScrollBar.Tracking := True;
  VertScrollBar.Tracking := True;
  Grid := TImage.Create(Self);
  Grid.Stretch := True;
  Grid.Parent := Self;
  Grid.Visible := False;
End;

Destructor TEKGOverlay.Destroy();
Begin
  While (ControlCount > 0) Do
    RemoveControl(Controls[0]);
  If (Grid <> Nil) Then
    Grid.Parent := Nil;
  Grid.Free();
  DragImage := Nil;
  TestList.Clear();
  TestList.Free();
  Inherited Destroy();
End;

Procedure TEKGOverlay.Add(Test: TMuseTest);
Begin
  TestList.Add(Test);
  AddImages(Test);
End;

Procedure TEKGOverlay.Remove(Test: TMuseTest);
Var
  i: Integer;
Begin
  For i := 0 To Test.Images.Count - 1 Do
  Begin
    If (TEKGImage(Test.Images[i]).Overlay.Parent <> Nil) Then
      RemoveControl(TEKGImage(Test.Images[i]).Overlay);
  End;
  TestList.Remove(Test);
End;

Procedure TEKGOverlay.Clear();
Begin
  TestList.Clear();
End;

Procedure TEKGOverlay.AddImages(Test: TMuseTest);
Var
  i: Integer;
  Image: TEKGImage;
Begin
  For i := 0 To Test.Images.Count - 1 Do
  Begin
    Image := TEKGImage(Test.Images[i]);
    Image.Overlay.Parent := Self;
    Image.Overlay.OnMouseDown := ImageMouseDown;
    Image.Overlay.OnMouseUp := ImageMouseUp;
    Image.Overlay.OnMouseMove := ImageMouseMove;
    Image.Overlay.Visible := True;
//    grid.SetBounds(image.Width, image.Height, 0, 0);
  End;
End;

Procedure TEKGOverlay.ResizeGrid(Zoom: Integer);
Var
  IWidth, IHeight: Integer;
Begin
  IWidth := ((Width - 30) * Zoom) Div 100;
  // this calculation of iHeight is designed to preserve the aspect ratio
  // of the original image during the scaling.
  IHeight := MulDiv(IWidth, Grid.Picture.Graphic.Height, Grid.Picture.Graphic.Width);
  Grid.SetBounds(0, 0, IWidth, IHeight);
End;

Procedure TEKGOverlay.ImageMouseDown(Sender: Tobject;
  Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Begin
  DragImage := TImage(Sender);
  DragPosX := Mouse.CursorPos.x;
  DragPosY := Mouse.CursorPos.y;
  DragImage.BringToFront();
End;

Procedure TEKGOverlay.ImageMouseUp(Sender: Tobject;
  Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Begin
  DragImage := Nil;
End;

Procedure TEKGOverlay.ImageMouseMove(Sender: Tobject;
  Shift: TShiftState; x, y: Integer);
Var
  NewLeft, NewTop: Integer;
Begin
  If DragImage <> Nil Then
  Begin
    {
        Don't use the XY passed in because you will get into some wackky looping.
        When you move the image under the cursor it causes the image to throw
        another mousemove event with new XY coordinated based on the new position
        of the image relative to the current mouse position.  This causes a very
        jittery movement, although it does get the job done.  To avoid this jittery
        movement, just use the XY position of the main mouse object to calculate
        differentials and move the image appropriately.  This method does not
        prevent the mousemove event from getting thrown again with wierd xy values
        but it does give us smooth dragging.
    }
    NewLeft := DragImage.Left + Mouse.CursorPos.x - DragPosX;
    NewTop := DragImage.Top + Mouse.CursorPos.y - DragPosY;
    DragPosX := Mouse.CursorPos.x;
    DragPosY := Mouse.CursorPos.y;
    DragImage.SetBounds(NewLeft, NewTop, DragImage.Width, DragImage.Height);
  End;
End;

End.
