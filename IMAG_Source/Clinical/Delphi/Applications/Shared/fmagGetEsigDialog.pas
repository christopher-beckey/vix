Unit FmagGetEsigDialog;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:  12/2004
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   [==    unit fmagGetEsigDialog;
   Description: frmGetEsigDialog is a Utility form used by
   Print and Copy functions to get the text of the User's Electronic Signature
   The text is then verified (outside of this form).
   ==]
   Note:
   }
(*
        ;; +---------------------------------------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +---------------------------------------------------------------------------------------------------+

*)

Interface

Uses
  Buttons,
  Classes,
  Controls,
  Forms,
  Stdctrls
  ;

//Uses Vetted 20090929:ExtCtrls, Dialogs, Graphics, SysUtils, Messages, Windows,

Type
  TfrmGetEsigDialog = Class(TForm)
    EdtEsig: TEdit;
    Label1: Tlabel;
    OKBtn: TBitBtn;
    btnCancel: TBitBtn;
    Lbesigdesc: Tlabel;
    Procedure EdtEsigKeyUp(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
  Private
    { Private declarations }
  Public
    Function Execute(Var Esig: String): Boolean; { Public declarations }
  End;

Var
  FrmGetEsigDialog: TfrmGetEsigDialog;

Implementation

{$R *.DFM}

Procedure TfrmGetEsigDialog.EdtEsigKeyUp(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If (Not OKBtn.Enabled) And (Length(EdtEsig.Text) > 0) Then OKBtn.Enabled := True;
End;

Function TfrmGetEsigDialog.Execute(Var Esig: String): Boolean;
Begin
  Application.CreateForm(TfrmGetEsigDialog, FrmGetEsigDialog);
  FrmGetEsigDialog.Showmodal;
  Result := (FrmGetEsigDialog.ModalResult = MrOK);
  If Result Then Esig := FrmGetEsigDialog.EdtEsig.Text;
  FrmGetEsigDialog.Release;
End;

End.
