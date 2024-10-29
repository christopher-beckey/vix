Program Magsys;

Uses
  Forms,
  Magsysu In 'MAGSYSU.PAS' {Magsysf},
  MagWrksListView In 'MagWrksListView.pas' {MagWrksListForm},
  MagSessionInfo In 'MagSessionInfo.pas' {MagSessionInfoform},
  MagProgress In 'MagProgress.pas' {MagProgressForm},
  magsysbrokercall In 'magsysbrokercall.pas',
  Umagutils8 In '..\Shared\uMagUtils8.pas';

{$R *.RES}

Begin
  Application.HelpFile := 'MAGSYS.HLP';
  Application.Title := 'Site Manager Tools';
  Application.CreateForm(TMagsysf, Magsysf);
  Application.CreateForm(TMagWrksListForm, MagWrksListForm);
  Application.CreateForm(TMagSessionInfoform, MagSessionInfoform);
  Application.CreateForm(TMagProgressForm, MagProgressForm);
  Application.Run;
End.
