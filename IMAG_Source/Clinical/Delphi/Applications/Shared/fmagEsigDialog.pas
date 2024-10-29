Unit FmagEsigDialog;

Interface

Uses
  Buttons,
  cMagDBBroker,
  Controls,
  Forms,
  Stdctrls,
  UMagDefinitions,
  Classes
  ;

//Uses Vetted 20090929:ExtCtrls, Dialogs, Graphics, Classes, SysUtils, Messages, Windows, hash

Type
  TfrmEsigDialog = Class(TForm)
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    LbUserName: Tlabel;
    EdtEsig: TEdit;
    LbEsigLabel: Tlabel;
  Private
    { Private declarations }
  Public
  {type  TEsigFailReason = (magesfailCancel,magesfailInvalid);}
    Function Execute(Username: String; Var Esig: String; FDBBroker: TMagDBBroker; Var FailReason: TEsigFailReason): Boolean;

  End;

Var
  FrmEsigDialog: TfrmEsigDialog;

Implementation
Uses
  Hash
  ;

{$R *.DFM}

{ TfrmEsigDialog }

Function TfrmEsigDialog.Execute(Username: String; Var Esig: String; FDBBroker: TMagDBBroker; Var FailReason: TEsigFailReason): Boolean;
Var
  ct: Integer;
  Xmsg: String;
Begin
  Application.CreateForm(TfrmEsigDialog, FrmEsigDialog);
  Try
    Result := False;
    ct := 3;

    With FrmEsigDialog Do
    Begin
      LbUserName.caption := Username;
      While ct > 0 Do
      Begin
        EdtEsig.Text := '';
        Showmodal;
        If ModalResult = MrCancel Then
        Begin
          Esig := '';
          ct := 0;
          FailReason := MagesfailCancel;
        End
        Else
        Begin
          Esig := EdtEsig.Text;
          If Not FDBBroker.RPVerifyEsig(Esig, Xmsg) Then
          Begin
            ct := ct - 1;
            FailReason := MagesfailInvalid;
          End
          Else
          Begin
            Result := True;
            ct := 0;
          End;
        End;
      End;
    End;
    If Result Then Esig := Encrypt(Esig);
  Finally
    FrmEsigDialog.Free;
  End;
End;

(*
  function TmagUtilsDB.GetEsigDialog(var xmsg : string) : boolean;
var ct : integer;
   esig : string;
begin
result := false;
ct := 3;
while ct > 0 do
  begin
    if frmGetEsigDialog.execute(esig) then
      begin
          if not FDBBroker.RPVerifyEsig(esig, xmsg)
            then ct := ct-1
            else
            begin
              result := true;
              ct := 0;
            end;
      end
      else
      begin
       xmsg := 'Electronic Signature Canceled.';
       ct := 0;
      end;

  end;
end;

*)

End.
