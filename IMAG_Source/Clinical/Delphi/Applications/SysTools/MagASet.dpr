Program MagASet;

Uses
  Forms,
  fMagASet In 'fMagASet.pas' {frmMagASet};

{$R *.RES}

Begin
  Application.Initialize;
  Application.CreateForm(TfrmMagASet, frmMagASet);
  If (ParamCount = 0) Then
    Application.Run
  Else
    frmMagASet.SetUpdateDirectory();
End.
