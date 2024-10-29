Unit FmagActiveForms;

Interface

Uses
  Buttons,
  Classes,
  Controls,
  Forms,
  Stdctrls
  ;

//Uses Vetted 20090929:Dialogs, Graphics, Variants, SysUtils, Messages, Windows

Type
  TfrmActiveForms = Class(TForm)
    ListBox1: TListBox;
    BitBtn1: TBitBtn;
    Procedure FormCreate(Sender: Tobject);
    Procedure ListBox1MouseUp(Sender: Tobject; Button: TMouseButton;
      Shift: TShiftState; x, y: Integer);
    Procedure ListBox1KeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure FormDestroy(Sender: Tobject);
    Procedure ListBox1KeyUp(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
  Private
    Fformnames: TStrings;
    FocusToForm: TForm;
    Procedure SwitchFocus;
    { Private declarations }
  Public
    Procedure Execute; { Public declarations }
  End;

Var
  FrmActiveForms: TfrmActiveForms;

Implementation
Uses
  Windows
  ;

{$R *.dfm}

Procedure TfrmActiveForms.FormCreate(Sender: Tobject);
Var
  i: Integer;
Begin
  FocusToForm := Nil;
  Fformnames := Tstringlist.Create;
  With Application Do
  Begin
    For i := 0 To ComponentCount - 1 Do
    Begin
      If (Components[i] Is TForm) Then
      Begin
        If TForm(Components[i]).Visible Then
        Begin
          ListBox1.Items.Add(TForm(Components[i]).caption);
          Fformnames.Add(TForm(Components[i]).Name)
        End;
      End;
    End;
  End;
End;

Procedure TfrmActiveForms.Execute;
Begin
  Application.CreateForm(TfrmActiveForms, FrmActiveForms);
  With FrmActiveForms Do
  Begin
    Showmodal;

    If FocusToForm <> Nil Then FocusToForm.SetFocus;
    Free;
  End;
End;

Procedure TfrmActiveForms.ListBox1MouseUp(Sender: Tobject;
  Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Begin
  If ListBox1.ItemIndex > -1 Then SwitchFocus;
End;

Procedure TfrmActiveForms.SwitchFocus;
Var
  i: Integer;
  Frmcap: String;
  Frmname: String;
  aFrm: String;
Begin
  Frmcap := ListBox1.Items[ListBox1.ItemIndex];
  Frmname := Fformnames[ListBox1.ItemIndex];
  With Application Do
  Begin
    For i := 0 To ComponentCount - 1 Do
    Begin
      If (Components[i] Is TForm) Then
      Begin
        If TForm(Components[i]).Visible Then
          aFrm := TForm(Components[i]).Name;
        If aFrm = Frmname Then
        Begin
          FocusToForm := TForm(Components[i]);
          Break;
        End;
      End;
    End;
  End;
  If FocusToForm <> Nil Then ModalResult := MrOK;
End;

Procedure TfrmActiveForms.ListBox1KeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_Return Then
    If ListBox1.ItemIndex > -1 Then SwitchFocus;
End;

Procedure TfrmActiveForms.FormDestroy(Sender: Tobject);
Begin
  Fformnames.Free;
End;

Procedure TfrmActiveForms.ListBox1KeyUp(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If (Key > 64) And (Key < 91) Then
    If ListBox1.ItemIndex > -1 Then SwitchFocus;
End;

End.
