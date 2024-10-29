Unit FMagLog;

Interface

Uses
  //cMagLogManager, {JK 10/5/2009 - Maggmsgu refactoring - deprecated unit}
  Maggmsgu,
  Controls,
  Dialogs,
  ExtCtrls,
  Forms,
  Stdctrls,
  Classes
  ;

//Uses Vetted 20090929:Graphics, Classes, Variants, Messages, Windows, SysUtils

Type

  TfrmLog = Class(TForm)
    MemLog: TMemo;
    PnlTop: Tpanel;
    btnClear: TButton;
    btnSave: TButton;
    SaveDialog1: TSaveDialog;
    chkWordWrap: TCheckBox;
    Procedure FormCreate(Sender: Tobject);
    Procedure btnClearClick(Sender: Tobject);
    Procedure btnSaveClick(Sender: Tobject);
    Procedure chkWordWrapClick(Sender: Tobject);
  Private
    { Private declarations }
  Public
    Procedure LogMsg(Sender: Tobject; MsgType: String; Msg: String; Priority: TMagLogPriority = MagLogINFO);
  End;

Var
  FrmLog: TfrmLog;

Implementation

Uses
  SysUtils
  ;

{$R *.dfm}

Procedure TfrmLog.FormCreate(Sender: Tobject);
Begin
  MemLog.Lines.Clear();
  MemLog.Align := alClient;
  btnClear.Align := alright;
  btnSave.Align := alright;
  chkWordWrap.Align := alright;
End;

Procedure TfrmLog.LogMsg(Sender: Tobject; MsgType: String; Msg: String; Priority: TMagLogPriority = MagLogINFO);
Var
  m: String;
Begin
  m := Formatdatetime('hh:mm:ss', Now);
  If Sender <> Nil Then
    m := m + ' [' + Sender.ClassName + ']';
  m := m + '(' + MsgType + ',' + MagLogger.GetLogEventPriorityString(Priority) + ') - ' + Msg;
  MemLog.Lines.Add(m);

End;

Procedure TfrmLog.btnClearClick(Sender: Tobject);
Begin
  MemLog.Lines.Clear();
End;

Procedure TfrmLog.btnSaveClick(Sender: Tobject);
Begin
  SaveDialog1.DefaultExt := 'txt';
  If SaveDialog1.Execute() Then
  Begin
    MemLog.Lines.SaveToFile(SaveDialog1.Filename);
  End;
End;

Procedure TfrmLog.chkWordWrapClick(Sender: Tobject);
Begin
  MemLog.Wordwrap := chkWordWrap.Checked;
  If MemLog.Wordwrap Then
    MemLog.ScrollBars := SsVertical
  Else
    MemLog.ScrollBars := SsBoth;
End;

End.
