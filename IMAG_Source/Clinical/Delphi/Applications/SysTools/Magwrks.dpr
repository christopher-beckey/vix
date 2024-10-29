Program Magwrks;

Uses
  Forms,
  Magguini In '..\Shared\Magguini.pas',
  FMagAbout In '..\Shared\fMagAbout.pas' {frmAbout},
  Magwkcnf In '..\Shared\MAGWKCNF.PAS' {MagWrksf},
  MagWrksMemou In '..\Shared\MagWrksmemou.pas' {MagWrksMemo},
  cMagListViewLite In '..\Shared\cMagListViewLite.pas',
  Umagutils8 In '..\Shared\umagutils8.pas';

{$R *.RES}

Begin
  Application.Title := 'Imaging Configuration';
  Application.HelpFile := 'magwrks.hlp';
  Application.CreateForm(TMagWrksf, MagWrksf);
  Application.CreateForm(TMagWrksmemo, MagWrksmemo);
  Application.CreateForm(TfrmAbout, FrmAbout);
  Application.Run;
End.
