Unit FmagCapBatchImageDesc;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging Description dialog, displayed for successive images in
      a batch.
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
   ;; a medical device.  As such, it may not be changed
   ;; in any way.  Modifications to this software may result in an
   ;; adulterated medical device under 21CFR820, the use of which
   ;; is considered to be a violation of US Federal Statutes.
   ;; +---------------------------------------------------------------------------------------------------+
*)

Interface

Uses
  Buttons,
  Forms,
  Stdctrls,
  Controls,
  Classes
  ;

//Uses Vetted 20090929:Dialogs, Graphics, Classes, SysUtils, Messages, Windows, umagutils, magpositions, Controls

Type
  TfrmCapBatchImageDesc = Class(TForm)
    BatchImageDesc: TEdit;
    Label1: Tlabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Procedure FormCreate(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
  Private
    { Private declarations }
  Public
    Function Execute(Wtop, Wleft: Integer; Var InText: String; Vdestroy: Boolean = True): Boolean;
  End;

Var
  FrmCapBatchImageDesc: TfrmCapBatchImageDesc;

Implementation
Uses
  Magpositions,
  Umagutils8
  ;

Function TfrmCapBatchImageDesc.Execute(Wtop, Wleft: Integer; Var InText: String; Vdestroy: Boolean = True): Boolean;
Begin
  If Not Doesformexist('frmCapBatchImageDesc') Then FrmCapBatchImageDesc := TfrmCapBatchImageDesc.Create(Application.MainForm);
  Try
    With FrmCapBatchImageDesc Do
    Begin
      If Wleft > 0 Then Left := Wleft;
      If Wtop > 0 Then Top := Wtop;

      BatchImageDesc.Text := InText;
      BatchImageDesc.Update;
      FrmCapBatchImageDesc.Showmodal;

      If FrmCapBatchImageDesc.ModalResult = MrOK Then
      Begin
        BatchImageDesc.Update;
        InText := BatchImageDesc.Text;
        Result := True;
      End
      Else
        Result := False;
    End;
  Finally
    If Vdestroy Then FrmCapBatchImageDesc.Free;
  End;
End;

{$R *.DFM}

Procedure TfrmCapBatchImageDesc.FormCreate(Sender: Tobject);
Begin
  GetFormPosition(Self As TForm);
End;

Procedure TfrmCapBatchImageDesc.FormDestroy(Sender: Tobject);
Begin
  SaveFormPosition(Self As TForm);
End;

End.
