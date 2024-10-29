program Mag_MakeAbs;

uses
  Forms,
  fmagMagMakeAbs in 'fmagMagMakeAbs.pas' {frmMakeAbs},
  umagAbsUtil in 'umagAbsUtil.pas',
  fmagMakeAbsUtil in 'fmagMakeAbsUtil.pas' {frmMakeAbsUtil};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

 //   application.ShowMainForm := false;

  Application.Title := 'Imaging Thumbnail messenger';
  Application.CreateForm(TfrmMakeAbs, frmMakeAbs);
  Application.CreateForm(TfrmMakeAbsUtil, frmMakeAbsUtil);
  Application.Run;
end.
