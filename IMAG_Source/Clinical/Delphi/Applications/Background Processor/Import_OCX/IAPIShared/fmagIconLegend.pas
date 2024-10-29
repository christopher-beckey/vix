Unit FmagIconLegend;

Interface

Uses
  Buttons,
  Classes,
  ExtCtrls,
  Forms,
  Menus,
  ValEdit,
  Stdctrls,
  Controls,
  Grids
  ;

//Uses Vetted 20090929:Grids, ComCtrls, StdCtrls, Dialogs, Controls, Graphics, Variants, SysUtils, Messages, Windows, umagutils

Type
  TfrmIconLegend = Class(TForm)
    ValueListEditor1: TValueListEditor;
    Panel1: Tpanel;
    Panel2: Tpanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    SwitchtoActiveWindow1: TMenuItem;
    GotoMainWindow1: TMenuItem;
    Procedure BitBtn1Click(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure BitBtn2Click(Sender: Tobject);
    Procedure SwitchtoActiveWindow1Click(Sender: Tobject);
    Procedure GoToMainWindow1Click(Sender: Tobject);
  Private
    { Private declarations }
  Public
    Procedure Execute;
  End;

Var
  FrmIconLegend: TfrmIconLegend;

Implementation

Uses
  DmSingle,
 // fmagmain,
  //u magdisplaymgr,
  umagutils8A,
  Umagutils8
  ;

{$R *.dfm}

Procedure TfrmIconLegend.Execute;
Begin
  If Not Doesformexist('frmIconLegend') Then
    Application.CreateForm(TfrmIconLegend, FrmIconLegend);
  FrmIconLegend.Show;

End;

Procedure TfrmIconLegend.BitBtn1Click(Sender: Tobject);
Begin
  Close;
End;

Procedure TfrmIconLegend.FormClose(Sender: Tobject; Var action: TCloseAction);
Begin
  action := caFree;
End;

Procedure TfrmIconLegend.BitBtn2Click(Sender: Tobject);
Var
  t: TStrings;
  i: Integer;
Begin
  Try
    t := Tstringlist.Create;
    t := ValueListEditor1.Strings;
    For i := 0 To t.Count - 1 Do
    Begin
      If Copy(t[i], 1, 2) = ' =' Then
        t[i] := '                    ' + Copy(t[i], 3, 99);
    End;
    Dmod.MagUtilsDB1.ImageTextFilePrint(Nil, t, 'VI Display ShortCut Keys');
  Finally
  //t.free;  Causing AccessViolations ?
  End;
End;

Procedure TfrmIconLegend.SwitchtoActiveWindow1Click(Sender: Tobject);
Begin
  SwitchToForm;
End;

Procedure TfrmIconLegend.GoToMainWindow1Click(Sender: Tobject);
Begin
  Application.MainForm.SetFocus;
// frmMain.focustomain;
End;

End.
