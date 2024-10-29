Unit FmagPasswordDlg;

Interface

Uses
  Buttons,
  ExtCtrls,
  Forms,
  Stdctrls,
  Classes,
  Controls
  ;

//Uses Vetted 20090929:StdCtrls, Dialogs, Controls, Graphics, Classes, Variants, SysUtils, Messages, Windows,

Type
  TfrmPasswordDlg = Class(TForm)
    Edtpassword: TLabeledEdit;
    btnOK: TBitBtn;
  Private
    { Private declarations }
  Public
    Function Execute: String; { Public declarations }
  End;

Var
  FrmPasswordDlg: TfrmPasswordDlg;

Implementation

{$R *.dfm}

{ TfrmPasswordDlg }

Function TfrmPasswordDlg.Execute: String;
Begin
  Application.CreateForm(TfrmPasswordDlg, FrmPasswordDlg);
  With FrmPasswordDlg Do
  Begin
    Showmodal;
    Result := Edtpassword.Text;
    FrmPasswordDlg.Free;
  End;
End;

End.
