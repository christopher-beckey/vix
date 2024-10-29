Unit fMagLauncher;

Interface

Uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Fmxutils,
  Stdctrls;

Type
  TfrmMagLauncher = Class(TForm)

  Private
    { Private declarations }
  Public
    Procedure Launch();
  End;

Var
  frmMagLauncher: TfrmMagLauncher;

Implementation

{$R *.DFM}

Procedure TfrmMagLauncher.Launch();
Var
  Executable, CommandLine: String;
  i: Integer;
Begin
  CommandLine := '';
  Executable := ParamStr(1);
  For i := 2 To ParamCount() Do
    CommandLine := CommandLine + ' "' + ParamStr(i) + '"';
  EXECUTEfile(Executable, CommandLine, '', SW_SHOW);
  Application.Terminate();
End;

End.
