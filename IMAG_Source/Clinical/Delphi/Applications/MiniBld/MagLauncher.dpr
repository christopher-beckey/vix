Program MagLauncher;

Uses
  Forms,
  fMagLauncher In 'fMagLauncher.pas' {frmMagLauncher};

{$R *.RES}

Begin
  Application.Initialize;
  Application.CreateForm(TfrmMagLauncher, frmMagLauncher);
  frmMagLauncher.Launch();
  Application.Terminate();
End.
