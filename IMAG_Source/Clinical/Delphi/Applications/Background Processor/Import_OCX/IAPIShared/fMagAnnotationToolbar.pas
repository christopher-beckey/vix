Unit FMagAnnotationToolbar;

Interface

Uses
  ComCtrls,
  Controls,
  FmagAnnotation,
  Forms,
  ImgList,
  Classes,
  ToolWin
  ;

//Uses Vetted 20090929:ImgList, Buttons, StdCtrls, ToolWin, Dialogs, Graphics, Classes, Variants, SysUtils, Messages, Windows,

Type
  TMagAnnotationToolbar = Class(TForm)
    ImageList1: TImageList;
    ToolBar2: TToolBar;
    TbPointer: TToolButton;
    TbFreehandLine: TToolButton;
    TbFilledRectangle: TToolButton;
    TbStraightLine: TToolButton;
    TbHollowRectangle: TToolButton;
    TbFilledEllipse: TToolButton;
    TbHollowEllipse: TToolButton;
    TbTypedText: TToolButton;
    TbArrow: TToolButton;
    TbProtractor: TToolButton;
    TbRuler: TToolButton;
    TbPlus: TToolButton;
    TbMinus: TToolButton;
    Procedure FormCreate(Sender: Tobject);
    Procedure TbPointerClick(Sender: Tobject);
    Procedure TbFreehandLineClick(Sender: Tobject);
    Procedure TbFilledRectangleClick(Sender: Tobject);
    Procedure TbStraightLineClick(Sender: Tobject);
    Procedure TbHollowRectangleClick(Sender: Tobject);
    Procedure TbFilledEllipseClick(Sender: Tobject);
    Procedure TbHollowEllipseClick(Sender: Tobject);
    Procedure TbTypedTextClick(Sender: Tobject);
    Procedure TbArrowClick(Sender: Tobject);
    Procedure TbProtractorClick(Sender: Tobject);
    Procedure TbRulerClick(Sender: Tobject);
    Procedure TbPlusClick(Sender: Tobject);
    Procedure TbMinusClick(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
  Private
    FAnnotationComponent: TMagAnnotation;

    Procedure SetButtonsEnabled(Value: Boolean);
  Public
    Procedure Initialize(AnnotationComponent: TMagAnnotation; x, y: Integer);
    { Public declarations }
  End;

Var
  MagAnnotationToolbar: TMagAnnotationToolbar;

Implementation

{$R *.dfm}

Procedure TMagAnnotationToolbar.FormCreate(Sender: Tobject);
Begin
  Self.Height := 56;

  ToolBar2.Align := alClient;

End;

Procedure TMagAnnotationToolbar.Initialize(AnnotationComponent: TMagAnnotation; x, y: Integer);
Begin
  FAnnotationComponent := AnnotationComponent;
  If FAnnotationComponent = Nil Then
    SetButtonsEnabled(False)
  Else
  Begin
    SetButtonsEnabled(True);
    Formstyle := Fsstayontop;

    // I don't like how this works... doesn't show on top properly
    Self.Left := x;
    Self.Top := y;

  End;
End;

Procedure TMagAnnotationToolbar.SetButtonsEnabled(Value: Boolean);
Begin
  TbPointer.Enabled := Value;
  TbArrow.Enabled := Value;
  TbFilledRectangle.Enabled := Value;
  TbFilledEllipse.Enabled := Value;
  TbFreehandLine.Enabled := Value;
  TbHollowRectangle.Enabled := Value;
  TbHollowEllipse.Enabled := Value;
  TbMinus.Enabled := Value;
  TbPlus.Enabled := Value;
  TbProtractor.Enabled := Value;
  {//ruler// <- other changes in other routines. Search on //ruler//
         gek p72t13 Disable the Ruler.}
  TbRuler.Enabled := False; //Value;   //ruler// gek - I put in 'false' instead of 'value'

  TbStraightLine.Enabled := Value;
  TbTypedText.Enabled := Value;

End;

Procedure TMagAnnotationToolbar.TbPointerClick(Sender: Tobject);
Begin
  FAnnotationComponent.SetTool(MagAnnToolPointer);
End;

Procedure TMagAnnotationToolbar.TbFreehandLineClick(Sender: Tobject);
Begin
  FAnnotationComponent.SetTool(MagAnnToolFreehandLine);
End;

Procedure TMagAnnotationToolbar.TbFilledRectangleClick(Sender: Tobject);
Begin
  FAnnotationComponent.SetTool(MagAnnToolFilledRectangle);
End;

Procedure TMagAnnotationToolbar.TbStraightLineClick(Sender: Tobject);
Begin
  FAnnotationComponent.SetTool(MagAnnToolStraightLine);
End;

Procedure TMagAnnotationToolbar.TbHollowRectangleClick(Sender: Tobject);
Begin
  FAnnotationComponent.SetTool(MagAnnToolHollowRectangle);
End;

Procedure TMagAnnotationToolbar.TbFilledEllipseClick(Sender: Tobject);
Begin
  FAnnotationComponent.SetTool(MagAnnToolFilledEllipse);
End;

Procedure TMagAnnotationToolbar.TbHollowEllipseClick(Sender: Tobject);
Begin
  FAnnotationComponent.SetTool(MagAnnToolHollowEllipse);
End;

Procedure TMagAnnotationToolbar.TbTypedTextClick(Sender: Tobject);
Begin
  FAnnotationComponent.SetTool(MagAnnToolTypedText);
End;

Procedure TMagAnnotationToolbar.TbArrowClick(Sender: Tobject);
Begin
  FAnnotationComponent.SetTool(MagAnnToolArrow);
End;

Procedure TMagAnnotationToolbar.TbProtractorClick(Sender: Tobject);
Begin
  FAnnotationComponent.SetTool(MagAnnToolProtractor);
End;

Procedure TMagAnnotationToolbar.TbRulerClick(Sender: Tobject);
Begin
  FAnnotationComponent.SetTool(MagAnnToolRuler);
End;

Procedure TMagAnnotationToolbar.TbPlusClick(Sender: Tobject);
Begin
  FAnnotationComponent.SetTool(MagAnnToolPlus);
End;

Procedure TMagAnnotationToolbar.TbMinusClick(Sender: Tobject);
Begin
  FAnnotationComponent.SetTool(MagAnnToolMinus);
End;

Procedure TMagAnnotationToolbar.FormClose(Sender: Tobject;
  Var action: TCloseAction);
Begin
  FAnnotationComponent.Enabled := False;
End;

End.
