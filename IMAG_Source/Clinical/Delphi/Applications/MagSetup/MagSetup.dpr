program MagSetup;

uses
  Forms,
  fMagSetup in 'fMagSetup.pas' {frmMagSetup},
  dMagInstallServiceClient in 'dMagInstallServiceClient.pas',
  cRequestInstallThread in 'cRequestInstallThread.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMagSetup, frmMagSetup);
  Application.Run;
end.
