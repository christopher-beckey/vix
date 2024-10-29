Unit MagBatchImageDesc;
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
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Stdctrls,
  Buttons;

Type
  TMagBatchImageDescform = Class(TForm)
    BatchImageDesc: TEdit;
    Label1: Tlabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;
Function GetBatchImageText(Wtop, Wleft: Integer; Var InText: String): Boolean;
Var
  MagBatchImageDescform: TMagBatchImageDescform;

Implementation

Function GetBatchImageText(Wtop, Wleft: Integer; Var InText: String): Boolean;
Begin
  MagBatchImageDescform := TMagBatchImageDescform.Create(Application.MainForm);
  Try
    With MagBatchImageDescform Do
    Begin
      Left := Wleft;
      Top := Wtop;

      BatchImageDesc.Text := InText;
      BatchImageDesc.Update;
      MagBatchImageDescform.Showmodal;

      If MagBatchImageDescform.ModalResult = MrOK Then
      Begin
        BatchImageDesc.Update;
        InText := BatchImageDesc.Text;
        Result := True;
      End
      Else
        Result := False;
    End;
  Finally
    MagBatchImageDescform.Free;
  End;
End;

{$R *.DFM}

End.
