Unit FMagDicomTxtfile;

Interface

Uses
  Buttons,
  Forms,
  Stdctrls,
  Classes,
  Controls
  ;

//Uses Vetted 20090929:Dialogs, Controls, Graphics, Classes, Variants, Messages, Windows, SysUtils

Type
  TfrmDicomTxtfile = Class(TForm)
    TxtHeader: TMemo;
    btnClose: TBitBtn;
    Procedure btnCloseClick(Sender: Tobject);
  Private
    { Private declarations }
  Public
    Procedure LoadTxtFile(Filename: String);
    { Public declarations }
  End;

Var
  FrmDicomTxtfile: TfrmDicomTxtfile;

Implementation
Uses
  SysUtils
  ;

{$R *.dfm}

Procedure TfrmDicomTxtfile.LoadTxtFile(Filename: String);
Begin
//  self.Caption := 'DCM Viewer Text Info - ' + Filename;
  Self.caption := 'DCM Viewer Text Info - ' + ExtractFileName(Filename);
  If FileExists(Filename) Then
  Begin
    TxtHeader.Lines.LoadFromFile(Filename);
  End
  Else
  Begin
    TxtHeader.Lines.Clear();
    TxtHeader.Lines.Add('File [' + Filename + '] does not exist');
  End;
  Self.Show();
End;

Procedure TfrmDicomTxtfile.btnCloseClick(Sender: Tobject);
Begin
  Self.Close();
End;

End.
