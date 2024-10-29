Unit MagProgress;

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
  Stdctrls,
  Gauges;

Type
  TMagProgressForm = Class(TForm)
    Gauge1: TGauge;
    Label1: Tlabel;
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  MagProgressForm: TMagProgressForm;

Implementation

{$R *.DFM}

End.
