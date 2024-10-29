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
  // JMW 6/4/2013 P131 - change to use Screen.Forms to show forms not
  // created by application but created by other forms
  For i := Screen.FormCount - 1 Downto 0 Do
  Begin
    if screen.Forms[i].Visible then
    begin
      ListBox1.Items.Add(screen.Forms[i].caption);
      Fformnames.Add(screen.Forms[i].Name);
    end;
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

  for i := 0 to screen.FormCount - 1 do
  begin
    if screen.Forms[i].Visible then
    begin
      if screen.forms[i].Name = Frmname then
      begin
        FocusToForm := screen.Forms[i];
        break;
      end;
    end;
  end;
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
