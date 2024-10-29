Unit FmagGenOverlay;

Interface

Uses
  Buttons,
  Forms,
  Stdctrls,
  Controls,
  Classes
  ;

//Uses Vetted 20090929:Dialogs, Controls, Graphics, Classes, Variants, SysUtils, Messages, Windows,

Type
  TfrmGenOverlay = Class(TForm)
    btnHide: TButton;
    LbPatName: Tlabel;
    LbImageType: Tlabel;
    LbImageSpec: Tlabel;
    btnMove: TSpeedButton;
    LbImageProc: Tlabel;
    Procedure btnHideClick(Sender: Tobject);
    Procedure btnMoveClick(Sender: Tobject);
  Private

    { Private declarations }
  Public
    Procedure SetAllFields(VPatName, VImageType, VImageSpec, VImageProc: String);
    Procedure ClearAllFields;
     { Public declarations }
  End;

Var
  FrmGenOverlay: TfrmGenOverlay;

Implementation

{$R *.dfm}

Procedure TfrmGenOverlay.btnHideClick(Sender: Tobject);
Begin
  Close;
End;

Procedure TfrmGenOverlay.btnMoveClick(Sender: Tobject);
Begin
  If FrmGenOverlay.BorderStyle = bsNone Then
  Begin
    btnMove.caption := '[pin info position]';
    FrmGenOverlay.BorderStyle := bsSizeToolWin;
    FrmGenOverlay.Top := FrmGenOverlay.Top - (FrmGenOverlay.Height - FrmGenOverlay.ClientHeight);
  End
  Else
  Begin
    btnMove.caption := '[move info position]';
    FrmGenOverlay.Top := FrmGenOverlay.Top + (FrmGenOverlay.Height - FrmGenOverlay.ClientHeight);
    FrmGenOverlay.BorderStyle := bsNone;

  End;
End;

Procedure TfrmGenOverlay.ClearAllFields;
Begin
  LbPatName.caption := '';
  LbImageType.caption := '';
  LbImageSpec.caption := '';
  LbImageProc.caption := '';

End;

Procedure TfrmGenOverlay.SetAllFields(VPatName, VImageType, VImageSpec, VImageProc: String);
Begin
  LbPatName.caption := VPatName;
  LbImageType.caption := VImageType;
  LbImageSpec.caption := VImageSpec;
  LbImageProc.caption := VImageProc;
End;

End.
