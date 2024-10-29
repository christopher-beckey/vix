Unit FmagReasonSelect;

Interface

Uses
  Buttons,
  Classes,
  cMagDBBroker,
  Controls,
  Forms,
  Menus,
  Stdctrls ,
  magPositions
  ;

//Uses Vetted 20090929:Dialogs, Graphics, Variants, SysUtils, Messages, Windows, umagutils

Type
  TfrmReasonSelect = Class(TForm)
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    LbPrompt: Tlabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    ReasonSelectHelptopic1: TMenuItem;
    LstReason: TListBox;
    Procedure Exit1Click(Sender: Tobject);
    Procedure LstReasonClick(Sender: Tobject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  Private
    Procedure Loadreasons(Reaslist: TStrings);
    { Private declarations }
  Public
    FMagDBBroker: TMagDBBroker;
    Function Execute(Code: String; MagDBBroker: TMagDBBroker; Title, Prompt: String; Var Statmsg: String): String;
    { Public declarations }
  End;

Var
  FrmReasonSelect: TfrmReasonSelect;

Implementation
Uses
  Umagutils8
  ;

{$R *.dfm}

Procedure TfrmReasonSelect.Loadreasons(Reaslist: TStrings);
Var
  i: Integer;
Begin
  LstReason.Clear;
  For i := 0 To Reaslist.Count - 1 Do
  Begin
    LstReason.Items.Add(MagPiece(Reaslist[i], '^', 2));
  End;

End;

{**  function TfrmReasonSelect.Execute(code: string; MagDBBroker : TMagDBBroker; var statmsg: string ): string;  **}
{       This window born in patch 93.  It allows uses to Select a reason from the MAG REASONS file.
        Reasons are for Copy Print Delete and Status.

}

Function TfrmReasonSelect.Execute(Code: String; MagDBBroker: TMagDBBroker; Title, Prompt: String; Var Statmsg: String): String;
Var
  Rstat: Boolean;
  Rmsg: String;
  TmpList: TStrings;
Begin
  Try
  {     Get the list of reasons, if error, quit with msg}
    If Code = '' Then Code := 'CPDS';
    Result := '';
    Statmsg := 'Unknown Error';
    TmpList := Tstringlist.Create;
    MagDBBroker.RPMaggReasonList(Rstat, Statmsg, TmpList, Code);
  {     statmsg is set in the RPC call.}
    If Not Rstat Then Exit;
    TmpList.Delete(0);

    Application.CreateForm(TfrmReasonSelect, FrmReasonSelect);
    FrmReasonSelect.FMagDBBroker := MagDBBroker;
    FrmReasonSelect.caption := Title;
    FrmReasonSelect.LbPrompt.caption := Prompt;
    FrmReasonSelect.Loadreasons(TmpList);
    FrmReasonSelect.Showmodal;
//        result := frmReasonSelect.cboxreason.Items[frmReasonSelect.cboxreason.itemindex];

    Statmsg := '';
    If FrmReasonSelect.ModalResult = MrCancel Then
    Begin
      Result := '';
      Statmsg := 'Selection Canceled.';
    End
    Else { Here ModalResult was mrOK}
    Begin
      Result := FrmReasonSelect.LstReason.Items[FrmReasonSelect.LstReason.ItemIndex];
      If Result = '' Then Statmsg := 'Selection Canceled.';
    End;
    Free;
  Finally
    TmpList.Free;
  End;
End;

Procedure TfrmReasonSelect.Exit1Click(Sender: Tobject);
Begin
  ModalResult := MrCancel;
End;

procedure TfrmReasonSelect.FormCreate(Sender: TObject);
begin
 GetFormPosition(self as Tform);
end;

procedure TfrmReasonSelect.FormDestroy(Sender: TObject);
begin
  saveformposition(self as Tform);
end;

Procedure TfrmReasonSelect.LstReasonClick(Sender: Tobject);
Begin
  btnOK.Enabled := (LstReason.ItemIndex <> -1);
End;

End.
