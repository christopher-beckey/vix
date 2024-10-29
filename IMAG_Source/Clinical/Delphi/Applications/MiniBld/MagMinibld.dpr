Program MagMinibld;

uses
  Forms,
  fmagMinibld in 'fmagMinibld.PAS' {frmMiniBld},
  Magguini in '..\Shared\Magguini.pas';

{$R *.RES}

Begin
  Application.CreateForm(TfrmMiniBld, frmMiniBld);
  Application.Run;
End.
